import 'dart:convert';
import 'dart:io';

const Map<String, String> _special = <String, String>{
  'ThemeData': 'ThemeTokens',
  'ThemeController': 'ThemeController',
  'ThemeMode': 'ColorMode',
  'ThemeKind': 'ResolvedColorMode',
  'Theme': 'ThemeScope',
  'Palette': 'Palette',
  'Oklab': 'OklabColor',
  'Widths': 'LayoutWidths',
  'Radii': 'Radii',
  'Blurs': 'Blurs',
  'Containers': 'Containers',
  'Breakpoints': 'Breakpoints',
  'MediaRatios': 'AspectRatios',
  'Fonts': 'Fonts',
  'TypeSpec': 'TextStyleToken',
  'TypeColor': 'TextColorRole',
  'ComponentType': 'ComponentTextStyles',
  'Type': 'TextStyles',
  'Text': 'StyledText',
  'ShadowLayer': 'ShadowLayer',
  'ShadowSpec': 'ShadowStyle',
  'Shadows': 'Shadows',
  'Durations': 'MotionDurations',
  'Curves': 'MotionCurves',
  'Transforms': 'MotionTransforms',
  'Steps': 'StepCurve',
  'KeyframeFill': 'KeyframeFill',
  'KeyframeStop': 'KeyframeStop',
  'Keyframes': 'Keyframes',
  'KeyframePlayer': 'KeyframePlayer',
  'LiftCard': 'InteractiveCard',
  'Lift': 'HoverBuilder',
  'SlidingPillGroup': 'ActiveIndicator',
  'SwapIn': 'ContentChange',
  'FoilValue': 'PremiumSurface',
  'SheenAction': 'ActionFeedback',
  'BloomCosmic': 'FeedbackSurface',
  'MachineSurface': 'Surface',
  'PageGlow': 'BackgroundEffect',
  'Starfield': 'AmbientPattern',
  'VoiceOrb': 'VoiceIndicator',
  'OrbState': 'VoiceIndicatorState',
  'MediaScrim': 'MediaScrim',
  'RuleTest': 'ValidationTest',
  'Rules': 'Validators',
  'Rule': 'ValidationRule',
  'NavUserAccount': 'UserMenuAccount',
  'NavUserItem': 'UserMenuItem',
  'NavUser': 'UserMenu',
  'CalendarSurface': 'CalendarPresentation',
  'PopoverOriginModel': 'PopoverAnchorMode',
  'MenuSurfaceKind': 'MenuSurfaceVariant',
  'ModalCompact': 'CompactDialogLayout',
  'ModalPortalState': 'OverlayPortalState',
  'ModalPortal': 'OverlayPortal',
  'JellyTransition': 'OpenTransition',
  'JellyReplay': 'StateChangeFeedback',
  'JellyIn': 'OpenMotion',
  'Jelly': 'StateChangeMotion',
  'AgentAttachmentStatusText': 'AgentStatusText',
  'CubeAvatar': 'AgentAvatar',
  'ButtonSurface': 'ButtonStyleRecipe',
  'FieldSurface': 'FieldSurfaceRecipe',
  'SelectionControl': 'SelectionControl',
  'HitArea': 'HitArea',
  'OrbProgram': 'VoiceIndicatorProgram',
  'SurfaceOpacity': 'SurfaceOpacity',
  'CalendarType': 'CalendarTextStyles',
  'PopIn': 'EntranceMotion',
  'SpringUp': 'SpringEntranceMotion',
  'Ratchet': 'DiscreteProgressMotion',
  'SignOnFrame': 'TextRevealFrame',
  'SignOn': 'TextRevealMotion',
  'Reveal': 'RevealMotion',
  'Shimmer': 'LoadingShimmerMotion',
  'PulseLive': 'LivePulseMotion',
  'Sweep': 'SweepMotion',
  'Travel': 'TravelMotion',
  'CheckDraw': 'CheckmarkDrawMotion',
  'DashDraw': 'DashDrawMotion',
  'DotPop': 'DotSelectionMotion',
  'SwapRoll': 'ContentSwapMotion',
  'elAnimationDuration': 'effectiveMotionDuration',
  'elHsl': 'hslColor',
};

void main(List<String> arguments) {
  if (arguments.length != 1 ||
      !const <String>{'--prepare', '--apply'}.contains(arguments.single)) {
    stderr.writeln(
      'usage: dart run tool/migration/apply_public_api_renames.dart '
      '--prepare|--apply',
    );
    exitCode = 64;
    return;
  }
  final Directory root = _repositoryRoot();
  final File mapFile = File(
    _join(root.path, 'tool/migration/public_api_renames.json'),
  );
  if (arguments.single == '--prepare') {
    final Map<String, int> tokens = _inventory(root);
    final List<Map<String, Object?>> rows = <Map<String, Object?>>[
      for (final MapEntry<String, int> entry in tokens.entries)
        <String, Object?>{
          'current': entry.key,
          'future': _future(entry.key),
          'occurrencesInLib': entry.value,
        },
    ]..sort((a, b) => '${a['current']}'.compareTo('${b['current']}'));
    _validate(rows);
    mapFile.parent.createSync(recursive: true);
    final String encoded = const JsonEncoder.withIndent('  ').convert(
      <String, Object?>{
        'schemaVersion': 1,
        'baseline': _git(root, const <String>[
          'rev-parse',
          '--short',
          'HEAD',
        ]).trim(),
        'renames': rows,
      },
    );
    mapFile.writeAsStringSync('$encoded\n');
    stdout.writeln('prepared ${rows.length} exact identifier renames');
    return;
  }

  final Map<String, Object?> document =
      jsonDecode(mapFile.readAsStringSync()) as Map<String, Object?>;
  final List<Map<String, Object?>> rows = <Map<String, Object?>>[
    for (final Object? row in document['renames']! as List<Object?>)
      row! as Map<String, Object?>,
  ];
  _validate(rows);
  final Map<String, String> renames = <String, String>{
    for (final Map<String, Object?> row in rows)
      row['current']! as String: row['future']! as String,
  };
  final int changed = _apply(root, renames);
  stdout.writeln('renamed ${renames.length} identifiers in $changed files');
}

Map<String, int> _inventory(Directory root) {
  final RegExp typeDeclaration = RegExp(
    r'\b(?:class|enum|mixin|typedef|extension(?:\s+type)?)\s+(El[A-Z][A-Za-z0-9_]*)\b',
  );
  final RegExp lowerIdentifier = RegExp(r'\bel[A-Z][A-Za-z0-9_]*\b');
  final RegExp constantIdentifier = RegExp(r'\bkEl[A-Z][A-Za-z0-9_]*\b');
  final Map<String, int> result = <String, int>{'el': 0};
  for (final File file in _sourceDartFiles(root)) {
    final String source = file.readAsStringSync();
    for (final RegExpMatch match in typeDeclaration.allMatches(source)) {
      final String value = match.group(1)!;
      result[value] = (result[value] ?? 0) + 1;
    }
    for (final RegExpMatch match in lowerIdentifier.allMatches(source)) {
      final String value = match.group(0)!;
      result[value] = (result[value] ?? 0) + 1;
    }
    for (final RegExpMatch match in constantIdentifier.allMatches(source)) {
      final String value = match.group(0)!;
      result[value] = (result[value] ?? 0) + 1;
    }
    result['el'] =
        result['el']! + RegExp(r'\bel\s*\(').allMatches(source).length;
  }
  if (result['el'] == 0) result.remove('el');
  return result;
}

String _future(String current) {
  final String? special = _special[current];
  if (special != null) return special;
  if (current == 'el') return 'space';
  if (current.startsWith('El')) return current.substring(2);
  if (current.startsWith('kEl')) {
    final String remainder = current.substring(3);
    return '${remainder[0].toLowerCase()}${remainder.substring(1)}';
  }
  final String remainder = current.substring(2);
  return '${remainder[0].toLowerCase()}${remainder.substring(1)}';
}

void _validate(List<Map<String, Object?>> rows) {
  final Set<String> oldNames = <String>{};
  final Map<String, String> futureOwners = <String, String>{};
  for (final Map<String, Object?> row in rows) {
    final String current = row['current']! as String;
    final String future = row['future']! as String;
    if (!oldNames.add(current)) throw StateError('Duplicate current: $current');
    final String? existing = futureOwners[future];
    if (existing != null && existing != current) {
      throw StateError('Future collision: $existing and $current -> $future');
    }
    futureOwners[future] = current;
  }
}

int _apply(Directory root, Map<String, String> renames) {
  var changed = 0;
  for (final File file in _textFiles(root)) {
    final String source = file.readAsStringSync();
    final String relative = _relative(root.path, file.path);
    final bool dart = file.path.endsWith('.dart');
    final bool packageSource = relative.startsWith('lib/src/');
    String prepared = source;
    if (packageSource) prepared = _protectFlutterNames(prepared);
    final String updated = dart
        ? _rewriteDart(prepared, renames, prefixCode: '')
        : _rewritePlain(prepared, renames);
    if (updated != source) {
      _writeWithRetry(file, updated);
      changed++;
    }
  }
  return changed;
}

const Set<String> _flutterCollisionNames = <String>{
  'AspectRatio',
  'Icon',
  'OverlayPortal',
  'RichText',
  'SafeArea',
  'ScrollPosition',
  'Table',
  'TableColumnWidth',
};

String _protectFlutterNames(String source) {
  if (RegExp(
    r"import 'package:flutter/(?:widgets|material)\.dart'\s+hide",
  ).hasMatch(source)) {
    return source;
  }
  final Set<String> used = <String>{};
  final String qualified = _rewriteDartIdentifiers(source, (
    identifier,
    previous,
  ) {
    if (_flutterCollisionNames.contains(identifier) && previous != '.') {
      used.add(identifier);
      return 'flutter.$identifier';
    }
    return identifier;
  });
  final List<String> hidden = _flutterCollisionNames.toList()..sort();
  String updated = qualified.replaceAllMapped(
    RegExp(r"import 'package:flutter/(widgets|material)\.dart';"),
    (match) =>
        "import 'package:flutter/${match.group(1)}.dart' hide ${hidden.join(', ')};",
  );
  if (used.isEmpty) return updated;
  final List<String> shown = used.toList()..sort();
  final String alias =
      "import 'package:flutter/widgets.dart' as flutter show ${shown.join(', ')};";
  final RegExp lastFlutterImport = RegExp(
    r"import 'package:flutter/[^']+'[^;]*;",
  );
  final List<RegExpMatch> imports = lastFlutterImport
      .allMatches(updated)
      .toList();
  if (imports.isEmpty) {
    throw StateError('Flutter name used without a Flutter import.');
  }
  final RegExpMatch last = imports.last;
  return updated.replaceRange(last.end, last.end, '\n$alias');
}

String _rewriteDart(
  String source,
  Map<String, String> renames, {
  required String prefixCode,
}) => _rewriteDartIdentifiers(source, (identifier, previous) {
  final String? future = renames[identifier];
  if (future == null) return identifier;
  if (previous == '.') return future;
  return '$prefixCode$future';
}, commentAndStringRenames: renames);

String _rewritePlain(String source, Map<String, String> renames) {
  if (renames.isEmpty) return source;
  final List<String> names = renames.keys.toList()
    ..sort((a, b) => b.length.compareTo(a.length));
  final RegExp pattern = RegExp(
    '\\b(?:${names.map(RegExp.escape).join('|')})\\b',
  );
  return source.replaceAllMapped(pattern, (match) => renames[match.group(0)!]!);
}

String _rewriteDartIdentifiers(
  String source,
  String Function(String identifier, String? previous) code, {
  Map<String, String> commentAndStringRenames = const <String, String>{},
}) {
  final StringBuffer out = StringBuffer();
  var index = 0;
  String? previousCodeCharacter;
  while (index < source.length) {
    final int char = source.codeUnitAt(index);
    if (char == 47 && index + 1 < source.length) {
      final int next = source.codeUnitAt(index + 1);
      if (next == 47) {
        final int end = source.indexOf('\n', index);
        final int limit = end < 0 ? source.length : end;
        out.write(
          _rewritePlain(
            source.substring(index, limit),
            commentAndStringRenames,
          ),
        );
        index = limit;
        continue;
      }
      if (next == 42) {
        final int end = source.indexOf('*/', index + 2);
        final int limit = end < 0 ? source.length : end + 2;
        out.write(
          _rewritePlain(
            source.substring(index, limit),
            commentAndStringRenames,
          ),
        );
        index = limit;
        continue;
      }
    }
    final bool raw =
        char == 114 &&
        index + 1 < source.length &&
        (source.codeUnitAt(index + 1) == 39 ||
            source.codeUnitAt(index + 1) == 34);
    final int quoteIndex = raw ? index + 1 : index;
    if (source.codeUnitAt(quoteIndex) == 39 ||
        source.codeUnitAt(quoteIndex) == 34) {
      final int limit = _stringEnd(source, quoteIndex, raw: raw);
      out.write(
        _rewritePlain(source.substring(index, limit), commentAndStringRenames),
      );
      previousCodeCharacter = source[quoteIndex];
      index = limit;
      continue;
    }
    if (_identifierStart(char)) {
      var end = index + 1;
      while (end < source.length && _identifierPart(source.codeUnitAt(end))) {
        end++;
      }
      final String identifier = source.substring(index, end);
      out.write(code(identifier, previousCodeCharacter));
      previousCodeCharacter = identifier.isEmpty
          ? previousCodeCharacter
          : identifier[identifier.length - 1];
      index = end;
      continue;
    }
    final String value = source[index];
    out.write(value);
    if (value.trim().isNotEmpty) previousCodeCharacter = value;
    index++;
  }
  return '$out';
}

int _stringEnd(String source, int quoteIndex, {required bool raw}) {
  final String quote = source[quoteIndex];
  final String tripleQuote = '$quote$quote$quote';
  final bool triple =
      quoteIndex + 2 < source.length &&
      source.substring(quoteIndex, quoteIndex + 3) == tripleQuote;
  var index = quoteIndex + (triple ? 3 : 1);
  while (index < source.length) {
    if (!raw && !triple && source[index] == '\\') {
      index += 2;
      continue;
    }
    if (triple) {
      if (index + 2 < source.length &&
          source.substring(index, index + 3) == tripleQuote) {
        return index + 3;
      }
    } else if (source[index] == quote) {
      return index + 1;
    }
    index++;
  }
  return source.length;
}

bool _identifierStart(int value) =>
    value == 95 ||
    value == 36 ||
    (value >= 65 && value <= 90) ||
    (value >= 97 && value <= 122);
bool _identifierPart(int value) =>
    _identifierStart(value) || (value >= 48 && value <= 57);

void _writeWithRetry(File file, String content) {
  Object? lastError;
  for (var attempt = 0; attempt < 12; attempt++) {
    try {
      file.writeAsStringSync(content);
      return;
    } on FileSystemException catch (error) {
      lastError = error;
      sleep(Duration(milliseconds: 25 * (attempt + 1)));
    }
  }
  throw StateError('Cannot write ${file.path}: $lastError');
}

Iterable<File> _sourceDartFiles(Directory root) =>
    Directory(_join(root.path, 'lib/src'))
        .listSync(recursive: true, followLinks: false)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

Iterable<File> _textFiles(Directory root) => root
    .listSync(recursive: true, followLinks: false)
    .whereType<File>()
    .where(
      (file) => const <String>{
        '.dart',
        '.json',
        '.md',
        '.yaml',
        '.yml',
      }.any(file.path.endsWith),
    )
    .where((file) {
      final String path = _relative(root.path, file.path);
      return !path.startsWith('.git/') &&
          !path.startsWith('.dart_tool/') &&
          !path.startsWith('build/') &&
          !path.startsWith('registry/generated/') &&
          !path.startsWith('tool/migration/') &&
          !path.startsWith('tool/verify/out/') &&
          !path.startsWith('docs/superpowers/');
    });

Directory _repositoryRoot() {
  Directory current = Directory.current.absolute;
  while (!File(_join(current.path, 'pubspec.yaml')).existsSync()) {
    final Directory parent = current.parent;
    if (parent.path == current.path) throw StateError('Repository not found.');
    current = parent;
  }
  return current;
}

String _git(Directory root, List<String> arguments) {
  final ProcessResult result = Process.runSync(
    'git',
    arguments,
    workingDirectory: root.path,
  );
  if (result.exitCode != 0) throw StateError('${result.stderr}');
  return '${result.stdout}';
}

String _relative(String root, String path) => path
    .replaceAll('\\', '/')
    .replaceFirst(
      '${root.replaceAll('\\', '/').replaceAll(RegExp(r'/+$'), '')}/',
      '',
    );
String _join(String root, String child) =>
    '${root.replaceAll(RegExp(r'[\\/]+$'), '')}${Platform.pathSeparator}${child.replaceAll('/', Platform.pathSeparator)}';
