/// Public documentation page for the `chart-cartesian` component.
///
/// This route now renders the consolidated chart-family page — see
/// `../chart/consolidated.dart`'s own doc comment.
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

import '../../docs/component_doc_page.dart';
import '../chart/consolidated.dart';
import 'meta.dart';

/// `final`, not `const`: reads `chartCartesianDoc.command`, a computed
/// getter.
final ComponentDocSpec chartCartesianDocSpec = buildChartFamilySpec(
  entry: chartCartesianDoc,
);

class ChartCartesianDocPage extends StatelessWidget {
  const ChartCartesianDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => ChartFamilyDocPage(
    entry: chartCartesianDoc,
    spec: chartCartesianDocSpec,
    articleKey: 'chart-cartesian-doc-article',
    breadcrumbTitle: 'Chart Cartesian',
    onNavigate: onNavigate,
  );
}
