/// The release invariants, checked by one command that needs no Flutter.
///
/// Most of what this asserts is also asserted somewhere in the test suites:
/// `packages/elattar_cli/test/version_identity_test.dart` covers the version
/// number, `test/license_distribution_test.dart` covers the licensing
/// contract. Both are worth keeping. Neither is reachable early: one needs
/// `dart pub get` inside the CLI package, the other needs a Flutter toolchain
/// and eighteen minutes of suite behind it.
///
/// This file exists so that the four things that make a release *wrong to
/// publish* — a version that is stated differently in different files, a
/// placeholder or quietly-extended license, a provenance ledger whose hashes
/// no longer describe the files, and a generated registry that disagrees with
/// its own index or with the tree it was generated from — fail in the first
/// minute of CI, on a runner that has only the Dart SDK.
///
/// Every check compares two independently-maintained sources against each
/// other. None compares a constant to a copy of itself.
///
/// The pure functions below take source text rather than paths so that the
/// mutation tests can break one invariant at a time without materialising a
/// fake repository.
library;

import 'dart:convert';
import 'dart:io';

/// Hashes a file's bytes to lowercase hex.
///
/// Injected rather than imported. The implementation this audit must use is
/// the registry generator's own `sha256Hex` — the exact code that wrote the
/// hashes being checked, so that a bug in it cannot make this audit pass while
/// the artifact is wrong in some other way. But a file under `lib/` is
/// addressed as a `package:` URI, and a relative import cannot climb out of
/// its own package, so `bin/verify.dart` and the tests pass it in instead.
typedef Sha256Hex = String Function(List<int> bytes);

/// The copyright line the owner confirmed on 2026-08-24.
///
/// Written out here rather than read from `LICENSE`, because a check that
/// reads its expectation from its subject checks nothing.
const String confirmedCopyrightLine = 'Copyright (c) 2026 ELATTAR Ayoub';

/// Words that would turn the standard MIT text into a different license while
/// still being labelled MIT.
const List<String> forbiddenLicenseWords = <String>[
  'attribution',
  'badge',
  'credit',
  'powered by',
  'built with',
];

/// Notice files that must be present, and the license each one carries.
const Map<String, String> noticeFiles = <String, String>{
  'third_party/fonts/inter/OFL.txt': 'SIL OPEN FONT LICENSE',
  'third_party/fonts/geist-mono/OFL.txt': 'SIL OPEN FONT LICENSE',
  'third_party/fonts/redaction/OFL.txt': 'SIL OPEN FONT LICENSE',
  'third_party/lucide/LICENSE': 'ISC License',
  'third_party/elevenlabs-ui/LICENSE': 'MIT License',
};

/// Files this repository redistributes that somebody else wrote.
///
/// The two generated Dart files are named in the ledger but deliberately not
/// hash-pinned: they are rebuilt from lucide on every upgrade, and pinning
/// them would turn a routine regeneration into a licensing failure. Their
/// notice is embedded in the file itself, which is checked separately.
const Map<String, bool> redistributedFiles = <String, bool>{
  'assets/fonts/InterVariable.ttf': true,
  'assets/fonts/GeistMono-Variable.ttf': true,
  'assets/fonts/Redaction35-Italic.ttf': true,
  'shaders/orb.frag': true,
  'assets/textures/perlin-noise.png': true,
  'lib/src/components/icon_paths.g.dart': false,
  'lib/src/components/icon_paths.g.index.dart': false,
};

// ─────────────────────────────────────────────────────────────────────────────
// Result model
// ─────────────────────────────────────────────────────────────────────────────

/// One invariant, and whether the tree satisfies it.
class Check {
  const Check(this.group, this.name, {required this.ok, this.detail = ''});

  final String group;
  final String name;
  final bool ok;
  final String detail;
}

/// The outcome of a whole audit run.
class AuditReport {
  AuditReport(this.checks);

  final List<Check> checks;

  Iterable<Check> get failures => checks.where((Check c) => !c.ok);

  bool get ok => failures.isEmpty;

  /// A human-readable transcript. Passing checks are printed too: a release
  /// audit that prints only failures gives no evidence that it looked.
  String render() {
    final StringBuffer out = StringBuffer();
    String? current;
    for (final Check check in checks) {
      if (check.group != current) {
        if (current != null) out.writeln();
        out.writeln('${check.group}:');
        current = check.group;
      }
      out.writeln('  ${check.ok ? 'ok  ' : 'FAIL'} ${check.name}');
      // Detail is evidence for a failure, not commentary on a pass.
      if (!check.ok && check.detail.isNotEmpty) {
        for (final String line in check.detail.split('\n')) {
          out.writeln('         $line');
        }
      }
    }
    out.writeln();
    final int failed = failures.length;
    out.writeln(
      failed == 0
          ? '${checks.length} checks, 0 failures.'
          : '${checks.length} checks, $failed failure${failed == 1 ? '' : 's'}.',
    );
    return out.toString();
  }
}

/// Collects checks in declaration order.
class _Recorder {
  final List<Check> checks = <Check>[];
  String _group = '';

  set group(String value) => _group = value;

  void record(String name, {required bool ok, String detail = ''}) =>
      checks.add(Check(_group, name, ok: ok, detail: detail));

  /// Records one check per finding-free assertion: no findings is a pass.
  void findings(String name, List<String> found) =>
      record(name, ok: found.isEmpty, detail: found.join('\n'));
}

// ─────────────────────────────────────────────────────────────────────────────
// Pure parsers — the pieces the mutation tests drive directly
// ─────────────────────────────────────────────────────────────────────────────

/// The `version:` a pubspec declares, or null if it declares none.
///
/// Deliberately not a YAML parse: this runs before any `pub get`, so it may
/// not depend on a package that is not in the SDK.
String? pubspecVersion(String source) {
  final RegExp declaration = RegExp(
    r'''^version:\s*['"]?([^'"\s#]+)''',
    multiLine: true,
  );
  return declaration.firstMatch(source)?.group(1);
}

/// The version in the first `## ` heading of a changelog.
String? firstChangelogVersion(String markdown) {
  for (final String line in const LineSplitter().convert(markdown)) {
    if (!line.startsWith('## ')) continue;
    final String heading = line.substring(3).trim();
    return RegExp(r'^\d+\.\d+\.\d+$').hasMatch(heading) ? heading : null;
  }
  return null;
}

/// The value of a top-level `const String <name> = ...;` declaration.
///
/// Handles the adjacent-string concatenation and `$cliVersion` interpolation
/// that `identity.dart` uses, because reconstructing the real runtime value is
/// the only way to check that the pinned registry path tracks the version
/// rather than merely looking like it does.
String? dartStringConstant(
  String source,
  String name, {
  Map<String, String> interpolations = const <String, String>{},
}) {
  final RegExp declaration = RegExp(
    'const\\s+String\\s+$name\\s*=([^;]*);',
    dotAll: true,
  );
  final RegExpMatch? match = declaration.firstMatch(source);
  if (match == null) return null;

  final String body = match.group(1)!;
  final Iterable<RegExpMatch> segments = RegExp(
    r"'((?:[^'\\]|\\.)*)'",
  ).allMatches(body);
  if (segments.isEmpty) return null;

  String value = segments
      .map((RegExpMatch segment) => segment.group(1)!)
      .join();
  interpolations.forEach((String key, String replacement) {
    value = value.replaceAll('\$$key', replacement);
  });
  return value;
}

/// The 64-hex tokens the provenance ledger states, lowercased.
Set<String> ledgerHashes(String prose) => RegExp(
  '`([0-9a-f]{64})`',
).allMatches(prose).map((RegExpMatch match) => match.group(1)!).toSet();

/// Everything wrong with the licensing surface, as sentences.
List<String> licenseFindings({
  required String license,
  required String cliLicense,
  required String pluginJson,
}) {
  final List<String> found = <String>[];

  if (license.contains('TODO')) {
    found.add('LICENSE still contains a TODO placeholder.');
  }
  if (!license.startsWith('MIT License')) {
    found.add('LICENSE does not begin with "MIT License".');
  }
  if (!license.contains(confirmedCopyrightLine)) {
    found.add('LICENSE does not carry "$confirmedCopyrightLine".');
  }
  for (final String clause in const <String>[
    'Permission is hereby granted, free of charge',
    'The above copyright notice and this permission notice shall be '
        'included in all',
    'THE SOFTWARE IS PROVIDED "AS IS"',
  ]) {
    if (!license.contains(clause)) {
      found.add('LICENSE is missing the MIT clause: "$clause".');
    }
  }
  final String lowered = license.toLowerCase();
  for (final String word in forbiddenLicenseWords) {
    if (lowered.contains(word)) {
      found.add(
        'LICENSE contains "$word", which suggests an added attribution '
        'clause. MIT must ship unmodified.',
      );
    }
  }
  if (cliLicense != license) {
    found.add(
      'packages/elattar_cli/LICENSE is not byte-identical to the '
      'repository LICENSE.',
    );
  }

  final Object? decoded = pluginJson.isEmpty ? null : jsonDecode(pluginJson);
  if (decoded is! Map<String, Object?>) {
    found.add('.claude-plugin/plugin.json is missing or is not an object.');
  } else if (decoded['license'] != 'MIT') {
    found.add(
      '.claude-plugin/plugin.json declares license '
      '${jsonEncode(decoded['license'])}, not "MIT".',
    );
  }

  return found;
}

/// Everything on which the generated index and the generated registry
/// disagree.
List<String> indexRegistryFindings(
  Map<String, Object?> index,
  Map<String, Object?> registry,
) {
  final List<String> found = <String>[];

  if (index['schemaVersion'] != registry['schemaVersion']) {
    found.add(
      'schemaVersion: index says ${index['schemaVersion']}, registry says '
      '${registry['schemaVersion']}.',
    );
  }
  if (index['registryVersion'] != registry['registryVersion']) {
    found.add(
      'registryVersion: index says ${index['registryVersion']}, registry '
      'says ${registry['registryVersion']}.',
    );
  }

  Map<String, Map<String, Object?>> byName(
    Object? items,
  ) => <String, Map<String, Object?>>{
    for (final Object? raw in (items as List<Object?>? ?? const <Object?>[]))
      ((raw! as Map<String, Object?>)['name']! as String):
          raw as Map<String, Object?>,
  };

  final Map<String, Map<String, Object?>> indexed = byName(index['items']);
  final Map<String, Map<String, Object?>> full = byName(registry['items']);

  final Set<String> onlyIndex = indexed.keys.toSet()..removeAll(full.keys);
  final Set<String> onlyRegistry = full.keys.toSet()..removeAll(indexed.keys);
  if (onlyIndex.isNotEmpty) {
    found.add('in the index but not the registry: ${onlyIndex.join(', ')}.');
  }
  if (onlyRegistry.isNotEmpty) {
    found.add('in the registry but not the index: ${onlyRegistry.join(', ')}.');
  }

  for (final String name in indexed.keys.where(full.containsKey)) {
    for (final String field in const <String>[
      'type',
      'version',
      'documentationRoute',
    ]) {
      if (indexed[name]![field] != full[name]![field]) {
        found.add(
          '$name.$field: index says ${jsonEncode(indexed[name]![field])}, '
          'registry says ${jsonEncode(full[name]![field])}.',
        );
      }
    }
  }

  return found;
}

/// Registry items whose `version` or `sourceLink` does not pin [version].
///
/// A `sourceLink` on a moving branch is the failure the baseline audit found:
/// every link would keep resolving while silently describing different source
/// than the one the release shipped.
List<String> registryPinningFindings(
  Map<String, Object?> registry,
  String version,
) {
  final List<String> found = <String>[];
  final String tag = 'v$version';
  for (final Object? raw
      in (registry['items'] as List<Object?>? ?? const <Object?>[])) {
    final Map<String, Object?> item = raw! as Map<String, Object?>;
    final String name = '${item['name']}';
    if (item['version'] != version) {
      found.add('$name declares version ${jsonEncode(item['version'])}.');
    }
    final Object? link = item['sourceLink'];
    if (link is! String || link.isEmpty) {
      found.add('$name has no sourceLink.');
    } else if (!link.contains('/blob/$tag/')) {
      found.add('$name.sourceLink does not pin /blob/$tag/: $link');
    }
  }
  return found;
}

// ─────────────────────────────────────────────────────────────────────────────
// The audit itself
// ─────────────────────────────────────────────────────────────────────────────

/// Runs every release invariant against the checkout at [repoRoot].
AuditReport auditRelease(String repoRoot, {required Sha256Hex sha256Hex}) {
  final _Recorder recorder = _Recorder();

  String path(String relative) => '$repoRoot/$relative';
  bool exists(String relative) => File(path(relative)).existsSync();
  String read(String relative) => File(path(relative)).readAsStringSync();
  String readOrEmpty(String relative) => exists(relative) ? read(relative) : '';
  Map<String, Object?>? readJson(String relative) => exists(relative)
      ? jsonDecode(read(relative)) as Map<String, Object?>
      : null;

  // ── version identity ──────────────────────────────────────────────────────
  recorder.group = 'Version identity';

  final String? cliVersion = dartStringConstant(
    readOrEmpty('packages/elattar_cli/lib/src/identity.dart'),
    'cliVersion',
  );
  final Map<String, Object?>? index = readJson(
    'registry/generated/latest/index.json',
  );
  final Map<String, Object?>? registry = readJson(
    'registry/generated/latest/registry.json',
  );
  final String? registryUrl = dartStringConstant(
    readOrEmpty('packages/elattar_cli/lib/src/identity.dart'),
    'defaultRegistryUrl',
    interpolations: <String, String>{'cliVersion': cliVersion ?? ''},
  );

  final Map<String, String?> stated = <String, String?>{
    'pubspec.yaml': pubspecVersion(readOrEmpty('pubspec.yaml')),
    'packages/elattar_cli/pubspec.yaml': pubspecVersion(
      readOrEmpty('packages/elattar_cli/pubspec.yaml'),
    ),
    'packages/elattar_cli/lib/src/identity.dart (cliVersion)': cliVersion,
    'packages/elattar_cli/lib/src/identity.dart (defaultRegistryUrl)':
        registryUrl == null
        ? null
        : RegExp(r'/registry/([^/]+)/$').firstMatch(registryUrl)?.group(1),
    'registry/generated/latest/index.json':
        index?['registryVersion'] as String?,
    'registry/generated/latest/registry.json':
        registry?['registryVersion'] as String?,
    'CHANGELOG.md': firstChangelogVersion(readOrEmpty('CHANGELOG.md')),
    'packages/elattar_cli/CHANGELOG.md': firstChangelogVersion(
      readOrEmpty('packages/elattar_cli/CHANGELOG.md'),
    ),
  };

  final Set<String?> distinct = stated.values.toSet();
  recorder.record(
    'all ${stated.length} sources state one version',
    ok: distinct.length == 1 && distinct.single != null,
    detail: distinct.length == 1 && distinct.single != null
        ? ''
        : stated.entries
              .map((MapEntry<String, String?> e) => '${e.key}: ${e.value}')
              .join('\n'),
  );

  final String version = distinct.length == 1 && distinct.single != null
      ? distinct.single!
      : (cliVersion ?? '');

  recorder.record(
    'the version they state, ${version.isEmpty ? '(none)' : version}, is a '
    'plain semver triple',
    ok: RegExp(r'^\d+\.\d+\.\d+$').hasMatch(version),
    detail: version.isEmpty ? 'no version could be read' : version,
  );

  final String identitySource = readOrEmpty(
    'packages/elattar_cli/lib/src/identity.dart',
  );
  final RegExpMatch? urlDeclaration = RegExp(
    r'const\s+String\s+defaultRegistryUrl\s*=([^;]*);',
    dotAll: true,
  ).firstMatch(identitySource);
  recorder.record(
    'the pinned registry URL is derived from cliVersion, not retyped',
    ok:
        urlDeclaration != null &&
        urlDeclaration.group(1)!.contains(r'$cliVersion') &&
        !RegExp(r'\d+\.\d+\.\d+').hasMatch(urlDeclaration.group(1)!),
    detail: urlDeclaration == null
        ? 'defaultRegistryUrl is not declared in identity.dart'
        : urlDeclaration.group(1)!.trim(),
  );

  // ── license ───────────────────────────────────────────────────────────────
  recorder.group = 'License';

  recorder.findings(
    'MIT is present, unmodified, and travels with the CLI package',
    exists('LICENSE')
        ? licenseFindings(
            license: read('LICENSE'),
            cliLicense: readOrEmpty('packages/elattar_cli/LICENSE'),
            pluginJson: readOrEmpty('.claude-plugin/plugin.json'),
          )
        : <String>['LICENSE does not exist.'],
  );

  recorder.record(
    'the CLI embeds the same MIT text it will write into consumer projects',
    ok: () {
      final String embedded = readOrEmpty(
        'packages/elattar_cli/lib/src/license_notice.dart',
      );
      final String license = readOrEmpty('LICENSE');
      if (embedded.isEmpty || license.isEmpty) return false;
      return license
          .split('\n')
          .where((String line) => line.trim().isNotEmpty)
          .every(embedded.contains);
    }(),
    detail:
        'packages/elattar_cli/lib/src/license_notice.dart must contain every '
        'line of LICENSE; it is the only copy a globally activated CLI has.',
  );

  // ── provenance ────────────────────────────────────────────────────────────
  recorder.group = 'Provenance';

  final String ledgerProse = readOrEmpty('THIRD_PARTY_NOTICES.md');
  final Set<String> ledger = ledgerHashes(ledgerProse);

  recorder.findings('every notice file exists and grants something', <String>[
    if (ledgerProse.isEmpty) 'THIRD_PARTY_NOTICES.md does not exist.',
    for (final MapEntry<String, String> entry in noticeFiles.entries)
      if (!exists(entry.key))
        '${entry.key} is missing.'
      else if (!read(entry.key).contains(entry.value))
        '${entry.key} does not contain "${entry.value}".'
      else if (!read(entry.key).contains('Permission is hereby granted') &&
          !read(entry.key).contains('Permission to use, copy, modify'))
        '${entry.key} names a license but states no permission grant.',
  ]);

  recorder.findings('every recorded hash still describes its file', <String>[
    for (final String notice in noticeFiles.keys)
      if (exists(notice) &&
          !ledger.contains(sha256Hex(File(path(notice)).readAsBytesSync())))
        '$notice hashes to '
            '${sha256Hex(File(path(notice)).readAsBytesSync())}, which '
            'THIRD_PARTY_NOTICES.md does not record.',
    for (final MapEntry<String, bool> entry in redistributedFiles.entries)
      if (!exists(entry.key))
        '${entry.key} is recorded as redistributed but is missing.'
      else if (!ledgerProse.contains(entry.key))
        '${entry.key} is redistributed but is never named in the ledger.'
      else if (entry.value &&
          !ledger.contains(sha256Hex(File(path(entry.key)).readAsBytesSync())))
        '${entry.key} hashes to '
            '${sha256Hex(File(path(entry.key)).readAsBytesSync())}, which '
            'THIRD_PARTY_NOTICES.md does not record.',
  ]);

  recorder.record(
    'the ledger scopes the MIT grant to Elattar\'s own work',
    ok: ledgerProse.contains('covers Elattar'),
    detail:
        'THIRD_PARTY_NOTICES.md must say what the MIT license does not cover.',
  );

  // ── registry ──────────────────────────────────────────────────────────────
  recorder.group = 'Registry';

  if (index == null || registry == null) {
    recorder.record(
      'the generated registry is present',
      ok: false,
      detail:
          'run `dart run tool/registry_builder/bin/build.dart .` before '
          'auditing.',
    );
  } else {
    recorder.findings(
      'the index and the registry describe the same ${(registry['items'] as List<Object?>).length} items',
      indexRegistryFindings(index, registry),
    );

    recorder.findings(
      'every item pins version $version and the v$version source tag',
      registryPinningFindings(registry, version),
    );

    final List<String> payload = <String>[];
    int hashed = 0;
    int notices = 0;
    for (final Object? raw in registry['items']! as List<Object?>) {
      final Map<String, Object?> item = raw! as Map<String, Object?>;
      for (final String kind in const <String>['files', 'licenses']) {
        for (final Object? entry
            in (item[kind] as List<Object?>? ?? const <Object?>[])) {
          final Map<String, Object?> record = entry! as Map<String, Object?>;
          final String source = record['source']! as String;
          final File file = File(path(source));
          if (!file.existsSync()) {
            payload.add('${item['name']}: $source does not exist.');
            continue;
          }
          final String actual = sha256Hex(file.readAsBytesSync());
          if (actual != record['sha256']) {
            payload.add(
              '${item['name']}: $source hashes to $actual, the registry '
              'records ${record['sha256']}.',
            );
          }
          if (kind == 'files') {
            hashed++;
          } else {
            notices++;
          }
        }
      }
    }
    recorder.findings(
      'all $hashed distributed files and $notices notice payloads hash as recorded',
      payload,
    );

    final Map<String, Object?>? inventory = readJson(
      'registry/component_inventory.json',
    );
    final Set<String> names = <String>{
      for (final Object? raw in registry['items']! as List<Object?>)
        (raw! as Map<String, Object?>)['name']! as String,
    };
    recorder.findings('every inventory owner is a registry item', <String>[
      if (inventory == null)
        'registry/component_inventory.json does not exist.'
      else
        for (final Object? owner
            in inventory['installableOwners']! as List<Object?>)
          if (!names.contains(owner))
            'inventory names $owner, the registry '
                'does not.',
    ]);
  }

  return AuditReport(recorder.checks);
}
