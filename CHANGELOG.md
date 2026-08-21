# Changelog

## 0.0.1

Initial public repository release for the maintained Flutter package.

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

* Toaster, compact anchor (2026-08-16) - **the one deliberate departure from
  the reference.** `DsToaster` is now width-responsive: at or below sonner's own
  `@media (max-width: 600px)` breakpoint the stack anchors to the TOP of the
  screen, grows downward, enters from the top edge and takes its swipe-dismiss
  direction from that anchor. Top placement on small screens was ordered;
  sonner's mobile block reskins whichever y-position is already set and never
  moves it, and `app/layout.tsx` mounts `position="bottom-right"` as a literal,
  so the reference itself keeps a bottom stack on a phone. Its mobile
  *geometry* is adopted whole - the 600px breakpoint, the 16px
  `MOBILE_VIEWPORT_OFFSET` on every edge, the toast widening to fill the
  viewport between those insets. One substitution, not a fork: the anchor flips
  `--lift` and every rule in the choreography is already a multiple of it. The
  wide bottom-right contract is unchanged and still pinned.

* Agent family complete (2026-08-17): console, avatar, composer, transcript,
  history, voice - 27 gallery routes wired, each of the six at rig-verified
  reading-column parity inside the probe's half-pixel band and none of them
  needing a named residual (largest, transcript, +0.14). 1398 package + 779
  example tests. Three primitives grew the slot their agent call site had been
  reporting rather than forking: `DsButtonSurface.hoverBorder` (the fifth
  class-list override - `hover:border-agent/50` on the launcher pill and on the
  welcome card's capability chips, springing on `btn-spring`'s own clock because
  the border colour was already carried there), `DsMenuItem.subtitle` (the model
  picker's `flex-col items-start gap-1`, on `DsCommandItem.subtitle`'s terms and
  4px taller for the gap a command row does not write), and the twelve
  `--agent-cube-*` tokens, which moved out of `agent_avatar.dart` into
  `foundation/theme.dart` as `DsThemeData.cube` - the same follow-up
  `bloom_cosmic.dart` closed, one family over. Foundations, Base and Agent are
  all built; the placeholder is now reachable only from Site.
