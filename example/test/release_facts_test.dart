/// `release_facts.dart` is a restatement, so something has to hold it to its
/// owners.
///
/// Four facts drive every install instruction on the site. Three of them have
/// an owner inside this repository: `identity.dart` for the version and the
/// registry URL, the generated registry for the version it declares, and the
/// CLI changelog for the version it documents. This suite checks each one by
/// reading that owner rather than by trusting the copy.
///
/// The fourth, whether the package is on pub.dev, has no owner in the tree at
/// all. What is checkable is that the pages agree with whichever answer the
/// file gives, which is the last group here and the prose half of it in
/// `public_claims_test.dart`.
///
/// Runs with cwd = `example/`, so repository files are read as `../…`.
library;

import 'dart:convert';
import 'dart:io';

import 'package:example/docs_pages/release_facts.dart';
import 'package:flutter_test/flutter_test.dart';

const String _identity = '../packages/elattar_cli/lib/src/identity.dart';

/// One `const String name = …;` value out of a Dart source file.
///
/// A text read, deliberately: `example/` does not depend on the CLI package
/// and should not start to for a guard. The assertion that the parse found
/// something real is the first test below.
///
/// Two shapes, because `identity.dart` uses both: a plain literal for the
/// version, and `String.fromEnvironment(..., defaultValue: '…')` for the
/// origin, whose default is what a released CLI compiles with when nothing
/// passes a `--define`.
String _constant(String source, String name) {
  final RegExpMatch? literal = RegExp(
    "const String $name =\\s*'([^']*)'",
  ).firstMatch(source);
  if (literal != null) return literal.group(1)!;

  final RegExpMatch? fromEnvironment = RegExp(
    "const String $name = String.fromEnvironment\\([^)]*"
    "defaultValue:\\s*'([^']*)'",
    dotAll: true,
  ).firstMatch(source);
  expect(
    fromEnvironment,
    isNotNull,
    reason: 'no `const String $name` in $_identity, literal or environment',
  );
  return fromEnvironment!.group(1)!;
}

void main() {
  late String identity;

  setUpAll(() {
    identity = File(_identity).readAsStringSync();
    expect(identity, isNotEmpty);
  });

  group('the facts match their owners', () {
    test('the parse recovers real values, not empty strings', () {
      // Without this every check below can pass against two empty strings,
      // which is how a guard stops guarding without ever going red.
      expect(_constant(identity, 'cliVersion'), isNotEmpty);
      expect(_constant(identity, 'cliName'), 'elattar');
    });

    test('the version is the CLI\'s own', () {
      expect(releaseFacts.version, _constant(identity, 'cliVersion'));
    });

    test('the registry URL is the one a released CLI composes', () {
      // `identity.dart` builds it as '$siteOrigin/registry/$cliVersion/' and
      // its own test pins that composition; this pins the value the site
      // prints against the same two parts.
      final String origin = _constant(identity, 'siteOrigin');
      expect(
        releaseFacts.registryUrl,
        '$origin/registry/${releaseFacts.version}/',
      );
      expect(
        releaseFacts.registryUrl,
        endsWith('/'),
        reason: 'Uri.resolve drops the last segment without it',
      );
    });

    test('the tag is the one the CLI says a release is cut at', () {
      // `releaseTagFor(version) => 'v$version'` is the rule; this is the
      // value, and the two must not drift.
      expect(identity, contains("String releaseTagFor(String version) => 'v"));
      expect(releaseFacts.tag, 'v${releaseFacts.version}');
    });

    test('the version is the one the generated registry declares', () {
      for (final String name in <String>['index.json', 'registry.json']) {
        final Map<String, Object?> document =
            jsonDecode(
                  File('../registry/generated/latest/$name').readAsStringSync(),
                )
                as Map<String, Object?>;
        expect(
          document['registryVersion'],
          releaseFacts.version,
          reason: '$name declares a different registry version',
        );
      }
    });

    test('the version heads the CLI changelog', () {
      final List<String> headings = RegExp(r'^## .*$', multiLine: true)
          .allMatches(
            File('../packages/elattar_cli/CHANGELOG.md').readAsStringSync(),
          )
          .map((RegExpMatch m) => m.group(0)!)
          .toList();
      expect(headings, isNotEmpty);
      expect(headings.first, '## ${releaseFacts.version}');
    });

    test('every registry item links into the release tag', () {
      // `sourceLink` embeds the tag, so the tag has to be cut at the commit
      // the registry was generated from or a reader following a link lands on
      // source that is not what the item ships.
      final Map<String, Object?> registry =
          jsonDecode(
                File(
                  '../registry/generated/latest/registry.json',
                ).readAsStringSync(),
              )
              as Map<String, Object?>;
      final List<Object?> items = registry['items']! as List<Object?>;
      expect(items, isNotEmpty);
      for (final Object? entry in items) {
        final Map<String, Object?> item = entry! as Map<String, Object?>;
        final Object? link = item['sourceLink'];
        if (link == null) continue;
        expect(
          '$link',
          contains('/blob/${releaseFacts.tag}/'),
          reason: '${item['name']} links outside the release tag',
        );
      }
    });
  });

  group('the pages print the command the facts choose', () {
    test('installCommand is one of the two documented spellings', () {
      expect(
        releaseFacts.installCommand,
        releaseFacts.cliOnPubDev ? pubDevInstallCommand : gitInstallCommand,
      );
      expect(pubDevInstallCommand, 'dart install elattar_cli');
      expect(gitInstallCommand, contains('--git-path packages/elattar_cli'));
      expect(
        gitInstallCommand,
        isNot(contains('--git-ref')),
        reason:
            'the from-source route tracks the default branch; pinning it to '
            'a tag is what the released package is for',
      );
    });

    test('the quickstart pages read the command rather than restating it', () {
      // Both pages open with the same three steps. A literal install line in
      // either is a copy that outlives the state it was written for.
      for (final String page in <String>[
        'lib/docs_pages/installation_page.dart',
        'lib/docs_pages/introduction_page.dart',
      ]) {
        final String source = File(page).readAsStringSync();
        expect(
          source,
          contains(r'${releaseFacts.installCommand}'),
          reason: '$page does not take its install line from release_facts',
        );
      }
    });

    test('the release tag is not written into a page by hand', () {
      // The one place a tag may be spelled is `release_facts.dart`. Anywhere
      // else it is a literal that survives the next release.
      final RegExp tag = RegExp('v${RegExp.escape(releaseFacts.version)}');
      final List<String> offenders = <String>[];
      for (final FileSystemEntity entity in Directory(
        'lib/docs_pages',
      ).listSync()) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        if (entity.path.endsWith('release_facts.dart')) continue;
        if (tag.hasMatch(entity.readAsStringSync())) {
          offenders.add(entity.path);
        }
      }
      expect(offenders, isEmpty, reason: 'take the tag from releaseFacts.tag');
    });
  });
}
