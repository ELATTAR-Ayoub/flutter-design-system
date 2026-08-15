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
* Components (phase 3, in progress): button (7 variants, 9 sizes), icon,
  sheet, input, and the buttons/inputs/forms families.
* Docs gallery (`example/`): overview, colors, typography, spacing,
  shadows, motion, icons — captured document heights equal the reference's
  in both themes (icons +21px: one sanctioned wrapping line, recorded in
  its drift register).
* Verification rig at `tool/verify/` (stitched captures, pixel diffs,
  section oracles); gallery boot params `?route= &theme= &motion=reduced`
  plus a js_interop scroll seam for deterministic capture.
