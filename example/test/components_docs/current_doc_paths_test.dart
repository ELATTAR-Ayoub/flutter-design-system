/// Guards that make wrong current documentation impossible to merge.
///
/// Three separate things drifted at once when the package moved its sources:
/// every `ComponentDocEntry.sourcePath` pointed at a file that no longer
/// existed, 452 lines of website copy still printed `lib/src/components/…`
/// without the `ui/` segment, and retired API spellings such as `NavUser`
/// survived in rendered prose. None of that is caught by a widget test: a
/// page renders a wrong path exactly as happily as a right one. These tests
/// read the repository instead.
///
/// Two exclusions, both deliberate and both narrow:
///
///   * `example/lib/nav.dart` is a character-for-character port of the
///     reference's own `lib/space/nav.ts`, asserted verbatim by
///     `nav_test.dart`'s "copy is verbatim" group. Its `NavUser` is the
///     reference's string, not this package's API.
///   * `docs/superpowers/**` is not scanned at all. Those are dated records
///     of what was true when they were written; editing one to quiet a
///     search would falsify it.
library;

import 'dart:convert';
import 'dart:io';

import 'package:example/components_docs/catalog.dart';
import 'package:example/site/site_routes.dart';
import 'package:flutter_test/flutter_test.dart';

/// The repository root, found by walking up from the test's working
/// directory — `flutter test` runs example tests from `example/`, and every
/// path a doc entry states is repository-root relative.
Directory _repositoryRoot() {
  Directory directory = Directory.current;
  for (int i = 0; i < 6; i++) {
    if (File('${directory.path}/pubspec.yaml').existsSync() &&
        File(
          '${directory.path}/pubspec.yaml',
        ).readAsStringSync().contains('name: elattar_design_system')) {
      return directory;
    }
    directory = directory.parent;
  }
  fail('could not find the repository root from ${Directory.current.path}');
}

/// Every current website source: the example app's own library and tests.
List<File> _currentWebsiteSources(Directory root) {
  return <File>[
    for (final String relative in <String>['example/lib', 'example/test'])
      ...Directory(
        '${root.path}/$relative',
      ).listSync(recursive: true).whereType<File>(),
  ].where((File file) {
    if (!file.path.endsWith('.dart')) return false;
    // This file names every retired spelling it forbids, and prints the
    // pre-move path it rejects. Scanning itself would fail on its own
    // vocabulary.
    return !_posix(
      file.path,
    ).endsWith('example/test/components_docs/current_doc_paths_test.dart');
  }).toList();
}

String _posix(String path) => path.replaceAll(r'\', '/');

/// A literal newline, kept out of the reason strings this file builds.
const String _newline = '\n';

void main() {
  final Directory root = _repositoryRoot();

  group('documentation source paths', () {
    test('every ComponentDocEntry.sourcePath resolves', () {
      final List<String> missing = <String>[
        for (final ComponentDocEntry entry in componentDocs)
          if (!File('${root.path}/${entry.sourcePath}').existsSync() &&
              !Directory('${root.path}/${entry.sourcePath}').existsSync())
            '${entry.name} → ${entry.sourcePath}',
      ];
      expect(
        missing,
        isEmpty,
        reason:
            'these entries state a source path that does not exist:\n'
            '${missing.join('\n')}',
      );
    });

    test('AgentConsole resolves to the block, not a UI component', () {
      expect(
        componentDoc('agent-console').sourcePath,
        'lib/src/blocks/agent_console/agent_console.dart',
      );
    });

    test('the foundation resolves to its design-system home', () {
      expect(
        componentDoc('source_foundation').sourcePath,
        'lib/src/design_system/foundation/',
      );
    });
  });

  group('registry manifests', () {
    /// Every hand-maintained manifest under `registry/`, decoded.
    ///
    /// The generated tree is not read: it is derived from these, so a wrong
    /// route there is a symptom and a wrong route here is the cause.
    List<MapEntry<String, Map<String, Object?>>> manifests() {
      final List<MapEntry<String, Map<String, Object?>>> out =
          <MapEntry<String, Map<String, Object?>>>[];
      for (final String directory in <String>[
        'components',
        'foundations',
        'blocks',
      ]) {
        final Directory dir = Directory('${root.path}/registry/$directory');
        if (!dir.existsSync()) continue;
        for (final File file in dir.listSync().whereType<File>()) {
          if (!file.path.endsWith('.json')) continue;
          out.add(
            MapEntry<String, Map<String, Object?>>(
              _posix(file.path),
              jsonDecode(file.readAsStringSync()) as Map<String, Object?>,
            ),
          );
        }
      }
      return out;
    }

    test('every documentationRoute resolves through siteRouteFor', () {
      // The field was typed by hand and hyphenated by habit, while the site
      // derives its routes from `ComponentDocEntry.name`, which is
      // inconsistent by history — `agent-console` and `ambient_pattern` are
      // both real. Thirty-four manifests pointed at a route nothing answers,
      // and one pointed into a `/blocks/` tree the site does not serve. A
      // consumer following a manifest's own link landed on the homepage.
      final List<String> offenders = <String>[];
      for (final MapEntry<String, Map<String, Object?>> entry in manifests()) {
        final Object? route = entry.value['documentationRoute'];
        expect(route, isA<String>(), reason: entry.key);
        if (siteRouteFor(route! as String) == null) {
          offenders.add('${entry.key} → $route');
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'these manifests link to a route no page answers:'
            '$_newline${offenders.join(_newline)}',
      );
    });

    test('every documentationRoute is the catalog entry it belongs to', () {
      // Resolving is necessary but not sufficient: a manifest could point at
      // some *other* real page. Pair each item with its catalog entry by the
      // one thing both spell the same once separators are normalised.
      String key(String name) => name.replaceAll('-', '_');
      final Map<String, ComponentDocEntry> byKey = <String, ComponentDocEntry>{
        for (final ComponentDocEntry entry in componentDocs)
          key(entry.name): entry,
      };
      final List<String> offenders = <String>[];
      for (final MapEntry<String, Map<String, Object?>> entry in manifests()) {
        final String name = entry.value['name']! as String;
        final ComponentDocEntry? doc = byKey[key(name)];
        if (doc == null) {
          offenders.add('${entry.key} → no catalog entry for $name');
          continue;
        }
        if (entry.value['documentationRoute'] != doc.route) {
          offenders.add(
            '${entry.key} → ${entry.value['documentationRoute']} '
            '(should be ${doc.route})',
          );
        }
      }
      expect(offenders, isEmpty, reason: offenders.join(_newline));
    });
  });

  group('current website copy', () {
    test('no source states lib/src/components/ without the ui segment', () {
      final List<String> offenders = <String>[];
      for (final File file in _currentWebsiteSources(root)) {
        final List<String> lines = file.readAsStringSync().split('\n');
        for (int i = 0; i < lines.length; i++) {
          final String line = lines[i];
          int at = line.indexOf('lib/src/components/');
          while (at >= 0) {
            final String rest = line.substring(
              at + 'lib/src/components/'.length,
            );
            if (!rest.startsWith('ui/')) {
              offenders.add('${_posix(file.path)}:${i + 1}');
              break;
            }
            at = line.indexOf('lib/src/components/', at + 1);
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'component sources live under lib/src/components/ui/; these '
            'lines still print the pre-move path:\n${offenders.join('\n')}',
      );
    });

    // `lib/shots/` is deliberately not listed: the two files that still
    // contain that string are a note about `example/lib/shots/`, a directory
    // of this app's own that was deleted, and a synthetic tree label in a
    // Semantics comment. Neither claims an install destination.
    test('no source states a retired foundation, effects or motion path', () {
      final List<String> offenders = <String>[];
      for (final File file in _currentWebsiteSources(root)) {
        final String text = file.readAsStringSync();
        for (final String retired in <String>[
          'lib/src/foundation/',
          'lib/src/effects/',
          'lib/src/motion/',
        ]) {
          if (text.contains(retired)) {
            offenders.add('${_posix(file.path)} → $retired');
          }
        }
      }
      expect(offenders, isEmpty, reason: offenders.join('\n'));
    });

    test('every authored /components/ link resolves to a real page', () {
      // The rail and the index build their links from the catalog, so they
      // cannot dangle. Hand-written ones can, and did: `/components/lift`,
      // `/components/starfield`, `/components/rule` and `/components/layout`
      // all survived the rename as prev/next links and See-also rows,
      // pointing at routes no page answers. `siteRouteFor` is the same
      // resolver `main.dart` dispatches through, so a link that fails here
      // is a link that lands a reader on the homepage.
      final RegExp link = RegExp(r"'(/components/[a-z0-9_-]*)'");
      final List<String> offenders = <String>[];
      for (final File file in _currentWebsiteSources(root)) {
        final List<String> lines = file.readAsStringSync().split('\n');
        for (int i = 0; i < lines.length; i++) {
          for (final RegExpMatch match in link.allMatches(lines[i])) {
            final String route = match.group(1)!;
            if (route == '/components/') continue;
            if (siteRouteFor(route) == null) {
              offenders.add('${_posix(file.path)}:${i + 1}  $route');
            }
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'these authored links resolve to nothing and drop the reader on '
            'the homepage:$_newline${offenders.join(_newline)}',
      );
    });

    test('no source cites a retired file, manifest or install destination', () {
      // Deliberately narrow: every entry is a full filename, manifest path,
      // logical target or install destination, never a bare word. `starfield`
      // on its own is still the name of a live FeedbackSurface parameter and
      // of the visual pattern itself, and `lift` is what a card does on
      // hover; neither may trip this.
      const List<String> retired = <String>[
        'starfield.dart',
        'lift.dart',
        'machine_surface.dart',
        'page_glow.dart',
        'sheen_action.dart',
        'foil_value.dart',
        'bloom_cosmic.dart',
        'voice_orb.dart',
        'sliding_pill.dart',
        'swap_in.dart',
        'nav_user.dart',
        'registry/components/starfield.json',
        'registry/components/lift.json',
        'registry/components/machine-surface.json',
        'registry/components/page-glow.json',
        'registry/components/sheen-action.json',
        'registry/components/foil-value.json',
        'registry/components/bloom-cosmic.json',
        'registry/components/voice-orb.json',
        'registry/components/sliding-pill.json',
        '@ui/starfield.dart',
        '@ui/lift.dart',
        'lib/effects/',
        'lib/motion/',
        'lib/shots/',
      ];
      final List<String> offenders = <String>[];
      for (final File file in _currentWebsiteSources(root)) {
        final String text = file.readAsStringSync();
        for (final String name in retired) {
          if (text.contains(name)) {
            offenders.add('${_posix(file.path)} → $name');
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'these name a file, manifest or install destination that does '
            'not exist:$_newline${offenders.join(_newline)}',
      );
    });

    test('every test path a page cites exists', () {
      // Total, not a blacklist. A "Tests" section that names a file nobody
      // wrote is a claim about coverage that no one can check: eleven of
      // these shipped, some renamed with their component
      // (`sliding_pill_test.dart`), some purely aspirational
      // (`example/test/sidebar_page_test.dart`). Both kinds read as evidence.
      final RegExp cited = RegExp(
        r"'((?:example/)?test/[a-z0-9_/]*[a-z0-9_]+_test\.dart)'",
      );
      final List<String> offenders = <String>[];
      for (final File file in _currentWebsiteSources(root)) {
        final List<String> lines = file.readAsStringSync().split('\n');
        for (int i = 0; i < lines.length; i++) {
          for (final RegExpMatch match in cited.allMatches(lines[i])) {
            final String path = match.group(1)!;
            if (!File('${root.path}/$path').existsSync()) {
              offenders.add('${_posix(file.path)}:${i + 1}  $path');
            }
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'these cite a test suite that does not exist:'
            '$_newline${offenders.join(_newline)}',
      );
    });

    test('no component page hand-types its own eyebrow', () {
      // The kicker is derived from the catalog family
      // (`componentDocEyebrow`). Ninety-nine pages used to type it, and
      // between them claimed eight taxonomies that matched neither the rail
      // nor each other — Chart introduced itself as "COMPONENTS / BASE"
      // while the rail filed it under Charts. A page that starts typing one
      // again is a page that can disagree with the group it is listed in.
      final List<String> offenders = <String>[
        for (final File file in Directory(
          '${root.path}/example/lib/components_docs',
        ).listSync(recursive: true).whereType<File>())
          if (file.path.endsWith('page.dart') &&
              file.readAsStringSync().contains('eyebrow:'))
            _posix(file.path),
      ];
      expect(offenders, isEmpty, reason: offenders.join(_newline));
    });

    test('no source carries a retired public API name', () {
      // `_SlidingPillGroupState` is included as a bare `SlidingPill`: the
      // page that quoted it was citing a private class that had already been
      // renamed, so the doc was wrong about the source it claimed to read.
      // Both spellings of each: the identifier a code sample would use, and
      // the spaced display title a doc entry, breadcrumb or cross-link
      // renders. The titles were the ones that actually survived — every
      // effects page still headed itself "Bloom Cosmic" or "Voice Orb" long
      // after the widgets became FeedbackSurface and VoiceIndicator.
      const List<String> retired = <String>[
        'NavUser',
        'SlidingPill',
        'Sliding Pill',
        'BloomCosmic',
        'Bloom Cosmic',
        'FoilValue',
        'Foil Value',
        'SheenAction',
        'Sheen Action',
        'MachineSurface',
        'Machine Surface',
        // Sentence case too: a section title or a sentence-initial name
        // renders this way, and no ordinary sentence does. Deliberately not
        // extended to 'Swap in', which is a normal imperative.
        'Machine surface',
        'Page glow',
        'Sheen action',
        'Foil value',
        'Bloom cosmic',
        'Voice orb',
        'Sliding pill',
        'PageGlow',
        'Page Glow',
        'VoiceOrb',
        'Voice Orb',
        'Swap In',
      ];
      final List<String> offenders = <String>[];
      for (final File file in _currentWebsiteSources(root)) {
        if (_posix(file.path).endsWith('example/lib/nav.dart')) continue;
        final String text = file.readAsStringSync();
        for (final String name in retired) {
          if (text.contains(name)) {
            offenders.add('${_posix(file.path)} → $name');
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'these are retired spellings; the shipped names are UserMenu, '
            'ActiveIndicator, FeedbackSurface, PremiumSurface, '
            'ActionFeedback, Surface, BackgroundEffect and '
            'VoiceIndicator:\n${offenders.join('\n')}',
      );
    });
  });
}
