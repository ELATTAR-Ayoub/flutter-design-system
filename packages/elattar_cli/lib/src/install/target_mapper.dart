import 'dart:io';

/// Where each logical target lands in a consumer project, project-root
/// relative and POSIX-separated.
///
/// These are FIXED. They were once mirrored by a configurable `paths:` block
/// in `elattar.yaml` that nothing read, so a project could configure
/// `lib/vendor/elattar` and silently receive `lib/components/ui` anyway. The
/// keys are gone; these constants are the only statement of install location,
/// and `.elattar/manifest.json` is the per-project record of what landed
/// where.
const String uiDirectory = 'lib/components/ui';
const String foundationDirectory = 'lib/design_system/foundation';
const String effectsDirectory = 'lib/design_system/effects';
const String motionDirectory = 'lib/design_system/motion';
const String assetsDirectory = 'assets';
const String shadersDirectory = 'shaders';
const String fontsDirectory = 'assets/elattar/fonts';

/// Application compositions (shots) land in the consumer's own `lib/`, not
/// under the design-system folders: `@app/shots/x/y.dart` -> `lib/shots/x/y.dart`.
const String appDirectory = 'lib';

/// Third-party license notices, at the consumer's project root.
///
/// Not under `lib/` and not under `assets/`: a notice exists to be found by a
/// person reading the repository and by whatever scans the project for
/// licenses, and neither of those looks inside a widget tree or an app bundle.
/// The uppercase name is the convention every such scanner already knows.
///
/// `tool/registry_builder/lib/registry_validator.dart` holds the other half of
/// this pair — the `@license/` prefix in its allowlist — and
/// `test/license_distribution_test.dart` fails if the two drift.
const String licensesDirectory = 'LICENSES';

class LogicalTargetMapper {
  const LogicalTargetMapper();

  String destination(String projectRoot, String logicalTarget) {
    final String relative = logicalTarget.replaceAll('\\', '/');
    if (relative.startsWith('@ui/')) {
      return _join(projectRoot, '$uiDirectory/${relative.substring(4)}');
    }
    if (relative.startsWith('@foundation/')) {
      if (relative.startsWith('@foundation/fonts/')) {
        const String prefix = '@foundation/fonts/';
        return _join(
          projectRoot,
          '$fontsDirectory/${relative.substring(prefix.length)}',
        );
      }
      return _join(
        projectRoot,
        '$foundationDirectory/${relative.substring(12)}',
      );
    }
    if (relative.startsWith('@effects/')) {
      return _join(projectRoot, '$effectsDirectory/${relative.substring(9)}');
    }
    if (relative.startsWith('@motion/')) {
      return _join(projectRoot, '$motionDirectory/${relative.substring(8)}');
    }
    if (relative.startsWith('@assets/')) {
      return _join(projectRoot, '$assetsDirectory/${relative.substring(8)}');
    }
    if (relative.startsWith('@shaders/')) {
      return _join(projectRoot, '$shadersDirectory/${relative.substring(9)}');
    }
    if (relative.startsWith('@app/')) {
      return _join(projectRoot, '$appDirectory/${relative.substring(5)}');
    }
    if (relative.startsWith('@license/')) {
      return _join(projectRoot, '$licensesDirectory/${relative.substring(9)}');
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
