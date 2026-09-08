/// Public documentation page for the `chart-geometry` component.
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

/// `final`, not `const`: reads `chartGeometryDoc.command`, a computed
/// getter.
final ComponentDocSpec chartGeometryDocSpec = buildChartFamilySpec(
  entry: chartGeometryDoc,
);

class ChartGeometryDocPage extends StatelessWidget {
  const ChartGeometryDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => ChartFamilyDocPage(
    entry: chartGeometryDoc,
    spec: chartGeometryDocSpec,
    articleKey: 'chart-geometry-doc-article',
    breadcrumbTitle: 'Chart Geometry',
    onNavigate: onNavigate,
  );
}
