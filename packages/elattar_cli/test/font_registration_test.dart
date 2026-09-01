/// The consumer-side font seam.
///
/// A font family is a string, so nothing downstream of the installer can catch
/// a wrong one: the project compiles, `flutter analyze` is clean, and every
/// glyph renders in the platform fallback face. These tests therefore run the
/// real `elattar init` into a clean project against the real registry, and
/// assert the two sides against **each other** — the families the generated
/// `pubspec.yaml` declares, and the families the installed `typography.dart`
/// asks for — so neither side can drift alone.
///
/// Mutations these catch (both previously survived the whole suite):
///  * deriving the family from the file name (`InterVariable`) instead of the
///    registry entry (`InterLocal`), or hard-coding any wrong family such as
///    `'zzz'`;
///  * leaving `Fonts.package = 'elattar_design_system'` in installed source,
///    which resolves every family to `packages/elattar_design_system/<Family>`
///    in a project that has no such dependency.
library;

import 'dart:io';

import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import '../lib/src/install/models.dart';

/// Families named by `Fonts` in installed foundation source, e.g.
/// `static const String sans = 'InterLocal';`.
///
/// `package` is deliberately not matched: installation rewrites it to
/// `static const String? package = null`, so the nullable type keeps it out of
/// this pattern — and if that rewrite ever stopped happening, the package name
/// would appear here as a family and the comparison below would fail.
final RegExp _dsFontsFamily = RegExp(
  r"^\s*static const String \w+ = '([^']+)';",
  multiLine: true,
);

Set<String> _familiesAskedFor(String typographySource) {
  final int classStart = typographySource.indexOf('class Fonts {');
  expect(classStart, greaterThanOrEqualTo(0), reason: 'Fonts not found');
  final int classEnd = typographySource.indexOf('\n}', classStart);
  final String body = typographySource.substring(classStart, classEnd);
  return <String>{
    for (final RegExpMatch match in _dsFontsFamily.allMatches(body))
      match.group(1)!,
  };
}

YamlList _declaredFonts(String pubspecSource) {
  final YamlMap pubspec = loadYaml(pubspecSource) as YamlMap;
  final YamlMap flutter = pubspec['flutter'] as YamlMap;
  return flutter['fonts'] as YamlList;
}

/// A clean project with `elattar init` run in it by the real CLI binary.
///
/// Driving the executable rather than `Installer` directly keeps the whole
/// chain under test: registry parse, `_toInstallItem`, the installer, the
/// source rewrite, and the pubspec editor.
Future<Directory> _initialisedProject() async {
  final Directory packageRoot = Directory.current.absolute;
  final Directory repoRoot = packageRoot.parent.parent.absolute;
  final Directory project = Directory.systemTemp.createTempSync(
    'elattar-fonts-',
  );
  File('${project.path}/pubspec.yaml').writeAsStringSync('''
name: font_fixture
description: Consumer-side font registration fixture.
environment:
  sdk: ^3.12.2
dependencies:
  flutter:
    sdk: flutter
flutter:
''');
  final ProcessResult init =
      await Process.run(Platform.resolvedExecutable, <String>[
        '${packageRoot.path}${Platform.pathSeparator}bin'
            '${Platform.pathSeparator}elattar.dart',
        'init',
        '--registry',
        '${repoRoot.path}${Platform.pathSeparator}registry'
            '${Platform.pathSeparator}generated'
            '${Platform.pathSeparator}latest',
      ], workingDirectory: project.path);
  expect(
    init.exitCode,
    0,
    reason: 'stdout:\n${init.stdout}\n\nstderr:\n${init.stderr}',
  );
  return project;
}

void main() {
  late Directory project;

  setUpAll(() async {
    project = await _initialisedProject();
  });

  tearDownAll(() {
    if (project.existsSync()) project.deleteSync(recursive: true);
  });

  String pubspec() => File('${project.path}/pubspec.yaml').readAsStringSync();

  String typography() => File(
    '${project.path}/lib/design_system/foundation/typography.dart',
  ).readAsStringSync();

  test(
    'the pubspec declares exactly the families the installed typography asks for',
    () {
      final Set<String> declared = <String>{
        for (final Object? entry in _declaredFonts(pubspec()))
          '${(entry! as YamlMap)['family']}',
      };
      final Set<String> askedFor = _familiesAskedFor(typography());

      expect(
        askedFor,
        isNotEmpty,
        reason: 'installed typography named no font families',
      );
      expect(
        declared,
        equals(askedFor),
        reason:
            'pubspec.yaml declares $declared but typography.dart asks for '
            '$askedFor — every glyph renders in the platform fallback face, '
            'and no analyzer can see it',
      );
    },
  );

  test('each declared family points at a font file that was copied', () {
    final Map<String, List<String>> assetsByFamily = <String, List<String>>{};
    for (final Object? entry in _declaredFonts(pubspec())) {
      final YamlMap family = entry! as YamlMap;
      assetsByFamily['${family['family']}'] = <String>[
        for (final Object? face in family['fonts'] as YamlList)
          '${(face! as YamlMap)['asset']}',
      ];
    }

    expect(assetsByFamily, hasLength(2));
    expect(assetsByFamily['InterLocal'], <String>[
      'assets/elattar/fonts/InterVariable.ttf',
    ]);
    expect(assetsByFamily['GeistMono'], <String>[
      'assets/elattar/fonts/GeistMono-Variable.ttf',
    ]);
    for (final List<String> assets in assetsByFamily.values) {
      for (final String asset in assets) {
        expect(
          File('${project.path}/$asset').existsSync(),
          isTrue,
          reason: '$asset was declared but never copied',
        );
      }
    }
  });

  test('only the two shipped faces are declared', () {
    final List<Object?> declared = _declaredFonts(pubspec());
    expect(declared.map((Object? e) => (e! as YamlMap)['family']), <String>[
      'InterLocal',
      'GeistMono',
    ]);
  });

  test('installed typography carries no package prefix', () {
    // `TextStyle(package: …)` prefixes the family with `packages/<name>/`, so
    // a surviving package name resolves every face into a bundle the consumer
    // does not have.
    expect(typography(), contains('static const String? package = null;'));
    expect(typography(), contains('package: Fonts.package'));
    expect(typography(), isNot(contains('elattar_design_system')));
  });

  test('no installed Dart source mentions the package it came from', () {
    final List<String> offenders = <String>[
      for (final FileSystemEntity entity in Directory(
        '${project.path}/lib',
      ).listSync(recursive: true))
        if (entity is File &&
            entity.path.endsWith('.dart') &&
            entity.readAsStringSync().contains('elattar_design_system'))
          entity.path,
    ];
    expect(offenders, isEmpty);
  });

  test('a font entry without a family cannot be constructed', () {
    // A compile-time guarantee rather than a runtime one: `InstallFont.family`
    // is required, so no expression installs a font whose family is guessed
    // from its file name.
    const InstallFont font = InstallFont(
      source: 'assets/fonts/InterVariable.ttf',
      target: '@foundation/fonts/InterVariable.ttf',
      family: 'InterLocal',
    );
    expect(font.family, 'InterLocal');
    expect(font.family, isNot(font.target.split('/').last.split('.').first));
  });
}
