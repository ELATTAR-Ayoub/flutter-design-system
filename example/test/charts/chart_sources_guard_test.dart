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

  // The drift test above (`the generated chart sources match the specimen
  // files`) compares the committed chartSources map to a fresh extraction
  // made by the SAME extractSpecimens()/collectSources() code that produced
  // the committed file. That comparison is circular: if a future edit to
  // extractor.dart breaks its brace or string handling and starts truncating
  // declarations, a regenerate-and-commit reproduces the same truncated
  // bytes, and the drift test passes because both sides agree on the same
  // wrong answer. The `contains('Widget')` check above is too weak to catch
  // this either — a declaration truncated after its first line still
  // contains the word `Widget` and is still non-empty.
  //
  // The assertions below do not route through the extractor at all. They
  // are independent oracles: a truncated declaration fails them regardless
  // of what extractor.dart currently does.
  //
  // package:analyzer (which would let us actually parse each source string
  // and assert zero syntax errors — the strongest independent oracle) is
  // NOT in this project's resolved dependency tree (`dart pub deps` was
  // checked; only flutter/flutter_test/flutter_lints and their transitive
  // deps resolve, no analyzer). Adding it requires an edit to
  // example/pubspec.yaml, which is out of scope here, so this guard falls
  // back to two cheaper, weaker-but-still-independent checks: a structural
  // "ends cleanly" character check, plus verified absolute counts.
  test('every generated source ends on a balanced declaration boundary', () {
    // FALLBACK (package:analyzer unavailable in this dependency tree): a
    // full Dart parse would catch any truncation, including one that still
    // happens to end in `;` or `}`. This character check only catches
    // truncation that leaves the string ending mid-token or mid-statement,
    // which is the common failure mode of a broken brace/string scanner,
    // but it is not a real parser and can be fooled.
    for (final MapEntry<String, String> entry in chartSources.entries) {
      final String trimmed = entry.value.trimRight();
      final String lastChar = trimmed.isEmpty
          ? ''
          : trimmed[trimmed.length - 1];
      expect(
        lastChar == ';' || lastChar == '}',
        isTrue,
        reason:
            '${entry.key} does not end with `;` or `}` — the extractor may '
            'be truncating declarations. Regenerating will NOT fix this; '
            'fix the extractor.',
      );
    }
  });

  test('chartSources has exactly 70 entries', () {
    // A systemic undercount from a broken extractor currently trips
    // nothing, because the drift test only compares two numbers that move
    // together (the committed map and a fresh extraction). This pins the
    // count to a number verified independently of the extractor.
    expect(
      chartSources.length,
      70,
      reason:
          'Expected exactly 70 chart specimen sources. If this changed '
          'intentionally (a specimen was added or removed), update this '
          'expected count alongside the per-family counts below.',
    );
  });

  test('chartSources has the verified per-family counts', () {
    // Per-family counts verified by hand against the specimen files
    // (see task-12-report.md), independent of what the extractor counts.
    const Map<String, int> expectedFamilyCounts = <String, int>{
      'chart-area-': 10,
      'chart-bar-': 10,
      'chart-line-': 10,
      'chart-pie-': 11,
      'chart-radar-': 14,
      'chart-radial-': 6,
      'chart-tooltip-': 9,
    };

    for (final MapEntry<String, int> family
        in expectedFamilyCounts.entries) {
      final int actual = chartSources.keys
          .where((String key) => key.startsWith(family.key))
          .length;
      expect(
        actual,
        family.value,
        reason:
            'Expected ${family.value} specimens with prefix '
            '"${family.key}", found $actual.',
      );
    }
  });
}
