# Charts Gallery Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a shadcn-style charts gallery at `/charts` where a reader switches families with a tab strip, copies any chart's real source with one click, and reads it in a right-hand sheet.

**Architecture:** The seventy chart specimens move out of the 6128-line `example/lib/pages/charts.dart` into a shared `example/lib/charts/` library of `ChartSpecimen` records. Both the existing reference page and the new gallery read that library, so they cannot drift. The copyable source is extracted from those files by a small Dart scanner into a generated map, guarded by a test that fails when the two disagree.

**Tech Stack:** Flutter (widgets layer only, never Material), the `elattar_design_system` package, `flutter_test`. Plain Dart for the extractor and its CLI.

**Design spec:** `docs/superpowers/specs/2026-09-09-charts-gallery-design.md`

## Global Constraints

- **Branch:** `charts-gallery`, already created, spec already committed on it.
- **Never edit `lib/src/`.** This work is confined to `example/`.
- **Tokens only.** No `Colors.`, no `Color(`, no raw `TextStyle(`, no `Duration(`, no `Curves.`, no bare numeric `width:`/`height:`/`padding:` literals. Use `space(n)`, `Radii.*`, `TextStyles.*`, `ThemeScope.of(context)`, `BorderWidths.hairline`.
- **Never use Material.** Import `package:flutter/widgets.dart` with the repo's standard `hide` list (copied verbatim in Task 3, Step 1). Use the design system's `Text` equivalents (`StyledText`, `RichText` from the package), not Flutter's.
- **Every specimen keeps its existing behaviour.** This is a re-housing, not a redesign. No chart is re-authored, no fixture value changes, no curve or colour changes.
- **`example/lib/pages/charts.dart` must render identically before and after.** Task 2's characterization test is the control and must stay green through Tasks 4 to 11.
- **Test command:** `flutter test` from the `example/` directory. It runs natively on Windows; there is no WSL mirror.
- **Pumping a themed widget in a test** uses `ThemeScope(controller: ThemeController(mode: ColorMode.light), child: …)`. There is no `lightTokens` and `ThemeScope` takes no `tokens:` argument; the token set is resolved by `ThemeScope.of(context)`, which returns `ThemeTokens.light` or `ThemeTokens.dark`. `ThemeController(...)` is not const, so the `ThemeScope` wrapping it cannot be `const` either. `example/test/docs/component_doc_page_test.dart` and `example/test/pages/charts_page_render_test.dart` are the working examples. Established by Task 2, whose brief had this wrong.
- **Analyzer:** `flutter analyze` from `example/` must be clean before each commit.
- **Commit messages** end with:
  ```
  Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
  ```
- **Specimen ids** are the shadcn registry names, e.g. `chart-area-step`, `chart-bar-label-custom`, `chart-tooltip-indicator-line`.

---

## File Structure

**Created:**

| File | Responsibility |
| --- | --- |
| `example/lib/charts/chart_copy.dart` | shadcn's harvested card copy, keyed by specimen id |
| `example/lib/charts/chart_specimen.dart` | the `ChartSpecimen` descriptor and `ChartSkeletonKind` |
| `example/lib/charts/chart_ink.dart` | `ChartInk`, the five token slots |
| `example/lib/charts/chart_data.dart` | every fixture the specimens read |
| `example/lib/charts/chart_states.dart` | `ChartStateSwitch`, the empty panel, the four skeletons |
| `example/lib/charts/specimens_area.dart` | 10 area specimens + `areaSpecimens` |
| `example/lib/charts/specimens_bar.dart` | 10 bar specimens + `barSpecimens` |
| `example/lib/charts/specimens_line.dart` | 10 line specimens + `lineSpecimens` |
| `example/lib/charts/specimens_pie.dart` | 11 pie specimens + `pieSpecimens` |
| `example/lib/charts/specimens_radar.dart` | 14 radar specimens + `radarSpecimens` |
| `example/lib/charts/specimens_radial.dart` | 6 radial specimens + `radialSpecimens` |
| `example/lib/charts/specimens_tooltip.dart` | 9 tooltip specimens + `tooltipSpecimens` |
| `example/lib/charts/chart_sources.g.dart` | generated map of copyable source |
| `example/lib/charts/chart_card.dart` | `ChartSpecimenCard`: toolbar, card, state toggle, sheet |
| `example/lib/site/pages/charts_gallery_page.dart` | the `/charts` page |
| `example/tool/chart_sources/extractor.dart` | the source scanner, plain Dart |
| `example/tool/chart_sources/generate.dart` | the CLI that writes the generated file |
| `example/test/charts/chart_extractor_test.dart` | extractor unit tests |
| `example/test/charts/chart_sources_guard_test.dart` | generated-file drift guard |
| `example/test/charts/charts_gallery_test.dart` | gallery page tests |
| `example/test/pages/charts_page_render_test.dart` | characterization test for the reference page |

**Modified:**

| File | Change |
| --- | --- |
| `example/lib/pages/charts.dart` | specimen bodies removed; imports the shared library |
| `example/lib/components_docs/catalog.dart` | `ComponentDocEntry.showInRail`; family landing fields |
| `example/lib/components_docs/chart*/meta.dart` | four entries set `showInRail: false` |
| `example/lib/docs/docs_layout.dart` | rail renders a family landing entry, skips hidden entries |
| `example/lib/site/site_routes.dart` | `chartsRoute` and its `SiteRoute` |
| `example/lib/main.dart` | `/charts` resolves to `ChartsGalleryPage` |
| `example/test/docs_sidebar_test.dart` | asserts the collapsed Charts group |

---

## Task 1: Harvest shadcn's card copy

**Owner:** orchestrator, not a subagent. It needs the browser and is done once.

**Files:**
- Create: `example/lib/charts/chart_copy.dart`

**Interfaces:**
- Produces: `class ChartCardCopy { final String title; final String trend; final String range; }` and `const Map<String, ChartCardCopy> chartCardCopy`, keyed by specimen id. Every later task reads titles and footer copy from here and never invents them.

- [ ] **Step 1: Read the seven gallery pages**

For each of `area`, `bar`, `line`, `pie`, `radar`, `radial`, `tooltip`, load `https://ui.shadcn.com/charts/<family>` and run, in the page:

```js
[...document.querySelectorAll('iframe')].map(f => {
  const d = f.contentDocument;
  const c = d.querySelector('[data-slot="card"]');
  const g = s => { const e = c && c.querySelector(`[data-slot="${s}"]`); return e ? e.innerText.trim() : null };
  return { id: f.src.split('/').pop(), header: g('card-header'), footer: g('card-footer') };
})
```

The header's first line is the title; the footer's two lines are the trend and the range. A card with no footer (the interactive ones) records empty strings for both.

- [ ] **Step 2: Write the map**

```dart
// example/lib/charts/chart_copy.dart
/// Card copy for every gallery specimen.
///
/// Harvested from shadcn's own per-variant view pages on 2026-09-09, not
/// written here: these cards reproduce the reference's registry variants, so
/// the words on them are the reference's words. A specimen with no footer on
/// the reference (the interactive ones) carries empty [trend] and [range],
/// and [ChartSpecimenCard] omits the band rather than printing a blank one.
library;

class ChartCardCopy {
  const ChartCardCopy({
    required this.title,
    required this.trend,
    required this.range,
  });

  /// `<CardTitle>`, e.g. `Area Chart - Step`.
  final String title;

  /// The footer's first line, e.g. `Trending up by 5.2% this month`.
  final String trend;

  /// The footer's second line, e.g. `January - June 2024`.
  final String range;

  bool get hasFooter => trend.isNotEmpty || range.isNotEmpty;
}

const Map<String, ChartCardCopy> chartCardCopy = <String, ChartCardCopy>{
  'chart-area-default': ChartCardCopy(
    title: 'Area Chart',
    trend: 'Trending up by 5.2% this month',
    range: 'January - June 2024',
  ),
  // ... one entry per specimen, seventy in total
};
```

- [ ] **Step 3: Verify the key set**

Run: `cd example && flutter analyze lib/charts/chart_copy.dart`
Expected: no issues. The map must hold exactly seventy entries; count them before committing.

- [ ] **Step 4: Commit**

```bash
git add example/lib/charts/chart_copy.dart
git commit -m "feat(charts): harvest shadcn card copy for the gallery"
```

---

## Task 2: Pin the reference page's current render

This runs **before** any extraction. It is the control that proves Tasks 4 to 11 changed nothing visible.

**Files:**
- Create: `example/test/pages/charts_page_render_test.dart`

**Interfaces:**
- Consumes: `ChartsPage` from `package:example/pages/charts.dart`.
- Produces: nothing other tasks import. It is a guard.

- [ ] **Step 1: Write the characterization test**

```dart
import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/kit.dart';
import 'package:example/pages/charts.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpChartsPage(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1600, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ThemeScope(
      controller: ThemeController(mode: ColorMode.light),
      child: const Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: MediaQueryData(size: Size(1600, 2400)),
          child: SingleChildScrollView(child: ChartsPage()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the reference page still carries every specimen panel', (
    WidgetTester tester,
  ) async {
    await _pumpChartsPage(tester);
    expect(tester.takeException(), isNull);

    // Seventy family specimens plus unit activity and conversion funnel.
    expect(find.byType(Panel), findsNWidgets(72));
  });

  testWidgets('every section heading is still present', (
    WidgetTester tester,
  ) async {
    await _pumpChartsPage(tester);

    for (final String title in <String>[
      'Area',
      'Bar',
      'Line',
      'Pie',
      'Radar',
      'Radial',
    ]) {
      expect(find.text(title), findsWidgets, reason: title);
    }
    expect(tester.takeException(), isNull);
  });
}
```

- [ ] **Step 2: Run it and read the real counts**

Run: `cd example && flutter test test/pages/charts_page_render_test.dart`

If the panel count assertion fails, the number in the message is the truth: replace `72` with it and rerun. Do **not** change any page source to satisfy this test. Its whole job is to record what is there today.

- [ ] **Step 3: Confirm green**

Run: `cd example && flutter test test/pages/charts_page_render_test.dart`
Expected: PASS, 2 tests.

- [ ] **Step 4: Commit**

```bash
git add example/test/pages/charts_page_render_test.dart
git commit -m "test(charts): pin the reference page render before extraction"
```

---

## Task 3: The specimen source extractor

Independent of every other task. Pure Dart, no Flutter.

**Files:**
- Create: `example/tool/chart_sources/extractor.dart`
- Test: `example/test/charts/chart_extractor_test.dart`

**Interfaces:**
- Produces: `Map<String, String> extractSpecimens(String source)` and `String dartStringLiteral(String value)`. Tasks 5 to 12 depend on both names exactly.

- [ ] **Step 1: Write the failing tests**

```dart
import 'package:flutter_test/flutter_test.dart';

import '../../tool/chart_sources/extractor.dart';

void main() {
  group('extractSpecimens', () {
    test('captures an expression-bodied declaration up to its semicolon', () {
      const String source = '''
// specimen: chart-area-default
Widget areaDefault(ChartInk ink) => plot(ink.desktop, const Text('x'));
''';
      expect(extractSpecimens(source), <String, String>{
        'chart-area-default':
            "Widget areaDefault(ChartInk ink) => plot(ink.desktop, const Text('x'));",
      });
    });

    test('captures a block-bodied declaration up to its closing brace', () {
      const String source = '''
// specimen: chart-pie-donut-text
Widget pieDonutText(ChartInk ink) {
  final int total = 1;
  return plot(ink.browsers, Text('\$total'));
}
''';
      expect(
        extractSpecimens(source)['chart-pie-donut-text'],
        'Widget pieDonutText(ChartInk ink) {\n'
        '  final int total = 1;\n'
        "  return plot(ink.browsers, Text('\$total'));\n"
        '}',
      );
    });

    test('includes the semicolon after a top-level assignment brace', () {
      const String source = '''
// specimen: chart-area-axes
const Map<String, int> axes = <String, int>{'a': 1};
''';
      expect(
        extractSpecimens(source)['chart-area-axes'],
        "const Map<String, int> axes = <String, int>{'a': 1};",
      );
    });

    test('a brace inside a string does not end the declaration', () {
      const String source = '''
// specimen: chart-bar-label
Widget barLabel() => const Text('}');
''';
      expect(
        extractSpecimens(source)['chart-bar-label'],
        "Widget barLabel() => const Text('}');",
      );
    });

    test('a brace inside a line comment does not end the declaration', () {
      const String source = '''
// specimen: chart-line-dots
Widget lineDots() {
  // a } in prose
  return const Text('x');
}
''';
      expect(
        extractSpecimens(source)['chart-line-dots'],
        'Widget lineDots() {\n'
        '  // a } in prose\n'
        "  return const Text('x');\n"
        '}',
      );
    });

    test('a brace inside a block comment does not end the declaration', () {
      const String source = '''
// specimen: chart-radar-dots
Widget radarDots() {
  /* } */
  return const Text('x');
}
''';
      expect(extractSpecimens(source)['chart-radar-dots'], contains('/* } */'));
    });

    test('interpolation braces are balanced as code, not swallowed', () {
      const String source = r'''
// specimen: chart-radial-text
Widget radialText(int n) => Text('${n + 1}');
''';
      expect(
        extractSpecimens(source)['chart-radial-text'],
        r"Widget radialText(int n) => Text('${n + 1}');",
      );
    });

    test('an escaped quote does not close the string', () {
      const String source = r'''
// specimen: chart-tooltip-default
Widget tooltipDefault() => const Text('it\'s');
''';
      expect(
        extractSpecimens(source)['chart-tooltip-default'],
        r"Widget tooltipDefault() => const Text('it\'s');",
      );
    });

    test('a raw string ignores escapes', () {
      const String source = r'''
// specimen: chart-bar-mixed
Widget barMixed() => const Text(r'a\');
''';
      expect(
        extractSpecimens(source)['chart-bar-mixed'],
        r"Widget barMixed() => const Text(r'a\');",
      );
    });

    test('a triple-quoted string may contain quotes and braces', () {
      const String source = """
// specimen: chart-pie-legend
Widget pieLegend() => const Text('''a } ' b''');
""";
      expect(
        extractSpecimens(source)['chart-pie-legend'],
        "Widget pieLegend() => const Text('''a } ' b''');",
      );
    });

    test('a class declaration is captured whole', () {
      const String source = '''
// specimen: chart-area-interactive
class AreaInteractive extends StatelessWidget {
  const AreaInteractive();

  @override
  Widget build(BuildContext context) => const Text('x');
}
''';
      final String out = extractSpecimens(source)['chart-area-interactive']!;
      expect(out, startsWith('class AreaInteractive'));
      expect(out, endsWith('}'));
    });

    test('several markers in one file are all captured', () {
      const String source = '''
// specimen: chart-a
Widget a() => const Text('a');

// specimen: chart-b
Widget b() => const Text('b');
''';
      expect(extractSpecimens(source).keys, <String>['chart-a', 'chart-b']);
    });

    test('an unterminated declaration is an error naming the id', () {
      const String source = '''
// specimen: chart-broken
Widget broken() {
''';
      expect(
        () => extractSpecimens(source),
        throwsA(
          isA<FormatException>().having(
            (FormatException e) => e.message,
            'message',
            contains('chart-broken'),
          ),
        ),
      );
    });
  });

  group('dartStringLiteral', () {
    test('escapes backslash, quote and dollar', () {
      expect(dartStringLiteral(r"a\b'c$d"), r"'a\\b\'c\$d'");
    });

    test('escapes newlines so the literal stays on one line', () {
      expect(dartStringLiteral('a\nb'), r"'a\nb'");
    });

    test('round-trips a declaration containing all three', () {
      const String value = "Text('\$x') // a \\ b";
      final String literal = dartStringLiteral(value);
      expect(literal.startsWith("'"), isTrue);
      expect(literal.endsWith("'"), isTrue);
      expect(literal.contains('\n'), isFalse);
    });
  });
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `cd example && flutter test test/charts/chart_extractor_test.dart`
Expected: FAIL, the import cannot be resolved and `extractSpecimens` is undefined.

- [ ] **Step 3: Write the extractor**

```dart
// example/tool/chart_sources/extractor.dart
/// Pulls the copyable source of every marked specimen out of a Dart file.
///
/// A library, not only a CLI, so `test/charts/chart_sources_guard_test.dart`
/// can re-run the extraction in-process and compare it against the committed
/// generated file. A guard that shells out to `dart run` is a guard that is
/// slow enough to be skipped.
library;

/// The marker a specimen declaration carries, on the line above it.
final RegExp _marker = RegExp(r'^\s*//\s*specimen:\s*([a-z0-9-]+)\s*$');

/// Every marked declaration in [source], keyed by its specimen id, in the
/// order the file declares them.
Map<String, String> extractSpecimens(String source) {
  final List<String> lines = source.split('\n');
  final Map<String, String> out = <String, String>{};

  for (int i = 0; i < lines.length; i++) {
    final RegExpMatch? match = _marker.firstMatch(lines[i]);
    if (match == null) continue;

    final String id = match.group(1)!;
    final int start = i + 1;
    if (start >= lines.length) {
      throw FormatException('specimen $id has no declaration under it');
    }
    final int end = _declarationEnd(lines, start, id);
    out[id] = lines.sublist(start, end + 1).join('\n').trimRight();
  }

  return out;
}

/// The index of the last line of the declaration beginning at [start].
///
/// A declaration ends either at a `;` seen at nesting depth zero, or at the
/// `}` that returns the depth to zero — plus the `;` that may follow it, so a
/// top-level `const Map<…> x = <…>{…};` keeps its terminator.
int _declarationEnd(List<String> lines, int start, String id) {
  int depth = 0;
  _Mode mode = _Mode.code;
  String quote = '';
  bool tripleQuoted = false;
  bool rawString = false;
  final List<int> interpolation = <int>[];

  for (int line = start; line < lines.length; line++) {
    final String text = lines[line];

    for (int i = 0; i < text.length; i++) {
      final String c = text[i];
      final String next = i + 1 < text.length ? text[i + 1] : '';

      switch (mode) {
        case _Mode.blockComment:
          if (c == '*' && next == '/') {
            mode = _Mode.code;
            i++;
          }
combine:
        case _Mode.string:
          if (!rawString && c == r'\') {
            i++;
            break;
          }
          if (!rawString && c == r'$' && next == '{') {
            interpolation.add(depth);
            depth++;
            mode = _Mode.code;
            i++;
            break;
          }
          if (c == quote) {
            if (!tripleQuoted) {
              mode = _Mode.code;
              break;
            }
            if (text.startsWith(quote * 3, i)) {
              mode = _Mode.code;
              i += 2;
            }
          }
        case _Mode.code:
          if (c == '/' && next == '/') {
            i = text.length;
            break;
          }
          if (c == '/' && next == '*') {
            mode = _Mode.blockComment;
            i++;
            break;
          }
          if (c == "'" || c == '"') {
            quote = c;
            tripleQuoted = text.startsWith(c * 3, i);
            if (tripleQuoted) i += 2;
            rawString = i >= 1 && text[i - (tripleQuoted ? 3 : 1)] == 'r';
            mode = _Mode.string;
            break;
          }
          if (c == '(' || c == '[' || c == '{') {
            depth++;
            break;
          }
          if (c == ')' || c == ']' || c == '}') {
            depth--;
            if (interpolation.isNotEmpty && depth == interpolation.last) {
              interpolation.removeLast();
              mode = _Mode.string;
              break;
            }
            if (depth == 0 && c == '}') {
              final String rest = text.substring(i + 1).trimLeft();
              return rest.startsWith(';') || line + 1 >= lines.length
                  ? line
                  : line;
            }
            break;
          }
          if (c == ';' && depth == 0) return line;
      }
    }
  }

  throw FormatException('specimen $id has no terminated declaration');
}

enum _Mode { code, string, blockComment }

/// [value] as a single-line Dart string literal.
///
/// Single-quoted with `\`, `'`, `$` and the newline escaped, rather than a raw
/// triple-quoted block: a specimen containing `'''` would close a raw block,
/// and one containing `$` would interpolate inside a non-raw one.
String dartStringLiteral(String value) {
  final StringBuffer out = StringBuffer("'");
  for (final int rune in value.runes) {
    final String c = String.fromCharCode(rune);
    out.write(switch (c) {
      r'\' => r'\\',
      "'" => r"\'",
      r'$' => r'\$',
      '\n' => r'\n',
      '\r' => r'\r',
      _ => c,
    });
  }
  out.write("'");
  return out.toString();
}
```

**Note on the switch above:** Dart does not allow a label mid-switch. Write the three cases as a plain `if / else if` chain on `mode` instead of a `switch`, keeping the same logic and the same order of checks. The reviewer should reject any implementation that leaves a `combine:` label in place.

- [ ] **Step 4: Run the tests until green**

Run: `cd example && flutter test test/charts/chart_extractor_test.dart`
Expected: PASS, 15 tests. Fix the extractor, never the tests, unless a test itself encodes wrong Dart.

- [ ] **Step 5: Analyze and commit**

```bash
cd example && flutter analyze tool/chart_sources/extractor.dart test/charts/chart_extractor_test.dart
git add example/tool/chart_sources/extractor.dart example/test/charts/chart_extractor_test.dart
git commit -m "feat(charts): add the specimen source extractor"
```

---

## Task 4: The shared foundation

Moves the four helper clusters out of `pages/charts.dart` and makes them public. No specimen moves yet.

**Files:**
- Create: `example/lib/charts/chart_specimen.dart`, `chart_ink.dart`, `chart_data.dart`, `chart_states.dart`
- Modify: `example/lib/pages/charts.dart`

**Interfaces:**
- Consumes: `chartCardCopy` from Task 1.
- Produces:
  - `enum ChartSkeletonKind { area, bar, line, pie, radar, radial, tooltip }`
  - `class ChartInk { ChartInk(ThemeTokens theme); ChartConfig get desktop; ChartConfig get browsers; Color slot(int n); … }` — the public form of today's `_ChartInk`, same members, same behaviour.
  - `class ChartSpecimen` as declared in Step 2 below.
  - `class ChartStateSwitch extends StatefulWidget` — today's `_ChartStates` with `Panel` removed, exposing only the toggle strip and the state slot; the reference page wraps it in `Panel` itself.
  - Every fixture today spelled `_monthsDesktop`, `_monthsDesktopMobile`, `_browsers`, `_radarMonths` and the rest, renamed without the leading underscore and unchanged in value.

- [ ] **Step 1: Read what moves**

Run: `cd example && grep -n "class _ChartInk\|class _ChartStates\|enum _SkeletonKind\|class _ChartEmpty\|class _ChartSkeleton\|class _CartesianSkeleton\|class _PolarSkeleton\|class _TooltipSkeleton\|class _Plot\|class _SeriesClipper\|class _Annulus" lib/pages/charts.dart`

Everything that prints is moving. Read each one whole before touching it.

- [ ] **Step 2: Create the descriptor**

```dart
// example/lib/charts/chart_specimen.dart
/// One gallery specimen: what it is called, what it demonstrates, and how to
/// build it.
///
/// The gallery is data-driven off these records, so adding a chart is adding
/// a record. [build] takes the ink rather than reading the theme itself so a
/// specimen can be rendered under either theme without rebuilding its config.
library;

import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import 'chart_copy.dart';
import 'chart_ink.dart';

/// Which stand-in a specimen shows while it is loading.
enum ChartSkeletonKind { area, bar, line, pie, radar, radial, tooltip }

class ChartSpecimen {
  const ChartSpecimen({
    required this.id,
    required this.note,
    required this.skeleton,
    required this.build,
    this.fullWidth = false,
  });

  /// The registry name, e.g. `chart-area-step`. The key into [chartCardCopy]
  /// and into the generated source map.
  final String id;

  /// What this variant demonstrates, e.g. `type=step`. The card's description,
  /// and the reference page's panel note.
  final String note;

  final ChartSkeletonKind skeleton;

  /// Whether the gallery gives this specimen a row of its own. True for the
  /// interactive variants, whose control strip needs the width.
  final bool fullWidth;

  final Widget Function(BuildContext context, ChartInk ink) build;

  /// The reference's own card copy for this specimen.
  ChartCardCopy get copy {
    final ChartCardCopy? found = chartCardCopy[id];
    if (found == null) {
      throw StateError('no card copy harvested for $id');
    }
    return found;
  }

  /// The title the card prints.
  String get title => copy.title;
}
```

- [ ] **Step 3: Move ink, data and states**

Cut `_ChartInk` into `chart_ink.dart` as `ChartInk`. Cut every fixture constant into `chart_data.dart` without its underscore. Cut `_SkeletonKind`, `_ChartStates`, `_ChartEmpty`, `_ChartEmptyMedia`, `_ChartSkeleton`, `_CartesianSkeleton`, `_PolarSkeleton`, `_TooltipSkeleton`, `_Plot`, `_SeriesClipper`, `_Annulus` and `_AnnulusClipper` into `chart_states.dart`, renaming only the ones the other files name.

`_ChartStates` becomes `ChartStateSwitch` and **loses its `Panel` wrapper**: it returns the `Column` of toggle strip plus slot. The reference page wraps the result in `Panel(label:, note:)` at its call site, so both consumers can frame it their own way.

Keep every doc comment. They carry the reference's reasoning and are the reason the file is readable.

- [ ] **Step 4: Point the reference page at the new library**

In `pages/charts.dart`, delete the moved declarations, add the four imports, and replace each `_ChartStates(title: x, note: y, …)` call with:

```dart
Panel(
  label: x,
  note: y,
  child: ChartStateSwitch(
    skeleton: ChartSkeletonKind.area,
    controls: null,
    child: areaDefault(ink),
  ),
)
```

- [ ] **Step 5: Run the control test**

Run: `cd example && flutter test test/pages/charts_page_render_test.dart`
Expected: PASS, 2 tests. A failure here means the page changed. Fix the move, not the test.

- [ ] **Step 6: Analyze, run the full suite, commit**

```bash
cd example && flutter analyze && flutter test
git add example/lib/charts example/lib/pages/charts.dart
git commit -m "refactor(charts): extract ink, fixtures and states into a shared library"
```

---

## Tasks 5 to 11: Move the seven families

These run **in order, one at a time**. Each touches `pages/charts.dart`, so two in flight would conflict.

Every one of the seven follows the identical shape below. The only differences are the family name, the functions that move, and the count.

**Files, per family `<F>`:**
- Create: `example/lib/charts/specimens_<F>.dart`
- Modify: `example/lib/pages/charts.dart`

**Interfaces, per family:**
- Consumes: `ChartSpecimen`, `ChartSkeletonKind`, `ChartInk`, the fixtures from Task 4.
- Produces: `const List<ChartSpecimen> <F>Specimens` and one public builder per specimen.

**The functions that move:**

| Task | Family | Builders | Support types | Count |
| --- | --- | --- | --- | --- |
| 5 | area | `_areaDefault`, `_areaLinear`, `_areaStep`, `_areaStacked`, `_areaStackedExpand`, `_areaLegend`, `_areaIcons`, `_areaGradient`, `_areaAxes`, `_areaInteractive` | `_AreaInteractive`, `_AreaInteractiveRange`, `_RangeStrip`, `_monthAxis` | 10 |
| 6 | bar | `_barDefault`, `_barHorizontal`, `_barMultiple`, `_barStacked`, `_barLabel`, `_barLabelCustom`, `_barMixed`, `_barActive`, `_barNegative`, `_barInteractive` | `_SeriesStrip`, `_SeriesTile`, `_SeriesScope` | 10 |
| 7 | line | `_lineDefault`, `_lineLinear`, `_lineStep`, `_lineMultiple`, `_lineDots`, `_lineDotsCustom`, `_lineDotsColors`, `_lineLabel`, `_lineLabelCustom`, `_lineInteractive` | `_lineChart` | 10 |
| 8 | pie | `_pieSimple`, `_pieSeparatorNone`, `_pieLabel`, `_pieLabelCustom`, `_pieLabelList`, `_pieLegend`, `_pieDonut`, `_pieDonutActive`, `_pieDonutText`, `_pieStacked`, `_pieInteractive` | `_PieActiveScope` | 11 |
| 9 | radar | `_radarDefault`, `_radarDots`, `_radarLinesOnly`, `_radarCustomTick`, `_radarLabelCustom`, `_radarGridCustom`, `_radarGridNone`, `_radarGridCircle`, `_radarGridCircleNoLines`, `_radarGridCircleFill`, `_radarGridFill`, `_radarMultiple`, `_radarLegend`, `_radarIcons`, `_radarRadius` | `_radarChart` | 14 |
| 10 | radial | `_radialSimple`, `_radialGrid`, `_radialLabel`, `_radialText`, `_radialShape`, `_radialStacked` | none | 6 |
| 11 | tooltip | `_tooltipDefault`, `_tooltipIndicatorLine`, `_tooltipIndicatorNone`, `_tooltipLabelCustom`, `_tooltipLabelFormatter`, `_tooltipLabelNone`, `_tooltipFormatter`, `_tooltipIcons`, `_tooltipAdvanced` | `_tooltipChart` | 9 |

Task 9's radar list holds fifteen builders for fourteen specimens: `_radarLinesOnly` and `_radarMultiple` share a body on the reference. Keep both names, give each its own `ChartSpecimen` only if the reference page has a panel for it; the panel count in `pages/charts.dart` is the authority.

- [ ] **Step 1: Read the family's section in the reference page**

Run: `cd example && grep -n "class _<F>Section" -A 120 lib/pages/charts.dart`

Record, for each panel, its `title:` and its `note:`. The note becomes `ChartSpecimen.note`. The title is **not** carried over: the card title comes from `chartCardCopy`.

- [ ] **Step 2: Create the family file**

```dart
// example/lib/charts/specimens_<F>.dart
/// The <F> specimens, and the list the gallery and the reference page read.
///
/// Each builder carries a `// specimen: <id>` marker directly above it. That
/// line is what `tool/chart_sources/extractor.dart` keys on, and it is the
/// only reason the code a reader copies is the code this file compiles.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import 'chart_data.dart';
import 'chart_ink.dart';
import 'chart_specimen.dart';
import 'chart_states.dart';

// specimen: chart-<F>-default
Widget <f>Default(ChartInk ink) => plot(
  // …the body, moved verbatim from pages/charts.dart
);

// …one marked builder per specimen…

const List<ChartSpecimen> <F>Specimens = <ChartSpecimen>[
  ChartSpecimen(
    id: 'chart-<F>-default',
    note: 'one series, natural curve',
    skeleton: ChartSkeletonKind.<F>,
    build: _buildDefault,
  ),
  // …
];

Widget _buildDefault(BuildContext context, ChartInk ink) => <f>Default(ink);
```

The `build` field takes a `(BuildContext, ChartInk)` function, so a builder that ignores the context gets a one-line adapter. A builder that needs it (the interactive ones) is referenced directly.

- [ ] **Step 3: Delete the moved code from the reference page and import the family**

`pages/charts.dart` keeps `_<F>Section` and its `Meta` block. Every `child:` argument now calls the public builder.

- [ ] **Step 4: Run the control test**

Run: `cd example && flutter test test/pages/charts_page_render_test.dart`
Expected: PASS, 2 tests.

- [ ] **Step 5: Run the whole suite**

Run: `cd example && flutter analyze && flutter test`
Expected: no analyzer issues, no new failures.

- [ ] **Step 6: Commit**

```bash
git add example/lib/charts/specimens_<F>.dart example/lib/pages/charts.dart
git commit -m "refactor(charts): move the <F> specimens into the shared library"
```

---

## Task 12: Generate the copyable source

**Files:**
- Create: `example/tool/chart_sources/generate.dart`, `example/lib/charts/chart_sources.g.dart`
- Test: `example/test/charts/chart_sources_guard_test.dart`

**Interfaces:**
- Consumes: `extractSpecimens`, `dartStringLiteral` from Task 3; the seven specimen files from Tasks 5 to 11.
- Produces: `const Map<String, String> chartSources`, imported by Task 13.

- [ ] **Step 1: Write the generator**

```dart
// example/tool/chart_sources/generate.dart
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
  File('${charts.path}/chart_sources.g.dart')
      .writeAsStringSync(renderGenerated(sources));
  stdout.writeln('wrote ${sources.length} specimen sources');
}
```

- [ ] **Step 2: Run it**

Run: `cd example && dart run tool/chart_sources/generate.dart`
Expected: `wrote 70 specimen sources`. A different number means a marker is missing or misspelled; fix the specimen file, not the count.

- [ ] **Step 3: Format and analyze the generated file**

Run: `cd example && dart format lib/charts/chart_sources.g.dart && flutter analyze lib/charts/chart_sources.g.dart`
Expected: clean.

- [ ] **Step 4: Write the drift guard**

```dart
import 'dart:io';

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
}
```

- [ ] **Step 5: Run it**

Run: `cd example && flutter test test/charts/chart_sources_guard_test.dart`
Expected: PASS, 2 tests.

- [ ] **Step 6: Commit**

```bash
git add example/tool/chart_sources/generate.dart example/lib/charts/chart_sources.g.dart example/test/charts/chart_sources_guard_test.dart
git commit -m "feat(charts): generate the copyable specimen source"
```

---

## Task 13: The specimen card

**Files:**
- Create: `example/lib/charts/chart_card.dart`
- Test: covered by Task 14's `charts_gallery_test.dart`

**Interfaces:**
- Consumes: `ChartSpecimen`, `ChartInk`, `ChartStateSwitch`, `chartSources`, `DocsCopyButton`, `DocsSnippet`.
- Produces: `class ChartSpecimenCard extends StatelessWidget` taking `{required ChartSpecimen specimen, required ChartInk ink, DocsClipboardWriter? writer}`.

- [ ] **Step 1: Write the card**

```dart
// example/lib/charts/chart_card.dart
/// One gallery card: the reference's own card, with this system's parts.
///
/// The toolbar sits above the card rather than in [CardHeader]'s action slot.
/// That slot is real and unused on sixty-six of the seventy, but the four
/// interactive specimens need it for their range picker, and a top-right
/// corner that means "copy this" on most cards and "change the range" on the
/// rest is worse than a strip that always means the same thing.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import '../docs/docs_copy_button.dart';
import '../docs/docs_snippet.dart';
import 'chart_ink.dart';
import 'chart_sources.g.dart';
import 'chart_specimen.dart';
import 'chart_states.dart';

class ChartSpecimenCard extends StatelessWidget {
  const ChartSpecimenCard({
    super.key,
    required this.specimen,
    required this.ink,
    this.writer,
  });

  final ChartSpecimen specimen;
  final ChartInk ink;

  /// Injected so a test can observe a copy without a platform channel.
  final DocsClipboardWriter? writer;

  String get _source =>
      chartSources[specimen.id] ?? '// no source generated for ${specimen.id}';

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _Toolbar(
          id: specimen.id,
          source: _source,
          title: specimen.title,
          writer: writer,
        ),
        SizedBox(height: space(2)),
        Card(
          children: <Widget>[
            CardHeader(
              title: CardTitle(specimen.title),
              description: CardDescription(specimen.note),
            ),
            CardContent(
              child: ChartStateSwitch(
                skeleton: specimen.skeleton,
                child: Builder(
                  builder: (BuildContext context) =>
                      specimen.build(context, ink),
                ),
              ),
            ),
            if (specimen.copy.hasFooter)
              CardFooter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        StyledText(specimen.copy.trend, TextStyles.small),
                        SizedBox(width: space(2)),
                        const Icon(LucideIcons.trendingUp, size: IconSizes.sm),
                      ],
                    ),
                    SizedBox(height: space(1)),
                    StyledText(
                      specimen.copy.range,
                      TextStyles.small,
                      color: theme.mutedForeground,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// The strip above the card: the registry id, then Copy and View Code.
class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.id,
    required this.source,
    required this.title,
    required this.writer,
  });

  final String id;
  final String source;
  final String title;
  final DocsClipboardWriter? writer;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Row(
      children: <Widget>[
        Expanded(
          child: StyledText(
            id,
            TextStyles.code,
            color: theme.mutedForeground,
          ),
        ),
        DocsCopyButton(text: source, writer: writer),
        SizedBox(width: space(2)),
        SheetOverlay(
          side: SheetSide.right,
          trigger: (BuildContext context, VoidCallback open) => Button(
            label: 'View Code',
            variant: ButtonVariant.secondary,
            size: ButtonSize.sm,
            onPressed: open,
          ),
          content: (BuildContext context, VoidCallback close) => SheetContent(
            side: SheetSide.right,
            width: _sheetWidth(context),
            onClose: close,
            children: <Widget>[
              StyledText(title, TextStyles.h4),
              StyledText(id, TextStyles.code, color: theme.mutedForeground),
              Expanded(
                child: SingleChildScrollView(
                  child: DocsSnippet(code: source, language: 'dart'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// `SheetContent`'s own `sm:max-w-sm` is 384, too narrow for source. The
  /// sheet takes half the viewport, floored at the container scale the code
  /// blocks elsewhere on the site read at.
  double _sheetWidth(BuildContext context) {
    final double half = MediaQuery.sizeOf(context).width / 2;
    return half < Containers.sm ? Containers.sm : half;
  }
}
```

- [ ] **Step 2: Resolve the names against the package**

The identifiers `Button`, `ButtonVariant`, `ButtonSize`, `Icon`, `LucideIcons.trendingUp`, `IconSizes.sm`, `Containers.sm`, `StyledText`, `space` and `TextStyles.code` must all exist. Confirm each:

Run: `cd example && flutter analyze lib/charts/chart_card.dart`

Where a name is wrong, find the real one rather than inventing a wrapper:

```bash
cd .. && grep -rn "class Button\b" lib/src/components/ui/button.dart
grep -rn "trendingUp\|trending_up" lib/src --include=*.dart | head -5
grep -rn "class IconSizes\|class Containers" lib/src --include=*.dart | head -5
```

- [ ] **Step 3: Confirm it analyzes clean**

Run: `cd example && flutter analyze lib/charts/chart_card.dart`
Expected: no issues.

- [ ] **Step 4: Commit**

```bash
git add example/lib/charts/chart_card.dart
git commit -m "feat(charts): add the gallery specimen card"
```

---

## Task 14: The gallery page

**Files:**
- Create: `example/lib/site/pages/charts_gallery_page.dart`
- Test: `example/test/charts/charts_gallery_test.dart`

**Interfaces:**
- Consumes: every `<F>Specimens` list, `ChartSpecimenCard`, `ChartInk`, `Tabs`, `TabItem`.
- Produces: `class ChartsGalleryPage extends StatefulWidget` with `const ChartsGalleryPage({super.key, this.onNavigate})`, where `onNavigate` is `void Function(String route)?`, matching the signature `main.dart`'s builder map already uses.

- [ ] **Step 1: Write the failing tests**

```dart
import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/charts/chart_card.dart';
import 'package:example/charts/chart_sources.g.dart';
import 'package:example/charts/specimens_area.dart';
import 'package:example/charts/specimens_radar.dart';
import 'package:example/site/pages/charts_gallery_page.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1600, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ThemeScope(
      controller: ThemeController(mode: ColorMode.light),
      child: const Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: MediaQueryData(size: Size(1600, 2400)),
          child: ChartsGalleryPage(),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('opens on the area family and renders one card per specimen', (
    WidgetTester tester,
  ) async {
    await _pump(tester);
    expect(
      find.byType(ChartSpecimenCard),
      findsNWidgets(areaSpecimens.length),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('the tab strip switches families', (WidgetTester tester) async {
    await _pump(tester);

    await tester.tap(find.text('Radar'));
    await tester.pumpAndSettle();

    expect(
      find.byType(ChartSpecimenCard),
      findsNWidgets(radarSpecimens.length),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('every family tab renders without throwing', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    for (final String family in <String>[
      'Bar',
      'Line',
      'Pie',
      'Radar',
      'Radial',
      'Tooltips',
    ]) {
      await tester.tap(find.text(family));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: family);
      expect(find.byType(ChartSpecimenCard), findsWidgets, reason: family);
    }
  });

  testWidgets('the first card copies its own generated source', (
    WidgetTester tester,
  ) async {
    final List<String> written = <String>[];

    tester.view.physicalSize = const Size(1600, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ThemeScope(
        controller: ThemeController(mode: ColorMode.light),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(size: Size(1600, 2400)),
            child: ChartsGalleryPage(
              clipboardWriter: (String text) async => written.add(text),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Copy code').first);
    await tester.pumpAndSettle();

    expect(written.single, chartSources[areaSpecimens.first.id]);
  });

  testWidgets('View Code opens a right sheet holding that source', (
    WidgetTester tester,
  ) async {
    await _pump(tester);

    await tester.tap(find.text('View Code').first);
    await tester.pumpAndSettle();

    expect(find.byType(SheetContent), findsOneWidget);
    expect(find.text(areaSpecimens.first.id), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
```

- [ ] **Step 2: Run to verify failure**

Run: `cd example && flutter test test/charts/charts_gallery_test.dart`
Expected: FAIL, `ChartsGalleryPage` is undefined.

- [ ] **Step 3: Write the page**

```dart
// example/lib/site/pages/charts_gallery_page.dart
/// `/charts`: every chart this system draws, as cards a reader can copy.
///
/// The split this page exists for is the reference's own: a gallery answers
/// "give me this chart", the component pages under `/components/chart*`
/// answer "how does the engine work". Neither page does both well, which is
/// why four API pages used to be the only charts a reader could find.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import '../../charts/chart_card.dart';
import '../../charts/chart_ink.dart';
import '../../charts/chart_specimen.dart';
import '../../charts/specimens_area.dart';
import '../../charts/specimens_bar.dart';
import '../../charts/specimens_line.dart';
import '../../charts/specimens_pie.dart';
import '../../charts/specimens_radar.dart';
import '../../charts/specimens_radial.dart';
import '../../charts/specimens_tooltip.dart';
import '../../docs/docs_copy_button.dart';

/// One tab: its label and the specimens under it.
class _Family {
  const _Family(this.label, this.specimens);

  final String label;
  final List<ChartSpecimen> specimens;
}

const List<_Family> _families = <_Family>[
  _Family('Area', areaSpecimens),
  _Family('Bar', barSpecimens),
  _Family('Line', lineSpecimens),
  _Family('Pie', pieSpecimens),
  _Family('Radar', radarSpecimens),
  _Family('Radial', radialSpecimens),
  _Family('Tooltips', tooltipSpecimens),
];

class ChartsGalleryPage extends StatefulWidget {
  const ChartsGalleryPage({
    super.key,
    this.onNavigate,
    this.clipboardWriter,
  });

  /// The site shell's navigator, passed by `main.dart`'s builder map.
  final void Function(String route)? onNavigate;

  /// Injected by tests so a copy can be observed without a platform channel.
  final DocsClipboardWriter? clipboardWriter;

  @override
  State<ChartsGalleryPage> createState() => _ChartsGalleryPageState();
}

class _ChartsGalleryPageState extends State<ChartsGalleryPage> {
  int _family = 0;

  /// The anchor `Browse Charts` scrolls to.
  final GlobalKey _tabsKey = GlobalKey();

  Future<void> _browse() async {
    final BuildContext? anchor = _tabsKey.currentContext;
    if (anchor == null) return;
    await Scrollable.ensureVisible(
      anchor,
      duration: Motion.medium,
      curve: Motion.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final ChartInk ink = ChartInk(theme);
    final _Family family = _families[_family];

    final List<ChartSpecimen> wide = family.specimens
        .where((ChartSpecimen s) => s.fullWidth)
        .toList();
    final List<ChartSpecimen> rest = family.specimens
        .where((ChartSpecimen s) => !s.fullWidth)
        .toList();

    Widget card(ChartSpecimen specimen) => ChartSpecimenCard(
      specimen: specimen,
      ink: ink,
      writer: widget.clipboardWriter,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _Hero(onBrowse: _browse, onNavigate: widget.onNavigate),
          SizedBox(height: space(10)),
          KeyedSubtree(
            key: _tabsKey,
            child: Tabs(
              items: <TabItem>[
                for (final _Family f in _families) TabItem(label: f.label),
              ],
              selectedIndex: _family,
              onChanged: (int next) => setState(() => _family = next),
            ),
          ),
          SizedBox(height: space(6)),
          for (final ChartSpecimen specimen in wide) ...<Widget>[
            card(specimen),
            SizedBox(height: space(6)),
          ],
          Grid(
            base: 1,
            md: 2,
            xl: 3,
            gap: space(6),
            matchHeights: false,
            children: <Widget>[for (final ChartSpecimen s in rest) card(s)],
          ),
          SizedBox(height: space(14)),
          _ComponentReference(onNavigate: widget.onNavigate),
        ],
      ),
    );
  }
}
```

Write `_Hero` and `_ComponentReference` in the same file:

- `_Hero` prints a title, one line of prose, and two buttons: `Browse Charts` (primary, calls `onBrowse`) and `Documentation` (secondary, calls `onNavigate?.call('/components/chart')`).
- `_ComponentReference` prints a small heading and four rows linking `/components/chart`, `/components/chart_cartesian`, `/components/chart_geometry` and `/components/chart_polar` with each entry's `title` and `description` read from `componentDocs`, not retyped. Import `package:example/components_docs/catalog.dart` and look each one up by `name`.

- [ ] **Step 4: Run the tests until green**

Run: `cd example && flutter test test/charts/charts_gallery_test.dart`
Expected: PASS, 5 tests.

If `find.text('Copy code')` misses, read `DocsCopyButton`'s real accessible name in `example/lib/docs/docs_copy_button.dart` and use that string. If `Motion.medium` or `Motion.easeOut` do not exist, find the real motion tokens:

```bash
cd .. && grep -rn "class Motion\b" -A 20 lib/src --include=*.dart | head -30
```

- [ ] **Step 5: Analyze and commit**

```bash
cd example && flutter analyze && flutter test
git add example/lib/site/pages/charts_gallery_page.dart example/test/charts/charts_gallery_test.dart
git commit -m "feat(charts): add the /charts gallery page"
```

---

## Task 15: Route the page and collapse the rail

**Files:**
- Modify: `example/lib/site/site_routes.dart`, `example/lib/main.dart`, `example/lib/components_docs/catalog.dart`, the four `example/lib/components_docs/chart*/meta.dart`, `example/lib/docs/docs_layout.dart`
- Test: `example/test/docs_sidebar_test.dart`

**Interfaces:**
- Consumes: `ChartsGalleryPage` from Task 14.
- Produces: `const String chartsRoute = '/charts';`

- [ ] **Step 1: Write the failing rail test**

Add to `example/test/docs_sidebar_test.dart`:

```dart
  test('the Charts rail group lists the gallery, not the four engine pages', () {
    final List<DocsSidebarGroup> groups = defaultSidebarGroups('/charts');
    final DocsSidebarGroup charts = groups.firstWhere(
      (DocsSidebarGroup g) => g.label == 'Charts',
    );

    expect(charts.items.map((DocsSidebarEntry e) => e.route), <String>[
      '/charts',
    ]);
  });

  test('the four chart component docs stay in the flat catalog', () {
    for (final String name in <String>[
      'chart',
      'chart_cartesian',
      'chart_geometry',
      'chart_polar',
    ]) {
      expect(
        componentDocs.any((ComponentDocEntry e) => e.name == name),
        isTrue,
        reason: name,
      );
    }
  });
```

If `defaultSidebarGroups` is private today, make it public rather than testing through the widget: read its current name with

```bash
cd example && grep -n "SidebarGroups" lib/docs/docs_layout.dart
```

and rename the function and its call sites in the same commit.

- [ ] **Step 2: Run to verify failure**

Run: `cd example && flutter test test/docs_sidebar_test.dart`
Expected: FAIL, the Charts group still holds four entries.

- [ ] **Step 3: Add the route**

In `site_routes.dart`, beside the other route constants:

```dart
const String chartsRoute = '/charts';
```

and in `siteRoutes`, after the `componentsRoute` entry:

```dart
  SiteRoute(
    path: chartsRoute,
    section: SiteSection.components,
    title: 'Charts',
    description:
        'Every chart this system draws, as cards you can copy: area, bar, '
        'line, pie, radar, radial and tooltips.',
    keywords: <String>['charts', 'graph', 'plot', 'recharts', 'dashboard'],
    showInSidebar: false,
  ),
```

`showInSidebar: false` because the Charts family group lists it, and listing it twice would put it in Sections as well.

In `main.dart`'s public builder map, beside the other entries:

```dart
      chartsRoute: ({onNavigate}) => ChartsGalleryPage(onNavigate: onNavigate),
```

- [ ] **Step 4: Add the catalog fields**

In `catalog.dart`, extend the entry:

```dart
class ComponentDocEntry {
  const ComponentDocEntry({
    required this.name,
    required this.title,
    required this.description,
    required this.dependencies,
    required this.exports,
    required this.sourcePath,
    this.showInRail = true,
  });

  /// Whether the documentation shell's rail lists this page under its family.
  ///
  /// The same trade `SiteRoute.showInSidebar` already makes for `/docs`:
  /// routable, searchable and listed on `/components`, absent only from the
  /// rail. The four chart pages set it `false` because `/charts` now leads
  /// that family and links them; they remain in [componentDocs], so the
  /// invariant this file states above — the rail and the index read one list —
  /// still holds. Only the rail's view of that one list narrows.
  final bool showInRail;
```

and extend the family:

```dart
enum ComponentDocFamily {
  components('Components', 'COMPONENTS'),
  effects('Effects', 'COMPONENTS / EFFECTS'),
  agent('Agent', 'COMPONENTS / AGENT'),
  charts('Charts', 'COMPONENTS / CHARTS', landingRoute: '/charts', landingTitle: 'Charts');

  const ComponentDocFamily(
    this.label,
    this.eyebrow, {
    this.landingRoute,
    this.landingTitle,
  });

  final String label;
  final String eyebrow;

  /// A page that leads this family in the rail, ahead of its components.
  final String? landingRoute;
  final String? landingTitle;
}
```

Set `showInRail: false` in all four of `chart/meta.dart`, `chart_cartesian/meta.dart`, `chart_geometry/meta.dart`, `chart_polar/meta.dart`.

- [ ] **Step 5: Teach the rail**

In `docs_layout.dart`, replace the family loop body:

```dart
    for (final ComponentDocFamily family in ComponentDocFamily.values)
      DocsSidebarGroup(
        label: family.label,
        items: <DocsSidebarEntry>[
          if (family.landingRoute != null)
            DocsSidebarEntry(
              title: family.landingTitle!,
              route: family.landingRoute!,
              selected: family.landingRoute == route,
            ),
          for (final ComponentDocEntry component in componentDocsIn(family))
            if (component.showInRail)
              DocsSidebarEntry(
                title: component.title,
                route: component.route,
                selected: component.route == route,
              ),
        ],
      ),
```

- [ ] **Step 6: Run the tests**

Run: `cd example && flutter test test/docs_sidebar_test.dart test/public_pages_test.dart test/site_routes_test.dart test/docs_pages_routing_test.dart`
Expected: PASS. `public_pages_test` must still find all four chart docs on `/components`; if it does not, the `showInRail` filter has leaked into `public_pages.dart`, which it must not.

- [ ] **Step 7: Commit**

```bash
cd example && flutter analyze
git add example/lib/site/site_routes.dart example/lib/main.dart example/lib/components_docs example/lib/docs/docs_layout.dart example/test/docs_sidebar_test.dart
git commit -m "feat(charts): route /charts and collapse the Charts rail group"
```

---

## Task 16: Verify the whole thing

**Owner:** orchestrator.

- [ ] **Step 1: Full suite**

Run: `cd example && flutter analyze && flutter test`
Expected: no analyzer issues; every test passing, including `docs_install_test.dart`, which must not have needed a change.

- [ ] **Step 2: Package suite**

Run: `flutter test` from the repository root.
Expected: unchanged. Nothing under `lib/src/` was touched, so a failure here means something leaked.

- [ ] **Step 3: See it**

Start the site preview, open `/charts`, and check by eye: the tab strip switches families, a card's Copy writes source, View Code slides a sheet in from the right with highlighted Dart, and the rail's Charts group holds one entry. Screenshot both themes.

- [ ] **Step 4: Report**

State what passed, what the counts were, and anything left undone. Do not claim completion without the test output in hand.

---

## Self-Review

**Spec coverage.** Route and rail: Task 15. Page anatomy: Task 14. The card: Task 13. Copy and View Code: Tasks 13 and 14. The specimen library: Tasks 4 to 11. Generated source: Tasks 3 and 12. Tests: Tasks 2, 3, 12, 14, 15, 16. Card copy harvest: Task 1. Every spec section maps to a task.

**Type consistency.** `ChartSpecimen`, `ChartSkeletonKind`, `ChartInk`, `ChartStateSwitch`, `chartCardCopy`, `chartSources`, `extractSpecimens`, `dartStringLiteral`, `collectSources`, `ChartSpecimenCard`, `ChartsGalleryPage`, `chartsRoute`, `showInRail`, `landingRoute`, `landingTitle` are each defined in exactly one task and spelled identically wherever a later task uses them.

**Known soft spots, called out rather than hidden.**

1. Task 3's extractor is written here as a `switch` with an illegal `combine:` label. The step says so and tells the implementer to write an `if / else if` chain. It is left visible because the control flow it describes is the flow that is wanted.
2. Task 13 names package identifiers (`Button`, `LucideIcons.trendingUp`, `IconSizes`, `Containers`, `Motion`) that were not read from source while planning. Step 2 of that task is a verification step with the exact greps to resolve them.
3. Task 2's panel count of 72 is an estimate from a grep, not a run. Its Step 2 says to take the number from the failure and never to change page source to match.
