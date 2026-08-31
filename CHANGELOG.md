# Changelog

## 0.0.1

The first public release. Elattar becomes something a stranger can install.

### Distribution

* **A hosted, version-pinned registry, live at**
  <https://flutter.elattar.dev/registry/0.0.1/>. That path is immutable: a
  change ships as a new version rather than as a rewrite of a released one, so
  an installed `0.0.1` keeps installing the same sources. `--registry` accepts
  any other directory or `http(s)` URL.
* **The documentation site is live** at <https://flutter.elattar.dev>.
* **`elattar_cli` `0.0.1` on pub.dev.** `dart install elattar_cli` puts an
  `elattar` command on your PATH; `elattar init --foundation source` and
  `elattar add button` set up a Flutter project without cloning anything. The
  CLI has one dependency, so it is a small resolve rather than a tree to
  audit.
* **Integrity before mutation.** Every manifest and payload is verified
  against its declared sha256, and the entire install is downloaded and
  checked before the first file is written. A dropped connection or a
  substituted payload aborts with the project untouched.
* **Offline works.** Downloads are cached per user under the platform's own
  cache directory (`ELATTAR_CACHE_DIR` overrides). `--offline` reads only that
  cache and distinguishes a cache miss from a network failure.
* **`elattar add --all`** installs the complete registry in one command.

### Licensing and provenance

* **Elattar's own work is MIT** (`Copyright (c) 2026 ELATTAR Ayoub`). The
  standard text, unmodified — no added attribution clause.
* **Every redistributed third-party file has a provenance record.**
  `THIRD_PARTY_NOTICES.md` names the upstream source, version, retrieval date
  and content hash for each, and `third_party/` reproduces each license text
  verbatim. Two findings worth naming: lucide's `LICENSE` is not ISC alone —
  roughly 110 glyphs descend from Feather and carry a second MIT notice in the
  same file, so the icon generator now embeds the whole file rather than a
  transcription — and Redaction is dual OFL 1.1 / LGPL 2.1 per its publisher
  although the binary declares only the OFL.
* **Notices travel with what they cover.** A `@license/` registry target
  installs them into the consumer's `LICENSES/` directory: Elattar's MIT
  always, the three font OFL notices with the foundation, lucide's with
  `icon`, ElevenLabs UI's with `voice-indicator`.
* **`assets/textures/perlin-noise.png` was replaced.** It was a byte copy of a
  file whose original this repository could not name. It is now generated from
  a checked-in seed by `tool/generate_perlin_texture/`, matching the file it
  replaces on the properties the shader depends on — same mean, same value
  span, seamless wrap, smoother.

### Package

* **`v0.0.1` is cut at the commit the registry and the site were built from**,
  so an item's `sourceLink` resolves to the source that item actually
  distributes, and `ref: v0.0.1` on a git dependency is the released code.
* **The public API carries no prefix.** The names are ordinary nouns:
  `Button`, `Card`, `Icon`, `TextStyles`, and the `space(...)` spacing helper.
  A hard rename with no compatibility aliases, because `0.0.1` had not been
  published when it happened.
* **The registry covers the full component surface**: 99 items at schema
  v1, across 112 distributed source files. 97 components, one block, one foundation
  bundle.
* Foundation, components, effects, motion and the three font faces are
  described in the sections below; nothing about them changed at release.

### Known limitations

* **`--foundation package` is refused.** It wrote a dependency on a package
  named `elattar_core` that does not exist, producing a project that could not
  resolve. It stays refused until such a package is really published;
  `--foundation source` is the supported path.
* **The root `elattar_design_system` package is not on pub.dev.** Source
  installation through the CLI is the distribution route. The package is
  consumable from Git when the dependency model is what you want.
* **Conflicts are all-or-nothing.** If any target file differs from the
  registry's copy, `add` exits 73 and writes nothing. Re-run with
  `--overwrite` once you have saved what you meant to keep.
* **Accessibility has not been audited against assistive technology.** The
  sources disambiguate semantic labels, and widget tests cover focus order and
  keyboard reachability, but no screen-reader pass has been recorded.

---

## How this was built

The port history below is kept because it records why the package is the way
it is. It is a build log, not a statement of the current release; where the
two disagree, the release record above wins.

1:1 Flutter port of Elattar's Design System (web reference:
`Design-System-2026-8/design-system`), verified side-by-side against the
running reference at 1440×900 in both themes.

* Foundation: colors (OKLab/OKLCH with chroma-reduction gamut mapping, ink
  contract), typography (reference font binaries, variable axes), spacing,
  radii, shadows (CSS-blur-exact), motion tokens (`effectiveMotionDuration`
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
  the reference.** `Toaster` is now width-responsive: at or below sonner's own
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
  reporting rather than forking: `ButtonStyleRecipe.hoverBorder` (the fifth
  class-list override - `hover:border-agent/50` on the launcher pill and on the
  welcome card's capability chips, springing on `btn-spring`'s own clock because
  the border colour was already carried there), `MenuItem.subtitle` (the model
  picker's `flex-col items-start gap-1`, on `CommandItem.subtitle`'s terms and
  4px taller for the gap a command row does not write), and the twelve
  `--agent-cube-*` tokens, which moved out of `agent_avatar.dart` into
  `foundation/theme.dart` as `ThemeTokens.cube` - the same follow-up
  `bloom_cosmic.dart` closed, one family over. Foundations, Base and Agent are
  all built; the placeholder is now reachable only from Site.

* Public release infrastructure (2026-08-21): the source-first registry pilot
  (`registry/`, `tool/registry_builder/`, schema v1, sha256-verified payloads)
  and the `elattar_cli` package (`packages/elattar_cli/`, commands
  `elattar init` and `elattar add <slug>`) landed alongside the public website
  shell, the documentation system, per-component guide pages, and
  public-repository governance (README, CONTRIBUTING, CODE_OF_CONDUCT,
  SECURITY, issue templates, the CI and deploy workflows). At the time this
  landed neither the CLI nor the registry had a public route. Both the
  registry and the site went live afterwards; the CLI has not. The release
  record above is the current truth.

* Shots (2026-08-23): a `shot` registry item kind installs multi-file,
  product-neutral application compositions into a consumer's `@app/`, with an
  import-rewriting pass so an installed Shot compiles against the consumer's
  own generated barrels rather than the package. Three Shots ship -
  `settings-profile`, `sign-in-flow`, `dashboard-overview` - behind a
  filterable `/shots` index, a per-Shot detail page (install command, file
  tree, dependency list), and a chrome-free `/shots/<slug>/preview` route. The
  import rewriter was later hardened (`48c390b`) after an independent review
  found it rewrote text inside comments and string literals instead of
  stopping at Dart's directive prologue; the same commit added CI coverage for
  the `packages/elattar_cli` test suite and the registry build/validate
  steps. The registry covered 20 items at this point; it reached 99 before
  release. Shots were removed in `9c48294` when the site's information
  architecture was reworked, and no `shot` item ships in `0.0.1`.

* Skills (2026-08-23): the `elattar-flutter-ui-director` coding-agent skill
  moved from `.agents/skills/` - a path no agent harness scans - to `skills/`,
  and the repository became its own single-plugin Claude Code marketplace
  (`.claude-plugin/marketplace.json`, `.claude-plugin/plugin.json`, plugin
  version `0.0.1`). The skill's references are now mode-aware, distinguishing
  a checkout of this repository from a project that installed the design
  system through the CLI. `/skills` on the public site documents
  install/update/inspect/remove commands per route (Claude Code plugin,
  manual copy, `AGENTS.md`), gated by a `verifiedCommands` allowlist so a
  command cannot reach the page without a human adding it explicitly - the
  same discipline that retired an earlier, invented `npx skills add …` line.
  The licensing blocker named here closed with this release; each route's
  page states its own verification status.
