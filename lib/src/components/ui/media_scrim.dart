/// Bottom-up media contrast that keeps overlaid copy readable without adding
/// an opaque information card.
library;

import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import '../../design_system/foundation/media.dart';

/// A sizing-preserving readability scrim for copy placed directly on media.
///
/// The top is fully transparent and the neutral ink rises only toward the
/// bottom edge. Place this over the full media bounds (commonly with
/// `Positioned.fill`) and compose the title/action content as [child]. The
/// wrapper adopts its incoming constraints and the child's natural size.
class MediaScrim extends StatelessWidget {
  const MediaScrim({super.key, required this.child});

  final Widget child;

  /// The theme-independent media ink used by [debugGradient].
  @visibleForTesting
  static Color get debugInk => MediaScrimTokens.ink;

  /// The exact top-to-bottom readability ramp.
  @visibleForTesting
  static LinearGradient get debugGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      MediaScrimTokens.ink.withValues(alpha: 0),
      MediaScrimTokens.ink.withValues(alpha: MediaScrimTokens.middleAlpha),
      MediaScrimTokens.ink.withValues(alpha: MediaScrimTokens.bottomAlpha),
    ],
    stops: MediaScrimTokens.stops,
  );

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(gradient: debugGradient),
    child: child,
  );
}
