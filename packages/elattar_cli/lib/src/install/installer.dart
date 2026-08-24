import 'dart:convert';
import 'dart:io';

import 'import_transformer.dart';
import 'models.dart';
import 'pubspec_editor.dart';
import 'source_rewrites.dart';
import 'target_mapper.dart';

class Installer {
  Installer({
    LogicalTargetMapper? mapper,
    DartImportTransformer? transformer,
    PubspecEditor? pubspecEditor,
    SourceRewriter? sourceRewriter,
  }) : mapper = mapper ?? const LogicalTargetMapper(),
       transformer =
           transformer ??
           DartImportTransformer(mapper: mapper ?? const LogicalTargetMapper()),
       pubspecEditor = pubspecEditor ?? const PubspecEditor(),
       sourceRewriter = sourceRewriter ?? const SourceRewriter();

  final LogicalTargetMapper mapper;
  final DartImportTransformer transformer;
  final PubspecEditor pubspecEditor;
  final SourceRewriter sourceRewriter;

  InstallPlan plan({
    required Directory projectRoot,
    required Directory repositoryRoot,
    required List<InstallItem> items,
    bool overwrite = false,
    Map<String, String> textNotices = const <String, String>{},
    InstallPayloads payloads = const InstallPayloads.empty(),
  }) {
    final List<InstallOperation> operations = <InstallOperation>[];
    final List<InstallConflict> conflicts = <InstallConflict>[];
    final Set<String> uiFiles = <String>{};
    final Set<String> foundationFiles = <String>{};
    final Map<String, String> pubDependencies = <String, String>{};
    final List<String> assets = <String>[];
    final List<String> shaders = <String>[];
    final List<FontRegistration> fonts = <FontRegistration>[];
    for (final InstallItem item in items) {
      pubDependencies.addAll(item.pubDependencies);
      for (final InstallFile file in item.files) {
        final String destination = mapper.destination(
          projectRoot.path,
          file.target,
        );
        final String content = sourceRewriter.rewrite(
          target: file.target,
          content: transformer.transform(
            // The *source* path, not the payload's location on disk. It is
            // read only to work out relative imports, and a payload staged
            // under `versions/<item>/<version>/logical/...` would compute the
            // wrong ones.
            sourcePath: _join(repositoryRoot.path, file.source),
            targetPath: destination,
            projectRoot: projectRoot.path,
            content: _readText(
              payloads,
              item,
              file.source,
              file.target,
              repositoryRoot,
            ),
          ),
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
          payloads: payloads,
          item: item,
          target: resource.target,
        );
        assets.add(_relative(projectRoot.path, destination));
      }
      for (final InstallFont resource in item.fonts) {
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
          payloads: payloads,
          item: item,
          target: resource.target,
        );
        // The family comes from the registry entry, never from the file name:
        // `InterVariable.ttf` registers as `InterLocal`, and the installed
        // typography asks for `InterLocal`.
        fonts.add(
          FontRegistration(
            family: resource.family,
            asset: _relative(projectRoot.path, destination),
            style: resource.style,
          ),
        );
      }
      for (final InstallResource resource in item.shaders) {
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
          payloads: payloads,
          item: item,
          target: resource.target,
        );
        shaders.add(_relative(projectRoot.path, destination));
      }
      // Notices, copied byte for byte into `LICENSES/`.
      //
      // Three deliberate differences from every other resource above. They are
      // not added to `assets`, so they never enter the consumer's
      // `pubspec.yaml` or their app bundle — a license belongs in the
      // repository, not in the shipped binary. They do not pass through the
      // import transformer or the source rewriter, because a rewritten notice
      // is no longer the text the upstream project published. And nothing here
      // removes a notice: `_queue` only ever writes the destinations this plan
      // names, so a consumer's own `LICENSES/` entries survive `--overwrite`
      // untouched, and an identical re-install is a no-op rather than a
      // conflict.
      for (final InstallResource resource in item.licenses) {
        _queueResource(
          operations,
          conflicts,
          mapper.destination(projectRoot.path, resource.target),
          resource.source,
          repositoryRoot,
          overwrite,
          payloads: payloads,
          item: item,
          target: resource.target,
        );
      }
    }
    // Notices the CLI carries itself rather than reads from the registry —
    // today just Elattar's own MIT text, which `init` must write into every
    // project whether or not a registry is reachable. Keyed by logical target
    // so they land in `LICENSES/` through the same mapper as the registry's
    // notices, and queued through `_queue` so an identical re-run is a no-op.
    for (final MapEntry<String, String> notice in textNotices.entries) {
      _queue(
        operations,
        conflicts,
        mapper.destination(projectRoot.path, notice.key),
        'cli:${notice.key}',
        notice.value,
        overwrite,
      );
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
    pubspec = pubspecEditor.addShaders(pubspec, shaders);
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
    bool overwrite, {
    InstallPayloads payloads = const InstallPayloads.empty(),
    InstallItem? item,
    String? target,
  }) {
    _queue(
      operations,
      conflicts,
      destination,
      source,
      _readBytes(payloads, item, source, target, root),
      overwrite,
    );
  }

  /// The bytes to install: the registry's staged payload when one was
  /// fetched, otherwise the repository file.
  ///
  /// The payload is preferred because it is the artifact whose sha256 was
  /// verified, and because a CLI installed from pub.dev has no repository to
  /// fall back to. The fallback exists for the repository's own tests, which
  /// build items by hand against a source tree and never stage payloads.
  static List<int> _readBytes(
    InstallPayloads payloads,
    InstallItem? item,
    String source,
    String? target,
    Directory root,
  ) {
    if (item != null && target != null) {
      final List<int>? staged = payloads.bytesFor(item, target);
      if (staged != null) return staged;
    }
    final File file = File(_join(root.path, source));
    if (!file.existsSync())
      throw StateError('Missing registry resource: $source');
    return file.readAsBytesSync();
  }

  static String _readText(
    InstallPayloads payloads,
    InstallItem item,
    String source,
    String target,
    Directory root,
  ) {
    final List<int>? staged = payloads.bytesFor(item, target);
    if (staged != null) return utf8.decode(staged);
    final File file = File(_join(root.path, source));
    if (!file.existsSync())
      throw StateError('Missing registry source: $source');
    return file.readAsStringSync();
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
