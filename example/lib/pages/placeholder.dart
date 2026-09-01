/// The page every in-scope route that has no page yet renders.
///
/// Design spec §2: *"Routes referenced by nav/foot-nav but out of scope
/// (shadows, motion, icons, component families) render a minimal placeholder
/// using the same shell: links must not dead-end."* A 404 would be a lie: the
/// route exists, the page is simply not ported.
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

/// Eyebrow, title, and an honest sentence.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title, this.eyebrow});

  /// The page's own name: the nav category, or the group for an index route.
  final String title;

  /// The group above it, rendered the way `PageHeader` renders one.
  final String? eyebrow;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (eyebrow != null) ...<Widget>[
          StyledText(eyebrow!, TextStyles.small, color: theme.actionText),
          // `mt-4`.
          SizedBox(height: space(4)),
        ],
        StyledText(title, TextStyles.h1, color: theme.foreground),
        SizedBox(height: space(4)),
        StyledText('Not ported yet', TextStyles.small),
      ],
    );
  }
}
