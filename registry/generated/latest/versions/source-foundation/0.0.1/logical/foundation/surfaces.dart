/// Opacity contracts for translucent system surfaces.
library;

/// Fill opacity by semantic surface role.
class DsSurfaceOpacity {
  const DsSurfaceOpacity._();

  /// Standard card-scale glass material.
  static const double glassPanel = 0.74;

  /// Clear navigation glass: enough fill to group controls while leaving the
  /// moving page beneath visibly legible through the backdrop blur.
  static const double navigationGlass = 0.56;
}
