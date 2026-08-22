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
      mapper.destination(root, '@effects/machine_surface.dart'),
      contains('lib/design_system/effects'),
    );
    expect(
      mapper.destination(root, '@motion/press.dart'),
      contains('lib/design_system/motion'),
    );
    expect(
      mapper
          .destination(root, '@app/shots/console/console_shot.dart')
          .replaceAll('\\', '/'),
      endsWith('lib/shots/console/console_shot.dart'),
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
      sourcePath: 'repo/lib/shots/console/console_shot.dart',
      targetPath: 'consumer/lib/shots/console/console_shot.dart',
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
      sourcePath: 'repo/lib/shots/minimal_shot.dart',
      targetPath: 'consumer/lib/shots/minimal_shot.dart',
      content: source,
    );
    expect(shallow, contains("import '../components/ui/ui.dart';"));
    expect(shallow, contains("import '../design_system/foundation.dart'"));

    final String deep = transformer.transform(
      sourcePath: 'repo/lib/shots/a/b/deep_shot.dart',
      targetPath: 'consumer/lib/shots/a/b/deep_shot.dart',
      content: source,
    );
    expect(deep, contains("import '../../../components/ui/ui.dart';"));
    expect(deep, contains("import '../../../design_system/foundation.dart'"));
  });

  test('direct package library imports map onto their logical targets', () {
    final DartImportTransformer transformer = DartImportTransformer();
    const String source =
        "import 'package:elattar_design_system/src/components/button.dart';\n"
        "import 'package:elattar_design_system/src/foundation/colors.dart';\n";
    final String result = transformer.transform(
      sourcePath: 'repo/lib/shots/console/console_shot.dart',
      targetPath: 'consumer/lib/shots/console/console_shot.dart',
      content: source,
    );
    expect(result, contains("import '../../components/ui/button.dart'"));
    expect(
      result,
      contains("import '../../design_system/foundation/colors.dart'"),
    );
  });

  test('an umbrella import that cannot be split is refused, not mangled', () {
    final DartImportTransformer transformer = DartImportTransformer();
    expect(
      () => transformer.transform(
        sourcePath: 'repo/lib/shots/console/console_shot.dart',
        targetPath: 'consumer/lib/shots/console/console_shot.dart',
        content:
            "import 'package:elattar_design_system/elattar_design_system.dart' as ds;\n",
      ),
      throwsA(
        isA<StateError>().having(
          (StateError error) => error.message,
          'message',
          contains('cannot be split'),
        ),
      ),
    );
  });

  test('relative imports resolve from source layout to copied layout', () {
    final DartImportTransformer transformer = DartImportTransformer();
    const String source =
        "import '../foundation/theme.dart';\nimport 'spinner.dart';\n";
    final String result = transformer.transform(
      sourcePath: 'repo/lib/src/components/button.dart',
      targetPath: 'consumer/lib/components/ui/button.dart',
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
          "import 'foundation/theme.dart';\nimport 'foundation/typography.dart';\n";
      final String result = transformer.transform(
        sourcePath: 'repo/lib/src/theme_scope.dart',
        targetPath: 'consumer/lib/design_system/foundation/theme_scope.dart',
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
          source: 'lib/src/components/card.dart',
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
          fonts: <InstallResource>[
            InstallResource(
              source: 'assets/fonts/InterVariable.ttf',
              target: '@foundation/fonts/InterVariable.ttf',
            ),
            InstallResource(
              source: 'assets/fonts/GeistMono-Variable.ttf',
              target: '@foundation/fonts/GeistMono-Variable.ttf',
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
              source: 'lib/src/components/card.dart',
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
}
