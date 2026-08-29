# Theming

Every color, type, radius, shadow, duration, and curve resolves from the
foundation. Light and dark are not a finishing step: a surface that was never
opened in dark mode is not finished.

## Where color comes from

`ThemeScope.of(context)` returns `ThemeTokens`. Use the semantic name, never a
hex value and never a color copied from a screenshot.

| Role | Tokens |
| --- | --- |
| Page and surfaces | `background`, `foreground`, `card`, `cardForeground`, `popover`, `popoverForeground`, `muted`, `mutedForeground` |
| Action | `primary`, `primaryForeground`, `actionText`, `accent`, `accentForeground` |
| Structure | `border`, `input`, `ring`, `rim`, `rimStrong` |
| Status | `successText`, `warningText`, `infoText`, `destructive`, `destructiveText`, `destructiveForeground` |
| Navigation | `sidebar`, `sidebarForeground`, `sidebarPrimary`, `sidebarAccent`, `sidebarBorder`, `sidebarRing` |
| Data | the chart tokens, in order, one per series |
| Agent | `agentAccent`, `agentAccentMuted`, `messageAccent` |

Rules:

- Status colors carry meaning. Do not use `destructive` because red looks good,
  and do not use `successText` for a neutral highlight.
- Status is never carried by color alone. Pair it with an icon or a word. See
  [accessibility.md](accessibility.md).
- `Theme.of(context)` is a parallel visual system. Do not read from it, and do
  not style Material widgets into looking like system components. Use the
  system component instead.
- Never adjust a foundation token to fix one screen. If a token is genuinely
  wrong, that is a foundation change with cross system evidence.

## Type

`StyledText` with `TextStyles` by role. Never a raw font size, weight, letter
spacing, or line height outside the foundation. Numeric type for metrics, so
figures align. Headings come from the role, not from picking a larger size.

## Geometry and depth

`space(...)` for spacing, `Radii` for corners, `Shadows` for depth,
`LayoutWidths` and `Containers` for measure. A local constant that holds a
literal is the same violation with an extra step.

## Motion

`MotionDurations` and `MotionCurves`, or the motion widgets. No `Duration`
literals and no stock Flutter curves outside the foundation.

## Effects

`Surface`, `Glass`, `FeedbackSurface`, `PremiumSurface`, `BackgroundEffect`,
`AmbientPattern`, and `MediaScrim` reinforce hierarchy. At most one supporting
effect per surface. Every effect must work in both themes, and none of them may
carry state or meaning: state is text and controls.

## Verifying both themes

Render every state in both themes, not just the default state. The states that
break are the ones nobody opens twice: the error alert, the disabled control,
the skeleton, the focused input, the selected row, and anything layered over a
`Glass` or `BackgroundEffect` surface.

In repository mode `test/token_guard_test.dart` enforces the no literal rule
mechanically. Consumer mode has no guard, so the same rule is applied by review
and by the scanner in [verify.md](verify.md).

## Checklist

- [ ] No raw color, size, weight, radius, shadow, duration, or curve outside the foundation.
- [ ] No literal hidden behind a local constant.
- [ ] All color from `ThemeScope.of(context)` by semantic role.
- [ ] `Theme.of(context)` is not used as a parallel system.
- [ ] Status colors used only for their meaning, never alone.
- [ ] Every state rendered and inspected in light and dark.
- [ ] At most one supporting effect, working in both themes.
