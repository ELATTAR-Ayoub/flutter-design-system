#!/usr/bin/env node
// Generates the full lucide glyph registry for the Flutter port.
//
//   node tool/generate_icons.mjs
//
// Reads EVERY icon module from the reference's own installed package
// (`design-system/node_modules/lucide-react`) and emits Dart. See
// `tool/README.md` for the contract, the rerun recipe and the design notes.
//
// Why Node and not Dart: the source of truth is a tree of ES modules. This
// script `import()`s them and reads the `__iconNode` array lucide itself
// exports, so the geometry is verbatim *by construction* — nothing re-parses
// lucide's JavaScript, and there is no second transcription to get wrong. A
// Dart generator would have had to re-implement a JS reader, which is exactly
// the risk the hand transcription in `icon_paths.dart` was written to avoid.

import { readdirSync, readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { pathToFileURL } from 'node:url';
import path from 'node:path';

// ── inputs ──────────────────────────────────────────────────────────────────

const REPO = path.resolve(import.meta.dirname, '..');
const PACKAGE_DIR = path.resolve(
  REPO,
  '../design-system/node_modules/lucide-react',
);
const ICONS_DIR = path.join(PACKAGE_DIR, 'dist/esm/icons');
const OUT_DIR = path.join(REPO, 'lib/src/components');

/** Emitted Dart type names.
 *
 *  `SEALED` is the default and the merged state: the node types are
 *  `icon_paths.dart`'s own `ElIconElement` hierarchy, which this file imports
 *  rather than declares. `SHIM` is the pre-merge shape kept for one reason —
 *  the two differ **only** in these names, and re-running under it reproduces
 *  the old file's node lines byte for byte, which is how the merge was checked.
 *  The constructor call shapes are identical in both, which is what made that
 *  merge a flag flip plus a rerun. */
const MODEL = {
  SHIM: {
    base: 'ElLucideNode',
    path: 'ElLucidePath',
    circle: 'ElLucideCircle',
    rect: 'ElLucideRect',
    line: 'ElLucideLine',
    ellipse: 'ElLucideEllipse',
    polyline: 'ElLucidePolyline',
    polygon: 'ElLucidePolygon',
    emitModel: true,
  },
  SEALED: {
    base: 'ElIconElement',
    path: 'ElIconPathElement',
    circle: 'ElIconCircleElement',
    rect: 'ElIconRectElement',
    line: 'ElIconLineElement',
    ellipse: 'ElIconEllipseElement',
    polyline: 'ElIconPolylineElement',
    polygon: 'ElIconPolygonElement',
    emitModel: false,
  },
};
const T = MODEL[process.env.EL_ICON_MODEL ?? 'SEALED'];

// ── read the package ────────────────────────────────────────────────────────

const pkg = JSON.parse(
  readFileSync(path.join(PACKAGE_DIR, 'package.json'), 'utf8'),
);

/** `[name, __iconNode]` for every real module, and `[alias, target]` for every
 *  module that is nothing but a re-export. */
async function readPackage() {
  const icons = [];
  const aliases = [];
  for (const file of readdirSync(ICONS_DIR).sort()) {
    if (!file.endsWith('.mjs') || file === 'index.mjs') continue;
    const name = file.slice(0, -4);
    const source = readFileSync(path.join(ICONS_DIR, file), 'utf8');
    if (!source.includes('__iconNode')) {
      const m = source.match(/^export \{ default \} from '\.\/(.+)\.mjs';$/m);
      if (!m) throw new Error(`${file}: neither an icon nor a re-export`);
      aliases.push([name, m[1]]);
      continue;
    }
    const mod = await import(pathToFileURL(path.join(ICONS_DIR, file)).href);
    if (!Array.isArray(mod.__iconNode)) {
      throw new Error(`${file}: __iconNode is not an array`);
    }
    icons.push([name, mod.__iconNode]);
  }
  return { icons, aliases };
}

// ── value formatting ────────────────────────────────────────────────────────

/** A lucide attribute string as a Dart numeric literal, digit for digit.
 *
 *  Never round-trips through a float: the string lucide ships is the truth, so
 *  `".5"` becomes `0.5` (Dart has no leading-dot literal) and everything else
 *  is passed through untouched. An int literal is legal where a double is
 *  expected, so `"12"` stays `12` exactly as the hand transcription writes it. */
function num(value) {
  if (!/^-?(\d+(\.\d+)?|\.\d+)$/.test(value)) {
    throw new Error(`not a plain decimal: ${JSON.stringify(value)}`);
  }
  if (value.startsWith('.')) return `0${value}`;
  if (value.startsWith('-.')) return `-0${value.slice(1)}`;
  return value;
}

/** `points` — space- or comma-separated pairs. `mailbox` is the one module that
 *  uses commas (`"15,9 18,9 18,11"`), which is why this splits on both. */
function points(value) {
  const parts = value.trim().split(/[\s,]+/);
  if (parts.length % 2 !== 0) {
    throw new Error(`odd point count: ${JSON.stringify(value)}`);
  }
  const pairs = [];
  for (let i = 0; i < parts.length; i += 2) {
    pairs.push(`Offset(${num(parts[i])}, ${num(parts[i + 1])})`);
  }
  return pairs;
}

const dartString = (s) =>
  `'${s.replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/\$/g, '\\$')}'`;

/** kebab-case module name → lowerCamelCase Dart identifier.
 *
 *  Verified collision-free across the whole set, and it reproduces the hand
 *  enum's spelling exactly (`rows-3` → `rows3`, `volume-x` → `volumeX`). */
const identifier = (name) => name.replace(/-([a-z0-9])/g, (_, c) => c.toUpperCase());

// ── node emission ───────────────────────────────────────────────────────────

/** The tally the header prints, and the evidence for the "no surprises" claim:
 *  an unknown tag or an unknown attribute throws rather than being dropped. */
const KNOWN_ATTRS = {
  path: ['d', 'key'],
  circle: ['cx', 'cy', 'r', 'fill', 'key'],
  rect: ['x', 'y', 'width', 'height', 'rx', 'ry', 'key'],
  line: ['x1', 'y1', 'x2', 'y2', 'key'],
  ellipse: ['cx', 'cy', 'rx', 'ry', 'key'],
  polyline: ['points', 'key'],
  polygon: ['points', 'key'],
};

function emitNode(icon, [tag, attrs]) {
  const known = KNOWN_ATTRS[tag];
  if (!known) throw new Error(`${icon}: unknown tag <${tag}>`);
  for (const k of Object.keys(attrs)) {
    if (!known.includes(k)) {
      throw new Error(`${icon}: <${tag}> carries an unhandled attribute "${k}"`);
    }
  }
  const note = [];
  let call;

  switch (tag) {
    case 'path':
      call = `${T.path}(${dartString(attrs.d)})`;
      break;

    case 'circle': {
      if (attrs.fill !== undefined && attrs.fill !== 'currentColor') {
        throw new Error(`${icon}: circle fill="${attrs.fill}"`);
      }
      const fill = attrs.fill ? ', filled: true' : '';
      call = `${T.circle}(${num(attrs.cx)}, ${num(attrs.cy)}, ${num(attrs.r)}${fill})`;
      break;
    }

    case 'rect': {
      // SVG's mutual-auto rule (`geometry properties`): an absent `rx` takes
      // `ry`'s value and vice versa; absent together means square corners.
      // lucide omits `rx` on five nodes, four of which spell `ry` — so the
      // rule is applied here, explicitly, rather than left to a reader.
      const rx = attrs.rx ?? attrs.ry ?? '0';
      const ry = attrs.ry === undefined ? '' : `, ry: ${num(attrs.ry)}`;
      if (attrs.rx === undefined) {
        note.push(attrs.ry === undefined ? 'rx,ry absent' : 'rx absent (= ry)');
      }
      call =
        `${T.rect}(${num(attrs.x)}, ${num(attrs.y)}, ${num(attrs.width)}, ` +
        `${num(attrs.height)}, ${num(rx)}${ry})`;
      break;
    }

    case 'line':
      // lucide writes `x1, x2, y1, y2`; the element takes point-then-point.
      call =
        `${T.line}(${num(attrs.x1)}, ${num(attrs.y1)}, ` +
        `${num(attrs.x2)}, ${num(attrs.y2)})`;
      break;

    case 'ellipse':
      call =
        `${T.ellipse}(${num(attrs.cx)}, ${num(attrs.cy)}, ` +
        `${num(attrs.rx)}, ${num(attrs.ry)})`;
      break;

    case 'polyline':
    case 'polygon': {
      const type = tag === 'polygon' ? T.polygon : T.polyline;
      call = `${type}(<Offset>[${points(attrs.points).join(', ')}])`;
      break;
    }
  }

  const comment = [`key: ${attrs.key}`, ...note].join('; ');
  return `    ${call}, // ${comment}`;
}

// ── file emission ───────────────────────────────────────────────────────────

function header(extra) {
  return `// GENERATED FILE — DO NOT EDIT BY HAND.
//
// Regenerate with:
//
//     node tool/generate_icons.mjs
//
// Source: ${pkg.name} ${pkg.version} (${pkg.license}), read from
// \`design-system/node_modules/${pkg.name}/dist/esm/icons/\` — the reference's
// own installed package, not a re-publication of it. The generator imports
// each module and reads the \`__iconNode\` array lucide exports, so every
// number and every \`d\` string below is that package's own, character for
// character. Node order is lucide's, and node order is paint order.
${extra}`;
}

/** The node model itself — emitted only by `SHIM`.
 *
 *  Under `SEALED` these seven types are `icon_paths.dart`'s own, the file
 *  imports them instead of declaring them, and this whole block goes away. That
 *  is the merge `tool/README.md` describes; the glyph class below is emitted
 *  either way, because it is the registry's own shape rather than the model. */
function emitNodeModel() {
  return `
/// One SVG element from a lucide \`__iconNode\` list.
///
/// **This model is a staging shim, and it is deliberately shallow.** The port's
/// real element model is the \`sealed class ElIconElement\` hierarchy in
/// \`icon_paths.dart\`; a sealed class cannot be extended from another library,
/// and the full lucide set needs two node types that hierarchy does not have
/// yet ([ElLucideEllipse], [ElLucidePolygon]) plus a \`rect\` whose \`rx\` may be
/// absent. Rather than fork the parser, this shim **delegates every \`d\` string
/// straight to [ElIconPathElement]** — the port's own reader, unchanged and
/// unduplicated — and holds the structured nodes as the same fields under
/// different names. \`tool/README.md\` records the merge that retires it.
sealed class ${T.base} {
  const ${T.base}();

  /// Whether this node carries \`fill="currentColor"\`.
  bool get filled => false;

  /// Appends this element to [path] in lucide's 24-unit coordinate space.
  void addTo(Path path);
}

/// \`["path", { d: … }]\` — the SVG path data, verbatim.
class ${T.path} extends ${T.base} {
  const ${T.path}(this.d);

  /// The \`d\` attribute, character for character as lucide ships it.
  final String d;

  /// Parsed by the port's own reader — this is the whole reason the shim
  /// delegates instead of carrying a second parser.
  @override
  void addTo(Path path) => ElIconPathElement(d).addTo(path);
}

/// \`["circle", { cx, cy, r, fill? }]\`.
class ${T.circle} extends ${T.base} {
  const ${T.circle}(this.cx, this.cy, this.r, {this.filled = false});

  final double cx;
  final double cy;
  final double r;

  @override
  final bool filled;

  @override
  void addTo(Path path) =>
      path.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
}

/// \`["rect", { x, y, width, height, rx?, ry? }]\`.
///
/// [rx] is already resolved: SVG's mutual-auto rule says an absent \`rx\` takes
/// \`ry\`'s value and an absent pair means square corners, and the generator
/// applies it at emit time, recording the omission in a trailing comment.
class ${T.rect} extends ${T.base} {
  const ${T.rect}(this.x, this.y, this.width, this.height, this.rx, {this.ry});

  final double x;
  final double y;
  final double width;
  final double height;
  final double rx;

  /// \`ry\` where lucide spells it; \`null\` where it is absent and [rx] stands
  /// for both. Unlike the curated 78, the full set contains four nodes that
  /// spell \`ry\` **without** \`rx\` — see \`tool/README.md\`.
  final double? ry;

  @override
  void addTo(Path path) => path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, width, height),
          Radius.elliptical(rx, ry ?? rx),
        ),
      );
}

/// \`["line", { x1, y1, x2, y2 }]\` — one straight stroke.
class ${T.line} extends ${T.base} {
  const ${T.line}(this.x1, this.y1, this.x2, this.y2);

  final double x1;
  final double y1;
  final double x2;
  final double y2;

  @override
  void addTo(Path path) {
    path.moveTo(x1, y1);
    path.lineTo(x2, y2);
  }
}

/// \`["ellipse", { cx, cy, rx, ry }]\` — a closed elliptical subpath.
///
/// **New in the generated set.** The curated 78 contain none, which is why
/// \`icon_paths.dart\`'s docstring calls \`ellipse\` "the one lucide never reaches
/// for"; over the whole package it appears 16 times, and \`database\`'s lid is
/// the one everybody has seen.
class ${T.ellipse} extends ${T.base} {
  const ${T.ellipse}(this.cx, this.cy, this.rx, this.ry);

  final double cx;
  final double cy;
  final double rx;
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

/// \`["polyline", { points }]\` — an **open** run of straight segments.
class ${T.polyline} extends ${T.base} {
  const ${T.polyline}(this.points);

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

/// \`["polygon", { points }]\` — the same run of segments, **closed**.
///
/// **New in the generated set**, and the reason it is a type of its own rather
/// than a [${T.polyline}]: closing is a real difference. Both of lucide's two
/// polygons (\`navigation\`, \`navigation-2\`) happen to repeat their first point
/// as their last, so a polyline through the same list would trace the same
/// geometry — but it would meet itself with two round *caps* instead of a
/// round *join*, and writing it that way would be a silent rewrite of the kind
/// \`icon_paths.dart\`'s "structure over stringification" ruling forbids.
class ${T.polygon} extends ${T.base} {
  const ${T.polygon}(this.points);

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
`;
}

/** The glyph class — emitted under both models. */
function emitGlyphClass() {
  return `
/// One lucide glyph: its module name and its \`__iconNode\` list.
///
/// A plain class with a const constructor rather than an enum member, and that
/// is the load-bearing choice in this file — see the library docstring.
@immutable
class ElLucideGlyph {
  const ElLucideGlyph(this.name, this.nodes);

  /// The lucide module name, kebab-case: \`'circle-dollar-sign'\`.
  final String name;

  /// \`__iconNode\`, in lucide's order, which is paint order.
  final List<${T.base}> nodes;

  /// The glyph as one [Path] in 24-unit coordinates — the caller scales.
  ///
  /// A **fresh** path every call: [Path] is mutable, and a shared instance
  /// would let one painter corrupt every other icon.
  Path toPath() {
    final Path path = Path();
    for (final ${T.base} node in nodes) {
      node.addTo(path);
    }
    return path;
  }

  /// The \`fill="currentColor"\` nodes as one [Path], or \`null\` when there are
  /// none. 19 nodes across 9 glyphs carry the attribute.
  Path? toFillPath() {
    Path? path;
    for (final ${T.base} node in nodes) {
      if (!node.filled) continue;
      node.addTo(path ??= Path());
    }
    return path;
  }

  @override
  String toString() => 'ElLucideGlyph($name)';
}
`;
}

// ── main ────────────────────────────────────────────────────────────────────

const { icons, aliases } = await readPackage();

const tally = {};
let nodeTotal = 0;
const bodies = [];
for (const [name, nodes] of icons) {
  for (const [tag] of nodes) {
    tally[tag] = (tally[tag] ?? 0) + 1;
    nodeTotal++;
  }
  const lines = nodes.map((n) => emitNode(name, n)).join('\n');
  bodies.push(
    `  /// \`${name}.mjs\`\n` +
      `  static const ElLucideGlyph ${identifier(name)} =\n` +
      `      ElLucideGlyph('${name}', <${T.base}>[\n${lines}\n  ]);`,
  );
}

const tallyLine = Object.entries(tally)
  .sort((a, b) => b[1] - a[1])
  .map(([t, n]) => `${n} ${t}`)
  .join(', ');

// ---- the registry -----------------------------------------------------------

const registry = `${header(`//
// ${icons.length} glyphs, ${nodeTotal} nodes (${tallyLine}); ${aliases.length}
// deprecated aliases are in \`icon_paths.g.index.dart\`.

/// The full lucide set, one \`static const\` per glyph.
///
/// **Why a class of constants and not an enum with a lookup map.** This file is
/// the whole package, and the whole package must not reach the bundle of an app
/// that draws six icons. Dart's tree shaker works per top-level symbol: a
/// \`static const\` field is dropped when nothing names it, so \`ElLucide.zap\`
/// pulls in \`zap\` and nothing else. A \`const Map<ElIconGlyph, …>\` is one
/// symbol holding every value, so touching it at all pulls in all ${icons.length} —
/// which is precisely what \`lucide-react\` avoids on the web by shipping one
/// module per icon and letting the bundler drop the rest. This is the Dart
/// spelling of that same property, measured in \`tool/README.md\`.
///
/// The cost of that choice is that there is no way to go from a *string* to a
/// glyph without naming them all. That lookup exists, deliberately, in a
/// separate library — \`icon_paths.g.index.dart\` — so importing it is an opt-in
/// with a documented price rather than the default.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'icon_paths.dart';${
  T.emitModel ? '' : ' // the sealed element model this file is emitted against'
}
${T.emitModel ? emitNodeModel() : ''}${emitGlyphClass()}
/// Every glyph lucide ${pkg.version} ships.
class ElLucide {
  const ElLucide._();

  /// The viewBox lucide authors on — the same 24×24 grid as [ElIconPaths].
  static const double viewBox = 24;

${bodies.join('\n\n')}
}
`)}`;

// ---- the index --------------------------------------------------------------

const byName = icons
  .map(([name]) => `  '${name}': ElLucide.${identifier(name)},`)
  .join('\n');
const aliasMap = aliases
  .map(([from, to]) => `  '${from}': '${to}',`)
  .join('\n');

const index = `${header(`//
// The opt-in half of the registry: names.

/// String → glyph for the whole lucide set.
///
/// **Importing this library costs the entire set.** [elLucideByName] is a
/// single const map that names all ${icons.length} glyphs, so the tree shaker
/// must keep all ${icons.length}. That is the honest price of a dynamic lookup
/// and it is charged here, in its own library, rather than silently in
/// \`icon_paths.g.dart\`: an app that writes \`ElLucide.zap\` pays for \`zap\`, and
/// an app that writes \`elLucideByName[userSuppliedString]\` pays for lucide.
///
/// Measured on this package's example app — see \`tool/README.md\`.
library;

import 'icon_paths.g.dart';

/// Every glyph, keyed by its lucide module name.
const Map<String, ElLucideGlyph> elLucideByName = <String, ElLucideGlyph>{
${byName}
};

/// lucide's ${aliases.length} deprecated aliases: old name → the module that
/// now holds the geometry.
///
/// These are the \`export { default } from './target.mjs'\` one-liners in the
/// package — \`filter\` → \`funnel\`, \`help-circle\` → \`circle-question-mark\`,
/// \`alert-triangle\` → \`triangle-alert\`, and ${aliases.length - 3} more. Strings
/// only, so this map is cheap on its own; it is [elLucideByName] that is not.
const Map<String, String> elLucideAliases = <String, String>{
${aliasMap}
};

/// The glyph called [name], resolving deprecated aliases.
///
/// Returns \`null\` for a name lucide ${pkg.version} does not ship.
ElLucideGlyph? elLucideLookup(String name) =>
    elLucideByName[name] ?? elLucideByName[elLucideAliases[name] ?? ''];
`)}`;

mkdirSync(OUT_DIR, { recursive: true });
writeFileSync(path.join(OUT_DIR, 'icon_paths.g.dart'), registry);
writeFileSync(path.join(OUT_DIR, 'icon_paths.g.index.dart'), index);

const kb = (s) => `${(Buffer.byteLength(s) / 1024).toFixed(1)} KiB`;
console.log(`${pkg.name} ${pkg.version} (${pkg.license})`);
console.log(`  ${icons.length} glyphs, ${nodeTotal} nodes: ${tallyLine}`);
console.log(`  ${aliases.length} aliases`);
console.log(`  icon_paths.g.dart        ${kb(registry)}`);
console.log(`  icon_paths.g.index.dart  ${kb(index)}`);
