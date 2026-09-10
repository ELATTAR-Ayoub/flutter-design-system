/// Card copy for every gallery specimen.
///
/// Harvested from shadcn's own per-variant view pages on 2026-09-09, not
/// written here: these cards reproduce the reference's registry variants, so
/// the words on them are the reference's words.
///
/// ## The footer's second line is not always a date, and that is not a bug
///
/// The reference's own families disagree about which line goes where. Read
/// off the live pages:
///
///  * **area** and **radar** put `Showing total visitors for the last 6
///    months` in the card *header* and `January - June 2024` in the footer.
///  * **bar**, **line**, **pie** and **radial** put the date in the *header*
///    and `Showing total visitors for the last 6 months` in the footer.
///
/// [trend] is therefore the footer's first line and [range] its second,
/// whatever each happens to say. Naming [range] after the common case and
/// documenting the exception beats inventing a normalisation the reference
/// does not have: the header line is dropped here anyway, because the card's
/// description slot carries the specimen's own note instead.
///
/// ## Two specimens have no harvested copy
///
/// `chart-radar-icons` and `chart-radar-radius` are in the registry and on
/// this system's reference page, but not on shadcn's radar gallery, which
/// shows twelve of the fourteen. Their titles follow the family's pattern and
/// their footers copy their siblings'. Both are marked below.
library;

class ChartCardCopy {
  const ChartCardCopy({required this.title, this.trend = '', this.range = ''});

  /// `<CardTitle>`, e.g. `Area Chart - Step`.
  final String title;

  /// The footer's first line. Always the trend statement where there is one.
  final String trend;

  /// The footer's second line. A date range on most families and a
  /// `Showing total visitors…` line on the rest; see the library note.
  final String range;

  /// Whether this specimen's card prints a footer band at all.
  ///
  /// The interactive variants and every tooltip specimen carry none on the
  /// reference, and a blank band is worse than no band.
  bool get hasFooter => trend.isNotEmpty || range.isNotEmpty;
}

/// The trend line every specimen that has a footer shares.
const String _trend = 'Trending up by 5.2% this month';

/// The footer's second line on area and radar.
const String _dates = 'January - June 2024';

/// The footer's second line on bar, line, pie and radial.
const String _showing = 'Showing total visitors for the last 6 months';

const Map<String, ChartCardCopy> chartCardCopy = <String, ChartCardCopy>{
  // ── Area ────────────────────────────────────────────────────────────────
  'chart-area-default': ChartCardCopy(
    title: 'Area Chart',
    trend: _trend,
    range: _dates,
  ),
  'chart-area-linear': ChartCardCopy(
    title: 'Area Chart - Linear',
    trend: _trend,
    range: _dates,
  ),
  'chart-area-step': ChartCardCopy(
    title: 'Area Chart - Step',
    trend: _trend,
    range: _dates,
  ),
  'chart-area-stacked': ChartCardCopy(
    title: 'Area Chart - Stacked',
    trend: _trend,
    range: _dates,
  ),
  'chart-area-stacked-expand': ChartCardCopy(
    title: 'Area Chart - Stacked Expanded',
    trend: _trend,
    range: _dates,
  ),
  'chart-area-legend': ChartCardCopy(
    title: 'Area Chart - Legend',
    trend: _trend,
    range: _dates,
  ),
  'chart-area-icons': ChartCardCopy(
    title: 'Area Chart - Icons',
    trend: _trend,
    range: _dates,
  ),
  'chart-area-gradient': ChartCardCopy(
    title: 'Area Chart - Gradient',
    trend: _trend,
    range: _dates,
  ),
  'chart-area-axes': ChartCardCopy(
    title: 'Area Chart - Axes',
    trend: _trend,
    range: _dates,
  ),
  'chart-area-interactive': ChartCardCopy(title: 'Area Chart - Interactive'),

  // ── Bar ─────────────────────────────────────────────────────────────────
  'chart-bar-default': ChartCardCopy(
    title: 'Bar Chart',
    trend: _trend,
    range: _showing,
  ),
  'chart-bar-horizontal': ChartCardCopy(
    title: 'Bar Chart - Horizontal',
    trend: _trend,
    range: _showing,
  ),
  'chart-bar-multiple': ChartCardCopy(
    title: 'Bar Chart - Multiple',
    trend: _trend,
    range: _showing,
  ),
  'chart-bar-stacked': ChartCardCopy(
    title: 'Bar Chart - Stacked + Legend',
    trend: _trend,
    range: _showing,
  ),
  'chart-bar-label': ChartCardCopy(
    title: 'Bar Chart - Label',
    trend: _trend,
    range: _showing,
  ),
  'chart-bar-label-custom': ChartCardCopy(
    title: 'Bar Chart - Custom Label',
    trend: _trend,
    range: _showing,
  ),
  'chart-bar-mixed': ChartCardCopy(
    title: 'Bar Chart - Mixed',
    trend: _trend,
    range: _showing,
  ),
  'chart-bar-active': ChartCardCopy(
    title: 'Bar Chart - Active',
    trend: _trend,
    range: _showing,
  ),
  'chart-bar-negative': ChartCardCopy(
    title: 'Bar Chart - Negative',
    trend: _trend,
    range: _showing,
  ),
  'chart-bar-interactive': ChartCardCopy(title: 'Bar Chart - Interactive'),

  // ── Line ────────────────────────────────────────────────────────────────
  'chart-line-default': ChartCardCopy(
    title: 'Line Chart',
    trend: _trend,
    range: _showing,
  ),
  'chart-line-linear': ChartCardCopy(
    title: 'Line Chart - Linear',
    trend: _trend,
    range: _showing,
  ),
  'chart-line-step': ChartCardCopy(
    title: 'Line Chart - Step',
    trend: _trend,
    range: _showing,
  ),
  'chart-line-multiple': ChartCardCopy(
    title: 'Line Chart - Multiple',
    trend: _trend,
    range: _showing,
  ),
  'chart-line-dots': ChartCardCopy(
    title: 'Line Chart - Dots',
    trend: _trend,
    range: _showing,
  ),
  'chart-line-dots-custom': ChartCardCopy(
    title: 'Line Chart - Custom Dots',
    trend: _trend,
    range: _showing,
  ),
  'chart-line-dots-colors': ChartCardCopy(
    title: 'Line Chart - Dots Colors',
    trend: _trend,
    range: _showing,
  ),
  'chart-line-label': ChartCardCopy(
    title: 'Line Chart - Label',
    trend: _trend,
    range: _showing,
  ),
  'chart-line-label-custom': ChartCardCopy(
    title: 'Line Chart - Custom Label',
    trend: _trend,
    range: _showing,
  ),
  'chart-line-interactive': ChartCardCopy(title: 'Line Chart - Interactive'),

  // ── Pie ─────────────────────────────────────────────────────────────────
  'chart-pie-simple': ChartCardCopy(
    title: 'Pie Chart',
    trend: _trend,
    range: _showing,
  ),
  'chart-pie-separator-none': ChartCardCopy(
    title: 'Pie Chart - Separator None',
    trend: _trend,
    range: _showing,
  ),
  'chart-pie-label': ChartCardCopy(
    title: 'Pie Chart - Label',
    trend: _trend,
    range: _showing,
  ),
  'chart-pie-label-custom': ChartCardCopy(
    title: 'Pie Chart - Custom Label',
    trend: _trend,
    range: _showing,
  ),
  'chart-pie-label-list': ChartCardCopy(
    title: 'Pie Chart - Label List',
    trend: _trend,
    range: _showing,
  ),
  'chart-pie-legend': ChartCardCopy(title: 'Pie Chart - Legend'),
  'chart-pie-donut': ChartCardCopy(
    title: 'Pie Chart - Donut',
    trend: _trend,
    range: _showing,
  ),
  'chart-pie-donut-active': ChartCardCopy(
    title: 'Pie Chart - Donut Active',
    trend: _trend,
    range: _showing,
  ),
  'chart-pie-donut-text': ChartCardCopy(
    title: 'Pie Chart - Donut with Text',
    trend: _trend,
    range: _showing,
  ),
  'chart-pie-stacked': ChartCardCopy(
    title: 'Pie Chart - Stacked',
    trend: _trend,
    range: _showing,
  ),
  'chart-pie-interactive': ChartCardCopy(title: 'Pie Chart - Interactive'),

  // ── Radar ───────────────────────────────────────────────────────────────
  'chart-radar-default': ChartCardCopy(
    title: 'Radar Chart',
    trend: _trend,
    range: _dates,
  ),
  'chart-radar-dots': ChartCardCopy(
    title: 'Radar Chart - Dots',
    trend: _trend,
    range: _dates,
  ),
  'chart-radar-lines-only': ChartCardCopy(
    title: 'Radar Chart - Lines Only',
    trend: _trend,
    range: _dates,
  ),
  'chart-radar-label-custom': ChartCardCopy(
    title: 'Radar Chart - Custom Label',
    trend: _trend,
    range: _dates,
  ),
  'chart-radar-grid-custom': ChartCardCopy(
    title: 'Radar Chart - Grid Custom',
    trend: _trend,
    range: _dates,
  ),
  'chart-radar-grid-none': ChartCardCopy(
    title: 'Radar Chart - Grid None',
    trend: _trend,
    range: _dates,
  ),
  'chart-radar-grid-circle': ChartCardCopy(
    title: 'Radar Chart - Grid Circle',
    trend: _trend,
    range: _dates,
  ),
  'chart-radar-grid-circle-no-lines': ChartCardCopy(
    title: 'Radar Chart - Grid Circle - No lines',
    trend: _trend,
    range: _dates,
  ),
  'chart-radar-grid-circle-fill': ChartCardCopy(
    title: 'Radar Chart - Grid Circle Filled',
    trend: _trend,
    range: _dates,
  ),
  'chart-radar-grid-fill': ChartCardCopy(
    title: 'Radar Chart - Grid Filled',
    trend: _trend,
    range: _dates,
  ),
  'chart-radar-multiple': ChartCardCopy(
    title: 'Radar Chart - Multiple',
    trend: _trend,
    range: _dates,
  ),
  'chart-radar-legend': ChartCardCopy(
    title: 'Radar Chart - Legend',
    trend: _trend,
    range: _dates,
  ),
  // Not on shadcn's radar gallery; title follows the family's pattern.
  'chart-radar-icons': ChartCardCopy(
    title: 'Radar Chart - Icons',
    trend: _trend,
    range: _dates,
  ),
  // Not on shadcn's radar gallery; title follows the family's pattern.
  'chart-radar-radius': ChartCardCopy(
    title: 'Radar Chart - Radius Axis',
    trend: _trend,
    range: _dates,
  ),

  // ── Radial ──────────────────────────────────────────────────────────────
  'chart-radial-simple': ChartCardCopy(
    title: 'Radial Chart',
    trend: _trend,
    range: _showing,
  ),
  'chart-radial-label': ChartCardCopy(
    title: 'Radial Chart - Label',
    trend: _trend,
    range: _showing,
  ),
  'chart-radial-grid': ChartCardCopy(
    title: 'Radial Chart - Grid',
    trend: _trend,
    range: _showing,
  ),
  'chart-radial-text': ChartCardCopy(
    title: 'Radial Chart - Text',
    trend: _trend,
    range: _showing,
  ),
  'chart-radial-shape': ChartCardCopy(
    title: 'Radial Chart - Shape',
    trend: _trend,
    range: _showing,
  ),
  'chart-radial-stacked': ChartCardCopy(
    title: 'Radial Chart - Stacked',
    trend: _trend,
    range: _showing,
  ),

  // ── Tooltips ────────────────────────────────────────────────────────────
  // None of the nine carries a footer on the reference.
  'chart-tooltip-default': ChartCardCopy(title: 'Tooltip - Default'),
  'chart-tooltip-indicator-line': ChartCardCopy(
    title: 'Tooltip - Line Indicator',
  ),
  'chart-tooltip-indicator-none': ChartCardCopy(
    title: 'Tooltip - No Indicator',
  ),
  'chart-tooltip-label-custom': ChartCardCopy(title: 'Tooltip - Custom label'),
  'chart-tooltip-label-formatter': ChartCardCopy(
    title: 'Tooltip - Label Formatter',
  ),
  'chart-tooltip-label-none': ChartCardCopy(title: 'Tooltip - No Label'),
  'chart-tooltip-formatter': ChartCardCopy(title: 'Tooltip - Formatter'),
  'chart-tooltip-icons': ChartCardCopy(title: 'Tooltip - Icons'),
  'chart-tooltip-advanced': ChartCardCopy(title: 'Tooltip - Advanced'),
};
