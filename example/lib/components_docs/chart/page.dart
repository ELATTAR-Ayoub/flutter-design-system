/// Public documentation page for the `chart` component.
///
/// This route now renders the consolidated chart-family page —
/// `consolidated.dart` — built once and shared with `chart-cartesian`,
/// `chart-geometry` and `chart-polar`. See that file's own doc comment for
/// why: since `/charts` exists as a seventy-chart copyable gallery, these
/// four API pages no longer need to teach by example.
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
import 'consolidated.dart';
import 'meta.dart';

/// `final`, not `const`: reads `chartDoc.command`, a computed getter.
final ComponentDocSpec chartDocSpec = buildChartFamilySpec(entry: chartDoc);

class ChartDocPage extends StatelessWidget {
  const ChartDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => ChartFamilyDocPage(
    entry: chartDoc,
    spec: chartDocSpec,
    articleKey: 'chart-doc-article',
    breadcrumbTitle: 'Chart',
    onNavigate: onNavigate,
  );
}
