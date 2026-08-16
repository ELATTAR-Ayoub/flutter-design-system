/// `components/ui/chart.tsx` — the official shadcn wrapper, ported.
///
/// The reference's own header is the most useful thing to carry over, because
/// almost every line of that file is a **defence** rather than a style:
///
/// > `.recharts-cartesian-axis-tick text` matches NOTHING in recharts 3.8. The
/// > tick label moved to `<g class="recharts-cartesian-axis-tick-label">` and
/// > the `<text>` carries `recharts-cartesian-axis-tick-value`, so the stock
/// > selector silently stopped applying and every axis label kept recharts' own
/// > inline `fill="#666"` — 3.46:1 on `--background` in dark, 5.74:1 in light.
/// > The polar tick was worse in the other direction: `#808080` measures 5.04:1
/// > dark and 3.95:1 light. Each theme was failing AA on one of the two axis
/// > families, with a colour from outside the system in both. On
/// > `--muted-foreground` they are 13.46:1 dark and 4.83:1 light.
///
/// A Flutter port has no vendored default to fight, so those selectors become
/// what they were always trying to be: every tick label, on every axis family,
/// paints `--muted-foreground`. The comment is kept because the *reason* the
/// class list is shaped that way is the finding, and a port that silently
/// dropped it would lose the only record of it.
///
/// Three of the sweep's other targets survive as real behaviour here and are
/// named at their call sites: a `Pie`/`Sector`'s `stroke="#fff"` becomes
/// transparent, a `RadialBar`'s background sector paints `--muted` rather than
/// recharts' `#eee`, and the cartesian grid's `#ccc` becomes `--border` at half
/// strength.
///
/// **`ChartStyle` is not ported, and that is the reference's own decision.**
/// shadcn mints a `--color-<seriesKey>` custom property per container so one
/// config can carry a light value and a dark one; the charts page's own
/// "Why the fills here do not go through ChartStyle" note explains that this
/// system does not need the second layer, because `--chart-1` … `-5` are
/// already declared once per theme. A [DsChartSeries] therefore carries a
/// resolved [Color], and the page resolves it from [DsTheme] on the way in.
library;

import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';
import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';

/* ── Type roles ──────────────────────────────────────────────────────────── */

/// The two text classes the chart family renders in, neither of which is a
/// `.type-*` class.
///
/// `ChartContainer` sets `text-xs` on the whole subtree, and every label a
/// chart draws — axis ticks, legend keys, tooltip names, `LabelList` values —
/// inherits it. `text-xs` is 12px with Tailwind's own
/// `--text-xs--line-height: calc(1 / .75)`, i.e. a 16px line box, at the
/// inherited weight 400.
///
/// These live here rather than in `foundation/typography.dart` for the reason
/// `toaster.dart`'s `titleSpec` and `field.dart`'s `normal` already do: they
/// are **component roles**, not rungs of the type scale, and the file that owns
/// the role owns the spec.
class DsChartText {
  const DsChartText._();

  /// `text-xs` — the class `ChartContainer` puts on everything it contains.
  ///
  /// Measured on the live container: `font-size: 12px`, `line-height: 16px`,
  /// `font-family: "Inter Local"`.
  static final DsTypeSpec xs = DsTypeSpec(
    family: DsFonts.sans,
    size: 12,
    height: 16 / 12,
  );

  /// `font-medium` on the tooltip's own label row.
  static final DsTypeSpec xsMedium = DsTypeSpec(
    family: DsFonts.sans,
    size: 12,
    height: 16 / 12,
    wght: 500,
  );

  /// `leading-none` — the tooltip's series name, whose row is measured at
  /// 14.4px because the value beside it is `.type-num-sm` and taller.
  static final DsTypeSpec xsTight = DsTypeSpec(
    family: DsFonts.sans,
    size: 12,
    // `leading-none` IS the ratio 1 — a CSS keyword with no token behind it,
    // and the reason this row measures 14.4px and not 16.
    height: 1, // allow-hardcoded: `leading-none`, a keyword not a token.
  );
}

/* ── Config ──────────────────────────────────────────────────────────────── */

/// One entry of `ChartConfig` — a label, a colour, and an optional icon.
///
/// The icon slot is the one piece of the reference that could not be routed
/// through the system's own `Icon` component: `ChartConfig["icon"]` is typed
/// `React.ComponentType` and rendered zero-prop, so `area.tsx` and `radar.tsx`
/// pass bare Lucide components and `tooltip.tsx` wraps `Icon` in a zero-arg
/// component to get the size and tone back. Flutter has no such constraint —
/// the builder receives a [BuildContext] and every call site uses [DsIcon] —
/// but the shape is kept so the four `icons` variants read the same way, and
/// every call site fills it with `DsIcon`.
class DsChartSeries {
  const DsChartSeries({this.label, this.color, this.icon});

  /// The human name — what the tooltip row and the legend key print. Without
  /// it a tooltip row says `running`, because that is the key in the data.
  final String? label;

  /// The series' own colour. Always one of the five chart tokens at every call
  /// site on the page; null for a value key like `visitors`, which carries the
  /// axis label and deliberately has no colour.
  final Color? color;

  /// `<itemConfig.icon />` — rendered in the tooltip's indicator slot and in
  /// the legend key's swatch slot when present.
  final WidgetBuilder? icon;
}

/// `ChartConfig` — every series key mapped to its label and colour.
///
/// The charts page calls this "the one piece of a chart that is worth writing
/// before the chart itself".
class DsChartConfig {
  const DsChartConfig(this.entries);

  final Map<String, DsChartSeries> entries;

  DsChartSeries? operator [](String key) => entries[key];

  /// `getPayloadConfigFromPayload` — resolve a row to its config entry.
  ///
  /// The indirection exists for pies and radial bars, whose series key is the
  /// *value* (`visitors`) and whose name lives on the datum (`browser`). The
  /// reference looks the key up on the payload first and falls back to the key
  /// itself; both halves are reproduced.
  DsChartSeries? resolve(String key, Map<String, Object?>? payload) {
    final Object? onPayload = payload?[key];
    if (onPayload is String && entries.containsKey(onPayload)) {
      return entries[onPayload];
    }
    return entries[key];
  }

  /// The label to print for [key], falling back to the key itself.
  String labelFor(String key, [Map<String, Object?>? payload]) =>
      resolve(key, payload)?.label ?? key;

  /// A config with [extra] merged over it — the `{...DESKTOP_MOBILE_CONFIG,
  /// other: {...}}` spread every variant uses to add one key.
  DsChartConfig plus(Map<String, DsChartSeries> extra) => DsChartConfig(
        <String, DsChartSeries>{...entries, ...extra},
      );
}

/// Carries the config down to whatever renders inside a [DsChartContainer].
class DsChartScope extends InheritedWidget {
  const DsChartScope({
    super.key,
    required this.config,
    required super.child,
  });

  final DsChartConfig config;

  /// `useChart()` — throws in the reference when there is no container. Here
  /// it returns an empty config instead, because a Flutter widget test that
  /// mounts a tooltip on its own is a legitimate thing to do and the reference
  /// has no equivalent of it.
  static DsChartConfig of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<DsChartScope>()
          ?.config ??
      const DsChartConfig(<String, DsChartSeries>{});

  @override
  bool updateShouldNotify(DsChartScope old) => old.config != config;
}

/* ── Motion ──────────────────────────────────────────────────────────────── */

/// `components/ds/chart-motion.ts` — the entrance timing, read rather than
/// typed.
///
/// The reference's whole point is that recharts takes `animationDuration` as a
/// raw number and `animationEasing` as a string, so neither is a class and
/// neither is visible to `check:tokens`: **a hardcoded 800 passes every guard
/// in that repository and is still wrong.** Its answer is to read
/// `--duration-slow` off the live stylesheet. The Flutter port has the token in
/// hand, so the equivalent statement is to name it — [DsDurations.slow].
///
/// **The easing is the half that failed, and the port reproduces the failure.**
/// `recharts/types/util/types.d.ts` declares `AnimationTiming` as five
/// keywords, so `--ease-out`'s `cubic-bezier(0.22, 1, 0.36, 1)` cannot be
/// assigned; what is passed is the keyword `ease-out`, which is CSS's
/// `cubic-bezier(0, 0, 0.58, 1)` and a visibly different curve. Reproducing the
/// port on [DsCurves.out] would make the Flutter charts *better* than the
/// reference and therefore wrong, so [curve] is [DsCurves.cssEaseOut] and the
/// page documents the difference exactly as the reference's Animation section
/// does.
///
/// Reduced motion is resolved by the caller through `dsAnimationDuration`
/// (`foundation/motion.dart`), which is the port's equivalent of the hook's
/// `isAnimationActive: false` —
/// and it matters for the same §4.3 reason: recharts animates by interpolating
/// the geometry it draws, so a bar that only reaches its value by animating is
/// a chart that shows a number the data does not contain.
class DsChartMotion {
  const DsChartMotion._();

  /// `--duration-slow`, as `useChartMotion` reads it.
  static Duration get duration => DsDurations.slow;

  /// The CSS keyword `ease-out`, which is what recharts received.
  static Curve get curve => DsCurves.cssEaseOut;
}

/* ── Container ───────────────────────────────────────────────────────────── */

/// `ChartContainer` — the box every specimen's plot lives in.
///
/// `className={PLOT}` is `h-64 w-full` on all 70, so [height] defaults to that
/// 256 and the width is whatever the panel offers. Measured inside a 532-wide
/// `Panel` with `p-6`: **482 × 256**, which is the footprint every skeleton and
/// the empty state hold too (`data.ts`'s `PLOT` is deliberately one constant
/// shared by all three).
///
/// `aspect-video` is in the class list and is beaten by `h-64` at every call
/// site, so it is recorded and not implemented — the same treatment
/// `data-vertical:*` got on the slider.
class DsChartContainer extends StatelessWidget {
  const DsChartContainer({
    super.key,
    required this.config,
    required this.child,
    this.height,
  });

  final DsChartConfig config;

  /// The plot. Usually one of the six chart widgets in `chart_cartesian.dart`
  /// or `chart_polar.dart`.
  final Widget child;

  /// `h-64` — `PLOT`'s own 256, and the number §5 asks a skeleton to match.
  static double get plotHeight => ds(64);

  final double? height;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsChartScope(
      config: config,
      child: SizedBox(
        height: height ?? plotHeight,
        width: double.infinity,
        child: DefaultTextStyle(
          // `text-xs` on the container, inherited by every label inside it.
          style: DsText.styleOf(context, DsChartText.xs,
              color: theme.mutedForeground),
          // `justify-center` — the plot is centred in whatever width it gets.
          child: Center(child: child),
        ),
      ),
    );
  }
}

/* ── Tooltip ─────────────────────────────────────────────────────────────── */

/// `ChartTooltipContent`'s `indicator` prop.
///
/// The page's own note: *"Cosmetic, except that dashed conventionally marks a
/// projection — do not spend it on a plain second series."*
enum DsChartIndicator { dot, line, dashed }

/// One row of a tooltip.
class DsChartTooltipItem {
  const DsChartTooltipItem({
    required this.name,
    required this.value,
    this.color,
    this.payload,
    this.dataKey,
  });

  /// The series key — `running`, `desktop`, or a datum's own name field.
  final String name;

  /// The number the row prints. `toLocaleString()` in the reference, which is
  /// grouped thousands.
  final num? value;

  /// `item.payload.fill ?? item.color` — the indicator's colour.
  final Color? color;

  /// The whole row, for a `formatter` that needs its siblings — the "Total"
  /// line in `TooltipAdvanced` reads `item.payload.running + …`.
  final Map<String, Object?>? payload;

  /// Which field of the datum this row came from. `PieStacked`'s
  /// `labelFormatter` reads it.
  final String? dataKey;
}

/// `ChartTooltipContent` — the panel every hovered chart shows.
///
/// Measured on `TooltipDefault`, which renders its tooltip at rest through
/// `defaultIndex={1}`: **128 × 70.78** for a label plus two rows. That decomposes
/// exactly, and the decomposition is what the port had to get right rather than
/// the total: 2 border + 12 `py-1.5` + 16 label line box + 6 `gap-1.5` +
/// (14.4 + 6 + 14.4) for two rows whose height is set by `.type-num-sm`'s
/// 12px × 1.2 rather than by the 12px name beside it, which `leading-none`
/// holds at 12.
class DsChartTooltipContent extends StatelessWidget {
  const DsChartTooltipContent({
    super.key,
    this.config,
    this.label,
    required this.items,
    this.indicator = DsChartIndicator.dot,
    this.hideLabel = false,
    this.hideIndicator = false,
    this.labelFormatter,
    this.formatter,
    this.nameKey,
    this.labelKey,
    this.width,
  });

  /// Normally read from [DsChartScope]; passed directly only by tests and by
  /// the two page-local label chips.
  final DsChartConfig? config;

  /// The category under the cursor — a month, an ISO date.
  final String? label;

  final List<DsChartTooltipItem> items;

  final DsChartIndicator indicator;
  final bool hideLabel;
  final bool hideIndicator;

  /// Replaces the header row's text. Six variants use it, all of them to turn
  /// an ISO date into something readable.
  final String Function(String label, List<DsChartTooltipItem> items)?
      labelFormatter;

  /// Replaces a row entirely — `ui/chart.tsx` renders `formatter(...)` instead
  /// of the built-in indicator/name/value trio, which is why `TooltipFormatter`
  /// and `TooltipAdvanced` rebuild the row by hand.
  final Widget Function(
    BuildContext context,
    DsChartTooltipItem item,
    int index,
  )? formatter;

  /// Which config key to look a row's name up under. Pies and radial bars
  /// almost always need it.
  final String? nameKey;

  /// Which config key to look the header up under. `TooltipLabelCustom`'s
  /// `activities` names no field on the datum at all, which is exactly the
  /// fallback `getPayloadConfigFromPayload` provides.
  final String? labelKey;

  /// `className="w-40"` / `"w-44"` on the two widest variants.
  final double? width;

  /// `min-w-32` — the reference's own floor, and the width the measured 128px
  /// panel is sitting at.
  static double get minWidth => ds(32);

  /// `border-border/50`.
  static const double _borderAlpha = 0.5;

  /// `h-2.5 w-2.5` — the dot indicator.
  static double get _dotSize => ds(2.5);

  /// `w-1` — the line indicator.
  static double get _lineWidth => ds(1);

  /// `border-[1.5px]` — the dashed indicator's own stroke.
  static const double _dashedStroke = 1.5;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final DsChartConfig cfg = config ?? DsChartScope.of(context);
    final Widget? header = _label(context, cfg);
    // `payload.filter(item => item.type !== "none")` is already applied by the
    // callers, which know which series are drawn.
    final List<Widget> rows = <Widget>[
      for (int i = 0; i < items.length; i++)
        _row(context, theme, cfg, items[i], i),
    ];

    return DefaultTextStyle(
      style: DsText.styleOf(context, DsChartText.xs, color: theme.foreground),
      child: Container(
        width: width,
        constraints: BoxConstraints(minWidth: width ?? minWidth),
        padding: EdgeInsets.symmetric(horizontal: ds(2.5), vertical: ds(1.5)),
        decoration: BoxDecoration(
          color: theme.background,
          borderRadius: BorderRadius.circular(DsRadii.lg),
          border: Border.all(
            color: theme.border.withValues(alpha: _borderAlpha),
            width: DsWidths.hairline,
          ),
          boxShadow: DsShadows.tailwindXl.outerShadows(theme),
        ),
        // `display: grid` shrink-to-fit under a `min-width`: the panel is as
        // wide as its widest row or 128, whichever is larger, and every row is
        // `w-full` inside that. Without the intrinsic pass an `Expanded` row
        // would stretch the panel to the whole surface.
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (header != null) ...<Widget>[header, SizedBox(height: ds(1.5))],
              for (int i = 0; i < rows.length; i++) ...<Widget>[
                if (i > 0) SizedBox(height: ds(1.5)),
                rows[i],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget? _label(BuildContext context, DsChartConfig cfg) {
    if (hideLabel || items.isEmpty) return null;
    final DsChartTooltipItem first = items.first;
    final String key = labelKey ?? first.dataKey ?? first.name;
    final DsChartSeries? entry = cfg.resolve(key, first.payload);
    // `!labelKey && typeof label === "string" ? (config[label]?.label ?? label)
    //                                          : itemConfig?.label`
    final String? value = labelKey == null && label != null
        ? (cfg[label!]?.label ?? label)
        : entry?.label;
    if (labelFormatter != null) {
      return DsText(labelFormatter!(label ?? '', items), DsChartText.xsMedium);
    }
    if (value == null || value.isEmpty) return null;
    return DsText(value, DsChartText.xsMedium);
  }

  Widget _row(
    BuildContext context,
    DsThemeData theme,
    DsChartConfig cfg,
    DsChartTooltipItem item,
    int index,
  ) {
    if (formatter != null) return formatter!(context, item, index);

    final String key = nameKey ?? item.name;
    final DsChartSeries? entry = cfg.resolve(key, item.payload);
    final Color ink = item.color ?? entry?.color ?? theme.foreground;
    final bool nested = items.length == 1 && indicator != DsChartIndicator.dot;

    final Widget? mark = entry?.icon != null
        ? SizedBox(width: _dotSize, height: _dotSize, child: entry!.icon!(context))
        : hideIndicator
            ? null
            : _indicator(theme, ink);

    // `items-stretch` — the line and dashed indicators are as tall as the row,
    // which needs the row's own height resolved first. `items-center` is the
    // `dot` case and needs nothing.
    final bool stretch = indicator != DsChartIndicator.dot && !nested;
    final Widget row = Row(
      crossAxisAlignment:
          stretch ? CrossAxisAlignment.stretch : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (mark != null) ...<Widget>[mark, SizedBox(width: ds(2))],
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: DsText(
                  entry?.label ?? item.name,
                  DsChartText.xsTight,
                  color: theme.mutedForeground,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (item.value != null) ...<Widget>[
                SizedBox(width: ds(2)),
                DsText(
                  dsChartNumber(item.value!),
                  DsType.numSm,
                  color: theme.foreground,
                ),
              ],
            ],
          ),
        ),
      ],
    );
    return stretch ? IntrinsicHeight(child: row) : row;
  }

  Widget _indicator(DsThemeData theme, Color ink) {
    switch (indicator) {
      case DsChartIndicator.dot:
        return Container(
          width: _dotSize,
          height: _dotSize,
          decoration: BoxDecoration(
            color: ink,
            borderRadius: BorderRadius.circular(DsRadii.xs),
          ),
        );
      case DsChartIndicator.line:
        return Container(
          width: _lineWidth,
          decoration: BoxDecoration(
            color: ink,
            borderRadius: BorderRadius.circular(DsRadii.xs),
          ),
        );
      case DsChartIndicator.dashed:
        // `w-0 border-[1.5px] border-dashed bg-transparent` — a zero-width box
        // whose own dashed border is the whole mark.
        return SizedBox(
          width: _dashedStroke,
          child: CustomPaint(
            painter: _DashedIndicatorPainter(color: ink, stroke: _dashedStroke),
          ),
        );
    }
  }
}

/// The `border-dashed` rule the dashed indicator is made of.
///
/// Painted rather than composed, because Flutter's `Border` has no dash
/// pattern and a stack of little boxes would round differently at every row
/// height.
class _DashedIndicatorPainter extends CustomPainter {
  const _DashedIndicatorPainter({required this.color, required this.stroke});

  final Color color;
  final double stroke;

  /// Chrome's own `border-dashed` rhythm for a 1.5px border: dashes of 3× the
  /// width with gaps of 2×. Measured against the rendered `BarMultiple`
  /// tooltip rather than taken from the spec, which does not define one.
  static const double _dash = 3;
  static const double _gap = 2;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke;
    final double x = size.width / 2;
    double y = 0;
    while (y < size.height) {
      final double end = (y + _dash * stroke).clamp(0, size.height);
      canvas.drawLine(Offset(x, y), Offset(x, end), paint);
      y = end + _gap * stroke;
    }
  }

  @override
  bool shouldRepaint(_DashedIndicatorPainter old) =>
      old.color != color || old.stroke != stroke;
}

/* ── Legend ──────────────────────────────────────────────────────────────── */

/// One legend key.
class DsChartLegendItem {
  const DsChartLegendItem({required this.name, this.color, this.label});

  final String name;
  final Color? color;

  /// Overrides the config lookup — `PieLegend` passes `nameKey="browser"` and
  /// the rows are months rather than series.
  final String? label;
}

/// `ChartLegendContent` — `flex items-center justify-center gap-4`, with
/// `pt-3` below the plot and `pb-3` above it.
class DsChartLegendContent extends StatelessWidget {
  const DsChartLegendContent({
    super.key,
    this.config,
    required this.items,
    this.verticalAlign = DsChartLegendAlign.bottom,
    this.hideIcon = false,
    this.wrap = false,
    this.gap,
  });

  final DsChartConfig? config;
  final List<DsChartLegendItem> items;
  final DsChartLegendAlign verticalAlign;

  /// Suppresses `itemConfig.icon` — nothing on the page sets it, kept for the
  /// prop's own sake.
  final bool hideIcon;

  /// `flex-wrap` — `PieLegend`'s own className, the one legend on the page that
  /// takes four keys onto two lines.
  final bool wrap;

  /// Overrides `gap-4`. `PieLegend` writes `gap-2`.
  final double? gap;

  /// `h-2 w-2 rounded-xs` — the swatch.
  static double get swatchSize => ds(2);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final DsChartConfig cfg = config ?? DsChartScope.of(context);
    if (items.isEmpty) return const SizedBox.shrink();
    final List<Widget> keys = <Widget>[
      for (final DsChartLegendItem item in items)
        _key(context, theme, cfg, item),
    ];
    final Widget row = wrap
        ? Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: gap ?? ds(4),
            runSpacing: gap ?? ds(4),
            children: keys,
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0; i < keys.length; i++) ...<Widget>[
                if (i > 0) SizedBox(width: gap ?? ds(4)),
                keys[i],
              ],
            ],
          );
    return Padding(
      padding: verticalAlign == DsChartLegendAlign.top
          ? EdgeInsets.only(bottom: ds(3))
          : EdgeInsets.only(top: ds(3)),
      child: Align(child: row),
    );
  }

  Widget _key(
    BuildContext context,
    DsThemeData theme,
    DsChartConfig cfg,
    DsChartLegendItem item,
  ) {
    final DsChartSeries? entry = cfg[item.name];
    final Widget swatch = entry?.icon != null && !hideIcon
        ? SizedBox(width: ds(3), height: ds(3), child: entry!.icon!(context))
        : Container(
            width: swatchSize,
            height: swatchSize,
            decoration: BoxDecoration(
              color: item.color ?? entry?.color ?? theme.mutedForeground,
              borderRadius: BorderRadius.circular(DsRadii.xs),
            ),
          );
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        swatch,
        SizedBox(width: ds(1.5)),
        DsText(
          item.label ?? entry?.label ?? item.name,
          DsChartText.xs,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

/// `verticalAlign` — which side of the plot the legend sits on.
enum DsChartLegendAlign { top, bottom }

/* ── Formatting ──────────────────────────────────────────────────────────── */

/// `Number.prototype.toLocaleString()` in `en-US` — grouped thousands, no
/// forced decimals.
///
/// Every figure the chart family prints goes through this: a tooltip value, the
/// donut's centred total, the two interactive strips' running sums. Written out
/// rather than reached for through `intl`, on ruling L10's precedent — the port
/// carries no i18n dependency and this is one comma rule.
String dsChartNumber(num value) {
  final bool negative = value < 0;
  final num abs = value.abs();
  final String whole = abs.truncate().toString();
  final StringBuffer grouped = StringBuffer();
  for (int i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) grouped.write(',');
    grouped.write(whole[i]);
  }
  final num fraction = abs - abs.truncate();
  final String tail = fraction == 0
      ? ''
      // `toLocaleString` prints at most three fraction digits and trims the
      // trailing zeros; nothing on the page reaches this branch, and it is here
      // so a formatter cannot silently drop a decimal.
      : fraction
          .toStringAsFixed(3)
          .substring(1)
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');
  return '${negative ? '−' : ''}$grouped$tail';
}
