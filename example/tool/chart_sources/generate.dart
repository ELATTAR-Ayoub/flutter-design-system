/// Writes `lib/charts/chart_sources.g.dart` from the marked declarations in
/// `lib/charts/specimens_*.dart`.
///
/// Run from `example/`: `dart run tool/chart_sources/generate.dart`
library;

import 'dart:io';

import 'extractor.dart';

/// Families in the order the gallery's tab strip lists them, so a
/// regeneration produces no reordering diff.
const List<String> _families = <String>[
  'area',
  'bar',
  'line',
  'pie',
  'radar',
  'radial',
  'tooltip',
];

Map<String, String> collectSources(Directory chartsDir) {
  final Map<String, String> all = <String, String>{};
  for (final String family in _families) {
    final File file = File('${chartsDir.path}/specimens_$family.dart');
    if (!file.existsSync()) {
      throw StateError('missing ${file.path}');
    }
    all.addAll(extractSpecimens(file.readAsStringSync()));
  }
  return all;
}

String renderGenerated(Map<String, String> sources) {
  final StringBuffer out = StringBuffer()
    ..writeln('// GENERATED FILE. Do not edit by hand.')
    ..writeln('// Run: dart run tool/chart_sources/generate.dart')
    ..writeln('//')
    ..writeln('// The source every gallery card copies, read out of')
    ..writeln('// lib/charts/specimens_*.dart so that what a reader copies is')
    ..writeln('// what this package compiles.')
    ..writeln('library;')
    ..writeln()
    ..writeln('const Map<String, String> chartSources = <String, String>{');
  for (final MapEntry<String, String> entry in sources.entries) {
    out.writeln('  ${dartStringLiteral(entry.key)}: ');
    out.writeln('      ${dartStringLiteral(entry.value)},');
  }
  out.writeln('};');
  return out.toString();
}

void main() {
  final Directory charts = Directory('lib/charts');
  final Map<String, String> sources = collectSources(charts);
  File(
    '${charts.path}/chart_sources.g.dart',
  ).writeAsStringSync(renderGenerated(sources));
  stdout.writeln('wrote ${sources.length} specimen sources');
}
