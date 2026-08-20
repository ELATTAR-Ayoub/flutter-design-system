/// Bottom-up media contrast that keeps overlaid copy readable without adding
/// an opaque information card.
library;

import 'package:flutter/widgets.dart';

import '../foundation/media.dart';

/// A sizing-preserving readability scrim for copy placed directly on media.
///
/// The top is fully transparent and the neutral ink rises only toward the
/// bottom edge. Place this over the full media bounds (commonly with
/// `Positioned.fill`) and compose the title/action content as [child]. The
/// wrapper adopts its incoming constraints and the child's natural size.
class DsMediaScrim extends StatelessWidget {
  const DsMediaScrim({super.key, required this.child});

  final Widget child;

  /// The theme-independent media ink used by [debugGradient].
  @visibleForTesting
  static Color get debugInk => DsMediaScrimTokens.ink;

  /// The exact top-to-bottom readability ramp.
  @visibleForTesting
  static LinearGradient get debugGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      DsMediaScrimTokens.ink.withValues(alpha: 0),
      DsMediaScrimTokens.ink.withValues(alpha: DsMediaScrimTokens.middleAlpha),
      DsMediaScrimTokens.ink.withValues(alpha: DsMediaScrimTokens.bottomAlpha),
    ],
    stops: DsMediaScrimTokens.stops,
  );

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(gradient: debugGradient),
    child: child,
  );
}
