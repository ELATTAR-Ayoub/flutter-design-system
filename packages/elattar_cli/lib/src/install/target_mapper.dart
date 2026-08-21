import 'dart:io';

class LogicalTargetMapper {
  const LogicalTargetMapper();

  String destination(String projectRoot, String logicalTarget) {
    final String relative = logicalTarget.replaceAll('\\', '/');
    if (relative.startsWith('@ui/')) {
      return _join(projectRoot, 'lib/components/ui/${relative.substring(4)}');
    }
    if (relative.startsWith('@foundation/')) {
      if (relative.startsWith('@foundation/fonts/')) {
        const String prefix = '@foundation/fonts/';
        return _join(
          projectRoot,
          'assets/elattar/fonts/${relative.substring(prefix.length)}',
        );
      }
      return _join(
        projectRoot,
        'lib/design_system/foundation/${relative.substring(12)}',
      );
    }
    if (relative.startsWith('@effects/')) {
      return _join(
        projectRoot,
        'lib/design_system/effects/${relative.substring(9)}',
      );
    }
    if (relative.startsWith('@motion/')) {
      return _join(
        projectRoot,
        'lib/design_system/motion/${relative.substring(8)}',
      );
    }
    throw ArgumentError.value(
      logicalTarget,
      'logicalTarget',
      'Unknown logical target prefix.',
    );
  }

  String relativeImport(String fromFile, String toFile) {
    final List<String> from = _segments(File(fromFile).parent.path);
    final List<String> to = _segments(toFile);
    while (from.isNotEmpty && to.isNotEmpty && from.first == to.first) {
      from.removeAt(0);
      to.removeAt(0);
    }
    final String value = <String>[
      ...List<String>.filled(from.length, '..'),
      ...to,
    ].join('/');
    return value.startsWith('.') ? value : './$value';
  }

  static String _join(String root, String child) =>
      '${root.replaceAll(RegExp(r'[\\/]+$'), '')}${Platform.pathSeparator}$child';

  static List<String> _segments(String value) => value
      .replaceAll('\\', '/')
      .split('/')
      .where((String part) => part.isNotEmpty)
      .toList();
}
