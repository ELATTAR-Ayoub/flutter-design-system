import 'dart:io';

import 'package:example/charts/chart_copy.dart';
import 'package:example/charts/chart_sources.g.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../tool/chart_sources/generate.dart' show collectSources;

void main() {
  test('the generated chart sources match the specimen files', () {
    final Map<String, String> fresh = collectSources(Directory('lib/charts'));

    expect(
      fresh.length,
      chartSources.length,
      reason:
          'A specimen was added or removed. Regenerate with:\n'
          '  dart run tool/chart_sources/generate.dart',
    );

    for (final MapEntry<String, String> entry in fresh.entries) {
      expect(
        chartSources[entry.key],
        entry.value,
        reason:
            '${entry.key} has drifted from its source. Regenerate with:\n'
            '  dart run tool/chart_sources/generate.dart',
      );
    }
  });

  test('every specimen source is copyable Dart, not an empty string', () {
    for (final MapEntry<String, String> entry in chartSources.entries) {
      expect(entry.value.trim(), isNotEmpty, reason: entry.key);
      expect(entry.value, contains('Widget'), reason: entry.key);
    }
  });

  test('chartSources and chartCardCopy key the same specimens', () {
    expect(
      chartSources.keys.toSet(),
      chartCardCopy.keys.toSet(),
      reason:
          'chartSources and chartCardCopy must share exactly the same '
          'specimen ids, or the gallery will join a card with source but no '
          'title, or a title with no source.',
    );
  });
}
