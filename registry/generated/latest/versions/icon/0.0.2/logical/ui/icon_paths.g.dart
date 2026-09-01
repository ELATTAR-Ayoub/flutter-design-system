// GENERATED FILE — DO NOT EDIT BY HAND.
//
// Regenerate with:
//
//     node tool/generate_icons.mjs
//
// Source: lucide-react 1.28.0 (ISC), read from
// `design-system/node_modules/lucide-react/dist/esm/icons/` — the reference's
// own installed package, not a re-publication of it. The generator imports
// each module and reads the `__iconNode` array lucide exports, so every
// number and every `d` string below is that package's own, character for
// character. Node order is lucide's, and node order is paint order.
//
// The geometry below is lucide's work, redistributed under lucide's terms.
// What follows is `lucide-react` 1.28.0's own `LICENSE`, reproduced
// verbatim from the installed package because ISC requires the notice to
// travel with every copy and this file is copied into consumer projects on
// its own. The same bytes are in `third_party/lucide/LICENSE`.
//
// ---------------------------------------------------------------------------
// ISC License
//
// Copyright (c) 2026 Lucide Icons and Contributors
//
// Permission to use, copy, modify, and/or distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.
//
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
//
// ---
//
// The following Lucide icons are derived from the Feather project:
//
// airplay, alert-circle, alert-octagon, alert-triangle, aperture, arrow-down-circle, arrow-down-left, arrow-down-right, arrow-down, arrow-left-circle, arrow-left, arrow-right-circle, arrow-right, arrow-up-circle, arrow-up-left, arrow-up-right, arrow-up, at-sign, calendar, cast, check, chevron-down, chevron-left, chevron-right, chevron-up, chevrons-down, chevrons-left, chevrons-right, chevrons-up, circle, clipboard, clock, code, columns, command, compass, corner-down-left, corner-down-right, corner-left-down, corner-left-up, corner-right-down, corner-right-up, corner-up-left, corner-up-right, crosshair, database, divide-circle, divide-square, dollar-sign, download, external-link, feather, frown, hash, headphones, help-circle, info, italic, key, layout, life-buoy, link-2, link, loader, lock, log-in, log-out, maximize, meh, minimize, minimize-2, minus-circle, minus-square, minus, monitor, moon, more-horizontal, more-vertical, move, music, navigation-2, navigation, octagon, pause-circle, percent, plus-circle, plus-square, plus, power, radio, rss, search, server, share, shopping-bag, sidebar, smartphone, smile, square, table-2, tablet, target, terminal, trash-2, trash, triangle, tv, type, upload, x-circle, x-octagon, x-square, x, zoom-in, zoom-out
//
// The MIT License (MIT) (for the icons listed above)
//
// Copyright (c) 2013-present Cole Bemis
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// ---------------------------------------------------------------------------
//
// 1756 glyphs, 7032 nodes (5932 path, 524 circle, 397 rect, 155 line, 16 ellipse, 6 polyline, 2 polygon); 250
// deprecated aliases are in `icon_paths.g.index.dart`.

/// The full lucide set, one `static const` per glyph.
///
/// **Why a class of constants and not an enum with a lookup map.** This file is
/// the whole package, and the whole package must not reach the bundle of an app
/// that draws six icons. Dart's tree shaker works per top-level symbol: a
/// `static const` field is dropped when nothing names it, so `Lucide.zap`
/// pulls in `zap` and nothing else. A `const Map<IconGlyph, …>` is one
/// symbol holding every value, so touching it at all pulls in all 1756 —
/// which is precisely what `lucide-react` avoids on the web by shipping one
/// module per icon and letting the bundler drop the rest. This is the Dart
/// spelling of that same property, measured in `tool/README.md`.
///
/// The cost of that choice is that there is no way to go from a *string* to a
/// glyph without naming them all. That lookup exists, deliberately, in a
/// separate library — `icon_paths.g.index.dart` — so importing it is an opt-in
/// with a documented price rather than the default.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import './icon_paths.dart'; // the sealed element model this file is emitted against

/// One lucide glyph: its module name and its `__iconNode` list.
///
/// A plain class with a const constructor rather than an enum member, and that
/// is the load-bearing choice in this file — see the library docstring.
@immutable
class LucideGlyph {
  const LucideGlyph(this.name, this.nodes);

  /// The lucide module name, kebab-case: `'circle-dollar-sign'`.
  final String name;

  /// `__iconNode`, in lucide's order, which is paint order.
  final List<IconElement> nodes;

  /// The glyph as one [Path] in 24-unit coordinates — the caller scales.
  ///
  /// A **fresh** path every call: [Path] is mutable, and a shared instance
  /// would let one painter corrupt every other icon.
  Path toPath() {
    final Path path = Path();
    for (final IconElement node in nodes) {
      node.addTo(path);
    }
    return path;
  }

  /// The `fill="currentColor"` nodes as one [Path], or `null` when there are
  /// none. 19 nodes across 9 glyphs carry the attribute.
  Path? toFillPath() {
    Path? path;
    for (final IconElement node in nodes) {
      if (!node.filled) continue;
      node.addTo(path ??= Path());
    }
    return path;
  }

  @override
  String toString() => 'LucideGlyph($name)';
}

/// Every glyph lucide 1.28.0 ships.
class Lucide {
  const Lucide._();

  /// The viewBox lucide authors on — the same 24×24 grid as [IconPaths].
  static const double viewBox = 24;

  /// `a-arrow-down.mjs`
  static const LucideGlyph
  aArrowDown = LucideGlyph('a-arrow-down', <IconElement>[
    IconPathElement('m14 12 4 4 4-4'), // key: buelq4
    IconPathElement('M18 16V7'), // key: ty0viw
    IconPathElement('m2 16 4.039-9.69a.5.5 0 0 1 .923 0L11 16'), // key: d5nyq2
    IconPathElement('M3.304 13h6.392'), // key: 1q3zxz
  ]);

  /// `a-arrow-up.mjs`
  static const LucideGlyph aArrowUp = LucideGlyph('a-arrow-up', <IconElement>[
    IconPathElement('m14 11 4-4 4 4'), // key: 1pu57t
    IconPathElement('M18 16V7'), // key: ty0viw
    IconPathElement('m2 16 4.039-9.69a.5.5 0 0 1 .923 0L11 16'), // key: d5nyq2
    IconPathElement('M3.304 13h6.392'), // key: 1q3zxz
  ]);

  /// `a-large-small.mjs`
  static const LucideGlyph
  aLargeSmall = LucideGlyph('a-large-small', <IconElement>[
    IconPathElement(
      'm15 16 2.536-7.328a1.02 1.02 1 0 1 1.928 0L22 16',
    ), // key: xik6mr
    IconPathElement('M15.697 14h5.606'), // key: 1stdlc
    IconPathElement('m2 16 4.039-9.69a.5.5 0 0 1 .923 0L11 16'), // key: d5nyq2
    IconPathElement('M3.304 13h6.392'), // key: 1q3zxz
  ]);

  /// `accessibility.mjs`
  static const LucideGlyph accessibility = LucideGlyph(
    'accessibility',
    <IconElement>[
      IconCircleElement(16, 4, 1), // key: 1grugj
      IconPathElement('m18 19 1-7-6 1'), // key: r0i19z
      IconPathElement('m5 8 3-3 5.5 3-2.36 3.5'), // key: 9ptxx2
      IconPathElement('M4.24 14.5a5 5 0 0 0 6.88 6'), // key: 10kmtu
      IconPathElement('M13.76 17.5a5 5 0 0 0-6.88-6'), // key: 2qq6rc
    ],
  );

  /// `activity.mjs`
  static const LucideGlyph activity = LucideGlyph('activity', <IconElement>[
    IconPathElement(
      'M22 12h-2.48a2 2 0 0 0-1.93 1.46l-2.35 8.36a.25.25 0 0 1-.48 0L9.24 2.18a.25.25 0 0 0-.48 0l-2.35 8.36A2 2 0 0 1 4.49 12H2',
    ), // key: 169zse
  ]);

  /// `ad.mjs`
  static const LucideGlyph ad = LucideGlyph('ad', <IconElement>[
    IconPathElement('M10 13H6'), // key: 18d9xh
    IconPathElement('M10 15v-4a2 2 0 0 0-4 0v4'), // key: ss28p3
    IconPathElement(
      'M14 14.5a.5.5 0 0 0 .5.5h1a2.5 2.5 0 0 0 2.5-2.5v-1A2.5 2.5 0 0 0 15.5 9h-1a.5.5 0 0 0-.5.5z',
    ), // key: b3f847
    IconRectElement(2, 5, 20, 14, 2), // key: qneu4z
  ]);

  /// `air-vent.mjs`
  static const LucideGlyph airVent = LucideGlyph('air-vent', <IconElement>[
    IconPathElement('M18 17.5a2.5 2.5 0 1 1-4 2.03V12'), // key: yd12zl
    IconPathElement(
      'M6 12H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2',
    ), // key: larmp2
    IconPathElement('M6 8h12'), // key: 6g4wlu
    IconPathElement('M6.6 15.572A2 2 0 1 0 10 17v-5'), // key: 1x1kqn
  ]);

  /// `airplay.mjs`
  static const LucideGlyph airplay = LucideGlyph('airplay', <IconElement>[
    IconPathElement(
      'M5 17H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-1',
    ), // key: ns4c3b
    IconPathElement('m12 15 5 6H7Z'), // key: 14qnn2
  ]);

  /// `alarm-clock-check.mjs`
  static const LucideGlyph alarmClockCheck = LucideGlyph(
    'alarm-clock-check',
    <IconElement>[
      IconCircleElement(12, 13, 8), // key: 3y4lt7
      IconPathElement('M5 3 2 6'), // key: 18tl5t
      IconPathElement('m22 6-3-3'), // key: 1opdir
      IconPathElement('M6.38 18.7 4 21'), // key: 17xu3x
      IconPathElement('M17.64 18.67 20 21'), // key: kv2oe2
      IconPathElement('m9 13 2 2 4-4'), // key: 6343dt
    ],
  );

  /// `alarm-clock-minus.mjs`
  static const LucideGlyph alarmClockMinus = LucideGlyph(
    'alarm-clock-minus',
    <IconElement>[
      IconCircleElement(12, 13, 8), // key: 3y4lt7
      IconPathElement('M5 3 2 6'), // key: 18tl5t
      IconPathElement('m22 6-3-3'), // key: 1opdir
      IconPathElement('M6.38 18.7 4 21'), // key: 17xu3x
      IconPathElement('M17.64 18.67 20 21'), // key: kv2oe2
      IconPathElement('M9 13h6'), // key: 1uhe8q
    ],
  );

  /// `alarm-clock-off.mjs`
  static const LucideGlyph alarmClockOff = LucideGlyph(
    'alarm-clock-off',
    <IconElement>[
      IconPathElement('M6.87 6.87a8 8 0 1 0 11.26 11.26'), // key: 3on8tj
      IconPathElement('M19.9 14.25a8 8 0 0 0-9.15-9.15'), // key: 15ghsc
      IconPathElement('m22 6-3-3'), // key: 1opdir
      IconPathElement('M6.26 18.67 4 21'), // key: yzmioq
      IconPathElement('m2 2 20 20'), // key: 1ooewy
      IconPathElement('M4 4 2 6'), // key: 1ycko6
    ],
  );

  /// `alarm-clock-plus.mjs`
  static const LucideGlyph alarmClockPlus = LucideGlyph(
    'alarm-clock-plus',
    <IconElement>[
      IconCircleElement(12, 13, 8), // key: 3y4lt7
      IconPathElement('M5 3 2 6'), // key: 18tl5t
      IconPathElement('m22 6-3-3'), // key: 1opdir
      IconPathElement('M6.38 18.7 4 21'), // key: 17xu3x
      IconPathElement('M17.64 18.67 20 21'), // key: kv2oe2
      IconPathElement('M12 10v6'), // key: 1bos4e
      IconPathElement('M9 13h6'), // key: 1uhe8q
    ],
  );

  /// `alarm-clock.mjs`
  static const LucideGlyph alarmClock = LucideGlyph(
    'alarm-clock',
    <IconElement>[
      IconCircleElement(12, 13, 8), // key: 3y4lt7
      IconPathElement('M12 9v4l2 2'), // key: 1c63tq
      IconPathElement('M5 3 2 6'), // key: 18tl5t
      IconPathElement('m22 6-3-3'), // key: 1opdir
      IconPathElement('M6.38 18.7 4 21'), // key: 17xu3x
      IconPathElement('M17.64 18.67 20 21'), // key: kv2oe2
    ],
  );

  /// `alarm-smoke.mjs`
  static const LucideGlyph alarmSmoke = LucideGlyph(
    'alarm-smoke',
    <IconElement>[
      IconPathElement('M11 21c0-2.5 2-2.5 2-5'), // key: 1sicvv
      IconPathElement('M16 21c0-2.5 2-2.5 2-5'), // key: 1o3eny
      IconPathElement(
        'm19 8-.8 3a1.25 1.25 0 0 1-1.2 1H7a1.25 1.25 0 0 1-1.2-1L5 8',
      ), // key: 1bvca4
      IconPathElement(
        'M21 3a1 1 0 0 1 1 1v2a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V4a1 1 0 0 1 1-1z',
      ), // key: x3qr1j
      IconPathElement('M6 21c0-2.5 2-2.5 2-5'), // key: i3w1gp
    ],
  );

  /// `album.mjs`
  static const LucideGlyph album = LucideGlyph('album', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    IconPolylineElement(<Offset>[
      Offset(11, 3),
      Offset(11, 11),
      Offset(14, 8),
      Offset(17, 11),
      Offset(17, 3),
    ]), // key: 1wcwz3
  ]);

  /// `align-center-horizontal.mjs`
  static const LucideGlyph
  alignCenterHorizontal = LucideGlyph('align-center-horizontal', <IconElement>[
    IconPathElement('M2 12h20'), // key: 9i4pu4
    IconPathElement('M10 16v4a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-4'), // key: 11f1s0
    IconPathElement('M10 8V4a2 2 0 0 0-2-2H6a2 2 0 0 0-2 2v4'), // key: t14dx9
    IconPathElement(
      'M20 16v1a2 2 0 0 1-2 2h-2a2 2 0 0 1-2-2v-1',
    ), // key: 1w07xs
    IconPathElement('M14 8V7c0-1.1.9-2 2-2h2a2 2 0 0 1 2 2v1'), // key: 1apec2
  ]);

  /// `align-center-vertical.mjs`
  static const LucideGlyph
  alignCenterVertical = LucideGlyph('align-center-vertical', <IconElement>[
    IconPathElement('M12 2v20'), // key: t6zp3m
    IconPathElement('M8 10H4a2 2 0 0 1-2-2V6c0-1.1.9-2 2-2h4'), // key: 14d6g8
    IconPathElement('M16 10h4a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2h-4'), // key: 1e2lrw
    IconPathElement('M8 20H7a2 2 0 0 1-2-2v-2c0-1.1.9-2 2-2h1'), // key: 1fkdwx
    IconPathElement('M16 14h1a2 2 0 0 1 2 2v2a2 2 0 0 1-2 2h-1'), // key: 1euafb
  ]);

  /// `align-end-horizontal.mjs`
  static const LucideGlyph alignEndHorizontal = LucideGlyph(
    'align-end-horizontal',
    <IconElement>[
      IconRectElement(4, 2, 6, 16, 2), // key: z5wdxg
      IconRectElement(14, 9, 6, 9, 2), // key: um7a8w
      IconPathElement('M22 22H2'), // key: 19qnx5
    ],
  );

  /// `align-end-vertical.mjs`
  static const LucideGlyph alignEndVertical = LucideGlyph(
    'align-end-vertical',
    <IconElement>[
      IconRectElement(2, 4, 16, 6, 2), // key: 10wcwx
      IconRectElement(9, 14, 9, 6, 2), // key: 4p5bwg
      IconPathElement('M22 22V2'), // key: 12ipfv
    ],
  );

  /// `align-horizontal-distribute-center.mjs`
  static const LucideGlyph alignHorizontalDistributeCenter = LucideGlyph(
    'align-horizontal-distribute-center',
    <IconElement>[
      IconRectElement(4, 5, 6, 14, 2), // key: 1wwnby
      IconRectElement(14, 7, 6, 10, 2), // key: 1fe6j6
      IconPathElement('M17 22v-5'), // key: 4b6g73
      IconPathElement('M17 7V2'), // key: hnrr36
      IconPathElement('M7 22v-3'), // key: 1r4jpn
      IconPathElement('M7 5V2'), // key: liy1u9
    ],
  );

  /// `align-horizontal-distribute-end.mjs`
  static const LucideGlyph alignHorizontalDistributeEnd = LucideGlyph(
    'align-horizontal-distribute-end',
    <IconElement>[
      IconRectElement(4, 5, 6, 14, 2), // key: 1wwnby
      IconRectElement(14, 7, 6, 10, 2), // key: 1fe6j6
      IconPathElement('M10 2v20'), // key: uyc634
      IconPathElement('M20 2v20'), // key: 1tx262
    ],
  );

  /// `align-horizontal-distribute-start.mjs`
  static const LucideGlyph alignHorizontalDistributeStart = LucideGlyph(
    'align-horizontal-distribute-start',
    <IconElement>[
      IconRectElement(4, 5, 6, 14, 2), // key: 1wwnby
      IconRectElement(14, 7, 6, 10, 2), // key: 1fe6j6
      IconPathElement('M4 2v20'), // key: gtpd5x
      IconPathElement('M14 2v20'), // key: tg6bpw
    ],
  );

  /// `align-horizontal-justify-center.mjs`
  static const LucideGlyph alignHorizontalJustifyCenter = LucideGlyph(
    'align-horizontal-justify-center',
    <IconElement>[
      IconRectElement(2, 5, 6, 14, 2), // key: dy24zr
      IconRectElement(16, 7, 6, 10, 2), // key: 13zkjt
      IconPathElement('M12 2v20'), // key: t6zp3m
    ],
  );

  /// `align-horizontal-justify-end.mjs`
  static const LucideGlyph alignHorizontalJustifyEnd = LucideGlyph(
    'align-horizontal-justify-end',
    <IconElement>[
      IconRectElement(2, 5, 6, 14, 2), // key: dy24zr
      IconRectElement(12, 7, 6, 10, 2), // key: 1ht384
      IconPathElement('M22 2v20'), // key: 40qfg1
    ],
  );

  /// `align-horizontal-justify-start.mjs`
  static const LucideGlyph alignHorizontalJustifyStart = LucideGlyph(
    'align-horizontal-justify-start',
    <IconElement>[
      IconRectElement(6, 5, 6, 14, 2), // key: hsirpf
      IconRectElement(16, 7, 6, 10, 2), // key: 13zkjt
      IconPathElement('M2 2v20'), // key: 1ivd8o
    ],
  );

  /// `align-horizontal-space-around.mjs`
  static const LucideGlyph alignHorizontalSpaceAround = LucideGlyph(
    'align-horizontal-space-around',
    <IconElement>[
      IconRectElement(9, 7, 6, 10, 2), // key: yn7j0q
      IconPathElement('M4 22V2'), // key: tsjzd3
      IconPathElement('M20 22V2'), // key: 1bnhr8
    ],
  );

  /// `align-horizontal-space-between.mjs`
  static const LucideGlyph alignHorizontalSpaceBetween = LucideGlyph(
    'align-horizontal-space-between',
    <IconElement>[
      IconRectElement(3, 5, 6, 14, 2), // key: j77dae
      IconRectElement(15, 7, 6, 10, 2), // key: bq30hj
      IconPathElement('M3 2v20'), // key: 1d2pfg
      IconPathElement('M21 2v20'), // key: p059bm
    ],
  );

  /// `align-start-horizontal.mjs`
  static const LucideGlyph alignStartHorizontal = LucideGlyph(
    'align-start-horizontal',
    <IconElement>[
      IconRectElement(4, 6, 6, 16, 2), // key: 1n4dg1
      IconRectElement(14, 6, 6, 9, 2), // key: 17khns
      IconPathElement('M22 2H2'), // key: fhrpnj
    ],
  );

  /// `align-start-vertical.mjs`
  static const LucideGlyph alignStartVertical = LucideGlyph(
    'align-start-vertical',
    <IconElement>[
      IconRectElement(6, 14, 9, 6, 2), // key: lpm2y7
      IconRectElement(6, 4, 16, 6, 2), // key: rdj6ps
      IconPathElement('M2 2v20'), // key: 1ivd8o
    ],
  );

  /// `align-vertical-distribute-center.mjs`
  static const LucideGlyph alignVerticalDistributeCenter = LucideGlyph(
    'align-vertical-distribute-center',
    <IconElement>[
      IconPathElement('M22 17h-3'), // key: 1lwga1
      IconPathElement('M22 7h-5'), // key: o2endc
      IconPathElement('M5 17H2'), // key: 1gx9xc
      IconPathElement('M7 7H2'), // key: 6bq26l
      IconRectElement(5, 14, 14, 6, 2), // key: 1qrzuf
      IconRectElement(7, 4, 10, 6, 2), // key: we8e9z
    ],
  );

  /// `align-vertical-distribute-end.mjs`
  static const LucideGlyph alignVerticalDistributeEnd = LucideGlyph(
    'align-vertical-distribute-end',
    <IconElement>[
      IconRectElement(5, 14, 14, 6, 2), // key: jmoj9s
      IconRectElement(7, 4, 10, 6, 2), // key: aza5on
      IconPathElement('M2 20h20'), // key: owomy5
      IconPathElement('M2 10h20'), // key: 1ir3d8
    ],
  );

  /// `align-vertical-distribute-start.mjs`
  static const LucideGlyph alignVerticalDistributeStart = LucideGlyph(
    'align-vertical-distribute-start',
    <IconElement>[
      IconRectElement(5, 14, 14, 6, 2), // key: jmoj9s
      IconRectElement(7, 4, 10, 6, 2), // key: aza5on
      IconPathElement('M2 14h20'), // key: myj16y
      IconPathElement('M2 4h20'), // key: mda7wb
    ],
  );

  /// `align-vertical-justify-center.mjs`
  static const LucideGlyph alignVerticalJustifyCenter = LucideGlyph(
    'align-vertical-justify-center',
    <IconElement>[
      IconRectElement(5, 16, 14, 6, 2), // key: 1i8z2d
      IconRectElement(7, 2, 10, 6, 2), // key: ypihtt
      IconPathElement('M2 12h20'), // key: 9i4pu4
    ],
  );

  /// `align-vertical-justify-end.mjs`
  static const LucideGlyph alignVerticalJustifyEnd = LucideGlyph(
    'align-vertical-justify-end',
    <IconElement>[
      IconRectElement(5, 12, 14, 6, 2), // key: 4l4tp2
      IconRectElement(7, 2, 10, 6, 2), // key: ypihtt
      IconPathElement('M2 22h20'), // key: 272qi7
    ],
  );

  /// `align-vertical-justify-start.mjs`
  static const LucideGlyph alignVerticalJustifyStart = LucideGlyph(
    'align-vertical-justify-start',
    <IconElement>[
      IconRectElement(5, 16, 14, 6, 2), // key: 1i8z2d
      IconRectElement(7, 6, 10, 6, 2), // key: 13squh
      IconPathElement('M2 2h20'), // key: 1ennik
    ],
  );

  /// `align-vertical-space-around.mjs`
  static const LucideGlyph alignVerticalSpaceAround = LucideGlyph(
    'align-vertical-space-around',
    <IconElement>[
      IconRectElement(7, 9, 10, 6, 2), // key: b1zbii
      IconPathElement('M22 20H2'), // key: 1p1f7z
      IconPathElement('M22 4H2'), // key: 1b7qnq
    ],
  );

  /// `align-vertical-space-between.mjs`
  static const LucideGlyph alignVerticalSpaceBetween = LucideGlyph(
    'align-vertical-space-between',
    <IconElement>[
      IconRectElement(5, 15, 14, 6, 2), // key: 1w91an
      IconRectElement(7, 3, 10, 6, 2), // key: 17wqzy
      IconPathElement('M2 21h20'), // key: 1nyx9w
      IconPathElement('M2 3h20'), // key: 91anmk
    ],
  );

  /// `ambulance.mjs`
  static const LucideGlyph ambulance = LucideGlyph('ambulance', <IconElement>[
    IconPathElement('M10 10H6'), // key: 1bsnug
    IconPathElement(
      'M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2',
    ), // key: wrbu53
    IconPathElement(
      'M19 18h2a1 1 0 0 0 1-1v-3.28a1 1 0 0 0-.684-.948l-1.923-.641a1 1 0 0 1-.578-.502l-1.539-3.076A1 1 0 0 0 16.382 8H14',
    ), // key: lrkjwd
    IconPathElement('M8 8v4'), // key: 1fwk8c
    IconPathElement('M9 18h6'), // key: x1upvd
    IconCircleElement(17, 18, 2), // key: 332jqn
    IconCircleElement(7, 18, 2), // key: 19iecd
  ]);

  /// `ampersand.mjs`
  static const LucideGlyph ampersand = LucideGlyph('ampersand', <IconElement>[
    IconPathElement('M16 12h3'), // key: 4uvgyw
    IconPathElement(
      'M17.5 12a8 8 0 0 1-8 8A4.5 4.5 0 0 1 5 15.5c0-6 8-4 8-8.5a3 3 0 1 0-6 0c0 3 2.5 8.5 12 13',
    ), // key: nfoe1t
  ]);

  /// `ampersands.mjs`
  static const LucideGlyph ampersands = LucideGlyph('ampersands', <IconElement>[
    IconPathElement(
      'M10 17c-5-3-7-7-7-9a2 2 0 0 1 4 0c0 2.5-5 2.5-5 6 0 1.7 1.3 3 3 3 2.8 0 5-2.2 5-5',
    ), // key: 12lh1k
    IconPathElement(
      'M22 17c-5-3-7-7-7-9a2 2 0 0 1 4 0c0 2.5-5 2.5-5 6 0 1.7 1.3 3 3 3 2.8 0 5-2.2 5-5',
    ), // key: 173c68
  ]);

  /// `amphora.mjs`
  static const LucideGlyph amphora = LucideGlyph('amphora', <IconElement>[
    IconPathElement(
      'M10 2v5.632c0 .424-.272.795-.653.982A6 6 0 0 0 6 14c.006 4 3 7 5 8',
    ), // key: 1h8rid
    IconPathElement('M10 5H8a2 2 0 0 0 0 4h.68'), // key: 3ezsi6
    IconPathElement(
      'M14 2v5.632c0 .424.272.795.652.982A6 6 0 0 1 18 14c0 4-3 7-5 8',
    ), // key: yt6q09
    IconPathElement('M14 5h2a2 2 0 0 1 0 4h-.68'), // key: 8f95yk
    IconPathElement('M18 22H6'), // key: mg6kv4
    IconPathElement('M9 2h6'), // key: 1jrp98
  ]);

  /// `anchor.mjs`
  static const LucideGlyph anchor = LucideGlyph('anchor', <IconElement>[
    IconPathElement('M12 6v16'), // key: nqf5sj
    IconPathElement('m19 13 2-1a9 9 0 0 1-18 0l2 1'), // key: y7qv08
    IconPathElement('M9 11h6'), // key: 1fldmi
    IconCircleElement(12, 4, 2), // key: muu5ef
  ]);

  /// `angry.mjs`
  static const LucideGlyph angry = LucideGlyph('angry', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M16 16s-1.5-2-4-2-4 2-4 2'), // key: epbg0q
    IconPathElement('M7.5 8 10 9'), // key: olxxln
    IconPathElement('m14 9 2.5-1'), // key: 1j6cij
    IconPathElement('M9 10h.01'), // key: qbtxuw
    IconPathElement('M15 10h.01'), // key: 1qmjsl
  ]);

  /// `annoyed.mjs`
  static const LucideGlyph annoyed = LucideGlyph('annoyed', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M8 15h8'), // key: 45n4r
    IconPathElement('M8 9h2'), // key: 1g203m
    IconPathElement('M14 9h2'), // key: 116p9w
  ]);

  /// `antenna.mjs`
  static const LucideGlyph antenna = LucideGlyph('antenna', <IconElement>[
    IconPathElement('M2 12 7 2'), // key: 117k30
    IconPathElement('m7 12 5-10'), // key: 1tvx22
    IconPathElement('m12 12 5-10'), // key: ev1o1a
    IconPathElement('m17 12 5-10'), // key: 1e4ti3
    IconPathElement('M4.5 7h15'), // key: vlsxkz
    IconPathElement('M12 16v6'), // key: c8a4gj
  ]);

  /// `anvil.mjs`
  static const LucideGlyph anvil = LucideGlyph('anvil', <IconElement>[
    IconPathElement('M7 10H6a4 4 0 0 1-4-4 1 1 0 0 1 1-1h4'), // key: 1hjpb6
    IconPathElement(
      'M7 5a1 1 0 0 1 1-1h13a1 1 0 0 1 1 1 7 7 0 0 1-7 7H8a1 1 0 0 1-1-1z',
    ), // key: 1qn45f
    IconPathElement('M9 12v5'), // key: 3anwtq
    IconPathElement('M15 12v5'), // key: 5xh3zn
    IconPathElement(
      'M5 20a3 3 0 0 1 3-3h8a3 3 0 0 1 3 3 1 1 0 0 1-1 1H6a1 1 0 0 1-1-1',
    ), // key: 1fi4x8
  ]);

  /// `aperture.mjs`
  static const LucideGlyph aperture = LucideGlyph('aperture', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('m14.31 8 5.74 9.94'), // key: 1y6ab4
    IconPathElement('M9.69 8h11.48'), // key: 1wxppr
    IconPathElement('m7.38 12 5.74-9.94'), // key: 1grp0k
    IconPathElement('M9.69 16 3.95 6.06'), // key: libnyf
    IconPathElement('M14.31 16H2.83'), // key: x5fava
    IconPathElement('m16.62 12-5.74 9.94'), // key: 1vwawt
  ]);

  /// `app-window-mac.mjs`
  static const LucideGlyph appWindowMac = LucideGlyph(
    'app-window-mac',
    <IconElement>[
      IconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
      IconPathElement('M6 8h.01'), // key: x9i8wu
      IconPathElement('M10 8h.01'), // key: 1r9ogq
      IconPathElement('M14 8h.01'), // key: 1primd
    ],
  );

  /// `app-window.mjs`
  static const LucideGlyph appWindow = LucideGlyph('app-window', <IconElement>[
    IconRectElement(2, 4, 20, 16, 2), // key: izxlao
    IconPathElement('M10 4v4'), // key: pp8u80
    IconPathElement('M2 8h20'), // key: d11cs7
    IconPathElement('M6 4v4'), // key: 1svtjw
  ]);

  /// `apple.mjs`
  static const LucideGlyph apple = LucideGlyph('apple', <IconElement>[
    IconPathElement('M12 6.528V3a1 1 0 0 1 1-1h0'), // key: 11qiee
    IconPathElement(
      'M18.237 21A15 15 0 0 0 22 11a6 6 0 0 0-10-4.472A6 6 0 0 0 2 11a15.1 15.1 0 0 0 3.763 10 3 3 0 0 0 3.648.648 5.5 5.5 0 0 1 5.178 0A3 3 0 0 0 18.237 21',
    ), // key: 110c12
  ]);

  /// `archive-restore.mjs`
  static const LucideGlyph archiveRestore = LucideGlyph(
    'archive-restore',
    <IconElement>[
      IconRectElement(2, 3, 20, 5, 1), // key: 1wp1u1
      IconPathElement('M4 8v11a2 2 0 0 0 2 2h2'), // key: tvwodi
      IconPathElement('M20 8v11a2 2 0 0 1-2 2h-2'), // key: 1gkqxj
      IconPathElement('m9 15 3-3 3 3'), // key: 1pd0qc
      IconPathElement('M12 12v9'), // key: 192myk
    ],
  );

  /// `archive-x.mjs`
  static const LucideGlyph archiveX = LucideGlyph('archive-x', <IconElement>[
    IconRectElement(2, 3, 20, 5, 1), // key: 1wp1u1
    IconPathElement('M4 8v11a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8'), // key: 1s80jp
    IconPathElement('m9.5 17 5-5'), // key: nakeu6
    IconPathElement('m9.5 12 5 5'), // key: 1hccrj
  ]);

  /// `archive.mjs`
  static const LucideGlyph archive = LucideGlyph('archive', <IconElement>[
    IconRectElement(2, 3, 20, 5, 1), // key: 1wp1u1
    IconPathElement('M4 8v11a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8'), // key: 1s80jp
    IconPathElement('M10 12h4'), // key: a56b0p
  ]);

  /// `armchair.mjs`
  static const LucideGlyph armchair = LucideGlyph('armchair', <IconElement>[
    IconPathElement('M19 9V6a2 2 0 0 0-2-2H7a2 2 0 0 0-2 2v3'), // key: irtipd
    IconPathElement(
      'M3 16a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-5a2 2 0 0 0-4 0v1.5a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5V11a2 2 0 0 0-4 0z',
    ), // key: 1qyhux
    IconPathElement('M5 18v2'), // key: ppbyun
    IconPathElement('M19 18v2'), // key: gy7782
  ]);

  /// `arrow-big-down-dash.mjs`
  static const LucideGlyph
  arrowBigDownDash = LucideGlyph('arrow-big-down-dash', <IconElement>[
    IconPathElement(
      'M14 8a1 1 0 0 1 1 1v2a1 1 0 0 0 1 1h3.293a.707.707 0 0 1 .5 1.207l-6.939 6.939a1.207 1.207 0 0 1-1.708 0l-6.94-6.94a.707.707 0 0 1 .5-1.206H8a1 1 0 0 0 1-1V9a1 1 0 0 1 1-1z',
    ), // key: 1b91ra
    IconPathElement('M9 4h6'), // key: 10am2s
  ]);

  /// `arrow-big-down.mjs`
  static const LucideGlyph
  arrowBigDown = LucideGlyph('arrow-big-down', <IconElement>[
    IconPathElement(
      'M9 5a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v6a1 1 0 0 0 1 1h3.293a.707.707 0 0 1 .5 1.207l-7.086 7.086a1 1 0 0 1-1.414 0l-7.086-7.086a.707.707 0 0 1 .5-1.207H8a1 1 0 0 0 1-1z',
    ), // key: 1o3tkq
  ]);

  /// `arrow-big-left-dash.mjs`
  static const LucideGlyph
  arrowBigLeftDash = LucideGlyph('arrow-big-left-dash', <IconElement>[
    IconPathElement(
      'M13 9a1 1 0 0 1-1-1V4.707a.707.707 0 0 0-1.207-.5l-6.94 6.94a1.207 1.207 0 0 0 0 1.707l6.94 6.94a.707.707 0 0 0 1.207-.5V16a1 1 0 0 1 1-1h2a1 1 0 0 0 1-1v-4a1 1 0 0 0-1-1z',
    ), // key: 17jy80
    IconPathElement('M20 9v6'), // key: 14roy0
  ]);

  /// `arrow-big-left.mjs`
  static const LucideGlyph
  arrowBigLeft = LucideGlyph('arrow-big-left', <IconElement>[
    IconPathElement(
      'M10.793 19.793a.707.707 0 0 0 1.207-.5V16a1 1 0 0 1 1-1h6a1 1 0 0 0 1-1v-4a1 1 0 0 0-1-1h-6a1 1 0 0 1-1-1V4.707a.707.707 0 0 0-1.207-.5l-6.94 6.94a1.207 1.207 0 0 0 0 1.707z',
    ), // key: qbhtmx
  ]);

  /// `arrow-big-right-dash.mjs`
  static const LucideGlyph
  arrowBigRightDash = LucideGlyph('arrow-big-right-dash', <IconElement>[
    IconPathElement(
      'M11 9a1 1 0 0 0 1-1V4.707a.707.707 0 0 1 1.207-.5l6.94 6.94a1.207 1.207 0 0 1 0 1.707l-6.94 6.94a.707.707 0 0 1-1.207-.5V16a1 1 0 0 0-1-1H9a1 1 0 0 1-1-1v-4a1 1 0 0 1 1-1z',
    ), // key: 9idyso
    IconPathElement('M4 9v6'), // key: bns7oa
  ]);

  /// `arrow-big-right.mjs`
  static const LucideGlyph
  arrowBigRight = LucideGlyph('arrow-big-right', <IconElement>[
    IconPathElement(
      'M13.207 19.793a.707.707 0 0 1-1.207-.5V16a1 1 0 0 0-1-1H5a1 1 0 0 1-1-1v-4a1 1 0 0 1 1-1h6a1 1 0 0 0 1-1V4.707a.707.707 0 0 1 1.207-.5l6.94 6.94a1.207 1.207 0 0 1 0 1.707z',
    ), // key: zee3eo
  ]);

  /// `arrow-big-up-dash.mjs`
  static const LucideGlyph
  arrowBigUpDash = LucideGlyph('arrow-big-up-dash', <IconElement>[
    IconPathElement(
      'M14 16a1 1 0 0 0 1-1v-2a1 1 0 0 1 1-1h3.293a.707.707 0 0 0 .5-1.207l-6.939-6.939a1.207 1.207 0 0 0-1.708 0l-6.94 6.94a.707.707 0 0 0 .5 1.206H8a1 1 0 0 1 1 1v2a1 1 0 0 0 1 1z',
    ), // key: q57loy
    IconPathElement('M9 20h6'), // key: s66wpe
  ]);

  /// `arrow-big-up.mjs`
  static const LucideGlyph
  arrowBigUp = LucideGlyph('arrow-big-up', <IconElement>[
    IconPathElement(
      'M9 19a1 1 0 0 0 1 1h4a1 1 0 0 0 1-1v-6a1 1 0 0 1 1-1h3.293a.707.707 0 0 0 .5-1.207l-7.086-7.086a1 1 0 0 0-1.414 0l-7.086 7.086a.707.707 0 0 0 .5 1.207H8a1 1 0 0 1 1 1z',
    ), // key: 106j91
  ]);

  /// `arrow-down-0-1.mjs`
  static const LucideGlyph arrowDown01 = LucideGlyph(
    'arrow-down-0-1',
    <IconElement>[
      IconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
      IconPathElement('M7 20V4'), // key: 1yoxec
      IconRectElement(15, 4, 4, 6, 2, ry: 2), // key: 1bwicg; rx absent (= ry)
      IconPathElement('M17 20v-6h-2'), // key: 1qp1so
      IconPathElement('M15 20h4'), // key: 1j968p
    ],
  );

  /// `arrow-down-1-0.mjs`
  static const LucideGlyph arrowDown10 = LucideGlyph(
    'arrow-down-1-0',
    <IconElement>[
      IconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
      IconPathElement('M7 20V4'), // key: 1yoxec
      IconPathElement('M17 10V4h-2'), // key: zcsr5x
      IconPathElement('M15 10h4'), // key: id2lce
      IconRectElement(15, 14, 4, 6, 2, ry: 2), // key: 33xykx; rx absent (= ry)
    ],
  );

  /// `arrow-down-a-z.mjs`
  static const LucideGlyph arrowDownAZ = LucideGlyph(
    'arrow-down-a-z',
    <IconElement>[
      IconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
      IconPathElement('M7 20V4'), // key: 1yoxec
      IconPathElement('M20 8h-5'), // key: 1vsyxs
      IconPathElement('M15 10V6.5a2.5 2.5 0 0 1 5 0V10'), // key: ag13bf
      IconPathElement('M15 14h5l-5 6h5'), // key: ur5jdg
    ],
  );

  /// `arrow-down-from-line.mjs`
  static const LucideGlyph arrowDownFromLine = LucideGlyph(
    'arrow-down-from-line',
    <IconElement>[
      IconPathElement('M19 3H5'), // key: 1236rx
      IconPathElement('M12 21V7'), // key: gj6g52
      IconPathElement('m6 15 6 6 6-6'), // key: h15q88
    ],
  );

  /// `arrow-down-left.mjs`
  static const LucideGlyph arrowDownLeft = LucideGlyph(
    'arrow-down-left',
    <IconElement>[
      IconPathElement('M17 7 7 17'), // key: 15tmo1
      IconPathElement('M17 17H7V7'), // key: 1org7z
    ],
  );

  /// `arrow-down-narrow-wide.mjs`
  static const LucideGlyph arrowDownNarrowWide = LucideGlyph(
    'arrow-down-narrow-wide',
    <IconElement>[
      IconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
      IconPathElement('M7 20V4'), // key: 1yoxec
      IconPathElement('M11 4h4'), // key: 6d7r33
      IconPathElement('M11 8h7'), // key: djye34
      IconPathElement('M11 12h10'), // key: 1438ji
    ],
  );

  /// `arrow-down-right.mjs`
  static const LucideGlyph arrowDownRight = LucideGlyph(
    'arrow-down-right',
    <IconElement>[
      IconPathElement('m7 7 10 10'), // key: 1fmybs
      IconPathElement('M17 7v10H7'), // key: 6fjiku
    ],
  );

  /// `arrow-down-to-dot.mjs`
  static const LucideGlyph arrowDownToDot = LucideGlyph(
    'arrow-down-to-dot',
    <IconElement>[
      IconPathElement('M12 2v14'), // key: jyx4ut
      IconPathElement('m19 9-7 7-7-7'), // key: 1oe3oy
      IconCircleElement(12, 21, 1), // key: o0uj5v
    ],
  );

  /// `arrow-down-to-line.mjs`
  static const LucideGlyph arrowDownToLine = LucideGlyph(
    'arrow-down-to-line',
    <IconElement>[
      IconPathElement('M12 17V3'), // key: 1cwfxf
      IconPathElement('m6 11 6 6 6-6'), // key: 12ii2o
      IconPathElement('M19 21H5'), // key: 150jfl
    ],
  );

  /// `arrow-down-up.mjs`
  static const LucideGlyph arrowDownUp = LucideGlyph(
    'arrow-down-up',
    <IconElement>[
      IconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
      IconPathElement('M7 20V4'), // key: 1yoxec
      IconPathElement('m21 8-4-4-4 4'), // key: 1c9v7m
      IconPathElement('M17 4v16'), // key: 7dpous
    ],
  );

  /// `arrow-down-wide-narrow.mjs`
  static const LucideGlyph arrowDownWideNarrow = LucideGlyph(
    'arrow-down-wide-narrow',
    <IconElement>[
      IconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
      IconPathElement('M7 20V4'), // key: 1yoxec
      IconPathElement('M11 4h10'), // key: 1w87gc
      IconPathElement('M11 8h7'), // key: djye34
      IconPathElement('M11 12h4'), // key: q8tih4
    ],
  );

  /// `arrow-down-z-a.mjs`
  static const LucideGlyph arrowDownZA = LucideGlyph(
    'arrow-down-z-a',
    <IconElement>[
      IconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
      IconPathElement('M7 4v16'), // key: 1glfcx
      IconPathElement('M15 4h5l-5 6h5'), // key: 8asdl1
      IconPathElement('M15 20v-3.5a2.5 2.5 0 0 1 5 0V20'), // key: r6l5cz
      IconPathElement('M20 18h-5'), // key: 18j1r2
    ],
  );

  /// `arrow-down.mjs`
  static const LucideGlyph arrowDown = LucideGlyph('arrow-down', <IconElement>[
    IconPathElement('M12 5v14'), // key: s699le
    IconPathElement('m19 12-7 7-7-7'), // key: 1idqje
  ]);

  /// `arrow-left-from-line.mjs`
  static const LucideGlyph arrowLeftFromLine = LucideGlyph(
    'arrow-left-from-line',
    <IconElement>[
      IconPathElement('m9 6-6 6 6 6'), // key: 7v63n9
      IconPathElement('M3 12h14'), // key: 13k4hi
      IconPathElement('M21 19V5'), // key: b4bplr
    ],
  );

  /// `arrow-left-right.mjs`
  static const LucideGlyph arrowLeftRight = LucideGlyph(
    'arrow-left-right',
    <IconElement>[
      IconPathElement('M8 3 4 7l4 4'), // key: 9rb6wj
      IconPathElement('M4 7h16'), // key: 6tx8e3
      IconPathElement('m16 21 4-4-4-4'), // key: siv7j2
      IconPathElement('M20 17H4'), // key: h6l3hr
    ],
  );

  /// `arrow-left-to-line.mjs`
  static const LucideGlyph arrowLeftToLine = LucideGlyph(
    'arrow-left-to-line',
    <IconElement>[
      IconPathElement('M3 19V5'), // key: rwsyhb
      IconPathElement('m13 6-6 6 6 6'), // key: 1yhaz7
      IconPathElement('M7 12h14'), // key: uoisry
    ],
  );

  /// `arrow-left.mjs`
  static const LucideGlyph arrowLeft = LucideGlyph('arrow-left', <IconElement>[
    IconPathElement('m12 19-7-7 7-7'), // key: 1l729n
    IconPathElement('M19 12H5'), // key: x3x0zl
  ]);

  /// `arrow-right-from-line.mjs`
  static const LucideGlyph arrowRightFromLine = LucideGlyph(
    'arrow-right-from-line',
    <IconElement>[
      IconPathElement('M3 5v14'), // key: 1nt18q
      IconPathElement('M21 12H7'), // key: 13ipq5
      IconPathElement('m15 18 6-6-6-6'), // key: 6tx3qv
    ],
  );

  /// `arrow-right-left.mjs`
  static const LucideGlyph arrowRightLeft = LucideGlyph(
    'arrow-right-left',
    <IconElement>[
      IconPathElement('m16 3 4 4-4 4'), // key: 1x1c3m
      IconPathElement('M20 7H4'), // key: zbl0bi
      IconPathElement('m8 21-4-4 4-4'), // key: h9nckh
      IconPathElement('M4 17h16'), // key: g4d7ey
    ],
  );

  /// `arrow-right-to-line.mjs`
  static const LucideGlyph arrowRightToLine = LucideGlyph(
    'arrow-right-to-line',
    <IconElement>[
      IconPathElement('M17 12H3'), // key: 8awo09
      IconPathElement('m11 18 6-6-6-6'), // key: 8c2y43
      IconPathElement('M21 5v14'), // key: nzette
    ],
  );

  /// `arrow-right.mjs`
  static const LucideGlyph arrowRight = LucideGlyph(
    'arrow-right',
    <IconElement>[
      IconPathElement('M5 12h14'), // key: 1ays0h
      IconPathElement('m12 5 7 7-7 7'), // key: xquz4c
    ],
  );

  /// `arrow-up-0-1.mjs`
  static const LucideGlyph arrowUp01 = LucideGlyph(
    'arrow-up-0-1',
    <IconElement>[
      IconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
      IconPathElement('M7 4v16'), // key: 1glfcx
      IconRectElement(15, 4, 4, 6, 2, ry: 2), // key: 1bwicg; rx absent (= ry)
      IconPathElement('M17 20v-6h-2'), // key: 1qp1so
      IconPathElement('M15 20h4'), // key: 1j968p
    ],
  );

  /// `arrow-up-1-0.mjs`
  static const LucideGlyph arrowUp10 = LucideGlyph(
    'arrow-up-1-0',
    <IconElement>[
      IconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
      IconPathElement('M7 4v16'), // key: 1glfcx
      IconPathElement('M17 10V4h-2'), // key: zcsr5x
      IconPathElement('M15 10h4'), // key: id2lce
      IconRectElement(15, 14, 4, 6, 2, ry: 2), // key: 33xykx; rx absent (= ry)
    ],
  );

  /// `arrow-up-a-z.mjs`
  static const LucideGlyph arrowUpAZ = LucideGlyph(
    'arrow-up-a-z',
    <IconElement>[
      IconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
      IconPathElement('M7 4v16'), // key: 1glfcx
      IconPathElement('M20 8h-5'), // key: 1vsyxs
      IconPathElement('M15 10V6.5a2.5 2.5 0 0 1 5 0V10'), // key: ag13bf
      IconPathElement('M15 14h5l-5 6h5'), // key: ur5jdg
    ],
  );

  /// `arrow-up-down.mjs`
  static const LucideGlyph arrowUpDown = LucideGlyph(
    'arrow-up-down',
    <IconElement>[
      IconPathElement('m21 16-4 4-4-4'), // key: f6ql7i
      IconPathElement('M17 20V4'), // key: 1ejh1v
      IconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
      IconPathElement('M7 4v16'), // key: 1glfcx
    ],
  );

  /// `arrow-up-from-dot.mjs`
  static const LucideGlyph arrowUpFromDot = LucideGlyph(
    'arrow-up-from-dot',
    <IconElement>[
      IconPathElement('m5 9 7-7 7 7'), // key: 1hw5ic
      IconPathElement('M12 16V2'), // key: ywoabb
      IconCircleElement(12, 21, 1), // key: o0uj5v
    ],
  );

  /// `arrow-up-from-line.mjs`
  static const LucideGlyph arrowUpFromLine = LucideGlyph(
    'arrow-up-from-line',
    <IconElement>[
      IconPathElement('m18 9-6-6-6 6'), // key: kcunyi
      IconPathElement('M12 3v14'), // key: 7cf3v8
      IconPathElement('M5 21h14'), // key: 11awu3
    ],
  );

  /// `arrow-up-left.mjs`
  static const LucideGlyph arrowUpLeft = LucideGlyph(
    'arrow-up-left',
    <IconElement>[
      IconPathElement('M7 17V7h10'), // key: 11bw93
      IconPathElement('M17 17 7 7'), // key: 2786uv
    ],
  );

  /// `arrow-up-narrow-wide.mjs`
  static const LucideGlyph arrowUpNarrowWide = LucideGlyph(
    'arrow-up-narrow-wide',
    <IconElement>[
      IconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
      IconPathElement('M7 4v16'), // key: 1glfcx
      IconPathElement('M11 12h4'), // key: q8tih4
      IconPathElement('M11 16h7'), // key: uosisv
      IconPathElement('M11 20h10'), // key: jvxblo
    ],
  );

  /// `arrow-up-right.mjs`
  static const LucideGlyph arrowUpRight = LucideGlyph(
    'arrow-up-right',
    <IconElement>[
      IconPathElement('M7 7h10v10'), // key: 1tivn9
      IconPathElement('M7 17 17 7'), // key: 1vkiza
    ],
  );

  /// `arrow-up-to-line.mjs`
  static const LucideGlyph arrowUpToLine = LucideGlyph(
    'arrow-up-to-line',
    <IconElement>[
      IconPathElement('M5 3h14'), // key: 7usisc
      IconPathElement('m18 13-6-6-6 6'), // key: 1kf1n9
      IconPathElement('M12 7v14'), // key: 1akyts
    ],
  );

  /// `arrow-up-wide-narrow.mjs`
  static const LucideGlyph arrowUpWideNarrow = LucideGlyph(
    'arrow-up-wide-narrow',
    <IconElement>[
      IconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
      IconPathElement('M7 4v16'), // key: 1glfcx
      IconPathElement('M11 12h10'), // key: 1438ji
      IconPathElement('M11 16h7'), // key: uosisv
      IconPathElement('M11 20h4'), // key: 1krc32
    ],
  );

  /// `arrow-up-z-a.mjs`
  static const LucideGlyph arrowUpZA = LucideGlyph(
    'arrow-up-z-a',
    <IconElement>[
      IconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
      IconPathElement('M7 4v16'), // key: 1glfcx
      IconPathElement('M15 4h5l-5 6h5'), // key: 8asdl1
      IconPathElement('M15 20v-3.5a2.5 2.5 0 0 1 5 0V20'), // key: r6l5cz
      IconPathElement('M20 18h-5'), // key: 18j1r2
    ],
  );

  /// `arrow-up.mjs`
  static const LucideGlyph arrowUp = LucideGlyph('arrow-up', <IconElement>[
    IconPathElement('m5 12 7-7 7 7'), // key: hav0vg
    IconPathElement('M12 19V5'), // key: x0mq9r
  ]);

  /// `arrows-up-from-line.mjs`
  static const LucideGlyph arrowsUpFromLine = LucideGlyph(
    'arrows-up-from-line',
    <IconElement>[
      IconPathElement('m4 6 3-3 3 3'), // key: 9aidw8
      IconPathElement('M7 17V3'), // key: 19qxw1
      IconPathElement('m14 6 3-3 3 3'), // key: 6iy689
      IconPathElement('M17 17V3'), // key: o0fmgi
      IconPathElement('M4 21h16'), // key: 1h09gz
    ],
  );

  /// `asterisk.mjs`
  static const LucideGlyph asterisk = LucideGlyph('asterisk', <IconElement>[
    IconPathElement('M12 6v12'), // key: 1vza4d
    IconPathElement('M17.196 9 6.804 15'), // key: 1ah31z
    IconPathElement('m6.804 9 10.392 6'), // key: 1b6pxd
  ]);

  /// `astroid.mjs`
  static const LucideGlyph astroid = LucideGlyph('astroid', <IconElement>[
    IconPathElement(
      'M12.983 21.186a1 1 0 0 1-1.966 0 10 10 0 0 0-8.203-8.203 1 1 0 0 1 0-1.966 10 10 0 0 0 8.203-8.203 1 1 0 0 1 1.966 0 10 10 0 0 0 8.203 8.203 1 1 0 0 1 0 1.966 10 10 0 0 0-8.203 8.203',
    ), // key: 1tipus
  ]);

  /// `at-sign.mjs`
  static const LucideGlyph atSign = LucideGlyph('at-sign', <IconElement>[
    IconCircleElement(12, 12, 4), // key: 4exip2
    IconPathElement('M16 8v5a3 3 0 0 0 6 0v-1a10 10 0 1 0-4 8'), // key: 7n84p3
  ]);

  /// `atom.mjs`
  static const LucideGlyph atom = LucideGlyph('atom', <IconElement>[
    IconCircleElement(12, 12, 1), // key: 41hilf
    IconPathElement(
      'M20.2 20.2c2.04-2.03.02-7.36-4.5-11.9-4.54-4.52-9.87-6.54-11.9-4.5-2.04 2.03-.02 7.36 4.5 11.9 4.54 4.52 9.87 6.54 11.9 4.5Z',
    ), // key: 1l2ple
    IconPathElement(
      'M15.7 15.7c4.52-4.54 6.54-9.87 4.5-11.9-2.03-2.04-7.36-.02-11.9 4.5-4.52 4.54-6.54 9.87-4.5 11.9 2.03 2.04 7.36.02 11.9-4.5Z',
    ), // key: 1wam0m
  ]);

  /// `audio-lines.mjs`
  static const LucideGlyph audioLines = LucideGlyph(
    'audio-lines',
    <IconElement>[
      IconPathElement('M2 10v3'), // key: 1fnikh
      IconPathElement('M6 6v11'), // key: 11sgs0
      IconPathElement('M10 3v18'), // key: yhl04a
      IconPathElement('M14 8v7'), // key: 3a1oy3
      IconPathElement('M18 5v13'), // key: 123xd1
      IconPathElement('M22 10v3'), // key: 154ddg
    ],
  );

  /// `audio-waveform.mjs`
  static const LucideGlyph
  audioWaveform = LucideGlyph('audio-waveform', <IconElement>[
    IconPathElement(
      'M2 13a2 2 0 0 0 2-2V7a2 2 0 0 1 4 0v13a2 2 0 0 0 4 0V4a2 2 0 0 1 4 0v13a2 2 0 0 0 4 0v-4a2 2 0 0 1 2-2',
    ), // key: 57tc96
  ]);

  /// `award.mjs`
  static const LucideGlyph award = LucideGlyph('award', <IconElement>[
    IconPathElement(
      'm15.477 12.89 1.515 8.526a.5.5 0 0 1-.81.47l-3.58-2.687a1 1 0 0 0-1.197 0l-3.586 2.686a.5.5 0 0 1-.81-.469l1.514-8.526',
    ), // key: 1yiouv
    IconCircleElement(12, 8, 6), // key: 1vp47v
  ]);

  /// `axe.mjs`
  static const LucideGlyph axe = LucideGlyph('axe', <IconElement>[
    IconPathElement('m14 12-8.381 8.38a1 1 0 0 1-3.001-3L11 9'), // key: 5z9253
    IconPathElement(
      'M15 15.5a.5.5 0 0 0 .5.5A6.5 6.5 0 0 0 22 9.5a.5.5 0 0 0-.5-.5h-1.672a2 2 0 0 1-1.414-.586l-5.062-5.062a1.205 1.205 0 0 0-1.704 0L9.352 5.648a1.205 1.205 0 0 0 0 1.704l5.062 5.062A2 2 0 0 1 15 13.828z',
    ), // key: 19zklq
  ]);

  /// `axis-3d.mjs`
  static const LucideGlyph axis3d = LucideGlyph('axis-3d', <IconElement>[
    IconPathElement('M13.5 10.5 15 9'), // key: 1nsxvm
    IconPathElement('M4 4v15a1 1 0 0 0 1 1h15'), // key: 1w6lkd
    IconPathElement('M4.293 19.707 6 18'), // key: 3g1p8c
    IconPathElement('m9 15 1.5-1.5'), // key: 1xfbes
  ]);

  /// `baby.mjs`
  static const LucideGlyph baby = LucideGlyph('baby', <IconElement>[
    IconPathElement('M10 16c.5.3 1.2.5 2 .5s1.5-.2 2-.5'), // key: 1u7htd
    IconPathElement('M15 12h.01'), // key: 1k8ypt
    IconPathElement(
      'M19.38 6.813A9 9 0 0 1 20.8 10.2a2 2 0 0 1 0 3.6 9 9 0 0 1-17.6 0 2 2 0 0 1 0-3.6A9 9 0 0 1 12 3c2 0 3.5 1.1 3.5 2.5s-.9 2.5-2 2.5c-.8 0-1.5-.4-1.5-1',
    ), // key: 11xh7x
    IconPathElement('M9 12h.01'), // key: 157uk2
  ]);

  /// `backpack.mjs`
  static const LucideGlyph backpack = LucideGlyph('backpack', <IconElement>[
    IconPathElement(
      'M4 10a4 4 0 0 1 4-4h8a4 4 0 0 1 4 4v10a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2z',
    ), // key: 1ol0lm
    IconPathElement('M8 10h8'), // key: c7uz4u
    IconPathElement('M8 18h8'), // key: 1no2b1
    IconPathElement('M8 22v-6a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v6'), // key: 1fr6do
    IconPathElement('M9 6V4a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2'), // key: donm21
  ]);

  /// `badge-alert.mjs`
  static const LucideGlyph
  badgeAlert = LucideGlyph('badge-alert', <IconElement>[
    IconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    IconLineElement(12, 8, 12, 12), // key: 1pkeuh
    IconLineElement(12, 16, 12.01, 16), // key: 4dfq90
  ]);

  /// `badge-cent.mjs`
  static const LucideGlyph badgeCent = LucideGlyph('badge-cent', <IconElement>[
    IconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    IconPathElement('M12 7v10'), // key: jspqdw
    IconPathElement('M15.4 10a4 4 0 1 0 0 4'), // key: 2eqtx8
  ]);

  /// `badge-check.mjs`
  static const LucideGlyph
  badgeCheck = LucideGlyph('badge-check', <IconElement>[
    IconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    IconPathElement('m9 12 2 2 4-4'), // key: dzmm74
  ]);

  /// `badge-dollar-sign.mjs`
  static const LucideGlyph
  badgeDollarSign = LucideGlyph('badge-dollar-sign', <IconElement>[
    IconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    IconPathElement('M16 8h-6a2 2 0 1 0 0 4h4a2 2 0 1 1 0 4H8'), // key: 1h4pet
    IconPathElement('M12 18V6'), // key: zqpxq5
  ]);

  /// `badge-euro.mjs`
  static const LucideGlyph badgeEuro = LucideGlyph('badge-euro', <IconElement>[
    IconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    IconPathElement('M7 12h5'), // key: gblrwe
    IconPathElement('M15 9.4a4 4 0 1 0 0 5.2'), // key: 1makmb
  ]);

  /// `badge-indian-rupee.mjs`
  static const LucideGlyph
  badgeIndianRupee = LucideGlyph('badge-indian-rupee', <IconElement>[
    IconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    IconPathElement('M8 8h8'), // key: 1bis0t
    IconPathElement('M8 12h8'), // key: 1wcyev
    IconPathElement('m13 17-5-1h1a4 4 0 0 0 0-8'), // key: nu2bwa
  ]);

  /// `badge-info.mjs`
  static const LucideGlyph badgeInfo = LucideGlyph('badge-info', <IconElement>[
    IconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    IconLineElement(12, 16, 12, 12), // key: 1y1yb1
    IconLineElement(12, 8, 12.01, 8), // key: 110wyk
  ]);

  /// `badge-japanese-yen.mjs`
  static const LucideGlyph
  badgeJapaneseYen = LucideGlyph('badge-japanese-yen', <IconElement>[
    IconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    IconPathElement('m9 8 3 3v7'), // key: 17yadx
    IconPathElement('m12 11 3-3'), // key: p4cfq1
    IconPathElement('M9 12h6'), // key: 1c52cq
    IconPathElement('M9 16h6'), // key: 8wimt3
  ]);

  /// `badge-minus.mjs`
  static const LucideGlyph
  badgeMinus = LucideGlyph('badge-minus', <IconElement>[
    IconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    IconLineElement(8, 12, 16, 12), // key: 1jonct
  ]);

  /// `badge-percent.mjs`
  static const LucideGlyph
  badgePercent = LucideGlyph('badge-percent', <IconElement>[
    IconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    IconPathElement('m15 9-6 6'), // key: 1uzhvr
    IconPathElement('M9 9h.01'), // key: 1q5me6
    IconPathElement('M15 15h.01'), // key: lqbp3k
  ]);

  /// `badge-plus.mjs`
  static const LucideGlyph badgePlus = LucideGlyph('badge-plus', <IconElement>[
    IconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    IconLineElement(12, 8, 12, 16), // key: 10p56q
    IconLineElement(8, 12, 16, 12), // key: 1jonct
  ]);

  /// `badge-pound-sterling.mjs`
  static const LucideGlyph
  badgePoundSterling = LucideGlyph('badge-pound-sterling', <IconElement>[
    IconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    IconPathElement('M8 12h4'), // key: qz6y1c
    IconPathElement('M10 16V9.5a2.5 2.5 0 0 1 5 0'), // key: 3mlbjk
    IconPathElement('M8 16h7'), // key: sbedsn
  ]);

  /// `badge-question-mark.mjs`
  static const LucideGlyph
  badgeQuestionMark = LucideGlyph('badge-question-mark', <IconElement>[
    IconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    IconPathElement('M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3'), // key: 1u773s
    IconLineElement(12, 17, 12.01, 17), // key: io3f8k
  ]);

  /// `badge-russian-ruble.mjs`
  static const LucideGlyph
  badgeRussianRuble = LucideGlyph('badge-russian-ruble', <IconElement>[
    IconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    IconPathElement('M9 16h5'), // key: 1syiyw
    IconPathElement('M9 12h5a2 2 0 1 0 0-4h-3v9'), // key: 1ge9c1
  ]);

  /// `badge-swiss-franc.mjs`
  static const LucideGlyph
  badgeSwissFranc = LucideGlyph('badge-swiss-franc', <IconElement>[
    IconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    IconPathElement('M11 17V8h4'), // key: 1bfq6y
    IconPathElement('M11 12h3'), // key: 2eqnfz
    IconPathElement('M9 16h4'), // key: 1skf3a
  ]);

  /// `badge-turkish-lira.mjs`
  static const LucideGlyph
  badgeTurkishLira = LucideGlyph('badge-turkish-lira', <IconElement>[
    IconPathElement('M11 7v10a5 5 0 0 0 5-5'), // key: 1ja3ih
    IconPathElement('m15 8-6 3'), // key: 4x0uwz
    IconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76',
    ), // key: 18242g
  ]);

  /// `badge-x.mjs`
  static const LucideGlyph badgeX = LucideGlyph('badge-x', <IconElement>[
    IconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    IconLineElement(15, 9, 9, 15), // key: f7djnv
    IconLineElement(9, 9, 15, 15), // key: 1shsy8
  ]);

  /// `badge.mjs`
  static const LucideGlyph badge = LucideGlyph('badge', <IconElement>[
    IconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
  ]);

  /// `baggage-claim.mjs`
  static const LucideGlyph baggageClaim = LucideGlyph(
    'baggage-claim',
    <IconElement>[
      IconPathElement('M22 18H6a2 2 0 0 1-2-2V7a2 2 0 0 0-2-2'), // key: 4irg2o
      IconPathElement(
        'M17 14V4a2 2 0 0 0-2-2h-1a2 2 0 0 0-2 2v10',
      ), // key: 14fcyx
      IconRectElement(8, 6, 13, 8, 1), // key: o6oiis
      IconCircleElement(18, 20, 2), // key: t9985n
      IconCircleElement(9, 20, 2), // key: e5v82j
    ],
  );

  /// `balloon.mjs`
  static const LucideGlyph balloon = LucideGlyph('balloon', <IconElement>[
    IconPathElement('M12 16v1a2 2 0 0 0 2 2h1a2 2 0 0 1 2 2v1'), // key: 2nz4b
    IconPathElement('M12 6a2 2 0 0 1 2 2'), // key: 7y7d82
    IconPathElement(
      'M18 8c0 4-3.5 8-6 8s-6-4-6-8a6 6 0 0 1 12 0',
    ), // key: vqb5s3
  ]);

  /// `ban.mjs`
  static const LucideGlyph ban = LucideGlyph('ban', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M4.929 4.929 19.07 19.071'), // key: 196cmz
  ]);

  /// `banana.mjs`
  static const LucideGlyph banana = LucideGlyph('banana', <IconElement>[
    IconPathElement('M4 13c3.5-2 8-2 10 2a5.5 5.5 0 0 1 8 5'), // key: 1cscit
    IconPathElement(
      'M5.15 17.89c5.52-1.52 8.65-6.89 7-12C11.55 4 11.5 2 13 2c3.22 0 5 5.5 5 8 0 6.5-4.2 12-10.49 12C5.11 22 2 22 2 20c0-1.5 1.14-1.55 3.15-2.11Z',
    ), // key: 1y1nbv
  ]);

  /// `bandage.mjs`
  static const LucideGlyph bandage = LucideGlyph('bandage', <IconElement>[
    IconPathElement('M10 10.01h.01'), // key: 1e9xi7
    IconPathElement('M10 14.01h.01'), // key: ac23bv
    IconPathElement('M14 10.01h.01'), // key: 2wfrvf
    IconPathElement('M14 14.01h.01'), // key: 8tw8yn
    IconPathElement('M18 6v12'), // key: 1bcixs
    IconPathElement('M6 6v12'), // key: vkc79e
    IconRectElement(2, 6, 20, 12, 2), // key: 1wpnh2
  ]);

  /// `banknote-arrow-down.mjs`
  static const LucideGlyph banknoteArrowDown = LucideGlyph(
    'banknote-arrow-down',
    <IconElement>[
      IconPathElement(
        'M12 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5',
      ), // key: x6cv4u
      IconPathElement('m16 19 3 3 3-3'), // key: 1ibux0
      IconPathElement('M18 12h.01'), // key: yjnet6
      IconPathElement('M19 16v6'), // key: tddt3s
      IconPathElement('M6 12h.01'), // key: c2rlol
      IconCircleElement(12, 12, 2), // key: 1c9p78
    ],
  );

  /// `banknote-arrow-up.mjs`
  static const LucideGlyph banknoteArrowUp = LucideGlyph(
    'banknote-arrow-up',
    <IconElement>[
      IconPathElement(
        'M12 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5',
      ), // key: x6cv4u
      IconPathElement('M18 12h.01'), // key: yjnet6
      IconPathElement('M19 22v-6'), // key: qhmiwi
      IconPathElement('m22 19-3-3-3 3'), // key: rn6bg2
      IconPathElement('M6 12h.01'), // key: c2rlol
      IconCircleElement(12, 12, 2), // key: 1c9p78
    ],
  );

  /// `banknote-check.mjs`
  static const LucideGlyph banknoteCheck = LucideGlyph(
    'banknote-check',
    <IconElement>[
      IconPathElement(
        'M11.748 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v4.875',
      ), // key: t4e5a5
      IconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
      IconPathElement('M18 12h.01'), // key: yjnet6
      IconPathElement('M6 12h.01'), // key: c2rlol
      IconCircleElement(12, 12, 2), // key: 1c9p78
    ],
  );

  /// `banknote-x.mjs`
  static const LucideGlyph banknoteX = LucideGlyph('banknote-x', <IconElement>[
    IconPathElement(
      'M13 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5',
    ), // key: 16nib6
    IconPathElement('m17 17 5 5'), // key: p7ous7
    IconPathElement('M18 12h.01'), // key: yjnet6
    IconPathElement('m22 17-5 5'), // key: gqnmv0
    IconPathElement('M6 12h.01'), // key: c2rlol
    IconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `banknote.mjs`
  static const LucideGlyph banknote = LucideGlyph('banknote', <IconElement>[
    IconRectElement(2, 6, 20, 12, 2), // key: 9lu3g6
    IconCircleElement(12, 12, 2), // key: 1c9p78
    IconPathElement('M6 12h.01M18 12h.01'), // key: 113zkx
  ]);

  /// `barcode.mjs`
  static const LucideGlyph barcode = LucideGlyph('barcode', <IconElement>[
    IconPathElement('M3 5v14'), // key: 1nt18q
    IconPathElement('M8 5v14'), // key: 1ybrkv
    IconPathElement('M12 5v14'), // key: s699le
    IconPathElement('M17 5v14'), // key: ycjyhj
    IconPathElement('M21 5v14'), // key: nzette
  ]);

  /// `barrel.mjs`
  static const LucideGlyph barrel = LucideGlyph('barrel', <IconElement>[
    IconPathElement('M10 3a41 41 0 000 18'), // key: 1f9k6x
    IconPathElement('M14 3a41 41 0 010 18'), // key: 1qo28r
    IconPathElement(
      'M16.997 21a2 2 0 001.68-.92 15.25 15.25 0 000-16.16 2 2 0 00-1.68-.92h-10a2 2 0 00-1.681.92 15.25 15.25 0 000 16.16 2 2 0 001.681.92z',
    ), // key: 1nrwe5
    IconPathElement('M3.54 16h16.914'), // key: jntgtt
    IconPathElement('M3.54 8h16.914'), // key: 14pf7i
  ]);

  /// `baseline.mjs`
  static const LucideGlyph baseline = LucideGlyph('baseline', <IconElement>[
    IconPathElement('M4 20h16'), // key: 14thso
    IconPathElement('m6 16 6-12 6 12'), // key: 1b4byz
    IconPathElement('M8 12h8'), // key: 1wcyev
  ]);

  /// `bath.mjs`
  static const LucideGlyph bath = LucideGlyph('bath', <IconElement>[
    IconPathElement('M10 4 8 6'), // key: 1rru8s
    IconPathElement('M17 19v2'), // key: ts1sot
    IconPathElement('M2 12h20'), // key: 9i4pu4
    IconPathElement('M7 19v2'), // key: 12npes
    IconPathElement(
      'M9 5 7.621 3.621A2.121 2.121 0 0 0 4 5v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-5',
    ), // key: 14ym8i
  ]);

  /// `battery-charging.mjs`
  static const LucideGlyph batteryCharging = LucideGlyph(
    'battery-charging',
    <IconElement>[
      IconPathElement('m11 7-3 5h4l-3 5'), // key: b4a64w
      IconPathElement(
        'M14.856 6H16a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-2.935',
      ), // key: lre1cr
      IconPathElement('M22 14v-4'), // key: 14q9d5
      IconPathElement(
        'M5.14 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h2.936',
      ), // key: 13q5k0
    ],
  );

  /// `battery-full.mjs`
  static const LucideGlyph batteryFull = LucideGlyph(
    'battery-full',
    <IconElement>[
      IconPathElement('M10 10v4'), // key: 1mb2ec
      IconPathElement('M14 10v4'), // key: 1nt88p
      IconPathElement('M22 14v-4'), // key: 14q9d5
      IconPathElement('M6 10v4'), // key: 1n77qd
      IconRectElement(2, 6, 16, 12, 2), // key: 13zb55
    ],
  );

  /// `battery-low.mjs`
  static const LucideGlyph batteryLow = LucideGlyph(
    'battery-low',
    <IconElement>[
      IconPathElement('M22 14v-4'), // key: 14q9d5
      IconPathElement('M6 14v-4'), // key: 14a6bd
      IconRectElement(2, 6, 16, 12, 2), // key: 13zb55
    ],
  );

  /// `battery-medium.mjs`
  static const LucideGlyph batteryMedium = LucideGlyph(
    'battery-medium',
    <IconElement>[
      IconPathElement('M10 14v-4'), // key: suye4c
      IconPathElement('M22 14v-4'), // key: 14q9d5
      IconPathElement('M6 14v-4'), // key: 14a6bd
      IconRectElement(2, 6, 16, 12, 2), // key: 13zb55
    ],
  );

  /// `battery-plus.mjs`
  static const LucideGlyph batteryPlus = LucideGlyph(
    'battery-plus',
    <IconElement>[
      IconPathElement('M10 9v6'), // key: 17i7lo
      IconPathElement(
        'M12.543 6H16a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-3.605',
      ), // key: o09yah
      IconPathElement('M22 14v-4'), // key: 14q9d5
      IconPathElement('M7 12h6'), // key: iekk3h
      IconPathElement(
        'M7.606 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h3.606',
      ), // key: xyqvf1
    ],
  );

  /// `battery-warning.mjs`
  static const LucideGlyph
  batteryWarning = LucideGlyph('battery-warning', <IconElement>[
    IconPathElement('M10 17h.01'), // key: nbq80n
    IconPathElement('M10 7v6'), // key: nne03l
    IconPathElement('M14 6h2a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-2'), // key: 1m83kb
    IconPathElement('M22 14v-4'), // key: 14q9d5
    IconPathElement('M6 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h2'), // key: h8lgfh
  ]);

  /// `battery.mjs`
  static const LucideGlyph battery = LucideGlyph('battery', <IconElement>[
    IconPathElement('M 22 14 L 22 10'), // key: nqc4tb
    IconRectElement(2, 6, 16, 12, 2), // key: 13zb55
  ]);

  /// `beaker.mjs`
  static const LucideGlyph beaker = LucideGlyph('beaker', <IconElement>[
    IconPathElement('M4.5 3h15'), // key: c7n0jr
    IconPathElement('M6 3v16a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V3'), // key: m1uhx7
    IconPathElement('M6 14h12'), // key: 4cwo0f
  ]);

  /// `bean-off.mjs`
  static const LucideGlyph beanOff = LucideGlyph('bean-off', <IconElement>[
    IconPathElement(
      'M9 9c-.64.64-1.521.954-2.402 1.165A6 6 0 0 0 8 22a13.96 13.96 0 0 0 9.9-4.1',
    ), // key: bq3udt
    IconPathElement(
      'M10.75 5.093A6 6 0 0 1 22 8c0 2.411-.61 4.68-1.683 6.66',
    ), // key: 17ccse
    IconPathElement(
      'M5.341 10.62a4 4 0 0 0 6.487 1.208M10.62 5.341a4.015 4.015 0 0 1 2.039 2.04',
    ), // key: 18zqgq
    IconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `bean.mjs`
  static const LucideGlyph bean = LucideGlyph('bean', <IconElement>[
    IconPathElement(
      'M10.165 6.598C9.954 7.478 9.64 8.36 9 9c-.64.64-1.521.954-2.402 1.165A6 6 0 0 0 8 22c7.732 0 14-6.268 14-14a6 6 0 0 0-11.835-1.402Z',
    ), // key: 1tvzk7
    IconPathElement('M5.341 10.62a4 4 0 1 0 5.279-5.28'), // key: 2cyri2
  ]);

  /// `bed-double.mjs`
  static const LucideGlyph bedDouble = LucideGlyph('bed-double', <IconElement>[
    IconPathElement('M2 20v-8a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v8'), // key: 1k78r4
    IconPathElement('M4 10V6a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v4'), // key: fb3tl2
    IconPathElement('M12 4v6'), // key: 1dcgq2
    IconPathElement('M2 18h20'), // key: ajqnye
  ]);

  /// `bed-single.mjs`
  static const LucideGlyph bedSingle = LucideGlyph('bed-single', <IconElement>[
    IconPathElement('M3 20v-8a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v8'), // key: 1wm6mi
    IconPathElement('M5 10V6a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v4'), // key: 4k93s5
    IconPathElement('M3 18h18'), // key: 1h113x
  ]);

  /// `bed.mjs`
  static const LucideGlyph bed = LucideGlyph('bed', <IconElement>[
    IconPathElement('M2 4v16'), // key: vw9hq8
    IconPathElement('M2 8h18a2 2 0 0 1 2 2v10'), // key: 1dgv2r
    IconPathElement('M2 17h20'), // key: 18nfp3
    IconPathElement('M6 8v9'), // key: 1yriud
  ]);

  /// `beef-off.mjs`
  static const LucideGlyph beefOff = LucideGlyph('beef-off', <IconElement>[
    IconPathElement('M11.771 6.109a2.5 2.5 0 0 1 3.12 3.12'), // key: 3w1grc
    IconPathElement('M17.852 12.185a6.5 6.5 0 0 0-9.035-9.04'), // key: 1xgl7b
    IconPathElement(
      'M18.013 18.013C15.029 20.349 10.831 22 7 22a3 3 0 0 1-2.68-1.66L2.4 16.5',
    ), // key: 3m3yc0
    IconPathElement(
      'm18.5 6 2.19 4.5a6.48 6.48 0 0 1-.139 4.393',
    ), // key: 1rvkn7
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement(
      'M6.355 6.37a7 7 0 0 0-.075.23c-1.1 3.13-.78 3.9-3.18 6.08A3 3 0 0 0 5 18c3.356 0 6.993-1.267 9.85-3.151',
    ), // key: 54713r
  ]);

  /// `beef.mjs`
  static const LucideGlyph beef = LucideGlyph('beef', <IconElement>[
    IconPathElement(
      'M16.4 13.7A6.5 6.5 0 1 0 6.28 6.6c-1.1 3.13-.78 3.9-3.18 6.08A3 3 0 0 0 5 18c4 0 8.4-1.8 11.4-4.3',
    ), // key: cisjcv
    IconPathElement(
      'm18.5 6 2.19 4.5a6.48 6.48 0 0 1-2.29 7.2C15.4 20.2 11 22 7 22a3 3 0 0 1-2.68-1.66L2.4 16.5',
    ), // key: 5byaag
    IconCircleElement(12.5, 8.5, 2.5), // key: 9738u8
  ]);

  /// `beer-off.mjs`
  static const LucideGlyph beerOff = LucideGlyph('beer-off', <IconElement>[
    IconPathElement('M13 13v5'), // key: igwfh0
    IconPathElement('M17 11.47V8'), // key: 16yw0g
    IconPathElement('M17 11h1a3 3 0 0 1 2.745 4.211'), // key: 1xbt65
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement('M5 8v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2v-3'), // key: c55o3e
    IconPathElement(
      'M7.536 7.535C6.766 7.649 6.154 8 5.5 8a2.5 2.5 0 0 1-1.768-4.268',
    ), // key: 1ydug7
    IconPathElement(
      'M8.727 3.204C9.306 2.767 9.885 2 11 2c1.56 0 2 1.5 3 1.5s1.72-.5 2.5-.5a1 1 0 1 1 0 5c-.78 0-1.5-.5-2.5-.5a3.149 3.149 0 0 0-.842.12',
    ), // key: q81o7q
    IconPathElement('M9 14.6V18'), // key: 20ek98
  ]);

  /// `beer.mjs`
  static const LucideGlyph beer = LucideGlyph('beer', <IconElement>[
    IconPathElement('M17 11h1a3 3 0 0 1 0 6h-1'), // key: 1yp76v
    IconPathElement('M9 12v6'), // key: 1u1cab
    IconPathElement('M13 12v6'), // key: 1sugkk
    IconPathElement(
      'M14 7.5c-1 0-1.44.5-3 .5s-2-.5-3-.5-1.72.5-2.5.5a2.5 2.5 0 0 1 0-5c.78 0 1.57.5 2.5.5S9.44 2 11 2s2 1.5 3 1.5 1.72-.5 2.5-.5a2.5 2.5 0 0 1 0 5c-.78 0-1.5-.5-2.5-.5Z',
    ), // key: 1510fo
    IconPathElement('M5 8v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V8'), // key: 19jb7n
  ]);

  /// `bell-check.mjs`
  static const LucideGlyph bellCheck = LucideGlyph('bell-check', <IconElement>[
    IconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    IconPathElement('m15 8 2 2 4-4'), // key: sbrgsm
    IconPathElement(
      'M16.8607 4.4824A6 6 0 0 0 6 8C6 12.499 4.589 13.956 3.262 15.326',
    ), // key: qcog4a
    IconPathElement(
      'M3.262 15.326A1 1 0 0 0 4 17H20A1 1 0 0 0 20.74 15.327C20.209 14.779 19.665 14.218 19.203 13.454',
    ), // key: mxnnoh
  ]);

  /// `bell-dot.mjs`
  static const LucideGlyph bellDot = LucideGlyph('bell-dot', <IconElement>[
    IconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    IconPathElement(
      'M11.68 2.009A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673c-.824-.85-1.678-1.731-2.21-3.348',
    ), // key: xaq59h
    IconCircleElement(18, 5, 3), // key: gq8acd
  ]);

  /// `bell-electric.mjs`
  static const LucideGlyph bellElectric = LucideGlyph(
    'bell-electric',
    <IconElement>[
      IconPathElement('M18.518 17.347A7 7 0 0 1 14 19'), // key: 1emhpo
      IconPathElement('M18.8 4A11 11 0 0 1 20 9'), // key: 127b67
      IconPathElement('M9 9h.01'), // key: 1q5me6
      IconCircleElement(20, 16, 2), // key: 1v9bxh
      IconCircleElement(9, 9, 7), // key: p2h5vp
      IconRectElement(4, 16, 10, 6, 2), // key: bfnviv
    ],
  );

  /// `bell-minus.mjs`
  static const LucideGlyph bellMinus = LucideGlyph('bell-minus', <IconElement>[
    IconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    IconPathElement('M15 8h6'), // key: 8ybuxh
    IconPathElement(
      'M16.243 3.757A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673A9.4 9.4 0 0 1 18.667 12',
    ), // key: bdwj86
  ]);

  /// `bell-off.mjs`
  static const LucideGlyph bellOff = LucideGlyph('bell-off', <IconElement>[
    IconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    IconPathElement(
      'M17 17H4a1 1 0 0 1-.74-1.673C4.59 13.956 6 12.499 6 8a6 6 0 0 1 .258-1.742',
    ), // key: 178tsu
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement(
      'M8.668 3.01A6 6 0 0 1 18 8c0 2.687.77 4.653 1.707 6.05',
    ), // key: 1hqiys
  ]);

  /// `bell-plus.mjs`
  static const LucideGlyph bellPlus = LucideGlyph('bell-plus', <IconElement>[
    IconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    IconPathElement('M15 8h6'), // key: 8ybuxh
    IconPathElement('M18 5v6'), // key: g5ayrv
    IconPathElement(
      'M20.002 14.464a9 9 0 0 0 .738.863A1 1 0 0 1 20 17H4a1 1 0 0 1-.74-1.673C4.59 13.956 6 12.499 6 8a6 6 0 0 1 8.75-5.332',
    ), // key: 1abcvy
  ]);

  /// `bell-ring.mjs`
  static const LucideGlyph bellRing = LucideGlyph('bell-ring', <IconElement>[
    IconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    IconPathElement('M22 8c0-2.3-.8-4.3-2-6'), // key: 5bb3ad
    IconPathElement(
      'M3.262 15.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673C19.41 13.956 18 12.499 18 8A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326',
    ), // key: 11g9vi
    IconPathElement('M4 2C2.8 3.7 2 5.7 2 8'), // key: tap9e0
  ]);

  /// `bell.mjs`
  static const LucideGlyph bell = LucideGlyph('bell', <IconElement>[
    IconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    IconPathElement(
      'M3.262 15.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673C19.41 13.956 18 12.499 18 8A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326',
    ), // key: 11g9vi
  ]);

  /// `between-horizontal-end.mjs`
  static const LucideGlyph betweenHorizontalEnd = LucideGlyph(
    'between-horizontal-end',
    <IconElement>[
      IconRectElement(3, 3, 13, 7, 1), // key: 11xb64
      IconPathElement('m22 15-3-3 3-3'), // key: 26chmm
      IconRectElement(3, 14, 13, 7, 1), // key: k6ky7n
    ],
  );

  /// `between-horizontal-start.mjs`
  static const LucideGlyph betweenHorizontalStart = LucideGlyph(
    'between-horizontal-start',
    <IconElement>[
      IconRectElement(8, 3, 13, 7, 1), // key: pkso9a
      IconPathElement('m2 9 3 3-3 3'), // key: 1agib5
      IconRectElement(8, 14, 13, 7, 1), // key: 1q5fc1
    ],
  );

  /// `between-vertical-end.mjs`
  static const LucideGlyph betweenVerticalEnd = LucideGlyph(
    'between-vertical-end',
    <IconElement>[
      IconRectElement(3, 3, 7, 13, 1), // key: 1fdu0f
      IconPathElement('m9 22 3-3 3 3'), // key: 17z65a
      IconRectElement(14, 3, 7, 13, 1), // key: 1squn4
    ],
  );

  /// `between-vertical-start.mjs`
  static const LucideGlyph betweenVerticalStart = LucideGlyph(
    'between-vertical-start',
    <IconElement>[
      IconRectElement(3, 8, 7, 13, 1), // key: 1fjrkv
      IconPathElement('m15 2-3 3-3-3'), // key: 1uh6eb
      IconRectElement(14, 8, 7, 13, 1), // key: w3fjg8
    ],
  );

  /// `biceps-flexed.mjs`
  static const LucideGlyph
  bicepsFlexed = LucideGlyph('biceps-flexed', <IconElement>[
    IconPathElement(
      'M12.409 13.017A5 5 0 0 1 22 15c0 3.866-4 7-9 7-4.077 0-8.153-.82-10.371-2.462-.426-.316-.631-.832-.62-1.362C2.118 12.723 2.627 2 10 2a3 3 0 0 1 3 3 2 2 0 0 1-2 2c-1.105 0-1.64-.444-2-1',
    ), // key: 1pmlyh
    IconPathElement('M15 14a5 5 0 0 0-7.584 2'), // key: 5rb254
    IconPathElement('M9.964 6.825C8.019 7.977 9.5 13 8 15'), // key: kbvsx9
  ]);

  /// `bike.mjs`
  static const LucideGlyph bike = LucideGlyph('bike', <IconElement>[
    IconCircleElement(18.5, 17.5, 3.5), // key: 15x4ox
    IconCircleElement(5.5, 17.5, 3.5), // key: 1noe27
    IconCircleElement(15, 5, 1), // key: 19l28e
    IconPathElement('M12 17.5V14l-3-3 4-3 2 3h2'), // key: 1npguv
  ]);

  /// `binary.mjs`
  static const LucideGlyph binary = LucideGlyph('binary', <IconElement>[
    IconRectElement(14, 14, 4, 6, 2), // key: p02svl
    IconRectElement(6, 4, 4, 6, 2), // key: xm4xkj
    IconPathElement('M6 20h4'), // key: 1i6q5t
    IconPathElement('M14 10h4'), // key: ru81e7
    IconPathElement('M6 14h2v6'), // key: 16z9wg
    IconPathElement('M14 4h2v6'), // key: 1idq9u
  ]);

  /// `binoculars.mjs`
  static const LucideGlyph binoculars = LucideGlyph('binoculars', <IconElement>[
    IconPathElement('M10 10h4'), // key: tcdvrf
    IconPathElement('M19 7V4a1 1 0 0 0-1-1h-2a1 1 0 0 0-1 1v3'), // key: 3apit1
    IconPathElement(
      'M20 21a2 2 0 0 0 2-2v-3.851c0-1.39-2-2.962-2-4.829V8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v11a2 2 0 0 0 2 2z',
    ), // key: rhpgnw
    IconPathElement('M 22 16 L 2 16'), // key: 14lkq7
    IconPathElement(
      'M4 21a2 2 0 0 1-2-2v-3.851c0-1.39 2-2.962 2-4.829V8a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v11a2 2 0 0 1-2 2z',
    ), // key: 104b3k
    IconPathElement('M9 7V4a1 1 0 0 0-1-1H6a1 1 0 0 0-1 1v3'), // key: 14fczp
  ]);

  /// `biohazard.mjs`
  static const LucideGlyph biohazard = LucideGlyph('biohazard', <IconElement>[
    IconCircleElement(12, 11.9, 2), // key: e8h31w
    IconPathElement(
      'M6.7 3.4c-.9 2.5 0 5.2 2.2 6.7C6.5 9 3.7 9.6 2 11.6',
    ), // key: 17bolr
    IconPathElement('m8.9 10.1 1.4.8'), // key: 15ezny
    IconPathElement(
      'M17.3 3.4c.9 2.5 0 5.2-2.2 6.7 2.4-1.2 5.2-.6 6.9 1.5',
    ), // key: wtwa5u
    IconPathElement('m15.1 10.1-1.4.8'), // key: 1r0b28
    IconPathElement(
      'M16.7 20.8c-2.6-.4-4.6-2.6-4.7-5.3-.2 2.6-2.1 4.8-4.7 5.2',
    ), // key: m7qszh
    IconPathElement('M12 13.9v1.6'), // key: zfyyim
    IconPathElement('M13.5 5.4c-1-.2-2-.2-3 0'), // key: 1bi9q0
    IconPathElement('M17 16.4c.7-.7 1.2-1.6 1.5-2.5'), // key: 1rhjqw
    IconPathElement('M5.5 13.9c.3.9.8 1.8 1.5 2.5'), // key: 8gsud3
  ]);

  /// `bird.mjs`
  static const LucideGlyph bird = LucideGlyph('bird', <IconElement>[
    IconPathElement('M16 7h.01'), // key: 1kdx03
    IconPathElement(
      'M3.4 18H12a8 8 0 0 0 8-8V7a4 4 0 0 0-7.28-2.3L2 20',
    ), // key: oj1oa8
    IconPathElement('m20 7 2 .5-2 .5'), // key: 12nv4d
    IconPathElement('M10 18v3'), // key: 1yea0a
    IconPathElement('M14 17.75V21'), // key: 1pymcb
    IconPathElement('M7 18a6 6 0 0 0 3.84-10.61'), // key: 1npnn0
  ]);

  /// `birdhouse.mjs`
  static const LucideGlyph birdhouse = LucideGlyph('birdhouse', <IconElement>[
    IconPathElement('M12 18v4'), // key: jadmvz
    IconPathElement('m17 18 1.956-11.468'), // key: l5n2ro
    IconPathElement('m3 8 7.82-5.615a2 2 0 0 1 2.36 0L21 8'), // key: 1sy6n7
    IconPathElement('M4 18h16'), // key: 19g7jn
    IconPathElement('M7 18 5.044 6.532'), // key: 1uqdf2
    IconCircleElement(12, 10, 2), // key: 1yojzk
  ]);

  /// `bitcoin.mjs`
  static const LucideGlyph bitcoin = LucideGlyph('bitcoin', <IconElement>[
    IconPathElement(
      'M11.767 19.089c4.924.868 6.14-6.025 1.216-6.894m-1.216 6.894L5.86 18.047m5.908 1.042-.347 1.97m1.563-8.864c4.924.869 6.14-6.025 1.215-6.893m-1.215 6.893-3.94-.694m5.155-6.2L8.29 4.26m5.908 1.042.348-1.97M7.48 20.364l3.126-17.727',
    ), // key: yr8idg
  ]);

  /// `blend.mjs`
  static const LucideGlyph blend = LucideGlyph('blend', <IconElement>[
    IconCircleElement(9, 9, 7), // key: p2h5vp
    IconCircleElement(15, 15, 7), // key: 19ennj
  ]);

  /// `blender.mjs`
  static const LucideGlyph blender = LucideGlyph('blender', <IconElement>[
    IconPathElement(
      'M8 14a2 2 0 0 0-1.963 1.615l-1.018 5.193A1 1 0 0 0 6 22h12a1 1 0 0 0 .981-1.192l-1.018-5.193A2 2 0 0 0 16 14z',
    ), // key: 11zxmj
    IconPathElement('m17 2-1 12'), // key: nxm2fw
    IconPathElement('M8.006 14 7 2'), // key: 13bxiv
    IconPathElement(
      'M7.565 8.787A5 5 0 0 0 12 8a5 5 0 0 1 4.56-.75',
    ), // key: 1s61ad
    IconPathElement(
      'M19 2H5a2 2 0 0 0-2 2v5a2 2 0 0 0 .688 1.5',
    ), // key: gel3rg
    IconPathElement('M12 18h.01'), // key: mhygvu
  ]);

  /// `blinds.mjs`
  static const LucideGlyph blinds = LucideGlyph('blinds', <IconElement>[
    IconPathElement('M3 3h18'), // key: o7r712
    IconPathElement('M20 7H8'), // key: gd2fo2
    IconPathElement('M20 11H8'), // key: 1ynp89
    IconPathElement('M10 19h10'), // key: 19hjk5
    IconPathElement('M8 15h12'), // key: 1yqzne
    IconPathElement('M4 3v14'), // key: fggqzn
    IconCircleElement(4, 19, 2), // key: p3m9r0
  ]);

  /// `blocks.mjs`
  static const LucideGlyph blocks = LucideGlyph('blocks', <IconElement>[
    IconPathElement(
      'M10 22V7a1 1 0 0 0-1-1H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-5a1 1 0 0 0-1-1H2',
    ), // key: 1ah6g2
    IconRectElement(14, 2, 8, 8, 1), // key: 88lufb
  ]);

  /// `bluetooth-connected.mjs`
  static const LucideGlyph bluetoothConnected = LucideGlyph(
    'bluetooth-connected',
    <IconElement>[
      IconPathElement('m7 7 10 10-5 5V2l5 5L7 17'), // key: 1q5490
      IconLineElement(18, 12, 21, 12), // key: 1rsjjs
      IconLineElement(3, 12, 6, 12), // key: 11yl8c
    ],
  );

  /// `bluetooth-off.mjs`
  static const LucideGlyph bluetoothOff = LucideGlyph(
    'bluetooth-off',
    <IconElement>[
      IconPathElement('m17 17-5 5V12l-5 5'), // key: v5aci6
      IconPathElement('m2 2 20 20'), // key: 1ooewy
      IconPathElement('M14.5 9.5 17 7l-5-5v4.5'), // key: 1kddfz
    ],
  );

  /// `bluetooth-searching.mjs`
  static const LucideGlyph bluetoothSearching = LucideGlyph(
    'bluetooth-searching',
    <IconElement>[
      IconPathElement('m7 7 10 10-5 5V2l5 5L7 17'), // key: 1q5490
      IconPathElement('M20.83 14.83a4 4 0 0 0 0-5.66'), // key: k8tn1j
      IconPathElement('M18 12h.01'), // key: yjnet6
    ],
  );

  /// `bluetooth.mjs`
  static const LucideGlyph bluetooth = LucideGlyph('bluetooth', <IconElement>[
    IconPathElement('m7 7 10 10-5 5V2l5 5L7 17'), // key: 1q5490
  ]);

  /// `bold.mjs`
  static const LucideGlyph bold = LucideGlyph('bold', <IconElement>[
    IconPathElement(
      'M6 12h9a4 4 0 0 1 0 8H7a1 1 0 0 1-1-1V5a1 1 0 0 1 1-1h7a4 4 0 0 1 0 8',
    ), // key: mg9rjx
  ]);

  /// `bolt.mjs`
  static const LucideGlyph bolt = LucideGlyph('bolt', <IconElement>[
    IconPathElement(
      'M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z',
    ), // key: yt0hxn
    IconCircleElement(12, 12, 4), // key: 4exip2
  ]);

  /// `bomb.mjs`
  static const LucideGlyph bomb = LucideGlyph('bomb', <IconElement>[
    IconCircleElement(11, 13, 9), // key: hd149
    IconPathElement(
      'M14.35 4.65 16.3 2.7a2.41 2.41 0 0 1 3.4 0l1.6 1.6a2.4 2.4 0 0 1 0 3.4l-1.95 1.95',
    ), // key: jp4j1b
    IconPathElement('m22 2-1.5 1.5'), // key: ay92ug
  ]);

  /// `bone-fracture.mjs`
  static const LucideGlyph
  boneFracture = LucideGlyph('bone-fracture', <IconElement>[
    IconPathElement(
      'M14 4.5a1 1 0 0 1 5 0 .5.5 0 0 0 .5.5 1 1 0 0 1 0 5c-.81 0-1.8-.7-2.5 0l-1.958 1.957a.15.15 0 0 1-.252-.072l-.493-2.07a.15.15 0 0 0-.111-.112l-2.072-.494a.15.15 0 0 1-.072-.252L14 7c.7-.7 0-1.69 0-2.5',
    ), // key: 1c7o5b
    IconPathElement('m16 20-1-2'), // key: 5348lt
    IconPathElement('m20 16-2-1'), // key: 2c7pv5
    IconPathElement('m4 8 2 1'), // key: rpj1x4
    IconPathElement('m8 4 1 2'), // key: 1r4zbp
    IconPathElement(
      'M9.698 14.19a.15.15 0 0 0 .112.112l2.074.489a.15.15 0 0 1 .072.252L10 17c-.7.7 0 1.69 0 2.5a1 1 0 0 1-5 0 .495.495 0 0 0-.5-.5 1 1 0 0 1 0-5c.81 0 1.8.7 2.5 0l1.956-1.957a.15.15 0 0 1 .252.072z',
    ), // key: 3u61yx
  ]);

  /// `bone.mjs`
  static const LucideGlyph bone = LucideGlyph('bone', <IconElement>[
    IconPathElement(
      'M17 10c.7-.7 1.69 0 2.5 0a2.5 2.5 0 1 0 0-5 .5.5 0 0 1-.5-.5 2.5 2.5 0 1 0-5 0c0 .81.7 1.8 0 2.5l-7 7c-.7.7-1.69 0-2.5 0a2.5 2.5 0 0 0 0 5c.28 0 .5.22.5.5a2.5 2.5 0 1 0 5 0c0-.81-.7-1.8 0-2.5Z',
    ), // key: w610uw
  ]);

  /// `book-a.mjs`
  static const LucideGlyph bookA = LucideGlyph('book-a', <IconElement>[
    IconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    IconPathElement('m8 13 4-7 4 7'), // key: 4rari8
    IconPathElement('M9.1 11h5.7'), // key: 1gkovt
  ]);

  /// `book-alert.mjs`
  static const LucideGlyph bookAlert = LucideGlyph('book-alert', <IconElement>[
    IconPathElement('M12 13h.01'), // key: y0uutt
    IconPathElement('M12 6v3'), // key: 1m4b9j
    IconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
  ]);

  /// `book-audio.mjs`
  static const LucideGlyph bookAudio = LucideGlyph('book-audio', <IconElement>[
    IconPathElement('M12 6v7'), // key: 1f6ttz
    IconPathElement('M16 8v3'), // key: gejaml
    IconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    IconPathElement('M8 8v3'), // key: 1qzp49
  ]);

  /// `book-check.mjs`
  static const LucideGlyph bookCheck = LucideGlyph('book-check', <IconElement>[
    IconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    IconPathElement('m9 9.5 2 2 4-4'), // key: 1dth82
  ]);

  /// `book-copy.mjs`
  static const LucideGlyph bookCopy = LucideGlyph('book-copy', <IconElement>[
    IconPathElement('M5 7a2 2 0 0 0-2 2v11'), // key: 1yhqjt
    IconPathElement(
      'M5.803 18H5a2 2 0 0 0 0 4h9.5a.5.5 0 0 0 .5-.5V21',
    ), // key: edzzo5
    IconPathElement(
      'M9 15V4a2 2 0 0 1 2-2h9.5a.5.5 0 0 1 .5.5v14a.5.5 0 0 1-.5.5H11a2 2 0 0 1 0-4h10',
    ), // key: 1nwzrg
  ]);

  /// `book-dashed.mjs`
  static const LucideGlyph bookDashed = LucideGlyph(
    'book-dashed',
    <IconElement>[
      IconPathElement('M12 17h1.5'), // key: 1gkc67
      IconPathElement('M12 22h1.5'), // key: 1my7sn
      IconPathElement('M12 2h1.5'), // key: 19tvb7
      IconPathElement('M17.5 22H19a1 1 0 0 0 1-1'), // key: 10akbh
      IconPathElement('M17.5 2H19a1 1 0 0 1 1 1v1.5'), // key: 1vrfjs
      IconPathElement('M20 14v3h-2.5'), // key: 1naeju
      IconPathElement('M20 8.5V10'), // key: 1ctpfu
      IconPathElement('M4 10V8.5'), // key: 1o3zg5
      IconPathElement('M4 19.5V14'), // key: ob81pf
      IconPathElement('M4 4.5A2.5 2.5 0 0 1 6.5 2H8'), // key: s8vcyb
      IconPathElement('M8 22H6.5a1 1 0 0 1 0-5H8'), // key: 1cu73q
    ],
  );

  /// `book-down.mjs`
  static const LucideGlyph bookDown = LucideGlyph('book-down', <IconElement>[
    IconPathElement('M12 13V7'), // key: h0r20n
    IconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    IconPathElement('m9 10 3 3 3-3'), // key: zt5b4y
  ]);

  /// `book-headphones.mjs`
  static const LucideGlyph
  bookHeadphones = LucideGlyph('book-headphones', <IconElement>[
    IconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    IconPathElement('M8 12v-2a4 4 0 0 1 8 0v2'), // key: 1vsqkj
    IconCircleElement(15, 12, 1), // key: 1tmaij
    IconCircleElement(9, 12, 1), // key: 1vctgf
  ]);

  /// `book-heart.mjs`
  static const LucideGlyph bookHeart = LucideGlyph('book-heart', <IconElement>[
    IconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    IconPathElement(
      'M8.62 9.8A2.25 2.25 0 1 1 12 6.836a2.25 2.25 0 1 1 3.38 2.966l-2.626 2.856a.998.998 0 0 1-1.507 0z',
    ), // key: 9v40y5
  ]);

  /// `book-image.mjs`
  static const LucideGlyph bookImage = LucideGlyph('book-image', <IconElement>[
    IconPathElement('m20 13.7-2.1-2.1a2 2 0 0 0-2.8 0L9.7 17'), // key: q6ojf0
    IconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    IconCircleElement(10, 8, 2), // key: 2qkj4p
  ]);

  /// `book-key.mjs`
  static const LucideGlyph bookKey = LucideGlyph('book-key', <IconElement>[
    IconPathElement('M13 2H6.5A2.5 2.5 0 0 0 4 4.5v15'), // key: 4azifu
    IconPathElement('M17 2v6'), // key: qgmh37
    IconPathElement('M17 4h2'), // key: 13vrzo
    IconPathElement(
      'M20 15.2V21a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: 192hzx
    IconCircleElement(17, 10, 2), // key: y0i25j
  ]);

  /// `book-lock.mjs`
  static const LucideGlyph bookLock = LucideGlyph('book-lock', <IconElement>[
    IconPathElement('M18 6V4a2 2 0 1 0-4 0v2'), // key: 1aquzs
    IconPathElement(
      'M20 15v6a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: 1rkj32
    IconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H10'), // key: 18wgow
    IconRectElement(12, 6, 8, 5, 1), // key: 73l30o
  ]);

  /// `book-marked.mjs`
  static const LucideGlyph
  bookMarked = LucideGlyph('book-marked', <IconElement>[
    IconPathElement('M10 2v8l3-3 3 3V2'), // key: sqw3rj
    IconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
  ]);

  /// `book-minus.mjs`
  static const LucideGlyph bookMinus = LucideGlyph('book-minus', <IconElement>[
    IconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    IconPathElement('M9 10h6'), // key: 9gxzsh
  ]);

  /// `book-open-check.mjs`
  static const LucideGlyph
  bookOpenCheck = LucideGlyph('book-open-check', <IconElement>[
    IconPathElement('M12 5v16'), // key: 1f6ucr
    IconPathElement('m16 12 2 2 4-4'), // key: mdajum
    IconPathElement(
      'M22 6V5a2 2 0 00-1.999-2L16 3.002A5 5 0 0012 5a5 5 0 00-4-2H4a2 2 0 00-2 2v12a2 2 0 001.999 2H8a5 5 0 014 2 5 5 0 014-2h4.001A2 2 0 0022 17v-1.344',
    ), // key: 144kbk
  ]);

  /// `book-open-text.mjs`
  static const LucideGlyph
  bookOpenText = LucideGlyph('book-open-text', <IconElement>[
    IconPathElement('M12 5v16'), // key: 1f6ucr
    IconPathElement('M16 13h2'), // key: weia3s
    IconPathElement('M16 9h2'), // key: 1n7gjm
    IconPathElement(
      'M20.001 19A2 2 0 0022 17V5a2 2 0 00-1.999-2L16 3.002A5 5 0 0012 5a5 5 0 00-4-2H4a2 2 0 00-2 2v12a2 2 0 001.999 2H8a5 5 0 014 2 5 5 0 014-2z',
    ), // key: 1fyvmf
    IconPathElement('M6 13h2'), // key: 1cckiz
    IconPathElement('M6 9h2'), // key: 1k7j9f
  ]);

  /// `book-open.mjs`
  static const LucideGlyph bookOpen = LucideGlyph('book-open', <IconElement>[
    IconPathElement('M12 5v16'), // key: 1f6ucr
    IconPathElement(
      'M20.001 19A2 2 0 0022 17V5a2 2 0 00-1.999-2L16 3.002A5 5 0 0012 5a5 5 0 00-4-2H4a2 2 0 00-2 2v12a2 2 0 001.999 2H8a5 5 0 014 2 5 5 0 014-2z',
    ), // key: 1fyvmf
  ]);

  /// `book-plus.mjs`
  static const LucideGlyph bookPlus = LucideGlyph('book-plus', <IconElement>[
    IconPathElement('M12 7v6'), // key: lw1j43
    IconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    IconPathElement('M9 10h6'), // key: 9gxzsh
  ]);

  /// `book-search.mjs`
  static const LucideGlyph bookSearch = LucideGlyph(
    'book-search',
    <IconElement>[
      IconPathElement('M11 22H5.5a1 1 0 0 1 0-5h4.501'), // key: mcbepb
      IconPathElement('m21 22-1.879-1.878'), // key: 12q7x1
      IconPathElement(
        'M3 19.5v-15A2.5 2.5 0 0 1 5.5 2H18a1 1 0 0 1 1 1v8',
      ), // key: olfd5n
      IconCircleElement(17, 18, 3), // key: 82mm0e
    ],
  );

  /// `book-text.mjs`
  static const LucideGlyph bookText = LucideGlyph('book-text', <IconElement>[
    IconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    IconPathElement('M8 11h8'), // key: vwpz6n
    IconPathElement('M8 7h6'), // key: 1f0q6e
  ]);

  /// `book-type.mjs`
  static const LucideGlyph bookType = LucideGlyph('book-type', <IconElement>[
    IconPathElement('M10 13h4'), // key: ytezjc
    IconPathElement('M12 6v7'), // key: 1f6ttz
    IconPathElement('M16 8V6H8v2'), // key: x8j6u4
    IconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
  ]);

  /// `book-up-2.mjs`
  static const LucideGlyph bookUp2 = LucideGlyph('book-up-2', <IconElement>[
    IconPathElement('M12 13V7'), // key: h0r20n
    IconPathElement(
      'M18 2h1a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: 161d7n
    IconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2'), // key: 1lorq7
    IconPathElement('m9 10 3-3 3 3'), // key: 11gsxs
    IconPathElement('m9 5 3-3 3 3'), // key: l8vdw6
  ]);

  /// `book-up.mjs`
  static const LucideGlyph bookUp = LucideGlyph('book-up', <IconElement>[
    IconPathElement('M12 13V7'), // key: h0r20n
    IconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    IconPathElement('m9 10 3-3 3 3'), // key: 11gsxs
  ]);

  /// `book-user.mjs`
  static const LucideGlyph bookUser = LucideGlyph('book-user', <IconElement>[
    IconPathElement('M15 13a3 3 0 1 0-6 0'), // key: 10j68g
    IconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    IconCircleElement(12, 8, 2), // key: 1822b1
  ]);

  /// `book-x.mjs`
  static const LucideGlyph bookX = LucideGlyph('book-x', <IconElement>[
    IconPathElement('m14.5 7-5 5'), // key: dy991v
    IconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    IconPathElement('m9.5 7 5 5'), // key: s45iea
  ]);

  /// `book.mjs`
  static const LucideGlyph book = LucideGlyph('book', <IconElement>[
    IconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
  ]);

  /// `bookmark-check.mjs`
  static const LucideGlyph
  bookmarkCheck = LucideGlyph('bookmark-check', <IconElement>[
    IconPathElement(
      'M17 3a2 2 0 0 1 2 2v15a1 1 0 0 1-1.496.868l-4.512-2.578a2 2 0 0 0-1.984 0l-4.512 2.578A1 1 0 0 1 5 20V5a2 2 0 0 1 2-2z',
    ), // key: oz39mx
    IconPathElement('m9 10 2 2 4-4'), // key: 1gnqz4
  ]);

  /// `bookmark-minus.mjs`
  static const LucideGlyph
  bookmarkMinus = LucideGlyph('bookmark-minus', <IconElement>[
    IconPathElement('M15 10H9'), // key: o6yqo3
    IconPathElement(
      'M17 3a2 2 0 0 1 2 2v15a1 1 0 0 1-1.496.868l-4.512-2.578a2 2 0 0 0-1.984 0l-4.512 2.578A1 1 0 0 1 5 20V5a2 2 0 0 1 2-2z',
    ), // key: oz39mx
  ]);

  /// `bookmark-off.mjs`
  static const LucideGlyph
  bookmarkOff = LucideGlyph('bookmark-off', <IconElement>[
    IconPathElement(
      'M19 19v1a1 1 0 0 1-1.496.868l-4.512-2.578a2 2 0 0 0-1.984 0l-4.512 2.578A1 1 0 0 1 5 20V5',
    ), // key: nigmce
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement('M8.656 3H17a2 2 0 0 1 2 2v8.344'), // key: hlvsa
  ]);

  /// `bookmark-plus.mjs`
  static const LucideGlyph
  bookmarkPlus = LucideGlyph('bookmark-plus', <IconElement>[
    IconPathElement('M12 7v6'), // key: lw1j43
    IconPathElement('M15 10H9'), // key: o6yqo3
    IconPathElement(
      'M17 3a2 2 0 0 1 2 2v15a1 1 0 0 1-1.496.868l-4.512-2.578a2 2 0 0 0-1.984 0l-4.512 2.578A1 1 0 0 1 5 20V5a2 2 0 0 1 2-2z',
    ), // key: oz39mx
  ]);

  /// `bookmark-x.mjs`
  static const LucideGlyph bookmarkX = LucideGlyph('bookmark-x', <IconElement>[
    IconPathElement('m14.5 7.5-5 5'), // key: 3lb6iw
    IconPathElement(
      'M17 3a2 2 0 0 1 2 2v15a1 1 0 0 1-1.496.868l-4.512-2.578a2 2 0 0 0-1.984 0l-4.512 2.578A1 1 0 0 1 5 20V5a2 2 0 0 1 2-2z',
    ), // key: oz39mx
    IconPathElement('m9.5 7.5 5 5'), // key: ko136h
  ]);

  /// `bookmark.mjs`
  static const LucideGlyph bookmark = LucideGlyph('bookmark', <IconElement>[
    IconPathElement(
      'M17 3a2 2 0 0 1 2 2v15a1 1 0 0 1-1.496.868l-4.512-2.578a2 2 0 0 0-1.984 0l-4.512 2.578A1 1 0 0 1 5 20V5a2 2 0 0 1 2-2z',
    ), // key: oz39mx
  ]);

  /// `boom-box.mjs`
  static const LucideGlyph boomBox = LucideGlyph('boom-box', <IconElement>[
    IconPathElement('M4 9V5a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v4'), // key: vvzvr1
    IconPathElement('M8 8v1'), // key: xcqmfk
    IconPathElement('M12 8v1'), // key: 1rj8u4
    IconPathElement('M16 8v1'), // key: 1q12zr
    IconRectElement(2, 9, 20, 12, 2), // key: igpb89
    IconCircleElement(8, 15, 2), // key: fa4a8s
    IconCircleElement(16, 15, 2), // key: 14c3ya
  ]);

  /// `bot-message-square.mjs`
  static const LucideGlyph
  botMessageSquare = LucideGlyph('bot-message-square', <IconElement>[
    IconPathElement('M12 6V2H8'), // key: 1155em
    IconPathElement('M15 11v2'), // key: i11awn
    IconPathElement('M2 12h2'), // key: 1t8f8n
    IconPathElement('M20 12h2'), // key: 1q8mjw
    IconPathElement(
      'M20 16a2 2 0 0 1-2 2H8.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 4 20.286V8a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2z',
    ), // key: 11gyqh
    IconPathElement('M9 11v2'), // key: 1ueba0
  ]);

  /// `bot-off.mjs`
  static const LucideGlyph botOff = LucideGlyph('bot-off', <IconElement>[
    IconPathElement('M13.67 8H18a2 2 0 0 1 2 2v4.33'), // key: 7az073
    IconPathElement('M2 14h2'), // key: vft8re
    IconPathElement('M20 14h2'), // key: 4cs60a
    IconPathElement('M22 22 2 2'), // key: 1r8tn9
    IconPathElement(
      'M8 8H6a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h12a2 2 0 0 0 1.414-.586',
    ), // key: s09a7a
    IconPathElement('M9 13v2'), // key: rq6x2g
    IconPathElement('M9.67 4H12v2.33'), // key: 110xot
  ]);

  /// `bot.mjs`
  static const LucideGlyph bot = LucideGlyph('bot', <IconElement>[
    IconPathElement('M12 8V4H8'), // key: hb8ula
    IconRectElement(4, 8, 16, 12, 2), // key: enze0r
    IconPathElement('M2 14h2'), // key: vft8re
    IconPathElement('M20 14h2'), // key: 4cs60a
    IconPathElement('M15 13v2'), // key: 1xurst
    IconPathElement('M9 13v2'), // key: rq6x2g
  ]);

  /// `bottle-wine.mjs`
  static const LucideGlyph
  bottleWine = LucideGlyph('bottle-wine', <IconElement>[
    IconPathElement(
      'M10 3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v2a6 6 0 0 0 1.2 3.6l.6.8A6 6 0 0 1 17 13v8a1 1 0 0 1-1 1H8a1 1 0 0 1-1-1v-8a6 6 0 0 1 1.2-3.6l.6-.8A6 6 0 0 0 10 5z',
    ), // key: blqgoc
    IconPathElement('M17 13h-4a1 1 0 0 0-1 1v3a1 1 0 0 0 1 1h4'), // key: 43jbee
  ]);

  /// `bow-arrow.mjs`
  static const LucideGlyph bowArrow = LucideGlyph('bow-arrow', <IconElement>[
    IconPathElement('M17 3h4v4'), // key: 19p9u1
    IconPathElement(
      'M18.575 11.082a13 13 0 0 1 1.048 9.027 1.17 1.17 0 0 1-1.914.597L14 17',
    ), // key: 12t3w9
    IconPathElement(
      'M7 10 3.29 6.29a1.17 1.17 0 0 1 .6-1.91 13 13 0 0 1 9.03 1.05',
    ), // key: ogng5l
    IconPathElement(
      'M7 14a1.7 1.7 0 0 0-1.207.5l-2.646 2.646A.5.5 0 0 0 3.5 18H5a1 1 0 0 1 1 1v1.5a.5.5 0 0 0 .854.354L9.5 18.207A1.7 1.7 0 0 0 10 17v-2a1 1 0 0 0-1-1z',
    ), // key: 8v3fy2
    IconPathElement('M9.707 14.293 21 3'), // key: ydm3bn
  ]);

  /// `box.mjs`
  static const LucideGlyph box = LucideGlyph('box', <IconElement>[
    IconPathElement(
      'M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z',
    ), // key: hh9hay
    IconPathElement('m3.3 7 8.7 5 8.7-5'), // key: g66t2b
    IconPathElement('M12 22V12'), // key: d0xqtd
  ]);

  /// `boxes.mjs`
  static const LucideGlyph boxes = LucideGlyph('boxes', <IconElement>[
    IconPathElement(
      'M2.97 12.92A2 2 0 0 0 2 14.63v3.24a2 2 0 0 0 .97 1.71l3 1.8a2 2 0 0 0 2.06 0L12 19v-5.5l-5-3-4.03 2.42Z',
    ), // key: lc1i9w
    IconPathElement('m7 16.5-4.74-2.85'), // key: 1o9zyk
    IconPathElement('m7 16.5 5-3'), // key: va8pkn
    IconPathElement('M7 16.5v5.17'), // key: jnp8gn
    IconPathElement(
      'M12 13.5V19l3.97 2.38a2 2 0 0 0 2.06 0l3-1.8a2 2 0 0 0 .97-1.71v-3.24a2 2 0 0 0-.97-1.71L17 10.5l-5 3Z',
    ), // key: 8zsnat
    IconPathElement('m17 16.5-5-3'), // key: 8arw3v
    IconPathElement('m17 16.5 4.74-2.85'), // key: 8rfmw
    IconPathElement('M17 16.5v5.17'), // key: k6z78m
    IconPathElement(
      'M7.97 4.42A2 2 0 0 0 7 6.13v4.37l5 3 5-3V6.13a2 2 0 0 0-.97-1.71l-3-1.8a2 2 0 0 0-2.06 0l-3 1.8Z',
    ), // key: 1xygjf
    IconPathElement('M12 8 7.26 5.15'), // key: 1vbdud
    IconPathElement('m12 8 4.74-2.85'), // key: 3rx089
    IconPathElement('M12 13.5V8'), // key: 1io7kd
  ]);

  /// `braces.mjs`
  static const LucideGlyph braces = LucideGlyph('braces', <IconElement>[
    IconPathElement(
      'M8 3H7a2 2 0 0 0-2 2v5a2 2 0 0 1-2 2 2 2 0 0 1 2 2v5c0 1.1.9 2 2 2h1',
    ), // key: ezmyqa
    IconPathElement(
      'M16 21h1a2 2 0 0 0 2-2v-5c0-1.1.9-2 2-2a2 2 0 0 1-2-2V5a2 2 0 0 0-2-2h-1',
    ), // key: e1hn23
  ]);

  /// `brackets.mjs`
  static const LucideGlyph brackets = LucideGlyph('brackets', <IconElement>[
    IconPathElement('M16 3h3a1 1 0 0 1 1 1v16a1 1 0 0 1-1 1h-3'), // key: 1kt8lf
    IconPathElement('M8 21H5a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h3'), // key: gduv9
  ]);

  /// `brain-circuit.mjs`
  static const LucideGlyph
  brainCircuit = LucideGlyph('brain-circuit', <IconElement>[
    IconPathElement(
      'M12 5a3 3 0 1 0-5.997.125 4 4 0 0 0-2.526 5.77 4 4 0 0 0 .556 6.588A4 4 0 1 0 12 18Z',
    ), // key: l5xja
    IconPathElement('M9 13a4.5 4.5 0 0 0 3-4'), // key: 10igwf
    IconPathElement('M6.003 5.125A3 3 0 0 0 6.401 6.5'), // key: 105sqy
    IconPathElement('M3.477 10.896a4 4 0 0 1 .585-.396'), // key: ql3yin
    IconPathElement('M6 18a4 4 0 0 1-1.967-.516'), // key: 2e4loj
    IconPathElement('M12 13h4'), // key: 1ku699
    IconPathElement('M12 18h6a2 2 0 0 1 2 2v1'), // key: 105ag5
    IconPathElement('M12 8h8'), // key: 1lhi5i
    IconPathElement('M16 8V5a2 2 0 0 1 2-2'), // key: u6izg6
    IconCircleElement(16, 13, 0.5), // key: ry7gng
    IconCircleElement(18, 3, 0.5), // key: 1aiba7
    IconCircleElement(20, 21, 0.5), // key: yhc1fs
    IconCircleElement(20, 8, 0.5), // key: 1e43v0
  ]);

  /// `brain-cog.mjs`
  static const LucideGlyph brainCog = LucideGlyph('brain-cog', <IconElement>[
    IconPathElement('m10.852 14.772-.383.923'), // key: 11vil6
    IconPathElement('m10.852 9.228-.383-.923'), // key: 1fjppe
    IconPathElement('m13.148 14.772.382.924'), // key: je3va1
    IconPathElement('m13.531 8.305-.383.923'), // key: 18epck
    IconPathElement('m14.772 10.852.923-.383'), // key: k9m8cz
    IconPathElement('m14.772 13.148.923.383'), // key: 1xvhww
    IconPathElement(
      'M17.598 6.5A3 3 0 1 0 12 5a3 3 0 0 0-5.63-1.446 3 3 0 0 0-.368 1.571 4 4 0 0 0-2.525 5.771',
    ), // key: jcbbz1
    IconPathElement('M17.998 5.125a4 4 0 0 1 2.525 5.771'), // key: 1kkn7e
    IconPathElement('M19.505 10.294a4 4 0 0 1-1.5 7.706'), // key: 18bmuc
    IconPathElement(
      'M4.032 17.483A4 4 0 0 0 11.464 20c.18-.311.892-.311 1.072 0a4 4 0 0 0 7.432-2.516',
    ), // key: uozx0d
    IconPathElement('M4.5 10.291A4 4 0 0 0 6 18'), // key: whdemb
    IconPathElement('M6.002 5.125a3 3 0 0 0 .4 1.375'), // key: 1kqy2g
    IconPathElement('m9.228 10.852-.923-.383'), // key: 1wtb30
    IconPathElement('m9.228 13.148-.923.383'), // key: 1a830x
    IconCircleElement(12, 12, 3), // key: 1v7zrd
  ]);

  /// `brain.mjs`
  static const LucideGlyph brain = LucideGlyph('brain', <IconElement>[
    IconPathElement('M12 18V5'), // key: adv99a
    IconPathElement(
      'M15 13a4.17 4.17 0 0 1-3-4 4.17 4.17 0 0 1-3 4',
    ), // key: 1e3is1
    IconPathElement(
      'M17.598 6.5A3 3 0 1 0 12 5a3 3 0 1 0-5.598 1.5',
    ), // key: 1gqd8o
    IconPathElement('M17.997 5.125a4 4 0 0 1 2.526 5.77'), // key: iwvgf7
    IconPathElement('M18 18a4 4 0 0 0 2-7.464'), // key: efp6ie
    IconPathElement(
      'M19.967 17.483A4 4 0 1 1 12 18a4 4 0 1 1-7.967-.517',
    ), // key: 1gq6am
    IconPathElement('M6 18a4 4 0 0 1-2-7.464'), // key: k1g0md
    IconPathElement('M6.003 5.125a4 4 0 0 0-2.526 5.77'), // key: q97ue3
  ]);

  /// `brick-wall-fire.mjs`
  static const LucideGlyph
  brickWallFire = LucideGlyph('brick-wall-fire', <IconElement>[
    IconPathElement('M16 3v2.107'), // key: gq8xun
    IconPathElement(
      'M17 9c1 3 2.5 3.5 3.5 4.5A5 5 0 0 1 22 17a5 5 0 0 1-10 0c0-.3 0-.6.1-.9a2 2 0 1 0 3.3-2C13 11.5 16 9 17 9',
    ), // key: 1l2pih
    IconPathElement(
      'M21 8.274V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h3.938',
    ), // key: jrnqjp
    IconPathElement('M3 15h5.253'), // key: xqg7rb
    IconPathElement('M3 9h8.228'), // key: 1ppb70
    IconPathElement('M8 15v6'), // key: 1stoo3
    IconPathElement('M8 3v6'), // key: vlvjmk
  ]);

  /// `brick-wall-shield.mjs`
  static const LucideGlyph
  brickWallShield = LucideGlyph('brick-wall-shield', <IconElement>[
    IconPathElement('M12 9v1.258'), // key: iwpddn
    IconPathElement('M16 3v5.46'), // key: d7ew98
    IconPathElement(
      'M21 9.118V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h5.75',
    ), // key: 137t5x
    IconPathElement(
      'M22 17.5c0 2.499-1.75 3.749-3.83 4.474a.5.5 0 0 1-.335-.005c-2.085-.72-3.835-1.97-3.835-4.47V14a.5.5 0 0 1 .5-.499c1 0 2.25-.6 3.12-1.36a.6.6 0 0 1 .76-.001c.875.765 2.12 1.36 3.12 1.36a.5.5 0 0 1 .5.5z',
    ), // key: 16j3tf
    IconPathElement('M3 15h7'), // key: 1qldh6
    IconPathElement('M3 9h12.142'), // key: 1yjd6m
    IconPathElement('M8 15v6'), // key: 1stoo3
    IconPathElement('M8 3v6'), // key: vlvjmk
  ]);

  /// `brick-wall.mjs`
  static const LucideGlyph brickWall = LucideGlyph('brick-wall', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    IconPathElement('M12 9v6'), // key: 199k2o
    IconPathElement('M16 15v6'), // key: 8rj2es
    IconPathElement('M16 3v6'), // key: 1j6rpj
    IconPathElement('M3 15h18'), // key: 5xshup
    IconPathElement('M3 9h18'), // key: 1pudct
    IconPathElement('M8 15v6'), // key: 1stoo3
    IconPathElement('M8 3v6'), // key: vlvjmk
  ]);

  /// `briefcase-business.mjs`
  static const LucideGlyph
  briefcaseBusiness = LucideGlyph('briefcase-business', <IconElement>[
    IconPathElement('M12 12h.01'), // key: 1mp3jc
    IconPathElement('M16 6V4a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2'), // key: 1ksdt3
    IconPathElement('M22 13a18.15 18.15 0 0 1-20 0'), // key: 12hx5q
    IconRectElement(2, 6, 20, 14, 2), // key: i6l2r4
  ]);

  /// `briefcase-conveyor-belt.mjs`
  static const LucideGlyph
  briefcaseConveyorBelt = LucideGlyph('briefcase-conveyor-belt', <IconElement>[
    IconPathElement('M10 20v2'), // key: 1n8e1g
    IconPathElement('M14 20v2'), // key: 1lq872
    IconPathElement('M18 20v2'), // key: 10uadw
    IconPathElement('M21 20H3'), // key: kdqkdp
    IconPathElement('M6 20v2'), // key: a9bc87
    IconPathElement('M8 16V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v12'), // key: 17n9tx
    IconRectElement(4, 6, 16, 10, 2), // key: 1097i5
  ]);

  /// `briefcase-medical.mjs`
  static const LucideGlyph
  briefcaseMedical = LucideGlyph('briefcase-medical', <IconElement>[
    IconPathElement('M12 11v4'), // key: a6ujw6
    IconPathElement('M14 13h-4'), // key: 1pl8zg
    IconPathElement('M16 6V4a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2'), // key: 1ksdt3
    IconPathElement('M18 6v14'), // key: 1mu4gy
    IconPathElement('M6 6v14'), // key: 1s15cj
    IconRectElement(2, 6, 20, 14, 2), // key: i6l2r4
  ]);

  /// `briefcase.mjs`
  static const LucideGlyph briefcase = LucideGlyph('briefcase', <IconElement>[
    IconPathElement('M16 20V4a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16'), // key: jecpp
    IconRectElement(2, 6, 20, 14, 2), // key: i6l2r4
  ]);

  /// `bring-to-front.mjs`
  static const LucideGlyph bringToFront = LucideGlyph(
    'bring-to-front',
    <IconElement>[
      IconRectElement(8, 8, 8, 8, 2), // key: yj20xf
      IconPathElement(
        'M4 10a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2',
      ), // key: 1ltk23
      IconPathElement(
        'M14 20a2 2 0 0 0 2 2h4a2 2 0 0 0 2-2v-4a2 2 0 0 0-2-2',
      ), // key: 1q24h9
    ],
  );

  /// `broccoli.mjs`
  static const LucideGlyph broccoli = LucideGlyph('broccoli', <IconElement>[
    IconPathElement('M10 13a3 3 0 0 1-2.121-5.121'), // key: 1oqad0
    IconPathElement(
      'M15.606 14.204c-3.5 1.5-5.899 4.503-8.899 7.503A1 1 0 0 1 6 22c-2 0-4-2-4-4a1 1 0 0 1 .293-.707c1.911-1.911 3.823-3.578 5.347-5.441',
    ), // key: c93qjr
    IconPathElement('M16.573 14.737A4 4 0 0 1 14 11'), // key: 1ymr17
    IconPathElement(
      'M7.14 10.907a4 4 0 1 1 2.756-7.43A4 4 0 0 1 16.7 4.48a2 2 0 0 1 2.82 2.82 4 4 0 0 1 1.002 6.805A4 4 0 1 1 13 16',
    ), // key: 1kbgad
  ]);

  /// `brush-cleaning.mjs`
  static const LucideGlyph
  brushCleaning = LucideGlyph('brush-cleaning', <IconElement>[
    IconPathElement('m16 22-1-4'), // key: 1ow2iv
    IconPathElement(
      'M19 14a1 1 0 0 0 1-1v-1a2 2 0 0 0-2-2h-3a1 1 0 0 1-1-1V4a2 2 0 0 0-4 0v5a1 1 0 0 1-1 1H6a2 2 0 0 0-2 2v1a1 1 0 0 0 1 1',
    ), // key: 11gii7
    IconPathElement(
      'M19 14H5l-1.973 6.767A1 1 0 0 0 4 22h16a1 1 0 0 0 .973-1.233z',
    ), // key: bju7h4
    IconPathElement('m8 22 1-4'), // key: s3unb
  ]);

  /// `brush.mjs`
  static const LucideGlyph brush = LucideGlyph('brush', <IconElement>[
    IconPathElement('m11 10 3 3'), // key: fzmg1i
    IconPathElement(
      'M6.5 21A3.5 3.5 0 1 0 3 17.5a2.62 2.62 0 0 1-.708 1.792A1 1 0 0 0 3 21z',
    ), // key: p4q2r7
    IconPathElement(
      'M9.969 17.031 21.378 5.624a1 1 0 0 0-3.002-3.002L6.967 14.031',
    ), // key: wy6l02
  ]);

  /// `bubbles.mjs`
  static const LucideGlyph bubbles = LucideGlyph('bubbles', <IconElement>[
    IconPathElement('M7.001 15.085A1.5 1.5 0 0 1 9 16.5'), // key: y44lvh
    IconCircleElement(18.5, 8.5, 3.5), // key: 1wadoa
    IconCircleElement(7.5, 16.5, 5.5), // key: 6mdt3g
    IconCircleElement(7.5, 4.5, 2.5), // key: 637s54
  ]);

  /// `bug-off.mjs`
  static const LucideGlyph bugOff = LucideGlyph('bug-off', <IconElement>[
    IconPathElement('M12 20v-8'), // key: i3yub9
    IconPathElement('M12.656 7H14a4 4 0 0 1 4 4v1.344'), // key: vvueyn
    IconPathElement('M14.12 3.88 16 2'), // key: qol33r
    IconPathElement(
      'M17.123 17.123A6 6 0 0 1 6 14v-3a4 4 0 0 1 1.72-3.287',
    ), // key: 1cu21y
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement('M21 5a4 4 0 0 1-3.55 3.97'), // key: 5cxbf6
    IconPathElement('M22 13h-3.344'), // key: qb08am
    IconPathElement('M3 21a4 4 0 0 1 3.81-4'), // key: 1fjd4g
    IconPathElement('M3 5a4 4 0 0 0 3.55 3.97'), // key: 1d7oge
    IconPathElement('M6 13H2'), // key: 82j7cp
    IconPathElement('m8 2 1.88 1.88'), // key: fmnt4t
    IconPathElement('M9.712 4.06A3 3 0 0 1 15 6v1.13'), // key: 1bvup6
  ]);

  /// `bug-play.mjs`
  static const LucideGlyph bugPlay = LucideGlyph('bug-play', <IconElement>[
    IconPathElement(
      'M10 19.655A6 6 0 0 1 6 14v-3a4 4 0 0 1 4-4h4a4 4 0 0 1 4 3.97',
    ), // key: 1gnv52
    IconPathElement(
      'M14 15.003a1 1 0 0 1 1.517-.859l4.997 2.997a1 1 0 0 1 0 1.718l-4.997 2.997a1 1 0 0 1-1.517-.86z',
    ), // key: 1weqy9
    IconPathElement('M14.12 3.88 16 2'), // key: qol33r
    IconPathElement('M21 5a4 4 0 0 1-3.55 3.97'), // key: 5cxbf6
    IconPathElement('M3 21a4 4 0 0 1 3.81-4'), // key: 1fjd4g
    IconPathElement('M3 5a4 4 0 0 0 3.55 3.97'), // key: 1d7oge
    IconPathElement('M6 13H2'), // key: 82j7cp
    IconPathElement('m8 2 1.88 1.88'), // key: fmnt4t
    IconPathElement('M9 7.13V6a3 3 0 1 1 6 0v1.13'), // key: 1vgav8
  ]);

  /// `bug.mjs`
  static const LucideGlyph bug = LucideGlyph('bug', <IconElement>[
    IconPathElement('M12 20v-9'), // key: 1qisl0
    IconPathElement(
      'M14 7a4 4 0 0 1 4 4v3a6 6 0 0 1-12 0v-3a4 4 0 0 1 4-4z',
    ), // key: uouzyp
    IconPathElement('M14.12 3.88 16 2'), // key: qol33r
    IconPathElement('M21 21a4 4 0 0 0-3.81-4'), // key: 1b0z45
    IconPathElement('M21 5a4 4 0 0 1-3.55 3.97'), // key: 5cxbf6
    IconPathElement('M22 13h-4'), // key: 1jl80f
    IconPathElement('M3 21a4 4 0 0 1 3.81-4'), // key: 1fjd4g
    IconPathElement('M3 5a4 4 0 0 0 3.55 3.97'), // key: 1d7oge
    IconPathElement('M6 13H2'), // key: 82j7cp
    IconPathElement('m8 2 1.88 1.88'), // key: fmnt4t
    IconPathElement('M9 7.13V6a3 3 0 1 1 6 0v1.13'), // key: 1vgav8
  ]);

  /// `building-2.mjs`
  static const LucideGlyph building2 = LucideGlyph('building-2', <IconElement>[
    IconPathElement('M10 12h4'), // key: a56b0p
    IconPathElement('M10 8h4'), // key: 1sr2af
    IconPathElement('M14 21v-3a2 2 0 0 0-4 0v3'), // key: 1rgiei
    IconPathElement(
      'M6 10H4a2 2 0 0 0-2 2v7a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-2',
    ), // key: secmi2
    IconPathElement('M6 21V5a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v16'), // key: 16ra0t
  ]);

  /// `building.mjs`
  static const LucideGlyph building = LucideGlyph('building', <IconElement>[
    IconPathElement('M12 10h.01'), // key: 1nrarc
    IconPathElement('M12 14h.01'), // key: 1etili
    IconPathElement('M12 6h.01'), // key: 1vi96p
    IconPathElement('M16 10h.01'), // key: 1m94wz
    IconPathElement('M16 14h.01'), // key: 1gbofw
    IconPathElement('M16 6h.01'), // key: 1x0f13
    IconPathElement('M8 10h.01'), // key: 19clt8
    IconPathElement('M8 14h.01'), // key: 6423bh
    IconPathElement('M8 6h.01'), // key: 1dz90k
    IconPathElement('M9 22v-3a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v3'), // key: cabbwy
    IconRectElement(4, 2, 16, 20, 2), // key: 1uxh74
  ]);

  /// `bus-front.mjs`
  static const LucideGlyph busFront = LucideGlyph('bus-front', <IconElement>[
    IconPathElement('M4 6 2 7'), // key: 1mqr15
    IconPathElement('M10 6h4'), // key: 1itunk
    IconPathElement('m22 7-2-1'), // key: 1umjhc
    IconRectElement(4, 3, 16, 16, 2), // key: 1wxw4b
    IconPathElement('M4 11h16'), // key: mpoxn0
    IconPathElement('M8 15h.01'), // key: a7atzg
    IconPathElement('M16 15h.01'), // key: rnfrdf
    IconPathElement('M6 19v2'), // key: 1loha6
    IconPathElement('M18 21v-2'), // key: sqyl04
  ]);

  /// `bus.mjs`
  static const LucideGlyph bus = LucideGlyph('bus', <IconElement>[
    IconPathElement('M8 6v6'), // key: 18i7km
    IconPathElement('M15 6v6'), // key: 1sg6z9
    IconPathElement('M2 12h19.6'), // key: de5uta
    IconPathElement(
      'M18 18h3s.5-1.7.8-2.8c.1-.4.2-.8.2-1.2 0-.4-.1-.8-.2-1.2l-1.4-5C20.1 6.8 19.1 6 18 6H4a2 2 0 0 0-2 2v10h3',
    ), // key: 1wwztk
    IconCircleElement(7, 18, 2), // key: 19iecd
    IconPathElement('M9 18h5'), // key: lrx6i
    IconCircleElement(16, 18, 2), // key: 1v4tcr
  ]);

  /// `cable-car.mjs`
  static const LucideGlyph cableCar = LucideGlyph('cable-car', <IconElement>[
    IconPathElement('M10 3h.01'), // key: lbucoy
    IconPathElement('M14 2h.01'), // key: 1k8aa1
    IconPathElement('m2 9 20-5'), // key: 1kz0j5
    IconPathElement('M12 12V6.5'), // key: 1vbrij
    IconRectElement(4, 12, 16, 10, 3), // key: if91er
    IconPathElement('M9 12v5'), // key: 3anwtq
    IconPathElement('M15 12v5'), // key: 5xh3zn
    IconPathElement('M4 17h16'), // key: g4d7ey
  ]);

  /// `cable.mjs`
  static const LucideGlyph cable = LucideGlyph('cable', <IconElement>[
    IconPathElement(
      'M17 19a1 1 0 0 1-1-1v-2a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2a1 1 0 0 1-1 1z',
    ), // key: trhst0
    IconPathElement('M17 21v-2'), // key: ds4u3f
    IconPathElement(
      'M19 14V6.5a1 1 0 0 0-7 0v11a1 1 0 0 1-7 0V10',
    ), // key: 1mo9zo
    IconPathElement('M21 21v-2'), // key: eo0ou
    IconPathElement('M3 5V3'), // key: 1k5hjh
    IconPathElement(
      'M4 10a2 2 0 0 1-2-2V6a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2a2 2 0 0 1-2 2z',
    ), // key: 1dd30t
    IconPathElement('M7 5V3'), // key: 1t1388
  ]);

  /// `cake-slice.mjs`
  static const LucideGlyph cakeSlice = LucideGlyph('cake-slice', <IconElement>[
    IconPathElement('M16 13H3'), // key: 1wpj08
    IconPathElement('M16 17H3'), // key: 3lvfcd
    IconPathElement(
      'm7.2 7.9-3.388 2.5A2 2 0 0 0 3 12.01V20a1 1 0 0 0 1 1h16a1 1 0 0 0 1-1v-8.654c0-2-2.44-6.026-6.44-8.026a1 1 0 0 0-1.082.057L10.4 5.6',
    ), // key: 1gmhf7
    IconCircleElement(9, 7, 2), // key: 1305pl
  ]);

  /// `cake.mjs`
  static const LucideGlyph cake = LucideGlyph('cake', <IconElement>[
    IconPathElement('M20 21v-8a2 2 0 0 0-2-2H6a2 2 0 0 0-2 2v8'), // key: 1w3rig
    IconPathElement(
      'M4 16s.5-1 2-1 2.5 2 4 2 2.5-2 4-2 2.5 2 4 2 2-1 2-1',
    ), // key: n2jgmb
    IconPathElement('M2 21h20'), // key: 1nyx9w
    IconPathElement('M7 8v3'), // key: 1qtyvj
    IconPathElement('M12 8v3'), // key: hwp4zt
    IconPathElement('M17 8v3'), // key: 1i6e5u
    IconPathElement('M7 4h.01'), // key: 1bh4kh
    IconPathElement('M12 4h.01'), // key: 1ujb9j
    IconPathElement('M17 4h.01'), // key: 1upcoc
  ]);

  /// `calculator.mjs`
  static const LucideGlyph calculator = LucideGlyph('calculator', <IconElement>[
    IconRectElement(4, 2, 16, 20, 2), // key: 1nb95v
    IconLineElement(8, 6, 16, 6), // key: x4nwl0
    IconLineElement(16, 14, 16, 18), // key: wjye3r
    IconPathElement('M16 10h.01'), // key: 1m94wz
    IconPathElement('M12 10h.01'), // key: 1nrarc
    IconPathElement('M8 10h.01'), // key: 19clt8
    IconPathElement('M12 14h.01'), // key: 1etili
    IconPathElement('M8 14h.01'), // key: 6423bh
    IconPathElement('M12 18h.01'), // key: mhygvu
    IconPathElement('M8 18h.01'), // key: lrp35t
  ]);

  /// `calendar-1.mjs`
  static const LucideGlyph calendar1 = LucideGlyph('calendar-1', <IconElement>[
    IconPathElement('M11 13h1v4'), // key: 10p4bv
    IconPathElement('M16 2v3'), // key: otl347
    IconPathElement('M3 9h18'), // key: 1pudct
    IconPathElement('M8 2v3'), // key: 1ioesn
    IconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `calendar-arrow-down.mjs`
  static const LucideGlyph calendarArrowDown = LucideGlyph(
    'calendar-arrow-down',
    <IconElement>[
      IconPathElement('m14 17 4 4 4-4'), // key: 17qdjf
      IconPathElement('M16 2v3'), // key: otl347
      IconPathElement('M18 13v8'), // key: 1a00n0
      IconPathElement(
        'M21 10.354V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h7.343',
      ), // key: 1qsorh
      IconPathElement('M3 9h18'), // key: 1pudct
      IconPathElement('M8 2v3'), // key: 1ioesn
    ],
  );

  /// `calendar-arrow-up.mjs`
  static const LucideGlyph calendarArrowUp = LucideGlyph(
    'calendar-arrow-up',
    <IconElement>[
      IconPathElement('m14 17 4-4 4 4'), // key: 1qa3u6
      IconPathElement('M16 2v3'), // key: otl347
      IconPathElement('M18 21v-8'), // key: 1ao88k
      IconPathElement(
        'M21 10.343V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h9',
      ), // key: 185mot
      IconPathElement('M3 9h18'), // key: 1pudct
      IconPathElement('M8 2v3'), // key: 1ioesn
    ],
  );

  /// `calendar-check-2.mjs`
  static const LucideGlyph calendarCheck2 = LucideGlyph(
    'calendar-check-2',
    <IconElement>[
      IconPathElement('M 19 3 L 5 3'), // key: 1xn3iy
      IconPathElement('M 21 13 L 21 5'), // key: 102s58
      IconPathElement('M 21 5 A2 2 0 0 0 19 3'), // key: 1xylja
      IconPathElement('M 3 19 A2 2 0 0 0 5 21'), // key: 19jxbv
      IconPathElement('M 3 5 L 3 19'), // key: 1yylhw
      IconPathElement('M 5 3 A2 2 0 0 0 3 5'), // key: 164twa
      IconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
      IconPathElement('M16 2v3'), // key: otl347
      IconPathElement('M3 9h18'), // key: 1pudct
      IconPathElement('M5 21 L12.5 21'), // key: 1n38e0
      IconPathElement('M8 2v3'), // key: 1ioesn
    ],
  );

  /// `calendar-check.mjs`
  static const LucideGlyph calendarCheck = LucideGlyph(
    'calendar-check',
    <IconElement>[
      IconPathElement('M8 2v3'), // key: 1ioesn
      IconPathElement('M16 2v3'), // key: otl347
      IconRectElement(3, 3, 18, 18, 2), // key: h1oib
      IconPathElement('M3 9h18'), // key: 1pudct
      IconPathElement('m9 15 2 2 4-4'), // key: 1grp1n
    ],
  );

  /// `calendar-clock.mjs`
  static const LucideGlyph calendarClock = LucideGlyph(
    'calendar-clock',
    <IconElement>[
      IconPathElement('M16 14v2.2l1.6 1'), // key: fo4ql5
      IconPathElement('M16 2v3'), // key: otl347
      IconPathElement(
        'M21 7.338V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h2.338',
      ), // key: 7hb8p4
      IconPathElement('M3 9h5.859'), // key: numkqi
      IconPathElement('M8 2v3'), // key: 1ioesn
      IconCircleElement(16, 16, 6), // key: qoo3c4
    ],
  );

  /// `calendar-cog.mjs`
  static const LucideGlyph calendarCog = LucideGlyph(
    'calendar-cog',
    <IconElement>[
      IconPathElement('m15.228 16.852-.923-.383'), // key: npixar
      IconPathElement('m15.228 19.148-.923.383'), // key: 51cr3n
      IconPathElement('M16 2v3'), // key: otl347
      IconPathElement('m16.47 14.305.382.923'), // key: obybxd
      IconPathElement('m16.852 20.772-.383.924'), // key: dpfhf9
      IconPathElement('m19.148 15.228.383-.923'), // key: 1reyyz
      IconPathElement('m19.53 21.696-.382-.924'), // key: 1goivc
      IconPathElement('m20.773 16.852.924-.383'), // key: ybmb4k
      IconPathElement('m20.773 19.148.924.383'), // key: 1c2d3p
      IconPathElement(
        'M21 10.5V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h5.5',
      ), // key: 1e6z1y
      IconPathElement('M3 9h18'), // key: 1pudct
      IconPathElement('M8 2v3'), // key: 1ioesn
      IconCircleElement(18, 18, 3), // key: 1xkwt0
    ],
  );

  /// `calendar-days.mjs`
  static const LucideGlyph calendarDays = LucideGlyph(
    'calendar-days',
    <IconElement>[
      IconPathElement('M8 2v3'), // key: 1ioesn
      IconPathElement('M16 2v3'), // key: otl347
      IconRectElement(3, 3, 18, 18, 2), // key: h1oib
      IconPathElement('M3 9h18'), // key: 1pudct
      IconPathElement('M8 13h.01'), // key: 1sbv64
      IconPathElement('M12 13h.01'), // key: y0uutt
      IconPathElement('M16 13h.01'), // key: wip0gl
      IconPathElement('M8 17h.01'), // key: p3bg7i
      IconPathElement('M12 17h.01'), // key: p32p05
      IconPathElement('M16 17h.01'), // key: ql8jdd
    ],
  );

  /// `calendar-fold.mjs`
  static const LucideGlyph
  calendarFold = LucideGlyph('calendar-fold', <IconElement>[
    IconPathElement('M16 2v3'), // key: otl347
    IconPathElement(
      'M21 15V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h10v-5a1 1 0 011-1za2.4 2.4 0 01-.706 1.706l-3.588 3.588A2.4 2.4 0 0115 21',
    ), // key: 4uit17
    IconPathElement('M3 9h18'), // key: 1pudct
    IconPathElement('M8 2v3'), // key: 1ioesn
  ]);

  /// `calendar-heart.mjs`
  static const LucideGlyph
  calendarHeart = LucideGlyph('calendar-heart', <IconElement>[
    IconPathElement(
      'M12.127 21H5a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v5.125',
    ), // key: 1fsxpc
    IconPathElement(
      'M14.62 17.8A2.25 2.25 0 1118 14.836a2.25 2.25 0 113.38 2.966l-2.626 2.856a.998.998 0 01-1.507 0z',
    ), // key: 1gk3ue
    IconPathElement('M16 2v3'), // key: otl347
    IconPathElement('M3 9h18'), // key: 1pudct
    IconPathElement('M8 2v3'), // key: 1ioesn
  ]);

  /// `calendar-minus-2.mjs`
  static const LucideGlyph calendarMinus2 = LucideGlyph(
    'calendar-minus-2',
    <IconElement>[
      IconPathElement('M8 2v3'), // key: 1ioesn
      IconPathElement('M16 2v3'), // key: otl347
      IconRectElement(3, 3, 18, 18, 2), // key: h1oib
      IconPathElement('M3 9h18'), // key: 1pudct
      IconPathElement('M10 15h4'), // key: 192ueg
    ],
  );

  /// `calendar-minus.mjs`
  static const LucideGlyph calendarMinus = LucideGlyph(
    'calendar-minus',
    <IconElement>[
      IconPathElement('M16 18h6'), // key: 987eiv
      IconPathElement('M16 2v3'), // key: otl347
      IconPathElement(
        'M21 14V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h8.3',
      ), // key: gcu0od
      IconPathElement('M3 9h18'), // key: 1pudct
      IconPathElement('M8 2v3'), // key: 1ioesn
    ],
  );

  /// `calendar-off.mjs`
  static const LucideGlyph calendarOff = LucideGlyph(
    'calendar-off',
    <IconElement>[
      IconPathElement('M16 2v3'), // key: otl347
      IconPathElement('m2 2 20 20'), // key: 1ooewy
      IconPathElement('M21 9h-5.5'), // key: 1g344v
      IconPathElement('M3 9h6'), // key: 1q2djq
      IconPathElement(
        'M3.586 3.586A2 2 0 003 5v14a2 2 0 002 2h14a2 2 0 001.414-.586',
      ), // key: 1g7ltu
      IconPathElement('M8.656 3H19a2 2 0 012 2v10.344'), // key: 1bwpd1
    ],
  );

  /// `calendar-plus-2.mjs`
  static const LucideGlyph calendarPlus2 = LucideGlyph(
    'calendar-plus-2',
    <IconElement>[
      IconPathElement('M8 2v3'), // key: 1ioesn
      IconPathElement('M16 2v3'), // key: otl347
      IconRectElement(3, 3, 18, 18, 2), // key: h1oib
      IconPathElement('M3 9h18'), // key: 1pudct
      IconPathElement('M10 15h4'), // key: 192ueg
      IconPathElement('M12 13v4'), // key: 1il4po
    ],
  );

  /// `calendar-plus.mjs`
  static const LucideGlyph calendarPlus = LucideGlyph(
    'calendar-plus',
    <IconElement>[
      IconPathElement('M16 18h6'), // key: 987eiv
      IconPathElement('M16 2v3'), // key: otl347
      IconPathElement('M19 15v6'), // key: 10aioa
      IconPathElement(
        'M21 11.5V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h8.3',
      ), // key: jgwkxf
      IconPathElement('M3 9h18'), // key: 1pudct
      IconPathElement('M8 2v3'), // key: 1ioesn
    ],
  );

  /// `calendar-range.mjs`
  static const LucideGlyph calendarRange = LucideGlyph(
    'calendar-range',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: h1oib
      IconPathElement('M16 2v3'), // key: otl347
      IconPathElement('M3 9h18'), // key: 1pudct
      IconPathElement('M8 2v3'), // key: 1ioesn
      IconPathElement('M17 13h-6'), // key: 1qbiup
      IconPathElement('M13 17H7'), // key: 1x38vv
      IconPathElement('M7 13h.01'), // key: 1vezk1
      IconPathElement('M17 17h.01'), // key: 1sd3ek
    ],
  );

  /// `calendar-search.mjs`
  static const LucideGlyph calendarSearch = LucideGlyph(
    'calendar-search',
    <IconElement>[
      IconPathElement('M16 2v3'), // key: otl347
      IconPathElement(
        'M21 10.69V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h7.25',
      ), // key: h6gkkz
      IconPathElement('m22 21-1.875-1.875'), // key: 1dzjql
      IconPathElement('M3 9h18'), // key: 1pudct
      IconPathElement('M8 2v3'), // key: 1ioesn
      IconCircleElement(18, 17, 3), // key: 1hty4x
    ],
  );

  /// `calendar-sync.mjs`
  static const LucideGlyph calendarSync = LucideGlyph(
    'calendar-sync',
    <IconElement>[
      IconPathElement('M11 10v4h4'), // key: 172dkj
      IconPathElement('m11 14 1.535-1.605a5 5 0 018 1.5'), // key: jekqcd
      IconPathElement('M16 2v3'), // key: otl347
      IconPathElement('m21 18-1.535 1.605a5 5 0 01-8-1.5'), // key: n107hu
      IconPathElement('M21 22v-4h-4'), // key: hrummi
      IconPathElement(
        'M21 8.517V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h3.517',
      ), // key: yafrba
      IconPathElement('M3 9h4'), // key: rnfnj5
      IconPathElement('M8 2v3'), // key: 1ioesn
    ],
  );

  /// `calendar-x-2.mjs`
  static const LucideGlyph calendarX2 = LucideGlyph(
    'calendar-x-2',
    <IconElement>[
      IconPathElement('M16 2v3'), // key: otl347
      IconPathElement('m17 16 5 5'), // key: 1a37d9
      IconPathElement('m17 21 5-5'), // key: 1b797a
      IconPathElement(
        'M21 12V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h8',
      ), // key: 14ws7l
      IconPathElement('M3 9h18'), // key: 1pudct
      IconPathElement('M8 2v3'), // key: 1ioesn
    ],
  );

  /// `calendar-x.mjs`
  static const LucideGlyph calendarX = LucideGlyph('calendar-x', <IconElement>[
    IconPathElement('M8 2v3'), // key: 1ioesn
    IconPathElement('M16 2v3'), // key: otl347
    IconRectElement(3, 3, 18, 18, 2), // key: h1oib
    IconPathElement('M3 9h18'), // key: 1pudct
    IconPathElement('m14 13-4 4'), // key: 1gib57
    IconPathElement('m10 13 4 4'), // key: 153uiq
  ]);

  /// `calendar.mjs`
  static const LucideGlyph calendar = LucideGlyph('calendar', <IconElement>[
    IconPathElement('M8 2v3'), // key: 1ioesn
    IconPathElement('M16 2v3'), // key: otl347
    IconRectElement(3, 3, 18, 18, 2), // key: h1oib
    IconPathElement('M3 9h18'), // key: 1pudct
  ]);

  /// `calendars.mjs`
  static const LucideGlyph calendars = LucideGlyph('calendars', <IconElement>[
    IconPathElement('M12 2v2'), // key: tus03m
    IconPathElement(
      'M15.726 21.01A2 2 0 0 1 14 22H4a2 2 0 0 1-2-2V10a2 2 0 0 1 2-2',
    ), // key: j6srht
    IconPathElement('M18 2v2'), // key: 1kh14s
    IconPathElement('M2 13h2'), // key: 13gyu8
    IconPathElement('M8 8h14'), // key: 12jxz2
    IconRectElement(8, 3, 14, 14, 2), // key: nsru6w
  ]);

  /// `camera-off.mjs`
  static const LucideGlyph cameraOff = LucideGlyph('camera-off', <IconElement>[
    IconPathElement('M14.564 14.558a3 3 0 1 1-4.122-4.121'), // key: 1rnrzw
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement(
      'M20 20H4a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2h1.997a2 2 0 0 0 .819-.175',
    ), // key: 1x3arw
    IconPathElement(
      'M9.695 4.024A2 2 0 0 1 10.004 4h3.993a2 2 0 0 1 1.76 1.05l.486.9A2 2 0 0 0 18.003 7H20a2 2 0 0 1 2 2v7.344',
    ), // key: 1i84u0
  ]);

  /// `camera.mjs`
  static const LucideGlyph camera = LucideGlyph('camera', <IconElement>[
    IconPathElement(
      'M13.997 4a2 2 0 0 1 1.76 1.05l.486.9A2 2 0 0 0 18.003 7H20a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2h1.997a2 2 0 0 0 1.759-1.048l.489-.904A2 2 0 0 1 10.004 4z',
    ), // key: 18u6gg
    IconCircleElement(12, 13, 3), // key: 1vg3eu
  ]);

  /// `candy-cane.mjs`
  static const LucideGlyph candyCane = LucideGlyph('candy-cane', <IconElement>[
    IconPathElement('m10.8 5 2.111 4.223'), // key: 11kb8w
    IconPathElement('M17.75 7 15 2.1'), // key: 12x7e8
    IconPathElement('m4.874 14.647 2.12 4.24'), // key: ccpt4b
    IconPathElement(
      'M5.7 21a2 2 0 0 1-3.5-2l8.6-14a6 6 0 0 1 10.4 6 2 2 0 1 1-3.464-2 2 2 0 1 0-3.464-2z',
    ), // key: u5e8z4
    IconPathElement('m7.906 9.712 2.005 4.411'), // key: 1k0qph
  ]);

  /// `candy-off.mjs`
  static const LucideGlyph candyOff = LucideGlyph('candy-off', <IconElement>[
    IconPathElement('M10 10v7.9'), // key: m8g9tt
    IconPathElement('M11.802 6.145a5 5 0 0 1 6.053 6.053'), // key: dn87i3
    IconPathElement('M14 6.1v2.243'), // key: 1kzysn
    IconPathElement(
      'm15.5 15.571-.964.964a5 5 0 0 1-7.071 0 5 5 0 0 1 0-7.07l.964-.965',
    ), // key: 3sxy18
    IconPathElement(
      'M16 7V3a1 1 0 0 1 1.707-.707 2.5 2.5 0 0 0 2.152.717 1 1 0 0 1 1.131 1.131 2.5 2.5 0 0 0 .717 2.152A1 1 0 0 1 21 8h-4',
    ), // key: gpb6xx
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement(
      'M8 17v4a1 1 0 0 1-1.707.707 2.5 2.5 0 0 0-2.152-.717 1 1 0 0 1-1.131-1.131 2.5 2.5 0 0 0-.717-2.152A1 1 0 0 1 3 16h4',
    ), // key: qexcha
  ]);

  /// `candy.mjs`
  static const LucideGlyph candy = LucideGlyph('candy', <IconElement>[
    IconPathElement('M10 7v10.9'), // key: 1gynux
    IconPathElement('M14 6.1V17'), // key: 116kdf
    IconPathElement(
      'M16 7V3a1 1 0 0 1 1.707-.707 2.5 2.5 0 0 0 2.152.717 1 1 0 0 1 1.131 1.131 2.5 2.5 0 0 0 .717 2.152A1 1 0 0 1 21 8h-4',
    ), // key: gpb6xx
    IconPathElement(
      'M16.536 7.465a5 5 0 0 0-7.072 0l-2 2a5 5 0 0 0 0 7.07 5 5 0 0 0 7.072 0l2-2a5 5 0 0 0 0-7.07',
    ), // key: 1tsln4
    IconPathElement(
      'M8 17v4a1 1 0 0 1-1.707.707 2.5 2.5 0 0 0-2.152-.717 1 1 0 0 1-1.131-1.131 2.5 2.5 0 0 0-.717-2.152A1 1 0 0 1 3 16h4',
    ), // key: qexcha
  ]);

  /// `cannabis-off.mjs`
  static const LucideGlyph
  cannabisOff = LucideGlyph('cannabis-off', <IconElement>[
    IconPathElement(
      'M12 22v-4c1.5 1.5 3.5 3 6 3 0-1.5-.5-3.5-2-5',
    ), // key: 1bqfb7
    IconPathElement(
      'M13.988 8.327C13.902 6.054 13.365 3.82 12 2a9.3 9.3 0 0 0-1.445 2.9',
    ), // key: 1p520n
    IconPathElement(
      'M17.375 11.725C18.882 10.53 21 7.841 21 6c-2.324 0-5.08 1.296-6.662 2.684',
    ), // key: q2itvb
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement(
      'M21.024 15.378A15 15 0 0 0 22 15c-.426-1.279-2.67-2.557-4.25-2.907',
    ), // key: j9amvs
    IconPathElement(
      'M6.995 6.992C5.714 6.4 4.29 6 3 6c0 2 2.5 5 4 6-1.5 0-4.5 1.5-5 3 3.5 1.5 6 1 6 1-1.5 1.5-2 3.5-2 5 2.5 0 4.5-1.5 6-3',
    ), // key: 8gmd5g
  ]);

  /// `cannabis.mjs`
  static const LucideGlyph cannabis = LucideGlyph('cannabis', <IconElement>[
    IconPathElement('M12 22v-4'), // key: 1utk9m
    IconPathElement(
      'M7 12c-1.5 0-4.5 1.5-5 3 3.5 1.5 6 1 6 1-1.5 1.5-2 3.5-2 5 2.5 0 4.5-1.5 6-3 1.5 1.5 3.5 3 6 3 0-1.5-.5-3.5-2-5 0 0 2.5.5 6-1-.5-1.5-3.5-3-5-3 1.5-1 4-4 4-6-2.5 0-5.5 1.5-7 3 0-2.5-.5-5-2-7-1.5 2-2 4.5-2 7-1.5-1.5-4.5-3-7-3 0 2 2.5 5 4 6',
    ), // key: 1mezod
  ]);

  /// `captions-off.mjs`
  static const LucideGlyph captionsOff = LucideGlyph(
    'captions-off',
    <IconElement>[
      IconPathElement('M10.5 5H19a2 2 0 0 1 2 2v8.5'), // key: jqtk4d
      IconPathElement('M17 11h-.5'), // key: 1961ue
      IconPathElement('M19 19H5a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2'), // key: 1keqsi
      IconPathElement('m2 2 20 20'), // key: 1ooewy
      IconPathElement('M7 11h4'), // key: 1o1z6v
      IconPathElement('M7 15h2.5'), // key: 1ina1g
    ],
  );

  /// `captions.mjs`
  static const LucideGlyph captions = LucideGlyph('captions', <IconElement>[
    IconRectElement(3, 5, 18, 14, 2, ry: 2), // key: 12ruh7
    IconPathElement('M7 15h4M15 15h2M7 11h2M13 11h4'), // key: 1ueiar
  ]);

  /// `car-front.mjs`
  static const LucideGlyph carFront = LucideGlyph('car-front', <IconElement>[
    IconPathElement(
      'm21 8-2 2-1.5-3.7A2 2 0 0 0 15.646 5H8.4a2 2 0 0 0-1.903 1.257L5 10 3 8',
    ), // key: 1imjwt
    IconPathElement('M7 14h.01'), // key: 1qa3f1
    IconPathElement('M17 14h.01'), // key: 7oqj8z
    IconRectElement(3, 10, 18, 8, 2), // key: a7itu8
    IconPathElement('M5 18v2'), // key: ppbyun
    IconPathElement('M19 18v2'), // key: gy7782
  ]);

  /// `car-taxi-front.mjs`
  static const LucideGlyph
  carTaxiFront = LucideGlyph('car-taxi-front', <IconElement>[
    IconPathElement('M10 2h4'), // key: n1abiw
    IconPathElement(
      'm21 8-2 2-1.5-3.7A2 2 0 0 0 15.646 5H8.4a2 2 0 0 0-1.903 1.257L5 10 3 8',
    ), // key: 1imjwt
    IconPathElement('M7 14h.01'), // key: 1qa3f1
    IconPathElement('M17 14h.01'), // key: 7oqj8z
    IconRectElement(3, 10, 18, 8, 2), // key: a7itu8
    IconPathElement('M5 18v2'), // key: ppbyun
    IconPathElement('M19 18v2'), // key: gy7782
  ]);

  /// `car.mjs`
  static const LucideGlyph car = LucideGlyph('car', <IconElement>[
    IconPathElement(
      'M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.4 2.9A3.7 3.7 0 0 0 2 12v4c0 .6.4 1 1 1h2',
    ), // key: 5owen
    IconCircleElement(7, 17, 2), // key: u2ysq9
    IconPathElement('M9 17h6'), // key: r8uit2
    IconCircleElement(17, 17, 2), // key: axvx0g
  ]);

  /// `caravan.mjs`
  static const LucideGlyph caravan = LucideGlyph('caravan', <IconElement>[
    IconPathElement(
      'M18 19V9a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v8a2 2 0 0 0 2 2h2',
    ), // key: 19jm3t
    IconPathElement('M2 9h3a1 1 0 0 1 1 1v2a1 1 0 0 1-1 1H2'), // key: 13hakp
    IconPathElement(
      'M22 17v1a1 1 0 0 1-1 1H10v-9a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v9',
    ), // key: 1crci8
    IconCircleElement(8, 19, 2), // key: t8fc5s
  ]);

  /// `card-sim.mjs`
  static const LucideGlyph cardSim = LucideGlyph('card-sim', <IconElement>[
    IconPathElement('M12 14v4'), // key: 1thi36
    IconPathElement(
      'M14.172 2a2 2 0 0 1 1.414.586l3.828 3.828A2 2 0 0 1 20 7.828V20a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2z',
    ), // key: 1o66bk
    IconPathElement('M8 14h8'), // key: 1fgep2
    IconRectElement(8, 10, 8, 8, 1), // key: 1aonk6
  ]);

  /// `carrot.mjs`
  static const LucideGlyph carrot = LucideGlyph('carrot', <IconElement>[
    IconPathElement(
      'M15 16a1 1 0 0 0-7-7q-4 4-5.987 12.385a.5.5 0 0 0 .602.602Q11 20 15 16l-3-3',
    ), // key: 1ta62j
    IconPathElement('M15 9q4 4 7 0-3-4-7 0 4-4 0-7-4 3 0 7'), // key: 1svf7i
    IconPathElement('m8 15-2.58-2.58'), // key: 7t238r
  ]);

  /// `case-lower.mjs`
  static const LucideGlyph caseLower = LucideGlyph('case-lower', <IconElement>[
    IconPathElement('M10 9v7'), // key: ylp826
    IconPathElement('M14 6v10'), // key: 1jy4vg
    IconCircleElement(17.5, 12.5, 3.5), // key: 1a9481
    IconCircleElement(6.5, 12.5, 3.5), // key: 2jlv1r
  ]);

  /// `case-sensitive.mjs`
  static const LucideGlyph
  caseSensitive = LucideGlyph('case-sensitive', <IconElement>[
    IconPathElement('m2 16 4.039-9.69a.5.5 0 0 1 .923 0L11 16'), // key: d5nyq2
    IconPathElement('M22 9v7'), // key: pvm9v3
    IconPathElement('M3.304 13h6.392'), // key: 1q3zxz
    IconCircleElement(18.5, 12.5, 3.5), // key: z97x68
  ]);

  /// `case-upper.mjs`
  static const LucideGlyph caseUpper = LucideGlyph('case-upper', <IconElement>[
    IconPathElement(
      'M15 11h4.5a1 1 0 0 1 0 5h-4a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h3a1 1 0 0 1 0 5',
    ), // key: nxs35
    IconPathElement('m2 16 4.039-9.69a.5.5 0 0 1 .923 0L11 16'), // key: d5nyq2
    IconPathElement('M3.304 13h6.392'), // key: 1q3zxz
  ]);

  /// `cassette-tape.mjs`
  static const LucideGlyph cassetteTape = LucideGlyph(
    'cassette-tape',
    <IconElement>[
      IconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
      IconCircleElement(8, 10, 2), // key: 1xl4ub
      IconPathElement('M8 12h8'), // key: 1wcyev
      IconCircleElement(16, 10, 2), // key: r14t7q
      IconPathElement(
        'm6 20 .7-2.9A1.4 1.4 0 0 1 8.1 16h7.8a1.4 1.4 0 0 1 1.4 1l.7 3',
      ), // key: l01ucn
    ],
  );

  /// `cast.mjs`
  static const LucideGlyph cast = LucideGlyph('cast', <IconElement>[
    IconPathElement(
      'M2 8V6a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2h-6',
    ), // key: 3zrzxg
    IconPathElement('M2 12a9 9 0 0 1 8 8'), // key: g6cvee
    IconPathElement('M2 16a5 5 0 0 1 4 4'), // key: 1y1dii
    IconLineElement(2, 20, 2.01, 20), // key: xu2jvo
  ]);

  /// `castle.mjs`
  static const LucideGlyph castle = LucideGlyph('castle', <IconElement>[
    IconPathElement('M10 5V3'), // key: 1y54qe
    IconPathElement('M14 5V3'), // key: m6isi
    IconPathElement('M15 21v-3a3 3 0 0 0-6 0v3'), // key: lbp5hj
    IconPathElement('M18 3v8'), // key: 2ollhf
    IconPathElement('M18 5H6'), // key: 98imr9
    IconPathElement('M22 11H2'), // key: 1lmjae
    IconPathElement('M22 9v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V9'), // key: 1rly83
    IconPathElement('M6 3v8'), // key: csox7g
  ]);

  /// `cat.mjs`
  static const LucideGlyph cat = LucideGlyph('cat', <IconElement>[
    IconPathElement(
      'M12 5c.67 0 1.35.09 2 .26 1.78-2 5.03-2.84 6.42-2.26 1.4.58-.42 7-.42 7 .57 1.07 1 2.24 1 3.44C21 17.9 16.97 21 12 21s-9-3-9-7.56c0-1.25.5-2.4 1-3.44 0 0-1.89-6.42-.5-7 1.39-.58 4.72.23 6.5 2.23A9.04 9.04 0 0 1 12 5Z',
    ), // key: x6xyqk
    IconPathElement('M8 14v.5'), // key: 1nzgdb
    IconPathElement('M16 14v.5'), // key: 1lajdz
    IconPathElement('M11.25 16.25h1.5L12 17l-.75-.75Z'), // key: 12kq1m
  ]);

  /// `cctv-off.mjs`
  static const LucideGlyph cctvOff = LucideGlyph('cctv-off', <IconElement>[
    IconPathElement(
      'm12.309 6.652 4.797 2.401a1 1 0 0 1 .447 1.341l-.501 1.001.605.605h2.725a1 1 0 0 1 .894 1.447l-.724 1.448',
    ), // key: e75roo
    IconPathElement(
      'm15.166 15.166-.719 1.439a1 1 0 0 1-1.342.447L3.61 12.3a2.92 2.92 0 0 1-1.3-3.91L3.69 5.6a2.9 2.9 0 0 1 .873-1.037',
    ), // key: 1h9o5r
    IconPathElement('M2 19h3.76a2 2 0 0 0 1.8-1.1l1.441-2.902'), // key: 1askrb
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement('M2 21v-4'), // key: l40lih
    IconPathElement('M7 9h.01'), // key: 19b3jx
  ]);

  /// `cctv.mjs`
  static const LucideGlyph cctv = LucideGlyph('cctv', <IconElement>[
    IconPathElement(
      'M16.75 12h3.632a1 1 0 0 1 .894 1.447l-2.034 4.069a1 1 0 0 1-1.708.134l-2.124-2.97',
    ), // key: ir91b5
    IconPathElement(
      'M17.106 9.053a1 1 0 0 1 .447 1.341l-3.106 6.211a1 1 0 0 1-1.342.447L3.61 12.3a2.92 2.92 0 0 1-1.3-3.91L3.69 5.6a2.92 2.92 0 0 1 3.92-1.3z',
    ), // key: jlp8i1
    IconPathElement('M2 19h3.76a2 2 0 0 0 1.8-1.1L9 15'), // key: 19bib8
    IconPathElement('M2 21v-4'), // key: l40lih
    IconPathElement('M7 9h.01'), // key: 19b3jx
  ]);

  /// `chart-area.mjs`
  static const LucideGlyph chartArea = LucideGlyph('chart-area', <IconElement>[
    IconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    IconPathElement(
      'M7 11.207a.5.5 0 0 1 .146-.353l2-2a.5.5 0 0 1 .708 0l3.292 3.292a.5.5 0 0 0 .708 0l4.292-4.292a.5.5 0 0 1 .854.353V16a1 1 0 0 1-1 1H8a1 1 0 0 1-1-1z',
    ), // key: q0gr47
  ]);

  /// `chart-bar-big.mjs`
  static const LucideGlyph chartBarBig = LucideGlyph(
    'chart-bar-big',
    <IconElement>[
      IconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      IconRectElement(7, 13, 9, 4, 1), // key: 1iip1u
      IconRectElement(7, 5, 12, 4, 1), // key: 1anskk
    ],
  );

  /// `chart-bar-decreasing.mjs`
  static const LucideGlyph chartBarDecreasing = LucideGlyph(
    'chart-bar-decreasing',
    <IconElement>[
      IconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      IconPathElement('M7 11h8'), // key: 1feolt
      IconPathElement('M7 16h3'), // key: ur6vzw
      IconPathElement('M7 6h12'), // key: sz5b0d
    ],
  );

  /// `chart-bar-increasing.mjs`
  static const LucideGlyph chartBarIncreasing = LucideGlyph(
    'chart-bar-increasing',
    <IconElement>[
      IconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      IconPathElement('M7 11h8'), // key: 1feolt
      IconPathElement('M7 16h12'), // key: wsnu98
      IconPathElement('M7 6h3'), // key: w9rmul
    ],
  );

  /// `chart-bar-stacked.mjs`
  static const LucideGlyph chartBarStacked = LucideGlyph(
    'chart-bar-stacked',
    <IconElement>[
      IconPathElement('M11 13v4'), // key: vyy2rb
      IconPathElement('M15 5v4'), // key: 1gx88a
      IconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      IconRectElement(7, 13, 9, 4, 1), // key: 1iip1u
      IconRectElement(7, 5, 12, 4, 1), // key: 1anskk
    ],
  );

  /// `chart-bar.mjs`
  static const LucideGlyph chartBar = LucideGlyph('chart-bar', <IconElement>[
    IconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    IconPathElement('M7 16h8'), // key: srdodz
    IconPathElement('M7 11h12'), // key: 127s9w
    IconPathElement('M7 6h3'), // key: w9rmul
  ]);

  /// `chart-candlestick.mjs`
  static const LucideGlyph chartCandlestick = LucideGlyph(
    'chart-candlestick',
    <IconElement>[
      IconPathElement('M9 5v4'), // key: 14uxtq
      IconRectElement(7, 9, 4, 6, 1), // key: f4fvz0
      IconPathElement('M9 15v2'), // key: r5rk32
      IconPathElement('M17 3v2'), // key: 1l2re6
      IconRectElement(15, 5, 4, 8, 1), // key: z38je5
      IconPathElement('M17 13v3'), // key: 5l0wba
      IconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    ],
  );

  /// `chart-column-big.mjs`
  static const LucideGlyph chartColumnBig = LucideGlyph(
    'chart-column-big',
    <IconElement>[
      IconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      IconRectElement(15, 5, 4, 12, 1), // key: q8uenq
      IconRectElement(7, 8, 4, 9, 1), // key: sr5ea
    ],
  );

  /// `chart-column-decreasing.mjs`
  static const LucideGlyph chartColumnDecreasing = LucideGlyph(
    'chart-column-decreasing',
    <IconElement>[
      IconPathElement('M13 17V9'), // key: 1fwyjl
      IconPathElement('M18 17v-3'), // key: 1sqioe
      IconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      IconPathElement('M8 17V5'), // key: 1wzmnc
    ],
  );

  /// `chart-column-increasing.mjs`
  static const LucideGlyph chartColumnIncreasing = LucideGlyph(
    'chart-column-increasing',
    <IconElement>[
      IconPathElement('M13 17V9'), // key: 1fwyjl
      IconPathElement('M18 17V5'), // key: sfb6ij
      IconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      IconPathElement('M8 17v-3'), // key: 17ska0
    ],
  );

  /// `chart-column-stacked.mjs`
  static const LucideGlyph chartColumnStacked = LucideGlyph(
    'chart-column-stacked',
    <IconElement>[
      IconPathElement('M11 13H7'), // key: t0o9gq
      IconPathElement('M19 9h-4'), // key: rera1j
      IconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      IconRectElement(15, 5, 4, 12, 1), // key: q8uenq
      IconRectElement(7, 8, 4, 9, 1), // key: sr5ea
    ],
  );

  /// `chart-column.mjs`
  static const LucideGlyph chartColumn = LucideGlyph(
    'chart-column',
    <IconElement>[
      IconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      IconPathElement('M18 17V9'), // key: 2bz60n
      IconPathElement('M13 17V5'), // key: 1frdt8
      IconPathElement('M8 17v-3'), // key: 17ska0
    ],
  );

  /// `chart-gantt.mjs`
  static const LucideGlyph chartGantt = LucideGlyph(
    'chart-gantt',
    <IconElement>[
      IconPathElement('M10 6h8'), // key: zvc2xc
      IconPathElement('M12 16h6'), // key: yi5mkt
      IconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      IconPathElement('M8 11h7'), // key: wz2hg0
    ],
  );

  /// `chart-line.mjs`
  static const LucideGlyph chartLine = LucideGlyph('chart-line', <IconElement>[
    IconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    IconPathElement('m19 9-5 5-4-4-3 3'), // key: 2osh9i
  ]);

  /// `chart-network.mjs`
  static const LucideGlyph chartNetwork = LucideGlyph(
    'chart-network',
    <IconElement>[
      IconPathElement('m13.11 7.664 1.78 2.672'), // key: go2gg9
      IconPathElement('m14.162 12.788-3.324 1.424'), // key: 11x848
      IconPathElement('m20 4-6.06 1.515'), // key: 1wxxh7
      IconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      IconCircleElement(12, 6, 2), // key: 1jj5th
      IconCircleElement(16, 12, 2), // key: 4ma0v8
      IconCircleElement(9, 15, 2), // key: lf2ghp
    ],
  );

  /// `chart-no-axes-column-decreasing.mjs`
  static const LucideGlyph chartNoAxesColumnDecreasing = LucideGlyph(
    'chart-no-axes-column-decreasing',
    <IconElement>[
      IconPathElement('M5 21V3'), // key: clc1r8
      IconPathElement('M12 21V9'), // key: uvy0l4
      IconPathElement('M19 21v-6'), // key: tkawy9
    ],
  );

  /// `chart-no-axes-column-increasing.mjs`
  static const LucideGlyph chartNoAxesColumnIncreasing = LucideGlyph(
    'chart-no-axes-column-increasing',
    <IconElement>[
      IconPathElement('M5 21v-6'), // key: 1hz6c0
      IconPathElement('M12 21V9'), // key: uvy0l4
      IconPathElement('M19 21V3'), // key: 11j9sm
    ],
  );

  /// `chart-no-axes-column.mjs`
  static const LucideGlyph chartNoAxesColumn = LucideGlyph(
    'chart-no-axes-column',
    <IconElement>[
      IconPathElement('M5 21v-6'), // key: 1hz6c0
      IconPathElement('M12 21V3'), // key: 1lcnhd
      IconPathElement('M19 21V9'), // key: unv183
    ],
  );

  /// `chart-no-axes-combined.mjs`
  static const LucideGlyph
  chartNoAxesCombined = LucideGlyph('chart-no-axes-combined', <IconElement>[
    IconPathElement('M12 16v5'), // key: zza2cw
    IconPathElement('M16 14.639V21'), // key: 1s85h0
    IconPathElement('M20 10.656V21'), // key: q45596
    IconPathElement(
      'm22 3-8.646 8.646a.5.5 0 0 1-.708 0L9.354 8.354a.5.5 0 0 0-.707 0L2 15',
    ), // key: 1fw8x9
    IconPathElement('M4 18.463V21'), // key: 1otddq
    IconPathElement('M8 14.656V21'), // key: 1t2idw
  ]);

  /// `chart-no-axes-gantt.mjs`
  static const LucideGlyph chartNoAxesGantt = LucideGlyph(
    'chart-no-axes-gantt',
    <IconElement>[
      IconPathElement('M6 5h12'), // key: fvfigv
      IconPathElement('M4 12h10'), // key: oujl3d
      IconPathElement('M12 19h8'), // key: baeox8
    ],
  );

  /// `chart-pie.mjs`
  static const LucideGlyph chartPie = LucideGlyph('chart-pie', <IconElement>[
    IconPathElement(
      'M21 12c.552 0 1.005-.449.95-.998a10 10 0 0 0-8.953-8.951c-.55-.055-.998.398-.998.95v8a1 1 0 0 0 1 1z',
    ), // key: pzmjnu
    IconPathElement('M21.21 15.89A10 10 0 1 1 8 2.83'), // key: k2fpak
  ]);

  /// `chart-scatter.mjs`
  static const LucideGlyph chartScatter = LucideGlyph(
    'chart-scatter',
    <IconElement>[
      IconCircleElement(7.5, 7.5, 0.5, filled: true), // key: kqv944
      IconCircleElement(18.5, 5.5, 0.5, filled: true), // key: lysivs
      IconCircleElement(11.5, 11.5, 0.5, filled: true), // key: byv1b8
      IconCircleElement(7.5, 16.5, 0.5, filled: true), // key: nkw3mc
      IconCircleElement(17.5, 14.5, 0.5, filled: true), // key: 1gjh6j
      IconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    ],
  );

  /// `chart-spline.mjs`
  static const LucideGlyph chartSpline = LucideGlyph(
    'chart-spline',
    <IconElement>[
      IconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      IconPathElement(
        'M7 16c.5-2 1.5-7 4-7 2 0 2 3 4 3 2.5 0 4.5-5 5-7',
      ), // key: lw07rv
    ],
  );

  /// `check-check.mjs`
  static const LucideGlyph checkCheck = LucideGlyph(
    'check-check',
    <IconElement>[
      IconPathElement('M18 6 7 17l-5-5'), // key: 116fxf
      IconPathElement('m22 10-7.5 7.5L13 16'), // key: ke71qq
    ],
  );

  /// `check-line.mjs`
  static const LucideGlyph checkLine = LucideGlyph('check-line', <IconElement>[
    IconPathElement('M20 4L9 15'), // key: 1qkx8z
    IconPathElement('M21 19L3 19'), // key: 100sma
    IconPathElement('M9 15L4 10'), // key: 9zxff7
  ]);

  /// `check.mjs`
  static const LucideGlyph check = LucideGlyph('check', <IconElement>[
    IconPathElement('M20 6 9 17l-5-5'), // key: 1gmf2c
  ]);

  /// `chef-hat.mjs`
  static const LucideGlyph chefHat = LucideGlyph('chef-hat', <IconElement>[
    IconPathElement(
      'M17 21a1 1 0 0 0 1-1v-5.35c0-.457.316-.844.727-1.041a4 4 0 0 0-2.134-7.589 5 5 0 0 0-9.186 0 4 4 0 0 0-2.134 7.588c.411.198.727.585.727 1.041V20a1 1 0 0 0 1 1Z',
    ), // key: 1qvrer
    IconPathElement('M6 17h12'), // key: 1jwigz
  ]);

  /// `cherry.mjs`
  static const LucideGlyph cherry = LucideGlyph('cherry', <IconElement>[
    IconPathElement(
      'M2 17a5 5 0 0 0 10 0c0-2.76-2.5-5-5-3-2.5-2-5 .24-5 3Z',
    ), // key: cvxqlc
    IconPathElement(
      'M12 17a5 5 0 0 0 10 0c0-2.76-2.5-5-5-3-2.5-2-5 .24-5 3Z',
    ), // key: 1ostrc
    IconPathElement(
      'M7 14c3.22-2.91 4.29-8.75 5-12 1.66 2.38 4.94 9 5 12',
    ), // key: hqx58h
    IconPathElement(
      'M22 9c-4.29 0-7.14-2.33-10-7 5.71 0 10 4.67 10 7Z',
    ), // key: eykp1o
  ]);

  /// `chess-bishop.mjs`
  static const LucideGlyph
  chessBishop = LucideGlyph('chess-bishop', <IconElement>[
    IconPathElement(
      'M5 20a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1z',
    ), // key: b89hwq
    IconPathElement(
      'M15 18c1.5-.615 3-2.461 3-4.923C18 8.769 14.5 4.462 12 2 9.5 4.462 6 8.77 6 13.077 6 15.539 7.5 17.385 9 18',
    ), // key: 8jdkhx
    IconPathElement('m16 7-2.5 2.5'), // key: 1jq90w
    IconPathElement('M9 2h6'), // key: 1jrp98
  ]);

  /// `chess-king.mjs`
  static const LucideGlyph chessKing = LucideGlyph('chess-king', <IconElement>[
    IconPathElement(
      'M4 20a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1z',
    ), // key: mqzwx6
    IconPathElement(
      'm6.7 18-1-1C4.35 15.682 3 14.09 3 12a5 5 0 0 1 4.95-5c1.584 0 2.7.455 4.05 1.818C13.35 7.455 14.466 7 16.05 7A5 5 0 0 1 21 12c0 2.082-1.359 3.673-2.7 5l-1 1',
    ), // key: 1gdt1g
    IconPathElement('M10 4h4'), // key: 1xpv9s
    IconPathElement('M12 2v6.818'), // key: b17a49
  ]);

  /// `chess-knight.mjs`
  static const LucideGlyph
  chessKnight = LucideGlyph('chess-knight', <IconElement>[
    IconPathElement(
      'M5 20a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1z',
    ), // key: b89hwq
    IconPathElement(
      'M16.5 18c1-2 2.5-5 2.5-9a7 7 0 0 0-7-7H6.635a1 1 0 0 0-.768 1.64L7 5l-2.32 5.802a2 2 0 0 0 .95 2.526l2.87 1.456',
    ), // key: axbnlq
    IconPathElement('m15 5 1.425-1.425'), // key: 15xz8w
    IconPathElement('m17 8 1.53-1.53'), // key: 15zhqh
    IconPathElement('M9.713 12.185 7 18'), // key: 1ocm0l
  ]);

  /// `chess-pawn.mjs`
  static const LucideGlyph chessPawn = LucideGlyph('chess-pawn', <IconElement>[
    IconPathElement(
      'M5 20a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1z',
    ), // key: b89hwq
    IconPathElement('m14.5 10 1.5 8'), // key: cim3qy
    IconPathElement('M7 10h10'), // key: 1101jm
    IconPathElement('m8 18 1.5-8'), // key: ja3yjd
    IconCircleElement(12, 6, 4), // key: 1frrej
  ]);

  /// `chess-queen.mjs`
  static const LucideGlyph chessQueen = LucideGlyph(
    'chess-queen',
    <IconElement>[
      IconPathElement(
        'M4 20a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1z',
      ), // key: mqzwx6
      IconPathElement(
        'm12.474 5.943 1.567 5.34a1 1 0 0 0 1.75.328l2.616-3.402',
      ), // key: 1js4gl
      IconPathElement('m20 9-3 9'), // key: r75r3f
      IconPathElement(
        'm5.594 8.209 2.615 3.403a1 1 0 0 0 1.75-.329l1.567-5.34',
      ), // key: 1joj19
      IconPathElement('M7 18 4 9'), // key: 1mfzj8
      IconCircleElement(12, 4, 2), // key: muu5ef
      IconCircleElement(20, 7, 2), // key: 9w7p1x
      IconCircleElement(4, 7, 2), // key: 1d9wy8
    ],
  );

  /// `chess-rook.mjs`
  static const LucideGlyph chessRook = LucideGlyph('chess-rook', <IconElement>[
    IconPathElement(
      'M5 20a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1z',
    ), // key: b89hwq
    IconPathElement('M10 2v2'), // key: 7u0qdc
    IconPathElement('M14 2v2'), // key: 6buw04
    IconPathElement('m17 18-1-9'), // key: 10nd7q
    IconPathElement('M6 2v5a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V2'), // key: uxf4yx
    IconPathElement('M6 4h12'), // key: 1x2ag7
    IconPathElement('m7 18 1-9'), // key: 1si9vq
  ]);

  /// `chevron-down.mjs`
  static const LucideGlyph chevronDown = LucideGlyph(
    'chevron-down',
    <IconElement>[
      IconPathElement('m6 9 6 6 6-6'), // key: qrunsl
    ],
  );

  /// `chevron-first.mjs`
  static const LucideGlyph chevronFirst = LucideGlyph(
    'chevron-first',
    <IconElement>[
      IconPathElement('m17 18-6-6 6-6'), // key: 1yerx2
      IconPathElement('M7 6v12'), // key: 1p53r6
    ],
  );

  /// `chevron-last.mjs`
  static const LucideGlyph chevronLast = LucideGlyph(
    'chevron-last',
    <IconElement>[
      IconPathElement('m7 18 6-6-6-6'), // key: lwmzdw
      IconPathElement('M17 6v12'), // key: 1o0aio
    ],
  );

  /// `chevron-left.mjs`
  static const LucideGlyph chevronLeft = LucideGlyph(
    'chevron-left',
    <IconElement>[
      IconPathElement('m15 18-6-6 6-6'), // key: 1wnfg3
    ],
  );

  /// `chevron-right.mjs`
  static const LucideGlyph chevronRight = LucideGlyph(
    'chevron-right',
    <IconElement>[
      IconPathElement('m9 18 6-6-6-6'), // key: mthhwq
    ],
  );

  /// `chevron-up.mjs`
  static const LucideGlyph chevronUp = LucideGlyph('chevron-up', <IconElement>[
    IconPathElement('m18 15-6-6-6 6'), // key: 153udz
  ]);

  /// `chevrons-down-up.mjs`
  static const LucideGlyph chevronsDownUp = LucideGlyph(
    'chevrons-down-up',
    <IconElement>[
      IconPathElement('m7 20 5-5 5 5'), // key: 13a0gw
      IconPathElement('m7 4 5 5 5-5'), // key: 1kwcof
    ],
  );

  /// `chevrons-down.mjs`
  static const LucideGlyph chevronsDown = LucideGlyph(
    'chevrons-down',
    <IconElement>[
      IconPathElement('m7 6 5 5 5-5'), // key: 1lc07p
      IconPathElement('m7 13 5 5 5-5'), // key: 1d48rs
    ],
  );

  /// `chevrons-left-right-ellipsis.mjs`
  static const LucideGlyph chevronsLeftRightEllipsis = LucideGlyph(
    'chevrons-left-right-ellipsis',
    <IconElement>[
      IconPathElement('M12 12h.01'), // key: 1mp3jc
      IconPathElement('M16 12h.01'), // key: 1l6xoz
      IconPathElement('m17 7 5 5-5 5'), // key: 1xlxn0
      IconPathElement('m7 7-5 5 5 5'), // key: 19njba
      IconPathElement('M8 12h.01'), // key: czm47f
    ],
  );

  /// `chevrons-left-right.mjs`
  static const LucideGlyph chevronsLeftRight = LucideGlyph(
    'chevrons-left-right',
    <IconElement>[
      IconPathElement('m9 7-5 5 5 5'), // key: j5w590
      IconPathElement('m15 7 5 5-5 5'), // key: 1bl6da
    ],
  );

  /// `chevrons-left.mjs`
  static const LucideGlyph chevronsLeft = LucideGlyph(
    'chevrons-left',
    <IconElement>[
      IconPathElement('m11 17-5-5 5-5'), // key: 13zhaf
      IconPathElement('m18 17-5-5 5-5'), // key: h8a8et
    ],
  );

  /// `chevrons-right-left.mjs`
  static const LucideGlyph chevronsRightLeft = LucideGlyph(
    'chevrons-right-left',
    <IconElement>[
      IconPathElement('m20 17-5-5 5-5'), // key: 30x0n2
      IconPathElement('m4 17 5-5-5-5'), // key: 16spf4
    ],
  );

  /// `chevrons-right.mjs`
  static const LucideGlyph chevronsRight = LucideGlyph(
    'chevrons-right',
    <IconElement>[
      IconPathElement('m6 17 5-5-5-5'), // key: xnjwq
      IconPathElement('m13 17 5-5-5-5'), // key: 17xmmf
    ],
  );

  /// `chevrons-up-down.mjs`
  static const LucideGlyph chevronsUpDown = LucideGlyph(
    'chevrons-up-down',
    <IconElement>[
      IconPathElement('m7 15 5 5 5-5'), // key: 1hf1tw
      IconPathElement('m7 9 5-5 5 5'), // key: sgt6xg
    ],
  );

  /// `chevrons-up.mjs`
  static const LucideGlyph chevronsUp = LucideGlyph(
    'chevrons-up',
    <IconElement>[
      IconPathElement('m17 11-5-5-5 5'), // key: e8nh98
      IconPathElement('m17 18-5-5-5 5'), // key: 2avn1x
    ],
  );

  /// `church.mjs`
  static const LucideGlyph church = LucideGlyph('church', <IconElement>[
    IconPathElement('M10 9h4'), // key: u4k05v
    IconPathElement('M12 7v5'), // key: ma6bk
    IconPathElement('M14 21v-3a2 2 0 0 0-4 0v3'), // key: 1rgiei
    IconPathElement(
      'm18 9 3.52 2.147a1 1 0 0 1 .48.854V19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-6.999a1 1 0 0 1 .48-.854L6 9',
    ), // key: flvdwo
    IconPathElement(
      'M6 21V7a1 1 0 0 1 .376-.782l5-3.999a1 1 0 0 1 1.249.001l5 4A1 1 0 0 1 18 7v14',
    ), // key: a5i0n2
  ]);

  /// `cigarette-off.mjs`
  static const LucideGlyph
  cigaretteOff = LucideGlyph('cigarette-off', <IconElement>[
    IconPathElement('M12 12H3a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h13'), // key: 1gdiyg
    IconPathElement('M18 8c0-2.5-2-2.5-2-5'), // key: 1il607
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement('M21 12a1 1 0 0 1 1 1v2a1 1 0 0 1-.5.866'), // key: 166zjj
    IconPathElement('M22 8c0-2.5-2-2.5-2-5'), // key: 1gah44
    IconPathElement('M7 12v4'), // key: jqww69
  ]);

  /// `cigarette.mjs`
  static const LucideGlyph cigarette = LucideGlyph('cigarette', <IconElement>[
    IconPathElement('M17 12H3a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h14'), // key: 1mb5g1
    IconPathElement('M18 8c0-2.5-2-2.5-2-5'), // key: 1il607
    IconPathElement('M21 16a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1'), // key: 1yl5r7
    IconPathElement('M22 8c0-2.5-2-2.5-2-5'), // key: 1gah44
    IconPathElement('M7 12v4'), // key: jqww69
  ]);

  /// `circle-alert.mjs`
  static const LucideGlyph circleAlert = LucideGlyph(
    'circle-alert',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconLineElement(12, 8, 12, 12), // key: 1pkeuh
      IconLineElement(12, 16, 12.01, 16), // key: 4dfq90
    ],
  );

  /// `circle-arrow-down.mjs`
  static const LucideGlyph circleArrowDown = LucideGlyph(
    'circle-arrow-down',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement('M12 8v8'), // key: napkw2
      IconPathElement('m8 12 4 4 4-4'), // key: k98ssh
    ],
  );

  /// `circle-arrow-left.mjs`
  static const LucideGlyph circleArrowLeft = LucideGlyph(
    'circle-arrow-left',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement('m12 8-4 4 4 4'), // key: 15vm53
      IconPathElement('M16 12H8'), // key: 1fr5h0
    ],
  );

  /// `circle-arrow-out-down-left.mjs`
  static const LucideGlyph circleArrowOutDownLeft = LucideGlyph(
    'circle-arrow-out-down-left',
    <IconElement>[
      IconPathElement('M2 12a10 10 0 1 1 10 10'), // key: 1yn6ov
      IconPathElement('m2 22 10-10'), // key: 28ilpk
      IconPathElement('M8 22H2v-6'), // key: sulq54
    ],
  );

  /// `circle-arrow-out-down-right.mjs`
  static const LucideGlyph circleArrowOutDownRight = LucideGlyph(
    'circle-arrow-out-down-right',
    <IconElement>[
      IconPathElement('M12 22a10 10 0 1 1 10-10'), // key: 130bv5
      IconPathElement('M22 22 12 12'), // key: 131aw7
      IconPathElement('M22 16v6h-6'), // key: 1gvm70
    ],
  );

  /// `circle-arrow-out-up-left.mjs`
  static const LucideGlyph circleArrowOutUpLeft = LucideGlyph(
    'circle-arrow-out-up-left',
    <IconElement>[
      IconPathElement('M2 8V2h6'), // key: hiwtdz
      IconPathElement('m2 2 10 10'), // key: 1oh8rs
      IconPathElement('M12 2A10 10 0 1 1 2 12'), // key: rrk4fa
    ],
  );

  /// `circle-arrow-out-up-right.mjs`
  static const LucideGlyph circleArrowOutUpRight = LucideGlyph(
    'circle-arrow-out-up-right',
    <IconElement>[
      IconPathElement('M22 12A10 10 0 1 1 12 2'), // key: 1fm58d
      IconPathElement('M22 2 12 12'), // key: yg2myt
      IconPathElement('M16 2h6v6'), // key: zan5cs
    ],
  );

  /// `circle-arrow-right.mjs`
  static const LucideGlyph circleArrowRight = LucideGlyph(
    'circle-arrow-right',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement('m12 16 4-4-4-4'), // key: 1i9zcv
      IconPathElement('M8 12h8'), // key: 1wcyev
    ],
  );

  /// `circle-arrow-up.mjs`
  static const LucideGlyph circleArrowUp = LucideGlyph(
    'circle-arrow-up',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement('m16 12-4-4-4 4'), // key: 177agl
      IconPathElement('M12 16V8'), // key: 1sbj14
    ],
  );

  /// `circle-check-big.mjs`
  static const LucideGlyph circleCheckBig = LucideGlyph(
    'circle-check-big',
    <IconElement>[
      IconPathElement('M21.801 10A10 10 0 1 1 17 3.335'), // key: yps3ct
      IconPathElement('m9 11 3 3L22 4'), // key: 1pflzl
    ],
  );

  /// `circle-check.mjs`
  static const LucideGlyph circleCheck = LucideGlyph(
    'circle-check',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement('m9 12 2 2 4-4'), // key: dzmm74
    ],
  );

  /// `circle-chevron-down.mjs`
  static const LucideGlyph circleChevronDown = LucideGlyph(
    'circle-chevron-down',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement('m16 10-4 4-4-4'), // key: 894hmk
    ],
  );

  /// `circle-chevron-left.mjs`
  static const LucideGlyph circleChevronLeft = LucideGlyph(
    'circle-chevron-left',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement('m14 16-4-4 4-4'), // key: ojs7w8
    ],
  );

  /// `circle-chevron-right.mjs`
  static const LucideGlyph circleChevronRight = LucideGlyph(
    'circle-chevron-right',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement('m10 8 4 4-4 4'), // key: 1wy4r4
    ],
  );

  /// `circle-chevron-up.mjs`
  static const LucideGlyph circleChevronUp = LucideGlyph(
    'circle-chevron-up',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement('m8 14 4-4 4 4'), // key: fy2ptz
    ],
  );

  /// `circle-dashed.mjs`
  static const LucideGlyph circleDashed = LucideGlyph(
    'circle-dashed',
    <IconElement>[
      IconPathElement('M10.1 2.182a10 10 0 0 1 3.8 0'), // key: 5ilxe3
      IconPathElement('M13.9 21.818a10 10 0 0 1-3.8 0'), // key: 11zvb9
      IconPathElement('M17.609 3.721a10 10 0 0 1 2.69 2.7'), // key: 1iw5b2
      IconPathElement('M2.182 13.9a10 10 0 0 1 0-3.8'), // key: c0bmvh
      IconPathElement('M20.279 17.609a10 10 0 0 1-2.7 2.69'), // key: 1ruxm7
      IconPathElement('M21.818 10.1a10 10 0 0 1 0 3.8'), // key: qkgqxc
      IconPathElement('M3.721 6.391a10 10 0 0 1 2.7-2.69'), // key: 1mcia2
      IconPathElement('M6.391 20.279a10 10 0 0 1-2.69-2.7'), // key: 1fvljs
    ],
  );

  /// `circle-divide.mjs`
  static const LucideGlyph circleDivide = LucideGlyph(
    'circle-divide',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconLineElement(8, 12, 16, 12), // key: 1jonct
      IconLineElement(12, 16, 12, 16), // key: aqc6ln
      IconLineElement(12, 8, 12, 8), // key: 1mkcni
    ],
  );

  /// `circle-dollar-sign.mjs`
  static const LucideGlyph
  circleDollarSign = LucideGlyph('circle-dollar-sign', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M16 8h-6a2 2 0 1 0 0 4h4a2 2 0 1 1 0 4H8'), // key: 1h4pet
    IconPathElement('M12 18V6'), // key: zqpxq5
  ]);

  /// `circle-dot-dashed.mjs`
  static const LucideGlyph circleDotDashed = LucideGlyph(
    'circle-dot-dashed',
    <IconElement>[
      IconPathElement('M10.1 2.18a9.93 9.93 0 0 1 3.8 0'), // key: 1qdqn0
      IconPathElement('M17.6 3.71a9.95 9.95 0 0 1 2.69 2.7'), // key: 1bq7p6
      IconPathElement('M21.82 10.1a9.93 9.93 0 0 1 0 3.8'), // key: 1rlaqf
      IconPathElement('M20.29 17.6a9.95 9.95 0 0 1-2.7 2.69'), // key: 1xk03u
      IconPathElement('M13.9 21.82a9.94 9.94 0 0 1-3.8 0'), // key: l7re25
      IconPathElement('M6.4 20.29a9.95 9.95 0 0 1-2.69-2.7'), // key: 1v18p6
      IconPathElement('M2.18 13.9a9.93 9.93 0 0 1 0-3.8'), // key: xdo6bj
      IconPathElement('M3.71 6.4a9.95 9.95 0 0 1 2.7-2.69'), // key: 1jjmaz
      IconCircleElement(12, 12, 1), // key: 41hilf
    ],
  );

  /// `circle-dot.mjs`
  static const LucideGlyph circleDot = LucideGlyph('circle-dot', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconCircleElement(12, 12, 1), // key: 41hilf
  ]);

  /// `circle-ellipsis.mjs`
  static const LucideGlyph circleEllipsis = LucideGlyph(
    'circle-ellipsis',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement('M17 12h.01'), // key: 1m0b6t
      IconPathElement('M12 12h.01'), // key: 1mp3jc
      IconPathElement('M7 12h.01'), // key: eqddd0
    ],
  );

  /// `circle-equal.mjs`
  static const LucideGlyph circleEqual = LucideGlyph(
    'circle-equal',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement('M7 10h10'), // key: 1101jm
      IconPathElement('M7 14h10'), // key: 1mhdw3
    ],
  );

  /// `circle-euro.mjs`
  static const LucideGlyph circleEuro = LucideGlyph(
    'circle-euro',
    <IconElement>[
      IconPathElement('M15 9.4a4 4 0 1 0 0 5.2'), // key: 1makmb
      IconPathElement('M7 12h5'), // key: gblrwe
      IconCircleElement(12, 12, 10), // key: 1mglay
    ],
  );

  /// `circle-fading-arrow-up.mjs`
  static const LucideGlyph circleFadingArrowUp = LucideGlyph(
    'circle-fading-arrow-up',
    <IconElement>[
      IconPathElement('M12 2a10 10 0 0 1 7.38 16.75'), // key: 175t95
      IconPathElement('m16 12-4-4-4 4'), // key: 177agl
      IconPathElement('M12 16V8'), // key: 1sbj14
      IconPathElement('M2.5 8.875a10 10 0 0 0-.5 3'), // key: 1vce0s
      IconPathElement('M2.83 16a10 10 0 0 0 2.43 3.4'), // key: o3fkw4
      IconPathElement('M4.636 5.235a10 10 0 0 1 .891-.857'), // key: 1szpfk
      IconPathElement('M8.644 21.42a10 10 0 0 0 7.631-.38'), // key: 9yhvd4
    ],
  );

  /// `circle-fading-plus.mjs`
  static const LucideGlyph circleFadingPlus = LucideGlyph(
    'circle-fading-plus',
    <IconElement>[
      IconPathElement('M12 2a10 10 0 0 1 7.38 16.75'), // key: 175t95
      IconPathElement('M12 8v8'), // key: napkw2
      IconPathElement('M16 12H8'), // key: 1fr5h0
      IconPathElement('M2.5 8.875a10 10 0 0 0-.5 3'), // key: 1vce0s
      IconPathElement('M2.83 16a10 10 0 0 0 2.43 3.4'), // key: o3fkw4
      IconPathElement('M4.636 5.235a10 10 0 0 1 .891-.857'), // key: 1szpfk
      IconPathElement('M8.644 21.42a10 10 0 0 0 7.631-.38'), // key: 9yhvd4
    ],
  );

  /// `circle-gauge.mjs`
  static const LucideGlyph circleGauge = LucideGlyph(
    'circle-gauge',
    <IconElement>[
      IconPathElement('M15.6 2.7a10 10 0 1 0 5.7 5.7'), // key: 1e0p6d
      IconCircleElement(12, 12, 2), // key: 1c9p78
      IconPathElement('M13.4 10.6 19 5'), // key: 1kr7tw
    ],
  );

  /// `circle-minus.mjs`
  static const LucideGlyph circleMinus = LucideGlyph(
    'circle-minus',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement('M8 12h8'), // key: 1wcyev
    ],
  );

  /// `circle-off.mjs`
  static const LucideGlyph circleOff = LucideGlyph('circle-off', <IconElement>[
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement('M8.35 2.69A10 10 0 0 1 21.3 15.65'), // key: 1pfsoa
    IconPathElement('M19.08 19.08A10 10 0 1 1 4.92 4.92'), // key: 1ablyi
  ]);

  /// `circle-parking-off.mjs`
  static const LucideGlyph circleParkingOff = LucideGlyph(
    'circle-parking-off',
    <IconElement>[
      IconPathElement('M12.656 7H13a3 3 0 0 1 2.984 3.307'), // key: 1sjx87
      IconPathElement('M13 13H9'), // key: e2beee
      IconPathElement('M19.071 19.071A1 1 0 0 1 4.93 4.93'), // key: 1kb595
      IconPathElement('m2 2 20 20'), // key: 1ooewy
      IconPathElement('M8.357 2.687a10 10 0 0 1 12.956 12.956'), // key: 5bsfdx
      IconPathElement('M9 17V9'), // key: ojradj
    ],
  );

  /// `circle-parking.mjs`
  static const LucideGlyph circleParking = LucideGlyph(
    'circle-parking',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement('M9 17V7h4a3 3 0 0 1 0 6H9'), // key: 1dfk2c
    ],
  );

  /// `circle-pause.mjs`
  static const LucideGlyph circlePause = LucideGlyph(
    'circle-pause',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconLineElement(10, 15, 10, 9), // key: c1nkhi
      IconLineElement(14, 15, 14, 9), // key: h65svq
    ],
  );

  /// `circle-percent.mjs`
  static const LucideGlyph circlePercent = LucideGlyph(
    'circle-percent',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement('m15 9-6 6'), // key: 1uzhvr
      IconPathElement('M9 9h.01'), // key: 1q5me6
      IconPathElement('M15 15h.01'), // key: lqbp3k
    ],
  );

  /// `circle-pile.mjs`
  static const LucideGlyph circlePile = LucideGlyph(
    'circle-pile',
    <IconElement>[
      IconCircleElement(12, 19, 2), // key: 13j0tp
      IconCircleElement(12, 5, 2), // key: f1ur92
      IconCircleElement(16, 12, 2), // key: 4ma0v8
      IconCircleElement(20, 19, 2), // key: 1obnsp
      IconCircleElement(4, 19, 2), // key: p3m9r0
      IconCircleElement(8, 12, 2), // key: 1nvbw3
    ],
  );

  /// `circle-play.mjs`
  static const LucideGlyph
  circlePlay = LucideGlyph('circle-play', <IconElement>[
    IconPathElement(
      'M9 9.003a1 1 0 0 1 1.517-.859l4.997 2.997a1 1 0 0 1 0 1.718l-4.997 2.997A1 1 0 0 1 9 14.996z',
    ), // key: kmsa83
    IconCircleElement(12, 12, 10), // key: 1mglay
  ]);

  /// `circle-plus.mjs`
  static const LucideGlyph circlePlus = LucideGlyph(
    'circle-plus',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement('M8 12h8'), // key: 1wcyev
      IconPathElement('M12 8v8'), // key: napkw2
    ],
  );

  /// `circle-pound-sterling.mjs`
  static const LucideGlyph circlePoundSterling = LucideGlyph(
    'circle-pound-sterling',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement('M10 16V9.5a1 1 0 0 1 5 0'), // key: 1i1are
      IconPathElement('M8 12h4'), // key: qz6y1c
      IconPathElement('M8 16h7'), // key: sbedsn
    ],
  );

  /// `circle-power.mjs`
  static const LucideGlyph circlePower = LucideGlyph(
    'circle-power',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement('M12 7v4'), // key: xawao1
      IconPathElement('M7.998 9.003a5 5 0 1 0 8-.005'), // key: 1pek45
    ],
  );

  /// `circle-question-mark.mjs`
  static const LucideGlyph circleQuestionMark = LucideGlyph(
    'circle-question-mark',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement('M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3'), // key: 1u773s
      IconPathElement('M12 17h.01'), // key: p32p05
    ],
  );

  /// `circle-slash-2.mjs`
  static const LucideGlyph circleSlash2 = LucideGlyph(
    'circle-slash-2',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement('M22 2 2 22'), // key: y4kqgn
    ],
  );

  /// `circle-slash.mjs`
  static const LucideGlyph circleSlash = LucideGlyph(
    'circle-slash',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconLineElement(9, 15, 15, 9), // key: 1dfufj
    ],
  );

  /// `circle-small.mjs`
  static const LucideGlyph circleSmall = LucideGlyph(
    'circle-small',
    <IconElement>[
      IconCircleElement(12, 12, 6), // key: 1vlfrh
    ],
  );

  /// `circle-star.mjs`
  static const LucideGlyph
  circleStar = LucideGlyph('circle-star', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement(
      'M11.051 7.616a1 1 0 0 1 1.909.024l.737 1.452a1 1 0 0 0 .737.535l1.634.256a1 1 0 0 1 .588 1.806l-1.172 1.168a1 1 0 0 0-.282.866l.259 1.613a1 1 0 0 1-1.541 1.134l-1.465-.75a1 1 0 0 0-.912 0l-1.465.75a1 1 0 0 1-1.539-1.133l.258-1.613a1 1 0 0 0-.282-.867l-1.156-1.152a1 1 0 0 1 .572-1.822l1.633-.256a1 1 0 0 0 .737-.535z',
    ), // key: 285bvi
  ]);

  /// `circle-stop.mjs`
  static const LucideGlyph circleStop = LucideGlyph(
    'circle-stop',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconRectElement(9, 9, 6, 6, 1), // key: 1ssd4o
    ],
  );

  /// `circle-user-round.mjs`
  static const LucideGlyph circleUserRound = LucideGlyph(
    'circle-user-round',
    <IconElement>[
      IconPathElement('M17.925 20.056a6 6 0 0 0-11.851.001'), // key: z69sun
      IconCircleElement(12, 11, 4), // key: 1gt34v
      IconCircleElement(12, 12, 10), // key: 1mglay
    ],
  );

  /// `circle-user.mjs`
  static const LucideGlyph circleUser = LucideGlyph(
    'circle-user',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconCircleElement(12, 10, 3), // key: ilqhr7
      IconPathElement(
        'M7 20.662V19a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v1.662',
      ), // key: 154egf
    ],
  );

  /// `circle-x.mjs`
  static const LucideGlyph circleX = LucideGlyph('circle-x', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('m15 9-6 6'), // key: 1uzhvr
    IconPathElement('m9 9 6 6'), // key: z0biqf
  ]);

  /// `circle.mjs`
  static const LucideGlyph circle = LucideGlyph('circle', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
  ]);

  /// `circuit-board.mjs`
  static const LucideGlyph circuitBoard = LucideGlyph(
    'circuit-board',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M11 9h4a2 2 0 0 0 2-2V3'), // key: 1ve2rv
      IconCircleElement(9, 9, 2), // key: af1f0g
      IconPathElement('M7 21v-4a2 2 0 0 1 2-2h4'), // key: 1fwkro
      IconCircleElement(15, 15, 2), // key: 3i40o0
    ],
  );

  /// `citrus.mjs`
  static const LucideGlyph citrus = LucideGlyph('citrus', <IconElement>[
    IconPathElement(
      'M21.66 17.67a1.08 1.08 0 0 1-.04 1.6A12 12 0 0 1 4.73 2.38a1.1 1.1 0 0 1 1.61-.04z',
    ), // key: 4ite01
    IconPathElement('M19.65 15.66A8 8 0 0 1 8.35 4.34'), // key: 1gxipu
    IconPathElement('m14 10-5.5 5.5'), // key: 92pfem
    IconPathElement('M14 17.85V10H6.15'), // key: xqmtsk
  ]);

  /// `clapperboard.mjs`
  static const LucideGlyph
  clapperboard = LucideGlyph('clapperboard', <IconElement>[
    IconPathElement('m12.296 3.464 3.02 3.956'), // key: qash78
    IconPathElement(
      'M20.2 6 3 11l-.9-2.4c-.3-1.1.3-2.2 1.3-2.5l13.5-4c1.1-.3 2.2.3 2.5 1.3z',
    ), // key: 1h7j8b
    IconPathElement('M3 11h18v8a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z'), // key: 4lm6w1
    IconPathElement('m6.18 5.276 3.1 3.899'), // key: zjj9t3
  ]);

  /// `clipboard-check.mjs`
  static const LucideGlyph
  clipboardCheck = LucideGlyph('clipboard-check', <IconElement>[
    IconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    IconPathElement(
      'M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2',
    ), // key: 116196
    IconPathElement('m9 14 2 2 4-4'), // key: df797q
  ]);

  /// `clipboard-clock.mjs`
  static const LucideGlyph clipboardClock = LucideGlyph(
    'clipboard-clock',
    <IconElement>[
      IconPathElement('M16 14v2.2l1.6 1'), // key: fo4ql5
      IconPathElement('M16 4h2a2 2 0 0 1 2 2v.832'), // key: 1ujtp2
      IconPathElement('M8 4H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h2'), // key: qvpao1
      IconCircleElement(16, 16, 6), // key: qoo3c4
      IconRectElement(8, 2, 8, 4, 1), // key: ublpy
    ],
  );

  /// `clipboard-copy.mjs`
  static const LucideGlyph clipboardCopy = LucideGlyph(
    'clipboard-copy',
    <IconElement>[
      IconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
      IconPathElement(
        'M8 4H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-2',
      ), // key: 4jdomd
      IconPathElement('M16 4h2a2 2 0 0 1 2 2v4'), // key: 3hqy98
      IconPathElement('M21 14H11'), // key: 1bme5i
      IconPathElement('m15 10-4 4 4 4'), // key: 5dvupr
    ],
  );

  /// `clipboard-list.mjs`
  static const LucideGlyph
  clipboardList = LucideGlyph('clipboard-list', <IconElement>[
    IconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    IconPathElement(
      'M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2',
    ), // key: 116196
    IconPathElement('M12 11h4'), // key: 1jrz19
    IconPathElement('M12 16h4'), // key: n85exb
    IconPathElement('M8 11h.01'), // key: 1dfujw
    IconPathElement('M8 16h.01'), // key: 18s6g9
  ]);

  /// `clipboard-minus.mjs`
  static const LucideGlyph
  clipboardMinus = LucideGlyph('clipboard-minus', <IconElement>[
    IconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    IconPathElement(
      'M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2',
    ), // key: 116196
    IconPathElement('M9 14h6'), // key: 159ibu
  ]);

  /// `clipboard-paste.mjs`
  static const LucideGlyph clipboardPaste = LucideGlyph(
    'clipboard-paste',
    <IconElement>[
      IconPathElement('M11 14h10'), // key: 1w8e9d
      IconPathElement('M16 4h2a2 2 0 0 1 2 2v1.344'), // key: 1e62lh
      IconPathElement('m17 18 4-4-4-4'), // key: z2g111
      IconPathElement(
        'M8 4H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 1.793-1.113',
      ), // key: bjbb7m
      IconRectElement(8, 2, 8, 4, 1), // key: ublpy
    ],
  );

  /// `clipboard-pen-line.mjs`
  static const LucideGlyph
  clipboardPenLine = LucideGlyph('clipboard-pen-line', <IconElement>[
    IconRectElement(8, 2, 8, 4, 1), // key: 1oijnt
    IconPathElement(
      'M8 4H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-.5',
    ), // key: 1but9f
    IconPathElement('M16 4h2a2 2 0 0 1 1.73 1'), // key: 1p8n7l
    IconPathElement('M8 18h1'), // key: 13wk12
    IconPathElement(
      'M21.378 12.626a1 1 0 0 0-3.004-3.004l-4.01 4.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z',
    ), // key: 2t3380
  ]);

  /// `clipboard-pen.mjs`
  static const LucideGlyph
  clipboardPen = LucideGlyph('clipboard-pen', <IconElement>[
    IconPathElement('M16 4h2a2 2 0 0 1 2 2v2'), // key: j91f56
    IconPathElement(
      'M21.34 15.664a1 1 0 1 0-3.004-3.004l-5.01 5.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z',
    ), // key: 16fuwn
    IconPathElement('M8 22H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2'), // key: 120tdm
    IconRectElement(8, 2, 8, 4, 1), // key: ublpy
  ]);

  /// `clipboard-plus.mjs`
  static const LucideGlyph
  clipboardPlus = LucideGlyph('clipboard-plus', <IconElement>[
    IconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    IconPathElement(
      'M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2',
    ), // key: 116196
    IconPathElement('M9 14h6'), // key: 159ibu
    IconPathElement('M12 17v-6'), // key: 1y8rbf
  ]);

  /// `clipboard-type.mjs`
  static const LucideGlyph
  clipboardType = LucideGlyph('clipboard-type', <IconElement>[
    IconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    IconPathElement(
      'M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2',
    ), // key: 116196
    IconPathElement('M9 12v-1h6v1'), // key: iehl6m
    IconPathElement('M11 17h2'), // key: 12w5me
    IconPathElement('M12 11v6'), // key: 1bwqyc
  ]);

  /// `clipboard-x.mjs`
  static const LucideGlyph
  clipboardX = LucideGlyph('clipboard-x', <IconElement>[
    IconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    IconPathElement(
      'M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2',
    ), // key: 116196
    IconPathElement('m15 11-6 6'), // key: 1toa9n
    IconPathElement('m9 11 6 6'), // key: wlibny
  ]);

  /// `clipboard.mjs`
  static const LucideGlyph clipboard = LucideGlyph('clipboard', <IconElement>[
    IconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    IconPathElement(
      'M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2',
    ), // key: 116196
  ]);

  /// `clock-1.mjs`
  static const LucideGlyph clock1 = LucideGlyph('clock-1', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M12 6v6l2-4'), // key: miptyd
  ]);

  /// `clock-10.mjs`
  static const LucideGlyph clock10 = LucideGlyph('clock-10', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M12 6v6l-4-2'), // key: cedpoo
  ]);

  /// `clock-11.mjs`
  static const LucideGlyph clock11 = LucideGlyph('clock-11', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M12 6v6l-2-4'), // key: ns39ag
  ]);

  /// `clock-12.mjs`
  static const LucideGlyph clock12 = LucideGlyph('clock-12', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M12 6v6'), // key: 1ipuwl
  ]);

  /// `clock-2.mjs`
  static const LucideGlyph clock2 = LucideGlyph('clock-2', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M12 6v6l4-2'), // key: 1r2kuh
  ]);

  /// `clock-3.mjs`
  static const LucideGlyph clock3 = LucideGlyph('clock-3', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M12 6v6h4'), // key: 135r8i
  ]);

  /// `clock-4.mjs`
  static const LucideGlyph clock4 = LucideGlyph('clock-4', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M12 6v6l4 2'), // key: mmk7yg
  ]);

  /// `clock-5.mjs`
  static const LucideGlyph clock5 = LucideGlyph('clock-5', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M12 6v6l2 4'), // key: 1287s9
  ]);

  /// `clock-6.mjs`
  static const LucideGlyph clock6 = LucideGlyph('clock-6', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M12 6v10'), // key: wf7rdh
  ]);

  /// `clock-7.mjs`
  static const LucideGlyph clock7 = LucideGlyph('clock-7', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M12 6v6l-2 4'), // key: 1095bu
  ]);

  /// `clock-8.mjs`
  static const LucideGlyph clock8 = LucideGlyph('clock-8', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M12 6v6l-4 2'), // key: imc3wl
  ]);

  /// `clock-9.mjs`
  static const LucideGlyph clock9 = LucideGlyph('clock-9', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M12 6v6H8'), // key: u39vzm
  ]);

  /// `clock-alert.mjs`
  static const LucideGlyph clockAlert = LucideGlyph(
    'clock-alert',
    <IconElement>[
      IconPathElement('M12 6v6l4 2'), // key: mmk7yg
      IconPathElement('M20 12v5'), // key: 12wsvk
      IconPathElement('M20 21h.01'), // key: 1p6o6n
      IconPathElement('M21.25 8.2A10 10 0 1 0 16 21.16'), // key: 17fp9f
    ],
  );

  /// `clock-arrow-down.mjs`
  static const LucideGlyph clockArrowDown = LucideGlyph(
    'clock-arrow-down',
    <IconElement>[
      IconPathElement('M12 6v6l2 1'), // key: 19cm8n
      IconPathElement('M12.337 21.994a10 10 0 1 1 9.588-8.767'), // key: 28moa
      IconPathElement('m14 18 4 4 4-4'), // key: 1waygx
      IconPathElement('M18 14v8'), // key: irew45
    ],
  );

  /// `clock-arrow-left.mjs`
  static const LucideGlyph clockArrowLeft = LucideGlyph(
    'clock-arrow-left',
    <IconElement>[
      IconPathElement('M12 6v6l1.5.8'), // key: uc7jki
      IconPathElement('M12.338 21.994a10 10 0 1 1 9.587-8.767'), // key: 1lz5pu
      IconPathElement('M14 18h8'), // key: 1le3fr
      IconPathElement('m18 22-4-4 4-4'), // key: dh5o1f
    ],
  );

  /// `clock-arrow-right.mjs`
  static const LucideGlyph clockArrowRight = LucideGlyph(
    'clock-arrow-right',
    <IconElement>[
      IconPathElement('M12 6v6l2 1'), // key: 19cm8n
      IconPathElement('M13.5 21.885A10 10 0 1 1 22 12'), // key: xgp8as
      IconPathElement('M14 18h8'), // key: 1le3fr
      IconPathElement('m18 22 4-4-4-4'), // key: mordo3
    ],
  );

  /// `clock-arrow-up.mjs`
  static const LucideGlyph clockArrowUp = LucideGlyph(
    'clock-arrow-up',
    <IconElement>[
      IconPathElement('M12 6v6l1.56.78'), // key: 14ed3g
      IconPathElement('M13.227 21.925a10 10 0 1 1 8.767-9.588'), // key: jwkls1
      IconPathElement('m14 18 4-4 4 4'), // key: ftkppy
      IconPathElement('M18 22v-8'), // key: su0gjh
    ],
  );

  /// `clock-check.mjs`
  static const LucideGlyph clockCheck = LucideGlyph(
    'clock-check',
    <IconElement>[
      IconPathElement('M12 6v6l4 2'), // key: mmk7yg
      IconPathElement('M22 12a10 10 0 1 0-11 9.95'), // key: 17dhok
      IconPathElement('m22 16-5.5 5.5L14 19'), // key: 1eibut
    ],
  );

  /// `clock-fading.mjs`
  static const LucideGlyph clockFading = LucideGlyph(
    'clock-fading',
    <IconElement>[
      IconPathElement('M12 2a10 10 0 0 1 7.38 16.75'), // key: 175t95
      IconPathElement('M12 6v6l4 2'), // key: mmk7yg
      IconPathElement('M2.5 8.875a10 10 0 0 0-.5 3'), // key: 1vce0s
      IconPathElement('M2.83 16a10 10 0 0 0 2.43 3.4'), // key: o3fkw4
      IconPathElement('M4.636 5.235a10 10 0 0 1 .891-.857'), // key: 1szpfk
      IconPathElement('M8.644 21.42a10 10 0 0 0 7.631-.38'), // key: 9yhvd4
    ],
  );

  /// `clock-plus.mjs`
  static const LucideGlyph clockPlus = LucideGlyph('clock-plus', <IconElement>[
    IconPathElement('M12 6v6l3.644 1.822'), // key: 1jmett
    IconPathElement('M16 19h6'), // key: xwg31i
    IconPathElement('M19 16v6'), // key: tddt3s
    IconPathElement('M21.92 13.267a10 10 0 1 0-8.653 8.653'), // key: 1u0osk
  ]);

  /// `clock.mjs`
  static const LucideGlyph clock = LucideGlyph('clock', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M12 6v6l4 2'), // key: mmk7yg
  ]);

  /// `closed-caption.mjs`
  static const LucideGlyph closedCaption = LucideGlyph(
    'closed-caption',
    <IconElement>[
      IconPathElement('M10 9.17a3 3 0 1 0 0 5.66'), // key: h9wayk
      IconPathElement('M17 9.17a3 3 0 1 0 0 5.66'), // key: 1v6zke
      IconRectElement(2, 5, 20, 14, 2), // key: qneu4z
    ],
  );

  /// `cloud-alert.mjs`
  static const LucideGlyph cloudAlert = LucideGlyph(
    'cloud-alert',
    <IconElement>[
      IconPathElement('M12 12v4'), // key: tww15h
      IconPathElement('M12 20h.01'), // key: zekei9
      IconPathElement(
        'M8.128 16.949A7 7 0 1 1 15.71 8h1.79a1 1 0 0 1 0 9h-1.642',
      ), // key: 1namsd
    ],
  );

  /// `cloud-backup.mjs`
  static const LucideGlyph
  cloudBackup = LucideGlyph('cloud-backup', <IconElement>[
    IconPathElement(
      'M21 15.251A4.5 4.5 0 0 0 17.5 8h-1.79A7 7 0 1 0 3 13.607',
    ), // key: xpoh9y
    IconPathElement('M7 11v4h4'), // key: q9yh32
    IconPathElement(
      'M8 19a5 5 0 0 0 9-3 4.5 4.5 0 0 0-4.5-4.5 4.82 4.82 0 0 0-3.41 1.41L7 15',
    ), // key: 1xm8iu
  ]);

  /// `cloud-check.mjs`
  static const LucideGlyph cloudCheck = LucideGlyph(
    'cloud-check',
    <IconElement>[
      IconPathElement('m17 15-5.5 5.5L9 18'), // key: 15q87x
      IconPathElement(
        'M5.516 16.07A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 3.501 7.327',
      ), // key: 1xtj56
    ],
  );

  /// `cloud-cog.mjs`
  static const LucideGlyph cloudCog = LucideGlyph('cloud-cog', <IconElement>[
    IconPathElement('m10.852 19.772-.383.924'), // key: r7sl7d
    IconPathElement('m13.148 14.228.383-.923'), // key: 1d5zpm
    IconPathElement(
      'M13.148 19.772a3 3 0 1 0-2.296-5.544l-.383-.923',
    ), // key: 1ydik7
    IconPathElement(
      'm13.53 20.696-.382-.924a3 3 0 1 1-2.296-5.544',
    ), // key: 1m1vsf
    IconPathElement('m14.772 15.852.923-.383'), // key: 660p6e
    IconPathElement('m14.772 18.148.923.383'), // key: hrcpis
    IconPathElement(
      'M4.2 15.1a7 7 0 1 1 9.93-9.858A7 7 0 0 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.2',
    ), // key: j2q98n
    IconPathElement('m9.228 15.852-.923-.383'), // key: 1p9ong
    IconPathElement('m9.228 18.148-.923.383'), // key: 6558rz
  ]);

  /// `cloud-download.mjs`
  static const LucideGlyph cloudDownload = LucideGlyph(
    'cloud-download',
    <IconElement>[
      IconPathElement('M12 13v8l-4-4'), // key: 1f5nwf
      IconPathElement('m12 21 4-4'), // key: 1lfcce
      IconPathElement(
        'M4.393 15.269A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.436 8.284',
      ), // key: ui1hmy
    ],
  );

  /// `cloud-drizzle.mjs`
  static const LucideGlyph cloudDrizzle = LucideGlyph(
    'cloud-drizzle',
    <IconElement>[
      IconPathElement(
        'M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242',
      ), // key: 1pljnt
      IconPathElement('M8 19v1'), // key: 1dk2by
      IconPathElement('M8 14v1'), // key: 84yxot
      IconPathElement('M16 19v1'), // key: v220m7
      IconPathElement('M16 14v1'), // key: g12gj6
      IconPathElement('M12 21v1'), // key: q8vafk
      IconPathElement('M12 16v1'), // key: 1mx6rx
    ],
  );

  /// `cloud-fog.mjs`
  static const LucideGlyph cloudFog = LucideGlyph('cloud-fog', <IconElement>[
    IconPathElement(
      'M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242',
    ), // key: 1pljnt
    IconPathElement('M16 17H7'), // key: pygtm1
    IconPathElement('M17 21H9'), // key: 1u2q02
  ]);

  /// `cloud-hail.mjs`
  static const LucideGlyph cloudHail = LucideGlyph('cloud-hail', <IconElement>[
    IconPathElement(
      'M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242',
    ), // key: 1pljnt
    IconPathElement('M16 14v2'), // key: a1is7l
    IconPathElement('M8 14v2'), // key: 1e9m6t
    IconPathElement('M16 20h.01'), // key: xwek51
    IconPathElement('M8 20h.01'), // key: 1vjney
    IconPathElement('M12 16v2'), // key: z66u1j
    IconPathElement('M12 22h.01'), // key: 1urd7a
  ]);

  /// `cloud-lightning.mjs`
  static const LucideGlyph cloudLightning = LucideGlyph(
    'cloud-lightning',
    <IconElement>[
      IconPathElement(
        'M6 16.326A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 .5 8.973',
      ), // key: 1cez44
      IconPathElement('m13 12-3 5h4l-3 5'), // key: 1t22er
    ],
  );

  /// `cloud-moon-rain.mjs`
  static const LucideGlyph
  cloudMoonRain = LucideGlyph('cloud-moon-rain', <IconElement>[
    IconPathElement('M11 20v2'), // key: 174qtz
    IconPathElement(
      'M18.376 14.512a6 6 0 0 0 3.461-4.127c.148-.625-.659-.97-1.248-.714a4 4 0 0 1-5.259-5.26c.255-.589-.09-1.395-.716-1.248a6 6 0 0 0-4.594 5.36',
    ), // key: zwnc1e
    IconPathElement('M3 20a5 5 0 1 1 8.9-4H13a3 3 0 0 1 2 5.24'), // key: 1qmrp3
    IconPathElement('M7 19v2'), // key: 12npes
  ]);

  /// `cloud-moon.mjs`
  static const LucideGlyph cloudMoon = LucideGlyph('cloud-moon', <IconElement>[
    IconPathElement('M13 16a3 3 0 0 1 0 6H7a5 5 0 1 1 4.9-6z'), // key: ie2ih4
    IconPathElement(
      'M18.376 14.512a6 6 0 0 0 3.461-4.127c.148-.625-.659-.97-1.248-.714a4 4 0 0 1-5.259-5.26c.255-.589-.09-1.395-.716-1.248a6 6 0 0 0-4.594 5.36',
    ), // key: zwnc1e
  ]);

  /// `cloud-off.mjs`
  static const LucideGlyph cloudOff = LucideGlyph('cloud-off', <IconElement>[
    IconPathElement(
      'M10.94 5.274A7 7 0 0 1 15.71 10h1.79a4.5 4.5 0 0 1 4.222 6.057',
    ), // key: 1uxyv8
    IconPathElement(
      'M18.796 18.81A4.5 4.5 0 0 1 17.5 19H9A7 7 0 0 1 5.79 5.78',
    ), // key: 99tcn7
    IconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `cloud-rain-wind.mjs`
  static const LucideGlyph cloudRainWind = LucideGlyph(
    'cloud-rain-wind',
    <IconElement>[
      IconPathElement(
        'M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242',
      ), // key: 1pljnt
      IconPathElement('m9.2 22 3-7'), // key: sb5f6j
      IconPathElement('m9 13-3 7'), // key: 500co5
      IconPathElement('m17 13-3 7'), // key: 8t2fiy
    ],
  );

  /// `cloud-rain.mjs`
  static const LucideGlyph cloudRain = LucideGlyph('cloud-rain', <IconElement>[
    IconPathElement(
      'M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242',
    ), // key: 1pljnt
    IconPathElement('M16 14v6'), // key: 1j4efv
    IconPathElement('M8 14v6'), // key: 17c4r9
    IconPathElement('M12 16v6'), // key: c8a4gj
  ]);

  /// `cloud-snow.mjs`
  static const LucideGlyph cloudSnow = LucideGlyph('cloud-snow', <IconElement>[
    IconPathElement(
      'M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242',
    ), // key: 1pljnt
    IconPathElement('M8 15h.01'), // key: a7atzg
    IconPathElement('M8 19h.01'), // key: puxtts
    IconPathElement('M12 17h.01'), // key: p32p05
    IconPathElement('M12 21h.01'), // key: h35vbk
    IconPathElement('M16 15h.01'), // key: rnfrdf
    IconPathElement('M16 19h.01'), // key: 1vcnzz
  ]);

  /// `cloud-sun-rain.mjs`
  static const LucideGlyph
  cloudSunRain = LucideGlyph('cloud-sun-rain', <IconElement>[
    IconPathElement('M12 2v2'), // key: tus03m
    IconPathElement('m4.93 4.93 1.41 1.41'), // key: 149t6j
    IconPathElement('M20 12h2'), // key: 1q8mjw
    IconPathElement('m19.07 4.93-1.41 1.41'), // key: 1shlcs
    IconPathElement('M15.947 12.65a4 4 0 0 0-5.925-4.128'), // key: dpwdj0
    IconPathElement('M3 20a5 5 0 1 1 8.9-4H13a3 3 0 0 1 2 5.24'), // key: 1qmrp3
    IconPathElement('M11 20v2'), // key: 174qtz
    IconPathElement('M7 19v2'), // key: 12npes
  ]);

  /// `cloud-sun.mjs`
  static const LucideGlyph cloudSun = LucideGlyph('cloud-sun', <IconElement>[
    IconPathElement('M12 2v2'), // key: tus03m
    IconPathElement('m4.93 4.93 1.41 1.41'), // key: 149t6j
    IconPathElement('M20 12h2'), // key: 1q8mjw
    IconPathElement('m19.07 4.93-1.41 1.41'), // key: 1shlcs
    IconPathElement('M15.947 12.65a4 4 0 0 0-5.925-4.128'), // key: dpwdj0
    IconPathElement(
      'M13 22H7a5 5 0 1 1 4.9-6H13a3 3 0 0 1 0 6Z',
    ), // key: s09mg5
  ]);

  /// `cloud-sync.mjs`
  static const LucideGlyph cloudSync = LucideGlyph('cloud-sync', <IconElement>[
    IconPathElement('m17 18-1.535 1.605a5 5 0 0 1-8-1.5'), // key: adpv5j
    IconPathElement('M17 22v-4h-4'), // key: ex1ofj
    IconPathElement(
      'M20.996 15.251A4.5 4.5 0 0 0 17.495 8h-1.79a7 7 0 1 0-12.709 5.607',
    ), // key: ziqt14
    IconPathElement('M7 10v4h4'), // key: 1j6gx1
    IconPathElement('m7 14 1.535-1.605a5 5 0 0 1 8 1.5'), // key: 19q5h7
  ]);

  /// `cloud-upload.mjs`
  static const LucideGlyph cloudUpload = LucideGlyph(
    'cloud-upload',
    <IconElement>[
      IconPathElement('M12 13v8'), // key: 1l5pq0
      IconPathElement(
        'M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242',
      ), // key: 1pljnt
      IconPathElement('m8 17 4-4 4 4'), // key: 1quai1
    ],
  );

  /// `cloud.mjs`
  static const LucideGlyph cloud = LucideGlyph('cloud', <IconElement>[
    IconPathElement(
      'M17.5 19H9a7 7 0 1 1 6.71-9h1.79a4.5 4.5 0 1 1 0 9Z',
    ), // key: p7xjir
  ]);

  /// `cloudy.mjs`
  static const LucideGlyph cloudy = LucideGlyph('cloudy', <IconElement>[
    IconPathElement(
      'M17.5 12a1 1 0 1 1 0 9H9.006a7 7 0 1 1 6.702-9z',
    ), // key: 44yre2
    IconPathElement(
      'M21.832 9A3 3 0 0 0 19 7h-2.207a5.5 5.5 0 0 0-10.72.61',
    ), // key: leugyv
  ]);

  /// `clover.mjs`
  static const LucideGlyph clover = LucideGlyph('clover', <IconElement>[
    IconPathElement('M16.17 7.83 2 22'), // key: t58vo8
    IconPathElement(
      'M4.02 12a2.827 2.827 0 1 1 3.81-4.17A2.827 2.827 0 1 1 12 4.02a2.827 2.827 0 1 1 4.17 3.81A2.827 2.827 0 1 1 19.98 12a2.827 2.827 0 1 1-3.81 4.17A2.827 2.827 0 1 1 12 19.98a2.827 2.827 0 1 1-4.17-3.81A1 1 0 1 1 4 12',
    ), // key: 17k36q
    IconPathElement('m7.83 7.83 8.34 8.34'), // key: 1d7sxk
  ]);

  /// `club.mjs`
  static const LucideGlyph club = LucideGlyph('club', <IconElement>[
    IconPathElement(
      'M17.28 9.05a5.5 5.5 0 1 0-10.56 0A5.5 5.5 0 1 0 12 17.66a5.5 5.5 0 1 0 5.28-8.6Z',
    ), // key: 27yuqz
    IconPathElement('M12 17.66L12 22'), // key: ogfahf
  ]);

  /// `code-xml.mjs`
  static const LucideGlyph codeXml = LucideGlyph('code-xml', <IconElement>[
    IconPathElement('m18 16 4-4-4-4'), // key: 1inbqp
    IconPathElement('m6 8-4 4 4 4'), // key: 15zrgr
    IconPathElement('m14.5 4-5 16'), // key: e7oirm
  ]);

  /// `code.mjs`
  static const LucideGlyph code = LucideGlyph('code', <IconElement>[
    IconPathElement('m16 18 6-6-6-6'), // key: eg8j8
    IconPathElement('m8 6-6 6 6 6'), // key: ppft3o
  ]);

  /// `coffee.mjs`
  static const LucideGlyph coffee = LucideGlyph('coffee', <IconElement>[
    IconPathElement('M10 2v2'), // key: 7u0qdc
    IconPathElement('M14 2v2'), // key: 6buw04
    IconPathElement(
      'M16 8a1 1 0 0 1 1 1v8a4 4 0 0 1-4 4H7a4 4 0 0 1-4-4V9a1 1 0 0 1 1-1h14a4 4 0 1 1 0 8h-1',
    ), // key: pwadti
    IconPathElement('M6 2v2'), // key: colzsn
  ]);

  /// `cog.mjs`
  static const LucideGlyph cog = LucideGlyph('cog', <IconElement>[
    IconPathElement('M11 10.27 7 3.34'), // key: 16pf9h
    IconPathElement('m11 13.73-4 6.93'), // key: 794ttg
    IconPathElement('M12 22v-2'), // key: 1osdcq
    IconPathElement('M12 2v2'), // key: tus03m
    IconPathElement('M14 12h8'), // key: 4f43i9
    IconPathElement('m17 20.66-1-1.73'), // key: eq3orb
    IconPathElement('m17 3.34-1 1.73'), // key: 2wel8s
    IconPathElement('M2 12h2'), // key: 1t8f8n
    IconPathElement('m20.66 17-1.73-1'), // key: sg0v6f
    IconPathElement('m20.66 7-1.73 1'), // key: 1ow05n
    IconPathElement('m3.34 17 1.73-1'), // key: nuk764
    IconPathElement('m3.34 7 1.73 1'), // key: 1ulond
    IconCircleElement(12, 12, 2), // key: 1c9p78
    IconCircleElement(12, 12, 8), // key: 46899m
  ]);

  /// `coins.mjs`
  static const LucideGlyph coins = LucideGlyph('coins', <IconElement>[
    IconPathElement('M13.744 17.736a6 6 0 1 1-7.48-7.48'), // key: bq4yh3
    IconPathElement('M15 6h1v4'), // key: 11y1tn
    IconPathElement('m6.134 14.768.866-.5 2 3.464'), // key: 17snzx
    IconCircleElement(16, 8, 6), // key: 14bfc9
  ]);

  /// `columns-2.mjs`
  static const LucideGlyph columns2 = LucideGlyph('columns-2', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    IconPathElement('M12 3v18'), // key: 108xh3
  ]);

  /// `columns-3-cog.mjs`
  static const LucideGlyph columns3Cog = LucideGlyph(
    'columns-3-cog',
    <IconElement>[
      IconPathElement(
        'M10.6 21H5a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v5.6',
      ), // key: 19s2bv
      IconPathElement('m14.305 19.53.923-.382'), // key: 3m78fa
      IconPathElement('M15 3v7.6'), // key: mv9izd
      IconPathElement('m15.229 16.852-.924-.383'), // key: qpfz85
      IconPathElement('m16.852 15.228-.383-.923'), // key: 5xggr7
      IconPathElement('m16.852 20.772-.383.924'), // key: dpfhf9
      IconPathElement('m19.148 15.228.383-.923'), // key: 1reyyz
      IconPathElement('m19.53 21.696-.382-.924'), // key: 1goivc
      IconPathElement('m20.773 16.852.922-.383'), // key: 59dfo2
      IconPathElement('m20.773 19.148.922.383'), // key: 1lk755
      IconPathElement('M9 3v18'), // key: fh3hqa
      IconCircleElement(18, 18, 3), // key: 1xkwt0
    ],
  );

  /// `columns-3.mjs`
  static const LucideGlyph columns3 = LucideGlyph('columns-3', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    IconPathElement('M9 3v18'), // key: fh3hqa
    IconPathElement('M15 3v18'), // key: 14nvp0
  ]);

  /// `columns-4.mjs`
  static const LucideGlyph columns4 = LucideGlyph('columns-4', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    IconPathElement('M7.5 3v18'), // key: w0wo6v
    IconPathElement('M12 3v18'), // key: 108xh3
    IconPathElement('M16.5 3v18'), // key: 10tjh1
  ]);

  /// `combine.mjs`
  static const LucideGlyph combine = LucideGlyph('combine', <IconElement>[
    IconPathElement('M14 3a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1'), // key: 1l7d7l
    IconPathElement('M19 3a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1'), // key: 9955pe
    IconPathElement('m7 15 3 3'), // key: 4hkfgk
    IconPathElement('m7 21 3-3H5a2 2 0 0 1-2-2v-2'), // key: 1xljwe
    IconRectElement(14, 14, 7, 7, 1), // key: 1cdgtw
    IconRectElement(3, 3, 7, 7, 1), // key: zi3rio
  ]);

  /// `command.mjs`
  static const LucideGlyph command = LucideGlyph('command', <IconElement>[
    IconPathElement(
      'M15 6v12a3 3 0 1 0 3-3H6a3 3 0 1 0 3 3V6a3 3 0 1 0-3 3h12a3 3 0 1 0-3-3',
    ), // key: 11bfej
  ]);

  /// `compass.mjs`
  static const LucideGlyph compass = LucideGlyph('compass', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement(
      'm16.24 7.76-1.804 5.411a2 2 0 0 1-1.265 1.265L7.76 16.24l1.804-5.411a2 2 0 0 1 1.265-1.265z',
    ), // key: 9ktpf1
  ]);

  /// `component.mjs`
  static const LucideGlyph component = LucideGlyph('component', <IconElement>[
    IconPathElement(
      'M15.536 11.293a1 1 0 0 0 0 1.414l2.376 2.377a1 1 0 0 0 1.414 0l2.377-2.377a1 1 0 0 0 0-1.414l-2.377-2.377a1 1 0 0 0-1.414 0z',
    ), // key: 1uwlt4
    IconPathElement(
      'M2.297 11.293a1 1 0 0 0 0 1.414l2.377 2.377a1 1 0 0 0 1.414 0l2.377-2.377a1 1 0 0 0 0-1.414L6.088 8.916a1 1 0 0 0-1.414 0z',
    ), // key: 10291m
    IconPathElement(
      'M8.916 17.912a1 1 0 0 0 0 1.415l2.377 2.376a1 1 0 0 0 1.414 0l2.377-2.376a1 1 0 0 0 0-1.415l-2.377-2.376a1 1 0 0 0-1.414 0z',
    ), // key: 1tqoq1
    IconPathElement(
      'M8.916 4.674a1 1 0 0 0 0 1.414l2.377 2.376a1 1 0 0 0 1.414 0l2.377-2.376a1 1 0 0 0 0-1.414l-2.377-2.377a1 1 0 0 0-1.414 0z',
    ), // key: 1x6lto
  ]);

  /// `computer.mjs`
  static const LucideGlyph computer = LucideGlyph('computer', <IconElement>[
    IconRectElement(5, 2, 14, 8, 2), // key: wc9tft
    IconRectElement(2, 14, 20, 8, 2), // key: w68u3i
    IconPathElement('M6 18h2'), // key: rwmk9e
    IconPathElement('M12 18h6'), // key: aqd8w3
  ]);

  /// `concierge-bell.mjs`
  static const LucideGlyph
  conciergeBell = LucideGlyph('concierge-bell', <IconElement>[
    IconPathElement(
      'M3 20a1 1 0 0 1-1-1v-1a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1Z',
    ), // key: 1pvr1r
    IconPathElement('M20 16a8 8 0 1 0-16 0'), // key: 1pa543
    IconPathElement('M12 4v4'), // key: 1bq03y
    IconPathElement('M10 4h4'), // key: 1xpv9s
  ]);

  /// `cone.mjs`
  static const LucideGlyph cone = LucideGlyph('cone', <IconElement>[
    IconPathElement(
      'm20.9 18.55-8-15.98a1 1 0 0 0-1.8 0l-8 15.98',
    ), // key: 53pte7
    IconEllipseElement(12, 19, 9, 3), // key: 1ji25f
  ]);

  /// `construction.mjs`
  static const LucideGlyph construction = LucideGlyph(
    'construction',
    <IconElement>[
      IconRectElement(2, 6, 20, 8, 1), // key: 1estib
      IconPathElement('M17 14v7'), // key: 7m2elx
      IconPathElement('M7 14v7'), // key: 1cm7wv
      IconPathElement('M17 3v3'), // key: 1v4jwn
      IconPathElement('M7 3v3'), // key: 7o6guu
      IconPathElement('M10 14 2.3 6.3'), // key: 1023jk
      IconPathElement('m14 6 7.7 7.7'), // key: 1s8pl2
      IconPathElement('m8 6 8 8'), // key: hl96qh
    ],
  );

  /// `contact-round.mjs`
  static const LucideGlyph contactRound = LucideGlyph(
    'contact-round',
    <IconElement>[
      IconPathElement('M16 2v2'), // key: scm5qe
      IconPathElement('M17.915 21a6 6 0 10-12 0'), // key: 13n4mv
      IconPathElement('M8 2v2'), // key: pbkmx
      IconCircleElement(12, 11, 4), // key: 1gt34v
      IconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `contact.mjs`
  static const LucideGlyph contact = LucideGlyph('contact', <IconElement>[
    IconPathElement('M16 2v2'), // key: scm5qe
    IconPathElement('M7 21v-2a2 2 0 012-2h6a2 2 0 012 2v2'), // key: k82dct
    IconPathElement('M8 2v2'), // key: pbkmx
    IconCircleElement(12, 10, 3), // key: ilqhr7
    IconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `container.mjs`
  static const LucideGlyph container = LucideGlyph('container', <IconElement>[
    IconPathElement(
      'M22 7.7c0-.6-.4-1.2-.8-1.5l-6.3-3.9a1.72 1.72 0 0 0-1.7 0l-10.3 6c-.5.2-.9.8-.9 1.4v6.6c0 .5.4 1.2.8 1.5l6.3 3.9a1.72 1.72 0 0 0 1.7 0l10.3-6c.5-.3.9-1 .9-1.5Z',
    ), // key: 1t2lqe
    IconPathElement('M10 21.9V14L2.1 9.1'), // key: o7czzq
    IconPathElement('m10 14 11.9-6.9'), // key: zm5e20
    IconPathElement('M14 19.8v-8.1'), // key: 159ecu
    IconPathElement('M18 17.5V9.4'), // key: 11uown
  ]);

  /// `contrast.mjs`
  static const LucideGlyph contrast = LucideGlyph('contrast', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M12 18a6 6 0 0 0 0-12v12z'), // key: j4l70d
  ]);

  /// `cookie.mjs`
  static const LucideGlyph cookie = LucideGlyph('cookie', <IconElement>[
    IconPathElement(
      'M12 2a10 10 0 1 0 10 10 4 4 0 0 1-5-5 4 4 0 0 1-5-5',
    ), // key: laymnq
    IconPathElement('M8.5 8.5v.01'), // key: ue8clq
    IconPathElement('M16 15.5v.01'), // key: 14dtrp
    IconPathElement('M12 12v.01'), // key: u5ubse
    IconPathElement('M11 17v.01'), // key: 1hyl5a
    IconPathElement('M7 14v.01'), // key: uct60s
  ]);

  /// `cooking-pot.mjs`
  static const LucideGlyph
  cookingPot = LucideGlyph('cooking-pot', <IconElement>[
    IconPathElement('M2 12h20'), // key: 9i4pu4
    IconPathElement('M20 12v8a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-8'), // key: u0tga0
    IconPathElement('m4 8 16-4'), // key: 16g0ng
    IconPathElement(
      'm8.86 6.78-.45-1.81a2 2 0 0 1 1.45-2.43l1.94-.48a2 2 0 0 1 2.43 1.46l.45 1.8',
    ), // key: 12cejc
  ]);

  /// `copy-check.mjs`
  static const LucideGlyph copyCheck = LucideGlyph('copy-check', <IconElement>[
    IconPathElement('m12 15 2 2 4-4'), // key: 2c609p
    IconRectElement(8, 8, 14, 14, 2, ry: 2), // key: 17jyea
    IconPathElement(
      'M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2',
    ), // key: zix9uf
  ]);

  /// `copy-minus.mjs`
  static const LucideGlyph copyMinus = LucideGlyph('copy-minus', <IconElement>[
    IconLineElement(12, 15, 18, 15), // key: 1nscbv
    IconRectElement(8, 8, 14, 14, 2, ry: 2), // key: 17jyea
    IconPathElement(
      'M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2',
    ), // key: zix9uf
  ]);

  /// `copy-plus.mjs`
  static const LucideGlyph copyPlus = LucideGlyph('copy-plus', <IconElement>[
    IconLineElement(15, 12, 15, 18), // key: 1p7wdc
    IconLineElement(12, 15, 18, 15), // key: 1nscbv
    IconRectElement(8, 8, 14, 14, 2, ry: 2), // key: 17jyea
    IconPathElement(
      'M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2',
    ), // key: zix9uf
  ]);

  /// `copy-slash.mjs`
  static const LucideGlyph copySlash = LucideGlyph('copy-slash', <IconElement>[
    IconLineElement(12, 18, 18, 12), // key: ebkxgr
    IconRectElement(8, 8, 14, 14, 2, ry: 2), // key: 17jyea
    IconPathElement(
      'M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2',
    ), // key: zix9uf
  ]);

  /// `copy-x.mjs`
  static const LucideGlyph copyX = LucideGlyph('copy-x', <IconElement>[
    IconLineElement(12, 12, 18, 18), // key: 1rg63v
    IconLineElement(12, 18, 18, 12), // key: ebkxgr
    IconRectElement(8, 8, 14, 14, 2, ry: 2), // key: 17jyea
    IconPathElement(
      'M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2',
    ), // key: zix9uf
  ]);

  /// `copy.mjs`
  static const LucideGlyph copy = LucideGlyph('copy', <IconElement>[
    IconRectElement(8, 8, 14, 14, 2, ry: 2), // key: 17jyea
    IconPathElement(
      'M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2',
    ), // key: zix9uf
  ]);

  /// `copyleft.mjs`
  static const LucideGlyph copyleft = LucideGlyph('copyleft', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M9.17 14.83a4 4 0 1 0 0-5.66'), // key: 1sveal
  ]);

  /// `copyright.mjs`
  static const LucideGlyph copyright = LucideGlyph('copyright', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M14.83 14.83a4 4 0 1 1 0-5.66'), // key: 1i56pz
  ]);

  /// `corner-down-left.mjs`
  static const LucideGlyph cornerDownLeft = LucideGlyph(
    'corner-down-left',
    <IconElement>[
      IconPathElement('M20 4v7a4 4 0 0 1-4 4H4'), // key: 6o5b7l
      IconPathElement('m9 10-5 5 5 5'), // key: 1kshq7
    ],
  );

  /// `corner-down-right.mjs`
  static const LucideGlyph cornerDownRight = LucideGlyph(
    'corner-down-right',
    <IconElement>[
      IconPathElement('m15 10 5 5-5 5'), // key: qqa56n
      IconPathElement('M4 4v7a4 4 0 0 0 4 4h12'), // key: z08zvw
    ],
  );

  /// `corner-left-down.mjs`
  static const LucideGlyph cornerLeftDown = LucideGlyph(
    'corner-left-down',
    <IconElement>[
      IconPathElement('m14 15-5 5-5-5'), // key: 1eia93
      IconPathElement('M20 4h-7a4 4 0 0 0-4 4v12'), // key: nbpdq2
    ],
  );

  /// `corner-left-up.mjs`
  static const LucideGlyph cornerLeftUp = LucideGlyph(
    'corner-left-up',
    <IconElement>[
      IconPathElement('M14 9 9 4 4 9'), // key: 1af5af
      IconPathElement('M20 20h-7a4 4 0 0 1-4-4V4'), // key: 1blwi3
    ],
  );

  /// `corner-right-down.mjs`
  static const LucideGlyph cornerRightDown = LucideGlyph(
    'corner-right-down',
    <IconElement>[
      IconPathElement('m10 15 5 5 5-5'), // key: 1hpjnr
      IconPathElement('M4 4h7a4 4 0 0 1 4 4v12'), // key: wcbgct
    ],
  );

  /// `corner-right-up.mjs`
  static const LucideGlyph cornerRightUp = LucideGlyph(
    'corner-right-up',
    <IconElement>[
      IconPathElement('m10 9 5-5 5 5'), // key: 9ctzwi
      IconPathElement('M4 20h7a4 4 0 0 0 4-4V4'), // key: 1plgdj
    ],
  );

  /// `corner-up-left.mjs`
  static const LucideGlyph cornerUpLeft = LucideGlyph(
    'corner-up-left',
    <IconElement>[
      IconPathElement('M20 20v-7a4 4 0 0 0-4-4H4'), // key: 1nkjon
      IconPathElement('M9 14 4 9l5-5'), // key: 102s5s
    ],
  );

  /// `corner-up-right.mjs`
  static const LucideGlyph cornerUpRight = LucideGlyph(
    'corner-up-right',
    <IconElement>[
      IconPathElement('m15 14 5-5-5-5'), // key: 12vg1m
      IconPathElement('M4 20v-7a4 4 0 0 1 4-4h12'), // key: 1lu4f8
    ],
  );

  /// `cpu.mjs`
  static const LucideGlyph cpu = LucideGlyph('cpu', <IconElement>[
    IconPathElement('M12 20v2'), // key: 1lh1kg
    IconPathElement('M12 2v2'), // key: tus03m
    IconPathElement('M17 20v2'), // key: 1rnc9c
    IconPathElement('M17 2v2'), // key: 11trls
    IconPathElement('M2 12h2'), // key: 1t8f8n
    IconPathElement('M2 17h2'), // key: 7oei6x
    IconPathElement('M2 7h2'), // key: asdhe0
    IconPathElement('M20 12h2'), // key: 1q8mjw
    IconPathElement('M20 17h2'), // key: 1fpfkl
    IconPathElement('M20 7h2'), // key: 1o8tra
    IconPathElement('M7 20v2'), // key: 4gnj0m
    IconPathElement('M7 2v2'), // key: 1i4yhu
    IconRectElement(4, 4, 16, 16, 2), // key: 1vbyd7
    IconRectElement(8, 8, 8, 8, 1), // key: z9xiuo
  ]);

  /// `creative-commons.mjs`
  static const LucideGlyph creativeCommons = LucideGlyph(
    'creative-commons',
    <IconElement>[
      IconCircleElement(12, 12, 10), // key: 1mglay
      IconPathElement(
        'M10 9.3a2.8 2.8 0 0 0-3.5 1 3.1 3.1 0 0 0 0 3.4 2.7 2.7 0 0 0 3.5 1',
      ), // key: 1ss3eq
      IconPathElement(
        'M17 9.3a2.8 2.8 0 0 0-3.5 1 3.1 3.1 0 0 0 0 3.4 2.7 2.7 0 0 0 3.5 1',
      ), // key: 1od56t
    ],
  );

  /// `credit-card.mjs`
  static const LucideGlyph creditCard = LucideGlyph(
    'credit-card',
    <IconElement>[
      IconRectElement(2, 5, 20, 14, 2), // key: ynyp8z
      IconLineElement(2, 10, 22, 10), // key: 1b3vmo
    ],
  );

  /// `croissant.mjs`
  static const LucideGlyph croissant = LucideGlyph('croissant', <IconElement>[
    IconPathElement(
      'M10.2 18H4.774a1.5 1.5 0 0 1-1.352-.97 11 11 0 0 1 .132-6.487',
    ), // key: 14kkz9
    IconPathElement(
      'M18 10.2V4.774a1.5 1.5 0 0 0-.97-1.352 11 11 0 0 0-6.486.132',
    ), // key: 1g7v07
    IconPathElement(
      'M18 5a4 3 0 0 1 4 3 2 2 0 0 1-2 2 10 10 0 0 0-5.139 1.42',
    ), // key: ratg6b
    IconPathElement(
      'M5 18a3 4 0 0 0 3 4 2 2 0 0 0 2-2 10 10 0 0 1 1.42-5.14',
    ), // key: 4454f0
    IconPathElement(
      'M8.709 2.554a10 10 0 0 0-6.155 6.155 1.5 1.5 0 0 0 .676 1.626l9.807 5.42a2 2 0 0 0 2.718-2.718l-5.42-9.807a1.5 1.5 0 0 0-1.626-.676',
    ), // key: qmemie
  ]);

  /// `crop.mjs`
  static const LucideGlyph crop = LucideGlyph('crop', <IconElement>[
    IconPathElement('M6 2v14a2 2 0 0 0 2 2h14'), // key: ron5a4
    IconPathElement('M18 22V8a2 2 0 0 0-2-2H2'), // key: 7s9ehn
  ]);

  /// `cross.mjs`
  static const LucideGlyph cross = LucideGlyph('cross', <IconElement>[
    IconPathElement(
      'M4 9a2 2 0 0 0-2 2v2a2 2 0 0 0 2 2h4a1 1 0 0 1 1 1v4a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2v-4a1 1 0 0 1 1-1h4a2 2 0 0 0 2-2v-2a2 2 0 0 0-2-2h-4a1 1 0 0 1-1-1V4a2 2 0 0 0-2-2h-2a2 2 0 0 0-2 2v4a1 1 0 0 1-1 1z',
    ), // key: 1xbrqy
  ]);

  /// `crosshair.mjs`
  static const LucideGlyph crosshair = LucideGlyph('crosshair', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconLineElement(22, 12, 18, 12), // key: l9bcsi
    IconLineElement(6, 12, 2, 12), // key: 13hhkx
    IconLineElement(12, 6, 12, 2), // key: 10w3f3
    IconLineElement(12, 22, 12, 18), // key: 15g9kq
  ]);

  /// `crown.mjs`
  static const LucideGlyph crown = LucideGlyph('crown', <IconElement>[
    IconPathElement(
      'M11.562 3.266a.5.5 0 0 1 .876 0L15.39 8.87a1 1 0 0 0 1.516.294L21.183 5.5a.5.5 0 0 1 .798.519l-2.834 10.246a1 1 0 0 1-.956.734H5.81a1 1 0 0 1-.957-.734L2.02 6.02a.5.5 0 0 1 .798-.519l4.276 3.664a1 1 0 0 0 1.516-.294z',
    ), // key: 1vdc57
    IconPathElement('M5 21h14'), // key: 11awu3
  ]);

  /// `cuboid.mjs`
  static const LucideGlyph cuboid = LucideGlyph('cuboid', <IconElement>[
    IconPathElement('M10 22v-8'), // key: 1f8443
    IconPathElement('M2.336 8.89 10 14l11.715-7.029'), // key: 1qnufy
    IconPathElement(
      'M22 14a2 2 0 0 1-.971 1.715l-10 6a2 2 0 0 1-2.138-.05l-6-4A2 2 0 0 1 2 16v-6a2 2 0 0 1 .971-1.715l10-6a2 2 0 0 1 2.138.05l6 4A2 2 0 0 1 22 8z',
    ), // key: 670npk
  ]);

  /// `cup-soda.mjs`
  static const LucideGlyph cupSoda = LucideGlyph('cup-soda', <IconElement>[
    IconPathElement(
      'm6 8 1.75 12.28a2 2 0 0 0 2 1.72h4.54a2 2 0 0 0 2-1.72L18 8',
    ), // key: 8166m8
    IconPathElement('M5 8h14'), // key: pcz4l3
    IconPathElement(
      'M7 15a6.47 6.47 0 0 1 5 0 6.47 6.47 0 0 0 5 0',
    ), // key: yjz344
    IconPathElement('m12 8 1-6h2'), // key: 3ybfa4
  ]);

  /// `currency.mjs`
  static const LucideGlyph currency = LucideGlyph('currency', <IconElement>[
    IconCircleElement(12, 12, 8), // key: 46899m
    IconLineElement(3, 3, 6, 6), // key: 1jkytn
    IconLineElement(21, 3, 18, 6), // key: 14zfjt
    IconLineElement(3, 21, 6, 18), // key: iusuec
    IconLineElement(21, 21, 18, 18), // key: yj2dd7
  ]);

  /// `cylinder.mjs`
  static const LucideGlyph cylinder = LucideGlyph('cylinder', <IconElement>[
    IconEllipseElement(12, 5, 9, 3), // key: msslwz
    IconPathElement('M3 5v14a9 3 0 0 0 18 0V5'), // key: aqi0yr
  ]);

  /// `dam.mjs`
  static const LucideGlyph dam = LucideGlyph('dam', <IconElement>[
    IconPathElement(
      'M11 11.31c1.17.56 1.54 1.69 3.5 1.69 2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1',
    ), // key: 157kva
    IconPathElement(
      'M11.75 18c.35.5 1.45 1 2.75 1 2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1',
    ), // key: d7q6m6
    IconPathElement('M2 10h4'), // key: l0bgd4
    IconPathElement('M2 14h4'), // key: 1gsvsf
    IconPathElement('M2 18h4'), // key: 1bu2t1
    IconPathElement('M2 6h4'), // key: aawbzj
    IconPathElement(
      'M7 3a1 1 0 0 0-1 1v16a1 1 0 0 0 1 1h4a1 1 0 0 0 1-1L10 4a1 1 0 0 0-1-1z',
    ), // key: pr6s65
  ]);

  /// `database-arrow-down.mjs`
  static const LucideGlyph databaseArrowDown = LucideGlyph(
    'database-arrow-down',
    <IconElement>[
      IconPathElement('m16 19 3 3 3-3'), // key: 1ibux0
      IconPathElement('M19 16v6'), // key: tddt3s
      IconPathElement('M21 12.536V5'), // key: zeza6i
      IconPathElement('M3 12A9 3 0 0 0 15.182 14.806'), // key: 11e5wb
      IconPathElement('M3 5V19A9 3 0 0 0 13.318 21.968'), // key: 1lyu4j
      IconEllipseElement(12, 5, 9, 3), // key: msslwz
    ],
  );

  /// `database-arrow-up.mjs`
  static const LucideGlyph databaseArrowUp = LucideGlyph(
    'database-arrow-up',
    <IconElement>[
      IconPathElement('M19 22v-6'), // key: qhmiwi
      IconPathElement('M21 12.536V5'), // key: zeza6i
      IconPathElement('m22 19-3-3-3 3'), // key: rn6bg2
      IconPathElement('M3 12A9 3 0 0 0 14.457 14.886'), // key: 1941vg
      IconPathElement('M3 5V19A9 3 0 0 0 13.318 21.968'), // key: 1lyu4j
      IconEllipseElement(12, 5, 9, 3), // key: msslwz
    ],
  );

  /// `database-backup.mjs`
  static const LucideGlyph
  databaseBackup = LucideGlyph('database-backup', <IconElement>[
    IconEllipseElement(12, 5, 9, 3), // key: msslwz
    IconPathElement('M3 12a9 3 0 0 0 5 2.69'), // key: 1ui2ym
    IconPathElement('M21 9.3V5'), // key: 6k6cib
    IconPathElement('M3 5v14a9 3 0 0 0 6.47 2.88'), // key: i62tjy
    IconPathElement('M12 12v4h4'), // key: 1bxaet
    IconPathElement(
      'M13 20a5 5 0 0 0 9-3 4.5 4.5 0 0 0-4.5-4.5c-1.33 0-2.54.54-3.41 1.41L12 16',
    ), // key: 1f4ei9
  ]);

  /// `database-check.mjs`
  static const LucideGlyph databaseCheck = LucideGlyph(
    'database-check',
    <IconElement>[
      IconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
      IconPathElement('M21 13.127V5'), // key: 59o5vz
      IconPathElement('M3 12A9 3 0 0 0 21 12'), // key: mv7ke4
      IconPathElement('M3 5V19A9 3 0 0 0 13.318 21.968'), // key: 1lyu4j
      IconEllipseElement(12, 5, 9, 3), // key: msslwz
    ],
  );

  /// `database-minus.mjs`
  static const LucideGlyph databaseMinus = LucideGlyph(
    'database-minus',
    <IconElement>[
      IconPathElement('M21 15V5'), // key: 1lbg5w
      IconPathElement('M22 19h-6'), // key: vcuq98
      IconPathElement('M3 12A9 3 0 0 0 21 12'), // key: mv7ke4
      IconPathElement('M3 5V19A9 3 0 0 0 13.318 21.968'), // key: 1lyu4j
      IconEllipseElement(12, 5, 9, 3), // key: msslwz
    ],
  );

  /// `database-plus.mjs`
  static const LucideGlyph databasePlus = LucideGlyph(
    'database-plus',
    <IconElement>[
      IconPathElement('M19 16v6'), // key: tddt3s
      IconPathElement('M21 12.536V5'), // key: zeza6i
      IconPathElement('M22 19h-6'), // key: vcuq98
      IconPathElement('M3 12A9 3 0 0 0 15.1824 14.8061'), // key: ukc3b1
      IconPathElement('M3 5V19A9 3 0 0 0 13.318 21.968'), // key: 1lyu4j
      IconEllipseElement(12, 5, 9, 3), // key: msslwz
    ],
  );

  /// `database-search.mjs`
  static const LucideGlyph databaseSearch = LucideGlyph(
    'database-search',
    <IconElement>[
      IconPathElement('M21 11.693V5'), // key: 175m1t
      IconPathElement('m22 22-1.875-1.875'), // key: 13zax7
      IconPathElement('M3 12a9 3 0 0 0 8.697 2.998'), // key: 151u9p
      IconPathElement('M3 5v14a9 3 0 0 0 9.28 2.999'), // key: q2rs2p
      IconCircleElement(18, 18, 3), // key: 1xkwt0
      IconEllipseElement(12, 5, 9, 3), // key: msslwz
    ],
  );

  /// `database-x.mjs`
  static const LucideGlyph databaseX = LucideGlyph('database-x', <IconElement>[
    IconPathElement('m17 17 5 5'), // key: p7ous7
    IconPathElement('M19.323 13.744A9 3 0 0 0 21 12'), // key: hmry77
    IconPathElement('M21 13.127V5'), // key: 59o5vz
    IconPathElement('m22 17-5 5'), // key: gqnmv0
    IconPathElement('M3 12A9 3 0 0 0 13.563 14.954'), // key: 1rmyhq
    IconPathElement('M3 5V19A9 3 0 0 0 13 21.981'), // key: 159k2m
    IconEllipseElement(12, 5, 9, 3), // key: msslwz
  ]);

  /// `database-zap.mjs`
  static const LucideGlyph databaseZap = LucideGlyph(
    'database-zap',
    <IconElement>[
      IconEllipseElement(12, 5, 9, 3), // key: msslwz
      IconPathElement('M3 5V19A9 3 0 0 0 15 21.84'), // key: 14ibmq
      IconPathElement('M21 5V8'), // key: 1marbg
      IconPathElement('M21 12L18 17H22L19 22'), // key: zafso
      IconPathElement('M3 12A9 3 0 0 0 14.59 14.87'), // key: 1y4wr8
    ],
  );

  /// `database.mjs`
  static const LucideGlyph database = LucideGlyph('database', <IconElement>[
    IconEllipseElement(12, 5, 9, 3), // key: msslwz
    IconPathElement('M3 5V19A9 3 0 0 0 21 19V5'), // key: 1wlel7
    IconPathElement('M3 12A9 3 0 0 0 21 12'), // key: mv7ke4
  ]);

  /// `decimals-arrow-left.mjs`
  static const LucideGlyph decimalsArrowLeft = LucideGlyph(
    'decimals-arrow-left',
    <IconElement>[
      IconPathElement('m13 21-3-3 3-3'), // key: s3o1nf
      IconPathElement('M20 18H10'), // key: 14r3mt
      IconPathElement('M3 11h.01'), // key: 1eifu7
      IconRectElement(6, 3, 5, 8, 2.5), // key: v9paqo
    ],
  );

  /// `decimals-arrow-right.mjs`
  static const LucideGlyph decimalsArrowRight = LucideGlyph(
    'decimals-arrow-right',
    <IconElement>[
      IconPathElement('M10 18h10'), // key: 1y5s8o
      IconPathElement('m17 21 3-3-3-3'), // key: 1ammt0
      IconPathElement('M3 11h.01'), // key: 1eifu7
      IconRectElement(15, 3, 5, 8, 2.5), // key: 76md6a
      IconRectElement(6, 3, 5, 8, 2.5), // key: v9paqo
    ],
  );

  /// `delete.mjs`
  static const LucideGlyph delete = LucideGlyph('delete', <IconElement>[
    IconPathElement(
      'M10 5a2 2 0 0 0-1.344.519l-6.328 5.74a1 1 0 0 0 0 1.481l6.328 5.741A2 2 0 0 0 10 19h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2z',
    ), // key: 1yo7s0
    IconPathElement('m12 9 6 6'), // key: anjzzh
    IconPathElement('m18 9-6 6'), // key: 1fp51s
  ]);

  /// `dessert.mjs`
  static const LucideGlyph dessert = LucideGlyph('dessert', <IconElement>[
    IconPathElement(
      'M10.162 3.167A10 10 0 0 0 2 13a2 2 0 0 0 4 0v-1a2 2 0 0 1 4 0v4a2 2 0 0 0 4 0v-4a2 2 0 0 1 4 0v1a2 2 0 0 0 4-.006 10 10 0 0 0-8.161-9.826',
    ), // key: xi88qy
    IconPathElement('M20.804 14.869a9 9 0 0 1-17.608 0'), // key: 1r28rg
    IconCircleElement(12, 4, 2), // key: muu5ef
  ]);

  /// `diameter.mjs`
  static const LucideGlyph diameter = LucideGlyph('diameter', <IconElement>[
    IconCircleElement(19, 19, 2), // key: 17f5cg
    IconCircleElement(5, 5, 2), // key: 1gwv83
    IconPathElement('M6.48 3.66a10 10 0 0 1 13.86 13.86'), // key: xr8kdq
    IconPathElement('m6.41 6.41 11.18 11.18'), // key: uhpjw7
    IconPathElement('M3.66 6.48a10 10 0 0 0 13.86 13.86'), // key: cldpwv
  ]);

  /// `diamond-minus.mjs`
  static const LucideGlyph
  diamondMinus = LucideGlyph('diamond-minus', <IconElement>[
    IconPathElement(
      'M2.7 10.3a2.41 2.41 0 0 0 0 3.41l7.59 7.59a2.41 2.41 0 0 0 3.41 0l7.59-7.59a2.41 2.41 0 0 0 0-3.41L13.7 2.71a2.41 2.41 0 0 0-3.41 0z',
    ), // key: 1ey20j
    IconPathElement('M8 12h8'), // key: 1wcyev
  ]);

  /// `diamond-percent.mjs`
  static const LucideGlyph
  diamondPercent = LucideGlyph('diamond-percent', <IconElement>[
    IconPathElement(
      'M2.7 10.3a2.41 2.41 0 0 0 0 3.41l7.59 7.59a2.41 2.41 0 0 0 3.41 0l7.59-7.59a2.41 2.41 0 0 0 0-3.41L13.7 2.71a2.41 2.41 0 0 0-3.41 0Z',
    ), // key: 1tpxz2
    IconPathElement('M9.2 9.2h.01'), // key: 1b7bvt
    IconPathElement('m14.5 9.5-5 5'), // key: 17q4r4
    IconPathElement('M14.7 14.8h.01'), // key: 17nsh4
  ]);

  /// `diamond-plus.mjs`
  static const LucideGlyph
  diamondPlus = LucideGlyph('diamond-plus', <IconElement>[
    IconPathElement('M12 8v8'), // key: napkw2
    IconPathElement(
      'M2.7 10.3a2.41 2.41 0 0 0 0 3.41l7.59 7.59a2.41 2.41 0 0 0 3.41 0l7.59-7.59a2.41 2.41 0 0 0 0-3.41L13.7 2.71a2.41 2.41 0 0 0-3.41 0z',
    ), // key: 1ey20j
    IconPathElement('M8 12h8'), // key: 1wcyev
  ]);

  /// `diamond.mjs`
  static const LucideGlyph diamond = LucideGlyph('diamond', <IconElement>[
    IconPathElement(
      'M2.7 10.3a2.41 2.41 0 0 0 0 3.41l7.59 7.59a2.41 2.41 0 0 0 3.41 0l7.59-7.59a2.41 2.41 0 0 0 0-3.41l-7.59-7.59a2.41 2.41 0 0 0-3.41 0Z',
    ), // key: 1f1r0c
  ]);

  /// `dice-1.mjs`
  static const LucideGlyph dice1 = LucideGlyph('dice-1', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    IconPathElement('M12 12h.01'), // key: 1mp3jc
  ]);

  /// `dice-2.mjs`
  static const LucideGlyph dice2 = LucideGlyph('dice-2', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    IconPathElement('M15 9h.01'), // key: x1ddxp
    IconPathElement('M9 15h.01'), // key: fzyn71
  ]);

  /// `dice-3.mjs`
  static const LucideGlyph dice3 = LucideGlyph('dice-3', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    IconPathElement('M16 8h.01'), // key: cr5u4v
    IconPathElement('M12 12h.01'), // key: 1mp3jc
    IconPathElement('M8 16h.01'), // key: 18s6g9
  ]);

  /// `dice-4.mjs`
  static const LucideGlyph dice4 = LucideGlyph('dice-4', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    IconPathElement('M16 8h.01'), // key: cr5u4v
    IconPathElement('M8 8h.01'), // key: 1e4136
    IconPathElement('M8 16h.01'), // key: 18s6g9
    IconPathElement('M16 16h.01'), // key: 1f9h7w
  ]);

  /// `dice-5.mjs`
  static const LucideGlyph dice5 = LucideGlyph('dice-5', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    IconPathElement('M16 8h.01'), // key: cr5u4v
    IconPathElement('M8 8h.01'), // key: 1e4136
    IconPathElement('M8 16h.01'), // key: 18s6g9
    IconPathElement('M16 16h.01'), // key: 1f9h7w
    IconPathElement('M12 12h.01'), // key: 1mp3jc
  ]);

  /// `dice-6.mjs`
  static const LucideGlyph dice6 = LucideGlyph('dice-6', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    IconPathElement('M16 8h.01'), // key: cr5u4v
    IconPathElement('M16 12h.01'), // key: 1l6xoz
    IconPathElement('M16 16h.01'), // key: 1f9h7w
    IconPathElement('M8 8h.01'), // key: 1e4136
    IconPathElement('M8 12h.01'), // key: czm47f
    IconPathElement('M8 16h.01'), // key: 18s6g9
  ]);

  /// `dices.mjs`
  static const LucideGlyph dices = LucideGlyph('dices', <IconElement>[
    IconRectElement(2, 10, 12, 12, 2, ry: 2), // key: 6agr2n
    IconPathElement(
      'm17.92 14 3.5-3.5a2.24 2.24 0 0 0 0-3l-5-4.92a2.24 2.24 0 0 0-3 0L10 6',
    ), // key: 1o487t
    IconPathElement('M6 18h.01'), // key: uhywen
    IconPathElement('M10 14h.01'), // key: ssrbsk
    IconPathElement('M15 6h.01'), // key: cblpky
    IconPathElement('M18 9h.01'), // key: 2061c0
  ]);

  /// `diff.mjs`
  static const LucideGlyph diff = LucideGlyph('diff', <IconElement>[
    IconPathElement('M12 3v14'), // key: 7cf3v8
    IconPathElement('M5 10h14'), // key: elsbfy
    IconPathElement('M5 21h14'), // key: 11awu3
  ]);

  /// `disc-2.mjs`
  static const LucideGlyph disc2 = LucideGlyph('disc-2', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconCircleElement(12, 12, 4), // key: 4exip2
    IconPathElement('M12 12h.01'), // key: 1mp3jc
  ]);

  /// `disc-3.mjs`
  static const LucideGlyph disc3 = LucideGlyph('disc-3', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M6 12c0-1.7.7-3.2 1.8-4.2'), // key: oqkarx
    IconCircleElement(12, 12, 2), // key: 1c9p78
    IconPathElement('M18 12c0 1.7-.7 3.2-1.8 4.2'), // key: 1eah9h
  ]);

  /// `disc-album.mjs`
  static const LucideGlyph discAlbum = LucideGlyph('disc-album', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    IconCircleElement(12, 12, 5), // key: nd82uf
    IconPathElement('M12 12h.01'), // key: 1mp3jc
  ]);

  /// `disc.mjs`
  static const LucideGlyph disc = LucideGlyph('disc', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `divide.mjs`
  static const LucideGlyph divide = LucideGlyph('divide', <IconElement>[
    IconCircleElement(12, 6, 1), // key: 1bh7o1
    IconLineElement(5, 12, 19, 12), // key: 13b5wn
    IconCircleElement(12, 18, 1), // key: lqb9t5
  ]);

  /// `dna-off.mjs`
  static const LucideGlyph dnaOff = LucideGlyph('dna-off', <IconElement>[
    IconPathElement('M15 2c-1.35 1.5-2.092 3-2.5 4.5L14 8'), // key: 1bivrr
    IconPathElement('m17 6-2.891-2.891'), // key: xu6p2f
    IconPathElement('M2 15c3.333-3 6.667-3 10-3'), // key: nxix30
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement('m20 9 .891.891'), // key: 3xwk7g
    IconPathElement('M22 9c-1.5 1.35-3 2.092-4.5 2.5l-1-1'), // key: 18cutr
    IconPathElement('M3.109 14.109 4 15'), // key: q76aoh
    IconPathElement('m6.5 12.5 1 1'), // key: cs35ky
    IconPathElement('m7 18 2.891 2.891'), // key: 1sisit
    IconPathElement('M9 22c1.35-1.5 2.092-3 2.5-4.5L10 16'), // key: rlvei3
  ]);

  /// `dna.mjs`
  static const LucideGlyph dna = LucideGlyph('dna', <IconElement>[
    IconPathElement('m10 16 1.5 1.5'), // key: 11lckj
    IconPathElement('m14 8-1.5-1.5'), // key: 1ohn8i
    IconPathElement(
      'M15 2c-1.798 1.998-2.518 3.995-2.807 5.993',
    ), // key: 80uv8i
    IconPathElement('m16.5 10.5 1 1'), // key: 696xn5
    IconPathElement('m17 6-2.891-2.891'), // key: xu6p2f
    IconPathElement('M2 15c6.667-6 13.333 0 20-6'), // key: 1pyr53
    IconPathElement('m20 9 .891.891'), // key: 3xwk7g
    IconPathElement('M3.109 14.109 4 15'), // key: q76aoh
    IconPathElement('m6.5 12.5 1 1'), // key: cs35ky
    IconPathElement('m7 18 2.891 2.891'), // key: 1sisit
    IconPathElement('M9 22c1.798-1.998 2.518-3.995 2.807-5.993'), // key: q3hbxp
  ]);

  /// `dock.mjs`
  static const LucideGlyph dock = LucideGlyph('dock', <IconElement>[
    IconPathElement('M2 8h20'), // key: d11cs7
    IconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
    IconPathElement('M6 16h12'), // key: u522kt
  ]);

  /// `dog.mjs`
  static const LucideGlyph dog = LucideGlyph('dog', <IconElement>[
    IconPathElement('M11.25 16.25h1.5L12 17z'), // key: w7jh35
    IconPathElement('M16 14v.5'), // key: 1lajdz
    IconPathElement(
      'M4.42 11.247A13.152 13.152 0 0 0 4 14.556C4 18.728 7.582 21 12 21s8-2.272 8-6.444a11.702 11.702 0 0 0-.493-3.309',
    ), // key: u7s9ue
    IconPathElement('M8 14v.5'), // key: 1nzgdb
    IconPathElement(
      'M8.5 8.5c-.384 1.05-1.083 2.028-2.344 2.5-1.931.722-3.576-.297-3.656-1-.113-.994 1.177-6.53 4-7 1.923-.321 3.651.845 3.651 2.235A7.497 7.497 0 0 1 14 5.277c0-1.39 1.844-2.598 3.767-2.277 2.823.47 4.113 6.006 4 7-.08.703-1.725 1.722-3.656 1-1.261-.472-1.855-1.45-2.239-2.5',
    ), // key: v8hric
  ]);

  /// `dollar-sign.mjs`
  static const LucideGlyph dollarSign = LucideGlyph(
    'dollar-sign',
    <IconElement>[
      IconLineElement(12, 2, 12, 22), // key: 7eqyqh
      IconPathElement(
        'M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6',
      ), // key: 1b0p4s
    ],
  );

  /// `donut.mjs`
  static const LucideGlyph donut = LucideGlyph('donut', <IconElement>[
    IconPathElement(
      'M20.5 10a2.5 2.5 0 0 1-2.4-3H18a2.95 2.95 0 0 1-2.6-4.4 10 10 0 1 0 6.3 7.1c-.3.2-.8.3-1.2.3',
    ), // key: 19sr3x
    IconCircleElement(12, 12, 3), // key: 1v7zrd
  ]);

  /// `door-closed-locked.mjs`
  static const LucideGlyph
  doorClosedLocked = LucideGlyph('door-closed-locked', <IconElement>[
    IconPathElement('M10 12h.01'), // key: 1kxr2c
    IconPathElement('M18 9V6a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v14'), // key: 1bnhmg
    IconPathElement('M2 20h8'), // key: 10ntw1
    IconPathElement('M20 17v-2a2 2 0 1 0-4 0v2'), // key: pwaxnr
    IconRectElement(14, 17, 8, 5, 1), // key: 15pjcy
  ]);

  /// `door-closed.mjs`
  static const LucideGlyph
  doorClosed = LucideGlyph('door-closed', <IconElement>[
    IconPathElement('M10 12h.01'), // key: 1kxr2c
    IconPathElement('M18 20V6a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v14'), // key: 36qu9e
    IconPathElement('M2 20h20'), // key: owomy5
  ]);

  /// `door-open.mjs`
  static const LucideGlyph doorOpen = LucideGlyph('door-open', <IconElement>[
    IconPathElement('M11 20H2'), // key: nlcfvz
    IconPathElement(
      'M11 4.562v16.157a1 1 0 0 0 1.242.97L19 20V5.562a2 2 0 0 0-1.515-1.94l-4-1A2 2 0 0 0 11 4.561z',
    ), // key: au4z13
    IconPathElement('M11 4H8a2 2 0 0 0-2 2v14'), // key: 74r1mk
    IconPathElement('M14 12h.01'), // key: 1jfl7z
    IconPathElement('M22 20h-3'), // key: vhrsz
  ]);

  /// `dot.mjs`
  static const LucideGlyph dot = LucideGlyph('dot', <IconElement>[
    IconCircleElement(12, 12, 1), // key: 41hilf
  ]);

  /// `download.mjs`
  static const LucideGlyph download = LucideGlyph('download', <IconElement>[
    IconPathElement('M12 15V3'), // key: m9g1x1
    IconPathElement('M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4'), // key: ih7n3h
    IconPathElement('m7 10 5 5 5-5'), // key: brsn70
  ]);

  /// `drafting-compass.mjs`
  static const LucideGlyph draftingCompass = LucideGlyph(
    'drafting-compass',
    <IconElement>[
      IconPathElement('m12.99 6.74 1.93 3.44'), // key: iwagvd
      IconPathElement('M19.136 12a10 10 0 0 1-14.271 0'), // key: ppmlo4
      IconPathElement('m21 21-2.16-3.84'), // key: vylbct
      IconPathElement('m3 21 8.02-14.26'), // key: 1ssaw4
      IconCircleElement(12, 5, 2), // key: f1ur92
    ],
  );

  /// `drama.mjs`
  static const LucideGlyph drama = LucideGlyph('drama', <IconElement>[
    IconPathElement('M10 11h.01'), // key: d2at3l
    IconPathElement('M14 6h.01'), // key: k028ub
    IconPathElement('M18 6h.01'), // key: 1v4wsw
    IconPathElement('M6.5 13.1h.01'), // key: 1748ia
    IconPathElement(
      'M22 5c0 9-4 12-6 12s-6-3-6-12c0-2 2-3 6-3s6 1 6 3',
    ), // key: 172yzv
    IconPathElement('M17.4 9.9c-.8.8-2 .8-2.8 0'), // key: 1obv0w
    IconPathElement(
      'M10.1 7.1C9 7.2 7.7 7.7 6 8.6c-3.5 2-4.7 3.9-3.7 5.6 4.5 7.8 9.5 8.4 11.2 7.4.9-.5 1.9-2.1 1.9-4.7',
    ), // key: rqjl8i
    IconPathElement('M9.1 16.5c.3-1.1 1.4-1.7 2.4-1.4'), // key: 1mr6wy
  ]);

  /// `drill.mjs`
  static const LucideGlyph drill = LucideGlyph('drill', <IconElement>[
    IconPathElement(
      'M10 18a1 1 0 0 1 1 1v2a1 1 0 0 1-1 1H5a3 3 0 0 1-3-3 1 1 0 0 1 1-1z',
    ), // key: ioqxb1
    IconPathElement(
      'M13 10H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a1 1 0 0 1 1 1v6a1 1 0 0 1-1 1l-.81 3.242a1 1 0 0 1-.97.758H8',
    ), // key: 1rs59n
    IconPathElement('M14 4h3a1 1 0 0 1 1 1v2a1 1 0 0 1-1 1h-3'), // key: 105ega
    IconPathElement('M18 6h4'), // key: 66u95g
    IconPathElement('m5 10-2 8'), // key: xt2lic
    IconPathElement('m7 18 2-8'), // key: 1bzku2
  ]);

  /// `drone.mjs`
  static const LucideGlyph drone = LucideGlyph('drone', <IconElement>[
    IconPathElement('M10 10 7 7'), // key: zp14k7
    IconPathElement('m10 14-3 3'), // key: 1jrpxk
    IconPathElement('m14 10 3-3'), // key: 7tigam
    IconPathElement('m14 14 3 3'), // key: vm23p3
    IconPathElement('M14.205 4.139a4 4 0 1 1 5.439 5.863'), // key: 1tm5p2
    IconPathElement('M19.637 14a4 4 0 1 1-5.432 5.868'), // key: 16egi2
    IconPathElement('M4.367 10a4 4 0 1 1 5.438-5.862'), // key: 1wta6a
    IconPathElement('M9.795 19.862a4 4 0 1 1-5.429-5.873'), // key: q39hpv
    IconRectElement(10, 8, 4, 8, 1), // key: phrjt1
  ]);

  /// `droplet-off.mjs`
  static const LucideGlyph
  dropletOff = LucideGlyph('droplet-off', <IconElement>[
    IconPathElement(
      'M18.715 13.186C18.29 11.858 17.384 10.607 16 9.5c-2-1.6-3.5-4-4-6.5a10.7 10.7 0 0 1-.884 2.586',
    ), // key: 8suz2t
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement(
      'M8.795 8.797A11 11 0 0 1 8 9.5C6 11.1 5 13 5 15a7 7 0 0 0 13.222 3.208',
    ), // key: 19dw9m
  ]);

  /// `droplet.mjs`
  static const LucideGlyph droplet = LucideGlyph('droplet', <IconElement>[
    IconPathElement(
      'M12 22a7 7 0 0 0 7-7c0-2-1-3.9-3-5.5s-3.5-4-4-6.5c-.5 2.5-2 4.9-4 6.5C6 11.1 5 13 5 15a7 7 0 0 0 7 7z',
    ), // key: c7niix
  ]);

  /// `droplets.mjs`
  static const LucideGlyph droplets = LucideGlyph('droplets', <IconElement>[
    IconPathElement(
      'M7 16.3c2.2 0 4-1.83 4-4.05 0-1.16-.57-2.26-1.71-3.19S7.29 6.75 7 5.3c-.29 1.45-1.14 2.84-2.29 3.76S3 11.1 3 12.25c0 2.22 1.8 4.05 4 4.05z',
    ), // key: 1ptgy4
    IconPathElement(
      'M12.56 6.6A10.97 10.97 0 0 0 14 3.02c.5 2.5 2 4.9 4 6.5s3 3.5 3 5.5a6.98 6.98 0 0 1-11.91 4.97',
    ), // key: 1sl1rz
  ]);

  /// `drum.mjs`
  static const LucideGlyph drum = LucideGlyph('drum', <IconElement>[
    IconPathElement('m2 2 8 8'), // key: 1v6059
    IconPathElement('m22 2-8 8'), // key: 173r8a
    IconEllipseElement(12, 9, 10, 5), // key: liohsx
    IconPathElement('M7 13.4v7.9'), // key: 1yi6u9
    IconPathElement('M12 14v8'), // key: 1tn2tj
    IconPathElement('M17 13.4v7.9'), // key: eqz2v3
    IconPathElement('M2 9v8a10 5 0 0 0 20 0V9'), // key: 1750ul
  ]);

  /// `drumstick.mjs`
  static const LucideGlyph drumstick = LucideGlyph('drumstick', <IconElement>[
    IconPathElement(
      'M15.4 15.63a7.875 6 135 1 1 6.23-6.23 4.5 3.43 135 0 0-6.23 6.23',
    ), // key: 1dtqwm
    IconPathElement(
      'm8.29 12.71-2.6 2.6a2.5 2.5 0 1 0-1.65 4.65A2.5 2.5 0 1 0 8.7 18.3l2.59-2.59',
    ), // key: 1oq1fw
  ]);

  /// `dumbbell.mjs`
  static const LucideGlyph dumbbell = LucideGlyph('dumbbell', <IconElement>[
    IconPathElement(
      'M17.596 12.768a2 2 0 1 0 2.829-2.829l-1.768-1.767a2 2 0 0 0 2.828-2.829l-2.828-2.828a2 2 0 0 0-2.829 2.828l-1.767-1.768a2 2 0 1 0-2.829 2.829z',
    ), // key: 9m4mmf
    IconPathElement('m2.5 21.5 1.4-1.4'), // key: 17g3f0
    IconPathElement('m20.1 3.9 1.4-1.4'), // key: 1qn309
    IconPathElement(
      'M5.343 21.485a2 2 0 1 0 2.829-2.828l1.767 1.768a2 2 0 1 0 2.829-2.829l-6.364-6.364a2 2 0 1 0-2.829 2.829l1.768 1.767a2 2 0 0 0-2.828 2.829z',
    ), // key: 1t2c92
    IconPathElement('m9.6 14.4 4.8-4.8'), // key: 6umqxw
  ]);

  /// `ear-off.mjs`
  static const LucideGlyph earOff = LucideGlyph('ear-off', <IconElement>[
    IconPathElement(
      'M6 18.5a3.5 3.5 0 1 0 7 0c0-1.57.92-2.52 2.04-3.46',
    ), // key: 1qngmn
    IconPathElement('M6 8.5c0-.75.13-1.47.36-2.14'), // key: b06bma
    IconPathElement(
      'M8.8 3.15A6.5 6.5 0 0 1 19 8.5c0 1.63-.44 2.81-1.09 3.76',
    ), // key: g10hsz
    IconPathElement(
      'M12.5 6A2.5 2.5 0 0 1 15 8.5M10 13a2 2 0 0 0 1.82-1.18',
    ), // key: ygzou7
    IconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `ear.mjs`
  static const LucideGlyph ear = LucideGlyph('ear', <IconElement>[
    IconPathElement(
      'M6 8.5a6.5 6.5 0 1 1 13 0c0 6-6 6-6 10a3.5 3.5 0 1 1-7 0',
    ), // key: 1dfaln
    IconPathElement('M15 8.5a2.5 2.5 0 0 0-5 0v1a2 2 0 1 1 0 4'), // key: 1qnva7
  ]);

  /// `earth-lock.mjs`
  static const LucideGlyph earthLock = LucideGlyph('earth-lock', <IconElement>[
    IconPathElement('M7 3.34V5a3 3 0 0 0 3 3'), // key: w732o8
    IconPathElement(
      'M11 21.95V18a2 2 0 0 0-2-2 2 2 0 0 1-2-2v-1a2 2 0 0 0-2-2H2.05',
    ), // key: f02343
    IconPathElement('M21.54 15H17a2 2 0 0 0-2 2v4.54'), // key: 1djwo0
    IconPathElement('M12 2a10 10 0 1 0 9.54 13'), // key: zjsr6q
    IconPathElement('M20 6V4a2 2 0 1 0-4 0v2'), // key: 1of5e8
    IconRectElement(14, 6, 8, 5, 1), // key: 1fmf51
  ]);

  /// `earth.mjs`
  static const LucideGlyph earth = LucideGlyph('earth', <IconElement>[
    IconPathElement('M21.54 15H17a2 2 0 0 0-2 2v4.54'), // key: 1djwo0
    IconPathElement(
      'M7 3.34V5a3 3 0 0 0 3 3a2 2 0 0 1 2 2c0 1.1.9 2 2 2a2 2 0 0 0 2-2c0-1.1.9-2 2-2h3.17',
    ), // key: 1tzkfa
    IconPathElement(
      'M11 21.95V18a2 2 0 0 0-2-2a2 2 0 0 1-2-2v-1a2 2 0 0 0-2-2H2.05',
    ), // key: 14pb5j
    IconCircleElement(12, 12, 10), // key: 1mglay
  ]);

  /// `eclipse.mjs`
  static const LucideGlyph eclipse = LucideGlyph('eclipse', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M12 2a7 7 0 1 0 10 10'), // key: 1yuj32
  ]);

  /// `egg-fried.mjs`
  static const LucideGlyph eggFried = LucideGlyph('egg-fried', <IconElement>[
    IconCircleElement(11.5, 12.5, 3.5), // key: 1cl1mi
    IconPathElement(
      'M3 8c0-3.5 2.5-6 6.5-6 5 0 4.83 3 7.5 5s5 2 5 6c0 4.5-2.5 6.5-7 6.5-2.5 0-2.5 2.5-6 2.5s-7-2-7-5.5c0-3 1.5-3 1.5-5C3.5 10 3 9 3 8Z',
    ), // key: 165ef9
  ]);

  /// `egg-off.mjs`
  static const LucideGlyph eggOff = LucideGlyph('egg-off', <IconElement>[
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement(
      'M20 14.347V14c0-6-4-12-8-12-1.078 0-2.157.436-3.157 1.19',
    ), // key: 13g2jy
    IconPathElement(
      'M6.206 6.21C4.871 8.4 4 11.2 4 14a8 8 0 0 0 14.568 4.568',
    ), // key: 1581id
  ]);

  /// `egg.mjs`
  static const LucideGlyph egg = LucideGlyph('egg', <IconElement>[
    IconPathElement(
      'M12 2C8 2 4 8 4 14a8 8 0 0 0 16 0c0-6-4-12-8-12',
    ), // key: 1le142
  ]);

  /// `ellipse.mjs`
  static const LucideGlyph ellipse = LucideGlyph('ellipse', <IconElement>[
    IconEllipseElement(12, 12, 10, 6), // key: swdkt4
  ]);

  /// `ellipsis-vertical.mjs`
  static const LucideGlyph ellipsisVertical = LucideGlyph(
    'ellipsis-vertical',
    <IconElement>[
      IconCircleElement(12, 12, 1), // key: 41hilf
      IconCircleElement(12, 5, 1), // key: gxeob9
      IconCircleElement(12, 19, 1), // key: lyex9k
    ],
  );

  /// `ellipsis.mjs`
  static const LucideGlyph ellipsis = LucideGlyph('ellipsis', <IconElement>[
    IconCircleElement(12, 12, 1), // key: 41hilf
    IconCircleElement(19, 12, 1), // key: 1wjl8i
    IconCircleElement(5, 12, 1), // key: 1pcz8c
  ]);

  /// `equal-approximately.mjs`
  static const LucideGlyph
  equalApproximately = LucideGlyph('equal-approximately', <IconElement>[
    IconPathElement('M5 15a6.5 6.5 0 0 1 7 0 6.5 6.5 0 0 0 7 0'), // key: yrdkhy
    IconPathElement('M5 9a6.5 6.5 0 0 1 7 0 6.5 6.5 0 0 0 7 0'), // key: gzkvyz
  ]);

  /// `equal-not.mjs`
  static const LucideGlyph equalNot = LucideGlyph('equal-not', <IconElement>[
    IconLineElement(5, 9, 19, 9), // key: 1nwqeh
    IconLineElement(5, 15, 19, 15), // key: g8yjpy
    IconLineElement(19, 5, 5, 19), // key: 1x9vlm
  ]);

  /// `equal.mjs`
  static const LucideGlyph equal = LucideGlyph('equal', <IconElement>[
    IconLineElement(5, 9, 19, 9), // key: 1nwqeh
    IconLineElement(5, 15, 19, 15), // key: g8yjpy
  ]);

  /// `eraser.mjs`
  static const LucideGlyph eraser = LucideGlyph('eraser', <IconElement>[
    IconPathElement(
      'M21 21H8a2 2 0 0 1-1.42-.587l-3.994-3.999a2 2 0 0 1 0-2.828l10-10a2 2 0 0 1 2.829 0l5.999 6a2 2 0 0 1 0 2.828L12.834 21',
    ), // key: g5wo59
    IconPathElement('m5.082 11.09 8.828 8.828'), // key: 1wx5vj
  ]);

  /// `ethernet-port.mjs`
  static const LucideGlyph
  ethernetPort = LucideGlyph('ethernet-port', <IconElement>[
    IconPathElement('M10 8v1'), // key: 1talb4
    IconPathElement('M14 8v1'), // key: 1rsfgr
    IconPathElement('M18 8v1'), // key: gnkwox
    IconPathElement(
      'M19 17a2 2 0 00-1.765 1.059l-.47.882A2 2 0 0115 20H9a2 2 0 01-1.765-1.059l-.47-.882A2 2 0 005 17H4a2 2 0 01-2-2V6a2 2 0 012-2h16a2 2 0 012 2v9a2 2 0 01-2 2z',
    ), // key: v5qa57
    IconPathElement('M6 8v1'), // key: 1636ez
  ]);

  /// `euro.mjs`
  static const LucideGlyph euro = LucideGlyph('euro', <IconElement>[
    IconPathElement('M4 10h12'), // key: 1y6xl8
    IconPathElement('M4 14h9'), // key: 1loblj
    IconPathElement(
      'M19 6a7.7 7.7 0 0 0-5.2-2A7.9 7.9 0 0 0 6 12c0 4.4 3.5 8 7.8 8 2 0 3.8-.8 5.2-2',
    ), // key: 1j6lzo
  ]);

  /// `ev-charger.mjs`
  static const LucideGlyph evCharger = LucideGlyph('ev-charger', <IconElement>[
    IconPathElement(
      'M14 13h2a2 2 0 0 1 2 2v2a2 2 0 0 0 4 0v-6.998a2 2 0 0 0-.59-1.42L18 5',
    ), // key: 1wtuz0
    IconPathElement('M14 21V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v16'), // key: e09ifn
    IconPathElement('M2 21h13'), // key: 1x0fut
    IconPathElement('M3 7h11'), // key: 19efrr
    IconPathElement('m9 11-2 3h3l-2 3'), // key: lmzxi1
  ]);

  /// `expand.mjs`
  static const LucideGlyph expand = LucideGlyph('expand', <IconElement>[
    IconPathElement('m15 15 6 6'), // key: 1s409w
    IconPathElement('m15 9 6-6'), // key: ko1vev
    IconPathElement('M21 16v5h-5'), // key: 1ck2sf
    IconPathElement('M21 8V3h-5'), // key: 1qoq8a
    IconPathElement('M3 16v5h5'), // key: 1t08am
    IconPathElement('m3 21 6-6'), // key: wwnumi
    IconPathElement('M3 8V3h5'), // key: 1ln10m
    IconPathElement('M9 9 3 3'), // key: v551iv
  ]);

  /// `external-link.mjs`
  static const LucideGlyph externalLink = LucideGlyph(
    'external-link',
    <IconElement>[
      IconPathElement('M15 3h6v6'), // key: 1q9fwt
      IconPathElement('M10 14 21 3'), // key: gplh6r
      IconPathElement(
        'M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6',
      ), // key: a6xqqp
    ],
  );

  /// `eye-closed.mjs`
  static const LucideGlyph eyeClosed = LucideGlyph('eye-closed', <IconElement>[
    IconPathElement('m15 18-.722-3.25'), // key: 1j64jw
    IconPathElement('M2 8a10.645 10.645 0 0 0 20 0'), // key: 1e7gxb
    IconPathElement('m20 15-1.726-2.05'), // key: 1cnuld
    IconPathElement('m4 15 1.726-2.05'), // key: 1dsqqd
    IconPathElement('m9 18 .722-3.25'), // key: ypw2yx
  ]);

  /// `eye-dashed.mjs`
  static const LucideGlyph eyeDashed = LucideGlyph('eye-dashed', <IconElement>[
    IconPathElement('M13.054 18.946a11 11 0 0 1-2.11 0'), // key: 1lgjj0
    IconPathElement('M13.054 5.054a11 11 0 0 0-2.11-.001'), // key: f7voaa
    IconPathElement('M17.072 6.274a11 11 0 0 1 1.753 1.173'), // key: 1rga24
    IconPathElement('M18.825 16.552a11 11 0 0 1-1.753 1.174'), // key: jfvai2
    IconPathElement(
      'M2.514 13.303a11 11 0 0 1-.452-.954 1 1 0 0 1 0-.697 11 11 0 0 1 .45-.955',
    ), // key: 1deed4
    IconPathElement(
      'M21.485 10.697a11 11 0 0 1 .453.955 1 1 0 0 1 0 .697 11 11 0 0 1-.453.954',
    ), // key: 1k4xil
    IconPathElement('M5.173 7.448a11 11 0 0 1 1.753-1.174'), // key: mwd8rq
    IconPathElement('M6.926 17.726a11 11 0 0 1-1.753-1.174'), // key: 15rpim
    IconCircleElement(12, 12, 3), // key: 1v7zrd
  ]);

  /// `eye-off.mjs`
  static const LucideGlyph eyeOff = LucideGlyph('eye-off', <IconElement>[
    IconPathElement(
      'M10.733 5.076a10.744 10.744 0 0 1 11.205 6.575 1 1 0 0 1 0 .696 10.747 10.747 0 0 1-1.444 2.49',
    ), // key: ct8e1f
    IconPathElement('M14.084 14.158a3 3 0 0 1-4.242-4.242'), // key: 151rxh
    IconPathElement(
      'M17.479 17.499a10.75 10.75 0 0 1-15.417-5.151 1 1 0 0 1 0-.696 10.75 10.75 0 0 1 4.446-5.143',
    ), // key: 13bj9a
    IconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `eye.mjs`
  static const LucideGlyph eye = LucideGlyph('eye', <IconElement>[
    IconPathElement(
      'M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0',
    ), // key: 1nclc0
    IconCircleElement(12, 12, 3), // key: 1v7zrd
  ]);

  /// `factory.mjs`
  static const LucideGlyph factory = LucideGlyph('factory', <IconElement>[
    IconPathElement('M12 16h.01'), // key: 1drbdi
    IconPathElement('M16 16h.01'), // key: 1f9h7w
    IconPathElement(
      'M3 19a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V8.5a.5.5 0 0 0-.769-.422l-4.462 2.844A.5.5 0 0 1 15 10.5v-2a.5.5 0 0 0-.769-.422L9.77 10.922A.5.5 0 0 1 9 10.5V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2z',
    ), // key: 1iv0i2
    IconPathElement('M8 16h.01'), // key: 18s6g9
  ]);

  /// `fan.mjs`
  static const LucideGlyph fan = LucideGlyph('fan', <IconElement>[
    IconPathElement(
      'M10.827 16.379a6.082 6.082 0 0 1-8.618-7.002l5.412 1.45a6.082 6.082 0 0 1 7.002-8.618l-1.45 5.412a6.082 6.082 0 0 1 8.618 7.002l-5.412-1.45a6.082 6.082 0 0 1-7.002 8.618l1.45-5.412Z',
    ), // key: 484a7f
    IconPathElement('M12 12v.01'), // key: u5ubse
  ]);

  /// `fast-forward.mjs`
  static const LucideGlyph
  fastForward = LucideGlyph('fast-forward', <IconElement>[
    IconPathElement(
      'M12 6a2 2 0 0 1 3.414-1.414l6 6a2 2 0 0 1 0 2.828l-6 6A2 2 0 0 1 12 18z',
    ), // key: b19h5q
    IconPathElement(
      'M2 6a2 2 0 0 1 3.414-1.414l6 6a2 2 0 0 1 0 2.828l-6 6A2 2 0 0 1 2 18z',
    ), // key: h7h5ge
  ]);

  /// `feather.mjs`
  static const LucideGlyph feather = LucideGlyph('feather', <IconElement>[
    IconPathElement(
      'M14.086 18.412A2 2 0 0112.67 19H5v-7.672a2 2 0 01.586-1.414L11.75 3.75a6 6 0 118.49 8.49z',
    ), // key: 1nq9jb
    IconPathElement('M16 8 2 22'), // key: vp34q
    IconPathElement('M17.488 15H9'), // key: 16yirz
  ]);

  /// `fence.mjs`
  static const LucideGlyph fence = LucideGlyph('fence', <IconElement>[
    IconPathElement(
      'M4 3 2 5v15c0 .6.4 1 1 1h2c.6 0 1-.4 1-1V5Z',
    ), // key: 1n2rgs
    IconPathElement('M6 8h4'), // key: utf9t1
    IconPathElement('M6 18h4'), // key: 12yh4b
    IconPathElement(
      'm12 3-2 2v15c0 .6.4 1 1 1h2c.6 0 1-.4 1-1V5Z',
    ), // key: 3ha7mj
    IconPathElement('M14 8h4'), // key: 1r8wg2
    IconPathElement('M14 18h4'), // key: 1t3kbu
    IconPathElement(
      'm20 3-2 2v15c0 .6.4 1 1 1h2c.6 0 1-.4 1-1V5Z',
    ), // key: dfd4e2
  ]);

  /// `ferris-wheel.mjs`
  static const LucideGlyph ferrisWheel = LucideGlyph(
    'ferris-wheel',
    <IconElement>[
      IconCircleElement(12, 12, 2), // key: 1c9p78
      IconPathElement('M12 2v4'), // key: 3427ic
      IconPathElement('m6.8 15-3.5 2'), // key: hjy98k
      IconPathElement('m20.7 7-3.5 2'), // key: f08gto
      IconPathElement('M6.8 9 3.3 7'), // key: 1aevh4
      IconPathElement('m20.7 17-3.5-2'), // key: 1liqo3
      IconPathElement('m9 22 3-8 3 8'), // key: wees03
      IconPathElement('M8 22h8'), // key: rmew8v
      IconPathElement('M18 18.7a9 9 0 1 0-12 0'), // key: dhzg4g
    ],
  );

  /// `file-archive.mjs`
  static const LucideGlyph
  fileArchive = LucideGlyph('file-archive', <IconElement>[
    IconPathElement(
      'M13.659 22H18a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v11.5',
    ), // key: 4pqfef
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M8 12v-1'), // key: 1ej8lb
    IconPathElement('M8 18v-2'), // key: qcmpov
    IconPathElement('M8 7V6'), // key: 1nbb54
    IconCircleElement(8, 20, 2), // key: ckkr5m
  ]);

  /// `file-axis-3d.mjs`
  static const LucideGlyph
  fileAxis3d = LucideGlyph('file-axis-3d', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('m8 18 4-4'), // key: 12zab0
    IconPathElement('M8 10v8h8'), // key: tlaukw
  ]);

  /// `file-badge.mjs`
  static const LucideGlyph fileBadge = LucideGlyph('file-badge', <IconElement>[
    IconPathElement(
      'M13 22h5a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v3.3',
    ), // key: cvl1xm
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement(
      'm7.69 16.479 1.29 4.88a.5.5 0 0 1-.698.591l-1.843-.849a1 1 0 0 0-.879.001l-1.846.85a.5.5 0 0 1-.692-.593l1.29-4.88',
    ), // key: 1ff7gj
    IconCircleElement(6, 14, 3), // key: a1xfv6
  ]);

  /// `file-box.mjs`
  static const LucideGlyph fileBox = LucideGlyph('file-box', <IconElement>[
    IconPathElement('M14 2v5a1 1 0 001 1h5'), // key: 9v5fu7
    IconPathElement(
      'M14.692 22H18a2 2 0 002-2V8a2.4 2.4 0 00-.706-1.706l-3.588-3.588A2.4 2.4 0 0014 2H6a2 2 0 00-2 2v3.804',
    ), // key: 1ne0j7
    IconPathElement('M2.264 13.752 7 16.5l4.737-2.748'), // key: t73mg3
    IconPathElement(
      'M2.995 13.014A2 2 0 002 14.744v3.516a2 2 0 00.996 1.73l3 1.74a2 2 0 002.008 0l3-1.74A2 2 0 0012 18.26v-3.517a2 2 0 00-.995-1.73l-3-1.742a2 2 0 00-1.892-.064z',
    ), // key: h4qck
    IconPathElement('M7 16.5V22'), // key: 1i1gou
  ]);

  /// `file-braces-corner.mjs`
  static const LucideGlyph
  fileBracesCorner = LucideGlyph('file-braces-corner', <IconElement>[
    IconPathElement(
      'M14 22h4a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v6',
    ), // key: 14cnrg
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement(
      'M5 14a1 1 0 0 0-1 1v2a1 1 0 0 1-1 1 1 1 0 0 1 1 1v2a1 1 0 0 0 1 1',
    ), // key: sr0ebq
    IconPathElement(
      'M9 22a1 1 0 0 0 1-1v-2a1 1 0 0 1 1-1 1 1 0 0 1-1-1v-2a1 1 0 0 0-1-1',
    ), // key: w793db
  ]);

  /// `file-braces.mjs`
  static const LucideGlyph
  fileBraces = LucideGlyph('file-braces', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement(
      'M10 12a1 1 0 0 0-1 1v1a1 1 0 0 1-1 1 1 1 0 0 1 1 1v1a1 1 0 0 0 1 1',
    ), // key: 1oajmo
    IconPathElement(
      'M14 18a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1 1 1 0 0 1-1-1v-1a1 1 0 0 0-1-1',
    ), // key: mpwhp6
  ]);

  /// `file-chart-column-increasing.mjs`
  static const LucideGlyph
  fileChartColumnIncreasing = LucideGlyph('file-chart-column-increasing', <
    IconElement
  >[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M8 18v-2'), // key: qcmpov
    IconPathElement('M12 18v-4'), // key: q1q25u
    IconPathElement('M16 18v-6'), // key: 15y0np
  ]);

  /// `file-chart-column.mjs`
  static const LucideGlyph
  fileChartColumn = LucideGlyph('file-chart-column', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M8 18v-1'), // key: zg0ygc
    IconPathElement('M12 18v-6'), // key: 17g6i2
    IconPathElement('M16 18v-3'), // key: j5jt4h
  ]);

  /// `file-chart-line.mjs`
  static const LucideGlyph
  fileChartLine = LucideGlyph('file-chart-line', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('m16 13-3.5 3.5-2-2L8 17'), // key: zz7yod
  ]);

  /// `file-chart-pie.mjs`
  static const LucideGlyph
  fileChartPie = LucideGlyph('file-chart-pie', <IconElement>[
    IconPathElement(
      'M15.941 22H18a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.704l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v3.512',
    ), // key: 13hoie
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M4.017 11.512a6 6 0 1 0 8.466 8.475'), // key: s6vs5t
    IconPathElement(
      'M9 16a1 1 0 0 1-1-1v-4c0-.552.45-1.008.995-.917a6 6 0 0 1 4.922 4.922c.091.544-.365.995-.917.995z',
    ), // key: 1dl6s6
  ]);

  /// `file-check-corner.mjs`
  static const LucideGlyph
  fileCheckCorner = LucideGlyph('file-check-corner', <IconElement>[
    IconPathElement(
      'M10.5 22H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v6',
    ), // key: g5mvt7
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('m14 20 2 2 4-4'), // key: 15kota
  ]);

  /// `file-check.mjs`
  static const LucideGlyph fileCheck = LucideGlyph('file-check', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('m9 15 2 2 4-4'), // key: 1grp1n
  ]);

  /// `file-clock.mjs`
  static const LucideGlyph fileClock = LucideGlyph('file-clock', <IconElement>[
    IconPathElement(
      'M16 22h2a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v2.85',
    ), // key: ryk6xj
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M8 14v2.2l1.6 1'), // key: 6m4bie
    IconCircleElement(8, 16, 6), // key: 10v15b
  ]);

  /// `file-code-corner.mjs`
  static const LucideGlyph
  fileCodeCorner = LucideGlyph('file-code-corner', <IconElement>[
    IconPathElement(
      'M4 12.15V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2h-3.35',
    ), // key: 1wthlu
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('m5 16-3 3 3 3'), // key: 331omg
    IconPathElement('m9 22 3-3-3-3'), // key: lsp7cz
  ]);

  /// `file-code.mjs`
  static const LucideGlyph fileCode = LucideGlyph('file-code', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M10 12.5 8 15l2 2.5'), // key: 1tg20x
    IconPathElement('m14 12.5 2 2.5-2 2.5'), // key: yinavb
  ]);

  /// `file-cog.mjs`
  static const LucideGlyph fileCog = LucideGlyph('file-cog', <IconElement>[
    IconPathElement(
      'M15 8a1 1 0 0 1-1-1V2a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8z',
    ), // key: 1ckgky
    IconPathElement('M20 8v12a2 2 0 0 1-2 2h-4.182'), // key: 1726p0
    IconPathElement('m3.305 19.53.923-.382'), // key: ao1pio
    IconPathElement('M4 10.592V4a2 2 0 0 1 2-2h8'), // key: 1foop0
    IconPathElement('m4.228 16.852-.924-.383'), // key: 1fv9zy
    IconPathElement('m5.852 15.228-.383-.923'), // key: 1a9hc2
    IconPathElement('m5.852 20.772-.383.924'), // key: 1sh9ke
    IconPathElement('m8.148 15.228.383-.923'), // key: 4yu6lf
    IconPathElement('m8.53 21.696-.382-.924'), // key: 18b0s9
    IconPathElement('m9.773 16.852.922-.383'), // key: ti6xop
    IconPathElement('m9.773 19.148.922.383'), // key: rws47d
    IconCircleElement(7, 18, 3), // key: lvkj7j
  ]);

  /// `file-diff.mjs`
  static const LucideGlyph fileDiff = LucideGlyph('file-diff', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M9 10h6'), // key: 9gxzsh
    IconPathElement('M12 13V7'), // key: h0r20n
    IconPathElement('M9 17h6'), // key: r8uit2
  ]);

  /// `file-digit.mjs`
  static const LucideGlyph fileDigit = LucideGlyph('file-digit', <IconElement>[
    IconPathElement(
      'M4 12V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2',
    ), // key: jrl274
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M10 16h2v6'), // key: 1bxocy
    IconPathElement('M10 22h4'), // key: ceow96
    IconRectElement(2, 16, 4, 6, 2), // key: r45zd0
  ]);

  /// `file-down.mjs`
  static const LucideGlyph fileDown = LucideGlyph('file-down', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M12 18v-6'), // key: 17g6i2
    IconPathElement('m9 15 3 3 3-3'), // key: 1npd3o
  ]);

  /// `file-exclamation-point.mjs`
  static const LucideGlyph
  fileExclamationPoint = LucideGlyph('file-exclamation-point', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M12 9v4'), // key: juzpu7
    IconPathElement('M12 17h.01'), // key: p32p05
  ]);

  /// `file-headphone.mjs`
  static const LucideGlyph
  fileHeadphone = LucideGlyph('file-headphone', <IconElement>[
    IconPathElement(
      'M4 6.835V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2h-.343',
    ), // key: 1vfytu
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement(
      'M2 19a2 2 0 0 1 4 0v1a2 2 0 0 1-4 0v-4a6 6 0 0 1 12 0v4a2 2 0 0 1-4 0v-1a2 2 0 0 1 4 0',
    ), // key: 1etmh7
  ]);

  /// `file-heart.mjs`
  static const LucideGlyph fileHeart = LucideGlyph('file-heart', <IconElement>[
    IconPathElement(
      'M13 22h5a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v7',
    ), // key: oagw2b
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement(
      'M3.62 18.8A2.25 2.25 0 1 1 7 15.836a2.25 2.25 0 1 1 3.38 2.966l-2.626 2.856a1 1 0 0 1-1.507 0z',
    ), // key: rg3psg
  ]);

  /// `file-image.mjs`
  static const LucideGlyph fileImage = LucideGlyph('file-image', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconCircleElement(10, 12, 2), // key: 737tya
    IconPathElement(
      'm20 17-1.296-1.296a2.41 2.41 0 0 0-3.408 0L9 22',
    ), // key: wt3hpn
  ]);

  /// `file-input.mjs`
  static const LucideGlyph fileInput = LucideGlyph('file-input', <IconElement>[
    IconPathElement(
      'M4 11V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-1',
    ), // key: 1q9hii
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M2 15h10'), // key: jfw4w8
    IconPathElement('m9 18 3-3-3-3'), // key: 112psh
  ]);

  /// `file-key.mjs`
  static const LucideGlyph fileKey = LucideGlyph('file-key', <IconElement>[
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M4 12v6'), // key: bg1pfk
    IconPathElement('M4 14h2'), // key: 1sf9f8
    IconPathElement(
      'M9.65 22H18a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v4',
    ), // key: d56i0q
    IconCircleElement(4, 20, 2), // key: 6kqj1y
  ]);

  /// `file-lock.mjs`
  static const LucideGlyph fileLock = LucideGlyph('file-lock', <IconElement>[
    IconPathElement(
      'M4 9.8V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2h-3',
    ), // key: 1432pc
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M9 17v-2a2 2 0 0 0-4 0v2'), // key: 168m41
    IconRectElement(3, 17, 8, 5, 1), // key: o8vfew
  ]);

  /// `file-minus-corner.mjs`
  static const LucideGlyph
  fileMinusCorner = LucideGlyph('file-minus-corner', <IconElement>[
    IconPathElement(
      'M20 14V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12',
    ), // key: l9p8hp
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M14 18h6'), // key: 1m8k6r
  ]);

  /// `file-minus.mjs`
  static const LucideGlyph fileMinus = LucideGlyph('file-minus', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M9 15h6'), // key: cctwl0
  ]);

  /// `file-music.mjs`
  static const LucideGlyph fileMusic = LucideGlyph('file-music', <IconElement>[
    IconPathElement(
      'M11.65 22H18a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v10.35',
    ), // key: 5ad7z2
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M8 20v-7l3 1.474'), // key: 1ggyb9
    IconCircleElement(6, 20, 2), // key: j7wjp0
  ]);

  /// `file-output.mjs`
  static const LucideGlyph
  fileOutput = LucideGlyph('file-output', <IconElement>[
    IconPathElement(
      'M4.226 20.925A2 2 0 0 0 6 22h12a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v3.127',
    ), // key: wfxp4w
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('m5 11-3 3'), // key: 1dgrs4
    IconPathElement('m5 17-3-3h10'), // key: 1mvvaf
  ]);

  /// `file-pen-line.mjs`
  static const LucideGlyph
  filePenLine = LucideGlyph('file-pen-line', <IconElement>[
    IconPathElement(
      'M14.364 13.634a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506l4.013-4.009a1 1 0 0 0-3.004-3.004z',
    ), // key: ukzhwg
    IconPathElement('M14.487 7.858A1 1 0 0 1 14 7V2'), // key: 1klhew
    IconPathElement(
      'M20 19.645V20a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l2.516 2.516',
    ), // key: rxaxab
    IconPathElement('M8 18h1'), // key: 13wk12
  ]);

  /// `file-pen.mjs`
  static const LucideGlyph filePen = LucideGlyph('file-pen', <IconElement>[
    IconPathElement(
      'M12.659 22H18a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v9.34',
    ), // key: o6klzx
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement(
      'M10.378 12.622a1 1 0 0 1 3 3.003L8.36 20.637a2 2 0 0 1-.854.506l-2.867.837a.5.5 0 0 1-.62-.62l.836-2.869a2 2 0 0 1 .506-.853z',
    ), // key: zhnas1
  ]);

  /// `file-play.mjs`
  static const LucideGlyph filePlay = LucideGlyph('file-play', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement(
      'M15.033 13.44a.647.647 0 0 1 0 1.12l-4.065 2.352a.645.645 0 0 1-.968-.56v-4.704a.645.645 0 0 1 .967-.56z',
    ), // key: 1tzo1f
  ]);

  /// `file-plus-corner.mjs`
  static const LucideGlyph
  filePlusCorner = LucideGlyph('file-plus-corner', <IconElement>[
    IconPathElement(
      'M11.35 22H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v5.35',
    ), // key: 17jvcc
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M14 19h6'), // key: bvotb8
    IconPathElement('M17 16v6'), // key: 18yu1i
  ]);

  /// `file-plus.mjs`
  static const LucideGlyph filePlus = LucideGlyph('file-plus', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M9 15h6'), // key: cctwl0
    IconPathElement('M12 18v-6'), // key: 17g6i2
  ]);

  /// `file-question-mark.mjs`
  static const LucideGlyph
  fileQuestionMark = LucideGlyph('file-question-mark', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M12 17h.01'), // key: p32p05
    IconPathElement('M9.1 9a3 3 0 0 1 5.82 1c0 2-3 3-3 3'), // key: mhlwft
  ]);

  /// `file-scan.mjs`
  static const LucideGlyph fileScan = LucideGlyph('file-scan', <IconElement>[
    IconPathElement(
      'M20 10V8a2.4 2.4 0 0 0-.706-1.704l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h4.35',
    ), // key: 1cdjst
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M16 14a2 2 0 0 0-2 2'), // key: ceaadl
    IconPathElement('M16 22a2 2 0 0 1-2-2'), // key: 1wqh5n
    IconPathElement('M20 14a2 2 0 0 1 2 2'), // key: 1ny6zw
    IconPathElement('M20 22a2 2 0 0 0 2-2'), // key: 1l9q4k
  ]);

  /// `file-search-corner.mjs`
  static const LucideGlyph
  fileSearchCorner = LucideGlyph('file-search-corner', <IconElement>[
    IconPathElement(
      'M11.1 22H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.589 3.588A2.4 2.4 0 0 1 20 8v3.25',
    ), // key: uh4ikj
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('m21 22-2.88-2.88'), // key: 9dd25w
    IconCircleElement(16, 17, 3), // key: 11br10
  ]);

  /// `file-search.mjs`
  static const LucideGlyph
  fileSearch = LucideGlyph('file-search', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconCircleElement(11.5, 14.5, 2.5), // key: 1bq0ko
    IconPathElement('M13.3 16.3 15 18'), // key: 2quom7
  ]);

  /// `file-signal.mjs`
  static const LucideGlyph
  fileSignal = LucideGlyph('file-signal', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M8 15h.01'), // key: a7atzg
    IconPathElement('M11.5 13.5a2.5 2.5 0 0 1 0 3'), // key: 1fccat
    IconPathElement('M15 12a5 5 0 0 1 0 6'), // key: ps46cm
  ]);

  /// `file-sliders.mjs`
  static const LucideGlyph
  fileSliders = LucideGlyph('file-sliders', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M8 12h8'), // key: 1wcyev
    IconPathElement('M10 11v2'), // key: 1s651w
    IconPathElement('M8 17h8'), // key: wh5c61
    IconPathElement('M14 16v2'), // key: 12fp5e
  ]);

  /// `file-spreadsheet.mjs`
  static const LucideGlyph
  fileSpreadsheet = LucideGlyph('file-spreadsheet', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M8 13h2'), // key: yr2amv
    IconPathElement('M14 13h2'), // key: un5t4a
    IconPathElement('M8 17h2'), // key: 2yhykz
    IconPathElement('M14 17h2'), // key: 10kma7
  ]);

  /// `file-stack.mjs`
  static const LucideGlyph fileStack = LucideGlyph('file-stack', <IconElement>[
    IconPathElement(
      'M11 21a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1v-8a1 1 0 0 1 1-1',
    ), // key: likhh7
    IconPathElement(
      'M16 16a1 1 0 0 1-1 1H9a1 1 0 0 1-1-1V8a1 1 0 0 1 1-1',
    ), // key: 17ky3x
    IconPathElement(
      'M21 6a2 2 0 0 0-.586-1.414l-2-2A2 2 0 0 0 17 2h-3a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1z',
    ), // key: 1hyeo0
  ]);

  /// `file-symlink.mjs`
  static const LucideGlyph
  fileSymlink = LucideGlyph('file-symlink', <IconElement>[
    IconPathElement(
      'M4 11V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h7',
    ), // key: huwfnr
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('m10 18 3-3-3-3'), // key: 18f6ys
  ]);

  /// `file-terminal.mjs`
  static const LucideGlyph
  fileTerminal = LucideGlyph('file-terminal', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('m8 16 2-2-2-2'), // key: 10vzyd
    IconPathElement('M12 18h4'), // key: 1wd2n7
  ]);

  /// `file-text.mjs`
  static const LucideGlyph fileText = LucideGlyph('file-text', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M10 9H8'), // key: b1mrlr
    IconPathElement('M16 13H8'), // key: t4e002
    IconPathElement('M16 17H8'), // key: z1uh3a
  ]);

  /// `file-type-corner.mjs`
  static const LucideGlyph
  fileTypeCorner = LucideGlyph('file-type-corner', <IconElement>[
    IconPathElement(
      'M12 22h6a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v6',
    ), // key: 15usau
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement(
      'M3 16v-1.5a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 .5.5V16',
    ), // key: s1gz5
    IconPathElement('M6 22h2'), // key: 194x9m
    IconPathElement('M7 14v8'), // key: 11ixej
  ]);

  /// `file-type.mjs`
  static const LucideGlyph fileType = LucideGlyph('file-type', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M11 18h2'), // key: 12mj7e
    IconPathElement('M12 12v6'), // key: 3ahymv
    IconPathElement(
      'M9 13v-.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 .5.5v.5',
    ), // key: qbrxap
  ]);

  /// `file-up.mjs`
  static const LucideGlyph fileUp = LucideGlyph('file-up', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M12 12v6'), // key: 3ahymv
    IconPathElement('m15 15-3-3-3 3'), // key: 15xj92
  ]);

  /// `file-user.mjs`
  static const LucideGlyph fileUser = LucideGlyph('file-user', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M16 22a4 4 0 0 0-8 0'), // key: 7a83pg
    IconCircleElement(12, 15, 3), // key: g36mzq
  ]);

  /// `file-video-camera.mjs`
  static const LucideGlyph
  fileVideoCamera = LucideGlyph('file-video-camera', <IconElement>[
    IconPathElement(
      'M4 12V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2',
    ), // key: jrl274
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement(
      'm10 17.843 3.033-1.755a.64.64 0 0 1 .967.56v4.704a.65.65 0 0 1-.967.56L10 20.157',
    ), // key: 17aeo9
    IconRectElement(3, 16, 7, 6, 1), // key: s27ndx
  ]);

  /// `file-volume.mjs`
  static const LucideGlyph
  fileVolume = LucideGlyph('file-volume', <IconElement>[
    IconPathElement(
      'M4 11.55V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2h-1.95',
    ), // key: 44gpjv
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M12 15a5 5 0 0 1 0 6'), // key: oxg87a
    IconPathElement(
      'M8 14.502a.5.5 0 0 0-.826-.381l-1.893 1.631a1 1 0 0 1-.651.243H3.5a.5.5 0 0 0-.5.501v3.006a.5.5 0 0 0 .5.501h1.129a1 1 0 0 1 .652.243l1.893 1.633a.5.5 0 0 0 .826-.38z',
    ), // key: 8rtoi1
  ]);

  /// `file-x-corner.mjs`
  static const LucideGlyph
  fileXCorner = LucideGlyph('file-x-corner', <IconElement>[
    IconPathElement(
      'M11 22H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v5',
    ), // key: 1jo35a
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('m15 17 5 5'), // key: 36xl1x
    IconPathElement('m20 17-5 5'), // key: vdz27y
  ]);

  /// `file-x.mjs`
  static const LucideGlyph fileX = LucideGlyph('file-x', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('m14.5 12.5-5 5'), // key: b62r18
    IconPathElement('m9.5 12.5 5 5'), // key: 1rk7el
  ]);

  /// `file.mjs`
  static const LucideGlyph file = LucideGlyph('file', <IconElement>[
    IconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
  ]);

  /// `files.mjs`
  static const LucideGlyph files = LucideGlyph('files', <IconElement>[
    IconPathElement(
      'M15 2h-4a2 2 0 0 0-2 2v11a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V8',
    ), // key: 14sh0y
    IconPathElement(
      'M16.706 2.706A2.4 2.4 0 0 0 15 2v5a1 1 0 0 0 1 1h5a2.4 2.4 0 0 0-.706-1.706z',
    ), // key: 1970lx
    IconPathElement(
      'M5 7a2 2 0 0 0-2 2v11a2 2 0 0 0 2 2h8a2 2 0 0 0 1.732-1',
    ), // key: l4dndm
  ]);

  /// `film.mjs`
  static const LucideGlyph film = LucideGlyph('film', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    IconPathElement('M7 3v18'), // key: bbkbws
    IconPathElement('M3 7.5h4'), // key: zfgn84
    IconPathElement('M3 12h18'), // key: 1i2n21
    IconPathElement('M3 16.5h4'), // key: 1230mu
    IconPathElement('M17 3v18'), // key: in4fa5
    IconPathElement('M17 7.5h4'), // key: myr1c1
    IconPathElement('M17 16.5h4'), // key: go4c1d
  ]);

  /// `fingerprint-pattern.mjs`
  static const LucideGlyph
  fingerprintPattern = LucideGlyph('fingerprint-pattern', <IconElement>[
    IconPathElement('M12 10a2 2 0 0 0-2 2c0 1.02-.1 2.51-.26 4'), // key: 1nerag
    IconPathElement('M14 13.12c0 2.38 0 6.38-1 8.88'), // key: o46ks0
    IconPathElement('M17.29 21.02c.12-.6.43-2.3.5-3.02'), // key: ptglia
    IconPathElement('M2 12a10 10 0 0 1 18-6'), // key: ydlgp0
    IconPathElement('M2 16h.01'), // key: 1gqxmh
    IconPathElement('M21.8 16c.2-2 .131-5.354 0-6'), // key: drycrb
    IconPathElement('M5 19.5C5.5 18 6 15 6 12a6 6 0 0 1 .34-2'), // key: 1tidbn
    IconPathElement('M8.65 22c.21-.66.45-1.32.57-2'), // key: 13wd9y
    IconPathElement('M9 6.8a6 6 0 0 1 9 5.2v2'), // key: 1fr1j5
  ]);

  /// `fire-extinguisher.mjs`
  static const LucideGlyph fireExtinguisher = LucideGlyph(
    'fire-extinguisher',
    <IconElement>[
      IconPathElement(
        'M15 6.5V3a1 1 0 0 0-1-1h-2a1 1 0 0 0-1 1v3.5',
      ), // key: sqyvz
      IconPathElement('M9 18h8'), // key: i7pszb
      IconPathElement('M18 3h-3'), // key: 7idoqj
      IconPathElement('M11 3a6 6 0 0 0-6 6v11'), // key: 1v5je3
      IconPathElement('M5 13h4'), // key: svpcxo
      IconPathElement(
        'M17 10a4 4 0 0 0-8 0v10a2 2 0 0 0 2 2h4a2 2 0 0 0 2-2Z',
      ), // key: vsjego
    ],
  );

  /// `fish-off.mjs`
  static const LucideGlyph fishOff = LucideGlyph('fish-off', <IconElement>[
    IconPathElement(
      'M18 12.47v.03m0-.5v.47m-.475 5.056A6.744 6.744 0 0 1 15 18c-3.56 0-7.56-2.53-8.5-6 .348-1.28 1.114-2.433 2.121-3.38m3.444-2.088A8.802 8.802 0 0 1 15 6c3.56 0 6.06 2.54 7 6-.309 1.14-.786 2.177-1.413 3.058',
    ), // key: 1j1hse
    IconPathElement(
      'M7 10.67C7 8 5.58 5.97 2.73 5.5c-1 1.5-1 5 .23 6.5-1.24 1.5-1.24 5-.23 6.5C5.58 18.03 7 16 7 13.33m7.48-4.372A9.77 9.77 0 0 1 16 6.07m0 11.86a9.77 9.77 0 0 1-1.728-3.618',
    ), // key: 1q46z8
    IconPathElement(
      'm16.01 17.93-.23 1.4A2 2 0 0 1 13.8 21H9.5a5.96 5.96 0 0 0 1.49-3.98M8.53 3h5.27a2 2 0 0 1 1.98 1.67l.23 1.4M2 2l20 20',
    ), // key: 1407gh
  ]);

  /// `fish-symbol.mjs`
  static const LucideGlyph fishSymbol = LucideGlyph(
    'fish-symbol',
    <IconElement>[
      IconPathElement('M2 16s9-15 20-4C11 23 2 8 2 8'), // key: h4oh4o
    ],
  );

  /// `fish.mjs`
  static const LucideGlyph fish = LucideGlyph('fish', <IconElement>[
    IconPathElement(
      'M6.5 12c.94-3.46 4.94-6 8.5-6 3.56 0 6.06 2.54 7 6-.94 3.47-3.44 6-7 6s-7.56-2.53-8.5-6Z',
    ), // key: 15baut
    IconPathElement('M18 12v.5'), // key: 18hhni
    IconPathElement('M16 17.93a9.77 9.77 0 0 1 0-11.86'), // key: 16dt7o
    IconPathElement(
      'M7 10.67C7 8 5.58 5.97 2.73 5.5c-1 1.5-1 5 .23 6.5-1.24 1.5-1.24 5-.23 6.5C5.58 18.03 7 16 7 13.33',
    ), // key: l9di03
    IconPathElement(
      'M10.46 7.26C10.2 5.88 9.17 4.24 8 3h5.8a2 2 0 0 1 1.98 1.67l.23 1.4',
    ), // key: 1kjonw
    IconPathElement(
      'm16.01 17.93-.23 1.4A2 2 0 0 1 13.8 21H9.5a5.96 5.96 0 0 0 1.49-3.98',
    ), // key: 1zlm23
  ]);

  /// `fishing-hook.mjs`
  static const LucideGlyph
  fishingHook = LucideGlyph('fishing-hook', <IconElement>[
    IconPathElement(
      'm17.586 11.414-5.93 5.93a1 1 0 0 1-8-8l3.137-3.137a.707.707 0 0 1 1.207.5V10',
    ), // key: 157y8s
    IconPathElement('M20.414 8.586 22 7'), // key: 5g2s34
    IconCircleElement(19, 10, 2), // key: 7363ft
  ]);

  /// `fishing-rod.mjs`
  static const LucideGlyph fishingRod = LucideGlyph(
    'fishing-rod',
    <IconElement>[
      IconPathElement('M4 11h1'), // key: 13eipc
      IconPathElement(
        'M8 15a2 2 0 0 1-4 0V3a1 1 0 0 1 1-1h.5C14 2 20 9 20 18v4',
      ), // key: 1hs3im
      IconCircleElement(18, 18, 2), // key: 1emm8v
    ],
  );

  /// `flag-off.mjs`
  static const LucideGlyph flagOff = LucideGlyph('flag-off', <IconElement>[
    IconPathElement('M16 16c-3 0-5-2-8-2a6 6 0 0 0-4 1.528'), // key: 1q158e
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement('M4 22V4'), // key: 1plyxx
    IconPathElement(
      'M7.656 2H8c3 0 5 2 7.333 2q2 0 3.067-.8A1 1 0 0 1 20 4v10.347',
    ), // key: xj1b71
  ]);

  /// `flag-triangle-left.mjs`
  static const LucideGlyph flagTriangleLeft = LucideGlyph(
    'flag-triangle-left',
    <IconElement>[
      IconPathElement(
        'M18 22V2.8a.8.8 0 0 0-1.17-.71L5.45 7.78a.8.8 0 0 0 0 1.44L18 15.5',
      ), // key: rbbtmw
    ],
  );

  /// `flag-triangle-right.mjs`
  static const LucideGlyph flagTriangleRight = LucideGlyph(
    'flag-triangle-right',
    <IconElement>[
      IconPathElement(
        'M6 22V2.8a.8.8 0 0 1 1.17-.71l11.38 5.69a.8.8 0 0 1 0 1.44L6 15.5',
      ), // key: kfjsu0
    ],
  );

  /// `flag.mjs`
  static const LucideGlyph flag = LucideGlyph('flag', <IconElement>[
    IconPathElement(
      'M4 22V4a1 1 0 0 1 .4-.8A6 6 0 0 1 8 2c3 0 5 2 7.333 2q2 0 3.067-.8A1 1 0 0 1 20 4v10a1 1 0 0 1-.4.8A6 6 0 0 1 16 16c-3 0-5-2-8-2a6 6 0 0 0-4 1.528',
    ), // key: 1jaruq
  ]);

  /// `flame-kindling.mjs`
  static const LucideGlyph
  flameKindling = LucideGlyph('flame-kindling', <IconElement>[
    IconPathElement(
      'M12 2c1 3 2.5 3.5 3.5 4.5A5 5 0 0 1 17 10a5 5 0 1 1-10 0c0-.3 0-.6.1-.9a2 2 0 1 0 3.3-2C8 4.5 11 2 12 2Z',
    ), // key: 1ir223
    IconPathElement('m5 22 14-4'), // key: 1brv4h
    IconPathElement('m5 18 14 4'), // key: lgyyje
  ]);

  /// `flame.mjs`
  static const LucideGlyph flame = LucideGlyph('flame', <IconElement>[
    IconPathElement(
      'M12 3q1 4 4 6.5t3 5.5a1 1 0 0 1-14 0 5 5 0 0 1 1-3 1 1 0 0 0 5 0c0-2-1.5-3-1.5-5q0-2 2.5-4',
    ), // key: 1slcih
  ]);

  /// `flashlight-off.mjs`
  static const LucideGlyph
  flashlightOff = LucideGlyph('flashlight-off', <IconElement>[
    IconPathElement('M11.652 6H18'), // key: voqkpr
    IconPathElement('M12 13v1'), // key: 176q98
    IconPathElement(
      'M16 16v4a2 2 0 0 1-2 2h-4a2 2 0 0 1-2-2v-8a4 4 0 0 0-.8-2.4l-.6-.8A3 3 0 0 1 6 7V6',
    ), // key: dzyf92
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement(
      'M7.649 2H17a1 1 0 0 1 1 1v4a3 3 0 0 1-.6 1.8l-.6.8a4 4 0 0 0-.55 1.007',
    ), // key: 1hvcfn
  ]);

  /// `flashlight.mjs`
  static const LucideGlyph flashlight = LucideGlyph('flashlight', <IconElement>[
    IconPathElement('M12 13v1'), // key: 176q98
    IconPathElement(
      'M17 2a1 1 0 0 1 1 1v4a3 3 0 0 1-.6 1.8l-.6.8A4 4 0 0 0 16 12v8a2 2 0 0 1-2 2H10a2 2 0 0 1-2-2v-8a4 4 0 0 0-.8-2.4l-.6-.8A3 3 0 0 1 6 7V3a1 1 0 0 1 1-1z',
    ), // key: 17vh7j
    IconPathElement('M6 6h12'), // key: n6hhss
  ]);

  /// `flask-conical-off.mjs`
  static const LucideGlyph flaskConicalOff = LucideGlyph(
    'flask-conical-off',
    <IconElement>[
      IconPathElement('M10 2v2.343'), // key: 15t272
      IconPathElement('M14 2v6.343'), // key: sxr80q
      IconPathElement('m2 2 20 20'), // key: 1ooewy
      IconPathElement(
        'M20 20a2 2 0 0 1-2 2H6a2 2 0 0 1-1.755-2.96l5.227-9.563',
      ), // key: k0duyd
      IconPathElement('M6.453 15H15'), // key: 1f0z33
      IconPathElement('M8.5 2h7'), // key: csnxdl
    ],
  );

  /// `flask-conical.mjs`
  static const LucideGlyph
  flaskConical = LucideGlyph('flask-conical', <IconElement>[
    IconPathElement(
      'M14 2v6a2 2 0 0 0 .245.96l5.51 10.08A2 2 0 0 1 18 22H6a2 2 0 0 1-1.755-2.96l5.51-10.08A2 2 0 0 0 10 8V2',
    ), // key: 18mbvz
    IconPathElement('M6.453 15h11.094'), // key: 3shlmq
    IconPathElement('M8.5 2h7'), // key: csnxdl
  ]);

  /// `flask-round.mjs`
  static const LucideGlyph flaskRound = LucideGlyph(
    'flask-round',
    <IconElement>[
      IconPathElement('M10 2v6.292a7 7 0 1 0 4 0V2'), // key: 1s42pc
      IconPathElement('M5 15h14'), // key: m0yey3
      IconPathElement('M8.5 2h7'), // key: csnxdl
    ],
  );

  /// `flip-horizontal-2.mjs`
  static const LucideGlyph flipHorizontal2 = LucideGlyph(
    'flip-horizontal-2',
    <IconElement>[
      IconPathElement('m3 7 5 5-5 5V7'), // key: couhi7
      IconPathElement('m21 7-5 5 5 5V7'), // key: 6ouia7
      IconPathElement('M12 20v2'), // key: 1lh1kg
      IconPathElement('M12 14v2'), // key: 8jcxud
      IconPathElement('M12 8v2'), // key: 1woqiv
      IconPathElement('M12 2v2'), // key: tus03m
    ],
  );

  /// `flip-vertical-2.mjs`
  static const LucideGlyph flipVertical2 = LucideGlyph(
    'flip-vertical-2',
    <IconElement>[
      IconPathElement('m17 3-5 5-5-5h10'), // key: 1ftt6x
      IconPathElement('m17 21-5-5-5 5h10'), // key: 1m0wmu
      IconPathElement('M4 12H2'), // key: rhcxmi
      IconPathElement('M10 12H8'), // key: s88cx1
      IconPathElement('M16 12h-2'), // key: 10asgb
      IconPathElement('M22 12h-2'), // key: 14jgyd
    ],
  );

  /// `flower-2.mjs`
  static const LucideGlyph flower2 = LucideGlyph('flower-2', <IconElement>[
    IconPathElement(
      'M12 5a3 3 0 1 1 3 3m-3-3a3 3 0 1 0-3 3m3-3v1M9 8a3 3 0 1 0 3 3M9 8h1m5 0a3 3 0 1 1-3 3m3-3h-1m-2 3v-1',
    ), // key: 3pnvol
    IconCircleElement(12, 8, 2), // key: 1822b1
    IconPathElement('M12 10v12'), // key: 6ubwww
    IconPathElement(
      'M12 22c4.2 0 7-1.667 7-5-4.2 0-7 1.667-7 5Z',
    ), // key: 9hd38g
    IconPathElement(
      'M12 22c-4.2 0-7-1.667-7-5 4.2 0 7 1.667 7 5Z',
    ), // key: ufn41s
  ]);

  /// `flower.mjs`
  static const LucideGlyph flower = LucideGlyph('flower', <IconElement>[
    IconCircleElement(12, 12, 3), // key: 1v7zrd
    IconPathElement(
      'M12 16.5A4.5 4.5 0 1 1 7.5 12 4.5 4.5 0 1 1 12 7.5a4.5 4.5 0 1 1 4.5 4.5 4.5 4.5 0 1 1-4.5 4.5',
    ), // key: 14wa3c
    IconPathElement('M12 7.5V9'), // key: 1oy5b0
    IconPathElement('M7.5 12H9'), // key: eltsq1
    IconPathElement('M16.5 12H15'), // key: vk5kw4
    IconPathElement('M12 16.5V15'), // key: k7eayi
    IconPathElement('m8 8 1.88 1.88'), // key: nxy4qf
    IconPathElement('M14.12 9.88 16 8'), // key: 1lst6k
    IconPathElement('m8 16 1.88-1.88'), // key: h2eex1
    IconPathElement('M14.12 14.12 16 16'), // key: uqkrx3
  ]);

  /// `focus.mjs`
  static const LucideGlyph focus = LucideGlyph('focus', <IconElement>[
    IconCircleElement(12, 12, 3), // key: 1v7zrd
    IconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    IconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    IconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    IconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
  ]);

  /// `fold-horizontal.mjs`
  static const LucideGlyph foldHorizontal = LucideGlyph(
    'fold-horizontal',
    <IconElement>[
      IconPathElement('M2 12h6'), // key: 1wqiqv
      IconPathElement('M22 12h-6'), // key: 1eg9hc
      IconPathElement('M12 2v2'), // key: tus03m
      IconPathElement('M12 8v2'), // key: 1woqiv
      IconPathElement('M12 14v2'), // key: 8jcxud
      IconPathElement('M12 20v2'), // key: 1lh1kg
      IconPathElement('m19 9-3 3 3 3'), // key: 12ol22
      IconPathElement('m5 15 3-3-3-3'), // key: 1kdhjc
    ],
  );

  /// `fold-vertical.mjs`
  static const LucideGlyph foldVertical = LucideGlyph(
    'fold-vertical',
    <IconElement>[
      IconPathElement('M12 22v-6'), // key: 6o8u61
      IconPathElement('M12 8V2'), // key: 1wkif3
      IconPathElement('M4 12H2'), // key: rhcxmi
      IconPathElement('M10 12H8'), // key: s88cx1
      IconPathElement('M16 12h-2'), // key: 10asgb
      IconPathElement('M22 12h-2'), // key: 14jgyd
      IconPathElement('m15 19-3-3-3 3'), // key: e37ymu
      IconPathElement('m15 5-3 3-3-3'), // key: 19d6lf
    ],
  );

  /// `folder-archive.mjs`
  static const LucideGlyph
  folderArchive = LucideGlyph('folder-archive', <IconElement>[
    IconCircleElement(15, 19, 2), // key: u2pros
    IconPathElement(
      'M20.9 19.8A2 2 0 0 0 22 18V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2h5.1',
    ), // key: 1jj40k
    IconPathElement('M15 11v-1'), // key: cntcp
    IconPathElement('M15 17v-2'), // key: 1279jj
  ]);

  /// `folder-bookmark.mjs`
  static const LucideGlyph
  folderBookmark = LucideGlyph('folder-bookmark', <IconElement>[
    IconPathElement('M12 6v8l3-3 3 3V6'), // key: 11pvqx
    IconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2z',
    ), // key: 1u1bxd
  ]);

  /// `folder-check.mjs`
  static const LucideGlyph
  folderCheck = LucideGlyph('folder-check', <IconElement>[
    IconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
    IconPathElement('m9 13 2 2 4-4'), // key: 6343dt
  ]);

  /// `folder-clock.mjs`
  static const LucideGlyph
  folderClock = LucideGlyph('folder-clock', <IconElement>[
    IconPathElement('M16 14v2.2l1.6 1'), // key: fo4ql5
    IconPathElement(
      'M7 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2',
    ), // key: 1urifu
    IconCircleElement(16, 16, 6), // key: qoo3c4
  ]);

  /// `folder-closed.mjs`
  static const LucideGlyph
  folderClosed = LucideGlyph('folder-closed', <IconElement>[
    IconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
    IconPathElement('M2 10h20'), // key: 1ir3d8
  ]);

  /// `folder-code.mjs`
  static const LucideGlyph
  folderCode = LucideGlyph('folder-code', <IconElement>[
    IconPathElement('M10 10.5 8 13l2 2.5'), // key: m4t9c1
    IconPathElement('m14 10.5 2 2.5-2 2.5'), // key: 14w2eb
    IconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2z',
    ), // key: 1u1bxd
  ]);

  /// `folder-cog.mjs`
  static const LucideGlyph folderCog = LucideGlyph('folder-cog', <IconElement>[
    IconPathElement(
      'M10.3 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.98a2 2 0 0 1 1.69.9l.66 1.2A2 2 0 0 0 12 6h8a2 2 0 0 1 2 2v3.3',
    ), // key: 128dxu
    IconPathElement('m14.305 19.53.923-.382'), // key: 3m78fa
    IconPathElement('m15.228 16.852-.923-.383'), // key: npixar
    IconPathElement('m16.852 15.228-.383-.923'), // key: 5xggr7
    IconPathElement('m16.852 20.772-.383.924'), // key: dpfhf9
    IconPathElement('m19.148 15.228.383-.923'), // key: 1reyyz
    IconPathElement('m19.53 21.696-.382-.924'), // key: 1goivc
    IconPathElement('m20.772 16.852.924-.383'), // key: htqkph
    IconPathElement('m20.772 19.148.924.383'), // key: 9w9pjp
    IconCircleElement(18, 18, 3), // key: 1xkwt0
  ]);

  /// `folder-dot.mjs`
  static const LucideGlyph folderDot = LucideGlyph('folder-dot', <IconElement>[
    IconPathElement(
      'M4 20h16a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.93a2 2 0 0 1-1.66-.9l-.82-1.2A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13c0 1.1.9 2 2 2Z',
    ), // key: 1fr9dc
    IconCircleElement(12, 13, 1), // key: 49l61u
  ]);

  /// `folder-down.mjs`
  static const LucideGlyph
  folderDown = LucideGlyph('folder-down', <IconElement>[
    IconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
    IconPathElement('M12 10v6'), // key: 1bos4e
    IconPathElement('m15 13-3 3-3-3'), // key: 6j2sf0
  ]);

  /// `folder-git-2.mjs`
  static const LucideGlyph
  folderGit2 = LucideGlyph('folder-git-2', <IconElement>[
    IconPathElement('M18 19a5 5 0 0 1-5-5v8'), // key: sz5oeg
    IconPathElement(
      'M9 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v5',
    ), // key: 1w6njk
    IconCircleElement(13, 12, 2), // key: 1j92g6
    IconCircleElement(20, 19, 2), // key: 1obnsp
  ]);

  /// `folder-git.mjs`
  static const LucideGlyph folderGit = LucideGlyph('folder-git', <IconElement>[
    IconCircleElement(12, 13, 2), // key: 1c1ljs
    IconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
    IconPathElement('M14 13h3'), // key: 1dgedf
    IconPathElement('M7 13h3'), // key: 1pygq7
  ]);

  /// `folder-heart.mjs`
  static const LucideGlyph
  folderHeart = LucideGlyph('folder-heart', <IconElement>[
    IconPathElement(
      'M10.638 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v3.417',
    ), // key: 10r6g4
    IconPathElement(
      'M14.62 18.8A2.25 2.25 0 1 1 18 15.836a2.25 2.25 0 1 1 3.38 2.966l-2.626 2.856a.998.998 0 0 1-1.507 0z',
    ), // key: 15cy7q
  ]);

  /// `folder-input.mjs`
  static const LucideGlyph
  folderInput = LucideGlyph('folder-input', <IconElement>[
    IconPathElement(
      'M2 9V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-1',
    ), // key: fm4g5t
    IconPathElement('M2 13h10'), // key: pgb2dq
    IconPathElement('m9 16 3-3-3-3'), // key: 6m91ic
  ]);

  /// `folder-kanban.mjs`
  static const LucideGlyph
  folderKanban = LucideGlyph('folder-kanban', <IconElement>[
    IconPathElement(
      'M4 20h16a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.93a2 2 0 0 1-1.66-.9l-.82-1.2A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13c0 1.1.9 2 2 2Z',
    ), // key: 1fr9dc
    IconPathElement('M8 10v4'), // key: tgpxqk
    IconPathElement('M12 10v2'), // key: hh53o1
    IconPathElement('M16 10v6'), // key: 1d6xys
  ]);

  /// `folder-key.mjs`
  static const LucideGlyph folderKey = LucideGlyph('folder-key', <IconElement>[
    IconPathElement(
      'M13 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v1.36',
    ), // key: 1shsnm
    IconPathElement('M19 12v6'), // key: kflna4
    IconPathElement('M19 14h2'), // key: wp2qbk
    IconCircleElement(19, 20, 2), // key: 1jfyz6
  ]);

  /// `folder-lock.mjs`
  static const LucideGlyph
  folderLock = LucideGlyph('folder-lock', <IconElement>[
    IconRectElement(14, 17, 8, 5, 1), // key: 19aais
    IconPathElement(
      'M10 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v2.5',
    ), // key: 1w6v7t
    IconPathElement('M20 17v-2a2 2 0 1 0-4 0v2'), // key: pwaxnr
  ]);

  /// `folder-minus.mjs`
  static const LucideGlyph
  folderMinus = LucideGlyph('folder-minus', <IconElement>[
    IconPathElement('M9 13h6'), // key: 1uhe8q
    IconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
  ]);

  /// `folder-open-dot.mjs`
  static const LucideGlyph
  folderOpenDot = LucideGlyph('folder-open-dot', <IconElement>[
    IconPathElement(
      'm6 14 1.45-2.9A2 2 0 0 1 9.24 10H20a2 2 0 0 1 1.94 2.5l-1.55 6a2 2 0 0 1-1.94 1.5H4a2 2 0 0 1-2-2V5c0-1.1.9-2 2-2h3.93a2 2 0 0 1 1.66.9l.82 1.2a2 2 0 0 0 1.66.9H18a2 2 0 0 1 2 2v2',
    ), // key: 1nmvlm
    IconCircleElement(14, 15, 1), // key: 1gm4qj
  ]);

  /// `folder-open.mjs`
  static const LucideGlyph
  folderOpen = LucideGlyph('folder-open', <IconElement>[
    IconPathElement(
      'm6 14 1.5-2.9A2 2 0 0 1 9.24 10H20a2 2 0 0 1 1.94 2.5l-1.54 6a2 2 0 0 1-1.95 1.5H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H18a2 2 0 0 1 2 2v2',
    ), // key: usdka0
  ]);

  /// `folder-output.mjs`
  static const LucideGlyph
  folderOutput = LucideGlyph('folder-output', <IconElement>[
    IconPathElement(
      'M2 7.5V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-1.5',
    ), // key: 1yk7aj
    IconPathElement('M2 13h10'), // key: pgb2dq
    IconPathElement('m5 10-3 3 3 3'), // key: 1r8ie0
  ]);

  /// `folder-pen.mjs`
  static const LucideGlyph folderPen = LucideGlyph('folder-pen', <IconElement>[
    IconPathElement(
      'M2 11.5V5a2 2 0 0 1 2-2h3.9c.7 0 1.3.3 1.7.9l.8 1.2c.4.6 1 .9 1.7.9H20a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-9.5',
    ), // key: a8xqs0
    IconPathElement(
      'M11.378 13.626a1 1 0 1 0-3.004-3.004l-5.01 5.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z',
    ), // key: 1saktj
  ]);

  /// `folder-plus.mjs`
  static const LucideGlyph
  folderPlus = LucideGlyph('folder-plus', <IconElement>[
    IconPathElement('M12 10v6'), // key: 1bos4e
    IconPathElement('M9 13h6'), // key: 1uhe8q
    IconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
  ]);

  /// `folder-root.mjs`
  static const LucideGlyph
  folderRoot = LucideGlyph('folder-root', <IconElement>[
    IconPathElement(
      'M4 20h16a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.93a2 2 0 0 1-1.66-.9l-.82-1.2A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13c0 1.1.9 2 2 2Z',
    ), // key: 1fr9dc
    IconCircleElement(12, 13, 2), // key: 1c1ljs
    IconPathElement('M12 15v5'), // key: 11xva1
  ]);

  /// `folder-search-2.mjs`
  static const LucideGlyph
  folderSearch2 = LucideGlyph('folder-search-2', <IconElement>[
    IconCircleElement(11.5, 12.5, 2.5), // key: 1ea5ju
    IconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
    IconPathElement('M13.3 14.3 15 16'), // key: 1y4v1n
  ]);

  /// `folder-search.mjs`
  static const LucideGlyph
  folderSearch = LucideGlyph('folder-search', <IconElement>[
    IconPathElement(
      'M10.7 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v4.1',
    ), // key: 1bw5m7
    IconPathElement('m21 21-1.9-1.9'), // key: 1g2n9r
    IconCircleElement(17, 17, 3), // key: 18b49y
  ]);

  /// `folder-symlink.mjs`
  static const LucideGlyph
  folderSymlink = LucideGlyph('folder-symlink', <IconElement>[
    IconPathElement(
      'M2 9.35V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h7',
    ), // key: y8kt7d
    IconPathElement('m8 16 3-3-3-3'), // key: rlqrt1
  ]);

  /// `folder-sync.mjs`
  static const LucideGlyph
  folderSync = LucideGlyph('folder-sync', <IconElement>[
    IconPathElement(
      'M9 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v.5',
    ), // key: 1dkoa9
    IconPathElement('M12 10v4h4'), // key: 1czhmt
    IconPathElement('m12 14 1.535-1.605a5 5 0 0 1 8 1.5'), // key: lvuxfi
    IconPathElement('M22 22v-4h-4'), // key: 1ewp4q
    IconPathElement('m22 18-1.535 1.605a5 5 0 0 1-8-1.5'), // key: 14ync0
  ]);

  /// `folder-tree.mjs`
  static const LucideGlyph
  folderTree = LucideGlyph('folder-tree', <IconElement>[
    IconPathElement(
      'M20 10a1 1 0 0 0 1-1V6a1 1 0 0 0-1-1h-2.5a1 1 0 0 1-.8-.4l-.9-1.2A1 1 0 0 0 15 3h-2a1 1 0 0 0-1 1v5a1 1 0 0 0 1 1Z',
    ), // key: hod4my
    IconPathElement(
      'M20 21a1 1 0 0 0 1-1v-3a1 1 0 0 0-1-1h-2.9a1 1 0 0 1-.88-.55l-.42-.85a1 1 0 0 0-.92-.6H13a1 1 0 0 0-1 1v5a1 1 0 0 0 1 1Z',
    ), // key: w4yl2u
    IconPathElement('M3 5a2 2 0 0 0 2 2h3'), // key: f2jnh7
    IconPathElement('M3 3v13a2 2 0 0 0 2 2h3'), // key: k8epm1
  ]);

  /// `folder-up.mjs`
  static const LucideGlyph folderUp = LucideGlyph('folder-up', <IconElement>[
    IconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
    IconPathElement('M12 10v6'), // key: 1bos4e
    IconPathElement('m9 13 3-3 3 3'), // key: 1pxg3c
  ]);

  /// `folder-x.mjs`
  static const LucideGlyph folderX = LucideGlyph('folder-x', <IconElement>[
    IconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
    IconPathElement('m9.5 10.5 5 5'), // key: ra9qjz
    IconPathElement('m14.5 10.5-5 5'), // key: l2rkpq
  ]);

  /// `folder.mjs`
  static const LucideGlyph folder = LucideGlyph('folder', <IconElement>[
    IconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
  ]);

  /// `folders.mjs`
  static const LucideGlyph folders = LucideGlyph('folders', <IconElement>[
    IconPathElement(
      'M20 5a2 2 0 0 1 2 2v7a2 2 0 0 1-2 2H9a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h2.5a1.5 1.5 0 0 1 1.2.6l.6.8a1.5 1.5 0 0 0 1.2.6z',
    ), // key: a4852j
    IconPathElement(
      'M3 8.268a2 2 0 0 0-1 1.738V19a2 2 0 0 0 2 2h11a2 2 0 0 0 1.732-1',
    ), // key: yxbcw3
  ]);

  /// `footprints.mjs`
  static const LucideGlyph footprints = LucideGlyph('footprints', <IconElement>[
    IconPathElement(
      'M4 16v-2.38C4 11.5 2.97 10.5 3 8c.03-2.72 1.49-6 4.5-6C9.37 2 10 3.8 10 5.5c0 3.11-2 5.66-2 8.68V16a2 2 0 1 1-4 0Z',
    ), // key: 1dudjm
    IconPathElement(
      'M20 20v-2.38c0-2.12 1.03-3.12 1-5.62-.03-2.72-1.49-6-4.5-6C14.63 6 14 7.8 14 9.5c0 3.11 2 5.66 2 8.68V20a2 2 0 1 0 4 0Z',
    ), // key: l2t8xc
    IconPathElement('M16 17h4'), // key: 1dejxt
    IconPathElement('M4 13h4'), // key: 1bwh8b
  ]);

  /// `forklift.mjs`
  static const LucideGlyph forklift = LucideGlyph('forklift', <IconElement>[
    IconPathElement('M12 12H5a2 2 0 0 0-2 2v5'), // key: 7zsz91
    IconPathElement('M15 19h7'), // key: 1askl3
    IconPathElement('M16 19V2'), // key: 1gf9nk
    IconPathElement(
      'M6 12V7a2 2 0 0 1 2-2h2.172a2 2 0 0 1 1.414.586l3.828 3.828A2 2 0 0 1 16 10.828',
    ), // key: enx9tf
    IconPathElement('M7 19h4'), // key: fumhkk
    IconCircleElement(13, 19, 2), // key: wjnkru
    IconCircleElement(5, 19, 2), // key: v8kfzx
  ]);

  /// `form.mjs`
  static const LucideGlyph form = LucideGlyph('form', <IconElement>[
    IconPathElement('M4 14h6'), // key: 77gv2w
    IconPathElement('M4 2h10'), // key: a2b314
    IconRectElement(4, 18, 16, 4, 1), // key: sybzq6
    IconRectElement(4, 6, 16, 4, 1), // key: 1osc9e
  ]);

  /// `forward.mjs`
  static const LucideGlyph forward = LucideGlyph('forward', <IconElement>[
    IconPathElement('m15 17 5-5-5-5'), // key: nf172w
    IconPathElement('M4 18v-2a4 4 0 0 1 4-4h12'), // key: jmiej9
  ]);

  /// `frame.mjs`
  static const LucideGlyph frame = LucideGlyph('frame', <IconElement>[
    IconLineElement(22, 6, 2, 6), // key: 15w7dq
    IconLineElement(22, 18, 2, 18), // key: 1ip48p
    IconLineElement(6, 2, 6, 22), // key: a2lnyx
    IconLineElement(18, 2, 18, 22), // key: 8vb6jd
  ]);

  /// `frown.mjs`
  static const LucideGlyph frown = LucideGlyph('frown', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M16 16s-1.5-2-4-2-4 2-4 2'), // key: epbg0q
    IconLineElement(9, 9, 9.01, 9), // key: yxxnd0
    IconLineElement(15, 9, 15.01, 9), // key: 1p4y9e
  ]);

  /// `fuel.mjs`
  static const LucideGlyph fuel = LucideGlyph('fuel', <IconElement>[
    IconPathElement(
      'M14 13h2a2 2 0 0 1 2 2v2a2 2 0 0 0 4 0v-6.998a2 2 0 0 0-.59-1.42L18 5',
    ), // key: 1wtuz0
    IconPathElement('M14 21V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v16'), // key: e09ifn
    IconPathElement('M2 21h13'), // key: 1x0fut
    IconPathElement('M3 9h11'), // key: 1p7c0w
  ]);

  /// `fullscreen.mjs`
  static const LucideGlyph fullscreen = LucideGlyph('fullscreen', <IconElement>[
    IconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    IconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    IconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    IconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
    IconRectElement(7, 8, 10, 8, 1), // key: vys8me
  ]);

  /// `funnel-plus.mjs`
  static const LucideGlyph
  funnelPlus = LucideGlyph('funnel-plus', <IconElement>[
    IconPathElement(
      'M13.354 3H3a1 1 0 0 0-.742 1.67l7.225 7.989A2 2 0 0 1 10 14v6a1 1 0 0 0 .553.895l2 1A1 1 0 0 0 14 21v-7a2 2 0 0 1 .517-1.341l1.218-1.348',
    ), // key: 8mvsmf
    IconPathElement('M16 6h6'), // key: 1dogtp
    IconPathElement('M19 3v6'), // key: 1ytpjt
  ]);

  /// `funnel-x.mjs`
  static const LucideGlyph funnelX = LucideGlyph('funnel-x', <IconElement>[
    IconPathElement(
      'M12.531 3H3a1 1 0 0 0-.742 1.67l7.225 7.989A2 2 0 0 1 10 14v6a1 1 0 0 0 .553.895l2 1A1 1 0 0 0 14 21v-7a2 2 0 0 1 .517-1.341l.427-.473',
    ), // key: ol2ft2
    IconPathElement('m16.5 3.5 5 5'), // key: 15e6fa
    IconPathElement('m21.5 3.5-5 5'), // key: m0lwru
  ]);

  /// `funnel.mjs`
  static const LucideGlyph funnel = LucideGlyph('funnel', <IconElement>[
    IconPathElement(
      'M10 20a1 1 0 0 0 .553.895l2 1A1 1 0 0 0 14 21v-7a2 2 0 0 1 .517-1.341L21.74 4.67A1 1 0 0 0 21 3H3a1 1 0 0 0-.742 1.67l7.225 7.989A2 2 0 0 1 10 14z',
    ), // key: sc7q7i
  ]);

  /// `gallery-horizontal-end.mjs`
  static const LucideGlyph galleryHorizontalEnd = LucideGlyph(
    'gallery-horizontal-end',
    <IconElement>[
      IconPathElement('M2 7v10'), // key: a2pl2d
      IconPathElement('M6 5v14'), // key: 1kq3d7
      IconRectElement(10, 3, 12, 18, 2), // key: 13i7bc
    ],
  );

  /// `gallery-horizontal.mjs`
  static const LucideGlyph galleryHorizontal = LucideGlyph(
    'gallery-horizontal',
    <IconElement>[
      IconPathElement('M2 3v18'), // key: pzttux
      IconRectElement(6, 3, 12, 18, 2), // key: btr8bg
      IconPathElement('M22 3v18'), // key: 6jf3v
    ],
  );

  /// `gallery-thumbnails.mjs`
  static const LucideGlyph galleryThumbnails = LucideGlyph(
    'gallery-thumbnails',
    <IconElement>[
      IconRectElement(3, 3, 18, 14, 2), // key: 74y24f
      IconPathElement('M4 21h1'), // key: 16zlid
      IconPathElement('M9 21h1'), // key: 15o7lz
      IconPathElement('M14 21h1'), // key: v9vybs
      IconPathElement('M19 21h1'), // key: edywat
    ],
  );

  /// `gallery-vertical-end.mjs`
  static const LucideGlyph galleryVerticalEnd = LucideGlyph(
    'gallery-vertical-end',
    <IconElement>[
      IconPathElement('M7 2h10'), // key: nczekb
      IconPathElement('M5 6h14'), // key: u2x4p
      IconRectElement(3, 10, 18, 12, 2), // key: l0tzu3
    ],
  );

  /// `gallery-vertical.mjs`
  static const LucideGlyph galleryVertical = LucideGlyph(
    'gallery-vertical',
    <IconElement>[
      IconPathElement('M3 2h18'), // key: 15qxfx
      IconRectElement(3, 6, 18, 12, 2), // key: 1439r6
      IconPathElement('M3 22h18'), // key: 8prr45
    ],
  );

  /// `gamepad-2.mjs`
  static const LucideGlyph gamepad2 = LucideGlyph('gamepad-2', <IconElement>[
    IconLineElement(6, 11, 10, 11), // key: 1gktln
    IconLineElement(8, 9, 8, 13), // key: qnk9ow
    IconLineElement(15, 12, 15.01, 12), // key: krot7o
    IconLineElement(18, 10, 18.01, 10), // key: 1lcuu1
    IconPathElement(
      'M17.32 5H6.68a4 4 0 0 0-3.978 3.59c-.006.052-.01.101-.017.152C2.604 9.416 2 14.456 2 16a3 3 0 0 0 3 3c1 0 1.5-.5 2-1l1.414-1.414A2 2 0 0 1 9.828 16h4.344a2 2 0 0 1 1.414.586L17 18c.5.5 1 1 2 1a3 3 0 0 0 3-3c0-1.545-.604-6.584-.685-7.258-.007-.05-.011-.1-.017-.151A4 4 0 0 0 17.32 5z',
    ), // key: mfqc10
  ]);

  /// `gamepad-directional.mjs`
  static const LucideGlyph
  gamepadDirectional = LucideGlyph('gamepad-directional', <IconElement>[
    IconPathElement(
      'M11.146 15.854a1.207 1.207 0 0 1 1.708 0l1.56 1.56A2 2 0 0 1 15 18.828V21a1 1 0 0 1-1 1h-4a1 1 0 0 1-1-1v-2.172a2 2 0 0 1 .586-1.414z',
    ), // key: 1re2og
    IconPathElement(
      'M18.828 15a2 2 0 0 1-1.414-.586l-1.56-1.56a1.207 1.207 0 0 1 0-1.708l1.56-1.56A2 2 0 0 1 18.828 9H21a1 1 0 0 1 1 1v4a1 1 0 0 1-1 1z',
    ), // key: 1pchrj
    IconPathElement(
      'M6.586 14.414A2 2 0 0 1 5.172 15H3a1 1 0 0 1-1-1v-4a1 1 0 0 1 1-1h2.172a2 2 0 0 1 1.414.586l1.56 1.56a1.207 1.207 0 0 1 0 1.708z',
    ), // key: 16mt4c
    IconPathElement(
      'M9 3a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2.172a2 2 0 0 1-.586 1.414l-1.56 1.56a1.207 1.207 0 0 1-1.708 0l-1.56-1.56A2 2 0 0 1 9 5.172z',
    ), // key: 19ox6c
  ]);

  /// `gamepad.mjs`
  static const LucideGlyph gamepad = LucideGlyph('gamepad', <IconElement>[
    IconLineElement(6, 12, 10, 12), // key: 161bw2
    IconLineElement(8, 10, 8, 14), // key: 1i6ji0
    IconLineElement(15, 13, 15.01, 13), // key: dqpgro
    IconLineElement(18, 11, 18.01, 11), // key: meh2c
    IconRectElement(2, 6, 20, 12, 2), // key: 9lu3g6
  ]);

  /// `gauge.mjs`
  static const LucideGlyph gauge = LucideGlyph('gauge', <IconElement>[
    IconPathElement('m12 14 4-4'), // key: 9kzdfg
    IconPathElement('M3.34 19a10 10 0 1 1 17.32 0'), // key: 19p75a
  ]);

  /// `gavel.mjs`
  static const LucideGlyph gavel = LucideGlyph('gavel', <IconElement>[
    IconPathElement(
      'm14 13-8.381 8.38a1 1 0 0 1-3.001-3l8.384-8.381',
    ), // key: pgg06f
    IconPathElement('m16 16 6-6'), // key: vzrcl6
    IconPathElement('m21.5 10.5-8-8'), // key: a17d9x
    IconPathElement('m8 8 6-6'), // key: 18bi4p
    IconPathElement('m8.5 7.5 8 8'), // key: 1oyaui
  ]);

  /// `gem.mjs`
  static const LucideGlyph gem = LucideGlyph('gem', <IconElement>[
    IconPathElement('M10.5 3 8 9l4 13 4-13-2.5-6'), // key: b3dvk1
    IconPathElement(
      'M17 3a2 2 0 0 1 1.6.8l3 4a2 2 0 0 1 .013 2.382l-7.99 10.986a2 2 0 0 1-3.247 0l-7.99-10.986A2 2 0 0 1 2.4 7.8l2.998-3.997A2 2 0 0 1 7 3z',
    ), // key: 7w4byz
    IconPathElement('M2 9h20'), // key: 16fsjt
  ]);

  /// `georgian-lari.mjs`
  static const LucideGlyph georgianLari = LucideGlyph(
    'georgian-lari',
    <IconElement>[
      IconPathElement('M11.5 21a7.5 7.5 0 1 1 7.35-9'), // key: 1gyj8k
      IconPathElement('M13 12V3'), // key: 18om2a
      IconPathElement('M4 21h16'), // key: 1h09gz
      IconPathElement('M9 12V3'), // key: geutu0
    ],
  );

  /// `ghost.mjs`
  static const LucideGlyph ghost = LucideGlyph('ghost', <IconElement>[
    IconPathElement('M9 10h.01'), // key: qbtxuw
    IconPathElement('M15 10h.01'), // key: 1qmjsl
    IconPathElement(
      'M12 2a8 8 0 0 0-8 8v12l3-3 2.5 2.5L12 19l2.5 2.5L17 19l3 3V10a8 8 0 0 0-8-8z',
    ), // key: uwwb07
  ]);

  /// `gift.mjs`
  static const LucideGlyph gift = LucideGlyph('gift', <IconElement>[
    IconPathElement('M12 7v14'), // key: 1akyts
    IconPathElement('M20 11v8a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-8'), // key: 1sqzm4
    IconPathElement(
      'M7.5 7a1 1 0 0 1 0-5A4.8 8 0 0 1 12 7a4.8 8 0 0 1 4.5-5 1 1 0 0 1 0 5',
    ), // key: kc0143
    IconRectElement(3, 7, 18, 4, 1), // key: 1hberx
  ]);

  /// `git-branch-minus.mjs`
  static const LucideGlyph gitBranchMinus = LucideGlyph(
    'git-branch-minus',
    <IconElement>[
      IconPathElement('M15 6a9 9 0 0 0-9 9V3'), // key: 1cii5b
      IconPathElement('M21 18h-6'), // key: 139f0c
      IconCircleElement(18, 6, 3), // key: 1h7g24
      IconCircleElement(6, 18, 3), // key: fqmcym
    ],
  );

  /// `git-branch-plus.mjs`
  static const LucideGlyph gitBranchPlus = LucideGlyph(
    'git-branch-plus',
    <IconElement>[
      IconPathElement('M6 3v12'), // key: qpgusn
      IconPathElement('M18 9a3 3 0 1 0 0-6 3 3 0 0 0 0 6z'), // key: 1d02ji
      IconPathElement('M6 21a3 3 0 1 0 0-6 3 3 0 0 0 0 6z'), // key: chk6ph
      IconPathElement('M15 6a9 9 0 0 0-9 9'), // key: or332x
      IconPathElement('M18 15v6'), // key: 9wciyi
      IconPathElement('M21 18h-6'), // key: 139f0c
    ],
  );

  /// `git-branch.mjs`
  static const LucideGlyph gitBranch = LucideGlyph('git-branch', <IconElement>[
    IconPathElement('M15 6a9 9 0 0 0-9 9V3'), // key: 1cii5b
    IconCircleElement(18, 6, 3), // key: 1h7g24
    IconCircleElement(6, 18, 3), // key: fqmcym
  ]);

  /// `git-commit-horizontal.mjs`
  static const LucideGlyph gitCommitHorizontal = LucideGlyph(
    'git-commit-horizontal',
    <IconElement>[
      IconCircleElement(12, 12, 3), // key: 1v7zrd
      IconLineElement(3, 12, 9, 12), // key: 1dyftd
      IconLineElement(15, 12, 21, 12), // key: oup4p8
    ],
  );

  /// `git-commit-vertical.mjs`
  static const LucideGlyph gitCommitVertical = LucideGlyph(
    'git-commit-vertical',
    <IconElement>[
      IconPathElement('M12 3v6'), // key: 1holv5
      IconCircleElement(12, 12, 3), // key: 1v7zrd
      IconPathElement('M12 15v6'), // key: a9ows0
    ],
  );

  /// `git-compare-arrows.mjs`
  static const LucideGlyph gitCompareArrows = LucideGlyph(
    'git-compare-arrows',
    <IconElement>[
      IconCircleElement(5, 6, 3), // key: 1qnov2
      IconPathElement('M12 6h5a2 2 0 0 1 2 2v7'), // key: 1yj91y
      IconPathElement('m15 9-3-3 3-3'), // key: 1lwv8l
      IconCircleElement(19, 18, 3), // key: 1qljk2
      IconPathElement('M12 18H7a2 2 0 0 1-2-2V9'), // key: 16sdep
      IconPathElement('m9 15 3 3-3 3'), // key: 1m3kbl
    ],
  );

  /// `git-compare.mjs`
  static const LucideGlyph gitCompare = LucideGlyph(
    'git-compare',
    <IconElement>[
      IconCircleElement(18, 18, 3), // key: 1xkwt0
      IconCircleElement(6, 6, 3), // key: 1lh9wr
      IconPathElement('M13 6h3a2 2 0 0 1 2 2v7'), // key: 1yeb86
      IconPathElement('M11 18H8a2 2 0 0 1-2-2V9'), // key: 19pyzm
    ],
  );

  /// `git-fork.mjs`
  static const LucideGlyph gitFork = LucideGlyph('git-fork', <IconElement>[
    IconCircleElement(12, 18, 3), // key: 1mpf1b
    IconCircleElement(6, 6, 3), // key: 1lh9wr
    IconCircleElement(18, 6, 3), // key: 1h7g24
    IconPathElement('M18 9v2c0 .6-.4 1-1 1H7c-.6 0-1-.4-1-1V9'), // key: 1uq4wg
    IconPathElement('M12 12v3'), // key: 158kv8
  ]);

  /// `git-graph.mjs`
  static const LucideGlyph gitGraph = LucideGlyph('git-graph', <IconElement>[
    IconCircleElement(5, 6, 3), // key: 1qnov2
    IconPathElement('M5 9v6'), // key: 158jrl
    IconCircleElement(5, 18, 3), // key: 104gr9
    IconPathElement('M12 3v18'), // key: 108xh3
    IconCircleElement(19, 6, 3), // key: 108a5v
    IconPathElement('M16 15.7A9 9 0 0 0 19 9'), // key: 1e3vqb
  ]);

  /// `git-merge-conflict.mjs`
  static const LucideGlyph gitMergeConflict = LucideGlyph(
    'git-merge-conflict',
    <IconElement>[
      IconPathElement('M12 6h4a2 2 0 0 1 2 2v7'), // key: 18ej7s
      IconPathElement('M6 12v9'), // key: 9e33v1
      IconPathElement('M9 3 3 9'), // key: ahyygn
      IconPathElement('M9 9 3 3'), // key: v551iv
      IconCircleElement(18, 18, 3), // key: 1xkwt0
    ],
  );

  /// `git-merge.mjs`
  static const LucideGlyph gitMerge = LucideGlyph('git-merge', <IconElement>[
    IconCircleElement(18, 18, 3), // key: 1xkwt0
    IconCircleElement(6, 6, 3), // key: 1lh9wr
    IconPathElement('M6 21V9a9 9 0 0 0 9 9'), // key: 7kw0sc
  ]);

  /// `git-pull-request-arrow.mjs`
  static const LucideGlyph gitPullRequestArrow = LucideGlyph(
    'git-pull-request-arrow',
    <IconElement>[
      IconCircleElement(5, 6, 3), // key: 1qnov2
      IconPathElement('M5 9v12'), // key: ih889a
      IconCircleElement(19, 18, 3), // key: 1qljk2
      IconPathElement('m15 9-3-3 3-3'), // key: 1lwv8l
      IconPathElement('M12 6h5a2 2 0 0 1 2 2v7'), // key: 1yj91y
    ],
  );

  /// `git-pull-request-closed.mjs`
  static const LucideGlyph gitPullRequestClosed = LucideGlyph(
    'git-pull-request-closed',
    <IconElement>[
      IconCircleElement(6, 6, 3), // key: 1lh9wr
      IconPathElement('M6 9v12'), // key: 1sc30k
      IconPathElement('m21 3-6 6'), // key: 16nqsk
      IconPathElement('m21 9-6-6'), // key: 9j17rh
      IconPathElement('M18 11.5V15'), // key: 65xf6f
      IconCircleElement(18, 18, 3), // key: 1xkwt0
    ],
  );

  /// `git-pull-request-create-arrow.mjs`
  static const LucideGlyph gitPullRequestCreateArrow = LucideGlyph(
    'git-pull-request-create-arrow',
    <IconElement>[
      IconCircleElement(5, 6, 3), // key: 1qnov2
      IconPathElement('M5 9v12'), // key: ih889a
      IconPathElement('m15 9-3-3 3-3'), // key: 1lwv8l
      IconPathElement('M12 6h5a2 2 0 0 1 2 2v3'), // key: 1rbwk6
      IconPathElement('M19 15v6'), // key: 10aioa
      IconPathElement('M22 18h-6'), // key: 1d5gi5
    ],
  );

  /// `git-pull-request-create.mjs`
  static const LucideGlyph gitPullRequestCreate = LucideGlyph(
    'git-pull-request-create',
    <IconElement>[
      IconCircleElement(6, 6, 3), // key: 1lh9wr
      IconPathElement('M6 9v12'), // key: 1sc30k
      IconPathElement('M13 6h3a2 2 0 0 1 2 2v3'), // key: 1jb6z3
      IconPathElement('M18 15v6'), // key: 9wciyi
      IconPathElement('M21 18h-6'), // key: 139f0c
    ],
  );

  /// `git-pull-request-draft.mjs`
  static const LucideGlyph gitPullRequestDraft = LucideGlyph(
    'git-pull-request-draft',
    <IconElement>[
      IconCircleElement(18, 18, 3), // key: 1xkwt0
      IconCircleElement(6, 6, 3), // key: 1lh9wr
      IconPathElement('M18 6V5'), // key: 1oao2s
      IconPathElement('M18 11v-1'), // key: 11c8tz
      IconLineElement(6, 9, 6, 21), // key: rroup
    ],
  );

  /// `git-pull-request.mjs`
  static const LucideGlyph gitPullRequest = LucideGlyph(
    'git-pull-request',
    <IconElement>[
      IconCircleElement(18, 18, 3), // key: 1xkwt0
      IconCircleElement(6, 6, 3), // key: 1lh9wr
      IconPathElement('M13 6h3a2 2 0 0 1 2 2v7'), // key: 1yeb86
      IconLineElement(6, 9, 6, 21), // key: rroup
    ],
  );

  /// `glass-water.mjs`
  static const LucideGlyph
  glassWater = LucideGlyph('glass-water', <IconElement>[
    IconPathElement(
      'M5.116 4.104A1 1 0 0 1 6.11 3h11.78a1 1 0 0 1 .994 1.105L17.19 20.21A2 2 0 0 1 15.2 22H8.8a2 2 0 0 1-2-1.79z',
    ), // key: p55z4y
    IconPathElement('M6 12a5 5 0 0 1 6 0 5 5 0 0 0 6 0'), // key: mjntcy
  ]);

  /// `glasses.mjs`
  static const LucideGlyph glasses = LucideGlyph('glasses', <IconElement>[
    IconCircleElement(6, 15, 4), // key: vux9w4
    IconCircleElement(18, 15, 4), // key: 18o8ve
    IconPathElement('M14 15a2 2 0 0 0-2-2 2 2 0 0 0-2 2'), // key: 1ag4bs
    IconPathElement('M2.5 13 5 7c.7-1.3 1.4-2 3-2'), // key: 1hm1gs
    IconPathElement('M21.5 13 19 7c-.7-1.3-1.5-2-3-2'), // key: 1r31ai
  ]);

  /// `globe-check.mjs`
  static const LucideGlyph globeCheck = LucideGlyph(
    'globe-check',
    <IconElement>[
      IconPathElement('m15 6 2 2 4-4'), // key: levio8
      IconPathElement(
        'M2 12h20A10 10 0 1 1 12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 4-10',
      ), // key: 46evmv
    ],
  );

  /// `globe-lock.mjs`
  static const LucideGlyph globeLock = LucideGlyph('globe-lock', <IconElement>[
    IconPathElement(
      'M15.686 15A14.5 14.5 0 0 1 12 22a14.5 14.5 0 0 1 0-20 10 10 0 1 0 9.542 13',
    ), // key: qkt0x6
    IconPathElement('M2 12h8.5'), // key: ovaggd
    IconPathElement('M20 6V4a2 2 0 1 0-4 0v2'), // key: 1of5e8
    IconRectElement(14, 6, 8, 5, 1), // key: 1fmf51
  ]);

  /// `globe-off.mjs`
  static const LucideGlyph globeOff = LucideGlyph('globe-off', <IconElement>[
    IconPathElement(
      'M10.114 4.462A14.5 14.5 0 0 1 12 2a10 10 0 0 1 9.313 13.643',
    ), // key: 1jq2r7
    IconPathElement(
      'M15.557 15.556A14.5 14.5 0 0 1 12 22 10 10 0 0 1 4.929 4.929',
    ), // key: 1ohfya
    IconPathElement(
      'M15.892 10.234A14.5 14.5 0 0 0 12 2a10 10 0 0 0-3.643.687',
    ), // key: 1fyh9w
    IconPathElement('M17.656 12H22'), // key: 1ttse4
    IconPathElement(
      'M19.071 19.071A10 10 0 0 1 12 22 14.5 14.5 0 0 1 8.44 8.45',
    ), // key: rmtjzo
    IconPathElement('M2 12h10'), // key: 19562f
    IconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `globe-x.mjs`
  static const LucideGlyph globeX = LucideGlyph('globe-x', <IconElement>[
    IconPathElement('m16 3 5 5'), // key: 1husv6
    IconPathElement(
      'M2 12h20A10 10 0 1 1 12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 4-10',
    ), // key: 46evmv
    IconPathElement('m21 3-5 5'), // key: 1g5oa7
  ]);

  /// `globe.mjs`
  static const LucideGlyph globe = LucideGlyph('globe', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement(
      'M12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 0-20',
    ), // key: 13o1zl
    IconPathElement('M2 12h20'), // key: 9i4pu4
  ]);

  /// `goal.mjs`
  static const LucideGlyph goal = LucideGlyph('goal', <IconElement>[
    IconPathElement('M12 13V2l8 4-8 4'), // key: 5wlwwj
    IconPathElement('M20.561 10.222a9 9 0 1 1-12.55-5.29'), // key: 1c0wjv
    IconPathElement('M8.002 9.997a5 5 0 1 0 8.9 2.02'), // key: gb1g7m
  ]);

  /// `gpu.mjs`
  static const LucideGlyph gpu = LucideGlyph('gpu', <IconElement>[
    IconPathElement('M2 17h18a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2H2'), // key: hpo31w
    IconPathElement('M2 21V3'), // key: 1bzk4w
    IconPathElement('M7 17v3a1 1 0 0 0 1 1h5a1 1 0 0 0 1-1v-3'), // key: 5hbqbf
    IconCircleElement(16, 11, 2), // key: qt15rb
    IconCircleElement(8, 11, 2), // key: ssideg
  ]);

  /// `graduation-cap.mjs`
  static const LucideGlyph
  graduationCap = LucideGlyph('graduation-cap', <IconElement>[
    IconPathElement(
      'M21.42 10.922a1 1 0 0 0-.019-1.838L12.83 5.18a2 2 0 0 0-1.66 0L2.6 9.08a1 1 0 0 0 0 1.832l8.57 3.908a2 2 0 0 0 1.66 0z',
    ), // key: j76jl0
    IconPathElement('M22 10v6'), // key: 1lu8f3
    IconPathElement('M6 12.5V16a6 3 0 0 0 12 0v-3.5'), // key: 1r8lef
  ]);

  /// `grape.mjs`
  static const LucideGlyph grape = LucideGlyph('grape', <IconElement>[
    IconPathElement('M22 5V2l-5.89 5.89'), // key: 1eenpo
    IconCircleElement(16.6, 15.89, 3), // key: xjtalx
    IconCircleElement(8.11, 7.4, 3), // key: u2fv6i
    IconCircleElement(12.35, 11.65, 3), // key: i6i8g7
    IconCircleElement(13.91, 5.85, 3), // key: 6ye0dv
    IconCircleElement(18.15, 10.09, 3), // key: snx9no
    IconCircleElement(6.56, 13.2, 3), // key: 17x4xg
    IconCircleElement(10.8, 17.44, 3), // key: 1hogw9
    IconCircleElement(5, 19, 3), // key: 1sn6vo
  ]);

  /// `grid-2x2-check.mjs`
  static const LucideGlyph
  grid2x2Check = LucideGlyph('grid-2x2-check', <IconElement>[
    IconPathElement(
      'M12 3v17a1 1 0 0 1-1 1H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v6a1 1 0 0 1-1 1H3',
    ), // key: 11za1p
    IconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
  ]);

  /// `grid-2x2-plus.mjs`
  static const LucideGlyph
  grid2x2Plus = LucideGlyph('grid-2x2-plus', <IconElement>[
    IconPathElement(
      'M12 3v17a1 1 0 0 1-1 1H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v6a1 1 0 0 1-1 1H3',
    ), // key: 11za1p
    IconPathElement('M16 19h6'), // key: xwg31i
    IconPathElement('M19 22v-6'), // key: qhmiwi
  ]);

  /// `grid-2x2-x.mjs`
  static const LucideGlyph grid2x2X = LucideGlyph('grid-2x2-x', <IconElement>[
    IconPathElement(
      'M12 3v17a1 1 0 0 1-1 1H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v6a1 1 0 0 1-1 1H3',
    ), // key: 11za1p
    IconPathElement('m16 16 5 5'), // key: 8tpb07
    IconPathElement('m16 21 5-5'), // key: 193jll
  ]);

  /// `grid-2x2.mjs`
  static const LucideGlyph grid2x2 = LucideGlyph('grid-2x2', <IconElement>[
    IconPathElement('M12 3v18'), // key: 108xh3
    IconPathElement('M3 12h18'), // key: 1i2n21
    IconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `grid-3x2.mjs`
  static const LucideGlyph grid3x2 = LucideGlyph('grid-3x2', <IconElement>[
    IconPathElement('M15 3v18'), // key: 14nvp0
    IconPathElement('M3 12h18'), // key: 1i2n21
    IconPathElement('M9 3v18'), // key: fh3hqa
    IconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `grid-3x3.mjs`
  static const LucideGlyph grid3x3 = LucideGlyph('grid-3x3', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    IconPathElement('M3 9h18'), // key: 1pudct
    IconPathElement('M3 15h18'), // key: 5xshup
    IconPathElement('M9 3v18'), // key: fh3hqa
    IconPathElement('M15 3v18'), // key: 14nvp0
  ]);

  /// `grip-horizontal.mjs`
  static const LucideGlyph gripHorizontal = LucideGlyph(
    'grip-horizontal',
    <IconElement>[
      IconCircleElement(12, 9, 1), // key: 124mty
      IconCircleElement(19, 9, 1), // key: 1ruzo2
      IconCircleElement(5, 9, 1), // key: 1a8b28
      IconCircleElement(12, 15, 1), // key: 1e56xg
      IconCircleElement(19, 15, 1), // key: 1a92ep
      IconCircleElement(5, 15, 1), // key: 5r1jwy
    ],
  );

  /// `grip-vertical.mjs`
  static const LucideGlyph gripVertical = LucideGlyph(
    'grip-vertical',
    <IconElement>[
      IconCircleElement(9, 12, 1), // key: 1vctgf
      IconCircleElement(9, 5, 1), // key: hp0tcf
      IconCircleElement(9, 19, 1), // key: fkjjf6
      IconCircleElement(15, 12, 1), // key: 1tmaij
      IconCircleElement(15, 5, 1), // key: 19l28e
      IconCircleElement(15, 19, 1), // key: f4zoj3
    ],
  );

  /// `grip.mjs`
  static const LucideGlyph grip = LucideGlyph('grip', <IconElement>[
    IconCircleElement(12, 5, 1), // key: gxeob9
    IconCircleElement(19, 5, 1), // key: w8mnmm
    IconCircleElement(5, 5, 1), // key: lttvr7
    IconCircleElement(12, 12, 1), // key: 41hilf
    IconCircleElement(19, 12, 1), // key: 1wjl8i
    IconCircleElement(5, 12, 1), // key: 1pcz8c
    IconCircleElement(12, 19, 1), // key: lyex9k
    IconCircleElement(19, 19, 1), // key: shf9b7
    IconCircleElement(5, 19, 1), // key: bfqh0e
  ]);

  /// `group.mjs`
  static const LucideGlyph group = LucideGlyph('group', <IconElement>[
    IconPathElement('M3 7V5c0-1.1.9-2 2-2h2'), // key: adw53z
    IconPathElement('M17 3h2c1.1 0 2 .9 2 2v2'), // key: an4l38
    IconPathElement('M21 17v2c0 1.1-.9 2-2 2h-2'), // key: 144t0e
    IconPathElement('M7 21H5c-1.1 0-2-.9-2-2v-2'), // key: rtnfgi
    IconRectElement(7, 7, 7, 5, 1), // key: 1eyiv7
    IconRectElement(10, 12, 7, 5, 1), // key: 1qlmkx
  ]);

  /// `guitar.mjs`
  static const LucideGlyph guitar = LucideGlyph('guitar', <IconElement>[
    IconPathElement('m11.9 12.1 4.514-4.514'), // key: 109xqo
    IconPathElement(
      'M20.1 2.3a1 1 0 0 0-1.4 0l-1.114 1.114A2 2 0 0 0 17 4.828v1.344a2 2 0 0 1-.586 1.414A2 2 0 0 1 17.828 7h1.344a2 2 0 0 0 1.414-.586L21.7 5.3a1 1 0 0 0 0-1.4z',
    ), // key: txyc8t
    IconPathElement('m6 16 2 2'), // key: 16qmzd
    IconPathElement(
      'M8.23 9.85A3 3 0 0 1 11 8a5 5 0 0 1 5 5 3 3 0 0 1-1.85 2.77l-.92.38A2 2 0 0 0 12 18a4 4 0 0 1-4 4 6 6 0 0 1-6-6 4 4 0 0 1 4-4 2 2 0 0 0 1.85-1.23z',
    ), // key: 1de1vg
  ]);

  /// `ham.mjs`
  static const LucideGlyph ham = LucideGlyph('ham', <IconElement>[
    IconPathElement(
      'M13.144 21.144A7.274 10.445 45 1 0 2.856 10.856',
    ), // key: 1k1t7q
    IconPathElement(
      'M13.144 21.144A7.274 4.365 45 0 0 2.856 10.856a7.274 4.365 45 0 0 10.288 10.288',
    ), // key: 153t1g
    IconPathElement(
      'M16.565 10.435 18.6 8.4a2.501 2.501 0 1 0 1.65-4.65 2.5 2.5 0 1 0-4.66 1.66l-2.024 2.025',
    ), // key: gzrt0n
    IconPathElement('m8.5 16.5-1-1'), // key: otr954
  ]);

  /// `hamburger.mjs`
  static const LucideGlyph hamburger = LucideGlyph('hamburger', <IconElement>[
    IconPathElement(
      'M12 16H4a2 2 0 1 1 0-4h16a2 2 0 1 1 0 4h-4.25',
    ), // key: 5dloqd
    IconPathElement(
      'M5 12a2 2 0 0 1-2-2 9 7 0 0 1 18 0 2 2 0 0 1-2 2',
    ), // key: 1vl3my
    IconPathElement(
      'M5 16a2 2 0 0 0-2 2 3 3 0 0 0 3 3h12a3 3 0 0 0 3-3 2 2 0 0 0-2-2q0 0 0 0',
    ), // key: 1us75o
    IconPathElement(
      'm6.67 12 6.13 4.6a2 2 0 0 0 2.8-.4l3.15-4.2',
    ), // key: qqzweh
  ]);

  /// `hammer.mjs`
  static const LucideGlyph hammer = LucideGlyph('hammer', <IconElement>[
    IconPathElement('m15 12-9.373 9.373a1 1 0 0 1-3.001-3L12 9'), // key: 1hayfq
    IconPathElement('m18 15 4-4'), // key: 16gjal
    IconPathElement(
      'm21.5 11.5-1.914-1.914A2 2 0 0 1 19 8.172v-.344a2 2 0 0 0-.586-1.414l-1.657-1.657A6 6 0 0 0 12.516 3H9l1.243 1.243A6 6 0 0 1 12 8.485V10l2 2h1.172a2 2 0 0 1 1.414.586L18.5 14.5',
    ), // key: 15ts47
  ]);

  /// `hand-coins.mjs`
  static const LucideGlyph handCoins = LucideGlyph('hand-coins', <IconElement>[
    IconPathElement(
      'M11 15h2a2 2 0 1 0 0-4h-3c-.6 0-1.1.2-1.4.6L3 17',
    ), // key: geh8rc
    IconPathElement(
      'm7 21 1.6-1.4c.3-.4.8-.6 1.4-.6h4c1.1 0 2.1-.4 2.8-1.2l4.6-4.4a2 2 0 0 0-2.75-2.91l-4.2 3.9',
    ), // key: 1fto5m
    IconPathElement('m2 16 6 6'), // key: 1pfhp9
    IconCircleElement(16, 9, 2.9), // key: 1n0dlu
    IconCircleElement(6, 5, 3), // key: 151irh
  ]);

  /// `hand-fist.mjs`
  static const LucideGlyph handFist = LucideGlyph('hand-fist', <IconElement>[
    IconPathElement(
      'M12.035 17.012a3 3 0 0 0-3-3l-.311-.002a.72.72 0 0 1-.505-1.229l1.195-1.195A2 2 0 0 1 10.828 11H12a2 2 0 0 0 0-4H9.243a3 3 0 0 0-2.122.879l-2.707 2.707A4.83 4.83 0 0 0 3 14a8 8 0 0 0 8 8h2a8 8 0 0 0 8-8V7a2 2 0 1 0-4 0v2a2 2 0 1 0 4 0',
    ), // key: 1ff7rl
    IconPathElement(
      'M13.888 9.662A2 2 0 0 0 17 8V5A2 2 0 1 0 13 5',
    ), // key: 1xmd21
    IconPathElement('M9 5A2 2 0 1 0 5 5V10'), // key: f3wfjw
    IconPathElement('M9 7V4A2 2 0 1 1 13 4V7.268'), // key: eaoucv
  ]);

  /// `hand-grab.mjs`
  static const LucideGlyph handGrab = LucideGlyph('hand-grab', <IconElement>[
    IconPathElement(
      'M18 11.5V9a2 2 0 0 0-2-2a2 2 0 0 0-2 2v1.4',
    ), // key: edstyy
    IconPathElement('M14 10V8a2 2 0 0 0-2-2a2 2 0 0 0-2 2v2'), // key: 19wdwo
    IconPathElement('M10 9.9V9a2 2 0 0 0-2-2a2 2 0 0 0-2 2v5'), // key: 1lugqo
    IconPathElement('M6 14a2 2 0 0 0-2-2a2 2 0 0 0-2 2'), // key: 1hbeus
    IconPathElement(
      'M18 11a2 2 0 1 1 4 0v3a8 8 0 0 1-8 8h-4a8 8 0 0 1-8-8 2 2 0 1 1 4 0',
    ), // key: 1etffm
  ]);

  /// `hand-heart.mjs`
  static const LucideGlyph handHeart = LucideGlyph('hand-heart', <IconElement>[
    IconPathElement(
      'M11 14h2a2 2 0 0 0 0-4h-3c-.6 0-1.1.2-1.4.6L3 16',
    ), // key: 1v1a37
    IconPathElement(
      'm14.45 13.39 5.05-4.694C20.196 8 21 6.85 21 5.75a2.75 2.75 0 0 0-4.797-1.837.276.276 0 0 1-.406 0A2.75 2.75 0 0 0 11 5.75c0 1.2.802 2.248 1.5 2.946L16 11.95',
    ), // key: fhfbnt
    IconPathElement('m2 15 6 6'), // key: 10dquu
    IconPathElement(
      'm7 20 1.6-1.4c.3-.4.8-.6 1.4-.6h4c1.1 0 2.1-.4 2.8-1.2l4.6-4.4a1 1 0 0 0-2.75-2.91',
    ), // key: 1x6kdw
  ]);

  /// `hand-helping.mjs`
  static const LucideGlyph
  handHelping = LucideGlyph('hand-helping', <IconElement>[
    IconPathElement(
      'M11 12h2a2 2 0 1 0 0-4h-3c-.6 0-1.1.2-1.4.6L3 14',
    ), // key: 1j4xps
    IconPathElement(
      'm7 18 1.6-1.4c.3-.4.8-.6 1.4-.6h4c1.1 0 2.1-.4 2.8-1.2l4.6-4.4a2 2 0 0 0-2.75-2.91l-4.2 3.9',
    ), // key: uospg8
    IconPathElement('m2 13 6 6'), // key: 16e5sb
  ]);

  /// `hand-metal.mjs`
  static const LucideGlyph handMetal = LucideGlyph('hand-metal', <IconElement>[
    IconPathElement(
      'M18 12.5V10a2 2 0 0 0-2-2a2 2 0 0 0-2 2v1.4',
    ), // key: wc6myp
    IconPathElement('M14 11V9a2 2 0 1 0-4 0v2'), // key: 94qvcw
    IconPathElement('M10 10.5V5a2 2 0 1 0-4 0v9'), // key: m1ah89
    IconPathElement(
      'm7 15-1.76-1.76a2 2 0 0 0-2.83 2.82l3.6 3.6C7.5 21.14 9.2 22 12 22h2a8 8 0 0 0 8-8V7a2 2 0 1 0-4 0v5',
    ), // key: t1skq1
  ]);

  /// `hand-platter.mjs`
  static const LucideGlyph
  handPlatter = LucideGlyph('hand-platter', <IconElement>[
    IconPathElement('M12 3V2'), // key: ar7q03
    IconPathElement(
      'm15.4 17.4 3.2-2.8a2 2 0 1 1 2.8 2.9l-3.6 3.3c-.7.8-1.7 1.2-2.8 1.2h-4c-1.1 0-2.1-.4-2.8-1.2l-1.302-1.464A1 1 0 0 0 6.151 19H5',
    ), // key: n2g93r
    IconPathElement('M2 14h12a2 2 0 0 1 0 4h-2'), // key: 1o2jem
    IconPathElement('M4 10h16'), // key: img6z1
    IconPathElement('M5 10a7 7 0 0 1 14 0'), // key: 1ega1o
    IconPathElement('M5 14v6a1 1 0 0 1-1 1H2'), // key: 1hescx
  ]);

  /// `hand.mjs`
  static const LucideGlyph hand = LucideGlyph('hand', <IconElement>[
    IconPathElement('M18 11V6a2 2 0 0 0-2-2a2 2 0 0 0-2 2'), // key: 1fvzgz
    IconPathElement('M14 10V4a2 2 0 0 0-2-2a2 2 0 0 0-2 2v2'), // key: 1kc0my
    IconPathElement('M10 10.5V6a2 2 0 0 0-2-2a2 2 0 0 0-2 2v8'), // key: 10h0bg
    IconPathElement(
      'M18 8a2 2 0 1 1 4 0v6a8 8 0 0 1-8 8h-2c-2.8 0-4.5-.86-5.99-2.34l-3.6-3.6a2 2 0 0 1 2.83-2.82L7 15',
    ), // key: 1s1gnw
  ]);

  /// `handbag.mjs`
  static const LucideGlyph handbag = LucideGlyph('handbag', <IconElement>[
    IconPathElement(
      'M2.048 18.566A2 2 0 0 0 4 21h16a2 2 0 0 0 1.952-2.434l-2-9A2 2 0 0 0 18 8H6a2 2 0 0 0-1.952 1.566z',
    ), // key: 1qbui5
    IconPathElement('M8 11V6a4 4 0 0 1 8 0v5'), // key: tcht90
  ]);

  /// `handshake.mjs`
  static const LucideGlyph handshake = LucideGlyph('handshake', <IconElement>[
    IconPathElement('m11 17 2 2a1 1 0 1 0 3-3'), // key: efffak
    IconPathElement(
      'm14 14 2.5 2.5a1 1 0 1 0 3-3l-3.88-3.88a3 3 0 0 0-4.24 0l-.88.88a1 1 0 1 1-3-3l2.81-2.81a5.79 5.79 0 0 1 7.06-.87l.47.28a2 2 0 0 0 1.42.25L21 4',
    ), // key: 9pr0kb
    IconPathElement('m21 3 1 11h-2'), // key: 1tisrp
    IconPathElement('M3 3 2 14l6.5 6.5a1 1 0 1 0 3-3'), // key: 1uvwmv
    IconPathElement('M3 4h8'), // key: 1ep09j
  ]);

  /// `hard-drive-download.mjs`
  static const LucideGlyph hardDriveDownload = LucideGlyph(
    'hard-drive-download',
    <IconElement>[
      IconPathElement('M12 2v8'), // key: 1q4o3n
      IconPathElement('m16 6-4 4-4-4'), // key: 6wukr
      IconRectElement(2, 14, 20, 8, 2), // key: w68u3i
      IconPathElement('M6 18h.01'), // key: uhywen
      IconPathElement('M10 18h.01'), // key: h775k
    ],
  );

  /// `hard-drive-upload.mjs`
  static const LucideGlyph hardDriveUpload = LucideGlyph(
    'hard-drive-upload',
    <IconElement>[
      IconPathElement('m16 6-4-4-4 4'), // key: 13yo43
      IconPathElement('M12 2v8'), // key: 1q4o3n
      IconRectElement(2, 14, 20, 8, 2), // key: w68u3i
      IconPathElement('M6 18h.01'), // key: uhywen
      IconPathElement('M10 18h.01'), // key: h775k
    ],
  );

  /// `hard-drive.mjs`
  static const LucideGlyph hardDrive = LucideGlyph('hard-drive', <IconElement>[
    IconPathElement('M10 16h.01'), // key: 1bzywj
    IconPathElement(
      'M2.212 11.577a2 2 0 0 0-.212.896V18a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-5.527a2 2 0 0 0-.212-.896L18.55 5.11A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z',
    ), // key: 18tbho
    IconPathElement('M21.946 12.013H2.054'), // key: zqlbp7
    IconPathElement('M6 16h.01'), // key: 1pmjb7
  ]);

  /// `hard-hat.mjs`
  static const LucideGlyph hardHat = LucideGlyph('hard-hat', <IconElement>[
    IconPathElement('M10 10V5a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v5'), // key: 1p9q5i
    IconPathElement('M14 6a6 6 0 0 1 6 6v3'), // key: 1hnv84
    IconPathElement('M4 15v-3a6 6 0 0 1 6-6'), // key: 9ciidu
    IconRectElement(2, 15, 20, 4, 1), // key: g3x8cw
  ]);

  /// `hash.mjs`
  static const LucideGlyph hash = LucideGlyph('hash', <IconElement>[
    IconLineElement(4, 9, 20, 9), // key: 4lhtct
    IconLineElement(4, 15, 20, 15), // key: vyu0kd
    IconLineElement(10, 3, 8, 21), // key: 1ggp8o
    IconLineElement(16, 3, 14, 21), // key: weycgp
  ]);

  /// `hat-glasses.mjs`
  static const LucideGlyph
  hatGlasses = LucideGlyph('hat-glasses', <IconElement>[
    IconPathElement('M14 18a2 2 0 0 0-4 0'), // key: 1v8fkw
    IconPathElement(
      'm19 11-2.11-6.657a2 2 0 0 0-2.752-1.148l-1.276.61A2 2 0 0 1 12 4H8.5a2 2 0 0 0-1.925 1.456L5 11',
    ), // key: 1fkr7p
    IconPathElement('M2 11h20'), // key: 3eubbj
    IconCircleElement(17, 18, 3), // key: 82mm0e
    IconCircleElement(7, 18, 3), // key: lvkj7j
  ]);

  /// `haze.mjs`
  static const LucideGlyph haze = LucideGlyph('haze', <IconElement>[
    IconPathElement('m5.2 6.2 1.4 1.4'), // key: 17imol
    IconPathElement('M2 13h2'), // key: 13gyu8
    IconPathElement('M20 13h2'), // key: 16rner
    IconPathElement('m17.4 7.6 1.4-1.4'), // key: t4xlah
    IconPathElement('M22 17H2'), // key: 1gtaj3
    IconPathElement('M22 21H2'), // key: 1gy6en
    IconPathElement('M16 13a4 4 0 0 0-8 0'), // key: 1dyczq
    IconPathElement('M12 5V2.5'), // key: 1vytko
  ]);

  /// `hd.mjs`
  static const LucideGlyph hd = LucideGlyph('hd', <IconElement>[
    IconPathElement('M10 12H6'), // key: 15f2ro
    IconPathElement('M10 15V9'), // key: 1lckn7
    IconPathElement(
      'M14 14.5a.5.5 0 0 0 .5.5h1a2.5 2.5 0 0 0 2.5-2.5v-1A2.5 2.5 0 0 0 15.5 9h-1a.5.5 0 0 0-.5.5z',
    ), // key: b3f847
    IconPathElement('M6 15V9'), // key: 12stmj
    IconRectElement(2, 5, 20, 14, 2), // key: qneu4z
  ]);

  /// `hdmi-port.mjs`
  static const LucideGlyph hdmiPort = LucideGlyph('hdmi-port', <IconElement>[
    IconPathElement(
      'M22 9a1 1 0 00-1-1H3a1 1 0 00-1 1v4a1 1 0 001 1h.5a2 2 0 011.6.8l.3.4A2 2 0 007 16h10a2 2 0 001.6-.8l.3-.4a2 2 0 011.6-.8h.5a1 1 0 001-1z',
    ), // key: 1kwg9h
    IconPathElement('M8 12h8'), // key: 1wcyev
  ]);

  /// `heading-1.mjs`
  static const LucideGlyph heading1 = LucideGlyph('heading-1', <IconElement>[
    IconPathElement('M4 12h8'), // key: 17cfdx
    IconPathElement('M4 18V6'), // key: 1rz3zl
    IconPathElement('M12 18V6'), // key: zqpxq5
    IconPathElement('m17 12 3-2v8'), // key: 1hhhft
  ]);

  /// `heading-2.mjs`
  static const LucideGlyph heading2 = LucideGlyph('heading-2', <IconElement>[
    IconPathElement('M4 12h8'), // key: 17cfdx
    IconPathElement('M4 18V6'), // key: 1rz3zl
    IconPathElement('M12 18V6'), // key: zqpxq5
    IconPathElement('M21 18h-4c0-4 4-3 4-6 0-1.5-2-2.5-4-1'), // key: 9jr5yi
  ]);

  /// `heading-3.mjs`
  static const LucideGlyph heading3 = LucideGlyph('heading-3', <IconElement>[
    IconPathElement('M4 12h8'), // key: 17cfdx
    IconPathElement('M4 18V6'), // key: 1rz3zl
    IconPathElement('M12 18V6'), // key: zqpxq5
    IconPathElement(
      'M17.5 10.5c1.7-1 3.5 0 3.5 1.5a2 2 0 0 1-2 2',
    ), // key: 68ncm8
    IconPathElement('M17 17.5c2 1.5 4 .3 4-1.5a2 2 0 0 0-2-2'), // key: 1ejuhz
  ]);

  /// `heading-4.mjs`
  static const LucideGlyph heading4 = LucideGlyph('heading-4', <IconElement>[
    IconPathElement('M12 18V6'), // key: zqpxq5
    IconPathElement('M17 10v3a1 1 0 0 0 1 1h3'), // key: tj5zdr
    IconPathElement('M21 10v8'), // key: 1kdml4
    IconPathElement('M4 12h8'), // key: 17cfdx
    IconPathElement('M4 18V6'), // key: 1rz3zl
  ]);

  /// `heading-5.mjs`
  static const LucideGlyph heading5 = LucideGlyph('heading-5', <IconElement>[
    IconPathElement('M4 12h8'), // key: 17cfdx
    IconPathElement('M4 18V6'), // key: 1rz3zl
    IconPathElement('M12 18V6'), // key: zqpxq5
    IconPathElement('M17 13v-3h4'), // key: 1nvgqp
    IconPathElement(
      'M17 17.7c.4.2.8.3 1.3.3 1.5 0 2.7-1.1 2.7-2.5S19.8 13 18.3 13H17',
    ), // key: 2nebdn
  ]);

  /// `heading-6.mjs`
  static const LucideGlyph heading6 = LucideGlyph('heading-6', <IconElement>[
    IconPathElement('M4 12h8'), // key: 17cfdx
    IconPathElement('M4 18V6'), // key: 1rz3zl
    IconPathElement('M12 18V6'), // key: zqpxq5
    IconCircleElement(19, 16, 2), // key: 15mx69
    IconPathElement('M20 10c-2 2-3 3.5-3 6'), // key: f35dl0
  ]);

  /// `heading.mjs`
  static const LucideGlyph heading = LucideGlyph('heading', <IconElement>[
    IconPathElement('M6 12h12'), // key: 8npq4p
    IconPathElement('M6 20V4'), // key: 1w1bmo
    IconPathElement('M18 20V4'), // key: o2hl4u
  ]);

  /// `headphone-off.mjs`
  static const LucideGlyph
  headphoneOff = LucideGlyph('headphone-off', <IconElement>[
    IconPathElement('M21 14h-1.343'), // key: 1jdnxi
    IconPathElement('M9.128 3.47A9 9 0 0 1 21 12v3.343'), // key: 6kipu2
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement(
      'M20.414 20.414A2 2 0 0 1 19 21h-1a2 2 0 0 1-2-2v-3',
    ), // key: 9x50f4
    IconPathElement(
      'M3 14h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-7a9 9 0 0 1 2.636-6.364',
    ), // key: 1bkxnm
  ]);

  /// `headphones.mjs`
  static const LucideGlyph headphones = LucideGlyph('headphones', <IconElement>[
    IconPathElement(
      'M3 14h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-7a9 9 0 0 1 18 0v7a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3',
    ), // key: 1xhozi
  ]);

  /// `headset.mjs`
  static const LucideGlyph headset = LucideGlyph('headset', <IconElement>[
    IconPathElement(
      'M3 11h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-5Zm0 0a9 9 0 1 1 18 0m0 0v5a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3Z',
    ), // key: 12oyoe
    IconPathElement('M21 16v2a4 4 0 0 1-4 4h-5'), // key: 1x7m43
  ]);

  /// `heart-crack.mjs`
  static const LucideGlyph
  heartCrack = LucideGlyph('heart-crack', <IconElement>[
    IconPathElement(
      'M12.409 5.824c-.702.792-1.15 1.496-1.415 2.166l2.153 2.156a.5.5 0 0 1 0 .707l-2.293 2.293a.5.5 0 0 0 0 .707L12 15',
    ), // key: idzbju
    IconPathElement(
      'M13.508 20.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5a5.5 5.5 0 0 1 9.591-3.677.6.6 0 0 0 .818.001A5.5 5.5 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5z',
    ), // key: 1su70f
  ]);

  /// `heart-handshake.mjs`
  static const LucideGlyph
  heartHandshake = LucideGlyph('heart-handshake', <IconElement>[
    IconPathElement(
      'M19.414 14.414C21 12.828 22 11.5 22 9.5a5.5 5.5 0 0 0-9.591-3.676.6.6 0 0 1-.818.001A5.5 5.5 0 0 0 2 9.5c0 2.3 1.5 4 3 5.5l5.535 5.362a2 2 0 0 0 2.879.052 2.12 2.12 0 0 0-.004-3 2.124 2.124 0 1 0 3-3 2.124 2.124 0 0 0 3.004 0 2 2 0 0 0 0-2.828l-1.881-1.882a2.41 2.41 0 0 0-3.409 0l-1.71 1.71a2 2 0 0 1-2.828 0 2 2 0 0 1 0-2.828l2.823-2.762',
    ), // key: 17lmqv
  ]);

  /// `heart-minus.mjs`
  static const LucideGlyph
  heartMinus = LucideGlyph('heart-minus', <IconElement>[
    IconPathElement(
      'm14.876 18.99-1.368 1.323a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5a5.2 5.2 0 0 1-.244 1.572',
    ), // key: 15yztm
    IconPathElement('M15 15h6'), // key: 1u4692
  ]);

  /// `heart-off.mjs`
  static const LucideGlyph heartOff = LucideGlyph('heart-off', <IconElement>[
    IconPathElement(
      'M10.5 4.893a5.5 5.5 0 0 1 1.091.931.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 1.872-1.002 3.356-2.187 4.655',
    ), // key: 1inpfl
    IconPathElement(
      'm16.967 16.967-3.459 3.346a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5a5.5 5.5 0 0 1 2.747-4.761',
    ), // key: vbc6x7
    IconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `heart-plus.mjs`
  static const LucideGlyph heartPlus = LucideGlyph('heart-plus', <IconElement>[
    IconPathElement(
      'm14.479 19.374-.971.939a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5a5.2 5.2 0 0 1-.219 1.49',
    ), // key: wg5jx
    IconPathElement('M15 15h6'), // key: 1u4692
    IconPathElement('M18 12v6'), // key: 1houu1
  ]);

  /// `heart-pulse.mjs`
  static const LucideGlyph
  heartPulse = LucideGlyph('heart-pulse', <IconElement>[
    IconPathElement(
      'M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5',
    ), // key: mvr1a0
    IconPathElement('M3.22 13H9.5l.5-1 2 4.5 2-7 1.5 3.5h5.27'), // key: auskq0
  ]);

  /// `heart-x.mjs`
  static const LucideGlyph heartX = LucideGlyph('heart-x', <IconElement>[
    IconPathElement('m15.5 12.5 5 5'), // key: 15wbfr
    IconPathElement('m20.5 12.5-5 5'), // key: o012pn
    IconPathElement(
      'M21.955 8.774a5.5 5.5 0 0 0-9.546-2.95.6.6 0 0 1-.818 0A5.5 5.5 0 0 0 2 9.5c0 2.3 1.5 4 3 5.5l5.508 5.332a2 2 0 0 0 2.57.352',
    ), // key: c1obtn
  ]);

  /// `heart.mjs`
  static const LucideGlyph heart = LucideGlyph('heart', <IconElement>[
    IconPathElement(
      'M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5',
    ), // key: mvr1a0
  ]);

  /// `heater.mjs`
  static const LucideGlyph heater = LucideGlyph('heater', <IconElement>[
    IconPathElement('M11 8c2-3-2-3 0-6'), // key: 1ldv5m
    IconPathElement('M15.5 8c2-3-2-3 0-6'), // key: 1otqoz
    IconPathElement('M6 10h.01'), // key: 1lbq93
    IconPathElement('M6 14h.01'), // key: zudwn7
    IconPathElement('M10 16v-4'), // key: 1c25yv
    IconPathElement('M14 16v-4'), // key: 1dkbt8
    IconPathElement('M18 16v-4'), // key: 1yg9me
    IconPathElement(
      'M20 6a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h3',
    ), // key: 1ubg90
    IconPathElement('M5 20v2'), // key: 1abpe8
    IconPathElement('M19 20v2'), // key: kqn6ft
  ]);

  /// `helicopter.mjs`
  static const LucideGlyph helicopter = LucideGlyph('helicopter', <IconElement>[
    IconPathElement('M11 17v4'), // key: 14wq8k
    IconPathElement('M14 3v8a2 2 0 0 0 2 2h5.865'), // key: 12oo5h
    IconPathElement('M17 17v4'), // key: hdt4hh
    IconPathElement(
      'M18 17a4 4 0 0 0 4-4 8 6 0 0 0-8-6 6 5 0 0 0-6 5v3a2 2 0 0 0 2 2z',
    ), // key: yynif
    IconPathElement('M2 10v5'), // key: sa5akn
    IconPathElement('M6 3h16'), // key: 27qw71
    IconPathElement('M7 21h14'), // key: 1ugz0u
    IconPathElement('M8 13H2'), // key: 1thz1o
  ]);

  /// `hexagon.mjs`
  static const LucideGlyph hexagon = LucideGlyph('hexagon', <IconElement>[
    IconPathElement(
      'M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z',
    ), // key: yt0hxn
  ]);

  /// `highlighter.mjs`
  static const LucideGlyph highlighter = LucideGlyph(
    'highlighter',
    <IconElement>[
      IconPathElement('m9 11-6 6v3h9l3-3'), // key: 1a3l36
      IconPathElement(
        'm22 12-4.6 4.6a2 2 0 0 1-2.8 0l-5.2-5.2a2 2 0 0 1 0-2.8L14 4',
      ), // key: 14a9rk
    ],
  );

  /// `hop-off.mjs`
  static const LucideGlyph hopOff = LucideGlyph('hop-off', <IconElement>[
    IconPathElement(
      'M10.82 16.12c1.69.6 3.91.79 5.18.85.28.01.53-.09.7-.27',
    ), // key: qyzcap
    IconPathElement(
      'M11.14 20.57c.52.24 2.44 1.12 4.08 1.37.46.06.86-.25.9-.71.12-1.52-.3-3.43-.5-4.28',
    ), // key: y078lb
    IconPathElement(
      'M16.13 21.05c1.65.63 3.68.84 4.87.91a.9.9 0 0 0 .7-.26',
    ), // key: 1utre3
    IconPathElement(
      'M17.99 5.52a20.83 20.83 0 0 1 3.15 4.5.8.8 0 0 1-.68 1.13c-1.17.1-2.5.02-3.9-.25',
    ), // key: 17o9hm
    IconPathElement(
      'M20.57 11.14c.24.52 1.12 2.44 1.37 4.08.04.3-.08.59-.31.75',
    ), // key: 1d1n4p
    IconPathElement(
      'M4.93 4.93a10 10 0 0 0-.67 13.4c.35.43.96.4 1.17-.12.69-1.71 1.07-5.07 1.07-6.71 1.34.45 3.1.9 4.88.62a.85.85 0 0 0 .48-.24',
    ), // key: 9uv3tt
    IconPathElement(
      'M5.52 17.99c1.05.95 2.91 2.42 4.5 3.15a.8.8 0 0 0 1.13-.68c.2-2.34-.33-5.3-1.57-8.28',
    ), // key: 1292wz
    IconPathElement(
      'M8.35 2.68a10 10 0 0 1 9.98 1.58c.43.35.4.96-.12 1.17-1.5.6-4.3.98-6.07 1.05',
    ), // key: 7ozu9p
    IconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `hop.mjs`
  static const LucideGlyph hop = LucideGlyph('hop', <IconElement>[
    IconPathElement(
      'M10.82 16.12c1.69.6 3.91.79 5.18.85.55.03 1-.42.97-.97-.06-1.27-.26-3.5-.85-5.18',
    ), // key: 18lxf1
    IconPathElement(
      'M11.5 6.5c1.64 0 5-.38 6.71-1.07.52-.2.55-.82.12-1.17A10 10 0 0 0 4.26 18.33c.35.43.96.4 1.17-.12.69-1.71 1.07-5.07 1.07-6.71 1.34.45 3.1.9 4.88.62a.88.88 0 0 0 .73-.74c.3-2.14-.15-3.5-.61-4.88',
    ), // key: vtfxrw
    IconPathElement(
      'M15.62 16.95c.2.85.62 2.76.5 4.28a.77.77 0 0 1-.9.7 16.64 16.64 0 0 1-4.08-1.36',
    ), // key: 13hl71
    IconPathElement(
      'M16.13 21.05c1.65.63 3.68.84 4.87.91a.9.9 0 0 0 .96-.96 17.68 17.68 0 0 0-.9-4.87',
    ), // key: 1sl8oj
    IconPathElement(
      'M16.94 15.62c.86.2 2.77.62 4.29.5a.77.77 0 0 0 .7-.9 16.64 16.64 0 0 0-1.36-4.08',
    ), // key: 19c6kt
    IconPathElement(
      'M17.99 5.52a20.82 20.82 0 0 1 3.15 4.5.8.8 0 0 1-.68 1.13c-2.33.2-5.3-.32-8.27-1.57',
    ), // key: 85ghs3
    IconPathElement('M4.93 4.93 3 3a.7.7 0 0 1 0-1'), // key: x087yj
    IconPathElement(
      'M9.58 12.18c1.24 2.98 1.77 5.95 1.57 8.28a.8.8 0 0 1-1.13.68 20.82 20.82 0 0 1-4.5-3.15',
    ), // key: 11xdqo
  ]);

  /// `hospital.mjs`
  static const LucideGlyph hospital = LucideGlyph('hospital', <IconElement>[
    IconPathElement('M12 7v4'), // key: xawao1
    IconPathElement('M14 21v-3a2 2 0 0 0-4 0v3'), // key: 1rgiei
    IconPathElement('M14 9h-4'), // key: 1w2s2s
    IconPathElement(
      'M18 11h2a2 2 0 0 1 2 2v6a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-9a2 2 0 0 1 2-2h2',
    ), // key: 1tthqt
    IconPathElement('M18 21V5a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v16'), // key: dw4p4i
  ]);

  /// `hotel.mjs`
  static const LucideGlyph hotel = LucideGlyph('hotel', <IconElement>[
    IconPathElement('M10 22v-6.57'), // key: 1wmca3
    IconPathElement('M12 11h.01'), // key: z322tv
    IconPathElement('M12 7h.01'), // key: 1ivr5q
    IconPathElement('M14 15.43V22'), // key: 1q2vjd
    IconPathElement('M15 16a5 5 0 0 0-6 0'), // key: o9wqvi
    IconPathElement('M16 11h.01'), // key: xkw8gn
    IconPathElement('M16 7h.01'), // key: 1kdx03
    IconPathElement('M8 11h.01'), // key: 1dfujw
    IconPathElement('M8 7h.01'), // key: 1vti4s
    IconRectElement(4, 2, 16, 20, 2), // key: 1uxh74
  ]);

  /// `hourglass.mjs`
  static const LucideGlyph hourglass = LucideGlyph('hourglass', <IconElement>[
    IconPathElement('M5 22h14'), // key: ehvnwv
    IconPathElement('M5 2h14'), // key: pdyrp9
    IconPathElement(
      'M17 22v-4.172a2 2 0 0 0-.586-1.414L12 12l-4.414 4.414A2 2 0 0 0 7 17.828V22',
    ), // key: 1d314k
    IconPathElement(
      'M7 2v4.172a2 2 0 0 0 .586 1.414L12 12l4.414-4.414A2 2 0 0 0 17 6.172V2',
    ), // key: 1vvvr6
  ]);

  /// `house-heart.mjs`
  static const LucideGlyph
  houseHeart = LucideGlyph('house-heart', <IconElement>[
    IconPathElement(
      'M8.62 13.8A2.25 2.25 0 1 1 12 10.836a2.25 2.25 0 1 1 3.38 2.966l-2.626 2.856a.998.998 0 0 1-1.507 0z',
    ), // key: n9s7kx
    IconPathElement(
      'M3 10a2 2 0 0 1 .709-1.528l7-6a2 2 0 0 1 2.582 0l7 6A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z',
    ), // key: r6nss1
  ]);

  /// `house-plug.mjs`
  static const LucideGlyph housePlug = LucideGlyph('house-plug', <IconElement>[
    IconPathElement('M10 12V8.964'), // key: 1vll13
    IconPathElement('M14 12V8.964'), // key: 1x3qvg
    IconPathElement(
      'M15 12a1 1 0 0 1 1 1v2a2 2 0 0 1-2 2h-4a2 2 0 0 1-2-2v-2a1 1 0 0 1 1-1z',
    ), // key: ppykja
    IconPathElement(
      'M8.5 21H5a2 2 0 0 1-2-2v-9a2 2 0 0 1 .709-1.528l7-6a2 2 0 0 1 2.582 0l7 6A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2h-5a2 2 0 0 1-2-2v-2',
    ), // key: 365xoy
  ]);

  /// `house-plus.mjs`
  static const LucideGlyph housePlus = LucideGlyph('house-plus', <IconElement>[
    IconPathElement(
      'M12.35 21H5a2 2 0 0 1-2-2v-9a2 2 0 0 1 .71-1.53l7-6a2 2 0 0 1 2.58 0l7 6A2 2 0 0 1 21 10v2.35',
    ), // key: 8ek5ge
    IconPathElement(
      'M14.8 12.4A1 1 0 0 0 14 12h-4a1 1 0 0 0-1 1v8',
    ), // key: 1rbg29
    IconPathElement('M15 18h6'), // key: 3b3c90
    IconPathElement('M18 15v6'), // key: 9wciyi
  ]);

  /// `house-wifi.mjs`
  static const LucideGlyph houseWifi = LucideGlyph('house-wifi', <IconElement>[
    IconPathElement('M9.5 13.866a4 4 0 0 1 5 .01'), // key: 1wy54i
    IconPathElement('M12 17h.01'), // key: p32p05
    IconPathElement(
      'M3 10a2 2 0 0 1 .709-1.528l7-6a2 2 0 0 1 2.582 0l7 6A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z',
    ), // key: r6nss1
    IconPathElement('M7 10.754a8 8 0 0 1 10 0'), // key: exoy2g
  ]);

  /// `house.mjs`
  static const LucideGlyph house = LucideGlyph('house', <IconElement>[
    IconPathElement(
      'M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8',
    ), // key: 5wwlr5
    IconPathElement(
      'M3 10a2 2 0 0 1 .709-1.528l7-6a2 2 0 0 1 2.582 0l7 6A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z',
    ), // key: r6nss1
  ]);

  /// `ice-cream-bowl.mjs`
  static const LucideGlyph
  iceCreamBowl = LucideGlyph('ice-cream-bowl', <IconElement>[
    IconPathElement(
      'M12 17c5 0 8-2.69 8-6H4c0 3.31 3 6 8 6m-4 4h8m-4-3v3M5.14 11a3.5 3.5 0 1 1 6.71 0',
    ), // key: 1uxfcu
    IconPathElement('M12.14 11a3.5 3.5 0 1 1 6.71 0'), // key: 4k3m1s
    IconPathElement('M15.5 6.5a3.5 3.5 0 1 0-7 0'), // key: zmuahr
  ]);

  /// `ice-cream-cone.mjs`
  static const LucideGlyph iceCreamCone = LucideGlyph(
    'ice-cream-cone',
    <IconElement>[
      IconPathElement('m7 11 4.08 10.35a1 1 0 0 0 1.84 0L17 11'), // key: 1v6356
      IconPathElement('M17 7A5 5 0 0 0 7 7'), // key: 151p3v
      IconPathElement('M17 7a2 2 0 0 1 0 4H7a2 2 0 0 1 0-4'), // key: 1sdaij
    ],
  );

  /// `id-card-lanyard.mjs`
  static const LucideGlyph
  idCardLanyard = LucideGlyph('id-card-lanyard', <IconElement>[
    IconPathElement('M13.5 8h-3'), // key: xvov4w
    IconPathElement(
      'm15 2-1 2h3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h3',
    ), // key: 16uttc
    IconPathElement('M16.899 22A5 5 0 0 0 7.1 22'), // key: 1d0ppr
    IconPathElement('m9 2 3 6'), // key: 1o7bd9
    IconCircleElement(12, 15, 3), // key: g36mzq
  ]);

  /// `id-card.mjs`
  static const LucideGlyph idCard = LucideGlyph('id-card', <IconElement>[
    IconPathElement('M16 10h2'), // key: 8sgtl7
    IconPathElement('M16 14h2'), // key: epxaof
    IconPathElement('M6.17 15a3 3 0 0 1 5.66 0'), // key: n6f512
    IconCircleElement(9, 11, 2), // key: yxgjnd
    IconRectElement(2, 5, 20, 14, 2), // key: qneu4z
  ]);

  /// `image-down.mjs`
  static const LucideGlyph imageDown = LucideGlyph('image-down', <IconElement>[
    IconPathElement(
      'M10.3 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v10l-3.1-3.1a2 2 0 0 0-2.814.014L6 21',
    ), // key: 9csbqa
    IconPathElement('m14 19 3 3v-5.5'), // key: 9ldu5r
    IconPathElement('m17 22 3-3'), // key: 1nkfve
    IconCircleElement(9, 9, 2), // key: af1f0g
  ]);

  /// `image-minus.mjs`
  static const LucideGlyph
  imageMinus = LucideGlyph('image-minus', <IconElement>[
    IconPathElement(
      'M21 9v10a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h7',
    ), // key: m87ecr
    IconLineElement(16, 5, 22, 5), // key: ez7e4s
    IconCircleElement(9, 9, 2), // key: af1f0g
    IconPathElement('m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21'), // key: 1xmnt7
  ]);

  /// `image-off.mjs`
  static const LucideGlyph imageOff = LucideGlyph('image-off', <IconElement>[
    IconLineElement(2, 2, 22, 22), // key: a6p6uj
    IconPathElement('M10.41 10.41a2 2 0 1 1-2.83-2.83'), // key: 1bzlo9
    IconLineElement(13.5, 13.5, 6, 21), // key: 1q0aeu
    IconLineElement(18, 12, 21, 15), // key: 5mozeu
    IconPathElement(
      'M3.59 3.59A1.99 1.99 0 0 0 3 5v14a2 2 0 0 0 2 2h14c.55 0 1.052-.22 1.41-.59',
    ), // key: mmje98
    IconPathElement('M21 15V5a2 2 0 0 0-2-2H9'), // key: 43el77
  ]);

  /// `image-play.mjs`
  static const LucideGlyph imagePlay = LucideGlyph('image-play', <IconElement>[
    IconPathElement(
      'M15 15.003a1 1 0 0 1 1.517-.859l4.997 2.997a1 1 0 0 1 0 1.718l-4.997 2.997a1 1 0 0 1-1.517-.86z',
    ), // key: nrt1m3
    IconPathElement(
      'M21 12.17V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h6',
    ), // key: 99hgts
    IconPathElement('m6 21 5-5'), // key: 1wyjai
    IconCircleElement(9, 9, 2), // key: af1f0g
  ]);

  /// `image-plus.mjs`
  static const LucideGlyph imagePlus = LucideGlyph('image-plus', <IconElement>[
    IconPathElement('M16 5h6'), // key: 1vod17
    IconPathElement('M19 2v6'), // key: 4bpg5p
    IconPathElement(
      'M21 11.5V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h7.5',
    ), // key: 1ue2ih
    IconPathElement('m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21'), // key: 1xmnt7
    IconCircleElement(9, 9, 2), // key: af1f0g
  ]);

  /// `image-up.mjs`
  static const LucideGlyph imageUp = LucideGlyph('image-up', <IconElement>[
    IconPathElement(
      'M10.3 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v10l-3.1-3.1a2 2 0 0 0-2.814.014L6 21',
    ), // key: 9csbqa
    IconPathElement('m14 19.5 3-3 3 3'), // key: 9vmjn0
    IconPathElement('M17 22v-5.5'), // key: 1aa6fl
    IconCircleElement(9, 9, 2), // key: af1f0g
  ]);

  /// `image-upscale.mjs`
  static const LucideGlyph imageUpscale = LucideGlyph(
    'image-upscale',
    <IconElement>[
      IconPathElement('M16 3h5v5'), // key: 1806ms
      IconPathElement('M17 21h2a2 2 0 0 0 2-2'), // key: 130fy9
      IconPathElement('M21 12v3'), // key: 1wzk3p
      IconPathElement('m21 3-5 5'), // key: 1g5oa7
      IconPathElement('M3 7V5a2 2 0 0 1 2-2'), // key: kk3yz1
      IconPathElement(
        'm5 21 4.144-4.144a1.21 1.21 0 0 1 1.712 0L13 19',
      ), // key: fyekpt
      IconPathElement('M9 3h3'), // key: d52fa
      IconRectElement(3, 11, 10, 10, 1), // key: 1wpmix
    ],
  );

  /// `image.mjs`
  static const LucideGlyph image = LucideGlyph('image', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    IconCircleElement(9, 9, 2), // key: af1f0g
    IconPathElement('m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21'), // key: 1xmnt7
  ]);

  /// `images.mjs`
  static const LucideGlyph images = LucideGlyph('images', <IconElement>[
    IconPathElement(
      'm22 11-1.296-1.296a2.4 2.4 0 0 0-3.408 0L11 16',
    ), // key: 9kzy35
    IconPathElement(
      'M4 8a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2',
    ), // key: 1t0f0t
    IconCircleElement(13, 7, 1, filled: true), // key: 1obus6
    IconRectElement(8, 2, 14, 14, 2), // key: 1gvhby
  ]);

  /// `import.mjs`
  static const LucideGlyph import = LucideGlyph('import', <IconElement>[
    IconPathElement('M12 3v12'), // key: 1x0j5s
    IconPathElement('m8 11 4 4 4-4'), // key: 1dohi6
    IconPathElement(
      'M8 5H4a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-4',
    ), // key: 1ywtjm
  ]);

  /// `inbox.mjs`
  static const LucideGlyph inbox = LucideGlyph('inbox', <IconElement>[
    IconPolylineElement(<Offset>[
      Offset(22, 12),
      Offset(16, 12),
      Offset(14, 15),
      Offset(10, 15),
      Offset(8, 12),
      Offset(2, 12),
    ]), // key: o97t9d
    IconPathElement(
      'M5.45 5.11 2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z',
    ), // key: oot6mr
  ]);

  /// `indian-rupee.mjs`
  static const LucideGlyph indianRupee = LucideGlyph(
    'indian-rupee',
    <IconElement>[
      IconPathElement('M6 3h12'), // key: ggurg9
      IconPathElement('M6 8h12'), // key: 6g4wlu
      IconPathElement('m6 13 8.5 8'), // key: u1kupk
      IconPathElement('M6 13h3'), // key: wdp6ag
      IconPathElement('M9 13c6.667 0 6.667-10 0-10'), // key: 1nkvk2
    ],
  );

  /// `infinity.mjs`
  static const LucideGlyph infinity = LucideGlyph('infinity', <IconElement>[
    IconPathElement(
      'M6 16c5 0 7-8 12-8a4 4 0 0 1 0 8c-5 0-7-8-12-8a4 4 0 1 0 0 8',
    ), // key: 18ogeb
  ]);

  /// `info.mjs`
  static const LucideGlyph info = LucideGlyph('info', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M12 16v-4'), // key: 1dtifu
    IconPathElement('M12 8h.01'), // key: e9boi3
  ]);

  /// `inspection-panel.mjs`
  static const LucideGlyph inspectionPanel = LucideGlyph(
    'inspection-panel',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M7 7h.01'), // key: 7u93v4
      IconPathElement('M17 7h.01'), // key: 14a9sn
      IconPathElement('M7 17h.01'), // key: 19xn7k
      IconPathElement('M17 17h.01'), // key: 1sd3ek
    ],
  );

  /// `italic.mjs`
  static const LucideGlyph italic = LucideGlyph('italic', <IconElement>[
    IconLineElement(19, 4, 10, 4), // key: 15jd3p
    IconLineElement(14, 20, 5, 20), // key: bu0au3
    IconLineElement(15, 4, 9, 20), // key: uljnxc
  ]);

  /// `iteration-ccw.mjs`
  static const LucideGlyph iterationCcw = LucideGlyph(
    'iteration-ccw',
    <IconElement>[
      IconPathElement('m16 14 4 4-4 4'), // key: hkso8o
      IconPathElement('M20 10a8 8 0 1 0-8 8h8'), // key: 1bik7b
    ],
  );

  /// `iteration-cw.mjs`
  static const LucideGlyph iterationCw = LucideGlyph(
    'iteration-cw',
    <IconElement>[
      IconPathElement('M4 10a8 8 0 1 1 8 8H4'), // key: svv66n
      IconPathElement('m8 22-4-4 4-4'), // key: 6g7gki
    ],
  );

  /// `japanese-yen.mjs`
  static const LucideGlyph japaneseYen = LucideGlyph(
    'japanese-yen',
    <IconElement>[
      IconPathElement('M12 9.5V21m0-11.5L6 3m6 6.5L18 3'), // key: 2ej80x
      IconPathElement('M6 15h12'), // key: 1hwgt5
      IconPathElement('M6 11h12'), // key: wf4gp6
    ],
  );

  /// `joystick.mjs`
  static const LucideGlyph joystick = LucideGlyph('joystick', <IconElement>[
    IconPathElement(
      'M21 17a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v2a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-2Z',
    ), // key: jg2n2t
    IconPathElement('M6 15v-2'), // key: gd6mvg
    IconPathElement('M12 15V9'), // key: 8c7uyn
    IconCircleElement(12, 6, 3), // key: 1gm2ql
  ]);

  /// `kanban.mjs`
  static const LucideGlyph kanban = LucideGlyph('kanban', <IconElement>[
    IconPathElement('M5 3v14'), // key: 9nsxs2
    IconPathElement('M12 3v8'), // key: 1h2ygw
    IconPathElement('M19 3v18'), // key: 1sk56x
  ]);

  /// `kayak.mjs`
  static const LucideGlyph kayak = LucideGlyph('kayak', <IconElement>[
    IconPathElement('M18 17a1 1 0 0 0-1 1v1a2 2 0 1 0 2-2z'), // key: skzb1g
    IconPathElement(
      'M20.97 3.61a.45.45 0 0 0-.58-.58C10.2 6.6 6.6 10.2 3.03 20.39a.45.45 0 0 0 .58.58C13.8 17.4 17.4 13.8 20.97 3.61',
    ), // key: cv9jm7
    IconPathElement('m6.707 6.707 10.586 10.586'), // key: d2l993
    IconPathElement('M7 5a2 2 0 1 0-2 2h1a1 1 0 0 0 1-1z'), // key: i0et4n
  ]);

  /// `key-round.mjs`
  static const LucideGlyph keyRound = LucideGlyph('key-round', <IconElement>[
    IconPathElement(
      'M2.586 17.414A2 2 0 0 0 2 18.828V21a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h1a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h.172a2 2 0 0 0 1.414-.586l.814-.814a6.5 6.5 0 1 0-4-4z',
    ), // key: 1s6t7t
    IconCircleElement(16.5, 7.5, 0.5, filled: true), // key: w0ekpg
  ]);

  /// `key-square.mjs`
  static const LucideGlyph keySquare = LucideGlyph('key-square', <IconElement>[
    IconPathElement(
      'M12.4 2.7a2.5 2.5 0 0 1 3.4 0l5.5 5.5a2.5 2.5 0 0 1 0 3.4l-3.7 3.7a2.5 2.5 0 0 1-3.4 0L8.7 9.8a2.5 2.5 0 0 1 0-3.4z',
    ), // key: 165ttr
    IconPathElement('m14 7 3 3'), // key: 1r5n42
    IconPathElement(
      'm9.4 10.6-6.814 6.814A2 2 0 0 0 2 18.828V21a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h1a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h.172a2 2 0 0 0 1.414-.586l.814-.814',
    ), // key: 1ubxi2
  ]);

  /// `key.mjs`
  static const LucideGlyph key = LucideGlyph('key', <IconElement>[
    IconPathElement(
      'm15.5 7.5 2.3 2.3a1 1 0 0 0 1.4 0l2.1-2.1a1 1 0 0 0 0-1.4L19 4',
    ), // key: g0fldk
    IconPathElement('m21 2-9.6 9.6'), // key: 1j0ho8
    IconCircleElement(7.5, 15.5, 5.5), // key: yqb3hr
  ]);

  /// `keyboard-music.mjs`
  static const LucideGlyph keyboardMusic = LucideGlyph(
    'keyboard-music',
    <IconElement>[
      IconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
      IconPathElement('M6 8h4'), // key: utf9t1
      IconPathElement('M14 8h.01'), // key: 1primd
      IconPathElement('M18 8h.01'), // key: emo2bl
      IconPathElement('M2 12h20'), // key: 9i4pu4
      IconPathElement('M6 12v4'), // key: dy92yo
      IconPathElement('M10 12v4'), // key: 1fxnav
      IconPathElement('M14 12v4'), // key: 1hft58
      IconPathElement('M18 12v4'), // key: tjjnbz
    ],
  );

  /// `keyboard-off.mjs`
  static const LucideGlyph keyboardOff = LucideGlyph(
    'keyboard-off',
    <IconElement>[
      IconPathElement('M 20 4 A2 2 0 0 1 22 6'), // key: 1g1fkt
      IconPathElement('M 22 6 L 22 16.41'), // key: 1qjg3w
      IconPathElement('M 7 16 L 16 16'), // key: n0yqwb
      IconPathElement('M 9.69 4 L 20 4'), // key: kbpcgx
      IconPathElement('M14 8h.01'), // key: 1primd
      IconPathElement('M18 8h.01'), // key: emo2bl
      IconPathElement('m2 2 20 20'), // key: 1ooewy
      IconPathElement('M20 20H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2'), // key: s23sx2
      IconPathElement('M6 8h.01'), // key: x9i8wu
      IconPathElement('M8 12h.01'), // key: czm47f
    ],
  );

  /// `keyboard.mjs`
  static const LucideGlyph keyboard = LucideGlyph('keyboard', <IconElement>[
    IconPathElement('M10 8h.01'), // key: 1r9ogq
    IconPathElement('M12 12h.01'), // key: 1mp3jc
    IconPathElement('M14 8h.01'), // key: 1primd
    IconPathElement('M16 12h.01'), // key: 1l6xoz
    IconPathElement('M18 8h.01'), // key: emo2bl
    IconPathElement('M6 8h.01'), // key: x9i8wu
    IconPathElement('M7 16h10'), // key: wp8him
    IconPathElement('M8 12h.01'), // key: czm47f
    IconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
  ]);

  /// `lamp-ceiling.mjs`
  static const LucideGlyph
  lampCeiling = LucideGlyph('lamp-ceiling', <IconElement>[
    IconPathElement('M12 2v5'), // key: nd4vlx
    IconPathElement('M14.829 15.998a3 3 0 1 1-5.658 0'), // key: 1pybiy
    IconPathElement(
      'M20.92 14.606A1 1 0 0 1 20 16H4a1 1 0 0 1-.92-1.394l3-7A1 1 0 0 1 7 7h10a1 1 0 0 1 .92.606z',
    ), // key: ma1wor
  ]);

  /// `lamp-desk.mjs`
  static const LucideGlyph lampDesk = LucideGlyph('lamp-desk', <IconElement>[
    IconPathElement(
      'M10.293 2.293a1 1 0 0 1 1.414 0l2.5 2.5 5.994 1.227a1 1 0 0 1 .506 1.687l-7 7a1 1 0 0 1-1.687-.506l-1.227-5.994-2.5-2.5a1 1 0 0 1 0-1.414z',
    ), // key: sb8slu
    IconPathElement('m14.207 4.793-3.414 3.414'), // key: m2x3oj
    IconPathElement(
      'M3 20a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1z',
    ), // key: 8b3myj
    IconPathElement(
      'm9.086 6.5-4.793 4.793a1 1 0 0 0-.18 1.17L7 18',
    ), // key: 43s6cu
  ]);

  /// `lamp-floor.mjs`
  static const LucideGlyph lampFloor = LucideGlyph('lamp-floor', <IconElement>[
    IconPathElement('M12 10v12'), // key: 6ubwww
    IconPathElement(
      'M17.929 7.629A1 1 0 0 1 17 9H7a1 1 0 0 1-.928-1.371l2-5A1 1 0 0 1 9 2h6a1 1 0 0 1 .928.629z',
    ), // key: 1o95gh
    IconPathElement('M9 22h6'), // key: 1rlq3v
  ]);

  /// `lamp-wall-down.mjs`
  static const LucideGlyph
  lampWallDown = LucideGlyph('lamp-wall-down', <IconElement>[
    IconPathElement(
      'M19.929 18.629A1 1 0 0 1 19 20H9a1 1 0 0 1-.928-1.371l2-5A1 1 0 0 1 11 13h6a1 1 0 0 1 .928.629z',
    ), // key: u4w2d7
    IconPathElement(
      'M6 3a2 2 0 0 1 2 2v2a2 2 0 0 1-2 2H5a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1z',
    ), // key: 15356w
    IconPathElement('M8 6h4a2 2 0 0 1 2 2v5'), // key: 1m6m7x
  ]);

  /// `lamp-wall-up.mjs`
  static const LucideGlyph
  lampWallUp = LucideGlyph('lamp-wall-up', <IconElement>[
    IconPathElement(
      'M19.929 9.629A1 1 0 0 1 19 11H9a1 1 0 0 1-.928-1.371l2-5A1 1 0 0 1 11 4h6a1 1 0 0 1 .928.629z',
    ), // key: 1uvrbf
    IconPathElement(
      'M6 15a2 2 0 0 1 2 2v2a2 2 0 0 1-2 2H5a1 1 0 0 1-1-1v-4a1 1 0 0 1 1-1z',
    ), // key: 154r2a
    IconPathElement('M8 18h4a2 2 0 0 0 2-2v-5'), // key: z9mbu0
  ]);

  /// `lamp.mjs`
  static const LucideGlyph lamp = LucideGlyph('lamp', <IconElement>[
    IconPathElement('M12 12v6'), // key: 3ahymv
    IconPathElement(
      'M4.077 10.615A1 1 0 0 0 5 12h14a1 1 0 0 0 .923-1.385l-3.077-7.384A2 2 0 0 0 15 2H9a2 2 0 0 0-1.846 1.23Z',
    ), // key: 1l7kg2
    IconPathElement(
      'M8 20a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H9a1 1 0 0 1-1-1z',
    ), // key: 1mmzpi
  ]);

  /// `land-plot.mjs`
  static const LucideGlyph landPlot = LucideGlyph('land-plot', <IconElement>[
    IconPathElement('m12 8 6-3-6-3v10'), // key: mvpnpy
    IconPathElement(
      'm8 11.99-5.5 3.14a1 1 0 0 0 0 1.74l8.5 4.86a2 2 0 0 0 2 0l8.5-4.86a1 1 0 0 0 0-1.74L16 12',
    ), // key: ek95tt
    IconPathElement('m6.49 12.85 11.02 6.3'), // key: 1kt42w
    IconPathElement('M17.51 12.85 6.5 19.15'), // key: v55bdg
  ]);

  /// `landmark.mjs`
  static const LucideGlyph landmark = LucideGlyph('landmark', <IconElement>[
    IconPathElement('M10 18v-7'), // key: wt116b
    IconPathElement(
      'M11.119 2.205a2 2 0 0 1 1.762 0l7.84 3.846A.5.5 0 0 1 20.5 7h-17a.5.5 0 0 1-.22-.949z',
    ), // key: yxxwt6
    IconPathElement('M14 18v-7'), // key: vav6t3
    IconPathElement('M18 18v-7'), // key: aexdmj
    IconPathElement('M3 22h18'), // key: 8prr45
    IconPathElement('M6 18v-7'), // key: 1ivflk
  ]);

  /// `languages.mjs`
  static const LucideGlyph languages = LucideGlyph('languages', <IconElement>[
    IconPathElement('m5 8 6 6'), // key: 1wu5hv
    IconPathElement('m4 14 6-6 2-3'), // key: 1k1g8d
    IconPathElement('M2 5h12'), // key: or177f
    IconPathElement('M7 2h1'), // key: 1t2jsx
    IconPathElement('m22 22-5-10-5 10'), // key: don7ne
    IconPathElement('M14 18h6'), // key: 1m8k6r
  ]);

  /// `laptop-minimal-check.mjs`
  static const LucideGlyph laptopMinimalCheck = LucideGlyph(
    'laptop-minimal-check',
    <IconElement>[
      IconPathElement('M2 20h20'), // key: owomy5
      IconPathElement('m9 10 2 2 4-4'), // key: 1gnqz4
      IconRectElement(3, 4, 18, 12, 2), // key: 8ur36m
    ],
  );

  /// `laptop-minimal.mjs`
  static const LucideGlyph laptopMinimal = LucideGlyph(
    'laptop-minimal',
    <IconElement>[
      IconRectElement(3, 4, 18, 12, 2, ry: 2), // key: 1qhy41
      IconLineElement(2, 20, 22, 20), // key: ni3hll
    ],
  );

  /// `laptop.mjs`
  static const LucideGlyph laptop = LucideGlyph('laptop', <IconElement>[
    IconPathElement(
      'M18 5a2 2 0 0 1 2 2v8.526a2 2 0 0 0 .212.897l1.068 2.127a1 1 0 0 1-.9 1.45H3.62a1 1 0 0 1-.9-1.45l1.068-2.127A2 2 0 0 0 4 15.526V7a2 2 0 0 1 2-2z',
    ), // key: 1pdavp
    IconPathElement('M20.054 15.987H3.946'), // key: 14rxg9
  ]);

  /// `lasso-select.mjs`
  static const LucideGlyph
  lassoSelect = LucideGlyph('lasso-select', <IconElement>[
    IconPathElement('M7 22a5 5 0 0 1-2-4'), // key: umushi
    IconPathElement('M7 16.93c.96.43 1.96.74 2.99.91'), // key: ybbtv3
    IconPathElement(
      'M3.34 14A6.8 6.8 0 0 1 2 10c0-4.42 4.48-8 10-8s10 3.58 10 8a7.19 7.19 0 0 1-.33 2',
    ), // key: gt5e1w
    IconPathElement('M5 18a2 2 0 1 0 0-4 2 2 0 0 0 0 4z'), // key: bq3ynw
    IconPathElement(
      'M14.33 22h-.09a.35.35 0 0 1-.24-.32v-10a.34.34 0 0 1 .33-.34c.08 0 .15.03.21.08l7.34 6a.33.33 0 0 1-.21.59h-4.49l-2.57 3.85a.35.35 0 0 1-.28.14z',
    ), // key: 72q637
  ]);

  /// `lasso.mjs`
  static const LucideGlyph lasso = LucideGlyph('lasso', <IconElement>[
    IconPathElement('M3.704 14.467a10 8 0 1 1 3.115 2.375'), // key: wxgc5m
    IconPathElement('M7 22a5 5 0 0 1-2-3.994'), // key: 1xp6a4
    IconCircleElement(5, 16, 2), // key: 18csp3
  ]);

  /// `laugh.mjs`
  static const LucideGlyph laugh = LucideGlyph('laugh', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M18 13a6 6 0 0 1-6 5 6 6 0 0 1-6-5h12Z'), // key: b2q4dd
    IconLineElement(9, 9, 9.01, 9), // key: yxxnd0
    IconLineElement(15, 9, 15.01, 9), // key: 1p4y9e
  ]);

  /// `layers-2.mjs`
  static const LucideGlyph layers2 = LucideGlyph('layers-2', <IconElement>[
    IconPathElement(
      'M13 13.74a2 2 0 0 1-2 0L2.5 8.87a1 1 0 0 1 0-1.74L11 2.26a2 2 0 0 1 2 0l8.5 4.87a1 1 0 0 1 0 1.74z',
    ), // key: 15q6uc
    IconPathElement(
      'm20 14.285 1.5.845a1 1 0 0 1 0 1.74L13 21.74a2 2 0 0 1-2 0l-8.5-4.87a1 1 0 0 1 0-1.74l1.5-.845',
    ), // key: byia6g
  ]);

  /// `layers-minus.mjs`
  static const LucideGlyph
  layersMinus = LucideGlyph('layers-minus', <IconElement>[
    IconPathElement(
      'M12.83 2.18a2 2 0 0 0-1.66 0L2.6 6.08a1 1 0 0 0 0 1.83l8.58 3.91a2 2 0 0 0 .83.18 2 2 0 0 0 .83-.18l8.58-3.9a1 1 0 0 0 0-1.832z',
    ), // key: tq134k
    IconPathElement('M16 17h6'), // key: 1ook5g
    IconPathElement(
      'M2.003 11.995a1 1 0 0 0 .597.915l8.58 3.91a2 2 0 0 0 .83.18',
    ), // key: 8mjqed
    IconPathElement(
      'M2.003 16.995a1 1 0 0 0 .597.915l8.58 3.91a2 2 0 0 0 .83.18 2 2 0 0 0 .83-.18l2.11-.96',
    ), // key: 7vwz41
    IconPathElement(
      'M22.018 12.004a1 1 0 0 1-.598.916l-.177.08',
    ), // key: bm5b9y
  ]);

  /// `layers-plus.mjs`
  static const LucideGlyph
  layersPlus = LucideGlyph('layers-plus', <IconElement>[
    IconPathElement(
      'M12.83 2.18a2 2 0 0 0-1.66 0L2.6 6.08a1 1 0 0 0 0 1.83l8.58 3.91a2 2 0 0 0 .83.18 2 2 0 0 0 .83-.18l8.58-3.9a1 1 0 0 0 0-1.831z',
    ), // key: zzgyd3
    IconPathElement('M16 17h6'), // key: 1ook5g
    IconPathElement('M19 14v6'), // key: 1ckrd5
    IconPathElement(
      'M2 12a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 .825.178',
    ), // key: 1ia9y3
    IconPathElement(
      'M2 17a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 1.65 0l2.116-.962',
    ), // key: jksky3
  ]);

  /// `layers.mjs`
  static const LucideGlyph layers = LucideGlyph('layers', <IconElement>[
    IconPathElement(
      'M12.83 2.18a2 2 0 0 0-1.66 0L2.6 6.08a1 1 0 0 0 0 1.83l8.58 3.91a2 2 0 0 0 1.66 0l8.58-3.9a1 1 0 0 0 0-1.83z',
    ), // key: zw3jo
    IconPathElement(
      'M2 12a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 1.65 0l8.58-3.9A1 1 0 0 0 22 12',
    ), // key: 1wduqc
    IconPathElement(
      'M2 17a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 1.65 0l8.58-3.9A1 1 0 0 0 22 17',
    ), // key: kqbvx6
  ]);

  /// `layout-dashboard.mjs`
  static const LucideGlyph layoutDashboard = LucideGlyph(
    'layout-dashboard',
    <IconElement>[
      IconRectElement(3, 3, 7, 9, 1), // key: 10lvy0
      IconRectElement(14, 3, 7, 5, 1), // key: 16une8
      IconRectElement(14, 12, 7, 9, 1), // key: 1hutg5
      IconRectElement(3, 16, 7, 5, 1), // key: ldoo1y
    ],
  );

  /// `layout-freeform.mjs`
  static const LucideGlyph layoutFreeform = LucideGlyph(
    'layout-freeform',
    <IconElement>[
      IconRectElement(3, 3, 7, 7, 1), // key: 1g98yp
      IconRectElement(14, 4, 7, 7, 1), // key: n7b4zl
      IconRectElement(4, 14, 7, 7, 1), // key: 1ngf42
    ],
  );

  /// `layout-grid.mjs`
  static const LucideGlyph layoutGrid = LucideGlyph(
    'layout-grid',
    <IconElement>[
      IconRectElement(3, 3, 7, 7, 1), // key: 1g98yp
      IconRectElement(14, 3, 7, 7, 1), // key: 6d4xhi
      IconRectElement(14, 14, 7, 7, 1), // key: nxv5o0
      IconRectElement(3, 14, 7, 7, 1), // key: 1bb6yr
    ],
  );

  /// `layout-list.mjs`
  static const LucideGlyph layoutList = LucideGlyph(
    'layout-list',
    <IconElement>[
      IconRectElement(3, 3, 7, 7, 1), // key: 1g98yp
      IconRectElement(3, 14, 7, 7, 1), // key: 1bb6yr
      IconPathElement('M14 4h7'), // key: 3xa0d5
      IconPathElement('M14 9h7'), // key: 1icrd9
      IconPathElement('M14 15h7'), // key: 1mj8o2
      IconPathElement('M14 20h7'), // key: 11slyb
    ],
  );

  /// `layout-panel-left.mjs`
  static const LucideGlyph layoutPanelLeft = LucideGlyph(
    'layout-panel-left',
    <IconElement>[
      IconRectElement(3, 3, 7, 18, 1), // key: 2obqm
      IconRectElement(14, 3, 7, 7, 1), // key: 6d4xhi
      IconRectElement(14, 14, 7, 7, 1), // key: nxv5o0
    ],
  );

  /// `layout-panel-top.mjs`
  static const LucideGlyph layoutPanelTop = LucideGlyph(
    'layout-panel-top',
    <IconElement>[
      IconRectElement(3, 3, 18, 7, 1), // key: f1a2em
      IconRectElement(3, 14, 7, 7, 1), // key: 1bb6yr
      IconRectElement(14, 14, 7, 7, 1), // key: nxv5o0
    ],
  );

  /// `layout-template.mjs`
  static const LucideGlyph layoutTemplate = LucideGlyph(
    'layout-template',
    <IconElement>[
      IconRectElement(3, 3, 18, 7, 1), // key: f1a2em
      IconRectElement(3, 14, 9, 7, 1), // key: jqznyg
      IconRectElement(16, 14, 5, 7, 1), // key: q5h2i8
    ],
  );

  /// `leaf.mjs`
  static const LucideGlyph leaf = LucideGlyph('leaf', <IconElement>[
    IconPathElement(
      'M11 20A7 7 0 0 1 9.8 6.1C15.5 5 17 4.48 19 2c1 2 2 4.18 2 8 0 5.5-4.78 10-10 10Z',
    ), // key: nnexq3
    IconPathElement(
      'M2 21c0-3 1.85-5.36 5.08-6C9.5 14.52 12 13 13 12',
    ), // key: mt58a7
  ]);

  /// `leafy-green.mjs`
  static const LucideGlyph
  leafyGreen = LucideGlyph('leafy-green', <IconElement>[
    IconPathElement(
      'M2 22c1.25-.987 2.27-1.975 3.9-2.2a5.56 5.56 0 0 1 3.8 1.5 4 4 0 0 0 6.187-2.353 3.5 3.5 0 0 0 3.69-5.116A3.5 3.5 0 0 0 20.95 8 3.5 3.5 0 1 0 16 3.05a3.5 3.5 0 0 0-5.831 1.373 3.5 3.5 0 0 0-5.116 3.69 4 4 0 0 0-2.348 6.155C3.499 15.42 4.409 16.712 4.2 18.1 3.926 19.743 3.014 20.732 2 22',
    ), // key: 1134nt
    IconPathElement('M2 22 17 7'), // key: 1q7jp2
  ]);

  /// `lectern.mjs`
  static const LucideGlyph lectern = LucideGlyph('lectern', <IconElement>[
    IconPathElement(
      'M16 12h3a2 2 0 0 0 1.902-1.38l1.056-3.333A1 1 0 0 0 21 6H3a1 1 0 0 0-.958 1.287l1.056 3.334A2 2 0 0 0 5 12h3',
    ), // key: 13jjxg
    IconPathElement('M18 6V3a1 1 0 0 0-1-1h-3'), // key: 1550fe
    IconRectElement(8, 10, 8, 12, 1), // key: qmu8b6
  ]);

  /// `lens-concave.mjs`
  static const LucideGlyph
  lensConcave = LucideGlyph('lens-concave', <IconElement>[
    IconPathElement(
      'M7 2a1 1 0 0 0-.8 1.6 14 14 0 0 1 0 16.8A1 1 0 0 0 7 22h10a1 1 0 0 0 .8-1.6 14 14 0 0 1 0-16.8A1 1 0 0 0 17 2z',
    ), // key: 109j23
  ]);

  /// `lens-convex.mjs`
  static const LucideGlyph
  lensConvex = LucideGlyph('lens-convex', <IconElement>[
    IconPathElement(
      'M13.433 2a1 1 0 0 1 .824.448 18 18 0 0 1 0 19.104 1 1 0 0 1-.824.448h-2.866a1 1 0 0 1-.824-.448 18 18 0 0 1 0-19.104A1 1 0 0 1 10.567 2z',
    ), // key: cq67go
  ]);

  /// `library-big.mjs`
  static const LucideGlyph
  libraryBig = LucideGlyph('library-big', <IconElement>[
    IconRectElement(3, 3, 8, 18, 1), // key: oynpb5
    IconPathElement('M7 3v18'), // key: bbkbws
    IconPathElement(
      'M20.4 18.9c.2.5-.1 1.1-.6 1.3l-1.9.7c-.5.2-1.1-.1-1.3-.6L11.1 5.1c-.2-.5.1-1.1.6-1.3l1.9-.7c.5-.2 1.1.1 1.3.6Z',
    ), // key: 1qboyk
  ]);

  /// `library.mjs`
  static const LucideGlyph library = LucideGlyph('library', <IconElement>[
    IconPathElement('m16 6 4 14'), // key: ji33uf
    IconPathElement('M12 6v14'), // key: 1n7gus
    IconPathElement('M8 8v12'), // key: 1gg7y9
    IconPathElement('M4 4v16'), // key: 6qkkli
  ]);

  /// `life-buoy.mjs`
  static const LucideGlyph lifeBuoy = LucideGlyph('life-buoy', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('m4.93 4.93 4.24 4.24'), // key: 1ymg45
    IconPathElement('m14.83 9.17 4.24-4.24'), // key: 1cb5xl
    IconPathElement('m14.83 14.83 4.24 4.24'), // key: q42g0n
    IconPathElement('m9.17 14.83-4.24 4.24'), // key: bqpfvv
    IconCircleElement(12, 12, 4), // key: 4exip2
  ]);

  /// `ligature.mjs`
  static const LucideGlyph ligature = LucideGlyph('ligature', <IconElement>[
    IconPathElement('M14 12h2v8'), // key: c1fccl
    IconPathElement('M14 20h4'), // key: lzx1xo
    IconPathElement('M6 12h4'), // key: a4o3ry
    IconPathElement('M6 20h4'), // key: 1i6q5t
    IconPathElement('M8 20V8a4 4 0 0 1 7.464-2'), // key: wk9t6r
  ]);

  /// `lightbulb-off.mjs`
  static const LucideGlyph lightbulbOff = LucideGlyph(
    'lightbulb-off',
    <IconElement>[
      IconPathElement(
        'M16.8 11.2c.8-.9 1.2-2 1.2-3.2a6 6 0 0 0-9.3-5',
      ), // key: 1fkcox
      IconPathElement('m2 2 20 20'), // key: 1ooewy
      IconPathElement(
        'M6.3 6.3a4.67 4.67 0 0 0 1.2 5.2c.7.7 1.3 1.5 1.5 2.5',
      ), // key: 10m8kw
      IconPathElement('M9 18h6'), // key: x1upvd
      IconPathElement('M10 22h4'), // key: ceow96
    ],
  );

  /// `lightbulb.mjs`
  static const LucideGlyph lightbulb = LucideGlyph('lightbulb', <IconElement>[
    IconPathElement(
      'M15 14c.2-1 .7-1.7 1.5-2.5 1-.9 1.5-2.2 1.5-3.5A6 6 0 0 0 6 8c0 1 .2 2.2 1.5 3.5.7.7 1.3 1.5 1.5 2.5',
    ), // key: 1gvzjb
    IconPathElement('M9 18h6'), // key: x1upvd
    IconPathElement('M10 22h4'), // key: ceow96
  ]);

  /// `line-dot-right-horizontal.mjs`
  static const LucideGlyph lineDotRightHorizontal = LucideGlyph(
    'line-dot-right-horizontal',
    <IconElement>[
      IconPathElement('M 3 12 L 15 12'), // key: ymhu98
      IconCircleElement(18, 12, 3), // key: 1kchzo
    ],
  );

  /// `line-squiggle.mjs`
  static const LucideGlyph
  lineSquiggle = LucideGlyph('line-squiggle', <IconElement>[
    IconPathElement(
      'M7 3.5c5-2 7 2.5 3 4C1.5 10 2 15 5 16c5 2 9-10 14-7s.5 13.5-4 12c-5-2.5.5-11 6-2',
    ), // key: 1lrphd
  ]);

  /// `line-style.mjs`
  static const LucideGlyph lineStyle = LucideGlyph('line-style', <IconElement>[
    IconPathElement('M11 5h2'), // key: 1s6z07
    IconPathElement('M15 12h6'), // key: upa0zy
    IconPathElement('M19 5h2'), // key: fjylsg
    IconPathElement('M3 12h6'), // key: ra68u1
    IconPathElement('M3 19h18'), // key: awlh7x
    IconPathElement('M3 5h2'), // key: 1qgu90
  ]);

  /// `link-2-off.mjs`
  static const LucideGlyph link2Off = LucideGlyph('link-2-off', <IconElement>[
    IconPathElement('M9 17H7A5 5 0 0 1 7 7'), // key: 10o201
    IconPathElement('M15 7h2a5 5 0 0 1 4 8'), // key: 1d3206
    IconLineElement(8, 12, 12, 12), // key: rvw6j4
    IconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `link-2.mjs`
  static const LucideGlyph link2 = LucideGlyph('link-2', <IconElement>[
    IconPathElement('M9 17H7A5 5 0 0 1 7 7h2'), // key: 8i5ue5
    IconPathElement('M15 7h2a5 5 0 1 1 0 10h-2'), // key: 1b9ql8
    IconLineElement(8, 12, 16, 12), // key: 1jonct
  ]);

  /// `link.mjs`
  static const LucideGlyph link = LucideGlyph('link', <IconElement>[
    IconPathElement(
      'M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71',
    ), // key: 1cjeqo
    IconPathElement(
      'M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71',
    ), // key: 19qd67
  ]);

  /// `list-check.mjs`
  static const LucideGlyph listCheck = LucideGlyph('list-check', <IconElement>[
    IconPathElement('M16 5H3'), // key: m91uny
    IconPathElement('M16 12H3'), // key: 1a2rj7
    IconPathElement('M11 19H3'), // key: zflm78
    IconPathElement('m15 18 2 2 4-4'), // key: 1szwhi
  ]);

  /// `list-checks.mjs`
  static const LucideGlyph listChecks = LucideGlyph(
    'list-checks',
    <IconElement>[
      IconPathElement('M13 5h8'), // key: a7qcls
      IconPathElement('M13 12h8'), // key: h98zly
      IconPathElement('M13 19h8'), // key: c3s6r1
      IconPathElement('m3 17 2 2 4-4'), // key: 1jhpwq
      IconPathElement('m3 7 2 2 4-4'), // key: 1obspn
    ],
  );

  /// `list-chevrons-down-up.mjs`
  static const LucideGlyph listChevronsDownUp = LucideGlyph(
    'list-chevrons-down-up',
    <IconElement>[
      IconPathElement('M3 5h8'), // key: 18g2rq
      IconPathElement('M3 12h8'), // key: 1xfjp6
      IconPathElement('M3 19h8'), // key: fpbke4
      IconPathElement('m15 5 3 3 3-3'), // key: 1t4thf
      IconPathElement('m15 19 3-3 3 3'), // key: y4ckd2
    ],
  );

  /// `list-chevrons-up-down.mjs`
  static const LucideGlyph listChevronsUpDown = LucideGlyph(
    'list-chevrons-up-down',
    <IconElement>[
      IconPathElement('M3 5h8'), // key: 18g2rq
      IconPathElement('M3 12h8'), // key: 1xfjp6
      IconPathElement('M3 19h8'), // key: fpbke4
      IconPathElement('m15 8 3-3 3 3'), // key: bc4io6
      IconPathElement('m15 16 3 3 3-3'), // key: 9wmg1l
    ],
  );

  /// `list-collapse.mjs`
  static const LucideGlyph listCollapse = LucideGlyph(
    'list-collapse',
    <IconElement>[
      IconPathElement('M10 5h11'), // key: 1hkqpe
      IconPathElement('M10 12h11'), // key: 6m4ad9
      IconPathElement('M10 19h11'), // key: 14g2nv
      IconPathElement('m3 10 3-3-3-3'), // key: i7pm08
      IconPathElement('m3 20 3-3-3-3'), // key: 20gx1n
    ],
  );

  /// `list-end.mjs`
  static const LucideGlyph listEnd = LucideGlyph('list-end', <IconElement>[
    IconPathElement('M16 5H3'), // key: m91uny
    IconPathElement('M16 12H3'), // key: 1a2rj7
    IconPathElement('M9 19H3'), // key: s61nz1
    IconPathElement('m16 16-3 3 3 3'), // key: 117b85
    IconPathElement('M21 5v12a2 2 0 0 1-2 2h-6'), // key: hey24a
  ]);

  /// `list-filter-plus.mjs`
  static const LucideGlyph listFilterPlus = LucideGlyph(
    'list-filter-plus',
    <IconElement>[
      IconPathElement('M12 5H2'), // key: 1o22fu
      IconPathElement('M6 12h12'), // key: 8npq4p
      IconPathElement('M9 19h6'), // key: 456am0
      IconPathElement('M16 5h6'), // key: 1vod17
      IconPathElement('M19 8V2'), // key: 1wcffq
    ],
  );

  /// `list-filter.mjs`
  static const LucideGlyph listFilter = LucideGlyph(
    'list-filter',
    <IconElement>[
      IconPathElement('M2 5h20'), // key: 1fs1ex
      IconPathElement('M6 12h12'), // key: 8npq4p
      IconPathElement('M9 19h6'), // key: 456am0
    ],
  );

  /// `list-indent-decrease.mjs`
  static const LucideGlyph listIndentDecrease = LucideGlyph(
    'list-indent-decrease',
    <IconElement>[
      IconPathElement('M21 5H11'), // key: us1j55
      IconPathElement('M21 12H11'), // key: wd7e0v
      IconPathElement('M21 19H11'), // key: saa85w
      IconPathElement('m7 8-4 4 4 4'), // key: o5hrat
    ],
  );

  /// `list-indent-increase.mjs`
  static const LucideGlyph listIndentIncrease = LucideGlyph(
    'list-indent-increase',
    <IconElement>[
      IconPathElement('M21 5H11'), // key: us1j55
      IconPathElement('M21 12H11'), // key: wd7e0v
      IconPathElement('M21 19H11'), // key: saa85w
      IconPathElement('m3 8 4 4-4 4'), // key: 1a3j6y
    ],
  );

  /// `list-minus.mjs`
  static const LucideGlyph listMinus = LucideGlyph('list-minus', <IconElement>[
    IconPathElement('M16 5H3'), // key: m91uny
    IconPathElement('M11 12H3'), // key: 51ecnj
    IconPathElement('M16 19H3'), // key: zzsher
    IconPathElement('M21 12h-6'), // key: bt1uis
  ]);

  /// `list-music.mjs`
  static const LucideGlyph listMusic = LucideGlyph('list-music', <IconElement>[
    IconPathElement('M16 5H3'), // key: m91uny
    IconPathElement('M11 12H3'), // key: 51ecnj
    IconPathElement('M11 19H3'), // key: zflm78
    IconPathElement('M21 16V5'), // key: yxg4q8
    IconCircleElement(18, 16, 3), // key: 1hluhg
  ]);

  /// `list-ordered.mjs`
  static const LucideGlyph listOrdered = LucideGlyph(
    'list-ordered',
    <IconElement>[
      IconPathElement('M11 5h10'), // key: 1cz7ny
      IconPathElement('M11 12h10'), // key: 1438ji
      IconPathElement('M11 19h10'), // key: 11t30w
      IconPathElement('M4 4h1v5'), // key: 10yrso
      IconPathElement('M4 9h2'), // key: r1h2o0
      IconPathElement(
        'M6.5 20H3.4c0-1 2.6-1.925 2.6-3.5a1.5 1.5 0 0 0-2.6-1.02',
      ), // key: xtkcd5
    ],
  );

  /// `list-plus.mjs`
  static const LucideGlyph listPlus = LucideGlyph('list-plus', <IconElement>[
    IconPathElement('M16 5H3'), // key: m91uny
    IconPathElement('M11 12H3'), // key: 51ecnj
    IconPathElement('M16 19H3'), // key: zzsher
    IconPathElement('M18 9v6'), // key: 1twb98
    IconPathElement('M21 12h-6'), // key: bt1uis
  ]);

  /// `list-restart.mjs`
  static const LucideGlyph
  listRestart = LucideGlyph('list-restart', <IconElement>[
    IconPathElement('M21 5H3'), // key: 1fi0y6
    IconPathElement('M7 12H3'), // key: 13ou7f
    IconPathElement('M7 19H3'), // key: wbqt3n
    IconPathElement(
      'M12 18a5 5 0 0 0 9-3 4.5 4.5 0 0 0-4.5-4.5c-1.33 0-2.54.54-3.41 1.41L11 14',
    ), // key: qth677
    IconPathElement('M11 10v4h4'), // key: 172dkj
  ]);

  /// `list-sort-ascending.mjs`
  static const LucideGlyph listSortAscending = LucideGlyph(
    'list-sort-ascending',
    <IconElement>[
      IconPathElement('M3 19h18'), // key: awlh7x
      IconPathElement('M15 12H3'), // key: 6jk70r
      IconPathElement('M9 5H3'), // key: 15j2za
    ],
  );

  /// `list-sort-descending.mjs`
  static const LucideGlyph listSortDescending = LucideGlyph(
    'list-sort-descending',
    <IconElement>[
      IconPathElement('M15 12H3'), // key: 6jk70r
      IconPathElement('M3 5h18'), // key: 1u36vt
      IconPathElement('M9 19H3'), // key: s61nz1
    ],
  );

  /// `list-start.mjs`
  static const LucideGlyph listStart = LucideGlyph('list-start', <IconElement>[
    IconPathElement('M3 5h6'), // key: 1ltk0q
    IconPathElement('M3 12h13'), // key: ppymz1
    IconPathElement('M3 19h13'), // key: bpdczq
    IconPathElement('m16 8-3-3 3-3'), // key: 1pjpp6
    IconPathElement('M21 19V7a2 2 0 0 0-2-2h-6'), // key: 4zzq67
  ]);

  /// `list-todo.mjs`
  static const LucideGlyph listTodo = LucideGlyph('list-todo', <IconElement>[
    IconPathElement('M13 5h8'), // key: a7qcls
    IconPathElement('M13 12h8'), // key: h98zly
    IconPathElement('M13 19h8'), // key: c3s6r1
    IconPathElement('m3 17 2 2 4-4'), // key: 1jhpwq
    IconRectElement(3, 4, 6, 6, 1), // key: cif1o7
  ]);

  /// `list-tree.mjs`
  static const LucideGlyph listTree = LucideGlyph('list-tree', <IconElement>[
    IconPathElement('M8 5h13'), // key: 1pao27
    IconPathElement('M13 12h8'), // key: h98zly
    IconPathElement('M13 19h8'), // key: c3s6r1
    IconPathElement('M3 10a2 2 0 0 0 2 2h3'), // key: 1npucw
    IconPathElement('M3 5v12a2 2 0 0 0 2 2h3'), // key: x1gjn2
  ]);

  /// `list-video.mjs`
  static const LucideGlyph listVideo = LucideGlyph('list-video', <IconElement>[
    IconPathElement('M21 5H3'), // key: 1fi0y6
    IconPathElement('M10 12H3'), // key: 1ulcyk
    IconPathElement('M10 19H3'), // key: 108z41
    IconPathElement(
      'M15 12.003a1 1 0 0 1 1.517-.859l4.997 2.997a1 1 0 0 1 0 1.718l-4.997 2.997a1 1 0 0 1-1.517-.86z',
    ), // key: ms4nik
  ]);

  /// `list-x.mjs`
  static const LucideGlyph listX = LucideGlyph('list-x', <IconElement>[
    IconPathElement('M16 5H3'), // key: m91uny
    IconPathElement('M11 12H3'), // key: 51ecnj
    IconPathElement('M16 19H3'), // key: zzsher
    IconPathElement('m15.5 9.5 5 5'), // key: ytk86i
    IconPathElement('m20.5 9.5-5 5'), // key: 17o44f
  ]);

  /// `list.mjs`
  static const LucideGlyph list = LucideGlyph('list', <IconElement>[
    IconPathElement('M3 5h.01'), // key: 18ugdj
    IconPathElement('M3 12h.01'), // key: nlz23k
    IconPathElement('M3 19h.01'), // key: noohij
    IconPathElement('M8 5h13'), // key: 1pao27
    IconPathElement('M8 12h13'), // key: 1za7za
    IconPathElement('M8 19h13'), // key: m83p4d
  ]);

  /// `loader-circle.mjs`
  static const LucideGlyph loaderCircle = LucideGlyph(
    'loader-circle',
    <IconElement>[
      IconPathElement('M21 12a9 9 0 1 1-6.219-8.56'), // key: 13zald
    ],
  );

  /// `loader-pinwheel.mjs`
  static const LucideGlyph loaderPinwheel = LucideGlyph(
    'loader-pinwheel',
    <IconElement>[
      IconPathElement('M22 12a1 1 0 0 1-10 0 1 1 0 0 0-10 0'), // key: 1lzz15
      IconPathElement('M7 20.7a1 1 0 1 1 5-8.7 1 1 0 1 0 5-8.6'), // key: 1gnrpi
      IconPathElement('M7 3.3a1 1 0 1 1 5 8.6 1 1 0 1 0 5 8.6'), // key: u9yy5q
      IconCircleElement(12, 12, 10), // key: 1mglay
    ],
  );

  /// `loader.mjs`
  static const LucideGlyph loader = LucideGlyph('loader', <IconElement>[
    IconPathElement('M12 2v4'), // key: 3427ic
    IconPathElement('m16.2 7.8 2.9-2.9'), // key: r700ao
    IconPathElement('M18 12h4'), // key: wj9ykh
    IconPathElement('m16.2 16.2 2.9 2.9'), // key: 1bxg5t
    IconPathElement('M12 18v4'), // key: jadmvz
    IconPathElement('m4.9 19.1 2.9-2.9'), // key: bwix9q
    IconPathElement('M2 12h4'), // key: j09sii
    IconPathElement('m4.9 4.9 2.9 2.9'), // key: giyufr
  ]);

  /// `locate-fixed.mjs`
  static const LucideGlyph locateFixed = LucideGlyph(
    'locate-fixed',
    <IconElement>[
      IconLineElement(2, 12, 5, 12), // key: bvdh0s
      IconLineElement(19, 12, 22, 12), // key: 1tbv5k
      IconLineElement(12, 2, 12, 5), // key: 11lu5j
      IconLineElement(12, 19, 12, 22), // key: x3vr5v
      IconCircleElement(12, 12, 7), // key: fim9np
      IconCircleElement(12, 12, 3), // key: 1v7zrd
    ],
  );

  /// `locate-off.mjs`
  static const LucideGlyph locateOff = LucideGlyph('locate-off', <IconElement>[
    IconPathElement('M12 19v3'), // key: npa21l
    IconPathElement('M12 2v3'), // key: qbqxhf
    IconPathElement('M18.89 13.24a7 7 0 0 0-8.13-8.13'), // key: 1v9jrh
    IconPathElement('M19 12h3'), // key: osuazr
    IconPathElement('M2 12h3'), // key: 1wrr53
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement('M7.05 7.05a7 7 0 0 0 9.9 9.9'), // key: rc5l2e
  ]);

  /// `locate.mjs`
  static const LucideGlyph locate = LucideGlyph('locate', <IconElement>[
    IconLineElement(2, 12, 5, 12), // key: bvdh0s
    IconLineElement(19, 12, 22, 12), // key: 1tbv5k
    IconLineElement(12, 2, 12, 5), // key: 11lu5j
    IconLineElement(12, 19, 12, 22), // key: x3vr5v
    IconCircleElement(12, 12, 7), // key: fim9np
  ]);

  /// `lock-keyhole-open.mjs`
  static const LucideGlyph lockKeyholeOpen = LucideGlyph(
    'lock-keyhole-open',
    <IconElement>[
      IconCircleElement(12, 16, 1), // key: 1au0dj
      IconRectElement(3, 10, 18, 12, 2), // key: l0tzu3
      IconPathElement('M7 10V7a5 5 0 0 1 9.33-2.5'), // key: car5b7
    ],
  );

  /// `lock-keyhole.mjs`
  static const LucideGlyph lockKeyhole = LucideGlyph(
    'lock-keyhole',
    <IconElement>[
      IconCircleElement(12, 16, 1), // key: 1au0dj
      IconRectElement(3, 10, 18, 12, 2), // key: 6s8ecr
      IconPathElement('M7 10V7a5 5 0 0 1 10 0v3'), // key: 1pqi11
    ],
  );

  /// `lock-open.mjs`
  static const LucideGlyph lockOpen = LucideGlyph('lock-open', <IconElement>[
    IconRectElement(3, 11, 18, 11, 2, ry: 2), // key: 1w4ew1
    IconPathElement('M7 11V7a5 5 0 0 1 9.9-1'), // key: 1mm8w8
  ]);

  /// `lock.mjs`
  static const LucideGlyph lock = LucideGlyph('lock', <IconElement>[
    IconRectElement(3, 11, 18, 11, 2, ry: 2), // key: 1w4ew1
    IconPathElement('M7 11V7a5 5 0 0 1 10 0v4'), // key: fwvmzm
  ]);

  /// `log-in.mjs`
  static const LucideGlyph logIn = LucideGlyph('log-in', <IconElement>[
    IconPathElement('m10 17 5-5-5-5'), // key: 1bsop3
    IconPathElement('M15 12H3'), // key: 6jk70r
    IconPathElement('M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4'), // key: u53s6r
  ]);

  /// `log-out.mjs`
  static const LucideGlyph logOut = LucideGlyph('log-out', <IconElement>[
    IconPathElement('m16 17 5-5-5-5'), // key: 1bji2h
    IconPathElement('M21 12H9'), // key: dn1m92
    IconPathElement('M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4'), // key: 1uf3rs
  ]);

  /// `logs.mjs`
  static const LucideGlyph logs = LucideGlyph('logs', <IconElement>[
    IconPathElement('M3 5h1'), // key: 1mv5vm
    IconPathElement('M3 12h1'), // key: lp3yf2
    IconPathElement('M3 19h1'), // key: w6f3n9
    IconPathElement('M8 5h1'), // key: 1nxr5w
    IconPathElement('M8 12h1'), // key: 1con00
    IconPathElement('M8 19h1'), // key: k7p10e
    IconPathElement('M13 5h8'), // key: a7qcls
    IconPathElement('M13 12h8'), // key: h98zly
    IconPathElement('M13 19h8'), // key: c3s6r1
  ]);

  /// `lollipop.mjs`
  static const LucideGlyph lollipop = LucideGlyph('lollipop', <IconElement>[
    IconCircleElement(11, 11, 8), // key: 4ej97u
    IconPathElement('m21 21-4.3-4.3'), // key: 1qie3q
    IconPathElement(
      'M11 11a2 2 0 0 0 4 0 4 4 0 0 0-8 0 6 6 0 0 0 12 0',
    ), // key: 107gwy
  ]);

  /// `luggage.mjs`
  static const LucideGlyph luggage = LucideGlyph('luggage', <IconElement>[
    IconPathElement(
      'M6 20a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2',
    ), // key: 1m57jg
    IconPathElement('M8 18V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v14'), // key: 1l99gc
    IconPathElement('M10 20h4'), // key: ni2waw
    IconCircleElement(16, 20, 2), // key: 1vifvg
    IconCircleElement(8, 20, 2), // key: ckkr5m
  ]);

  /// `magnet.mjs`
  static const LucideGlyph magnet = LucideGlyph('magnet', <IconElement>[
    IconPathElement('m12 15 4 4'), // key: lnac28
    IconPathElement(
      'M2.352 10.648a1.205 1.205 0 0 0 0 1.704l2.296 2.296a1.205 1.205 0 0 0 1.704 0l6.029-6.029a1 1 0 1 1 3 3l-6.029 6.029a1.205 1.205 0 0 0 0 1.704l2.296 2.296a1.205 1.205 0 0 0 1.704 0l6.365-6.367A1 1 0 0 0 8.716 4.282z',
    ), // key: nlhkjb
    IconPathElement('m5 8 4 4'), // key: j6kj7e
  ]);

  /// `mail-check.mjs`
  static const LucideGlyph mailCheck = LucideGlyph('mail-check', <IconElement>[
    IconPathElement(
      'M22 13V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h8',
    ), // key: 12jkf8
    IconPathElement('m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7'), // key: 1ocrg3
    IconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
  ]);

  /// `mail-minus.mjs`
  static const LucideGlyph mailMinus = LucideGlyph('mail-minus', <IconElement>[
    IconPathElement(
      'M22 15V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h8',
    ), // key: fuxbkv
    IconPathElement('m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7'), // key: 1ocrg3
    IconPathElement('M16 19h6'), // key: xwg31i
  ]);

  /// `mail-open.mjs`
  static const LucideGlyph mailOpen = LucideGlyph('mail-open', <IconElement>[
    IconPathElement(
      'M21.2 8.4c.5.38.8.97.8 1.6v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V10a2 2 0 0 1 .8-1.6l8-6a2 2 0 0 1 2.4 0l8 6Z',
    ), // key: 1jhwl8
    IconPathElement(
      'm22 10-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 10',
    ), // key: 1qfld7
  ]);

  /// `mail-plus.mjs`
  static const LucideGlyph mailPlus = LucideGlyph('mail-plus', <IconElement>[
    IconPathElement(
      'M22 13V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h8',
    ), // key: 12jkf8
    IconPathElement('m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7'), // key: 1ocrg3
    IconPathElement('M19 16v6'), // key: tddt3s
    IconPathElement('M16 19h6'), // key: xwg31i
  ]);

  /// `mail-question-mark.mjs`
  static const LucideGlyph
  mailQuestionMark = LucideGlyph('mail-question-mark', <IconElement>[
    IconPathElement(
      'M22 10.5V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h12.5',
    ), // key: e61zoh
    IconPathElement('m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7'), // key: 1ocrg3
    IconPathElement(
      'M18 15.28c.2-.4.5-.8.9-1a2.1 2.1 0 0 1 2.6.4c.3.4.5.8.5 1.3 0 1.3-2 2-2 2',
    ), // key: 7z9rxb
    IconPathElement('M20 22v.01'), // key: 12bgn6
  ]);

  /// `mail-search.mjs`
  static const LucideGlyph
  mailSearch = LucideGlyph('mail-search', <IconElement>[
    IconPathElement(
      'M22 12.5V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h7.5',
    ), // key: w80f2v
    IconPathElement('m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7'), // key: 1ocrg3
    IconPathElement('M18 21a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z'), // key: 8lzu5m
    IconCircleElement(18, 18, 3), // key: 1xkwt0
    IconPathElement('m22 22-1.5-1.5'), // key: 1x83k4
  ]);

  /// `mail-warning.mjs`
  static const LucideGlyph
  mailWarning = LucideGlyph('mail-warning', <IconElement>[
    IconPathElement(
      'M22 10.5V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h12.5',
    ), // key: e61zoh
    IconPathElement('m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7'), // key: 1ocrg3
    IconPathElement('M20 14v4'), // key: 1hm744
    IconPathElement('M20 22v.01'), // key: 12bgn6
  ]);

  /// `mail-x.mjs`
  static const LucideGlyph mailX = LucideGlyph('mail-x', <IconElement>[
    IconPathElement(
      'M22 13V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h9',
    ), // key: 1j9vog
    IconPathElement('m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7'), // key: 1ocrg3
    IconPathElement('m17 17 4 4'), // key: 1b3523
    IconPathElement('m21 17-4 4'), // key: uinynz
  ]);

  /// `mail.mjs`
  static const LucideGlyph mail = LucideGlyph('mail', <IconElement>[
    IconPathElement('m22 7-8.991 5.727a2 2 0 0 1-2.009 0L2 7'), // key: 132q7q
    IconRectElement(2, 4, 20, 16, 2), // key: izxlao
  ]);

  /// `mailbox.mjs`
  static const LucideGlyph mailbox = LucideGlyph('mailbox', <IconElement>[
    IconPathElement(
      'M22 17a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V9.5C2 7 4 5 6.5 5H18c2.2 0 4 1.8 4 4v8Z',
    ), // key: 1lbycx
    IconPolylineElement(<Offset>[
      Offset(15, 9),
      Offset(18, 9),
      Offset(18, 11),
    ]), // key: 1pm9c0
    IconPathElement('M6.5 5C9 5 11 7 11 9.5V17a2 2 0 0 1-2 2'), // key: 15i455
    IconLineElement(6, 10, 7, 10), // key: 1e2scm
  ]);

  /// `mails.mjs`
  static const LucideGlyph mails = LucideGlyph('mails', <IconElement>[
    IconPathElement(
      'M17 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-8a2 2 0 0 1 1-1.732',
    ), // key: 1vyzll
    IconPathElement(
      'm22 5.5-6.419 4.179a2 2 0 0 1-2.162 0L7 5.5',
    ), // key: k7ramc
    IconRectElement(7, 3, 15, 12, 2), // key: 17196g
  ]);

  /// `map-minus.mjs`
  static const LucideGlyph mapMinus = LucideGlyph('map-minus', <IconElement>[
    IconPathElement(
      'm11 19-1.106-.552a2 2 0 0 0-1.788 0l-3.659 1.83A1 1 0 0 1 3 19.381V6.618a1 1 0 0 1 .553-.894l4.553-2.277a2 2 0 0 1 1.788 0l4.212 2.106a2 2 0 0 0 1.788 0l3.659-1.83A1 1 0 0 1 21 4.619V14',
    ), // key: 40pylx
    IconPathElement('M15 5.764V14'), // key: 1bab71
    IconPathElement('M21 18h-6'), // key: 139f0c
    IconPathElement('M9 3.236v15'), // key: 1uimfh
  ]);

  /// `map-pin-check-inside.mjs`
  static const LucideGlyph
  mapPinCheckInside = LucideGlyph('map-pin-check-inside', <IconElement>[
    IconPathElement(
      'M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0',
    ), // key: 1r0f0z
    IconPathElement('m9 10 2 2 4-4'), // key: 1gnqz4
  ]);

  /// `map-pin-check.mjs`
  static const LucideGlyph
  mapPinCheck = LucideGlyph('map-pin-check', <IconElement>[
    IconPathElement(
      'M19.43 12.935c.357-.967.57-1.955.57-2.935a8 8 0 0 0-16 0c0 4.993 5.539 10.193 7.399 11.799a1 1 0 0 0 1.202 0 32.197 32.197 0 0 0 .813-.728',
    ), // key: 1dq61d
    IconCircleElement(12, 10, 3), // key: ilqhr7
    IconPathElement('m16 18 2 2 4-4'), // key: 1mkfmb
  ]);

  /// `map-pin-house.mjs`
  static const LucideGlyph
  mapPinHouse = LucideGlyph('map-pin-house', <IconElement>[
    IconPathElement(
      'M15 22a1 1 0 0 1-1-1v-4a1 1 0 0 1 .445-.832l3-2a1 1 0 0 1 1.11 0l3 2A1 1 0 0 1 22 17v4a1 1 0 0 1-1 1z',
    ), // key: 1p1rcz
    IconPathElement(
      'M18 10a8 8 0 0 0-16 0c0 4.993 5.539 10.193 7.399 11.799a1 1 0 0 0 .601.2',
    ), // key: mcbcs9
    IconPathElement('M18 22v-3'), // key: 1t1ugv
    IconCircleElement(10, 10, 3), // key: 1ns7v1
  ]);

  /// `map-pin-minus-inside.mjs`
  static const LucideGlyph
  mapPinMinusInside = LucideGlyph('map-pin-minus-inside', <IconElement>[
    IconPathElement(
      'M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0',
    ), // key: 1r0f0z
    IconPathElement('M9 10h6'), // key: 9gxzsh
  ]);

  /// `map-pin-minus.mjs`
  static const LucideGlyph
  mapPinMinus = LucideGlyph('map-pin-minus', <IconElement>[
    IconPathElement(
      'M18.977 14C19.6 12.701 20 11.343 20 10a8 8 0 0 0-16 0c0 4.993 5.539 10.193 7.399 11.799a1 1 0 0 0 1.202 0 32 32 0 0 0 .824-.738',
    ), // key: 11uxia
    IconCircleElement(12, 10, 3), // key: ilqhr7
    IconPathElement('M16 18h6'), // key: 987eiv
  ]);

  /// `map-pin-off.mjs`
  static const LucideGlyph mapPinOff = LucideGlyph('map-pin-off', <IconElement>[
    IconPathElement('M12.75 7.09a3 3 0 0 1 2.16 2.16'), // key: 1d4wjd
    IconPathElement(
      'M17.072 17.072c-1.634 2.17-3.527 3.912-4.471 4.727a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 1.432-4.568',
    ), // key: 12yil7
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement(
      'M8.475 2.818A8 8 0 0 1 20 10c0 1.183-.31 2.377-.81 3.533',
    ), // key: lhrkcz
    IconPathElement('M9.13 9.13a3 3 0 0 0 3.74 3.74'), // key: 13wojd
  ]);

  /// `map-pin-pen.mjs`
  static const LucideGlyph mapPinPen = LucideGlyph('map-pin-pen', <IconElement>[
    IconPathElement(
      'M17.97 9.304A8 8 0 0 0 2 10c0 4.69 4.887 9.562 7.022 11.468',
    ), // key: 1fahp3
    IconPathElement(
      'M21.378 16.626a1 1 0 0 0-3.004-3.004l-4.01 4.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z',
    ), // key: 1817ys
    IconCircleElement(10, 10, 3), // key: 1ns7v1
  ]);

  /// `map-pin-plus-inside.mjs`
  static const LucideGlyph
  mapPinPlusInside = LucideGlyph('map-pin-plus-inside', <IconElement>[
    IconPathElement(
      'M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0',
    ), // key: 1r0f0z
    IconPathElement('M12 7v6'), // key: lw1j43
    IconPathElement('M9 10h6'), // key: 9gxzsh
  ]);

  /// `map-pin-plus.mjs`
  static const LucideGlyph
  mapPinPlus = LucideGlyph('map-pin-plus', <IconElement>[
    IconPathElement(
      'M19.914 11.105A7.298 7.298 0 0 0 20 10a8 8 0 0 0-16 0c0 4.993 5.539 10.193 7.399 11.799a1 1 0 0 0 1.202 0 32 32 0 0 0 .824-.738',
    ), // key: fcdtly
    IconCircleElement(12, 10, 3), // key: ilqhr7
    IconPathElement('M16 18h6'), // key: 987eiv
    IconPathElement('M19 15v6'), // key: 10aioa
  ]);

  /// `map-pin-search.mjs`
  static const LucideGlyph
  mapPinSearch = LucideGlyph('map-pin-search', <IconElement>[
    IconPathElement(
      'M 12.248 21.969 a 1 1 0 0 1 -0.849 -0.17 C 9.539 20.193 4 14.993 4 10 a 8 8 0 0 1 16 0 C 20 10.42 19.961 10.841 19.888 11.262',
    ), // key: 1jho5b
    IconPathElement('m22 22-1.88-1.88'), // key: 1bgjp0
    IconCircleElement(12, 10, 3), // key: ilqhr7
    IconCircleElement(18, 18, 3), // key: 1xkwt0
  ]);

  /// `map-pin-x-inside.mjs`
  static const LucideGlyph
  mapPinXInside = LucideGlyph('map-pin-x-inside', <IconElement>[
    IconPathElement(
      'M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0',
    ), // key: 1r0f0z
    IconPathElement('m14.5 7.5-5 5'), // key: 3lb6iw
    IconPathElement('m9.5 7.5 5 5'), // key: ko136h
  ]);

  /// `map-pin-x.mjs`
  static const LucideGlyph mapPinX = LucideGlyph('map-pin-x', <IconElement>[
    IconPathElement(
      'M19.752 11.901A7.78 7.78 0 0 0 20 10a8 8 0 0 0-16 0c0 4.993 5.539 10.193 7.399 11.799a1 1 0 0 0 1.202 0 19 19 0 0 0 .09-.077',
    ), // key: y0ewhp
    IconCircleElement(12, 10, 3), // key: ilqhr7
    IconPathElement('m21.5 15.5-5 5'), // key: 11iqnx
    IconPathElement('m21.5 20.5-5-5'), // key: 1bylgx
  ]);

  /// `map-pin.mjs`
  static const LucideGlyph mapPin = LucideGlyph('map-pin', <IconElement>[
    IconPathElement(
      'M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0',
    ), // key: 1r0f0z
    IconCircleElement(12, 10, 3), // key: ilqhr7
  ]);

  /// `map-pinned.mjs`
  static const LucideGlyph mapPinned = LucideGlyph('map-pinned', <IconElement>[
    IconPathElement(
      'M18 8c0 3.613-3.869 7.429-5.393 8.795a1 1 0 0 1-1.214 0C9.87 15.429 6 11.613 6 8a6 6 0 0 1 12 0',
    ), // key: 11u0oz
    IconCircleElement(12, 8, 2), // key: 1822b1
    IconPathElement(
      'M8.714 14h-3.71a1 1 0 0 0-.948.683l-2.004 6A1 1 0 0 0 3 22h18a1 1 0 0 0 .948-1.316l-2-6a1 1 0 0 0-.949-.684h-3.712',
    ), // key: q8zwxj
  ]);

  /// `map-plus.mjs`
  static const LucideGlyph mapPlus = LucideGlyph('map-plus', <IconElement>[
    IconPathElement(
      'm11 19-1.106-.552a2 2 0 0 0-1.788 0l-3.659 1.83A1 1 0 0 1 3 19.381V6.618a1 1 0 0 1 .553-.894l4.553-2.277a2 2 0 0 1 1.788 0l4.212 2.106a2 2 0 0 0 1.788 0l3.659-1.83A1 1 0 0 1 21 4.619V12',
    ), // key: svfegj
    IconPathElement('M15 5.764V12'), // key: 1ocw4k
    IconPathElement('M18 15v6'), // key: 9wciyi
    IconPathElement('M21 18h-6'), // key: 139f0c
    IconPathElement('M9 3.236v15'), // key: 1uimfh
  ]);

  /// `map.mjs`
  static const LucideGlyph map = LucideGlyph('map', <IconElement>[
    IconPathElement(
      'M14.106 5.553a2 2 0 0 0 1.788 0l3.659-1.83A1 1 0 0 1 21 4.619v12.764a1 1 0 0 1-.553.894l-4.553 2.277a2 2 0 0 1-1.788 0l-4.212-2.106a2 2 0 0 0-1.788 0l-3.659 1.83A1 1 0 0 1 3 19.381V6.618a1 1 0 0 1 .553-.894l4.553-2.277a2 2 0 0 1 1.788 0z',
    ), // key: 169xi5
    IconPathElement('M15 5.764v15'), // key: 1pn4in
    IconPathElement('M9 3.236v15'), // key: 1uimfh
  ]);

  /// `mars-stroke.mjs`
  static const LucideGlyph marsStroke = LucideGlyph(
    'mars-stroke',
    <IconElement>[
      IconPathElement('m14 6 4 4'), // key: 1q72g9
      IconPathElement('M17 3h4v4'), // key: 19p9u1
      IconPathElement('m21 3-7.75 7.75'), // key: 1cjbfd
      IconCircleElement(9, 15, 6), // key: bx5svt
    ],
  );

  /// `mars.mjs`
  static const LucideGlyph mars = LucideGlyph('mars', <IconElement>[
    IconPathElement('M16 3h5v5'), // key: 1806ms
    IconPathElement('m21 3-6.75 6.75'), // key: pv0uzu
    IconCircleElement(10, 14, 6), // key: 1qwbdc
  ]);

  /// `martini.mjs`
  static const LucideGlyph martini = LucideGlyph('martini', <IconElement>[
    IconPathElement(
      'M12 12 4.207 4.207A.707.707 0 0 1 4.707 3h14.586a.707.707 0 0 1 .5 1.207z',
    ), // key: vxdekd
    IconPathElement('M12 12v10'), // key: 1nesaz
    IconPathElement('M7 22h10'), // key: 10w4w3
  ]);

  /// `maximize-2.mjs`
  static const LucideGlyph maximize2 = LucideGlyph('maximize-2', <IconElement>[
    IconPathElement('M15 3h6v6'), // key: 1q9fwt
    IconPathElement('m21 3-7 7'), // key: 1l2asr
    IconPathElement('m3 21 7-7'), // key: tjx5ai
    IconPathElement('M9 21H3v-6'), // key: wtvkvv
  ]);

  /// `maximize.mjs`
  static const LucideGlyph maximize = LucideGlyph('maximize', <IconElement>[
    IconPathElement('M8 3H5a2 2 0 0 0-2 2v3'), // key: 1dcmit
    IconPathElement('M21 8V5a2 2 0 0 0-2-2h-3'), // key: 1e4gt3
    IconPathElement('M3 16v3a2 2 0 0 0 2 2h3'), // key: wsl5sc
    IconPathElement('M16 21h3a2 2 0 0 0 2-2v-3'), // key: 18trek
  ]);

  /// `medal.mjs`
  static const LucideGlyph medal = LucideGlyph('medal', <IconElement>[
    IconPathElement(
      'M7.21 15 2.66 7.14a2 2 0 0 1 .13-2.2L4.4 2.8A2 2 0 0 1 6 2h12a2 2 0 0 1 1.6.8l1.6 2.14a2 2 0 0 1 .14 2.2L16.79 15',
    ), // key: 143lza
    IconPathElement('M11 12 5.12 2.2'), // key: qhuxz6
    IconPathElement('m13 12 5.88-9.8'), // key: hbye0f
    IconPathElement('M8 7h8'), // key: i86dvs
    IconCircleElement(12, 17, 5), // key: qbz8iq
    IconPathElement('M12 18v-2h-.5'), // key: fawc4q
  ]);

  /// `megaphone-off.mjs`
  static const LucideGlyph megaphoneOff = LucideGlyph(
    'megaphone-off',
    <IconElement>[
      IconPathElement(
        'M11.636 6A13 13 0 0 0 19.4 3.2 1 1 0 0 1 21 4v11.344',
      ), // key: bycexp
      IconPathElement(
        'M14.378 14.357A13 13 0 0 0 11 14H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h1',
      ), // key: 1t17s6
      IconPathElement('m2 2 20 20'), // key: 1ooewy
      IconPathElement(
        'M6 14a12 12 0 0 0 2.4 7.2 2 2 0 0 0 3.2-2.4A8 8 0 0 1 10 14',
      ), // key: 1853fq
      IconPathElement('M8 8v6'), // key: aieo6v
    ],
  );

  /// `megaphone.mjs`
  static const LucideGlyph megaphone = LucideGlyph('megaphone', <IconElement>[
    IconPathElement(
      'M11 6a13 13 0 0 0 8.4-2.8A1 1 0 0 1 21 4v12a1 1 0 0 1-1.6.8A13 13 0 0 0 11 14H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2z',
    ), // key: q8bfy3
    IconPathElement(
      'M6 14a12 12 0 0 0 2.4 7.2 2 2 0 0 0 3.2-2.4A8 8 0 0 1 10 14',
    ), // key: 1853fq
    IconPathElement('M8 6v8'), // key: 15ugcq
  ]);

  /// `meh.mjs`
  static const LucideGlyph meh = LucideGlyph('meh', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconLineElement(8, 15, 16, 15), // key: 1xb1d9
    IconLineElement(9, 9, 9.01, 9), // key: yxxnd0
    IconLineElement(15, 9, 15.01, 9), // key: 1p4y9e
  ]);

  /// `memory-stick.mjs`
  static const LucideGlyph memoryStick = LucideGlyph(
    'memory-stick',
    <IconElement>[
      IconPathElement('M12 12v-2'), // key: fwoke6
      IconPathElement('M12 18v-2'), // key: qj6yno
      IconPathElement('M16 12v-2'), // key: heuere
      IconPathElement('M16 18v-2'), // key: s1ct0w
      IconPathElement('M2 11h1.5'), // key: 15p63e
      IconPathElement('M20 18v-2'), // key: 12ehxp
      IconPathElement('M20.5 11H22'), // key: khsy7a
      IconPathElement('M4 18v-2'), // key: 1c3oqr
      IconPathElement('M8 12v-2'), // key: 1mwtfd
      IconPathElement('M8 18v-2'), // key: qcmpov
      IconRectElement(2, 6, 20, 10, 2), // key: 1qcswk
    ],
  );

  /// `menu.mjs`
  static const LucideGlyph menu = LucideGlyph('menu', <IconElement>[
    IconPathElement('M4 5h16'), // key: 1tepv9
    IconPathElement('M4 12h16'), // key: 1lakjw
    IconPathElement('M4 19h16'), // key: 1djgab
  ]);

  /// `merge.mjs`
  static const LucideGlyph merge = LucideGlyph('merge', <IconElement>[
    IconPathElement('m8 6 4-4 4 4'), // key: ybng9g
    IconPathElement('M12 2v10.3a4 4 0 0 1-1.172 2.872L4 22'), // key: 1hyw0i
    IconPathElement('m20 22-5-5'), // key: 1m27yz
  ]);

  /// `message-circle-check.mjs`
  static const LucideGlyph
  messageCircleCheck = LucideGlyph('message-circle-check', <IconElement>[
    IconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
    IconPathElement('m9 12 2 2 4-4'), // key: dzmm74
  ]);

  /// `message-circle-code.mjs`
  static const LucideGlyph
  messageCircleCode = LucideGlyph('message-circle-code', <IconElement>[
    IconPathElement('m10 9-3 3 3 3'), // key: 1oro0q
    IconPathElement('m14 15 3-3-3-3'), // key: bz13h7
    IconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
  ]);

  /// `message-circle-dashed.mjs`
  static const LucideGlyph messageCircleDashed = LucideGlyph(
    'message-circle-dashed',
    <IconElement>[
      IconPathElement('M10.1 2.182a10 10 0 0 1 3.8 0'), // key: 5ilxe3
      IconPathElement('M13.9 21.818a10 10 0 0 1-3.8 0'), // key: 11zvb9
      IconPathElement('M17.609 3.72a10 10 0 0 1 2.69 2.7'), // key: jiglxs
      IconPathElement('M2.182 13.9a10 10 0 0 1 0-3.8'), // key: c0bmvh
      IconPathElement('M20.28 17.61a10 10 0 0 1-2.7 2.69'), // key: elg7ff
      IconPathElement('M21.818 10.1a10 10 0 0 1 0 3.8'), // key: qkgqxc
      IconPathElement('M3.721 6.391a10 10 0 0 1 2.7-2.69'), // key: 1mcia2
      IconPathElement(
        'm6.163 21.117-2.906.85a1 1 0 0 1-1.236-1.169l.965-2.98',
      ), // key: 1qsu07
    ],
  );

  /// `message-circle-heart.mjs`
  static const LucideGlyph
  messageCircleHeart = LucideGlyph('message-circle-heart', <IconElement>[
    IconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
    IconPathElement(
      'M7.828 13.07A3 3 0 0 1 12 8.764a3 3 0 0 1 5.004 2.224 3 3 0 0 1-.832 2.083l-3.447 3.62a1 1 0 0 1-1.45-.001z',
    ), // key: hoo97p
  ]);

  /// `message-circle-more.mjs`
  static const LucideGlyph
  messageCircleMore = LucideGlyph('message-circle-more', <IconElement>[
    IconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
    IconPathElement('M8 12h.01'), // key: czm47f
    IconPathElement('M12 12h.01'), // key: 1mp3jc
    IconPathElement('M16 12h.01'), // key: 1l6xoz
  ]);

  /// `message-circle-off.mjs`
  static const LucideGlyph
  messageCircleOff = LucideGlyph('message-circle-off', <IconElement>[
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement(
      'M4.93 4.929a10 10 0 0 0-1.938 11.412 2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 0 0 11.302-1.989',
    ), // key: 7il5tn
    IconPathElement('M8.35 2.69A10 10 0 0 1 21.3 15.65'), // key: 1pfsoa
  ]);

  /// `message-circle-plus.mjs`
  static const LucideGlyph
  messageCirclePlus = LucideGlyph('message-circle-plus', <IconElement>[
    IconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
    IconPathElement('M8 12h8'), // key: 1wcyev
    IconPathElement('M12 8v8'), // key: napkw2
  ]);

  /// `message-circle-question-mark.mjs`
  static const LucideGlyph
  messageCircleQuestionMark = LucideGlyph('message-circle-question-mark', <
    IconElement
  >[
    IconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
    IconPathElement('M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3'), // key: 1u773s
    IconPathElement('M12 17h.01'), // key: p32p05
  ]);

  /// `message-circle-reply.mjs`
  static const LucideGlyph
  messageCircleReply = LucideGlyph('message-circle-reply', <IconElement>[
    IconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
    IconPathElement('m10 15-3-3 3-3'), // key: 1pgupc
    IconPathElement('M7 12h8a2 2 0 0 1 2 2v1'), // key: 89sh1g
  ]);

  /// `message-circle-warning.mjs`
  static const LucideGlyph
  messageCircleWarning = LucideGlyph('message-circle-warning', <IconElement>[
    IconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
    IconPathElement('M12 8v4'), // key: 1got3b
    IconPathElement('M12 16h.01'), // key: 1drbdi
  ]);

  /// `message-circle-x.mjs`
  static const LucideGlyph
  messageCircleX = LucideGlyph('message-circle-x', <IconElement>[
    IconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
    IconPathElement('m15 9-6 6'), // key: 1uzhvr
    IconPathElement('m9 9 6 6'), // key: z0biqf
  ]);

  /// `message-circle.mjs`
  static const LucideGlyph
  messageCircle = LucideGlyph('message-circle', <IconElement>[
    IconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
  ]);

  /// `message-square-check.mjs`
  static const LucideGlyph
  messageSquareCheck = LucideGlyph('message-square-check', <IconElement>[
    IconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.7.7 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: m0kn7k
    IconPathElement('m9 11 2 2 4-4'), // key: kz4plv
  ]);

  /// `message-square-code.mjs`
  static const LucideGlyph
  messageSquareCode = LucideGlyph('message-square-code', <IconElement>[
    IconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    IconPathElement('m10 8-3 3 3 3'), // key: fp6dz7
    IconPathElement('m14 14 3-3-3-3'), // key: 1yrceu
  ]);

  /// `message-square-dashed.mjs`
  static const LucideGlyph messageSquareDashed = LucideGlyph(
    'message-square-dashed',
    <IconElement>[
      IconPathElement('M14 3h2'), // key: 1d12a5
      IconPathElement('M16 19h-2'), // key: 1agirb
      IconPathElement('M2 12v-2'), // key: 1ey295
      IconPathElement(
        'M2 16v5.286a.71.71 0 0 0 1.212.502l1.149-1.149',
      ), // key: 120k8q
      IconPathElement('M20 19a2 2 0 0 0 2-2v-1'), // key: ior8tn
      IconPathElement('M22 10v2'), // key: rmlecy
      IconPathElement('M22 6V5a2 2 0 0 0-2-2'), // key: sp3k6r
      IconPathElement('M4 3a2 2 0 0 0-2 2v1'), // key: 11zt7s
      IconPathElement('M8 19h2'), // key: jnunrx
      IconPathElement('M8 3h2'), // key: ysbsee
    ],
  );

  /// `message-square-diff.mjs`
  static const LucideGlyph
  messageSquareDiff = LucideGlyph('message-square-diff', <IconElement>[
    IconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    IconPathElement('M10 15h4'), // key: 192ueg
    IconPathElement('M10 9h4'), // key: u4k05v
    IconPathElement('M12 7v4'), // key: xawao1
  ]);

  /// `message-square-dot.mjs`
  static const LucideGlyph
  messageSquareDot = LucideGlyph('message-square-dot', <IconElement>[
    IconPathElement(
      'M12.7 3H4a2 2 0 0 0-2 2v16.286a.71.71 0 0 0 1.212.502l2.202-2.202A2 2 0 0 1 6.828 19H20a2 2 0 0 0 2-2v-4.7',
    ), // key: wjb7ig
    IconCircleElement(19, 6, 3), // key: 108a5v
  ]);

  /// `message-square-heart.mjs`
  static const LucideGlyph
  messageSquareHeart = LucideGlyph('message-square-heart', <IconElement>[
    IconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    IconPathElement(
      'M7.5 9.5c0 .687.265 1.383.697 1.844l3.009 3.264a1.14 1.14 0 0 0 .407.314 1 1 0 0 0 .783-.004 1.14 1.14 0 0 0 .398-.31l3.008-3.264A2.77 2.77 0 0 0 16.5 9.5 2.5 2.5 0 0 0 12 8a2.5 2.5 0 0 0-4.5 1.5',
    ), // key: 1faxuh
  ]);

  /// `message-square-lock.mjs`
  static const LucideGlyph
  messageSquareLock = LucideGlyph('message-square-lock', <IconElement>[
    IconPathElement(
      'M22 8.5V5a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v16.286a.71.71 0 0 0 1.212.502l2.202-2.202A2 2 0 0 1 6.828 19H10',
    ), // key: fu6chl
    IconPathElement('M20 15v-2a2 2 0 0 0-4 0v2'), // key: vl8a78
    IconRectElement(14, 15, 8, 5, 1), // key: 37aafw
  ]);

  /// `message-square-more.mjs`
  static const LucideGlyph
  messageSquareMore = LucideGlyph('message-square-more', <IconElement>[
    IconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    IconPathElement('M12 11h.01'), // key: z322tv
    IconPathElement('M16 11h.01'), // key: xkw8gn
    IconPathElement('M8 11h.01'), // key: 1dfujw
  ]);

  /// `message-square-off.mjs`
  static const LucideGlyph
  messageSquareOff = LucideGlyph('message-square-off', <IconElement>[
    IconPathElement(
      'M19 19H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.7.7 0 0 1 2 21.286V5a2 2 0 0 1 1.184-1.826',
    ), // key: 1wyg69
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement('M8.656 3H20a2 2 0 0 1 2 2v11.344'), // key: mhl4k6
  ]);

  /// `message-square-plus.mjs`
  static const LucideGlyph
  messageSquarePlus = LucideGlyph('message-square-plus', <IconElement>[
    IconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    IconPathElement('M12 8v6'), // key: 1ib9pf
    IconPathElement('M9 11h6'), // key: 1fldmi
  ]);

  /// `message-square-quote.mjs`
  static const LucideGlyph
  messageSquareQuote = LucideGlyph('message-square-quote', <IconElement>[
    IconPathElement('M14 14a2 2 0 0 0 2-2V8h-2'), // key: 1r06pg
    IconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    IconPathElement('M8 14a2 2 0 0 0 2-2V8H8'), // key: 1jzu5j
  ]);

  /// `message-square-reply.mjs`
  static const LucideGlyph
  messageSquareReply = LucideGlyph('message-square-reply', <IconElement>[
    IconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    IconPathElement('m10 8-3 3 3 3'), // key: fp6dz7
    IconPathElement('M17 14v-1a2 2 0 0 0-2-2H7'), // key: 1tkjnz
  ]);

  /// `message-square-share.mjs`
  static const LucideGlyph
  messageSquareShare = LucideGlyph('message-square-share', <IconElement>[
    IconPathElement(
      'M12 3H4a2 2 0 0 0-2 2v16.286a.71.71 0 0 0 1.212.502l2.202-2.202A2 2 0 0 1 6.828 19H20a2 2 0 0 0 2-2v-4',
    ), // key: 11da1y
    IconPathElement('M16 3h6v6'), // key: 1bx56c
    IconPathElement('m16 9 6-6'), // key: m4dnic
  ]);

  /// `message-square-text.mjs`
  static const LucideGlyph
  messageSquareText = LucideGlyph('message-square-text', <IconElement>[
    IconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    IconPathElement('M7 11h10'), // key: 1twpyw
    IconPathElement('M7 15h6'), // key: d9of3u
    IconPathElement('M7 7h8'), // key: af5zfr
  ]);

  /// `message-square-warning.mjs`
  static const LucideGlyph
  messageSquareWarning = LucideGlyph('message-square-warning', <IconElement>[
    IconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    IconPathElement('M12 15h.01'), // key: q59x07
    IconPathElement('M12 7v4'), // key: xawao1
  ]);

  /// `message-square-x.mjs`
  static const LucideGlyph
  messageSquareX = LucideGlyph('message-square-x', <IconElement>[
    IconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    IconPathElement('m14.5 8.5-5 5'), // key: 19tnj2
    IconPathElement('m9.5 8.5 5 5'), // key: 1oa8ql
  ]);

  /// `message-square.mjs`
  static const LucideGlyph
  messageSquare = LucideGlyph('message-square', <IconElement>[
    IconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
  ]);

  /// `messages-square.mjs`
  static const LucideGlyph
  messagesSquare = LucideGlyph('messages-square', <IconElement>[
    IconPathElement(
      'M16 10a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 14.286V4a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z',
    ), // key: 1n2ejm
    IconPathElement(
      'M20 9a2 2 0 0 1 2 2v10.286a.71.71 0 0 1-1.212.502l-2.202-2.202A2 2 0 0 0 17.172 19H10a2 2 0 0 1-2-2v-1',
    ), // key: 1qfcsi
  ]);

  /// `metronome.mjs`
  static const LucideGlyph metronome = LucideGlyph('metronome', <IconElement>[
    IconPathElement('M12 11.4V9.1'), // key: audfby
    IconPathElement('m12 17 6.59-6.59'), // key: c0sb7j
    IconPathElement(
      'm15.05 5.7-.218-.691a3 3 0 0 0-5.663 0L4.418 19.695A1 1 0 0 0 5.37 21h13.253a1 1 0 0 0 .951-1.31L18.45 16.2',
    ), // key: 1pkfrk
    IconCircleElement(20, 9, 2), // key: 1udoqf
  ]);

  /// `mic-audio-lines.mjs`
  static const LucideGlyph micAudioLines = LucideGlyph(
    'mic-audio-lines',
    <IconElement>[
      IconPathElement('M10 3v2.341'), // key: d00509
      IconPathElement('M12 17v4'), // key: 1riwvh
      IconPathElement('M14 5v.341'), // key: 72nt6x
      IconPathElement('M18 5v13'), // key: 123xd1
      IconPathElement('M2 10v3'), // key: 1fnikh
      IconPathElement('M22 10v3'), // key: 154ddg
      IconPathElement('M6 6v11'), // key: 11sgs0
      IconPathElement('M9 21h6'), // key: 1udhl7
      IconRectElement(10, 9, 4, 8, 2), // key: 1d9qhd
    ],
  );

  /// `mic-off.mjs`
  static const LucideGlyph micOff = LucideGlyph('mic-off', <IconElement>[
    IconPathElement('M12 19v3'), // key: npa21l
    IconPathElement('M15 9.34V5a3 3 0 0 0-5.68-1.33'), // key: 1gzdoj
    IconPathElement('M16.95 16.95A7 7 0 0 1 5 12v-2'), // key: cqa7eg
    IconPathElement('M18.89 13.23A7 7 0 0 0 19 12v-2'), // key: 16hl24
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement('M9 9v3a3 3 0 0 0 5.12 2.12'), // key: r2i35w
  ]);

  /// `mic-signal.mjs`
  static const LucideGlyph micSignal = LucideGlyph('mic-signal', <IconElement>[
    IconPathElement('M12 17v4'), // key: 1riwvh
    IconPathElement('M18 11a6 6 0 00-3-5.197'), // key: 1lvu40
    IconPathElement('M2 11a10 10 0 015-8.662'), // key: bida4p
    IconPathElement('M22 11a10 10 0 00-5-8.662'), // key: idvinr
    IconPathElement('M6 11a6 6 0 013-5.197'), // key: 17n2ii
    IconPathElement('M9 21h6'), // key: 1udhl7
    IconRectElement(10, 9, 4, 8, 2), // key: 1l8p2f
  ]);

  /// `mic-vocal.mjs`
  static const LucideGlyph micVocal = LucideGlyph('mic-vocal', <IconElement>[
    IconPathElement(
      'm11 7.601-5.994 8.19a1 1 0 0 0 .1 1.298l.817.818a1 1 0 0 0 1.314.087L15.09 12',
    ), // key: 80a601
    IconPathElement(
      'M16.5 21.174C15.5 20.5 14.372 20 13 20c-2.058 0-3.928 2.356-6 2-2.072-.356-2.775-3.369-1.5-4.5',
    ), // key: j0ngtp
    IconCircleElement(16, 7, 5), // key: d08jfb
  ]);

  /// `mic.mjs`
  static const LucideGlyph mic = LucideGlyph('mic', <IconElement>[
    IconPathElement('M12 19v3'), // key: npa21l
    IconPathElement('M19 10v2a7 7 0 0 1-14 0v-2'), // key: 1vc78b
    IconRectElement(9, 2, 6, 13, 3), // key: s6n7sd
  ]);

  /// `microchip.mjs`
  static const LucideGlyph microchip = LucideGlyph('microchip', <IconElement>[
    IconPathElement('M10 12h4'), // key: a56b0p
    IconPathElement('M10 17h4'), // key: pvmtpo
    IconPathElement('M10 7h4'), // key: 1vgcok
    IconPathElement('M18 12h2'), // key: quuxs7
    IconPathElement('M18 18h2'), // key: 4scel
    IconPathElement('M18 6h2'), // key: 1ptzki
    IconPathElement('M4 12h2'), // key: 1ltxp0
    IconPathElement('M4 18h2'), // key: 1xrofg
    IconPathElement('M4 6h2'), // key: 1cx33n
    IconRectElement(6, 2, 12, 20, 2), // key: 749fme
  ]);

  /// `microscope.mjs`
  static const LucideGlyph microscope = LucideGlyph('microscope', <IconElement>[
    IconPathElement('M6 18h8'), // key: 1borvv
    IconPathElement('M3 22h18'), // key: 8prr45
    IconPathElement('M14 22a7 7 0 1 0 0-14h-1'), // key: 1jwaiy
    IconPathElement('M9 14h2'), // key: 197e7h
    IconPathElement('M9 12a2 2 0 0 1-2-2V6h6v4a2 2 0 0 1-2 2Z'), // key: 1bmzmy
    IconPathElement('M12 6V3a1 1 0 0 0-1-1H9a1 1 0 0 0-1 1v3'), // key: 1drr47
  ]);

  /// `microwave.mjs`
  static const LucideGlyph microwave = LucideGlyph('microwave', <IconElement>[
    IconRectElement(2, 4, 20, 15, 2), // key: 2no95f
    IconRectElement(6, 8, 8, 7, 1), // key: zh9wx
    IconPathElement('M18 8v7'), // key: o5zi4n
    IconPathElement('M6 19v2'), // key: 1loha6
    IconPathElement('M18 19v2'), // key: 1dawf0
  ]);

  /// `milestone.mjs`
  static const LucideGlyph milestone = LucideGlyph('milestone', <IconElement>[
    IconPathElement('M12 13v8'), // key: 1l5pq0
    IconPathElement('M12 3v3'), // key: 1n5kay
    IconPathElement(
      'M18.172 6a2 2 0 0 1 1.414.586l2.06 2.06a1.207 1.207 0 0 1 0 1.708l-2.06 2.06a2 2 0 0 1-1.414.586H4a1 1 0 0 1-1-1V7a1 1 0 0 1 1-1z',
    ), // key: 8gz4t4
  ]);

  /// `milk-off.mjs`
  static const LucideGlyph milkOff = LucideGlyph('milk-off', <IconElement>[
    IconPathElement('M8 2h8'), // key: 1ssgc1
    IconPathElement(
      'M9 2v1.343M15 2v2.789a4 4 0 0 0 .672 2.219l.656.984a4 4 0 0 1 .672 2.22v1.131M7.8 7.8l-.128.192A4 4 0 0 0 7 10.212V20a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2v-3',
    ), // key: y0ejgx
    IconPathElement(
      'M7 15a6.47 6.47 0 0 1 5 0 6.472 6.472 0 0 0 3.435.435',
    ), // key: iaxqsy
    IconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `milk.mjs`
  static const LucideGlyph milk = LucideGlyph('milk', <IconElement>[
    IconPathElement('M8 2h8'), // key: 1ssgc1
    IconPathElement(
      'M9 2v2.789a4 4 0 0 1-.672 2.219l-.656.984A4 4 0 0 0 7 10.212V20a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2v-9.789a4 4 0 0 0-.672-2.219l-.656-.984A4 4 0 0 1 15 4.788V2',
    ), // key: qtp12x
    IconPathElement(
      'M7 15a6.472 6.472 0 0 1 5 0 6.47 6.47 0 0 0 5 0',
    ), // key: ygeh44
  ]);

  /// `minimize-2.mjs`
  static const LucideGlyph minimize2 = LucideGlyph('minimize-2', <IconElement>[
    IconPathElement('m14 10 7-7'), // key: oa77jy
    IconPathElement('M20 10h-6V4'), // key: mjg0md
    IconPathElement('m3 21 7-7'), // key: tjx5ai
    IconPathElement('M4 14h6v6'), // key: rmj7iw
  ]);

  /// `minimize.mjs`
  static const LucideGlyph minimize = LucideGlyph('minimize', <IconElement>[
    IconPathElement('M8 3v3a2 2 0 0 1-2 2H3'), // key: hohbtr
    IconPathElement('M21 8h-3a2 2 0 0 1-2-2V3'), // key: 5jw1f3
    IconPathElement('M3 16h3a2 2 0 0 1 2 2v3'), // key: 198tvr
    IconPathElement('M16 21v-3a2 2 0 0 1 2-2h3'), // key: ph8mxp
  ]);

  /// `minus.mjs`
  static const LucideGlyph minus = LucideGlyph('minus', <IconElement>[
    IconPathElement('M5 12h14'), // key: 1ays0h
  ]);

  /// `mirror-rectangular.mjs`
  static const LucideGlyph mirrorRectangular = LucideGlyph(
    'mirror-rectangular',
    <IconElement>[
      IconPathElement('M11 6 8 9'), // key: 7zt14w
      IconPathElement('m16 7-8 8'), // key: tkgtvu
      IconRectElement(4, 2, 16, 20, 2), // key: 1uxh74
    ],
  );

  /// `mirror-round.mjs`
  static const LucideGlyph mirrorRound = LucideGlyph(
    'mirror-round',
    <IconElement>[
      IconPathElement('M10 6.6 8.6 8'), // key: itrr7k
      IconPathElement('M12 18v4'), // key: jadmvz
      IconPathElement('M15 7.5 9.5 13'), // key: 1vyrsv
      IconPathElement('M7 22h10'), // key: 10w4w3
      IconCircleElement(12, 10, 8), // key: 1gshiw
    ],
  );

  /// `monitor-check.mjs`
  static const LucideGlyph monitorCheck = LucideGlyph(
    'monitor-check',
    <IconElement>[
      IconPathElement('m9 10 2 2 4-4'), // key: 1gnqz4
      IconRectElement(2, 3, 20, 14, 2), // key: 48i651
      IconPathElement('M12 17v4'), // key: 1riwvh
      IconPathElement('M8 21h8'), // key: 1ev6f3
    ],
  );

  /// `monitor-cloud.mjs`
  static const LucideGlyph
  monitorCloud = LucideGlyph('monitor-cloud', <IconElement>[
    IconPathElement('M11 13a3 3 0 1 1 2.83-4H14a2 2 0 0 1 0 4z'), // key: 1da4q6
    IconPathElement('M12 17v4'), // key: 1riwvh
    IconPathElement('M8 21h8'), // key: 1ev6f3
    IconRectElement(2, 3, 20, 14, 2), // key: x3v2xh
  ]);

  /// `monitor-cog.mjs`
  static const LucideGlyph monitorCog = LucideGlyph(
    'monitor-cog',
    <IconElement>[
      IconPathElement('M12 17v4'), // key: 1riwvh
      IconPathElement('m14.305 7.53.923-.382'), // key: 1mlnsw
      IconPathElement('m15.228 4.852-.923-.383'), // key: 82mpwg
      IconPathElement('m16.852 3.228-.383-.924'), // key: ln4sir
      IconPathElement('m16.852 8.772-.383.923'), // key: 1dejw0
      IconPathElement('m19.148 3.228.383-.924'), // key: 192kgf
      IconPathElement('m19.53 9.696-.382-.924'), // key: fiavlr
      IconPathElement('m20.772 4.852.924-.383'), // key: 1j8mgp
      IconPathElement('m20.772 7.148.924.383'), // key: zix9be
      IconPathElement(
        'M22 13v2a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h7',
      ), // key: 1tnzv8
      IconPathElement('M8 21h8'), // key: 1ev6f3
      IconCircleElement(18, 6, 3), // key: 1h7g24
    ],
  );

  /// `monitor-dot.mjs`
  static const LucideGlyph monitorDot = LucideGlyph(
    'monitor-dot',
    <IconElement>[
      IconPathElement('M12 17v4'), // key: 1riwvh
      IconPathElement(
        'M22 12.307V15a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h8.693',
      ), // key: 1dx6ho
      IconPathElement('M8 21h8'), // key: 1ev6f3
      IconCircleElement(19, 6, 3), // key: 108a5v
    ],
  );

  /// `monitor-down.mjs`
  static const LucideGlyph monitorDown = LucideGlyph(
    'monitor-down',
    <IconElement>[
      IconPathElement('M12 13V7'), // key: h0r20n
      IconPathElement('m15 10-3 3-3-3'), // key: lzhmyn
      IconRectElement(2, 3, 20, 14, 2), // key: 48i651
      IconPathElement('M12 17v4'), // key: 1riwvh
      IconPathElement('M8 21h8'), // key: 1ev6f3
    ],
  );

  /// `monitor-off.mjs`
  static const LucideGlyph monitorOff = LucideGlyph(
    'monitor-off',
    <IconElement>[
      IconPathElement('M12 17v4'), // key: 1riwvh
      IconPathElement(
        'M17 17H4a2 2 0 0 1-2-2V5a2 2 0 0 1 1.184-1.826',
      ), // key: cv7jms
      IconPathElement('m2 2 20 20'), // key: 1ooewy
      IconPathElement('M8 21h8'), // key: 1ev6f3
      IconPathElement(
        'M8.656 3H20a2 2 0 0 1 2 2v10a2 2 0 0 1-.293 1.042',
      ), // key: z8ni2w
    ],
  );

  /// `monitor-pause.mjs`
  static const LucideGlyph monitorPause = LucideGlyph(
    'monitor-pause',
    <IconElement>[
      IconPathElement('M10 13V7'), // key: 1u13u9
      IconPathElement('M14 13V7'), // key: 1vj9om
      IconRectElement(2, 3, 20, 14, 2), // key: 48i651
      IconPathElement('M12 17v4'), // key: 1riwvh
      IconPathElement('M8 21h8'), // key: 1ev6f3
    ],
  );

  /// `monitor-play.mjs`
  static const LucideGlyph
  monitorPlay = LucideGlyph('monitor-play', <IconElement>[
    IconPathElement(
      'M15.033 9.44a.647.647 0 0 1 0 1.12l-4.065 2.352a.645.645 0 0 1-.968-.56V7.648a.645.645 0 0 1 .967-.56z',
    ), // key: vbtd3f
    IconPathElement('M12 17v4'), // key: 1riwvh
    IconPathElement('M8 21h8'), // key: 1ev6f3
    IconRectElement(2, 3, 20, 14, 2), // key: x3v2xh
  ]);

  /// `monitor-smartphone.mjs`
  static const LucideGlyph monitorSmartphone = LucideGlyph(
    'monitor-smartphone',
    <IconElement>[
      IconPathElement(
        'M18 8V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v7a2 2 0 0 0 2 2h8',
      ), // key: 10dyio
      IconPathElement('M10 19v-3.96 3.15'), // key: 1irgej
      IconPathElement('M7 19h5'), // key: qswx4l
      IconRectElement(16, 12, 6, 10, 2), // key: 1egngj
    ],
  );

  /// `monitor-speaker.mjs`
  static const LucideGlyph monitorSpeaker = LucideGlyph(
    'monitor-speaker',
    <IconElement>[
      IconPathElement('M5.5 20H8'), // key: 1k40s5
      IconPathElement('M17 9h.01'), // key: 1j24nn
      IconRectElement(12, 4, 10, 16, 2), // key: ixliua
      IconPathElement('M8 6H4a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h4'), // key: 1mp6e1
      IconCircleElement(17, 15, 1), // key: tqvash
    ],
  );

  /// `monitor-stop.mjs`
  static const LucideGlyph monitorStop = LucideGlyph(
    'monitor-stop',
    <IconElement>[
      IconPathElement('M12 17v4'), // key: 1riwvh
      IconPathElement('M8 21h8'), // key: 1ev6f3
      IconRectElement(2, 3, 20, 14, 2), // key: x3v2xh
      IconRectElement(9, 7, 6, 6, 1), // key: 5m2oou
    ],
  );

  /// `monitor-up.mjs`
  static const LucideGlyph monitorUp = LucideGlyph('monitor-up', <IconElement>[
    IconPathElement('m9 10 3-3 3 3'), // key: 11gsxs
    IconPathElement('M12 13V7'), // key: h0r20n
    IconRectElement(2, 3, 20, 14, 2), // key: 48i651
    IconPathElement('M12 17v4'), // key: 1riwvh
    IconPathElement('M8 21h8'), // key: 1ev6f3
  ]);

  /// `monitor-x.mjs`
  static const LucideGlyph monitorX = LucideGlyph('monitor-x', <IconElement>[
    IconPathElement('m14.5 12.5-5-5'), // key: 1jahn5
    IconPathElement('m9.5 12.5 5-5'), // key: 1k2t7b
    IconRectElement(2, 3, 20, 14, 2), // key: 48i651
    IconPathElement('M12 17v4'), // key: 1riwvh
    IconPathElement('M8 21h8'), // key: 1ev6f3
  ]);

  /// `monitor.mjs`
  static const LucideGlyph monitor = LucideGlyph('monitor', <IconElement>[
    IconRectElement(2, 3, 20, 14, 2), // key: 48i651
    IconLineElement(8, 21, 16, 21), // key: 1svkeh
    IconLineElement(12, 17, 12, 21), // key: vw1qmm
  ]);

  /// `moon-star.mjs`
  static const LucideGlyph moonStar = LucideGlyph('moon-star', <IconElement>[
    IconPathElement('M18 5h4'), // key: 1lhgn2
    IconPathElement('M20 3v4'), // key: 1olli1
    IconPathElement(
      'M20.985 12.486a9 9 0 1 1-9.473-9.472c.405-.022.617.46.402.803a6 6 0 0 0 8.268 8.268c.344-.215.825-.004.803.401',
    ), // key: kfwtm
  ]);

  /// `moon.mjs`
  static const LucideGlyph moon = LucideGlyph('moon', <IconElement>[
    IconPathElement(
      'M20.985 12.486a9 9 0 1 1-9.473-9.472c.405-.022.617.46.402.803a6 6 0 0 0 8.268 8.268c.344-.215.825-.004.803.401',
    ), // key: kfwtm
  ]);

  /// `mosque.mjs`
  static const LucideGlyph mosque = LucideGlyph('mosque', <IconElement>[
    IconPathElement('M12.268 2a2 2 0 003.465 2'), // key: 3in8xp
    IconPathElement('M14 5 L14 8'), // key: 1fhhfb
    IconPathElement('M16 22v-3a2 2 0 00-4 0v3'), // key: 1p6nbd
    IconPathElement(
      'M21 13c-.662-1.497-1.666-2.753-2.9-3.63C16.825 8.47 15.422 8 14 8s-2.826.47-4.1 1.37C8.668 10.248 7.663 11.504 7 13z',
    ), // key: ck3r5y
    IconPathElement('M3 9h4'), // key: rnfnj5
    IconPathElement(
      'M7 22V6a5 5 0 00-2-4 5 5 0 00-2 4v14a2 2 0 002 2h14a2 2 0 002-2v-7',
    ), // key: 28kgc3
  ]);

  /// `motorbike.mjs`
  static const LucideGlyph motorbike = LucideGlyph('motorbike', <IconElement>[
    IconPathElement('m18 14-1-3'), // key: bdajw9
    IconPathElement(
      'm3 9 6 2a2 2 0 0 1 2-2h2a2 2 0 0 1 1.99 1.81',
    ), // key: f5fotj
    IconPathElement(
      'M8 17h3a1 1 0 0 0 1-1 6 6 0 0 1 6-6 1 1 0 0 0 1-1v-.75A5 5 0 0 0 17 5',
    ), // key: 3i90e2
    IconCircleElement(19, 17, 3), // key: 1otbdv
    IconCircleElement(5, 17, 3), // key: 1d8p0c
  ]);

  /// `mountain-snow.mjs`
  static const LucideGlyph mountainSnow = LucideGlyph(
    'mountain-snow',
    <IconElement>[
      IconPathElement('m8 3 4 8 5-5 5 15H2L8 3z'), // key: otkl63
      IconPathElement(
        'M4.14 15.08c2.62-1.57 5.24-1.43 7.86.42 2.74 1.94 5.49 2 8.23.19',
      ), // key: 1pvmmp
    ],
  );

  /// `mountain.mjs`
  static const LucideGlyph mountain = LucideGlyph('mountain', <IconElement>[
    IconPathElement('m8 3 4 8 5-5 5 15H2L8 3z'), // key: otkl63
  ]);

  /// `mouse-left.mjs`
  static const LucideGlyph mouseLeft = LucideGlyph('mouse-left', <IconElement>[
    IconPathElement('M12 7.318V10'), // key: 17s7lh
    IconPathElement(
      'M5 10v5a7 7 0 0 0 14 0V9c0-3.527-2.608-6.515-6-7',
    ), // key: imk5ea
    IconCircleElement(7, 4, 2), // key: ra7k3
  ]);

  /// `mouse-off.mjs`
  static const LucideGlyph mouseOff = LucideGlyph('mouse-off', <IconElement>[
    IconPathElement('M12 6v.343'), // key: 1gyhex
    IconPathElement(
      'M18.218 18.218A7 7 0 0 1 5 15V9a7 7 0 0 1 .782-3.218',
    ), // key: ukzz01
    IconPathElement('M19 13.343V9A7 7 0 0 0 8.56 2.902'), // key: 104jy9
    IconPathElement('M22 22 2 2'), // key: 1r8tn9
  ]);

  /// `mouse-pointer-2-off.mjs`
  static const LucideGlyph
  mousePointer2Off = LucideGlyph('mouse-pointer-2-off', <IconElement>[
    IconPathElement(
      'm15.55 8.45 5.138 2.087a.5.5 0 0 1-.063.947l-6.124 1.58a2 2 0 0 0-1.438 1.435l-1.579 6.126a.5.5 0 0 1-.947.063L8.45 15.551',
    ), // key: 1qoshx
    IconPathElement('M22 2 2 22'), // key: y4kqgn
    IconPathElement(
      'm6.816 11.528-2.779-6.84a.495.495 0 0 1 .651-.651l6.84 2.779',
    ), // key: mymuvk
  ]);

  /// `mouse-pointer-2.mjs`
  static const LucideGlyph
  mousePointer2 = LucideGlyph('mouse-pointer-2', <IconElement>[
    IconPathElement(
      'M4.037 4.688a.495.495 0 0 1 .651-.651l16 6.5a.5.5 0 0 1-.063.947l-6.124 1.58a2 2 0 0 0-1.438 1.435l-1.579 6.126a.5.5 0 0 1-.947.063z',
    ), // key: edeuup
  ]);

  /// `mouse-pointer-ban.mjs`
  static const LucideGlyph
  mousePointerBan = LucideGlyph('mouse-pointer-ban', <IconElement>[
    IconPathElement(
      'M2.034 2.681a.498.498 0 0 1 .647-.647l9 3.5a.5.5 0 0 1-.033.944L8.204 7.545a1 1 0 0 0-.66.66l-1.066 3.443a.5.5 0 0 1-.944.033z',
    ), // key: 11pp1i
    IconCircleElement(16, 16, 6), // key: qoo3c4
    IconPathElement('m11.8 11.8 8.4 8.4'), // key: oogvdj
  ]);

  /// `mouse-pointer-click.mjs`
  static const LucideGlyph
  mousePointerClick = LucideGlyph('mouse-pointer-click', <IconElement>[
    IconPathElement('M14 4.1 12 6'), // key: ita8i4
    IconPathElement('m5.1 8-2.9-.8'), // key: 1go3kf
    IconPathElement('m6 12-1.9 2'), // key: mnht97
    IconPathElement('M7.2 2.2 8 5.1'), // key: 1cfko1
    IconPathElement(
      'M9.037 9.69a.498.498 0 0 1 .653-.653l11 4.5a.5.5 0 0 1-.074.949l-4.349 1.041a1 1 0 0 0-.74.739l-1.04 4.35a.5.5 0 0 1-.95.074z',
    ), // key: s0h3yz
  ]);

  /// `mouse-pointer.mjs`
  static const LucideGlyph
  mousePointer = LucideGlyph('mouse-pointer', <IconElement>[
    IconPathElement('M12.586 12.586 19 19'), // key: ea5xo7
    IconPathElement(
      'M3.688 3.037a.497.497 0 0 0-.651.651l6.5 15.999a.501.501 0 0 0 .947-.062l1.569-6.083a2 2 0 0 1 1.448-1.479l6.124-1.579a.5.5 0 0 0 .063-.947z',
    ), // key: 277e5u
  ]);

  /// `mouse-right.mjs`
  static const LucideGlyph mouseRight = LucideGlyph(
    'mouse-right',
    <IconElement>[
      IconPathElement('M12 7.318V10'), // key: 17s7lh
      IconPathElement(
        'M19 10v5a7 7 0 0 1-14 0V9c0-3.527 2.608-6.515 6-7',
      ), // key: 2es5nn
      IconCircleElement(17, 4, 2), // key: y5j2s2
    ],
  );

  /// `mouse.mjs`
  static const LucideGlyph mouse = LucideGlyph('mouse', <IconElement>[
    IconRectElement(5, 2, 14, 20, 7), // key: 11ol66
    IconPathElement('M12 6v4'), // key: 16clxf
  ]);

  /// `move-3d.mjs`
  static const LucideGlyph move3d = LucideGlyph('move-3d', <IconElement>[
    IconPathElement('M5 3v16h16'), // key: 1mqmf9
    IconPathElement('m5 19 6-6'), // key: jh6hbb
    IconPathElement('m2 6 3-3 3 3'), // key: tkyvxa
    IconPathElement('m18 16 3 3-3 3'), // key: 1d4glt
  ]);

  /// `move-diagonal-2.mjs`
  static const LucideGlyph moveDiagonal2 = LucideGlyph(
    'move-diagonal-2',
    <IconElement>[
      IconPathElement('M19 13v6h-6'), // key: 1hxl6d
      IconPathElement('M5 11V5h6'), // key: 12e2xe
      IconPathElement('m5 5 14 14'), // key: 11anup
    ],
  );

  /// `move-diagonal.mjs`
  static const LucideGlyph moveDiagonal = LucideGlyph(
    'move-diagonal',
    <IconElement>[
      IconPathElement('M11 19H5v-6'), // key: 8awifj
      IconPathElement('M13 5h6v6'), // key: 7voy1q
      IconPathElement('M19 5 5 19'), // key: wwaj1z
    ],
  );

  /// `move-down-left.mjs`
  static const LucideGlyph moveDownLeft = LucideGlyph(
    'move-down-left',
    <IconElement>[
      IconPathElement('M11 19H5V13'), // key: 1akmht
      IconPathElement('M19 5L5 19'), // key: 72u4yj
    ],
  );

  /// `move-down-right.mjs`
  static const LucideGlyph moveDownRight = LucideGlyph(
    'move-down-right',
    <IconElement>[
      IconPathElement('M19 13V19H13'), // key: 10vkzq
      IconPathElement('M5 5L19 19'), // key: 5zm2fv
    ],
  );

  /// `move-down.mjs`
  static const LucideGlyph moveDown = LucideGlyph('move-down', <IconElement>[
    IconPathElement('M8 18L12 22L16 18'), // key: cskvfv
    IconPathElement('M12 2V22'), // key: r89rzk
  ]);

  /// `move-horizontal.mjs`
  static const LucideGlyph moveHorizontal = LucideGlyph(
    'move-horizontal',
    <IconElement>[
      IconPathElement('m18 8 4 4-4 4'), // key: 1ak13k
      IconPathElement('M2 12h20'), // key: 9i4pu4
      IconPathElement('m6 8-4 4 4 4'), // key: 15zrgr
    ],
  );

  /// `move-left.mjs`
  static const LucideGlyph moveLeft = LucideGlyph('move-left', <IconElement>[
    IconPathElement('M6 8L2 12L6 16'), // key: kyvwex
    IconPathElement('M2 12H22'), // key: 1m8cig
  ]);

  /// `move-right.mjs`
  static const LucideGlyph moveRight = LucideGlyph('move-right', <IconElement>[
    IconPathElement('M18 8L22 12L18 16'), // key: 1r0oui
    IconPathElement('M2 12H22'), // key: 1m8cig
  ]);

  /// `move-up-left.mjs`
  static const LucideGlyph moveUpLeft = LucideGlyph(
    'move-up-left',
    <IconElement>[
      IconPathElement('M5 11V5H11'), // key: 3q78g9
      IconPathElement('M5 5L19 19'), // key: 5zm2fv
    ],
  );

  /// `move-up-right.mjs`
  static const LucideGlyph moveUpRight = LucideGlyph(
    'move-up-right',
    <IconElement>[
      IconPathElement('M13 5H19V11'), // key: 1n1gyv
      IconPathElement('M19 5L5 19'), // key: 72u4yj
    ],
  );

  /// `move-up.mjs`
  static const LucideGlyph moveUp = LucideGlyph('move-up', <IconElement>[
    IconPathElement('M8 6L12 2L16 6'), // key: 1yvkyx
    IconPathElement('M12 2V22'), // key: r89rzk
  ]);

  /// `move-vertical.mjs`
  static const LucideGlyph moveVertical = LucideGlyph(
    'move-vertical',
    <IconElement>[
      IconPathElement('M12 2v20'), // key: t6zp3m
      IconPathElement('m8 18 4 4 4-4'), // key: bh5tu3
      IconPathElement('m8 6 4-4 4 4'), // key: ybng9g
    ],
  );

  /// `move.mjs`
  static const LucideGlyph move = LucideGlyph('move', <IconElement>[
    IconPathElement('M12 2v20'), // key: t6zp3m
    IconPathElement('m15 19-3 3-3-3'), // key: 11eu04
    IconPathElement('m19 9 3 3-3 3'), // key: 1mg7y2
    IconPathElement('M2 12h20'), // key: 9i4pu4
    IconPathElement('m5 9-3 3 3 3'), // key: j64kie
    IconPathElement('m9 5 3-3 3 3'), // key: l8vdw6
  ]);

  /// `music-2.mjs`
  static const LucideGlyph music2 = LucideGlyph('music-2', <IconElement>[
    IconCircleElement(8, 18, 4), // key: 1fc0mg
    IconPathElement('M12 18V2l7 4'), // key: g04rme
  ]);

  /// `music-3.mjs`
  static const LucideGlyph music3 = LucideGlyph('music-3', <IconElement>[
    IconCircleElement(12, 18, 4), // key: m3r9ws
    IconPathElement('M16 18V2'), // key: 40x2m5
  ]);

  /// `music-4.mjs`
  static const LucideGlyph music4 = LucideGlyph('music-4', <IconElement>[
    IconPathElement('M9 18V5l12-2v13'), // key: 1jmyc2
    IconPathElement('m9 9 12-2'), // key: 1e64n2
    IconCircleElement(6, 18, 3), // key: fqmcym
    IconCircleElement(18, 16, 3), // key: 1hluhg
  ]);

  /// `music.mjs`
  static const LucideGlyph music = LucideGlyph('music', <IconElement>[
    IconPathElement('M9 18V5l12-2v13'), // key: 1jmyc2
    IconCircleElement(6, 18, 3), // key: fqmcym
    IconCircleElement(18, 16, 3), // key: 1hluhg
  ]);

  /// `navigation-2-off.mjs`
  static const LucideGlyph navigation2Off = LucideGlyph(
    'navigation-2-off',
    <IconElement>[
      IconPathElement('M9.31 9.31 5 21l7-4 7 4-1.17-3.17'), // key: qoq2o2
      IconPathElement('M14.53 8.88 12 2l-1.17 3.17'), // key: k3sjzy
      IconLineElement(2, 2, 22, 22), // key: a6p6uj
    ],
  );

  /// `navigation-2.mjs`
  static const LucideGlyph navigation2 = LucideGlyph(
    'navigation-2',
    <IconElement>[
      IconPolygonElement(<Offset>[
        Offset(12, 2),
        Offset(19, 21),
        Offset(12, 17),
        Offset(5, 21),
        Offset(12, 2),
      ]), // key: x8c0qg
    ],
  );

  /// `navigation-off.mjs`
  static const LucideGlyph navigationOff = LucideGlyph(
    'navigation-off',
    <IconElement>[
      IconPathElement('M8.43 8.43 3 11l8 2 2 8 2.57-5.43'), // key: 1vdtb7
      IconPathElement('M17.39 11.73 22 2l-9.73 4.61'), // key: tya3r6
      IconLineElement(2, 2, 22, 22), // key: a6p6uj
    ],
  );

  /// `navigation.mjs`
  static const LucideGlyph navigation = LucideGlyph('navigation', <IconElement>[
    IconPolygonElement(<Offset>[
      Offset(3, 11),
      Offset(22, 2),
      Offset(13, 21),
      Offset(11, 13),
      Offset(3, 11),
    ]), // key: 1ltx0t
  ]);

  /// `network.mjs`
  static const LucideGlyph network = LucideGlyph('network', <IconElement>[
    IconRectElement(16, 16, 6, 6, 1), // key: 4q2zg0
    IconRectElement(2, 16, 6, 6, 1), // key: 8cvhb9
    IconRectElement(9, 2, 6, 6, 1), // key: 1egb70
    IconPathElement('M5 16v-3a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1v3'), // key: 1jsf9p
    IconPathElement('M12 12V8'), // key: 2874zd
  ]);

  /// `newspaper.mjs`
  static const LucideGlyph newspaper = LucideGlyph('newspaper', <IconElement>[
    IconPathElement('M15 18h-5'), // key: 95g1m2
    IconPathElement('M18 14h-8'), // key: sponae
    IconPathElement(
      'M4 22h16a2 2 0 0 0 2-2V4a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v16a2 2 0 0 1-4 0v-9a2 2 0 0 1 2-2h2',
    ), // key: 39pd36
    IconRectElement(10, 6, 8, 4, 1), // key: aywv1n
  ]);

  /// `nfc.mjs`
  static const LucideGlyph nfc = LucideGlyph('nfc', <IconElement>[
    IconPathElement('M6 8.32a7.43 7.43 0 0 1 0 7.36'), // key: 9iaqei
    IconPathElement('M9.46 6.21a11.76 11.76 0 0 1 0 11.58'), // key: 1yha7l
    IconPathElement('M12.91 4.1a15.91 15.91 0 0 1 .01 15.8'), // key: 4iu2gk
    IconPathElement('M16.37 2a20.16 20.16 0 0 1 0 20'), // key: sap9u2
  ]);

  /// `non-binary.mjs`
  static const LucideGlyph nonBinary = LucideGlyph('non-binary', <IconElement>[
    IconPathElement('M12 2v10'), // key: mnfbl
    IconPathElement('m8.5 4 7 4'), // key: m1xjk3
    IconPathElement('m8.5 8 7-4'), // key: t0m5j6
    IconCircleElement(12, 17, 5), // key: qbz8iq
  ]);

  /// `notebook-pen.mjs`
  static const LucideGlyph
  notebookPen = LucideGlyph('notebook-pen', <IconElement>[
    IconPathElement(
      'M13.4 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-7.4',
    ), // key: re6nr2
    IconPathElement('M2 6h4'), // key: aawbzj
    IconPathElement('M2 10h4'), // key: l0bgd4
    IconPathElement('M2 14h4'), // key: 1gsvsf
    IconPathElement('M2 18h4'), // key: 1bu2t1
    IconPathElement(
      'M21.378 5.626a1 1 0 1 0-3.004-3.004l-5.01 5.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z',
    ), // key: pqwjuv
  ]);

  /// `notebook-tabs.mjs`
  static const LucideGlyph notebookTabs = LucideGlyph(
    'notebook-tabs',
    <IconElement>[
      IconPathElement('M2 6h4'), // key: aawbzj
      IconPathElement('M2 10h4'), // key: l0bgd4
      IconPathElement('M2 14h4'), // key: 1gsvsf
      IconPathElement('M2 18h4'), // key: 1bu2t1
      IconRectElement(4, 2, 16, 20, 2), // key: 1nb95v
      IconPathElement('M15 2v20'), // key: dcj49h
      IconPathElement('M15 7h5'), // key: 1xj5lc
      IconPathElement('M15 12h5'), // key: w5shd9
      IconPathElement('M15 17h5'), // key: 1qaofu
    ],
  );

  /// `notebook-text.mjs`
  static const LucideGlyph notebookText = LucideGlyph(
    'notebook-text',
    <IconElement>[
      IconPathElement('M2 6h4'), // key: aawbzj
      IconPathElement('M2 10h4'), // key: l0bgd4
      IconPathElement('M2 14h4'), // key: 1gsvsf
      IconPathElement('M2 18h4'), // key: 1bu2t1
      IconRectElement(4, 2, 16, 20, 2), // key: 1nb95v
      IconPathElement('M9.5 8h5'), // key: 11mslq
      IconPathElement('M9.5 12H16'), // key: ktog6x
      IconPathElement('M9.5 16H14'), // key: p1seyn
    ],
  );

  /// `notebook.mjs`
  static const LucideGlyph notebook = LucideGlyph('notebook', <IconElement>[
    IconPathElement('M2 6h4'), // key: aawbzj
    IconPathElement('M2 10h4'), // key: l0bgd4
    IconPathElement('M2 14h4'), // key: 1gsvsf
    IconPathElement('M2 18h4'), // key: 1bu2t1
    IconRectElement(4, 2, 16, 20, 2), // key: 1nb95v
    IconPathElement('M16 2v20'), // key: rotuqe
  ]);

  /// `notepad-text-dashed.mjs`
  static const LucideGlyph notepadTextDashed = LucideGlyph(
    'notepad-text-dashed',
    <IconElement>[
      IconPathElement('M8 2v4'), // key: 1cmpym
      IconPathElement('M12 2v4'), // key: 3427ic
      IconPathElement('M16 2v4'), // key: 4m81vk
      IconPathElement('M16 4h2a2 2 0 0 1 2 2v2'), // key: j91f56
      IconPathElement('M20 12v2'), // key: w8o0tu
      IconPathElement('M20 18v2a2 2 0 0 1-2 2h-1'), // key: 1c9ggx
      IconPathElement('M13 22h-2'), // key: 191ugt
      IconPathElement('M7 22H6a2 2 0 0 1-2-2v-2'), // key: 1rt9px
      IconPathElement('M4 14v-2'), // key: 1v0sqh
      IconPathElement('M4 8V6a2 2 0 0 1 2-2h2'), // key: 1mwabg
      IconPathElement('M8 10h6'), // key: 3oa6kw
      IconPathElement('M8 14h8'), // key: 1fgep2
      IconPathElement('M8 18h5'), // key: 17enja
    ],
  );

  /// `notepad-text.mjs`
  static const LucideGlyph notepadText = LucideGlyph(
    'notepad-text',
    <IconElement>[
      IconPathElement('M8 2v4'), // key: 1cmpym
      IconPathElement('M12 2v4'), // key: 3427ic
      IconPathElement('M16 2v4'), // key: 4m81vk
      IconRectElement(4, 4, 16, 18, 2), // key: 1u9h20
      IconPathElement('M8 10h6'), // key: 3oa6kw
      IconPathElement('M8 14h8'), // key: 1fgep2
      IconPathElement('M8 18h5'), // key: 17enja
    ],
  );

  /// `nut-off.mjs`
  static const LucideGlyph nutOff = LucideGlyph('nut-off', <IconElement>[
    IconPathElement('M12 4V2'), // key: 1k5q1u
    IconPathElement(
      'M5 10v4a7.004 7.004 0 0 0 5.277 6.787c.412.104.802.292 1.102.592L12 22l.621-.621c.3-.3.69-.488 1.102-.592a7.01 7.01 0 0 0 4.125-2.939',
    ), // key: 1xcvy9
    IconPathElement('M19 10v3.343'), // key: 163tfc
    IconPathElement(
      'M12 12c-1.349-.573-1.905-1.005-2.5-2-.546.902-1.048 1.353-2.5 2-1.018-.644-1.46-1.08-2-2-1.028.71-1.69.918-3 1 1.081-1.048 1.757-2.03 2-3 .194-.776.84-1.551 1.79-2.21m11.654 5.997c.887-.457 1.28-.891 1.556-1.787 1.032.916 1.683 1.157 3 1-1.297-1.036-1.758-2.03-2-3-.5-2-4-4-8-4-.74 0-1.461.068-2.15.192',
    ), // key: 17914v
    IconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `nut.mjs`
  static const LucideGlyph nut = LucideGlyph('nut', <IconElement>[
    IconPathElement('M12 4V2'), // key: 1k5q1u
    IconPathElement(
      'M5 10v4a7.004 7.004 0 0 0 5.277 6.787c.412.104.802.292 1.102.592L12 22l.621-.621c.3-.3.69-.488 1.102-.592A7.003 7.003 0 0 0 19 14v-4',
    ), // key: 1tgyif
    IconPathElement(
      'M12 4C8 4 4.5 6 4 8c-.243.97-.919 1.952-2 3 1.31-.082 1.972-.29 3-1 .54.92.982 1.356 2 2 1.452-.647 1.954-1.098 2.5-2 .595.995 1.151 1.427 2.5 2 1.31-.621 1.862-1.058 2.5-2 .629.977 1.162 1.423 2.5 2 1.209-.548 1.68-.967 2-2 1.032.916 1.683 1.157 3 1-1.297-1.036-1.758-2.03-2-3-.5-2-4-4-8-4Z',
    ), // key: tnsqj
  ]);

  /// `octagon-alert.mjs`
  static const LucideGlyph
  octagonAlert = LucideGlyph('octagon-alert', <IconElement>[
    IconPathElement('M12 16h.01'), // key: 1drbdi
    IconPathElement('M12 8v4'), // key: 1got3b
    IconPathElement(
      'M15.312 2a2 2 0 0 1 1.414.586l4.688 4.688A2 2 0 0 1 22 8.688v6.624a2 2 0 0 1-.586 1.414l-4.688 4.688a2 2 0 0 1-1.414.586H8.688a2 2 0 0 1-1.414-.586l-4.688-4.688A2 2 0 0 1 2 15.312V8.688a2 2 0 0 1 .586-1.414l4.688-4.688A2 2 0 0 1 8.688 2z',
    ), // key: 1fd625
  ]);

  /// `octagon-minus.mjs`
  static const LucideGlyph
  octagonMinus = LucideGlyph('octagon-minus', <IconElement>[
    IconPathElement(
      'M2.586 16.726A2 2 0 0 1 2 15.312V8.688a2 2 0 0 1 .586-1.414l4.688-4.688A2 2 0 0 1 8.688 2h6.624a2 2 0 0 1 1.414.586l4.688 4.688A2 2 0 0 1 22 8.688v6.624a2 2 0 0 1-.586 1.414l-4.688 4.688a2 2 0 0 1-1.414.586H8.688a2 2 0 0 1-1.414-.586z',
    ), // key: 2d38gg
    IconPathElement('M8 12h8'), // key: 1wcyev
  ]);

  /// `octagon-pause.mjs`
  static const LucideGlyph
  octagonPause = LucideGlyph('octagon-pause', <IconElement>[
    IconPathElement('M10 15V9'), // key: 1lckn7
    IconPathElement('M14 15V9'), // key: 1muqhk
    IconPathElement(
      'M2.586 16.726A2 2 0 0 1 2 15.312V8.688a2 2 0 0 1 .586-1.414l4.688-4.688A2 2 0 0 1 8.688 2h6.624a2 2 0 0 1 1.414.586l4.688 4.688A2 2 0 0 1 22 8.688v6.624a2 2 0 0 1-.586 1.414l-4.688 4.688a2 2 0 0 1-1.414.586H8.688a2 2 0 0 1-1.414-.586z',
    ), // key: 2d38gg
  ]);

  /// `octagon-x.mjs`
  static const LucideGlyph octagonX = LucideGlyph('octagon-x', <IconElement>[
    IconPathElement('m15 9-6 6'), // key: 1uzhvr
    IconPathElement(
      'M2.586 16.726A2 2 0 0 1 2 15.312V8.688a2 2 0 0 1 .586-1.414l4.688-4.688A2 2 0 0 1 8.688 2h6.624a2 2 0 0 1 1.414.586l4.688 4.688A2 2 0 0 1 22 8.688v6.624a2 2 0 0 1-.586 1.414l-4.688 4.688a2 2 0 0 1-1.414.586H8.688a2 2 0 0 1-1.414-.586z',
    ), // key: 2d38gg
    IconPathElement('m9 9 6 6'), // key: z0biqf
  ]);

  /// `octagon.mjs`
  static const LucideGlyph octagon = LucideGlyph('octagon', <IconElement>[
    IconPathElement(
      'M2.586 16.726A2 2 0 0 1 2 15.312V8.688a2 2 0 0 1 .586-1.414l4.688-4.688A2 2 0 0 1 8.688 2h6.624a2 2 0 0 1 1.414.586l4.688 4.688A2 2 0 0 1 22 8.688v6.624a2 2 0 0 1-.586 1.414l-4.688 4.688a2 2 0 0 1-1.414.586H8.688a2 2 0 0 1-1.414-.586z',
    ), // key: 2d38gg
  ]);

  /// `omega.mjs`
  static const LucideGlyph omega = LucideGlyph('omega', <IconElement>[
    IconPathElement(
      'M3 20h4.5a.5.5 0 0 0 .5-.5v-.282a.52.52 0 0 0-.247-.437 8 8 0 1 1 8.494-.001.52.52 0 0 0-.247.438v.282a.5.5 0 0 0 .5.5H21',
    ), // key: 1x94xo
  ]);

  /// `option.mjs`
  static const LucideGlyph option = LucideGlyph('option', <IconElement>[
    IconPathElement('M14 3h7'), // key: 16f0ms
    IconPathElement(
      'M3 3h5.28a1 1 0 0 1 .948.684l5.544 16.632a1 1 0 0 0 .949.684H21',
    ), // key: 1qf1im
  ]);

  /// `orbit.mjs`
  static const LucideGlyph orbit = LucideGlyph('orbit', <IconElement>[
    IconPathElement('M20.341 6.484A10 10 0 0 1 10.266 21.85'), // key: 1enhxb
    IconPathElement('M3.659 17.516A10 10 0 0 1 13.74 2.152'), // key: 1crzgf
    IconCircleElement(12, 12, 3), // key: 1v7zrd
    IconCircleElement(19, 5, 2), // key: mhkx31
    IconCircleElement(5, 19, 2), // key: v8kfzx
  ]);

  /// `origami.mjs`
  static const LucideGlyph origami = LucideGlyph('origami', <IconElement>[
    IconPathElement(
      'M12 12V4a1 1 0 0 1 1-1h6.297a1 1 0 0 1 .651 1.759l-4.696 4.025',
    ), // key: 1bx4vc
    IconPathElement(
      'm12 21-7.414-7.414A2 2 0 0 1 4 12.172V6.415a1.002 1.002 0 0 1 1.707-.707L20 20.009',
    ), // key: 1h3km6
    IconPathElement(
      'm12.214 3.381 8.414 14.966a1 1 0 0 1-.167 1.199l-1.168 1.163a1 1 0 0 1-.706.291H6.351a1 1 0 0 1-.625-.219L3.25 18.8a1 1 0 0 1 .631-1.781l4.165.027',
    ), // key: 1hj4wg
  ]);

  /// `package-2.mjs`
  static const LucideGlyph package2 = LucideGlyph('package-2', <IconElement>[
    IconPathElement('M12 3v6'), // key: 1holv5
    IconPathElement(
      'M16.76 3a2 2 0 0 1 1.8 1.1l2.23 4.479a2 2 0 0 1 .21.891V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V9.472a2 2 0 0 1 .211-.894L5.45 4.1A2 2 0 0 1 7.24 3z',
    ), // key: 187q7i
    IconPathElement('M3.054 9.013h17.893'), // key: grwhos
  ]);

  /// `package-check.mjs`
  static const LucideGlyph
  packageCheck = LucideGlyph('package-check', <IconElement>[
    IconPathElement('M12 22V12'), // key: d0xqtd
    IconPathElement('m16 17 2 2 4-4'), // key: uh5qu3
    IconPathElement(
      'M21 11.127V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.729l7 4a2 2 0 0 0 2 .001l1.32-.753',
    ), // key: kpkbpo
    IconPathElement('M3.29 7 12 12l8.71-5'), // key: 19ckod
    IconPathElement('m7.5 4.27 8.997 5.148'), // key: 9yrvtv
  ]);

  /// `package-minus.mjs`
  static const LucideGlyph
  packageMinus = LucideGlyph('package-minus', <IconElement>[
    IconPathElement('M12 22V12'), // key: d0xqtd
    IconPathElement('M16 17h6'), // key: 1ook5g
    IconPathElement(
      'M21 13V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.729l7 4a2 2 0 0 0 2 .001l1.675-.955',
    ), // key: zu9avd
    IconPathElement('M3.29 7 12 12l8.71-5'), // key: 19ckod
    IconPathElement('m7.5 4.27 8.997 5.148'), // key: 9yrvtv
  ]);

  /// `package-open.mjs`
  static const LucideGlyph
  packageOpen = LucideGlyph('package-open', <IconElement>[
    IconPathElement('M12 22v-9'), // key: x3hkom
    IconPathElement(
      'M15.17 2.21a1.67 1.67 0 0 1 1.63 0L21 4.57a1.93 1.93 0 0 1 0 3.36L8.82 14.79a1.655 1.655 0 0 1-1.64 0L3 12.43a1.93 1.93 0 0 1 0-3.36z',
    ), // key: 2ntwy6
    IconPathElement(
      'M20 13v3.87a2.06 2.06 0 0 1-1.11 1.83l-6 3.08a1.93 1.93 0 0 1-1.78 0l-6-3.08A2.06 2.06 0 0 1 4 16.87V13',
    ), // key: 1pmm1c
    IconPathElement(
      'M21 12.43a1.93 1.93 0 0 0 0-3.36L8.83 2.2a1.64 1.64 0 0 0-1.63 0L3 4.57a1.93 1.93 0 0 0 0 3.36l12.18 6.86a1.636 1.636 0 0 0 1.63 0z',
    ), // key: 12ttoo
  ]);

  /// `package-plus.mjs`
  static const LucideGlyph
  packagePlus = LucideGlyph('package-plus', <IconElement>[
    IconPathElement('M12 22V12'), // key: d0xqtd
    IconPathElement('M16 17h6'), // key: 1ook5g
    IconPathElement('M19 14v6'), // key: 1ckrd5
    IconPathElement(
      'M21 10.535V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.729l7 4a2 2 0 0 0 2 .001l1.675-.955',
    ), // key: 28k6lz
    IconPathElement('M3.29 7 12 12l8.71-5'), // key: 19ckod
    IconPathElement('m7.5 4.27 8.997 5.148'), // key: 9yrvtv
  ]);

  /// `package-search.mjs`
  static const LucideGlyph
  packageSearch = LucideGlyph('package-search', <IconElement>[
    IconPathElement('M12 22V12'), // key: d0xqtd
    IconPathElement('M20.27 18.27 22 20'), // key: er2am
    IconPathElement(
      'M21 10.498V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.729l7 4a2 2 0 0 0 2 .001l.98-.559',
    ), // key: tok1h1
    IconPathElement('M3.29 7 12 12l8.71-5'), // key: 19ckod
    IconPathElement('m7.5 4.27 8.997 5.148'), // key: 9yrvtv
    IconCircleElement(18.5, 16.5, 2.5), // key: ke13xx
  ]);

  /// `package-x.mjs`
  static const LucideGlyph packageX = LucideGlyph('package-x', <IconElement>[
    IconPathElement('M12 22V12'), // key: d0xqtd
    IconPathElement('m16.5 14.5 5 5'), // key: ozpm51
    IconPathElement('m16.5 19.5 5-5'), // key: syf6b9
    IconPathElement(
      'M21 10.5V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.729l7 4a2 2 0 0 0 2 .001l.13-.074',
    ), // key: isw6gs
    IconPathElement('M3.29 7 12 12l8.71-5'), // key: 19ckod
    IconPathElement('m7.5 4.27 8.997 5.148'), // key: 9yrvtv
  ]);

  /// `package.mjs`
  static const LucideGlyph package = LucideGlyph('package', <IconElement>[
    IconPathElement(
      'M11 21.73a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73z',
    ), // key: 1a0edw
    IconPathElement('M12 22V12'), // key: d0xqtd
    IconPolylineElement(<Offset>[
      Offset(3.29, 7),
      Offset(12, 12),
      Offset(20.71, 7),
    ]), // key: ousv84
    IconPathElement('m7.5 4.27 9 5.15'), // key: 1c824w
  ]);

  /// `paint-bucket.mjs`
  static const LucideGlyph
  paintBucket = LucideGlyph('paint-bucket', <IconElement>[
    IconPathElement('M11 7 6 2'), // key: 1jwth8
    IconPathElement('M18.992 12H2.041'), // key: xw1gg
    IconPathElement(
      'M21.145 18.38A3.34 3.34 0 0 1 20 16.5a3.3 3.3 0 0 1-1.145 1.88c-.575.46-.855 1.02-.855 1.595A2 2 0 0 0 20 22a2 2 0 0 0 2-2.025c0-.58-.285-1.13-.855-1.595',
    ), // key: 1nkol4
    IconPathElement(
      'm8.5 4.5 2.148-2.148a1.205 1.205 0 0 1 1.704 0l7.296 7.296a1.205 1.205 0 0 1 0 1.704l-7.592 7.592a3.615 3.615 0 0 1-5.112 0l-3.888-3.888a3.615 3.615 0 0 1 0-5.112L5.67 7.33',
    ), // key: 1nk1rd
  ]);

  /// `paint-roller.mjs`
  static const LucideGlyph paintRoller = LucideGlyph(
    'paint-roller',
    <IconElement>[
      IconRectElement(2, 2, 16, 6, 2), // key: jcyz7m
      IconPathElement(
        'M10 16v-2a2 2 0 0 1 2-2h8a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2',
      ), // key: 1b9h7c
      IconRectElement(8, 16, 4, 6, 1), // key: d6e7yl
    ],
  );

  /// `paintbrush-vertical.mjs`
  static const LucideGlyph
  paintbrushVertical = LucideGlyph('paintbrush-vertical', <IconElement>[
    IconPathElement('M10 2v2'), // key: 7u0qdc
    IconPathElement('M14 2v4'), // key: qmzblu
    IconPathElement('M17 2a1 1 0 0 1 1 1v9H6V3a1 1 0 0 1 1-1z'), // key: ycvu00
    IconPathElement(
      'M6 12a1 1 0 0 0-1 1v1a2 2 0 0 0 2 2h2a1 1 0 0 1 1 1v2.9a2 2 0 1 0 4 0V17a1 1 0 0 1 1-1h2a2 2 0 0 0 2-2v-1a1 1 0 0 0-1-1',
    ), // key: iw4wnp
  ]);

  /// `paintbrush.mjs`
  static const LucideGlyph paintbrush = LucideGlyph('paintbrush', <IconElement>[
    IconPathElement('m14.622 17.897-10.68-2.913'), // key: vj2p1u
    IconPathElement(
      'M18.376 2.622a1 1 0 1 1 3.002 3.002L17.36 9.643a.5.5 0 0 0 0 .707l.944.944a2.41 2.41 0 0 1 0 3.408l-.944.944a.5.5 0 0 1-.707 0L8.354 7.348a.5.5 0 0 1 0-.707l.944-.944a2.41 2.41 0 0 1 3.408 0l.944.944a.5.5 0 0 0 .707 0z',
    ), // key: 18tc5c
    IconPathElement(
      'M9 8c-1.804 2.71-3.97 3.46-6.583 3.948a.507.507 0 0 0-.302.819l7.32 8.883a1 1 0 0 0 1.185.204C12.735 20.405 16 16.792 16 15',
    ), // key: ytzfxy
  ]);

  /// `palette.mjs`
  static const LucideGlyph palette = LucideGlyph('palette', <IconElement>[
    IconPathElement(
      'M12 22a1 1 0 0 1 0-20 10 9 0 0 1 10 9 5 5 0 0 1-5 5h-2.25a1.75 1.75 0 0 0-1.4 2.8l.3.4a1.75 1.75 0 0 1-1.4 2.8z',
    ), // key: e79jfc
    IconCircleElement(13.5, 6.5, 0.5, filled: true), // key: 1okk4w
    IconCircleElement(17.5, 10.5, 0.5, filled: true), // key: f64h9f
    IconCircleElement(6.5, 12.5, 0.5, filled: true), // key: qy21gx
    IconCircleElement(8.5, 7.5, 0.5, filled: true), // key: fotxhn
  ]);

  /// `panda.mjs`
  static const LucideGlyph panda = LucideGlyph('panda', <IconElement>[
    IconPathElement('M11.25 17.25h1.5L12 18z'), // key: 1wmwwj
    IconPathElement('m15 12 2 2'), // key: k60wz4
    IconPathElement('M18 6.5a.5.5 0 0 0-.5-.5'), // key: 1ch4h4
    IconPathElement(
      'M20.69 9.67a4.5 4.5 0 1 0-7.04-5.5 8.35 8.35 0 0 0-3.3 0 4.5 4.5 0 1 0-7.04 5.5C2.49 11.2 2 12.88 2 14.5 2 19.47 6.48 22 12 22s10-2.53 10-7.5c0-1.62-.48-3.3-1.3-4.83',
    ), // key: 1c660l
    IconPathElement('M6 6.5a.495.495 0 0 1 .5-.5'), // key: eviuep
    IconPathElement('m9 12-2 2'), // key: 326nkw
  ]);

  /// `panel-bottom-close.mjs`
  static const LucideGlyph panelBottomClose = LucideGlyph(
    'panel-bottom-close',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M3 15h18'), // key: 5xshup
      IconPathElement('m15 8-3 3-3-3'), // key: 1oxy1z
    ],
  );

  /// `panel-bottom-dashed.mjs`
  static const LucideGlyph panelBottomDashed = LucideGlyph(
    'panel-bottom-dashed',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M14 15h1'), // key: 171nev
      IconPathElement('M19 15h2'), // key: 1vnucp
      IconPathElement('M3 15h2'), // key: 8bym0q
      IconPathElement('M9 15h1'), // key: 1tg3ks
    ],
  );

  /// `panel-bottom-open.mjs`
  static const LucideGlyph panelBottomOpen = LucideGlyph(
    'panel-bottom-open',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M3 15h18'), // key: 5xshup
      IconPathElement('m9 10 3-3 3 3'), // key: 11gsxs
    ],
  );

  /// `panel-bottom.mjs`
  static const LucideGlyph panelBottom = LucideGlyph(
    'panel-bottom',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M3 15h18'), // key: 5xshup
    ],
  );

  /// `panel-left-close.mjs`
  static const LucideGlyph panelLeftClose = LucideGlyph(
    'panel-left-close',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M9 3v18'), // key: fh3hqa
      IconPathElement('m16 15-3-3 3-3'), // key: 14y99z
    ],
  );

  /// `panel-left-dashed.mjs`
  static const LucideGlyph panelLeftDashed = LucideGlyph(
    'panel-left-dashed',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M9 14v1'), // key: askpd8
      IconPathElement('M9 19v2'), // key: 16tejx
      IconPathElement('M9 3v2'), // key: 1noubl
      IconPathElement('M9 9v1'), // key: 19ebxg
    ],
  );

  /// `panel-left-open.mjs`
  static const LucideGlyph panelLeftOpen = LucideGlyph(
    'panel-left-open',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M9 3v18'), // key: fh3hqa
      IconPathElement('m14 9 3 3-3 3'), // key: 8010ee
    ],
  );

  /// `panel-left-right-dashed.mjs`
  static const LucideGlyph panelLeftRightDashed = LucideGlyph(
    'panel-left-right-dashed',
    <IconElement>[
      IconPathElement('M15 10V9'), // key: 4dkmfx
      IconPathElement('M15 15v-1'), // key: 6a4afx
      IconPathElement('M15 21v-2'), // key: 1qshmc
      IconPathElement('M15 5V3'), // key: 1fk0mb
      IconPathElement('M9 10V9'), // key: 1lazqi
      IconPathElement('M9 15v-1'), // key: 9lx740
      IconPathElement('M9 21v-2'), // key: 1fwk0n
      IconPathElement('M9 5V3'), // key: 2q8zi6
      IconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `panel-left.mjs`
  static const LucideGlyph panelLeft = LucideGlyph('panel-left', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    IconPathElement('M9 3v18'), // key: fh3hqa
  ]);

  /// `panel-right-close.mjs`
  static const LucideGlyph panelRightClose = LucideGlyph(
    'panel-right-close',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M15 3v18'), // key: 14nvp0
      IconPathElement('m8 9 3 3-3 3'), // key: 12hl5m
    ],
  );

  /// `panel-right-dashed.mjs`
  static const LucideGlyph panelRightDashed = LucideGlyph(
    'panel-right-dashed',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M15 14v1'), // key: ilsfch
      IconPathElement('M15 19v2'), // key: 1fst2f
      IconPathElement('M15 3v2'), // key: z204g4
      IconPathElement('M15 9v1'), // key: z2a8b1
    ],
  );

  /// `panel-right-open.mjs`
  static const LucideGlyph panelRightOpen = LucideGlyph(
    'panel-right-open',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M15 3v18'), // key: 14nvp0
      IconPathElement('m10 15-3-3 3-3'), // key: 1pgupc
    ],
  );

  /// `panel-right.mjs`
  static const LucideGlyph panelRight = LucideGlyph(
    'panel-right',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M15 3v18'), // key: 14nvp0
    ],
  );

  /// `panel-top-bottom-dashed.mjs`
  static const LucideGlyph panelTopBottomDashed = LucideGlyph(
    'panel-top-bottom-dashed',
    <IconElement>[
      IconPathElement('M14 15h1'), // key: 171nev
      IconPathElement('M14 9h1'), // key: l0svgy
      IconPathElement('M19 15h2'), // key: 1vnucp
      IconPathElement('M19 9h2'), // key: te2zfg
      IconPathElement('M3 15h2'), // key: 8bym0q
      IconPathElement('M3 9h2'), // key: 1h4ldw
      IconPathElement('M9 15h1'), // key: 1tg3ks
      IconPathElement('M9 9h1'), // key: 15jzuz
      IconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `panel-top-close.mjs`
  static const LucideGlyph panelTopClose = LucideGlyph(
    'panel-top-close',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M3 9h18'), // key: 1pudct
      IconPathElement('m9 16 3-3 3 3'), // key: 1idcnm
    ],
  );

  /// `panel-top-dashed.mjs`
  static const LucideGlyph panelTopDashed = LucideGlyph(
    'panel-top-dashed',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M14 9h1'), // key: l0svgy
      IconPathElement('M19 9h2'), // key: te2zfg
      IconPathElement('M3 9h2'), // key: 1h4ldw
      IconPathElement('M9 9h1'), // key: 15jzuz
    ],
  );

  /// `panel-top-open.mjs`
  static const LucideGlyph panelTopOpen = LucideGlyph(
    'panel-top-open',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M3 9h18'), // key: 1pudct
      IconPathElement('m15 14-3 3-3-3'), // key: g215vf
    ],
  );

  /// `panel-top.mjs`
  static const LucideGlyph panelTop = LucideGlyph('panel-top', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    IconPathElement('M3 9h18'), // key: 1pudct
  ]);

  /// `panels-left-bottom.mjs`
  static const LucideGlyph panelsLeftBottom = LucideGlyph(
    'panels-left-bottom',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M9 3v18'), // key: fh3hqa
      IconPathElement('M9 15h12'), // key: 5ijen5
    ],
  );

  /// `panels-right-bottom.mjs`
  static const LucideGlyph panelsRightBottom = LucideGlyph(
    'panels-right-bottom',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M3 15h12'), // key: 1wkqb3
      IconPathElement('M15 3v18'), // key: 14nvp0
    ],
  );

  /// `panels-top-left.mjs`
  static const LucideGlyph panelsTopLeft = LucideGlyph(
    'panels-top-left',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M3 9h18'), // key: 1pudct
      IconPathElement('M9 21V9'), // key: 1oto5p
    ],
  );

  /// `paper-bag.mjs`
  static const LucideGlyph paperBag = LucideGlyph('paper-bag', <IconElement>[
    IconPathElement(
      'M5.364 3.848C4 6 3 9.652 3 12.652V19a2 2 0 002 2h14a2 2 0 002-2v-5c0-2.334-1.816-4.668-2.622-7.002',
    ), // key: vlsvfu
    IconPathElement(
      'M7 3h11.379a2 2 0 011.789 1.106l.723 1.447A1 1 0 0119.997 7h-8.525a2 2 0 01-1.789-1.106L8.79 4.105a2 2 0 10-3.579 1.789l2.261 4.522A5 5 0 018 12.652V21',
    ), // key: 12exh5
  ]);

  /// `paperclip.mjs`
  static const LucideGlyph paperclip = LucideGlyph('paperclip', <IconElement>[
    IconPathElement(
      'm16 6-8.414 8.586a2 2 0 0 0 2.829 2.829l8.414-8.586a4 4 0 1 0-5.657-5.657l-8.379 8.551a6 6 0 1 0 8.485 8.485l8.379-8.551',
    ), // key: 1miecu
  ]);

  /// `parasol.mjs`
  static const LucideGlyph parasol = LucideGlyph('parasol', <IconElement>[
    IconPathElement('M12.5 11.134 18.196 21'), // key: gf58kt
    IconPathElement(
      'M20.425 5.299a10 10 0 0 0-16.941 9.78c.183.563.843.774 1.355.478L20.16 6.711c.512-.296.66-.973.264-1.413',
    ), // key: znqfe4
    IconPathElement('M21 21H3'), // key: oafrgs
  ]);

  /// `parentheses.mjs`
  static const LucideGlyph parentheses = LucideGlyph(
    'parentheses',
    <IconElement>[
      IconPathElement('M8 21s-4-3-4-9 4-9 4-9'), // key: uto9ud
      IconPathElement('M16 3s4 3 4 9-4 9-4 9'), // key: 4w2vsq
    ],
  );

  /// `parking-meter.mjs`
  static const LucideGlyph
  parkingMeter = LucideGlyph('parking-meter', <IconElement>[
    IconPathElement('M11 15h2'), // key: 199qp6
    IconPathElement('M12 12v3'), // key: 158kv8
    IconPathElement('M12 19v3'), // key: npa21l
    IconPathElement(
      'M15.282 19a1 1 0 0 0 .948-.68l2.37-6.988a7 7 0 1 0-13.2 0l2.37 6.988a1 1 0 0 0 .948.68z',
    ), // key: 1jofit
    IconPathElement('M9 9a3 3 0 1 1 6 0'), // key: jdoeu8
  ]);

  /// `party-popper.mjs`
  static const LucideGlyph
  partyPopper = LucideGlyph('party-popper', <IconElement>[
    IconPathElement('M5.8 11.3 2 22l10.7-3.79'), // key: gwxi1d
    IconPathElement('M4 3h.01'), // key: 1vcuye
    IconPathElement('M22 8h.01'), // key: 1mrtc2
    IconPathElement('M15 2h.01'), // key: 1cjtqr
    IconPathElement('M22 20h.01'), // key: 1mrys2
    IconPathElement(
      'm22 2-2.24.75a2.9 2.9 0 0 0-1.96 3.12c.1.86-.57 1.63-1.45 1.63h-.38c-.86 0-1.6.6-1.76 1.44L14 10',
    ), // key: hbicv8
    IconPathElement(
      'm22 13-.82-.33c-.86-.34-1.82.2-1.98 1.11c-.11.7-.72 1.22-1.43 1.22H17',
    ), // key: 1i94pl
    IconPathElement(
      'm11 2 .33.82c.34.86-.2 1.82-1.11 1.98C9.52 4.9 9 5.52 9 6.23V7',
    ), // key: 1cofks
    IconPathElement(
      'M11 13c1.93 1.93 2.83 4.17 2 5-.83.83-3.07-.07-5-2-1.93-1.93-2.83-4.17-2-5 .83-.83 3.07.07 5 2Z',
    ), // key: 4kbmks
  ]);

  /// `pause.mjs`
  static const LucideGlyph pause = LucideGlyph('pause', <IconElement>[
    IconRectElement(14, 3, 5, 18, 1), // key: kaeet6
    IconRectElement(5, 3, 5, 18, 1), // key: 1wsw3u
  ]);

  /// `paw-print.mjs`
  static const LucideGlyph pawPrint = LucideGlyph('paw-print', <IconElement>[
    IconCircleElement(11, 4, 2), // key: vol9p0
    IconCircleElement(18, 8, 2), // key: 17gozi
    IconCircleElement(20, 16, 2), // key: 1v9bxh
    IconPathElement(
      'M9 10a5 5 0 0 1 5 5v3.5a3.5 3.5 0 0 1-6.84 1.045Q6.52 17.48 4.46 16.84A3.5 3.5 0 0 1 5.5 10Z',
    ), // key: 1ydw1z
  ]);

  /// `pc-case.mjs`
  static const LucideGlyph pcCase = LucideGlyph('pc-case', <IconElement>[
    IconRectElement(5, 2, 14, 20, 2), // key: 1uq1d7
    IconPathElement('M15 14h.01'), // key: 1kp3bh
    IconPathElement('M9 6h6'), // key: dgm16u
    IconPathElement('M9 10h6'), // key: 9gxzsh
  ]);

  /// `pen-line.mjs`
  static const LucideGlyph penLine = LucideGlyph('pen-line', <IconElement>[
    IconPathElement('M13 21h8'), // key: 1jsn5i
    IconPathElement(
      'M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z',
    ), // key: 1a8usu
  ]);

  /// `pen-off.mjs`
  static const LucideGlyph penOff = LucideGlyph('pen-off', <IconElement>[
    IconPathElement(
      'm10 10-6.157 6.162a2 2 0 0 0-.5.833l-1.322 4.36a.5.5 0 0 0 .622.624l4.358-1.323a2 2 0 0 0 .83-.5L14 13.982',
    ), // key: bjo8r8
    IconPathElement(
      'm12.829 7.172 4.359-4.346a1 1 0 1 1 3.986 3.986l-4.353 4.353',
    ), // key: 16h5ne
    IconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `pen-tool.mjs`
  static const LucideGlyph penTool = LucideGlyph('pen-tool', <IconElement>[
    IconPathElement(
      'M15.707 21.293a1 1 0 0 1-1.414 0l-1.586-1.586a1 1 0 0 1 0-1.414l5.586-5.586a1 1 0 0 1 1.414 0l1.586 1.586a1 1 0 0 1 0 1.414z',
    ), // key: nt11vn
    IconPathElement(
      'm18 13-1.375-6.874a1 1 0 0 0-.746-.776L3.235 2.028a1 1 0 0 0-1.207 1.207L5.35 15.879a1 1 0 0 0 .776.746L13 18',
    ), // key: 15qc1e
    IconPathElement('m2.3 2.3 7.286 7.286'), // key: 1wuzzi
    IconCircleElement(11, 11, 2), // key: xmgehs
  ]);

  /// `pen.mjs`
  static const LucideGlyph pen = LucideGlyph('pen', <IconElement>[
    IconPathElement(
      'M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z',
    ), // key: 1a8usu
  ]);

  /// `pencil-line.mjs`
  static const LucideGlyph
  pencilLine = LucideGlyph('pencil-line', <IconElement>[
    IconPathElement('M13 21h8'), // key: 1jsn5i
    IconPathElement('m15 5 4 4'), // key: 1mk7zo
    IconPathElement(
      'M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z',
    ), // key: 1a8usu
  ]);

  /// `pencil-off.mjs`
  static const LucideGlyph pencilOff = LucideGlyph('pencil-off', <IconElement>[
    IconPathElement(
      'm10 10-6.157 6.162a2 2 0 0 0-.5.833l-1.322 4.36a.5.5 0 0 0 .622.624l4.358-1.323a2 2 0 0 0 .83-.5L14 13.982',
    ), // key: bjo8r8
    IconPathElement(
      'm12.829 7.172 4.359-4.346a1 1 0 1 1 3.986 3.986l-4.353 4.353',
    ), // key: 16h5ne
    IconPathElement('m15 5 4 4'), // key: 1mk7zo
    IconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `pencil-ruler.mjs`
  static const LucideGlyph
  pencilRuler = LucideGlyph('pencil-ruler', <IconElement>[
    IconPathElement(
      'M13 7 8.7 2.7a2.41 2.41 0 0 0-3.4 0L2.7 5.3a2.41 2.41 0 0 0 0 3.4L7 13',
    ), // key: orapub
    IconPathElement('m8 6 2-2'), // key: 115y1s
    IconPathElement('m18 16 2-2'), // key: ee94s4
    IconPathElement(
      'm17 11 4.3 4.3c.94.94.94 2.46 0 3.4l-2.6 2.6c-.94.94-2.46.94-3.4 0L11 17',
    ), // key: cfq27r
    IconPathElement(
      'M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z',
    ), // key: 1a8usu
    IconPathElement('m15 5 4 4'), // key: 1mk7zo
  ]);

  /// `pencil-sparkles.mjs`
  static const LucideGlyph
  pencilSparkles = LucideGlyph('pencil-sparkles', <IconElement>[
    IconPathElement('M10 3H8'), // key: mzdi2d
    IconPathElement('m15.007 5.008 3.987 3.986'), // key: 1scubj
    IconPathElement('M20 15v4'), // key: nmhudv
    IconPathElement(
      'M21.174 6.813a2.82 2.82 0 0 0-3.986-3.987L3.842 16.175a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z',
    ), // key: fs0856
    IconPathElement('M22 17h-4'), // key: 1sj068
    IconPathElement('M4 5v4'), // key: 13jjxc
    IconPathElement('M6 7H2'), // key: 8zbtv0
    IconPathElement('M9 2v2'), // key: 165o2o
  ]);

  /// `pencil.mjs`
  static const LucideGlyph pencil = LucideGlyph('pencil', <IconElement>[
    IconPathElement(
      'M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z',
    ), // key: 1a8usu
    IconPathElement('m15 5 4 4'), // key: 1mk7zo
  ]);

  /// `pentagon.mjs`
  static const LucideGlyph pentagon = LucideGlyph('pentagon', <IconElement>[
    IconPathElement(
      'M10.83 2.38a2 2 0 0 1 2.34 0l8 5.74a2 2 0 0 1 .73 2.25l-3.04 9.26a2 2 0 0 1-1.9 1.37H7.04a2 2 0 0 1-1.9-1.37L2.1 10.37a2 2 0 0 1 .73-2.25z',
    ), // key: 2hea0t
  ]);

  /// `percent.mjs`
  static const LucideGlyph percent = LucideGlyph('percent', <IconElement>[
    IconLineElement(19, 5, 5, 19), // key: 1x9vlm
    IconCircleElement(6.5, 6.5, 2.5), // key: 4mh3h7
    IconCircleElement(17.5, 17.5, 2.5), // key: 1mdrzq
  ]);

  /// `person-standing.mjs`
  static const LucideGlyph personStanding = LucideGlyph(
    'person-standing',
    <IconElement>[
      IconCircleElement(12, 5, 1), // key: gxeob9
      IconPathElement('m9 20 3-6 3 6'), // key: se2kox
      IconPathElement('m6 8 6 2 6-2'), // key: 4o3us4
      IconPathElement('M12 10v4'), // key: 1kjpxc
    ],
  );

  /// `phi.mjs`
  static const LucideGlyph phi = LucideGlyph('phi', <IconElement>[
    IconPathElement('M12 2v20'), // key: t6zp3m
    IconCircleElement(12, 12, 7), // key: fim9np
  ]);

  /// `philippine-peso.mjs`
  static const LucideGlyph
  philippinePeso = LucideGlyph('philippine-peso', <IconElement>[
    IconPathElement('M20 11H4'), // key: 6ut86h
    IconPathElement('M20 7H4'), // key: zbl0bi
    IconPathElement('M7 21V4a1 1 0 0 1 1-1h4a1 1 0 0 1 0 12H7'), // key: 1ana5r
  ]);

  /// `phone-call.mjs`
  static const LucideGlyph phoneCall = LucideGlyph('phone-call', <IconElement>[
    IconPathElement('M13 2a9 9 0 0 1 9 9'), // key: 1itnx2
    IconPathElement('M13 6a5 5 0 0 1 5 5'), // key: 11nki7
    IconPathElement(
      'M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384',
    ), // key: 9njp5v
  ]);

  /// `phone-forwarded.mjs`
  static const LucideGlyph
  phoneForwarded = LucideGlyph('phone-forwarded', <IconElement>[
    IconPathElement('M14 6h8'), // key: yd68k4
    IconPathElement('m18 2 4 4-4 4'), // key: pucp1d
    IconPathElement(
      'M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384',
    ), // key: 9njp5v
  ]);

  /// `phone-incoming.mjs`
  static const LucideGlyph
  phoneIncoming = LucideGlyph('phone-incoming', <IconElement>[
    IconPathElement('M16 2v6h6'), // key: 1mfrl5
    IconPathElement('m22 2-6 6'), // key: 6f0sa0
    IconPathElement(
      'M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384',
    ), // key: 9njp5v
  ]);

  /// `phone-missed.mjs`
  static const LucideGlyph
  phoneMissed = LucideGlyph('phone-missed', <IconElement>[
    IconPathElement('m16 2 6 6'), // key: 1gw87d
    IconPathElement('m22 2-6 6'), // key: 6f0sa0
    IconPathElement(
      'M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384',
    ), // key: 9njp5v
  ]);

  /// `phone-off.mjs`
  static const LucideGlyph phoneOff = LucideGlyph('phone-off', <IconElement>[
    IconPathElement(
      'M10.1 13.9a14 14 0 0 0 3.732 2.668 1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2 18 18 0 0 1-12.728-5.272',
    ), // key: 1wngk7
    IconPathElement('M22 2 2 22'), // key: y4kqgn
    IconPathElement(
      'M4.76 13.582A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 .244.473',
    ), // key: 10hv5p
  ]);

  /// `phone-outgoing.mjs`
  static const LucideGlyph
  phoneOutgoing = LucideGlyph('phone-outgoing', <IconElement>[
    IconPathElement('m16 8 6-6'), // key: oawc05
    IconPathElement('M22 8V2h-6'), // key: oqy2zc
    IconPathElement(
      'M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384',
    ), // key: 9njp5v
  ]);

  /// `phone.mjs`
  static const LucideGlyph phone = LucideGlyph('phone', <IconElement>[
    IconPathElement(
      'M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384',
    ), // key: 9njp5v
  ]);

  /// `pi.mjs`
  static const LucideGlyph pi = LucideGlyph('pi', <IconElement>[
    IconLineElement(9, 4, 9, 20), // key: ovs5a5
    IconPathElement('M4 7c0-1.7 1.3-3 3-3h13'), // key: 10pag4
    IconPathElement('M18 20c-1.7 0-3-1.3-3-3V4'), // key: 1gaosr
  ]);

  /// `piano.mjs`
  static const LucideGlyph piano = LucideGlyph('piano', <IconElement>[
    IconPathElement(
      'M18.5 8c-1.4 0-2.6-.8-3.2-2A6.87 6.87 0 0 0 2 9v11a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-8.5C22 9.6 20.4 8 18.5 8',
    ), // key: lag0yf
    IconPathElement('M2 14h20'), // key: myj16y
    IconPathElement('M6 14v4'), // key: 9ng0ue
    IconPathElement('M10 14v4'), // key: 1v8uk5
    IconPathElement('M14 14v4'), // key: 1tqops
    IconPathElement('M18 14v4'), // key: 18uqwm
  ]);

  /// `pickaxe.mjs`
  static const LucideGlyph pickaxe = LucideGlyph('pickaxe', <IconElement>[
    IconPathElement(
      'm14 13-8.381 8.38a1 1 0 0 1-3.001-3L11 9.999',
    ), // key: 1lw9ds
    IconPathElement(
      'M15.973 4.027A13 13 0 0 0 5.902 2.373c-1.398.342-1.092 2.158.277 2.601a19.9 19.9 0 0 1 5.822 3.024',
    ), // key: ffj4ej
    IconPathElement(
      'M16.001 11.999a19.9 19.9 0 0 1 3.024 5.824c.444 1.369 2.26 1.676 2.603.278A13 13 0 0 0 20 8.069',
    ), // key: 8tj4zw
    IconPathElement(
      'M18.352 3.352a1.205 1.205 0 0 0-1.704 0l-5.296 5.296a1.205 1.205 0 0 0 0 1.704l2.296 2.296a1.205 1.205 0 0 0 1.704 0l5.296-5.296a1.205 1.205 0 0 0 0-1.704z',
    ), // key: hh6h97
  ]);

  /// `picture-in-picture-2.mjs`
  static const LucideGlyph pictureInPicture2 = LucideGlyph(
    'picture-in-picture-2',
    <IconElement>[
      IconPathElement(
        'M21 9V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v10c0 1.1.9 2 2 2h4',
      ), // key: daa4of
      IconRectElement(12, 13, 10, 7, 2), // key: 1nb8gs
    ],
  );

  /// `picture-in-picture.mjs`
  static const LucideGlyph pictureInPicture = LucideGlyph(
    'picture-in-picture',
    <IconElement>[
      IconPathElement('M2 10h6V4'), // key: zwrco
      IconPathElement('m2 4 6 6'), // key: ug085t
      IconPathElement('M21 10V7a2 2 0 0 0-2-2h-7'), // key: git5jr
      IconPathElement('M3 14v2a2 2 0 0 0 2 2h3'), // key: 1f7fh3
      IconRectElement(12, 14, 10, 7, 1), // key: 1wjs3o
    ],
  );

  /// `piggy-bank.mjs`
  static const LucideGlyph piggyBank = LucideGlyph('piggy-bank', <IconElement>[
    IconPathElement(
      'M11 17h3v2a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1v-3a3.16 3.16 0 0 0 2-2h1a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1h-1a5 5 0 0 0-2-4V3a4 4 0 0 0-3.2 1.6l-.3.4H11a6 6 0 0 0-6 6v1a5 5 0 0 0 2 4v3a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1z',
    ), // key: 1piglc
    IconPathElement('M16 10h.01'), // key: 1m94wz
    IconPathElement('M2 8v1a2 2 0 0 0 2 2h1'), // key: 1env43
  ]);

  /// `pilcrow-left.mjs`
  static const LucideGlyph pilcrowLeft = LucideGlyph(
    'pilcrow-left',
    <IconElement>[
      IconPathElement('M14 3v11'), // key: mlfb7b
      IconPathElement('M14 9h-3a3 3 0 0 1 0-6h9'), // key: 1ulc19
      IconPathElement('M18 3v11'), // key: 1phi0r
      IconPathElement('M22 18H2l4-4'), // key: yt65j9
      IconPathElement('m6 22-4-4'), // key: 6jgyf5
    ],
  );

  /// `pilcrow-right.mjs`
  static const LucideGlyph pilcrowRight = LucideGlyph(
    'pilcrow-right',
    <IconElement>[
      IconPathElement('M10 3v11'), // key: o3l5kj
      IconPathElement('M10 9H7a1 1 0 0 1 0-6h8'), // key: 1wb1nc
      IconPathElement('M14 3v11'), // key: mlfb7b
      IconPathElement('m18 14 4 4H2'), // key: 4r8io1
      IconPathElement('m22 18-4 4'), // key: 1hjjrd
    ],
  );

  /// `pilcrow.mjs`
  static const LucideGlyph pilcrow = LucideGlyph('pilcrow', <IconElement>[
    IconPathElement('M13 4v16'), // key: 8vvj80
    IconPathElement('M17 4v16'), // key: 7dpous
    IconPathElement('M19 4H9.5a4.5 4.5 0 0 0 0 9H13'), // key: sh4n9v
  ]);

  /// `pill-bottle.mjs`
  static const LucideGlyph
  pillBottle = LucideGlyph('pill-bottle', <IconElement>[
    IconPathElement('M18 11h-4a1 1 0 0 0-1 1v5a1 1 0 0 0 1 1h4'), // key: 17ldeb
    IconPathElement('M6 7v13a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V7'), // key: nc37y6
    IconRectElement(4, 2, 16, 5, 1), // key: 3jeezo
  ]);

  /// `pill.mjs`
  static const LucideGlyph pill = LucideGlyph('pill', <IconElement>[
    IconPathElement(
      'm10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z',
    ), // key: wa1lgi
    IconPathElement('m8.5 8.5 7 7'), // key: rvfmvr
  ]);

  /// `pin-off.mjs`
  static const LucideGlyph pinOff = LucideGlyph('pin-off', <IconElement>[
    IconPathElement('M12 17v5'), // key: bb1du9
    IconPathElement(
      'M15 9.34V7a1 1 0 0 1 1-1 2 2 0 0 0 0-4H7.89',
    ), // key: znwnzq
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement(
      'M9 9v1.76a2 2 0 0 1-1.11 1.79l-1.78.9A2 2 0 0 0 5 15.24V16a1 1 0 0 0 1 1h11',
    ), // key: c9qhm2
  ]);

  /// `pin.mjs`
  static const LucideGlyph pin = LucideGlyph('pin', <IconElement>[
    IconPathElement('M12 17v5'), // key: bb1du9
    IconPathElement(
      'M9 10.76a2 2 0 0 1-1.11 1.79l-1.78.9A2 2 0 0 0 5 15.24V16a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-.76a2 2 0 0 0-1.11-1.79l-1.78-.9A2 2 0 0 1 15 10.76V7a1 1 0 0 1 1-1 2 2 0 0 0 0-4H8a2 2 0 0 0 0 4 1 1 0 0 1 1 1z',
    ), // key: 1nkz8b
  ]);

  /// `pipette.mjs`
  static const LucideGlyph pipette = LucideGlyph('pipette', <IconElement>[
    IconPathElement(
      'm12 9-8.414 8.414A2 2 0 0 0 3 18.828v1.344a2 2 0 0 1-.586 1.414A2 2 0 0 1 3.828 21h1.344a2 2 0 0 0 1.414-.586L15 12',
    ), // key: 1y3wsu
    IconPathElement(
      'm18 9 .4.4a1 1 0 1 1-3 3l-3.8-3.8a1 1 0 1 1 3-3l.4.4 3.4-3.4a1 1 0 1 1 3 3z',
    ), // key: 110lr1
    IconPathElement('m2 22 .414-.414'), // key: jhxm08
  ]);

  /// `pizza.mjs`
  static const LucideGlyph pizza = LucideGlyph('pizza', <IconElement>[
    IconPathElement('m12 14-1 1'), // key: 11onhr
    IconPathElement('m13.75 18.25-1.25 1.42'), // key: 1yisr3
    IconPathElement(
      'M17.775 5.654a15.68 15.68 0 0 0-12.121 12.12',
    ), // key: 1qtqk6
    IconPathElement('M18.8 9.3a1 1 0 0 0 2.1 7.7'), // key: fbbbr2
    IconPathElement(
      'M21.964 20.732a1 1 0 0 1-1.232 1.232l-18-5a1 1 0 0 1-.695-1.232A19.68 19.68 0 0 1 15.732 2.037a1 1 0 0 1 1.232.695z',
    ), // key: 1hyfdd
  ]);

  /// `plane-landing.mjs`
  static const LucideGlyph
  planeLanding = LucideGlyph('plane-landing', <IconElement>[
    IconPathElement('M2 22h20'), // key: 272qi7
    IconPathElement(
      'M3.77 10.77 2 9l2-4.5 1.1.55c.55.28.9.84.9 1.45s.35 1.17.9 1.45L8 8.5l3-6 1.05.53a2 2 0 0 1 1.09 1.52l.72 5.4a2 2 0 0 0 1.09 1.52l4.4 2.2c.42.22.78.55 1.01.96l.6 1.03c.49.88-.06 1.98-1.06 2.1l-1.18.15c-.47.06-.95-.02-1.37-.24L4.29 11.15a2 2 0 0 1-.52-.38Z',
    ), // key: 1ma21e
  ]);

  /// `plane-takeoff.mjs`
  static const LucideGlyph
  planeTakeoff = LucideGlyph('plane-takeoff', <IconElement>[
    IconPathElement('M2 22h20'), // key: 272qi7
    IconPathElement(
      'M6.36 17.4 4 17l-2-4 1.1-.55a2 2 0 0 1 1.8 0l.17.1a2 2 0 0 0 1.8 0L8 12 5 6l.9-.45a2 2 0 0 1 2.09.2l4.02 3a2 2 0 0 0 2.1.2l4.19-2.06a2.41 2.41 0 0 1 1.73-.17L21 7a1.4 1.4 0 0 1 .87 1.99l-.38.76c-.23.46-.6.84-1.07 1.08L7.58 17.2a2 2 0 0 1-1.22.18Z',
    ), // key: fkigj9
  ]);

  /// `plane.mjs`
  static const LucideGlyph plane = LucideGlyph('plane', <IconElement>[
    IconPathElement(
      'M17.8 19.2 16 11l3.5-3.5C21 6 21.5 4 21 3c-1-.5-3 0-4.5 1.5L13 8 4.8 6.2c-.5-.1-.9.1-1.1.5l-.3.5c-.2.5-.1 1 .3 1.3L9 12l-2 3H4l-1 1 3 2 2 3 1-1v-3l3-2 3.5 5.3c.3.4.8.5 1.3.3l.5-.2c.4-.3.6-.7.5-1.2z',
    ), // key: 1v9wt8
  ]);

  /// `play-off.mjs`
  static const LucideGlyph playOff = LucideGlyph('play-off', <IconElement>[
    IconPathElement(
      'm10.215 4.56 9.79 5.71a2 2 0 0 1 .003 3.458l-.393.23',
    ), // key: fdtkwz
    IconPathElement(
      'm16.042 16.042-8.034 4.686A2 2 0 0 1 5 19V5',
    ), // key: 1c8hxg
    IconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `play.mjs`
  static const LucideGlyph play = LucideGlyph('play', <IconElement>[
    IconPathElement(
      'M5 5a2 2 0 0 1 3.008-1.728l11.997 6.998a2 2 0 0 1 .003 3.458l-12 7A2 2 0 0 1 5 19z',
    ), // key: 10ikf1
  ]);

  /// `plug-2.mjs`
  static const LucideGlyph plug2 = LucideGlyph('plug-2', <IconElement>[
    IconPathElement('M9 2v6'), // key: 17ngun
    IconPathElement('M15 2v6'), // key: s7yy2p
    IconPathElement('M12 17v5'), // key: bb1du9
    IconPathElement('M5 8h14'), // key: pcz4l3
    IconPathElement('M6 11V8h12v3a6 6 0 1 1-12 0Z'), // key: wtfw2c
  ]);

  /// `plug-zap.mjs`
  static const LucideGlyph plugZap = LucideGlyph('plug-zap', <IconElement>[
    IconPathElement(
      'M6.3 20.3a2.4 2.4 0 0 0 3.4 0L12 18l-6-6-2.3 2.3a2.4 2.4 0 0 0 0 3.4Z',
    ), // key: goz73y
    IconPathElement('m2 22 3-3'), // key: 19mgm9
    IconPathElement('M7.5 13.5 10 11'), // key: 7xgeeb
    IconPathElement('M10.5 16.5 13 14'), // key: 10btkg
    IconPathElement('m18 3-4 4h6l-4 4'), // key: 16psg9
  ]);

  /// `plug.mjs`
  static const LucideGlyph plug = LucideGlyph('plug', <IconElement>[
    IconPathElement('M12 22v-5'), // key: 1ega77
    IconPathElement('M15 8V2'), // key: 18g5xt
    IconPathElement(
      'M17 8a1 1 0 0 1 1 1v4a4 4 0 0 1-4 4h-4a4 4 0 0 1-4-4V9a1 1 0 0 1 1-1z',
    ), // key: 1xoxul
    IconPathElement('M9 8V2'), // key: 14iosj
  ]);

  /// `plus.mjs`
  static const LucideGlyph plus = LucideGlyph('plus', <IconElement>[
    IconPathElement('M5 12h14'), // key: 1ays0h
    IconPathElement('M12 5v14'), // key: s699le
  ]);

  /// `pocket-knife.mjs`
  static const LucideGlyph pocketKnife = LucideGlyph(
    'pocket-knife',
    <IconElement>[
      IconPathElement(
        'M3 2v1c0 1 2 1 2 2S3 6 3 7s2 1 2 2-2 1-2 2 2 1 2 2',
      ), // key: 19w3oe
      IconPathElement('M18 6h.01'), // key: 1v4wsw
      IconPathElement('M6 18h.01'), // key: uhywen
      IconPathElement(
        'M20.83 8.83a4 4 0 0 0-5.66-5.66l-12 12a4 4 0 1 0 5.66 5.66Z',
      ), // key: 6fykxj
      IconPathElement('M18 11.66V22a4 4 0 0 0 4-4V6'), // key: 1utzek
    ],
  );

  /// `podium.mjs`
  static const LucideGlyph podium = LucideGlyph('podium', <IconElement>[
    IconPathElement('M12 6V2h-1'), // key: 1hv4eo
    IconPathElement(
      'M9 15a1 1 0 0 0-1-1H4a1 1 0 0 0-1 1v5a1 1 0 0 0 1 1h16a1 1 0 0 0 1-1v-3a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1',
    ), // key: 1jvw5n
    IconPathElement('M9 21V11a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v10'), // key: rgi5dp
  ]);

  /// `pointer-off.mjs`
  static const LucideGlyph
  pointerOff = LucideGlyph('pointer-off', <IconElement>[
    IconPathElement('M10 4.5V4a2 2 0 0 0-2.41-1.957'), // key: jsi14n
    IconPathElement('M13.9 8.4a2 2 0 0 0-1.26-1.295'), // key: hirc7f
    IconPathElement(
      'M21.7 16.2A8 8 0 0 0 22 14v-3a2 2 0 1 0-4 0v-1a2 2 0 0 0-3.63-1.158',
    ), // key: 1jxb2e
    IconPathElement(
      'm7 15-1.8-1.8a2 2 0 0 0-2.79 2.86L6 19.7a7.74 7.74 0 0 0 6 2.3h2a8 8 0 0 0 5.657-2.343',
    ), // key: 10r7hm
    IconPathElement('M6 6v8'), // key: tv5xkp
    IconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `pointer.mjs`
  static const LucideGlyph pointer = LucideGlyph('pointer', <IconElement>[
    IconPathElement('M22 14a8 8 0 0 1-8 8'), // key: 56vcr3
    IconPathElement('M18 11v-1a2 2 0 0 0-2-2a2 2 0 0 0-2 2'), // key: 1agjmk
    IconPathElement('M14 10V9a2 2 0 0 0-2-2a2 2 0 0 0-2 2v1'), // key: wdbh2u
    IconPathElement('M10 9.5V4a2 2 0 0 0-2-2a2 2 0 0 0-2 2v10'), // key: 1ibuk9
    IconPathElement(
      'M18 11a2 2 0 1 1 4 0v3a8 8 0 0 1-8 8h-2c-2.8 0-4.5-.86-5.99-2.34l-3.6-3.6a2 2 0 0 1 2.83-2.82L7 15',
    ), // key: g6ys72
  ]);

  /// `popcorn.mjs`
  static const LucideGlyph popcorn = LucideGlyph('popcorn', <IconElement>[
    IconPathElement(
      'M18 8a2 2 0 0 0 0-4 2 2 0 0 0-4 0 2 2 0 0 0-4 0 2 2 0 0 0-4 0 2 2 0 0 0 0 4',
    ), // key: 10td1f
    IconPathElement('M10 22 9 8'), // key: yjptiv
    IconPathElement('m14 22 1-14'), // key: 8jwc8b
    IconPathElement(
      'M20 8c.5 0 .9.4.8 1l-2.6 12c-.1.5-.7 1-1.2 1H7c-.6 0-1.1-.4-1.2-1L3.2 9c-.1-.6.3-1 .8-1Z',
    ), // key: 1qo33t
  ]);

  /// `popsicle.mjs`
  static const LucideGlyph popsicle = LucideGlyph('popsicle', <IconElement>[
    IconPathElement(
      'M18.6 14.4c.8-.8.8-2 0-2.8l-8.1-8.1a4.95 4.95 0 1 0-7.1 7.1l8.1 8.1c.9.7 2.1.7 2.9-.1Z',
    ), // key: 1o68ps
    IconPathElement('m22 22-5.5-5.5'), // key: 17o70y
  ]);

  /// `pound-sterling.mjs`
  static const LucideGlyph poundSterling = LucideGlyph(
    'pound-sterling',
    <IconElement>[
      IconPathElement('M18 7c0-5.333-8-5.333-8 0'), // key: 1prm2n
      IconPathElement('M10 7v14'), // key: 18tmcs
      IconPathElement('M6 21h12'), // key: 4dkmi1
      IconPathElement('M6 13h10'), // key: ybwr4a
    ],
  );

  /// `power-off.mjs`
  static const LucideGlyph powerOff = LucideGlyph('power-off', <IconElement>[
    IconPathElement('M18.36 6.64A9 9 0 0 1 20.77 15'), // key: dxknvb
    IconPathElement('M6.16 6.16a9 9 0 1 0 12.68 12.68'), // key: 1x7qb5
    IconPathElement('M12 2v4'), // key: 3427ic
    IconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `power.mjs`
  static const LucideGlyph power = LucideGlyph('power', <IconElement>[
    IconPathElement('M12 2v10'), // key: mnfbl
    IconPathElement('M18.4 6.6a9 9 0 1 1-12.77.04'), // key: obofu9
  ]);

  /// `presentation.mjs`
  static const LucideGlyph
  presentation = LucideGlyph('presentation', <IconElement>[
    IconPathElement('M2 3h20'), // key: 91anmk
    IconPathElement('M21 3v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V3'), // key: 2k9sn8
    IconPathElement('m7 21 5-5 5 5'), // key: bip4we
  ]);

  /// `printer-check.mjs`
  static const LucideGlyph printerCheck = LucideGlyph(
    'printer-check',
    <IconElement>[
      IconPathElement(
        'M13.5 22H7a1 1 0 0 1-1-1v-6a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v.5',
      ), // key: qeb09x
      IconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
      IconPathElement(
        'M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v2',
      ), // key: 1md90i
      IconPathElement('M6 9V3a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v6'), // key: 1itne7
    ],
  );

  /// `printer-x.mjs`
  static const LucideGlyph printerX = LucideGlyph('printer-x', <IconElement>[
    IconPathElement(
      'M12.531 22H7a1 1 0 0 1-1-1v-6a1 1 0 0 1 1-1h6.377',
    ), // key: 1w39xo
    IconPathElement('m16.5 16.5 5 5'), // key: zc9lw7
    IconPathElement('m16.5 21.5 5-5'), // key: 1fr29m
    IconPathElement(
      'M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v1.5',
    ), // key: 18he39
    IconPathElement('M6 9V3a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v6'), // key: 1itne7
  ]);

  /// `printer.mjs`
  static const LucideGlyph printer = LucideGlyph('printer', <IconElement>[
    IconPathElement(
      'M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2',
    ), // key: 143wyd
    IconPathElement('M6 9V3a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v6'), // key: 1itne7
    IconRectElement(6, 14, 12, 8, 1), // key: 1ue0tg
  ]);

  /// `projector.mjs`
  static const LucideGlyph projector = LucideGlyph('projector', <IconElement>[
    IconPathElement('M5 7 3 5'), // key: 1yys58
    IconPathElement('M9 6V3'), // key: 1ptz9u
    IconPathElement('m13 7 2-2'), // key: 1w3vmq
    IconCircleElement(9, 13, 3), // key: 1mma13
    IconPathElement(
      'M11.83 12H20a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-4a2 2 0 0 1 2-2h2.17',
    ), // key: 2frwzc
    IconPathElement('M16 16h2'), // key: dnq2od
  ]);

  /// `proportions.mjs`
  static const LucideGlyph proportions = LucideGlyph(
    'proportions',
    <IconElement>[
      IconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
      IconPathElement('M12 9v11'), // key: 1fnkrn
      IconPathElement('M2 9h13a2 2 0 0 1 2 2v9'), // key: 11z3ex
    ],
  );

  /// `puzzle.mjs`
  static const LucideGlyph puzzle = LucideGlyph('puzzle', <IconElement>[
    IconPathElement(
      'M15.39 4.39a1 1 0 0 0 1.68-.474 2.5 2.5 0 1 1 3.014 3.015 1 1 0 0 0-.474 1.68l1.683 1.682a2.414 2.414 0 0 1 0 3.414L19.61 15.39a1 1 0 0 1-1.68-.474 2.5 2.5 0 1 0-3.014 3.015 1 1 0 0 1 .474 1.68l-1.683 1.682a2.414 2.414 0 0 1-3.414 0L8.61 19.61a1 1 0 0 0-1.68.474 2.5 2.5 0 1 1-3.014-3.015 1 1 0 0 0 .474-1.68l-1.683-1.682a2.414 2.414 0 0 1 0-3.414L4.39 8.61a1 1 0 0 1 1.68.474 2.5 2.5 0 1 0 3.014-3.015 1 1 0 0 1-.474-1.68l1.683-1.682a2.414 2.414 0 0 1 3.414 0z',
    ), // key: w46dr5
  ]);

  /// `pyramid.mjs`
  static const LucideGlyph pyramid = LucideGlyph('pyramid', <IconElement>[
    IconPathElement(
      'M2.5 16.88a1 1 0 0 1-.32-1.43l9-13.02a1 1 0 0 1 1.64 0l9 13.01a1 1 0 0 1-.32 1.44l-8.51 4.86a2 2 0 0 1-1.98 0Z',
    ), // key: aenxs0
    IconPathElement('M12 2v20'), // key: t6zp3m
  ]);

  /// `qr-code.mjs`
  static const LucideGlyph qrCode = LucideGlyph('qr-code', <IconElement>[
    IconRectElement(3, 3, 5, 5, 1), // key: 1tu5fj
    IconRectElement(16, 3, 5, 5, 1), // key: 1v8r4q
    IconRectElement(3, 16, 5, 5, 1), // key: 1x03jg
    IconPathElement('M21 16h-3a2 2 0 0 0-2 2v3'), // key: 177gqh
    IconPathElement('M21 21v.01'), // key: ents32
    IconPathElement('M12 7v3a2 2 0 0 1-2 2H7'), // key: 8crl2c
    IconPathElement('M3 12h.01'), // key: nlz23k
    IconPathElement('M12 3h.01'), // key: n36tog
    IconPathElement('M12 16v.01'), // key: 133mhm
    IconPathElement('M16 12h1'), // key: 1slzba
    IconPathElement('M21 12v.01'), // key: 1lwtk9
    IconPathElement('M12 21v-1'), // key: 1880an
  ]);

  /// `quote.mjs`
  static const LucideGlyph quote = LucideGlyph('quote', <IconElement>[
    IconPathElement(
      'M16 3a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2 1 1 0 0 1 1 1v1a2 2 0 0 1-2 2 1 1 0 0 0-1 1v2a1 1 0 0 0 1 1 6 6 0 0 0 6-6V5a2 2 0 0 0-2-2z',
    ), // key: rib7q0
    IconPathElement(
      'M5 3a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2 1 1 0 0 1 1 1v1a2 2 0 0 1-2 2 1 1 0 0 0-1 1v2a1 1 0 0 0 1 1 6 6 0 0 0 6-6V5a2 2 0 0 0-2-2z',
    ), // key: 1ymkrd
  ]);

  /// `rabbit.mjs`
  static const LucideGlyph rabbit = LucideGlyph('rabbit', <IconElement>[
    IconPathElement('M13 16a3 3 0 0 1 2.24 5'), // key: 1epib5
    IconPathElement('M18 12h.01'), // key: yjnet6
    IconPathElement(
      'M18 21h-8a4 4 0 0 1-4-4 7 7 0 0 1 7-7h.2L9.6 6.4a1 1 0 1 1 2.8-2.8L15.8 7h.2c3.3 0 6 2.7 6 6v1a2 2 0 0 1-2 2h-1a3 3 0 0 0-3 3',
    ), // key: ue9ozu
    IconPathElement('M20 8.54V4a2 2 0 1 0-4 0v3'), // key: 49iql8
    IconPathElement('M7.612 12.524a3 3 0 1 0-1.6 4.3'), // key: 1e33i0
  ]);

  /// `radar.mjs`
  static const LucideGlyph radar = LucideGlyph('radar', <IconElement>[
    IconPathElement('M19.07 4.93A10 10 0 0 0 6.99 3.34'), // key: z3du51
    IconPathElement('M4 6h.01'), // key: oypzma
    IconPathElement('M2.29 9.62A10 10 0 1 0 21.31 8.35'), // key: qzzz0
    IconPathElement('M16.24 7.76A6 6 0 1 0 8.23 16.67'), // key: 1yjesh
    IconPathElement('M12 18h.01'), // key: mhygvu
    IconPathElement('M17.99 11.66A6 6 0 0 1 15.77 16.67'), // key: 1u2y91
    IconCircleElement(12, 12, 2), // key: 1c9p78
    IconPathElement('m13.41 10.59 5.66-5.66'), // key: mhq4k0
  ]);

  /// `radiation.mjs`
  static const LucideGlyph radiation = LucideGlyph('radiation', <IconElement>[
    IconPathElement('M12 12h.01'), // key: 1mp3jc
    IconPathElement(
      'M14 15.4641a4 4 0 0 1-4 0L7.52786 19.74597 A 1 1 0 0 0 7.99303 21.16211 10 10 0 0 0 16.00697 21.16211 1 1 0 0 0 16.47214 19.74597z',
    ), // key: 1y4lzb
    IconPathElement(
      'M16 12a4 4 0 0 0-2-3.464l2.472-4.282a1 1 0 0 1 1.46-.305 10 10 0 0 1 4.006 6.94A1 1 0 0 1 21 12z',
    ), // key: 163ggk
    IconPathElement(
      'M8 12a4 4 0 0 1 2-3.464L7.528 4.254a1 1 0 0 0-1.46-.305 10 10 0 0 0-4.006 6.94A1 1 0 0 0 3 12z',
    ), // key: 1l9i0b
  ]);

  /// `radical.mjs`
  static const LucideGlyph radical = LucideGlyph('radical', <IconElement>[
    IconPathElement(
      'M3 12h3.28a1 1 0 0 1 .948.684l2.298 7.934a.5.5 0 0 0 .96-.044L13.82 4.771A1 1 0 0 1 14.792 4H21',
    ), // key: 1mqj8i
  ]);

  /// `radio-off.mjs`
  static const LucideGlyph radioOff = LucideGlyph('radio-off', <IconElement>[
    IconPathElement('M13.414 13.414a2 2 0 1 1-2.828-2.828'), // key: srl686
    IconPathElement('M16.247 7.761a6 6 0 0 1 1.744 4.572'), // key: 1h86sp
    IconPathElement('M19.075 4.933a10 10 0 0 1 2.234 10.72'), // key: 1n13k4
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement('M4.925 19.067a10 10 0 0 1 0-14.134'), // key: 1q22gi
    IconPathElement('M7.753 16.239a6 6 0 0 1 0-8.478'), // key: r2q7qm
  ]);

  /// `radio-receiver.mjs`
  static const LucideGlyph radioReceiver = LucideGlyph(
    'radio-receiver',
    <IconElement>[
      IconPathElement('M5 16v2'), // key: g5qcv5
      IconPathElement('M19 16v2'), // key: 1gbaio
      IconRectElement(2, 8, 20, 8, 2), // key: vjsjur
      IconPathElement('M18 12h.01'), // key: yjnet6
    ],
  );

  /// `radio-tower.mjs`
  static const LucideGlyph radioTower = LucideGlyph(
    'radio-tower',
    <IconElement>[
      IconPathElement('M4.9 16.1C1 12.2 1 5.8 4.9 1.9'), // key: s0qx1y
      IconPathElement('M7.8 4.7a6.14 6.14 0 0 0-.8 7.5'), // key: 1idnkw
      IconCircleElement(12, 9, 2), // key: 1092wv
      IconPathElement('M16.2 4.8c2 2 2.26 5.11.8 7.47'), // key: ojru2q
      IconPathElement('M19.1 1.9a9.96 9.96 0 0 1 0 14.1'), // key: rhi7fg
      IconPathElement('M9.5 18h5'), // key: mfy3pd
      IconPathElement('m8 22 4-11 4 11'), // key: 25yftu
    ],
  );

  /// `radio.mjs`
  static const LucideGlyph radio = LucideGlyph('radio', <IconElement>[
    IconPathElement('M16.247 7.761a6 6 0 0 1 0 8.478'), // key: 1fwjs5
    IconPathElement('M19.075 4.933a10 10 0 0 1 0 14.134'), // key: ehdyv1
    IconPathElement('M4.925 19.067a10 10 0 0 1 0-14.134'), // key: 1q22gi
    IconPathElement('M7.753 16.239a6 6 0 0 1 0-8.478'), // key: r2q7qm
    IconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `radius.mjs`
  static const LucideGlyph radius = LucideGlyph('radius', <IconElement>[
    IconPathElement('M20.34 17.52a10 10 0 1 0-2.82 2.82'), // key: fydyku
    IconCircleElement(19, 19, 2), // key: 17f5cg
    IconPathElement('m13.41 13.41 4.18 4.18'), // key: 1gqbwc
    IconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `rainbow.mjs`
  static const LucideGlyph rainbow = LucideGlyph('rainbow', <IconElement>[
    IconPathElement('M22 17a10 10 0 0 0-20 0'), // key: ozegv
    IconPathElement('M6 17a6 6 0 0 1 12 0'), // key: 5giftw
    IconPathElement('M10 17a2 2 0 0 1 4 0'), // key: gnsikk
  ]);

  /// `rat.mjs`
  static const LucideGlyph rat = LucideGlyph('rat', <IconElement>[
    IconPathElement('M13 22H4a2 2 0 0 1 0-4h12'), // key: bt3f23
    IconPathElement('M13.236 18a3 3 0 0 0-2.2-5'), // key: 1tbvmo
    IconPathElement('M16 9h.01'), // key: 1bdo4e
    IconPathElement(
      'M16.82 3.94a3 3 0 1 1 3.237 4.868l1.815 2.587a1.5 1.5 0 0 1-1.5 2.1l-2.872-.453a3 3 0 0 0-3.5 3',
    ), // key: 9ch7kn
    IconPathElement(
      'M17 4.988a3 3 0 1 0-5.2 2.052A7 7 0 0 0 4 14.015 4 4 0 0 0 8 18',
    ), // key: 3s7e9i
  ]);

  /// `ratio.mjs`
  static const LucideGlyph ratio = LucideGlyph('ratio', <IconElement>[
    IconRectElement(6, 2, 12, 20, 2), // key: 1oxtiu
    IconRectElement(2, 6, 20, 12, 2), // key: 9lu3g6
  ]);

  /// `receipt-cent.mjs`
  static const LucideGlyph
  receiptCent = LucideGlyph('receipt-cent', <IconElement>[
    IconPathElement('M12 7v10'), // key: jspqdw
    IconPathElement(
      'M14.828 14.829a4 4 0 0 1-5.656 0 4 4 0 0 1 0-5.657 4 4 0 0 1 5.656 0',
    ), // key: qvqont
    IconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
  ]);

  /// `receipt-euro.mjs`
  static const LucideGlyph
  receiptEuro = LucideGlyph('receipt-euro', <IconElement>[
    IconPathElement(
      'M15.828 14.829a4 4 0 0 1-5.656 0 4 4 0 0 1 0-5.657 4 4 0 0 1 5.656 0',
    ), // key: 16zdw4
    IconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
    IconPathElement('M8 12h5'), // key: 1g6qi8
  ]);

  /// `receipt-indian-rupee.mjs`
  static const LucideGlyph
  receiptIndianRupee = LucideGlyph('receipt-indian-rupee', <IconElement>[
    IconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
    IconPathElement('M8 11h8'), // key: vwpz6n
    IconPathElement('M8 7h8'), // key: i86dvs
    IconPathElement('M9 7a4 4 0 0 1 0 8H8l3 2'), // key: 1xaco0
  ]);

  /// `receipt-japanese-yen.mjs`
  static const LucideGlyph
  receiptJapaneseYen = LucideGlyph('receipt-japanese-yen', <IconElement>[
    IconPathElement('m12 10 3-3'), // key: 1mc12w
    IconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
    IconPathElement('M9 11h6'), // key: 1fldmi
    IconPathElement('M9 15h6'), // key: cctwl0
    IconPathElement('m9 7 3 3v7'), // key: 1x0cue
  ]);

  /// `receipt-pound-sterling.mjs`
  static const LucideGlyph
  receiptPoundSterling = LucideGlyph('receipt-pound-sterling', <IconElement>[
    IconPathElement('M10 17V9.5a1 1 0 0 1 5 0'), // key: td22vl
    IconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
    IconPathElement('M8 13h5'), // key: 1k9z8w
    IconPathElement('M8 17h7'), // key: 8mjdqu
  ]);

  /// `receipt-russian-ruble.mjs`
  static const LucideGlyph
  receiptRussianRuble = LucideGlyph('receipt-russian-ruble', <IconElement>[
    IconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
    IconPathElement('M8 11h5a2 2 0 0 0 0-4h-3v10'), // key: agnv0r
    IconPathElement('M8 15h5'), // key: vxg57a
  ]);

  /// `receipt-swiss-franc.mjs`
  static const LucideGlyph
  receiptSwissFranc = LucideGlyph('receipt-swiss-franc', <IconElement>[
    IconPathElement('M10 11h4'), // key: 1i0mka
    IconPathElement('M10 17V7h5'), // key: k7jq18
    IconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
    IconPathElement('M8 15h5'), // key: vxg57a
  ]);

  /// `receipt-text.mjs`
  static const LucideGlyph
  receiptText = LucideGlyph('receipt-text', <IconElement>[
    IconPathElement('M13 16H8'), // key: wsln4y
    IconPathElement('M14 8H8'), // key: 1l3xfs
    IconPathElement('M16 12H8'), // key: 1fr5h0
    IconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
  ]);

  /// `receipt-turkish-lira.mjs`
  static const LucideGlyph
  receiptTurkishLira = LucideGlyph('receipt-turkish-lira', <IconElement>[
    IconPathElement('M10 7v10a5 5 0 0 0 5-5'), // key: 1blmz7
    IconPathElement('m14 8-6 3'), // key: 2tb98i
    IconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
  ]);

  /// `receipt.mjs`
  static const LucideGlyph receipt = LucideGlyph('receipt', <IconElement>[
    IconPathElement('M12 17V7'), // key: pyj7ub
    IconPathElement('M16 8h-6a2 2 0 0 0 0 4h4a2 2 0 0 1 0 4H8'), // key: 1elt7d
    IconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
  ]);

  /// `rectangle-circle.mjs`
  static const LucideGlyph
  rectangleCircle = LucideGlyph('rectangle-circle', <IconElement>[
    IconPathElement('M14 4v16H3a1 1 0 0 1-1-1V5a1 1 0 0 1 1-1z'), // key: 1m5n7q
    IconCircleElement(14, 12, 8), // key: 1pag6k
  ]);

  /// `rectangle-ellipsis.mjs`
  static const LucideGlyph rectangleEllipsis = LucideGlyph(
    'rectangle-ellipsis',
    <IconElement>[
      IconRectElement(2, 6, 20, 12, 2), // key: 9lu3g6
      IconPathElement('M12 12h.01'), // key: 1mp3jc
      IconPathElement('M17 12h.01'), // key: 1m0b6t
      IconPathElement('M7 12h.01'), // key: eqddd0
    ],
  );

  /// `rectangle-goggles.mjs`
  static const LucideGlyph
  rectangleGoggles = LucideGlyph('rectangle-goggles', <IconElement>[
    IconPathElement(
      'M20 6a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-4a2 2 0 0 1-1.6-.8l-1.6-2.13a1 1 0 0 0-1.6 0L9.6 17.2A2 2 0 0 1 8 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2z',
    ), // key: d5y1f
  ]);

  /// `rectangle-horizontal.mjs`
  static const LucideGlyph rectangleHorizontal = LucideGlyph(
    'rectangle-horizontal',
    <IconElement>[
      IconRectElement(2, 6, 20, 12, 2), // key: 9lu3g6
    ],
  );

  /// `rectangle-vertical.mjs`
  static const LucideGlyph rectangleVertical = LucideGlyph(
    'rectangle-vertical',
    <IconElement>[
      IconRectElement(6, 2, 12, 20, 2), // key: 1oxtiu
    ],
  );

  /// `recycle.mjs`
  static const LucideGlyph recycle = LucideGlyph('recycle', <IconElement>[
    IconPathElement(
      'M7 19H4.815a1.83 1.83 0 0 1-1.57-.881 1.785 1.785 0 0 1-.004-1.784L7.196 9.5',
    ), // key: x6z5xu
    IconPathElement(
      'M11 19h8.203a1.83 1.83 0 0 0 1.556-.89 1.784 1.784 0 0 0 0-1.775l-1.226-2.12',
    ), // key: 1x4zh5
    IconPathElement('m14 16-3 3 3 3'), // key: f6jyew
    IconPathElement('M8.293 13.596 7.196 9.5 3.1 10.598'), // key: wf1obh
    IconPathElement(
      'm9.344 5.811 1.093-1.892A1.83 1.83 0 0 1 11.985 3a1.784 1.784 0 0 1 1.546.888l3.943 6.843',
    ), // key: 9tzpgr
    IconPathElement('m13.378 9.633 4.096 1.098 1.097-4.096'), // key: 1oe83g
  ]);

  /// `redo-2.mjs`
  static const LucideGlyph redo2 = LucideGlyph('redo-2', <IconElement>[
    IconPathElement('m15 14 5-5-5-5'), // key: 12vg1m
    IconPathElement(
      'M20 9H9.5A5.5 5.5 0 0 0 4 14.5A5.5 5.5 0 0 0 9.5 20H13',
    ), // key: 6uklza
  ]);

  /// `redo-dot.mjs`
  static const LucideGlyph redoDot = LucideGlyph('redo-dot', <IconElement>[
    IconCircleElement(12, 17, 1), // key: 1ixnty
    IconPathElement('M21 7v6h-6'), // key: 3ptur4
    IconPathElement('M3 17a9 9 0 0 1 9-9 9 9 0 0 1 6 2.3l3 2.7'), // key: 1kgawr
  ]);

  /// `redo.mjs`
  static const LucideGlyph redo = LucideGlyph('redo', <IconElement>[
    IconPathElement('M21 7v6h-6'), // key: 3ptur4
    IconPathElement('M3 17a9 9 0 0 1 9-9 9 9 0 0 1 6 2.3l3 2.7'), // key: 1kgawr
  ]);

  /// `refresh-ccw-dot.mjs`
  static const LucideGlyph refreshCcwDot = LucideGlyph(
    'refresh-ccw-dot',
    <IconElement>[
      IconPathElement(
        'M21 12a9 9 0 0 0-9-9 9.75 9.75 0 0 0-6.74 2.74L3 8',
      ), // key: 14sxne
      IconPathElement('M3 3v5h5'), // key: 1xhq8a
      IconPathElement(
        'M3 12a9 9 0 0 0 9 9 9.75 9.75 0 0 0 6.74-2.74L21 16',
      ), // key: 1hlbsb
      IconPathElement('M16 16h5v5'), // key: ccwih5
      IconCircleElement(12, 12, 1), // key: 41hilf
    ],
  );

  /// `refresh-ccw.mjs`
  static const LucideGlyph refreshCcw = LucideGlyph(
    'refresh-ccw',
    <IconElement>[
      IconPathElement(
        'M21 12a9 9 0 0 0-9-9 9.75 9.75 0 0 0-6.74 2.74L3 8',
      ), // key: 14sxne
      IconPathElement('M3 3v5h5'), // key: 1xhq8a
      IconPathElement(
        'M3 12a9 9 0 0 0 9 9 9.75 9.75 0 0 0 6.74-2.74L21 16',
      ), // key: 1hlbsb
      IconPathElement('M16 16h5v5'), // key: ccwih5
    ],
  );

  /// `refresh-cw-off.mjs`
  static const LucideGlyph refreshCwOff = LucideGlyph(
    'refresh-cw-off',
    <IconElement>[
      IconPathElement(
        'M21 8L18.74 5.74A9.75 9.75 0 0 0 12 3C11 3 10.03 3.16 9.13 3.47',
      ), // key: 1krf6h
      IconPathElement('M8 16H3v5'), // key: 1cv678
      IconPathElement('M3 12C3 9.51 4 7.26 5.64 5.64'), // key: ruvoct
      IconPathElement(
        'm3 16 2.26 2.26A9.75 9.75 0 0 0 12 21c2.49 0 4.74-1 6.36-2.64',
      ), // key: 19q130
      IconPathElement('M21 12c0 1-.16 1.97-.47 2.87'), // key: 4w8emr
      IconPathElement('M21 3v5h-5'), // key: 1q7to0
      IconPathElement('M22 22 2 2'), // key: 1r8tn9
    ],
  );

  /// `refresh-cw.mjs`
  static const LucideGlyph refreshCw = LucideGlyph('refresh-cw', <IconElement>[
    IconPathElement(
      'M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8',
    ), // key: v9h5vc
    IconPathElement('M21 3v5h-5'), // key: 1q7to0
    IconPathElement(
      'M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16',
    ), // key: 3uifl3
    IconPathElement('M8 16H3v5'), // key: 1cv678
  ]);

  /// `refrigerator.mjs`
  static const LucideGlyph
  refrigerator = LucideGlyph('refrigerator', <IconElement>[
    IconPathElement(
      'M5 6a4 4 0 0 1 4-4h6a4 4 0 0 1 4 4v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6Z',
    ), // key: fpq118
    IconPathElement('M5 10h14'), // key: elsbfy
    IconPathElement('M15 7v6'), // key: 1nx30x
  ]);

  /// `regex.mjs`
  static const LucideGlyph regex = LucideGlyph('regex', <IconElement>[
    IconPathElement('M17 3v10'), // key: 15fgeh
    IconPathElement('m12.67 5.5 8.66 5'), // key: 1gpheq
    IconPathElement('m12.67 10.5 8.66-5'), // key: 1dkfa6
    IconPathElement(
      'M9 17a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v2a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2v-2z',
    ), // key: swwfx4
  ]);

  /// `remove-formatting.mjs`
  static const LucideGlyph removeFormatting = LucideGlyph(
    'remove-formatting',
    <IconElement>[
      IconPathElement('M4 7V4h16v3'), // key: 9msm58
      IconPathElement('M5 20h6'), // key: 1h6pxn
      IconPathElement('M13 4 8 20'), // key: kqq6aj
      IconPathElement('m15 15 5 5'), // key: me55sn
      IconPathElement('m20 15-5 5'), // key: 11p7ol
    ],
  );

  /// `repeat-1.mjs`
  static const LucideGlyph repeat1 = LucideGlyph('repeat-1', <IconElement>[
    IconPathElement('m17 2 4 4-4 4'), // key: nntrym
    IconPathElement('M3 11v-1a4 4 0 0 1 4-4h14'), // key: 84bu3i
    IconPathElement('m7 22-4-4 4-4'), // key: 1wqhfi
    IconPathElement('M21 13v1a4 4 0 0 1-4 4H3'), // key: 1rx37r
    IconPathElement('M11 10h1v4'), // key: 70cz1p
  ]);

  /// `repeat-2.mjs`
  static const LucideGlyph repeat2 = LucideGlyph('repeat-2', <IconElement>[
    IconPathElement('m2 9 3-3 3 3'), // key: 1ltn5i
    IconPathElement('M13 18H7a2 2 0 0 1-2-2V6'), // key: 1r6tfw
    IconPathElement('m22 15-3 3-3-3'), // key: 4rnwn2
    IconPathElement('M11 6h6a2 2 0 0 1 2 2v10'), // key: 2f72bc
  ]);

  /// `repeat-off.mjs`
  static const LucideGlyph repeatOff = LucideGlyph('repeat-off', <IconElement>[
    IconPathElement('M11.656 6H21l-4-4'), // key: w9pozh
    IconPathElement('M17.898 17.898A4 4 0 0 1 17 18H3l4-4'), // key: 156mfe
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement('M21 13v1a4 4 0 0 1-.171 1.159'), // key: 2p1713
    IconPathElement('m21 6-4 4'), // key: p7opkf
    IconPathElement('M3 11v-1a4 4 0 0 1 3.102-3.898'), // key: 8cius9
    IconPathElement('m7 22-4-4'), // key: 1kl3a3
  ]);

  /// `repeat.mjs`
  static const LucideGlyph repeat = LucideGlyph('repeat', <IconElement>[
    IconPathElement('m17 2 4 4-4 4'), // key: nntrym
    IconPathElement('M3 11v-1a4 4 0 0 1 4-4h14'), // key: 84bu3i
    IconPathElement('m7 22-4-4 4-4'), // key: 1wqhfi
    IconPathElement('M21 13v1a4 4 0 0 1-4 4H3'), // key: 1rx37r
  ]);

  /// `replace-all.mjs`
  static const LucideGlyph replaceAll = LucideGlyph(
    'replace-all',
    <IconElement>[
      IconPathElement('M14 14a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1'), // key: zg1ipl
      IconPathElement('M14 4a1 1 0 0 1 1-1'), // key: dhj8ez
      IconPathElement('M15 10a1 1 0 0 1-1-1'), // key: 1mnyi5
      IconPathElement('M19 14a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1'), // key: txt6k4
      IconPathElement('M21 4a1 1 0 0 0-1-1'), // key: sfs9ap
      IconPathElement('M21 9a1 1 0 0 1-1 1'), // key: mp6qeo
      IconPathElement('m3 7 3 3 3-3'), // key: x25e72
      IconPathElement('M6 10V5a2 2 0 0 1 2-2h2'), // key: 15xut4
      IconRectElement(3, 14, 7, 7, 1), // key: 1bkyp8
    ],
  );

  /// `replace.mjs`
  static const LucideGlyph replace = LucideGlyph('replace', <IconElement>[
    IconPathElement('M14 4a1 1 0 0 1 1-1'), // key: dhj8ez
    IconPathElement('M15 10a1 1 0 0 1-1-1'), // key: 1mnyi5
    IconPathElement('M21 4a1 1 0 0 0-1-1'), // key: sfs9ap
    IconPathElement('M21 9a1 1 0 0 1-1 1'), // key: mp6qeo
    IconPathElement('m3 7 3 3 3-3'), // key: x25e72
    IconPathElement('M6 10V5a2 2 0 0 1 2-2h2'), // key: 15xut4
    IconRectElement(3, 14, 7, 7, 1), // key: 1bkyp8
  ]);

  /// `reply-all.mjs`
  static const LucideGlyph replyAll = LucideGlyph('reply-all', <IconElement>[
    IconPathElement('m12 17-5-5 5-5'), // key: 1s3y5u
    IconPathElement('M22 18v-2a4 4 0 0 0-4-4H7'), // key: 1fcyog
    IconPathElement('m7 17-5-5 5-5'), // key: 1ed8i2
  ]);

  /// `reply.mjs`
  static const LucideGlyph reply = LucideGlyph('reply', <IconElement>[
    IconPathElement('M20 18v-2a4 4 0 0 0-4-4H4'), // key: 5vmcpk
    IconPathElement('m9 17-5-5 5-5'), // key: nvlc11
  ]);

  /// `rewind.mjs`
  static const LucideGlyph rewind = LucideGlyph('rewind', <IconElement>[
    IconPathElement(
      'M12 6a2 2 0 0 0-3.414-1.414l-6 6a2 2 0 0 0 0 2.828l6 6A2 2 0 0 0 12 18z',
    ), // key: 2a1g8i
    IconPathElement(
      'M22 6a2 2 0 0 0-3.414-1.414l-6 6a2 2 0 0 0 0 2.828l6 6A2 2 0 0 0 22 18z',
    ), // key: rg3s36
  ]);

  /// `ribbon.mjs`
  static const LucideGlyph ribbon = LucideGlyph('ribbon', <IconElement>[
    IconPathElement(
      'M12 11.22C11 9.997 10 9 10 8a2 2 0 0 1 4 0c0 1-.998 2.002-2.01 3.22',
    ), // key: 1rnhq3
    IconPathElement('m12 18 2.57-3.5'), // key: 116vt7
    IconPathElement('M6.243 9.016a7 7 0 0 1 11.507-.009'), // key: 10dq0b
    IconPathElement('M9.35 14.53 12 11.22'), // key: tdsyp2
    IconPathElement(
      'M9.35 14.53C7.728 12.246 6 10.221 6 7a6 5 0 0 1 12 0c-.005 3.22-1.778 5.235-3.43 7.5l3.557 4.527a1 1 0 0 1-.203 1.43l-1.894 1.36a1 1 0 0 1-1.384-.215L12 18l-2.679 3.593a1 1 0 0 1-1.39.213l-1.865-1.353a1 1 0 0 1-.203-1.422z',
    ), // key: nmifey
  ]);

  /// `road.mjs`
  static const LucideGlyph road = LucideGlyph('road', <IconElement>[
    IconPathElement('M12 17v4'), // key: 1riwvh
    IconPathElement('M12 5V3'), // key: vd5es
    IconPathElement('M12 9v3'), // key: qyerrc
    IconPathElement(
      'M2.077 18.449A2 2 0 0 0 4 21h16a2 2 0 0 0 1.924-2.55l-4-14A2 2 0 0 0 16 3H8a2 2 0 0 0-1.924 1.45z',
    ), // key: 1cuxct
  ]);

  /// `rocket.mjs`
  static const LucideGlyph rocket = LucideGlyph('rocket', <IconElement>[
    IconPathElement('M12 15v5s3.03-.55 4-2c1.08-1.62 0-5 0-5'), // key: qeys4
    IconPathElement(
      'M4.5 16.5c-1.5 1.26-2 5-2 5s3.74-.5 5-2c.71-.84.7-2.13-.09-2.91a2.18 2.18 0 0 0-2.91-.09',
    ), // key: u4xsad
    IconPathElement(
      'M9 12a22 22 0 0 1 2-3.95A12.88 12.88 0 0 1 22 2c0 2.72-.78 7.5-6 11a22.4 22.4 0 0 1-4 2z',
    ), // key: 676m9
    IconPathElement(
      'M9 12H4s.55-3.03 2-4c1.62-1.08 5 .05 5 .05',
    ), // key: 92ym6u
  ]);

  /// `rocking-chair.mjs`
  static const LucideGlyph rockingChair = LucideGlyph(
    'rocking-chair',
    <IconElement>[
      IconPathElement('m15 13 3.708 7.416'), // key: 1edxn9
      IconPathElement('M3 19a15 15 0 0 0 18 0'), // key: d0d1c4
      IconPathElement('m3 2 3.21 9.633A2 2 0 0 0 8.109 13H18'), // key: tpa4et
      IconPathElement('m9 13-3.708 7.416'), // key: 1oplxx
    ],
  );

  /// `roller-coaster.mjs`
  static const LucideGlyph rollerCoaster = LucideGlyph(
    'roller-coaster',
    <IconElement>[
      IconPathElement('M6 19V5'), // key: 1r845m
      IconPathElement('M10 19V6.8'), // key: 9j2tfs
      IconPathElement('M14 19v-7.8'), // key: 10s8qv
      IconPathElement('M18 5v4'), // key: 1tajlv
      IconPathElement('M18 19v-6'), // key: ielfq3
      IconPathElement('M22 19V9'), // key: 158nzp
      IconPathElement(
        'M2 19V9a4 4 0 0 1 4-4c2 0 4 1.33 6 4s4 4 6 4a4 4 0 1 0-3-6.65',
      ), // key: 1930oh
    ],
  );

  /// `rose.mjs`
  static const LucideGlyph rose = LucideGlyph('rose', <IconElement>[
    IconPathElement('M17 10h-1a4 4 0 1 1 4-4v.534'), // key: 7qf5zm
    IconPathElement(
      'M17 6h1a4 4 0 0 1 1.42 7.74l-2.29.87a6 6 0 0 1-5.339-10.68l2.069-1.31',
    ), // key: 1et29u
    IconPathElement(
      'M4.5 17c2.8-.5 4.4 0 5.5.8s1.8 2.2 2.3 3.7c-2 .4-3.5.4-4.8-.3-1.2-.6-2.3-1.9-3-4.2',
    ), // key: kiv2lz
    IconPathElement('M9.77 12C4 15 2 22 2 22'), // key: h28rw0
    IconCircleElement(17, 8, 2), // key: 1330xn
  ]);

  /// `rotate-3d.mjs`
  static const LucideGlyph rotate3d = LucideGlyph('rotate-3d', <IconElement>[
    IconPathElement('m15.194 13.707 3.814 1.86-1.86 3.814'), // key: 16shm9
    IconPathElement(
      'M16.47214 7.52786 A 5 10 0 1 0 13 21.79796',
    ), // key: 1245p8
    IconPathElement('M21.79796 11 A 10 5 0 1 0 19 15.57071'), // key: 1i40ks
  ]);

  /// `rotate-ccw-clock.mjs`
  static const LucideGlyph rotateCcwClock = LucideGlyph(
    'rotate-ccw-clock',
    <IconElement>[
      IconPathElement(
        'M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8',
      ), // key: 1357e3
      IconPathElement('M3 3v5h5'), // key: 1xhq8a
      IconPathElement('M12 7v5l4 2'), // key: 1fdv2h
    ],
  );

  /// `rotate-ccw-key.mjs`
  static const LucideGlyph rotateCcwKey = LucideGlyph(
    'rotate-ccw-key',
    <IconElement>[
      IconPathElement('M12 7v6'), // key: lw1j43
      IconPathElement('M12 9h2'), // key: 1lpap9
      IconPathElement(
        'M3 12a9 9 0 1 0 9-9 9.74 9.74 0 0 0-6.74 2.74L3 8',
      ), // key: g2jlw
      IconPathElement('M3 3v5h5'), // key: 1xhq8a
      IconCircleElement(12, 15, 2), // key: 1vpstw
    ],
  );

  /// `rotate-ccw-square.mjs`
  static const LucideGlyph rotateCcwSquare = LucideGlyph(
    'rotate-ccw-square',
    <IconElement>[
      IconPathElement('M20 9V7a2 2 0 0 0-2-2h-6'), // key: 19z8uc
      IconPathElement('m15 2-3 3 3 3'), // key: 177bxs
      IconPathElement(
        'M20 13v5a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2h2',
      ), // key: d36hnl
    ],
  );

  /// `rotate-ccw.mjs`
  static const LucideGlyph rotateCcw = LucideGlyph('rotate-ccw', <IconElement>[
    IconPathElement(
      'M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8',
    ), // key: 1357e3
    IconPathElement('M3 3v5h5'), // key: 1xhq8a
  ]);

  /// `rotate-cw-fading-clock.mjs`
  static const LucideGlyph rotateCwFadingClock = LucideGlyph(
    'rotate-cw-fading-clock',
    <IconElement>[
      IconPathElement('M12 3a9.75 9.75 0 0 1 6.74 2.74'), // key: 1k3kxf
      IconPathElement('M18.74 5.74 21 8'), // key: 1eb40o
      IconPathElement('M21 8V3'), // key: 1et280
      IconPathElement('M7.5 19.794c-6-3.464-6-12.124 0-15.588'), // key: 19r0lp
      IconPathElement('M7.5 4.206A9 9 0 0 1 12 3'), // key: s8r11
      IconPathElement('M12 7v5l4 2'), // key: 1fdv2h
      IconPathElement('M14 20.775A9 9 0 0 1 12 21'), // key: 184rgu
      IconPathElement('M19 17.656a9 9 0 0 1-1.5 1.456'), // key: 7qgp6l
      IconPathElement('M21 12a9 9 0 0 1-.228 2'), // key: 1h378y
      IconPathElement('M21 8h-5'), // key: k0yzmk
    ],
  );

  /// `rotate-cw-square.mjs`
  static const LucideGlyph rotateCwSquare = LucideGlyph(
    'rotate-cw-square',
    <IconElement>[
      IconPathElement('M12 5H6a2 2 0 0 0-2 2v3'), // key: l96uqu
      IconPathElement('m9 8 3-3-3-3'), // key: 1gzgc3
      IconPathElement(
        'M4 14v4a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2',
      ), // key: 1w2k5h
    ],
  );

  /// `rotate-cw.mjs`
  static const LucideGlyph rotateCw = LucideGlyph('rotate-cw', <IconElement>[
    IconPathElement(
      'M21 12a9 9 0 1 1-9-9c2.52 0 4.93 1 6.74 2.74L21 8',
    ), // key: 1p45f6
    IconPathElement('M21 3v5h-5'), // key: 1q7to0
  ]);

  /// `route-off.mjs`
  static const LucideGlyph routeOff = LucideGlyph('route-off', <IconElement>[
    IconCircleElement(6, 19, 3), // key: 1kj8tv
    IconPathElement('M9 19h8.5c.4 0 .9-.1 1.3-.2'), // key: 1effex
    IconPathElement('M5.2 5.2A3.5 3.53 0 0 0 6.5 12H12'), // key: k9y2ds
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement('M21 15.3a3.5 3.5 0 0 0-3.3-3.3'), // key: 11nlu2
    IconPathElement('M15 5h-4.3'), // key: 6537je
    IconCircleElement(18, 5, 3), // key: gq8acd
  ]);

  /// `route.mjs`
  static const LucideGlyph route = LucideGlyph('route', <IconElement>[
    IconCircleElement(6, 19, 3), // key: 1kj8tv
    IconPathElement(
      'M9 19h8.5a3.5 3.5 0 0 0 0-7h-11a3.5 3.5 0 0 1 0-7H15',
    ), // key: 1d8sl
    IconCircleElement(18, 5, 3), // key: gq8acd
  ]);

  /// `router.mjs`
  static const LucideGlyph router = LucideGlyph('router', <IconElement>[
    IconRectElement(2, 14, 20, 8, 2), // key: w68u3i
    IconPathElement('M6.01 18H6'), // key: 19vcac
    IconPathElement('M10.01 18H10'), // key: uamcmx
    IconPathElement('M15 10v4'), // key: qjz1xs
    IconPathElement('M17.84 7.17a4 4 0 0 0-5.66 0'), // key: 1rif40
    IconPathElement('M20.66 4.34a8 8 0 0 0-11.31 0'), // key: 6a5xfq
  ]);

  /// `rows-2.mjs`
  static const LucideGlyph rows2 = LucideGlyph('rows-2', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    IconPathElement('M3 12h18'), // key: 1i2n21
  ]);

  /// `rows-3.mjs`
  static const LucideGlyph rows3 = LucideGlyph('rows-3', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    IconPathElement('M21 9H3'), // key: 1338ky
    IconPathElement('M21 15H3'), // key: 9uk58r
  ]);

  /// `rows-4.mjs`
  static const LucideGlyph rows4 = LucideGlyph('rows-4', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    IconPathElement('M21 7.5H3'), // key: 1hm9pq
    IconPathElement('M21 12H3'), // key: 2avoz0
    IconPathElement('M21 16.5H3'), // key: n7jzkj
  ]);

  /// `rss.mjs`
  static const LucideGlyph rss = LucideGlyph('rss', <IconElement>[
    IconPathElement('M4 11a9 9 0 0 1 9 9'), // key: pv89mb
    IconPathElement('M4 4a16 16 0 0 1 16 16'), // key: k0647b
    IconCircleElement(5, 19, 1), // key: bfqh0e
  ]);

  /// `ruler-dimension-line.mjs`
  static const LucideGlyph rulerDimensionLine = LucideGlyph(
    'ruler-dimension-line',
    <IconElement>[
      IconPathElement('M10 15v-3'), // key: 1pjskw
      IconPathElement('M14 15v-3'), // key: 1o1mqj
      IconPathElement('M18 15v-3'), // key: cws6he
      IconPathElement('M2 8V4'), // key: 3jv1jz
      IconPathElement('M22 6H2'), // key: 1iqbfk
      IconPathElement('M22 8V4'), // key: 16f4ou
      IconPathElement('M6 15v-3'), // key: 1ij1qe
      IconRectElement(2, 12, 20, 8, 2), // key: 1tqiko
    ],
  );

  /// `ruler.mjs`
  static const LucideGlyph ruler = LucideGlyph('ruler', <IconElement>[
    IconPathElement(
      'M21.3 15.3a2.4 2.4 0 0 1 0 3.4l-2.6 2.6a2.4 2.4 0 0 1-3.4 0L2.7 8.7a2.41 2.41 0 0 1 0-3.4l2.6-2.6a2.41 2.41 0 0 1 3.4 0Z',
    ), // key: icamh8
    IconPathElement('m14.5 12.5 2-2'), // key: inckbg
    IconPathElement('m11.5 9.5 2-2'), // key: fmmyf7
    IconPathElement('m8.5 6.5 2-2'), // key: vc6u1g
    IconPathElement('m17.5 15.5 2-2'), // key: wo5hmg
  ]);

  /// `russian-ruble.mjs`
  static const LucideGlyph russianRuble = LucideGlyph(
    'russian-ruble',
    <IconElement>[
      IconPathElement('M6 11h8a4 4 0 0 0 0-8H9v18'), // key: 18ai8t
      IconPathElement('M6 15h8'), // key: 1y8f6l
    ],
  );

  /// `sailboat.mjs`
  static const LucideGlyph sailboat = LucideGlyph('sailboat', <IconElement>[
    IconPathElement('M10 2v15'), // key: 1qf71f
    IconPathElement(
      'M7 22a4 4 0 0 1-4-4 1 1 0 0 1 1-1h16a1 1 0 0 1 1 1 4 4 0 0 1-4 4z',
    ), // key: 1pxcvx
    IconPathElement(
      'M9.159 2.46a1 1 0 0 1 1.521-.193l9.977 8.98A1 1 0 0 1 20 13H4a1 1 0 0 1-.824-1.567z',
    ), // key: 5oog16
  ]);

  /// `salad.mjs`
  static const LucideGlyph salad = LucideGlyph('salad', <IconElement>[
    IconPathElement('M7 21h10'), // key: 1b0cd5
    IconPathElement('M12 21a9 9 0 0 0 9-9H3a9 9 0 0 0 9 9Z'), // key: 4rw317
    IconPathElement(
      'M11.38 12a2.4 2.4 0 0 1-.4-4.77 2.4 2.4 0 0 1 3.2-2.77 2.4 2.4 0 0 1 3.47-.63 2.4 2.4 0 0 1 3.37 3.37 2.4 2.4 0 0 1-1.1 3.7 2.51 2.51 0 0 1 .03 1.1',
    ), // key: 10xrj0
    IconPathElement('m13 12 4-4'), // key: 1hckqy
    IconPathElement(
      'M10.9 7.25A3.99 3.99 0 0 0 4 10c0 .73.2 1.41.54 2',
    ), // key: 1p4srx
  ]);

  /// `sandwich.mjs`
  static const LucideGlyph sandwich = LucideGlyph('sandwich', <IconElement>[
    IconPathElement(
      'm2.37 11.223 8.372-6.777a2 2 0 0 1 2.516 0l8.371 6.777',
    ), // key: f1wd0e
    IconPathElement(
      'M21 15a1 1 0 0 1 1 1v2a1 1 0 0 1-1 1h-5.25',
    ), // key: 1pfu07
    IconPathElement('M3 15a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h9'), // key: 1oq9qw
    IconPathElement(
      'm6.67 15 6.13 4.6a2 2 0 0 0 2.8-.4l3.15-4.2',
    ), // key: 1fnwu5
    IconRectElement(2, 11, 20, 4, 1), // key: itshg
  ]);

  /// `satellite-dish.mjs`
  static const LucideGlyph satelliteDish = LucideGlyph(
    'satellite-dish',
    <IconElement>[
      IconPathElement('M4 10a7.31 7.31 0 0 0 10 10Z'), // key: 1fzpp3
      IconPathElement('m9 15 3-3'), // key: 88sc13
      IconPathElement('M17 13a6 6 0 0 0-6-6'), // key: 15cc6u
      IconPathElement('M21 13A10 10 0 0 0 11 3'), // key: 11nf8s
    ],
  );

  /// `satellite.mjs`
  static const LucideGlyph satellite = LucideGlyph('satellite', <IconElement>[
    IconPathElement(
      'm13.5 6.5-3.148-3.148a1.205 1.205 0 0 0-1.704 0L6.352 5.648a1.205 1.205 0 0 0 0 1.704L9.5 10.5',
    ), // key: dzhfyz
    IconPathElement('M16.5 7.5 19 5'), // key: 1ltcjm
    IconPathElement(
      'm17.5 10.5 3.148 3.148a1.205 1.205 0 0 1 0 1.704l-2.296 2.296a1.205 1.205 0 0 1-1.704 0L13.5 14.5',
    ), // key: nfoymv
    IconPathElement('M9 21a6 6 0 0 0-6-6'), // key: 1iajcf
    IconPathElement(
      'M9.352 10.648a1.205 1.205 0 0 0 0 1.704l2.296 2.296a1.205 1.205 0 0 0 1.704 0l4.296-4.296a1.205 1.205 0 0 0 0-1.704l-2.296-2.296a1.205 1.205 0 0 0-1.704 0z',
    ), // key: nv9zqy
  ]);

  /// `saudi-riyal.mjs`
  static const LucideGlyph
  saudiRiyal = LucideGlyph('saudi-riyal', <IconElement>[
    IconPathElement('m20 19.5-5.5 1.2'), // key: 1aenhr
    IconPathElement('M14.5 4v11.22a1 1 0 0 0 1.242.97L20 15.2'), // key: 2rtezt
    IconPathElement(
      'm2.978 19.351 5.549-1.363A2 2 0 0 0 10 16V2',
    ), // key: 1kbm92
    IconPathElement('M20 10 4 13.5'), // key: 8nums9
  ]);

  /// `save-all.mjs`
  static const LucideGlyph saveAll = LucideGlyph('save-all', <IconElement>[
    IconPathElement('M10 2v3a1 1 0 0 0 1 1h5'), // key: 1xspal
    IconPathElement(
      'M18 18v-6a1 1 0 0 0-1-1h-6a1 1 0 0 0-1 1v6',
    ), // key: 1ra60u
    IconPathElement('M18 22H4a2 2 0 0 1-2-2V6'), // key: pblm9e
    IconPathElement(
      'M8 18a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9.172a2 2 0 0 1 1.414.586l2.828 2.828A2 2 0 0 1 22 6.828V16a2 2 0 0 1-2.01 2z',
    ), // key: 1yve0x
  ]);

  /// `save-check.mjs`
  static const LucideGlyph saveCheck = LucideGlyph('save-check', <IconElement>[
    IconPathElement(
      'M12.5 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h10.2a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4v4.35',
    ), // key: 6jbevg
    IconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
    IconPathElement(
      'M17 15.13V14a1 1 0 0 0-1-1H8a1 1 0 0 0-1 1v7',
    ), // key: 1bzeol
    IconPathElement('M7 3v4a1 1 0 0 0 1 1h7'), // key: t51u73
  ]);

  /// `save-off.mjs`
  static const LucideGlyph saveOff = LucideGlyph('save-off', <IconElement>[
    IconPathElement('M13 13H8a1 1 0 0 0-1 1v7'), // key: h8g396
    IconPathElement('M14 8h1'), // key: 1lfen6
    IconPathElement('M17 21v-4'), // key: 1yknxs
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement(
      'M20.41 20.41A2 2 0 0 1 19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 .59-1.41',
    ), // key: 1t4vdl
    IconPathElement('M29.5 11.5s5 5 4 5'), // key: zzn4i6
    IconPathElement(
      'M9 3h6.2a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4V15',
    ), // key: 24cby9
  ]);

  /// `save-pen.mjs`
  static const LucideGlyph savePen = LucideGlyph('save-pen', <IconElement>[
    IconPathElement('M13.33 13H8a1 1 0 00-1 1v7'), // key: 60fs50
    IconPathElement(
      'M14.363 17.634a2 2 0 00-.506.854l-.837 2.87a.5.5 0 00.62.62l2.87-.837a2 2 0 00.854-.506l4.013-4.009a1 1 0 10-3.004-3.004z',
    ), // key: dpj1he
    IconPathElement('M7 3v4a1 1 0 001 1h7'), // key: vkun1b
    IconPathElement(
      'M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h10.2a2 2 0 011.4.6l3.8 3.8a2 2 0 01.6 1.4v.3',
    ), // key: 1oj3yb
  ]);

  /// `save-plus.mjs`
  static const LucideGlyph savePlus = LucideGlyph('save-plus', <IconElement>[
    IconPathElement(
      'M12.5 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h10.2a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4V12',
    ), // key: bhibzn
    IconPathElement('M16 13H8a1 1 0 0 0-1 1v7'), // key: 164ge7
    IconPathElement('M19 22v-6'), // key: qhmiwi
    IconPathElement('M22 19h-6'), // key: vcuq98
    IconPathElement('M7 3v4a1 1 0 0 0 1 1h7'), // key: t51u73
  ]);

  /// `save.mjs`
  static const LucideGlyph save = LucideGlyph('save', <IconElement>[
    IconPathElement(
      'M15.2 3a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2z',
    ), // key: 1c8476
    IconPathElement('M17 21v-7a1 1 0 0 0-1-1H8a1 1 0 0 0-1 1v7'), // key: 1ydtos
    IconPathElement('M7 3v4a1 1 0 0 0 1 1h7'), // key: t51u73
  ]);

  /// `scale-3d.mjs`
  static const LucideGlyph scale3d = LucideGlyph('scale-3d', <IconElement>[
    IconPathElement('M5 7v11a1 1 0 0 0 1 1h11'), // key: 13dt1j
    IconPathElement('M5.293 18.707 11 13'), // key: ezgbsx
    IconCircleElement(19, 19, 2), // key: 17f5cg
    IconCircleElement(5, 5, 2), // key: 1gwv83
  ]);

  /// `scale.mjs`
  static const LucideGlyph scale = LucideGlyph('scale', <IconElement>[
    IconPathElement('M12 3v18'), // key: 108xh3
    IconPathElement('m19 8 3 8a5 5 0 0 1-6 0zV7'), // key: zcdpyk
    IconPathElement('M3 7h1a17 17 0 0 0 8-2 17 17 0 0 0 8 2h1'), // key: 1yorad
    IconPathElement('m5 8 3 8a5 5 0 0 1-6 0zV7'), // key: eua70x
    IconPathElement('M7 21h10'), // key: 1b0cd5
  ]);

  /// `scaling.mjs`
  static const LucideGlyph scaling = LucideGlyph('scaling', <IconElement>[
    IconPathElement(
      'M12 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7',
    ), // key: 1m0v6g
    IconPathElement('M14 15H9v-5'), // key: pi4jk9
    IconPathElement('M16 3h5v5'), // key: 1806ms
    IconPathElement('M21 3 9 15'), // key: 15kdhq
  ]);

  /// `scan-barcode.mjs`
  static const LucideGlyph scanBarcode = LucideGlyph(
    'scan-barcode',
    <IconElement>[
      IconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
      IconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
      IconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
      IconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
      IconPathElement('M8 7v10'), // key: 23sfjj
      IconPathElement('M12 7v10'), // key: jspqdw
      IconPathElement('M17 7v10'), // key: 578dap
    ],
  );

  /// `scan-box.mjs`
  static const LucideGlyph scanBox = LucideGlyph('scan-box', <IconElement>[
    IconPathElement('M12 12v5.5'), // key: 1fezw7
    IconPathElement('M17 3h2a2 2 0 012 2v2'), // key: sxhzt8
    IconPathElement('M21 17v2a2 2 0 01-2 2h-2'), // key: b4b27w
    IconPathElement('M3 7V5a2 2 0 012-2h2'), // key: 5quapj
    IconPathElement('M7 21H5a2 2 0 01-2-2v-2'), // key: rx7q13
    IconPathElement('M7.264 9.252 12 12l4.737-2.748'), // key: 176tmc
    IconPathElement(
      'M7.995 8.514A2 2 0 007 10.244v3.516a2 2 0 00.996 1.73l3 1.74a2 2 0 002.008 0l3-1.74A2 2 0 0017 13.76v-3.517a2 2 0 00-.995-1.73l-3-1.742a2 2 0 00-1.892-.064z',
    ), // key: 7zy66p
  ]);

  /// `scan-eye.mjs`
  static const LucideGlyph scanEye = LucideGlyph('scan-eye', <IconElement>[
    IconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    IconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    IconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    IconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
    IconCircleElement(12, 12, 1), // key: 41hilf
    IconPathElement(
      'M18.944 12.33a1 1 0 0 0 0-.66 7.5 7.5 0 0 0-13.888 0 1 1 0 0 0 0 .66 7.5 7.5 0 0 0 13.888 0',
    ), // key: 11ak4c
  ]);

  /// `scan-face.mjs`
  static const LucideGlyph scanFace = LucideGlyph('scan-face', <IconElement>[
    IconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    IconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    IconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    IconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
    IconPathElement('M8 14s1.5 2 4 2 4-2 4-2'), // key: 1y1vjs
    IconPathElement('M9 9h.01'), // key: 1q5me6
    IconPathElement('M15 9h.01'), // key: x1ddxp
  ]);

  /// `scan-heart.mjs`
  static const LucideGlyph scanHeart = LucideGlyph('scan-heart', <IconElement>[
    IconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    IconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    IconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    IconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
    IconPathElement(
      'M7.828 13.07A3 3 0 0 1 12 8.764a3 3 0 0 1 4.172 4.306l-3.447 3.62a1 1 0 0 1-1.449 0z',
    ), // key: 1ak1ef
  ]);

  /// `scan-line.mjs`
  static const LucideGlyph scanLine = LucideGlyph('scan-line', <IconElement>[
    IconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    IconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    IconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    IconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
    IconPathElement('M7 12h10'), // key: b7w52i
  ]);

  /// `scan-qr-code.mjs`
  static const LucideGlyph scanQrCode = LucideGlyph(
    'scan-qr-code',
    <IconElement>[
      IconPathElement('M17 12v4a1 1 0 0 1-1 1h-4'), // key: uk4fdo
      IconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
      IconPathElement('M17 8V7'), // key: q2g9wo
      IconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
      IconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
      IconPathElement('M7 17h.01'), // key: 19xn7k
      IconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
      IconRectElement(7, 7, 5, 5, 1), // key: m9kyts
    ],
  );

  /// `scan-search.mjs`
  static const LucideGlyph scanSearch = LucideGlyph(
    'scan-search',
    <IconElement>[
      IconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
      IconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
      IconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
      IconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
      IconCircleElement(12, 12, 3), // key: 1v7zrd
      IconPathElement('m16 16-1.9-1.9'), // key: 1dq9hf
    ],
  );

  /// `scan-square.mjs`
  static const LucideGlyph scanSquare = LucideGlyph(
    'scan-square',
    <IconElement>[
      IconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
      IconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
      IconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
      IconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
      IconRectElement(8, 8, 8, 8, 1), // key: 69yp3k
    ],
  );

  /// `scan-text.mjs`
  static const LucideGlyph scanText = LucideGlyph('scan-text', <IconElement>[
    IconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    IconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    IconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    IconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
    IconPathElement('M7 8h8'), // key: 1jbsf9
    IconPathElement('M7 12h10'), // key: b7w52i
    IconPathElement('M7 16h6'), // key: 1vyc9m
  ]);

  /// `scan.mjs`
  static const LucideGlyph scan = LucideGlyph('scan', <IconElement>[
    IconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    IconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    IconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    IconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
  ]);

  /// `school.mjs`
  static const LucideGlyph school = LucideGlyph('school', <IconElement>[
    IconPathElement('M14 21v-3a2 2 0 0 0-4 0v3'), // key: 1rgiei
    IconPathElement('M18 4.933V21'), // key: tjwmp4
    IconPathElement('m4 6 7.106-3.79a2 2 0 0 1 1.788 0L20 6'), // key: zywc2d
    IconPathElement(
      'm6 11-3.52 2.147a1 1 0 0 0-.48.854V19a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-5a1 1 0 0 0-.48-.853L18 11',
    ), // key: 1d4ql0
    IconPathElement('M6 4.933V21'), // key: 1ufz1j
    IconCircleElement(12, 9, 2), // key: 1092wv
  ]);

  /// `scissors-line-dashed.mjs`
  static const LucideGlyph scissorsLineDashed = LucideGlyph(
    'scissors-line-dashed',
    <IconElement>[
      IconPathElement('M5.42 9.42 8 12'), // key: 12pkuq
      IconCircleElement(4, 8, 2), // key: 107mxr
      IconPathElement('m14 6-8.58 8.58'), // key: gvzu5l
      IconCircleElement(4, 16, 2), // key: 1ehqvc
      IconPathElement('M10.8 14.8 14 18'), // key: ax7m9r
      IconPathElement('M16 12h-2'), // key: 10asgb
      IconPathElement('M22 12h-2'), // key: 14jgyd
    ],
  );

  /// `scissors.mjs`
  static const LucideGlyph scissors = LucideGlyph('scissors', <IconElement>[
    IconCircleElement(6, 6, 3), // key: 1lh9wr
    IconPathElement('M8.12 8.12 12 12'), // key: 1alkpv
    IconPathElement('M20 4 8.12 15.88'), // key: xgtan2
    IconCircleElement(6, 18, 3), // key: fqmcym
    IconPathElement('M14.8 14.8 20 20'), // key: ptml3r
  ]);

  /// `scooter.mjs`
  static const LucideGlyph scooter = LucideGlyph('scooter', <IconElement>[
    IconPathElement('M21 4h-3.5l2 11.05'), // key: 1gktiw
    IconPathElement(
      'M6.95 17h5.142c.523 0 .95-.406 1.063-.916a6.5 6.5 0 0 1 5.345-5.009',
    ), // key: 1bq3u3
    IconCircleElement(19.5, 17.5, 2.5), // key: e4zhv9
    IconCircleElement(4.5, 17.5, 2.5), // key: 50vk4p
  ]);

  /// `screen-share-off.mjs`
  static const LucideGlyph screenShareOff = LucideGlyph(
    'screen-share-off',
    <IconElement>[
      IconPathElement(
        'M13 3H4a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-3',
      ), // key: i8wdob
      IconPathElement('M8 21h8'), // key: 1ev6f3
      IconPathElement('M12 17v4'), // key: 1riwvh
      IconPathElement('m22 3-5 5'), // key: 12jva0
      IconPathElement('m17 3 5 5'), // key: k36vhe
    ],
  );

  /// `screen-share.mjs`
  static const LucideGlyph screenShare = LucideGlyph(
    'screen-share',
    <IconElement>[
      IconPathElement(
        'M13 3H4a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-3',
      ), // key: i8wdob
      IconPathElement('M8 21h8'), // key: 1ev6f3
      IconPathElement('M12 17v4'), // key: 1riwvh
      IconPathElement('m17 8 5-5'), // key: fqif7o
      IconPathElement('M17 3h5v5'), // key: 1o3tu8
    ],
  );

  /// `scroll-text.mjs`
  static const LucideGlyph
  scrollText = LucideGlyph('scroll-text', <IconElement>[
    IconPathElement('M15 12h-5'), // key: r7krc0
    IconPathElement('M15 8h-5'), // key: 1khuty
    IconPathElement('M19 17V5a2 2 0 0 0-2-2H4'), // key: zz82l3
    IconPathElement(
      'M8 21h12a2 2 0 0 0 2-2v-1a1 1 0 0 0-1-1H11a1 1 0 0 0-1 1v1a2 2 0 1 1-4 0V5a2 2 0 1 0-4 0v2a1 1 0 0 0 1 1h3',
    ), // key: 1ph1d7
  ]);

  /// `scroll.mjs`
  static const LucideGlyph scroll = LucideGlyph('scroll', <IconElement>[
    IconPathElement('M19 17V5a2 2 0 0 0-2-2H4'), // key: zz82l3
    IconPathElement(
      'M8 21h12a2 2 0 0 0 2-2v-1a1 1 0 0 0-1-1H11a1 1 0 0 0-1 1v1a2 2 0 1 1-4 0V5a2 2 0 1 0-4 0v2a1 1 0 0 0 1 1h3',
    ), // key: 1ph1d7
  ]);

  /// `search-alert.mjs`
  static const LucideGlyph searchAlert = LucideGlyph(
    'search-alert',
    <IconElement>[
      IconCircleElement(11, 11, 8), // key: 4ej97u
      IconPathElement('m21 21-4.3-4.3'), // key: 1qie3q
      IconPathElement('M11 7v4'), // key: m2edmq
      IconPathElement('M11 15h.01'), // key: k85uqc
    ],
  );

  /// `search-check.mjs`
  static const LucideGlyph searchCheck = LucideGlyph(
    'search-check',
    <IconElement>[
      IconPathElement('m8 11 2 2 4-4'), // key: 1sed1v
      IconCircleElement(11, 11, 8), // key: 4ej97u
      IconPathElement('m21 21-4.3-4.3'), // key: 1qie3q
    ],
  );

  /// `search-code.mjs`
  static const LucideGlyph searchCode = LucideGlyph(
    'search-code',
    <IconElement>[
      IconPathElement('m13 13.5 2-2.5-2-2.5'), // key: 1rvxrh
      IconPathElement('m21 21-4.3-4.3'), // key: 1qie3q
      IconPathElement('M9 8.5 7 11l2 2.5'), // key: 6ffwbx
      IconCircleElement(11, 11, 8), // key: 4ej97u
    ],
  );

  /// `search-slash.mjs`
  static const LucideGlyph searchSlash = LucideGlyph(
    'search-slash',
    <IconElement>[
      IconPathElement('m13.5 8.5-5 5'), // key: 1cs55j
      IconCircleElement(11, 11, 8), // key: 4ej97u
      IconPathElement('m21 21-4.3-4.3'), // key: 1qie3q
    ],
  );

  /// `search-x.mjs`
  static const LucideGlyph searchX = LucideGlyph('search-x', <IconElement>[
    IconPathElement('m13.5 8.5-5 5'), // key: 1cs55j
    IconPathElement('m8.5 8.5 5 5'), // key: a8mexj
    IconCircleElement(11, 11, 8), // key: 4ej97u
    IconPathElement('m21 21-4.3-4.3'), // key: 1qie3q
  ]);

  /// `search.mjs`
  static const LucideGlyph search = LucideGlyph('search', <IconElement>[
    IconPathElement('m21 21-4.34-4.34'), // key: 14j7rj
    IconCircleElement(11, 11, 8), // key: 4ej97u
  ]);

  /// `section.mjs`
  static const LucideGlyph section = LucideGlyph('section', <IconElement>[
    IconPathElement(
      'M16 5a4 3 0 0 0-8 0c0 4 8 3 8 7a4 3 0 0 1-8 0',
    ), // key: vqan6v
    IconPathElement(
      'M8 19a4 3 0 0 0 8 0c0-4-8-3-8-7a4 3 0 0 1 8 0',
    ), // key: wdjd8o
  ]);

  /// `send-horizontal.mjs`
  static const LucideGlyph
  sendHorizontal = LucideGlyph('send-horizontal', <IconElement>[
    IconPathElement(
      'M3.714 3.048a.498.498 0 0 0-.683.627l2.843 7.627a2 2 0 0 1 0 1.396l-2.842 7.627a.498.498 0 0 0 .682.627l18-8.5a.5.5 0 0 0 0-.904z',
    ), // key: 117uat
    IconPathElement('M6 12h16'), // key: s4cdu5
  ]);

  /// `send-to-back.mjs`
  static const LucideGlyph sendToBack = LucideGlyph(
    'send-to-back',
    <IconElement>[
      IconRectElement(14, 14, 8, 8, 2), // key: 1b0bso
      IconRectElement(2, 2, 8, 8, 2), // key: 1x09vl
      IconPathElement('M7 14v1a2 2 0 0 0 2 2h1'), // key: pao6x6
      IconPathElement('M14 7h1a2 2 0 0 1 2 2v1'), // key: 19tdru
    ],
  );

  /// `send.mjs`
  static const LucideGlyph send = LucideGlyph('send', <IconElement>[
    IconPathElement(
      'M14.536 21.686a.5.5 0 0 0 .937-.024l6.5-19a.496.496 0 0 0-.635-.635l-19 6.5a.5.5 0 0 0-.024.937l7.93 3.18a2 2 0 0 1 1.112 1.11z',
    ), // key: 1ffxy3
    IconPathElement('m21.854 2.147-10.94 10.939'), // key: 12cjpa
  ]);

  /// `separator-horizontal.mjs`
  static const LucideGlyph separatorHorizontal = LucideGlyph(
    'separator-horizontal',
    <IconElement>[
      IconPathElement('m16 16-4 4-4-4'), // key: 3dv8je
      IconPathElement('M3 12h18'), // key: 1i2n21
      IconPathElement('m8 8 4-4 4 4'), // key: 2bscm2
    ],
  );

  /// `separator-vertical.mjs`
  static const LucideGlyph separatorVertical = LucideGlyph(
    'separator-vertical',
    <IconElement>[
      IconPathElement('M12 3v18'), // key: 108xh3
      IconPathElement('m16 16 4-4-4-4'), // key: 1js579
      IconPathElement('m8 8-4 4 4 4'), // key: 1whems
    ],
  );

  /// `server-cog.mjs`
  static const LucideGlyph serverCog = LucideGlyph('server-cog', <IconElement>[
    IconPathElement('m10.852 14.772-.383.923'), // key: 11vil6
    IconPathElement(
      'M13.148 14.772a3 3 0 1 0-2.296-5.544l-.383-.923',
    ), // key: 1v3clb
    IconPathElement('m13.148 9.228.383-.923'), // key: t2zzyc
    IconPathElement(
      'm13.53 15.696-.382-.924a3 3 0 1 1-2.296-5.544',
    ), // key: 1bxfiv
    IconPathElement('m14.772 10.852.923-.383'), // key: k9m8cz
    IconPathElement('m14.772 13.148.923.383'), // key: 1xvhww
    IconPathElement(
      'M4.5 10H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2h-.5',
    ), // key: tn8das
    IconPathElement(
      'M4.5 14H4a2 2 0 0 0-2 2v4a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-4a2 2 0 0 0-2-2h-.5',
    ), // key: 1g2pve
    IconPathElement('M6 18h.01'), // key: uhywen
    IconPathElement('M6 6h.01'), // key: 1utrut
    IconPathElement('m9.228 10.852-.923-.383'), // key: 1wtb30
    IconPathElement('m9.228 13.148-.923.383'), // key: 1a830x
  ]);

  /// `server-crash.mjs`
  static const LucideGlyph
  serverCrash = LucideGlyph('server-crash', <IconElement>[
    IconPathElement(
      'M6 10H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2h-2',
    ), // key: 4b9dqc
    IconPathElement(
      'M6 14H4a2 2 0 0 0-2 2v4a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-4a2 2 0 0 0-2-2h-2',
    ), // key: 22nnkd
    IconPathElement('M6 6h.01'), // key: 1utrut
    IconPathElement('M6 18h.01'), // key: uhywen
    IconPathElement('m13 6-4 6h6l-4 6'), // key: 14hqih
  ]);

  /// `server-off.mjs`
  static const LucideGlyph serverOff = LucideGlyph('server-off', <IconElement>[
    IconPathElement('M7 2h13a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2h-5'), // key: bt2siv
    IconPathElement(
      'M10 10 2.5 2.5C2 2 2 2.5 2 5v3a2 2 0 0 0 2 2h6z',
    ), // key: 1hjrv1
    IconPathElement('M22 17v-1a2 2 0 0 0-2-2h-1'), // key: 1iynyr
    IconPathElement(
      'M4 14a2 2 0 0 0-2 2v4a2 2 0 0 0 2 2h16.5l1-.5.5.5-8-8H4z',
    ), // key: 161ggg
    IconPathElement('M6 18h.01'), // key: uhywen
    IconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `server-plus.mjs`
  static const LucideGlyph serverPlus = LucideGlyph(
    'server-plus',
    <IconElement>[
      IconPathElement(
        'M12.5 10H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v2',
      ), // key: s66i12
      IconPathElement('M16 12h6'), // key: 15xry1
      IconPathElement('M19 9v6'), // key: 1kf5t6
      IconPathElement(
        'M22 18v2a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-4a2 2 0 0 1 2-2h8.5',
      ), // key: lo70fm
      IconPathElement('M6 18h.01'), // key: uhywen
      IconPathElement('M6 6h.01'), // key: 1utrut
    ],
  );

  /// `server.mjs`
  static const LucideGlyph server = LucideGlyph('server', <IconElement>[
    IconRectElement(2, 2, 20, 8, 2, ry: 2), // key: ngkwjq
    IconRectElement(2, 14, 20, 8, 2, ry: 2), // key: iecqi9
    IconLineElement(6, 6, 6.01, 6), // key: 16zg32
    IconLineElement(6, 18, 6.01, 18), // key: nzw8ys
  ]);

  /// `settings-2.mjs`
  static const LucideGlyph settings2 = LucideGlyph('settings-2', <IconElement>[
    IconPathElement('M14 17H5'), // key: gfn3mx
    IconPathElement('M19 7h-9'), // key: 6i9tg
    IconCircleElement(17, 17, 3), // key: 18b49y
    IconCircleElement(7, 7, 3), // key: dfmy0x
  ]);

  /// `settings.mjs`
  static const LucideGlyph settings = LucideGlyph('settings', <IconElement>[
    IconPathElement(
      'M9.671 4.136a2.34 2.34 0 0 1 4.659 0 2.34 2.34 0 0 0 3.319 1.915 2.34 2.34 0 0 1 2.33 4.033 2.34 2.34 0 0 0 0 3.831 2.34 2.34 0 0 1-2.33 4.033 2.34 2.34 0 0 0-3.319 1.915 2.34 2.34 0 0 1-4.659 0 2.34 2.34 0 0 0-3.32-1.915 2.34 2.34 0 0 1-2.33-4.033 2.34 2.34 0 0 0 0-3.831A2.34 2.34 0 0 1 6.35 6.051a2.34 2.34 0 0 0 3.319-1.915',
    ), // key: 1i5ecw
    IconCircleElement(12, 12, 3), // key: 1v7zrd
  ]);

  /// `shapes.mjs`
  static const LucideGlyph shapes = LucideGlyph('shapes', <IconElement>[
    IconPathElement(
      'M8.3 10a.7.7 0 0 1-.626-1.079L11.4 3a.7.7 0 0 1 1.198-.043L16.3 8.9a.7.7 0 0 1-.572 1.1Z',
    ), // key: 1bo67w
    IconRectElement(3, 14, 7, 7, 1), // key: 1bkyp8
    IconCircleElement(17.5, 17.5, 3.5), // key: w3z12y
  ]);

  /// `share-2.mjs`
  static const LucideGlyph share2 = LucideGlyph('share-2', <IconElement>[
    IconCircleElement(18, 5, 3), // key: gq8acd
    IconCircleElement(6, 12, 3), // key: w7nqdw
    IconCircleElement(18, 19, 3), // key: 1xt0gg
    IconLineElement(8.59, 13.51, 15.42, 17.49), // key: 47mynk
    IconLineElement(15.41, 6.51, 8.59, 10.49), // key: 1n3mei
  ]);

  /// `share.mjs`
  static const LucideGlyph share = LucideGlyph('share', <IconElement>[
    IconPathElement('M12 2v13'), // key: 1km8f5
    IconPathElement('m16 6-4-4-4 4'), // key: 13yo43
    IconPathElement('M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8'), // key: 1b2hhj
  ]);

  /// `sheet.mjs`
  static const LucideGlyph sheet = LucideGlyph('sheet', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    IconLineElement(3, 9, 21, 9), // key: 1vqk6q
    IconLineElement(3, 15, 21, 15), // key: o2sbyz
    IconLineElement(9, 9, 9, 21), // key: 1ib60c
    IconLineElement(15, 9, 15, 21), // key: 1n26ft
  ]);

  /// `shell.mjs`
  static const LucideGlyph shell = LucideGlyph('shell', <IconElement>[
    IconPathElement(
      'M14 11a2 2 0 1 1-4 0 4 4 0 0 1 8 0 6 6 0 0 1-12 0 8 8 0 0 1 16 0 10 10 0 1 1-20 0 11.93 11.93 0 0 1 2.42-7.22 2 2 0 1 1 3.16 2.44',
    ), // key: 1cn552
  ]);

  /// `shelving-unit.mjs`
  static const LucideGlyph
  shelvingUnit = LucideGlyph('shelving-unit', <IconElement>[
    IconPathElement('M12 12V9a1 1 0 0 0-1-1H9a1 1 0 0 0-1 1v3'), // key: wiz68x
    IconPathElement(
      'M16 20v-3a1 1 0 0 0-1-1h-2a1 1 0 0 0-1 1v3',
    ), // key: 1b59c4
    IconPathElement('M20 22V2'), // key: 1bnhr8
    IconPathElement('M4 12h16'), // key: 1lakjw
    IconPathElement('M4 20h16'), // key: 14thso
    IconPathElement('M4 2v20'), // key: gtpd5x
    IconPathElement('M4 4h16'), // key: 1bkgr1
  ]);

  /// `shield-alert.mjs`
  static const LucideGlyph
  shieldAlert = LucideGlyph('shield-alert', <IconElement>[
    IconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    IconPathElement('M12 8v4'), // key: 1got3b
    IconPathElement('M12 16h.01'), // key: 1drbdi
  ]);

  /// `shield-ban.mjs`
  static const LucideGlyph shieldBan = LucideGlyph('shield-ban', <IconElement>[
    IconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    IconPathElement('m4.243 5.21 14.39 12.472'), // key: 1c9a7c
  ]);

  /// `shield-check.mjs`
  static const LucideGlyph
  shieldCheck = LucideGlyph('shield-check', <IconElement>[
    IconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    IconPathElement('m9 12 2 2 4-4'), // key: dzmm74
  ]);

  /// `shield-cog-corner.mjs`
  static const LucideGlyph
  shieldCogCorner = LucideGlyph('shield-cog-corner', <IconElement>[
    IconPathElement(
      'M11 22c-3.806-1.45-7-3.966-7-9V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1v4',
    ), // key: hf1sz5
    IconPathElement('M14.923 16.547 14 16.164'), // key: 41f878
    IconPathElement('m14.923 18.843-.923.383'), // key: 82rvv5
    IconPathElement('M16.547 14.923 16.164 14'), // key: 1r7ypn
    IconPathElement('m16.547 20.467-.383.924'), // key: au4kyj
    IconPathElement('m18.843 14.923.383-.923'), // key: 1cbrwq
    IconPathElement('m19.225 21.391-.382-.924'), // key: 1u2bh9
    IconPathElement('m20.467 16.547.923-.383'), // key: cprboc
    IconPathElement('m20.467 18.843.923.383'), // key: inm8l2
    IconCircleElement(17.695, 17.695, 3), // key: 1i1rmh
  ]);

  /// `shield-cog.mjs`
  static const LucideGlyph shieldCog = LucideGlyph('shield-cog', <IconElement>[
    IconPathElement('m10.929 14.467-.383.924'), // key: hdyevy
    IconPathElement('M10.929 8.923 10.546 8'), // key: 1nr44d
    IconPathElement('M13.225 8.923 13.608 8'), // key: aewley
    IconPathElement('m13.607 15.391-.382-.924'), // key: m37gf1
    IconPathElement('m14.849 10.547.923-.383'), // key: 1d3c4q
    IconPathElement('m14.849 12.843.923.383'), // key: lmvhy3
    IconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    IconPathElement('m9.305 10.547-.923-.383'), // key: 1d13ox
    IconPathElement('m9.305 12.843-.923.383'), // key: 7wxwh5
    IconCircleElement(12.077, 11.695, 3), // key: fse9k8
  ]);

  /// `shield-ellipsis.mjs`
  static const LucideGlyph
  shieldEllipsis = LucideGlyph('shield-ellipsis', <IconElement>[
    IconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    IconPathElement('M8 12h.01'), // key: czm47f
    IconPathElement('M12 12h.01'), // key: 1mp3jc
    IconPathElement('M16 12h.01'), // key: 1l6xoz
  ]);

  /// `shield-half.mjs`
  static const LucideGlyph
  shieldHalf = LucideGlyph('shield-half', <IconElement>[
    IconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    IconPathElement('M12 22V2'), // key: zs6s6o
  ]);

  /// `shield-keyhole.mjs`
  static const LucideGlyph
  shieldKeyhole = LucideGlyph('shield-keyhole', <IconElement>[
    IconPathElement('M12 13v3'), // key: gkc6qb
    IconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 01-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 011-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 011.52 0C14.51 3.81 17 5 19 5a1 1 0 011 1z',
    ), // key: 1buusj
    IconCircleElement(12, 11, 2), // key: 1yggc4
  ]);

  /// `shield-minus.mjs`
  static const LucideGlyph
  shieldMinus = LucideGlyph('shield-minus', <IconElement>[
    IconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    IconPathElement('M9 12h6'), // key: 1c52cq
  ]);

  /// `shield-off.mjs`
  static const LucideGlyph shieldOff = LucideGlyph('shield-off', <IconElement>[
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement(
      'M5 5a1 1 0 0 0-1 1v7c0 5 3.5 7.5 7.67 8.94a1 1 0 0 0 .67.01c2.35-.82 4.48-1.97 5.9-3.71',
    ), // key: 1jlk70
    IconPathElement(
      'M9.309 3.652A12.252 12.252 0 0 0 11.24 2.28a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1v7a9.784 9.784 0 0 1-.08 1.264',
    ), // key: 18rp1v
  ]);

  /// `shield-plus.mjs`
  static const LucideGlyph
  shieldPlus = LucideGlyph('shield-plus', <IconElement>[
    IconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    IconPathElement('M9 12h6'), // key: 1c52cq
    IconPathElement('M12 9v6'), // key: 199k2o
  ]);

  /// `shield-question-mark.mjs`
  static const LucideGlyph
  shieldQuestionMark = LucideGlyph('shield-question-mark', <IconElement>[
    IconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    IconPathElement('M9.1 9a3 3 0 0 1 5.82 1c0 2-3 3-3 3'), // key: mhlwft
    IconPathElement('M12 17h.01'), // key: p32p05
  ]);

  /// `shield-user.mjs`
  static const LucideGlyph
  shieldUser = LucideGlyph('shield-user', <IconElement>[
    IconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    IconPathElement('M6.376 18.91a6 6 0 0 1 11.249.003'), // key: hnjrf2
    IconCircleElement(12, 11, 4), // key: 1gt34v
  ]);

  /// `shield-x.mjs`
  static const LucideGlyph shieldX = LucideGlyph('shield-x', <IconElement>[
    IconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    IconPathElement('m14.5 9.5-5 5'), // key: 17q4r4
    IconPathElement('m9.5 9.5 5 5'), // key: 18nt4w
  ]);

  /// `shield.mjs`
  static const LucideGlyph shield = LucideGlyph('shield', <IconElement>[
    IconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
  ]);

  /// `ship-wheel.mjs`
  static const LucideGlyph shipWheel = LucideGlyph('ship-wheel', <IconElement>[
    IconCircleElement(12, 12, 8), // key: 46899m
    IconPathElement('M12 2v7.5'), // key: 1e5rl5
    IconPathElement('m19 5-5.23 5.23'), // key: 1ezxxf
    IconPathElement('M22 12h-7.5'), // key: le1719
    IconPathElement('m19 19-5.23-5.23'), // key: p3fmgn
    IconPathElement('M12 14.5V22'), // key: dgcmos
    IconPathElement('M10.23 13.77 5 19'), // key: qwopd4
    IconPathElement('M9.5 12H2'), // key: r7bup8
    IconPathElement('M10.23 10.23 5 5'), // key: k2y7lj
    IconCircleElement(12, 12, 2.5), // key: ix0uyj
  ]);

  /// `ship.mjs`
  static const LucideGlyph ship = LucideGlyph('ship', <IconElement>[
    IconPathElement('M12 10.189V14'), // key: 1p8cqu
    IconPathElement('M12 2v3'), // key: qbqxhf
    IconPathElement('M19 13V7a2 2 0 0 0-2-2H7a2 2 0 0 0-2 2v6'), // key: qpkstq
    IconPathElement(
      'M19.38 20A11.6 11.6 0 0 0 21 14l-8.188-3.639a2 2 0 0 0-1.624 0L3 14a11.6 11.6 0 0 0 2.81 7.76',
    ), // key: 7tigtc
    IconPathElement(
      'M2 21c.6.5 1.2 1 2.5 1 2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1s1.2 1 2.5 1c2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1',
    ), // key: 1924j5
  ]);

  /// `shirt.mjs`
  static const LucideGlyph shirt = LucideGlyph('shirt', <IconElement>[
    IconPathElement(
      'M20.38 3.46 16 2a4 4 0 0 1-8 0L3.62 3.46a2 2 0 0 0-1.34 2.23l.58 3.47a1 1 0 0 0 .99.84H6v10c0 1.1.9 2 2 2h8a2 2 0 0 0 2-2V10h2.15a1 1 0 0 0 .99-.84l.58-3.47a2 2 0 0 0-1.34-2.23z',
    ), // key: 1wgbhj
  ]);

  /// `shopping-bag.mjs`
  static const LucideGlyph
  shoppingBag = LucideGlyph('shopping-bag', <IconElement>[
    IconPathElement('M16 10a4 4 0 0 1-8 0'), // key: 1ltviw
    IconPathElement('M3.103 6.034h17.794'), // key: awc11p
    IconPathElement(
      'M3.4 5.467a2 2 0 0 0-.4 1.2V20a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6.667a2 2 0 0 0-.4-1.2l-2-2.667A2 2 0 0 0 17 2H7a2 2 0 0 0-1.6.8z',
    ), // key: o988cm
  ]);

  /// `shopping-basket.mjs`
  static const LucideGlyph shoppingBasket = LucideGlyph(
    'shopping-basket',
    <IconElement>[
      IconPathElement('m15 11-1 9'), // key: 5wnq3a
      IconPathElement('m19 11-4-7'), // key: cnml18
      IconPathElement('M2 11h20'), // key: 3eubbj
      IconPathElement(
        'm3.5 11 1.6 7.4a2 2 0 0 0 2 1.6h9.8a2 2 0 0 0 2-1.6l1.7-7.4',
      ), // key: yiazzp
      IconPathElement('M4.5 15.5h15'), // key: 13mye1
      IconPathElement('m5 11 4-7'), // key: 116ra9
      IconPathElement('m9 11 1 9'), // key: 1ojof7
    ],
  );

  /// `shopping-cart.mjs`
  static const LucideGlyph
  shoppingCart = LucideGlyph('shopping-cart', <IconElement>[
    IconCircleElement(8, 21, 1), // key: jimo8o
    IconCircleElement(19, 21, 1), // key: 13723u
    IconPathElement(
      'M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12',
    ), // key: 9zh506
  ]);

  /// `shovel.mjs`
  static const LucideGlyph shovel = LucideGlyph('shovel', <IconElement>[
    IconPathElement(
      'M21.56 4.56a1.5 1.5 0 0 1 0 2.122l-.47.47a3 3 0 0 1-4.212-.03 3 3 0 0 1 0-4.243l.44-.44a1.5 1.5 0 0 1 2.121 0z',
    ), // key: 1gcedi
    IconPathElement(
      'M3 22a1 1 0 0 1-1-1v-3.586a1 1 0 0 1 .293-.707l3.355-3.355a1.205 1.205 0 0 1 1.704 0l3.296 3.296a1.205 1.205 0 0 1 0 1.704l-3.355 3.355a1 1 0 0 1-.707.293z',
    ), // key: pg9kv3
    IconPathElement('m9 15 7.879-7.878'), // key: 1o1zgh
  ]);

  /// `shower-head.mjs`
  static const LucideGlyph showerHead = LucideGlyph(
    'shower-head',
    <IconElement>[
      IconPathElement('m4 4 2.5 2.5'), // key: uv2vmf
      IconPathElement('M13.5 6.5a4.95 4.95 0 0 0-7 7'), // key: frdkwv
      IconPathElement('M15 5 5 15'), // key: 1ag8rq
      IconPathElement('M14 17v.01'), // key: eokfpp
      IconPathElement('M10 16v.01'), // key: 14uyyl
      IconPathElement('M13 13v.01'), // key: 1v1k97
      IconPathElement('M16 10v.01'), // key: 5169yg
      IconPathElement('M11 20v.01'), // key: cj92p8
      IconPathElement('M17 14v.01'), // key: 11cswd
      IconPathElement('M20 11v.01'), // key: 19e0od
    ],
  );

  /// `shredder.mjs`
  static const LucideGlyph shredder = LucideGlyph('shredder', <IconElement>[
    IconPathElement(
      'M4 13V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v5',
    ), // key: 1eob4r
    IconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    IconPathElement('M10 22v-5'), // key: sfixh4
    IconPathElement('M14 19v-2'), // key: pdve8j
    IconPathElement('M18 20v-3'), // key: uox2gk
    IconPathElement('M2 13h20'), // key: 5evz65
    IconPathElement('M6 20v-3'), // key: c6pdcb
  ]);

  /// `shrimp.mjs`
  static const LucideGlyph shrimp = LucideGlyph('shrimp', <IconElement>[
    IconPathElement('M11 12h.01'), // key: 1lr4k6
    IconPathElement(
      'M13 22c.5-.5 1.12-1 2.5-1-1.38 0-2-.5-2.5-1',
    ), // key: fatpdi
    IconPathElement(
      'M14 2a3.28 3.28 0 0 1-3.227 1.798l-6.17-.561A2.387 2.387 0 1 0 4.387 8H15.5a1 1 0 0 1 0 13 1 1 0 0 0 0-5H12a7 7 0 0 1-7-7V8',
    ), // key: kehrqe
    IconPathElement('M14 8a8.5 8.5 0 0 1 0 8'), // key: 1imjx2
    IconPathElement('M16 16c2 0 4.5-4 4-6'), // key: z0nejz
  ]);

  /// `shrink.mjs`
  static const LucideGlyph shrink = LucideGlyph('shrink', <IconElement>[
    IconPathElement('m15 15 6 6m-6-6v4.8m0-4.8h4.8'), // key: 17vawe
    IconPathElement('M9 19.8V15m0 0H4.2M9 15l-6 6'), // key: chjx8e
    IconPathElement('M15 4.2V9m0 0h4.8M15 9l6-6'), // key: lav6yq
    IconPathElement('M9 4.2V9m0 0H4.2M9 9 3 3'), // key: 1pxi2q
  ]);

  /// `shrub.mjs`
  static const LucideGlyph shrub = LucideGlyph('shrub', <IconElement>[
    IconPathElement(
      'M12 22v-5.172a2 2 0 0 0-.586-1.414L9.5 13.5',
    ), // key: 1p17fm
    IconPathElement('M14.5 14.5 12 17'), // key: dy5w4y
    IconPathElement(
      'M17 8.8A6 6 0 0 1 13.8 20H10A6.5 6.5 0 0 1 7 8a5 5 0 0 1 10 0z',
    ), // key: 6z7b3o
  ]);

  /// `shuffle.mjs`
  static const LucideGlyph shuffle = LucideGlyph('shuffle', <IconElement>[
    IconPathElement('m18 14 4 4-4 4'), // key: 10pe0f
    IconPathElement('m18 2 4 4-4 4'), // key: pucp1d
    IconPathElement(
      'M2 18h1.973a4 4 0 0 0 3.3-1.7l5.454-8.6a4 4 0 0 1 3.3-1.7H22',
    ), // key: 1ailkh
    IconPathElement('M2 6h1.972a4 4 0 0 1 3.6 2.2'), // key: km57vx
    IconPathElement('M22 18h-6.041a4 4 0 0 1-3.3-1.8l-.359-.45'), // key: os18l9
  ]);

  /// `sigma.mjs`
  static const LucideGlyph sigma = LucideGlyph('sigma', <IconElement>[
    IconPathElement(
      'M18 7V5a1 1 0 0 0-1-1H6.5a.5.5 0 0 0-.4.8l4.5 6a2 2 0 0 1 0 2.4l-4.5 6a.5.5 0 0 0 .4.8H17a1 1 0 0 0 1-1v-2',
    ), // key: wuwx1p
  ]);

  /// `signal-high.mjs`
  static const LucideGlyph signalHigh = LucideGlyph(
    'signal-high',
    <IconElement>[
      IconPathElement('M2 20h.01'), // key: 4haj6o
      IconPathElement('M7 20v-4'), // key: j294jx
      IconPathElement('M12 20v-8'), // key: i3yub9
      IconPathElement('M17 20V8'), // key: 1tkaf5
    ],
  );

  /// `signal-low.mjs`
  static const LucideGlyph signalLow = LucideGlyph('signal-low', <IconElement>[
    IconPathElement('M2 20h.01'), // key: 4haj6o
    IconPathElement('M7 20v-4'), // key: j294jx
  ]);

  /// `signal-medium.mjs`
  static const LucideGlyph signalMedium = LucideGlyph(
    'signal-medium',
    <IconElement>[
      IconPathElement('M2 20h.01'), // key: 4haj6o
      IconPathElement('M7 20v-4'), // key: j294jx
      IconPathElement('M12 20v-8'), // key: i3yub9
    ],
  );

  /// `signal-zero.mjs`
  static const LucideGlyph signalZero = LucideGlyph(
    'signal-zero',
    <IconElement>[
      IconPathElement('M2 20h.01'), // key: 4haj6o
    ],
  );

  /// `signal.mjs`
  static const LucideGlyph signal = LucideGlyph('signal', <IconElement>[
    IconPathElement('M2 20h.01'), // key: 4haj6o
    IconPathElement('M7 20v-4'), // key: j294jx
    IconPathElement('M12 20v-8'), // key: i3yub9
    IconPathElement('M17 20V8'), // key: 1tkaf5
    IconPathElement('M22 4v16'), // key: sih9yq
  ]);

  /// `signature.mjs`
  static const LucideGlyph signature = LucideGlyph('signature', <IconElement>[
    IconPathElement(
      'm21 17-2.156-1.868A.5.5 0 0 0 18 15.5v.5a1 1 0 0 1-1 1h-2a1 1 0 0 1-1-1c0-2.545-3.991-3.97-8.5-4a1 1 0 0 0 0 5c4.153 0 4.745-11.295 5.708-13.5a2.5 2.5 0 1 1 3.31 3.284',
    ), // key: y32ogt
    IconPathElement('M3 21h18'), // key: itz85i
  ]);

  /// `signpost-big.mjs`
  static const LucideGlyph signpostBig = LucideGlyph(
    'signpost-big',
    <IconElement>[
      IconPathElement('M10 9H4L2 7l2-2h6'), // key: 1hq7x2
      IconPathElement('M14 5h6l2 2-2 2h-6'), // key: bv62ej
      IconPathElement('M10 22V4a2 2 0 1 1 4 0v18'), // key: eqpcf2
      IconPathElement('M8 22h8'), // key: rmew8v
    ],
  );

  /// `signpost.mjs`
  static const LucideGlyph signpost = LucideGlyph('signpost', <IconElement>[
    IconPathElement('M12 13v8'), // key: 1l5pq0
    IconPathElement('M12 3v3'), // key: 1n5kay
    IconPathElement(
      'M2.354 10.354a1.207 1.207 0 0 1 0-1.708l2.06-2.06A2 2 0 0 1 5.828 6h12.344a2 2 0 0 1 1.414.586l2.06 2.06a1.207 1.207 0 0 1 0 1.708l-2.06 2.06a2 2 0 0 1-1.414.586H5.828a2 2 0 0 1-1.414-.586z',
    ), // key: 1tm261
  ]);

  /// `siren.mjs`
  static const LucideGlyph siren = LucideGlyph('siren', <IconElement>[
    IconPathElement('M7 18v-6a5 5 0 1 1 10 0v6'), // key: pcx96s
    IconPathElement(
      'M5 21a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-1a2 2 0 0 0-2-2H7a2 2 0 0 0-2 2z',
    ), // key: 1b4s83
    IconPathElement('M21 12h1'), // key: jtio3y
    IconPathElement('M18.5 4.5 18 5'), // key: g5sp9y
    IconPathElement('M2 12h1'), // key: 1uaihz
    IconPathElement('M12 2v1'), // key: 11qlp1
    IconPathElement('m4.929 4.929.707.707'), // key: 1i51kw
    IconPathElement('M12 12v6'), // key: 3ahymv
  ]);

  /// `skip-back.mjs`
  static const LucideGlyph skipBack = LucideGlyph('skip-back', <IconElement>[
    IconPathElement(
      'M17.971 4.285A2 2 0 0 1 21 6v12a2 2 0 0 1-3.029 1.715l-9.997-5.998a2 2 0 0 1-.003-3.432z',
    ), // key: 15892j
    IconPathElement('M3 20V4'), // key: 1ptbpl
  ]);

  /// `skip-forward.mjs`
  static const LucideGlyph
  skipForward = LucideGlyph('skip-forward', <IconElement>[
    IconPathElement('M21 4v16'), // key: 7j8fe9
    IconPathElement(
      'M6.029 4.285A2 2 0 0 0 3 6v12a2 2 0 0 0 3.029 1.715l9.997-5.998a2 2 0 0 0 .003-3.432z',
    ), // key: zs4d6
  ]);

  /// `skull.mjs`
  static const LucideGlyph skull = LucideGlyph('skull', <IconElement>[
    IconPathElement('m12.5 17-.5-1-.5 1h1z'), // key: 3me087
    IconPathElement(
      'M15 22a1 1 0 0 0 1-1v-1a2 2 0 0 0 1.56-3.25 8 8 0 1 0-11.12 0A2 2 0 0 0 8 20v1a1 1 0 0 0 1 1z',
    ), // key: 1o5pge
    IconCircleElement(15, 12, 1), // key: 1tmaij
    IconCircleElement(9, 12, 1), // key: 1vctgf
  ]);

  /// `slash.mjs`
  static const LucideGlyph slash = LucideGlyph('slash', <IconElement>[
    IconPathElement('M22 2 2 22'), // key: y4kqgn
  ]);

  /// `slice.mjs`
  static const LucideGlyph slice = LucideGlyph('slice', <IconElement>[
    IconPathElement(
      'M11 16.586V19a1 1 0 0 1-1 1H2L18.37 3.63a1 1 0 1 1 3 3l-9.663 9.663a1 1 0 0 1-1.414 0L8 14',
    ), // key: 1sllp5
  ]);

  /// `sliders-horizontal.mjs`
  static const LucideGlyph slidersHorizontal = LucideGlyph(
    'sliders-horizontal',
    <IconElement>[
      IconPathElement('M10 5H3'), // key: 1qgfaw
      IconPathElement('M12 19H3'), // key: yhmn1j
      IconPathElement('M14 3v4'), // key: 1sua03
      IconPathElement('M16 17v4'), // key: 1q0r14
      IconPathElement('M21 12h-9'), // key: 1o4lsq
      IconPathElement('M21 19h-5'), // key: 1rlt1p
      IconPathElement('M21 5h-7'), // key: 1oszz2
      IconPathElement('M8 10v4'), // key: tgpxqk
      IconPathElement('M8 12H3'), // key: a7s4jb
    ],
  );

  /// `sliders-vertical.mjs`
  static const LucideGlyph slidersVertical = LucideGlyph(
    'sliders-vertical',
    <IconElement>[
      IconPathElement('M10 8h4'), // key: 1sr2af
      IconPathElement('M12 21v-9'), // key: 17s77i
      IconPathElement('M12 8V3'), // key: 13r4qs
      IconPathElement('M17 16h4'), // key: h1uq16
      IconPathElement('M19 12V3'), // key: o1uvq1
      IconPathElement('M19 21v-5'), // key: qua636
      IconPathElement('M3 14h4'), // key: bcjad9
      IconPathElement('M5 10V3'), // key: cb8scm
      IconPathElement('M5 21v-7'), // key: 1w1uti
    ],
  );

  /// `smartphone-charging.mjs`
  static const LucideGlyph smartphoneCharging = LucideGlyph(
    'smartphone-charging',
    <IconElement>[
      IconRectElement(5, 2, 14, 20, 2, ry: 2), // key: 1yt0o3
      IconPathElement('M12.667 8 10 12h4l-2.667 4'), // key: h9lk2d
    ],
  );

  /// `smartphone-nfc.mjs`
  static const LucideGlyph smartphoneNfc = LucideGlyph(
    'smartphone-nfc',
    <IconElement>[
      IconRectElement(2, 6, 7, 12, 1), // key: 5nje8w
      IconPathElement('M13 8.32a7.43 7.43 0 0 1 0 7.36'), // key: 1g306n
      IconPathElement('M16.46 6.21a11.76 11.76 0 0 1 0 11.58'), // key: uqvjvo
      IconPathElement('M19.91 4.1a15.91 15.91 0 0 1 .01 15.8'), // key: ujntz3
    ],
  );

  /// `smartphone.mjs`
  static const LucideGlyph smartphone = LucideGlyph('smartphone', <IconElement>[
    IconRectElement(5, 2, 14, 20, 2, ry: 2), // key: 1yt0o3
    IconPathElement('M12 18h.01'), // key: mhygvu
  ]);

  /// `smile-plus.mjs`
  static const LucideGlyph smilePlus = LucideGlyph('smile-plus', <IconElement>[
    IconPathElement('M22 11v1a10 10 0 1 1-9-10'), // key: ew0xw9
    IconPathElement('M8 14s1.5 2 4 2 4-2 4-2'), // key: 1y1vjs
    IconLineElement(9, 9, 9.01, 9), // key: yxxnd0
    IconLineElement(15, 9, 15.01, 9), // key: 1p4y9e
    IconPathElement('M16 5h6'), // key: 1vod17
    IconPathElement('M19 2v6'), // key: 4bpg5p
  ]);

  /// `smile.mjs`
  static const LucideGlyph smile = LucideGlyph('smile', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconPathElement('M8 14s1.5 2 4 2 4-2 4-2'), // key: 1y1vjs
    IconLineElement(9, 9, 9.01, 9), // key: yxxnd0
    IconLineElement(15, 9, 15.01, 9), // key: 1p4y9e
  ]);

  /// `snail.mjs`
  static const LucideGlyph snail = LucideGlyph('snail', <IconElement>[
    IconPathElement(
      'M2 13a6 6 0 1 0 12 0 4 4 0 1 0-8 0 2 2 0 0 0 4 0',
    ), // key: hneq2s
    IconCircleElement(10, 13, 8), // key: 194lz3
    IconPathElement(
      'M2 21h12c4.4 0 8-3.6 8-8V7a2 2 0 1 0-4 0v6',
    ), // key: ixqyt7
    IconPathElement('M18 3 19.1 5.2'), // key: 9tjm43
    IconPathElement('M22 3 20.9 5.2'), // key: j3odrs
  ]);

  /// `snowflake.mjs`
  static const LucideGlyph snowflake = LucideGlyph('snowflake', <IconElement>[
    IconPathElement('m10 20-1.25-2.5L6 18'), // key: 18frcb
    IconPathElement('M10 4 8.75 6.5 6 6'), // key: 7mghy3
    IconPathElement('m14 20 1.25-2.5L18 18'), // key: 1chtki
    IconPathElement('m14 4 1.25 2.5L18 6'), // key: 1b4wsy
    IconPathElement('m17 21-3-6h-4'), // key: 15hhxa
    IconPathElement('m17 3-3 6 1.5 3'), // key: 11697g
    IconPathElement('M2 12h6.5L10 9'), // key: kv9z4n
    IconPathElement('m20 10-1.5 2 1.5 2'), // key: 1swlpi
    IconPathElement('M22 12h-6.5L14 15'), // key: 1mxi28
    IconPathElement('m4 10 1.5 2L4 14'), // key: k9enpj
    IconPathElement('m7 21 3-6-1.5-3'), // key: j8hb9u
    IconPathElement('m7 3 3 6h4'), // key: 1otusx
  ]);

  /// `soap-dispenser-droplet.mjs`
  static const LucideGlyph
  soapDispenserDroplet = LucideGlyph('soap-dispenser-droplet', <IconElement>[
    IconPathElement('M10.5 2v4'), // key: 1xt6in
    IconPathElement('M14 2H7a2 2 0 0 0-2 2'), // key: e6xig3
    IconPathElement(
      'M19.29 14.76A6.67 6.67 0 0 1 17 11a6.6 6.6 0 0 1-2.29 3.76c-1.15.92-1.71 2.04-1.71 3.19 0 2.22 1.8 4.05 4 4.05s4-1.83 4-4.05c0-1.16-.57-2.26-1.71-3.19',
    ), // key: adq7uc
    IconPathElement(
      'M9.607 21H6a2 2 0 0 1-2-2v-7a2 2 0 0 1 2-2h7V7a1 1 0 0 0-1-1H9a1 1 0 0 0-1 1v3',
    ), // key: t9hm96
  ]);

  /// `sofa.mjs`
  static const LucideGlyph sofa = LucideGlyph('sofa', <IconElement>[
    IconPathElement('M20 9V6a2 2 0 0 0-2-2H6a2 2 0 0 0-2 2v3'), // key: 1dgpiv
    IconPathElement(
      'M2 16a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-5a2 2 0 0 0-4 0v1.5a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5V11a2 2 0 0 0-4 0z',
    ), // key: xacw8m
    IconPathElement('M4 18v2'), // key: jwo5n2
    IconPathElement('M20 18v2'), // key: 1ar1qi
    IconPathElement('M12 4v9'), // key: oqhhn3
  ]);

  /// `solar-panel.mjs`
  static const LucideGlyph
  solarPanel = LucideGlyph('solar-panel', <IconElement>[
    IconPathElement('M11 2h2'), // key: isr7bz
    IconPathElement('m14.28 14-4.56 8'), // key: 4anwcf
    IconPathElement('m21 22-1.558-4H4.558'), // key: enk13h
    IconPathElement('M3 10v2'), // key: w8mti9
    IconPathElement(
      'M6.245 15.04A2 2 0 0 1 8 14h12a1 1 0 0 1 .864 1.505l-3.11 5.457A2 2 0 0 1 16 22H4a1 1 0 0 1-.863-1.506z',
    ), // key: pouggg
    IconPathElement('M7 2a4 4 0 0 1-4 4'), // key: 78s8of
    IconPathElement('m8.66 7.66 1.41 1.41'), // key: 1vaqj8
  ]);

  /// `soup.mjs`
  static const LucideGlyph soup = LucideGlyph('soup', <IconElement>[
    IconPathElement('M12 21a9 9 0 0 0 9-9H3a9 9 0 0 0 9 9Z'), // key: 4rw317
    IconPathElement('M7 21h10'), // key: 1b0cd5
    IconPathElement('M19.5 12 22 6'), // key: shfsr5
    IconPathElement(
      'M16.25 3c.27.1.8.53.75 1.36-.06.83-.93 1.2-1 2.02-.05.78.34 1.24.73 1.62',
    ), // key: rpc6vp
    IconPathElement(
      'M11.25 3c.27.1.8.53.74 1.36-.05.83-.93 1.2-.98 2.02-.06.78.33 1.24.72 1.62',
    ), // key: 1lf63m
    IconPathElement(
      'M6.25 3c.27.1.8.53.75 1.36-.06.83-.93 1.2-1 2.02-.05.78.34 1.24.74 1.62',
    ), // key: 97tijn
  ]);

  /// `space.mjs`
  static const LucideGlyph space = LucideGlyph('space', <IconElement>[
    IconPathElement(
      'M22 17v1c0 .5-.5 1-1 1H3c-.5 0-1-.5-1-1v-1',
    ), // key: lt2kga
  ]);

  /// `spade.mjs`
  static const LucideGlyph spade = LucideGlyph('spade', <IconElement>[
    IconPathElement('M12 18v4'), // key: jadmvz
    IconPathElement(
      'M2 14.499a5.5 5.5 0 0 0 9.591 3.675.6.6 0 0 1 .818.001A5.5 5.5 0 0 0 22 14.5c0-2.29-1.5-4-3-5.5l-5.492-5.312a2 2 0 0 0-3-.02L5 8.999c-1.5 1.5-3 3.2-3 5.5',
    ), // key: 1aw2pz
  ]);

  /// `sparkle.mjs`
  static const LucideGlyph sparkle = LucideGlyph('sparkle', <IconElement>[
    IconPathElement(
      'M11.017 2.814a1 1 0 0 1 1.966 0l1.051 5.558a2 2 0 0 0 1.594 1.594l5.558 1.051a1 1 0 0 1 0 1.966l-5.558 1.051a2 2 0 0 0-1.594 1.594l-1.051 5.558a1 1 0 0 1-1.966 0l-1.051-5.558a2 2 0 0 0-1.594-1.594l-5.558-1.051a1 1 0 0 1 0-1.966l5.558-1.051a2 2 0 0 0 1.594-1.594z',
    ), // key: 1s2grr
  ]);

  /// `sparkles.mjs`
  static const LucideGlyph sparkles = LucideGlyph('sparkles', <IconElement>[
    IconPathElement(
      'M11.017 2.814a1 1 0 0 1 1.966 0l1.051 5.558a2 2 0 0 0 1.594 1.594l5.558 1.051a1 1 0 0 1 0 1.966l-5.558 1.051a2 2 0 0 0-1.594 1.594l-1.051 5.558a1 1 0 0 1-1.966 0l-1.051-5.558a2 2 0 0 0-1.594-1.594l-5.558-1.051a1 1 0 0 1 0-1.966l5.558-1.051a2 2 0 0 0 1.594-1.594z',
    ), // key: 1s2grr
    IconPathElement('M20 2v4'), // key: 1rf3ol
    IconPathElement('M22 4h-4'), // key: gwowj6
    IconCircleElement(4, 20, 2), // key: 6kqj1y
  ]);

  /// `speaker.mjs`
  static const LucideGlyph speaker = LucideGlyph('speaker', <IconElement>[
    IconRectElement(4, 2, 16, 20, 2), // key: 1nb95v
    IconPathElement('M12 6h.01'), // key: 1vi96p
    IconCircleElement(12, 14, 4), // key: 1jruaj
    IconPathElement('M12 14h.01'), // key: 1etili
  ]);

  /// `speech.mjs`
  static const LucideGlyph speech = LucideGlyph('speech', <IconElement>[
    IconPathElement(
      'M8.8 20v-4.1l1.9.2a2.3 2.3 0 0 0 2.164-2.1V8.3A5.37 5.37 0 0 0 2 8.25c0 2.8.656 3.054 1 4.55a5.77 5.77 0 0 1 .029 2.758L2 20',
    ), // key: 11atix
    IconPathElement('M19.8 17.8a7.5 7.5 0 0 0 .003-10.603'), // key: yol142
    IconPathElement('M17 15a3.5 3.5 0 0 0-.025-4.975'), // key: ssbmkc
  ]);

  /// `spell-check-2.mjs`
  static const LucideGlyph
  spellCheck2 = LucideGlyph('spell-check-2', <IconElement>[
    IconPathElement('m6 16 6-12 6 12'), // key: 1b4byz
    IconPathElement('M8 12h8'), // key: 1wcyev
    IconPathElement(
      'M4 21c1.1 0 1.1-1 2.3-1s1.1 1 2.3 1c1.1 0 1.1-1 2.3-1 1.1 0 1.1 1 2.3 1 1.1 0 1.1-1 2.3-1 1.1 0 1.1 1 2.3 1 1.1 0 1.1-1 2.3-1',
    ), // key: 8mdmtu
  ]);

  /// `spell-check.mjs`
  static const LucideGlyph spellCheck = LucideGlyph(
    'spell-check',
    <IconElement>[
      IconPathElement('m6 16 6-12 6 12'), // key: 1b4byz
      IconPathElement('M8 12h8'), // key: 1wcyev
      IconPathElement('m16 20 2 2 4-4'), // key: 13tcca
    ],
  );

  /// `spline-pointer.mjs`
  static const LucideGlyph
  splinePointer = LucideGlyph('spline-pointer', <IconElement>[
    IconPathElement(
      'M12.034 12.681a.498.498 0 0 1 .647-.647l9 3.5a.5.5 0 0 1-.033.943l-3.444 1.068a1 1 0 0 0-.66.66l-1.067 3.443a.5.5 0 0 1-.943.033z',
    ), // key: xwnzip
    IconPathElement('M5 17A12 12 0 0 1 17 5'), // key: 1okkup
    IconCircleElement(19, 5, 2), // key: mhkx31
    IconCircleElement(5, 19, 2), // key: v8kfzx
  ]);

  /// `spline.mjs`
  static const LucideGlyph spline = LucideGlyph('spline', <IconElement>[
    IconCircleElement(19, 5, 2), // key: mhkx31
    IconCircleElement(5, 19, 2), // key: v8kfzx
    IconPathElement('M5 17A12 12 0 0 1 17 5'), // key: 1okkup
  ]);

  /// `split.mjs`
  static const LucideGlyph split = LucideGlyph('split', <IconElement>[
    IconPathElement('M16 3h5v5'), // key: 1806ms
    IconPathElement('M8 3H3v5'), // key: 15dfkv
    IconPathElement('M12 22v-8.3a4 4 0 0 0-1.172-2.872L3 3'), // key: 1qrqzj
    IconPathElement('m15 9 6-6'), // key: ko1vev
  ]);

  /// `spool.mjs`
  static const LucideGlyph spool = LucideGlyph('spool', <IconElement>[
    IconPathElement(
      'M17 13.44 4.442 17.082A2 2 0 0 0 4.982 21H19a2 2 0 0 0 .558-3.921l-1.115-.32A2 2 0 0 1 17 14.837V7.66',
    ), // key: 13vns8
    IconPathElement(
      'm7 10.56 12.558-3.642A2 2 0 0 0 19.018 3H5a2 2 0 0 0-.558 3.921l1.115.32A2 2 0 0 1 7 9.163v7.178',
    ), // key: s8x3u0
  ]);

  /// `sport-shoe.mjs`
  static const LucideGlyph sportShoe = LucideGlyph('sport-shoe', <IconElement>[
    IconPathElement('m15 10.42 4.8-5.07'), // key: 10at9d
    IconPathElement('M19 18h3'), // key: nnkd4d
    IconPathElement(
      'M9.5 22 21.414 9.415A2 2 0 0 0 21.2 6.4l-5.61-4.208A1 1 0 0 0 14 3v2a2 2 0 0 1-1.394 1.906L8.677 8.053A1 1 0 0 0 8 9c-.155 6.393-2.082 9-4 9a2 2 0 0 0 0 4h14',
    ), // key: v410ed
  ]);

  /// `spotlight.mjs`
  static const LucideGlyph spotlight = LucideGlyph('spotlight', <IconElement>[
    IconPathElement('M15.295 19.562 16 22'), // key: 31jsb7
    IconPathElement('m17 16 3.758 2.098'), // key: 121ar7
    IconPathElement('m19 12.5 3.026-.598'), // key: 19ukd3
    IconPathElement(
      'M7.61 6.3a3 3 0 0 0-3.92 1.3l-1.38 2.79a3 3 0 0 0 1.3 3.91l6.89 3.597a1 1 0 0 0 1.342-.447l3.106-6.211a1 1 0 0 0-.447-1.341z',
    ), // key: lwb9l9
    IconPathElement('M8 9V2'), // key: 1xa0v7
  ]);

  /// `spray-can.mjs`
  static const LucideGlyph sprayCan = LucideGlyph('spray-can', <IconElement>[
    IconPathElement('M3 3h.01'), // key: 159qn6
    IconPathElement('M7 5h.01'), // key: 1hq22a
    IconPathElement('M11 7h.01'), // key: 1osv80
    IconPathElement('M3 7h.01'), // key: 1xzrh3
    IconPathElement('M7 9h.01'), // key: 19b3jx
    IconPathElement('M3 11h.01'), // key: 1eifu7
    IconRectElement(15, 5, 4, 4, 0), // key: mri9e4; rx,ry absent
    IconPathElement(
      'm19 9 2 2v10c0 .6-.4 1-1 1h-6c-.6 0-1-.4-1-1V11l2-2',
    ), // key: aib6hk
    IconPathElement('m13 14 8-2'), // key: 1d7bmk
    IconPathElement('m13 19 8-2'), // key: 1y2vml
  ]);

  /// `sprout.mjs`
  static const LucideGlyph sprout = LucideGlyph('sprout', <IconElement>[
    IconPathElement(
      'M14 9.536V7a4 4 0 0 1 4-4h1.5a.5.5 0 0 1 .5.5V5a4 4 0 0 1-4 4 4 4 0 0 0-4 4c0 2 1 3 1 5a5 5 0 0 1-1 3',
    ), // key: 139s4v
    IconPathElement('M4 9a5 5 0 0 1 8 4 5 5 0 0 1-8-4'), // key: 1dlkgp
    IconPathElement('M5 21h14'), // key: 11awu3
  ]);

  /// `square-activity.mjs`
  static const LucideGlyph squareActivity = LucideGlyph(
    'square-activity',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M17 12h-2l-2 5-2-10-2 5H7'), // key: 15hlnc
    ],
  );

  /// `square-arrow-down-left.mjs`
  static const LucideGlyph squareArrowDownLeft = LucideGlyph(
    'square-arrow-down-left',
    <IconElement>[
      IconPathElement('M15 15H9l6-6'), // key: 1w52wt
      IconPathElement('M9 15V9'), // key: 1kwqze
      IconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `square-arrow-down-right.mjs`
  static const LucideGlyph squareArrowDownRight = LucideGlyph(
    'square-arrow-down-right',
    <IconElement>[
      IconPathElement('M15 15 9 9'), // key: qb9ybb
      IconPathElement('M9 15h6V9'), // key: 1wezwn
      IconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `square-arrow-down.mjs`
  static const LucideGlyph squareArrowDown = LucideGlyph(
    'square-arrow-down',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M12 8v8'), // key: napkw2
      IconPathElement('m8 12 4 4 4-4'), // key: k98ssh
    ],
  );

  /// `square-arrow-left.mjs`
  static const LucideGlyph squareArrowLeft = LucideGlyph(
    'square-arrow-left',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('m12 8-4 4 4 4'), // key: 15vm53
      IconPathElement('M16 12H8'), // key: 1fr5h0
    ],
  );

  /// `square-arrow-out-down-left.mjs`
  static const LucideGlyph squareArrowOutDownLeft = LucideGlyph(
    'square-arrow-out-down-left',
    <IconElement>[
      IconPathElement(
        'M13 21h6a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v6',
      ), // key: 14qz4y
      IconPathElement('m3 21 9-9'), // key: 1jfql5
      IconPathElement('M9 21H3v-6'), // key: wtvkvv
    ],
  );

  /// `square-arrow-out-down-right.mjs`
  static const LucideGlyph squareArrowOutDownRight = LucideGlyph(
    'square-arrow-out-down-right',
    <IconElement>[
      IconPathElement(
        'M21 11V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h6',
      ), // key: 14rsvq
      IconPathElement('m21 21-9-9'), // key: 1et2py
      IconPathElement('M21 15v6h-6'), // key: 1jko0i
    ],
  );

  /// `square-arrow-out-up-left.mjs`
  static const LucideGlyph squareArrowOutUpLeft = LucideGlyph(
    'square-arrow-out-up-left',
    <IconElement>[
      IconPathElement(
        'M13 3h6a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-6',
      ), // key: 14mv1t
      IconPathElement('m3 3 9 9'), // key: rks13r
      IconPathElement('M3 9V3h6'), // key: ira0h2
    ],
  );

  /// `square-arrow-out-up-right.mjs`
  static const LucideGlyph squareArrowOutUpRight = LucideGlyph(
    'square-arrow-out-up-right',
    <IconElement>[
      IconPathElement(
        'M21 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h6',
      ), // key: y09zxi
      IconPathElement('m21 3-9 9'), // key: mpx6sq
      IconPathElement('M15 3h6v6'), // key: 1q9fwt
    ],
  );

  /// `square-arrow-right-enter.mjs`
  static const LucideGlyph
  squareArrowRightEnter = LucideGlyph('square-arrow-right-enter', <IconElement>[
    IconPathElement('m10 16 4-4-4-4'), // key: w9835o
    IconPathElement('M3 12h11'), // key: pmja8f
    IconPathElement(
      'M3 8V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-3',
    ), // key: 1bqs5q
  ]);

  /// `square-arrow-right-exit.mjs`
  static const LucideGlyph
  squareArrowRightExit = LucideGlyph('square-arrow-right-exit', <IconElement>[
    IconPathElement('M10 12h11'), // key: 6m4ad9
    IconPathElement('m17 16 4-4-4-4'), // key: iin4zf
    IconPathElement(
      'M21 6.344V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-1.344',
    ), // key: 1ojbhp
  ]);

  /// `square-arrow-right.mjs`
  static const LucideGlyph squareArrowRight = LucideGlyph(
    'square-arrow-right',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M8 12h8'), // key: 1wcyev
      IconPathElement('m12 16 4-4-4-4'), // key: 1i9zcv
    ],
  );

  /// `square-arrow-up-left.mjs`
  static const LucideGlyph squareArrowUpLeft = LucideGlyph(
    'square-arrow-up-left',
    <IconElement>[
      IconPathElement('M15 15 9 9'), // key: qb9ybb
      IconPathElement('M9 15V9h6'), // key: 1pdr5l
      IconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `square-arrow-up-right.mjs`
  static const LucideGlyph squareArrowUpRight = LucideGlyph(
    'square-arrow-up-right',
    <IconElement>[
      IconPathElement('M15 15V9H9'), // key: vxyd2h
      IconPathElement('m9 15 6-6'), // key: 1ygkhp
      IconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `square-arrow-up.mjs`
  static const LucideGlyph squareArrowUp = LucideGlyph(
    'square-arrow-up',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('m16 12-4-4-4 4'), // key: 177agl
      IconPathElement('M12 16V8'), // key: 1sbj14
    ],
  );

  /// `square-asterisk.mjs`
  static const LucideGlyph squareAsterisk = LucideGlyph(
    'square-asterisk',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M12 8v8'), // key: napkw2
      IconPathElement('m8.5 14 7-4'), // key: 12hpby
      IconPathElement('m8.5 10 7 4'), // key: wwy2dy
    ],
  );

  /// `square-bottom-dashed-scissors.mjs`
  static const LucideGlyph squareBottomDashedScissors = LucideGlyph(
    'square-bottom-dashed-scissors',
    <IconElement>[
      IconPathElement('M14 21h1'), // key: v9vybs
      IconPathElement('m17 17-2.18-2.18'), // key: 1y7dt1
      IconPathElement(
        'M5 21a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v14a2 2 0 01-2 2',
      ), // key: 2q1jq4
      IconPathElement('M9 21h1'), // key: 15o7lz
      IconPathElement('M9.56 14.44 17 7'), // key: ue8l15
      IconPathElement('M9.56 9.56 12 12'), // key: rml9qv
      IconCircleElement(8.5, 15.5, 1.5), // key: 12hfy1
      IconCircleElement(8.5, 8.5, 1.5), // key: cn5opk
    ],
  );

  /// `square-centerline-dashed-horizontal.mjs`
  static const LucideGlyph squareCenterlineDashedHorizontal = LucideGlyph(
    'square-centerline-dashed-horizontal',
    <IconElement>[
      IconPathElement('M8 3H5a2 2 0 0 0-2 2v14c0 1.1.9 2 2 2h3'), // key: 1i73f7
      IconPathElement(
        'M16 3h3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-3',
      ), // key: saxlbk
      IconPathElement('M12 20v2'), // key: 1lh1kg
      IconPathElement('M12 14v2'), // key: 8jcxud
      IconPathElement('M12 8v2'), // key: 1woqiv
      IconPathElement('M12 2v2'), // key: tus03m
    ],
  );

  /// `square-centerline-dashed-vertical.mjs`
  static const LucideGlyph squareCenterlineDashedVertical = LucideGlyph(
    'square-centerline-dashed-vertical',
    <IconElement>[
      IconPathElement('M21 8V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v3'), // key: 14bfxa
      IconPathElement(
        'M21 16v3a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-3',
      ), // key: 14rx03
      IconPathElement('M4 12H2'), // key: rhcxmi
      IconPathElement('M10 12H8'), // key: s88cx1
      IconPathElement('M16 12h-2'), // key: 10asgb
      IconPathElement('M22 12h-2'), // key: 14jgyd
    ],
  );

  /// `square-chart-gantt.mjs`
  static const LucideGlyph squareChartGantt = LucideGlyph(
    'square-chart-gantt',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M9 8h7'), // key: kbo1nt
      IconPathElement('M8 12h6'), // key: ikassy
      IconPathElement('M11 16h5'), // key: oq65wt
    ],
  );

  /// `square-check-big.mjs`
  static const LucideGlyph squareCheckBig = LucideGlyph(
    'square-check-big',
    <IconElement>[
      IconPathElement(
        'M21 10.656V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h12.344',
      ), // key: 2acyp4
      IconPathElement('m9 11 3 3L22 4'), // key: 1pflzl
    ],
  );

  /// `square-check.mjs`
  static const LucideGlyph squareCheck = LucideGlyph(
    'square-check',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('m9 12 2 2 4-4'), // key: dzmm74
    ],
  );

  /// `square-chevron-down.mjs`
  static const LucideGlyph squareChevronDown = LucideGlyph(
    'square-chevron-down',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('m16 10-4 4-4-4'), // key: 894hmk
    ],
  );

  /// `square-chevron-left.mjs`
  static const LucideGlyph squareChevronLeft = LucideGlyph(
    'square-chevron-left',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('m14 16-4-4 4-4'), // key: ojs7w8
    ],
  );

  /// `square-chevron-right.mjs`
  static const LucideGlyph squareChevronRight = LucideGlyph(
    'square-chevron-right',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('m10 8 4 4-4 4'), // key: 1wy4r4
    ],
  );

  /// `square-chevron-up.mjs`
  static const LucideGlyph squareChevronUp = LucideGlyph(
    'square-chevron-up',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('m8 14 4-4 4 4'), // key: fy2ptz
    ],
  );

  /// `square-code.mjs`
  static const LucideGlyph squareCode = LucideGlyph(
    'square-code',
    <IconElement>[
      IconPathElement('m10 9-3 3 3 3'), // key: 1oro0q
      IconPathElement('m14 15 3-3-3-3'), // key: bz13h7
      IconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `square-dashed-bottom-code.mjs`
  static const LucideGlyph squareDashedBottomCode = LucideGlyph(
    'square-dashed-bottom-code',
    <IconElement>[
      IconPathElement('M10 9.5 8 12l2 2.5'), // key: 3mjy60
      IconPathElement('M14 21h1'), // key: v9vybs
      IconPathElement('m14 9.5 2 2.5-2 2.5'), // key: 1bir2l
      IconPathElement(
        'M5 21a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2',
      ), // key: as5y1o
      IconPathElement('M9 21h1'), // key: 15o7lz
    ],
  );

  /// `square-dashed-bottom.mjs`
  static const LucideGlyph squareDashedBottom = LucideGlyph(
    'square-dashed-bottom',
    <IconElement>[
      IconPathElement(
        'M5 21a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2',
      ), // key: as5y1o
      IconPathElement('M9 21h1'), // key: 15o7lz
      IconPathElement('M14 21h1'), // key: v9vybs
    ],
  );

  /// `square-dashed-kanban.mjs`
  static const LucideGlyph squareDashedKanban = LucideGlyph(
    'square-dashed-kanban',
    <IconElement>[
      IconPathElement('M8 7v7'), // key: 1x2jlm
      IconPathElement('M12 7v4'), // key: xawao1
      IconPathElement('M16 7v9'), // key: 1hp2iy
      IconPathElement('M5 3a2 2 0 0 0-2 2'), // key: y57alp
      IconPathElement('M9 3h1'), // key: 1yesri
      IconPathElement('M14 3h1'), // key: 1ec4yj
      IconPathElement('M19 3a2 2 0 0 1 2 2'), // key: 18rm91
      IconPathElement('M21 9v1'), // key: mxsmne
      IconPathElement('M21 14v1'), // key: 169vum
      IconPathElement('M21 19a2 2 0 0 1-2 2'), // key: 1j7049
      IconPathElement('M14 21h1'), // key: v9vybs
      IconPathElement('M9 21h1'), // key: 15o7lz
      IconPathElement('M5 21a2 2 0 0 1-2-2'), // key: sbafld
      IconPathElement('M3 14v1'), // key: vnatye
      IconPathElement('M3 9v1'), // key: 1r0deq
    ],
  );

  /// `square-dashed-mouse-pointer.mjs`
  static const LucideGlyph
  squareDashedMousePointer = LucideGlyph('square-dashed-mouse-pointer', <
    IconElement
  >[
    IconPathElement(
      'M12.034 12.681a.498.498 0 0 1 .647-.647l9 3.5a.5.5 0 0 1-.033.943l-3.444 1.068a1 1 0 0 0-.66.66l-1.067 3.443a.5.5 0 0 1-.943.033z',
    ), // key: xwnzip
    IconPathElement('M5 3a2 2 0 0 0-2 2'), // key: y57alp
    IconPathElement('M19 3a2 2 0 0 1 2 2'), // key: 18rm91
    IconPathElement('M5 21a2 2 0 0 1-2-2'), // key: sbafld
    IconPathElement('M9 3h1'), // key: 1yesri
    IconPathElement('M9 21h2'), // key: 1qve2z
    IconPathElement('M14 3h1'), // key: 1ec4yj
    IconPathElement('M3 9v1'), // key: 1r0deq
    IconPathElement('M21 9v2'), // key: p14lih
    IconPathElement('M3 14v1'), // key: vnatye
  ]);

  /// `square-dashed-text.mjs`
  static const LucideGlyph squareDashedText = LucideGlyph(
    'square-dashed-text',
    <IconElement>[
      IconPathElement('M14 21h1'), // key: v9vybs
      IconPathElement('M14 3h1'), // key: 1ec4yj
      IconPathElement('M19 3a2 2 0 0 1 2 2'), // key: 18rm91
      IconPathElement('M21 14v1'), // key: 169vum
      IconPathElement('M21 19a2 2 0 0 1-2 2'), // key: 1j7049
      IconPathElement('M21 9v1'), // key: mxsmne
      IconPathElement('M3 14v1'), // key: vnatye
      IconPathElement('M3 9v1'), // key: 1r0deq
      IconPathElement('M5 21a2 2 0 0 1-2-2'), // key: sbafld
      IconPathElement('M5 3a2 2 0 0 0-2 2'), // key: y57alp
      IconPathElement('M7 12h10'), // key: b7w52i
      IconPathElement('M7 16h6'), // key: 1vyc9m
      IconPathElement('M7 8h8'), // key: 1jbsf9
      IconPathElement('M9 21h1'), // key: 15o7lz
      IconPathElement('M9 3h1'), // key: 1yesri
    ],
  );

  /// `square-dashed-top-solid.mjs`
  static const LucideGlyph squareDashedTopSolid = LucideGlyph(
    'square-dashed-top-solid',
    <IconElement>[
      IconPathElement('M14 21h1'), // key: v9vybs
      IconPathElement('M21 14v1'), // key: 169vum
      IconPathElement('M21 19a2 2 0 0 1-2 2'), // key: 1j7049
      IconPathElement('M21 9v1'), // key: mxsmne
      IconPathElement('M3 14v1'), // key: vnatye
      IconPathElement('M3 5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2'), // key: 89voep
      IconPathElement('M3 9v1'), // key: 1r0deq
      IconPathElement('M5 21a2 2 0 0 1-2-2'), // key: sbafld
      IconPathElement('M9 21h1'), // key: 15o7lz
    ],
  );

  /// `square-dashed.mjs`
  static const LucideGlyph squareDashed = LucideGlyph(
    'square-dashed',
    <IconElement>[
      IconPathElement('M5 3a2 2 0 0 0-2 2'), // key: y57alp
      IconPathElement('M19 3a2 2 0 0 1 2 2'), // key: 18rm91
      IconPathElement('M21 19a2 2 0 0 1-2 2'), // key: 1j7049
      IconPathElement('M5 21a2 2 0 0 1-2-2'), // key: sbafld
      IconPathElement('M9 3h1'), // key: 1yesri
      IconPathElement('M9 21h1'), // key: 15o7lz
      IconPathElement('M14 3h1'), // key: 1ec4yj
      IconPathElement('M14 21h1'), // key: v9vybs
      IconPathElement('M3 9v1'), // key: 1r0deq
      IconPathElement('M21 9v1'), // key: mxsmne
      IconPathElement('M3 14v1'), // key: vnatye
      IconPathElement('M21 14v1'), // key: 169vum
    ],
  );

  /// `square-divide.mjs`
  static const LucideGlyph squareDivide = LucideGlyph(
    'square-divide',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
      IconLineElement(8, 12, 16, 12), // key: 1jonct
      IconLineElement(12, 16, 12, 16), // key: aqc6ln
      IconLineElement(12, 8, 12, 8), // key: 1mkcni
    ],
  );

  /// `square-dot.mjs`
  static const LucideGlyph squareDot = LucideGlyph('square-dot', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    IconCircleElement(12, 12, 1), // key: 41hilf
  ]);

  /// `square-equal.mjs`
  static const LucideGlyph squareEqual = LucideGlyph(
    'square-equal',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M7 10h10'), // key: 1101jm
      IconPathElement('M7 14h10'), // key: 1mhdw3
    ],
  );

  /// `square-function.mjs`
  static const LucideGlyph squareFunction = LucideGlyph(
    'square-function',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
      IconPathElement(
        'M9 17c2 0 2.8-1 2.8-2.8V10c0-2 1-3.3 3.2-3',
      ), // key: m1af9g
      IconPathElement('M9 11.2h5.7'), // key: 3zgcl2
    ],
  );

  /// `square-kanban.mjs`
  static const LucideGlyph squareKanban = LucideGlyph(
    'square-kanban',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M8 7v7'), // key: 1x2jlm
      IconPathElement('M12 7v4'), // key: xawao1
      IconPathElement('M16 7v9'), // key: 1hp2iy
    ],
  );

  /// `square-library.mjs`
  static const LucideGlyph squareLibrary = LucideGlyph(
    'square-library',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M7 7v10'), // key: d5nglc
      IconPathElement('M11 7v10'), // key: pptsnr
      IconPathElement('m15 7 2 10'), // key: 1m7qm5
    ],
  );

  /// `square-m.mjs`
  static const LucideGlyph squareM = LucideGlyph('square-m', <IconElement>[
    IconPathElement(
      'M8 16V8.5a.5.5 0 0 1 .9-.3l2.7 3.599a.5.5 0 0 0 .8 0l2.7-3.6a.5.5 0 0 1 .9.3V16',
    ), // key: 1ywlsj
    IconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `square-menu.mjs`
  static const LucideGlyph squareMenu = LucideGlyph(
    'square-menu',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M7 8h10'), // key: 1jw688
      IconPathElement('M7 12h10'), // key: b7w52i
      IconPathElement('M7 16h10'), // key: wp8him
    ],
  );

  /// `square-minus.mjs`
  static const LucideGlyph squareMinus = LucideGlyph(
    'square-minus',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M8 12h8'), // key: 1wcyev
    ],
  );

  /// `square-mouse-pointer.mjs`
  static const LucideGlyph
  squareMousePointer = LucideGlyph('square-mouse-pointer', <IconElement>[
    IconPathElement(
      'M12.034 12.681a.498.498 0 0 1 .647-.647l9 3.5a.5.5 0 0 1-.033.943l-3.444 1.068a1 1 0 0 0-.66.66l-1.067 3.443a.5.5 0 0 1-.943.033z',
    ), // key: xwnzip
    IconPathElement(
      'M21 11V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h6',
    ), // key: 14rsvq
  ]);

  /// `square-off.mjs`
  static const LucideGlyph squareOff = LucideGlyph('square-off', <IconElement>[
    IconPathElement(
      'M20.4 20.4a2 2 0 01-1.4.6H5a2 2 0 01-2-2V5a2 2 0 01.59-1.41',
    ), // key: 7ym6nm
    IconPathElement('M21 15.3V5a2 2 0 00-2-2H8.7'), // key: m4nk5y
    IconPathElement('M22 22 2 2'), // key: 1r8tn9
  ]);

  /// `square-parking-off.mjs`
  static const LucideGlyph squareParkingOff = LucideGlyph(
    'square-parking-off',
    <IconElement>[
      IconPathElement(
        'M3.6 3.6A2 2 0 0 1 5 3h14a2 2 0 0 1 2 2v14a2 2 0 0 1-.59 1.41',
      ), // key: 9l1ft6
      IconPathElement('M3 8.7V19a2 2 0 0 0 2 2h10.3'), // key: 17knke
      IconPathElement('m2 2 20 20'), // key: 1ooewy
      IconPathElement('M13 13a3 3 0 1 0 0-6H9v2'), // key: uoagbd
      IconPathElement('M9 17v-2.3'), // key: 1jxgo2
    ],
  );

  /// `square-parking.mjs`
  static const LucideGlyph squareParking = LucideGlyph(
    'square-parking',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M9 17V7h4a3 3 0 0 1 0 6H9'), // key: 1dfk2c
    ],
  );

  /// `square-pause.mjs`
  static const LucideGlyph squarePause = LucideGlyph(
    'square-pause',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconLineElement(10, 15, 10, 9), // key: c1nkhi
      IconLineElement(14, 15, 14, 9), // key: h65svq
    ],
  );

  /// `square-pen.mjs`
  static const LucideGlyph squarePen = LucideGlyph('square-pen', <IconElement>[
    IconPathElement(
      'M12 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7',
    ), // key: 1m0v6g
    IconPathElement(
      'M18.375 2.625a1 1 0 0 1 3 3l-9.013 9.014a2 2 0 0 1-.853.505l-2.873.84a.5.5 0 0 1-.62-.62l.84-2.873a2 2 0 0 1 .506-.852z',
    ), // key: ohrbg2
  ]);

  /// `square-percent.mjs`
  static const LucideGlyph squarePercent = LucideGlyph(
    'square-percent',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('m15 9-6 6'), // key: 1uzhvr
      IconPathElement('M9 9h.01'), // key: 1q5me6
      IconPathElement('M15 15h.01'), // key: lqbp3k
    ],
  );

  /// `square-pi.mjs`
  static const LucideGlyph squarePi = LucideGlyph('square-pi', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    IconPathElement('M7 7h10'), // key: udp07y
    IconPathElement('M10 7v10'), // key: i1d9ee
    IconPathElement('M16 17a2 2 0 0 1-2-2V7'), // key: ftwdc7
  ]);

  /// `square-pilcrow.mjs`
  static const LucideGlyph squarePilcrow = LucideGlyph(
    'square-pilcrow',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M12 12H9.5a2.5 2.5 0 0 1 0-5H17'), // key: 1l9586
      IconPathElement('M12 7v10'), // key: jspqdw
      IconPathElement('M16 7v10'), // key: lavkr4
    ],
  );

  /// `square-play.mjs`
  static const LucideGlyph
  squarePlay = LucideGlyph('square-play', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2), // key: h1oib
    IconPathElement(
      'M9 9.003a1 1 0 0 1 1.517-.859l4.997 2.997a1 1 0 0 1 0 1.718l-4.997 2.997A1 1 0 0 1 9 14.996z',
    ), // key: kmsa83
  ]);

  /// `square-plus.mjs`
  static const LucideGlyph squarePlus = LucideGlyph(
    'square-plus',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M8 12h8'), // key: 1wcyev
      IconPathElement('M12 8v8'), // key: napkw2
    ],
  );

  /// `square-power.mjs`
  static const LucideGlyph squarePower = LucideGlyph(
    'square-power',
    <IconElement>[
      IconPathElement('M12 7v4'), // key: xawao1
      IconPathElement('M7.998 9.003a5 5 0 1 0 8-.005'), // key: 1pek45
      IconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `square-radical.mjs`
  static const LucideGlyph squareRadical = LucideGlyph(
    'square-radical',
    <IconElement>[
      IconPathElement('M7 12h2l2 5 2-10h4'), // key: 1fxv6h
      IconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `square-round-corner.mjs`
  static const LucideGlyph squareRoundCorner = LucideGlyph(
    'square-round-corner',
    <IconElement>[
      IconPathElement('M21 11a8 8 0 0 0-8-8'), // key: 1lxwo5
      IconPathElement(
        'M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4',
      ), // key: 1dv2y5
    ],
  );

  /// `square-scissors.mjs`
  static const LucideGlyph squareScissors = LucideGlyph(
    'square-scissors',
    <IconElement>[
      IconPathElement('m17 17-2.18-2.18'), // key: 1y7dt1
      IconPathElement('M9.56 14.44 17 7'), // key: ue8l15
      IconPathElement('M9.56 9.56 12 12'), // key: rml9qv
      IconCircleElement(8.5, 15.5, 1.5), // key: 12hfy1
      IconCircleElement(8.5, 8.5, 1.5), // key: cn5opk
      IconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `square-sigma.mjs`
  static const LucideGlyph squareSigma = LucideGlyph(
    'square-sigma',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M16 8.9V7H8l4 5-4 5h8v-1.9'), // key: 9nih0i
    ],
  );

  /// `square-slash.mjs`
  static const LucideGlyph squareSlash = LucideGlyph(
    'square-slash',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconLineElement(9, 15, 15, 9), // key: 1dfufj
    ],
  );

  /// `square-split-horizontal.mjs`
  static const LucideGlyph squareSplitHorizontal = LucideGlyph(
    'square-split-horizontal',
    <IconElement>[
      IconPathElement('M8 19H5c-1 0-2-1-2-2V7c0-1 1-2 2-2h3'), // key: lubmu8
      IconPathElement('M16 5h3c1 0 2 1 2 2v10c0 1-1 2-2 2h-3'), // key: 1ag34g
      IconLineElement(12, 4, 12, 20), // key: 1tx1rr
    ],
  );

  /// `square-split-vertical.mjs`
  static const LucideGlyph squareSplitVertical = LucideGlyph(
    'square-split-vertical',
    <IconElement>[
      IconPathElement('M5 8V5c0-1 1-2 2-2h10c1 0 2 1 2 2v3'), // key: 1pi83i
      IconPathElement('M19 16v3c0 1-1 2-2 2H7c-1 0-2-1-2-2v-3'), // key: ido5k7
      IconLineElement(4, 12, 20, 12), // key: 1e0a9i
    ],
  );

  /// `square-square.mjs`
  static const LucideGlyph squareSquare = LucideGlyph(
    'square-square',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: h1oib
      IconRectElement(8, 8, 8, 8, 1), // key: z9xiuo
    ],
  );

  /// `square-stack.mjs`
  static const LucideGlyph squareStack = LucideGlyph(
    'square-stack',
    <IconElement>[
      IconPathElement(
        'M4 10c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h4c1.1 0 2 .9 2 2',
      ), // key: 4i38lg
      IconPathElement(
        'M10 16c-1.1 0-2-.9-2-2v-4c0-1.1.9-2 2-2h4c1.1 0 2 .9 2 2',
      ), // key: mlte4a
      IconRectElement(14, 14, 8, 8, 2), // key: 1fa9i4
    ],
  );

  /// `square-star.mjs`
  static const LucideGlyph
  squareStar = LucideGlyph('square-star', <IconElement>[
    IconPathElement(
      'M11.035 7.69a1 1 0 0 1 1.909.024l.737 1.452a1 1 0 0 0 .737.535l1.634.256a1 1 0 0 1 .588 1.806l-1.172 1.168a1 1 0 0 0-.282.866l.259 1.613a1 1 0 0 1-1.541 1.134l-1.465-.75a1 1 0 0 0-.912 0l-1.465.75a1 1 0 0 1-1.539-1.133l.258-1.613a1 1 0 0 0-.282-.866l-1.156-1.153a1 1 0 0 1 .572-1.822l1.633-.256a1 1 0 0 0 .737-.535z',
    ), // key: 13edca
    IconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `square-stop.mjs`
  static const LucideGlyph squareStop = LucideGlyph(
    'square-stop',
    <IconElement>[
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconRectElement(9, 9, 6, 6, 1), // key: 1ssd4o
    ],
  );

  /// `square-terminal.mjs`
  static const LucideGlyph squareTerminal = LucideGlyph(
    'square-terminal',
    <IconElement>[
      IconPathElement('m7 11 2-2-2-2'), // key: 1lz0vl
      IconPathElement('M11 13h4'), // key: 1p7l4v
      IconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    ],
  );

  /// `square-user-round.mjs`
  static const LucideGlyph squareUserRound = LucideGlyph(
    'square-user-round',
    <IconElement>[
      IconPathElement('M18 21a6 6 0 0 0-12 0'), // key: kaz2du
      IconCircleElement(12, 11, 4), // key: 1gt34v
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    ],
  );

  /// `square-user.mjs`
  static const LucideGlyph
  squareUser = LucideGlyph('square-user', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    IconCircleElement(12, 10, 3), // key: ilqhr7
    IconPathElement('M7 21v-2a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v2'), // key: 1m6ac2
  ]);

  /// `square-x.mjs`
  static const LucideGlyph squareX = LucideGlyph('square-x', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    IconPathElement('m15 9-6 6'), // key: 1uzhvr
    IconPathElement('m9 9 6 6'), // key: z0biqf
  ]);

  /// `square.mjs`
  static const LucideGlyph square = LucideGlyph('square', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2), // key: afitv7
  ]);

  /// `squares-exclude.mjs`
  static const LucideGlyph
  squaresExclude = LucideGlyph('squares-exclude', <IconElement>[
    IconPathElement(
      'M16 12v2a2 2 0 0 1-2 2H9a1 1 0 0 0-1 1v3a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V10a2 2 0 0 0-2-2h0',
    ), // key: 1mcohs
    IconPathElement(
      'M4 16a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v3a1 1 0 0 1-1 1h-5a2 2 0 0 0-2 2v2',
    ), // key: 1r1efp
  ]);

  /// `squares-intersect.mjs`
  static const LucideGlyph squaresIntersect = LucideGlyph(
    'squares-intersect',
    <IconElement>[
      IconPathElement('M10 22a2 2 0 0 1-2-2'), // key: i7yj1i
      IconPathElement('M14 2a2 2 0 0 1 2 2'), // key: 170a0m
      IconPathElement('M16 22h-2'), // key: 18d249
      IconPathElement('M2 10V8'), // key: 7yj4fe
      IconPathElement('M2 4a2 2 0 0 1 2-2'), // key: ddgnws
      IconPathElement('M20 8a2 2 0 0 1 2 2'), // key: 1770vt
      IconPathElement('M22 14v2'), // key: iot8ja
      IconPathElement('M22 20a2 2 0 0 1-2 2'), // key: qj8q6g
      IconPathElement('M4 16a2 2 0 0 1-2-2'), // key: 1dnafg
      IconPathElement(
        'M8 10a2 2 0 0 1 2-2h5a1 1 0 0 1 1 1v5a2 2 0 0 1-2 2H9a1 1 0 0 1-1-1z',
      ), // key: ci6f0b
      IconPathElement('M8 2h2'), // key: 1gmkwm
    ],
  );

  /// `squares-subtract.mjs`
  static const LucideGlyph
  squaresSubtract = LucideGlyph('squares-subtract', <IconElement>[
    IconPathElement('M10 22a2 2 0 0 1-2-2'), // key: i7yj1i
    IconPathElement('M16 22h-2'), // key: 18d249
    IconPathElement(
      'M16 4a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h3a1 1 0 0 0 1-1v-5a2 2 0 0 1 2-2h5a1 1 0 0 0 1-1z',
    ), // key: 1njgbb
    IconPathElement('M20 8a2 2 0 0 1 2 2'), // key: 1770vt
    IconPathElement('M22 14v2'), // key: iot8ja
    IconPathElement('M22 20a2 2 0 0 1-2 2'), // key: qj8q6g
  ]);

  /// `squares-unite.mjs`
  static const LucideGlyph
  squaresUnite = LucideGlyph('squares-unite', <IconElement>[
    IconPathElement(
      'M4 16a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v3a1 1 0 0 0 1 1h3a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H10a2 2 0 0 1-2-2v-3a1 1 0 0 0-1-1z',
    ), // key: 17jnth
  ]);

  /// `squircle-dashed.mjs`
  static const LucideGlyph
  squircleDashed = LucideGlyph('squircle-dashed', <IconElement>[
    IconPathElement('M13.77 3.043a34 34 0 0 0-3.54 0'), // key: 1oaobr
    IconPathElement('M13.771 20.956a33 33 0 0 1-3.541.001'), // key: 95iq0j
    IconPathElement(
      'M20.18 17.74c-.51 1.15-1.29 1.93-2.439 2.44',
    ), // key: 1u6qty
    IconPathElement(
      'M20.18 6.259c-.51-1.148-1.291-1.929-2.44-2.438',
    ), // key: 1ew6g6
    IconPathElement('M20.957 10.23a33 33 0 0 1 0 3.54'), // key: 1l9npr
    IconPathElement('M3.043 10.23a34 34 0 0 0 .001 3.541'), // key: 1it6jm
    IconPathElement(
      'M6.26 20.179c-1.15-.508-1.93-1.29-2.44-2.438',
    ), // key: 14uchd
    IconPathElement('M6.26 3.82c-1.149.51-1.93 1.291-2.44 2.44'), // key: 8k4agb
  ]);

  /// `squircle.mjs`
  static const LucideGlyph squircle = LucideGlyph('squircle', <IconElement>[
    IconPathElement(
      'M12 3c7.2 0 9 1.8 9 9s-1.8 9-9 9-9-1.8-9-9 1.8-9 9-9',
    ), // key: garfkc
  ]);

  /// `squirrel.mjs`
  static const LucideGlyph squirrel = LucideGlyph('squirrel', <IconElement>[
    IconPathElement('M15.236 22a3 3 0 0 0-2.2-5'), // key: 21bitc
    IconPathElement(
      'M16 20a3 3 0 0 1 3-3h1a2 2 0 0 0 2-2v-2a4 4 0 0 0-4-4V4',
    ), // key: oh0fg0
    IconPathElement('M18 13h.01'), // key: 9veqaj
    IconPathElement(
      'M18 6a4 4 0 0 0-4 4 7 7 0 0 0-7 7c0-5 4-5 4-10.5a4.5 4.5 0 1 0-9 0 2.5 2.5 0 0 0 5 0C7 10 3 11 3 17c0 2.8 2.2 5 5 5h10',
    ), // key: 980v8a
  ]);

  /// `stamp.mjs`
  static const LucideGlyph stamp = LucideGlyph('stamp', <IconElement>[
    IconPathElement(
      'M14 13V8.5C14 7 15 7 15 5a3 3 0 0 0-6 0c0 2 1 2 1 3.5V13',
    ), // key: i9gjdv
    IconPathElement(
      'M20 15.5a2.5 2.5 0 0 0-2.5-2.5h-11A2.5 2.5 0 0 0 4 15.5V17a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1z',
    ), // key: 1vzg3v
    IconPathElement('M5 22h14'), // key: ehvnwv
  ]);

  /// `star-check.mjs`
  static const LucideGlyph starCheck = LucideGlyph('star-check', <IconElement>[
    IconPathElement(
      'm19.06 12.501 2.78-2.707a.53.53 0 0 0-.294-.905l-5.166-.755a2.1 2.1 0 0 1-1.595-1.16l-2.31-4.68a.53.53 0 0 0-.95.001L9.216 6.974a2.1 2.1 0 0 1-1.597 1.16l-5.165.755a.53.53 0 0 0-.294.906l3.736 3.637a2.1 2.1 0 0 1 .611 1.879l-.88 5.139a.53.53 0 0 0 .769.56l4.617-2.428.027-.014',
    ), // key: 14g7km
    IconPathElement('m15 18 2 2 4-4'), // key: 1szwhi
  ]);

  /// `star-half.mjs`
  static const LucideGlyph starHalf = LucideGlyph('star-half', <IconElement>[
    IconPathElement(
      'M12 18.338a2.1 2.1 0 0 0-.987.244L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.12 2.12 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.12 2.12 0 0 0 1.597-1.16l2.309-4.679A.53.53 0 0 1 12 2',
    ), // key: 2ksp49
  ]);

  /// `star-minus.mjs`
  static const LucideGlyph starMinus = LucideGlyph('star-minus', <IconElement>[
    IconPathElement('M15 18h6'), // key: 3b3c90
    IconPathElement(
      'M17.688 14a2.1 2.1 0 0 1 .416-.568l3.736-3.638a.53.53 0 0 0-.294-.905l-5.166-.755a2.1 2.1 0 0 1-1.595-1.16l-2.31-4.68a.53.53 0 0 0-.95.001L9.216 6.974a2.1 2.1 0 0 1-1.597 1.16l-5.165.755a.53.53 0 0 0-.294.906l3.736 3.637a2.1 2.1 0 0 1 .611 1.879l-.88 5.139a.53.53 0 0 0 .769.56l4.617-2.428.027-.014',
    ), // key: rwo527
  ]);

  /// `star-off.mjs`
  static const LucideGlyph starOff = LucideGlyph('star-off', <IconElement>[
    IconPathElement(
      'm10.344 4.688 1.181-2.393a.53.53 0 0 1 .95 0l2.31 4.679a2.12 2.12 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.237 3.152',
    ), // key: 19ctli
    IconPathElement(
      'm17.945 17.945.43 2.505a.53.53 0 0 1-.771.56l-4.618-2.428a2.12 2.12 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.12 2.12 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a8 8 0 0 0 .4-.099',
    ), // key: ptqqvy
    IconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `star-plus.mjs`
  static const LucideGlyph starPlus = LucideGlyph('star-plus', <IconElement>[
    IconPathElement(
      'M11.013 18.582 6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.12 2.12 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.12 2.12 0 0 0 1.597-1.16l2.309-4.679a.53.53 0 0 1 .95 0l2.31 4.679a2.12 2.12 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904L20 11.5',
    ), // key: 1hs8rk
    IconPathElement('M15 18h6'), // key: 3b3c90
    IconPathElement('M18 15v6'), // key: 9wciyi
  ]);

  /// `star-x.mjs`
  static const LucideGlyph starX = LucideGlyph('star-x', <IconElement>[
    IconPathElement('m15.5 15.5 5 5'), // key: 1ky94l
    IconPathElement(
      'm20.063 11.525 1.777-1.731a.53.53 0 0 0-.294-.905l-5.166-.755a2.1 2.1 0 0 1-1.595-1.16l-2.31-4.68a.53.53 0 0 0-.95.001L9.216 6.974a2.1 2.1 0 0 1-1.597 1.16l-5.165.755a.53.53 0 0 0-.294.906l3.736 3.637a2.1 2.1 0 0 1 .611 1.879l-.88 5.139a.53.53 0 0 0 .769.56l4.617-2.428a2.1 2.1 0 0 1 .987-.243 2 2 0 0 1 .132.004',
    ), // key: 6uuto3
    IconPathElement('m20.5 15.5-5 5'), // key: 1w5am3
  ]);

  /// `star.mjs`
  static const LucideGlyph star = LucideGlyph('star', <IconElement>[
    IconPathElement(
      'M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z',
    ), // key: r04s7s
  ]);

  /// `step-back.mjs`
  static const LucideGlyph stepBack = LucideGlyph('step-back', <IconElement>[
    IconPathElement(
      'M13.971 4.285A2 2 0 0 1 17 6v12a2 2 0 0 1-3.029 1.715l-9.997-5.998a2 2 0 0 1-.003-3.432z',
    ), // key: 19qhus
    IconPathElement('M21 20V4'), // key: cb8qj8
  ]);

  /// `step-forward.mjs`
  static const LucideGlyph
  stepForward = LucideGlyph('step-forward', <IconElement>[
    IconPathElement(
      'M10.029 4.285A2 2 0 0 0 7 6v12a2 2 0 0 0 3.029 1.715l9.997-5.998a2 2 0 0 0 .003-3.432z',
    ), // key: 1ystz2
    IconPathElement('M3 4v16'), // key: 1ph11n
  ]);

  /// `stethoscope.mjs`
  static const LucideGlyph stethoscope = LucideGlyph(
    'stethoscope',
    <IconElement>[
      IconPathElement('M11 2v2'), // key: 1539x4
      IconPathElement('M5 2v2'), // key: 1yf1q8
      IconPathElement(
        'M5 3H4a2 2 0 0 0-2 2v4a6 6 0 0 0 12 0V5a2 2 0 0 0-2-2h-1',
      ), // key: rb5t3r
      IconPathElement('M8 15a6 6 0 0 0 12 0v-3'), // key: x18d4x
      IconCircleElement(20, 10, 2), // key: ts1r5v
    ],
  );

  /// `sticker.mjs`
  static const LucideGlyph sticker = LucideGlyph('sticker', <IconElement>[
    IconPathElement(
      'M21 9a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 15 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2z',
    ), // key: 1dfntj
    IconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
    IconPathElement('M8 13h.01'), // key: 1sbv64
    IconPathElement('M16 13h.01'), // key: wip0gl
    IconPathElement('M10 16s.8 1 2 1c1.3 0 2-1 2-1'), // key: 1vvgv3
  ]);

  /// `sticky-note-check.mjs`
  static const LucideGlyph
  stickyNoteCheck = LucideGlyph('sticky-note-check', <IconElement>[
    IconPathElement('m15 19 2 2 4-4'), // key: 1wqv71
    IconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
    IconPathElement(
      'M21 13V9a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 15 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h6.5',
    ), // key: 1onoss
  ]);

  /// `sticky-note-minus.mjs`
  static const LucideGlyph
  stickyNoteMinus = LucideGlyph('sticky-note-minus', <IconElement>[
    IconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
    IconPathElement(
      'M21 14V9a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 15 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h7.35',
    ), // key: g18rj4
    IconPathElement('M21 18h-6'), // key: 139f0c
  ]);

  /// `sticky-note-off.mjs`
  static const LucideGlyph
  stickyNoteOff = LucideGlyph('sticky-note-off', <IconElement>[
    IconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement(
      'M3.586 3.586A2 2 0 0 0 3 5v14a2 2 0 0 0 2 2h14a2 2 0 0 0 1.414-.586',
    ), // key: 12nghy
    IconPathElement(
      'M8.656 3H15a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 21 9v6.344',
    ), // key: 134c6x
  ]);

  /// `sticky-note-plus.mjs`
  static const LucideGlyph
  stickyNotePlus = LucideGlyph('sticky-note-plus', <IconElement>[
    IconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
    IconPathElement('M18 15v6'), // key: 9wciyi
    IconPathElement(
      'M21 12.356V9a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 15 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h7.355',
    ), // key: 12ish9
    IconPathElement('M21 18h-6'), // key: 139f0c
  ]);

  /// `sticky-note-x.mjs`
  static const LucideGlyph
  stickyNoteX = LucideGlyph('sticky-note-x', <IconElement>[
    IconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
    IconPathElement('m16 16 5 5'), // key: 8tpb07
    IconPathElement(
      'M21 12V9a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 15 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h7',
    ), // key: 156tez
    IconPathElement('m21 16-5 5'), // key: kplof2
  ]);

  /// `sticky-note.mjs`
  static const LucideGlyph
  stickyNote = LucideGlyph('sticky-note', <IconElement>[
    IconPathElement(
      'M21 9a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 15 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2z',
    ), // key: 1dfntj
    IconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
  ]);

  /// `sticky-notes.mjs`
  static const LucideGlyph
  stickyNotes = LucideGlyph('sticky-notes', <IconElement>[
    IconPathElement(
      'M10 8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 16 14v6a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V10a2 2 0 0 1 2-2z',
    ), // key: 19nc0g
    IconPathElement('M10 8v5a1 1 0 0 0 1 1h5'), // key: m3law1
    IconPathElement(
      'M8 4a2 2 0 0 1 2-2h6a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 22 8v6a2 2 0 0 1-2 2',
    ), // key: 1iu1qd
    IconPathElement('M16 2v5a1 1 0 0 0 1 1h5'), // key: af171p
  ]);

  /// `stone.mjs`
  static const LucideGlyph stone = LucideGlyph('stone', <IconElement>[
    IconPathElement(
      'M11.264 2.205A4 4 0 0 0 6.42 4.211l-4 8a4 4 0 0 0 1.359 5.117l6 4a4 4 0 0 0 4.438 0l6-4a4 4 0 0 0 1.576-4.592l-2-6a4 4 0 0 0-2.53-2.53z',
    ), // key: 1si4ox
    IconPathElement('M11.99 22 14 12l7.822 3.184'), // key: 1u8to0
    IconPathElement('M14 12 8.47 2.302'), // key: guo3d5
  ]);

  /// `store.mjs`
  static const LucideGlyph store = LucideGlyph('store', <IconElement>[
    IconPathElement(
      'M15 21v-5a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v5',
    ), // key: slp6dd
    IconPathElement(
      'M17.774 10.31a1.12 1.12 0 0 0-1.549 0 2.5 2.5 0 0 1-3.451 0 1.12 1.12 0 0 0-1.548 0 2.5 2.5 0 0 1-3.452 0 1.12 1.12 0 0 0-1.549 0 2.5 2.5 0 0 1-3.77-3.248l2.889-4.184A2 2 0 0 1 7 2h10a2 2 0 0 1 1.653.873l2.895 4.192a2.5 2.5 0 0 1-3.774 3.244',
    ), // key: o0xfot
    IconPathElement(
      'M4 10.95V19a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8.05',
    ), // key: wn3emo
  ]);

  /// `stretch-horizontal.mjs`
  static const LucideGlyph stretchHorizontal = LucideGlyph(
    'stretch-horizontal',
    <IconElement>[
      IconRectElement(2, 4, 20, 6, 2), // key: qdearl
      IconRectElement(2, 14, 20, 6, 2), // key: 1xrn6j
    ],
  );

  /// `stretch-vertical.mjs`
  static const LucideGlyph stretchVertical = LucideGlyph(
    'stretch-vertical',
    <IconElement>[
      IconRectElement(4, 2, 6, 20, 2), // key: 19qu7m
      IconRectElement(14, 2, 6, 20, 2), // key: 24v0nk
    ],
  );

  /// `strikethrough.mjs`
  static const LucideGlyph strikethrough = LucideGlyph(
    'strikethrough',
    <IconElement>[
      IconPathElement('M16 4H9a3 3 0 0 0-2.83 4'), // key: 43sutm
      IconPathElement('M14 12a4 4 0 0 1 0 8H6'), // key: nlfj13
      IconLineElement(4, 12, 20, 12), // key: 1e0a9i
    ],
  );

  /// `subscript.mjs`
  static const LucideGlyph subscript = LucideGlyph('subscript', <IconElement>[
    IconPathElement('m4 5 8 8'), // key: 1eunvl
    IconPathElement('m12 5-8 8'), // key: 1ah0jp
    IconPathElement(
      'M20 19h-4c0-1.5.44-2 1.5-2.5S20 15.33 20 14c0-.47-.17-.93-.48-1.29a2.11 2.11 0 0 0-2.62-.44c-.42.24-.74.62-.9 1.07',
    ), // key: e8ta8j
  ]);

  /// `summary.mjs`
  static const LucideGlyph summary = LucideGlyph('summary', <IconElement>[
    IconPathElement('M15 4H7'), // key: oyc4c8
    IconPathElement('m18 16 3 3-3 3'), // key: 1d4glt
    IconPathElement('M3 4v13a2 2 0 0 0 2 2h16'), // key: o3n0ii
    IconPathElement('M7 14h7'), // key: 16kgpy
    IconPathElement('M7 9h12'), // key: ihq7ma
  ]);

  /// `sun-dim.mjs`
  static const LucideGlyph sunDim = LucideGlyph('sun-dim', <IconElement>[
    IconCircleElement(12, 12, 4), // key: 4exip2
    IconPathElement('M12 4h.01'), // key: 1ujb9j
    IconPathElement('M20 12h.01'), // key: 1ykeid
    IconPathElement('M12 20h.01'), // key: zekei9
    IconPathElement('M4 12h.01'), // key: 158zrr
    IconPathElement('M17.657 6.343h.01'), // key: 31pqzk
    IconPathElement('M17.657 17.657h.01'), // key: jehnf4
    IconPathElement('M6.343 17.657h.01'), // key: gdk6ow
    IconPathElement('M6.343 6.343h.01'), // key: 1uurf0
  ]);

  /// `sun-medium.mjs`
  static const LucideGlyph sunMedium = LucideGlyph('sun-medium', <IconElement>[
    IconCircleElement(12, 12, 4), // key: 4exip2
    IconPathElement('M12 3v1'), // key: 1asbbs
    IconPathElement('M12 20v1'), // key: 1wcdkc
    IconPathElement('M3 12h1'), // key: lp3yf2
    IconPathElement('M20 12h1'), // key: 1vloll
    IconPathElement('m18.364 5.636-.707.707'), // key: 1hakh0
    IconPathElement('m6.343 17.657-.707.707'), // key: 18m9nf
    IconPathElement('m5.636 5.636.707.707'), // key: 1xv1c5
    IconPathElement('m17.657 17.657.707.707'), // key: vl76zb
  ]);

  /// `sun-moon.mjs`
  static const LucideGlyph sunMoon = LucideGlyph('sun-moon', <IconElement>[
    IconPathElement('M12 2v2'), // key: tus03m
    IconPathElement(
      'M14.837 16.385a6 6 0 1 1-7.223-7.222c.624-.147.97.66.715 1.248a4 4 0 0 0 5.26 5.259c.589-.255 1.396.09 1.248.715',
    ), // key: xlf6rm
    IconPathElement('M16 12a4 4 0 0 0-4-4'), // key: 6vsxu
    IconPathElement('m19 5-1.256 1.256'), // key: 1yg6a6
    IconPathElement('M20 12h2'), // key: 1q8mjw
  ]);

  /// `sun-snow.mjs`
  static const LucideGlyph sunSnow = LucideGlyph('sun-snow', <IconElement>[
    IconPathElement('M10 21v-1'), // key: 1u8rkd
    IconPathElement('M10 4V3'), // key: pkzwkn
    IconPathElement('M10 9a3 3 0 0 0 0 6'), // key: gv75dk
    IconPathElement('m14 20 1.25-2.5L18 18'), // key: 1chtki
    IconPathElement('m14 4 1.25 2.5L18 6'), // key: 1b4wsy
    IconPathElement('m17 21-3-6 1.5-3H22'), // key: o5qa3v
    IconPathElement('m17 3-3 6 1.5 3'), // key: 11697g
    IconPathElement('M2 12h1'), // key: 1uaihz
    IconPathElement('m20 10-1.5 2 1.5 2'), // key: 1swlpi
    IconPathElement('m3.64 18.36.7-.7'), // key: 105rm9
    IconPathElement('m4.34 6.34-.7-.7'), // key: d3unjp
  ]);

  /// `sun.mjs`
  static const LucideGlyph sun = LucideGlyph('sun', <IconElement>[
    IconCircleElement(12, 12, 4), // key: 4exip2
    IconPathElement('M12 2v2'), // key: tus03m
    IconPathElement('M12 20v2'), // key: 1lh1kg
    IconPathElement('m4.93 4.93 1.41 1.41'), // key: 149t6j
    IconPathElement('m17.66 17.66 1.41 1.41'), // key: ptbguv
    IconPathElement('M2 12h2'), // key: 1t8f8n
    IconPathElement('M20 12h2'), // key: 1q8mjw
    IconPathElement('m6.34 17.66-1.41 1.41'), // key: 1m8zz5
    IconPathElement('m19.07 4.93-1.41 1.41'), // key: 1shlcs
  ]);

  /// `sunrise.mjs`
  static const LucideGlyph sunrise = LucideGlyph('sunrise', <IconElement>[
    IconPathElement('M12 2v8'), // key: 1q4o3n
    IconPathElement('m4.93 10.93 1.41 1.41'), // key: 2a7f42
    IconPathElement('M2 18h2'), // key: j10viu
    IconPathElement('M20 18h2'), // key: wocana
    IconPathElement('m19.07 10.93-1.41 1.41'), // key: 15zs5n
    IconPathElement('M22 22H2'), // key: 19qnx5
    IconPathElement('m8 6 4-4 4 4'), // key: ybng9g
    IconPathElement('M16 18a4 4 0 0 0-8 0'), // key: 1lzouq
  ]);

  /// `sunset.mjs`
  static const LucideGlyph sunset = LucideGlyph('sunset', <IconElement>[
    IconPathElement('M12 10V2'), // key: 16sf7g
    IconPathElement('m4.93 10.93 1.41 1.41'), // key: 2a7f42
    IconPathElement('M2 18h2'), // key: j10viu
    IconPathElement('M20 18h2'), // key: wocana
    IconPathElement('m19.07 10.93-1.41 1.41'), // key: 15zs5n
    IconPathElement('M22 22H2'), // key: 19qnx5
    IconPathElement('m16 6-4 4-4-4'), // key: 6wukr
    IconPathElement('M16 18a4 4 0 0 0-8 0'), // key: 1lzouq
  ]);

  /// `superscript.mjs`
  static const LucideGlyph
  superscript = LucideGlyph('superscript', <IconElement>[
    IconPathElement('m4 19 8-8'), // key: hr47gm
    IconPathElement('m12 19-8-8'), // key: 1dhhmo
    IconPathElement(
      'M20 12h-4c0-1.5.442-2 1.5-2.5S20 8.334 20 7.002c0-.472-.17-.93-.484-1.29a2.105 2.105 0 0 0-2.617-.436c-.42.239-.738.614-.899 1.06',
    ), // key: 1dfcux
  ]);

  /// `swatch-book.mjs`
  static const LucideGlyph
  swatchBook = LucideGlyph('swatch-book', <IconElement>[
    IconPathElement(
      'M11 17a4 4 0 0 1-8 0V5a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2Z',
    ), // key: 1ldrpk
    IconPathElement(
      'M16.7 13H19a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2H7',
    ), // key: 11i5po
    IconPathElement('M 7 17h.01'), // key: 1euzgo
    IconPathElement(
      'm11 8 2.3-2.3a2.4 2.4 0 0 1 3.404.004L18.6 7.6a2.4 2.4 0 0 1 .026 3.434L9.9 19.8',
    ), // key: o2gii7
  ]);

  /// `swiss-franc.mjs`
  static const LucideGlyph swissFranc = LucideGlyph(
    'swiss-franc',
    <IconElement>[
      IconPathElement('M10 21V3h8'), // key: br2l0g
      IconPathElement('M6 16h9'), // key: 2py0wn
      IconPathElement('M10 9.5h7'), // key: 13dmhz
    ],
  );

  /// `switch-camera.mjs`
  static const LucideGlyph
  switchCamera = LucideGlyph('switch-camera', <IconElement>[
    IconPathElement('M11 19H4a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2h5'), // key: mtk2lu
    IconPathElement('M13 5h7a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-5'), // key: 120jsl
    IconCircleElement(12, 12, 3), // key: 1v7zrd
    IconPathElement('m18 22-3-3 3-3'), // key: kgdoj7
    IconPathElement('m6 2 3 3-3 3'), // key: 1fnbkv
  ]);

  /// `sword.mjs`
  static const LucideGlyph sword = LucideGlyph('sword', <IconElement>[
    IconPathElement('m11 19-6-6'), // key: s7kpr
    IconPathElement('m5 21-2-2'), // key: 1kw20b
    IconPathElement('m8 16-4 4'), // key: 1oqv8h
    IconPathElement('M9.5 17.5 21 6V3h-3L6.5 14.5'), // key: pkxemp
  ]);

  /// `swords.mjs`
  static const LucideGlyph swords = LucideGlyph('swords', <IconElement>[
    IconPolylineElement(<Offset>[
      Offset(14.5, 17.5),
      Offset(3, 6),
      Offset(3, 3),
      Offset(6, 3),
      Offset(17.5, 14.5),
    ]), // key: 1hfsw2
    IconLineElement(13, 19, 19, 13), // key: 1vrmhu
    IconLineElement(16, 16, 20, 20), // key: 1bron3
    IconLineElement(19, 21, 21, 19), // key: 13pww6
    IconPolylineElement(<Offset>[
      Offset(14.5, 6.5),
      Offset(18, 3),
      Offset(21, 3),
      Offset(21, 6),
      Offset(17.5, 9.5),
    ]), // key: hbey2j
    IconLineElement(5, 14, 9, 18), // key: 1hf58s
    IconLineElement(7, 17, 4, 20), // key: pidxm4
    IconLineElement(3, 19, 5, 21), // key: 1pehsh
  ]);

  /// `syringe.mjs`
  static const LucideGlyph syringe = LucideGlyph('syringe', <IconElement>[
    IconPathElement('m18 2 4 4'), // key: 22kx64
    IconPathElement('m17 7 3-3'), // key: 1w1zoj
    IconPathElement(
      'M19 9 8.7 19.3c-1 1-2.5 1-3.4 0l-.6-.6c-1-1-1-2.5 0-3.4L15 5',
    ), // key: 1exhtz
    IconPathElement('m9 11 4 4'), // key: rovt3i
    IconPathElement('m5 19-3 3'), // key: 59f2uf
    IconPathElement('m14 4 6 6'), // key: yqp9t2
  ]);

  /// `table-2.mjs`
  static const LucideGlyph table2 = LucideGlyph('table-2', <IconElement>[
    IconPathElement(
      'M9 3H5a2 2 0 0 0-2 2v4m6-6h10a2 2 0 0 1 2 2v4M9 3v18m0 0h10a2 2 0 0 0 2-2V9M9 21H5a2 2 0 0 1-2-2V9m0 0h18',
    ), // key: gugj83
  ]);

  /// `table-cells-merge.mjs`
  static const LucideGlyph tableCellsMerge = LucideGlyph(
    'table-cells-merge',
    <IconElement>[
      IconPathElement('M12 21v-6'), // key: lihzve
      IconPathElement('M12 9V3'), // key: da5inc
      IconPathElement('M3 15h18'), // key: 5xshup
      IconPathElement('M3 9h18'), // key: 1pudct
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    ],
  );

  /// `table-cells-split.mjs`
  static const LucideGlyph tableCellsSplit = LucideGlyph(
    'table-cells-split',
    <IconElement>[
      IconPathElement('M12 15V9'), // key: 8c7uyn
      IconPathElement('M3 15h18'), // key: 5xshup
      IconPathElement('M3 9h18'), // key: 1pudct
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    ],
  );

  /// `table-columns-split.mjs`
  static const LucideGlyph
  tableColumnsSplit = LucideGlyph('table-columns-split', <IconElement>[
    IconPathElement('M14 14v2'), // key: w2a1xv
    IconPathElement('M14 20v2'), // key: 1lq872
    IconPathElement('M14 2v2'), // key: 6buw04
    IconPathElement('M14 8v2'), // key: i67w9a
    IconPathElement('M2 15h8'), // key: 82wtch
    IconPathElement('M2 3h6a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H2'), // key: up0l64
    IconPathElement('M2 9h8'), // key: yelfik
    IconPathElement('M22 15h-4'), // key: 1es58f
    IconPathElement('M22 3h-2a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h2'), // key: pdjoqf
    IconPathElement('M22 9h-4'), // key: 1luja7
    IconPathElement('M5 3v18'), // key: 14hmio
  ]);

  /// `table-of-contents.mjs`
  static const LucideGlyph tableOfContents = LucideGlyph(
    'table-of-contents',
    <IconElement>[
      IconPathElement('M16 5H3'), // key: m91uny
      IconPathElement('M16 12H3'), // key: 1a2rj7
      IconPathElement('M16 19H3'), // key: zzsher
      IconPathElement('M21 5h.01'), // key: wa75ra
      IconPathElement('M21 12h.01'), // key: msek7k
      IconPathElement('M21 19h.01'), // key: qvbq2j
    ],
  );

  /// `table-properties.mjs`
  static const LucideGlyph tableProperties = LucideGlyph(
    'table-properties',
    <IconElement>[
      IconPathElement('M15 3v18'), // key: 14nvp0
      IconRectElement(3, 3, 18, 18, 2), // key: afitv7
      IconPathElement('M21 9H3'), // key: 1338ky
      IconPathElement('M21 15H3'), // key: 9uk58r
    ],
  );

  /// `table-rows-split.mjs`
  static const LucideGlyph tableRowsSplit = LucideGlyph(
    'table-rows-split',
    <IconElement>[
      IconPathElement('M14 10h2'), // key: 1lstlu
      IconPathElement('M15 22v-8'), // key: 1fwwgm
      IconPathElement('M15 2v4'), // key: 1044rn
      IconPathElement('M2 10h2'), // key: 1r8dkt
      IconPathElement('M20 10h2'), // key: 1ug425
      IconPathElement('M3 19h18'), // key: awlh7x
      IconPathElement(
        'M3 22v-6a2 2 135 0 1 2-2h14a2 2 45 0 1 2 2v6',
      ), // key: ibqhof
      IconPathElement(
        'M3 2v2a2 2 45 0 0 2 2h14a2 2 135 0 0 2-2V2',
      ), // key: 1uenja
      IconPathElement('M8 10h2'), // key: 66od0
      IconPathElement('M9 22v-8'), // key: fmnu31
      IconPathElement('M9 2v4'), // key: j1yeou
    ],
  );

  /// `table.mjs`
  static const LucideGlyph table = LucideGlyph('table', <IconElement>[
    IconPathElement('M12 3v18'), // key: 108xh3
    IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    IconPathElement('M3 9h18'), // key: 1pudct
    IconPathElement('M3 15h18'), // key: 5xshup
  ]);

  /// `tablet-smartphone.mjs`
  static const LucideGlyph tabletSmartphone = LucideGlyph(
    'tablet-smartphone',
    <IconElement>[
      IconRectElement(3, 8, 10, 14, 2), // key: 1vrsiq
      IconPathElement(
        'M5 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v16a2 2 0 0 1-2 2h-2.4',
      ), // key: 1j4zmg
      IconPathElement('M8 18h.01'), // key: lrp35t
    ],
  );

  /// `tablet.mjs`
  static const LucideGlyph tablet = LucideGlyph('tablet', <IconElement>[
    IconRectElement(4, 2, 16, 20, 2, ry: 2), // key: 76otgf
    IconLineElement(12, 18, 12.01, 18), // key: 1dp563
  ]);

  /// `tablets.mjs`
  static const LucideGlyph tablets = LucideGlyph('tablets', <IconElement>[
    IconCircleElement(7, 7, 5), // key: x29byf
    IconCircleElement(17, 17, 5), // key: 1op1d2
    IconPathElement('M12 17h10'), // key: ls21zv
    IconPathElement('m3.46 10.54 7.08-7.08'), // key: 1rehiu
  ]);

  /// `tag-plus.mjs`
  static const LucideGlyph tagPlus = LucideGlyph('tag-plus', <IconElement>[
    IconPathElement('M16 13h6'), // key: 1um0mj
    IconPathElement(
      'm16.5 6.5-3.914-3.914A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l1.79-1.79',
    ), // key: dp0yc9
    IconPathElement('M19 10v6'), // key: 13mz7b
    IconCircleElement(7.5, 7.5, 0.5, filled: true), // key: kqv944
  ]);

  /// `tag-x.mjs`
  static const LucideGlyph tagX = LucideGlyph('tag-x', <IconElement>[
    IconPathElement(
      'm16.5 6.5-3.914-3.914A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.43 2.43 0 0 0 3.42 0l1.79-1.79',
    ), // key: hu94c9
    IconPathElement('m16.5 10.5 5 5'), // key: 1jo8bf
    IconPathElement('m21.5 10.5-5 5'), // key: jzei60
    IconCircleElement(7.5, 7.5, 0.5, filled: true), // key: kqv944
  ]);

  /// `tag.mjs`
  static const LucideGlyph tag = LucideGlyph('tag', <IconElement>[
    IconPathElement(
      'M12.586 2.586A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l6.58-6.58a2.426 2.426 0 0 0 0-3.42z',
    ), // key: vktsd0
    IconCircleElement(7.5, 7.5, 0.5, filled: true), // key: kqv944
  ]);

  /// `tags.mjs`
  static const LucideGlyph tags = LucideGlyph('tags', <IconElement>[
    IconPathElement(
      'M13.172 2a2 2 0 0 1 1.414.586l6.71 6.71a2.4 2.4 0 0 1 0 3.408l-4.592 4.592a2.4 2.4 0 0 1-3.408 0l-6.71-6.71A2 2 0 0 1 6 9.172V3a1 1 0 0 1 1-1z',
    ), // key: 16rjxf
    IconPathElement(
      'M2 7v6.172a2 2 0 0 0 .586 1.414l6.71 6.71a2.4 2.4 0 0 0 3.191.193',
    ), // key: 178nd4
    IconCircleElement(10.5, 6.5, 0.5, filled: true), // key: 12ikhr
  ]);

  /// `tally-1.mjs`
  static const LucideGlyph tally1 = LucideGlyph('tally-1', <IconElement>[
    IconPathElement('M4 4v16'), // key: 6qkkli
  ]);

  /// `tally-2.mjs`
  static const LucideGlyph tally2 = LucideGlyph('tally-2', <IconElement>[
    IconPathElement('M4 4v16'), // key: 6qkkli
    IconPathElement('M9 4v16'), // key: 81ygyz
  ]);

  /// `tally-3.mjs`
  static const LucideGlyph tally3 = LucideGlyph('tally-3', <IconElement>[
    IconPathElement('M4 4v16'), // key: 6qkkli
    IconPathElement('M9 4v16'), // key: 81ygyz
    IconPathElement('M14 4v16'), // key: 12vmem
  ]);

  /// `tally-4.mjs`
  static const LucideGlyph tally4 = LucideGlyph('tally-4', <IconElement>[
    IconPathElement('M4 4v16'), // key: 6qkkli
    IconPathElement('M9 4v16'), // key: 81ygyz
    IconPathElement('M14 4v16'), // key: 12vmem
    IconPathElement('M19 4v16'), // key: 8ij5ei
  ]);

  /// `tally-5.mjs`
  static const LucideGlyph tally5 = LucideGlyph('tally-5', <IconElement>[
    IconPathElement('M4 4v16'), // key: 6qkkli
    IconPathElement('M9 4v16'), // key: 81ygyz
    IconPathElement('M14 4v16'), // key: 12vmem
    IconPathElement('M19 4v16'), // key: 8ij5ei
    IconPathElement('M22 6 2 18'), // key: h9moai
  ]);

  /// `tangent.mjs`
  static const LucideGlyph tangent = LucideGlyph('tangent', <IconElement>[
    IconCircleElement(17, 4, 2), // key: y5j2s2
    IconPathElement('M15.59 5.41 5.41 15.59'), // key: l0vprr
    IconCircleElement(4, 17, 2), // key: 9p4efm
    IconPathElement('M12 22s-4-9-1.5-11.5S22 12 22 12'), // key: 1twk4o
  ]);

  /// `target.mjs`
  static const LucideGlyph target = LucideGlyph('target', <IconElement>[
    IconCircleElement(12, 12, 10), // key: 1mglay
    IconCircleElement(12, 12, 6), // key: 1vlfrh
    IconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `telescope.mjs`
  static const LucideGlyph telescope = LucideGlyph('telescope', <IconElement>[
    IconPathElement(
      'm10.065 12.493-6.18 1.318a.934.934 0 0 1-1.108-.702l-.537-2.15a1.07 1.07 0 0 1 .691-1.265l13.504-4.44',
    ), // key: k4qptu
    IconPathElement('m13.56 11.747 4.332-.924'), // key: 19l80z
    IconPathElement('m16 21-3.105-6.21'), // key: 7oh9d
    IconPathElement(
      'M16.485 5.94a2 2 0 0 1 1.455-2.425l1.09-.272a1 1 0 0 1 1.212.727l1.515 6.06a1 1 0 0 1-.727 1.213l-1.09.272a2 2 0 0 1-2.425-1.455z',
    ), // key: m7xp4m
    IconPathElement('m6.158 8.633 1.114 4.456'), // key: 74o979
    IconPathElement('m8 21 3.105-6.21'), // key: 1fvxut
    IconCircleElement(12, 13, 2), // key: 1c1ljs
  ]);

  /// `tent-tree.mjs`
  static const LucideGlyph tentTree = LucideGlyph('tent-tree', <IconElement>[
    IconCircleElement(4, 4, 2), // key: bt5ra8
    IconPathElement('m14 5 3-3 3 3'), // key: 1sorif
    IconPathElement('m14 10 3-3 3 3'), // key: 1jyi9h
    IconPathElement('M17 14V2'), // key: 8ymqnk
    IconPathElement('M17 14H7l-5 8h20Z'), // key: 13ar7p
    IconPathElement('M8 14v8'), // key: 1ghmqk
    IconPathElement('m9 14 5 8'), // key: 13pgi6
  ]);

  /// `tent.mjs`
  static const LucideGlyph tent = LucideGlyph('tent', <IconElement>[
    IconPathElement('M3.5 21 14 3'), // key: 1szst5
    IconPathElement('M20.5 21 10 3'), // key: 1310c3
    IconPathElement('M15.5 21 12 15l-3.5 6'), // key: 1ddtfw
    IconPathElement('M2 21h20'), // key: 1nyx9w
  ]);

  /// `terminal.mjs`
  static const LucideGlyph terminal = LucideGlyph('terminal', <IconElement>[
    IconPathElement('M12 19h8'), // key: baeox8
    IconPathElement('m4 17 6-6-6-6'), // key: 1yngyt
  ]);

  /// `test-tube-diagonal.mjs`
  static const LucideGlyph testTubeDiagonal = LucideGlyph(
    'test-tube-diagonal',
    <IconElement>[
      IconPathElement(
        'M21 7 6.82 21.18a2.83 2.83 0 0 1-3.99-.01a2.83 2.83 0 0 1 0-4L17 3',
      ), // key: 1ub6xw
      IconPathElement('m16 2 6 6'), // key: 1gw87d
      IconPathElement('M12 16H4'), // key: 1cjfip
    ],
  );

  /// `test-tube.mjs`
  static const LucideGlyph testTube = LucideGlyph('test-tube', <IconElement>[
    IconPathElement(
      'M14.5 2v17.5c0 1.4-1.1 2.5-2.5 2.5c-1.4 0-2.5-1.1-2.5-2.5V2',
    ), // key: 125lnx
    IconPathElement('M8.5 2h7'), // key: csnxdl
    IconPathElement('M14.5 16h-5'), // key: 1ox875
  ]);

  /// `test-tubes.mjs`
  static const LucideGlyph testTubes = LucideGlyph('test-tubes', <IconElement>[
    IconPathElement(
      'M9 2v17.5A2.5 2.5 0 0 1 6.5 22A2.5 2.5 0 0 1 4 19.5V2',
    ), // key: 1hjrqt
    IconPathElement(
      'M20 2v17.5a2.5 2.5 0 0 1-2.5 2.5a2.5 2.5 0 0 1-2.5-2.5V2',
    ), // key: 16lc8n
    IconPathElement('M3 2h7'), // key: 7s29d5
    IconPathElement('M14 2h7'), // key: 7sicin
    IconPathElement('M9 16H4'), // key: 1bfye3
    IconPathElement('M20 16h-5'), // key: ddnjpe
  ]);

  /// `text-align-center.mjs`
  static const LucideGlyph textAlignCenter = LucideGlyph(
    'text-align-center',
    <IconElement>[
      IconPathElement('M21 5H3'), // key: 1fi0y6
      IconPathElement('M17 12H7'), // key: 16if0g
      IconPathElement('M19 19H5'), // key: vjpgq2
    ],
  );

  /// `text-align-end.mjs`
  static const LucideGlyph textAlignEnd = LucideGlyph(
    'text-align-end',
    <IconElement>[
      IconPathElement('M21 5H3'), // key: 1fi0y6
      IconPathElement('M21 12H9'), // key: dn1m92
      IconPathElement('M21 19H7'), // key: 4cu937
    ],
  );

  /// `text-align-justify.mjs`
  static const LucideGlyph textAlignJustify = LucideGlyph(
    'text-align-justify',
    <IconElement>[
      IconPathElement('M3 5h18'), // key: 1u36vt
      IconPathElement('M3 12h18'), // key: 1i2n21
      IconPathElement('M3 19h18'), // key: awlh7x
    ],
  );

  /// `text-align-start.mjs`
  static const LucideGlyph textAlignStart = LucideGlyph(
    'text-align-start',
    <IconElement>[
      IconPathElement('M21 5H3'), // key: 1fi0y6
      IconPathElement('M15 12H3'), // key: 6jk70r
      IconPathElement('M17 19H3'), // key: z6ezky
    ],
  );

  /// `text-cursor-input.mjs`
  static const LucideGlyph
  textCursorInput = LucideGlyph('text-cursor-input', <IconElement>[
    IconPathElement('M12 20h-1a2 2 0 0 1-2-2 2 2 0 0 1-2 2H6'), // key: 1528k5
    IconPathElement('M13 8h7a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2h-7'), // key: 13ksps
    IconPathElement('M5 16H4a2 2 0 0 1-2-2v-4a2 2 0 0 1 2-2h1'), // key: 1n9rhb
    IconPathElement('M6 4h1a2 2 0 0 1 2 2 2 2 0 0 1 2-2h1'), // key: 1mj8rg
    IconPathElement('M9 6v12'), // key: velyjx
  ]);

  /// `text-cursor.mjs`
  static const LucideGlyph
  textCursor = LucideGlyph('text-cursor', <IconElement>[
    IconPathElement('M17 22h-1a4 4 0 0 1-4-4V6a4 4 0 0 1 4-4h1'), // key: uvaxm9
    IconPathElement('M7 22h1a4 4 0 0 0 4-4'), // key: 1l7xii
    IconPathElement('M7 2h1a4 4 0 0 1 4 4'), // key: 1vrvvh
  ]);

  /// `text-initial.mjs`
  static const LucideGlyph
  textInitial = LucideGlyph('text-initial', <IconElement>[
    IconPathElement('M15 5h6'), // key: 1pr8yx
    IconPathElement('M15 12h6'), // key: upa0zy
    IconPathElement('M3 19h18'), // key: awlh7x
    IconPathElement('m3 12 3.553-7.724a.5.5 0 0 1 .894 0L11 12'), // key: 6lvno8
    IconPathElement('M3.92 10h6.16'), // key: 1tl8ex
  ]);

  /// `text-quote.mjs`
  static const LucideGlyph textQuote = LucideGlyph('text-quote', <IconElement>[
    IconPathElement('M17 5H3'), // key: 1cn7zz
    IconPathElement('M21 12H8'), // key: scolzb
    IconPathElement('M21 19H8'), // key: 13qgcb
    IconPathElement('M3 12v7'), // key: 1ri8j3
  ]);

  /// `text-search.mjs`
  static const LucideGlyph textSearch = LucideGlyph(
    'text-search',
    <IconElement>[
      IconPathElement('M21 5H3'), // key: 1fi0y6
      IconPathElement('M10 12H3'), // key: 1ulcyk
      IconPathElement('M10 19H3'), // key: 108z41
      IconCircleElement(17, 15, 3), // key: 1upz2a
      IconPathElement('m21 19-1.9-1.9'), // key: dwi7p8
    ],
  );

  /// `text-wrap.mjs`
  static const LucideGlyph textWrap = LucideGlyph('text-wrap', <IconElement>[
    IconPathElement('m16 16-3 3 3 3'), // key: 117b85
    IconPathElement('M3 12h14.5a1 1 0 0 1 0 7H13'), // key: 18xa6z
    IconPathElement('M3 19h6'), // key: 1ygdsz
    IconPathElement('M3 5h18'), // key: 1u36vt
  ]);

  /// `theater.mjs`
  static const LucideGlyph theater = LucideGlyph('theater', <IconElement>[
    IconPathElement('M2 10s3-3 3-8'), // key: 3xiif0
    IconPathElement('M22 10s-3-3-3-8'), // key: ioaa5q
    IconPathElement('M10 2c0 4.4-3.6 8-8 8'), // key: 16fkpi
    IconPathElement('M14 2c0 4.4 3.6 8 8 8'), // key: b9eulq
    IconPathElement('M2 10s2 2 2 5'), // key: 1au1lb
    IconPathElement('M22 10s-2 2-2 5'), // key: qi2y5e
    IconPathElement('M8 15h8'), // key: 45n4r
    IconPathElement('M2 22v-1a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v1'), // key: 1vsc2m
    IconPathElement('M14 22v-1a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v1'), // key: hrha4u
  ]);

  /// `thermometer-snowflake.mjs`
  static const LucideGlyph
  thermometerSnowflake = LucideGlyph('thermometer-snowflake', <IconElement>[
    IconPathElement('m10 20-1.25-2.5L6 18'), // key: 18frcb
    IconPathElement('M10 4 8.75 6.5 6 6'), // key: 7mghy3
    IconPathElement('M10.585 15H10'), // key: 4nqulp
    IconPathElement('M2 12h6.5L10 9'), // key: kv9z4n
    IconPathElement('M20 14.54a4 4 0 1 1-4 0V4a2 2 0 0 1 4 0z'), // key: yu0u2z
    IconPathElement('m4 10 1.5 2L4 14'), // key: k9enpj
    IconPathElement('m7 21 3-6-1.5-3'), // key: j8hb9u
    IconPathElement('m7 3 3 6h2'), // key: 1bbqgq
  ]);

  /// `thermometer-sun.mjs`
  static const LucideGlyph
  thermometerSun = LucideGlyph('thermometer-sun', <IconElement>[
    IconPathElement('M12 2v2'), // key: tus03m
    IconPathElement('M12 8a4 4 0 0 0-1.645 7.647'), // key: wz5p04
    IconPathElement('M2 12h2'), // key: 1t8f8n
    IconPathElement('M20 14.54a4 4 0 1 1-4 0V4a2 2 0 0 1 4 0z'), // key: yu0u2z
    IconPathElement('m4.93 4.93 1.41 1.41'), // key: 149t6j
    IconPathElement('m6.34 17.66-1.41 1.41'), // key: 1m8zz5
  ]);

  /// `thermometer.mjs`
  static const LucideGlyph thermometer = LucideGlyph(
    'thermometer',
    <IconElement>[
      IconPathElement(
        'M14 4v10.54a4 4 0 1 1-4 0V4a2 2 0 0 1 4 0Z',
      ), // key: 17jzev
    ],
  );

  /// `thumbs-down.mjs`
  static const LucideGlyph
  thumbsDown = LucideGlyph('thumbs-down', <IconElement>[
    IconPathElement(
      'M9 18.12 10 14H4.17a2 2 0 0 1-1.92-2.56l2.33-8A2 2 0 0 1 6.5 2H20a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-2.76a2 2 0 0 0-1.79 1.11L12 22a3.13 3.13 0 0 1-3-3.88Z',
    ), // key: m61m77
    IconPathElement('M17 14V2'), // key: 8ymqnk
  ]);

  /// `thumbs-up.mjs`
  static const LucideGlyph thumbsUp = LucideGlyph('thumbs-up', <IconElement>[
    IconPathElement(
      'M15 5.88 14 10h5.83a2 2 0 0 1 1.92 2.56l-2.33 8A2 2 0 0 1 17.5 22H4a2 2 0 0 1-2-2v-8a2 2 0 0 1 2-2h2.76a2 2 0 0 0 1.79-1.11L12 2a3.13 3.13 0 0 1 3 3.88Z',
    ), // key: emmmcr
    IconPathElement('M7 10v12'), // key: 1qc93n
  ]);

  /// `ticket-check.mjs`
  static const LucideGlyph
  ticketCheck = LucideGlyph('ticket-check', <IconElement>[
    IconPathElement(
      'M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z',
    ), // key: qn84l0
    IconPathElement('m9 12 2 2 4-4'), // key: dzmm74
  ]);

  /// `ticket-minus.mjs`
  static const LucideGlyph
  ticketMinus = LucideGlyph('ticket-minus', <IconElement>[
    IconPathElement(
      'M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z',
    ), // key: qn84l0
    IconPathElement('M9 12h6'), // key: 1c52cq
  ]);

  /// `ticket-percent.mjs`
  static const LucideGlyph
  ticketPercent = LucideGlyph('ticket-percent', <IconElement>[
    IconPathElement(
      'M2 9a3 3 0 1 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 1 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z',
    ), // key: 1l48ns
    IconPathElement('M9 9h.01'), // key: 1q5me6
    IconPathElement('m15 9-6 6'), // key: 1uzhvr
    IconPathElement('M15 15h.01'), // key: lqbp3k
  ]);

  /// `ticket-plus.mjs`
  static const LucideGlyph
  ticketPlus = LucideGlyph('ticket-plus', <IconElement>[
    IconPathElement(
      'M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z',
    ), // key: qn84l0
    IconPathElement('M9 12h6'), // key: 1c52cq
    IconPathElement('M12 9v6'), // key: 199k2o
  ]);

  /// `ticket-slash.mjs`
  static const LucideGlyph
  ticketSlash = LucideGlyph('ticket-slash', <IconElement>[
    IconPathElement(
      'M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z',
    ), // key: qn84l0
    IconPathElement('m9.5 14.5 5-5'), // key: qviqfa
  ]);

  /// `ticket-x.mjs`
  static const LucideGlyph ticketX = LucideGlyph('ticket-x', <IconElement>[
    IconPathElement(
      'M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z',
    ), // key: qn84l0
    IconPathElement('m9.5 14.5 5-5'), // key: qviqfa
    IconPathElement('m9.5 9.5 5 5'), // key: 18nt4w
  ]);

  /// `ticket.mjs`
  static const LucideGlyph ticket = LucideGlyph('ticket', <IconElement>[
    IconPathElement(
      'M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z',
    ), // key: qn84l0
    IconPathElement('M13 5v2'), // key: dyzc3o
    IconPathElement('M13 17v2'), // key: 1ont0d
    IconPathElement('M13 11v2'), // key: 1wjjxi
  ]);

  /// `tickets-plane.mjs`
  static const LucideGlyph
  ticketsPlane = LucideGlyph('tickets-plane', <IconElement>[
    IconPathElement('M10.5 17h1.227a2 2 0 0 0 1.345-.52L18 12'), // key: 16muxl
    IconPathElement('m12 13.5 3.794.506'), // key: 6v5z87
    IconPathElement(
      'm3.173 8.18 11-5a2 2 0 0 1 2.647.993L18.56 8',
    ), // key: 15hfpj
    IconPathElement('M6 10V8'), // key: 1y41hn
    IconPathElement('M6 14v1'), // key: cao2tf
    IconPathElement('M6 19v2'), // key: 1loha6
    IconRectElement(2, 8, 20, 13, 2), // key: p3bz5l
  ]);

  /// `tickets.mjs`
  static const LucideGlyph tickets = LucideGlyph('tickets', <IconElement>[
    IconPathElement(
      'm3.173 8.18 11-5a2 2 0 0 1 2.647.993L18.56 8',
    ), // key: 15hfpj
    IconPathElement('M6 10V8'), // key: 1y41hn
    IconPathElement('M6 14v1'), // key: cao2tf
    IconPathElement('M6 19v2'), // key: 1loha6
    IconRectElement(2, 8, 20, 13, 2), // key: p3bz5l
  ]);

  /// `timeline.mjs`
  static const LucideGlyph timeline = LucideGlyph('timeline', <IconElement>[
    IconPathElement('M4 12h.01'), // key: 158zrr
    IconPathElement('M4 16h.01'), // key: jrnfb7
    IconPathElement('M4 20h.01'), // key: orx0iu
    IconPathElement('M4 4h.01'), // key: cieki8
    IconPathElement('M4 8h.01'), // key: 43g258
    IconPathElement(
      'M9.414 13.414a2 2 0 0 0 1.414.586H19a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1h-8.172a2 2 0 0 0-1.414.586L8 12z',
    ), // key: 1pvxkf
    IconPathElement(
      'M9.414 21.414a2 2 0 0 0 1.414.586H19a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1h-8.172a2 2 0 0 0-1.414.586L8 20z',
    ), // key: 1k13gh
    IconPathElement(
      'M9.414 5.414A2 2 0 0 0 10.828 6H19a1 1 0 0 0 1-1V3a1 1 0 0 0-1-1h-8.172a2 2 0 0 0-1.414.586L8 4z',
    ), // key: 12x0hd
  ]);

  /// `timer-off.mjs`
  static const LucideGlyph timerOff = LucideGlyph('timer-off', <IconElement>[
    IconPathElement('M10 2h4'), // key: n1abiw
    IconPathElement(
      'M4.6 11a8 8 0 0 0 1.7 8.7 8 8 0 0 0 8.7 1.7',
    ), // key: 10he05
    IconPathElement(
      'M7.4 7.4a8 8 0 0 1 10.3 1 8 8 0 0 1 .9 10.2',
    ), // key: 15f7sh
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement('M12 12v-2'), // key: fwoke6
  ]);

  /// `timer-reset.mjs`
  static const LucideGlyph timerReset = LucideGlyph(
    'timer-reset',
    <IconElement>[
      IconPathElement('M10 2h4'), // key: n1abiw
      IconPathElement('M12 14v-4'), // key: 1evpnu
      IconPathElement(
        'M4 13a8 8 0 0 1 8-7 8 8 0 1 1-5.3 14L4 17.6',
      ), // key: 1ts96g
      IconPathElement('M9 17H4v5'), // key: 8t5av
    ],
  );

  /// `timer.mjs`
  static const LucideGlyph timer = LucideGlyph('timer', <IconElement>[
    IconLineElement(10, 2, 14, 2), // key: 14vaq8
    IconLineElement(12, 14, 15, 11), // key: 17fdiu
    IconCircleElement(12, 14, 8), // key: 1e1u0o
  ]);

  /// `toggle-left.mjs`
  static const LucideGlyph toggleLeft = LucideGlyph(
    'toggle-left',
    <IconElement>[
      IconCircleElement(9, 12, 3), // key: u3jwor
      IconRectElement(2, 5, 20, 14, 7), // key: g7kal2
    ],
  );

  /// `toggle-right.mjs`
  static const LucideGlyph toggleRight = LucideGlyph(
    'toggle-right',
    <IconElement>[
      IconCircleElement(15, 12, 3), // key: 1afu0r
      IconRectElement(2, 5, 20, 14, 7), // key: g7kal2
    ],
  );

  /// `toilet.mjs`
  static const LucideGlyph toilet = LucideGlyph('toilet', <IconElement>[
    IconPathElement(
      'M7 12h13a1 1 0 0 1 1 1 5 5 0 0 1-5 5h-.598a.5.5 0 0 0-.424.765l1.544 2.47a.5.5 0 0 1-.424.765H5.402a.5.5 0 0 1-.424-.765L7 18',
    ), // key: kc4kqr
    IconPathElement(
      'M8 18a5 5 0 0 1-5-5V4a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v8',
    ), // key: 1tqs57
  ]);

  /// `tool-case.mjs`
  static const LucideGlyph toolCase = LucideGlyph('tool-case', <IconElement>[
    IconPathElement('M10 15h4'), // key: 192ueg
    IconPathElement(
      'm14.817 10.995-.971-1.45 1.034-1.232a2 2 0 0 0-2.025-3.238l-1.82.364L9.91 3.885a2 2 0 0 0-3.625.748L6.141 6.55l-1.725.426a2 2 0 0 0-.19 3.756l.657.27',
    ), // key: xbnumr
    IconPathElement(
      'm18.822 10.995 2.26-5.38a1 1 0 0 0-.557-1.318L16.954 2.9a1 1 0 0 0-1.281.533l-.924 2.122',
    ), // key: eaw7gc
    IconPathElement(
      'M4 12.006A1 1 0 0 1 4.994 11H19a1 1 0 0 1 1 1v7a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2z',
    ), // key: 1vaooh
  ]);

  /// `toolbox.mjs`
  static const LucideGlyph toolbox = LucideGlyph('toolbox', <IconElement>[
    IconPathElement('M16 12v4'), // key: vf1vip
    IconPathElement('M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2'), // key: llnzfg
    IconPathElement(
      'M17 6a2 2 0 011.414.586l3 3A2 2 0 0122 11v8a2 2 0 01-2 2H4a2 2 0 01-2-2v-8a2 2 0 01.586-1.414l3-3A2 2 0 017 6z',
    ), // key: 1hprxj
    IconPathElement('M2 14h20'), // key: myj16y
    IconPathElement('M8 12v4'), // key: 1w4uao
  ]);

  /// `tornado.mjs`
  static const LucideGlyph tornado = LucideGlyph('tornado', <IconElement>[
    IconPathElement('M21 4H3'), // key: 1hwok0
    IconPathElement('M18 8H6'), // key: 41n648
    IconPathElement('M19 12H9'), // key: 1g4lpz
    IconPathElement('M16 16h-6'), // key: 1j5d54
    IconPathElement('M11 20H9'), // key: 39obr8
  ]);

  /// `torus.mjs`
  static const LucideGlyph torus = LucideGlyph('torus', <IconElement>[
    IconEllipseElement(12, 11, 3, 2), // key: 1b2qxu
    IconEllipseElement(12, 12.5, 10, 8.5), // key: h8emeu
  ]);

  /// `touchpad-off.mjs`
  static const LucideGlyph touchpadOff = LucideGlyph(
    'touchpad-off',
    <IconElement>[
      IconPathElement('M12 20v-6'), // key: 1rm09r
      IconPathElement('M19.656 14H22'), // key: 170xzr
      IconPathElement('M2 14h12'), // key: d8icqz
      IconPathElement('m2 2 20 20'), // key: 1ooewy
      IconPathElement('M20 20H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2'), // key: s23sx2
      IconPathElement('M9.656 4H20a2 2 0 0 1 2 2v10.344'), // key: ovjcvl
    ],
  );

  /// `touchpad.mjs`
  static const LucideGlyph touchpad = LucideGlyph('touchpad', <IconElement>[
    IconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
    IconPathElement('M2 14h20'), // key: myj16y
    IconPathElement('M12 20v-6'), // key: 1rm09r
  ]);

  /// `towel-rack.mjs`
  static const LucideGlyph towelRack = LucideGlyph('towel-rack', <IconElement>[
    IconPathElement('M22 7h-2'), // key: 1okbx2
    IconPathElement(
      'M6.5 3h11A2.5 2.5 0 0 1 20 5.5V20a1 1 0 0 1-1 1h-9a1 1 0 0 1-1-1V5.5a1 1 0 0 0-5 0V17a1 1 0 0 0 1 1h4',
    ), // key: kc32tg
    IconPathElement('M9 7H2'), // key: ahf7b7
  ]);

  /// `tower-control.mjs`
  static const LucideGlyph towerControl = LucideGlyph(
    'tower-control',
    <IconElement>[
      IconPathElement(
        'M18.2 12.27 20 6H4l1.8 6.27a1 1 0 0 0 .95.73h10.5a1 1 0 0 0 .96-.73Z',
      ), // key: 1pledb
      IconPathElement('M8 13v9'), // key: hmv0ci
      IconPathElement('M16 22v-9'), // key: ylnf1u
      IconPathElement('m9 6 1 7'), // key: dpdgam
      IconPathElement('m15 6-1 7'), // key: ls7zgu
      IconPathElement('M12 6V2'), // key: 1pj48d
      IconPathElement('M13 2h-2'), // key: mj6ths
    ],
  );

  /// `toy-brick.mjs`
  static const LucideGlyph toyBrick = LucideGlyph('toy-brick', <IconElement>[
    IconRectElement(3, 8, 18, 12, 1), // key: 158fvp
    IconPathElement('M10 8V5c0-.6-.4-1-1-1H6a1 1 0 0 0-1 1v3'), // key: s0042v
    IconPathElement('M19 8V5c0-.6-.4-1-1-1h-3a1 1 0 0 0-1 1v3'), // key: 9wmeh2
  ]);

  /// `tractor.mjs`
  static const LucideGlyph tractor = LucideGlyph('tractor', <IconElement>[
    IconPathElement(
      'm10 11 11 .9a1 1 0 0 1 .8 1.1l-.665 4.158a1 1 0 0 1-.988.842H20',
    ), // key: she1j9
    IconPathElement('M16 18h-5'), // key: bq60fd
    IconPathElement('M18 5a1 1 0 0 0-1 1v5.573'), // key: 1kv8ia
    IconPathElement('M3 4h8.129a1 1 0 0 1 .99.863L13 11.246'), // key: 1q1ert
    IconPathElement('M4 11V4'), // key: 9ft8pt
    IconPathElement('M7 15h.01'), // key: k5ht0j
    IconPathElement('M8 10.1V4'), // key: 1jgyzo
    IconCircleElement(18, 18, 2), // key: 1emm8v
    IconCircleElement(7, 15, 5), // key: ddtuc
  ]);

  /// `traffic-cone.mjs`
  static const LucideGlyph
  trafficCone = LucideGlyph('traffic-cone', <IconElement>[
    IconPathElement('M16.05 10.966a5 2.5 0 0 1-8.1 0'), // key: m5jpwb
    IconPathElement(
      'm16.923 14.049 4.48 2.04a1 1 0 0 1 .001 1.831l-8.574 3.9a2 2 0 0 1-1.66 0l-8.574-3.91a1 1 0 0 1 0-1.83l4.484-2.04',
    ), // key: rbg3g8
    IconPathElement(
      'M16.949 14.14a5 2.5 0 1 1-9.9 0L10.063 3.5a2 2 0 0 1 3.874 0z',
    ), // key: vap8c8
    IconPathElement('M9.194 6.57a5 2.5 0 0 0 5.61 0'), // key: 15hn5c
  ]);

  /// `train-front-tunnel.mjs`
  static const LucideGlyph trainFrontTunnel = LucideGlyph(
    'train-front-tunnel',
    <IconElement>[
      IconPathElement('M2 22V12a10 10 0 1 1 20 0v10'), // key: o0fyp0
      IconPathElement('M15 6.8v1.4a3 2.8 0 1 1-6 0V6.8'), // key: m8q3n9
      IconPathElement('M10 15h.01'), // key: 44in9x
      IconPathElement('M14 15h.01'), // key: 5mohn5
      IconPathElement(
        'M10 19a4 4 0 0 1-4-4v-3a6 6 0 1 1 12 0v3a4 4 0 0 1-4 4Z',
      ), // key: hckbmu
      IconPathElement('m9 19-2 3'), // key: iij7hm
      IconPathElement('m15 19 2 3'), // key: npx8sa
    ],
  );

  /// `train-front.mjs`
  static const LucideGlyph trainFront = LucideGlyph(
    'train-front',
    <IconElement>[
      IconPathElement('M8 3.1V7a4 4 0 0 0 8 0V3.1'), // key: 1v71zp
      IconPathElement('m9 15-1-1'), // key: 1yrq24
      IconPathElement('m15 15 1-1'), // key: 1t0d6s
      IconPathElement(
        'M9 19c-2.8 0-5-2.2-5-5v-4a8 8 0 0 1 16 0v4c0 2.8-2.2 5-5 5Z',
      ), // key: 1p0hjs
      IconPathElement('m8 19-2 3'), // key: 13i0xs
      IconPathElement('m16 19 2 3'), // key: xo31yx
    ],
  );

  /// `train-track.mjs`
  static const LucideGlyph trainTrack = LucideGlyph(
    'train-track',
    <IconElement>[
      IconPathElement('M2 17 17 2'), // key: 18b09t
      IconPathElement('m2 14 8 8'), // key: 1gv9hu
      IconPathElement('m5 11 8 8'), // key: 189pqp
      IconPathElement('m8 8 8 8'), // key: 1imecy
      IconPathElement('m11 5 8 8'), // key: ummqn6
      IconPathElement('m14 2 8 8'), // key: 1vk7dn
      IconPathElement('M7 22 22 7'), // key: 15mb1i
    ],
  );

  /// `tram-front.mjs`
  static const LucideGlyph tramFront = LucideGlyph('tram-front', <IconElement>[
    IconRectElement(4, 3, 16, 16, 2), // key: 1wxw4b
    IconPathElement('M4 11h16'), // key: mpoxn0
    IconPathElement('M12 3v8'), // key: 1h2ygw
    IconPathElement('m8 19-2 3'), // key: 13i0xs
    IconPathElement('m18 22-2-3'), // key: 1p0ohu
    IconPathElement('M8 15h.01'), // key: a7atzg
    IconPathElement('M16 15h.01'), // key: rnfrdf
  ]);

  /// `transgender.mjs`
  static const LucideGlyph transgender = LucideGlyph(
    'transgender',
    <IconElement>[
      IconPathElement('M12 16v6'), // key: c8a4gj
      IconPathElement('M14 20h-4'), // key: m8m19d
      IconPathElement('M18 2h4v4'), // key: 1341mj
      IconPathElement('m2 2 7.17 7.17'), // key: 13q8l2
      IconPathElement('M2 5.355V2h3.357'), // key: 18136r
      IconPathElement('m22 2-7.17 7.17'), // key: 1epvy4
      IconPathElement('M8 5 5 8'), // key: mgbjhz
      IconCircleElement(12, 12, 4), // key: 4exip2
    ],
  );

  /// `trash-2.mjs`
  static const LucideGlyph trash2 = LucideGlyph('trash-2', <IconElement>[
    IconPathElement('M10 11v6'), // key: nco0om
    IconPathElement('M14 11v6'), // key: outv1u
    IconPathElement('M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6'), // key: miytrc
    IconPathElement('M3 6h18'), // key: d0wm0j
    IconPathElement('M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2'), // key: e791ji
  ]);

  /// `trash.mjs`
  static const LucideGlyph trash = LucideGlyph('trash', <IconElement>[
    IconPathElement('M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6'), // key: miytrc
    IconPathElement('M3 6h18'), // key: d0wm0j
    IconPathElement('M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2'), // key: e791ji
  ]);

  /// `tree-deciduous.mjs`
  static const LucideGlyph
  treeDeciduous = LucideGlyph('tree-deciduous', <IconElement>[
    IconPathElement(
      'M8 19a4 4 0 0 1-2.24-7.32A3.5 3.5 0 0 1 9 6.03V6a3 3 0 1 1 6 0v.04a3.5 3.5 0 0 1 3.24 5.65A4 4 0 0 1 16 19Z',
    ), // key: oadzkq
    IconPathElement('M12 19v3'), // key: npa21l
  ]);

  /// `tree-palm.mjs`
  static const LucideGlyph treePalm = LucideGlyph('tree-palm', <IconElement>[
    IconPathElement(
      'M13 8c0-2.76-2.46-5-5.5-5S2 5.24 2 8h2l1-1 1 1h4',
    ), // key: foxbe7
    IconPathElement(
      'M13 7.14A5.82 5.82 0 0 1 16.5 6c3.04 0 5.5 2.24 5.5 5h-3l-1-1-1 1h-3',
    ), // key: 18arnh
    IconPathElement(
      'M5.89 9.71c-2.15 2.15-2.3 5.47-.35 7.43l4.24-4.25.7-.7.71-.71 2.12-2.12c-1.95-1.96-5.27-1.8-7.42.35',
    ), // key: ywahnh
    IconPathElement(
      'M11 15.5c.5 2.5-.17 4.5-1 6.5h4c2-5.5-.5-12-1-14',
    ), // key: ft0feo
  ]);

  /// `tree-pine.mjs`
  static const LucideGlyph treePine = LucideGlyph('tree-pine', <IconElement>[
    IconPathElement(
      'm17 14 3 3.3a1 1 0 0 1-.7 1.7H4.7a1 1 0 0 1-.7-1.7L7 14h-.3a1 1 0 0 1-.7-1.7L9 9h-.2A1 1 0 0 1 8 7.3L12 3l4 4.3a1 1 0 0 1-.8 1.7H15l3 3.3a1 1 0 0 1-.7 1.7H17Z',
    ), // key: cpyugq
    IconPathElement('M12 22v-3'), // key: kmzjlo
  ]);

  /// `trees.mjs`
  static const LucideGlyph trees = LucideGlyph('trees', <IconElement>[
    IconPathElement(
      'M10 10v.2A3 3 0 0 1 8.9 16H5a3 3 0 0 1-1-5.8V10a3 3 0 0 1 6 0Z',
    ), // key: 1l6gj6
    IconPathElement('M7 16v6'), // key: 1a82de
    IconPathElement('M13 19v3'), // key: 13sx9i
    IconPathElement(
      'M12 19h8.3a1 1 0 0 0 .7-1.7L18 14h.3a1 1 0 0 0 .7-1.7L16 9h.2a1 1 0 0 0 .8-1.7L13 3l-1.4 1.5',
    ), // key: 1sj9kv
  ]);

  /// `trending-down.mjs`
  static const LucideGlyph trendingDown = LucideGlyph(
    'trending-down',
    <IconElement>[
      IconPathElement('M16 17h6v-6'), // key: t6n2it
      IconPathElement('m22 17-8.5-8.5-5 5L2 7'), // key: x473p
    ],
  );

  /// `trending-up-down.mjs`
  static const LucideGlyph trendingUpDown = LucideGlyph(
    'trending-up-down',
    <IconElement>[
      IconPathElement('M14.828 14.828 21 21'), // key: ar5fw7
      IconPathElement('M21 16v5h-5'), // key: 1ck2sf
      IconPathElement('m21 3-9 9-4-4-6 6'), // key: 1h02xo
      IconPathElement('M21 8V3h-5'), // key: 1qoq8a
    ],
  );

  /// `trending-up.mjs`
  static const LucideGlyph trendingUp = LucideGlyph(
    'trending-up',
    <IconElement>[
      IconPathElement('M16 7h6v6'), // key: box55l
      IconPathElement('m22 7-8.5 8.5-5-5L2 17'), // key: 1t1m79
    ],
  );

  /// `triangle-alert.mjs`
  static const LucideGlyph
  triangleAlert = LucideGlyph('triangle-alert', <IconElement>[
    IconPathElement(
      'm21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3',
    ), // key: wmoenq
    IconPathElement('M12 9v4'), // key: juzpu7
    IconPathElement('M12 17h.01'), // key: p32p05
  ]);

  /// `triangle-dashed.mjs`
  static const LucideGlyph triangleDashed = LucideGlyph(
    'triangle-dashed',
    <IconElement>[
      IconPathElement('M10.17 4.193a2 2 0 0 1 3.666.013'), // key: pltmmw
      IconPathElement('M14 21h2'), // key: v4qezv
      IconPathElement('m15.874 7.743 1 1.732'), // key: 10m0iw
      IconPathElement('m18.849 12.952 1 1.732'), // key: zadnam
      IconPathElement('M21.824 18.18a2 2 0 0 1-1.835 2.824'), // key: fvwuk4
      IconPathElement('M4.024 21a2 2 0 0 1-1.839-2.839'), // key: 1e1kah
      IconPathElement('m5.136 12.952-1 1.732'), // key: 1u4ldi
      IconPathElement('M8 21h2'), // key: i9zjee
      IconPathElement('m8.102 7.743-1 1.732'), // key: 1zzo4u
    ],
  );

  /// `triangle-right.mjs`
  static const LucideGlyph
  triangleRight = LucideGlyph('triangle-right', <IconElement>[
    IconPathElement(
      'M22 18a2 2 0 0 1-2 2H3c-1.1 0-1.3-.6-.4-1.3L20.4 4.3c.9-.7 1.6-.4 1.6.7Z',
    ), // key: 183wce
  ]);

  /// `triangle.mjs`
  static const LucideGlyph triangle = LucideGlyph('triangle', <IconElement>[
    IconPathElement(
      'M13.73 4a2 2 0 0 0-3.46 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z',
    ), // key: 14u9p9
  ]);

  /// `trophy.mjs`
  static const LucideGlyph trophy = LucideGlyph('trophy', <IconElement>[
    IconPathElement(
      'M10 14.66V17a1 1 0 0 1-1 1 2 2 0 0 0-2 2v2',
    ), // key: pwuv1l
    IconPathElement(
      'M14 14.66V17a1 1 0 0 0 1 1 2 2 0 0 1 2 2v2',
    ), // key: 1y54w1
    IconPathElement(
      'M17.916 10H19.5A2.5 2.5 0 0 0 22 7.5V5a1 1 0 0 0-1-1h-3',
    ), // key: e30mpu
    IconPathElement('M4 22h16'), // key: 57wxv0
    IconPathElement(
      'M6 9a6 6 0 0 0 12 0V3a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1z',
    ), // key: 1mhfuq
    IconPathElement(
      'M6.084 10H4.5A2.5 2.5 0 0 1 2 7.5V5a1 1 0 0 1 1-1h3',
    ), // key: i0yafy
  ]);

  /// `truck-electric.mjs`
  static const LucideGlyph
  truckElectric = LucideGlyph('truck-electric', <IconElement>[
    IconPathElement('M14 19V7a2 2 0 0 0-2-2H9'), // key: 15peso
    IconPathElement('M15 19H9'), // key: 18q6dt
    IconPathElement(
      'M19 19h2a1 1 0 0 0 1-1v-3.65a1 1 0 0 0-.22-.62L18.3 9.38a1 1 0 0 0-.78-.38H14',
    ), // key: 1dkp3j
    IconPathElement('M2 13v5a1 1 0 0 0 1 1h2'), // key: pkmmzz
    IconPathElement(
      'M4 3 2.15 5.15a.495.495 0 0 0 .35.86h2.15a.47.47 0 0 1 .35.86L3 9.02',
    ), // key: 1n26pd
    IconCircleElement(17, 19, 2), // key: 1nxcgd
    IconCircleElement(7, 19, 2), // key: gzo7y7
  ]);

  /// `truck.mjs`
  static const LucideGlyph truck = LucideGlyph('truck', <IconElement>[
    IconPathElement(
      'M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2',
    ), // key: wrbu53
    IconPathElement('M15 18H9'), // key: 1lyqi6
    IconPathElement(
      'M19 18h2a1 1 0 0 0 1-1v-3.65a1 1 0 0 0-.22-.624l-3.48-4.35A1 1 0 0 0 17.52 8H14',
    ), // key: lysw3i
    IconCircleElement(17, 18, 2), // key: 332jqn
    IconCircleElement(7, 18, 2), // key: 19iecd
  ]);

  /// `turkish-lira.mjs`
  static const LucideGlyph turkishLira = LucideGlyph(
    'turkish-lira',
    <IconElement>[
      IconPathElement('M15 4 5 9'), // key: 14bkc9
      IconPathElement('m15 8.5-10 5'), // key: 1grtsx
      IconPathElement('M18 12a9 9 0 0 1-9 9V3'), // key: 1sst7f
    ],
  );

  /// `turntable.mjs`
  static const LucideGlyph turntable = LucideGlyph('turntable', <IconElement>[
    IconPathElement('M10 12.01h.01'), // key: 7rp0yl
    IconPathElement('M18 8v4a8 8 0 0 1-1.07 4'), // key: 1st48v
    IconCircleElement(10, 12, 4), // key: 19levz
    IconRectElement(2, 4, 20, 16, 2), // key: izxlao
  ]);

  /// `turtle.mjs`
  static const LucideGlyph turtle = LucideGlyph('turtle', <IconElement>[
    IconPathElement(
      'm12 10 2 4v3a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1v-3a8 8 0 1 0-16 0v3a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1v-3l2-4h4Z',
    ), // key: 1lbbv7
    IconPathElement('M4.82 7.9 8 10'), // key: m9wose
    IconPathElement('M15.18 7.9 12 10'), // key: p8dp2u
    IconPathElement('M16.93 10H20a2 2 0 0 1 0 4H2'), // key: 12nsm7
  ]);

  /// `tv-minimal-play.mjs`
  static const LucideGlyph
  tvMinimalPlay = LucideGlyph('tv-minimal-play', <IconElement>[
    IconPathElement(
      'M15.033 9.44a.647.647 0 0 1 0 1.12l-4.065 2.352a.645.645 0 0 1-.968-.56V7.648a.645.645 0 0 1 .967-.56z',
    ), // key: vbtd3f
    IconPathElement('M7 21h10'), // key: 1b0cd5
    IconRectElement(2, 3, 20, 14, 2), // key: 48i651
  ]);

  /// `tv-minimal.mjs`
  static const LucideGlyph tvMinimal = LucideGlyph('tv-minimal', <IconElement>[
    IconPathElement('M7 21h10'), // key: 1b0cd5
    IconRectElement(2, 3, 20, 14, 2), // key: 48i651
  ]);

  /// `tv.mjs`
  static const LucideGlyph tv = LucideGlyph('tv', <IconElement>[
    IconPathElement('m17 2-5 5-5-5'), // key: 16satq
    IconRectElement(2, 7, 20, 15, 2), // key: 1e6viu
  ]);

  /// `type-outline.mjs`
  static const LucideGlyph
  typeOutline = LucideGlyph('type-outline', <IconElement>[
    IconPathElement(
      'M14 16.5a.5.5 0 0 0 .5.5h.5a2 2 0 0 1 0 4H9a2 2 0 0 1 0-4h.5a.5.5 0 0 0 .5-.5v-9a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5V8a2 2 0 0 1-4 0V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v3a2 2 0 0 1-4 0v-.5a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5Z',
    ), // key: 1reda3
  ]);

  /// `type.mjs`
  static const LucideGlyph type = LucideGlyph('type', <IconElement>[
    IconPathElement('M12 4v16'), // key: 1654pz
    IconPathElement('M4 7V5a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v2'), // key: e0r10z
    IconPathElement('M9 20h6'), // key: s66wpe
  ]);

  /// `umbrella-off.mjs`
  static const LucideGlyph umbrellaOff = LucideGlyph(
    'umbrella-off',
    <IconElement>[
      IconPathElement('M12 13v7a2 2 0 0 0 4 0'), // key: rpgb42
      IconPathElement('M12 2v2'), // key: tus03m
      IconPathElement(
        'M18.656 13h2.336a1 1 0 0 0 .97-1.274 10.284 10.284 0 0 0-12.07-7.51',
      ), // key: yawknk
      IconPathElement('m2 2 20 20'), // key: 1ooewy
      IconPathElement(
        'M5.961 5.957a10.28 10.28 0 0 0-3.922 5.769A1 1 0 0 0 3 13h10',
      ), // key: 5sfalc
    ],
  );

  /// `umbrella.mjs`
  static const LucideGlyph umbrella = LucideGlyph('umbrella', <IconElement>[
    IconPathElement('M12 13v7a2 2 0 0 0 4 0'), // key: rpgb42
    IconPathElement('M12 2v2'), // key: tus03m
    IconPathElement(
      'M20.992 13a1 1 0 0 0 .97-1.274 10.284 10.284 0 0 0-19.923 0A1 1 0 0 0 3 13z',
    ), // key: 124nyo
  ]);

  /// `underline.mjs`
  static const LucideGlyph underline = LucideGlyph('underline', <IconElement>[
    IconPathElement('M6 4v6a6 6 0 0 0 12 0V4'), // key: 9kb039
    IconLineElement(4, 20, 20, 20), // key: nun2al
  ]);

  /// `undo-2.mjs`
  static const LucideGlyph undo2 = LucideGlyph('undo-2', <IconElement>[
    IconPathElement('M9 14 4 9l5-5'), // key: 102s5s
    IconPathElement(
      'M4 9h10.5a5.5 5.5 0 0 1 5.5 5.5a5.5 5.5 0 0 1-5.5 5.5H11',
    ), // key: f3b9sd
  ]);

  /// `undo-dot.mjs`
  static const LucideGlyph undoDot = LucideGlyph('undo-dot', <IconElement>[
    IconPathElement('M21 17a9 9 0 0 0-15-6.7L3 13'), // key: 8mp6z9
    IconPathElement('M3 7v6h6'), // key: 1v2h90
    IconCircleElement(12, 17, 1), // key: 1ixnty
  ]);

  /// `undo.mjs`
  static const LucideGlyph undo = LucideGlyph('undo', <IconElement>[
    IconPathElement('M3 7v6h6'), // key: 1v2h90
    IconPathElement('M21 17a9 9 0 0 0-9-9 9 9 0 0 0-6 2.3L3 13'), // key: 1r6uu6
  ]);

  /// `unfold-horizontal.mjs`
  static const LucideGlyph unfoldHorizontal = LucideGlyph(
    'unfold-horizontal',
    <IconElement>[
      IconPathElement('M16 12h6'), // key: 15xry1
      IconPathElement('M8 12H2'), // key: 1jqql6
      IconPathElement('M12 2v2'), // key: tus03m
      IconPathElement('M12 8v2'), // key: 1woqiv
      IconPathElement('M12 14v2'), // key: 8jcxud
      IconPathElement('M12 20v2'), // key: 1lh1kg
      IconPathElement('m19 15 3-3-3-3'), // key: wjy7rq
      IconPathElement('m5 9-3 3 3 3'), // key: j64kie
    ],
  );

  /// `unfold-vertical.mjs`
  static const LucideGlyph unfoldVertical = LucideGlyph(
    'unfold-vertical',
    <IconElement>[
      IconPathElement('M12 22v-6'), // key: 6o8u61
      IconPathElement('M12 8V2'), // key: 1wkif3
      IconPathElement('M4 12H2'), // key: rhcxmi
      IconPathElement('M10 12H8'), // key: s88cx1
      IconPathElement('M16 12h-2'), // key: 10asgb
      IconPathElement('M22 12h-2'), // key: 14jgyd
      IconPathElement('m15 19-3 3-3-3'), // key: 11eu04
      IconPathElement('m15 5-3-3-3 3'), // key: itvq4r
    ],
  );

  /// `ungroup.mjs`
  static const LucideGlyph ungroup = LucideGlyph('ungroup', <IconElement>[
    IconRectElement(11, 14, 10, 7, 2), // key: nfm8rk
    IconRectElement(3, 3, 10, 7, 2), // key: 1ljebb
  ]);

  /// `university.mjs`
  static const LucideGlyph university = LucideGlyph('university', <IconElement>[
    IconPathElement('M14 21v-3a2 2 0 0 0-4 0v3'), // key: 1rgiei
    IconPathElement('M18 12h.01'), // key: yjnet6
    IconPathElement('M18 16h.01'), // key: plv8zi
    IconPathElement(
      'M22 7a1 1 0 0 0-1-1h-2a2 2 0 0 1-1.143-.359L13.143 2.36a2 2 0 0 0-2.286-.001L6.143 5.64A2 2 0 0 1 5 6H3a1 1 0 0 0-1 1v12a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2z',
    ), // key: 1ogmi3
    IconPathElement('M6 12h.01'), // key: c2rlol
    IconPathElement('M6 16h.01'), // key: 1pmjb7
    IconCircleElement(12, 10, 2), // key: 1yojzk
  ]);

  /// `unlink-2.mjs`
  static const LucideGlyph unlink2 = LucideGlyph('unlink-2', <IconElement>[
    IconPathElement(
      'M15 7h2a5 5 0 0 1 0 10h-2m-6 0H7A5 5 0 0 1 7 7h2',
    ), // key: 1re2ne
  ]);

  /// `unlink.mjs`
  static const LucideGlyph unlink = LucideGlyph('unlink', <IconElement>[
    IconPathElement(
      'm18.84 12.25 1.72-1.71h-.02a5.004 5.004 0 0 0-.12-7.07 5.006 5.006 0 0 0-6.95 0l-1.72 1.71',
    ), // key: yqzxt4
    IconPathElement(
      'm5.17 11.75-1.71 1.71a5.004 5.004 0 0 0 .12 7.07 5.006 5.006 0 0 0 6.95 0l1.71-1.71',
    ), // key: 4qinb0
    IconLineElement(8, 2, 8, 5), // key: 1041cp
    IconLineElement(2, 8, 5, 8), // key: 14m1p5
    IconLineElement(16, 19, 16, 22), // key: rzdirn
    IconLineElement(19, 16, 22, 16), // key: ox905f
  ]);

  /// `unplug.mjs`
  static const LucideGlyph unplug = LucideGlyph('unplug', <IconElement>[
    IconPathElement('m19 5 3-3'), // key: yk6iyv
    IconPathElement('m2 22 3-3'), // key: 19mgm9
    IconPathElement(
      'M6.3 20.3a2.4 2.4 0 0 0 3.4 0L12 18l-6-6-2.3 2.3a2.4 2.4 0 0 0 0 3.4Z',
    ), // key: goz73y
    IconPathElement('M7.5 13.5 10 11'), // key: 7xgeeb
    IconPathElement('M10.5 16.5 13 14'), // key: 10btkg
    IconPathElement(
      'm12 6 6 6 2.3-2.3a2.4 2.4 0 0 0 0-3.4l-2.6-2.6a2.4 2.4 0 0 0-3.4 0Z',
    ), // key: 1snsnr
  ]);

  /// `upload.mjs`
  static const LucideGlyph upload = LucideGlyph('upload', <IconElement>[
    IconPathElement('M12 3v12'), // key: 1x0j5s
    IconPathElement('m17 8-5-5-5 5'), // key: 7q97r8
    IconPathElement('M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4'), // key: ih7n3h
  ]);

  /// `usb.mjs`
  static const LucideGlyph usb = LucideGlyph('usb', <IconElement>[
    IconCircleElement(10, 7, 1), // key: dypaad
    IconCircleElement(4, 20, 1), // key: 22iqad
    IconPathElement('M4.7 19.3 19 5'), // key: 1enqfc
    IconPathElement('m21 3-3 1 2 2Z'), // key: d3ov82
    IconPathElement('M9.26 7.68 5 12l2 5'), // key: 1esawj
    IconPathElement('m10 14 5 2 3.5-3.5'), // key: v8oal5
    IconPathElement('m18 12 1-1 1 1-1 1Z'), // key: 1bh22v
  ]);

  /// `user-check.mjs`
  static const LucideGlyph userCheck = LucideGlyph('user-check', <IconElement>[
    IconPathElement('m16 11 2 2 4-4'), // key: 9rsbq5
    IconPathElement('M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2'), // key: 1yyitq
    IconCircleElement(9, 7, 4), // key: nufk8
  ]);

  /// `user-cog.mjs`
  static const LucideGlyph userCog = LucideGlyph('user-cog', <IconElement>[
    IconPathElement('M10 15H6a4 4 0 0 0-4 4v2'), // key: 1nfge6
    IconPathElement('m14.305 16.53.923-.382'), // key: 1itpsq
    IconPathElement('m15.228 13.852-.923-.383'), // key: eplpkm
    IconPathElement('m16.852 12.228-.383-.923'), // key: 13v3q0
    IconPathElement('m16.852 17.772-.383.924'), // key: 1i8mnm
    IconPathElement('m19.148 12.228.383-.923'), // key: 1q8j1v
    IconPathElement('m19.53 18.696-.382-.924'), // key: vk1qj3
    IconPathElement('m20.772 13.852.924-.383'), // key: n880s0
    IconPathElement('m20.772 16.148.924.383'), // key: 1g6xey
    IconCircleElement(18, 15, 3), // key: gjjjvw
    IconCircleElement(9, 7, 4), // key: nufk8
  ]);

  /// `user-key.mjs`
  static const LucideGlyph userKey = LucideGlyph('user-key', <IconElement>[
    IconPathElement('M20 11v6'), // key: d77pzp
    IconPathElement('M20 13h2'), // key: 16rner
    IconPathElement(
      'M3 21v-2a4 4 0 0 1 4-4h6a4 4 0 0 1 2.072.578',
    ), // key: 1yxgtw
    IconCircleElement(10, 7, 4), // key: e45bow
    IconCircleElement(20, 19, 2), // key: 1obnsp
  ]);

  /// `user-lock.mjs`
  static const LucideGlyph userLock = LucideGlyph('user-lock', <IconElement>[
    IconPathElement('M19 16v-2a2 2 0 0 0-4 0v2'), // key: 17sujf
    IconPathElement('M9.5 15H7a4 4 0 0 0-4 4v2'), // key: 9it25y
    IconCircleElement(10, 7, 4), // key: e45bow
    IconRectElement(13, 16, 8, 5, 0.899), // key: ur80nz
  ]);

  /// `user-minus.mjs`
  static const LucideGlyph userMinus = LucideGlyph('user-minus', <IconElement>[
    IconPathElement('M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2'), // key: 1yyitq
    IconCircleElement(9, 7, 4), // key: nufk8
    IconLineElement(22, 11, 16, 11), // key: 1shjgl
  ]);

  /// `user-pen.mjs`
  static const LucideGlyph userPen = LucideGlyph('user-pen', <IconElement>[
    IconPathElement('M11.5 15H7a4 4 0 0 0-4 4v2'), // key: 15lzij
    IconPathElement(
      'M21.378 16.626a1 1 0 0 0-3.004-3.004l-4.01 4.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z',
    ), // key: 1817ys
    IconCircleElement(10, 7, 4), // key: e45bow
  ]);

  /// `user-plus.mjs`
  static const LucideGlyph userPlus = LucideGlyph('user-plus', <IconElement>[
    IconPathElement('M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2'), // key: 1yyitq
    IconCircleElement(9, 7, 4), // key: nufk8
    IconLineElement(19, 8, 19, 14), // key: 1bvyxn
    IconLineElement(22, 11, 16, 11), // key: 1shjgl
  ]);

  /// `user-round-arrow-left.mjs`
  static const LucideGlyph userRoundArrowLeft = LucideGlyph(
    'user-round-arrow-left',
    <IconElement>[
      IconPathElement('m19 16-3 3'), // key: lp3y45
      IconPathElement('M2 21a8 8 0 0 1 12.664-6.5'), // key: 1ap0vn
      IconPathElement('M22 19h-6l3 3'), // key: 13fjle
      IconCircleElement(10, 8, 5), // key: o932ke
    ],
  );

  /// `user-round-check.mjs`
  static const LucideGlyph userRoundCheck = LucideGlyph(
    'user-round-check',
    <IconElement>[
      IconPathElement('M2 21a8 8 0 0 1 13.292-6'), // key: bjp14o
      IconCircleElement(10, 8, 5), // key: o932ke
      IconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
    ],
  );

  /// `user-round-cog.mjs`
  static const LucideGlyph userRoundCog = LucideGlyph(
    'user-round-cog',
    <IconElement>[
      IconPathElement('m14.305 19.53.923-.382'), // key: 3m78fa
      IconPathElement('m15.228 16.852-.923-.383'), // key: npixar
      IconPathElement('m16.852 15.228-.383-.923'), // key: 5xggr7
      IconPathElement('m16.852 20.772-.383.924'), // key: dpfhf9
      IconPathElement('m19.148 15.228.383-.923'), // key: 1reyyz
      IconPathElement('m19.53 21.696-.382-.924'), // key: 1goivc
      IconPathElement('M2 21a8 8 0 0 1 10.434-7.62'), // key: 1yezr2
      IconPathElement('m20.772 16.852.924-.383'), // key: htqkph
      IconPathElement('m20.772 19.148.924.383'), // key: 9w9pjp
      IconCircleElement(10, 8, 5), // key: o932ke
      IconCircleElement(18, 18, 3), // key: 1xkwt0
    ],
  );

  /// `user-round-key.mjs`
  static const LucideGlyph userRoundKey = LucideGlyph(
    'user-round-key',
    <IconElement>[
      IconPathElement('M19 11v6'), // key: rcqigv
      IconPathElement('M19 13h2'), // key: 1gch44
      IconPathElement('M2 21a8 8 0 0 1 12.868-6.349'), // key: 1lryzn
      IconCircleElement(10, 8, 5), // key: o932ke
      IconCircleElement(19, 19, 2), // key: 17f5cg
    ],
  );

  /// `user-round-minus.mjs`
  static const LucideGlyph userRoundMinus = LucideGlyph(
    'user-round-minus',
    <IconElement>[
      IconPathElement('M2 21a8 8 0 0 1 13.292-6'), // key: bjp14o
      IconCircleElement(10, 8, 5), // key: o932ke
      IconPathElement('M22 19h-6'), // key: vcuq98
    ],
  );

  /// `user-round-pen.mjs`
  static const LucideGlyph
  userRoundPen = LucideGlyph('user-round-pen', <IconElement>[
    IconPathElement('M2 21a8 8 0 0 1 10.821-7.487'), // key: 1c8h7z
    IconPathElement(
      'M21.378 16.626a1 1 0 0 0-3.004-3.004l-4.01 4.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z',
    ), // key: 1817ys
    IconCircleElement(10, 8, 5), // key: o932ke
  ]);

  /// `user-round-plus.mjs`
  static const LucideGlyph userRoundPlus = LucideGlyph(
    'user-round-plus',
    <IconElement>[
      IconPathElement('M2 21a8 8 0 0 1 13.292-6'), // key: bjp14o
      IconCircleElement(10, 8, 5), // key: o932ke
      IconPathElement('M19 16v6'), // key: tddt3s
      IconPathElement('M22 19h-6'), // key: vcuq98
    ],
  );

  /// `user-round-search.mjs`
  static const LucideGlyph userRoundSearch = LucideGlyph(
    'user-round-search',
    <IconElement>[
      IconCircleElement(10, 8, 5), // key: o932ke
      IconPathElement('M2 21a8 8 0 0 1 10.434-7.62'), // key: 1yezr2
      IconCircleElement(18, 18, 3), // key: 1xkwt0
      IconPathElement('m22 22-1.9-1.9'), // key: 1e5ubv
    ],
  );

  /// `user-round-x.mjs`
  static const LucideGlyph userRoundX = LucideGlyph(
    'user-round-x',
    <IconElement>[
      IconPathElement('M2 21a8 8 0 0 1 11.873-7'), // key: 74fkxq
      IconCircleElement(10, 8, 5), // key: o932ke
      IconPathElement('m17 17 5 5'), // key: p7ous7
      IconPathElement('m22 17-5 5'), // key: gqnmv0
    ],
  );

  /// `user-round.mjs`
  static const LucideGlyph userRound = LucideGlyph('user-round', <IconElement>[
    IconCircleElement(12, 8, 5), // key: 1hypcn
    IconPathElement('M20 21a8 8 0 0 0-16 0'), // key: rfgkzh
  ]);

  /// `user-search.mjs`
  static const LucideGlyph userSearch = LucideGlyph(
    'user-search',
    <IconElement>[
      IconCircleElement(10, 7, 4), // key: e45bow
      IconPathElement('M10.3 15H7a4 4 0 0 0-4 4v2'), // key: 3bnktk
      IconCircleElement(17, 17, 3), // key: 18b49y
      IconPathElement('m21 21-1.9-1.9'), // key: 1g2n9r
    ],
  );

  /// `user-shield.mjs`
  static const LucideGlyph
  userShield = LucideGlyph('user-shield', <IconElement>[
    IconPathElement('M10 15H6a4 4 0 0 0-4 4v2'), // key: 1nfge6
    IconPathElement(
      'M22 17.5c0 2.499-1.75 3.749-3.83 4.474a.5.5 0 0 1-.335-.005c-2.085-.72-3.835-1.97-3.835-4.47V14a.5.5 0 0 1 .5-.499c1 0 2.25-.6 3.12-1.36a.6.6 0 0 1 .76-.001c.875.765 2.12 1.36 3.12 1.36a.5.5 0 0 1 .5.5z',
    ), // key: 16j3tf
    IconCircleElement(9, 7, 4), // key: nufk8
  ]);

  /// `user-star.mjs`
  static const LucideGlyph userStar = LucideGlyph('user-star', <IconElement>[
    IconPathElement(
      'M16.051 12.616a1 1 0 0 1 1.909.024l.737 1.452a1 1 0 0 0 .737.535l1.634.256a1 1 0 0 1 .588 1.806l-1.172 1.168a1 1 0 0 0-.282.866l.259 1.613a1 1 0 0 1-1.541 1.134l-1.465-.75a1 1 0 0 0-.912 0l-1.465.75a1 1 0 0 1-1.539-1.133l.258-1.613a1 1 0 0 0-.282-.866l-1.156-1.153a1 1 0 0 1 .572-1.822l1.633-.256a1 1 0 0 0 .737-.535z',
    ), // key: 1m8t9f
    IconPathElement('M8 15H7a4 4 0 0 0-4 4v2'), // key: l9tmp8
    IconCircleElement(10, 7, 4), // key: e45bow
  ]);

  /// `user-x.mjs`
  static const LucideGlyph userX = LucideGlyph('user-x', <IconElement>[
    IconPathElement('M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2'), // key: 1yyitq
    IconCircleElement(9, 7, 4), // key: nufk8
    IconLineElement(17, 8, 22, 13), // key: 3nzzx3
    IconLineElement(22, 8, 17, 13), // key: 1swrse
  ]);

  /// `user.mjs`
  static const LucideGlyph user = LucideGlyph('user', <IconElement>[
    IconPathElement('M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2'), // key: 975kel
    IconCircleElement(12, 7, 4), // key: 17ys0d
  ]);

  /// `users-round.mjs`
  static const LucideGlyph
  usersRound = LucideGlyph('users-round', <IconElement>[
    IconPathElement('M18 21a8 8 0 0 0-16 0'), // key: 3ypg7q
    IconCircleElement(10, 8, 5), // key: o932ke
    IconPathElement('M22 20c0-3.37-2-6.5-4-8a5 5 0 0 0-.45-8.3'), // key: 10s06x
  ]);

  /// `users.mjs`
  static const LucideGlyph users = LucideGlyph('users', <IconElement>[
    IconPathElement('M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2'), // key: 1yyitq
    IconPathElement('M16 3.128a4 4 0 0 1 0 7.744'), // key: 16gr8j
    IconPathElement('M22 21v-2a4 4 0 0 0-3-3.87'), // key: kshegd
    IconCircleElement(9, 7, 4), // key: nufk8
  ]);

  /// `utensils-crossed.mjs`
  static const LucideGlyph
  utensilsCrossed = LucideGlyph('utensils-crossed', <IconElement>[
    IconPathElement(
      'm16 2-2.3 2.3a3 3 0 0 0 0 4.2l1.8 1.8a3 3 0 0 0 4.2 0L22 8',
    ), // key: n7qcjb
    IconPathElement(
      'M15 15 3.3 3.3a4.2 4.2 0 0 0 0 6l7.3 7.3c.7.7 2 .7 2.8 0L15 15Zm0 0 7 7',
    ), // key: d0u48b
    IconPathElement('m2.1 21.8 6.4-6.3'), // key: yn04lh
    IconPathElement('m19 5-7 7'), // key: 194lzd
  ]);

  /// `utensils.mjs`
  static const LucideGlyph utensils = LucideGlyph('utensils', <IconElement>[
    IconPathElement('M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2'), // key: cjf0a3
    IconPathElement('M7 2v20'), // key: 1473qp
    IconPathElement(
      'M21 15V2a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3Zm0 0v7',
    ), // key: j28e5
  ]);

  /// `utility-pole.mjs`
  static const LucideGlyph utilityPole = LucideGlyph(
    'utility-pole',
    <IconElement>[
      IconPathElement('M12 2v20'), // key: t6zp3m
      IconPathElement('M2 5h20'), // key: 1fs1ex
      IconPathElement('M3 3v2'), // key: 9imdir
      IconPathElement('M7 3v2'), // key: n0os7
      IconPathElement('M17 3v2'), // key: 1l2re6
      IconPathElement('M21 3v2'), // key: 1duuac
      IconPathElement('m19 5-7 7-7-7'), // key: 133zxf
    ],
  );

  /// `van.mjs`
  static const LucideGlyph van = LucideGlyph('van', <IconElement>[
    IconPathElement(
      'M13 6v5a1 1 0 0 0 1 1h6.102a1 1 0 0 1 .712.298l.898.91a1 1 0 0 1 .288.702V17a1 1 0 0 1-1 1h-3',
    ), // key: k3s650
    IconPathElement(
      'M5 18H3a1 1 0 0 1-1-1V8a2 2 0 0 1 2-2h12c1.1 0 2.1.8 2.4 1.8l1.176 4.2',
    ), // key: fnd93u
    IconPathElement('M9 18h5'), // key: lrx6i
    IconCircleElement(16, 18, 2), // key: 1v4tcr
    IconCircleElement(7, 18, 2), // key: 19iecd
  ]);

  /// `variable.mjs`
  static const LucideGlyph variable = LucideGlyph('variable', <IconElement>[
    IconPathElement('M8 21s-4-3-4-9 4-9 4-9'), // key: uto9ud
    IconPathElement('M16 3s4 3 4 9-4 9-4 9'), // key: 4w2vsq
    IconLineElement(15, 9, 9, 15), // key: f7djnv
    IconLineElement(9, 9, 15, 15), // key: 1shsy8
  ]);

  /// `vault.mjs`
  static const LucideGlyph vault = LucideGlyph('vault', <IconElement>[
    IconRectElement(3, 3, 18, 18, 2), // key: afitv7
    IconCircleElement(7.5, 7.5, 0.5, filled: true), // key: kqv944
    IconPathElement('m7.9 7.9 2.7 2.7'), // key: hpeyl3
    IconCircleElement(16.5, 7.5, 0.5, filled: true), // key: w0ekpg
    IconPathElement('m13.4 10.6 2.7-2.7'), // key: 264c1n
    IconCircleElement(7.5, 16.5, 0.5, filled: true), // key: nkw3mc
    IconPathElement('m7.9 16.1 2.7-2.7'), // key: p81g5e
    IconCircleElement(16.5, 16.5, 0.5, filled: true), // key: fubopw
    IconPathElement('m13.4 13.4 2.7 2.7'), // key: abhel3
    IconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `vector-square.mjs`
  static const LucideGlyph vectorSquare = LucideGlyph(
    'vector-square',
    <IconElement>[
      IconPathElement('M19.5 7a24 24 0 0 1 0 10'), // key: 8n60xe
      IconPathElement('M4.5 7a24 24 0 0 0 0 10'), // key: 2lmadr
      IconPathElement('M7 19.5a24 24 0 0 0 10 0'), // key: 1q94o2
      IconPathElement('M7 4.5a24 24 0 0 1 10 0'), // key: 2z8ypa
      IconRectElement(17, 17, 5, 5, 1), // key: 1ac74s
      IconRectElement(17, 2, 5, 5, 1), // key: 1e7h5j
      IconRectElement(2, 17, 5, 5, 1), // key: 1t4eah
      IconRectElement(2, 2, 5, 5, 1), // key: 940dhs
    ],
  );

  /// `vegan.mjs`
  static const LucideGlyph vegan = LucideGlyph('vegan', <IconElement>[
    IconPathElement('M16 8q6 0 6-6-6 0-6 6'), // key: qsyyc4
    IconPathElement('M17.41 3.59a10 10 0 1 0 3 3'), // key: 41m9h7
    IconPathElement(
      'M2 2a26.6 26.6 0 0 1 10 20c.9-6.82 1.5-9.5 4-14',
    ), // key: qiv7li
  ]);

  /// `venetian-mask.mjs`
  static const LucideGlyph
  venetianMask = LucideGlyph('venetian-mask', <IconElement>[
    IconPathElement('M18 11c-1.5 0-2.5.5-3 2'), // key: 1fod00
    IconPathElement(
      'M4 6a2 2 0 0 0-2 2v4a5 5 0 0 0 5 5 8 8 0 0 1 5 2 8 8 0 0 1 5-2 5 5 0 0 0 5-5V8a2 2 0 0 0-2-2h-3a8 8 0 0 0-5 2 8 8 0 0 0-5-2z',
    ), // key: d70hit
    IconPathElement('M6 11c1.5 0 2.5.5 3 2'), // key: 136fht
  ]);

  /// `venus-and-mars.mjs`
  static const LucideGlyph venusAndMars = LucideGlyph(
    'venus-and-mars',
    <IconElement>[
      IconPathElement('M10 20h4'), // key: ni2waw
      IconPathElement('M12 16v6'), // key: c8a4gj
      IconPathElement('M17 2h4v4'), // key: vhe59
      IconPathElement('m21 2-5.46 5.46'), // key: 19kypf
      IconCircleElement(12, 11, 5), // key: 16gxyc
    ],
  );

  /// `venus.mjs`
  static const LucideGlyph venus = LucideGlyph('venus', <IconElement>[
    IconPathElement('M12 15v7'), // key: t2xh3l
    IconPathElement('M9 19h6'), // key: 456am0
    IconCircleElement(12, 9, 6), // key: 1nw4tq
  ]);

  /// `vibrate-off.mjs`
  static const LucideGlyph vibrateOff = LucideGlyph(
    'vibrate-off',
    <IconElement>[
      IconPathElement('m2 8 2 2-2 2 2 2-2 2'), // key: sv1b1
      IconPathElement('m22 8-2 2 2 2-2 2 2 2'), // key: 101i4y
      IconPathElement(
        'M8 8v10c0 .55.45 1 1 1h6c.55 0 1-.45 1-1v-2',
      ), // key: 1hbad5
      IconPathElement('M16 10.34V6c0-.55-.45-1-1-1h-4.34'), // key: 1x5tf0
      IconLineElement(2, 2, 22, 22), // key: a6p6uj
    ],
  );

  /// `vibrate.mjs`
  static const LucideGlyph vibrate = LucideGlyph('vibrate', <IconElement>[
    IconPathElement('m2 8 2 2-2 2 2 2-2 2'), // key: sv1b1
    IconPathElement('m22 8-2 2 2 2-2 2 2 2'), // key: 101i4y
    IconRectElement(8, 5, 8, 14, 1), // key: 1oyrl4
  ]);

  /// `video-off.mjs`
  static const LucideGlyph videoOff = LucideGlyph('video-off', <IconElement>[
    IconPathElement(
      'M10.66 6H14a2 2 0 0 1 2 2v2.5l5.248-3.062A.5.5 0 0 1 22 7.87v8.196',
    ), // key: w8jjjt
    IconPathElement(
      'M16 16a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h2',
    ), // key: 1xawa7
    IconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `video.mjs`
  static const LucideGlyph video = LucideGlyph('video', <IconElement>[
    IconPathElement(
      'm16 13 5.223 3.482a.5.5 0 0 0 .777-.416V7.87a.5.5 0 0 0-.752-.432L16 10.5',
    ), // key: ftymec
    IconRectElement(2, 6, 14, 12, 2), // key: 158x01
  ]);

  /// `videotape.mjs`
  static const LucideGlyph videotape = LucideGlyph('videotape', <IconElement>[
    IconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
    IconPathElement('M2 8h20'), // key: d11cs7
    IconCircleElement(8, 14, 2), // key: 1k2qr5
    IconPathElement('M8 12h8'), // key: 1wcyev
    IconCircleElement(16, 14, 2), // key: 14k7lr
  ]);

  /// `view.mjs`
  static const LucideGlyph view = LucideGlyph('view', <IconElement>[
    IconPathElement('M21 17v2a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-2'), // key: mrq65r
    IconPathElement('M21 7V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v2'), // key: be3xqs
    IconCircleElement(12, 12, 1), // key: 41hilf
    IconPathElement(
      'M18.944 12.33a1 1 0 0 0 0-.66 7.5 7.5 0 0 0-13.888 0 1 1 0 0 0 0 .66 7.5 7.5 0 0 0 13.888 0',
    ), // key: 11ak4c
  ]);

  /// `voicemail.mjs`
  static const LucideGlyph voicemail = LucideGlyph('voicemail', <IconElement>[
    IconCircleElement(6, 12, 4), // key: 1ehtga
    IconCircleElement(18, 12, 4), // key: 4vafl8
    IconLineElement(6, 16, 18, 16), // key: pmt8us
  ]);

  /// `volleyball.mjs`
  static const LucideGlyph volleyball = LucideGlyph('volleyball', <IconElement>[
    IconPathElement('M11 7a16 16 20 0 1 10.98 4.362'), // key: 1mmfx7
    IconPathElement('M12 12a13 13 0 0 1-8.66 5'), // key: 14sm5y
    IconPathElement('M16.83 13.634a16 16 0 0 1-9.267 7.328'), // key: j0eyj5
    IconPathElement(
      'M20.66 17A13 13 0 0 0 12 12a13 13 0 0 1 0-10',
    ), // key: qaetsw
    IconPathElement('M8.17 15.366a16 16 0 0 1-1.713-11.69'), // key: 17ewdd
    IconCircleElement(12, 12, 10), // key: 1mglay
  ]);

  /// `volume-1.mjs`
  static const LucideGlyph volume1 = LucideGlyph('volume-1', <IconElement>[
    IconPathElement(
      'M11 4.702a.705.705 0 0 0-1.203-.498L6.413 7.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298z',
    ), // key: uqj9uw
    IconPathElement('M16 9a5 5 0 0 1 0 6'), // key: 1q6k2b
  ]);

  /// `volume-2.mjs`
  static const LucideGlyph volume2 = LucideGlyph('volume-2', <IconElement>[
    IconPathElement(
      'M11 4.702a.705.705 0 0 0-1.203-.498L6.413 7.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298z',
    ), // key: uqj9uw
    IconPathElement('M16 9a5 5 0 0 1 0 6'), // key: 1q6k2b
    IconPathElement('M19.364 18.364a9 9 0 0 0 0-12.728'), // key: ijwkga
  ]);

  /// `volume-off.mjs`
  static const LucideGlyph volumeOff = LucideGlyph('volume-off', <IconElement>[
    IconPathElement('M16 9a5 5 0 0 1 .95 2.293'), // key: 1fgyg8
    IconPathElement('M19.364 5.636a9 9 0 0 1 1.889 9.96'), // key: l3zxae
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement(
      'm7 7-.587.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298V11',
    ), // key: 1gbwow
    IconPathElement('M9.828 4.172A.686.686 0 0 1 11 4.657v.686'), // key: s2je0y
  ]);

  /// `volume-x.mjs`
  static const LucideGlyph volumeX = LucideGlyph('volume-x', <IconElement>[
    IconPathElement(
      'M11 4.702a.705.705 0 0 0-1.203-.498L6.413 7.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298z',
    ), // key: uqj9uw
    IconLineElement(22, 9, 16, 15), // key: 1ewh16
    IconLineElement(16, 9, 22, 15), // key: 5ykzw1
  ]);

  /// `volume.mjs`
  static const LucideGlyph volume = LucideGlyph('volume', <IconElement>[
    IconPathElement(
      'M11 4.702a.705.705 0 0 0-1.203-.498L6.413 7.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298z',
    ), // key: uqj9uw
  ]);

  /// `vote.mjs`
  static const LucideGlyph vote = LucideGlyph('vote', <IconElement>[
    IconPathElement('m9 12 2 2 4-4'), // key: dzmm74
    IconPathElement(
      'M5 7c0-1.1.9-2 2-2h10a2 2 0 0 1 2 2v12H5V7Z',
    ), // key: 1ezoue
    IconPathElement('M22 19H2'), // key: nuriw5
  ]);

  /// `wallet-cards.mjs`
  static const LucideGlyph
  walletCards = LucideGlyph('wallet-cards', <IconElement>[
    IconPathElement(
      'M3 11h3.75a2 2 0 0 1 1.6.8l.45.6a4 4 0 0 0 6.4 0l.45-.6a2 2 0 0 1 1.6-.8H21',
    ), // key: 1vwh6y
    IconPathElement('M3 7h18'), // key: 1uiuf2
    IconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `wallet-minimal.mjs`
  static const LucideGlyph
  walletMinimal = LucideGlyph('wallet-minimal', <IconElement>[
    IconPathElement('M17 14h.01'), // key: 7oqj8z
    IconPathElement(
      'M7 7h12a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14',
    ), // key: u1rqew
  ]);

  /// `wallet.mjs`
  static const LucideGlyph wallet = LucideGlyph('wallet', <IconElement>[
    IconPathElement(
      'M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1',
    ), // key: 18etb6
    IconPathElement('M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4'), // key: xoc0q4
  ]);

  /// `wallpaper.mjs`
  static const LucideGlyph wallpaper = LucideGlyph('wallpaper', <IconElement>[
    IconPathElement('M12 17v4'), // key: 1riwvh
    IconPathElement('M8 21h8'), // key: 1ev6f3
    IconPathElement('m9 17 6.1-6.1a2 2 0 0 1 2.81.01L22 15'), // key: 1sl52q
    IconCircleElement(8, 9, 2), // key: gjzl9d
    IconRectElement(2, 3, 20, 14, 2), // key: x3v2xh
  ]);

  /// `wand-sparkles.mjs`
  static const LucideGlyph
  wandSparkles = LucideGlyph('wand-sparkles', <IconElement>[
    IconPathElement(
      'm21.64 3.64-1.28-1.28a1.21 1.21 0 0 0-1.72 0L2.36 18.64a1.21 1.21 0 0 0 0 1.72l1.28 1.28a1.2 1.2 0 0 0 1.72 0L21.64 5.36a1.2 1.2 0 0 0 0-1.72',
    ), // key: ul74o6
    IconPathElement('m14 7 3 3'), // key: 1r5n42
    IconPathElement('M5 6v4'), // key: ilb8ba
    IconPathElement('M19 14v4'), // key: blhpug
    IconPathElement('M10 2v2'), // key: 7u0qdc
    IconPathElement('M7 8H3'), // key: zfb6yr
    IconPathElement('M21 16h-4'), // key: 1cnmox
    IconPathElement('M11 3H9'), // key: 1obp7u
  ]);

  /// `wand.mjs`
  static const LucideGlyph wand = LucideGlyph('wand', <IconElement>[
    IconPathElement('M15 4V2'), // key: z1p9b7
    IconPathElement('M15 16v-2'), // key: px0unx
    IconPathElement('M8 9h2'), // key: 1g203m
    IconPathElement('M20 9h2'), // key: 19tzq7
    IconPathElement('M17.8 11.8 19 13'), // key: yihg8r
    IconPathElement('M15 9h.01'), // key: x1ddxp
    IconPathElement('M17.8 6.2 19 5'), // key: fd4us0
    IconPathElement('m3 21 9-9'), // key: 1jfql5
    IconPathElement('M12.2 6.2 11 5'), // key: i3da3b
  ]);

  /// `warehouse.mjs`
  static const LucideGlyph warehouse = LucideGlyph('warehouse', <IconElement>[
    IconPathElement(
      'M18 21V10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1v11',
    ), // key: pb2vm6
    IconPathElement(
      'M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V8a2 2 0 0 1 1.132-1.803l7.95-3.974a2 2 0 0 1 1.837 0l7.948 3.974A2 2 0 0 1 22 8z',
    ), // key: doq5xv
    IconPathElement('M6 13h12'), // key: yf64js
    IconPathElement('M6 17h12'), // key: 1jwigz
  ]);

  /// `washing-machine.mjs`
  static const LucideGlyph washingMachine = LucideGlyph(
    'washing-machine',
    <IconElement>[
      IconPathElement('M3 6h3'), // key: 155dbl
      IconPathElement('M17 6h.01'), // key: e2y6kg
      IconRectElement(3, 2, 18, 20, 2), // key: od3kk9
      IconCircleElement(12, 13, 5), // key: nlbqau
      IconPathElement(
        'M12 18a2.5 2.5 0 0 0 0-5 2.5 2.5 0 0 1 0-5',
      ), // key: 17lach
    ],
  );

  /// `watch.mjs`
  static const LucideGlyph watch = LucideGlyph('watch', <IconElement>[
    IconPathElement('M12 10v2.2l1.6 1'), // key: n3r21l
    IconPathElement(
      'm16.13 7.66-.81-4.05a2 2 0 0 0-2-1.61h-2.68a2 2 0 0 0-2 1.61l-.78 4.05',
    ), // key: 18k57s
    IconPathElement(
      'm7.88 16.36.8 4a2 2 0 0 0 2 1.61h2.72a2 2 0 0 0 2-1.61l.81-4.05',
    ), // key: 16ny36
    IconCircleElement(12, 12, 6), // key: 1vlfrh
  ]);

  /// `waves-arrow-down.mjs`
  static const LucideGlyph
  wavesArrowDown = LucideGlyph('waves-arrow-down', <IconElement>[
    IconPathElement('M12 10L12 2'), // key: jvb0aw
    IconPathElement('M16 6L12 10L8 6'), // key: 9j6vje
    IconPathElement(
      'M2 15C2.6 15.5 3.2 16 4.5 16C7 16 7 14 9.5 14C12.1 14 11.9 16 14.5 16C17 16 17 14 19.5 14C20.8 14 21.4 14.5 22 15',
    ), // key: s2zepw
    IconPathElement(
      'M2 21C2.6 21.5 3.2 22 4.5 22C7 22 7 20 9.5 20C12.1 20 11.9 22 14.5 22C17 22 17 20 19.5 20C20.8 20 21.4 20.5 22 21',
    ), // key: u68omc
  ]);

  /// `waves-arrow-up.mjs`
  static const LucideGlyph
  wavesArrowUp = LucideGlyph('waves-arrow-up', <IconElement>[
    IconPathElement('M12 2v8'), // key: 1q4o3n
    IconPathElement(
      'M2 15c.6.5 1.2 1 2.5 1 2.5 0 2.5-2 5-2 2.6 0 2.4 2 5 2 2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1',
    ), // key: 1p9f19
    IconPathElement(
      'M2 21c.6.5 1.2 1 2.5 1 2.5 0 2.5-2 5-2 2.6 0 2.4 2 5 2 2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1',
    ), // key: vbxynw
    IconPathElement('m8 6 4-4 4 4'), // key: ybng9g
  ]);

  /// `waves-horizontal.mjs`
  static const LucideGlyph wavesHorizontal = LucideGlyph(
    'waves-horizontal',
    <IconElement>[
      IconPathElement('M2 12q2.5 2 5 0t5 0 5 0 5 0'), // key: 8ddzzs
      IconPathElement('M2 19q2.5 2 5 0t5 0 5 0 5 0'), // key: 1wj4st
      IconPathElement('M2 5q2.5 2 5 0t5 0 5 0 5 0'), // key: 69x50u
    ],
  );

  /// `waves-ladder.mjs`
  static const LucideGlyph
  wavesLadder = LucideGlyph('waves-ladder', <IconElement>[
    IconPathElement('M19 5a2 2 0 0 0-2 2v11'), // key: s41o68
    IconPathElement(
      'M2 18c.6.5 1.2 1 2.5 1 2.5 0 2.5-2 5-2 2.6 0 2.4 2 5 2 2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1',
    ), // key: rd2r6e
    IconPathElement('M7 13h10'), // key: 1rwob1
    IconPathElement('M7 9h10'), // key: 12czzb
    IconPathElement('M9 5a2 2 0 0 0-2 2v11'), // key: x0q4gh
  ]);

  /// `waves-vertical.mjs`
  static const LucideGlyph wavesVertical = LucideGlyph(
    'waves-vertical',
    <IconElement>[
      IconPathElement('M12 2q2 2.5 0 5t0 5 0 5 0 5'), // key: 13jdbg
      IconPathElement('M19 2q2 2.5 0 5t0 5 0 5 0 5'), // key: 1ozhzu
      IconPathElement('M5 2q2 2.5 0 5t0 5 0 5 0 5'), // key: 1bi6v5
    ],
  );

  /// `waypoints.mjs`
  static const LucideGlyph waypoints = LucideGlyph('waypoints', <IconElement>[
    IconPathElement('m10.586 5.414-5.172 5.172'), // key: 4mc350
    IconPathElement('m18.586 13.414-5.172 5.172'), // key: 8c96vv
    IconPathElement('M6 12h12'), // key: 8npq4p
    IconCircleElement(12, 20, 2), // key: 144qzu
    IconCircleElement(12, 4, 2), // key: muu5ef
    IconCircleElement(20, 12, 2), // key: 1xzzfp
    IconCircleElement(4, 12, 2), // key: 1hvhnz
  ]);

  /// `webcam-off.mjs`
  static const LucideGlyph webcamOff = LucideGlyph('webcam-off', <IconElement>[
    IconPathElement('M12 22v-4'), // key: 1utk9m
    IconPathElement('M12.754 7.096a3 3 0 0 1 2.15 2.15'), // key: 1v0qsm
    IconPathElement('M12.863 12.873a3 3 0 0 1-3.736-3.735'), // key: 13aqxl
    IconPathElement('M16.566 16.57A8 8 0 0 1 5.43 5.433'), // key: 1hliph
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement('M7 22h10'), // key: 10w4w3
    IconPathElement('M8.478 2.817a8 8 0 0 1 10.705 10.705'), // key: r097k8
  ]);

  /// `webcam.mjs`
  static const LucideGlyph webcam = LucideGlyph('webcam', <IconElement>[
    IconCircleElement(12, 10, 8), // key: 1gshiw
    IconCircleElement(12, 10, 3), // key: ilqhr7
    IconPathElement('M7 22h10'), // key: 10w4w3
    IconPathElement('M12 22v-4'), // key: 1utk9m
  ]);

  /// `webhook-off.mjs`
  static const LucideGlyph webhookOff = LucideGlyph(
    'webhook-off',
    <IconElement>[
      IconPathElement(
        'M17 17h-5c-1.09-.02-1.94.92-2.5 1.9A3 3 0 1 1 2.57 15',
      ), // key: 1tvl6x
      IconPathElement('M9 3.4a4 4 0 0 1 6.52.66'), // key: q04jfq
      IconPathElement('m6 17 3.1-5.8a2.5 2.5 0 0 0 .057-2.05'), // key: azowf0
      IconPathElement('M20.3 20.3a4 4 0 0 1-2.3.7'), // key: 5joiws
      IconPathElement('M18.6 13a4 4 0 0 1 3.357 3.414'), // key: cangb8
      IconPathElement('m12 6 .6 1'), // key: tpjl1n
      IconPathElement('m2 2 20 20'), // key: 1ooewy
    ],
  );

  /// `webhook.mjs`
  static const LucideGlyph webhook = LucideGlyph('webhook', <IconElement>[
    IconPathElement(
      'M18 16.98h-5.99c-1.1 0-1.95.94-2.48 1.9A4 4 0 0 1 2 17c.01-.7.2-1.4.57-2',
    ), // key: q3hayz
    IconPathElement(
      'm6 17 3.13-5.78c.53-.97.1-2.18-.5-3.1a4 4 0 1 1 6.89-4.06',
    ), // key: 1go1hn
    IconPathElement(
      'm12 6 3.13 5.73C15.66 12.7 16.9 13 18 13a4 4 0 0 1 0 8',
    ), // key: qlwsc0
  ]);

  /// `weight-tilde.mjs`
  static const LucideGlyph
  weightTilde = LucideGlyph('weight-tilde', <IconElement>[
    IconPathElement(
      'M6.5 8a2 2 0 0 0-1.906 1.46L2.1 18.5A2 2 0 0 0 4 21h16a2 2 0 0 0 1.925-2.54L19.4 9.5A2 2 0 0 0 17.48 8z',
    ), // key: 1wl739
    IconPathElement(
      'M7.999 15a2.5 2.5 0 0 1 4 0 2.5 2.5 0 0 0 4 0',
    ), // key: 1egezo
    IconCircleElement(12, 5, 3), // key: rqqgnr
  ]);

  /// `weight.mjs`
  static const LucideGlyph weight = LucideGlyph('weight', <IconElement>[
    IconCircleElement(12, 5, 3), // key: rqqgnr
    IconPathElement(
      'M6.5 8a2 2 0 0 0-1.905 1.46L2.1 18.5A2 2 0 0 0 4 21h16a2 2 0 0 0 1.925-2.54L19.4 9.5A2 2 0 0 0 17.48 8Z',
    ), // key: 56o5sh
  ]);

  /// `wheat-off.mjs`
  static const LucideGlyph wheatOff = LucideGlyph('wheat-off', <IconElement>[
    IconPathElement('m2 22 10-10'), // key: 28ilpk
    IconPathElement('m16 8-1.17 1.17'), // key: 1qqm82
    IconPathElement(
      'M3.47 12.53 5 11l1.53 1.53a3.5 3.5 0 0 1 0 4.94L5 19l-1.53-1.53a3.5 3.5 0 0 1 0-4.94Z',
    ), // key: 1rdhi6
    IconPathElement(
      'm8 8-.53.53a3.5 3.5 0 0 0 0 4.94L9 15l1.53-1.53c.55-.55.88-1.25.98-1.97',
    ), // key: 4wz8re
    IconPathElement(
      'M10.91 5.26c.15-.26.34-.51.56-.73L13 3l1.53 1.53a3.5 3.5 0 0 1 .28 4.62',
    ), // key: rves66
    IconPathElement(
      'M20 2h2v2a4 4 0 0 1-4 4h-2V6a4 4 0 0 1 4-4Z',
    ), // key: 19rau1
    IconPathElement(
      'M11.47 17.47 13 19l-1.53 1.53a3.5 3.5 0 0 1-4.94 0L5 19l1.53-1.53a3.5 3.5 0 0 1 4.94 0Z',
    ), // key: tc8ph9
    IconPathElement(
      'm16 16-.53.53a3.5 3.5 0 0 1-4.94 0L9 15l1.53-1.53a3.49 3.49 0 0 1 1.97-.98',
    ), // key: ak46r
    IconPathElement(
      'M18.74 13.09c.26-.15.51-.34.73-.56L21 11l-1.53-1.53a3.5 3.5 0 0 0-4.62-.28',
    ), // key: 1tw520
    IconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `wheat.mjs`
  static const LucideGlyph wheat = LucideGlyph('wheat', <IconElement>[
    IconPathElement('M2 22 16 8'), // key: 60hf96
    IconPathElement(
      'M3.47 12.53 5 11l1.53 1.53a3.5 3.5 0 0 1 0 4.94L5 19l-1.53-1.53a3.5 3.5 0 0 1 0-4.94Z',
    ), // key: 1rdhi6
    IconPathElement(
      'M7.47 8.53 9 7l1.53 1.53a3.5 3.5 0 0 1 0 4.94L9 15l-1.53-1.53a3.5 3.5 0 0 1 0-4.94Z',
    ), // key: 1sdzmb
    IconPathElement(
      'M11.47 4.53 13 3l1.53 1.53a3.5 3.5 0 0 1 0 4.94L13 11l-1.53-1.53a3.5 3.5 0 0 1 0-4.94Z',
    ), // key: eoatbi
    IconPathElement(
      'M20 2h2v2a4 4 0 0 1-4 4h-2V6a4 4 0 0 1 4-4Z',
    ), // key: 19rau1
    IconPathElement(
      'M11.47 17.47 13 19l-1.53 1.53a3.5 3.5 0 0 1-4.94 0L5 19l1.53-1.53a3.5 3.5 0 0 1 4.94 0Z',
    ), // key: tc8ph9
    IconPathElement(
      'M15.47 13.47 17 15l-1.53 1.53a3.5 3.5 0 0 1-4.94 0L9 15l1.53-1.53a3.5 3.5 0 0 1 4.94 0Z',
    ), // key: 2m8kc5
    IconPathElement(
      'M19.47 9.47 21 11l-1.53 1.53a3.5 3.5 0 0 1-4.94 0L13 11l1.53-1.53a3.5 3.5 0 0 1 4.94 0Z',
    ), // key: vex3ng
  ]);

  /// `whole-word.mjs`
  static const LucideGlyph wholeWord = LucideGlyph('whole-word', <IconElement>[
    IconCircleElement(7, 12, 3), // key: 12clwm
    IconPathElement('M10 9v6'), // key: 17i7lo
    IconCircleElement(17, 12, 3), // key: gl7c2s
    IconPathElement('M14 7v8'), // key: dl84cr
    IconPathElement(
      'M22 17v1c0 .5-.5 1-1 1H3c-.5 0-1-.5-1-1v-1',
    ), // key: lt2kga
  ]);

  /// `wifi-cog.mjs`
  static const LucideGlyph wifiCog = LucideGlyph('wifi-cog', <IconElement>[
    IconPathElement('m14.305 19.53.923-.382'), // key: 3m78fa
    IconPathElement('m15.228 16.852-.923-.383'), // key: npixar
    IconPathElement('m16.852 15.228-.383-.923'), // key: 5xggr7
    IconPathElement('m16.852 20.772-.383.924'), // key: dpfhf9
    IconPathElement('m19.148 15.228.383-.923'), // key: 1reyyz
    IconPathElement('m19.53 21.696-.382-.924'), // key: 1goivc
    IconPathElement('M2 7.82a15 15 0 0 1 20 0'), // key: 1ovjuk
    IconPathElement('m20.772 16.852.924-.383'), // key: htqkph
    IconPathElement('m20.772 19.148.924.383'), // key: 9w9pjp
    IconPathElement('M5 11.858a10 10 0 0 1 11.5-1.785'), // key: 3sn16i
    IconPathElement('M8.5 15.429a5 5 0 0 1 2.413-1.31'), // key: 1pxovh
    IconCircleElement(18, 18, 3), // key: 1xkwt0
  ]);

  /// `wifi-high.mjs`
  static const LucideGlyph wifiHigh = LucideGlyph('wifi-high', <IconElement>[
    IconPathElement('M12 20h.01'), // key: zekei9
    IconPathElement('M5 12.859a10 10 0 0 1 14 0'), // key: 1x1e6c
    IconPathElement('M8.5 16.429a5 5 0 0 1 7 0'), // key: 1bycff
  ]);

  /// `wifi-low.mjs`
  static const LucideGlyph wifiLow = LucideGlyph('wifi-low', <IconElement>[
    IconPathElement('M12 20h.01'), // key: zekei9
    IconPathElement('M8.5 16.429a5 5 0 0 1 7 0'), // key: 1bycff
  ]);

  /// `wifi-off.mjs`
  static const LucideGlyph wifiOff = LucideGlyph('wifi-off', <IconElement>[
    IconPathElement('M12 20h.01'), // key: zekei9
    IconPathElement('M8.5 16.429a5 5 0 0 1 7 0'), // key: 1bycff
    IconPathElement('M5 12.859a10 10 0 0 1 5.17-2.69'), // key: 1dl1wf
    IconPathElement('M19 12.859a10 10 0 0 0-2.007-1.523'), // key: 4k23kn
    IconPathElement('M2 8.82a15 15 0 0 1 4.177-2.643'), // key: 1grhjp
    IconPathElement('M22 8.82a15 15 0 0 0-11.288-3.764'), // key: z3jwby
    IconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `wifi-pen.mjs`
  static const LucideGlyph wifiPen = LucideGlyph('wifi-pen', <IconElement>[
    IconPathElement('M2 8.82a15 15 0 0 1 20 0'), // key: dnpr2z
    IconPathElement(
      'M21.378 16.626a1 1 0 0 0-3.004-3.004l-4.01 4.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z',
    ), // key: 1817ys
    IconPathElement('M5 12.859a10 10 0 0 1 10.5-2.222'), // key: rpb7oy
    IconPathElement('M8.5 16.429a5 5 0 0 1 3-1.406'), // key: r8bmzl
  ]);

  /// `wifi-sync.mjs`
  static const LucideGlyph wifiSync = LucideGlyph('wifi-sync', <IconElement>[
    IconPathElement(
      'M11.965 10.105v4L13.5 12.5a5 5 0 0 1 8 1.5',
    ), // key: 1immaq
    IconPathElement('M11.965 14.105h4'), // key: uejny8
    IconPathElement(
      'M17.965 18.105h4L20.43 19.71a5 5 0 0 1-8-1.5',
    ), // key: 1i3a7e
    IconPathElement('M2 8.82a15 15 0 0 1 20 0'), // key: dnpr2z
    IconPathElement('M21.965 22.105v-4'), // key: 1ku6vx
    IconPathElement('M5 12.86a10 10 0 0 1 3-2.032'), // key: pemdtu
    IconPathElement('M8.5 16.429h.01'), // key: 2bm739
  ]);

  /// `wifi-zero.mjs`
  static const LucideGlyph wifiZero = LucideGlyph('wifi-zero', <IconElement>[
    IconPathElement('M12 20h.01'), // key: zekei9
  ]);

  /// `wifi.mjs`
  static const LucideGlyph wifi = LucideGlyph('wifi', <IconElement>[
    IconPathElement('M12 20h.01'), // key: zekei9
    IconPathElement('M2 8.82a15 15 0 0 1 20 0'), // key: dnpr2z
    IconPathElement('M5 12.859a10 10 0 0 1 14 0'), // key: 1x1e6c
    IconPathElement('M8.5 16.429a5 5 0 0 1 7 0'), // key: 1bycff
  ]);

  /// `wind-arrow-down.mjs`
  static const LucideGlyph windArrowDown = LucideGlyph(
    'wind-arrow-down',
    <IconElement>[
      IconPathElement('M10 2v8'), // key: d4bbey
      IconPathElement('M12.8 21.6A2 2 0 1 0 14 18H2'), // key: 19kp1d
      IconPathElement('M17.5 10a2.5 2.5 0 1 1 2 4H2'), // key: 19kpjc
      IconPathElement('m6 6 4 4 4-4'), // key: k13n16
    ],
  );

  /// `wind.mjs`
  static const LucideGlyph wind = LucideGlyph('wind', <IconElement>[
    IconPathElement('M12.8 19.6A2 2 0 1 0 14 16H2'), // key: 148xed
    IconPathElement('M17.5 8a2.5 2.5 0 1 1 2 4H2'), // key: 1u4tom
    IconPathElement('M9.8 4.4A2 2 0 1 1 11 8H2'), // key: 75valh
  ]);

  /// `wine-off.mjs`
  static const LucideGlyph wineOff = LucideGlyph('wine-off', <IconElement>[
    IconPathElement('M8 22h8'), // key: rmew8v
    IconPathElement('M7 10h3m7 0h-1.343'), // key: v48bem
    IconPathElement('M12 15v7'), // key: t2xh3l
    IconPathElement(
      'M7.307 7.307A12.33 12.33 0 0 0 7 10a5 5 0 0 0 7.391 4.391M8.638 2.981C8.75 2.668 8.872 2.34 9 2h6c1.5 4 2 6 2 8 0 .407-.05.809-.145 1.198',
    ), // key: 1ymjlu
    IconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `wine.mjs`
  static const LucideGlyph wine = LucideGlyph('wine', <IconElement>[
    IconPathElement('M8 22h8'), // key: rmew8v
    IconPathElement('M7 10h10'), // key: 1101jm
    IconPathElement('M12 15v7'), // key: t2xh3l
    IconPathElement(
      'M12 15a5 5 0 0 0 5-5c0-2-.5-4-2-8H9c-1.5 4-2 6-2 8a5 5 0 0 0 5 5Z',
    ), // key: 10ffi3
  ]);

  /// `workflow.mjs`
  static const LucideGlyph workflow = LucideGlyph('workflow', <IconElement>[
    IconRectElement(3, 3, 8, 8, 2), // key: by2w9f
    IconPathElement('M7 11v4a2 2 0 0 0 2 2h4'), // key: xkn7yn
    IconRectElement(13, 13, 8, 8, 2), // key: 1cgmvn
  ]);

  /// `worm.mjs`
  static const LucideGlyph worm = LucideGlyph('worm', <IconElement>[
    IconPathElement('m19 12-1.5 3'), // key: 9bcu4o
    IconPathElement('M19.63 18.81 22 20'), // key: 121v98
    IconPathElement(
      'M6.47 8.23a1.68 1.68 0 0 1 2.44 1.93l-.64 2.08a6.76 6.76 0 0 0 10.16 7.67l.42-.27a1 1 0 1 0-2.73-4.21l-.42.27a1.76 1.76 0 0 1-2.63-1.99l.64-2.08A6.66 6.66 0 0 0 3.94 3.9l-.7.4a1 1 0 1 0 2.55 4.34z',
    ), // key: 1tij6q
  ]);

  /// `wrench-off.mjs`
  static const LucideGlyph wrenchOff = LucideGlyph('wrench-off', <IconElement>[
    IconPathElement(
      'M10.747 5.093a6 6 0 0 1 6.841-2.882c.438.12.54.662.219.984L14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.106-3.105c.32-.322.863-.22.983.218a6 6 0 0 1-2.882 6.842',
    ), // key: sded7h
    IconPathElement(
      'm13.5 13.5-7.88 7.88a1 1 0 0 1-2.999-3l7.88-7.88',
    ), // key: 66etnh
    IconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `wrench.mjs`
  static const LucideGlyph wrench = LucideGlyph('wrench', <IconElement>[
    IconPathElement(
      'M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.106-3.105c.32-.322.863-.22.983.218a6 6 0 0 1-8.259 7.057l-7.91 7.91a1 1 0 0 1-2.999-3l7.91-7.91a6 6 0 0 1 7.057-8.259c.438.12.54.662.219.984z',
    ), // key: 1ngwbx
  ]);

  /// `x-line-top.mjs`
  static const LucideGlyph xLineTop = LucideGlyph('x-line-top', <IconElement>[
    IconPathElement('M18 4H6'), // key: 1hsngl
    IconPathElement('M18 8 6 20'), // key: xspwia
    IconPathElement('m6 8 12 12'), // key: qb1veh
  ]);

  /// `x.mjs`
  static const LucideGlyph x = LucideGlyph('x', <IconElement>[
    IconPathElement('M18 6 6 18'), // key: 1bl5f8
    IconPathElement('m6 6 12 12'), // key: d8bk6v
  ]);

  /// `zap-off.mjs`
  static const LucideGlyph zapOff = LucideGlyph('zap-off', <IconElement>[
    IconPathElement(
      'M10.768 5.111 13.44 2.44a1.5 1.5 0 012.474 1.561l-1.633 4.625',
    ), // key: l6h226
    IconPathElement(
      'm18.889 13.232.672-.672A1.5 1.5 0 0018.5 10h-2.844',
    ), // key: 1717b9
    IconPathElement('m2 2 20 20'), // key: 1ooewy
    IconPathElement(
      'm7.94 7.94-3.5 3.499A1.5 1.5 0 005.5 14h4.002a.5.5 0 01.471.666L8.086 20a1.5 1.5 0 002.475 1.56l5.5-5.5',
    ), // key: 1bjzrh
  ]);

  /// `zap.mjs`
  static const LucideGlyph zap = LucideGlyph('zap', <IconElement>[
    IconPathElement(
      'M15.914 4a1.5 1.5 0 00-2.474-1.561l-9 9A1.5 1.5 0 005.5 14h4.002a.5.5 0 01.471.666L8.086 20a1.5 1.5 0 002.475 1.56l9-9A1.5 1.5 0 0018.5 10h-3.997a.5.5 0 01-.472-.667z',
    ), // key: 1v7up4
  ]);

  /// `zodiac-aquarius.mjs`
  static const LucideGlyph
  zodiacAquarius = LucideGlyph('zodiac-aquarius', <IconElement>[
    IconPathElement(
      'm2 10 2.456-3.684a.7.7 0 0 1 1.106-.013l2.39 3.413a.7.7 0 0 0 1.096-.001l2.402-3.432a.7.7 0 0 1 1.098 0l2.402 3.432a.7.7 0 0 0 1.098 0l2.389-3.413a.7.7 0 0 1 1.106.013L22 10',
    ), // key: 1o8iok
    IconPathElement(
      'm2 18.002 2.456-3.684a.7.7 0 0 1 1.106-.013l2.39 3.413a.7.7 0 0 0 1.097 0l2.402-3.432a.7.7 0 0 1 1.098 0l2.402 3.432a.7.7 0 0 0 1.098 0l2.389-3.413a.7.7 0 0 1 1.106.013L22 18.002',
    ), // key: 112qy7
  ]);

  /// `zodiac-aries.mjs`
  static const LucideGlyph zodiacAries = LucideGlyph(
    'zodiac-aries',
    <IconElement>[
      IconPathElement('M12 7.5a4.5 4.5 0 1 1 5 4.5'), // key: k987hv
      IconPathElement('M7 12a4.5 4.5 0 1 1 5-4.5V21'), // key: mjup0w
    ],
  );

  /// `zodiac-cancer.mjs`
  static const LucideGlyph zodiacCancer = LucideGlyph(
    'zodiac-cancer',
    <IconElement>[
      IconPathElement('M21 14.5A9 6.5 0 0 1 5.5 19'), // key: 1xj2o6
      IconPathElement('M3 9.5A9 6.5 0 0 1 18.5 5'), // key: 1gln3t
      IconCircleElement(17.5, 14.5, 3.5), // key: 1ccu1t
      IconCircleElement(6.5, 9.5, 3.5), // key: x5tc2d
    ],
  );

  /// `zodiac-capricorn.mjs`
  static const LucideGlyph zodiacCapricorn = LucideGlyph(
    'zodiac-capricorn',
    <IconElement>[
      IconPathElement('M11 21a3 3 0 0 0 3-3V6.5a1 1 0 0 0-7 0'), // key: 1kkncs
      IconPathElement('M7 19V6a3 3 0 0 0-3-3h0'), // key: 1jg5y1
      IconCircleElement(17, 17, 3), // key: 18b49y
    ],
  );

  /// `zodiac-gemini.mjs`
  static const LucideGlyph zodiacGemini = LucideGlyph(
    'zodiac-gemini',
    <IconElement>[
      IconPathElement('M16 4.525v14.948'), // key: bgoxo0
      IconPathElement('M20 3A17 17 0 0 1 4 3'), // key: 1djemw
      IconPathElement('M4 21a17 17 0 0 1 16 0'), // key: onoyo7
      IconPathElement('M8 4.525v14.948'), // key: u5iyof
    ],
  );

  /// `zodiac-leo.mjs`
  static const LucideGlyph zodiacLeo = LucideGlyph('zodiac-leo', <IconElement>[
    IconPathElement(
      'M10 16c0-4-3-4.5-3-8a5 5 0 0 1 10 0c0 3.466-3 6.196-3 10a3 3 0 0 0 6 0',
    ), // key: 1qj6nb
    IconCircleElement(7, 16, 3), // key: yyv3zl
  ]);

  /// `zodiac-libra.mjs`
  static const LucideGlyph
  zodiacLibra = LucideGlyph('zodiac-libra', <IconElement>[
    IconPathElement(
      'M3 16h6.857c.162-.012.19-.323.038-.38a6 6 0 1 1 4.212 0c-.153.057-.125.368.038.38H21',
    ), // key: 1novf0
    IconPathElement('M3 20h18'), // key: 1l19wn
  ]);

  /// `zodiac-ophiuchus.mjs`
  static const LucideGlyph zodiacOphiuchus = LucideGlyph(
    'zodiac-ophiuchus',
    <IconElement>[
      IconPathElement(
        'M3 10A6.06 6.06 0 0 1 12 10 A6.06 6.06 0 0 0 21 10',
      ), // key: 13lfmc
      IconPathElement('M6 3v12a6 6 0 0 0 12 0V3'), // key: 1jnivp
    ],
  );

  /// `zodiac-pisces.mjs`
  static const LucideGlyph zodiacPisces = LucideGlyph(
    'zodiac-pisces',
    <IconElement>[
      IconPathElement('M19 21a15 15 0 0 1 0-18'), // key: br2vug
      IconPathElement('M20 12H4'), // key: 1mtusc
      IconPathElement('M5 3a15 15 0 0 1 0 18'), // key: 1w7hae
    ],
  );

  /// `zodiac-sagittarius.mjs`
  static const LucideGlyph zodiacSagittarius = LucideGlyph(
    'zodiac-sagittarius',
    <IconElement>[
      IconPathElement('M15 3h6v6'), // key: 1q9fwt
      IconPathElement('M21 3 3 21'), // key: 1011np
      IconPathElement('m9 9 6 6'), // key: z0biqf
    ],
  );

  /// `zodiac-scorpio.mjs`
  static const LucideGlyph zodiacScorpio = LucideGlyph(
    'zodiac-scorpio',
    <IconElement>[
      IconPathElement(
        'M10 19V5.5a1 1 0 0 1 5 0V17a2 2 0 0 0 2 2h5l-3-3',
      ), // key: 1w8g0z
      IconPathElement('m22 19-3 3'), // key: 1ix4wq
      IconPathElement('M5 19V5.5a1 1 0 0 1 5 0'), // key: 1d4oa3
      IconPathElement('M5 5.5A2.5 2.5 0 0 0 2.5 3'), // key: gp646f
    ],
  );

  /// `zodiac-taurus.mjs`
  static const LucideGlyph zodiacTaurus = LucideGlyph(
    'zodiac-taurus',
    <IconElement>[
      IconCircleElement(12, 15, 6), // key: lhqcmb
      IconPathElement('M18 3A6 6 0 0 1 6 3'), // key: 1p399e
    ],
  );

  /// `zodiac-virgo.mjs`
  static const LucideGlyph zodiacVirgo = LucideGlyph(
    'zodiac-virgo',
    <IconElement>[
      IconPathElement('M11 5.5a1 1 0 0 1 5 0V16a5 5 0 0 0 5 5'), // key: 1szkuh
      IconPathElement('M16 11.5a1 1 0 0 1 5 0V16a5 5 0 0 1-5 5'), // key: pyq0k2
      IconPathElement('M6 19V6a3 3 0 0 0-3-3h0'), // key: pvee4g
      IconPathElement('M6 5.5a1 1 0 0 1 5 0V19'), // key: vncctg
    ],
  );

  /// `zoom-in.mjs`
  static const LucideGlyph zoomIn = LucideGlyph('zoom-in', <IconElement>[
    IconCircleElement(11, 11, 8), // key: 4ej97u
    IconLineElement(21, 21, 16.65, 16.65), // key: 13gj7c
    IconLineElement(11, 8, 11, 14), // key: 1vmskp
    IconLineElement(8, 11, 14, 11), // key: durymu
  ]);

  /// `zoom-out.mjs`
  static const LucideGlyph zoomOut = LucideGlyph('zoom-out', <IconElement>[
    IconCircleElement(11, 11, 8), // key: 4ej97u
    IconLineElement(21, 21, 16.65, 16.65), // key: 13gj7c
    IconLineElement(8, 11, 14, 11), // key: durymu
  ]);
}
