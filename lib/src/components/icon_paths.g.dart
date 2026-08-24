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
// 1756 glyphs, 7032 nodes (5932 path, 524 circle, 397 rect, 155 line, 16 ellipse, 6 polyline, 2 polygon); 250
// deprecated aliases are in `icon_paths.g.index.dart`.

/// The full lucide set, one `static const` per glyph.
///
/// **Why a class of constants and not an enum with a lookup map.** This file is
/// the whole package, and the whole package must not reach the bundle of an app
/// that draws six icons. Dart's tree shaker works per top-level symbol: a
/// `static const` field is dropped when nothing names it, so `ElLucide.zap`
/// pulls in `zap` and nothing else. A `const Map<ElIconGlyph, …>` is one
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

import 'icon_paths.dart'; // the sealed element model this file is emitted against

/// One lucide glyph: its module name and its `__iconNode` list.
///
/// A plain class with a const constructor rather than an enum member, and that
/// is the load-bearing choice in this file — see the library docstring.
@immutable
class ElLucideGlyph {
  const ElLucideGlyph(this.name, this.nodes);

  /// The lucide module name, kebab-case: `'circle-dollar-sign'`.
  final String name;

  /// `__iconNode`, in lucide's order, which is paint order.
  final List<ElIconElement> nodes;

  /// The glyph as one [Path] in 24-unit coordinates — the caller scales.
  ///
  /// A **fresh** path every call: [Path] is mutable, and a shared instance
  /// would let one painter corrupt every other icon.
  Path toPath() {
    final Path path = Path();
    for (final ElIconElement node in nodes) {
      node.addTo(path);
    }
    return path;
  }

  /// The `fill="currentColor"` nodes as one [Path], or `null` when there are
  /// none. 19 nodes across 9 glyphs carry the attribute.
  Path? toFillPath() {
    Path? path;
    for (final ElIconElement node in nodes) {
      if (!node.filled) continue;
      node.addTo(path ??= Path());
    }
    return path;
  }

  @override
  String toString() => 'ElLucideGlyph($name)';
}

/// Every glyph lucide 1.28.0 ships.
class ElLucide {
  const ElLucide._();

  /// The viewBox lucide authors on — the same 24×24 grid as [ElIconPaths].
  static const double viewBox = 24;

  /// `a-arrow-down.mjs`
  static const ElLucideGlyph aArrowDown = ElLucideGlyph(
    'a-arrow-down',
    <ElIconElement>[
      ElIconPathElement('m14 12 4 4 4-4'), // key: buelq4
      ElIconPathElement('M18 16V7'), // key: ty0viw
      ElIconPathElement(
        'm2 16 4.039-9.69a.5.5 0 0 1 .923 0L11 16',
      ), // key: d5nyq2
      ElIconPathElement('M3.304 13h6.392'), // key: 1q3zxz
    ],
  );

  /// `a-arrow-up.mjs`
  static const ElLucideGlyph aArrowUp = ElLucideGlyph(
    'a-arrow-up',
    <ElIconElement>[
      ElIconPathElement('m14 11 4-4 4 4'), // key: 1pu57t
      ElIconPathElement('M18 16V7'), // key: ty0viw
      ElIconPathElement(
        'm2 16 4.039-9.69a.5.5 0 0 1 .923 0L11 16',
      ), // key: d5nyq2
      ElIconPathElement('M3.304 13h6.392'), // key: 1q3zxz
    ],
  );

  /// `a-large-small.mjs`
  static const ElLucideGlyph aLargeSmall = ElLucideGlyph(
    'a-large-small',
    <ElIconElement>[
      ElIconPathElement(
        'm15 16 2.536-7.328a1.02 1.02 1 0 1 1.928 0L22 16',
      ), // key: xik6mr
      ElIconPathElement('M15.697 14h5.606'), // key: 1stdlc
      ElIconPathElement(
        'm2 16 4.039-9.69a.5.5 0 0 1 .923 0L11 16',
      ), // key: d5nyq2
      ElIconPathElement('M3.304 13h6.392'), // key: 1q3zxz
    ],
  );

  /// `accessibility.mjs`
  static const ElLucideGlyph accessibility = ElLucideGlyph(
    'accessibility',
    <ElIconElement>[
      ElIconCircleElement(16, 4, 1), // key: 1grugj
      ElIconPathElement('m18 19 1-7-6 1'), // key: r0i19z
      ElIconPathElement('m5 8 3-3 5.5 3-2.36 3.5'), // key: 9ptxx2
      ElIconPathElement('M4.24 14.5a5 5 0 0 0 6.88 6'), // key: 10kmtu
      ElIconPathElement('M13.76 17.5a5 5 0 0 0-6.88-6'), // key: 2qq6rc
    ],
  );

  /// `activity.mjs`
  static const ElLucideGlyph
  activity = ElLucideGlyph('activity', <ElIconElement>[
    ElIconPathElement(
      'M22 12h-2.48a2 2 0 0 0-1.93 1.46l-2.35 8.36a.25.25 0 0 1-.48 0L9.24 2.18a.25.25 0 0 0-.48 0l-2.35 8.36A2 2 0 0 1 4.49 12H2',
    ), // key: 169zse
  ]);

  /// `ad.mjs`
  static const ElLucideGlyph ad = ElLucideGlyph('ad', <ElIconElement>[
    ElIconPathElement('M10 13H6'), // key: 18d9xh
    ElIconPathElement('M10 15v-4a2 2 0 0 0-4 0v4'), // key: ss28p3
    ElIconPathElement(
      'M14 14.5a.5.5 0 0 0 .5.5h1a2.5 2.5 0 0 0 2.5-2.5v-1A2.5 2.5 0 0 0 15.5 9h-1a.5.5 0 0 0-.5.5z',
    ), // key: b3f847
    ElIconRectElement(2, 5, 20, 14, 2), // key: qneu4z
  ]);

  /// `air-vent.mjs`
  static const ElLucideGlyph
  airVent = ElLucideGlyph('air-vent', <ElIconElement>[
    ElIconPathElement('M18 17.5a2.5 2.5 0 1 1-4 2.03V12'), // key: yd12zl
    ElIconPathElement(
      'M6 12H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2',
    ), // key: larmp2
    ElIconPathElement('M6 8h12'), // key: 6g4wlu
    ElIconPathElement('M6.6 15.572A2 2 0 1 0 10 17v-5'), // key: 1x1kqn
  ]);

  /// `airplay.mjs`
  static const ElLucideGlyph airplay = ElLucideGlyph('airplay', <ElIconElement>[
    ElIconPathElement(
      'M5 17H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-1',
    ), // key: ns4c3b
    ElIconPathElement('m12 15 5 6H7Z'), // key: 14qnn2
  ]);

  /// `alarm-clock-check.mjs`
  static const ElLucideGlyph alarmClockCheck = ElLucideGlyph(
    'alarm-clock-check',
    <ElIconElement>[
      ElIconCircleElement(12, 13, 8), // key: 3y4lt7
      ElIconPathElement('M5 3 2 6'), // key: 18tl5t
      ElIconPathElement('m22 6-3-3'), // key: 1opdir
      ElIconPathElement('M6.38 18.7 4 21'), // key: 17xu3x
      ElIconPathElement('M17.64 18.67 20 21'), // key: kv2oe2
      ElIconPathElement('m9 13 2 2 4-4'), // key: 6343dt
    ],
  );

  /// `alarm-clock-minus.mjs`
  static const ElLucideGlyph alarmClockMinus = ElLucideGlyph(
    'alarm-clock-minus',
    <ElIconElement>[
      ElIconCircleElement(12, 13, 8), // key: 3y4lt7
      ElIconPathElement('M5 3 2 6'), // key: 18tl5t
      ElIconPathElement('m22 6-3-3'), // key: 1opdir
      ElIconPathElement('M6.38 18.7 4 21'), // key: 17xu3x
      ElIconPathElement('M17.64 18.67 20 21'), // key: kv2oe2
      ElIconPathElement('M9 13h6'), // key: 1uhe8q
    ],
  );

  /// `alarm-clock-off.mjs`
  static const ElLucideGlyph alarmClockOff = ElLucideGlyph(
    'alarm-clock-off',
    <ElIconElement>[
      ElIconPathElement('M6.87 6.87a8 8 0 1 0 11.26 11.26'), // key: 3on8tj
      ElIconPathElement('M19.9 14.25a8 8 0 0 0-9.15-9.15'), // key: 15ghsc
      ElIconPathElement('m22 6-3-3'), // key: 1opdir
      ElIconPathElement('M6.26 18.67 4 21'), // key: yzmioq
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
      ElIconPathElement('M4 4 2 6'), // key: 1ycko6
    ],
  );

  /// `alarm-clock-plus.mjs`
  static const ElLucideGlyph alarmClockPlus = ElLucideGlyph(
    'alarm-clock-plus',
    <ElIconElement>[
      ElIconCircleElement(12, 13, 8), // key: 3y4lt7
      ElIconPathElement('M5 3 2 6'), // key: 18tl5t
      ElIconPathElement('m22 6-3-3'), // key: 1opdir
      ElIconPathElement('M6.38 18.7 4 21'), // key: 17xu3x
      ElIconPathElement('M17.64 18.67 20 21'), // key: kv2oe2
      ElIconPathElement('M12 10v6'), // key: 1bos4e
      ElIconPathElement('M9 13h6'), // key: 1uhe8q
    ],
  );

  /// `alarm-clock.mjs`
  static const ElLucideGlyph alarmClock = ElLucideGlyph(
    'alarm-clock',
    <ElIconElement>[
      ElIconCircleElement(12, 13, 8), // key: 3y4lt7
      ElIconPathElement('M12 9v4l2 2'), // key: 1c63tq
      ElIconPathElement('M5 3 2 6'), // key: 18tl5t
      ElIconPathElement('m22 6-3-3'), // key: 1opdir
      ElIconPathElement('M6.38 18.7 4 21'), // key: 17xu3x
      ElIconPathElement('M17.64 18.67 20 21'), // key: kv2oe2
    ],
  );

  /// `alarm-smoke.mjs`
  static const ElLucideGlyph alarmSmoke = ElLucideGlyph(
    'alarm-smoke',
    <ElIconElement>[
      ElIconPathElement('M11 21c0-2.5 2-2.5 2-5'), // key: 1sicvv
      ElIconPathElement('M16 21c0-2.5 2-2.5 2-5'), // key: 1o3eny
      ElIconPathElement(
        'm19 8-.8 3a1.25 1.25 0 0 1-1.2 1H7a1.25 1.25 0 0 1-1.2-1L5 8',
      ), // key: 1bvca4
      ElIconPathElement(
        'M21 3a1 1 0 0 1 1 1v2a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V4a1 1 0 0 1 1-1z',
      ), // key: x3qr1j
      ElIconPathElement('M6 21c0-2.5 2-2.5 2-5'), // key: i3w1gp
    ],
  );

  /// `album.mjs`
  static const ElLucideGlyph album = ElLucideGlyph('album', <ElIconElement>[
    ElIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    ElIconPolylineElement(<Offset>[
      Offset(11, 3),
      Offset(11, 11),
      Offset(14, 8),
      Offset(17, 11),
      Offset(17, 3),
    ]), // key: 1wcwz3
  ]);

  /// `align-center-horizontal.mjs`
  static const ElLucideGlyph alignCenterHorizontal = ElLucideGlyph(
    'align-center-horizontal',
    <ElIconElement>[
      ElIconPathElement('M2 12h20'), // key: 9i4pu4
      ElIconPathElement(
        'M10 16v4a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-4',
      ), // key: 11f1s0
      ElIconPathElement(
        'M10 8V4a2 2 0 0 0-2-2H6a2 2 0 0 0-2 2v4',
      ), // key: t14dx9
      ElIconPathElement(
        'M20 16v1a2 2 0 0 1-2 2h-2a2 2 0 0 1-2-2v-1',
      ), // key: 1w07xs
      ElIconPathElement(
        'M14 8V7c0-1.1.9-2 2-2h2a2 2 0 0 1 2 2v1',
      ), // key: 1apec2
    ],
  );

  /// `align-center-vertical.mjs`
  static const ElLucideGlyph
  alignCenterVertical = ElLucideGlyph('align-center-vertical', <ElIconElement>[
    ElIconPathElement('M12 2v20'), // key: t6zp3m
    ElIconPathElement('M8 10H4a2 2 0 0 1-2-2V6c0-1.1.9-2 2-2h4'), // key: 14d6g8
    ElIconPathElement(
      'M16 10h4a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2h-4',
    ), // key: 1e2lrw
    ElIconPathElement(
      'M8 20H7a2 2 0 0 1-2-2v-2c0-1.1.9-2 2-2h1',
    ), // key: 1fkdwx
    ElIconPathElement(
      'M16 14h1a2 2 0 0 1 2 2v2a2 2 0 0 1-2 2h-1',
    ), // key: 1euafb
  ]);

  /// `align-end-horizontal.mjs`
  static const ElLucideGlyph alignEndHorizontal = ElLucideGlyph(
    'align-end-horizontal',
    <ElIconElement>[
      ElIconRectElement(4, 2, 6, 16, 2), // key: z5wdxg
      ElIconRectElement(14, 9, 6, 9, 2), // key: um7a8w
      ElIconPathElement('M22 22H2'), // key: 19qnx5
    ],
  );

  /// `align-end-vertical.mjs`
  static const ElLucideGlyph alignEndVertical = ElLucideGlyph(
    'align-end-vertical',
    <ElIconElement>[
      ElIconRectElement(2, 4, 16, 6, 2), // key: 10wcwx
      ElIconRectElement(9, 14, 9, 6, 2), // key: 4p5bwg
      ElIconPathElement('M22 22V2'), // key: 12ipfv
    ],
  );

  /// `align-horizontal-distribute-center.mjs`
  static const ElLucideGlyph alignHorizontalDistributeCenter = ElLucideGlyph(
    'align-horizontal-distribute-center',
    <ElIconElement>[
      ElIconRectElement(4, 5, 6, 14, 2), // key: 1wwnby
      ElIconRectElement(14, 7, 6, 10, 2), // key: 1fe6j6
      ElIconPathElement('M17 22v-5'), // key: 4b6g73
      ElIconPathElement('M17 7V2'), // key: hnrr36
      ElIconPathElement('M7 22v-3'), // key: 1r4jpn
      ElIconPathElement('M7 5V2'), // key: liy1u9
    ],
  );

  /// `align-horizontal-distribute-end.mjs`
  static const ElLucideGlyph alignHorizontalDistributeEnd = ElLucideGlyph(
    'align-horizontal-distribute-end',
    <ElIconElement>[
      ElIconRectElement(4, 5, 6, 14, 2), // key: 1wwnby
      ElIconRectElement(14, 7, 6, 10, 2), // key: 1fe6j6
      ElIconPathElement('M10 2v20'), // key: uyc634
      ElIconPathElement('M20 2v20'), // key: 1tx262
    ],
  );

  /// `align-horizontal-distribute-start.mjs`
  static const ElLucideGlyph alignHorizontalDistributeStart = ElLucideGlyph(
    'align-horizontal-distribute-start',
    <ElIconElement>[
      ElIconRectElement(4, 5, 6, 14, 2), // key: 1wwnby
      ElIconRectElement(14, 7, 6, 10, 2), // key: 1fe6j6
      ElIconPathElement('M4 2v20'), // key: gtpd5x
      ElIconPathElement('M14 2v20'), // key: tg6bpw
    ],
  );

  /// `align-horizontal-justify-center.mjs`
  static const ElLucideGlyph alignHorizontalJustifyCenter = ElLucideGlyph(
    'align-horizontal-justify-center',
    <ElIconElement>[
      ElIconRectElement(2, 5, 6, 14, 2), // key: dy24zr
      ElIconRectElement(16, 7, 6, 10, 2), // key: 13zkjt
      ElIconPathElement('M12 2v20'), // key: t6zp3m
    ],
  );

  /// `align-horizontal-justify-end.mjs`
  static const ElLucideGlyph alignHorizontalJustifyEnd = ElLucideGlyph(
    'align-horizontal-justify-end',
    <ElIconElement>[
      ElIconRectElement(2, 5, 6, 14, 2), // key: dy24zr
      ElIconRectElement(12, 7, 6, 10, 2), // key: 1ht384
      ElIconPathElement('M22 2v20'), // key: 40qfg1
    ],
  );

  /// `align-horizontal-justify-start.mjs`
  static const ElLucideGlyph alignHorizontalJustifyStart = ElLucideGlyph(
    'align-horizontal-justify-start',
    <ElIconElement>[
      ElIconRectElement(6, 5, 6, 14, 2), // key: hsirpf
      ElIconRectElement(16, 7, 6, 10, 2), // key: 13zkjt
      ElIconPathElement('M2 2v20'), // key: 1ivd8o
    ],
  );

  /// `align-horizontal-space-around.mjs`
  static const ElLucideGlyph alignHorizontalSpaceAround = ElLucideGlyph(
    'align-horizontal-space-around',
    <ElIconElement>[
      ElIconRectElement(9, 7, 6, 10, 2), // key: yn7j0q
      ElIconPathElement('M4 22V2'), // key: tsjzd3
      ElIconPathElement('M20 22V2'), // key: 1bnhr8
    ],
  );

  /// `align-horizontal-space-between.mjs`
  static const ElLucideGlyph alignHorizontalSpaceBetween = ElLucideGlyph(
    'align-horizontal-space-between',
    <ElIconElement>[
      ElIconRectElement(3, 5, 6, 14, 2), // key: j77dae
      ElIconRectElement(15, 7, 6, 10, 2), // key: bq30hj
      ElIconPathElement('M3 2v20'), // key: 1d2pfg
      ElIconPathElement('M21 2v20'), // key: p059bm
    ],
  );

  /// `align-start-horizontal.mjs`
  static const ElLucideGlyph alignStartHorizontal = ElLucideGlyph(
    'align-start-horizontal',
    <ElIconElement>[
      ElIconRectElement(4, 6, 6, 16, 2), // key: 1n4dg1
      ElIconRectElement(14, 6, 6, 9, 2), // key: 17khns
      ElIconPathElement('M22 2H2'), // key: fhrpnj
    ],
  );

  /// `align-start-vertical.mjs`
  static const ElLucideGlyph alignStartVertical = ElLucideGlyph(
    'align-start-vertical',
    <ElIconElement>[
      ElIconRectElement(6, 14, 9, 6, 2), // key: lpm2y7
      ElIconRectElement(6, 4, 16, 6, 2), // key: rdj6ps
      ElIconPathElement('M2 2v20'), // key: 1ivd8o
    ],
  );

  /// `align-vertical-distribute-center.mjs`
  static const ElLucideGlyph alignVerticalDistributeCenter = ElLucideGlyph(
    'align-vertical-distribute-center',
    <ElIconElement>[
      ElIconPathElement('M22 17h-3'), // key: 1lwga1
      ElIconPathElement('M22 7h-5'), // key: o2endc
      ElIconPathElement('M5 17H2'), // key: 1gx9xc
      ElIconPathElement('M7 7H2'), // key: 6bq26l
      ElIconRectElement(5, 14, 14, 6, 2), // key: 1qrzuf
      ElIconRectElement(7, 4, 10, 6, 2), // key: we8e9z
    ],
  );

  /// `align-vertical-distribute-end.mjs`
  static const ElLucideGlyph alignVerticalDistributeEnd = ElLucideGlyph(
    'align-vertical-distribute-end',
    <ElIconElement>[
      ElIconRectElement(5, 14, 14, 6, 2), // key: jmoj9s
      ElIconRectElement(7, 4, 10, 6, 2), // key: aza5on
      ElIconPathElement('M2 20h20'), // key: owomy5
      ElIconPathElement('M2 10h20'), // key: 1ir3d8
    ],
  );

  /// `align-vertical-distribute-start.mjs`
  static const ElLucideGlyph alignVerticalDistributeStart = ElLucideGlyph(
    'align-vertical-distribute-start',
    <ElIconElement>[
      ElIconRectElement(5, 14, 14, 6, 2), // key: jmoj9s
      ElIconRectElement(7, 4, 10, 6, 2), // key: aza5on
      ElIconPathElement('M2 14h20'), // key: myj16y
      ElIconPathElement('M2 4h20'), // key: mda7wb
    ],
  );

  /// `align-vertical-justify-center.mjs`
  static const ElLucideGlyph alignVerticalJustifyCenter = ElLucideGlyph(
    'align-vertical-justify-center',
    <ElIconElement>[
      ElIconRectElement(5, 16, 14, 6, 2), // key: 1i8z2d
      ElIconRectElement(7, 2, 10, 6, 2), // key: ypihtt
      ElIconPathElement('M2 12h20'), // key: 9i4pu4
    ],
  );

  /// `align-vertical-justify-end.mjs`
  static const ElLucideGlyph alignVerticalJustifyEnd = ElLucideGlyph(
    'align-vertical-justify-end',
    <ElIconElement>[
      ElIconRectElement(5, 12, 14, 6, 2), // key: 4l4tp2
      ElIconRectElement(7, 2, 10, 6, 2), // key: ypihtt
      ElIconPathElement('M2 22h20'), // key: 272qi7
    ],
  );

  /// `align-vertical-justify-start.mjs`
  static const ElLucideGlyph alignVerticalJustifyStart = ElLucideGlyph(
    'align-vertical-justify-start',
    <ElIconElement>[
      ElIconRectElement(5, 16, 14, 6, 2), // key: 1i8z2d
      ElIconRectElement(7, 6, 10, 6, 2), // key: 13squh
      ElIconPathElement('M2 2h20'), // key: 1ennik
    ],
  );

  /// `align-vertical-space-around.mjs`
  static const ElLucideGlyph alignVerticalSpaceAround = ElLucideGlyph(
    'align-vertical-space-around',
    <ElIconElement>[
      ElIconRectElement(7, 9, 10, 6, 2), // key: b1zbii
      ElIconPathElement('M22 20H2'), // key: 1p1f7z
      ElIconPathElement('M22 4H2'), // key: 1b7qnq
    ],
  );

  /// `align-vertical-space-between.mjs`
  static const ElLucideGlyph alignVerticalSpaceBetween = ElLucideGlyph(
    'align-vertical-space-between',
    <ElIconElement>[
      ElIconRectElement(5, 15, 14, 6, 2), // key: 1w91an
      ElIconRectElement(7, 3, 10, 6, 2), // key: 17wqzy
      ElIconPathElement('M2 21h20'), // key: 1nyx9w
      ElIconPathElement('M2 3h20'), // key: 91anmk
    ],
  );

  /// `ambulance.mjs`
  static const ElLucideGlyph
  ambulance = ElLucideGlyph('ambulance', <ElIconElement>[
    ElIconPathElement('M10 10H6'), // key: 1bsnug
    ElIconPathElement(
      'M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2',
    ), // key: wrbu53
    ElIconPathElement(
      'M19 18h2a1 1 0 0 0 1-1v-3.28a1 1 0 0 0-.684-.948l-1.923-.641a1 1 0 0 1-.578-.502l-1.539-3.076A1 1 0 0 0 16.382 8H14',
    ), // key: lrkjwd
    ElIconPathElement('M8 8v4'), // key: 1fwk8c
    ElIconPathElement('M9 18h6'), // key: x1upvd
    ElIconCircleElement(17, 18, 2), // key: 332jqn
    ElIconCircleElement(7, 18, 2), // key: 19iecd
  ]);

  /// `ampersand.mjs`
  static const ElLucideGlyph
  ampersand = ElLucideGlyph('ampersand', <ElIconElement>[
    ElIconPathElement('M16 12h3'), // key: 4uvgyw
    ElIconPathElement(
      'M17.5 12a8 8 0 0 1-8 8A4.5 4.5 0 0 1 5 15.5c0-6 8-4 8-8.5a3 3 0 1 0-6 0c0 3 2.5 8.5 12 13',
    ), // key: nfoe1t
  ]);

  /// `ampersands.mjs`
  static const ElLucideGlyph
  ampersands = ElLucideGlyph('ampersands', <ElIconElement>[
    ElIconPathElement(
      'M10 17c-5-3-7-7-7-9a2 2 0 0 1 4 0c0 2.5-5 2.5-5 6 0 1.7 1.3 3 3 3 2.8 0 5-2.2 5-5',
    ), // key: 12lh1k
    ElIconPathElement(
      'M22 17c-5-3-7-7-7-9a2 2 0 0 1 4 0c0 2.5-5 2.5-5 6 0 1.7 1.3 3 3 3 2.8 0 5-2.2 5-5',
    ), // key: 173c68
  ]);

  /// `amphora.mjs`
  static const ElLucideGlyph amphora = ElLucideGlyph('amphora', <ElIconElement>[
    ElIconPathElement(
      'M10 2v5.632c0 .424-.272.795-.653.982A6 6 0 0 0 6 14c.006 4 3 7 5 8',
    ), // key: 1h8rid
    ElIconPathElement('M10 5H8a2 2 0 0 0 0 4h.68'), // key: 3ezsi6
    ElIconPathElement(
      'M14 2v5.632c0 .424.272.795.652.982A6 6 0 0 1 18 14c0 4-3 7-5 8',
    ), // key: yt6q09
    ElIconPathElement('M14 5h2a2 2 0 0 1 0 4h-.68'), // key: 8f95yk
    ElIconPathElement('M18 22H6'), // key: mg6kv4
    ElIconPathElement('M9 2h6'), // key: 1jrp98
  ]);

  /// `anchor.mjs`
  static const ElLucideGlyph anchor = ElLucideGlyph('anchor', <ElIconElement>[
    ElIconPathElement('M12 6v16'), // key: nqf5sj
    ElIconPathElement('m19 13 2-1a9 9 0 0 1-18 0l2 1'), // key: y7qv08
    ElIconPathElement('M9 11h6'), // key: 1fldmi
    ElIconCircleElement(12, 4, 2), // key: muu5ef
  ]);

  /// `angry.mjs`
  static const ElLucideGlyph angry = ElLucideGlyph('angry', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement('M16 16s-1.5-2-4-2-4 2-4 2'), // key: epbg0q
    ElIconPathElement('M7.5 8 10 9'), // key: olxxln
    ElIconPathElement('m14 9 2.5-1'), // key: 1j6cij
    ElIconPathElement('M9 10h.01'), // key: qbtxuw
    ElIconPathElement('M15 10h.01'), // key: 1qmjsl
  ]);

  /// `annoyed.mjs`
  static const ElLucideGlyph annoyed = ElLucideGlyph('annoyed', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement('M8 15h8'), // key: 45n4r
    ElIconPathElement('M8 9h2'), // key: 1g203m
    ElIconPathElement('M14 9h2'), // key: 116p9w
  ]);

  /// `antenna.mjs`
  static const ElLucideGlyph antenna = ElLucideGlyph('antenna', <ElIconElement>[
    ElIconPathElement('M2 12 7 2'), // key: 117k30
    ElIconPathElement('m7 12 5-10'), // key: 1tvx22
    ElIconPathElement('m12 12 5-10'), // key: ev1o1a
    ElIconPathElement('m17 12 5-10'), // key: 1e4ti3
    ElIconPathElement('M4.5 7h15'), // key: vlsxkz
    ElIconPathElement('M12 16v6'), // key: c8a4gj
  ]);

  /// `anvil.mjs`
  static const ElLucideGlyph anvil = ElLucideGlyph('anvil', <ElIconElement>[
    ElIconPathElement('M7 10H6a4 4 0 0 1-4-4 1 1 0 0 1 1-1h4'), // key: 1hjpb6
    ElIconPathElement(
      'M7 5a1 1 0 0 1 1-1h13a1 1 0 0 1 1 1 7 7 0 0 1-7 7H8a1 1 0 0 1-1-1z',
    ), // key: 1qn45f
    ElIconPathElement('M9 12v5'), // key: 3anwtq
    ElIconPathElement('M15 12v5'), // key: 5xh3zn
    ElIconPathElement(
      'M5 20a3 3 0 0 1 3-3h8a3 3 0 0 1 3 3 1 1 0 0 1-1 1H6a1 1 0 0 1-1-1',
    ), // key: 1fi4x8
  ]);

  /// `aperture.mjs`
  static const ElLucideGlyph aperture = ElLucideGlyph(
    'aperture',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('m14.31 8 5.74 9.94'), // key: 1y6ab4
      ElIconPathElement('M9.69 8h11.48'), // key: 1wxppr
      ElIconPathElement('m7.38 12 5.74-9.94'), // key: 1grp0k
      ElIconPathElement('M9.69 16 3.95 6.06'), // key: libnyf
      ElIconPathElement('M14.31 16H2.83'), // key: x5fava
      ElIconPathElement('m16.62 12-5.74 9.94'), // key: 1vwawt
    ],
  );

  /// `app-window-mac.mjs`
  static const ElLucideGlyph appWindowMac = ElLucideGlyph(
    'app-window-mac',
    <ElIconElement>[
      ElIconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
      ElIconPathElement('M6 8h.01'), // key: x9i8wu
      ElIconPathElement('M10 8h.01'), // key: 1r9ogq
      ElIconPathElement('M14 8h.01'), // key: 1primd
    ],
  );

  /// `app-window.mjs`
  static const ElLucideGlyph appWindow = ElLucideGlyph(
    'app-window',
    <ElIconElement>[
      ElIconRectElement(2, 4, 20, 16, 2), // key: izxlao
      ElIconPathElement('M10 4v4'), // key: pp8u80
      ElIconPathElement('M2 8h20'), // key: d11cs7
      ElIconPathElement('M6 4v4'), // key: 1svtjw
    ],
  );

  /// `apple.mjs`
  static const ElLucideGlyph apple = ElLucideGlyph('apple', <ElIconElement>[
    ElIconPathElement('M12 6.528V3a1 1 0 0 1 1-1h0'), // key: 11qiee
    ElIconPathElement(
      'M18.237 21A15 15 0 0 0 22 11a6 6 0 0 0-10-4.472A6 6 0 0 0 2 11a15.1 15.1 0 0 0 3.763 10 3 3 0 0 0 3.648.648 5.5 5.5 0 0 1 5.178 0A3 3 0 0 0 18.237 21',
    ), // key: 110c12
  ]);

  /// `archive-restore.mjs`
  static const ElLucideGlyph archiveRestore = ElLucideGlyph(
    'archive-restore',
    <ElIconElement>[
      ElIconRectElement(2, 3, 20, 5, 1), // key: 1wp1u1
      ElIconPathElement('M4 8v11a2 2 0 0 0 2 2h2'), // key: tvwodi
      ElIconPathElement('M20 8v11a2 2 0 0 1-2 2h-2'), // key: 1gkqxj
      ElIconPathElement('m9 15 3-3 3 3'), // key: 1pd0qc
      ElIconPathElement('M12 12v9'), // key: 192myk
    ],
  );

  /// `archive-x.mjs`
  static const ElLucideGlyph archiveX = ElLucideGlyph(
    'archive-x',
    <ElIconElement>[
      ElIconRectElement(2, 3, 20, 5, 1), // key: 1wp1u1
      ElIconPathElement(
        'M4 8v11a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8',
      ), // key: 1s80jp
      ElIconPathElement('m9.5 17 5-5'), // key: nakeu6
      ElIconPathElement('m9.5 12 5 5'), // key: 1hccrj
    ],
  );

  /// `archive.mjs`
  static const ElLucideGlyph archive = ElLucideGlyph('archive', <ElIconElement>[
    ElIconRectElement(2, 3, 20, 5, 1), // key: 1wp1u1
    ElIconPathElement(
      'M4 8v11a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8',
    ), // key: 1s80jp
    ElIconPathElement('M10 12h4'), // key: a56b0p
  ]);

  /// `armchair.mjs`
  static const ElLucideGlyph
  armchair = ElLucideGlyph('armchair', <ElIconElement>[
    ElIconPathElement('M19 9V6a2 2 0 0 0-2-2H7a2 2 0 0 0-2 2v3'), // key: irtipd
    ElIconPathElement(
      'M3 16a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-5a2 2 0 0 0-4 0v1.5a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5V11a2 2 0 0 0-4 0z',
    ), // key: 1qyhux
    ElIconPathElement('M5 18v2'), // key: ppbyun
    ElIconPathElement('M19 18v2'), // key: gy7782
  ]);

  /// `arrow-big-down-dash.mjs`
  static const ElLucideGlyph
  arrowBigDownDash = ElLucideGlyph('arrow-big-down-dash', <ElIconElement>[
    ElIconPathElement(
      'M14 8a1 1 0 0 1 1 1v2a1 1 0 0 0 1 1h3.293a.707.707 0 0 1 .5 1.207l-6.939 6.939a1.207 1.207 0 0 1-1.708 0l-6.94-6.94a.707.707 0 0 1 .5-1.206H8a1 1 0 0 0 1-1V9a1 1 0 0 1 1-1z',
    ), // key: 1b91ra
    ElIconPathElement('M9 4h6'), // key: 10am2s
  ]);

  /// `arrow-big-down.mjs`
  static const ElLucideGlyph
  arrowBigDown = ElLucideGlyph('arrow-big-down', <ElIconElement>[
    ElIconPathElement(
      'M9 5a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v6a1 1 0 0 0 1 1h3.293a.707.707 0 0 1 .5 1.207l-7.086 7.086a1 1 0 0 1-1.414 0l-7.086-7.086a.707.707 0 0 1 .5-1.207H8a1 1 0 0 0 1-1z',
    ), // key: 1o3tkq
  ]);

  /// `arrow-big-left-dash.mjs`
  static const ElLucideGlyph
  arrowBigLeftDash = ElLucideGlyph('arrow-big-left-dash', <ElIconElement>[
    ElIconPathElement(
      'M13 9a1 1 0 0 1-1-1V4.707a.707.707 0 0 0-1.207-.5l-6.94 6.94a1.207 1.207 0 0 0 0 1.707l6.94 6.94a.707.707 0 0 0 1.207-.5V16a1 1 0 0 1 1-1h2a1 1 0 0 0 1-1v-4a1 1 0 0 0-1-1z',
    ), // key: 17jy80
    ElIconPathElement('M20 9v6'), // key: 14roy0
  ]);

  /// `arrow-big-left.mjs`
  static const ElLucideGlyph
  arrowBigLeft = ElLucideGlyph('arrow-big-left', <ElIconElement>[
    ElIconPathElement(
      'M10.793 19.793a.707.707 0 0 0 1.207-.5V16a1 1 0 0 1 1-1h6a1 1 0 0 0 1-1v-4a1 1 0 0 0-1-1h-6a1 1 0 0 1-1-1V4.707a.707.707 0 0 0-1.207-.5l-6.94 6.94a1.207 1.207 0 0 0 0 1.707z',
    ), // key: qbhtmx
  ]);

  /// `arrow-big-right-dash.mjs`
  static const ElLucideGlyph
  arrowBigRightDash = ElLucideGlyph('arrow-big-right-dash', <ElIconElement>[
    ElIconPathElement(
      'M11 9a1 1 0 0 0 1-1V4.707a.707.707 0 0 1 1.207-.5l6.94 6.94a1.207 1.207 0 0 1 0 1.707l-6.94 6.94a.707.707 0 0 1-1.207-.5V16a1 1 0 0 0-1-1H9a1 1 0 0 1-1-1v-4a1 1 0 0 1 1-1z',
    ), // key: 9idyso
    ElIconPathElement('M4 9v6'), // key: bns7oa
  ]);

  /// `arrow-big-right.mjs`
  static const ElLucideGlyph
  arrowBigRight = ElLucideGlyph('arrow-big-right', <ElIconElement>[
    ElIconPathElement(
      'M13.207 19.793a.707.707 0 0 1-1.207-.5V16a1 1 0 0 0-1-1H5a1 1 0 0 1-1-1v-4a1 1 0 0 1 1-1h6a1 1 0 0 0 1-1V4.707a.707.707 0 0 1 1.207-.5l6.94 6.94a1.207 1.207 0 0 1 0 1.707z',
    ), // key: zee3eo
  ]);

  /// `arrow-big-up-dash.mjs`
  static const ElLucideGlyph
  arrowBigUpDash = ElLucideGlyph('arrow-big-up-dash', <ElIconElement>[
    ElIconPathElement(
      'M14 16a1 1 0 0 0 1-1v-2a1 1 0 0 1 1-1h3.293a.707.707 0 0 0 .5-1.207l-6.939-6.939a1.207 1.207 0 0 0-1.708 0l-6.94 6.94a.707.707 0 0 0 .5 1.206H8a1 1 0 0 1 1 1v2a1 1 0 0 0 1 1z',
    ), // key: q57loy
    ElIconPathElement('M9 20h6'), // key: s66wpe
  ]);

  /// `arrow-big-up.mjs`
  static const ElLucideGlyph
  arrowBigUp = ElLucideGlyph('arrow-big-up', <ElIconElement>[
    ElIconPathElement(
      'M9 19a1 1 0 0 0 1 1h4a1 1 0 0 0 1-1v-6a1 1 0 0 1 1-1h3.293a.707.707 0 0 0 .5-1.207l-7.086-7.086a1 1 0 0 0-1.414 0l-7.086 7.086a.707.707 0 0 0 .5 1.207H8a1 1 0 0 1 1 1z',
    ), // key: 106j91
  ]);

  /// `arrow-down-0-1.mjs`
  static const ElLucideGlyph arrowDown01 = ElLucideGlyph(
    'arrow-down-0-1',
    <ElIconElement>[
      ElIconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
      ElIconPathElement('M7 20V4'), // key: 1yoxec
      ElIconRectElement(15, 4, 4, 6, 2, ry: 2), // key: 1bwicg; rx absent (= ry)
      ElIconPathElement('M17 20v-6h-2'), // key: 1qp1so
      ElIconPathElement('M15 20h4'), // key: 1j968p
    ],
  );

  /// `arrow-down-1-0.mjs`
  static const ElLucideGlyph
  arrowDown10 = ElLucideGlyph('arrow-down-1-0', <ElIconElement>[
    ElIconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
    ElIconPathElement('M7 20V4'), // key: 1yoxec
    ElIconPathElement('M17 10V4h-2'), // key: zcsr5x
    ElIconPathElement('M15 10h4'), // key: id2lce
    ElIconRectElement(15, 14, 4, 6, 2, ry: 2), // key: 33xykx; rx absent (= ry)
  ]);

  /// `arrow-down-a-z.mjs`
  static const ElLucideGlyph arrowDownAZ = ElLucideGlyph(
    'arrow-down-a-z',
    <ElIconElement>[
      ElIconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
      ElIconPathElement('M7 20V4'), // key: 1yoxec
      ElIconPathElement('M20 8h-5'), // key: 1vsyxs
      ElIconPathElement('M15 10V6.5a2.5 2.5 0 0 1 5 0V10'), // key: ag13bf
      ElIconPathElement('M15 14h5l-5 6h5'), // key: ur5jdg
    ],
  );

  /// `arrow-down-from-line.mjs`
  static const ElLucideGlyph arrowDownFromLine = ElLucideGlyph(
    'arrow-down-from-line',
    <ElIconElement>[
      ElIconPathElement('M19 3H5'), // key: 1236rx
      ElIconPathElement('M12 21V7'), // key: gj6g52
      ElIconPathElement('m6 15 6 6 6-6'), // key: h15q88
    ],
  );

  /// `arrow-down-left.mjs`
  static const ElLucideGlyph arrowDownLeft = ElLucideGlyph(
    'arrow-down-left',
    <ElIconElement>[
      ElIconPathElement('M17 7 7 17'), // key: 15tmo1
      ElIconPathElement('M17 17H7V7'), // key: 1org7z
    ],
  );

  /// `arrow-down-narrow-wide.mjs`
  static const ElLucideGlyph arrowDownNarrowWide = ElLucideGlyph(
    'arrow-down-narrow-wide',
    <ElIconElement>[
      ElIconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
      ElIconPathElement('M7 20V4'), // key: 1yoxec
      ElIconPathElement('M11 4h4'), // key: 6d7r33
      ElIconPathElement('M11 8h7'), // key: djye34
      ElIconPathElement('M11 12h10'), // key: 1438ji
    ],
  );

  /// `arrow-down-right.mjs`
  static const ElLucideGlyph arrowDownRight = ElLucideGlyph(
    'arrow-down-right',
    <ElIconElement>[
      ElIconPathElement('m7 7 10 10'), // key: 1fmybs
      ElIconPathElement('M17 7v10H7'), // key: 6fjiku
    ],
  );

  /// `arrow-down-to-dot.mjs`
  static const ElLucideGlyph arrowDownToDot = ElLucideGlyph(
    'arrow-down-to-dot',
    <ElIconElement>[
      ElIconPathElement('M12 2v14'), // key: jyx4ut
      ElIconPathElement('m19 9-7 7-7-7'), // key: 1oe3oy
      ElIconCircleElement(12, 21, 1), // key: o0uj5v
    ],
  );

  /// `arrow-down-to-line.mjs`
  static const ElLucideGlyph arrowDownToLine = ElLucideGlyph(
    'arrow-down-to-line',
    <ElIconElement>[
      ElIconPathElement('M12 17V3'), // key: 1cwfxf
      ElIconPathElement('m6 11 6 6 6-6'), // key: 12ii2o
      ElIconPathElement('M19 21H5'), // key: 150jfl
    ],
  );

  /// `arrow-down-up.mjs`
  static const ElLucideGlyph arrowDownUp = ElLucideGlyph(
    'arrow-down-up',
    <ElIconElement>[
      ElIconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
      ElIconPathElement('M7 20V4'), // key: 1yoxec
      ElIconPathElement('m21 8-4-4-4 4'), // key: 1c9v7m
      ElIconPathElement('M17 4v16'), // key: 7dpous
    ],
  );

  /// `arrow-down-wide-narrow.mjs`
  static const ElLucideGlyph arrowDownWideNarrow = ElLucideGlyph(
    'arrow-down-wide-narrow',
    <ElIconElement>[
      ElIconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
      ElIconPathElement('M7 20V4'), // key: 1yoxec
      ElIconPathElement('M11 4h10'), // key: 1w87gc
      ElIconPathElement('M11 8h7'), // key: djye34
      ElIconPathElement('M11 12h4'), // key: q8tih4
    ],
  );

  /// `arrow-down-z-a.mjs`
  static const ElLucideGlyph arrowDownZA = ElLucideGlyph(
    'arrow-down-z-a',
    <ElIconElement>[
      ElIconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
      ElIconPathElement('M7 4v16'), // key: 1glfcx
      ElIconPathElement('M15 4h5l-5 6h5'), // key: 8asdl1
      ElIconPathElement('M15 20v-3.5a2.5 2.5 0 0 1 5 0V20'), // key: r6l5cz
      ElIconPathElement('M20 18h-5'), // key: 18j1r2
    ],
  );

  /// `arrow-down.mjs`
  static const ElLucideGlyph arrowDown = ElLucideGlyph(
    'arrow-down',
    <ElIconElement>[
      ElIconPathElement('M12 5v14'), // key: s699le
      ElIconPathElement('m19 12-7 7-7-7'), // key: 1idqje
    ],
  );

  /// `arrow-left-from-line.mjs`
  static const ElLucideGlyph arrowLeftFromLine = ElLucideGlyph(
    'arrow-left-from-line',
    <ElIconElement>[
      ElIconPathElement('m9 6-6 6 6 6'), // key: 7v63n9
      ElIconPathElement('M3 12h14'), // key: 13k4hi
      ElIconPathElement('M21 19V5'), // key: b4bplr
    ],
  );

  /// `arrow-left-right.mjs`
  static const ElLucideGlyph arrowLeftRight = ElLucideGlyph(
    'arrow-left-right',
    <ElIconElement>[
      ElIconPathElement('M8 3 4 7l4 4'), // key: 9rb6wj
      ElIconPathElement('M4 7h16'), // key: 6tx8e3
      ElIconPathElement('m16 21 4-4-4-4'), // key: siv7j2
      ElIconPathElement('M20 17H4'), // key: h6l3hr
    ],
  );

  /// `arrow-left-to-line.mjs`
  static const ElLucideGlyph arrowLeftToLine = ElLucideGlyph(
    'arrow-left-to-line',
    <ElIconElement>[
      ElIconPathElement('M3 19V5'), // key: rwsyhb
      ElIconPathElement('m13 6-6 6 6 6'), // key: 1yhaz7
      ElIconPathElement('M7 12h14'), // key: uoisry
    ],
  );

  /// `arrow-left.mjs`
  static const ElLucideGlyph arrowLeft = ElLucideGlyph(
    'arrow-left',
    <ElIconElement>[
      ElIconPathElement('m12 19-7-7 7-7'), // key: 1l729n
      ElIconPathElement('M19 12H5'), // key: x3x0zl
    ],
  );

  /// `arrow-right-from-line.mjs`
  static const ElLucideGlyph arrowRightFromLine = ElLucideGlyph(
    'arrow-right-from-line',
    <ElIconElement>[
      ElIconPathElement('M3 5v14'), // key: 1nt18q
      ElIconPathElement('M21 12H7'), // key: 13ipq5
      ElIconPathElement('m15 18 6-6-6-6'), // key: 6tx3qv
    ],
  );

  /// `arrow-right-left.mjs`
  static const ElLucideGlyph arrowRightLeft = ElLucideGlyph(
    'arrow-right-left',
    <ElIconElement>[
      ElIconPathElement('m16 3 4 4-4 4'), // key: 1x1c3m
      ElIconPathElement('M20 7H4'), // key: zbl0bi
      ElIconPathElement('m8 21-4-4 4-4'), // key: h9nckh
      ElIconPathElement('M4 17h16'), // key: g4d7ey
    ],
  );

  /// `arrow-right-to-line.mjs`
  static const ElLucideGlyph arrowRightToLine = ElLucideGlyph(
    'arrow-right-to-line',
    <ElIconElement>[
      ElIconPathElement('M17 12H3'), // key: 8awo09
      ElIconPathElement('m11 18 6-6-6-6'), // key: 8c2y43
      ElIconPathElement('M21 5v14'), // key: nzette
    ],
  );

  /// `arrow-right.mjs`
  static const ElLucideGlyph arrowRight = ElLucideGlyph(
    'arrow-right',
    <ElIconElement>[
      ElIconPathElement('M5 12h14'), // key: 1ays0h
      ElIconPathElement('m12 5 7 7-7 7'), // key: xquz4c
    ],
  );

  /// `arrow-up-0-1.mjs`
  static const ElLucideGlyph arrowUp01 = ElLucideGlyph(
    'arrow-up-0-1',
    <ElIconElement>[
      ElIconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
      ElIconPathElement('M7 4v16'), // key: 1glfcx
      ElIconRectElement(15, 4, 4, 6, 2, ry: 2), // key: 1bwicg; rx absent (= ry)
      ElIconPathElement('M17 20v-6h-2'), // key: 1qp1so
      ElIconPathElement('M15 20h4'), // key: 1j968p
    ],
  );

  /// `arrow-up-1-0.mjs`
  static const ElLucideGlyph
  arrowUp10 = ElLucideGlyph('arrow-up-1-0', <ElIconElement>[
    ElIconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
    ElIconPathElement('M7 4v16'), // key: 1glfcx
    ElIconPathElement('M17 10V4h-2'), // key: zcsr5x
    ElIconPathElement('M15 10h4'), // key: id2lce
    ElIconRectElement(15, 14, 4, 6, 2, ry: 2), // key: 33xykx; rx absent (= ry)
  ]);

  /// `arrow-up-a-z.mjs`
  static const ElLucideGlyph arrowUpAZ = ElLucideGlyph(
    'arrow-up-a-z',
    <ElIconElement>[
      ElIconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
      ElIconPathElement('M7 4v16'), // key: 1glfcx
      ElIconPathElement('M20 8h-5'), // key: 1vsyxs
      ElIconPathElement('M15 10V6.5a2.5 2.5 0 0 1 5 0V10'), // key: ag13bf
      ElIconPathElement('M15 14h5l-5 6h5'), // key: ur5jdg
    ],
  );

  /// `arrow-up-down.mjs`
  static const ElLucideGlyph arrowUpDown = ElLucideGlyph(
    'arrow-up-down',
    <ElIconElement>[
      ElIconPathElement('m21 16-4 4-4-4'), // key: f6ql7i
      ElIconPathElement('M17 20V4'), // key: 1ejh1v
      ElIconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
      ElIconPathElement('M7 4v16'), // key: 1glfcx
    ],
  );

  /// `arrow-up-from-dot.mjs`
  static const ElLucideGlyph arrowUpFromDot = ElLucideGlyph(
    'arrow-up-from-dot',
    <ElIconElement>[
      ElIconPathElement('m5 9 7-7 7 7'), // key: 1hw5ic
      ElIconPathElement('M12 16V2'), // key: ywoabb
      ElIconCircleElement(12, 21, 1), // key: o0uj5v
    ],
  );

  /// `arrow-up-from-line.mjs`
  static const ElLucideGlyph arrowUpFromLine = ElLucideGlyph(
    'arrow-up-from-line',
    <ElIconElement>[
      ElIconPathElement('m18 9-6-6-6 6'), // key: kcunyi
      ElIconPathElement('M12 3v14'), // key: 7cf3v8
      ElIconPathElement('M5 21h14'), // key: 11awu3
    ],
  );

  /// `arrow-up-left.mjs`
  static const ElLucideGlyph arrowUpLeft = ElLucideGlyph(
    'arrow-up-left',
    <ElIconElement>[
      ElIconPathElement('M7 17V7h10'), // key: 11bw93
      ElIconPathElement('M17 17 7 7'), // key: 2786uv
    ],
  );

  /// `arrow-up-narrow-wide.mjs`
  static const ElLucideGlyph arrowUpNarrowWide = ElLucideGlyph(
    'arrow-up-narrow-wide',
    <ElIconElement>[
      ElIconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
      ElIconPathElement('M7 4v16'), // key: 1glfcx
      ElIconPathElement('M11 12h4'), // key: q8tih4
      ElIconPathElement('M11 16h7'), // key: uosisv
      ElIconPathElement('M11 20h10'), // key: jvxblo
    ],
  );

  /// `arrow-up-right.mjs`
  static const ElLucideGlyph arrowUpRight = ElLucideGlyph(
    'arrow-up-right',
    <ElIconElement>[
      ElIconPathElement('M7 7h10v10'), // key: 1tivn9
      ElIconPathElement('M7 17 17 7'), // key: 1vkiza
    ],
  );

  /// `arrow-up-to-line.mjs`
  static const ElLucideGlyph arrowUpToLine = ElLucideGlyph(
    'arrow-up-to-line',
    <ElIconElement>[
      ElIconPathElement('M5 3h14'), // key: 7usisc
      ElIconPathElement('m18 13-6-6-6 6'), // key: 1kf1n9
      ElIconPathElement('M12 7v14'), // key: 1akyts
    ],
  );

  /// `arrow-up-wide-narrow.mjs`
  static const ElLucideGlyph arrowUpWideNarrow = ElLucideGlyph(
    'arrow-up-wide-narrow',
    <ElIconElement>[
      ElIconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
      ElIconPathElement('M7 4v16'), // key: 1glfcx
      ElIconPathElement('M11 12h10'), // key: 1438ji
      ElIconPathElement('M11 16h7'), // key: uosisv
      ElIconPathElement('M11 20h4'), // key: 1krc32
    ],
  );

  /// `arrow-up-z-a.mjs`
  static const ElLucideGlyph arrowUpZA = ElLucideGlyph(
    'arrow-up-z-a',
    <ElIconElement>[
      ElIconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
      ElIconPathElement('M7 4v16'), // key: 1glfcx
      ElIconPathElement('M15 4h5l-5 6h5'), // key: 8asdl1
      ElIconPathElement('M15 20v-3.5a2.5 2.5 0 0 1 5 0V20'), // key: r6l5cz
      ElIconPathElement('M20 18h-5'), // key: 18j1r2
    ],
  );

  /// `arrow-up.mjs`
  static const ElLucideGlyph arrowUp = ElLucideGlyph(
    'arrow-up',
    <ElIconElement>[
      ElIconPathElement('m5 12 7-7 7 7'), // key: hav0vg
      ElIconPathElement('M12 19V5'), // key: x0mq9r
    ],
  );

  /// `arrows-up-from-line.mjs`
  static const ElLucideGlyph arrowsUpFromLine = ElLucideGlyph(
    'arrows-up-from-line',
    <ElIconElement>[
      ElIconPathElement('m4 6 3-3 3 3'), // key: 9aidw8
      ElIconPathElement('M7 17V3'), // key: 19qxw1
      ElIconPathElement('m14 6 3-3 3 3'), // key: 6iy689
      ElIconPathElement('M17 17V3'), // key: o0fmgi
      ElIconPathElement('M4 21h16'), // key: 1h09gz
    ],
  );

  /// `asterisk.mjs`
  static const ElLucideGlyph asterisk = ElLucideGlyph(
    'asterisk',
    <ElIconElement>[
      ElIconPathElement('M12 6v12'), // key: 1vza4d
      ElIconPathElement('M17.196 9 6.804 15'), // key: 1ah31z
      ElIconPathElement('m6.804 9 10.392 6'), // key: 1b6pxd
    ],
  );

  /// `astroid.mjs`
  static const ElLucideGlyph astroid = ElLucideGlyph('astroid', <ElIconElement>[
    ElIconPathElement(
      'M12.983 21.186a1 1 0 0 1-1.966 0 10 10 0 0 0-8.203-8.203 1 1 0 0 1 0-1.966 10 10 0 0 0 8.203-8.203 1 1 0 0 1 1.966 0 10 10 0 0 0 8.203 8.203 1 1 0 0 1 0 1.966 10 10 0 0 0-8.203 8.203',
    ), // key: 1tipus
  ]);

  /// `at-sign.mjs`
  static const ElLucideGlyph atSign = ElLucideGlyph('at-sign', <ElIconElement>[
    ElIconCircleElement(12, 12, 4), // key: 4exip2
    ElIconPathElement(
      'M16 8v5a3 3 0 0 0 6 0v-1a10 10 0 1 0-4 8',
    ), // key: 7n84p3
  ]);

  /// `atom.mjs`
  static const ElLucideGlyph atom = ElLucideGlyph('atom', <ElIconElement>[
    ElIconCircleElement(12, 12, 1), // key: 41hilf
    ElIconPathElement(
      'M20.2 20.2c2.04-2.03.02-7.36-4.5-11.9-4.54-4.52-9.87-6.54-11.9-4.5-2.04 2.03-.02 7.36 4.5 11.9 4.54 4.52 9.87 6.54 11.9 4.5Z',
    ), // key: 1l2ple
    ElIconPathElement(
      'M15.7 15.7c4.52-4.54 6.54-9.87 4.5-11.9-2.03-2.04-7.36-.02-11.9 4.5-4.52 4.54-6.54 9.87-4.5 11.9 2.03 2.04 7.36.02 11.9-4.5Z',
    ), // key: 1wam0m
  ]);

  /// `audio-lines.mjs`
  static const ElLucideGlyph audioLines = ElLucideGlyph(
    'audio-lines',
    <ElIconElement>[
      ElIconPathElement('M2 10v3'), // key: 1fnikh
      ElIconPathElement('M6 6v11'), // key: 11sgs0
      ElIconPathElement('M10 3v18'), // key: yhl04a
      ElIconPathElement('M14 8v7'), // key: 3a1oy3
      ElIconPathElement('M18 5v13'), // key: 123xd1
      ElIconPathElement('M22 10v3'), // key: 154ddg
    ],
  );

  /// `audio-waveform.mjs`
  static const ElLucideGlyph
  audioWaveform = ElLucideGlyph('audio-waveform', <ElIconElement>[
    ElIconPathElement(
      'M2 13a2 2 0 0 0 2-2V7a2 2 0 0 1 4 0v13a2 2 0 0 0 4 0V4a2 2 0 0 1 4 0v13a2 2 0 0 0 4 0v-4a2 2 0 0 1 2-2',
    ), // key: 57tc96
  ]);

  /// `award.mjs`
  static const ElLucideGlyph award = ElLucideGlyph('award', <ElIconElement>[
    ElIconPathElement(
      'm15.477 12.89 1.515 8.526a.5.5 0 0 1-.81.47l-3.58-2.687a1 1 0 0 0-1.197 0l-3.586 2.686a.5.5 0 0 1-.81-.469l1.514-8.526',
    ), // key: 1yiouv
    ElIconCircleElement(12, 8, 6), // key: 1vp47v
  ]);

  /// `axe.mjs`
  static const ElLucideGlyph axe = ElLucideGlyph('axe', <ElIconElement>[
    ElIconPathElement(
      'm14 12-8.381 8.38a1 1 0 0 1-3.001-3L11 9',
    ), // key: 5z9253
    ElIconPathElement(
      'M15 15.5a.5.5 0 0 0 .5.5A6.5 6.5 0 0 0 22 9.5a.5.5 0 0 0-.5-.5h-1.672a2 2 0 0 1-1.414-.586l-5.062-5.062a1.205 1.205 0 0 0-1.704 0L9.352 5.648a1.205 1.205 0 0 0 0 1.704l5.062 5.062A2 2 0 0 1 15 13.828z',
    ), // key: 19zklq
  ]);

  /// `axis-3d.mjs`
  static const ElLucideGlyph axis3d = ElLucideGlyph('axis-3d', <ElIconElement>[
    ElIconPathElement('M13.5 10.5 15 9'), // key: 1nsxvm
    ElIconPathElement('M4 4v15a1 1 0 0 0 1 1h15'), // key: 1w6lkd
    ElIconPathElement('M4.293 19.707 6 18'), // key: 3g1p8c
    ElIconPathElement('m9 15 1.5-1.5'), // key: 1xfbes
  ]);

  /// `baby.mjs`
  static const ElLucideGlyph baby = ElLucideGlyph('baby', <ElIconElement>[
    ElIconPathElement('M10 16c.5.3 1.2.5 2 .5s1.5-.2 2-.5'), // key: 1u7htd
    ElIconPathElement('M15 12h.01'), // key: 1k8ypt
    ElIconPathElement(
      'M19.38 6.813A9 9 0 0 1 20.8 10.2a2 2 0 0 1 0 3.6 9 9 0 0 1-17.6 0 2 2 0 0 1 0-3.6A9 9 0 0 1 12 3c2 0 3.5 1.1 3.5 2.5s-.9 2.5-2 2.5c-.8 0-1.5-.4-1.5-1',
    ), // key: 11xh7x
    ElIconPathElement('M9 12h.01'), // key: 157uk2
  ]);

  /// `backpack.mjs`
  static const ElLucideGlyph
  backpack = ElLucideGlyph('backpack', <ElIconElement>[
    ElIconPathElement(
      'M4 10a4 4 0 0 1 4-4h8a4 4 0 0 1 4 4v10a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2z',
    ), // key: 1ol0lm
    ElIconPathElement('M8 10h8'), // key: c7uz4u
    ElIconPathElement('M8 18h8'), // key: 1no2b1
    ElIconPathElement(
      'M8 22v-6a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v6',
    ), // key: 1fr6do
    ElIconPathElement('M9 6V4a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2'), // key: donm21
  ]);

  /// `badge-alert.mjs`
  static const ElLucideGlyph
  badgeAlert = ElLucideGlyph('badge-alert', <ElIconElement>[
    ElIconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    ElIconLineElement(12, 8, 12, 12), // key: 1pkeuh
    ElIconLineElement(12, 16, 12.01, 16), // key: 4dfq90
  ]);

  /// `badge-cent.mjs`
  static const ElLucideGlyph
  badgeCent = ElLucideGlyph('badge-cent', <ElIconElement>[
    ElIconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    ElIconPathElement('M12 7v10'), // key: jspqdw
    ElIconPathElement('M15.4 10a4 4 0 1 0 0 4'), // key: 2eqtx8
  ]);

  /// `badge-check.mjs`
  static const ElLucideGlyph
  badgeCheck = ElLucideGlyph('badge-check', <ElIconElement>[
    ElIconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    ElIconPathElement('m9 12 2 2 4-4'), // key: dzmm74
  ]);

  /// `badge-dollar-sign.mjs`
  static const ElLucideGlyph
  badgeDollarSign = ElLucideGlyph('badge-dollar-sign', <ElIconElement>[
    ElIconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    ElIconPathElement(
      'M16 8h-6a2 2 0 1 0 0 4h4a2 2 0 1 1 0 4H8',
    ), // key: 1h4pet
    ElIconPathElement('M12 18V6'), // key: zqpxq5
  ]);

  /// `badge-euro.mjs`
  static const ElLucideGlyph
  badgeEuro = ElLucideGlyph('badge-euro', <ElIconElement>[
    ElIconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    ElIconPathElement('M7 12h5'), // key: gblrwe
    ElIconPathElement('M15 9.4a4 4 0 1 0 0 5.2'), // key: 1makmb
  ]);

  /// `badge-indian-rupee.mjs`
  static const ElLucideGlyph
  badgeIndianRupee = ElLucideGlyph('badge-indian-rupee', <ElIconElement>[
    ElIconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    ElIconPathElement('M8 8h8'), // key: 1bis0t
    ElIconPathElement('M8 12h8'), // key: 1wcyev
    ElIconPathElement('m13 17-5-1h1a4 4 0 0 0 0-8'), // key: nu2bwa
  ]);

  /// `badge-info.mjs`
  static const ElLucideGlyph
  badgeInfo = ElLucideGlyph('badge-info', <ElIconElement>[
    ElIconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    ElIconLineElement(12, 16, 12, 12), // key: 1y1yb1
    ElIconLineElement(12, 8, 12.01, 8), // key: 110wyk
  ]);

  /// `badge-japanese-yen.mjs`
  static const ElLucideGlyph
  badgeJapaneseYen = ElLucideGlyph('badge-japanese-yen', <ElIconElement>[
    ElIconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    ElIconPathElement('m9 8 3 3v7'), // key: 17yadx
    ElIconPathElement('m12 11 3-3'), // key: p4cfq1
    ElIconPathElement('M9 12h6'), // key: 1c52cq
    ElIconPathElement('M9 16h6'), // key: 8wimt3
  ]);

  /// `badge-minus.mjs`
  static const ElLucideGlyph
  badgeMinus = ElLucideGlyph('badge-minus', <ElIconElement>[
    ElIconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    ElIconLineElement(8, 12, 16, 12), // key: 1jonct
  ]);

  /// `badge-percent.mjs`
  static const ElLucideGlyph
  badgePercent = ElLucideGlyph('badge-percent', <ElIconElement>[
    ElIconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    ElIconPathElement('m15 9-6 6'), // key: 1uzhvr
    ElIconPathElement('M9 9h.01'), // key: 1q5me6
    ElIconPathElement('M15 15h.01'), // key: lqbp3k
  ]);

  /// `badge-plus.mjs`
  static const ElLucideGlyph
  badgePlus = ElLucideGlyph('badge-plus', <ElIconElement>[
    ElIconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    ElIconLineElement(12, 8, 12, 16), // key: 10p56q
    ElIconLineElement(8, 12, 16, 12), // key: 1jonct
  ]);

  /// `badge-pound-sterling.mjs`
  static const ElLucideGlyph
  badgePoundSterling = ElLucideGlyph('badge-pound-sterling', <ElIconElement>[
    ElIconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    ElIconPathElement('M8 12h4'), // key: qz6y1c
    ElIconPathElement('M10 16V9.5a2.5 2.5 0 0 1 5 0'), // key: 3mlbjk
    ElIconPathElement('M8 16h7'), // key: sbedsn
  ]);

  /// `badge-question-mark.mjs`
  static const ElLucideGlyph
  badgeQuestionMark = ElLucideGlyph('badge-question-mark', <ElIconElement>[
    ElIconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    ElIconPathElement('M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3'), // key: 1u773s
    ElIconLineElement(12, 17, 12.01, 17), // key: io3f8k
  ]);

  /// `badge-russian-ruble.mjs`
  static const ElLucideGlyph
  badgeRussianRuble = ElLucideGlyph('badge-russian-ruble', <ElIconElement>[
    ElIconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    ElIconPathElement('M9 16h5'), // key: 1syiyw
    ElIconPathElement('M9 12h5a2 2 0 1 0 0-4h-3v9'), // key: 1ge9c1
  ]);

  /// `badge-swiss-franc.mjs`
  static const ElLucideGlyph
  badgeSwissFranc = ElLucideGlyph('badge-swiss-franc', <ElIconElement>[
    ElIconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    ElIconPathElement('M11 17V8h4'), // key: 1bfq6y
    ElIconPathElement('M11 12h3'), // key: 2eqnfz
    ElIconPathElement('M9 16h4'), // key: 1skf3a
  ]);

  /// `badge-turkish-lira.mjs`
  static const ElLucideGlyph
  badgeTurkishLira = ElLucideGlyph('badge-turkish-lira', <ElIconElement>[
    ElIconPathElement('M11 7v10a5 5 0 0 0 5-5'), // key: 1ja3ih
    ElIconPathElement('m15 8-6 3'), // key: 4x0uwz
    ElIconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76',
    ), // key: 18242g
  ]);

  /// `badge-x.mjs`
  static const ElLucideGlyph badgeX = ElLucideGlyph('badge-x', <ElIconElement>[
    ElIconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
    ElIconLineElement(15, 9, 9, 15), // key: f7djnv
    ElIconLineElement(9, 9, 15, 15), // key: 1shsy8
  ]);

  /// `badge.mjs`
  static const ElLucideGlyph badge = ElLucideGlyph('badge', <ElIconElement>[
    ElIconPathElement(
      'M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z',
    ), // key: 3c2336
  ]);

  /// `baggage-claim.mjs`
  static const ElLucideGlyph
  baggageClaim = ElLucideGlyph('baggage-claim', <ElIconElement>[
    ElIconPathElement('M22 18H6a2 2 0 0 1-2-2V7a2 2 0 0 0-2-2'), // key: 4irg2o
    ElIconPathElement(
      'M17 14V4a2 2 0 0 0-2-2h-1a2 2 0 0 0-2 2v10',
    ), // key: 14fcyx
    ElIconRectElement(8, 6, 13, 8, 1), // key: o6oiis
    ElIconCircleElement(18, 20, 2), // key: t9985n
    ElIconCircleElement(9, 20, 2), // key: e5v82j
  ]);

  /// `balloon.mjs`
  static const ElLucideGlyph balloon = ElLucideGlyph('balloon', <ElIconElement>[
    ElIconPathElement('M12 16v1a2 2 0 0 0 2 2h1a2 2 0 0 1 2 2v1'), // key: 2nz4b
    ElIconPathElement('M12 6a2 2 0 0 1 2 2'), // key: 7y7d82
    ElIconPathElement(
      'M18 8c0 4-3.5 8-6 8s-6-4-6-8a6 6 0 0 1 12 0',
    ), // key: vqb5s3
  ]);

  /// `ban.mjs`
  static const ElLucideGlyph ban = ElLucideGlyph('ban', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement('M4.929 4.929 19.07 19.071'), // key: 196cmz
  ]);

  /// `banana.mjs`
  static const ElLucideGlyph banana = ElLucideGlyph('banana', <ElIconElement>[
    ElIconPathElement('M4 13c3.5-2 8-2 10 2a5.5 5.5 0 0 1 8 5'), // key: 1cscit
    ElIconPathElement(
      'M5.15 17.89c5.52-1.52 8.65-6.89 7-12C11.55 4 11.5 2 13 2c3.22 0 5 5.5 5 8 0 6.5-4.2 12-10.49 12C5.11 22 2 22 2 20c0-1.5 1.14-1.55 3.15-2.11Z',
    ), // key: 1y1nbv
  ]);

  /// `bandage.mjs`
  static const ElLucideGlyph bandage = ElLucideGlyph('bandage', <ElIconElement>[
    ElIconPathElement('M10 10.01h.01'), // key: 1e9xi7
    ElIconPathElement('M10 14.01h.01'), // key: ac23bv
    ElIconPathElement('M14 10.01h.01'), // key: 2wfrvf
    ElIconPathElement('M14 14.01h.01'), // key: 8tw8yn
    ElIconPathElement('M18 6v12'), // key: 1bcixs
    ElIconPathElement('M6 6v12'), // key: vkc79e
    ElIconRectElement(2, 6, 20, 12, 2), // key: 1wpnh2
  ]);

  /// `banknote-arrow-down.mjs`
  static const ElLucideGlyph banknoteArrowDown = ElLucideGlyph(
    'banknote-arrow-down',
    <ElIconElement>[
      ElIconPathElement(
        'M12 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5',
      ), // key: x6cv4u
      ElIconPathElement('m16 19 3 3 3-3'), // key: 1ibux0
      ElIconPathElement('M18 12h.01'), // key: yjnet6
      ElIconPathElement('M19 16v6'), // key: tddt3s
      ElIconPathElement('M6 12h.01'), // key: c2rlol
      ElIconCircleElement(12, 12, 2), // key: 1c9p78
    ],
  );

  /// `banknote-arrow-up.mjs`
  static const ElLucideGlyph banknoteArrowUp = ElLucideGlyph(
    'banknote-arrow-up',
    <ElIconElement>[
      ElIconPathElement(
        'M12 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5',
      ), // key: x6cv4u
      ElIconPathElement('M18 12h.01'), // key: yjnet6
      ElIconPathElement('M19 22v-6'), // key: qhmiwi
      ElIconPathElement('m22 19-3-3-3 3'), // key: rn6bg2
      ElIconPathElement('M6 12h.01'), // key: c2rlol
      ElIconCircleElement(12, 12, 2), // key: 1c9p78
    ],
  );

  /// `banknote-check.mjs`
  static const ElLucideGlyph banknoteCheck = ElLucideGlyph(
    'banknote-check',
    <ElIconElement>[
      ElIconPathElement(
        'M11.748 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v4.875',
      ), // key: t4e5a5
      ElIconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
      ElIconPathElement('M18 12h.01'), // key: yjnet6
      ElIconPathElement('M6 12h.01'), // key: c2rlol
      ElIconCircleElement(12, 12, 2), // key: 1c9p78
    ],
  );

  /// `banknote-x.mjs`
  static const ElLucideGlyph banknoteX = ElLucideGlyph(
    'banknote-x',
    <ElIconElement>[
      ElIconPathElement(
        'M13 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5',
      ), // key: 16nib6
      ElIconPathElement('m17 17 5 5'), // key: p7ous7
      ElIconPathElement('M18 12h.01'), // key: yjnet6
      ElIconPathElement('m22 17-5 5'), // key: gqnmv0
      ElIconPathElement('M6 12h.01'), // key: c2rlol
      ElIconCircleElement(12, 12, 2), // key: 1c9p78
    ],
  );

  /// `banknote.mjs`
  static const ElLucideGlyph banknote = ElLucideGlyph(
    'banknote',
    <ElIconElement>[
      ElIconRectElement(2, 6, 20, 12, 2), // key: 9lu3g6
      ElIconCircleElement(12, 12, 2), // key: 1c9p78
      ElIconPathElement('M6 12h.01M18 12h.01'), // key: 113zkx
    ],
  );

  /// `barcode.mjs`
  static const ElLucideGlyph barcode = ElLucideGlyph('barcode', <ElIconElement>[
    ElIconPathElement('M3 5v14'), // key: 1nt18q
    ElIconPathElement('M8 5v14'), // key: 1ybrkv
    ElIconPathElement('M12 5v14'), // key: s699le
    ElIconPathElement('M17 5v14'), // key: ycjyhj
    ElIconPathElement('M21 5v14'), // key: nzette
  ]);

  /// `barrel.mjs`
  static const ElLucideGlyph barrel = ElLucideGlyph('barrel', <ElIconElement>[
    ElIconPathElement('M10 3a41 41 0 000 18'), // key: 1f9k6x
    ElIconPathElement('M14 3a41 41 0 010 18'), // key: 1qo28r
    ElIconPathElement(
      'M16.997 21a2 2 0 001.68-.92 15.25 15.25 0 000-16.16 2 2 0 00-1.68-.92h-10a2 2 0 00-1.681.92 15.25 15.25 0 000 16.16 2 2 0 001.681.92z',
    ), // key: 1nrwe5
    ElIconPathElement('M3.54 16h16.914'), // key: jntgtt
    ElIconPathElement('M3.54 8h16.914'), // key: 14pf7i
  ]);

  /// `baseline.mjs`
  static const ElLucideGlyph baseline = ElLucideGlyph(
    'baseline',
    <ElIconElement>[
      ElIconPathElement('M4 20h16'), // key: 14thso
      ElIconPathElement('m6 16 6-12 6 12'), // key: 1b4byz
      ElIconPathElement('M8 12h8'), // key: 1wcyev
    ],
  );

  /// `bath.mjs`
  static const ElLucideGlyph bath = ElLucideGlyph('bath', <ElIconElement>[
    ElIconPathElement('M10 4 8 6'), // key: 1rru8s
    ElIconPathElement('M17 19v2'), // key: ts1sot
    ElIconPathElement('M2 12h20'), // key: 9i4pu4
    ElIconPathElement('M7 19v2'), // key: 12npes
    ElIconPathElement(
      'M9 5 7.621 3.621A2.121 2.121 0 0 0 4 5v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-5',
    ), // key: 14ym8i
  ]);

  /// `battery-charging.mjs`
  static const ElLucideGlyph batteryCharging = ElLucideGlyph(
    'battery-charging',
    <ElIconElement>[
      ElIconPathElement('m11 7-3 5h4l-3 5'), // key: b4a64w
      ElIconPathElement(
        'M14.856 6H16a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-2.935',
      ), // key: lre1cr
      ElIconPathElement('M22 14v-4'), // key: 14q9d5
      ElIconPathElement(
        'M5.14 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h2.936',
      ), // key: 13q5k0
    ],
  );

  /// `battery-full.mjs`
  static const ElLucideGlyph batteryFull = ElLucideGlyph(
    'battery-full',
    <ElIconElement>[
      ElIconPathElement('M10 10v4'), // key: 1mb2ec
      ElIconPathElement('M14 10v4'), // key: 1nt88p
      ElIconPathElement('M22 14v-4'), // key: 14q9d5
      ElIconPathElement('M6 10v4'), // key: 1n77qd
      ElIconRectElement(2, 6, 16, 12, 2), // key: 13zb55
    ],
  );

  /// `battery-low.mjs`
  static const ElLucideGlyph batteryLow = ElLucideGlyph(
    'battery-low',
    <ElIconElement>[
      ElIconPathElement('M22 14v-4'), // key: 14q9d5
      ElIconPathElement('M6 14v-4'), // key: 14a6bd
      ElIconRectElement(2, 6, 16, 12, 2), // key: 13zb55
    ],
  );

  /// `battery-medium.mjs`
  static const ElLucideGlyph batteryMedium = ElLucideGlyph(
    'battery-medium',
    <ElIconElement>[
      ElIconPathElement('M10 14v-4'), // key: suye4c
      ElIconPathElement('M22 14v-4'), // key: 14q9d5
      ElIconPathElement('M6 14v-4'), // key: 14a6bd
      ElIconRectElement(2, 6, 16, 12, 2), // key: 13zb55
    ],
  );

  /// `battery-plus.mjs`
  static const ElLucideGlyph batteryPlus = ElLucideGlyph(
    'battery-plus',
    <ElIconElement>[
      ElIconPathElement('M10 9v6'), // key: 17i7lo
      ElIconPathElement(
        'M12.543 6H16a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-3.605',
      ), // key: o09yah
      ElIconPathElement('M22 14v-4'), // key: 14q9d5
      ElIconPathElement('M7 12h6'), // key: iekk3h
      ElIconPathElement(
        'M7.606 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h3.606',
      ), // key: xyqvf1
    ],
  );

  /// `battery-warning.mjs`
  static const ElLucideGlyph
  batteryWarning = ElLucideGlyph('battery-warning', <ElIconElement>[
    ElIconPathElement('M10 17h.01'), // key: nbq80n
    ElIconPathElement('M10 7v6'), // key: nne03l
    ElIconPathElement(
      'M14 6h2a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-2',
    ), // key: 1m83kb
    ElIconPathElement('M22 14v-4'), // key: 14q9d5
    ElIconPathElement('M6 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h2'), // key: h8lgfh
  ]);

  /// `battery.mjs`
  static const ElLucideGlyph battery = ElLucideGlyph('battery', <ElIconElement>[
    ElIconPathElement('M 22 14 L 22 10'), // key: nqc4tb
    ElIconRectElement(2, 6, 16, 12, 2), // key: 13zb55
  ]);

  /// `beaker.mjs`
  static const ElLucideGlyph beaker = ElLucideGlyph('beaker', <ElIconElement>[
    ElIconPathElement('M4.5 3h15'), // key: c7n0jr
    ElIconPathElement('M6 3v16a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V3'), // key: m1uhx7
    ElIconPathElement('M6 14h12'), // key: 4cwo0f
  ]);

  /// `bean-off.mjs`
  static const ElLucideGlyph
  beanOff = ElLucideGlyph('bean-off', <ElIconElement>[
    ElIconPathElement(
      'M9 9c-.64.64-1.521.954-2.402 1.165A6 6 0 0 0 8 22a13.96 13.96 0 0 0 9.9-4.1',
    ), // key: bq3udt
    ElIconPathElement(
      'M10.75 5.093A6 6 0 0 1 22 8c0 2.411-.61 4.68-1.683 6.66',
    ), // key: 17ccse
    ElIconPathElement(
      'M5.341 10.62a4 4 0 0 0 6.487 1.208M10.62 5.341a4.015 4.015 0 0 1 2.039 2.04',
    ), // key: 18zqgq
    ElIconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `bean.mjs`
  static const ElLucideGlyph bean = ElLucideGlyph('bean', <ElIconElement>[
    ElIconPathElement(
      'M10.165 6.598C9.954 7.478 9.64 8.36 9 9c-.64.64-1.521.954-2.402 1.165A6 6 0 0 0 8 22c7.732 0 14-6.268 14-14a6 6 0 0 0-11.835-1.402Z',
    ), // key: 1tvzk7
    ElIconPathElement('M5.341 10.62a4 4 0 1 0 5.279-5.28'), // key: 2cyri2
  ]);

  /// `bed-double.mjs`
  static const ElLucideGlyph bedDouble = ElLucideGlyph(
    'bed-double',
    <ElIconElement>[
      ElIconPathElement(
        'M2 20v-8a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v8',
      ), // key: 1k78r4
      ElIconPathElement(
        'M4 10V6a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v4',
      ), // key: fb3tl2
      ElIconPathElement('M12 4v6'), // key: 1dcgq2
      ElIconPathElement('M2 18h20'), // key: ajqnye
    ],
  );

  /// `bed-single.mjs`
  static const ElLucideGlyph bedSingle = ElLucideGlyph(
    'bed-single',
    <ElIconElement>[
      ElIconPathElement(
        'M3 20v-8a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v8',
      ), // key: 1wm6mi
      ElIconPathElement(
        'M5 10V6a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v4',
      ), // key: 4k93s5
      ElIconPathElement('M3 18h18'), // key: 1h113x
    ],
  );

  /// `bed.mjs`
  static const ElLucideGlyph bed = ElLucideGlyph('bed', <ElIconElement>[
    ElIconPathElement('M2 4v16'), // key: vw9hq8
    ElIconPathElement('M2 8h18a2 2 0 0 1 2 2v10'), // key: 1dgv2r
    ElIconPathElement('M2 17h20'), // key: 18nfp3
    ElIconPathElement('M6 8v9'), // key: 1yriud
  ]);

  /// `beef-off.mjs`
  static const ElLucideGlyph
  beefOff = ElLucideGlyph('beef-off', <ElIconElement>[
    ElIconPathElement('M11.771 6.109a2.5 2.5 0 0 1 3.12 3.12'), // key: 3w1grc
    ElIconPathElement('M17.852 12.185a6.5 6.5 0 0 0-9.035-9.04'), // key: 1xgl7b
    ElIconPathElement(
      'M18.013 18.013C15.029 20.349 10.831 22 7 22a3 3 0 0 1-2.68-1.66L2.4 16.5',
    ), // key: 3m3yc0
    ElIconPathElement(
      'm18.5 6 2.19 4.5a6.48 6.48 0 0 1-.139 4.393',
    ), // key: 1rvkn7
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement(
      'M6.355 6.37a7 7 0 0 0-.075.23c-1.1 3.13-.78 3.9-3.18 6.08A3 3 0 0 0 5 18c3.356 0 6.993-1.267 9.85-3.151',
    ), // key: 54713r
  ]);

  /// `beef.mjs`
  static const ElLucideGlyph beef = ElLucideGlyph('beef', <ElIconElement>[
    ElIconPathElement(
      'M16.4 13.7A6.5 6.5 0 1 0 6.28 6.6c-1.1 3.13-.78 3.9-3.18 6.08A3 3 0 0 0 5 18c4 0 8.4-1.8 11.4-4.3',
    ), // key: cisjcv
    ElIconPathElement(
      'm18.5 6 2.19 4.5a6.48 6.48 0 0 1-2.29 7.2C15.4 20.2 11 22 7 22a3 3 0 0 1-2.68-1.66L2.4 16.5',
    ), // key: 5byaag
    ElIconCircleElement(12.5, 8.5, 2.5), // key: 9738u8
  ]);

  /// `beer-off.mjs`
  static const ElLucideGlyph
  beerOff = ElLucideGlyph('beer-off', <ElIconElement>[
    ElIconPathElement('M13 13v5'), // key: igwfh0
    ElIconPathElement('M17 11.47V8'), // key: 16yw0g
    ElIconPathElement('M17 11h1a3 3 0 0 1 2.745 4.211'), // key: 1xbt65
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement(
      'M5 8v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2v-3',
    ), // key: c55o3e
    ElIconPathElement(
      'M7.536 7.535C6.766 7.649 6.154 8 5.5 8a2.5 2.5 0 0 1-1.768-4.268',
    ), // key: 1ydug7
    ElIconPathElement(
      'M8.727 3.204C9.306 2.767 9.885 2 11 2c1.56 0 2 1.5 3 1.5s1.72-.5 2.5-.5a1 1 0 1 1 0 5c-.78 0-1.5-.5-2.5-.5a3.149 3.149 0 0 0-.842.12',
    ), // key: q81o7q
    ElIconPathElement('M9 14.6V18'), // key: 20ek98
  ]);

  /// `beer.mjs`
  static const ElLucideGlyph beer = ElLucideGlyph('beer', <ElIconElement>[
    ElIconPathElement('M17 11h1a3 3 0 0 1 0 6h-1'), // key: 1yp76v
    ElIconPathElement('M9 12v6'), // key: 1u1cab
    ElIconPathElement('M13 12v6'), // key: 1sugkk
    ElIconPathElement(
      'M14 7.5c-1 0-1.44.5-3 .5s-2-.5-3-.5-1.72.5-2.5.5a2.5 2.5 0 0 1 0-5c.78 0 1.57.5 2.5.5S9.44 2 11 2s2 1.5 3 1.5 1.72-.5 2.5-.5a2.5 2.5 0 0 1 0 5c-.78 0-1.5-.5-2.5-.5Z',
    ), // key: 1510fo
    ElIconPathElement('M5 8v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V8'), // key: 19jb7n
  ]);

  /// `bell-check.mjs`
  static const ElLucideGlyph
  bellCheck = ElLucideGlyph('bell-check', <ElIconElement>[
    ElIconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    ElIconPathElement('m15 8 2 2 4-4'), // key: sbrgsm
    ElIconPathElement(
      'M16.8607 4.4824A6 6 0 0 0 6 8C6 12.499 4.589 13.956 3.262 15.326',
    ), // key: qcog4a
    ElIconPathElement(
      'M3.262 15.326A1 1 0 0 0 4 17H20A1 1 0 0 0 20.74 15.327C20.209 14.779 19.665 14.218 19.203 13.454',
    ), // key: mxnnoh
  ]);

  /// `bell-dot.mjs`
  static const ElLucideGlyph
  bellDot = ElLucideGlyph('bell-dot', <ElIconElement>[
    ElIconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    ElIconPathElement(
      'M11.68 2.009A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673c-.824-.85-1.678-1.731-2.21-3.348',
    ), // key: xaq59h
    ElIconCircleElement(18, 5, 3), // key: gq8acd
  ]);

  /// `bell-electric.mjs`
  static const ElLucideGlyph bellElectric = ElLucideGlyph(
    'bell-electric',
    <ElIconElement>[
      ElIconPathElement('M18.518 17.347A7 7 0 0 1 14 19'), // key: 1emhpo
      ElIconPathElement('M18.8 4A11 11 0 0 1 20 9'), // key: 127b67
      ElIconPathElement('M9 9h.01'), // key: 1q5me6
      ElIconCircleElement(20, 16, 2), // key: 1v9bxh
      ElIconCircleElement(9, 9, 7), // key: p2h5vp
      ElIconRectElement(4, 16, 10, 6, 2), // key: bfnviv
    ],
  );

  /// `bell-minus.mjs`
  static const ElLucideGlyph
  bellMinus = ElLucideGlyph('bell-minus', <ElIconElement>[
    ElIconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    ElIconPathElement('M15 8h6'), // key: 8ybuxh
    ElIconPathElement(
      'M16.243 3.757A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673A9.4 9.4 0 0 1 18.667 12',
    ), // key: bdwj86
  ]);

  /// `bell-off.mjs`
  static const ElLucideGlyph
  bellOff = ElLucideGlyph('bell-off', <ElIconElement>[
    ElIconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    ElIconPathElement(
      'M17 17H4a1 1 0 0 1-.74-1.673C4.59 13.956 6 12.499 6 8a6 6 0 0 1 .258-1.742',
    ), // key: 178tsu
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement(
      'M8.668 3.01A6 6 0 0 1 18 8c0 2.687.77 4.653 1.707 6.05',
    ), // key: 1hqiys
  ]);

  /// `bell-plus.mjs`
  static const ElLucideGlyph
  bellPlus = ElLucideGlyph('bell-plus', <ElIconElement>[
    ElIconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    ElIconPathElement('M15 8h6'), // key: 8ybuxh
    ElIconPathElement('M18 5v6'), // key: g5ayrv
    ElIconPathElement(
      'M20.002 14.464a9 9 0 0 0 .738.863A1 1 0 0 1 20 17H4a1 1 0 0 1-.74-1.673C4.59 13.956 6 12.499 6 8a6 6 0 0 1 8.75-5.332',
    ), // key: 1abcvy
  ]);

  /// `bell-ring.mjs`
  static const ElLucideGlyph
  bellRing = ElLucideGlyph('bell-ring', <ElIconElement>[
    ElIconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    ElIconPathElement('M22 8c0-2.3-.8-4.3-2-6'), // key: 5bb3ad
    ElIconPathElement(
      'M3.262 15.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673C19.41 13.956 18 12.499 18 8A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326',
    ), // key: 11g9vi
    ElIconPathElement('M4 2C2.8 3.7 2 5.7 2 8'), // key: tap9e0
  ]);

  /// `bell.mjs`
  static const ElLucideGlyph bell = ElLucideGlyph('bell', <ElIconElement>[
    ElIconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    ElIconPathElement(
      'M3.262 15.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673C19.41 13.956 18 12.499 18 8A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326',
    ), // key: 11g9vi
  ]);

  /// `between-horizontal-end.mjs`
  static const ElLucideGlyph betweenHorizontalEnd = ElLucideGlyph(
    'between-horizontal-end',
    <ElIconElement>[
      ElIconRectElement(3, 3, 13, 7, 1), // key: 11xb64
      ElIconPathElement('m22 15-3-3 3-3'), // key: 26chmm
      ElIconRectElement(3, 14, 13, 7, 1), // key: k6ky7n
    ],
  );

  /// `between-horizontal-start.mjs`
  static const ElLucideGlyph betweenHorizontalStart = ElLucideGlyph(
    'between-horizontal-start',
    <ElIconElement>[
      ElIconRectElement(8, 3, 13, 7, 1), // key: pkso9a
      ElIconPathElement('m2 9 3 3-3 3'), // key: 1agib5
      ElIconRectElement(8, 14, 13, 7, 1), // key: 1q5fc1
    ],
  );

  /// `between-vertical-end.mjs`
  static const ElLucideGlyph betweenVerticalEnd = ElLucideGlyph(
    'between-vertical-end',
    <ElIconElement>[
      ElIconRectElement(3, 3, 7, 13, 1), // key: 1fdu0f
      ElIconPathElement('m9 22 3-3 3 3'), // key: 17z65a
      ElIconRectElement(14, 3, 7, 13, 1), // key: 1squn4
    ],
  );

  /// `between-vertical-start.mjs`
  static const ElLucideGlyph betweenVerticalStart = ElLucideGlyph(
    'between-vertical-start',
    <ElIconElement>[
      ElIconRectElement(3, 8, 7, 13, 1), // key: 1fjrkv
      ElIconPathElement('m15 2-3 3-3-3'), // key: 1uh6eb
      ElIconRectElement(14, 8, 7, 13, 1), // key: w3fjg8
    ],
  );

  /// `biceps-flexed.mjs`
  static const ElLucideGlyph
  bicepsFlexed = ElLucideGlyph('biceps-flexed', <ElIconElement>[
    ElIconPathElement(
      'M12.409 13.017A5 5 0 0 1 22 15c0 3.866-4 7-9 7-4.077 0-8.153-.82-10.371-2.462-.426-.316-.631-.832-.62-1.362C2.118 12.723 2.627 2 10 2a3 3 0 0 1 3 3 2 2 0 0 1-2 2c-1.105 0-1.64-.444-2-1',
    ), // key: 1pmlyh
    ElIconPathElement('M15 14a5 5 0 0 0-7.584 2'), // key: 5rb254
    ElIconPathElement('M9.964 6.825C8.019 7.977 9.5 13 8 15'), // key: kbvsx9
  ]);

  /// `bike.mjs`
  static const ElLucideGlyph bike = ElLucideGlyph('bike', <ElIconElement>[
    ElIconCircleElement(18.5, 17.5, 3.5), // key: 15x4ox
    ElIconCircleElement(5.5, 17.5, 3.5), // key: 1noe27
    ElIconCircleElement(15, 5, 1), // key: 19l28e
    ElIconPathElement('M12 17.5V14l-3-3 4-3 2 3h2'), // key: 1npguv
  ]);

  /// `binary.mjs`
  static const ElLucideGlyph binary = ElLucideGlyph('binary', <ElIconElement>[
    ElIconRectElement(14, 14, 4, 6, 2), // key: p02svl
    ElIconRectElement(6, 4, 4, 6, 2), // key: xm4xkj
    ElIconPathElement('M6 20h4'), // key: 1i6q5t
    ElIconPathElement('M14 10h4'), // key: ru81e7
    ElIconPathElement('M6 14h2v6'), // key: 16z9wg
    ElIconPathElement('M14 4h2v6'), // key: 1idq9u
  ]);

  /// `binoculars.mjs`
  static const ElLucideGlyph
  binoculars = ElLucideGlyph('binoculars', <ElIconElement>[
    ElIconPathElement('M10 10h4'), // key: tcdvrf
    ElIconPathElement(
      'M19 7V4a1 1 0 0 0-1-1h-2a1 1 0 0 0-1 1v3',
    ), // key: 3apit1
    ElIconPathElement(
      'M20 21a2 2 0 0 0 2-2v-3.851c0-1.39-2-2.962-2-4.829V8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v11a2 2 0 0 0 2 2z',
    ), // key: rhpgnw
    ElIconPathElement('M 22 16 L 2 16'), // key: 14lkq7
    ElIconPathElement(
      'M4 21a2 2 0 0 1-2-2v-3.851c0-1.39 2-2.962 2-4.829V8a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v11a2 2 0 0 1-2 2z',
    ), // key: 104b3k
    ElIconPathElement('M9 7V4a1 1 0 0 0-1-1H6a1 1 0 0 0-1 1v3'), // key: 14fczp
  ]);

  /// `biohazard.mjs`
  static const ElLucideGlyph biohazard = ElLucideGlyph(
    'biohazard',
    <ElIconElement>[
      ElIconCircleElement(12, 11.9, 2), // key: e8h31w
      ElIconPathElement(
        'M6.7 3.4c-.9 2.5 0 5.2 2.2 6.7C6.5 9 3.7 9.6 2 11.6',
      ), // key: 17bolr
      ElIconPathElement('m8.9 10.1 1.4.8'), // key: 15ezny
      ElIconPathElement(
        'M17.3 3.4c.9 2.5 0 5.2-2.2 6.7 2.4-1.2 5.2-.6 6.9 1.5',
      ), // key: wtwa5u
      ElIconPathElement('m15.1 10.1-1.4.8'), // key: 1r0b28
      ElIconPathElement(
        'M16.7 20.8c-2.6-.4-4.6-2.6-4.7-5.3-.2 2.6-2.1 4.8-4.7 5.2',
      ), // key: m7qszh
      ElIconPathElement('M12 13.9v1.6'), // key: zfyyim
      ElIconPathElement('M13.5 5.4c-1-.2-2-.2-3 0'), // key: 1bi9q0
      ElIconPathElement('M17 16.4c.7-.7 1.2-1.6 1.5-2.5'), // key: 1rhjqw
      ElIconPathElement('M5.5 13.9c.3.9.8 1.8 1.5 2.5'), // key: 8gsud3
    ],
  );

  /// `bird.mjs`
  static const ElLucideGlyph bird = ElLucideGlyph('bird', <ElIconElement>[
    ElIconPathElement('M16 7h.01'), // key: 1kdx03
    ElIconPathElement(
      'M3.4 18H12a8 8 0 0 0 8-8V7a4 4 0 0 0-7.28-2.3L2 20',
    ), // key: oj1oa8
    ElIconPathElement('m20 7 2 .5-2 .5'), // key: 12nv4d
    ElIconPathElement('M10 18v3'), // key: 1yea0a
    ElIconPathElement('M14 17.75V21'), // key: 1pymcb
    ElIconPathElement('M7 18a6 6 0 0 0 3.84-10.61'), // key: 1npnn0
  ]);

  /// `birdhouse.mjs`
  static const ElLucideGlyph birdhouse = ElLucideGlyph(
    'birdhouse',
    <ElIconElement>[
      ElIconPathElement('M12 18v4'), // key: jadmvz
      ElIconPathElement('m17 18 1.956-11.468'), // key: l5n2ro
      ElIconPathElement('m3 8 7.82-5.615a2 2 0 0 1 2.36 0L21 8'), // key: 1sy6n7
      ElIconPathElement('M4 18h16'), // key: 19g7jn
      ElIconPathElement('M7 18 5.044 6.532'), // key: 1uqdf2
      ElIconCircleElement(12, 10, 2), // key: 1yojzk
    ],
  );

  /// `bitcoin.mjs`
  static const ElLucideGlyph bitcoin = ElLucideGlyph('bitcoin', <ElIconElement>[
    ElIconPathElement(
      'M11.767 19.089c4.924.868 6.14-6.025 1.216-6.894m-1.216 6.894L5.86 18.047m5.908 1.042-.347 1.97m1.563-8.864c4.924.869 6.14-6.025 1.215-6.893m-1.215 6.893-3.94-.694m5.155-6.2L8.29 4.26m5.908 1.042.348-1.97M7.48 20.364l3.126-17.727',
    ), // key: yr8idg
  ]);

  /// `blend.mjs`
  static const ElLucideGlyph blend = ElLucideGlyph('blend', <ElIconElement>[
    ElIconCircleElement(9, 9, 7), // key: p2h5vp
    ElIconCircleElement(15, 15, 7), // key: 19ennj
  ]);

  /// `blender.mjs`
  static const ElLucideGlyph blender = ElLucideGlyph('blender', <ElIconElement>[
    ElIconPathElement(
      'M8 14a2 2 0 0 0-1.963 1.615l-1.018 5.193A1 1 0 0 0 6 22h12a1 1 0 0 0 .981-1.192l-1.018-5.193A2 2 0 0 0 16 14z',
    ), // key: 11zxmj
    ElIconPathElement('m17 2-1 12'), // key: nxm2fw
    ElIconPathElement('M8.006 14 7 2'), // key: 13bxiv
    ElIconPathElement(
      'M7.565 8.787A5 5 0 0 0 12 8a5 5 0 0 1 4.56-.75',
    ), // key: 1s61ad
    ElIconPathElement(
      'M19 2H5a2 2 0 0 0-2 2v5a2 2 0 0 0 .688 1.5',
    ), // key: gel3rg
    ElIconPathElement('M12 18h.01'), // key: mhygvu
  ]);

  /// `blinds.mjs`
  static const ElLucideGlyph blinds = ElLucideGlyph('blinds', <ElIconElement>[
    ElIconPathElement('M3 3h18'), // key: o7r712
    ElIconPathElement('M20 7H8'), // key: gd2fo2
    ElIconPathElement('M20 11H8'), // key: 1ynp89
    ElIconPathElement('M10 19h10'), // key: 19hjk5
    ElIconPathElement('M8 15h12'), // key: 1yqzne
    ElIconPathElement('M4 3v14'), // key: fggqzn
    ElIconCircleElement(4, 19, 2), // key: p3m9r0
  ]);

  /// `blocks.mjs`
  static const ElLucideGlyph blocks = ElLucideGlyph('blocks', <ElIconElement>[
    ElIconPathElement(
      'M10 22V7a1 1 0 0 0-1-1H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-5a1 1 0 0 0-1-1H2',
    ), // key: 1ah6g2
    ElIconRectElement(14, 2, 8, 8, 1), // key: 88lufb
  ]);

  /// `bluetooth-connected.mjs`
  static const ElLucideGlyph bluetoothConnected = ElLucideGlyph(
    'bluetooth-connected',
    <ElIconElement>[
      ElIconPathElement('m7 7 10 10-5 5V2l5 5L7 17'), // key: 1q5490
      ElIconLineElement(18, 12, 21, 12), // key: 1rsjjs
      ElIconLineElement(3, 12, 6, 12), // key: 11yl8c
    ],
  );

  /// `bluetooth-off.mjs`
  static const ElLucideGlyph bluetoothOff = ElLucideGlyph(
    'bluetooth-off',
    <ElIconElement>[
      ElIconPathElement('m17 17-5 5V12l-5 5'), // key: v5aci6
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
      ElIconPathElement('M14.5 9.5 17 7l-5-5v4.5'), // key: 1kddfz
    ],
  );

  /// `bluetooth-searching.mjs`
  static const ElLucideGlyph bluetoothSearching = ElLucideGlyph(
    'bluetooth-searching',
    <ElIconElement>[
      ElIconPathElement('m7 7 10 10-5 5V2l5 5L7 17'), // key: 1q5490
      ElIconPathElement('M20.83 14.83a4 4 0 0 0 0-5.66'), // key: k8tn1j
      ElIconPathElement('M18 12h.01'), // key: yjnet6
    ],
  );

  /// `bluetooth.mjs`
  static const ElLucideGlyph bluetooth = ElLucideGlyph(
    'bluetooth',
    <ElIconElement>[
      ElIconPathElement('m7 7 10 10-5 5V2l5 5L7 17'), // key: 1q5490
    ],
  );

  /// `bold.mjs`
  static const ElLucideGlyph bold = ElLucideGlyph('bold', <ElIconElement>[
    ElIconPathElement(
      'M6 12h9a4 4 0 0 1 0 8H7a1 1 0 0 1-1-1V5a1 1 0 0 1 1-1h7a4 4 0 0 1 0 8',
    ), // key: mg9rjx
  ]);

  /// `bolt.mjs`
  static const ElLucideGlyph bolt = ElLucideGlyph('bolt', <ElIconElement>[
    ElIconPathElement(
      'M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z',
    ), // key: yt0hxn
    ElIconCircleElement(12, 12, 4), // key: 4exip2
  ]);

  /// `bomb.mjs`
  static const ElLucideGlyph bomb = ElLucideGlyph('bomb', <ElIconElement>[
    ElIconCircleElement(11, 13, 9), // key: hd149
    ElIconPathElement(
      'M14.35 4.65 16.3 2.7a2.41 2.41 0 0 1 3.4 0l1.6 1.6a2.4 2.4 0 0 1 0 3.4l-1.95 1.95',
    ), // key: jp4j1b
    ElIconPathElement('m22 2-1.5 1.5'), // key: ay92ug
  ]);

  /// `bone-fracture.mjs`
  static const ElLucideGlyph
  boneFracture = ElLucideGlyph('bone-fracture', <ElIconElement>[
    ElIconPathElement(
      'M14 4.5a1 1 0 0 1 5 0 .5.5 0 0 0 .5.5 1 1 0 0 1 0 5c-.81 0-1.8-.7-2.5 0l-1.958 1.957a.15.15 0 0 1-.252-.072l-.493-2.07a.15.15 0 0 0-.111-.112l-2.072-.494a.15.15 0 0 1-.072-.252L14 7c.7-.7 0-1.69 0-2.5',
    ), // key: 1c7o5b
    ElIconPathElement('m16 20-1-2'), // key: 5348lt
    ElIconPathElement('m20 16-2-1'), // key: 2c7pv5
    ElIconPathElement('m4 8 2 1'), // key: rpj1x4
    ElIconPathElement('m8 4 1 2'), // key: 1r4zbp
    ElIconPathElement(
      'M9.698 14.19a.15.15 0 0 0 .112.112l2.074.489a.15.15 0 0 1 .072.252L10 17c-.7.7 0 1.69 0 2.5a1 1 0 0 1-5 0 .495.495 0 0 0-.5-.5 1 1 0 0 1 0-5c.81 0 1.8.7 2.5 0l1.956-1.957a.15.15 0 0 1 .252.072z',
    ), // key: 3u61yx
  ]);

  /// `bone.mjs`
  static const ElLucideGlyph bone = ElLucideGlyph('bone', <ElIconElement>[
    ElIconPathElement(
      'M17 10c.7-.7 1.69 0 2.5 0a2.5 2.5 0 1 0 0-5 .5.5 0 0 1-.5-.5 2.5 2.5 0 1 0-5 0c0 .81.7 1.8 0 2.5l-7 7c-.7.7-1.69 0-2.5 0a2.5 2.5 0 0 0 0 5c.28 0 .5.22.5.5a2.5 2.5 0 1 0 5 0c0-.81-.7-1.8 0-2.5Z',
    ), // key: w610uw
  ]);

  /// `book-a.mjs`
  static const ElLucideGlyph bookA = ElLucideGlyph('book-a', <ElIconElement>[
    ElIconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    ElIconPathElement('m8 13 4-7 4 7'), // key: 4rari8
    ElIconPathElement('M9.1 11h5.7'), // key: 1gkovt
  ]);

  /// `book-alert.mjs`
  static const ElLucideGlyph
  bookAlert = ElLucideGlyph('book-alert', <ElIconElement>[
    ElIconPathElement('M12 13h.01'), // key: y0uutt
    ElIconPathElement('M12 6v3'), // key: 1m4b9j
    ElIconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
  ]);

  /// `book-audio.mjs`
  static const ElLucideGlyph
  bookAudio = ElLucideGlyph('book-audio', <ElIconElement>[
    ElIconPathElement('M12 6v7'), // key: 1f6ttz
    ElIconPathElement('M16 8v3'), // key: gejaml
    ElIconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    ElIconPathElement('M8 8v3'), // key: 1qzp49
  ]);

  /// `book-check.mjs`
  static const ElLucideGlyph
  bookCheck = ElLucideGlyph('book-check', <ElIconElement>[
    ElIconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    ElIconPathElement('m9 9.5 2 2 4-4'), // key: 1dth82
  ]);

  /// `book-copy.mjs`
  static const ElLucideGlyph
  bookCopy = ElLucideGlyph('book-copy', <ElIconElement>[
    ElIconPathElement('M5 7a2 2 0 0 0-2 2v11'), // key: 1yhqjt
    ElIconPathElement(
      'M5.803 18H5a2 2 0 0 0 0 4h9.5a.5.5 0 0 0 .5-.5V21',
    ), // key: edzzo5
    ElIconPathElement(
      'M9 15V4a2 2 0 0 1 2-2h9.5a.5.5 0 0 1 .5.5v14a.5.5 0 0 1-.5.5H11a2 2 0 0 1 0-4h10',
    ), // key: 1nwzrg
  ]);

  /// `book-dashed.mjs`
  static const ElLucideGlyph bookDashed = ElLucideGlyph(
    'book-dashed',
    <ElIconElement>[
      ElIconPathElement('M12 17h1.5'), // key: 1gkc67
      ElIconPathElement('M12 22h1.5'), // key: 1my7sn
      ElIconPathElement('M12 2h1.5'), // key: 19tvb7
      ElIconPathElement('M17.5 22H19a1 1 0 0 0 1-1'), // key: 10akbh
      ElIconPathElement('M17.5 2H19a1 1 0 0 1 1 1v1.5'), // key: 1vrfjs
      ElIconPathElement('M20 14v3h-2.5'), // key: 1naeju
      ElIconPathElement('M20 8.5V10'), // key: 1ctpfu
      ElIconPathElement('M4 10V8.5'), // key: 1o3zg5
      ElIconPathElement('M4 19.5V14'), // key: ob81pf
      ElIconPathElement('M4 4.5A2.5 2.5 0 0 1 6.5 2H8'), // key: s8vcyb
      ElIconPathElement('M8 22H6.5a1 1 0 0 1 0-5H8'), // key: 1cu73q
    ],
  );

  /// `book-down.mjs`
  static const ElLucideGlyph
  bookDown = ElLucideGlyph('book-down', <ElIconElement>[
    ElIconPathElement('M12 13V7'), // key: h0r20n
    ElIconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    ElIconPathElement('m9 10 3 3 3-3'), // key: zt5b4y
  ]);

  /// `book-headphones.mjs`
  static const ElLucideGlyph
  bookHeadphones = ElLucideGlyph('book-headphones', <ElIconElement>[
    ElIconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    ElIconPathElement('M8 12v-2a4 4 0 0 1 8 0v2'), // key: 1vsqkj
    ElIconCircleElement(15, 12, 1), // key: 1tmaij
    ElIconCircleElement(9, 12, 1), // key: 1vctgf
  ]);

  /// `book-heart.mjs`
  static const ElLucideGlyph
  bookHeart = ElLucideGlyph('book-heart', <ElIconElement>[
    ElIconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    ElIconPathElement(
      'M8.62 9.8A2.25 2.25 0 1 1 12 6.836a2.25 2.25 0 1 1 3.38 2.966l-2.626 2.856a.998.998 0 0 1-1.507 0z',
    ), // key: 9v40y5
  ]);

  /// `book-image.mjs`
  static const ElLucideGlyph
  bookImage = ElLucideGlyph('book-image', <ElIconElement>[
    ElIconPathElement('m20 13.7-2.1-2.1a2 2 0 0 0-2.8 0L9.7 17'), // key: q6ojf0
    ElIconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    ElIconCircleElement(10, 8, 2), // key: 2qkj4p
  ]);

  /// `book-key.mjs`
  static const ElLucideGlyph bookKey = ElLucideGlyph(
    'book-key',
    <ElIconElement>[
      ElIconPathElement('M13 2H6.5A2.5 2.5 0 0 0 4 4.5v15'), // key: 4azifu
      ElIconPathElement('M17 2v6'), // key: qgmh37
      ElIconPathElement('M17 4h2'), // key: 13vrzo
      ElIconPathElement(
        'M20 15.2V21a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
      ), // key: 192hzx
      ElIconCircleElement(17, 10, 2), // key: y0i25j
    ],
  );

  /// `book-lock.mjs`
  static const ElLucideGlyph bookLock = ElLucideGlyph(
    'book-lock',
    <ElIconElement>[
      ElIconPathElement('M18 6V4a2 2 0 1 0-4 0v2'), // key: 1aquzs
      ElIconPathElement(
        'M20 15v6a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
      ), // key: 1rkj32
      ElIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H10'), // key: 18wgow
      ElIconRectElement(12, 6, 8, 5, 1), // key: 73l30o
    ],
  );

  /// `book-marked.mjs`
  static const ElLucideGlyph
  bookMarked = ElLucideGlyph('book-marked', <ElIconElement>[
    ElIconPathElement('M10 2v8l3-3 3 3V2'), // key: sqw3rj
    ElIconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
  ]);

  /// `book-minus.mjs`
  static const ElLucideGlyph
  bookMinus = ElLucideGlyph('book-minus', <ElIconElement>[
    ElIconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    ElIconPathElement('M9 10h6'), // key: 9gxzsh
  ]);

  /// `book-open-check.mjs`
  static const ElLucideGlyph
  bookOpenCheck = ElLucideGlyph('book-open-check', <ElIconElement>[
    ElIconPathElement('M12 5v16'), // key: 1f6ucr
    ElIconPathElement('m16 12 2 2 4-4'), // key: mdajum
    ElIconPathElement(
      'M22 6V5a2 2 0 00-1.999-2L16 3.002A5 5 0 0012 5a5 5 0 00-4-2H4a2 2 0 00-2 2v12a2 2 0 001.999 2H8a5 5 0 014 2 5 5 0 014-2h4.001A2 2 0 0022 17v-1.344',
    ), // key: 144kbk
  ]);

  /// `book-open-text.mjs`
  static const ElLucideGlyph
  bookOpenText = ElLucideGlyph('book-open-text', <ElIconElement>[
    ElIconPathElement('M12 5v16'), // key: 1f6ucr
    ElIconPathElement('M16 13h2'), // key: weia3s
    ElIconPathElement('M16 9h2'), // key: 1n7gjm
    ElIconPathElement(
      'M20.001 19A2 2 0 0022 17V5a2 2 0 00-1.999-2L16 3.002A5 5 0 0012 5a5 5 0 00-4-2H4a2 2 0 00-2 2v12a2 2 0 001.999 2H8a5 5 0 014 2 5 5 0 014-2z',
    ), // key: 1fyvmf
    ElIconPathElement('M6 13h2'), // key: 1cckiz
    ElIconPathElement('M6 9h2'), // key: 1k7j9f
  ]);

  /// `book-open.mjs`
  static const ElLucideGlyph
  bookOpen = ElLucideGlyph('book-open', <ElIconElement>[
    ElIconPathElement('M12 5v16'), // key: 1f6ucr
    ElIconPathElement(
      'M20.001 19A2 2 0 0022 17V5a2 2 0 00-1.999-2L16 3.002A5 5 0 0012 5a5 5 0 00-4-2H4a2 2 0 00-2 2v12a2 2 0 001.999 2H8a5 5 0 014 2 5 5 0 014-2z',
    ), // key: 1fyvmf
  ]);

  /// `book-plus.mjs`
  static const ElLucideGlyph
  bookPlus = ElLucideGlyph('book-plus', <ElIconElement>[
    ElIconPathElement('M12 7v6'), // key: lw1j43
    ElIconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    ElIconPathElement('M9 10h6'), // key: 9gxzsh
  ]);

  /// `book-search.mjs`
  static const ElLucideGlyph bookSearch = ElLucideGlyph(
    'book-search',
    <ElIconElement>[
      ElIconPathElement('M11 22H5.5a1 1 0 0 1 0-5h4.501'), // key: mcbepb
      ElIconPathElement('m21 22-1.879-1.878'), // key: 12q7x1
      ElIconPathElement(
        'M3 19.5v-15A2.5 2.5 0 0 1 5.5 2H18a1 1 0 0 1 1 1v8',
      ), // key: olfd5n
      ElIconCircleElement(17, 18, 3), // key: 82mm0e
    ],
  );

  /// `book-text.mjs`
  static const ElLucideGlyph
  bookText = ElLucideGlyph('book-text', <ElIconElement>[
    ElIconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    ElIconPathElement('M8 11h8'), // key: vwpz6n
    ElIconPathElement('M8 7h6'), // key: 1f0q6e
  ]);

  /// `book-type.mjs`
  static const ElLucideGlyph
  bookType = ElLucideGlyph('book-type', <ElIconElement>[
    ElIconPathElement('M10 13h4'), // key: ytezjc
    ElIconPathElement('M12 6v7'), // key: 1f6ttz
    ElIconPathElement('M16 8V6H8v2'), // key: x8j6u4
    ElIconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
  ]);

  /// `book-up-2.mjs`
  static const ElLucideGlyph bookUp2 = ElLucideGlyph(
    'book-up-2',
    <ElIconElement>[
      ElIconPathElement('M12 13V7'), // key: h0r20n
      ElIconPathElement(
        'M18 2h1a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
      ), // key: 161d7n
      ElIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2'), // key: 1lorq7
      ElIconPathElement('m9 10 3-3 3 3'), // key: 11gsxs
      ElIconPathElement('m9 5 3-3 3 3'), // key: l8vdw6
    ],
  );

  /// `book-up.mjs`
  static const ElLucideGlyph bookUp = ElLucideGlyph('book-up', <ElIconElement>[
    ElIconPathElement('M12 13V7'), // key: h0r20n
    ElIconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    ElIconPathElement('m9 10 3-3 3 3'), // key: 11gsxs
  ]);

  /// `book-user.mjs`
  static const ElLucideGlyph
  bookUser = ElLucideGlyph('book-user', <ElIconElement>[
    ElIconPathElement('M15 13a3 3 0 1 0-6 0'), // key: 10j68g
    ElIconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    ElIconCircleElement(12, 8, 2), // key: 1822b1
  ]);

  /// `book-x.mjs`
  static const ElLucideGlyph bookX = ElLucideGlyph('book-x', <ElIconElement>[
    ElIconPathElement('m14.5 7-5 5'), // key: dy991v
    ElIconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
    ElIconPathElement('m9.5 7 5 5'), // key: s45iea
  ]);

  /// `book.mjs`
  static const ElLucideGlyph book = ElLucideGlyph('book', <ElIconElement>[
    ElIconPathElement(
      'M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20',
    ), // key: k3hazp
  ]);

  /// `bookmark-check.mjs`
  static const ElLucideGlyph
  bookmarkCheck = ElLucideGlyph('bookmark-check', <ElIconElement>[
    ElIconPathElement(
      'M17 3a2 2 0 0 1 2 2v15a1 1 0 0 1-1.496.868l-4.512-2.578a2 2 0 0 0-1.984 0l-4.512 2.578A1 1 0 0 1 5 20V5a2 2 0 0 1 2-2z',
    ), // key: oz39mx
    ElIconPathElement('m9 10 2 2 4-4'), // key: 1gnqz4
  ]);

  /// `bookmark-minus.mjs`
  static const ElLucideGlyph
  bookmarkMinus = ElLucideGlyph('bookmark-minus', <ElIconElement>[
    ElIconPathElement('M15 10H9'), // key: o6yqo3
    ElIconPathElement(
      'M17 3a2 2 0 0 1 2 2v15a1 1 0 0 1-1.496.868l-4.512-2.578a2 2 0 0 0-1.984 0l-4.512 2.578A1 1 0 0 1 5 20V5a2 2 0 0 1 2-2z',
    ), // key: oz39mx
  ]);

  /// `bookmark-off.mjs`
  static const ElLucideGlyph
  bookmarkOff = ElLucideGlyph('bookmark-off', <ElIconElement>[
    ElIconPathElement(
      'M19 19v1a1 1 0 0 1-1.496.868l-4.512-2.578a2 2 0 0 0-1.984 0l-4.512 2.578A1 1 0 0 1 5 20V5',
    ), // key: nigmce
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement('M8.656 3H17a2 2 0 0 1 2 2v8.344'), // key: hlvsa
  ]);

  /// `bookmark-plus.mjs`
  static const ElLucideGlyph
  bookmarkPlus = ElLucideGlyph('bookmark-plus', <ElIconElement>[
    ElIconPathElement('M12 7v6'), // key: lw1j43
    ElIconPathElement('M15 10H9'), // key: o6yqo3
    ElIconPathElement(
      'M17 3a2 2 0 0 1 2 2v15a1 1 0 0 1-1.496.868l-4.512-2.578a2 2 0 0 0-1.984 0l-4.512 2.578A1 1 0 0 1 5 20V5a2 2 0 0 1 2-2z',
    ), // key: oz39mx
  ]);

  /// `bookmark-x.mjs`
  static const ElLucideGlyph
  bookmarkX = ElLucideGlyph('bookmark-x', <ElIconElement>[
    ElIconPathElement('m14.5 7.5-5 5'), // key: 3lb6iw
    ElIconPathElement(
      'M17 3a2 2 0 0 1 2 2v15a1 1 0 0 1-1.496.868l-4.512-2.578a2 2 0 0 0-1.984 0l-4.512 2.578A1 1 0 0 1 5 20V5a2 2 0 0 1 2-2z',
    ), // key: oz39mx
    ElIconPathElement('m9.5 7.5 5 5'), // key: ko136h
  ]);

  /// `bookmark.mjs`
  static const ElLucideGlyph
  bookmark = ElLucideGlyph('bookmark', <ElIconElement>[
    ElIconPathElement(
      'M17 3a2 2 0 0 1 2 2v15a1 1 0 0 1-1.496.868l-4.512-2.578a2 2 0 0 0-1.984 0l-4.512 2.578A1 1 0 0 1 5 20V5a2 2 0 0 1 2-2z',
    ), // key: oz39mx
  ]);

  /// `boom-box.mjs`
  static const ElLucideGlyph
  boomBox = ElLucideGlyph('boom-box', <ElIconElement>[
    ElIconPathElement('M4 9V5a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v4'), // key: vvzvr1
    ElIconPathElement('M8 8v1'), // key: xcqmfk
    ElIconPathElement('M12 8v1'), // key: 1rj8u4
    ElIconPathElement('M16 8v1'), // key: 1q12zr
    ElIconRectElement(2, 9, 20, 12, 2), // key: igpb89
    ElIconCircleElement(8, 15, 2), // key: fa4a8s
    ElIconCircleElement(16, 15, 2), // key: 14c3ya
  ]);

  /// `bot-message-square.mjs`
  static const ElLucideGlyph
  botMessageSquare = ElLucideGlyph('bot-message-square', <ElIconElement>[
    ElIconPathElement('M12 6V2H8'), // key: 1155em
    ElIconPathElement('M15 11v2'), // key: i11awn
    ElIconPathElement('M2 12h2'), // key: 1t8f8n
    ElIconPathElement('M20 12h2'), // key: 1q8mjw
    ElIconPathElement(
      'M20 16a2 2 0 0 1-2 2H8.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 4 20.286V8a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2z',
    ), // key: 11gyqh
    ElIconPathElement('M9 11v2'), // key: 1ueba0
  ]);

  /// `bot-off.mjs`
  static const ElLucideGlyph botOff = ElLucideGlyph('bot-off', <ElIconElement>[
    ElIconPathElement('M13.67 8H18a2 2 0 0 1 2 2v4.33'), // key: 7az073
    ElIconPathElement('M2 14h2'), // key: vft8re
    ElIconPathElement('M20 14h2'), // key: 4cs60a
    ElIconPathElement('M22 22 2 2'), // key: 1r8tn9
    ElIconPathElement(
      'M8 8H6a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h12a2 2 0 0 0 1.414-.586',
    ), // key: s09a7a
    ElIconPathElement('M9 13v2'), // key: rq6x2g
    ElIconPathElement('M9.67 4H12v2.33'), // key: 110xot
  ]);

  /// `bot.mjs`
  static const ElLucideGlyph bot = ElLucideGlyph('bot', <ElIconElement>[
    ElIconPathElement('M12 8V4H8'), // key: hb8ula
    ElIconRectElement(4, 8, 16, 12, 2), // key: enze0r
    ElIconPathElement('M2 14h2'), // key: vft8re
    ElIconPathElement('M20 14h2'), // key: 4cs60a
    ElIconPathElement('M15 13v2'), // key: 1xurst
    ElIconPathElement('M9 13v2'), // key: rq6x2g
  ]);

  /// `bottle-wine.mjs`
  static const ElLucideGlyph
  bottleWine = ElLucideGlyph('bottle-wine', <ElIconElement>[
    ElIconPathElement(
      'M10 3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v2a6 6 0 0 0 1.2 3.6l.6.8A6 6 0 0 1 17 13v8a1 1 0 0 1-1 1H8a1 1 0 0 1-1-1v-8a6 6 0 0 1 1.2-3.6l.6-.8A6 6 0 0 0 10 5z',
    ), // key: blqgoc
    ElIconPathElement(
      'M17 13h-4a1 1 0 0 0-1 1v3a1 1 0 0 0 1 1h4',
    ), // key: 43jbee
  ]);

  /// `bow-arrow.mjs`
  static const ElLucideGlyph
  bowArrow = ElLucideGlyph('bow-arrow', <ElIconElement>[
    ElIconPathElement('M17 3h4v4'), // key: 19p9u1
    ElIconPathElement(
      'M18.575 11.082a13 13 0 0 1 1.048 9.027 1.17 1.17 0 0 1-1.914.597L14 17',
    ), // key: 12t3w9
    ElIconPathElement(
      'M7 10 3.29 6.29a1.17 1.17 0 0 1 .6-1.91 13 13 0 0 1 9.03 1.05',
    ), // key: ogng5l
    ElIconPathElement(
      'M7 14a1.7 1.7 0 0 0-1.207.5l-2.646 2.646A.5.5 0 0 0 3.5 18H5a1 1 0 0 1 1 1v1.5a.5.5 0 0 0 .854.354L9.5 18.207A1.7 1.7 0 0 0 10 17v-2a1 1 0 0 0-1-1z',
    ), // key: 8v3fy2
    ElIconPathElement('M9.707 14.293 21 3'), // key: ydm3bn
  ]);

  /// `box.mjs`
  static const ElLucideGlyph box = ElLucideGlyph('box', <ElIconElement>[
    ElIconPathElement(
      'M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z',
    ), // key: hh9hay
    ElIconPathElement('m3.3 7 8.7 5 8.7-5'), // key: g66t2b
    ElIconPathElement('M12 22V12'), // key: d0xqtd
  ]);

  /// `boxes.mjs`
  static const ElLucideGlyph boxes = ElLucideGlyph('boxes', <ElIconElement>[
    ElIconPathElement(
      'M2.97 12.92A2 2 0 0 0 2 14.63v3.24a2 2 0 0 0 .97 1.71l3 1.8a2 2 0 0 0 2.06 0L12 19v-5.5l-5-3-4.03 2.42Z',
    ), // key: lc1i9w
    ElIconPathElement('m7 16.5-4.74-2.85'), // key: 1o9zyk
    ElIconPathElement('m7 16.5 5-3'), // key: va8pkn
    ElIconPathElement('M7 16.5v5.17'), // key: jnp8gn
    ElIconPathElement(
      'M12 13.5V19l3.97 2.38a2 2 0 0 0 2.06 0l3-1.8a2 2 0 0 0 .97-1.71v-3.24a2 2 0 0 0-.97-1.71L17 10.5l-5 3Z',
    ), // key: 8zsnat
    ElIconPathElement('m17 16.5-5-3'), // key: 8arw3v
    ElIconPathElement('m17 16.5 4.74-2.85'), // key: 8rfmw
    ElIconPathElement('M17 16.5v5.17'), // key: k6z78m
    ElIconPathElement(
      'M7.97 4.42A2 2 0 0 0 7 6.13v4.37l5 3 5-3V6.13a2 2 0 0 0-.97-1.71l-3-1.8a2 2 0 0 0-2.06 0l-3 1.8Z',
    ), // key: 1xygjf
    ElIconPathElement('M12 8 7.26 5.15'), // key: 1vbdud
    ElIconPathElement('m12 8 4.74-2.85'), // key: 3rx089
    ElIconPathElement('M12 13.5V8'), // key: 1io7kd
  ]);

  /// `braces.mjs`
  static const ElLucideGlyph braces = ElLucideGlyph('braces', <ElIconElement>[
    ElIconPathElement(
      'M8 3H7a2 2 0 0 0-2 2v5a2 2 0 0 1-2 2 2 2 0 0 1 2 2v5c0 1.1.9 2 2 2h1',
    ), // key: ezmyqa
    ElIconPathElement(
      'M16 21h1a2 2 0 0 0 2-2v-5c0-1.1.9-2 2-2a2 2 0 0 1-2-2V5a2 2 0 0 0-2-2h-1',
    ), // key: e1hn23
  ]);

  /// `brackets.mjs`
  static const ElLucideGlyph
  brackets = ElLucideGlyph('brackets', <ElIconElement>[
    ElIconPathElement(
      'M16 3h3a1 1 0 0 1 1 1v16a1 1 0 0 1-1 1h-3',
    ), // key: 1kt8lf
    ElIconPathElement('M8 21H5a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h3'), // key: gduv9
  ]);

  /// `brain-circuit.mjs`
  static const ElLucideGlyph
  brainCircuit = ElLucideGlyph('brain-circuit', <ElIconElement>[
    ElIconPathElement(
      'M12 5a3 3 0 1 0-5.997.125 4 4 0 0 0-2.526 5.77 4 4 0 0 0 .556 6.588A4 4 0 1 0 12 18Z',
    ), // key: l5xja
    ElIconPathElement('M9 13a4.5 4.5 0 0 0 3-4'), // key: 10igwf
    ElIconPathElement('M6.003 5.125A3 3 0 0 0 6.401 6.5'), // key: 105sqy
    ElIconPathElement('M3.477 10.896a4 4 0 0 1 .585-.396'), // key: ql3yin
    ElIconPathElement('M6 18a4 4 0 0 1-1.967-.516'), // key: 2e4loj
    ElIconPathElement('M12 13h4'), // key: 1ku699
    ElIconPathElement('M12 18h6a2 2 0 0 1 2 2v1'), // key: 105ag5
    ElIconPathElement('M12 8h8'), // key: 1lhi5i
    ElIconPathElement('M16 8V5a2 2 0 0 1 2-2'), // key: u6izg6
    ElIconCircleElement(16, 13, 0.5), // key: ry7gng
    ElIconCircleElement(18, 3, 0.5), // key: 1aiba7
    ElIconCircleElement(20, 21, 0.5), // key: yhc1fs
    ElIconCircleElement(20, 8, 0.5), // key: 1e43v0
  ]);

  /// `brain-cog.mjs`
  static const ElLucideGlyph
  brainCog = ElLucideGlyph('brain-cog', <ElIconElement>[
    ElIconPathElement('m10.852 14.772-.383.923'), // key: 11vil6
    ElIconPathElement('m10.852 9.228-.383-.923'), // key: 1fjppe
    ElIconPathElement('m13.148 14.772.382.924'), // key: je3va1
    ElIconPathElement('m13.531 8.305-.383.923'), // key: 18epck
    ElIconPathElement('m14.772 10.852.923-.383'), // key: k9m8cz
    ElIconPathElement('m14.772 13.148.923.383'), // key: 1xvhww
    ElIconPathElement(
      'M17.598 6.5A3 3 0 1 0 12 5a3 3 0 0 0-5.63-1.446 3 3 0 0 0-.368 1.571 4 4 0 0 0-2.525 5.771',
    ), // key: jcbbz1
    ElIconPathElement('M17.998 5.125a4 4 0 0 1 2.525 5.771'), // key: 1kkn7e
    ElIconPathElement('M19.505 10.294a4 4 0 0 1-1.5 7.706'), // key: 18bmuc
    ElIconPathElement(
      'M4.032 17.483A4 4 0 0 0 11.464 20c.18-.311.892-.311 1.072 0a4 4 0 0 0 7.432-2.516',
    ), // key: uozx0d
    ElIconPathElement('M4.5 10.291A4 4 0 0 0 6 18'), // key: whdemb
    ElIconPathElement('M6.002 5.125a3 3 0 0 0 .4 1.375'), // key: 1kqy2g
    ElIconPathElement('m9.228 10.852-.923-.383'), // key: 1wtb30
    ElIconPathElement('m9.228 13.148-.923.383'), // key: 1a830x
    ElIconCircleElement(12, 12, 3), // key: 1v7zrd
  ]);

  /// `brain.mjs`
  static const ElLucideGlyph brain = ElLucideGlyph('brain', <ElIconElement>[
    ElIconPathElement('M12 18V5'), // key: adv99a
    ElIconPathElement(
      'M15 13a4.17 4.17 0 0 1-3-4 4.17 4.17 0 0 1-3 4',
    ), // key: 1e3is1
    ElIconPathElement(
      'M17.598 6.5A3 3 0 1 0 12 5a3 3 0 1 0-5.598 1.5',
    ), // key: 1gqd8o
    ElIconPathElement('M17.997 5.125a4 4 0 0 1 2.526 5.77'), // key: iwvgf7
    ElIconPathElement('M18 18a4 4 0 0 0 2-7.464'), // key: efp6ie
    ElIconPathElement(
      'M19.967 17.483A4 4 0 1 1 12 18a4 4 0 1 1-7.967-.517',
    ), // key: 1gq6am
    ElIconPathElement('M6 18a4 4 0 0 1-2-7.464'), // key: k1g0md
    ElIconPathElement('M6.003 5.125a4 4 0 0 0-2.526 5.77'), // key: q97ue3
  ]);

  /// `brick-wall-fire.mjs`
  static const ElLucideGlyph
  brickWallFire = ElLucideGlyph('brick-wall-fire', <ElIconElement>[
    ElIconPathElement('M16 3v2.107'), // key: gq8xun
    ElIconPathElement(
      'M17 9c1 3 2.5 3.5 3.5 4.5A5 5 0 0 1 22 17a5 5 0 0 1-10 0c0-.3 0-.6.1-.9a2 2 0 1 0 3.3-2C13 11.5 16 9 17 9',
    ), // key: 1l2pih
    ElIconPathElement(
      'M21 8.274V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h3.938',
    ), // key: jrnqjp
    ElIconPathElement('M3 15h5.253'), // key: xqg7rb
    ElIconPathElement('M3 9h8.228'), // key: 1ppb70
    ElIconPathElement('M8 15v6'), // key: 1stoo3
    ElIconPathElement('M8 3v6'), // key: vlvjmk
  ]);

  /// `brick-wall-shield.mjs`
  static const ElLucideGlyph
  brickWallShield = ElLucideGlyph('brick-wall-shield', <ElIconElement>[
    ElIconPathElement('M12 9v1.258'), // key: iwpddn
    ElIconPathElement('M16 3v5.46'), // key: d7ew98
    ElIconPathElement(
      'M21 9.118V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h5.75',
    ), // key: 137t5x
    ElIconPathElement(
      'M22 17.5c0 2.499-1.75 3.749-3.83 4.474a.5.5 0 0 1-.335-.005c-2.085-.72-3.835-1.97-3.835-4.47V14a.5.5 0 0 1 .5-.499c1 0 2.25-.6 3.12-1.36a.6.6 0 0 1 .76-.001c.875.765 2.12 1.36 3.12 1.36a.5.5 0 0 1 .5.5z',
    ), // key: 16j3tf
    ElIconPathElement('M3 15h7'), // key: 1qldh6
    ElIconPathElement('M3 9h12.142'), // key: 1yjd6m
    ElIconPathElement('M8 15v6'), // key: 1stoo3
    ElIconPathElement('M8 3v6'), // key: vlvjmk
  ]);

  /// `brick-wall.mjs`
  static const ElLucideGlyph brickWall = ElLucideGlyph(
    'brick-wall',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M12 9v6'), // key: 199k2o
      ElIconPathElement('M16 15v6'), // key: 8rj2es
      ElIconPathElement('M16 3v6'), // key: 1j6rpj
      ElIconPathElement('M3 15h18'), // key: 5xshup
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('M8 15v6'), // key: 1stoo3
      ElIconPathElement('M8 3v6'), // key: vlvjmk
    ],
  );

  /// `briefcase-business.mjs`
  static const ElLucideGlyph briefcaseBusiness = ElLucideGlyph(
    'briefcase-business',
    <ElIconElement>[
      ElIconPathElement('M12 12h.01'), // key: 1mp3jc
      ElIconPathElement(
        'M16 6V4a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2',
      ), // key: 1ksdt3
      ElIconPathElement('M22 13a18.15 18.15 0 0 1-20 0'), // key: 12hx5q
      ElIconRectElement(2, 6, 20, 14, 2), // key: i6l2r4
    ],
  );

  /// `briefcase-conveyor-belt.mjs`
  static const ElLucideGlyph briefcaseConveyorBelt = ElLucideGlyph(
    'briefcase-conveyor-belt',
    <ElIconElement>[
      ElIconPathElement('M10 20v2'), // key: 1n8e1g
      ElIconPathElement('M14 20v2'), // key: 1lq872
      ElIconPathElement('M18 20v2'), // key: 10uadw
      ElIconPathElement('M21 20H3'), // key: kdqkdp
      ElIconPathElement('M6 20v2'), // key: a9bc87
      ElIconPathElement(
        'M8 16V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v12',
      ), // key: 17n9tx
      ElIconRectElement(4, 6, 16, 10, 2), // key: 1097i5
    ],
  );

  /// `briefcase-medical.mjs`
  static const ElLucideGlyph briefcaseMedical = ElLucideGlyph(
    'briefcase-medical',
    <ElIconElement>[
      ElIconPathElement('M12 11v4'), // key: a6ujw6
      ElIconPathElement('M14 13h-4'), // key: 1pl8zg
      ElIconPathElement(
        'M16 6V4a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2',
      ), // key: 1ksdt3
      ElIconPathElement('M18 6v14'), // key: 1mu4gy
      ElIconPathElement('M6 6v14'), // key: 1s15cj
      ElIconRectElement(2, 6, 20, 14, 2), // key: i6l2r4
    ],
  );

  /// `briefcase.mjs`
  static const ElLucideGlyph briefcase = ElLucideGlyph(
    'briefcase',
    <ElIconElement>[
      ElIconPathElement(
        'M16 20V4a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16',
      ), // key: jecpp
      ElIconRectElement(2, 6, 20, 14, 2), // key: i6l2r4
    ],
  );

  /// `bring-to-front.mjs`
  static const ElLucideGlyph bringToFront = ElLucideGlyph(
    'bring-to-front',
    <ElIconElement>[
      ElIconRectElement(8, 8, 8, 8, 2), // key: yj20xf
      ElIconPathElement(
        'M4 10a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2',
      ), // key: 1ltk23
      ElIconPathElement(
        'M14 20a2 2 0 0 0 2 2h4a2 2 0 0 0 2-2v-4a2 2 0 0 0-2-2',
      ), // key: 1q24h9
    ],
  );

  /// `broccoli.mjs`
  static const ElLucideGlyph
  broccoli = ElLucideGlyph('broccoli', <ElIconElement>[
    ElIconPathElement('M10 13a3 3 0 0 1-2.121-5.121'), // key: 1oqad0
    ElIconPathElement(
      'M15.606 14.204c-3.5 1.5-5.899 4.503-8.899 7.503A1 1 0 0 1 6 22c-2 0-4-2-4-4a1 1 0 0 1 .293-.707c1.911-1.911 3.823-3.578 5.347-5.441',
    ), // key: c93qjr
    ElIconPathElement('M16.573 14.737A4 4 0 0 1 14 11'), // key: 1ymr17
    ElIconPathElement(
      'M7.14 10.907a4 4 0 1 1 2.756-7.43A4 4 0 0 1 16.7 4.48a2 2 0 0 1 2.82 2.82 4 4 0 0 1 1.002 6.805A4 4 0 1 1 13 16',
    ), // key: 1kbgad
  ]);

  /// `brush-cleaning.mjs`
  static const ElLucideGlyph
  brushCleaning = ElLucideGlyph('brush-cleaning', <ElIconElement>[
    ElIconPathElement('m16 22-1-4'), // key: 1ow2iv
    ElIconPathElement(
      'M19 14a1 1 0 0 0 1-1v-1a2 2 0 0 0-2-2h-3a1 1 0 0 1-1-1V4a2 2 0 0 0-4 0v5a1 1 0 0 1-1 1H6a2 2 0 0 0-2 2v1a1 1 0 0 0 1 1',
    ), // key: 11gii7
    ElIconPathElement(
      'M19 14H5l-1.973 6.767A1 1 0 0 0 4 22h16a1 1 0 0 0 .973-1.233z',
    ), // key: bju7h4
    ElIconPathElement('m8 22 1-4'), // key: s3unb
  ]);

  /// `brush.mjs`
  static const ElLucideGlyph brush = ElLucideGlyph('brush', <ElIconElement>[
    ElIconPathElement('m11 10 3 3'), // key: fzmg1i
    ElIconPathElement(
      'M6.5 21A3.5 3.5 0 1 0 3 17.5a2.62 2.62 0 0 1-.708 1.792A1 1 0 0 0 3 21z',
    ), // key: p4q2r7
    ElIconPathElement(
      'M9.969 17.031 21.378 5.624a1 1 0 0 0-3.002-3.002L6.967 14.031',
    ), // key: wy6l02
  ]);

  /// `bubbles.mjs`
  static const ElLucideGlyph bubbles = ElLucideGlyph('bubbles', <ElIconElement>[
    ElIconPathElement('M7.001 15.085A1.5 1.5 0 0 1 9 16.5'), // key: y44lvh
    ElIconCircleElement(18.5, 8.5, 3.5), // key: 1wadoa
    ElIconCircleElement(7.5, 16.5, 5.5), // key: 6mdt3g
    ElIconCircleElement(7.5, 4.5, 2.5), // key: 637s54
  ]);

  /// `bug-off.mjs`
  static const ElLucideGlyph bugOff = ElLucideGlyph('bug-off', <ElIconElement>[
    ElIconPathElement('M12 20v-8'), // key: i3yub9
    ElIconPathElement('M12.656 7H14a4 4 0 0 1 4 4v1.344'), // key: vvueyn
    ElIconPathElement('M14.12 3.88 16 2'), // key: qol33r
    ElIconPathElement(
      'M17.123 17.123A6 6 0 0 1 6 14v-3a4 4 0 0 1 1.72-3.287',
    ), // key: 1cu21y
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement('M21 5a4 4 0 0 1-3.55 3.97'), // key: 5cxbf6
    ElIconPathElement('M22 13h-3.344'), // key: qb08am
    ElIconPathElement('M3 21a4 4 0 0 1 3.81-4'), // key: 1fjd4g
    ElIconPathElement('M3 5a4 4 0 0 0 3.55 3.97'), // key: 1d7oge
    ElIconPathElement('M6 13H2'), // key: 82j7cp
    ElIconPathElement('m8 2 1.88 1.88'), // key: fmnt4t
    ElIconPathElement('M9.712 4.06A3 3 0 0 1 15 6v1.13'), // key: 1bvup6
  ]);

  /// `bug-play.mjs`
  static const ElLucideGlyph
  bugPlay = ElLucideGlyph('bug-play', <ElIconElement>[
    ElIconPathElement(
      'M10 19.655A6 6 0 0 1 6 14v-3a4 4 0 0 1 4-4h4a4 4 0 0 1 4 3.97',
    ), // key: 1gnv52
    ElIconPathElement(
      'M14 15.003a1 1 0 0 1 1.517-.859l4.997 2.997a1 1 0 0 1 0 1.718l-4.997 2.997a1 1 0 0 1-1.517-.86z',
    ), // key: 1weqy9
    ElIconPathElement('M14.12 3.88 16 2'), // key: qol33r
    ElIconPathElement('M21 5a4 4 0 0 1-3.55 3.97'), // key: 5cxbf6
    ElIconPathElement('M3 21a4 4 0 0 1 3.81-4'), // key: 1fjd4g
    ElIconPathElement('M3 5a4 4 0 0 0 3.55 3.97'), // key: 1d7oge
    ElIconPathElement('M6 13H2'), // key: 82j7cp
    ElIconPathElement('m8 2 1.88 1.88'), // key: fmnt4t
    ElIconPathElement('M9 7.13V6a3 3 0 1 1 6 0v1.13'), // key: 1vgav8
  ]);

  /// `bug.mjs`
  static const ElLucideGlyph bug = ElLucideGlyph('bug', <ElIconElement>[
    ElIconPathElement('M12 20v-9'), // key: 1qisl0
    ElIconPathElement(
      'M14 7a4 4 0 0 1 4 4v3a6 6 0 0 1-12 0v-3a4 4 0 0 1 4-4z',
    ), // key: uouzyp
    ElIconPathElement('M14.12 3.88 16 2'), // key: qol33r
    ElIconPathElement('M21 21a4 4 0 0 0-3.81-4'), // key: 1b0z45
    ElIconPathElement('M21 5a4 4 0 0 1-3.55 3.97'), // key: 5cxbf6
    ElIconPathElement('M22 13h-4'), // key: 1jl80f
    ElIconPathElement('M3 21a4 4 0 0 1 3.81-4'), // key: 1fjd4g
    ElIconPathElement('M3 5a4 4 0 0 0 3.55 3.97'), // key: 1d7oge
    ElIconPathElement('M6 13H2'), // key: 82j7cp
    ElIconPathElement('m8 2 1.88 1.88'), // key: fmnt4t
    ElIconPathElement('M9 7.13V6a3 3 0 1 1 6 0v1.13'), // key: 1vgav8
  ]);

  /// `building-2.mjs`
  static const ElLucideGlyph
  building2 = ElLucideGlyph('building-2', <ElIconElement>[
    ElIconPathElement('M10 12h4'), // key: a56b0p
    ElIconPathElement('M10 8h4'), // key: 1sr2af
    ElIconPathElement('M14 21v-3a2 2 0 0 0-4 0v3'), // key: 1rgiei
    ElIconPathElement(
      'M6 10H4a2 2 0 0 0-2 2v7a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-2',
    ), // key: secmi2
    ElIconPathElement(
      'M6 21V5a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v16',
    ), // key: 16ra0t
  ]);

  /// `building.mjs`
  static const ElLucideGlyph building = ElLucideGlyph(
    'building',
    <ElIconElement>[
      ElIconPathElement('M12 10h.01'), // key: 1nrarc
      ElIconPathElement('M12 14h.01'), // key: 1etili
      ElIconPathElement('M12 6h.01'), // key: 1vi96p
      ElIconPathElement('M16 10h.01'), // key: 1m94wz
      ElIconPathElement('M16 14h.01'), // key: 1gbofw
      ElIconPathElement('M16 6h.01'), // key: 1x0f13
      ElIconPathElement('M8 10h.01'), // key: 19clt8
      ElIconPathElement('M8 14h.01'), // key: 6423bh
      ElIconPathElement('M8 6h.01'), // key: 1dz90k
      ElIconPathElement(
        'M9 22v-3a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v3',
      ), // key: cabbwy
      ElIconRectElement(4, 2, 16, 20, 2), // key: 1uxh74
    ],
  );

  /// `bus-front.mjs`
  static const ElLucideGlyph busFront = ElLucideGlyph(
    'bus-front',
    <ElIconElement>[
      ElIconPathElement('M4 6 2 7'), // key: 1mqr15
      ElIconPathElement('M10 6h4'), // key: 1itunk
      ElIconPathElement('m22 7-2-1'), // key: 1umjhc
      ElIconRectElement(4, 3, 16, 16, 2), // key: 1wxw4b
      ElIconPathElement('M4 11h16'), // key: mpoxn0
      ElIconPathElement('M8 15h.01'), // key: a7atzg
      ElIconPathElement('M16 15h.01'), // key: rnfrdf
      ElIconPathElement('M6 19v2'), // key: 1loha6
      ElIconPathElement('M18 21v-2'), // key: sqyl04
    ],
  );

  /// `bus.mjs`
  static const ElLucideGlyph bus = ElLucideGlyph('bus', <ElIconElement>[
    ElIconPathElement('M8 6v6'), // key: 18i7km
    ElIconPathElement('M15 6v6'), // key: 1sg6z9
    ElIconPathElement('M2 12h19.6'), // key: de5uta
    ElIconPathElement(
      'M18 18h3s.5-1.7.8-2.8c.1-.4.2-.8.2-1.2 0-.4-.1-.8-.2-1.2l-1.4-5C20.1 6.8 19.1 6 18 6H4a2 2 0 0 0-2 2v10h3',
    ), // key: 1wwztk
    ElIconCircleElement(7, 18, 2), // key: 19iecd
    ElIconPathElement('M9 18h5'), // key: lrx6i
    ElIconCircleElement(16, 18, 2), // key: 1v4tcr
  ]);

  /// `cable-car.mjs`
  static const ElLucideGlyph cableCar = ElLucideGlyph(
    'cable-car',
    <ElIconElement>[
      ElIconPathElement('M10 3h.01'), // key: lbucoy
      ElIconPathElement('M14 2h.01'), // key: 1k8aa1
      ElIconPathElement('m2 9 20-5'), // key: 1kz0j5
      ElIconPathElement('M12 12V6.5'), // key: 1vbrij
      ElIconRectElement(4, 12, 16, 10, 3), // key: if91er
      ElIconPathElement('M9 12v5'), // key: 3anwtq
      ElIconPathElement('M15 12v5'), // key: 5xh3zn
      ElIconPathElement('M4 17h16'), // key: g4d7ey
    ],
  );

  /// `cable.mjs`
  static const ElLucideGlyph cable = ElLucideGlyph('cable', <ElIconElement>[
    ElIconPathElement(
      'M17 19a1 1 0 0 1-1-1v-2a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2a1 1 0 0 1-1 1z',
    ), // key: trhst0
    ElIconPathElement('M17 21v-2'), // key: ds4u3f
    ElIconPathElement(
      'M19 14V6.5a1 1 0 0 0-7 0v11a1 1 0 0 1-7 0V10',
    ), // key: 1mo9zo
    ElIconPathElement('M21 21v-2'), // key: eo0ou
    ElIconPathElement('M3 5V3'), // key: 1k5hjh
    ElIconPathElement(
      'M4 10a2 2 0 0 1-2-2V6a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2a2 2 0 0 1-2 2z',
    ), // key: 1dd30t
    ElIconPathElement('M7 5V3'), // key: 1t1388
  ]);

  /// `cake-slice.mjs`
  static const ElLucideGlyph
  cakeSlice = ElLucideGlyph('cake-slice', <ElIconElement>[
    ElIconPathElement('M16 13H3'), // key: 1wpj08
    ElIconPathElement('M16 17H3'), // key: 3lvfcd
    ElIconPathElement(
      'm7.2 7.9-3.388 2.5A2 2 0 0 0 3 12.01V20a1 1 0 0 0 1 1h16a1 1 0 0 0 1-1v-8.654c0-2-2.44-6.026-6.44-8.026a1 1 0 0 0-1.082.057L10.4 5.6',
    ), // key: 1gmhf7
    ElIconCircleElement(9, 7, 2), // key: 1305pl
  ]);

  /// `cake.mjs`
  static const ElLucideGlyph cake = ElLucideGlyph('cake', <ElIconElement>[
    ElIconPathElement(
      'M20 21v-8a2 2 0 0 0-2-2H6a2 2 0 0 0-2 2v8',
    ), // key: 1w3rig
    ElIconPathElement(
      'M4 16s.5-1 2-1 2.5 2 4 2 2.5-2 4-2 2.5 2 4 2 2-1 2-1',
    ), // key: n2jgmb
    ElIconPathElement('M2 21h20'), // key: 1nyx9w
    ElIconPathElement('M7 8v3'), // key: 1qtyvj
    ElIconPathElement('M12 8v3'), // key: hwp4zt
    ElIconPathElement('M17 8v3'), // key: 1i6e5u
    ElIconPathElement('M7 4h.01'), // key: 1bh4kh
    ElIconPathElement('M12 4h.01'), // key: 1ujb9j
    ElIconPathElement('M17 4h.01'), // key: 1upcoc
  ]);

  /// `calculator.mjs`
  static const ElLucideGlyph calculator = ElLucideGlyph(
    'calculator',
    <ElIconElement>[
      ElIconRectElement(4, 2, 16, 20, 2), // key: 1nb95v
      ElIconLineElement(8, 6, 16, 6), // key: x4nwl0
      ElIconLineElement(16, 14, 16, 18), // key: wjye3r
      ElIconPathElement('M16 10h.01'), // key: 1m94wz
      ElIconPathElement('M12 10h.01'), // key: 1nrarc
      ElIconPathElement('M8 10h.01'), // key: 19clt8
      ElIconPathElement('M12 14h.01'), // key: 1etili
      ElIconPathElement('M8 14h.01'), // key: 6423bh
      ElIconPathElement('M12 18h.01'), // key: mhygvu
      ElIconPathElement('M8 18h.01'), // key: lrp35t
    ],
  );

  /// `calendar-1.mjs`
  static const ElLucideGlyph calendar1 = ElLucideGlyph(
    'calendar-1',
    <ElIconElement>[
      ElIconPathElement('M11 13h1v4'), // key: 10p4bv
      ElIconPathElement('M16 2v3'), // key: otl347
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('M8 2v3'), // key: 1ioesn
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `calendar-arrow-down.mjs`
  static const ElLucideGlyph calendarArrowDown = ElLucideGlyph(
    'calendar-arrow-down',
    <ElIconElement>[
      ElIconPathElement('m14 17 4 4 4-4'), // key: 17qdjf
      ElIconPathElement('M16 2v3'), // key: otl347
      ElIconPathElement('M18 13v8'), // key: 1a00n0
      ElIconPathElement(
        'M21 10.354V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h7.343',
      ), // key: 1qsorh
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('M8 2v3'), // key: 1ioesn
    ],
  );

  /// `calendar-arrow-up.mjs`
  static const ElLucideGlyph calendarArrowUp = ElLucideGlyph(
    'calendar-arrow-up',
    <ElIconElement>[
      ElIconPathElement('m14 17 4-4 4 4'), // key: 1qa3u6
      ElIconPathElement('M16 2v3'), // key: otl347
      ElIconPathElement('M18 21v-8'), // key: 1ao88k
      ElIconPathElement(
        'M21 10.343V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h9',
      ), // key: 185mot
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('M8 2v3'), // key: 1ioesn
    ],
  );

  /// `calendar-check-2.mjs`
  static const ElLucideGlyph calendarCheck2 = ElLucideGlyph(
    'calendar-check-2',
    <ElIconElement>[
      ElIconPathElement('M 19 3 L 5 3'), // key: 1xn3iy
      ElIconPathElement('M 21 13 L 21 5'), // key: 102s58
      ElIconPathElement('M 21 5 A2 2 0 0 0 19 3'), // key: 1xylja
      ElIconPathElement('M 3 19 A2 2 0 0 0 5 21'), // key: 19jxbv
      ElIconPathElement('M 3 5 L 3 19'), // key: 1yylhw
      ElIconPathElement('M 5 3 A2 2 0 0 0 3 5'), // key: 164twa
      ElIconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
      ElIconPathElement('M16 2v3'), // key: otl347
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('M5 21 L12.5 21'), // key: 1n38e0
      ElIconPathElement('M8 2v3'), // key: 1ioesn
    ],
  );

  /// `calendar-check.mjs`
  static const ElLucideGlyph calendarCheck = ElLucideGlyph(
    'calendar-check',
    <ElIconElement>[
      ElIconPathElement('M8 2v3'), // key: 1ioesn
      ElIconPathElement('M16 2v3'), // key: otl347
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('m9 15 2 2 4-4'), // key: 1grp1n
    ],
  );

  /// `calendar-clock.mjs`
  static const ElLucideGlyph calendarClock = ElLucideGlyph(
    'calendar-clock',
    <ElIconElement>[
      ElIconPathElement('M16 14v2.2l1.6 1'), // key: fo4ql5
      ElIconPathElement('M16 2v3'), // key: otl347
      ElIconPathElement(
        'M21 7.338V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h2.338',
      ), // key: 7hb8p4
      ElIconPathElement('M3 9h5.859'), // key: numkqi
      ElIconPathElement('M8 2v3'), // key: 1ioesn
      ElIconCircleElement(16, 16, 6), // key: qoo3c4
    ],
  );

  /// `calendar-cog.mjs`
  static const ElLucideGlyph calendarCog = ElLucideGlyph(
    'calendar-cog',
    <ElIconElement>[
      ElIconPathElement('m15.228 16.852-.923-.383'), // key: npixar
      ElIconPathElement('m15.228 19.148-.923.383'), // key: 51cr3n
      ElIconPathElement('M16 2v3'), // key: otl347
      ElIconPathElement('m16.47 14.305.382.923'), // key: obybxd
      ElIconPathElement('m16.852 20.772-.383.924'), // key: dpfhf9
      ElIconPathElement('m19.148 15.228.383-.923'), // key: 1reyyz
      ElIconPathElement('m19.53 21.696-.382-.924'), // key: 1goivc
      ElIconPathElement('m20.773 16.852.924-.383'), // key: ybmb4k
      ElIconPathElement('m20.773 19.148.924.383'), // key: 1c2d3p
      ElIconPathElement(
        'M21 10.5V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h5.5',
      ), // key: 1e6z1y
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('M8 2v3'), // key: 1ioesn
      ElIconCircleElement(18, 18, 3), // key: 1xkwt0
    ],
  );

  /// `calendar-days.mjs`
  static const ElLucideGlyph calendarDays = ElLucideGlyph(
    'calendar-days',
    <ElIconElement>[
      ElIconPathElement('M8 2v3'), // key: 1ioesn
      ElIconPathElement('M16 2v3'), // key: otl347
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('M8 13h.01'), // key: 1sbv64
      ElIconPathElement('M12 13h.01'), // key: y0uutt
      ElIconPathElement('M16 13h.01'), // key: wip0gl
      ElIconPathElement('M8 17h.01'), // key: p3bg7i
      ElIconPathElement('M12 17h.01'), // key: p32p05
      ElIconPathElement('M16 17h.01'), // key: ql8jdd
    ],
  );

  /// `calendar-fold.mjs`
  static const ElLucideGlyph
  calendarFold = ElLucideGlyph('calendar-fold', <ElIconElement>[
    ElIconPathElement('M16 2v3'), // key: otl347
    ElIconPathElement(
      'M21 15V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h10v-5a1 1 0 011-1za2.4 2.4 0 01-.706 1.706l-3.588 3.588A2.4 2.4 0 0115 21',
    ), // key: 4uit17
    ElIconPathElement('M3 9h18'), // key: 1pudct
    ElIconPathElement('M8 2v3'), // key: 1ioesn
  ]);

  /// `calendar-heart.mjs`
  static const ElLucideGlyph
  calendarHeart = ElLucideGlyph('calendar-heart', <ElIconElement>[
    ElIconPathElement(
      'M12.127 21H5a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v5.125',
    ), // key: 1fsxpc
    ElIconPathElement(
      'M14.62 17.8A2.25 2.25 0 1118 14.836a2.25 2.25 0 113.38 2.966l-2.626 2.856a.998.998 0 01-1.507 0z',
    ), // key: 1gk3ue
    ElIconPathElement('M16 2v3'), // key: otl347
    ElIconPathElement('M3 9h18'), // key: 1pudct
    ElIconPathElement('M8 2v3'), // key: 1ioesn
  ]);

  /// `calendar-minus-2.mjs`
  static const ElLucideGlyph calendarMinus2 = ElLucideGlyph(
    'calendar-minus-2',
    <ElIconElement>[
      ElIconPathElement('M8 2v3'), // key: 1ioesn
      ElIconPathElement('M16 2v3'), // key: otl347
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('M10 15h4'), // key: 192ueg
    ],
  );

  /// `calendar-minus.mjs`
  static const ElLucideGlyph calendarMinus = ElLucideGlyph(
    'calendar-minus',
    <ElIconElement>[
      ElIconPathElement('M16 18h6'), // key: 987eiv
      ElIconPathElement('M16 2v3'), // key: otl347
      ElIconPathElement(
        'M21 14V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h8.3',
      ), // key: gcu0od
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('M8 2v3'), // key: 1ioesn
    ],
  );

  /// `calendar-off.mjs`
  static const ElLucideGlyph calendarOff = ElLucideGlyph(
    'calendar-off',
    <ElIconElement>[
      ElIconPathElement('M16 2v3'), // key: otl347
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
      ElIconPathElement('M21 9h-5.5'), // key: 1g344v
      ElIconPathElement('M3 9h6'), // key: 1q2djq
      ElIconPathElement(
        'M3.586 3.586A2 2 0 003 5v14a2 2 0 002 2h14a2 2 0 001.414-.586',
      ), // key: 1g7ltu
      ElIconPathElement('M8.656 3H19a2 2 0 012 2v10.344'), // key: 1bwpd1
    ],
  );

  /// `calendar-plus-2.mjs`
  static const ElLucideGlyph calendarPlus2 = ElLucideGlyph(
    'calendar-plus-2',
    <ElIconElement>[
      ElIconPathElement('M8 2v3'), // key: 1ioesn
      ElIconPathElement('M16 2v3'), // key: otl347
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('M10 15h4'), // key: 192ueg
      ElIconPathElement('M12 13v4'), // key: 1il4po
    ],
  );

  /// `calendar-plus.mjs`
  static const ElLucideGlyph calendarPlus = ElLucideGlyph(
    'calendar-plus',
    <ElIconElement>[
      ElIconPathElement('M16 18h6'), // key: 987eiv
      ElIconPathElement('M16 2v3'), // key: otl347
      ElIconPathElement('M19 15v6'), // key: 10aioa
      ElIconPathElement(
        'M21 11.5V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h8.3',
      ), // key: jgwkxf
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('M8 2v3'), // key: 1ioesn
    ],
  );

  /// `calendar-range.mjs`
  static const ElLucideGlyph calendarRange = ElLucideGlyph(
    'calendar-range',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
      ElIconPathElement('M16 2v3'), // key: otl347
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('M8 2v3'), // key: 1ioesn
      ElIconPathElement('M17 13h-6'), // key: 1qbiup
      ElIconPathElement('M13 17H7'), // key: 1x38vv
      ElIconPathElement('M7 13h.01'), // key: 1vezk1
      ElIconPathElement('M17 17h.01'), // key: 1sd3ek
    ],
  );

  /// `calendar-search.mjs`
  static const ElLucideGlyph calendarSearch = ElLucideGlyph(
    'calendar-search',
    <ElIconElement>[
      ElIconPathElement('M16 2v3'), // key: otl347
      ElIconPathElement(
        'M21 10.69V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h7.25',
      ), // key: h6gkkz
      ElIconPathElement('m22 21-1.875-1.875'), // key: 1dzjql
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('M8 2v3'), // key: 1ioesn
      ElIconCircleElement(18, 17, 3), // key: 1hty4x
    ],
  );

  /// `calendar-sync.mjs`
  static const ElLucideGlyph calendarSync = ElLucideGlyph(
    'calendar-sync',
    <ElIconElement>[
      ElIconPathElement('M11 10v4h4'), // key: 172dkj
      ElIconPathElement('m11 14 1.535-1.605a5 5 0 018 1.5'), // key: jekqcd
      ElIconPathElement('M16 2v3'), // key: otl347
      ElIconPathElement('m21 18-1.535 1.605a5 5 0 01-8-1.5'), // key: n107hu
      ElIconPathElement('M21 22v-4h-4'), // key: hrummi
      ElIconPathElement(
        'M21 8.517V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h3.517',
      ), // key: yafrba
      ElIconPathElement('M3 9h4'), // key: rnfnj5
      ElIconPathElement('M8 2v3'), // key: 1ioesn
    ],
  );

  /// `calendar-x-2.mjs`
  static const ElLucideGlyph calendarX2 = ElLucideGlyph(
    'calendar-x-2',
    <ElIconElement>[
      ElIconPathElement('M16 2v3'), // key: otl347
      ElIconPathElement('m17 16 5 5'), // key: 1a37d9
      ElIconPathElement('m17 21 5-5'), // key: 1b797a
      ElIconPathElement(
        'M21 12V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h8',
      ), // key: 14ws7l
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('M8 2v3'), // key: 1ioesn
    ],
  );

  /// `calendar-x.mjs`
  static const ElLucideGlyph calendarX = ElLucideGlyph(
    'calendar-x',
    <ElIconElement>[
      ElIconPathElement('M8 2v3'), // key: 1ioesn
      ElIconPathElement('M16 2v3'), // key: otl347
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('m14 13-4 4'), // key: 1gib57
      ElIconPathElement('m10 13 4 4'), // key: 153uiq
    ],
  );

  /// `calendar.mjs`
  static const ElLucideGlyph calendar = ElLucideGlyph(
    'calendar',
    <ElIconElement>[
      ElIconPathElement('M8 2v3'), // key: 1ioesn
      ElIconPathElement('M16 2v3'), // key: otl347
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
      ElIconPathElement('M3 9h18'), // key: 1pudct
    ],
  );

  /// `calendars.mjs`
  static const ElLucideGlyph calendars = ElLucideGlyph(
    'calendars',
    <ElIconElement>[
      ElIconPathElement('M12 2v2'), // key: tus03m
      ElIconPathElement(
        'M15.726 21.01A2 2 0 0 1 14 22H4a2 2 0 0 1-2-2V10a2 2 0 0 1 2-2',
      ), // key: j6srht
      ElIconPathElement('M18 2v2'), // key: 1kh14s
      ElIconPathElement('M2 13h2'), // key: 13gyu8
      ElIconPathElement('M8 8h14'), // key: 12jxz2
      ElIconRectElement(8, 3, 14, 14, 2), // key: nsru6w
    ],
  );

  /// `camera-off.mjs`
  static const ElLucideGlyph
  cameraOff = ElLucideGlyph('camera-off', <ElIconElement>[
    ElIconPathElement('M14.564 14.558a3 3 0 1 1-4.122-4.121'), // key: 1rnrzw
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement(
      'M20 20H4a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2h1.997a2 2 0 0 0 .819-.175',
    ), // key: 1x3arw
    ElIconPathElement(
      'M9.695 4.024A2 2 0 0 1 10.004 4h3.993a2 2 0 0 1 1.76 1.05l.486.9A2 2 0 0 0 18.003 7H20a2 2 0 0 1 2 2v7.344',
    ), // key: 1i84u0
  ]);

  /// `camera.mjs`
  static const ElLucideGlyph camera = ElLucideGlyph('camera', <ElIconElement>[
    ElIconPathElement(
      'M13.997 4a2 2 0 0 1 1.76 1.05l.486.9A2 2 0 0 0 18.003 7H20a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2h1.997a2 2 0 0 0 1.759-1.048l.489-.904A2 2 0 0 1 10.004 4z',
    ), // key: 18u6gg
    ElIconCircleElement(12, 13, 3), // key: 1vg3eu
  ]);

  /// `candy-cane.mjs`
  static const ElLucideGlyph
  candyCane = ElLucideGlyph('candy-cane', <ElIconElement>[
    ElIconPathElement('m10.8 5 2.111 4.223'), // key: 11kb8w
    ElIconPathElement('M17.75 7 15 2.1'), // key: 12x7e8
    ElIconPathElement('m4.874 14.647 2.12 4.24'), // key: ccpt4b
    ElIconPathElement(
      'M5.7 21a2 2 0 0 1-3.5-2l8.6-14a6 6 0 0 1 10.4 6 2 2 0 1 1-3.464-2 2 2 0 1 0-3.464-2z',
    ), // key: u5e8z4
    ElIconPathElement('m7.906 9.712 2.005 4.411'), // key: 1k0qph
  ]);

  /// `candy-off.mjs`
  static const ElLucideGlyph
  candyOff = ElLucideGlyph('candy-off', <ElIconElement>[
    ElIconPathElement('M10 10v7.9'), // key: m8g9tt
    ElIconPathElement('M11.802 6.145a5 5 0 0 1 6.053 6.053'), // key: dn87i3
    ElIconPathElement('M14 6.1v2.243'), // key: 1kzysn
    ElIconPathElement(
      'm15.5 15.571-.964.964a5 5 0 0 1-7.071 0 5 5 0 0 1 0-7.07l.964-.965',
    ), // key: 3sxy18
    ElIconPathElement(
      'M16 7V3a1 1 0 0 1 1.707-.707 2.5 2.5 0 0 0 2.152.717 1 1 0 0 1 1.131 1.131 2.5 2.5 0 0 0 .717 2.152A1 1 0 0 1 21 8h-4',
    ), // key: gpb6xx
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement(
      'M8 17v4a1 1 0 0 1-1.707.707 2.5 2.5 0 0 0-2.152-.717 1 1 0 0 1-1.131-1.131 2.5 2.5 0 0 0-.717-2.152A1 1 0 0 1 3 16h4',
    ), // key: qexcha
  ]);

  /// `candy.mjs`
  static const ElLucideGlyph candy = ElLucideGlyph('candy', <ElIconElement>[
    ElIconPathElement('M10 7v10.9'), // key: 1gynux
    ElIconPathElement('M14 6.1V17'), // key: 116kdf
    ElIconPathElement(
      'M16 7V3a1 1 0 0 1 1.707-.707 2.5 2.5 0 0 0 2.152.717 1 1 0 0 1 1.131 1.131 2.5 2.5 0 0 0 .717 2.152A1 1 0 0 1 21 8h-4',
    ), // key: gpb6xx
    ElIconPathElement(
      'M16.536 7.465a5 5 0 0 0-7.072 0l-2 2a5 5 0 0 0 0 7.07 5 5 0 0 0 7.072 0l2-2a5 5 0 0 0 0-7.07',
    ), // key: 1tsln4
    ElIconPathElement(
      'M8 17v4a1 1 0 0 1-1.707.707 2.5 2.5 0 0 0-2.152-.717 1 1 0 0 1-1.131-1.131 2.5 2.5 0 0 0-.717-2.152A1 1 0 0 1 3 16h4',
    ), // key: qexcha
  ]);

  /// `cannabis-off.mjs`
  static const ElLucideGlyph
  cannabisOff = ElLucideGlyph('cannabis-off', <ElIconElement>[
    ElIconPathElement(
      'M12 22v-4c1.5 1.5 3.5 3 6 3 0-1.5-.5-3.5-2-5',
    ), // key: 1bqfb7
    ElIconPathElement(
      'M13.988 8.327C13.902 6.054 13.365 3.82 12 2a9.3 9.3 0 0 0-1.445 2.9',
    ), // key: 1p520n
    ElIconPathElement(
      'M17.375 11.725C18.882 10.53 21 7.841 21 6c-2.324 0-5.08 1.296-6.662 2.684',
    ), // key: q2itvb
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement(
      'M21.024 15.378A15 15 0 0 0 22 15c-.426-1.279-2.67-2.557-4.25-2.907',
    ), // key: j9amvs
    ElIconPathElement(
      'M6.995 6.992C5.714 6.4 4.29 6 3 6c0 2 2.5 5 4 6-1.5 0-4.5 1.5-5 3 3.5 1.5 6 1 6 1-1.5 1.5-2 3.5-2 5 2.5 0 4.5-1.5 6-3',
    ), // key: 8gmd5g
  ]);

  /// `cannabis.mjs`
  static const ElLucideGlyph
  cannabis = ElLucideGlyph('cannabis', <ElIconElement>[
    ElIconPathElement('M12 22v-4'), // key: 1utk9m
    ElIconPathElement(
      'M7 12c-1.5 0-4.5 1.5-5 3 3.5 1.5 6 1 6 1-1.5 1.5-2 3.5-2 5 2.5 0 4.5-1.5 6-3 1.5 1.5 3.5 3 6 3 0-1.5-.5-3.5-2-5 0 0 2.5.5 6-1-.5-1.5-3.5-3-5-3 1.5-1 4-4 4-6-2.5 0-5.5 1.5-7 3 0-2.5-.5-5-2-7-1.5 2-2 4.5-2 7-1.5-1.5-4.5-3-7-3 0 2 2.5 5 4 6',
    ), // key: 1mezod
  ]);

  /// `captions-off.mjs`
  static const ElLucideGlyph
  captionsOff = ElLucideGlyph('captions-off', <ElIconElement>[
    ElIconPathElement('M10.5 5H19a2 2 0 0 1 2 2v8.5'), // key: jqtk4d
    ElIconPathElement('M17 11h-.5'), // key: 1961ue
    ElIconPathElement('M19 19H5a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2'), // key: 1keqsi
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement('M7 11h4'), // key: 1o1z6v
    ElIconPathElement('M7 15h2.5'), // key: 1ina1g
  ]);

  /// `captions.mjs`
  static const ElLucideGlyph captions = ElLucideGlyph(
    'captions',
    <ElIconElement>[
      ElIconRectElement(3, 5, 18, 14, 2, ry: 2), // key: 12ruh7
      ElIconPathElement('M7 15h4M15 15h2M7 11h2M13 11h4'), // key: 1ueiar
    ],
  );

  /// `car-front.mjs`
  static const ElLucideGlyph
  carFront = ElLucideGlyph('car-front', <ElIconElement>[
    ElIconPathElement(
      'm21 8-2 2-1.5-3.7A2 2 0 0 0 15.646 5H8.4a2 2 0 0 0-1.903 1.257L5 10 3 8',
    ), // key: 1imjwt
    ElIconPathElement('M7 14h.01'), // key: 1qa3f1
    ElIconPathElement('M17 14h.01'), // key: 7oqj8z
    ElIconRectElement(3, 10, 18, 8, 2), // key: a7itu8
    ElIconPathElement('M5 18v2'), // key: ppbyun
    ElIconPathElement('M19 18v2'), // key: gy7782
  ]);

  /// `car-taxi-front.mjs`
  static const ElLucideGlyph
  carTaxiFront = ElLucideGlyph('car-taxi-front', <ElIconElement>[
    ElIconPathElement('M10 2h4'), // key: n1abiw
    ElIconPathElement(
      'm21 8-2 2-1.5-3.7A2 2 0 0 0 15.646 5H8.4a2 2 0 0 0-1.903 1.257L5 10 3 8',
    ), // key: 1imjwt
    ElIconPathElement('M7 14h.01'), // key: 1qa3f1
    ElIconPathElement('M17 14h.01'), // key: 7oqj8z
    ElIconRectElement(3, 10, 18, 8, 2), // key: a7itu8
    ElIconPathElement('M5 18v2'), // key: ppbyun
    ElIconPathElement('M19 18v2'), // key: gy7782
  ]);

  /// `car.mjs`
  static const ElLucideGlyph car = ElLucideGlyph('car', <ElIconElement>[
    ElIconPathElement(
      'M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.4 2.9A3.7 3.7 0 0 0 2 12v4c0 .6.4 1 1 1h2',
    ), // key: 5owen
    ElIconCircleElement(7, 17, 2), // key: u2ysq9
    ElIconPathElement('M9 17h6'), // key: r8uit2
    ElIconCircleElement(17, 17, 2), // key: axvx0g
  ]);

  /// `caravan.mjs`
  static const ElLucideGlyph caravan = ElLucideGlyph('caravan', <ElIconElement>[
    ElIconPathElement(
      'M18 19V9a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v8a2 2 0 0 0 2 2h2',
    ), // key: 19jm3t
    ElIconPathElement('M2 9h3a1 1 0 0 1 1 1v2a1 1 0 0 1-1 1H2'), // key: 13hakp
    ElIconPathElement(
      'M22 17v1a1 1 0 0 1-1 1H10v-9a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v9',
    ), // key: 1crci8
    ElIconCircleElement(8, 19, 2), // key: t8fc5s
  ]);

  /// `card-sim.mjs`
  static const ElLucideGlyph
  cardSim = ElLucideGlyph('card-sim', <ElIconElement>[
    ElIconPathElement('M12 14v4'), // key: 1thi36
    ElIconPathElement(
      'M14.172 2a2 2 0 0 1 1.414.586l3.828 3.828A2 2 0 0 1 20 7.828V20a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2z',
    ), // key: 1o66bk
    ElIconPathElement('M8 14h8'), // key: 1fgep2
    ElIconRectElement(8, 10, 8, 8, 1), // key: 1aonk6
  ]);

  /// `carrot.mjs`
  static const ElLucideGlyph carrot = ElLucideGlyph('carrot', <ElIconElement>[
    ElIconPathElement(
      'M15 16a1 1 0 0 0-7-7q-4 4-5.987 12.385a.5.5 0 0 0 .602.602Q11 20 15 16l-3-3',
    ), // key: 1ta62j
    ElIconPathElement('M15 9q4 4 7 0-3-4-7 0 4-4 0-7-4 3 0 7'), // key: 1svf7i
    ElIconPathElement('m8 15-2.58-2.58'), // key: 7t238r
  ]);

  /// `case-lower.mjs`
  static const ElLucideGlyph caseLower = ElLucideGlyph(
    'case-lower',
    <ElIconElement>[
      ElIconPathElement('M10 9v7'), // key: ylp826
      ElIconPathElement('M14 6v10'), // key: 1jy4vg
      ElIconCircleElement(17.5, 12.5, 3.5), // key: 1a9481
      ElIconCircleElement(6.5, 12.5, 3.5), // key: 2jlv1r
    ],
  );

  /// `case-sensitive.mjs`
  static const ElLucideGlyph caseSensitive = ElLucideGlyph(
    'case-sensitive',
    <ElIconElement>[
      ElIconPathElement(
        'm2 16 4.039-9.69a.5.5 0 0 1 .923 0L11 16',
      ), // key: d5nyq2
      ElIconPathElement('M22 9v7'), // key: pvm9v3
      ElIconPathElement('M3.304 13h6.392'), // key: 1q3zxz
      ElIconCircleElement(18.5, 12.5, 3.5), // key: z97x68
    ],
  );

  /// `case-upper.mjs`
  static const ElLucideGlyph
  caseUpper = ElLucideGlyph('case-upper', <ElIconElement>[
    ElIconPathElement(
      'M15 11h4.5a1 1 0 0 1 0 5h-4a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h3a1 1 0 0 1 0 5',
    ), // key: nxs35
    ElIconPathElement(
      'm2 16 4.039-9.69a.5.5 0 0 1 .923 0L11 16',
    ), // key: d5nyq2
    ElIconPathElement('M3.304 13h6.392'), // key: 1q3zxz
  ]);

  /// `cassette-tape.mjs`
  static const ElLucideGlyph cassetteTape = ElLucideGlyph(
    'cassette-tape',
    <ElIconElement>[
      ElIconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
      ElIconCircleElement(8, 10, 2), // key: 1xl4ub
      ElIconPathElement('M8 12h8'), // key: 1wcyev
      ElIconCircleElement(16, 10, 2), // key: r14t7q
      ElIconPathElement(
        'm6 20 .7-2.9A1.4 1.4 0 0 1 8.1 16h7.8a1.4 1.4 0 0 1 1.4 1l.7 3',
      ), // key: l01ucn
    ],
  );

  /// `cast.mjs`
  static const ElLucideGlyph cast = ElLucideGlyph('cast', <ElIconElement>[
    ElIconPathElement(
      'M2 8V6a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2h-6',
    ), // key: 3zrzxg
    ElIconPathElement('M2 12a9 9 0 0 1 8 8'), // key: g6cvee
    ElIconPathElement('M2 16a5 5 0 0 1 4 4'), // key: 1y1dii
    ElIconLineElement(2, 20, 2.01, 20), // key: xu2jvo
  ]);

  /// `castle.mjs`
  static const ElLucideGlyph castle = ElLucideGlyph('castle', <ElIconElement>[
    ElIconPathElement('M10 5V3'), // key: 1y54qe
    ElIconPathElement('M14 5V3'), // key: m6isi
    ElIconPathElement('M15 21v-3a3 3 0 0 0-6 0v3'), // key: lbp5hj
    ElIconPathElement('M18 3v8'), // key: 2ollhf
    ElIconPathElement('M18 5H6'), // key: 98imr9
    ElIconPathElement('M22 11H2'), // key: 1lmjae
    ElIconPathElement(
      'M22 9v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V9',
    ), // key: 1rly83
    ElIconPathElement('M6 3v8'), // key: csox7g
  ]);

  /// `cat.mjs`
  static const ElLucideGlyph cat = ElLucideGlyph('cat', <ElIconElement>[
    ElIconPathElement(
      'M12 5c.67 0 1.35.09 2 .26 1.78-2 5.03-2.84 6.42-2.26 1.4.58-.42 7-.42 7 .57 1.07 1 2.24 1 3.44C21 17.9 16.97 21 12 21s-9-3-9-7.56c0-1.25.5-2.4 1-3.44 0 0-1.89-6.42-.5-7 1.39-.58 4.72.23 6.5 2.23A9.04 9.04 0 0 1 12 5Z',
    ), // key: x6xyqk
    ElIconPathElement('M8 14v.5'), // key: 1nzgdb
    ElIconPathElement('M16 14v.5'), // key: 1lajdz
    ElIconPathElement('M11.25 16.25h1.5L12 17l-.75-.75Z'), // key: 12kq1m
  ]);

  /// `cctv-off.mjs`
  static const ElLucideGlyph
  cctvOff = ElLucideGlyph('cctv-off', <ElIconElement>[
    ElIconPathElement(
      'm12.309 6.652 4.797 2.401a1 1 0 0 1 .447 1.341l-.501 1.001.605.605h2.725a1 1 0 0 1 .894 1.447l-.724 1.448',
    ), // key: e75roo
    ElIconPathElement(
      'm15.166 15.166-.719 1.439a1 1 0 0 1-1.342.447L3.61 12.3a2.92 2.92 0 0 1-1.3-3.91L3.69 5.6a2.9 2.9 0 0 1 .873-1.037',
    ), // key: 1h9o5r
    ElIconPathElement(
      'M2 19h3.76a2 2 0 0 0 1.8-1.1l1.441-2.902',
    ), // key: 1askrb
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement('M2 21v-4'), // key: l40lih
    ElIconPathElement('M7 9h.01'), // key: 19b3jx
  ]);

  /// `cctv.mjs`
  static const ElLucideGlyph cctv = ElLucideGlyph('cctv', <ElIconElement>[
    ElIconPathElement(
      'M16.75 12h3.632a1 1 0 0 1 .894 1.447l-2.034 4.069a1 1 0 0 1-1.708.134l-2.124-2.97',
    ), // key: ir91b5
    ElIconPathElement(
      'M17.106 9.053a1 1 0 0 1 .447 1.341l-3.106 6.211a1 1 0 0 1-1.342.447L3.61 12.3a2.92 2.92 0 0 1-1.3-3.91L3.69 5.6a2.92 2.92 0 0 1 3.92-1.3z',
    ), // key: jlp8i1
    ElIconPathElement('M2 19h3.76a2 2 0 0 0 1.8-1.1L9 15'), // key: 19bib8
    ElIconPathElement('M2 21v-4'), // key: l40lih
    ElIconPathElement('M7 9h.01'), // key: 19b3jx
  ]);

  /// `chart-area.mjs`
  static const ElLucideGlyph
  chartArea = ElLucideGlyph('chart-area', <ElIconElement>[
    ElIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    ElIconPathElement(
      'M7 11.207a.5.5 0 0 1 .146-.353l2-2a.5.5 0 0 1 .708 0l3.292 3.292a.5.5 0 0 0 .708 0l4.292-4.292a.5.5 0 0 1 .854.353V16a1 1 0 0 1-1 1H8a1 1 0 0 1-1-1z',
    ), // key: q0gr47
  ]);

  /// `chart-bar-big.mjs`
  static const ElLucideGlyph chartBarBig = ElLucideGlyph(
    'chart-bar-big',
    <ElIconElement>[
      ElIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      ElIconRectElement(7, 13, 9, 4, 1), // key: 1iip1u
      ElIconRectElement(7, 5, 12, 4, 1), // key: 1anskk
    ],
  );

  /// `chart-bar-decreasing.mjs`
  static const ElLucideGlyph chartBarDecreasing = ElLucideGlyph(
    'chart-bar-decreasing',
    <ElIconElement>[
      ElIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      ElIconPathElement('M7 11h8'), // key: 1feolt
      ElIconPathElement('M7 16h3'), // key: ur6vzw
      ElIconPathElement('M7 6h12'), // key: sz5b0d
    ],
  );

  /// `chart-bar-increasing.mjs`
  static const ElLucideGlyph chartBarIncreasing = ElLucideGlyph(
    'chart-bar-increasing',
    <ElIconElement>[
      ElIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      ElIconPathElement('M7 11h8'), // key: 1feolt
      ElIconPathElement('M7 16h12'), // key: wsnu98
      ElIconPathElement('M7 6h3'), // key: w9rmul
    ],
  );

  /// `chart-bar-stacked.mjs`
  static const ElLucideGlyph chartBarStacked = ElLucideGlyph(
    'chart-bar-stacked',
    <ElIconElement>[
      ElIconPathElement('M11 13v4'), // key: vyy2rb
      ElIconPathElement('M15 5v4'), // key: 1gx88a
      ElIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      ElIconRectElement(7, 13, 9, 4, 1), // key: 1iip1u
      ElIconRectElement(7, 5, 12, 4, 1), // key: 1anskk
    ],
  );

  /// `chart-bar.mjs`
  static const ElLucideGlyph chartBar = ElLucideGlyph(
    'chart-bar',
    <ElIconElement>[
      ElIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      ElIconPathElement('M7 16h8'), // key: srdodz
      ElIconPathElement('M7 11h12'), // key: 127s9w
      ElIconPathElement('M7 6h3'), // key: w9rmul
    ],
  );

  /// `chart-candlestick.mjs`
  static const ElLucideGlyph chartCandlestick = ElLucideGlyph(
    'chart-candlestick',
    <ElIconElement>[
      ElIconPathElement('M9 5v4'), // key: 14uxtq
      ElIconRectElement(7, 9, 4, 6, 1), // key: f4fvz0
      ElIconPathElement('M9 15v2'), // key: r5rk32
      ElIconPathElement('M17 3v2'), // key: 1l2re6
      ElIconRectElement(15, 5, 4, 8, 1), // key: z38je5
      ElIconPathElement('M17 13v3'), // key: 5l0wba
      ElIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    ],
  );

  /// `chart-column-big.mjs`
  static const ElLucideGlyph chartColumnBig = ElLucideGlyph(
    'chart-column-big',
    <ElIconElement>[
      ElIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      ElIconRectElement(15, 5, 4, 12, 1), // key: q8uenq
      ElIconRectElement(7, 8, 4, 9, 1), // key: sr5ea
    ],
  );

  /// `chart-column-decreasing.mjs`
  static const ElLucideGlyph chartColumnDecreasing = ElLucideGlyph(
    'chart-column-decreasing',
    <ElIconElement>[
      ElIconPathElement('M13 17V9'), // key: 1fwyjl
      ElIconPathElement('M18 17v-3'), // key: 1sqioe
      ElIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      ElIconPathElement('M8 17V5'), // key: 1wzmnc
    ],
  );

  /// `chart-column-increasing.mjs`
  static const ElLucideGlyph chartColumnIncreasing = ElLucideGlyph(
    'chart-column-increasing',
    <ElIconElement>[
      ElIconPathElement('M13 17V9'), // key: 1fwyjl
      ElIconPathElement('M18 17V5'), // key: sfb6ij
      ElIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      ElIconPathElement('M8 17v-3'), // key: 17ska0
    ],
  );

  /// `chart-column-stacked.mjs`
  static const ElLucideGlyph chartColumnStacked = ElLucideGlyph(
    'chart-column-stacked',
    <ElIconElement>[
      ElIconPathElement('M11 13H7'), // key: t0o9gq
      ElIconPathElement('M19 9h-4'), // key: rera1j
      ElIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      ElIconRectElement(15, 5, 4, 12, 1), // key: q8uenq
      ElIconRectElement(7, 8, 4, 9, 1), // key: sr5ea
    ],
  );

  /// `chart-column.mjs`
  static const ElLucideGlyph chartColumn = ElLucideGlyph(
    'chart-column',
    <ElIconElement>[
      ElIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      ElIconPathElement('M18 17V9'), // key: 2bz60n
      ElIconPathElement('M13 17V5'), // key: 1frdt8
      ElIconPathElement('M8 17v-3'), // key: 17ska0
    ],
  );

  /// `chart-gantt.mjs`
  static const ElLucideGlyph chartGantt = ElLucideGlyph(
    'chart-gantt',
    <ElIconElement>[
      ElIconPathElement('M10 6h8'), // key: zvc2xc
      ElIconPathElement('M12 16h6'), // key: yi5mkt
      ElIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      ElIconPathElement('M8 11h7'), // key: wz2hg0
    ],
  );

  /// `chart-line.mjs`
  static const ElLucideGlyph chartLine = ElLucideGlyph(
    'chart-line',
    <ElIconElement>[
      ElIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      ElIconPathElement('m19 9-5 5-4-4-3 3'), // key: 2osh9i
    ],
  );

  /// `chart-network.mjs`
  static const ElLucideGlyph chartNetwork = ElLucideGlyph(
    'chart-network',
    <ElIconElement>[
      ElIconPathElement('m13.11 7.664 1.78 2.672'), // key: go2gg9
      ElIconPathElement('m14.162 12.788-3.324 1.424'), // key: 11x848
      ElIconPathElement('m20 4-6.06 1.515'), // key: 1wxxh7
      ElIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      ElIconCircleElement(12, 6, 2), // key: 1jj5th
      ElIconCircleElement(16, 12, 2), // key: 4ma0v8
      ElIconCircleElement(9, 15, 2), // key: lf2ghp
    ],
  );

  /// `chart-no-axes-column-decreasing.mjs`
  static const ElLucideGlyph chartNoAxesColumnDecreasing = ElLucideGlyph(
    'chart-no-axes-column-decreasing',
    <ElIconElement>[
      ElIconPathElement('M5 21V3'), // key: clc1r8
      ElIconPathElement('M12 21V9'), // key: uvy0l4
      ElIconPathElement('M19 21v-6'), // key: tkawy9
    ],
  );

  /// `chart-no-axes-column-increasing.mjs`
  static const ElLucideGlyph chartNoAxesColumnIncreasing = ElLucideGlyph(
    'chart-no-axes-column-increasing',
    <ElIconElement>[
      ElIconPathElement('M5 21v-6'), // key: 1hz6c0
      ElIconPathElement('M12 21V9'), // key: uvy0l4
      ElIconPathElement('M19 21V3'), // key: 11j9sm
    ],
  );

  /// `chart-no-axes-column.mjs`
  static const ElLucideGlyph chartNoAxesColumn = ElLucideGlyph(
    'chart-no-axes-column',
    <ElIconElement>[
      ElIconPathElement('M5 21v-6'), // key: 1hz6c0
      ElIconPathElement('M12 21V3'), // key: 1lcnhd
      ElIconPathElement('M19 21V9'), // key: unv183
    ],
  );

  /// `chart-no-axes-combined.mjs`
  static const ElLucideGlyph
  chartNoAxesCombined = ElLucideGlyph('chart-no-axes-combined', <ElIconElement>[
    ElIconPathElement('M12 16v5'), // key: zza2cw
    ElIconPathElement('M16 14.639V21'), // key: 1s85h0
    ElIconPathElement('M20 10.656V21'), // key: q45596
    ElIconPathElement(
      'm22 3-8.646 8.646a.5.5 0 0 1-.708 0L9.354 8.354a.5.5 0 0 0-.707 0L2 15',
    ), // key: 1fw8x9
    ElIconPathElement('M4 18.463V21'), // key: 1otddq
    ElIconPathElement('M8 14.656V21'), // key: 1t2idw
  ]);

  /// `chart-no-axes-gantt.mjs`
  static const ElLucideGlyph chartNoAxesGantt = ElLucideGlyph(
    'chart-no-axes-gantt',
    <ElIconElement>[
      ElIconPathElement('M6 5h12'), // key: fvfigv
      ElIconPathElement('M4 12h10'), // key: oujl3d
      ElIconPathElement('M12 19h8'), // key: baeox8
    ],
  );

  /// `chart-pie.mjs`
  static const ElLucideGlyph
  chartPie = ElLucideGlyph('chart-pie', <ElIconElement>[
    ElIconPathElement(
      'M21 12c.552 0 1.005-.449.95-.998a10 10 0 0 0-8.953-8.951c-.55-.055-.998.398-.998.95v8a1 1 0 0 0 1 1z',
    ), // key: pzmjnu
    ElIconPathElement('M21.21 15.89A10 10 0 1 1 8 2.83'), // key: k2fpak
  ]);

  /// `chart-scatter.mjs`
  static const ElLucideGlyph chartScatter = ElLucideGlyph(
    'chart-scatter',
    <ElIconElement>[
      ElIconCircleElement(7.5, 7.5, 0.5, filled: true), // key: kqv944
      ElIconCircleElement(18.5, 5.5, 0.5, filled: true), // key: lysivs
      ElIconCircleElement(11.5, 11.5, 0.5, filled: true), // key: byv1b8
      ElIconCircleElement(7.5, 16.5, 0.5, filled: true), // key: nkw3mc
      ElIconCircleElement(17.5, 14.5, 0.5, filled: true), // key: 1gjh6j
      ElIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    ],
  );

  /// `chart-spline.mjs`
  static const ElLucideGlyph chartSpline = ElLucideGlyph(
    'chart-spline',
    <ElIconElement>[
      ElIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
      ElIconPathElement(
        'M7 16c.5-2 1.5-7 4-7 2 0 2 3 4 3 2.5 0 4.5-5 5-7',
      ), // key: lw07rv
    ],
  );

  /// `check-check.mjs`
  static const ElLucideGlyph checkCheck = ElLucideGlyph(
    'check-check',
    <ElIconElement>[
      ElIconPathElement('M18 6 7 17l-5-5'), // key: 116fxf
      ElIconPathElement('m22 10-7.5 7.5L13 16'), // key: ke71qq
    ],
  );

  /// `check-line.mjs`
  static const ElLucideGlyph checkLine = ElLucideGlyph(
    'check-line',
    <ElIconElement>[
      ElIconPathElement('M20 4L9 15'), // key: 1qkx8z
      ElIconPathElement('M21 19L3 19'), // key: 100sma
      ElIconPathElement('M9 15L4 10'), // key: 9zxff7
    ],
  );

  /// `check.mjs`
  static const ElLucideGlyph check = ElLucideGlyph('check', <ElIconElement>[
    ElIconPathElement('M20 6 9 17l-5-5'), // key: 1gmf2c
  ]);

  /// `chef-hat.mjs`
  static const ElLucideGlyph
  chefHat = ElLucideGlyph('chef-hat', <ElIconElement>[
    ElIconPathElement(
      'M17 21a1 1 0 0 0 1-1v-5.35c0-.457.316-.844.727-1.041a4 4 0 0 0-2.134-7.589 5 5 0 0 0-9.186 0 4 4 0 0 0-2.134 7.588c.411.198.727.585.727 1.041V20a1 1 0 0 0 1 1Z',
    ), // key: 1qvrer
    ElIconPathElement('M6 17h12'), // key: 1jwigz
  ]);

  /// `cherry.mjs`
  static const ElLucideGlyph cherry = ElLucideGlyph('cherry', <ElIconElement>[
    ElIconPathElement(
      'M2 17a5 5 0 0 0 10 0c0-2.76-2.5-5-5-3-2.5-2-5 .24-5 3Z',
    ), // key: cvxqlc
    ElIconPathElement(
      'M12 17a5 5 0 0 0 10 0c0-2.76-2.5-5-5-3-2.5-2-5 .24-5 3Z',
    ), // key: 1ostrc
    ElIconPathElement(
      'M7 14c3.22-2.91 4.29-8.75 5-12 1.66 2.38 4.94 9 5 12',
    ), // key: hqx58h
    ElIconPathElement(
      'M22 9c-4.29 0-7.14-2.33-10-7 5.71 0 10 4.67 10 7Z',
    ), // key: eykp1o
  ]);

  /// `chess-bishop.mjs`
  static const ElLucideGlyph
  chessBishop = ElLucideGlyph('chess-bishop', <ElIconElement>[
    ElIconPathElement(
      'M5 20a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1z',
    ), // key: b89hwq
    ElIconPathElement(
      'M15 18c1.5-.615 3-2.461 3-4.923C18 8.769 14.5 4.462 12 2 9.5 4.462 6 8.77 6 13.077 6 15.539 7.5 17.385 9 18',
    ), // key: 8jdkhx
    ElIconPathElement('m16 7-2.5 2.5'), // key: 1jq90w
    ElIconPathElement('M9 2h6'), // key: 1jrp98
  ]);

  /// `chess-king.mjs`
  static const ElLucideGlyph
  chessKing = ElLucideGlyph('chess-king', <ElIconElement>[
    ElIconPathElement(
      'M4 20a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1z',
    ), // key: mqzwx6
    ElIconPathElement(
      'm6.7 18-1-1C4.35 15.682 3 14.09 3 12a5 5 0 0 1 4.95-5c1.584 0 2.7.455 4.05 1.818C13.35 7.455 14.466 7 16.05 7A5 5 0 0 1 21 12c0 2.082-1.359 3.673-2.7 5l-1 1',
    ), // key: 1gdt1g
    ElIconPathElement('M10 4h4'), // key: 1xpv9s
    ElIconPathElement('M12 2v6.818'), // key: b17a49
  ]);

  /// `chess-knight.mjs`
  static const ElLucideGlyph
  chessKnight = ElLucideGlyph('chess-knight', <ElIconElement>[
    ElIconPathElement(
      'M5 20a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1z',
    ), // key: b89hwq
    ElIconPathElement(
      'M16.5 18c1-2 2.5-5 2.5-9a7 7 0 0 0-7-7H6.635a1 1 0 0 0-.768 1.64L7 5l-2.32 5.802a2 2 0 0 0 .95 2.526l2.87 1.456',
    ), // key: axbnlq
    ElIconPathElement('m15 5 1.425-1.425'), // key: 15xz8w
    ElIconPathElement('m17 8 1.53-1.53'), // key: 15zhqh
    ElIconPathElement('M9.713 12.185 7 18'), // key: 1ocm0l
  ]);

  /// `chess-pawn.mjs`
  static const ElLucideGlyph chessPawn = ElLucideGlyph(
    'chess-pawn',
    <ElIconElement>[
      ElIconPathElement(
        'M5 20a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1z',
      ), // key: b89hwq
      ElIconPathElement('m14.5 10 1.5 8'), // key: cim3qy
      ElIconPathElement('M7 10h10'), // key: 1101jm
      ElIconPathElement('m8 18 1.5-8'), // key: ja3yjd
      ElIconCircleElement(12, 6, 4), // key: 1frrej
    ],
  );

  /// `chess-queen.mjs`
  static const ElLucideGlyph chessQueen = ElLucideGlyph(
    'chess-queen',
    <ElIconElement>[
      ElIconPathElement(
        'M4 20a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1z',
      ), // key: mqzwx6
      ElIconPathElement(
        'm12.474 5.943 1.567 5.34a1 1 0 0 0 1.75.328l2.616-3.402',
      ), // key: 1js4gl
      ElIconPathElement('m20 9-3 9'), // key: r75r3f
      ElIconPathElement(
        'm5.594 8.209 2.615 3.403a1 1 0 0 0 1.75-.329l1.567-5.34',
      ), // key: 1joj19
      ElIconPathElement('M7 18 4 9'), // key: 1mfzj8
      ElIconCircleElement(12, 4, 2), // key: muu5ef
      ElIconCircleElement(20, 7, 2), // key: 9w7p1x
      ElIconCircleElement(4, 7, 2), // key: 1d9wy8
    ],
  );

  /// `chess-rook.mjs`
  static const ElLucideGlyph
  chessRook = ElLucideGlyph('chess-rook', <ElIconElement>[
    ElIconPathElement(
      'M5 20a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1z',
    ), // key: b89hwq
    ElIconPathElement('M10 2v2'), // key: 7u0qdc
    ElIconPathElement('M14 2v2'), // key: 6buw04
    ElIconPathElement('m17 18-1-9'), // key: 10nd7q
    ElIconPathElement('M6 2v5a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V2'), // key: uxf4yx
    ElIconPathElement('M6 4h12'), // key: 1x2ag7
    ElIconPathElement('m7 18 1-9'), // key: 1si9vq
  ]);

  /// `chevron-down.mjs`
  static const ElLucideGlyph chevronDown = ElLucideGlyph(
    'chevron-down',
    <ElIconElement>[
      ElIconPathElement('m6 9 6 6 6-6'), // key: qrunsl
    ],
  );

  /// `chevron-first.mjs`
  static const ElLucideGlyph chevronFirst = ElLucideGlyph(
    'chevron-first',
    <ElIconElement>[
      ElIconPathElement('m17 18-6-6 6-6'), // key: 1yerx2
      ElIconPathElement('M7 6v12'), // key: 1p53r6
    ],
  );

  /// `chevron-last.mjs`
  static const ElLucideGlyph chevronLast = ElLucideGlyph(
    'chevron-last',
    <ElIconElement>[
      ElIconPathElement('m7 18 6-6-6-6'), // key: lwmzdw
      ElIconPathElement('M17 6v12'), // key: 1o0aio
    ],
  );

  /// `chevron-left.mjs`
  static const ElLucideGlyph chevronLeft = ElLucideGlyph(
    'chevron-left',
    <ElIconElement>[
      ElIconPathElement('m15 18-6-6 6-6'), // key: 1wnfg3
    ],
  );

  /// `chevron-right.mjs`
  static const ElLucideGlyph chevronRight = ElLucideGlyph(
    'chevron-right',
    <ElIconElement>[
      ElIconPathElement('m9 18 6-6-6-6'), // key: mthhwq
    ],
  );

  /// `chevron-up.mjs`
  static const ElLucideGlyph chevronUp = ElLucideGlyph(
    'chevron-up',
    <ElIconElement>[
      ElIconPathElement('m18 15-6-6-6 6'), // key: 153udz
    ],
  );

  /// `chevrons-down-up.mjs`
  static const ElLucideGlyph chevronsDownUp = ElLucideGlyph(
    'chevrons-down-up',
    <ElIconElement>[
      ElIconPathElement('m7 20 5-5 5 5'), // key: 13a0gw
      ElIconPathElement('m7 4 5 5 5-5'), // key: 1kwcof
    ],
  );

  /// `chevrons-down.mjs`
  static const ElLucideGlyph chevronsDown = ElLucideGlyph(
    'chevrons-down',
    <ElIconElement>[
      ElIconPathElement('m7 6 5 5 5-5'), // key: 1lc07p
      ElIconPathElement('m7 13 5 5 5-5'), // key: 1d48rs
    ],
  );

  /// `chevrons-left-right-ellipsis.mjs`
  static const ElLucideGlyph chevronsLeftRightEllipsis = ElLucideGlyph(
    'chevrons-left-right-ellipsis',
    <ElIconElement>[
      ElIconPathElement('M12 12h.01'), // key: 1mp3jc
      ElIconPathElement('M16 12h.01'), // key: 1l6xoz
      ElIconPathElement('m17 7 5 5-5 5'), // key: 1xlxn0
      ElIconPathElement('m7 7-5 5 5 5'), // key: 19njba
      ElIconPathElement('M8 12h.01'), // key: czm47f
    ],
  );

  /// `chevrons-left-right.mjs`
  static const ElLucideGlyph chevronsLeftRight = ElLucideGlyph(
    'chevrons-left-right',
    <ElIconElement>[
      ElIconPathElement('m9 7-5 5 5 5'), // key: j5w590
      ElIconPathElement('m15 7 5 5-5 5'), // key: 1bl6da
    ],
  );

  /// `chevrons-left.mjs`
  static const ElLucideGlyph chevronsLeft = ElLucideGlyph(
    'chevrons-left',
    <ElIconElement>[
      ElIconPathElement('m11 17-5-5 5-5'), // key: 13zhaf
      ElIconPathElement('m18 17-5-5 5-5'), // key: h8a8et
    ],
  );

  /// `chevrons-right-left.mjs`
  static const ElLucideGlyph chevronsRightLeft = ElLucideGlyph(
    'chevrons-right-left',
    <ElIconElement>[
      ElIconPathElement('m20 17-5-5 5-5'), // key: 30x0n2
      ElIconPathElement('m4 17 5-5-5-5'), // key: 16spf4
    ],
  );

  /// `chevrons-right.mjs`
  static const ElLucideGlyph chevronsRight = ElLucideGlyph(
    'chevrons-right',
    <ElIconElement>[
      ElIconPathElement('m6 17 5-5-5-5'), // key: xnjwq
      ElIconPathElement('m13 17 5-5-5-5'), // key: 17xmmf
    ],
  );

  /// `chevrons-up-down.mjs`
  static const ElLucideGlyph chevronsUpDown = ElLucideGlyph(
    'chevrons-up-down',
    <ElIconElement>[
      ElIconPathElement('m7 15 5 5 5-5'), // key: 1hf1tw
      ElIconPathElement('m7 9 5-5 5 5'), // key: sgt6xg
    ],
  );

  /// `chevrons-up.mjs`
  static const ElLucideGlyph chevronsUp = ElLucideGlyph(
    'chevrons-up',
    <ElIconElement>[
      ElIconPathElement('m17 11-5-5-5 5'), // key: e8nh98
      ElIconPathElement('m17 18-5-5-5 5'), // key: 2avn1x
    ],
  );

  /// `church.mjs`
  static const ElLucideGlyph church = ElLucideGlyph('church', <ElIconElement>[
    ElIconPathElement('M10 9h4'), // key: u4k05v
    ElIconPathElement('M12 7v5'), // key: ma6bk
    ElIconPathElement('M14 21v-3a2 2 0 0 0-4 0v3'), // key: 1rgiei
    ElIconPathElement(
      'm18 9 3.52 2.147a1 1 0 0 1 .48.854V19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-6.999a1 1 0 0 1 .48-.854L6 9',
    ), // key: flvdwo
    ElIconPathElement(
      'M6 21V7a1 1 0 0 1 .376-.782l5-3.999a1 1 0 0 1 1.249.001l5 4A1 1 0 0 1 18 7v14',
    ), // key: a5i0n2
  ]);

  /// `cigarette-off.mjs`
  static const ElLucideGlyph
  cigaretteOff = ElLucideGlyph('cigarette-off', <ElIconElement>[
    ElIconPathElement(
      'M12 12H3a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h13',
    ), // key: 1gdiyg
    ElIconPathElement('M18 8c0-2.5-2-2.5-2-5'), // key: 1il607
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement('M21 12a1 1 0 0 1 1 1v2a1 1 0 0 1-.5.866'), // key: 166zjj
    ElIconPathElement('M22 8c0-2.5-2-2.5-2-5'), // key: 1gah44
    ElIconPathElement('M7 12v4'), // key: jqww69
  ]);

  /// `cigarette.mjs`
  static const ElLucideGlyph cigarette = ElLucideGlyph(
    'cigarette',
    <ElIconElement>[
      ElIconPathElement(
        'M17 12H3a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h14',
      ), // key: 1mb5g1
      ElIconPathElement('M18 8c0-2.5-2-2.5-2-5'), // key: 1il607
      ElIconPathElement('M21 16a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1'), // key: 1yl5r7
      ElIconPathElement('M22 8c0-2.5-2-2.5-2-5'), // key: 1gah44
      ElIconPathElement('M7 12v4'), // key: jqww69
    ],
  );

  /// `circle-alert.mjs`
  static const ElLucideGlyph circleAlert = ElLucideGlyph(
    'circle-alert',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconLineElement(12, 8, 12, 12), // key: 1pkeuh
      ElIconLineElement(12, 16, 12.01, 16), // key: 4dfq90
    ],
  );

  /// `circle-arrow-down.mjs`
  static const ElLucideGlyph circleArrowDown = ElLucideGlyph(
    'circle-arrow-down',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('M12 8v8'), // key: napkw2
      ElIconPathElement('m8 12 4 4 4-4'), // key: k98ssh
    ],
  );

  /// `circle-arrow-left.mjs`
  static const ElLucideGlyph circleArrowLeft = ElLucideGlyph(
    'circle-arrow-left',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('m12 8-4 4 4 4'), // key: 15vm53
      ElIconPathElement('M16 12H8'), // key: 1fr5h0
    ],
  );

  /// `circle-arrow-out-down-left.mjs`
  static const ElLucideGlyph circleArrowOutDownLeft = ElLucideGlyph(
    'circle-arrow-out-down-left',
    <ElIconElement>[
      ElIconPathElement('M2 12a10 10 0 1 1 10 10'), // key: 1yn6ov
      ElIconPathElement('m2 22 10-10'), // key: 28ilpk
      ElIconPathElement('M8 22H2v-6'), // key: sulq54
    ],
  );

  /// `circle-arrow-out-down-right.mjs`
  static const ElLucideGlyph circleArrowOutDownRight = ElLucideGlyph(
    'circle-arrow-out-down-right',
    <ElIconElement>[
      ElIconPathElement('M12 22a10 10 0 1 1 10-10'), // key: 130bv5
      ElIconPathElement('M22 22 12 12'), // key: 131aw7
      ElIconPathElement('M22 16v6h-6'), // key: 1gvm70
    ],
  );

  /// `circle-arrow-out-up-left.mjs`
  static const ElLucideGlyph circleArrowOutUpLeft = ElLucideGlyph(
    'circle-arrow-out-up-left',
    <ElIconElement>[
      ElIconPathElement('M2 8V2h6'), // key: hiwtdz
      ElIconPathElement('m2 2 10 10'), // key: 1oh8rs
      ElIconPathElement('M12 2A10 10 0 1 1 2 12'), // key: rrk4fa
    ],
  );

  /// `circle-arrow-out-up-right.mjs`
  static const ElLucideGlyph circleArrowOutUpRight = ElLucideGlyph(
    'circle-arrow-out-up-right',
    <ElIconElement>[
      ElIconPathElement('M22 12A10 10 0 1 1 12 2'), // key: 1fm58d
      ElIconPathElement('M22 2 12 12'), // key: yg2myt
      ElIconPathElement('M16 2h6v6'), // key: zan5cs
    ],
  );

  /// `circle-arrow-right.mjs`
  static const ElLucideGlyph circleArrowRight = ElLucideGlyph(
    'circle-arrow-right',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('m12 16 4-4-4-4'), // key: 1i9zcv
      ElIconPathElement('M8 12h8'), // key: 1wcyev
    ],
  );

  /// `circle-arrow-up.mjs`
  static const ElLucideGlyph circleArrowUp = ElLucideGlyph(
    'circle-arrow-up',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('m16 12-4-4-4 4'), // key: 177agl
      ElIconPathElement('M12 16V8'), // key: 1sbj14
    ],
  );

  /// `circle-check-big.mjs`
  static const ElLucideGlyph circleCheckBig = ElLucideGlyph(
    'circle-check-big',
    <ElIconElement>[
      ElIconPathElement('M21.801 10A10 10 0 1 1 17 3.335'), // key: yps3ct
      ElIconPathElement('m9 11 3 3L22 4'), // key: 1pflzl
    ],
  );

  /// `circle-check.mjs`
  static const ElLucideGlyph circleCheck = ElLucideGlyph(
    'circle-check',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('m9 12 2 2 4-4'), // key: dzmm74
    ],
  );

  /// `circle-chevron-down.mjs`
  static const ElLucideGlyph circleChevronDown = ElLucideGlyph(
    'circle-chevron-down',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('m16 10-4 4-4-4'), // key: 894hmk
    ],
  );

  /// `circle-chevron-left.mjs`
  static const ElLucideGlyph circleChevronLeft = ElLucideGlyph(
    'circle-chevron-left',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('m14 16-4-4 4-4'), // key: ojs7w8
    ],
  );

  /// `circle-chevron-right.mjs`
  static const ElLucideGlyph circleChevronRight = ElLucideGlyph(
    'circle-chevron-right',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('m10 8 4 4-4 4'), // key: 1wy4r4
    ],
  );

  /// `circle-chevron-up.mjs`
  static const ElLucideGlyph circleChevronUp = ElLucideGlyph(
    'circle-chevron-up',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('m8 14 4-4 4 4'), // key: fy2ptz
    ],
  );

  /// `circle-dashed.mjs`
  static const ElLucideGlyph circleDashed = ElLucideGlyph(
    'circle-dashed',
    <ElIconElement>[
      ElIconPathElement('M10.1 2.182a10 10 0 0 1 3.8 0'), // key: 5ilxe3
      ElIconPathElement('M13.9 21.818a10 10 0 0 1-3.8 0'), // key: 11zvb9
      ElIconPathElement('M17.609 3.721a10 10 0 0 1 2.69 2.7'), // key: 1iw5b2
      ElIconPathElement('M2.182 13.9a10 10 0 0 1 0-3.8'), // key: c0bmvh
      ElIconPathElement('M20.279 17.609a10 10 0 0 1-2.7 2.69'), // key: 1ruxm7
      ElIconPathElement('M21.818 10.1a10 10 0 0 1 0 3.8'), // key: qkgqxc
      ElIconPathElement('M3.721 6.391a10 10 0 0 1 2.7-2.69'), // key: 1mcia2
      ElIconPathElement('M6.391 20.279a10 10 0 0 1-2.69-2.7'), // key: 1fvljs
    ],
  );

  /// `circle-divide.mjs`
  static const ElLucideGlyph circleDivide = ElLucideGlyph(
    'circle-divide',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconLineElement(8, 12, 16, 12), // key: 1jonct
      ElIconLineElement(12, 16, 12, 16), // key: aqc6ln
      ElIconLineElement(12, 8, 12, 8), // key: 1mkcni
    ],
  );

  /// `circle-dollar-sign.mjs`
  static const ElLucideGlyph circleDollarSign = ElLucideGlyph(
    'circle-dollar-sign',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement(
        'M16 8h-6a2 2 0 1 0 0 4h4a2 2 0 1 1 0 4H8',
      ), // key: 1h4pet
      ElIconPathElement('M12 18V6'), // key: zqpxq5
    ],
  );

  /// `circle-dot-dashed.mjs`
  static const ElLucideGlyph circleDotDashed = ElLucideGlyph(
    'circle-dot-dashed',
    <ElIconElement>[
      ElIconPathElement('M10.1 2.18a9.93 9.93 0 0 1 3.8 0'), // key: 1qdqn0
      ElIconPathElement('M17.6 3.71a9.95 9.95 0 0 1 2.69 2.7'), // key: 1bq7p6
      ElIconPathElement('M21.82 10.1a9.93 9.93 0 0 1 0 3.8'), // key: 1rlaqf
      ElIconPathElement('M20.29 17.6a9.95 9.95 0 0 1-2.7 2.69'), // key: 1xk03u
      ElIconPathElement('M13.9 21.82a9.94 9.94 0 0 1-3.8 0'), // key: l7re25
      ElIconPathElement('M6.4 20.29a9.95 9.95 0 0 1-2.69-2.7'), // key: 1v18p6
      ElIconPathElement('M2.18 13.9a9.93 9.93 0 0 1 0-3.8'), // key: xdo6bj
      ElIconPathElement('M3.71 6.4a9.95 9.95 0 0 1 2.7-2.69'), // key: 1jjmaz
      ElIconCircleElement(12, 12, 1), // key: 41hilf
    ],
  );

  /// `circle-dot.mjs`
  static const ElLucideGlyph circleDot = ElLucideGlyph(
    'circle-dot',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconCircleElement(12, 12, 1), // key: 41hilf
    ],
  );

  /// `circle-ellipsis.mjs`
  static const ElLucideGlyph circleEllipsis = ElLucideGlyph(
    'circle-ellipsis',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('M17 12h.01'), // key: 1m0b6t
      ElIconPathElement('M12 12h.01'), // key: 1mp3jc
      ElIconPathElement('M7 12h.01'), // key: eqddd0
    ],
  );

  /// `circle-equal.mjs`
  static const ElLucideGlyph circleEqual = ElLucideGlyph(
    'circle-equal',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('M7 10h10'), // key: 1101jm
      ElIconPathElement('M7 14h10'), // key: 1mhdw3
    ],
  );

  /// `circle-euro.mjs`
  static const ElLucideGlyph circleEuro = ElLucideGlyph(
    'circle-euro',
    <ElIconElement>[
      ElIconPathElement('M15 9.4a4 4 0 1 0 0 5.2'), // key: 1makmb
      ElIconPathElement('M7 12h5'), // key: gblrwe
      ElIconCircleElement(12, 12, 10), // key: 1mglay
    ],
  );

  /// `circle-fading-arrow-up.mjs`
  static const ElLucideGlyph circleFadingArrowUp = ElLucideGlyph(
    'circle-fading-arrow-up',
    <ElIconElement>[
      ElIconPathElement('M12 2a10 10 0 0 1 7.38 16.75'), // key: 175t95
      ElIconPathElement('m16 12-4-4-4 4'), // key: 177agl
      ElIconPathElement('M12 16V8'), // key: 1sbj14
      ElIconPathElement('M2.5 8.875a10 10 0 0 0-.5 3'), // key: 1vce0s
      ElIconPathElement('M2.83 16a10 10 0 0 0 2.43 3.4'), // key: o3fkw4
      ElIconPathElement('M4.636 5.235a10 10 0 0 1 .891-.857'), // key: 1szpfk
      ElIconPathElement('M8.644 21.42a10 10 0 0 0 7.631-.38'), // key: 9yhvd4
    ],
  );

  /// `circle-fading-plus.mjs`
  static const ElLucideGlyph circleFadingPlus = ElLucideGlyph(
    'circle-fading-plus',
    <ElIconElement>[
      ElIconPathElement('M12 2a10 10 0 0 1 7.38 16.75'), // key: 175t95
      ElIconPathElement('M12 8v8'), // key: napkw2
      ElIconPathElement('M16 12H8'), // key: 1fr5h0
      ElIconPathElement('M2.5 8.875a10 10 0 0 0-.5 3'), // key: 1vce0s
      ElIconPathElement('M2.83 16a10 10 0 0 0 2.43 3.4'), // key: o3fkw4
      ElIconPathElement('M4.636 5.235a10 10 0 0 1 .891-.857'), // key: 1szpfk
      ElIconPathElement('M8.644 21.42a10 10 0 0 0 7.631-.38'), // key: 9yhvd4
    ],
  );

  /// `circle-gauge.mjs`
  static const ElLucideGlyph circleGauge = ElLucideGlyph(
    'circle-gauge',
    <ElIconElement>[
      ElIconPathElement('M15.6 2.7a10 10 0 1 0 5.7 5.7'), // key: 1e0p6d
      ElIconCircleElement(12, 12, 2), // key: 1c9p78
      ElIconPathElement('M13.4 10.6 19 5'), // key: 1kr7tw
    ],
  );

  /// `circle-minus.mjs`
  static const ElLucideGlyph circleMinus = ElLucideGlyph(
    'circle-minus',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('M8 12h8'), // key: 1wcyev
    ],
  );

  /// `circle-off.mjs`
  static const ElLucideGlyph circleOff = ElLucideGlyph(
    'circle-off',
    <ElIconElement>[
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
      ElIconPathElement('M8.35 2.69A10 10 0 0 1 21.3 15.65'), // key: 1pfsoa
      ElIconPathElement('M19.08 19.08A10 10 0 1 1 4.92 4.92'), // key: 1ablyi
    ],
  );

  /// `circle-parking-off.mjs`
  static const ElLucideGlyph
  circleParkingOff = ElLucideGlyph('circle-parking-off', <ElIconElement>[
    ElIconPathElement('M12.656 7H13a3 3 0 0 1 2.984 3.307'), // key: 1sjx87
    ElIconPathElement('M13 13H9'), // key: e2beee
    ElIconPathElement('M19.071 19.071A1 1 0 0 1 4.93 4.93'), // key: 1kb595
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement('M8.357 2.687a10 10 0 0 1 12.956 12.956'), // key: 5bsfdx
    ElIconPathElement('M9 17V9'), // key: ojradj
  ]);

  /// `circle-parking.mjs`
  static const ElLucideGlyph circleParking = ElLucideGlyph(
    'circle-parking',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('M9 17V7h4a3 3 0 0 1 0 6H9'), // key: 1dfk2c
    ],
  );

  /// `circle-pause.mjs`
  static const ElLucideGlyph circlePause = ElLucideGlyph(
    'circle-pause',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconLineElement(10, 15, 10, 9), // key: c1nkhi
      ElIconLineElement(14, 15, 14, 9), // key: h65svq
    ],
  );

  /// `circle-percent.mjs`
  static const ElLucideGlyph circlePercent = ElLucideGlyph(
    'circle-percent',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('m15 9-6 6'), // key: 1uzhvr
      ElIconPathElement('M9 9h.01'), // key: 1q5me6
      ElIconPathElement('M15 15h.01'), // key: lqbp3k
    ],
  );

  /// `circle-pile.mjs`
  static const ElLucideGlyph circlePile = ElLucideGlyph(
    'circle-pile',
    <ElIconElement>[
      ElIconCircleElement(12, 19, 2), // key: 13j0tp
      ElIconCircleElement(12, 5, 2), // key: f1ur92
      ElIconCircleElement(16, 12, 2), // key: 4ma0v8
      ElIconCircleElement(20, 19, 2), // key: 1obnsp
      ElIconCircleElement(4, 19, 2), // key: p3m9r0
      ElIconCircleElement(8, 12, 2), // key: 1nvbw3
    ],
  );

  /// `circle-play.mjs`
  static const ElLucideGlyph
  circlePlay = ElLucideGlyph('circle-play', <ElIconElement>[
    ElIconPathElement(
      'M9 9.003a1 1 0 0 1 1.517-.859l4.997 2.997a1 1 0 0 1 0 1.718l-4.997 2.997A1 1 0 0 1 9 14.996z',
    ), // key: kmsa83
    ElIconCircleElement(12, 12, 10), // key: 1mglay
  ]);

  /// `circle-plus.mjs`
  static const ElLucideGlyph circlePlus = ElLucideGlyph(
    'circle-plus',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('M8 12h8'), // key: 1wcyev
      ElIconPathElement('M12 8v8'), // key: napkw2
    ],
  );

  /// `circle-pound-sterling.mjs`
  static const ElLucideGlyph circlePoundSterling = ElLucideGlyph(
    'circle-pound-sterling',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('M10 16V9.5a1 1 0 0 1 5 0'), // key: 1i1are
      ElIconPathElement('M8 12h4'), // key: qz6y1c
      ElIconPathElement('M8 16h7'), // key: sbedsn
    ],
  );

  /// `circle-power.mjs`
  static const ElLucideGlyph circlePower = ElLucideGlyph(
    'circle-power',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('M12 7v4'), // key: xawao1
      ElIconPathElement('M7.998 9.003a5 5 0 1 0 8-.005'), // key: 1pek45
    ],
  );

  /// `circle-question-mark.mjs`
  static const ElLucideGlyph circleQuestionMark = ElLucideGlyph(
    'circle-question-mark',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3'), // key: 1u773s
      ElIconPathElement('M12 17h.01'), // key: p32p05
    ],
  );

  /// `circle-slash-2.mjs`
  static const ElLucideGlyph circleSlash2 = ElLucideGlyph(
    'circle-slash-2',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('M22 2 2 22'), // key: y4kqgn
    ],
  );

  /// `circle-slash.mjs`
  static const ElLucideGlyph circleSlash = ElLucideGlyph(
    'circle-slash',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconLineElement(9, 15, 15, 9), // key: 1dfufj
    ],
  );

  /// `circle-small.mjs`
  static const ElLucideGlyph circleSmall = ElLucideGlyph(
    'circle-small',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 6), // key: 1vlfrh
    ],
  );

  /// `circle-star.mjs`
  static const ElLucideGlyph
  circleStar = ElLucideGlyph('circle-star', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement(
      'M11.051 7.616a1 1 0 0 1 1.909.024l.737 1.452a1 1 0 0 0 .737.535l1.634.256a1 1 0 0 1 .588 1.806l-1.172 1.168a1 1 0 0 0-.282.866l.259 1.613a1 1 0 0 1-1.541 1.134l-1.465-.75a1 1 0 0 0-.912 0l-1.465.75a1 1 0 0 1-1.539-1.133l.258-1.613a1 1 0 0 0-.282-.867l-1.156-1.152a1 1 0 0 1 .572-1.822l1.633-.256a1 1 0 0 0 .737-.535z',
    ), // key: 285bvi
  ]);

  /// `circle-stop.mjs`
  static const ElLucideGlyph circleStop = ElLucideGlyph(
    'circle-stop',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconRectElement(9, 9, 6, 6, 1), // key: 1ssd4o
    ],
  );

  /// `circle-user-round.mjs`
  static const ElLucideGlyph circleUserRound = ElLucideGlyph(
    'circle-user-round',
    <ElIconElement>[
      ElIconPathElement('M17.925 20.056a6 6 0 0 0-11.851.001'), // key: z69sun
      ElIconCircleElement(12, 11, 4), // key: 1gt34v
      ElIconCircleElement(12, 12, 10), // key: 1mglay
    ],
  );

  /// `circle-user.mjs`
  static const ElLucideGlyph circleUser = ElLucideGlyph(
    'circle-user',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconCircleElement(12, 10, 3), // key: ilqhr7
      ElIconPathElement(
        'M7 20.662V19a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v1.662',
      ), // key: 154egf
    ],
  );

  /// `circle-x.mjs`
  static const ElLucideGlyph circleX = ElLucideGlyph(
    'circle-x',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('m15 9-6 6'), // key: 1uzhvr
      ElIconPathElement('m9 9 6 6'), // key: z0biqf
    ],
  );

  /// `circle.mjs`
  static const ElLucideGlyph circle = ElLucideGlyph('circle', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
  ]);

  /// `circuit-board.mjs`
  static const ElLucideGlyph circuitBoard = ElLucideGlyph(
    'circuit-board',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M11 9h4a2 2 0 0 0 2-2V3'), // key: 1ve2rv
      ElIconCircleElement(9, 9, 2), // key: af1f0g
      ElIconPathElement('M7 21v-4a2 2 0 0 1 2-2h4'), // key: 1fwkro
      ElIconCircleElement(15, 15, 2), // key: 3i40o0
    ],
  );

  /// `citrus.mjs`
  static const ElLucideGlyph citrus = ElLucideGlyph('citrus', <ElIconElement>[
    ElIconPathElement(
      'M21.66 17.67a1.08 1.08 0 0 1-.04 1.6A12 12 0 0 1 4.73 2.38a1.1 1.1 0 0 1 1.61-.04z',
    ), // key: 4ite01
    ElIconPathElement('M19.65 15.66A8 8 0 0 1 8.35 4.34'), // key: 1gxipu
    ElIconPathElement('m14 10-5.5 5.5'), // key: 92pfem
    ElIconPathElement('M14 17.85V10H6.15'), // key: xqmtsk
  ]);

  /// `clapperboard.mjs`
  static const ElLucideGlyph
  clapperboard = ElLucideGlyph('clapperboard', <ElIconElement>[
    ElIconPathElement('m12.296 3.464 3.02 3.956'), // key: qash78
    ElIconPathElement(
      'M20.2 6 3 11l-.9-2.4c-.3-1.1.3-2.2 1.3-2.5l13.5-4c1.1-.3 2.2.3 2.5 1.3z',
    ), // key: 1h7j8b
    ElIconPathElement(
      'M3 11h18v8a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z',
    ), // key: 4lm6w1
    ElIconPathElement('m6.18 5.276 3.1 3.899'), // key: zjj9t3
  ]);

  /// `clipboard-check.mjs`
  static const ElLucideGlyph
  clipboardCheck = ElLucideGlyph('clipboard-check', <ElIconElement>[
    ElIconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    ElIconPathElement(
      'M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2',
    ), // key: 116196
    ElIconPathElement('m9 14 2 2 4-4'), // key: df797q
  ]);

  /// `clipboard-clock.mjs`
  static const ElLucideGlyph
  clipboardClock = ElLucideGlyph('clipboard-clock', <ElIconElement>[
    ElIconPathElement('M16 14v2.2l1.6 1'), // key: fo4ql5
    ElIconPathElement('M16 4h2a2 2 0 0 1 2 2v.832'), // key: 1ujtp2
    ElIconPathElement('M8 4H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h2'), // key: qvpao1
    ElIconCircleElement(16, 16, 6), // key: qoo3c4
    ElIconRectElement(8, 2, 8, 4, 1), // key: ublpy
  ]);

  /// `clipboard-copy.mjs`
  static const ElLucideGlyph clipboardCopy = ElLucideGlyph(
    'clipboard-copy',
    <ElIconElement>[
      ElIconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
      ElIconPathElement(
        'M8 4H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-2',
      ), // key: 4jdomd
      ElIconPathElement('M16 4h2a2 2 0 0 1 2 2v4'), // key: 3hqy98
      ElIconPathElement('M21 14H11'), // key: 1bme5i
      ElIconPathElement('m15 10-4 4 4 4'), // key: 5dvupr
    ],
  );

  /// `clipboard-list.mjs`
  static const ElLucideGlyph
  clipboardList = ElLucideGlyph('clipboard-list', <ElIconElement>[
    ElIconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    ElIconPathElement(
      'M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2',
    ), // key: 116196
    ElIconPathElement('M12 11h4'), // key: 1jrz19
    ElIconPathElement('M12 16h4'), // key: n85exb
    ElIconPathElement('M8 11h.01'), // key: 1dfujw
    ElIconPathElement('M8 16h.01'), // key: 18s6g9
  ]);

  /// `clipboard-minus.mjs`
  static const ElLucideGlyph
  clipboardMinus = ElLucideGlyph('clipboard-minus', <ElIconElement>[
    ElIconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    ElIconPathElement(
      'M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2',
    ), // key: 116196
    ElIconPathElement('M9 14h6'), // key: 159ibu
  ]);

  /// `clipboard-paste.mjs`
  static const ElLucideGlyph clipboardPaste = ElLucideGlyph(
    'clipboard-paste',
    <ElIconElement>[
      ElIconPathElement('M11 14h10'), // key: 1w8e9d
      ElIconPathElement('M16 4h2a2 2 0 0 1 2 2v1.344'), // key: 1e62lh
      ElIconPathElement('m17 18 4-4-4-4'), // key: z2g111
      ElIconPathElement(
        'M8 4H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 1.793-1.113',
      ), // key: bjbb7m
      ElIconRectElement(8, 2, 8, 4, 1), // key: ublpy
    ],
  );

  /// `clipboard-pen-line.mjs`
  static const ElLucideGlyph
  clipboardPenLine = ElLucideGlyph('clipboard-pen-line', <ElIconElement>[
    ElIconRectElement(8, 2, 8, 4, 1), // key: 1oijnt
    ElIconPathElement(
      'M8 4H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-.5',
    ), // key: 1but9f
    ElIconPathElement('M16 4h2a2 2 0 0 1 1.73 1'), // key: 1p8n7l
    ElIconPathElement('M8 18h1'), // key: 13wk12
    ElIconPathElement(
      'M21.378 12.626a1 1 0 0 0-3.004-3.004l-4.01 4.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z',
    ), // key: 2t3380
  ]);

  /// `clipboard-pen.mjs`
  static const ElLucideGlyph
  clipboardPen = ElLucideGlyph('clipboard-pen', <ElIconElement>[
    ElIconPathElement('M16 4h2a2 2 0 0 1 2 2v2'), // key: j91f56
    ElIconPathElement(
      'M21.34 15.664a1 1 0 1 0-3.004-3.004l-5.01 5.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z',
    ), // key: 16fuwn
    ElIconPathElement('M8 22H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2'), // key: 120tdm
    ElIconRectElement(8, 2, 8, 4, 1), // key: ublpy
  ]);

  /// `clipboard-plus.mjs`
  static const ElLucideGlyph
  clipboardPlus = ElLucideGlyph('clipboard-plus', <ElIconElement>[
    ElIconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    ElIconPathElement(
      'M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2',
    ), // key: 116196
    ElIconPathElement('M9 14h6'), // key: 159ibu
    ElIconPathElement('M12 17v-6'), // key: 1y8rbf
  ]);

  /// `clipboard-type.mjs`
  static const ElLucideGlyph
  clipboardType = ElLucideGlyph('clipboard-type', <ElIconElement>[
    ElIconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    ElIconPathElement(
      'M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2',
    ), // key: 116196
    ElIconPathElement('M9 12v-1h6v1'), // key: iehl6m
    ElIconPathElement('M11 17h2'), // key: 12w5me
    ElIconPathElement('M12 11v6'), // key: 1bwqyc
  ]);

  /// `clipboard-x.mjs`
  static const ElLucideGlyph
  clipboardX = ElLucideGlyph('clipboard-x', <ElIconElement>[
    ElIconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    ElIconPathElement(
      'M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2',
    ), // key: 116196
    ElIconPathElement('m15 11-6 6'), // key: 1toa9n
    ElIconPathElement('m9 11 6 6'), // key: wlibny
  ]);

  /// `clipboard.mjs`
  static const ElLucideGlyph
  clipboard = ElLucideGlyph('clipboard', <ElIconElement>[
    ElIconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    ElIconPathElement(
      'M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2',
    ), // key: 116196
  ]);

  /// `clock-1.mjs`
  static const ElLucideGlyph clock1 = ElLucideGlyph('clock-1', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement('M12 6v6l2-4'), // key: miptyd
  ]);

  /// `clock-10.mjs`
  static const ElLucideGlyph clock10 = ElLucideGlyph(
    'clock-10',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('M12 6v6l-4-2'), // key: cedpoo
    ],
  );

  /// `clock-11.mjs`
  static const ElLucideGlyph clock11 = ElLucideGlyph(
    'clock-11',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('M12 6v6l-2-4'), // key: ns39ag
    ],
  );

  /// `clock-12.mjs`
  static const ElLucideGlyph clock12 = ElLucideGlyph(
    'clock-12',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('M12 6v6'), // key: 1ipuwl
    ],
  );

  /// `clock-2.mjs`
  static const ElLucideGlyph clock2 = ElLucideGlyph('clock-2', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement('M12 6v6l4-2'), // key: 1r2kuh
  ]);

  /// `clock-3.mjs`
  static const ElLucideGlyph clock3 = ElLucideGlyph('clock-3', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement('M12 6v6h4'), // key: 135r8i
  ]);

  /// `clock-4.mjs`
  static const ElLucideGlyph clock4 = ElLucideGlyph('clock-4', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement('M12 6v6l4 2'), // key: mmk7yg
  ]);

  /// `clock-5.mjs`
  static const ElLucideGlyph clock5 = ElLucideGlyph('clock-5', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement('M12 6v6l2 4'), // key: 1287s9
  ]);

  /// `clock-6.mjs`
  static const ElLucideGlyph clock6 = ElLucideGlyph('clock-6', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement('M12 6v10'), // key: wf7rdh
  ]);

  /// `clock-7.mjs`
  static const ElLucideGlyph clock7 = ElLucideGlyph('clock-7', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement('M12 6v6l-2 4'), // key: 1095bu
  ]);

  /// `clock-8.mjs`
  static const ElLucideGlyph clock8 = ElLucideGlyph('clock-8', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement('M12 6v6l-4 2'), // key: imc3wl
  ]);

  /// `clock-9.mjs`
  static const ElLucideGlyph clock9 = ElLucideGlyph('clock-9', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement('M12 6v6H8'), // key: u39vzm
  ]);

  /// `clock-alert.mjs`
  static const ElLucideGlyph clockAlert = ElLucideGlyph(
    'clock-alert',
    <ElIconElement>[
      ElIconPathElement('M12 6v6l4 2'), // key: mmk7yg
      ElIconPathElement('M20 12v5'), // key: 12wsvk
      ElIconPathElement('M20 21h.01'), // key: 1p6o6n
      ElIconPathElement('M21.25 8.2A10 10 0 1 0 16 21.16'), // key: 17fp9f
    ],
  );

  /// `clock-arrow-down.mjs`
  static const ElLucideGlyph clockArrowDown = ElLucideGlyph(
    'clock-arrow-down',
    <ElIconElement>[
      ElIconPathElement('M12 6v6l2 1'), // key: 19cm8n
      ElIconPathElement('M12.337 21.994a10 10 0 1 1 9.588-8.767'), // key: 28moa
      ElIconPathElement('m14 18 4 4 4-4'), // key: 1waygx
      ElIconPathElement('M18 14v8'), // key: irew45
    ],
  );

  /// `clock-arrow-left.mjs`
  static const ElLucideGlyph
  clockArrowLeft = ElLucideGlyph('clock-arrow-left', <ElIconElement>[
    ElIconPathElement('M12 6v6l1.5.8'), // key: uc7jki
    ElIconPathElement('M12.338 21.994a10 10 0 1 1 9.587-8.767'), // key: 1lz5pu
    ElIconPathElement('M14 18h8'), // key: 1le3fr
    ElIconPathElement('m18 22-4-4 4-4'), // key: dh5o1f
  ]);

  /// `clock-arrow-right.mjs`
  static const ElLucideGlyph clockArrowRight = ElLucideGlyph(
    'clock-arrow-right',
    <ElIconElement>[
      ElIconPathElement('M12 6v6l2 1'), // key: 19cm8n
      ElIconPathElement('M13.5 21.885A10 10 0 1 1 22 12'), // key: xgp8as
      ElIconPathElement('M14 18h8'), // key: 1le3fr
      ElIconPathElement('m18 22 4-4-4-4'), // key: mordo3
    ],
  );

  /// `clock-arrow-up.mjs`
  static const ElLucideGlyph
  clockArrowUp = ElLucideGlyph('clock-arrow-up', <ElIconElement>[
    ElIconPathElement('M12 6v6l1.56.78'), // key: 14ed3g
    ElIconPathElement('M13.227 21.925a10 10 0 1 1 8.767-9.588'), // key: jwkls1
    ElIconPathElement('m14 18 4-4 4 4'), // key: ftkppy
    ElIconPathElement('M18 22v-8'), // key: su0gjh
  ]);

  /// `clock-check.mjs`
  static const ElLucideGlyph clockCheck = ElLucideGlyph(
    'clock-check',
    <ElIconElement>[
      ElIconPathElement('M12 6v6l4 2'), // key: mmk7yg
      ElIconPathElement('M22 12a10 10 0 1 0-11 9.95'), // key: 17dhok
      ElIconPathElement('m22 16-5.5 5.5L14 19'), // key: 1eibut
    ],
  );

  /// `clock-fading.mjs`
  static const ElLucideGlyph clockFading = ElLucideGlyph(
    'clock-fading',
    <ElIconElement>[
      ElIconPathElement('M12 2a10 10 0 0 1 7.38 16.75'), // key: 175t95
      ElIconPathElement('M12 6v6l4 2'), // key: mmk7yg
      ElIconPathElement('M2.5 8.875a10 10 0 0 0-.5 3'), // key: 1vce0s
      ElIconPathElement('M2.83 16a10 10 0 0 0 2.43 3.4'), // key: o3fkw4
      ElIconPathElement('M4.636 5.235a10 10 0 0 1 .891-.857'), // key: 1szpfk
      ElIconPathElement('M8.644 21.42a10 10 0 0 0 7.631-.38'), // key: 9yhvd4
    ],
  );

  /// `clock-plus.mjs`
  static const ElLucideGlyph clockPlus = ElLucideGlyph(
    'clock-plus',
    <ElIconElement>[
      ElIconPathElement('M12 6v6l3.644 1.822'), // key: 1jmett
      ElIconPathElement('M16 19h6'), // key: xwg31i
      ElIconPathElement('M19 16v6'), // key: tddt3s
      ElIconPathElement('M21.92 13.267a10 10 0 1 0-8.653 8.653'), // key: 1u0osk
    ],
  );

  /// `clock.mjs`
  static const ElLucideGlyph clock = ElLucideGlyph('clock', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement('M12 6v6l4 2'), // key: mmk7yg
  ]);

  /// `closed-caption.mjs`
  static const ElLucideGlyph closedCaption = ElLucideGlyph(
    'closed-caption',
    <ElIconElement>[
      ElIconPathElement('M10 9.17a3 3 0 1 0 0 5.66'), // key: h9wayk
      ElIconPathElement('M17 9.17a3 3 0 1 0 0 5.66'), // key: 1v6zke
      ElIconRectElement(2, 5, 20, 14, 2), // key: qneu4z
    ],
  );

  /// `cloud-alert.mjs`
  static const ElLucideGlyph cloudAlert = ElLucideGlyph(
    'cloud-alert',
    <ElIconElement>[
      ElIconPathElement('M12 12v4'), // key: tww15h
      ElIconPathElement('M12 20h.01'), // key: zekei9
      ElIconPathElement(
        'M8.128 16.949A7 7 0 1 1 15.71 8h1.79a1 1 0 0 1 0 9h-1.642',
      ), // key: 1namsd
    ],
  );

  /// `cloud-backup.mjs`
  static const ElLucideGlyph
  cloudBackup = ElLucideGlyph('cloud-backup', <ElIconElement>[
    ElIconPathElement(
      'M21 15.251A4.5 4.5 0 0 0 17.5 8h-1.79A7 7 0 1 0 3 13.607',
    ), // key: xpoh9y
    ElIconPathElement('M7 11v4h4'), // key: q9yh32
    ElIconPathElement(
      'M8 19a5 5 0 0 0 9-3 4.5 4.5 0 0 0-4.5-4.5 4.82 4.82 0 0 0-3.41 1.41L7 15',
    ), // key: 1xm8iu
  ]);

  /// `cloud-check.mjs`
  static const ElLucideGlyph cloudCheck = ElLucideGlyph(
    'cloud-check',
    <ElIconElement>[
      ElIconPathElement('m17 15-5.5 5.5L9 18'), // key: 15q87x
      ElIconPathElement(
        'M5.516 16.07A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 3.501 7.327',
      ), // key: 1xtj56
    ],
  );

  /// `cloud-cog.mjs`
  static const ElLucideGlyph
  cloudCog = ElLucideGlyph('cloud-cog', <ElIconElement>[
    ElIconPathElement('m10.852 19.772-.383.924'), // key: r7sl7d
    ElIconPathElement('m13.148 14.228.383-.923'), // key: 1d5zpm
    ElIconPathElement(
      'M13.148 19.772a3 3 0 1 0-2.296-5.544l-.383-.923',
    ), // key: 1ydik7
    ElIconPathElement(
      'm13.53 20.696-.382-.924a3 3 0 1 1-2.296-5.544',
    ), // key: 1m1vsf
    ElIconPathElement('m14.772 15.852.923-.383'), // key: 660p6e
    ElIconPathElement('m14.772 18.148.923.383'), // key: hrcpis
    ElIconPathElement(
      'M4.2 15.1a7 7 0 1 1 9.93-9.858A7 7 0 0 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.2',
    ), // key: j2q98n
    ElIconPathElement('m9.228 15.852-.923-.383'), // key: 1p9ong
    ElIconPathElement('m9.228 18.148-.923.383'), // key: 6558rz
  ]);

  /// `cloud-download.mjs`
  static const ElLucideGlyph cloudDownload = ElLucideGlyph(
    'cloud-download',
    <ElIconElement>[
      ElIconPathElement('M12 13v8l-4-4'), // key: 1f5nwf
      ElIconPathElement('m12 21 4-4'), // key: 1lfcce
      ElIconPathElement(
        'M4.393 15.269A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.436 8.284',
      ), // key: ui1hmy
    ],
  );

  /// `cloud-drizzle.mjs`
  static const ElLucideGlyph cloudDrizzle = ElLucideGlyph(
    'cloud-drizzle',
    <ElIconElement>[
      ElIconPathElement(
        'M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242',
      ), // key: 1pljnt
      ElIconPathElement('M8 19v1'), // key: 1dk2by
      ElIconPathElement('M8 14v1'), // key: 84yxot
      ElIconPathElement('M16 19v1'), // key: v220m7
      ElIconPathElement('M16 14v1'), // key: g12gj6
      ElIconPathElement('M12 21v1'), // key: q8vafk
      ElIconPathElement('M12 16v1'), // key: 1mx6rx
    ],
  );

  /// `cloud-fog.mjs`
  static const ElLucideGlyph cloudFog = ElLucideGlyph(
    'cloud-fog',
    <ElIconElement>[
      ElIconPathElement(
        'M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242',
      ), // key: 1pljnt
      ElIconPathElement('M16 17H7'), // key: pygtm1
      ElIconPathElement('M17 21H9'), // key: 1u2q02
    ],
  );

  /// `cloud-hail.mjs`
  static const ElLucideGlyph cloudHail = ElLucideGlyph(
    'cloud-hail',
    <ElIconElement>[
      ElIconPathElement(
        'M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242',
      ), // key: 1pljnt
      ElIconPathElement('M16 14v2'), // key: a1is7l
      ElIconPathElement('M8 14v2'), // key: 1e9m6t
      ElIconPathElement('M16 20h.01'), // key: xwek51
      ElIconPathElement('M8 20h.01'), // key: 1vjney
      ElIconPathElement('M12 16v2'), // key: z66u1j
      ElIconPathElement('M12 22h.01'), // key: 1urd7a
    ],
  );

  /// `cloud-lightning.mjs`
  static const ElLucideGlyph cloudLightning = ElLucideGlyph(
    'cloud-lightning',
    <ElIconElement>[
      ElIconPathElement(
        'M6 16.326A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 .5 8.973',
      ), // key: 1cez44
      ElIconPathElement('m13 12-3 5h4l-3 5'), // key: 1t22er
    ],
  );

  /// `cloud-moon-rain.mjs`
  static const ElLucideGlyph
  cloudMoonRain = ElLucideGlyph('cloud-moon-rain', <ElIconElement>[
    ElIconPathElement('M11 20v2'), // key: 174qtz
    ElIconPathElement(
      'M18.376 14.512a6 6 0 0 0 3.461-4.127c.148-.625-.659-.97-1.248-.714a4 4 0 0 1-5.259-5.26c.255-.589-.09-1.395-.716-1.248a6 6 0 0 0-4.594 5.36',
    ), // key: zwnc1e
    ElIconPathElement(
      'M3 20a5 5 0 1 1 8.9-4H13a3 3 0 0 1 2 5.24',
    ), // key: 1qmrp3
    ElIconPathElement('M7 19v2'), // key: 12npes
  ]);

  /// `cloud-moon.mjs`
  static const ElLucideGlyph
  cloudMoon = ElLucideGlyph('cloud-moon', <ElIconElement>[
    ElIconPathElement('M13 16a3 3 0 0 1 0 6H7a5 5 0 1 1 4.9-6z'), // key: ie2ih4
    ElIconPathElement(
      'M18.376 14.512a6 6 0 0 0 3.461-4.127c.148-.625-.659-.97-1.248-.714a4 4 0 0 1-5.259-5.26c.255-.589-.09-1.395-.716-1.248a6 6 0 0 0-4.594 5.36',
    ), // key: zwnc1e
  ]);

  /// `cloud-off.mjs`
  static const ElLucideGlyph cloudOff = ElLucideGlyph(
    'cloud-off',
    <ElIconElement>[
      ElIconPathElement(
        'M10.94 5.274A7 7 0 0 1 15.71 10h1.79a4.5 4.5 0 0 1 4.222 6.057',
      ), // key: 1uxyv8
      ElIconPathElement(
        'M18.796 18.81A4.5 4.5 0 0 1 17.5 19H9A7 7 0 0 1 5.79 5.78',
      ), // key: 99tcn7
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ],
  );

  /// `cloud-rain-wind.mjs`
  static const ElLucideGlyph cloudRainWind = ElLucideGlyph(
    'cloud-rain-wind',
    <ElIconElement>[
      ElIconPathElement(
        'M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242',
      ), // key: 1pljnt
      ElIconPathElement('m9.2 22 3-7'), // key: sb5f6j
      ElIconPathElement('m9 13-3 7'), // key: 500co5
      ElIconPathElement('m17 13-3 7'), // key: 8t2fiy
    ],
  );

  /// `cloud-rain.mjs`
  static const ElLucideGlyph cloudRain = ElLucideGlyph(
    'cloud-rain',
    <ElIconElement>[
      ElIconPathElement(
        'M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242',
      ), // key: 1pljnt
      ElIconPathElement('M16 14v6'), // key: 1j4efv
      ElIconPathElement('M8 14v6'), // key: 17c4r9
      ElIconPathElement('M12 16v6'), // key: c8a4gj
    ],
  );

  /// `cloud-snow.mjs`
  static const ElLucideGlyph cloudSnow = ElLucideGlyph(
    'cloud-snow',
    <ElIconElement>[
      ElIconPathElement(
        'M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242',
      ), // key: 1pljnt
      ElIconPathElement('M8 15h.01'), // key: a7atzg
      ElIconPathElement('M8 19h.01'), // key: puxtts
      ElIconPathElement('M12 17h.01'), // key: p32p05
      ElIconPathElement('M12 21h.01'), // key: h35vbk
      ElIconPathElement('M16 15h.01'), // key: rnfrdf
      ElIconPathElement('M16 19h.01'), // key: 1vcnzz
    ],
  );

  /// `cloud-sun-rain.mjs`
  static const ElLucideGlyph cloudSunRain = ElLucideGlyph(
    'cloud-sun-rain',
    <ElIconElement>[
      ElIconPathElement('M12 2v2'), // key: tus03m
      ElIconPathElement('m4.93 4.93 1.41 1.41'), // key: 149t6j
      ElIconPathElement('M20 12h2'), // key: 1q8mjw
      ElIconPathElement('m19.07 4.93-1.41 1.41'), // key: 1shlcs
      ElIconPathElement('M15.947 12.65a4 4 0 0 0-5.925-4.128'), // key: dpwdj0
      ElIconPathElement(
        'M3 20a5 5 0 1 1 8.9-4H13a3 3 0 0 1 2 5.24',
      ), // key: 1qmrp3
      ElIconPathElement('M11 20v2'), // key: 174qtz
      ElIconPathElement('M7 19v2'), // key: 12npes
    ],
  );

  /// `cloud-sun.mjs`
  static const ElLucideGlyph cloudSun = ElLucideGlyph(
    'cloud-sun',
    <ElIconElement>[
      ElIconPathElement('M12 2v2'), // key: tus03m
      ElIconPathElement('m4.93 4.93 1.41 1.41'), // key: 149t6j
      ElIconPathElement('M20 12h2'), // key: 1q8mjw
      ElIconPathElement('m19.07 4.93-1.41 1.41'), // key: 1shlcs
      ElIconPathElement('M15.947 12.65a4 4 0 0 0-5.925-4.128'), // key: dpwdj0
      ElIconPathElement(
        'M13 22H7a5 5 0 1 1 4.9-6H13a3 3 0 0 1 0 6Z',
      ), // key: s09mg5
    ],
  );

  /// `cloud-sync.mjs`
  static const ElLucideGlyph cloudSync = ElLucideGlyph(
    'cloud-sync',
    <ElIconElement>[
      ElIconPathElement('m17 18-1.535 1.605a5 5 0 0 1-8-1.5'), // key: adpv5j
      ElIconPathElement('M17 22v-4h-4'), // key: ex1ofj
      ElIconPathElement(
        'M20.996 15.251A4.5 4.5 0 0 0 17.495 8h-1.79a7 7 0 1 0-12.709 5.607',
      ), // key: ziqt14
      ElIconPathElement('M7 10v4h4'), // key: 1j6gx1
      ElIconPathElement('m7 14 1.535-1.605a5 5 0 0 1 8 1.5'), // key: 19q5h7
    ],
  );

  /// `cloud-upload.mjs`
  static const ElLucideGlyph cloudUpload = ElLucideGlyph(
    'cloud-upload',
    <ElIconElement>[
      ElIconPathElement('M12 13v8'), // key: 1l5pq0
      ElIconPathElement(
        'M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242',
      ), // key: 1pljnt
      ElIconPathElement('m8 17 4-4 4 4'), // key: 1quai1
    ],
  );

  /// `cloud.mjs`
  static const ElLucideGlyph cloud = ElLucideGlyph('cloud', <ElIconElement>[
    ElIconPathElement(
      'M17.5 19H9a7 7 0 1 1 6.71-9h1.79a4.5 4.5 0 1 1 0 9Z',
    ), // key: p7xjir
  ]);

  /// `cloudy.mjs`
  static const ElLucideGlyph cloudy = ElLucideGlyph('cloudy', <ElIconElement>[
    ElIconPathElement(
      'M17.5 12a1 1 0 1 1 0 9H9.006a7 7 0 1 1 6.702-9z',
    ), // key: 44yre2
    ElIconPathElement(
      'M21.832 9A3 3 0 0 0 19 7h-2.207a5.5 5.5 0 0 0-10.72.61',
    ), // key: leugyv
  ]);

  /// `clover.mjs`
  static const ElLucideGlyph clover = ElLucideGlyph('clover', <ElIconElement>[
    ElIconPathElement('M16.17 7.83 2 22'), // key: t58vo8
    ElIconPathElement(
      'M4.02 12a2.827 2.827 0 1 1 3.81-4.17A2.827 2.827 0 1 1 12 4.02a2.827 2.827 0 1 1 4.17 3.81A2.827 2.827 0 1 1 19.98 12a2.827 2.827 0 1 1-3.81 4.17A2.827 2.827 0 1 1 12 19.98a2.827 2.827 0 1 1-4.17-3.81A1 1 0 1 1 4 12',
    ), // key: 17k36q
    ElIconPathElement('m7.83 7.83 8.34 8.34'), // key: 1d7sxk
  ]);

  /// `club.mjs`
  static const ElLucideGlyph club = ElLucideGlyph('club', <ElIconElement>[
    ElIconPathElement(
      'M17.28 9.05a5.5 5.5 0 1 0-10.56 0A5.5 5.5 0 1 0 12 17.66a5.5 5.5 0 1 0 5.28-8.6Z',
    ), // key: 27yuqz
    ElIconPathElement('M12 17.66L12 22'), // key: ogfahf
  ]);

  /// `code-xml.mjs`
  static const ElLucideGlyph codeXml = ElLucideGlyph(
    'code-xml',
    <ElIconElement>[
      ElIconPathElement('m18 16 4-4-4-4'), // key: 1inbqp
      ElIconPathElement('m6 8-4 4 4 4'), // key: 15zrgr
      ElIconPathElement('m14.5 4-5 16'), // key: e7oirm
    ],
  );

  /// `code.mjs`
  static const ElLucideGlyph code = ElLucideGlyph('code', <ElIconElement>[
    ElIconPathElement('m16 18 6-6-6-6'), // key: eg8j8
    ElIconPathElement('m8 6-6 6 6 6'), // key: ppft3o
  ]);

  /// `coffee.mjs`
  static const ElLucideGlyph coffee = ElLucideGlyph('coffee', <ElIconElement>[
    ElIconPathElement('M10 2v2'), // key: 7u0qdc
    ElIconPathElement('M14 2v2'), // key: 6buw04
    ElIconPathElement(
      'M16 8a1 1 0 0 1 1 1v8a4 4 0 0 1-4 4H7a4 4 0 0 1-4-4V9a1 1 0 0 1 1-1h14a4 4 0 1 1 0 8h-1',
    ), // key: pwadti
    ElIconPathElement('M6 2v2'), // key: colzsn
  ]);

  /// `cog.mjs`
  static const ElLucideGlyph cog = ElLucideGlyph('cog', <ElIconElement>[
    ElIconPathElement('M11 10.27 7 3.34'), // key: 16pf9h
    ElIconPathElement('m11 13.73-4 6.93'), // key: 794ttg
    ElIconPathElement('M12 22v-2'), // key: 1osdcq
    ElIconPathElement('M12 2v2'), // key: tus03m
    ElIconPathElement('M14 12h8'), // key: 4f43i9
    ElIconPathElement('m17 20.66-1-1.73'), // key: eq3orb
    ElIconPathElement('m17 3.34-1 1.73'), // key: 2wel8s
    ElIconPathElement('M2 12h2'), // key: 1t8f8n
    ElIconPathElement('m20.66 17-1.73-1'), // key: sg0v6f
    ElIconPathElement('m20.66 7-1.73 1'), // key: 1ow05n
    ElIconPathElement('m3.34 17 1.73-1'), // key: nuk764
    ElIconPathElement('m3.34 7 1.73 1'), // key: 1ulond
    ElIconCircleElement(12, 12, 2), // key: 1c9p78
    ElIconCircleElement(12, 12, 8), // key: 46899m
  ]);

  /// `coins.mjs`
  static const ElLucideGlyph coins = ElLucideGlyph('coins', <ElIconElement>[
    ElIconPathElement('M13.744 17.736a6 6 0 1 1-7.48-7.48'), // key: bq4yh3
    ElIconPathElement('M15 6h1v4'), // key: 11y1tn
    ElIconPathElement('m6.134 14.768.866-.5 2 3.464'), // key: 17snzx
    ElIconCircleElement(16, 8, 6), // key: 14bfc9
  ]);

  /// `columns-2.mjs`
  static const ElLucideGlyph columns2 = ElLucideGlyph(
    'columns-2',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M12 3v18'), // key: 108xh3
    ],
  );

  /// `columns-3-cog.mjs`
  static const ElLucideGlyph columns3Cog = ElLucideGlyph(
    'columns-3-cog',
    <ElIconElement>[
      ElIconPathElement(
        'M10.6 21H5a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v5.6',
      ), // key: 19s2bv
      ElIconPathElement('m14.305 19.53.923-.382'), // key: 3m78fa
      ElIconPathElement('M15 3v7.6'), // key: mv9izd
      ElIconPathElement('m15.229 16.852-.924-.383'), // key: qpfz85
      ElIconPathElement('m16.852 15.228-.383-.923'), // key: 5xggr7
      ElIconPathElement('m16.852 20.772-.383.924'), // key: dpfhf9
      ElIconPathElement('m19.148 15.228.383-.923'), // key: 1reyyz
      ElIconPathElement('m19.53 21.696-.382-.924'), // key: 1goivc
      ElIconPathElement('m20.773 16.852.922-.383'), // key: 59dfo2
      ElIconPathElement('m20.773 19.148.922.383'), // key: 1lk755
      ElIconPathElement('M9 3v18'), // key: fh3hqa
      ElIconCircleElement(18, 18, 3), // key: 1xkwt0
    ],
  );

  /// `columns-3.mjs`
  static const ElLucideGlyph columns3 = ElLucideGlyph(
    'columns-3',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M9 3v18'), // key: fh3hqa
      ElIconPathElement('M15 3v18'), // key: 14nvp0
    ],
  );

  /// `columns-4.mjs`
  static const ElLucideGlyph columns4 = ElLucideGlyph(
    'columns-4',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M7.5 3v18'), // key: w0wo6v
      ElIconPathElement('M12 3v18'), // key: 108xh3
      ElIconPathElement('M16.5 3v18'), // key: 10tjh1
    ],
  );

  /// `combine.mjs`
  static const ElLucideGlyph combine = ElLucideGlyph('combine', <ElIconElement>[
    ElIconPathElement('M14 3a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1'), // key: 1l7d7l
    ElIconPathElement('M19 3a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1'), // key: 9955pe
    ElIconPathElement('m7 15 3 3'), // key: 4hkfgk
    ElIconPathElement('m7 21 3-3H5a2 2 0 0 1-2-2v-2'), // key: 1xljwe
    ElIconRectElement(14, 14, 7, 7, 1), // key: 1cdgtw
    ElIconRectElement(3, 3, 7, 7, 1), // key: zi3rio
  ]);

  /// `command.mjs`
  static const ElLucideGlyph command = ElLucideGlyph('command', <ElIconElement>[
    ElIconPathElement(
      'M15 6v12a3 3 0 1 0 3-3H6a3 3 0 1 0 3 3V6a3 3 0 1 0-3 3h12a3 3 0 1 0-3-3',
    ), // key: 11bfej
  ]);

  /// `compass.mjs`
  static const ElLucideGlyph compass = ElLucideGlyph('compass', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement(
      'm16.24 7.76-1.804 5.411a2 2 0 0 1-1.265 1.265L7.76 16.24l1.804-5.411a2 2 0 0 1 1.265-1.265z',
    ), // key: 9ktpf1
  ]);

  /// `component.mjs`
  static const ElLucideGlyph
  component = ElLucideGlyph('component', <ElIconElement>[
    ElIconPathElement(
      'M15.536 11.293a1 1 0 0 0 0 1.414l2.376 2.377a1 1 0 0 0 1.414 0l2.377-2.377a1 1 0 0 0 0-1.414l-2.377-2.377a1 1 0 0 0-1.414 0z',
    ), // key: 1uwlt4
    ElIconPathElement(
      'M2.297 11.293a1 1 0 0 0 0 1.414l2.377 2.377a1 1 0 0 0 1.414 0l2.377-2.377a1 1 0 0 0 0-1.414L6.088 8.916a1 1 0 0 0-1.414 0z',
    ), // key: 10291m
    ElIconPathElement(
      'M8.916 17.912a1 1 0 0 0 0 1.415l2.377 2.376a1 1 0 0 0 1.414 0l2.377-2.376a1 1 0 0 0 0-1.415l-2.377-2.376a1 1 0 0 0-1.414 0z',
    ), // key: 1tqoq1
    ElIconPathElement(
      'M8.916 4.674a1 1 0 0 0 0 1.414l2.377 2.376a1 1 0 0 0 1.414 0l2.377-2.376a1 1 0 0 0 0-1.414l-2.377-2.377a1 1 0 0 0-1.414 0z',
    ), // key: 1x6lto
  ]);

  /// `computer.mjs`
  static const ElLucideGlyph computer = ElLucideGlyph(
    'computer',
    <ElIconElement>[
      ElIconRectElement(5, 2, 14, 8, 2), // key: wc9tft
      ElIconRectElement(2, 14, 20, 8, 2), // key: w68u3i
      ElIconPathElement('M6 18h2'), // key: rwmk9e
      ElIconPathElement('M12 18h6'), // key: aqd8w3
    ],
  );

  /// `concierge-bell.mjs`
  static const ElLucideGlyph
  conciergeBell = ElLucideGlyph('concierge-bell', <ElIconElement>[
    ElIconPathElement(
      'M3 20a1 1 0 0 1-1-1v-1a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1Z',
    ), // key: 1pvr1r
    ElIconPathElement('M20 16a8 8 0 1 0-16 0'), // key: 1pa543
    ElIconPathElement('M12 4v4'), // key: 1bq03y
    ElIconPathElement('M10 4h4'), // key: 1xpv9s
  ]);

  /// `cone.mjs`
  static const ElLucideGlyph cone = ElLucideGlyph('cone', <ElIconElement>[
    ElIconPathElement(
      'm20.9 18.55-8-15.98a1 1 0 0 0-1.8 0l-8 15.98',
    ), // key: 53pte7
    ElIconEllipseElement(12, 19, 9, 3), // key: 1ji25f
  ]);

  /// `construction.mjs`
  static const ElLucideGlyph construction = ElLucideGlyph(
    'construction',
    <ElIconElement>[
      ElIconRectElement(2, 6, 20, 8, 1), // key: 1estib
      ElIconPathElement('M17 14v7'), // key: 7m2elx
      ElIconPathElement('M7 14v7'), // key: 1cm7wv
      ElIconPathElement('M17 3v3'), // key: 1v4jwn
      ElIconPathElement('M7 3v3'), // key: 7o6guu
      ElIconPathElement('M10 14 2.3 6.3'), // key: 1023jk
      ElIconPathElement('m14 6 7.7 7.7'), // key: 1s8pl2
      ElIconPathElement('m8 6 8 8'), // key: hl96qh
    ],
  );

  /// `contact-round.mjs`
  static const ElLucideGlyph contactRound = ElLucideGlyph(
    'contact-round',
    <ElIconElement>[
      ElIconPathElement('M16 2v2'), // key: scm5qe
      ElIconPathElement('M17.915 21a6 6 0 10-12 0'), // key: 13n4mv
      ElIconPathElement('M8 2v2'), // key: pbkmx
      ElIconCircleElement(12, 11, 4), // key: 1gt34v
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `contact.mjs`
  static const ElLucideGlyph contact = ElLucideGlyph('contact', <ElIconElement>[
    ElIconPathElement('M16 2v2'), // key: scm5qe
    ElIconPathElement('M7 21v-2a2 2 0 012-2h6a2 2 0 012 2v2'), // key: k82dct
    ElIconPathElement('M8 2v2'), // key: pbkmx
    ElIconCircleElement(12, 10, 3), // key: ilqhr7
    ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `container.mjs`
  static const ElLucideGlyph
  container = ElLucideGlyph('container', <ElIconElement>[
    ElIconPathElement(
      'M22 7.7c0-.6-.4-1.2-.8-1.5l-6.3-3.9a1.72 1.72 0 0 0-1.7 0l-10.3 6c-.5.2-.9.8-.9 1.4v6.6c0 .5.4 1.2.8 1.5l6.3 3.9a1.72 1.72 0 0 0 1.7 0l10.3-6c.5-.3.9-1 .9-1.5Z',
    ), // key: 1t2lqe
    ElIconPathElement('M10 21.9V14L2.1 9.1'), // key: o7czzq
    ElIconPathElement('m10 14 11.9-6.9'), // key: zm5e20
    ElIconPathElement('M14 19.8v-8.1'), // key: 159ecu
    ElIconPathElement('M18 17.5V9.4'), // key: 11uown
  ]);

  /// `contrast.mjs`
  static const ElLucideGlyph contrast = ElLucideGlyph(
    'contrast',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('M12 18a6 6 0 0 0 0-12v12z'), // key: j4l70d
    ],
  );

  /// `cookie.mjs`
  static const ElLucideGlyph cookie = ElLucideGlyph('cookie', <ElIconElement>[
    ElIconPathElement(
      'M12 2a10 10 0 1 0 10 10 4 4 0 0 1-5-5 4 4 0 0 1-5-5',
    ), // key: laymnq
    ElIconPathElement('M8.5 8.5v.01'), // key: ue8clq
    ElIconPathElement('M16 15.5v.01'), // key: 14dtrp
    ElIconPathElement('M12 12v.01'), // key: u5ubse
    ElIconPathElement('M11 17v.01'), // key: 1hyl5a
    ElIconPathElement('M7 14v.01'), // key: uct60s
  ]);

  /// `cooking-pot.mjs`
  static const ElLucideGlyph
  cookingPot = ElLucideGlyph('cooking-pot', <ElIconElement>[
    ElIconPathElement('M2 12h20'), // key: 9i4pu4
    ElIconPathElement(
      'M20 12v8a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-8',
    ), // key: u0tga0
    ElIconPathElement('m4 8 16-4'), // key: 16g0ng
    ElIconPathElement(
      'm8.86 6.78-.45-1.81a2 2 0 0 1 1.45-2.43l1.94-.48a2 2 0 0 1 2.43 1.46l.45 1.8',
    ), // key: 12cejc
  ]);

  /// `copy-check.mjs`
  static const ElLucideGlyph copyCheck = ElLucideGlyph(
    'copy-check',
    <ElIconElement>[
      ElIconPathElement('m12 15 2 2 4-4'), // key: 2c609p
      ElIconRectElement(8, 8, 14, 14, 2, ry: 2), // key: 17jyea
      ElIconPathElement(
        'M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2',
      ), // key: zix9uf
    ],
  );

  /// `copy-minus.mjs`
  static const ElLucideGlyph copyMinus = ElLucideGlyph(
    'copy-minus',
    <ElIconElement>[
      ElIconLineElement(12, 15, 18, 15), // key: 1nscbv
      ElIconRectElement(8, 8, 14, 14, 2, ry: 2), // key: 17jyea
      ElIconPathElement(
        'M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2',
      ), // key: zix9uf
    ],
  );

  /// `copy-plus.mjs`
  static const ElLucideGlyph copyPlus = ElLucideGlyph(
    'copy-plus',
    <ElIconElement>[
      ElIconLineElement(15, 12, 15, 18), // key: 1p7wdc
      ElIconLineElement(12, 15, 18, 15), // key: 1nscbv
      ElIconRectElement(8, 8, 14, 14, 2, ry: 2), // key: 17jyea
      ElIconPathElement(
        'M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2',
      ), // key: zix9uf
    ],
  );

  /// `copy-slash.mjs`
  static const ElLucideGlyph copySlash = ElLucideGlyph(
    'copy-slash',
    <ElIconElement>[
      ElIconLineElement(12, 18, 18, 12), // key: ebkxgr
      ElIconRectElement(8, 8, 14, 14, 2, ry: 2), // key: 17jyea
      ElIconPathElement(
        'M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2',
      ), // key: zix9uf
    ],
  );

  /// `copy-x.mjs`
  static const ElLucideGlyph copyX = ElLucideGlyph('copy-x', <ElIconElement>[
    ElIconLineElement(12, 12, 18, 18), // key: 1rg63v
    ElIconLineElement(12, 18, 18, 12), // key: ebkxgr
    ElIconRectElement(8, 8, 14, 14, 2, ry: 2), // key: 17jyea
    ElIconPathElement(
      'M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2',
    ), // key: zix9uf
  ]);

  /// `copy.mjs`
  static const ElLucideGlyph copy = ElLucideGlyph('copy', <ElIconElement>[
    ElIconRectElement(8, 8, 14, 14, 2, ry: 2), // key: 17jyea
    ElIconPathElement(
      'M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2',
    ), // key: zix9uf
  ]);

  /// `copyleft.mjs`
  static const ElLucideGlyph copyleft = ElLucideGlyph(
    'copyleft',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('M9.17 14.83a4 4 0 1 0 0-5.66'), // key: 1sveal
    ],
  );

  /// `copyright.mjs`
  static const ElLucideGlyph copyright = ElLucideGlyph(
    'copyright',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('M14.83 14.83a4 4 0 1 1 0-5.66'), // key: 1i56pz
    ],
  );

  /// `corner-down-left.mjs`
  static const ElLucideGlyph cornerDownLeft = ElLucideGlyph(
    'corner-down-left',
    <ElIconElement>[
      ElIconPathElement('M20 4v7a4 4 0 0 1-4 4H4'), // key: 6o5b7l
      ElIconPathElement('m9 10-5 5 5 5'), // key: 1kshq7
    ],
  );

  /// `corner-down-right.mjs`
  static const ElLucideGlyph cornerDownRight = ElLucideGlyph(
    'corner-down-right',
    <ElIconElement>[
      ElIconPathElement('m15 10 5 5-5 5'), // key: qqa56n
      ElIconPathElement('M4 4v7a4 4 0 0 0 4 4h12'), // key: z08zvw
    ],
  );

  /// `corner-left-down.mjs`
  static const ElLucideGlyph cornerLeftDown = ElLucideGlyph(
    'corner-left-down',
    <ElIconElement>[
      ElIconPathElement('m14 15-5 5-5-5'), // key: 1eia93
      ElIconPathElement('M20 4h-7a4 4 0 0 0-4 4v12'), // key: nbpdq2
    ],
  );

  /// `corner-left-up.mjs`
  static const ElLucideGlyph cornerLeftUp = ElLucideGlyph(
    'corner-left-up',
    <ElIconElement>[
      ElIconPathElement('M14 9 9 4 4 9'), // key: 1af5af
      ElIconPathElement('M20 20h-7a4 4 0 0 1-4-4V4'), // key: 1blwi3
    ],
  );

  /// `corner-right-down.mjs`
  static const ElLucideGlyph cornerRightDown = ElLucideGlyph(
    'corner-right-down',
    <ElIconElement>[
      ElIconPathElement('m10 15 5 5 5-5'), // key: 1hpjnr
      ElIconPathElement('M4 4h7a4 4 0 0 1 4 4v12'), // key: wcbgct
    ],
  );

  /// `corner-right-up.mjs`
  static const ElLucideGlyph cornerRightUp = ElLucideGlyph(
    'corner-right-up',
    <ElIconElement>[
      ElIconPathElement('m10 9 5-5 5 5'), // key: 9ctzwi
      ElIconPathElement('M4 20h7a4 4 0 0 0 4-4V4'), // key: 1plgdj
    ],
  );

  /// `corner-up-left.mjs`
  static const ElLucideGlyph cornerUpLeft = ElLucideGlyph(
    'corner-up-left',
    <ElIconElement>[
      ElIconPathElement('M20 20v-7a4 4 0 0 0-4-4H4'), // key: 1nkjon
      ElIconPathElement('M9 14 4 9l5-5'), // key: 102s5s
    ],
  );

  /// `corner-up-right.mjs`
  static const ElLucideGlyph cornerUpRight = ElLucideGlyph(
    'corner-up-right',
    <ElIconElement>[
      ElIconPathElement('m15 14 5-5-5-5'), // key: 12vg1m
      ElIconPathElement('M4 20v-7a4 4 0 0 1 4-4h12'), // key: 1lu4f8
    ],
  );

  /// `cpu.mjs`
  static const ElLucideGlyph cpu = ElLucideGlyph('cpu', <ElIconElement>[
    ElIconPathElement('M12 20v2'), // key: 1lh1kg
    ElIconPathElement('M12 2v2'), // key: tus03m
    ElIconPathElement('M17 20v2'), // key: 1rnc9c
    ElIconPathElement('M17 2v2'), // key: 11trls
    ElIconPathElement('M2 12h2'), // key: 1t8f8n
    ElIconPathElement('M2 17h2'), // key: 7oei6x
    ElIconPathElement('M2 7h2'), // key: asdhe0
    ElIconPathElement('M20 12h2'), // key: 1q8mjw
    ElIconPathElement('M20 17h2'), // key: 1fpfkl
    ElIconPathElement('M20 7h2'), // key: 1o8tra
    ElIconPathElement('M7 20v2'), // key: 4gnj0m
    ElIconPathElement('M7 2v2'), // key: 1i4yhu
    ElIconRectElement(4, 4, 16, 16, 2), // key: 1vbyd7
    ElIconRectElement(8, 8, 8, 8, 1), // key: z9xiuo
  ]);

  /// `creative-commons.mjs`
  static const ElLucideGlyph creativeCommons = ElLucideGlyph(
    'creative-commons',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement(
        'M10 9.3a2.8 2.8 0 0 0-3.5 1 3.1 3.1 0 0 0 0 3.4 2.7 2.7 0 0 0 3.5 1',
      ), // key: 1ss3eq
      ElIconPathElement(
        'M17 9.3a2.8 2.8 0 0 0-3.5 1 3.1 3.1 0 0 0 0 3.4 2.7 2.7 0 0 0 3.5 1',
      ), // key: 1od56t
    ],
  );

  /// `credit-card.mjs`
  static const ElLucideGlyph creditCard = ElLucideGlyph(
    'credit-card',
    <ElIconElement>[
      ElIconRectElement(2, 5, 20, 14, 2), // key: ynyp8z
      ElIconLineElement(2, 10, 22, 10), // key: 1b3vmo
    ],
  );

  /// `croissant.mjs`
  static const ElLucideGlyph
  croissant = ElLucideGlyph('croissant', <ElIconElement>[
    ElIconPathElement(
      'M10.2 18H4.774a1.5 1.5 0 0 1-1.352-.97 11 11 0 0 1 .132-6.487',
    ), // key: 14kkz9
    ElIconPathElement(
      'M18 10.2V4.774a1.5 1.5 0 0 0-.97-1.352 11 11 0 0 0-6.486.132',
    ), // key: 1g7v07
    ElIconPathElement(
      'M18 5a4 3 0 0 1 4 3 2 2 0 0 1-2 2 10 10 0 0 0-5.139 1.42',
    ), // key: ratg6b
    ElIconPathElement(
      'M5 18a3 4 0 0 0 3 4 2 2 0 0 0 2-2 10 10 0 0 1 1.42-5.14',
    ), // key: 4454f0
    ElIconPathElement(
      'M8.709 2.554a10 10 0 0 0-6.155 6.155 1.5 1.5 0 0 0 .676 1.626l9.807 5.42a2 2 0 0 0 2.718-2.718l-5.42-9.807a1.5 1.5 0 0 0-1.626-.676',
    ), // key: qmemie
  ]);

  /// `crop.mjs`
  static const ElLucideGlyph crop = ElLucideGlyph('crop', <ElIconElement>[
    ElIconPathElement('M6 2v14a2 2 0 0 0 2 2h14'), // key: ron5a4
    ElIconPathElement('M18 22V8a2 2 0 0 0-2-2H2'), // key: 7s9ehn
  ]);

  /// `cross.mjs`
  static const ElLucideGlyph cross = ElLucideGlyph('cross', <ElIconElement>[
    ElIconPathElement(
      'M4 9a2 2 0 0 0-2 2v2a2 2 0 0 0 2 2h4a1 1 0 0 1 1 1v4a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2v-4a1 1 0 0 1 1-1h4a2 2 0 0 0 2-2v-2a2 2 0 0 0-2-2h-4a1 1 0 0 1-1-1V4a2 2 0 0 0-2-2h-2a2 2 0 0 0-2 2v4a1 1 0 0 1-1 1z',
    ), // key: 1xbrqy
  ]);

  /// `crosshair.mjs`
  static const ElLucideGlyph crosshair = ElLucideGlyph(
    'crosshair',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconLineElement(22, 12, 18, 12), // key: l9bcsi
      ElIconLineElement(6, 12, 2, 12), // key: 13hhkx
      ElIconLineElement(12, 6, 12, 2), // key: 10w3f3
      ElIconLineElement(12, 22, 12, 18), // key: 15g9kq
    ],
  );

  /// `crown.mjs`
  static const ElLucideGlyph crown = ElLucideGlyph('crown', <ElIconElement>[
    ElIconPathElement(
      'M11.562 3.266a.5.5 0 0 1 .876 0L15.39 8.87a1 1 0 0 0 1.516.294L21.183 5.5a.5.5 0 0 1 .798.519l-2.834 10.246a1 1 0 0 1-.956.734H5.81a1 1 0 0 1-.957-.734L2.02 6.02a.5.5 0 0 1 .798-.519l4.276 3.664a1 1 0 0 0 1.516-.294z',
    ), // key: 1vdc57
    ElIconPathElement('M5 21h14'), // key: 11awu3
  ]);

  /// `cuboid.mjs`
  static const ElLucideGlyph cuboid = ElLucideGlyph('cuboid', <ElIconElement>[
    ElIconPathElement('M10 22v-8'), // key: 1f8443
    ElIconPathElement('M2.336 8.89 10 14l11.715-7.029'), // key: 1qnufy
    ElIconPathElement(
      'M22 14a2 2 0 0 1-.971 1.715l-10 6a2 2 0 0 1-2.138-.05l-6-4A2 2 0 0 1 2 16v-6a2 2 0 0 1 .971-1.715l10-6a2 2 0 0 1 2.138.05l6 4A2 2 0 0 1 22 8z',
    ), // key: 670npk
  ]);

  /// `cup-soda.mjs`
  static const ElLucideGlyph cupSoda = ElLucideGlyph(
    'cup-soda',
    <ElIconElement>[
      ElIconPathElement(
        'm6 8 1.75 12.28a2 2 0 0 0 2 1.72h4.54a2 2 0 0 0 2-1.72L18 8',
      ), // key: 8166m8
      ElIconPathElement('M5 8h14'), // key: pcz4l3
      ElIconPathElement(
        'M7 15a6.47 6.47 0 0 1 5 0 6.47 6.47 0 0 0 5 0',
      ), // key: yjz344
      ElIconPathElement('m12 8 1-6h2'), // key: 3ybfa4
    ],
  );

  /// `currency.mjs`
  static const ElLucideGlyph currency = ElLucideGlyph(
    'currency',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 8), // key: 46899m
      ElIconLineElement(3, 3, 6, 6), // key: 1jkytn
      ElIconLineElement(21, 3, 18, 6), // key: 14zfjt
      ElIconLineElement(3, 21, 6, 18), // key: iusuec
      ElIconLineElement(21, 21, 18, 18), // key: yj2dd7
    ],
  );

  /// `cylinder.mjs`
  static const ElLucideGlyph cylinder = ElLucideGlyph(
    'cylinder',
    <ElIconElement>[
      ElIconEllipseElement(12, 5, 9, 3), // key: msslwz
      ElIconPathElement('M3 5v14a9 3 0 0 0 18 0V5'), // key: aqi0yr
    ],
  );

  /// `dam.mjs`
  static const ElLucideGlyph dam = ElLucideGlyph('dam', <ElIconElement>[
    ElIconPathElement(
      'M11 11.31c1.17.56 1.54 1.69 3.5 1.69 2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1',
    ), // key: 157kva
    ElIconPathElement(
      'M11.75 18c.35.5 1.45 1 2.75 1 2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1',
    ), // key: d7q6m6
    ElIconPathElement('M2 10h4'), // key: l0bgd4
    ElIconPathElement('M2 14h4'), // key: 1gsvsf
    ElIconPathElement('M2 18h4'), // key: 1bu2t1
    ElIconPathElement('M2 6h4'), // key: aawbzj
    ElIconPathElement(
      'M7 3a1 1 0 0 0-1 1v16a1 1 0 0 0 1 1h4a1 1 0 0 0 1-1L10 4a1 1 0 0 0-1-1z',
    ), // key: pr6s65
  ]);

  /// `database-arrow-down.mjs`
  static const ElLucideGlyph databaseArrowDown = ElLucideGlyph(
    'database-arrow-down',
    <ElIconElement>[
      ElIconPathElement('m16 19 3 3 3-3'), // key: 1ibux0
      ElIconPathElement('M19 16v6'), // key: tddt3s
      ElIconPathElement('M21 12.536V5'), // key: zeza6i
      ElIconPathElement('M3 12A9 3 0 0 0 15.182 14.806'), // key: 11e5wb
      ElIconPathElement('M3 5V19A9 3 0 0 0 13.318 21.968'), // key: 1lyu4j
      ElIconEllipseElement(12, 5, 9, 3), // key: msslwz
    ],
  );

  /// `database-arrow-up.mjs`
  static const ElLucideGlyph databaseArrowUp = ElLucideGlyph(
    'database-arrow-up',
    <ElIconElement>[
      ElIconPathElement('M19 22v-6'), // key: qhmiwi
      ElIconPathElement('M21 12.536V5'), // key: zeza6i
      ElIconPathElement('m22 19-3-3-3 3'), // key: rn6bg2
      ElIconPathElement('M3 12A9 3 0 0 0 14.457 14.886'), // key: 1941vg
      ElIconPathElement('M3 5V19A9 3 0 0 0 13.318 21.968'), // key: 1lyu4j
      ElIconEllipseElement(12, 5, 9, 3), // key: msslwz
    ],
  );

  /// `database-backup.mjs`
  static const ElLucideGlyph
  databaseBackup = ElLucideGlyph('database-backup', <ElIconElement>[
    ElIconEllipseElement(12, 5, 9, 3), // key: msslwz
    ElIconPathElement('M3 12a9 3 0 0 0 5 2.69'), // key: 1ui2ym
    ElIconPathElement('M21 9.3V5'), // key: 6k6cib
    ElIconPathElement('M3 5v14a9 3 0 0 0 6.47 2.88'), // key: i62tjy
    ElIconPathElement('M12 12v4h4'), // key: 1bxaet
    ElIconPathElement(
      'M13 20a5 5 0 0 0 9-3 4.5 4.5 0 0 0-4.5-4.5c-1.33 0-2.54.54-3.41 1.41L12 16',
    ), // key: 1f4ei9
  ]);

  /// `database-check.mjs`
  static const ElLucideGlyph databaseCheck = ElLucideGlyph(
    'database-check',
    <ElIconElement>[
      ElIconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
      ElIconPathElement('M21 13.127V5'), // key: 59o5vz
      ElIconPathElement('M3 12A9 3 0 0 0 21 12'), // key: mv7ke4
      ElIconPathElement('M3 5V19A9 3 0 0 0 13.318 21.968'), // key: 1lyu4j
      ElIconEllipseElement(12, 5, 9, 3), // key: msslwz
    ],
  );

  /// `database-minus.mjs`
  static const ElLucideGlyph databaseMinus = ElLucideGlyph(
    'database-minus',
    <ElIconElement>[
      ElIconPathElement('M21 15V5'), // key: 1lbg5w
      ElIconPathElement('M22 19h-6'), // key: vcuq98
      ElIconPathElement('M3 12A9 3 0 0 0 21 12'), // key: mv7ke4
      ElIconPathElement('M3 5V19A9 3 0 0 0 13.318 21.968'), // key: 1lyu4j
      ElIconEllipseElement(12, 5, 9, 3), // key: msslwz
    ],
  );

  /// `database-plus.mjs`
  static const ElLucideGlyph databasePlus = ElLucideGlyph(
    'database-plus',
    <ElIconElement>[
      ElIconPathElement('M19 16v6'), // key: tddt3s
      ElIconPathElement('M21 12.536V5'), // key: zeza6i
      ElIconPathElement('M22 19h-6'), // key: vcuq98
      ElIconPathElement('M3 12A9 3 0 0 0 15.1824 14.8061'), // key: ukc3b1
      ElIconPathElement('M3 5V19A9 3 0 0 0 13.318 21.968'), // key: 1lyu4j
      ElIconEllipseElement(12, 5, 9, 3), // key: msslwz
    ],
  );

  /// `database-search.mjs`
  static const ElLucideGlyph databaseSearch = ElLucideGlyph(
    'database-search',
    <ElIconElement>[
      ElIconPathElement('M21 11.693V5'), // key: 175m1t
      ElIconPathElement('m22 22-1.875-1.875'), // key: 13zax7
      ElIconPathElement('M3 12a9 3 0 0 0 8.697 2.998'), // key: 151u9p
      ElIconPathElement('M3 5v14a9 3 0 0 0 9.28 2.999'), // key: q2rs2p
      ElIconCircleElement(18, 18, 3), // key: 1xkwt0
      ElIconEllipseElement(12, 5, 9, 3), // key: msslwz
    ],
  );

  /// `database-x.mjs`
  static const ElLucideGlyph databaseX = ElLucideGlyph(
    'database-x',
    <ElIconElement>[
      ElIconPathElement('m17 17 5 5'), // key: p7ous7
      ElIconPathElement('M19.323 13.744A9 3 0 0 0 21 12'), // key: hmry77
      ElIconPathElement('M21 13.127V5'), // key: 59o5vz
      ElIconPathElement('m22 17-5 5'), // key: gqnmv0
      ElIconPathElement('M3 12A9 3 0 0 0 13.563 14.954'), // key: 1rmyhq
      ElIconPathElement('M3 5V19A9 3 0 0 0 13 21.981'), // key: 159k2m
      ElIconEllipseElement(12, 5, 9, 3), // key: msslwz
    ],
  );

  /// `database-zap.mjs`
  static const ElLucideGlyph databaseZap = ElLucideGlyph(
    'database-zap',
    <ElIconElement>[
      ElIconEllipseElement(12, 5, 9, 3), // key: msslwz
      ElIconPathElement('M3 5V19A9 3 0 0 0 15 21.84'), // key: 14ibmq
      ElIconPathElement('M21 5V8'), // key: 1marbg
      ElIconPathElement('M21 12L18 17H22L19 22'), // key: zafso
      ElIconPathElement('M3 12A9 3 0 0 0 14.59 14.87'), // key: 1y4wr8
    ],
  );

  /// `database.mjs`
  static const ElLucideGlyph database = ElLucideGlyph(
    'database',
    <ElIconElement>[
      ElIconEllipseElement(12, 5, 9, 3), // key: msslwz
      ElIconPathElement('M3 5V19A9 3 0 0 0 21 19V5'), // key: 1wlel7
      ElIconPathElement('M3 12A9 3 0 0 0 21 12'), // key: mv7ke4
    ],
  );

  /// `decimals-arrow-left.mjs`
  static const ElLucideGlyph decimalsArrowLeft = ElLucideGlyph(
    'decimals-arrow-left',
    <ElIconElement>[
      ElIconPathElement('m13 21-3-3 3-3'), // key: s3o1nf
      ElIconPathElement('M20 18H10'), // key: 14r3mt
      ElIconPathElement('M3 11h.01'), // key: 1eifu7
      ElIconRectElement(6, 3, 5, 8, 2.5), // key: v9paqo
    ],
  );

  /// `decimals-arrow-right.mjs`
  static const ElLucideGlyph decimalsArrowRight = ElLucideGlyph(
    'decimals-arrow-right',
    <ElIconElement>[
      ElIconPathElement('M10 18h10'), // key: 1y5s8o
      ElIconPathElement('m17 21 3-3-3-3'), // key: 1ammt0
      ElIconPathElement('M3 11h.01'), // key: 1eifu7
      ElIconRectElement(15, 3, 5, 8, 2.5), // key: 76md6a
      ElIconRectElement(6, 3, 5, 8, 2.5), // key: v9paqo
    ],
  );

  /// `delete.mjs`
  static const ElLucideGlyph delete = ElLucideGlyph('delete', <ElIconElement>[
    ElIconPathElement(
      'M10 5a2 2 0 0 0-1.344.519l-6.328 5.74a1 1 0 0 0 0 1.481l6.328 5.741A2 2 0 0 0 10 19h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2z',
    ), // key: 1yo7s0
    ElIconPathElement('m12 9 6 6'), // key: anjzzh
    ElIconPathElement('m18 9-6 6'), // key: 1fp51s
  ]);

  /// `dessert.mjs`
  static const ElLucideGlyph dessert = ElLucideGlyph('dessert', <ElIconElement>[
    ElIconPathElement(
      'M10.162 3.167A10 10 0 0 0 2 13a2 2 0 0 0 4 0v-1a2 2 0 0 1 4 0v4a2 2 0 0 0 4 0v-4a2 2 0 0 1 4 0v1a2 2 0 0 0 4-.006 10 10 0 0 0-8.161-9.826',
    ), // key: xi88qy
    ElIconPathElement('M20.804 14.869a9 9 0 0 1-17.608 0'), // key: 1r28rg
    ElIconCircleElement(12, 4, 2), // key: muu5ef
  ]);

  /// `diameter.mjs`
  static const ElLucideGlyph diameter = ElLucideGlyph(
    'diameter',
    <ElIconElement>[
      ElIconCircleElement(19, 19, 2), // key: 17f5cg
      ElIconCircleElement(5, 5, 2), // key: 1gwv83
      ElIconPathElement('M6.48 3.66a10 10 0 0 1 13.86 13.86'), // key: xr8kdq
      ElIconPathElement('m6.41 6.41 11.18 11.18'), // key: uhpjw7
      ElIconPathElement('M3.66 6.48a10 10 0 0 0 13.86 13.86'), // key: cldpwv
    ],
  );

  /// `diamond-minus.mjs`
  static const ElLucideGlyph
  diamondMinus = ElLucideGlyph('diamond-minus', <ElIconElement>[
    ElIconPathElement(
      'M2.7 10.3a2.41 2.41 0 0 0 0 3.41l7.59 7.59a2.41 2.41 0 0 0 3.41 0l7.59-7.59a2.41 2.41 0 0 0 0-3.41L13.7 2.71a2.41 2.41 0 0 0-3.41 0z',
    ), // key: 1ey20j
    ElIconPathElement('M8 12h8'), // key: 1wcyev
  ]);

  /// `diamond-percent.mjs`
  static const ElLucideGlyph
  diamondPercent = ElLucideGlyph('diamond-percent', <ElIconElement>[
    ElIconPathElement(
      'M2.7 10.3a2.41 2.41 0 0 0 0 3.41l7.59 7.59a2.41 2.41 0 0 0 3.41 0l7.59-7.59a2.41 2.41 0 0 0 0-3.41L13.7 2.71a2.41 2.41 0 0 0-3.41 0Z',
    ), // key: 1tpxz2
    ElIconPathElement('M9.2 9.2h.01'), // key: 1b7bvt
    ElIconPathElement('m14.5 9.5-5 5'), // key: 17q4r4
    ElIconPathElement('M14.7 14.8h.01'), // key: 17nsh4
  ]);

  /// `diamond-plus.mjs`
  static const ElLucideGlyph
  diamondPlus = ElLucideGlyph('diamond-plus', <ElIconElement>[
    ElIconPathElement('M12 8v8'), // key: napkw2
    ElIconPathElement(
      'M2.7 10.3a2.41 2.41 0 0 0 0 3.41l7.59 7.59a2.41 2.41 0 0 0 3.41 0l7.59-7.59a2.41 2.41 0 0 0 0-3.41L13.7 2.71a2.41 2.41 0 0 0-3.41 0z',
    ), // key: 1ey20j
    ElIconPathElement('M8 12h8'), // key: 1wcyev
  ]);

  /// `diamond.mjs`
  static const ElLucideGlyph diamond = ElLucideGlyph('diamond', <ElIconElement>[
    ElIconPathElement(
      'M2.7 10.3a2.41 2.41 0 0 0 0 3.41l7.59 7.59a2.41 2.41 0 0 0 3.41 0l7.59-7.59a2.41 2.41 0 0 0 0-3.41l-7.59-7.59a2.41 2.41 0 0 0-3.41 0Z',
    ), // key: 1f1r0c
  ]);

  /// `dice-1.mjs`
  static const ElLucideGlyph dice1 = ElLucideGlyph('dice-1', <ElIconElement>[
    ElIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    ElIconPathElement('M12 12h.01'), // key: 1mp3jc
  ]);

  /// `dice-2.mjs`
  static const ElLucideGlyph dice2 = ElLucideGlyph('dice-2', <ElIconElement>[
    ElIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    ElIconPathElement('M15 9h.01'), // key: x1ddxp
    ElIconPathElement('M9 15h.01'), // key: fzyn71
  ]);

  /// `dice-3.mjs`
  static const ElLucideGlyph dice3 = ElLucideGlyph('dice-3', <ElIconElement>[
    ElIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    ElIconPathElement('M16 8h.01'), // key: cr5u4v
    ElIconPathElement('M12 12h.01'), // key: 1mp3jc
    ElIconPathElement('M8 16h.01'), // key: 18s6g9
  ]);

  /// `dice-4.mjs`
  static const ElLucideGlyph dice4 = ElLucideGlyph('dice-4', <ElIconElement>[
    ElIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    ElIconPathElement('M16 8h.01'), // key: cr5u4v
    ElIconPathElement('M8 8h.01'), // key: 1e4136
    ElIconPathElement('M8 16h.01'), // key: 18s6g9
    ElIconPathElement('M16 16h.01'), // key: 1f9h7w
  ]);

  /// `dice-5.mjs`
  static const ElLucideGlyph dice5 = ElLucideGlyph('dice-5', <ElIconElement>[
    ElIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    ElIconPathElement('M16 8h.01'), // key: cr5u4v
    ElIconPathElement('M8 8h.01'), // key: 1e4136
    ElIconPathElement('M8 16h.01'), // key: 18s6g9
    ElIconPathElement('M16 16h.01'), // key: 1f9h7w
    ElIconPathElement('M12 12h.01'), // key: 1mp3jc
  ]);

  /// `dice-6.mjs`
  static const ElLucideGlyph dice6 = ElLucideGlyph('dice-6', <ElIconElement>[
    ElIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    ElIconPathElement('M16 8h.01'), // key: cr5u4v
    ElIconPathElement('M16 12h.01'), // key: 1l6xoz
    ElIconPathElement('M16 16h.01'), // key: 1f9h7w
    ElIconPathElement('M8 8h.01'), // key: 1e4136
    ElIconPathElement('M8 12h.01'), // key: czm47f
    ElIconPathElement('M8 16h.01'), // key: 18s6g9
  ]);

  /// `dices.mjs`
  static const ElLucideGlyph dices = ElLucideGlyph('dices', <ElIconElement>[
    ElIconRectElement(2, 10, 12, 12, 2, ry: 2), // key: 6agr2n
    ElIconPathElement(
      'm17.92 14 3.5-3.5a2.24 2.24 0 0 0 0-3l-5-4.92a2.24 2.24 0 0 0-3 0L10 6',
    ), // key: 1o487t
    ElIconPathElement('M6 18h.01'), // key: uhywen
    ElIconPathElement('M10 14h.01'), // key: ssrbsk
    ElIconPathElement('M15 6h.01'), // key: cblpky
    ElIconPathElement('M18 9h.01'), // key: 2061c0
  ]);

  /// `diff.mjs`
  static const ElLucideGlyph diff = ElLucideGlyph('diff', <ElIconElement>[
    ElIconPathElement('M12 3v14'), // key: 7cf3v8
    ElIconPathElement('M5 10h14'), // key: elsbfy
    ElIconPathElement('M5 21h14'), // key: 11awu3
  ]);

  /// `disc-2.mjs`
  static const ElLucideGlyph disc2 = ElLucideGlyph('disc-2', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconCircleElement(12, 12, 4), // key: 4exip2
    ElIconPathElement('M12 12h.01'), // key: 1mp3jc
  ]);

  /// `disc-3.mjs`
  static const ElLucideGlyph disc3 = ElLucideGlyph('disc-3', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement('M6 12c0-1.7.7-3.2 1.8-4.2'), // key: oqkarx
    ElIconCircleElement(12, 12, 2), // key: 1c9p78
    ElIconPathElement('M18 12c0 1.7-.7 3.2-1.8 4.2'), // key: 1eah9h
  ]);

  /// `disc-album.mjs`
  static const ElLucideGlyph discAlbum = ElLucideGlyph(
    'disc-album',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconCircleElement(12, 12, 5), // key: nd82uf
      ElIconPathElement('M12 12h.01'), // key: 1mp3jc
    ],
  );

  /// `disc.mjs`
  static const ElLucideGlyph disc = ElLucideGlyph('disc', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `divide.mjs`
  static const ElLucideGlyph divide = ElLucideGlyph('divide', <ElIconElement>[
    ElIconCircleElement(12, 6, 1), // key: 1bh7o1
    ElIconLineElement(5, 12, 19, 12), // key: 13b5wn
    ElIconCircleElement(12, 18, 1), // key: lqb9t5
  ]);

  /// `dna-off.mjs`
  static const ElLucideGlyph dnaOff = ElLucideGlyph('dna-off', <ElIconElement>[
    ElIconPathElement('M15 2c-1.35 1.5-2.092 3-2.5 4.5L14 8'), // key: 1bivrr
    ElIconPathElement('m17 6-2.891-2.891'), // key: xu6p2f
    ElIconPathElement('M2 15c3.333-3 6.667-3 10-3'), // key: nxix30
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement('m20 9 .891.891'), // key: 3xwk7g
    ElIconPathElement('M22 9c-1.5 1.35-3 2.092-4.5 2.5l-1-1'), // key: 18cutr
    ElIconPathElement('M3.109 14.109 4 15'), // key: q76aoh
    ElIconPathElement('m6.5 12.5 1 1'), // key: cs35ky
    ElIconPathElement('m7 18 2.891 2.891'), // key: 1sisit
    ElIconPathElement('M9 22c1.35-1.5 2.092-3 2.5-4.5L10 16'), // key: rlvei3
  ]);

  /// `dna.mjs`
  static const ElLucideGlyph dna = ElLucideGlyph('dna', <ElIconElement>[
    ElIconPathElement('m10 16 1.5 1.5'), // key: 11lckj
    ElIconPathElement('m14 8-1.5-1.5'), // key: 1ohn8i
    ElIconPathElement(
      'M15 2c-1.798 1.998-2.518 3.995-2.807 5.993',
    ), // key: 80uv8i
    ElIconPathElement('m16.5 10.5 1 1'), // key: 696xn5
    ElIconPathElement('m17 6-2.891-2.891'), // key: xu6p2f
    ElIconPathElement('M2 15c6.667-6 13.333 0 20-6'), // key: 1pyr53
    ElIconPathElement('m20 9 .891.891'), // key: 3xwk7g
    ElIconPathElement('M3.109 14.109 4 15'), // key: q76aoh
    ElIconPathElement('m6.5 12.5 1 1'), // key: cs35ky
    ElIconPathElement('m7 18 2.891 2.891'), // key: 1sisit
    ElIconPathElement(
      'M9 22c1.798-1.998 2.518-3.995 2.807-5.993',
    ), // key: q3hbxp
  ]);

  /// `dock.mjs`
  static const ElLucideGlyph dock = ElLucideGlyph('dock', <ElIconElement>[
    ElIconPathElement('M2 8h20'), // key: d11cs7
    ElIconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
    ElIconPathElement('M6 16h12'), // key: u522kt
  ]);

  /// `dog.mjs`
  static const ElLucideGlyph dog = ElLucideGlyph('dog', <ElIconElement>[
    ElIconPathElement('M11.25 16.25h1.5L12 17z'), // key: w7jh35
    ElIconPathElement('M16 14v.5'), // key: 1lajdz
    ElIconPathElement(
      'M4.42 11.247A13.152 13.152 0 0 0 4 14.556C4 18.728 7.582 21 12 21s8-2.272 8-6.444a11.702 11.702 0 0 0-.493-3.309',
    ), // key: u7s9ue
    ElIconPathElement('M8 14v.5'), // key: 1nzgdb
    ElIconPathElement(
      'M8.5 8.5c-.384 1.05-1.083 2.028-2.344 2.5-1.931.722-3.576-.297-3.656-1-.113-.994 1.177-6.53 4-7 1.923-.321 3.651.845 3.651 2.235A7.497 7.497 0 0 1 14 5.277c0-1.39 1.844-2.598 3.767-2.277 2.823.47 4.113 6.006 4 7-.08.703-1.725 1.722-3.656 1-1.261-.472-1.855-1.45-2.239-2.5',
    ), // key: v8hric
  ]);

  /// `dollar-sign.mjs`
  static const ElLucideGlyph dollarSign = ElLucideGlyph(
    'dollar-sign',
    <ElIconElement>[
      ElIconLineElement(12, 2, 12, 22), // key: 7eqyqh
      ElIconPathElement(
        'M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6',
      ), // key: 1b0p4s
    ],
  );

  /// `donut.mjs`
  static const ElLucideGlyph donut = ElLucideGlyph('donut', <ElIconElement>[
    ElIconPathElement(
      'M20.5 10a2.5 2.5 0 0 1-2.4-3H18a2.95 2.95 0 0 1-2.6-4.4 10 10 0 1 0 6.3 7.1c-.3.2-.8.3-1.2.3',
    ), // key: 19sr3x
    ElIconCircleElement(12, 12, 3), // key: 1v7zrd
  ]);

  /// `door-closed-locked.mjs`
  static const ElLucideGlyph doorClosedLocked = ElLucideGlyph(
    'door-closed-locked',
    <ElIconElement>[
      ElIconPathElement('M10 12h.01'), // key: 1kxr2c
      ElIconPathElement(
        'M18 9V6a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v14',
      ), // key: 1bnhmg
      ElIconPathElement('M2 20h8'), // key: 10ntw1
      ElIconPathElement('M20 17v-2a2 2 0 1 0-4 0v2'), // key: pwaxnr
      ElIconRectElement(14, 17, 8, 5, 1), // key: 15pjcy
    ],
  );

  /// `door-closed.mjs`
  static const ElLucideGlyph doorClosed = ElLucideGlyph(
    'door-closed',
    <ElIconElement>[
      ElIconPathElement('M10 12h.01'), // key: 1kxr2c
      ElIconPathElement(
        'M18 20V6a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v14',
      ), // key: 36qu9e
      ElIconPathElement('M2 20h20'), // key: owomy5
    ],
  );

  /// `door-open.mjs`
  static const ElLucideGlyph
  doorOpen = ElLucideGlyph('door-open', <ElIconElement>[
    ElIconPathElement('M11 20H2'), // key: nlcfvz
    ElIconPathElement(
      'M11 4.562v16.157a1 1 0 0 0 1.242.97L19 20V5.562a2 2 0 0 0-1.515-1.94l-4-1A2 2 0 0 0 11 4.561z',
    ), // key: au4z13
    ElIconPathElement('M11 4H8a2 2 0 0 0-2 2v14'), // key: 74r1mk
    ElIconPathElement('M14 12h.01'), // key: 1jfl7z
    ElIconPathElement('M22 20h-3'), // key: vhrsz
  ]);

  /// `dot.mjs`
  static const ElLucideGlyph dot = ElLucideGlyph('dot', <ElIconElement>[
    ElIconCircleElement(12, 12, 1), // key: 41hilf
  ]);

  /// `download.mjs`
  static const ElLucideGlyph download = ElLucideGlyph(
    'download',
    <ElIconElement>[
      ElIconPathElement('M12 15V3'), // key: m9g1x1
      ElIconPathElement(
        'M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4',
      ), // key: ih7n3h
      ElIconPathElement('m7 10 5 5 5-5'), // key: brsn70
    ],
  );

  /// `drafting-compass.mjs`
  static const ElLucideGlyph draftingCompass = ElLucideGlyph(
    'drafting-compass',
    <ElIconElement>[
      ElIconPathElement('m12.99 6.74 1.93 3.44'), // key: iwagvd
      ElIconPathElement('M19.136 12a10 10 0 0 1-14.271 0'), // key: ppmlo4
      ElIconPathElement('m21 21-2.16-3.84'), // key: vylbct
      ElIconPathElement('m3 21 8.02-14.26'), // key: 1ssaw4
      ElIconCircleElement(12, 5, 2), // key: f1ur92
    ],
  );

  /// `drama.mjs`
  static const ElLucideGlyph drama = ElLucideGlyph('drama', <ElIconElement>[
    ElIconPathElement('M10 11h.01'), // key: d2at3l
    ElIconPathElement('M14 6h.01'), // key: k028ub
    ElIconPathElement('M18 6h.01'), // key: 1v4wsw
    ElIconPathElement('M6.5 13.1h.01'), // key: 1748ia
    ElIconPathElement(
      'M22 5c0 9-4 12-6 12s-6-3-6-12c0-2 2-3 6-3s6 1 6 3',
    ), // key: 172yzv
    ElIconPathElement('M17.4 9.9c-.8.8-2 .8-2.8 0'), // key: 1obv0w
    ElIconPathElement(
      'M10.1 7.1C9 7.2 7.7 7.7 6 8.6c-3.5 2-4.7 3.9-3.7 5.6 4.5 7.8 9.5 8.4 11.2 7.4.9-.5 1.9-2.1 1.9-4.7',
    ), // key: rqjl8i
    ElIconPathElement('M9.1 16.5c.3-1.1 1.4-1.7 2.4-1.4'), // key: 1mr6wy
  ]);

  /// `drill.mjs`
  static const ElLucideGlyph drill = ElLucideGlyph('drill', <ElIconElement>[
    ElIconPathElement(
      'M10 18a1 1 0 0 1 1 1v2a1 1 0 0 1-1 1H5a3 3 0 0 1-3-3 1 1 0 0 1 1-1z',
    ), // key: ioqxb1
    ElIconPathElement(
      'M13 10H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a1 1 0 0 1 1 1v6a1 1 0 0 1-1 1l-.81 3.242a1 1 0 0 1-.97.758H8',
    ), // key: 1rs59n
    ElIconPathElement(
      'M14 4h3a1 1 0 0 1 1 1v2a1 1 0 0 1-1 1h-3',
    ), // key: 105ega
    ElIconPathElement('M18 6h4'), // key: 66u95g
    ElIconPathElement('m5 10-2 8'), // key: xt2lic
    ElIconPathElement('m7 18 2-8'), // key: 1bzku2
  ]);

  /// `drone.mjs`
  static const ElLucideGlyph drone = ElLucideGlyph('drone', <ElIconElement>[
    ElIconPathElement('M10 10 7 7'), // key: zp14k7
    ElIconPathElement('m10 14-3 3'), // key: 1jrpxk
    ElIconPathElement('m14 10 3-3'), // key: 7tigam
    ElIconPathElement('m14 14 3 3'), // key: vm23p3
    ElIconPathElement('M14.205 4.139a4 4 0 1 1 5.439 5.863'), // key: 1tm5p2
    ElIconPathElement('M19.637 14a4 4 0 1 1-5.432 5.868'), // key: 16egi2
    ElIconPathElement('M4.367 10a4 4 0 1 1 5.438-5.862'), // key: 1wta6a
    ElIconPathElement('M9.795 19.862a4 4 0 1 1-5.429-5.873'), // key: q39hpv
    ElIconRectElement(10, 8, 4, 8, 1), // key: phrjt1
  ]);

  /// `droplet-off.mjs`
  static const ElLucideGlyph
  dropletOff = ElLucideGlyph('droplet-off', <ElIconElement>[
    ElIconPathElement(
      'M18.715 13.186C18.29 11.858 17.384 10.607 16 9.5c-2-1.6-3.5-4-4-6.5a10.7 10.7 0 0 1-.884 2.586',
    ), // key: 8suz2t
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement(
      'M8.795 8.797A11 11 0 0 1 8 9.5C6 11.1 5 13 5 15a7 7 0 0 0 13.222 3.208',
    ), // key: 19dw9m
  ]);

  /// `droplet.mjs`
  static const ElLucideGlyph droplet = ElLucideGlyph('droplet', <ElIconElement>[
    ElIconPathElement(
      'M12 22a7 7 0 0 0 7-7c0-2-1-3.9-3-5.5s-3.5-4-4-6.5c-.5 2.5-2 4.9-4 6.5C6 11.1 5 13 5 15a7 7 0 0 0 7 7z',
    ), // key: c7niix
  ]);

  /// `droplets.mjs`
  static const ElLucideGlyph
  droplets = ElLucideGlyph('droplets', <ElIconElement>[
    ElIconPathElement(
      'M7 16.3c2.2 0 4-1.83 4-4.05 0-1.16-.57-2.26-1.71-3.19S7.29 6.75 7 5.3c-.29 1.45-1.14 2.84-2.29 3.76S3 11.1 3 12.25c0 2.22 1.8 4.05 4 4.05z',
    ), // key: 1ptgy4
    ElIconPathElement(
      'M12.56 6.6A10.97 10.97 0 0 0 14 3.02c.5 2.5 2 4.9 4 6.5s3 3.5 3 5.5a6.98 6.98 0 0 1-11.91 4.97',
    ), // key: 1sl1rz
  ]);

  /// `drum.mjs`
  static const ElLucideGlyph drum = ElLucideGlyph('drum', <ElIconElement>[
    ElIconPathElement('m2 2 8 8'), // key: 1v6059
    ElIconPathElement('m22 2-8 8'), // key: 173r8a
    ElIconEllipseElement(12, 9, 10, 5), // key: liohsx
    ElIconPathElement('M7 13.4v7.9'), // key: 1yi6u9
    ElIconPathElement('M12 14v8'), // key: 1tn2tj
    ElIconPathElement('M17 13.4v7.9'), // key: eqz2v3
    ElIconPathElement('M2 9v8a10 5 0 0 0 20 0V9'), // key: 1750ul
  ]);

  /// `drumstick.mjs`
  static const ElLucideGlyph
  drumstick = ElLucideGlyph('drumstick', <ElIconElement>[
    ElIconPathElement(
      'M15.4 15.63a7.875 6 135 1 1 6.23-6.23 4.5 3.43 135 0 0-6.23 6.23',
    ), // key: 1dtqwm
    ElIconPathElement(
      'm8.29 12.71-2.6 2.6a2.5 2.5 0 1 0-1.65 4.65A2.5 2.5 0 1 0 8.7 18.3l2.59-2.59',
    ), // key: 1oq1fw
  ]);

  /// `dumbbell.mjs`
  static const ElLucideGlyph
  dumbbell = ElLucideGlyph('dumbbell', <ElIconElement>[
    ElIconPathElement(
      'M17.596 12.768a2 2 0 1 0 2.829-2.829l-1.768-1.767a2 2 0 0 0 2.828-2.829l-2.828-2.828a2 2 0 0 0-2.829 2.828l-1.767-1.768a2 2 0 1 0-2.829 2.829z',
    ), // key: 9m4mmf
    ElIconPathElement('m2.5 21.5 1.4-1.4'), // key: 17g3f0
    ElIconPathElement('m20.1 3.9 1.4-1.4'), // key: 1qn309
    ElIconPathElement(
      'M5.343 21.485a2 2 0 1 0 2.829-2.828l1.767 1.768a2 2 0 1 0 2.829-2.829l-6.364-6.364a2 2 0 1 0-2.829 2.829l1.768 1.767a2 2 0 0 0-2.828 2.829z',
    ), // key: 1t2c92
    ElIconPathElement('m9.6 14.4 4.8-4.8'), // key: 6umqxw
  ]);

  /// `ear-off.mjs`
  static const ElLucideGlyph earOff = ElLucideGlyph('ear-off', <ElIconElement>[
    ElIconPathElement(
      'M6 18.5a3.5 3.5 0 1 0 7 0c0-1.57.92-2.52 2.04-3.46',
    ), // key: 1qngmn
    ElIconPathElement('M6 8.5c0-.75.13-1.47.36-2.14'), // key: b06bma
    ElIconPathElement(
      'M8.8 3.15A6.5 6.5 0 0 1 19 8.5c0 1.63-.44 2.81-1.09 3.76',
    ), // key: g10hsz
    ElIconPathElement(
      'M12.5 6A2.5 2.5 0 0 1 15 8.5M10 13a2 2 0 0 0 1.82-1.18',
    ), // key: ygzou7
    ElIconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `ear.mjs`
  static const ElLucideGlyph ear = ElLucideGlyph('ear', <ElIconElement>[
    ElIconPathElement(
      'M6 8.5a6.5 6.5 0 1 1 13 0c0 6-6 6-6 10a3.5 3.5 0 1 1-7 0',
    ), // key: 1dfaln
    ElIconPathElement(
      'M15 8.5a2.5 2.5 0 0 0-5 0v1a2 2 0 1 1 0 4',
    ), // key: 1qnva7
  ]);

  /// `earth-lock.mjs`
  static const ElLucideGlyph earthLock = ElLucideGlyph(
    'earth-lock',
    <ElIconElement>[
      ElIconPathElement('M7 3.34V5a3 3 0 0 0 3 3'), // key: w732o8
      ElIconPathElement(
        'M11 21.95V18a2 2 0 0 0-2-2 2 2 0 0 1-2-2v-1a2 2 0 0 0-2-2H2.05',
      ), // key: f02343
      ElIconPathElement('M21.54 15H17a2 2 0 0 0-2 2v4.54'), // key: 1djwo0
      ElIconPathElement('M12 2a10 10 0 1 0 9.54 13'), // key: zjsr6q
      ElIconPathElement('M20 6V4a2 2 0 1 0-4 0v2'), // key: 1of5e8
      ElIconRectElement(14, 6, 8, 5, 1), // key: 1fmf51
    ],
  );

  /// `earth.mjs`
  static const ElLucideGlyph earth = ElLucideGlyph('earth', <ElIconElement>[
    ElIconPathElement('M21.54 15H17a2 2 0 0 0-2 2v4.54'), // key: 1djwo0
    ElIconPathElement(
      'M7 3.34V5a3 3 0 0 0 3 3a2 2 0 0 1 2 2c0 1.1.9 2 2 2a2 2 0 0 0 2-2c0-1.1.9-2 2-2h3.17',
    ), // key: 1tzkfa
    ElIconPathElement(
      'M11 21.95V18a2 2 0 0 0-2-2a2 2 0 0 1-2-2v-1a2 2 0 0 0-2-2H2.05',
    ), // key: 14pb5j
    ElIconCircleElement(12, 12, 10), // key: 1mglay
  ]);

  /// `eclipse.mjs`
  static const ElLucideGlyph eclipse = ElLucideGlyph('eclipse', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement('M12 2a7 7 0 1 0 10 10'), // key: 1yuj32
  ]);

  /// `egg-fried.mjs`
  static const ElLucideGlyph
  eggFried = ElLucideGlyph('egg-fried', <ElIconElement>[
    ElIconCircleElement(11.5, 12.5, 3.5), // key: 1cl1mi
    ElIconPathElement(
      'M3 8c0-3.5 2.5-6 6.5-6 5 0 4.83 3 7.5 5s5 2 5 6c0 4.5-2.5 6.5-7 6.5-2.5 0-2.5 2.5-6 2.5s-7-2-7-5.5c0-3 1.5-3 1.5-5C3.5 10 3 9 3 8Z',
    ), // key: 165ef9
  ]);

  /// `egg-off.mjs`
  static const ElLucideGlyph eggOff = ElLucideGlyph('egg-off', <ElIconElement>[
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement(
      'M20 14.347V14c0-6-4-12-8-12-1.078 0-2.157.436-3.157 1.19',
    ), // key: 13g2jy
    ElIconPathElement(
      'M6.206 6.21C4.871 8.4 4 11.2 4 14a8 8 0 0 0 14.568 4.568',
    ), // key: 1581id
  ]);

  /// `egg.mjs`
  static const ElLucideGlyph egg = ElLucideGlyph('egg', <ElIconElement>[
    ElIconPathElement(
      'M12 2C8 2 4 8 4 14a8 8 0 0 0 16 0c0-6-4-12-8-12',
    ), // key: 1le142
  ]);

  /// `ellipse.mjs`
  static const ElLucideGlyph ellipse = ElLucideGlyph('ellipse', <ElIconElement>[
    ElIconEllipseElement(12, 12, 10, 6), // key: swdkt4
  ]);

  /// `ellipsis-vertical.mjs`
  static const ElLucideGlyph ellipsisVertical = ElLucideGlyph(
    'ellipsis-vertical',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 1), // key: 41hilf
      ElIconCircleElement(12, 5, 1), // key: gxeob9
      ElIconCircleElement(12, 19, 1), // key: lyex9k
    ],
  );

  /// `ellipsis.mjs`
  static const ElLucideGlyph ellipsis = ElLucideGlyph(
    'ellipsis',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 1), // key: 41hilf
      ElIconCircleElement(19, 12, 1), // key: 1wjl8i
      ElIconCircleElement(5, 12, 1), // key: 1pcz8c
    ],
  );

  /// `equal-approximately.mjs`
  static const ElLucideGlyph equalApproximately = ElLucideGlyph(
    'equal-approximately',
    <ElIconElement>[
      ElIconPathElement(
        'M5 15a6.5 6.5 0 0 1 7 0 6.5 6.5 0 0 0 7 0',
      ), // key: yrdkhy
      ElIconPathElement(
        'M5 9a6.5 6.5 0 0 1 7 0 6.5 6.5 0 0 0 7 0',
      ), // key: gzkvyz
    ],
  );

  /// `equal-not.mjs`
  static const ElLucideGlyph equalNot = ElLucideGlyph(
    'equal-not',
    <ElIconElement>[
      ElIconLineElement(5, 9, 19, 9), // key: 1nwqeh
      ElIconLineElement(5, 15, 19, 15), // key: g8yjpy
      ElIconLineElement(19, 5, 5, 19), // key: 1x9vlm
    ],
  );

  /// `equal.mjs`
  static const ElLucideGlyph equal = ElLucideGlyph('equal', <ElIconElement>[
    ElIconLineElement(5, 9, 19, 9), // key: 1nwqeh
    ElIconLineElement(5, 15, 19, 15), // key: g8yjpy
  ]);

  /// `eraser.mjs`
  static const ElLucideGlyph eraser = ElLucideGlyph('eraser', <ElIconElement>[
    ElIconPathElement(
      'M21 21H8a2 2 0 0 1-1.42-.587l-3.994-3.999a2 2 0 0 1 0-2.828l10-10a2 2 0 0 1 2.829 0l5.999 6a2 2 0 0 1 0 2.828L12.834 21',
    ), // key: g5wo59
    ElIconPathElement('m5.082 11.09 8.828 8.828'), // key: 1wx5vj
  ]);

  /// `ethernet-port.mjs`
  static const ElLucideGlyph
  ethernetPort = ElLucideGlyph('ethernet-port', <ElIconElement>[
    ElIconPathElement('M10 8v1'), // key: 1talb4
    ElIconPathElement('M14 8v1'), // key: 1rsfgr
    ElIconPathElement('M18 8v1'), // key: gnkwox
    ElIconPathElement(
      'M19 17a2 2 0 00-1.765 1.059l-.47.882A2 2 0 0115 20H9a2 2 0 01-1.765-1.059l-.47-.882A2 2 0 005 17H4a2 2 0 01-2-2V6a2 2 0 012-2h16a2 2 0 012 2v9a2 2 0 01-2 2z',
    ), // key: v5qa57
    ElIconPathElement('M6 8v1'), // key: 1636ez
  ]);

  /// `euro.mjs`
  static const ElLucideGlyph euro = ElLucideGlyph('euro', <ElIconElement>[
    ElIconPathElement('M4 10h12'), // key: 1y6xl8
    ElIconPathElement('M4 14h9'), // key: 1loblj
    ElIconPathElement(
      'M19 6a7.7 7.7 0 0 0-5.2-2A7.9 7.9 0 0 0 6 12c0 4.4 3.5 8 7.8 8 2 0 3.8-.8 5.2-2',
    ), // key: 1j6lzo
  ]);

  /// `ev-charger.mjs`
  static const ElLucideGlyph evCharger = ElLucideGlyph(
    'ev-charger',
    <ElIconElement>[
      ElIconPathElement(
        'M14 13h2a2 2 0 0 1 2 2v2a2 2 0 0 0 4 0v-6.998a2 2 0 0 0-.59-1.42L18 5',
      ), // key: 1wtuz0
      ElIconPathElement(
        'M14 21V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v16',
      ), // key: e09ifn
      ElIconPathElement('M2 21h13'), // key: 1x0fut
      ElIconPathElement('M3 7h11'), // key: 19efrr
      ElIconPathElement('m9 11-2 3h3l-2 3'), // key: lmzxi1
    ],
  );

  /// `expand.mjs`
  static const ElLucideGlyph expand = ElLucideGlyph('expand', <ElIconElement>[
    ElIconPathElement('m15 15 6 6'), // key: 1s409w
    ElIconPathElement('m15 9 6-6'), // key: ko1vev
    ElIconPathElement('M21 16v5h-5'), // key: 1ck2sf
    ElIconPathElement('M21 8V3h-5'), // key: 1qoq8a
    ElIconPathElement('M3 16v5h5'), // key: 1t08am
    ElIconPathElement('m3 21 6-6'), // key: wwnumi
    ElIconPathElement('M3 8V3h5'), // key: 1ln10m
    ElIconPathElement('M9 9 3 3'), // key: v551iv
  ]);

  /// `external-link.mjs`
  static const ElLucideGlyph externalLink = ElLucideGlyph(
    'external-link',
    <ElIconElement>[
      ElIconPathElement('M15 3h6v6'), // key: 1q9fwt
      ElIconPathElement('M10 14 21 3'), // key: gplh6r
      ElIconPathElement(
        'M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6',
      ), // key: a6xqqp
    ],
  );

  /// `eye-closed.mjs`
  static const ElLucideGlyph eyeClosed = ElLucideGlyph(
    'eye-closed',
    <ElIconElement>[
      ElIconPathElement('m15 18-.722-3.25'), // key: 1j64jw
      ElIconPathElement('M2 8a10.645 10.645 0 0 0 20 0'), // key: 1e7gxb
      ElIconPathElement('m20 15-1.726-2.05'), // key: 1cnuld
      ElIconPathElement('m4 15 1.726-2.05'), // key: 1dsqqd
      ElIconPathElement('m9 18 .722-3.25'), // key: ypw2yx
    ],
  );

  /// `eye-dashed.mjs`
  static const ElLucideGlyph
  eyeDashed = ElLucideGlyph('eye-dashed', <ElIconElement>[
    ElIconPathElement('M13.054 18.946a11 11 0 0 1-2.11 0'), // key: 1lgjj0
    ElIconPathElement('M13.054 5.054a11 11 0 0 0-2.11-.001'), // key: f7voaa
    ElIconPathElement('M17.072 6.274a11 11 0 0 1 1.753 1.173'), // key: 1rga24
    ElIconPathElement('M18.825 16.552a11 11 0 0 1-1.753 1.174'), // key: jfvai2
    ElIconPathElement(
      'M2.514 13.303a11 11 0 0 1-.452-.954 1 1 0 0 1 0-.697 11 11 0 0 1 .45-.955',
    ), // key: 1deed4
    ElIconPathElement(
      'M21.485 10.697a11 11 0 0 1 .453.955 1 1 0 0 1 0 .697 11 11 0 0 1-.453.954',
    ), // key: 1k4xil
    ElIconPathElement('M5.173 7.448a11 11 0 0 1 1.753-1.174'), // key: mwd8rq
    ElIconPathElement('M6.926 17.726a11 11 0 0 1-1.753-1.174'), // key: 15rpim
    ElIconCircleElement(12, 12, 3), // key: 1v7zrd
  ]);

  /// `eye-off.mjs`
  static const ElLucideGlyph eyeOff = ElLucideGlyph('eye-off', <ElIconElement>[
    ElIconPathElement(
      'M10.733 5.076a10.744 10.744 0 0 1 11.205 6.575 1 1 0 0 1 0 .696 10.747 10.747 0 0 1-1.444 2.49',
    ), // key: ct8e1f
    ElIconPathElement('M14.084 14.158a3 3 0 0 1-4.242-4.242'), // key: 151rxh
    ElIconPathElement(
      'M17.479 17.499a10.75 10.75 0 0 1-15.417-5.151 1 1 0 0 1 0-.696 10.75 10.75 0 0 1 4.446-5.143',
    ), // key: 13bj9a
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `eye.mjs`
  static const ElLucideGlyph eye = ElLucideGlyph('eye', <ElIconElement>[
    ElIconPathElement(
      'M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0',
    ), // key: 1nclc0
    ElIconCircleElement(12, 12, 3), // key: 1v7zrd
  ]);

  /// `factory.mjs`
  static const ElLucideGlyph factory = ElLucideGlyph('factory', <ElIconElement>[
    ElIconPathElement('M12 16h.01'), // key: 1drbdi
    ElIconPathElement('M16 16h.01'), // key: 1f9h7w
    ElIconPathElement(
      'M3 19a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V8.5a.5.5 0 0 0-.769-.422l-4.462 2.844A.5.5 0 0 1 15 10.5v-2a.5.5 0 0 0-.769-.422L9.77 10.922A.5.5 0 0 1 9 10.5V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2z',
    ), // key: 1iv0i2
    ElIconPathElement('M8 16h.01'), // key: 18s6g9
  ]);

  /// `fan.mjs`
  static const ElLucideGlyph fan = ElLucideGlyph('fan', <ElIconElement>[
    ElIconPathElement(
      'M10.827 16.379a6.082 6.082 0 0 1-8.618-7.002l5.412 1.45a6.082 6.082 0 0 1 7.002-8.618l-1.45 5.412a6.082 6.082 0 0 1 8.618 7.002l-5.412-1.45a6.082 6.082 0 0 1-7.002 8.618l1.45-5.412Z',
    ), // key: 484a7f
    ElIconPathElement('M12 12v.01'), // key: u5ubse
  ]);

  /// `fast-forward.mjs`
  static const ElLucideGlyph
  fastForward = ElLucideGlyph('fast-forward', <ElIconElement>[
    ElIconPathElement(
      'M12 6a2 2 0 0 1 3.414-1.414l6 6a2 2 0 0 1 0 2.828l-6 6A2 2 0 0 1 12 18z',
    ), // key: b19h5q
    ElIconPathElement(
      'M2 6a2 2 0 0 1 3.414-1.414l6 6a2 2 0 0 1 0 2.828l-6 6A2 2 0 0 1 2 18z',
    ), // key: h7h5ge
  ]);

  /// `feather.mjs`
  static const ElLucideGlyph feather = ElLucideGlyph('feather', <ElIconElement>[
    ElIconPathElement(
      'M14.086 18.412A2 2 0 0112.67 19H5v-7.672a2 2 0 01.586-1.414L11.75 3.75a6 6 0 118.49 8.49z',
    ), // key: 1nq9jb
    ElIconPathElement('M16 8 2 22'), // key: vp34q
    ElIconPathElement('M17.488 15H9'), // key: 16yirz
  ]);

  /// `fence.mjs`
  static const ElLucideGlyph fence = ElLucideGlyph('fence', <ElIconElement>[
    ElIconPathElement(
      'M4 3 2 5v15c0 .6.4 1 1 1h2c.6 0 1-.4 1-1V5Z',
    ), // key: 1n2rgs
    ElIconPathElement('M6 8h4'), // key: utf9t1
    ElIconPathElement('M6 18h4'), // key: 12yh4b
    ElIconPathElement(
      'm12 3-2 2v15c0 .6.4 1 1 1h2c.6 0 1-.4 1-1V5Z',
    ), // key: 3ha7mj
    ElIconPathElement('M14 8h4'), // key: 1r8wg2
    ElIconPathElement('M14 18h4'), // key: 1t3kbu
    ElIconPathElement(
      'm20 3-2 2v15c0 .6.4 1 1 1h2c.6 0 1-.4 1-1V5Z',
    ), // key: dfd4e2
  ]);

  /// `ferris-wheel.mjs`
  static const ElLucideGlyph ferrisWheel = ElLucideGlyph(
    'ferris-wheel',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 2), // key: 1c9p78
      ElIconPathElement('M12 2v4'), // key: 3427ic
      ElIconPathElement('m6.8 15-3.5 2'), // key: hjy98k
      ElIconPathElement('m20.7 7-3.5 2'), // key: f08gto
      ElIconPathElement('M6.8 9 3.3 7'), // key: 1aevh4
      ElIconPathElement('m20.7 17-3.5-2'), // key: 1liqo3
      ElIconPathElement('m9 22 3-8 3 8'), // key: wees03
      ElIconPathElement('M8 22h8'), // key: rmew8v
      ElIconPathElement('M18 18.7a9 9 0 1 0-12 0'), // key: dhzg4g
    ],
  );

  /// `file-archive.mjs`
  static const ElLucideGlyph
  fileArchive = ElLucideGlyph('file-archive', <ElIconElement>[
    ElIconPathElement(
      'M13.659 22H18a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v11.5',
    ), // key: 4pqfef
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M8 12v-1'), // key: 1ej8lb
    ElIconPathElement('M8 18v-2'), // key: qcmpov
    ElIconPathElement('M8 7V6'), // key: 1nbb54
    ElIconCircleElement(8, 20, 2), // key: ckkr5m
  ]);

  /// `file-axis-3d.mjs`
  static const ElLucideGlyph
  fileAxis3d = ElLucideGlyph('file-axis-3d', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('m8 18 4-4'), // key: 12zab0
    ElIconPathElement('M8 10v8h8'), // key: tlaukw
  ]);

  /// `file-badge.mjs`
  static const ElLucideGlyph
  fileBadge = ElLucideGlyph('file-badge', <ElIconElement>[
    ElIconPathElement(
      'M13 22h5a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v3.3',
    ), // key: cvl1xm
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement(
      'm7.69 16.479 1.29 4.88a.5.5 0 0 1-.698.591l-1.843-.849a1 1 0 0 0-.879.001l-1.846.85a.5.5 0 0 1-.692-.593l1.29-4.88',
    ), // key: 1ff7gj
    ElIconCircleElement(6, 14, 3), // key: a1xfv6
  ]);

  /// `file-box.mjs`
  static const ElLucideGlyph
  fileBox = ElLucideGlyph('file-box', <ElIconElement>[
    ElIconPathElement('M14 2v5a1 1 0 001 1h5'), // key: 9v5fu7
    ElIconPathElement(
      'M14.692 22H18a2 2 0 002-2V8a2.4 2.4 0 00-.706-1.706l-3.588-3.588A2.4 2.4 0 0014 2H6a2 2 0 00-2 2v3.804',
    ), // key: 1ne0j7
    ElIconPathElement('M2.264 13.752 7 16.5l4.737-2.748'), // key: t73mg3
    ElIconPathElement(
      'M2.995 13.014A2 2 0 002 14.744v3.516a2 2 0 00.996 1.73l3 1.74a2 2 0 002.008 0l3-1.74A2 2 0 0012 18.26v-3.517a2 2 0 00-.995-1.73l-3-1.742a2 2 0 00-1.892-.064z',
    ), // key: h4qck
    ElIconPathElement('M7 16.5V22'), // key: 1i1gou
  ]);

  /// `file-braces-corner.mjs`
  static const ElLucideGlyph
  fileBracesCorner = ElLucideGlyph('file-braces-corner', <ElIconElement>[
    ElIconPathElement(
      'M14 22h4a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v6',
    ), // key: 14cnrg
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement(
      'M5 14a1 1 0 0 0-1 1v2a1 1 0 0 1-1 1 1 1 0 0 1 1 1v2a1 1 0 0 0 1 1',
    ), // key: sr0ebq
    ElIconPathElement(
      'M9 22a1 1 0 0 0 1-1v-2a1 1 0 0 1 1-1 1 1 0 0 1-1-1v-2a1 1 0 0 0-1-1',
    ), // key: w793db
  ]);

  /// `file-braces.mjs`
  static const ElLucideGlyph
  fileBraces = ElLucideGlyph('file-braces', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement(
      'M10 12a1 1 0 0 0-1 1v1a1 1 0 0 1-1 1 1 1 0 0 1 1 1v1a1 1 0 0 0 1 1',
    ), // key: 1oajmo
    ElIconPathElement(
      'M14 18a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1 1 1 0 0 1-1-1v-1a1 1 0 0 0-1-1',
    ), // key: mpwhp6
  ]);

  /// `file-chart-column-increasing.mjs`
  static const ElLucideGlyph
  fileChartColumnIncreasing = ElLucideGlyph('file-chart-column-increasing', <
    ElIconElement
  >[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M8 18v-2'), // key: qcmpov
    ElIconPathElement('M12 18v-4'), // key: q1q25u
    ElIconPathElement('M16 18v-6'), // key: 15y0np
  ]);

  /// `file-chart-column.mjs`
  static const ElLucideGlyph
  fileChartColumn = ElLucideGlyph('file-chart-column', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M8 18v-1'), // key: zg0ygc
    ElIconPathElement('M12 18v-6'), // key: 17g6i2
    ElIconPathElement('M16 18v-3'), // key: j5jt4h
  ]);

  /// `file-chart-line.mjs`
  static const ElLucideGlyph
  fileChartLine = ElLucideGlyph('file-chart-line', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('m16 13-3.5 3.5-2-2L8 17'), // key: zz7yod
  ]);

  /// `file-chart-pie.mjs`
  static const ElLucideGlyph
  fileChartPie = ElLucideGlyph('file-chart-pie', <ElIconElement>[
    ElIconPathElement(
      'M15.941 22H18a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.704l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v3.512',
    ), // key: 13hoie
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M4.017 11.512a6 6 0 1 0 8.466 8.475'), // key: s6vs5t
    ElIconPathElement(
      'M9 16a1 1 0 0 1-1-1v-4c0-.552.45-1.008.995-.917a6 6 0 0 1 4.922 4.922c.091.544-.365.995-.917.995z',
    ), // key: 1dl6s6
  ]);

  /// `file-check-corner.mjs`
  static const ElLucideGlyph
  fileCheckCorner = ElLucideGlyph('file-check-corner', <ElIconElement>[
    ElIconPathElement(
      'M10.5 22H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v6',
    ), // key: g5mvt7
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('m14 20 2 2 4-4'), // key: 15kota
  ]);

  /// `file-check.mjs`
  static const ElLucideGlyph
  fileCheck = ElLucideGlyph('file-check', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('m9 15 2 2 4-4'), // key: 1grp1n
  ]);

  /// `file-clock.mjs`
  static const ElLucideGlyph
  fileClock = ElLucideGlyph('file-clock', <ElIconElement>[
    ElIconPathElement(
      'M16 22h2a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v2.85',
    ), // key: ryk6xj
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M8 14v2.2l1.6 1'), // key: 6m4bie
    ElIconCircleElement(8, 16, 6), // key: 10v15b
  ]);

  /// `file-code-corner.mjs`
  static const ElLucideGlyph
  fileCodeCorner = ElLucideGlyph('file-code-corner', <ElIconElement>[
    ElIconPathElement(
      'M4 12.15V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2h-3.35',
    ), // key: 1wthlu
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('m5 16-3 3 3 3'), // key: 331omg
    ElIconPathElement('m9 22 3-3-3-3'), // key: lsp7cz
  ]);

  /// `file-code.mjs`
  static const ElLucideGlyph
  fileCode = ElLucideGlyph('file-code', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M10 12.5 8 15l2 2.5'), // key: 1tg20x
    ElIconPathElement('m14 12.5 2 2.5-2 2.5'), // key: yinavb
  ]);

  /// `file-cog.mjs`
  static const ElLucideGlyph
  fileCog = ElLucideGlyph('file-cog', <ElIconElement>[
    ElIconPathElement(
      'M15 8a1 1 0 0 1-1-1V2a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8z',
    ), // key: 1ckgky
    ElIconPathElement('M20 8v12a2 2 0 0 1-2 2h-4.182'), // key: 1726p0
    ElIconPathElement('m3.305 19.53.923-.382'), // key: ao1pio
    ElIconPathElement('M4 10.592V4a2 2 0 0 1 2-2h8'), // key: 1foop0
    ElIconPathElement('m4.228 16.852-.924-.383'), // key: 1fv9zy
    ElIconPathElement('m5.852 15.228-.383-.923'), // key: 1a9hc2
    ElIconPathElement('m5.852 20.772-.383.924'), // key: 1sh9ke
    ElIconPathElement('m8.148 15.228.383-.923'), // key: 4yu6lf
    ElIconPathElement('m8.53 21.696-.382-.924'), // key: 18b0s9
    ElIconPathElement('m9.773 16.852.922-.383'), // key: ti6xop
    ElIconPathElement('m9.773 19.148.922.383'), // key: rws47d
    ElIconCircleElement(7, 18, 3), // key: lvkj7j
  ]);

  /// `file-diff.mjs`
  static const ElLucideGlyph
  fileDiff = ElLucideGlyph('file-diff', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M9 10h6'), // key: 9gxzsh
    ElIconPathElement('M12 13V7'), // key: h0r20n
    ElIconPathElement('M9 17h6'), // key: r8uit2
  ]);

  /// `file-digit.mjs`
  static const ElLucideGlyph
  fileDigit = ElLucideGlyph('file-digit', <ElIconElement>[
    ElIconPathElement(
      'M4 12V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2',
    ), // key: jrl274
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M10 16h2v6'), // key: 1bxocy
    ElIconPathElement('M10 22h4'), // key: ceow96
    ElIconRectElement(2, 16, 4, 6, 2), // key: r45zd0
  ]);

  /// `file-down.mjs`
  static const ElLucideGlyph
  fileDown = ElLucideGlyph('file-down', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M12 18v-6'), // key: 17g6i2
    ElIconPathElement('m9 15 3 3 3-3'), // key: 1npd3o
  ]);

  /// `file-exclamation-point.mjs`
  static const ElLucideGlyph
  fileExclamationPoint = ElLucideGlyph('file-exclamation-point', <
    ElIconElement
  >[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M12 9v4'), // key: juzpu7
    ElIconPathElement('M12 17h.01'), // key: p32p05
  ]);

  /// `file-headphone.mjs`
  static const ElLucideGlyph
  fileHeadphone = ElLucideGlyph('file-headphone', <ElIconElement>[
    ElIconPathElement(
      'M4 6.835V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2h-.343',
    ), // key: 1vfytu
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement(
      'M2 19a2 2 0 0 1 4 0v1a2 2 0 0 1-4 0v-4a6 6 0 0 1 12 0v4a2 2 0 0 1-4 0v-1a2 2 0 0 1 4 0',
    ), // key: 1etmh7
  ]);

  /// `file-heart.mjs`
  static const ElLucideGlyph
  fileHeart = ElLucideGlyph('file-heart', <ElIconElement>[
    ElIconPathElement(
      'M13 22h5a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v7',
    ), // key: oagw2b
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement(
      'M3.62 18.8A2.25 2.25 0 1 1 7 15.836a2.25 2.25 0 1 1 3.38 2.966l-2.626 2.856a1 1 0 0 1-1.507 0z',
    ), // key: rg3psg
  ]);

  /// `file-image.mjs`
  static const ElLucideGlyph
  fileImage = ElLucideGlyph('file-image', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconCircleElement(10, 12, 2), // key: 737tya
    ElIconPathElement(
      'm20 17-1.296-1.296a2.41 2.41 0 0 0-3.408 0L9 22',
    ), // key: wt3hpn
  ]);

  /// `file-input.mjs`
  static const ElLucideGlyph
  fileInput = ElLucideGlyph('file-input', <ElIconElement>[
    ElIconPathElement(
      'M4 11V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-1',
    ), // key: 1q9hii
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M2 15h10'), // key: jfw4w8
    ElIconPathElement('m9 18 3-3-3-3'), // key: 112psh
  ]);

  /// `file-key.mjs`
  static const ElLucideGlyph
  fileKey = ElLucideGlyph('file-key', <ElIconElement>[
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M4 12v6'), // key: bg1pfk
    ElIconPathElement('M4 14h2'), // key: 1sf9f8
    ElIconPathElement(
      'M9.65 22H18a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v4',
    ), // key: d56i0q
    ElIconCircleElement(4, 20, 2), // key: 6kqj1y
  ]);

  /// `file-lock.mjs`
  static const ElLucideGlyph
  fileLock = ElLucideGlyph('file-lock', <ElIconElement>[
    ElIconPathElement(
      'M4 9.8V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2h-3',
    ), // key: 1432pc
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M9 17v-2a2 2 0 0 0-4 0v2'), // key: 168m41
    ElIconRectElement(3, 17, 8, 5, 1), // key: o8vfew
  ]);

  /// `file-minus-corner.mjs`
  static const ElLucideGlyph
  fileMinusCorner = ElLucideGlyph('file-minus-corner', <ElIconElement>[
    ElIconPathElement(
      'M20 14V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12',
    ), // key: l9p8hp
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M14 18h6'), // key: 1m8k6r
  ]);

  /// `file-minus.mjs`
  static const ElLucideGlyph
  fileMinus = ElLucideGlyph('file-minus', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M9 15h6'), // key: cctwl0
  ]);

  /// `file-music.mjs`
  static const ElLucideGlyph
  fileMusic = ElLucideGlyph('file-music', <ElIconElement>[
    ElIconPathElement(
      'M11.65 22H18a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v10.35',
    ), // key: 5ad7z2
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M8 20v-7l3 1.474'), // key: 1ggyb9
    ElIconCircleElement(6, 20, 2), // key: j7wjp0
  ]);

  /// `file-output.mjs`
  static const ElLucideGlyph
  fileOutput = ElLucideGlyph('file-output', <ElIconElement>[
    ElIconPathElement(
      'M4.226 20.925A2 2 0 0 0 6 22h12a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v3.127',
    ), // key: wfxp4w
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('m5 11-3 3'), // key: 1dgrs4
    ElIconPathElement('m5 17-3-3h10'), // key: 1mvvaf
  ]);

  /// `file-pen-line.mjs`
  static const ElLucideGlyph
  filePenLine = ElLucideGlyph('file-pen-line', <ElIconElement>[
    ElIconPathElement(
      'M14.364 13.634a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506l4.013-4.009a1 1 0 0 0-3.004-3.004z',
    ), // key: ukzhwg
    ElIconPathElement('M14.487 7.858A1 1 0 0 1 14 7V2'), // key: 1klhew
    ElIconPathElement(
      'M20 19.645V20a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l2.516 2.516',
    ), // key: rxaxab
    ElIconPathElement('M8 18h1'), // key: 13wk12
  ]);

  /// `file-pen.mjs`
  static const ElLucideGlyph
  filePen = ElLucideGlyph('file-pen', <ElIconElement>[
    ElIconPathElement(
      'M12.659 22H18a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v9.34',
    ), // key: o6klzx
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement(
      'M10.378 12.622a1 1 0 0 1 3 3.003L8.36 20.637a2 2 0 0 1-.854.506l-2.867.837a.5.5 0 0 1-.62-.62l.836-2.869a2 2 0 0 1 .506-.853z',
    ), // key: zhnas1
  ]);

  /// `file-play.mjs`
  static const ElLucideGlyph
  filePlay = ElLucideGlyph('file-play', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement(
      'M15.033 13.44a.647.647 0 0 1 0 1.12l-4.065 2.352a.645.645 0 0 1-.968-.56v-4.704a.645.645 0 0 1 .967-.56z',
    ), // key: 1tzo1f
  ]);

  /// `file-plus-corner.mjs`
  static const ElLucideGlyph
  filePlusCorner = ElLucideGlyph('file-plus-corner', <ElIconElement>[
    ElIconPathElement(
      'M11.35 22H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v5.35',
    ), // key: 17jvcc
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M14 19h6'), // key: bvotb8
    ElIconPathElement('M17 16v6'), // key: 18yu1i
  ]);

  /// `file-plus.mjs`
  static const ElLucideGlyph
  filePlus = ElLucideGlyph('file-plus', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M9 15h6'), // key: cctwl0
    ElIconPathElement('M12 18v-6'), // key: 17g6i2
  ]);

  /// `file-question-mark.mjs`
  static const ElLucideGlyph
  fileQuestionMark = ElLucideGlyph('file-question-mark', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M12 17h.01'), // key: p32p05
    ElIconPathElement('M9.1 9a3 3 0 0 1 5.82 1c0 2-3 3-3 3'), // key: mhlwft
  ]);

  /// `file-scan.mjs`
  static const ElLucideGlyph
  fileScan = ElLucideGlyph('file-scan', <ElIconElement>[
    ElIconPathElement(
      'M20 10V8a2.4 2.4 0 0 0-.706-1.704l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h4.35',
    ), // key: 1cdjst
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M16 14a2 2 0 0 0-2 2'), // key: ceaadl
    ElIconPathElement('M16 22a2 2 0 0 1-2-2'), // key: 1wqh5n
    ElIconPathElement('M20 14a2 2 0 0 1 2 2'), // key: 1ny6zw
    ElIconPathElement('M20 22a2 2 0 0 0 2-2'), // key: 1l9q4k
  ]);

  /// `file-search-corner.mjs`
  static const ElLucideGlyph
  fileSearchCorner = ElLucideGlyph('file-search-corner', <ElIconElement>[
    ElIconPathElement(
      'M11.1 22H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.589 3.588A2.4 2.4 0 0 1 20 8v3.25',
    ), // key: uh4ikj
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('m21 22-2.88-2.88'), // key: 9dd25w
    ElIconCircleElement(16, 17, 3), // key: 11br10
  ]);

  /// `file-search.mjs`
  static const ElLucideGlyph
  fileSearch = ElLucideGlyph('file-search', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconCircleElement(11.5, 14.5, 2.5), // key: 1bq0ko
    ElIconPathElement('M13.3 16.3 15 18'), // key: 2quom7
  ]);

  /// `file-signal.mjs`
  static const ElLucideGlyph
  fileSignal = ElLucideGlyph('file-signal', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M8 15h.01'), // key: a7atzg
    ElIconPathElement('M11.5 13.5a2.5 2.5 0 0 1 0 3'), // key: 1fccat
    ElIconPathElement('M15 12a5 5 0 0 1 0 6'), // key: ps46cm
  ]);

  /// `file-sliders.mjs`
  static const ElLucideGlyph
  fileSliders = ElLucideGlyph('file-sliders', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M8 12h8'), // key: 1wcyev
    ElIconPathElement('M10 11v2'), // key: 1s651w
    ElIconPathElement('M8 17h8'), // key: wh5c61
    ElIconPathElement('M14 16v2'), // key: 12fp5e
  ]);

  /// `file-spreadsheet.mjs`
  static const ElLucideGlyph
  fileSpreadsheet = ElLucideGlyph('file-spreadsheet', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M8 13h2'), // key: yr2amv
    ElIconPathElement('M14 13h2'), // key: un5t4a
    ElIconPathElement('M8 17h2'), // key: 2yhykz
    ElIconPathElement('M14 17h2'), // key: 10kma7
  ]);

  /// `file-stack.mjs`
  static const ElLucideGlyph
  fileStack = ElLucideGlyph('file-stack', <ElIconElement>[
    ElIconPathElement(
      'M11 21a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1v-8a1 1 0 0 1 1-1',
    ), // key: likhh7
    ElIconPathElement(
      'M16 16a1 1 0 0 1-1 1H9a1 1 0 0 1-1-1V8a1 1 0 0 1 1-1',
    ), // key: 17ky3x
    ElIconPathElement(
      'M21 6a2 2 0 0 0-.586-1.414l-2-2A2 2 0 0 0 17 2h-3a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1z',
    ), // key: 1hyeo0
  ]);

  /// `file-symlink.mjs`
  static const ElLucideGlyph
  fileSymlink = ElLucideGlyph('file-symlink', <ElIconElement>[
    ElIconPathElement(
      'M4 11V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h7',
    ), // key: huwfnr
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('m10 18 3-3-3-3'), // key: 18f6ys
  ]);

  /// `file-terminal.mjs`
  static const ElLucideGlyph
  fileTerminal = ElLucideGlyph('file-terminal', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('m8 16 2-2-2-2'), // key: 10vzyd
    ElIconPathElement('M12 18h4'), // key: 1wd2n7
  ]);

  /// `file-text.mjs`
  static const ElLucideGlyph
  fileText = ElLucideGlyph('file-text', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M10 9H8'), // key: b1mrlr
    ElIconPathElement('M16 13H8'), // key: t4e002
    ElIconPathElement('M16 17H8'), // key: z1uh3a
  ]);

  /// `file-type-corner.mjs`
  static const ElLucideGlyph
  fileTypeCorner = ElLucideGlyph('file-type-corner', <ElIconElement>[
    ElIconPathElement(
      'M12 22h6a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v6',
    ), // key: 15usau
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement(
      'M3 16v-1.5a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 .5.5V16',
    ), // key: s1gz5
    ElIconPathElement('M6 22h2'), // key: 194x9m
    ElIconPathElement('M7 14v8'), // key: 11ixej
  ]);

  /// `file-type.mjs`
  static const ElLucideGlyph
  fileType = ElLucideGlyph('file-type', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M11 18h2'), // key: 12mj7e
    ElIconPathElement('M12 12v6'), // key: 3ahymv
    ElIconPathElement(
      'M9 13v-.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 .5.5v.5',
    ), // key: qbrxap
  ]);

  /// `file-up.mjs`
  static const ElLucideGlyph fileUp = ElLucideGlyph('file-up', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M12 12v6'), // key: 3ahymv
    ElIconPathElement('m15 15-3-3-3 3'), // key: 15xj92
  ]);

  /// `file-user.mjs`
  static const ElLucideGlyph
  fileUser = ElLucideGlyph('file-user', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M16 22a4 4 0 0 0-8 0'), // key: 7a83pg
    ElIconCircleElement(12, 15, 3), // key: g36mzq
  ]);

  /// `file-video-camera.mjs`
  static const ElLucideGlyph
  fileVideoCamera = ElLucideGlyph('file-video-camera', <ElIconElement>[
    ElIconPathElement(
      'M4 12V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2',
    ), // key: jrl274
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement(
      'm10 17.843 3.033-1.755a.64.64 0 0 1 .967.56v4.704a.65.65 0 0 1-.967.56L10 20.157',
    ), // key: 17aeo9
    ElIconRectElement(3, 16, 7, 6, 1), // key: s27ndx
  ]);

  /// `file-volume.mjs`
  static const ElLucideGlyph
  fileVolume = ElLucideGlyph('file-volume', <ElIconElement>[
    ElIconPathElement(
      'M4 11.55V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2h-1.95',
    ), // key: 44gpjv
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M12 15a5 5 0 0 1 0 6'), // key: oxg87a
    ElIconPathElement(
      'M8 14.502a.5.5 0 0 0-.826-.381l-1.893 1.631a1 1 0 0 1-.651.243H3.5a.5.5 0 0 0-.5.501v3.006a.5.5 0 0 0 .5.501h1.129a1 1 0 0 1 .652.243l1.893 1.633a.5.5 0 0 0 .826-.38z',
    ), // key: 8rtoi1
  ]);

  /// `file-x-corner.mjs`
  static const ElLucideGlyph
  fileXCorner = ElLucideGlyph('file-x-corner', <ElIconElement>[
    ElIconPathElement(
      'M11 22H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v5',
    ), // key: 1jo35a
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('m15 17 5 5'), // key: 36xl1x
    ElIconPathElement('m20 17-5 5'), // key: vdz27y
  ]);

  /// `file-x.mjs`
  static const ElLucideGlyph fileX = ElLucideGlyph('file-x', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('m14.5 12.5-5 5'), // key: b62r18
    ElIconPathElement('m9.5 12.5 5 5'), // key: 1rk7el
  ]);

  /// `file.mjs`
  static const ElLucideGlyph file = ElLucideGlyph('file', <ElIconElement>[
    ElIconPathElement(
      'M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z',
    ), // key: 1oefj6
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
  ]);

  /// `files.mjs`
  static const ElLucideGlyph files = ElLucideGlyph('files', <ElIconElement>[
    ElIconPathElement(
      'M15 2h-4a2 2 0 0 0-2 2v11a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V8',
    ), // key: 14sh0y
    ElIconPathElement(
      'M16.706 2.706A2.4 2.4 0 0 0 15 2v5a1 1 0 0 0 1 1h5a2.4 2.4 0 0 0-.706-1.706z',
    ), // key: 1970lx
    ElIconPathElement(
      'M5 7a2 2 0 0 0-2 2v11a2 2 0 0 0 2 2h8a2 2 0 0 0 1.732-1',
    ), // key: l4dndm
  ]);

  /// `film.mjs`
  static const ElLucideGlyph film = ElLucideGlyph('film', <ElIconElement>[
    ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    ElIconPathElement('M7 3v18'), // key: bbkbws
    ElIconPathElement('M3 7.5h4'), // key: zfgn84
    ElIconPathElement('M3 12h18'), // key: 1i2n21
    ElIconPathElement('M3 16.5h4'), // key: 1230mu
    ElIconPathElement('M17 3v18'), // key: in4fa5
    ElIconPathElement('M17 7.5h4'), // key: myr1c1
    ElIconPathElement('M17 16.5h4'), // key: go4c1d
  ]);

  /// `fingerprint-pattern.mjs`
  static const ElLucideGlyph fingerprintPattern = ElLucideGlyph(
    'fingerprint-pattern',
    <ElIconElement>[
      ElIconPathElement(
        'M12 10a2 2 0 0 0-2 2c0 1.02-.1 2.51-.26 4',
      ), // key: 1nerag
      ElIconPathElement('M14 13.12c0 2.38 0 6.38-1 8.88'), // key: o46ks0
      ElIconPathElement('M17.29 21.02c.12-.6.43-2.3.5-3.02'), // key: ptglia
      ElIconPathElement('M2 12a10 10 0 0 1 18-6'), // key: ydlgp0
      ElIconPathElement('M2 16h.01'), // key: 1gqxmh
      ElIconPathElement('M21.8 16c.2-2 .131-5.354 0-6'), // key: drycrb
      ElIconPathElement(
        'M5 19.5C5.5 18 6 15 6 12a6 6 0 0 1 .34-2',
      ), // key: 1tidbn
      ElIconPathElement('M8.65 22c.21-.66.45-1.32.57-2'), // key: 13wd9y
      ElIconPathElement('M9 6.8a6 6 0 0 1 9 5.2v2'), // key: 1fr1j5
    ],
  );

  /// `fire-extinguisher.mjs`
  static const ElLucideGlyph fireExtinguisher = ElLucideGlyph(
    'fire-extinguisher',
    <ElIconElement>[
      ElIconPathElement(
        'M15 6.5V3a1 1 0 0 0-1-1h-2a1 1 0 0 0-1 1v3.5',
      ), // key: sqyvz
      ElIconPathElement('M9 18h8'), // key: i7pszb
      ElIconPathElement('M18 3h-3'), // key: 7idoqj
      ElIconPathElement('M11 3a6 6 0 0 0-6 6v11'), // key: 1v5je3
      ElIconPathElement('M5 13h4'), // key: svpcxo
      ElIconPathElement(
        'M17 10a4 4 0 0 0-8 0v10a2 2 0 0 0 2 2h4a2 2 0 0 0 2-2Z',
      ), // key: vsjego
    ],
  );

  /// `fish-off.mjs`
  static const ElLucideGlyph
  fishOff = ElLucideGlyph('fish-off', <ElIconElement>[
    ElIconPathElement(
      'M18 12.47v.03m0-.5v.47m-.475 5.056A6.744 6.744 0 0 1 15 18c-3.56 0-7.56-2.53-8.5-6 .348-1.28 1.114-2.433 2.121-3.38m3.444-2.088A8.802 8.802 0 0 1 15 6c3.56 0 6.06 2.54 7 6-.309 1.14-.786 2.177-1.413 3.058',
    ), // key: 1j1hse
    ElIconPathElement(
      'M7 10.67C7 8 5.58 5.97 2.73 5.5c-1 1.5-1 5 .23 6.5-1.24 1.5-1.24 5-.23 6.5C5.58 18.03 7 16 7 13.33m7.48-4.372A9.77 9.77 0 0 1 16 6.07m0 11.86a9.77 9.77 0 0 1-1.728-3.618',
    ), // key: 1q46z8
    ElIconPathElement(
      'm16.01 17.93-.23 1.4A2 2 0 0 1 13.8 21H9.5a5.96 5.96 0 0 0 1.49-3.98M8.53 3h5.27a2 2 0 0 1 1.98 1.67l.23 1.4M2 2l20 20',
    ), // key: 1407gh
  ]);

  /// `fish-symbol.mjs`
  static const ElLucideGlyph fishSymbol = ElLucideGlyph(
    'fish-symbol',
    <ElIconElement>[
      ElIconPathElement('M2 16s9-15 20-4C11 23 2 8 2 8'), // key: h4oh4o
    ],
  );

  /// `fish.mjs`
  static const ElLucideGlyph fish = ElLucideGlyph('fish', <ElIconElement>[
    ElIconPathElement(
      'M6.5 12c.94-3.46 4.94-6 8.5-6 3.56 0 6.06 2.54 7 6-.94 3.47-3.44 6-7 6s-7.56-2.53-8.5-6Z',
    ), // key: 15baut
    ElIconPathElement('M18 12v.5'), // key: 18hhni
    ElIconPathElement('M16 17.93a9.77 9.77 0 0 1 0-11.86'), // key: 16dt7o
    ElIconPathElement(
      'M7 10.67C7 8 5.58 5.97 2.73 5.5c-1 1.5-1 5 .23 6.5-1.24 1.5-1.24 5-.23 6.5C5.58 18.03 7 16 7 13.33',
    ), // key: l9di03
    ElIconPathElement(
      'M10.46 7.26C10.2 5.88 9.17 4.24 8 3h5.8a2 2 0 0 1 1.98 1.67l.23 1.4',
    ), // key: 1kjonw
    ElIconPathElement(
      'm16.01 17.93-.23 1.4A2 2 0 0 1 13.8 21H9.5a5.96 5.96 0 0 0 1.49-3.98',
    ), // key: 1zlm23
  ]);

  /// `fishing-hook.mjs`
  static const ElLucideGlyph
  fishingHook = ElLucideGlyph('fishing-hook', <ElIconElement>[
    ElIconPathElement(
      'm17.586 11.414-5.93 5.93a1 1 0 0 1-8-8l3.137-3.137a.707.707 0 0 1 1.207.5V10',
    ), // key: 157y8s
    ElIconPathElement('M20.414 8.586 22 7'), // key: 5g2s34
    ElIconCircleElement(19, 10, 2), // key: 7363ft
  ]);

  /// `fishing-rod.mjs`
  static const ElLucideGlyph fishingRod = ElLucideGlyph(
    'fishing-rod',
    <ElIconElement>[
      ElIconPathElement('M4 11h1'), // key: 13eipc
      ElIconPathElement(
        'M8 15a2 2 0 0 1-4 0V3a1 1 0 0 1 1-1h.5C14 2 20 9 20 18v4',
      ), // key: 1hs3im
      ElIconCircleElement(18, 18, 2), // key: 1emm8v
    ],
  );

  /// `flag-off.mjs`
  static const ElLucideGlyph flagOff = ElLucideGlyph(
    'flag-off',
    <ElIconElement>[
      ElIconPathElement('M16 16c-3 0-5-2-8-2a6 6 0 0 0-4 1.528'), // key: 1q158e
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
      ElIconPathElement('M4 22V4'), // key: 1plyxx
      ElIconPathElement(
        'M7.656 2H8c3 0 5 2 7.333 2q2 0 3.067-.8A1 1 0 0 1 20 4v10.347',
      ), // key: xj1b71
    ],
  );

  /// `flag-triangle-left.mjs`
  static const ElLucideGlyph flagTriangleLeft = ElLucideGlyph(
    'flag-triangle-left',
    <ElIconElement>[
      ElIconPathElement(
        'M18 22V2.8a.8.8 0 0 0-1.17-.71L5.45 7.78a.8.8 0 0 0 0 1.44L18 15.5',
      ), // key: rbbtmw
    ],
  );

  /// `flag-triangle-right.mjs`
  static const ElLucideGlyph flagTriangleRight = ElLucideGlyph(
    'flag-triangle-right',
    <ElIconElement>[
      ElIconPathElement(
        'M6 22V2.8a.8.8 0 0 1 1.17-.71l11.38 5.69a.8.8 0 0 1 0 1.44L6 15.5',
      ), // key: kfjsu0
    ],
  );

  /// `flag.mjs`
  static const ElLucideGlyph flag = ElLucideGlyph('flag', <ElIconElement>[
    ElIconPathElement(
      'M4 22V4a1 1 0 0 1 .4-.8A6 6 0 0 1 8 2c3 0 5 2 7.333 2q2 0 3.067-.8A1 1 0 0 1 20 4v10a1 1 0 0 1-.4.8A6 6 0 0 1 16 16c-3 0-5-2-8-2a6 6 0 0 0-4 1.528',
    ), // key: 1jaruq
  ]);

  /// `flame-kindling.mjs`
  static const ElLucideGlyph
  flameKindling = ElLucideGlyph('flame-kindling', <ElIconElement>[
    ElIconPathElement(
      'M12 2c1 3 2.5 3.5 3.5 4.5A5 5 0 0 1 17 10a5 5 0 1 1-10 0c0-.3 0-.6.1-.9a2 2 0 1 0 3.3-2C8 4.5 11 2 12 2Z',
    ), // key: 1ir223
    ElIconPathElement('m5 22 14-4'), // key: 1brv4h
    ElIconPathElement('m5 18 14 4'), // key: lgyyje
  ]);

  /// `flame.mjs`
  static const ElLucideGlyph flame = ElLucideGlyph('flame', <ElIconElement>[
    ElIconPathElement(
      'M12 3q1 4 4 6.5t3 5.5a1 1 0 0 1-14 0 5 5 0 0 1 1-3 1 1 0 0 0 5 0c0-2-1.5-3-1.5-5q0-2 2.5-4',
    ), // key: 1slcih
  ]);

  /// `flashlight-off.mjs`
  static const ElLucideGlyph
  flashlightOff = ElLucideGlyph('flashlight-off', <ElIconElement>[
    ElIconPathElement('M11.652 6H18'), // key: voqkpr
    ElIconPathElement('M12 13v1'), // key: 176q98
    ElIconPathElement(
      'M16 16v4a2 2 0 0 1-2 2h-4a2 2 0 0 1-2-2v-8a4 4 0 0 0-.8-2.4l-.6-.8A3 3 0 0 1 6 7V6',
    ), // key: dzyf92
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement(
      'M7.649 2H17a1 1 0 0 1 1 1v4a3 3 0 0 1-.6 1.8l-.6.8a4 4 0 0 0-.55 1.007',
    ), // key: 1hvcfn
  ]);

  /// `flashlight.mjs`
  static const ElLucideGlyph
  flashlight = ElLucideGlyph('flashlight', <ElIconElement>[
    ElIconPathElement('M12 13v1'), // key: 176q98
    ElIconPathElement(
      'M17 2a1 1 0 0 1 1 1v4a3 3 0 0 1-.6 1.8l-.6.8A4 4 0 0 0 16 12v8a2 2 0 0 1-2 2H10a2 2 0 0 1-2-2v-8a4 4 0 0 0-.8-2.4l-.6-.8A3 3 0 0 1 6 7V3a1 1 0 0 1 1-1z',
    ), // key: 17vh7j
    ElIconPathElement('M6 6h12'), // key: n6hhss
  ]);

  /// `flask-conical-off.mjs`
  static const ElLucideGlyph flaskConicalOff = ElLucideGlyph(
    'flask-conical-off',
    <ElIconElement>[
      ElIconPathElement('M10 2v2.343'), // key: 15t272
      ElIconPathElement('M14 2v6.343'), // key: sxr80q
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
      ElIconPathElement(
        'M20 20a2 2 0 0 1-2 2H6a2 2 0 0 1-1.755-2.96l5.227-9.563',
      ), // key: k0duyd
      ElIconPathElement('M6.453 15H15'), // key: 1f0z33
      ElIconPathElement('M8.5 2h7'), // key: csnxdl
    ],
  );

  /// `flask-conical.mjs`
  static const ElLucideGlyph
  flaskConical = ElLucideGlyph('flask-conical', <ElIconElement>[
    ElIconPathElement(
      'M14 2v6a2 2 0 0 0 .245.96l5.51 10.08A2 2 0 0 1 18 22H6a2 2 0 0 1-1.755-2.96l5.51-10.08A2 2 0 0 0 10 8V2',
    ), // key: 18mbvz
    ElIconPathElement('M6.453 15h11.094'), // key: 3shlmq
    ElIconPathElement('M8.5 2h7'), // key: csnxdl
  ]);

  /// `flask-round.mjs`
  static const ElLucideGlyph flaskRound = ElLucideGlyph(
    'flask-round',
    <ElIconElement>[
      ElIconPathElement('M10 2v6.292a7 7 0 1 0 4 0V2'), // key: 1s42pc
      ElIconPathElement('M5 15h14'), // key: m0yey3
      ElIconPathElement('M8.5 2h7'), // key: csnxdl
    ],
  );

  /// `flip-horizontal-2.mjs`
  static const ElLucideGlyph flipHorizontal2 = ElLucideGlyph(
    'flip-horizontal-2',
    <ElIconElement>[
      ElIconPathElement('m3 7 5 5-5 5V7'), // key: couhi7
      ElIconPathElement('m21 7-5 5 5 5V7'), // key: 6ouia7
      ElIconPathElement('M12 20v2'), // key: 1lh1kg
      ElIconPathElement('M12 14v2'), // key: 8jcxud
      ElIconPathElement('M12 8v2'), // key: 1woqiv
      ElIconPathElement('M12 2v2'), // key: tus03m
    ],
  );

  /// `flip-vertical-2.mjs`
  static const ElLucideGlyph flipVertical2 = ElLucideGlyph(
    'flip-vertical-2',
    <ElIconElement>[
      ElIconPathElement('m17 3-5 5-5-5h10'), // key: 1ftt6x
      ElIconPathElement('m17 21-5-5-5 5h10'), // key: 1m0wmu
      ElIconPathElement('M4 12H2'), // key: rhcxmi
      ElIconPathElement('M10 12H8'), // key: s88cx1
      ElIconPathElement('M16 12h-2'), // key: 10asgb
      ElIconPathElement('M22 12h-2'), // key: 14jgyd
    ],
  );

  /// `flower-2.mjs`
  static const ElLucideGlyph
  flower2 = ElLucideGlyph('flower-2', <ElIconElement>[
    ElIconPathElement(
      'M12 5a3 3 0 1 1 3 3m-3-3a3 3 0 1 0-3 3m3-3v1M9 8a3 3 0 1 0 3 3M9 8h1m5 0a3 3 0 1 1-3 3m3-3h-1m-2 3v-1',
    ), // key: 3pnvol
    ElIconCircleElement(12, 8, 2), // key: 1822b1
    ElIconPathElement('M12 10v12'), // key: 6ubwww
    ElIconPathElement(
      'M12 22c4.2 0 7-1.667 7-5-4.2 0-7 1.667-7 5Z',
    ), // key: 9hd38g
    ElIconPathElement(
      'M12 22c-4.2 0-7-1.667-7-5 4.2 0 7 1.667 7 5Z',
    ), // key: ufn41s
  ]);

  /// `flower.mjs`
  static const ElLucideGlyph flower = ElLucideGlyph('flower', <ElIconElement>[
    ElIconCircleElement(12, 12, 3), // key: 1v7zrd
    ElIconPathElement(
      'M12 16.5A4.5 4.5 0 1 1 7.5 12 4.5 4.5 0 1 1 12 7.5a4.5 4.5 0 1 1 4.5 4.5 4.5 4.5 0 1 1-4.5 4.5',
    ), // key: 14wa3c
    ElIconPathElement('M12 7.5V9'), // key: 1oy5b0
    ElIconPathElement('M7.5 12H9'), // key: eltsq1
    ElIconPathElement('M16.5 12H15'), // key: vk5kw4
    ElIconPathElement('M12 16.5V15'), // key: k7eayi
    ElIconPathElement('m8 8 1.88 1.88'), // key: nxy4qf
    ElIconPathElement('M14.12 9.88 16 8'), // key: 1lst6k
    ElIconPathElement('m8 16 1.88-1.88'), // key: h2eex1
    ElIconPathElement('M14.12 14.12 16 16'), // key: uqkrx3
  ]);

  /// `focus.mjs`
  static const ElLucideGlyph focus = ElLucideGlyph('focus', <ElIconElement>[
    ElIconCircleElement(12, 12, 3), // key: 1v7zrd
    ElIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    ElIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    ElIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    ElIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
  ]);

  /// `fold-horizontal.mjs`
  static const ElLucideGlyph foldHorizontal = ElLucideGlyph(
    'fold-horizontal',
    <ElIconElement>[
      ElIconPathElement('M2 12h6'), // key: 1wqiqv
      ElIconPathElement('M22 12h-6'), // key: 1eg9hc
      ElIconPathElement('M12 2v2'), // key: tus03m
      ElIconPathElement('M12 8v2'), // key: 1woqiv
      ElIconPathElement('M12 14v2'), // key: 8jcxud
      ElIconPathElement('M12 20v2'), // key: 1lh1kg
      ElIconPathElement('m19 9-3 3 3 3'), // key: 12ol22
      ElIconPathElement('m5 15 3-3-3-3'), // key: 1kdhjc
    ],
  );

  /// `fold-vertical.mjs`
  static const ElLucideGlyph foldVertical = ElLucideGlyph(
    'fold-vertical',
    <ElIconElement>[
      ElIconPathElement('M12 22v-6'), // key: 6o8u61
      ElIconPathElement('M12 8V2'), // key: 1wkif3
      ElIconPathElement('M4 12H2'), // key: rhcxmi
      ElIconPathElement('M10 12H8'), // key: s88cx1
      ElIconPathElement('M16 12h-2'), // key: 10asgb
      ElIconPathElement('M22 12h-2'), // key: 14jgyd
      ElIconPathElement('m15 19-3-3-3 3'), // key: e37ymu
      ElIconPathElement('m15 5-3 3-3-3'), // key: 19d6lf
    ],
  );

  /// `folder-archive.mjs`
  static const ElLucideGlyph
  folderArchive = ElLucideGlyph('folder-archive', <ElIconElement>[
    ElIconCircleElement(15, 19, 2), // key: u2pros
    ElIconPathElement(
      'M20.9 19.8A2 2 0 0 0 22 18V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2h5.1',
    ), // key: 1jj40k
    ElIconPathElement('M15 11v-1'), // key: cntcp
    ElIconPathElement('M15 17v-2'), // key: 1279jj
  ]);

  /// `folder-bookmark.mjs`
  static const ElLucideGlyph
  folderBookmark = ElLucideGlyph('folder-bookmark', <ElIconElement>[
    ElIconPathElement('M12 6v8l3-3 3 3V6'), // key: 11pvqx
    ElIconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2z',
    ), // key: 1u1bxd
  ]);

  /// `folder-check.mjs`
  static const ElLucideGlyph
  folderCheck = ElLucideGlyph('folder-check', <ElIconElement>[
    ElIconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
    ElIconPathElement('m9 13 2 2 4-4'), // key: 6343dt
  ]);

  /// `folder-clock.mjs`
  static const ElLucideGlyph
  folderClock = ElLucideGlyph('folder-clock', <ElIconElement>[
    ElIconPathElement('M16 14v2.2l1.6 1'), // key: fo4ql5
    ElIconPathElement(
      'M7 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2',
    ), // key: 1urifu
    ElIconCircleElement(16, 16, 6), // key: qoo3c4
  ]);

  /// `folder-closed.mjs`
  static const ElLucideGlyph
  folderClosed = ElLucideGlyph('folder-closed', <ElIconElement>[
    ElIconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
    ElIconPathElement('M2 10h20'), // key: 1ir3d8
  ]);

  /// `folder-code.mjs`
  static const ElLucideGlyph
  folderCode = ElLucideGlyph('folder-code', <ElIconElement>[
    ElIconPathElement('M10 10.5 8 13l2 2.5'), // key: m4t9c1
    ElIconPathElement('m14 10.5 2 2.5-2 2.5'), // key: 14w2eb
    ElIconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2z',
    ), // key: 1u1bxd
  ]);

  /// `folder-cog.mjs`
  static const ElLucideGlyph
  folderCog = ElLucideGlyph('folder-cog', <ElIconElement>[
    ElIconPathElement(
      'M10.3 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.98a2 2 0 0 1 1.69.9l.66 1.2A2 2 0 0 0 12 6h8a2 2 0 0 1 2 2v3.3',
    ), // key: 128dxu
    ElIconPathElement('m14.305 19.53.923-.382'), // key: 3m78fa
    ElIconPathElement('m15.228 16.852-.923-.383'), // key: npixar
    ElIconPathElement('m16.852 15.228-.383-.923'), // key: 5xggr7
    ElIconPathElement('m16.852 20.772-.383.924'), // key: dpfhf9
    ElIconPathElement('m19.148 15.228.383-.923'), // key: 1reyyz
    ElIconPathElement('m19.53 21.696-.382-.924'), // key: 1goivc
    ElIconPathElement('m20.772 16.852.924-.383'), // key: htqkph
    ElIconPathElement('m20.772 19.148.924.383'), // key: 9w9pjp
    ElIconCircleElement(18, 18, 3), // key: 1xkwt0
  ]);

  /// `folder-dot.mjs`
  static const ElLucideGlyph
  folderDot = ElLucideGlyph('folder-dot', <ElIconElement>[
    ElIconPathElement(
      'M4 20h16a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.93a2 2 0 0 1-1.66-.9l-.82-1.2A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13c0 1.1.9 2 2 2Z',
    ), // key: 1fr9dc
    ElIconCircleElement(12, 13, 1), // key: 49l61u
  ]);

  /// `folder-down.mjs`
  static const ElLucideGlyph
  folderDown = ElLucideGlyph('folder-down', <ElIconElement>[
    ElIconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
    ElIconPathElement('M12 10v6'), // key: 1bos4e
    ElIconPathElement('m15 13-3 3-3-3'), // key: 6j2sf0
  ]);

  /// `folder-git-2.mjs`
  static const ElLucideGlyph
  folderGit2 = ElLucideGlyph('folder-git-2', <ElIconElement>[
    ElIconPathElement('M18 19a5 5 0 0 1-5-5v8'), // key: sz5oeg
    ElIconPathElement(
      'M9 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v5',
    ), // key: 1w6njk
    ElIconCircleElement(13, 12, 2), // key: 1j92g6
    ElIconCircleElement(20, 19, 2), // key: 1obnsp
  ]);

  /// `folder-git.mjs`
  static const ElLucideGlyph
  folderGit = ElLucideGlyph('folder-git', <ElIconElement>[
    ElIconCircleElement(12, 13, 2), // key: 1c1ljs
    ElIconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
    ElIconPathElement('M14 13h3'), // key: 1dgedf
    ElIconPathElement('M7 13h3'), // key: 1pygq7
  ]);

  /// `folder-heart.mjs`
  static const ElLucideGlyph
  folderHeart = ElLucideGlyph('folder-heart', <ElIconElement>[
    ElIconPathElement(
      'M10.638 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v3.417',
    ), // key: 10r6g4
    ElIconPathElement(
      'M14.62 18.8A2.25 2.25 0 1 1 18 15.836a2.25 2.25 0 1 1 3.38 2.966l-2.626 2.856a.998.998 0 0 1-1.507 0z',
    ), // key: 15cy7q
  ]);

  /// `folder-input.mjs`
  static const ElLucideGlyph
  folderInput = ElLucideGlyph('folder-input', <ElIconElement>[
    ElIconPathElement(
      'M2 9V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-1',
    ), // key: fm4g5t
    ElIconPathElement('M2 13h10'), // key: pgb2dq
    ElIconPathElement('m9 16 3-3-3-3'), // key: 6m91ic
  ]);

  /// `folder-kanban.mjs`
  static const ElLucideGlyph
  folderKanban = ElLucideGlyph('folder-kanban', <ElIconElement>[
    ElIconPathElement(
      'M4 20h16a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.93a2 2 0 0 1-1.66-.9l-.82-1.2A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13c0 1.1.9 2 2 2Z',
    ), // key: 1fr9dc
    ElIconPathElement('M8 10v4'), // key: tgpxqk
    ElIconPathElement('M12 10v2'), // key: hh53o1
    ElIconPathElement('M16 10v6'), // key: 1d6xys
  ]);

  /// `folder-key.mjs`
  static const ElLucideGlyph
  folderKey = ElLucideGlyph('folder-key', <ElIconElement>[
    ElIconPathElement(
      'M13 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v1.36',
    ), // key: 1shsnm
    ElIconPathElement('M19 12v6'), // key: kflna4
    ElIconPathElement('M19 14h2'), // key: wp2qbk
    ElIconCircleElement(19, 20, 2), // key: 1jfyz6
  ]);

  /// `folder-lock.mjs`
  static const ElLucideGlyph
  folderLock = ElLucideGlyph('folder-lock', <ElIconElement>[
    ElIconRectElement(14, 17, 8, 5, 1), // key: 19aais
    ElIconPathElement(
      'M10 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v2.5',
    ), // key: 1w6v7t
    ElIconPathElement('M20 17v-2a2 2 0 1 0-4 0v2'), // key: pwaxnr
  ]);

  /// `folder-minus.mjs`
  static const ElLucideGlyph
  folderMinus = ElLucideGlyph('folder-minus', <ElIconElement>[
    ElIconPathElement('M9 13h6'), // key: 1uhe8q
    ElIconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
  ]);

  /// `folder-open-dot.mjs`
  static const ElLucideGlyph
  folderOpenDot = ElLucideGlyph('folder-open-dot', <ElIconElement>[
    ElIconPathElement(
      'm6 14 1.45-2.9A2 2 0 0 1 9.24 10H20a2 2 0 0 1 1.94 2.5l-1.55 6a2 2 0 0 1-1.94 1.5H4a2 2 0 0 1-2-2V5c0-1.1.9-2 2-2h3.93a2 2 0 0 1 1.66.9l.82 1.2a2 2 0 0 0 1.66.9H18a2 2 0 0 1 2 2v2',
    ), // key: 1nmvlm
    ElIconCircleElement(14, 15, 1), // key: 1gm4qj
  ]);

  /// `folder-open.mjs`
  static const ElLucideGlyph
  folderOpen = ElLucideGlyph('folder-open', <ElIconElement>[
    ElIconPathElement(
      'm6 14 1.5-2.9A2 2 0 0 1 9.24 10H20a2 2 0 0 1 1.94 2.5l-1.54 6a2 2 0 0 1-1.95 1.5H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H18a2 2 0 0 1 2 2v2',
    ), // key: usdka0
  ]);

  /// `folder-output.mjs`
  static const ElLucideGlyph
  folderOutput = ElLucideGlyph('folder-output', <ElIconElement>[
    ElIconPathElement(
      'M2 7.5V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-1.5',
    ), // key: 1yk7aj
    ElIconPathElement('M2 13h10'), // key: pgb2dq
    ElIconPathElement('m5 10-3 3 3 3'), // key: 1r8ie0
  ]);

  /// `folder-pen.mjs`
  static const ElLucideGlyph
  folderPen = ElLucideGlyph('folder-pen', <ElIconElement>[
    ElIconPathElement(
      'M2 11.5V5a2 2 0 0 1 2-2h3.9c.7 0 1.3.3 1.7.9l.8 1.2c.4.6 1 .9 1.7.9H20a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-9.5',
    ), // key: a8xqs0
    ElIconPathElement(
      'M11.378 13.626a1 1 0 1 0-3.004-3.004l-5.01 5.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z',
    ), // key: 1saktj
  ]);

  /// `folder-plus.mjs`
  static const ElLucideGlyph
  folderPlus = ElLucideGlyph('folder-plus', <ElIconElement>[
    ElIconPathElement('M12 10v6'), // key: 1bos4e
    ElIconPathElement('M9 13h6'), // key: 1uhe8q
    ElIconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
  ]);

  /// `folder-root.mjs`
  static const ElLucideGlyph
  folderRoot = ElLucideGlyph('folder-root', <ElIconElement>[
    ElIconPathElement(
      'M4 20h16a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.93a2 2 0 0 1-1.66-.9l-.82-1.2A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13c0 1.1.9 2 2 2Z',
    ), // key: 1fr9dc
    ElIconCircleElement(12, 13, 2), // key: 1c1ljs
    ElIconPathElement('M12 15v5'), // key: 11xva1
  ]);

  /// `folder-search-2.mjs`
  static const ElLucideGlyph
  folderSearch2 = ElLucideGlyph('folder-search-2', <ElIconElement>[
    ElIconCircleElement(11.5, 12.5, 2.5), // key: 1ea5ju
    ElIconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
    ElIconPathElement('M13.3 14.3 15 16'), // key: 1y4v1n
  ]);

  /// `folder-search.mjs`
  static const ElLucideGlyph
  folderSearch = ElLucideGlyph('folder-search', <ElIconElement>[
    ElIconPathElement(
      'M10.7 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v4.1',
    ), // key: 1bw5m7
    ElIconPathElement('m21 21-1.9-1.9'), // key: 1g2n9r
    ElIconCircleElement(17, 17, 3), // key: 18b49y
  ]);

  /// `folder-symlink.mjs`
  static const ElLucideGlyph
  folderSymlink = ElLucideGlyph('folder-symlink', <ElIconElement>[
    ElIconPathElement(
      'M2 9.35V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h7',
    ), // key: y8kt7d
    ElIconPathElement('m8 16 3-3-3-3'), // key: rlqrt1
  ]);

  /// `folder-sync.mjs`
  static const ElLucideGlyph
  folderSync = ElLucideGlyph('folder-sync', <ElIconElement>[
    ElIconPathElement(
      'M9 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v.5',
    ), // key: 1dkoa9
    ElIconPathElement('M12 10v4h4'), // key: 1czhmt
    ElIconPathElement('m12 14 1.535-1.605a5 5 0 0 1 8 1.5'), // key: lvuxfi
    ElIconPathElement('M22 22v-4h-4'), // key: 1ewp4q
    ElIconPathElement('m22 18-1.535 1.605a5 5 0 0 1-8-1.5'), // key: 14ync0
  ]);

  /// `folder-tree.mjs`
  static const ElLucideGlyph
  folderTree = ElLucideGlyph('folder-tree', <ElIconElement>[
    ElIconPathElement(
      'M20 10a1 1 0 0 0 1-1V6a1 1 0 0 0-1-1h-2.5a1 1 0 0 1-.8-.4l-.9-1.2A1 1 0 0 0 15 3h-2a1 1 0 0 0-1 1v5a1 1 0 0 0 1 1Z',
    ), // key: hod4my
    ElIconPathElement(
      'M20 21a1 1 0 0 0 1-1v-3a1 1 0 0 0-1-1h-2.9a1 1 0 0 1-.88-.55l-.42-.85a1 1 0 0 0-.92-.6H13a1 1 0 0 0-1 1v5a1 1 0 0 0 1 1Z',
    ), // key: w4yl2u
    ElIconPathElement('M3 5a2 2 0 0 0 2 2h3'), // key: f2jnh7
    ElIconPathElement('M3 3v13a2 2 0 0 0 2 2h3'), // key: k8epm1
  ]);

  /// `folder-up.mjs`
  static const ElLucideGlyph
  folderUp = ElLucideGlyph('folder-up', <ElIconElement>[
    ElIconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
    ElIconPathElement('M12 10v6'), // key: 1bos4e
    ElIconPathElement('m9 13 3-3 3 3'), // key: 1pxg3c
  ]);

  /// `folder-x.mjs`
  static const ElLucideGlyph
  folderX = ElLucideGlyph('folder-x', <ElIconElement>[
    ElIconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
    ElIconPathElement('m9.5 10.5 5 5'), // key: ra9qjz
    ElIconPathElement('m14.5 10.5-5 5'), // key: l2rkpq
  ]);

  /// `folder.mjs`
  static const ElLucideGlyph folder = ElLucideGlyph('folder', <ElIconElement>[
    ElIconPathElement(
      'M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z',
    ), // key: 1kt360
  ]);

  /// `folders.mjs`
  static const ElLucideGlyph folders = ElLucideGlyph('folders', <ElIconElement>[
    ElIconPathElement(
      'M20 5a2 2 0 0 1 2 2v7a2 2 0 0 1-2 2H9a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h2.5a1.5 1.5 0 0 1 1.2.6l.6.8a1.5 1.5 0 0 0 1.2.6z',
    ), // key: a4852j
    ElIconPathElement(
      'M3 8.268a2 2 0 0 0-1 1.738V19a2 2 0 0 0 2 2h11a2 2 0 0 0 1.732-1',
    ), // key: yxbcw3
  ]);

  /// `footprints.mjs`
  static const ElLucideGlyph
  footprints = ElLucideGlyph('footprints', <ElIconElement>[
    ElIconPathElement(
      'M4 16v-2.38C4 11.5 2.97 10.5 3 8c.03-2.72 1.49-6 4.5-6C9.37 2 10 3.8 10 5.5c0 3.11-2 5.66-2 8.68V16a2 2 0 1 1-4 0Z',
    ), // key: 1dudjm
    ElIconPathElement(
      'M20 20v-2.38c0-2.12 1.03-3.12 1-5.62-.03-2.72-1.49-6-4.5-6C14.63 6 14 7.8 14 9.5c0 3.11 2 5.66 2 8.68V20a2 2 0 1 0 4 0Z',
    ), // key: l2t8xc
    ElIconPathElement('M16 17h4'), // key: 1dejxt
    ElIconPathElement('M4 13h4'), // key: 1bwh8b
  ]);

  /// `forklift.mjs`
  static const ElLucideGlyph
  forklift = ElLucideGlyph('forklift', <ElIconElement>[
    ElIconPathElement('M12 12H5a2 2 0 0 0-2 2v5'), // key: 7zsz91
    ElIconPathElement('M15 19h7'), // key: 1askl3
    ElIconPathElement('M16 19V2'), // key: 1gf9nk
    ElIconPathElement(
      'M6 12V7a2 2 0 0 1 2-2h2.172a2 2 0 0 1 1.414.586l3.828 3.828A2 2 0 0 1 16 10.828',
    ), // key: enx9tf
    ElIconPathElement('M7 19h4'), // key: fumhkk
    ElIconCircleElement(13, 19, 2), // key: wjnkru
    ElIconCircleElement(5, 19, 2), // key: v8kfzx
  ]);

  /// `form.mjs`
  static const ElLucideGlyph form = ElLucideGlyph('form', <ElIconElement>[
    ElIconPathElement('M4 14h6'), // key: 77gv2w
    ElIconPathElement('M4 2h10'), // key: a2b314
    ElIconRectElement(4, 18, 16, 4, 1), // key: sybzq6
    ElIconRectElement(4, 6, 16, 4, 1), // key: 1osc9e
  ]);

  /// `forward.mjs`
  static const ElLucideGlyph forward = ElLucideGlyph('forward', <ElIconElement>[
    ElIconPathElement('m15 17 5-5-5-5'), // key: nf172w
    ElIconPathElement('M4 18v-2a4 4 0 0 1 4-4h12'), // key: jmiej9
  ]);

  /// `frame.mjs`
  static const ElLucideGlyph frame = ElLucideGlyph('frame', <ElIconElement>[
    ElIconLineElement(22, 6, 2, 6), // key: 15w7dq
    ElIconLineElement(22, 18, 2, 18), // key: 1ip48p
    ElIconLineElement(6, 2, 6, 22), // key: a2lnyx
    ElIconLineElement(18, 2, 18, 22), // key: 8vb6jd
  ]);

  /// `frown.mjs`
  static const ElLucideGlyph frown = ElLucideGlyph('frown', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement('M16 16s-1.5-2-4-2-4 2-4 2'), // key: epbg0q
    ElIconLineElement(9, 9, 9.01, 9), // key: yxxnd0
    ElIconLineElement(15, 9, 15.01, 9), // key: 1p4y9e
  ]);

  /// `fuel.mjs`
  static const ElLucideGlyph fuel = ElLucideGlyph('fuel', <ElIconElement>[
    ElIconPathElement(
      'M14 13h2a2 2 0 0 1 2 2v2a2 2 0 0 0 4 0v-6.998a2 2 0 0 0-.59-1.42L18 5',
    ), // key: 1wtuz0
    ElIconPathElement(
      'M14 21V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v16',
    ), // key: e09ifn
    ElIconPathElement('M2 21h13'), // key: 1x0fut
    ElIconPathElement('M3 9h11'), // key: 1p7c0w
  ]);

  /// `fullscreen.mjs`
  static const ElLucideGlyph fullscreen = ElLucideGlyph(
    'fullscreen',
    <ElIconElement>[
      ElIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
      ElIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
      ElIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
      ElIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
      ElIconRectElement(7, 8, 10, 8, 1), // key: vys8me
    ],
  );

  /// `funnel-plus.mjs`
  static const ElLucideGlyph
  funnelPlus = ElLucideGlyph('funnel-plus', <ElIconElement>[
    ElIconPathElement(
      'M13.354 3H3a1 1 0 0 0-.742 1.67l7.225 7.989A2 2 0 0 1 10 14v6a1 1 0 0 0 .553.895l2 1A1 1 0 0 0 14 21v-7a2 2 0 0 1 .517-1.341l1.218-1.348',
    ), // key: 8mvsmf
    ElIconPathElement('M16 6h6'), // key: 1dogtp
    ElIconPathElement('M19 3v6'), // key: 1ytpjt
  ]);

  /// `funnel-x.mjs`
  static const ElLucideGlyph
  funnelX = ElLucideGlyph('funnel-x', <ElIconElement>[
    ElIconPathElement(
      'M12.531 3H3a1 1 0 0 0-.742 1.67l7.225 7.989A2 2 0 0 1 10 14v6a1 1 0 0 0 .553.895l2 1A1 1 0 0 0 14 21v-7a2 2 0 0 1 .517-1.341l.427-.473',
    ), // key: ol2ft2
    ElIconPathElement('m16.5 3.5 5 5'), // key: 15e6fa
    ElIconPathElement('m21.5 3.5-5 5'), // key: m0lwru
  ]);

  /// `funnel.mjs`
  static const ElLucideGlyph funnel = ElLucideGlyph('funnel', <ElIconElement>[
    ElIconPathElement(
      'M10 20a1 1 0 0 0 .553.895l2 1A1 1 0 0 0 14 21v-7a2 2 0 0 1 .517-1.341L21.74 4.67A1 1 0 0 0 21 3H3a1 1 0 0 0-.742 1.67l7.225 7.989A2 2 0 0 1 10 14z',
    ), // key: sc7q7i
  ]);

  /// `gallery-horizontal-end.mjs`
  static const ElLucideGlyph galleryHorizontalEnd = ElLucideGlyph(
    'gallery-horizontal-end',
    <ElIconElement>[
      ElIconPathElement('M2 7v10'), // key: a2pl2d
      ElIconPathElement('M6 5v14'), // key: 1kq3d7
      ElIconRectElement(10, 3, 12, 18, 2), // key: 13i7bc
    ],
  );

  /// `gallery-horizontal.mjs`
  static const ElLucideGlyph galleryHorizontal = ElLucideGlyph(
    'gallery-horizontal',
    <ElIconElement>[
      ElIconPathElement('M2 3v18'), // key: pzttux
      ElIconRectElement(6, 3, 12, 18, 2), // key: btr8bg
      ElIconPathElement('M22 3v18'), // key: 6jf3v
    ],
  );

  /// `gallery-thumbnails.mjs`
  static const ElLucideGlyph galleryThumbnails = ElLucideGlyph(
    'gallery-thumbnails',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 14, 2), // key: 74y24f
      ElIconPathElement('M4 21h1'), // key: 16zlid
      ElIconPathElement('M9 21h1'), // key: 15o7lz
      ElIconPathElement('M14 21h1'), // key: v9vybs
      ElIconPathElement('M19 21h1'), // key: edywat
    ],
  );

  /// `gallery-vertical-end.mjs`
  static const ElLucideGlyph galleryVerticalEnd = ElLucideGlyph(
    'gallery-vertical-end',
    <ElIconElement>[
      ElIconPathElement('M7 2h10'), // key: nczekb
      ElIconPathElement('M5 6h14'), // key: u2x4p
      ElIconRectElement(3, 10, 18, 12, 2), // key: l0tzu3
    ],
  );

  /// `gallery-vertical.mjs`
  static const ElLucideGlyph galleryVertical = ElLucideGlyph(
    'gallery-vertical',
    <ElIconElement>[
      ElIconPathElement('M3 2h18'), // key: 15qxfx
      ElIconRectElement(3, 6, 18, 12, 2), // key: 1439r6
      ElIconPathElement('M3 22h18'), // key: 8prr45
    ],
  );

  /// `gamepad-2.mjs`
  static const ElLucideGlyph
  gamepad2 = ElLucideGlyph('gamepad-2', <ElIconElement>[
    ElIconLineElement(6, 11, 10, 11), // key: 1gktln
    ElIconLineElement(8, 9, 8, 13), // key: qnk9ow
    ElIconLineElement(15, 12, 15.01, 12), // key: krot7o
    ElIconLineElement(18, 10, 18.01, 10), // key: 1lcuu1
    ElIconPathElement(
      'M17.32 5H6.68a4 4 0 0 0-3.978 3.59c-.006.052-.01.101-.017.152C2.604 9.416 2 14.456 2 16a3 3 0 0 0 3 3c1 0 1.5-.5 2-1l1.414-1.414A2 2 0 0 1 9.828 16h4.344a2 2 0 0 1 1.414.586L17 18c.5.5 1 1 2 1a3 3 0 0 0 3-3c0-1.545-.604-6.584-.685-7.258-.007-.05-.011-.1-.017-.151A4 4 0 0 0 17.32 5z',
    ), // key: mfqc10
  ]);

  /// `gamepad-directional.mjs`
  static const ElLucideGlyph
  gamepadDirectional = ElLucideGlyph('gamepad-directional', <ElIconElement>[
    ElIconPathElement(
      'M11.146 15.854a1.207 1.207 0 0 1 1.708 0l1.56 1.56A2 2 0 0 1 15 18.828V21a1 1 0 0 1-1 1h-4a1 1 0 0 1-1-1v-2.172a2 2 0 0 1 .586-1.414z',
    ), // key: 1re2og
    ElIconPathElement(
      'M18.828 15a2 2 0 0 1-1.414-.586l-1.56-1.56a1.207 1.207 0 0 1 0-1.708l1.56-1.56A2 2 0 0 1 18.828 9H21a1 1 0 0 1 1 1v4a1 1 0 0 1-1 1z',
    ), // key: 1pchrj
    ElIconPathElement(
      'M6.586 14.414A2 2 0 0 1 5.172 15H3a1 1 0 0 1-1-1v-4a1 1 0 0 1 1-1h2.172a2 2 0 0 1 1.414.586l1.56 1.56a1.207 1.207 0 0 1 0 1.708z',
    ), // key: 16mt4c
    ElIconPathElement(
      'M9 3a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2.172a2 2 0 0 1-.586 1.414l-1.56 1.56a1.207 1.207 0 0 1-1.708 0l-1.56-1.56A2 2 0 0 1 9 5.172z',
    ), // key: 19ox6c
  ]);

  /// `gamepad.mjs`
  static const ElLucideGlyph gamepad = ElLucideGlyph('gamepad', <ElIconElement>[
    ElIconLineElement(6, 12, 10, 12), // key: 161bw2
    ElIconLineElement(8, 10, 8, 14), // key: 1i6ji0
    ElIconLineElement(15, 13, 15.01, 13), // key: dqpgro
    ElIconLineElement(18, 11, 18.01, 11), // key: meh2c
    ElIconRectElement(2, 6, 20, 12, 2), // key: 9lu3g6
  ]);

  /// `gauge.mjs`
  static const ElLucideGlyph gauge = ElLucideGlyph('gauge', <ElIconElement>[
    ElIconPathElement('m12 14 4-4'), // key: 9kzdfg
    ElIconPathElement('M3.34 19a10 10 0 1 1 17.32 0'), // key: 19p75a
  ]);

  /// `gavel.mjs`
  static const ElLucideGlyph gavel = ElLucideGlyph('gavel', <ElIconElement>[
    ElIconPathElement(
      'm14 13-8.381 8.38a1 1 0 0 1-3.001-3l8.384-8.381',
    ), // key: pgg06f
    ElIconPathElement('m16 16 6-6'), // key: vzrcl6
    ElIconPathElement('m21.5 10.5-8-8'), // key: a17d9x
    ElIconPathElement('m8 8 6-6'), // key: 18bi4p
    ElIconPathElement('m8.5 7.5 8 8'), // key: 1oyaui
  ]);

  /// `gem.mjs`
  static const ElLucideGlyph gem = ElLucideGlyph('gem', <ElIconElement>[
    ElIconPathElement('M10.5 3 8 9l4 13 4-13-2.5-6'), // key: b3dvk1
    ElIconPathElement(
      'M17 3a2 2 0 0 1 1.6.8l3 4a2 2 0 0 1 .013 2.382l-7.99 10.986a2 2 0 0 1-3.247 0l-7.99-10.986A2 2 0 0 1 2.4 7.8l2.998-3.997A2 2 0 0 1 7 3z',
    ), // key: 7w4byz
    ElIconPathElement('M2 9h20'), // key: 16fsjt
  ]);

  /// `georgian-lari.mjs`
  static const ElLucideGlyph georgianLari = ElLucideGlyph(
    'georgian-lari',
    <ElIconElement>[
      ElIconPathElement('M11.5 21a7.5 7.5 0 1 1 7.35-9'), // key: 1gyj8k
      ElIconPathElement('M13 12V3'), // key: 18om2a
      ElIconPathElement('M4 21h16'), // key: 1h09gz
      ElIconPathElement('M9 12V3'), // key: geutu0
    ],
  );

  /// `ghost.mjs`
  static const ElLucideGlyph ghost = ElLucideGlyph('ghost', <ElIconElement>[
    ElIconPathElement('M9 10h.01'), // key: qbtxuw
    ElIconPathElement('M15 10h.01'), // key: 1qmjsl
    ElIconPathElement(
      'M12 2a8 8 0 0 0-8 8v12l3-3 2.5 2.5L12 19l2.5 2.5L17 19l3 3V10a8 8 0 0 0-8-8z',
    ), // key: uwwb07
  ]);

  /// `gift.mjs`
  static const ElLucideGlyph gift = ElLucideGlyph('gift', <ElIconElement>[
    ElIconPathElement('M12 7v14'), // key: 1akyts
    ElIconPathElement(
      'M20 11v8a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-8',
    ), // key: 1sqzm4
    ElIconPathElement(
      'M7.5 7a1 1 0 0 1 0-5A4.8 8 0 0 1 12 7a4.8 8 0 0 1 4.5-5 1 1 0 0 1 0 5',
    ), // key: kc0143
    ElIconRectElement(3, 7, 18, 4, 1), // key: 1hberx
  ]);

  /// `git-branch-minus.mjs`
  static const ElLucideGlyph gitBranchMinus = ElLucideGlyph(
    'git-branch-minus',
    <ElIconElement>[
      ElIconPathElement('M15 6a9 9 0 0 0-9 9V3'), // key: 1cii5b
      ElIconPathElement('M21 18h-6'), // key: 139f0c
      ElIconCircleElement(18, 6, 3), // key: 1h7g24
      ElIconCircleElement(6, 18, 3), // key: fqmcym
    ],
  );

  /// `git-branch-plus.mjs`
  static const ElLucideGlyph gitBranchPlus = ElLucideGlyph(
    'git-branch-plus',
    <ElIconElement>[
      ElIconPathElement('M6 3v12'), // key: qpgusn
      ElIconPathElement('M18 9a3 3 0 1 0 0-6 3 3 0 0 0 0 6z'), // key: 1d02ji
      ElIconPathElement('M6 21a3 3 0 1 0 0-6 3 3 0 0 0 0 6z'), // key: chk6ph
      ElIconPathElement('M15 6a9 9 0 0 0-9 9'), // key: or332x
      ElIconPathElement('M18 15v6'), // key: 9wciyi
      ElIconPathElement('M21 18h-6'), // key: 139f0c
    ],
  );

  /// `git-branch.mjs`
  static const ElLucideGlyph gitBranch = ElLucideGlyph(
    'git-branch',
    <ElIconElement>[
      ElIconPathElement('M15 6a9 9 0 0 0-9 9V3'), // key: 1cii5b
      ElIconCircleElement(18, 6, 3), // key: 1h7g24
      ElIconCircleElement(6, 18, 3), // key: fqmcym
    ],
  );

  /// `git-commit-horizontal.mjs`
  static const ElLucideGlyph gitCommitHorizontal = ElLucideGlyph(
    'git-commit-horizontal',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 3), // key: 1v7zrd
      ElIconLineElement(3, 12, 9, 12), // key: 1dyftd
      ElIconLineElement(15, 12, 21, 12), // key: oup4p8
    ],
  );

  /// `git-commit-vertical.mjs`
  static const ElLucideGlyph gitCommitVertical = ElLucideGlyph(
    'git-commit-vertical',
    <ElIconElement>[
      ElIconPathElement('M12 3v6'), // key: 1holv5
      ElIconCircleElement(12, 12, 3), // key: 1v7zrd
      ElIconPathElement('M12 15v6'), // key: a9ows0
    ],
  );

  /// `git-compare-arrows.mjs`
  static const ElLucideGlyph gitCompareArrows = ElLucideGlyph(
    'git-compare-arrows',
    <ElIconElement>[
      ElIconCircleElement(5, 6, 3), // key: 1qnov2
      ElIconPathElement('M12 6h5a2 2 0 0 1 2 2v7'), // key: 1yj91y
      ElIconPathElement('m15 9-3-3 3-3'), // key: 1lwv8l
      ElIconCircleElement(19, 18, 3), // key: 1qljk2
      ElIconPathElement('M12 18H7a2 2 0 0 1-2-2V9'), // key: 16sdep
      ElIconPathElement('m9 15 3 3-3 3'), // key: 1m3kbl
    ],
  );

  /// `git-compare.mjs`
  static const ElLucideGlyph gitCompare = ElLucideGlyph(
    'git-compare',
    <ElIconElement>[
      ElIconCircleElement(18, 18, 3), // key: 1xkwt0
      ElIconCircleElement(6, 6, 3), // key: 1lh9wr
      ElIconPathElement('M13 6h3a2 2 0 0 1 2 2v7'), // key: 1yeb86
      ElIconPathElement('M11 18H8a2 2 0 0 1-2-2V9'), // key: 19pyzm
    ],
  );

  /// `git-fork.mjs`
  static const ElLucideGlyph gitFork = ElLucideGlyph(
    'git-fork',
    <ElIconElement>[
      ElIconCircleElement(12, 18, 3), // key: 1mpf1b
      ElIconCircleElement(6, 6, 3), // key: 1lh9wr
      ElIconCircleElement(18, 6, 3), // key: 1h7g24
      ElIconPathElement(
        'M18 9v2c0 .6-.4 1-1 1H7c-.6 0-1-.4-1-1V9',
      ), // key: 1uq4wg
      ElIconPathElement('M12 12v3'), // key: 158kv8
    ],
  );

  /// `git-graph.mjs`
  static const ElLucideGlyph gitGraph = ElLucideGlyph(
    'git-graph',
    <ElIconElement>[
      ElIconCircleElement(5, 6, 3), // key: 1qnov2
      ElIconPathElement('M5 9v6'), // key: 158jrl
      ElIconCircleElement(5, 18, 3), // key: 104gr9
      ElIconPathElement('M12 3v18'), // key: 108xh3
      ElIconCircleElement(19, 6, 3), // key: 108a5v
      ElIconPathElement('M16 15.7A9 9 0 0 0 19 9'), // key: 1e3vqb
    ],
  );

  /// `git-merge-conflict.mjs`
  static const ElLucideGlyph gitMergeConflict = ElLucideGlyph(
    'git-merge-conflict',
    <ElIconElement>[
      ElIconPathElement('M12 6h4a2 2 0 0 1 2 2v7'), // key: 18ej7s
      ElIconPathElement('M6 12v9'), // key: 9e33v1
      ElIconPathElement('M9 3 3 9'), // key: ahyygn
      ElIconPathElement('M9 9 3 3'), // key: v551iv
      ElIconCircleElement(18, 18, 3), // key: 1xkwt0
    ],
  );

  /// `git-merge.mjs`
  static const ElLucideGlyph gitMerge = ElLucideGlyph(
    'git-merge',
    <ElIconElement>[
      ElIconCircleElement(18, 18, 3), // key: 1xkwt0
      ElIconCircleElement(6, 6, 3), // key: 1lh9wr
      ElIconPathElement('M6 21V9a9 9 0 0 0 9 9'), // key: 7kw0sc
    ],
  );

  /// `git-pull-request-arrow.mjs`
  static const ElLucideGlyph gitPullRequestArrow = ElLucideGlyph(
    'git-pull-request-arrow',
    <ElIconElement>[
      ElIconCircleElement(5, 6, 3), // key: 1qnov2
      ElIconPathElement('M5 9v12'), // key: ih889a
      ElIconCircleElement(19, 18, 3), // key: 1qljk2
      ElIconPathElement('m15 9-3-3 3-3'), // key: 1lwv8l
      ElIconPathElement('M12 6h5a2 2 0 0 1 2 2v7'), // key: 1yj91y
    ],
  );

  /// `git-pull-request-closed.mjs`
  static const ElLucideGlyph gitPullRequestClosed = ElLucideGlyph(
    'git-pull-request-closed',
    <ElIconElement>[
      ElIconCircleElement(6, 6, 3), // key: 1lh9wr
      ElIconPathElement('M6 9v12'), // key: 1sc30k
      ElIconPathElement('m21 3-6 6'), // key: 16nqsk
      ElIconPathElement('m21 9-6-6'), // key: 9j17rh
      ElIconPathElement('M18 11.5V15'), // key: 65xf6f
      ElIconCircleElement(18, 18, 3), // key: 1xkwt0
    ],
  );

  /// `git-pull-request-create-arrow.mjs`
  static const ElLucideGlyph gitPullRequestCreateArrow = ElLucideGlyph(
    'git-pull-request-create-arrow',
    <ElIconElement>[
      ElIconCircleElement(5, 6, 3), // key: 1qnov2
      ElIconPathElement('M5 9v12'), // key: ih889a
      ElIconPathElement('m15 9-3-3 3-3'), // key: 1lwv8l
      ElIconPathElement('M12 6h5a2 2 0 0 1 2 2v3'), // key: 1rbwk6
      ElIconPathElement('M19 15v6'), // key: 10aioa
      ElIconPathElement('M22 18h-6'), // key: 1d5gi5
    ],
  );

  /// `git-pull-request-create.mjs`
  static const ElLucideGlyph gitPullRequestCreate = ElLucideGlyph(
    'git-pull-request-create',
    <ElIconElement>[
      ElIconCircleElement(6, 6, 3), // key: 1lh9wr
      ElIconPathElement('M6 9v12'), // key: 1sc30k
      ElIconPathElement('M13 6h3a2 2 0 0 1 2 2v3'), // key: 1jb6z3
      ElIconPathElement('M18 15v6'), // key: 9wciyi
      ElIconPathElement('M21 18h-6'), // key: 139f0c
    ],
  );

  /// `git-pull-request-draft.mjs`
  static const ElLucideGlyph gitPullRequestDraft = ElLucideGlyph(
    'git-pull-request-draft',
    <ElIconElement>[
      ElIconCircleElement(18, 18, 3), // key: 1xkwt0
      ElIconCircleElement(6, 6, 3), // key: 1lh9wr
      ElIconPathElement('M18 6V5'), // key: 1oao2s
      ElIconPathElement('M18 11v-1'), // key: 11c8tz
      ElIconLineElement(6, 9, 6, 21), // key: rroup
    ],
  );

  /// `git-pull-request.mjs`
  static const ElLucideGlyph gitPullRequest = ElLucideGlyph(
    'git-pull-request',
    <ElIconElement>[
      ElIconCircleElement(18, 18, 3), // key: 1xkwt0
      ElIconCircleElement(6, 6, 3), // key: 1lh9wr
      ElIconPathElement('M13 6h3a2 2 0 0 1 2 2v7'), // key: 1yeb86
      ElIconLineElement(6, 9, 6, 21), // key: rroup
    ],
  );

  /// `glass-water.mjs`
  static const ElLucideGlyph
  glassWater = ElLucideGlyph('glass-water', <ElIconElement>[
    ElIconPathElement(
      'M5.116 4.104A1 1 0 0 1 6.11 3h11.78a1 1 0 0 1 .994 1.105L17.19 20.21A2 2 0 0 1 15.2 22H8.8a2 2 0 0 1-2-1.79z',
    ), // key: p55z4y
    ElIconPathElement('M6 12a5 5 0 0 1 6 0 5 5 0 0 0 6 0'), // key: mjntcy
  ]);

  /// `glasses.mjs`
  static const ElLucideGlyph glasses = ElLucideGlyph('glasses', <ElIconElement>[
    ElIconCircleElement(6, 15, 4), // key: vux9w4
    ElIconCircleElement(18, 15, 4), // key: 18o8ve
    ElIconPathElement('M14 15a2 2 0 0 0-2-2 2 2 0 0 0-2 2'), // key: 1ag4bs
    ElIconPathElement('M2.5 13 5 7c.7-1.3 1.4-2 3-2'), // key: 1hm1gs
    ElIconPathElement('M21.5 13 19 7c-.7-1.3-1.5-2-3-2'), // key: 1r31ai
  ]);

  /// `globe-check.mjs`
  static const ElLucideGlyph globeCheck = ElLucideGlyph(
    'globe-check',
    <ElIconElement>[
      ElIconPathElement('m15 6 2 2 4-4'), // key: levio8
      ElIconPathElement(
        'M2 12h20A10 10 0 1 1 12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 4-10',
      ), // key: 46evmv
    ],
  );

  /// `globe-lock.mjs`
  static const ElLucideGlyph
  globeLock = ElLucideGlyph('globe-lock', <ElIconElement>[
    ElIconPathElement(
      'M15.686 15A14.5 14.5 0 0 1 12 22a14.5 14.5 0 0 1 0-20 10 10 0 1 0 9.542 13',
    ), // key: qkt0x6
    ElIconPathElement('M2 12h8.5'), // key: ovaggd
    ElIconPathElement('M20 6V4a2 2 0 1 0-4 0v2'), // key: 1of5e8
    ElIconRectElement(14, 6, 8, 5, 1), // key: 1fmf51
  ]);

  /// `globe-off.mjs`
  static const ElLucideGlyph globeOff = ElLucideGlyph(
    'globe-off',
    <ElIconElement>[
      ElIconPathElement(
        'M10.114 4.462A14.5 14.5 0 0 1 12 2a10 10 0 0 1 9.313 13.643',
      ), // key: 1jq2r7
      ElIconPathElement(
        'M15.557 15.556A14.5 14.5 0 0 1 12 22 10 10 0 0 1 4.929 4.929',
      ), // key: 1ohfya
      ElIconPathElement(
        'M15.892 10.234A14.5 14.5 0 0 0 12 2a10 10 0 0 0-3.643.687',
      ), // key: 1fyh9w
      ElIconPathElement('M17.656 12H22'), // key: 1ttse4
      ElIconPathElement(
        'M19.071 19.071A10 10 0 0 1 12 22 14.5 14.5 0 0 1 8.44 8.45',
      ), // key: rmtjzo
      ElIconPathElement('M2 12h10'), // key: 19562f
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ],
  );

  /// `globe-x.mjs`
  static const ElLucideGlyph globeX = ElLucideGlyph('globe-x', <ElIconElement>[
    ElIconPathElement('m16 3 5 5'), // key: 1husv6
    ElIconPathElement(
      'M2 12h20A10 10 0 1 1 12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 4-10',
    ), // key: 46evmv
    ElIconPathElement('m21 3-5 5'), // key: 1g5oa7
  ]);

  /// `globe.mjs`
  static const ElLucideGlyph globe = ElLucideGlyph('globe', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement(
      'M12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 0-20',
    ), // key: 13o1zl
    ElIconPathElement('M2 12h20'), // key: 9i4pu4
  ]);

  /// `goal.mjs`
  static const ElLucideGlyph goal = ElLucideGlyph('goal', <ElIconElement>[
    ElIconPathElement('M12 13V2l8 4-8 4'), // key: 5wlwwj
    ElIconPathElement('M20.561 10.222a9 9 0 1 1-12.55-5.29'), // key: 1c0wjv
    ElIconPathElement('M8.002 9.997a5 5 0 1 0 8.9 2.02'), // key: gb1g7m
  ]);

  /// `gpu.mjs`
  static const ElLucideGlyph gpu = ElLucideGlyph('gpu', <ElIconElement>[
    ElIconPathElement(
      'M2 17h18a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2H2',
    ), // key: hpo31w
    ElIconPathElement('M2 21V3'), // key: 1bzk4w
    ElIconPathElement(
      'M7 17v3a1 1 0 0 0 1 1h5a1 1 0 0 0 1-1v-3',
    ), // key: 5hbqbf
    ElIconCircleElement(16, 11, 2), // key: qt15rb
    ElIconCircleElement(8, 11, 2), // key: ssideg
  ]);

  /// `graduation-cap.mjs`
  static const ElLucideGlyph
  graduationCap = ElLucideGlyph('graduation-cap', <ElIconElement>[
    ElIconPathElement(
      'M21.42 10.922a1 1 0 0 0-.019-1.838L12.83 5.18a2 2 0 0 0-1.66 0L2.6 9.08a1 1 0 0 0 0 1.832l8.57 3.908a2 2 0 0 0 1.66 0z',
    ), // key: j76jl0
    ElIconPathElement('M22 10v6'), // key: 1lu8f3
    ElIconPathElement('M6 12.5V16a6 3 0 0 0 12 0v-3.5'), // key: 1r8lef
  ]);

  /// `grape.mjs`
  static const ElLucideGlyph grape = ElLucideGlyph('grape', <ElIconElement>[
    ElIconPathElement('M22 5V2l-5.89 5.89'), // key: 1eenpo
    ElIconCircleElement(16.6, 15.89, 3), // key: xjtalx
    ElIconCircleElement(8.11, 7.4, 3), // key: u2fv6i
    ElIconCircleElement(12.35, 11.65, 3), // key: i6i8g7
    ElIconCircleElement(13.91, 5.85, 3), // key: 6ye0dv
    ElIconCircleElement(18.15, 10.09, 3), // key: snx9no
    ElIconCircleElement(6.56, 13.2, 3), // key: 17x4xg
    ElIconCircleElement(10.8, 17.44, 3), // key: 1hogw9
    ElIconCircleElement(5, 19, 3), // key: 1sn6vo
  ]);

  /// `grid-2x2-check.mjs`
  static const ElLucideGlyph
  grid2x2Check = ElLucideGlyph('grid-2x2-check', <ElIconElement>[
    ElIconPathElement(
      'M12 3v17a1 1 0 0 1-1 1H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v6a1 1 0 0 1-1 1H3',
    ), // key: 11za1p
    ElIconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
  ]);

  /// `grid-2x2-plus.mjs`
  static const ElLucideGlyph
  grid2x2Plus = ElLucideGlyph('grid-2x2-plus', <ElIconElement>[
    ElIconPathElement(
      'M12 3v17a1 1 0 0 1-1 1H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v6a1 1 0 0 1-1 1H3',
    ), // key: 11za1p
    ElIconPathElement('M16 19h6'), // key: xwg31i
    ElIconPathElement('M19 22v-6'), // key: qhmiwi
  ]);

  /// `grid-2x2-x.mjs`
  static const ElLucideGlyph
  grid2x2X = ElLucideGlyph('grid-2x2-x', <ElIconElement>[
    ElIconPathElement(
      'M12 3v17a1 1 0 0 1-1 1H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v6a1 1 0 0 1-1 1H3',
    ), // key: 11za1p
    ElIconPathElement('m16 16 5 5'), // key: 8tpb07
    ElIconPathElement('m16 21 5-5'), // key: 193jll
  ]);

  /// `grid-2x2.mjs`
  static const ElLucideGlyph grid2x2 = ElLucideGlyph(
    'grid-2x2',
    <ElIconElement>[
      ElIconPathElement('M12 3v18'), // key: 108xh3
      ElIconPathElement('M3 12h18'), // key: 1i2n21
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `grid-3x2.mjs`
  static const ElLucideGlyph grid3x2 = ElLucideGlyph(
    'grid-3x2',
    <ElIconElement>[
      ElIconPathElement('M15 3v18'), // key: 14nvp0
      ElIconPathElement('M3 12h18'), // key: 1i2n21
      ElIconPathElement('M9 3v18'), // key: fh3hqa
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `grid-3x3.mjs`
  static const ElLucideGlyph grid3x3 = ElLucideGlyph(
    'grid-3x3',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('M3 15h18'), // key: 5xshup
      ElIconPathElement('M9 3v18'), // key: fh3hqa
      ElIconPathElement('M15 3v18'), // key: 14nvp0
    ],
  );

  /// `grip-horizontal.mjs`
  static const ElLucideGlyph gripHorizontal = ElLucideGlyph(
    'grip-horizontal',
    <ElIconElement>[
      ElIconCircleElement(12, 9, 1), // key: 124mty
      ElIconCircleElement(19, 9, 1), // key: 1ruzo2
      ElIconCircleElement(5, 9, 1), // key: 1a8b28
      ElIconCircleElement(12, 15, 1), // key: 1e56xg
      ElIconCircleElement(19, 15, 1), // key: 1a92ep
      ElIconCircleElement(5, 15, 1), // key: 5r1jwy
    ],
  );

  /// `grip-vertical.mjs`
  static const ElLucideGlyph gripVertical = ElLucideGlyph(
    'grip-vertical',
    <ElIconElement>[
      ElIconCircleElement(9, 12, 1), // key: 1vctgf
      ElIconCircleElement(9, 5, 1), // key: hp0tcf
      ElIconCircleElement(9, 19, 1), // key: fkjjf6
      ElIconCircleElement(15, 12, 1), // key: 1tmaij
      ElIconCircleElement(15, 5, 1), // key: 19l28e
      ElIconCircleElement(15, 19, 1), // key: f4zoj3
    ],
  );

  /// `grip.mjs`
  static const ElLucideGlyph grip = ElLucideGlyph('grip', <ElIconElement>[
    ElIconCircleElement(12, 5, 1), // key: gxeob9
    ElIconCircleElement(19, 5, 1), // key: w8mnmm
    ElIconCircleElement(5, 5, 1), // key: lttvr7
    ElIconCircleElement(12, 12, 1), // key: 41hilf
    ElIconCircleElement(19, 12, 1), // key: 1wjl8i
    ElIconCircleElement(5, 12, 1), // key: 1pcz8c
    ElIconCircleElement(12, 19, 1), // key: lyex9k
    ElIconCircleElement(19, 19, 1), // key: shf9b7
    ElIconCircleElement(5, 19, 1), // key: bfqh0e
  ]);

  /// `group.mjs`
  static const ElLucideGlyph group = ElLucideGlyph('group', <ElIconElement>[
    ElIconPathElement('M3 7V5c0-1.1.9-2 2-2h2'), // key: adw53z
    ElIconPathElement('M17 3h2c1.1 0 2 .9 2 2v2'), // key: an4l38
    ElIconPathElement('M21 17v2c0 1.1-.9 2-2 2h-2'), // key: 144t0e
    ElIconPathElement('M7 21H5c-1.1 0-2-.9-2-2v-2'), // key: rtnfgi
    ElIconRectElement(7, 7, 7, 5, 1), // key: 1eyiv7
    ElIconRectElement(10, 12, 7, 5, 1), // key: 1qlmkx
  ]);

  /// `guitar.mjs`
  static const ElLucideGlyph guitar = ElLucideGlyph('guitar', <ElIconElement>[
    ElIconPathElement('m11.9 12.1 4.514-4.514'), // key: 109xqo
    ElIconPathElement(
      'M20.1 2.3a1 1 0 0 0-1.4 0l-1.114 1.114A2 2 0 0 0 17 4.828v1.344a2 2 0 0 1-.586 1.414A2 2 0 0 1 17.828 7h1.344a2 2 0 0 0 1.414-.586L21.7 5.3a1 1 0 0 0 0-1.4z',
    ), // key: txyc8t
    ElIconPathElement('m6 16 2 2'), // key: 16qmzd
    ElIconPathElement(
      'M8.23 9.85A3 3 0 0 1 11 8a5 5 0 0 1 5 5 3 3 0 0 1-1.85 2.77l-.92.38A2 2 0 0 0 12 18a4 4 0 0 1-4 4 6 6 0 0 1-6-6 4 4 0 0 1 4-4 2 2 0 0 0 1.85-1.23z',
    ), // key: 1de1vg
  ]);

  /// `ham.mjs`
  static const ElLucideGlyph ham = ElLucideGlyph('ham', <ElIconElement>[
    ElIconPathElement(
      'M13.144 21.144A7.274 10.445 45 1 0 2.856 10.856',
    ), // key: 1k1t7q
    ElIconPathElement(
      'M13.144 21.144A7.274 4.365 45 0 0 2.856 10.856a7.274 4.365 45 0 0 10.288 10.288',
    ), // key: 153t1g
    ElIconPathElement(
      'M16.565 10.435 18.6 8.4a2.501 2.501 0 1 0 1.65-4.65 2.5 2.5 0 1 0-4.66 1.66l-2.024 2.025',
    ), // key: gzrt0n
    ElIconPathElement('m8.5 16.5-1-1'), // key: otr954
  ]);

  /// `hamburger.mjs`
  static const ElLucideGlyph
  hamburger = ElLucideGlyph('hamburger', <ElIconElement>[
    ElIconPathElement(
      'M12 16H4a2 2 0 1 1 0-4h16a2 2 0 1 1 0 4h-4.25',
    ), // key: 5dloqd
    ElIconPathElement(
      'M5 12a2 2 0 0 1-2-2 9 7 0 0 1 18 0 2 2 0 0 1-2 2',
    ), // key: 1vl3my
    ElIconPathElement(
      'M5 16a2 2 0 0 0-2 2 3 3 0 0 0 3 3h12a3 3 0 0 0 3-3 2 2 0 0 0-2-2q0 0 0 0',
    ), // key: 1us75o
    ElIconPathElement(
      'm6.67 12 6.13 4.6a2 2 0 0 0 2.8-.4l3.15-4.2',
    ), // key: qqzweh
  ]);

  /// `hammer.mjs`
  static const ElLucideGlyph hammer = ElLucideGlyph('hammer', <ElIconElement>[
    ElIconPathElement(
      'm15 12-9.373 9.373a1 1 0 0 1-3.001-3L12 9',
    ), // key: 1hayfq
    ElIconPathElement('m18 15 4-4'), // key: 16gjal
    ElIconPathElement(
      'm21.5 11.5-1.914-1.914A2 2 0 0 1 19 8.172v-.344a2 2 0 0 0-.586-1.414l-1.657-1.657A6 6 0 0 0 12.516 3H9l1.243 1.243A6 6 0 0 1 12 8.485V10l2 2h1.172a2 2 0 0 1 1.414.586L18.5 14.5',
    ), // key: 15ts47
  ]);

  /// `hand-coins.mjs`
  static const ElLucideGlyph
  handCoins = ElLucideGlyph('hand-coins', <ElIconElement>[
    ElIconPathElement(
      'M11 15h2a2 2 0 1 0 0-4h-3c-.6 0-1.1.2-1.4.6L3 17',
    ), // key: geh8rc
    ElIconPathElement(
      'm7 21 1.6-1.4c.3-.4.8-.6 1.4-.6h4c1.1 0 2.1-.4 2.8-1.2l4.6-4.4a2 2 0 0 0-2.75-2.91l-4.2 3.9',
    ), // key: 1fto5m
    ElIconPathElement('m2 16 6 6'), // key: 1pfhp9
    ElIconCircleElement(16, 9, 2.9), // key: 1n0dlu
    ElIconCircleElement(6, 5, 3), // key: 151irh
  ]);

  /// `hand-fist.mjs`
  static const ElLucideGlyph
  handFist = ElLucideGlyph('hand-fist', <ElIconElement>[
    ElIconPathElement(
      'M12.035 17.012a3 3 0 0 0-3-3l-.311-.002a.72.72 0 0 1-.505-1.229l1.195-1.195A2 2 0 0 1 10.828 11H12a2 2 0 0 0 0-4H9.243a3 3 0 0 0-2.122.879l-2.707 2.707A4.83 4.83 0 0 0 3 14a8 8 0 0 0 8 8h2a8 8 0 0 0 8-8V7a2 2 0 1 0-4 0v2a2 2 0 1 0 4 0',
    ), // key: 1ff7rl
    ElIconPathElement(
      'M13.888 9.662A2 2 0 0 0 17 8V5A2 2 0 1 0 13 5',
    ), // key: 1xmd21
    ElIconPathElement('M9 5A2 2 0 1 0 5 5V10'), // key: f3wfjw
    ElIconPathElement('M9 7V4A2 2 0 1 1 13 4V7.268'), // key: eaoucv
  ]);

  /// `hand-grab.mjs`
  static const ElLucideGlyph
  handGrab = ElLucideGlyph('hand-grab', <ElIconElement>[
    ElIconPathElement(
      'M18 11.5V9a2 2 0 0 0-2-2a2 2 0 0 0-2 2v1.4',
    ), // key: edstyy
    ElIconPathElement('M14 10V8a2 2 0 0 0-2-2a2 2 0 0 0-2 2v2'), // key: 19wdwo
    ElIconPathElement('M10 9.9V9a2 2 0 0 0-2-2a2 2 0 0 0-2 2v5'), // key: 1lugqo
    ElIconPathElement('M6 14a2 2 0 0 0-2-2a2 2 0 0 0-2 2'), // key: 1hbeus
    ElIconPathElement(
      'M18 11a2 2 0 1 1 4 0v3a8 8 0 0 1-8 8h-4a8 8 0 0 1-8-8 2 2 0 1 1 4 0',
    ), // key: 1etffm
  ]);

  /// `hand-heart.mjs`
  static const ElLucideGlyph
  handHeart = ElLucideGlyph('hand-heart', <ElIconElement>[
    ElIconPathElement(
      'M11 14h2a2 2 0 0 0 0-4h-3c-.6 0-1.1.2-1.4.6L3 16',
    ), // key: 1v1a37
    ElIconPathElement(
      'm14.45 13.39 5.05-4.694C20.196 8 21 6.85 21 5.75a2.75 2.75 0 0 0-4.797-1.837.276.276 0 0 1-.406 0A2.75 2.75 0 0 0 11 5.75c0 1.2.802 2.248 1.5 2.946L16 11.95',
    ), // key: fhfbnt
    ElIconPathElement('m2 15 6 6'), // key: 10dquu
    ElIconPathElement(
      'm7 20 1.6-1.4c.3-.4.8-.6 1.4-.6h4c1.1 0 2.1-.4 2.8-1.2l4.6-4.4a1 1 0 0 0-2.75-2.91',
    ), // key: 1x6kdw
  ]);

  /// `hand-helping.mjs`
  static const ElLucideGlyph
  handHelping = ElLucideGlyph('hand-helping', <ElIconElement>[
    ElIconPathElement(
      'M11 12h2a2 2 0 1 0 0-4h-3c-.6 0-1.1.2-1.4.6L3 14',
    ), // key: 1j4xps
    ElIconPathElement(
      'm7 18 1.6-1.4c.3-.4.8-.6 1.4-.6h4c1.1 0 2.1-.4 2.8-1.2l4.6-4.4a2 2 0 0 0-2.75-2.91l-4.2 3.9',
    ), // key: uospg8
    ElIconPathElement('m2 13 6 6'), // key: 16e5sb
  ]);

  /// `hand-metal.mjs`
  static const ElLucideGlyph
  handMetal = ElLucideGlyph('hand-metal', <ElIconElement>[
    ElIconPathElement(
      'M18 12.5V10a2 2 0 0 0-2-2a2 2 0 0 0-2 2v1.4',
    ), // key: wc6myp
    ElIconPathElement('M14 11V9a2 2 0 1 0-4 0v2'), // key: 94qvcw
    ElIconPathElement('M10 10.5V5a2 2 0 1 0-4 0v9'), // key: m1ah89
    ElIconPathElement(
      'm7 15-1.76-1.76a2 2 0 0 0-2.83 2.82l3.6 3.6C7.5 21.14 9.2 22 12 22h2a8 8 0 0 0 8-8V7a2 2 0 1 0-4 0v5',
    ), // key: t1skq1
  ]);

  /// `hand-platter.mjs`
  static const ElLucideGlyph
  handPlatter = ElLucideGlyph('hand-platter', <ElIconElement>[
    ElIconPathElement('M12 3V2'), // key: ar7q03
    ElIconPathElement(
      'm15.4 17.4 3.2-2.8a2 2 0 1 1 2.8 2.9l-3.6 3.3c-.7.8-1.7 1.2-2.8 1.2h-4c-1.1 0-2.1-.4-2.8-1.2l-1.302-1.464A1 1 0 0 0 6.151 19H5',
    ), // key: n2g93r
    ElIconPathElement('M2 14h12a2 2 0 0 1 0 4h-2'), // key: 1o2jem
    ElIconPathElement('M4 10h16'), // key: img6z1
    ElIconPathElement('M5 10a7 7 0 0 1 14 0'), // key: 1ega1o
    ElIconPathElement('M5 14v6a1 1 0 0 1-1 1H2'), // key: 1hescx
  ]);

  /// `hand.mjs`
  static const ElLucideGlyph hand = ElLucideGlyph('hand', <ElIconElement>[
    ElIconPathElement('M18 11V6a2 2 0 0 0-2-2a2 2 0 0 0-2 2'), // key: 1fvzgz
    ElIconPathElement('M14 10V4a2 2 0 0 0-2-2a2 2 0 0 0-2 2v2'), // key: 1kc0my
    ElIconPathElement(
      'M10 10.5V6a2 2 0 0 0-2-2a2 2 0 0 0-2 2v8',
    ), // key: 10h0bg
    ElIconPathElement(
      'M18 8a2 2 0 1 1 4 0v6a8 8 0 0 1-8 8h-2c-2.8 0-4.5-.86-5.99-2.34l-3.6-3.6a2 2 0 0 1 2.83-2.82L7 15',
    ), // key: 1s1gnw
  ]);

  /// `handbag.mjs`
  static const ElLucideGlyph handbag = ElLucideGlyph('handbag', <ElIconElement>[
    ElIconPathElement(
      'M2.048 18.566A2 2 0 0 0 4 21h16a2 2 0 0 0 1.952-2.434l-2-9A2 2 0 0 0 18 8H6a2 2 0 0 0-1.952 1.566z',
    ), // key: 1qbui5
    ElIconPathElement('M8 11V6a4 4 0 0 1 8 0v5'), // key: tcht90
  ]);

  /// `handshake.mjs`
  static const ElLucideGlyph
  handshake = ElLucideGlyph('handshake', <ElIconElement>[
    ElIconPathElement('m11 17 2 2a1 1 0 1 0 3-3'), // key: efffak
    ElIconPathElement(
      'm14 14 2.5 2.5a1 1 0 1 0 3-3l-3.88-3.88a3 3 0 0 0-4.24 0l-.88.88a1 1 0 1 1-3-3l2.81-2.81a5.79 5.79 0 0 1 7.06-.87l.47.28a2 2 0 0 0 1.42.25L21 4',
    ), // key: 9pr0kb
    ElIconPathElement('m21 3 1 11h-2'), // key: 1tisrp
    ElIconPathElement('M3 3 2 14l6.5 6.5a1 1 0 1 0 3-3'), // key: 1uvwmv
    ElIconPathElement('M3 4h8'), // key: 1ep09j
  ]);

  /// `hard-drive-download.mjs`
  static const ElLucideGlyph hardDriveDownload = ElLucideGlyph(
    'hard-drive-download',
    <ElIconElement>[
      ElIconPathElement('M12 2v8'), // key: 1q4o3n
      ElIconPathElement('m16 6-4 4-4-4'), // key: 6wukr
      ElIconRectElement(2, 14, 20, 8, 2), // key: w68u3i
      ElIconPathElement('M6 18h.01'), // key: uhywen
      ElIconPathElement('M10 18h.01'), // key: h775k
    ],
  );

  /// `hard-drive-upload.mjs`
  static const ElLucideGlyph hardDriveUpload = ElLucideGlyph(
    'hard-drive-upload',
    <ElIconElement>[
      ElIconPathElement('m16 6-4-4-4 4'), // key: 13yo43
      ElIconPathElement('M12 2v8'), // key: 1q4o3n
      ElIconRectElement(2, 14, 20, 8, 2), // key: w68u3i
      ElIconPathElement('M6 18h.01'), // key: uhywen
      ElIconPathElement('M10 18h.01'), // key: h775k
    ],
  );

  /// `hard-drive.mjs`
  static const ElLucideGlyph
  hardDrive = ElLucideGlyph('hard-drive', <ElIconElement>[
    ElIconPathElement('M10 16h.01'), // key: 1bzywj
    ElIconPathElement(
      'M2.212 11.577a2 2 0 0 0-.212.896V18a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-5.527a2 2 0 0 0-.212-.896L18.55 5.11A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z',
    ), // key: 18tbho
    ElIconPathElement('M21.946 12.013H2.054'), // key: zqlbp7
    ElIconPathElement('M6 16h.01'), // key: 1pmjb7
  ]);

  /// `hard-hat.mjs`
  static const ElLucideGlyph hardHat = ElLucideGlyph(
    'hard-hat',
    <ElIconElement>[
      ElIconPathElement(
        'M10 10V5a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v5',
      ), // key: 1p9q5i
      ElIconPathElement('M14 6a6 6 0 0 1 6 6v3'), // key: 1hnv84
      ElIconPathElement('M4 15v-3a6 6 0 0 1 6-6'), // key: 9ciidu
      ElIconRectElement(2, 15, 20, 4, 1), // key: g3x8cw
    ],
  );

  /// `hash.mjs`
  static const ElLucideGlyph hash = ElLucideGlyph('hash', <ElIconElement>[
    ElIconLineElement(4, 9, 20, 9), // key: 4lhtct
    ElIconLineElement(4, 15, 20, 15), // key: vyu0kd
    ElIconLineElement(10, 3, 8, 21), // key: 1ggp8o
    ElIconLineElement(16, 3, 14, 21), // key: weycgp
  ]);

  /// `hat-glasses.mjs`
  static const ElLucideGlyph
  hatGlasses = ElLucideGlyph('hat-glasses', <ElIconElement>[
    ElIconPathElement('M14 18a2 2 0 0 0-4 0'), // key: 1v8fkw
    ElIconPathElement(
      'm19 11-2.11-6.657a2 2 0 0 0-2.752-1.148l-1.276.61A2 2 0 0 1 12 4H8.5a2 2 0 0 0-1.925 1.456L5 11',
    ), // key: 1fkr7p
    ElIconPathElement('M2 11h20'), // key: 3eubbj
    ElIconCircleElement(17, 18, 3), // key: 82mm0e
    ElIconCircleElement(7, 18, 3), // key: lvkj7j
  ]);

  /// `haze.mjs`
  static const ElLucideGlyph haze = ElLucideGlyph('haze', <ElIconElement>[
    ElIconPathElement('m5.2 6.2 1.4 1.4'), // key: 17imol
    ElIconPathElement('M2 13h2'), // key: 13gyu8
    ElIconPathElement('M20 13h2'), // key: 16rner
    ElIconPathElement('m17.4 7.6 1.4-1.4'), // key: t4xlah
    ElIconPathElement('M22 17H2'), // key: 1gtaj3
    ElIconPathElement('M22 21H2'), // key: 1gy6en
    ElIconPathElement('M16 13a4 4 0 0 0-8 0'), // key: 1dyczq
    ElIconPathElement('M12 5V2.5'), // key: 1vytko
  ]);

  /// `hd.mjs`
  static const ElLucideGlyph hd = ElLucideGlyph('hd', <ElIconElement>[
    ElIconPathElement('M10 12H6'), // key: 15f2ro
    ElIconPathElement('M10 15V9'), // key: 1lckn7
    ElIconPathElement(
      'M14 14.5a.5.5 0 0 0 .5.5h1a2.5 2.5 0 0 0 2.5-2.5v-1A2.5 2.5 0 0 0 15.5 9h-1a.5.5 0 0 0-.5.5z',
    ), // key: b3f847
    ElIconPathElement('M6 15V9'), // key: 12stmj
    ElIconRectElement(2, 5, 20, 14, 2), // key: qneu4z
  ]);

  /// `hdmi-port.mjs`
  static const ElLucideGlyph
  hdmiPort = ElLucideGlyph('hdmi-port', <ElIconElement>[
    ElIconPathElement(
      'M22 9a1 1 0 00-1-1H3a1 1 0 00-1 1v4a1 1 0 001 1h.5a2 2 0 011.6.8l.3.4A2 2 0 007 16h10a2 2 0 001.6-.8l.3-.4a2 2 0 011.6-.8h.5a1 1 0 001-1z',
    ), // key: 1kwg9h
    ElIconPathElement('M8 12h8'), // key: 1wcyev
  ]);

  /// `heading-1.mjs`
  static const ElLucideGlyph heading1 = ElLucideGlyph(
    'heading-1',
    <ElIconElement>[
      ElIconPathElement('M4 12h8'), // key: 17cfdx
      ElIconPathElement('M4 18V6'), // key: 1rz3zl
      ElIconPathElement('M12 18V6'), // key: zqpxq5
      ElIconPathElement('m17 12 3-2v8'), // key: 1hhhft
    ],
  );

  /// `heading-2.mjs`
  static const ElLucideGlyph heading2 = ElLucideGlyph(
    'heading-2',
    <ElIconElement>[
      ElIconPathElement('M4 12h8'), // key: 17cfdx
      ElIconPathElement('M4 18V6'), // key: 1rz3zl
      ElIconPathElement('M12 18V6'), // key: zqpxq5
      ElIconPathElement('M21 18h-4c0-4 4-3 4-6 0-1.5-2-2.5-4-1'), // key: 9jr5yi
    ],
  );

  /// `heading-3.mjs`
  static const ElLucideGlyph
  heading3 = ElLucideGlyph('heading-3', <ElIconElement>[
    ElIconPathElement('M4 12h8'), // key: 17cfdx
    ElIconPathElement('M4 18V6'), // key: 1rz3zl
    ElIconPathElement('M12 18V6'), // key: zqpxq5
    ElIconPathElement(
      'M17.5 10.5c1.7-1 3.5 0 3.5 1.5a2 2 0 0 1-2 2',
    ), // key: 68ncm8
    ElIconPathElement('M17 17.5c2 1.5 4 .3 4-1.5a2 2 0 0 0-2-2'), // key: 1ejuhz
  ]);

  /// `heading-4.mjs`
  static const ElLucideGlyph heading4 = ElLucideGlyph(
    'heading-4',
    <ElIconElement>[
      ElIconPathElement('M12 18V6'), // key: zqpxq5
      ElIconPathElement('M17 10v3a1 1 0 0 0 1 1h3'), // key: tj5zdr
      ElIconPathElement('M21 10v8'), // key: 1kdml4
      ElIconPathElement('M4 12h8'), // key: 17cfdx
      ElIconPathElement('M4 18V6'), // key: 1rz3zl
    ],
  );

  /// `heading-5.mjs`
  static const ElLucideGlyph heading5 = ElLucideGlyph(
    'heading-5',
    <ElIconElement>[
      ElIconPathElement('M4 12h8'), // key: 17cfdx
      ElIconPathElement('M4 18V6'), // key: 1rz3zl
      ElIconPathElement('M12 18V6'), // key: zqpxq5
      ElIconPathElement('M17 13v-3h4'), // key: 1nvgqp
      ElIconPathElement(
        'M17 17.7c.4.2.8.3 1.3.3 1.5 0 2.7-1.1 2.7-2.5S19.8 13 18.3 13H17',
      ), // key: 2nebdn
    ],
  );

  /// `heading-6.mjs`
  static const ElLucideGlyph heading6 = ElLucideGlyph(
    'heading-6',
    <ElIconElement>[
      ElIconPathElement('M4 12h8'), // key: 17cfdx
      ElIconPathElement('M4 18V6'), // key: 1rz3zl
      ElIconPathElement('M12 18V6'), // key: zqpxq5
      ElIconCircleElement(19, 16, 2), // key: 15mx69
      ElIconPathElement('M20 10c-2 2-3 3.5-3 6'), // key: f35dl0
    ],
  );

  /// `heading.mjs`
  static const ElLucideGlyph heading = ElLucideGlyph('heading', <ElIconElement>[
    ElIconPathElement('M6 12h12'), // key: 8npq4p
    ElIconPathElement('M6 20V4'), // key: 1w1bmo
    ElIconPathElement('M18 20V4'), // key: o2hl4u
  ]);

  /// `headphone-off.mjs`
  static const ElLucideGlyph
  headphoneOff = ElLucideGlyph('headphone-off', <ElIconElement>[
    ElIconPathElement('M21 14h-1.343'), // key: 1jdnxi
    ElIconPathElement('M9.128 3.47A9 9 0 0 1 21 12v3.343'), // key: 6kipu2
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement(
      'M20.414 20.414A2 2 0 0 1 19 21h-1a2 2 0 0 1-2-2v-3',
    ), // key: 9x50f4
    ElIconPathElement(
      'M3 14h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-7a9 9 0 0 1 2.636-6.364',
    ), // key: 1bkxnm
  ]);

  /// `headphones.mjs`
  static const ElLucideGlyph
  headphones = ElLucideGlyph('headphones', <ElIconElement>[
    ElIconPathElement(
      'M3 14h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-7a9 9 0 0 1 18 0v7a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3',
    ), // key: 1xhozi
  ]);

  /// `headset.mjs`
  static const ElLucideGlyph headset = ElLucideGlyph('headset', <ElIconElement>[
    ElIconPathElement(
      'M3 11h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-5Zm0 0a9 9 0 1 1 18 0m0 0v5a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3Z',
    ), // key: 12oyoe
    ElIconPathElement('M21 16v2a4 4 0 0 1-4 4h-5'), // key: 1x7m43
  ]);

  /// `heart-crack.mjs`
  static const ElLucideGlyph
  heartCrack = ElLucideGlyph('heart-crack', <ElIconElement>[
    ElIconPathElement(
      'M12.409 5.824c-.702.792-1.15 1.496-1.415 2.166l2.153 2.156a.5.5 0 0 1 0 .707l-2.293 2.293a.5.5 0 0 0 0 .707L12 15',
    ), // key: idzbju
    ElIconPathElement(
      'M13.508 20.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5a5.5 5.5 0 0 1 9.591-3.677.6.6 0 0 0 .818.001A5.5 5.5 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5z',
    ), // key: 1su70f
  ]);

  /// `heart-handshake.mjs`
  static const ElLucideGlyph
  heartHandshake = ElLucideGlyph('heart-handshake', <ElIconElement>[
    ElIconPathElement(
      'M19.414 14.414C21 12.828 22 11.5 22 9.5a5.5 5.5 0 0 0-9.591-3.676.6.6 0 0 1-.818.001A5.5 5.5 0 0 0 2 9.5c0 2.3 1.5 4 3 5.5l5.535 5.362a2 2 0 0 0 2.879.052 2.12 2.12 0 0 0-.004-3 2.124 2.124 0 1 0 3-3 2.124 2.124 0 0 0 3.004 0 2 2 0 0 0 0-2.828l-1.881-1.882a2.41 2.41 0 0 0-3.409 0l-1.71 1.71a2 2 0 0 1-2.828 0 2 2 0 0 1 0-2.828l2.823-2.762',
    ), // key: 17lmqv
  ]);

  /// `heart-minus.mjs`
  static const ElLucideGlyph
  heartMinus = ElLucideGlyph('heart-minus', <ElIconElement>[
    ElIconPathElement(
      'm14.876 18.99-1.368 1.323a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5a5.2 5.2 0 0 1-.244 1.572',
    ), // key: 15yztm
    ElIconPathElement('M15 15h6'), // key: 1u4692
  ]);

  /// `heart-off.mjs`
  static const ElLucideGlyph
  heartOff = ElLucideGlyph('heart-off', <ElIconElement>[
    ElIconPathElement(
      'M10.5 4.893a5.5 5.5 0 0 1 1.091.931.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 1.872-1.002 3.356-2.187 4.655',
    ), // key: 1inpfl
    ElIconPathElement(
      'm16.967 16.967-3.459 3.346a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5a5.5 5.5 0 0 1 2.747-4.761',
    ), // key: vbc6x7
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `heart-plus.mjs`
  static const ElLucideGlyph
  heartPlus = ElLucideGlyph('heart-plus', <ElIconElement>[
    ElIconPathElement(
      'm14.479 19.374-.971.939a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5a5.2 5.2 0 0 1-.219 1.49',
    ), // key: wg5jx
    ElIconPathElement('M15 15h6'), // key: 1u4692
    ElIconPathElement('M18 12v6'), // key: 1houu1
  ]);

  /// `heart-pulse.mjs`
  static const ElLucideGlyph
  heartPulse = ElLucideGlyph('heart-pulse', <ElIconElement>[
    ElIconPathElement(
      'M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5',
    ), // key: mvr1a0
    ElIconPathElement(
      'M3.22 13H9.5l.5-1 2 4.5 2-7 1.5 3.5h5.27',
    ), // key: auskq0
  ]);

  /// `heart-x.mjs`
  static const ElLucideGlyph heartX = ElLucideGlyph('heart-x', <ElIconElement>[
    ElIconPathElement('m15.5 12.5 5 5'), // key: 15wbfr
    ElIconPathElement('m20.5 12.5-5 5'), // key: o012pn
    ElIconPathElement(
      'M21.955 8.774a5.5 5.5 0 0 0-9.546-2.95.6.6 0 0 1-.818 0A5.5 5.5 0 0 0 2 9.5c0 2.3 1.5 4 3 5.5l5.508 5.332a2 2 0 0 0 2.57.352',
    ), // key: c1obtn
  ]);

  /// `heart.mjs`
  static const ElLucideGlyph heart = ElLucideGlyph('heart', <ElIconElement>[
    ElIconPathElement(
      'M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5',
    ), // key: mvr1a0
  ]);

  /// `heater.mjs`
  static const ElLucideGlyph heater = ElLucideGlyph('heater', <ElIconElement>[
    ElIconPathElement('M11 8c2-3-2-3 0-6'), // key: 1ldv5m
    ElIconPathElement('M15.5 8c2-3-2-3 0-6'), // key: 1otqoz
    ElIconPathElement('M6 10h.01'), // key: 1lbq93
    ElIconPathElement('M6 14h.01'), // key: zudwn7
    ElIconPathElement('M10 16v-4'), // key: 1c25yv
    ElIconPathElement('M14 16v-4'), // key: 1dkbt8
    ElIconPathElement('M18 16v-4'), // key: 1yg9me
    ElIconPathElement(
      'M20 6a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h3',
    ), // key: 1ubg90
    ElIconPathElement('M5 20v2'), // key: 1abpe8
    ElIconPathElement('M19 20v2'), // key: kqn6ft
  ]);

  /// `helicopter.mjs`
  static const ElLucideGlyph helicopter = ElLucideGlyph(
    'helicopter',
    <ElIconElement>[
      ElIconPathElement('M11 17v4'), // key: 14wq8k
      ElIconPathElement('M14 3v8a2 2 0 0 0 2 2h5.865'), // key: 12oo5h
      ElIconPathElement('M17 17v4'), // key: hdt4hh
      ElIconPathElement(
        'M18 17a4 4 0 0 0 4-4 8 6 0 0 0-8-6 6 5 0 0 0-6 5v3a2 2 0 0 0 2 2z',
      ), // key: yynif
      ElIconPathElement('M2 10v5'), // key: sa5akn
      ElIconPathElement('M6 3h16'), // key: 27qw71
      ElIconPathElement('M7 21h14'), // key: 1ugz0u
      ElIconPathElement('M8 13H2'), // key: 1thz1o
    ],
  );

  /// `hexagon.mjs`
  static const ElLucideGlyph hexagon = ElLucideGlyph('hexagon', <ElIconElement>[
    ElIconPathElement(
      'M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z',
    ), // key: yt0hxn
  ]);

  /// `highlighter.mjs`
  static const ElLucideGlyph highlighter = ElLucideGlyph(
    'highlighter',
    <ElIconElement>[
      ElIconPathElement('m9 11-6 6v3h9l3-3'), // key: 1a3l36
      ElIconPathElement(
        'm22 12-4.6 4.6a2 2 0 0 1-2.8 0l-5.2-5.2a2 2 0 0 1 0-2.8L14 4',
      ), // key: 14a9rk
    ],
  );

  /// `hop-off.mjs`
  static const ElLucideGlyph hopOff = ElLucideGlyph('hop-off', <ElIconElement>[
    ElIconPathElement(
      'M10.82 16.12c1.69.6 3.91.79 5.18.85.28.01.53-.09.7-.27',
    ), // key: qyzcap
    ElIconPathElement(
      'M11.14 20.57c.52.24 2.44 1.12 4.08 1.37.46.06.86-.25.9-.71.12-1.52-.3-3.43-.5-4.28',
    ), // key: y078lb
    ElIconPathElement(
      'M16.13 21.05c1.65.63 3.68.84 4.87.91a.9.9 0 0 0 .7-.26',
    ), // key: 1utre3
    ElIconPathElement(
      'M17.99 5.52a20.83 20.83 0 0 1 3.15 4.5.8.8 0 0 1-.68 1.13c-1.17.1-2.5.02-3.9-.25',
    ), // key: 17o9hm
    ElIconPathElement(
      'M20.57 11.14c.24.52 1.12 2.44 1.37 4.08.04.3-.08.59-.31.75',
    ), // key: 1d1n4p
    ElIconPathElement(
      'M4.93 4.93a10 10 0 0 0-.67 13.4c.35.43.96.4 1.17-.12.69-1.71 1.07-5.07 1.07-6.71 1.34.45 3.1.9 4.88.62a.85.85 0 0 0 .48-.24',
    ), // key: 9uv3tt
    ElIconPathElement(
      'M5.52 17.99c1.05.95 2.91 2.42 4.5 3.15a.8.8 0 0 0 1.13-.68c.2-2.34-.33-5.3-1.57-8.28',
    ), // key: 1292wz
    ElIconPathElement(
      'M8.35 2.68a10 10 0 0 1 9.98 1.58c.43.35.4.96-.12 1.17-1.5.6-4.3.98-6.07 1.05',
    ), // key: 7ozu9p
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `hop.mjs`
  static const ElLucideGlyph hop = ElLucideGlyph('hop', <ElIconElement>[
    ElIconPathElement(
      'M10.82 16.12c1.69.6 3.91.79 5.18.85.55.03 1-.42.97-.97-.06-1.27-.26-3.5-.85-5.18',
    ), // key: 18lxf1
    ElIconPathElement(
      'M11.5 6.5c1.64 0 5-.38 6.71-1.07.52-.2.55-.82.12-1.17A10 10 0 0 0 4.26 18.33c.35.43.96.4 1.17-.12.69-1.71 1.07-5.07 1.07-6.71 1.34.45 3.1.9 4.88.62a.88.88 0 0 0 .73-.74c.3-2.14-.15-3.5-.61-4.88',
    ), // key: vtfxrw
    ElIconPathElement(
      'M15.62 16.95c.2.85.62 2.76.5 4.28a.77.77 0 0 1-.9.7 16.64 16.64 0 0 1-4.08-1.36',
    ), // key: 13hl71
    ElIconPathElement(
      'M16.13 21.05c1.65.63 3.68.84 4.87.91a.9.9 0 0 0 .96-.96 17.68 17.68 0 0 0-.9-4.87',
    ), // key: 1sl8oj
    ElIconPathElement(
      'M16.94 15.62c.86.2 2.77.62 4.29.5a.77.77 0 0 0 .7-.9 16.64 16.64 0 0 0-1.36-4.08',
    ), // key: 19c6kt
    ElIconPathElement(
      'M17.99 5.52a20.82 20.82 0 0 1 3.15 4.5.8.8 0 0 1-.68 1.13c-2.33.2-5.3-.32-8.27-1.57',
    ), // key: 85ghs3
    ElIconPathElement('M4.93 4.93 3 3a.7.7 0 0 1 0-1'), // key: x087yj
    ElIconPathElement(
      'M9.58 12.18c1.24 2.98 1.77 5.95 1.57 8.28a.8.8 0 0 1-1.13.68 20.82 20.82 0 0 1-4.5-3.15',
    ), // key: 11xdqo
  ]);

  /// `hospital.mjs`
  static const ElLucideGlyph
  hospital = ElLucideGlyph('hospital', <ElIconElement>[
    ElIconPathElement('M12 7v4'), // key: xawao1
    ElIconPathElement('M14 21v-3a2 2 0 0 0-4 0v3'), // key: 1rgiei
    ElIconPathElement('M14 9h-4'), // key: 1w2s2s
    ElIconPathElement(
      'M18 11h2a2 2 0 0 1 2 2v6a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-9a2 2 0 0 1 2-2h2',
    ), // key: 1tthqt
    ElIconPathElement(
      'M18 21V5a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v16',
    ), // key: dw4p4i
  ]);

  /// `hotel.mjs`
  static const ElLucideGlyph hotel = ElLucideGlyph('hotel', <ElIconElement>[
    ElIconPathElement('M10 22v-6.57'), // key: 1wmca3
    ElIconPathElement('M12 11h.01'), // key: z322tv
    ElIconPathElement('M12 7h.01'), // key: 1ivr5q
    ElIconPathElement('M14 15.43V22'), // key: 1q2vjd
    ElIconPathElement('M15 16a5 5 0 0 0-6 0'), // key: o9wqvi
    ElIconPathElement('M16 11h.01'), // key: xkw8gn
    ElIconPathElement('M16 7h.01'), // key: 1kdx03
    ElIconPathElement('M8 11h.01'), // key: 1dfujw
    ElIconPathElement('M8 7h.01'), // key: 1vti4s
    ElIconRectElement(4, 2, 16, 20, 2), // key: 1uxh74
  ]);

  /// `hourglass.mjs`
  static const ElLucideGlyph
  hourglass = ElLucideGlyph('hourglass', <ElIconElement>[
    ElIconPathElement('M5 22h14'), // key: ehvnwv
    ElIconPathElement('M5 2h14'), // key: pdyrp9
    ElIconPathElement(
      'M17 22v-4.172a2 2 0 0 0-.586-1.414L12 12l-4.414 4.414A2 2 0 0 0 7 17.828V22',
    ), // key: 1d314k
    ElIconPathElement(
      'M7 2v4.172a2 2 0 0 0 .586 1.414L12 12l4.414-4.414A2 2 0 0 0 17 6.172V2',
    ), // key: 1vvvr6
  ]);

  /// `house-heart.mjs`
  static const ElLucideGlyph
  houseHeart = ElLucideGlyph('house-heart', <ElIconElement>[
    ElIconPathElement(
      'M8.62 13.8A2.25 2.25 0 1 1 12 10.836a2.25 2.25 0 1 1 3.38 2.966l-2.626 2.856a.998.998 0 0 1-1.507 0z',
    ), // key: n9s7kx
    ElIconPathElement(
      'M3 10a2 2 0 0 1 .709-1.528l7-6a2 2 0 0 1 2.582 0l7 6A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z',
    ), // key: r6nss1
  ]);

  /// `house-plug.mjs`
  static const ElLucideGlyph
  housePlug = ElLucideGlyph('house-plug', <ElIconElement>[
    ElIconPathElement('M10 12V8.964'), // key: 1vll13
    ElIconPathElement('M14 12V8.964'), // key: 1x3qvg
    ElIconPathElement(
      'M15 12a1 1 0 0 1 1 1v2a2 2 0 0 1-2 2h-4a2 2 0 0 1-2-2v-2a1 1 0 0 1 1-1z',
    ), // key: ppykja
    ElIconPathElement(
      'M8.5 21H5a2 2 0 0 1-2-2v-9a2 2 0 0 1 .709-1.528l7-6a2 2 0 0 1 2.582 0l7 6A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2h-5a2 2 0 0 1-2-2v-2',
    ), // key: 365xoy
  ]);

  /// `house-plus.mjs`
  static const ElLucideGlyph
  housePlus = ElLucideGlyph('house-plus', <ElIconElement>[
    ElIconPathElement(
      'M12.35 21H5a2 2 0 0 1-2-2v-9a2 2 0 0 1 .71-1.53l7-6a2 2 0 0 1 2.58 0l7 6A2 2 0 0 1 21 10v2.35',
    ), // key: 8ek5ge
    ElIconPathElement(
      'M14.8 12.4A1 1 0 0 0 14 12h-4a1 1 0 0 0-1 1v8',
    ), // key: 1rbg29
    ElIconPathElement('M15 18h6'), // key: 3b3c90
    ElIconPathElement('M18 15v6'), // key: 9wciyi
  ]);

  /// `house-wifi.mjs`
  static const ElLucideGlyph
  houseWifi = ElLucideGlyph('house-wifi', <ElIconElement>[
    ElIconPathElement('M9.5 13.866a4 4 0 0 1 5 .01'), // key: 1wy54i
    ElIconPathElement('M12 17h.01'), // key: p32p05
    ElIconPathElement(
      'M3 10a2 2 0 0 1 .709-1.528l7-6a2 2 0 0 1 2.582 0l7 6A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z',
    ), // key: r6nss1
    ElIconPathElement('M7 10.754a8 8 0 0 1 10 0'), // key: exoy2g
  ]);

  /// `house.mjs`
  static const ElLucideGlyph house = ElLucideGlyph('house', <ElIconElement>[
    ElIconPathElement(
      'M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8',
    ), // key: 5wwlr5
    ElIconPathElement(
      'M3 10a2 2 0 0 1 .709-1.528l7-6a2 2 0 0 1 2.582 0l7 6A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z',
    ), // key: r6nss1
  ]);

  /// `ice-cream-bowl.mjs`
  static const ElLucideGlyph
  iceCreamBowl = ElLucideGlyph('ice-cream-bowl', <ElIconElement>[
    ElIconPathElement(
      'M12 17c5 0 8-2.69 8-6H4c0 3.31 3 6 8 6m-4 4h8m-4-3v3M5.14 11a3.5 3.5 0 1 1 6.71 0',
    ), // key: 1uxfcu
    ElIconPathElement('M12.14 11a3.5 3.5 0 1 1 6.71 0'), // key: 4k3m1s
    ElIconPathElement('M15.5 6.5a3.5 3.5 0 1 0-7 0'), // key: zmuahr
  ]);

  /// `ice-cream-cone.mjs`
  static const ElLucideGlyph
  iceCreamCone = ElLucideGlyph('ice-cream-cone', <ElIconElement>[
    ElIconPathElement('m7 11 4.08 10.35a1 1 0 0 0 1.84 0L17 11'), // key: 1v6356
    ElIconPathElement('M17 7A5 5 0 0 0 7 7'), // key: 151p3v
    ElIconPathElement('M17 7a2 2 0 0 1 0 4H7a2 2 0 0 1 0-4'), // key: 1sdaij
  ]);

  /// `id-card-lanyard.mjs`
  static const ElLucideGlyph
  idCardLanyard = ElLucideGlyph('id-card-lanyard', <ElIconElement>[
    ElIconPathElement('M13.5 8h-3'), // key: xvov4w
    ElIconPathElement(
      'm15 2-1 2h3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h3',
    ), // key: 16uttc
    ElIconPathElement('M16.899 22A5 5 0 0 0 7.1 22'), // key: 1d0ppr
    ElIconPathElement('m9 2 3 6'), // key: 1o7bd9
    ElIconCircleElement(12, 15, 3), // key: g36mzq
  ]);

  /// `id-card.mjs`
  static const ElLucideGlyph idCard = ElLucideGlyph('id-card', <ElIconElement>[
    ElIconPathElement('M16 10h2'), // key: 8sgtl7
    ElIconPathElement('M16 14h2'), // key: epxaof
    ElIconPathElement('M6.17 15a3 3 0 0 1 5.66 0'), // key: n6f512
    ElIconCircleElement(9, 11, 2), // key: yxgjnd
    ElIconRectElement(2, 5, 20, 14, 2), // key: qneu4z
  ]);

  /// `image-down.mjs`
  static const ElLucideGlyph
  imageDown = ElLucideGlyph('image-down', <ElIconElement>[
    ElIconPathElement(
      'M10.3 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v10l-3.1-3.1a2 2 0 0 0-2.814.014L6 21',
    ), // key: 9csbqa
    ElIconPathElement('m14 19 3 3v-5.5'), // key: 9ldu5r
    ElIconPathElement('m17 22 3-3'), // key: 1nkfve
    ElIconCircleElement(9, 9, 2), // key: af1f0g
  ]);

  /// `image-minus.mjs`
  static const ElLucideGlyph imageMinus = ElLucideGlyph(
    'image-minus',
    <ElIconElement>[
      ElIconPathElement(
        'M21 9v10a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h7',
      ), // key: m87ecr
      ElIconLineElement(16, 5, 22, 5), // key: ez7e4s
      ElIconCircleElement(9, 9, 2), // key: af1f0g
      ElIconPathElement(
        'm21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21',
      ), // key: 1xmnt7
    ],
  );

  /// `image-off.mjs`
  static const ElLucideGlyph
  imageOff = ElLucideGlyph('image-off', <ElIconElement>[
    ElIconLineElement(2, 2, 22, 22), // key: a6p6uj
    ElIconPathElement('M10.41 10.41a2 2 0 1 1-2.83-2.83'), // key: 1bzlo9
    ElIconLineElement(13.5, 13.5, 6, 21), // key: 1q0aeu
    ElIconLineElement(18, 12, 21, 15), // key: 5mozeu
    ElIconPathElement(
      'M3.59 3.59A1.99 1.99 0 0 0 3 5v14a2 2 0 0 0 2 2h14c.55 0 1.052-.22 1.41-.59',
    ), // key: mmje98
    ElIconPathElement('M21 15V5a2 2 0 0 0-2-2H9'), // key: 43el77
  ]);

  /// `image-play.mjs`
  static const ElLucideGlyph
  imagePlay = ElLucideGlyph('image-play', <ElIconElement>[
    ElIconPathElement(
      'M15 15.003a1 1 0 0 1 1.517-.859l4.997 2.997a1 1 0 0 1 0 1.718l-4.997 2.997a1 1 0 0 1-1.517-.86z',
    ), // key: nrt1m3
    ElIconPathElement(
      'M21 12.17V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h6',
    ), // key: 99hgts
    ElIconPathElement('m6 21 5-5'), // key: 1wyjai
    ElIconCircleElement(9, 9, 2), // key: af1f0g
  ]);

  /// `image-plus.mjs`
  static const ElLucideGlyph imagePlus = ElLucideGlyph(
    'image-plus',
    <ElIconElement>[
      ElIconPathElement('M16 5h6'), // key: 1vod17
      ElIconPathElement('M19 2v6'), // key: 4bpg5p
      ElIconPathElement(
        'M21 11.5V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h7.5',
      ), // key: 1ue2ih
      ElIconPathElement(
        'm21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21',
      ), // key: 1xmnt7
      ElIconCircleElement(9, 9, 2), // key: af1f0g
    ],
  );

  /// `image-up.mjs`
  static const ElLucideGlyph
  imageUp = ElLucideGlyph('image-up', <ElIconElement>[
    ElIconPathElement(
      'M10.3 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v10l-3.1-3.1a2 2 0 0 0-2.814.014L6 21',
    ), // key: 9csbqa
    ElIconPathElement('m14 19.5 3-3 3 3'), // key: 9vmjn0
    ElIconPathElement('M17 22v-5.5'), // key: 1aa6fl
    ElIconCircleElement(9, 9, 2), // key: af1f0g
  ]);

  /// `image-upscale.mjs`
  static const ElLucideGlyph imageUpscale = ElLucideGlyph(
    'image-upscale',
    <ElIconElement>[
      ElIconPathElement('M16 3h5v5'), // key: 1806ms
      ElIconPathElement('M17 21h2a2 2 0 0 0 2-2'), // key: 130fy9
      ElIconPathElement('M21 12v3'), // key: 1wzk3p
      ElIconPathElement('m21 3-5 5'), // key: 1g5oa7
      ElIconPathElement('M3 7V5a2 2 0 0 1 2-2'), // key: kk3yz1
      ElIconPathElement(
        'm5 21 4.144-4.144a1.21 1.21 0 0 1 1.712 0L13 19',
      ), // key: fyekpt
      ElIconPathElement('M9 3h3'), // key: d52fa
      ElIconRectElement(3, 11, 10, 10, 1), // key: 1wpmix
    ],
  );

  /// `image.mjs`
  static const ElLucideGlyph image = ElLucideGlyph('image', <ElIconElement>[
    ElIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    ElIconCircleElement(9, 9, 2), // key: af1f0g
    ElIconPathElement(
      'm21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21',
    ), // key: 1xmnt7
  ]);

  /// `images.mjs`
  static const ElLucideGlyph images = ElLucideGlyph('images', <ElIconElement>[
    ElIconPathElement(
      'm22 11-1.296-1.296a2.4 2.4 0 0 0-3.408 0L11 16',
    ), // key: 9kzy35
    ElIconPathElement(
      'M4 8a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2',
    ), // key: 1t0f0t
    ElIconCircleElement(13, 7, 1, filled: true), // key: 1obus6
    ElIconRectElement(8, 2, 14, 14, 2), // key: 1gvhby
  ]);

  /// `import.mjs`
  static const ElLucideGlyph import = ElLucideGlyph('import', <ElIconElement>[
    ElIconPathElement('M12 3v12'), // key: 1x0j5s
    ElIconPathElement('m8 11 4 4 4-4'), // key: 1dohi6
    ElIconPathElement(
      'M8 5H4a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-4',
    ), // key: 1ywtjm
  ]);

  /// `inbox.mjs`
  static const ElLucideGlyph inbox = ElLucideGlyph('inbox', <ElIconElement>[
    ElIconPolylineElement(<Offset>[
      Offset(22, 12),
      Offset(16, 12),
      Offset(14, 15),
      Offset(10, 15),
      Offset(8, 12),
      Offset(2, 12),
    ]), // key: o97t9d
    ElIconPathElement(
      'M5.45 5.11 2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z',
    ), // key: oot6mr
  ]);

  /// `indian-rupee.mjs`
  static const ElLucideGlyph indianRupee = ElLucideGlyph(
    'indian-rupee',
    <ElIconElement>[
      ElIconPathElement('M6 3h12'), // key: ggurg9
      ElIconPathElement('M6 8h12'), // key: 6g4wlu
      ElIconPathElement('m6 13 8.5 8'), // key: u1kupk
      ElIconPathElement('M6 13h3'), // key: wdp6ag
      ElIconPathElement('M9 13c6.667 0 6.667-10 0-10'), // key: 1nkvk2
    ],
  );

  /// `infinity.mjs`
  static const ElLucideGlyph infinity = ElLucideGlyph(
    'infinity',
    <ElIconElement>[
      ElIconPathElement(
        'M6 16c5 0 7-8 12-8a4 4 0 0 1 0 8c-5 0-7-8-12-8a4 4 0 1 0 0 8',
      ), // key: 18ogeb
    ],
  );

  /// `info.mjs`
  static const ElLucideGlyph info = ElLucideGlyph('info', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement('M12 16v-4'), // key: 1dtifu
    ElIconPathElement('M12 8h.01'), // key: e9boi3
  ]);

  /// `inspection-panel.mjs`
  static const ElLucideGlyph inspectionPanel = ElLucideGlyph(
    'inspection-panel',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M7 7h.01'), // key: 7u93v4
      ElIconPathElement('M17 7h.01'), // key: 14a9sn
      ElIconPathElement('M7 17h.01'), // key: 19xn7k
      ElIconPathElement('M17 17h.01'), // key: 1sd3ek
    ],
  );

  /// `italic.mjs`
  static const ElLucideGlyph italic = ElLucideGlyph('italic', <ElIconElement>[
    ElIconLineElement(19, 4, 10, 4), // key: 15jd3p
    ElIconLineElement(14, 20, 5, 20), // key: bu0au3
    ElIconLineElement(15, 4, 9, 20), // key: uljnxc
  ]);

  /// `iteration-ccw.mjs`
  static const ElLucideGlyph iterationCcw = ElLucideGlyph(
    'iteration-ccw',
    <ElIconElement>[
      ElIconPathElement('m16 14 4 4-4 4'), // key: hkso8o
      ElIconPathElement('M20 10a8 8 0 1 0-8 8h8'), // key: 1bik7b
    ],
  );

  /// `iteration-cw.mjs`
  static const ElLucideGlyph iterationCw = ElLucideGlyph(
    'iteration-cw',
    <ElIconElement>[
      ElIconPathElement('M4 10a8 8 0 1 1 8 8H4'), // key: svv66n
      ElIconPathElement('m8 22-4-4 4-4'), // key: 6g7gki
    ],
  );

  /// `japanese-yen.mjs`
  static const ElLucideGlyph japaneseYen = ElLucideGlyph(
    'japanese-yen',
    <ElIconElement>[
      ElIconPathElement('M12 9.5V21m0-11.5L6 3m6 6.5L18 3'), // key: 2ej80x
      ElIconPathElement('M6 15h12'), // key: 1hwgt5
      ElIconPathElement('M6 11h12'), // key: wf4gp6
    ],
  );

  /// `joystick.mjs`
  static const ElLucideGlyph
  joystick = ElLucideGlyph('joystick', <ElIconElement>[
    ElIconPathElement(
      'M21 17a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v2a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-2Z',
    ), // key: jg2n2t
    ElIconPathElement('M6 15v-2'), // key: gd6mvg
    ElIconPathElement('M12 15V9'), // key: 8c7uyn
    ElIconCircleElement(12, 6, 3), // key: 1gm2ql
  ]);

  /// `kanban.mjs`
  static const ElLucideGlyph kanban = ElLucideGlyph('kanban', <ElIconElement>[
    ElIconPathElement('M5 3v14'), // key: 9nsxs2
    ElIconPathElement('M12 3v8'), // key: 1h2ygw
    ElIconPathElement('M19 3v18'), // key: 1sk56x
  ]);

  /// `kayak.mjs`
  static const ElLucideGlyph kayak = ElLucideGlyph('kayak', <ElIconElement>[
    ElIconPathElement('M18 17a1 1 0 0 0-1 1v1a2 2 0 1 0 2-2z'), // key: skzb1g
    ElIconPathElement(
      'M20.97 3.61a.45.45 0 0 0-.58-.58C10.2 6.6 6.6 10.2 3.03 20.39a.45.45 0 0 0 .58.58C13.8 17.4 17.4 13.8 20.97 3.61',
    ), // key: cv9jm7
    ElIconPathElement('m6.707 6.707 10.586 10.586'), // key: d2l993
    ElIconPathElement('M7 5a2 2 0 1 0-2 2h1a1 1 0 0 0 1-1z'), // key: i0et4n
  ]);

  /// `key-round.mjs`
  static const ElLucideGlyph
  keyRound = ElLucideGlyph('key-round', <ElIconElement>[
    ElIconPathElement(
      'M2.586 17.414A2 2 0 0 0 2 18.828V21a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h1a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h.172a2 2 0 0 0 1.414-.586l.814-.814a6.5 6.5 0 1 0-4-4z',
    ), // key: 1s6t7t
    ElIconCircleElement(16.5, 7.5, 0.5, filled: true), // key: w0ekpg
  ]);

  /// `key-square.mjs`
  static const ElLucideGlyph
  keySquare = ElLucideGlyph('key-square', <ElIconElement>[
    ElIconPathElement(
      'M12.4 2.7a2.5 2.5 0 0 1 3.4 0l5.5 5.5a2.5 2.5 0 0 1 0 3.4l-3.7 3.7a2.5 2.5 0 0 1-3.4 0L8.7 9.8a2.5 2.5 0 0 1 0-3.4z',
    ), // key: 165ttr
    ElIconPathElement('m14 7 3 3'), // key: 1r5n42
    ElIconPathElement(
      'm9.4 10.6-6.814 6.814A2 2 0 0 0 2 18.828V21a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h1a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h.172a2 2 0 0 0 1.414-.586l.814-.814',
    ), // key: 1ubxi2
  ]);

  /// `key.mjs`
  static const ElLucideGlyph key = ElLucideGlyph('key', <ElIconElement>[
    ElIconPathElement(
      'm15.5 7.5 2.3 2.3a1 1 0 0 0 1.4 0l2.1-2.1a1 1 0 0 0 0-1.4L19 4',
    ), // key: g0fldk
    ElIconPathElement('m21 2-9.6 9.6'), // key: 1j0ho8
    ElIconCircleElement(7.5, 15.5, 5.5), // key: yqb3hr
  ]);

  /// `keyboard-music.mjs`
  static const ElLucideGlyph keyboardMusic = ElLucideGlyph(
    'keyboard-music',
    <ElIconElement>[
      ElIconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
      ElIconPathElement('M6 8h4'), // key: utf9t1
      ElIconPathElement('M14 8h.01'), // key: 1primd
      ElIconPathElement('M18 8h.01'), // key: emo2bl
      ElIconPathElement('M2 12h20'), // key: 9i4pu4
      ElIconPathElement('M6 12v4'), // key: dy92yo
      ElIconPathElement('M10 12v4'), // key: 1fxnav
      ElIconPathElement('M14 12v4'), // key: 1hft58
      ElIconPathElement('M18 12v4'), // key: tjjnbz
    ],
  );

  /// `keyboard-off.mjs`
  static const ElLucideGlyph
  keyboardOff = ElLucideGlyph('keyboard-off', <ElIconElement>[
    ElIconPathElement('M 20 4 A2 2 0 0 1 22 6'), // key: 1g1fkt
    ElIconPathElement('M 22 6 L 22 16.41'), // key: 1qjg3w
    ElIconPathElement('M 7 16 L 16 16'), // key: n0yqwb
    ElIconPathElement('M 9.69 4 L 20 4'), // key: kbpcgx
    ElIconPathElement('M14 8h.01'), // key: 1primd
    ElIconPathElement('M18 8h.01'), // key: emo2bl
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement('M20 20H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2'), // key: s23sx2
    ElIconPathElement('M6 8h.01'), // key: x9i8wu
    ElIconPathElement('M8 12h.01'), // key: czm47f
  ]);

  /// `keyboard.mjs`
  static const ElLucideGlyph keyboard = ElLucideGlyph(
    'keyboard',
    <ElIconElement>[
      ElIconPathElement('M10 8h.01'), // key: 1r9ogq
      ElIconPathElement('M12 12h.01'), // key: 1mp3jc
      ElIconPathElement('M14 8h.01'), // key: 1primd
      ElIconPathElement('M16 12h.01'), // key: 1l6xoz
      ElIconPathElement('M18 8h.01'), // key: emo2bl
      ElIconPathElement('M6 8h.01'), // key: x9i8wu
      ElIconPathElement('M7 16h10'), // key: wp8him
      ElIconPathElement('M8 12h.01'), // key: czm47f
      ElIconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
    ],
  );

  /// `lamp-ceiling.mjs`
  static const ElLucideGlyph
  lampCeiling = ElLucideGlyph('lamp-ceiling', <ElIconElement>[
    ElIconPathElement('M12 2v5'), // key: nd4vlx
    ElIconPathElement('M14.829 15.998a3 3 0 1 1-5.658 0'), // key: 1pybiy
    ElIconPathElement(
      'M20.92 14.606A1 1 0 0 1 20 16H4a1 1 0 0 1-.92-1.394l3-7A1 1 0 0 1 7 7h10a1 1 0 0 1 .92.606z',
    ), // key: ma1wor
  ]);

  /// `lamp-desk.mjs`
  static const ElLucideGlyph
  lampDesk = ElLucideGlyph('lamp-desk', <ElIconElement>[
    ElIconPathElement(
      'M10.293 2.293a1 1 0 0 1 1.414 0l2.5 2.5 5.994 1.227a1 1 0 0 1 .506 1.687l-7 7a1 1 0 0 1-1.687-.506l-1.227-5.994-2.5-2.5a1 1 0 0 1 0-1.414z',
    ), // key: sb8slu
    ElIconPathElement('m14.207 4.793-3.414 3.414'), // key: m2x3oj
    ElIconPathElement(
      'M3 20a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1z',
    ), // key: 8b3myj
    ElIconPathElement(
      'm9.086 6.5-4.793 4.793a1 1 0 0 0-.18 1.17L7 18',
    ), // key: 43s6cu
  ]);

  /// `lamp-floor.mjs`
  static const ElLucideGlyph
  lampFloor = ElLucideGlyph('lamp-floor', <ElIconElement>[
    ElIconPathElement('M12 10v12'), // key: 6ubwww
    ElIconPathElement(
      'M17.929 7.629A1 1 0 0 1 17 9H7a1 1 0 0 1-.928-1.371l2-5A1 1 0 0 1 9 2h6a1 1 0 0 1 .928.629z',
    ), // key: 1o95gh
    ElIconPathElement('M9 22h6'), // key: 1rlq3v
  ]);

  /// `lamp-wall-down.mjs`
  static const ElLucideGlyph
  lampWallDown = ElLucideGlyph('lamp-wall-down', <ElIconElement>[
    ElIconPathElement(
      'M19.929 18.629A1 1 0 0 1 19 20H9a1 1 0 0 1-.928-1.371l2-5A1 1 0 0 1 11 13h6a1 1 0 0 1 .928.629z',
    ), // key: u4w2d7
    ElIconPathElement(
      'M6 3a2 2 0 0 1 2 2v2a2 2 0 0 1-2 2H5a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1z',
    ), // key: 15356w
    ElIconPathElement('M8 6h4a2 2 0 0 1 2 2v5'), // key: 1m6m7x
  ]);

  /// `lamp-wall-up.mjs`
  static const ElLucideGlyph
  lampWallUp = ElLucideGlyph('lamp-wall-up', <ElIconElement>[
    ElIconPathElement(
      'M19.929 9.629A1 1 0 0 1 19 11H9a1 1 0 0 1-.928-1.371l2-5A1 1 0 0 1 11 4h6a1 1 0 0 1 .928.629z',
    ), // key: 1uvrbf
    ElIconPathElement(
      'M6 15a2 2 0 0 1 2 2v2a2 2 0 0 1-2 2H5a1 1 0 0 1-1-1v-4a1 1 0 0 1 1-1z',
    ), // key: 154r2a
    ElIconPathElement('M8 18h4a2 2 0 0 0 2-2v-5'), // key: z9mbu0
  ]);

  /// `lamp.mjs`
  static const ElLucideGlyph lamp = ElLucideGlyph('lamp', <ElIconElement>[
    ElIconPathElement('M12 12v6'), // key: 3ahymv
    ElIconPathElement(
      'M4.077 10.615A1 1 0 0 0 5 12h14a1 1 0 0 0 .923-1.385l-3.077-7.384A2 2 0 0 0 15 2H9a2 2 0 0 0-1.846 1.23Z',
    ), // key: 1l7kg2
    ElIconPathElement(
      'M8 20a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H9a1 1 0 0 1-1-1z',
    ), // key: 1mmzpi
  ]);

  /// `land-plot.mjs`
  static const ElLucideGlyph
  landPlot = ElLucideGlyph('land-plot', <ElIconElement>[
    ElIconPathElement('m12 8 6-3-6-3v10'), // key: mvpnpy
    ElIconPathElement(
      'm8 11.99-5.5 3.14a1 1 0 0 0 0 1.74l8.5 4.86a2 2 0 0 0 2 0l8.5-4.86a1 1 0 0 0 0-1.74L16 12',
    ), // key: ek95tt
    ElIconPathElement('m6.49 12.85 11.02 6.3'), // key: 1kt42w
    ElIconPathElement('M17.51 12.85 6.5 19.15'), // key: v55bdg
  ]);

  /// `landmark.mjs`
  static const ElLucideGlyph
  landmark = ElLucideGlyph('landmark', <ElIconElement>[
    ElIconPathElement('M10 18v-7'), // key: wt116b
    ElIconPathElement(
      'M11.119 2.205a2 2 0 0 1 1.762 0l7.84 3.846A.5.5 0 0 1 20.5 7h-17a.5.5 0 0 1-.22-.949z',
    ), // key: yxxwt6
    ElIconPathElement('M14 18v-7'), // key: vav6t3
    ElIconPathElement('M18 18v-7'), // key: aexdmj
    ElIconPathElement('M3 22h18'), // key: 8prr45
    ElIconPathElement('M6 18v-7'), // key: 1ivflk
  ]);

  /// `languages.mjs`
  static const ElLucideGlyph languages = ElLucideGlyph(
    'languages',
    <ElIconElement>[
      ElIconPathElement('m5 8 6 6'), // key: 1wu5hv
      ElIconPathElement('m4 14 6-6 2-3'), // key: 1k1g8d
      ElIconPathElement('M2 5h12'), // key: or177f
      ElIconPathElement('M7 2h1'), // key: 1t2jsx
      ElIconPathElement('m22 22-5-10-5 10'), // key: don7ne
      ElIconPathElement('M14 18h6'), // key: 1m8k6r
    ],
  );

  /// `laptop-minimal-check.mjs`
  static const ElLucideGlyph laptopMinimalCheck = ElLucideGlyph(
    'laptop-minimal-check',
    <ElIconElement>[
      ElIconPathElement('M2 20h20'), // key: owomy5
      ElIconPathElement('m9 10 2 2 4-4'), // key: 1gnqz4
      ElIconRectElement(3, 4, 18, 12, 2), // key: 8ur36m
    ],
  );

  /// `laptop-minimal.mjs`
  static const ElLucideGlyph laptopMinimal = ElLucideGlyph(
    'laptop-minimal',
    <ElIconElement>[
      ElIconRectElement(3, 4, 18, 12, 2, ry: 2), // key: 1qhy41
      ElIconLineElement(2, 20, 22, 20), // key: ni3hll
    ],
  );

  /// `laptop.mjs`
  static const ElLucideGlyph laptop = ElLucideGlyph('laptop', <ElIconElement>[
    ElIconPathElement(
      'M18 5a2 2 0 0 1 2 2v8.526a2 2 0 0 0 .212.897l1.068 2.127a1 1 0 0 1-.9 1.45H3.62a1 1 0 0 1-.9-1.45l1.068-2.127A2 2 0 0 0 4 15.526V7a2 2 0 0 1 2-2z',
    ), // key: 1pdavp
    ElIconPathElement('M20.054 15.987H3.946'), // key: 14rxg9
  ]);

  /// `lasso-select.mjs`
  static const ElLucideGlyph
  lassoSelect = ElLucideGlyph('lasso-select', <ElIconElement>[
    ElIconPathElement('M7 22a5 5 0 0 1-2-4'), // key: umushi
    ElIconPathElement('M7 16.93c.96.43 1.96.74 2.99.91'), // key: ybbtv3
    ElIconPathElement(
      'M3.34 14A6.8 6.8 0 0 1 2 10c0-4.42 4.48-8 10-8s10 3.58 10 8a7.19 7.19 0 0 1-.33 2',
    ), // key: gt5e1w
    ElIconPathElement('M5 18a2 2 0 1 0 0-4 2 2 0 0 0 0 4z'), // key: bq3ynw
    ElIconPathElement(
      'M14.33 22h-.09a.35.35 0 0 1-.24-.32v-10a.34.34 0 0 1 .33-.34c.08 0 .15.03.21.08l7.34 6a.33.33 0 0 1-.21.59h-4.49l-2.57 3.85a.35.35 0 0 1-.28.14z',
    ), // key: 72q637
  ]);

  /// `lasso.mjs`
  static const ElLucideGlyph lasso = ElLucideGlyph('lasso', <ElIconElement>[
    ElIconPathElement('M3.704 14.467a10 8 0 1 1 3.115 2.375'), // key: wxgc5m
    ElIconPathElement('M7 22a5 5 0 0 1-2-3.994'), // key: 1xp6a4
    ElIconCircleElement(5, 16, 2), // key: 18csp3
  ]);

  /// `laugh.mjs`
  static const ElLucideGlyph laugh = ElLucideGlyph('laugh', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement('M18 13a6 6 0 0 1-6 5 6 6 0 0 1-6-5h12Z'), // key: b2q4dd
    ElIconLineElement(9, 9, 9.01, 9), // key: yxxnd0
    ElIconLineElement(15, 9, 15.01, 9), // key: 1p4y9e
  ]);

  /// `layers-2.mjs`
  static const ElLucideGlyph
  layers2 = ElLucideGlyph('layers-2', <ElIconElement>[
    ElIconPathElement(
      'M13 13.74a2 2 0 0 1-2 0L2.5 8.87a1 1 0 0 1 0-1.74L11 2.26a2 2 0 0 1 2 0l8.5 4.87a1 1 0 0 1 0 1.74z',
    ), // key: 15q6uc
    ElIconPathElement(
      'm20 14.285 1.5.845a1 1 0 0 1 0 1.74L13 21.74a2 2 0 0 1-2 0l-8.5-4.87a1 1 0 0 1 0-1.74l1.5-.845',
    ), // key: byia6g
  ]);

  /// `layers-minus.mjs`
  static const ElLucideGlyph
  layersMinus = ElLucideGlyph('layers-minus', <ElIconElement>[
    ElIconPathElement(
      'M12.83 2.18a2 2 0 0 0-1.66 0L2.6 6.08a1 1 0 0 0 0 1.83l8.58 3.91a2 2 0 0 0 .83.18 2 2 0 0 0 .83-.18l8.58-3.9a1 1 0 0 0 0-1.832z',
    ), // key: tq134k
    ElIconPathElement('M16 17h6'), // key: 1ook5g
    ElIconPathElement(
      'M2.003 11.995a1 1 0 0 0 .597.915l8.58 3.91a2 2 0 0 0 .83.18',
    ), // key: 8mjqed
    ElIconPathElement(
      'M2.003 16.995a1 1 0 0 0 .597.915l8.58 3.91a2 2 0 0 0 .83.18 2 2 0 0 0 .83-.18l2.11-.96',
    ), // key: 7vwz41
    ElIconPathElement(
      'M22.018 12.004a1 1 0 0 1-.598.916l-.177.08',
    ), // key: bm5b9y
  ]);

  /// `layers-plus.mjs`
  static const ElLucideGlyph
  layersPlus = ElLucideGlyph('layers-plus', <ElIconElement>[
    ElIconPathElement(
      'M12.83 2.18a2 2 0 0 0-1.66 0L2.6 6.08a1 1 0 0 0 0 1.83l8.58 3.91a2 2 0 0 0 .83.18 2 2 0 0 0 .83-.18l8.58-3.9a1 1 0 0 0 0-1.831z',
    ), // key: zzgyd3
    ElIconPathElement('M16 17h6'), // key: 1ook5g
    ElIconPathElement('M19 14v6'), // key: 1ckrd5
    ElIconPathElement(
      'M2 12a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 .825.178',
    ), // key: 1ia9y3
    ElIconPathElement(
      'M2 17a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 1.65 0l2.116-.962',
    ), // key: jksky3
  ]);

  /// `layers.mjs`
  static const ElLucideGlyph layers = ElLucideGlyph('layers', <ElIconElement>[
    ElIconPathElement(
      'M12.83 2.18a2 2 0 0 0-1.66 0L2.6 6.08a1 1 0 0 0 0 1.83l8.58 3.91a2 2 0 0 0 1.66 0l8.58-3.9a1 1 0 0 0 0-1.83z',
    ), // key: zw3jo
    ElIconPathElement(
      'M2 12a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 1.65 0l8.58-3.9A1 1 0 0 0 22 12',
    ), // key: 1wduqc
    ElIconPathElement(
      'M2 17a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 1.65 0l8.58-3.9A1 1 0 0 0 22 17',
    ), // key: kqbvx6
  ]);

  /// `layout-dashboard.mjs`
  static const ElLucideGlyph layoutDashboard = ElLucideGlyph(
    'layout-dashboard',
    <ElIconElement>[
      ElIconRectElement(3, 3, 7, 9, 1), // key: 10lvy0
      ElIconRectElement(14, 3, 7, 5, 1), // key: 16une8
      ElIconRectElement(14, 12, 7, 9, 1), // key: 1hutg5
      ElIconRectElement(3, 16, 7, 5, 1), // key: ldoo1y
    ],
  );

  /// `layout-freeform.mjs`
  static const ElLucideGlyph layoutFreeform = ElLucideGlyph(
    'layout-freeform',
    <ElIconElement>[
      ElIconRectElement(3, 3, 7, 7, 1), // key: 1g98yp
      ElIconRectElement(14, 4, 7, 7, 1), // key: n7b4zl
      ElIconRectElement(4, 14, 7, 7, 1), // key: 1ngf42
    ],
  );

  /// `layout-grid.mjs`
  static const ElLucideGlyph layoutGrid = ElLucideGlyph(
    'layout-grid',
    <ElIconElement>[
      ElIconRectElement(3, 3, 7, 7, 1), // key: 1g98yp
      ElIconRectElement(14, 3, 7, 7, 1), // key: 6d4xhi
      ElIconRectElement(14, 14, 7, 7, 1), // key: nxv5o0
      ElIconRectElement(3, 14, 7, 7, 1), // key: 1bb6yr
    ],
  );

  /// `layout-list.mjs`
  static const ElLucideGlyph layoutList = ElLucideGlyph(
    'layout-list',
    <ElIconElement>[
      ElIconRectElement(3, 3, 7, 7, 1), // key: 1g98yp
      ElIconRectElement(3, 14, 7, 7, 1), // key: 1bb6yr
      ElIconPathElement('M14 4h7'), // key: 3xa0d5
      ElIconPathElement('M14 9h7'), // key: 1icrd9
      ElIconPathElement('M14 15h7'), // key: 1mj8o2
      ElIconPathElement('M14 20h7'), // key: 11slyb
    ],
  );

  /// `layout-panel-left.mjs`
  static const ElLucideGlyph layoutPanelLeft = ElLucideGlyph(
    'layout-panel-left',
    <ElIconElement>[
      ElIconRectElement(3, 3, 7, 18, 1), // key: 2obqm
      ElIconRectElement(14, 3, 7, 7, 1), // key: 6d4xhi
      ElIconRectElement(14, 14, 7, 7, 1), // key: nxv5o0
    ],
  );

  /// `layout-panel-top.mjs`
  static const ElLucideGlyph layoutPanelTop = ElLucideGlyph(
    'layout-panel-top',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 7, 1), // key: f1a2em
      ElIconRectElement(3, 14, 7, 7, 1), // key: 1bb6yr
      ElIconRectElement(14, 14, 7, 7, 1), // key: nxv5o0
    ],
  );

  /// `layout-template.mjs`
  static const ElLucideGlyph layoutTemplate = ElLucideGlyph(
    'layout-template',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 7, 1), // key: f1a2em
      ElIconRectElement(3, 14, 9, 7, 1), // key: jqznyg
      ElIconRectElement(16, 14, 5, 7, 1), // key: q5h2i8
    ],
  );

  /// `leaf.mjs`
  static const ElLucideGlyph leaf = ElLucideGlyph('leaf', <ElIconElement>[
    ElIconPathElement(
      'M11 20A7 7 0 0 1 9.8 6.1C15.5 5 17 4.48 19 2c1 2 2 4.18 2 8 0 5.5-4.78 10-10 10Z',
    ), // key: nnexq3
    ElIconPathElement(
      'M2 21c0-3 1.85-5.36 5.08-6C9.5 14.52 12 13 13 12',
    ), // key: mt58a7
  ]);

  /// `leafy-green.mjs`
  static const ElLucideGlyph
  leafyGreen = ElLucideGlyph('leafy-green', <ElIconElement>[
    ElIconPathElement(
      'M2 22c1.25-.987 2.27-1.975 3.9-2.2a5.56 5.56 0 0 1 3.8 1.5 4 4 0 0 0 6.187-2.353 3.5 3.5 0 0 0 3.69-5.116A3.5 3.5 0 0 0 20.95 8 3.5 3.5 0 1 0 16 3.05a3.5 3.5 0 0 0-5.831 1.373 3.5 3.5 0 0 0-5.116 3.69 4 4 0 0 0-2.348 6.155C3.499 15.42 4.409 16.712 4.2 18.1 3.926 19.743 3.014 20.732 2 22',
    ), // key: 1134nt
    ElIconPathElement('M2 22 17 7'), // key: 1q7jp2
  ]);

  /// `lectern.mjs`
  static const ElLucideGlyph lectern = ElLucideGlyph('lectern', <ElIconElement>[
    ElIconPathElement(
      'M16 12h3a2 2 0 0 0 1.902-1.38l1.056-3.333A1 1 0 0 0 21 6H3a1 1 0 0 0-.958 1.287l1.056 3.334A2 2 0 0 0 5 12h3',
    ), // key: 13jjxg
    ElIconPathElement('M18 6V3a1 1 0 0 0-1-1h-3'), // key: 1550fe
    ElIconRectElement(8, 10, 8, 12, 1), // key: qmu8b6
  ]);

  /// `lens-concave.mjs`
  static const ElLucideGlyph
  lensConcave = ElLucideGlyph('lens-concave', <ElIconElement>[
    ElIconPathElement(
      'M7 2a1 1 0 0 0-.8 1.6 14 14 0 0 1 0 16.8A1 1 0 0 0 7 22h10a1 1 0 0 0 .8-1.6 14 14 0 0 1 0-16.8A1 1 0 0 0 17 2z',
    ), // key: 109j23
  ]);

  /// `lens-convex.mjs`
  static const ElLucideGlyph
  lensConvex = ElLucideGlyph('lens-convex', <ElIconElement>[
    ElIconPathElement(
      'M13.433 2a1 1 0 0 1 .824.448 18 18 0 0 1 0 19.104 1 1 0 0 1-.824.448h-2.866a1 1 0 0 1-.824-.448 18 18 0 0 1 0-19.104A1 1 0 0 1 10.567 2z',
    ), // key: cq67go
  ]);

  /// `library-big.mjs`
  static const ElLucideGlyph
  libraryBig = ElLucideGlyph('library-big', <ElIconElement>[
    ElIconRectElement(3, 3, 8, 18, 1), // key: oynpb5
    ElIconPathElement('M7 3v18'), // key: bbkbws
    ElIconPathElement(
      'M20.4 18.9c.2.5-.1 1.1-.6 1.3l-1.9.7c-.5.2-1.1-.1-1.3-.6L11.1 5.1c-.2-.5.1-1.1.6-1.3l1.9-.7c.5-.2 1.1.1 1.3.6Z',
    ), // key: 1qboyk
  ]);

  /// `library.mjs`
  static const ElLucideGlyph library = ElLucideGlyph('library', <ElIconElement>[
    ElIconPathElement('m16 6 4 14'), // key: ji33uf
    ElIconPathElement('M12 6v14'), // key: 1n7gus
    ElIconPathElement('M8 8v12'), // key: 1gg7y9
    ElIconPathElement('M4 4v16'), // key: 6qkkli
  ]);

  /// `life-buoy.mjs`
  static const ElLucideGlyph lifeBuoy = ElLucideGlyph(
    'life-buoy',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 10), // key: 1mglay
      ElIconPathElement('m4.93 4.93 4.24 4.24'), // key: 1ymg45
      ElIconPathElement('m14.83 9.17 4.24-4.24'), // key: 1cb5xl
      ElIconPathElement('m14.83 14.83 4.24 4.24'), // key: q42g0n
      ElIconPathElement('m9.17 14.83-4.24 4.24'), // key: bqpfvv
      ElIconCircleElement(12, 12, 4), // key: 4exip2
    ],
  );

  /// `ligature.mjs`
  static const ElLucideGlyph ligature = ElLucideGlyph(
    'ligature',
    <ElIconElement>[
      ElIconPathElement('M14 12h2v8'), // key: c1fccl
      ElIconPathElement('M14 20h4'), // key: lzx1xo
      ElIconPathElement('M6 12h4'), // key: a4o3ry
      ElIconPathElement('M6 20h4'), // key: 1i6q5t
      ElIconPathElement('M8 20V8a4 4 0 0 1 7.464-2'), // key: wk9t6r
    ],
  );

  /// `lightbulb-off.mjs`
  static const ElLucideGlyph lightbulbOff = ElLucideGlyph(
    'lightbulb-off',
    <ElIconElement>[
      ElIconPathElement(
        'M16.8 11.2c.8-.9 1.2-2 1.2-3.2a6 6 0 0 0-9.3-5',
      ), // key: 1fkcox
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
      ElIconPathElement(
        'M6.3 6.3a4.67 4.67 0 0 0 1.2 5.2c.7.7 1.3 1.5 1.5 2.5',
      ), // key: 10m8kw
      ElIconPathElement('M9 18h6'), // key: x1upvd
      ElIconPathElement('M10 22h4'), // key: ceow96
    ],
  );

  /// `lightbulb.mjs`
  static const ElLucideGlyph
  lightbulb = ElLucideGlyph('lightbulb', <ElIconElement>[
    ElIconPathElement(
      'M15 14c.2-1 .7-1.7 1.5-2.5 1-.9 1.5-2.2 1.5-3.5A6 6 0 0 0 6 8c0 1 .2 2.2 1.5 3.5.7.7 1.3 1.5 1.5 2.5',
    ), // key: 1gvzjb
    ElIconPathElement('M9 18h6'), // key: x1upvd
    ElIconPathElement('M10 22h4'), // key: ceow96
  ]);

  /// `line-dot-right-horizontal.mjs`
  static const ElLucideGlyph lineDotRightHorizontal = ElLucideGlyph(
    'line-dot-right-horizontal',
    <ElIconElement>[
      ElIconPathElement('M 3 12 L 15 12'), // key: ymhu98
      ElIconCircleElement(18, 12, 3), // key: 1kchzo
    ],
  );

  /// `line-squiggle.mjs`
  static const ElLucideGlyph
  lineSquiggle = ElLucideGlyph('line-squiggle', <ElIconElement>[
    ElIconPathElement(
      'M7 3.5c5-2 7 2.5 3 4C1.5 10 2 15 5 16c5 2 9-10 14-7s.5 13.5-4 12c-5-2.5.5-11 6-2',
    ), // key: 1lrphd
  ]);

  /// `line-style.mjs`
  static const ElLucideGlyph lineStyle = ElLucideGlyph(
    'line-style',
    <ElIconElement>[
      ElIconPathElement('M11 5h2'), // key: 1s6z07
      ElIconPathElement('M15 12h6'), // key: upa0zy
      ElIconPathElement('M19 5h2'), // key: fjylsg
      ElIconPathElement('M3 12h6'), // key: ra68u1
      ElIconPathElement('M3 19h18'), // key: awlh7x
      ElIconPathElement('M3 5h2'), // key: 1qgu90
    ],
  );

  /// `link-2-off.mjs`
  static const ElLucideGlyph link2Off = ElLucideGlyph(
    'link-2-off',
    <ElIconElement>[
      ElIconPathElement('M9 17H7A5 5 0 0 1 7 7'), // key: 10o201
      ElIconPathElement('M15 7h2a5 5 0 0 1 4 8'), // key: 1d3206
      ElIconLineElement(8, 12, 12, 12), // key: rvw6j4
      ElIconLineElement(2, 2, 22, 22), // key: a6p6uj
    ],
  );

  /// `link-2.mjs`
  static const ElLucideGlyph link2 = ElLucideGlyph('link-2', <ElIconElement>[
    ElIconPathElement('M9 17H7A5 5 0 0 1 7 7h2'), // key: 8i5ue5
    ElIconPathElement('M15 7h2a5 5 0 1 1 0 10h-2'), // key: 1b9ql8
    ElIconLineElement(8, 12, 16, 12), // key: 1jonct
  ]);

  /// `link.mjs`
  static const ElLucideGlyph link = ElLucideGlyph('link', <ElIconElement>[
    ElIconPathElement(
      'M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71',
    ), // key: 1cjeqo
    ElIconPathElement(
      'M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71',
    ), // key: 19qd67
  ]);

  /// `list-check.mjs`
  static const ElLucideGlyph listCheck = ElLucideGlyph(
    'list-check',
    <ElIconElement>[
      ElIconPathElement('M16 5H3'), // key: m91uny
      ElIconPathElement('M16 12H3'), // key: 1a2rj7
      ElIconPathElement('M11 19H3'), // key: zflm78
      ElIconPathElement('m15 18 2 2 4-4'), // key: 1szwhi
    ],
  );

  /// `list-checks.mjs`
  static const ElLucideGlyph listChecks = ElLucideGlyph(
    'list-checks',
    <ElIconElement>[
      ElIconPathElement('M13 5h8'), // key: a7qcls
      ElIconPathElement('M13 12h8'), // key: h98zly
      ElIconPathElement('M13 19h8'), // key: c3s6r1
      ElIconPathElement('m3 17 2 2 4-4'), // key: 1jhpwq
      ElIconPathElement('m3 7 2 2 4-4'), // key: 1obspn
    ],
  );

  /// `list-chevrons-down-up.mjs`
  static const ElLucideGlyph listChevronsDownUp = ElLucideGlyph(
    'list-chevrons-down-up',
    <ElIconElement>[
      ElIconPathElement('M3 5h8'), // key: 18g2rq
      ElIconPathElement('M3 12h8'), // key: 1xfjp6
      ElIconPathElement('M3 19h8'), // key: fpbke4
      ElIconPathElement('m15 5 3 3 3-3'), // key: 1t4thf
      ElIconPathElement('m15 19 3-3 3 3'), // key: y4ckd2
    ],
  );

  /// `list-chevrons-up-down.mjs`
  static const ElLucideGlyph listChevronsUpDown = ElLucideGlyph(
    'list-chevrons-up-down',
    <ElIconElement>[
      ElIconPathElement('M3 5h8'), // key: 18g2rq
      ElIconPathElement('M3 12h8'), // key: 1xfjp6
      ElIconPathElement('M3 19h8'), // key: fpbke4
      ElIconPathElement('m15 8 3-3 3 3'), // key: bc4io6
      ElIconPathElement('m15 16 3 3 3-3'), // key: 9wmg1l
    ],
  );

  /// `list-collapse.mjs`
  static const ElLucideGlyph listCollapse = ElLucideGlyph(
    'list-collapse',
    <ElIconElement>[
      ElIconPathElement('M10 5h11'), // key: 1hkqpe
      ElIconPathElement('M10 12h11'), // key: 6m4ad9
      ElIconPathElement('M10 19h11'), // key: 14g2nv
      ElIconPathElement('m3 10 3-3-3-3'), // key: i7pm08
      ElIconPathElement('m3 20 3-3-3-3'), // key: 20gx1n
    ],
  );

  /// `list-end.mjs`
  static const ElLucideGlyph listEnd = ElLucideGlyph(
    'list-end',
    <ElIconElement>[
      ElIconPathElement('M16 5H3'), // key: m91uny
      ElIconPathElement('M16 12H3'), // key: 1a2rj7
      ElIconPathElement('M9 19H3'), // key: s61nz1
      ElIconPathElement('m16 16-3 3 3 3'), // key: 117b85
      ElIconPathElement('M21 5v12a2 2 0 0 1-2 2h-6'), // key: hey24a
    ],
  );

  /// `list-filter-plus.mjs`
  static const ElLucideGlyph listFilterPlus = ElLucideGlyph(
    'list-filter-plus',
    <ElIconElement>[
      ElIconPathElement('M12 5H2'), // key: 1o22fu
      ElIconPathElement('M6 12h12'), // key: 8npq4p
      ElIconPathElement('M9 19h6'), // key: 456am0
      ElIconPathElement('M16 5h6'), // key: 1vod17
      ElIconPathElement('M19 8V2'), // key: 1wcffq
    ],
  );

  /// `list-filter.mjs`
  static const ElLucideGlyph listFilter = ElLucideGlyph(
    'list-filter',
    <ElIconElement>[
      ElIconPathElement('M2 5h20'), // key: 1fs1ex
      ElIconPathElement('M6 12h12'), // key: 8npq4p
      ElIconPathElement('M9 19h6'), // key: 456am0
    ],
  );

  /// `list-indent-decrease.mjs`
  static const ElLucideGlyph listIndentDecrease = ElLucideGlyph(
    'list-indent-decrease',
    <ElIconElement>[
      ElIconPathElement('M21 5H11'), // key: us1j55
      ElIconPathElement('M21 12H11'), // key: wd7e0v
      ElIconPathElement('M21 19H11'), // key: saa85w
      ElIconPathElement('m7 8-4 4 4 4'), // key: o5hrat
    ],
  );

  /// `list-indent-increase.mjs`
  static const ElLucideGlyph listIndentIncrease = ElLucideGlyph(
    'list-indent-increase',
    <ElIconElement>[
      ElIconPathElement('M21 5H11'), // key: us1j55
      ElIconPathElement('M21 12H11'), // key: wd7e0v
      ElIconPathElement('M21 19H11'), // key: saa85w
      ElIconPathElement('m3 8 4 4-4 4'), // key: 1a3j6y
    ],
  );

  /// `list-minus.mjs`
  static const ElLucideGlyph listMinus = ElLucideGlyph(
    'list-minus',
    <ElIconElement>[
      ElIconPathElement('M16 5H3'), // key: m91uny
      ElIconPathElement('M11 12H3'), // key: 51ecnj
      ElIconPathElement('M16 19H3'), // key: zzsher
      ElIconPathElement('M21 12h-6'), // key: bt1uis
    ],
  );

  /// `list-music.mjs`
  static const ElLucideGlyph listMusic = ElLucideGlyph(
    'list-music',
    <ElIconElement>[
      ElIconPathElement('M16 5H3'), // key: m91uny
      ElIconPathElement('M11 12H3'), // key: 51ecnj
      ElIconPathElement('M11 19H3'), // key: zflm78
      ElIconPathElement('M21 16V5'), // key: yxg4q8
      ElIconCircleElement(18, 16, 3), // key: 1hluhg
    ],
  );

  /// `list-ordered.mjs`
  static const ElLucideGlyph listOrdered = ElLucideGlyph(
    'list-ordered',
    <ElIconElement>[
      ElIconPathElement('M11 5h10'), // key: 1cz7ny
      ElIconPathElement('M11 12h10'), // key: 1438ji
      ElIconPathElement('M11 19h10'), // key: 11t30w
      ElIconPathElement('M4 4h1v5'), // key: 10yrso
      ElIconPathElement('M4 9h2'), // key: r1h2o0
      ElIconPathElement(
        'M6.5 20H3.4c0-1 2.6-1.925 2.6-3.5a1.5 1.5 0 0 0-2.6-1.02',
      ), // key: xtkcd5
    ],
  );

  /// `list-plus.mjs`
  static const ElLucideGlyph listPlus = ElLucideGlyph(
    'list-plus',
    <ElIconElement>[
      ElIconPathElement('M16 5H3'), // key: m91uny
      ElIconPathElement('M11 12H3'), // key: 51ecnj
      ElIconPathElement('M16 19H3'), // key: zzsher
      ElIconPathElement('M18 9v6'), // key: 1twb98
      ElIconPathElement('M21 12h-6'), // key: bt1uis
    ],
  );

  /// `list-restart.mjs`
  static const ElLucideGlyph
  listRestart = ElLucideGlyph('list-restart', <ElIconElement>[
    ElIconPathElement('M21 5H3'), // key: 1fi0y6
    ElIconPathElement('M7 12H3'), // key: 13ou7f
    ElIconPathElement('M7 19H3'), // key: wbqt3n
    ElIconPathElement(
      'M12 18a5 5 0 0 0 9-3 4.5 4.5 0 0 0-4.5-4.5c-1.33 0-2.54.54-3.41 1.41L11 14',
    ), // key: qth677
    ElIconPathElement('M11 10v4h4'), // key: 172dkj
  ]);

  /// `list-sort-ascending.mjs`
  static const ElLucideGlyph listSortAscending = ElLucideGlyph(
    'list-sort-ascending',
    <ElIconElement>[
      ElIconPathElement('M3 19h18'), // key: awlh7x
      ElIconPathElement('M15 12H3'), // key: 6jk70r
      ElIconPathElement('M9 5H3'), // key: 15j2za
    ],
  );

  /// `list-sort-descending.mjs`
  static const ElLucideGlyph listSortDescending = ElLucideGlyph(
    'list-sort-descending',
    <ElIconElement>[
      ElIconPathElement('M15 12H3'), // key: 6jk70r
      ElIconPathElement('M3 5h18'), // key: 1u36vt
      ElIconPathElement('M9 19H3'), // key: s61nz1
    ],
  );

  /// `list-start.mjs`
  static const ElLucideGlyph listStart = ElLucideGlyph(
    'list-start',
    <ElIconElement>[
      ElIconPathElement('M3 5h6'), // key: 1ltk0q
      ElIconPathElement('M3 12h13'), // key: ppymz1
      ElIconPathElement('M3 19h13'), // key: bpdczq
      ElIconPathElement('m16 8-3-3 3-3'), // key: 1pjpp6
      ElIconPathElement('M21 19V7a2 2 0 0 0-2-2h-6'), // key: 4zzq67
    ],
  );

  /// `list-todo.mjs`
  static const ElLucideGlyph listTodo = ElLucideGlyph(
    'list-todo',
    <ElIconElement>[
      ElIconPathElement('M13 5h8'), // key: a7qcls
      ElIconPathElement('M13 12h8'), // key: h98zly
      ElIconPathElement('M13 19h8'), // key: c3s6r1
      ElIconPathElement('m3 17 2 2 4-4'), // key: 1jhpwq
      ElIconRectElement(3, 4, 6, 6, 1), // key: cif1o7
    ],
  );

  /// `list-tree.mjs`
  static const ElLucideGlyph listTree = ElLucideGlyph(
    'list-tree',
    <ElIconElement>[
      ElIconPathElement('M8 5h13'), // key: 1pao27
      ElIconPathElement('M13 12h8'), // key: h98zly
      ElIconPathElement('M13 19h8'), // key: c3s6r1
      ElIconPathElement('M3 10a2 2 0 0 0 2 2h3'), // key: 1npucw
      ElIconPathElement('M3 5v12a2 2 0 0 0 2 2h3'), // key: x1gjn2
    ],
  );

  /// `list-video.mjs`
  static const ElLucideGlyph
  listVideo = ElLucideGlyph('list-video', <ElIconElement>[
    ElIconPathElement('M21 5H3'), // key: 1fi0y6
    ElIconPathElement('M10 12H3'), // key: 1ulcyk
    ElIconPathElement('M10 19H3'), // key: 108z41
    ElIconPathElement(
      'M15 12.003a1 1 0 0 1 1.517-.859l4.997 2.997a1 1 0 0 1 0 1.718l-4.997 2.997a1 1 0 0 1-1.517-.86z',
    ), // key: ms4nik
  ]);

  /// `list-x.mjs`
  static const ElLucideGlyph listX = ElLucideGlyph('list-x', <ElIconElement>[
    ElIconPathElement('M16 5H3'), // key: m91uny
    ElIconPathElement('M11 12H3'), // key: 51ecnj
    ElIconPathElement('M16 19H3'), // key: zzsher
    ElIconPathElement('m15.5 9.5 5 5'), // key: ytk86i
    ElIconPathElement('m20.5 9.5-5 5'), // key: 17o44f
  ]);

  /// `list.mjs`
  static const ElLucideGlyph list = ElLucideGlyph('list', <ElIconElement>[
    ElIconPathElement('M3 5h.01'), // key: 18ugdj
    ElIconPathElement('M3 12h.01'), // key: nlz23k
    ElIconPathElement('M3 19h.01'), // key: noohij
    ElIconPathElement('M8 5h13'), // key: 1pao27
    ElIconPathElement('M8 12h13'), // key: 1za7za
    ElIconPathElement('M8 19h13'), // key: m83p4d
  ]);

  /// `loader-circle.mjs`
  static const ElLucideGlyph loaderCircle = ElLucideGlyph(
    'loader-circle',
    <ElIconElement>[
      ElIconPathElement('M21 12a9 9 0 1 1-6.219-8.56'), // key: 13zald
    ],
  );

  /// `loader-pinwheel.mjs`
  static const ElLucideGlyph
  loaderPinwheel = ElLucideGlyph('loader-pinwheel', <ElIconElement>[
    ElIconPathElement('M22 12a1 1 0 0 1-10 0 1 1 0 0 0-10 0'), // key: 1lzz15
    ElIconPathElement('M7 20.7a1 1 0 1 1 5-8.7 1 1 0 1 0 5-8.6'), // key: 1gnrpi
    ElIconPathElement('M7 3.3a1 1 0 1 1 5 8.6 1 1 0 1 0 5 8.6'), // key: u9yy5q
    ElIconCircleElement(12, 12, 10), // key: 1mglay
  ]);

  /// `loader.mjs`
  static const ElLucideGlyph loader = ElLucideGlyph('loader', <ElIconElement>[
    ElIconPathElement('M12 2v4'), // key: 3427ic
    ElIconPathElement('m16.2 7.8 2.9-2.9'), // key: r700ao
    ElIconPathElement('M18 12h4'), // key: wj9ykh
    ElIconPathElement('m16.2 16.2 2.9 2.9'), // key: 1bxg5t
    ElIconPathElement('M12 18v4'), // key: jadmvz
    ElIconPathElement('m4.9 19.1 2.9-2.9'), // key: bwix9q
    ElIconPathElement('M2 12h4'), // key: j09sii
    ElIconPathElement('m4.9 4.9 2.9 2.9'), // key: giyufr
  ]);

  /// `locate-fixed.mjs`
  static const ElLucideGlyph locateFixed = ElLucideGlyph(
    'locate-fixed',
    <ElIconElement>[
      ElIconLineElement(2, 12, 5, 12), // key: bvdh0s
      ElIconLineElement(19, 12, 22, 12), // key: 1tbv5k
      ElIconLineElement(12, 2, 12, 5), // key: 11lu5j
      ElIconLineElement(12, 19, 12, 22), // key: x3vr5v
      ElIconCircleElement(12, 12, 7), // key: fim9np
      ElIconCircleElement(12, 12, 3), // key: 1v7zrd
    ],
  );

  /// `locate-off.mjs`
  static const ElLucideGlyph locateOff = ElLucideGlyph(
    'locate-off',
    <ElIconElement>[
      ElIconPathElement('M12 19v3'), // key: npa21l
      ElIconPathElement('M12 2v3'), // key: qbqxhf
      ElIconPathElement('M18.89 13.24a7 7 0 0 0-8.13-8.13'), // key: 1v9jrh
      ElIconPathElement('M19 12h3'), // key: osuazr
      ElIconPathElement('M2 12h3'), // key: 1wrr53
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
      ElIconPathElement('M7.05 7.05a7 7 0 0 0 9.9 9.9'), // key: rc5l2e
    ],
  );

  /// `locate.mjs`
  static const ElLucideGlyph locate = ElLucideGlyph('locate', <ElIconElement>[
    ElIconLineElement(2, 12, 5, 12), // key: bvdh0s
    ElIconLineElement(19, 12, 22, 12), // key: 1tbv5k
    ElIconLineElement(12, 2, 12, 5), // key: 11lu5j
    ElIconLineElement(12, 19, 12, 22), // key: x3vr5v
    ElIconCircleElement(12, 12, 7), // key: fim9np
  ]);

  /// `lock-keyhole-open.mjs`
  static const ElLucideGlyph lockKeyholeOpen = ElLucideGlyph(
    'lock-keyhole-open',
    <ElIconElement>[
      ElIconCircleElement(12, 16, 1), // key: 1au0dj
      ElIconRectElement(3, 10, 18, 12, 2), // key: l0tzu3
      ElIconPathElement('M7 10V7a5 5 0 0 1 9.33-2.5'), // key: car5b7
    ],
  );

  /// `lock-keyhole.mjs`
  static const ElLucideGlyph lockKeyhole = ElLucideGlyph(
    'lock-keyhole',
    <ElIconElement>[
      ElIconCircleElement(12, 16, 1), // key: 1au0dj
      ElIconRectElement(3, 10, 18, 12, 2), // key: 6s8ecr
      ElIconPathElement('M7 10V7a5 5 0 0 1 10 0v3'), // key: 1pqi11
    ],
  );

  /// `lock-open.mjs`
  static const ElLucideGlyph lockOpen = ElLucideGlyph(
    'lock-open',
    <ElIconElement>[
      ElIconRectElement(3, 11, 18, 11, 2, ry: 2), // key: 1w4ew1
      ElIconPathElement('M7 11V7a5 5 0 0 1 9.9-1'), // key: 1mm8w8
    ],
  );

  /// `lock.mjs`
  static const ElLucideGlyph lock = ElLucideGlyph('lock', <ElIconElement>[
    ElIconRectElement(3, 11, 18, 11, 2, ry: 2), // key: 1w4ew1
    ElIconPathElement('M7 11V7a5 5 0 0 1 10 0v4'), // key: fwvmzm
  ]);

  /// `log-in.mjs`
  static const ElLucideGlyph logIn = ElLucideGlyph('log-in', <ElIconElement>[
    ElIconPathElement('m10 17 5-5-5-5'), // key: 1bsop3
    ElIconPathElement('M15 12H3'), // key: 6jk70r
    ElIconPathElement(
      'M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4',
    ), // key: u53s6r
  ]);

  /// `log-out.mjs`
  static const ElLucideGlyph logOut = ElLucideGlyph('log-out', <ElIconElement>[
    ElIconPathElement('m16 17 5-5-5-5'), // key: 1bji2h
    ElIconPathElement('M21 12H9'), // key: dn1m92
    ElIconPathElement('M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4'), // key: 1uf3rs
  ]);

  /// `logs.mjs`
  static const ElLucideGlyph logs = ElLucideGlyph('logs', <ElIconElement>[
    ElIconPathElement('M3 5h1'), // key: 1mv5vm
    ElIconPathElement('M3 12h1'), // key: lp3yf2
    ElIconPathElement('M3 19h1'), // key: w6f3n9
    ElIconPathElement('M8 5h1'), // key: 1nxr5w
    ElIconPathElement('M8 12h1'), // key: 1con00
    ElIconPathElement('M8 19h1'), // key: k7p10e
    ElIconPathElement('M13 5h8'), // key: a7qcls
    ElIconPathElement('M13 12h8'), // key: h98zly
    ElIconPathElement('M13 19h8'), // key: c3s6r1
  ]);

  /// `lollipop.mjs`
  static const ElLucideGlyph lollipop = ElLucideGlyph(
    'lollipop',
    <ElIconElement>[
      ElIconCircleElement(11, 11, 8), // key: 4ej97u
      ElIconPathElement('m21 21-4.3-4.3'), // key: 1qie3q
      ElIconPathElement(
        'M11 11a2 2 0 0 0 4 0 4 4 0 0 0-8 0 6 6 0 0 0 12 0',
      ), // key: 107gwy
    ],
  );

  /// `luggage.mjs`
  static const ElLucideGlyph luggage = ElLucideGlyph('luggage', <ElIconElement>[
    ElIconPathElement(
      'M6 20a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2',
    ), // key: 1m57jg
    ElIconPathElement(
      'M8 18V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v14',
    ), // key: 1l99gc
    ElIconPathElement('M10 20h4'), // key: ni2waw
    ElIconCircleElement(16, 20, 2), // key: 1vifvg
    ElIconCircleElement(8, 20, 2), // key: ckkr5m
  ]);

  /// `magnet.mjs`
  static const ElLucideGlyph magnet = ElLucideGlyph('magnet', <ElIconElement>[
    ElIconPathElement('m12 15 4 4'), // key: lnac28
    ElIconPathElement(
      'M2.352 10.648a1.205 1.205 0 0 0 0 1.704l2.296 2.296a1.205 1.205 0 0 0 1.704 0l6.029-6.029a1 1 0 1 1 3 3l-6.029 6.029a1.205 1.205 0 0 0 0 1.704l2.296 2.296a1.205 1.205 0 0 0 1.704 0l6.365-6.367A1 1 0 0 0 8.716 4.282z',
    ), // key: nlhkjb
    ElIconPathElement('m5 8 4 4'), // key: j6kj7e
  ]);

  /// `mail-check.mjs`
  static const ElLucideGlyph mailCheck = ElLucideGlyph(
    'mail-check',
    <ElIconElement>[
      ElIconPathElement(
        'M22 13V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h8',
      ), // key: 12jkf8
      ElIconPathElement(
        'm22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7',
      ), // key: 1ocrg3
      ElIconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
    ],
  );

  /// `mail-minus.mjs`
  static const ElLucideGlyph mailMinus = ElLucideGlyph(
    'mail-minus',
    <ElIconElement>[
      ElIconPathElement(
        'M22 15V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h8',
      ), // key: fuxbkv
      ElIconPathElement(
        'm22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7',
      ), // key: 1ocrg3
      ElIconPathElement('M16 19h6'), // key: xwg31i
    ],
  );

  /// `mail-open.mjs`
  static const ElLucideGlyph
  mailOpen = ElLucideGlyph('mail-open', <ElIconElement>[
    ElIconPathElement(
      'M21.2 8.4c.5.38.8.97.8 1.6v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V10a2 2 0 0 1 .8-1.6l8-6a2 2 0 0 1 2.4 0l8 6Z',
    ), // key: 1jhwl8
    ElIconPathElement(
      'm22 10-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 10',
    ), // key: 1qfld7
  ]);

  /// `mail-plus.mjs`
  static const ElLucideGlyph mailPlus = ElLucideGlyph(
    'mail-plus',
    <ElIconElement>[
      ElIconPathElement(
        'M22 13V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h8',
      ), // key: 12jkf8
      ElIconPathElement(
        'm22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7',
      ), // key: 1ocrg3
      ElIconPathElement('M19 16v6'), // key: tddt3s
      ElIconPathElement('M16 19h6'), // key: xwg31i
    ],
  );

  /// `mail-question-mark.mjs`
  static const ElLucideGlyph
  mailQuestionMark = ElLucideGlyph('mail-question-mark', <ElIconElement>[
    ElIconPathElement(
      'M22 10.5V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h12.5',
    ), // key: e61zoh
    ElIconPathElement(
      'm22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7',
    ), // key: 1ocrg3
    ElIconPathElement(
      'M18 15.28c.2-.4.5-.8.9-1a2.1 2.1 0 0 1 2.6.4c.3.4.5.8.5 1.3 0 1.3-2 2-2 2',
    ), // key: 7z9rxb
    ElIconPathElement('M20 22v.01'), // key: 12bgn6
  ]);

  /// `mail-search.mjs`
  static const ElLucideGlyph mailSearch = ElLucideGlyph(
    'mail-search',
    <ElIconElement>[
      ElIconPathElement(
        'M22 12.5V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h7.5',
      ), // key: w80f2v
      ElIconPathElement(
        'm22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7',
      ), // key: 1ocrg3
      ElIconPathElement('M18 21a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z'), // key: 8lzu5m
      ElIconCircleElement(18, 18, 3), // key: 1xkwt0
      ElIconPathElement('m22 22-1.5-1.5'), // key: 1x83k4
    ],
  );

  /// `mail-warning.mjs`
  static const ElLucideGlyph mailWarning = ElLucideGlyph(
    'mail-warning',
    <ElIconElement>[
      ElIconPathElement(
        'M22 10.5V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h12.5',
      ), // key: e61zoh
      ElIconPathElement(
        'm22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7',
      ), // key: 1ocrg3
      ElIconPathElement('M20 14v4'), // key: 1hm744
      ElIconPathElement('M20 22v.01'), // key: 12bgn6
    ],
  );

  /// `mail-x.mjs`
  static const ElLucideGlyph mailX = ElLucideGlyph('mail-x', <ElIconElement>[
    ElIconPathElement(
      'M22 13V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h9',
    ), // key: 1j9vog
    ElIconPathElement(
      'm22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7',
    ), // key: 1ocrg3
    ElIconPathElement('m17 17 4 4'), // key: 1b3523
    ElIconPathElement('m21 17-4 4'), // key: uinynz
  ]);

  /// `mail.mjs`
  static const ElLucideGlyph mail = ElLucideGlyph('mail', <ElIconElement>[
    ElIconPathElement('m22 7-8.991 5.727a2 2 0 0 1-2.009 0L2 7'), // key: 132q7q
    ElIconRectElement(2, 4, 20, 16, 2), // key: izxlao
  ]);

  /// `mailbox.mjs`
  static const ElLucideGlyph mailbox = ElLucideGlyph('mailbox', <ElIconElement>[
    ElIconPathElement(
      'M22 17a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V9.5C2 7 4 5 6.5 5H18c2.2 0 4 1.8 4 4v8Z',
    ), // key: 1lbycx
    ElIconPolylineElement(<Offset>[
      Offset(15, 9),
      Offset(18, 9),
      Offset(18, 11),
    ]), // key: 1pm9c0
    ElIconPathElement('M6.5 5C9 5 11 7 11 9.5V17a2 2 0 0 1-2 2'), // key: 15i455
    ElIconLineElement(6, 10, 7, 10), // key: 1e2scm
  ]);

  /// `mails.mjs`
  static const ElLucideGlyph mails = ElLucideGlyph('mails', <ElIconElement>[
    ElIconPathElement(
      'M17 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-8a2 2 0 0 1 1-1.732',
    ), // key: 1vyzll
    ElIconPathElement(
      'm22 5.5-6.419 4.179a2 2 0 0 1-2.162 0L7 5.5',
    ), // key: k7ramc
    ElIconRectElement(7, 3, 15, 12, 2), // key: 17196g
  ]);

  /// `map-minus.mjs`
  static const ElLucideGlyph
  mapMinus = ElLucideGlyph('map-minus', <ElIconElement>[
    ElIconPathElement(
      'm11 19-1.106-.552a2 2 0 0 0-1.788 0l-3.659 1.83A1 1 0 0 1 3 19.381V6.618a1 1 0 0 1 .553-.894l4.553-2.277a2 2 0 0 1 1.788 0l4.212 2.106a2 2 0 0 0 1.788 0l3.659-1.83A1 1 0 0 1 21 4.619V14',
    ), // key: 40pylx
    ElIconPathElement('M15 5.764V14'), // key: 1bab71
    ElIconPathElement('M21 18h-6'), // key: 139f0c
    ElIconPathElement('M9 3.236v15'), // key: 1uimfh
  ]);

  /// `map-pin-check-inside.mjs`
  static const ElLucideGlyph
  mapPinCheckInside = ElLucideGlyph('map-pin-check-inside', <ElIconElement>[
    ElIconPathElement(
      'M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0',
    ), // key: 1r0f0z
    ElIconPathElement('m9 10 2 2 4-4'), // key: 1gnqz4
  ]);

  /// `map-pin-check.mjs`
  static const ElLucideGlyph
  mapPinCheck = ElLucideGlyph('map-pin-check', <ElIconElement>[
    ElIconPathElement(
      'M19.43 12.935c.357-.967.57-1.955.57-2.935a8 8 0 0 0-16 0c0 4.993 5.539 10.193 7.399 11.799a1 1 0 0 0 1.202 0 32.197 32.197 0 0 0 .813-.728',
    ), // key: 1dq61d
    ElIconCircleElement(12, 10, 3), // key: ilqhr7
    ElIconPathElement('m16 18 2 2 4-4'), // key: 1mkfmb
  ]);

  /// `map-pin-house.mjs`
  static const ElLucideGlyph
  mapPinHouse = ElLucideGlyph('map-pin-house', <ElIconElement>[
    ElIconPathElement(
      'M15 22a1 1 0 0 1-1-1v-4a1 1 0 0 1 .445-.832l3-2a1 1 0 0 1 1.11 0l3 2A1 1 0 0 1 22 17v4a1 1 0 0 1-1 1z',
    ), // key: 1p1rcz
    ElIconPathElement(
      'M18 10a8 8 0 0 0-16 0c0 4.993 5.539 10.193 7.399 11.799a1 1 0 0 0 .601.2',
    ), // key: mcbcs9
    ElIconPathElement('M18 22v-3'), // key: 1t1ugv
    ElIconCircleElement(10, 10, 3), // key: 1ns7v1
  ]);

  /// `map-pin-minus-inside.mjs`
  static const ElLucideGlyph
  mapPinMinusInside = ElLucideGlyph('map-pin-minus-inside', <ElIconElement>[
    ElIconPathElement(
      'M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0',
    ), // key: 1r0f0z
    ElIconPathElement('M9 10h6'), // key: 9gxzsh
  ]);

  /// `map-pin-minus.mjs`
  static const ElLucideGlyph
  mapPinMinus = ElLucideGlyph('map-pin-minus', <ElIconElement>[
    ElIconPathElement(
      'M18.977 14C19.6 12.701 20 11.343 20 10a8 8 0 0 0-16 0c0 4.993 5.539 10.193 7.399 11.799a1 1 0 0 0 1.202 0 32 32 0 0 0 .824-.738',
    ), // key: 11uxia
    ElIconCircleElement(12, 10, 3), // key: ilqhr7
    ElIconPathElement('M16 18h6'), // key: 987eiv
  ]);

  /// `map-pin-off.mjs`
  static const ElLucideGlyph
  mapPinOff = ElLucideGlyph('map-pin-off', <ElIconElement>[
    ElIconPathElement('M12.75 7.09a3 3 0 0 1 2.16 2.16'), // key: 1d4wjd
    ElIconPathElement(
      'M17.072 17.072c-1.634 2.17-3.527 3.912-4.471 4.727a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 1.432-4.568',
    ), // key: 12yil7
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement(
      'M8.475 2.818A8 8 0 0 1 20 10c0 1.183-.31 2.377-.81 3.533',
    ), // key: lhrkcz
    ElIconPathElement('M9.13 9.13a3 3 0 0 0 3.74 3.74'), // key: 13wojd
  ]);

  /// `map-pin-pen.mjs`
  static const ElLucideGlyph
  mapPinPen = ElLucideGlyph('map-pin-pen', <ElIconElement>[
    ElIconPathElement(
      'M17.97 9.304A8 8 0 0 0 2 10c0 4.69 4.887 9.562 7.022 11.468',
    ), // key: 1fahp3
    ElIconPathElement(
      'M21.378 16.626a1 1 0 0 0-3.004-3.004l-4.01 4.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z',
    ), // key: 1817ys
    ElIconCircleElement(10, 10, 3), // key: 1ns7v1
  ]);

  /// `map-pin-plus-inside.mjs`
  static const ElLucideGlyph
  mapPinPlusInside = ElLucideGlyph('map-pin-plus-inside', <ElIconElement>[
    ElIconPathElement(
      'M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0',
    ), // key: 1r0f0z
    ElIconPathElement('M12 7v6'), // key: lw1j43
    ElIconPathElement('M9 10h6'), // key: 9gxzsh
  ]);

  /// `map-pin-plus.mjs`
  static const ElLucideGlyph
  mapPinPlus = ElLucideGlyph('map-pin-plus', <ElIconElement>[
    ElIconPathElement(
      'M19.914 11.105A7.298 7.298 0 0 0 20 10a8 8 0 0 0-16 0c0 4.993 5.539 10.193 7.399 11.799a1 1 0 0 0 1.202 0 32 32 0 0 0 .824-.738',
    ), // key: fcdtly
    ElIconCircleElement(12, 10, 3), // key: ilqhr7
    ElIconPathElement('M16 18h6'), // key: 987eiv
    ElIconPathElement('M19 15v6'), // key: 10aioa
  ]);

  /// `map-pin-search.mjs`
  static const ElLucideGlyph
  mapPinSearch = ElLucideGlyph('map-pin-search', <ElIconElement>[
    ElIconPathElement(
      'M 12.248 21.969 a 1 1 0 0 1 -0.849 -0.17 C 9.539 20.193 4 14.993 4 10 a 8 8 0 0 1 16 0 C 20 10.42 19.961 10.841 19.888 11.262',
    ), // key: 1jho5b
    ElIconPathElement('m22 22-1.88-1.88'), // key: 1bgjp0
    ElIconCircleElement(12, 10, 3), // key: ilqhr7
    ElIconCircleElement(18, 18, 3), // key: 1xkwt0
  ]);

  /// `map-pin-x-inside.mjs`
  static const ElLucideGlyph
  mapPinXInside = ElLucideGlyph('map-pin-x-inside', <ElIconElement>[
    ElIconPathElement(
      'M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0',
    ), // key: 1r0f0z
    ElIconPathElement('m14.5 7.5-5 5'), // key: 3lb6iw
    ElIconPathElement('m9.5 7.5 5 5'), // key: ko136h
  ]);

  /// `map-pin-x.mjs`
  static const ElLucideGlyph
  mapPinX = ElLucideGlyph('map-pin-x', <ElIconElement>[
    ElIconPathElement(
      'M19.752 11.901A7.78 7.78 0 0 0 20 10a8 8 0 0 0-16 0c0 4.993 5.539 10.193 7.399 11.799a1 1 0 0 0 1.202 0 19 19 0 0 0 .09-.077',
    ), // key: y0ewhp
    ElIconCircleElement(12, 10, 3), // key: ilqhr7
    ElIconPathElement('m21.5 15.5-5 5'), // key: 11iqnx
    ElIconPathElement('m21.5 20.5-5-5'), // key: 1bylgx
  ]);

  /// `map-pin.mjs`
  static const ElLucideGlyph mapPin = ElLucideGlyph('map-pin', <ElIconElement>[
    ElIconPathElement(
      'M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0',
    ), // key: 1r0f0z
    ElIconCircleElement(12, 10, 3), // key: ilqhr7
  ]);

  /// `map-pinned.mjs`
  static const ElLucideGlyph
  mapPinned = ElLucideGlyph('map-pinned', <ElIconElement>[
    ElIconPathElement(
      'M18 8c0 3.613-3.869 7.429-5.393 8.795a1 1 0 0 1-1.214 0C9.87 15.429 6 11.613 6 8a6 6 0 0 1 12 0',
    ), // key: 11u0oz
    ElIconCircleElement(12, 8, 2), // key: 1822b1
    ElIconPathElement(
      'M8.714 14h-3.71a1 1 0 0 0-.948.683l-2.004 6A1 1 0 0 0 3 22h18a1 1 0 0 0 .948-1.316l-2-6a1 1 0 0 0-.949-.684h-3.712',
    ), // key: q8zwxj
  ]);

  /// `map-plus.mjs`
  static const ElLucideGlyph
  mapPlus = ElLucideGlyph('map-plus', <ElIconElement>[
    ElIconPathElement(
      'm11 19-1.106-.552a2 2 0 0 0-1.788 0l-3.659 1.83A1 1 0 0 1 3 19.381V6.618a1 1 0 0 1 .553-.894l4.553-2.277a2 2 0 0 1 1.788 0l4.212 2.106a2 2 0 0 0 1.788 0l3.659-1.83A1 1 0 0 1 21 4.619V12',
    ), // key: svfegj
    ElIconPathElement('M15 5.764V12'), // key: 1ocw4k
    ElIconPathElement('M18 15v6'), // key: 9wciyi
    ElIconPathElement('M21 18h-6'), // key: 139f0c
    ElIconPathElement('M9 3.236v15'), // key: 1uimfh
  ]);

  /// `map.mjs`
  static const ElLucideGlyph map = ElLucideGlyph('map', <ElIconElement>[
    ElIconPathElement(
      'M14.106 5.553a2 2 0 0 0 1.788 0l3.659-1.83A1 1 0 0 1 21 4.619v12.764a1 1 0 0 1-.553.894l-4.553 2.277a2 2 0 0 1-1.788 0l-4.212-2.106a2 2 0 0 0-1.788 0l-3.659 1.83A1 1 0 0 1 3 19.381V6.618a1 1 0 0 1 .553-.894l4.553-2.277a2 2 0 0 1 1.788 0z',
    ), // key: 169xi5
    ElIconPathElement('M15 5.764v15'), // key: 1pn4in
    ElIconPathElement('M9 3.236v15'), // key: 1uimfh
  ]);

  /// `mars-stroke.mjs`
  static const ElLucideGlyph marsStroke = ElLucideGlyph(
    'mars-stroke',
    <ElIconElement>[
      ElIconPathElement('m14 6 4 4'), // key: 1q72g9
      ElIconPathElement('M17 3h4v4'), // key: 19p9u1
      ElIconPathElement('m21 3-7.75 7.75'), // key: 1cjbfd
      ElIconCircleElement(9, 15, 6), // key: bx5svt
    ],
  );

  /// `mars.mjs`
  static const ElLucideGlyph mars = ElLucideGlyph('mars', <ElIconElement>[
    ElIconPathElement('M16 3h5v5'), // key: 1806ms
    ElIconPathElement('m21 3-6.75 6.75'), // key: pv0uzu
    ElIconCircleElement(10, 14, 6), // key: 1qwbdc
  ]);

  /// `martini.mjs`
  static const ElLucideGlyph martini = ElLucideGlyph('martini', <ElIconElement>[
    ElIconPathElement(
      'M12 12 4.207 4.207A.707.707 0 0 1 4.707 3h14.586a.707.707 0 0 1 .5 1.207z',
    ), // key: vxdekd
    ElIconPathElement('M12 12v10'), // key: 1nesaz
    ElIconPathElement('M7 22h10'), // key: 10w4w3
  ]);

  /// `maximize-2.mjs`
  static const ElLucideGlyph maximize2 = ElLucideGlyph(
    'maximize-2',
    <ElIconElement>[
      ElIconPathElement('M15 3h6v6'), // key: 1q9fwt
      ElIconPathElement('m21 3-7 7'), // key: 1l2asr
      ElIconPathElement('m3 21 7-7'), // key: tjx5ai
      ElIconPathElement('M9 21H3v-6'), // key: wtvkvv
    ],
  );

  /// `maximize.mjs`
  static const ElLucideGlyph maximize = ElLucideGlyph(
    'maximize',
    <ElIconElement>[
      ElIconPathElement('M8 3H5a2 2 0 0 0-2 2v3'), // key: 1dcmit
      ElIconPathElement('M21 8V5a2 2 0 0 0-2-2h-3'), // key: 1e4gt3
      ElIconPathElement('M3 16v3a2 2 0 0 0 2 2h3'), // key: wsl5sc
      ElIconPathElement('M16 21h3a2 2 0 0 0 2-2v-3'), // key: 18trek
    ],
  );

  /// `medal.mjs`
  static const ElLucideGlyph medal = ElLucideGlyph('medal', <ElIconElement>[
    ElIconPathElement(
      'M7.21 15 2.66 7.14a2 2 0 0 1 .13-2.2L4.4 2.8A2 2 0 0 1 6 2h12a2 2 0 0 1 1.6.8l1.6 2.14a2 2 0 0 1 .14 2.2L16.79 15',
    ), // key: 143lza
    ElIconPathElement('M11 12 5.12 2.2'), // key: qhuxz6
    ElIconPathElement('m13 12 5.88-9.8'), // key: hbye0f
    ElIconPathElement('M8 7h8'), // key: i86dvs
    ElIconCircleElement(12, 17, 5), // key: qbz8iq
    ElIconPathElement('M12 18v-2h-.5'), // key: fawc4q
  ]);

  /// `megaphone-off.mjs`
  static const ElLucideGlyph megaphoneOff = ElLucideGlyph(
    'megaphone-off',
    <ElIconElement>[
      ElIconPathElement(
        'M11.636 6A13 13 0 0 0 19.4 3.2 1 1 0 0 1 21 4v11.344',
      ), // key: bycexp
      ElIconPathElement(
        'M14.378 14.357A13 13 0 0 0 11 14H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h1',
      ), // key: 1t17s6
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
      ElIconPathElement(
        'M6 14a12 12 0 0 0 2.4 7.2 2 2 0 0 0 3.2-2.4A8 8 0 0 1 10 14',
      ), // key: 1853fq
      ElIconPathElement('M8 8v6'), // key: aieo6v
    ],
  );

  /// `megaphone.mjs`
  static const ElLucideGlyph
  megaphone = ElLucideGlyph('megaphone', <ElIconElement>[
    ElIconPathElement(
      'M11 6a13 13 0 0 0 8.4-2.8A1 1 0 0 1 21 4v12a1 1 0 0 1-1.6.8A13 13 0 0 0 11 14H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2z',
    ), // key: q8bfy3
    ElIconPathElement(
      'M6 14a12 12 0 0 0 2.4 7.2 2 2 0 0 0 3.2-2.4A8 8 0 0 1 10 14',
    ), // key: 1853fq
    ElIconPathElement('M8 6v8'), // key: 15ugcq
  ]);

  /// `meh.mjs`
  static const ElLucideGlyph meh = ElLucideGlyph('meh', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconLineElement(8, 15, 16, 15), // key: 1xb1d9
    ElIconLineElement(9, 9, 9.01, 9), // key: yxxnd0
    ElIconLineElement(15, 9, 15.01, 9), // key: 1p4y9e
  ]);

  /// `memory-stick.mjs`
  static const ElLucideGlyph memoryStick = ElLucideGlyph(
    'memory-stick',
    <ElIconElement>[
      ElIconPathElement('M12 12v-2'), // key: fwoke6
      ElIconPathElement('M12 18v-2'), // key: qj6yno
      ElIconPathElement('M16 12v-2'), // key: heuere
      ElIconPathElement('M16 18v-2'), // key: s1ct0w
      ElIconPathElement('M2 11h1.5'), // key: 15p63e
      ElIconPathElement('M20 18v-2'), // key: 12ehxp
      ElIconPathElement('M20.5 11H22'), // key: khsy7a
      ElIconPathElement('M4 18v-2'), // key: 1c3oqr
      ElIconPathElement('M8 12v-2'), // key: 1mwtfd
      ElIconPathElement('M8 18v-2'), // key: qcmpov
      ElIconRectElement(2, 6, 20, 10, 2), // key: 1qcswk
    ],
  );

  /// `menu.mjs`
  static const ElLucideGlyph menu = ElLucideGlyph('menu', <ElIconElement>[
    ElIconPathElement('M4 5h16'), // key: 1tepv9
    ElIconPathElement('M4 12h16'), // key: 1lakjw
    ElIconPathElement('M4 19h16'), // key: 1djgab
  ]);

  /// `merge.mjs`
  static const ElLucideGlyph merge = ElLucideGlyph('merge', <ElIconElement>[
    ElIconPathElement('m8 6 4-4 4 4'), // key: ybng9g
    ElIconPathElement('M12 2v10.3a4 4 0 0 1-1.172 2.872L4 22'), // key: 1hyw0i
    ElIconPathElement('m20 22-5-5'), // key: 1m27yz
  ]);

  /// `message-circle-check.mjs`
  static const ElLucideGlyph
  messageCircleCheck = ElLucideGlyph('message-circle-check', <ElIconElement>[
    ElIconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
    ElIconPathElement('m9 12 2 2 4-4'), // key: dzmm74
  ]);

  /// `message-circle-code.mjs`
  static const ElLucideGlyph
  messageCircleCode = ElLucideGlyph('message-circle-code', <ElIconElement>[
    ElIconPathElement('m10 9-3 3 3 3'), // key: 1oro0q
    ElIconPathElement('m14 15 3-3-3-3'), // key: bz13h7
    ElIconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
  ]);

  /// `message-circle-dashed.mjs`
  static const ElLucideGlyph messageCircleDashed = ElLucideGlyph(
    'message-circle-dashed',
    <ElIconElement>[
      ElIconPathElement('M10.1 2.182a10 10 0 0 1 3.8 0'), // key: 5ilxe3
      ElIconPathElement('M13.9 21.818a10 10 0 0 1-3.8 0'), // key: 11zvb9
      ElIconPathElement('M17.609 3.72a10 10 0 0 1 2.69 2.7'), // key: jiglxs
      ElIconPathElement('M2.182 13.9a10 10 0 0 1 0-3.8'), // key: c0bmvh
      ElIconPathElement('M20.28 17.61a10 10 0 0 1-2.7 2.69'), // key: elg7ff
      ElIconPathElement('M21.818 10.1a10 10 0 0 1 0 3.8'), // key: qkgqxc
      ElIconPathElement('M3.721 6.391a10 10 0 0 1 2.7-2.69'), // key: 1mcia2
      ElIconPathElement(
        'm6.163 21.117-2.906.85a1 1 0 0 1-1.236-1.169l.965-2.98',
      ), // key: 1qsu07
    ],
  );

  /// `message-circle-heart.mjs`
  static const ElLucideGlyph
  messageCircleHeart = ElLucideGlyph('message-circle-heart', <ElIconElement>[
    ElIconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
    ElIconPathElement(
      'M7.828 13.07A3 3 0 0 1 12 8.764a3 3 0 0 1 5.004 2.224 3 3 0 0 1-.832 2.083l-3.447 3.62a1 1 0 0 1-1.45-.001z',
    ), // key: hoo97p
  ]);

  /// `message-circle-more.mjs`
  static const ElLucideGlyph
  messageCircleMore = ElLucideGlyph('message-circle-more', <ElIconElement>[
    ElIconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
    ElIconPathElement('M8 12h.01'), // key: czm47f
    ElIconPathElement('M12 12h.01'), // key: 1mp3jc
    ElIconPathElement('M16 12h.01'), // key: 1l6xoz
  ]);

  /// `message-circle-off.mjs`
  static const ElLucideGlyph
  messageCircleOff = ElLucideGlyph('message-circle-off', <ElIconElement>[
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement(
      'M4.93 4.929a10 10 0 0 0-1.938 11.412 2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 0 0 11.302-1.989',
    ), // key: 7il5tn
    ElIconPathElement('M8.35 2.69A10 10 0 0 1 21.3 15.65'), // key: 1pfsoa
  ]);

  /// `message-circle-plus.mjs`
  static const ElLucideGlyph
  messageCirclePlus = ElLucideGlyph('message-circle-plus', <ElIconElement>[
    ElIconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
    ElIconPathElement('M8 12h8'), // key: 1wcyev
    ElIconPathElement('M12 8v8'), // key: napkw2
  ]);

  /// `message-circle-question-mark.mjs`
  static const ElLucideGlyph
  messageCircleQuestionMark = ElLucideGlyph('message-circle-question-mark', <
    ElIconElement
  >[
    ElIconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
    ElIconPathElement('M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3'), // key: 1u773s
    ElIconPathElement('M12 17h.01'), // key: p32p05
  ]);

  /// `message-circle-reply.mjs`
  static const ElLucideGlyph
  messageCircleReply = ElLucideGlyph('message-circle-reply', <ElIconElement>[
    ElIconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
    ElIconPathElement('m10 15-3-3 3-3'), // key: 1pgupc
    ElIconPathElement('M7 12h8a2 2 0 0 1 2 2v1'), // key: 89sh1g
  ]);

  /// `message-circle-warning.mjs`
  static const ElLucideGlyph
  messageCircleWarning = ElLucideGlyph('message-circle-warning', <
    ElIconElement
  >[
    ElIconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
    ElIconPathElement('M12 8v4'), // key: 1got3b
    ElIconPathElement('M12 16h.01'), // key: 1drbdi
  ]);

  /// `message-circle-x.mjs`
  static const ElLucideGlyph
  messageCircleX = ElLucideGlyph('message-circle-x', <ElIconElement>[
    ElIconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
    ElIconPathElement('m15 9-6 6'), // key: 1uzhvr
    ElIconPathElement('m9 9 6 6'), // key: z0biqf
  ]);

  /// `message-circle.mjs`
  static const ElLucideGlyph
  messageCircle = ElLucideGlyph('message-circle', <ElIconElement>[
    ElIconPathElement(
      'M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719',
    ), // key: 1sd12s
  ]);

  /// `message-square-check.mjs`
  static const ElLucideGlyph
  messageSquareCheck = ElLucideGlyph('message-square-check', <ElIconElement>[
    ElIconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.7.7 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: m0kn7k
    ElIconPathElement('m9 11 2 2 4-4'), // key: kz4plv
  ]);

  /// `message-square-code.mjs`
  static const ElLucideGlyph
  messageSquareCode = ElLucideGlyph('message-square-code', <ElIconElement>[
    ElIconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    ElIconPathElement('m10 8-3 3 3 3'), // key: fp6dz7
    ElIconPathElement('m14 14 3-3-3-3'), // key: 1yrceu
  ]);

  /// `message-square-dashed.mjs`
  static const ElLucideGlyph messageSquareDashed = ElLucideGlyph(
    'message-square-dashed',
    <ElIconElement>[
      ElIconPathElement('M14 3h2'), // key: 1d12a5
      ElIconPathElement('M16 19h-2'), // key: 1agirb
      ElIconPathElement('M2 12v-2'), // key: 1ey295
      ElIconPathElement(
        'M2 16v5.286a.71.71 0 0 0 1.212.502l1.149-1.149',
      ), // key: 120k8q
      ElIconPathElement('M20 19a2 2 0 0 0 2-2v-1'), // key: ior8tn
      ElIconPathElement('M22 10v2'), // key: rmlecy
      ElIconPathElement('M22 6V5a2 2 0 0 0-2-2'), // key: sp3k6r
      ElIconPathElement('M4 3a2 2 0 0 0-2 2v1'), // key: 11zt7s
      ElIconPathElement('M8 19h2'), // key: jnunrx
      ElIconPathElement('M8 3h2'), // key: ysbsee
    ],
  );

  /// `message-square-diff.mjs`
  static const ElLucideGlyph
  messageSquareDiff = ElLucideGlyph('message-square-diff', <ElIconElement>[
    ElIconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    ElIconPathElement('M10 15h4'), // key: 192ueg
    ElIconPathElement('M10 9h4'), // key: u4k05v
    ElIconPathElement('M12 7v4'), // key: xawao1
  ]);

  /// `message-square-dot.mjs`
  static const ElLucideGlyph
  messageSquareDot = ElLucideGlyph('message-square-dot', <ElIconElement>[
    ElIconPathElement(
      'M12.7 3H4a2 2 0 0 0-2 2v16.286a.71.71 0 0 0 1.212.502l2.202-2.202A2 2 0 0 1 6.828 19H20a2 2 0 0 0 2-2v-4.7',
    ), // key: wjb7ig
    ElIconCircleElement(19, 6, 3), // key: 108a5v
  ]);

  /// `message-square-heart.mjs`
  static const ElLucideGlyph
  messageSquareHeart = ElLucideGlyph('message-square-heart', <ElIconElement>[
    ElIconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    ElIconPathElement(
      'M7.5 9.5c0 .687.265 1.383.697 1.844l3.009 3.264a1.14 1.14 0 0 0 .407.314 1 1 0 0 0 .783-.004 1.14 1.14 0 0 0 .398-.31l3.008-3.264A2.77 2.77 0 0 0 16.5 9.5 2.5 2.5 0 0 0 12 8a2.5 2.5 0 0 0-4.5 1.5',
    ), // key: 1faxuh
  ]);

  /// `message-square-lock.mjs`
  static const ElLucideGlyph
  messageSquareLock = ElLucideGlyph('message-square-lock', <ElIconElement>[
    ElIconPathElement(
      'M22 8.5V5a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v16.286a.71.71 0 0 0 1.212.502l2.202-2.202A2 2 0 0 1 6.828 19H10',
    ), // key: fu6chl
    ElIconPathElement('M20 15v-2a2 2 0 0 0-4 0v2'), // key: vl8a78
    ElIconRectElement(14, 15, 8, 5, 1), // key: 37aafw
  ]);

  /// `message-square-more.mjs`
  static const ElLucideGlyph
  messageSquareMore = ElLucideGlyph('message-square-more', <ElIconElement>[
    ElIconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    ElIconPathElement('M12 11h.01'), // key: z322tv
    ElIconPathElement('M16 11h.01'), // key: xkw8gn
    ElIconPathElement('M8 11h.01'), // key: 1dfujw
  ]);

  /// `message-square-off.mjs`
  static const ElLucideGlyph
  messageSquareOff = ElLucideGlyph('message-square-off', <ElIconElement>[
    ElIconPathElement(
      'M19 19H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.7.7 0 0 1 2 21.286V5a2 2 0 0 1 1.184-1.826',
    ), // key: 1wyg69
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement('M8.656 3H20a2 2 0 0 1 2 2v11.344'), // key: mhl4k6
  ]);

  /// `message-square-plus.mjs`
  static const ElLucideGlyph
  messageSquarePlus = ElLucideGlyph('message-square-plus', <ElIconElement>[
    ElIconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    ElIconPathElement('M12 8v6'), // key: 1ib9pf
    ElIconPathElement('M9 11h6'), // key: 1fldmi
  ]);

  /// `message-square-quote.mjs`
  static const ElLucideGlyph
  messageSquareQuote = ElLucideGlyph('message-square-quote', <ElIconElement>[
    ElIconPathElement('M14 14a2 2 0 0 0 2-2V8h-2'), // key: 1r06pg
    ElIconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    ElIconPathElement('M8 14a2 2 0 0 0 2-2V8H8'), // key: 1jzu5j
  ]);

  /// `message-square-reply.mjs`
  static const ElLucideGlyph
  messageSquareReply = ElLucideGlyph('message-square-reply', <ElIconElement>[
    ElIconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    ElIconPathElement('m10 8-3 3 3 3'), // key: fp6dz7
    ElIconPathElement('M17 14v-1a2 2 0 0 0-2-2H7'), // key: 1tkjnz
  ]);

  /// `message-square-share.mjs`
  static const ElLucideGlyph
  messageSquareShare = ElLucideGlyph('message-square-share', <ElIconElement>[
    ElIconPathElement(
      'M12 3H4a2 2 0 0 0-2 2v16.286a.71.71 0 0 0 1.212.502l2.202-2.202A2 2 0 0 1 6.828 19H20a2 2 0 0 0 2-2v-4',
    ), // key: 11da1y
    ElIconPathElement('M16 3h6v6'), // key: 1bx56c
    ElIconPathElement('m16 9 6-6'), // key: m4dnic
  ]);

  /// `message-square-text.mjs`
  static const ElLucideGlyph
  messageSquareText = ElLucideGlyph('message-square-text', <ElIconElement>[
    ElIconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    ElIconPathElement('M7 11h10'), // key: 1twpyw
    ElIconPathElement('M7 15h6'), // key: d9of3u
    ElIconPathElement('M7 7h8'), // key: af5zfr
  ]);

  /// `message-square-warning.mjs`
  static const ElLucideGlyph
  messageSquareWarning = ElLucideGlyph('message-square-warning', <
    ElIconElement
  >[
    ElIconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    ElIconPathElement('M12 15h.01'), // key: q59x07
    ElIconPathElement('M12 7v4'), // key: xawao1
  ]);

  /// `message-square-x.mjs`
  static const ElLucideGlyph
  messageSquareX = ElLucideGlyph('message-square-x', <ElIconElement>[
    ElIconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
    ElIconPathElement('m14.5 8.5-5 5'), // key: 19tnj2
    ElIconPathElement('m9.5 8.5 5 5'), // key: 1oa8ql
  ]);

  /// `message-square.mjs`
  static const ElLucideGlyph
  messageSquare = ElLucideGlyph('message-square', <ElIconElement>[
    ElIconPathElement(
      'M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z',
    ), // key: 18887p
  ]);

  /// `messages-square.mjs`
  static const ElLucideGlyph
  messagesSquare = ElLucideGlyph('messages-square', <ElIconElement>[
    ElIconPathElement(
      'M16 10a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 14.286V4a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z',
    ), // key: 1n2ejm
    ElIconPathElement(
      'M20 9a2 2 0 0 1 2 2v10.286a.71.71 0 0 1-1.212.502l-2.202-2.202A2 2 0 0 0 17.172 19H10a2 2 0 0 1-2-2v-1',
    ), // key: 1qfcsi
  ]);

  /// `metronome.mjs`
  static const ElLucideGlyph
  metronome = ElLucideGlyph('metronome', <ElIconElement>[
    ElIconPathElement('M12 11.4V9.1'), // key: audfby
    ElIconPathElement('m12 17 6.59-6.59'), // key: c0sb7j
    ElIconPathElement(
      'm15.05 5.7-.218-.691a3 3 0 0 0-5.663 0L4.418 19.695A1 1 0 0 0 5.37 21h13.253a1 1 0 0 0 .951-1.31L18.45 16.2',
    ), // key: 1pkfrk
    ElIconCircleElement(20, 9, 2), // key: 1udoqf
  ]);

  /// `mic-audio-lines.mjs`
  static const ElLucideGlyph micAudioLines = ElLucideGlyph(
    'mic-audio-lines',
    <ElIconElement>[
      ElIconPathElement('M10 3v2.341'), // key: d00509
      ElIconPathElement('M12 17v4'), // key: 1riwvh
      ElIconPathElement('M14 5v.341'), // key: 72nt6x
      ElIconPathElement('M18 5v13'), // key: 123xd1
      ElIconPathElement('M2 10v3'), // key: 1fnikh
      ElIconPathElement('M22 10v3'), // key: 154ddg
      ElIconPathElement('M6 6v11'), // key: 11sgs0
      ElIconPathElement('M9 21h6'), // key: 1udhl7
      ElIconRectElement(10, 9, 4, 8, 2), // key: 1d9qhd
    ],
  );

  /// `mic-off.mjs`
  static const ElLucideGlyph micOff = ElLucideGlyph('mic-off', <ElIconElement>[
    ElIconPathElement('M12 19v3'), // key: npa21l
    ElIconPathElement('M15 9.34V5a3 3 0 0 0-5.68-1.33'), // key: 1gzdoj
    ElIconPathElement('M16.95 16.95A7 7 0 0 1 5 12v-2'), // key: cqa7eg
    ElIconPathElement('M18.89 13.23A7 7 0 0 0 19 12v-2'), // key: 16hl24
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement('M9 9v3a3 3 0 0 0 5.12 2.12'), // key: r2i35w
  ]);

  /// `mic-signal.mjs`
  static const ElLucideGlyph micSignal = ElLucideGlyph(
    'mic-signal',
    <ElIconElement>[
      ElIconPathElement('M12 17v4'), // key: 1riwvh
      ElIconPathElement('M18 11a6 6 0 00-3-5.197'), // key: 1lvu40
      ElIconPathElement('M2 11a10 10 0 015-8.662'), // key: bida4p
      ElIconPathElement('M22 11a10 10 0 00-5-8.662'), // key: idvinr
      ElIconPathElement('M6 11a6 6 0 013-5.197'), // key: 17n2ii
      ElIconPathElement('M9 21h6'), // key: 1udhl7
      ElIconRectElement(10, 9, 4, 8, 2), // key: 1l8p2f
    ],
  );

  /// `mic-vocal.mjs`
  static const ElLucideGlyph
  micVocal = ElLucideGlyph('mic-vocal', <ElIconElement>[
    ElIconPathElement(
      'm11 7.601-5.994 8.19a1 1 0 0 0 .1 1.298l.817.818a1 1 0 0 0 1.314.087L15.09 12',
    ), // key: 80a601
    ElIconPathElement(
      'M16.5 21.174C15.5 20.5 14.372 20 13 20c-2.058 0-3.928 2.356-6 2-2.072-.356-2.775-3.369-1.5-4.5',
    ), // key: j0ngtp
    ElIconCircleElement(16, 7, 5), // key: d08jfb
  ]);

  /// `mic.mjs`
  static const ElLucideGlyph mic = ElLucideGlyph('mic', <ElIconElement>[
    ElIconPathElement('M12 19v3'), // key: npa21l
    ElIconPathElement('M19 10v2a7 7 0 0 1-14 0v-2'), // key: 1vc78b
    ElIconRectElement(9, 2, 6, 13, 3), // key: s6n7sd
  ]);

  /// `microchip.mjs`
  static const ElLucideGlyph microchip = ElLucideGlyph(
    'microchip',
    <ElIconElement>[
      ElIconPathElement('M10 12h4'), // key: a56b0p
      ElIconPathElement('M10 17h4'), // key: pvmtpo
      ElIconPathElement('M10 7h4'), // key: 1vgcok
      ElIconPathElement('M18 12h2'), // key: quuxs7
      ElIconPathElement('M18 18h2'), // key: 4scel
      ElIconPathElement('M18 6h2'), // key: 1ptzki
      ElIconPathElement('M4 12h2'), // key: 1ltxp0
      ElIconPathElement('M4 18h2'), // key: 1xrofg
      ElIconPathElement('M4 6h2'), // key: 1cx33n
      ElIconRectElement(6, 2, 12, 20, 2), // key: 749fme
    ],
  );

  /// `microscope.mjs`
  static const ElLucideGlyph
  microscope = ElLucideGlyph('microscope', <ElIconElement>[
    ElIconPathElement('M6 18h8'), // key: 1borvv
    ElIconPathElement('M3 22h18'), // key: 8prr45
    ElIconPathElement('M14 22a7 7 0 1 0 0-14h-1'), // key: 1jwaiy
    ElIconPathElement('M9 14h2'), // key: 197e7h
    ElIconPathElement(
      'M9 12a2 2 0 0 1-2-2V6h6v4a2 2 0 0 1-2 2Z',
    ), // key: 1bmzmy
    ElIconPathElement('M12 6V3a1 1 0 0 0-1-1H9a1 1 0 0 0-1 1v3'), // key: 1drr47
  ]);

  /// `microwave.mjs`
  static const ElLucideGlyph microwave = ElLucideGlyph(
    'microwave',
    <ElIconElement>[
      ElIconRectElement(2, 4, 20, 15, 2), // key: 2no95f
      ElIconRectElement(6, 8, 8, 7, 1), // key: zh9wx
      ElIconPathElement('M18 8v7'), // key: o5zi4n
      ElIconPathElement('M6 19v2'), // key: 1loha6
      ElIconPathElement('M18 19v2'), // key: 1dawf0
    ],
  );

  /// `milestone.mjs`
  static const ElLucideGlyph
  milestone = ElLucideGlyph('milestone', <ElIconElement>[
    ElIconPathElement('M12 13v8'), // key: 1l5pq0
    ElIconPathElement('M12 3v3'), // key: 1n5kay
    ElIconPathElement(
      'M18.172 6a2 2 0 0 1 1.414.586l2.06 2.06a1.207 1.207 0 0 1 0 1.708l-2.06 2.06a2 2 0 0 1-1.414.586H4a1 1 0 0 1-1-1V7a1 1 0 0 1 1-1z',
    ), // key: 8gz4t4
  ]);

  /// `milk-off.mjs`
  static const ElLucideGlyph
  milkOff = ElLucideGlyph('milk-off', <ElIconElement>[
    ElIconPathElement('M8 2h8'), // key: 1ssgc1
    ElIconPathElement(
      'M9 2v1.343M15 2v2.789a4 4 0 0 0 .672 2.219l.656.984a4 4 0 0 1 .672 2.22v1.131M7.8 7.8l-.128.192A4 4 0 0 0 7 10.212V20a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2v-3',
    ), // key: y0ejgx
    ElIconPathElement(
      'M7 15a6.47 6.47 0 0 1 5 0 6.472 6.472 0 0 0 3.435.435',
    ), // key: iaxqsy
    ElIconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `milk.mjs`
  static const ElLucideGlyph milk = ElLucideGlyph('milk', <ElIconElement>[
    ElIconPathElement('M8 2h8'), // key: 1ssgc1
    ElIconPathElement(
      'M9 2v2.789a4 4 0 0 1-.672 2.219l-.656.984A4 4 0 0 0 7 10.212V20a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2v-9.789a4 4 0 0 0-.672-2.219l-.656-.984A4 4 0 0 1 15 4.788V2',
    ), // key: qtp12x
    ElIconPathElement(
      'M7 15a6.472 6.472 0 0 1 5 0 6.47 6.47 0 0 0 5 0',
    ), // key: ygeh44
  ]);

  /// `minimize-2.mjs`
  static const ElLucideGlyph minimize2 = ElLucideGlyph(
    'minimize-2',
    <ElIconElement>[
      ElIconPathElement('m14 10 7-7'), // key: oa77jy
      ElIconPathElement('M20 10h-6V4'), // key: mjg0md
      ElIconPathElement('m3 21 7-7'), // key: tjx5ai
      ElIconPathElement('M4 14h6v6'), // key: rmj7iw
    ],
  );

  /// `minimize.mjs`
  static const ElLucideGlyph minimize = ElLucideGlyph(
    'minimize',
    <ElIconElement>[
      ElIconPathElement('M8 3v3a2 2 0 0 1-2 2H3'), // key: hohbtr
      ElIconPathElement('M21 8h-3a2 2 0 0 1-2-2V3'), // key: 5jw1f3
      ElIconPathElement('M3 16h3a2 2 0 0 1 2 2v3'), // key: 198tvr
      ElIconPathElement('M16 21v-3a2 2 0 0 1 2-2h3'), // key: ph8mxp
    ],
  );

  /// `minus.mjs`
  static const ElLucideGlyph minus = ElLucideGlyph('minus', <ElIconElement>[
    ElIconPathElement('M5 12h14'), // key: 1ays0h
  ]);

  /// `mirror-rectangular.mjs`
  static const ElLucideGlyph mirrorRectangular = ElLucideGlyph(
    'mirror-rectangular',
    <ElIconElement>[
      ElIconPathElement('M11 6 8 9'), // key: 7zt14w
      ElIconPathElement('m16 7-8 8'), // key: tkgtvu
      ElIconRectElement(4, 2, 16, 20, 2), // key: 1uxh74
    ],
  );

  /// `mirror-round.mjs`
  static const ElLucideGlyph mirrorRound = ElLucideGlyph(
    'mirror-round',
    <ElIconElement>[
      ElIconPathElement('M10 6.6 8.6 8'), // key: itrr7k
      ElIconPathElement('M12 18v4'), // key: jadmvz
      ElIconPathElement('M15 7.5 9.5 13'), // key: 1vyrsv
      ElIconPathElement('M7 22h10'), // key: 10w4w3
      ElIconCircleElement(12, 10, 8), // key: 1gshiw
    ],
  );

  /// `monitor-check.mjs`
  static const ElLucideGlyph monitorCheck = ElLucideGlyph(
    'monitor-check',
    <ElIconElement>[
      ElIconPathElement('m9 10 2 2 4-4'), // key: 1gnqz4
      ElIconRectElement(2, 3, 20, 14, 2), // key: 48i651
      ElIconPathElement('M12 17v4'), // key: 1riwvh
      ElIconPathElement('M8 21h8'), // key: 1ev6f3
    ],
  );

  /// `monitor-cloud.mjs`
  static const ElLucideGlyph monitorCloud = ElLucideGlyph(
    'monitor-cloud',
    <ElIconElement>[
      ElIconPathElement(
        'M11 13a3 3 0 1 1 2.83-4H14a2 2 0 0 1 0 4z',
      ), // key: 1da4q6
      ElIconPathElement('M12 17v4'), // key: 1riwvh
      ElIconPathElement('M8 21h8'), // key: 1ev6f3
      ElIconRectElement(2, 3, 20, 14, 2), // key: x3v2xh
    ],
  );

  /// `monitor-cog.mjs`
  static const ElLucideGlyph monitorCog = ElLucideGlyph(
    'monitor-cog',
    <ElIconElement>[
      ElIconPathElement('M12 17v4'), // key: 1riwvh
      ElIconPathElement('m14.305 7.53.923-.382'), // key: 1mlnsw
      ElIconPathElement('m15.228 4.852-.923-.383'), // key: 82mpwg
      ElIconPathElement('m16.852 3.228-.383-.924'), // key: ln4sir
      ElIconPathElement('m16.852 8.772-.383.923'), // key: 1dejw0
      ElIconPathElement('m19.148 3.228.383-.924'), // key: 192kgf
      ElIconPathElement('m19.53 9.696-.382-.924'), // key: fiavlr
      ElIconPathElement('m20.772 4.852.924-.383'), // key: 1j8mgp
      ElIconPathElement('m20.772 7.148.924.383'), // key: zix9be
      ElIconPathElement(
        'M22 13v2a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h7',
      ), // key: 1tnzv8
      ElIconPathElement('M8 21h8'), // key: 1ev6f3
      ElIconCircleElement(18, 6, 3), // key: 1h7g24
    ],
  );

  /// `monitor-dot.mjs`
  static const ElLucideGlyph monitorDot = ElLucideGlyph(
    'monitor-dot',
    <ElIconElement>[
      ElIconPathElement('M12 17v4'), // key: 1riwvh
      ElIconPathElement(
        'M22 12.307V15a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h8.693',
      ), // key: 1dx6ho
      ElIconPathElement('M8 21h8'), // key: 1ev6f3
      ElIconCircleElement(19, 6, 3), // key: 108a5v
    ],
  );

  /// `monitor-down.mjs`
  static const ElLucideGlyph monitorDown = ElLucideGlyph(
    'monitor-down',
    <ElIconElement>[
      ElIconPathElement('M12 13V7'), // key: h0r20n
      ElIconPathElement('m15 10-3 3-3-3'), // key: lzhmyn
      ElIconRectElement(2, 3, 20, 14, 2), // key: 48i651
      ElIconPathElement('M12 17v4'), // key: 1riwvh
      ElIconPathElement('M8 21h8'), // key: 1ev6f3
    ],
  );

  /// `monitor-off.mjs`
  static const ElLucideGlyph monitorOff = ElLucideGlyph(
    'monitor-off',
    <ElIconElement>[
      ElIconPathElement('M12 17v4'), // key: 1riwvh
      ElIconPathElement(
        'M17 17H4a2 2 0 0 1-2-2V5a2 2 0 0 1 1.184-1.826',
      ), // key: cv7jms
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
      ElIconPathElement('M8 21h8'), // key: 1ev6f3
      ElIconPathElement(
        'M8.656 3H20a2 2 0 0 1 2 2v10a2 2 0 0 1-.293 1.042',
      ), // key: z8ni2w
    ],
  );

  /// `monitor-pause.mjs`
  static const ElLucideGlyph monitorPause = ElLucideGlyph(
    'monitor-pause',
    <ElIconElement>[
      ElIconPathElement('M10 13V7'), // key: 1u13u9
      ElIconPathElement('M14 13V7'), // key: 1vj9om
      ElIconRectElement(2, 3, 20, 14, 2), // key: 48i651
      ElIconPathElement('M12 17v4'), // key: 1riwvh
      ElIconPathElement('M8 21h8'), // key: 1ev6f3
    ],
  );

  /// `monitor-play.mjs`
  static const ElLucideGlyph
  monitorPlay = ElLucideGlyph('monitor-play', <ElIconElement>[
    ElIconPathElement(
      'M15.033 9.44a.647.647 0 0 1 0 1.12l-4.065 2.352a.645.645 0 0 1-.968-.56V7.648a.645.645 0 0 1 .967-.56z',
    ), // key: vbtd3f
    ElIconPathElement('M12 17v4'), // key: 1riwvh
    ElIconPathElement('M8 21h8'), // key: 1ev6f3
    ElIconRectElement(2, 3, 20, 14, 2), // key: x3v2xh
  ]);

  /// `monitor-smartphone.mjs`
  static const ElLucideGlyph monitorSmartphone = ElLucideGlyph(
    'monitor-smartphone',
    <ElIconElement>[
      ElIconPathElement(
        'M18 8V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v7a2 2 0 0 0 2 2h8',
      ), // key: 10dyio
      ElIconPathElement('M10 19v-3.96 3.15'), // key: 1irgej
      ElIconPathElement('M7 19h5'), // key: qswx4l
      ElIconRectElement(16, 12, 6, 10, 2), // key: 1egngj
    ],
  );

  /// `monitor-speaker.mjs`
  static const ElLucideGlyph
  monitorSpeaker = ElLucideGlyph('monitor-speaker', <ElIconElement>[
    ElIconPathElement('M5.5 20H8'), // key: 1k40s5
    ElIconPathElement('M17 9h.01'), // key: 1j24nn
    ElIconRectElement(12, 4, 10, 16, 2), // key: ixliua
    ElIconPathElement('M8 6H4a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h4'), // key: 1mp6e1
    ElIconCircleElement(17, 15, 1), // key: tqvash
  ]);

  /// `monitor-stop.mjs`
  static const ElLucideGlyph monitorStop = ElLucideGlyph(
    'monitor-stop',
    <ElIconElement>[
      ElIconPathElement('M12 17v4'), // key: 1riwvh
      ElIconPathElement('M8 21h8'), // key: 1ev6f3
      ElIconRectElement(2, 3, 20, 14, 2), // key: x3v2xh
      ElIconRectElement(9, 7, 6, 6, 1), // key: 5m2oou
    ],
  );

  /// `monitor-up.mjs`
  static const ElLucideGlyph monitorUp = ElLucideGlyph(
    'monitor-up',
    <ElIconElement>[
      ElIconPathElement('m9 10 3-3 3 3'), // key: 11gsxs
      ElIconPathElement('M12 13V7'), // key: h0r20n
      ElIconRectElement(2, 3, 20, 14, 2), // key: 48i651
      ElIconPathElement('M12 17v4'), // key: 1riwvh
      ElIconPathElement('M8 21h8'), // key: 1ev6f3
    ],
  );

  /// `monitor-x.mjs`
  static const ElLucideGlyph monitorX = ElLucideGlyph(
    'monitor-x',
    <ElIconElement>[
      ElIconPathElement('m14.5 12.5-5-5'), // key: 1jahn5
      ElIconPathElement('m9.5 12.5 5-5'), // key: 1k2t7b
      ElIconRectElement(2, 3, 20, 14, 2), // key: 48i651
      ElIconPathElement('M12 17v4'), // key: 1riwvh
      ElIconPathElement('M8 21h8'), // key: 1ev6f3
    ],
  );

  /// `monitor.mjs`
  static const ElLucideGlyph monitor = ElLucideGlyph('monitor', <ElIconElement>[
    ElIconRectElement(2, 3, 20, 14, 2), // key: 48i651
    ElIconLineElement(8, 21, 16, 21), // key: 1svkeh
    ElIconLineElement(12, 17, 12, 21), // key: vw1qmm
  ]);

  /// `moon-star.mjs`
  static const ElLucideGlyph
  moonStar = ElLucideGlyph('moon-star', <ElIconElement>[
    ElIconPathElement('M18 5h4'), // key: 1lhgn2
    ElIconPathElement('M20 3v4'), // key: 1olli1
    ElIconPathElement(
      'M20.985 12.486a9 9 0 1 1-9.473-9.472c.405-.022.617.46.402.803a6 6 0 0 0 8.268 8.268c.344-.215.825-.004.803.401',
    ), // key: kfwtm
  ]);

  /// `moon.mjs`
  static const ElLucideGlyph moon = ElLucideGlyph('moon', <ElIconElement>[
    ElIconPathElement(
      'M20.985 12.486a9 9 0 1 1-9.473-9.472c.405-.022.617.46.402.803a6 6 0 0 0 8.268 8.268c.344-.215.825-.004.803.401',
    ), // key: kfwtm
  ]);

  /// `mosque.mjs`
  static const ElLucideGlyph mosque = ElLucideGlyph('mosque', <ElIconElement>[
    ElIconPathElement('M12.268 2a2 2 0 003.465 2'), // key: 3in8xp
    ElIconPathElement('M14 5 L14 8'), // key: 1fhhfb
    ElIconPathElement('M16 22v-3a2 2 0 00-4 0v3'), // key: 1p6nbd
    ElIconPathElement(
      'M21 13c-.662-1.497-1.666-2.753-2.9-3.63C16.825 8.47 15.422 8 14 8s-2.826.47-4.1 1.37C8.668 10.248 7.663 11.504 7 13z',
    ), // key: ck3r5y
    ElIconPathElement('M3 9h4'), // key: rnfnj5
    ElIconPathElement(
      'M7 22V6a5 5 0 00-2-4 5 5 0 00-2 4v14a2 2 0 002 2h14a2 2 0 002-2v-7',
    ), // key: 28kgc3
  ]);

  /// `motorbike.mjs`
  static const ElLucideGlyph motorbike = ElLucideGlyph(
    'motorbike',
    <ElIconElement>[
      ElIconPathElement('m18 14-1-3'), // key: bdajw9
      ElIconPathElement(
        'm3 9 6 2a2 2 0 0 1 2-2h2a2 2 0 0 1 1.99 1.81',
      ), // key: f5fotj
      ElIconPathElement(
        'M8 17h3a1 1 0 0 0 1-1 6 6 0 0 1 6-6 1 1 0 0 0 1-1v-.75A5 5 0 0 0 17 5',
      ), // key: 3i90e2
      ElIconCircleElement(19, 17, 3), // key: 1otbdv
      ElIconCircleElement(5, 17, 3), // key: 1d8p0c
    ],
  );

  /// `mountain-snow.mjs`
  static const ElLucideGlyph mountainSnow = ElLucideGlyph(
    'mountain-snow',
    <ElIconElement>[
      ElIconPathElement('m8 3 4 8 5-5 5 15H2L8 3z'), // key: otkl63
      ElIconPathElement(
        'M4.14 15.08c2.62-1.57 5.24-1.43 7.86.42 2.74 1.94 5.49 2 8.23.19',
      ), // key: 1pvmmp
    ],
  );

  /// `mountain.mjs`
  static const ElLucideGlyph mountain = ElLucideGlyph(
    'mountain',
    <ElIconElement>[
      ElIconPathElement('m8 3 4 8 5-5 5 15H2L8 3z'), // key: otkl63
    ],
  );

  /// `mouse-left.mjs`
  static const ElLucideGlyph mouseLeft = ElLucideGlyph(
    'mouse-left',
    <ElIconElement>[
      ElIconPathElement('M12 7.318V10'), // key: 17s7lh
      ElIconPathElement(
        'M5 10v5a7 7 0 0 0 14 0V9c0-3.527-2.608-6.515-6-7',
      ), // key: imk5ea
      ElIconCircleElement(7, 4, 2), // key: ra7k3
    ],
  );

  /// `mouse-off.mjs`
  static const ElLucideGlyph mouseOff = ElLucideGlyph(
    'mouse-off',
    <ElIconElement>[
      ElIconPathElement('M12 6v.343'), // key: 1gyhex
      ElIconPathElement(
        'M18.218 18.218A7 7 0 0 1 5 15V9a7 7 0 0 1 .782-3.218',
      ), // key: ukzz01
      ElIconPathElement('M19 13.343V9A7 7 0 0 0 8.56 2.902'), // key: 104jy9
      ElIconPathElement('M22 22 2 2'), // key: 1r8tn9
    ],
  );

  /// `mouse-pointer-2-off.mjs`
  static const ElLucideGlyph
  mousePointer2Off = ElLucideGlyph('mouse-pointer-2-off', <ElIconElement>[
    ElIconPathElement(
      'm15.55 8.45 5.138 2.087a.5.5 0 0 1-.063.947l-6.124 1.58a2 2 0 0 0-1.438 1.435l-1.579 6.126a.5.5 0 0 1-.947.063L8.45 15.551',
    ), // key: 1qoshx
    ElIconPathElement('M22 2 2 22'), // key: y4kqgn
    ElIconPathElement(
      'm6.816 11.528-2.779-6.84a.495.495 0 0 1 .651-.651l6.84 2.779',
    ), // key: mymuvk
  ]);

  /// `mouse-pointer-2.mjs`
  static const ElLucideGlyph
  mousePointer2 = ElLucideGlyph('mouse-pointer-2', <ElIconElement>[
    ElIconPathElement(
      'M4.037 4.688a.495.495 0 0 1 .651-.651l16 6.5a.5.5 0 0 1-.063.947l-6.124 1.58a2 2 0 0 0-1.438 1.435l-1.579 6.126a.5.5 0 0 1-.947.063z',
    ), // key: edeuup
  ]);

  /// `mouse-pointer-ban.mjs`
  static const ElLucideGlyph
  mousePointerBan = ElLucideGlyph('mouse-pointer-ban', <ElIconElement>[
    ElIconPathElement(
      'M2.034 2.681a.498.498 0 0 1 .647-.647l9 3.5a.5.5 0 0 1-.033.944L8.204 7.545a1 1 0 0 0-.66.66l-1.066 3.443a.5.5 0 0 1-.944.033z',
    ), // key: 11pp1i
    ElIconCircleElement(16, 16, 6), // key: qoo3c4
    ElIconPathElement('m11.8 11.8 8.4 8.4'), // key: oogvdj
  ]);

  /// `mouse-pointer-click.mjs`
  static const ElLucideGlyph
  mousePointerClick = ElLucideGlyph('mouse-pointer-click', <ElIconElement>[
    ElIconPathElement('M14 4.1 12 6'), // key: ita8i4
    ElIconPathElement('m5.1 8-2.9-.8'), // key: 1go3kf
    ElIconPathElement('m6 12-1.9 2'), // key: mnht97
    ElIconPathElement('M7.2 2.2 8 5.1'), // key: 1cfko1
    ElIconPathElement(
      'M9.037 9.69a.498.498 0 0 1 .653-.653l11 4.5a.5.5 0 0 1-.074.949l-4.349 1.041a1 1 0 0 0-.74.739l-1.04 4.35a.5.5 0 0 1-.95.074z',
    ), // key: s0h3yz
  ]);

  /// `mouse-pointer.mjs`
  static const ElLucideGlyph
  mousePointer = ElLucideGlyph('mouse-pointer', <ElIconElement>[
    ElIconPathElement('M12.586 12.586 19 19'), // key: ea5xo7
    ElIconPathElement(
      'M3.688 3.037a.497.497 0 0 0-.651.651l6.5 15.999a.501.501 0 0 0 .947-.062l1.569-6.083a2 2 0 0 1 1.448-1.479l6.124-1.579a.5.5 0 0 0 .063-.947z',
    ), // key: 277e5u
  ]);

  /// `mouse-right.mjs`
  static const ElLucideGlyph mouseRight = ElLucideGlyph(
    'mouse-right',
    <ElIconElement>[
      ElIconPathElement('M12 7.318V10'), // key: 17s7lh
      ElIconPathElement(
        'M19 10v5a7 7 0 0 1-14 0V9c0-3.527 2.608-6.515 6-7',
      ), // key: 2es5nn
      ElIconCircleElement(17, 4, 2), // key: y5j2s2
    ],
  );

  /// `mouse.mjs`
  static const ElLucideGlyph mouse = ElLucideGlyph('mouse', <ElIconElement>[
    ElIconRectElement(5, 2, 14, 20, 7), // key: 11ol66
    ElIconPathElement('M12 6v4'), // key: 16clxf
  ]);

  /// `move-3d.mjs`
  static const ElLucideGlyph move3d = ElLucideGlyph('move-3d', <ElIconElement>[
    ElIconPathElement('M5 3v16h16'), // key: 1mqmf9
    ElIconPathElement('m5 19 6-6'), // key: jh6hbb
    ElIconPathElement('m2 6 3-3 3 3'), // key: tkyvxa
    ElIconPathElement('m18 16 3 3-3 3'), // key: 1d4glt
  ]);

  /// `move-diagonal-2.mjs`
  static const ElLucideGlyph moveDiagonal2 = ElLucideGlyph(
    'move-diagonal-2',
    <ElIconElement>[
      ElIconPathElement('M19 13v6h-6'), // key: 1hxl6d
      ElIconPathElement('M5 11V5h6'), // key: 12e2xe
      ElIconPathElement('m5 5 14 14'), // key: 11anup
    ],
  );

  /// `move-diagonal.mjs`
  static const ElLucideGlyph moveDiagonal = ElLucideGlyph(
    'move-diagonal',
    <ElIconElement>[
      ElIconPathElement('M11 19H5v-6'), // key: 8awifj
      ElIconPathElement('M13 5h6v6'), // key: 7voy1q
      ElIconPathElement('M19 5 5 19'), // key: wwaj1z
    ],
  );

  /// `move-down-left.mjs`
  static const ElLucideGlyph moveDownLeft = ElLucideGlyph(
    'move-down-left',
    <ElIconElement>[
      ElIconPathElement('M11 19H5V13'), // key: 1akmht
      ElIconPathElement('M19 5L5 19'), // key: 72u4yj
    ],
  );

  /// `move-down-right.mjs`
  static const ElLucideGlyph moveDownRight = ElLucideGlyph(
    'move-down-right',
    <ElIconElement>[
      ElIconPathElement('M19 13V19H13'), // key: 10vkzq
      ElIconPathElement('M5 5L19 19'), // key: 5zm2fv
    ],
  );

  /// `move-down.mjs`
  static const ElLucideGlyph moveDown = ElLucideGlyph(
    'move-down',
    <ElIconElement>[
      ElIconPathElement('M8 18L12 22L16 18'), // key: cskvfv
      ElIconPathElement('M12 2V22'), // key: r89rzk
    ],
  );

  /// `move-horizontal.mjs`
  static const ElLucideGlyph moveHorizontal = ElLucideGlyph(
    'move-horizontal',
    <ElIconElement>[
      ElIconPathElement('m18 8 4 4-4 4'), // key: 1ak13k
      ElIconPathElement('M2 12h20'), // key: 9i4pu4
      ElIconPathElement('m6 8-4 4 4 4'), // key: 15zrgr
    ],
  );

  /// `move-left.mjs`
  static const ElLucideGlyph moveLeft = ElLucideGlyph(
    'move-left',
    <ElIconElement>[
      ElIconPathElement('M6 8L2 12L6 16'), // key: kyvwex
      ElIconPathElement('M2 12H22'), // key: 1m8cig
    ],
  );

  /// `move-right.mjs`
  static const ElLucideGlyph moveRight = ElLucideGlyph(
    'move-right',
    <ElIconElement>[
      ElIconPathElement('M18 8L22 12L18 16'), // key: 1r0oui
      ElIconPathElement('M2 12H22'), // key: 1m8cig
    ],
  );

  /// `move-up-left.mjs`
  static const ElLucideGlyph moveUpLeft = ElLucideGlyph(
    'move-up-left',
    <ElIconElement>[
      ElIconPathElement('M5 11V5H11'), // key: 3q78g9
      ElIconPathElement('M5 5L19 19'), // key: 5zm2fv
    ],
  );

  /// `move-up-right.mjs`
  static const ElLucideGlyph moveUpRight = ElLucideGlyph(
    'move-up-right',
    <ElIconElement>[
      ElIconPathElement('M13 5H19V11'), // key: 1n1gyv
      ElIconPathElement('M19 5L5 19'), // key: 72u4yj
    ],
  );

  /// `move-up.mjs`
  static const ElLucideGlyph moveUp = ElLucideGlyph('move-up', <ElIconElement>[
    ElIconPathElement('M8 6L12 2L16 6'), // key: 1yvkyx
    ElIconPathElement('M12 2V22'), // key: r89rzk
  ]);

  /// `move-vertical.mjs`
  static const ElLucideGlyph moveVertical = ElLucideGlyph(
    'move-vertical',
    <ElIconElement>[
      ElIconPathElement('M12 2v20'), // key: t6zp3m
      ElIconPathElement('m8 18 4 4 4-4'), // key: bh5tu3
      ElIconPathElement('m8 6 4-4 4 4'), // key: ybng9g
    ],
  );

  /// `move.mjs`
  static const ElLucideGlyph move = ElLucideGlyph('move', <ElIconElement>[
    ElIconPathElement('M12 2v20'), // key: t6zp3m
    ElIconPathElement('m15 19-3 3-3-3'), // key: 11eu04
    ElIconPathElement('m19 9 3 3-3 3'), // key: 1mg7y2
    ElIconPathElement('M2 12h20'), // key: 9i4pu4
    ElIconPathElement('m5 9-3 3 3 3'), // key: j64kie
    ElIconPathElement('m9 5 3-3 3 3'), // key: l8vdw6
  ]);

  /// `music-2.mjs`
  static const ElLucideGlyph music2 = ElLucideGlyph('music-2', <ElIconElement>[
    ElIconCircleElement(8, 18, 4), // key: 1fc0mg
    ElIconPathElement('M12 18V2l7 4'), // key: g04rme
  ]);

  /// `music-3.mjs`
  static const ElLucideGlyph music3 = ElLucideGlyph('music-3', <ElIconElement>[
    ElIconCircleElement(12, 18, 4), // key: m3r9ws
    ElIconPathElement('M16 18V2'), // key: 40x2m5
  ]);

  /// `music-4.mjs`
  static const ElLucideGlyph music4 = ElLucideGlyph('music-4', <ElIconElement>[
    ElIconPathElement('M9 18V5l12-2v13'), // key: 1jmyc2
    ElIconPathElement('m9 9 12-2'), // key: 1e64n2
    ElIconCircleElement(6, 18, 3), // key: fqmcym
    ElIconCircleElement(18, 16, 3), // key: 1hluhg
  ]);

  /// `music.mjs`
  static const ElLucideGlyph music = ElLucideGlyph('music', <ElIconElement>[
    ElIconPathElement('M9 18V5l12-2v13'), // key: 1jmyc2
    ElIconCircleElement(6, 18, 3), // key: fqmcym
    ElIconCircleElement(18, 16, 3), // key: 1hluhg
  ]);

  /// `navigation-2-off.mjs`
  static const ElLucideGlyph navigation2Off = ElLucideGlyph(
    'navigation-2-off',
    <ElIconElement>[
      ElIconPathElement('M9.31 9.31 5 21l7-4 7 4-1.17-3.17'), // key: qoq2o2
      ElIconPathElement('M14.53 8.88 12 2l-1.17 3.17'), // key: k3sjzy
      ElIconLineElement(2, 2, 22, 22), // key: a6p6uj
    ],
  );

  /// `navigation-2.mjs`
  static const ElLucideGlyph navigation2 = ElLucideGlyph(
    'navigation-2',
    <ElIconElement>[
      ElIconPolygonElement(<Offset>[
        Offset(12, 2),
        Offset(19, 21),
        Offset(12, 17),
        Offset(5, 21),
        Offset(12, 2),
      ]), // key: x8c0qg
    ],
  );

  /// `navigation-off.mjs`
  static const ElLucideGlyph navigationOff = ElLucideGlyph(
    'navigation-off',
    <ElIconElement>[
      ElIconPathElement('M8.43 8.43 3 11l8 2 2 8 2.57-5.43'), // key: 1vdtb7
      ElIconPathElement('M17.39 11.73 22 2l-9.73 4.61'), // key: tya3r6
      ElIconLineElement(2, 2, 22, 22), // key: a6p6uj
    ],
  );

  /// `navigation.mjs`
  static const ElLucideGlyph navigation = ElLucideGlyph(
    'navigation',
    <ElIconElement>[
      ElIconPolygonElement(<Offset>[
        Offset(3, 11),
        Offset(22, 2),
        Offset(13, 21),
        Offset(11, 13),
        Offset(3, 11),
      ]), // key: 1ltx0t
    ],
  );

  /// `network.mjs`
  static const ElLucideGlyph network = ElLucideGlyph('network', <ElIconElement>[
    ElIconRectElement(16, 16, 6, 6, 1), // key: 4q2zg0
    ElIconRectElement(2, 16, 6, 6, 1), // key: 8cvhb9
    ElIconRectElement(9, 2, 6, 6, 1), // key: 1egb70
    ElIconPathElement(
      'M5 16v-3a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1v3',
    ), // key: 1jsf9p
    ElIconPathElement('M12 12V8'), // key: 2874zd
  ]);

  /// `newspaper.mjs`
  static const ElLucideGlyph
  newspaper = ElLucideGlyph('newspaper', <ElIconElement>[
    ElIconPathElement('M15 18h-5'), // key: 95g1m2
    ElIconPathElement('M18 14h-8'), // key: sponae
    ElIconPathElement(
      'M4 22h16a2 2 0 0 0 2-2V4a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v16a2 2 0 0 1-4 0v-9a2 2 0 0 1 2-2h2',
    ), // key: 39pd36
    ElIconRectElement(10, 6, 8, 4, 1), // key: aywv1n
  ]);

  /// `nfc.mjs`
  static const ElLucideGlyph nfc = ElLucideGlyph('nfc', <ElIconElement>[
    ElIconPathElement('M6 8.32a7.43 7.43 0 0 1 0 7.36'), // key: 9iaqei
    ElIconPathElement('M9.46 6.21a11.76 11.76 0 0 1 0 11.58'), // key: 1yha7l
    ElIconPathElement('M12.91 4.1a15.91 15.91 0 0 1 .01 15.8'), // key: 4iu2gk
    ElIconPathElement('M16.37 2a20.16 20.16 0 0 1 0 20'), // key: sap9u2
  ]);

  /// `non-binary.mjs`
  static const ElLucideGlyph nonBinary = ElLucideGlyph(
    'non-binary',
    <ElIconElement>[
      ElIconPathElement('M12 2v10'), // key: mnfbl
      ElIconPathElement('m8.5 4 7 4'), // key: m1xjk3
      ElIconPathElement('m8.5 8 7-4'), // key: t0m5j6
      ElIconCircleElement(12, 17, 5), // key: qbz8iq
    ],
  );

  /// `notebook-pen.mjs`
  static const ElLucideGlyph
  notebookPen = ElLucideGlyph('notebook-pen', <ElIconElement>[
    ElIconPathElement(
      'M13.4 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-7.4',
    ), // key: re6nr2
    ElIconPathElement('M2 6h4'), // key: aawbzj
    ElIconPathElement('M2 10h4'), // key: l0bgd4
    ElIconPathElement('M2 14h4'), // key: 1gsvsf
    ElIconPathElement('M2 18h4'), // key: 1bu2t1
    ElIconPathElement(
      'M21.378 5.626a1 1 0 1 0-3.004-3.004l-5.01 5.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z',
    ), // key: pqwjuv
  ]);

  /// `notebook-tabs.mjs`
  static const ElLucideGlyph notebookTabs = ElLucideGlyph(
    'notebook-tabs',
    <ElIconElement>[
      ElIconPathElement('M2 6h4'), // key: aawbzj
      ElIconPathElement('M2 10h4'), // key: l0bgd4
      ElIconPathElement('M2 14h4'), // key: 1gsvsf
      ElIconPathElement('M2 18h4'), // key: 1bu2t1
      ElIconRectElement(4, 2, 16, 20, 2), // key: 1nb95v
      ElIconPathElement('M15 2v20'), // key: dcj49h
      ElIconPathElement('M15 7h5'), // key: 1xj5lc
      ElIconPathElement('M15 12h5'), // key: w5shd9
      ElIconPathElement('M15 17h5'), // key: 1qaofu
    ],
  );

  /// `notebook-text.mjs`
  static const ElLucideGlyph notebookText = ElLucideGlyph(
    'notebook-text',
    <ElIconElement>[
      ElIconPathElement('M2 6h4'), // key: aawbzj
      ElIconPathElement('M2 10h4'), // key: l0bgd4
      ElIconPathElement('M2 14h4'), // key: 1gsvsf
      ElIconPathElement('M2 18h4'), // key: 1bu2t1
      ElIconRectElement(4, 2, 16, 20, 2), // key: 1nb95v
      ElIconPathElement('M9.5 8h5'), // key: 11mslq
      ElIconPathElement('M9.5 12H16'), // key: ktog6x
      ElIconPathElement('M9.5 16H14'), // key: p1seyn
    ],
  );

  /// `notebook.mjs`
  static const ElLucideGlyph notebook = ElLucideGlyph(
    'notebook',
    <ElIconElement>[
      ElIconPathElement('M2 6h4'), // key: aawbzj
      ElIconPathElement('M2 10h4'), // key: l0bgd4
      ElIconPathElement('M2 14h4'), // key: 1gsvsf
      ElIconPathElement('M2 18h4'), // key: 1bu2t1
      ElIconRectElement(4, 2, 16, 20, 2), // key: 1nb95v
      ElIconPathElement('M16 2v20'), // key: rotuqe
    ],
  );

  /// `notepad-text-dashed.mjs`
  static const ElLucideGlyph notepadTextDashed = ElLucideGlyph(
    'notepad-text-dashed',
    <ElIconElement>[
      ElIconPathElement('M8 2v4'), // key: 1cmpym
      ElIconPathElement('M12 2v4'), // key: 3427ic
      ElIconPathElement('M16 2v4'), // key: 4m81vk
      ElIconPathElement('M16 4h2a2 2 0 0 1 2 2v2'), // key: j91f56
      ElIconPathElement('M20 12v2'), // key: w8o0tu
      ElIconPathElement('M20 18v2a2 2 0 0 1-2 2h-1'), // key: 1c9ggx
      ElIconPathElement('M13 22h-2'), // key: 191ugt
      ElIconPathElement('M7 22H6a2 2 0 0 1-2-2v-2'), // key: 1rt9px
      ElIconPathElement('M4 14v-2'), // key: 1v0sqh
      ElIconPathElement('M4 8V6a2 2 0 0 1 2-2h2'), // key: 1mwabg
      ElIconPathElement('M8 10h6'), // key: 3oa6kw
      ElIconPathElement('M8 14h8'), // key: 1fgep2
      ElIconPathElement('M8 18h5'), // key: 17enja
    ],
  );

  /// `notepad-text.mjs`
  static const ElLucideGlyph notepadText = ElLucideGlyph(
    'notepad-text',
    <ElIconElement>[
      ElIconPathElement('M8 2v4'), // key: 1cmpym
      ElIconPathElement('M12 2v4'), // key: 3427ic
      ElIconPathElement('M16 2v4'), // key: 4m81vk
      ElIconRectElement(4, 4, 16, 18, 2), // key: 1u9h20
      ElIconPathElement('M8 10h6'), // key: 3oa6kw
      ElIconPathElement('M8 14h8'), // key: 1fgep2
      ElIconPathElement('M8 18h5'), // key: 17enja
    ],
  );

  /// `nut-off.mjs`
  static const ElLucideGlyph nutOff = ElLucideGlyph('nut-off', <ElIconElement>[
    ElIconPathElement('M12 4V2'), // key: 1k5q1u
    ElIconPathElement(
      'M5 10v4a7.004 7.004 0 0 0 5.277 6.787c.412.104.802.292 1.102.592L12 22l.621-.621c.3-.3.69-.488 1.102-.592a7.01 7.01 0 0 0 4.125-2.939',
    ), // key: 1xcvy9
    ElIconPathElement('M19 10v3.343'), // key: 163tfc
    ElIconPathElement(
      'M12 12c-1.349-.573-1.905-1.005-2.5-2-.546.902-1.048 1.353-2.5 2-1.018-.644-1.46-1.08-2-2-1.028.71-1.69.918-3 1 1.081-1.048 1.757-2.03 2-3 .194-.776.84-1.551 1.79-2.21m11.654 5.997c.887-.457 1.28-.891 1.556-1.787 1.032.916 1.683 1.157 3 1-1.297-1.036-1.758-2.03-2-3-.5-2-4-4-8-4-.74 0-1.461.068-2.15.192',
    ), // key: 17914v
    ElIconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `nut.mjs`
  static const ElLucideGlyph nut = ElLucideGlyph('nut', <ElIconElement>[
    ElIconPathElement('M12 4V2'), // key: 1k5q1u
    ElIconPathElement(
      'M5 10v4a7.004 7.004 0 0 0 5.277 6.787c.412.104.802.292 1.102.592L12 22l.621-.621c.3-.3.69-.488 1.102-.592A7.003 7.003 0 0 0 19 14v-4',
    ), // key: 1tgyif
    ElIconPathElement(
      'M12 4C8 4 4.5 6 4 8c-.243.97-.919 1.952-2 3 1.31-.082 1.972-.29 3-1 .54.92.982 1.356 2 2 1.452-.647 1.954-1.098 2.5-2 .595.995 1.151 1.427 2.5 2 1.31-.621 1.862-1.058 2.5-2 .629.977 1.162 1.423 2.5 2 1.209-.548 1.68-.967 2-2 1.032.916 1.683 1.157 3 1-1.297-1.036-1.758-2.03-2-3-.5-2-4-4-8-4Z',
    ), // key: tnsqj
  ]);

  /// `octagon-alert.mjs`
  static const ElLucideGlyph
  octagonAlert = ElLucideGlyph('octagon-alert', <ElIconElement>[
    ElIconPathElement('M12 16h.01'), // key: 1drbdi
    ElIconPathElement('M12 8v4'), // key: 1got3b
    ElIconPathElement(
      'M15.312 2a2 2 0 0 1 1.414.586l4.688 4.688A2 2 0 0 1 22 8.688v6.624a2 2 0 0 1-.586 1.414l-4.688 4.688a2 2 0 0 1-1.414.586H8.688a2 2 0 0 1-1.414-.586l-4.688-4.688A2 2 0 0 1 2 15.312V8.688a2 2 0 0 1 .586-1.414l4.688-4.688A2 2 0 0 1 8.688 2z',
    ), // key: 1fd625
  ]);

  /// `octagon-minus.mjs`
  static const ElLucideGlyph
  octagonMinus = ElLucideGlyph('octagon-minus', <ElIconElement>[
    ElIconPathElement(
      'M2.586 16.726A2 2 0 0 1 2 15.312V8.688a2 2 0 0 1 .586-1.414l4.688-4.688A2 2 0 0 1 8.688 2h6.624a2 2 0 0 1 1.414.586l4.688 4.688A2 2 0 0 1 22 8.688v6.624a2 2 0 0 1-.586 1.414l-4.688 4.688a2 2 0 0 1-1.414.586H8.688a2 2 0 0 1-1.414-.586z',
    ), // key: 2d38gg
    ElIconPathElement('M8 12h8'), // key: 1wcyev
  ]);

  /// `octagon-pause.mjs`
  static const ElLucideGlyph
  octagonPause = ElLucideGlyph('octagon-pause', <ElIconElement>[
    ElIconPathElement('M10 15V9'), // key: 1lckn7
    ElIconPathElement('M14 15V9'), // key: 1muqhk
    ElIconPathElement(
      'M2.586 16.726A2 2 0 0 1 2 15.312V8.688a2 2 0 0 1 .586-1.414l4.688-4.688A2 2 0 0 1 8.688 2h6.624a2 2 0 0 1 1.414.586l4.688 4.688A2 2 0 0 1 22 8.688v6.624a2 2 0 0 1-.586 1.414l-4.688 4.688a2 2 0 0 1-1.414.586H8.688a2 2 0 0 1-1.414-.586z',
    ), // key: 2d38gg
  ]);

  /// `octagon-x.mjs`
  static const ElLucideGlyph
  octagonX = ElLucideGlyph('octagon-x', <ElIconElement>[
    ElIconPathElement('m15 9-6 6'), // key: 1uzhvr
    ElIconPathElement(
      'M2.586 16.726A2 2 0 0 1 2 15.312V8.688a2 2 0 0 1 .586-1.414l4.688-4.688A2 2 0 0 1 8.688 2h6.624a2 2 0 0 1 1.414.586l4.688 4.688A2 2 0 0 1 22 8.688v6.624a2 2 0 0 1-.586 1.414l-4.688 4.688a2 2 0 0 1-1.414.586H8.688a2 2 0 0 1-1.414-.586z',
    ), // key: 2d38gg
    ElIconPathElement('m9 9 6 6'), // key: z0biqf
  ]);

  /// `octagon.mjs`
  static const ElLucideGlyph octagon = ElLucideGlyph('octagon', <ElIconElement>[
    ElIconPathElement(
      'M2.586 16.726A2 2 0 0 1 2 15.312V8.688a2 2 0 0 1 .586-1.414l4.688-4.688A2 2 0 0 1 8.688 2h6.624a2 2 0 0 1 1.414.586l4.688 4.688A2 2 0 0 1 22 8.688v6.624a2 2 0 0 1-.586 1.414l-4.688 4.688a2 2 0 0 1-1.414.586H8.688a2 2 0 0 1-1.414-.586z',
    ), // key: 2d38gg
  ]);

  /// `omega.mjs`
  static const ElLucideGlyph omega = ElLucideGlyph('omega', <ElIconElement>[
    ElIconPathElement(
      'M3 20h4.5a.5.5 0 0 0 .5-.5v-.282a.52.52 0 0 0-.247-.437 8 8 0 1 1 8.494-.001.52.52 0 0 0-.247.438v.282a.5.5 0 0 0 .5.5H21',
    ), // key: 1x94xo
  ]);

  /// `option.mjs`
  static const ElLucideGlyph option = ElLucideGlyph('option', <ElIconElement>[
    ElIconPathElement('M14 3h7'), // key: 16f0ms
    ElIconPathElement(
      'M3 3h5.28a1 1 0 0 1 .948.684l5.544 16.632a1 1 0 0 0 .949.684H21',
    ), // key: 1qf1im
  ]);

  /// `orbit.mjs`
  static const ElLucideGlyph orbit = ElLucideGlyph('orbit', <ElIconElement>[
    ElIconPathElement('M20.341 6.484A10 10 0 0 1 10.266 21.85'), // key: 1enhxb
    ElIconPathElement('M3.659 17.516A10 10 0 0 1 13.74 2.152'), // key: 1crzgf
    ElIconCircleElement(12, 12, 3), // key: 1v7zrd
    ElIconCircleElement(19, 5, 2), // key: mhkx31
    ElIconCircleElement(5, 19, 2), // key: v8kfzx
  ]);

  /// `origami.mjs`
  static const ElLucideGlyph origami = ElLucideGlyph('origami', <ElIconElement>[
    ElIconPathElement(
      'M12 12V4a1 1 0 0 1 1-1h6.297a1 1 0 0 1 .651 1.759l-4.696 4.025',
    ), // key: 1bx4vc
    ElIconPathElement(
      'm12 21-7.414-7.414A2 2 0 0 1 4 12.172V6.415a1.002 1.002 0 0 1 1.707-.707L20 20.009',
    ), // key: 1h3km6
    ElIconPathElement(
      'm12.214 3.381 8.414 14.966a1 1 0 0 1-.167 1.199l-1.168 1.163a1 1 0 0 1-.706.291H6.351a1 1 0 0 1-.625-.219L3.25 18.8a1 1 0 0 1 .631-1.781l4.165.027',
    ), // key: 1hj4wg
  ]);

  /// `package-2.mjs`
  static const ElLucideGlyph
  package2 = ElLucideGlyph('package-2', <ElIconElement>[
    ElIconPathElement('M12 3v6'), // key: 1holv5
    ElIconPathElement(
      'M16.76 3a2 2 0 0 1 1.8 1.1l2.23 4.479a2 2 0 0 1 .21.891V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V9.472a2 2 0 0 1 .211-.894L5.45 4.1A2 2 0 0 1 7.24 3z',
    ), // key: 187q7i
    ElIconPathElement('M3.054 9.013h17.893'), // key: grwhos
  ]);

  /// `package-check.mjs`
  static const ElLucideGlyph
  packageCheck = ElLucideGlyph('package-check', <ElIconElement>[
    ElIconPathElement('M12 22V12'), // key: d0xqtd
    ElIconPathElement('m16 17 2 2 4-4'), // key: uh5qu3
    ElIconPathElement(
      'M21 11.127V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.729l7 4a2 2 0 0 0 2 .001l1.32-.753',
    ), // key: kpkbpo
    ElIconPathElement('M3.29 7 12 12l8.71-5'), // key: 19ckod
    ElIconPathElement('m7.5 4.27 8.997 5.148'), // key: 9yrvtv
  ]);

  /// `package-minus.mjs`
  static const ElLucideGlyph
  packageMinus = ElLucideGlyph('package-minus', <ElIconElement>[
    ElIconPathElement('M12 22V12'), // key: d0xqtd
    ElIconPathElement('M16 17h6'), // key: 1ook5g
    ElIconPathElement(
      'M21 13V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.729l7 4a2 2 0 0 0 2 .001l1.675-.955',
    ), // key: zu9avd
    ElIconPathElement('M3.29 7 12 12l8.71-5'), // key: 19ckod
    ElIconPathElement('m7.5 4.27 8.997 5.148'), // key: 9yrvtv
  ]);

  /// `package-open.mjs`
  static const ElLucideGlyph
  packageOpen = ElLucideGlyph('package-open', <ElIconElement>[
    ElIconPathElement('M12 22v-9'), // key: x3hkom
    ElIconPathElement(
      'M15.17 2.21a1.67 1.67 0 0 1 1.63 0L21 4.57a1.93 1.93 0 0 1 0 3.36L8.82 14.79a1.655 1.655 0 0 1-1.64 0L3 12.43a1.93 1.93 0 0 1 0-3.36z',
    ), // key: 2ntwy6
    ElIconPathElement(
      'M20 13v3.87a2.06 2.06 0 0 1-1.11 1.83l-6 3.08a1.93 1.93 0 0 1-1.78 0l-6-3.08A2.06 2.06 0 0 1 4 16.87V13',
    ), // key: 1pmm1c
    ElIconPathElement(
      'M21 12.43a1.93 1.93 0 0 0 0-3.36L8.83 2.2a1.64 1.64 0 0 0-1.63 0L3 4.57a1.93 1.93 0 0 0 0 3.36l12.18 6.86a1.636 1.636 0 0 0 1.63 0z',
    ), // key: 12ttoo
  ]);

  /// `package-plus.mjs`
  static const ElLucideGlyph
  packagePlus = ElLucideGlyph('package-plus', <ElIconElement>[
    ElIconPathElement('M12 22V12'), // key: d0xqtd
    ElIconPathElement('M16 17h6'), // key: 1ook5g
    ElIconPathElement('M19 14v6'), // key: 1ckrd5
    ElIconPathElement(
      'M21 10.535V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.729l7 4a2 2 0 0 0 2 .001l1.675-.955',
    ), // key: 28k6lz
    ElIconPathElement('M3.29 7 12 12l8.71-5'), // key: 19ckod
    ElIconPathElement('m7.5 4.27 8.997 5.148'), // key: 9yrvtv
  ]);

  /// `package-search.mjs`
  static const ElLucideGlyph
  packageSearch = ElLucideGlyph('package-search', <ElIconElement>[
    ElIconPathElement('M12 22V12'), // key: d0xqtd
    ElIconPathElement('M20.27 18.27 22 20'), // key: er2am
    ElIconPathElement(
      'M21 10.498V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.729l7 4a2 2 0 0 0 2 .001l.98-.559',
    ), // key: tok1h1
    ElIconPathElement('M3.29 7 12 12l8.71-5'), // key: 19ckod
    ElIconPathElement('m7.5 4.27 8.997 5.148'), // key: 9yrvtv
    ElIconCircleElement(18.5, 16.5, 2.5), // key: ke13xx
  ]);

  /// `package-x.mjs`
  static const ElLucideGlyph
  packageX = ElLucideGlyph('package-x', <ElIconElement>[
    ElIconPathElement('M12 22V12'), // key: d0xqtd
    ElIconPathElement('m16.5 14.5 5 5'), // key: ozpm51
    ElIconPathElement('m16.5 19.5 5-5'), // key: syf6b9
    ElIconPathElement(
      'M21 10.5V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.729l7 4a2 2 0 0 0 2 .001l.13-.074',
    ), // key: isw6gs
    ElIconPathElement('M3.29 7 12 12l8.71-5'), // key: 19ckod
    ElIconPathElement('m7.5 4.27 8.997 5.148'), // key: 9yrvtv
  ]);

  /// `package.mjs`
  static const ElLucideGlyph package = ElLucideGlyph('package', <ElIconElement>[
    ElIconPathElement(
      'M11 21.73a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73z',
    ), // key: 1a0edw
    ElIconPathElement('M12 22V12'), // key: d0xqtd
    ElIconPolylineElement(<Offset>[
      Offset(3.29, 7),
      Offset(12, 12),
      Offset(20.71, 7),
    ]), // key: ousv84
    ElIconPathElement('m7.5 4.27 9 5.15'), // key: 1c824w
  ]);

  /// `paint-bucket.mjs`
  static const ElLucideGlyph
  paintBucket = ElLucideGlyph('paint-bucket', <ElIconElement>[
    ElIconPathElement('M11 7 6 2'), // key: 1jwth8
    ElIconPathElement('M18.992 12H2.041'), // key: xw1gg
    ElIconPathElement(
      'M21.145 18.38A3.34 3.34 0 0 1 20 16.5a3.3 3.3 0 0 1-1.145 1.88c-.575.46-.855 1.02-.855 1.595A2 2 0 0 0 20 22a2 2 0 0 0 2-2.025c0-.58-.285-1.13-.855-1.595',
    ), // key: 1nkol4
    ElIconPathElement(
      'm8.5 4.5 2.148-2.148a1.205 1.205 0 0 1 1.704 0l7.296 7.296a1.205 1.205 0 0 1 0 1.704l-7.592 7.592a3.615 3.615 0 0 1-5.112 0l-3.888-3.888a3.615 3.615 0 0 1 0-5.112L5.67 7.33',
    ), // key: 1nk1rd
  ]);

  /// `paint-roller.mjs`
  static const ElLucideGlyph paintRoller = ElLucideGlyph(
    'paint-roller',
    <ElIconElement>[
      ElIconRectElement(2, 2, 16, 6, 2), // key: jcyz7m
      ElIconPathElement(
        'M10 16v-2a2 2 0 0 1 2-2h8a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2',
      ), // key: 1b9h7c
      ElIconRectElement(8, 16, 4, 6, 1), // key: d6e7yl
    ],
  );

  /// `paintbrush-vertical.mjs`
  static const ElLucideGlyph
  paintbrushVertical = ElLucideGlyph('paintbrush-vertical', <ElIconElement>[
    ElIconPathElement('M10 2v2'), // key: 7u0qdc
    ElIconPathElement('M14 2v4'), // key: qmzblu
    ElIconPathElement(
      'M17 2a1 1 0 0 1 1 1v9H6V3a1 1 0 0 1 1-1z',
    ), // key: ycvu00
    ElIconPathElement(
      'M6 12a1 1 0 0 0-1 1v1a2 2 0 0 0 2 2h2a1 1 0 0 1 1 1v2.9a2 2 0 1 0 4 0V17a1 1 0 0 1 1-1h2a2 2 0 0 0 2-2v-1a1 1 0 0 0-1-1',
    ), // key: iw4wnp
  ]);

  /// `paintbrush.mjs`
  static const ElLucideGlyph
  paintbrush = ElLucideGlyph('paintbrush', <ElIconElement>[
    ElIconPathElement('m14.622 17.897-10.68-2.913'), // key: vj2p1u
    ElIconPathElement(
      'M18.376 2.622a1 1 0 1 1 3.002 3.002L17.36 9.643a.5.5 0 0 0 0 .707l.944.944a2.41 2.41 0 0 1 0 3.408l-.944.944a.5.5 0 0 1-.707 0L8.354 7.348a.5.5 0 0 1 0-.707l.944-.944a2.41 2.41 0 0 1 3.408 0l.944.944a.5.5 0 0 0 .707 0z',
    ), // key: 18tc5c
    ElIconPathElement(
      'M9 8c-1.804 2.71-3.97 3.46-6.583 3.948a.507.507 0 0 0-.302.819l7.32 8.883a1 1 0 0 0 1.185.204C12.735 20.405 16 16.792 16 15',
    ), // key: ytzfxy
  ]);

  /// `palette.mjs`
  static const ElLucideGlyph palette = ElLucideGlyph('palette', <ElIconElement>[
    ElIconPathElement(
      'M12 22a1 1 0 0 1 0-20 10 9 0 0 1 10 9 5 5 0 0 1-5 5h-2.25a1.75 1.75 0 0 0-1.4 2.8l.3.4a1.75 1.75 0 0 1-1.4 2.8z',
    ), // key: e79jfc
    ElIconCircleElement(13.5, 6.5, 0.5, filled: true), // key: 1okk4w
    ElIconCircleElement(17.5, 10.5, 0.5, filled: true), // key: f64h9f
    ElIconCircleElement(6.5, 12.5, 0.5, filled: true), // key: qy21gx
    ElIconCircleElement(8.5, 7.5, 0.5, filled: true), // key: fotxhn
  ]);

  /// `panda.mjs`
  static const ElLucideGlyph panda = ElLucideGlyph('panda', <ElIconElement>[
    ElIconPathElement('M11.25 17.25h1.5L12 18z'), // key: 1wmwwj
    ElIconPathElement('m15 12 2 2'), // key: k60wz4
    ElIconPathElement('M18 6.5a.5.5 0 0 0-.5-.5'), // key: 1ch4h4
    ElIconPathElement(
      'M20.69 9.67a4.5 4.5 0 1 0-7.04-5.5 8.35 8.35 0 0 0-3.3 0 4.5 4.5 0 1 0-7.04 5.5C2.49 11.2 2 12.88 2 14.5 2 19.47 6.48 22 12 22s10-2.53 10-7.5c0-1.62-.48-3.3-1.3-4.83',
    ), // key: 1c660l
    ElIconPathElement('M6 6.5a.495.495 0 0 1 .5-.5'), // key: eviuep
    ElIconPathElement('m9 12-2 2'), // key: 326nkw
  ]);

  /// `panel-bottom-close.mjs`
  static const ElLucideGlyph panelBottomClose = ElLucideGlyph(
    'panel-bottom-close',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M3 15h18'), // key: 5xshup
      ElIconPathElement('m15 8-3 3-3-3'), // key: 1oxy1z
    ],
  );

  /// `panel-bottom-dashed.mjs`
  static const ElLucideGlyph panelBottomDashed = ElLucideGlyph(
    'panel-bottom-dashed',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M14 15h1'), // key: 171nev
      ElIconPathElement('M19 15h2'), // key: 1vnucp
      ElIconPathElement('M3 15h2'), // key: 8bym0q
      ElIconPathElement('M9 15h1'), // key: 1tg3ks
    ],
  );

  /// `panel-bottom-open.mjs`
  static const ElLucideGlyph panelBottomOpen = ElLucideGlyph(
    'panel-bottom-open',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M3 15h18'), // key: 5xshup
      ElIconPathElement('m9 10 3-3 3 3'), // key: 11gsxs
    ],
  );

  /// `panel-bottom.mjs`
  static const ElLucideGlyph panelBottom = ElLucideGlyph(
    'panel-bottom',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M3 15h18'), // key: 5xshup
    ],
  );

  /// `panel-left-close.mjs`
  static const ElLucideGlyph panelLeftClose = ElLucideGlyph(
    'panel-left-close',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M9 3v18'), // key: fh3hqa
      ElIconPathElement('m16 15-3-3 3-3'), // key: 14y99z
    ],
  );

  /// `panel-left-dashed.mjs`
  static const ElLucideGlyph panelLeftDashed = ElLucideGlyph(
    'panel-left-dashed',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M9 14v1'), // key: askpd8
      ElIconPathElement('M9 19v2'), // key: 16tejx
      ElIconPathElement('M9 3v2'), // key: 1noubl
      ElIconPathElement('M9 9v1'), // key: 19ebxg
    ],
  );

  /// `panel-left-open.mjs`
  static const ElLucideGlyph panelLeftOpen = ElLucideGlyph(
    'panel-left-open',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M9 3v18'), // key: fh3hqa
      ElIconPathElement('m14 9 3 3-3 3'), // key: 8010ee
    ],
  );

  /// `panel-left-right-dashed.mjs`
  static const ElLucideGlyph panelLeftRightDashed = ElLucideGlyph(
    'panel-left-right-dashed',
    <ElIconElement>[
      ElIconPathElement('M15 10V9'), // key: 4dkmfx
      ElIconPathElement('M15 15v-1'), // key: 6a4afx
      ElIconPathElement('M15 21v-2'), // key: 1qshmc
      ElIconPathElement('M15 5V3'), // key: 1fk0mb
      ElIconPathElement('M9 10V9'), // key: 1lazqi
      ElIconPathElement('M9 15v-1'), // key: 9lx740
      ElIconPathElement('M9 21v-2'), // key: 1fwk0n
      ElIconPathElement('M9 5V3'), // key: 2q8zi6
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `panel-left.mjs`
  static const ElLucideGlyph panelLeft = ElLucideGlyph(
    'panel-left',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M9 3v18'), // key: fh3hqa
    ],
  );

  /// `panel-right-close.mjs`
  static const ElLucideGlyph panelRightClose = ElLucideGlyph(
    'panel-right-close',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M15 3v18'), // key: 14nvp0
      ElIconPathElement('m8 9 3 3-3 3'), // key: 12hl5m
    ],
  );

  /// `panel-right-dashed.mjs`
  static const ElLucideGlyph panelRightDashed = ElLucideGlyph(
    'panel-right-dashed',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M15 14v1'), // key: ilsfch
      ElIconPathElement('M15 19v2'), // key: 1fst2f
      ElIconPathElement('M15 3v2'), // key: z204g4
      ElIconPathElement('M15 9v1'), // key: z2a8b1
    ],
  );

  /// `panel-right-open.mjs`
  static const ElLucideGlyph panelRightOpen = ElLucideGlyph(
    'panel-right-open',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M15 3v18'), // key: 14nvp0
      ElIconPathElement('m10 15-3-3 3-3'), // key: 1pgupc
    ],
  );

  /// `panel-right.mjs`
  static const ElLucideGlyph panelRight = ElLucideGlyph(
    'panel-right',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M15 3v18'), // key: 14nvp0
    ],
  );

  /// `panel-top-bottom-dashed.mjs`
  static const ElLucideGlyph panelTopBottomDashed = ElLucideGlyph(
    'panel-top-bottom-dashed',
    <ElIconElement>[
      ElIconPathElement('M14 15h1'), // key: 171nev
      ElIconPathElement('M14 9h1'), // key: l0svgy
      ElIconPathElement('M19 15h2'), // key: 1vnucp
      ElIconPathElement('M19 9h2'), // key: te2zfg
      ElIconPathElement('M3 15h2'), // key: 8bym0q
      ElIconPathElement('M3 9h2'), // key: 1h4ldw
      ElIconPathElement('M9 15h1'), // key: 1tg3ks
      ElIconPathElement('M9 9h1'), // key: 15jzuz
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `panel-top-close.mjs`
  static const ElLucideGlyph panelTopClose = ElLucideGlyph(
    'panel-top-close',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('m9 16 3-3 3 3'), // key: 1idcnm
    ],
  );

  /// `panel-top-dashed.mjs`
  static const ElLucideGlyph panelTopDashed = ElLucideGlyph(
    'panel-top-dashed',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M14 9h1'), // key: l0svgy
      ElIconPathElement('M19 9h2'), // key: te2zfg
      ElIconPathElement('M3 9h2'), // key: 1h4ldw
      ElIconPathElement('M9 9h1'), // key: 15jzuz
    ],
  );

  /// `panel-top-open.mjs`
  static const ElLucideGlyph panelTopOpen = ElLucideGlyph(
    'panel-top-open',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('m15 14-3 3-3-3'), // key: g215vf
    ],
  );

  /// `panel-top.mjs`
  static const ElLucideGlyph panelTop = ElLucideGlyph(
    'panel-top',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M3 9h18'), // key: 1pudct
    ],
  );

  /// `panels-left-bottom.mjs`
  static const ElLucideGlyph panelsLeftBottom = ElLucideGlyph(
    'panels-left-bottom',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M9 3v18'), // key: fh3hqa
      ElIconPathElement('M9 15h12'), // key: 5ijen5
    ],
  );

  /// `panels-right-bottom.mjs`
  static const ElLucideGlyph panelsRightBottom = ElLucideGlyph(
    'panels-right-bottom',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M3 15h12'), // key: 1wkqb3
      ElIconPathElement('M15 3v18'), // key: 14nvp0
    ],
  );

  /// `panels-top-left.mjs`
  static const ElLucideGlyph panelsTopLeft = ElLucideGlyph(
    'panels-top-left',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconPathElement('M9 21V9'), // key: 1oto5p
    ],
  );

  /// `paper-bag.mjs`
  static const ElLucideGlyph
  paperBag = ElLucideGlyph('paper-bag', <ElIconElement>[
    ElIconPathElement(
      'M5.364 3.848C4 6 3 9.652 3 12.652V19a2 2 0 002 2h14a2 2 0 002-2v-5c0-2.334-1.816-4.668-2.622-7.002',
    ), // key: vlsvfu
    ElIconPathElement(
      'M7 3h11.379a2 2 0 011.789 1.106l.723 1.447A1 1 0 0119.997 7h-8.525a2 2 0 01-1.789-1.106L8.79 4.105a2 2 0 10-3.579 1.789l2.261 4.522A5 5 0 018 12.652V21',
    ), // key: 12exh5
  ]);

  /// `paperclip.mjs`
  static const ElLucideGlyph
  paperclip = ElLucideGlyph('paperclip', <ElIconElement>[
    ElIconPathElement(
      'm16 6-8.414 8.586a2 2 0 0 0 2.829 2.829l8.414-8.586a4 4 0 1 0-5.657-5.657l-8.379 8.551a6 6 0 1 0 8.485 8.485l8.379-8.551',
    ), // key: 1miecu
  ]);

  /// `parasol.mjs`
  static const ElLucideGlyph parasol = ElLucideGlyph('parasol', <ElIconElement>[
    ElIconPathElement('M12.5 11.134 18.196 21'), // key: gf58kt
    ElIconPathElement(
      'M20.425 5.299a10 10 0 0 0-16.941 9.78c.183.563.843.774 1.355.478L20.16 6.711c.512-.296.66-.973.264-1.413',
    ), // key: znqfe4
    ElIconPathElement('M21 21H3'), // key: oafrgs
  ]);

  /// `parentheses.mjs`
  static const ElLucideGlyph parentheses = ElLucideGlyph(
    'parentheses',
    <ElIconElement>[
      ElIconPathElement('M8 21s-4-3-4-9 4-9 4-9'), // key: uto9ud
      ElIconPathElement('M16 3s4 3 4 9-4 9-4 9'), // key: 4w2vsq
    ],
  );

  /// `parking-meter.mjs`
  static const ElLucideGlyph
  parkingMeter = ElLucideGlyph('parking-meter', <ElIconElement>[
    ElIconPathElement('M11 15h2'), // key: 199qp6
    ElIconPathElement('M12 12v3'), // key: 158kv8
    ElIconPathElement('M12 19v3'), // key: npa21l
    ElIconPathElement(
      'M15.282 19a1 1 0 0 0 .948-.68l2.37-6.988a7 7 0 1 0-13.2 0l2.37 6.988a1 1 0 0 0 .948.68z',
    ), // key: 1jofit
    ElIconPathElement('M9 9a3 3 0 1 1 6 0'), // key: jdoeu8
  ]);

  /// `party-popper.mjs`
  static const ElLucideGlyph
  partyPopper = ElLucideGlyph('party-popper', <ElIconElement>[
    ElIconPathElement('M5.8 11.3 2 22l10.7-3.79'), // key: gwxi1d
    ElIconPathElement('M4 3h.01'), // key: 1vcuye
    ElIconPathElement('M22 8h.01'), // key: 1mrtc2
    ElIconPathElement('M15 2h.01'), // key: 1cjtqr
    ElIconPathElement('M22 20h.01'), // key: 1mrys2
    ElIconPathElement(
      'm22 2-2.24.75a2.9 2.9 0 0 0-1.96 3.12c.1.86-.57 1.63-1.45 1.63h-.38c-.86 0-1.6.6-1.76 1.44L14 10',
    ), // key: hbicv8
    ElIconPathElement(
      'm22 13-.82-.33c-.86-.34-1.82.2-1.98 1.11c-.11.7-.72 1.22-1.43 1.22H17',
    ), // key: 1i94pl
    ElIconPathElement(
      'm11 2 .33.82c.34.86-.2 1.82-1.11 1.98C9.52 4.9 9 5.52 9 6.23V7',
    ), // key: 1cofks
    ElIconPathElement(
      'M11 13c1.93 1.93 2.83 4.17 2 5-.83.83-3.07-.07-5-2-1.93-1.93-2.83-4.17-2-5 .83-.83 3.07.07 5 2Z',
    ), // key: 4kbmks
  ]);

  /// `pause.mjs`
  static const ElLucideGlyph pause = ElLucideGlyph('pause', <ElIconElement>[
    ElIconRectElement(14, 3, 5, 18, 1), // key: kaeet6
    ElIconRectElement(5, 3, 5, 18, 1), // key: 1wsw3u
  ]);

  /// `paw-print.mjs`
  static const ElLucideGlyph
  pawPrint = ElLucideGlyph('paw-print', <ElIconElement>[
    ElIconCircleElement(11, 4, 2), // key: vol9p0
    ElIconCircleElement(18, 8, 2), // key: 17gozi
    ElIconCircleElement(20, 16, 2), // key: 1v9bxh
    ElIconPathElement(
      'M9 10a5 5 0 0 1 5 5v3.5a3.5 3.5 0 0 1-6.84 1.045Q6.52 17.48 4.46 16.84A3.5 3.5 0 0 1 5.5 10Z',
    ), // key: 1ydw1z
  ]);

  /// `pc-case.mjs`
  static const ElLucideGlyph pcCase = ElLucideGlyph('pc-case', <ElIconElement>[
    ElIconRectElement(5, 2, 14, 20, 2), // key: 1uq1d7
    ElIconPathElement('M15 14h.01'), // key: 1kp3bh
    ElIconPathElement('M9 6h6'), // key: dgm16u
    ElIconPathElement('M9 10h6'), // key: 9gxzsh
  ]);

  /// `pen-line.mjs`
  static const ElLucideGlyph
  penLine = ElLucideGlyph('pen-line', <ElIconElement>[
    ElIconPathElement('M13 21h8'), // key: 1jsn5i
    ElIconPathElement(
      'M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z',
    ), // key: 1a8usu
  ]);

  /// `pen-off.mjs`
  static const ElLucideGlyph penOff = ElLucideGlyph('pen-off', <ElIconElement>[
    ElIconPathElement(
      'm10 10-6.157 6.162a2 2 0 0 0-.5.833l-1.322 4.36a.5.5 0 0 0 .622.624l4.358-1.323a2 2 0 0 0 .83-.5L14 13.982',
    ), // key: bjo8r8
    ElIconPathElement(
      'm12.829 7.172 4.359-4.346a1 1 0 1 1 3.986 3.986l-4.353 4.353',
    ), // key: 16h5ne
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `pen-tool.mjs`
  static const ElLucideGlyph
  penTool = ElLucideGlyph('pen-tool', <ElIconElement>[
    ElIconPathElement(
      'M15.707 21.293a1 1 0 0 1-1.414 0l-1.586-1.586a1 1 0 0 1 0-1.414l5.586-5.586a1 1 0 0 1 1.414 0l1.586 1.586a1 1 0 0 1 0 1.414z',
    ), // key: nt11vn
    ElIconPathElement(
      'm18 13-1.375-6.874a1 1 0 0 0-.746-.776L3.235 2.028a1 1 0 0 0-1.207 1.207L5.35 15.879a1 1 0 0 0 .776.746L13 18',
    ), // key: 15qc1e
    ElIconPathElement('m2.3 2.3 7.286 7.286'), // key: 1wuzzi
    ElIconCircleElement(11, 11, 2), // key: xmgehs
  ]);

  /// `pen.mjs`
  static const ElLucideGlyph pen = ElLucideGlyph('pen', <ElIconElement>[
    ElIconPathElement(
      'M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z',
    ), // key: 1a8usu
  ]);

  /// `pencil-line.mjs`
  static const ElLucideGlyph
  pencilLine = ElLucideGlyph('pencil-line', <ElIconElement>[
    ElIconPathElement('M13 21h8'), // key: 1jsn5i
    ElIconPathElement('m15 5 4 4'), // key: 1mk7zo
    ElIconPathElement(
      'M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z',
    ), // key: 1a8usu
  ]);

  /// `pencil-off.mjs`
  static const ElLucideGlyph
  pencilOff = ElLucideGlyph('pencil-off', <ElIconElement>[
    ElIconPathElement(
      'm10 10-6.157 6.162a2 2 0 0 0-.5.833l-1.322 4.36a.5.5 0 0 0 .622.624l4.358-1.323a2 2 0 0 0 .83-.5L14 13.982',
    ), // key: bjo8r8
    ElIconPathElement(
      'm12.829 7.172 4.359-4.346a1 1 0 1 1 3.986 3.986l-4.353 4.353',
    ), // key: 16h5ne
    ElIconPathElement('m15 5 4 4'), // key: 1mk7zo
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `pencil-ruler.mjs`
  static const ElLucideGlyph
  pencilRuler = ElLucideGlyph('pencil-ruler', <ElIconElement>[
    ElIconPathElement(
      'M13 7 8.7 2.7a2.41 2.41 0 0 0-3.4 0L2.7 5.3a2.41 2.41 0 0 0 0 3.4L7 13',
    ), // key: orapub
    ElIconPathElement('m8 6 2-2'), // key: 115y1s
    ElIconPathElement('m18 16 2-2'), // key: ee94s4
    ElIconPathElement(
      'm17 11 4.3 4.3c.94.94.94 2.46 0 3.4l-2.6 2.6c-.94.94-2.46.94-3.4 0L11 17',
    ), // key: cfq27r
    ElIconPathElement(
      'M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z',
    ), // key: 1a8usu
    ElIconPathElement('m15 5 4 4'), // key: 1mk7zo
  ]);

  /// `pencil-sparkles.mjs`
  static const ElLucideGlyph
  pencilSparkles = ElLucideGlyph('pencil-sparkles', <ElIconElement>[
    ElIconPathElement('M10 3H8'), // key: mzdi2d
    ElIconPathElement('m15.007 5.008 3.987 3.986'), // key: 1scubj
    ElIconPathElement('M20 15v4'), // key: nmhudv
    ElIconPathElement(
      'M21.174 6.813a2.82 2.82 0 0 0-3.986-3.987L3.842 16.175a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z',
    ), // key: fs0856
    ElIconPathElement('M22 17h-4'), // key: 1sj068
    ElIconPathElement('M4 5v4'), // key: 13jjxc
    ElIconPathElement('M6 7H2'), // key: 8zbtv0
    ElIconPathElement('M9 2v2'), // key: 165o2o
  ]);

  /// `pencil.mjs`
  static const ElLucideGlyph pencil = ElLucideGlyph('pencil', <ElIconElement>[
    ElIconPathElement(
      'M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z',
    ), // key: 1a8usu
    ElIconPathElement('m15 5 4 4'), // key: 1mk7zo
  ]);

  /// `pentagon.mjs`
  static const ElLucideGlyph
  pentagon = ElLucideGlyph('pentagon', <ElIconElement>[
    ElIconPathElement(
      'M10.83 2.38a2 2 0 0 1 2.34 0l8 5.74a2 2 0 0 1 .73 2.25l-3.04 9.26a2 2 0 0 1-1.9 1.37H7.04a2 2 0 0 1-1.9-1.37L2.1 10.37a2 2 0 0 1 .73-2.25z',
    ), // key: 2hea0t
  ]);

  /// `percent.mjs`
  static const ElLucideGlyph percent = ElLucideGlyph('percent', <ElIconElement>[
    ElIconLineElement(19, 5, 5, 19), // key: 1x9vlm
    ElIconCircleElement(6.5, 6.5, 2.5), // key: 4mh3h7
    ElIconCircleElement(17.5, 17.5, 2.5), // key: 1mdrzq
  ]);

  /// `person-standing.mjs`
  static const ElLucideGlyph personStanding = ElLucideGlyph(
    'person-standing',
    <ElIconElement>[
      ElIconCircleElement(12, 5, 1), // key: gxeob9
      ElIconPathElement('m9 20 3-6 3 6'), // key: se2kox
      ElIconPathElement('m6 8 6 2 6-2'), // key: 4o3us4
      ElIconPathElement('M12 10v4'), // key: 1kjpxc
    ],
  );

  /// `phi.mjs`
  static const ElLucideGlyph phi = ElLucideGlyph('phi', <ElIconElement>[
    ElIconPathElement('M12 2v20'), // key: t6zp3m
    ElIconCircleElement(12, 12, 7), // key: fim9np
  ]);

  /// `philippine-peso.mjs`
  static const ElLucideGlyph philippinePeso = ElLucideGlyph(
    'philippine-peso',
    <ElIconElement>[
      ElIconPathElement('M20 11H4'), // key: 6ut86h
      ElIconPathElement('M20 7H4'), // key: zbl0bi
      ElIconPathElement(
        'M7 21V4a1 1 0 0 1 1-1h4a1 1 0 0 1 0 12H7',
      ), // key: 1ana5r
    ],
  );

  /// `phone-call.mjs`
  static const ElLucideGlyph
  phoneCall = ElLucideGlyph('phone-call', <ElIconElement>[
    ElIconPathElement('M13 2a9 9 0 0 1 9 9'), // key: 1itnx2
    ElIconPathElement('M13 6a5 5 0 0 1 5 5'), // key: 11nki7
    ElIconPathElement(
      'M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384',
    ), // key: 9njp5v
  ]);

  /// `phone-forwarded.mjs`
  static const ElLucideGlyph
  phoneForwarded = ElLucideGlyph('phone-forwarded', <ElIconElement>[
    ElIconPathElement('M14 6h8'), // key: yd68k4
    ElIconPathElement('m18 2 4 4-4 4'), // key: pucp1d
    ElIconPathElement(
      'M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384',
    ), // key: 9njp5v
  ]);

  /// `phone-incoming.mjs`
  static const ElLucideGlyph
  phoneIncoming = ElLucideGlyph('phone-incoming', <ElIconElement>[
    ElIconPathElement('M16 2v6h6'), // key: 1mfrl5
    ElIconPathElement('m22 2-6 6'), // key: 6f0sa0
    ElIconPathElement(
      'M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384',
    ), // key: 9njp5v
  ]);

  /// `phone-missed.mjs`
  static const ElLucideGlyph
  phoneMissed = ElLucideGlyph('phone-missed', <ElIconElement>[
    ElIconPathElement('m16 2 6 6'), // key: 1gw87d
    ElIconPathElement('m22 2-6 6'), // key: 6f0sa0
    ElIconPathElement(
      'M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384',
    ), // key: 9njp5v
  ]);

  /// `phone-off.mjs`
  static const ElLucideGlyph
  phoneOff = ElLucideGlyph('phone-off', <ElIconElement>[
    ElIconPathElement(
      'M10.1 13.9a14 14 0 0 0 3.732 2.668 1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2 18 18 0 0 1-12.728-5.272',
    ), // key: 1wngk7
    ElIconPathElement('M22 2 2 22'), // key: y4kqgn
    ElIconPathElement(
      'M4.76 13.582A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 .244.473',
    ), // key: 10hv5p
  ]);

  /// `phone-outgoing.mjs`
  static const ElLucideGlyph
  phoneOutgoing = ElLucideGlyph('phone-outgoing', <ElIconElement>[
    ElIconPathElement('m16 8 6-6'), // key: oawc05
    ElIconPathElement('M22 8V2h-6'), // key: oqy2zc
    ElIconPathElement(
      'M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384',
    ), // key: 9njp5v
  ]);

  /// `phone.mjs`
  static const ElLucideGlyph phone = ElLucideGlyph('phone', <ElIconElement>[
    ElIconPathElement(
      'M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384',
    ), // key: 9njp5v
  ]);

  /// `pi.mjs`
  static const ElLucideGlyph pi = ElLucideGlyph('pi', <ElIconElement>[
    ElIconLineElement(9, 4, 9, 20), // key: ovs5a5
    ElIconPathElement('M4 7c0-1.7 1.3-3 3-3h13'), // key: 10pag4
    ElIconPathElement('M18 20c-1.7 0-3-1.3-3-3V4'), // key: 1gaosr
  ]);

  /// `piano.mjs`
  static const ElLucideGlyph piano = ElLucideGlyph('piano', <ElIconElement>[
    ElIconPathElement(
      'M18.5 8c-1.4 0-2.6-.8-3.2-2A6.87 6.87 0 0 0 2 9v11a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-8.5C22 9.6 20.4 8 18.5 8',
    ), // key: lag0yf
    ElIconPathElement('M2 14h20'), // key: myj16y
    ElIconPathElement('M6 14v4'), // key: 9ng0ue
    ElIconPathElement('M10 14v4'), // key: 1v8uk5
    ElIconPathElement('M14 14v4'), // key: 1tqops
    ElIconPathElement('M18 14v4'), // key: 18uqwm
  ]);

  /// `pickaxe.mjs`
  static const ElLucideGlyph pickaxe = ElLucideGlyph('pickaxe', <ElIconElement>[
    ElIconPathElement(
      'm14 13-8.381 8.38a1 1 0 0 1-3.001-3L11 9.999',
    ), // key: 1lw9ds
    ElIconPathElement(
      'M15.973 4.027A13 13 0 0 0 5.902 2.373c-1.398.342-1.092 2.158.277 2.601a19.9 19.9 0 0 1 5.822 3.024',
    ), // key: ffj4ej
    ElIconPathElement(
      'M16.001 11.999a19.9 19.9 0 0 1 3.024 5.824c.444 1.369 2.26 1.676 2.603.278A13 13 0 0 0 20 8.069',
    ), // key: 8tj4zw
    ElIconPathElement(
      'M18.352 3.352a1.205 1.205 0 0 0-1.704 0l-5.296 5.296a1.205 1.205 0 0 0 0 1.704l2.296 2.296a1.205 1.205 0 0 0 1.704 0l5.296-5.296a1.205 1.205 0 0 0 0-1.704z',
    ), // key: hh6h97
  ]);

  /// `picture-in-picture-2.mjs`
  static const ElLucideGlyph pictureInPicture2 = ElLucideGlyph(
    'picture-in-picture-2',
    <ElIconElement>[
      ElIconPathElement(
        'M21 9V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v10c0 1.1.9 2 2 2h4',
      ), // key: daa4of
      ElIconRectElement(12, 13, 10, 7, 2), // key: 1nb8gs
    ],
  );

  /// `picture-in-picture.mjs`
  static const ElLucideGlyph pictureInPicture = ElLucideGlyph(
    'picture-in-picture',
    <ElIconElement>[
      ElIconPathElement('M2 10h6V4'), // key: zwrco
      ElIconPathElement('m2 4 6 6'), // key: ug085t
      ElIconPathElement('M21 10V7a2 2 0 0 0-2-2h-7'), // key: git5jr
      ElIconPathElement('M3 14v2a2 2 0 0 0 2 2h3'), // key: 1f7fh3
      ElIconRectElement(12, 14, 10, 7, 1), // key: 1wjs3o
    ],
  );

  /// `piggy-bank.mjs`
  static const ElLucideGlyph
  piggyBank = ElLucideGlyph('piggy-bank', <ElIconElement>[
    ElIconPathElement(
      'M11 17h3v2a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1v-3a3.16 3.16 0 0 0 2-2h1a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1h-1a5 5 0 0 0-2-4V3a4 4 0 0 0-3.2 1.6l-.3.4H11a6 6 0 0 0-6 6v1a5 5 0 0 0 2 4v3a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1z',
    ), // key: 1piglc
    ElIconPathElement('M16 10h.01'), // key: 1m94wz
    ElIconPathElement('M2 8v1a2 2 0 0 0 2 2h1'), // key: 1env43
  ]);

  /// `pilcrow-left.mjs`
  static const ElLucideGlyph pilcrowLeft = ElLucideGlyph(
    'pilcrow-left',
    <ElIconElement>[
      ElIconPathElement('M14 3v11'), // key: mlfb7b
      ElIconPathElement('M14 9h-3a3 3 0 0 1 0-6h9'), // key: 1ulc19
      ElIconPathElement('M18 3v11'), // key: 1phi0r
      ElIconPathElement('M22 18H2l4-4'), // key: yt65j9
      ElIconPathElement('m6 22-4-4'), // key: 6jgyf5
    ],
  );

  /// `pilcrow-right.mjs`
  static const ElLucideGlyph pilcrowRight = ElLucideGlyph(
    'pilcrow-right',
    <ElIconElement>[
      ElIconPathElement('M10 3v11'), // key: o3l5kj
      ElIconPathElement('M10 9H7a1 1 0 0 1 0-6h8'), // key: 1wb1nc
      ElIconPathElement('M14 3v11'), // key: mlfb7b
      ElIconPathElement('m18 14 4 4H2'), // key: 4r8io1
      ElIconPathElement('m22 18-4 4'), // key: 1hjjrd
    ],
  );

  /// `pilcrow.mjs`
  static const ElLucideGlyph pilcrow = ElLucideGlyph('pilcrow', <ElIconElement>[
    ElIconPathElement('M13 4v16'), // key: 8vvj80
    ElIconPathElement('M17 4v16'), // key: 7dpous
    ElIconPathElement('M19 4H9.5a4.5 4.5 0 0 0 0 9H13'), // key: sh4n9v
  ]);

  /// `pill-bottle.mjs`
  static const ElLucideGlyph
  pillBottle = ElLucideGlyph('pill-bottle', <ElIconElement>[
    ElIconPathElement(
      'M18 11h-4a1 1 0 0 0-1 1v5a1 1 0 0 0 1 1h4',
    ), // key: 17ldeb
    ElIconPathElement('M6 7v13a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V7'), // key: nc37y6
    ElIconRectElement(4, 2, 16, 5, 1), // key: 3jeezo
  ]);

  /// `pill.mjs`
  static const ElLucideGlyph pill = ElLucideGlyph('pill', <ElIconElement>[
    ElIconPathElement(
      'm10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z',
    ), // key: wa1lgi
    ElIconPathElement('m8.5 8.5 7 7'), // key: rvfmvr
  ]);

  /// `pin-off.mjs`
  static const ElLucideGlyph pinOff = ElLucideGlyph('pin-off', <ElIconElement>[
    ElIconPathElement('M12 17v5'), // key: bb1du9
    ElIconPathElement(
      'M15 9.34V7a1 1 0 0 1 1-1 2 2 0 0 0 0-4H7.89',
    ), // key: znwnzq
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement(
      'M9 9v1.76a2 2 0 0 1-1.11 1.79l-1.78.9A2 2 0 0 0 5 15.24V16a1 1 0 0 0 1 1h11',
    ), // key: c9qhm2
  ]);

  /// `pin.mjs`
  static const ElLucideGlyph pin = ElLucideGlyph('pin', <ElIconElement>[
    ElIconPathElement('M12 17v5'), // key: bb1du9
    ElIconPathElement(
      'M9 10.76a2 2 0 0 1-1.11 1.79l-1.78.9A2 2 0 0 0 5 15.24V16a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-.76a2 2 0 0 0-1.11-1.79l-1.78-.9A2 2 0 0 1 15 10.76V7a1 1 0 0 1 1-1 2 2 0 0 0 0-4H8a2 2 0 0 0 0 4 1 1 0 0 1 1 1z',
    ), // key: 1nkz8b
  ]);

  /// `pipette.mjs`
  static const ElLucideGlyph pipette = ElLucideGlyph('pipette', <ElIconElement>[
    ElIconPathElement(
      'm12 9-8.414 8.414A2 2 0 0 0 3 18.828v1.344a2 2 0 0 1-.586 1.414A2 2 0 0 1 3.828 21h1.344a2 2 0 0 0 1.414-.586L15 12',
    ), // key: 1y3wsu
    ElIconPathElement(
      'm18 9 .4.4a1 1 0 1 1-3 3l-3.8-3.8a1 1 0 1 1 3-3l.4.4 3.4-3.4a1 1 0 1 1 3 3z',
    ), // key: 110lr1
    ElIconPathElement('m2 22 .414-.414'), // key: jhxm08
  ]);

  /// `pizza.mjs`
  static const ElLucideGlyph pizza = ElLucideGlyph('pizza', <ElIconElement>[
    ElIconPathElement('m12 14-1 1'), // key: 11onhr
    ElIconPathElement('m13.75 18.25-1.25 1.42'), // key: 1yisr3
    ElIconPathElement(
      'M17.775 5.654a15.68 15.68 0 0 0-12.121 12.12',
    ), // key: 1qtqk6
    ElIconPathElement('M18.8 9.3a1 1 0 0 0 2.1 7.7'), // key: fbbbr2
    ElIconPathElement(
      'M21.964 20.732a1 1 0 0 1-1.232 1.232l-18-5a1 1 0 0 1-.695-1.232A19.68 19.68 0 0 1 15.732 2.037a1 1 0 0 1 1.232.695z',
    ), // key: 1hyfdd
  ]);

  /// `plane-landing.mjs`
  static const ElLucideGlyph
  planeLanding = ElLucideGlyph('plane-landing', <ElIconElement>[
    ElIconPathElement('M2 22h20'), // key: 272qi7
    ElIconPathElement(
      'M3.77 10.77 2 9l2-4.5 1.1.55c.55.28.9.84.9 1.45s.35 1.17.9 1.45L8 8.5l3-6 1.05.53a2 2 0 0 1 1.09 1.52l.72 5.4a2 2 0 0 0 1.09 1.52l4.4 2.2c.42.22.78.55 1.01.96l.6 1.03c.49.88-.06 1.98-1.06 2.1l-1.18.15c-.47.06-.95-.02-1.37-.24L4.29 11.15a2 2 0 0 1-.52-.38Z',
    ), // key: 1ma21e
  ]);

  /// `plane-takeoff.mjs`
  static const ElLucideGlyph
  planeTakeoff = ElLucideGlyph('plane-takeoff', <ElIconElement>[
    ElIconPathElement('M2 22h20'), // key: 272qi7
    ElIconPathElement(
      'M6.36 17.4 4 17l-2-4 1.1-.55a2 2 0 0 1 1.8 0l.17.1a2 2 0 0 0 1.8 0L8 12 5 6l.9-.45a2 2 0 0 1 2.09.2l4.02 3a2 2 0 0 0 2.1.2l4.19-2.06a2.41 2.41 0 0 1 1.73-.17L21 7a1.4 1.4 0 0 1 .87 1.99l-.38.76c-.23.46-.6.84-1.07 1.08L7.58 17.2a2 2 0 0 1-1.22.18Z',
    ), // key: fkigj9
  ]);

  /// `plane.mjs`
  static const ElLucideGlyph plane = ElLucideGlyph('plane', <ElIconElement>[
    ElIconPathElement(
      'M17.8 19.2 16 11l3.5-3.5C21 6 21.5 4 21 3c-1-.5-3 0-4.5 1.5L13 8 4.8 6.2c-.5-.1-.9.1-1.1.5l-.3.5c-.2.5-.1 1 .3 1.3L9 12l-2 3H4l-1 1 3 2 2 3 1-1v-3l3-2 3.5 5.3c.3.4.8.5 1.3.3l.5-.2c.4-.3.6-.7.5-1.2z',
    ), // key: 1v9wt8
  ]);

  /// `play-off.mjs`
  static const ElLucideGlyph playOff = ElLucideGlyph(
    'play-off',
    <ElIconElement>[
      ElIconPathElement(
        'm10.215 4.56 9.79 5.71a2 2 0 0 1 .003 3.458l-.393.23',
      ), // key: fdtkwz
      ElIconPathElement(
        'm16.042 16.042-8.034 4.686A2 2 0 0 1 5 19V5',
      ), // key: 1c8hxg
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ],
  );

  /// `play.mjs`
  static const ElLucideGlyph play = ElLucideGlyph('play', <ElIconElement>[
    ElIconPathElement(
      'M5 5a2 2 0 0 1 3.008-1.728l11.997 6.998a2 2 0 0 1 .003 3.458l-12 7A2 2 0 0 1 5 19z',
    ), // key: 10ikf1
  ]);

  /// `plug-2.mjs`
  static const ElLucideGlyph plug2 = ElLucideGlyph('plug-2', <ElIconElement>[
    ElIconPathElement('M9 2v6'), // key: 17ngun
    ElIconPathElement('M15 2v6'), // key: s7yy2p
    ElIconPathElement('M12 17v5'), // key: bb1du9
    ElIconPathElement('M5 8h14'), // key: pcz4l3
    ElIconPathElement('M6 11V8h12v3a6 6 0 1 1-12 0Z'), // key: wtfw2c
  ]);

  /// `plug-zap.mjs`
  static const ElLucideGlyph plugZap = ElLucideGlyph(
    'plug-zap',
    <ElIconElement>[
      ElIconPathElement(
        'M6.3 20.3a2.4 2.4 0 0 0 3.4 0L12 18l-6-6-2.3 2.3a2.4 2.4 0 0 0 0 3.4Z',
      ), // key: goz73y
      ElIconPathElement('m2 22 3-3'), // key: 19mgm9
      ElIconPathElement('M7.5 13.5 10 11'), // key: 7xgeeb
      ElIconPathElement('M10.5 16.5 13 14'), // key: 10btkg
      ElIconPathElement('m18 3-4 4h6l-4 4'), // key: 16psg9
    ],
  );

  /// `plug.mjs`
  static const ElLucideGlyph plug = ElLucideGlyph('plug', <ElIconElement>[
    ElIconPathElement('M12 22v-5'), // key: 1ega77
    ElIconPathElement('M15 8V2'), // key: 18g5xt
    ElIconPathElement(
      'M17 8a1 1 0 0 1 1 1v4a4 4 0 0 1-4 4h-4a4 4 0 0 1-4-4V9a1 1 0 0 1 1-1z',
    ), // key: 1xoxul
    ElIconPathElement('M9 8V2'), // key: 14iosj
  ]);

  /// `plus.mjs`
  static const ElLucideGlyph plus = ElLucideGlyph('plus', <ElIconElement>[
    ElIconPathElement('M5 12h14'), // key: 1ays0h
    ElIconPathElement('M12 5v14'), // key: s699le
  ]);

  /// `pocket-knife.mjs`
  static const ElLucideGlyph pocketKnife = ElLucideGlyph(
    'pocket-knife',
    <ElIconElement>[
      ElIconPathElement(
        'M3 2v1c0 1 2 1 2 2S3 6 3 7s2 1 2 2-2 1-2 2 2 1 2 2',
      ), // key: 19w3oe
      ElIconPathElement('M18 6h.01'), // key: 1v4wsw
      ElIconPathElement('M6 18h.01'), // key: uhywen
      ElIconPathElement(
        'M20.83 8.83a4 4 0 0 0-5.66-5.66l-12 12a4 4 0 1 0 5.66 5.66Z',
      ), // key: 6fykxj
      ElIconPathElement('M18 11.66V22a4 4 0 0 0 4-4V6'), // key: 1utzek
    ],
  );

  /// `podium.mjs`
  static const ElLucideGlyph podium = ElLucideGlyph('podium', <ElIconElement>[
    ElIconPathElement('M12 6V2h-1'), // key: 1hv4eo
    ElIconPathElement(
      'M9 15a1 1 0 0 0-1-1H4a1 1 0 0 0-1 1v5a1 1 0 0 0 1 1h16a1 1 0 0 0 1-1v-3a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1',
    ), // key: 1jvw5n
    ElIconPathElement(
      'M9 21V11a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v10',
    ), // key: rgi5dp
  ]);

  /// `pointer-off.mjs`
  static const ElLucideGlyph
  pointerOff = ElLucideGlyph('pointer-off', <ElIconElement>[
    ElIconPathElement('M10 4.5V4a2 2 0 0 0-2.41-1.957'), // key: jsi14n
    ElIconPathElement('M13.9 8.4a2 2 0 0 0-1.26-1.295'), // key: hirc7f
    ElIconPathElement(
      'M21.7 16.2A8 8 0 0 0 22 14v-3a2 2 0 1 0-4 0v-1a2 2 0 0 0-3.63-1.158',
    ), // key: 1jxb2e
    ElIconPathElement(
      'm7 15-1.8-1.8a2 2 0 0 0-2.79 2.86L6 19.7a7.74 7.74 0 0 0 6 2.3h2a8 8 0 0 0 5.657-2.343',
    ), // key: 10r7hm
    ElIconPathElement('M6 6v8'), // key: tv5xkp
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `pointer.mjs`
  static const ElLucideGlyph pointer = ElLucideGlyph('pointer', <ElIconElement>[
    ElIconPathElement('M22 14a8 8 0 0 1-8 8'), // key: 56vcr3
    ElIconPathElement('M18 11v-1a2 2 0 0 0-2-2a2 2 0 0 0-2 2'), // key: 1agjmk
    ElIconPathElement('M14 10V9a2 2 0 0 0-2-2a2 2 0 0 0-2 2v1'), // key: wdbh2u
    ElIconPathElement(
      'M10 9.5V4a2 2 0 0 0-2-2a2 2 0 0 0-2 2v10',
    ), // key: 1ibuk9
    ElIconPathElement(
      'M18 11a2 2 0 1 1 4 0v3a8 8 0 0 1-8 8h-2c-2.8 0-4.5-.86-5.99-2.34l-3.6-3.6a2 2 0 0 1 2.83-2.82L7 15',
    ), // key: g6ys72
  ]);

  /// `popcorn.mjs`
  static const ElLucideGlyph popcorn = ElLucideGlyph('popcorn', <ElIconElement>[
    ElIconPathElement(
      'M18 8a2 2 0 0 0 0-4 2 2 0 0 0-4 0 2 2 0 0 0-4 0 2 2 0 0 0-4 0 2 2 0 0 0 0 4',
    ), // key: 10td1f
    ElIconPathElement('M10 22 9 8'), // key: yjptiv
    ElIconPathElement('m14 22 1-14'), // key: 8jwc8b
    ElIconPathElement(
      'M20 8c.5 0 .9.4.8 1l-2.6 12c-.1.5-.7 1-1.2 1H7c-.6 0-1.1-.4-1.2-1L3.2 9c-.1-.6.3-1 .8-1Z',
    ), // key: 1qo33t
  ]);

  /// `popsicle.mjs`
  static const ElLucideGlyph
  popsicle = ElLucideGlyph('popsicle', <ElIconElement>[
    ElIconPathElement(
      'M18.6 14.4c.8-.8.8-2 0-2.8l-8.1-8.1a4.95 4.95 0 1 0-7.1 7.1l8.1 8.1c.9.7 2.1.7 2.9-.1Z',
    ), // key: 1o68ps
    ElIconPathElement('m22 22-5.5-5.5'), // key: 17o70y
  ]);

  /// `pound-sterling.mjs`
  static const ElLucideGlyph poundSterling = ElLucideGlyph(
    'pound-sterling',
    <ElIconElement>[
      ElIconPathElement('M18 7c0-5.333-8-5.333-8 0'), // key: 1prm2n
      ElIconPathElement('M10 7v14'), // key: 18tmcs
      ElIconPathElement('M6 21h12'), // key: 4dkmi1
      ElIconPathElement('M6 13h10'), // key: ybwr4a
    ],
  );

  /// `power-off.mjs`
  static const ElLucideGlyph powerOff = ElLucideGlyph(
    'power-off',
    <ElIconElement>[
      ElIconPathElement('M18.36 6.64A9 9 0 0 1 20.77 15'), // key: dxknvb
      ElIconPathElement('M6.16 6.16a9 9 0 1 0 12.68 12.68'), // key: 1x7qb5
      ElIconPathElement('M12 2v4'), // key: 3427ic
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ],
  );

  /// `power.mjs`
  static const ElLucideGlyph power = ElLucideGlyph('power', <ElIconElement>[
    ElIconPathElement('M12 2v10'), // key: mnfbl
    ElIconPathElement('M18.4 6.6a9 9 0 1 1-12.77.04'), // key: obofu9
  ]);

  /// `presentation.mjs`
  static const ElLucideGlyph presentation = ElLucideGlyph(
    'presentation',
    <ElIconElement>[
      ElIconPathElement('M2 3h20'), // key: 91anmk
      ElIconPathElement(
        'M21 3v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V3',
      ), // key: 2k9sn8
      ElIconPathElement('m7 21 5-5 5 5'), // key: bip4we
    ],
  );

  /// `printer-check.mjs`
  static const ElLucideGlyph
  printerCheck = ElLucideGlyph('printer-check', <ElIconElement>[
    ElIconPathElement(
      'M13.5 22H7a1 1 0 0 1-1-1v-6a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v.5',
    ), // key: qeb09x
    ElIconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
    ElIconPathElement(
      'M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v2',
    ), // key: 1md90i
    ElIconPathElement('M6 9V3a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v6'), // key: 1itne7
  ]);

  /// `printer-x.mjs`
  static const ElLucideGlyph
  printerX = ElLucideGlyph('printer-x', <ElIconElement>[
    ElIconPathElement(
      'M12.531 22H7a1 1 0 0 1-1-1v-6a1 1 0 0 1 1-1h6.377',
    ), // key: 1w39xo
    ElIconPathElement('m16.5 16.5 5 5'), // key: zc9lw7
    ElIconPathElement('m16.5 21.5 5-5'), // key: 1fr29m
    ElIconPathElement(
      'M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v1.5',
    ), // key: 18he39
    ElIconPathElement('M6 9V3a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v6'), // key: 1itne7
  ]);

  /// `printer.mjs`
  static const ElLucideGlyph printer = ElLucideGlyph('printer', <ElIconElement>[
    ElIconPathElement(
      'M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2',
    ), // key: 143wyd
    ElIconPathElement('M6 9V3a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v6'), // key: 1itne7
    ElIconRectElement(6, 14, 12, 8, 1), // key: 1ue0tg
  ]);

  /// `projector.mjs`
  static const ElLucideGlyph
  projector = ElLucideGlyph('projector', <ElIconElement>[
    ElIconPathElement('M5 7 3 5'), // key: 1yys58
    ElIconPathElement('M9 6V3'), // key: 1ptz9u
    ElIconPathElement('m13 7 2-2'), // key: 1w3vmq
    ElIconCircleElement(9, 13, 3), // key: 1mma13
    ElIconPathElement(
      'M11.83 12H20a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-4a2 2 0 0 1 2-2h2.17',
    ), // key: 2frwzc
    ElIconPathElement('M16 16h2'), // key: dnq2od
  ]);

  /// `proportions.mjs`
  static const ElLucideGlyph proportions = ElLucideGlyph(
    'proportions',
    <ElIconElement>[
      ElIconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
      ElIconPathElement('M12 9v11'), // key: 1fnkrn
      ElIconPathElement('M2 9h13a2 2 0 0 1 2 2v9'), // key: 11z3ex
    ],
  );

  /// `puzzle.mjs`
  static const ElLucideGlyph puzzle = ElLucideGlyph('puzzle', <ElIconElement>[
    ElIconPathElement(
      'M15.39 4.39a1 1 0 0 0 1.68-.474 2.5 2.5 0 1 1 3.014 3.015 1 1 0 0 0-.474 1.68l1.683 1.682a2.414 2.414 0 0 1 0 3.414L19.61 15.39a1 1 0 0 1-1.68-.474 2.5 2.5 0 1 0-3.014 3.015 1 1 0 0 1 .474 1.68l-1.683 1.682a2.414 2.414 0 0 1-3.414 0L8.61 19.61a1 1 0 0 0-1.68.474 2.5 2.5 0 1 1-3.014-3.015 1 1 0 0 0 .474-1.68l-1.683-1.682a2.414 2.414 0 0 1 0-3.414L4.39 8.61a1 1 0 0 1 1.68.474 2.5 2.5 0 1 0 3.014-3.015 1 1 0 0 1-.474-1.68l1.683-1.682a2.414 2.414 0 0 1 3.414 0z',
    ), // key: w46dr5
  ]);

  /// `pyramid.mjs`
  static const ElLucideGlyph pyramid = ElLucideGlyph('pyramid', <ElIconElement>[
    ElIconPathElement(
      'M2.5 16.88a1 1 0 0 1-.32-1.43l9-13.02a1 1 0 0 1 1.64 0l9 13.01a1 1 0 0 1-.32 1.44l-8.51 4.86a2 2 0 0 1-1.98 0Z',
    ), // key: aenxs0
    ElIconPathElement('M12 2v20'), // key: t6zp3m
  ]);

  /// `qr-code.mjs`
  static const ElLucideGlyph qrCode = ElLucideGlyph('qr-code', <ElIconElement>[
    ElIconRectElement(3, 3, 5, 5, 1), // key: 1tu5fj
    ElIconRectElement(16, 3, 5, 5, 1), // key: 1v8r4q
    ElIconRectElement(3, 16, 5, 5, 1), // key: 1x03jg
    ElIconPathElement('M21 16h-3a2 2 0 0 0-2 2v3'), // key: 177gqh
    ElIconPathElement('M21 21v.01'), // key: ents32
    ElIconPathElement('M12 7v3a2 2 0 0 1-2 2H7'), // key: 8crl2c
    ElIconPathElement('M3 12h.01'), // key: nlz23k
    ElIconPathElement('M12 3h.01'), // key: n36tog
    ElIconPathElement('M12 16v.01'), // key: 133mhm
    ElIconPathElement('M16 12h1'), // key: 1slzba
    ElIconPathElement('M21 12v.01'), // key: 1lwtk9
    ElIconPathElement('M12 21v-1'), // key: 1880an
  ]);

  /// `quote.mjs`
  static const ElLucideGlyph quote = ElLucideGlyph('quote', <ElIconElement>[
    ElIconPathElement(
      'M16 3a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2 1 1 0 0 1 1 1v1a2 2 0 0 1-2 2 1 1 0 0 0-1 1v2a1 1 0 0 0 1 1 6 6 0 0 0 6-6V5a2 2 0 0 0-2-2z',
    ), // key: rib7q0
    ElIconPathElement(
      'M5 3a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2 1 1 0 0 1 1 1v1a2 2 0 0 1-2 2 1 1 0 0 0-1 1v2a1 1 0 0 0 1 1 6 6 0 0 0 6-6V5a2 2 0 0 0-2-2z',
    ), // key: 1ymkrd
  ]);

  /// `rabbit.mjs`
  static const ElLucideGlyph rabbit = ElLucideGlyph('rabbit', <ElIconElement>[
    ElIconPathElement('M13 16a3 3 0 0 1 2.24 5'), // key: 1epib5
    ElIconPathElement('M18 12h.01'), // key: yjnet6
    ElIconPathElement(
      'M18 21h-8a4 4 0 0 1-4-4 7 7 0 0 1 7-7h.2L9.6 6.4a1 1 0 1 1 2.8-2.8L15.8 7h.2c3.3 0 6 2.7 6 6v1a2 2 0 0 1-2 2h-1a3 3 0 0 0-3 3',
    ), // key: ue9ozu
    ElIconPathElement('M20 8.54V4a2 2 0 1 0-4 0v3'), // key: 49iql8
    ElIconPathElement('M7.612 12.524a3 3 0 1 0-1.6 4.3'), // key: 1e33i0
  ]);

  /// `radar.mjs`
  static const ElLucideGlyph radar = ElLucideGlyph('radar', <ElIconElement>[
    ElIconPathElement('M19.07 4.93A10 10 0 0 0 6.99 3.34'), // key: z3du51
    ElIconPathElement('M4 6h.01'), // key: oypzma
    ElIconPathElement('M2.29 9.62A10 10 0 1 0 21.31 8.35'), // key: qzzz0
    ElIconPathElement('M16.24 7.76A6 6 0 1 0 8.23 16.67'), // key: 1yjesh
    ElIconPathElement('M12 18h.01'), // key: mhygvu
    ElIconPathElement('M17.99 11.66A6 6 0 0 1 15.77 16.67'), // key: 1u2y91
    ElIconCircleElement(12, 12, 2), // key: 1c9p78
    ElIconPathElement('m13.41 10.59 5.66-5.66'), // key: mhq4k0
  ]);

  /// `radiation.mjs`
  static const ElLucideGlyph
  radiation = ElLucideGlyph('radiation', <ElIconElement>[
    ElIconPathElement('M12 12h.01'), // key: 1mp3jc
    ElIconPathElement(
      'M14 15.4641a4 4 0 0 1-4 0L7.52786 19.74597 A 1 1 0 0 0 7.99303 21.16211 10 10 0 0 0 16.00697 21.16211 1 1 0 0 0 16.47214 19.74597z',
    ), // key: 1y4lzb
    ElIconPathElement(
      'M16 12a4 4 0 0 0-2-3.464l2.472-4.282a1 1 0 0 1 1.46-.305 10 10 0 0 1 4.006 6.94A1 1 0 0 1 21 12z',
    ), // key: 163ggk
    ElIconPathElement(
      'M8 12a4 4 0 0 1 2-3.464L7.528 4.254a1 1 0 0 0-1.46-.305 10 10 0 0 0-4.006 6.94A1 1 0 0 0 3 12z',
    ), // key: 1l9i0b
  ]);

  /// `radical.mjs`
  static const ElLucideGlyph radical = ElLucideGlyph('radical', <ElIconElement>[
    ElIconPathElement(
      'M3 12h3.28a1 1 0 0 1 .948.684l2.298 7.934a.5.5 0 0 0 .96-.044L13.82 4.771A1 1 0 0 1 14.792 4H21',
    ), // key: 1mqj8i
  ]);

  /// `radio-off.mjs`
  static const ElLucideGlyph radioOff = ElLucideGlyph(
    'radio-off',
    <ElIconElement>[
      ElIconPathElement('M13.414 13.414a2 2 0 1 1-2.828-2.828'), // key: srl686
      ElIconPathElement('M16.247 7.761a6 6 0 0 1 1.744 4.572'), // key: 1h86sp
      ElIconPathElement('M19.075 4.933a10 10 0 0 1 2.234 10.72'), // key: 1n13k4
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
      ElIconPathElement('M4.925 19.067a10 10 0 0 1 0-14.134'), // key: 1q22gi
      ElIconPathElement('M7.753 16.239a6 6 0 0 1 0-8.478'), // key: r2q7qm
    ],
  );

  /// `radio-receiver.mjs`
  static const ElLucideGlyph radioReceiver = ElLucideGlyph(
    'radio-receiver',
    <ElIconElement>[
      ElIconPathElement('M5 16v2'), // key: g5qcv5
      ElIconPathElement('M19 16v2'), // key: 1gbaio
      ElIconRectElement(2, 8, 20, 8, 2), // key: vjsjur
      ElIconPathElement('M18 12h.01'), // key: yjnet6
    ],
  );

  /// `radio-tower.mjs`
  static const ElLucideGlyph radioTower = ElLucideGlyph(
    'radio-tower',
    <ElIconElement>[
      ElIconPathElement('M4.9 16.1C1 12.2 1 5.8 4.9 1.9'), // key: s0qx1y
      ElIconPathElement('M7.8 4.7a6.14 6.14 0 0 0-.8 7.5'), // key: 1idnkw
      ElIconCircleElement(12, 9, 2), // key: 1092wv
      ElIconPathElement('M16.2 4.8c2 2 2.26 5.11.8 7.47'), // key: ojru2q
      ElIconPathElement('M19.1 1.9a9.96 9.96 0 0 1 0 14.1'), // key: rhi7fg
      ElIconPathElement('M9.5 18h5'), // key: mfy3pd
      ElIconPathElement('m8 22 4-11 4 11'), // key: 25yftu
    ],
  );

  /// `radio.mjs`
  static const ElLucideGlyph radio = ElLucideGlyph('radio', <ElIconElement>[
    ElIconPathElement('M16.247 7.761a6 6 0 0 1 0 8.478'), // key: 1fwjs5
    ElIconPathElement('M19.075 4.933a10 10 0 0 1 0 14.134'), // key: ehdyv1
    ElIconPathElement('M4.925 19.067a10 10 0 0 1 0-14.134'), // key: 1q22gi
    ElIconPathElement('M7.753 16.239a6 6 0 0 1 0-8.478'), // key: r2q7qm
    ElIconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `radius.mjs`
  static const ElLucideGlyph radius = ElLucideGlyph('radius', <ElIconElement>[
    ElIconPathElement('M20.34 17.52a10 10 0 1 0-2.82 2.82'), // key: fydyku
    ElIconCircleElement(19, 19, 2), // key: 17f5cg
    ElIconPathElement('m13.41 13.41 4.18 4.18'), // key: 1gqbwc
    ElIconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `rainbow.mjs`
  static const ElLucideGlyph rainbow = ElLucideGlyph('rainbow', <ElIconElement>[
    ElIconPathElement('M22 17a10 10 0 0 0-20 0'), // key: ozegv
    ElIconPathElement('M6 17a6 6 0 0 1 12 0'), // key: 5giftw
    ElIconPathElement('M10 17a2 2 0 0 1 4 0'), // key: gnsikk
  ]);

  /// `rat.mjs`
  static const ElLucideGlyph rat = ElLucideGlyph('rat', <ElIconElement>[
    ElIconPathElement('M13 22H4a2 2 0 0 1 0-4h12'), // key: bt3f23
    ElIconPathElement('M13.236 18a3 3 0 0 0-2.2-5'), // key: 1tbvmo
    ElIconPathElement('M16 9h.01'), // key: 1bdo4e
    ElIconPathElement(
      'M16.82 3.94a3 3 0 1 1 3.237 4.868l1.815 2.587a1.5 1.5 0 0 1-1.5 2.1l-2.872-.453a3 3 0 0 0-3.5 3',
    ), // key: 9ch7kn
    ElIconPathElement(
      'M17 4.988a3 3 0 1 0-5.2 2.052A7 7 0 0 0 4 14.015 4 4 0 0 0 8 18',
    ), // key: 3s7e9i
  ]);

  /// `ratio.mjs`
  static const ElLucideGlyph ratio = ElLucideGlyph('ratio', <ElIconElement>[
    ElIconRectElement(6, 2, 12, 20, 2), // key: 1oxtiu
    ElIconRectElement(2, 6, 20, 12, 2), // key: 9lu3g6
  ]);

  /// `receipt-cent.mjs`
  static const ElLucideGlyph
  receiptCent = ElLucideGlyph('receipt-cent', <ElIconElement>[
    ElIconPathElement('M12 7v10'), // key: jspqdw
    ElIconPathElement(
      'M14.828 14.829a4 4 0 0 1-5.656 0 4 4 0 0 1 0-5.657 4 4 0 0 1 5.656 0',
    ), // key: qvqont
    ElIconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
  ]);

  /// `receipt-euro.mjs`
  static const ElLucideGlyph
  receiptEuro = ElLucideGlyph('receipt-euro', <ElIconElement>[
    ElIconPathElement(
      'M15.828 14.829a4 4 0 0 1-5.656 0 4 4 0 0 1 0-5.657 4 4 0 0 1 5.656 0',
    ), // key: 16zdw4
    ElIconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
    ElIconPathElement('M8 12h5'), // key: 1g6qi8
  ]);

  /// `receipt-indian-rupee.mjs`
  static const ElLucideGlyph
  receiptIndianRupee = ElLucideGlyph('receipt-indian-rupee', <ElIconElement>[
    ElIconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
    ElIconPathElement('M8 11h8'), // key: vwpz6n
    ElIconPathElement('M8 7h8'), // key: i86dvs
    ElIconPathElement('M9 7a4 4 0 0 1 0 8H8l3 2'), // key: 1xaco0
  ]);

  /// `receipt-japanese-yen.mjs`
  static const ElLucideGlyph
  receiptJapaneseYen = ElLucideGlyph('receipt-japanese-yen', <ElIconElement>[
    ElIconPathElement('m12 10 3-3'), // key: 1mc12w
    ElIconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
    ElIconPathElement('M9 11h6'), // key: 1fldmi
    ElIconPathElement('M9 15h6'), // key: cctwl0
    ElIconPathElement('m9 7 3 3v7'), // key: 1x0cue
  ]);

  /// `receipt-pound-sterling.mjs`
  static const ElLucideGlyph
  receiptPoundSterling = ElLucideGlyph('receipt-pound-sterling', <
    ElIconElement
  >[
    ElIconPathElement('M10 17V9.5a1 1 0 0 1 5 0'), // key: td22vl
    ElIconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
    ElIconPathElement('M8 13h5'), // key: 1k9z8w
    ElIconPathElement('M8 17h7'), // key: 8mjdqu
  ]);

  /// `receipt-russian-ruble.mjs`
  static const ElLucideGlyph
  receiptRussianRuble = ElLucideGlyph('receipt-russian-ruble', <ElIconElement>[
    ElIconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
    ElIconPathElement('M8 11h5a2 2 0 0 0 0-4h-3v10'), // key: agnv0r
    ElIconPathElement('M8 15h5'), // key: vxg57a
  ]);

  /// `receipt-swiss-franc.mjs`
  static const ElLucideGlyph
  receiptSwissFranc = ElLucideGlyph('receipt-swiss-franc', <ElIconElement>[
    ElIconPathElement('M10 11h4'), // key: 1i0mka
    ElIconPathElement('M10 17V7h5'), // key: k7jq18
    ElIconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
    ElIconPathElement('M8 15h5'), // key: vxg57a
  ]);

  /// `receipt-text.mjs`
  static const ElLucideGlyph
  receiptText = ElLucideGlyph('receipt-text', <ElIconElement>[
    ElIconPathElement('M13 16H8'), // key: wsln4y
    ElIconPathElement('M14 8H8'), // key: 1l3xfs
    ElIconPathElement('M16 12H8'), // key: 1fr5h0
    ElIconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
  ]);

  /// `receipt-turkish-lira.mjs`
  static const ElLucideGlyph
  receiptTurkishLira = ElLucideGlyph('receipt-turkish-lira', <ElIconElement>[
    ElIconPathElement('M10 7v10a5 5 0 0 0 5-5'), // key: 1blmz7
    ElIconPathElement('m14 8-6 3'), // key: 2tb98i
    ElIconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
  ]);

  /// `receipt.mjs`
  static const ElLucideGlyph receipt = ElLucideGlyph('receipt', <ElIconElement>[
    ElIconPathElement('M12 17V7'), // key: pyj7ub
    ElIconPathElement(
      'M16 8h-6a2 2 0 0 0 0 4h4a2 2 0 0 1 0 4H8',
    ), // key: 1elt7d
    ElIconPathElement(
      'M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z',
    ), // key: ycz6yz
  ]);

  /// `rectangle-circle.mjs`
  static const ElLucideGlyph rectangleCircle = ElLucideGlyph(
    'rectangle-circle',
    <ElIconElement>[
      ElIconPathElement(
        'M14 4v16H3a1 1 0 0 1-1-1V5a1 1 0 0 1 1-1z',
      ), // key: 1m5n7q
      ElIconCircleElement(14, 12, 8), // key: 1pag6k
    ],
  );

  /// `rectangle-ellipsis.mjs`
  static const ElLucideGlyph rectangleEllipsis = ElLucideGlyph(
    'rectangle-ellipsis',
    <ElIconElement>[
      ElIconRectElement(2, 6, 20, 12, 2), // key: 9lu3g6
      ElIconPathElement('M12 12h.01'), // key: 1mp3jc
      ElIconPathElement('M17 12h.01'), // key: 1m0b6t
      ElIconPathElement('M7 12h.01'), // key: eqddd0
    ],
  );

  /// `rectangle-goggles.mjs`
  static const ElLucideGlyph
  rectangleGoggles = ElLucideGlyph('rectangle-goggles', <ElIconElement>[
    ElIconPathElement(
      'M20 6a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-4a2 2 0 0 1-1.6-.8l-1.6-2.13a1 1 0 0 0-1.6 0L9.6 17.2A2 2 0 0 1 8 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2z',
    ), // key: d5y1f
  ]);

  /// `rectangle-horizontal.mjs`
  static const ElLucideGlyph rectangleHorizontal = ElLucideGlyph(
    'rectangle-horizontal',
    <ElIconElement>[
      ElIconRectElement(2, 6, 20, 12, 2), // key: 9lu3g6
    ],
  );

  /// `rectangle-vertical.mjs`
  static const ElLucideGlyph rectangleVertical = ElLucideGlyph(
    'rectangle-vertical',
    <ElIconElement>[
      ElIconRectElement(6, 2, 12, 20, 2), // key: 1oxtiu
    ],
  );

  /// `recycle.mjs`
  static const ElLucideGlyph recycle = ElLucideGlyph('recycle', <ElIconElement>[
    ElIconPathElement(
      'M7 19H4.815a1.83 1.83 0 0 1-1.57-.881 1.785 1.785 0 0 1-.004-1.784L7.196 9.5',
    ), // key: x6z5xu
    ElIconPathElement(
      'M11 19h8.203a1.83 1.83 0 0 0 1.556-.89 1.784 1.784 0 0 0 0-1.775l-1.226-2.12',
    ), // key: 1x4zh5
    ElIconPathElement('m14 16-3 3 3 3'), // key: f6jyew
    ElIconPathElement('M8.293 13.596 7.196 9.5 3.1 10.598'), // key: wf1obh
    ElIconPathElement(
      'm9.344 5.811 1.093-1.892A1.83 1.83 0 0 1 11.985 3a1.784 1.784 0 0 1 1.546.888l3.943 6.843',
    ), // key: 9tzpgr
    ElIconPathElement('m13.378 9.633 4.096 1.098 1.097-4.096'), // key: 1oe83g
  ]);

  /// `redo-2.mjs`
  static const ElLucideGlyph redo2 = ElLucideGlyph('redo-2', <ElIconElement>[
    ElIconPathElement('m15 14 5-5-5-5'), // key: 12vg1m
    ElIconPathElement(
      'M20 9H9.5A5.5 5.5 0 0 0 4 14.5A5.5 5.5 0 0 0 9.5 20H13',
    ), // key: 6uklza
  ]);

  /// `redo-dot.mjs`
  static const ElLucideGlyph redoDot = ElLucideGlyph(
    'redo-dot',
    <ElIconElement>[
      ElIconCircleElement(12, 17, 1), // key: 1ixnty
      ElIconPathElement('M21 7v6h-6'), // key: 3ptur4
      ElIconPathElement(
        'M3 17a9 9 0 0 1 9-9 9 9 0 0 1 6 2.3l3 2.7',
      ), // key: 1kgawr
    ],
  );

  /// `redo.mjs`
  static const ElLucideGlyph redo = ElLucideGlyph('redo', <ElIconElement>[
    ElIconPathElement('M21 7v6h-6'), // key: 3ptur4
    ElIconPathElement(
      'M3 17a9 9 0 0 1 9-9 9 9 0 0 1 6 2.3l3 2.7',
    ), // key: 1kgawr
  ]);

  /// `refresh-ccw-dot.mjs`
  static const ElLucideGlyph refreshCcwDot = ElLucideGlyph(
    'refresh-ccw-dot',
    <ElIconElement>[
      ElIconPathElement(
        'M21 12a9 9 0 0 0-9-9 9.75 9.75 0 0 0-6.74 2.74L3 8',
      ), // key: 14sxne
      ElIconPathElement('M3 3v5h5'), // key: 1xhq8a
      ElIconPathElement(
        'M3 12a9 9 0 0 0 9 9 9.75 9.75 0 0 0 6.74-2.74L21 16',
      ), // key: 1hlbsb
      ElIconPathElement('M16 16h5v5'), // key: ccwih5
      ElIconCircleElement(12, 12, 1), // key: 41hilf
    ],
  );

  /// `refresh-ccw.mjs`
  static const ElLucideGlyph refreshCcw = ElLucideGlyph(
    'refresh-ccw',
    <ElIconElement>[
      ElIconPathElement(
        'M21 12a9 9 0 0 0-9-9 9.75 9.75 0 0 0-6.74 2.74L3 8',
      ), // key: 14sxne
      ElIconPathElement('M3 3v5h5'), // key: 1xhq8a
      ElIconPathElement(
        'M3 12a9 9 0 0 0 9 9 9.75 9.75 0 0 0 6.74-2.74L21 16',
      ), // key: 1hlbsb
      ElIconPathElement('M16 16h5v5'), // key: ccwih5
    ],
  );

  /// `refresh-cw-off.mjs`
  static const ElLucideGlyph refreshCwOff = ElLucideGlyph(
    'refresh-cw-off',
    <ElIconElement>[
      ElIconPathElement(
        'M21 8L18.74 5.74A9.75 9.75 0 0 0 12 3C11 3 10.03 3.16 9.13 3.47',
      ), // key: 1krf6h
      ElIconPathElement('M8 16H3v5'), // key: 1cv678
      ElIconPathElement('M3 12C3 9.51 4 7.26 5.64 5.64'), // key: ruvoct
      ElIconPathElement(
        'm3 16 2.26 2.26A9.75 9.75 0 0 0 12 21c2.49 0 4.74-1 6.36-2.64',
      ), // key: 19q130
      ElIconPathElement('M21 12c0 1-.16 1.97-.47 2.87'), // key: 4w8emr
      ElIconPathElement('M21 3v5h-5'), // key: 1q7to0
      ElIconPathElement('M22 22 2 2'), // key: 1r8tn9
    ],
  );

  /// `refresh-cw.mjs`
  static const ElLucideGlyph refreshCw = ElLucideGlyph(
    'refresh-cw',
    <ElIconElement>[
      ElIconPathElement(
        'M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8',
      ), // key: v9h5vc
      ElIconPathElement('M21 3v5h-5'), // key: 1q7to0
      ElIconPathElement(
        'M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16',
      ), // key: 3uifl3
      ElIconPathElement('M8 16H3v5'), // key: 1cv678
    ],
  );

  /// `refrigerator.mjs`
  static const ElLucideGlyph
  refrigerator = ElLucideGlyph('refrigerator', <ElIconElement>[
    ElIconPathElement(
      'M5 6a4 4 0 0 1 4-4h6a4 4 0 0 1 4 4v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6Z',
    ), // key: fpq118
    ElIconPathElement('M5 10h14'), // key: elsbfy
    ElIconPathElement('M15 7v6'), // key: 1nx30x
  ]);

  /// `regex.mjs`
  static const ElLucideGlyph regex = ElLucideGlyph('regex', <ElIconElement>[
    ElIconPathElement('M17 3v10'), // key: 15fgeh
    ElIconPathElement('m12.67 5.5 8.66 5'), // key: 1gpheq
    ElIconPathElement('m12.67 10.5 8.66-5'), // key: 1dkfa6
    ElIconPathElement(
      'M9 17a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v2a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2v-2z',
    ), // key: swwfx4
  ]);

  /// `remove-formatting.mjs`
  static const ElLucideGlyph removeFormatting = ElLucideGlyph(
    'remove-formatting',
    <ElIconElement>[
      ElIconPathElement('M4 7V4h16v3'), // key: 9msm58
      ElIconPathElement('M5 20h6'), // key: 1h6pxn
      ElIconPathElement('M13 4 8 20'), // key: kqq6aj
      ElIconPathElement('m15 15 5 5'), // key: me55sn
      ElIconPathElement('m20 15-5 5'), // key: 11p7ol
    ],
  );

  /// `repeat-1.mjs`
  static const ElLucideGlyph repeat1 = ElLucideGlyph(
    'repeat-1',
    <ElIconElement>[
      ElIconPathElement('m17 2 4 4-4 4'), // key: nntrym
      ElIconPathElement('M3 11v-1a4 4 0 0 1 4-4h14'), // key: 84bu3i
      ElIconPathElement('m7 22-4-4 4-4'), // key: 1wqhfi
      ElIconPathElement('M21 13v1a4 4 0 0 1-4 4H3'), // key: 1rx37r
      ElIconPathElement('M11 10h1v4'), // key: 70cz1p
    ],
  );

  /// `repeat-2.mjs`
  static const ElLucideGlyph repeat2 = ElLucideGlyph(
    'repeat-2',
    <ElIconElement>[
      ElIconPathElement('m2 9 3-3 3 3'), // key: 1ltn5i
      ElIconPathElement('M13 18H7a2 2 0 0 1-2-2V6'), // key: 1r6tfw
      ElIconPathElement('m22 15-3 3-3-3'), // key: 4rnwn2
      ElIconPathElement('M11 6h6a2 2 0 0 1 2 2v10'), // key: 2f72bc
    ],
  );

  /// `repeat-off.mjs`
  static const ElLucideGlyph repeatOff = ElLucideGlyph(
    'repeat-off',
    <ElIconElement>[
      ElIconPathElement('M11.656 6H21l-4-4'), // key: w9pozh
      ElIconPathElement('M17.898 17.898A4 4 0 0 1 17 18H3l4-4'), // key: 156mfe
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
      ElIconPathElement('M21 13v1a4 4 0 0 1-.171 1.159'), // key: 2p1713
      ElIconPathElement('m21 6-4 4'), // key: p7opkf
      ElIconPathElement('M3 11v-1a4 4 0 0 1 3.102-3.898'), // key: 8cius9
      ElIconPathElement('m7 22-4-4'), // key: 1kl3a3
    ],
  );

  /// `repeat.mjs`
  static const ElLucideGlyph repeat = ElLucideGlyph('repeat', <ElIconElement>[
    ElIconPathElement('m17 2 4 4-4 4'), // key: nntrym
    ElIconPathElement('M3 11v-1a4 4 0 0 1 4-4h14'), // key: 84bu3i
    ElIconPathElement('m7 22-4-4 4-4'), // key: 1wqhfi
    ElIconPathElement('M21 13v1a4 4 0 0 1-4 4H3'), // key: 1rx37r
  ]);

  /// `replace-all.mjs`
  static const ElLucideGlyph replaceAll = ElLucideGlyph(
    'replace-all',
    <ElIconElement>[
      ElIconPathElement('M14 14a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1'), // key: zg1ipl
      ElIconPathElement('M14 4a1 1 0 0 1 1-1'), // key: dhj8ez
      ElIconPathElement('M15 10a1 1 0 0 1-1-1'), // key: 1mnyi5
      ElIconPathElement('M19 14a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1'), // key: txt6k4
      ElIconPathElement('M21 4a1 1 0 0 0-1-1'), // key: sfs9ap
      ElIconPathElement('M21 9a1 1 0 0 1-1 1'), // key: mp6qeo
      ElIconPathElement('m3 7 3 3 3-3'), // key: x25e72
      ElIconPathElement('M6 10V5a2 2 0 0 1 2-2h2'), // key: 15xut4
      ElIconRectElement(3, 14, 7, 7, 1), // key: 1bkyp8
    ],
  );

  /// `replace.mjs`
  static const ElLucideGlyph replace = ElLucideGlyph('replace', <ElIconElement>[
    ElIconPathElement('M14 4a1 1 0 0 1 1-1'), // key: dhj8ez
    ElIconPathElement('M15 10a1 1 0 0 1-1-1'), // key: 1mnyi5
    ElIconPathElement('M21 4a1 1 0 0 0-1-1'), // key: sfs9ap
    ElIconPathElement('M21 9a1 1 0 0 1-1 1'), // key: mp6qeo
    ElIconPathElement('m3 7 3 3 3-3'), // key: x25e72
    ElIconPathElement('M6 10V5a2 2 0 0 1 2-2h2'), // key: 15xut4
    ElIconRectElement(3, 14, 7, 7, 1), // key: 1bkyp8
  ]);

  /// `reply-all.mjs`
  static const ElLucideGlyph replyAll = ElLucideGlyph(
    'reply-all',
    <ElIconElement>[
      ElIconPathElement('m12 17-5-5 5-5'), // key: 1s3y5u
      ElIconPathElement('M22 18v-2a4 4 0 0 0-4-4H7'), // key: 1fcyog
      ElIconPathElement('m7 17-5-5 5-5'), // key: 1ed8i2
    ],
  );

  /// `reply.mjs`
  static const ElLucideGlyph reply = ElLucideGlyph('reply', <ElIconElement>[
    ElIconPathElement('M20 18v-2a4 4 0 0 0-4-4H4'), // key: 5vmcpk
    ElIconPathElement('m9 17-5-5 5-5'), // key: nvlc11
  ]);

  /// `rewind.mjs`
  static const ElLucideGlyph rewind = ElLucideGlyph('rewind', <ElIconElement>[
    ElIconPathElement(
      'M12 6a2 2 0 0 0-3.414-1.414l-6 6a2 2 0 0 0 0 2.828l6 6A2 2 0 0 0 12 18z',
    ), // key: 2a1g8i
    ElIconPathElement(
      'M22 6a2 2 0 0 0-3.414-1.414l-6 6a2 2 0 0 0 0 2.828l6 6A2 2 0 0 0 22 18z',
    ), // key: rg3s36
  ]);

  /// `ribbon.mjs`
  static const ElLucideGlyph ribbon = ElLucideGlyph('ribbon', <ElIconElement>[
    ElIconPathElement(
      'M12 11.22C11 9.997 10 9 10 8a2 2 0 0 1 4 0c0 1-.998 2.002-2.01 3.22',
    ), // key: 1rnhq3
    ElIconPathElement('m12 18 2.57-3.5'), // key: 116vt7
    ElIconPathElement('M6.243 9.016a7 7 0 0 1 11.507-.009'), // key: 10dq0b
    ElIconPathElement('M9.35 14.53 12 11.22'), // key: tdsyp2
    ElIconPathElement(
      'M9.35 14.53C7.728 12.246 6 10.221 6 7a6 5 0 0 1 12 0c-.005 3.22-1.778 5.235-3.43 7.5l3.557 4.527a1 1 0 0 1-.203 1.43l-1.894 1.36a1 1 0 0 1-1.384-.215L12 18l-2.679 3.593a1 1 0 0 1-1.39.213l-1.865-1.353a1 1 0 0 1-.203-1.422z',
    ), // key: nmifey
  ]);

  /// `road.mjs`
  static const ElLucideGlyph road = ElLucideGlyph('road', <ElIconElement>[
    ElIconPathElement('M12 17v4'), // key: 1riwvh
    ElIconPathElement('M12 5V3'), // key: vd5es
    ElIconPathElement('M12 9v3'), // key: qyerrc
    ElIconPathElement(
      'M2.077 18.449A2 2 0 0 0 4 21h16a2 2 0 0 0 1.924-2.55l-4-14A2 2 0 0 0 16 3H8a2 2 0 0 0-1.924 1.45z',
    ), // key: 1cuxct
  ]);

  /// `rocket.mjs`
  static const ElLucideGlyph rocket = ElLucideGlyph('rocket', <ElIconElement>[
    ElIconPathElement('M12 15v5s3.03-.55 4-2c1.08-1.62 0-5 0-5'), // key: qeys4
    ElIconPathElement(
      'M4.5 16.5c-1.5 1.26-2 5-2 5s3.74-.5 5-2c.71-.84.7-2.13-.09-2.91a2.18 2.18 0 0 0-2.91-.09',
    ), // key: u4xsad
    ElIconPathElement(
      'M9 12a22 22 0 0 1 2-3.95A12.88 12.88 0 0 1 22 2c0 2.72-.78 7.5-6 11a22.4 22.4 0 0 1-4 2z',
    ), // key: 676m9
    ElIconPathElement(
      'M9 12H4s.55-3.03 2-4c1.62-1.08 5 .05 5 .05',
    ), // key: 92ym6u
  ]);

  /// `rocking-chair.mjs`
  static const ElLucideGlyph rockingChair = ElLucideGlyph(
    'rocking-chair',
    <ElIconElement>[
      ElIconPathElement('m15 13 3.708 7.416'), // key: 1edxn9
      ElIconPathElement('M3 19a15 15 0 0 0 18 0'), // key: d0d1c4
      ElIconPathElement('m3 2 3.21 9.633A2 2 0 0 0 8.109 13H18'), // key: tpa4et
      ElIconPathElement('m9 13-3.708 7.416'), // key: 1oplxx
    ],
  );

  /// `roller-coaster.mjs`
  static const ElLucideGlyph rollerCoaster = ElLucideGlyph(
    'roller-coaster',
    <ElIconElement>[
      ElIconPathElement('M6 19V5'), // key: 1r845m
      ElIconPathElement('M10 19V6.8'), // key: 9j2tfs
      ElIconPathElement('M14 19v-7.8'), // key: 10s8qv
      ElIconPathElement('M18 5v4'), // key: 1tajlv
      ElIconPathElement('M18 19v-6'), // key: ielfq3
      ElIconPathElement('M22 19V9'), // key: 158nzp
      ElIconPathElement(
        'M2 19V9a4 4 0 0 1 4-4c2 0 4 1.33 6 4s4 4 6 4a4 4 0 1 0-3-6.65',
      ), // key: 1930oh
    ],
  );

  /// `rose.mjs`
  static const ElLucideGlyph rose = ElLucideGlyph('rose', <ElIconElement>[
    ElIconPathElement('M17 10h-1a4 4 0 1 1 4-4v.534'), // key: 7qf5zm
    ElIconPathElement(
      'M17 6h1a4 4 0 0 1 1.42 7.74l-2.29.87a6 6 0 0 1-5.339-10.68l2.069-1.31',
    ), // key: 1et29u
    ElIconPathElement(
      'M4.5 17c2.8-.5 4.4 0 5.5.8s1.8 2.2 2.3 3.7c-2 .4-3.5.4-4.8-.3-1.2-.6-2.3-1.9-3-4.2',
    ), // key: kiv2lz
    ElIconPathElement('M9.77 12C4 15 2 22 2 22'), // key: h28rw0
    ElIconCircleElement(17, 8, 2), // key: 1330xn
  ]);

  /// `rotate-3d.mjs`
  static const ElLucideGlyph rotate3d = ElLucideGlyph(
    'rotate-3d',
    <ElIconElement>[
      ElIconPathElement('m15.194 13.707 3.814 1.86-1.86 3.814'), // key: 16shm9
      ElIconPathElement(
        'M16.47214 7.52786 A 5 10 0 1 0 13 21.79796',
      ), // key: 1245p8
      ElIconPathElement('M21.79796 11 A 10 5 0 1 0 19 15.57071'), // key: 1i40ks
    ],
  );

  /// `rotate-ccw-clock.mjs`
  static const ElLucideGlyph rotateCcwClock = ElLucideGlyph(
    'rotate-ccw-clock',
    <ElIconElement>[
      ElIconPathElement(
        'M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8',
      ), // key: 1357e3
      ElIconPathElement('M3 3v5h5'), // key: 1xhq8a
      ElIconPathElement('M12 7v5l4 2'), // key: 1fdv2h
    ],
  );

  /// `rotate-ccw-key.mjs`
  static const ElLucideGlyph rotateCcwKey = ElLucideGlyph(
    'rotate-ccw-key',
    <ElIconElement>[
      ElIconPathElement('M12 7v6'), // key: lw1j43
      ElIconPathElement('M12 9h2'), // key: 1lpap9
      ElIconPathElement(
        'M3 12a9 9 0 1 0 9-9 9.74 9.74 0 0 0-6.74 2.74L3 8',
      ), // key: g2jlw
      ElIconPathElement('M3 3v5h5'), // key: 1xhq8a
      ElIconCircleElement(12, 15, 2), // key: 1vpstw
    ],
  );

  /// `rotate-ccw-square.mjs`
  static const ElLucideGlyph rotateCcwSquare = ElLucideGlyph(
    'rotate-ccw-square',
    <ElIconElement>[
      ElIconPathElement('M20 9V7a2 2 0 0 0-2-2h-6'), // key: 19z8uc
      ElIconPathElement('m15 2-3 3 3 3'), // key: 177bxs
      ElIconPathElement(
        'M20 13v5a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2h2',
      ), // key: d36hnl
    ],
  );

  /// `rotate-ccw.mjs`
  static const ElLucideGlyph rotateCcw = ElLucideGlyph(
    'rotate-ccw',
    <ElIconElement>[
      ElIconPathElement(
        'M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8',
      ), // key: 1357e3
      ElIconPathElement('M3 3v5h5'), // key: 1xhq8a
    ],
  );

  /// `rotate-cw-fading-clock.mjs`
  static const ElLucideGlyph
  rotateCwFadingClock = ElLucideGlyph('rotate-cw-fading-clock', <ElIconElement>[
    ElIconPathElement('M12 3a9.75 9.75 0 0 1 6.74 2.74'), // key: 1k3kxf
    ElIconPathElement('M18.74 5.74 21 8'), // key: 1eb40o
    ElIconPathElement('M21 8V3'), // key: 1et280
    ElIconPathElement('M7.5 19.794c-6-3.464-6-12.124 0-15.588'), // key: 19r0lp
    ElIconPathElement('M7.5 4.206A9 9 0 0 1 12 3'), // key: s8r11
    ElIconPathElement('M12 7v5l4 2'), // key: 1fdv2h
    ElIconPathElement('M14 20.775A9 9 0 0 1 12 21'), // key: 184rgu
    ElIconPathElement('M19 17.656a9 9 0 0 1-1.5 1.456'), // key: 7qgp6l
    ElIconPathElement('M21 12a9 9 0 0 1-.228 2'), // key: 1h378y
    ElIconPathElement('M21 8h-5'), // key: k0yzmk
  ]);

  /// `rotate-cw-square.mjs`
  static const ElLucideGlyph rotateCwSquare = ElLucideGlyph(
    'rotate-cw-square',
    <ElIconElement>[
      ElIconPathElement('M12 5H6a2 2 0 0 0-2 2v3'), // key: l96uqu
      ElIconPathElement('m9 8 3-3-3-3'), // key: 1gzgc3
      ElIconPathElement(
        'M4 14v4a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2',
      ), // key: 1w2k5h
    ],
  );

  /// `rotate-cw.mjs`
  static const ElLucideGlyph rotateCw = ElLucideGlyph(
    'rotate-cw',
    <ElIconElement>[
      ElIconPathElement(
        'M21 12a9 9 0 1 1-9-9c2.52 0 4.93 1 6.74 2.74L21 8',
      ), // key: 1p45f6
      ElIconPathElement('M21 3v5h-5'), // key: 1q7to0
    ],
  );

  /// `route-off.mjs`
  static const ElLucideGlyph routeOff = ElLucideGlyph(
    'route-off',
    <ElIconElement>[
      ElIconCircleElement(6, 19, 3), // key: 1kj8tv
      ElIconPathElement('M9 19h8.5c.4 0 .9-.1 1.3-.2'), // key: 1effex
      ElIconPathElement('M5.2 5.2A3.5 3.53 0 0 0 6.5 12H12'), // key: k9y2ds
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
      ElIconPathElement('M21 15.3a3.5 3.5 0 0 0-3.3-3.3'), // key: 11nlu2
      ElIconPathElement('M15 5h-4.3'), // key: 6537je
      ElIconCircleElement(18, 5, 3), // key: gq8acd
    ],
  );

  /// `route.mjs`
  static const ElLucideGlyph route = ElLucideGlyph('route', <ElIconElement>[
    ElIconCircleElement(6, 19, 3), // key: 1kj8tv
    ElIconPathElement(
      'M9 19h8.5a3.5 3.5 0 0 0 0-7h-11a3.5 3.5 0 0 1 0-7H15',
    ), // key: 1d8sl
    ElIconCircleElement(18, 5, 3), // key: gq8acd
  ]);

  /// `router.mjs`
  static const ElLucideGlyph router = ElLucideGlyph('router', <ElIconElement>[
    ElIconRectElement(2, 14, 20, 8, 2), // key: w68u3i
    ElIconPathElement('M6.01 18H6'), // key: 19vcac
    ElIconPathElement('M10.01 18H10'), // key: uamcmx
    ElIconPathElement('M15 10v4'), // key: qjz1xs
    ElIconPathElement('M17.84 7.17a4 4 0 0 0-5.66 0'), // key: 1rif40
    ElIconPathElement('M20.66 4.34a8 8 0 0 0-11.31 0'), // key: 6a5xfq
  ]);

  /// `rows-2.mjs`
  static const ElLucideGlyph rows2 = ElLucideGlyph('rows-2', <ElIconElement>[
    ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    ElIconPathElement('M3 12h18'), // key: 1i2n21
  ]);

  /// `rows-3.mjs`
  static const ElLucideGlyph rows3 = ElLucideGlyph('rows-3', <ElIconElement>[
    ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    ElIconPathElement('M21 9H3'), // key: 1338ky
    ElIconPathElement('M21 15H3'), // key: 9uk58r
  ]);

  /// `rows-4.mjs`
  static const ElLucideGlyph rows4 = ElLucideGlyph('rows-4', <ElIconElement>[
    ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    ElIconPathElement('M21 7.5H3'), // key: 1hm9pq
    ElIconPathElement('M21 12H3'), // key: 2avoz0
    ElIconPathElement('M21 16.5H3'), // key: n7jzkj
  ]);

  /// `rss.mjs`
  static const ElLucideGlyph rss = ElLucideGlyph('rss', <ElIconElement>[
    ElIconPathElement('M4 11a9 9 0 0 1 9 9'), // key: pv89mb
    ElIconPathElement('M4 4a16 16 0 0 1 16 16'), // key: k0647b
    ElIconCircleElement(5, 19, 1), // key: bfqh0e
  ]);

  /// `ruler-dimension-line.mjs`
  static const ElLucideGlyph rulerDimensionLine = ElLucideGlyph(
    'ruler-dimension-line',
    <ElIconElement>[
      ElIconPathElement('M10 15v-3'), // key: 1pjskw
      ElIconPathElement('M14 15v-3'), // key: 1o1mqj
      ElIconPathElement('M18 15v-3'), // key: cws6he
      ElIconPathElement('M2 8V4'), // key: 3jv1jz
      ElIconPathElement('M22 6H2'), // key: 1iqbfk
      ElIconPathElement('M22 8V4'), // key: 16f4ou
      ElIconPathElement('M6 15v-3'), // key: 1ij1qe
      ElIconRectElement(2, 12, 20, 8, 2), // key: 1tqiko
    ],
  );

  /// `ruler.mjs`
  static const ElLucideGlyph ruler = ElLucideGlyph('ruler', <ElIconElement>[
    ElIconPathElement(
      'M21.3 15.3a2.4 2.4 0 0 1 0 3.4l-2.6 2.6a2.4 2.4 0 0 1-3.4 0L2.7 8.7a2.41 2.41 0 0 1 0-3.4l2.6-2.6a2.41 2.41 0 0 1 3.4 0Z',
    ), // key: icamh8
    ElIconPathElement('m14.5 12.5 2-2'), // key: inckbg
    ElIconPathElement('m11.5 9.5 2-2'), // key: fmmyf7
    ElIconPathElement('m8.5 6.5 2-2'), // key: vc6u1g
    ElIconPathElement('m17.5 15.5 2-2'), // key: wo5hmg
  ]);

  /// `russian-ruble.mjs`
  static const ElLucideGlyph russianRuble = ElLucideGlyph(
    'russian-ruble',
    <ElIconElement>[
      ElIconPathElement('M6 11h8a4 4 0 0 0 0-8H9v18'), // key: 18ai8t
      ElIconPathElement('M6 15h8'), // key: 1y8f6l
    ],
  );

  /// `sailboat.mjs`
  static const ElLucideGlyph
  sailboat = ElLucideGlyph('sailboat', <ElIconElement>[
    ElIconPathElement('M10 2v15'), // key: 1qf71f
    ElIconPathElement(
      'M7 22a4 4 0 0 1-4-4 1 1 0 0 1 1-1h16a1 1 0 0 1 1 1 4 4 0 0 1-4 4z',
    ), // key: 1pxcvx
    ElIconPathElement(
      'M9.159 2.46a1 1 0 0 1 1.521-.193l9.977 8.98A1 1 0 0 1 20 13H4a1 1 0 0 1-.824-1.567z',
    ), // key: 5oog16
  ]);

  /// `salad.mjs`
  static const ElLucideGlyph salad = ElLucideGlyph('salad', <ElIconElement>[
    ElIconPathElement('M7 21h10'), // key: 1b0cd5
    ElIconPathElement('M12 21a9 9 0 0 0 9-9H3a9 9 0 0 0 9 9Z'), // key: 4rw317
    ElIconPathElement(
      'M11.38 12a2.4 2.4 0 0 1-.4-4.77 2.4 2.4 0 0 1 3.2-2.77 2.4 2.4 0 0 1 3.47-.63 2.4 2.4 0 0 1 3.37 3.37 2.4 2.4 0 0 1-1.1 3.7 2.51 2.51 0 0 1 .03 1.1',
    ), // key: 10xrj0
    ElIconPathElement('m13 12 4-4'), // key: 1hckqy
    ElIconPathElement(
      'M10.9 7.25A3.99 3.99 0 0 0 4 10c0 .73.2 1.41.54 2',
    ), // key: 1p4srx
  ]);

  /// `sandwich.mjs`
  static const ElLucideGlyph sandwich = ElLucideGlyph(
    'sandwich',
    <ElIconElement>[
      ElIconPathElement(
        'm2.37 11.223 8.372-6.777a2 2 0 0 1 2.516 0l8.371 6.777',
      ), // key: f1wd0e
      ElIconPathElement(
        'M21 15a1 1 0 0 1 1 1v2a1 1 0 0 1-1 1h-5.25',
      ), // key: 1pfu07
      ElIconPathElement('M3 15a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h9'), // key: 1oq9qw
      ElIconPathElement(
        'm6.67 15 6.13 4.6a2 2 0 0 0 2.8-.4l3.15-4.2',
      ), // key: 1fnwu5
      ElIconRectElement(2, 11, 20, 4, 1), // key: itshg
    ],
  );

  /// `satellite-dish.mjs`
  static const ElLucideGlyph satelliteDish = ElLucideGlyph(
    'satellite-dish',
    <ElIconElement>[
      ElIconPathElement('M4 10a7.31 7.31 0 0 0 10 10Z'), // key: 1fzpp3
      ElIconPathElement('m9 15 3-3'), // key: 88sc13
      ElIconPathElement('M17 13a6 6 0 0 0-6-6'), // key: 15cc6u
      ElIconPathElement('M21 13A10 10 0 0 0 11 3'), // key: 11nf8s
    ],
  );

  /// `satellite.mjs`
  static const ElLucideGlyph
  satellite = ElLucideGlyph('satellite', <ElIconElement>[
    ElIconPathElement(
      'm13.5 6.5-3.148-3.148a1.205 1.205 0 0 0-1.704 0L6.352 5.648a1.205 1.205 0 0 0 0 1.704L9.5 10.5',
    ), // key: dzhfyz
    ElIconPathElement('M16.5 7.5 19 5'), // key: 1ltcjm
    ElIconPathElement(
      'm17.5 10.5 3.148 3.148a1.205 1.205 0 0 1 0 1.704l-2.296 2.296a1.205 1.205 0 0 1-1.704 0L13.5 14.5',
    ), // key: nfoymv
    ElIconPathElement('M9 21a6 6 0 0 0-6-6'), // key: 1iajcf
    ElIconPathElement(
      'M9.352 10.648a1.205 1.205 0 0 0 0 1.704l2.296 2.296a1.205 1.205 0 0 0 1.704 0l4.296-4.296a1.205 1.205 0 0 0 0-1.704l-2.296-2.296a1.205 1.205 0 0 0-1.704 0z',
    ), // key: nv9zqy
  ]);

  /// `saudi-riyal.mjs`
  static const ElLucideGlyph saudiRiyal = ElLucideGlyph(
    'saudi-riyal',
    <ElIconElement>[
      ElIconPathElement('m20 19.5-5.5 1.2'), // key: 1aenhr
      ElIconPathElement(
        'M14.5 4v11.22a1 1 0 0 0 1.242.97L20 15.2',
      ), // key: 2rtezt
      ElIconPathElement(
        'm2.978 19.351 5.549-1.363A2 2 0 0 0 10 16V2',
      ), // key: 1kbm92
      ElIconPathElement('M20 10 4 13.5'), // key: 8nums9
    ],
  );

  /// `save-all.mjs`
  static const ElLucideGlyph
  saveAll = ElLucideGlyph('save-all', <ElIconElement>[
    ElIconPathElement('M10 2v3a1 1 0 0 0 1 1h5'), // key: 1xspal
    ElIconPathElement(
      'M18 18v-6a1 1 0 0 0-1-1h-6a1 1 0 0 0-1 1v6',
    ), // key: 1ra60u
    ElIconPathElement('M18 22H4a2 2 0 0 1-2-2V6'), // key: pblm9e
    ElIconPathElement(
      'M8 18a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9.172a2 2 0 0 1 1.414.586l2.828 2.828A2 2 0 0 1 22 6.828V16a2 2 0 0 1-2.01 2z',
    ), // key: 1yve0x
  ]);

  /// `save-check.mjs`
  static const ElLucideGlyph
  saveCheck = ElLucideGlyph('save-check', <ElIconElement>[
    ElIconPathElement(
      'M12.5 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h10.2a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4v4.35',
    ), // key: 6jbevg
    ElIconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
    ElIconPathElement(
      'M17 15.13V14a1 1 0 0 0-1-1H8a1 1 0 0 0-1 1v7',
    ), // key: 1bzeol
    ElIconPathElement('M7 3v4a1 1 0 0 0 1 1h7'), // key: t51u73
  ]);

  /// `save-off.mjs`
  static const ElLucideGlyph saveOff = ElLucideGlyph(
    'save-off',
    <ElIconElement>[
      ElIconPathElement('M13 13H8a1 1 0 0 0-1 1v7'), // key: h8g396
      ElIconPathElement('M14 8h1'), // key: 1lfen6
      ElIconPathElement('M17 21v-4'), // key: 1yknxs
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
      ElIconPathElement(
        'M20.41 20.41A2 2 0 0 1 19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 .59-1.41',
      ), // key: 1t4vdl
      ElIconPathElement('M29.5 11.5s5 5 4 5'), // key: zzn4i6
      ElIconPathElement(
        'M9 3h6.2a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4V15',
      ), // key: 24cby9
    ],
  );

  /// `save-pen.mjs`
  static const ElLucideGlyph
  savePen = ElLucideGlyph('save-pen', <ElIconElement>[
    ElIconPathElement('M13.33 13H8a1 1 0 00-1 1v7'), // key: 60fs50
    ElIconPathElement(
      'M14.363 17.634a2 2 0 00-.506.854l-.837 2.87a.5.5 0 00.62.62l2.87-.837a2 2 0 00.854-.506l4.013-4.009a1 1 0 10-3.004-3.004z',
    ), // key: dpj1he
    ElIconPathElement('M7 3v4a1 1 0 001 1h7'), // key: vkun1b
    ElIconPathElement(
      'M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h10.2a2 2 0 011.4.6l3.8 3.8a2 2 0 01.6 1.4v.3',
    ), // key: 1oj3yb
  ]);

  /// `save-plus.mjs`
  static const ElLucideGlyph
  savePlus = ElLucideGlyph('save-plus', <ElIconElement>[
    ElIconPathElement(
      'M12.5 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h10.2a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4V12',
    ), // key: bhibzn
    ElIconPathElement('M16 13H8a1 1 0 0 0-1 1v7'), // key: 164ge7
    ElIconPathElement('M19 22v-6'), // key: qhmiwi
    ElIconPathElement('M22 19h-6'), // key: vcuq98
    ElIconPathElement('M7 3v4a1 1 0 0 0 1 1h7'), // key: t51u73
  ]);

  /// `save.mjs`
  static const ElLucideGlyph save = ElLucideGlyph('save', <ElIconElement>[
    ElIconPathElement(
      'M15.2 3a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2z',
    ), // key: 1c8476
    ElIconPathElement(
      'M17 21v-7a1 1 0 0 0-1-1H8a1 1 0 0 0-1 1v7',
    ), // key: 1ydtos
    ElIconPathElement('M7 3v4a1 1 0 0 0 1 1h7'), // key: t51u73
  ]);

  /// `scale-3d.mjs`
  static const ElLucideGlyph scale3d = ElLucideGlyph(
    'scale-3d',
    <ElIconElement>[
      ElIconPathElement('M5 7v11a1 1 0 0 0 1 1h11'), // key: 13dt1j
      ElIconPathElement('M5.293 18.707 11 13'), // key: ezgbsx
      ElIconCircleElement(19, 19, 2), // key: 17f5cg
      ElIconCircleElement(5, 5, 2), // key: 1gwv83
    ],
  );

  /// `scale.mjs`
  static const ElLucideGlyph scale = ElLucideGlyph('scale', <ElIconElement>[
    ElIconPathElement('M12 3v18'), // key: 108xh3
    ElIconPathElement('m19 8 3 8a5 5 0 0 1-6 0zV7'), // key: zcdpyk
    ElIconPathElement(
      'M3 7h1a17 17 0 0 0 8-2 17 17 0 0 0 8 2h1',
    ), // key: 1yorad
    ElIconPathElement('m5 8 3 8a5 5 0 0 1-6 0zV7'), // key: eua70x
    ElIconPathElement('M7 21h10'), // key: 1b0cd5
  ]);

  /// `scaling.mjs`
  static const ElLucideGlyph scaling = ElLucideGlyph('scaling', <ElIconElement>[
    ElIconPathElement(
      'M12 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7',
    ), // key: 1m0v6g
    ElIconPathElement('M14 15H9v-5'), // key: pi4jk9
    ElIconPathElement('M16 3h5v5'), // key: 1806ms
    ElIconPathElement('M21 3 9 15'), // key: 15kdhq
  ]);

  /// `scan-barcode.mjs`
  static const ElLucideGlyph scanBarcode = ElLucideGlyph(
    'scan-barcode',
    <ElIconElement>[
      ElIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
      ElIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
      ElIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
      ElIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
      ElIconPathElement('M8 7v10'), // key: 23sfjj
      ElIconPathElement('M12 7v10'), // key: jspqdw
      ElIconPathElement('M17 7v10'), // key: 578dap
    ],
  );

  /// `scan-box.mjs`
  static const ElLucideGlyph
  scanBox = ElLucideGlyph('scan-box', <ElIconElement>[
    ElIconPathElement('M12 12v5.5'), // key: 1fezw7
    ElIconPathElement('M17 3h2a2 2 0 012 2v2'), // key: sxhzt8
    ElIconPathElement('M21 17v2a2 2 0 01-2 2h-2'), // key: b4b27w
    ElIconPathElement('M3 7V5a2 2 0 012-2h2'), // key: 5quapj
    ElIconPathElement('M7 21H5a2 2 0 01-2-2v-2'), // key: rx7q13
    ElIconPathElement('M7.264 9.252 12 12l4.737-2.748'), // key: 176tmc
    ElIconPathElement(
      'M7.995 8.514A2 2 0 007 10.244v3.516a2 2 0 00.996 1.73l3 1.74a2 2 0 002.008 0l3-1.74A2 2 0 0017 13.76v-3.517a2 2 0 00-.995-1.73l-3-1.742a2 2 0 00-1.892-.064z',
    ), // key: 7zy66p
  ]);

  /// `scan-eye.mjs`
  static const ElLucideGlyph
  scanEye = ElLucideGlyph('scan-eye', <ElIconElement>[
    ElIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    ElIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    ElIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    ElIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
    ElIconCircleElement(12, 12, 1), // key: 41hilf
    ElIconPathElement(
      'M18.944 12.33a1 1 0 0 0 0-.66 7.5 7.5 0 0 0-13.888 0 1 1 0 0 0 0 .66 7.5 7.5 0 0 0 13.888 0',
    ), // key: 11ak4c
  ]);

  /// `scan-face.mjs`
  static const ElLucideGlyph scanFace = ElLucideGlyph(
    'scan-face',
    <ElIconElement>[
      ElIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
      ElIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
      ElIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
      ElIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
      ElIconPathElement('M8 14s1.5 2 4 2 4-2 4-2'), // key: 1y1vjs
      ElIconPathElement('M9 9h.01'), // key: 1q5me6
      ElIconPathElement('M15 9h.01'), // key: x1ddxp
    ],
  );

  /// `scan-heart.mjs`
  static const ElLucideGlyph
  scanHeart = ElLucideGlyph('scan-heart', <ElIconElement>[
    ElIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    ElIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    ElIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    ElIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
    ElIconPathElement(
      'M7.828 13.07A3 3 0 0 1 12 8.764a3 3 0 0 1 4.172 4.306l-3.447 3.62a1 1 0 0 1-1.449 0z',
    ), // key: 1ak1ef
  ]);

  /// `scan-line.mjs`
  static const ElLucideGlyph scanLine = ElLucideGlyph(
    'scan-line',
    <ElIconElement>[
      ElIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
      ElIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
      ElIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
      ElIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
      ElIconPathElement('M7 12h10'), // key: b7w52i
    ],
  );

  /// `scan-qr-code.mjs`
  static const ElLucideGlyph scanQrCode = ElLucideGlyph(
    'scan-qr-code',
    <ElIconElement>[
      ElIconPathElement('M17 12v4a1 1 0 0 1-1 1h-4'), // key: uk4fdo
      ElIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
      ElIconPathElement('M17 8V7'), // key: q2g9wo
      ElIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
      ElIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
      ElIconPathElement('M7 17h.01'), // key: 19xn7k
      ElIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
      ElIconRectElement(7, 7, 5, 5, 1), // key: m9kyts
    ],
  );

  /// `scan-search.mjs`
  static const ElLucideGlyph scanSearch = ElLucideGlyph(
    'scan-search',
    <ElIconElement>[
      ElIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
      ElIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
      ElIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
      ElIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
      ElIconCircleElement(12, 12, 3), // key: 1v7zrd
      ElIconPathElement('m16 16-1.9-1.9'), // key: 1dq9hf
    ],
  );

  /// `scan-square.mjs`
  static const ElLucideGlyph scanSquare = ElLucideGlyph(
    'scan-square',
    <ElIconElement>[
      ElIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
      ElIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
      ElIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
      ElIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
      ElIconRectElement(8, 8, 8, 8, 1), // key: 69yp3k
    ],
  );

  /// `scan-text.mjs`
  static const ElLucideGlyph scanText = ElLucideGlyph(
    'scan-text',
    <ElIconElement>[
      ElIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
      ElIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
      ElIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
      ElIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
      ElIconPathElement('M7 8h8'), // key: 1jbsf9
      ElIconPathElement('M7 12h10'), // key: b7w52i
      ElIconPathElement('M7 16h6'), // key: 1vyc9m
    ],
  );

  /// `scan.mjs`
  static const ElLucideGlyph scan = ElLucideGlyph('scan', <ElIconElement>[
    ElIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    ElIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    ElIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    ElIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
  ]);

  /// `school.mjs`
  static const ElLucideGlyph school = ElLucideGlyph('school', <ElIconElement>[
    ElIconPathElement('M14 21v-3a2 2 0 0 0-4 0v3'), // key: 1rgiei
    ElIconPathElement('M18 4.933V21'), // key: tjwmp4
    ElIconPathElement('m4 6 7.106-3.79a2 2 0 0 1 1.788 0L20 6'), // key: zywc2d
    ElIconPathElement(
      'm6 11-3.52 2.147a1 1 0 0 0-.48.854V19a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-5a1 1 0 0 0-.48-.853L18 11',
    ), // key: 1d4ql0
    ElIconPathElement('M6 4.933V21'), // key: 1ufz1j
    ElIconCircleElement(12, 9, 2), // key: 1092wv
  ]);

  /// `scissors-line-dashed.mjs`
  static const ElLucideGlyph scissorsLineDashed = ElLucideGlyph(
    'scissors-line-dashed',
    <ElIconElement>[
      ElIconPathElement('M5.42 9.42 8 12'), // key: 12pkuq
      ElIconCircleElement(4, 8, 2), // key: 107mxr
      ElIconPathElement('m14 6-8.58 8.58'), // key: gvzu5l
      ElIconCircleElement(4, 16, 2), // key: 1ehqvc
      ElIconPathElement('M10.8 14.8 14 18'), // key: ax7m9r
      ElIconPathElement('M16 12h-2'), // key: 10asgb
      ElIconPathElement('M22 12h-2'), // key: 14jgyd
    ],
  );

  /// `scissors.mjs`
  static const ElLucideGlyph scissors = ElLucideGlyph(
    'scissors',
    <ElIconElement>[
      ElIconCircleElement(6, 6, 3), // key: 1lh9wr
      ElIconPathElement('M8.12 8.12 12 12'), // key: 1alkpv
      ElIconPathElement('M20 4 8.12 15.88'), // key: xgtan2
      ElIconCircleElement(6, 18, 3), // key: fqmcym
      ElIconPathElement('M14.8 14.8 20 20'), // key: ptml3r
    ],
  );

  /// `scooter.mjs`
  static const ElLucideGlyph scooter = ElLucideGlyph('scooter', <ElIconElement>[
    ElIconPathElement('M21 4h-3.5l2 11.05'), // key: 1gktiw
    ElIconPathElement(
      'M6.95 17h5.142c.523 0 .95-.406 1.063-.916a6.5 6.5 0 0 1 5.345-5.009',
    ), // key: 1bq3u3
    ElIconCircleElement(19.5, 17.5, 2.5), // key: e4zhv9
    ElIconCircleElement(4.5, 17.5, 2.5), // key: 50vk4p
  ]);

  /// `screen-share-off.mjs`
  static const ElLucideGlyph screenShareOff = ElLucideGlyph(
    'screen-share-off',
    <ElIconElement>[
      ElIconPathElement(
        'M13 3H4a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-3',
      ), // key: i8wdob
      ElIconPathElement('M8 21h8'), // key: 1ev6f3
      ElIconPathElement('M12 17v4'), // key: 1riwvh
      ElIconPathElement('m22 3-5 5'), // key: 12jva0
      ElIconPathElement('m17 3 5 5'), // key: k36vhe
    ],
  );

  /// `screen-share.mjs`
  static const ElLucideGlyph screenShare = ElLucideGlyph(
    'screen-share',
    <ElIconElement>[
      ElIconPathElement(
        'M13 3H4a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-3',
      ), // key: i8wdob
      ElIconPathElement('M8 21h8'), // key: 1ev6f3
      ElIconPathElement('M12 17v4'), // key: 1riwvh
      ElIconPathElement('m17 8 5-5'), // key: fqif7o
      ElIconPathElement('M17 3h5v5'), // key: 1o3tu8
    ],
  );

  /// `scroll-text.mjs`
  static const ElLucideGlyph
  scrollText = ElLucideGlyph('scroll-text', <ElIconElement>[
    ElIconPathElement('M15 12h-5'), // key: r7krc0
    ElIconPathElement('M15 8h-5'), // key: 1khuty
    ElIconPathElement('M19 17V5a2 2 0 0 0-2-2H4'), // key: zz82l3
    ElIconPathElement(
      'M8 21h12a2 2 0 0 0 2-2v-1a1 1 0 0 0-1-1H11a1 1 0 0 0-1 1v1a2 2 0 1 1-4 0V5a2 2 0 1 0-4 0v2a1 1 0 0 0 1 1h3',
    ), // key: 1ph1d7
  ]);

  /// `scroll.mjs`
  static const ElLucideGlyph scroll = ElLucideGlyph('scroll', <ElIconElement>[
    ElIconPathElement('M19 17V5a2 2 0 0 0-2-2H4'), // key: zz82l3
    ElIconPathElement(
      'M8 21h12a2 2 0 0 0 2-2v-1a1 1 0 0 0-1-1H11a1 1 0 0 0-1 1v1a2 2 0 1 1-4 0V5a2 2 0 1 0-4 0v2a1 1 0 0 0 1 1h3',
    ), // key: 1ph1d7
  ]);

  /// `search-alert.mjs`
  static const ElLucideGlyph searchAlert = ElLucideGlyph(
    'search-alert',
    <ElIconElement>[
      ElIconCircleElement(11, 11, 8), // key: 4ej97u
      ElIconPathElement('m21 21-4.3-4.3'), // key: 1qie3q
      ElIconPathElement('M11 7v4'), // key: m2edmq
      ElIconPathElement('M11 15h.01'), // key: k85uqc
    ],
  );

  /// `search-check.mjs`
  static const ElLucideGlyph searchCheck = ElLucideGlyph(
    'search-check',
    <ElIconElement>[
      ElIconPathElement('m8 11 2 2 4-4'), // key: 1sed1v
      ElIconCircleElement(11, 11, 8), // key: 4ej97u
      ElIconPathElement('m21 21-4.3-4.3'), // key: 1qie3q
    ],
  );

  /// `search-code.mjs`
  static const ElLucideGlyph searchCode = ElLucideGlyph(
    'search-code',
    <ElIconElement>[
      ElIconPathElement('m13 13.5 2-2.5-2-2.5'), // key: 1rvxrh
      ElIconPathElement('m21 21-4.3-4.3'), // key: 1qie3q
      ElIconPathElement('M9 8.5 7 11l2 2.5'), // key: 6ffwbx
      ElIconCircleElement(11, 11, 8), // key: 4ej97u
    ],
  );

  /// `search-slash.mjs`
  static const ElLucideGlyph searchSlash = ElLucideGlyph(
    'search-slash',
    <ElIconElement>[
      ElIconPathElement('m13.5 8.5-5 5'), // key: 1cs55j
      ElIconCircleElement(11, 11, 8), // key: 4ej97u
      ElIconPathElement('m21 21-4.3-4.3'), // key: 1qie3q
    ],
  );

  /// `search-x.mjs`
  static const ElLucideGlyph searchX = ElLucideGlyph(
    'search-x',
    <ElIconElement>[
      ElIconPathElement('m13.5 8.5-5 5'), // key: 1cs55j
      ElIconPathElement('m8.5 8.5 5 5'), // key: a8mexj
      ElIconCircleElement(11, 11, 8), // key: 4ej97u
      ElIconPathElement('m21 21-4.3-4.3'), // key: 1qie3q
    ],
  );

  /// `search.mjs`
  static const ElLucideGlyph search = ElLucideGlyph('search', <ElIconElement>[
    ElIconPathElement('m21 21-4.34-4.34'), // key: 14j7rj
    ElIconCircleElement(11, 11, 8), // key: 4ej97u
  ]);

  /// `section.mjs`
  static const ElLucideGlyph section = ElLucideGlyph('section', <ElIconElement>[
    ElIconPathElement(
      'M16 5a4 3 0 0 0-8 0c0 4 8 3 8 7a4 3 0 0 1-8 0',
    ), // key: vqan6v
    ElIconPathElement(
      'M8 19a4 3 0 0 0 8 0c0-4-8-3-8-7a4 3 0 0 1 8 0',
    ), // key: wdjd8o
  ]);

  /// `send-horizontal.mjs`
  static const ElLucideGlyph
  sendHorizontal = ElLucideGlyph('send-horizontal', <ElIconElement>[
    ElIconPathElement(
      'M3.714 3.048a.498.498 0 0 0-.683.627l2.843 7.627a2 2 0 0 1 0 1.396l-2.842 7.627a.498.498 0 0 0 .682.627l18-8.5a.5.5 0 0 0 0-.904z',
    ), // key: 117uat
    ElIconPathElement('M6 12h16'), // key: s4cdu5
  ]);

  /// `send-to-back.mjs`
  static const ElLucideGlyph sendToBack = ElLucideGlyph(
    'send-to-back',
    <ElIconElement>[
      ElIconRectElement(14, 14, 8, 8, 2), // key: 1b0bso
      ElIconRectElement(2, 2, 8, 8, 2), // key: 1x09vl
      ElIconPathElement('M7 14v1a2 2 0 0 0 2 2h1'), // key: pao6x6
      ElIconPathElement('M14 7h1a2 2 0 0 1 2 2v1'), // key: 19tdru
    ],
  );

  /// `send.mjs`
  static const ElLucideGlyph send = ElLucideGlyph('send', <ElIconElement>[
    ElIconPathElement(
      'M14.536 21.686a.5.5 0 0 0 .937-.024l6.5-19a.496.496 0 0 0-.635-.635l-19 6.5a.5.5 0 0 0-.024.937l7.93 3.18a2 2 0 0 1 1.112 1.11z',
    ), // key: 1ffxy3
    ElIconPathElement('m21.854 2.147-10.94 10.939'), // key: 12cjpa
  ]);

  /// `separator-horizontal.mjs`
  static const ElLucideGlyph separatorHorizontal = ElLucideGlyph(
    'separator-horizontal',
    <ElIconElement>[
      ElIconPathElement('m16 16-4 4-4-4'), // key: 3dv8je
      ElIconPathElement('M3 12h18'), // key: 1i2n21
      ElIconPathElement('m8 8 4-4 4 4'), // key: 2bscm2
    ],
  );

  /// `separator-vertical.mjs`
  static const ElLucideGlyph separatorVertical = ElLucideGlyph(
    'separator-vertical',
    <ElIconElement>[
      ElIconPathElement('M12 3v18'), // key: 108xh3
      ElIconPathElement('m16 16 4-4-4-4'), // key: 1js579
      ElIconPathElement('m8 8-4 4 4 4'), // key: 1whems
    ],
  );

  /// `server-cog.mjs`
  static const ElLucideGlyph
  serverCog = ElLucideGlyph('server-cog', <ElIconElement>[
    ElIconPathElement('m10.852 14.772-.383.923'), // key: 11vil6
    ElIconPathElement(
      'M13.148 14.772a3 3 0 1 0-2.296-5.544l-.383-.923',
    ), // key: 1v3clb
    ElIconPathElement('m13.148 9.228.383-.923'), // key: t2zzyc
    ElIconPathElement(
      'm13.53 15.696-.382-.924a3 3 0 1 1-2.296-5.544',
    ), // key: 1bxfiv
    ElIconPathElement('m14.772 10.852.923-.383'), // key: k9m8cz
    ElIconPathElement('m14.772 13.148.923.383'), // key: 1xvhww
    ElIconPathElement(
      'M4.5 10H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2h-.5',
    ), // key: tn8das
    ElIconPathElement(
      'M4.5 14H4a2 2 0 0 0-2 2v4a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-4a2 2 0 0 0-2-2h-.5',
    ), // key: 1g2pve
    ElIconPathElement('M6 18h.01'), // key: uhywen
    ElIconPathElement('M6 6h.01'), // key: 1utrut
    ElIconPathElement('m9.228 10.852-.923-.383'), // key: 1wtb30
    ElIconPathElement('m9.228 13.148-.923.383'), // key: 1a830x
  ]);

  /// `server-crash.mjs`
  static const ElLucideGlyph
  serverCrash = ElLucideGlyph('server-crash', <ElIconElement>[
    ElIconPathElement(
      'M6 10H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2h-2',
    ), // key: 4b9dqc
    ElIconPathElement(
      'M6 14H4a2 2 0 0 0-2 2v4a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-4a2 2 0 0 0-2-2h-2',
    ), // key: 22nnkd
    ElIconPathElement('M6 6h.01'), // key: 1utrut
    ElIconPathElement('M6 18h.01'), // key: uhywen
    ElIconPathElement('m13 6-4 6h6l-4 6'), // key: 14hqih
  ]);

  /// `server-off.mjs`
  static const ElLucideGlyph serverOff = ElLucideGlyph(
    'server-off',
    <ElIconElement>[
      ElIconPathElement(
        'M7 2h13a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2h-5',
      ), // key: bt2siv
      ElIconPathElement(
        'M10 10 2.5 2.5C2 2 2 2.5 2 5v3a2 2 0 0 0 2 2h6z',
      ), // key: 1hjrv1
      ElIconPathElement('M22 17v-1a2 2 0 0 0-2-2h-1'), // key: 1iynyr
      ElIconPathElement(
        'M4 14a2 2 0 0 0-2 2v4a2 2 0 0 0 2 2h16.5l1-.5.5.5-8-8H4z',
      ), // key: 161ggg
      ElIconPathElement('M6 18h.01'), // key: uhywen
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ],
  );

  /// `server-plus.mjs`
  static const ElLucideGlyph serverPlus = ElLucideGlyph(
    'server-plus',
    <ElIconElement>[
      ElIconPathElement(
        'M12.5 10H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v2',
      ), // key: s66i12
      ElIconPathElement('M16 12h6'), // key: 15xry1
      ElIconPathElement('M19 9v6'), // key: 1kf5t6
      ElIconPathElement(
        'M22 18v2a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-4a2 2 0 0 1 2-2h8.5',
      ), // key: lo70fm
      ElIconPathElement('M6 18h.01'), // key: uhywen
      ElIconPathElement('M6 6h.01'), // key: 1utrut
    ],
  );

  /// `server.mjs`
  static const ElLucideGlyph server = ElLucideGlyph('server', <ElIconElement>[
    ElIconRectElement(2, 2, 20, 8, 2, ry: 2), // key: ngkwjq
    ElIconRectElement(2, 14, 20, 8, 2, ry: 2), // key: iecqi9
    ElIconLineElement(6, 6, 6.01, 6), // key: 16zg32
    ElIconLineElement(6, 18, 6.01, 18), // key: nzw8ys
  ]);

  /// `settings-2.mjs`
  static const ElLucideGlyph settings2 = ElLucideGlyph(
    'settings-2',
    <ElIconElement>[
      ElIconPathElement('M14 17H5'), // key: gfn3mx
      ElIconPathElement('M19 7h-9'), // key: 6i9tg
      ElIconCircleElement(17, 17, 3), // key: 18b49y
      ElIconCircleElement(7, 7, 3), // key: dfmy0x
    ],
  );

  /// `settings.mjs`
  static const ElLucideGlyph
  settings = ElLucideGlyph('settings', <ElIconElement>[
    ElIconPathElement(
      'M9.671 4.136a2.34 2.34 0 0 1 4.659 0 2.34 2.34 0 0 0 3.319 1.915 2.34 2.34 0 0 1 2.33 4.033 2.34 2.34 0 0 0 0 3.831 2.34 2.34 0 0 1-2.33 4.033 2.34 2.34 0 0 0-3.319 1.915 2.34 2.34 0 0 1-4.659 0 2.34 2.34 0 0 0-3.32-1.915 2.34 2.34 0 0 1-2.33-4.033 2.34 2.34 0 0 0 0-3.831A2.34 2.34 0 0 1 6.35 6.051a2.34 2.34 0 0 0 3.319-1.915',
    ), // key: 1i5ecw
    ElIconCircleElement(12, 12, 3), // key: 1v7zrd
  ]);

  /// `shapes.mjs`
  static const ElLucideGlyph shapes = ElLucideGlyph('shapes', <ElIconElement>[
    ElIconPathElement(
      'M8.3 10a.7.7 0 0 1-.626-1.079L11.4 3a.7.7 0 0 1 1.198-.043L16.3 8.9a.7.7 0 0 1-.572 1.1Z',
    ), // key: 1bo67w
    ElIconRectElement(3, 14, 7, 7, 1), // key: 1bkyp8
    ElIconCircleElement(17.5, 17.5, 3.5), // key: w3z12y
  ]);

  /// `share-2.mjs`
  static const ElLucideGlyph share2 = ElLucideGlyph('share-2', <ElIconElement>[
    ElIconCircleElement(18, 5, 3), // key: gq8acd
    ElIconCircleElement(6, 12, 3), // key: w7nqdw
    ElIconCircleElement(18, 19, 3), // key: 1xt0gg
    ElIconLineElement(8.59, 13.51, 15.42, 17.49), // key: 47mynk
    ElIconLineElement(15.41, 6.51, 8.59, 10.49), // key: 1n3mei
  ]);

  /// `share.mjs`
  static const ElLucideGlyph share = ElLucideGlyph('share', <ElIconElement>[
    ElIconPathElement('M12 2v13'), // key: 1km8f5
    ElIconPathElement('m16 6-4-4-4 4'), // key: 13yo43
    ElIconPathElement(
      'M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8',
    ), // key: 1b2hhj
  ]);

  /// `sheet.mjs`
  static const ElLucideGlyph sheet = ElLucideGlyph('sheet', <ElIconElement>[
    ElIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    ElIconLineElement(3, 9, 21, 9), // key: 1vqk6q
    ElIconLineElement(3, 15, 21, 15), // key: o2sbyz
    ElIconLineElement(9, 9, 9, 21), // key: 1ib60c
    ElIconLineElement(15, 9, 15, 21), // key: 1n26ft
  ]);

  /// `shell.mjs`
  static const ElLucideGlyph shell = ElLucideGlyph('shell', <ElIconElement>[
    ElIconPathElement(
      'M14 11a2 2 0 1 1-4 0 4 4 0 0 1 8 0 6 6 0 0 1-12 0 8 8 0 0 1 16 0 10 10 0 1 1-20 0 11.93 11.93 0 0 1 2.42-7.22 2 2 0 1 1 3.16 2.44',
    ), // key: 1cn552
  ]);

  /// `shelving-unit.mjs`
  static const ElLucideGlyph shelvingUnit = ElLucideGlyph(
    'shelving-unit',
    <ElIconElement>[
      ElIconPathElement(
        'M12 12V9a1 1 0 0 0-1-1H9a1 1 0 0 0-1 1v3',
      ), // key: wiz68x
      ElIconPathElement(
        'M16 20v-3a1 1 0 0 0-1-1h-2a1 1 0 0 0-1 1v3',
      ), // key: 1b59c4
      ElIconPathElement('M20 22V2'), // key: 1bnhr8
      ElIconPathElement('M4 12h16'), // key: 1lakjw
      ElIconPathElement('M4 20h16'), // key: 14thso
      ElIconPathElement('M4 2v20'), // key: gtpd5x
      ElIconPathElement('M4 4h16'), // key: 1bkgr1
    ],
  );

  /// `shield-alert.mjs`
  static const ElLucideGlyph
  shieldAlert = ElLucideGlyph('shield-alert', <ElIconElement>[
    ElIconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    ElIconPathElement('M12 8v4'), // key: 1got3b
    ElIconPathElement('M12 16h.01'), // key: 1drbdi
  ]);

  /// `shield-ban.mjs`
  static const ElLucideGlyph
  shieldBan = ElLucideGlyph('shield-ban', <ElIconElement>[
    ElIconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    ElIconPathElement('m4.243 5.21 14.39 12.472'), // key: 1c9a7c
  ]);

  /// `shield-check.mjs`
  static const ElLucideGlyph
  shieldCheck = ElLucideGlyph('shield-check', <ElIconElement>[
    ElIconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    ElIconPathElement('m9 12 2 2 4-4'), // key: dzmm74
  ]);

  /// `shield-cog-corner.mjs`
  static const ElLucideGlyph
  shieldCogCorner = ElLucideGlyph('shield-cog-corner', <ElIconElement>[
    ElIconPathElement(
      'M11 22c-3.806-1.45-7-3.966-7-9V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1v4',
    ), // key: hf1sz5
    ElIconPathElement('M14.923 16.547 14 16.164'), // key: 41f878
    ElIconPathElement('m14.923 18.843-.923.383'), // key: 82rvv5
    ElIconPathElement('M16.547 14.923 16.164 14'), // key: 1r7ypn
    ElIconPathElement('m16.547 20.467-.383.924'), // key: au4kyj
    ElIconPathElement('m18.843 14.923.383-.923'), // key: 1cbrwq
    ElIconPathElement('m19.225 21.391-.382-.924'), // key: 1u2bh9
    ElIconPathElement('m20.467 16.547.923-.383'), // key: cprboc
    ElIconPathElement('m20.467 18.843.923.383'), // key: inm8l2
    ElIconCircleElement(17.695, 17.695, 3), // key: 1i1rmh
  ]);

  /// `shield-cog.mjs`
  static const ElLucideGlyph
  shieldCog = ElLucideGlyph('shield-cog', <ElIconElement>[
    ElIconPathElement('m10.929 14.467-.383.924'), // key: hdyevy
    ElIconPathElement('M10.929 8.923 10.546 8'), // key: 1nr44d
    ElIconPathElement('M13.225 8.923 13.608 8'), // key: aewley
    ElIconPathElement('m13.607 15.391-.382-.924'), // key: m37gf1
    ElIconPathElement('m14.849 10.547.923-.383'), // key: 1d3c4q
    ElIconPathElement('m14.849 12.843.923.383'), // key: lmvhy3
    ElIconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    ElIconPathElement('m9.305 10.547-.923-.383'), // key: 1d13ox
    ElIconPathElement('m9.305 12.843-.923.383'), // key: 7wxwh5
    ElIconCircleElement(12.077, 11.695, 3), // key: fse9k8
  ]);

  /// `shield-ellipsis.mjs`
  static const ElLucideGlyph
  shieldEllipsis = ElLucideGlyph('shield-ellipsis', <ElIconElement>[
    ElIconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    ElIconPathElement('M8 12h.01'), // key: czm47f
    ElIconPathElement('M12 12h.01'), // key: 1mp3jc
    ElIconPathElement('M16 12h.01'), // key: 1l6xoz
  ]);

  /// `shield-half.mjs`
  static const ElLucideGlyph
  shieldHalf = ElLucideGlyph('shield-half', <ElIconElement>[
    ElIconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    ElIconPathElement('M12 22V2'), // key: zs6s6o
  ]);

  /// `shield-keyhole.mjs`
  static const ElLucideGlyph
  shieldKeyhole = ElLucideGlyph('shield-keyhole', <ElIconElement>[
    ElIconPathElement('M12 13v3'), // key: gkc6qb
    ElIconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 01-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 011-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 011.52 0C14.51 3.81 17 5 19 5a1 1 0 011 1z',
    ), // key: 1buusj
    ElIconCircleElement(12, 11, 2), // key: 1yggc4
  ]);

  /// `shield-minus.mjs`
  static const ElLucideGlyph
  shieldMinus = ElLucideGlyph('shield-minus', <ElIconElement>[
    ElIconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    ElIconPathElement('M9 12h6'), // key: 1c52cq
  ]);

  /// `shield-off.mjs`
  static const ElLucideGlyph
  shieldOff = ElLucideGlyph('shield-off', <ElIconElement>[
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement(
      'M5 5a1 1 0 0 0-1 1v7c0 5 3.5 7.5 7.67 8.94a1 1 0 0 0 .67.01c2.35-.82 4.48-1.97 5.9-3.71',
    ), // key: 1jlk70
    ElIconPathElement(
      'M9.309 3.652A12.252 12.252 0 0 0 11.24 2.28a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1v7a9.784 9.784 0 0 1-.08 1.264',
    ), // key: 18rp1v
  ]);

  /// `shield-plus.mjs`
  static const ElLucideGlyph
  shieldPlus = ElLucideGlyph('shield-plus', <ElIconElement>[
    ElIconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    ElIconPathElement('M9 12h6'), // key: 1c52cq
    ElIconPathElement('M12 9v6'), // key: 199k2o
  ]);

  /// `shield-question-mark.mjs`
  static const ElLucideGlyph
  shieldQuestionMark = ElLucideGlyph('shield-question-mark', <ElIconElement>[
    ElIconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    ElIconPathElement('M9.1 9a3 3 0 0 1 5.82 1c0 2-3 3-3 3'), // key: mhlwft
    ElIconPathElement('M12 17h.01'), // key: p32p05
  ]);

  /// `shield-user.mjs`
  static const ElLucideGlyph
  shieldUser = ElLucideGlyph('shield-user', <ElIconElement>[
    ElIconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    ElIconPathElement('M6.376 18.91a6 6 0 0 1 11.249.003'), // key: hnjrf2
    ElIconCircleElement(12, 11, 4), // key: 1gt34v
  ]);

  /// `shield-x.mjs`
  static const ElLucideGlyph
  shieldX = ElLucideGlyph('shield-x', <ElIconElement>[
    ElIconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
    ElIconPathElement('m14.5 9.5-5 5'), // key: 17q4r4
    ElIconPathElement('m9.5 9.5 5 5'), // key: 18nt4w
  ]);

  /// `shield.mjs`
  static const ElLucideGlyph shield = ElLucideGlyph('shield', <ElIconElement>[
    ElIconPathElement(
      'M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z',
    ), // key: oel41y
  ]);

  /// `ship-wheel.mjs`
  static const ElLucideGlyph shipWheel = ElLucideGlyph(
    'ship-wheel',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 8), // key: 46899m
      ElIconPathElement('M12 2v7.5'), // key: 1e5rl5
      ElIconPathElement('m19 5-5.23 5.23'), // key: 1ezxxf
      ElIconPathElement('M22 12h-7.5'), // key: le1719
      ElIconPathElement('m19 19-5.23-5.23'), // key: p3fmgn
      ElIconPathElement('M12 14.5V22'), // key: dgcmos
      ElIconPathElement('M10.23 13.77 5 19'), // key: qwopd4
      ElIconPathElement('M9.5 12H2'), // key: r7bup8
      ElIconPathElement('M10.23 10.23 5 5'), // key: k2y7lj
      ElIconCircleElement(12, 12, 2.5), // key: ix0uyj
    ],
  );

  /// `ship.mjs`
  static const ElLucideGlyph ship = ElLucideGlyph('ship', <ElIconElement>[
    ElIconPathElement('M12 10.189V14'), // key: 1p8cqu
    ElIconPathElement('M12 2v3'), // key: qbqxhf
    ElIconPathElement(
      'M19 13V7a2 2 0 0 0-2-2H7a2 2 0 0 0-2 2v6',
    ), // key: qpkstq
    ElIconPathElement(
      'M19.38 20A11.6 11.6 0 0 0 21 14l-8.188-3.639a2 2 0 0 0-1.624 0L3 14a11.6 11.6 0 0 0 2.81 7.76',
    ), // key: 7tigtc
    ElIconPathElement(
      'M2 21c.6.5 1.2 1 2.5 1 2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1s1.2 1 2.5 1c2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1',
    ), // key: 1924j5
  ]);

  /// `shirt.mjs`
  static const ElLucideGlyph shirt = ElLucideGlyph('shirt', <ElIconElement>[
    ElIconPathElement(
      'M20.38 3.46 16 2a4 4 0 0 1-8 0L3.62 3.46a2 2 0 0 0-1.34 2.23l.58 3.47a1 1 0 0 0 .99.84H6v10c0 1.1.9 2 2 2h8a2 2 0 0 0 2-2V10h2.15a1 1 0 0 0 .99-.84l.58-3.47a2 2 0 0 0-1.34-2.23z',
    ), // key: 1wgbhj
  ]);

  /// `shopping-bag.mjs`
  static const ElLucideGlyph
  shoppingBag = ElLucideGlyph('shopping-bag', <ElIconElement>[
    ElIconPathElement('M16 10a4 4 0 0 1-8 0'), // key: 1ltviw
    ElIconPathElement('M3.103 6.034h17.794'), // key: awc11p
    ElIconPathElement(
      'M3.4 5.467a2 2 0 0 0-.4 1.2V20a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6.667a2 2 0 0 0-.4-1.2l-2-2.667A2 2 0 0 0 17 2H7a2 2 0 0 0-1.6.8z',
    ), // key: o988cm
  ]);

  /// `shopping-basket.mjs`
  static const ElLucideGlyph shoppingBasket = ElLucideGlyph(
    'shopping-basket',
    <ElIconElement>[
      ElIconPathElement('m15 11-1 9'), // key: 5wnq3a
      ElIconPathElement('m19 11-4-7'), // key: cnml18
      ElIconPathElement('M2 11h20'), // key: 3eubbj
      ElIconPathElement(
        'm3.5 11 1.6 7.4a2 2 0 0 0 2 1.6h9.8a2 2 0 0 0 2-1.6l1.7-7.4',
      ), // key: yiazzp
      ElIconPathElement('M4.5 15.5h15'), // key: 13mye1
      ElIconPathElement('m5 11 4-7'), // key: 116ra9
      ElIconPathElement('m9 11 1 9'), // key: 1ojof7
    ],
  );

  /// `shopping-cart.mjs`
  static const ElLucideGlyph
  shoppingCart = ElLucideGlyph('shopping-cart', <ElIconElement>[
    ElIconCircleElement(8, 21, 1), // key: jimo8o
    ElIconCircleElement(19, 21, 1), // key: 13723u
    ElIconPathElement(
      'M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12',
    ), // key: 9zh506
  ]);

  /// `shovel.mjs`
  static const ElLucideGlyph shovel = ElLucideGlyph('shovel', <ElIconElement>[
    ElIconPathElement(
      'M21.56 4.56a1.5 1.5 0 0 1 0 2.122l-.47.47a3 3 0 0 1-4.212-.03 3 3 0 0 1 0-4.243l.44-.44a1.5 1.5 0 0 1 2.121 0z',
    ), // key: 1gcedi
    ElIconPathElement(
      'M3 22a1 1 0 0 1-1-1v-3.586a1 1 0 0 1 .293-.707l3.355-3.355a1.205 1.205 0 0 1 1.704 0l3.296 3.296a1.205 1.205 0 0 1 0 1.704l-3.355 3.355a1 1 0 0 1-.707.293z',
    ), // key: pg9kv3
    ElIconPathElement('m9 15 7.879-7.878'), // key: 1o1zgh
  ]);

  /// `shower-head.mjs`
  static const ElLucideGlyph showerHead = ElLucideGlyph(
    'shower-head',
    <ElIconElement>[
      ElIconPathElement('m4 4 2.5 2.5'), // key: uv2vmf
      ElIconPathElement('M13.5 6.5a4.95 4.95 0 0 0-7 7'), // key: frdkwv
      ElIconPathElement('M15 5 5 15'), // key: 1ag8rq
      ElIconPathElement('M14 17v.01'), // key: eokfpp
      ElIconPathElement('M10 16v.01'), // key: 14uyyl
      ElIconPathElement('M13 13v.01'), // key: 1v1k97
      ElIconPathElement('M16 10v.01'), // key: 5169yg
      ElIconPathElement('M11 20v.01'), // key: cj92p8
      ElIconPathElement('M17 14v.01'), // key: 11cswd
      ElIconPathElement('M20 11v.01'), // key: 19e0od
    ],
  );

  /// `shredder.mjs`
  static const ElLucideGlyph
  shredder = ElLucideGlyph('shredder', <ElIconElement>[
    ElIconPathElement(
      'M4 13V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v5',
    ), // key: 1eob4r
    ElIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    ElIconPathElement('M10 22v-5'), // key: sfixh4
    ElIconPathElement('M14 19v-2'), // key: pdve8j
    ElIconPathElement('M18 20v-3'), // key: uox2gk
    ElIconPathElement('M2 13h20'), // key: 5evz65
    ElIconPathElement('M6 20v-3'), // key: c6pdcb
  ]);

  /// `shrimp.mjs`
  static const ElLucideGlyph shrimp = ElLucideGlyph('shrimp', <ElIconElement>[
    ElIconPathElement('M11 12h.01'), // key: 1lr4k6
    ElIconPathElement(
      'M13 22c.5-.5 1.12-1 2.5-1-1.38 0-2-.5-2.5-1',
    ), // key: fatpdi
    ElIconPathElement(
      'M14 2a3.28 3.28 0 0 1-3.227 1.798l-6.17-.561A2.387 2.387 0 1 0 4.387 8H15.5a1 1 0 0 1 0 13 1 1 0 0 0 0-5H12a7 7 0 0 1-7-7V8',
    ), // key: kehrqe
    ElIconPathElement('M14 8a8.5 8.5 0 0 1 0 8'), // key: 1imjx2
    ElIconPathElement('M16 16c2 0 4.5-4 4-6'), // key: z0nejz
  ]);

  /// `shrink.mjs`
  static const ElLucideGlyph shrink = ElLucideGlyph('shrink', <ElIconElement>[
    ElIconPathElement('m15 15 6 6m-6-6v4.8m0-4.8h4.8'), // key: 17vawe
    ElIconPathElement('M9 19.8V15m0 0H4.2M9 15l-6 6'), // key: chjx8e
    ElIconPathElement('M15 4.2V9m0 0h4.8M15 9l6-6'), // key: lav6yq
    ElIconPathElement('M9 4.2V9m0 0H4.2M9 9 3 3'), // key: 1pxi2q
  ]);

  /// `shrub.mjs`
  static const ElLucideGlyph shrub = ElLucideGlyph('shrub', <ElIconElement>[
    ElIconPathElement(
      'M12 22v-5.172a2 2 0 0 0-.586-1.414L9.5 13.5',
    ), // key: 1p17fm
    ElIconPathElement('M14.5 14.5 12 17'), // key: dy5w4y
    ElIconPathElement(
      'M17 8.8A6 6 0 0 1 13.8 20H10A6.5 6.5 0 0 1 7 8a5 5 0 0 1 10 0z',
    ), // key: 6z7b3o
  ]);

  /// `shuffle.mjs`
  static const ElLucideGlyph shuffle = ElLucideGlyph('shuffle', <ElIconElement>[
    ElIconPathElement('m18 14 4 4-4 4'), // key: 10pe0f
    ElIconPathElement('m18 2 4 4-4 4'), // key: pucp1d
    ElIconPathElement(
      'M2 18h1.973a4 4 0 0 0 3.3-1.7l5.454-8.6a4 4 0 0 1 3.3-1.7H22',
    ), // key: 1ailkh
    ElIconPathElement('M2 6h1.972a4 4 0 0 1 3.6 2.2'), // key: km57vx
    ElIconPathElement(
      'M22 18h-6.041a4 4 0 0 1-3.3-1.8l-.359-.45',
    ), // key: os18l9
  ]);

  /// `sigma.mjs`
  static const ElLucideGlyph sigma = ElLucideGlyph('sigma', <ElIconElement>[
    ElIconPathElement(
      'M18 7V5a1 1 0 0 0-1-1H6.5a.5.5 0 0 0-.4.8l4.5 6a2 2 0 0 1 0 2.4l-4.5 6a.5.5 0 0 0 .4.8H17a1 1 0 0 0 1-1v-2',
    ), // key: wuwx1p
  ]);

  /// `signal-high.mjs`
  static const ElLucideGlyph signalHigh = ElLucideGlyph(
    'signal-high',
    <ElIconElement>[
      ElIconPathElement('M2 20h.01'), // key: 4haj6o
      ElIconPathElement('M7 20v-4'), // key: j294jx
      ElIconPathElement('M12 20v-8'), // key: i3yub9
      ElIconPathElement('M17 20V8'), // key: 1tkaf5
    ],
  );

  /// `signal-low.mjs`
  static const ElLucideGlyph signalLow = ElLucideGlyph(
    'signal-low',
    <ElIconElement>[
      ElIconPathElement('M2 20h.01'), // key: 4haj6o
      ElIconPathElement('M7 20v-4'), // key: j294jx
    ],
  );

  /// `signal-medium.mjs`
  static const ElLucideGlyph signalMedium = ElLucideGlyph(
    'signal-medium',
    <ElIconElement>[
      ElIconPathElement('M2 20h.01'), // key: 4haj6o
      ElIconPathElement('M7 20v-4'), // key: j294jx
      ElIconPathElement('M12 20v-8'), // key: i3yub9
    ],
  );

  /// `signal-zero.mjs`
  static const ElLucideGlyph signalZero = ElLucideGlyph(
    'signal-zero',
    <ElIconElement>[
      ElIconPathElement('M2 20h.01'), // key: 4haj6o
    ],
  );

  /// `signal.mjs`
  static const ElLucideGlyph signal = ElLucideGlyph('signal', <ElIconElement>[
    ElIconPathElement('M2 20h.01'), // key: 4haj6o
    ElIconPathElement('M7 20v-4'), // key: j294jx
    ElIconPathElement('M12 20v-8'), // key: i3yub9
    ElIconPathElement('M17 20V8'), // key: 1tkaf5
    ElIconPathElement('M22 4v16'), // key: sih9yq
  ]);

  /// `signature.mjs`
  static const ElLucideGlyph
  signature = ElLucideGlyph('signature', <ElIconElement>[
    ElIconPathElement(
      'm21 17-2.156-1.868A.5.5 0 0 0 18 15.5v.5a1 1 0 0 1-1 1h-2a1 1 0 0 1-1-1c0-2.545-3.991-3.97-8.5-4a1 1 0 0 0 0 5c4.153 0 4.745-11.295 5.708-13.5a2.5 2.5 0 1 1 3.31 3.284',
    ), // key: y32ogt
    ElIconPathElement('M3 21h18'), // key: itz85i
  ]);

  /// `signpost-big.mjs`
  static const ElLucideGlyph signpostBig = ElLucideGlyph(
    'signpost-big',
    <ElIconElement>[
      ElIconPathElement('M10 9H4L2 7l2-2h6'), // key: 1hq7x2
      ElIconPathElement('M14 5h6l2 2-2 2h-6'), // key: bv62ej
      ElIconPathElement('M10 22V4a2 2 0 1 1 4 0v18'), // key: eqpcf2
      ElIconPathElement('M8 22h8'), // key: rmew8v
    ],
  );

  /// `signpost.mjs`
  static const ElLucideGlyph
  signpost = ElLucideGlyph('signpost', <ElIconElement>[
    ElIconPathElement('M12 13v8'), // key: 1l5pq0
    ElIconPathElement('M12 3v3'), // key: 1n5kay
    ElIconPathElement(
      'M2.354 10.354a1.207 1.207 0 0 1 0-1.708l2.06-2.06A2 2 0 0 1 5.828 6h12.344a2 2 0 0 1 1.414.586l2.06 2.06a1.207 1.207 0 0 1 0 1.708l-2.06 2.06a2 2 0 0 1-1.414.586H5.828a2 2 0 0 1-1.414-.586z',
    ), // key: 1tm261
  ]);

  /// `siren.mjs`
  static const ElLucideGlyph siren = ElLucideGlyph('siren', <ElIconElement>[
    ElIconPathElement('M7 18v-6a5 5 0 1 1 10 0v6'), // key: pcx96s
    ElIconPathElement(
      'M5 21a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-1a2 2 0 0 0-2-2H7a2 2 0 0 0-2 2z',
    ), // key: 1b4s83
    ElIconPathElement('M21 12h1'), // key: jtio3y
    ElIconPathElement('M18.5 4.5 18 5'), // key: g5sp9y
    ElIconPathElement('M2 12h1'), // key: 1uaihz
    ElIconPathElement('M12 2v1'), // key: 11qlp1
    ElIconPathElement('m4.929 4.929.707.707'), // key: 1i51kw
    ElIconPathElement('M12 12v6'), // key: 3ahymv
  ]);

  /// `skip-back.mjs`
  static const ElLucideGlyph
  skipBack = ElLucideGlyph('skip-back', <ElIconElement>[
    ElIconPathElement(
      'M17.971 4.285A2 2 0 0 1 21 6v12a2 2 0 0 1-3.029 1.715l-9.997-5.998a2 2 0 0 1-.003-3.432z',
    ), // key: 15892j
    ElIconPathElement('M3 20V4'), // key: 1ptbpl
  ]);

  /// `skip-forward.mjs`
  static const ElLucideGlyph
  skipForward = ElLucideGlyph('skip-forward', <ElIconElement>[
    ElIconPathElement('M21 4v16'), // key: 7j8fe9
    ElIconPathElement(
      'M6.029 4.285A2 2 0 0 0 3 6v12a2 2 0 0 0 3.029 1.715l9.997-5.998a2 2 0 0 0 .003-3.432z',
    ), // key: zs4d6
  ]);

  /// `skull.mjs`
  static const ElLucideGlyph skull = ElLucideGlyph('skull', <ElIconElement>[
    ElIconPathElement('m12.5 17-.5-1-.5 1h1z'), // key: 3me087
    ElIconPathElement(
      'M15 22a1 1 0 0 0 1-1v-1a2 2 0 0 0 1.56-3.25 8 8 0 1 0-11.12 0A2 2 0 0 0 8 20v1a1 1 0 0 0 1 1z',
    ), // key: 1o5pge
    ElIconCircleElement(15, 12, 1), // key: 1tmaij
    ElIconCircleElement(9, 12, 1), // key: 1vctgf
  ]);

  /// `slash.mjs`
  static const ElLucideGlyph slash = ElLucideGlyph('slash', <ElIconElement>[
    ElIconPathElement('M22 2 2 22'), // key: y4kqgn
  ]);

  /// `slice.mjs`
  static const ElLucideGlyph slice = ElLucideGlyph('slice', <ElIconElement>[
    ElIconPathElement(
      'M11 16.586V19a1 1 0 0 1-1 1H2L18.37 3.63a1 1 0 1 1 3 3l-9.663 9.663a1 1 0 0 1-1.414 0L8 14',
    ), // key: 1sllp5
  ]);

  /// `sliders-horizontal.mjs`
  static const ElLucideGlyph slidersHorizontal = ElLucideGlyph(
    'sliders-horizontal',
    <ElIconElement>[
      ElIconPathElement('M10 5H3'), // key: 1qgfaw
      ElIconPathElement('M12 19H3'), // key: yhmn1j
      ElIconPathElement('M14 3v4'), // key: 1sua03
      ElIconPathElement('M16 17v4'), // key: 1q0r14
      ElIconPathElement('M21 12h-9'), // key: 1o4lsq
      ElIconPathElement('M21 19h-5'), // key: 1rlt1p
      ElIconPathElement('M21 5h-7'), // key: 1oszz2
      ElIconPathElement('M8 10v4'), // key: tgpxqk
      ElIconPathElement('M8 12H3'), // key: a7s4jb
    ],
  );

  /// `sliders-vertical.mjs`
  static const ElLucideGlyph slidersVertical = ElLucideGlyph(
    'sliders-vertical',
    <ElIconElement>[
      ElIconPathElement('M10 8h4'), // key: 1sr2af
      ElIconPathElement('M12 21v-9'), // key: 17s77i
      ElIconPathElement('M12 8V3'), // key: 13r4qs
      ElIconPathElement('M17 16h4'), // key: h1uq16
      ElIconPathElement('M19 12V3'), // key: o1uvq1
      ElIconPathElement('M19 21v-5'), // key: qua636
      ElIconPathElement('M3 14h4'), // key: bcjad9
      ElIconPathElement('M5 10V3'), // key: cb8scm
      ElIconPathElement('M5 21v-7'), // key: 1w1uti
    ],
  );

  /// `smartphone-charging.mjs`
  static const ElLucideGlyph smartphoneCharging = ElLucideGlyph(
    'smartphone-charging',
    <ElIconElement>[
      ElIconRectElement(5, 2, 14, 20, 2, ry: 2), // key: 1yt0o3
      ElIconPathElement('M12.667 8 10 12h4l-2.667 4'), // key: h9lk2d
    ],
  );

  /// `smartphone-nfc.mjs`
  static const ElLucideGlyph smartphoneNfc = ElLucideGlyph(
    'smartphone-nfc',
    <ElIconElement>[
      ElIconRectElement(2, 6, 7, 12, 1), // key: 5nje8w
      ElIconPathElement('M13 8.32a7.43 7.43 0 0 1 0 7.36'), // key: 1g306n
      ElIconPathElement('M16.46 6.21a11.76 11.76 0 0 1 0 11.58'), // key: uqvjvo
      ElIconPathElement('M19.91 4.1a15.91 15.91 0 0 1 .01 15.8'), // key: ujntz3
    ],
  );

  /// `smartphone.mjs`
  static const ElLucideGlyph smartphone = ElLucideGlyph(
    'smartphone',
    <ElIconElement>[
      ElIconRectElement(5, 2, 14, 20, 2, ry: 2), // key: 1yt0o3
      ElIconPathElement('M12 18h.01'), // key: mhygvu
    ],
  );

  /// `smile-plus.mjs`
  static const ElLucideGlyph smilePlus = ElLucideGlyph(
    'smile-plus',
    <ElIconElement>[
      ElIconPathElement('M22 11v1a10 10 0 1 1-9-10'), // key: ew0xw9
      ElIconPathElement('M8 14s1.5 2 4 2 4-2 4-2'), // key: 1y1vjs
      ElIconLineElement(9, 9, 9.01, 9), // key: yxxnd0
      ElIconLineElement(15, 9, 15.01, 9), // key: 1p4y9e
      ElIconPathElement('M16 5h6'), // key: 1vod17
      ElIconPathElement('M19 2v6'), // key: 4bpg5p
    ],
  );

  /// `smile.mjs`
  static const ElLucideGlyph smile = ElLucideGlyph('smile', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconPathElement('M8 14s1.5 2 4 2 4-2 4-2'), // key: 1y1vjs
    ElIconLineElement(9, 9, 9.01, 9), // key: yxxnd0
    ElIconLineElement(15, 9, 15.01, 9), // key: 1p4y9e
  ]);

  /// `snail.mjs`
  static const ElLucideGlyph snail = ElLucideGlyph('snail', <ElIconElement>[
    ElIconPathElement(
      'M2 13a6 6 0 1 0 12 0 4 4 0 1 0-8 0 2 2 0 0 0 4 0',
    ), // key: hneq2s
    ElIconCircleElement(10, 13, 8), // key: 194lz3
    ElIconPathElement(
      'M2 21h12c4.4 0 8-3.6 8-8V7a2 2 0 1 0-4 0v6',
    ), // key: ixqyt7
    ElIconPathElement('M18 3 19.1 5.2'), // key: 9tjm43
    ElIconPathElement('M22 3 20.9 5.2'), // key: j3odrs
  ]);

  /// `snowflake.mjs`
  static const ElLucideGlyph snowflake = ElLucideGlyph(
    'snowflake',
    <ElIconElement>[
      ElIconPathElement('m10 20-1.25-2.5L6 18'), // key: 18frcb
      ElIconPathElement('M10 4 8.75 6.5 6 6'), // key: 7mghy3
      ElIconPathElement('m14 20 1.25-2.5L18 18'), // key: 1chtki
      ElIconPathElement('m14 4 1.25 2.5L18 6'), // key: 1b4wsy
      ElIconPathElement('m17 21-3-6h-4'), // key: 15hhxa
      ElIconPathElement('m17 3-3 6 1.5 3'), // key: 11697g
      ElIconPathElement('M2 12h6.5L10 9'), // key: kv9z4n
      ElIconPathElement('m20 10-1.5 2 1.5 2'), // key: 1swlpi
      ElIconPathElement('M22 12h-6.5L14 15'), // key: 1mxi28
      ElIconPathElement('m4 10 1.5 2L4 14'), // key: k9enpj
      ElIconPathElement('m7 21 3-6-1.5-3'), // key: j8hb9u
      ElIconPathElement('m7 3 3 6h4'), // key: 1otusx
    ],
  );

  /// `soap-dispenser-droplet.mjs`
  static const ElLucideGlyph
  soapDispenserDroplet = ElLucideGlyph('soap-dispenser-droplet', <
    ElIconElement
  >[
    ElIconPathElement('M10.5 2v4'), // key: 1xt6in
    ElIconPathElement('M14 2H7a2 2 0 0 0-2 2'), // key: e6xig3
    ElIconPathElement(
      'M19.29 14.76A6.67 6.67 0 0 1 17 11a6.6 6.6 0 0 1-2.29 3.76c-1.15.92-1.71 2.04-1.71 3.19 0 2.22 1.8 4.05 4 4.05s4-1.83 4-4.05c0-1.16-.57-2.26-1.71-3.19',
    ), // key: adq7uc
    ElIconPathElement(
      'M9.607 21H6a2 2 0 0 1-2-2v-7a2 2 0 0 1 2-2h7V7a1 1 0 0 0-1-1H9a1 1 0 0 0-1 1v3',
    ), // key: t9hm96
  ]);

  /// `sofa.mjs`
  static const ElLucideGlyph sofa = ElLucideGlyph('sofa', <ElIconElement>[
    ElIconPathElement('M20 9V6a2 2 0 0 0-2-2H6a2 2 0 0 0-2 2v3'), // key: 1dgpiv
    ElIconPathElement(
      'M2 16a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-5a2 2 0 0 0-4 0v1.5a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5V11a2 2 0 0 0-4 0z',
    ), // key: xacw8m
    ElIconPathElement('M4 18v2'), // key: jwo5n2
    ElIconPathElement('M20 18v2'), // key: 1ar1qi
    ElIconPathElement('M12 4v9'), // key: oqhhn3
  ]);

  /// `solar-panel.mjs`
  static const ElLucideGlyph
  solarPanel = ElLucideGlyph('solar-panel', <ElIconElement>[
    ElIconPathElement('M11 2h2'), // key: isr7bz
    ElIconPathElement('m14.28 14-4.56 8'), // key: 4anwcf
    ElIconPathElement('m21 22-1.558-4H4.558'), // key: enk13h
    ElIconPathElement('M3 10v2'), // key: w8mti9
    ElIconPathElement(
      'M6.245 15.04A2 2 0 0 1 8 14h12a1 1 0 0 1 .864 1.505l-3.11 5.457A2 2 0 0 1 16 22H4a1 1 0 0 1-.863-1.506z',
    ), // key: pouggg
    ElIconPathElement('M7 2a4 4 0 0 1-4 4'), // key: 78s8of
    ElIconPathElement('m8.66 7.66 1.41 1.41'), // key: 1vaqj8
  ]);

  /// `soup.mjs`
  static const ElLucideGlyph soup = ElLucideGlyph('soup', <ElIconElement>[
    ElIconPathElement('M12 21a9 9 0 0 0 9-9H3a9 9 0 0 0 9 9Z'), // key: 4rw317
    ElIconPathElement('M7 21h10'), // key: 1b0cd5
    ElIconPathElement('M19.5 12 22 6'), // key: shfsr5
    ElIconPathElement(
      'M16.25 3c.27.1.8.53.75 1.36-.06.83-.93 1.2-1 2.02-.05.78.34 1.24.73 1.62',
    ), // key: rpc6vp
    ElIconPathElement(
      'M11.25 3c.27.1.8.53.74 1.36-.05.83-.93 1.2-.98 2.02-.06.78.33 1.24.72 1.62',
    ), // key: 1lf63m
    ElIconPathElement(
      'M6.25 3c.27.1.8.53.75 1.36-.06.83-.93 1.2-1 2.02-.05.78.34 1.24.74 1.62',
    ), // key: 97tijn
  ]);

  /// `space.mjs`
  static const ElLucideGlyph space = ElLucideGlyph('space', <ElIconElement>[
    ElIconPathElement(
      'M22 17v1c0 .5-.5 1-1 1H3c-.5 0-1-.5-1-1v-1',
    ), // key: lt2kga
  ]);

  /// `spade.mjs`
  static const ElLucideGlyph spade = ElLucideGlyph('spade', <ElIconElement>[
    ElIconPathElement('M12 18v4'), // key: jadmvz
    ElIconPathElement(
      'M2 14.499a5.5 5.5 0 0 0 9.591 3.675.6.6 0 0 1 .818.001A5.5 5.5 0 0 0 22 14.5c0-2.29-1.5-4-3-5.5l-5.492-5.312a2 2 0 0 0-3-.02L5 8.999c-1.5 1.5-3 3.2-3 5.5',
    ), // key: 1aw2pz
  ]);

  /// `sparkle.mjs`
  static const ElLucideGlyph sparkle = ElLucideGlyph('sparkle', <ElIconElement>[
    ElIconPathElement(
      'M11.017 2.814a1 1 0 0 1 1.966 0l1.051 5.558a2 2 0 0 0 1.594 1.594l5.558 1.051a1 1 0 0 1 0 1.966l-5.558 1.051a2 2 0 0 0-1.594 1.594l-1.051 5.558a1 1 0 0 1-1.966 0l-1.051-5.558a2 2 0 0 0-1.594-1.594l-5.558-1.051a1 1 0 0 1 0-1.966l5.558-1.051a2 2 0 0 0 1.594-1.594z',
    ), // key: 1s2grr
  ]);

  /// `sparkles.mjs`
  static const ElLucideGlyph
  sparkles = ElLucideGlyph('sparkles', <ElIconElement>[
    ElIconPathElement(
      'M11.017 2.814a1 1 0 0 1 1.966 0l1.051 5.558a2 2 0 0 0 1.594 1.594l5.558 1.051a1 1 0 0 1 0 1.966l-5.558 1.051a2 2 0 0 0-1.594 1.594l-1.051 5.558a1 1 0 0 1-1.966 0l-1.051-5.558a2 2 0 0 0-1.594-1.594l-5.558-1.051a1 1 0 0 1 0-1.966l5.558-1.051a2 2 0 0 0 1.594-1.594z',
    ), // key: 1s2grr
    ElIconPathElement('M20 2v4'), // key: 1rf3ol
    ElIconPathElement('M22 4h-4'), // key: gwowj6
    ElIconCircleElement(4, 20, 2), // key: 6kqj1y
  ]);

  /// `speaker.mjs`
  static const ElLucideGlyph speaker = ElLucideGlyph('speaker', <ElIconElement>[
    ElIconRectElement(4, 2, 16, 20, 2), // key: 1nb95v
    ElIconPathElement('M12 6h.01'), // key: 1vi96p
    ElIconCircleElement(12, 14, 4), // key: 1jruaj
    ElIconPathElement('M12 14h.01'), // key: 1etili
  ]);

  /// `speech.mjs`
  static const ElLucideGlyph speech = ElLucideGlyph('speech', <ElIconElement>[
    ElIconPathElement(
      'M8.8 20v-4.1l1.9.2a2.3 2.3 0 0 0 2.164-2.1V8.3A5.37 5.37 0 0 0 2 8.25c0 2.8.656 3.054 1 4.55a5.77 5.77 0 0 1 .029 2.758L2 20',
    ), // key: 11atix
    ElIconPathElement('M19.8 17.8a7.5 7.5 0 0 0 .003-10.603'), // key: yol142
    ElIconPathElement('M17 15a3.5 3.5 0 0 0-.025-4.975'), // key: ssbmkc
  ]);

  /// `spell-check-2.mjs`
  static const ElLucideGlyph
  spellCheck2 = ElLucideGlyph('spell-check-2', <ElIconElement>[
    ElIconPathElement('m6 16 6-12 6 12'), // key: 1b4byz
    ElIconPathElement('M8 12h8'), // key: 1wcyev
    ElIconPathElement(
      'M4 21c1.1 0 1.1-1 2.3-1s1.1 1 2.3 1c1.1 0 1.1-1 2.3-1 1.1 0 1.1 1 2.3 1 1.1 0 1.1-1 2.3-1 1.1 0 1.1 1 2.3 1 1.1 0 1.1-1 2.3-1',
    ), // key: 8mdmtu
  ]);

  /// `spell-check.mjs`
  static const ElLucideGlyph spellCheck = ElLucideGlyph(
    'spell-check',
    <ElIconElement>[
      ElIconPathElement('m6 16 6-12 6 12'), // key: 1b4byz
      ElIconPathElement('M8 12h8'), // key: 1wcyev
      ElIconPathElement('m16 20 2 2 4-4'), // key: 13tcca
    ],
  );

  /// `spline-pointer.mjs`
  static const ElLucideGlyph
  splinePointer = ElLucideGlyph('spline-pointer', <ElIconElement>[
    ElIconPathElement(
      'M12.034 12.681a.498.498 0 0 1 .647-.647l9 3.5a.5.5 0 0 1-.033.943l-3.444 1.068a1 1 0 0 0-.66.66l-1.067 3.443a.5.5 0 0 1-.943.033z',
    ), // key: xwnzip
    ElIconPathElement('M5 17A12 12 0 0 1 17 5'), // key: 1okkup
    ElIconCircleElement(19, 5, 2), // key: mhkx31
    ElIconCircleElement(5, 19, 2), // key: v8kfzx
  ]);

  /// `spline.mjs`
  static const ElLucideGlyph spline = ElLucideGlyph('spline', <ElIconElement>[
    ElIconCircleElement(19, 5, 2), // key: mhkx31
    ElIconCircleElement(5, 19, 2), // key: v8kfzx
    ElIconPathElement('M5 17A12 12 0 0 1 17 5'), // key: 1okkup
  ]);

  /// `split.mjs`
  static const ElLucideGlyph split = ElLucideGlyph('split', <ElIconElement>[
    ElIconPathElement('M16 3h5v5'), // key: 1806ms
    ElIconPathElement('M8 3H3v5'), // key: 15dfkv
    ElIconPathElement('M12 22v-8.3a4 4 0 0 0-1.172-2.872L3 3'), // key: 1qrqzj
    ElIconPathElement('m15 9 6-6'), // key: ko1vev
  ]);

  /// `spool.mjs`
  static const ElLucideGlyph spool = ElLucideGlyph('spool', <ElIconElement>[
    ElIconPathElement(
      'M17 13.44 4.442 17.082A2 2 0 0 0 4.982 21H19a2 2 0 0 0 .558-3.921l-1.115-.32A2 2 0 0 1 17 14.837V7.66',
    ), // key: 13vns8
    ElIconPathElement(
      'm7 10.56 12.558-3.642A2 2 0 0 0 19.018 3H5a2 2 0 0 0-.558 3.921l1.115.32A2 2 0 0 1 7 9.163v7.178',
    ), // key: s8x3u0
  ]);

  /// `sport-shoe.mjs`
  static const ElLucideGlyph
  sportShoe = ElLucideGlyph('sport-shoe', <ElIconElement>[
    ElIconPathElement('m15 10.42 4.8-5.07'), // key: 10at9d
    ElIconPathElement('M19 18h3'), // key: nnkd4d
    ElIconPathElement(
      'M9.5 22 21.414 9.415A2 2 0 0 0 21.2 6.4l-5.61-4.208A1 1 0 0 0 14 3v2a2 2 0 0 1-1.394 1.906L8.677 8.053A1 1 0 0 0 8 9c-.155 6.393-2.082 9-4 9a2 2 0 0 0 0 4h14',
    ), // key: v410ed
  ]);

  /// `spotlight.mjs`
  static const ElLucideGlyph
  spotlight = ElLucideGlyph('spotlight', <ElIconElement>[
    ElIconPathElement('M15.295 19.562 16 22'), // key: 31jsb7
    ElIconPathElement('m17 16 3.758 2.098'), // key: 121ar7
    ElIconPathElement('m19 12.5 3.026-.598'), // key: 19ukd3
    ElIconPathElement(
      'M7.61 6.3a3 3 0 0 0-3.92 1.3l-1.38 2.79a3 3 0 0 0 1.3 3.91l6.89 3.597a1 1 0 0 0 1.342-.447l3.106-6.211a1 1 0 0 0-.447-1.341z',
    ), // key: lwb9l9
    ElIconPathElement('M8 9V2'), // key: 1xa0v7
  ]);

  /// `spray-can.mjs`
  static const ElLucideGlyph sprayCan = ElLucideGlyph(
    'spray-can',
    <ElIconElement>[
      ElIconPathElement('M3 3h.01'), // key: 159qn6
      ElIconPathElement('M7 5h.01'), // key: 1hq22a
      ElIconPathElement('M11 7h.01'), // key: 1osv80
      ElIconPathElement('M3 7h.01'), // key: 1xzrh3
      ElIconPathElement('M7 9h.01'), // key: 19b3jx
      ElIconPathElement('M3 11h.01'), // key: 1eifu7
      ElIconRectElement(15, 5, 4, 4, 0), // key: mri9e4; rx,ry absent
      ElIconPathElement(
        'm19 9 2 2v10c0 .6-.4 1-1 1h-6c-.6 0-1-.4-1-1V11l2-2',
      ), // key: aib6hk
      ElIconPathElement('m13 14 8-2'), // key: 1d7bmk
      ElIconPathElement('m13 19 8-2'), // key: 1y2vml
    ],
  );

  /// `sprout.mjs`
  static const ElLucideGlyph sprout = ElLucideGlyph('sprout', <ElIconElement>[
    ElIconPathElement(
      'M14 9.536V7a4 4 0 0 1 4-4h1.5a.5.5 0 0 1 .5.5V5a4 4 0 0 1-4 4 4 4 0 0 0-4 4c0 2 1 3 1 5a5 5 0 0 1-1 3',
    ), // key: 139s4v
    ElIconPathElement('M4 9a5 5 0 0 1 8 4 5 5 0 0 1-8-4'), // key: 1dlkgp
    ElIconPathElement('M5 21h14'), // key: 11awu3
  ]);

  /// `square-activity.mjs`
  static const ElLucideGlyph squareActivity = ElLucideGlyph(
    'square-activity',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M17 12h-2l-2 5-2-10-2 5H7'), // key: 15hlnc
    ],
  );

  /// `square-arrow-down-left.mjs`
  static const ElLucideGlyph squareArrowDownLeft = ElLucideGlyph(
    'square-arrow-down-left',
    <ElIconElement>[
      ElIconPathElement('M15 15H9l6-6'), // key: 1w52wt
      ElIconPathElement('M9 15V9'), // key: 1kwqze
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `square-arrow-down-right.mjs`
  static const ElLucideGlyph squareArrowDownRight = ElLucideGlyph(
    'square-arrow-down-right',
    <ElIconElement>[
      ElIconPathElement('M15 15 9 9'), // key: qb9ybb
      ElIconPathElement('M9 15h6V9'), // key: 1wezwn
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `square-arrow-down.mjs`
  static const ElLucideGlyph squareArrowDown = ElLucideGlyph(
    'square-arrow-down',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M12 8v8'), // key: napkw2
      ElIconPathElement('m8 12 4 4 4-4'), // key: k98ssh
    ],
  );

  /// `square-arrow-left.mjs`
  static const ElLucideGlyph squareArrowLeft = ElLucideGlyph(
    'square-arrow-left',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('m12 8-4 4 4 4'), // key: 15vm53
      ElIconPathElement('M16 12H8'), // key: 1fr5h0
    ],
  );

  /// `square-arrow-out-down-left.mjs`
  static const ElLucideGlyph squareArrowOutDownLeft = ElLucideGlyph(
    'square-arrow-out-down-left',
    <ElIconElement>[
      ElIconPathElement(
        'M13 21h6a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v6',
      ), // key: 14qz4y
      ElIconPathElement('m3 21 9-9'), // key: 1jfql5
      ElIconPathElement('M9 21H3v-6'), // key: wtvkvv
    ],
  );

  /// `square-arrow-out-down-right.mjs`
  static const ElLucideGlyph squareArrowOutDownRight = ElLucideGlyph(
    'square-arrow-out-down-right',
    <ElIconElement>[
      ElIconPathElement(
        'M21 11V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h6',
      ), // key: 14rsvq
      ElIconPathElement('m21 21-9-9'), // key: 1et2py
      ElIconPathElement('M21 15v6h-6'), // key: 1jko0i
    ],
  );

  /// `square-arrow-out-up-left.mjs`
  static const ElLucideGlyph squareArrowOutUpLeft = ElLucideGlyph(
    'square-arrow-out-up-left',
    <ElIconElement>[
      ElIconPathElement(
        'M13 3h6a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-6',
      ), // key: 14mv1t
      ElIconPathElement('m3 3 9 9'), // key: rks13r
      ElIconPathElement('M3 9V3h6'), // key: ira0h2
    ],
  );

  /// `square-arrow-out-up-right.mjs`
  static const ElLucideGlyph squareArrowOutUpRight = ElLucideGlyph(
    'square-arrow-out-up-right',
    <ElIconElement>[
      ElIconPathElement(
        'M21 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h6',
      ), // key: y09zxi
      ElIconPathElement('m21 3-9 9'), // key: mpx6sq
      ElIconPathElement('M15 3h6v6'), // key: 1q9fwt
    ],
  );

  /// `square-arrow-right-enter.mjs`
  static const ElLucideGlyph
  squareArrowRightEnter = ElLucideGlyph('square-arrow-right-enter', <
    ElIconElement
  >[
    ElIconPathElement('m10 16 4-4-4-4'), // key: w9835o
    ElIconPathElement('M3 12h11'), // key: pmja8f
    ElIconPathElement(
      'M3 8V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-3',
    ), // key: 1bqs5q
  ]);

  /// `square-arrow-right-exit.mjs`
  static const ElLucideGlyph
  squareArrowRightExit = ElLucideGlyph('square-arrow-right-exit', <
    ElIconElement
  >[
    ElIconPathElement('M10 12h11'), // key: 6m4ad9
    ElIconPathElement('m17 16 4-4-4-4'), // key: iin4zf
    ElIconPathElement(
      'M21 6.344V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-1.344',
    ), // key: 1ojbhp
  ]);

  /// `square-arrow-right.mjs`
  static const ElLucideGlyph squareArrowRight = ElLucideGlyph(
    'square-arrow-right',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M8 12h8'), // key: 1wcyev
      ElIconPathElement('m12 16 4-4-4-4'), // key: 1i9zcv
    ],
  );

  /// `square-arrow-up-left.mjs`
  static const ElLucideGlyph squareArrowUpLeft = ElLucideGlyph(
    'square-arrow-up-left',
    <ElIconElement>[
      ElIconPathElement('M15 15 9 9'), // key: qb9ybb
      ElIconPathElement('M9 15V9h6'), // key: 1pdr5l
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `square-arrow-up-right.mjs`
  static const ElLucideGlyph squareArrowUpRight = ElLucideGlyph(
    'square-arrow-up-right',
    <ElIconElement>[
      ElIconPathElement('M15 15V9H9'), // key: vxyd2h
      ElIconPathElement('m9 15 6-6'), // key: 1ygkhp
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `square-arrow-up.mjs`
  static const ElLucideGlyph squareArrowUp = ElLucideGlyph(
    'square-arrow-up',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('m16 12-4-4-4 4'), // key: 177agl
      ElIconPathElement('M12 16V8'), // key: 1sbj14
    ],
  );

  /// `square-asterisk.mjs`
  static const ElLucideGlyph squareAsterisk = ElLucideGlyph(
    'square-asterisk',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M12 8v8'), // key: napkw2
      ElIconPathElement('m8.5 14 7-4'), // key: 12hpby
      ElIconPathElement('m8.5 10 7 4'), // key: wwy2dy
    ],
  );

  /// `square-bottom-dashed-scissors.mjs`
  static const ElLucideGlyph squareBottomDashedScissors = ElLucideGlyph(
    'square-bottom-dashed-scissors',
    <ElIconElement>[
      ElIconPathElement('M14 21h1'), // key: v9vybs
      ElIconPathElement('m17 17-2.18-2.18'), // key: 1y7dt1
      ElIconPathElement(
        'M5 21a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v14a2 2 0 01-2 2',
      ), // key: 2q1jq4
      ElIconPathElement('M9 21h1'), // key: 15o7lz
      ElIconPathElement('M9.56 14.44 17 7'), // key: ue8l15
      ElIconPathElement('M9.56 9.56 12 12'), // key: rml9qv
      ElIconCircleElement(8.5, 15.5, 1.5), // key: 12hfy1
      ElIconCircleElement(8.5, 8.5, 1.5), // key: cn5opk
    ],
  );

  /// `square-centerline-dashed-horizontal.mjs`
  static const ElLucideGlyph squareCenterlineDashedHorizontal = ElLucideGlyph(
    'square-centerline-dashed-horizontal',
    <ElIconElement>[
      ElIconPathElement(
        'M8 3H5a2 2 0 0 0-2 2v14c0 1.1.9 2 2 2h3',
      ), // key: 1i73f7
      ElIconPathElement(
        'M16 3h3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-3',
      ), // key: saxlbk
      ElIconPathElement('M12 20v2'), // key: 1lh1kg
      ElIconPathElement('M12 14v2'), // key: 8jcxud
      ElIconPathElement('M12 8v2'), // key: 1woqiv
      ElIconPathElement('M12 2v2'), // key: tus03m
    ],
  );

  /// `square-centerline-dashed-vertical.mjs`
  static const ElLucideGlyph squareCenterlineDashedVertical = ElLucideGlyph(
    'square-centerline-dashed-vertical',
    <ElIconElement>[
      ElIconPathElement(
        'M21 8V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v3',
      ), // key: 14bfxa
      ElIconPathElement(
        'M21 16v3a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-3',
      ), // key: 14rx03
      ElIconPathElement('M4 12H2'), // key: rhcxmi
      ElIconPathElement('M10 12H8'), // key: s88cx1
      ElIconPathElement('M16 12h-2'), // key: 10asgb
      ElIconPathElement('M22 12h-2'), // key: 14jgyd
    ],
  );

  /// `square-chart-gantt.mjs`
  static const ElLucideGlyph squareChartGantt = ElLucideGlyph(
    'square-chart-gantt',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M9 8h7'), // key: kbo1nt
      ElIconPathElement('M8 12h6'), // key: ikassy
      ElIconPathElement('M11 16h5'), // key: oq65wt
    ],
  );

  /// `square-check-big.mjs`
  static const ElLucideGlyph squareCheckBig = ElLucideGlyph(
    'square-check-big',
    <ElIconElement>[
      ElIconPathElement(
        'M21 10.656V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h12.344',
      ), // key: 2acyp4
      ElIconPathElement('m9 11 3 3L22 4'), // key: 1pflzl
    ],
  );

  /// `square-check.mjs`
  static const ElLucideGlyph squareCheck = ElLucideGlyph(
    'square-check',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('m9 12 2 2 4-4'), // key: dzmm74
    ],
  );

  /// `square-chevron-down.mjs`
  static const ElLucideGlyph squareChevronDown = ElLucideGlyph(
    'square-chevron-down',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('m16 10-4 4-4-4'), // key: 894hmk
    ],
  );

  /// `square-chevron-left.mjs`
  static const ElLucideGlyph squareChevronLeft = ElLucideGlyph(
    'square-chevron-left',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('m14 16-4-4 4-4'), // key: ojs7w8
    ],
  );

  /// `square-chevron-right.mjs`
  static const ElLucideGlyph squareChevronRight = ElLucideGlyph(
    'square-chevron-right',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('m10 8 4 4-4 4'), // key: 1wy4r4
    ],
  );

  /// `square-chevron-up.mjs`
  static const ElLucideGlyph squareChevronUp = ElLucideGlyph(
    'square-chevron-up',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('m8 14 4-4 4 4'), // key: fy2ptz
    ],
  );

  /// `square-code.mjs`
  static const ElLucideGlyph squareCode = ElLucideGlyph(
    'square-code',
    <ElIconElement>[
      ElIconPathElement('m10 9-3 3 3 3'), // key: 1oro0q
      ElIconPathElement('m14 15 3-3-3-3'), // key: bz13h7
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `square-dashed-bottom-code.mjs`
  static const ElLucideGlyph squareDashedBottomCode = ElLucideGlyph(
    'square-dashed-bottom-code',
    <ElIconElement>[
      ElIconPathElement('M10 9.5 8 12l2 2.5'), // key: 3mjy60
      ElIconPathElement('M14 21h1'), // key: v9vybs
      ElIconPathElement('m14 9.5 2 2.5-2 2.5'), // key: 1bir2l
      ElIconPathElement(
        'M5 21a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2',
      ), // key: as5y1o
      ElIconPathElement('M9 21h1'), // key: 15o7lz
    ],
  );

  /// `square-dashed-bottom.mjs`
  static const ElLucideGlyph squareDashedBottom = ElLucideGlyph(
    'square-dashed-bottom',
    <ElIconElement>[
      ElIconPathElement(
        'M5 21a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2',
      ), // key: as5y1o
      ElIconPathElement('M9 21h1'), // key: 15o7lz
      ElIconPathElement('M14 21h1'), // key: v9vybs
    ],
  );

  /// `square-dashed-kanban.mjs`
  static const ElLucideGlyph squareDashedKanban = ElLucideGlyph(
    'square-dashed-kanban',
    <ElIconElement>[
      ElIconPathElement('M8 7v7'), // key: 1x2jlm
      ElIconPathElement('M12 7v4'), // key: xawao1
      ElIconPathElement('M16 7v9'), // key: 1hp2iy
      ElIconPathElement('M5 3a2 2 0 0 0-2 2'), // key: y57alp
      ElIconPathElement('M9 3h1'), // key: 1yesri
      ElIconPathElement('M14 3h1'), // key: 1ec4yj
      ElIconPathElement('M19 3a2 2 0 0 1 2 2'), // key: 18rm91
      ElIconPathElement('M21 9v1'), // key: mxsmne
      ElIconPathElement('M21 14v1'), // key: 169vum
      ElIconPathElement('M21 19a2 2 0 0 1-2 2'), // key: 1j7049
      ElIconPathElement('M14 21h1'), // key: v9vybs
      ElIconPathElement('M9 21h1'), // key: 15o7lz
      ElIconPathElement('M5 21a2 2 0 0 1-2-2'), // key: sbafld
      ElIconPathElement('M3 14v1'), // key: vnatye
      ElIconPathElement('M3 9v1'), // key: 1r0deq
    ],
  );

  /// `square-dashed-mouse-pointer.mjs`
  static const ElLucideGlyph
  squareDashedMousePointer = ElLucideGlyph('square-dashed-mouse-pointer', <
    ElIconElement
  >[
    ElIconPathElement(
      'M12.034 12.681a.498.498 0 0 1 .647-.647l9 3.5a.5.5 0 0 1-.033.943l-3.444 1.068a1 1 0 0 0-.66.66l-1.067 3.443a.5.5 0 0 1-.943.033z',
    ), // key: xwnzip
    ElIconPathElement('M5 3a2 2 0 0 0-2 2'), // key: y57alp
    ElIconPathElement('M19 3a2 2 0 0 1 2 2'), // key: 18rm91
    ElIconPathElement('M5 21a2 2 0 0 1-2-2'), // key: sbafld
    ElIconPathElement('M9 3h1'), // key: 1yesri
    ElIconPathElement('M9 21h2'), // key: 1qve2z
    ElIconPathElement('M14 3h1'), // key: 1ec4yj
    ElIconPathElement('M3 9v1'), // key: 1r0deq
    ElIconPathElement('M21 9v2'), // key: p14lih
    ElIconPathElement('M3 14v1'), // key: vnatye
  ]);

  /// `square-dashed-text.mjs`
  static const ElLucideGlyph squareDashedText = ElLucideGlyph(
    'square-dashed-text',
    <ElIconElement>[
      ElIconPathElement('M14 21h1'), // key: v9vybs
      ElIconPathElement('M14 3h1'), // key: 1ec4yj
      ElIconPathElement('M19 3a2 2 0 0 1 2 2'), // key: 18rm91
      ElIconPathElement('M21 14v1'), // key: 169vum
      ElIconPathElement('M21 19a2 2 0 0 1-2 2'), // key: 1j7049
      ElIconPathElement('M21 9v1'), // key: mxsmne
      ElIconPathElement('M3 14v1'), // key: vnatye
      ElIconPathElement('M3 9v1'), // key: 1r0deq
      ElIconPathElement('M5 21a2 2 0 0 1-2-2'), // key: sbafld
      ElIconPathElement('M5 3a2 2 0 0 0-2 2'), // key: y57alp
      ElIconPathElement('M7 12h10'), // key: b7w52i
      ElIconPathElement('M7 16h6'), // key: 1vyc9m
      ElIconPathElement('M7 8h8'), // key: 1jbsf9
      ElIconPathElement('M9 21h1'), // key: 15o7lz
      ElIconPathElement('M9 3h1'), // key: 1yesri
    ],
  );

  /// `square-dashed-top-solid.mjs`
  static const ElLucideGlyph squareDashedTopSolid = ElLucideGlyph(
    'square-dashed-top-solid',
    <ElIconElement>[
      ElIconPathElement('M14 21h1'), // key: v9vybs
      ElIconPathElement('M21 14v1'), // key: 169vum
      ElIconPathElement('M21 19a2 2 0 0 1-2 2'), // key: 1j7049
      ElIconPathElement('M21 9v1'), // key: mxsmne
      ElIconPathElement('M3 14v1'), // key: vnatye
      ElIconPathElement('M3 5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2'), // key: 89voep
      ElIconPathElement('M3 9v1'), // key: 1r0deq
      ElIconPathElement('M5 21a2 2 0 0 1-2-2'), // key: sbafld
      ElIconPathElement('M9 21h1'), // key: 15o7lz
    ],
  );

  /// `square-dashed.mjs`
  static const ElLucideGlyph squareDashed = ElLucideGlyph(
    'square-dashed',
    <ElIconElement>[
      ElIconPathElement('M5 3a2 2 0 0 0-2 2'), // key: y57alp
      ElIconPathElement('M19 3a2 2 0 0 1 2 2'), // key: 18rm91
      ElIconPathElement('M21 19a2 2 0 0 1-2 2'), // key: 1j7049
      ElIconPathElement('M5 21a2 2 0 0 1-2-2'), // key: sbafld
      ElIconPathElement('M9 3h1'), // key: 1yesri
      ElIconPathElement('M9 21h1'), // key: 15o7lz
      ElIconPathElement('M14 3h1'), // key: 1ec4yj
      ElIconPathElement('M14 21h1'), // key: v9vybs
      ElIconPathElement('M3 9v1'), // key: 1r0deq
      ElIconPathElement('M21 9v1'), // key: mxsmne
      ElIconPathElement('M3 14v1'), // key: vnatye
      ElIconPathElement('M21 14v1'), // key: 169vum
    ],
  );

  /// `square-divide.mjs`
  static const ElLucideGlyph squareDivide = ElLucideGlyph(
    'square-divide',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
      ElIconLineElement(8, 12, 16, 12), // key: 1jonct
      ElIconLineElement(12, 16, 12, 16), // key: aqc6ln
      ElIconLineElement(12, 8, 12, 8), // key: 1mkcni
    ],
  );

  /// `square-dot.mjs`
  static const ElLucideGlyph squareDot = ElLucideGlyph(
    'square-dot',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconCircleElement(12, 12, 1), // key: 41hilf
    ],
  );

  /// `square-equal.mjs`
  static const ElLucideGlyph squareEqual = ElLucideGlyph(
    'square-equal',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M7 10h10'), // key: 1101jm
      ElIconPathElement('M7 14h10'), // key: 1mhdw3
    ],
  );

  /// `square-function.mjs`
  static const ElLucideGlyph squareFunction = ElLucideGlyph(
    'square-function',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
      ElIconPathElement(
        'M9 17c2 0 2.8-1 2.8-2.8V10c0-2 1-3.3 3.2-3',
      ), // key: m1af9g
      ElIconPathElement('M9 11.2h5.7'), // key: 3zgcl2
    ],
  );

  /// `square-kanban.mjs`
  static const ElLucideGlyph squareKanban = ElLucideGlyph(
    'square-kanban',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M8 7v7'), // key: 1x2jlm
      ElIconPathElement('M12 7v4'), // key: xawao1
      ElIconPathElement('M16 7v9'), // key: 1hp2iy
    ],
  );

  /// `square-library.mjs`
  static const ElLucideGlyph squareLibrary = ElLucideGlyph(
    'square-library',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M7 7v10'), // key: d5nglc
      ElIconPathElement('M11 7v10'), // key: pptsnr
      ElIconPathElement('m15 7 2 10'), // key: 1m7qm5
    ],
  );

  /// `square-m.mjs`
  static const ElLucideGlyph
  squareM = ElLucideGlyph('square-m', <ElIconElement>[
    ElIconPathElement(
      'M8 16V8.5a.5.5 0 0 1 .9-.3l2.7 3.599a.5.5 0 0 0 .8 0l2.7-3.6a.5.5 0 0 1 .9.3V16',
    ), // key: 1ywlsj
    ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `square-menu.mjs`
  static const ElLucideGlyph squareMenu = ElLucideGlyph(
    'square-menu',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M7 8h10'), // key: 1jw688
      ElIconPathElement('M7 12h10'), // key: b7w52i
      ElIconPathElement('M7 16h10'), // key: wp8him
    ],
  );

  /// `square-minus.mjs`
  static const ElLucideGlyph squareMinus = ElLucideGlyph(
    'square-minus',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M8 12h8'), // key: 1wcyev
    ],
  );

  /// `square-mouse-pointer.mjs`
  static const ElLucideGlyph
  squareMousePointer = ElLucideGlyph('square-mouse-pointer', <ElIconElement>[
    ElIconPathElement(
      'M12.034 12.681a.498.498 0 0 1 .647-.647l9 3.5a.5.5 0 0 1-.033.943l-3.444 1.068a1 1 0 0 0-.66.66l-1.067 3.443a.5.5 0 0 1-.943.033z',
    ), // key: xwnzip
    ElIconPathElement(
      'M21 11V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h6',
    ), // key: 14rsvq
  ]);

  /// `square-off.mjs`
  static const ElLucideGlyph squareOff = ElLucideGlyph(
    'square-off',
    <ElIconElement>[
      ElIconPathElement(
        'M20.4 20.4a2 2 0 01-1.4.6H5a2 2 0 01-2-2V5a2 2 0 01.59-1.41',
      ), // key: 7ym6nm
      ElIconPathElement('M21 15.3V5a2 2 0 00-2-2H8.7'), // key: m4nk5y
      ElIconPathElement('M22 22 2 2'), // key: 1r8tn9
    ],
  );

  /// `square-parking-off.mjs`
  static const ElLucideGlyph squareParkingOff = ElLucideGlyph(
    'square-parking-off',
    <ElIconElement>[
      ElIconPathElement(
        'M3.6 3.6A2 2 0 0 1 5 3h14a2 2 0 0 1 2 2v14a2 2 0 0 1-.59 1.41',
      ), // key: 9l1ft6
      ElIconPathElement('M3 8.7V19a2 2 0 0 0 2 2h10.3'), // key: 17knke
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
      ElIconPathElement('M13 13a3 3 0 1 0 0-6H9v2'), // key: uoagbd
      ElIconPathElement('M9 17v-2.3'), // key: 1jxgo2
    ],
  );

  /// `square-parking.mjs`
  static const ElLucideGlyph squareParking = ElLucideGlyph(
    'square-parking',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M9 17V7h4a3 3 0 0 1 0 6H9'), // key: 1dfk2c
    ],
  );

  /// `square-pause.mjs`
  static const ElLucideGlyph squarePause = ElLucideGlyph(
    'square-pause',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconLineElement(10, 15, 10, 9), // key: c1nkhi
      ElIconLineElement(14, 15, 14, 9), // key: h65svq
    ],
  );

  /// `square-pen.mjs`
  static const ElLucideGlyph
  squarePen = ElLucideGlyph('square-pen', <ElIconElement>[
    ElIconPathElement(
      'M12 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7',
    ), // key: 1m0v6g
    ElIconPathElement(
      'M18.375 2.625a1 1 0 0 1 3 3l-9.013 9.014a2 2 0 0 1-.853.505l-2.873.84a.5.5 0 0 1-.62-.62l.84-2.873a2 2 0 0 1 .506-.852z',
    ), // key: ohrbg2
  ]);

  /// `square-percent.mjs`
  static const ElLucideGlyph squarePercent = ElLucideGlyph(
    'square-percent',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('m15 9-6 6'), // key: 1uzhvr
      ElIconPathElement('M9 9h.01'), // key: 1q5me6
      ElIconPathElement('M15 15h.01'), // key: lqbp3k
    ],
  );

  /// `square-pi.mjs`
  static const ElLucideGlyph squarePi = ElLucideGlyph(
    'square-pi',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M7 7h10'), // key: udp07y
      ElIconPathElement('M10 7v10'), // key: i1d9ee
      ElIconPathElement('M16 17a2 2 0 0 1-2-2V7'), // key: ftwdc7
    ],
  );

  /// `square-pilcrow.mjs`
  static const ElLucideGlyph squarePilcrow = ElLucideGlyph(
    'square-pilcrow',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M12 12H9.5a2.5 2.5 0 0 1 0-5H17'), // key: 1l9586
      ElIconPathElement('M12 7v10'), // key: jspqdw
      ElIconPathElement('M16 7v10'), // key: lavkr4
    ],
  );

  /// `square-play.mjs`
  static const ElLucideGlyph
  squarePlay = ElLucideGlyph('square-play', <ElIconElement>[
    ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ElIconPathElement(
      'M9 9.003a1 1 0 0 1 1.517-.859l4.997 2.997a1 1 0 0 1 0 1.718l-4.997 2.997A1 1 0 0 1 9 14.996z',
    ), // key: kmsa83
  ]);

  /// `square-plus.mjs`
  static const ElLucideGlyph squarePlus = ElLucideGlyph(
    'square-plus',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M8 12h8'), // key: 1wcyev
      ElIconPathElement('M12 8v8'), // key: napkw2
    ],
  );

  /// `square-power.mjs`
  static const ElLucideGlyph squarePower = ElLucideGlyph(
    'square-power',
    <ElIconElement>[
      ElIconPathElement('M12 7v4'), // key: xawao1
      ElIconPathElement('M7.998 9.003a5 5 0 1 0 8-.005'), // key: 1pek45
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `square-radical.mjs`
  static const ElLucideGlyph squareRadical = ElLucideGlyph(
    'square-radical',
    <ElIconElement>[
      ElIconPathElement('M7 12h2l2 5 2-10h4'), // key: 1fxv6h
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `square-round-corner.mjs`
  static const ElLucideGlyph squareRoundCorner = ElLucideGlyph(
    'square-round-corner',
    <ElIconElement>[
      ElIconPathElement('M21 11a8 8 0 0 0-8-8'), // key: 1lxwo5
      ElIconPathElement(
        'M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4',
      ), // key: 1dv2y5
    ],
  );

  /// `square-scissors.mjs`
  static const ElLucideGlyph squareScissors = ElLucideGlyph(
    'square-scissors',
    <ElIconElement>[
      ElIconPathElement('m17 17-2.18-2.18'), // key: 1y7dt1
      ElIconPathElement('M9.56 14.44 17 7'), // key: ue8l15
      ElIconPathElement('M9.56 9.56 12 12'), // key: rml9qv
      ElIconCircleElement(8.5, 15.5, 1.5), // key: 12hfy1
      ElIconCircleElement(8.5, 8.5, 1.5), // key: cn5opk
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    ],
  );

  /// `square-sigma.mjs`
  static const ElLucideGlyph squareSigma = ElLucideGlyph(
    'square-sigma',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M16 8.9V7H8l4 5-4 5h8v-1.9'), // key: 9nih0i
    ],
  );

  /// `square-slash.mjs`
  static const ElLucideGlyph squareSlash = ElLucideGlyph(
    'square-slash',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconLineElement(9, 15, 15, 9), // key: 1dfufj
    ],
  );

  /// `square-split-horizontal.mjs`
  static const ElLucideGlyph squareSplitHorizontal = ElLucideGlyph(
    'square-split-horizontal',
    <ElIconElement>[
      ElIconPathElement('M8 19H5c-1 0-2-1-2-2V7c0-1 1-2 2-2h3'), // key: lubmu8
      ElIconPathElement('M16 5h3c1 0 2 1 2 2v10c0 1-1 2-2 2h-3'), // key: 1ag34g
      ElIconLineElement(12, 4, 12, 20), // key: 1tx1rr
    ],
  );

  /// `square-split-vertical.mjs`
  static const ElLucideGlyph
  squareSplitVertical = ElLucideGlyph('square-split-vertical', <ElIconElement>[
    ElIconPathElement('M5 8V5c0-1 1-2 2-2h10c1 0 2 1 2 2v3'), // key: 1pi83i
    ElIconPathElement('M19 16v3c0 1-1 2-2 2H7c-1 0-2-1-2-2v-3'), // key: ido5k7
    ElIconLineElement(4, 12, 20, 12), // key: 1e0a9i
  ]);

  /// `square-square.mjs`
  static const ElLucideGlyph squareSquare = ElLucideGlyph(
    'square-square',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
      ElIconRectElement(8, 8, 8, 8, 1), // key: z9xiuo
    ],
  );

  /// `square-stack.mjs`
  static const ElLucideGlyph squareStack = ElLucideGlyph(
    'square-stack',
    <ElIconElement>[
      ElIconPathElement(
        'M4 10c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h4c1.1 0 2 .9 2 2',
      ), // key: 4i38lg
      ElIconPathElement(
        'M10 16c-1.1 0-2-.9-2-2v-4c0-1.1.9-2 2-2h4c1.1 0 2 .9 2 2',
      ), // key: mlte4a
      ElIconRectElement(14, 14, 8, 8, 2), // key: 1fa9i4
    ],
  );

  /// `square-star.mjs`
  static const ElLucideGlyph
  squareStar = ElLucideGlyph('square-star', <ElIconElement>[
    ElIconPathElement(
      'M11.035 7.69a1 1 0 0 1 1.909.024l.737 1.452a1 1 0 0 0 .737.535l1.634.256a1 1 0 0 1 .588 1.806l-1.172 1.168a1 1 0 0 0-.282.866l.259 1.613a1 1 0 0 1-1.541 1.134l-1.465-.75a1 1 0 0 0-.912 0l-1.465.75a1 1 0 0 1-1.539-1.133l.258-1.613a1 1 0 0 0-.282-.866l-1.156-1.153a1 1 0 0 1 .572-1.822l1.633-.256a1 1 0 0 0 .737-.535z',
    ), // key: 13edca
    ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `square-stop.mjs`
  static const ElLucideGlyph squareStop = ElLucideGlyph(
    'square-stop',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconRectElement(9, 9, 6, 6, 1), // key: 1ssd4o
    ],
  );

  /// `square-terminal.mjs`
  static const ElLucideGlyph squareTerminal = ElLucideGlyph(
    'square-terminal',
    <ElIconElement>[
      ElIconPathElement('m7 11 2-2-2-2'), // key: 1lz0vl
      ElIconPathElement('M11 13h4'), // key: 1p7l4v
      ElIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    ],
  );

  /// `square-user-round.mjs`
  static const ElLucideGlyph squareUserRound = ElLucideGlyph(
    'square-user-round',
    <ElIconElement>[
      ElIconPathElement('M18 21a6 6 0 0 0-12 0'), // key: kaz2du
      ElIconCircleElement(12, 11, 4), // key: 1gt34v
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    ],
  );

  /// `square-user.mjs`
  static const ElLucideGlyph squareUser = ElLucideGlyph(
    'square-user',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconCircleElement(12, 10, 3), // key: ilqhr7
      ElIconPathElement(
        'M7 21v-2a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v2',
      ), // key: 1m6ac2
    ],
  );

  /// `square-x.mjs`
  static const ElLucideGlyph squareX = ElLucideGlyph(
    'square-x',
    <ElIconElement>[
      ElIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
      ElIconPathElement('m15 9-6 6'), // key: 1uzhvr
      ElIconPathElement('m9 9 6 6'), // key: z0biqf
    ],
  );

  /// `square.mjs`
  static const ElLucideGlyph square = ElLucideGlyph('square', <ElIconElement>[
    ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
  ]);

  /// `squares-exclude.mjs`
  static const ElLucideGlyph
  squaresExclude = ElLucideGlyph('squares-exclude', <ElIconElement>[
    ElIconPathElement(
      'M16 12v2a2 2 0 0 1-2 2H9a1 1 0 0 0-1 1v3a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V10a2 2 0 0 0-2-2h0',
    ), // key: 1mcohs
    ElIconPathElement(
      'M4 16a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v3a1 1 0 0 1-1 1h-5a2 2 0 0 0-2 2v2',
    ), // key: 1r1efp
  ]);

  /// `squares-intersect.mjs`
  static const ElLucideGlyph squaresIntersect = ElLucideGlyph(
    'squares-intersect',
    <ElIconElement>[
      ElIconPathElement('M10 22a2 2 0 0 1-2-2'), // key: i7yj1i
      ElIconPathElement('M14 2a2 2 0 0 1 2 2'), // key: 170a0m
      ElIconPathElement('M16 22h-2'), // key: 18d249
      ElIconPathElement('M2 10V8'), // key: 7yj4fe
      ElIconPathElement('M2 4a2 2 0 0 1 2-2'), // key: ddgnws
      ElIconPathElement('M20 8a2 2 0 0 1 2 2'), // key: 1770vt
      ElIconPathElement('M22 14v2'), // key: iot8ja
      ElIconPathElement('M22 20a2 2 0 0 1-2 2'), // key: qj8q6g
      ElIconPathElement('M4 16a2 2 0 0 1-2-2'), // key: 1dnafg
      ElIconPathElement(
        'M8 10a2 2 0 0 1 2-2h5a1 1 0 0 1 1 1v5a2 2 0 0 1-2 2H9a1 1 0 0 1-1-1z',
      ), // key: ci6f0b
      ElIconPathElement('M8 2h2'), // key: 1gmkwm
    ],
  );

  /// `squares-subtract.mjs`
  static const ElLucideGlyph
  squaresSubtract = ElLucideGlyph('squares-subtract', <ElIconElement>[
    ElIconPathElement('M10 22a2 2 0 0 1-2-2'), // key: i7yj1i
    ElIconPathElement('M16 22h-2'), // key: 18d249
    ElIconPathElement(
      'M16 4a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h3a1 1 0 0 0 1-1v-5a2 2 0 0 1 2-2h5a1 1 0 0 0 1-1z',
    ), // key: 1njgbb
    ElIconPathElement('M20 8a2 2 0 0 1 2 2'), // key: 1770vt
    ElIconPathElement('M22 14v2'), // key: iot8ja
    ElIconPathElement('M22 20a2 2 0 0 1-2 2'), // key: qj8q6g
  ]);

  /// `squares-unite.mjs`
  static const ElLucideGlyph
  squaresUnite = ElLucideGlyph('squares-unite', <ElIconElement>[
    ElIconPathElement(
      'M4 16a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v3a1 1 0 0 0 1 1h3a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H10a2 2 0 0 1-2-2v-3a1 1 0 0 0-1-1z',
    ), // key: 17jnth
  ]);

  /// `squircle-dashed.mjs`
  static const ElLucideGlyph squircleDashed = ElLucideGlyph(
    'squircle-dashed',
    <ElIconElement>[
      ElIconPathElement('M13.77 3.043a34 34 0 0 0-3.54 0'), // key: 1oaobr
      ElIconPathElement('M13.771 20.956a33 33 0 0 1-3.541.001'), // key: 95iq0j
      ElIconPathElement(
        'M20.18 17.74c-.51 1.15-1.29 1.93-2.439 2.44',
      ), // key: 1u6qty
      ElIconPathElement(
        'M20.18 6.259c-.51-1.148-1.291-1.929-2.44-2.438',
      ), // key: 1ew6g6
      ElIconPathElement('M20.957 10.23a33 33 0 0 1 0 3.54'), // key: 1l9npr
      ElIconPathElement('M3.043 10.23a34 34 0 0 0 .001 3.541'), // key: 1it6jm
      ElIconPathElement(
        'M6.26 20.179c-1.15-.508-1.93-1.29-2.44-2.438',
      ), // key: 14uchd
      ElIconPathElement(
        'M6.26 3.82c-1.149.51-1.93 1.291-2.44 2.44',
      ), // key: 8k4agb
    ],
  );

  /// `squircle.mjs`
  static const ElLucideGlyph squircle = ElLucideGlyph(
    'squircle',
    <ElIconElement>[
      ElIconPathElement(
        'M12 3c7.2 0 9 1.8 9 9s-1.8 9-9 9-9-1.8-9-9 1.8-9 9-9',
      ), // key: garfkc
    ],
  );

  /// `squirrel.mjs`
  static const ElLucideGlyph
  squirrel = ElLucideGlyph('squirrel', <ElIconElement>[
    ElIconPathElement('M15.236 22a3 3 0 0 0-2.2-5'), // key: 21bitc
    ElIconPathElement(
      'M16 20a3 3 0 0 1 3-3h1a2 2 0 0 0 2-2v-2a4 4 0 0 0-4-4V4',
    ), // key: oh0fg0
    ElIconPathElement('M18 13h.01'), // key: 9veqaj
    ElIconPathElement(
      'M18 6a4 4 0 0 0-4 4 7 7 0 0 0-7 7c0-5 4-5 4-10.5a4.5 4.5 0 1 0-9 0 2.5 2.5 0 0 0 5 0C7 10 3 11 3 17c0 2.8 2.2 5 5 5h10',
    ), // key: 980v8a
  ]);

  /// `stamp.mjs`
  static const ElLucideGlyph stamp = ElLucideGlyph('stamp', <ElIconElement>[
    ElIconPathElement(
      'M14 13V8.5C14 7 15 7 15 5a3 3 0 0 0-6 0c0 2 1 2 1 3.5V13',
    ), // key: i9gjdv
    ElIconPathElement(
      'M20 15.5a2.5 2.5 0 0 0-2.5-2.5h-11A2.5 2.5 0 0 0 4 15.5V17a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1z',
    ), // key: 1vzg3v
    ElIconPathElement('M5 22h14'), // key: ehvnwv
  ]);

  /// `star-check.mjs`
  static const ElLucideGlyph
  starCheck = ElLucideGlyph('star-check', <ElIconElement>[
    ElIconPathElement(
      'm19.06 12.501 2.78-2.707a.53.53 0 0 0-.294-.905l-5.166-.755a2.1 2.1 0 0 1-1.595-1.16l-2.31-4.68a.53.53 0 0 0-.95.001L9.216 6.974a2.1 2.1 0 0 1-1.597 1.16l-5.165.755a.53.53 0 0 0-.294.906l3.736 3.637a2.1 2.1 0 0 1 .611 1.879l-.88 5.139a.53.53 0 0 0 .769.56l4.617-2.428.027-.014',
    ), // key: 14g7km
    ElIconPathElement('m15 18 2 2 4-4'), // key: 1szwhi
  ]);

  /// `star-half.mjs`
  static const ElLucideGlyph
  starHalf = ElLucideGlyph('star-half', <ElIconElement>[
    ElIconPathElement(
      'M12 18.338a2.1 2.1 0 0 0-.987.244L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.12 2.12 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.12 2.12 0 0 0 1.597-1.16l2.309-4.679A.53.53 0 0 1 12 2',
    ), // key: 2ksp49
  ]);

  /// `star-minus.mjs`
  static const ElLucideGlyph
  starMinus = ElLucideGlyph('star-minus', <ElIconElement>[
    ElIconPathElement('M15 18h6'), // key: 3b3c90
    ElIconPathElement(
      'M17.688 14a2.1 2.1 0 0 1 .416-.568l3.736-3.638a.53.53 0 0 0-.294-.905l-5.166-.755a2.1 2.1 0 0 1-1.595-1.16l-2.31-4.68a.53.53 0 0 0-.95.001L9.216 6.974a2.1 2.1 0 0 1-1.597 1.16l-5.165.755a.53.53 0 0 0-.294.906l3.736 3.637a2.1 2.1 0 0 1 .611 1.879l-.88 5.139a.53.53 0 0 0 .769.56l4.617-2.428.027-.014',
    ), // key: rwo527
  ]);

  /// `star-off.mjs`
  static const ElLucideGlyph
  starOff = ElLucideGlyph('star-off', <ElIconElement>[
    ElIconPathElement(
      'm10.344 4.688 1.181-2.393a.53.53 0 0 1 .95 0l2.31 4.679a2.12 2.12 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.237 3.152',
    ), // key: 19ctli
    ElIconPathElement(
      'm17.945 17.945.43 2.505a.53.53 0 0 1-.771.56l-4.618-2.428a2.12 2.12 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.12 2.12 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a8 8 0 0 0 .4-.099',
    ), // key: ptqqvy
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `star-plus.mjs`
  static const ElLucideGlyph
  starPlus = ElLucideGlyph('star-plus', <ElIconElement>[
    ElIconPathElement(
      'M11.013 18.582 6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.12 2.12 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.12 2.12 0 0 0 1.597-1.16l2.309-4.679a.53.53 0 0 1 .95 0l2.31 4.679a2.12 2.12 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904L20 11.5',
    ), // key: 1hs8rk
    ElIconPathElement('M15 18h6'), // key: 3b3c90
    ElIconPathElement('M18 15v6'), // key: 9wciyi
  ]);

  /// `star-x.mjs`
  static const ElLucideGlyph starX = ElLucideGlyph('star-x', <ElIconElement>[
    ElIconPathElement('m15.5 15.5 5 5'), // key: 1ky94l
    ElIconPathElement(
      'm20.063 11.525 1.777-1.731a.53.53 0 0 0-.294-.905l-5.166-.755a2.1 2.1 0 0 1-1.595-1.16l-2.31-4.68a.53.53 0 0 0-.95.001L9.216 6.974a2.1 2.1 0 0 1-1.597 1.16l-5.165.755a.53.53 0 0 0-.294.906l3.736 3.637a2.1 2.1 0 0 1 .611 1.879l-.88 5.139a.53.53 0 0 0 .769.56l4.617-2.428a2.1 2.1 0 0 1 .987-.243 2 2 0 0 1 .132.004',
    ), // key: 6uuto3
    ElIconPathElement('m20.5 15.5-5 5'), // key: 1w5am3
  ]);

  /// `star.mjs`
  static const ElLucideGlyph star = ElLucideGlyph('star', <ElIconElement>[
    ElIconPathElement(
      'M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z',
    ), // key: r04s7s
  ]);

  /// `step-back.mjs`
  static const ElLucideGlyph
  stepBack = ElLucideGlyph('step-back', <ElIconElement>[
    ElIconPathElement(
      'M13.971 4.285A2 2 0 0 1 17 6v12a2 2 0 0 1-3.029 1.715l-9.997-5.998a2 2 0 0 1-.003-3.432z',
    ), // key: 19qhus
    ElIconPathElement('M21 20V4'), // key: cb8qj8
  ]);

  /// `step-forward.mjs`
  static const ElLucideGlyph
  stepForward = ElLucideGlyph('step-forward', <ElIconElement>[
    ElIconPathElement(
      'M10.029 4.285A2 2 0 0 0 7 6v12a2 2 0 0 0 3.029 1.715l9.997-5.998a2 2 0 0 0 .003-3.432z',
    ), // key: 1ystz2
    ElIconPathElement('M3 4v16'), // key: 1ph11n
  ]);

  /// `stethoscope.mjs`
  static const ElLucideGlyph stethoscope = ElLucideGlyph(
    'stethoscope',
    <ElIconElement>[
      ElIconPathElement('M11 2v2'), // key: 1539x4
      ElIconPathElement('M5 2v2'), // key: 1yf1q8
      ElIconPathElement(
        'M5 3H4a2 2 0 0 0-2 2v4a6 6 0 0 0 12 0V5a2 2 0 0 0-2-2h-1',
      ), // key: rb5t3r
      ElIconPathElement('M8 15a6 6 0 0 0 12 0v-3'), // key: x18d4x
      ElIconCircleElement(20, 10, 2), // key: ts1r5v
    ],
  );

  /// `sticker.mjs`
  static const ElLucideGlyph sticker = ElLucideGlyph('sticker', <ElIconElement>[
    ElIconPathElement(
      'M21 9a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 15 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2z',
    ), // key: 1dfntj
    ElIconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
    ElIconPathElement('M8 13h.01'), // key: 1sbv64
    ElIconPathElement('M16 13h.01'), // key: wip0gl
    ElIconPathElement('M10 16s.8 1 2 1c1.3 0 2-1 2-1'), // key: 1vvgv3
  ]);

  /// `sticky-note-check.mjs`
  static const ElLucideGlyph
  stickyNoteCheck = ElLucideGlyph('sticky-note-check', <ElIconElement>[
    ElIconPathElement('m15 19 2 2 4-4'), // key: 1wqv71
    ElIconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
    ElIconPathElement(
      'M21 13V9a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 15 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h6.5',
    ), // key: 1onoss
  ]);

  /// `sticky-note-minus.mjs`
  static const ElLucideGlyph
  stickyNoteMinus = ElLucideGlyph('sticky-note-minus', <ElIconElement>[
    ElIconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
    ElIconPathElement(
      'M21 14V9a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 15 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h7.35',
    ), // key: g18rj4
    ElIconPathElement('M21 18h-6'), // key: 139f0c
  ]);

  /// `sticky-note-off.mjs`
  static const ElLucideGlyph
  stickyNoteOff = ElLucideGlyph('sticky-note-off', <ElIconElement>[
    ElIconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement(
      'M3.586 3.586A2 2 0 0 0 3 5v14a2 2 0 0 0 2 2h14a2 2 0 0 0 1.414-.586',
    ), // key: 12nghy
    ElIconPathElement(
      'M8.656 3H15a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 21 9v6.344',
    ), // key: 134c6x
  ]);

  /// `sticky-note-plus.mjs`
  static const ElLucideGlyph
  stickyNotePlus = ElLucideGlyph('sticky-note-plus', <ElIconElement>[
    ElIconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
    ElIconPathElement('M18 15v6'), // key: 9wciyi
    ElIconPathElement(
      'M21 12.356V9a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 15 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h7.355',
    ), // key: 12ish9
    ElIconPathElement('M21 18h-6'), // key: 139f0c
  ]);

  /// `sticky-note-x.mjs`
  static const ElLucideGlyph
  stickyNoteX = ElLucideGlyph('sticky-note-x', <ElIconElement>[
    ElIconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
    ElIconPathElement('m16 16 5 5'), // key: 8tpb07
    ElIconPathElement(
      'M21 12V9a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 15 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h7',
    ), // key: 156tez
    ElIconPathElement('m21 16-5 5'), // key: kplof2
  ]);

  /// `sticky-note.mjs`
  static const ElLucideGlyph
  stickyNote = ElLucideGlyph('sticky-note', <ElIconElement>[
    ElIconPathElement(
      'M21 9a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 15 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2z',
    ), // key: 1dfntj
    ElIconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
  ]);

  /// `sticky-notes.mjs`
  static const ElLucideGlyph
  stickyNotes = ElLucideGlyph('sticky-notes', <ElIconElement>[
    ElIconPathElement(
      'M10 8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 16 14v6a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V10a2 2 0 0 1 2-2z',
    ), // key: 19nc0g
    ElIconPathElement('M10 8v5a1 1 0 0 0 1 1h5'), // key: m3law1
    ElIconPathElement(
      'M8 4a2 2 0 0 1 2-2h6a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 22 8v6a2 2 0 0 1-2 2',
    ), // key: 1iu1qd
    ElIconPathElement('M16 2v5a1 1 0 0 0 1 1h5'), // key: af171p
  ]);

  /// `stone.mjs`
  static const ElLucideGlyph stone = ElLucideGlyph('stone', <ElIconElement>[
    ElIconPathElement(
      'M11.264 2.205A4 4 0 0 0 6.42 4.211l-4 8a4 4 0 0 0 1.359 5.117l6 4a4 4 0 0 0 4.438 0l6-4a4 4 0 0 0 1.576-4.592l-2-6a4 4 0 0 0-2.53-2.53z',
    ), // key: 1si4ox
    ElIconPathElement('M11.99 22 14 12l7.822 3.184'), // key: 1u8to0
    ElIconPathElement('M14 12 8.47 2.302'), // key: guo3d5
  ]);

  /// `store.mjs`
  static const ElLucideGlyph store = ElLucideGlyph('store', <ElIconElement>[
    ElIconPathElement(
      'M15 21v-5a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v5',
    ), // key: slp6dd
    ElIconPathElement(
      'M17.774 10.31a1.12 1.12 0 0 0-1.549 0 2.5 2.5 0 0 1-3.451 0 1.12 1.12 0 0 0-1.548 0 2.5 2.5 0 0 1-3.452 0 1.12 1.12 0 0 0-1.549 0 2.5 2.5 0 0 1-3.77-3.248l2.889-4.184A2 2 0 0 1 7 2h10a2 2 0 0 1 1.653.873l2.895 4.192a2.5 2.5 0 0 1-3.774 3.244',
    ), // key: o0xfot
    ElIconPathElement(
      'M4 10.95V19a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8.05',
    ), // key: wn3emo
  ]);

  /// `stretch-horizontal.mjs`
  static const ElLucideGlyph stretchHorizontal = ElLucideGlyph(
    'stretch-horizontal',
    <ElIconElement>[
      ElIconRectElement(2, 4, 20, 6, 2), // key: qdearl
      ElIconRectElement(2, 14, 20, 6, 2), // key: 1xrn6j
    ],
  );

  /// `stretch-vertical.mjs`
  static const ElLucideGlyph stretchVertical = ElLucideGlyph(
    'stretch-vertical',
    <ElIconElement>[
      ElIconRectElement(4, 2, 6, 20, 2), // key: 19qu7m
      ElIconRectElement(14, 2, 6, 20, 2), // key: 24v0nk
    ],
  );

  /// `strikethrough.mjs`
  static const ElLucideGlyph strikethrough = ElLucideGlyph(
    'strikethrough',
    <ElIconElement>[
      ElIconPathElement('M16 4H9a3 3 0 0 0-2.83 4'), // key: 43sutm
      ElIconPathElement('M14 12a4 4 0 0 1 0 8H6'), // key: nlfj13
      ElIconLineElement(4, 12, 20, 12), // key: 1e0a9i
    ],
  );

  /// `subscript.mjs`
  static const ElLucideGlyph
  subscript = ElLucideGlyph('subscript', <ElIconElement>[
    ElIconPathElement('m4 5 8 8'), // key: 1eunvl
    ElIconPathElement('m12 5-8 8'), // key: 1ah0jp
    ElIconPathElement(
      'M20 19h-4c0-1.5.44-2 1.5-2.5S20 15.33 20 14c0-.47-.17-.93-.48-1.29a2.11 2.11 0 0 0-2.62-.44c-.42.24-.74.62-.9 1.07',
    ), // key: e8ta8j
  ]);

  /// `summary.mjs`
  static const ElLucideGlyph summary = ElLucideGlyph('summary', <ElIconElement>[
    ElIconPathElement('M15 4H7'), // key: oyc4c8
    ElIconPathElement('m18 16 3 3-3 3'), // key: 1d4glt
    ElIconPathElement('M3 4v13a2 2 0 0 0 2 2h16'), // key: o3n0ii
    ElIconPathElement('M7 14h7'), // key: 16kgpy
    ElIconPathElement('M7 9h12'), // key: ihq7ma
  ]);

  /// `sun-dim.mjs`
  static const ElLucideGlyph sunDim = ElLucideGlyph('sun-dim', <ElIconElement>[
    ElIconCircleElement(12, 12, 4), // key: 4exip2
    ElIconPathElement('M12 4h.01'), // key: 1ujb9j
    ElIconPathElement('M20 12h.01'), // key: 1ykeid
    ElIconPathElement('M12 20h.01'), // key: zekei9
    ElIconPathElement('M4 12h.01'), // key: 158zrr
    ElIconPathElement('M17.657 6.343h.01'), // key: 31pqzk
    ElIconPathElement('M17.657 17.657h.01'), // key: jehnf4
    ElIconPathElement('M6.343 17.657h.01'), // key: gdk6ow
    ElIconPathElement('M6.343 6.343h.01'), // key: 1uurf0
  ]);

  /// `sun-medium.mjs`
  static const ElLucideGlyph sunMedium = ElLucideGlyph(
    'sun-medium',
    <ElIconElement>[
      ElIconCircleElement(12, 12, 4), // key: 4exip2
      ElIconPathElement('M12 3v1'), // key: 1asbbs
      ElIconPathElement('M12 20v1'), // key: 1wcdkc
      ElIconPathElement('M3 12h1'), // key: lp3yf2
      ElIconPathElement('M20 12h1'), // key: 1vloll
      ElIconPathElement('m18.364 5.636-.707.707'), // key: 1hakh0
      ElIconPathElement('m6.343 17.657-.707.707'), // key: 18m9nf
      ElIconPathElement('m5.636 5.636.707.707'), // key: 1xv1c5
      ElIconPathElement('m17.657 17.657.707.707'), // key: vl76zb
    ],
  );

  /// `sun-moon.mjs`
  static const ElLucideGlyph
  sunMoon = ElLucideGlyph('sun-moon', <ElIconElement>[
    ElIconPathElement('M12 2v2'), // key: tus03m
    ElIconPathElement(
      'M14.837 16.385a6 6 0 1 1-7.223-7.222c.624-.147.97.66.715 1.248a4 4 0 0 0 5.26 5.259c.589-.255 1.396.09 1.248.715',
    ), // key: xlf6rm
    ElIconPathElement('M16 12a4 4 0 0 0-4-4'), // key: 6vsxu
    ElIconPathElement('m19 5-1.256 1.256'), // key: 1yg6a6
    ElIconPathElement('M20 12h2'), // key: 1q8mjw
  ]);

  /// `sun-snow.mjs`
  static const ElLucideGlyph sunSnow = ElLucideGlyph(
    'sun-snow',
    <ElIconElement>[
      ElIconPathElement('M10 21v-1'), // key: 1u8rkd
      ElIconPathElement('M10 4V3'), // key: pkzwkn
      ElIconPathElement('M10 9a3 3 0 0 0 0 6'), // key: gv75dk
      ElIconPathElement('m14 20 1.25-2.5L18 18'), // key: 1chtki
      ElIconPathElement('m14 4 1.25 2.5L18 6'), // key: 1b4wsy
      ElIconPathElement('m17 21-3-6 1.5-3H22'), // key: o5qa3v
      ElIconPathElement('m17 3-3 6 1.5 3'), // key: 11697g
      ElIconPathElement('M2 12h1'), // key: 1uaihz
      ElIconPathElement('m20 10-1.5 2 1.5 2'), // key: 1swlpi
      ElIconPathElement('m3.64 18.36.7-.7'), // key: 105rm9
      ElIconPathElement('m4.34 6.34-.7-.7'), // key: d3unjp
    ],
  );

  /// `sun.mjs`
  static const ElLucideGlyph sun = ElLucideGlyph('sun', <ElIconElement>[
    ElIconCircleElement(12, 12, 4), // key: 4exip2
    ElIconPathElement('M12 2v2'), // key: tus03m
    ElIconPathElement('M12 20v2'), // key: 1lh1kg
    ElIconPathElement('m4.93 4.93 1.41 1.41'), // key: 149t6j
    ElIconPathElement('m17.66 17.66 1.41 1.41'), // key: ptbguv
    ElIconPathElement('M2 12h2'), // key: 1t8f8n
    ElIconPathElement('M20 12h2'), // key: 1q8mjw
    ElIconPathElement('m6.34 17.66-1.41 1.41'), // key: 1m8zz5
    ElIconPathElement('m19.07 4.93-1.41 1.41'), // key: 1shlcs
  ]);

  /// `sunrise.mjs`
  static const ElLucideGlyph sunrise = ElLucideGlyph('sunrise', <ElIconElement>[
    ElIconPathElement('M12 2v8'), // key: 1q4o3n
    ElIconPathElement('m4.93 10.93 1.41 1.41'), // key: 2a7f42
    ElIconPathElement('M2 18h2'), // key: j10viu
    ElIconPathElement('M20 18h2'), // key: wocana
    ElIconPathElement('m19.07 10.93-1.41 1.41'), // key: 15zs5n
    ElIconPathElement('M22 22H2'), // key: 19qnx5
    ElIconPathElement('m8 6 4-4 4 4'), // key: ybng9g
    ElIconPathElement('M16 18a4 4 0 0 0-8 0'), // key: 1lzouq
  ]);

  /// `sunset.mjs`
  static const ElLucideGlyph sunset = ElLucideGlyph('sunset', <ElIconElement>[
    ElIconPathElement('M12 10V2'), // key: 16sf7g
    ElIconPathElement('m4.93 10.93 1.41 1.41'), // key: 2a7f42
    ElIconPathElement('M2 18h2'), // key: j10viu
    ElIconPathElement('M20 18h2'), // key: wocana
    ElIconPathElement('m19.07 10.93-1.41 1.41'), // key: 15zs5n
    ElIconPathElement('M22 22H2'), // key: 19qnx5
    ElIconPathElement('m16 6-4 4-4-4'), // key: 6wukr
    ElIconPathElement('M16 18a4 4 0 0 0-8 0'), // key: 1lzouq
  ]);

  /// `superscript.mjs`
  static const ElLucideGlyph
  superscript = ElLucideGlyph('superscript', <ElIconElement>[
    ElIconPathElement('m4 19 8-8'), // key: hr47gm
    ElIconPathElement('m12 19-8-8'), // key: 1dhhmo
    ElIconPathElement(
      'M20 12h-4c0-1.5.442-2 1.5-2.5S20 8.334 20 7.002c0-.472-.17-.93-.484-1.29a2.105 2.105 0 0 0-2.617-.436c-.42.239-.738.614-.899 1.06',
    ), // key: 1dfcux
  ]);

  /// `swatch-book.mjs`
  static const ElLucideGlyph
  swatchBook = ElLucideGlyph('swatch-book', <ElIconElement>[
    ElIconPathElement(
      'M11 17a4 4 0 0 1-8 0V5a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2Z',
    ), // key: 1ldrpk
    ElIconPathElement(
      'M16.7 13H19a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2H7',
    ), // key: 11i5po
    ElIconPathElement('M 7 17h.01'), // key: 1euzgo
    ElIconPathElement(
      'm11 8 2.3-2.3a2.4 2.4 0 0 1 3.404.004L18.6 7.6a2.4 2.4 0 0 1 .026 3.434L9.9 19.8',
    ), // key: o2gii7
  ]);

  /// `swiss-franc.mjs`
  static const ElLucideGlyph swissFranc = ElLucideGlyph(
    'swiss-franc',
    <ElIconElement>[
      ElIconPathElement('M10 21V3h8'), // key: br2l0g
      ElIconPathElement('M6 16h9'), // key: 2py0wn
      ElIconPathElement('M10 9.5h7'), // key: 13dmhz
    ],
  );

  /// `switch-camera.mjs`
  static const ElLucideGlyph switchCamera = ElLucideGlyph(
    'switch-camera',
    <ElIconElement>[
      ElIconPathElement(
        'M11 19H4a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2h5',
      ), // key: mtk2lu
      ElIconPathElement(
        'M13 5h7a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-5',
      ), // key: 120jsl
      ElIconCircleElement(12, 12, 3), // key: 1v7zrd
      ElIconPathElement('m18 22-3-3 3-3'), // key: kgdoj7
      ElIconPathElement('m6 2 3 3-3 3'), // key: 1fnbkv
    ],
  );

  /// `sword.mjs`
  static const ElLucideGlyph sword = ElLucideGlyph('sword', <ElIconElement>[
    ElIconPathElement('m11 19-6-6'), // key: s7kpr
    ElIconPathElement('m5 21-2-2'), // key: 1kw20b
    ElIconPathElement('m8 16-4 4'), // key: 1oqv8h
    ElIconPathElement('M9.5 17.5 21 6V3h-3L6.5 14.5'), // key: pkxemp
  ]);

  /// `swords.mjs`
  static const ElLucideGlyph swords = ElLucideGlyph('swords', <ElIconElement>[
    ElIconPolylineElement(<Offset>[
      Offset(14.5, 17.5),
      Offset(3, 6),
      Offset(3, 3),
      Offset(6, 3),
      Offset(17.5, 14.5),
    ]), // key: 1hfsw2
    ElIconLineElement(13, 19, 19, 13), // key: 1vrmhu
    ElIconLineElement(16, 16, 20, 20), // key: 1bron3
    ElIconLineElement(19, 21, 21, 19), // key: 13pww6
    ElIconPolylineElement(<Offset>[
      Offset(14.5, 6.5),
      Offset(18, 3),
      Offset(21, 3),
      Offset(21, 6),
      Offset(17.5, 9.5),
    ]), // key: hbey2j
    ElIconLineElement(5, 14, 9, 18), // key: 1hf58s
    ElIconLineElement(7, 17, 4, 20), // key: pidxm4
    ElIconLineElement(3, 19, 5, 21), // key: 1pehsh
  ]);

  /// `syringe.mjs`
  static const ElLucideGlyph syringe = ElLucideGlyph('syringe', <ElIconElement>[
    ElIconPathElement('m18 2 4 4'), // key: 22kx64
    ElIconPathElement('m17 7 3-3'), // key: 1w1zoj
    ElIconPathElement(
      'M19 9 8.7 19.3c-1 1-2.5 1-3.4 0l-.6-.6c-1-1-1-2.5 0-3.4L15 5',
    ), // key: 1exhtz
    ElIconPathElement('m9 11 4 4'), // key: rovt3i
    ElIconPathElement('m5 19-3 3'), // key: 59f2uf
    ElIconPathElement('m14 4 6 6'), // key: yqp9t2
  ]);

  /// `table-2.mjs`
  static const ElLucideGlyph table2 = ElLucideGlyph('table-2', <ElIconElement>[
    ElIconPathElement(
      'M9 3H5a2 2 0 0 0-2 2v4m6-6h10a2 2 0 0 1 2 2v4M9 3v18m0 0h10a2 2 0 0 0 2-2V9M9 21H5a2 2 0 0 1-2-2V9m0 0h18',
    ), // key: gugj83
  ]);

  /// `table-cells-merge.mjs`
  static const ElLucideGlyph tableCellsMerge = ElLucideGlyph(
    'table-cells-merge',
    <ElIconElement>[
      ElIconPathElement('M12 21v-6'), // key: lihzve
      ElIconPathElement('M12 9V3'), // key: da5inc
      ElIconPathElement('M3 15h18'), // key: 5xshup
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    ],
  );

  /// `table-cells-split.mjs`
  static const ElLucideGlyph tableCellsSplit = ElLucideGlyph(
    'table-cells-split',
    <ElIconElement>[
      ElIconPathElement('M12 15V9'), // key: 8c7uyn
      ElIconPathElement('M3 15h18'), // key: 5xshup
      ElIconPathElement('M3 9h18'), // key: 1pudct
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    ],
  );

  /// `table-columns-split.mjs`
  static const ElLucideGlyph
  tableColumnsSplit = ElLucideGlyph('table-columns-split', <ElIconElement>[
    ElIconPathElement('M14 14v2'), // key: w2a1xv
    ElIconPathElement('M14 20v2'), // key: 1lq872
    ElIconPathElement('M14 2v2'), // key: 6buw04
    ElIconPathElement('M14 8v2'), // key: i67w9a
    ElIconPathElement('M2 15h8'), // key: 82wtch
    ElIconPathElement('M2 3h6a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H2'), // key: up0l64
    ElIconPathElement('M2 9h8'), // key: yelfik
    ElIconPathElement('M22 15h-4'), // key: 1es58f
    ElIconPathElement(
      'M22 3h-2a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h2',
    ), // key: pdjoqf
    ElIconPathElement('M22 9h-4'), // key: 1luja7
    ElIconPathElement('M5 3v18'), // key: 14hmio
  ]);

  /// `table-of-contents.mjs`
  static const ElLucideGlyph tableOfContents = ElLucideGlyph(
    'table-of-contents',
    <ElIconElement>[
      ElIconPathElement('M16 5H3'), // key: m91uny
      ElIconPathElement('M16 12H3'), // key: 1a2rj7
      ElIconPathElement('M16 19H3'), // key: zzsher
      ElIconPathElement('M21 5h.01'), // key: wa75ra
      ElIconPathElement('M21 12h.01'), // key: msek7k
      ElIconPathElement('M21 19h.01'), // key: qvbq2j
    ],
  );

  /// `table-properties.mjs`
  static const ElLucideGlyph tableProperties = ElLucideGlyph(
    'table-properties',
    <ElIconElement>[
      ElIconPathElement('M15 3v18'), // key: 14nvp0
      ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
      ElIconPathElement('M21 9H3'), // key: 1338ky
      ElIconPathElement('M21 15H3'), // key: 9uk58r
    ],
  );

  /// `table-rows-split.mjs`
  static const ElLucideGlyph tableRowsSplit = ElLucideGlyph(
    'table-rows-split',
    <ElIconElement>[
      ElIconPathElement('M14 10h2'), // key: 1lstlu
      ElIconPathElement('M15 22v-8'), // key: 1fwwgm
      ElIconPathElement('M15 2v4'), // key: 1044rn
      ElIconPathElement('M2 10h2'), // key: 1r8dkt
      ElIconPathElement('M20 10h2'), // key: 1ug425
      ElIconPathElement('M3 19h18'), // key: awlh7x
      ElIconPathElement(
        'M3 22v-6a2 2 135 0 1 2-2h14a2 2 45 0 1 2 2v6',
      ), // key: ibqhof
      ElIconPathElement(
        'M3 2v2a2 2 45 0 0 2 2h14a2 2 135 0 0 2-2V2',
      ), // key: 1uenja
      ElIconPathElement('M8 10h2'), // key: 66od0
      ElIconPathElement('M9 22v-8'), // key: fmnu31
      ElIconPathElement('M9 2v4'), // key: j1yeou
    ],
  );

  /// `table.mjs`
  static const ElLucideGlyph table = ElLucideGlyph('table', <ElIconElement>[
    ElIconPathElement('M12 3v18'), // key: 108xh3
    ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    ElIconPathElement('M3 9h18'), // key: 1pudct
    ElIconPathElement('M3 15h18'), // key: 5xshup
  ]);

  /// `tablet-smartphone.mjs`
  static const ElLucideGlyph tabletSmartphone = ElLucideGlyph(
    'tablet-smartphone',
    <ElIconElement>[
      ElIconRectElement(3, 8, 10, 14, 2), // key: 1vrsiq
      ElIconPathElement(
        'M5 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v16a2 2 0 0 1-2 2h-2.4',
      ), // key: 1j4zmg
      ElIconPathElement('M8 18h.01'), // key: lrp35t
    ],
  );

  /// `tablet.mjs`
  static const ElLucideGlyph tablet = ElLucideGlyph('tablet', <ElIconElement>[
    ElIconRectElement(4, 2, 16, 20, 2, ry: 2), // key: 76otgf
    ElIconLineElement(12, 18, 12.01, 18), // key: 1dp563
  ]);

  /// `tablets.mjs`
  static const ElLucideGlyph tablets = ElLucideGlyph('tablets', <ElIconElement>[
    ElIconCircleElement(7, 7, 5), // key: x29byf
    ElIconCircleElement(17, 17, 5), // key: 1op1d2
    ElIconPathElement('M12 17h10'), // key: ls21zv
    ElIconPathElement('m3.46 10.54 7.08-7.08'), // key: 1rehiu
  ]);

  /// `tag-plus.mjs`
  static const ElLucideGlyph
  tagPlus = ElLucideGlyph('tag-plus', <ElIconElement>[
    ElIconPathElement('M16 13h6'), // key: 1um0mj
    ElIconPathElement(
      'm16.5 6.5-3.914-3.914A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l1.79-1.79',
    ), // key: dp0yc9
    ElIconPathElement('M19 10v6'), // key: 13mz7b
    ElIconCircleElement(7.5, 7.5, 0.5, filled: true), // key: kqv944
  ]);

  /// `tag-x.mjs`
  static const ElLucideGlyph tagX = ElLucideGlyph('tag-x', <ElIconElement>[
    ElIconPathElement(
      'm16.5 6.5-3.914-3.914A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.43 2.43 0 0 0 3.42 0l1.79-1.79',
    ), // key: hu94c9
    ElIconPathElement('m16.5 10.5 5 5'), // key: 1jo8bf
    ElIconPathElement('m21.5 10.5-5 5'), // key: jzei60
    ElIconCircleElement(7.5, 7.5, 0.5, filled: true), // key: kqv944
  ]);

  /// `tag.mjs`
  static const ElLucideGlyph tag = ElLucideGlyph('tag', <ElIconElement>[
    ElIconPathElement(
      'M12.586 2.586A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l6.58-6.58a2.426 2.426 0 0 0 0-3.42z',
    ), // key: vktsd0
    ElIconCircleElement(7.5, 7.5, 0.5, filled: true), // key: kqv944
  ]);

  /// `tags.mjs`
  static const ElLucideGlyph tags = ElLucideGlyph('tags', <ElIconElement>[
    ElIconPathElement(
      'M13.172 2a2 2 0 0 1 1.414.586l6.71 6.71a2.4 2.4 0 0 1 0 3.408l-4.592 4.592a2.4 2.4 0 0 1-3.408 0l-6.71-6.71A2 2 0 0 1 6 9.172V3a1 1 0 0 1 1-1z',
    ), // key: 16rjxf
    ElIconPathElement(
      'M2 7v6.172a2 2 0 0 0 .586 1.414l6.71 6.71a2.4 2.4 0 0 0 3.191.193',
    ), // key: 178nd4
    ElIconCircleElement(10.5, 6.5, 0.5, filled: true), // key: 12ikhr
  ]);

  /// `tally-1.mjs`
  static const ElLucideGlyph tally1 = ElLucideGlyph('tally-1', <ElIconElement>[
    ElIconPathElement('M4 4v16'), // key: 6qkkli
  ]);

  /// `tally-2.mjs`
  static const ElLucideGlyph tally2 = ElLucideGlyph('tally-2', <ElIconElement>[
    ElIconPathElement('M4 4v16'), // key: 6qkkli
    ElIconPathElement('M9 4v16'), // key: 81ygyz
  ]);

  /// `tally-3.mjs`
  static const ElLucideGlyph tally3 = ElLucideGlyph('tally-3', <ElIconElement>[
    ElIconPathElement('M4 4v16'), // key: 6qkkli
    ElIconPathElement('M9 4v16'), // key: 81ygyz
    ElIconPathElement('M14 4v16'), // key: 12vmem
  ]);

  /// `tally-4.mjs`
  static const ElLucideGlyph tally4 = ElLucideGlyph('tally-4', <ElIconElement>[
    ElIconPathElement('M4 4v16'), // key: 6qkkli
    ElIconPathElement('M9 4v16'), // key: 81ygyz
    ElIconPathElement('M14 4v16'), // key: 12vmem
    ElIconPathElement('M19 4v16'), // key: 8ij5ei
  ]);

  /// `tally-5.mjs`
  static const ElLucideGlyph tally5 = ElLucideGlyph('tally-5', <ElIconElement>[
    ElIconPathElement('M4 4v16'), // key: 6qkkli
    ElIconPathElement('M9 4v16'), // key: 81ygyz
    ElIconPathElement('M14 4v16'), // key: 12vmem
    ElIconPathElement('M19 4v16'), // key: 8ij5ei
    ElIconPathElement('M22 6 2 18'), // key: h9moai
  ]);

  /// `tangent.mjs`
  static const ElLucideGlyph tangent = ElLucideGlyph('tangent', <ElIconElement>[
    ElIconCircleElement(17, 4, 2), // key: y5j2s2
    ElIconPathElement('M15.59 5.41 5.41 15.59'), // key: l0vprr
    ElIconCircleElement(4, 17, 2), // key: 9p4efm
    ElIconPathElement('M12 22s-4-9-1.5-11.5S22 12 22 12'), // key: 1twk4o
  ]);

  /// `target.mjs`
  static const ElLucideGlyph target = ElLucideGlyph('target', <ElIconElement>[
    ElIconCircleElement(12, 12, 10), // key: 1mglay
    ElIconCircleElement(12, 12, 6), // key: 1vlfrh
    ElIconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `telescope.mjs`
  static const ElLucideGlyph
  telescope = ElLucideGlyph('telescope', <ElIconElement>[
    ElIconPathElement(
      'm10.065 12.493-6.18 1.318a.934.934 0 0 1-1.108-.702l-.537-2.15a1.07 1.07 0 0 1 .691-1.265l13.504-4.44',
    ), // key: k4qptu
    ElIconPathElement('m13.56 11.747 4.332-.924'), // key: 19l80z
    ElIconPathElement('m16 21-3.105-6.21'), // key: 7oh9d
    ElIconPathElement(
      'M16.485 5.94a2 2 0 0 1 1.455-2.425l1.09-.272a1 1 0 0 1 1.212.727l1.515 6.06a1 1 0 0 1-.727 1.213l-1.09.272a2 2 0 0 1-2.425-1.455z',
    ), // key: m7xp4m
    ElIconPathElement('m6.158 8.633 1.114 4.456'), // key: 74o979
    ElIconPathElement('m8 21 3.105-6.21'), // key: 1fvxut
    ElIconCircleElement(12, 13, 2), // key: 1c1ljs
  ]);

  /// `tent-tree.mjs`
  static const ElLucideGlyph tentTree = ElLucideGlyph(
    'tent-tree',
    <ElIconElement>[
      ElIconCircleElement(4, 4, 2), // key: bt5ra8
      ElIconPathElement('m14 5 3-3 3 3'), // key: 1sorif
      ElIconPathElement('m14 10 3-3 3 3'), // key: 1jyi9h
      ElIconPathElement('M17 14V2'), // key: 8ymqnk
      ElIconPathElement('M17 14H7l-5 8h20Z'), // key: 13ar7p
      ElIconPathElement('M8 14v8'), // key: 1ghmqk
      ElIconPathElement('m9 14 5 8'), // key: 13pgi6
    ],
  );

  /// `tent.mjs`
  static const ElLucideGlyph tent = ElLucideGlyph('tent', <ElIconElement>[
    ElIconPathElement('M3.5 21 14 3'), // key: 1szst5
    ElIconPathElement('M20.5 21 10 3'), // key: 1310c3
    ElIconPathElement('M15.5 21 12 15l-3.5 6'), // key: 1ddtfw
    ElIconPathElement('M2 21h20'), // key: 1nyx9w
  ]);

  /// `terminal.mjs`
  static const ElLucideGlyph terminal = ElLucideGlyph(
    'terminal',
    <ElIconElement>[
      ElIconPathElement('M12 19h8'), // key: baeox8
      ElIconPathElement('m4 17 6-6-6-6'), // key: 1yngyt
    ],
  );

  /// `test-tube-diagonal.mjs`
  static const ElLucideGlyph testTubeDiagonal = ElLucideGlyph(
    'test-tube-diagonal',
    <ElIconElement>[
      ElIconPathElement(
        'M21 7 6.82 21.18a2.83 2.83 0 0 1-3.99-.01a2.83 2.83 0 0 1 0-4L17 3',
      ), // key: 1ub6xw
      ElIconPathElement('m16 2 6 6'), // key: 1gw87d
      ElIconPathElement('M12 16H4'), // key: 1cjfip
    ],
  );

  /// `test-tube.mjs`
  static const ElLucideGlyph testTube = ElLucideGlyph(
    'test-tube',
    <ElIconElement>[
      ElIconPathElement(
        'M14.5 2v17.5c0 1.4-1.1 2.5-2.5 2.5c-1.4 0-2.5-1.1-2.5-2.5V2',
      ), // key: 125lnx
      ElIconPathElement('M8.5 2h7'), // key: csnxdl
      ElIconPathElement('M14.5 16h-5'), // key: 1ox875
    ],
  );

  /// `test-tubes.mjs`
  static const ElLucideGlyph testTubes = ElLucideGlyph(
    'test-tubes',
    <ElIconElement>[
      ElIconPathElement(
        'M9 2v17.5A2.5 2.5 0 0 1 6.5 22A2.5 2.5 0 0 1 4 19.5V2',
      ), // key: 1hjrqt
      ElIconPathElement(
        'M20 2v17.5a2.5 2.5 0 0 1-2.5 2.5a2.5 2.5 0 0 1-2.5-2.5V2',
      ), // key: 16lc8n
      ElIconPathElement('M3 2h7'), // key: 7s29d5
      ElIconPathElement('M14 2h7'), // key: 7sicin
      ElIconPathElement('M9 16H4'), // key: 1bfye3
      ElIconPathElement('M20 16h-5'), // key: ddnjpe
    ],
  );

  /// `text-align-center.mjs`
  static const ElLucideGlyph textAlignCenter = ElLucideGlyph(
    'text-align-center',
    <ElIconElement>[
      ElIconPathElement('M21 5H3'), // key: 1fi0y6
      ElIconPathElement('M17 12H7'), // key: 16if0g
      ElIconPathElement('M19 19H5'), // key: vjpgq2
    ],
  );

  /// `text-align-end.mjs`
  static const ElLucideGlyph textAlignEnd = ElLucideGlyph(
    'text-align-end',
    <ElIconElement>[
      ElIconPathElement('M21 5H3'), // key: 1fi0y6
      ElIconPathElement('M21 12H9'), // key: dn1m92
      ElIconPathElement('M21 19H7'), // key: 4cu937
    ],
  );

  /// `text-align-justify.mjs`
  static const ElLucideGlyph textAlignJustify = ElLucideGlyph(
    'text-align-justify',
    <ElIconElement>[
      ElIconPathElement('M3 5h18'), // key: 1u36vt
      ElIconPathElement('M3 12h18'), // key: 1i2n21
      ElIconPathElement('M3 19h18'), // key: awlh7x
    ],
  );

  /// `text-align-start.mjs`
  static const ElLucideGlyph textAlignStart = ElLucideGlyph(
    'text-align-start',
    <ElIconElement>[
      ElIconPathElement('M21 5H3'), // key: 1fi0y6
      ElIconPathElement('M15 12H3'), // key: 6jk70r
      ElIconPathElement('M17 19H3'), // key: z6ezky
    ],
  );

  /// `text-cursor-input.mjs`
  static const ElLucideGlyph
  textCursorInput = ElLucideGlyph('text-cursor-input', <ElIconElement>[
    ElIconPathElement('M12 20h-1a2 2 0 0 1-2-2 2 2 0 0 1-2 2H6'), // key: 1528k5
    ElIconPathElement(
      'M13 8h7a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2h-7',
    ), // key: 13ksps
    ElIconPathElement(
      'M5 16H4a2 2 0 0 1-2-2v-4a2 2 0 0 1 2-2h1',
    ), // key: 1n9rhb
    ElIconPathElement('M6 4h1a2 2 0 0 1 2 2 2 2 0 0 1 2-2h1'), // key: 1mj8rg
    ElIconPathElement('M9 6v12'), // key: velyjx
  ]);

  /// `text-cursor.mjs`
  static const ElLucideGlyph textCursor = ElLucideGlyph(
    'text-cursor',
    <ElIconElement>[
      ElIconPathElement(
        'M17 22h-1a4 4 0 0 1-4-4V6a4 4 0 0 1 4-4h1',
      ), // key: uvaxm9
      ElIconPathElement('M7 22h1a4 4 0 0 0 4-4'), // key: 1l7xii
      ElIconPathElement('M7 2h1a4 4 0 0 1 4 4'), // key: 1vrvvh
    ],
  );

  /// `text-initial.mjs`
  static const ElLucideGlyph textInitial = ElLucideGlyph(
    'text-initial',
    <ElIconElement>[
      ElIconPathElement('M15 5h6'), // key: 1pr8yx
      ElIconPathElement('M15 12h6'), // key: upa0zy
      ElIconPathElement('M3 19h18'), // key: awlh7x
      ElIconPathElement(
        'm3 12 3.553-7.724a.5.5 0 0 1 .894 0L11 12',
      ), // key: 6lvno8
      ElIconPathElement('M3.92 10h6.16'), // key: 1tl8ex
    ],
  );

  /// `text-quote.mjs`
  static const ElLucideGlyph textQuote = ElLucideGlyph(
    'text-quote',
    <ElIconElement>[
      ElIconPathElement('M17 5H3'), // key: 1cn7zz
      ElIconPathElement('M21 12H8'), // key: scolzb
      ElIconPathElement('M21 19H8'), // key: 13qgcb
      ElIconPathElement('M3 12v7'), // key: 1ri8j3
    ],
  );

  /// `text-search.mjs`
  static const ElLucideGlyph textSearch = ElLucideGlyph(
    'text-search',
    <ElIconElement>[
      ElIconPathElement('M21 5H3'), // key: 1fi0y6
      ElIconPathElement('M10 12H3'), // key: 1ulcyk
      ElIconPathElement('M10 19H3'), // key: 108z41
      ElIconCircleElement(17, 15, 3), // key: 1upz2a
      ElIconPathElement('m21 19-1.9-1.9'), // key: dwi7p8
    ],
  );

  /// `text-wrap.mjs`
  static const ElLucideGlyph textWrap = ElLucideGlyph(
    'text-wrap',
    <ElIconElement>[
      ElIconPathElement('m16 16-3 3 3 3'), // key: 117b85
      ElIconPathElement('M3 12h14.5a1 1 0 0 1 0 7H13'), // key: 18xa6z
      ElIconPathElement('M3 19h6'), // key: 1ygdsz
      ElIconPathElement('M3 5h18'), // key: 1u36vt
    ],
  );

  /// `theater.mjs`
  static const ElLucideGlyph theater = ElLucideGlyph('theater', <ElIconElement>[
    ElIconPathElement('M2 10s3-3 3-8'), // key: 3xiif0
    ElIconPathElement('M22 10s-3-3-3-8'), // key: ioaa5q
    ElIconPathElement('M10 2c0 4.4-3.6 8-8 8'), // key: 16fkpi
    ElIconPathElement('M14 2c0 4.4 3.6 8 8 8'), // key: b9eulq
    ElIconPathElement('M2 10s2 2 2 5'), // key: 1au1lb
    ElIconPathElement('M22 10s-2 2-2 5'), // key: qi2y5e
    ElIconPathElement('M8 15h8'), // key: 45n4r
    ElIconPathElement(
      'M2 22v-1a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v1',
    ), // key: 1vsc2m
    ElIconPathElement(
      'M14 22v-1a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v1',
    ), // key: hrha4u
  ]);

  /// `thermometer-snowflake.mjs`
  static const ElLucideGlyph thermometerSnowflake = ElLucideGlyph(
    'thermometer-snowflake',
    <ElIconElement>[
      ElIconPathElement('m10 20-1.25-2.5L6 18'), // key: 18frcb
      ElIconPathElement('M10 4 8.75 6.5 6 6'), // key: 7mghy3
      ElIconPathElement('M10.585 15H10'), // key: 4nqulp
      ElIconPathElement('M2 12h6.5L10 9'), // key: kv9z4n
      ElIconPathElement(
        'M20 14.54a4 4 0 1 1-4 0V4a2 2 0 0 1 4 0z',
      ), // key: yu0u2z
      ElIconPathElement('m4 10 1.5 2L4 14'), // key: k9enpj
      ElIconPathElement('m7 21 3-6-1.5-3'), // key: j8hb9u
      ElIconPathElement('m7 3 3 6h2'), // key: 1bbqgq
    ],
  );

  /// `thermometer-sun.mjs`
  static const ElLucideGlyph thermometerSun = ElLucideGlyph(
    'thermometer-sun',
    <ElIconElement>[
      ElIconPathElement('M12 2v2'), // key: tus03m
      ElIconPathElement('M12 8a4 4 0 0 0-1.645 7.647'), // key: wz5p04
      ElIconPathElement('M2 12h2'), // key: 1t8f8n
      ElIconPathElement(
        'M20 14.54a4 4 0 1 1-4 0V4a2 2 0 0 1 4 0z',
      ), // key: yu0u2z
      ElIconPathElement('m4.93 4.93 1.41 1.41'), // key: 149t6j
      ElIconPathElement('m6.34 17.66-1.41 1.41'), // key: 1m8zz5
    ],
  );

  /// `thermometer.mjs`
  static const ElLucideGlyph thermometer = ElLucideGlyph(
    'thermometer',
    <ElIconElement>[
      ElIconPathElement(
        'M14 4v10.54a4 4 0 1 1-4 0V4a2 2 0 0 1 4 0Z',
      ), // key: 17jzev
    ],
  );

  /// `thumbs-down.mjs`
  static const ElLucideGlyph
  thumbsDown = ElLucideGlyph('thumbs-down', <ElIconElement>[
    ElIconPathElement(
      'M9 18.12 10 14H4.17a2 2 0 0 1-1.92-2.56l2.33-8A2 2 0 0 1 6.5 2H20a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-2.76a2 2 0 0 0-1.79 1.11L12 22a3.13 3.13 0 0 1-3-3.88Z',
    ), // key: m61m77
    ElIconPathElement('M17 14V2'), // key: 8ymqnk
  ]);

  /// `thumbs-up.mjs`
  static const ElLucideGlyph
  thumbsUp = ElLucideGlyph('thumbs-up', <ElIconElement>[
    ElIconPathElement(
      'M15 5.88 14 10h5.83a2 2 0 0 1 1.92 2.56l-2.33 8A2 2 0 0 1 17.5 22H4a2 2 0 0 1-2-2v-8a2 2 0 0 1 2-2h2.76a2 2 0 0 0 1.79-1.11L12 2a3.13 3.13 0 0 1 3 3.88Z',
    ), // key: emmmcr
    ElIconPathElement('M7 10v12'), // key: 1qc93n
  ]);

  /// `ticket-check.mjs`
  static const ElLucideGlyph
  ticketCheck = ElLucideGlyph('ticket-check', <ElIconElement>[
    ElIconPathElement(
      'M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z',
    ), // key: qn84l0
    ElIconPathElement('m9 12 2 2 4-4'), // key: dzmm74
  ]);

  /// `ticket-minus.mjs`
  static const ElLucideGlyph
  ticketMinus = ElLucideGlyph('ticket-minus', <ElIconElement>[
    ElIconPathElement(
      'M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z',
    ), // key: qn84l0
    ElIconPathElement('M9 12h6'), // key: 1c52cq
  ]);

  /// `ticket-percent.mjs`
  static const ElLucideGlyph
  ticketPercent = ElLucideGlyph('ticket-percent', <ElIconElement>[
    ElIconPathElement(
      'M2 9a3 3 0 1 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 1 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z',
    ), // key: 1l48ns
    ElIconPathElement('M9 9h.01'), // key: 1q5me6
    ElIconPathElement('m15 9-6 6'), // key: 1uzhvr
    ElIconPathElement('M15 15h.01'), // key: lqbp3k
  ]);

  /// `ticket-plus.mjs`
  static const ElLucideGlyph
  ticketPlus = ElLucideGlyph('ticket-plus', <ElIconElement>[
    ElIconPathElement(
      'M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z',
    ), // key: qn84l0
    ElIconPathElement('M9 12h6'), // key: 1c52cq
    ElIconPathElement('M12 9v6'), // key: 199k2o
  ]);

  /// `ticket-slash.mjs`
  static const ElLucideGlyph
  ticketSlash = ElLucideGlyph('ticket-slash', <ElIconElement>[
    ElIconPathElement(
      'M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z',
    ), // key: qn84l0
    ElIconPathElement('m9.5 14.5 5-5'), // key: qviqfa
  ]);

  /// `ticket-x.mjs`
  static const ElLucideGlyph
  ticketX = ElLucideGlyph('ticket-x', <ElIconElement>[
    ElIconPathElement(
      'M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z',
    ), // key: qn84l0
    ElIconPathElement('m9.5 14.5 5-5'), // key: qviqfa
    ElIconPathElement('m9.5 9.5 5 5'), // key: 18nt4w
  ]);

  /// `ticket.mjs`
  static const ElLucideGlyph ticket = ElLucideGlyph('ticket', <ElIconElement>[
    ElIconPathElement(
      'M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z',
    ), // key: qn84l0
    ElIconPathElement('M13 5v2'), // key: dyzc3o
    ElIconPathElement('M13 17v2'), // key: 1ont0d
    ElIconPathElement('M13 11v2'), // key: 1wjjxi
  ]);

  /// `tickets-plane.mjs`
  static const ElLucideGlyph ticketsPlane = ElLucideGlyph(
    'tickets-plane',
    <ElIconElement>[
      ElIconPathElement(
        'M10.5 17h1.227a2 2 0 0 0 1.345-.52L18 12',
      ), // key: 16muxl
      ElIconPathElement('m12 13.5 3.794.506'), // key: 6v5z87
      ElIconPathElement(
        'm3.173 8.18 11-5a2 2 0 0 1 2.647.993L18.56 8',
      ), // key: 15hfpj
      ElIconPathElement('M6 10V8'), // key: 1y41hn
      ElIconPathElement('M6 14v1'), // key: cao2tf
      ElIconPathElement('M6 19v2'), // key: 1loha6
      ElIconRectElement(2, 8, 20, 13, 2), // key: p3bz5l
    ],
  );

  /// `tickets.mjs`
  static const ElLucideGlyph tickets = ElLucideGlyph('tickets', <ElIconElement>[
    ElIconPathElement(
      'm3.173 8.18 11-5a2 2 0 0 1 2.647.993L18.56 8',
    ), // key: 15hfpj
    ElIconPathElement('M6 10V8'), // key: 1y41hn
    ElIconPathElement('M6 14v1'), // key: cao2tf
    ElIconPathElement('M6 19v2'), // key: 1loha6
    ElIconRectElement(2, 8, 20, 13, 2), // key: p3bz5l
  ]);

  /// `timeline.mjs`
  static const ElLucideGlyph
  timeline = ElLucideGlyph('timeline', <ElIconElement>[
    ElIconPathElement('M4 12h.01'), // key: 158zrr
    ElIconPathElement('M4 16h.01'), // key: jrnfb7
    ElIconPathElement('M4 20h.01'), // key: orx0iu
    ElIconPathElement('M4 4h.01'), // key: cieki8
    ElIconPathElement('M4 8h.01'), // key: 43g258
    ElIconPathElement(
      'M9.414 13.414a2 2 0 0 0 1.414.586H19a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1h-8.172a2 2 0 0 0-1.414.586L8 12z',
    ), // key: 1pvxkf
    ElIconPathElement(
      'M9.414 21.414a2 2 0 0 0 1.414.586H19a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1h-8.172a2 2 0 0 0-1.414.586L8 20z',
    ), // key: 1k13gh
    ElIconPathElement(
      'M9.414 5.414A2 2 0 0 0 10.828 6H19a1 1 0 0 0 1-1V3a1 1 0 0 0-1-1h-8.172a2 2 0 0 0-1.414.586L8 4z',
    ), // key: 12x0hd
  ]);

  /// `timer-off.mjs`
  static const ElLucideGlyph timerOff = ElLucideGlyph(
    'timer-off',
    <ElIconElement>[
      ElIconPathElement('M10 2h4'), // key: n1abiw
      ElIconPathElement(
        'M4.6 11a8 8 0 0 0 1.7 8.7 8 8 0 0 0 8.7 1.7',
      ), // key: 10he05
      ElIconPathElement(
        'M7.4 7.4a8 8 0 0 1 10.3 1 8 8 0 0 1 .9 10.2',
      ), // key: 15f7sh
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
      ElIconPathElement('M12 12v-2'), // key: fwoke6
    ],
  );

  /// `timer-reset.mjs`
  static const ElLucideGlyph timerReset = ElLucideGlyph(
    'timer-reset',
    <ElIconElement>[
      ElIconPathElement('M10 2h4'), // key: n1abiw
      ElIconPathElement('M12 14v-4'), // key: 1evpnu
      ElIconPathElement(
        'M4 13a8 8 0 0 1 8-7 8 8 0 1 1-5.3 14L4 17.6',
      ), // key: 1ts96g
      ElIconPathElement('M9 17H4v5'), // key: 8t5av
    ],
  );

  /// `timer.mjs`
  static const ElLucideGlyph timer = ElLucideGlyph('timer', <ElIconElement>[
    ElIconLineElement(10, 2, 14, 2), // key: 14vaq8
    ElIconLineElement(12, 14, 15, 11), // key: 17fdiu
    ElIconCircleElement(12, 14, 8), // key: 1e1u0o
  ]);

  /// `toggle-left.mjs`
  static const ElLucideGlyph toggleLeft = ElLucideGlyph(
    'toggle-left',
    <ElIconElement>[
      ElIconCircleElement(9, 12, 3), // key: u3jwor
      ElIconRectElement(2, 5, 20, 14, 7), // key: g7kal2
    ],
  );

  /// `toggle-right.mjs`
  static const ElLucideGlyph toggleRight = ElLucideGlyph(
    'toggle-right',
    <ElIconElement>[
      ElIconCircleElement(15, 12, 3), // key: 1afu0r
      ElIconRectElement(2, 5, 20, 14, 7), // key: g7kal2
    ],
  );

  /// `toilet.mjs`
  static const ElLucideGlyph toilet = ElLucideGlyph('toilet', <ElIconElement>[
    ElIconPathElement(
      'M7 12h13a1 1 0 0 1 1 1 5 5 0 0 1-5 5h-.598a.5.5 0 0 0-.424.765l1.544 2.47a.5.5 0 0 1-.424.765H5.402a.5.5 0 0 1-.424-.765L7 18',
    ), // key: kc4kqr
    ElIconPathElement(
      'M8 18a5 5 0 0 1-5-5V4a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v8',
    ), // key: 1tqs57
  ]);

  /// `tool-case.mjs`
  static const ElLucideGlyph
  toolCase = ElLucideGlyph('tool-case', <ElIconElement>[
    ElIconPathElement('M10 15h4'), // key: 192ueg
    ElIconPathElement(
      'm14.817 10.995-.971-1.45 1.034-1.232a2 2 0 0 0-2.025-3.238l-1.82.364L9.91 3.885a2 2 0 0 0-3.625.748L6.141 6.55l-1.725.426a2 2 0 0 0-.19 3.756l.657.27',
    ), // key: xbnumr
    ElIconPathElement(
      'm18.822 10.995 2.26-5.38a1 1 0 0 0-.557-1.318L16.954 2.9a1 1 0 0 0-1.281.533l-.924 2.122',
    ), // key: eaw7gc
    ElIconPathElement(
      'M4 12.006A1 1 0 0 1 4.994 11H19a1 1 0 0 1 1 1v7a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2z',
    ), // key: 1vaooh
  ]);

  /// `toolbox.mjs`
  static const ElLucideGlyph toolbox = ElLucideGlyph('toolbox', <ElIconElement>[
    ElIconPathElement('M16 12v4'), // key: vf1vip
    ElIconPathElement('M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2'), // key: llnzfg
    ElIconPathElement(
      'M17 6a2 2 0 011.414.586l3 3A2 2 0 0122 11v8a2 2 0 01-2 2H4a2 2 0 01-2-2v-8a2 2 0 01.586-1.414l3-3A2 2 0 017 6z',
    ), // key: 1hprxj
    ElIconPathElement('M2 14h20'), // key: myj16y
    ElIconPathElement('M8 12v4'), // key: 1w4uao
  ]);

  /// `tornado.mjs`
  static const ElLucideGlyph tornado = ElLucideGlyph('tornado', <ElIconElement>[
    ElIconPathElement('M21 4H3'), // key: 1hwok0
    ElIconPathElement('M18 8H6'), // key: 41n648
    ElIconPathElement('M19 12H9'), // key: 1g4lpz
    ElIconPathElement('M16 16h-6'), // key: 1j5d54
    ElIconPathElement('M11 20H9'), // key: 39obr8
  ]);

  /// `torus.mjs`
  static const ElLucideGlyph torus = ElLucideGlyph('torus', <ElIconElement>[
    ElIconEllipseElement(12, 11, 3, 2), // key: 1b2qxu
    ElIconEllipseElement(12, 12.5, 10, 8.5), // key: h8emeu
  ]);

  /// `touchpad-off.mjs`
  static const ElLucideGlyph
  touchpadOff = ElLucideGlyph('touchpad-off', <ElIconElement>[
    ElIconPathElement('M12 20v-6'), // key: 1rm09r
    ElIconPathElement('M19.656 14H22'), // key: 170xzr
    ElIconPathElement('M2 14h12'), // key: d8icqz
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement('M20 20H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2'), // key: s23sx2
    ElIconPathElement('M9.656 4H20a2 2 0 0 1 2 2v10.344'), // key: ovjcvl
  ]);

  /// `touchpad.mjs`
  static const ElLucideGlyph touchpad = ElLucideGlyph(
    'touchpad',
    <ElIconElement>[
      ElIconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
      ElIconPathElement('M2 14h20'), // key: myj16y
      ElIconPathElement('M12 20v-6'), // key: 1rm09r
    ],
  );

  /// `towel-rack.mjs`
  static const ElLucideGlyph
  towelRack = ElLucideGlyph('towel-rack', <ElIconElement>[
    ElIconPathElement('M22 7h-2'), // key: 1okbx2
    ElIconPathElement(
      'M6.5 3h11A2.5 2.5 0 0 1 20 5.5V20a1 1 0 0 1-1 1h-9a1 1 0 0 1-1-1V5.5a1 1 0 0 0-5 0V17a1 1 0 0 0 1 1h4',
    ), // key: kc32tg
    ElIconPathElement('M9 7H2'), // key: ahf7b7
  ]);

  /// `tower-control.mjs`
  static const ElLucideGlyph towerControl = ElLucideGlyph(
    'tower-control',
    <ElIconElement>[
      ElIconPathElement(
        'M18.2 12.27 20 6H4l1.8 6.27a1 1 0 0 0 .95.73h10.5a1 1 0 0 0 .96-.73Z',
      ), // key: 1pledb
      ElIconPathElement('M8 13v9'), // key: hmv0ci
      ElIconPathElement('M16 22v-9'), // key: ylnf1u
      ElIconPathElement('m9 6 1 7'), // key: dpdgam
      ElIconPathElement('m15 6-1 7'), // key: ls7zgu
      ElIconPathElement('M12 6V2'), // key: 1pj48d
      ElIconPathElement('M13 2h-2'), // key: mj6ths
    ],
  );

  /// `toy-brick.mjs`
  static const ElLucideGlyph
  toyBrick = ElLucideGlyph('toy-brick', <ElIconElement>[
    ElIconRectElement(3, 8, 18, 12, 1), // key: 158fvp
    ElIconPathElement('M10 8V5c0-.6-.4-1-1-1H6a1 1 0 0 0-1 1v3'), // key: s0042v
    ElIconPathElement(
      'M19 8V5c0-.6-.4-1-1-1h-3a1 1 0 0 0-1 1v3',
    ), // key: 9wmeh2
  ]);

  /// `tractor.mjs`
  static const ElLucideGlyph tractor = ElLucideGlyph('tractor', <ElIconElement>[
    ElIconPathElement(
      'm10 11 11 .9a1 1 0 0 1 .8 1.1l-.665 4.158a1 1 0 0 1-.988.842H20',
    ), // key: she1j9
    ElIconPathElement('M16 18h-5'), // key: bq60fd
    ElIconPathElement('M18 5a1 1 0 0 0-1 1v5.573'), // key: 1kv8ia
    ElIconPathElement('M3 4h8.129a1 1 0 0 1 .99.863L13 11.246'), // key: 1q1ert
    ElIconPathElement('M4 11V4'), // key: 9ft8pt
    ElIconPathElement('M7 15h.01'), // key: k5ht0j
    ElIconPathElement('M8 10.1V4'), // key: 1jgyzo
    ElIconCircleElement(18, 18, 2), // key: 1emm8v
    ElIconCircleElement(7, 15, 5), // key: ddtuc
  ]);

  /// `traffic-cone.mjs`
  static const ElLucideGlyph
  trafficCone = ElLucideGlyph('traffic-cone', <ElIconElement>[
    ElIconPathElement('M16.05 10.966a5 2.5 0 0 1-8.1 0'), // key: m5jpwb
    ElIconPathElement(
      'm16.923 14.049 4.48 2.04a1 1 0 0 1 .001 1.831l-8.574 3.9a2 2 0 0 1-1.66 0l-8.574-3.91a1 1 0 0 1 0-1.83l4.484-2.04',
    ), // key: rbg3g8
    ElIconPathElement(
      'M16.949 14.14a5 2.5 0 1 1-9.9 0L10.063 3.5a2 2 0 0 1 3.874 0z',
    ), // key: vap8c8
    ElIconPathElement('M9.194 6.57a5 2.5 0 0 0 5.61 0'), // key: 15hn5c
  ]);

  /// `train-front-tunnel.mjs`
  static const ElLucideGlyph trainFrontTunnel = ElLucideGlyph(
    'train-front-tunnel',
    <ElIconElement>[
      ElIconPathElement('M2 22V12a10 10 0 1 1 20 0v10'), // key: o0fyp0
      ElIconPathElement('M15 6.8v1.4a3 2.8 0 1 1-6 0V6.8'), // key: m8q3n9
      ElIconPathElement('M10 15h.01'), // key: 44in9x
      ElIconPathElement('M14 15h.01'), // key: 5mohn5
      ElIconPathElement(
        'M10 19a4 4 0 0 1-4-4v-3a6 6 0 1 1 12 0v3a4 4 0 0 1-4 4Z',
      ), // key: hckbmu
      ElIconPathElement('m9 19-2 3'), // key: iij7hm
      ElIconPathElement('m15 19 2 3'), // key: npx8sa
    ],
  );

  /// `train-front.mjs`
  static const ElLucideGlyph trainFront = ElLucideGlyph(
    'train-front',
    <ElIconElement>[
      ElIconPathElement('M8 3.1V7a4 4 0 0 0 8 0V3.1'), // key: 1v71zp
      ElIconPathElement('m9 15-1-1'), // key: 1yrq24
      ElIconPathElement('m15 15 1-1'), // key: 1t0d6s
      ElIconPathElement(
        'M9 19c-2.8 0-5-2.2-5-5v-4a8 8 0 0 1 16 0v4c0 2.8-2.2 5-5 5Z',
      ), // key: 1p0hjs
      ElIconPathElement('m8 19-2 3'), // key: 13i0xs
      ElIconPathElement('m16 19 2 3'), // key: xo31yx
    ],
  );

  /// `train-track.mjs`
  static const ElLucideGlyph trainTrack = ElLucideGlyph(
    'train-track',
    <ElIconElement>[
      ElIconPathElement('M2 17 17 2'), // key: 18b09t
      ElIconPathElement('m2 14 8 8'), // key: 1gv9hu
      ElIconPathElement('m5 11 8 8'), // key: 189pqp
      ElIconPathElement('m8 8 8 8'), // key: 1imecy
      ElIconPathElement('m11 5 8 8'), // key: ummqn6
      ElIconPathElement('m14 2 8 8'), // key: 1vk7dn
      ElIconPathElement('M7 22 22 7'), // key: 15mb1i
    ],
  );

  /// `tram-front.mjs`
  static const ElLucideGlyph tramFront = ElLucideGlyph(
    'tram-front',
    <ElIconElement>[
      ElIconRectElement(4, 3, 16, 16, 2), // key: 1wxw4b
      ElIconPathElement('M4 11h16'), // key: mpoxn0
      ElIconPathElement('M12 3v8'), // key: 1h2ygw
      ElIconPathElement('m8 19-2 3'), // key: 13i0xs
      ElIconPathElement('m18 22-2-3'), // key: 1p0ohu
      ElIconPathElement('M8 15h.01'), // key: a7atzg
      ElIconPathElement('M16 15h.01'), // key: rnfrdf
    ],
  );

  /// `transgender.mjs`
  static const ElLucideGlyph transgender = ElLucideGlyph(
    'transgender',
    <ElIconElement>[
      ElIconPathElement('M12 16v6'), // key: c8a4gj
      ElIconPathElement('M14 20h-4'), // key: m8m19d
      ElIconPathElement('M18 2h4v4'), // key: 1341mj
      ElIconPathElement('m2 2 7.17 7.17'), // key: 13q8l2
      ElIconPathElement('M2 5.355V2h3.357'), // key: 18136r
      ElIconPathElement('m22 2-7.17 7.17'), // key: 1epvy4
      ElIconPathElement('M8 5 5 8'), // key: mgbjhz
      ElIconCircleElement(12, 12, 4), // key: 4exip2
    ],
  );

  /// `trash-2.mjs`
  static const ElLucideGlyph trash2 = ElLucideGlyph('trash-2', <ElIconElement>[
    ElIconPathElement('M10 11v6'), // key: nco0om
    ElIconPathElement('M14 11v6'), // key: outv1u
    ElIconPathElement(
      'M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6',
    ), // key: miytrc
    ElIconPathElement('M3 6h18'), // key: d0wm0j
    ElIconPathElement('M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2'), // key: e791ji
  ]);

  /// `trash.mjs`
  static const ElLucideGlyph trash = ElLucideGlyph('trash', <ElIconElement>[
    ElIconPathElement(
      'M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6',
    ), // key: miytrc
    ElIconPathElement('M3 6h18'), // key: d0wm0j
    ElIconPathElement('M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2'), // key: e791ji
  ]);

  /// `tree-deciduous.mjs`
  static const ElLucideGlyph
  treeDeciduous = ElLucideGlyph('tree-deciduous', <ElIconElement>[
    ElIconPathElement(
      'M8 19a4 4 0 0 1-2.24-7.32A3.5 3.5 0 0 1 9 6.03V6a3 3 0 1 1 6 0v.04a3.5 3.5 0 0 1 3.24 5.65A4 4 0 0 1 16 19Z',
    ), // key: oadzkq
    ElIconPathElement('M12 19v3'), // key: npa21l
  ]);

  /// `tree-palm.mjs`
  static const ElLucideGlyph
  treePalm = ElLucideGlyph('tree-palm', <ElIconElement>[
    ElIconPathElement(
      'M13 8c0-2.76-2.46-5-5.5-5S2 5.24 2 8h2l1-1 1 1h4',
    ), // key: foxbe7
    ElIconPathElement(
      'M13 7.14A5.82 5.82 0 0 1 16.5 6c3.04 0 5.5 2.24 5.5 5h-3l-1-1-1 1h-3',
    ), // key: 18arnh
    ElIconPathElement(
      'M5.89 9.71c-2.15 2.15-2.3 5.47-.35 7.43l4.24-4.25.7-.7.71-.71 2.12-2.12c-1.95-1.96-5.27-1.8-7.42.35',
    ), // key: ywahnh
    ElIconPathElement(
      'M11 15.5c.5 2.5-.17 4.5-1 6.5h4c2-5.5-.5-12-1-14',
    ), // key: ft0feo
  ]);

  /// `tree-pine.mjs`
  static const ElLucideGlyph
  treePine = ElLucideGlyph('tree-pine', <ElIconElement>[
    ElIconPathElement(
      'm17 14 3 3.3a1 1 0 0 1-.7 1.7H4.7a1 1 0 0 1-.7-1.7L7 14h-.3a1 1 0 0 1-.7-1.7L9 9h-.2A1 1 0 0 1 8 7.3L12 3l4 4.3a1 1 0 0 1-.8 1.7H15l3 3.3a1 1 0 0 1-.7 1.7H17Z',
    ), // key: cpyugq
    ElIconPathElement('M12 22v-3'), // key: kmzjlo
  ]);

  /// `trees.mjs`
  static const ElLucideGlyph trees = ElLucideGlyph('trees', <ElIconElement>[
    ElIconPathElement(
      'M10 10v.2A3 3 0 0 1 8.9 16H5a3 3 0 0 1-1-5.8V10a3 3 0 0 1 6 0Z',
    ), // key: 1l6gj6
    ElIconPathElement('M7 16v6'), // key: 1a82de
    ElIconPathElement('M13 19v3'), // key: 13sx9i
    ElIconPathElement(
      'M12 19h8.3a1 1 0 0 0 .7-1.7L18 14h.3a1 1 0 0 0 .7-1.7L16 9h.2a1 1 0 0 0 .8-1.7L13 3l-1.4 1.5',
    ), // key: 1sj9kv
  ]);

  /// `trending-down.mjs`
  static const ElLucideGlyph trendingDown = ElLucideGlyph(
    'trending-down',
    <ElIconElement>[
      ElIconPathElement('M16 17h6v-6'), // key: t6n2it
      ElIconPathElement('m22 17-8.5-8.5-5 5L2 7'), // key: x473p
    ],
  );

  /// `trending-up-down.mjs`
  static const ElLucideGlyph trendingUpDown = ElLucideGlyph(
    'trending-up-down',
    <ElIconElement>[
      ElIconPathElement('M14.828 14.828 21 21'), // key: ar5fw7
      ElIconPathElement('M21 16v5h-5'), // key: 1ck2sf
      ElIconPathElement('m21 3-9 9-4-4-6 6'), // key: 1h02xo
      ElIconPathElement('M21 8V3h-5'), // key: 1qoq8a
    ],
  );

  /// `trending-up.mjs`
  static const ElLucideGlyph trendingUp = ElLucideGlyph(
    'trending-up',
    <ElIconElement>[
      ElIconPathElement('M16 7h6v6'), // key: box55l
      ElIconPathElement('m22 7-8.5 8.5-5-5L2 17'), // key: 1t1m79
    ],
  );

  /// `triangle-alert.mjs`
  static const ElLucideGlyph
  triangleAlert = ElLucideGlyph('triangle-alert', <ElIconElement>[
    ElIconPathElement(
      'm21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3',
    ), // key: wmoenq
    ElIconPathElement('M12 9v4'), // key: juzpu7
    ElIconPathElement('M12 17h.01'), // key: p32p05
  ]);

  /// `triangle-dashed.mjs`
  static const ElLucideGlyph triangleDashed = ElLucideGlyph(
    'triangle-dashed',
    <ElIconElement>[
      ElIconPathElement('M10.17 4.193a2 2 0 0 1 3.666.013'), // key: pltmmw
      ElIconPathElement('M14 21h2'), // key: v4qezv
      ElIconPathElement('m15.874 7.743 1 1.732'), // key: 10m0iw
      ElIconPathElement('m18.849 12.952 1 1.732'), // key: zadnam
      ElIconPathElement('M21.824 18.18a2 2 0 0 1-1.835 2.824'), // key: fvwuk4
      ElIconPathElement('M4.024 21a2 2 0 0 1-1.839-2.839'), // key: 1e1kah
      ElIconPathElement('m5.136 12.952-1 1.732'), // key: 1u4ldi
      ElIconPathElement('M8 21h2'), // key: i9zjee
      ElIconPathElement('m8.102 7.743-1 1.732'), // key: 1zzo4u
    ],
  );

  /// `triangle-right.mjs`
  static const ElLucideGlyph
  triangleRight = ElLucideGlyph('triangle-right', <ElIconElement>[
    ElIconPathElement(
      'M22 18a2 2 0 0 1-2 2H3c-1.1 0-1.3-.6-.4-1.3L20.4 4.3c.9-.7 1.6-.4 1.6.7Z',
    ), // key: 183wce
  ]);

  /// `triangle.mjs`
  static const ElLucideGlyph triangle = ElLucideGlyph(
    'triangle',
    <ElIconElement>[
      ElIconPathElement(
        'M13.73 4a2 2 0 0 0-3.46 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z',
      ), // key: 14u9p9
    ],
  );

  /// `trophy.mjs`
  static const ElLucideGlyph trophy = ElLucideGlyph('trophy', <ElIconElement>[
    ElIconPathElement(
      'M10 14.66V17a1 1 0 0 1-1 1 2 2 0 0 0-2 2v2',
    ), // key: pwuv1l
    ElIconPathElement(
      'M14 14.66V17a1 1 0 0 0 1 1 2 2 0 0 1 2 2v2',
    ), // key: 1y54w1
    ElIconPathElement(
      'M17.916 10H19.5A2.5 2.5 0 0 0 22 7.5V5a1 1 0 0 0-1-1h-3',
    ), // key: e30mpu
    ElIconPathElement('M4 22h16'), // key: 57wxv0
    ElIconPathElement(
      'M6 9a6 6 0 0 0 12 0V3a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1z',
    ), // key: 1mhfuq
    ElIconPathElement(
      'M6.084 10H4.5A2.5 2.5 0 0 1 2 7.5V5a1 1 0 0 1 1-1h3',
    ), // key: i0yafy
  ]);

  /// `truck-electric.mjs`
  static const ElLucideGlyph
  truckElectric = ElLucideGlyph('truck-electric', <ElIconElement>[
    ElIconPathElement('M14 19V7a2 2 0 0 0-2-2H9'), // key: 15peso
    ElIconPathElement('M15 19H9'), // key: 18q6dt
    ElIconPathElement(
      'M19 19h2a1 1 0 0 0 1-1v-3.65a1 1 0 0 0-.22-.62L18.3 9.38a1 1 0 0 0-.78-.38H14',
    ), // key: 1dkp3j
    ElIconPathElement('M2 13v5a1 1 0 0 0 1 1h2'), // key: pkmmzz
    ElIconPathElement(
      'M4 3 2.15 5.15a.495.495 0 0 0 .35.86h2.15a.47.47 0 0 1 .35.86L3 9.02',
    ), // key: 1n26pd
    ElIconCircleElement(17, 19, 2), // key: 1nxcgd
    ElIconCircleElement(7, 19, 2), // key: gzo7y7
  ]);

  /// `truck.mjs`
  static const ElLucideGlyph truck = ElLucideGlyph('truck', <ElIconElement>[
    ElIconPathElement(
      'M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2',
    ), // key: wrbu53
    ElIconPathElement('M15 18H9'), // key: 1lyqi6
    ElIconPathElement(
      'M19 18h2a1 1 0 0 0 1-1v-3.65a1 1 0 0 0-.22-.624l-3.48-4.35A1 1 0 0 0 17.52 8H14',
    ), // key: lysw3i
    ElIconCircleElement(17, 18, 2), // key: 332jqn
    ElIconCircleElement(7, 18, 2), // key: 19iecd
  ]);

  /// `turkish-lira.mjs`
  static const ElLucideGlyph turkishLira = ElLucideGlyph(
    'turkish-lira',
    <ElIconElement>[
      ElIconPathElement('M15 4 5 9'), // key: 14bkc9
      ElIconPathElement('m15 8.5-10 5'), // key: 1grtsx
      ElIconPathElement('M18 12a9 9 0 0 1-9 9V3'), // key: 1sst7f
    ],
  );

  /// `turntable.mjs`
  static const ElLucideGlyph turntable = ElLucideGlyph(
    'turntable',
    <ElIconElement>[
      ElIconPathElement('M10 12.01h.01'), // key: 7rp0yl
      ElIconPathElement('M18 8v4a8 8 0 0 1-1.07 4'), // key: 1st48v
      ElIconCircleElement(10, 12, 4), // key: 19levz
      ElIconRectElement(2, 4, 20, 16, 2), // key: izxlao
    ],
  );

  /// `turtle.mjs`
  static const ElLucideGlyph turtle = ElLucideGlyph('turtle', <ElIconElement>[
    ElIconPathElement(
      'm12 10 2 4v3a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1v-3a8 8 0 1 0-16 0v3a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1v-3l2-4h4Z',
    ), // key: 1lbbv7
    ElIconPathElement('M4.82 7.9 8 10'), // key: m9wose
    ElIconPathElement('M15.18 7.9 12 10'), // key: p8dp2u
    ElIconPathElement('M16.93 10H20a2 2 0 0 1 0 4H2'), // key: 12nsm7
  ]);

  /// `tv-minimal-play.mjs`
  static const ElLucideGlyph
  tvMinimalPlay = ElLucideGlyph('tv-minimal-play', <ElIconElement>[
    ElIconPathElement(
      'M15.033 9.44a.647.647 0 0 1 0 1.12l-4.065 2.352a.645.645 0 0 1-.968-.56V7.648a.645.645 0 0 1 .967-.56z',
    ), // key: vbtd3f
    ElIconPathElement('M7 21h10'), // key: 1b0cd5
    ElIconRectElement(2, 3, 20, 14, 2), // key: 48i651
  ]);

  /// `tv-minimal.mjs`
  static const ElLucideGlyph tvMinimal = ElLucideGlyph(
    'tv-minimal',
    <ElIconElement>[
      ElIconPathElement('M7 21h10'), // key: 1b0cd5
      ElIconRectElement(2, 3, 20, 14, 2), // key: 48i651
    ],
  );

  /// `tv.mjs`
  static const ElLucideGlyph tv = ElLucideGlyph('tv', <ElIconElement>[
    ElIconPathElement('m17 2-5 5-5-5'), // key: 16satq
    ElIconRectElement(2, 7, 20, 15, 2), // key: 1e6viu
  ]);

  /// `type-outline.mjs`
  static const ElLucideGlyph
  typeOutline = ElLucideGlyph('type-outline', <ElIconElement>[
    ElIconPathElement(
      'M14 16.5a.5.5 0 0 0 .5.5h.5a2 2 0 0 1 0 4H9a2 2 0 0 1 0-4h.5a.5.5 0 0 0 .5-.5v-9a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5V8a2 2 0 0 1-4 0V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v3a2 2 0 0 1-4 0v-.5a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5Z',
    ), // key: 1reda3
  ]);

  /// `type.mjs`
  static const ElLucideGlyph type = ElLucideGlyph('type', <ElIconElement>[
    ElIconPathElement('M12 4v16'), // key: 1654pz
    ElIconPathElement('M4 7V5a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v2'), // key: e0r10z
    ElIconPathElement('M9 20h6'), // key: s66wpe
  ]);

  /// `umbrella-off.mjs`
  static const ElLucideGlyph umbrellaOff = ElLucideGlyph(
    'umbrella-off',
    <ElIconElement>[
      ElIconPathElement('M12 13v7a2 2 0 0 0 4 0'), // key: rpgb42
      ElIconPathElement('M12 2v2'), // key: tus03m
      ElIconPathElement(
        'M18.656 13h2.336a1 1 0 0 0 .97-1.274 10.284 10.284 0 0 0-12.07-7.51',
      ), // key: yawknk
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
      ElIconPathElement(
        'M5.961 5.957a10.28 10.28 0 0 0-3.922 5.769A1 1 0 0 0 3 13h10',
      ), // key: 5sfalc
    ],
  );

  /// `umbrella.mjs`
  static const ElLucideGlyph
  umbrella = ElLucideGlyph('umbrella', <ElIconElement>[
    ElIconPathElement('M12 13v7a2 2 0 0 0 4 0'), // key: rpgb42
    ElIconPathElement('M12 2v2'), // key: tus03m
    ElIconPathElement(
      'M20.992 13a1 1 0 0 0 .97-1.274 10.284 10.284 0 0 0-19.923 0A1 1 0 0 0 3 13z',
    ), // key: 124nyo
  ]);

  /// `underline.mjs`
  static const ElLucideGlyph underline = ElLucideGlyph(
    'underline',
    <ElIconElement>[
      ElIconPathElement('M6 4v6a6 6 0 0 0 12 0V4'), // key: 9kb039
      ElIconLineElement(4, 20, 20, 20), // key: nun2al
    ],
  );

  /// `undo-2.mjs`
  static const ElLucideGlyph undo2 = ElLucideGlyph('undo-2', <ElIconElement>[
    ElIconPathElement('M9 14 4 9l5-5'), // key: 102s5s
    ElIconPathElement(
      'M4 9h10.5a5.5 5.5 0 0 1 5.5 5.5a5.5 5.5 0 0 1-5.5 5.5H11',
    ), // key: f3b9sd
  ]);

  /// `undo-dot.mjs`
  static const ElLucideGlyph undoDot = ElLucideGlyph(
    'undo-dot',
    <ElIconElement>[
      ElIconPathElement('M21 17a9 9 0 0 0-15-6.7L3 13'), // key: 8mp6z9
      ElIconPathElement('M3 7v6h6'), // key: 1v2h90
      ElIconCircleElement(12, 17, 1), // key: 1ixnty
    ],
  );

  /// `undo.mjs`
  static const ElLucideGlyph undo = ElLucideGlyph('undo', <ElIconElement>[
    ElIconPathElement('M3 7v6h6'), // key: 1v2h90
    ElIconPathElement(
      'M21 17a9 9 0 0 0-9-9 9 9 0 0 0-6 2.3L3 13',
    ), // key: 1r6uu6
  ]);

  /// `unfold-horizontal.mjs`
  static const ElLucideGlyph unfoldHorizontal = ElLucideGlyph(
    'unfold-horizontal',
    <ElIconElement>[
      ElIconPathElement('M16 12h6'), // key: 15xry1
      ElIconPathElement('M8 12H2'), // key: 1jqql6
      ElIconPathElement('M12 2v2'), // key: tus03m
      ElIconPathElement('M12 8v2'), // key: 1woqiv
      ElIconPathElement('M12 14v2'), // key: 8jcxud
      ElIconPathElement('M12 20v2'), // key: 1lh1kg
      ElIconPathElement('m19 15 3-3-3-3'), // key: wjy7rq
      ElIconPathElement('m5 9-3 3 3 3'), // key: j64kie
    ],
  );

  /// `unfold-vertical.mjs`
  static const ElLucideGlyph unfoldVertical = ElLucideGlyph(
    'unfold-vertical',
    <ElIconElement>[
      ElIconPathElement('M12 22v-6'), // key: 6o8u61
      ElIconPathElement('M12 8V2'), // key: 1wkif3
      ElIconPathElement('M4 12H2'), // key: rhcxmi
      ElIconPathElement('M10 12H8'), // key: s88cx1
      ElIconPathElement('M16 12h-2'), // key: 10asgb
      ElIconPathElement('M22 12h-2'), // key: 14jgyd
      ElIconPathElement('m15 19-3 3-3-3'), // key: 11eu04
      ElIconPathElement('m15 5-3-3-3 3'), // key: itvq4r
    ],
  );

  /// `ungroup.mjs`
  static const ElLucideGlyph ungroup = ElLucideGlyph('ungroup', <ElIconElement>[
    ElIconRectElement(11, 14, 10, 7, 2), // key: nfm8rk
    ElIconRectElement(3, 3, 10, 7, 2), // key: 1ljebb
  ]);

  /// `university.mjs`
  static const ElLucideGlyph
  university = ElLucideGlyph('university', <ElIconElement>[
    ElIconPathElement('M14 21v-3a2 2 0 0 0-4 0v3'), // key: 1rgiei
    ElIconPathElement('M18 12h.01'), // key: yjnet6
    ElIconPathElement('M18 16h.01'), // key: plv8zi
    ElIconPathElement(
      'M22 7a1 1 0 0 0-1-1h-2a2 2 0 0 1-1.143-.359L13.143 2.36a2 2 0 0 0-2.286-.001L6.143 5.64A2 2 0 0 1 5 6H3a1 1 0 0 0-1 1v12a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2z',
    ), // key: 1ogmi3
    ElIconPathElement('M6 12h.01'), // key: c2rlol
    ElIconPathElement('M6 16h.01'), // key: 1pmjb7
    ElIconCircleElement(12, 10, 2), // key: 1yojzk
  ]);

  /// `unlink-2.mjs`
  static const ElLucideGlyph unlink2 = ElLucideGlyph(
    'unlink-2',
    <ElIconElement>[
      ElIconPathElement(
        'M15 7h2a5 5 0 0 1 0 10h-2m-6 0H7A5 5 0 0 1 7 7h2',
      ), // key: 1re2ne
    ],
  );

  /// `unlink.mjs`
  static const ElLucideGlyph unlink = ElLucideGlyph('unlink', <ElIconElement>[
    ElIconPathElement(
      'm18.84 12.25 1.72-1.71h-.02a5.004 5.004 0 0 0-.12-7.07 5.006 5.006 0 0 0-6.95 0l-1.72 1.71',
    ), // key: yqzxt4
    ElIconPathElement(
      'm5.17 11.75-1.71 1.71a5.004 5.004 0 0 0 .12 7.07 5.006 5.006 0 0 0 6.95 0l1.71-1.71',
    ), // key: 4qinb0
    ElIconLineElement(8, 2, 8, 5), // key: 1041cp
    ElIconLineElement(2, 8, 5, 8), // key: 14m1p5
    ElIconLineElement(16, 19, 16, 22), // key: rzdirn
    ElIconLineElement(19, 16, 22, 16), // key: ox905f
  ]);

  /// `unplug.mjs`
  static const ElLucideGlyph unplug = ElLucideGlyph('unplug', <ElIconElement>[
    ElIconPathElement('m19 5 3-3'), // key: yk6iyv
    ElIconPathElement('m2 22 3-3'), // key: 19mgm9
    ElIconPathElement(
      'M6.3 20.3a2.4 2.4 0 0 0 3.4 0L12 18l-6-6-2.3 2.3a2.4 2.4 0 0 0 0 3.4Z',
    ), // key: goz73y
    ElIconPathElement('M7.5 13.5 10 11'), // key: 7xgeeb
    ElIconPathElement('M10.5 16.5 13 14'), // key: 10btkg
    ElIconPathElement(
      'm12 6 6 6 2.3-2.3a2.4 2.4 0 0 0 0-3.4l-2.6-2.6a2.4 2.4 0 0 0-3.4 0Z',
    ), // key: 1snsnr
  ]);

  /// `upload.mjs`
  static const ElLucideGlyph upload = ElLucideGlyph('upload', <ElIconElement>[
    ElIconPathElement('M12 3v12'), // key: 1x0j5s
    ElIconPathElement('m17 8-5-5-5 5'), // key: 7q97r8
    ElIconPathElement(
      'M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4',
    ), // key: ih7n3h
  ]);

  /// `usb.mjs`
  static const ElLucideGlyph usb = ElLucideGlyph('usb', <ElIconElement>[
    ElIconCircleElement(10, 7, 1), // key: dypaad
    ElIconCircleElement(4, 20, 1), // key: 22iqad
    ElIconPathElement('M4.7 19.3 19 5'), // key: 1enqfc
    ElIconPathElement('m21 3-3 1 2 2Z'), // key: d3ov82
    ElIconPathElement('M9.26 7.68 5 12l2 5'), // key: 1esawj
    ElIconPathElement('m10 14 5 2 3.5-3.5'), // key: v8oal5
    ElIconPathElement('m18 12 1-1 1 1-1 1Z'), // key: 1bh22v
  ]);

  /// `user-check.mjs`
  static const ElLucideGlyph userCheck = ElLucideGlyph(
    'user-check',
    <ElIconElement>[
      ElIconPathElement('m16 11 2 2 4-4'), // key: 9rsbq5
      ElIconPathElement(
        'M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2',
      ), // key: 1yyitq
      ElIconCircleElement(9, 7, 4), // key: nufk8
    ],
  );

  /// `user-cog.mjs`
  static const ElLucideGlyph userCog = ElLucideGlyph(
    'user-cog',
    <ElIconElement>[
      ElIconPathElement('M10 15H6a4 4 0 0 0-4 4v2'), // key: 1nfge6
      ElIconPathElement('m14.305 16.53.923-.382'), // key: 1itpsq
      ElIconPathElement('m15.228 13.852-.923-.383'), // key: eplpkm
      ElIconPathElement('m16.852 12.228-.383-.923'), // key: 13v3q0
      ElIconPathElement('m16.852 17.772-.383.924'), // key: 1i8mnm
      ElIconPathElement('m19.148 12.228.383-.923'), // key: 1q8j1v
      ElIconPathElement('m19.53 18.696-.382-.924'), // key: vk1qj3
      ElIconPathElement('m20.772 13.852.924-.383'), // key: n880s0
      ElIconPathElement('m20.772 16.148.924.383'), // key: 1g6xey
      ElIconCircleElement(18, 15, 3), // key: gjjjvw
      ElIconCircleElement(9, 7, 4), // key: nufk8
    ],
  );

  /// `user-key.mjs`
  static const ElLucideGlyph userKey = ElLucideGlyph(
    'user-key',
    <ElIconElement>[
      ElIconPathElement('M20 11v6'), // key: d77pzp
      ElIconPathElement('M20 13h2'), // key: 16rner
      ElIconPathElement(
        'M3 21v-2a4 4 0 0 1 4-4h6a4 4 0 0 1 2.072.578',
      ), // key: 1yxgtw
      ElIconCircleElement(10, 7, 4), // key: e45bow
      ElIconCircleElement(20, 19, 2), // key: 1obnsp
    ],
  );

  /// `user-lock.mjs`
  static const ElLucideGlyph userLock = ElLucideGlyph(
    'user-lock',
    <ElIconElement>[
      ElIconPathElement('M19 16v-2a2 2 0 0 0-4 0v2'), // key: 17sujf
      ElIconPathElement('M9.5 15H7a4 4 0 0 0-4 4v2'), // key: 9it25y
      ElIconCircleElement(10, 7, 4), // key: e45bow
      ElIconRectElement(13, 16, 8, 5, 0.899), // key: ur80nz
    ],
  );

  /// `user-minus.mjs`
  static const ElLucideGlyph userMinus = ElLucideGlyph(
    'user-minus',
    <ElIconElement>[
      ElIconPathElement(
        'M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2',
      ), // key: 1yyitq
      ElIconCircleElement(9, 7, 4), // key: nufk8
      ElIconLineElement(22, 11, 16, 11), // key: 1shjgl
    ],
  );

  /// `user-pen.mjs`
  static const ElLucideGlyph
  userPen = ElLucideGlyph('user-pen', <ElIconElement>[
    ElIconPathElement('M11.5 15H7a4 4 0 0 0-4 4v2'), // key: 15lzij
    ElIconPathElement(
      'M21.378 16.626a1 1 0 0 0-3.004-3.004l-4.01 4.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z',
    ), // key: 1817ys
    ElIconCircleElement(10, 7, 4), // key: e45bow
  ]);

  /// `user-plus.mjs`
  static const ElLucideGlyph userPlus = ElLucideGlyph(
    'user-plus',
    <ElIconElement>[
      ElIconPathElement(
        'M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2',
      ), // key: 1yyitq
      ElIconCircleElement(9, 7, 4), // key: nufk8
      ElIconLineElement(19, 8, 19, 14), // key: 1bvyxn
      ElIconLineElement(22, 11, 16, 11), // key: 1shjgl
    ],
  );

  /// `user-round-arrow-left.mjs`
  static const ElLucideGlyph userRoundArrowLeft = ElLucideGlyph(
    'user-round-arrow-left',
    <ElIconElement>[
      ElIconPathElement('m19 16-3 3'), // key: lp3y45
      ElIconPathElement('M2 21a8 8 0 0 1 12.664-6.5'), // key: 1ap0vn
      ElIconPathElement('M22 19h-6l3 3'), // key: 13fjle
      ElIconCircleElement(10, 8, 5), // key: o932ke
    ],
  );

  /// `user-round-check.mjs`
  static const ElLucideGlyph userRoundCheck = ElLucideGlyph(
    'user-round-check',
    <ElIconElement>[
      ElIconPathElement('M2 21a8 8 0 0 1 13.292-6'), // key: bjp14o
      ElIconCircleElement(10, 8, 5), // key: o932ke
      ElIconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
    ],
  );

  /// `user-round-cog.mjs`
  static const ElLucideGlyph userRoundCog = ElLucideGlyph(
    'user-round-cog',
    <ElIconElement>[
      ElIconPathElement('m14.305 19.53.923-.382'), // key: 3m78fa
      ElIconPathElement('m15.228 16.852-.923-.383'), // key: npixar
      ElIconPathElement('m16.852 15.228-.383-.923'), // key: 5xggr7
      ElIconPathElement('m16.852 20.772-.383.924'), // key: dpfhf9
      ElIconPathElement('m19.148 15.228.383-.923'), // key: 1reyyz
      ElIconPathElement('m19.53 21.696-.382-.924'), // key: 1goivc
      ElIconPathElement('M2 21a8 8 0 0 1 10.434-7.62'), // key: 1yezr2
      ElIconPathElement('m20.772 16.852.924-.383'), // key: htqkph
      ElIconPathElement('m20.772 19.148.924.383'), // key: 9w9pjp
      ElIconCircleElement(10, 8, 5), // key: o932ke
      ElIconCircleElement(18, 18, 3), // key: 1xkwt0
    ],
  );

  /// `user-round-key.mjs`
  static const ElLucideGlyph userRoundKey = ElLucideGlyph(
    'user-round-key',
    <ElIconElement>[
      ElIconPathElement('M19 11v6'), // key: rcqigv
      ElIconPathElement('M19 13h2'), // key: 1gch44
      ElIconPathElement('M2 21a8 8 0 0 1 12.868-6.349'), // key: 1lryzn
      ElIconCircleElement(10, 8, 5), // key: o932ke
      ElIconCircleElement(19, 19, 2), // key: 17f5cg
    ],
  );

  /// `user-round-minus.mjs`
  static const ElLucideGlyph userRoundMinus = ElLucideGlyph(
    'user-round-minus',
    <ElIconElement>[
      ElIconPathElement('M2 21a8 8 0 0 1 13.292-6'), // key: bjp14o
      ElIconCircleElement(10, 8, 5), // key: o932ke
      ElIconPathElement('M22 19h-6'), // key: vcuq98
    ],
  );

  /// `user-round-pen.mjs`
  static const ElLucideGlyph
  userRoundPen = ElLucideGlyph('user-round-pen', <ElIconElement>[
    ElIconPathElement('M2 21a8 8 0 0 1 10.821-7.487'), // key: 1c8h7z
    ElIconPathElement(
      'M21.378 16.626a1 1 0 0 0-3.004-3.004l-4.01 4.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z',
    ), // key: 1817ys
    ElIconCircleElement(10, 8, 5), // key: o932ke
  ]);

  /// `user-round-plus.mjs`
  static const ElLucideGlyph userRoundPlus = ElLucideGlyph(
    'user-round-plus',
    <ElIconElement>[
      ElIconPathElement('M2 21a8 8 0 0 1 13.292-6'), // key: bjp14o
      ElIconCircleElement(10, 8, 5), // key: o932ke
      ElIconPathElement('M19 16v6'), // key: tddt3s
      ElIconPathElement('M22 19h-6'), // key: vcuq98
    ],
  );

  /// `user-round-search.mjs`
  static const ElLucideGlyph userRoundSearch = ElLucideGlyph(
    'user-round-search',
    <ElIconElement>[
      ElIconCircleElement(10, 8, 5), // key: o932ke
      ElIconPathElement('M2 21a8 8 0 0 1 10.434-7.62'), // key: 1yezr2
      ElIconCircleElement(18, 18, 3), // key: 1xkwt0
      ElIconPathElement('m22 22-1.9-1.9'), // key: 1e5ubv
    ],
  );

  /// `user-round-x.mjs`
  static const ElLucideGlyph userRoundX = ElLucideGlyph(
    'user-round-x',
    <ElIconElement>[
      ElIconPathElement('M2 21a8 8 0 0 1 11.873-7'), // key: 74fkxq
      ElIconCircleElement(10, 8, 5), // key: o932ke
      ElIconPathElement('m17 17 5 5'), // key: p7ous7
      ElIconPathElement('m22 17-5 5'), // key: gqnmv0
    ],
  );

  /// `user-round.mjs`
  static const ElLucideGlyph userRound = ElLucideGlyph(
    'user-round',
    <ElIconElement>[
      ElIconCircleElement(12, 8, 5), // key: 1hypcn
      ElIconPathElement('M20 21a8 8 0 0 0-16 0'), // key: rfgkzh
    ],
  );

  /// `user-search.mjs`
  static const ElLucideGlyph userSearch = ElLucideGlyph(
    'user-search',
    <ElIconElement>[
      ElIconCircleElement(10, 7, 4), // key: e45bow
      ElIconPathElement('M10.3 15H7a4 4 0 0 0-4 4v2'), // key: 3bnktk
      ElIconCircleElement(17, 17, 3), // key: 18b49y
      ElIconPathElement('m21 21-1.9-1.9'), // key: 1g2n9r
    ],
  );

  /// `user-shield.mjs`
  static const ElLucideGlyph
  userShield = ElLucideGlyph('user-shield', <ElIconElement>[
    ElIconPathElement('M10 15H6a4 4 0 0 0-4 4v2'), // key: 1nfge6
    ElIconPathElement(
      'M22 17.5c0 2.499-1.75 3.749-3.83 4.474a.5.5 0 0 1-.335-.005c-2.085-.72-3.835-1.97-3.835-4.47V14a.5.5 0 0 1 .5-.499c1 0 2.25-.6 3.12-1.36a.6.6 0 0 1 .76-.001c.875.765 2.12 1.36 3.12 1.36a.5.5 0 0 1 .5.5z',
    ), // key: 16j3tf
    ElIconCircleElement(9, 7, 4), // key: nufk8
  ]);

  /// `user-star.mjs`
  static const ElLucideGlyph
  userStar = ElLucideGlyph('user-star', <ElIconElement>[
    ElIconPathElement(
      'M16.051 12.616a1 1 0 0 1 1.909.024l.737 1.452a1 1 0 0 0 .737.535l1.634.256a1 1 0 0 1 .588 1.806l-1.172 1.168a1 1 0 0 0-.282.866l.259 1.613a1 1 0 0 1-1.541 1.134l-1.465-.75a1 1 0 0 0-.912 0l-1.465.75a1 1 0 0 1-1.539-1.133l.258-1.613a1 1 0 0 0-.282-.866l-1.156-1.153a1 1 0 0 1 .572-1.822l1.633-.256a1 1 0 0 0 .737-.535z',
    ), // key: 1m8t9f
    ElIconPathElement('M8 15H7a4 4 0 0 0-4 4v2'), // key: l9tmp8
    ElIconCircleElement(10, 7, 4), // key: e45bow
  ]);

  /// `user-x.mjs`
  static const ElLucideGlyph userX = ElLucideGlyph('user-x', <ElIconElement>[
    ElIconPathElement(
      'M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2',
    ), // key: 1yyitq
    ElIconCircleElement(9, 7, 4), // key: nufk8
    ElIconLineElement(17, 8, 22, 13), // key: 3nzzx3
    ElIconLineElement(22, 8, 17, 13), // key: 1swrse
  ]);

  /// `user.mjs`
  static const ElLucideGlyph user = ElLucideGlyph('user', <ElIconElement>[
    ElIconPathElement(
      'M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2',
    ), // key: 975kel
    ElIconCircleElement(12, 7, 4), // key: 17ys0d
  ]);

  /// `users-round.mjs`
  static const ElLucideGlyph usersRound = ElLucideGlyph(
    'users-round',
    <ElIconElement>[
      ElIconPathElement('M18 21a8 8 0 0 0-16 0'), // key: 3ypg7q
      ElIconCircleElement(10, 8, 5), // key: o932ke
      ElIconPathElement(
        'M22 20c0-3.37-2-6.5-4-8a5 5 0 0 0-.45-8.3',
      ), // key: 10s06x
    ],
  );

  /// `users.mjs`
  static const ElLucideGlyph users = ElLucideGlyph('users', <ElIconElement>[
    ElIconPathElement(
      'M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2',
    ), // key: 1yyitq
    ElIconPathElement('M16 3.128a4 4 0 0 1 0 7.744'), // key: 16gr8j
    ElIconPathElement('M22 21v-2a4 4 0 0 0-3-3.87'), // key: kshegd
    ElIconCircleElement(9, 7, 4), // key: nufk8
  ]);

  /// `utensils-crossed.mjs`
  static const ElLucideGlyph
  utensilsCrossed = ElLucideGlyph('utensils-crossed', <ElIconElement>[
    ElIconPathElement(
      'm16 2-2.3 2.3a3 3 0 0 0 0 4.2l1.8 1.8a3 3 0 0 0 4.2 0L22 8',
    ), // key: n7qcjb
    ElIconPathElement(
      'M15 15 3.3 3.3a4.2 4.2 0 0 0 0 6l7.3 7.3c.7.7 2 .7 2.8 0L15 15Zm0 0 7 7',
    ), // key: d0u48b
    ElIconPathElement('m2.1 21.8 6.4-6.3'), // key: yn04lh
    ElIconPathElement('m19 5-7 7'), // key: 194lzd
  ]);

  /// `utensils.mjs`
  static const ElLucideGlyph
  utensils = ElLucideGlyph('utensils', <ElIconElement>[
    ElIconPathElement('M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2'), // key: cjf0a3
    ElIconPathElement('M7 2v20'), // key: 1473qp
    ElIconPathElement(
      'M21 15V2a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3Zm0 0v7',
    ), // key: j28e5
  ]);

  /// `utility-pole.mjs`
  static const ElLucideGlyph utilityPole = ElLucideGlyph(
    'utility-pole',
    <ElIconElement>[
      ElIconPathElement('M12 2v20'), // key: t6zp3m
      ElIconPathElement('M2 5h20'), // key: 1fs1ex
      ElIconPathElement('M3 3v2'), // key: 9imdir
      ElIconPathElement('M7 3v2'), // key: n0os7
      ElIconPathElement('M17 3v2'), // key: 1l2re6
      ElIconPathElement('M21 3v2'), // key: 1duuac
      ElIconPathElement('m19 5-7 7-7-7'), // key: 133zxf
    ],
  );

  /// `van.mjs`
  static const ElLucideGlyph van = ElLucideGlyph('van', <ElIconElement>[
    ElIconPathElement(
      'M13 6v5a1 1 0 0 0 1 1h6.102a1 1 0 0 1 .712.298l.898.91a1 1 0 0 1 .288.702V17a1 1 0 0 1-1 1h-3',
    ), // key: k3s650
    ElIconPathElement(
      'M5 18H3a1 1 0 0 1-1-1V8a2 2 0 0 1 2-2h12c1.1 0 2.1.8 2.4 1.8l1.176 4.2',
    ), // key: fnd93u
    ElIconPathElement('M9 18h5'), // key: lrx6i
    ElIconCircleElement(16, 18, 2), // key: 1v4tcr
    ElIconCircleElement(7, 18, 2), // key: 19iecd
  ]);

  /// `variable.mjs`
  static const ElLucideGlyph variable = ElLucideGlyph(
    'variable',
    <ElIconElement>[
      ElIconPathElement('M8 21s-4-3-4-9 4-9 4-9'), // key: uto9ud
      ElIconPathElement('M16 3s4 3 4 9-4 9-4 9'), // key: 4w2vsq
      ElIconLineElement(15, 9, 9, 15), // key: f7djnv
      ElIconLineElement(9, 9, 15, 15), // key: 1shsy8
    ],
  );

  /// `vault.mjs`
  static const ElLucideGlyph vault = ElLucideGlyph('vault', <ElIconElement>[
    ElIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    ElIconCircleElement(7.5, 7.5, 0.5, filled: true), // key: kqv944
    ElIconPathElement('m7.9 7.9 2.7 2.7'), // key: hpeyl3
    ElIconCircleElement(16.5, 7.5, 0.5, filled: true), // key: w0ekpg
    ElIconPathElement('m13.4 10.6 2.7-2.7'), // key: 264c1n
    ElIconCircleElement(7.5, 16.5, 0.5, filled: true), // key: nkw3mc
    ElIconPathElement('m7.9 16.1 2.7-2.7'), // key: p81g5e
    ElIconCircleElement(16.5, 16.5, 0.5, filled: true), // key: fubopw
    ElIconPathElement('m13.4 13.4 2.7 2.7'), // key: abhel3
    ElIconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `vector-square.mjs`
  static const ElLucideGlyph vectorSquare = ElLucideGlyph(
    'vector-square',
    <ElIconElement>[
      ElIconPathElement('M19.5 7a24 24 0 0 1 0 10'), // key: 8n60xe
      ElIconPathElement('M4.5 7a24 24 0 0 0 0 10'), // key: 2lmadr
      ElIconPathElement('M7 19.5a24 24 0 0 0 10 0'), // key: 1q94o2
      ElIconPathElement('M7 4.5a24 24 0 0 1 10 0'), // key: 2z8ypa
      ElIconRectElement(17, 17, 5, 5, 1), // key: 1ac74s
      ElIconRectElement(17, 2, 5, 5, 1), // key: 1e7h5j
      ElIconRectElement(2, 17, 5, 5, 1), // key: 1t4eah
      ElIconRectElement(2, 2, 5, 5, 1), // key: 940dhs
    ],
  );

  /// `vegan.mjs`
  static const ElLucideGlyph vegan = ElLucideGlyph('vegan', <ElIconElement>[
    ElIconPathElement('M16 8q6 0 6-6-6 0-6 6'), // key: qsyyc4
    ElIconPathElement('M17.41 3.59a10 10 0 1 0 3 3'), // key: 41m9h7
    ElIconPathElement(
      'M2 2a26.6 26.6 0 0 1 10 20c.9-6.82 1.5-9.5 4-14',
    ), // key: qiv7li
  ]);

  /// `venetian-mask.mjs`
  static const ElLucideGlyph
  venetianMask = ElLucideGlyph('venetian-mask', <ElIconElement>[
    ElIconPathElement('M18 11c-1.5 0-2.5.5-3 2'), // key: 1fod00
    ElIconPathElement(
      'M4 6a2 2 0 0 0-2 2v4a5 5 0 0 0 5 5 8 8 0 0 1 5 2 8 8 0 0 1 5-2 5 5 0 0 0 5-5V8a2 2 0 0 0-2-2h-3a8 8 0 0 0-5 2 8 8 0 0 0-5-2z',
    ), // key: d70hit
    ElIconPathElement('M6 11c1.5 0 2.5.5 3 2'), // key: 136fht
  ]);

  /// `venus-and-mars.mjs`
  static const ElLucideGlyph venusAndMars = ElLucideGlyph(
    'venus-and-mars',
    <ElIconElement>[
      ElIconPathElement('M10 20h4'), // key: ni2waw
      ElIconPathElement('M12 16v6'), // key: c8a4gj
      ElIconPathElement('M17 2h4v4'), // key: vhe59
      ElIconPathElement('m21 2-5.46 5.46'), // key: 19kypf
      ElIconCircleElement(12, 11, 5), // key: 16gxyc
    ],
  );

  /// `venus.mjs`
  static const ElLucideGlyph venus = ElLucideGlyph('venus', <ElIconElement>[
    ElIconPathElement('M12 15v7'), // key: t2xh3l
    ElIconPathElement('M9 19h6'), // key: 456am0
    ElIconCircleElement(12, 9, 6), // key: 1nw4tq
  ]);

  /// `vibrate-off.mjs`
  static const ElLucideGlyph vibrateOff = ElLucideGlyph(
    'vibrate-off',
    <ElIconElement>[
      ElIconPathElement('m2 8 2 2-2 2 2 2-2 2'), // key: sv1b1
      ElIconPathElement('m22 8-2 2 2 2-2 2 2 2'), // key: 101i4y
      ElIconPathElement(
        'M8 8v10c0 .55.45 1 1 1h6c.55 0 1-.45 1-1v-2',
      ), // key: 1hbad5
      ElIconPathElement('M16 10.34V6c0-.55-.45-1-1-1h-4.34'), // key: 1x5tf0
      ElIconLineElement(2, 2, 22, 22), // key: a6p6uj
    ],
  );

  /// `vibrate.mjs`
  static const ElLucideGlyph vibrate = ElLucideGlyph('vibrate', <ElIconElement>[
    ElIconPathElement('m2 8 2 2-2 2 2 2-2 2'), // key: sv1b1
    ElIconPathElement('m22 8-2 2 2 2-2 2 2 2'), // key: 101i4y
    ElIconRectElement(8, 5, 8, 14, 1), // key: 1oyrl4
  ]);

  /// `video-off.mjs`
  static const ElLucideGlyph videoOff = ElLucideGlyph(
    'video-off',
    <ElIconElement>[
      ElIconPathElement(
        'M10.66 6H14a2 2 0 0 1 2 2v2.5l5.248-3.062A.5.5 0 0 1 22 7.87v8.196',
      ), // key: w8jjjt
      ElIconPathElement(
        'M16 16a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h2',
      ), // key: 1xawa7
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ],
  );

  /// `video.mjs`
  static const ElLucideGlyph video = ElLucideGlyph('video', <ElIconElement>[
    ElIconPathElement(
      'm16 13 5.223 3.482a.5.5 0 0 0 .777-.416V7.87a.5.5 0 0 0-.752-.432L16 10.5',
    ), // key: ftymec
    ElIconRectElement(2, 6, 14, 12, 2), // key: 158x01
  ]);

  /// `videotape.mjs`
  static const ElLucideGlyph videotape = ElLucideGlyph(
    'videotape',
    <ElIconElement>[
      ElIconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
      ElIconPathElement('M2 8h20'), // key: d11cs7
      ElIconCircleElement(8, 14, 2), // key: 1k2qr5
      ElIconPathElement('M8 12h8'), // key: 1wcyev
      ElIconCircleElement(16, 14, 2), // key: 14k7lr
    ],
  );

  /// `view.mjs`
  static const ElLucideGlyph view = ElLucideGlyph('view', <ElIconElement>[
    ElIconPathElement(
      'M21 17v2a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-2',
    ), // key: mrq65r
    ElIconPathElement('M21 7V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v2'), // key: be3xqs
    ElIconCircleElement(12, 12, 1), // key: 41hilf
    ElIconPathElement(
      'M18.944 12.33a1 1 0 0 0 0-.66 7.5 7.5 0 0 0-13.888 0 1 1 0 0 0 0 .66 7.5 7.5 0 0 0 13.888 0',
    ), // key: 11ak4c
  ]);

  /// `voicemail.mjs`
  static const ElLucideGlyph voicemail = ElLucideGlyph(
    'voicemail',
    <ElIconElement>[
      ElIconCircleElement(6, 12, 4), // key: 1ehtga
      ElIconCircleElement(18, 12, 4), // key: 4vafl8
      ElIconLineElement(6, 16, 18, 16), // key: pmt8us
    ],
  );

  /// `volleyball.mjs`
  static const ElLucideGlyph volleyball = ElLucideGlyph(
    'volleyball',
    <ElIconElement>[
      ElIconPathElement('M11 7a16 16 20 0 1 10.98 4.362'), // key: 1mmfx7
      ElIconPathElement('M12 12a13 13 0 0 1-8.66 5'), // key: 14sm5y
      ElIconPathElement('M16.83 13.634a16 16 0 0 1-9.267 7.328'), // key: j0eyj5
      ElIconPathElement(
        'M20.66 17A13 13 0 0 0 12 12a13 13 0 0 1 0-10',
      ), // key: qaetsw
      ElIconPathElement('M8.17 15.366a16 16 0 0 1-1.713-11.69'), // key: 17ewdd
      ElIconCircleElement(12, 12, 10), // key: 1mglay
    ],
  );

  /// `volume-1.mjs`
  static const ElLucideGlyph
  volume1 = ElLucideGlyph('volume-1', <ElIconElement>[
    ElIconPathElement(
      'M11 4.702a.705.705 0 0 0-1.203-.498L6.413 7.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298z',
    ), // key: uqj9uw
    ElIconPathElement('M16 9a5 5 0 0 1 0 6'), // key: 1q6k2b
  ]);

  /// `volume-2.mjs`
  static const ElLucideGlyph
  volume2 = ElLucideGlyph('volume-2', <ElIconElement>[
    ElIconPathElement(
      'M11 4.702a.705.705 0 0 0-1.203-.498L6.413 7.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298z',
    ), // key: uqj9uw
    ElIconPathElement('M16 9a5 5 0 0 1 0 6'), // key: 1q6k2b
    ElIconPathElement('M19.364 18.364a9 9 0 0 0 0-12.728'), // key: ijwkga
  ]);

  /// `volume-off.mjs`
  static const ElLucideGlyph
  volumeOff = ElLucideGlyph('volume-off', <ElIconElement>[
    ElIconPathElement('M16 9a5 5 0 0 1 .95 2.293'), // key: 1fgyg8
    ElIconPathElement('M19.364 5.636a9 9 0 0 1 1.889 9.96'), // key: l3zxae
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement(
      'm7 7-.587.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298V11',
    ), // key: 1gbwow
    ElIconPathElement(
      'M9.828 4.172A.686.686 0 0 1 11 4.657v.686',
    ), // key: s2je0y
  ]);

  /// `volume-x.mjs`
  static const ElLucideGlyph
  volumeX = ElLucideGlyph('volume-x', <ElIconElement>[
    ElIconPathElement(
      'M11 4.702a.705.705 0 0 0-1.203-.498L6.413 7.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298z',
    ), // key: uqj9uw
    ElIconLineElement(22, 9, 16, 15), // key: 1ewh16
    ElIconLineElement(16, 9, 22, 15), // key: 5ykzw1
  ]);

  /// `volume.mjs`
  static const ElLucideGlyph volume = ElLucideGlyph('volume', <ElIconElement>[
    ElIconPathElement(
      'M11 4.702a.705.705 0 0 0-1.203-.498L6.413 7.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298z',
    ), // key: uqj9uw
  ]);

  /// `vote.mjs`
  static const ElLucideGlyph vote = ElLucideGlyph('vote', <ElIconElement>[
    ElIconPathElement('m9 12 2 2 4-4'), // key: dzmm74
    ElIconPathElement(
      'M5 7c0-1.1.9-2 2-2h10a2 2 0 0 1 2 2v12H5V7Z',
    ), // key: 1ezoue
    ElIconPathElement('M22 19H2'), // key: nuriw5
  ]);

  /// `wallet-cards.mjs`
  static const ElLucideGlyph
  walletCards = ElLucideGlyph('wallet-cards', <ElIconElement>[
    ElIconPathElement(
      'M3 11h3.75a2 2 0 0 1 1.6.8l.45.6a4 4 0 0 0 6.4 0l.45-.6a2 2 0 0 1 1.6-.8H21',
    ), // key: 1vwh6y
    ElIconPathElement('M3 7h18'), // key: 1uiuf2
    ElIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `wallet-minimal.mjs`
  static const ElLucideGlyph
  walletMinimal = ElLucideGlyph('wallet-minimal', <ElIconElement>[
    ElIconPathElement('M17 14h.01'), // key: 7oqj8z
    ElIconPathElement(
      'M7 7h12a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14',
    ), // key: u1rqew
  ]);

  /// `wallet.mjs`
  static const ElLucideGlyph wallet = ElLucideGlyph('wallet', <ElIconElement>[
    ElIconPathElement(
      'M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1',
    ), // key: 18etb6
    ElIconPathElement(
      'M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4',
    ), // key: xoc0q4
  ]);

  /// `wallpaper.mjs`
  static const ElLucideGlyph wallpaper = ElLucideGlyph(
    'wallpaper',
    <ElIconElement>[
      ElIconPathElement('M12 17v4'), // key: 1riwvh
      ElIconPathElement('M8 21h8'), // key: 1ev6f3
      ElIconPathElement('m9 17 6.1-6.1a2 2 0 0 1 2.81.01L22 15'), // key: 1sl52q
      ElIconCircleElement(8, 9, 2), // key: gjzl9d
      ElIconRectElement(2, 3, 20, 14, 2), // key: x3v2xh
    ],
  );

  /// `wand-sparkles.mjs`
  static const ElLucideGlyph
  wandSparkles = ElLucideGlyph('wand-sparkles', <ElIconElement>[
    ElIconPathElement(
      'm21.64 3.64-1.28-1.28a1.21 1.21 0 0 0-1.72 0L2.36 18.64a1.21 1.21 0 0 0 0 1.72l1.28 1.28a1.2 1.2 0 0 0 1.72 0L21.64 5.36a1.2 1.2 0 0 0 0-1.72',
    ), // key: ul74o6
    ElIconPathElement('m14 7 3 3'), // key: 1r5n42
    ElIconPathElement('M5 6v4'), // key: ilb8ba
    ElIconPathElement('M19 14v4'), // key: blhpug
    ElIconPathElement('M10 2v2'), // key: 7u0qdc
    ElIconPathElement('M7 8H3'), // key: zfb6yr
    ElIconPathElement('M21 16h-4'), // key: 1cnmox
    ElIconPathElement('M11 3H9'), // key: 1obp7u
  ]);

  /// `wand.mjs`
  static const ElLucideGlyph wand = ElLucideGlyph('wand', <ElIconElement>[
    ElIconPathElement('M15 4V2'), // key: z1p9b7
    ElIconPathElement('M15 16v-2'), // key: px0unx
    ElIconPathElement('M8 9h2'), // key: 1g203m
    ElIconPathElement('M20 9h2'), // key: 19tzq7
    ElIconPathElement('M17.8 11.8 19 13'), // key: yihg8r
    ElIconPathElement('M15 9h.01'), // key: x1ddxp
    ElIconPathElement('M17.8 6.2 19 5'), // key: fd4us0
    ElIconPathElement('m3 21 9-9'), // key: 1jfql5
    ElIconPathElement('M12.2 6.2 11 5'), // key: i3da3b
  ]);

  /// `warehouse.mjs`
  static const ElLucideGlyph
  warehouse = ElLucideGlyph('warehouse', <ElIconElement>[
    ElIconPathElement(
      'M18 21V10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1v11',
    ), // key: pb2vm6
    ElIconPathElement(
      'M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V8a2 2 0 0 1 1.132-1.803l7.95-3.974a2 2 0 0 1 1.837 0l7.948 3.974A2 2 0 0 1 22 8z',
    ), // key: doq5xv
    ElIconPathElement('M6 13h12'), // key: yf64js
    ElIconPathElement('M6 17h12'), // key: 1jwigz
  ]);

  /// `washing-machine.mjs`
  static const ElLucideGlyph washingMachine = ElLucideGlyph(
    'washing-machine',
    <ElIconElement>[
      ElIconPathElement('M3 6h3'), // key: 155dbl
      ElIconPathElement('M17 6h.01'), // key: e2y6kg
      ElIconRectElement(3, 2, 18, 20, 2), // key: od3kk9
      ElIconCircleElement(12, 13, 5), // key: nlbqau
      ElIconPathElement(
        'M12 18a2.5 2.5 0 0 0 0-5 2.5 2.5 0 0 1 0-5',
      ), // key: 17lach
    ],
  );

  /// `watch.mjs`
  static const ElLucideGlyph watch = ElLucideGlyph('watch', <ElIconElement>[
    ElIconPathElement('M12 10v2.2l1.6 1'), // key: n3r21l
    ElIconPathElement(
      'm16.13 7.66-.81-4.05a2 2 0 0 0-2-1.61h-2.68a2 2 0 0 0-2 1.61l-.78 4.05',
    ), // key: 18k57s
    ElIconPathElement(
      'm7.88 16.36.8 4a2 2 0 0 0 2 1.61h2.72a2 2 0 0 0 2-1.61l.81-4.05',
    ), // key: 16ny36
    ElIconCircleElement(12, 12, 6), // key: 1vlfrh
  ]);

  /// `waves-arrow-down.mjs`
  static const ElLucideGlyph
  wavesArrowDown = ElLucideGlyph('waves-arrow-down', <ElIconElement>[
    ElIconPathElement('M12 10L12 2'), // key: jvb0aw
    ElIconPathElement('M16 6L12 10L8 6'), // key: 9j6vje
    ElIconPathElement(
      'M2 15C2.6 15.5 3.2 16 4.5 16C7 16 7 14 9.5 14C12.1 14 11.9 16 14.5 16C17 16 17 14 19.5 14C20.8 14 21.4 14.5 22 15',
    ), // key: s2zepw
    ElIconPathElement(
      'M2 21C2.6 21.5 3.2 22 4.5 22C7 22 7 20 9.5 20C12.1 20 11.9 22 14.5 22C17 22 17 20 19.5 20C20.8 20 21.4 20.5 22 21',
    ), // key: u68omc
  ]);

  /// `waves-arrow-up.mjs`
  static const ElLucideGlyph
  wavesArrowUp = ElLucideGlyph('waves-arrow-up', <ElIconElement>[
    ElIconPathElement('M12 2v8'), // key: 1q4o3n
    ElIconPathElement(
      'M2 15c.6.5 1.2 1 2.5 1 2.5 0 2.5-2 5-2 2.6 0 2.4 2 5 2 2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1',
    ), // key: 1p9f19
    ElIconPathElement(
      'M2 21c.6.5 1.2 1 2.5 1 2.5 0 2.5-2 5-2 2.6 0 2.4 2 5 2 2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1',
    ), // key: vbxynw
    ElIconPathElement('m8 6 4-4 4 4'), // key: ybng9g
  ]);

  /// `waves-horizontal.mjs`
  static const ElLucideGlyph wavesHorizontal = ElLucideGlyph(
    'waves-horizontal',
    <ElIconElement>[
      ElIconPathElement('M2 12q2.5 2 5 0t5 0 5 0 5 0'), // key: 8ddzzs
      ElIconPathElement('M2 19q2.5 2 5 0t5 0 5 0 5 0'), // key: 1wj4st
      ElIconPathElement('M2 5q2.5 2 5 0t5 0 5 0 5 0'), // key: 69x50u
    ],
  );

  /// `waves-ladder.mjs`
  static const ElLucideGlyph
  wavesLadder = ElLucideGlyph('waves-ladder', <ElIconElement>[
    ElIconPathElement('M19 5a2 2 0 0 0-2 2v11'), // key: s41o68
    ElIconPathElement(
      'M2 18c.6.5 1.2 1 2.5 1 2.5 0 2.5-2 5-2 2.6 0 2.4 2 5 2 2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1',
    ), // key: rd2r6e
    ElIconPathElement('M7 13h10'), // key: 1rwob1
    ElIconPathElement('M7 9h10'), // key: 12czzb
    ElIconPathElement('M9 5a2 2 0 0 0-2 2v11'), // key: x0q4gh
  ]);

  /// `waves-vertical.mjs`
  static const ElLucideGlyph wavesVertical = ElLucideGlyph(
    'waves-vertical',
    <ElIconElement>[
      ElIconPathElement('M12 2q2 2.5 0 5t0 5 0 5 0 5'), // key: 13jdbg
      ElIconPathElement('M19 2q2 2.5 0 5t0 5 0 5 0 5'), // key: 1ozhzu
      ElIconPathElement('M5 2q2 2.5 0 5t0 5 0 5 0 5'), // key: 1bi6v5
    ],
  );

  /// `waypoints.mjs`
  static const ElLucideGlyph waypoints = ElLucideGlyph(
    'waypoints',
    <ElIconElement>[
      ElIconPathElement('m10.586 5.414-5.172 5.172'), // key: 4mc350
      ElIconPathElement('m18.586 13.414-5.172 5.172'), // key: 8c96vv
      ElIconPathElement('M6 12h12'), // key: 8npq4p
      ElIconCircleElement(12, 20, 2), // key: 144qzu
      ElIconCircleElement(12, 4, 2), // key: muu5ef
      ElIconCircleElement(20, 12, 2), // key: 1xzzfp
      ElIconCircleElement(4, 12, 2), // key: 1hvhnz
    ],
  );

  /// `webcam-off.mjs`
  static const ElLucideGlyph webcamOff = ElLucideGlyph(
    'webcam-off',
    <ElIconElement>[
      ElIconPathElement('M12 22v-4'), // key: 1utk9m
      ElIconPathElement('M12.754 7.096a3 3 0 0 1 2.15 2.15'), // key: 1v0qsm
      ElIconPathElement('M12.863 12.873a3 3 0 0 1-3.736-3.735'), // key: 13aqxl
      ElIconPathElement('M16.566 16.57A8 8 0 0 1 5.43 5.433'), // key: 1hliph
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
      ElIconPathElement('M7 22h10'), // key: 10w4w3
      ElIconPathElement('M8.478 2.817a8 8 0 0 1 10.705 10.705'), // key: r097k8
    ],
  );

  /// `webcam.mjs`
  static const ElLucideGlyph webcam = ElLucideGlyph('webcam', <ElIconElement>[
    ElIconCircleElement(12, 10, 8), // key: 1gshiw
    ElIconCircleElement(12, 10, 3), // key: ilqhr7
    ElIconPathElement('M7 22h10'), // key: 10w4w3
    ElIconPathElement('M12 22v-4'), // key: 1utk9m
  ]);

  /// `webhook-off.mjs`
  static const ElLucideGlyph webhookOff = ElLucideGlyph(
    'webhook-off',
    <ElIconElement>[
      ElIconPathElement(
        'M17 17h-5c-1.09-.02-1.94.92-2.5 1.9A3 3 0 1 1 2.57 15',
      ), // key: 1tvl6x
      ElIconPathElement('M9 3.4a4 4 0 0 1 6.52.66'), // key: q04jfq
      ElIconPathElement('m6 17 3.1-5.8a2.5 2.5 0 0 0 .057-2.05'), // key: azowf0
      ElIconPathElement('M20.3 20.3a4 4 0 0 1-2.3.7'), // key: 5joiws
      ElIconPathElement('M18.6 13a4 4 0 0 1 3.357 3.414'), // key: cangb8
      ElIconPathElement('m12 6 .6 1'), // key: tpjl1n
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ],
  );

  /// `webhook.mjs`
  static const ElLucideGlyph webhook = ElLucideGlyph('webhook', <ElIconElement>[
    ElIconPathElement(
      'M18 16.98h-5.99c-1.1 0-1.95.94-2.48 1.9A4 4 0 0 1 2 17c.01-.7.2-1.4.57-2',
    ), // key: q3hayz
    ElIconPathElement(
      'm6 17 3.13-5.78c.53-.97.1-2.18-.5-3.1a4 4 0 1 1 6.89-4.06',
    ), // key: 1go1hn
    ElIconPathElement(
      'm12 6 3.13 5.73C15.66 12.7 16.9 13 18 13a4 4 0 0 1 0 8',
    ), // key: qlwsc0
  ]);

  /// `weight-tilde.mjs`
  static const ElLucideGlyph
  weightTilde = ElLucideGlyph('weight-tilde', <ElIconElement>[
    ElIconPathElement(
      'M6.5 8a2 2 0 0 0-1.906 1.46L2.1 18.5A2 2 0 0 0 4 21h16a2 2 0 0 0 1.925-2.54L19.4 9.5A2 2 0 0 0 17.48 8z',
    ), // key: 1wl739
    ElIconPathElement(
      'M7.999 15a2.5 2.5 0 0 1 4 0 2.5 2.5 0 0 0 4 0',
    ), // key: 1egezo
    ElIconCircleElement(12, 5, 3), // key: rqqgnr
  ]);

  /// `weight.mjs`
  static const ElLucideGlyph weight = ElLucideGlyph('weight', <ElIconElement>[
    ElIconCircleElement(12, 5, 3), // key: rqqgnr
    ElIconPathElement(
      'M6.5 8a2 2 0 0 0-1.905 1.46L2.1 18.5A2 2 0 0 0 4 21h16a2 2 0 0 0 1.925-2.54L19.4 9.5A2 2 0 0 0 17.48 8Z',
    ), // key: 56o5sh
  ]);

  /// `wheat-off.mjs`
  static const ElLucideGlyph
  wheatOff = ElLucideGlyph('wheat-off', <ElIconElement>[
    ElIconPathElement('m2 22 10-10'), // key: 28ilpk
    ElIconPathElement('m16 8-1.17 1.17'), // key: 1qqm82
    ElIconPathElement(
      'M3.47 12.53 5 11l1.53 1.53a3.5 3.5 0 0 1 0 4.94L5 19l-1.53-1.53a3.5 3.5 0 0 1 0-4.94Z',
    ), // key: 1rdhi6
    ElIconPathElement(
      'm8 8-.53.53a3.5 3.5 0 0 0 0 4.94L9 15l1.53-1.53c.55-.55.88-1.25.98-1.97',
    ), // key: 4wz8re
    ElIconPathElement(
      'M10.91 5.26c.15-.26.34-.51.56-.73L13 3l1.53 1.53a3.5 3.5 0 0 1 .28 4.62',
    ), // key: rves66
    ElIconPathElement(
      'M20 2h2v2a4 4 0 0 1-4 4h-2V6a4 4 0 0 1 4-4Z',
    ), // key: 19rau1
    ElIconPathElement(
      'M11.47 17.47 13 19l-1.53 1.53a3.5 3.5 0 0 1-4.94 0L5 19l1.53-1.53a3.5 3.5 0 0 1 4.94 0Z',
    ), // key: tc8ph9
    ElIconPathElement(
      'm16 16-.53.53a3.5 3.5 0 0 1-4.94 0L9 15l1.53-1.53a3.49 3.49 0 0 1 1.97-.98',
    ), // key: ak46r
    ElIconPathElement(
      'M18.74 13.09c.26-.15.51-.34.73-.56L21 11l-1.53-1.53a3.5 3.5 0 0 0-4.62-.28',
    ), // key: 1tw520
    ElIconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `wheat.mjs`
  static const ElLucideGlyph wheat = ElLucideGlyph('wheat', <ElIconElement>[
    ElIconPathElement('M2 22 16 8'), // key: 60hf96
    ElIconPathElement(
      'M3.47 12.53 5 11l1.53 1.53a3.5 3.5 0 0 1 0 4.94L5 19l-1.53-1.53a3.5 3.5 0 0 1 0-4.94Z',
    ), // key: 1rdhi6
    ElIconPathElement(
      'M7.47 8.53 9 7l1.53 1.53a3.5 3.5 0 0 1 0 4.94L9 15l-1.53-1.53a3.5 3.5 0 0 1 0-4.94Z',
    ), // key: 1sdzmb
    ElIconPathElement(
      'M11.47 4.53 13 3l1.53 1.53a3.5 3.5 0 0 1 0 4.94L13 11l-1.53-1.53a3.5 3.5 0 0 1 0-4.94Z',
    ), // key: eoatbi
    ElIconPathElement(
      'M20 2h2v2a4 4 0 0 1-4 4h-2V6a4 4 0 0 1 4-4Z',
    ), // key: 19rau1
    ElIconPathElement(
      'M11.47 17.47 13 19l-1.53 1.53a3.5 3.5 0 0 1-4.94 0L5 19l1.53-1.53a3.5 3.5 0 0 1 4.94 0Z',
    ), // key: tc8ph9
    ElIconPathElement(
      'M15.47 13.47 17 15l-1.53 1.53a3.5 3.5 0 0 1-4.94 0L9 15l1.53-1.53a3.5 3.5 0 0 1 4.94 0Z',
    ), // key: 2m8kc5
    ElIconPathElement(
      'M19.47 9.47 21 11l-1.53 1.53a3.5 3.5 0 0 1-4.94 0L13 11l1.53-1.53a3.5 3.5 0 0 1 4.94 0Z',
    ), // key: vex3ng
  ]);

  /// `whole-word.mjs`
  static const ElLucideGlyph wholeWord = ElLucideGlyph(
    'whole-word',
    <ElIconElement>[
      ElIconCircleElement(7, 12, 3), // key: 12clwm
      ElIconPathElement('M10 9v6'), // key: 17i7lo
      ElIconCircleElement(17, 12, 3), // key: gl7c2s
      ElIconPathElement('M14 7v8'), // key: dl84cr
      ElIconPathElement(
        'M22 17v1c0 .5-.5 1-1 1H3c-.5 0-1-.5-1-1v-1',
      ), // key: lt2kga
    ],
  );

  /// `wifi-cog.mjs`
  static const ElLucideGlyph wifiCog = ElLucideGlyph(
    'wifi-cog',
    <ElIconElement>[
      ElIconPathElement('m14.305 19.53.923-.382'), // key: 3m78fa
      ElIconPathElement('m15.228 16.852-.923-.383'), // key: npixar
      ElIconPathElement('m16.852 15.228-.383-.923'), // key: 5xggr7
      ElIconPathElement('m16.852 20.772-.383.924'), // key: dpfhf9
      ElIconPathElement('m19.148 15.228.383-.923'), // key: 1reyyz
      ElIconPathElement('m19.53 21.696-.382-.924'), // key: 1goivc
      ElIconPathElement('M2 7.82a15 15 0 0 1 20 0'), // key: 1ovjuk
      ElIconPathElement('m20.772 16.852.924-.383'), // key: htqkph
      ElIconPathElement('m20.772 19.148.924.383'), // key: 9w9pjp
      ElIconPathElement('M5 11.858a10 10 0 0 1 11.5-1.785'), // key: 3sn16i
      ElIconPathElement('M8.5 15.429a5 5 0 0 1 2.413-1.31'), // key: 1pxovh
      ElIconCircleElement(18, 18, 3), // key: 1xkwt0
    ],
  );

  /// `wifi-high.mjs`
  static const ElLucideGlyph wifiHigh = ElLucideGlyph(
    'wifi-high',
    <ElIconElement>[
      ElIconPathElement('M12 20h.01'), // key: zekei9
      ElIconPathElement('M5 12.859a10 10 0 0 1 14 0'), // key: 1x1e6c
      ElIconPathElement('M8.5 16.429a5 5 0 0 1 7 0'), // key: 1bycff
    ],
  );

  /// `wifi-low.mjs`
  static const ElLucideGlyph wifiLow = ElLucideGlyph(
    'wifi-low',
    <ElIconElement>[
      ElIconPathElement('M12 20h.01'), // key: zekei9
      ElIconPathElement('M8.5 16.429a5 5 0 0 1 7 0'), // key: 1bycff
    ],
  );

  /// `wifi-off.mjs`
  static const ElLucideGlyph wifiOff = ElLucideGlyph(
    'wifi-off',
    <ElIconElement>[
      ElIconPathElement('M12 20h.01'), // key: zekei9
      ElIconPathElement('M8.5 16.429a5 5 0 0 1 7 0'), // key: 1bycff
      ElIconPathElement('M5 12.859a10 10 0 0 1 5.17-2.69'), // key: 1dl1wf
      ElIconPathElement('M19 12.859a10 10 0 0 0-2.007-1.523'), // key: 4k23kn
      ElIconPathElement('M2 8.82a15 15 0 0 1 4.177-2.643'), // key: 1grhjp
      ElIconPathElement('M22 8.82a15 15 0 0 0-11.288-3.764'), // key: z3jwby
      ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ],
  );

  /// `wifi-pen.mjs`
  static const ElLucideGlyph
  wifiPen = ElLucideGlyph('wifi-pen', <ElIconElement>[
    ElIconPathElement('M2 8.82a15 15 0 0 1 20 0'), // key: dnpr2z
    ElIconPathElement(
      'M21.378 16.626a1 1 0 0 0-3.004-3.004l-4.01 4.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z',
    ), // key: 1817ys
    ElIconPathElement('M5 12.859a10 10 0 0 1 10.5-2.222'), // key: rpb7oy
    ElIconPathElement('M8.5 16.429a5 5 0 0 1 3-1.406'), // key: r8bmzl
  ]);

  /// `wifi-sync.mjs`
  static const ElLucideGlyph wifiSync = ElLucideGlyph(
    'wifi-sync',
    <ElIconElement>[
      ElIconPathElement(
        'M11.965 10.105v4L13.5 12.5a5 5 0 0 1 8 1.5',
      ), // key: 1immaq
      ElIconPathElement('M11.965 14.105h4'), // key: uejny8
      ElIconPathElement(
        'M17.965 18.105h4L20.43 19.71a5 5 0 0 1-8-1.5',
      ), // key: 1i3a7e
      ElIconPathElement('M2 8.82a15 15 0 0 1 20 0'), // key: dnpr2z
      ElIconPathElement('M21.965 22.105v-4'), // key: 1ku6vx
      ElIconPathElement('M5 12.86a10 10 0 0 1 3-2.032'), // key: pemdtu
      ElIconPathElement('M8.5 16.429h.01'), // key: 2bm739
    ],
  );

  /// `wifi-zero.mjs`
  static const ElLucideGlyph wifiZero = ElLucideGlyph(
    'wifi-zero',
    <ElIconElement>[
      ElIconPathElement('M12 20h.01'), // key: zekei9
    ],
  );

  /// `wifi.mjs`
  static const ElLucideGlyph wifi = ElLucideGlyph('wifi', <ElIconElement>[
    ElIconPathElement('M12 20h.01'), // key: zekei9
    ElIconPathElement('M2 8.82a15 15 0 0 1 20 0'), // key: dnpr2z
    ElIconPathElement('M5 12.859a10 10 0 0 1 14 0'), // key: 1x1e6c
    ElIconPathElement('M8.5 16.429a5 5 0 0 1 7 0'), // key: 1bycff
  ]);

  /// `wind-arrow-down.mjs`
  static const ElLucideGlyph windArrowDown = ElLucideGlyph(
    'wind-arrow-down',
    <ElIconElement>[
      ElIconPathElement('M10 2v8'), // key: d4bbey
      ElIconPathElement('M12.8 21.6A2 2 0 1 0 14 18H2'), // key: 19kp1d
      ElIconPathElement('M17.5 10a2.5 2.5 0 1 1 2 4H2'), // key: 19kpjc
      ElIconPathElement('m6 6 4 4 4-4'), // key: k13n16
    ],
  );

  /// `wind.mjs`
  static const ElLucideGlyph wind = ElLucideGlyph('wind', <ElIconElement>[
    ElIconPathElement('M12.8 19.6A2 2 0 1 0 14 16H2'), // key: 148xed
    ElIconPathElement('M17.5 8a2.5 2.5 0 1 1 2 4H2'), // key: 1u4tom
    ElIconPathElement('M9.8 4.4A2 2 0 1 1 11 8H2'), // key: 75valh
  ]);

  /// `wine-off.mjs`
  static const ElLucideGlyph
  wineOff = ElLucideGlyph('wine-off', <ElIconElement>[
    ElIconPathElement('M8 22h8'), // key: rmew8v
    ElIconPathElement('M7 10h3m7 0h-1.343'), // key: v48bem
    ElIconPathElement('M12 15v7'), // key: t2xh3l
    ElIconPathElement(
      'M7.307 7.307A12.33 12.33 0 0 0 7 10a5 5 0 0 0 7.391 4.391M8.638 2.981C8.75 2.668 8.872 2.34 9 2h6c1.5 4 2 6 2 8 0 .407-.05.809-.145 1.198',
    ), // key: 1ymjlu
    ElIconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `wine.mjs`
  static const ElLucideGlyph wine = ElLucideGlyph('wine', <ElIconElement>[
    ElIconPathElement('M8 22h8'), // key: rmew8v
    ElIconPathElement('M7 10h10'), // key: 1101jm
    ElIconPathElement('M12 15v7'), // key: t2xh3l
    ElIconPathElement(
      'M12 15a5 5 0 0 0 5-5c0-2-.5-4-2-8H9c-1.5 4-2 6-2 8a5 5 0 0 0 5 5Z',
    ), // key: 10ffi3
  ]);

  /// `workflow.mjs`
  static const ElLucideGlyph workflow = ElLucideGlyph(
    'workflow',
    <ElIconElement>[
      ElIconRectElement(3, 3, 8, 8, 2), // key: by2w9f
      ElIconPathElement('M7 11v4a2 2 0 0 0 2 2h4'), // key: xkn7yn
      ElIconRectElement(13, 13, 8, 8, 2), // key: 1cgmvn
    ],
  );

  /// `worm.mjs`
  static const ElLucideGlyph worm = ElLucideGlyph('worm', <ElIconElement>[
    ElIconPathElement('m19 12-1.5 3'), // key: 9bcu4o
    ElIconPathElement('M19.63 18.81 22 20'), // key: 121v98
    ElIconPathElement(
      'M6.47 8.23a1.68 1.68 0 0 1 2.44 1.93l-.64 2.08a6.76 6.76 0 0 0 10.16 7.67l.42-.27a1 1 0 1 0-2.73-4.21l-.42.27a1.76 1.76 0 0 1-2.63-1.99l.64-2.08A6.66 6.66 0 0 0 3.94 3.9l-.7.4a1 1 0 1 0 2.55 4.34z',
    ), // key: 1tij6q
  ]);

  /// `wrench-off.mjs`
  static const ElLucideGlyph
  wrenchOff = ElLucideGlyph('wrench-off', <ElIconElement>[
    ElIconPathElement(
      'M10.747 5.093a6 6 0 0 1 6.841-2.882c.438.12.54.662.219.984L14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.106-3.105c.32-.322.863-.22.983.218a6 6 0 0 1-2.882 6.842',
    ), // key: sded7h
    ElIconPathElement(
      'm13.5 13.5-7.88 7.88a1 1 0 0 1-2.999-3l7.88-7.88',
    ), // key: 66etnh
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `wrench.mjs`
  static const ElLucideGlyph wrench = ElLucideGlyph('wrench', <ElIconElement>[
    ElIconPathElement(
      'M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.106-3.105c.32-.322.863-.22.983.218a6 6 0 0 1-8.259 7.057l-7.91 7.91a1 1 0 0 1-2.999-3l7.91-7.91a6 6 0 0 1 7.057-8.259c.438.12.54.662.219.984z',
    ), // key: 1ngwbx
  ]);

  /// `x-line-top.mjs`
  static const ElLucideGlyph xLineTop = ElLucideGlyph(
    'x-line-top',
    <ElIconElement>[
      ElIconPathElement('M18 4H6'), // key: 1hsngl
      ElIconPathElement('M18 8 6 20'), // key: xspwia
      ElIconPathElement('m6 8 12 12'), // key: qb1veh
    ],
  );

  /// `x.mjs`
  static const ElLucideGlyph x = ElLucideGlyph('x', <ElIconElement>[
    ElIconPathElement('M18 6 6 18'), // key: 1bl5f8
    ElIconPathElement('m6 6 12 12'), // key: d8bk6v
  ]);

  /// `zap-off.mjs`
  static const ElLucideGlyph zapOff = ElLucideGlyph('zap-off', <ElIconElement>[
    ElIconPathElement(
      'M10.768 5.111 13.44 2.44a1.5 1.5 0 012.474 1.561l-1.633 4.625',
    ), // key: l6h226
    ElIconPathElement(
      'm18.889 13.232.672-.672A1.5 1.5 0 0018.5 10h-2.844',
    ), // key: 1717b9
    ElIconPathElement('m2 2 20 20'), // key: 1ooewy
    ElIconPathElement(
      'm7.94 7.94-3.5 3.499A1.5 1.5 0 005.5 14h4.002a.5.5 0 01.471.666L8.086 20a1.5 1.5 0 002.475 1.56l5.5-5.5',
    ), // key: 1bjzrh
  ]);

  /// `zap.mjs`
  static const ElLucideGlyph zap = ElLucideGlyph('zap', <ElIconElement>[
    ElIconPathElement(
      'M15.914 4a1.5 1.5 0 00-2.474-1.561l-9 9A1.5 1.5 0 005.5 14h4.002a.5.5 0 01.471.666L8.086 20a1.5 1.5 0 002.475 1.56l9-9A1.5 1.5 0 0018.5 10h-3.997a.5.5 0 01-.472-.667z',
    ), // key: 1v7up4
  ]);

  /// `zodiac-aquarius.mjs`
  static const ElLucideGlyph
  zodiacAquarius = ElLucideGlyph('zodiac-aquarius', <ElIconElement>[
    ElIconPathElement(
      'm2 10 2.456-3.684a.7.7 0 0 1 1.106-.013l2.39 3.413a.7.7 0 0 0 1.096-.001l2.402-3.432a.7.7 0 0 1 1.098 0l2.402 3.432a.7.7 0 0 0 1.098 0l2.389-3.413a.7.7 0 0 1 1.106.013L22 10',
    ), // key: 1o8iok
    ElIconPathElement(
      'm2 18.002 2.456-3.684a.7.7 0 0 1 1.106-.013l2.39 3.413a.7.7 0 0 0 1.097 0l2.402-3.432a.7.7 0 0 1 1.098 0l2.402 3.432a.7.7 0 0 0 1.098 0l2.389-3.413a.7.7 0 0 1 1.106.013L22 18.002',
    ), // key: 112qy7
  ]);

  /// `zodiac-aries.mjs`
  static const ElLucideGlyph zodiacAries = ElLucideGlyph(
    'zodiac-aries',
    <ElIconElement>[
      ElIconPathElement('M12 7.5a4.5 4.5 0 1 1 5 4.5'), // key: k987hv
      ElIconPathElement('M7 12a4.5 4.5 0 1 1 5-4.5V21'), // key: mjup0w
    ],
  );

  /// `zodiac-cancer.mjs`
  static const ElLucideGlyph zodiacCancer = ElLucideGlyph(
    'zodiac-cancer',
    <ElIconElement>[
      ElIconPathElement('M21 14.5A9 6.5 0 0 1 5.5 19'), // key: 1xj2o6
      ElIconPathElement('M3 9.5A9 6.5 0 0 1 18.5 5'), // key: 1gln3t
      ElIconCircleElement(17.5, 14.5, 3.5), // key: 1ccu1t
      ElIconCircleElement(6.5, 9.5, 3.5), // key: x5tc2d
    ],
  );

  /// `zodiac-capricorn.mjs`
  static const ElLucideGlyph
  zodiacCapricorn = ElLucideGlyph('zodiac-capricorn', <ElIconElement>[
    ElIconPathElement('M11 21a3 3 0 0 0 3-3V6.5a1 1 0 0 0-7 0'), // key: 1kkncs
    ElIconPathElement('M7 19V6a3 3 0 0 0-3-3h0'), // key: 1jg5y1
    ElIconCircleElement(17, 17, 3), // key: 18b49y
  ]);

  /// `zodiac-gemini.mjs`
  static const ElLucideGlyph zodiacGemini = ElLucideGlyph(
    'zodiac-gemini',
    <ElIconElement>[
      ElIconPathElement('M16 4.525v14.948'), // key: bgoxo0
      ElIconPathElement('M20 3A17 17 0 0 1 4 3'), // key: 1djemw
      ElIconPathElement('M4 21a17 17 0 0 1 16 0'), // key: onoyo7
      ElIconPathElement('M8 4.525v14.948'), // key: u5iyof
    ],
  );

  /// `zodiac-leo.mjs`
  static const ElLucideGlyph
  zodiacLeo = ElLucideGlyph('zodiac-leo', <ElIconElement>[
    ElIconPathElement(
      'M10 16c0-4-3-4.5-3-8a5 5 0 0 1 10 0c0 3.466-3 6.196-3 10a3 3 0 0 0 6 0',
    ), // key: 1qj6nb
    ElIconCircleElement(7, 16, 3), // key: yyv3zl
  ]);

  /// `zodiac-libra.mjs`
  static const ElLucideGlyph
  zodiacLibra = ElLucideGlyph('zodiac-libra', <ElIconElement>[
    ElIconPathElement(
      'M3 16h6.857c.162-.012.19-.323.038-.38a6 6 0 1 1 4.212 0c-.153.057-.125.368.038.38H21',
    ), // key: 1novf0
    ElIconPathElement('M3 20h18'), // key: 1l19wn
  ]);

  /// `zodiac-ophiuchus.mjs`
  static const ElLucideGlyph zodiacOphiuchus = ElLucideGlyph(
    'zodiac-ophiuchus',
    <ElIconElement>[
      ElIconPathElement(
        'M3 10A6.06 6.06 0 0 1 12 10 A6.06 6.06 0 0 0 21 10',
      ), // key: 13lfmc
      ElIconPathElement('M6 3v12a6 6 0 0 0 12 0V3'), // key: 1jnivp
    ],
  );

  /// `zodiac-pisces.mjs`
  static const ElLucideGlyph zodiacPisces = ElLucideGlyph(
    'zodiac-pisces',
    <ElIconElement>[
      ElIconPathElement('M19 21a15 15 0 0 1 0-18'), // key: br2vug
      ElIconPathElement('M20 12H4'), // key: 1mtusc
      ElIconPathElement('M5 3a15 15 0 0 1 0 18'), // key: 1w7hae
    ],
  );

  /// `zodiac-sagittarius.mjs`
  static const ElLucideGlyph zodiacSagittarius = ElLucideGlyph(
    'zodiac-sagittarius',
    <ElIconElement>[
      ElIconPathElement('M15 3h6v6'), // key: 1q9fwt
      ElIconPathElement('M21 3 3 21'), // key: 1011np
      ElIconPathElement('m9 9 6 6'), // key: z0biqf
    ],
  );

  /// `zodiac-scorpio.mjs`
  static const ElLucideGlyph zodiacScorpio = ElLucideGlyph(
    'zodiac-scorpio',
    <ElIconElement>[
      ElIconPathElement(
        'M10 19V5.5a1 1 0 0 1 5 0V17a2 2 0 0 0 2 2h5l-3-3',
      ), // key: 1w8g0z
      ElIconPathElement('m22 19-3 3'), // key: 1ix4wq
      ElIconPathElement('M5 19V5.5a1 1 0 0 1 5 0'), // key: 1d4oa3
      ElIconPathElement('M5 5.5A2.5 2.5 0 0 0 2.5 3'), // key: gp646f
    ],
  );

  /// `zodiac-taurus.mjs`
  static const ElLucideGlyph zodiacTaurus = ElLucideGlyph(
    'zodiac-taurus',
    <ElIconElement>[
      ElIconCircleElement(12, 15, 6), // key: lhqcmb
      ElIconPathElement('M18 3A6 6 0 0 1 6 3'), // key: 1p399e
    ],
  );

  /// `zodiac-virgo.mjs`
  static const ElLucideGlyph
  zodiacVirgo = ElLucideGlyph('zodiac-virgo', <ElIconElement>[
    ElIconPathElement('M11 5.5a1 1 0 0 1 5 0V16a5 5 0 0 0 5 5'), // key: 1szkuh
    ElIconPathElement('M16 11.5a1 1 0 0 1 5 0V16a5 5 0 0 1-5 5'), // key: pyq0k2
    ElIconPathElement('M6 19V6a3 3 0 0 0-3-3h0'), // key: pvee4g
    ElIconPathElement('M6 5.5a1 1 0 0 1 5 0V19'), // key: vncctg
  ]);

  /// `zoom-in.mjs`
  static const ElLucideGlyph zoomIn = ElLucideGlyph('zoom-in', <ElIconElement>[
    ElIconCircleElement(11, 11, 8), // key: 4ej97u
    ElIconLineElement(21, 21, 16.65, 16.65), // key: 13gj7c
    ElIconLineElement(11, 8, 11, 14), // key: 1vmskp
    ElIconLineElement(8, 11, 14, 11), // key: durymu
  ]);

  /// `zoom-out.mjs`
  static const ElLucideGlyph zoomOut = ElLucideGlyph(
    'zoom-out',
    <ElIconElement>[
      ElIconCircleElement(11, 11, 8), // key: 4ej97u
      ElIconLineElement(21, 21, 16.65, 16.65), // key: 13gj7c
      ElIconLineElement(8, 11, 14, 11), // key: durymu
    ],
  );
}
