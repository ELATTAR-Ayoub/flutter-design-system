/// Icon geometry — a transcript of lucide-react's own icon nodes.
///
/// Source of truth: `design-system/node_modules/lucide-react/dist/esm/icons/`
/// — lucide-react **1.28.0**, ISC, both confirmed in that package's
/// `package.json`. One module per glyph; [DsIconGlyph] names them all and each
/// entry in [DsIconPaths.elements] carries its module in a header comment.
///
/// Each module exports `__iconNode`: an ordered list of `[tag, attributes]`
/// SVG elements drawn on lucide's 24×24 grid and stroked, via the `<svg>`
/// wrapper in `dist/esm/Icon.mjs` + `dist/esm/defaultAttributes.mjs`, with
/// `fill="none" stroke="currentColor" stroke-width="2"
/// stroke-linecap="round" stroke-linejoin="round"`. [DsIconPaths.elements] is
/// that list transcribed element for element and attribute for attribute —
/// `d` strings copied character for character, lowercase relative commands,
/// packed signs and leading-dot decimals included — with each element's lucide
/// `key` kept as a trailing comment so the transcription stays auditable
/// against the package. Those keys are content hashes, so glyphs that share
/// geometry share a key (`shield` and `shield-check` open with the same crest
/// under key `oel41y`; seven glyphs share the 10-unit ring `1mglay`, and
/// `circle-x` borrows every node it has) — a
/// mismatched key is therefore a transcription bug, not a coincidence.
///
/// **Recorded decision: structure over stringification.** `line`, `circle`,
/// `rect` and `polyline` nodes are kept as their own element types rather than
/// rewritten into `d` strings. A rewrite would be a second, unverifiable
/// transcription; these map onto `moveTo`/`lineTo`, [Path.addOval] and
/// [Path.addRRect] exactly.
///
/// **Recorded decision: geometry only.** No colour, no px size, no stroke
/// width lives here — `icon.dart` owns the size ladder, the tone map and the
/// web's stroke-width formula, and scales this 24-unit path to the rendered
/// box. That is also why this file is not a token file: it states no design
/// value, only the shape of a third-party glyph. The one attribute that is
/// *almost* colour — `fill="currentColor"` on one node — is transcribed as the
/// boolean [DsIconElement.filled], not as a colour, for the same reason.
library;

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Every glyph this package embeds.
///
/// Named after their lucide file names (`arrow-left` → [arrowLeft]) — with the
/// three exceptions below, which are named after the **curated** name instead.
///
/// Two populations share this enum:
///
///  * **Docs chrome**, first, from `assets-map.md` §3: [menu] and [x] for the
///    mobile nav sheet, [sun]/[monitor]/[moon] for the theme toggle,
///    [arrowLeft] and [arrowRight] for the foot nav and index cards, [check]
///    (with [x]) for the do/don't lists.
///  * **The curated set** — the 63 entries of `lib/ds/icons.ts`, which the
///    icons page renders in full, listed below in that file's own four groups
///    and group order. Four of them ([arrowLeft], [arrowRight], [x], [check])
///    are already above as docs chrome and are not repeated.
///
/// Three curated names are **deprecated lucide aliases** in 1.28.0:
/// `filter.mjs`, `help-circle.mjs` and `alert-triangle.mjs` contain nothing but
/// a re-export, and the geometry lives in `funnel.mjs`,
/// `circle-question-mark.mjs` and `triangle-alert.mjs`. The enum keeps the
/// curated spelling — [filter], [helpCircle], [alertTriangle] — because that is
/// the string the page prints and the name the whitelist uses; each transcript
/// comment below cites the module the geometry actually came from, so an audit
/// against `filter.mjs` does not find an empty file and conclude the
/// transcription is wrong.
enum DsIconGlyph {
  // ── docs chrome ──
  menu,
  x,
  sun,
  monitor,
  moon,
  arrowLeft,
  arrowRight,
  check,

  // ── curated · "Navigation & structure" (21 entries; ArrowLeft and
  //    ArrowRight are entries 18–19 and sit above as docs chrome) ──
  package,
  radio,
  layers,
  gift,
  trophy,
  wallet,
  user,
  search,
  bell,
  settings,
  logOut,
  layoutGrid,
  rows3,
  chevronDown,
  chevronUp,
  chevronLeft,
  chevronRight,
  ellipsis,
  externalLink,

  // ── curated · "Actions" (19 entries; X and Check are entries 18–19 and sit
  //    above as docs chrome) ──
  packageOpen,
  shoppingCart,
  heart,
  eye,
  eyeOff,
  share2,
  copy,
  filter,
  slidersHorizontal,
  plus,
  minus,
  refreshCw,
  download,
  upload,
  truck,
  trash2,
  ban,

  // ── curated · "Collectible domain" (11 entries) ──
  sparkles,
  crown,
  flame,
  zap,
  star,
  tag,
  percent,
  medal,
  activity,
  trendingUp,
  trendingDown,

  // ── curated · "Money & status" (12 entries) ──
  circleDollarSign,
  creditCard,
  arrowDownLeft,
  arrowUpRight,
  hourglass,
  clock,
  lock,
  shield,
  shieldCheck,
  info,
  helpCircle,
  alertTriangle,

  // ── off-set ──
  /// `rotate-ccw.mjs`. **Not** one of the curated 63 — the motion page's replay
  /// control needs it, and the icons page's registry must not list it.
  rotateCcw,

  /// `loader-circle.mjs`. **Not** one of the curated 63 — `Spinner` is the only
  /// thing that renders it, and the icons page's registry must not list it.
  ///
  /// The reference imports it as **`Loader2Icon`** (`components/ui/spinner.tsx`
  /// L2). In lucide-react 1.28.0 `loader-2.mjs` is a one-line re-export of
  /// `loader-circle.mjs`, the same aliasing that makes [filter], [helpCircle]
  /// and [alertTriangle] point at other modules — but the opposite naming
  /// choice, because no curated list prints "Loader2" and the module the
  /// geometry comes from is the honest name.
  loaderCircle,

  /// `play.mjs`. Off-set: the buttons page's `PlayPauseDemo` renders it inside
  /// an `IconSwap`, and no curated list contains it.
  play,

  /// `pause.mjs`. The other half of that swap.
  pause,

  /// `volume-2.mjs`. Off-set: the buttons page's `MuteDemo`.
  volume2,

  /// `volume-x.mjs`. The other half of the mute swap. It shares its speaker
  /// body with [volume2] — the same `d`, under the same key `uqj9uw` — and
  /// differs only in what stands beside it: two arcs there, a cross here.
  volumeX,

  /// `circle-check.mjs`. Off-set: sonner's `TOAST_ICONS.success`
  /// (`components/ui/sonner.tsx` L19), imported there as `CircleCheckIcon`.
  ///
  /// Not to be confused with `check-circle.mjs`, which in 1.28.0 re-exports
  /// **`circle-check-big.mjs`** — a different glyph with a longer tick. The
  /// alias and the module are not two names for one shape here, which is why
  /// the module name is the one worth carrying.
  circleCheck,

  /// `octagon-x.mjs`. Off-set: sonner's `TOAST_ICONS.error` (L22), imported
  /// there as `OctagonXIcon`. `x-octagon.mjs` is its deprecated alias.
  octagonX,

  /// `circle-x.mjs`. Off-set: the forms page's server-error `Alert`, which
  /// imports it as **`XCircle`** (`…/base/forms/page.tsx` L4, rendered at
  /// L246).
  ///
  /// Named after the module rather than the import, on [loaderCircle]'s
  /// precedent and for its reason: `x-circle.mjs` in 1.28.0 is a one-line
  /// re-export of this module, no curated list prints either spelling, and the
  /// file the geometry lives in is the honest name. The three glyphs that
  /// *keep* their alias spelling ([filter], [helpCircle], [alertTriangle]) do
  /// so only because the icons page prints those strings.
  ///
  /// It is [octagonX]'s cross inside [circleCheck]'s ring: all three of its
  /// nodes are shared geometry, and all three carry their neighbours' keys.
  circleX,

  /// `at-sign.mjs`. Off-set (ruling I6): the inputs page's Email addon.
  ///
  /// Its ring is a **4**-unit circle, not the 10-unit `1mglay` one the status
  /// glyphs share — it is the `@`'s inner bowl, with the sweep around it drawn
  /// as the companion path.
  atSign,

  /// `ticket.mjs`. Off-set (ruling I6): the inputs page's Invite-code addon.
  ///
  /// The only glyph in the embedded set whose `d` closes with an **uppercase**
  /// `Z`. Transcribed as lucide writes it: the parser treats the two spellings
  /// identically, so a silent lowercasing would never fail a test — which is
  /// exactly why the transcript has to carry the character it was given.
  ticket,

  /// `calendar.mjs`. Off-set: the selects page's **two** `Icon Calendar` sites
  /// — the date picker's trigger and its disabled twin (`…/base/selects
  /// /page.tsx` L344, L381) — and nothing else in the corpus renders it.
  ///
  /// Off-set rather than curated on the same test the other eleven pass: it is
  /// not in `lib/ds/icons.ts`'s sixty-three, so the icons page's registry must
  /// keep excluding it. Note that [clock] — its neighbour in meaning — **is**
  /// curated, entry 6 of "Money & status"; a page that shows both would print
  /// one and not the other.
  ///
  /// The only glyph in the embedded set whose `rect` carries an `rx` and no
  /// `ry`, so its corners are circular rather than elliptical; the parser
  /// falls `ry` back to `rx`, which is what SVG says to do.
  calendar,
}

/// One SVG element from a lucide `__iconNode` list.
///
/// Sealed, and now **complete**: `path`, `line`, `circle`, `rect`, `ellipse`,
/// `polyline` and `polygon` are every tag lucide 1.28.0 emits, counted over the
/// whole package rather than inferred from a sample — 5932 path, 524 circle,
/// 397 rect, 155 line, 16 ellipse, 6 polyline, 2 polygon, and `tool/README.md`
/// records the tally that says so. A new node type is a new subclass here, not
/// a special case at the call site.
///
/// Five of the seven appear in the glyphs transcribed by hand below.
/// [DsIconEllipseElement] and [DsIconPolygonElement] arrived with the generated
/// registry (`icon_paths.g.dart`), which is the same 24-unit model applied to
/// all 1756 modules; they live here, in the sealed hierarchy, because a sealed
/// class cannot be extended from another library and because one model for both
/// halves is what lets the identity check compare them element for element.
@immutable
sealed class DsIconElement {
  const DsIconElement();

  /// Whether this node carries `fill="currentColor"`.
  ///
  /// The `<svg>` wrapper lucide renders sets `fill="none" stroke="currentColor"
  /// stroke-width="2"` (`dist/esm/defaultAttributes.mjs`), and a node that sets
  /// `fill` overrides **only** that one attribute — it keeps the inherited
  /// stroke. So a filled node is stroked *as well*, and this flag adds a paint
  /// pass rather than swapping one. `tag.mjs`'s 0.5-unit dot is the only one in
  /// the embedded set.
  bool get filled => false;

  /// Appends this element to [path] as its own subpath, in lucide's 24-unit
  /// coordinate space.
  void addTo(Path path);
}

/// `["path", { d: … }]` — the SVG path data, verbatim.
///
/// The string is parsed on every [addTo] rather than pre-baked into a [Path]:
/// a const element cannot hold a mutable [Path], and handing out a shared one
/// would let a caller mutate every future icon.
class DsIconPathElement extends DsIconElement {
  const DsIconPathElement(this.d);

  /// The `d` attribute, character for character as lucide ships it.
  final String d;

  @override
  void addTo(Path path) => _SvgPathParser(d).run(path);
}

/// `["line", { x1, y1, x2, y2 }]` — one straight stroke.
///
/// Constructor order is `(x1, y1, x2, y2)`, i.e. point-then-point; lucide
/// writes the attributes `x1, x2, y1, y2`, so the transcription below reorders
/// them deliberately.
class DsIconLineElement extends DsIconElement {
  const DsIconLineElement(this.x1, this.y1, this.x2, this.y2);

  /// `x1` — start x.
  final double x1;

  /// `y1` — start y.
  final double y1;

  /// `x2` — end x.
  final double x2;

  /// `y2` — end y.
  final double y2;

  @override
  void addTo(Path path) {
    path.moveTo(x1, y1);
    path.lineTo(x2, y2);
  }
}

/// `["circle", { cx, cy, r }]` — a closed circular subpath.
///
/// [filled] transcribes `fill="currentColor"`, which one node in the set
/// carries. See [DsIconElement.filled]: it is an extra paint pass, not a
/// replacement for the inherited stroke.
class DsIconCircleElement extends DsIconElement {
  const DsIconCircleElement(this.cx, this.cy, this.r, {this.filled = false});

  /// `cx` — centre x.
  final double cx;

  /// `cy` — centre y.
  final double cy;

  /// `r` — radius.
  final double r;

  @override
  final bool filled;

  @override
  void addTo(Path path) =>
      path.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
}

/// `["rect", { x, y, width, height, rx?, ry? }]` — a closed rounded-rect
/// subpath.
///
/// Among the glyphs transcribed by hand below, lucide always writes `rx` and
/// writes `ry` only where it equals it (`copy.mjs` and `lock.mjs` are the two,
/// both `rx: "2", ry: "2"`); everywhere else `ry` is absent and SVG's "`ry`
/// defaults to `rx`" rule applies. Either way the corner radius comes out
/// uniform — but [ry] is transcribed rather than assumed, so the test can
/// assert the equality instead of the file quietly relying on it.
///
/// **That generalisation does not survive the whole package**, which is why
/// both radii are nullable. Four nodes spell `ry` with no `rx` at all
/// (`arrow-down-0-1`, `arrow-down-1-0`, `arrow-up-0-1`, `arrow-up-1-0`) and one
/// spells neither (`spray-can`). SVG's rule for the pair is *mutual*: an absent
/// `rx` takes `ry`'s value, an absent `ry` takes `rx`'s, and absent together
/// means square corners — which is exactly what [addTo] reads. A model that
/// took `rx` as a non-null number could not say "absent" at all, and would have
/// to guess. See `tool/README.md`.
///
/// Constructor order is `(x, y, width, height, rx)`; lucide usually writes
/// `width, height, x, y, rx` — `gift.mjs` is the one that writes
/// `x, y, width, height, rx` — so the transcription reorders deliberately.
class DsIconRectElement extends DsIconElement {
  const DsIconRectElement(
    this.x,
    this.y,
    this.width,
    this.height,
    this.rx, {
    this.ry,
  });

  /// `x` — left edge.
  final double x;

  /// `y` — top edge.
  final double y;

  /// `width`.
  final double width;

  /// `height`.
  final double height;

  /// `rx` — corner radius on the x axis, when lucide writes it. `null` means
  /// the attribute is absent and the radius falls back to [ry].
  final double? rx;

  /// `ry` — corner radius on the y axis, when lucide writes it. `null` means
  /// the attribute is absent and the radius falls back to [rx].
  final double? ry;

  @override
  void addTo(Path path) => path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, width, height),
          // SVG's mutual-auto rule, both directions, and square when neither
          // is written.
          Radius.elliptical(rx ?? ry ?? 0, ry ?? rx ?? 0),
        ),
      );
}

/// `["polyline", { points }]` — an **open** run of straight segments.
///
/// `moveTo` the first point, `lineTo` the rest, and no `close()`: closing is
/// what [DsIconPolygonElement] means. `package.mjs`'s
/// `points: "3.29 7 12 12 20.71 7"` is the only polyline in the embedded set;
/// the package holds six, `mailbox`'s being the one whose `points` are
/// comma-separated rather than space-separated.
class DsIconPolylineElement extends DsIconElement {
  const DsIconPolylineElement(this.points);

  /// The `points` attribute, parsed into its coordinate pairs in source order.
  final List<Offset> points;

  @override
  void addTo(Path path) {
    if (points.isEmpty) return;
    path.moveTo(points.first.dx, points.first.dy);
    for (final Offset point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
  }
}

/// `["ellipse", { cx, cy, rx, ry }]` — a closed elliptical subpath.
///
/// None of the glyphs transcribed by hand below use one, which is what the old
/// docstring on [DsIconElement] generalised into "the one lucide never reaches
/// for". Over the whole package it appears **16 times across 15 glyphs** —
/// `database` and its nine siblings, `cone`, `cylinder`, `drum`, `ellipse` and
/// `torus` — and every one of the 16 is genuinely non-circular (`rx != ry`), so
/// not one of them could have been demoted to a [DsIconCircleElement] without
/// changing the drawn shape.
///
/// [Rect.fromCenter] takes diameters, so both radii are doubled here; a circle
/// is the `rx == ry` case of the same call, and stays its own type because
/// lucide spells it as its own tag.
class DsIconEllipseElement extends DsIconElement {
  const DsIconEllipseElement(this.cx, this.cy, this.rx, this.ry);

  /// `cx` — centre x.
  final double cx;

  /// `cy` — centre y.
  final double cy;

  /// `rx` — radius on the x axis.
  final double rx;

  /// `ry` — radius on the y axis.
  final double ry;

  @override
  void addTo(Path path) => path.addOval(
        Rect.fromCenter(
          center: Offset(cx, cy),
          width: rx * 2,
          height: ry * 2,
        ),
      );
}

/// `["polygon", { points }]` — the same run of segments as a polyline, but
/// **closed**.
///
/// lucide emits two, `navigation` and `navigation-2`, and neither is in the
/// hand-transcribed set — which is what let [DsIconPolylineElement]'s old
/// docstring say "lucide emits none".
///
/// **Why this is a type of its own and not a polyline with a repeated point.**
/// Both polygons happen to repeat their first point as their last, so a
/// polyline through the same list would trace the same *geometry*. It would not
/// paint the same: an open contour meeting itself is two round **caps**, while
/// a closed one is a round **join**, and lucide's `<svg>` sets both
/// `stroke-linecap="round"` and `stroke-linejoin="round"` precisely because
/// they are different operations. Spelling a polygon as a polyline would be a
/// silent rewrite of the kind this file's "structure over stringification"
/// ruling forbids.
class DsIconPolygonElement extends DsIconElement {
  const DsIconPolygonElement(this.points);

  /// The `points` attribute, parsed into its coordinate pairs in source order.
  final List<Offset> points;

  @override
  void addTo(Path path) {
    if (points.isEmpty) return;
    path.moveTo(points.first.dx, points.first.dy);
    for (final Offset point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    path.close();
  }
}

/// The embedded lucide glyphs.
class DsIconPaths {
  const DsIconPaths._();

  /// The viewBox lucide authors on: `viewBox="0 0 24 24"`, so 24×24.
  ///
  /// Every number in [elements] is in these units. Callers scale by
  /// `renderedPx / viewBox` — never by re-authoring the geometry.
  static const double viewBox = 24;

  /// Verbatim `__iconNode` per glyph, in file order.
  ///
  /// Order matters twice: it is the paint order, and it is what makes this a
  /// diffable transcript of the eight `.mjs` files.
  static const Map<DsIconGlyph, List<DsIconElement>> elements =
      <DsIconGlyph, List<DsIconElement>>{
    // `menu.mjs` — three 16-unit rules at y = 5 / 12 / 19.
    DsIconGlyph.menu: <DsIconElement>[
      DsIconPathElement('M4 5h16'), // key: 1tepv9
      DsIconPathElement('M4 12h16'), // key: 1lakjw
      DsIconPathElement('M4 19h16'), // key: 1djgab
    ],

    // `x.mjs` — two diagonals. The first is absolute with an implicit
    // `lineto`, the second is the relative spelling of the same idea; both are
    // kept exactly as authored.
    DsIconGlyph.x: <DsIconElement>[
      DsIconPathElement('M18 6 6 18'), // key: 1bl5f8
      DsIconPathElement('m6 6 12 12'), // key: d8bk6v
    ],

    // `sun.mjs` — a circle plus eight rays; nine subpaths in total.
    DsIconGlyph.sun: <DsIconElement>[
      DsIconCircleElement(12, 12, 4), // key: 4exip2
      DsIconPathElement('M12 2v2'), // key: tus03m
      DsIconPathElement('M12 20v2'), // key: 1lh1kg
      DsIconPathElement('m4.93 4.93 1.41 1.41'), // key: 149t6j
      DsIconPathElement('m17.66 17.66 1.41 1.41'), // key: ptbguv
      DsIconPathElement('M2 12h2'), // key: 1t8f8n
      DsIconPathElement('M20 12h2'), // key: 1q8mjw
      DsIconPathElement('m6.34 17.66-1.41 1.41'), // key: 1m8zz5
      DsIconPathElement('m19.07 4.93-1.41 1.41'), // key: 1shlcs
    ],

    // `monitor.mjs` — screen, stand foot, stand neck.
    DsIconGlyph.monitor: <DsIconElement>[
      // width: 20, height: 14, x: 2, y: 3, rx: 2
      DsIconRectElement(2, 3, 20, 14, 2), // key: 48i651
      // x1: 8, x2: 16, y1: 21, y2: 21
      DsIconLineElement(8, 21, 16, 21), // key: 1svkeh
      // x1: 12, x2: 12, y1: 17, y2: 21
      DsIconLineElement(12, 17, 12, 21), // key: vw1qmm
    ],

    // `moon.mjs` — one subpath: a 9-unit large arc, a cubic hook, a 6-unit arc
    // back and a second hook. The only glyph in this set that uses `A`/`a`, and
    // therefore the only one that exercises the arc conversion.
    DsIconGlyph.moon: <DsIconElement>[
      DsIconPathElement(
          'M20.985 12.486a9 9 0 1 1-9.473-9.472c.405-.022.617.46.402.803a6 6 0 0 0 8.268 8.268c.344-.215.825-.004.803.401'), // key: kfwtm
    ],

    // `arrow-left.mjs` — head first, then the shaft.
    DsIconGlyph.arrowLeft: <DsIconElement>[
      DsIconPathElement('m12 19-7-7 7-7'), // key: 1l729n
      DsIconPathElement('M19 12H5'), // key: x3x0zl
    ],

    // `arrow-right.mjs` — shaft first, then the head. Mirrors arrow-left
    // geometrically but not in element order — kept as lucide ships it.
    DsIconGlyph.arrowRight: <DsIconElement>[
      DsIconPathElement('M5 12h14'), // key: 1ays0h
      DsIconPathElement('m12 5 7 7-7 7'), // key: xquz4c
    ],

    // `check.mjs` — one stroke: the long fall, then the relative short rise.
    DsIconGlyph.check: <DsIconElement>[
      DsIconPathElement('M20 6 9 17l-5-5'), // key: 1gmf2c
    ],

    // ─── curated · "Navigation & structure" ─────────────────────────────────

    // `package.mjs` — the closed box, the vertical seam, the lid ridge and the
    // strap crease. Element 3 is the set's only `polyline`.
    DsIconGlyph.package: <DsIconElement>[
      DsIconPathElement(
          'M11 21.73a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73z'), // key: 1a0edw
      DsIconPathElement('M12 22V12'), // key: d0xqtd
      // points: "3.29 7 12 12 20.71 7"
      DsIconPolylineElement(<Offset>[
        Offset(3.29, 7),
        Offset(12, 12),
        Offset(20.71, 7),
      ]), // key: ousv84
      DsIconPathElement('m7.5 4.27 9 5.15'), // key: 1c824w
    ],

    // `radio.mjs` — two pairs of broadcast arcs, inner then outer on each
    // side, around a 2-unit core.
    DsIconGlyph.radio: <DsIconElement>[
      DsIconPathElement('M16.247 7.761a6 6 0 0 1 0 8.478'), // key: 1fwjs5
      DsIconPathElement('M19.075 4.933a10 10 0 0 1 0 14.134'), // key: ehdyv1
      DsIconPathElement('M4.925 19.067a10 10 0 0 1 0-14.134'), // key: 1q22gi
      DsIconPathElement('M7.753 16.239a6 6 0 0 1 0-8.478'), // key: r2q7qm
      DsIconCircleElement(12, 12, 2), // key: 1c9p78
    ],

    // `layers.mjs` — the closed top plate, then two open sweeps for the sheets
    // beneath it.
    DsIconGlyph.layers: <DsIconElement>[
      DsIconPathElement(
          'M12.83 2.18a2 2 0 0 0-1.66 0L2.6 6.08a1 1 0 0 0 0 1.83l8.58 3.91a2 2 0 0 0 1.66 0l8.58-3.9a1 1 0 0 0 0-1.83z'), // key: zw3jo
      DsIconPathElement(
          'M2 12a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 1.65 0l8.58-3.9A1 1 0 0 0 22 12'), // key: 1wduqc
      DsIconPathElement(
          'M2 17a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 1.65 0l8.58-3.9A1 1 0 0 0 22 17'), // key: kqbvx6
    ],

    // `gift.mjs` — the ribbon drop, the box, the bow, and the lid as a `rect`.
    DsIconGlyph.gift: <DsIconElement>[
      DsIconPathElement('M12 7v14'), // key: 1akyts
      DsIconPathElement(
          'M20 11v8a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-8'), // key: 1sqzm4
      DsIconPathElement(
          'M7.5 7a1 1 0 0 1 0-5A4.8 8 0 0 1 12 7a4.8 8 0 0 1 4.5-5 1 1 0 0 1 0 5'), // key: kc0143
      // x: 3, y: 7, width: 18, height: 4, rx: 1 — the one rect lucide writes
      // position-first; every other spells width and height first.
      DsIconRectElement(3, 7, 18, 4, 1), // key: 1hberx
    ],

    // `trophy.mjs` — the two stem halves, the right and left handles, the base
    // rule and the closed cup.
    DsIconGlyph.trophy: <DsIconElement>[
      DsIconPathElement(
          'M10 14.66V17a1 1 0 0 1-1 1 2 2 0 0 0-2 2v2'), // key: pwuv1l
      DsIconPathElement(
          'M14 14.66V17a1 1 0 0 0 1 1 2 2 0 0 1 2 2v2'), // key: 1y54w1
      DsIconPathElement(
          'M17.916 10H19.5A2.5 2.5 0 0 0 22 7.5V5a1 1 0 0 0-1-1h-3'), // key: e30mpu
      DsIconPathElement('M4 22h16'), // key: 57wxv0
      DsIconPathElement(
          'M6 9a6 6 0 0 0 12 0V3a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1z'), // key: 1mhfuq
      DsIconPathElement(
          'M6.084 10H4.5A2.5 2.5 0 0 1 2 7.5V5a1 1 0 0 1 1-1h3'), // key: i0yafy
    ],

    // `wallet.mjs` — the flap with its card slot, then the body.
    DsIconGlyph.wallet: <DsIconElement>[
      DsIconPathElement(
          'M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1'), // key: 18etb6
      DsIconPathElement(
          'M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4'), // key: xoc0q4
    ],

    // `user.mjs` — the shoulders, then the head.
    DsIconGlyph.user: <DsIconElement>[
      DsIconPathElement(
          'M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2'), // key: 975kel
      DsIconCircleElement(12, 7, 4), // key: 17ys0d
    ],

    // `search.mjs` — the handle first, then the lens.
    DsIconGlyph.search: <DsIconElement>[
      DsIconPathElement('m21 21-4.34-4.34'), // key: 14j7rj
      DsIconCircleElement(11, 11, 8), // key: 4ej97u
    ],

    // `bell.mjs` — the clapper, then the dome. The dome is the set's longest
    // run of absolute cubics.
    DsIconGlyph.bell: <DsIconElement>[
      DsIconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
      DsIconPathElement(
          'M3.262 15.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673C19.41 13.956 18 12.499 18 8A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326'), // key: 11g9vi
    ],

    // `settings.mjs` — the twelve-lobed cog as one subpath of alternating
    // 2.34-unit arcs, then the hub.
    DsIconGlyph.settings: <DsIconElement>[
      DsIconPathElement(
          'M9.671 4.136a2.34 2.34 0 0 1 4.659 0 2.34 2.34 0 0 0 3.319 1.915 2.34 2.34 0 0 1 2.33 4.033 2.34 2.34 0 0 0 0 3.831 2.34 2.34 0 0 1-2.33 4.033 2.34 2.34 0 0 0-3.319 1.915 2.34 2.34 0 0 1-4.659 0 2.34 2.34 0 0 0-3.32-1.915 2.34 2.34 0 0 1-2.33-4.033 2.34 2.34 0 0 0 0-3.831A2.34 2.34 0 0 1 6.35 6.051a2.34 2.34 0 0 0 3.319-1.915'), // key: 1i5ecw
      DsIconCircleElement(12, 12, 3), // key: 1v7zrd
    ],

    // `log-out.mjs` — the arrow head, the shaft, then the doorway it leaves.
    DsIconGlyph.logOut: <DsIconElement>[
      DsIconPathElement('m16 17 5-5-5-5'), // key: 1bji2h
      DsIconPathElement('M21 12H9'), // key: dn1m92
      DsIconPathElement(
          'M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4'), // key: 1uf3rs
    ],

    // `layout-grid.mjs` — four 7-unit tiles: top-left, top-right,
    // bottom-right, bottom-left. Four `rect`s and nothing else.
    DsIconGlyph.layoutGrid: <DsIconElement>[
      // width: 7, height: 7, x: 3, y: 3, rx: 1
      DsIconRectElement(3, 3, 7, 7, 1), // key: 1g98yp
      // width: 7, height: 7, x: 14, y: 3, rx: 1
      DsIconRectElement(14, 3, 7, 7, 1), // key: 6d4xhi
      // width: 7, height: 7, x: 14, y: 14, rx: 1
      DsIconRectElement(14, 14, 7, 7, 1), // key: nxv5o0
      // width: 7, height: 7, x: 3, y: 14, rx: 1
      DsIconRectElement(3, 14, 7, 7, 1), // key: 1bb6yr
    ],

    // `rows-3.mjs` — the frame, then the two dividing rules.
    DsIconGlyph.rows3: <DsIconElement>[
      // width: 18, height: 18, x: 3, y: 3, rx: 2
      DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      DsIconPathElement('M21 9H3'), // key: 1338ky
      DsIconPathElement('M21 15H3'), // key: 9uk58r
    ],

    // `chevron-down.mjs` — one relative V.
    DsIconGlyph.chevronDown: <DsIconElement>[
      DsIconPathElement('m6 9 6 6 6-6'), // key: qrunsl
    ],

    // `chevron-up.mjs`.
    DsIconGlyph.chevronUp: <DsIconElement>[
      DsIconPathElement('m18 15-6-6-6 6'), // key: 153udz
    ],

    // `chevron-left.mjs`.
    DsIconGlyph.chevronLeft: <DsIconElement>[
      DsIconPathElement('m15 18-6-6 6-6'), // key: 1wnfg3
    ],

    // `chevron-right.mjs`.
    DsIconGlyph.chevronRight: <DsIconElement>[
      DsIconPathElement('m9 18 6-6-6-6'), // key: mthhwq
    ],

    // `ellipsis.mjs` — three 1-unit dots, authored centre, right, left.
    DsIconGlyph.ellipsis: <DsIconElement>[
      DsIconCircleElement(12, 12, 1), // key: 41hilf
      DsIconCircleElement(19, 12, 1), // key: 1wjl8i
      DsIconCircleElement(5, 12, 1), // key: 1pcz8c
    ],

    // `external-link.mjs` — the arrow corner, the diagonal, the open frame.
    DsIconGlyph.externalLink: <DsIconElement>[
      DsIconPathElement('M15 3h6v6'), // key: 1q9fwt
      DsIconPathElement('M10 14 21 3'), // key: gplh6r
      DsIconPathElement(
          'M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6'), // key: a6xqqp
    ],

    // ─── curated · "Actions" ────────────────────────────────────────────────

    // `package-open.mjs` — the seam, then three closed flaps.
    DsIconGlyph.packageOpen: <DsIconElement>[
      DsIconPathElement('M12 22v-9'), // key: x3hkom
      DsIconPathElement(
          'M15.17 2.21a1.67 1.67 0 0 1 1.63 0L21 4.57a1.93 1.93 0 0 1 0 3.36L8.82 14.79a1.655 1.655 0 0 1-1.64 0L3 12.43a1.93 1.93 0 0 1 0-3.36z'), // key: 2ntwy6
      DsIconPathElement(
          'M20 13v3.87a2.06 2.06 0 0 1-1.11 1.83l-6 3.08a1.93 1.93 0 0 1-1.78 0l-6-3.08A2.06 2.06 0 0 1 4 16.87V13'), // key: 1pmm1c
      DsIconPathElement(
          'M21 12.43a1.93 1.93 0 0 0 0-3.36L8.83 2.2a1.64 1.64 0 0 0-1.63 0L3 4.57a1.93 1.93 0 0 0 0 3.36l12.18 6.86a1.636 1.636 0 0 0 1.63 0z'), // key: 12ttoo
    ],

    // `shopping-cart.mjs` — the two wheels first, then the basket and handle
    // as one stroke.
    DsIconGlyph.shoppingCart: <DsIconElement>[
      DsIconCircleElement(8, 21, 1), // key: jimo8o
      DsIconCircleElement(19, 21, 1), // key: 13723u
      DsIconPathElement(
          'M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12'), // key: 9zh506
    ],

    // `heart.mjs` — one open subpath: the two lobes as arcs meeting over a
    // cubic, then the fall to the tip and back.
    DsIconGlyph.heart: <DsIconElement>[
      DsIconPathElement(
          'M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5'), // key: mvr1a0
    ],

    // `eye.mjs` — the lid outline as two 10.75-unit arcs, then the iris.
    DsIconGlyph.eye: <DsIconElement>[
      DsIconPathElement(
          'M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0'), // key: 1nclc0
      DsIconCircleElement(12, 12, 3), // key: 1v7zrd
    ],

    // `eye-off.mjs` — the lid broken into two arcs, the interrupted iris, and
    // the slash last.
    DsIconGlyph.eyeOff: <DsIconElement>[
      DsIconPathElement(
          'M10.733 5.076a10.744 10.744 0 0 1 11.205 6.575 1 1 0 0 1 0 .696 10.747 10.747 0 0 1-1.444 2.49'), // key: ct8e1f
      DsIconPathElement(
          'M14.084 14.158a3 3 0 0 1-4.242-4.242'), // key: 151rxh
      DsIconPathElement(
          'M17.479 17.499a10.75 10.75 0 0 1-15.417-5.151 1 1 0 0 1 0-.696 10.75 10.75 0 0 1 4.446-5.143'), // key: 13bj9a
      DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    ],

    // `share-2.mjs` — the three nodes, then the two `line`s that join them.
    DsIconGlyph.share2: <DsIconElement>[
      DsIconCircleElement(18, 5, 3), // key: gq8acd
      DsIconCircleElement(6, 12, 3), // key: w7nqdw
      DsIconCircleElement(18, 19, 3), // key: 1xt0gg
      // x1: 8.59, x2: 15.42, y1: 13.51, y2: 17.49
      DsIconLineElement(8.59, 13.51, 15.42, 17.49), // key: 47mynk
      // x1: 15.41, x2: 8.59, y1: 6.51, y2: 10.49
      DsIconLineElement(15.41, 6.51, 8.59, 10.49), // key: 1n3mei
    ],

    // `copy.mjs` — the front sheet, then the back one. The front sheet is one
    // of the two `rect`s in the whole set that spell `ry` (equal to `rx`).
    DsIconGlyph.copy: <DsIconElement>[
      // width: 14, height: 14, x: 8, y: 8, rx: 2, ry: 2
      DsIconRectElement(8, 8, 14, 14, 2, ry: 2), // key: 17jyea
      DsIconPathElement(
          'M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2'), // key: zix9uf
    ],

    // `funnel.mjs` — the curated set calls this one **Filter**, and
    // `filter.mjs` in 1.28.0 is a one-line re-export of this module.
    DsIconGlyph.filter: <DsIconElement>[
      DsIconPathElement(
          'M10 20a1 1 0 0 0 .553.895l2 1A1 1 0 0 0 14 21v-7a2 2 0 0 1 .517-1.341L21.74 4.67A1 1 0 0 0 21 3H3a1 1 0 0 0-.742 1.67l7.225 7.989A2 2 0 0 1 10 14z'), // key: sc7q7i
    ],

    // `sliders-horizontal.mjs` — three tracks and three handles, nine separate
    // rules. The set's longest element list.
    DsIconGlyph.slidersHorizontal: <DsIconElement>[
      DsIconPathElement('M10 5H3'), // key: 1qgfaw
      DsIconPathElement('M12 19H3'), // key: yhmn1j
      DsIconPathElement('M14 3v4'), // key: 1sua03
      DsIconPathElement('M16 17v4'), // key: 1q0r14
      DsIconPathElement('M21 12h-9'), // key: 1o4lsq
      DsIconPathElement('M21 19h-5'), // key: 1rlt1p
      DsIconPathElement('M21 5h-7'), // key: 1oszz2
      DsIconPathElement('M8 10v4'), // key: tgpxqk
      DsIconPathElement('M8 12H3'), // key: a7s4jb
    ],

    // `plus.mjs` — the bar `arrow-right` also opens with, then the stem.
    DsIconGlyph.plus: <DsIconElement>[
      DsIconPathElement('M5 12h14'), // key: 1ays0h
      DsIconPathElement('M12 5v14'), // key: s699le
    ],

    // `minus.mjs` — plus without its stem; lucide dedupes to the same key.
    DsIconGlyph.minus: <DsIconElement>[
      DsIconPathElement('M5 12h14'), // key: 1ays0h
    ],

    // `refresh-cw.mjs` — the top arc and its arrow corner, then the bottom arc
    // and its corner.
    DsIconGlyph.refreshCw: <DsIconElement>[
      DsIconPathElement(
          'M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8'), // key: v9h5vc
      DsIconPathElement('M21 3v5h-5'), // key: 1q7to0
      DsIconPathElement(
          'M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16'), // key: 3uifl3
      DsIconPathElement('M8 16H3v5'), // key: 1cv678
    ],

    // `download.mjs` — the shaft, the tray, the arrow head.
    DsIconGlyph.download: <DsIconElement>[
      DsIconPathElement('M12 15V3'), // key: m9g1x1
      DsIconPathElement(
          'M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4'), // key: ih7n3h
      DsIconPathElement('m7 10 5 5 5-5'), // key: brsn70
    ],

    // `upload.mjs` — the same tray (same lucide key), a longer shaft and the
    // head pointing the other way; note the element order differs from
    // `download`.
    DsIconGlyph.upload: <DsIconElement>[
      DsIconPathElement('M12 3v12'), // key: 1x0j5s
      DsIconPathElement('m17 8-5-5-5 5'), // key: 7q97r8
      DsIconPathElement(
          'M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4'), // key: ih7n3h
    ],

    // `truck.mjs` — the cab, the axle rule, the box, then the two wheels.
    DsIconGlyph.truck: <DsIconElement>[
      DsIconPathElement(
          'M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2'), // key: wrbu53
      DsIconPathElement('M15 18H9'), // key: 1lyqi6
      DsIconPathElement(
          'M19 18h2a1 1 0 0 0 1-1v-3.65a1 1 0 0 0-.22-.624l-3.48-4.35A1 1 0 0 0 17.52 8H14'), // key: lysw3i
      DsIconCircleElement(17, 18, 2), // key: 332jqn
      DsIconCircleElement(7, 18, 2), // key: 19iecd
    ],

    // `trash-2.mjs` — the two ribs, the can, the lid rule, the handle.
    DsIconGlyph.trash2: <DsIconElement>[
      DsIconPathElement('M10 11v6'), // key: nco0om
      DsIconPathElement('M14 11v6'), // key: outv1u
      DsIconPathElement(
          'M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6'), // key: miytrc
      DsIconPathElement('M3 6h18'), // key: d0wm0j
      DsIconPathElement(
          'M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2'), // key: e791ji
    ],

    // `ban.mjs` — the ring, then its bar.
    DsIconGlyph.ban: <DsIconElement>[
      DsIconCircleElement(12, 12, 10), // key: 1mglay
      DsIconPathElement('M4.929 4.929 19.07 19.071'), // key: 196cmz
    ],

    // ─── curated · "Collectible domain" ─────────────────────────────────────

    // `sparkles.mjs` — the four-point star as one closed subpath of eight
    // alternating arcs and linetos, then the small cross and the 2-unit disc.
    DsIconGlyph.sparkles: <DsIconElement>[
      DsIconPathElement(
          'M11.017 2.814a1 1 0 0 1 1.966 0l1.051 5.558a2 2 0 0 0 1.594 1.594l5.558 1.051a1 1 0 0 1 0 1.966l-5.558 1.051a2 2 0 0 0-1.594 1.594l-1.051 5.558a1 1 0 0 1-1.966 0l-1.051-5.558a2 2 0 0 0-1.594-1.594l-5.558-1.051a1 1 0 0 1 0-1.966l5.558-1.051a2 2 0 0 0 1.594-1.594z'), // key: 1s2grr
      DsIconPathElement('M20 2v4'), // key: 1rf3ol
      DsIconPathElement('M22 4h-4'), // key: gwowj6
      DsIconCircleElement(4, 20, 2), // key: 6kqj1y
    ],

    // `crown.mjs` — the closed crown outline, then the separate base rule.
    DsIconGlyph.crown: <DsIconElement>[
      DsIconPathElement(
          'M11.562 3.266a.5.5 0 0 1 .876 0L15.39 8.87a1 1 0 0 0 1.516.294L21.183 5.5a.5.5 0 0 1 .798.519l-2.834 10.246a1 1 0 0 1-.956.734H5.81a1 1 0 0 1-.957-.734L2.02 6.02a.5.5 0 0 1 .798-.519l4.276 3.664a1 1 0 0 0 1.516-.294z'), // key: 1vdc57
      DsIconPathElement('M5 21h14'), // key: 11awu3
    ],

    // `flame.mjs` — the only glyph in the set that uses `q` and `t`
    // (`q1 4 4 6.5t3 5.5`), so the only real exercise of the quadratic and
    // reflected-quadratic branches of the parser.
    DsIconGlyph.flame: <DsIconElement>[
      DsIconPathElement(
          'M12 3q1 4 4 6.5t3 5.5a1 1 0 0 1-14 0 5 5 0 0 1 1-3 1 1 0 0 0 5 0c0-2-1.5-3-1.5-5q0-2 2.5-4'), // key: 1slcih
    ],

    // `zap.mjs` — one closed bolt. The set's densest arc packing: `0 00-2.474`
    // is two flags and a coordinate with no separators at all, which is why
    // the parser scans flags one character at a time.
    DsIconGlyph.zap: <DsIconElement>[
      DsIconPathElement(
          'M15.914 4a1.5 1.5 0 00-2.474-1.561l-9 9A1.5 1.5 0 005.5 14h4.002a.5.5 0 01.471.666L8.086 20a1.5 1.5 0 002.475 1.56l9-9A1.5 1.5 0 0018.5 10h-3.997a.5.5 0 01-.472-.667z'), // key: 1v7up4
    ],

    // `star.mjs` — one closed five-point star: ten linetos with a rounded arc
    // at every vertex.
    DsIconGlyph.star: <DsIconElement>[
      DsIconPathElement(
          'M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z'), // key: r04s7s
    ],

    // `tag.mjs` — the closed label, then the punched hole. That hole is the
    // set's **only** `fill="currentColor"` node; see [DsIconElement.filled].
    DsIconGlyph.tag: <DsIconElement>[
      DsIconPathElement(
          'M12.586 2.586A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l6.58-6.58a2.426 2.426 0 0 0 0-3.42z'), // key: vktsd0
      // cx: 7.5, cy: 7.5, r: .5, fill: "currentColor"
      DsIconCircleElement(7.5, 7.5, 0.5, filled: true), // key: kqv944
    ],

    // `percent.mjs` — the slash as a `line`, then the two rings.
    DsIconGlyph.percent: <DsIconElement>[
      // x1: 19, x2: 5, y1: 5, y2: 19
      DsIconLineElement(19, 5, 5, 19), // key: 1x9vlm
      DsIconCircleElement(6.5, 6.5, 2.5), // key: 4mh3h7
      DsIconCircleElement(17.5, 17.5, 2.5), // key: 1mdrzq
    ],

    // `medal.mjs` — the ribbon, its two folds, the bar, the disc, and the
    // numeral last so it sits over the disc.
    DsIconGlyph.medal: <DsIconElement>[
      DsIconPathElement(
          'M7.21 15 2.66 7.14a2 2 0 0 1 .13-2.2L4.4 2.8A2 2 0 0 1 6 2h12a2 2 0 0 1 1.6.8l1.6 2.14a2 2 0 0 1 .14 2.2L16.79 15'), // key: 143lza
      DsIconPathElement('M11 12 5.12 2.2'), // key: qhuxz6
      DsIconPathElement('m13 12 5.88-9.8'), // key: hbye0f
      DsIconPathElement('M8 7h8'), // key: i86dvs
      DsIconCircleElement(12, 17, 5), // key: qbz8iq
      DsIconPathElement('M12 18v-2h-.5'), // key: fawc4q
    ],

    // `activity.mjs` — one pulse trace, drawn as a path rather than a
    // polyline because the peaks are rounded with 0.25-unit arcs.
    DsIconGlyph.activity: <DsIconElement>[
      DsIconPathElement(
          'M22 12h-2.48a2 2 0 0 0-1.93 1.46l-2.35 8.36a.25.25 0 0 1-.48 0L9.24 2.18a.25.25 0 0 0-.48 0l-2.35 8.36A2 2 0 0 1 4.49 12H2'), // key: 169zse
    ],

    // `trending-up.mjs` — the arrow corner, then the trace.
    DsIconGlyph.trendingUp: <DsIconElement>[
      DsIconPathElement('M16 7h6v6'), // key: box55l
      DsIconPathElement('m22 7-8.5 8.5-5-5L2 17'), // key: 1t1m79
    ],

    // `trending-down.mjs` — the same construction, mirrored.
    DsIconGlyph.trendingDown: <DsIconElement>[
      DsIconPathElement('M16 17h6v-6'), // key: t6n2it
      DsIconPathElement('m22 17-8.5-8.5-5 5L2 7'), // key: x473p
    ],

    // ─── curated · "Money & status" ─────────────────────────────────────────

    // `circle-dollar-sign.mjs` — the ring (lucide's shared 10-unit circle,
    // key `1mglay`), the S, then the stem.
    DsIconGlyph.circleDollarSign: <DsIconElement>[
      DsIconCircleElement(12, 12, 10), // key: 1mglay
      DsIconPathElement(
          'M16 8h-6a2 2 0 1 0 0 4h4a2 2 0 1 1 0 4H8'), // key: 1h4pet
      DsIconPathElement('M12 18V6'), // key: zqpxq5
    ],

    // `credit-card.mjs` — the card, then the magnetic stripe as a `line`.
    DsIconGlyph.creditCard: <DsIconElement>[
      // width: 20, height: 14, x: 2, y: 5, rx: 2
      DsIconRectElement(2, 5, 20, 14, 2), // key: ynyp8z
      // x1: 2, x2: 22, y1: 10, y2: 10
      DsIconLineElement(2, 10, 22, 10), // key: 1b3vmo
    ],

    // `arrow-down-left.mjs` — the diagonal, then the corner.
    DsIconGlyph.arrowDownLeft: <DsIconElement>[
      DsIconPathElement('M17 7 7 17'), // key: 15tmo1
      DsIconPathElement('M17 17H7V7'), // key: 1org7z
    ],

    // `arrow-up-right.mjs` — corner first here, then the diagonal.
    DsIconGlyph.arrowUpRight: <DsIconElement>[
      DsIconPathElement('M7 7h10v10'), // key: 1tivn9
      DsIconPathElement('M7 17 17 7'), // key: 1vkiza
    ],

    // `hourglass.mjs` — the two rails, then the lower and upper bulbs.
    DsIconGlyph.hourglass: <DsIconElement>[
      DsIconPathElement('M5 22h14'), // key: ehvnwv
      DsIconPathElement('M5 2h14'), // key: pdyrp9
      DsIconPathElement(
          'M17 22v-4.172a2 2 0 0 0-.586-1.414L12 12l-4.414 4.414A2 2 0 0 0 7 17.828V22'), // key: 1d314k
      DsIconPathElement(
          'M7 2v4.172a2 2 0 0 0 .586 1.414L12 12l4.414-4.414A2 2 0 0 0 17 6.172V2'), // key: 1vvvr6
    ],

    // `clock.mjs` — the ring, then both hands as one stroke.
    DsIconGlyph.clock: <DsIconElement>[
      DsIconCircleElement(12, 12, 10), // key: 1mglay
      DsIconPathElement('M12 6v6l4 2'), // key: mmk7yg
    ],

    // `lock.mjs` — the body, then the shackle. The body is the second of the
    // two `rect`s that spell `ry`.
    DsIconGlyph.lock: <DsIconElement>[
      // width: 18, height: 11, x: 3, y: 11, rx: 2, ry: 2
      DsIconRectElement(3, 11, 18, 11, 2, ry: 2), // key: 1w4ew1
      DsIconPathElement('M7 11V7a5 5 0 0 1 10 0v4'), // key: fwvmzm
    ],

    // `shield.mjs` — one closed crest.
    DsIconGlyph.shield: <DsIconElement>[
      DsIconPathElement(
          'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z'), // key: oel41y
    ],

    // `shield-check.mjs` — the same crest character for character (lucide
    // keeps the same key, `oel41y`), plus the tick.
    DsIconGlyph.shieldCheck: <DsIconElement>[
      DsIconPathElement(
          'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z'), // key: oel41y
      DsIconPathElement('m9 12 2 2 4-4'), // key: dzmm74
    ],

    // `info.mjs` — the ring, the stem, and `h.01`: a 0.01-unit stroke that a
    // round linecap renders as the tittle. Three glyphs use that trick.
    DsIconGlyph.info: <DsIconElement>[
      DsIconCircleElement(12, 12, 10), // key: 1mglay
      DsIconPathElement('M12 16v-4'), // key: 1dtifu
      DsIconPathElement('M12 8h.01'), // key: e9boi3
    ],

    // `circle-question-mark.mjs` — the curated set calls this one
    // **HelpCircle**, and `help-circle.mjs` in 1.28.0 is a one-line re-export
    // of this module.
    DsIconGlyph.helpCircle: <DsIconElement>[
      DsIconCircleElement(12, 12, 10), // key: 1mglay
      DsIconPathElement('M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3'), // key: 1u773s
      DsIconPathElement('M12 17h.01'), // key: p32p05
    ],

    // `triangle-alert.mjs` — the curated set calls this one **AlertTriangle**,
    // and `alert-triangle.mjs` in 1.28.0 is a one-line re-export of this
    // module.
    DsIconGlyph.alertTriangle: <DsIconElement>[
      DsIconPathElement(
          'm21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3'), // key: wmoenq
      DsIconPathElement('M12 9v4'), // key: juzpu7
      DsIconPathElement('M12 17h.01'), // key: p32p05
    ],

    // ─── off-set ────────────────────────────────────────────────────────────

    // `rotate-ccw.mjs` — the motion page's replay control. Not a member of the
    // curated 63, so the icons page's registry must not list it.
    DsIconGlyph.rotateCcw: <DsIconElement>[
      DsIconPathElement(
          'M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8'), // key: 1357e3
      DsIconPathElement('M3 3v5h5'), // key: 1xhq8a
    ],

    // `loader-circle.mjs` — the loading spinner's glyph, imported in the
    // reference under its 1.28.0 alias `Loader2Icon` (`loader-2.mjs` re-exports
    // this module and nothing else). One open arc: three quarters of a 9-unit
    // ring, drawn as a single sweep that stops short of closing, which is what
    // makes a rotation read as a spinner rather than as a wheel.
    DsIconGlyph.loaderCircle: <DsIconElement>[
      DsIconPathElement('M21 12a9 9 0 1 1-6.219-8.56'), // key: 13zald
    ],

    // `play.mjs` — the `PlayPauseDemo` swap. One closed path: a triangle whose
    // three corners are 2-unit arcs, which is why it is a `path` and not a
    // `polygon`.
    DsIconGlyph.play: <DsIconElement>[
      DsIconPathElement(
          'M5 5a2 2 0 0 1 3.008-1.728l11.997 6.998a2 2 0 0 1 .003 3.458l-12 7A2 2 0 0 1 5 19z'), // key: 10ikf1
    ],

    // `pause.mjs` — two 5×18 bars at x = 14 and x = 5, in that order. The
    // right-hand bar is declared first; the transcription keeps lucide's order
    // because order is paint order.
    DsIconGlyph.pause: <DsIconElement>[
      DsIconRectElement(14, 3, 5, 18, 1), // key: kaeet6
      DsIconRectElement(5, 3, 5, 18, 1), // key: 1wsw3u
    ],

    // `volume-2.mjs` — the `MuteDemo` swap. The speaker body plus two arcs.
    DsIconGlyph.volume2: <DsIconElement>[
      DsIconPathElement(
          'M11 4.702a.705.705 0 0 0-1.203-.498L6.413 7.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298z'), // key: uqj9uw
      DsIconPathElement('M16 9a5 5 0 0 1 0 6'), // key: 1q6k2b
      DsIconPathElement('M19.364 18.364a9 9 0 0 0 0-12.728'), // key: ijwkga
    ],

    // `volume-x.mjs` — the same speaker body under the same content hash, with
    // a cross where the arcs were. The two `line` nodes are the two diagonals,
    // declared in lucide's `x1, x2, y1, y2` order and reordered here to this
    // element's point-then-point constructor.
    DsIconGlyph.volumeX: <DsIconElement>[
      DsIconPathElement(
          'M11 4.702a.705.705 0 0 0-1.203-.498L6.413 7.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298z'), // key: uqj9uw
      DsIconLineElement(22, 9, 16, 15), // key: 1ewh16
      DsIconLineElement(16, 9, 22, 15), // key: 5ykzw1
    ],

    // `circle-check.mjs` — sonner's success toast. The shared 10-unit ring,
    // then a tick drawn inside it.
    DsIconGlyph.circleCheck: <DsIconElement>[
      DsIconCircleElement(12, 12, 10), // key: 1mglay
      DsIconPathElement('m9 12 2 2 4-4'), // key: dzmm74
    ],

    // `octagon-x.mjs` — sonner's error toast. The two diagonals are declared
    // AROUND the octagon, not after it: lucide writes the first stroke, then
    // the plate, then the second stroke, so the plate paints over the first
    // diagonal's middle. Order is paint order and the order is kept.
    DsIconGlyph.octagonX: <DsIconElement>[
      DsIconPathElement('m15 9-6 6'), // key: 1uzhvr
      DsIconPathElement(
          'M2.586 16.726A2 2 0 0 1 2 15.312V8.688a2 2 0 0 1 .586-1.414l4.688-4.688A2 2 0 0 1 8.688 2h6.624a2 2 0 0 1 1.414.586l4.688 4.688A2 2 0 0 1 22 8.688v6.624a2 2 0 0 1-.586 1.414l-4.688 4.688a2 2 0 0 1-1.414.586H8.688a2 2 0 0 1-1.414-.586z'), // key: 2d38gg
      DsIconPathElement('m9 9 6 6'), // key: z0biqf
    ],

    // `circle-x.mjs` — the forms page's server-error Alert, imported there as
    // `XCircle`. Every node is borrowed: the ring is [circleCheck]'s and both
    // diagonals are [octagonX]'s, keys included — which is exactly what shared
    // keys are supposed to look like, since they are content hashes.
    DsIconGlyph.circleX: <DsIconElement>[
      DsIconCircleElement(12, 12, 10), // key: 1mglay
      DsIconPathElement('m15 9-6 6'), // key: 1uzhvr
      DsIconPathElement('m9 9 6 6'), // key: z0biqf
    ],

    // `at-sign.mjs` — the inputs page's Email addon. The bowl is a 4-unit
    // circle; the path is the tail that starts inside the ring at (16,8), runs
    // down and around, and stops short of closing so the `@` reads as open.
    DsIconGlyph.atSign: <DsIconElement>[
      DsIconCircleElement(12, 12, 4), // key: 4exip2
      DsIconPathElement('M16 8v5a3 3 0 0 0 6 0v-1a10 10 0 1 0-4 8'), // key: 7n84p3
    ],

    // `ticket.mjs` — the inputs page's Invite-code addon. The outline plus
    // three stub perforations down the x = 13 line. Its `d` ends in an
    // uppercase `Z`, which is kept verbatim.
    DsIconGlyph.ticket: <DsIconElement>[
      DsIconPathElement(
          'M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z'), // key: qn84l0
      DsIconPathElement('M13 5v2'), // key: dyzc3o
      DsIconPathElement('M13 17v2'), // key: 1ont0d
      DsIconPathElement('M13 11v2'), // key: 1wjjxi
    ],

    // `calendar.mjs` — the selects page's date-picker triggers. Two 3-unit
    // tabs above an 18-unit plate, then the rule that separates the header
    // strip from the grid. Lucide declares the tabs FIRST and the plate
    // second, so the plate paints over their feet; order is paint order and
    // the order is kept.
    DsIconGlyph.calendar: <DsIconElement>[
      DsIconPathElement('M8 2v3'), // key: 1ioesn
      DsIconPathElement('M16 2v3'), // key: otl347
      DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
      DsIconPathElement('M3 9h18'), // key: 1pudct
    ],
  };

  /// The glyph as one [Path] in 24-unit coordinates — the caller scales.
  ///
  /// **Every** element, filled ones included: `fill` on a lucide node overrides
  /// the `<svg>`'s `fill="none"` and nothing else, so a filled node still
  /// inherits `stroke="currentColor"` and is stroked like its siblings. The
  /// stroke pass is therefore still one path for one `drawPath`, exactly as
  /// before; [fillPathFor] is an *addition* on top of it, not a subtraction
  /// from it.
  ///
  /// A **fresh** path every call: [Path] is mutable, and a shared instance
  /// would let one painter's `transform`/`addPath` corrupt every other icon.
  static Path pathFor(DsIconGlyph glyph) {
    final Path path = Path();
    for (final DsIconElement element in elements[glyph]!) {
      element.addTo(path);
    }
    return path;
  }

  /// The glyph's `fill="currentColor"` elements as one [Path], or `null` when
  /// it has none — which is every glyph but [DsIconGlyph.tag].
  ///
  /// `null` rather than an empty [Path] so the painter can skip the second
  /// `drawPath` outright instead of asking Skia to fill nothing.
  ///
  /// Both passes use the same colour, so their order cannot show; the painter
  /// runs stroke first, which also happens to be lucide's element order here
  /// (tag's dot is its last node).
  static Path? fillPathFor(DsIconGlyph glyph) {
    Path? path;
    for (final DsIconElement element in elements[glyph]!) {
      if (!element.filled) continue;
      element.addTo(path ??= Path());
    }
    return path;
  }

  // ─── off-set, and off-lucide: the starfield's sparkle ────────────────────

  /// The one glyph the `.starfield` utility draws, thirteen times
  /// (`app/globals.css` L3474 and L3478, inside the two `url("data:image/svg+xml…")`
  /// backgrounds).
  ///
  /// ```svg
  /// <path d="M12 0C12 6.6 17.4 12 24 12C17.4 12 12 17.4 12 24C12 17.4 6.6 12 0 12C6.6 12 12 6.6 12 0Z" fill="#ffffff"/>
  /// ```
  ///
  /// A four-point star on the same 24×24 grid lucide authors on ([viewBox]),
  /// so the two sets of geometry share this file's units and its parser. Four
  /// cubic segments, closed; every control point sits at 6.6 or 17.4, which is
  /// 27.5% of the way in from each edge — that is what pinches the waist and
  /// makes the arms concave rather than a plain diamond.
  ///
  /// **Deliberately NOT a [DsIconGlyph].** Every member of that enum is a
  /// transcript of one lucide module, stroked through `icon.dart`'s ladder,
  /// and the icons page's registry is derived from it by subtraction (78 =
  /// chrome + curated + off-set). This shape is none of those things: its
  /// source is the stylesheet, it carries `fill="#ffffff"` and **no stroke at
  /// all**, and there is no size rung or tone that would make sense for it. It
  /// lands in this file because this file is where transcribed geometry lives
  /// — supervisor ruling F7 — and it stays out of the enum so that neither the
  /// registry arithmetic nor `DsIcon` can ever reach it by accident.
  ///
  /// Held as a [DsIconPathElement] rather than a bare [String] so the `d`
  /// reads as one more transcript beside the others, and so [sparkle] can go
  /// through the same parser every glyph above does.
  static const DsIconPathElement sparkleElement = DsIconPathElement(
      'M12 0C12 6.6 17.4 12 24 12C17.4 12 12 17.4 12 24C12 17.4 6.6 12 0 12C6.6 12 12 6.6 12 0Z');

  /// [sparkleElement] as a fresh [Path] in 24-unit coordinates — the caller
  /// scales and translates, exactly as the SVG's own
  /// `transform="translate(x,y) scale(s)"` does.
  ///
  /// A **fresh** path every call, for [pathFor]'s reason: [Path] is mutable and
  /// thirteen instances share one shape.
  static Path sparkle() {
    final Path path = Path();
    sparkleElement.addTo(path);
    return path;
  }
}

// ─── SVG path data ──────────────────────────────────────────────────────────

/// A single-pass reader for one SVG `d` string.
///
/// Implements the whole grammar — `M m L l H h V v C c S s Q q T t A a Z z` —
/// even though the eight glyphs above only reach for `M/m`, `L/l`, `C/c` and
/// `A/a`. The parser is the reusable half of this file: later batches embed
/// more lucide glyphs, and a partial parser would fail on them silently rather
/// than loudly.
///
/// Two SVG rules make the scanner less obvious than it looks, and both appear
/// in the data above:
///
///  * **separators are optional.** `-1.41 1.41` and `1 1-9.473` pack a sign
///    straight against the previous number, and `.405-.022` packs two
///    leading-dot decimals. A number therefore ends where the next one can
///    legally begin, not at whitespace.
///  * **a command letter is sticky.** One letter may be followed by many
///    argument sets (`m12 5 7 7-7 7` is a moveto and two linetos), and a
///    repeated `M`/`m` degrades to `L`/`l` — the *implicit lineto* rule.
///
/// Deliberate omission: this reader raises on malformed data instead of
/// recovering the way a browser does. The input is a const string checked into
/// the repo, so a throw is a build-time transcription bug, not a runtime risk.
class _SvgPathParser {
  _SvgPathParser(this._d);

  final String _d;
  int _i = 0;

  /// The current point. A `d` string starts at the origin: each lucide element
  /// is its own `<path>`, so a leading relative `m6 6` means (6, 6).
  Offset _current = Offset.zero;

  /// Where the current subpath began — the target of `Z`/`z`.
  Offset _subpathStart = Offset.zero;

  /// Second control point of the previous `C c S s`, for `S`/`s` to reflect.
  /// Null after any other command, which is the spec's "assume the first
  /// control point is coincident with the current point".
  Offset? _cubicControl;

  /// Control point of the previous `Q q T t`, for `T`/`t` to reflect.
  Offset? _quadControl;

  static const int _zero = 0x30; // '0'
  static const int _nine = 0x39; // '9'

  static bool _isDigit(int code) => code >= _zero && code <= _nine;

  static bool _isCommand(String c) {
    final int code = c.codeUnitAt(0);
    return (code >= 0x41 && code <= 0x5A) || (code >= 0x61 && code <= 0x7A);
  }

  /// Whitespace and commas, per the `wsp`/`comma-wsp` productions.
  static bool _isSeparator(String c) =>
      c == ' ' ||
      c == ',' ||
      c == '\t' ||
      c == '\n' ||
      c == '\r' ||
      c == '\f';

  void _skip() {
    while (_i < _d.length && _isSeparator(_d[_i])) {
      _i++;
    }
  }

  /// Reads one number: optional sign, integer part, fraction, exponent — any
  /// part of which may be absent, so `.5`, `-.5`, `5.`, `5e-3` all scan.
  double _number() {
    _skip();
    final int start = _i;
    if (_i < _d.length && (_d[_i] == '+' || _d[_i] == '-')) {
      _i++;
    }
    while (_i < _d.length && _isDigit(_d.codeUnitAt(_i))) {
      _i++;
    }
    if (_i < _d.length && _d[_i] == '.') {
      _i++;
      while (_i < _d.length && _isDigit(_d.codeUnitAt(_i))) {
        _i++;
      }
    }
    if (_i < _d.length && (_d[_i] == 'e' || _d[_i] == 'E')) {
      // An `e` only belongs to this number if a (signed) digit follows;
      // otherwise it is the next command letter and must be given back.
      final int mark = _i;
      _i++;
      if (_i < _d.length && (_d[_i] == '+' || _d[_i] == '-')) {
        _i++;
      }
      if (_i < _d.length && _isDigit(_d.codeUnitAt(_i))) {
        while (_i < _d.length && _isDigit(_d.codeUnitAt(_i))) {
          _i++;
        }
      } else {
        _i = mark;
      }
    }
    if (_i == start) {
      throw FormatException('expected a number', _d, _i);
    }
    final double? value = double.tryParse(_d.substring(start, _i));
    if (value == null) {
      throw FormatException('malformed number', _d, start);
    }
    return value;
  }

  /// Reads an arc flag: exactly **one** character, `0` or `1`.
  ///
  /// Not a number — the grammar lets `1 1-9.473` and even `11-9.473` pack two
  /// flags together, so scanning a flag as a number would swallow the second.
  bool _flag() {
    _skip();
    if (_i >= _d.length || (_d[_i] != '0' && _d[_i] != '1')) {
      throw FormatException('expected an arc flag (0 or 1)', _d, _i);
    }
    return _d[_i++] == '1';
  }

  /// Two numbers as a point.
  Offset _point() => Offset(_number(), _number());

  /// The command an unlettered argument set repeats: `M`/`m` degrade to
  /// `L`/`l`, everything else repeats itself.
  static String _implicitRepeat(String command) => switch (command) {
        'M' => 'L',
        'm' => 'l',
        _ => command,
      };

  void run(Path path) {
    _skip();
    while (_i < _d.length) {
      final String letter = _d[_i];
      if (!_isCommand(letter)) {
        throw FormatException('expected a command letter', _d, _i);
      }
      _i++;
      if (letter == 'Z' || letter == 'z') {
        path.close();
        _current = _subpathStart;
        _cubicControl = null;
        _quadControl = null;
        _skip();
        continue;
      }
      String command = letter;
      do {
        _execute(path, command);
        _skip();
        command = _implicitRepeat(command);
      } while (_i < _d.length && !_isCommand(_d[_i]));
    }
  }

  void _execute(Path path, String command) {
    switch (command) {
      case 'M':
        _moveTo(path, _point());
      case 'm':
        _moveTo(path, _current + _point());

      case 'L':
        _lineTo(path, _point());
      case 'l':
        _lineTo(path, _current + _point());

      case 'H':
        _lineTo(path, Offset(_number(), _current.dy));
      case 'h':
        _lineTo(path, Offset(_current.dx + _number(), _current.dy));
      case 'V':
        _lineTo(path, Offset(_current.dx, _number()));
      case 'v':
        _lineTo(path, Offset(_current.dx, _current.dy + _number()));

      case 'C':
        _cubicTo(path, _point(), _point(), _point());
      case 'c':
        final Offset origin = _current;
        _cubicTo(
          path,
          origin + _point(),
          origin + _point(),
          origin + _point(),
        );
      case 'S':
        _cubicTo(path, _reflectedCubic, _point(), _point());
      case 's':
        final Offset origin = _current;
        final Offset control1 = _reflectedCubic;
        _cubicTo(path, control1, origin + _point(), origin + _point());

      case 'Q':
        _quadTo(path, _point(), _point());
      case 'q':
        final Offset origin = _current;
        _quadTo(path, origin + _point(), origin + _point());
      case 'T':
        _quadTo(path, _reflectedQuad, _point());
      case 't':
        final Offset origin = _current;
        _quadTo(path, _reflectedQuad, origin + _point());

      case 'A':
        _arc(path, absolute: true);
      case 'a':
        _arc(path, absolute: false);

      default:
        throw FormatException('unknown command "$command"', _d, _i);
    }
  }

  /// The reflection of the previous cubic's second control point through the
  /// current point — or the current point itself when the previous command was
  /// not a cubic (SVG 1.1 §8.3.6).
  Offset get _reflectedCubic =>
      _cubicControl == null ? _current : _current * 2 - _cubicControl!;

  /// Same rule for quadratics (§8.3.7).
  Offset get _reflectedQuad =>
      _quadControl == null ? _current : _current * 2 - _quadControl!;

  void _moveTo(Path path, Offset to) {
    path.moveTo(to.dx, to.dy);
    _current = to;
    _subpathStart = to;
    _cubicControl = null;
    _quadControl = null;
  }

  void _lineTo(Path path, Offset to) {
    path.lineTo(to.dx, to.dy);
    _current = to;
    _cubicControl = null;
    _quadControl = null;
  }

  void _cubicTo(Path path, Offset control1, Offset control2, Offset to) {
    path.cubicTo(control1.dx, control1.dy, control2.dx, control2.dy, to.dx,
        to.dy);
    _current = to;
    _cubicControl = control2;
    _quadControl = null;
  }

  void _quadTo(Path path, Offset control, Offset to) {
    path.quadraticBezierTo(control.dx, control.dy, to.dx, to.dy);
    _current = to;
    _cubicControl = null;
    _quadControl = control;
  }

  void _arc(Path path, {required bool absolute}) {
    final double rx = _number();
    final double ry = _number();
    final double rotation = _number();
    final bool largeArc = _flag();
    final bool sweep = _flag();
    final Offset raw = _point();
    _arcTo(
      path,
      rx: rx,
      ry: ry,
      rotationDegrees: rotation,
      largeArc: largeArc,
      sweep: sweep,
      end: absolute ? raw : _current + raw,
    );
    _cubicControl = null;
    _quadControl = null;
  }

  /// Emits an SVG elliptical arc as cubic segments.
  ///
  /// Endpoint→centre parameterisation per SVG 1.1 appendix **F.6.5**, with the
  /// out-of-range radii correction of **F.6.6** applied before the centre is
  /// solved. The out-of-range checks of F.6.2 come first: a zero-length arc is
  /// dropped entirely, and a zero radius degrades to a straight line.
  ///
  /// The sweep is then cut into equal segments of **at most 90°** and each is
  /// approximated by one cubic whose control points sit `4/3·tan(θ/4)` of the
  /// tangent out from the endpoints — the standard construction, exact at the
  /// two ends and within ~2.7e-4·r in the middle at 90°.
  ///
  /// The final segment lands on the caller's `end` verbatim rather than on the
  /// re-derived point, so accumulated float error can never leave a hairline
  /// gap where a subsequent command continues the subpath.
  void _arcTo(
    Path path, {
    required double rx,
    required double ry,
    required double rotationDegrees,
    required bool largeArc,
    required bool sweep,
    required Offset end,
  }) {
    final Offset start = _current;
    if (start == end) {
      return; // F.6.2: coincident endpoints — the arc is omitted.
    }
    if (rx == 0 || ry == 0) {
      _lineTo(path, end); // F.6.2: a zero radius is a straight line.
      return;
    }
    rx = rx.abs();
    ry = ry.abs();

    final double phi = rotationDegrees * math.pi / 180;
    final double cosPhi = math.cos(phi);
    final double sinPhi = math.sin(phi);

    // F.6.5 step 1 — the endpoint midpoint, rotated into the ellipse's frame.
    final double halfDx = (start.dx - end.dx) / 2;
    final double halfDy = (start.dy - end.dy) / 2;
    final double x1p = cosPhi * halfDx + sinPhi * halfDy;
    final double y1p = -sinPhi * halfDx + cosPhi * halfDy;

    // F.6.6 — radii too small to span the chord are scaled up until they fit.
    final double lambda = (x1p * x1p) / (rx * rx) + (y1p * y1p) / (ry * ry);
    if (lambda > 1) {
      final double scale = math.sqrt(lambda);
      rx *= scale;
      ry *= scale;
    }

    // F.6.5 step 2 — the centre, still in the ellipse's frame.
    final double rx2 = rx * rx;
    final double ry2 = ry * ry;
    final double x1p2 = x1p * x1p;
    final double y1p2 = y1p * y1p;
    final double denominator = rx2 * y1p2 + ry2 * x1p2;
    double radicand =
        denominator == 0 ? 0 : (rx2 * ry2 - denominator) / denominator;
    if (radicand < 0) {
      radicand = 0; // F.6.6 leaves this at exactly 0; float error can dip below.
    }
    final double coefficient =
        (largeArc == sweep ? -1 : 1) * math.sqrt(radicand);
    final double cxp = coefficient * rx * y1p / ry;
    final double cyp = -coefficient * ry * x1p / rx;

    // F.6.5 step 3 — rotate the centre back into user space.
    final double cx = cosPhi * cxp - sinPhi * cyp + (start.dx + end.dx) / 2;
    final double cy = sinPhi * cxp + cosPhi * cyp + (start.dy + end.dy) / 2;

    // F.6.5 step 4 — start angle and sweep, as angles on the unit circle the
    // ellipse maps from.
    final double ux = (x1p - cxp) / rx;
    final double uy = (y1p - cyp) / ry;
    final double vx = (-x1p - cxp) / rx;
    final double vy = (-y1p - cyp) / ry;
    final double theta1 = math.atan2(uy, ux);
    double delta = math.atan2(ux * vy - uy * vx, ux * vx + uy * vy);
    if (!sweep && delta > 0) {
      delta -= 2 * math.pi;
    } else if (sweep && delta < 0) {
      delta += 2 * math.pi;
    }

    final int segments = math.max(1, (delta.abs() / (math.pi / 2)).ceil());
    final double step = delta / segments;
    final double alpha = 4 / 3 * math.tan(step / 4);

    Offset pointAt(double theta) {
      final double cosT = math.cos(theta);
      final double sinT = math.sin(theta);
      return Offset(
        cx + rx * cosT * cosPhi - ry * sinT * sinPhi,
        cy + rx * cosT * sinPhi + ry * sinT * cosPhi,
      );
    }

    Offset tangentAt(double theta) {
      final double cosT = math.cos(theta);
      final double sinT = math.sin(theta);
      return Offset(
        -rx * sinT * cosPhi - ry * cosT * sinPhi,
        -rx * sinT * sinPhi + ry * cosT * cosPhi,
      );
    }

    for (int segment = 0; segment < segments; segment++) {
      final double thetaA = theta1 + step * segment;
      final double thetaB = thetaA + step;
      final Offset pointA = pointAt(thetaA);
      final bool last = segment == segments - 1;
      final Offset pointB = last ? end : pointAt(thetaB);
      final Offset control1 = pointA + tangentAt(thetaA) * alpha;
      final Offset control2 = pointAt(thetaB) - tangentAt(thetaB) * alpha;
      path.cubicTo(
        control1.dx,
        control1.dy,
        control2.dx,
        control2.dy,
        pointB.dx,
        pointB.dy,
      );
    }
    _current = end;
  }
}
