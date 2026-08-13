/// Elattar's Design System — Flutter port.
///
/// A 1:1 port of the web design system defined in `app/globals.css`.
/// One token source of truth: literals live ONLY under `lib/src/foundation/`
/// (enforced by `test/token_guard_test.dart`); everything else consumes tokens.
library;

// ── foundation ──────────────────────────────────────────────────────────────
export 'src/foundation/colors.dart';
export 'src/foundation/motion.dart';
export 'src/foundation/shadows.dart';
export 'src/foundation/spacing.dart';
export 'src/foundation/theme.dart';
export 'src/foundation/typography.dart';

// ── scope ───────────────────────────────────────────────────────────────────
export 'src/theme_scope.dart';

// ── effects ─────────────────────────────────────────────────────────────────
export 'src/effects/machine_surface.dart';
export 'src/effects/page_glow.dart';

// ── motion ──────────────────────────────────────────────────────────────────
export 'src/motion/lift.dart';
export 'src/motion/press.dart';
export 'src/motion/sliding_pill.dart';
