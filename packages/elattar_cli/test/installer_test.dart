import 'dart:io';

import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import '../lib/src/install/import_transformer.dart';
import '../lib/src/install/installer.dart';
import '../lib/src/install/models.dart';
import '../lib/src/install/target_mapper.dart';

void main() {
  test('logical targets map to stable consumer destinations', () {
    final String root = Directory.systemTemp.path;
    const LogicalTargetMapper mapper = LogicalTargetMapper();
    expect(
      mapper.destination(root, '@ui/button.dart'),
      contains('lib/components/ui'),
    );
    expect(
      mapper.destination(root, '@foundation/colors.dart'),
      contains('lib/design_system/foundation'),
    );
    expect(
      mapper.destination(root, '@ui/surface.dart'),
      contains('lib/components/ui'),
    );
    expect(
      mapper.destination(root, '@ui/press.dart'),
      contains('lib/components/ui'),
    );
    expect(
      mapper.destination(root, '@assets/textures/perlin-noise.png'),
      contains('assets/ui'),
    );
    expect(
      mapper.destination(root, '@shaders/orb.frag').replaceAll('\\', '/'),
      endsWith('shaders/ui/orb.frag'),
    );
    expect(
      mapper
          .destination(root, '@block/console/console.dart')
          .replaceAll('\\', '/'),
      endsWith('lib/blocks/console/console.dart'),
    );
  });

  test('unknown logical prefixes are still rejected', () {
    const LogicalTargetMapper mapper = LogicalTargetMapper();
    expect(
      () => mapper.destination(Directory.systemTemp.path, '@nope/x.dart'),
      throwsArgumentError,
    );
  });

  test('shot umbrella package import fans out to the generated barrels', () {
    final DartImportTransformer transformer = DartImportTransformer();
    const String source =
        "import 'package:flutter/widgets.dart';\n"
        "import 'package:elattar_design_system/elattar_design_system.dart';\n";
    final String result = transformer.transform(
      sourcePath: 'repo/lib/src/blocks/console/console_shot.dart',
      targetPath: 'consumer/lib/blocks/console/console_shot.dart',
      projectRoot: 'consumer',
      content: source,
    );
    expect(result, isNot(contains('package:elattar_design_system')));
    expect(
      result,
      contains(
        "// ignore: unused_import\nimport '../../components/ui/ui.dart';\n"
        "// ignore: unused_import\nimport '../../design_system/foundation.dart';",
      ),
    );
    // Unrelated package imports are untouched.
    expect(result, contains("import 'package:flutter/widgets.dart';"));
  });

  test('barrel imports are relative to the shot install depth', () {
    final DartImportTransformer transformer = DartImportTransformer();
    const String source =
        "import 'package:elattar_design_system/elattar_design_system.dart';\n";
    final String shallow = transformer.transform(
      sourcePath: 'repo/lib/src/blocks/minimal_shot.dart',
      targetPath: 'consumer/lib/blocks/minimal_shot.dart',
      projectRoot: 'consumer',
      content: source,
    );
    expect(shallow, contains("import '../components/ui/ui.dart';"));
    expect(shallow, contains("import '../design_system/foundation.dart'"));

    final String deep = transformer.transform(
      sourcePath: 'repo/lib/src/blocks/a/b/deep_shot.dart',
      targetPath: 'consumer/lib/blocks/a/b/deep_shot.dart',
      projectRoot: 'consumer',
      content: source,
    );
    expect(deep, contains("import '../../../components/ui/ui.dart';"));
    expect(deep, contains("import '../../../design_system/foundation.dart'"));
  });

  test('direct package library imports map onto their logical targets', () {
    final DartImportTransformer transformer = DartImportTransformer();
    const String source =
        "import 'package:elattar_design_system/src/components/ui/button.dart' as UI;\n"
        "import 'package:elattar_design_system/src/design_system/foundation/colors.dart' as UI;\n";
    final String result = transformer.transform(
      sourcePath: 'repo/lib/src/blocks/console/console_shot.dart',
      targetPath: 'consumer/lib/blocks/console/console_shot.dart',
      projectRoot: 'consumer',
      content: source,
    );
    expect(result, contains("import '../../components/ui/button.dart'"));
    expect(
      result,
      contains("import '../../design_system/foundation/colors.dart'"),
    );
  });

  // A combinator or prefix on the umbrella import lands on whichever directive
  // the fan-out emits LAST, so `show Button` would attach to the foundation
  // barrel and Button would not resolve. All three forms must be refused,
  // not just `as`.
  for (final ({String label, String trailing}) form
      in <({String label, String trailing})>[
        (label: 'a prefix', trailing: ' as space'),
        (label: 'a show combinator', trailing: ' show Button'),
        (label: 'a hide combinator', trailing: ' hide Button'),
        (label: 'a prefix and a combinator', trailing: ' as space show Button'),
      ]) {
    test('an umbrella import with ${form.label} is refused, not mangled', () {
      final DartImportTransformer transformer = DartImportTransformer();
      expect(
        () => transformer.transform(
          sourcePath: 'repo/lib/src/blocks/console/console_shot.dart',
          targetPath: 'consumer/lib/blocks/console/console_shot.dart',
          projectRoot: 'consumer',
          content:
              "import 'package:elattar_design_system/elattar_design_system.dart' as UI"
              '${form.trailing};\n',
        ),
        throwsA(
          isA<StateError>().having(
            (StateError error) => error.message,
            'message',
            allOf(contains('cannot be split'), contains(form.trailing.trim())),
          ),
        ),
      );
    });
  }

  test('an umbrella export fans out to the generated barrels', () {
    final DartImportTransformer transformer = DartImportTransformer();
    final String result = transformer.transform(
      sourcePath: 'repo/lib/src/blocks/api.dart',
      targetPath: 'consumer/lib/blocks/api.dart',
      projectRoot: 'consumer',
      content:
          "export 'package:elattar_design_system/elattar_design_system.dart';\n",
    );
    // An export fan-out carries no `// ignore: unused_import`: the lint does
    // not apply to exports.
    expect(
      result,
      "export '../components/ui/ui.dart';\n"
      "export '../design_system/foundation.dart';\n",
    );
  });

  // ── only genuine top-level directives are rewritten ──────────────────────
  //
  // Shots are documentation-shaped code: they carry doc comments that show
  // usage, and string literals that quote snippets. A rewrite that matched the
  // word `import` anywhere would fan the umbrella barrel out into the middle of
  // a class body ("Directives must appear before any declarations") or into the
  // middle of a string literal, and a commented-out `as space` import would abort
  // the whole install.

  test('an import inside a doc comment is not a directive', () {
    final DartImportTransformer transformer = DartImportTransformer();
    const String source =
        "import 'package:elattar_design_system/elattar_design_system.dart';\n"
        '\n'
        'class ConsoleShot extends StatelessWidget {\n'
        '  /// Wire this up with:\n'
        "  /// import 'package:elattar_design_system/elattar_design_system.dart';\n"
        '  const ConsoleShot();\n'
        '}\n';
    final String result = transformer.transform(
      sourcePath: 'repo/lib/src/blocks/console/console_shot.dart',
      targetPath: 'consumer/lib/blocks/console/console_shot.dart',
      projectRoot: 'consumer',
      content: source,
    );
    // The real directive was rewritten...
    expect(result, contains("import '../../components/ui/ui.dart';"));
    // ...exactly once, and the doc comment came through byte for byte.
    expect(
      "import '../../components/ui/ui.dart';".allMatches(result).length,
      1,
    );
    expect(
      result,
      contains(
        "  /// import 'package:elattar_design_system/elattar_design_system.dart';\n"
        '  const ConsoleShot();',
      ),
    );
    // No directive was injected after the class declaration opened.
    expect(
      result.indexOf('class ConsoleShot'),
      greaterThan(result.lastIndexOf("import '../../design_system")),
    );
  });

  test('an import inside a line comment in the prologue is not rewritten', () {
    final DartImportTransformer transformer = DartImportTransformer();
    const String source =
        "import 'package:flutter/widgets.dart';\n"
        "// import 'package:elattar_design_system/elattar_design_system.dart';\n"
        '\n'
        'class Foo {}\n';
    expect(
      transformer.transform(
        sourcePath: 'repo/lib/src/blocks/console/console_shot.dart',
        targetPath: 'consumer/lib/blocks/console/console_shot.dart',
        projectRoot: 'consumer',
        content: source,
      ),
      source,
    );
  });

  test('an import inside a string literal is not rewritten', () {
    final DartImportTransformer transformer = DartImportTransformer();
    const String source =
        "import 'package:flutter/widgets.dart';\n"
        '\n'
        'const String snippet =\n'
        '    \'import "package:elattar_design_system/elattar_design_system.dart";\';\n';
    expect(
      transformer.transform(
        sourcePath: 'repo/lib/src/blocks/console/console_shot.dart',
        targetPath: 'consumer/lib/blocks/console/console_shot.dart',
        projectRoot: 'consumer',
        content: source,
      ),
      source,
    );
  });

  test('an import inside a raw string is not rewritten', () {
    final DartImportTransformer transformer = DartImportTransformer();
    const String source =
        "import 'package:flutter/widgets.dart';\n"
        '\n'
        "const String snippet = r'''\n"
        "import 'package:elattar_design_system/elattar_design_system.dart';\n"
        "''';\n";
    expect(
      transformer.transform(
        sourcePath: 'repo/lib/src/blocks/console/console_shot.dart',
        targetPath: 'consumer/lib/blocks/console/console_shot.dart',
        projectRoot: 'consumer',
        content: source,
      ),
      source,
    );
  });

  test('a commented-out umbrella import with a prefix does not throw', () {
    final DartImportTransformer transformer = DartImportTransformer();
    const String source =
        "// import 'package:elattar_design_system/elattar_design_system.dart' as space;\n"
        '/*\n'
        "import 'package:elattar_design_system/elattar_design_system.dart' as UI show Button;\n"
        '*/\n'
        "import 'package:flutter/widgets.dart';\n";
    late String result;
    expect(
      () => result = transformer.transform(
        sourcePath: 'repo/lib/src/blocks/console/console_shot.dart',
        targetPath: 'consumer/lib/blocks/console/console_shot.dart',
        projectRoot: 'consumer',
        content: source,
      ),
      returnsNormally,
    );
    expect(result, source);
  });

  // ── the project root is supplied, never guessed from the target ──────────

  test('a consumer root containing a lib directory resolves correctly', () {
    final DartImportTransformer transformer = DartImportTransformer();
    final String result = transformer.transform(
      sourcePath: 'repo/lib/src/blocks/console/console_shot.dart',
      targetPath: 'C:/dev/lib/myapp/lib/blocks/console/console_shot.dart',
      projectRoot: 'C:/dev/lib/myapp',
      content:
          "import 'package:elattar_design_system/elattar_design_system.dart';\n",
    );
    expect(result, contains("import '../../components/ui/ui.dart';"));
    expect(result, contains("import '../../design_system/foundation.dart';"));
    // Splitting the target on '/lib/' would climb out of the project.
    expect(result, isNot(contains('../../../')));
  });

  test('a target outside lib/ resolves against the project root', () {
    final DartImportTransformer transformer = DartImportTransformer();
    final String result = transformer.transform(
      sourcePath: 'repo/lib/src/blocks/console_shot.dart',
      targetPath: 'consumer/console_shot.dart',
      projectRoot: 'consumer',
      content:
          "import 'package:elattar_design_system/elattar_design_system.dart';\n",
    );
    expect(result, contains("import './lib/components/ui/ui.dart';"));
    expect(result, contains("import './lib/design_system/foundation.dart';"));
  });

  test('relative imports resolve from source layout to copied layout', () {
    final DartImportTransformer transformer = DartImportTransformer();
    const String source =
        "import '../../design_system/foundation/theme.dart';\nimport 'spinner.dart';\n";
    final String result = transformer.transform(
      sourcePath: 'repo/lib/src/components/ui/button.dart',
      targetPath: 'consumer/lib/components/ui/button.dart',
      projectRoot: 'consumer',
      content: source,
    );
    expect(
      result,
      contains("import '../../design_system/foundation/theme.dart'"),
    );
    expect(result, contains("import './spinner.dart'"));
  });

  test(
    'scheme-less package-relative imports are rewritten from foundation files',
    () {
      final DartImportTransformer transformer = DartImportTransformer();
      const String source =
          "import './theme.dart';\nimport './typography.dart';\n";
      final String result = transformer.transform(
        sourcePath: 'repo/lib/src/theme_scope.dart',
        targetPath: 'consumer/lib/design_system/foundation/theme_scope.dart',
        projectRoot: 'consumer',
        content: source,
      );
      expect(result, contains("import './theme.dart'"));
      expect(result, contains("import './typography.dart'"));
    },
  );

  test('installer plans without writing and reports conflicts', () {
    final Directory root = Directory.systemTemp.createTempSync(
      'elattar-installer-',
    );
    addTearDown(() => root.deleteSync(recursive: true));
    final Directory repository = Directory.current.parent.parent;
    final InstallItem item = InstallItem(
      name: 'card',
      version: '0.0.1',
      files: const <InstallFile>[
        InstallFile(
          source: 'lib/src/components/ui/card.dart',
          target: '@ui/card.dart',
        ),
      ],
    );
    final Installer installer = Installer();
    final InstallPlan first = installer.plan(
      projectRoot: root,
      repositoryRoot: repository,
      items: <InstallItem>[item],
    );
    expect(first.canApply, isTrue);
    expect(
      File(
        '${root.path}${Platform.pathSeparator}lib/components/ui/card.dart',
      ).existsSync(),
      isFalse,
    );
    installer.apply(first);
    final InstallPlan second = installer.plan(
      projectRoot: root,
      repositoryRoot: repository,
      items: <InstallItem>[item],
    );
    expect(second.conflicts, isEmpty);
    File(
      '${root.path}${Platform.pathSeparator}lib/components/ui/card.dart',
    ).writeAsStringSync('custom');
    final InstallPlan conflict = installer.plan(
      projectRoot: root,
      repositoryRoot: repository,
      items: <InstallItem>[item],
    );
    expect(conflict.canApply, isFalse);
    expect(conflict.conflicts.single.destination, contains('card.dart'));
  });

  test('pubspec merge preserves unrelated Flutter configuration', () {
    final Directory root = Directory.systemTemp.createTempSync(
      'elattar-pubspec-',
    );
    addTearDown(() => root.deleteSync(recursive: true));
    final Directory repository = Directory.current.parent.parent;
    final File pubspec =
        File('${root.path}${Platform.pathSeparator}pubspec.yaml')
          ..parent.createSync(recursive: true)
          ..writeAsStringSync('''name: fixture
description: Keep this text.
environment:
  sdk: ^3.12.2
flutter:
  uses-material-design: true
''');
    final InstallPlan plan = Installer().plan(
      projectRoot: root,
      repositoryRoot: repository,
      items: const <InstallItem>[
        InstallItem(
          name: 'button',
          version: '0.0.1',
          files: <InstallFile>[],
          pubDependencies: <String, String>{'example_dependency': '^1.0.0'},
        ),
      ],
    );
    expect(plan.canApply, isTrue);
    expect(plan.pubspec, contains('description: Keep this text.'));
    expect(plan.pubspec, contains('uses-material-design: true'));
    expect(plan.pubspec, contains('example_dependency: ^1.0.0'));
    Installer().apply(plan);
    expect(
      pubspec.readAsStringSync(),
      contains('description: Keep this text.'),
    );
    expect(pubspec.readAsStringSync(), contains('example_dependency: ^1.0.0'));
  });

  test('pubspec merge with fonts stays valid YAML', () {
    final Directory root = Directory.systemTemp.createTempSync(
      'elattar-pubspec-fonts-',
    );
    addTearDown(() => root.deleteSync(recursive: true));
    final Directory repository = Directory.current.parent.parent;
    final File pubspec =
        File('${root.path}${Platform.pathSeparator}pubspec.yaml')
          ..parent.createSync(recursive: true)
          ..writeAsStringSync('''name: fixture
description: Font merge.
environment:
  sdk: ^3.12.2
dependencies:
  flutter:
    sdk: flutter
flutter:
''');
    final InstallPlan plan = Installer().plan(
      projectRoot: root,
      repositoryRoot: repository,
      items: const <InstallItem>[
        InstallItem(
          name: 'source-foundation',
          version: '0.0.1',
          files: <InstallFile>[],
          fonts: <InstallFont>[
            InstallFont(
              source: 'assets/fonts/InterVariable.ttf',
              target: '@foundation/fonts/InterVariable.ttf',
              family: 'InterLocal',
            ),
            InstallFont(
              source: 'assets/fonts/GeistMono-Variable.ttf',
              target: '@foundation/fonts/GeistMono-Variable.ttf',
              family: 'GeistMono',
            ),
          ],
        ),
      ],
    );
    expect(plan.canApply, isTrue);
    expect(() => loadYaml(plan.pubspec), returnsNormally);
    Installer().apply(plan);
    expect(() => loadYaml(pubspec.readAsStringSync()), returnsNormally);
  });

  test('pubspec merge adds shaders and assets at root-relative paths', () {
    final Directory root = Directory.systemTemp.createTempSync(
      'elattar-pubspec-shaders-',
    );
    addTearDown(() => root.deleteSync(recursive: true));
    final Directory repository = Directory.current.parent.parent;
    final File pubspec =
        File('${root.path}${Platform.pathSeparator}pubspec.yaml')
          ..parent.createSync(recursive: true)
          ..writeAsStringSync('''name: fixture
description: Shader merge.
environment:
  sdk: ^3.12.2
dependencies:
  flutter:
    sdk: flutter
flutter:
''');
    final InstallPlan plan = Installer().plan(
      projectRoot: root,
      repositoryRoot: repository,
      items: const <InstallItem>[
        InstallItem(
          name: 'voice-indicator',
          version: '0.0.1',
          files: <InstallFile>[],
          assets: <InstallResource>[
            InstallResource(
              source: 'assets/textures/perlin-noise.png',
              target: '@assets/textures/perlin-noise.png',
            ),
          ],
          shaders: <InstallResource>[
            InstallResource(
              source: 'shaders/orb.frag',
              target: '@shaders/orb.frag',
            ),
          ],
        ),
      ],
    );
    expect(plan.canApply, isTrue);
    expect(plan.pubspec, contains('assets/ui/textures/perlin-noise.png'));
    expect(plan.pubspec, contains('shaders/ui/orb.frag'));
    expect(() => loadYaml(plan.pubspec), returnsNormally);
    Installer().apply(plan);
    expect(() => loadYaml(pubspec.readAsStringSync()), returnsNormally);
  });

  test('generated empty barrel is updated when a component is added', () {
    final Directory root = Directory.systemTemp.createTempSync(
      'elattar-barrel-',
    );
    addTearDown(() => root.deleteSync(recursive: true));
    final Directory repository = Directory.current.parent.parent;
    final Directory ui = Directory(
      '${root.path}${Platform.pathSeparator}lib/components/ui',
    )..createSync(recursive: true);
    File('${ui.path}${Platform.pathSeparator}ui.dart').writeAsStringSync('');
    final InstallPlan plan = Installer().plan(
      projectRoot: root,
      repositoryRoot: repository,
      items: const <InstallItem>[
        InstallItem(
          name: 'card',
          version: '0.0.1',
          files: <InstallFile>[
            InstallFile(
              source: 'lib/src/components/ui/card.dart',
              target: '@ui/card.dart',
            ),
          ],
        ),
      ],
    );
    expect(plan.canApply, isTrue);
    Installer().apply(plan);
    expect(
      File('${ui.path}${Platform.pathSeparator}ui.dart').readAsStringSync(),
      contains("export 'card.dart';"),
    );
  });

  test(
    'installer rewrites against the real project root, not a path guess',
    () {
      final Directory temp = Directory.systemTemp.createTempSync(
        'elattar-libroot-',
      );
      addTearDown(() => temp.deleteSync(recursive: true));
      // A consumer project that itself lives under a directory named `lib`.
      // Deriving the root by splitting the destination on '/lib/' climbs out of
      // the project and emits imports that point above it.
      final Directory root = Directory(
        '${temp.path}${Platform.pathSeparator}lib'
        '${Platform.pathSeparator}myapp',
      )..createSync(recursive: true);
      final Directory repository = Directory.current.parent.parent;
      final InstallPlan plan = Installer().plan(
        projectRoot: root,
        repositoryRoot: repository,
        items: const <InstallItem>[
          InstallItem(
            name: 'card',
            version: '0.0.1',
            files: <InstallFile>[
              InstallFile(
                source: 'lib/src/components/ui/card.dart',
                target: '@ui/card.dart',
              ),
            ],
          ),
        ],
      );
      expect(plan.canApply, isTrue);
      final InstallOperation card = plan.operations.firstWhere(
        (InstallOperation operation) =>
            operation.source == 'lib/src/components/ui/card.dart',
      );
      final String content = card.content.toString();
      expect(
        content,
        contains("import '../../design_system/foundation/shadows.dart';"),
      );
      expect(content, isNot(contains('../../../')));
    },
  );
}
