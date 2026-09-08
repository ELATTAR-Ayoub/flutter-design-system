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

/// `value.slice(0, 3)`: the three-letter month every cartesian axis prints.
String month3(Object? value) => '$value'.substring(0, 3);

/// `new Date(v).toLocaleDateString("en-US", { month: "short", day: "numeric" })`.
String shortDate(Object? value) {
  final DateTime d = DateTime.parse('$value');
  return '${DateFormat.monthsShort[d.month - 1]} ${d.day}';
}

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
