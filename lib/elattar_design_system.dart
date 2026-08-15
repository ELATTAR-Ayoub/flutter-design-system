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
export 'src/text_layout.dart';
export 'src/theme_scope.dart';

// ── components ──────────────────────────────────────────────────────────────
export 'src/components/alert.dart';
export 'src/components/button.dart';
export 'src/components/button_group.dart';
export 'src/components/checkbox.dart';
export 'src/components/ds_rule.dart';
export 'src/components/field.dart';
export 'src/components/form.dart';
export 'src/components/icon.dart';
export 'src/components/icon_paths.dart';
export 'src/components/icon_swap.dart';
export 'src/components/input.dart';
export 'src/components/input_group.dart';
export 'src/components/input_otp.dart';
export 'src/components/kbd.dart';
export 'src/components/radio.dart';
export 'src/components/select.dart';
export 'src/components/selection_control.dart';
export 'src/components/sheet.dart';
export 'src/components/spinner.dart';
export 'src/components/switch.dart';
export 'src/components/textarea.dart';
export 'src/components/toaster.dart';
export 'src/components/toggle.dart';
export 'src/components/toggle_group.dart';

// ── effects ─────────────────────────────────────────────────────────────────
export 'src/effects/bloom_cosmic.dart';
export 'src/effects/foil_value.dart';
export 'src/effects/glass.dart';
export 'src/effects/machine_surface.dart';
export 'src/effects/page_glow.dart';
export 'src/effects/sheen_action.dart';

// ── motion ──────────────────────────────────────────────────────────────────
export 'src/motion/keyframes.dart';
export 'src/motion/lift.dart';
export 'src/motion/press.dart';
export 'src/motion/sliding_pill.dart';
