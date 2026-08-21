import 'dart:io';

import 'target_mapper.dart';

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
      final String uri = match.group(2)!;
      final bool hasScheme = RegExp(r'^[A-Za-z][A-Za-z0-9+.-]*:').hasMatch(uri);
      if (hasScheme) return match.group(0)!;
      final String sourceResolved = _normalise(
        '${File(sourcePath).parent.path}/$uri',
      );
      final String logical = _logicalTarget(sourceResolved);
      if (logical == sourceResolved) return match.group(0)!;
      final String destination = _destinationForLogical(targetPath, logical);
      final String rewritten = mapper.relativeImport(targetPath, destination);
      return '${match.group(1)} \'$rewritten\'';
    });
  }

  String _logicalTarget(String sourcePath) {
    final String normalized = sourcePath.replaceAll('\\', '/');
    final int marker = normalized.indexOf('/lib/src/');
    if (marker < 0) return sourcePath;
    final String suffix = normalized.substring(marker + 9);
    if (suffix.startsWith('components/')) return '@ui/${suffix.substring(11)}';
    if (suffix.startsWith('foundation/'))
      return '@foundation/${suffix.substring(11)}';
    if (suffix.startsWith('effects/')) return '@effects/${suffix.substring(8)}';
    if (suffix.startsWith('motion/')) return '@motion/${suffix.substring(7)}';
    if (suffix == 'theme_scope.dart' || suffix == 'text_layout.dart')
      return '@foundation/$suffix';
    return sourcePath;
  }

  String _destinationForLogical(String currentTarget, String logical) {
    final String root = currentTarget
        .replaceAll('\\', '/')
        .split('/lib/')
        .first;
    return mapper.destination(root, logical);
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
