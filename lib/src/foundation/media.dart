/// Media geometry and readability values shared by product surfaces.
///
/// These are semantic media contracts rather than page-owned literals: a
/// portrait asset keeps the same ratio, and foreground copy needs the same
/// bottom-up contrast treatment, wherever it is presented.
library;

import 'dart:ui' show Color;

import 'colors.dart';

/// Aspect ratios for system-supported media frames.
class ElMediaRatios {
  const ElMediaRatios._();

  /// A portrait-first `9:16` frame used by reels and short-form media.
  static const double portrait = 9 / 16;
}

/// The bottom-up contrast ramp used when copy sits directly on media.
class ElMediaScrimTokens {
  const ElMediaScrimTokens._();

  /// A theme-independent neutral ink: media contrast must not invert when the
  /// surrounding application switches theme.
  static final Color ink = elHsl(0, 0, 0);

  /// Theme-independent foreground placed over [ink]. Media does not change
  /// when the surrounding application theme changes, so its contrast pair
  /// must stay stable as well.
  static final Color foreground = elHsl(0, 0, 100);

  /// The ramp stays transparent through the upper half of the media.
  static const List<double> stops = <double>[0, 0.58, 1];

  /// A restrained bridge between the transparent field and readable edge.
  static const double middleAlpha = 0.18;

  /// Enough contrast for white title copy without becoming an opaque slab.
  static const double bottomAlpha = 0.82;
}
