/// Elattar's Design System — Flutter port.
///
/// A 1:1 port of the web design system defined in `app/globals.css`.
/// One token source of truth: literals live ONLY under
/// `lib/src/design_system/foundation/`
/// (enforced by `test/token_guard_test.dart`); everything else consumes tokens.
library;

// ── foundation ──────────────────────────────────────────────────────────────
export './src/design_system/foundation/colors.dart';
export './src/design_system/foundation/date_format.dart';
export './src/design_system/foundation/media.dart';
export './src/design_system/foundation/motion.dart';
export './src/design_system/foundation/shadows.dart';
export './src/design_system/foundation/spacing.dart';
export './src/design_system/foundation/surfaces.dart';
export './src/design_system/foundation/theme.dart';
export './src/design_system/foundation/typography.dart';

// ── scope ───────────────────────────────────────────────────────────────────
export './src/design_system/foundation/text_layout.dart';
export './src/design_system/foundation/theme_scope.dart';

// ── components ──────────────────────────────────────────────────────────────
export './src/components/ui/accordion.dart';
export './src/components/ui/agent_attach_menu.dart';
export './src/components/ui/agent_attachments.dart';
export './src/components/ui/agent_avatar.dart';
export './src/components/ui/agent_composer.dart';
export './src/blocks/agent_console/agent_console.dart';
export './src/components/ui/agent_core.dart';
export './src/components/ui/agent_face.dart';
export './src/components/ui/agent_history.dart';
export './src/components/ui/agent_launcher.dart';
export './src/components/ui/agent_markdown.dart';
export './src/components/ui/agent_slash_palette.dart';
export './src/components/ui/agent_transcript.dart';
export './src/components/ui/alert.dart';
export './src/components/ui/alert_dialog.dart';
export './src/components/ui/aspect_ratio.dart';
export './src/components/ui/attachment.dart';
export './src/components/ui/avatar.dart';
export './src/components/ui/badge.dart';
export './src/components/ui/breadcrumb.dart';
export './src/components/ui/bubble.dart';
export './src/components/ui/button.dart';
export './src/components/ui/button_group.dart';
export './src/components/ui/card.dart';
export './src/components/ui/calendar.dart';
export './src/components/ui/carousel.dart';
export './src/components/ui/chart.dart';
export './src/components/ui/chart_cartesian.dart';
export './src/components/ui/chart_geometry.dart';
export './src/components/ui/chart_polar.dart';
export './src/components/ui/checkbox.dart';
export './src/components/ui/collapsible.dart';
export './src/components/ui/combobox.dart';
export './src/components/ui/command.dart';
export './src/components/ui/context_menu.dart';
export './src/components/ui/dialog.dart';
export './src/components/ui/drawer.dart';
export './src/components/ui/validation_rule.dart';
export './src/components/ui/safe_area.dart';
export './src/components/ui/dropdown_menu.dart';
export './src/components/ui/empty.dart';
export './src/components/ui/field.dart';
export './src/components/ui/form.dart';
export './src/components/ui/hover_card.dart';
export './src/components/ui/icon.dart';
export './src/components/ui/icon_paths.dart';
export './src/components/ui/icon_paths.g.dart';
export './src/components/ui/icon_swap.dart';
export './src/components/ui/input.dart';
export './src/components/ui/input_group.dart';
export './src/components/ui/input_otp.dart';
export './src/components/ui/item.dart';
export './src/components/ui/kbd.dart';
export './src/components/ui/menu.dart';
export './src/components/ui/menubar.dart';
export './src/components/ui/marker.dart';
export './src/components/ui/message.dart';
export './src/components/ui/message_scroller.dart';
export './src/components/ui/native_select.dart';
export './src/components/ui/user_menu.dart';
export './src/components/ui/navigation_menu.dart';
export './src/components/ui/pagination.dart';
export './src/components/ui/popover.dart';
export './src/components/ui/progress.dart';
export './src/components/ui/questionnaire.dart';
export './src/components/ui/radio.dart';
export './src/components/ui/resizable.dart';
export './src/components/ui/scroll_area.dart';
export './src/components/ui/select.dart';
export './src/components/ui/separator.dart';
export './src/components/ui/selection_control.dart';
export './src/components/ui/sheet.dart';
export './src/components/ui/sidebar.dart';
export './src/components/ui/skeleton.dart';
export './src/components/ui/slider.dart';
export './src/components/ui/spinner.dart';
export './src/components/ui/stat.dart';
export './src/components/ui/switch.dart';
export './src/components/ui/table.dart';
export './src/components/ui/tabs.dart';
export './src/components/ui/textarea.dart';
export './src/components/ui/toaster.dart';
export './src/components/ui/toggle.dart';
export './src/components/ui/toggle_group.dart';
export './src/components/ui/tooltip.dart';
export './src/components/ui/voice.dart';

// ── effects ─────────────────────────────────────────────────────────────────
export './src/components/ui/feedback_surface.dart';
export './src/components/ui/premium_surface.dart';
export './src/components/ui/glass.dart';
export './src/components/ui/surface.dart';
export './src/components/ui/media_scrim.dart';
export './src/components/ui/background_effect.dart';
export './src/components/ui/action_feedback.dart';
export './src/components/ui/ambient_pattern.dart';
export './src/components/ui/voice_indicator.dart';

// ── motion ──────────────────────────────────────────────────────────────────
export './src/components/ui/keyframes.dart';
export './src/components/ui/hover_builder.dart';
export './src/components/ui/press.dart';
export './src/components/ui/active_indicator.dart';
export './src/components/ui/content_change.dart';
