/// Two kinds of test, because one alone would be a lie.
///
/// The end-to-end test runs the real audit against this real checkout and
/// requires zero failures. On its own that proves only that the audit is
/// currently quiet — an audit that returned an empty list would pass it.
///
/// So every invariant also has a mutation test: the pure function is handed a
/// version of the input with exactly that invariant broken, and must say so.
/// Those run on strings rather than on a fabricated repository, which is what
/// keeps them fast and what keeps them from re-implementing the tree they are
/// supposed to be checking.
library;

import 'dart:io';

import 'package:test/test.dart';

import '../../registry_builder/lib/generator.dart' show sha256Hex;
import '../lib/audit.dart';

/// `dart test` runs with the package directory as the working directory.
final String _repoRoot = Directory.current.parent.parent.path;

const String _mit = '''
MIT License

Copyright (c) 2026 ELATTAR Ayoub

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction.

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.
''';

Map<String, Object?> _item(
  String name, {
  String version = '0.0.1',
  String type = 'component',
  String route = '/components/x',
  String? link,
}) => <String, Object?>{
  'name': name,
  'type': type,
  'version': version,
  'documentationRoute': route,
  'sourceLink': link ?? 'https://example.test/blob/v0.0.1/lib/$name.dart',
};

void main() {
  group('this checkout', () {
    late AuditReport report;

    setUpAll(() => report = auditRelease(_repoRoot, sha256Hex: sha256Hex));

    test('passes every release invariant', () {
      expect(report.ok, isTrue, reason: report.render());
    });

    test('was actually audited, rather than found empty', () {
      // The mutation this catches: an audit that silently checks nothing
      // satisfies `ok` perfectly.
      expect(report.checks.length, greaterThanOrEqualTo(12));
      for (final String group in const <String>[
        'Version identity',
        'License',
        'Provenance',
        'Registry',
      ]) {
        expect(
          report.checks.map((Check c) => c.group),
          contains(group),
          reason: 'the audit skipped the $group group entirely',
        );
      }
    });

    test('renders a transcript that names each failure', () {
      final String rendered = AuditReport(<Check>[
        const Check('G', 'passing', ok: true, detail: 'not shown'),
        const Check('G', 'broken', ok: false, detail: 'because of this'),
      ]).render();
      expect(rendered, contains('FAIL broken'));
      expect(rendered, contains('because of this'));
      expect(rendered, isNot(contains('not shown')));
      expect(rendered, contains('2 checks, 1 failure.'));
    });
  });

  group('pubspecVersion', () {
    test('reads a quoted or bare version', () {
      expect(pubspecVersion('name: x\nversion: 0.0.1\n'), '0.0.1');
      expect(pubspecVersion("name: x\nversion: '1.2.3'\n"), '1.2.3');
    });

    test('is not fooled by a version key nested under something else', () {
      // `^version:` is anchored to column zero for this reason: a dependency
      // constraint block contains lines that look like a declaration.
      expect(
        pubspecVersion('dependencies:\n  foo:\n    version: 9.9.9\n'),
        isNull,
      );
    });

    test('returns null when there is no version at all', () {
      expect(pubspecVersion('name: x\n'), isNull);
    });
  });

  group('firstChangelogVersion', () {
    test('reads the topmost release heading', () {
      expect(
        firstChangelogVersion('# Changelog\n\n## 0.0.1\n\n## 0.0.0\n'),
        '0.0.1',
      );
    });

    test('refuses a heading that is not a version', () {
      // "## Unreleased" at the top means the changelog does not yet describe
      // the thing being released.
      expect(firstChangelogVersion('# Changelog\n\n## Unreleased\n'), isNull);
    });
  });

  group('dartStringConstant', () {
    const String identity = '''
const String cliVersion = '0.0.1';

const String defaultRegistryUrl =
    'https://example.test/registry/'
    '\$cliVersion/';
''';

    test('reads a plain constant', () {
      expect(dartStringConstant(identity, 'cliVersion'), '0.0.1');
    });

    test('reconstructs concatenation and interpolation', () {
      expect(
        dartStringConstant(
          identity,
          'defaultRegistryUrl',
          interpolations: const <String, String>{'cliVersion': '0.0.1'},
        ),
        'https://example.test/registry/0.0.1/',
      );
    });

    test('returns null for a constant that is not declared', () {
      expect(dartStringConstant(identity, 'notThere'), isNull);
    });

    test(
      'resolves only the requested interpolation, leaving an unrequested '
      'one as literal text',
      () {
        // The real shape post-refactor: `defaultRegistryUrl` interpolates
        // both `siteOrigin` and `cliVersion` into one literal, and the audit
        // only ever resolves `cliVersion` (see the comment in audit.dart).
        // This pins that resolving one placeholder does not choke on, or
        // silently drop, the other — the exact regression that would make
        // the version-identity check start comparing `$cliVersion` against
        // itself instead of against the real version.
        const String withSiteOrigin = '''
const String siteOrigin = String.fromEnvironment(
  'ELATTAR_SITE_ORIGIN',
  defaultValue: 'https://example.test',
);
const String cliVersion = '0.0.1';

const String defaultRegistryUrl = '\$siteOrigin/registry/\$cliVersion/';
''';
        expect(
          dartStringConstant(
            withSiteOrigin,
            'defaultRegistryUrl',
            interpolations: const <String, String>{'cliVersion': '0.0.1'},
          ),
          r'$siteOrigin/registry/0.0.1/',
        );
      },
    );
  });

  group('registryUrlCompositionFinding', () {
    test('a declaration built from siteOrigin and cliVersion has no finding', () {
      expect(
        registryUrlCompositionFinding(
          r"const String defaultRegistryUrl = '$siteOrigin/registry/$cliVersion/';",
        ),
        isNull,
      );
    });

    test(
      'catches a hardcoded origin even when cliVersion is still interpolated',
      () {
        expect(
          registryUrlCompositionFinding(
            "const String defaultRegistryUrl =\n"
            "    'https://example.test/registry/'\n"
            "    '\$cliVersion/';",
          ),
          contains('siteOrigin'),
        );
      },
    );

    test('catches a hardcoded version standing in for cliVersion', () {
      expect(
        registryUrlCompositionFinding(
          r"const String defaultRegistryUrl = '$siteOrigin/registry/0.0.1/';",
        ),
        isNotNull,
      );
    });

    test('catches a missing declaration', () {
      expect(
        registryUrlCompositionFinding('const int x = 1;'),
        contains('is not declared'),
      );
    });
  });

  group('ledgerHashes', () {
    test('collects backticked sha256 tokens and nothing else', () {
      final Set<String> found = ledgerHashes(
        'Notice sha256 | `${'a' * 64}`\nnot a hash: `${'a' * 63}`\n'
        'unquoted ${'b' * 64}\n',
      );
      expect(found, <String>{'a' * 64});
    });
  });

  group('licenseFindings', () {
    List<String> check({
      String? license,
      String? cliLicense,
      String plugin = '{"license": "MIT"}',
    }) => licenseFindings(
      license: license ?? _mit,
      cliLicense: cliLicense ?? license ?? _mit,
      pluginJson: plugin,
    );

    test('an intact MIT with the confirmed line has no findings', () {
      expect(check(), isEmpty);
    });

    test('catches the placeholder the baseline audit found', () {
      expect(
        check(license: 'TODO: Add your license here.\n'),
        contains(contains('TODO')),
      );
    });

    test('catches a different copyright holder', () {
      expect(
        check(license: _mit.replaceAll('ELATTAR Ayoub', 'Somebody Else')),
        contains(contains(confirmedCopyrightLine)),
      );
    });

    test('catches a dropped MIT clause', () {
      expect(
        check(license: _mit.replaceAll('THE SOFTWARE IS PROVIDED "AS IS"', '')),
        contains(contains('missing the MIT clause')),
      );
    });

    test('catches MIT quietly extended with an attribution clause', () {
      for (final String word in forbiddenLicenseWords) {
        expect(
          check(license: '$_mit\nYou must display $word in your app.\n'),
          contains(contains(word)),
          reason: '"$word" should have been rejected',
        );
      }
    });

    test('catches the CLI package carrying a different license', () {
      expect(
        check(cliLicense: '$_mit\n'),
        contains(contains('byte-identical')),
      );
    });

    test('catches a plugin payload that declares no license', () {
      expect(check(plugin: '{}'), contains(contains('plugin.json')));
      expect(check(plugin: ''), contains(contains('plugin.json')));
    });
  });

  group('indexRegistryFindings', () {
    Map<String, Object?> registry(List<Map<String, Object?>> items) =>
        <String, Object?>{
          'schemaVersion': 1,
          'registryVersion': '0.0.1',
          'items': items,
        };

    test('agreeing documents have no findings', () {
      expect(
        indexRegistryFindings(
          registry(<Map<String, Object?>>[_item('button')]),
          registry(<Map<String, Object?>>[_item('button')]),
        ),
        isEmpty,
      );
    });

    test('catches an item present in only one of them', () {
      expect(
        indexRegistryFindings(
          registry(<Map<String, Object?>>[_item('button')]),
          registry(<Map<String, Object?>>[_item('button'), _item('icon')]),
        ),
        contains(contains('not the index')),
      );
      expect(
        indexRegistryFindings(
          registry(<Map<String, Object?>>[_item('button'), _item('icon')]),
          registry(<Map<String, Object?>>[_item('button')]),
        ),
        contains(contains('not the registry')),
      );
    });

    test('catches a field that drifted between them', () {
      expect(
        indexRegistryFindings(
          registry(<Map<String, Object?>>[_item('button', route: '/old')]),
          registry(<Map<String, Object?>>[_item('button', route: '/new')]),
        ),
        contains(contains('button.documentationRoute')),
      );
    });

    test('catches disagreeing schema or registry versions', () {
      final Map<String, Object?> index = registry(<Map<String, Object?>>[]);
      final Map<String, Object?> full = registry(<Map<String, Object?>>[])
        ..['registryVersion'] = '0.0.2'
        ..['schemaVersion'] = 2;
      final List<String> found = indexRegistryFindings(index, full);
      expect(found, contains(contains('schemaVersion')));
      expect(found, contains(contains('registryVersion')));
    });
  });

  group('registryPinningFindings', () {
    Map<String, Object?> registry(List<Map<String, Object?>> items) =>
        <String, Object?>{'items': items};

    test('items pinned to the release tag have no findings', () {
      expect(
        registryPinningFindings(
          registry(<Map<String, Object?>>[_item('button')]),
          '0.0.1',
        ),
        isEmpty,
      );
    });

    test('catches a sourceLink on a moving branch', () {
      // The exact failure the baseline audit recorded: 99 links to
      // `blob/main/...`, all of which keep resolving while describing source
      // that is not what the release shipped.
      expect(
        registryPinningFindings(
          registry(<Map<String, Object?>>[
            _item(
              'button',
              link: 'https://example.test/blob/main/lib/button.dart',
            ),
          ]),
          '0.0.1',
        ),
        contains(contains('does not pin /blob/v0.0.1/')),
      );
    });

    test('catches an item left at an older version', () {
      expect(
        registryPinningFindings(
          registry(<Map<String, Object?>>[_item('button', version: '0.0.0')]),
          '0.0.1',
        ),
        contains(contains('declares version')),
      );
    });

    test('catches a missing sourceLink', () {
      final Map<String, Object?> item = _item('button')..remove('sourceLink');
      expect(
        registryPinningFindings(
          registry(<Map<String, Object?>>[item]),
          '0.0.1',
        ),
        contains(contains('no sourceLink')),
      );
    });
  });
}
