/// Public documentation page for the `chart-polar` component.
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

/// `final`, not `const`: reads `chartPolarDoc.command`, a computed getter.
final ComponentDocSpec chartPolarDocSpec = buildChartFamilySpec(
  entry: chartPolarDoc,
);

class ChartPolarDocPage extends StatelessWidget {
  const ChartPolarDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => ChartFamilyDocPage(
    entry: chartPolarDoc,
    spec: chartPolarDocSpec,
    articleKey: 'chart-polar-doc-article',
    breadcrumbTitle: 'Chart Polar',
    onNavigate: onNavigate,
  );
}
