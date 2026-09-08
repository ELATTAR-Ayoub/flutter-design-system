# The charts gallery — design

**Date:** 2026-09-09
**Branch:** `main`
**Status:** design, approved in conversation, not yet planned

## What this supersedes

Part 1 of `2026-08-26-charts-and-site-fixes-design.md`. None of it was built:
there is no `/charts` route today, the four chart component pages are still
four, and `pages/charts.dart` is still 6128 lines. Parts 2 and 3 of that
document are untouched by this one.

Three decisions changed since then, all from the owner:

1. **One page with a family toggle**, not six routes. The reader switches
   between Area, Bar, Line, Pie, Radar, Radial and Tooltips in place.
2. **Tooltips is a tab.** The earlier spec deliberately dropped it.
3. **The four component docs are kept whole**, not collapsed into one page
   with three redirects. They leave the sidebar rail and are reached from the
   gallery instead. This also means `docs_install_test.dart` keeps passing
   unchanged, where the earlier plan required extending it with a
   many-names-to-one-page mapping.

## Why

The charts a reader wants to copy are buried. Seventy working specimens live
inside a single 6128-line reference page at
`/design-system/components/base/charts`, presented as bare plots in a two-up
grid of documentation panels. The four pages the sidebar does show (Chart,
Chart Cartesian, Chart Geometry, Chart Polar) are API references for the
engine, which is what someone extending the chart widgets needs and not what
someone building a dashboard needs.

shadcn solves this by separating "copy this" from "read this". `/charts` is a
gallery of finished cards; `/docs/components/chart` is the reference. We adopt
the split.

## Reference

`https://ui.shadcn.com/charts/area`, read directly. Each chart is a complete
Card, not a bare plot:

* `CardHeader` with a title (`Area Chart - Gradient`) and a description
  (`Showing total visitors for the last 6 months`).
* `CardContent` holding the plot.
* `CardFooter` with two lines: a trend statement with an arrow
  (`Trending up by 5.2% this month`) and a range (`January - June 2024`).
* A toolbar above each card carrying the block name on the left, and Copy and
  View Code on the right.
* The interactive variant is full width; the rest sit in a three-up grid.

## Scope

**In:** a new `/charts` page; extraction of the seventy specimens into a
shared library; generation of the copyable source; the rail change.

**Out:** re-authoring any chart. Every specimen already works and is
re-housed, not rewritten. The reference page at
`/design-system/components/base/charts` keeps its current appearance and its
drift register. Nothing under `lib/src/` changes.

---

## 1. Route and rail

`/charts` is a `SiteRoute`, not a `ComponentDocEntry`. It documents no
registry item and has no exports, dependencies or source path, so a catalog
entry would be a false one.

The rail's Charts group collapses from four entries to one. The mechanism
follows the precedent `SiteRoute.showInSidebar` already sets for `docsRoute`:
routable and searchable, absent from the rail.

* `ComponentDocFamily` gains `landingRoute` and `landingTitle`, both nullable.
  Only `charts` sets them.
* `ComponentDocEntry` gains `showInRail`, defaulting to `true`. The four chart
  entries set it `false`.
* `docs_layout.dart` renders, per family, the landing entry first (when the
  family declares one) and then its entries where `showInRail` is true.

`componentDocs` stays the complete flat catalog. The `/components` index
(`public_pages.dart`) keeps listing all four, so the catalog's stated
invariant holds: the rail and the index still read one list, and only the
rail's view of it narrows. That invariant's docstring in `catalog.dart` is
updated to record the exception and why it exists.

## 2. Page anatomy

```
hero          title, blurb, [Browse Charts] [Documentation]
Tabs          Area | Bar | Line | Pie | Radar | Radial | Tooltips
  full row    specimens flagged fullWidth (the interactive ones)
  Grid        base 1, md 2, xl 3, the rest
component     four links: Chart, Chart Cartesian, Chart Geometry, Chart Polar
reference
```

`Browse Charts` scrolls to the tab strip. `Documentation` navigates to
`/components/chart`.

The component reference block at the foot is not decoration. Once the rail
stops listing the four, that block and the CTA are the only paths to
`chart-cartesian`, `chart-geometry` and `chart-polar`. A page a reader cannot
open does not belong in a catalog, and the same rule applies to a page a
reader can no longer find.

The family switch is `Tabs` with `TabItem`, seven items. Not `ToggleGroup`:
this selects between panels of content, which is what `Tabs` means.

## 3. The card

One `ChartSpecimenCard` per specimen:

```
toolbar     chart-area-step                    [Copy] [View Code]
Card
├─ CardHeader      CardTitle        "Area Chart - Step"
│                  CardDescription  "type=step"
├─ ToggleGroup     Empty | Loading | Ready
├─ CardContent     the plot, 256px
└─ CardFooter      "Trending up by 5.2% this month" with a trend glyph
                   "January - June 2024"
```

**Title** is shadcn's, verbatim. **Description** is the specimen's existing
spec note from `pages/charts.dart`, which carries real information
(`type=step`, `shared stackId`, `stackOffset=expand`) where shadcn's
description repeats one sentence seventy times. **Footer** is shadcn's trend
and range copy, harvested from the seventy view pages rather than invented.

The toolbar sits above the card, outside it, where shadcn puts it.
`CardHeader` does have an `action` slot, but the interactive variants need it
for their range picker; putting a toolbar there on the other sixty-six would
leave the two kinds of card disagreeing about what the top-right corner
means.

The Empty/Loading/Ready toggle is kept on every card. shadcn has no such
control; this system documents its states, and the loading skeleton is sized
from the same 256px constant the plot is, so the two match by construction.

## 4. Copy and View Code

**Copy** is `DocsCopyButton`, unchanged. It already rolls the glyph through
`IconSwap` across idle, pending and copied, writes through an injectable
`DocsClipboardWriter` so a test can observe it without a platform channel, and
raises a toast.

**View Code** is `SheetOverlay(side: SheetSide.right)`. Its `SheetContent`
carries the specimen title, the id, the highlighted source, and its own copy
button. Highlighting is `docsTokenise(code, 'dart')`, already used by the
component doc pages. The body scrolls in both directions; source is never
re-wrapped, on the same reasoning `CodeBlock` gives.

## 5. The specimen library

The seventy specimens are private functions inside `pages/charts.dart` today.
They move to a shared library that both pages read, so the gallery and the
reference page cannot drift apart:

```
example/lib/charts/
  chart_specimen.dart      the descriptor
  chart_ink.dart           token slots (today's _ChartInk)
  chart_states.dart        Empty/Loading/Ready and the four skeletons
  chart_data.dart          fixtures (today's month, browser and radar rows)
  specimens_area.dart      10
  specimens_bar.dart       10
  specimens_line.dart      10
  specimens_pie.dart       11
  specimens_radar.dart     14
  specimens_radial.dart     6
  specimens_tooltip.dart    9
  chart_sources.g.dart     generated
```

The descriptor:

```dart
class ChartSpecimen {
  const ChartSpecimen({
    required this.id,          // 'chart-area-step', the registry name
    required this.title,       // 'Area Chart - Step'
    required this.note,        // 'type=step'
    required this.trend,       // 'Trending up by 5.2% this month'
    required this.range,       // 'January - June 2024'
    required this.skeleton,
    required this.build,
    this.fullWidth = false,
  });

  final Widget Function(BuildContext context, ChartInk ink) build;
  // …
}
```

Each family file exports one `List<ChartSpecimen>`. The gallery is then
data-driven: a tab renders its list, and adding a specimen is adding a record.

`pages/charts.dart` imports the same library and keeps its own presentation
(`Panel`, its prose, its drift register, its token block, its animation
section, unit activity and conversion funnel). Its specimen bodies are the
only thing that moves. Its rendered appearance must not change.

## 6. Generating the copyable source

What a reader copies must be what the page compiles. The source is therefore
extracted from the specimen files rather than authored beside them.

**Marker.** A line comment directly above each declaration to extract:

```dart
// specimen: chart-area-step
Widget areaStep(ChartInk ink) => plot(...);
```

**Extractor.** `example/tool/chart_sources/extractor.dart`, plain Dart with no
Flutter import. It scans the seven specimen files, and for each marker
captures from the following line to the end of that declaration by balanced
brace and paren scanning that skips string literals, interpolations and
comments. It returns `Map<String, String>` keyed by id.

**CLI.** `example/tool/chart_sources/generate.dart` writes
`example/lib/charts/chart_sources.g.dart`:

```dart
// GENERATED. Do not edit. Run: dart run tool/chart_sources/generate.dart
const Map<String, String> chartSources = <String, String>{ ... };
```

Entries are emitted as ordinary single-quoted Dart string literals with
backslash, dollar and quote escaped, not raw triple-quoted strings: a specimen
containing a triple quote would otherwise close the literal, and one
containing a dollar sign would interpolate.

**Guard.** `example/test/chart_sources_guard_test.dart` imports the extractor
directly, re-runs it over the same files, and compares against the committed
map. It fails with the command to regenerate. The extractor is a library
precisely so the test does not shell out to `dart run`.

**Ordering.** The generated map is emitted in a stable order (family, then
declaration order) so a regeneration produces no spurious diff.

## 7. Tests

| Test | Asserts |
| --- | --- |
| `chart_sources_guard_test.dart` | the generated map matches the source |
| `charts_gallery_test.dart` | each of the seven tabs renders its cards; counts match the family lists |
| | Copy writes the specimen's exact source through an injected writer |
| | View Code opens a right sheet showing that specimen's source |
| | the state toggle swaps plot, skeleton and empty |
| `docs_sidebar_test.dart` | the Charts rail group holds one entry, `/charts` |
| `public_pages_test.dart` | the `/components` index still lists all four chart docs |
| `site_routes_test.dart` | `/charts` is declared and reachable |
| `docs_install_test.dart` | unchanged, and still green: the four pages still exist |

The reference page has no test of its own today. One is added asserting it
still renders its seventy specimens after the extraction, because a refactor
of that size with no coverage is how appearance changes get shipped silently.

## 8. Consequences, stated

* **The rail stops advertising the engine docs.** Three of the four become
  two clicks away rather than one. Accepted: they are reference material for
  someone extending the chart widgets, and the gallery links them.
* **A third page shape.** `/charts` is neither a component doc page nor a
  prose page. Accepted; it follows the reference.
* **`pages/charts.dart` is edited without being redesigned.** The risk is an
  invisible appearance change during extraction. The new render test is the
  control.
* **Seventy trend and range strings are copied from shadcn.** They are the
  reference's own card copy, on a page that already reproduces the
  reference's registry variants.

## Risks

* **The extraction is mechanical but large.** Seventy functions, four helper
  clusters and a fixture set move between files. Done family by family, each
  step compiling and testable on its own.
* **The extractor is a small Dart parser.** Balanced scanning over real source
  with strings, interpolation, raw strings and comments is where this bites.
  It is covered by its own unit tests over hand-written fixtures before it is
  pointed at the specimen files.
* **`Grid` has no per-cell span**, so the full-width interactive card is a
  separate single-column grid above the three-up one rather than a spanning
  cell. This matches shadcn's own layout, so it costs nothing here.
