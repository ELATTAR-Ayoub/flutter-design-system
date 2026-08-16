# Changelog

## 0.0.1 (unreleased)

1:1 Flutter port of Elattar's Design System (web reference:
`Design-System-2026-8/design-system`), verified side-by-side against the
running reference at 1440×900 in both themes.

* Foundation: colors (OKLab/OKLCH with chroma-reduction gamut mapping, ink
  contract), typography (reference font binaries, variable axes), spacing,
  radii, shadows (CSS-blur-exact), motion tokens (`dsAnimationDuration`
  reduced-motion resolver), path-drawn icon registry.
* Effects: machine surface (inset shadows), page glow, sheen, foil, glass.
* Motion: lift/press, sliding pill, keyframe player (linear-t, per-gap
  easing, ratchet).
* Components: button (7 variants, 9 cva sizes, emphasis, loading), icon
  (78 path-drawn glyphs), sheet, spinner, toggle + toggle group, kbd,
  button group, icon swap, input, textarea, input group, OTP, the field
  family (label-for activation, scope adoption, focus-on-error), form +
  dependency-free rule validator, checkbox/radio/switch on a shared
  selection socket, select, alert, toaster.
* Docs gallery (`example/`): ten pages — overview, colors, typography,
  spacing, shadows, motion, icons, buttons, inputs, forms — captured
  document heights equal the reference's in both themes (icons +21px:
  one sanctioned wrapping line; buttons ±1px: integral rounding of a
  +0.025px column), pixel residuals at the antialiasing floor.
* CanvasKit parity: inset rings paint as `drawDRRect` (the engine
  collapses a blurred difference-path to its inner region; the VM raster
  does not), guarded by rendered-pixel tests and a browser probe.
* Verification rig at `tool/verify/` (stitched captures, pixel diffs,
  section oracles); gallery boot params `?route= &theme= &motion=reduced`
  plus a js_interop scroll seam for deterministic capture.

* Base families complete (2026-08-16): selects/pickers, selection, dialogs & overlays, menus, navigation, feedback, chat, data display, charts, layout primitives, sidebar - 21 gallery pages at rig-verified height parity, 1074 package + 624 example tests, full generated Lucide registry.
