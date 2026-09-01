/// One version number, stated in six places, asserted to be the same one.
///
/// The audit found that `--version` printed a literal the pubspec did not
/// constrain: bumping `pubspec.yaml` to `0.0.2` would have shipped a package
/// whose own `--version` still said `0.0.1`, and nothing would have failed.
/// The literal was asserted against another literal, which tests the test.
///
/// So every check below compares two *independently maintained sources*
/// against each other, never a constant against a copy of itself.
library;

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import '../lib/src/identity.dart';
import '../lib/src/license_notice.dart';

/// `dart test` runs with the package as the working directory.
File _packageFile(String relative) => File(relative);

File _repoFile(String relative) => File('../../$relative');

String _pubspecVersion(File pubspec) {
  final Object parsed = loadYaml(pubspec.readAsStringSync());
  return (parsed as YamlMap)['version'] as String;
}

void main() {
  final File pubspec = _packageFile('pubspec.yaml');

  group('the version this package declares', () {
    test('matches the version the binary prints', () {
      // The mutation this exists to catch: change the pubspec, and
      // `--version` keeps lying until someone notices in a bug report.
      expect(_pubspecVersion(pubspec), cliVersion);
      expect(CliIdentity.version, cliVersion);
    });

    test('is the version the default registry URL points at', () {
      // A CLI that pins `/registry/0.0.1/` while calling itself 0.0.2 would
      // install the previous release's sources under the new name.
      expect(
        defaultRegistryUrl,
        contains('/registry/$cliVersion/'),
        reason: 'the pinned registry path must track the CLI version',
      );
      expect(defaultRegistryUri.path, endsWith('/$cliVersion/'));
    });

    test('composes siteOrigin and cliVersion rather than restating either', () {
      // Not `defaultRegistryUrl == 'https://flutter.elattar.dev/registry/'
      // '0.0.1/'`: a test that spells the origin out again would keep
      // passing even if `defaultRegistryUrl` stopped deriving from
      // `siteOrigin` and went back to restating it — exactly the drift the
      // refactor to a single injected origin closed. Comparing against the
      // *value* of `siteOrigin` (not a literal copy of it) is what proves
      // composition rather than restatement.
      expect(
        defaultRegistryUrl,
        startsWith(siteOrigin),
        reason:
            'defaultRegistryUrl must derive from siteOrigin, not a '
            'hardcoded host',
      );
      expect(defaultRegistryUrl, '$siteOrigin/registry/$cliVersion/');
    });

    test(
      'ends in a trailing slash, so Uri.resolve does not drop a segment',
      () {
        expect(defaultRegistryUrl, endsWith('/'));
        expect(defaultRegistryUri.path, endsWith('/'));

        // Prove the slash is load-bearing rather than decorative: resolving a
        // relative path against a base URI missing the trailing slash drops
        // the base's last path segment instead of appending underneath it.
        final Uri withoutTrailingSlash = Uri.parse(
          defaultRegistryUrl.substring(0, defaultRegistryUrl.length - 1),
        );
        expect(
          withoutTrailingSlash.resolve('index.json').path,
          isNot(defaultRegistryUri.resolve('index.json').path),
          reason:
              'a base URI without the trailing slash would resolve '
              '"index.json" one directory up instead of alongside the '
              'version it is pinned to',
        );
      },
    );

    test('is the version the generated registry declares', () {
      final File registry = _repoFile('registry/generated/latest/index.json');
      expect(
        registry.existsSync(),
        isTrue,
        reason: 'run `dart run tool/registry_builder/bin/build.dart .` first',
      );
      final Map<String, Object?> index =
          jsonDecode(registry.readAsStringSync()) as Map<String, Object?>;
      expect(
        index['registryVersion'],
        cliVersion,
        reason:
            'this CLI would fetch /registry/$cliVersion/ and find a registry '
            'declaring ${index['registryVersion']}',
      );
    });

    test('is the version the release tag will use', () {
      // The tag format is stated here rather than only in a runbook, so the
      // release process has one machine-checked spelling of it.
      expect(releaseTagFor(cliVersion), 'v$cliVersion');
      expect(RegExp(r'^\d+\.\d+\.\d+$').hasMatch(cliVersion), isTrue);
    });

    test('has a matching entry at the top of this package\'s changelog', () {
      final List<String> headings = _packageFile('CHANGELOG.md')
          .readAsLinesSync()
          .where((String line) => line.startsWith('## '))
          .toList();
      expect(headings, isNotEmpty, reason: 'the changelog has no releases');
      expect(headings.first, '## $cliVersion');
    });
  });

  group('the package is shaped for pub.dev', () {
    late YamlMap manifest;

    setUpAll(() {
      manifest = loadYaml(pubspec.readAsStringSync()) as YamlMap;
    });

    test('publishing is not blocked', () {
      // The root package keeps `publish_to: none` deliberately. This one must
      // not, or `dart pub publish` refuses before it starts.
      expect(
        manifest.containsKey('publish_to'),
        isFalse,
        reason: 'publish_to: none would make this package unpublishable',
      );
    });

    test('it declares where it comes from', () {
      for (final String key in <String>[
        'homepage',
        'repository',
        'issue_tracker',
        'description',
        'topics',
      ]) {
        expect(manifest.containsKey(key), isTrue, reason: 'missing $key');
      }
      expect('${manifest['repository']}', startsWith('https://'));
      expect('${manifest['issue_tracker']}', startsWith('https://'));
    });

    test('the description is within pub.dev\'s preferred length', () {
      // pub.dev scores 60-180 characters. Outside it, the package ships with
      // an avoidable points deduction on its own listing page.
      final String description = '${manifest['description']}'.trim();
      expect(description.length, greaterThanOrEqualTo(60));
      expect(description.length, lessThanOrEqualTo(180));
    });

    test('the executable is named elattar', () {
      final YamlMap executables = manifest['executables'] as YamlMap;
      expect(executables['elattar'], 'elattar');
      expect(
        _packageFile('bin/elattar.dart').existsSync(),
        isTrue,
        reason: 'executables: points at bin/elattar.dart',
      );
    });

    test('every dependency is default-hosted', () {
      // A git or path dependency makes a package unpublishable, and a
      // non-default hosted one makes it uninstallable for anyone who has not
      // configured that server.
      final YamlMap dependencies = manifest['dependencies'] as YamlMap;
      dependencies.forEach((Object? name, Object? constraint) {
        expect(
          constraint,
          isA<String>(),
          reason: '$name must be a plain hosted version constraint',
        );
      });
      expect(dependencies.keys, <String>['yaml']);
    });

    test('the required files are present', () {
      for (final String name in <String>[
        'README.md',
        'CHANGELOG.md',
        'LICENSE',
        '.pubignore',
      ]) {
        expect(
          _packageFile(name).existsSync(),
          isTrue,
          reason: '$name is missing from the package root',
        );
      }
    });
  });

  group('the license travels intact', () {
    test('this package\'s LICENSE is the repository\'s, byte for byte', () {
      expect(
        _packageFile('LICENSE').readAsBytesSync(),
        _repoFile('LICENSE').readAsBytesSync(),
        reason:
            'the published package must carry the same MIT text as the '
            'repository it comes from',
      );
    });

    test('the notice the CLI writes is that same text', () {
      // Three copies now: the repository's, the package's, and the constant
      // compiled into the binary. All three are compared, because the one a
      // consumer receives is the third.
      expect(elattarMitNotice, _packageFile('LICENSE').readAsStringSync());
    });

    test('it names the confirmed copyright holder', () {
      expect(
        _packageFile('LICENSE').readAsStringSync(),
        contains('Copyright (c) 2026 ELATTAR Ayoub'),
      );
    });
  });
}
