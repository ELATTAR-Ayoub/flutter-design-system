/// The plot container, the shared X axis, the month/date formatters and the
/// range-select strip every chart family reads.
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

/// `value.slice(0, 3)`: the three-letter month every cartesian axis prints.
String month3(Object? value) => '$value'.substring(0, 3);

/// `new Date(v).toLocaleDateString("en-US", { month: "short", day: "numeric" })`.
String shortDate(Object? value) {
  final DateTime d = DateTime.parse('$value');
  return '${DateFormat.monthsShort[d.month - 1]} ${d.day}';
}

/// …with `year: "numeric"`: the two interactive tooltips.
String _shortDateYear(Object? value) {
  final DateTime d = DateTime.parse('$value');
  return '${DateFormat.monthsShort[d.month - 1]} ${d.day}, ${d.year}';
}

String shortDateYearLabel(String label, List<ChartTooltipItem> items) =>
    _shortDateYear(label);

/// The bar's corner radius, off the ladder.
///
/// `bar.tsx` reads `--radius-sm` from the live stylesheet rather than typing
/// the registry's 8 / 5 / 4, and says why at length: *"§0's radius family, 2 ·
/// 6 · 10 · 12 · 16 · 20 · 24 · 999: has no 8, no 5 and no 4 in it… The
/// registry's 8 / 5 / 4 are not a considered distinction: they are the same
/// bar drawn three ways across ten files: and 6px is where they average."*
/// The port names the rung instead of reading it, which is the same single
/// source of truth with one fewer indirection.
const double barRadius = Radii.sm;

/// `[0, 0, r, r]`: the bottom of a stack.
const List<double> radiiBottom = <double>[0, 0, barRadius, barRadius];

/// `[r, r, 0, 0]`: the top of one.
const List<double> radiiTop = <double>[barRadius, barRadius, 0, 0];

/// All four corners.
const List<double> radiiAll = <double>[
  barRadius,
  barRadius,
  barRadius,
  barRadius,
];

/// `BROWSER_CONFIG`'s labels, as a formatter: the registry writes the same
/// lookup inline on three axes.
String browserLabel(String key) => switch (key) {
  'chrome' => 'Chrome',
  'safari' => 'Safari',
  'firefox' => 'Firefox',
  'edge' => 'Edge',
  'other' => 'Other',
  _ => key,
};

/// The registry writes ``fill={`var(--color-${activeChart})`}``: at runtime
/// exactly `var(--color-desktop)`, the `--color-<seriesKey>` pattern rule 1
/// forbids. A lookup keeps the per-series colour without assembling that string.
Color seriesColour(ChartInk ink, String key) =>
    key == 'desktop' ? ink.slot(1) : ink.slot(2);

/// The plot, in the container every specimen shares.
Widget plot(ChartConfig config, Widget chart) =>
    ChartContainer(config: config, child: chart);

/// The X axis nine of the ten area variants share, byte for byte.
ChartAxis monthAxis() => const ChartAxis(
  dataKey: 'month',
  tickLine: false,
  axisLine: false,
  tickMargin: 8,
  tickFormatter: month3,
);

/// The `Select` strip, rendering unconditionally with `children` exactly once —
/// the two obligations `state.tsx` puts on anything passed to `controls`.
class RangeStrip extends StatelessWidget {
  const RangeStrip({
    super.key,
    required this.value,
    required this.onChanged,
    required this.child,
    this.width,
    this.label = 'Select a range',
    this.placeholder = 'Last 3 months',
    this.options = _rangeOptions,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final Widget child;
  final double? width;
  final String label;
  final String placeholder;
  final List<SelectOption<String>> options;

  /// `w-40` on the area strip.
  static double get rangeWidth => space(40);

  /// `w-36` on the pie strip.
  static double get monthWidth => space(36);

  static const List<SelectOption<String>> _rangeOptions =
      <SelectOption<String>>[
        SelectOption<String>(value: '90d', label: 'Last 3 months'),
        SelectOption<String>(value: '30d', label: 'Last 30 days'),
        SelectOption<String>(value: '7d', label: 'Last 7 days'),
      ];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      Align(
        alignment: Alignment.centerRight,
        child: Select<String>(
          width: width ?? rangeWidth,
          label: label,
          placeholder: placeholder,
          value: value,
          onChanged: onChanged,
          options: options,
        ),
      ),
      // `mb-5`.
      SizedBox(height: space(5)),
      child,
    ],
  );
}

/// The two clickable totals, and the series they switch between.
///
/// Inline, this strip made the panel 94px taller in `ready` than in the other
/// two states: measured 393.39 → 487.78: which is §5's *"a layout jump is
/// worse than the spinner it was meant to avoid"*.
///
/// **The selection travels.** §4: *"a group of options owns ONE pill that
/// physically slides from the old selection to the new one… Options never own
/// their own selected background… Applies to `ToggleGroup` and `Tabs`, and to
/// anything like them you add later."* `ToggleGroup` itself does not drop in —
/// its variants are built for label-sized items and these tiles carry a
/// `Stat`-sized figure: but the travel is [ActiveIndicator]'s, and that is
/// reusable on its own.
///
/// **The pill carries the series' colour, and only below the text.** `bar.tsx`
/// derives it in full: `--muted-foreground` measures 4.83:1 on `--card`, so the
/// only flat tint of a chart token that keeps an 11px `type-label` above AA is
/// 4%, and at 4% the two active states are the same colour. So the tint stops
/// before it reaches the text: the bottom half of the pill carries it, the top
/// half, where the label sits, carries none.
class SeriesStrip extends StatefulWidget {
  const SeriesStrip({
    super.key,
    required this.ink,
    required this.slot,
    required this.child,
  });

  final ChartInk ink;

  /// Which key the strip is for, `bar-series-option` or `line-series-option`.
  final String slot;

  final Widget child;

  /// `desktop` / `mobile`, in the registry's order.
  static const List<String> series = <String>['desktop', 'mobile'];

  /// The running totals over all 91 days.
  static int total(String key) => dailyVisits.fold<int>(
    0,
    (int acc, Map<String, Object?> row) => acc + (row[key]! as int),
  );

  @override
  State<SeriesStrip> createState() => _SeriesStripState();
}

class _SeriesStripState extends State<SeriesStrip> {
  int _active = 0;

  /// `to-50%`: the tint reaches exactly halfway and no further, which is what
  /// keeps the `type-label` on `--card` rather than on `--muted`.
  static const double _tintStop = 0.5;

  /// `from-chart-N/40`.
  static const double _tintAlpha = 0.4;

  /// `border-b-2`: full saturation where no text sits.
  static const double _ruleHeight = 2;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Color colour = widget.ink.slot(_active + 1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(
              color: theme.border,
              width: BorderWidths.hairline,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Radii.lg),
            // Two `Stat` tiles at 200% text can outgrow the strip's own
            // width; [ActiveIndicator]'s row is intrinsically sized (it has
            // to be, to track the sliding fill under whichever tile is
            // active), so it scrolls horizontally rather than compressing
            // the figures it is tracking.
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ActiveIndicator(
                activeIndex: _active,
                indicator: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const <double>[0, _tintStop],
                      colors: <Color>[
                        colour.withValues(alpha: _tintAlpha),
                        colour.withValues(alpha: 0),
                      ],
                    ),
                    border: Border(
                      bottom: BorderSide(color: colour, width: _ruleHeight),
                    ),
                  ),
                  child: const SizedBox.expand(),
                ),
                children: <Widget>[
                  for (int i = 0; i < SeriesStrip.series.length; i++)
                    _SeriesTile(
                      label: i == 0 ? 'Desktop' : 'Mobile',
                      value: chartNumber(
                        SeriesStrip.total(SeriesStrip.series[i]),
                      ),
                      swatch: widget.ink.slot(i + 1),
                      leadingBorder: i > 0,
                      onTap: () => setState(() => _active = i),
                    ),
                ],
              ),
            ),
          ),
        ),
        // `mb-5`.
        SizedBox(height: space(5)),
        SeriesScope(series: SeriesStrip.series[_active], child: widget.child),
      ],
    );
  }
}

/// One tile: a `Stat` and a swatch, in a control.
class _SeriesTile extends StatelessWidget {
  const _SeriesTile({
    required this.label,
    required this.value,
    required this.swatch,
    required this.leadingBorder,
    required this.onTap,
  });

  final String label;
  final String value;
  final Color swatch;
  final bool leadingBorder;
  final VoidCallback onTap;

  /// `size-3 rounded-xs`: the same swatch `PieInteractiveControls` uses, so
  /// the two interactive pickers share one idiom rather than inventing a
  /// second.
  static double get swatchSize => space(3);

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: leadingBorder
              ? Border(
                  left: BorderSide(
                    color: theme.border,
                    width: BorderWidths.hairline,
                  ),
                )
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: space(4),
            vertical: space(3),
          ),
          child: Stack(
            children: <Widget>[
              Stat(label: label, value: value),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: swatchSize,
                  height: swatchSize,
                  decoration: BoxDecoration(
                    color: swatch,
                    borderRadius: BorderRadius.circular(Radii.xs),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The context the series strip hands down through the keyed slot.
class SeriesScope extends InheritedWidget {
  const SeriesScope({super.key, required this.series, required super.child});

  final String series;

  static String of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SeriesScope>()?.series ??
      'desktop';

  @override
  bool updateShouldNotify(SeriesScope old) => old.series != series;
}
