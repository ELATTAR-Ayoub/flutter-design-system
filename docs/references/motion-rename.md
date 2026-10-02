# Motion rename record, 2026-09-22: the fourteen

The motion vocabulary is fourteen names. Twelve recipes in
`lib/src/components/ui/keyframes.dart`, plus two transitions: `Press`
(`press.dart`) and `ActiveIndicator` (`active_indicator.dart`).

Mirrors the web design system's own `docs/references/motion-rename.md`, so
both platforms name the same fourteen things.

## Classes

| Retired | Now |
|---|---|
| `EntranceMotion`, `SpringEntranceMotion`, `FadeUp`, `RowMotion`, `_PanelIn`, `_FadeIn` | `EnterMotion` |
| `BlurSwitchController` (out half), `RowMotion` (leave), `_ConfirmSlide` | `ExitMotion` |
| each overlay's private `_XTransition`, `MenuMotion` | `OpenMotion` / `CloseMotion`, played by `OpenTransition` |
| collapsible and accordion's own durations | `ExpandMotion` (reverse is collapse) |
| `StateChangeMotion`, `CheckmarkDrawMotion`, `DashDrawMotion`, `DotSelectionMotion` | `ChangeMotion` |
| the spinner's own controller, `DiscreteProgressMotion` | `SpinMotion` |
| `LoadingShimmerMotion` | `ShimmerMotion` (`textDuration` for the agent status line) |
| the progress bar's own controller | `ProgressMotion` |
| `LivePulseMotion` | `PulseMotion` |
| `TextRevealMotion` (the OTP caret) | `CaretMotion` |
| `ContentSwapMotion` | `SwapRollMotion` |
| `Press(scale:)` at 0.94, `InteractiveCard`, the slider's thumb scales | `Press` at 0.9, no `scale` parameter |
| `RevealMotion`, `SweepMotion`, `TravelMotion`, `TextRevealFrame` | removed, nothing used them |

## Tokens

| Retired | Note |
|---|---|
| `MotionDurations.reward`, `popIn`, `springUp`, `signOn`, `ratchet`, `ratchetStep`, `checkDraw`, `dashDraw`, `dotPop`, `pressSpringUp`, `copyConfirmation`, `frame`, `overlayExit`, `close`, `collapse`, `expand` | the fourteen read the seven-step scale instead |
| `MotionTransforms.clickSpringScale`, `pressSpringScale`, `buttonPress`, `sliderThumbHoverScale`, `sliderThumbActiveScale`, `liftY`, `keyDownY` | one `MotionTransforms.press = 0.9` |
| `MotionCurves.balanced`, `decelerate`, `symmetric`, `linear`, `vaul` | seven curves remain; `Curves.linear` is Flutter's own, and vaul's curve lives in `drawer.dart` |

The scale is now `tick 80` · `fast 150` · `normal 250` · `slow 400` ·
`overlayEnter 320` · `open 420` · `bloom 1000`, plus one constant per looping
animation or surface, plus the third-party behaviour timers (tooltip and
hover-card delays, toast lifetimes, menu typeahead, scroll-area hide, select
auto-scroll) which are not animations and were never vocabulary.

## Component-owned, not vocabulary

These stay with the component that owns them and never counted toward the
fourteen: `AgentCubeMotion` (`agent_avatar.dart`), `ChartMotion`
(`chart.dart`), `SheetTransition` (`sheet.dart`), the drawer's slide and its
vaul curve (`drawer.dart`).

## Behaviour that changed

* A removed history row no longer animates its own gap closed.
* The checkbox tick and the radio dot pop rather than draw themselves on.
* Switching conversations is an exit followed by an entrance, not a blur.
* Slider thumbs and buttons press at 0.9 like everything else.
