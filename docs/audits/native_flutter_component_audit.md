# Native Flutter component audit ledger

Execution source of truth for `docs/superpowers/plans/2026-08-31-native-flutter-system-architecture.md`.

Status values: `pending`, `in progress`, `complete`. Disposition classifies the *legacy web-parity behaviour* found in the entry: **keep** / **translate** / **fix** / **remove** / **document**. An entry usually carries several; the column lists each one recorded for that row.


## Row index

| # | Entry | Batch | Prio | Source | Docs page | Tests | Disposition | Status | Evidence |
|---:|---|---:|---|---|---|---|---|---|---|
| 1 | `feedback_surface` | 2 | P0 | `lib/src/components/ui/feedback_surface.dart` | `example/lib/components_docs/feedback_surface/` | `example/test/components_docs/feedback_surface_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 2 | `hover_builder` | 2 | P0 | `lib/src/components/ui/hover_builder.dart` | `example/lib/components_docs/hover_builder/` | `example/test/components_docs/hover_builder_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 3 | `keyframes` | 2 | P0 | `lib/src/components/ui/keyframes.dart` | `example/lib/components_docs/keyframes/` | `example/test/components_docs/keyframes_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 4 | `premium_surface` | 2 | P0 | `lib/src/components/ui/premium_surface.dart` | `example/lib/components_docs/premium_surface/` | `example/test/components_docs/premium_surface_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 5 | `press` | 2 | P0 | `lib/src/components/ui/press.dart` | `example/lib/components_docs/press/` | `example/test/components_docs/press_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 6 | `selection_control` | 2 | P0 | `lib/src/components/ui/selection_control.dart` | `example/lib/components_docs/selection_control/` | `example/test/components_docs/selection_control_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 7 | `action_feedback` | 2 | P1 | `lib/src/components/ui/action_feedback.dart` | `example/lib/components_docs/action_feedback/` | `example/test/components_docs/action_feedback_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 8 | `active_indicator` | 2 | P1 | `lib/src/components/ui/active_indicator.dart` | `example/lib/components_docs/active_indicator/` | `example/test/components_docs/active_indicator_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 9 | `content_change` | 2 | P1 | `lib/src/components/ui/content_change.dart` | `example/lib/components_docs/content_change/` | `example/test/components_docs/content_change_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 10 | `glass` | 2 | P1 | `lib/src/components/ui/glass.dart` | `example/lib/components_docs/glass/` | `example/test/components_docs/glass_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 11 | `icon_swap` | 2 | P1 | `lib/src/components/ui/icon_swap.dart` | `example/lib/components_docs/icon_swap/` | `example/test/components_docs/icon_swap_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 12 | `spinner` | 3 | P0 | `lib/src/components/ui/spinner.dart` | `example/lib/components_docs/spinner/` | `example/test/components_docs/spinner_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 13 | `alert` | 3 | P1 | `lib/src/components/ui/alert.dart` | `example/lib/components_docs/alert/` | `example/test/components_docs/alert_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 14 | `badge` | 3 | P1 | `lib/src/components/ui/badge.dart` | `example/lib/components_docs/badge/` | `example/test/components_docs/badge_test.dart` | fix — `Badge.height` was a hard 20px border box that clipped a scaled label; it is `Badge.minHeight` now. The label also flexes, so a chip in a narrow row shortens its word rather than pushing its glyph off the edge. | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 15 | `icon` | 3 | P1 | `lib/src/components/ui/icon.dart` | `example/lib/components_docs/icon/` | `example/test/components_docs/icon_test.dart` | keep — no typography of its own | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 16 | `progress` | 3 | P1 | `lib/src/components/ui/progress.dart` | `example/lib/components_docs/progress/` | `example/test/components_docs/progress_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 17 | `stat` | 3 | P1 | `lib/src/components/ui/stat.dart` | `example/lib/components_docs/stat/` | `example/test/components_docs/stat_test.dart` | fix — the figure slot was a `SizedBox(height:)` that clipped a scaled metric; it is a text-scale-aware minimum (`Stat.figureMinHeightOf`) that still holds the footprint steady across loading, ready and error. | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 18 | `avatar` | 3 | P2 | `lib/src/components/ui/avatar.dart` | `example/lib/components_docs/avatar/` | `example/test/components_docs/avatar_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 19 | `card` | 3 | P2 | `lib/src/components/ui/card.dart` | `example/lib/components_docs/card/` | `example/test/components_docs/card_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 20 | `empty` | 3 | P2 | `lib/src/components/ui/empty.dart` | `example/lib/components_docs/empty/` | `example/test/components_docs/empty_test.dart` | translate — the title derives its tighter tracking from `nav` rather than composing two roles by hand | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 21 | `kbd` | 3 | P2 | `lib/src/components/ui/kbd.dart` | `example/lib/components_docs/kbd/` | `example/test/components_docs/kbd_test.dart` | fix — `Kbd.height` was a hard 20px box; it is `Kbd.minHeight` now, and the legend reads at the mono `code` role rather than a 12px sans rung. | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 22 | `marker` | 3 | P2 | `lib/src/components/ui/marker.dart` | `example/lib/components_docs/marker/` | `example/test/components_docs/marker_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 23 | `skeleton` | 3 | P2 | `lib/src/components/ui/skeleton.dart` | `example/lib/components_docs/skeleton/` | `example/test/components_docs/skeleton_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 24 | `surface` | 3 | P2 | `lib/src/components/ui/surface.dart` | `example/lib/components_docs/surface/` | `example/test/components_docs/surface_test.dart<br>test/surface_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 25 | `aspect_ratio` | 3 | P3 | `lib/src/components/ui/aspect_ratio.dart` | `example/lib/components_docs/aspect_ratio/` | `example/test/components_docs/aspect_ratio_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 26 | `separator` | 3 | P3 | `lib/src/components/ui/separator.dart` | `example/lib/components_docs/separator/` | `example/test/components_docs/separator_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 27 | `button` | 4 | P0 | `lib/src/components/ui/button.dart` | `example/lib/components_docs/button/` | `example/test/components_docs/button_test.dart` | translate — the five label rungs derive from `small`/`body` at medium weight; `caps` keeps its rung and no rung drops below 14px; icon rungs own no text role | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 28 | `checkbox` | 4 | P0 | `lib/src/components/ui/checkbox.dart` | `example/lib/components_docs/checkbox/` | `example/test/components_docs/checkbox_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 29 | `radio` | 4 | P0 | `lib/src/components/ui/radio.dart` | `example/lib/components_docs/radio/` | `example/test/components_docs/radio_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 30 | `slider` | 4 | P0 | `lib/src/components/ui/slider.dart` | `example/lib/components_docs/slider/` | `example/test/components_docs/slider_test.dart<br>test/slider_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 31 | `switch` | 4 | P0 | `lib/src/components/ui/switch.dart` | `example/lib/components_docs/switch/` | `example/test/components_docs/switch_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 32 | `toggle` | 4 | P0 | `lib/src/components/ui/toggle.dart` | `example/lib/components_docs/toggle/` | `example/test/components_docs/toggle_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 33 | `toggle_group` | 4 | P0 | `lib/src/components/ui/toggle_group.dart` | `example/lib/components_docs/toggle_group/` | `example/test/components_docs/toggle_group_test.dart` | fix — the group overflowed rather than scrolling when its options did not fit; it now scrolls horizontally so every option stays reachable. | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 34 | `button_group` | 4 | P1 | `lib/src/components/ui/button_group.dart` | `example/lib/components_docs/button_group/` | `example/test/components_docs/button_group_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 35 | `item` | 4 | P1 | `lib/src/components/ui/item.dart` | `example/lib/components_docs/item/` | `example/test/components_docs/item_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 36 | `field` | 5 | P0 | `lib/src/components/ui/field.dart` | `example/lib/components_docs/field/` | `example/test/components_docs/field_test.dart` | fix — `FieldDescription` inherited the invalid state's destructive ink once roles stopped carrying colour; it states its own muted ink. `FieldLabel.medium` is the default anatomy, `FieldLabel.normal` the flat-weight variant for a list of labels. | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 37 | `form` | 5 | P0 | `lib/src/components/ui/form.dart` | `example/lib/components_docs/form/` | `example/test/components_docs/form_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 38 | `input` | 5 | P0 | `lib/src/components/ui/input.dart` | `example/lib/components_docs/input/` | `example/test/components_docs/input_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 39 | `input_group` | 5 | P0 | `lib/src/components/ui/input_group.dart` | `example/lib/components_docs/input_group/` | `example/test/components_docs/input_group_test.dart` | fix — an addon read a step below the control it sits beside; it reads at the control's own role now. | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 40 | `input_otp` | 5 | P0 | `lib/src/components/ui/input_otp.dart` | `example/lib/components_docs/input_otp/` | `example/test/components_docs/input_otp_test.dart` | fix — a digit read a step below reading size; it is the `body` role now. | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 41 | `native_select` | 5 | P0 | `lib/src/components/ui/native_select.dart` | `example/lib/components_docs/native_select/` | `example/test/components_docs/native_select_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 42 | `questionnaire` | 5 | P0 | `lib/src/components/ui/questionnaire.dart` | `example/lib/components_docs/questionnaire/` | `example/test/components_docs/questionnaire_test.dart` | translate — the progress label derives medium + tabular from `small` | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 43 | `textarea` | 5 | P0 | `lib/src/components/ui/textarea.dart` | `example/lib/components_docs/textarea/` | `example/test/components_docs/textarea_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 44 | `validation_rule` | 5 | P2 | `lib/src/components/ui/validation_rule.dart` | `example/lib/components_docs/validation_rule/` | `example/test/components_docs/validation_rule_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 45 | `alert_dialog` | 6 | P0 | `lib/src/components/ui/alert_dialog.dart` | `example/lib/components_docs/alert_dialog/` | `example/test/components_docs/alert_dialog_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 46 | `combobox` | 6 | P0 | `lib/src/components/ui/combobox.dart` | `example/lib/components_docs/combobox/` | `example/test/components_docs/combobox_test.dart` | translate — row and empty-row heights derive from the role they set | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 47 | `command` | 6 | P0 | `lib/src/components/ui/command.dart` | `example/lib/components_docs/command/` | `example/test/components_docs/command_test.dart` | translate — the group heading derives medium weight from `small` instead of a published `menuHeading` role; row, heading and empty-row heights derive from the roles they set. | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 48 | `context_menu` | 6 | P0 | `lib/src/components/ui/context_menu.dart` | `example/lib/components_docs/context_menu/` | `example/test/components_docs/context_menu_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 49 | `dialog` | 6 | P0 | `lib/src/components/ui/dialog.dart` | `example/lib/components_docs/dialog/` | `example/test/components_docs/dialog_test.dart` | fix — `DialogFooter` was a `Row` that clipped its actions; it is a `Wrap` now, so two or three labels at a large text scale run onto a second line instead of off the edge. | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 50 | `drawer` | 6 | P0 | `lib/src/components/ui/drawer.dart` | `example/lib/components_docs/drawer/` | `example/test/components_docs/drawer_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 51 | `dropdown_menu` | 6 | P0 | `lib/src/components/ui/dropdown_menu.dart` | `example/lib/components_docs/dropdown_menu/` | `example/test/components_docs/dropdown_menu_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 52 | `hover_card` | 6 | P0 | `lib/src/components/ui/hover_card.dart` | `example/lib/components_docs/hover_card/` | `example/test/components_docs/hover_card_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 53 | `menu` | 6 | P0 | `lib/src/components/ui/menu.dart` | `example/lib/components_docs/menu/` | `example/test/components_docs/menu_test.dart` | translate — row, two-line row and label heights derive from the roles they set | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 54 | `menubar` | 6 | P0 | `lib/src/components/ui/menubar.dart` | `example/lib/components_docs/menubar/` | `example/test/components_docs/menubar_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 55 | `popover` | 6 | P0 | `lib/src/components/ui/popover.dart` | `example/lib/components_docs/popover/` | `example/test/components_docs/popover_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 56 | `select` | 6 | P0 | `lib/src/components/ui/select.dart` | `example/lib/components_docs/select/` | `example/test/components_docs/select_test.dart` | translate — row and label heights derive from the roles they set | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 57 | `sheet` | 6 | P0 | `lib/src/components/ui/sheet.dart` | `example/lib/components_docs/sheet/` | `example/test/components_docs/sheet_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 58 | `tooltip` | 6 | P0 | `lib/src/components/ui/tooltip.dart` | `example/lib/components_docs/tooltip/` | `example/test/components_docs/tooltip_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 59 | `user_menu` | 6 | P1 | `lib/src/components/ui/user_menu.dart` | `example/lib/components_docs/user_menu/` | `example/test/components_docs/user_menu_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 60 | `calendar` | 7 | P0 | `lib/src/components/ui/calendar.dart` | `example/lib/components_docs/calendar/` | `example/test/components_docs/calendar_test.dart<br>test/calendar_test.dart` | translate — the day number derives tabular figures from `body` so a date grid aligns its columns | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 61 | `navigation_menu` | 7 | P0 | `lib/src/components/ui/navigation_menu.dart` | `example/lib/components_docs/navigation_menu/` | `example/test/components_docs/navigation_menu_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 62 | `scroll_area` | 7 | P0 | `lib/src/components/ui/scroll_area.dart` | `example/lib/components_docs/scroll_area/` | `example/test/components_docs/scroll_area_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 63 | `sidebar` | 7 | P0 | `lib/src/components/ui/sidebar.dart` | `example/lib/components_docs/sidebar/` | `example/test/components_docs/sidebar_test.dart<br>test/sidebar_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 64 | `table` | 7 | P0 | `lib/src/components/ui/table.dart` | `example/lib/components_docs/table/` | `example/test/components_docs/table_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 65 | `tabs` | 7 | P0 | `lib/src/components/ui/tabs.dart` | `example/lib/components_docs/tabs/` | `example/test/components_docs/tabs_test.dart` | fix — the track was an unclipped, unscrolled Row that painted its last tab past the edge at a phone width, and a fixed-height box around real text. It is now a minimum height inside a horizontal scroll view, and the docs page no longer documents the overflow as behaviour. | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 66 | `accordion` | 7 | P1 | `lib/src/components/ui/accordion.dart` | `example/lib/components_docs/accordion/` | `example/test/components_docs/accordion_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 67 | `breadcrumb` | 7 | P1 | `lib/src/components/ui/breadcrumb.dart` | `example/lib/components_docs/breadcrumb/` | `example/test/components_docs/breadcrumb_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 68 | `carousel` | 7 | P1 | `lib/src/components/ui/carousel.dart` | `example/lib/components_docs/carousel/` | `example/test/components_docs/carousel_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 69 | `collapsible` | 7 | P1 | `lib/src/components/ui/collapsible.dart` | `example/lib/components_docs/collapsible/` | `example/test/components_docs/collapsible_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 70 | `pagination` | 7 | P1 | `lib/src/components/ui/pagination.dart` | `example/lib/components_docs/pagination/` | `example/test/components_docs/pagination_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 71 | `resizable` | 7 | P1 | `lib/src/components/ui/resizable.dart` | `example/lib/components_docs/resizable/` | `example/test/components_docs/resizable_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 72 | `safe_area` | 7 | P1 | `lib/src/components/ui/safe_area.dart` | `example/lib/components_docs/safe_area/` | `example/test/components_docs/safe_area_test.dart<br>test/safe_area_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 73 | `agent_markdown` | 8 | P0 | `lib/src/components/ui/agent_markdown.dart` | `example/lib/components_docs/agent_markdown/` | `example/test/components_docs/agent_markdown_test.dart` | translate — `strong`/`emphasis`/`cellTabular` derive from `body`/`small`; the fence label sets its own caps treatment and keeps the authored name as its accessible label rather than relying on a hidden role transform. | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 74 | `message_scroller` | 8 | P0 | `lib/src/components/ui/message_scroller.dart` | `example/lib/components_docs/message_scroller/` | `example/test/components_docs/message_scroller_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 75 | `attachment` | 8 | P1 | `lib/src/components/ui/attachment.dart` | `example/lib/components_docs/attachment/` | `example/test/components_docs/attachment_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 76 | `bubble` | 8 | P1 | `lib/src/components/ui/bubble.dart` | `example/lib/components_docs/bubble/` | `example/test/components_docs/bubble_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 77 | `message` | 8 | P1 | `lib/src/components/ui/message.dart` | `example/lib/components_docs/message/` | `example/test/components_docs/message_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 78 | `chart` | 9 | P0 | `lib/src/components/ui/chart.dart` | `example/lib/components_docs/chart/` | `example/test/components_docs/chart_test.dart` | remove — the `leading-none` keyword row and the 12px chart-label rung; chart text reads at `small`. | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 79 | `chart_cartesian` | 9 | P1 | `lib/src/components/ui/chart_cartesian.dart` | `example/lib/components_docs/chart_cartesian/` | `example/test/components_docs/chart_cartesian_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 80 | `chart_polar` | 9 | P1 | `lib/src/components/ui/chart_polar.dart` | `example/lib/components_docs/chart_polar/` | `example/test/components_docs/chart_polar_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 81 | `ambient_pattern` | 9 | P2 | `lib/src/components/ui/ambient_pattern.dart` | `example/lib/components_docs/ambient_pattern/` | `example/test/components_docs/ambient_pattern_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 82 | `background_effect` | 9 | P2 | `lib/src/components/ui/background_effect.dart` | `example/lib/components_docs/background_effect/` | `example/test/components_docs/background_effect_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 83 | `chart_geometry` | 9 | P2 | `lib/src/components/ui/chart_geometry.dart` | `example/lib/components_docs/chart_geometry/` | `example/test/components_docs/chart_geometry_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 84 | `media_scrim` | 9 | P3 | `lib/src/components/ui/media_scrim.dart` | `example/lib/components_docs/media_scrim/` | `example/test/components_docs/media_scrim_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 85 | `agent_attach_menu` | 10 | P0 | `lib/src/components/ui/agent_attach_menu.dart` | `example/lib/components_docs/agent_attach_menu/` | `example/test/components_docs/agent_attach_menu_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 86 | `agent_composer` | 10 | P0 | `lib/src/components/ui/agent_composer.dart` | `example/lib/components_docs/agent_composer/` | `example/test/components_docs/agent_composer_test.dart<br>test/agent_composer_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 87 | `agent_console` | 10 | P0 | `lib/src/blocks/agent_console/agent_console.dart` | `example/lib/components_docs/agent_console/` | `example/test/components_docs/agent_console_test.dart<br>test/agent_console_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 88 | `agent_history` | 10 | P0 | `lib/src/components/ui/agent_history.dart` | `example/lib/components_docs/agent_history/` | `example/test/components_docs/agent_history_test.dart<br>test/agent_history_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 89 | `agent_launcher` | 10 | P0 | `lib/src/components/ui/agent_launcher.dart` | `example/lib/components_docs/agent_launcher/` | `example/test/components_docs/agent_launcher_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 90 | `agent_slash_palette` | 10 | P0 | `lib/src/components/ui/agent_slash_palette.dart` | `example/lib/components_docs/agent_slash_palette/` | `example/test/components_docs/agent_slash_palette_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 91 | `agent_transcript` | 10 | P0 | `lib/src/components/ui/agent_transcript.dart` | `example/lib/components_docs/agent_transcript/` | `example/test/components_docs/agent_transcript_test.dart<br>test/agent_transcript_test.dart` | translate — capability and suggestion labels derive medium weight from `small` | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 92 | `voice` | 10 | P0 | `lib/src/components/ui/voice.dart` | `example/lib/components_docs/voice/` | `example/test/components_docs/voice_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 93 | `agent_attachments` | 10 | P1 | `lib/src/components/ui/agent_attachments.dart` | `example/lib/components_docs/agent_attachments/` | `example/test/components_docs/agent_attachments_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 94 | `agent_avatar` | 10 | P1 | `lib/src/components/ui/agent_avatar.dart` | `example/lib/components_docs/agent_avatar/` | `example/test/components_docs/agent_avatar_test.dart<br>test/agent_avatar_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 95 | `agent_core` | 10 | P1 | `lib/src/components/ui/agent_core.dart` | `example/lib/components_docs/agent_core/` | `example/test/components_docs/agent_core_test.dart<br>test/agent_core_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 96 | `agent_face` | 10 | P1 | `lib/src/components/ui/agent_face.dart` | `example/lib/components_docs/agent_face/` | `example/test/components_docs/agent_face_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 97 | `voice_indicator` | 10 | P1 | `lib/src/components/ui/voice_indicator.dart` | `example/lib/components_docs/voice_indicator/` | `example/test/components_docs/voice_indicator_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 98 | `toaster` | 11 | P0 | `lib/src/components/ui/toaster.dart` | `example/lib/components_docs/toaster/` | `example/test/components_docs/toaster_test.dart` | remove — the title and description specs no longer restate a foreign stylesheet's line height; the description is the `small` role and the title derives medium weight from it. | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 99 | `source_foundation` | 11 | P1 | `lib/src/design_system/foundation/` | `example/lib/components_docs/source_foundation/` | `example/test/components_docs/source_foundation_test.dart` | remove — the Redaction 35 face, its pubspec registration, its packaged asset, its registry manifest entry and its OFL notice. Two faces ship. The CLI's install-time source rewrite and its font registration test moved with it. | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |
| 100 | `icon_paths` | 11 | P2 | `lib/src/components/ui/icon_paths.dart` | `—` | `test/icon_paths_test.dart` | translate — type call sites migrated to the 17-role contract | type contract complete | root suite green (1514 tests); see CHANGELOG 0.0.2 — unreleased |

## Required native action per row

| Entry | Family | Required native Flutter action and acceptance (from the master plan) |
|---|---|---|
| `feedback_surface` | Effects and low-level interaction entries | Largest drift concentration: replace pseudo-element and selector parity with explicit Flutter layers/state; theme/repaint/reduced-motion tests; remove unreachable branches. |
| `hover_builder` | Effects and low-level interaction entries | Keep hover reporting separate from activation; ensure consumers cannot accidentally create hover-only controls; lifecycle/cursor tests and touch-neutral behavior. |
| `keyframes` | Effects and low-level interaction entries | Decide whether public exposure is justified. Prefer typed Flutter animations; remove CSS-keyframe implementation vocabulary, validate interpolation, loops, TickerMode, reduced motion, disposal. |
| `premium_surface` | Effects and low-level interaction entries | Replace pseudo-element/hover CSS parity with explicit Flutter composition; effects subordinate to meaning, reduced motion, theme/contrast, performance, remove no-op branches. |
| `press` | Effects and low-level interaction entries | Make visual press a layer of a complete control, or clearly noninteractive when callback absent; keyboard/focus/semantics/target contract, reduced motion and cancellation. |
| `selection_control` | General components — controls and forms | Make the shared checkbox/radio/switch activation, target, semantics, focus, and animation contract authoritative; remove selector/cascade artifacts. |
| `action_feedback` | Effects and low-level interaction entries | Retain only as reusable pressed/focus feedback; remove pseudo-element/CSS-state modelling, connect to shared control state, reduced motion and repaint isolation. |
| `active_indicator` | Effects and low-level interaction entries | Constraint-based measurement, stable first frame, RTL, resize/reorder handling, reduced motion/TickerMode, semantic state remains on the control—not indicator. |
| `content_change` | Effects and low-level interaction entries | Native keyed content transition, correct identity/state preservation, size changes, focus preservation, reduced motion, and no CSS transition vocabulary in API. |
| `glass` | Effects and low-level interaction entries | Validate actual BackdropFilter behavior and fallback rather than CSS blur assumptions; contrast in both themes, clipping/performance, no invisible redundant layers. |
| `icon_swap` | Effects and low-level interaction entries | Native transition with stable layout/semantics, correct child identity, reduced motion/TickerMode, no CSS transform assumptions. |
| `spinner` | General components — content, layout, and feedback | Remove deliberately reproduced silent semantics. Provide contextual status policy, reduced motion/TickerMode, size/stroke consistency, and prevent duplicate announcement inside loading Button. |
| `alert` | General components — content, layout, and feedback | Separate semantic status ink from typography; icon/word conveys status; flexible title/body layout; validate contrast and long text. |
| `badge` | General components — content, layout, and feedback | Use 14/18 Badge-owned role; ensure status never color-only; remove unreachable icon-padding selector behavior; grow for scaled/localized text. |
| `icon` | Remaining catalog/support entries | Meaningful icon requires label; decorative icon excluded; consistent Flutter sizing/stroke/tone, RTL mirroring where appropriate, scalable surrounding target, no DOM prop-loss parity. |
| `progress` | General components — content, layout, and feedback | Correct determinate/indeterminate semantics and announcements, clamp/NaN handling, status beyond color, reduced motion, and scalable adjacent labels. |
| `stat` | General components — content, layout, and feedback | Use final numeric roles, semantic label/value/trend, trend not color-only, locale-safe formatting, long labels, and responsive metric layout. |
| `avatar` | General components — content, layout, and feedback | Validate image semantics/fallback initials, loading/error behavior, scalable fallback type, clipping, and decorative usage; remove CSS-only style branches. |
| `card` | General components — content, layout, and feedback | Keep as semantic surface; ensure interactive cards go through complete shared activation rather than raw gesture/hover; flexible contents and correct elevations. |
| `empty` | General components — content, layout, and feedback | Remove old font/cascade assumptions; enforce title/body/one-next-step structure, flexible layout, image semantics, and empty versus no-results documentation. |
| `kbd` | General components — content, layout, and feedback | Raise/readjust typography, expose spoken key names, model platform-specific modifier labels, and grow instead of clipping. Remove Preflight-derived sizing. |
| `marker` | General components — content, layout, and feedback | Validate semantic meaning versus decoration, anchor/layout behavior, token colors, contrast, and scalable labels. |
| `skeleton` | General components — content, layout, and feedback | Preserve footprint ownership, exclude decoration from semantics, respect reduced motion/TickerMode, verify no layout jump and document fixed pumping accurately. |
| `surface` | Effects and low-level interaction entries | Keep as tokenized visual primitive; validate clipping, border/shadow composition, theme changes and semantics neutrality; remove CSS box-model reasoning from public docs. |
| `aspect_ratio` | General components — navigation and layout | Keep Flutter geometry semantics; validate invalid ratios/constraints and docs. It owns no typography or interaction. |
| `separator` | General components — content, layout, and feedback | Validate horizontal/vertical semantics (decorative by default), hairline rendering at DPRs, and token color; no rewrite if contract passes. |
| `button` | General components — content, layout, and feedback | Execute core type migration; minimum/effective targets, loading/busy semantics, no double action, keyboard/focus/press parity, remove dead `iconXs`/web-only branches. |
| `checkbox` | General components — controls and forms | Native checked/mixed semantics, Space activation, focus-visible, validation, 44×44 target, disabled/read-only distinction, and reduced motion. |
| `radio` | General components — controls and forms | One-tab-stop group with arrow navigation, selected semantics, labels/description, focus-visible, 44×44 targets, disabled behavior, and validation. |
| `slider` | General components — controls and forms | Adjustable semantics/increase/decrease actions, keyboard increments, RTL, divisions/range edge cases, 44×44 thumb target, labels, focus, reduced motion. |
| `switch` | General components — controls and forms | Native toggled semantics and Space activation, focus-visible, 44×44 target, label association, disabled/read-only distinction, reduced motion. |
| `toggle` | General components — controls and forms | Native selected semantics, Space/Enter, focus/target states, remove CVA/class precedence, final type, and meaningful variants only. |
| `toggle_group` | General components — controls and forms | One Tab stop, arrow navigation, single/multiple selection semantics, disabled items, roving focus, wrap/overflow behavior, and no per-child Tab stops. |
| `button_group` | General components — navigation and layout | Remove descendant-selector/CVA assumptions; semantic grouping, connected-border geometry, flexible wrapping, keyboard behavior inherited from children, delete unreachable nesting rules. |
| `item` | General components — content, layout, and feedback | Make selectable/actionable rows complete controls; remove no-op transition behavior; flexible leading/trailing slots; target, focus, semantics, and long-text stress. |
| `field` | General components — controls and forms | Visible label, description/error associations, required state, focus/error routing, flexible copy, semantic grouping, and final typography. |
| `form` | General components — controls and forms | Native form validation/submission ownership, first-invalid focus, submitting lock, async error boundary, announcements, and no CSS layout assumptions. |
| `input` | General components — controls and forms | TextField-native editing/selection/IME/autofill, visible label via Field, focus/error/read-only/disabled semantics, keyboard inset, scalable minimum geometry. |
| `input_group` | General components — controls and forms | Preserve one coherent field semantics node while keeping prefix/suffix actions separately operable; flexible slots, focus ring, long/scaled content. |
| `input_otp` | General components — controls and forms | Native text input/IME/paste/autofill, one logical semantic field, error announcement, focus movement without invisible-web-field assumptions, RTL and 200% stress. |
| `native_select` | General components — controls and forms | Prove the name: use appropriate Flutter/platform selection semantics; full keyboard model, focus lifecycle, selected announcement, disabled/read-only, long options. |
| `questionnaire` | General components — content, layout, and feedback | Treat as a composite form: field labels/errors, focus on invalid, keyboard ordering, submitting/disabled states, no double submit, adaptive structure, and human error copy. |
| `textarea` | General components — controls and forms | Native multiline editing/IME/selection, visible label, error/read-only/disabled states, keyboard inset, min rather than fixed height, 200% stress. |
| `validation_rule` | General components — controls and forms | Keep as pure validation/domain contract; verify localized human messages, composability, async boundary, and no UI/backend leakage. |
| `alert_dialog` | General components — content, layout, and feedback | Rebuild on the shared modal lifecycle; safest initial focus, trap, Escape, focus restore, semantic title/description, growing actions via `Wrap`. Remove reproduced drifts. |
| `combobox` | General components — overlays, menus, and disclosure | Shared overlay lifecycle plus editable text semantics, filtering/result-count announcements, arrows/Enter/Escape, no-results action, IME, focus restore, long options. |
| `command` | General components — overlays, menus, and disclosure | Remove documented no-op filtering/parity defects; native search/list state, one active option, full keyboard map, result announcements, command activation and empty state. |
| `context_menu` | General components — overlays, menus, and disclosure | Native secondary-click/long-press invocation, keyboard alternative, anchor placement, menu semantics, focus entry/restore, and touch reachability. |
| `dialog` | General components — overlays, menus, and disclosure | Shared modal lifecycle, semantic route/name, focus trap/restore, Escape/barrier policy, safe areas, keyboard inset, flexible actions, and reduced motion. |
| `drawer` | General components — overlays, menus, and disclosure | Use route/overlay semantics appropriate to modality; safe areas, drag/keyboard dismissal, focus lifecycle, text scaling, and reduced motion. |
| `dropdown_menu` | General components — overlays, menus, and disclosure | Thin composition over native Menu infrastructure; complete keyboard/submenu/check/radio/disabled semantics and focus restoration. |
| `hover_card` | General components — overlays, menus, and disclosure | Hover may preview but focus/tap must reach identical content; dismissal timing, nonmodal focus behavior, placement/resize, semantic duplication, remove unused fixed width. |
| `menu` | General components — overlays, menus, and disclosure | Authoritative menu engine: roving focus, arrows/Home/End/typeahead, submenu direction/RTL, roles/states, pointer+touch, placement, focus restore; delete zero-duration CSS quirks. |
| `menubar` | General components — overlays, menus, and disclosure | Native composite focus model across top-level menus, arrow switching, Escape hierarchy, mnemonic/typeahead policy, touch alternative, semantics, and nonzero intentional feedback. |
| `popover` | General components — overlays, menus, and disclosure | Shared nonmodal lifecycle: anchor tracking, outside dismissal, Escape, optional focus entry, trigger restoration, scroll/resize and safe-area placement. |
| `select` | General components — overlays, menus, and disclosure | Noneditable select semantics, selected value announcement, complete keys, shared menu/overlay behavior, long option layout, focus restore, remove class-order styling. |
| `sheet` | General components — overlays, menus, and disclosure | Shared modal lifecycle and native route/insets; drag/dismiss policy, focus trap/restore, keyboard and safe area, flexible header/footer, reduced motion. |
| `tooltip` | General components — overlays, menus, and disclosure | Hover/focus/long-press parity, semantic description without duplicate speech, delay/dismiss rules, placement, no interactive content, reduced motion. |
| `user_menu` | General components — content, layout, and feedback | Make it a composed Menu contract rather than independent web behavior; trigger label/state, keyboard menu flow, focus restore, account copy, and narrow layout. |
| `calendar` | General components — content, layout, and feedback | Validate Flutter date/grid semantics, arrow-key model, locale/first-day rules, timezone-safe selection, focus movement, range states, 200% layout, and remove selector-derived quirks. |
| `navigation_menu` | General components — navigation and layout | Replace hover-dominant web navigation with pointer/touch/keyboard paths, correct composite focus, panel semantics, responsive alternative, and remove reproduced drifts. |
| `scroll_area` | General components — navigation and layout | Clarify specialized contract, native scrollbars/controllers/semantics, keyboard/wheel/touch, nested-scroll rules, no IntrinsicWidth/LayoutBuilder trap, large content. |
| `sidebar` | General components — navigation and layout | Remove reproduced drift register and 11.5px nav; responsive rail/drawer structure, keyboard navigation, current semantics, focus, touch rows, safe area, scaled text, persistence. |
| `table` | General components — content, layout, and feedback | Native header/cell semantics, keyboard/action access, sorting announcements, scalable rows, narrow stacked alternative guidance, horizontal scroll without unreachable controls. |
| `tabs` | General components — navigation and layout | One Tab stop with arrows/Home/End, selected/tab-panel semantics, focus/activation policy, scrollable/wrapping narrow behavior, 44px targets, indicator reduced motion. |
| `accordion` | General components — content, layout, and feedback | Replace CSS-height/cascade assumptions; semantic expanded state; keyboard activation; content grows at 200%; migrate trigger/body type. |
| `breadcrumb` | General components — content, layout, and feedback | Remove reproduced separator drift and browser list inheritance; semantic navigation/order/current item; wrap at narrow width; links keyboard/touch accessible. |
| `carousel` | General components — content, layout, and feedback | Native scroll/page physics, semantic position and actions, arrows/keys/touch, reduced motion, focus retention, resize behavior, and no clipped scaled content. |
| `collapsible` | General components — content, layout, and feedback | Native expanded semantics and keyboard activation; flexible animated size; reduced motion; state ownership and controller lifecycle. |
| `pagination` | General components — navigation and layout | Navigation semantics/current page, descriptive labels, keyboard/touch targets, compact responsive strategy without tiny type, disabled boundaries, and long page counts. |
| `resizable` | General components — navigation and layout | Native drag plus keyboard resizing, adjustable semantics, min/max constraints, RTL/axis handling, 44px effective handle, pointer cursors, persistence callbacks. |
| `safe_area` | General components — navigation and layout | Validate MediaQuery inset consumption, nested idempotence, keyboard/system gesture insets, edge selection, and page/overlay integration. |
| `agent_markdown` | Agent and voice entries | Native selectable rich text, links/code semantics and activation, copy, wrapping/overflow, headings/lists/tables, syntax contrast, large input performance and safe parsing. Remove Preflight assumptions. |
| `message_scroller` | General components — content, layout, and feedback | Native scroll anchoring, “new messages” announcements, user-versus-programmatic scroll ownership, keyboard access, reduced motion, resize/text-scale stress, and no CSS duration no-ops. |
| `attachment` | General components — content, layout, and feedback | Replace 12–13px utility roles, fixed compact geometry, hover-only affordances, and silent loading; validate remove/retry/download semantics and long filenames. |
| `bubble` | General components — content, layout, and feedback | Replace 13px/zero-duration CSS behavior; flexible content, reactions and actions accessible on touch, semantic speaker/order, long code and 200% stress. |
| `message` | General components — content, layout, and feedback | Semantic author/time/content ordering, scalable body/meta type, status not color-only, long content, copy/select behavior, and explicit action accessibility. |
| `chart` | Charts | Provide semantic summary/table alternative, series labels beyond color, locale formatting, empty/loading/error states, scale/text/theme/contrast and interaction policy. Remove selector-derived axis behavior. |
| `chart_cartesian` | Charts | Native painters/layout, axis/label collision strategy, touch+keyboard exploration, RTL, resize, large datasets, semantics delegated through chart contract. |
| `chart_polar` | Charts | Native painter/layout, label collision and tiny-slice policy, noncolor identification, touch+keyboard exploration, resize/RTL and semantic summary. |
| `ambient_pattern` | Effects and low-level interaction entries | Decorative-only semantics/IgnorePointer, theme contrast, reduced motion/TickerMode, repaint boundaries, resize and performance; remove selector ancestry assumptions. |
| `background_effect` | Effects and low-level interaction entries | Decorative-only, tokenized and theme-safe, no state meaning, resize/performance/reduced-motion validation; keep API small. |
| `chart_geometry` | Charts | Keep pure tested math; property/edge tests for NaN/infinity/zero ranges, precision and bounds; no UI or web-coordinate assumptions leak publicly. |
| `media_scrim` | Effects and low-level interaction entries | Decorative/token surface; validate contrast purpose, IgnorePointer/semantics, clipping and both themes. |
| `agent_attach_menu` | Agent and voice entries | Compose corrected Menu/Attachment contracts; keyboard/touch invocation, permissions/errors, focus restore, file-type labels and no hover-only actions. |
| `agent_composer` | Agent and voice entries | Native text editing/IME/keyboard inset, send/stop/attachment focus order, submitting lock, shortcuts without platform conflicts, validation, long text and error announcements. Remove DOM/drop assumptions. |
| `agent_console` | Agent and voice entries | Block-level regional state contracts, responsive shell, one scroll owner, safe areas/keyboard, focus traversal, loading/empty/error/reconnect, Toaster ownership and 200% stress. |
| `agent_history` | Agent and voice entries | Native list performance and scroll, rename/delete focus, keyboard/touch actions, confirmation/undo, empty/filter/error states, announcements and responsive structure. |
| `agent_launcher` | Agent and voice entries | Replace `vw/rem` dialog calculations with constraints/breakpoints; corrected Dialog lifecycle, trigger semantics/focus restore, narrow full-screen form, keyboard/safe-area behavior. |
| `agent_slash_palette` | Agent and voice entries | Compose corrected Command engine; remove documented no-op behavior, native filtering/keys, result announcements, empty state, focus return and IME compatibility. |
| `agent_transcript` | Agent and voice entries | Semantic message order/live updates, scalable typography, native scrolling/anchoring, tool/error disclosures, copy/actions, long code/media and no CSS type collapse. |
| `voice` | Agent and voice entries | Explicit permission/device/error/state machine, start/stop keyboard+semantics, announcements, lifecycle/background handling, reduced motion and platform capability fallbacks. |
| `agent_attachments` | Agent and voice entries | Responsive list/grid, file semantics, download/remove/retry states, long names, progress announcements, touch targets, and no silent actions. |
| `agent_avatar` | Agent and voice entries | Decorative versus meaningful semantics, state conveyed beyond color/motion, reduced motion/TickerMode, theme/contrast, sizing and shader/painter performance. |
| `agent_core` | Agent and voice entries | Keep domain/controller layer UI-free; typed states/errors/events, disposal, cancellation, concurrency and deterministic tests. Remove web-domain naming only where public meaning improves. |
| `agent_face` | Agent and voice entries | State semantics separate from animation, reduced motion, theme/contrast, painter/shader fallback and performance; decorative internals excluded. |
| `voice_indicator` | Agent and voice entries | Status expressed in text/semantics rather than orb color/motion, reduced motion/TickerMode, shader fallback/performance, resize/themes and decorative child exclusion. |
| `toaster` | General components — content, layout, and feedback | One app-level controller/host, live-region announcements, deterministic queue/update/dismiss timers, pause and swipe behavior, keyboard-accessible actions, focus safety, reduced motion, and no clocks expiring while content is invisibly queued. |
| `source_foundation` | Remaining catalog/support entries | Not a widget: regenerate from corrected authored foundation, accurate two-font/type/motion/theme contract, install rehearsal, hashes/licenses and immutable version policy. |
| `icon_paths` | Remaining catalog/support entries | Keep generated/source ownership explicit, validate every glyph and parser contract, do not expose generated index internals unnecessarily, no manual edits to generated files. |

## Workstream 2 — per component, per axis

One row per component file in `lib/src/components/ui/`, one column per axis. A cell is one of four things and each says how it was reached:

- **verified** — a named test in this repository asserts it; the test is in the notes.
- **audited** — the static sweep (`tool/`-external scripts, recorded under *Verification, exactly as run*) looked at this axis for this file and found nothing to fix. No dedicated test.
- **n/a** — the component has no such surface.
- **open** — a finding, stated in the notes.

`audited` is deliberately weaker than `verified`, and the difference is the point: a row is **not** complete because its typography passes. A row is complete on an axis only where that cell reads `verified`.

| Component | typography | interaction | overlay lifecycle | keyboard & focus | semantics | target sizing | text scale & reflow | motion | disposal | visual & perf | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|
| `accordion` | verified | verified | audited | verified | verified | audited | audited | audited | n/a | audited | **interaction** — test/interaction_kernel_test.dart (via Press)<br>**keyboard & focus** — test/interaction_kernel_test.dart (via Press)<br>**semantics** — test/interaction_kernel_test.dart (via Press) |
| `action_feedback` | n/a | n/a | audited | n/a | audited | n/a | n/a | audited | audited | audited | — |
| `active_indicator` | n/a | n/a | audited | n/a | audited | n/a | n/a | audited | audited | audited | — |
| `agent_attach_menu` | verified | audited | audited | audited | audited | audited | audited | n/a | n/a | audited | — |
| `agent_attachments` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `agent_avatar` | verified | n/a | audited | n/a | audited | n/a | audited | audited | audited | audited | — |
| `agent_composer` | verified | audited | audited | audited | audited | audited | audited | n/a | n/a | audited | — |
| `agent_core` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `agent_face` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `agent_history` | verified | audited | audited | audited | audited | audited | audited | audited | audited | audited | — |
| `agent_launcher` | verified | n/a | audited | n/a | audited | n/a | audited | audited | n/a | audited | — |
| `agent_markdown` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `agent_slash_palette` | verified | n/a | audited | n/a | audited | n/a | audited | audited | n/a | audited | — |
| `agent_transcript` | verified | n/a | audited | n/a | audited | n/a | audited | audited | audited | audited | — |
| `alert` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `alert_dialog` | verified | n/a | verified | verified | audited | n/a | audited | n/a | n/a | audited | **overlay lifecycle** — test/overlay_lifecycle_test.dart (same host)<br>**keyboard & focus** — test/overlay_lifecycle_test.dart (same host) |
| `ambient_pattern` | n/a | n/a | audited | n/a | audited | n/a | n/a | audited | audited | audited | — |
| `aspect_ratio` | n/a | n/a | audited | n/a | audited | n/a | n/a | n/a | n/a | audited | — |
| `attachment` | verified | audited | audited | audited | audited | audited | audited | audited | audited | audited | — |
| `avatar` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `background_effect` | n/a | n/a | audited | n/a | audited | n/a | n/a | n/a | n/a | audited | — |
| `badge` | verified | n/a | audited | n/a | audited | n/a | verified | n/a | n/a | audited | **text scale & reflow** — root suite — minHeight, flexed label |
| `breadcrumb` | verified | verified | audited | verified | audited | audited | audited | audited | n/a | audited | **interaction** — test/interaction_kernel_test.dart (via Press)<br>**keyboard & focus** — test/interaction_kernel_test.dart (via Press) |
| `bubble` | verified | audited | audited | audited | audited | audited | audited | audited | n/a | audited | — |
| `button` | verified | audited | audited | audited | audited | audited | audited | audited | n/a | audited | — |
| `button_group` | verified | n/a | audited | n/a | audited | n/a | open | n/a | n/a | audited | **text scale & reflow** — scrolls now; the docs specimen still composes a rigid row — see example/test/responsive_text_scale_test.dart |
| `calendar` | verified | audited | audited | audited | audited | audited | audited | audited | n/a | audited | — |
| `card` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `carousel` | verified | n/a | audited | n/a | audited | n/a | audited | audited | audited | audited | — |
| `chart` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `chart_cartesian` | verified | n/a | audited | n/a | audited | n/a | audited | audited | audited | audited | — |
| `chart_geometry` | verified | n/a | n/a | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `chart_polar` | verified | n/a | audited | n/a | audited | n/a | audited | audited | audited | audited | — |
| `checkbox` | verified | audited | audited | audited | audited | verified | audited | n/a | n/a | audited | **target sizing** — test/selection_feedback_test.dart (HitArea) |
| `collapsible` | verified | n/a | audited | n/a | audited | n/a | audited | audited | audited | audited | — |
| `combobox` | verified | audited | audited | audited | audited | open | audited | n/a | n/a | audited | **target sizing** — list rows, as `menu`. |
| `command` | verified | audited | audited | audited | audited | open | audited | n/a | n/a | audited | **target sizing** — list rows, as `menu`. |
| `content_change` | n/a | n/a | audited | n/a | audited | n/a | n/a | n/a | n/a | audited | — |
| `context_menu` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `dialog` | verified | audited | verified | verified | verified | audited | verified | audited | verified | audited | **overlay lifecycle** — test/overlay_lifecycle_test.dart<br>**keyboard & focus** — test/overlay_lifecycle_test.dart<br>**semantics** — test/overlay_lifecycle_test.dart<br>**text scale & reflow** — root suite — DialogFooter wraps<br>**disposal** — test/overlay_lifecycle_test.dart |
| `drawer` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `dropdown_menu` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `empty` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `feedback_surface` | n/a | n/a | audited | n/a | audited | n/a | n/a | audited | audited | audited | — |
| `field` | verified | audited | audited | audited | audited | audited | audited | n/a | n/a | audited | — |
| `form` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `glass` | n/a | n/a | audited | n/a | audited | n/a | n/a | n/a | n/a | audited | — |
| `hover_builder` | n/a | audited | audited | audited | audited | audited | n/a | audited | audited | audited | — |
| `hover_card` | verified | n/a | audited | n/a | audited | n/a | audited | audited | audited | audited | — |
| `icon` | n/a | n/a | audited | n/a | audited | n/a | n/a | n/a | n/a | audited | — |
| `icon_paths` | n/a | n/a | n/a | n/a | audited | n/a | n/a | n/a | n/a | audited | — |
| `icon_swap` | n/a | n/a | audited | n/a | audited | n/a | n/a | audited | audited | audited | — |
| `input` | verified | audited | audited | audited | audited | audited | audited | audited | n/a | audited | — |
| `input_group` | verified | audited | audited | audited | audited | audited | audited | audited | n/a | audited | — |
| `input_otp` | verified | audited | audited | audited | audited | audited | audited | audited | n/a | audited | — |
| `item` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `kbd` | verified | n/a | audited | n/a | audited | n/a | verified | n/a | n/a | audited | **text scale & reflow** — root suite — minHeight |
| `keyframes` | n/a | n/a | audited | n/a | audited | n/a | n/a | audited | audited | audited | — |
| `marker` | n/a | n/a | audited | n/a | audited | n/a | n/a | n/a | n/a | audited | — |
| `media_scrim` | n/a | n/a | audited | n/a | audited | n/a | n/a | n/a | n/a | audited | — |
| `menu` | verified | audited | audited | audited | audited | open | audited | n/a | n/a | audited | **target sizing** — rows are 36px and packed; a symmetric expansion would make each row answer for its neighbour. Reference geometry drives the scroll math. Decided: not expanded. |
| `menubar` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `message` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `message_scroller` | verified | n/a | audited | n/a | audited | n/a | audited | audited | n/a | audited | — |
| `native_select` | verified | audited | audited | audited | audited | audited | audited | audited | n/a | audited | — |
| `navigation_menu` | verified | audited | audited | audited | audited | audited | audited | audited | n/a | audited | — |
| `pagination` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `popover` | verified | audited | audited | audited | audited | audited | audited | audited | verified | audited | **disposal** — test/dialogs_test.dart |
| `premium_surface` | n/a | n/a | audited | n/a | audited | n/a | n/a | audited | audited | audited | — |
| `press` | n/a | verified | audited | verified | verified | verified | n/a | audited | audited | audited | **interaction** — test/interaction_kernel_test.dart<br>**keyboard & focus** — test/interaction_kernel_test.dart<br>**semantics** — test/interaction_kernel_test.dart<br>**target sizing** — test/interaction_kernel_test.dart |
| `progress` | verified | n/a | audited | n/a | audited | n/a | audited | audited | n/a | audited | — |
| `questionnaire` | verified | audited | audited | audited | audited | audited | audited | audited | audited | audited | — |
| `radio` | verified | audited | audited | audited | audited | verified | audited | n/a | n/a | audited | **target sizing** — test/selection_feedback_test.dart (HitArea) |
| `resizable` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `safe_area` | n/a | n/a | audited | n/a | audited | n/a | n/a | n/a | n/a | audited | — |
| `scroll_area` | verified | audited | audited | audited | audited | open | audited | n/a | n/a | audited | **target sizing** — the scrollbar is a pointer affordance duplicating the scrollable's own keyboard scrolling. Decided: not a control, not expanded. |
| `select` | verified | audited | audited | audited | audited | open | audited | audited | n/a | audited | **target sizing** — list rows, as `menu`. The trigger IS expanded. |
| `selection_control` | verified | verified | audited | verified | audited | verified | audited | audited | n/a | audited | **interaction** — test/selection_feedback_test.dart<br>**keyboard & focus** — test/selection_feedback_test.dart<br>**target sizing** — test/selection_feedback_test.dart (HitArea) |
| `separator` | n/a | n/a | audited | n/a | audited | n/a | n/a | n/a | n/a | audited | — |
| `sheet` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `sidebar` | verified | audited | audited | audited | audited | audited | audited | audited | audited | audited | — |
| `skeleton` | n/a | n/a | audited | n/a | audited | n/a | n/a | n/a | n/a | audited | — |
| `slider` | verified | n/a | audited | n/a | audited | n/a | audited | audited | n/a | audited | — |
| `spinner` | n/a | n/a | audited | n/a | audited | n/a | n/a | audited | audited | audited | — |
| `stat` | verified | n/a | audited | n/a | audited | n/a | verified | n/a | n/a | audited | **text scale & reflow** — root suite — figureMinHeightOf |
| `surface` | n/a | n/a | audited | n/a | audited | n/a | n/a | n/a | n/a | audited | — |
| `switch` | verified | audited | audited | audited | audited | verified | audited | audited | n/a | audited | **target sizing** — test/selection_feedback_test.dart (HitArea) |
| `table` | verified | n/a | audited | n/a | audited | n/a | audited | audited | n/a | audited | — |
| `tabs` | verified | verified | audited | verified | verified | verified | verified | audited | verified | audited | **interaction** — test/tabs_keyboard_test.dart<br>**keyboard & focus** — test/tabs_keyboard_test.dart<br>**semantics** — test/tabs_keyboard_test.dart<br>**target sizing** — test/tabs_keyboard_test.dart<br>**text scale & reflow** — test/tabs_keyboard_test.dart<br>**disposal** — test/tabs_keyboard_test.dart |
| `textarea` | verified | audited | audited | audited | audited | audited | audited | n/a | n/a | audited | — |
| `toaster` | verified | verified | audited | verified | verified | audited | audited | audited | audited | audited | **interaction** — test/interaction_kernel_test.dart (via Press)<br>**keyboard & focus** — test/interaction_kernel_test.dart (via Press)<br>**semantics** — test/interaction_kernel_test.dart (via Press) |
| `toggle` | verified | audited | audited | audited | audited | audited | audited | audited | n/a | audited | — |
| `toggle_group` | verified | n/a | audited | n/a | audited | open | verified | n/a | n/a | audited | **target sizing** — items are packed edge to edge; a standalone `Toggle` IS expanded.<br>**text scale & reflow** — root suite — scrolls |
| `tooltip` | verified | n/a | audited | n/a | audited | n/a | audited | audited | audited | audited | — |
| `user_menu` | verified | n/a | audited | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `validation_rule` | verified | n/a | n/a | n/a | audited | n/a | audited | n/a | n/a | audited | — |
| `voice` | verified | n/a | audited | n/a | audited | n/a | audited | audited | audited | audited | — |
| `voice_indicator` | verified | n/a | audited | n/a | audited | n/a | audited | audited | audited | audited | — |

## Foundation and support rows

| Item | Source | Disposition | Status | Evidence |
|---|---|---|---|---|
| `lib/src/design_system/foundation/typography.dart` | authored | **remove** the 27-class transcript, `TextColorRole`, `defaultColor`, `uppercase`, the fluid size functions, `Fonts.heading`, `Fonts.accent`; **translate** family/size/leading/weight/tracking/features into 17 roles with three responsive steps; **fix** the sub-14px reading sizes | complete | `test/foundation_type_motion_test.dart` — 17 roles asserted field by field, boundary tests at 767/768/1023/1024, no-ink test over every role |
| `lib/src/design_system/foundation/text_layout.dart` | authored | **keep** — `LineBox`/`InlineBox`/`glueInlineBoxes` are Flutter layout corrections, not CSS emulation | complete | `test/text_layout_test.dart` — one line is the role's own leading, for all 17 roles |
| `lib/src/design_system/foundation/theme_scope.dart` | authored | **remove** `Fluid`, colour-from-role resolution and the uppercase transform; **translate** `StyledText` into a width-resolving renderer; **keep** `ThemeScope`, `RichText`, `effectiveMotionDuration`; **document** `TypeWidthScope` as the region override | complete | `test/theme_scope_test.dart` — width scope, step resolution, inherited ink, authored text |
| `lib/src/design_system/foundation/colors.dart` | authored | pending | pending | — |
| `lib/src/design_system/foundation/theme.dart` | authored | pending | pending | — |
| `lib/src/design_system/foundation/spacing.dart` | authored | pending | pending | — |
| `lib/src/design_system/foundation/shadows.dart` | authored | pending | pending | — |
| `lib/src/design_system/foundation/surfaces.dart` | authored | pending | pending | — |
| `lib/src/design_system/foundation/motion.dart` | authored | pending | pending | — |
| `lib/src/design_system/foundation/media.dart` | authored | pending | pending | — |
| `lib/src/design_system/foundation/date_format.dart` | authored | **translate** — the day number derives tabular figures from `body` | complete | `test/calendar_test.dart` |
| `lib/elattar_design_system.dart` (public barrel) | authored | **keep** — whole-file exports, so `TypeGroup`, `TypeStep` and `TypeWidthScope` are public and the retired members are gone with their declarations | complete | `test/public_api_prefix_test.dart` |
| `pubspec.yaml` (SDK floor, fonts, assets) | authored | **remove** the Redaction 35 registration and packaged asset | fonts complete; **SDK floor still `flutter: >=1.17.0` and not yet corrected** | `test/assets_test.dart`, `test/license_distribution_test.dart` |

## What "type contract complete" means, and what it does not

Every one of the 100 rows above has had its **typography and any geometry
derived from typography** migrated to the native contract, and the whole root
suite is green against it. That is one batch of the master plan — Workstream 1
and the parts of Workstreams 3 and 4 that it forced.

It is **not** the full per-row acceptance in the plan's matrix. The
interaction-kernel, overlay-lifecycle, semantics, focus, 44x44-target and
reduced-motion audits (Workstream 2, and the per-row "validate" work) have not
been performed for these rows, and no row should be read as signed off on those
axes.

## Workstream 2 — what was changed, and what was decided against

### Changed

| Component | Axis | Change |
|---|---|---|
| `press` | interaction, keyboard & focus, semantics, target sizing | Rewritten as the shared activation contract. With `onTap` it is Tab-reachable, activated by Enter and Space through `FocusableActionDetector`, ringed on keyboard focus only, announced as a button or (with `link: true`) a link, and expanded to `TouchTargets.minimum` by the new public `TapTarget`. Without `onTap` it is still a decoration that takes no focus and adds no semantics. |
| `breadcrumb` | interaction, keyboard & focus, semantics | The link was a `GestureDetector` under a `MouseRegion`. It goes through `Press(link: true)` now. |
| `toaster` | interaction, keyboard & focus, semantics, target sizing | The action pill goes through `Press`. The card offers dismissal as `Semantics(onDismiss:)` rather than as a focusable control — a toast arrives unbidden and leaves on a clock, and moving focus into one takes the caret out of whatever the reader was doing. The pill's fixed height became a minimum. |
| `accordion` | interaction, keyboard & focus, semantics, target sizing | The trigger was focusable and ringed but answered no key. It goes through `Press` now, and announces `expanded`. |
| `tabs` | keyboard & focus, semantics, target sizing, text scale, disposal | The set owns one Tab stop and the focus nodes; arrows move between tabs (RTL-aware) and wrap, Home and End go to the ends, selection follows focus. The trigger height became a minimum and the trigger got a `TapTarget`. |
| `dialog` / `alert_dialog` (`OverlayPortal`) | overlay lifecycle, keyboard & focus, semantics | Focus is captured on open and returned on close; the panel takes the focus on the frame after it exists (`FocusScope(autofocus:)` alone does not, while the trigger holds the focus); `BlockSemantics` covers the page behind; a dismissible scrim is a named control and an inert one is not; the panel scopes the route with explicit child nodes. |
| `popover` | overlay lifecycle, keyboard & focus | Focus is captured on open and returned on dismissal — but only while the focus is still inside the popup, so a click elsewhere keeps whatever it landed on. The popup's own node is held for that test and disposed with the state. |
| `toggle`, `select`, `native_select` | target sizing | The trigger reaches 44px through `TapTarget`. Layout is untouched. |
| `chart` (`ChartLegendContent`) | text scale & reflow | A single-row legend that outgrows its column scrolls rather than clipping, and stays centred whenever it fits. |
| `tabs` docs page | keyboard & focus | The page's Accessibility and Keyboard sections said plainly that no keyboard interaction was wired at all, and `example/test/components_docs/tabs_test.dart` asserted the absence as a regression check — with a stated instruction to update both if it ever changed. Both were rewritten to the contract the set now keeps, and the check inverted. |
| `alert_dialog` docs test | overlay lifecycle | Asserted that autofocus rests on the panel's own `FocusScopeNode`. It now asserts the focus is inside the panel and on a control, which is what the dialog's own source has always said it does. |
| `press` docs page | documentation | The API table and the registry manifest's description and `exports` were rewritten: eleven new parameters, and `TapTarget` alongside `Press`. |
| `stat`, `chart_cartesian`, `text_layout.dart` | text scale & reflow | The delta number, the axis tick labels and the inline punctuation box flex instead of painting past their box. |

### Decided against, with the reason

| Component | Axis | Decision |
|---|---|---|
| `menu`, `select`, `combobox`, `command` (list rows) | target sizing | **Not expanded.** The rows are packed with no gap, so a symmetric hit expansion would make each row answer for its neighbour's edge — a worse failure than a small target. The row height also drives the popup's scroll math (`(index + 0.5) x itemHeight`), and the existing tests are authoritative on that geometry. |
| `toggle_group` items | target sizing | **Not expanded**, for the same reason. A standalone `Toggle` is. |
| `scroll_area` scrollbar | interaction, semantics, target sizing | **Not a control.** It duplicates the scrollable's own keyboard scrolling; making it focusable would add a Tab stop that does nothing new. |
| `input`, `textarea`, `input_otp`, `field` | keyboard & focus | **No change.** The tap handler focuses the field; `EditableText` owns the keyboard, and each announces `Semantics(textField: true)`. |
| `button_group`, `pagination` | text scale & reflow | **Not scrolled — tried and reverted.** Wrapping either `w-fit` row in its own horizontal scroll view unbounds the width its members measure against. That changed what every specimen of both components measures, and `IntrinsicHeight` over `ButtonGroup`'s slot render objects then flushed semantics against boxes that were never laid out (`RenderBox was not laid out`, 45 exceptions in one docs test). Six `button_group` and seven `pagination` docs tests caught it. Reverted; the consumer decides whether these rows scroll, as it does for a wide table. |
| The 18 docs specimen pages listed in `example/test/responsive_text_scale_test.dart` | text scale & reflow | **Deferred and named.** Each is a hand-built figure in `example/lib` laid out for a desktop column, not a library defect. The list is explicit: every route not on it is a live regression test. |

### Sweeps, as run

```sh
# interaction: a tap handler with no focus, no keyboard path, or no semantics
python kernel_audit.py       # 100 files: 1 / 5 / 5, every one classified above
# targets: a tap handler that never reaches TapTarget, HitArea, Press or Button
python target_audit.py       # 100 files: 10, every one classified above
```

Both scripts strip comments before matching, so prose does not count as code, and
both are case-insensitive on `disableAnimations` — a case-sensitive first pass
called two correct components broken. Motion is 0 findings across all 100 files:
every `AnimationController` disposes and every one is gated on
`effectiveMotionDuration` or `MediaQuery.disableAnimations`.

## Verification, exactly as run

Local toolchain: Flutter 3.44.8 (stable, revision 058e0af2c2), Dart 3.12.2, on
Windows 11. CI pins `channel: stable` and no version, so 3.44.8 is the oldest
Flutter this tree has actually been verified against — which is now what
`pubspec.yaml` claims.

| Command | Result |
|---|---|
| `dart format lib test tool/… example/lib example/test packages/…` | 647 files, 18 changed |
| `flutter analyze` (root) | no issues |
| `flutter test` (root) | **1514 passed, 0 failed** |
| `cd example && flutter analyze lib test` | no issues |
| `cd example && flutter test` | **1436 passed, 0 failed** |
| `cd example && flutter build web --release` | built `build/web` (77.9s compile) |
| `cd packages/elattar_cli && dart test` | **129 passed, 0 failed** |
| `cd tool/release_audit && dart test` | 32 passed |
| `cd tool/registry_builder && dart test` | 5 passed |
| `cd tool/release_registry && dart test` | 28 passed |
| `dart run tool/registry_builder/bin/reseal.dart --apply` | 56 + 3 pins across 54 + 3 manifests |
| `dart run tool/registry_builder/bin/build.dart .` | generated 99 items |
| `dart run tool/registry_builder/bin/validate.dart …/registry.json` | valid, 99 items, schema v1 |
| `dart run tool/release_audit/bin/verify.dart .` | **12 checks, 0 failures** |
| `git diff --check` | clean |

`packages/elattar_cli/test/public_consumer_test.dart` is the clean-consumer
rehearsal and is part of that green CLI run: it serves this repository's
generated registry over HTTP, runs `elattar init` and `elattar add` into an
empty project, then analyses and runs that project.

### Negative searches

- No authored source names a retired role. The only matches in the tree are the
  guard that forbids them (`example/test/docs/docs_no_uppercase_test.dart`) and
  a superseded rename script under `tool/migration/`.
- `Fonts.accent` and `Fonts.heading`: 0 occurrences.
- `TextColorRole`, `Fluid.`, `TextStyleToken.uppercase`: 0 occurrences.
- The semantic colour tokens are untouched: 97 `theme.accent` /
  `accentForeground` / `agentAccent` references remain.

### Scanner findings, unchanged by this batch

`dart run skills/elattar-flutter-ui-director/scripts/check_ui_completeness.dart
example/lib` reports 398 heuristic findings over the documentation app:
`dead-press` 239 (a component gallery's specimens have no-op handlers by
design), `raw-token` 128, `no-empty` 15, `no-loading` 7, `copy` 7,
`unlabelled-icon` 2. None of the sampled findings sit in code this batch
authored, and `test/token_guard_test.dart` — the enforced subset of the same
rule over `lib/` and `example/lib/` — is green.

---

## Correction: the 0.0.1 registry payloads (2026-08-31, after review)

The first pass regenerated `registry/generated/latest` while every authored
manifest still declared item version `0.0.1`, so 116 payload files published
under `/registry/0.0.1/` were rewritten in place. That is the one thing
`tool/README.md` §Immutability forbids: a CLI pinned to `/registry/0.0.1/`
would have started installing different sources.

**Restored.** `git diff v0.0.1 HEAD -- registry` was empty, so HEAD's bytes are
the released bytes; `git checkout HEAD -- registry/generated/latest` put them
back, and `git diff --quiet v0.0.1 -- registry/generated/latest` now exits 0.
Re-staging is a no-op:

```
dart run tool/release_registry/bin/stage.dart --version 0.0.1 --web-root example/build/web
  files 223   status already published, byte-identical
  tree hash 7939bb19890e6bdb0602143baf92737d3fc1a4baa2336775dbb33d40686628c9
```

**Republished as 0.0.2, per item.** 56 items changed their own bytes; the
reverse-dependency closure adds 38 more, because an item's version is a promise
about what installing it *does* and `form` installs `validation-rule`. 94 items
are at `0.0.2`; `aspect-ratio`, `chart-geometry`, `form`, `safe-area` and
`validation-rule` stay at `0.0.1` and regenerate byte-identically.

**Made structural rather than remembered.** `_writePayloads` no longer wipes its
output — it clears only the `<item>/<version>` it is about to write, plus items
the registry no longer has — and `registry/released/0.0.1.lock.json` plus
`test/registry_released_immutability_test.dart` fail the suite if any released
payload is ever regenerated with different bytes. The guard was verified by
mutating a payload and watching it fail.

## Correction: three typography deviations, decided

| Finding | Decision | Where |
|---|---|---|
| Accordion trigger used `nav`, mapping said `h4` | **`h4` applied** | `accordion.dart:266` |
| Alert title used `nav`, mapping said `h4` | **`h4` applied** | `alert.dart:170` |
| `StyledText` silently replaced the framework's error ink | **asserts in debug, substitutes in release** | `theme_scope.dart` |
| `TypeGroup`/`TypeStep`/`TypeWidthScope`/`derive` public by accident | **catalog reached by sets** (`wordRoles`/`codeRoles`/`numericRoles`); `ofGroup` removed; surface pinned | `typography.dart`, `test/typography_api_surface_test.dart` |

The assert immediately found 54 real cases of the thing it exists to catch: 53
component-doc test harnesses and `DocsLayout` itself mounted pages with no root
`DefaultTextStyle`, so every inherited string would have rendered in
`WidgetsApp`'s red fallback. `DocsLayout` now states its own ambient ink, which
fixes the product as well as the tests.
