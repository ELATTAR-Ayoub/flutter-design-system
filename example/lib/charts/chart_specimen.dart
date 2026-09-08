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
