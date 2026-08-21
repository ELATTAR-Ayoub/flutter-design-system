import 'dart:io';

import 'import_transformer.dart';
import 'models.dart';
import 'pubspec_editor.dart';
import 'target_mapper.dart';

class Installer {
  Installer({
    LogicalTargetMapper? mapper,
    DartImportTransformer? transformer,
    PubspecEditor? pubspecEditor,
  }) : mapper = mapper ?? const LogicalTargetMapper(),
       transformer =
           transformer ??
           DartImportTransformer(mapper: mapper ?? const LogicalTargetMapper()),
       pubspecEditor = pubspecEditor ?? const PubspecEditor();

  final LogicalTargetMapper mapper;
  final DartImportTransformer transformer;
  final PubspecEditor pubspecEditor;

  InstallPlan plan({
    required Directory projectRoot,
    required Directory repositoryRoot,
    required List<InstallItem> items,
    bool overwrite = false,
  }) {
    final List<InstallOperation> operations = <InstallOperation>[];
    final List<InstallConflict> conflicts = <InstallConflict>[];
    final Set<String> uiFiles = <String>{};
    final Set<String> foundationFiles = <String>{};
    final Map<String, String> pubDependencies = <String, String>{};
    final List<String> assets = <String>[];
    final List<({String family, String asset})> fonts =
        <({String family, String asset})>[];
    for (final InstallItem item in items) {
      pubDependencies.addAll(item.pubDependencies);
      for (final InstallFile file in item.files) {
        final String destination = mapper.destination(
          projectRoot.path,
          file.target,
        );
        final File source = File(_join(repositoryRoot.path, file.source));
        if (!source.existsSync())
          throw StateError('Missing registry source: ${file.source}');
        final String content = transformer.transform(
          sourcePath: source.path,
          targetPath: destination,
          content: source.readAsStringSync(),
        );
        _queue(
          operations,
          conflicts,
          destination,
          file.source,
          content,
          overwrite,
        );
        if (file.target.startsWith('@ui/')) uiFiles.add(destination);
        if (file.target.startsWith('@foundation/'))
          foundationFiles.add(destination);
      }
      for (final InstallResource resource in item.assets) {
        final String destination = mapper.destination(
          projectRoot.path,
          resource.target,
        );
        _queueResource(
          operations,
          conflicts,
          destination,
          resource.source,
          repositoryRoot,
          overwrite,
        );
        assets.add(_relative(projectRoot.path, destination));
      }
      for (final InstallResource resource in item.fonts) {
        final String destination = mapper.destination(
          projectRoot.path,
          resource.target,
        );
        _queueResource(
          operations,
          conflicts,
          destination,
          resource.source,
          repositoryRoot,
          overwrite,
        );
        fonts.add((
          family: resource.target.split('/').last.split('.').first,
          asset: _relative(projectRoot.path, destination),
        ));
      }
      for (final InstallResource resource in item.shaders) {
        _queueResource(
          operations,
          conflicts,
          mapper.destination(projectRoot.path, resource.target),
          resource.source,
          repositoryRoot,
          overwrite,
        );
      }
    }
    final String uiBarrel = _barrel(
      uiFiles,
      projectRoot.path,
      'lib/components/ui/',
    );
    final String foundationBarrel = _barrel(
      foundationFiles,
      projectRoot.path,
      'lib/design_system/',
    );
    _queueBarrel(
      operations,
      _join(projectRoot.path, 'lib/components/ui/ui.dart'),
      uiBarrel,
    );
    _queueBarrel(
      operations,
      _join(projectRoot.path, 'lib/design_system/foundation.dart'),
      foundationBarrel,
    );
    final String pubspecPath = _join(projectRoot.path, 'pubspec.yaml');
    final String currentPubspec = File(pubspecPath).existsSync()
        ? File(pubspecPath).readAsStringSync()
        : '';
    String pubspec = currentPubspec.isEmpty ? 'name: app\n' : currentPubspec;
    pubspec = pubspecEditor.addDependencies(pubspec, pubDependencies);
    pubspec = pubspecEditor.addAssets(pubspec, assets);
    pubspec = pubspecEditor.addFonts(pubspec, fonts);
    // pubspec.yaml is a structured merge target. Existing content is
    // preserved, so it does not participate in copied-source conflicts.
    if (pubspec != currentPubspec) {
      operations.add(
        InstallOperation(
          source: 'generated:pubspec.yaml',
          destination: pubspecPath,
          content: pubspec,
        ),
      );
    }
    return InstallPlan(
      operations: operations,
      conflicts: conflicts,
      pubspec: pubspec,
      uiBarrel: uiBarrel,
      foundationBarrel: foundationBarrel,
    );
  }

  void apply(InstallPlan plan) {
    if (!plan.canApply)
      throw StateError(
        'Install plan has conflicts; pass overwrite or resolve them first.',
      );
    for (final InstallOperation operation in plan.operations) {
      final File file = File(operation.destination);
      file.parent.createSync(recursive: true);
      final Object content = operation.content;
      if (content is List<int>) {
        file.writeAsBytesSync(content);
      } else {
        file.writeAsStringSync(content.toString());
      }
    }
  }

  void _queue(
    List<InstallOperation> operations,
    List<InstallConflict> conflicts,
    String destination,
    String source,
    Object content,
    bool overwrite,
  ) {
    final File file = File(destination);
    if (file.existsSync()) {
      final bool same = content is List<int>
          ? _bytesEqual(file.readAsBytesSync(), content)
          : file.readAsStringSync() == content.toString();
      if (same) return;
      if (!overwrite) {
        conflicts.add(
          InstallConflict(
            destination: destination,
            reason: 'Existing file differs from registry source.',
          ),
        );
        return;
      }
    }
    operations.add(
      InstallOperation(
        source: source,
        destination: destination,
        content: content,
      ),
    );
  }

  void _queueResource(
    List<InstallOperation> operations,
    List<InstallConflict> conflicts,
    String destination,
    String source,
    Directory root,
    bool overwrite,
  ) {
    final File file = File(_join(root.path, source));
    if (!file.existsSync())
      throw StateError('Missing registry resource: $source');
    _queue(
      operations,
      conflicts,
      destination,
      source,
      file.readAsBytesSync(),
      overwrite,
    );
  }

  void _queueBarrel(
    List<InstallOperation> operations,
    String destination,
    String generated,
  ) {
    final File file = File(destination);
    final String content = file.existsSync()
        ? _mergeBarrel(file.readAsStringSync(), generated)
        : generated;
    if (!file.existsSync() || file.readAsStringSync() != content) {
      operations.add(
        InstallOperation(
          source: 'generated:${file.uri.pathSegments.last}',
          destination: destination,
          content: content,
        ),
      );
    }
  }

  String _mergeBarrel(String existing, String generated) {
    final Set<String> exports = <String>{
      ..._exports(existing),
      ..._exports(generated),
    };
    final List<String> sorted = exports.toList()..sort();
    return sorted.map((String value) => "export '$value';").join('\n') +
        (sorted.isEmpty ? '' : '\n');
  }

  Iterable<String> _exports(String source) sync* {
    final RegExp pattern = RegExp(
      r'''^\s*export\s+['"]([^'"]+)['"]\s*;''',
      multiLine: true,
    );
    for (final RegExpMatch match in pattern.allMatches(source)) {
      yield match.group(1)!;
    }
  }

  String _barrel(Set<String> files, String root, String prefix) {
    final List<String> names =
        files
            .map((String value) => _relative(root, value))
            .where((String value) => value.startsWith(prefix))
            .map((String value) => value.substring(prefix.length))
            .where(
              (String value) =>
                  value.endsWith('.dart') &&
                  !value.endsWith('/ui.dart') &&
                  !value.endsWith('/foundation.dart'),
            )
            .toList()
          ..sort();
    return names.map((String name) => "export '$name';").join('\n') +
        (names.isEmpty ? '' : '\n');
  }

  static bool _bytesEqual(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int index = 0; index < a.length; index++) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }

  static String _relative(String root, String path) => path
      .replaceAll('\\', '/')
      .replaceFirst('${root.replaceAll('\\', '/')}/', '');
  static String _join(String root, String child) =>
      '${root.replaceAll(RegExp(r'[\\/]+$'), '')}${Platform.pathSeparator}$child';
}
