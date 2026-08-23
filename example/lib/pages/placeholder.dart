/// The page every in-scope route that has no page yet renders.
///
/// Design spec §2: *"Routes referenced by nav/foot-nav but out of scope
/// (shadows, motion, icons, component families) render a minimal placeholder
/// using the same shell: links must not dead-end."* A 404 would be a lie: the
/// route exists, the page is simply not ported.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

/// Eyebrow, title, and an honest sentence.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title, this.eyebrow});

  /// The page's own name: the nav category, or the group for an index route.
  final String title;

  /// The group above it, rendered the way `DsPageHeader` renders one.
  final String? eyebrow;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (eyebrow != null) ...<Widget>[
          DsText(eyebrow!, DsType.label, color: theme.actionInk),
          // `mt-4`.
          SizedBox(height: ds(4)),
        ],
        DsText(
          title,
          DsType.h1,
          fontSize: DsFluid.h1(context),
          color: theme.foreground,
        ),
        SizedBox(height: ds(4)),
        DsText('Not ported yet', DsType.small),
      ],
    );
  }
}
