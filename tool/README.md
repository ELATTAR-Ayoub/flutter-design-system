# `tool/`

| tool | job |
|---|---|
| `generate_icons.mjs` | emits the full lucide glyph registry from the reference's own installed package |
| `generate_perlin_texture/` | regenerates the voice orb's tiling noise field from a checked-in seed |
| `registry_builder/` | builds and validates `registry/generated/latest` from the source manifests |
| `release_registry/` | stages a generated registry into the published site artifact |
| `verify/` | the side-by-side pixel-parity rig — see `verify/README.md` |

---

# `release_registry/` — publishing a registry version

The CLI pins `https://elattar-ayoub.github.io/flutter-design-system/registry/<version>/`
and refuses to follow a moving target. This tool is what makes that pin mean
something.

## Staging a release

Run it **after** `flutter build web`, because that build clears its own output
directory:

```sh
cd example && flutter build web --release --base-href /flutter-design-system/ && cd ..
dart run tool/release_registry/bin/stage.dart --version 0.0.1 --web-root example/build/web
```

That copies `registry/generated/latest` to
`example/build/web/registry/0.0.1/`, validates the copy, and writes a
`release.json` beside it recording the version, schema version, item count,
file count, tree hash and the commit it was generated from.

`--alias` also writes a mutable `/registry/latest/` for browsing. **A released
CLI must never default to it** — that is the whole distinction this tool
exists to keep.

## Immutability

Staging over an existing version with different bytes is refused, and the
refusal happens before a single file is written, so a rejected re-stage cannot
leave the published version half-replaced.

```
Refusing to overwrite the published registry 0.0.1 with different bytes.
A released version is immutable: a CLI pinned to /registry/0.0.1/ would
silently start installing different sources.
Publish a new version instead.

  - versions/button/0.0.1/logical/ui/button.dart would change
```

Re-staging *identical* bytes is a no-op and exits 0, so re-running a deploy is
safe. If you meant to change what a version installs, that is a new version.

## What the validator checks

Not the generated registry — the generator already did that — but the copy
that will actually be served: `index.json` and `registry.json` agree on
version and item count, every item's manifest is present and matches its
catalog entry, every dependency edge lands on an item that shipped, and every
declared sha256 matches the staged payload's bytes.

## Why Dart and not shell steps in the workflow

So the behaviour a maintainer runs locally and the behaviour CI runs are the
same code. Path handling is the first thing a shell copy step gets wrong on
Windows, and a release tool that only works on the runner is a tool nobody can
debug.

---

# `generate_icons.mjs` — the lucide registry

## Rerun

```sh
node tool/generate_icons.mjs        # from the repo root
```

No arguments, no flags, no network. It reads

```
design-system/node_modules/lucide-react/dist/esm/icons/
```

— the reference repo's own installed package, resolved relative to this
repo — and overwrites two files:

```
lib/src/components/icon_paths.g.dart        the 1756 glyphs
lib/src/components/icon_paths.g.index.dart  the string → glyph lookup
```

Both carry the pinned version in their header. Rerun after any
`npm install` in the reference repo that moves lucide, then run
`flutter test test/icon_paths_generated_test.dart` — that suite is what
decides whether the new output is trustworthy (see *The identity check*).

## Why Node and not Dart

The source of truth is a tree of ES modules. The generator `import()`s each
one and reads the `__iconNode` array **lucide itself exports**, so the
geometry is verbatim *by construction* — nothing re-parses lucide's
JavaScript and there is no second transcription to get wrong.

A Dart generator would have had to re-implement a JavaScript reader, which
is exactly the risk `lib/src/components/icon_paths.dart` was hand-written to
avoid. The generator throws rather than guessing: an unknown tag, an
unhandled attribute, a `fill` that is not `currentColor`, a coordinate that
is not a plain decimal, or an odd number of `points` all abort the run.

## The identity check

`icon_paths.dart` holds 78 glyphs transcribed **by hand** from these same
modules. The generator's claim to be trustworthy for the other 1678 rests on
reproducing those 78 exactly, and
`test/icon_paths_generated_test.dart` asserts it element for element and
character for character.

It passes. Every `d` string, every coordinate, every `ry`, every `fill`, and
every element's position in its list is identical between the two. That
includes the details the hand transcription was written to catch and a
careless generator would smooth away:

- `ticket`'s `d` closes with an **uppercase `Z`**. The parser treats `Z` and
  `z` identically, so a silent lowercasing would never fail a rendering
  test — it is asserted on the character.
- `zap`'s packed arc flags (`a1.5 1.5 0 00-2.474-1.561` — two flags and a
  coordinate with no separator at all).
- `x.mjs`'s two diagonals, one absolute and one relative: same shape, two
  spellings, both kept.
- shared geometry stays shared: `shield` and `shield-check` open with the
  same crest, and `circle-x` borrows all three of its nodes.

## What the package actually contains

lucide-react **1.28.0**, ISC.

| | |
|---|---|
| modules exporting `__iconNode` | **1756** |
| deprecated aliases (re-export one-liners) | **250** |
| nodes | **7032** |

Nodes by tag: 5932 `path`, 524 `circle`, 397 `rect`, 155 `line`, 16
`ellipse`, 6 `polyline`, 2 `polygon`.

No node carries a `stroke`, `stroke-width`, `opacity`, `transform`,
`fill-rule` or any other presentation attribute. The only non-geometry
attribute in the whole package is `fill="currentColor"`, on 19 `circle`
nodes across 9 glyphs.

## Findings — things the curated 78 did not contain

The hand file generalises from 78 glyphs. Three of those generalisations do
not survive the whole package, and one glyph is an upstream defect.

### 1. `ellipse` exists (16 nodes, 15 glyphs)

`icon_paths.dart` used to call `ellipse` "the one lucide never reaches for".
True of the curated 78; false of the package — `database` and its nine siblings,
`cone`, `cylinder`, `drum`, `ellipse` and `torus` all use it, and every one
is genuinely non-circular (`rx != ry`), so none could be demoted to a
`circle`. **New element type.**

### 2. `polygon` exists (2 nodes)

`icon_paths.dart`'s polyline doc used to say "closing is what `polygon` means,
and lucide emits none". `navigation` and `navigation-2` are polygons.

Both happen to repeat their first point as their last, so a polyline through
the same list would trace the same *geometry* — but it would meet itself
with two round **caps** instead of a round **join**. Writing it that way
would be a silent rewrite of the kind the file's "structure over
stringification" ruling forbids, so `polygon` is a type of its own.
**New element type.**

### 3. `rect` may omit `rx` (5 nodes)

`icon_paths.dart` stated "lucide writes `ry` only where it equals `rx`".
True of the 78. In the package, four nodes spell `ry` with **no `rx` at
all** (`arrow-down-0-1`, `arrow-down-1-0`, `arrow-up-0-1`, `arrow-up-1-0`)
and one spells neither (`spray-can`).

SVG's mutual-auto rule applies: an absent `rx` takes `ry`'s value and vice
versa, and absent together means square corners. The generator resolves it
**at emit time**, explicitly, and records the omission in a trailing comment
(`// key: 1bwicg; rx absent (= ry)`) so the transcript still shows what
lucide wrote. The pre-merge `ElIconRectElement` took `rx` as a non-null
positional, which could not express the distinction at all; both radii are
nullable now and the element applies the rule itself, so a hand transcript can
spell the omission where the generator states the resolved value — see
*The merge*.

### 4. `save-off` is broken upstream — reproduced deliberately

`save-off.mjs`'s sixth node is

```
"M29.5 11.5s5 5 4 5"
```

a stroke running from x = 29.5 to x = 34.5, **entirely outside** the
`viewBox="0 0 24 24"` its other six nodes are drawn in. lucide-react 1.28.0
ships it that way. A browser never shows it, because the outermost `<svg>`
clips to its viewport by default.

Measured across all 1756 glyphs, `save-off` is the **only** one that leaves
the grid, and it leaves it by 10.5 units. The runner-up (`line-squiggle`)
touches x = 24 exactly and no further; every other glyph is strictly inside,
control points included. So this is one bad node, not a slope.

The generator reproduces it verbatim — dropping or "fixing" a node would
make the registry disagree with its source and hide the defect. **The
consequence is a renderer decision, not a data one**, and it has been taken:
`ElIcon.paintGlyph` clips to the 24-grid with a single `Canvas.clipRect`,
which is the browser's own rule rather than a special case for one glyph.
Measured on the rendered pixels, at 24 px on a 40×24 surface:

| | inked pixels beyond x = 24 | rightmost inked column |
|---|---|---|
| unclipped | **31** | 34 |
| clipped | **0** | 22 |

Inside the grid the two agree to within 13/255 of alpha on 21 pixels — Skia
rasterising a clipped draw slightly differently, not geometry going missing.
The anti-assertion is byte-for-byte: `at-sign` (the closest any embedded
glyph comes to the edge, 0.98 units inside it) and `line-squiggle` (the whole
package's runner-up, touching x = 24 exactly) render **identically** clipped
and unclipped, because the clip never meets their geometry. Both pins are in
`test/icon_paths_generated_test.dart`.

## Bundle size and tree-shaking

**The design constraint:** the registry is the whole of lucide, and the whole
of lucide must not reach the bundle of an app that draws six icons.

### What tree-shakes in Dart

dart2js and the AOT compiler shake per **top-level symbol**:

- A `static const` field is dropped when nothing names it. ✅
- A `const Map`/`const List` is **one symbol holding every value**. Touching
  it retains everything in it. ❌
- A `switch` over an enum that returns a different constant per case
  references every one of them, so calling it retains all of them. ❌
- An `enum` retains its members' data through `values` and through any map
  keyed on it. ❌

So an `enum ElIconGlyph { … }` plus a `const Map<ElIconGlyph, List<…>>` — the
shape the curated 78 use, which is right for 78 — is **all-or-nothing** at
1756. There is no arrangement of a name-keyed lookup that avoids this: going
from a runtime string to a glyph requires naming every glyph.

### The shape chosen

`ElLucide` is a class of 1756 `static const` fields, one per glyph. Naming
`ElLucide.zap` pulls in `zap` and nothing else — the Dart spelling of the
property `lucide-react` gets on the web by shipping one module per icon and
letting the bundler drop the rest.

The string lookup still exists, because "lucide-level flexibility" needs it —
but it lives in its **own library**, `icon_paths.g.index.dart`, so importing
it is an opt-in with a price, not a default that everybody pays.

### Measured

`flutter build web --release`, Flutter 3.44.8, identical app shell in every
variant, glyph chosen from a query parameter so nothing folds away:

| variant | `main.dart.js` | gzip −9 | Δ raw | Δ gzip |
|---|---|---|---|---|
| shell only, registry not imported | 1,505,742 | 461,784 | — | — |
| **1 glyph** (`ElLucide.zap`) | 1,512,008 | 463,634 | **+6,266** | **+1,850** |
| **6 glyphs**, chosen at runtime | 1,514,136 | 464,716 | **+8,394** | **+2,932** |
| **whole set** via `elLucideLookup` | 1,939,598 | 607,590 | **+433,856** | **+145,806** |

Read it as:

- **Importing the 1756-glyph library and naming one glyph costs 6.3 KB, not
  434 KB.** That is the whole claim, measured.
- Of that 6.3 KB, ~5.8 KB is fixed — the element model and the SVG path
  reader — and ~426 bytes is the glyph. The marginal glyph after the first
  costs **426 bytes raw / 216 bytes gzipped**.
- Taking the string index costs **52× what six glyphs cost**. Worth it if you
  need it, and now a priced, deliberate choice.

**Effect on this repo's example gallery: +2 bytes.** Measured, not assumed —
the gallery was built with the two generated files present and again with
them deleted from the package:

| | `main.dart.js` |
|---|---|
| gallery with the registry in the package | 2,641,677 |
| gallery with the registry deleted | 2,641,675 |
| **Δ** | **+2 bytes** (0.00008%) |

Two bytes on 2.6 MB is build noise, not content: nothing imports
`icon_paths.g.dart`, so dart2js never loads the library at all. A generated
file that nobody names is free, and adding 1756 glyphs to this package costs
the gallery nothing.

## The merge — done

The generated registry used to ship its **own** node model (`ElLucideNode`
and its seven subclasses) because `ElIconElement` is `sealed` and cannot be
extended from another library, while the full set needs two node types the
hierarchy did not have (`ellipse`, `polygon`) plus a `rect` whose `rx` may be
absent. That shim is gone. `icon_paths.dart` now declares all seven types,
and this file is emitted **against them**: `EL_ICON_MODEL` still selects the
table, `SEALED` is the default, and `SHIM` is kept only because re-running
under it reproduces the pre-merge file's node lines byte for byte.

The parser never was duplicated — the shim's `addTo` delegated to
`ElIconPathElement` — so all 5932 `d` strings have always gone through the
port's own reader.

**The merge changed no data.** Re-running under `SEALED` and renaming the
seven types in the pre-merge output gives back the new file's registry
character for character: 7032 node lines, 690,808 → 727,724 bytes of purely
type-name growth, and `icon_paths.g.index.dart` identical outright. The
78-glyph identity check in `test/icon_paths_generated_test.dart` still
passes, and now compares one model to itself rather than two models to each
other — its two signature functions collapsed into one.

One integration step remains out of scope, and is not required for the
registry to be correct:

- **Rendering.** `ElIcon` takes a `ElIconGlyph`; a `ElLucideGlyph` needs
  either a second constructor or a widened parameter. `ElIcon.paintGlyph` is
  already the seam — it takes a `Path`, not a glyph — and `ElIcon.strokeFor`,
  the per-size stroke retune that is the reason this port draws paths instead
  of using an icon font, is geometry-independent and needs no change at all.
  Nothing imports `icon_paths.g.dart` from `lib/` today, which is what keeps
  the gallery's cost at the +2 bytes measured above.

**The curated/off-set distinction survives untouched.** The generated set is
the *universe*; `lib/el/icons.ts`'s curated 63 stay an explicit list, and the
icons page's registry keeps enumerating them by name. Nothing about making
1756 glyphs available changes which ones that page prints — which is the
point of keeping the two lists separate, and `example/test/icons_page_test.dart`
passes unmodified through this merge.
