# `tool/`

| tool | job |
|---|---|
| `generate_icons.mjs` | emits the full lucide glyph registry from the reference's own installed package |
| `verify/` | the side-by-side pixel-parity rig — see `verify/README.md` |

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

`icon_paths.dart` calls `ellipse` "the one lucide never reaches for". True of
the curated 78; false of the package — `database` and its nine siblings,
`cone`, `cylinder`, `drum`, `ellipse` and `torus` all use it, and every one
is genuinely non-circular (`rx != ry`), so none could be demoted to a
`circle`. **New element type.**

### 2. `polygon` exists (2 nodes)

`icon_paths.dart`'s polyline doc says "closing is what `polygon` means, and
lucide emits none". `navigation` and `navigation-2` are polygons.

Both happen to repeat their first point as their last, so a polyline through
the same list would trace the same *geometry* — but it would meet itself
with two round **caps** instead of a round **join**. Writing it that way
would be a silent rewrite of the kind the file's "structure over
stringification" ruling forbids, so `polygon` is a type of its own.
**New element type.**

### 3. `rect` may omit `rx` (5 nodes)

`icon_paths.dart` states "lucide writes `ry` only where it equals `rx`".
True of the 78. In the package, four nodes spell `ry` with **no `rx` at
all** (`arrow-down-0-1`, `arrow-down-1-0`, `arrow-up-0-1`, `arrow-up-1-0`)
and one spells neither (`spray-can`).

SVG's mutual-auto rule applies: an absent `rx` takes `ry`'s value and vice
versa, and absent together means square corners. The generator resolves it
**at emit time**, explicitly, and records the omission in a trailing comment
(`// key: 1bwicg; rx absent (= ry)`) so the transcript still shows what
lucide wrote. The current `DsIconRectElement` takes `rx` as a required
positional, which cannot express the distinction — see *The merge*.

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
consequence is a renderer decision, not a data one:** `_GlyphPainter` in
`icon.dart` scales but does not clip, so this glyph would paint outside its
own box and overlap whatever sits to its right. Clipping to the viewBox, as
the browser does, is the fix, and it belongs in the painter.

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

So an `enum DsIconGlyph { … }` plus a `const Map<DsIconGlyph, List<…>>` — the
shape the curated 78 use, which is right for 78 — is **all-or-nothing** at
1756. There is no arrangement of a name-keyed lookup that avoids this: going
from a runtime string to a glyph requires naming every glyph.

### The shape chosen

`DsLucide` is a class of 1756 `static const` fields, one per glyph. Naming
`DsLucide.zap` pulls in `zap` and nothing else — the Dart spelling of the
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
| **1 glyph** (`DsLucide.zap`) | 1,512,008 | 463,634 | **+6,266** | **+1,850** |
| **6 glyphs**, chosen at runtime | 1,514,136 | 464,716 | **+8,394** | **+2,932** |
| **whole set** via `dsLucideLookup` | 1,939,598 | 607,590 | **+433,856** | **+145,806** |

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

## The merge

The generated registry currently ships its **own** node model
(`DsLucideNode` and its seven subclasses) rather than reusing
`DsIconElement` from `icon_paths.dart`. That is deliberate and temporary:

- `DsIconElement` is `sealed`, so it cannot be extended from another
  library, and the full set needs two node types it does not have
  (`ellipse`, `polygon`) plus a `rect` whose `rx` may be absent.
- `icon_paths.dart` was being edited by another workstream when this landed,
  so extending it in place was not available.

**The parser is not duplicated.** `DsLucidePath.addTo` delegates straight to
`DsIconPathElement` — the port's own reader, unchanged — so all 5932 `d`
strings go through the same code the hand-transcribed 78 do.

To retire the shim:

1. In `icon_paths.dart`, add `DsIconEllipseElement` and
   `DsIconPolygonElement` to the sealed hierarchy, and make
   `DsIconRectElement`'s `rx` nullable with SVG's mutual-auto rule
   (`rx ?? ry ?? 0`). Update the two docstrings the findings above falsify.
2. Regenerate against the real model — the constructor call shapes do not
   change, only the type names, which is why the generator carries them in
   one table:

   ```sh
   DS_ICON_MODEL=SEALED node tool/generate_icons.mjs
   ```

3. Delete the `emitModel()` output (the flag already suppresses it) and
   point `test/icon_paths_generated_test.dart`'s
   `_generatedSignature` at `DsIconElement`.

Two further integration steps, both out of scope here and neither required
for the registry to be correct:

- **Rendering.** `DsIcon` takes a `DsIconGlyph`; a `DsLucideGlyph` needs
  either a second constructor or a widened parameter. Note that
  `DsIcon.strokeFor` — the per-size stroke retune that is the reason this
  port draws paths instead of using an icon font — is geometry-independent
  and needs no change at all.
- **The curated/off-set distinction survives untouched.** The generated set
  is the *universe*; `lib/ds/icons.ts`'s curated 63 stay an explicit list, and
  the icons page's registry keeps enumerating them by name. Nothing about
  making 1756 glyphs available changes which ones that page prints — which is
  the point of keeping the two lists separate.
