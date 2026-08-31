/// The site may not tell a reader something untrue about the product.
///
/// Two failures this suite exists to make impossible, both of which shipped:
///
///  * Nineteen component pages told a reader that `elattar add <name>` would
///    not resolve, for components the registry had shipped for weeks. Several
///    contradicted themselves in one sentence — "ships in the registry, so
///    `elattar add carousel` is not available" — the residue of a partial
///    sweep when the registry grew to cover the whole component surface.
///  * Eleven install commands contained a raw ESC byte where the `e` of
///    `elattar` should be, so the site rendered `lattar add …`: a command
///    that does not exist, in the one string a reader is most likely to copy.
///
/// Neither is the kind of thing a human notices on the hundredth page.
library;

import 'dart:convert';
import 'dart:io';

import 'package:example/docs_pages/release_facts.dart';
import 'package:flutter_test/flutter_test.dart';

/// `flutter test` runs with `example/` as the working directory.
const String _repoRoot = '..';

List<File> _dartSources(String directory) => Directory(directory)
    .listSync(recursive: true)
    .whereType<File>()
    .where((File file) => file.path.endsWith('.dart'))
    .toList();

Set<String> _registryItemNames() {
  final File registry = File(
    '$_repoRoot/registry/generated/latest/registry.json',
  );
  final Map<String, Object?> document =
      jsonDecode(registry.readAsStringSync()) as Map<String, Object?>;
  return <String>{
    for (final Object? item in document['items']! as List<Object?>)
      (item! as Map<String, Object?>)['name']! as String,
  };
}

void main() {
  group('the source is clean text', () {
    test('no Dart source carries a control character', () {
      // Tab, newline and carriage return only. Anything else in a string
      // literal is invisible in an editor and renders as nothing on the site,
      // so it survives every review that is not looking for it specifically.
      final List<String> offenders = <String>[];
      for (final File file in <File>[
        ..._dartSources('lib'),
        ..._dartSources('test'),
      ]) {
        final String text = file.readAsStringSync();
        for (int i = 0; i < text.length; i++) {
          final int code = text.codeUnitAt(i);
          if (code < 32 && code != 9 && code != 10 && code != 13) {
            final int line = '\n'.allMatches(text.substring(0, i)).length + 1;
            offenders.add(
              '${file.path}:$line carries U+${code.toRadixString(16).padLeft(4, '0')}',
            );
          }
        }
      }
      expect(offenders, isEmpty);
    });

    test('no page prints the CLI name with a character missing', () {
      // The specific shape the ESC bytes left behind. Cheap, and it names the
      // failure directly rather than through a codepoint.
      // The negative lookbehind is load-bearing: every correct
      // `elattar add` contains `lattar add` as a substring, so a plain
      // `contains` check fails on every well-formed page in the site.
      final RegExp truncated = RegExp('(?<!e)lattar add');
      for (final File file in _dartSources('lib')) {
        expect(
          truncated.hasMatch(file.readAsStringSync()),
          isFalse,
          reason: '${file.path} prints "lattar add" instead of "elattar add"',
        );
      }
    });
  });

  group('what the site says you can install', () {
    late Set<String> shipped;

    setUpAll(() => shipped = _registryItemNames());

    test('the registry has items to check against', () {
      expect(shipped, isNotEmpty);
      expect(shipped, contains('button'));
    });

    test('every `elattar add <name>` names a real registry item', () {
      // A published command that 404s costs more than no command at all: a
      // plausible failure gets attributed to the reader's setup.
      // Only *copyable* commands are checked: the ones inside backticks, and
      // the ones a `value:` field renders as a copy button. Matching bare
      // prose would flag sentences like "elattar add appends the item to
      // your pubspec", where the next word is an English verb rather than an
      // item name — a false positive that would make the guard unusable and
      // therefore ignored.
      final RegExp copyable = RegExp(
        r"(?:`elattar add ([a-z][a-z0-9-]*)`)"
        r"|(?:'elattar add ([a-z][a-z0-9-]*)')",
      );
      final List<String> unknown = <String>[];
      for (final File file in _dartSources('lib')) {
        final String text = file.readAsStringSync();
        for (final RegExpMatch match in copyable.allMatches(text)) {
          final String name = match.group(1) ?? match.group(2)!;
          if (!shipped.contains(name)) {
            unknown.add('${file.path}: elattar add $name');
          }
        }
      }
      expect(
        unknown,
        isEmpty,
        reason: 'these commands name items the registry does not ship',
      );
    });

    test('no page claims a shipped item cannot be installed', () {
      const List<String> falseClaims = <String>[
        'not yet a registry item',
        'is not yet available',
        'is not available: install by copying',
        'will not resolve. It is one of the Wave',
        'still awaiting a manifest',
      ];
      final List<String> offenders = <String>[];
      for (final File file in _dartSources('lib')) {
        final String text = file.readAsStringSync();
        for (final String claim in falseClaims) {
          if (text.contains(claim)) {
            offenders.add('${file.path}: "$claim"');
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'the registry ships the full component surface; a page saying '
            'otherwise is telling a reader not to use a command that works',
      );
    });
  });

  group('what the site says about obtaining the product', () {
    test('no page describes the CLI or repository as unobtainable', () {
      // The gate for the public release: a reader must not be told the thing
      // they are reading about cannot be had. Each phrase below was live on
      // the site while the CLI was genuinely unpublished, and each one has to
      // stay gone once it is not.
      const List<String> stale = <String>[
        'the repository is private',
        'this repository is private',
        'repository itself is private',
        'not published for anyone',
        'no route for anyone else',
        'publish_to: none',
        'Not Published',
      ];
      final List<String> offenders = <String>[];
      for (final File file in _dartSources('lib')) {
        final String text = file.readAsStringSync();
        for (final String phrase in stale) {
          if (text.contains(phrase)) {
            offenders.add('${file.path}: "$phrase"');
          }
        }
      }
      expect(offenders, isEmpty);
    });

    test('no retired type prefix appears anywhere in the site', () {
      // Two renames have passed through this repository, and the site was
      // the slowest surface to follow each one. `Ds*` went first; `El*` went
      // second and was still in the introduction page, the skills catalog
      // and five home cards long after the code had stopped using it. Both
      // spellings are matched.
      //
      // Case-sensitive, and anchored on a capital or a `*` after the two
      // letters: `Elattar`, `ElevenLabs` and `Dashboard` are ordinary words
      // and must not be flagged, while `ElButton` and the prose `El*` must
      // be. Only `lib/` is scanned, so this file is not part of the corpus
      // whose vocabulary it forbids.
      final RegExp retired = RegExp(r'\b(?:Ds|El)[A-Z*]');
      final List<String> offenders = <String>[];
      for (final File file in _dartSources('lib')) {
        for (final RegExpMatch match in retired.allMatches(
          file.readAsStringSync(),
        )) {
          offenders.add('${file.path}: "${match.group(0)}"');
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'the public API carries no prefix. It is Button, Card, Icon, '
            'TextStyles, space, and a page that says otherwise names an API '
            'a reader cannot import',
      );
    });

    test('no page says the CLI is unpublished once it is published', () {
      // The site is deployed after the CLI is published, so a build that
      // still apologises for an unpublished package is describing the
      // previous release candidate. `release_facts.dart` holds the answer and
      // `release_facts_test.dart` holds that file to its owners; this is the
      // prose half.
      const List<String> stale = <String>[
        'not on pub.dev yet',
        'not yet on pub.dev',
        'is built and gated but not published',
        'does not resolve today',
        'until it publishes',
      ];
      final List<String> offenders = <String>[];
      for (final File file in _dartSources('lib')) {
        final String text = file.readAsStringSync();
        for (final String phrase in stale) {
          if (text.contains(phrase)) offenders.add('${file.path}: "$phrase"');
        }
      }

      if (releaseFacts.cliOnPubDev) {
        expect(
          offenders,
          isEmpty,
          reason:
              'releaseFacts.cliOnPubDev is true, so the package resolves and '
              'no page may tell a reader otherwise',
        );
      } else {
        // The mirror image, kept live rather than deleted: while the package
        // is unpublished a page must not render the command as a copyable
        // line, because the reader who copies it gets a resolution failure
        // with no way to tell it apart from a broken setup of their own. The
        // shape matched is a whole Dart string literal, a snippet's own
        // `code:` value, never a mention inside a sentence.
        final RegExp copyable = RegExp(r"'dart install elattar_cli(?:\\n)?'");
        final List<String> copied = <String>[
          for (final File file in _dartSources('lib'))
            if (copyable.hasMatch(file.readAsStringSync())) file.path,
        ];
        expect(
          copied,
          isEmpty,
          reason:
              'releaseFacts.cliOnPubDev is false: present the pub.dev '
              'spelling in prose, never as a command to copy',
        );
      }
    });
  });
}
