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

import 'dart:io';

import 'package:example/components_docs/catalog.dart';
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
