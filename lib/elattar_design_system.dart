/// Elattar's Design System — Flutter port.
///
/// A 1:1 port of the web design system defined in `app/globals.css`.
/// One token source of truth: literals live ONLY under `lib/src/foundation/`
/// (enforced by `test/token_guard_test.dart`); everything else consumes tokens.
library;

// ── foundation ──────────────────────────────────────────────────────────────
export 'src/foundation/colors.dart';
export 'src/foundation/date_format.dart';
export 'src/foundation/motion.dart';
export 'src/foundation/shadows.dart';
export 'src/foundation/spacing.dart';
export 'src/foundation/theme.dart';
export 'src/foundation/typography.dart';

// ── scope ───────────────────────────────────────────────────────────────────
export 'src/text_layout.dart';
export 'src/theme_scope.dart';

// ── components ──────────────────────────────────────────────────────────────
export 'src/components/accordion.dart';
export 'src/components/alert.dart';
export 'src/components/alert_dialog.dart';
export 'src/components/aspect_ratio.dart';
export 'src/components/attachment.dart';
export 'src/components/avatar.dart';
export 'src/components/badge.dart';
export 'src/components/breadcrumb.dart';
export 'src/components/bubble.dart';
export 'src/components/button.dart';
export 'src/components/button_group.dart';
export 'src/components/card.dart';
export 'src/components/calendar.dart';
export 'src/components/carousel.dart';
export 'src/components/chart.dart';
export 'src/components/chart_cartesian.dart';
export 'src/components/chart_geometry.dart';
export 'src/components/chart_polar.dart';
export 'src/components/checkbox.dart';
export 'src/components/collapsible.dart';
export 'src/components/combobox.dart';
export 'src/components/command.dart';
export 'src/components/context_menu.dart';
export 'src/components/dialog.dart';
export 'src/components/drawer.dart';
export 'src/components/ds_rule.dart';
export 'src/components/dropdown_menu.dart';
export 'src/components/empty.dart';
export 'src/components/field.dart';
export 'src/components/form.dart';
export 'src/components/hover_card.dart';
export 'src/components/icon.dart';
export 'src/components/icon_paths.dart';
export 'src/components/icon_paths.g.dart';
export 'src/components/icon_swap.dart';
export 'src/components/input.dart';
export 'src/components/input_group.dart';
export 'src/components/input_otp.dart';
export 'src/components/item.dart';
export 'src/components/kbd.dart';
export 'src/components/menu.dart';
export 'src/components/menubar.dart';
export 'src/components/marker.dart';
export 'src/components/message.dart';
export 'src/components/message_scroller.dart';
export 'src/components/native_select.dart';
export 'src/components/nav_user.dart';
export 'src/components/navigation_menu.dart';
export 'src/components/pagination.dart';
export 'src/components/popover.dart';
export 'src/components/progress.dart';
export 'src/components/radio.dart';
export 'src/components/resizable.dart';
export 'src/components/scroll_area.dart';
export 'src/components/select.dart';
export 'src/components/separator.dart';
export 'src/components/selection_control.dart';
export 'src/components/sheet.dart';
export 'src/components/sidebar.dart';
export 'src/components/skeleton.dart';
export 'src/components/slider.dart';
export 'src/components/spinner.dart';
export 'src/components/stat.dart';
export 'src/components/switch.dart';
export 'src/components/table.dart';
export 'src/components/tabs.dart';
export 'src/components/textarea.dart';
export 'src/components/toaster.dart';
export 'src/components/toggle.dart';
export 'src/components/toggle_group.dart';
export 'src/components/tooltip.dart';

// ── effects ─────────────────────────────────────────────────────────────────
export 'src/effects/bloom_cosmic.dart';
export 'src/effects/foil_value.dart';
export 'src/effects/glass.dart';
export 'src/effects/machine_surface.dart';
export 'src/effects/page_glow.dart';
export 'src/effects/sheen_action.dart';
export 'src/effects/starfield.dart';

// ── motion ──────────────────────────────────────────────────────────────────
export 'src/motion/keyframes.dart';
export 'src/motion/lift.dart';
export 'src/motion/press.dart';
export 'src/motion/sliding_pill.dart';
export 'src/motion/swap_in.dart';
