import 'dart:io';

import 'target_mapper.dart';

/// The package whose umbrella barrel application sources (shots) import so that
/// they compile inside this repository. A consumer project has no dependency on
/// it, so on install the import is rewritten onto the barrels the installer
/// generates.
const String designSystemPackage = 'elattar_design_system';

/// Barrels emitted by `Installer.plan`, project-root relative and in the order
/// they are written into a rewritten source. Keep in sync with the
/// `_queueBarrel` calls in `installer.dart`.
const List<String> designSystemBarrels = <String>[
  'lib/components/ui/ui.dart',
  'lib/design_system/foundation.dart',
];

const String _packagePrefix = 'package:$designSystemPackage/';

class DartImportTransformer {
  DartImportTransformer({LogicalTargetMapper? mapper})
    : mapper = mapper ?? const LogicalTargetMapper();

  final LogicalTargetMapper mapper;

  String transform({
    required String sourcePath,
    required String targetPath,
    required String content,
  }) {
    final RegExp pattern = RegExp(r'''(import|export)\s+['"]([^'"]+)['"]''');
    return content.replaceAllMapped(pattern, (Match match) {
      final String directive = match.group(1)!;
      final String uri = match.group(2)!;
      if (uri.startsWith(_packagePrefix)) {
        return _rewriteDesignSystemPackage(
              directive: directive,
              uri: uri,
              targetPath: targetPath,
              trailing: _trailingBeforeSemicolon(content, match.end),
            ) ??
            match.group(0)!;
      }
      final bool hasScheme = RegExp(r'^[A-Za-z][A-Za-z0-9+.-]*:').hasMatch(uri);
      if (hasScheme) return match.group(0)!;
      final String sourceResolved = _normalise(
        '${File(sourcePath).parent.path}/$uri',
      );
      final String logical = _logicalTarget(sourceResolved);
      if (logical == sourceResolved) return match.group(0)!;
      final String destination = _destinationForLogical(targetPath, logical);
      final String rewritten = mapper.relativeImport(targetPath, destination);
      return '$directive \'$rewritten\'';
    });
  }

  /// Rewrites `package:elattar_design_system/...` onto consumer-local paths.
  ///
  /// Returns `null` when the URI has no counterpart in a consumer project, in
  /// which case the directive is left untouched.
  String? _rewriteDesignSystemPackage({
    required String directive,
    required String uri,
    required String targetPath,
    required String trailing,
  }) {
    final String path = uri.substring(_packagePrefix.length);
    if (path == '$designSystemPackage.dart') {
      // The umbrella barrel has no single counterpart: the installer emits one
      // barrel per family, so one directive fans out to several. That is only
      // sound for a plain directive — a prefix (`as ds`) or a combinator
      // (`show`/`hide`) cannot be distributed across barrels without silently
      // changing what resolves, so refuse rather than emit broken code.
      if (trailing.isNotEmpty) {
        throw StateError(
          'Cannot rewrite "$uri" for $targetPath: an umbrella directive with '
          '"$trailing" cannot be split across the generated barrels '
          '(${designSystemBarrels.join(', ')}). Import the umbrella barrel '
          'plainly, or import the specific library instead.',
        );
      }
      return <String>[
        for (final String barrel in designSystemBarrels)
          _barrelDirective(directive, targetPath, barrel),
        // The source's own `;` terminates the final directive.
      ].join(';\n');
    }
    if (path.startsWith('src/')) {
      final String? logical = _logicalForSourceSuffix(path.substring(4));
      if (logical == null) return null;
      final String destination = _destinationForLogical(targetPath, logical);
      return '$directive \'${mapper.relativeImport(targetPath, destination)}\'';
    }
    return null;
  }

  String _barrelDirective(
    String directive,
    String targetPath,
    String projectRelativeBarrel,
  ) {
    final String destination = _projectFile(targetPath, projectRelativeBarrel);
    final String line = '$directive \'${mapper.relativeImport(targetPath, destination)}\'';
    if (directive != 'import') return line;
    // One umbrella import fans out to every barrel, so a consumer project can
    // legitimately end up not using one of them. `unused_import` is an
    // analyzer warning that is on by default (and `flutter analyze` fails on
    // warnings), so suppress it per line rather than leaving consumers to
    // hand-prune generated code.
    return '// ignore: unused_import\n$line';
  }

  String _logicalTarget(String sourcePath) {
    final String normalized = sourcePath.replaceAll('\\', '/');
    final int marker = normalized.indexOf('/lib/src/');
    if (marker < 0) return sourcePath;
    return _logicalForSourceSuffix(normalized.substring(marker + 9)) ??
        sourcePath;
  }

  /// Maps a path relative to the package's `lib/src/` onto a logical target,
  /// or `null` when the path is not distributed through the registry.
  String? _logicalForSourceSuffix(String suffix) {
    if (suffix.startsWith('components/')) return '@ui/${suffix.substring(11)}';
    if (suffix.startsWith('foundation/')) {
      return '@foundation/${suffix.substring(11)}';
    }
    if (suffix.startsWith('effects/')) return '@effects/${suffix.substring(8)}';
    if (suffix.startsWith('motion/')) return '@motion/${suffix.substring(7)}';
    if (suffix == 'theme_scope.dart' || suffix == 'text_layout.dart') {
      return '@foundation/$suffix';
    }
    return null;
  }

  String _destinationForLogical(String currentTarget, String logical) {
    return mapper.destination(_projectRoot(currentTarget), logical);
  }

  String _projectFile(String currentTarget, String projectRelative) =>
      '${_projectRoot(currentTarget)}/$projectRelative';

  static String _projectRoot(String currentTarget) =>
      currentTarget.replaceAll('\\', '/').split('/lib/').first;

  static String _trailingBeforeSemicolon(String content, int start) {
    final int end = content.indexOf(';', start);
    return (end < 0 ? content.substring(start) : content.substring(start, end))
        .trim();
  }

  static String _normalise(String value) {
    final List<String> parts = <String>[];
    for (final String part in value.replaceAll('\\', '/').split('/')) {
      if (part.isEmpty || part == '.') continue;
      if (part == '..' && parts.isNotEmpty) {
        parts.removeLast();
      } else {
        parts.add(part);
      }
    }
    return parts.join('/');
  }
}
