/// Opacity contracts for translucent system surfaces.
library;

/// Fill opacity by semantic surface role.
class SurfaceOpacity {
  const SurfaceOpacity._();

  /// Standard card-scale glass material.
  static const double glassPanel = 0.74;

  /// What a disabled control fades to.
  ///
  /// One number for the whole system. Eighteen components used to carry a
  /// private copy of this and they disagreed — 0.45 in Button, Input, Stat and
  /// Textarea, 0.60 in AgentComposer, 0.50 everywhere else — so a disabled
  /// input beside a disabled select read as two different states. Disabled is
  /// one state; it gets one value, and it lives here with every other token.
  static const double disabled = 0.5;

  /// Clear navigation glass: enough fill to group controls while leaving the
  /// moving page beneath visibly legible through the backdrop blur.
  static const double navigationGlass = 0.56;
}
