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
/// `static const` field is dropped when nothing names it, so `DsLucide.zap`
/// pulls in `zap` and nothing else. A `const Map<DsIconGlyph, …>` is one
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
class DsLucideGlyph {
  const DsLucideGlyph(this.name, this.nodes);

  /// The lucide module name, kebab-case: `'circle-dollar-sign'`.
  final String name;

  /// `__iconNode`, in lucide's order, which is paint order.
  final List<DsIconElement> nodes;

  /// The glyph as one [Path] in 24-unit coordinates — the caller scales.
  ///
  /// A **fresh** path every call: [Path] is mutable, and a shared instance
  /// would let one painter corrupt every other icon.
  Path toPath() {
    final Path path = Path();
    for (final DsIconElement node in nodes) {
      node.addTo(path);
    }
    return path;
  }

  /// The `fill="currentColor"` nodes as one [Path], or `null` when there are
  /// none. 19 nodes across 9 glyphs carry the attribute.
  Path? toFillPath() {
    Path? path;
    for (final DsIconElement node in nodes) {
      if (!node.filled) continue;
      node.addTo(path ??= Path());
    }
    return path;
  }

  @override
  String toString() => 'DsLucideGlyph($name)';
}

/// Every glyph lucide 1.28.0 ships.
class DsLucide {
  const DsLucide._();

  /// The viewBox lucide authors on — the same 24×24 grid as [DsIconPaths].
  static const double viewBox = 24;

  /// `a-arrow-down.mjs`
  static const DsLucideGlyph aArrowDown =
      DsLucideGlyph('a-arrow-down', <DsIconElement>[
    DsIconPathElement('m14 12 4 4 4-4'), // key: buelq4
    DsIconPathElement('M18 16V7'), // key: ty0viw
    DsIconPathElement('m2 16 4.039-9.69a.5.5 0 0 1 .923 0L11 16'), // key: d5nyq2
    DsIconPathElement('M3.304 13h6.392'), // key: 1q3zxz
  ]);

  /// `a-arrow-up.mjs`
  static const DsLucideGlyph aArrowUp =
      DsLucideGlyph('a-arrow-up', <DsIconElement>[
    DsIconPathElement('m14 11 4-4 4 4'), // key: 1pu57t
    DsIconPathElement('M18 16V7'), // key: ty0viw
    DsIconPathElement('m2 16 4.039-9.69a.5.5 0 0 1 .923 0L11 16'), // key: d5nyq2
    DsIconPathElement('M3.304 13h6.392'), // key: 1q3zxz
  ]);

  /// `a-large-small.mjs`
  static const DsLucideGlyph aLargeSmall =
      DsLucideGlyph('a-large-small', <DsIconElement>[
    DsIconPathElement('m15 16 2.536-7.328a1.02 1.02 1 0 1 1.928 0L22 16'), // key: xik6mr
    DsIconPathElement('M15.697 14h5.606'), // key: 1stdlc
    DsIconPathElement('m2 16 4.039-9.69a.5.5 0 0 1 .923 0L11 16'), // key: d5nyq2
    DsIconPathElement('M3.304 13h6.392'), // key: 1q3zxz
  ]);

  /// `accessibility.mjs`
  static const DsLucideGlyph accessibility =
      DsLucideGlyph('accessibility', <DsIconElement>[
    DsIconCircleElement(16, 4, 1), // key: 1grugj
    DsIconPathElement('m18 19 1-7-6 1'), // key: r0i19z
    DsIconPathElement('m5 8 3-3 5.5 3-2.36 3.5'), // key: 9ptxx2
    DsIconPathElement('M4.24 14.5a5 5 0 0 0 6.88 6'), // key: 10kmtu
    DsIconPathElement('M13.76 17.5a5 5 0 0 0-6.88-6'), // key: 2qq6rc
  ]);

  /// `activity.mjs`
  static const DsLucideGlyph activity =
      DsLucideGlyph('activity', <DsIconElement>[
    DsIconPathElement('M22 12h-2.48a2 2 0 0 0-1.93 1.46l-2.35 8.36a.25.25 0 0 1-.48 0L9.24 2.18a.25.25 0 0 0-.48 0l-2.35 8.36A2 2 0 0 1 4.49 12H2'), // key: 169zse
  ]);

  /// `ad.mjs`
  static const DsLucideGlyph ad =
      DsLucideGlyph('ad', <DsIconElement>[
    DsIconPathElement('M10 13H6'), // key: 18d9xh
    DsIconPathElement('M10 15v-4a2 2 0 0 0-4 0v4'), // key: ss28p3
    DsIconPathElement('M14 14.5a.5.5 0 0 0 .5.5h1a2.5 2.5 0 0 0 2.5-2.5v-1A2.5 2.5 0 0 0 15.5 9h-1a.5.5 0 0 0-.5.5z'), // key: b3f847
    DsIconRectElement(2, 5, 20, 14, 2), // key: qneu4z
  ]);

  /// `air-vent.mjs`
  static const DsLucideGlyph airVent =
      DsLucideGlyph('air-vent', <DsIconElement>[
    DsIconPathElement('M18 17.5a2.5 2.5 0 1 1-4 2.03V12'), // key: yd12zl
    DsIconPathElement('M6 12H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2'), // key: larmp2
    DsIconPathElement('M6 8h12'), // key: 6g4wlu
    DsIconPathElement('M6.6 15.572A2 2 0 1 0 10 17v-5'), // key: 1x1kqn
  ]);

  /// `airplay.mjs`
  static const DsLucideGlyph airplay =
      DsLucideGlyph('airplay', <DsIconElement>[
    DsIconPathElement('M5 17H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-1'), // key: ns4c3b
    DsIconPathElement('m12 15 5 6H7Z'), // key: 14qnn2
  ]);

  /// `alarm-clock-check.mjs`
  static const DsLucideGlyph alarmClockCheck =
      DsLucideGlyph('alarm-clock-check', <DsIconElement>[
    DsIconCircleElement(12, 13, 8), // key: 3y4lt7
    DsIconPathElement('M5 3 2 6'), // key: 18tl5t
    DsIconPathElement('m22 6-3-3'), // key: 1opdir
    DsIconPathElement('M6.38 18.7 4 21'), // key: 17xu3x
    DsIconPathElement('M17.64 18.67 20 21'), // key: kv2oe2
    DsIconPathElement('m9 13 2 2 4-4'), // key: 6343dt
  ]);

  /// `alarm-clock-minus.mjs`
  static const DsLucideGlyph alarmClockMinus =
      DsLucideGlyph('alarm-clock-minus', <DsIconElement>[
    DsIconCircleElement(12, 13, 8), // key: 3y4lt7
    DsIconPathElement('M5 3 2 6'), // key: 18tl5t
    DsIconPathElement('m22 6-3-3'), // key: 1opdir
    DsIconPathElement('M6.38 18.7 4 21'), // key: 17xu3x
    DsIconPathElement('M17.64 18.67 20 21'), // key: kv2oe2
    DsIconPathElement('M9 13h6'), // key: 1uhe8q
  ]);

  /// `alarm-clock-off.mjs`
  static const DsLucideGlyph alarmClockOff =
      DsLucideGlyph('alarm-clock-off', <DsIconElement>[
    DsIconPathElement('M6.87 6.87a8 8 0 1 0 11.26 11.26'), // key: 3on8tj
    DsIconPathElement('M19.9 14.25a8 8 0 0 0-9.15-9.15'), // key: 15ghsc
    DsIconPathElement('m22 6-3-3'), // key: 1opdir
    DsIconPathElement('M6.26 18.67 4 21'), // key: yzmioq
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M4 4 2 6'), // key: 1ycko6
  ]);

  /// `alarm-clock-plus.mjs`
  static const DsLucideGlyph alarmClockPlus =
      DsLucideGlyph('alarm-clock-plus', <DsIconElement>[
    DsIconCircleElement(12, 13, 8), // key: 3y4lt7
    DsIconPathElement('M5 3 2 6'), // key: 18tl5t
    DsIconPathElement('m22 6-3-3'), // key: 1opdir
    DsIconPathElement('M6.38 18.7 4 21'), // key: 17xu3x
    DsIconPathElement('M17.64 18.67 20 21'), // key: kv2oe2
    DsIconPathElement('M12 10v6'), // key: 1bos4e
    DsIconPathElement('M9 13h6'), // key: 1uhe8q
  ]);

  /// `alarm-clock.mjs`
  static const DsLucideGlyph alarmClock =
      DsLucideGlyph('alarm-clock', <DsIconElement>[
    DsIconCircleElement(12, 13, 8), // key: 3y4lt7
    DsIconPathElement('M12 9v4l2 2'), // key: 1c63tq
    DsIconPathElement('M5 3 2 6'), // key: 18tl5t
    DsIconPathElement('m22 6-3-3'), // key: 1opdir
    DsIconPathElement('M6.38 18.7 4 21'), // key: 17xu3x
    DsIconPathElement('M17.64 18.67 20 21'), // key: kv2oe2
  ]);

  /// `alarm-smoke.mjs`
  static const DsLucideGlyph alarmSmoke =
      DsLucideGlyph('alarm-smoke', <DsIconElement>[
    DsIconPathElement('M11 21c0-2.5 2-2.5 2-5'), // key: 1sicvv
    DsIconPathElement('M16 21c0-2.5 2-2.5 2-5'), // key: 1o3eny
    DsIconPathElement('m19 8-.8 3a1.25 1.25 0 0 1-1.2 1H7a1.25 1.25 0 0 1-1.2-1L5 8'), // key: 1bvca4
    DsIconPathElement('M21 3a1 1 0 0 1 1 1v2a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V4a1 1 0 0 1 1-1z'), // key: x3qr1j
    DsIconPathElement('M6 21c0-2.5 2-2.5 2-5'), // key: i3w1gp
  ]);

  /// `album.mjs`
  static const DsLucideGlyph album =
      DsLucideGlyph('album', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    DsIconPolylineElement(<Offset>[Offset(11, 3), Offset(11, 11), Offset(14, 8), Offset(17, 11), Offset(17, 3)]), // key: 1wcwz3
  ]);

  /// `align-center-horizontal.mjs`
  static const DsLucideGlyph alignCenterHorizontal =
      DsLucideGlyph('align-center-horizontal', <DsIconElement>[
    DsIconPathElement('M2 12h20'), // key: 9i4pu4
    DsIconPathElement('M10 16v4a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-4'), // key: 11f1s0
    DsIconPathElement('M10 8V4a2 2 0 0 0-2-2H6a2 2 0 0 0-2 2v4'), // key: t14dx9
    DsIconPathElement('M20 16v1a2 2 0 0 1-2 2h-2a2 2 0 0 1-2-2v-1'), // key: 1w07xs
    DsIconPathElement('M14 8V7c0-1.1.9-2 2-2h2a2 2 0 0 1 2 2v1'), // key: 1apec2
  ]);

  /// `align-center-vertical.mjs`
  static const DsLucideGlyph alignCenterVertical =
      DsLucideGlyph('align-center-vertical', <DsIconElement>[
    DsIconPathElement('M12 2v20'), // key: t6zp3m
    DsIconPathElement('M8 10H4a2 2 0 0 1-2-2V6c0-1.1.9-2 2-2h4'), // key: 14d6g8
    DsIconPathElement('M16 10h4a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2h-4'), // key: 1e2lrw
    DsIconPathElement('M8 20H7a2 2 0 0 1-2-2v-2c0-1.1.9-2 2-2h1'), // key: 1fkdwx
    DsIconPathElement('M16 14h1a2 2 0 0 1 2 2v2a2 2 0 0 1-2 2h-1'), // key: 1euafb
  ]);

  /// `align-end-horizontal.mjs`
  static const DsLucideGlyph alignEndHorizontal =
      DsLucideGlyph('align-end-horizontal', <DsIconElement>[
    DsIconRectElement(4, 2, 6, 16, 2), // key: z5wdxg
    DsIconRectElement(14, 9, 6, 9, 2), // key: um7a8w
    DsIconPathElement('M22 22H2'), // key: 19qnx5
  ]);

  /// `align-end-vertical.mjs`
  static const DsLucideGlyph alignEndVertical =
      DsLucideGlyph('align-end-vertical', <DsIconElement>[
    DsIconRectElement(2, 4, 16, 6, 2), // key: 10wcwx
    DsIconRectElement(9, 14, 9, 6, 2), // key: 4p5bwg
    DsIconPathElement('M22 22V2'), // key: 12ipfv
  ]);

  /// `align-horizontal-distribute-center.mjs`
  static const DsLucideGlyph alignHorizontalDistributeCenter =
      DsLucideGlyph('align-horizontal-distribute-center', <DsIconElement>[
    DsIconRectElement(4, 5, 6, 14, 2), // key: 1wwnby
    DsIconRectElement(14, 7, 6, 10, 2), // key: 1fe6j6
    DsIconPathElement('M17 22v-5'), // key: 4b6g73
    DsIconPathElement('M17 7V2'), // key: hnrr36
    DsIconPathElement('M7 22v-3'), // key: 1r4jpn
    DsIconPathElement('M7 5V2'), // key: liy1u9
  ]);

  /// `align-horizontal-distribute-end.mjs`
  static const DsLucideGlyph alignHorizontalDistributeEnd =
      DsLucideGlyph('align-horizontal-distribute-end', <DsIconElement>[
    DsIconRectElement(4, 5, 6, 14, 2), // key: 1wwnby
    DsIconRectElement(14, 7, 6, 10, 2), // key: 1fe6j6
    DsIconPathElement('M10 2v20'), // key: uyc634
    DsIconPathElement('M20 2v20'), // key: 1tx262
  ]);

  /// `align-horizontal-distribute-start.mjs`
  static const DsLucideGlyph alignHorizontalDistributeStart =
      DsLucideGlyph('align-horizontal-distribute-start', <DsIconElement>[
    DsIconRectElement(4, 5, 6, 14, 2), // key: 1wwnby
    DsIconRectElement(14, 7, 6, 10, 2), // key: 1fe6j6
    DsIconPathElement('M4 2v20'), // key: gtpd5x
    DsIconPathElement('M14 2v20'), // key: tg6bpw
  ]);

  /// `align-horizontal-justify-center.mjs`
  static const DsLucideGlyph alignHorizontalJustifyCenter =
      DsLucideGlyph('align-horizontal-justify-center', <DsIconElement>[
    DsIconRectElement(2, 5, 6, 14, 2), // key: dy24zr
    DsIconRectElement(16, 7, 6, 10, 2), // key: 13zkjt
    DsIconPathElement('M12 2v20'), // key: t6zp3m
  ]);

  /// `align-horizontal-justify-end.mjs`
  static const DsLucideGlyph alignHorizontalJustifyEnd =
      DsLucideGlyph('align-horizontal-justify-end', <DsIconElement>[
    DsIconRectElement(2, 5, 6, 14, 2), // key: dy24zr
    DsIconRectElement(12, 7, 6, 10, 2), // key: 1ht384
    DsIconPathElement('M22 2v20'), // key: 40qfg1
  ]);

  /// `align-horizontal-justify-start.mjs`
  static const DsLucideGlyph alignHorizontalJustifyStart =
      DsLucideGlyph('align-horizontal-justify-start', <DsIconElement>[
    DsIconRectElement(6, 5, 6, 14, 2), // key: hsirpf
    DsIconRectElement(16, 7, 6, 10, 2), // key: 13zkjt
    DsIconPathElement('M2 2v20'), // key: 1ivd8o
  ]);

  /// `align-horizontal-space-around.mjs`
  static const DsLucideGlyph alignHorizontalSpaceAround =
      DsLucideGlyph('align-horizontal-space-around', <DsIconElement>[
    DsIconRectElement(9, 7, 6, 10, 2), // key: yn7j0q
    DsIconPathElement('M4 22V2'), // key: tsjzd3
    DsIconPathElement('M20 22V2'), // key: 1bnhr8
  ]);

  /// `align-horizontal-space-between.mjs`
  static const DsLucideGlyph alignHorizontalSpaceBetween =
      DsLucideGlyph('align-horizontal-space-between', <DsIconElement>[
    DsIconRectElement(3, 5, 6, 14, 2), // key: j77dae
    DsIconRectElement(15, 7, 6, 10, 2), // key: bq30hj
    DsIconPathElement('M3 2v20'), // key: 1d2pfg
    DsIconPathElement('M21 2v20'), // key: p059bm
  ]);

  /// `align-start-horizontal.mjs`
  static const DsLucideGlyph alignStartHorizontal =
      DsLucideGlyph('align-start-horizontal', <DsIconElement>[
    DsIconRectElement(4, 6, 6, 16, 2), // key: 1n4dg1
    DsIconRectElement(14, 6, 6, 9, 2), // key: 17khns
    DsIconPathElement('M22 2H2'), // key: fhrpnj
  ]);

  /// `align-start-vertical.mjs`
  static const DsLucideGlyph alignStartVertical =
      DsLucideGlyph('align-start-vertical', <DsIconElement>[
    DsIconRectElement(6, 14, 9, 6, 2), // key: lpm2y7
    DsIconRectElement(6, 4, 16, 6, 2), // key: rdj6ps
    DsIconPathElement('M2 2v20'), // key: 1ivd8o
  ]);

  /// `align-vertical-distribute-center.mjs`
  static const DsLucideGlyph alignVerticalDistributeCenter =
      DsLucideGlyph('align-vertical-distribute-center', <DsIconElement>[
    DsIconPathElement('M22 17h-3'), // key: 1lwga1
    DsIconPathElement('M22 7h-5'), // key: o2endc
    DsIconPathElement('M5 17H2'), // key: 1gx9xc
    DsIconPathElement('M7 7H2'), // key: 6bq26l
    DsIconRectElement(5, 14, 14, 6, 2), // key: 1qrzuf
    DsIconRectElement(7, 4, 10, 6, 2), // key: we8e9z
  ]);

  /// `align-vertical-distribute-end.mjs`
  static const DsLucideGlyph alignVerticalDistributeEnd =
      DsLucideGlyph('align-vertical-distribute-end', <DsIconElement>[
    DsIconRectElement(5, 14, 14, 6, 2), // key: jmoj9s
    DsIconRectElement(7, 4, 10, 6, 2), // key: aza5on
    DsIconPathElement('M2 20h20'), // key: owomy5
    DsIconPathElement('M2 10h20'), // key: 1ir3d8
  ]);

  /// `align-vertical-distribute-start.mjs`
  static const DsLucideGlyph alignVerticalDistributeStart =
      DsLucideGlyph('align-vertical-distribute-start', <DsIconElement>[
    DsIconRectElement(5, 14, 14, 6, 2), // key: jmoj9s
    DsIconRectElement(7, 4, 10, 6, 2), // key: aza5on
    DsIconPathElement('M2 14h20'), // key: myj16y
    DsIconPathElement('M2 4h20'), // key: mda7wb
  ]);

  /// `align-vertical-justify-center.mjs`
  static const DsLucideGlyph alignVerticalJustifyCenter =
      DsLucideGlyph('align-vertical-justify-center', <DsIconElement>[
    DsIconRectElement(5, 16, 14, 6, 2), // key: 1i8z2d
    DsIconRectElement(7, 2, 10, 6, 2), // key: ypihtt
    DsIconPathElement('M2 12h20'), // key: 9i4pu4
  ]);

  /// `align-vertical-justify-end.mjs`
  static const DsLucideGlyph alignVerticalJustifyEnd =
      DsLucideGlyph('align-vertical-justify-end', <DsIconElement>[
    DsIconRectElement(5, 12, 14, 6, 2), // key: 4l4tp2
    DsIconRectElement(7, 2, 10, 6, 2), // key: ypihtt
    DsIconPathElement('M2 22h20'), // key: 272qi7
  ]);

  /// `align-vertical-justify-start.mjs`
  static const DsLucideGlyph alignVerticalJustifyStart =
      DsLucideGlyph('align-vertical-justify-start', <DsIconElement>[
    DsIconRectElement(5, 16, 14, 6, 2), // key: 1i8z2d
    DsIconRectElement(7, 6, 10, 6, 2), // key: 13squh
    DsIconPathElement('M2 2h20'), // key: 1ennik
  ]);

  /// `align-vertical-space-around.mjs`
  static const DsLucideGlyph alignVerticalSpaceAround =
      DsLucideGlyph('align-vertical-space-around', <DsIconElement>[
    DsIconRectElement(7, 9, 10, 6, 2), // key: b1zbii
    DsIconPathElement('M22 20H2'), // key: 1p1f7z
    DsIconPathElement('M22 4H2'), // key: 1b7qnq
  ]);

  /// `align-vertical-space-between.mjs`
  static const DsLucideGlyph alignVerticalSpaceBetween =
      DsLucideGlyph('align-vertical-space-between', <DsIconElement>[
    DsIconRectElement(5, 15, 14, 6, 2), // key: 1w91an
    DsIconRectElement(7, 3, 10, 6, 2), // key: 17wqzy
    DsIconPathElement('M2 21h20'), // key: 1nyx9w
    DsIconPathElement('M2 3h20'), // key: 91anmk
  ]);

  /// `ambulance.mjs`
  static const DsLucideGlyph ambulance =
      DsLucideGlyph('ambulance', <DsIconElement>[
    DsIconPathElement('M10 10H6'), // key: 1bsnug
    DsIconPathElement('M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2'), // key: wrbu53
    DsIconPathElement('M19 18h2a1 1 0 0 0 1-1v-3.28a1 1 0 0 0-.684-.948l-1.923-.641a1 1 0 0 1-.578-.502l-1.539-3.076A1 1 0 0 0 16.382 8H14'), // key: lrkjwd
    DsIconPathElement('M8 8v4'), // key: 1fwk8c
    DsIconPathElement('M9 18h6'), // key: x1upvd
    DsIconCircleElement(17, 18, 2), // key: 332jqn
    DsIconCircleElement(7, 18, 2), // key: 19iecd
  ]);

  /// `ampersand.mjs`
  static const DsLucideGlyph ampersand =
      DsLucideGlyph('ampersand', <DsIconElement>[
    DsIconPathElement('M16 12h3'), // key: 4uvgyw
    DsIconPathElement('M17.5 12a8 8 0 0 1-8 8A4.5 4.5 0 0 1 5 15.5c0-6 8-4 8-8.5a3 3 0 1 0-6 0c0 3 2.5 8.5 12 13'), // key: nfoe1t
  ]);

  /// `ampersands.mjs`
  static const DsLucideGlyph ampersands =
      DsLucideGlyph('ampersands', <DsIconElement>[
    DsIconPathElement('M10 17c-5-3-7-7-7-9a2 2 0 0 1 4 0c0 2.5-5 2.5-5 6 0 1.7 1.3 3 3 3 2.8 0 5-2.2 5-5'), // key: 12lh1k
    DsIconPathElement('M22 17c-5-3-7-7-7-9a2 2 0 0 1 4 0c0 2.5-5 2.5-5 6 0 1.7 1.3 3 3 3 2.8 0 5-2.2 5-5'), // key: 173c68
  ]);

  /// `amphora.mjs`
  static const DsLucideGlyph amphora =
      DsLucideGlyph('amphora', <DsIconElement>[
    DsIconPathElement('M10 2v5.632c0 .424-.272.795-.653.982A6 6 0 0 0 6 14c.006 4 3 7 5 8'), // key: 1h8rid
    DsIconPathElement('M10 5H8a2 2 0 0 0 0 4h.68'), // key: 3ezsi6
    DsIconPathElement('M14 2v5.632c0 .424.272.795.652.982A6 6 0 0 1 18 14c0 4-3 7-5 8'), // key: yt6q09
    DsIconPathElement('M14 5h2a2 2 0 0 1 0 4h-.68'), // key: 8f95yk
    DsIconPathElement('M18 22H6'), // key: mg6kv4
    DsIconPathElement('M9 2h6'), // key: 1jrp98
  ]);

  /// `anchor.mjs`
  static const DsLucideGlyph anchor =
      DsLucideGlyph('anchor', <DsIconElement>[
    DsIconPathElement('M12 6v16'), // key: nqf5sj
    DsIconPathElement('m19 13 2-1a9 9 0 0 1-18 0l2 1'), // key: y7qv08
    DsIconPathElement('M9 11h6'), // key: 1fldmi
    DsIconCircleElement(12, 4, 2), // key: muu5ef
  ]);

  /// `angry.mjs`
  static const DsLucideGlyph angry =
      DsLucideGlyph('angry', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M16 16s-1.5-2-4-2-4 2-4 2'), // key: epbg0q
    DsIconPathElement('M7.5 8 10 9'), // key: olxxln
    DsIconPathElement('m14 9 2.5-1'), // key: 1j6cij
    DsIconPathElement('M9 10h.01'), // key: qbtxuw
    DsIconPathElement('M15 10h.01'), // key: 1qmjsl
  ]);

  /// `annoyed.mjs`
  static const DsLucideGlyph annoyed =
      DsLucideGlyph('annoyed', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M8 15h8'), // key: 45n4r
    DsIconPathElement('M8 9h2'), // key: 1g203m
    DsIconPathElement('M14 9h2'), // key: 116p9w
  ]);

  /// `antenna.mjs`
  static const DsLucideGlyph antenna =
      DsLucideGlyph('antenna', <DsIconElement>[
    DsIconPathElement('M2 12 7 2'), // key: 117k30
    DsIconPathElement('m7 12 5-10'), // key: 1tvx22
    DsIconPathElement('m12 12 5-10'), // key: ev1o1a
    DsIconPathElement('m17 12 5-10'), // key: 1e4ti3
    DsIconPathElement('M4.5 7h15'), // key: vlsxkz
    DsIconPathElement('M12 16v6'), // key: c8a4gj
  ]);

  /// `anvil.mjs`
  static const DsLucideGlyph anvil =
      DsLucideGlyph('anvil', <DsIconElement>[
    DsIconPathElement('M7 10H6a4 4 0 0 1-4-4 1 1 0 0 1 1-1h4'), // key: 1hjpb6
    DsIconPathElement('M7 5a1 1 0 0 1 1-1h13a1 1 0 0 1 1 1 7 7 0 0 1-7 7H8a1 1 0 0 1-1-1z'), // key: 1qn45f
    DsIconPathElement('M9 12v5'), // key: 3anwtq
    DsIconPathElement('M15 12v5'), // key: 5xh3zn
    DsIconPathElement('M5 20a3 3 0 0 1 3-3h8a3 3 0 0 1 3 3 1 1 0 0 1-1 1H6a1 1 0 0 1-1-1'), // key: 1fi4x8
  ]);

  /// `aperture.mjs`
  static const DsLucideGlyph aperture =
      DsLucideGlyph('aperture', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('m14.31 8 5.74 9.94'), // key: 1y6ab4
    DsIconPathElement('M9.69 8h11.48'), // key: 1wxppr
    DsIconPathElement('m7.38 12 5.74-9.94'), // key: 1grp0k
    DsIconPathElement('M9.69 16 3.95 6.06'), // key: libnyf
    DsIconPathElement('M14.31 16H2.83'), // key: x5fava
    DsIconPathElement('m16.62 12-5.74 9.94'), // key: 1vwawt
  ]);

  /// `app-window-mac.mjs`
  static const DsLucideGlyph appWindowMac =
      DsLucideGlyph('app-window-mac', <DsIconElement>[
    DsIconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
    DsIconPathElement('M6 8h.01'), // key: x9i8wu
    DsIconPathElement('M10 8h.01'), // key: 1r9ogq
    DsIconPathElement('M14 8h.01'), // key: 1primd
  ]);

  /// `app-window.mjs`
  static const DsLucideGlyph appWindow =
      DsLucideGlyph('app-window', <DsIconElement>[
    DsIconRectElement(2, 4, 20, 16, 2), // key: izxlao
    DsIconPathElement('M10 4v4'), // key: pp8u80
    DsIconPathElement('M2 8h20'), // key: d11cs7
    DsIconPathElement('M6 4v4'), // key: 1svtjw
  ]);

  /// `apple.mjs`
  static const DsLucideGlyph apple =
      DsLucideGlyph('apple', <DsIconElement>[
    DsIconPathElement('M12 6.528V3a1 1 0 0 1 1-1h0'), // key: 11qiee
    DsIconPathElement('M18.237 21A15 15 0 0 0 22 11a6 6 0 0 0-10-4.472A6 6 0 0 0 2 11a15.1 15.1 0 0 0 3.763 10 3 3 0 0 0 3.648.648 5.5 5.5 0 0 1 5.178 0A3 3 0 0 0 18.237 21'), // key: 110c12
  ]);

  /// `archive-restore.mjs`
  static const DsLucideGlyph archiveRestore =
      DsLucideGlyph('archive-restore', <DsIconElement>[
    DsIconRectElement(2, 3, 20, 5, 1), // key: 1wp1u1
    DsIconPathElement('M4 8v11a2 2 0 0 0 2 2h2'), // key: tvwodi
    DsIconPathElement('M20 8v11a2 2 0 0 1-2 2h-2'), // key: 1gkqxj
    DsIconPathElement('m9 15 3-3 3 3'), // key: 1pd0qc
    DsIconPathElement('M12 12v9'), // key: 192myk
  ]);

  /// `archive-x.mjs`
  static const DsLucideGlyph archiveX =
      DsLucideGlyph('archive-x', <DsIconElement>[
    DsIconRectElement(2, 3, 20, 5, 1), // key: 1wp1u1
    DsIconPathElement('M4 8v11a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8'), // key: 1s80jp
    DsIconPathElement('m9.5 17 5-5'), // key: nakeu6
    DsIconPathElement('m9.5 12 5 5'), // key: 1hccrj
  ]);

  /// `archive.mjs`
  static const DsLucideGlyph archive =
      DsLucideGlyph('archive', <DsIconElement>[
    DsIconRectElement(2, 3, 20, 5, 1), // key: 1wp1u1
    DsIconPathElement('M4 8v11a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8'), // key: 1s80jp
    DsIconPathElement('M10 12h4'), // key: a56b0p
  ]);

  /// `armchair.mjs`
  static const DsLucideGlyph armchair =
      DsLucideGlyph('armchair', <DsIconElement>[
    DsIconPathElement('M19 9V6a2 2 0 0 0-2-2H7a2 2 0 0 0-2 2v3'), // key: irtipd
    DsIconPathElement('M3 16a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-5a2 2 0 0 0-4 0v1.5a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5V11a2 2 0 0 0-4 0z'), // key: 1qyhux
    DsIconPathElement('M5 18v2'), // key: ppbyun
    DsIconPathElement('M19 18v2'), // key: gy7782
  ]);

  /// `arrow-big-down-dash.mjs`
  static const DsLucideGlyph arrowBigDownDash =
      DsLucideGlyph('arrow-big-down-dash', <DsIconElement>[
    DsIconPathElement('M14 8a1 1 0 0 1 1 1v2a1 1 0 0 0 1 1h3.293a.707.707 0 0 1 .5 1.207l-6.939 6.939a1.207 1.207 0 0 1-1.708 0l-6.94-6.94a.707.707 0 0 1 .5-1.206H8a1 1 0 0 0 1-1V9a1 1 0 0 1 1-1z'), // key: 1b91ra
    DsIconPathElement('M9 4h6'), // key: 10am2s
  ]);

  /// `arrow-big-down.mjs`
  static const DsLucideGlyph arrowBigDown =
      DsLucideGlyph('arrow-big-down', <DsIconElement>[
    DsIconPathElement('M9 5a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v6a1 1 0 0 0 1 1h3.293a.707.707 0 0 1 .5 1.207l-7.086 7.086a1 1 0 0 1-1.414 0l-7.086-7.086a.707.707 0 0 1 .5-1.207H8a1 1 0 0 0 1-1z'), // key: 1o3tkq
  ]);

  /// `arrow-big-left-dash.mjs`
  static const DsLucideGlyph arrowBigLeftDash =
      DsLucideGlyph('arrow-big-left-dash', <DsIconElement>[
    DsIconPathElement('M13 9a1 1 0 0 1-1-1V4.707a.707.707 0 0 0-1.207-.5l-6.94 6.94a1.207 1.207 0 0 0 0 1.707l6.94 6.94a.707.707 0 0 0 1.207-.5V16a1 1 0 0 1 1-1h2a1 1 0 0 0 1-1v-4a1 1 0 0 0-1-1z'), // key: 17jy80
    DsIconPathElement('M20 9v6'), // key: 14roy0
  ]);

  /// `arrow-big-left.mjs`
  static const DsLucideGlyph arrowBigLeft =
      DsLucideGlyph('arrow-big-left', <DsIconElement>[
    DsIconPathElement('M10.793 19.793a.707.707 0 0 0 1.207-.5V16a1 1 0 0 1 1-1h6a1 1 0 0 0 1-1v-4a1 1 0 0 0-1-1h-6a1 1 0 0 1-1-1V4.707a.707.707 0 0 0-1.207-.5l-6.94 6.94a1.207 1.207 0 0 0 0 1.707z'), // key: qbhtmx
  ]);

  /// `arrow-big-right-dash.mjs`
  static const DsLucideGlyph arrowBigRightDash =
      DsLucideGlyph('arrow-big-right-dash', <DsIconElement>[
    DsIconPathElement('M11 9a1 1 0 0 0 1-1V4.707a.707.707 0 0 1 1.207-.5l6.94 6.94a1.207 1.207 0 0 1 0 1.707l-6.94 6.94a.707.707 0 0 1-1.207-.5V16a1 1 0 0 0-1-1H9a1 1 0 0 1-1-1v-4a1 1 0 0 1 1-1z'), // key: 9idyso
    DsIconPathElement('M4 9v6'), // key: bns7oa
  ]);

  /// `arrow-big-right.mjs`
  static const DsLucideGlyph arrowBigRight =
      DsLucideGlyph('arrow-big-right', <DsIconElement>[
    DsIconPathElement('M13.207 19.793a.707.707 0 0 1-1.207-.5V16a1 1 0 0 0-1-1H5a1 1 0 0 1-1-1v-4a1 1 0 0 1 1-1h6a1 1 0 0 0 1-1V4.707a.707.707 0 0 1 1.207-.5l6.94 6.94a1.207 1.207 0 0 1 0 1.707z'), // key: zee3eo
  ]);

  /// `arrow-big-up-dash.mjs`
  static const DsLucideGlyph arrowBigUpDash =
      DsLucideGlyph('arrow-big-up-dash', <DsIconElement>[
    DsIconPathElement('M14 16a1 1 0 0 0 1-1v-2a1 1 0 0 1 1-1h3.293a.707.707 0 0 0 .5-1.207l-6.939-6.939a1.207 1.207 0 0 0-1.708 0l-6.94 6.94a.707.707 0 0 0 .5 1.206H8a1 1 0 0 1 1 1v2a1 1 0 0 0 1 1z'), // key: q57loy
    DsIconPathElement('M9 20h6'), // key: s66wpe
  ]);

  /// `arrow-big-up.mjs`
  static const DsLucideGlyph arrowBigUp =
      DsLucideGlyph('arrow-big-up', <DsIconElement>[
    DsIconPathElement('M9 19a1 1 0 0 0 1 1h4a1 1 0 0 0 1-1v-6a1 1 0 0 1 1-1h3.293a.707.707 0 0 0 .5-1.207l-7.086-7.086a1 1 0 0 0-1.414 0l-7.086 7.086a.707.707 0 0 0 .5 1.207H8a1 1 0 0 1 1 1z'), // key: 106j91
  ]);

  /// `arrow-down-0-1.mjs`
  static const DsLucideGlyph arrowDown01 =
      DsLucideGlyph('arrow-down-0-1', <DsIconElement>[
    DsIconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
    DsIconPathElement('M7 20V4'), // key: 1yoxec
    DsIconRectElement(15, 4, 4, 6, 2, ry: 2), // key: 1bwicg; rx absent (= ry)
    DsIconPathElement('M17 20v-6h-2'), // key: 1qp1so
    DsIconPathElement('M15 20h4'), // key: 1j968p
  ]);

  /// `arrow-down-1-0.mjs`
  static const DsLucideGlyph arrowDown10 =
      DsLucideGlyph('arrow-down-1-0', <DsIconElement>[
    DsIconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
    DsIconPathElement('M7 20V4'), // key: 1yoxec
    DsIconPathElement('M17 10V4h-2'), // key: zcsr5x
    DsIconPathElement('M15 10h4'), // key: id2lce
    DsIconRectElement(15, 14, 4, 6, 2, ry: 2), // key: 33xykx; rx absent (= ry)
  ]);

  /// `arrow-down-a-z.mjs`
  static const DsLucideGlyph arrowDownAZ =
      DsLucideGlyph('arrow-down-a-z', <DsIconElement>[
    DsIconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
    DsIconPathElement('M7 20V4'), // key: 1yoxec
    DsIconPathElement('M20 8h-5'), // key: 1vsyxs
    DsIconPathElement('M15 10V6.5a2.5 2.5 0 0 1 5 0V10'), // key: ag13bf
    DsIconPathElement('M15 14h5l-5 6h5'), // key: ur5jdg
  ]);

  /// `arrow-down-from-line.mjs`
  static const DsLucideGlyph arrowDownFromLine =
      DsLucideGlyph('arrow-down-from-line', <DsIconElement>[
    DsIconPathElement('M19 3H5'), // key: 1236rx
    DsIconPathElement('M12 21V7'), // key: gj6g52
    DsIconPathElement('m6 15 6 6 6-6'), // key: h15q88
  ]);

  /// `arrow-down-left.mjs`
  static const DsLucideGlyph arrowDownLeft =
      DsLucideGlyph('arrow-down-left', <DsIconElement>[
    DsIconPathElement('M17 7 7 17'), // key: 15tmo1
    DsIconPathElement('M17 17H7V7'), // key: 1org7z
  ]);

  /// `arrow-down-narrow-wide.mjs`
  static const DsLucideGlyph arrowDownNarrowWide =
      DsLucideGlyph('arrow-down-narrow-wide', <DsIconElement>[
    DsIconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
    DsIconPathElement('M7 20V4'), // key: 1yoxec
    DsIconPathElement('M11 4h4'), // key: 6d7r33
    DsIconPathElement('M11 8h7'), // key: djye34
    DsIconPathElement('M11 12h10'), // key: 1438ji
  ]);

  /// `arrow-down-right.mjs`
  static const DsLucideGlyph arrowDownRight =
      DsLucideGlyph('arrow-down-right', <DsIconElement>[
    DsIconPathElement('m7 7 10 10'), // key: 1fmybs
    DsIconPathElement('M17 7v10H7'), // key: 6fjiku
  ]);

  /// `arrow-down-to-dot.mjs`
  static const DsLucideGlyph arrowDownToDot =
      DsLucideGlyph('arrow-down-to-dot', <DsIconElement>[
    DsIconPathElement('M12 2v14'), // key: jyx4ut
    DsIconPathElement('m19 9-7 7-7-7'), // key: 1oe3oy
    DsIconCircleElement(12, 21, 1), // key: o0uj5v
  ]);

  /// `arrow-down-to-line.mjs`
  static const DsLucideGlyph arrowDownToLine =
      DsLucideGlyph('arrow-down-to-line', <DsIconElement>[
    DsIconPathElement('M12 17V3'), // key: 1cwfxf
    DsIconPathElement('m6 11 6 6 6-6'), // key: 12ii2o
    DsIconPathElement('M19 21H5'), // key: 150jfl
  ]);

  /// `arrow-down-up.mjs`
  static const DsLucideGlyph arrowDownUp =
      DsLucideGlyph('arrow-down-up', <DsIconElement>[
    DsIconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
    DsIconPathElement('M7 20V4'), // key: 1yoxec
    DsIconPathElement('m21 8-4-4-4 4'), // key: 1c9v7m
    DsIconPathElement('M17 4v16'), // key: 7dpous
  ]);

  /// `arrow-down-wide-narrow.mjs`
  static const DsLucideGlyph arrowDownWideNarrow =
      DsLucideGlyph('arrow-down-wide-narrow', <DsIconElement>[
    DsIconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
    DsIconPathElement('M7 20V4'), // key: 1yoxec
    DsIconPathElement('M11 4h10'), // key: 1w87gc
    DsIconPathElement('M11 8h7'), // key: djye34
    DsIconPathElement('M11 12h4'), // key: q8tih4
  ]);

  /// `arrow-down-z-a.mjs`
  static const DsLucideGlyph arrowDownZA =
      DsLucideGlyph('arrow-down-z-a', <DsIconElement>[
    DsIconPathElement('m3 16 4 4 4-4'), // key: 1co6wj
    DsIconPathElement('M7 4v16'), // key: 1glfcx
    DsIconPathElement('M15 4h5l-5 6h5'), // key: 8asdl1
    DsIconPathElement('M15 20v-3.5a2.5 2.5 0 0 1 5 0V20'), // key: r6l5cz
    DsIconPathElement('M20 18h-5'), // key: 18j1r2
  ]);

  /// `arrow-down.mjs`
  static const DsLucideGlyph arrowDown =
      DsLucideGlyph('arrow-down', <DsIconElement>[
    DsIconPathElement('M12 5v14'), // key: s699le
    DsIconPathElement('m19 12-7 7-7-7'), // key: 1idqje
  ]);

  /// `arrow-left-from-line.mjs`
  static const DsLucideGlyph arrowLeftFromLine =
      DsLucideGlyph('arrow-left-from-line', <DsIconElement>[
    DsIconPathElement('m9 6-6 6 6 6'), // key: 7v63n9
    DsIconPathElement('M3 12h14'), // key: 13k4hi
    DsIconPathElement('M21 19V5'), // key: b4bplr
  ]);

  /// `arrow-left-right.mjs`
  static const DsLucideGlyph arrowLeftRight =
      DsLucideGlyph('arrow-left-right', <DsIconElement>[
    DsIconPathElement('M8 3 4 7l4 4'), // key: 9rb6wj
    DsIconPathElement('M4 7h16'), // key: 6tx8e3
    DsIconPathElement('m16 21 4-4-4-4'), // key: siv7j2
    DsIconPathElement('M20 17H4'), // key: h6l3hr
  ]);

  /// `arrow-left-to-line.mjs`
  static const DsLucideGlyph arrowLeftToLine =
      DsLucideGlyph('arrow-left-to-line', <DsIconElement>[
    DsIconPathElement('M3 19V5'), // key: rwsyhb
    DsIconPathElement('m13 6-6 6 6 6'), // key: 1yhaz7
    DsIconPathElement('M7 12h14'), // key: uoisry
  ]);

  /// `arrow-left.mjs`
  static const DsLucideGlyph arrowLeft =
      DsLucideGlyph('arrow-left', <DsIconElement>[
    DsIconPathElement('m12 19-7-7 7-7'), // key: 1l729n
    DsIconPathElement('M19 12H5'), // key: x3x0zl
  ]);

  /// `arrow-right-from-line.mjs`
  static const DsLucideGlyph arrowRightFromLine =
      DsLucideGlyph('arrow-right-from-line', <DsIconElement>[
    DsIconPathElement('M3 5v14'), // key: 1nt18q
    DsIconPathElement('M21 12H7'), // key: 13ipq5
    DsIconPathElement('m15 18 6-6-6-6'), // key: 6tx3qv
  ]);

  /// `arrow-right-left.mjs`
  static const DsLucideGlyph arrowRightLeft =
      DsLucideGlyph('arrow-right-left', <DsIconElement>[
    DsIconPathElement('m16 3 4 4-4 4'), // key: 1x1c3m
    DsIconPathElement('M20 7H4'), // key: zbl0bi
    DsIconPathElement('m8 21-4-4 4-4'), // key: h9nckh
    DsIconPathElement('M4 17h16'), // key: g4d7ey
  ]);

  /// `arrow-right-to-line.mjs`
  static const DsLucideGlyph arrowRightToLine =
      DsLucideGlyph('arrow-right-to-line', <DsIconElement>[
    DsIconPathElement('M17 12H3'), // key: 8awo09
    DsIconPathElement('m11 18 6-6-6-6'), // key: 8c2y43
    DsIconPathElement('M21 5v14'), // key: nzette
  ]);

  /// `arrow-right.mjs`
  static const DsLucideGlyph arrowRight =
      DsLucideGlyph('arrow-right', <DsIconElement>[
    DsIconPathElement('M5 12h14'), // key: 1ays0h
    DsIconPathElement('m12 5 7 7-7 7'), // key: xquz4c
  ]);

  /// `arrow-up-0-1.mjs`
  static const DsLucideGlyph arrowUp01 =
      DsLucideGlyph('arrow-up-0-1', <DsIconElement>[
    DsIconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
    DsIconPathElement('M7 4v16'), // key: 1glfcx
    DsIconRectElement(15, 4, 4, 6, 2, ry: 2), // key: 1bwicg; rx absent (= ry)
    DsIconPathElement('M17 20v-6h-2'), // key: 1qp1so
    DsIconPathElement('M15 20h4'), // key: 1j968p
  ]);

  /// `arrow-up-1-0.mjs`
  static const DsLucideGlyph arrowUp10 =
      DsLucideGlyph('arrow-up-1-0', <DsIconElement>[
    DsIconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
    DsIconPathElement('M7 4v16'), // key: 1glfcx
    DsIconPathElement('M17 10V4h-2'), // key: zcsr5x
    DsIconPathElement('M15 10h4'), // key: id2lce
    DsIconRectElement(15, 14, 4, 6, 2, ry: 2), // key: 33xykx; rx absent (= ry)
  ]);

  /// `arrow-up-a-z.mjs`
  static const DsLucideGlyph arrowUpAZ =
      DsLucideGlyph('arrow-up-a-z', <DsIconElement>[
    DsIconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
    DsIconPathElement('M7 4v16'), // key: 1glfcx
    DsIconPathElement('M20 8h-5'), // key: 1vsyxs
    DsIconPathElement('M15 10V6.5a2.5 2.5 0 0 1 5 0V10'), // key: ag13bf
    DsIconPathElement('M15 14h5l-5 6h5'), // key: ur5jdg
  ]);

  /// `arrow-up-down.mjs`
  static const DsLucideGlyph arrowUpDown =
      DsLucideGlyph('arrow-up-down', <DsIconElement>[
    DsIconPathElement('m21 16-4 4-4-4'), // key: f6ql7i
    DsIconPathElement('M17 20V4'), // key: 1ejh1v
    DsIconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
    DsIconPathElement('M7 4v16'), // key: 1glfcx
  ]);

  /// `arrow-up-from-dot.mjs`
  static const DsLucideGlyph arrowUpFromDot =
      DsLucideGlyph('arrow-up-from-dot', <DsIconElement>[
    DsIconPathElement('m5 9 7-7 7 7'), // key: 1hw5ic
    DsIconPathElement('M12 16V2'), // key: ywoabb
    DsIconCircleElement(12, 21, 1), // key: o0uj5v
  ]);

  /// `arrow-up-from-line.mjs`
  static const DsLucideGlyph arrowUpFromLine =
      DsLucideGlyph('arrow-up-from-line', <DsIconElement>[
    DsIconPathElement('m18 9-6-6-6 6'), // key: kcunyi
    DsIconPathElement('M12 3v14'), // key: 7cf3v8
    DsIconPathElement('M5 21h14'), // key: 11awu3
  ]);

  /// `arrow-up-left.mjs`
  static const DsLucideGlyph arrowUpLeft =
      DsLucideGlyph('arrow-up-left', <DsIconElement>[
    DsIconPathElement('M7 17V7h10'), // key: 11bw93
    DsIconPathElement('M17 17 7 7'), // key: 2786uv
  ]);

  /// `arrow-up-narrow-wide.mjs`
  static const DsLucideGlyph arrowUpNarrowWide =
      DsLucideGlyph('arrow-up-narrow-wide', <DsIconElement>[
    DsIconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
    DsIconPathElement('M7 4v16'), // key: 1glfcx
    DsIconPathElement('M11 12h4'), // key: q8tih4
    DsIconPathElement('M11 16h7'), // key: uosisv
    DsIconPathElement('M11 20h10'), // key: jvxblo
  ]);

  /// `arrow-up-right.mjs`
  static const DsLucideGlyph arrowUpRight =
      DsLucideGlyph('arrow-up-right', <DsIconElement>[
    DsIconPathElement('M7 7h10v10'), // key: 1tivn9
    DsIconPathElement('M7 17 17 7'), // key: 1vkiza
  ]);

  /// `arrow-up-to-line.mjs`
  static const DsLucideGlyph arrowUpToLine =
      DsLucideGlyph('arrow-up-to-line', <DsIconElement>[
    DsIconPathElement('M5 3h14'), // key: 7usisc
    DsIconPathElement('m18 13-6-6-6 6'), // key: 1kf1n9
    DsIconPathElement('M12 7v14'), // key: 1akyts
  ]);

  /// `arrow-up-wide-narrow.mjs`
  static const DsLucideGlyph arrowUpWideNarrow =
      DsLucideGlyph('arrow-up-wide-narrow', <DsIconElement>[
    DsIconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
    DsIconPathElement('M7 4v16'), // key: 1glfcx
    DsIconPathElement('M11 12h10'), // key: 1438ji
    DsIconPathElement('M11 16h7'), // key: uosisv
    DsIconPathElement('M11 20h4'), // key: 1krc32
  ]);

  /// `arrow-up-z-a.mjs`
  static const DsLucideGlyph arrowUpZA =
      DsLucideGlyph('arrow-up-z-a', <DsIconElement>[
    DsIconPathElement('m3 8 4-4 4 4'), // key: 11wl7u
    DsIconPathElement('M7 4v16'), // key: 1glfcx
    DsIconPathElement('M15 4h5l-5 6h5'), // key: 8asdl1
    DsIconPathElement('M15 20v-3.5a2.5 2.5 0 0 1 5 0V20'), // key: r6l5cz
    DsIconPathElement('M20 18h-5'), // key: 18j1r2
  ]);

  /// `arrow-up.mjs`
  static const DsLucideGlyph arrowUp =
      DsLucideGlyph('arrow-up', <DsIconElement>[
    DsIconPathElement('m5 12 7-7 7 7'), // key: hav0vg
    DsIconPathElement('M12 19V5'), // key: x0mq9r
  ]);

  /// `arrows-up-from-line.mjs`
  static const DsLucideGlyph arrowsUpFromLine =
      DsLucideGlyph('arrows-up-from-line', <DsIconElement>[
    DsIconPathElement('m4 6 3-3 3 3'), // key: 9aidw8
    DsIconPathElement('M7 17V3'), // key: 19qxw1
    DsIconPathElement('m14 6 3-3 3 3'), // key: 6iy689
    DsIconPathElement('M17 17V3'), // key: o0fmgi
    DsIconPathElement('M4 21h16'), // key: 1h09gz
  ]);

  /// `asterisk.mjs`
  static const DsLucideGlyph asterisk =
      DsLucideGlyph('asterisk', <DsIconElement>[
    DsIconPathElement('M12 6v12'), // key: 1vza4d
    DsIconPathElement('M17.196 9 6.804 15'), // key: 1ah31z
    DsIconPathElement('m6.804 9 10.392 6'), // key: 1b6pxd
  ]);

  /// `astroid.mjs`
  static const DsLucideGlyph astroid =
      DsLucideGlyph('astroid', <DsIconElement>[
    DsIconPathElement('M12.983 21.186a1 1 0 0 1-1.966 0 10 10 0 0 0-8.203-8.203 1 1 0 0 1 0-1.966 10 10 0 0 0 8.203-8.203 1 1 0 0 1 1.966 0 10 10 0 0 0 8.203 8.203 1 1 0 0 1 0 1.966 10 10 0 0 0-8.203 8.203'), // key: 1tipus
  ]);

  /// `at-sign.mjs`
  static const DsLucideGlyph atSign =
      DsLucideGlyph('at-sign', <DsIconElement>[
    DsIconCircleElement(12, 12, 4), // key: 4exip2
    DsIconPathElement('M16 8v5a3 3 0 0 0 6 0v-1a10 10 0 1 0-4 8'), // key: 7n84p3
  ]);

  /// `atom.mjs`
  static const DsLucideGlyph atom =
      DsLucideGlyph('atom', <DsIconElement>[
    DsIconCircleElement(12, 12, 1), // key: 41hilf
    DsIconPathElement('M20.2 20.2c2.04-2.03.02-7.36-4.5-11.9-4.54-4.52-9.87-6.54-11.9-4.5-2.04 2.03-.02 7.36 4.5 11.9 4.54 4.52 9.87 6.54 11.9 4.5Z'), // key: 1l2ple
    DsIconPathElement('M15.7 15.7c4.52-4.54 6.54-9.87 4.5-11.9-2.03-2.04-7.36-.02-11.9 4.5-4.52 4.54-6.54 9.87-4.5 11.9 2.03 2.04 7.36.02 11.9-4.5Z'), // key: 1wam0m
  ]);

  /// `audio-lines.mjs`
  static const DsLucideGlyph audioLines =
      DsLucideGlyph('audio-lines', <DsIconElement>[
    DsIconPathElement('M2 10v3'), // key: 1fnikh
    DsIconPathElement('M6 6v11'), // key: 11sgs0
    DsIconPathElement('M10 3v18'), // key: yhl04a
    DsIconPathElement('M14 8v7'), // key: 3a1oy3
    DsIconPathElement('M18 5v13'), // key: 123xd1
    DsIconPathElement('M22 10v3'), // key: 154ddg
  ]);

  /// `audio-waveform.mjs`
  static const DsLucideGlyph audioWaveform =
      DsLucideGlyph('audio-waveform', <DsIconElement>[
    DsIconPathElement('M2 13a2 2 0 0 0 2-2V7a2 2 0 0 1 4 0v13a2 2 0 0 0 4 0V4a2 2 0 0 1 4 0v13a2 2 0 0 0 4 0v-4a2 2 0 0 1 2-2'), // key: 57tc96
  ]);

  /// `award.mjs`
  static const DsLucideGlyph award =
      DsLucideGlyph('award', <DsIconElement>[
    DsIconPathElement('m15.477 12.89 1.515 8.526a.5.5 0 0 1-.81.47l-3.58-2.687a1 1 0 0 0-1.197 0l-3.586 2.686a.5.5 0 0 1-.81-.469l1.514-8.526'), // key: 1yiouv
    DsIconCircleElement(12, 8, 6), // key: 1vp47v
  ]);

  /// `axe.mjs`
  static const DsLucideGlyph axe =
      DsLucideGlyph('axe', <DsIconElement>[
    DsIconPathElement('m14 12-8.381 8.38a1 1 0 0 1-3.001-3L11 9'), // key: 5z9253
    DsIconPathElement('M15 15.5a.5.5 0 0 0 .5.5A6.5 6.5 0 0 0 22 9.5a.5.5 0 0 0-.5-.5h-1.672a2 2 0 0 1-1.414-.586l-5.062-5.062a1.205 1.205 0 0 0-1.704 0L9.352 5.648a1.205 1.205 0 0 0 0 1.704l5.062 5.062A2 2 0 0 1 15 13.828z'), // key: 19zklq
  ]);

  /// `axis-3d.mjs`
  static const DsLucideGlyph axis3d =
      DsLucideGlyph('axis-3d', <DsIconElement>[
    DsIconPathElement('M13.5 10.5 15 9'), // key: 1nsxvm
    DsIconPathElement('M4 4v15a1 1 0 0 0 1 1h15'), // key: 1w6lkd
    DsIconPathElement('M4.293 19.707 6 18'), // key: 3g1p8c
    DsIconPathElement('m9 15 1.5-1.5'), // key: 1xfbes
  ]);

  /// `baby.mjs`
  static const DsLucideGlyph baby =
      DsLucideGlyph('baby', <DsIconElement>[
    DsIconPathElement('M10 16c.5.3 1.2.5 2 .5s1.5-.2 2-.5'), // key: 1u7htd
    DsIconPathElement('M15 12h.01'), // key: 1k8ypt
    DsIconPathElement('M19.38 6.813A9 9 0 0 1 20.8 10.2a2 2 0 0 1 0 3.6 9 9 0 0 1-17.6 0 2 2 0 0 1 0-3.6A9 9 0 0 1 12 3c2 0 3.5 1.1 3.5 2.5s-.9 2.5-2 2.5c-.8 0-1.5-.4-1.5-1'), // key: 11xh7x
    DsIconPathElement('M9 12h.01'), // key: 157uk2
  ]);

  /// `backpack.mjs`
  static const DsLucideGlyph backpack =
      DsLucideGlyph('backpack', <DsIconElement>[
    DsIconPathElement('M4 10a4 4 0 0 1 4-4h8a4 4 0 0 1 4 4v10a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2z'), // key: 1ol0lm
    DsIconPathElement('M8 10h8'), // key: c7uz4u
    DsIconPathElement('M8 18h8'), // key: 1no2b1
    DsIconPathElement('M8 22v-6a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v6'), // key: 1fr6do
    DsIconPathElement('M9 6V4a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2'), // key: donm21
  ]);

  /// `badge-alert.mjs`
  static const DsLucideGlyph badgeAlert =
      DsLucideGlyph('badge-alert', <DsIconElement>[
    DsIconPathElement('M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z'), // key: 3c2336
    DsIconLineElement(12, 8, 12, 12), // key: 1pkeuh
    DsIconLineElement(12, 16, 12.01, 16), // key: 4dfq90
  ]);

  /// `badge-cent.mjs`
  static const DsLucideGlyph badgeCent =
      DsLucideGlyph('badge-cent', <DsIconElement>[
    DsIconPathElement('M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z'), // key: 3c2336
    DsIconPathElement('M12 7v10'), // key: jspqdw
    DsIconPathElement('M15.4 10a4 4 0 1 0 0 4'), // key: 2eqtx8
  ]);

  /// `badge-check.mjs`
  static const DsLucideGlyph badgeCheck =
      DsLucideGlyph('badge-check', <DsIconElement>[
    DsIconPathElement('M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z'), // key: 3c2336
    DsIconPathElement('m9 12 2 2 4-4'), // key: dzmm74
  ]);

  /// `badge-dollar-sign.mjs`
  static const DsLucideGlyph badgeDollarSign =
      DsLucideGlyph('badge-dollar-sign', <DsIconElement>[
    DsIconPathElement('M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z'), // key: 3c2336
    DsIconPathElement('M16 8h-6a2 2 0 1 0 0 4h4a2 2 0 1 1 0 4H8'), // key: 1h4pet
    DsIconPathElement('M12 18V6'), // key: zqpxq5
  ]);

  /// `badge-euro.mjs`
  static const DsLucideGlyph badgeEuro =
      DsLucideGlyph('badge-euro', <DsIconElement>[
    DsIconPathElement('M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z'), // key: 3c2336
    DsIconPathElement('M7 12h5'), // key: gblrwe
    DsIconPathElement('M15 9.4a4 4 0 1 0 0 5.2'), // key: 1makmb
  ]);

  /// `badge-indian-rupee.mjs`
  static const DsLucideGlyph badgeIndianRupee =
      DsLucideGlyph('badge-indian-rupee', <DsIconElement>[
    DsIconPathElement('M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z'), // key: 3c2336
    DsIconPathElement('M8 8h8'), // key: 1bis0t
    DsIconPathElement('M8 12h8'), // key: 1wcyev
    DsIconPathElement('m13 17-5-1h1a4 4 0 0 0 0-8'), // key: nu2bwa
  ]);

  /// `badge-info.mjs`
  static const DsLucideGlyph badgeInfo =
      DsLucideGlyph('badge-info', <DsIconElement>[
    DsIconPathElement('M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z'), // key: 3c2336
    DsIconLineElement(12, 16, 12, 12), // key: 1y1yb1
    DsIconLineElement(12, 8, 12.01, 8), // key: 110wyk
  ]);

  /// `badge-japanese-yen.mjs`
  static const DsLucideGlyph badgeJapaneseYen =
      DsLucideGlyph('badge-japanese-yen', <DsIconElement>[
    DsIconPathElement('M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z'), // key: 3c2336
    DsIconPathElement('m9 8 3 3v7'), // key: 17yadx
    DsIconPathElement('m12 11 3-3'), // key: p4cfq1
    DsIconPathElement('M9 12h6'), // key: 1c52cq
    DsIconPathElement('M9 16h6'), // key: 8wimt3
  ]);

  /// `badge-minus.mjs`
  static const DsLucideGlyph badgeMinus =
      DsLucideGlyph('badge-minus', <DsIconElement>[
    DsIconPathElement('M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z'), // key: 3c2336
    DsIconLineElement(8, 12, 16, 12), // key: 1jonct
  ]);

  /// `badge-percent.mjs`
  static const DsLucideGlyph badgePercent =
      DsLucideGlyph('badge-percent', <DsIconElement>[
    DsIconPathElement('M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z'), // key: 3c2336
    DsIconPathElement('m15 9-6 6'), // key: 1uzhvr
    DsIconPathElement('M9 9h.01'), // key: 1q5me6
    DsIconPathElement('M15 15h.01'), // key: lqbp3k
  ]);

  /// `badge-plus.mjs`
  static const DsLucideGlyph badgePlus =
      DsLucideGlyph('badge-plus', <DsIconElement>[
    DsIconPathElement('M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z'), // key: 3c2336
    DsIconLineElement(12, 8, 12, 16), // key: 10p56q
    DsIconLineElement(8, 12, 16, 12), // key: 1jonct
  ]);

  /// `badge-pound-sterling.mjs`
  static const DsLucideGlyph badgePoundSterling =
      DsLucideGlyph('badge-pound-sterling', <DsIconElement>[
    DsIconPathElement('M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z'), // key: 3c2336
    DsIconPathElement('M8 12h4'), // key: qz6y1c
    DsIconPathElement('M10 16V9.5a2.5 2.5 0 0 1 5 0'), // key: 3mlbjk
    DsIconPathElement('M8 16h7'), // key: sbedsn
  ]);

  /// `badge-question-mark.mjs`
  static const DsLucideGlyph badgeQuestionMark =
      DsLucideGlyph('badge-question-mark', <DsIconElement>[
    DsIconPathElement('M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z'), // key: 3c2336
    DsIconPathElement('M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3'), // key: 1u773s
    DsIconLineElement(12, 17, 12.01, 17), // key: io3f8k
  ]);

  /// `badge-russian-ruble.mjs`
  static const DsLucideGlyph badgeRussianRuble =
      DsLucideGlyph('badge-russian-ruble', <DsIconElement>[
    DsIconPathElement('M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z'), // key: 3c2336
    DsIconPathElement('M9 16h5'), // key: 1syiyw
    DsIconPathElement('M9 12h5a2 2 0 1 0 0-4h-3v9'), // key: 1ge9c1
  ]);

  /// `badge-swiss-franc.mjs`
  static const DsLucideGlyph badgeSwissFranc =
      DsLucideGlyph('badge-swiss-franc', <DsIconElement>[
    DsIconPathElement('M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z'), // key: 3c2336
    DsIconPathElement('M11 17V8h4'), // key: 1bfq6y
    DsIconPathElement('M11 12h3'), // key: 2eqnfz
    DsIconPathElement('M9 16h4'), // key: 1skf3a
  ]);

  /// `badge-turkish-lira.mjs`
  static const DsLucideGlyph badgeTurkishLira =
      DsLucideGlyph('badge-turkish-lira', <DsIconElement>[
    DsIconPathElement('M11 7v10a5 5 0 0 0 5-5'), // key: 1ja3ih
    DsIconPathElement('m15 8-6 3'), // key: 4x0uwz
    DsIconPathElement('M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76'), // key: 18242g
  ]);

  /// `badge-x.mjs`
  static const DsLucideGlyph badgeX =
      DsLucideGlyph('badge-x', <DsIconElement>[
    DsIconPathElement('M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z'), // key: 3c2336
    DsIconLineElement(15, 9, 9, 15), // key: f7djnv
    DsIconLineElement(9, 9, 15, 15), // key: 1shsy8
  ]);

  /// `badge.mjs`
  static const DsLucideGlyph badge =
      DsLucideGlyph('badge', <DsIconElement>[
    DsIconPathElement('M3.85 8.62a4 4 0 0 1 4.78-4.77 4 4 0 0 1 6.74 0 4 4 0 0 1 4.78 4.78 4 4 0 0 1 0 6.74 4 4 0 0 1-4.77 4.78 4 4 0 0 1-6.75 0 4 4 0 0 1-4.78-4.77 4 4 0 0 1 0-6.76Z'), // key: 3c2336
  ]);

  /// `baggage-claim.mjs`
  static const DsLucideGlyph baggageClaim =
      DsLucideGlyph('baggage-claim', <DsIconElement>[
    DsIconPathElement('M22 18H6a2 2 0 0 1-2-2V7a2 2 0 0 0-2-2'), // key: 4irg2o
    DsIconPathElement('M17 14V4a2 2 0 0 0-2-2h-1a2 2 0 0 0-2 2v10'), // key: 14fcyx
    DsIconRectElement(8, 6, 13, 8, 1), // key: o6oiis
    DsIconCircleElement(18, 20, 2), // key: t9985n
    DsIconCircleElement(9, 20, 2), // key: e5v82j
  ]);

  /// `balloon.mjs`
  static const DsLucideGlyph balloon =
      DsLucideGlyph('balloon', <DsIconElement>[
    DsIconPathElement('M12 16v1a2 2 0 0 0 2 2h1a2 2 0 0 1 2 2v1'), // key: 2nz4b
    DsIconPathElement('M12 6a2 2 0 0 1 2 2'), // key: 7y7d82
    DsIconPathElement('M18 8c0 4-3.5 8-6 8s-6-4-6-8a6 6 0 0 1 12 0'), // key: vqb5s3
  ]);

  /// `ban.mjs`
  static const DsLucideGlyph ban =
      DsLucideGlyph('ban', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M4.929 4.929 19.07 19.071'), // key: 196cmz
  ]);

  /// `banana.mjs`
  static const DsLucideGlyph banana =
      DsLucideGlyph('banana', <DsIconElement>[
    DsIconPathElement('M4 13c3.5-2 8-2 10 2a5.5 5.5 0 0 1 8 5'), // key: 1cscit
    DsIconPathElement('M5.15 17.89c5.52-1.52 8.65-6.89 7-12C11.55 4 11.5 2 13 2c3.22 0 5 5.5 5 8 0 6.5-4.2 12-10.49 12C5.11 22 2 22 2 20c0-1.5 1.14-1.55 3.15-2.11Z'), // key: 1y1nbv
  ]);

  /// `bandage.mjs`
  static const DsLucideGlyph bandage =
      DsLucideGlyph('bandage', <DsIconElement>[
    DsIconPathElement('M10 10.01h.01'), // key: 1e9xi7
    DsIconPathElement('M10 14.01h.01'), // key: ac23bv
    DsIconPathElement('M14 10.01h.01'), // key: 2wfrvf
    DsIconPathElement('M14 14.01h.01'), // key: 8tw8yn
    DsIconPathElement('M18 6v12'), // key: 1bcixs
    DsIconPathElement('M6 6v12'), // key: vkc79e
    DsIconRectElement(2, 6, 20, 12, 2), // key: 1wpnh2
  ]);

  /// `banknote-arrow-down.mjs`
  static const DsLucideGlyph banknoteArrowDown =
      DsLucideGlyph('banknote-arrow-down', <DsIconElement>[
    DsIconPathElement('M12 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5'), // key: x6cv4u
    DsIconPathElement('m16 19 3 3 3-3'), // key: 1ibux0
    DsIconPathElement('M18 12h.01'), // key: yjnet6
    DsIconPathElement('M19 16v6'), // key: tddt3s
    DsIconPathElement('M6 12h.01'), // key: c2rlol
    DsIconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `banknote-arrow-up.mjs`
  static const DsLucideGlyph banknoteArrowUp =
      DsLucideGlyph('banknote-arrow-up', <DsIconElement>[
    DsIconPathElement('M12 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5'), // key: x6cv4u
    DsIconPathElement('M18 12h.01'), // key: yjnet6
    DsIconPathElement('M19 22v-6'), // key: qhmiwi
    DsIconPathElement('m22 19-3-3-3 3'), // key: rn6bg2
    DsIconPathElement('M6 12h.01'), // key: c2rlol
    DsIconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `banknote-check.mjs`
  static const DsLucideGlyph banknoteCheck =
      DsLucideGlyph('banknote-check', <DsIconElement>[
    DsIconPathElement('M11.748 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v4.875'), // key: t4e5a5
    DsIconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
    DsIconPathElement('M18 12h.01'), // key: yjnet6
    DsIconPathElement('M6 12h.01'), // key: c2rlol
    DsIconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `banknote-x.mjs`
  static const DsLucideGlyph banknoteX =
      DsLucideGlyph('banknote-x', <DsIconElement>[
    DsIconPathElement('M13 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5'), // key: 16nib6
    DsIconPathElement('m17 17 5 5'), // key: p7ous7
    DsIconPathElement('M18 12h.01'), // key: yjnet6
    DsIconPathElement('m22 17-5 5'), // key: gqnmv0
    DsIconPathElement('M6 12h.01'), // key: c2rlol
    DsIconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `banknote.mjs`
  static const DsLucideGlyph banknote =
      DsLucideGlyph('banknote', <DsIconElement>[
    DsIconRectElement(2, 6, 20, 12, 2), // key: 9lu3g6
    DsIconCircleElement(12, 12, 2), // key: 1c9p78
    DsIconPathElement('M6 12h.01M18 12h.01'), // key: 113zkx
  ]);

  /// `barcode.mjs`
  static const DsLucideGlyph barcode =
      DsLucideGlyph('barcode', <DsIconElement>[
    DsIconPathElement('M3 5v14'), // key: 1nt18q
    DsIconPathElement('M8 5v14'), // key: 1ybrkv
    DsIconPathElement('M12 5v14'), // key: s699le
    DsIconPathElement('M17 5v14'), // key: ycjyhj
    DsIconPathElement('M21 5v14'), // key: nzette
  ]);

  /// `barrel.mjs`
  static const DsLucideGlyph barrel =
      DsLucideGlyph('barrel', <DsIconElement>[
    DsIconPathElement('M10 3a41 41 0 000 18'), // key: 1f9k6x
    DsIconPathElement('M14 3a41 41 0 010 18'), // key: 1qo28r
    DsIconPathElement('M16.997 21a2 2 0 001.68-.92 15.25 15.25 0 000-16.16 2 2 0 00-1.68-.92h-10a2 2 0 00-1.681.92 15.25 15.25 0 000 16.16 2 2 0 001.681.92z'), // key: 1nrwe5
    DsIconPathElement('M3.54 16h16.914'), // key: jntgtt
    DsIconPathElement('M3.54 8h16.914'), // key: 14pf7i
  ]);

  /// `baseline.mjs`
  static const DsLucideGlyph baseline =
      DsLucideGlyph('baseline', <DsIconElement>[
    DsIconPathElement('M4 20h16'), // key: 14thso
    DsIconPathElement('m6 16 6-12 6 12'), // key: 1b4byz
    DsIconPathElement('M8 12h8'), // key: 1wcyev
  ]);

  /// `bath.mjs`
  static const DsLucideGlyph bath =
      DsLucideGlyph('bath', <DsIconElement>[
    DsIconPathElement('M10 4 8 6'), // key: 1rru8s
    DsIconPathElement('M17 19v2'), // key: ts1sot
    DsIconPathElement('M2 12h20'), // key: 9i4pu4
    DsIconPathElement('M7 19v2'), // key: 12npes
    DsIconPathElement('M9 5 7.621 3.621A2.121 2.121 0 0 0 4 5v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-5'), // key: 14ym8i
  ]);

  /// `battery-charging.mjs`
  static const DsLucideGlyph batteryCharging =
      DsLucideGlyph('battery-charging', <DsIconElement>[
    DsIconPathElement('m11 7-3 5h4l-3 5'), // key: b4a64w
    DsIconPathElement('M14.856 6H16a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-2.935'), // key: lre1cr
    DsIconPathElement('M22 14v-4'), // key: 14q9d5
    DsIconPathElement('M5.14 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h2.936'), // key: 13q5k0
  ]);

  /// `battery-full.mjs`
  static const DsLucideGlyph batteryFull =
      DsLucideGlyph('battery-full', <DsIconElement>[
    DsIconPathElement('M10 10v4'), // key: 1mb2ec
    DsIconPathElement('M14 10v4'), // key: 1nt88p
    DsIconPathElement('M22 14v-4'), // key: 14q9d5
    DsIconPathElement('M6 10v4'), // key: 1n77qd
    DsIconRectElement(2, 6, 16, 12, 2), // key: 13zb55
  ]);

  /// `battery-low.mjs`
  static const DsLucideGlyph batteryLow =
      DsLucideGlyph('battery-low', <DsIconElement>[
    DsIconPathElement('M22 14v-4'), // key: 14q9d5
    DsIconPathElement('M6 14v-4'), // key: 14a6bd
    DsIconRectElement(2, 6, 16, 12, 2), // key: 13zb55
  ]);

  /// `battery-medium.mjs`
  static const DsLucideGlyph batteryMedium =
      DsLucideGlyph('battery-medium', <DsIconElement>[
    DsIconPathElement('M10 14v-4'), // key: suye4c
    DsIconPathElement('M22 14v-4'), // key: 14q9d5
    DsIconPathElement('M6 14v-4'), // key: 14a6bd
    DsIconRectElement(2, 6, 16, 12, 2), // key: 13zb55
  ]);

  /// `battery-plus.mjs`
  static const DsLucideGlyph batteryPlus =
      DsLucideGlyph('battery-plus', <DsIconElement>[
    DsIconPathElement('M10 9v6'), // key: 17i7lo
    DsIconPathElement('M12.543 6H16a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-3.605'), // key: o09yah
    DsIconPathElement('M22 14v-4'), // key: 14q9d5
    DsIconPathElement('M7 12h6'), // key: iekk3h
    DsIconPathElement('M7.606 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h3.606'), // key: xyqvf1
  ]);

  /// `battery-warning.mjs`
  static const DsLucideGlyph batteryWarning =
      DsLucideGlyph('battery-warning', <DsIconElement>[
    DsIconPathElement('M10 17h.01'), // key: nbq80n
    DsIconPathElement('M10 7v6'), // key: nne03l
    DsIconPathElement('M14 6h2a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-2'), // key: 1m83kb
    DsIconPathElement('M22 14v-4'), // key: 14q9d5
    DsIconPathElement('M6 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h2'), // key: h8lgfh
  ]);

  /// `battery.mjs`
  static const DsLucideGlyph battery =
      DsLucideGlyph('battery', <DsIconElement>[
    DsIconPathElement('M 22 14 L 22 10'), // key: nqc4tb
    DsIconRectElement(2, 6, 16, 12, 2), // key: 13zb55
  ]);

  /// `beaker.mjs`
  static const DsLucideGlyph beaker =
      DsLucideGlyph('beaker', <DsIconElement>[
    DsIconPathElement('M4.5 3h15'), // key: c7n0jr
    DsIconPathElement('M6 3v16a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V3'), // key: m1uhx7
    DsIconPathElement('M6 14h12'), // key: 4cwo0f
  ]);

  /// `bean-off.mjs`
  static const DsLucideGlyph beanOff =
      DsLucideGlyph('bean-off', <DsIconElement>[
    DsIconPathElement('M9 9c-.64.64-1.521.954-2.402 1.165A6 6 0 0 0 8 22a13.96 13.96 0 0 0 9.9-4.1'), // key: bq3udt
    DsIconPathElement('M10.75 5.093A6 6 0 0 1 22 8c0 2.411-.61 4.68-1.683 6.66'), // key: 17ccse
    DsIconPathElement('M5.341 10.62a4 4 0 0 0 6.487 1.208M10.62 5.341a4.015 4.015 0 0 1 2.039 2.04'), // key: 18zqgq
    DsIconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `bean.mjs`
  static const DsLucideGlyph bean =
      DsLucideGlyph('bean', <DsIconElement>[
    DsIconPathElement('M10.165 6.598C9.954 7.478 9.64 8.36 9 9c-.64.64-1.521.954-2.402 1.165A6 6 0 0 0 8 22c7.732 0 14-6.268 14-14a6 6 0 0 0-11.835-1.402Z'), // key: 1tvzk7
    DsIconPathElement('M5.341 10.62a4 4 0 1 0 5.279-5.28'), // key: 2cyri2
  ]);

  /// `bed-double.mjs`
  static const DsLucideGlyph bedDouble =
      DsLucideGlyph('bed-double', <DsIconElement>[
    DsIconPathElement('M2 20v-8a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v8'), // key: 1k78r4
    DsIconPathElement('M4 10V6a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v4'), // key: fb3tl2
    DsIconPathElement('M12 4v6'), // key: 1dcgq2
    DsIconPathElement('M2 18h20'), // key: ajqnye
  ]);

  /// `bed-single.mjs`
  static const DsLucideGlyph bedSingle =
      DsLucideGlyph('bed-single', <DsIconElement>[
    DsIconPathElement('M3 20v-8a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v8'), // key: 1wm6mi
    DsIconPathElement('M5 10V6a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v4'), // key: 4k93s5
    DsIconPathElement('M3 18h18'), // key: 1h113x
  ]);

  /// `bed.mjs`
  static const DsLucideGlyph bed =
      DsLucideGlyph('bed', <DsIconElement>[
    DsIconPathElement('M2 4v16'), // key: vw9hq8
    DsIconPathElement('M2 8h18a2 2 0 0 1 2 2v10'), // key: 1dgv2r
    DsIconPathElement('M2 17h20'), // key: 18nfp3
    DsIconPathElement('M6 8v9'), // key: 1yriud
  ]);

  /// `beef-off.mjs`
  static const DsLucideGlyph beefOff =
      DsLucideGlyph('beef-off', <DsIconElement>[
    DsIconPathElement('M11.771 6.109a2.5 2.5 0 0 1 3.12 3.12'), // key: 3w1grc
    DsIconPathElement('M17.852 12.185a6.5 6.5 0 0 0-9.035-9.04'), // key: 1xgl7b
    DsIconPathElement('M18.013 18.013C15.029 20.349 10.831 22 7 22a3 3 0 0 1-2.68-1.66L2.4 16.5'), // key: 3m3yc0
    DsIconPathElement('m18.5 6 2.19 4.5a6.48 6.48 0 0 1-.139 4.393'), // key: 1rvkn7
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M6.355 6.37a7 7 0 0 0-.075.23c-1.1 3.13-.78 3.9-3.18 6.08A3 3 0 0 0 5 18c3.356 0 6.993-1.267 9.85-3.151'), // key: 54713r
  ]);

  /// `beef.mjs`
  static const DsLucideGlyph beef =
      DsLucideGlyph('beef', <DsIconElement>[
    DsIconPathElement('M16.4 13.7A6.5 6.5 0 1 0 6.28 6.6c-1.1 3.13-.78 3.9-3.18 6.08A3 3 0 0 0 5 18c4 0 8.4-1.8 11.4-4.3'), // key: cisjcv
    DsIconPathElement('m18.5 6 2.19 4.5a6.48 6.48 0 0 1-2.29 7.2C15.4 20.2 11 22 7 22a3 3 0 0 1-2.68-1.66L2.4 16.5'), // key: 5byaag
    DsIconCircleElement(12.5, 8.5, 2.5), // key: 9738u8
  ]);

  /// `beer-off.mjs`
  static const DsLucideGlyph beerOff =
      DsLucideGlyph('beer-off', <DsIconElement>[
    DsIconPathElement('M13 13v5'), // key: igwfh0
    DsIconPathElement('M17 11.47V8'), // key: 16yw0g
    DsIconPathElement('M17 11h1a3 3 0 0 1 2.745 4.211'), // key: 1xbt65
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M5 8v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2v-3'), // key: c55o3e
    DsIconPathElement('M7.536 7.535C6.766 7.649 6.154 8 5.5 8a2.5 2.5 0 0 1-1.768-4.268'), // key: 1ydug7
    DsIconPathElement('M8.727 3.204C9.306 2.767 9.885 2 11 2c1.56 0 2 1.5 3 1.5s1.72-.5 2.5-.5a1 1 0 1 1 0 5c-.78 0-1.5-.5-2.5-.5a3.149 3.149 0 0 0-.842.12'), // key: q81o7q
    DsIconPathElement('M9 14.6V18'), // key: 20ek98
  ]);

  /// `beer.mjs`
  static const DsLucideGlyph beer =
      DsLucideGlyph('beer', <DsIconElement>[
    DsIconPathElement('M17 11h1a3 3 0 0 1 0 6h-1'), // key: 1yp76v
    DsIconPathElement('M9 12v6'), // key: 1u1cab
    DsIconPathElement('M13 12v6'), // key: 1sugkk
    DsIconPathElement('M14 7.5c-1 0-1.44.5-3 .5s-2-.5-3-.5-1.72.5-2.5.5a2.5 2.5 0 0 1 0-5c.78 0 1.57.5 2.5.5S9.44 2 11 2s2 1.5 3 1.5 1.72-.5 2.5-.5a2.5 2.5 0 0 1 0 5c-.78 0-1.5-.5-2.5-.5Z'), // key: 1510fo
    DsIconPathElement('M5 8v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V8'), // key: 19jb7n
  ]);

  /// `bell-check.mjs`
  static const DsLucideGlyph bellCheck =
      DsLucideGlyph('bell-check', <DsIconElement>[
    DsIconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    DsIconPathElement('m15 8 2 2 4-4'), // key: sbrgsm
    DsIconPathElement('M16.8607 4.4824A6 6 0 0 0 6 8C6 12.499 4.589 13.956 3.262 15.326'), // key: qcog4a
    DsIconPathElement('M3.262 15.326A1 1 0 0 0 4 17H20A1 1 0 0 0 20.74 15.327C20.209 14.779 19.665 14.218 19.203 13.454'), // key: mxnnoh
  ]);

  /// `bell-dot.mjs`
  static const DsLucideGlyph bellDot =
      DsLucideGlyph('bell-dot', <DsIconElement>[
    DsIconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    DsIconPathElement('M11.68 2.009A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673c-.824-.85-1.678-1.731-2.21-3.348'), // key: xaq59h
    DsIconCircleElement(18, 5, 3), // key: gq8acd
  ]);

  /// `bell-electric.mjs`
  static const DsLucideGlyph bellElectric =
      DsLucideGlyph('bell-electric', <DsIconElement>[
    DsIconPathElement('M18.518 17.347A7 7 0 0 1 14 19'), // key: 1emhpo
    DsIconPathElement('M18.8 4A11 11 0 0 1 20 9'), // key: 127b67
    DsIconPathElement('M9 9h.01'), // key: 1q5me6
    DsIconCircleElement(20, 16, 2), // key: 1v9bxh
    DsIconCircleElement(9, 9, 7), // key: p2h5vp
    DsIconRectElement(4, 16, 10, 6, 2), // key: bfnviv
  ]);

  /// `bell-minus.mjs`
  static const DsLucideGlyph bellMinus =
      DsLucideGlyph('bell-minus', <DsIconElement>[
    DsIconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    DsIconPathElement('M15 8h6'), // key: 8ybuxh
    DsIconPathElement('M16.243 3.757A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673A9.4 9.4 0 0 1 18.667 12'), // key: bdwj86
  ]);

  /// `bell-off.mjs`
  static const DsLucideGlyph bellOff =
      DsLucideGlyph('bell-off', <DsIconElement>[
    DsIconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    DsIconPathElement('M17 17H4a1 1 0 0 1-.74-1.673C4.59 13.956 6 12.499 6 8a6 6 0 0 1 .258-1.742'), // key: 178tsu
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M8.668 3.01A6 6 0 0 1 18 8c0 2.687.77 4.653 1.707 6.05'), // key: 1hqiys
  ]);

  /// `bell-plus.mjs`
  static const DsLucideGlyph bellPlus =
      DsLucideGlyph('bell-plus', <DsIconElement>[
    DsIconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    DsIconPathElement('M15 8h6'), // key: 8ybuxh
    DsIconPathElement('M18 5v6'), // key: g5ayrv
    DsIconPathElement('M20.002 14.464a9 9 0 0 0 .738.863A1 1 0 0 1 20 17H4a1 1 0 0 1-.74-1.673C4.59 13.956 6 12.499 6 8a6 6 0 0 1 8.75-5.332'), // key: 1abcvy
  ]);

  /// `bell-ring.mjs`
  static const DsLucideGlyph bellRing =
      DsLucideGlyph('bell-ring', <DsIconElement>[
    DsIconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    DsIconPathElement('M22 8c0-2.3-.8-4.3-2-6'), // key: 5bb3ad
    DsIconPathElement('M3.262 15.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673C19.41 13.956 18 12.499 18 8A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326'), // key: 11g9vi
    DsIconPathElement('M4 2C2.8 3.7 2 5.7 2 8'), // key: tap9e0
  ]);

  /// `bell.mjs`
  static const DsLucideGlyph bell =
      DsLucideGlyph('bell', <DsIconElement>[
    DsIconPathElement('M10.268 21a2 2 0 0 0 3.464 0'), // key: vwvbt9
    DsIconPathElement('M3.262 15.326A1 1 0 0 0 4 17h16a1 1 0 0 0 .74-1.673C19.41 13.956 18 12.499 18 8A6 6 0 0 0 6 8c0 4.499-1.411 5.956-2.738 7.326'), // key: 11g9vi
  ]);

  /// `between-horizontal-end.mjs`
  static const DsLucideGlyph betweenHorizontalEnd =
      DsLucideGlyph('between-horizontal-end', <DsIconElement>[
    DsIconRectElement(3, 3, 13, 7, 1), // key: 11xb64
    DsIconPathElement('m22 15-3-3 3-3'), // key: 26chmm
    DsIconRectElement(3, 14, 13, 7, 1), // key: k6ky7n
  ]);

  /// `between-horizontal-start.mjs`
  static const DsLucideGlyph betweenHorizontalStart =
      DsLucideGlyph('between-horizontal-start', <DsIconElement>[
    DsIconRectElement(8, 3, 13, 7, 1), // key: pkso9a
    DsIconPathElement('m2 9 3 3-3 3'), // key: 1agib5
    DsIconRectElement(8, 14, 13, 7, 1), // key: 1q5fc1
  ]);

  /// `between-vertical-end.mjs`
  static const DsLucideGlyph betweenVerticalEnd =
      DsLucideGlyph('between-vertical-end', <DsIconElement>[
    DsIconRectElement(3, 3, 7, 13, 1), // key: 1fdu0f
    DsIconPathElement('m9 22 3-3 3 3'), // key: 17z65a
    DsIconRectElement(14, 3, 7, 13, 1), // key: 1squn4
  ]);

  /// `between-vertical-start.mjs`
  static const DsLucideGlyph betweenVerticalStart =
      DsLucideGlyph('between-vertical-start', <DsIconElement>[
    DsIconRectElement(3, 8, 7, 13, 1), // key: 1fjrkv
    DsIconPathElement('m15 2-3 3-3-3'), // key: 1uh6eb
    DsIconRectElement(14, 8, 7, 13, 1), // key: w3fjg8
  ]);

  /// `biceps-flexed.mjs`
  static const DsLucideGlyph bicepsFlexed =
      DsLucideGlyph('biceps-flexed', <DsIconElement>[
    DsIconPathElement('M12.409 13.017A5 5 0 0 1 22 15c0 3.866-4 7-9 7-4.077 0-8.153-.82-10.371-2.462-.426-.316-.631-.832-.62-1.362C2.118 12.723 2.627 2 10 2a3 3 0 0 1 3 3 2 2 0 0 1-2 2c-1.105 0-1.64-.444-2-1'), // key: 1pmlyh
    DsIconPathElement('M15 14a5 5 0 0 0-7.584 2'), // key: 5rb254
    DsIconPathElement('M9.964 6.825C8.019 7.977 9.5 13 8 15'), // key: kbvsx9
  ]);

  /// `bike.mjs`
  static const DsLucideGlyph bike =
      DsLucideGlyph('bike', <DsIconElement>[
    DsIconCircleElement(18.5, 17.5, 3.5), // key: 15x4ox
    DsIconCircleElement(5.5, 17.5, 3.5), // key: 1noe27
    DsIconCircleElement(15, 5, 1), // key: 19l28e
    DsIconPathElement('M12 17.5V14l-3-3 4-3 2 3h2'), // key: 1npguv
  ]);

  /// `binary.mjs`
  static const DsLucideGlyph binary =
      DsLucideGlyph('binary', <DsIconElement>[
    DsIconRectElement(14, 14, 4, 6, 2), // key: p02svl
    DsIconRectElement(6, 4, 4, 6, 2), // key: xm4xkj
    DsIconPathElement('M6 20h4'), // key: 1i6q5t
    DsIconPathElement('M14 10h4'), // key: ru81e7
    DsIconPathElement('M6 14h2v6'), // key: 16z9wg
    DsIconPathElement('M14 4h2v6'), // key: 1idq9u
  ]);

  /// `binoculars.mjs`
  static const DsLucideGlyph binoculars =
      DsLucideGlyph('binoculars', <DsIconElement>[
    DsIconPathElement('M10 10h4'), // key: tcdvrf
    DsIconPathElement('M19 7V4a1 1 0 0 0-1-1h-2a1 1 0 0 0-1 1v3'), // key: 3apit1
    DsIconPathElement('M20 21a2 2 0 0 0 2-2v-3.851c0-1.39-2-2.962-2-4.829V8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v11a2 2 0 0 0 2 2z'), // key: rhpgnw
    DsIconPathElement('M 22 16 L 2 16'), // key: 14lkq7
    DsIconPathElement('M4 21a2 2 0 0 1-2-2v-3.851c0-1.39 2-2.962 2-4.829V8a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v11a2 2 0 0 1-2 2z'), // key: 104b3k
    DsIconPathElement('M9 7V4a1 1 0 0 0-1-1H6a1 1 0 0 0-1 1v3'), // key: 14fczp
  ]);

  /// `biohazard.mjs`
  static const DsLucideGlyph biohazard =
      DsLucideGlyph('biohazard', <DsIconElement>[
    DsIconCircleElement(12, 11.9, 2), // key: e8h31w
    DsIconPathElement('M6.7 3.4c-.9 2.5 0 5.2 2.2 6.7C6.5 9 3.7 9.6 2 11.6'), // key: 17bolr
    DsIconPathElement('m8.9 10.1 1.4.8'), // key: 15ezny
    DsIconPathElement('M17.3 3.4c.9 2.5 0 5.2-2.2 6.7 2.4-1.2 5.2-.6 6.9 1.5'), // key: wtwa5u
    DsIconPathElement('m15.1 10.1-1.4.8'), // key: 1r0b28
    DsIconPathElement('M16.7 20.8c-2.6-.4-4.6-2.6-4.7-5.3-.2 2.6-2.1 4.8-4.7 5.2'), // key: m7qszh
    DsIconPathElement('M12 13.9v1.6'), // key: zfyyim
    DsIconPathElement('M13.5 5.4c-1-.2-2-.2-3 0'), // key: 1bi9q0
    DsIconPathElement('M17 16.4c.7-.7 1.2-1.6 1.5-2.5'), // key: 1rhjqw
    DsIconPathElement('M5.5 13.9c.3.9.8 1.8 1.5 2.5'), // key: 8gsud3
  ]);

  /// `bird.mjs`
  static const DsLucideGlyph bird =
      DsLucideGlyph('bird', <DsIconElement>[
    DsIconPathElement('M16 7h.01'), // key: 1kdx03
    DsIconPathElement('M3.4 18H12a8 8 0 0 0 8-8V7a4 4 0 0 0-7.28-2.3L2 20'), // key: oj1oa8
    DsIconPathElement('m20 7 2 .5-2 .5'), // key: 12nv4d
    DsIconPathElement('M10 18v3'), // key: 1yea0a
    DsIconPathElement('M14 17.75V21'), // key: 1pymcb
    DsIconPathElement('M7 18a6 6 0 0 0 3.84-10.61'), // key: 1npnn0
  ]);

  /// `birdhouse.mjs`
  static const DsLucideGlyph birdhouse =
      DsLucideGlyph('birdhouse', <DsIconElement>[
    DsIconPathElement('M12 18v4'), // key: jadmvz
    DsIconPathElement('m17 18 1.956-11.468'), // key: l5n2ro
    DsIconPathElement('m3 8 7.82-5.615a2 2 0 0 1 2.36 0L21 8'), // key: 1sy6n7
    DsIconPathElement('M4 18h16'), // key: 19g7jn
    DsIconPathElement('M7 18 5.044 6.532'), // key: 1uqdf2
    DsIconCircleElement(12, 10, 2), // key: 1yojzk
  ]);

  /// `bitcoin.mjs`
  static const DsLucideGlyph bitcoin =
      DsLucideGlyph('bitcoin', <DsIconElement>[
    DsIconPathElement('M11.767 19.089c4.924.868 6.14-6.025 1.216-6.894m-1.216 6.894L5.86 18.047m5.908 1.042-.347 1.97m1.563-8.864c4.924.869 6.14-6.025 1.215-6.893m-1.215 6.893-3.94-.694m5.155-6.2L8.29 4.26m5.908 1.042.348-1.97M7.48 20.364l3.126-17.727'), // key: yr8idg
  ]);

  /// `blend.mjs`
  static const DsLucideGlyph blend =
      DsLucideGlyph('blend', <DsIconElement>[
    DsIconCircleElement(9, 9, 7), // key: p2h5vp
    DsIconCircleElement(15, 15, 7), // key: 19ennj
  ]);

  /// `blender.mjs`
  static const DsLucideGlyph blender =
      DsLucideGlyph('blender', <DsIconElement>[
    DsIconPathElement('M8 14a2 2 0 0 0-1.963 1.615l-1.018 5.193A1 1 0 0 0 6 22h12a1 1 0 0 0 .981-1.192l-1.018-5.193A2 2 0 0 0 16 14z'), // key: 11zxmj
    DsIconPathElement('m17 2-1 12'), // key: nxm2fw
    DsIconPathElement('M8.006 14 7 2'), // key: 13bxiv
    DsIconPathElement('M7.565 8.787A5 5 0 0 0 12 8a5 5 0 0 1 4.56-.75'), // key: 1s61ad
    DsIconPathElement('M19 2H5a2 2 0 0 0-2 2v5a2 2 0 0 0 .688 1.5'), // key: gel3rg
    DsIconPathElement('M12 18h.01'), // key: mhygvu
  ]);

  /// `blinds.mjs`
  static const DsLucideGlyph blinds =
      DsLucideGlyph('blinds', <DsIconElement>[
    DsIconPathElement('M3 3h18'), // key: o7r712
    DsIconPathElement('M20 7H8'), // key: gd2fo2
    DsIconPathElement('M20 11H8'), // key: 1ynp89
    DsIconPathElement('M10 19h10'), // key: 19hjk5
    DsIconPathElement('M8 15h12'), // key: 1yqzne
    DsIconPathElement('M4 3v14'), // key: fggqzn
    DsIconCircleElement(4, 19, 2), // key: p3m9r0
  ]);

  /// `blocks.mjs`
  static const DsLucideGlyph blocks =
      DsLucideGlyph('blocks', <DsIconElement>[
    DsIconPathElement('M10 22V7a1 1 0 0 0-1-1H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-5a1 1 0 0 0-1-1H2'), // key: 1ah6g2
    DsIconRectElement(14, 2, 8, 8, 1), // key: 88lufb
  ]);

  /// `bluetooth-connected.mjs`
  static const DsLucideGlyph bluetoothConnected =
      DsLucideGlyph('bluetooth-connected', <DsIconElement>[
    DsIconPathElement('m7 7 10 10-5 5V2l5 5L7 17'), // key: 1q5490
    DsIconLineElement(18, 12, 21, 12), // key: 1rsjjs
    DsIconLineElement(3, 12, 6, 12), // key: 11yl8c
  ]);

  /// `bluetooth-off.mjs`
  static const DsLucideGlyph bluetoothOff =
      DsLucideGlyph('bluetooth-off', <DsIconElement>[
    DsIconPathElement('m17 17-5 5V12l-5 5'), // key: v5aci6
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M14.5 9.5 17 7l-5-5v4.5'), // key: 1kddfz
  ]);

  /// `bluetooth-searching.mjs`
  static const DsLucideGlyph bluetoothSearching =
      DsLucideGlyph('bluetooth-searching', <DsIconElement>[
    DsIconPathElement('m7 7 10 10-5 5V2l5 5L7 17'), // key: 1q5490
    DsIconPathElement('M20.83 14.83a4 4 0 0 0 0-5.66'), // key: k8tn1j
    DsIconPathElement('M18 12h.01'), // key: yjnet6
  ]);

  /// `bluetooth.mjs`
  static const DsLucideGlyph bluetooth =
      DsLucideGlyph('bluetooth', <DsIconElement>[
    DsIconPathElement('m7 7 10 10-5 5V2l5 5L7 17'), // key: 1q5490
  ]);

  /// `bold.mjs`
  static const DsLucideGlyph bold =
      DsLucideGlyph('bold', <DsIconElement>[
    DsIconPathElement('M6 12h9a4 4 0 0 1 0 8H7a1 1 0 0 1-1-1V5a1 1 0 0 1 1-1h7a4 4 0 0 1 0 8'), // key: mg9rjx
  ]);

  /// `bolt.mjs`
  static const DsLucideGlyph bolt =
      DsLucideGlyph('bolt', <DsIconElement>[
    DsIconPathElement('M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z'), // key: yt0hxn
    DsIconCircleElement(12, 12, 4), // key: 4exip2
  ]);

  /// `bomb.mjs`
  static const DsLucideGlyph bomb =
      DsLucideGlyph('bomb', <DsIconElement>[
    DsIconCircleElement(11, 13, 9), // key: hd149
    DsIconPathElement('M14.35 4.65 16.3 2.7a2.41 2.41 0 0 1 3.4 0l1.6 1.6a2.4 2.4 0 0 1 0 3.4l-1.95 1.95'), // key: jp4j1b
    DsIconPathElement('m22 2-1.5 1.5'), // key: ay92ug
  ]);

  /// `bone-fracture.mjs`
  static const DsLucideGlyph boneFracture =
      DsLucideGlyph('bone-fracture', <DsIconElement>[
    DsIconPathElement('M14 4.5a1 1 0 0 1 5 0 .5.5 0 0 0 .5.5 1 1 0 0 1 0 5c-.81 0-1.8-.7-2.5 0l-1.958 1.957a.15.15 0 0 1-.252-.072l-.493-2.07a.15.15 0 0 0-.111-.112l-2.072-.494a.15.15 0 0 1-.072-.252L14 7c.7-.7 0-1.69 0-2.5'), // key: 1c7o5b
    DsIconPathElement('m16 20-1-2'), // key: 5348lt
    DsIconPathElement('m20 16-2-1'), // key: 2c7pv5
    DsIconPathElement('m4 8 2 1'), // key: rpj1x4
    DsIconPathElement('m8 4 1 2'), // key: 1r4zbp
    DsIconPathElement('M9.698 14.19a.15.15 0 0 0 .112.112l2.074.489a.15.15 0 0 1 .072.252L10 17c-.7.7 0 1.69 0 2.5a1 1 0 0 1-5 0 .495.495 0 0 0-.5-.5 1 1 0 0 1 0-5c.81 0 1.8.7 2.5 0l1.956-1.957a.15.15 0 0 1 .252.072z'), // key: 3u61yx
  ]);

  /// `bone.mjs`
  static const DsLucideGlyph bone =
      DsLucideGlyph('bone', <DsIconElement>[
    DsIconPathElement('M17 10c.7-.7 1.69 0 2.5 0a2.5 2.5 0 1 0 0-5 .5.5 0 0 1-.5-.5 2.5 2.5 0 1 0-5 0c0 .81.7 1.8 0 2.5l-7 7c-.7.7-1.69 0-2.5 0a2.5 2.5 0 0 0 0 5c.28 0 .5.22.5.5a2.5 2.5 0 1 0 5 0c0-.81-.7-1.8 0-2.5Z'), // key: w610uw
  ]);

  /// `book-a.mjs`
  static const DsLucideGlyph bookA =
      DsLucideGlyph('book-a', <DsIconElement>[
    DsIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: k3hazp
    DsIconPathElement('m8 13 4-7 4 7'), // key: 4rari8
    DsIconPathElement('M9.1 11h5.7'), // key: 1gkovt
  ]);

  /// `book-alert.mjs`
  static const DsLucideGlyph bookAlert =
      DsLucideGlyph('book-alert', <DsIconElement>[
    DsIconPathElement('M12 13h.01'), // key: y0uutt
    DsIconPathElement('M12 6v3'), // key: 1m4b9j
    DsIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: k3hazp
  ]);

  /// `book-audio.mjs`
  static const DsLucideGlyph bookAudio =
      DsLucideGlyph('book-audio', <DsIconElement>[
    DsIconPathElement('M12 6v7'), // key: 1f6ttz
    DsIconPathElement('M16 8v3'), // key: gejaml
    DsIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: k3hazp
    DsIconPathElement('M8 8v3'), // key: 1qzp49
  ]);

  /// `book-check.mjs`
  static const DsLucideGlyph bookCheck =
      DsLucideGlyph('book-check', <DsIconElement>[
    DsIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: k3hazp
    DsIconPathElement('m9 9.5 2 2 4-4'), // key: 1dth82
  ]);

  /// `book-copy.mjs`
  static const DsLucideGlyph bookCopy =
      DsLucideGlyph('book-copy', <DsIconElement>[
    DsIconPathElement('M5 7a2 2 0 0 0-2 2v11'), // key: 1yhqjt
    DsIconPathElement('M5.803 18H5a2 2 0 0 0 0 4h9.5a.5.5 0 0 0 .5-.5V21'), // key: edzzo5
    DsIconPathElement('M9 15V4a2 2 0 0 1 2-2h9.5a.5.5 0 0 1 .5.5v14a.5.5 0 0 1-.5.5H11a2 2 0 0 1 0-4h10'), // key: 1nwzrg
  ]);

  /// `book-dashed.mjs`
  static const DsLucideGlyph bookDashed =
      DsLucideGlyph('book-dashed', <DsIconElement>[
    DsIconPathElement('M12 17h1.5'), // key: 1gkc67
    DsIconPathElement('M12 22h1.5'), // key: 1my7sn
    DsIconPathElement('M12 2h1.5'), // key: 19tvb7
    DsIconPathElement('M17.5 22H19a1 1 0 0 0 1-1'), // key: 10akbh
    DsIconPathElement('M17.5 2H19a1 1 0 0 1 1 1v1.5'), // key: 1vrfjs
    DsIconPathElement('M20 14v3h-2.5'), // key: 1naeju
    DsIconPathElement('M20 8.5V10'), // key: 1ctpfu
    DsIconPathElement('M4 10V8.5'), // key: 1o3zg5
    DsIconPathElement('M4 19.5V14'), // key: ob81pf
    DsIconPathElement('M4 4.5A2.5 2.5 0 0 1 6.5 2H8'), // key: s8vcyb
    DsIconPathElement('M8 22H6.5a1 1 0 0 1 0-5H8'), // key: 1cu73q
  ]);

  /// `book-down.mjs`
  static const DsLucideGlyph bookDown =
      DsLucideGlyph('book-down', <DsIconElement>[
    DsIconPathElement('M12 13V7'), // key: h0r20n
    DsIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: k3hazp
    DsIconPathElement('m9 10 3 3 3-3'), // key: zt5b4y
  ]);

  /// `book-headphones.mjs`
  static const DsLucideGlyph bookHeadphones =
      DsLucideGlyph('book-headphones', <DsIconElement>[
    DsIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: k3hazp
    DsIconPathElement('M8 12v-2a4 4 0 0 1 8 0v2'), // key: 1vsqkj
    DsIconCircleElement(15, 12, 1), // key: 1tmaij
    DsIconCircleElement(9, 12, 1), // key: 1vctgf
  ]);

  /// `book-heart.mjs`
  static const DsLucideGlyph bookHeart =
      DsLucideGlyph('book-heart', <DsIconElement>[
    DsIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: k3hazp
    DsIconPathElement('M8.62 9.8A2.25 2.25 0 1 1 12 6.836a2.25 2.25 0 1 1 3.38 2.966l-2.626 2.856a.998.998 0 0 1-1.507 0z'), // key: 9v40y5
  ]);

  /// `book-image.mjs`
  static const DsLucideGlyph bookImage =
      DsLucideGlyph('book-image', <DsIconElement>[
    DsIconPathElement('m20 13.7-2.1-2.1a2 2 0 0 0-2.8 0L9.7 17'), // key: q6ojf0
    DsIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: k3hazp
    DsIconCircleElement(10, 8, 2), // key: 2qkj4p
  ]);

  /// `book-key.mjs`
  static const DsLucideGlyph bookKey =
      DsLucideGlyph('book-key', <DsIconElement>[
    DsIconPathElement('M13 2H6.5A2.5 2.5 0 0 0 4 4.5v15'), // key: 4azifu
    DsIconPathElement('M17 2v6'), // key: qgmh37
    DsIconPathElement('M17 4h2'), // key: 13vrzo
    DsIconPathElement('M20 15.2V21a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: 192hzx
    DsIconCircleElement(17, 10, 2), // key: y0i25j
  ]);

  /// `book-lock.mjs`
  static const DsLucideGlyph bookLock =
      DsLucideGlyph('book-lock', <DsIconElement>[
    DsIconPathElement('M18 6V4a2 2 0 1 0-4 0v2'), // key: 1aquzs
    DsIconPathElement('M20 15v6a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: 1rkj32
    DsIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H10'), // key: 18wgow
    DsIconRectElement(12, 6, 8, 5, 1), // key: 73l30o
  ]);

  /// `book-marked.mjs`
  static const DsLucideGlyph bookMarked =
      DsLucideGlyph('book-marked', <DsIconElement>[
    DsIconPathElement('M10 2v8l3-3 3 3V2'), // key: sqw3rj
    DsIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: k3hazp
  ]);

  /// `book-minus.mjs`
  static const DsLucideGlyph bookMinus =
      DsLucideGlyph('book-minus', <DsIconElement>[
    DsIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: k3hazp
    DsIconPathElement('M9 10h6'), // key: 9gxzsh
  ]);

  /// `book-open-check.mjs`
  static const DsLucideGlyph bookOpenCheck =
      DsLucideGlyph('book-open-check', <DsIconElement>[
    DsIconPathElement('M12 5v16'), // key: 1f6ucr
    DsIconPathElement('m16 12 2 2 4-4'), // key: mdajum
    DsIconPathElement('M22 6V5a2 2 0 00-1.999-2L16 3.002A5 5 0 0012 5a5 5 0 00-4-2H4a2 2 0 00-2 2v12a2 2 0 001.999 2H8a5 5 0 014 2 5 5 0 014-2h4.001A2 2 0 0022 17v-1.344'), // key: 144kbk
  ]);

  /// `book-open-text.mjs`
  static const DsLucideGlyph bookOpenText =
      DsLucideGlyph('book-open-text', <DsIconElement>[
    DsIconPathElement('M12 5v16'), // key: 1f6ucr
    DsIconPathElement('M16 13h2'), // key: weia3s
    DsIconPathElement('M16 9h2'), // key: 1n7gjm
    DsIconPathElement('M20.001 19A2 2 0 0022 17V5a2 2 0 00-1.999-2L16 3.002A5 5 0 0012 5a5 5 0 00-4-2H4a2 2 0 00-2 2v12a2 2 0 001.999 2H8a5 5 0 014 2 5 5 0 014-2z'), // key: 1fyvmf
    DsIconPathElement('M6 13h2'), // key: 1cckiz
    DsIconPathElement('M6 9h2'), // key: 1k7j9f
  ]);

  /// `book-open.mjs`
  static const DsLucideGlyph bookOpen =
      DsLucideGlyph('book-open', <DsIconElement>[
    DsIconPathElement('M12 5v16'), // key: 1f6ucr
    DsIconPathElement('M20.001 19A2 2 0 0022 17V5a2 2 0 00-1.999-2L16 3.002A5 5 0 0012 5a5 5 0 00-4-2H4a2 2 0 00-2 2v12a2 2 0 001.999 2H8a5 5 0 014 2 5 5 0 014-2z'), // key: 1fyvmf
  ]);

  /// `book-plus.mjs`
  static const DsLucideGlyph bookPlus =
      DsLucideGlyph('book-plus', <DsIconElement>[
    DsIconPathElement('M12 7v6'), // key: lw1j43
    DsIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: k3hazp
    DsIconPathElement('M9 10h6'), // key: 9gxzsh
  ]);

  /// `book-search.mjs`
  static const DsLucideGlyph bookSearch =
      DsLucideGlyph('book-search', <DsIconElement>[
    DsIconPathElement('M11 22H5.5a1 1 0 0 1 0-5h4.501'), // key: mcbepb
    DsIconPathElement('m21 22-1.879-1.878'), // key: 12q7x1
    DsIconPathElement('M3 19.5v-15A2.5 2.5 0 0 1 5.5 2H18a1 1 0 0 1 1 1v8'), // key: olfd5n
    DsIconCircleElement(17, 18, 3), // key: 82mm0e
  ]);

  /// `book-text.mjs`
  static const DsLucideGlyph bookText =
      DsLucideGlyph('book-text', <DsIconElement>[
    DsIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: k3hazp
    DsIconPathElement('M8 11h8'), // key: vwpz6n
    DsIconPathElement('M8 7h6'), // key: 1f0q6e
  ]);

  /// `book-type.mjs`
  static const DsLucideGlyph bookType =
      DsLucideGlyph('book-type', <DsIconElement>[
    DsIconPathElement('M10 13h4'), // key: ytezjc
    DsIconPathElement('M12 6v7'), // key: 1f6ttz
    DsIconPathElement('M16 8V6H8v2'), // key: x8j6u4
    DsIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: k3hazp
  ]);

  /// `book-up-2.mjs`
  static const DsLucideGlyph bookUp2 =
      DsLucideGlyph('book-up-2', <DsIconElement>[
    DsIconPathElement('M12 13V7'), // key: h0r20n
    DsIconPathElement('M18 2h1a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: 161d7n
    DsIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2'), // key: 1lorq7
    DsIconPathElement('m9 10 3-3 3 3'), // key: 11gsxs
    DsIconPathElement('m9 5 3-3 3 3'), // key: l8vdw6
  ]);

  /// `book-up.mjs`
  static const DsLucideGlyph bookUp =
      DsLucideGlyph('book-up', <DsIconElement>[
    DsIconPathElement('M12 13V7'), // key: h0r20n
    DsIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: k3hazp
    DsIconPathElement('m9 10 3-3 3 3'), // key: 11gsxs
  ]);

  /// `book-user.mjs`
  static const DsLucideGlyph bookUser =
      DsLucideGlyph('book-user', <DsIconElement>[
    DsIconPathElement('M15 13a3 3 0 1 0-6 0'), // key: 10j68g
    DsIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: k3hazp
    DsIconCircleElement(12, 8, 2), // key: 1822b1
  ]);

  /// `book-x.mjs`
  static const DsLucideGlyph bookX =
      DsLucideGlyph('book-x', <DsIconElement>[
    DsIconPathElement('m14.5 7-5 5'), // key: dy991v
    DsIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: k3hazp
    DsIconPathElement('m9.5 7 5 5'), // key: s45iea
  ]);

  /// `book.mjs`
  static const DsLucideGlyph book =
      DsLucideGlyph('book', <DsIconElement>[
    DsIconPathElement('M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H19a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1H6.5a1 1 0 0 1 0-5H20'), // key: k3hazp
  ]);

  /// `bookmark-check.mjs`
  static const DsLucideGlyph bookmarkCheck =
      DsLucideGlyph('bookmark-check', <DsIconElement>[
    DsIconPathElement('M17 3a2 2 0 0 1 2 2v15a1 1 0 0 1-1.496.868l-4.512-2.578a2 2 0 0 0-1.984 0l-4.512 2.578A1 1 0 0 1 5 20V5a2 2 0 0 1 2-2z'), // key: oz39mx
    DsIconPathElement('m9 10 2 2 4-4'), // key: 1gnqz4
  ]);

  /// `bookmark-minus.mjs`
  static const DsLucideGlyph bookmarkMinus =
      DsLucideGlyph('bookmark-minus', <DsIconElement>[
    DsIconPathElement('M15 10H9'), // key: o6yqo3
    DsIconPathElement('M17 3a2 2 0 0 1 2 2v15a1 1 0 0 1-1.496.868l-4.512-2.578a2 2 0 0 0-1.984 0l-4.512 2.578A1 1 0 0 1 5 20V5a2 2 0 0 1 2-2z'), // key: oz39mx
  ]);

  /// `bookmark-off.mjs`
  static const DsLucideGlyph bookmarkOff =
      DsLucideGlyph('bookmark-off', <DsIconElement>[
    DsIconPathElement('M19 19v1a1 1 0 0 1-1.496.868l-4.512-2.578a2 2 0 0 0-1.984 0l-4.512 2.578A1 1 0 0 1 5 20V5'), // key: nigmce
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M8.656 3H17a2 2 0 0 1 2 2v8.344'), // key: hlvsa
  ]);

  /// `bookmark-plus.mjs`
  static const DsLucideGlyph bookmarkPlus =
      DsLucideGlyph('bookmark-plus', <DsIconElement>[
    DsIconPathElement('M12 7v6'), // key: lw1j43
    DsIconPathElement('M15 10H9'), // key: o6yqo3
    DsIconPathElement('M17 3a2 2 0 0 1 2 2v15a1 1 0 0 1-1.496.868l-4.512-2.578a2 2 0 0 0-1.984 0l-4.512 2.578A1 1 0 0 1 5 20V5a2 2 0 0 1 2-2z'), // key: oz39mx
  ]);

  /// `bookmark-x.mjs`
  static const DsLucideGlyph bookmarkX =
      DsLucideGlyph('bookmark-x', <DsIconElement>[
    DsIconPathElement('m14.5 7.5-5 5'), // key: 3lb6iw
    DsIconPathElement('M17 3a2 2 0 0 1 2 2v15a1 1 0 0 1-1.496.868l-4.512-2.578a2 2 0 0 0-1.984 0l-4.512 2.578A1 1 0 0 1 5 20V5a2 2 0 0 1 2-2z'), // key: oz39mx
    DsIconPathElement('m9.5 7.5 5 5'), // key: ko136h
  ]);

  /// `bookmark.mjs`
  static const DsLucideGlyph bookmark =
      DsLucideGlyph('bookmark', <DsIconElement>[
    DsIconPathElement('M17 3a2 2 0 0 1 2 2v15a1 1 0 0 1-1.496.868l-4.512-2.578a2 2 0 0 0-1.984 0l-4.512 2.578A1 1 0 0 1 5 20V5a2 2 0 0 1 2-2z'), // key: oz39mx
  ]);

  /// `boom-box.mjs`
  static const DsLucideGlyph boomBox =
      DsLucideGlyph('boom-box', <DsIconElement>[
    DsIconPathElement('M4 9V5a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v4'), // key: vvzvr1
    DsIconPathElement('M8 8v1'), // key: xcqmfk
    DsIconPathElement('M12 8v1'), // key: 1rj8u4
    DsIconPathElement('M16 8v1'), // key: 1q12zr
    DsIconRectElement(2, 9, 20, 12, 2), // key: igpb89
    DsIconCircleElement(8, 15, 2), // key: fa4a8s
    DsIconCircleElement(16, 15, 2), // key: 14c3ya
  ]);

  /// `bot-message-square.mjs`
  static const DsLucideGlyph botMessageSquare =
      DsLucideGlyph('bot-message-square', <DsIconElement>[
    DsIconPathElement('M12 6V2H8'), // key: 1155em
    DsIconPathElement('M15 11v2'), // key: i11awn
    DsIconPathElement('M2 12h2'), // key: 1t8f8n
    DsIconPathElement('M20 12h2'), // key: 1q8mjw
    DsIconPathElement('M20 16a2 2 0 0 1-2 2H8.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 4 20.286V8a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2z'), // key: 11gyqh
    DsIconPathElement('M9 11v2'), // key: 1ueba0
  ]);

  /// `bot-off.mjs`
  static const DsLucideGlyph botOff =
      DsLucideGlyph('bot-off', <DsIconElement>[
    DsIconPathElement('M13.67 8H18a2 2 0 0 1 2 2v4.33'), // key: 7az073
    DsIconPathElement('M2 14h2'), // key: vft8re
    DsIconPathElement('M20 14h2'), // key: 4cs60a
    DsIconPathElement('M22 22 2 2'), // key: 1r8tn9
    DsIconPathElement('M8 8H6a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h12a2 2 0 0 0 1.414-.586'), // key: s09a7a
    DsIconPathElement('M9 13v2'), // key: rq6x2g
    DsIconPathElement('M9.67 4H12v2.33'), // key: 110xot
  ]);

  /// `bot.mjs`
  static const DsLucideGlyph bot =
      DsLucideGlyph('bot', <DsIconElement>[
    DsIconPathElement('M12 8V4H8'), // key: hb8ula
    DsIconRectElement(4, 8, 16, 12, 2), // key: enze0r
    DsIconPathElement('M2 14h2'), // key: vft8re
    DsIconPathElement('M20 14h2'), // key: 4cs60a
    DsIconPathElement('M15 13v2'), // key: 1xurst
    DsIconPathElement('M9 13v2'), // key: rq6x2g
  ]);

  /// `bottle-wine.mjs`
  static const DsLucideGlyph bottleWine =
      DsLucideGlyph('bottle-wine', <DsIconElement>[
    DsIconPathElement('M10 3a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v2a6 6 0 0 0 1.2 3.6l.6.8A6 6 0 0 1 17 13v8a1 1 0 0 1-1 1H8a1 1 0 0 1-1-1v-8a6 6 0 0 1 1.2-3.6l.6-.8A6 6 0 0 0 10 5z'), // key: blqgoc
    DsIconPathElement('M17 13h-4a1 1 0 0 0-1 1v3a1 1 0 0 0 1 1h4'), // key: 43jbee
  ]);

  /// `bow-arrow.mjs`
  static const DsLucideGlyph bowArrow =
      DsLucideGlyph('bow-arrow', <DsIconElement>[
    DsIconPathElement('M17 3h4v4'), // key: 19p9u1
    DsIconPathElement('M18.575 11.082a13 13 0 0 1 1.048 9.027 1.17 1.17 0 0 1-1.914.597L14 17'), // key: 12t3w9
    DsIconPathElement('M7 10 3.29 6.29a1.17 1.17 0 0 1 .6-1.91 13 13 0 0 1 9.03 1.05'), // key: ogng5l
    DsIconPathElement('M7 14a1.7 1.7 0 0 0-1.207.5l-2.646 2.646A.5.5 0 0 0 3.5 18H5a1 1 0 0 1 1 1v1.5a.5.5 0 0 0 .854.354L9.5 18.207A1.7 1.7 0 0 0 10 17v-2a1 1 0 0 0-1-1z'), // key: 8v3fy2
    DsIconPathElement('M9.707 14.293 21 3'), // key: ydm3bn
  ]);

  /// `box.mjs`
  static const DsLucideGlyph box =
      DsLucideGlyph('box', <DsIconElement>[
    DsIconPathElement('M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z'), // key: hh9hay
    DsIconPathElement('m3.3 7 8.7 5 8.7-5'), // key: g66t2b
    DsIconPathElement('M12 22V12'), // key: d0xqtd
  ]);

  /// `boxes.mjs`
  static const DsLucideGlyph boxes =
      DsLucideGlyph('boxes', <DsIconElement>[
    DsIconPathElement('M2.97 12.92A2 2 0 0 0 2 14.63v3.24a2 2 0 0 0 .97 1.71l3 1.8a2 2 0 0 0 2.06 0L12 19v-5.5l-5-3-4.03 2.42Z'), // key: lc1i9w
    DsIconPathElement('m7 16.5-4.74-2.85'), // key: 1o9zyk
    DsIconPathElement('m7 16.5 5-3'), // key: va8pkn
    DsIconPathElement('M7 16.5v5.17'), // key: jnp8gn
    DsIconPathElement('M12 13.5V19l3.97 2.38a2 2 0 0 0 2.06 0l3-1.8a2 2 0 0 0 .97-1.71v-3.24a2 2 0 0 0-.97-1.71L17 10.5l-5 3Z'), // key: 8zsnat
    DsIconPathElement('m17 16.5-5-3'), // key: 8arw3v
    DsIconPathElement('m17 16.5 4.74-2.85'), // key: 8rfmw
    DsIconPathElement('M17 16.5v5.17'), // key: k6z78m
    DsIconPathElement('M7.97 4.42A2 2 0 0 0 7 6.13v4.37l5 3 5-3V6.13a2 2 0 0 0-.97-1.71l-3-1.8a2 2 0 0 0-2.06 0l-3 1.8Z'), // key: 1xygjf
    DsIconPathElement('M12 8 7.26 5.15'), // key: 1vbdud
    DsIconPathElement('m12 8 4.74-2.85'), // key: 3rx089
    DsIconPathElement('M12 13.5V8'), // key: 1io7kd
  ]);

  /// `braces.mjs`
  static const DsLucideGlyph braces =
      DsLucideGlyph('braces', <DsIconElement>[
    DsIconPathElement('M8 3H7a2 2 0 0 0-2 2v5a2 2 0 0 1-2 2 2 2 0 0 1 2 2v5c0 1.1.9 2 2 2h1'), // key: ezmyqa
    DsIconPathElement('M16 21h1a2 2 0 0 0 2-2v-5c0-1.1.9-2 2-2a2 2 0 0 1-2-2V5a2 2 0 0 0-2-2h-1'), // key: e1hn23
  ]);

  /// `brackets.mjs`
  static const DsLucideGlyph brackets =
      DsLucideGlyph('brackets', <DsIconElement>[
    DsIconPathElement('M16 3h3a1 1 0 0 1 1 1v16a1 1 0 0 1-1 1h-3'), // key: 1kt8lf
    DsIconPathElement('M8 21H5a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h3'), // key: gduv9
  ]);

  /// `brain-circuit.mjs`
  static const DsLucideGlyph brainCircuit =
      DsLucideGlyph('brain-circuit', <DsIconElement>[
    DsIconPathElement('M12 5a3 3 0 1 0-5.997.125 4 4 0 0 0-2.526 5.77 4 4 0 0 0 .556 6.588A4 4 0 1 0 12 18Z'), // key: l5xja
    DsIconPathElement('M9 13a4.5 4.5 0 0 0 3-4'), // key: 10igwf
    DsIconPathElement('M6.003 5.125A3 3 0 0 0 6.401 6.5'), // key: 105sqy
    DsIconPathElement('M3.477 10.896a4 4 0 0 1 .585-.396'), // key: ql3yin
    DsIconPathElement('M6 18a4 4 0 0 1-1.967-.516'), // key: 2e4loj
    DsIconPathElement('M12 13h4'), // key: 1ku699
    DsIconPathElement('M12 18h6a2 2 0 0 1 2 2v1'), // key: 105ag5
    DsIconPathElement('M12 8h8'), // key: 1lhi5i
    DsIconPathElement('M16 8V5a2 2 0 0 1 2-2'), // key: u6izg6
    DsIconCircleElement(16, 13, 0.5), // key: ry7gng
    DsIconCircleElement(18, 3, 0.5), // key: 1aiba7
    DsIconCircleElement(20, 21, 0.5), // key: yhc1fs
    DsIconCircleElement(20, 8, 0.5), // key: 1e43v0
  ]);

  /// `brain-cog.mjs`
  static const DsLucideGlyph brainCog =
      DsLucideGlyph('brain-cog', <DsIconElement>[
    DsIconPathElement('m10.852 14.772-.383.923'), // key: 11vil6
    DsIconPathElement('m10.852 9.228-.383-.923'), // key: 1fjppe
    DsIconPathElement('m13.148 14.772.382.924'), // key: je3va1
    DsIconPathElement('m13.531 8.305-.383.923'), // key: 18epck
    DsIconPathElement('m14.772 10.852.923-.383'), // key: k9m8cz
    DsIconPathElement('m14.772 13.148.923.383'), // key: 1xvhww
    DsIconPathElement('M17.598 6.5A3 3 0 1 0 12 5a3 3 0 0 0-5.63-1.446 3 3 0 0 0-.368 1.571 4 4 0 0 0-2.525 5.771'), // key: jcbbz1
    DsIconPathElement('M17.998 5.125a4 4 0 0 1 2.525 5.771'), // key: 1kkn7e
    DsIconPathElement('M19.505 10.294a4 4 0 0 1-1.5 7.706'), // key: 18bmuc
    DsIconPathElement('M4.032 17.483A4 4 0 0 0 11.464 20c.18-.311.892-.311 1.072 0a4 4 0 0 0 7.432-2.516'), // key: uozx0d
    DsIconPathElement('M4.5 10.291A4 4 0 0 0 6 18'), // key: whdemb
    DsIconPathElement('M6.002 5.125a3 3 0 0 0 .4 1.375'), // key: 1kqy2g
    DsIconPathElement('m9.228 10.852-.923-.383'), // key: 1wtb30
    DsIconPathElement('m9.228 13.148-.923.383'), // key: 1a830x
    DsIconCircleElement(12, 12, 3), // key: 1v7zrd
  ]);

  /// `brain.mjs`
  static const DsLucideGlyph brain =
      DsLucideGlyph('brain', <DsIconElement>[
    DsIconPathElement('M12 18V5'), // key: adv99a
    DsIconPathElement('M15 13a4.17 4.17 0 0 1-3-4 4.17 4.17 0 0 1-3 4'), // key: 1e3is1
    DsIconPathElement('M17.598 6.5A3 3 0 1 0 12 5a3 3 0 1 0-5.598 1.5'), // key: 1gqd8o
    DsIconPathElement('M17.997 5.125a4 4 0 0 1 2.526 5.77'), // key: iwvgf7
    DsIconPathElement('M18 18a4 4 0 0 0 2-7.464'), // key: efp6ie
    DsIconPathElement('M19.967 17.483A4 4 0 1 1 12 18a4 4 0 1 1-7.967-.517'), // key: 1gq6am
    DsIconPathElement('M6 18a4 4 0 0 1-2-7.464'), // key: k1g0md
    DsIconPathElement('M6.003 5.125a4 4 0 0 0-2.526 5.77'), // key: q97ue3
  ]);

  /// `brick-wall-fire.mjs`
  static const DsLucideGlyph brickWallFire =
      DsLucideGlyph('brick-wall-fire', <DsIconElement>[
    DsIconPathElement('M16 3v2.107'), // key: gq8xun
    DsIconPathElement('M17 9c1 3 2.5 3.5 3.5 4.5A5 5 0 0 1 22 17a5 5 0 0 1-10 0c0-.3 0-.6.1-.9a2 2 0 1 0 3.3-2C13 11.5 16 9 17 9'), // key: 1l2pih
    DsIconPathElement('M21 8.274V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h3.938'), // key: jrnqjp
    DsIconPathElement('M3 15h5.253'), // key: xqg7rb
    DsIconPathElement('M3 9h8.228'), // key: 1ppb70
    DsIconPathElement('M8 15v6'), // key: 1stoo3
    DsIconPathElement('M8 3v6'), // key: vlvjmk
  ]);

  /// `brick-wall-shield.mjs`
  static const DsLucideGlyph brickWallShield =
      DsLucideGlyph('brick-wall-shield', <DsIconElement>[
    DsIconPathElement('M12 9v1.258'), // key: iwpddn
    DsIconPathElement('M16 3v5.46'), // key: d7ew98
    DsIconPathElement('M21 9.118V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h5.75'), // key: 137t5x
    DsIconPathElement('M22 17.5c0 2.499-1.75 3.749-3.83 4.474a.5.5 0 0 1-.335-.005c-2.085-.72-3.835-1.97-3.835-4.47V14a.5.5 0 0 1 .5-.499c1 0 2.25-.6 3.12-1.36a.6.6 0 0 1 .76-.001c.875.765 2.12 1.36 3.12 1.36a.5.5 0 0 1 .5.5z'), // key: 16j3tf
    DsIconPathElement('M3 15h7'), // key: 1qldh6
    DsIconPathElement('M3 9h12.142'), // key: 1yjd6m
    DsIconPathElement('M8 15v6'), // key: 1stoo3
    DsIconPathElement('M8 3v6'), // key: vlvjmk
  ]);

  /// `brick-wall.mjs`
  static const DsLucideGlyph brickWall =
      DsLucideGlyph('brick-wall', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M12 9v6'), // key: 199k2o
    DsIconPathElement('M16 15v6'), // key: 8rj2es
    DsIconPathElement('M16 3v6'), // key: 1j6rpj
    DsIconPathElement('M3 15h18'), // key: 5xshup
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('M8 15v6'), // key: 1stoo3
    DsIconPathElement('M8 3v6'), // key: vlvjmk
  ]);

  /// `briefcase-business.mjs`
  static const DsLucideGlyph briefcaseBusiness =
      DsLucideGlyph('briefcase-business', <DsIconElement>[
    DsIconPathElement('M12 12h.01'), // key: 1mp3jc
    DsIconPathElement('M16 6V4a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2'), // key: 1ksdt3
    DsIconPathElement('M22 13a18.15 18.15 0 0 1-20 0'), // key: 12hx5q
    DsIconRectElement(2, 6, 20, 14, 2), // key: i6l2r4
  ]);

  /// `briefcase-conveyor-belt.mjs`
  static const DsLucideGlyph briefcaseConveyorBelt =
      DsLucideGlyph('briefcase-conveyor-belt', <DsIconElement>[
    DsIconPathElement('M10 20v2'), // key: 1n8e1g
    DsIconPathElement('M14 20v2'), // key: 1lq872
    DsIconPathElement('M18 20v2'), // key: 10uadw
    DsIconPathElement('M21 20H3'), // key: kdqkdp
    DsIconPathElement('M6 20v2'), // key: a9bc87
    DsIconPathElement('M8 16V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v12'), // key: 17n9tx
    DsIconRectElement(4, 6, 16, 10, 2), // key: 1097i5
  ]);

  /// `briefcase-medical.mjs`
  static const DsLucideGlyph briefcaseMedical =
      DsLucideGlyph('briefcase-medical', <DsIconElement>[
    DsIconPathElement('M12 11v4'), // key: a6ujw6
    DsIconPathElement('M14 13h-4'), // key: 1pl8zg
    DsIconPathElement('M16 6V4a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2'), // key: 1ksdt3
    DsIconPathElement('M18 6v14'), // key: 1mu4gy
    DsIconPathElement('M6 6v14'), // key: 1s15cj
    DsIconRectElement(2, 6, 20, 14, 2), // key: i6l2r4
  ]);

  /// `briefcase.mjs`
  static const DsLucideGlyph briefcase =
      DsLucideGlyph('briefcase', <DsIconElement>[
    DsIconPathElement('M16 20V4a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16'), // key: jecpp
    DsIconRectElement(2, 6, 20, 14, 2), // key: i6l2r4
  ]);

  /// `bring-to-front.mjs`
  static const DsLucideGlyph bringToFront =
      DsLucideGlyph('bring-to-front', <DsIconElement>[
    DsIconRectElement(8, 8, 8, 8, 2), // key: yj20xf
    DsIconPathElement('M4 10a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2'), // key: 1ltk23
    DsIconPathElement('M14 20a2 2 0 0 0 2 2h4a2 2 0 0 0 2-2v-4a2 2 0 0 0-2-2'), // key: 1q24h9
  ]);

  /// `broccoli.mjs`
  static const DsLucideGlyph broccoli =
      DsLucideGlyph('broccoli', <DsIconElement>[
    DsIconPathElement('M10 13a3 3 0 0 1-2.121-5.121'), // key: 1oqad0
    DsIconPathElement('M15.606 14.204c-3.5 1.5-5.899 4.503-8.899 7.503A1 1 0 0 1 6 22c-2 0-4-2-4-4a1 1 0 0 1 .293-.707c1.911-1.911 3.823-3.578 5.347-5.441'), // key: c93qjr
    DsIconPathElement('M16.573 14.737A4 4 0 0 1 14 11'), // key: 1ymr17
    DsIconPathElement('M7.14 10.907a4 4 0 1 1 2.756-7.43A4 4 0 0 1 16.7 4.48a2 2 0 0 1 2.82 2.82 4 4 0 0 1 1.002 6.805A4 4 0 1 1 13 16'), // key: 1kbgad
  ]);

  /// `brush-cleaning.mjs`
  static const DsLucideGlyph brushCleaning =
      DsLucideGlyph('brush-cleaning', <DsIconElement>[
    DsIconPathElement('m16 22-1-4'), // key: 1ow2iv
    DsIconPathElement('M19 14a1 1 0 0 0 1-1v-1a2 2 0 0 0-2-2h-3a1 1 0 0 1-1-1V4a2 2 0 0 0-4 0v5a1 1 0 0 1-1 1H6a2 2 0 0 0-2 2v1a1 1 0 0 0 1 1'), // key: 11gii7
    DsIconPathElement('M19 14H5l-1.973 6.767A1 1 0 0 0 4 22h16a1 1 0 0 0 .973-1.233z'), // key: bju7h4
    DsIconPathElement('m8 22 1-4'), // key: s3unb
  ]);

  /// `brush.mjs`
  static const DsLucideGlyph brush =
      DsLucideGlyph('brush', <DsIconElement>[
    DsIconPathElement('m11 10 3 3'), // key: fzmg1i
    DsIconPathElement('M6.5 21A3.5 3.5 0 1 0 3 17.5a2.62 2.62 0 0 1-.708 1.792A1 1 0 0 0 3 21z'), // key: p4q2r7
    DsIconPathElement('M9.969 17.031 21.378 5.624a1 1 0 0 0-3.002-3.002L6.967 14.031'), // key: wy6l02
  ]);

  /// `bubbles.mjs`
  static const DsLucideGlyph bubbles =
      DsLucideGlyph('bubbles', <DsIconElement>[
    DsIconPathElement('M7.001 15.085A1.5 1.5 0 0 1 9 16.5'), // key: y44lvh
    DsIconCircleElement(18.5, 8.5, 3.5), // key: 1wadoa
    DsIconCircleElement(7.5, 16.5, 5.5), // key: 6mdt3g
    DsIconCircleElement(7.5, 4.5, 2.5), // key: 637s54
  ]);

  /// `bug-off.mjs`
  static const DsLucideGlyph bugOff =
      DsLucideGlyph('bug-off', <DsIconElement>[
    DsIconPathElement('M12 20v-8'), // key: i3yub9
    DsIconPathElement('M12.656 7H14a4 4 0 0 1 4 4v1.344'), // key: vvueyn
    DsIconPathElement('M14.12 3.88 16 2'), // key: qol33r
    DsIconPathElement('M17.123 17.123A6 6 0 0 1 6 14v-3a4 4 0 0 1 1.72-3.287'), // key: 1cu21y
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M21 5a4 4 0 0 1-3.55 3.97'), // key: 5cxbf6
    DsIconPathElement('M22 13h-3.344'), // key: qb08am
    DsIconPathElement('M3 21a4 4 0 0 1 3.81-4'), // key: 1fjd4g
    DsIconPathElement('M3 5a4 4 0 0 0 3.55 3.97'), // key: 1d7oge
    DsIconPathElement('M6 13H2'), // key: 82j7cp
    DsIconPathElement('m8 2 1.88 1.88'), // key: fmnt4t
    DsIconPathElement('M9.712 4.06A3 3 0 0 1 15 6v1.13'), // key: 1bvup6
  ]);

  /// `bug-play.mjs`
  static const DsLucideGlyph bugPlay =
      DsLucideGlyph('bug-play', <DsIconElement>[
    DsIconPathElement('M10 19.655A6 6 0 0 1 6 14v-3a4 4 0 0 1 4-4h4a4 4 0 0 1 4 3.97'), // key: 1gnv52
    DsIconPathElement('M14 15.003a1 1 0 0 1 1.517-.859l4.997 2.997a1 1 0 0 1 0 1.718l-4.997 2.997a1 1 0 0 1-1.517-.86z'), // key: 1weqy9
    DsIconPathElement('M14.12 3.88 16 2'), // key: qol33r
    DsIconPathElement('M21 5a4 4 0 0 1-3.55 3.97'), // key: 5cxbf6
    DsIconPathElement('M3 21a4 4 0 0 1 3.81-4'), // key: 1fjd4g
    DsIconPathElement('M3 5a4 4 0 0 0 3.55 3.97'), // key: 1d7oge
    DsIconPathElement('M6 13H2'), // key: 82j7cp
    DsIconPathElement('m8 2 1.88 1.88'), // key: fmnt4t
    DsIconPathElement('M9 7.13V6a3 3 0 1 1 6 0v1.13'), // key: 1vgav8
  ]);

  /// `bug.mjs`
  static const DsLucideGlyph bug =
      DsLucideGlyph('bug', <DsIconElement>[
    DsIconPathElement('M12 20v-9'), // key: 1qisl0
    DsIconPathElement('M14 7a4 4 0 0 1 4 4v3a6 6 0 0 1-12 0v-3a4 4 0 0 1 4-4z'), // key: uouzyp
    DsIconPathElement('M14.12 3.88 16 2'), // key: qol33r
    DsIconPathElement('M21 21a4 4 0 0 0-3.81-4'), // key: 1b0z45
    DsIconPathElement('M21 5a4 4 0 0 1-3.55 3.97'), // key: 5cxbf6
    DsIconPathElement('M22 13h-4'), // key: 1jl80f
    DsIconPathElement('M3 21a4 4 0 0 1 3.81-4'), // key: 1fjd4g
    DsIconPathElement('M3 5a4 4 0 0 0 3.55 3.97'), // key: 1d7oge
    DsIconPathElement('M6 13H2'), // key: 82j7cp
    DsIconPathElement('m8 2 1.88 1.88'), // key: fmnt4t
    DsIconPathElement('M9 7.13V6a3 3 0 1 1 6 0v1.13'), // key: 1vgav8
  ]);

  /// `building-2.mjs`
  static const DsLucideGlyph building2 =
      DsLucideGlyph('building-2', <DsIconElement>[
    DsIconPathElement('M10 12h4'), // key: a56b0p
    DsIconPathElement('M10 8h4'), // key: 1sr2af
    DsIconPathElement('M14 21v-3a2 2 0 0 0-4 0v3'), // key: 1rgiei
    DsIconPathElement('M6 10H4a2 2 0 0 0-2 2v7a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-2'), // key: secmi2
    DsIconPathElement('M6 21V5a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v16'), // key: 16ra0t
  ]);

  /// `building.mjs`
  static const DsLucideGlyph building =
      DsLucideGlyph('building', <DsIconElement>[
    DsIconPathElement('M12 10h.01'), // key: 1nrarc
    DsIconPathElement('M12 14h.01'), // key: 1etili
    DsIconPathElement('M12 6h.01'), // key: 1vi96p
    DsIconPathElement('M16 10h.01'), // key: 1m94wz
    DsIconPathElement('M16 14h.01'), // key: 1gbofw
    DsIconPathElement('M16 6h.01'), // key: 1x0f13
    DsIconPathElement('M8 10h.01'), // key: 19clt8
    DsIconPathElement('M8 14h.01'), // key: 6423bh
    DsIconPathElement('M8 6h.01'), // key: 1dz90k
    DsIconPathElement('M9 22v-3a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v3'), // key: cabbwy
    DsIconRectElement(4, 2, 16, 20, 2), // key: 1uxh74
  ]);

  /// `bus-front.mjs`
  static const DsLucideGlyph busFront =
      DsLucideGlyph('bus-front', <DsIconElement>[
    DsIconPathElement('M4 6 2 7'), // key: 1mqr15
    DsIconPathElement('M10 6h4'), // key: 1itunk
    DsIconPathElement('m22 7-2-1'), // key: 1umjhc
    DsIconRectElement(4, 3, 16, 16, 2), // key: 1wxw4b
    DsIconPathElement('M4 11h16'), // key: mpoxn0
    DsIconPathElement('M8 15h.01'), // key: a7atzg
    DsIconPathElement('M16 15h.01'), // key: rnfrdf
    DsIconPathElement('M6 19v2'), // key: 1loha6
    DsIconPathElement('M18 21v-2'), // key: sqyl04
  ]);

  /// `bus.mjs`
  static const DsLucideGlyph bus =
      DsLucideGlyph('bus', <DsIconElement>[
    DsIconPathElement('M8 6v6'), // key: 18i7km
    DsIconPathElement('M15 6v6'), // key: 1sg6z9
    DsIconPathElement('M2 12h19.6'), // key: de5uta
    DsIconPathElement('M18 18h3s.5-1.7.8-2.8c.1-.4.2-.8.2-1.2 0-.4-.1-.8-.2-1.2l-1.4-5C20.1 6.8 19.1 6 18 6H4a2 2 0 0 0-2 2v10h3'), // key: 1wwztk
    DsIconCircleElement(7, 18, 2), // key: 19iecd
    DsIconPathElement('M9 18h5'), // key: lrx6i
    DsIconCircleElement(16, 18, 2), // key: 1v4tcr
  ]);

  /// `cable-car.mjs`
  static const DsLucideGlyph cableCar =
      DsLucideGlyph('cable-car', <DsIconElement>[
    DsIconPathElement('M10 3h.01'), // key: lbucoy
    DsIconPathElement('M14 2h.01'), // key: 1k8aa1
    DsIconPathElement('m2 9 20-5'), // key: 1kz0j5
    DsIconPathElement('M12 12V6.5'), // key: 1vbrij
    DsIconRectElement(4, 12, 16, 10, 3), // key: if91er
    DsIconPathElement('M9 12v5'), // key: 3anwtq
    DsIconPathElement('M15 12v5'), // key: 5xh3zn
    DsIconPathElement('M4 17h16'), // key: g4d7ey
  ]);

  /// `cable.mjs`
  static const DsLucideGlyph cable =
      DsLucideGlyph('cable', <DsIconElement>[
    DsIconPathElement('M17 19a1 1 0 0 1-1-1v-2a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2a1 1 0 0 1-1 1z'), // key: trhst0
    DsIconPathElement('M17 21v-2'), // key: ds4u3f
    DsIconPathElement('M19 14V6.5a1 1 0 0 0-7 0v11a1 1 0 0 1-7 0V10'), // key: 1mo9zo
    DsIconPathElement('M21 21v-2'), // key: eo0ou
    DsIconPathElement('M3 5V3'), // key: 1k5hjh
    DsIconPathElement('M4 10a2 2 0 0 1-2-2V6a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2a2 2 0 0 1-2 2z'), // key: 1dd30t
    DsIconPathElement('M7 5V3'), // key: 1t1388
  ]);

  /// `cake-slice.mjs`
  static const DsLucideGlyph cakeSlice =
      DsLucideGlyph('cake-slice', <DsIconElement>[
    DsIconPathElement('M16 13H3'), // key: 1wpj08
    DsIconPathElement('M16 17H3'), // key: 3lvfcd
    DsIconPathElement('m7.2 7.9-3.388 2.5A2 2 0 0 0 3 12.01V20a1 1 0 0 0 1 1h16a1 1 0 0 0 1-1v-8.654c0-2-2.44-6.026-6.44-8.026a1 1 0 0 0-1.082.057L10.4 5.6'), // key: 1gmhf7
    DsIconCircleElement(9, 7, 2), // key: 1305pl
  ]);

  /// `cake.mjs`
  static const DsLucideGlyph cake =
      DsLucideGlyph('cake', <DsIconElement>[
    DsIconPathElement('M20 21v-8a2 2 0 0 0-2-2H6a2 2 0 0 0-2 2v8'), // key: 1w3rig
    DsIconPathElement('M4 16s.5-1 2-1 2.5 2 4 2 2.5-2 4-2 2.5 2 4 2 2-1 2-1'), // key: n2jgmb
    DsIconPathElement('M2 21h20'), // key: 1nyx9w
    DsIconPathElement('M7 8v3'), // key: 1qtyvj
    DsIconPathElement('M12 8v3'), // key: hwp4zt
    DsIconPathElement('M17 8v3'), // key: 1i6e5u
    DsIconPathElement('M7 4h.01'), // key: 1bh4kh
    DsIconPathElement('M12 4h.01'), // key: 1ujb9j
    DsIconPathElement('M17 4h.01'), // key: 1upcoc
  ]);

  /// `calculator.mjs`
  static const DsLucideGlyph calculator =
      DsLucideGlyph('calculator', <DsIconElement>[
    DsIconRectElement(4, 2, 16, 20, 2), // key: 1nb95v
    DsIconLineElement(8, 6, 16, 6), // key: x4nwl0
    DsIconLineElement(16, 14, 16, 18), // key: wjye3r
    DsIconPathElement('M16 10h.01'), // key: 1m94wz
    DsIconPathElement('M12 10h.01'), // key: 1nrarc
    DsIconPathElement('M8 10h.01'), // key: 19clt8
    DsIconPathElement('M12 14h.01'), // key: 1etili
    DsIconPathElement('M8 14h.01'), // key: 6423bh
    DsIconPathElement('M12 18h.01'), // key: mhygvu
    DsIconPathElement('M8 18h.01'), // key: lrp35t
  ]);

  /// `calendar-1.mjs`
  static const DsLucideGlyph calendar1 =
      DsLucideGlyph('calendar-1', <DsIconElement>[
    DsIconPathElement('M11 13h1v4'), // key: 10p4bv
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('M8 2v3'), // key: 1ioesn
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `calendar-arrow-down.mjs`
  static const DsLucideGlyph calendarArrowDown =
      DsLucideGlyph('calendar-arrow-down', <DsIconElement>[
    DsIconPathElement('m14 17 4 4 4-4'), // key: 17qdjf
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconPathElement('M18 13v8'), // key: 1a00n0
    DsIconPathElement('M21 10.354V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h7.343'), // key: 1qsorh
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('M8 2v3'), // key: 1ioesn
  ]);

  /// `calendar-arrow-up.mjs`
  static const DsLucideGlyph calendarArrowUp =
      DsLucideGlyph('calendar-arrow-up', <DsIconElement>[
    DsIconPathElement('m14 17 4-4 4 4'), // key: 1qa3u6
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconPathElement('M18 21v-8'), // key: 1ao88k
    DsIconPathElement('M21 10.343V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h9'), // key: 185mot
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('M8 2v3'), // key: 1ioesn
  ]);

  /// `calendar-check-2.mjs`
  static const DsLucideGlyph calendarCheck2 =
      DsLucideGlyph('calendar-check-2', <DsIconElement>[
    DsIconPathElement('M 19 3 L 5 3'), // key: 1xn3iy
    DsIconPathElement('M 21 13 L 21 5'), // key: 102s58
    DsIconPathElement('M 21 5 A2 2 0 0 0 19 3'), // key: 1xylja
    DsIconPathElement('M 3 19 A2 2 0 0 0 5 21'), // key: 19jxbv
    DsIconPathElement('M 3 5 L 3 19'), // key: 1yylhw
    DsIconPathElement('M 5 3 A2 2 0 0 0 3 5'), // key: 164twa
    DsIconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('M5 21 L12.5 21'), // key: 1n38e0
    DsIconPathElement('M8 2v3'), // key: 1ioesn
  ]);

  /// `calendar-check.mjs`
  static const DsLucideGlyph calendarCheck =
      DsLucideGlyph('calendar-check', <DsIconElement>[
    DsIconPathElement('M8 2v3'), // key: 1ioesn
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('m9 15 2 2 4-4'), // key: 1grp1n
  ]);

  /// `calendar-clock.mjs`
  static const DsLucideGlyph calendarClock =
      DsLucideGlyph('calendar-clock', <DsIconElement>[
    DsIconPathElement('M16 14v2.2l1.6 1'), // key: fo4ql5
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconPathElement('M21 7.338V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h2.338'), // key: 7hb8p4
    DsIconPathElement('M3 9h5.859'), // key: numkqi
    DsIconPathElement('M8 2v3'), // key: 1ioesn
    DsIconCircleElement(16, 16, 6), // key: qoo3c4
  ]);

  /// `calendar-cog.mjs`
  static const DsLucideGlyph calendarCog =
      DsLucideGlyph('calendar-cog', <DsIconElement>[
    DsIconPathElement('m15.228 16.852-.923-.383'), // key: npixar
    DsIconPathElement('m15.228 19.148-.923.383'), // key: 51cr3n
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconPathElement('m16.47 14.305.382.923'), // key: obybxd
    DsIconPathElement('m16.852 20.772-.383.924'), // key: dpfhf9
    DsIconPathElement('m19.148 15.228.383-.923'), // key: 1reyyz
    DsIconPathElement('m19.53 21.696-.382-.924'), // key: 1goivc
    DsIconPathElement('m20.773 16.852.924-.383'), // key: ybmb4k
    DsIconPathElement('m20.773 19.148.924.383'), // key: 1c2d3p
    DsIconPathElement('M21 10.5V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h5.5'), // key: 1e6z1y
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('M8 2v3'), // key: 1ioesn
    DsIconCircleElement(18, 18, 3), // key: 1xkwt0
  ]);

  /// `calendar-days.mjs`
  static const DsLucideGlyph calendarDays =
      DsLucideGlyph('calendar-days', <DsIconElement>[
    DsIconPathElement('M8 2v3'), // key: 1ioesn
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('M8 13h.01'), // key: 1sbv64
    DsIconPathElement('M12 13h.01'), // key: y0uutt
    DsIconPathElement('M16 13h.01'), // key: wip0gl
    DsIconPathElement('M8 17h.01'), // key: p3bg7i
    DsIconPathElement('M12 17h.01'), // key: p32p05
    DsIconPathElement('M16 17h.01'), // key: ql8jdd
  ]);

  /// `calendar-fold.mjs`
  static const DsLucideGlyph calendarFold =
      DsLucideGlyph('calendar-fold', <DsIconElement>[
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconPathElement('M21 15V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h10v-5a1 1 0 011-1za2.4 2.4 0 01-.706 1.706l-3.588 3.588A2.4 2.4 0 0115 21'), // key: 4uit17
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('M8 2v3'), // key: 1ioesn
  ]);

  /// `calendar-heart.mjs`
  static const DsLucideGlyph calendarHeart =
      DsLucideGlyph('calendar-heart', <DsIconElement>[
    DsIconPathElement('M12.127 21H5a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v5.125'), // key: 1fsxpc
    DsIconPathElement('M14.62 17.8A2.25 2.25 0 1118 14.836a2.25 2.25 0 113.38 2.966l-2.626 2.856a.998.998 0 01-1.507 0z'), // key: 1gk3ue
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('M8 2v3'), // key: 1ioesn
  ]);

  /// `calendar-minus-2.mjs`
  static const DsLucideGlyph calendarMinus2 =
      DsLucideGlyph('calendar-minus-2', <DsIconElement>[
    DsIconPathElement('M8 2v3'), // key: 1ioesn
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('M10 15h4'), // key: 192ueg
  ]);

  /// `calendar-minus.mjs`
  static const DsLucideGlyph calendarMinus =
      DsLucideGlyph('calendar-minus', <DsIconElement>[
    DsIconPathElement('M16 18h6'), // key: 987eiv
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconPathElement('M21 14V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h8.3'), // key: gcu0od
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('M8 2v3'), // key: 1ioesn
  ]);

  /// `calendar-off.mjs`
  static const DsLucideGlyph calendarOff =
      DsLucideGlyph('calendar-off', <DsIconElement>[
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M21 9h-5.5'), // key: 1g344v
    DsIconPathElement('M3 9h6'), // key: 1q2djq
    DsIconPathElement('M3.586 3.586A2 2 0 003 5v14a2 2 0 002 2h14a2 2 0 001.414-.586'), // key: 1g7ltu
    DsIconPathElement('M8.656 3H19a2 2 0 012 2v10.344'), // key: 1bwpd1
  ]);

  /// `calendar-plus-2.mjs`
  static const DsLucideGlyph calendarPlus2 =
      DsLucideGlyph('calendar-plus-2', <DsIconElement>[
    DsIconPathElement('M8 2v3'), // key: 1ioesn
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('M10 15h4'), // key: 192ueg
    DsIconPathElement('M12 13v4'), // key: 1il4po
  ]);

  /// `calendar-plus.mjs`
  static const DsLucideGlyph calendarPlus =
      DsLucideGlyph('calendar-plus', <DsIconElement>[
    DsIconPathElement('M16 18h6'), // key: 987eiv
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconPathElement('M19 15v6'), // key: 10aioa
    DsIconPathElement('M21 11.5V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h8.3'), // key: jgwkxf
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('M8 2v3'), // key: 1ioesn
  ]);

  /// `calendar-range.mjs`
  static const DsLucideGlyph calendarRange =
      DsLucideGlyph('calendar-range', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('M8 2v3'), // key: 1ioesn
    DsIconPathElement('M17 13h-6'), // key: 1qbiup
    DsIconPathElement('M13 17H7'), // key: 1x38vv
    DsIconPathElement('M7 13h.01'), // key: 1vezk1
    DsIconPathElement('M17 17h.01'), // key: 1sd3ek
  ]);

  /// `calendar-search.mjs`
  static const DsLucideGlyph calendarSearch =
      DsLucideGlyph('calendar-search', <DsIconElement>[
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconPathElement('M21 10.69V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h7.25'), // key: h6gkkz
    DsIconPathElement('m22 21-1.875-1.875'), // key: 1dzjql
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('M8 2v3'), // key: 1ioesn
    DsIconCircleElement(18, 17, 3), // key: 1hty4x
  ]);

  /// `calendar-sync.mjs`
  static const DsLucideGlyph calendarSync =
      DsLucideGlyph('calendar-sync', <DsIconElement>[
    DsIconPathElement('M11 10v4h4'), // key: 172dkj
    DsIconPathElement('m11 14 1.535-1.605a5 5 0 018 1.5'), // key: jekqcd
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconPathElement('m21 18-1.535 1.605a5 5 0 01-8-1.5'), // key: n107hu
    DsIconPathElement('M21 22v-4h-4'), // key: hrummi
    DsIconPathElement('M21 8.517V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h3.517'), // key: yafrba
    DsIconPathElement('M3 9h4'), // key: rnfnj5
    DsIconPathElement('M8 2v3'), // key: 1ioesn
  ]);

  /// `calendar-x-2.mjs`
  static const DsLucideGlyph calendarX2 =
      DsLucideGlyph('calendar-x-2', <DsIconElement>[
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconPathElement('m17 16 5 5'), // key: 1a37d9
    DsIconPathElement('m17 21 5-5'), // key: 1b797a
    DsIconPathElement('M21 12V5a2 2 0 00-2-2H5a2 2 0 00-2 2v14a2 2 0 002 2h8'), // key: 14ws7l
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('M8 2v3'), // key: 1ioesn
  ]);

  /// `calendar-x.mjs`
  static const DsLucideGlyph calendarX =
      DsLucideGlyph('calendar-x', <DsIconElement>[
    DsIconPathElement('M8 2v3'), // key: 1ioesn
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('m14 13-4 4'), // key: 1gib57
    DsIconPathElement('m10 13 4 4'), // key: 153uiq
  ]);

  /// `calendar.mjs`
  static const DsLucideGlyph calendar =
      DsLucideGlyph('calendar', <DsIconElement>[
    DsIconPathElement('M8 2v3'), // key: 1ioesn
    DsIconPathElement('M16 2v3'), // key: otl347
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    DsIconPathElement('M3 9h18'), // key: 1pudct
  ]);

  /// `calendars.mjs`
  static const DsLucideGlyph calendars =
      DsLucideGlyph('calendars', <DsIconElement>[
    DsIconPathElement('M12 2v2'), // key: tus03m
    DsIconPathElement('M15.726 21.01A2 2 0 0 1 14 22H4a2 2 0 0 1-2-2V10a2 2 0 0 1 2-2'), // key: j6srht
    DsIconPathElement('M18 2v2'), // key: 1kh14s
    DsIconPathElement('M2 13h2'), // key: 13gyu8
    DsIconPathElement('M8 8h14'), // key: 12jxz2
    DsIconRectElement(8, 3, 14, 14, 2), // key: nsru6w
  ]);

  /// `camera-off.mjs`
  static const DsLucideGlyph cameraOff =
      DsLucideGlyph('camera-off', <DsIconElement>[
    DsIconPathElement('M14.564 14.558a3 3 0 1 1-4.122-4.121'), // key: 1rnrzw
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M20 20H4a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2h1.997a2 2 0 0 0 .819-.175'), // key: 1x3arw
    DsIconPathElement('M9.695 4.024A2 2 0 0 1 10.004 4h3.993a2 2 0 0 1 1.76 1.05l.486.9A2 2 0 0 0 18.003 7H20a2 2 0 0 1 2 2v7.344'), // key: 1i84u0
  ]);

  /// `camera.mjs`
  static const DsLucideGlyph camera =
      DsLucideGlyph('camera', <DsIconElement>[
    DsIconPathElement('M13.997 4a2 2 0 0 1 1.76 1.05l.486.9A2 2 0 0 0 18.003 7H20a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V9a2 2 0 0 1 2-2h1.997a2 2 0 0 0 1.759-1.048l.489-.904A2 2 0 0 1 10.004 4z'), // key: 18u6gg
    DsIconCircleElement(12, 13, 3), // key: 1vg3eu
  ]);

  /// `candy-cane.mjs`
  static const DsLucideGlyph candyCane =
      DsLucideGlyph('candy-cane', <DsIconElement>[
    DsIconPathElement('m10.8 5 2.111 4.223'), // key: 11kb8w
    DsIconPathElement('M17.75 7 15 2.1'), // key: 12x7e8
    DsIconPathElement('m4.874 14.647 2.12 4.24'), // key: ccpt4b
    DsIconPathElement('M5.7 21a2 2 0 0 1-3.5-2l8.6-14a6 6 0 0 1 10.4 6 2 2 0 1 1-3.464-2 2 2 0 1 0-3.464-2z'), // key: u5e8z4
    DsIconPathElement('m7.906 9.712 2.005 4.411'), // key: 1k0qph
  ]);

  /// `candy-off.mjs`
  static const DsLucideGlyph candyOff =
      DsLucideGlyph('candy-off', <DsIconElement>[
    DsIconPathElement('M10 10v7.9'), // key: m8g9tt
    DsIconPathElement('M11.802 6.145a5 5 0 0 1 6.053 6.053'), // key: dn87i3
    DsIconPathElement('M14 6.1v2.243'), // key: 1kzysn
    DsIconPathElement('m15.5 15.571-.964.964a5 5 0 0 1-7.071 0 5 5 0 0 1 0-7.07l.964-.965'), // key: 3sxy18
    DsIconPathElement('M16 7V3a1 1 0 0 1 1.707-.707 2.5 2.5 0 0 0 2.152.717 1 1 0 0 1 1.131 1.131 2.5 2.5 0 0 0 .717 2.152A1 1 0 0 1 21 8h-4'), // key: gpb6xx
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M8 17v4a1 1 0 0 1-1.707.707 2.5 2.5 0 0 0-2.152-.717 1 1 0 0 1-1.131-1.131 2.5 2.5 0 0 0-.717-2.152A1 1 0 0 1 3 16h4'), // key: qexcha
  ]);

  /// `candy.mjs`
  static const DsLucideGlyph candy =
      DsLucideGlyph('candy', <DsIconElement>[
    DsIconPathElement('M10 7v10.9'), // key: 1gynux
    DsIconPathElement('M14 6.1V17'), // key: 116kdf
    DsIconPathElement('M16 7V3a1 1 0 0 1 1.707-.707 2.5 2.5 0 0 0 2.152.717 1 1 0 0 1 1.131 1.131 2.5 2.5 0 0 0 .717 2.152A1 1 0 0 1 21 8h-4'), // key: gpb6xx
    DsIconPathElement('M16.536 7.465a5 5 0 0 0-7.072 0l-2 2a5 5 0 0 0 0 7.07 5 5 0 0 0 7.072 0l2-2a5 5 0 0 0 0-7.07'), // key: 1tsln4
    DsIconPathElement('M8 17v4a1 1 0 0 1-1.707.707 2.5 2.5 0 0 0-2.152-.717 1 1 0 0 1-1.131-1.131 2.5 2.5 0 0 0-.717-2.152A1 1 0 0 1 3 16h4'), // key: qexcha
  ]);

  /// `cannabis-off.mjs`
  static const DsLucideGlyph cannabisOff =
      DsLucideGlyph('cannabis-off', <DsIconElement>[
    DsIconPathElement('M12 22v-4c1.5 1.5 3.5 3 6 3 0-1.5-.5-3.5-2-5'), // key: 1bqfb7
    DsIconPathElement('M13.988 8.327C13.902 6.054 13.365 3.82 12 2a9.3 9.3 0 0 0-1.445 2.9'), // key: 1p520n
    DsIconPathElement('M17.375 11.725C18.882 10.53 21 7.841 21 6c-2.324 0-5.08 1.296-6.662 2.684'), // key: q2itvb
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M21.024 15.378A15 15 0 0 0 22 15c-.426-1.279-2.67-2.557-4.25-2.907'), // key: j9amvs
    DsIconPathElement('M6.995 6.992C5.714 6.4 4.29 6 3 6c0 2 2.5 5 4 6-1.5 0-4.5 1.5-5 3 3.5 1.5 6 1 6 1-1.5 1.5-2 3.5-2 5 2.5 0 4.5-1.5 6-3'), // key: 8gmd5g
  ]);

  /// `cannabis.mjs`
  static const DsLucideGlyph cannabis =
      DsLucideGlyph('cannabis', <DsIconElement>[
    DsIconPathElement('M12 22v-4'), // key: 1utk9m
    DsIconPathElement('M7 12c-1.5 0-4.5 1.5-5 3 3.5 1.5 6 1 6 1-1.5 1.5-2 3.5-2 5 2.5 0 4.5-1.5 6-3 1.5 1.5 3.5 3 6 3 0-1.5-.5-3.5-2-5 0 0 2.5.5 6-1-.5-1.5-3.5-3-5-3 1.5-1 4-4 4-6-2.5 0-5.5 1.5-7 3 0-2.5-.5-5-2-7-1.5 2-2 4.5-2 7-1.5-1.5-4.5-3-7-3 0 2 2.5 5 4 6'), // key: 1mezod
  ]);

  /// `captions-off.mjs`
  static const DsLucideGlyph captionsOff =
      DsLucideGlyph('captions-off', <DsIconElement>[
    DsIconPathElement('M10.5 5H19a2 2 0 0 1 2 2v8.5'), // key: jqtk4d
    DsIconPathElement('M17 11h-.5'), // key: 1961ue
    DsIconPathElement('M19 19H5a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2'), // key: 1keqsi
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M7 11h4'), // key: 1o1z6v
    DsIconPathElement('M7 15h2.5'), // key: 1ina1g
  ]);

  /// `captions.mjs`
  static const DsLucideGlyph captions =
      DsLucideGlyph('captions', <DsIconElement>[
    DsIconRectElement(3, 5, 18, 14, 2, ry: 2), // key: 12ruh7
    DsIconPathElement('M7 15h4M15 15h2M7 11h2M13 11h4'), // key: 1ueiar
  ]);

  /// `car-front.mjs`
  static const DsLucideGlyph carFront =
      DsLucideGlyph('car-front', <DsIconElement>[
    DsIconPathElement('m21 8-2 2-1.5-3.7A2 2 0 0 0 15.646 5H8.4a2 2 0 0 0-1.903 1.257L5 10 3 8'), // key: 1imjwt
    DsIconPathElement('M7 14h.01'), // key: 1qa3f1
    DsIconPathElement('M17 14h.01'), // key: 7oqj8z
    DsIconRectElement(3, 10, 18, 8, 2), // key: a7itu8
    DsIconPathElement('M5 18v2'), // key: ppbyun
    DsIconPathElement('M19 18v2'), // key: gy7782
  ]);

  /// `car-taxi-front.mjs`
  static const DsLucideGlyph carTaxiFront =
      DsLucideGlyph('car-taxi-front', <DsIconElement>[
    DsIconPathElement('M10 2h4'), // key: n1abiw
    DsIconPathElement('m21 8-2 2-1.5-3.7A2 2 0 0 0 15.646 5H8.4a2 2 0 0 0-1.903 1.257L5 10 3 8'), // key: 1imjwt
    DsIconPathElement('M7 14h.01'), // key: 1qa3f1
    DsIconPathElement('M17 14h.01'), // key: 7oqj8z
    DsIconRectElement(3, 10, 18, 8, 2), // key: a7itu8
    DsIconPathElement('M5 18v2'), // key: ppbyun
    DsIconPathElement('M19 18v2'), // key: gy7782
  ]);

  /// `car.mjs`
  static const DsLucideGlyph car =
      DsLucideGlyph('car', <DsIconElement>[
    DsIconPathElement('M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.4 2.9A3.7 3.7 0 0 0 2 12v4c0 .6.4 1 1 1h2'), // key: 5owen
    DsIconCircleElement(7, 17, 2), // key: u2ysq9
    DsIconPathElement('M9 17h6'), // key: r8uit2
    DsIconCircleElement(17, 17, 2), // key: axvx0g
  ]);

  /// `caravan.mjs`
  static const DsLucideGlyph caravan =
      DsLucideGlyph('caravan', <DsIconElement>[
    DsIconPathElement('M18 19V9a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v8a2 2 0 0 0 2 2h2'), // key: 19jm3t
    DsIconPathElement('M2 9h3a1 1 0 0 1 1 1v2a1 1 0 0 1-1 1H2'), // key: 13hakp
    DsIconPathElement('M22 17v1a1 1 0 0 1-1 1H10v-9a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v9'), // key: 1crci8
    DsIconCircleElement(8, 19, 2), // key: t8fc5s
  ]);

  /// `card-sim.mjs`
  static const DsLucideGlyph cardSim =
      DsLucideGlyph('card-sim', <DsIconElement>[
    DsIconPathElement('M12 14v4'), // key: 1thi36
    DsIconPathElement('M14.172 2a2 2 0 0 1 1.414.586l3.828 3.828A2 2 0 0 1 20 7.828V20a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2z'), // key: 1o66bk
    DsIconPathElement('M8 14h8'), // key: 1fgep2
    DsIconRectElement(8, 10, 8, 8, 1), // key: 1aonk6
  ]);

  /// `carrot.mjs`
  static const DsLucideGlyph carrot =
      DsLucideGlyph('carrot', <DsIconElement>[
    DsIconPathElement('M15 16a1 1 0 0 0-7-7q-4 4-5.987 12.385a.5.5 0 0 0 .602.602Q11 20 15 16l-3-3'), // key: 1ta62j
    DsIconPathElement('M15 9q4 4 7 0-3-4-7 0 4-4 0-7-4 3 0 7'), // key: 1svf7i
    DsIconPathElement('m8 15-2.58-2.58'), // key: 7t238r
  ]);

  /// `case-lower.mjs`
  static const DsLucideGlyph caseLower =
      DsLucideGlyph('case-lower', <DsIconElement>[
    DsIconPathElement('M10 9v7'), // key: ylp826
    DsIconPathElement('M14 6v10'), // key: 1jy4vg
    DsIconCircleElement(17.5, 12.5, 3.5), // key: 1a9481
    DsIconCircleElement(6.5, 12.5, 3.5), // key: 2jlv1r
  ]);

  /// `case-sensitive.mjs`
  static const DsLucideGlyph caseSensitive =
      DsLucideGlyph('case-sensitive', <DsIconElement>[
    DsIconPathElement('m2 16 4.039-9.69a.5.5 0 0 1 .923 0L11 16'), // key: d5nyq2
    DsIconPathElement('M22 9v7'), // key: pvm9v3
    DsIconPathElement('M3.304 13h6.392'), // key: 1q3zxz
    DsIconCircleElement(18.5, 12.5, 3.5), // key: z97x68
  ]);

  /// `case-upper.mjs`
  static const DsLucideGlyph caseUpper =
      DsLucideGlyph('case-upper', <DsIconElement>[
    DsIconPathElement('M15 11h4.5a1 1 0 0 1 0 5h-4a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h3a1 1 0 0 1 0 5'), // key: nxs35
    DsIconPathElement('m2 16 4.039-9.69a.5.5 0 0 1 .923 0L11 16'), // key: d5nyq2
    DsIconPathElement('M3.304 13h6.392'), // key: 1q3zxz
  ]);

  /// `cassette-tape.mjs`
  static const DsLucideGlyph cassetteTape =
      DsLucideGlyph('cassette-tape', <DsIconElement>[
    DsIconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
    DsIconCircleElement(8, 10, 2), // key: 1xl4ub
    DsIconPathElement('M8 12h8'), // key: 1wcyev
    DsIconCircleElement(16, 10, 2), // key: r14t7q
    DsIconPathElement('m6 20 .7-2.9A1.4 1.4 0 0 1 8.1 16h7.8a1.4 1.4 0 0 1 1.4 1l.7 3'), // key: l01ucn
  ]);

  /// `cast.mjs`
  static const DsLucideGlyph cast =
      DsLucideGlyph('cast', <DsIconElement>[
    DsIconPathElement('M2 8V6a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2h-6'), // key: 3zrzxg
    DsIconPathElement('M2 12a9 9 0 0 1 8 8'), // key: g6cvee
    DsIconPathElement('M2 16a5 5 0 0 1 4 4'), // key: 1y1dii
    DsIconLineElement(2, 20, 2.01, 20), // key: xu2jvo
  ]);

  /// `castle.mjs`
  static const DsLucideGlyph castle =
      DsLucideGlyph('castle', <DsIconElement>[
    DsIconPathElement('M10 5V3'), // key: 1y54qe
    DsIconPathElement('M14 5V3'), // key: m6isi
    DsIconPathElement('M15 21v-3a3 3 0 0 0-6 0v3'), // key: lbp5hj
    DsIconPathElement('M18 3v8'), // key: 2ollhf
    DsIconPathElement('M18 5H6'), // key: 98imr9
    DsIconPathElement('M22 11H2'), // key: 1lmjae
    DsIconPathElement('M22 9v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V9'), // key: 1rly83
    DsIconPathElement('M6 3v8'), // key: csox7g
  ]);

  /// `cat.mjs`
  static const DsLucideGlyph cat =
      DsLucideGlyph('cat', <DsIconElement>[
    DsIconPathElement('M12 5c.67 0 1.35.09 2 .26 1.78-2 5.03-2.84 6.42-2.26 1.4.58-.42 7-.42 7 .57 1.07 1 2.24 1 3.44C21 17.9 16.97 21 12 21s-9-3-9-7.56c0-1.25.5-2.4 1-3.44 0 0-1.89-6.42-.5-7 1.39-.58 4.72.23 6.5 2.23A9.04 9.04 0 0 1 12 5Z'), // key: x6xyqk
    DsIconPathElement('M8 14v.5'), // key: 1nzgdb
    DsIconPathElement('M16 14v.5'), // key: 1lajdz
    DsIconPathElement('M11.25 16.25h1.5L12 17l-.75-.75Z'), // key: 12kq1m
  ]);

  /// `cctv-off.mjs`
  static const DsLucideGlyph cctvOff =
      DsLucideGlyph('cctv-off', <DsIconElement>[
    DsIconPathElement('m12.309 6.652 4.797 2.401a1 1 0 0 1 .447 1.341l-.501 1.001.605.605h2.725a1 1 0 0 1 .894 1.447l-.724 1.448'), // key: e75roo
    DsIconPathElement('m15.166 15.166-.719 1.439a1 1 0 0 1-1.342.447L3.61 12.3a2.92 2.92 0 0 1-1.3-3.91L3.69 5.6a2.9 2.9 0 0 1 .873-1.037'), // key: 1h9o5r
    DsIconPathElement('M2 19h3.76a2 2 0 0 0 1.8-1.1l1.441-2.902'), // key: 1askrb
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M2 21v-4'), // key: l40lih
    DsIconPathElement('M7 9h.01'), // key: 19b3jx
  ]);

  /// `cctv.mjs`
  static const DsLucideGlyph cctv =
      DsLucideGlyph('cctv', <DsIconElement>[
    DsIconPathElement('M16.75 12h3.632a1 1 0 0 1 .894 1.447l-2.034 4.069a1 1 0 0 1-1.708.134l-2.124-2.97'), // key: ir91b5
    DsIconPathElement('M17.106 9.053a1 1 0 0 1 .447 1.341l-3.106 6.211a1 1 0 0 1-1.342.447L3.61 12.3a2.92 2.92 0 0 1-1.3-3.91L3.69 5.6a2.92 2.92 0 0 1 3.92-1.3z'), // key: jlp8i1
    DsIconPathElement('M2 19h3.76a2 2 0 0 0 1.8-1.1L9 15'), // key: 19bib8
    DsIconPathElement('M2 21v-4'), // key: l40lih
    DsIconPathElement('M7 9h.01'), // key: 19b3jx
  ]);

  /// `chart-area.mjs`
  static const DsLucideGlyph chartArea =
      DsLucideGlyph('chart-area', <DsIconElement>[
    DsIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    DsIconPathElement('M7 11.207a.5.5 0 0 1 .146-.353l2-2a.5.5 0 0 1 .708 0l3.292 3.292a.5.5 0 0 0 .708 0l4.292-4.292a.5.5 0 0 1 .854.353V16a1 1 0 0 1-1 1H8a1 1 0 0 1-1-1z'), // key: q0gr47
  ]);

  /// `chart-bar-big.mjs`
  static const DsLucideGlyph chartBarBig =
      DsLucideGlyph('chart-bar-big', <DsIconElement>[
    DsIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    DsIconRectElement(7, 13, 9, 4, 1), // key: 1iip1u
    DsIconRectElement(7, 5, 12, 4, 1), // key: 1anskk
  ]);

  /// `chart-bar-decreasing.mjs`
  static const DsLucideGlyph chartBarDecreasing =
      DsLucideGlyph('chart-bar-decreasing', <DsIconElement>[
    DsIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    DsIconPathElement('M7 11h8'), // key: 1feolt
    DsIconPathElement('M7 16h3'), // key: ur6vzw
    DsIconPathElement('M7 6h12'), // key: sz5b0d
  ]);

  /// `chart-bar-increasing.mjs`
  static const DsLucideGlyph chartBarIncreasing =
      DsLucideGlyph('chart-bar-increasing', <DsIconElement>[
    DsIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    DsIconPathElement('M7 11h8'), // key: 1feolt
    DsIconPathElement('M7 16h12'), // key: wsnu98
    DsIconPathElement('M7 6h3'), // key: w9rmul
  ]);

  /// `chart-bar-stacked.mjs`
  static const DsLucideGlyph chartBarStacked =
      DsLucideGlyph('chart-bar-stacked', <DsIconElement>[
    DsIconPathElement('M11 13v4'), // key: vyy2rb
    DsIconPathElement('M15 5v4'), // key: 1gx88a
    DsIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    DsIconRectElement(7, 13, 9, 4, 1), // key: 1iip1u
    DsIconRectElement(7, 5, 12, 4, 1), // key: 1anskk
  ]);

  /// `chart-bar.mjs`
  static const DsLucideGlyph chartBar =
      DsLucideGlyph('chart-bar', <DsIconElement>[
    DsIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    DsIconPathElement('M7 16h8'), // key: srdodz
    DsIconPathElement('M7 11h12'), // key: 127s9w
    DsIconPathElement('M7 6h3'), // key: w9rmul
  ]);

  /// `chart-candlestick.mjs`
  static const DsLucideGlyph chartCandlestick =
      DsLucideGlyph('chart-candlestick', <DsIconElement>[
    DsIconPathElement('M9 5v4'), // key: 14uxtq
    DsIconRectElement(7, 9, 4, 6, 1), // key: f4fvz0
    DsIconPathElement('M9 15v2'), // key: r5rk32
    DsIconPathElement('M17 3v2'), // key: 1l2re6
    DsIconRectElement(15, 5, 4, 8, 1), // key: z38je5
    DsIconPathElement('M17 13v3'), // key: 5l0wba
    DsIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
  ]);

  /// `chart-column-big.mjs`
  static const DsLucideGlyph chartColumnBig =
      DsLucideGlyph('chart-column-big', <DsIconElement>[
    DsIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    DsIconRectElement(15, 5, 4, 12, 1), // key: q8uenq
    DsIconRectElement(7, 8, 4, 9, 1), // key: sr5ea
  ]);

  /// `chart-column-decreasing.mjs`
  static const DsLucideGlyph chartColumnDecreasing =
      DsLucideGlyph('chart-column-decreasing', <DsIconElement>[
    DsIconPathElement('M13 17V9'), // key: 1fwyjl
    DsIconPathElement('M18 17v-3'), // key: 1sqioe
    DsIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    DsIconPathElement('M8 17V5'), // key: 1wzmnc
  ]);

  /// `chart-column-increasing.mjs`
  static const DsLucideGlyph chartColumnIncreasing =
      DsLucideGlyph('chart-column-increasing', <DsIconElement>[
    DsIconPathElement('M13 17V9'), // key: 1fwyjl
    DsIconPathElement('M18 17V5'), // key: sfb6ij
    DsIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    DsIconPathElement('M8 17v-3'), // key: 17ska0
  ]);

  /// `chart-column-stacked.mjs`
  static const DsLucideGlyph chartColumnStacked =
      DsLucideGlyph('chart-column-stacked', <DsIconElement>[
    DsIconPathElement('M11 13H7'), // key: t0o9gq
    DsIconPathElement('M19 9h-4'), // key: rera1j
    DsIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    DsIconRectElement(15, 5, 4, 12, 1), // key: q8uenq
    DsIconRectElement(7, 8, 4, 9, 1), // key: sr5ea
  ]);

  /// `chart-column.mjs`
  static const DsLucideGlyph chartColumn =
      DsLucideGlyph('chart-column', <DsIconElement>[
    DsIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    DsIconPathElement('M18 17V9'), // key: 2bz60n
    DsIconPathElement('M13 17V5'), // key: 1frdt8
    DsIconPathElement('M8 17v-3'), // key: 17ska0
  ]);

  /// `chart-gantt.mjs`
  static const DsLucideGlyph chartGantt =
      DsLucideGlyph('chart-gantt', <DsIconElement>[
    DsIconPathElement('M10 6h8'), // key: zvc2xc
    DsIconPathElement('M12 16h6'), // key: yi5mkt
    DsIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    DsIconPathElement('M8 11h7'), // key: wz2hg0
  ]);

  /// `chart-line.mjs`
  static const DsLucideGlyph chartLine =
      DsLucideGlyph('chart-line', <DsIconElement>[
    DsIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    DsIconPathElement('m19 9-5 5-4-4-3 3'), // key: 2osh9i
  ]);

  /// `chart-network.mjs`
  static const DsLucideGlyph chartNetwork =
      DsLucideGlyph('chart-network', <DsIconElement>[
    DsIconPathElement('m13.11 7.664 1.78 2.672'), // key: go2gg9
    DsIconPathElement('m14.162 12.788-3.324 1.424'), // key: 11x848
    DsIconPathElement('m20 4-6.06 1.515'), // key: 1wxxh7
    DsIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    DsIconCircleElement(12, 6, 2), // key: 1jj5th
    DsIconCircleElement(16, 12, 2), // key: 4ma0v8
    DsIconCircleElement(9, 15, 2), // key: lf2ghp
  ]);

  /// `chart-no-axes-column-decreasing.mjs`
  static const DsLucideGlyph chartNoAxesColumnDecreasing =
      DsLucideGlyph('chart-no-axes-column-decreasing', <DsIconElement>[
    DsIconPathElement('M5 21V3'), // key: clc1r8
    DsIconPathElement('M12 21V9'), // key: uvy0l4
    DsIconPathElement('M19 21v-6'), // key: tkawy9
  ]);

  /// `chart-no-axes-column-increasing.mjs`
  static const DsLucideGlyph chartNoAxesColumnIncreasing =
      DsLucideGlyph('chart-no-axes-column-increasing', <DsIconElement>[
    DsIconPathElement('M5 21v-6'), // key: 1hz6c0
    DsIconPathElement('M12 21V9'), // key: uvy0l4
    DsIconPathElement('M19 21V3'), // key: 11j9sm
  ]);

  /// `chart-no-axes-column.mjs`
  static const DsLucideGlyph chartNoAxesColumn =
      DsLucideGlyph('chart-no-axes-column', <DsIconElement>[
    DsIconPathElement('M5 21v-6'), // key: 1hz6c0
    DsIconPathElement('M12 21V3'), // key: 1lcnhd
    DsIconPathElement('M19 21V9'), // key: unv183
  ]);

  /// `chart-no-axes-combined.mjs`
  static const DsLucideGlyph chartNoAxesCombined =
      DsLucideGlyph('chart-no-axes-combined', <DsIconElement>[
    DsIconPathElement('M12 16v5'), // key: zza2cw
    DsIconPathElement('M16 14.639V21'), // key: 1s85h0
    DsIconPathElement('M20 10.656V21'), // key: q45596
    DsIconPathElement('m22 3-8.646 8.646a.5.5 0 0 1-.708 0L9.354 8.354a.5.5 0 0 0-.707 0L2 15'), // key: 1fw8x9
    DsIconPathElement('M4 18.463V21'), // key: 1otddq
    DsIconPathElement('M8 14.656V21'), // key: 1t2idw
  ]);

  /// `chart-no-axes-gantt.mjs`
  static const DsLucideGlyph chartNoAxesGantt =
      DsLucideGlyph('chart-no-axes-gantt', <DsIconElement>[
    DsIconPathElement('M6 5h12'), // key: fvfigv
    DsIconPathElement('M4 12h10'), // key: oujl3d
    DsIconPathElement('M12 19h8'), // key: baeox8
  ]);

  /// `chart-pie.mjs`
  static const DsLucideGlyph chartPie =
      DsLucideGlyph('chart-pie', <DsIconElement>[
    DsIconPathElement('M21 12c.552 0 1.005-.449.95-.998a10 10 0 0 0-8.953-8.951c-.55-.055-.998.398-.998.95v8a1 1 0 0 0 1 1z'), // key: pzmjnu
    DsIconPathElement('M21.21 15.89A10 10 0 1 1 8 2.83'), // key: k2fpak
  ]);

  /// `chart-scatter.mjs`
  static const DsLucideGlyph chartScatter =
      DsLucideGlyph('chart-scatter', <DsIconElement>[
    DsIconCircleElement(7.5, 7.5, 0.5, filled: true), // key: kqv944
    DsIconCircleElement(18.5, 5.5, 0.5, filled: true), // key: lysivs
    DsIconCircleElement(11.5, 11.5, 0.5, filled: true), // key: byv1b8
    DsIconCircleElement(7.5, 16.5, 0.5, filled: true), // key: nkw3mc
    DsIconCircleElement(17.5, 14.5, 0.5, filled: true), // key: 1gjh6j
    DsIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
  ]);

  /// `chart-spline.mjs`
  static const DsLucideGlyph chartSpline =
      DsLucideGlyph('chart-spline', <DsIconElement>[
    DsIconPathElement('M3 3v16a2 2 0 0 0 2 2h16'), // key: c24i48
    DsIconPathElement('M7 16c.5-2 1.5-7 4-7 2 0 2 3 4 3 2.5 0 4.5-5 5-7'), // key: lw07rv
  ]);

  /// `check-check.mjs`
  static const DsLucideGlyph checkCheck =
      DsLucideGlyph('check-check', <DsIconElement>[
    DsIconPathElement('M18 6 7 17l-5-5'), // key: 116fxf
    DsIconPathElement('m22 10-7.5 7.5L13 16'), // key: ke71qq
  ]);

  /// `check-line.mjs`
  static const DsLucideGlyph checkLine =
      DsLucideGlyph('check-line', <DsIconElement>[
    DsIconPathElement('M20 4L9 15'), // key: 1qkx8z
    DsIconPathElement('M21 19L3 19'), // key: 100sma
    DsIconPathElement('M9 15L4 10'), // key: 9zxff7
  ]);

  /// `check.mjs`
  static const DsLucideGlyph check =
      DsLucideGlyph('check', <DsIconElement>[
    DsIconPathElement('M20 6 9 17l-5-5'), // key: 1gmf2c
  ]);

  /// `chef-hat.mjs`
  static const DsLucideGlyph chefHat =
      DsLucideGlyph('chef-hat', <DsIconElement>[
    DsIconPathElement('M17 21a1 1 0 0 0 1-1v-5.35c0-.457.316-.844.727-1.041a4 4 0 0 0-2.134-7.589 5 5 0 0 0-9.186 0 4 4 0 0 0-2.134 7.588c.411.198.727.585.727 1.041V20a1 1 0 0 0 1 1Z'), // key: 1qvrer
    DsIconPathElement('M6 17h12'), // key: 1jwigz
  ]);

  /// `cherry.mjs`
  static const DsLucideGlyph cherry =
      DsLucideGlyph('cherry', <DsIconElement>[
    DsIconPathElement('M2 17a5 5 0 0 0 10 0c0-2.76-2.5-5-5-3-2.5-2-5 .24-5 3Z'), // key: cvxqlc
    DsIconPathElement('M12 17a5 5 0 0 0 10 0c0-2.76-2.5-5-5-3-2.5-2-5 .24-5 3Z'), // key: 1ostrc
    DsIconPathElement('M7 14c3.22-2.91 4.29-8.75 5-12 1.66 2.38 4.94 9 5 12'), // key: hqx58h
    DsIconPathElement('M22 9c-4.29 0-7.14-2.33-10-7 5.71 0 10 4.67 10 7Z'), // key: eykp1o
  ]);

  /// `chess-bishop.mjs`
  static const DsLucideGlyph chessBishop =
      DsLucideGlyph('chess-bishop', <DsIconElement>[
    DsIconPathElement('M5 20a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1z'), // key: b89hwq
    DsIconPathElement('M15 18c1.5-.615 3-2.461 3-4.923C18 8.769 14.5 4.462 12 2 9.5 4.462 6 8.77 6 13.077 6 15.539 7.5 17.385 9 18'), // key: 8jdkhx
    DsIconPathElement('m16 7-2.5 2.5'), // key: 1jq90w
    DsIconPathElement('M9 2h6'), // key: 1jrp98
  ]);

  /// `chess-king.mjs`
  static const DsLucideGlyph chessKing =
      DsLucideGlyph('chess-king', <DsIconElement>[
    DsIconPathElement('M4 20a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1z'), // key: mqzwx6
    DsIconPathElement('m6.7 18-1-1C4.35 15.682 3 14.09 3 12a5 5 0 0 1 4.95-5c1.584 0 2.7.455 4.05 1.818C13.35 7.455 14.466 7 16.05 7A5 5 0 0 1 21 12c0 2.082-1.359 3.673-2.7 5l-1 1'), // key: 1gdt1g
    DsIconPathElement('M10 4h4'), // key: 1xpv9s
    DsIconPathElement('M12 2v6.818'), // key: b17a49
  ]);

  /// `chess-knight.mjs`
  static const DsLucideGlyph chessKnight =
      DsLucideGlyph('chess-knight', <DsIconElement>[
    DsIconPathElement('M5 20a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1z'), // key: b89hwq
    DsIconPathElement('M16.5 18c1-2 2.5-5 2.5-9a7 7 0 0 0-7-7H6.635a1 1 0 0 0-.768 1.64L7 5l-2.32 5.802a2 2 0 0 0 .95 2.526l2.87 1.456'), // key: axbnlq
    DsIconPathElement('m15 5 1.425-1.425'), // key: 15xz8w
    DsIconPathElement('m17 8 1.53-1.53'), // key: 15zhqh
    DsIconPathElement('M9.713 12.185 7 18'), // key: 1ocm0l
  ]);

  /// `chess-pawn.mjs`
  static const DsLucideGlyph chessPawn =
      DsLucideGlyph('chess-pawn', <DsIconElement>[
    DsIconPathElement('M5 20a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1z'), // key: b89hwq
    DsIconPathElement('m14.5 10 1.5 8'), // key: cim3qy
    DsIconPathElement('M7 10h10'), // key: 1101jm
    DsIconPathElement('m8 18 1.5-8'), // key: ja3yjd
    DsIconCircleElement(12, 6, 4), // key: 1frrej
  ]);

  /// `chess-queen.mjs`
  static const DsLucideGlyph chessQueen =
      DsLucideGlyph('chess-queen', <DsIconElement>[
    DsIconPathElement('M4 20a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1z'), // key: mqzwx6
    DsIconPathElement('m12.474 5.943 1.567 5.34a1 1 0 0 0 1.75.328l2.616-3.402'), // key: 1js4gl
    DsIconPathElement('m20 9-3 9'), // key: r75r3f
    DsIconPathElement('m5.594 8.209 2.615 3.403a1 1 0 0 0 1.75-.329l1.567-5.34'), // key: 1joj19
    DsIconPathElement('M7 18 4 9'), // key: 1mfzj8
    DsIconCircleElement(12, 4, 2), // key: muu5ef
    DsIconCircleElement(20, 7, 2), // key: 9w7p1x
    DsIconCircleElement(4, 7, 2), // key: 1d9wy8
  ]);

  /// `chess-rook.mjs`
  static const DsLucideGlyph chessRook =
      DsLucideGlyph('chess-rook', <DsIconElement>[
    DsIconPathElement('M5 20a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H6a1 1 0 0 1-1-1z'), // key: b89hwq
    DsIconPathElement('M10 2v2'), // key: 7u0qdc
    DsIconPathElement('M14 2v2'), // key: 6buw04
    DsIconPathElement('m17 18-1-9'), // key: 10nd7q
    DsIconPathElement('M6 2v5a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V2'), // key: uxf4yx
    DsIconPathElement('M6 4h12'), // key: 1x2ag7
    DsIconPathElement('m7 18 1-9'), // key: 1si9vq
  ]);

  /// `chevron-down.mjs`
  static const DsLucideGlyph chevronDown =
      DsLucideGlyph('chevron-down', <DsIconElement>[
    DsIconPathElement('m6 9 6 6 6-6'), // key: qrunsl
  ]);

  /// `chevron-first.mjs`
  static const DsLucideGlyph chevronFirst =
      DsLucideGlyph('chevron-first', <DsIconElement>[
    DsIconPathElement('m17 18-6-6 6-6'), // key: 1yerx2
    DsIconPathElement('M7 6v12'), // key: 1p53r6
  ]);

  /// `chevron-last.mjs`
  static const DsLucideGlyph chevronLast =
      DsLucideGlyph('chevron-last', <DsIconElement>[
    DsIconPathElement('m7 18 6-6-6-6'), // key: lwmzdw
    DsIconPathElement('M17 6v12'), // key: 1o0aio
  ]);

  /// `chevron-left.mjs`
  static const DsLucideGlyph chevronLeft =
      DsLucideGlyph('chevron-left', <DsIconElement>[
    DsIconPathElement('m15 18-6-6 6-6'), // key: 1wnfg3
  ]);

  /// `chevron-right.mjs`
  static const DsLucideGlyph chevronRight =
      DsLucideGlyph('chevron-right', <DsIconElement>[
    DsIconPathElement('m9 18 6-6-6-6'), // key: mthhwq
  ]);

  /// `chevron-up.mjs`
  static const DsLucideGlyph chevronUp =
      DsLucideGlyph('chevron-up', <DsIconElement>[
    DsIconPathElement('m18 15-6-6-6 6'), // key: 153udz
  ]);

  /// `chevrons-down-up.mjs`
  static const DsLucideGlyph chevronsDownUp =
      DsLucideGlyph('chevrons-down-up', <DsIconElement>[
    DsIconPathElement('m7 20 5-5 5 5'), // key: 13a0gw
    DsIconPathElement('m7 4 5 5 5-5'), // key: 1kwcof
  ]);

  /// `chevrons-down.mjs`
  static const DsLucideGlyph chevronsDown =
      DsLucideGlyph('chevrons-down', <DsIconElement>[
    DsIconPathElement('m7 6 5 5 5-5'), // key: 1lc07p
    DsIconPathElement('m7 13 5 5 5-5'), // key: 1d48rs
  ]);

  /// `chevrons-left-right-ellipsis.mjs`
  static const DsLucideGlyph chevronsLeftRightEllipsis =
      DsLucideGlyph('chevrons-left-right-ellipsis', <DsIconElement>[
    DsIconPathElement('M12 12h.01'), // key: 1mp3jc
    DsIconPathElement('M16 12h.01'), // key: 1l6xoz
    DsIconPathElement('m17 7 5 5-5 5'), // key: 1xlxn0
    DsIconPathElement('m7 7-5 5 5 5'), // key: 19njba
    DsIconPathElement('M8 12h.01'), // key: czm47f
  ]);

  /// `chevrons-left-right.mjs`
  static const DsLucideGlyph chevronsLeftRight =
      DsLucideGlyph('chevrons-left-right', <DsIconElement>[
    DsIconPathElement('m9 7-5 5 5 5'), // key: j5w590
    DsIconPathElement('m15 7 5 5-5 5'), // key: 1bl6da
  ]);

  /// `chevrons-left.mjs`
  static const DsLucideGlyph chevronsLeft =
      DsLucideGlyph('chevrons-left', <DsIconElement>[
    DsIconPathElement('m11 17-5-5 5-5'), // key: 13zhaf
    DsIconPathElement('m18 17-5-5 5-5'), // key: h8a8et
  ]);

  /// `chevrons-right-left.mjs`
  static const DsLucideGlyph chevronsRightLeft =
      DsLucideGlyph('chevrons-right-left', <DsIconElement>[
    DsIconPathElement('m20 17-5-5 5-5'), // key: 30x0n2
    DsIconPathElement('m4 17 5-5-5-5'), // key: 16spf4
  ]);

  /// `chevrons-right.mjs`
  static const DsLucideGlyph chevronsRight =
      DsLucideGlyph('chevrons-right', <DsIconElement>[
    DsIconPathElement('m6 17 5-5-5-5'), // key: xnjwq
    DsIconPathElement('m13 17 5-5-5-5'), // key: 17xmmf
  ]);

  /// `chevrons-up-down.mjs`
  static const DsLucideGlyph chevronsUpDown =
      DsLucideGlyph('chevrons-up-down', <DsIconElement>[
    DsIconPathElement('m7 15 5 5 5-5'), // key: 1hf1tw
    DsIconPathElement('m7 9 5-5 5 5'), // key: sgt6xg
  ]);

  /// `chevrons-up.mjs`
  static const DsLucideGlyph chevronsUp =
      DsLucideGlyph('chevrons-up', <DsIconElement>[
    DsIconPathElement('m17 11-5-5-5 5'), // key: e8nh98
    DsIconPathElement('m17 18-5-5-5 5'), // key: 2avn1x
  ]);

  /// `church.mjs`
  static const DsLucideGlyph church =
      DsLucideGlyph('church', <DsIconElement>[
    DsIconPathElement('M10 9h4'), // key: u4k05v
    DsIconPathElement('M12 7v5'), // key: ma6bk
    DsIconPathElement('M14 21v-3a2 2 0 0 0-4 0v3'), // key: 1rgiei
    DsIconPathElement('m18 9 3.52 2.147a1 1 0 0 1 .48.854V19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-6.999a1 1 0 0 1 .48-.854L6 9'), // key: flvdwo
    DsIconPathElement('M6 21V7a1 1 0 0 1 .376-.782l5-3.999a1 1 0 0 1 1.249.001l5 4A1 1 0 0 1 18 7v14'), // key: a5i0n2
  ]);

  /// `cigarette-off.mjs`
  static const DsLucideGlyph cigaretteOff =
      DsLucideGlyph('cigarette-off', <DsIconElement>[
    DsIconPathElement('M12 12H3a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h13'), // key: 1gdiyg
    DsIconPathElement('M18 8c0-2.5-2-2.5-2-5'), // key: 1il607
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M21 12a1 1 0 0 1 1 1v2a1 1 0 0 1-.5.866'), // key: 166zjj
    DsIconPathElement('M22 8c0-2.5-2-2.5-2-5'), // key: 1gah44
    DsIconPathElement('M7 12v4'), // key: jqww69
  ]);

  /// `cigarette.mjs`
  static const DsLucideGlyph cigarette =
      DsLucideGlyph('cigarette', <DsIconElement>[
    DsIconPathElement('M17 12H3a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h14'), // key: 1mb5g1
    DsIconPathElement('M18 8c0-2.5-2-2.5-2-5'), // key: 1il607
    DsIconPathElement('M21 16a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1'), // key: 1yl5r7
    DsIconPathElement('M22 8c0-2.5-2-2.5-2-5'), // key: 1gah44
    DsIconPathElement('M7 12v4'), // key: jqww69
  ]);

  /// `circle-alert.mjs`
  static const DsLucideGlyph circleAlert =
      DsLucideGlyph('circle-alert', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconLineElement(12, 8, 12, 12), // key: 1pkeuh
    DsIconLineElement(12, 16, 12.01, 16), // key: 4dfq90
  ]);

  /// `circle-arrow-down.mjs`
  static const DsLucideGlyph circleArrowDown =
      DsLucideGlyph('circle-arrow-down', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M12 8v8'), // key: napkw2
    DsIconPathElement('m8 12 4 4 4-4'), // key: k98ssh
  ]);

  /// `circle-arrow-left.mjs`
  static const DsLucideGlyph circleArrowLeft =
      DsLucideGlyph('circle-arrow-left', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('m12 8-4 4 4 4'), // key: 15vm53
    DsIconPathElement('M16 12H8'), // key: 1fr5h0
  ]);

  /// `circle-arrow-out-down-left.mjs`
  static const DsLucideGlyph circleArrowOutDownLeft =
      DsLucideGlyph('circle-arrow-out-down-left', <DsIconElement>[
    DsIconPathElement('M2 12a10 10 0 1 1 10 10'), // key: 1yn6ov
    DsIconPathElement('m2 22 10-10'), // key: 28ilpk
    DsIconPathElement('M8 22H2v-6'), // key: sulq54
  ]);

  /// `circle-arrow-out-down-right.mjs`
  static const DsLucideGlyph circleArrowOutDownRight =
      DsLucideGlyph('circle-arrow-out-down-right', <DsIconElement>[
    DsIconPathElement('M12 22a10 10 0 1 1 10-10'), // key: 130bv5
    DsIconPathElement('M22 22 12 12'), // key: 131aw7
    DsIconPathElement('M22 16v6h-6'), // key: 1gvm70
  ]);

  /// `circle-arrow-out-up-left.mjs`
  static const DsLucideGlyph circleArrowOutUpLeft =
      DsLucideGlyph('circle-arrow-out-up-left', <DsIconElement>[
    DsIconPathElement('M2 8V2h6'), // key: hiwtdz
    DsIconPathElement('m2 2 10 10'), // key: 1oh8rs
    DsIconPathElement('M12 2A10 10 0 1 1 2 12'), // key: rrk4fa
  ]);

  /// `circle-arrow-out-up-right.mjs`
  static const DsLucideGlyph circleArrowOutUpRight =
      DsLucideGlyph('circle-arrow-out-up-right', <DsIconElement>[
    DsIconPathElement('M22 12A10 10 0 1 1 12 2'), // key: 1fm58d
    DsIconPathElement('M22 2 12 12'), // key: yg2myt
    DsIconPathElement('M16 2h6v6'), // key: zan5cs
  ]);

  /// `circle-arrow-right.mjs`
  static const DsLucideGlyph circleArrowRight =
      DsLucideGlyph('circle-arrow-right', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('m12 16 4-4-4-4'), // key: 1i9zcv
    DsIconPathElement('M8 12h8'), // key: 1wcyev
  ]);

  /// `circle-arrow-up.mjs`
  static const DsLucideGlyph circleArrowUp =
      DsLucideGlyph('circle-arrow-up', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('m16 12-4-4-4 4'), // key: 177agl
    DsIconPathElement('M12 16V8'), // key: 1sbj14
  ]);

  /// `circle-check-big.mjs`
  static const DsLucideGlyph circleCheckBig =
      DsLucideGlyph('circle-check-big', <DsIconElement>[
    DsIconPathElement('M21.801 10A10 10 0 1 1 17 3.335'), // key: yps3ct
    DsIconPathElement('m9 11 3 3L22 4'), // key: 1pflzl
  ]);

  /// `circle-check.mjs`
  static const DsLucideGlyph circleCheck =
      DsLucideGlyph('circle-check', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('m9 12 2 2 4-4'), // key: dzmm74
  ]);

  /// `circle-chevron-down.mjs`
  static const DsLucideGlyph circleChevronDown =
      DsLucideGlyph('circle-chevron-down', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('m16 10-4 4-4-4'), // key: 894hmk
  ]);

  /// `circle-chevron-left.mjs`
  static const DsLucideGlyph circleChevronLeft =
      DsLucideGlyph('circle-chevron-left', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('m14 16-4-4 4-4'), // key: ojs7w8
  ]);

  /// `circle-chevron-right.mjs`
  static const DsLucideGlyph circleChevronRight =
      DsLucideGlyph('circle-chevron-right', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('m10 8 4 4-4 4'), // key: 1wy4r4
  ]);

  /// `circle-chevron-up.mjs`
  static const DsLucideGlyph circleChevronUp =
      DsLucideGlyph('circle-chevron-up', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('m8 14 4-4 4 4'), // key: fy2ptz
  ]);

  /// `circle-dashed.mjs`
  static const DsLucideGlyph circleDashed =
      DsLucideGlyph('circle-dashed', <DsIconElement>[
    DsIconPathElement('M10.1 2.182a10 10 0 0 1 3.8 0'), // key: 5ilxe3
    DsIconPathElement('M13.9 21.818a10 10 0 0 1-3.8 0'), // key: 11zvb9
    DsIconPathElement('M17.609 3.721a10 10 0 0 1 2.69 2.7'), // key: 1iw5b2
    DsIconPathElement('M2.182 13.9a10 10 0 0 1 0-3.8'), // key: c0bmvh
    DsIconPathElement('M20.279 17.609a10 10 0 0 1-2.7 2.69'), // key: 1ruxm7
    DsIconPathElement('M21.818 10.1a10 10 0 0 1 0 3.8'), // key: qkgqxc
    DsIconPathElement('M3.721 6.391a10 10 0 0 1 2.7-2.69'), // key: 1mcia2
    DsIconPathElement('M6.391 20.279a10 10 0 0 1-2.69-2.7'), // key: 1fvljs
  ]);

  /// `circle-divide.mjs`
  static const DsLucideGlyph circleDivide =
      DsLucideGlyph('circle-divide', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconLineElement(8, 12, 16, 12), // key: 1jonct
    DsIconLineElement(12, 16, 12, 16), // key: aqc6ln
    DsIconLineElement(12, 8, 12, 8), // key: 1mkcni
  ]);

  /// `circle-dollar-sign.mjs`
  static const DsLucideGlyph circleDollarSign =
      DsLucideGlyph('circle-dollar-sign', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M16 8h-6a2 2 0 1 0 0 4h4a2 2 0 1 1 0 4H8'), // key: 1h4pet
    DsIconPathElement('M12 18V6'), // key: zqpxq5
  ]);

  /// `circle-dot-dashed.mjs`
  static const DsLucideGlyph circleDotDashed =
      DsLucideGlyph('circle-dot-dashed', <DsIconElement>[
    DsIconPathElement('M10.1 2.18a9.93 9.93 0 0 1 3.8 0'), // key: 1qdqn0
    DsIconPathElement('M17.6 3.71a9.95 9.95 0 0 1 2.69 2.7'), // key: 1bq7p6
    DsIconPathElement('M21.82 10.1a9.93 9.93 0 0 1 0 3.8'), // key: 1rlaqf
    DsIconPathElement('M20.29 17.6a9.95 9.95 0 0 1-2.7 2.69'), // key: 1xk03u
    DsIconPathElement('M13.9 21.82a9.94 9.94 0 0 1-3.8 0'), // key: l7re25
    DsIconPathElement('M6.4 20.29a9.95 9.95 0 0 1-2.69-2.7'), // key: 1v18p6
    DsIconPathElement('M2.18 13.9a9.93 9.93 0 0 1 0-3.8'), // key: xdo6bj
    DsIconPathElement('M3.71 6.4a9.95 9.95 0 0 1 2.7-2.69'), // key: 1jjmaz
    DsIconCircleElement(12, 12, 1), // key: 41hilf
  ]);

  /// `circle-dot.mjs`
  static const DsLucideGlyph circleDot =
      DsLucideGlyph('circle-dot', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconCircleElement(12, 12, 1), // key: 41hilf
  ]);

  /// `circle-ellipsis.mjs`
  static const DsLucideGlyph circleEllipsis =
      DsLucideGlyph('circle-ellipsis', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M17 12h.01'), // key: 1m0b6t
    DsIconPathElement('M12 12h.01'), // key: 1mp3jc
    DsIconPathElement('M7 12h.01'), // key: eqddd0
  ]);

  /// `circle-equal.mjs`
  static const DsLucideGlyph circleEqual =
      DsLucideGlyph('circle-equal', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M7 10h10'), // key: 1101jm
    DsIconPathElement('M7 14h10'), // key: 1mhdw3
  ]);

  /// `circle-euro.mjs`
  static const DsLucideGlyph circleEuro =
      DsLucideGlyph('circle-euro', <DsIconElement>[
    DsIconPathElement('M15 9.4a4 4 0 1 0 0 5.2'), // key: 1makmb
    DsIconPathElement('M7 12h5'), // key: gblrwe
    DsIconCircleElement(12, 12, 10), // key: 1mglay
  ]);

  /// `circle-fading-arrow-up.mjs`
  static const DsLucideGlyph circleFadingArrowUp =
      DsLucideGlyph('circle-fading-arrow-up', <DsIconElement>[
    DsIconPathElement('M12 2a10 10 0 0 1 7.38 16.75'), // key: 175t95
    DsIconPathElement('m16 12-4-4-4 4'), // key: 177agl
    DsIconPathElement('M12 16V8'), // key: 1sbj14
    DsIconPathElement('M2.5 8.875a10 10 0 0 0-.5 3'), // key: 1vce0s
    DsIconPathElement('M2.83 16a10 10 0 0 0 2.43 3.4'), // key: o3fkw4
    DsIconPathElement('M4.636 5.235a10 10 0 0 1 .891-.857'), // key: 1szpfk
    DsIconPathElement('M8.644 21.42a10 10 0 0 0 7.631-.38'), // key: 9yhvd4
  ]);

  /// `circle-fading-plus.mjs`
  static const DsLucideGlyph circleFadingPlus =
      DsLucideGlyph('circle-fading-plus', <DsIconElement>[
    DsIconPathElement('M12 2a10 10 0 0 1 7.38 16.75'), // key: 175t95
    DsIconPathElement('M12 8v8'), // key: napkw2
    DsIconPathElement('M16 12H8'), // key: 1fr5h0
    DsIconPathElement('M2.5 8.875a10 10 0 0 0-.5 3'), // key: 1vce0s
    DsIconPathElement('M2.83 16a10 10 0 0 0 2.43 3.4'), // key: o3fkw4
    DsIconPathElement('M4.636 5.235a10 10 0 0 1 .891-.857'), // key: 1szpfk
    DsIconPathElement('M8.644 21.42a10 10 0 0 0 7.631-.38'), // key: 9yhvd4
  ]);

  /// `circle-gauge.mjs`
  static const DsLucideGlyph circleGauge =
      DsLucideGlyph('circle-gauge', <DsIconElement>[
    DsIconPathElement('M15.6 2.7a10 10 0 1 0 5.7 5.7'), // key: 1e0p6d
    DsIconCircleElement(12, 12, 2), // key: 1c9p78
    DsIconPathElement('M13.4 10.6 19 5'), // key: 1kr7tw
  ]);

  /// `circle-minus.mjs`
  static const DsLucideGlyph circleMinus =
      DsLucideGlyph('circle-minus', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M8 12h8'), // key: 1wcyev
  ]);

  /// `circle-off.mjs`
  static const DsLucideGlyph circleOff =
      DsLucideGlyph('circle-off', <DsIconElement>[
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M8.35 2.69A10 10 0 0 1 21.3 15.65'), // key: 1pfsoa
    DsIconPathElement('M19.08 19.08A10 10 0 1 1 4.92 4.92'), // key: 1ablyi
  ]);

  /// `circle-parking-off.mjs`
  static const DsLucideGlyph circleParkingOff =
      DsLucideGlyph('circle-parking-off', <DsIconElement>[
    DsIconPathElement('M12.656 7H13a3 3 0 0 1 2.984 3.307'), // key: 1sjx87
    DsIconPathElement('M13 13H9'), // key: e2beee
    DsIconPathElement('M19.071 19.071A1 1 0 0 1 4.93 4.93'), // key: 1kb595
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M8.357 2.687a10 10 0 0 1 12.956 12.956'), // key: 5bsfdx
    DsIconPathElement('M9 17V9'), // key: ojradj
  ]);

  /// `circle-parking.mjs`
  static const DsLucideGlyph circleParking =
      DsLucideGlyph('circle-parking', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M9 17V7h4a3 3 0 0 1 0 6H9'), // key: 1dfk2c
  ]);

  /// `circle-pause.mjs`
  static const DsLucideGlyph circlePause =
      DsLucideGlyph('circle-pause', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconLineElement(10, 15, 10, 9), // key: c1nkhi
    DsIconLineElement(14, 15, 14, 9), // key: h65svq
  ]);

  /// `circle-percent.mjs`
  static const DsLucideGlyph circlePercent =
      DsLucideGlyph('circle-percent', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('m15 9-6 6'), // key: 1uzhvr
    DsIconPathElement('M9 9h.01'), // key: 1q5me6
    DsIconPathElement('M15 15h.01'), // key: lqbp3k
  ]);

  /// `circle-pile.mjs`
  static const DsLucideGlyph circlePile =
      DsLucideGlyph('circle-pile', <DsIconElement>[
    DsIconCircleElement(12, 19, 2), // key: 13j0tp
    DsIconCircleElement(12, 5, 2), // key: f1ur92
    DsIconCircleElement(16, 12, 2), // key: 4ma0v8
    DsIconCircleElement(20, 19, 2), // key: 1obnsp
    DsIconCircleElement(4, 19, 2), // key: p3m9r0
    DsIconCircleElement(8, 12, 2), // key: 1nvbw3
  ]);

  /// `circle-play.mjs`
  static const DsLucideGlyph circlePlay =
      DsLucideGlyph('circle-play', <DsIconElement>[
    DsIconPathElement('M9 9.003a1 1 0 0 1 1.517-.859l4.997 2.997a1 1 0 0 1 0 1.718l-4.997 2.997A1 1 0 0 1 9 14.996z'), // key: kmsa83
    DsIconCircleElement(12, 12, 10), // key: 1mglay
  ]);

  /// `circle-plus.mjs`
  static const DsLucideGlyph circlePlus =
      DsLucideGlyph('circle-plus', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M8 12h8'), // key: 1wcyev
    DsIconPathElement('M12 8v8'), // key: napkw2
  ]);

  /// `circle-pound-sterling.mjs`
  static const DsLucideGlyph circlePoundSterling =
      DsLucideGlyph('circle-pound-sterling', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M10 16V9.5a1 1 0 0 1 5 0'), // key: 1i1are
    DsIconPathElement('M8 12h4'), // key: qz6y1c
    DsIconPathElement('M8 16h7'), // key: sbedsn
  ]);

  /// `circle-power.mjs`
  static const DsLucideGlyph circlePower =
      DsLucideGlyph('circle-power', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M12 7v4'), // key: xawao1
    DsIconPathElement('M7.998 9.003a5 5 0 1 0 8-.005'), // key: 1pek45
  ]);

  /// `circle-question-mark.mjs`
  static const DsLucideGlyph circleQuestionMark =
      DsLucideGlyph('circle-question-mark', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3'), // key: 1u773s
    DsIconPathElement('M12 17h.01'), // key: p32p05
  ]);

  /// `circle-slash-2.mjs`
  static const DsLucideGlyph circleSlash2 =
      DsLucideGlyph('circle-slash-2', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M22 2 2 22'), // key: y4kqgn
  ]);

  /// `circle-slash.mjs`
  static const DsLucideGlyph circleSlash =
      DsLucideGlyph('circle-slash', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconLineElement(9, 15, 15, 9), // key: 1dfufj
  ]);

  /// `circle-small.mjs`
  static const DsLucideGlyph circleSmall =
      DsLucideGlyph('circle-small', <DsIconElement>[
    DsIconCircleElement(12, 12, 6), // key: 1vlfrh
  ]);

  /// `circle-star.mjs`
  static const DsLucideGlyph circleStar =
      DsLucideGlyph('circle-star', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M11.051 7.616a1 1 0 0 1 1.909.024l.737 1.452a1 1 0 0 0 .737.535l1.634.256a1 1 0 0 1 .588 1.806l-1.172 1.168a1 1 0 0 0-.282.866l.259 1.613a1 1 0 0 1-1.541 1.134l-1.465-.75a1 1 0 0 0-.912 0l-1.465.75a1 1 0 0 1-1.539-1.133l.258-1.613a1 1 0 0 0-.282-.867l-1.156-1.152a1 1 0 0 1 .572-1.822l1.633-.256a1 1 0 0 0 .737-.535z'), // key: 285bvi
  ]);

  /// `circle-stop.mjs`
  static const DsLucideGlyph circleStop =
      DsLucideGlyph('circle-stop', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconRectElement(9, 9, 6, 6, 1), // key: 1ssd4o
  ]);

  /// `circle-user-round.mjs`
  static const DsLucideGlyph circleUserRound =
      DsLucideGlyph('circle-user-round', <DsIconElement>[
    DsIconPathElement('M17.925 20.056a6 6 0 0 0-11.851.001'), // key: z69sun
    DsIconCircleElement(12, 11, 4), // key: 1gt34v
    DsIconCircleElement(12, 12, 10), // key: 1mglay
  ]);

  /// `circle-user.mjs`
  static const DsLucideGlyph circleUser =
      DsLucideGlyph('circle-user', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconCircleElement(12, 10, 3), // key: ilqhr7
    DsIconPathElement('M7 20.662V19a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v1.662'), // key: 154egf
  ]);

  /// `circle-x.mjs`
  static const DsLucideGlyph circleX =
      DsLucideGlyph('circle-x', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('m15 9-6 6'), // key: 1uzhvr
    DsIconPathElement('m9 9 6 6'), // key: z0biqf
  ]);

  /// `circle.mjs`
  static const DsLucideGlyph circle =
      DsLucideGlyph('circle', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
  ]);

  /// `circuit-board.mjs`
  static const DsLucideGlyph circuitBoard =
      DsLucideGlyph('circuit-board', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M11 9h4a2 2 0 0 0 2-2V3'), // key: 1ve2rv
    DsIconCircleElement(9, 9, 2), // key: af1f0g
    DsIconPathElement('M7 21v-4a2 2 0 0 1 2-2h4'), // key: 1fwkro
    DsIconCircleElement(15, 15, 2), // key: 3i40o0
  ]);

  /// `citrus.mjs`
  static const DsLucideGlyph citrus =
      DsLucideGlyph('citrus', <DsIconElement>[
    DsIconPathElement('M21.66 17.67a1.08 1.08 0 0 1-.04 1.6A12 12 0 0 1 4.73 2.38a1.1 1.1 0 0 1 1.61-.04z'), // key: 4ite01
    DsIconPathElement('M19.65 15.66A8 8 0 0 1 8.35 4.34'), // key: 1gxipu
    DsIconPathElement('m14 10-5.5 5.5'), // key: 92pfem
    DsIconPathElement('M14 17.85V10H6.15'), // key: xqmtsk
  ]);

  /// `clapperboard.mjs`
  static const DsLucideGlyph clapperboard =
      DsLucideGlyph('clapperboard', <DsIconElement>[
    DsIconPathElement('m12.296 3.464 3.02 3.956'), // key: qash78
    DsIconPathElement('M20.2 6 3 11l-.9-2.4c-.3-1.1.3-2.2 1.3-2.5l13.5-4c1.1-.3 2.2.3 2.5 1.3z'), // key: 1h7j8b
    DsIconPathElement('M3 11h18v8a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z'), // key: 4lm6w1
    DsIconPathElement('m6.18 5.276 3.1 3.899'), // key: zjj9t3
  ]);

  /// `clipboard-check.mjs`
  static const DsLucideGlyph clipboardCheck =
      DsLucideGlyph('clipboard-check', <DsIconElement>[
    DsIconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    DsIconPathElement('M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2'), // key: 116196
    DsIconPathElement('m9 14 2 2 4-4'), // key: df797q
  ]);

  /// `clipboard-clock.mjs`
  static const DsLucideGlyph clipboardClock =
      DsLucideGlyph('clipboard-clock', <DsIconElement>[
    DsIconPathElement('M16 14v2.2l1.6 1'), // key: fo4ql5
    DsIconPathElement('M16 4h2a2 2 0 0 1 2 2v.832'), // key: 1ujtp2
    DsIconPathElement('M8 4H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h2'), // key: qvpao1
    DsIconCircleElement(16, 16, 6), // key: qoo3c4
    DsIconRectElement(8, 2, 8, 4, 1), // key: ublpy
  ]);

  /// `clipboard-copy.mjs`
  static const DsLucideGlyph clipboardCopy =
      DsLucideGlyph('clipboard-copy', <DsIconElement>[
    DsIconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    DsIconPathElement('M8 4H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-2'), // key: 4jdomd
    DsIconPathElement('M16 4h2a2 2 0 0 1 2 2v4'), // key: 3hqy98
    DsIconPathElement('M21 14H11'), // key: 1bme5i
    DsIconPathElement('m15 10-4 4 4 4'), // key: 5dvupr
  ]);

  /// `clipboard-list.mjs`
  static const DsLucideGlyph clipboardList =
      DsLucideGlyph('clipboard-list', <DsIconElement>[
    DsIconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    DsIconPathElement('M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2'), // key: 116196
    DsIconPathElement('M12 11h4'), // key: 1jrz19
    DsIconPathElement('M12 16h4'), // key: n85exb
    DsIconPathElement('M8 11h.01'), // key: 1dfujw
    DsIconPathElement('M8 16h.01'), // key: 18s6g9
  ]);

  /// `clipboard-minus.mjs`
  static const DsLucideGlyph clipboardMinus =
      DsLucideGlyph('clipboard-minus', <DsIconElement>[
    DsIconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    DsIconPathElement('M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2'), // key: 116196
    DsIconPathElement('M9 14h6'), // key: 159ibu
  ]);

  /// `clipboard-paste.mjs`
  static const DsLucideGlyph clipboardPaste =
      DsLucideGlyph('clipboard-paste', <DsIconElement>[
    DsIconPathElement('M11 14h10'), // key: 1w8e9d
    DsIconPathElement('M16 4h2a2 2 0 0 1 2 2v1.344'), // key: 1e62lh
    DsIconPathElement('m17 18 4-4-4-4'), // key: z2g111
    DsIconPathElement('M8 4H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 1.793-1.113'), // key: bjbb7m
    DsIconRectElement(8, 2, 8, 4, 1), // key: ublpy
  ]);

  /// `clipboard-pen-line.mjs`
  static const DsLucideGlyph clipboardPenLine =
      DsLucideGlyph('clipboard-pen-line', <DsIconElement>[
    DsIconRectElement(8, 2, 8, 4, 1), // key: 1oijnt
    DsIconPathElement('M8 4H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-.5'), // key: 1but9f
    DsIconPathElement('M16 4h2a2 2 0 0 1 1.73 1'), // key: 1p8n7l
    DsIconPathElement('M8 18h1'), // key: 13wk12
    DsIconPathElement('M21.378 12.626a1 1 0 0 0-3.004-3.004l-4.01 4.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z'), // key: 2t3380
  ]);

  /// `clipboard-pen.mjs`
  static const DsLucideGlyph clipboardPen =
      DsLucideGlyph('clipboard-pen', <DsIconElement>[
    DsIconPathElement('M16 4h2a2 2 0 0 1 2 2v2'), // key: j91f56
    DsIconPathElement('M21.34 15.664a1 1 0 1 0-3.004-3.004l-5.01 5.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z'), // key: 16fuwn
    DsIconPathElement('M8 22H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2'), // key: 120tdm
    DsIconRectElement(8, 2, 8, 4, 1), // key: ublpy
  ]);

  /// `clipboard-plus.mjs`
  static const DsLucideGlyph clipboardPlus =
      DsLucideGlyph('clipboard-plus', <DsIconElement>[
    DsIconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    DsIconPathElement('M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2'), // key: 116196
    DsIconPathElement('M9 14h6'), // key: 159ibu
    DsIconPathElement('M12 17v-6'), // key: 1y8rbf
  ]);

  /// `clipboard-type.mjs`
  static const DsLucideGlyph clipboardType =
      DsLucideGlyph('clipboard-type', <DsIconElement>[
    DsIconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    DsIconPathElement('M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2'), // key: 116196
    DsIconPathElement('M9 12v-1h6v1'), // key: iehl6m
    DsIconPathElement('M11 17h2'), // key: 12w5me
    DsIconPathElement('M12 11v6'), // key: 1bwqyc
  ]);

  /// `clipboard-x.mjs`
  static const DsLucideGlyph clipboardX =
      DsLucideGlyph('clipboard-x', <DsIconElement>[
    DsIconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    DsIconPathElement('M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2'), // key: 116196
    DsIconPathElement('m15 11-6 6'), // key: 1toa9n
    DsIconPathElement('m9 11 6 6'), // key: wlibny
  ]);

  /// `clipboard.mjs`
  static const DsLucideGlyph clipboard =
      DsLucideGlyph('clipboard', <DsIconElement>[
    DsIconRectElement(8, 2, 8, 4, 1, ry: 1), // key: tgr4d6
    DsIconPathElement('M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2'), // key: 116196
  ]);

  /// `clock-1.mjs`
  static const DsLucideGlyph clock1 =
      DsLucideGlyph('clock-1', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M12 6v6l2-4'), // key: miptyd
  ]);

  /// `clock-10.mjs`
  static const DsLucideGlyph clock10 =
      DsLucideGlyph('clock-10', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M12 6v6l-4-2'), // key: cedpoo
  ]);

  /// `clock-11.mjs`
  static const DsLucideGlyph clock11 =
      DsLucideGlyph('clock-11', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M12 6v6l-2-4'), // key: ns39ag
  ]);

  /// `clock-12.mjs`
  static const DsLucideGlyph clock12 =
      DsLucideGlyph('clock-12', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M12 6v6'), // key: 1ipuwl
  ]);

  /// `clock-2.mjs`
  static const DsLucideGlyph clock2 =
      DsLucideGlyph('clock-2', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M12 6v6l4-2'), // key: 1r2kuh
  ]);

  /// `clock-3.mjs`
  static const DsLucideGlyph clock3 =
      DsLucideGlyph('clock-3', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M12 6v6h4'), // key: 135r8i
  ]);

  /// `clock-4.mjs`
  static const DsLucideGlyph clock4 =
      DsLucideGlyph('clock-4', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M12 6v6l4 2'), // key: mmk7yg
  ]);

  /// `clock-5.mjs`
  static const DsLucideGlyph clock5 =
      DsLucideGlyph('clock-5', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M12 6v6l2 4'), // key: 1287s9
  ]);

  /// `clock-6.mjs`
  static const DsLucideGlyph clock6 =
      DsLucideGlyph('clock-6', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M12 6v10'), // key: wf7rdh
  ]);

  /// `clock-7.mjs`
  static const DsLucideGlyph clock7 =
      DsLucideGlyph('clock-7', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M12 6v6l-2 4'), // key: 1095bu
  ]);

  /// `clock-8.mjs`
  static const DsLucideGlyph clock8 =
      DsLucideGlyph('clock-8', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M12 6v6l-4 2'), // key: imc3wl
  ]);

  /// `clock-9.mjs`
  static const DsLucideGlyph clock9 =
      DsLucideGlyph('clock-9', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M12 6v6H8'), // key: u39vzm
  ]);

  /// `clock-alert.mjs`
  static const DsLucideGlyph clockAlert =
      DsLucideGlyph('clock-alert', <DsIconElement>[
    DsIconPathElement('M12 6v6l4 2'), // key: mmk7yg
    DsIconPathElement('M20 12v5'), // key: 12wsvk
    DsIconPathElement('M20 21h.01'), // key: 1p6o6n
    DsIconPathElement('M21.25 8.2A10 10 0 1 0 16 21.16'), // key: 17fp9f
  ]);

  /// `clock-arrow-down.mjs`
  static const DsLucideGlyph clockArrowDown =
      DsLucideGlyph('clock-arrow-down', <DsIconElement>[
    DsIconPathElement('M12 6v6l2 1'), // key: 19cm8n
    DsIconPathElement('M12.337 21.994a10 10 0 1 1 9.588-8.767'), // key: 28moa
    DsIconPathElement('m14 18 4 4 4-4'), // key: 1waygx
    DsIconPathElement('M18 14v8'), // key: irew45
  ]);

  /// `clock-arrow-left.mjs`
  static const DsLucideGlyph clockArrowLeft =
      DsLucideGlyph('clock-arrow-left', <DsIconElement>[
    DsIconPathElement('M12 6v6l1.5.8'), // key: uc7jki
    DsIconPathElement('M12.338 21.994a10 10 0 1 1 9.587-8.767'), // key: 1lz5pu
    DsIconPathElement('M14 18h8'), // key: 1le3fr
    DsIconPathElement('m18 22-4-4 4-4'), // key: dh5o1f
  ]);

  /// `clock-arrow-right.mjs`
  static const DsLucideGlyph clockArrowRight =
      DsLucideGlyph('clock-arrow-right', <DsIconElement>[
    DsIconPathElement('M12 6v6l2 1'), // key: 19cm8n
    DsIconPathElement('M13.5 21.885A10 10 0 1 1 22 12'), // key: xgp8as
    DsIconPathElement('M14 18h8'), // key: 1le3fr
    DsIconPathElement('m18 22 4-4-4-4'), // key: mordo3
  ]);

  /// `clock-arrow-up.mjs`
  static const DsLucideGlyph clockArrowUp =
      DsLucideGlyph('clock-arrow-up', <DsIconElement>[
    DsIconPathElement('M12 6v6l1.56.78'), // key: 14ed3g
    DsIconPathElement('M13.227 21.925a10 10 0 1 1 8.767-9.588'), // key: jwkls1
    DsIconPathElement('m14 18 4-4 4 4'), // key: ftkppy
    DsIconPathElement('M18 22v-8'), // key: su0gjh
  ]);

  /// `clock-check.mjs`
  static const DsLucideGlyph clockCheck =
      DsLucideGlyph('clock-check', <DsIconElement>[
    DsIconPathElement('M12 6v6l4 2'), // key: mmk7yg
    DsIconPathElement('M22 12a10 10 0 1 0-11 9.95'), // key: 17dhok
    DsIconPathElement('m22 16-5.5 5.5L14 19'), // key: 1eibut
  ]);

  /// `clock-fading.mjs`
  static const DsLucideGlyph clockFading =
      DsLucideGlyph('clock-fading', <DsIconElement>[
    DsIconPathElement('M12 2a10 10 0 0 1 7.38 16.75'), // key: 175t95
    DsIconPathElement('M12 6v6l4 2'), // key: mmk7yg
    DsIconPathElement('M2.5 8.875a10 10 0 0 0-.5 3'), // key: 1vce0s
    DsIconPathElement('M2.83 16a10 10 0 0 0 2.43 3.4'), // key: o3fkw4
    DsIconPathElement('M4.636 5.235a10 10 0 0 1 .891-.857'), // key: 1szpfk
    DsIconPathElement('M8.644 21.42a10 10 0 0 0 7.631-.38'), // key: 9yhvd4
  ]);

  /// `clock-plus.mjs`
  static const DsLucideGlyph clockPlus =
      DsLucideGlyph('clock-plus', <DsIconElement>[
    DsIconPathElement('M12 6v6l3.644 1.822'), // key: 1jmett
    DsIconPathElement('M16 19h6'), // key: xwg31i
    DsIconPathElement('M19 16v6'), // key: tddt3s
    DsIconPathElement('M21.92 13.267a10 10 0 1 0-8.653 8.653'), // key: 1u0osk
  ]);

  /// `clock.mjs`
  static const DsLucideGlyph clock =
      DsLucideGlyph('clock', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M12 6v6l4 2'), // key: mmk7yg
  ]);

  /// `closed-caption.mjs`
  static const DsLucideGlyph closedCaption =
      DsLucideGlyph('closed-caption', <DsIconElement>[
    DsIconPathElement('M10 9.17a3 3 0 1 0 0 5.66'), // key: h9wayk
    DsIconPathElement('M17 9.17a3 3 0 1 0 0 5.66'), // key: 1v6zke
    DsIconRectElement(2, 5, 20, 14, 2), // key: qneu4z
  ]);

  /// `cloud-alert.mjs`
  static const DsLucideGlyph cloudAlert =
      DsLucideGlyph('cloud-alert', <DsIconElement>[
    DsIconPathElement('M12 12v4'), // key: tww15h
    DsIconPathElement('M12 20h.01'), // key: zekei9
    DsIconPathElement('M8.128 16.949A7 7 0 1 1 15.71 8h1.79a1 1 0 0 1 0 9h-1.642'), // key: 1namsd
  ]);

  /// `cloud-backup.mjs`
  static const DsLucideGlyph cloudBackup =
      DsLucideGlyph('cloud-backup', <DsIconElement>[
    DsIconPathElement('M21 15.251A4.5 4.5 0 0 0 17.5 8h-1.79A7 7 0 1 0 3 13.607'), // key: xpoh9y
    DsIconPathElement('M7 11v4h4'), // key: q9yh32
    DsIconPathElement('M8 19a5 5 0 0 0 9-3 4.5 4.5 0 0 0-4.5-4.5 4.82 4.82 0 0 0-3.41 1.41L7 15'), // key: 1xm8iu
  ]);

  /// `cloud-check.mjs`
  static const DsLucideGlyph cloudCheck =
      DsLucideGlyph('cloud-check', <DsIconElement>[
    DsIconPathElement('m17 15-5.5 5.5L9 18'), // key: 15q87x
    DsIconPathElement('M5.516 16.07A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 3.501 7.327'), // key: 1xtj56
  ]);

  /// `cloud-cog.mjs`
  static const DsLucideGlyph cloudCog =
      DsLucideGlyph('cloud-cog', <DsIconElement>[
    DsIconPathElement('m10.852 19.772-.383.924'), // key: r7sl7d
    DsIconPathElement('m13.148 14.228.383-.923'), // key: 1d5zpm
    DsIconPathElement('M13.148 19.772a3 3 0 1 0-2.296-5.544l-.383-.923'), // key: 1ydik7
    DsIconPathElement('m13.53 20.696-.382-.924a3 3 0 1 1-2.296-5.544'), // key: 1m1vsf
    DsIconPathElement('m14.772 15.852.923-.383'), // key: 660p6e
    DsIconPathElement('m14.772 18.148.923.383'), // key: hrcpis
    DsIconPathElement('M4.2 15.1a7 7 0 1 1 9.93-9.858A7 7 0 0 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.2'), // key: j2q98n
    DsIconPathElement('m9.228 15.852-.923-.383'), // key: 1p9ong
    DsIconPathElement('m9.228 18.148-.923.383'), // key: 6558rz
  ]);

  /// `cloud-download.mjs`
  static const DsLucideGlyph cloudDownload =
      DsLucideGlyph('cloud-download', <DsIconElement>[
    DsIconPathElement('M12 13v8l-4-4'), // key: 1f5nwf
    DsIconPathElement('m12 21 4-4'), // key: 1lfcce
    DsIconPathElement('M4.393 15.269A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.436 8.284'), // key: ui1hmy
  ]);

  /// `cloud-drizzle.mjs`
  static const DsLucideGlyph cloudDrizzle =
      DsLucideGlyph('cloud-drizzle', <DsIconElement>[
    DsIconPathElement('M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242'), // key: 1pljnt
    DsIconPathElement('M8 19v1'), // key: 1dk2by
    DsIconPathElement('M8 14v1'), // key: 84yxot
    DsIconPathElement('M16 19v1'), // key: v220m7
    DsIconPathElement('M16 14v1'), // key: g12gj6
    DsIconPathElement('M12 21v1'), // key: q8vafk
    DsIconPathElement('M12 16v1'), // key: 1mx6rx
  ]);

  /// `cloud-fog.mjs`
  static const DsLucideGlyph cloudFog =
      DsLucideGlyph('cloud-fog', <DsIconElement>[
    DsIconPathElement('M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242'), // key: 1pljnt
    DsIconPathElement('M16 17H7'), // key: pygtm1
    DsIconPathElement('M17 21H9'), // key: 1u2q02
  ]);

  /// `cloud-hail.mjs`
  static const DsLucideGlyph cloudHail =
      DsLucideGlyph('cloud-hail', <DsIconElement>[
    DsIconPathElement('M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242'), // key: 1pljnt
    DsIconPathElement('M16 14v2'), // key: a1is7l
    DsIconPathElement('M8 14v2'), // key: 1e9m6t
    DsIconPathElement('M16 20h.01'), // key: xwek51
    DsIconPathElement('M8 20h.01'), // key: 1vjney
    DsIconPathElement('M12 16v2'), // key: z66u1j
    DsIconPathElement('M12 22h.01'), // key: 1urd7a
  ]);

  /// `cloud-lightning.mjs`
  static const DsLucideGlyph cloudLightning =
      DsLucideGlyph('cloud-lightning', <DsIconElement>[
    DsIconPathElement('M6 16.326A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 .5 8.973'), // key: 1cez44
    DsIconPathElement('m13 12-3 5h4l-3 5'), // key: 1t22er
  ]);

  /// `cloud-moon-rain.mjs`
  static const DsLucideGlyph cloudMoonRain =
      DsLucideGlyph('cloud-moon-rain', <DsIconElement>[
    DsIconPathElement('M11 20v2'), // key: 174qtz
    DsIconPathElement('M18.376 14.512a6 6 0 0 0 3.461-4.127c.148-.625-.659-.97-1.248-.714a4 4 0 0 1-5.259-5.26c.255-.589-.09-1.395-.716-1.248a6 6 0 0 0-4.594 5.36'), // key: zwnc1e
    DsIconPathElement('M3 20a5 5 0 1 1 8.9-4H13a3 3 0 0 1 2 5.24'), // key: 1qmrp3
    DsIconPathElement('M7 19v2'), // key: 12npes
  ]);

  /// `cloud-moon.mjs`
  static const DsLucideGlyph cloudMoon =
      DsLucideGlyph('cloud-moon', <DsIconElement>[
    DsIconPathElement('M13 16a3 3 0 0 1 0 6H7a5 5 0 1 1 4.9-6z'), // key: ie2ih4
    DsIconPathElement('M18.376 14.512a6 6 0 0 0 3.461-4.127c.148-.625-.659-.97-1.248-.714a4 4 0 0 1-5.259-5.26c.255-.589-.09-1.395-.716-1.248a6 6 0 0 0-4.594 5.36'), // key: zwnc1e
  ]);

  /// `cloud-off.mjs`
  static const DsLucideGlyph cloudOff =
      DsLucideGlyph('cloud-off', <DsIconElement>[
    DsIconPathElement('M10.94 5.274A7 7 0 0 1 15.71 10h1.79a4.5 4.5 0 0 1 4.222 6.057'), // key: 1uxyv8
    DsIconPathElement('M18.796 18.81A4.5 4.5 0 0 1 17.5 19H9A7 7 0 0 1 5.79 5.78'), // key: 99tcn7
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `cloud-rain-wind.mjs`
  static const DsLucideGlyph cloudRainWind =
      DsLucideGlyph('cloud-rain-wind', <DsIconElement>[
    DsIconPathElement('M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242'), // key: 1pljnt
    DsIconPathElement('m9.2 22 3-7'), // key: sb5f6j
    DsIconPathElement('m9 13-3 7'), // key: 500co5
    DsIconPathElement('m17 13-3 7'), // key: 8t2fiy
  ]);

  /// `cloud-rain.mjs`
  static const DsLucideGlyph cloudRain =
      DsLucideGlyph('cloud-rain', <DsIconElement>[
    DsIconPathElement('M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242'), // key: 1pljnt
    DsIconPathElement('M16 14v6'), // key: 1j4efv
    DsIconPathElement('M8 14v6'), // key: 17c4r9
    DsIconPathElement('M12 16v6'), // key: c8a4gj
  ]);

  /// `cloud-snow.mjs`
  static const DsLucideGlyph cloudSnow =
      DsLucideGlyph('cloud-snow', <DsIconElement>[
    DsIconPathElement('M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242'), // key: 1pljnt
    DsIconPathElement('M8 15h.01'), // key: a7atzg
    DsIconPathElement('M8 19h.01'), // key: puxtts
    DsIconPathElement('M12 17h.01'), // key: p32p05
    DsIconPathElement('M12 21h.01'), // key: h35vbk
    DsIconPathElement('M16 15h.01'), // key: rnfrdf
    DsIconPathElement('M16 19h.01'), // key: 1vcnzz
  ]);

  /// `cloud-sun-rain.mjs`
  static const DsLucideGlyph cloudSunRain =
      DsLucideGlyph('cloud-sun-rain', <DsIconElement>[
    DsIconPathElement('M12 2v2'), // key: tus03m
    DsIconPathElement('m4.93 4.93 1.41 1.41'), // key: 149t6j
    DsIconPathElement('M20 12h2'), // key: 1q8mjw
    DsIconPathElement('m19.07 4.93-1.41 1.41'), // key: 1shlcs
    DsIconPathElement('M15.947 12.65a4 4 0 0 0-5.925-4.128'), // key: dpwdj0
    DsIconPathElement('M3 20a5 5 0 1 1 8.9-4H13a3 3 0 0 1 2 5.24'), // key: 1qmrp3
    DsIconPathElement('M11 20v2'), // key: 174qtz
    DsIconPathElement('M7 19v2'), // key: 12npes
  ]);

  /// `cloud-sun.mjs`
  static const DsLucideGlyph cloudSun =
      DsLucideGlyph('cloud-sun', <DsIconElement>[
    DsIconPathElement('M12 2v2'), // key: tus03m
    DsIconPathElement('m4.93 4.93 1.41 1.41'), // key: 149t6j
    DsIconPathElement('M20 12h2'), // key: 1q8mjw
    DsIconPathElement('m19.07 4.93-1.41 1.41'), // key: 1shlcs
    DsIconPathElement('M15.947 12.65a4 4 0 0 0-5.925-4.128'), // key: dpwdj0
    DsIconPathElement('M13 22H7a5 5 0 1 1 4.9-6H13a3 3 0 0 1 0 6Z'), // key: s09mg5
  ]);

  /// `cloud-sync.mjs`
  static const DsLucideGlyph cloudSync =
      DsLucideGlyph('cloud-sync', <DsIconElement>[
    DsIconPathElement('m17 18-1.535 1.605a5 5 0 0 1-8-1.5'), // key: adpv5j
    DsIconPathElement('M17 22v-4h-4'), // key: ex1ofj
    DsIconPathElement('M20.996 15.251A4.5 4.5 0 0 0 17.495 8h-1.79a7 7 0 1 0-12.709 5.607'), // key: ziqt14
    DsIconPathElement('M7 10v4h4'), // key: 1j6gx1
    DsIconPathElement('m7 14 1.535-1.605a5 5 0 0 1 8 1.5'), // key: 19q5h7
  ]);

  /// `cloud-upload.mjs`
  static const DsLucideGlyph cloudUpload =
      DsLucideGlyph('cloud-upload', <DsIconElement>[
    DsIconPathElement('M12 13v8'), // key: 1l5pq0
    DsIconPathElement('M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242'), // key: 1pljnt
    DsIconPathElement('m8 17 4-4 4 4'), // key: 1quai1
  ]);

  /// `cloud.mjs`
  static const DsLucideGlyph cloud =
      DsLucideGlyph('cloud', <DsIconElement>[
    DsIconPathElement('M17.5 19H9a7 7 0 1 1 6.71-9h1.79a4.5 4.5 0 1 1 0 9Z'), // key: p7xjir
  ]);

  /// `cloudy.mjs`
  static const DsLucideGlyph cloudy =
      DsLucideGlyph('cloudy', <DsIconElement>[
    DsIconPathElement('M17.5 12a1 1 0 1 1 0 9H9.006a7 7 0 1 1 6.702-9z'), // key: 44yre2
    DsIconPathElement('M21.832 9A3 3 0 0 0 19 7h-2.207a5.5 5.5 0 0 0-10.72.61'), // key: leugyv
  ]);

  /// `clover.mjs`
  static const DsLucideGlyph clover =
      DsLucideGlyph('clover', <DsIconElement>[
    DsIconPathElement('M16.17 7.83 2 22'), // key: t58vo8
    DsIconPathElement('M4.02 12a2.827 2.827 0 1 1 3.81-4.17A2.827 2.827 0 1 1 12 4.02a2.827 2.827 0 1 1 4.17 3.81A2.827 2.827 0 1 1 19.98 12a2.827 2.827 0 1 1-3.81 4.17A2.827 2.827 0 1 1 12 19.98a2.827 2.827 0 1 1-4.17-3.81A1 1 0 1 1 4 12'), // key: 17k36q
    DsIconPathElement('m7.83 7.83 8.34 8.34'), // key: 1d7sxk
  ]);

  /// `club.mjs`
  static const DsLucideGlyph club =
      DsLucideGlyph('club', <DsIconElement>[
    DsIconPathElement('M17.28 9.05a5.5 5.5 0 1 0-10.56 0A5.5 5.5 0 1 0 12 17.66a5.5 5.5 0 1 0 5.28-8.6Z'), // key: 27yuqz
    DsIconPathElement('M12 17.66L12 22'), // key: ogfahf
  ]);

  /// `code-xml.mjs`
  static const DsLucideGlyph codeXml =
      DsLucideGlyph('code-xml', <DsIconElement>[
    DsIconPathElement('m18 16 4-4-4-4'), // key: 1inbqp
    DsIconPathElement('m6 8-4 4 4 4'), // key: 15zrgr
    DsIconPathElement('m14.5 4-5 16'), // key: e7oirm
  ]);

  /// `code.mjs`
  static const DsLucideGlyph code =
      DsLucideGlyph('code', <DsIconElement>[
    DsIconPathElement('m16 18 6-6-6-6'), // key: eg8j8
    DsIconPathElement('m8 6-6 6 6 6'), // key: ppft3o
  ]);

  /// `coffee.mjs`
  static const DsLucideGlyph coffee =
      DsLucideGlyph('coffee', <DsIconElement>[
    DsIconPathElement('M10 2v2'), // key: 7u0qdc
    DsIconPathElement('M14 2v2'), // key: 6buw04
    DsIconPathElement('M16 8a1 1 0 0 1 1 1v8a4 4 0 0 1-4 4H7a4 4 0 0 1-4-4V9a1 1 0 0 1 1-1h14a4 4 0 1 1 0 8h-1'), // key: pwadti
    DsIconPathElement('M6 2v2'), // key: colzsn
  ]);

  /// `cog.mjs`
  static const DsLucideGlyph cog =
      DsLucideGlyph('cog', <DsIconElement>[
    DsIconPathElement('M11 10.27 7 3.34'), // key: 16pf9h
    DsIconPathElement('m11 13.73-4 6.93'), // key: 794ttg
    DsIconPathElement('M12 22v-2'), // key: 1osdcq
    DsIconPathElement('M12 2v2'), // key: tus03m
    DsIconPathElement('M14 12h8'), // key: 4f43i9
    DsIconPathElement('m17 20.66-1-1.73'), // key: eq3orb
    DsIconPathElement('m17 3.34-1 1.73'), // key: 2wel8s
    DsIconPathElement('M2 12h2'), // key: 1t8f8n
    DsIconPathElement('m20.66 17-1.73-1'), // key: sg0v6f
    DsIconPathElement('m20.66 7-1.73 1'), // key: 1ow05n
    DsIconPathElement('m3.34 17 1.73-1'), // key: nuk764
    DsIconPathElement('m3.34 7 1.73 1'), // key: 1ulond
    DsIconCircleElement(12, 12, 2), // key: 1c9p78
    DsIconCircleElement(12, 12, 8), // key: 46899m
  ]);

  /// `coins.mjs`
  static const DsLucideGlyph coins =
      DsLucideGlyph('coins', <DsIconElement>[
    DsIconPathElement('M13.744 17.736a6 6 0 1 1-7.48-7.48'), // key: bq4yh3
    DsIconPathElement('M15 6h1v4'), // key: 11y1tn
    DsIconPathElement('m6.134 14.768.866-.5 2 3.464'), // key: 17snzx
    DsIconCircleElement(16, 8, 6), // key: 14bfc9
  ]);

  /// `columns-2.mjs`
  static const DsLucideGlyph columns2 =
      DsLucideGlyph('columns-2', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M12 3v18'), // key: 108xh3
  ]);

  /// `columns-3-cog.mjs`
  static const DsLucideGlyph columns3Cog =
      DsLucideGlyph('columns-3-cog', <DsIconElement>[
    DsIconPathElement('M10.6 21H5a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v5.6'), // key: 19s2bv
    DsIconPathElement('m14.305 19.53.923-.382'), // key: 3m78fa
    DsIconPathElement('M15 3v7.6'), // key: mv9izd
    DsIconPathElement('m15.229 16.852-.924-.383'), // key: qpfz85
    DsIconPathElement('m16.852 15.228-.383-.923'), // key: 5xggr7
    DsIconPathElement('m16.852 20.772-.383.924'), // key: dpfhf9
    DsIconPathElement('m19.148 15.228.383-.923'), // key: 1reyyz
    DsIconPathElement('m19.53 21.696-.382-.924'), // key: 1goivc
    DsIconPathElement('m20.773 16.852.922-.383'), // key: 59dfo2
    DsIconPathElement('m20.773 19.148.922.383'), // key: 1lk755
    DsIconPathElement('M9 3v18'), // key: fh3hqa
    DsIconCircleElement(18, 18, 3), // key: 1xkwt0
  ]);

  /// `columns-3.mjs`
  static const DsLucideGlyph columns3 =
      DsLucideGlyph('columns-3', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M9 3v18'), // key: fh3hqa
    DsIconPathElement('M15 3v18'), // key: 14nvp0
  ]);

  /// `columns-4.mjs`
  static const DsLucideGlyph columns4 =
      DsLucideGlyph('columns-4', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M7.5 3v18'), // key: w0wo6v
    DsIconPathElement('M12 3v18'), // key: 108xh3
    DsIconPathElement('M16.5 3v18'), // key: 10tjh1
  ]);

  /// `combine.mjs`
  static const DsLucideGlyph combine =
      DsLucideGlyph('combine', <DsIconElement>[
    DsIconPathElement('M14 3a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1'), // key: 1l7d7l
    DsIconPathElement('M19 3a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1'), // key: 9955pe
    DsIconPathElement('m7 15 3 3'), // key: 4hkfgk
    DsIconPathElement('m7 21 3-3H5a2 2 0 0 1-2-2v-2'), // key: 1xljwe
    DsIconRectElement(14, 14, 7, 7, 1), // key: 1cdgtw
    DsIconRectElement(3, 3, 7, 7, 1), // key: zi3rio
  ]);

  /// `command.mjs`
  static const DsLucideGlyph command =
      DsLucideGlyph('command', <DsIconElement>[
    DsIconPathElement('M15 6v12a3 3 0 1 0 3-3H6a3 3 0 1 0 3 3V6a3 3 0 1 0-3 3h12a3 3 0 1 0-3-3'), // key: 11bfej
  ]);

  /// `compass.mjs`
  static const DsLucideGlyph compass =
      DsLucideGlyph('compass', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('m16.24 7.76-1.804 5.411a2 2 0 0 1-1.265 1.265L7.76 16.24l1.804-5.411a2 2 0 0 1 1.265-1.265z'), // key: 9ktpf1
  ]);

  /// `component.mjs`
  static const DsLucideGlyph component =
      DsLucideGlyph('component', <DsIconElement>[
    DsIconPathElement('M15.536 11.293a1 1 0 0 0 0 1.414l2.376 2.377a1 1 0 0 0 1.414 0l2.377-2.377a1 1 0 0 0 0-1.414l-2.377-2.377a1 1 0 0 0-1.414 0z'), // key: 1uwlt4
    DsIconPathElement('M2.297 11.293a1 1 0 0 0 0 1.414l2.377 2.377a1 1 0 0 0 1.414 0l2.377-2.377a1 1 0 0 0 0-1.414L6.088 8.916a1 1 0 0 0-1.414 0z'), // key: 10291m
    DsIconPathElement('M8.916 17.912a1 1 0 0 0 0 1.415l2.377 2.376a1 1 0 0 0 1.414 0l2.377-2.376a1 1 0 0 0 0-1.415l-2.377-2.376a1 1 0 0 0-1.414 0z'), // key: 1tqoq1
    DsIconPathElement('M8.916 4.674a1 1 0 0 0 0 1.414l2.377 2.376a1 1 0 0 0 1.414 0l2.377-2.376a1 1 0 0 0 0-1.414l-2.377-2.377a1 1 0 0 0-1.414 0z'), // key: 1x6lto
  ]);

  /// `computer.mjs`
  static const DsLucideGlyph computer =
      DsLucideGlyph('computer', <DsIconElement>[
    DsIconRectElement(5, 2, 14, 8, 2), // key: wc9tft
    DsIconRectElement(2, 14, 20, 8, 2), // key: w68u3i
    DsIconPathElement('M6 18h2'), // key: rwmk9e
    DsIconPathElement('M12 18h6'), // key: aqd8w3
  ]);

  /// `concierge-bell.mjs`
  static const DsLucideGlyph conciergeBell =
      DsLucideGlyph('concierge-bell', <DsIconElement>[
    DsIconPathElement('M3 20a1 1 0 0 1-1-1v-1a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1Z'), // key: 1pvr1r
    DsIconPathElement('M20 16a8 8 0 1 0-16 0'), // key: 1pa543
    DsIconPathElement('M12 4v4'), // key: 1bq03y
    DsIconPathElement('M10 4h4'), // key: 1xpv9s
  ]);

  /// `cone.mjs`
  static const DsLucideGlyph cone =
      DsLucideGlyph('cone', <DsIconElement>[
    DsIconPathElement('m20.9 18.55-8-15.98a1 1 0 0 0-1.8 0l-8 15.98'), // key: 53pte7
    DsIconEllipseElement(12, 19, 9, 3), // key: 1ji25f
  ]);

  /// `construction.mjs`
  static const DsLucideGlyph construction =
      DsLucideGlyph('construction', <DsIconElement>[
    DsIconRectElement(2, 6, 20, 8, 1), // key: 1estib
    DsIconPathElement('M17 14v7'), // key: 7m2elx
    DsIconPathElement('M7 14v7'), // key: 1cm7wv
    DsIconPathElement('M17 3v3'), // key: 1v4jwn
    DsIconPathElement('M7 3v3'), // key: 7o6guu
    DsIconPathElement('M10 14 2.3 6.3'), // key: 1023jk
    DsIconPathElement('m14 6 7.7 7.7'), // key: 1s8pl2
    DsIconPathElement('m8 6 8 8'), // key: hl96qh
  ]);

  /// `contact-round.mjs`
  static const DsLucideGlyph contactRound =
      DsLucideGlyph('contact-round', <DsIconElement>[
    DsIconPathElement('M16 2v2'), // key: scm5qe
    DsIconPathElement('M17.915 21a6 6 0 10-12 0'), // key: 13n4mv
    DsIconPathElement('M8 2v2'), // key: pbkmx
    DsIconCircleElement(12, 11, 4), // key: 1gt34v
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `contact.mjs`
  static const DsLucideGlyph contact =
      DsLucideGlyph('contact', <DsIconElement>[
    DsIconPathElement('M16 2v2'), // key: scm5qe
    DsIconPathElement('M7 21v-2a2 2 0 012-2h6a2 2 0 012 2v2'), // key: k82dct
    DsIconPathElement('M8 2v2'), // key: pbkmx
    DsIconCircleElement(12, 10, 3), // key: ilqhr7
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `container.mjs`
  static const DsLucideGlyph container =
      DsLucideGlyph('container', <DsIconElement>[
    DsIconPathElement('M22 7.7c0-.6-.4-1.2-.8-1.5l-6.3-3.9a1.72 1.72 0 0 0-1.7 0l-10.3 6c-.5.2-.9.8-.9 1.4v6.6c0 .5.4 1.2.8 1.5l6.3 3.9a1.72 1.72 0 0 0 1.7 0l10.3-6c.5-.3.9-1 .9-1.5Z'), // key: 1t2lqe
    DsIconPathElement('M10 21.9V14L2.1 9.1'), // key: o7czzq
    DsIconPathElement('m10 14 11.9-6.9'), // key: zm5e20
    DsIconPathElement('M14 19.8v-8.1'), // key: 159ecu
    DsIconPathElement('M18 17.5V9.4'), // key: 11uown
  ]);

  /// `contrast.mjs`
  static const DsLucideGlyph contrast =
      DsLucideGlyph('contrast', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M12 18a6 6 0 0 0 0-12v12z'), // key: j4l70d
  ]);

  /// `cookie.mjs`
  static const DsLucideGlyph cookie =
      DsLucideGlyph('cookie', <DsIconElement>[
    DsIconPathElement('M12 2a10 10 0 1 0 10 10 4 4 0 0 1-5-5 4 4 0 0 1-5-5'), // key: laymnq
    DsIconPathElement('M8.5 8.5v.01'), // key: ue8clq
    DsIconPathElement('M16 15.5v.01'), // key: 14dtrp
    DsIconPathElement('M12 12v.01'), // key: u5ubse
    DsIconPathElement('M11 17v.01'), // key: 1hyl5a
    DsIconPathElement('M7 14v.01'), // key: uct60s
  ]);

  /// `cooking-pot.mjs`
  static const DsLucideGlyph cookingPot =
      DsLucideGlyph('cooking-pot', <DsIconElement>[
    DsIconPathElement('M2 12h20'), // key: 9i4pu4
    DsIconPathElement('M20 12v8a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-8'), // key: u0tga0
    DsIconPathElement('m4 8 16-4'), // key: 16g0ng
    DsIconPathElement('m8.86 6.78-.45-1.81a2 2 0 0 1 1.45-2.43l1.94-.48a2 2 0 0 1 2.43 1.46l.45 1.8'), // key: 12cejc
  ]);

  /// `copy-check.mjs`
  static const DsLucideGlyph copyCheck =
      DsLucideGlyph('copy-check', <DsIconElement>[
    DsIconPathElement('m12 15 2 2 4-4'), // key: 2c609p
    DsIconRectElement(8, 8, 14, 14, 2, ry: 2), // key: 17jyea
    DsIconPathElement('M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2'), // key: zix9uf
  ]);

  /// `copy-minus.mjs`
  static const DsLucideGlyph copyMinus =
      DsLucideGlyph('copy-minus', <DsIconElement>[
    DsIconLineElement(12, 15, 18, 15), // key: 1nscbv
    DsIconRectElement(8, 8, 14, 14, 2, ry: 2), // key: 17jyea
    DsIconPathElement('M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2'), // key: zix9uf
  ]);

  /// `copy-plus.mjs`
  static const DsLucideGlyph copyPlus =
      DsLucideGlyph('copy-plus', <DsIconElement>[
    DsIconLineElement(15, 12, 15, 18), // key: 1p7wdc
    DsIconLineElement(12, 15, 18, 15), // key: 1nscbv
    DsIconRectElement(8, 8, 14, 14, 2, ry: 2), // key: 17jyea
    DsIconPathElement('M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2'), // key: zix9uf
  ]);

  /// `copy-slash.mjs`
  static const DsLucideGlyph copySlash =
      DsLucideGlyph('copy-slash', <DsIconElement>[
    DsIconLineElement(12, 18, 18, 12), // key: ebkxgr
    DsIconRectElement(8, 8, 14, 14, 2, ry: 2), // key: 17jyea
    DsIconPathElement('M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2'), // key: zix9uf
  ]);

  /// `copy-x.mjs`
  static const DsLucideGlyph copyX =
      DsLucideGlyph('copy-x', <DsIconElement>[
    DsIconLineElement(12, 12, 18, 18), // key: 1rg63v
    DsIconLineElement(12, 18, 18, 12), // key: ebkxgr
    DsIconRectElement(8, 8, 14, 14, 2, ry: 2), // key: 17jyea
    DsIconPathElement('M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2'), // key: zix9uf
  ]);

  /// `copy.mjs`
  static const DsLucideGlyph copy =
      DsLucideGlyph('copy', <DsIconElement>[
    DsIconRectElement(8, 8, 14, 14, 2, ry: 2), // key: 17jyea
    DsIconPathElement('M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2'), // key: zix9uf
  ]);

  /// `copyleft.mjs`
  static const DsLucideGlyph copyleft =
      DsLucideGlyph('copyleft', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M9.17 14.83a4 4 0 1 0 0-5.66'), // key: 1sveal
  ]);

  /// `copyright.mjs`
  static const DsLucideGlyph copyright =
      DsLucideGlyph('copyright', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M14.83 14.83a4 4 0 1 1 0-5.66'), // key: 1i56pz
  ]);

  /// `corner-down-left.mjs`
  static const DsLucideGlyph cornerDownLeft =
      DsLucideGlyph('corner-down-left', <DsIconElement>[
    DsIconPathElement('M20 4v7a4 4 0 0 1-4 4H4'), // key: 6o5b7l
    DsIconPathElement('m9 10-5 5 5 5'), // key: 1kshq7
  ]);

  /// `corner-down-right.mjs`
  static const DsLucideGlyph cornerDownRight =
      DsLucideGlyph('corner-down-right', <DsIconElement>[
    DsIconPathElement('m15 10 5 5-5 5'), // key: qqa56n
    DsIconPathElement('M4 4v7a4 4 0 0 0 4 4h12'), // key: z08zvw
  ]);

  /// `corner-left-down.mjs`
  static const DsLucideGlyph cornerLeftDown =
      DsLucideGlyph('corner-left-down', <DsIconElement>[
    DsIconPathElement('m14 15-5 5-5-5'), // key: 1eia93
    DsIconPathElement('M20 4h-7a4 4 0 0 0-4 4v12'), // key: nbpdq2
  ]);

  /// `corner-left-up.mjs`
  static const DsLucideGlyph cornerLeftUp =
      DsLucideGlyph('corner-left-up', <DsIconElement>[
    DsIconPathElement('M14 9 9 4 4 9'), // key: 1af5af
    DsIconPathElement('M20 20h-7a4 4 0 0 1-4-4V4'), // key: 1blwi3
  ]);

  /// `corner-right-down.mjs`
  static const DsLucideGlyph cornerRightDown =
      DsLucideGlyph('corner-right-down', <DsIconElement>[
    DsIconPathElement('m10 15 5 5 5-5'), // key: 1hpjnr
    DsIconPathElement('M4 4h7a4 4 0 0 1 4 4v12'), // key: wcbgct
  ]);

  /// `corner-right-up.mjs`
  static const DsLucideGlyph cornerRightUp =
      DsLucideGlyph('corner-right-up', <DsIconElement>[
    DsIconPathElement('m10 9 5-5 5 5'), // key: 9ctzwi
    DsIconPathElement('M4 20h7a4 4 0 0 0 4-4V4'), // key: 1plgdj
  ]);

  /// `corner-up-left.mjs`
  static const DsLucideGlyph cornerUpLeft =
      DsLucideGlyph('corner-up-left', <DsIconElement>[
    DsIconPathElement('M20 20v-7a4 4 0 0 0-4-4H4'), // key: 1nkjon
    DsIconPathElement('M9 14 4 9l5-5'), // key: 102s5s
  ]);

  /// `corner-up-right.mjs`
  static const DsLucideGlyph cornerUpRight =
      DsLucideGlyph('corner-up-right', <DsIconElement>[
    DsIconPathElement('m15 14 5-5-5-5'), // key: 12vg1m
    DsIconPathElement('M4 20v-7a4 4 0 0 1 4-4h12'), // key: 1lu4f8
  ]);

  /// `cpu.mjs`
  static const DsLucideGlyph cpu =
      DsLucideGlyph('cpu', <DsIconElement>[
    DsIconPathElement('M12 20v2'), // key: 1lh1kg
    DsIconPathElement('M12 2v2'), // key: tus03m
    DsIconPathElement('M17 20v2'), // key: 1rnc9c
    DsIconPathElement('M17 2v2'), // key: 11trls
    DsIconPathElement('M2 12h2'), // key: 1t8f8n
    DsIconPathElement('M2 17h2'), // key: 7oei6x
    DsIconPathElement('M2 7h2'), // key: asdhe0
    DsIconPathElement('M20 12h2'), // key: 1q8mjw
    DsIconPathElement('M20 17h2'), // key: 1fpfkl
    DsIconPathElement('M20 7h2'), // key: 1o8tra
    DsIconPathElement('M7 20v2'), // key: 4gnj0m
    DsIconPathElement('M7 2v2'), // key: 1i4yhu
    DsIconRectElement(4, 4, 16, 16, 2), // key: 1vbyd7
    DsIconRectElement(8, 8, 8, 8, 1), // key: z9xiuo
  ]);

  /// `creative-commons.mjs`
  static const DsLucideGlyph creativeCommons =
      DsLucideGlyph('creative-commons', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M10 9.3a2.8 2.8 0 0 0-3.5 1 3.1 3.1 0 0 0 0 3.4 2.7 2.7 0 0 0 3.5 1'), // key: 1ss3eq
    DsIconPathElement('M17 9.3a2.8 2.8 0 0 0-3.5 1 3.1 3.1 0 0 0 0 3.4 2.7 2.7 0 0 0 3.5 1'), // key: 1od56t
  ]);

  /// `credit-card.mjs`
  static const DsLucideGlyph creditCard =
      DsLucideGlyph('credit-card', <DsIconElement>[
    DsIconRectElement(2, 5, 20, 14, 2), // key: ynyp8z
    DsIconLineElement(2, 10, 22, 10), // key: 1b3vmo
  ]);

  /// `croissant.mjs`
  static const DsLucideGlyph croissant =
      DsLucideGlyph('croissant', <DsIconElement>[
    DsIconPathElement('M10.2 18H4.774a1.5 1.5 0 0 1-1.352-.97 11 11 0 0 1 .132-6.487'), // key: 14kkz9
    DsIconPathElement('M18 10.2V4.774a1.5 1.5 0 0 0-.97-1.352 11 11 0 0 0-6.486.132'), // key: 1g7v07
    DsIconPathElement('M18 5a4 3 0 0 1 4 3 2 2 0 0 1-2 2 10 10 0 0 0-5.139 1.42'), // key: ratg6b
    DsIconPathElement('M5 18a3 4 0 0 0 3 4 2 2 0 0 0 2-2 10 10 0 0 1 1.42-5.14'), // key: 4454f0
    DsIconPathElement('M8.709 2.554a10 10 0 0 0-6.155 6.155 1.5 1.5 0 0 0 .676 1.626l9.807 5.42a2 2 0 0 0 2.718-2.718l-5.42-9.807a1.5 1.5 0 0 0-1.626-.676'), // key: qmemie
  ]);

  /// `crop.mjs`
  static const DsLucideGlyph crop =
      DsLucideGlyph('crop', <DsIconElement>[
    DsIconPathElement('M6 2v14a2 2 0 0 0 2 2h14'), // key: ron5a4
    DsIconPathElement('M18 22V8a2 2 0 0 0-2-2H2'), // key: 7s9ehn
  ]);

  /// `cross.mjs`
  static const DsLucideGlyph cross =
      DsLucideGlyph('cross', <DsIconElement>[
    DsIconPathElement('M4 9a2 2 0 0 0-2 2v2a2 2 0 0 0 2 2h4a1 1 0 0 1 1 1v4a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2v-4a1 1 0 0 1 1-1h4a2 2 0 0 0 2-2v-2a2 2 0 0 0-2-2h-4a1 1 0 0 1-1-1V4a2 2 0 0 0-2-2h-2a2 2 0 0 0-2 2v4a1 1 0 0 1-1 1z'), // key: 1xbrqy
  ]);

  /// `crosshair.mjs`
  static const DsLucideGlyph crosshair =
      DsLucideGlyph('crosshair', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconLineElement(22, 12, 18, 12), // key: l9bcsi
    DsIconLineElement(6, 12, 2, 12), // key: 13hhkx
    DsIconLineElement(12, 6, 12, 2), // key: 10w3f3
    DsIconLineElement(12, 22, 12, 18), // key: 15g9kq
  ]);

  /// `crown.mjs`
  static const DsLucideGlyph crown =
      DsLucideGlyph('crown', <DsIconElement>[
    DsIconPathElement('M11.562 3.266a.5.5 0 0 1 .876 0L15.39 8.87a1 1 0 0 0 1.516.294L21.183 5.5a.5.5 0 0 1 .798.519l-2.834 10.246a1 1 0 0 1-.956.734H5.81a1 1 0 0 1-.957-.734L2.02 6.02a.5.5 0 0 1 .798-.519l4.276 3.664a1 1 0 0 0 1.516-.294z'), // key: 1vdc57
    DsIconPathElement('M5 21h14'), // key: 11awu3
  ]);

  /// `cuboid.mjs`
  static const DsLucideGlyph cuboid =
      DsLucideGlyph('cuboid', <DsIconElement>[
    DsIconPathElement('M10 22v-8'), // key: 1f8443
    DsIconPathElement('M2.336 8.89 10 14l11.715-7.029'), // key: 1qnufy
    DsIconPathElement('M22 14a2 2 0 0 1-.971 1.715l-10 6a2 2 0 0 1-2.138-.05l-6-4A2 2 0 0 1 2 16v-6a2 2 0 0 1 .971-1.715l10-6a2 2 0 0 1 2.138.05l6 4A2 2 0 0 1 22 8z'), // key: 670npk
  ]);

  /// `cup-soda.mjs`
  static const DsLucideGlyph cupSoda =
      DsLucideGlyph('cup-soda', <DsIconElement>[
    DsIconPathElement('m6 8 1.75 12.28a2 2 0 0 0 2 1.72h4.54a2 2 0 0 0 2-1.72L18 8'), // key: 8166m8
    DsIconPathElement('M5 8h14'), // key: pcz4l3
    DsIconPathElement('M7 15a6.47 6.47 0 0 1 5 0 6.47 6.47 0 0 0 5 0'), // key: yjz344
    DsIconPathElement('m12 8 1-6h2'), // key: 3ybfa4
  ]);

  /// `currency.mjs`
  static const DsLucideGlyph currency =
      DsLucideGlyph('currency', <DsIconElement>[
    DsIconCircleElement(12, 12, 8), // key: 46899m
    DsIconLineElement(3, 3, 6, 6), // key: 1jkytn
    DsIconLineElement(21, 3, 18, 6), // key: 14zfjt
    DsIconLineElement(3, 21, 6, 18), // key: iusuec
    DsIconLineElement(21, 21, 18, 18), // key: yj2dd7
  ]);

  /// `cylinder.mjs`
  static const DsLucideGlyph cylinder =
      DsLucideGlyph('cylinder', <DsIconElement>[
    DsIconEllipseElement(12, 5, 9, 3), // key: msslwz
    DsIconPathElement('M3 5v14a9 3 0 0 0 18 0V5'), // key: aqi0yr
  ]);

  /// `dam.mjs`
  static const DsLucideGlyph dam =
      DsLucideGlyph('dam', <DsIconElement>[
    DsIconPathElement('M11 11.31c1.17.56 1.54 1.69 3.5 1.69 2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1'), // key: 157kva
    DsIconPathElement('M11.75 18c.35.5 1.45 1 2.75 1 2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1'), // key: d7q6m6
    DsIconPathElement('M2 10h4'), // key: l0bgd4
    DsIconPathElement('M2 14h4'), // key: 1gsvsf
    DsIconPathElement('M2 18h4'), // key: 1bu2t1
    DsIconPathElement('M2 6h4'), // key: aawbzj
    DsIconPathElement('M7 3a1 1 0 0 0-1 1v16a1 1 0 0 0 1 1h4a1 1 0 0 0 1-1L10 4a1 1 0 0 0-1-1z'), // key: pr6s65
  ]);

  /// `database-arrow-down.mjs`
  static const DsLucideGlyph databaseArrowDown =
      DsLucideGlyph('database-arrow-down', <DsIconElement>[
    DsIconPathElement('m16 19 3 3 3-3'), // key: 1ibux0
    DsIconPathElement('M19 16v6'), // key: tddt3s
    DsIconPathElement('M21 12.536V5'), // key: zeza6i
    DsIconPathElement('M3 12A9 3 0 0 0 15.182 14.806'), // key: 11e5wb
    DsIconPathElement('M3 5V19A9 3 0 0 0 13.318 21.968'), // key: 1lyu4j
    DsIconEllipseElement(12, 5, 9, 3), // key: msslwz
  ]);

  /// `database-arrow-up.mjs`
  static const DsLucideGlyph databaseArrowUp =
      DsLucideGlyph('database-arrow-up', <DsIconElement>[
    DsIconPathElement('M19 22v-6'), // key: qhmiwi
    DsIconPathElement('M21 12.536V5'), // key: zeza6i
    DsIconPathElement('m22 19-3-3-3 3'), // key: rn6bg2
    DsIconPathElement('M3 12A9 3 0 0 0 14.457 14.886'), // key: 1941vg
    DsIconPathElement('M3 5V19A9 3 0 0 0 13.318 21.968'), // key: 1lyu4j
    DsIconEllipseElement(12, 5, 9, 3), // key: msslwz
  ]);

  /// `database-backup.mjs`
  static const DsLucideGlyph databaseBackup =
      DsLucideGlyph('database-backup', <DsIconElement>[
    DsIconEllipseElement(12, 5, 9, 3), // key: msslwz
    DsIconPathElement('M3 12a9 3 0 0 0 5 2.69'), // key: 1ui2ym
    DsIconPathElement('M21 9.3V5'), // key: 6k6cib
    DsIconPathElement('M3 5v14a9 3 0 0 0 6.47 2.88'), // key: i62tjy
    DsIconPathElement('M12 12v4h4'), // key: 1bxaet
    DsIconPathElement('M13 20a5 5 0 0 0 9-3 4.5 4.5 0 0 0-4.5-4.5c-1.33 0-2.54.54-3.41 1.41L12 16'), // key: 1f4ei9
  ]);

  /// `database-check.mjs`
  static const DsLucideGlyph databaseCheck =
      DsLucideGlyph('database-check', <DsIconElement>[
    DsIconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
    DsIconPathElement('M21 13.127V5'), // key: 59o5vz
    DsIconPathElement('M3 12A9 3 0 0 0 21 12'), // key: mv7ke4
    DsIconPathElement('M3 5V19A9 3 0 0 0 13.318 21.968'), // key: 1lyu4j
    DsIconEllipseElement(12, 5, 9, 3), // key: msslwz
  ]);

  /// `database-minus.mjs`
  static const DsLucideGlyph databaseMinus =
      DsLucideGlyph('database-minus', <DsIconElement>[
    DsIconPathElement('M21 15V5'), // key: 1lbg5w
    DsIconPathElement('M22 19h-6'), // key: vcuq98
    DsIconPathElement('M3 12A9 3 0 0 0 21 12'), // key: mv7ke4
    DsIconPathElement('M3 5V19A9 3 0 0 0 13.318 21.968'), // key: 1lyu4j
    DsIconEllipseElement(12, 5, 9, 3), // key: msslwz
  ]);

  /// `database-plus.mjs`
  static const DsLucideGlyph databasePlus =
      DsLucideGlyph('database-plus', <DsIconElement>[
    DsIconPathElement('M19 16v6'), // key: tddt3s
    DsIconPathElement('M21 12.536V5'), // key: zeza6i
    DsIconPathElement('M22 19h-6'), // key: vcuq98
    DsIconPathElement('M3 12A9 3 0 0 0 15.1824 14.8061'), // key: ukc3b1
    DsIconPathElement('M3 5V19A9 3 0 0 0 13.318 21.968'), // key: 1lyu4j
    DsIconEllipseElement(12, 5, 9, 3), // key: msslwz
  ]);

  /// `database-search.mjs`
  static const DsLucideGlyph databaseSearch =
      DsLucideGlyph('database-search', <DsIconElement>[
    DsIconPathElement('M21 11.693V5'), // key: 175m1t
    DsIconPathElement('m22 22-1.875-1.875'), // key: 13zax7
    DsIconPathElement('M3 12a9 3 0 0 0 8.697 2.998'), // key: 151u9p
    DsIconPathElement('M3 5v14a9 3 0 0 0 9.28 2.999'), // key: q2rs2p
    DsIconCircleElement(18, 18, 3), // key: 1xkwt0
    DsIconEllipseElement(12, 5, 9, 3), // key: msslwz
  ]);

  /// `database-x.mjs`
  static const DsLucideGlyph databaseX =
      DsLucideGlyph('database-x', <DsIconElement>[
    DsIconPathElement('m17 17 5 5'), // key: p7ous7
    DsIconPathElement('M19.323 13.744A9 3 0 0 0 21 12'), // key: hmry77
    DsIconPathElement('M21 13.127V5'), // key: 59o5vz
    DsIconPathElement('m22 17-5 5'), // key: gqnmv0
    DsIconPathElement('M3 12A9 3 0 0 0 13.563 14.954'), // key: 1rmyhq
    DsIconPathElement('M3 5V19A9 3 0 0 0 13 21.981'), // key: 159k2m
    DsIconEllipseElement(12, 5, 9, 3), // key: msslwz
  ]);

  /// `database-zap.mjs`
  static const DsLucideGlyph databaseZap =
      DsLucideGlyph('database-zap', <DsIconElement>[
    DsIconEllipseElement(12, 5, 9, 3), // key: msslwz
    DsIconPathElement('M3 5V19A9 3 0 0 0 15 21.84'), // key: 14ibmq
    DsIconPathElement('M21 5V8'), // key: 1marbg
    DsIconPathElement('M21 12L18 17H22L19 22'), // key: zafso
    DsIconPathElement('M3 12A9 3 0 0 0 14.59 14.87'), // key: 1y4wr8
  ]);

  /// `database.mjs`
  static const DsLucideGlyph database =
      DsLucideGlyph('database', <DsIconElement>[
    DsIconEllipseElement(12, 5, 9, 3), // key: msslwz
    DsIconPathElement('M3 5V19A9 3 0 0 0 21 19V5'), // key: 1wlel7
    DsIconPathElement('M3 12A9 3 0 0 0 21 12'), // key: mv7ke4
  ]);

  /// `decimals-arrow-left.mjs`
  static const DsLucideGlyph decimalsArrowLeft =
      DsLucideGlyph('decimals-arrow-left', <DsIconElement>[
    DsIconPathElement('m13 21-3-3 3-3'), // key: s3o1nf
    DsIconPathElement('M20 18H10'), // key: 14r3mt
    DsIconPathElement('M3 11h.01'), // key: 1eifu7
    DsIconRectElement(6, 3, 5, 8, 2.5), // key: v9paqo
  ]);

  /// `decimals-arrow-right.mjs`
  static const DsLucideGlyph decimalsArrowRight =
      DsLucideGlyph('decimals-arrow-right', <DsIconElement>[
    DsIconPathElement('M10 18h10'), // key: 1y5s8o
    DsIconPathElement('m17 21 3-3-3-3'), // key: 1ammt0
    DsIconPathElement('M3 11h.01'), // key: 1eifu7
    DsIconRectElement(15, 3, 5, 8, 2.5), // key: 76md6a
    DsIconRectElement(6, 3, 5, 8, 2.5), // key: v9paqo
  ]);

  /// `delete.mjs`
  static const DsLucideGlyph delete =
      DsLucideGlyph('delete', <DsIconElement>[
    DsIconPathElement('M10 5a2 2 0 0 0-1.344.519l-6.328 5.74a1 1 0 0 0 0 1.481l6.328 5.741A2 2 0 0 0 10 19h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2z'), // key: 1yo7s0
    DsIconPathElement('m12 9 6 6'), // key: anjzzh
    DsIconPathElement('m18 9-6 6'), // key: 1fp51s
  ]);

  /// `dessert.mjs`
  static const DsLucideGlyph dessert =
      DsLucideGlyph('dessert', <DsIconElement>[
    DsIconPathElement('M10.162 3.167A10 10 0 0 0 2 13a2 2 0 0 0 4 0v-1a2 2 0 0 1 4 0v4a2 2 0 0 0 4 0v-4a2 2 0 0 1 4 0v1a2 2 0 0 0 4-.006 10 10 0 0 0-8.161-9.826'), // key: xi88qy
    DsIconPathElement('M20.804 14.869a9 9 0 0 1-17.608 0'), // key: 1r28rg
    DsIconCircleElement(12, 4, 2), // key: muu5ef
  ]);

  /// `diameter.mjs`
  static const DsLucideGlyph diameter =
      DsLucideGlyph('diameter', <DsIconElement>[
    DsIconCircleElement(19, 19, 2), // key: 17f5cg
    DsIconCircleElement(5, 5, 2), // key: 1gwv83
    DsIconPathElement('M6.48 3.66a10 10 0 0 1 13.86 13.86'), // key: xr8kdq
    DsIconPathElement('m6.41 6.41 11.18 11.18'), // key: uhpjw7
    DsIconPathElement('M3.66 6.48a10 10 0 0 0 13.86 13.86'), // key: cldpwv
  ]);

  /// `diamond-minus.mjs`
  static const DsLucideGlyph diamondMinus =
      DsLucideGlyph('diamond-minus', <DsIconElement>[
    DsIconPathElement('M2.7 10.3a2.41 2.41 0 0 0 0 3.41l7.59 7.59a2.41 2.41 0 0 0 3.41 0l7.59-7.59a2.41 2.41 0 0 0 0-3.41L13.7 2.71a2.41 2.41 0 0 0-3.41 0z'), // key: 1ey20j
    DsIconPathElement('M8 12h8'), // key: 1wcyev
  ]);

  /// `diamond-percent.mjs`
  static const DsLucideGlyph diamondPercent =
      DsLucideGlyph('diamond-percent', <DsIconElement>[
    DsIconPathElement('M2.7 10.3a2.41 2.41 0 0 0 0 3.41l7.59 7.59a2.41 2.41 0 0 0 3.41 0l7.59-7.59a2.41 2.41 0 0 0 0-3.41L13.7 2.71a2.41 2.41 0 0 0-3.41 0Z'), // key: 1tpxz2
    DsIconPathElement('M9.2 9.2h.01'), // key: 1b7bvt
    DsIconPathElement('m14.5 9.5-5 5'), // key: 17q4r4
    DsIconPathElement('M14.7 14.8h.01'), // key: 17nsh4
  ]);

  /// `diamond-plus.mjs`
  static const DsLucideGlyph diamondPlus =
      DsLucideGlyph('diamond-plus', <DsIconElement>[
    DsIconPathElement('M12 8v8'), // key: napkw2
    DsIconPathElement('M2.7 10.3a2.41 2.41 0 0 0 0 3.41l7.59 7.59a2.41 2.41 0 0 0 3.41 0l7.59-7.59a2.41 2.41 0 0 0 0-3.41L13.7 2.71a2.41 2.41 0 0 0-3.41 0z'), // key: 1ey20j
    DsIconPathElement('M8 12h8'), // key: 1wcyev
  ]);

  /// `diamond.mjs`
  static const DsLucideGlyph diamond =
      DsLucideGlyph('diamond', <DsIconElement>[
    DsIconPathElement('M2.7 10.3a2.41 2.41 0 0 0 0 3.41l7.59 7.59a2.41 2.41 0 0 0 3.41 0l7.59-7.59a2.41 2.41 0 0 0 0-3.41l-7.59-7.59a2.41 2.41 0 0 0-3.41 0Z'), // key: 1f1r0c
  ]);

  /// `dice-1.mjs`
  static const DsLucideGlyph dice1 =
      DsLucideGlyph('dice-1', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    DsIconPathElement('M12 12h.01'), // key: 1mp3jc
  ]);

  /// `dice-2.mjs`
  static const DsLucideGlyph dice2 =
      DsLucideGlyph('dice-2', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    DsIconPathElement('M15 9h.01'), // key: x1ddxp
    DsIconPathElement('M9 15h.01'), // key: fzyn71
  ]);

  /// `dice-3.mjs`
  static const DsLucideGlyph dice3 =
      DsLucideGlyph('dice-3', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    DsIconPathElement('M16 8h.01'), // key: cr5u4v
    DsIconPathElement('M12 12h.01'), // key: 1mp3jc
    DsIconPathElement('M8 16h.01'), // key: 18s6g9
  ]);

  /// `dice-4.mjs`
  static const DsLucideGlyph dice4 =
      DsLucideGlyph('dice-4', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    DsIconPathElement('M16 8h.01'), // key: cr5u4v
    DsIconPathElement('M8 8h.01'), // key: 1e4136
    DsIconPathElement('M8 16h.01'), // key: 18s6g9
    DsIconPathElement('M16 16h.01'), // key: 1f9h7w
  ]);

  /// `dice-5.mjs`
  static const DsLucideGlyph dice5 =
      DsLucideGlyph('dice-5', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    DsIconPathElement('M16 8h.01'), // key: cr5u4v
    DsIconPathElement('M8 8h.01'), // key: 1e4136
    DsIconPathElement('M8 16h.01'), // key: 18s6g9
    DsIconPathElement('M16 16h.01'), // key: 1f9h7w
    DsIconPathElement('M12 12h.01'), // key: 1mp3jc
  ]);

  /// `dice-6.mjs`
  static const DsLucideGlyph dice6 =
      DsLucideGlyph('dice-6', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    DsIconPathElement('M16 8h.01'), // key: cr5u4v
    DsIconPathElement('M16 12h.01'), // key: 1l6xoz
    DsIconPathElement('M16 16h.01'), // key: 1f9h7w
    DsIconPathElement('M8 8h.01'), // key: 1e4136
    DsIconPathElement('M8 12h.01'), // key: czm47f
    DsIconPathElement('M8 16h.01'), // key: 18s6g9
  ]);

  /// `dices.mjs`
  static const DsLucideGlyph dices =
      DsLucideGlyph('dices', <DsIconElement>[
    DsIconRectElement(2, 10, 12, 12, 2, ry: 2), // key: 6agr2n
    DsIconPathElement('m17.92 14 3.5-3.5a2.24 2.24 0 0 0 0-3l-5-4.92a2.24 2.24 0 0 0-3 0L10 6'), // key: 1o487t
    DsIconPathElement('M6 18h.01'), // key: uhywen
    DsIconPathElement('M10 14h.01'), // key: ssrbsk
    DsIconPathElement('M15 6h.01'), // key: cblpky
    DsIconPathElement('M18 9h.01'), // key: 2061c0
  ]);

  /// `diff.mjs`
  static const DsLucideGlyph diff =
      DsLucideGlyph('diff', <DsIconElement>[
    DsIconPathElement('M12 3v14'), // key: 7cf3v8
    DsIconPathElement('M5 10h14'), // key: elsbfy
    DsIconPathElement('M5 21h14'), // key: 11awu3
  ]);

  /// `disc-2.mjs`
  static const DsLucideGlyph disc2 =
      DsLucideGlyph('disc-2', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconCircleElement(12, 12, 4), // key: 4exip2
    DsIconPathElement('M12 12h.01'), // key: 1mp3jc
  ]);

  /// `disc-3.mjs`
  static const DsLucideGlyph disc3 =
      DsLucideGlyph('disc-3', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M6 12c0-1.7.7-3.2 1.8-4.2'), // key: oqkarx
    DsIconCircleElement(12, 12, 2), // key: 1c9p78
    DsIconPathElement('M18 12c0 1.7-.7 3.2-1.8 4.2'), // key: 1eah9h
  ]);

  /// `disc-album.mjs`
  static const DsLucideGlyph discAlbum =
      DsLucideGlyph('disc-album', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconCircleElement(12, 12, 5), // key: nd82uf
    DsIconPathElement('M12 12h.01'), // key: 1mp3jc
  ]);

  /// `disc.mjs`
  static const DsLucideGlyph disc =
      DsLucideGlyph('disc', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `divide.mjs`
  static const DsLucideGlyph divide =
      DsLucideGlyph('divide', <DsIconElement>[
    DsIconCircleElement(12, 6, 1), // key: 1bh7o1
    DsIconLineElement(5, 12, 19, 12), // key: 13b5wn
    DsIconCircleElement(12, 18, 1), // key: lqb9t5
  ]);

  /// `dna-off.mjs`
  static const DsLucideGlyph dnaOff =
      DsLucideGlyph('dna-off', <DsIconElement>[
    DsIconPathElement('M15 2c-1.35 1.5-2.092 3-2.5 4.5L14 8'), // key: 1bivrr
    DsIconPathElement('m17 6-2.891-2.891'), // key: xu6p2f
    DsIconPathElement('M2 15c3.333-3 6.667-3 10-3'), // key: nxix30
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('m20 9 .891.891'), // key: 3xwk7g
    DsIconPathElement('M22 9c-1.5 1.35-3 2.092-4.5 2.5l-1-1'), // key: 18cutr
    DsIconPathElement('M3.109 14.109 4 15'), // key: q76aoh
    DsIconPathElement('m6.5 12.5 1 1'), // key: cs35ky
    DsIconPathElement('m7 18 2.891 2.891'), // key: 1sisit
    DsIconPathElement('M9 22c1.35-1.5 2.092-3 2.5-4.5L10 16'), // key: rlvei3
  ]);

  /// `dna.mjs`
  static const DsLucideGlyph dna =
      DsLucideGlyph('dna', <DsIconElement>[
    DsIconPathElement('m10 16 1.5 1.5'), // key: 11lckj
    DsIconPathElement('m14 8-1.5-1.5'), // key: 1ohn8i
    DsIconPathElement('M15 2c-1.798 1.998-2.518 3.995-2.807 5.993'), // key: 80uv8i
    DsIconPathElement('m16.5 10.5 1 1'), // key: 696xn5
    DsIconPathElement('m17 6-2.891-2.891'), // key: xu6p2f
    DsIconPathElement('M2 15c6.667-6 13.333 0 20-6'), // key: 1pyr53
    DsIconPathElement('m20 9 .891.891'), // key: 3xwk7g
    DsIconPathElement('M3.109 14.109 4 15'), // key: q76aoh
    DsIconPathElement('m6.5 12.5 1 1'), // key: cs35ky
    DsIconPathElement('m7 18 2.891 2.891'), // key: 1sisit
    DsIconPathElement('M9 22c1.798-1.998 2.518-3.995 2.807-5.993'), // key: q3hbxp
  ]);

  /// `dock.mjs`
  static const DsLucideGlyph dock =
      DsLucideGlyph('dock', <DsIconElement>[
    DsIconPathElement('M2 8h20'), // key: d11cs7
    DsIconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
    DsIconPathElement('M6 16h12'), // key: u522kt
  ]);

  /// `dog.mjs`
  static const DsLucideGlyph dog =
      DsLucideGlyph('dog', <DsIconElement>[
    DsIconPathElement('M11.25 16.25h1.5L12 17z'), // key: w7jh35
    DsIconPathElement('M16 14v.5'), // key: 1lajdz
    DsIconPathElement('M4.42 11.247A13.152 13.152 0 0 0 4 14.556C4 18.728 7.582 21 12 21s8-2.272 8-6.444a11.702 11.702 0 0 0-.493-3.309'), // key: u7s9ue
    DsIconPathElement('M8 14v.5'), // key: 1nzgdb
    DsIconPathElement('M8.5 8.5c-.384 1.05-1.083 2.028-2.344 2.5-1.931.722-3.576-.297-3.656-1-.113-.994 1.177-6.53 4-7 1.923-.321 3.651.845 3.651 2.235A7.497 7.497 0 0 1 14 5.277c0-1.39 1.844-2.598 3.767-2.277 2.823.47 4.113 6.006 4 7-.08.703-1.725 1.722-3.656 1-1.261-.472-1.855-1.45-2.239-2.5'), // key: v8hric
  ]);

  /// `dollar-sign.mjs`
  static const DsLucideGlyph dollarSign =
      DsLucideGlyph('dollar-sign', <DsIconElement>[
    DsIconLineElement(12, 2, 12, 22), // key: 7eqyqh
    DsIconPathElement('M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6'), // key: 1b0p4s
  ]);

  /// `donut.mjs`
  static const DsLucideGlyph donut =
      DsLucideGlyph('donut', <DsIconElement>[
    DsIconPathElement('M20.5 10a2.5 2.5 0 0 1-2.4-3H18a2.95 2.95 0 0 1-2.6-4.4 10 10 0 1 0 6.3 7.1c-.3.2-.8.3-1.2.3'), // key: 19sr3x
    DsIconCircleElement(12, 12, 3), // key: 1v7zrd
  ]);

  /// `door-closed-locked.mjs`
  static const DsLucideGlyph doorClosedLocked =
      DsLucideGlyph('door-closed-locked', <DsIconElement>[
    DsIconPathElement('M10 12h.01'), // key: 1kxr2c
    DsIconPathElement('M18 9V6a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v14'), // key: 1bnhmg
    DsIconPathElement('M2 20h8'), // key: 10ntw1
    DsIconPathElement('M20 17v-2a2 2 0 1 0-4 0v2'), // key: pwaxnr
    DsIconRectElement(14, 17, 8, 5, 1), // key: 15pjcy
  ]);

  /// `door-closed.mjs`
  static const DsLucideGlyph doorClosed =
      DsLucideGlyph('door-closed', <DsIconElement>[
    DsIconPathElement('M10 12h.01'), // key: 1kxr2c
    DsIconPathElement('M18 20V6a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v14'), // key: 36qu9e
    DsIconPathElement('M2 20h20'), // key: owomy5
  ]);

  /// `door-open.mjs`
  static const DsLucideGlyph doorOpen =
      DsLucideGlyph('door-open', <DsIconElement>[
    DsIconPathElement('M11 20H2'), // key: nlcfvz
    DsIconPathElement('M11 4.562v16.157a1 1 0 0 0 1.242.97L19 20V5.562a2 2 0 0 0-1.515-1.94l-4-1A2 2 0 0 0 11 4.561z'), // key: au4z13
    DsIconPathElement('M11 4H8a2 2 0 0 0-2 2v14'), // key: 74r1mk
    DsIconPathElement('M14 12h.01'), // key: 1jfl7z
    DsIconPathElement('M22 20h-3'), // key: vhrsz
  ]);

  /// `dot.mjs`
  static const DsLucideGlyph dot =
      DsLucideGlyph('dot', <DsIconElement>[
    DsIconCircleElement(12, 12, 1), // key: 41hilf
  ]);

  /// `download.mjs`
  static const DsLucideGlyph download =
      DsLucideGlyph('download', <DsIconElement>[
    DsIconPathElement('M12 15V3'), // key: m9g1x1
    DsIconPathElement('M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4'), // key: ih7n3h
    DsIconPathElement('m7 10 5 5 5-5'), // key: brsn70
  ]);

  /// `drafting-compass.mjs`
  static const DsLucideGlyph draftingCompass =
      DsLucideGlyph('drafting-compass', <DsIconElement>[
    DsIconPathElement('m12.99 6.74 1.93 3.44'), // key: iwagvd
    DsIconPathElement('M19.136 12a10 10 0 0 1-14.271 0'), // key: ppmlo4
    DsIconPathElement('m21 21-2.16-3.84'), // key: vylbct
    DsIconPathElement('m3 21 8.02-14.26'), // key: 1ssaw4
    DsIconCircleElement(12, 5, 2), // key: f1ur92
  ]);

  /// `drama.mjs`
  static const DsLucideGlyph drama =
      DsLucideGlyph('drama', <DsIconElement>[
    DsIconPathElement('M10 11h.01'), // key: d2at3l
    DsIconPathElement('M14 6h.01'), // key: k028ub
    DsIconPathElement('M18 6h.01'), // key: 1v4wsw
    DsIconPathElement('M6.5 13.1h.01'), // key: 1748ia
    DsIconPathElement('M22 5c0 9-4 12-6 12s-6-3-6-12c0-2 2-3 6-3s6 1 6 3'), // key: 172yzv
    DsIconPathElement('M17.4 9.9c-.8.8-2 .8-2.8 0'), // key: 1obv0w
    DsIconPathElement('M10.1 7.1C9 7.2 7.7 7.7 6 8.6c-3.5 2-4.7 3.9-3.7 5.6 4.5 7.8 9.5 8.4 11.2 7.4.9-.5 1.9-2.1 1.9-4.7'), // key: rqjl8i
    DsIconPathElement('M9.1 16.5c.3-1.1 1.4-1.7 2.4-1.4'), // key: 1mr6wy
  ]);

  /// `drill.mjs`
  static const DsLucideGlyph drill =
      DsLucideGlyph('drill', <DsIconElement>[
    DsIconPathElement('M10 18a1 1 0 0 1 1 1v2a1 1 0 0 1-1 1H5a3 3 0 0 1-3-3 1 1 0 0 1 1-1z'), // key: ioqxb1
    DsIconPathElement('M13 10H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a1 1 0 0 1 1 1v6a1 1 0 0 1-1 1l-.81 3.242a1 1 0 0 1-.97.758H8'), // key: 1rs59n
    DsIconPathElement('M14 4h3a1 1 0 0 1 1 1v2a1 1 0 0 1-1 1h-3'), // key: 105ega
    DsIconPathElement('M18 6h4'), // key: 66u95g
    DsIconPathElement('m5 10-2 8'), // key: xt2lic
    DsIconPathElement('m7 18 2-8'), // key: 1bzku2
  ]);

  /// `drone.mjs`
  static const DsLucideGlyph drone =
      DsLucideGlyph('drone', <DsIconElement>[
    DsIconPathElement('M10 10 7 7'), // key: zp14k7
    DsIconPathElement('m10 14-3 3'), // key: 1jrpxk
    DsIconPathElement('m14 10 3-3'), // key: 7tigam
    DsIconPathElement('m14 14 3 3'), // key: vm23p3
    DsIconPathElement('M14.205 4.139a4 4 0 1 1 5.439 5.863'), // key: 1tm5p2
    DsIconPathElement('M19.637 14a4 4 0 1 1-5.432 5.868'), // key: 16egi2
    DsIconPathElement('M4.367 10a4 4 0 1 1 5.438-5.862'), // key: 1wta6a
    DsIconPathElement('M9.795 19.862a4 4 0 1 1-5.429-5.873'), // key: q39hpv
    DsIconRectElement(10, 8, 4, 8, 1), // key: phrjt1
  ]);

  /// `droplet-off.mjs`
  static const DsLucideGlyph dropletOff =
      DsLucideGlyph('droplet-off', <DsIconElement>[
    DsIconPathElement('M18.715 13.186C18.29 11.858 17.384 10.607 16 9.5c-2-1.6-3.5-4-4-6.5a10.7 10.7 0 0 1-.884 2.586'), // key: 8suz2t
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M8.795 8.797A11 11 0 0 1 8 9.5C6 11.1 5 13 5 15a7 7 0 0 0 13.222 3.208'), // key: 19dw9m
  ]);

  /// `droplet.mjs`
  static const DsLucideGlyph droplet =
      DsLucideGlyph('droplet', <DsIconElement>[
    DsIconPathElement('M12 22a7 7 0 0 0 7-7c0-2-1-3.9-3-5.5s-3.5-4-4-6.5c-.5 2.5-2 4.9-4 6.5C6 11.1 5 13 5 15a7 7 0 0 0 7 7z'), // key: c7niix
  ]);

  /// `droplets.mjs`
  static const DsLucideGlyph droplets =
      DsLucideGlyph('droplets', <DsIconElement>[
    DsIconPathElement('M7 16.3c2.2 0 4-1.83 4-4.05 0-1.16-.57-2.26-1.71-3.19S7.29 6.75 7 5.3c-.29 1.45-1.14 2.84-2.29 3.76S3 11.1 3 12.25c0 2.22 1.8 4.05 4 4.05z'), // key: 1ptgy4
    DsIconPathElement('M12.56 6.6A10.97 10.97 0 0 0 14 3.02c.5 2.5 2 4.9 4 6.5s3 3.5 3 5.5a6.98 6.98 0 0 1-11.91 4.97'), // key: 1sl1rz
  ]);

  /// `drum.mjs`
  static const DsLucideGlyph drum =
      DsLucideGlyph('drum', <DsIconElement>[
    DsIconPathElement('m2 2 8 8'), // key: 1v6059
    DsIconPathElement('m22 2-8 8'), // key: 173r8a
    DsIconEllipseElement(12, 9, 10, 5), // key: liohsx
    DsIconPathElement('M7 13.4v7.9'), // key: 1yi6u9
    DsIconPathElement('M12 14v8'), // key: 1tn2tj
    DsIconPathElement('M17 13.4v7.9'), // key: eqz2v3
    DsIconPathElement('M2 9v8a10 5 0 0 0 20 0V9'), // key: 1750ul
  ]);

  /// `drumstick.mjs`
  static const DsLucideGlyph drumstick =
      DsLucideGlyph('drumstick', <DsIconElement>[
    DsIconPathElement('M15.4 15.63a7.875 6 135 1 1 6.23-6.23 4.5 3.43 135 0 0-6.23 6.23'), // key: 1dtqwm
    DsIconPathElement('m8.29 12.71-2.6 2.6a2.5 2.5 0 1 0-1.65 4.65A2.5 2.5 0 1 0 8.7 18.3l2.59-2.59'), // key: 1oq1fw
  ]);

  /// `dumbbell.mjs`
  static const DsLucideGlyph dumbbell =
      DsLucideGlyph('dumbbell', <DsIconElement>[
    DsIconPathElement('M17.596 12.768a2 2 0 1 0 2.829-2.829l-1.768-1.767a2 2 0 0 0 2.828-2.829l-2.828-2.828a2 2 0 0 0-2.829 2.828l-1.767-1.768a2 2 0 1 0-2.829 2.829z'), // key: 9m4mmf
    DsIconPathElement('m2.5 21.5 1.4-1.4'), // key: 17g3f0
    DsIconPathElement('m20.1 3.9 1.4-1.4'), // key: 1qn309
    DsIconPathElement('M5.343 21.485a2 2 0 1 0 2.829-2.828l1.767 1.768a2 2 0 1 0 2.829-2.829l-6.364-6.364a2 2 0 1 0-2.829 2.829l1.768 1.767a2 2 0 0 0-2.828 2.829z'), // key: 1t2c92
    DsIconPathElement('m9.6 14.4 4.8-4.8'), // key: 6umqxw
  ]);

  /// `ear-off.mjs`
  static const DsLucideGlyph earOff =
      DsLucideGlyph('ear-off', <DsIconElement>[
    DsIconPathElement('M6 18.5a3.5 3.5 0 1 0 7 0c0-1.57.92-2.52 2.04-3.46'), // key: 1qngmn
    DsIconPathElement('M6 8.5c0-.75.13-1.47.36-2.14'), // key: b06bma
    DsIconPathElement('M8.8 3.15A6.5 6.5 0 0 1 19 8.5c0 1.63-.44 2.81-1.09 3.76'), // key: g10hsz
    DsIconPathElement('M12.5 6A2.5 2.5 0 0 1 15 8.5M10 13a2 2 0 0 0 1.82-1.18'), // key: ygzou7
    DsIconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `ear.mjs`
  static const DsLucideGlyph ear =
      DsLucideGlyph('ear', <DsIconElement>[
    DsIconPathElement('M6 8.5a6.5 6.5 0 1 1 13 0c0 6-6 6-6 10a3.5 3.5 0 1 1-7 0'), // key: 1dfaln
    DsIconPathElement('M15 8.5a2.5 2.5 0 0 0-5 0v1a2 2 0 1 1 0 4'), // key: 1qnva7
  ]);

  /// `earth-lock.mjs`
  static const DsLucideGlyph earthLock =
      DsLucideGlyph('earth-lock', <DsIconElement>[
    DsIconPathElement('M7 3.34V5a3 3 0 0 0 3 3'), // key: w732o8
    DsIconPathElement('M11 21.95V18a2 2 0 0 0-2-2 2 2 0 0 1-2-2v-1a2 2 0 0 0-2-2H2.05'), // key: f02343
    DsIconPathElement('M21.54 15H17a2 2 0 0 0-2 2v4.54'), // key: 1djwo0
    DsIconPathElement('M12 2a10 10 0 1 0 9.54 13'), // key: zjsr6q
    DsIconPathElement('M20 6V4a2 2 0 1 0-4 0v2'), // key: 1of5e8
    DsIconRectElement(14, 6, 8, 5, 1), // key: 1fmf51
  ]);

  /// `earth.mjs`
  static const DsLucideGlyph earth =
      DsLucideGlyph('earth', <DsIconElement>[
    DsIconPathElement('M21.54 15H17a2 2 0 0 0-2 2v4.54'), // key: 1djwo0
    DsIconPathElement('M7 3.34V5a3 3 0 0 0 3 3a2 2 0 0 1 2 2c0 1.1.9 2 2 2a2 2 0 0 0 2-2c0-1.1.9-2 2-2h3.17'), // key: 1tzkfa
    DsIconPathElement('M11 21.95V18a2 2 0 0 0-2-2a2 2 0 0 1-2-2v-1a2 2 0 0 0-2-2H2.05'), // key: 14pb5j
    DsIconCircleElement(12, 12, 10), // key: 1mglay
  ]);

  /// `eclipse.mjs`
  static const DsLucideGlyph eclipse =
      DsLucideGlyph('eclipse', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M12 2a7 7 0 1 0 10 10'), // key: 1yuj32
  ]);

  /// `egg-fried.mjs`
  static const DsLucideGlyph eggFried =
      DsLucideGlyph('egg-fried', <DsIconElement>[
    DsIconCircleElement(11.5, 12.5, 3.5), // key: 1cl1mi
    DsIconPathElement('M3 8c0-3.5 2.5-6 6.5-6 5 0 4.83 3 7.5 5s5 2 5 6c0 4.5-2.5 6.5-7 6.5-2.5 0-2.5 2.5-6 2.5s-7-2-7-5.5c0-3 1.5-3 1.5-5C3.5 10 3 9 3 8Z'), // key: 165ef9
  ]);

  /// `egg-off.mjs`
  static const DsLucideGlyph eggOff =
      DsLucideGlyph('egg-off', <DsIconElement>[
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M20 14.347V14c0-6-4-12-8-12-1.078 0-2.157.436-3.157 1.19'), // key: 13g2jy
    DsIconPathElement('M6.206 6.21C4.871 8.4 4 11.2 4 14a8 8 0 0 0 14.568 4.568'), // key: 1581id
  ]);

  /// `egg.mjs`
  static const DsLucideGlyph egg =
      DsLucideGlyph('egg', <DsIconElement>[
    DsIconPathElement('M12 2C8 2 4 8 4 14a8 8 0 0 0 16 0c0-6-4-12-8-12'), // key: 1le142
  ]);

  /// `ellipse.mjs`
  static const DsLucideGlyph ellipse =
      DsLucideGlyph('ellipse', <DsIconElement>[
    DsIconEllipseElement(12, 12, 10, 6), // key: swdkt4
  ]);

  /// `ellipsis-vertical.mjs`
  static const DsLucideGlyph ellipsisVertical =
      DsLucideGlyph('ellipsis-vertical', <DsIconElement>[
    DsIconCircleElement(12, 12, 1), // key: 41hilf
    DsIconCircleElement(12, 5, 1), // key: gxeob9
    DsIconCircleElement(12, 19, 1), // key: lyex9k
  ]);

  /// `ellipsis.mjs`
  static const DsLucideGlyph ellipsis =
      DsLucideGlyph('ellipsis', <DsIconElement>[
    DsIconCircleElement(12, 12, 1), // key: 41hilf
    DsIconCircleElement(19, 12, 1), // key: 1wjl8i
    DsIconCircleElement(5, 12, 1), // key: 1pcz8c
  ]);

  /// `equal-approximately.mjs`
  static const DsLucideGlyph equalApproximately =
      DsLucideGlyph('equal-approximately', <DsIconElement>[
    DsIconPathElement('M5 15a6.5 6.5 0 0 1 7 0 6.5 6.5 0 0 0 7 0'), // key: yrdkhy
    DsIconPathElement('M5 9a6.5 6.5 0 0 1 7 0 6.5 6.5 0 0 0 7 0'), // key: gzkvyz
  ]);

  /// `equal-not.mjs`
  static const DsLucideGlyph equalNot =
      DsLucideGlyph('equal-not', <DsIconElement>[
    DsIconLineElement(5, 9, 19, 9), // key: 1nwqeh
    DsIconLineElement(5, 15, 19, 15), // key: g8yjpy
    DsIconLineElement(19, 5, 5, 19), // key: 1x9vlm
  ]);

  /// `equal.mjs`
  static const DsLucideGlyph equal =
      DsLucideGlyph('equal', <DsIconElement>[
    DsIconLineElement(5, 9, 19, 9), // key: 1nwqeh
    DsIconLineElement(5, 15, 19, 15), // key: g8yjpy
  ]);

  /// `eraser.mjs`
  static const DsLucideGlyph eraser =
      DsLucideGlyph('eraser', <DsIconElement>[
    DsIconPathElement('M21 21H8a2 2 0 0 1-1.42-.587l-3.994-3.999a2 2 0 0 1 0-2.828l10-10a2 2 0 0 1 2.829 0l5.999 6a2 2 0 0 1 0 2.828L12.834 21'), // key: g5wo59
    DsIconPathElement('m5.082 11.09 8.828 8.828'), // key: 1wx5vj
  ]);

  /// `ethernet-port.mjs`
  static const DsLucideGlyph ethernetPort =
      DsLucideGlyph('ethernet-port', <DsIconElement>[
    DsIconPathElement('M10 8v1'), // key: 1talb4
    DsIconPathElement('M14 8v1'), // key: 1rsfgr
    DsIconPathElement('M18 8v1'), // key: gnkwox
    DsIconPathElement('M19 17a2 2 0 00-1.765 1.059l-.47.882A2 2 0 0115 20H9a2 2 0 01-1.765-1.059l-.47-.882A2 2 0 005 17H4a2 2 0 01-2-2V6a2 2 0 012-2h16a2 2 0 012 2v9a2 2 0 01-2 2z'), // key: v5qa57
    DsIconPathElement('M6 8v1'), // key: 1636ez
  ]);

  /// `euro.mjs`
  static const DsLucideGlyph euro =
      DsLucideGlyph('euro', <DsIconElement>[
    DsIconPathElement('M4 10h12'), // key: 1y6xl8
    DsIconPathElement('M4 14h9'), // key: 1loblj
    DsIconPathElement('M19 6a7.7 7.7 0 0 0-5.2-2A7.9 7.9 0 0 0 6 12c0 4.4 3.5 8 7.8 8 2 0 3.8-.8 5.2-2'), // key: 1j6lzo
  ]);

  /// `ev-charger.mjs`
  static const DsLucideGlyph evCharger =
      DsLucideGlyph('ev-charger', <DsIconElement>[
    DsIconPathElement('M14 13h2a2 2 0 0 1 2 2v2a2 2 0 0 0 4 0v-6.998a2 2 0 0 0-.59-1.42L18 5'), // key: 1wtuz0
    DsIconPathElement('M14 21V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v16'), // key: e09ifn
    DsIconPathElement('M2 21h13'), // key: 1x0fut
    DsIconPathElement('M3 7h11'), // key: 19efrr
    DsIconPathElement('m9 11-2 3h3l-2 3'), // key: lmzxi1
  ]);

  /// `expand.mjs`
  static const DsLucideGlyph expand =
      DsLucideGlyph('expand', <DsIconElement>[
    DsIconPathElement('m15 15 6 6'), // key: 1s409w
    DsIconPathElement('m15 9 6-6'), // key: ko1vev
    DsIconPathElement('M21 16v5h-5'), // key: 1ck2sf
    DsIconPathElement('M21 8V3h-5'), // key: 1qoq8a
    DsIconPathElement('M3 16v5h5'), // key: 1t08am
    DsIconPathElement('m3 21 6-6'), // key: wwnumi
    DsIconPathElement('M3 8V3h5'), // key: 1ln10m
    DsIconPathElement('M9 9 3 3'), // key: v551iv
  ]);

  /// `external-link.mjs`
  static const DsLucideGlyph externalLink =
      DsLucideGlyph('external-link', <DsIconElement>[
    DsIconPathElement('M15 3h6v6'), // key: 1q9fwt
    DsIconPathElement('M10 14 21 3'), // key: gplh6r
    DsIconPathElement('M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6'), // key: a6xqqp
  ]);

  /// `eye-closed.mjs`
  static const DsLucideGlyph eyeClosed =
      DsLucideGlyph('eye-closed', <DsIconElement>[
    DsIconPathElement('m15 18-.722-3.25'), // key: 1j64jw
    DsIconPathElement('M2 8a10.645 10.645 0 0 0 20 0'), // key: 1e7gxb
    DsIconPathElement('m20 15-1.726-2.05'), // key: 1cnuld
    DsIconPathElement('m4 15 1.726-2.05'), // key: 1dsqqd
    DsIconPathElement('m9 18 .722-3.25'), // key: ypw2yx
  ]);

  /// `eye-dashed.mjs`
  static const DsLucideGlyph eyeDashed =
      DsLucideGlyph('eye-dashed', <DsIconElement>[
    DsIconPathElement('M13.054 18.946a11 11 0 0 1-2.11 0'), // key: 1lgjj0
    DsIconPathElement('M13.054 5.054a11 11 0 0 0-2.11-.001'), // key: f7voaa
    DsIconPathElement('M17.072 6.274a11 11 0 0 1 1.753 1.173'), // key: 1rga24
    DsIconPathElement('M18.825 16.552a11 11 0 0 1-1.753 1.174'), // key: jfvai2
    DsIconPathElement('M2.514 13.303a11 11 0 0 1-.452-.954 1 1 0 0 1 0-.697 11 11 0 0 1 .45-.955'), // key: 1deed4
    DsIconPathElement('M21.485 10.697a11 11 0 0 1 .453.955 1 1 0 0 1 0 .697 11 11 0 0 1-.453.954'), // key: 1k4xil
    DsIconPathElement('M5.173 7.448a11 11 0 0 1 1.753-1.174'), // key: mwd8rq
    DsIconPathElement('M6.926 17.726a11 11 0 0 1-1.753-1.174'), // key: 15rpim
    DsIconCircleElement(12, 12, 3), // key: 1v7zrd
  ]);

  /// `eye-off.mjs`
  static const DsLucideGlyph eyeOff =
      DsLucideGlyph('eye-off', <DsIconElement>[
    DsIconPathElement('M10.733 5.076a10.744 10.744 0 0 1 11.205 6.575 1 1 0 0 1 0 .696 10.747 10.747 0 0 1-1.444 2.49'), // key: ct8e1f
    DsIconPathElement('M14.084 14.158a3 3 0 0 1-4.242-4.242'), // key: 151rxh
    DsIconPathElement('M17.479 17.499a10.75 10.75 0 0 1-15.417-5.151 1 1 0 0 1 0-.696 10.75 10.75 0 0 1 4.446-5.143'), // key: 13bj9a
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `eye.mjs`
  static const DsLucideGlyph eye =
      DsLucideGlyph('eye', <DsIconElement>[
    DsIconPathElement('M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0'), // key: 1nclc0
    DsIconCircleElement(12, 12, 3), // key: 1v7zrd
  ]);

  /// `factory.mjs`
  static const DsLucideGlyph factory =
      DsLucideGlyph('factory', <DsIconElement>[
    DsIconPathElement('M12 16h.01'), // key: 1drbdi
    DsIconPathElement('M16 16h.01'), // key: 1f9h7w
    DsIconPathElement('M3 19a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V8.5a.5.5 0 0 0-.769-.422l-4.462 2.844A.5.5 0 0 1 15 10.5v-2a.5.5 0 0 0-.769-.422L9.77 10.922A.5.5 0 0 1 9 10.5V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2z'), // key: 1iv0i2
    DsIconPathElement('M8 16h.01'), // key: 18s6g9
  ]);

  /// `fan.mjs`
  static const DsLucideGlyph fan =
      DsLucideGlyph('fan', <DsIconElement>[
    DsIconPathElement('M10.827 16.379a6.082 6.082 0 0 1-8.618-7.002l5.412 1.45a6.082 6.082 0 0 1 7.002-8.618l-1.45 5.412a6.082 6.082 0 0 1 8.618 7.002l-5.412-1.45a6.082 6.082 0 0 1-7.002 8.618l1.45-5.412Z'), // key: 484a7f
    DsIconPathElement('M12 12v.01'), // key: u5ubse
  ]);

  /// `fast-forward.mjs`
  static const DsLucideGlyph fastForward =
      DsLucideGlyph('fast-forward', <DsIconElement>[
    DsIconPathElement('M12 6a2 2 0 0 1 3.414-1.414l6 6a2 2 0 0 1 0 2.828l-6 6A2 2 0 0 1 12 18z'), // key: b19h5q
    DsIconPathElement('M2 6a2 2 0 0 1 3.414-1.414l6 6a2 2 0 0 1 0 2.828l-6 6A2 2 0 0 1 2 18z'), // key: h7h5ge
  ]);

  /// `feather.mjs`
  static const DsLucideGlyph feather =
      DsLucideGlyph('feather', <DsIconElement>[
    DsIconPathElement('M14.086 18.412A2 2 0 0112.67 19H5v-7.672a2 2 0 01.586-1.414L11.75 3.75a6 6 0 118.49 8.49z'), // key: 1nq9jb
    DsIconPathElement('M16 8 2 22'), // key: vp34q
    DsIconPathElement('M17.488 15H9'), // key: 16yirz
  ]);

  /// `fence.mjs`
  static const DsLucideGlyph fence =
      DsLucideGlyph('fence', <DsIconElement>[
    DsIconPathElement('M4 3 2 5v15c0 .6.4 1 1 1h2c.6 0 1-.4 1-1V5Z'), // key: 1n2rgs
    DsIconPathElement('M6 8h4'), // key: utf9t1
    DsIconPathElement('M6 18h4'), // key: 12yh4b
    DsIconPathElement('m12 3-2 2v15c0 .6.4 1 1 1h2c.6 0 1-.4 1-1V5Z'), // key: 3ha7mj
    DsIconPathElement('M14 8h4'), // key: 1r8wg2
    DsIconPathElement('M14 18h4'), // key: 1t3kbu
    DsIconPathElement('m20 3-2 2v15c0 .6.4 1 1 1h2c.6 0 1-.4 1-1V5Z'), // key: dfd4e2
  ]);

  /// `ferris-wheel.mjs`
  static const DsLucideGlyph ferrisWheel =
      DsLucideGlyph('ferris-wheel', <DsIconElement>[
    DsIconCircleElement(12, 12, 2), // key: 1c9p78
    DsIconPathElement('M12 2v4'), // key: 3427ic
    DsIconPathElement('m6.8 15-3.5 2'), // key: hjy98k
    DsIconPathElement('m20.7 7-3.5 2'), // key: f08gto
    DsIconPathElement('M6.8 9 3.3 7'), // key: 1aevh4
    DsIconPathElement('m20.7 17-3.5-2'), // key: 1liqo3
    DsIconPathElement('m9 22 3-8 3 8'), // key: wees03
    DsIconPathElement('M8 22h8'), // key: rmew8v
    DsIconPathElement('M18 18.7a9 9 0 1 0-12 0'), // key: dhzg4g
  ]);

  /// `file-archive.mjs`
  static const DsLucideGlyph fileArchive =
      DsLucideGlyph('file-archive', <DsIconElement>[
    DsIconPathElement('M13.659 22H18a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v11.5'), // key: 4pqfef
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M8 12v-1'), // key: 1ej8lb
    DsIconPathElement('M8 18v-2'), // key: qcmpov
    DsIconPathElement('M8 7V6'), // key: 1nbb54
    DsIconCircleElement(8, 20, 2), // key: ckkr5m
  ]);

  /// `file-axis-3d.mjs`
  static const DsLucideGlyph fileAxis3d =
      DsLucideGlyph('file-axis-3d', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('m8 18 4-4'), // key: 12zab0
    DsIconPathElement('M8 10v8h8'), // key: tlaukw
  ]);

  /// `file-badge.mjs`
  static const DsLucideGlyph fileBadge =
      DsLucideGlyph('file-badge', <DsIconElement>[
    DsIconPathElement('M13 22h5a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v3.3'), // key: cvl1xm
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('m7.69 16.479 1.29 4.88a.5.5 0 0 1-.698.591l-1.843-.849a1 1 0 0 0-.879.001l-1.846.85a.5.5 0 0 1-.692-.593l1.29-4.88'), // key: 1ff7gj
    DsIconCircleElement(6, 14, 3), // key: a1xfv6
  ]);

  /// `file-box.mjs`
  static const DsLucideGlyph fileBox =
      DsLucideGlyph('file-box', <DsIconElement>[
    DsIconPathElement('M14 2v5a1 1 0 001 1h5'), // key: 9v5fu7
    DsIconPathElement('M14.692 22H18a2 2 0 002-2V8a2.4 2.4 0 00-.706-1.706l-3.588-3.588A2.4 2.4 0 0014 2H6a2 2 0 00-2 2v3.804'), // key: 1ne0j7
    DsIconPathElement('M2.264 13.752 7 16.5l4.737-2.748'), // key: t73mg3
    DsIconPathElement('M2.995 13.014A2 2 0 002 14.744v3.516a2 2 0 00.996 1.73l3 1.74a2 2 0 002.008 0l3-1.74A2 2 0 0012 18.26v-3.517a2 2 0 00-.995-1.73l-3-1.742a2 2 0 00-1.892-.064z'), // key: h4qck
    DsIconPathElement('M7 16.5V22'), // key: 1i1gou
  ]);

  /// `file-braces-corner.mjs`
  static const DsLucideGlyph fileBracesCorner =
      DsLucideGlyph('file-braces-corner', <DsIconElement>[
    DsIconPathElement('M14 22h4a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v6'), // key: 14cnrg
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M5 14a1 1 0 0 0-1 1v2a1 1 0 0 1-1 1 1 1 0 0 1 1 1v2a1 1 0 0 0 1 1'), // key: sr0ebq
    DsIconPathElement('M9 22a1 1 0 0 0 1-1v-2a1 1 0 0 1 1-1 1 1 0 0 1-1-1v-2a1 1 0 0 0-1-1'), // key: w793db
  ]);

  /// `file-braces.mjs`
  static const DsLucideGlyph fileBraces =
      DsLucideGlyph('file-braces', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M10 12a1 1 0 0 0-1 1v1a1 1 0 0 1-1 1 1 1 0 0 1 1 1v1a1 1 0 0 0 1 1'), // key: 1oajmo
    DsIconPathElement('M14 18a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1 1 1 0 0 1-1-1v-1a1 1 0 0 0-1-1'), // key: mpwhp6
  ]);

  /// `file-chart-column-increasing.mjs`
  static const DsLucideGlyph fileChartColumnIncreasing =
      DsLucideGlyph('file-chart-column-increasing', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M8 18v-2'), // key: qcmpov
    DsIconPathElement('M12 18v-4'), // key: q1q25u
    DsIconPathElement('M16 18v-6'), // key: 15y0np
  ]);

  /// `file-chart-column.mjs`
  static const DsLucideGlyph fileChartColumn =
      DsLucideGlyph('file-chart-column', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M8 18v-1'), // key: zg0ygc
    DsIconPathElement('M12 18v-6'), // key: 17g6i2
    DsIconPathElement('M16 18v-3'), // key: j5jt4h
  ]);

  /// `file-chart-line.mjs`
  static const DsLucideGlyph fileChartLine =
      DsLucideGlyph('file-chart-line', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('m16 13-3.5 3.5-2-2L8 17'), // key: zz7yod
  ]);

  /// `file-chart-pie.mjs`
  static const DsLucideGlyph fileChartPie =
      DsLucideGlyph('file-chart-pie', <DsIconElement>[
    DsIconPathElement('M15.941 22H18a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.704l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v3.512'), // key: 13hoie
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M4.017 11.512a6 6 0 1 0 8.466 8.475'), // key: s6vs5t
    DsIconPathElement('M9 16a1 1 0 0 1-1-1v-4c0-.552.45-1.008.995-.917a6 6 0 0 1 4.922 4.922c.091.544-.365.995-.917.995z'), // key: 1dl6s6
  ]);

  /// `file-check-corner.mjs`
  static const DsLucideGlyph fileCheckCorner =
      DsLucideGlyph('file-check-corner', <DsIconElement>[
    DsIconPathElement('M10.5 22H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v6'), // key: g5mvt7
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('m14 20 2 2 4-4'), // key: 15kota
  ]);

  /// `file-check.mjs`
  static const DsLucideGlyph fileCheck =
      DsLucideGlyph('file-check', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('m9 15 2 2 4-4'), // key: 1grp1n
  ]);

  /// `file-clock.mjs`
  static const DsLucideGlyph fileClock =
      DsLucideGlyph('file-clock', <DsIconElement>[
    DsIconPathElement('M16 22h2a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v2.85'), // key: ryk6xj
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M8 14v2.2l1.6 1'), // key: 6m4bie
    DsIconCircleElement(8, 16, 6), // key: 10v15b
  ]);

  /// `file-code-corner.mjs`
  static const DsLucideGlyph fileCodeCorner =
      DsLucideGlyph('file-code-corner', <DsIconElement>[
    DsIconPathElement('M4 12.15V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2h-3.35'), // key: 1wthlu
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('m5 16-3 3 3 3'), // key: 331omg
    DsIconPathElement('m9 22 3-3-3-3'), // key: lsp7cz
  ]);

  /// `file-code.mjs`
  static const DsLucideGlyph fileCode =
      DsLucideGlyph('file-code', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M10 12.5 8 15l2 2.5'), // key: 1tg20x
    DsIconPathElement('m14 12.5 2 2.5-2 2.5'), // key: yinavb
  ]);

  /// `file-cog.mjs`
  static const DsLucideGlyph fileCog =
      DsLucideGlyph('file-cog', <DsIconElement>[
    DsIconPathElement('M15 8a1 1 0 0 1-1-1V2a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8z'), // key: 1ckgky
    DsIconPathElement('M20 8v12a2 2 0 0 1-2 2h-4.182'), // key: 1726p0
    DsIconPathElement('m3.305 19.53.923-.382'), // key: ao1pio
    DsIconPathElement('M4 10.592V4a2 2 0 0 1 2-2h8'), // key: 1foop0
    DsIconPathElement('m4.228 16.852-.924-.383'), // key: 1fv9zy
    DsIconPathElement('m5.852 15.228-.383-.923'), // key: 1a9hc2
    DsIconPathElement('m5.852 20.772-.383.924'), // key: 1sh9ke
    DsIconPathElement('m8.148 15.228.383-.923'), // key: 4yu6lf
    DsIconPathElement('m8.53 21.696-.382-.924'), // key: 18b0s9
    DsIconPathElement('m9.773 16.852.922-.383'), // key: ti6xop
    DsIconPathElement('m9.773 19.148.922.383'), // key: rws47d
    DsIconCircleElement(7, 18, 3), // key: lvkj7j
  ]);

  /// `file-diff.mjs`
  static const DsLucideGlyph fileDiff =
      DsLucideGlyph('file-diff', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M9 10h6'), // key: 9gxzsh
    DsIconPathElement('M12 13V7'), // key: h0r20n
    DsIconPathElement('M9 17h6'), // key: r8uit2
  ]);

  /// `file-digit.mjs`
  static const DsLucideGlyph fileDigit =
      DsLucideGlyph('file-digit', <DsIconElement>[
    DsIconPathElement('M4 12V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2'), // key: jrl274
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M10 16h2v6'), // key: 1bxocy
    DsIconPathElement('M10 22h4'), // key: ceow96
    DsIconRectElement(2, 16, 4, 6, 2), // key: r45zd0
  ]);

  /// `file-down.mjs`
  static const DsLucideGlyph fileDown =
      DsLucideGlyph('file-down', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M12 18v-6'), // key: 17g6i2
    DsIconPathElement('m9 15 3 3 3-3'), // key: 1npd3o
  ]);

  /// `file-exclamation-point.mjs`
  static const DsLucideGlyph fileExclamationPoint =
      DsLucideGlyph('file-exclamation-point', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M12 9v4'), // key: juzpu7
    DsIconPathElement('M12 17h.01'), // key: p32p05
  ]);

  /// `file-headphone.mjs`
  static const DsLucideGlyph fileHeadphone =
      DsLucideGlyph('file-headphone', <DsIconElement>[
    DsIconPathElement('M4 6.835V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2h-.343'), // key: 1vfytu
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M2 19a2 2 0 0 1 4 0v1a2 2 0 0 1-4 0v-4a6 6 0 0 1 12 0v4a2 2 0 0 1-4 0v-1a2 2 0 0 1 4 0'), // key: 1etmh7
  ]);

  /// `file-heart.mjs`
  static const DsLucideGlyph fileHeart =
      DsLucideGlyph('file-heart', <DsIconElement>[
    DsIconPathElement('M13 22h5a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v7'), // key: oagw2b
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M3.62 18.8A2.25 2.25 0 1 1 7 15.836a2.25 2.25 0 1 1 3.38 2.966l-2.626 2.856a1 1 0 0 1-1.507 0z'), // key: rg3psg
  ]);

  /// `file-image.mjs`
  static const DsLucideGlyph fileImage =
      DsLucideGlyph('file-image', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconCircleElement(10, 12, 2), // key: 737tya
    DsIconPathElement('m20 17-1.296-1.296a2.41 2.41 0 0 0-3.408 0L9 22'), // key: wt3hpn
  ]);

  /// `file-input.mjs`
  static const DsLucideGlyph fileInput =
      DsLucideGlyph('file-input', <DsIconElement>[
    DsIconPathElement('M4 11V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-1'), // key: 1q9hii
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M2 15h10'), // key: jfw4w8
    DsIconPathElement('m9 18 3-3-3-3'), // key: 112psh
  ]);

  /// `file-key.mjs`
  static const DsLucideGlyph fileKey =
      DsLucideGlyph('file-key', <DsIconElement>[
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M4 12v6'), // key: bg1pfk
    DsIconPathElement('M4 14h2'), // key: 1sf9f8
    DsIconPathElement('M9.65 22H18a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v4'), // key: d56i0q
    DsIconCircleElement(4, 20, 2), // key: 6kqj1y
  ]);

  /// `file-lock.mjs`
  static const DsLucideGlyph fileLock =
      DsLucideGlyph('file-lock', <DsIconElement>[
    DsIconPathElement('M4 9.8V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2h-3'), // key: 1432pc
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M9 17v-2a2 2 0 0 0-4 0v2'), // key: 168m41
    DsIconRectElement(3, 17, 8, 5, 1), // key: o8vfew
  ]);

  /// `file-minus-corner.mjs`
  static const DsLucideGlyph fileMinusCorner =
      DsLucideGlyph('file-minus-corner', <DsIconElement>[
    DsIconPathElement('M20 14V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12'), // key: l9p8hp
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M14 18h6'), // key: 1m8k6r
  ]);

  /// `file-minus.mjs`
  static const DsLucideGlyph fileMinus =
      DsLucideGlyph('file-minus', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M9 15h6'), // key: cctwl0
  ]);

  /// `file-music.mjs`
  static const DsLucideGlyph fileMusic =
      DsLucideGlyph('file-music', <DsIconElement>[
    DsIconPathElement('M11.65 22H18a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v10.35'), // key: 5ad7z2
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M8 20v-7l3 1.474'), // key: 1ggyb9
    DsIconCircleElement(6, 20, 2), // key: j7wjp0
  ]);

  /// `file-output.mjs`
  static const DsLucideGlyph fileOutput =
      DsLucideGlyph('file-output', <DsIconElement>[
    DsIconPathElement('M4.226 20.925A2 2 0 0 0 6 22h12a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v3.127'), // key: wfxp4w
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('m5 11-3 3'), // key: 1dgrs4
    DsIconPathElement('m5 17-3-3h10'), // key: 1mvvaf
  ]);

  /// `file-pen-line.mjs`
  static const DsLucideGlyph filePenLine =
      DsLucideGlyph('file-pen-line', <DsIconElement>[
    DsIconPathElement('M14.364 13.634a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506l4.013-4.009a1 1 0 0 0-3.004-3.004z'), // key: ukzhwg
    DsIconPathElement('M14.487 7.858A1 1 0 0 1 14 7V2'), // key: 1klhew
    DsIconPathElement('M20 19.645V20a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l2.516 2.516'), // key: rxaxab
    DsIconPathElement('M8 18h1'), // key: 13wk12
  ]);

  /// `file-pen.mjs`
  static const DsLucideGlyph filePen =
      DsLucideGlyph('file-pen', <DsIconElement>[
    DsIconPathElement('M12.659 22H18a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v9.34'), // key: o6klzx
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M10.378 12.622a1 1 0 0 1 3 3.003L8.36 20.637a2 2 0 0 1-.854.506l-2.867.837a.5.5 0 0 1-.62-.62l.836-2.869a2 2 0 0 1 .506-.853z'), // key: zhnas1
  ]);

  /// `file-play.mjs`
  static const DsLucideGlyph filePlay =
      DsLucideGlyph('file-play', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M15.033 13.44a.647.647 0 0 1 0 1.12l-4.065 2.352a.645.645 0 0 1-.968-.56v-4.704a.645.645 0 0 1 .967-.56z'), // key: 1tzo1f
  ]);

  /// `file-plus-corner.mjs`
  static const DsLucideGlyph filePlusCorner =
      DsLucideGlyph('file-plus-corner', <DsIconElement>[
    DsIconPathElement('M11.35 22H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v5.35'), // key: 17jvcc
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M14 19h6'), // key: bvotb8
    DsIconPathElement('M17 16v6'), // key: 18yu1i
  ]);

  /// `file-plus.mjs`
  static const DsLucideGlyph filePlus =
      DsLucideGlyph('file-plus', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M9 15h6'), // key: cctwl0
    DsIconPathElement('M12 18v-6'), // key: 17g6i2
  ]);

  /// `file-question-mark.mjs`
  static const DsLucideGlyph fileQuestionMark =
      DsLucideGlyph('file-question-mark', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M12 17h.01'), // key: p32p05
    DsIconPathElement('M9.1 9a3 3 0 0 1 5.82 1c0 2-3 3-3 3'), // key: mhlwft
  ]);

  /// `file-scan.mjs`
  static const DsLucideGlyph fileScan =
      DsLucideGlyph('file-scan', <DsIconElement>[
    DsIconPathElement('M20 10V8a2.4 2.4 0 0 0-.706-1.704l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h4.35'), // key: 1cdjst
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M16 14a2 2 0 0 0-2 2'), // key: ceaadl
    DsIconPathElement('M16 22a2 2 0 0 1-2-2'), // key: 1wqh5n
    DsIconPathElement('M20 14a2 2 0 0 1 2 2'), // key: 1ny6zw
    DsIconPathElement('M20 22a2 2 0 0 0 2-2'), // key: 1l9q4k
  ]);

  /// `file-search-corner.mjs`
  static const DsLucideGlyph fileSearchCorner =
      DsLucideGlyph('file-search-corner', <DsIconElement>[
    DsIconPathElement('M11.1 22H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.589 3.588A2.4 2.4 0 0 1 20 8v3.25'), // key: uh4ikj
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('m21 22-2.88-2.88'), // key: 9dd25w
    DsIconCircleElement(16, 17, 3), // key: 11br10
  ]);

  /// `file-search.mjs`
  static const DsLucideGlyph fileSearch =
      DsLucideGlyph('file-search', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconCircleElement(11.5, 14.5, 2.5), // key: 1bq0ko
    DsIconPathElement('M13.3 16.3 15 18'), // key: 2quom7
  ]);

  /// `file-signal.mjs`
  static const DsLucideGlyph fileSignal =
      DsLucideGlyph('file-signal', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M8 15h.01'), // key: a7atzg
    DsIconPathElement('M11.5 13.5a2.5 2.5 0 0 1 0 3'), // key: 1fccat
    DsIconPathElement('M15 12a5 5 0 0 1 0 6'), // key: ps46cm
  ]);

  /// `file-sliders.mjs`
  static const DsLucideGlyph fileSliders =
      DsLucideGlyph('file-sliders', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M8 12h8'), // key: 1wcyev
    DsIconPathElement('M10 11v2'), // key: 1s651w
    DsIconPathElement('M8 17h8'), // key: wh5c61
    DsIconPathElement('M14 16v2'), // key: 12fp5e
  ]);

  /// `file-spreadsheet.mjs`
  static const DsLucideGlyph fileSpreadsheet =
      DsLucideGlyph('file-spreadsheet', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M8 13h2'), // key: yr2amv
    DsIconPathElement('M14 13h2'), // key: un5t4a
    DsIconPathElement('M8 17h2'), // key: 2yhykz
    DsIconPathElement('M14 17h2'), // key: 10kma7
  ]);

  /// `file-stack.mjs`
  static const DsLucideGlyph fileStack =
      DsLucideGlyph('file-stack', <DsIconElement>[
    DsIconPathElement('M11 21a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1v-8a1 1 0 0 1 1-1'), // key: likhh7
    DsIconPathElement('M16 16a1 1 0 0 1-1 1H9a1 1 0 0 1-1-1V8a1 1 0 0 1 1-1'), // key: 17ky3x
    DsIconPathElement('M21 6a2 2 0 0 0-.586-1.414l-2-2A2 2 0 0 0 17 2h-3a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1z'), // key: 1hyeo0
  ]);

  /// `file-symlink.mjs`
  static const DsLucideGlyph fileSymlink =
      DsLucideGlyph('file-symlink', <DsIconElement>[
    DsIconPathElement('M4 11V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h7'), // key: huwfnr
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('m10 18 3-3-3-3'), // key: 18f6ys
  ]);

  /// `file-terminal.mjs`
  static const DsLucideGlyph fileTerminal =
      DsLucideGlyph('file-terminal', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('m8 16 2-2-2-2'), // key: 10vzyd
    DsIconPathElement('M12 18h4'), // key: 1wd2n7
  ]);

  /// `file-text.mjs`
  static const DsLucideGlyph fileText =
      DsLucideGlyph('file-text', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M10 9H8'), // key: b1mrlr
    DsIconPathElement('M16 13H8'), // key: t4e002
    DsIconPathElement('M16 17H8'), // key: z1uh3a
  ]);

  /// `file-type-corner.mjs`
  static const DsLucideGlyph fileTypeCorner =
      DsLucideGlyph('file-type-corner', <DsIconElement>[
    DsIconPathElement('M12 22h6a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v6'), // key: 15usau
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M3 16v-1.5a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 .5.5V16'), // key: s1gz5
    DsIconPathElement('M6 22h2'), // key: 194x9m
    DsIconPathElement('M7 14v8'), // key: 11ixej
  ]);

  /// `file-type.mjs`
  static const DsLucideGlyph fileType =
      DsLucideGlyph('file-type', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M11 18h2'), // key: 12mj7e
    DsIconPathElement('M12 12v6'), // key: 3ahymv
    DsIconPathElement('M9 13v-.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 .5.5v.5'), // key: qbrxap
  ]);

  /// `file-up.mjs`
  static const DsLucideGlyph fileUp =
      DsLucideGlyph('file-up', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M12 12v6'), // key: 3ahymv
    DsIconPathElement('m15 15-3-3-3 3'), // key: 15xj92
  ]);

  /// `file-user.mjs`
  static const DsLucideGlyph fileUser =
      DsLucideGlyph('file-user', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M16 22a4 4 0 0 0-8 0'), // key: 7a83pg
    DsIconCircleElement(12, 15, 3), // key: g36mzq
  ]);

  /// `file-video-camera.mjs`
  static const DsLucideGlyph fileVideoCamera =
      DsLucideGlyph('file-video-camera', <DsIconElement>[
    DsIconPathElement('M4 12V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2'), // key: jrl274
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('m10 17.843 3.033-1.755a.64.64 0 0 1 .967.56v4.704a.65.65 0 0 1-.967.56L10 20.157'), // key: 17aeo9
    DsIconRectElement(3, 16, 7, 6, 1), // key: s27ndx
  ]);

  /// `file-volume.mjs`
  static const DsLucideGlyph fileVolume =
      DsLucideGlyph('file-volume', <DsIconElement>[
    DsIconPathElement('M4 11.55V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2h-1.95'), // key: 44gpjv
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M12 15a5 5 0 0 1 0 6'), // key: oxg87a
    DsIconPathElement('M8 14.502a.5.5 0 0 0-.826-.381l-1.893 1.631a1 1 0 0 1-.651.243H3.5a.5.5 0 0 0-.5.501v3.006a.5.5 0 0 0 .5.501h1.129a1 1 0 0 1 .652.243l1.893 1.633a.5.5 0 0 0 .826-.38z'), // key: 8rtoi1
  ]);

  /// `file-x-corner.mjs`
  static const DsLucideGlyph fileXCorner =
      DsLucideGlyph('file-x-corner', <DsIconElement>[
    DsIconPathElement('M11 22H6a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v5'), // key: 1jo35a
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('m15 17 5 5'), // key: 36xl1x
    DsIconPathElement('m20 17-5 5'), // key: vdz27y
  ]);

  /// `file-x.mjs`
  static const DsLucideGlyph fileX =
      DsLucideGlyph('file-x', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('m14.5 12.5-5 5'), // key: b62r18
    DsIconPathElement('m9.5 12.5 5 5'), // key: 1rk7el
  ]);

  /// `file.mjs`
  static const DsLucideGlyph file =
      DsLucideGlyph('file', <DsIconElement>[
    DsIconPathElement('M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z'), // key: 1oefj6
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
  ]);

  /// `files.mjs`
  static const DsLucideGlyph files =
      DsLucideGlyph('files', <DsIconElement>[
    DsIconPathElement('M15 2h-4a2 2 0 0 0-2 2v11a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V8'), // key: 14sh0y
    DsIconPathElement('M16.706 2.706A2.4 2.4 0 0 0 15 2v5a1 1 0 0 0 1 1h5a2.4 2.4 0 0 0-.706-1.706z'), // key: 1970lx
    DsIconPathElement('M5 7a2 2 0 0 0-2 2v11a2 2 0 0 0 2 2h8a2 2 0 0 0 1.732-1'), // key: l4dndm
  ]);

  /// `film.mjs`
  static const DsLucideGlyph film =
      DsLucideGlyph('film', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M7 3v18'), // key: bbkbws
    DsIconPathElement('M3 7.5h4'), // key: zfgn84
    DsIconPathElement('M3 12h18'), // key: 1i2n21
    DsIconPathElement('M3 16.5h4'), // key: 1230mu
    DsIconPathElement('M17 3v18'), // key: in4fa5
    DsIconPathElement('M17 7.5h4'), // key: myr1c1
    DsIconPathElement('M17 16.5h4'), // key: go4c1d
  ]);

  /// `fingerprint-pattern.mjs`
  static const DsLucideGlyph fingerprintPattern =
      DsLucideGlyph('fingerprint-pattern', <DsIconElement>[
    DsIconPathElement('M12 10a2 2 0 0 0-2 2c0 1.02-.1 2.51-.26 4'), // key: 1nerag
    DsIconPathElement('M14 13.12c0 2.38 0 6.38-1 8.88'), // key: o46ks0
    DsIconPathElement('M17.29 21.02c.12-.6.43-2.3.5-3.02'), // key: ptglia
    DsIconPathElement('M2 12a10 10 0 0 1 18-6'), // key: ydlgp0
    DsIconPathElement('M2 16h.01'), // key: 1gqxmh
    DsIconPathElement('M21.8 16c.2-2 .131-5.354 0-6'), // key: drycrb
    DsIconPathElement('M5 19.5C5.5 18 6 15 6 12a6 6 0 0 1 .34-2'), // key: 1tidbn
    DsIconPathElement('M8.65 22c.21-.66.45-1.32.57-2'), // key: 13wd9y
    DsIconPathElement('M9 6.8a6 6 0 0 1 9 5.2v2'), // key: 1fr1j5
  ]);

  /// `fire-extinguisher.mjs`
  static const DsLucideGlyph fireExtinguisher =
      DsLucideGlyph('fire-extinguisher', <DsIconElement>[
    DsIconPathElement('M15 6.5V3a1 1 0 0 0-1-1h-2a1 1 0 0 0-1 1v3.5'), // key: sqyvz
    DsIconPathElement('M9 18h8'), // key: i7pszb
    DsIconPathElement('M18 3h-3'), // key: 7idoqj
    DsIconPathElement('M11 3a6 6 0 0 0-6 6v11'), // key: 1v5je3
    DsIconPathElement('M5 13h4'), // key: svpcxo
    DsIconPathElement('M17 10a4 4 0 0 0-8 0v10a2 2 0 0 0 2 2h4a2 2 0 0 0 2-2Z'), // key: vsjego
  ]);

  /// `fish-off.mjs`
  static const DsLucideGlyph fishOff =
      DsLucideGlyph('fish-off', <DsIconElement>[
    DsIconPathElement('M18 12.47v.03m0-.5v.47m-.475 5.056A6.744 6.744 0 0 1 15 18c-3.56 0-7.56-2.53-8.5-6 .348-1.28 1.114-2.433 2.121-3.38m3.444-2.088A8.802 8.802 0 0 1 15 6c3.56 0 6.06 2.54 7 6-.309 1.14-.786 2.177-1.413 3.058'), // key: 1j1hse
    DsIconPathElement('M7 10.67C7 8 5.58 5.97 2.73 5.5c-1 1.5-1 5 .23 6.5-1.24 1.5-1.24 5-.23 6.5C5.58 18.03 7 16 7 13.33m7.48-4.372A9.77 9.77 0 0 1 16 6.07m0 11.86a9.77 9.77 0 0 1-1.728-3.618'), // key: 1q46z8
    DsIconPathElement('m16.01 17.93-.23 1.4A2 2 0 0 1 13.8 21H9.5a5.96 5.96 0 0 0 1.49-3.98M8.53 3h5.27a2 2 0 0 1 1.98 1.67l.23 1.4M2 2l20 20'), // key: 1407gh
  ]);

  /// `fish-symbol.mjs`
  static const DsLucideGlyph fishSymbol =
      DsLucideGlyph('fish-symbol', <DsIconElement>[
    DsIconPathElement('M2 16s9-15 20-4C11 23 2 8 2 8'), // key: h4oh4o
  ]);

  /// `fish.mjs`
  static const DsLucideGlyph fish =
      DsLucideGlyph('fish', <DsIconElement>[
    DsIconPathElement('M6.5 12c.94-3.46 4.94-6 8.5-6 3.56 0 6.06 2.54 7 6-.94 3.47-3.44 6-7 6s-7.56-2.53-8.5-6Z'), // key: 15baut
    DsIconPathElement('M18 12v.5'), // key: 18hhni
    DsIconPathElement('M16 17.93a9.77 9.77 0 0 1 0-11.86'), // key: 16dt7o
    DsIconPathElement('M7 10.67C7 8 5.58 5.97 2.73 5.5c-1 1.5-1 5 .23 6.5-1.24 1.5-1.24 5-.23 6.5C5.58 18.03 7 16 7 13.33'), // key: l9di03
    DsIconPathElement('M10.46 7.26C10.2 5.88 9.17 4.24 8 3h5.8a2 2 0 0 1 1.98 1.67l.23 1.4'), // key: 1kjonw
    DsIconPathElement('m16.01 17.93-.23 1.4A2 2 0 0 1 13.8 21H9.5a5.96 5.96 0 0 0 1.49-3.98'), // key: 1zlm23
  ]);

  /// `fishing-hook.mjs`
  static const DsLucideGlyph fishingHook =
      DsLucideGlyph('fishing-hook', <DsIconElement>[
    DsIconPathElement('m17.586 11.414-5.93 5.93a1 1 0 0 1-8-8l3.137-3.137a.707.707 0 0 1 1.207.5V10'), // key: 157y8s
    DsIconPathElement('M20.414 8.586 22 7'), // key: 5g2s34
    DsIconCircleElement(19, 10, 2), // key: 7363ft
  ]);

  /// `fishing-rod.mjs`
  static const DsLucideGlyph fishingRod =
      DsLucideGlyph('fishing-rod', <DsIconElement>[
    DsIconPathElement('M4 11h1'), // key: 13eipc
    DsIconPathElement('M8 15a2 2 0 0 1-4 0V3a1 1 0 0 1 1-1h.5C14 2 20 9 20 18v4'), // key: 1hs3im
    DsIconCircleElement(18, 18, 2), // key: 1emm8v
  ]);

  /// `flag-off.mjs`
  static const DsLucideGlyph flagOff =
      DsLucideGlyph('flag-off', <DsIconElement>[
    DsIconPathElement('M16 16c-3 0-5-2-8-2a6 6 0 0 0-4 1.528'), // key: 1q158e
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M4 22V4'), // key: 1plyxx
    DsIconPathElement('M7.656 2H8c3 0 5 2 7.333 2q2 0 3.067-.8A1 1 0 0 1 20 4v10.347'), // key: xj1b71
  ]);

  /// `flag-triangle-left.mjs`
  static const DsLucideGlyph flagTriangleLeft =
      DsLucideGlyph('flag-triangle-left', <DsIconElement>[
    DsIconPathElement('M18 22V2.8a.8.8 0 0 0-1.17-.71L5.45 7.78a.8.8 0 0 0 0 1.44L18 15.5'), // key: rbbtmw
  ]);

  /// `flag-triangle-right.mjs`
  static const DsLucideGlyph flagTriangleRight =
      DsLucideGlyph('flag-triangle-right', <DsIconElement>[
    DsIconPathElement('M6 22V2.8a.8.8 0 0 1 1.17-.71l11.38 5.69a.8.8 0 0 1 0 1.44L6 15.5'), // key: kfjsu0
  ]);

  /// `flag.mjs`
  static const DsLucideGlyph flag =
      DsLucideGlyph('flag', <DsIconElement>[
    DsIconPathElement('M4 22V4a1 1 0 0 1 .4-.8A6 6 0 0 1 8 2c3 0 5 2 7.333 2q2 0 3.067-.8A1 1 0 0 1 20 4v10a1 1 0 0 1-.4.8A6 6 0 0 1 16 16c-3 0-5-2-8-2a6 6 0 0 0-4 1.528'), // key: 1jaruq
  ]);

  /// `flame-kindling.mjs`
  static const DsLucideGlyph flameKindling =
      DsLucideGlyph('flame-kindling', <DsIconElement>[
    DsIconPathElement('M12 2c1 3 2.5 3.5 3.5 4.5A5 5 0 0 1 17 10a5 5 0 1 1-10 0c0-.3 0-.6.1-.9a2 2 0 1 0 3.3-2C8 4.5 11 2 12 2Z'), // key: 1ir223
    DsIconPathElement('m5 22 14-4'), // key: 1brv4h
    DsIconPathElement('m5 18 14 4'), // key: lgyyje
  ]);

  /// `flame.mjs`
  static const DsLucideGlyph flame =
      DsLucideGlyph('flame', <DsIconElement>[
    DsIconPathElement('M12 3q1 4 4 6.5t3 5.5a1 1 0 0 1-14 0 5 5 0 0 1 1-3 1 1 0 0 0 5 0c0-2-1.5-3-1.5-5q0-2 2.5-4'), // key: 1slcih
  ]);

  /// `flashlight-off.mjs`
  static const DsLucideGlyph flashlightOff =
      DsLucideGlyph('flashlight-off', <DsIconElement>[
    DsIconPathElement('M11.652 6H18'), // key: voqkpr
    DsIconPathElement('M12 13v1'), // key: 176q98
    DsIconPathElement('M16 16v4a2 2 0 0 1-2 2h-4a2 2 0 0 1-2-2v-8a4 4 0 0 0-.8-2.4l-.6-.8A3 3 0 0 1 6 7V6'), // key: dzyf92
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M7.649 2H17a1 1 0 0 1 1 1v4a3 3 0 0 1-.6 1.8l-.6.8a4 4 0 0 0-.55 1.007'), // key: 1hvcfn
  ]);

  /// `flashlight.mjs`
  static const DsLucideGlyph flashlight =
      DsLucideGlyph('flashlight', <DsIconElement>[
    DsIconPathElement('M12 13v1'), // key: 176q98
    DsIconPathElement('M17 2a1 1 0 0 1 1 1v4a3 3 0 0 1-.6 1.8l-.6.8A4 4 0 0 0 16 12v8a2 2 0 0 1-2 2H10a2 2 0 0 1-2-2v-8a4 4 0 0 0-.8-2.4l-.6-.8A3 3 0 0 1 6 7V3a1 1 0 0 1 1-1z'), // key: 17vh7j
    DsIconPathElement('M6 6h12'), // key: n6hhss
  ]);

  /// `flask-conical-off.mjs`
  static const DsLucideGlyph flaskConicalOff =
      DsLucideGlyph('flask-conical-off', <DsIconElement>[
    DsIconPathElement('M10 2v2.343'), // key: 15t272
    DsIconPathElement('M14 2v6.343'), // key: sxr80q
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M20 20a2 2 0 0 1-2 2H6a2 2 0 0 1-1.755-2.96l5.227-9.563'), // key: k0duyd
    DsIconPathElement('M6.453 15H15'), // key: 1f0z33
    DsIconPathElement('M8.5 2h7'), // key: csnxdl
  ]);

  /// `flask-conical.mjs`
  static const DsLucideGlyph flaskConical =
      DsLucideGlyph('flask-conical', <DsIconElement>[
    DsIconPathElement('M14 2v6a2 2 0 0 0 .245.96l5.51 10.08A2 2 0 0 1 18 22H6a2 2 0 0 1-1.755-2.96l5.51-10.08A2 2 0 0 0 10 8V2'), // key: 18mbvz
    DsIconPathElement('M6.453 15h11.094'), // key: 3shlmq
    DsIconPathElement('M8.5 2h7'), // key: csnxdl
  ]);

  /// `flask-round.mjs`
  static const DsLucideGlyph flaskRound =
      DsLucideGlyph('flask-round', <DsIconElement>[
    DsIconPathElement('M10 2v6.292a7 7 0 1 0 4 0V2'), // key: 1s42pc
    DsIconPathElement('M5 15h14'), // key: m0yey3
    DsIconPathElement('M8.5 2h7'), // key: csnxdl
  ]);

  /// `flip-horizontal-2.mjs`
  static const DsLucideGlyph flipHorizontal2 =
      DsLucideGlyph('flip-horizontal-2', <DsIconElement>[
    DsIconPathElement('m3 7 5 5-5 5V7'), // key: couhi7
    DsIconPathElement('m21 7-5 5 5 5V7'), // key: 6ouia7
    DsIconPathElement('M12 20v2'), // key: 1lh1kg
    DsIconPathElement('M12 14v2'), // key: 8jcxud
    DsIconPathElement('M12 8v2'), // key: 1woqiv
    DsIconPathElement('M12 2v2'), // key: tus03m
  ]);

  /// `flip-vertical-2.mjs`
  static const DsLucideGlyph flipVertical2 =
      DsLucideGlyph('flip-vertical-2', <DsIconElement>[
    DsIconPathElement('m17 3-5 5-5-5h10'), // key: 1ftt6x
    DsIconPathElement('m17 21-5-5-5 5h10'), // key: 1m0wmu
    DsIconPathElement('M4 12H2'), // key: rhcxmi
    DsIconPathElement('M10 12H8'), // key: s88cx1
    DsIconPathElement('M16 12h-2'), // key: 10asgb
    DsIconPathElement('M22 12h-2'), // key: 14jgyd
  ]);

  /// `flower-2.mjs`
  static const DsLucideGlyph flower2 =
      DsLucideGlyph('flower-2', <DsIconElement>[
    DsIconPathElement('M12 5a3 3 0 1 1 3 3m-3-3a3 3 0 1 0-3 3m3-3v1M9 8a3 3 0 1 0 3 3M9 8h1m5 0a3 3 0 1 1-3 3m3-3h-1m-2 3v-1'), // key: 3pnvol
    DsIconCircleElement(12, 8, 2), // key: 1822b1
    DsIconPathElement('M12 10v12'), // key: 6ubwww
    DsIconPathElement('M12 22c4.2 0 7-1.667 7-5-4.2 0-7 1.667-7 5Z'), // key: 9hd38g
    DsIconPathElement('M12 22c-4.2 0-7-1.667-7-5 4.2 0 7 1.667 7 5Z'), // key: ufn41s
  ]);

  /// `flower.mjs`
  static const DsLucideGlyph flower =
      DsLucideGlyph('flower', <DsIconElement>[
    DsIconCircleElement(12, 12, 3), // key: 1v7zrd
    DsIconPathElement('M12 16.5A4.5 4.5 0 1 1 7.5 12 4.5 4.5 0 1 1 12 7.5a4.5 4.5 0 1 1 4.5 4.5 4.5 4.5 0 1 1-4.5 4.5'), // key: 14wa3c
    DsIconPathElement('M12 7.5V9'), // key: 1oy5b0
    DsIconPathElement('M7.5 12H9'), // key: eltsq1
    DsIconPathElement('M16.5 12H15'), // key: vk5kw4
    DsIconPathElement('M12 16.5V15'), // key: k7eayi
    DsIconPathElement('m8 8 1.88 1.88'), // key: nxy4qf
    DsIconPathElement('M14.12 9.88 16 8'), // key: 1lst6k
    DsIconPathElement('m8 16 1.88-1.88'), // key: h2eex1
    DsIconPathElement('M14.12 14.12 16 16'), // key: uqkrx3
  ]);

  /// `focus.mjs`
  static const DsLucideGlyph focus =
      DsLucideGlyph('focus', <DsIconElement>[
    DsIconCircleElement(12, 12, 3), // key: 1v7zrd
    DsIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    DsIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    DsIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    DsIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
  ]);

  /// `fold-horizontal.mjs`
  static const DsLucideGlyph foldHorizontal =
      DsLucideGlyph('fold-horizontal', <DsIconElement>[
    DsIconPathElement('M2 12h6'), // key: 1wqiqv
    DsIconPathElement('M22 12h-6'), // key: 1eg9hc
    DsIconPathElement('M12 2v2'), // key: tus03m
    DsIconPathElement('M12 8v2'), // key: 1woqiv
    DsIconPathElement('M12 14v2'), // key: 8jcxud
    DsIconPathElement('M12 20v2'), // key: 1lh1kg
    DsIconPathElement('m19 9-3 3 3 3'), // key: 12ol22
    DsIconPathElement('m5 15 3-3-3-3'), // key: 1kdhjc
  ]);

  /// `fold-vertical.mjs`
  static const DsLucideGlyph foldVertical =
      DsLucideGlyph('fold-vertical', <DsIconElement>[
    DsIconPathElement('M12 22v-6'), // key: 6o8u61
    DsIconPathElement('M12 8V2'), // key: 1wkif3
    DsIconPathElement('M4 12H2'), // key: rhcxmi
    DsIconPathElement('M10 12H8'), // key: s88cx1
    DsIconPathElement('M16 12h-2'), // key: 10asgb
    DsIconPathElement('M22 12h-2'), // key: 14jgyd
    DsIconPathElement('m15 19-3-3-3 3'), // key: e37ymu
    DsIconPathElement('m15 5-3 3-3-3'), // key: 19d6lf
  ]);

  /// `folder-archive.mjs`
  static const DsLucideGlyph folderArchive =
      DsLucideGlyph('folder-archive', <DsIconElement>[
    DsIconCircleElement(15, 19, 2), // key: u2pros
    DsIconPathElement('M20.9 19.8A2 2 0 0 0 22 18V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2h5.1'), // key: 1jj40k
    DsIconPathElement('M15 11v-1'), // key: cntcp
    DsIconPathElement('M15 17v-2'), // key: 1279jj
  ]);

  /// `folder-bookmark.mjs`
  static const DsLucideGlyph folderBookmark =
      DsLucideGlyph('folder-bookmark', <DsIconElement>[
    DsIconPathElement('M12 6v8l3-3 3 3V6'), // key: 11pvqx
    DsIconPathElement('M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2z'), // key: 1u1bxd
  ]);

  /// `folder-check.mjs`
  static const DsLucideGlyph folderCheck =
      DsLucideGlyph('folder-check', <DsIconElement>[
    DsIconPathElement('M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z'), // key: 1kt360
    DsIconPathElement('m9 13 2 2 4-4'), // key: 6343dt
  ]);

  /// `folder-clock.mjs`
  static const DsLucideGlyph folderClock =
      DsLucideGlyph('folder-clock', <DsIconElement>[
    DsIconPathElement('M16 14v2.2l1.6 1'), // key: fo4ql5
    DsIconPathElement('M7 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2'), // key: 1urifu
    DsIconCircleElement(16, 16, 6), // key: qoo3c4
  ]);

  /// `folder-closed.mjs`
  static const DsLucideGlyph folderClosed =
      DsLucideGlyph('folder-closed', <DsIconElement>[
    DsIconPathElement('M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z'), // key: 1kt360
    DsIconPathElement('M2 10h20'), // key: 1ir3d8
  ]);

  /// `folder-code.mjs`
  static const DsLucideGlyph folderCode =
      DsLucideGlyph('folder-code', <DsIconElement>[
    DsIconPathElement('M10 10.5 8 13l2 2.5'), // key: m4t9c1
    DsIconPathElement('m14 10.5 2 2.5-2 2.5'), // key: 14w2eb
    DsIconPathElement('M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2z'), // key: 1u1bxd
  ]);

  /// `folder-cog.mjs`
  static const DsLucideGlyph folderCog =
      DsLucideGlyph('folder-cog', <DsIconElement>[
    DsIconPathElement('M10.3 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.98a2 2 0 0 1 1.69.9l.66 1.2A2 2 0 0 0 12 6h8a2 2 0 0 1 2 2v3.3'), // key: 128dxu
    DsIconPathElement('m14.305 19.53.923-.382'), // key: 3m78fa
    DsIconPathElement('m15.228 16.852-.923-.383'), // key: npixar
    DsIconPathElement('m16.852 15.228-.383-.923'), // key: 5xggr7
    DsIconPathElement('m16.852 20.772-.383.924'), // key: dpfhf9
    DsIconPathElement('m19.148 15.228.383-.923'), // key: 1reyyz
    DsIconPathElement('m19.53 21.696-.382-.924'), // key: 1goivc
    DsIconPathElement('m20.772 16.852.924-.383'), // key: htqkph
    DsIconPathElement('m20.772 19.148.924.383'), // key: 9w9pjp
    DsIconCircleElement(18, 18, 3), // key: 1xkwt0
  ]);

  /// `folder-dot.mjs`
  static const DsLucideGlyph folderDot =
      DsLucideGlyph('folder-dot', <DsIconElement>[
    DsIconPathElement('M4 20h16a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.93a2 2 0 0 1-1.66-.9l-.82-1.2A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13c0 1.1.9 2 2 2Z'), // key: 1fr9dc
    DsIconCircleElement(12, 13, 1), // key: 49l61u
  ]);

  /// `folder-down.mjs`
  static const DsLucideGlyph folderDown =
      DsLucideGlyph('folder-down', <DsIconElement>[
    DsIconPathElement('M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z'), // key: 1kt360
    DsIconPathElement('M12 10v6'), // key: 1bos4e
    DsIconPathElement('m15 13-3 3-3-3'), // key: 6j2sf0
  ]);

  /// `folder-git-2.mjs`
  static const DsLucideGlyph folderGit2 =
      DsLucideGlyph('folder-git-2', <DsIconElement>[
    DsIconPathElement('M18 19a5 5 0 0 1-5-5v8'), // key: sz5oeg
    DsIconPathElement('M9 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v5'), // key: 1w6njk
    DsIconCircleElement(13, 12, 2), // key: 1j92g6
    DsIconCircleElement(20, 19, 2), // key: 1obnsp
  ]);

  /// `folder-git.mjs`
  static const DsLucideGlyph folderGit =
      DsLucideGlyph('folder-git', <DsIconElement>[
    DsIconCircleElement(12, 13, 2), // key: 1c1ljs
    DsIconPathElement('M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z'), // key: 1kt360
    DsIconPathElement('M14 13h3'), // key: 1dgedf
    DsIconPathElement('M7 13h3'), // key: 1pygq7
  ]);

  /// `folder-heart.mjs`
  static const DsLucideGlyph folderHeart =
      DsLucideGlyph('folder-heart', <DsIconElement>[
    DsIconPathElement('M10.638 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v3.417'), // key: 10r6g4
    DsIconPathElement('M14.62 18.8A2.25 2.25 0 1 1 18 15.836a2.25 2.25 0 1 1 3.38 2.966l-2.626 2.856a.998.998 0 0 1-1.507 0z'), // key: 15cy7q
  ]);

  /// `folder-input.mjs`
  static const DsLucideGlyph folderInput =
      DsLucideGlyph('folder-input', <DsIconElement>[
    DsIconPathElement('M2 9V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-1'), // key: fm4g5t
    DsIconPathElement('M2 13h10'), // key: pgb2dq
    DsIconPathElement('m9 16 3-3-3-3'), // key: 6m91ic
  ]);

  /// `folder-kanban.mjs`
  static const DsLucideGlyph folderKanban =
      DsLucideGlyph('folder-kanban', <DsIconElement>[
    DsIconPathElement('M4 20h16a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.93a2 2 0 0 1-1.66-.9l-.82-1.2A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13c0 1.1.9 2 2 2Z'), // key: 1fr9dc
    DsIconPathElement('M8 10v4'), // key: tgpxqk
    DsIconPathElement('M12 10v2'), // key: hh53o1
    DsIconPathElement('M16 10v6'), // key: 1d6xys
  ]);

  /// `folder-key.mjs`
  static const DsLucideGlyph folderKey =
      DsLucideGlyph('folder-key', <DsIconElement>[
    DsIconPathElement('M13 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v1.36'), // key: 1shsnm
    DsIconPathElement('M19 12v6'), // key: kflna4
    DsIconPathElement('M19 14h2'), // key: wp2qbk
    DsIconCircleElement(19, 20, 2), // key: 1jfyz6
  ]);

  /// `folder-lock.mjs`
  static const DsLucideGlyph folderLock =
      DsLucideGlyph('folder-lock', <DsIconElement>[
    DsIconRectElement(14, 17, 8, 5, 1), // key: 19aais
    DsIconPathElement('M10 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v2.5'), // key: 1w6v7t
    DsIconPathElement('M20 17v-2a2 2 0 1 0-4 0v2'), // key: pwaxnr
  ]);

  /// `folder-minus.mjs`
  static const DsLucideGlyph folderMinus =
      DsLucideGlyph('folder-minus', <DsIconElement>[
    DsIconPathElement('M9 13h6'), // key: 1uhe8q
    DsIconPathElement('M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z'), // key: 1kt360
  ]);

  /// `folder-open-dot.mjs`
  static const DsLucideGlyph folderOpenDot =
      DsLucideGlyph('folder-open-dot', <DsIconElement>[
    DsIconPathElement('m6 14 1.45-2.9A2 2 0 0 1 9.24 10H20a2 2 0 0 1 1.94 2.5l-1.55 6a2 2 0 0 1-1.94 1.5H4a2 2 0 0 1-2-2V5c0-1.1.9-2 2-2h3.93a2 2 0 0 1 1.66.9l.82 1.2a2 2 0 0 0 1.66.9H18a2 2 0 0 1 2 2v2'), // key: 1nmvlm
    DsIconCircleElement(14, 15, 1), // key: 1gm4qj
  ]);

  /// `folder-open.mjs`
  static const DsLucideGlyph folderOpen =
      DsLucideGlyph('folder-open', <DsIconElement>[
    DsIconPathElement('m6 14 1.5-2.9A2 2 0 0 1 9.24 10H20a2 2 0 0 1 1.94 2.5l-1.54 6a2 2 0 0 1-1.95 1.5H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H18a2 2 0 0 1 2 2v2'), // key: usdka0
  ]);

  /// `folder-output.mjs`
  static const DsLucideGlyph folderOutput =
      DsLucideGlyph('folder-output', <DsIconElement>[
    DsIconPathElement('M2 7.5V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-1.5'), // key: 1yk7aj
    DsIconPathElement('M2 13h10'), // key: pgb2dq
    DsIconPathElement('m5 10-3 3 3 3'), // key: 1r8ie0
  ]);

  /// `folder-pen.mjs`
  static const DsLucideGlyph folderPen =
      DsLucideGlyph('folder-pen', <DsIconElement>[
    DsIconPathElement('M2 11.5V5a2 2 0 0 1 2-2h3.9c.7 0 1.3.3 1.7.9l.8 1.2c.4.6 1 .9 1.7.9H20a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-9.5'), // key: a8xqs0
    DsIconPathElement('M11.378 13.626a1 1 0 1 0-3.004-3.004l-5.01 5.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z'), // key: 1saktj
  ]);

  /// `folder-plus.mjs`
  static const DsLucideGlyph folderPlus =
      DsLucideGlyph('folder-plus', <DsIconElement>[
    DsIconPathElement('M12 10v6'), // key: 1bos4e
    DsIconPathElement('M9 13h6'), // key: 1uhe8q
    DsIconPathElement('M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z'), // key: 1kt360
  ]);

  /// `folder-root.mjs`
  static const DsLucideGlyph folderRoot =
      DsLucideGlyph('folder-root', <DsIconElement>[
    DsIconPathElement('M4 20h16a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.93a2 2 0 0 1-1.66-.9l-.82-1.2A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13c0 1.1.9 2 2 2Z'), // key: 1fr9dc
    DsIconCircleElement(12, 13, 2), // key: 1c1ljs
    DsIconPathElement('M12 15v5'), // key: 11xva1
  ]);

  /// `folder-search-2.mjs`
  static const DsLucideGlyph folderSearch2 =
      DsLucideGlyph('folder-search-2', <DsIconElement>[
    DsIconCircleElement(11.5, 12.5, 2.5), // key: 1ea5ju
    DsIconPathElement('M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z'), // key: 1kt360
    DsIconPathElement('M13.3 14.3 15 16'), // key: 1y4v1n
  ]);

  /// `folder-search.mjs`
  static const DsLucideGlyph folderSearch =
      DsLucideGlyph('folder-search', <DsIconElement>[
    DsIconPathElement('M10.7 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v4.1'), // key: 1bw5m7
    DsIconPathElement('m21 21-1.9-1.9'), // key: 1g2n9r
    DsIconCircleElement(17, 17, 3), // key: 18b49y
  ]);

  /// `folder-symlink.mjs`
  static const DsLucideGlyph folderSymlink =
      DsLucideGlyph('folder-symlink', <DsIconElement>[
    DsIconPathElement('M2 9.35V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h7'), // key: y8kt7d
    DsIconPathElement('m8 16 3-3-3-3'), // key: rlqrt1
  ]);

  /// `folder-sync.mjs`
  static const DsLucideGlyph folderSync =
      DsLucideGlyph('folder-sync', <DsIconElement>[
    DsIconPathElement('M9 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v.5'), // key: 1dkoa9
    DsIconPathElement('M12 10v4h4'), // key: 1czhmt
    DsIconPathElement('m12 14 1.535-1.605a5 5 0 0 1 8 1.5'), // key: lvuxfi
    DsIconPathElement('M22 22v-4h-4'), // key: 1ewp4q
    DsIconPathElement('m22 18-1.535 1.605a5 5 0 0 1-8-1.5'), // key: 14ync0
  ]);

  /// `folder-tree.mjs`
  static const DsLucideGlyph folderTree =
      DsLucideGlyph('folder-tree', <DsIconElement>[
    DsIconPathElement('M20 10a1 1 0 0 0 1-1V6a1 1 0 0 0-1-1h-2.5a1 1 0 0 1-.8-.4l-.9-1.2A1 1 0 0 0 15 3h-2a1 1 0 0 0-1 1v5a1 1 0 0 0 1 1Z'), // key: hod4my
    DsIconPathElement('M20 21a1 1 0 0 0 1-1v-3a1 1 0 0 0-1-1h-2.9a1 1 0 0 1-.88-.55l-.42-.85a1 1 0 0 0-.92-.6H13a1 1 0 0 0-1 1v5a1 1 0 0 0 1 1Z'), // key: w4yl2u
    DsIconPathElement('M3 5a2 2 0 0 0 2 2h3'), // key: f2jnh7
    DsIconPathElement('M3 3v13a2 2 0 0 0 2 2h3'), // key: k8epm1
  ]);

  /// `folder-up.mjs`
  static const DsLucideGlyph folderUp =
      DsLucideGlyph('folder-up', <DsIconElement>[
    DsIconPathElement('M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z'), // key: 1kt360
    DsIconPathElement('M12 10v6'), // key: 1bos4e
    DsIconPathElement('m9 13 3-3 3 3'), // key: 1pxg3c
  ]);

  /// `folder-x.mjs`
  static const DsLucideGlyph folderX =
      DsLucideGlyph('folder-x', <DsIconElement>[
    DsIconPathElement('M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z'), // key: 1kt360
    DsIconPathElement('m9.5 10.5 5 5'), // key: ra9qjz
    DsIconPathElement('m14.5 10.5-5 5'), // key: l2rkpq
  ]);

  /// `folder.mjs`
  static const DsLucideGlyph folder =
      DsLucideGlyph('folder', <DsIconElement>[
    DsIconPathElement('M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z'), // key: 1kt360
  ]);

  /// `folders.mjs`
  static const DsLucideGlyph folders =
      DsLucideGlyph('folders', <DsIconElement>[
    DsIconPathElement('M20 5a2 2 0 0 1 2 2v7a2 2 0 0 1-2 2H9a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h2.5a1.5 1.5 0 0 1 1.2.6l.6.8a1.5 1.5 0 0 0 1.2.6z'), // key: a4852j
    DsIconPathElement('M3 8.268a2 2 0 0 0-1 1.738V19a2 2 0 0 0 2 2h11a2 2 0 0 0 1.732-1'), // key: yxbcw3
  ]);

  /// `footprints.mjs`
  static const DsLucideGlyph footprints =
      DsLucideGlyph('footprints', <DsIconElement>[
    DsIconPathElement('M4 16v-2.38C4 11.5 2.97 10.5 3 8c.03-2.72 1.49-6 4.5-6C9.37 2 10 3.8 10 5.5c0 3.11-2 5.66-2 8.68V16a2 2 0 1 1-4 0Z'), // key: 1dudjm
    DsIconPathElement('M20 20v-2.38c0-2.12 1.03-3.12 1-5.62-.03-2.72-1.49-6-4.5-6C14.63 6 14 7.8 14 9.5c0 3.11 2 5.66 2 8.68V20a2 2 0 1 0 4 0Z'), // key: l2t8xc
    DsIconPathElement('M16 17h4'), // key: 1dejxt
    DsIconPathElement('M4 13h4'), // key: 1bwh8b
  ]);

  /// `forklift.mjs`
  static const DsLucideGlyph forklift =
      DsLucideGlyph('forklift', <DsIconElement>[
    DsIconPathElement('M12 12H5a2 2 0 0 0-2 2v5'), // key: 7zsz91
    DsIconPathElement('M15 19h7'), // key: 1askl3
    DsIconPathElement('M16 19V2'), // key: 1gf9nk
    DsIconPathElement('M6 12V7a2 2 0 0 1 2-2h2.172a2 2 0 0 1 1.414.586l3.828 3.828A2 2 0 0 1 16 10.828'), // key: enx9tf
    DsIconPathElement('M7 19h4'), // key: fumhkk
    DsIconCircleElement(13, 19, 2), // key: wjnkru
    DsIconCircleElement(5, 19, 2), // key: v8kfzx
  ]);

  /// `form.mjs`
  static const DsLucideGlyph form =
      DsLucideGlyph('form', <DsIconElement>[
    DsIconPathElement('M4 14h6'), // key: 77gv2w
    DsIconPathElement('M4 2h10'), // key: a2b314
    DsIconRectElement(4, 18, 16, 4, 1), // key: sybzq6
    DsIconRectElement(4, 6, 16, 4, 1), // key: 1osc9e
  ]);

  /// `forward.mjs`
  static const DsLucideGlyph forward =
      DsLucideGlyph('forward', <DsIconElement>[
    DsIconPathElement('m15 17 5-5-5-5'), // key: nf172w
    DsIconPathElement('M4 18v-2a4 4 0 0 1 4-4h12'), // key: jmiej9
  ]);

  /// `frame.mjs`
  static const DsLucideGlyph frame =
      DsLucideGlyph('frame', <DsIconElement>[
    DsIconLineElement(22, 6, 2, 6), // key: 15w7dq
    DsIconLineElement(22, 18, 2, 18), // key: 1ip48p
    DsIconLineElement(6, 2, 6, 22), // key: a2lnyx
    DsIconLineElement(18, 2, 18, 22), // key: 8vb6jd
  ]);

  /// `frown.mjs`
  static const DsLucideGlyph frown =
      DsLucideGlyph('frown', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M16 16s-1.5-2-4-2-4 2-4 2'), // key: epbg0q
    DsIconLineElement(9, 9, 9.01, 9), // key: yxxnd0
    DsIconLineElement(15, 9, 15.01, 9), // key: 1p4y9e
  ]);

  /// `fuel.mjs`
  static const DsLucideGlyph fuel =
      DsLucideGlyph('fuel', <DsIconElement>[
    DsIconPathElement('M14 13h2a2 2 0 0 1 2 2v2a2 2 0 0 0 4 0v-6.998a2 2 0 0 0-.59-1.42L18 5'), // key: 1wtuz0
    DsIconPathElement('M14 21V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v16'), // key: e09ifn
    DsIconPathElement('M2 21h13'), // key: 1x0fut
    DsIconPathElement('M3 9h11'), // key: 1p7c0w
  ]);

  /// `fullscreen.mjs`
  static const DsLucideGlyph fullscreen =
      DsLucideGlyph('fullscreen', <DsIconElement>[
    DsIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    DsIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    DsIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    DsIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
    DsIconRectElement(7, 8, 10, 8, 1), // key: vys8me
  ]);

  /// `funnel-plus.mjs`
  static const DsLucideGlyph funnelPlus =
      DsLucideGlyph('funnel-plus', <DsIconElement>[
    DsIconPathElement('M13.354 3H3a1 1 0 0 0-.742 1.67l7.225 7.989A2 2 0 0 1 10 14v6a1 1 0 0 0 .553.895l2 1A1 1 0 0 0 14 21v-7a2 2 0 0 1 .517-1.341l1.218-1.348'), // key: 8mvsmf
    DsIconPathElement('M16 6h6'), // key: 1dogtp
    DsIconPathElement('M19 3v6'), // key: 1ytpjt
  ]);

  /// `funnel-x.mjs`
  static const DsLucideGlyph funnelX =
      DsLucideGlyph('funnel-x', <DsIconElement>[
    DsIconPathElement('M12.531 3H3a1 1 0 0 0-.742 1.67l7.225 7.989A2 2 0 0 1 10 14v6a1 1 0 0 0 .553.895l2 1A1 1 0 0 0 14 21v-7a2 2 0 0 1 .517-1.341l.427-.473'), // key: ol2ft2
    DsIconPathElement('m16.5 3.5 5 5'), // key: 15e6fa
    DsIconPathElement('m21.5 3.5-5 5'), // key: m0lwru
  ]);

  /// `funnel.mjs`
  static const DsLucideGlyph funnel =
      DsLucideGlyph('funnel', <DsIconElement>[
    DsIconPathElement('M10 20a1 1 0 0 0 .553.895l2 1A1 1 0 0 0 14 21v-7a2 2 0 0 1 .517-1.341L21.74 4.67A1 1 0 0 0 21 3H3a1 1 0 0 0-.742 1.67l7.225 7.989A2 2 0 0 1 10 14z'), // key: sc7q7i
  ]);

  /// `gallery-horizontal-end.mjs`
  static const DsLucideGlyph galleryHorizontalEnd =
      DsLucideGlyph('gallery-horizontal-end', <DsIconElement>[
    DsIconPathElement('M2 7v10'), // key: a2pl2d
    DsIconPathElement('M6 5v14'), // key: 1kq3d7
    DsIconRectElement(10, 3, 12, 18, 2), // key: 13i7bc
  ]);

  /// `gallery-horizontal.mjs`
  static const DsLucideGlyph galleryHorizontal =
      DsLucideGlyph('gallery-horizontal', <DsIconElement>[
    DsIconPathElement('M2 3v18'), // key: pzttux
    DsIconRectElement(6, 3, 12, 18, 2), // key: btr8bg
    DsIconPathElement('M22 3v18'), // key: 6jf3v
  ]);

  /// `gallery-thumbnails.mjs`
  static const DsLucideGlyph galleryThumbnails =
      DsLucideGlyph('gallery-thumbnails', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 14, 2), // key: 74y24f
    DsIconPathElement('M4 21h1'), // key: 16zlid
    DsIconPathElement('M9 21h1'), // key: 15o7lz
    DsIconPathElement('M14 21h1'), // key: v9vybs
    DsIconPathElement('M19 21h1'), // key: edywat
  ]);

  /// `gallery-vertical-end.mjs`
  static const DsLucideGlyph galleryVerticalEnd =
      DsLucideGlyph('gallery-vertical-end', <DsIconElement>[
    DsIconPathElement('M7 2h10'), // key: nczekb
    DsIconPathElement('M5 6h14'), // key: u2x4p
    DsIconRectElement(3, 10, 18, 12, 2), // key: l0tzu3
  ]);

  /// `gallery-vertical.mjs`
  static const DsLucideGlyph galleryVertical =
      DsLucideGlyph('gallery-vertical', <DsIconElement>[
    DsIconPathElement('M3 2h18'), // key: 15qxfx
    DsIconRectElement(3, 6, 18, 12, 2), // key: 1439r6
    DsIconPathElement('M3 22h18'), // key: 8prr45
  ]);

  /// `gamepad-2.mjs`
  static const DsLucideGlyph gamepad2 =
      DsLucideGlyph('gamepad-2', <DsIconElement>[
    DsIconLineElement(6, 11, 10, 11), // key: 1gktln
    DsIconLineElement(8, 9, 8, 13), // key: qnk9ow
    DsIconLineElement(15, 12, 15.01, 12), // key: krot7o
    DsIconLineElement(18, 10, 18.01, 10), // key: 1lcuu1
    DsIconPathElement('M17.32 5H6.68a4 4 0 0 0-3.978 3.59c-.006.052-.01.101-.017.152C2.604 9.416 2 14.456 2 16a3 3 0 0 0 3 3c1 0 1.5-.5 2-1l1.414-1.414A2 2 0 0 1 9.828 16h4.344a2 2 0 0 1 1.414.586L17 18c.5.5 1 1 2 1a3 3 0 0 0 3-3c0-1.545-.604-6.584-.685-7.258-.007-.05-.011-.1-.017-.151A4 4 0 0 0 17.32 5z'), // key: mfqc10
  ]);

  /// `gamepad-directional.mjs`
  static const DsLucideGlyph gamepadDirectional =
      DsLucideGlyph('gamepad-directional', <DsIconElement>[
    DsIconPathElement('M11.146 15.854a1.207 1.207 0 0 1 1.708 0l1.56 1.56A2 2 0 0 1 15 18.828V21a1 1 0 0 1-1 1h-4a1 1 0 0 1-1-1v-2.172a2 2 0 0 1 .586-1.414z'), // key: 1re2og
    DsIconPathElement('M18.828 15a2 2 0 0 1-1.414-.586l-1.56-1.56a1.207 1.207 0 0 1 0-1.708l1.56-1.56A2 2 0 0 1 18.828 9H21a1 1 0 0 1 1 1v4a1 1 0 0 1-1 1z'), // key: 1pchrj
    DsIconPathElement('M6.586 14.414A2 2 0 0 1 5.172 15H3a1 1 0 0 1-1-1v-4a1 1 0 0 1 1-1h2.172a2 2 0 0 1 1.414.586l1.56 1.56a1.207 1.207 0 0 1 0 1.708z'), // key: 16mt4c
    DsIconPathElement('M9 3a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2.172a2 2 0 0 1-.586 1.414l-1.56 1.56a1.207 1.207 0 0 1-1.708 0l-1.56-1.56A2 2 0 0 1 9 5.172z'), // key: 19ox6c
  ]);

  /// `gamepad.mjs`
  static const DsLucideGlyph gamepad =
      DsLucideGlyph('gamepad', <DsIconElement>[
    DsIconLineElement(6, 12, 10, 12), // key: 161bw2
    DsIconLineElement(8, 10, 8, 14), // key: 1i6ji0
    DsIconLineElement(15, 13, 15.01, 13), // key: dqpgro
    DsIconLineElement(18, 11, 18.01, 11), // key: meh2c
    DsIconRectElement(2, 6, 20, 12, 2), // key: 9lu3g6
  ]);

  /// `gauge.mjs`
  static const DsLucideGlyph gauge =
      DsLucideGlyph('gauge', <DsIconElement>[
    DsIconPathElement('m12 14 4-4'), // key: 9kzdfg
    DsIconPathElement('M3.34 19a10 10 0 1 1 17.32 0'), // key: 19p75a
  ]);

  /// `gavel.mjs`
  static const DsLucideGlyph gavel =
      DsLucideGlyph('gavel', <DsIconElement>[
    DsIconPathElement('m14 13-8.381 8.38a1 1 0 0 1-3.001-3l8.384-8.381'), // key: pgg06f
    DsIconPathElement('m16 16 6-6'), // key: vzrcl6
    DsIconPathElement('m21.5 10.5-8-8'), // key: a17d9x
    DsIconPathElement('m8 8 6-6'), // key: 18bi4p
    DsIconPathElement('m8.5 7.5 8 8'), // key: 1oyaui
  ]);

  /// `gem.mjs`
  static const DsLucideGlyph gem =
      DsLucideGlyph('gem', <DsIconElement>[
    DsIconPathElement('M10.5 3 8 9l4 13 4-13-2.5-6'), // key: b3dvk1
    DsIconPathElement('M17 3a2 2 0 0 1 1.6.8l3 4a2 2 0 0 1 .013 2.382l-7.99 10.986a2 2 0 0 1-3.247 0l-7.99-10.986A2 2 0 0 1 2.4 7.8l2.998-3.997A2 2 0 0 1 7 3z'), // key: 7w4byz
    DsIconPathElement('M2 9h20'), // key: 16fsjt
  ]);

  /// `georgian-lari.mjs`
  static const DsLucideGlyph georgianLari =
      DsLucideGlyph('georgian-lari', <DsIconElement>[
    DsIconPathElement('M11.5 21a7.5 7.5 0 1 1 7.35-9'), // key: 1gyj8k
    DsIconPathElement('M13 12V3'), // key: 18om2a
    DsIconPathElement('M4 21h16'), // key: 1h09gz
    DsIconPathElement('M9 12V3'), // key: geutu0
  ]);

  /// `ghost.mjs`
  static const DsLucideGlyph ghost =
      DsLucideGlyph('ghost', <DsIconElement>[
    DsIconPathElement('M9 10h.01'), // key: qbtxuw
    DsIconPathElement('M15 10h.01'), // key: 1qmjsl
    DsIconPathElement('M12 2a8 8 0 0 0-8 8v12l3-3 2.5 2.5L12 19l2.5 2.5L17 19l3 3V10a8 8 0 0 0-8-8z'), // key: uwwb07
  ]);

  /// `gift.mjs`
  static const DsLucideGlyph gift =
      DsLucideGlyph('gift', <DsIconElement>[
    DsIconPathElement('M12 7v14'), // key: 1akyts
    DsIconPathElement('M20 11v8a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-8'), // key: 1sqzm4
    DsIconPathElement('M7.5 7a1 1 0 0 1 0-5A4.8 8 0 0 1 12 7a4.8 8 0 0 1 4.5-5 1 1 0 0 1 0 5'), // key: kc0143
    DsIconRectElement(3, 7, 18, 4, 1), // key: 1hberx
  ]);

  /// `git-branch-minus.mjs`
  static const DsLucideGlyph gitBranchMinus =
      DsLucideGlyph('git-branch-minus', <DsIconElement>[
    DsIconPathElement('M15 6a9 9 0 0 0-9 9V3'), // key: 1cii5b
    DsIconPathElement('M21 18h-6'), // key: 139f0c
    DsIconCircleElement(18, 6, 3), // key: 1h7g24
    DsIconCircleElement(6, 18, 3), // key: fqmcym
  ]);

  /// `git-branch-plus.mjs`
  static const DsLucideGlyph gitBranchPlus =
      DsLucideGlyph('git-branch-plus', <DsIconElement>[
    DsIconPathElement('M6 3v12'), // key: qpgusn
    DsIconPathElement('M18 9a3 3 0 1 0 0-6 3 3 0 0 0 0 6z'), // key: 1d02ji
    DsIconPathElement('M6 21a3 3 0 1 0 0-6 3 3 0 0 0 0 6z'), // key: chk6ph
    DsIconPathElement('M15 6a9 9 0 0 0-9 9'), // key: or332x
    DsIconPathElement('M18 15v6'), // key: 9wciyi
    DsIconPathElement('M21 18h-6'), // key: 139f0c
  ]);

  /// `git-branch.mjs`
  static const DsLucideGlyph gitBranch =
      DsLucideGlyph('git-branch', <DsIconElement>[
    DsIconPathElement('M15 6a9 9 0 0 0-9 9V3'), // key: 1cii5b
    DsIconCircleElement(18, 6, 3), // key: 1h7g24
    DsIconCircleElement(6, 18, 3), // key: fqmcym
  ]);

  /// `git-commit-horizontal.mjs`
  static const DsLucideGlyph gitCommitHorizontal =
      DsLucideGlyph('git-commit-horizontal', <DsIconElement>[
    DsIconCircleElement(12, 12, 3), // key: 1v7zrd
    DsIconLineElement(3, 12, 9, 12), // key: 1dyftd
    DsIconLineElement(15, 12, 21, 12), // key: oup4p8
  ]);

  /// `git-commit-vertical.mjs`
  static const DsLucideGlyph gitCommitVertical =
      DsLucideGlyph('git-commit-vertical', <DsIconElement>[
    DsIconPathElement('M12 3v6'), // key: 1holv5
    DsIconCircleElement(12, 12, 3), // key: 1v7zrd
    DsIconPathElement('M12 15v6'), // key: a9ows0
  ]);

  /// `git-compare-arrows.mjs`
  static const DsLucideGlyph gitCompareArrows =
      DsLucideGlyph('git-compare-arrows', <DsIconElement>[
    DsIconCircleElement(5, 6, 3), // key: 1qnov2
    DsIconPathElement('M12 6h5a2 2 0 0 1 2 2v7'), // key: 1yj91y
    DsIconPathElement('m15 9-3-3 3-3'), // key: 1lwv8l
    DsIconCircleElement(19, 18, 3), // key: 1qljk2
    DsIconPathElement('M12 18H7a2 2 0 0 1-2-2V9'), // key: 16sdep
    DsIconPathElement('m9 15 3 3-3 3'), // key: 1m3kbl
  ]);

  /// `git-compare.mjs`
  static const DsLucideGlyph gitCompare =
      DsLucideGlyph('git-compare', <DsIconElement>[
    DsIconCircleElement(18, 18, 3), // key: 1xkwt0
    DsIconCircleElement(6, 6, 3), // key: 1lh9wr
    DsIconPathElement('M13 6h3a2 2 0 0 1 2 2v7'), // key: 1yeb86
    DsIconPathElement('M11 18H8a2 2 0 0 1-2-2V9'), // key: 19pyzm
  ]);

  /// `git-fork.mjs`
  static const DsLucideGlyph gitFork =
      DsLucideGlyph('git-fork', <DsIconElement>[
    DsIconCircleElement(12, 18, 3), // key: 1mpf1b
    DsIconCircleElement(6, 6, 3), // key: 1lh9wr
    DsIconCircleElement(18, 6, 3), // key: 1h7g24
    DsIconPathElement('M18 9v2c0 .6-.4 1-1 1H7c-.6 0-1-.4-1-1V9'), // key: 1uq4wg
    DsIconPathElement('M12 12v3'), // key: 158kv8
  ]);

  /// `git-graph.mjs`
  static const DsLucideGlyph gitGraph =
      DsLucideGlyph('git-graph', <DsIconElement>[
    DsIconCircleElement(5, 6, 3), // key: 1qnov2
    DsIconPathElement('M5 9v6'), // key: 158jrl
    DsIconCircleElement(5, 18, 3), // key: 104gr9
    DsIconPathElement('M12 3v18'), // key: 108xh3
    DsIconCircleElement(19, 6, 3), // key: 108a5v
    DsIconPathElement('M16 15.7A9 9 0 0 0 19 9'), // key: 1e3vqb
  ]);

  /// `git-merge-conflict.mjs`
  static const DsLucideGlyph gitMergeConflict =
      DsLucideGlyph('git-merge-conflict', <DsIconElement>[
    DsIconPathElement('M12 6h4a2 2 0 0 1 2 2v7'), // key: 18ej7s
    DsIconPathElement('M6 12v9'), // key: 9e33v1
    DsIconPathElement('M9 3 3 9'), // key: ahyygn
    DsIconPathElement('M9 9 3 3'), // key: v551iv
    DsIconCircleElement(18, 18, 3), // key: 1xkwt0
  ]);

  /// `git-merge.mjs`
  static const DsLucideGlyph gitMerge =
      DsLucideGlyph('git-merge', <DsIconElement>[
    DsIconCircleElement(18, 18, 3), // key: 1xkwt0
    DsIconCircleElement(6, 6, 3), // key: 1lh9wr
    DsIconPathElement('M6 21V9a9 9 0 0 0 9 9'), // key: 7kw0sc
  ]);

  /// `git-pull-request-arrow.mjs`
  static const DsLucideGlyph gitPullRequestArrow =
      DsLucideGlyph('git-pull-request-arrow', <DsIconElement>[
    DsIconCircleElement(5, 6, 3), // key: 1qnov2
    DsIconPathElement('M5 9v12'), // key: ih889a
    DsIconCircleElement(19, 18, 3), // key: 1qljk2
    DsIconPathElement('m15 9-3-3 3-3'), // key: 1lwv8l
    DsIconPathElement('M12 6h5a2 2 0 0 1 2 2v7'), // key: 1yj91y
  ]);

  /// `git-pull-request-closed.mjs`
  static const DsLucideGlyph gitPullRequestClosed =
      DsLucideGlyph('git-pull-request-closed', <DsIconElement>[
    DsIconCircleElement(6, 6, 3), // key: 1lh9wr
    DsIconPathElement('M6 9v12'), // key: 1sc30k
    DsIconPathElement('m21 3-6 6'), // key: 16nqsk
    DsIconPathElement('m21 9-6-6'), // key: 9j17rh
    DsIconPathElement('M18 11.5V15'), // key: 65xf6f
    DsIconCircleElement(18, 18, 3), // key: 1xkwt0
  ]);

  /// `git-pull-request-create-arrow.mjs`
  static const DsLucideGlyph gitPullRequestCreateArrow =
      DsLucideGlyph('git-pull-request-create-arrow', <DsIconElement>[
    DsIconCircleElement(5, 6, 3), // key: 1qnov2
    DsIconPathElement('M5 9v12'), // key: ih889a
    DsIconPathElement('m15 9-3-3 3-3'), // key: 1lwv8l
    DsIconPathElement('M12 6h5a2 2 0 0 1 2 2v3'), // key: 1rbwk6
    DsIconPathElement('M19 15v6'), // key: 10aioa
    DsIconPathElement('M22 18h-6'), // key: 1d5gi5
  ]);

  /// `git-pull-request-create.mjs`
  static const DsLucideGlyph gitPullRequestCreate =
      DsLucideGlyph('git-pull-request-create', <DsIconElement>[
    DsIconCircleElement(6, 6, 3), // key: 1lh9wr
    DsIconPathElement('M6 9v12'), // key: 1sc30k
    DsIconPathElement('M13 6h3a2 2 0 0 1 2 2v3'), // key: 1jb6z3
    DsIconPathElement('M18 15v6'), // key: 9wciyi
    DsIconPathElement('M21 18h-6'), // key: 139f0c
  ]);

  /// `git-pull-request-draft.mjs`
  static const DsLucideGlyph gitPullRequestDraft =
      DsLucideGlyph('git-pull-request-draft', <DsIconElement>[
    DsIconCircleElement(18, 18, 3), // key: 1xkwt0
    DsIconCircleElement(6, 6, 3), // key: 1lh9wr
    DsIconPathElement('M18 6V5'), // key: 1oao2s
    DsIconPathElement('M18 11v-1'), // key: 11c8tz
    DsIconLineElement(6, 9, 6, 21), // key: rroup
  ]);

  /// `git-pull-request.mjs`
  static const DsLucideGlyph gitPullRequest =
      DsLucideGlyph('git-pull-request', <DsIconElement>[
    DsIconCircleElement(18, 18, 3), // key: 1xkwt0
    DsIconCircleElement(6, 6, 3), // key: 1lh9wr
    DsIconPathElement('M13 6h3a2 2 0 0 1 2 2v7'), // key: 1yeb86
    DsIconLineElement(6, 9, 6, 21), // key: rroup
  ]);

  /// `glass-water.mjs`
  static const DsLucideGlyph glassWater =
      DsLucideGlyph('glass-water', <DsIconElement>[
    DsIconPathElement('M5.116 4.104A1 1 0 0 1 6.11 3h11.78a1 1 0 0 1 .994 1.105L17.19 20.21A2 2 0 0 1 15.2 22H8.8a2 2 0 0 1-2-1.79z'), // key: p55z4y
    DsIconPathElement('M6 12a5 5 0 0 1 6 0 5 5 0 0 0 6 0'), // key: mjntcy
  ]);

  /// `glasses.mjs`
  static const DsLucideGlyph glasses =
      DsLucideGlyph('glasses', <DsIconElement>[
    DsIconCircleElement(6, 15, 4), // key: vux9w4
    DsIconCircleElement(18, 15, 4), // key: 18o8ve
    DsIconPathElement('M14 15a2 2 0 0 0-2-2 2 2 0 0 0-2 2'), // key: 1ag4bs
    DsIconPathElement('M2.5 13 5 7c.7-1.3 1.4-2 3-2'), // key: 1hm1gs
    DsIconPathElement('M21.5 13 19 7c-.7-1.3-1.5-2-3-2'), // key: 1r31ai
  ]);

  /// `globe-check.mjs`
  static const DsLucideGlyph globeCheck =
      DsLucideGlyph('globe-check', <DsIconElement>[
    DsIconPathElement('m15 6 2 2 4-4'), // key: levio8
    DsIconPathElement('M2 12h20A10 10 0 1 1 12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 4-10'), // key: 46evmv
  ]);

  /// `globe-lock.mjs`
  static const DsLucideGlyph globeLock =
      DsLucideGlyph('globe-lock', <DsIconElement>[
    DsIconPathElement('M15.686 15A14.5 14.5 0 0 1 12 22a14.5 14.5 0 0 1 0-20 10 10 0 1 0 9.542 13'), // key: qkt0x6
    DsIconPathElement('M2 12h8.5'), // key: ovaggd
    DsIconPathElement('M20 6V4a2 2 0 1 0-4 0v2'), // key: 1of5e8
    DsIconRectElement(14, 6, 8, 5, 1), // key: 1fmf51
  ]);

  /// `globe-off.mjs`
  static const DsLucideGlyph globeOff =
      DsLucideGlyph('globe-off', <DsIconElement>[
    DsIconPathElement('M10.114 4.462A14.5 14.5 0 0 1 12 2a10 10 0 0 1 9.313 13.643'), // key: 1jq2r7
    DsIconPathElement('M15.557 15.556A14.5 14.5 0 0 1 12 22 10 10 0 0 1 4.929 4.929'), // key: 1ohfya
    DsIconPathElement('M15.892 10.234A14.5 14.5 0 0 0 12 2a10 10 0 0 0-3.643.687'), // key: 1fyh9w
    DsIconPathElement('M17.656 12H22'), // key: 1ttse4
    DsIconPathElement('M19.071 19.071A10 10 0 0 1 12 22 14.5 14.5 0 0 1 8.44 8.45'), // key: rmtjzo
    DsIconPathElement('M2 12h10'), // key: 19562f
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `globe-x.mjs`
  static const DsLucideGlyph globeX =
      DsLucideGlyph('globe-x', <DsIconElement>[
    DsIconPathElement('m16 3 5 5'), // key: 1husv6
    DsIconPathElement('M2 12h20A10 10 0 1 1 12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 4-10'), // key: 46evmv
    DsIconPathElement('m21 3-5 5'), // key: 1g5oa7
  ]);

  /// `globe.mjs`
  static const DsLucideGlyph globe =
      DsLucideGlyph('globe', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 0-20'), // key: 13o1zl
    DsIconPathElement('M2 12h20'), // key: 9i4pu4
  ]);

  /// `goal.mjs`
  static const DsLucideGlyph goal =
      DsLucideGlyph('goal', <DsIconElement>[
    DsIconPathElement('M12 13V2l8 4-8 4'), // key: 5wlwwj
    DsIconPathElement('M20.561 10.222a9 9 0 1 1-12.55-5.29'), // key: 1c0wjv
    DsIconPathElement('M8.002 9.997a5 5 0 1 0 8.9 2.02'), // key: gb1g7m
  ]);

  /// `gpu.mjs`
  static const DsLucideGlyph gpu =
      DsLucideGlyph('gpu', <DsIconElement>[
    DsIconPathElement('M2 17h18a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2H2'), // key: hpo31w
    DsIconPathElement('M2 21V3'), // key: 1bzk4w
    DsIconPathElement('M7 17v3a1 1 0 0 0 1 1h5a1 1 0 0 0 1-1v-3'), // key: 5hbqbf
    DsIconCircleElement(16, 11, 2), // key: qt15rb
    DsIconCircleElement(8, 11, 2), // key: ssideg
  ]);

  /// `graduation-cap.mjs`
  static const DsLucideGlyph graduationCap =
      DsLucideGlyph('graduation-cap', <DsIconElement>[
    DsIconPathElement('M21.42 10.922a1 1 0 0 0-.019-1.838L12.83 5.18a2 2 0 0 0-1.66 0L2.6 9.08a1 1 0 0 0 0 1.832l8.57 3.908a2 2 0 0 0 1.66 0z'), // key: j76jl0
    DsIconPathElement('M22 10v6'), // key: 1lu8f3
    DsIconPathElement('M6 12.5V16a6 3 0 0 0 12 0v-3.5'), // key: 1r8lef
  ]);

  /// `grape.mjs`
  static const DsLucideGlyph grape =
      DsLucideGlyph('grape', <DsIconElement>[
    DsIconPathElement('M22 5V2l-5.89 5.89'), // key: 1eenpo
    DsIconCircleElement(16.6, 15.89, 3), // key: xjtalx
    DsIconCircleElement(8.11, 7.4, 3), // key: u2fv6i
    DsIconCircleElement(12.35, 11.65, 3), // key: i6i8g7
    DsIconCircleElement(13.91, 5.85, 3), // key: 6ye0dv
    DsIconCircleElement(18.15, 10.09, 3), // key: snx9no
    DsIconCircleElement(6.56, 13.2, 3), // key: 17x4xg
    DsIconCircleElement(10.8, 17.44, 3), // key: 1hogw9
    DsIconCircleElement(5, 19, 3), // key: 1sn6vo
  ]);

  /// `grid-2x2-check.mjs`
  static const DsLucideGlyph grid2x2Check =
      DsLucideGlyph('grid-2x2-check', <DsIconElement>[
    DsIconPathElement('M12 3v17a1 1 0 0 1-1 1H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v6a1 1 0 0 1-1 1H3'), // key: 11za1p
    DsIconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
  ]);

  /// `grid-2x2-plus.mjs`
  static const DsLucideGlyph grid2x2Plus =
      DsLucideGlyph('grid-2x2-plus', <DsIconElement>[
    DsIconPathElement('M12 3v17a1 1 0 0 1-1 1H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v6a1 1 0 0 1-1 1H3'), // key: 11za1p
    DsIconPathElement('M16 19h6'), // key: xwg31i
    DsIconPathElement('M19 22v-6'), // key: qhmiwi
  ]);

  /// `grid-2x2-x.mjs`
  static const DsLucideGlyph grid2x2X =
      DsLucideGlyph('grid-2x2-x', <DsIconElement>[
    DsIconPathElement('M12 3v17a1 1 0 0 1-1 1H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v6a1 1 0 0 1-1 1H3'), // key: 11za1p
    DsIconPathElement('m16 16 5 5'), // key: 8tpb07
    DsIconPathElement('m16 21 5-5'), // key: 193jll
  ]);

  /// `grid-2x2.mjs`
  static const DsLucideGlyph grid2x2 =
      DsLucideGlyph('grid-2x2', <DsIconElement>[
    DsIconPathElement('M12 3v18'), // key: 108xh3
    DsIconPathElement('M3 12h18'), // key: 1i2n21
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `grid-3x2.mjs`
  static const DsLucideGlyph grid3x2 =
      DsLucideGlyph('grid-3x2', <DsIconElement>[
    DsIconPathElement('M15 3v18'), // key: 14nvp0
    DsIconPathElement('M3 12h18'), // key: 1i2n21
    DsIconPathElement('M9 3v18'), // key: fh3hqa
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `grid-3x3.mjs`
  static const DsLucideGlyph grid3x3 =
      DsLucideGlyph('grid-3x3', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('M3 15h18'), // key: 5xshup
    DsIconPathElement('M9 3v18'), // key: fh3hqa
    DsIconPathElement('M15 3v18'), // key: 14nvp0
  ]);

  /// `grip-horizontal.mjs`
  static const DsLucideGlyph gripHorizontal =
      DsLucideGlyph('grip-horizontal', <DsIconElement>[
    DsIconCircleElement(12, 9, 1), // key: 124mty
    DsIconCircleElement(19, 9, 1), // key: 1ruzo2
    DsIconCircleElement(5, 9, 1), // key: 1a8b28
    DsIconCircleElement(12, 15, 1), // key: 1e56xg
    DsIconCircleElement(19, 15, 1), // key: 1a92ep
    DsIconCircleElement(5, 15, 1), // key: 5r1jwy
  ]);

  /// `grip-vertical.mjs`
  static const DsLucideGlyph gripVertical =
      DsLucideGlyph('grip-vertical', <DsIconElement>[
    DsIconCircleElement(9, 12, 1), // key: 1vctgf
    DsIconCircleElement(9, 5, 1), // key: hp0tcf
    DsIconCircleElement(9, 19, 1), // key: fkjjf6
    DsIconCircleElement(15, 12, 1), // key: 1tmaij
    DsIconCircleElement(15, 5, 1), // key: 19l28e
    DsIconCircleElement(15, 19, 1), // key: f4zoj3
  ]);

  /// `grip.mjs`
  static const DsLucideGlyph grip =
      DsLucideGlyph('grip', <DsIconElement>[
    DsIconCircleElement(12, 5, 1), // key: gxeob9
    DsIconCircleElement(19, 5, 1), // key: w8mnmm
    DsIconCircleElement(5, 5, 1), // key: lttvr7
    DsIconCircleElement(12, 12, 1), // key: 41hilf
    DsIconCircleElement(19, 12, 1), // key: 1wjl8i
    DsIconCircleElement(5, 12, 1), // key: 1pcz8c
    DsIconCircleElement(12, 19, 1), // key: lyex9k
    DsIconCircleElement(19, 19, 1), // key: shf9b7
    DsIconCircleElement(5, 19, 1), // key: bfqh0e
  ]);

  /// `group.mjs`
  static const DsLucideGlyph group =
      DsLucideGlyph('group', <DsIconElement>[
    DsIconPathElement('M3 7V5c0-1.1.9-2 2-2h2'), // key: adw53z
    DsIconPathElement('M17 3h2c1.1 0 2 .9 2 2v2'), // key: an4l38
    DsIconPathElement('M21 17v2c0 1.1-.9 2-2 2h-2'), // key: 144t0e
    DsIconPathElement('M7 21H5c-1.1 0-2-.9-2-2v-2'), // key: rtnfgi
    DsIconRectElement(7, 7, 7, 5, 1), // key: 1eyiv7
    DsIconRectElement(10, 12, 7, 5, 1), // key: 1qlmkx
  ]);

  /// `guitar.mjs`
  static const DsLucideGlyph guitar =
      DsLucideGlyph('guitar', <DsIconElement>[
    DsIconPathElement('m11.9 12.1 4.514-4.514'), // key: 109xqo
    DsIconPathElement('M20.1 2.3a1 1 0 0 0-1.4 0l-1.114 1.114A2 2 0 0 0 17 4.828v1.344a2 2 0 0 1-.586 1.414A2 2 0 0 1 17.828 7h1.344a2 2 0 0 0 1.414-.586L21.7 5.3a1 1 0 0 0 0-1.4z'), // key: txyc8t
    DsIconPathElement('m6 16 2 2'), // key: 16qmzd
    DsIconPathElement('M8.23 9.85A3 3 0 0 1 11 8a5 5 0 0 1 5 5 3 3 0 0 1-1.85 2.77l-.92.38A2 2 0 0 0 12 18a4 4 0 0 1-4 4 6 6 0 0 1-6-6 4 4 0 0 1 4-4 2 2 0 0 0 1.85-1.23z'), // key: 1de1vg
  ]);

  /// `ham.mjs`
  static const DsLucideGlyph ham =
      DsLucideGlyph('ham', <DsIconElement>[
    DsIconPathElement('M13.144 21.144A7.274 10.445 45 1 0 2.856 10.856'), // key: 1k1t7q
    DsIconPathElement('M13.144 21.144A7.274 4.365 45 0 0 2.856 10.856a7.274 4.365 45 0 0 10.288 10.288'), // key: 153t1g
    DsIconPathElement('M16.565 10.435 18.6 8.4a2.501 2.501 0 1 0 1.65-4.65 2.5 2.5 0 1 0-4.66 1.66l-2.024 2.025'), // key: gzrt0n
    DsIconPathElement('m8.5 16.5-1-1'), // key: otr954
  ]);

  /// `hamburger.mjs`
  static const DsLucideGlyph hamburger =
      DsLucideGlyph('hamburger', <DsIconElement>[
    DsIconPathElement('M12 16H4a2 2 0 1 1 0-4h16a2 2 0 1 1 0 4h-4.25'), // key: 5dloqd
    DsIconPathElement('M5 12a2 2 0 0 1-2-2 9 7 0 0 1 18 0 2 2 0 0 1-2 2'), // key: 1vl3my
    DsIconPathElement('M5 16a2 2 0 0 0-2 2 3 3 0 0 0 3 3h12a3 3 0 0 0 3-3 2 2 0 0 0-2-2q0 0 0 0'), // key: 1us75o
    DsIconPathElement('m6.67 12 6.13 4.6a2 2 0 0 0 2.8-.4l3.15-4.2'), // key: qqzweh
  ]);

  /// `hammer.mjs`
  static const DsLucideGlyph hammer =
      DsLucideGlyph('hammer', <DsIconElement>[
    DsIconPathElement('m15 12-9.373 9.373a1 1 0 0 1-3.001-3L12 9'), // key: 1hayfq
    DsIconPathElement('m18 15 4-4'), // key: 16gjal
    DsIconPathElement('m21.5 11.5-1.914-1.914A2 2 0 0 1 19 8.172v-.344a2 2 0 0 0-.586-1.414l-1.657-1.657A6 6 0 0 0 12.516 3H9l1.243 1.243A6 6 0 0 1 12 8.485V10l2 2h1.172a2 2 0 0 1 1.414.586L18.5 14.5'), // key: 15ts47
  ]);

  /// `hand-coins.mjs`
  static const DsLucideGlyph handCoins =
      DsLucideGlyph('hand-coins', <DsIconElement>[
    DsIconPathElement('M11 15h2a2 2 0 1 0 0-4h-3c-.6 0-1.1.2-1.4.6L3 17'), // key: geh8rc
    DsIconPathElement('m7 21 1.6-1.4c.3-.4.8-.6 1.4-.6h4c1.1 0 2.1-.4 2.8-1.2l4.6-4.4a2 2 0 0 0-2.75-2.91l-4.2 3.9'), // key: 1fto5m
    DsIconPathElement('m2 16 6 6'), // key: 1pfhp9
    DsIconCircleElement(16, 9, 2.9), // key: 1n0dlu
    DsIconCircleElement(6, 5, 3), // key: 151irh
  ]);

  /// `hand-fist.mjs`
  static const DsLucideGlyph handFist =
      DsLucideGlyph('hand-fist', <DsIconElement>[
    DsIconPathElement('M12.035 17.012a3 3 0 0 0-3-3l-.311-.002a.72.72 0 0 1-.505-1.229l1.195-1.195A2 2 0 0 1 10.828 11H12a2 2 0 0 0 0-4H9.243a3 3 0 0 0-2.122.879l-2.707 2.707A4.83 4.83 0 0 0 3 14a8 8 0 0 0 8 8h2a8 8 0 0 0 8-8V7a2 2 0 1 0-4 0v2a2 2 0 1 0 4 0'), // key: 1ff7rl
    DsIconPathElement('M13.888 9.662A2 2 0 0 0 17 8V5A2 2 0 1 0 13 5'), // key: 1xmd21
    DsIconPathElement('M9 5A2 2 0 1 0 5 5V10'), // key: f3wfjw
    DsIconPathElement('M9 7V4A2 2 0 1 1 13 4V7.268'), // key: eaoucv
  ]);

  /// `hand-grab.mjs`
  static const DsLucideGlyph handGrab =
      DsLucideGlyph('hand-grab', <DsIconElement>[
    DsIconPathElement('M18 11.5V9a2 2 0 0 0-2-2a2 2 0 0 0-2 2v1.4'), // key: edstyy
    DsIconPathElement('M14 10V8a2 2 0 0 0-2-2a2 2 0 0 0-2 2v2'), // key: 19wdwo
    DsIconPathElement('M10 9.9V9a2 2 0 0 0-2-2a2 2 0 0 0-2 2v5'), // key: 1lugqo
    DsIconPathElement('M6 14a2 2 0 0 0-2-2a2 2 0 0 0-2 2'), // key: 1hbeus
    DsIconPathElement('M18 11a2 2 0 1 1 4 0v3a8 8 0 0 1-8 8h-4a8 8 0 0 1-8-8 2 2 0 1 1 4 0'), // key: 1etffm
  ]);

  /// `hand-heart.mjs`
  static const DsLucideGlyph handHeart =
      DsLucideGlyph('hand-heart', <DsIconElement>[
    DsIconPathElement('M11 14h2a2 2 0 0 0 0-4h-3c-.6 0-1.1.2-1.4.6L3 16'), // key: 1v1a37
    DsIconPathElement('m14.45 13.39 5.05-4.694C20.196 8 21 6.85 21 5.75a2.75 2.75 0 0 0-4.797-1.837.276.276 0 0 1-.406 0A2.75 2.75 0 0 0 11 5.75c0 1.2.802 2.248 1.5 2.946L16 11.95'), // key: fhfbnt
    DsIconPathElement('m2 15 6 6'), // key: 10dquu
    DsIconPathElement('m7 20 1.6-1.4c.3-.4.8-.6 1.4-.6h4c1.1 0 2.1-.4 2.8-1.2l4.6-4.4a1 1 0 0 0-2.75-2.91'), // key: 1x6kdw
  ]);

  /// `hand-helping.mjs`
  static const DsLucideGlyph handHelping =
      DsLucideGlyph('hand-helping', <DsIconElement>[
    DsIconPathElement('M11 12h2a2 2 0 1 0 0-4h-3c-.6 0-1.1.2-1.4.6L3 14'), // key: 1j4xps
    DsIconPathElement('m7 18 1.6-1.4c.3-.4.8-.6 1.4-.6h4c1.1 0 2.1-.4 2.8-1.2l4.6-4.4a2 2 0 0 0-2.75-2.91l-4.2 3.9'), // key: uospg8
    DsIconPathElement('m2 13 6 6'), // key: 16e5sb
  ]);

  /// `hand-metal.mjs`
  static const DsLucideGlyph handMetal =
      DsLucideGlyph('hand-metal', <DsIconElement>[
    DsIconPathElement('M18 12.5V10a2 2 0 0 0-2-2a2 2 0 0 0-2 2v1.4'), // key: wc6myp
    DsIconPathElement('M14 11V9a2 2 0 1 0-4 0v2'), // key: 94qvcw
    DsIconPathElement('M10 10.5V5a2 2 0 1 0-4 0v9'), // key: m1ah89
    DsIconPathElement('m7 15-1.76-1.76a2 2 0 0 0-2.83 2.82l3.6 3.6C7.5 21.14 9.2 22 12 22h2a8 8 0 0 0 8-8V7a2 2 0 1 0-4 0v5'), // key: t1skq1
  ]);

  /// `hand-platter.mjs`
  static const DsLucideGlyph handPlatter =
      DsLucideGlyph('hand-platter', <DsIconElement>[
    DsIconPathElement('M12 3V2'), // key: ar7q03
    DsIconPathElement('m15.4 17.4 3.2-2.8a2 2 0 1 1 2.8 2.9l-3.6 3.3c-.7.8-1.7 1.2-2.8 1.2h-4c-1.1 0-2.1-.4-2.8-1.2l-1.302-1.464A1 1 0 0 0 6.151 19H5'), // key: n2g93r
    DsIconPathElement('M2 14h12a2 2 0 0 1 0 4h-2'), // key: 1o2jem
    DsIconPathElement('M4 10h16'), // key: img6z1
    DsIconPathElement('M5 10a7 7 0 0 1 14 0'), // key: 1ega1o
    DsIconPathElement('M5 14v6a1 1 0 0 1-1 1H2'), // key: 1hescx
  ]);

  /// `hand.mjs`
  static const DsLucideGlyph hand =
      DsLucideGlyph('hand', <DsIconElement>[
    DsIconPathElement('M18 11V6a2 2 0 0 0-2-2a2 2 0 0 0-2 2'), // key: 1fvzgz
    DsIconPathElement('M14 10V4a2 2 0 0 0-2-2a2 2 0 0 0-2 2v2'), // key: 1kc0my
    DsIconPathElement('M10 10.5V6a2 2 0 0 0-2-2a2 2 0 0 0-2 2v8'), // key: 10h0bg
    DsIconPathElement('M18 8a2 2 0 1 1 4 0v6a8 8 0 0 1-8 8h-2c-2.8 0-4.5-.86-5.99-2.34l-3.6-3.6a2 2 0 0 1 2.83-2.82L7 15'), // key: 1s1gnw
  ]);

  /// `handbag.mjs`
  static const DsLucideGlyph handbag =
      DsLucideGlyph('handbag', <DsIconElement>[
    DsIconPathElement('M2.048 18.566A2 2 0 0 0 4 21h16a2 2 0 0 0 1.952-2.434l-2-9A2 2 0 0 0 18 8H6a2 2 0 0 0-1.952 1.566z'), // key: 1qbui5
    DsIconPathElement('M8 11V6a4 4 0 0 1 8 0v5'), // key: tcht90
  ]);

  /// `handshake.mjs`
  static const DsLucideGlyph handshake =
      DsLucideGlyph('handshake', <DsIconElement>[
    DsIconPathElement('m11 17 2 2a1 1 0 1 0 3-3'), // key: efffak
    DsIconPathElement('m14 14 2.5 2.5a1 1 0 1 0 3-3l-3.88-3.88a3 3 0 0 0-4.24 0l-.88.88a1 1 0 1 1-3-3l2.81-2.81a5.79 5.79 0 0 1 7.06-.87l.47.28a2 2 0 0 0 1.42.25L21 4'), // key: 9pr0kb
    DsIconPathElement('m21 3 1 11h-2'), // key: 1tisrp
    DsIconPathElement('M3 3 2 14l6.5 6.5a1 1 0 1 0 3-3'), // key: 1uvwmv
    DsIconPathElement('M3 4h8'), // key: 1ep09j
  ]);

  /// `hard-drive-download.mjs`
  static const DsLucideGlyph hardDriveDownload =
      DsLucideGlyph('hard-drive-download', <DsIconElement>[
    DsIconPathElement('M12 2v8'), // key: 1q4o3n
    DsIconPathElement('m16 6-4 4-4-4'), // key: 6wukr
    DsIconRectElement(2, 14, 20, 8, 2), // key: w68u3i
    DsIconPathElement('M6 18h.01'), // key: uhywen
    DsIconPathElement('M10 18h.01'), // key: h775k
  ]);

  /// `hard-drive-upload.mjs`
  static const DsLucideGlyph hardDriveUpload =
      DsLucideGlyph('hard-drive-upload', <DsIconElement>[
    DsIconPathElement('m16 6-4-4-4 4'), // key: 13yo43
    DsIconPathElement('M12 2v8'), // key: 1q4o3n
    DsIconRectElement(2, 14, 20, 8, 2), // key: w68u3i
    DsIconPathElement('M6 18h.01'), // key: uhywen
    DsIconPathElement('M10 18h.01'), // key: h775k
  ]);

  /// `hard-drive.mjs`
  static const DsLucideGlyph hardDrive =
      DsLucideGlyph('hard-drive', <DsIconElement>[
    DsIconPathElement('M10 16h.01'), // key: 1bzywj
    DsIconPathElement('M2.212 11.577a2 2 0 0 0-.212.896V18a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-5.527a2 2 0 0 0-.212-.896L18.55 5.11A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z'), // key: 18tbho
    DsIconPathElement('M21.946 12.013H2.054'), // key: zqlbp7
    DsIconPathElement('M6 16h.01'), // key: 1pmjb7
  ]);

  /// `hard-hat.mjs`
  static const DsLucideGlyph hardHat =
      DsLucideGlyph('hard-hat', <DsIconElement>[
    DsIconPathElement('M10 10V5a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v5'), // key: 1p9q5i
    DsIconPathElement('M14 6a6 6 0 0 1 6 6v3'), // key: 1hnv84
    DsIconPathElement('M4 15v-3a6 6 0 0 1 6-6'), // key: 9ciidu
    DsIconRectElement(2, 15, 20, 4, 1), // key: g3x8cw
  ]);

  /// `hash.mjs`
  static const DsLucideGlyph hash =
      DsLucideGlyph('hash', <DsIconElement>[
    DsIconLineElement(4, 9, 20, 9), // key: 4lhtct
    DsIconLineElement(4, 15, 20, 15), // key: vyu0kd
    DsIconLineElement(10, 3, 8, 21), // key: 1ggp8o
    DsIconLineElement(16, 3, 14, 21), // key: weycgp
  ]);

  /// `hat-glasses.mjs`
  static const DsLucideGlyph hatGlasses =
      DsLucideGlyph('hat-glasses', <DsIconElement>[
    DsIconPathElement('M14 18a2 2 0 0 0-4 0'), // key: 1v8fkw
    DsIconPathElement('m19 11-2.11-6.657a2 2 0 0 0-2.752-1.148l-1.276.61A2 2 0 0 1 12 4H8.5a2 2 0 0 0-1.925 1.456L5 11'), // key: 1fkr7p
    DsIconPathElement('M2 11h20'), // key: 3eubbj
    DsIconCircleElement(17, 18, 3), // key: 82mm0e
    DsIconCircleElement(7, 18, 3), // key: lvkj7j
  ]);

  /// `haze.mjs`
  static const DsLucideGlyph haze =
      DsLucideGlyph('haze', <DsIconElement>[
    DsIconPathElement('m5.2 6.2 1.4 1.4'), // key: 17imol
    DsIconPathElement('M2 13h2'), // key: 13gyu8
    DsIconPathElement('M20 13h2'), // key: 16rner
    DsIconPathElement('m17.4 7.6 1.4-1.4'), // key: t4xlah
    DsIconPathElement('M22 17H2'), // key: 1gtaj3
    DsIconPathElement('M22 21H2'), // key: 1gy6en
    DsIconPathElement('M16 13a4 4 0 0 0-8 0'), // key: 1dyczq
    DsIconPathElement('M12 5V2.5'), // key: 1vytko
  ]);

  /// `hd.mjs`
  static const DsLucideGlyph hd =
      DsLucideGlyph('hd', <DsIconElement>[
    DsIconPathElement('M10 12H6'), // key: 15f2ro
    DsIconPathElement('M10 15V9'), // key: 1lckn7
    DsIconPathElement('M14 14.5a.5.5 0 0 0 .5.5h1a2.5 2.5 0 0 0 2.5-2.5v-1A2.5 2.5 0 0 0 15.5 9h-1a.5.5 0 0 0-.5.5z'), // key: b3f847
    DsIconPathElement('M6 15V9'), // key: 12stmj
    DsIconRectElement(2, 5, 20, 14, 2), // key: qneu4z
  ]);

  /// `hdmi-port.mjs`
  static const DsLucideGlyph hdmiPort =
      DsLucideGlyph('hdmi-port', <DsIconElement>[
    DsIconPathElement('M22 9a1 1 0 00-1-1H3a1 1 0 00-1 1v4a1 1 0 001 1h.5a2 2 0 011.6.8l.3.4A2 2 0 007 16h10a2 2 0 001.6-.8l.3-.4a2 2 0 011.6-.8h.5a1 1 0 001-1z'), // key: 1kwg9h
    DsIconPathElement('M8 12h8'), // key: 1wcyev
  ]);

  /// `heading-1.mjs`
  static const DsLucideGlyph heading1 =
      DsLucideGlyph('heading-1', <DsIconElement>[
    DsIconPathElement('M4 12h8'), // key: 17cfdx
    DsIconPathElement('M4 18V6'), // key: 1rz3zl
    DsIconPathElement('M12 18V6'), // key: zqpxq5
    DsIconPathElement('m17 12 3-2v8'), // key: 1hhhft
  ]);

  /// `heading-2.mjs`
  static const DsLucideGlyph heading2 =
      DsLucideGlyph('heading-2', <DsIconElement>[
    DsIconPathElement('M4 12h8'), // key: 17cfdx
    DsIconPathElement('M4 18V6'), // key: 1rz3zl
    DsIconPathElement('M12 18V6'), // key: zqpxq5
    DsIconPathElement('M21 18h-4c0-4 4-3 4-6 0-1.5-2-2.5-4-1'), // key: 9jr5yi
  ]);

  /// `heading-3.mjs`
  static const DsLucideGlyph heading3 =
      DsLucideGlyph('heading-3', <DsIconElement>[
    DsIconPathElement('M4 12h8'), // key: 17cfdx
    DsIconPathElement('M4 18V6'), // key: 1rz3zl
    DsIconPathElement('M12 18V6'), // key: zqpxq5
    DsIconPathElement('M17.5 10.5c1.7-1 3.5 0 3.5 1.5a2 2 0 0 1-2 2'), // key: 68ncm8
    DsIconPathElement('M17 17.5c2 1.5 4 .3 4-1.5a2 2 0 0 0-2-2'), // key: 1ejuhz
  ]);

  /// `heading-4.mjs`
  static const DsLucideGlyph heading4 =
      DsLucideGlyph('heading-4', <DsIconElement>[
    DsIconPathElement('M12 18V6'), // key: zqpxq5
    DsIconPathElement('M17 10v3a1 1 0 0 0 1 1h3'), // key: tj5zdr
    DsIconPathElement('M21 10v8'), // key: 1kdml4
    DsIconPathElement('M4 12h8'), // key: 17cfdx
    DsIconPathElement('M4 18V6'), // key: 1rz3zl
  ]);

  /// `heading-5.mjs`
  static const DsLucideGlyph heading5 =
      DsLucideGlyph('heading-5', <DsIconElement>[
    DsIconPathElement('M4 12h8'), // key: 17cfdx
    DsIconPathElement('M4 18V6'), // key: 1rz3zl
    DsIconPathElement('M12 18V6'), // key: zqpxq5
    DsIconPathElement('M17 13v-3h4'), // key: 1nvgqp
    DsIconPathElement('M17 17.7c.4.2.8.3 1.3.3 1.5 0 2.7-1.1 2.7-2.5S19.8 13 18.3 13H17'), // key: 2nebdn
  ]);

  /// `heading-6.mjs`
  static const DsLucideGlyph heading6 =
      DsLucideGlyph('heading-6', <DsIconElement>[
    DsIconPathElement('M4 12h8'), // key: 17cfdx
    DsIconPathElement('M4 18V6'), // key: 1rz3zl
    DsIconPathElement('M12 18V6'), // key: zqpxq5
    DsIconCircleElement(19, 16, 2), // key: 15mx69
    DsIconPathElement('M20 10c-2 2-3 3.5-3 6'), // key: f35dl0
  ]);

  /// `heading.mjs`
  static const DsLucideGlyph heading =
      DsLucideGlyph('heading', <DsIconElement>[
    DsIconPathElement('M6 12h12'), // key: 8npq4p
    DsIconPathElement('M6 20V4'), // key: 1w1bmo
    DsIconPathElement('M18 20V4'), // key: o2hl4u
  ]);

  /// `headphone-off.mjs`
  static const DsLucideGlyph headphoneOff =
      DsLucideGlyph('headphone-off', <DsIconElement>[
    DsIconPathElement('M21 14h-1.343'), // key: 1jdnxi
    DsIconPathElement('M9.128 3.47A9 9 0 0 1 21 12v3.343'), // key: 6kipu2
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M20.414 20.414A2 2 0 0 1 19 21h-1a2 2 0 0 1-2-2v-3'), // key: 9x50f4
    DsIconPathElement('M3 14h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-7a9 9 0 0 1 2.636-6.364'), // key: 1bkxnm
  ]);

  /// `headphones.mjs`
  static const DsLucideGlyph headphones =
      DsLucideGlyph('headphones', <DsIconElement>[
    DsIconPathElement('M3 14h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-7a9 9 0 0 1 18 0v7a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3'), // key: 1xhozi
  ]);

  /// `headset.mjs`
  static const DsLucideGlyph headset =
      DsLucideGlyph('headset', <DsIconElement>[
    DsIconPathElement('M3 11h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-5Zm0 0a9 9 0 1 1 18 0m0 0v5a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3Z'), // key: 12oyoe
    DsIconPathElement('M21 16v2a4 4 0 0 1-4 4h-5'), // key: 1x7m43
  ]);

  /// `heart-crack.mjs`
  static const DsLucideGlyph heartCrack =
      DsLucideGlyph('heart-crack', <DsIconElement>[
    DsIconPathElement('M12.409 5.824c-.702.792-1.15 1.496-1.415 2.166l2.153 2.156a.5.5 0 0 1 0 .707l-2.293 2.293a.5.5 0 0 0 0 .707L12 15'), // key: idzbju
    DsIconPathElement('M13.508 20.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5a5.5 5.5 0 0 1 9.591-3.677.6.6 0 0 0 .818.001A5.5 5.5 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5z'), // key: 1su70f
  ]);

  /// `heart-handshake.mjs`
  static const DsLucideGlyph heartHandshake =
      DsLucideGlyph('heart-handshake', <DsIconElement>[
    DsIconPathElement('M19.414 14.414C21 12.828 22 11.5 22 9.5a5.5 5.5 0 0 0-9.591-3.676.6.6 0 0 1-.818.001A5.5 5.5 0 0 0 2 9.5c0 2.3 1.5 4 3 5.5l5.535 5.362a2 2 0 0 0 2.879.052 2.12 2.12 0 0 0-.004-3 2.124 2.124 0 1 0 3-3 2.124 2.124 0 0 0 3.004 0 2 2 0 0 0 0-2.828l-1.881-1.882a2.41 2.41 0 0 0-3.409 0l-1.71 1.71a2 2 0 0 1-2.828 0 2 2 0 0 1 0-2.828l2.823-2.762'), // key: 17lmqv
  ]);

  /// `heart-minus.mjs`
  static const DsLucideGlyph heartMinus =
      DsLucideGlyph('heart-minus', <DsIconElement>[
    DsIconPathElement('m14.876 18.99-1.368 1.323a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5a5.2 5.2 0 0 1-.244 1.572'), // key: 15yztm
    DsIconPathElement('M15 15h6'), // key: 1u4692
  ]);

  /// `heart-off.mjs`
  static const DsLucideGlyph heartOff =
      DsLucideGlyph('heart-off', <DsIconElement>[
    DsIconPathElement('M10.5 4.893a5.5 5.5 0 0 1 1.091.931.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 1.872-1.002 3.356-2.187 4.655'), // key: 1inpfl
    DsIconPathElement('m16.967 16.967-3.459 3.346a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5a5.5 5.5 0 0 1 2.747-4.761'), // key: vbc6x7
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `heart-plus.mjs`
  static const DsLucideGlyph heartPlus =
      DsLucideGlyph('heart-plus', <DsIconElement>[
    DsIconPathElement('m14.479 19.374-.971.939a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5a5.2 5.2 0 0 1-.219 1.49'), // key: wg5jx
    DsIconPathElement('M15 15h6'), // key: 1u4692
    DsIconPathElement('M18 12v6'), // key: 1houu1
  ]);

  /// `heart-pulse.mjs`
  static const DsLucideGlyph heartPulse =
      DsLucideGlyph('heart-pulse', <DsIconElement>[
    DsIconPathElement('M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5'), // key: mvr1a0
    DsIconPathElement('M3.22 13H9.5l.5-1 2 4.5 2-7 1.5 3.5h5.27'), // key: auskq0
  ]);

  /// `heart-x.mjs`
  static const DsLucideGlyph heartX =
      DsLucideGlyph('heart-x', <DsIconElement>[
    DsIconPathElement('m15.5 12.5 5 5'), // key: 15wbfr
    DsIconPathElement('m20.5 12.5-5 5'), // key: o012pn
    DsIconPathElement('M21.955 8.774a5.5 5.5 0 0 0-9.546-2.95.6.6 0 0 1-.818 0A5.5 5.5 0 0 0 2 9.5c0 2.3 1.5 4 3 5.5l5.508 5.332a2 2 0 0 0 2.57.352'), // key: c1obtn
  ]);

  /// `heart.mjs`
  static const DsLucideGlyph heart =
      DsLucideGlyph('heart', <DsIconElement>[
    DsIconPathElement('M2 9.5a5.5 5.5 0 0 1 9.591-3.676.56.56 0 0 0 .818 0A5.49 5.49 0 0 1 22 9.5c0 2.29-1.5 4-3 5.5l-5.492 5.313a2 2 0 0 1-3 .019L5 15c-1.5-1.5-3-3.2-3-5.5'), // key: mvr1a0
  ]);

  /// `heater.mjs`
  static const DsLucideGlyph heater =
      DsLucideGlyph('heater', <DsIconElement>[
    DsIconPathElement('M11 8c2-3-2-3 0-6'), // key: 1ldv5m
    DsIconPathElement('M15.5 8c2-3-2-3 0-6'), // key: 1otqoz
    DsIconPathElement('M6 10h.01'), // key: 1lbq93
    DsIconPathElement('M6 14h.01'), // key: zudwn7
    DsIconPathElement('M10 16v-4'), // key: 1c25yv
    DsIconPathElement('M14 16v-4'), // key: 1dkbt8
    DsIconPathElement('M18 16v-4'), // key: 1yg9me
    DsIconPathElement('M20 6a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h3'), // key: 1ubg90
    DsIconPathElement('M5 20v2'), // key: 1abpe8
    DsIconPathElement('M19 20v2'), // key: kqn6ft
  ]);

  /// `helicopter.mjs`
  static const DsLucideGlyph helicopter =
      DsLucideGlyph('helicopter', <DsIconElement>[
    DsIconPathElement('M11 17v4'), // key: 14wq8k
    DsIconPathElement('M14 3v8a2 2 0 0 0 2 2h5.865'), // key: 12oo5h
    DsIconPathElement('M17 17v4'), // key: hdt4hh
    DsIconPathElement('M18 17a4 4 0 0 0 4-4 8 6 0 0 0-8-6 6 5 0 0 0-6 5v3a2 2 0 0 0 2 2z'), // key: yynif
    DsIconPathElement('M2 10v5'), // key: sa5akn
    DsIconPathElement('M6 3h16'), // key: 27qw71
    DsIconPathElement('M7 21h14'), // key: 1ugz0u
    DsIconPathElement('M8 13H2'), // key: 1thz1o
  ]);

  /// `hexagon.mjs`
  static const DsLucideGlyph hexagon =
      DsLucideGlyph('hexagon', <DsIconElement>[
    DsIconPathElement('M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z'), // key: yt0hxn
  ]);

  /// `highlighter.mjs`
  static const DsLucideGlyph highlighter =
      DsLucideGlyph('highlighter', <DsIconElement>[
    DsIconPathElement('m9 11-6 6v3h9l3-3'), // key: 1a3l36
    DsIconPathElement('m22 12-4.6 4.6a2 2 0 0 1-2.8 0l-5.2-5.2a2 2 0 0 1 0-2.8L14 4'), // key: 14a9rk
  ]);

  /// `hop-off.mjs`
  static const DsLucideGlyph hopOff =
      DsLucideGlyph('hop-off', <DsIconElement>[
    DsIconPathElement('M10.82 16.12c1.69.6 3.91.79 5.18.85.28.01.53-.09.7-.27'), // key: qyzcap
    DsIconPathElement('M11.14 20.57c.52.24 2.44 1.12 4.08 1.37.46.06.86-.25.9-.71.12-1.52-.3-3.43-.5-4.28'), // key: y078lb
    DsIconPathElement('M16.13 21.05c1.65.63 3.68.84 4.87.91a.9.9 0 0 0 .7-.26'), // key: 1utre3
    DsIconPathElement('M17.99 5.52a20.83 20.83 0 0 1 3.15 4.5.8.8 0 0 1-.68 1.13c-1.17.1-2.5.02-3.9-.25'), // key: 17o9hm
    DsIconPathElement('M20.57 11.14c.24.52 1.12 2.44 1.37 4.08.04.3-.08.59-.31.75'), // key: 1d1n4p
    DsIconPathElement('M4.93 4.93a10 10 0 0 0-.67 13.4c.35.43.96.4 1.17-.12.69-1.71 1.07-5.07 1.07-6.71 1.34.45 3.1.9 4.88.62a.85.85 0 0 0 .48-.24'), // key: 9uv3tt
    DsIconPathElement('M5.52 17.99c1.05.95 2.91 2.42 4.5 3.15a.8.8 0 0 0 1.13-.68c.2-2.34-.33-5.3-1.57-8.28'), // key: 1292wz
    DsIconPathElement('M8.35 2.68a10 10 0 0 1 9.98 1.58c.43.35.4.96-.12 1.17-1.5.6-4.3.98-6.07 1.05'), // key: 7ozu9p
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `hop.mjs`
  static const DsLucideGlyph hop =
      DsLucideGlyph('hop', <DsIconElement>[
    DsIconPathElement('M10.82 16.12c1.69.6 3.91.79 5.18.85.55.03 1-.42.97-.97-.06-1.27-.26-3.5-.85-5.18'), // key: 18lxf1
    DsIconPathElement('M11.5 6.5c1.64 0 5-.38 6.71-1.07.52-.2.55-.82.12-1.17A10 10 0 0 0 4.26 18.33c.35.43.96.4 1.17-.12.69-1.71 1.07-5.07 1.07-6.71 1.34.45 3.1.9 4.88.62a.88.88 0 0 0 .73-.74c.3-2.14-.15-3.5-.61-4.88'), // key: vtfxrw
    DsIconPathElement('M15.62 16.95c.2.85.62 2.76.5 4.28a.77.77 0 0 1-.9.7 16.64 16.64 0 0 1-4.08-1.36'), // key: 13hl71
    DsIconPathElement('M16.13 21.05c1.65.63 3.68.84 4.87.91a.9.9 0 0 0 .96-.96 17.68 17.68 0 0 0-.9-4.87'), // key: 1sl8oj
    DsIconPathElement('M16.94 15.62c.86.2 2.77.62 4.29.5a.77.77 0 0 0 .7-.9 16.64 16.64 0 0 0-1.36-4.08'), // key: 19c6kt
    DsIconPathElement('M17.99 5.52a20.82 20.82 0 0 1 3.15 4.5.8.8 0 0 1-.68 1.13c-2.33.2-5.3-.32-8.27-1.57'), // key: 85ghs3
    DsIconPathElement('M4.93 4.93 3 3a.7.7 0 0 1 0-1'), // key: x087yj
    DsIconPathElement('M9.58 12.18c1.24 2.98 1.77 5.95 1.57 8.28a.8.8 0 0 1-1.13.68 20.82 20.82 0 0 1-4.5-3.15'), // key: 11xdqo
  ]);

  /// `hospital.mjs`
  static const DsLucideGlyph hospital =
      DsLucideGlyph('hospital', <DsIconElement>[
    DsIconPathElement('M12 7v4'), // key: xawao1
    DsIconPathElement('M14 21v-3a2 2 0 0 0-4 0v3'), // key: 1rgiei
    DsIconPathElement('M14 9h-4'), // key: 1w2s2s
    DsIconPathElement('M18 11h2a2 2 0 0 1 2 2v6a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-9a2 2 0 0 1 2-2h2'), // key: 1tthqt
    DsIconPathElement('M18 21V5a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v16'), // key: dw4p4i
  ]);

  /// `hotel.mjs`
  static const DsLucideGlyph hotel =
      DsLucideGlyph('hotel', <DsIconElement>[
    DsIconPathElement('M10 22v-6.57'), // key: 1wmca3
    DsIconPathElement('M12 11h.01'), // key: z322tv
    DsIconPathElement('M12 7h.01'), // key: 1ivr5q
    DsIconPathElement('M14 15.43V22'), // key: 1q2vjd
    DsIconPathElement('M15 16a5 5 0 0 0-6 0'), // key: o9wqvi
    DsIconPathElement('M16 11h.01'), // key: xkw8gn
    DsIconPathElement('M16 7h.01'), // key: 1kdx03
    DsIconPathElement('M8 11h.01'), // key: 1dfujw
    DsIconPathElement('M8 7h.01'), // key: 1vti4s
    DsIconRectElement(4, 2, 16, 20, 2), // key: 1uxh74
  ]);

  /// `hourglass.mjs`
  static const DsLucideGlyph hourglass =
      DsLucideGlyph('hourglass', <DsIconElement>[
    DsIconPathElement('M5 22h14'), // key: ehvnwv
    DsIconPathElement('M5 2h14'), // key: pdyrp9
    DsIconPathElement('M17 22v-4.172a2 2 0 0 0-.586-1.414L12 12l-4.414 4.414A2 2 0 0 0 7 17.828V22'), // key: 1d314k
    DsIconPathElement('M7 2v4.172a2 2 0 0 0 .586 1.414L12 12l4.414-4.414A2 2 0 0 0 17 6.172V2'), // key: 1vvvr6
  ]);

  /// `house-heart.mjs`
  static const DsLucideGlyph houseHeart =
      DsLucideGlyph('house-heart', <DsIconElement>[
    DsIconPathElement('M8.62 13.8A2.25 2.25 0 1 1 12 10.836a2.25 2.25 0 1 1 3.38 2.966l-2.626 2.856a.998.998 0 0 1-1.507 0z'), // key: n9s7kx
    DsIconPathElement('M3 10a2 2 0 0 1 .709-1.528l7-6a2 2 0 0 1 2.582 0l7 6A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z'), // key: r6nss1
  ]);

  /// `house-plug.mjs`
  static const DsLucideGlyph housePlug =
      DsLucideGlyph('house-plug', <DsIconElement>[
    DsIconPathElement('M10 12V8.964'), // key: 1vll13
    DsIconPathElement('M14 12V8.964'), // key: 1x3qvg
    DsIconPathElement('M15 12a1 1 0 0 1 1 1v2a2 2 0 0 1-2 2h-4a2 2 0 0 1-2-2v-2a1 1 0 0 1 1-1z'), // key: ppykja
    DsIconPathElement('M8.5 21H5a2 2 0 0 1-2-2v-9a2 2 0 0 1 .709-1.528l7-6a2 2 0 0 1 2.582 0l7 6A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2h-5a2 2 0 0 1-2-2v-2'), // key: 365xoy
  ]);

  /// `house-plus.mjs`
  static const DsLucideGlyph housePlus =
      DsLucideGlyph('house-plus', <DsIconElement>[
    DsIconPathElement('M12.35 21H5a2 2 0 0 1-2-2v-9a2 2 0 0 1 .71-1.53l7-6a2 2 0 0 1 2.58 0l7 6A2 2 0 0 1 21 10v2.35'), // key: 8ek5ge
    DsIconPathElement('M14.8 12.4A1 1 0 0 0 14 12h-4a1 1 0 0 0-1 1v8'), // key: 1rbg29
    DsIconPathElement('M15 18h6'), // key: 3b3c90
    DsIconPathElement('M18 15v6'), // key: 9wciyi
  ]);

  /// `house-wifi.mjs`
  static const DsLucideGlyph houseWifi =
      DsLucideGlyph('house-wifi', <DsIconElement>[
    DsIconPathElement('M9.5 13.866a4 4 0 0 1 5 .01'), // key: 1wy54i
    DsIconPathElement('M12 17h.01'), // key: p32p05
    DsIconPathElement('M3 10a2 2 0 0 1 .709-1.528l7-6a2 2 0 0 1 2.582 0l7 6A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z'), // key: r6nss1
    DsIconPathElement('M7 10.754a8 8 0 0 1 10 0'), // key: exoy2g
  ]);

  /// `house.mjs`
  static const DsLucideGlyph house =
      DsLucideGlyph('house', <DsIconElement>[
    DsIconPathElement('M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8'), // key: 5wwlr5
    DsIconPathElement('M3 10a2 2 0 0 1 .709-1.528l7-6a2 2 0 0 1 2.582 0l7 6A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z'), // key: r6nss1
  ]);

  /// `ice-cream-bowl.mjs`
  static const DsLucideGlyph iceCreamBowl =
      DsLucideGlyph('ice-cream-bowl', <DsIconElement>[
    DsIconPathElement('M12 17c5 0 8-2.69 8-6H4c0 3.31 3 6 8 6m-4 4h8m-4-3v3M5.14 11a3.5 3.5 0 1 1 6.71 0'), // key: 1uxfcu
    DsIconPathElement('M12.14 11a3.5 3.5 0 1 1 6.71 0'), // key: 4k3m1s
    DsIconPathElement('M15.5 6.5a3.5 3.5 0 1 0-7 0'), // key: zmuahr
  ]);

  /// `ice-cream-cone.mjs`
  static const DsLucideGlyph iceCreamCone =
      DsLucideGlyph('ice-cream-cone', <DsIconElement>[
    DsIconPathElement('m7 11 4.08 10.35a1 1 0 0 0 1.84 0L17 11'), // key: 1v6356
    DsIconPathElement('M17 7A5 5 0 0 0 7 7'), // key: 151p3v
    DsIconPathElement('M17 7a2 2 0 0 1 0 4H7a2 2 0 0 1 0-4'), // key: 1sdaij
  ]);

  /// `id-card-lanyard.mjs`
  static const DsLucideGlyph idCardLanyard =
      DsLucideGlyph('id-card-lanyard', <DsIconElement>[
    DsIconPathElement('M13.5 8h-3'), // key: xvov4w
    DsIconPathElement('m15 2-1 2h3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h3'), // key: 16uttc
    DsIconPathElement('M16.899 22A5 5 0 0 0 7.1 22'), // key: 1d0ppr
    DsIconPathElement('m9 2 3 6'), // key: 1o7bd9
    DsIconCircleElement(12, 15, 3), // key: g36mzq
  ]);

  /// `id-card.mjs`
  static const DsLucideGlyph idCard =
      DsLucideGlyph('id-card', <DsIconElement>[
    DsIconPathElement('M16 10h2'), // key: 8sgtl7
    DsIconPathElement('M16 14h2'), // key: epxaof
    DsIconPathElement('M6.17 15a3 3 0 0 1 5.66 0'), // key: n6f512
    DsIconCircleElement(9, 11, 2), // key: yxgjnd
    DsIconRectElement(2, 5, 20, 14, 2), // key: qneu4z
  ]);

  /// `image-down.mjs`
  static const DsLucideGlyph imageDown =
      DsLucideGlyph('image-down', <DsIconElement>[
    DsIconPathElement('M10.3 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v10l-3.1-3.1a2 2 0 0 0-2.814.014L6 21'), // key: 9csbqa
    DsIconPathElement('m14 19 3 3v-5.5'), // key: 9ldu5r
    DsIconPathElement('m17 22 3-3'), // key: 1nkfve
    DsIconCircleElement(9, 9, 2), // key: af1f0g
  ]);

  /// `image-minus.mjs`
  static const DsLucideGlyph imageMinus =
      DsLucideGlyph('image-minus', <DsIconElement>[
    DsIconPathElement('M21 9v10a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h7'), // key: m87ecr
    DsIconLineElement(16, 5, 22, 5), // key: ez7e4s
    DsIconCircleElement(9, 9, 2), // key: af1f0g
    DsIconPathElement('m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21'), // key: 1xmnt7
  ]);

  /// `image-off.mjs`
  static const DsLucideGlyph imageOff =
      DsLucideGlyph('image-off', <DsIconElement>[
    DsIconLineElement(2, 2, 22, 22), // key: a6p6uj
    DsIconPathElement('M10.41 10.41a2 2 0 1 1-2.83-2.83'), // key: 1bzlo9
    DsIconLineElement(13.5, 13.5, 6, 21), // key: 1q0aeu
    DsIconLineElement(18, 12, 21, 15), // key: 5mozeu
    DsIconPathElement('M3.59 3.59A1.99 1.99 0 0 0 3 5v14a2 2 0 0 0 2 2h14c.55 0 1.052-.22 1.41-.59'), // key: mmje98
    DsIconPathElement('M21 15V5a2 2 0 0 0-2-2H9'), // key: 43el77
  ]);

  /// `image-play.mjs`
  static const DsLucideGlyph imagePlay =
      DsLucideGlyph('image-play', <DsIconElement>[
    DsIconPathElement('M15 15.003a1 1 0 0 1 1.517-.859l4.997 2.997a1 1 0 0 1 0 1.718l-4.997 2.997a1 1 0 0 1-1.517-.86z'), // key: nrt1m3
    DsIconPathElement('M21 12.17V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h6'), // key: 99hgts
    DsIconPathElement('m6 21 5-5'), // key: 1wyjai
    DsIconCircleElement(9, 9, 2), // key: af1f0g
  ]);

  /// `image-plus.mjs`
  static const DsLucideGlyph imagePlus =
      DsLucideGlyph('image-plus', <DsIconElement>[
    DsIconPathElement('M16 5h6'), // key: 1vod17
    DsIconPathElement('M19 2v6'), // key: 4bpg5p
    DsIconPathElement('M21 11.5V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h7.5'), // key: 1ue2ih
    DsIconPathElement('m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21'), // key: 1xmnt7
    DsIconCircleElement(9, 9, 2), // key: af1f0g
  ]);

  /// `image-up.mjs`
  static const DsLucideGlyph imageUp =
      DsLucideGlyph('image-up', <DsIconElement>[
    DsIconPathElement('M10.3 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v10l-3.1-3.1a2 2 0 0 0-2.814.014L6 21'), // key: 9csbqa
    DsIconPathElement('m14 19.5 3-3 3 3'), // key: 9vmjn0
    DsIconPathElement('M17 22v-5.5'), // key: 1aa6fl
    DsIconCircleElement(9, 9, 2), // key: af1f0g
  ]);

  /// `image-upscale.mjs`
  static const DsLucideGlyph imageUpscale =
      DsLucideGlyph('image-upscale', <DsIconElement>[
    DsIconPathElement('M16 3h5v5'), // key: 1806ms
    DsIconPathElement('M17 21h2a2 2 0 0 0 2-2'), // key: 130fy9
    DsIconPathElement('M21 12v3'), // key: 1wzk3p
    DsIconPathElement('m21 3-5 5'), // key: 1g5oa7
    DsIconPathElement('M3 7V5a2 2 0 0 1 2-2'), // key: kk3yz1
    DsIconPathElement('m5 21 4.144-4.144a1.21 1.21 0 0 1 1.712 0L13 19'), // key: fyekpt
    DsIconPathElement('M9 3h3'), // key: d52fa
    DsIconRectElement(3, 11, 10, 10, 1), // key: 1wpmix
  ]);

  /// `image.mjs`
  static const DsLucideGlyph image =
      DsLucideGlyph('image', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    DsIconCircleElement(9, 9, 2), // key: af1f0g
    DsIconPathElement('m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21'), // key: 1xmnt7
  ]);

  /// `images.mjs`
  static const DsLucideGlyph images =
      DsLucideGlyph('images', <DsIconElement>[
    DsIconPathElement('m22 11-1.296-1.296a2.4 2.4 0 0 0-3.408 0L11 16'), // key: 9kzy35
    DsIconPathElement('M4 8a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2'), // key: 1t0f0t
    DsIconCircleElement(13, 7, 1, filled: true), // key: 1obus6
    DsIconRectElement(8, 2, 14, 14, 2), // key: 1gvhby
  ]);

  /// `import.mjs`
  static const DsLucideGlyph import =
      DsLucideGlyph('import', <DsIconElement>[
    DsIconPathElement('M12 3v12'), // key: 1x0j5s
    DsIconPathElement('m8 11 4 4 4-4'), // key: 1dohi6
    DsIconPathElement('M8 5H4a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-4'), // key: 1ywtjm
  ]);

  /// `inbox.mjs`
  static const DsLucideGlyph inbox =
      DsLucideGlyph('inbox', <DsIconElement>[
    DsIconPolylineElement(<Offset>[Offset(22, 12), Offset(16, 12), Offset(14, 15), Offset(10, 15), Offset(8, 12), Offset(2, 12)]), // key: o97t9d
    DsIconPathElement('M5.45 5.11 2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z'), // key: oot6mr
  ]);

  /// `indian-rupee.mjs`
  static const DsLucideGlyph indianRupee =
      DsLucideGlyph('indian-rupee', <DsIconElement>[
    DsIconPathElement('M6 3h12'), // key: ggurg9
    DsIconPathElement('M6 8h12'), // key: 6g4wlu
    DsIconPathElement('m6 13 8.5 8'), // key: u1kupk
    DsIconPathElement('M6 13h3'), // key: wdp6ag
    DsIconPathElement('M9 13c6.667 0 6.667-10 0-10'), // key: 1nkvk2
  ]);

  /// `infinity.mjs`
  static const DsLucideGlyph infinity =
      DsLucideGlyph('infinity', <DsIconElement>[
    DsIconPathElement('M6 16c5 0 7-8 12-8a4 4 0 0 1 0 8c-5 0-7-8-12-8a4 4 0 1 0 0 8'), // key: 18ogeb
  ]);

  /// `info.mjs`
  static const DsLucideGlyph info =
      DsLucideGlyph('info', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M12 16v-4'), // key: 1dtifu
    DsIconPathElement('M12 8h.01'), // key: e9boi3
  ]);

  /// `inspection-panel.mjs`
  static const DsLucideGlyph inspectionPanel =
      DsLucideGlyph('inspection-panel', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M7 7h.01'), // key: 7u93v4
    DsIconPathElement('M17 7h.01'), // key: 14a9sn
    DsIconPathElement('M7 17h.01'), // key: 19xn7k
    DsIconPathElement('M17 17h.01'), // key: 1sd3ek
  ]);

  /// `italic.mjs`
  static const DsLucideGlyph italic =
      DsLucideGlyph('italic', <DsIconElement>[
    DsIconLineElement(19, 4, 10, 4), // key: 15jd3p
    DsIconLineElement(14, 20, 5, 20), // key: bu0au3
    DsIconLineElement(15, 4, 9, 20), // key: uljnxc
  ]);

  /// `iteration-ccw.mjs`
  static const DsLucideGlyph iterationCcw =
      DsLucideGlyph('iteration-ccw', <DsIconElement>[
    DsIconPathElement('m16 14 4 4-4 4'), // key: hkso8o
    DsIconPathElement('M20 10a8 8 0 1 0-8 8h8'), // key: 1bik7b
  ]);

  /// `iteration-cw.mjs`
  static const DsLucideGlyph iterationCw =
      DsLucideGlyph('iteration-cw', <DsIconElement>[
    DsIconPathElement('M4 10a8 8 0 1 1 8 8H4'), // key: svv66n
    DsIconPathElement('m8 22-4-4 4-4'), // key: 6g7gki
  ]);

  /// `japanese-yen.mjs`
  static const DsLucideGlyph japaneseYen =
      DsLucideGlyph('japanese-yen', <DsIconElement>[
    DsIconPathElement('M12 9.5V21m0-11.5L6 3m6 6.5L18 3'), // key: 2ej80x
    DsIconPathElement('M6 15h12'), // key: 1hwgt5
    DsIconPathElement('M6 11h12'), // key: wf4gp6
  ]);

  /// `joystick.mjs`
  static const DsLucideGlyph joystick =
      DsLucideGlyph('joystick', <DsIconElement>[
    DsIconPathElement('M21 17a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v2a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-2Z'), // key: jg2n2t
    DsIconPathElement('M6 15v-2'), // key: gd6mvg
    DsIconPathElement('M12 15V9'), // key: 8c7uyn
    DsIconCircleElement(12, 6, 3), // key: 1gm2ql
  ]);

  /// `kanban.mjs`
  static const DsLucideGlyph kanban =
      DsLucideGlyph('kanban', <DsIconElement>[
    DsIconPathElement('M5 3v14'), // key: 9nsxs2
    DsIconPathElement('M12 3v8'), // key: 1h2ygw
    DsIconPathElement('M19 3v18'), // key: 1sk56x
  ]);

  /// `kayak.mjs`
  static const DsLucideGlyph kayak =
      DsLucideGlyph('kayak', <DsIconElement>[
    DsIconPathElement('M18 17a1 1 0 0 0-1 1v1a2 2 0 1 0 2-2z'), // key: skzb1g
    DsIconPathElement('M20.97 3.61a.45.45 0 0 0-.58-.58C10.2 6.6 6.6 10.2 3.03 20.39a.45.45 0 0 0 .58.58C13.8 17.4 17.4 13.8 20.97 3.61'), // key: cv9jm7
    DsIconPathElement('m6.707 6.707 10.586 10.586'), // key: d2l993
    DsIconPathElement('M7 5a2 2 0 1 0-2 2h1a1 1 0 0 0 1-1z'), // key: i0et4n
  ]);

  /// `key-round.mjs`
  static const DsLucideGlyph keyRound =
      DsLucideGlyph('key-round', <DsIconElement>[
    DsIconPathElement('M2.586 17.414A2 2 0 0 0 2 18.828V21a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h1a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h.172a2 2 0 0 0 1.414-.586l.814-.814a6.5 6.5 0 1 0-4-4z'), // key: 1s6t7t
    DsIconCircleElement(16.5, 7.5, 0.5, filled: true), // key: w0ekpg
  ]);

  /// `key-square.mjs`
  static const DsLucideGlyph keySquare =
      DsLucideGlyph('key-square', <DsIconElement>[
    DsIconPathElement('M12.4 2.7a2.5 2.5 0 0 1 3.4 0l5.5 5.5a2.5 2.5 0 0 1 0 3.4l-3.7 3.7a2.5 2.5 0 0 1-3.4 0L8.7 9.8a2.5 2.5 0 0 1 0-3.4z'), // key: 165ttr
    DsIconPathElement('m14 7 3 3'), // key: 1r5n42
    DsIconPathElement('m9.4 10.6-6.814 6.814A2 2 0 0 0 2 18.828V21a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h1a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h.172a2 2 0 0 0 1.414-.586l.814-.814'), // key: 1ubxi2
  ]);

  /// `key.mjs`
  static const DsLucideGlyph key =
      DsLucideGlyph('key', <DsIconElement>[
    DsIconPathElement('m15.5 7.5 2.3 2.3a1 1 0 0 0 1.4 0l2.1-2.1a1 1 0 0 0 0-1.4L19 4'), // key: g0fldk
    DsIconPathElement('m21 2-9.6 9.6'), // key: 1j0ho8
    DsIconCircleElement(7.5, 15.5, 5.5), // key: yqb3hr
  ]);

  /// `keyboard-music.mjs`
  static const DsLucideGlyph keyboardMusic =
      DsLucideGlyph('keyboard-music', <DsIconElement>[
    DsIconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
    DsIconPathElement('M6 8h4'), // key: utf9t1
    DsIconPathElement('M14 8h.01'), // key: 1primd
    DsIconPathElement('M18 8h.01'), // key: emo2bl
    DsIconPathElement('M2 12h20'), // key: 9i4pu4
    DsIconPathElement('M6 12v4'), // key: dy92yo
    DsIconPathElement('M10 12v4'), // key: 1fxnav
    DsIconPathElement('M14 12v4'), // key: 1hft58
    DsIconPathElement('M18 12v4'), // key: tjjnbz
  ]);

  /// `keyboard-off.mjs`
  static const DsLucideGlyph keyboardOff =
      DsLucideGlyph('keyboard-off', <DsIconElement>[
    DsIconPathElement('M 20 4 A2 2 0 0 1 22 6'), // key: 1g1fkt
    DsIconPathElement('M 22 6 L 22 16.41'), // key: 1qjg3w
    DsIconPathElement('M 7 16 L 16 16'), // key: n0yqwb
    DsIconPathElement('M 9.69 4 L 20 4'), // key: kbpcgx
    DsIconPathElement('M14 8h.01'), // key: 1primd
    DsIconPathElement('M18 8h.01'), // key: emo2bl
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M20 20H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2'), // key: s23sx2
    DsIconPathElement('M6 8h.01'), // key: x9i8wu
    DsIconPathElement('M8 12h.01'), // key: czm47f
  ]);

  /// `keyboard.mjs`
  static const DsLucideGlyph keyboard =
      DsLucideGlyph('keyboard', <DsIconElement>[
    DsIconPathElement('M10 8h.01'), // key: 1r9ogq
    DsIconPathElement('M12 12h.01'), // key: 1mp3jc
    DsIconPathElement('M14 8h.01'), // key: 1primd
    DsIconPathElement('M16 12h.01'), // key: 1l6xoz
    DsIconPathElement('M18 8h.01'), // key: emo2bl
    DsIconPathElement('M6 8h.01'), // key: x9i8wu
    DsIconPathElement('M7 16h10'), // key: wp8him
    DsIconPathElement('M8 12h.01'), // key: czm47f
    DsIconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
  ]);

  /// `lamp-ceiling.mjs`
  static const DsLucideGlyph lampCeiling =
      DsLucideGlyph('lamp-ceiling', <DsIconElement>[
    DsIconPathElement('M12 2v5'), // key: nd4vlx
    DsIconPathElement('M14.829 15.998a3 3 0 1 1-5.658 0'), // key: 1pybiy
    DsIconPathElement('M20.92 14.606A1 1 0 0 1 20 16H4a1 1 0 0 1-.92-1.394l3-7A1 1 0 0 1 7 7h10a1 1 0 0 1 .92.606z'), // key: ma1wor
  ]);

  /// `lamp-desk.mjs`
  static const DsLucideGlyph lampDesk =
      DsLucideGlyph('lamp-desk', <DsIconElement>[
    DsIconPathElement('M10.293 2.293a1 1 0 0 1 1.414 0l2.5 2.5 5.994 1.227a1 1 0 0 1 .506 1.687l-7 7a1 1 0 0 1-1.687-.506l-1.227-5.994-2.5-2.5a1 1 0 0 1 0-1.414z'), // key: sb8slu
    DsIconPathElement('m14.207 4.793-3.414 3.414'), // key: m2x3oj
    DsIconPathElement('M3 20a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1z'), // key: 8b3myj
    DsIconPathElement('m9.086 6.5-4.793 4.793a1 1 0 0 0-.18 1.17L7 18'), // key: 43s6cu
  ]);

  /// `lamp-floor.mjs`
  static const DsLucideGlyph lampFloor =
      DsLucideGlyph('lamp-floor', <DsIconElement>[
    DsIconPathElement('M12 10v12'), // key: 6ubwww
    DsIconPathElement('M17.929 7.629A1 1 0 0 1 17 9H7a1 1 0 0 1-.928-1.371l2-5A1 1 0 0 1 9 2h6a1 1 0 0 1 .928.629z'), // key: 1o95gh
    DsIconPathElement('M9 22h6'), // key: 1rlq3v
  ]);

  /// `lamp-wall-down.mjs`
  static const DsLucideGlyph lampWallDown =
      DsLucideGlyph('lamp-wall-down', <DsIconElement>[
    DsIconPathElement('M19.929 18.629A1 1 0 0 1 19 20H9a1 1 0 0 1-.928-1.371l2-5A1 1 0 0 1 11 13h6a1 1 0 0 1 .928.629z'), // key: u4w2d7
    DsIconPathElement('M6 3a2 2 0 0 1 2 2v2a2 2 0 0 1-2 2H5a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1z'), // key: 15356w
    DsIconPathElement('M8 6h4a2 2 0 0 1 2 2v5'), // key: 1m6m7x
  ]);

  /// `lamp-wall-up.mjs`
  static const DsLucideGlyph lampWallUp =
      DsLucideGlyph('lamp-wall-up', <DsIconElement>[
    DsIconPathElement('M19.929 9.629A1 1 0 0 1 19 11H9a1 1 0 0 1-.928-1.371l2-5A1 1 0 0 1 11 4h6a1 1 0 0 1 .928.629z'), // key: 1uvrbf
    DsIconPathElement('M6 15a2 2 0 0 1 2 2v2a2 2 0 0 1-2 2H5a1 1 0 0 1-1-1v-4a1 1 0 0 1 1-1z'), // key: 154r2a
    DsIconPathElement('M8 18h4a2 2 0 0 0 2-2v-5'), // key: z9mbu0
  ]);

  /// `lamp.mjs`
  static const DsLucideGlyph lamp =
      DsLucideGlyph('lamp', <DsIconElement>[
    DsIconPathElement('M12 12v6'), // key: 3ahymv
    DsIconPathElement('M4.077 10.615A1 1 0 0 0 5 12h14a1 1 0 0 0 .923-1.385l-3.077-7.384A2 2 0 0 0 15 2H9a2 2 0 0 0-1.846 1.23Z'), // key: 1l7kg2
    DsIconPathElement('M8 20a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v1a1 1 0 0 1-1 1H9a1 1 0 0 1-1-1z'), // key: 1mmzpi
  ]);

  /// `land-plot.mjs`
  static const DsLucideGlyph landPlot =
      DsLucideGlyph('land-plot', <DsIconElement>[
    DsIconPathElement('m12 8 6-3-6-3v10'), // key: mvpnpy
    DsIconPathElement('m8 11.99-5.5 3.14a1 1 0 0 0 0 1.74l8.5 4.86a2 2 0 0 0 2 0l8.5-4.86a1 1 0 0 0 0-1.74L16 12'), // key: ek95tt
    DsIconPathElement('m6.49 12.85 11.02 6.3'), // key: 1kt42w
    DsIconPathElement('M17.51 12.85 6.5 19.15'), // key: v55bdg
  ]);

  /// `landmark.mjs`
  static const DsLucideGlyph landmark =
      DsLucideGlyph('landmark', <DsIconElement>[
    DsIconPathElement('M10 18v-7'), // key: wt116b
    DsIconPathElement('M11.119 2.205a2 2 0 0 1 1.762 0l7.84 3.846A.5.5 0 0 1 20.5 7h-17a.5.5 0 0 1-.22-.949z'), // key: yxxwt6
    DsIconPathElement('M14 18v-7'), // key: vav6t3
    DsIconPathElement('M18 18v-7'), // key: aexdmj
    DsIconPathElement('M3 22h18'), // key: 8prr45
    DsIconPathElement('M6 18v-7'), // key: 1ivflk
  ]);

  /// `languages.mjs`
  static const DsLucideGlyph languages =
      DsLucideGlyph('languages', <DsIconElement>[
    DsIconPathElement('m5 8 6 6'), // key: 1wu5hv
    DsIconPathElement('m4 14 6-6 2-3'), // key: 1k1g8d
    DsIconPathElement('M2 5h12'), // key: or177f
    DsIconPathElement('M7 2h1'), // key: 1t2jsx
    DsIconPathElement('m22 22-5-10-5 10'), // key: don7ne
    DsIconPathElement('M14 18h6'), // key: 1m8k6r
  ]);

  /// `laptop-minimal-check.mjs`
  static const DsLucideGlyph laptopMinimalCheck =
      DsLucideGlyph('laptop-minimal-check', <DsIconElement>[
    DsIconPathElement('M2 20h20'), // key: owomy5
    DsIconPathElement('m9 10 2 2 4-4'), // key: 1gnqz4
    DsIconRectElement(3, 4, 18, 12, 2), // key: 8ur36m
  ]);

  /// `laptop-minimal.mjs`
  static const DsLucideGlyph laptopMinimal =
      DsLucideGlyph('laptop-minimal', <DsIconElement>[
    DsIconRectElement(3, 4, 18, 12, 2, ry: 2), // key: 1qhy41
    DsIconLineElement(2, 20, 22, 20), // key: ni3hll
  ]);

  /// `laptop.mjs`
  static const DsLucideGlyph laptop =
      DsLucideGlyph('laptop', <DsIconElement>[
    DsIconPathElement('M18 5a2 2 0 0 1 2 2v8.526a2 2 0 0 0 .212.897l1.068 2.127a1 1 0 0 1-.9 1.45H3.62a1 1 0 0 1-.9-1.45l1.068-2.127A2 2 0 0 0 4 15.526V7a2 2 0 0 1 2-2z'), // key: 1pdavp
    DsIconPathElement('M20.054 15.987H3.946'), // key: 14rxg9
  ]);

  /// `lasso-select.mjs`
  static const DsLucideGlyph lassoSelect =
      DsLucideGlyph('lasso-select', <DsIconElement>[
    DsIconPathElement('M7 22a5 5 0 0 1-2-4'), // key: umushi
    DsIconPathElement('M7 16.93c.96.43 1.96.74 2.99.91'), // key: ybbtv3
    DsIconPathElement('M3.34 14A6.8 6.8 0 0 1 2 10c0-4.42 4.48-8 10-8s10 3.58 10 8a7.19 7.19 0 0 1-.33 2'), // key: gt5e1w
    DsIconPathElement('M5 18a2 2 0 1 0 0-4 2 2 0 0 0 0 4z'), // key: bq3ynw
    DsIconPathElement('M14.33 22h-.09a.35.35 0 0 1-.24-.32v-10a.34.34 0 0 1 .33-.34c.08 0 .15.03.21.08l7.34 6a.33.33 0 0 1-.21.59h-4.49l-2.57 3.85a.35.35 0 0 1-.28.14z'), // key: 72q637
  ]);

  /// `lasso.mjs`
  static const DsLucideGlyph lasso =
      DsLucideGlyph('lasso', <DsIconElement>[
    DsIconPathElement('M3.704 14.467a10 8 0 1 1 3.115 2.375'), // key: wxgc5m
    DsIconPathElement('M7 22a5 5 0 0 1-2-3.994'), // key: 1xp6a4
    DsIconCircleElement(5, 16, 2), // key: 18csp3
  ]);

  /// `laugh.mjs`
  static const DsLucideGlyph laugh =
      DsLucideGlyph('laugh', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M18 13a6 6 0 0 1-6 5 6 6 0 0 1-6-5h12Z'), // key: b2q4dd
    DsIconLineElement(9, 9, 9.01, 9), // key: yxxnd0
    DsIconLineElement(15, 9, 15.01, 9), // key: 1p4y9e
  ]);

  /// `layers-2.mjs`
  static const DsLucideGlyph layers2 =
      DsLucideGlyph('layers-2', <DsIconElement>[
    DsIconPathElement('M13 13.74a2 2 0 0 1-2 0L2.5 8.87a1 1 0 0 1 0-1.74L11 2.26a2 2 0 0 1 2 0l8.5 4.87a1 1 0 0 1 0 1.74z'), // key: 15q6uc
    DsIconPathElement('m20 14.285 1.5.845a1 1 0 0 1 0 1.74L13 21.74a2 2 0 0 1-2 0l-8.5-4.87a1 1 0 0 1 0-1.74l1.5-.845'), // key: byia6g
  ]);

  /// `layers-minus.mjs`
  static const DsLucideGlyph layersMinus =
      DsLucideGlyph('layers-minus', <DsIconElement>[
    DsIconPathElement('M12.83 2.18a2 2 0 0 0-1.66 0L2.6 6.08a1 1 0 0 0 0 1.83l8.58 3.91a2 2 0 0 0 .83.18 2 2 0 0 0 .83-.18l8.58-3.9a1 1 0 0 0 0-1.832z'), // key: tq134k
    DsIconPathElement('M16 17h6'), // key: 1ook5g
    DsIconPathElement('M2.003 11.995a1 1 0 0 0 .597.915l8.58 3.91a2 2 0 0 0 .83.18'), // key: 8mjqed
    DsIconPathElement('M2.003 16.995a1 1 0 0 0 .597.915l8.58 3.91a2 2 0 0 0 .83.18 2 2 0 0 0 .83-.18l2.11-.96'), // key: 7vwz41
    DsIconPathElement('M22.018 12.004a1 1 0 0 1-.598.916l-.177.08'), // key: bm5b9y
  ]);

  /// `layers-plus.mjs`
  static const DsLucideGlyph layersPlus =
      DsLucideGlyph('layers-plus', <DsIconElement>[
    DsIconPathElement('M12.83 2.18a2 2 0 0 0-1.66 0L2.6 6.08a1 1 0 0 0 0 1.83l8.58 3.91a2 2 0 0 0 .83.18 2 2 0 0 0 .83-.18l8.58-3.9a1 1 0 0 0 0-1.831z'), // key: zzgyd3
    DsIconPathElement('M16 17h6'), // key: 1ook5g
    DsIconPathElement('M19 14v6'), // key: 1ckrd5
    DsIconPathElement('M2 12a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 .825.178'), // key: 1ia9y3
    DsIconPathElement('M2 17a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 1.65 0l2.116-.962'), // key: jksky3
  ]);

  /// `layers.mjs`
  static const DsLucideGlyph layers =
      DsLucideGlyph('layers', <DsIconElement>[
    DsIconPathElement('M12.83 2.18a2 2 0 0 0-1.66 0L2.6 6.08a1 1 0 0 0 0 1.83l8.58 3.91a2 2 0 0 0 1.66 0l8.58-3.9a1 1 0 0 0 0-1.83z'), // key: zw3jo
    DsIconPathElement('M2 12a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 1.65 0l8.58-3.9A1 1 0 0 0 22 12'), // key: 1wduqc
    DsIconPathElement('M2 17a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 1.65 0l8.58-3.9A1 1 0 0 0 22 17'), // key: kqbvx6
  ]);

  /// `layout-dashboard.mjs`
  static const DsLucideGlyph layoutDashboard =
      DsLucideGlyph('layout-dashboard', <DsIconElement>[
    DsIconRectElement(3, 3, 7, 9, 1), // key: 10lvy0
    DsIconRectElement(14, 3, 7, 5, 1), // key: 16une8
    DsIconRectElement(14, 12, 7, 9, 1), // key: 1hutg5
    DsIconRectElement(3, 16, 7, 5, 1), // key: ldoo1y
  ]);

  /// `layout-freeform.mjs`
  static const DsLucideGlyph layoutFreeform =
      DsLucideGlyph('layout-freeform', <DsIconElement>[
    DsIconRectElement(3, 3, 7, 7, 1), // key: 1g98yp
    DsIconRectElement(14, 4, 7, 7, 1), // key: n7b4zl
    DsIconRectElement(4, 14, 7, 7, 1), // key: 1ngf42
  ]);

  /// `layout-grid.mjs`
  static const DsLucideGlyph layoutGrid =
      DsLucideGlyph('layout-grid', <DsIconElement>[
    DsIconRectElement(3, 3, 7, 7, 1), // key: 1g98yp
    DsIconRectElement(14, 3, 7, 7, 1), // key: 6d4xhi
    DsIconRectElement(14, 14, 7, 7, 1), // key: nxv5o0
    DsIconRectElement(3, 14, 7, 7, 1), // key: 1bb6yr
  ]);

  /// `layout-list.mjs`
  static const DsLucideGlyph layoutList =
      DsLucideGlyph('layout-list', <DsIconElement>[
    DsIconRectElement(3, 3, 7, 7, 1), // key: 1g98yp
    DsIconRectElement(3, 14, 7, 7, 1), // key: 1bb6yr
    DsIconPathElement('M14 4h7'), // key: 3xa0d5
    DsIconPathElement('M14 9h7'), // key: 1icrd9
    DsIconPathElement('M14 15h7'), // key: 1mj8o2
    DsIconPathElement('M14 20h7'), // key: 11slyb
  ]);

  /// `layout-panel-left.mjs`
  static const DsLucideGlyph layoutPanelLeft =
      DsLucideGlyph('layout-panel-left', <DsIconElement>[
    DsIconRectElement(3, 3, 7, 18, 1), // key: 2obqm
    DsIconRectElement(14, 3, 7, 7, 1), // key: 6d4xhi
    DsIconRectElement(14, 14, 7, 7, 1), // key: nxv5o0
  ]);

  /// `layout-panel-top.mjs`
  static const DsLucideGlyph layoutPanelTop =
      DsLucideGlyph('layout-panel-top', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 7, 1), // key: f1a2em
    DsIconRectElement(3, 14, 7, 7, 1), // key: 1bb6yr
    DsIconRectElement(14, 14, 7, 7, 1), // key: nxv5o0
  ]);

  /// `layout-template.mjs`
  static const DsLucideGlyph layoutTemplate =
      DsLucideGlyph('layout-template', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 7, 1), // key: f1a2em
    DsIconRectElement(3, 14, 9, 7, 1), // key: jqznyg
    DsIconRectElement(16, 14, 5, 7, 1), // key: q5h2i8
  ]);

  /// `leaf.mjs`
  static const DsLucideGlyph leaf =
      DsLucideGlyph('leaf', <DsIconElement>[
    DsIconPathElement('M11 20A7 7 0 0 1 9.8 6.1C15.5 5 17 4.48 19 2c1 2 2 4.18 2 8 0 5.5-4.78 10-10 10Z'), // key: nnexq3
    DsIconPathElement('M2 21c0-3 1.85-5.36 5.08-6C9.5 14.52 12 13 13 12'), // key: mt58a7
  ]);

  /// `leafy-green.mjs`
  static const DsLucideGlyph leafyGreen =
      DsLucideGlyph('leafy-green', <DsIconElement>[
    DsIconPathElement('M2 22c1.25-.987 2.27-1.975 3.9-2.2a5.56 5.56 0 0 1 3.8 1.5 4 4 0 0 0 6.187-2.353 3.5 3.5 0 0 0 3.69-5.116A3.5 3.5 0 0 0 20.95 8 3.5 3.5 0 1 0 16 3.05a3.5 3.5 0 0 0-5.831 1.373 3.5 3.5 0 0 0-5.116 3.69 4 4 0 0 0-2.348 6.155C3.499 15.42 4.409 16.712 4.2 18.1 3.926 19.743 3.014 20.732 2 22'), // key: 1134nt
    DsIconPathElement('M2 22 17 7'), // key: 1q7jp2
  ]);

  /// `lectern.mjs`
  static const DsLucideGlyph lectern =
      DsLucideGlyph('lectern', <DsIconElement>[
    DsIconPathElement('M16 12h3a2 2 0 0 0 1.902-1.38l1.056-3.333A1 1 0 0 0 21 6H3a1 1 0 0 0-.958 1.287l1.056 3.334A2 2 0 0 0 5 12h3'), // key: 13jjxg
    DsIconPathElement('M18 6V3a1 1 0 0 0-1-1h-3'), // key: 1550fe
    DsIconRectElement(8, 10, 8, 12, 1), // key: qmu8b6
  ]);

  /// `lens-concave.mjs`
  static const DsLucideGlyph lensConcave =
      DsLucideGlyph('lens-concave', <DsIconElement>[
    DsIconPathElement('M7 2a1 1 0 0 0-.8 1.6 14 14 0 0 1 0 16.8A1 1 0 0 0 7 22h10a1 1 0 0 0 .8-1.6 14 14 0 0 1 0-16.8A1 1 0 0 0 17 2z'), // key: 109j23
  ]);

  /// `lens-convex.mjs`
  static const DsLucideGlyph lensConvex =
      DsLucideGlyph('lens-convex', <DsIconElement>[
    DsIconPathElement('M13.433 2a1 1 0 0 1 .824.448 18 18 0 0 1 0 19.104 1 1 0 0 1-.824.448h-2.866a1 1 0 0 1-.824-.448 18 18 0 0 1 0-19.104A1 1 0 0 1 10.567 2z'), // key: cq67go
  ]);

  /// `library-big.mjs`
  static const DsLucideGlyph libraryBig =
      DsLucideGlyph('library-big', <DsIconElement>[
    DsIconRectElement(3, 3, 8, 18, 1), // key: oynpb5
    DsIconPathElement('M7 3v18'), // key: bbkbws
    DsIconPathElement('M20.4 18.9c.2.5-.1 1.1-.6 1.3l-1.9.7c-.5.2-1.1-.1-1.3-.6L11.1 5.1c-.2-.5.1-1.1.6-1.3l1.9-.7c.5-.2 1.1.1 1.3.6Z'), // key: 1qboyk
  ]);

  /// `library.mjs`
  static const DsLucideGlyph library =
      DsLucideGlyph('library', <DsIconElement>[
    DsIconPathElement('m16 6 4 14'), // key: ji33uf
    DsIconPathElement('M12 6v14'), // key: 1n7gus
    DsIconPathElement('M8 8v12'), // key: 1gg7y9
    DsIconPathElement('M4 4v16'), // key: 6qkkli
  ]);

  /// `life-buoy.mjs`
  static const DsLucideGlyph lifeBuoy =
      DsLucideGlyph('life-buoy', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('m4.93 4.93 4.24 4.24'), // key: 1ymg45
    DsIconPathElement('m14.83 9.17 4.24-4.24'), // key: 1cb5xl
    DsIconPathElement('m14.83 14.83 4.24 4.24'), // key: q42g0n
    DsIconPathElement('m9.17 14.83-4.24 4.24'), // key: bqpfvv
    DsIconCircleElement(12, 12, 4), // key: 4exip2
  ]);

  /// `ligature.mjs`
  static const DsLucideGlyph ligature =
      DsLucideGlyph('ligature', <DsIconElement>[
    DsIconPathElement('M14 12h2v8'), // key: c1fccl
    DsIconPathElement('M14 20h4'), // key: lzx1xo
    DsIconPathElement('M6 12h4'), // key: a4o3ry
    DsIconPathElement('M6 20h4'), // key: 1i6q5t
    DsIconPathElement('M8 20V8a4 4 0 0 1 7.464-2'), // key: wk9t6r
  ]);

  /// `lightbulb-off.mjs`
  static const DsLucideGlyph lightbulbOff =
      DsLucideGlyph('lightbulb-off', <DsIconElement>[
    DsIconPathElement('M16.8 11.2c.8-.9 1.2-2 1.2-3.2a6 6 0 0 0-9.3-5'), // key: 1fkcox
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M6.3 6.3a4.67 4.67 0 0 0 1.2 5.2c.7.7 1.3 1.5 1.5 2.5'), // key: 10m8kw
    DsIconPathElement('M9 18h6'), // key: x1upvd
    DsIconPathElement('M10 22h4'), // key: ceow96
  ]);

  /// `lightbulb.mjs`
  static const DsLucideGlyph lightbulb =
      DsLucideGlyph('lightbulb', <DsIconElement>[
    DsIconPathElement('M15 14c.2-1 .7-1.7 1.5-2.5 1-.9 1.5-2.2 1.5-3.5A6 6 0 0 0 6 8c0 1 .2 2.2 1.5 3.5.7.7 1.3 1.5 1.5 2.5'), // key: 1gvzjb
    DsIconPathElement('M9 18h6'), // key: x1upvd
    DsIconPathElement('M10 22h4'), // key: ceow96
  ]);

  /// `line-dot-right-horizontal.mjs`
  static const DsLucideGlyph lineDotRightHorizontal =
      DsLucideGlyph('line-dot-right-horizontal', <DsIconElement>[
    DsIconPathElement('M 3 12 L 15 12'), // key: ymhu98
    DsIconCircleElement(18, 12, 3), // key: 1kchzo
  ]);

  /// `line-squiggle.mjs`
  static const DsLucideGlyph lineSquiggle =
      DsLucideGlyph('line-squiggle', <DsIconElement>[
    DsIconPathElement('M7 3.5c5-2 7 2.5 3 4C1.5 10 2 15 5 16c5 2 9-10 14-7s.5 13.5-4 12c-5-2.5.5-11 6-2'), // key: 1lrphd
  ]);

  /// `line-style.mjs`
  static const DsLucideGlyph lineStyle =
      DsLucideGlyph('line-style', <DsIconElement>[
    DsIconPathElement('M11 5h2'), // key: 1s6z07
    DsIconPathElement('M15 12h6'), // key: upa0zy
    DsIconPathElement('M19 5h2'), // key: fjylsg
    DsIconPathElement('M3 12h6'), // key: ra68u1
    DsIconPathElement('M3 19h18'), // key: awlh7x
    DsIconPathElement('M3 5h2'), // key: 1qgu90
  ]);

  /// `link-2-off.mjs`
  static const DsLucideGlyph link2Off =
      DsLucideGlyph('link-2-off', <DsIconElement>[
    DsIconPathElement('M9 17H7A5 5 0 0 1 7 7'), // key: 10o201
    DsIconPathElement('M15 7h2a5 5 0 0 1 4 8'), // key: 1d3206
    DsIconLineElement(8, 12, 12, 12), // key: rvw6j4
    DsIconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `link-2.mjs`
  static const DsLucideGlyph link2 =
      DsLucideGlyph('link-2', <DsIconElement>[
    DsIconPathElement('M9 17H7A5 5 0 0 1 7 7h2'), // key: 8i5ue5
    DsIconPathElement('M15 7h2a5 5 0 1 1 0 10h-2'), // key: 1b9ql8
    DsIconLineElement(8, 12, 16, 12), // key: 1jonct
  ]);

  /// `link.mjs`
  static const DsLucideGlyph link =
      DsLucideGlyph('link', <DsIconElement>[
    DsIconPathElement('M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71'), // key: 1cjeqo
    DsIconPathElement('M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71'), // key: 19qd67
  ]);

  /// `list-check.mjs`
  static const DsLucideGlyph listCheck =
      DsLucideGlyph('list-check', <DsIconElement>[
    DsIconPathElement('M16 5H3'), // key: m91uny
    DsIconPathElement('M16 12H3'), // key: 1a2rj7
    DsIconPathElement('M11 19H3'), // key: zflm78
    DsIconPathElement('m15 18 2 2 4-4'), // key: 1szwhi
  ]);

  /// `list-checks.mjs`
  static const DsLucideGlyph listChecks =
      DsLucideGlyph('list-checks', <DsIconElement>[
    DsIconPathElement('M13 5h8'), // key: a7qcls
    DsIconPathElement('M13 12h8'), // key: h98zly
    DsIconPathElement('M13 19h8'), // key: c3s6r1
    DsIconPathElement('m3 17 2 2 4-4'), // key: 1jhpwq
    DsIconPathElement('m3 7 2 2 4-4'), // key: 1obspn
  ]);

  /// `list-chevrons-down-up.mjs`
  static const DsLucideGlyph listChevronsDownUp =
      DsLucideGlyph('list-chevrons-down-up', <DsIconElement>[
    DsIconPathElement('M3 5h8'), // key: 18g2rq
    DsIconPathElement('M3 12h8'), // key: 1xfjp6
    DsIconPathElement('M3 19h8'), // key: fpbke4
    DsIconPathElement('m15 5 3 3 3-3'), // key: 1t4thf
    DsIconPathElement('m15 19 3-3 3 3'), // key: y4ckd2
  ]);

  /// `list-chevrons-up-down.mjs`
  static const DsLucideGlyph listChevronsUpDown =
      DsLucideGlyph('list-chevrons-up-down', <DsIconElement>[
    DsIconPathElement('M3 5h8'), // key: 18g2rq
    DsIconPathElement('M3 12h8'), // key: 1xfjp6
    DsIconPathElement('M3 19h8'), // key: fpbke4
    DsIconPathElement('m15 8 3-3 3 3'), // key: bc4io6
    DsIconPathElement('m15 16 3 3 3-3'), // key: 9wmg1l
  ]);

  /// `list-collapse.mjs`
  static const DsLucideGlyph listCollapse =
      DsLucideGlyph('list-collapse', <DsIconElement>[
    DsIconPathElement('M10 5h11'), // key: 1hkqpe
    DsIconPathElement('M10 12h11'), // key: 6m4ad9
    DsIconPathElement('M10 19h11'), // key: 14g2nv
    DsIconPathElement('m3 10 3-3-3-3'), // key: i7pm08
    DsIconPathElement('m3 20 3-3-3-3'), // key: 20gx1n
  ]);

  /// `list-end.mjs`
  static const DsLucideGlyph listEnd =
      DsLucideGlyph('list-end', <DsIconElement>[
    DsIconPathElement('M16 5H3'), // key: m91uny
    DsIconPathElement('M16 12H3'), // key: 1a2rj7
    DsIconPathElement('M9 19H3'), // key: s61nz1
    DsIconPathElement('m16 16-3 3 3 3'), // key: 117b85
    DsIconPathElement('M21 5v12a2 2 0 0 1-2 2h-6'), // key: hey24a
  ]);

  /// `list-filter-plus.mjs`
  static const DsLucideGlyph listFilterPlus =
      DsLucideGlyph('list-filter-plus', <DsIconElement>[
    DsIconPathElement('M12 5H2'), // key: 1o22fu
    DsIconPathElement('M6 12h12'), // key: 8npq4p
    DsIconPathElement('M9 19h6'), // key: 456am0
    DsIconPathElement('M16 5h6'), // key: 1vod17
    DsIconPathElement('M19 8V2'), // key: 1wcffq
  ]);

  /// `list-filter.mjs`
  static const DsLucideGlyph listFilter =
      DsLucideGlyph('list-filter', <DsIconElement>[
    DsIconPathElement('M2 5h20'), // key: 1fs1ex
    DsIconPathElement('M6 12h12'), // key: 8npq4p
    DsIconPathElement('M9 19h6'), // key: 456am0
  ]);

  /// `list-indent-decrease.mjs`
  static const DsLucideGlyph listIndentDecrease =
      DsLucideGlyph('list-indent-decrease', <DsIconElement>[
    DsIconPathElement('M21 5H11'), // key: us1j55
    DsIconPathElement('M21 12H11'), // key: wd7e0v
    DsIconPathElement('M21 19H11'), // key: saa85w
    DsIconPathElement('m7 8-4 4 4 4'), // key: o5hrat
  ]);

  /// `list-indent-increase.mjs`
  static const DsLucideGlyph listIndentIncrease =
      DsLucideGlyph('list-indent-increase', <DsIconElement>[
    DsIconPathElement('M21 5H11'), // key: us1j55
    DsIconPathElement('M21 12H11'), // key: wd7e0v
    DsIconPathElement('M21 19H11'), // key: saa85w
    DsIconPathElement('m3 8 4 4-4 4'), // key: 1a3j6y
  ]);

  /// `list-minus.mjs`
  static const DsLucideGlyph listMinus =
      DsLucideGlyph('list-minus', <DsIconElement>[
    DsIconPathElement('M16 5H3'), // key: m91uny
    DsIconPathElement('M11 12H3'), // key: 51ecnj
    DsIconPathElement('M16 19H3'), // key: zzsher
    DsIconPathElement('M21 12h-6'), // key: bt1uis
  ]);

  /// `list-music.mjs`
  static const DsLucideGlyph listMusic =
      DsLucideGlyph('list-music', <DsIconElement>[
    DsIconPathElement('M16 5H3'), // key: m91uny
    DsIconPathElement('M11 12H3'), // key: 51ecnj
    DsIconPathElement('M11 19H3'), // key: zflm78
    DsIconPathElement('M21 16V5'), // key: yxg4q8
    DsIconCircleElement(18, 16, 3), // key: 1hluhg
  ]);

  /// `list-ordered.mjs`
  static const DsLucideGlyph listOrdered =
      DsLucideGlyph('list-ordered', <DsIconElement>[
    DsIconPathElement('M11 5h10'), // key: 1cz7ny
    DsIconPathElement('M11 12h10'), // key: 1438ji
    DsIconPathElement('M11 19h10'), // key: 11t30w
    DsIconPathElement('M4 4h1v5'), // key: 10yrso
    DsIconPathElement('M4 9h2'), // key: r1h2o0
    DsIconPathElement('M6.5 20H3.4c0-1 2.6-1.925 2.6-3.5a1.5 1.5 0 0 0-2.6-1.02'), // key: xtkcd5
  ]);

  /// `list-plus.mjs`
  static const DsLucideGlyph listPlus =
      DsLucideGlyph('list-plus', <DsIconElement>[
    DsIconPathElement('M16 5H3'), // key: m91uny
    DsIconPathElement('M11 12H3'), // key: 51ecnj
    DsIconPathElement('M16 19H3'), // key: zzsher
    DsIconPathElement('M18 9v6'), // key: 1twb98
    DsIconPathElement('M21 12h-6'), // key: bt1uis
  ]);

  /// `list-restart.mjs`
  static const DsLucideGlyph listRestart =
      DsLucideGlyph('list-restart', <DsIconElement>[
    DsIconPathElement('M21 5H3'), // key: 1fi0y6
    DsIconPathElement('M7 12H3'), // key: 13ou7f
    DsIconPathElement('M7 19H3'), // key: wbqt3n
    DsIconPathElement('M12 18a5 5 0 0 0 9-3 4.5 4.5 0 0 0-4.5-4.5c-1.33 0-2.54.54-3.41 1.41L11 14'), // key: qth677
    DsIconPathElement('M11 10v4h4'), // key: 172dkj
  ]);

  /// `list-sort-ascending.mjs`
  static const DsLucideGlyph listSortAscending =
      DsLucideGlyph('list-sort-ascending', <DsIconElement>[
    DsIconPathElement('M3 19h18'), // key: awlh7x
    DsIconPathElement('M15 12H3'), // key: 6jk70r
    DsIconPathElement('M9 5H3'), // key: 15j2za
  ]);

  /// `list-sort-descending.mjs`
  static const DsLucideGlyph listSortDescending =
      DsLucideGlyph('list-sort-descending', <DsIconElement>[
    DsIconPathElement('M15 12H3'), // key: 6jk70r
    DsIconPathElement('M3 5h18'), // key: 1u36vt
    DsIconPathElement('M9 19H3'), // key: s61nz1
  ]);

  /// `list-start.mjs`
  static const DsLucideGlyph listStart =
      DsLucideGlyph('list-start', <DsIconElement>[
    DsIconPathElement('M3 5h6'), // key: 1ltk0q
    DsIconPathElement('M3 12h13'), // key: ppymz1
    DsIconPathElement('M3 19h13'), // key: bpdczq
    DsIconPathElement('m16 8-3-3 3-3'), // key: 1pjpp6
    DsIconPathElement('M21 19V7a2 2 0 0 0-2-2h-6'), // key: 4zzq67
  ]);

  /// `list-todo.mjs`
  static const DsLucideGlyph listTodo =
      DsLucideGlyph('list-todo', <DsIconElement>[
    DsIconPathElement('M13 5h8'), // key: a7qcls
    DsIconPathElement('M13 12h8'), // key: h98zly
    DsIconPathElement('M13 19h8'), // key: c3s6r1
    DsIconPathElement('m3 17 2 2 4-4'), // key: 1jhpwq
    DsIconRectElement(3, 4, 6, 6, 1), // key: cif1o7
  ]);

  /// `list-tree.mjs`
  static const DsLucideGlyph listTree =
      DsLucideGlyph('list-tree', <DsIconElement>[
    DsIconPathElement('M8 5h13'), // key: 1pao27
    DsIconPathElement('M13 12h8'), // key: h98zly
    DsIconPathElement('M13 19h8'), // key: c3s6r1
    DsIconPathElement('M3 10a2 2 0 0 0 2 2h3'), // key: 1npucw
    DsIconPathElement('M3 5v12a2 2 0 0 0 2 2h3'), // key: x1gjn2
  ]);

  /// `list-video.mjs`
  static const DsLucideGlyph listVideo =
      DsLucideGlyph('list-video', <DsIconElement>[
    DsIconPathElement('M21 5H3'), // key: 1fi0y6
    DsIconPathElement('M10 12H3'), // key: 1ulcyk
    DsIconPathElement('M10 19H3'), // key: 108z41
    DsIconPathElement('M15 12.003a1 1 0 0 1 1.517-.859l4.997 2.997a1 1 0 0 1 0 1.718l-4.997 2.997a1 1 0 0 1-1.517-.86z'), // key: ms4nik
  ]);

  /// `list-x.mjs`
  static const DsLucideGlyph listX =
      DsLucideGlyph('list-x', <DsIconElement>[
    DsIconPathElement('M16 5H3'), // key: m91uny
    DsIconPathElement('M11 12H3'), // key: 51ecnj
    DsIconPathElement('M16 19H3'), // key: zzsher
    DsIconPathElement('m15.5 9.5 5 5'), // key: ytk86i
    DsIconPathElement('m20.5 9.5-5 5'), // key: 17o44f
  ]);

  /// `list.mjs`
  static const DsLucideGlyph list =
      DsLucideGlyph('list', <DsIconElement>[
    DsIconPathElement('M3 5h.01'), // key: 18ugdj
    DsIconPathElement('M3 12h.01'), // key: nlz23k
    DsIconPathElement('M3 19h.01'), // key: noohij
    DsIconPathElement('M8 5h13'), // key: 1pao27
    DsIconPathElement('M8 12h13'), // key: 1za7za
    DsIconPathElement('M8 19h13'), // key: m83p4d
  ]);

  /// `loader-circle.mjs`
  static const DsLucideGlyph loaderCircle =
      DsLucideGlyph('loader-circle', <DsIconElement>[
    DsIconPathElement('M21 12a9 9 0 1 1-6.219-8.56'), // key: 13zald
  ]);

  /// `loader-pinwheel.mjs`
  static const DsLucideGlyph loaderPinwheel =
      DsLucideGlyph('loader-pinwheel', <DsIconElement>[
    DsIconPathElement('M22 12a1 1 0 0 1-10 0 1 1 0 0 0-10 0'), // key: 1lzz15
    DsIconPathElement('M7 20.7a1 1 0 1 1 5-8.7 1 1 0 1 0 5-8.6'), // key: 1gnrpi
    DsIconPathElement('M7 3.3a1 1 0 1 1 5 8.6 1 1 0 1 0 5 8.6'), // key: u9yy5q
    DsIconCircleElement(12, 12, 10), // key: 1mglay
  ]);

  /// `loader.mjs`
  static const DsLucideGlyph loader =
      DsLucideGlyph('loader', <DsIconElement>[
    DsIconPathElement('M12 2v4'), // key: 3427ic
    DsIconPathElement('m16.2 7.8 2.9-2.9'), // key: r700ao
    DsIconPathElement('M18 12h4'), // key: wj9ykh
    DsIconPathElement('m16.2 16.2 2.9 2.9'), // key: 1bxg5t
    DsIconPathElement('M12 18v4'), // key: jadmvz
    DsIconPathElement('m4.9 19.1 2.9-2.9'), // key: bwix9q
    DsIconPathElement('M2 12h4'), // key: j09sii
    DsIconPathElement('m4.9 4.9 2.9 2.9'), // key: giyufr
  ]);

  /// `locate-fixed.mjs`
  static const DsLucideGlyph locateFixed =
      DsLucideGlyph('locate-fixed', <DsIconElement>[
    DsIconLineElement(2, 12, 5, 12), // key: bvdh0s
    DsIconLineElement(19, 12, 22, 12), // key: 1tbv5k
    DsIconLineElement(12, 2, 12, 5), // key: 11lu5j
    DsIconLineElement(12, 19, 12, 22), // key: x3vr5v
    DsIconCircleElement(12, 12, 7), // key: fim9np
    DsIconCircleElement(12, 12, 3), // key: 1v7zrd
  ]);

  /// `locate-off.mjs`
  static const DsLucideGlyph locateOff =
      DsLucideGlyph('locate-off', <DsIconElement>[
    DsIconPathElement('M12 19v3'), // key: npa21l
    DsIconPathElement('M12 2v3'), // key: qbqxhf
    DsIconPathElement('M18.89 13.24a7 7 0 0 0-8.13-8.13'), // key: 1v9jrh
    DsIconPathElement('M19 12h3'), // key: osuazr
    DsIconPathElement('M2 12h3'), // key: 1wrr53
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M7.05 7.05a7 7 0 0 0 9.9 9.9'), // key: rc5l2e
  ]);

  /// `locate.mjs`
  static const DsLucideGlyph locate =
      DsLucideGlyph('locate', <DsIconElement>[
    DsIconLineElement(2, 12, 5, 12), // key: bvdh0s
    DsIconLineElement(19, 12, 22, 12), // key: 1tbv5k
    DsIconLineElement(12, 2, 12, 5), // key: 11lu5j
    DsIconLineElement(12, 19, 12, 22), // key: x3vr5v
    DsIconCircleElement(12, 12, 7), // key: fim9np
  ]);

  /// `lock-keyhole-open.mjs`
  static const DsLucideGlyph lockKeyholeOpen =
      DsLucideGlyph('lock-keyhole-open', <DsIconElement>[
    DsIconCircleElement(12, 16, 1), // key: 1au0dj
    DsIconRectElement(3, 10, 18, 12, 2), // key: l0tzu3
    DsIconPathElement('M7 10V7a5 5 0 0 1 9.33-2.5'), // key: car5b7
  ]);

  /// `lock-keyhole.mjs`
  static const DsLucideGlyph lockKeyhole =
      DsLucideGlyph('lock-keyhole', <DsIconElement>[
    DsIconCircleElement(12, 16, 1), // key: 1au0dj
    DsIconRectElement(3, 10, 18, 12, 2), // key: 6s8ecr
    DsIconPathElement('M7 10V7a5 5 0 0 1 10 0v3'), // key: 1pqi11
  ]);

  /// `lock-open.mjs`
  static const DsLucideGlyph lockOpen =
      DsLucideGlyph('lock-open', <DsIconElement>[
    DsIconRectElement(3, 11, 18, 11, 2, ry: 2), // key: 1w4ew1
    DsIconPathElement('M7 11V7a5 5 0 0 1 9.9-1'), // key: 1mm8w8
  ]);

  /// `lock.mjs`
  static const DsLucideGlyph lock =
      DsLucideGlyph('lock', <DsIconElement>[
    DsIconRectElement(3, 11, 18, 11, 2, ry: 2), // key: 1w4ew1
    DsIconPathElement('M7 11V7a5 5 0 0 1 10 0v4'), // key: fwvmzm
  ]);

  /// `log-in.mjs`
  static const DsLucideGlyph logIn =
      DsLucideGlyph('log-in', <DsIconElement>[
    DsIconPathElement('m10 17 5-5-5-5'), // key: 1bsop3
    DsIconPathElement('M15 12H3'), // key: 6jk70r
    DsIconPathElement('M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4'), // key: u53s6r
  ]);

  /// `log-out.mjs`
  static const DsLucideGlyph logOut =
      DsLucideGlyph('log-out', <DsIconElement>[
    DsIconPathElement('m16 17 5-5-5-5'), // key: 1bji2h
    DsIconPathElement('M21 12H9'), // key: dn1m92
    DsIconPathElement('M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4'), // key: 1uf3rs
  ]);

  /// `logs.mjs`
  static const DsLucideGlyph logs =
      DsLucideGlyph('logs', <DsIconElement>[
    DsIconPathElement('M3 5h1'), // key: 1mv5vm
    DsIconPathElement('M3 12h1'), // key: lp3yf2
    DsIconPathElement('M3 19h1'), // key: w6f3n9
    DsIconPathElement('M8 5h1'), // key: 1nxr5w
    DsIconPathElement('M8 12h1'), // key: 1con00
    DsIconPathElement('M8 19h1'), // key: k7p10e
    DsIconPathElement('M13 5h8'), // key: a7qcls
    DsIconPathElement('M13 12h8'), // key: h98zly
    DsIconPathElement('M13 19h8'), // key: c3s6r1
  ]);

  /// `lollipop.mjs`
  static const DsLucideGlyph lollipop =
      DsLucideGlyph('lollipop', <DsIconElement>[
    DsIconCircleElement(11, 11, 8), // key: 4ej97u
    DsIconPathElement('m21 21-4.3-4.3'), // key: 1qie3q
    DsIconPathElement('M11 11a2 2 0 0 0 4 0 4 4 0 0 0-8 0 6 6 0 0 0 12 0'), // key: 107gwy
  ]);

  /// `luggage.mjs`
  static const DsLucideGlyph luggage =
      DsLucideGlyph('luggage', <DsIconElement>[
    DsIconPathElement('M6 20a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2'), // key: 1m57jg
    DsIconPathElement('M8 18V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v14'), // key: 1l99gc
    DsIconPathElement('M10 20h4'), // key: ni2waw
    DsIconCircleElement(16, 20, 2), // key: 1vifvg
    DsIconCircleElement(8, 20, 2), // key: ckkr5m
  ]);

  /// `magnet.mjs`
  static const DsLucideGlyph magnet =
      DsLucideGlyph('magnet', <DsIconElement>[
    DsIconPathElement('m12 15 4 4'), // key: lnac28
    DsIconPathElement('M2.352 10.648a1.205 1.205 0 0 0 0 1.704l2.296 2.296a1.205 1.205 0 0 0 1.704 0l6.029-6.029a1 1 0 1 1 3 3l-6.029 6.029a1.205 1.205 0 0 0 0 1.704l2.296 2.296a1.205 1.205 0 0 0 1.704 0l6.365-6.367A1 1 0 0 0 8.716 4.282z'), // key: nlhkjb
    DsIconPathElement('m5 8 4 4'), // key: j6kj7e
  ]);

  /// `mail-check.mjs`
  static const DsLucideGlyph mailCheck =
      DsLucideGlyph('mail-check', <DsIconElement>[
    DsIconPathElement('M22 13V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h8'), // key: 12jkf8
    DsIconPathElement('m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7'), // key: 1ocrg3
    DsIconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
  ]);

  /// `mail-minus.mjs`
  static const DsLucideGlyph mailMinus =
      DsLucideGlyph('mail-minus', <DsIconElement>[
    DsIconPathElement('M22 15V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h8'), // key: fuxbkv
    DsIconPathElement('m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7'), // key: 1ocrg3
    DsIconPathElement('M16 19h6'), // key: xwg31i
  ]);

  /// `mail-open.mjs`
  static const DsLucideGlyph mailOpen =
      DsLucideGlyph('mail-open', <DsIconElement>[
    DsIconPathElement('M21.2 8.4c.5.38.8.97.8 1.6v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V10a2 2 0 0 1 .8-1.6l8-6a2 2 0 0 1 2.4 0l8 6Z'), // key: 1jhwl8
    DsIconPathElement('m22 10-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 10'), // key: 1qfld7
  ]);

  /// `mail-plus.mjs`
  static const DsLucideGlyph mailPlus =
      DsLucideGlyph('mail-plus', <DsIconElement>[
    DsIconPathElement('M22 13V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h8'), // key: 12jkf8
    DsIconPathElement('m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7'), // key: 1ocrg3
    DsIconPathElement('M19 16v6'), // key: tddt3s
    DsIconPathElement('M16 19h6'), // key: xwg31i
  ]);

  /// `mail-question-mark.mjs`
  static const DsLucideGlyph mailQuestionMark =
      DsLucideGlyph('mail-question-mark', <DsIconElement>[
    DsIconPathElement('M22 10.5V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h12.5'), // key: e61zoh
    DsIconPathElement('m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7'), // key: 1ocrg3
    DsIconPathElement('M18 15.28c.2-.4.5-.8.9-1a2.1 2.1 0 0 1 2.6.4c.3.4.5.8.5 1.3 0 1.3-2 2-2 2'), // key: 7z9rxb
    DsIconPathElement('M20 22v.01'), // key: 12bgn6
  ]);

  /// `mail-search.mjs`
  static const DsLucideGlyph mailSearch =
      DsLucideGlyph('mail-search', <DsIconElement>[
    DsIconPathElement('M22 12.5V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h7.5'), // key: w80f2v
    DsIconPathElement('m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7'), // key: 1ocrg3
    DsIconPathElement('M18 21a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z'), // key: 8lzu5m
    DsIconCircleElement(18, 18, 3), // key: 1xkwt0
    DsIconPathElement('m22 22-1.5-1.5'), // key: 1x83k4
  ]);

  /// `mail-warning.mjs`
  static const DsLucideGlyph mailWarning =
      DsLucideGlyph('mail-warning', <DsIconElement>[
    DsIconPathElement('M22 10.5V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h12.5'), // key: e61zoh
    DsIconPathElement('m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7'), // key: 1ocrg3
    DsIconPathElement('M20 14v4'), // key: 1hm744
    DsIconPathElement('M20 22v.01'), // key: 12bgn6
  ]);

  /// `mail-x.mjs`
  static const DsLucideGlyph mailX =
      DsLucideGlyph('mail-x', <DsIconElement>[
    DsIconPathElement('M22 13V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v12c0 1.1.9 2 2 2h9'), // key: 1j9vog
    DsIconPathElement('m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7'), // key: 1ocrg3
    DsIconPathElement('m17 17 4 4'), // key: 1b3523
    DsIconPathElement('m21 17-4 4'), // key: uinynz
  ]);

  /// `mail.mjs`
  static const DsLucideGlyph mail =
      DsLucideGlyph('mail', <DsIconElement>[
    DsIconPathElement('m22 7-8.991 5.727a2 2 0 0 1-2.009 0L2 7'), // key: 132q7q
    DsIconRectElement(2, 4, 20, 16, 2), // key: izxlao
  ]);

  /// `mailbox.mjs`
  static const DsLucideGlyph mailbox =
      DsLucideGlyph('mailbox', <DsIconElement>[
    DsIconPathElement('M22 17a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V9.5C2 7 4 5 6.5 5H18c2.2 0 4 1.8 4 4v8Z'), // key: 1lbycx
    DsIconPolylineElement(<Offset>[Offset(15, 9), Offset(18, 9), Offset(18, 11)]), // key: 1pm9c0
    DsIconPathElement('M6.5 5C9 5 11 7 11 9.5V17a2 2 0 0 1-2 2'), // key: 15i455
    DsIconLineElement(6, 10, 7, 10), // key: 1e2scm
  ]);

  /// `mails.mjs`
  static const DsLucideGlyph mails =
      DsLucideGlyph('mails', <DsIconElement>[
    DsIconPathElement('M17 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-8a2 2 0 0 1 1-1.732'), // key: 1vyzll
    DsIconPathElement('m22 5.5-6.419 4.179a2 2 0 0 1-2.162 0L7 5.5'), // key: k7ramc
    DsIconRectElement(7, 3, 15, 12, 2), // key: 17196g
  ]);

  /// `map-minus.mjs`
  static const DsLucideGlyph mapMinus =
      DsLucideGlyph('map-minus', <DsIconElement>[
    DsIconPathElement('m11 19-1.106-.552a2 2 0 0 0-1.788 0l-3.659 1.83A1 1 0 0 1 3 19.381V6.618a1 1 0 0 1 .553-.894l4.553-2.277a2 2 0 0 1 1.788 0l4.212 2.106a2 2 0 0 0 1.788 0l3.659-1.83A1 1 0 0 1 21 4.619V14'), // key: 40pylx
    DsIconPathElement('M15 5.764V14'), // key: 1bab71
    DsIconPathElement('M21 18h-6'), // key: 139f0c
    DsIconPathElement('M9 3.236v15'), // key: 1uimfh
  ]);

  /// `map-pin-check-inside.mjs`
  static const DsLucideGlyph mapPinCheckInside =
      DsLucideGlyph('map-pin-check-inside', <DsIconElement>[
    DsIconPathElement('M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0'), // key: 1r0f0z
    DsIconPathElement('m9 10 2 2 4-4'), // key: 1gnqz4
  ]);

  /// `map-pin-check.mjs`
  static const DsLucideGlyph mapPinCheck =
      DsLucideGlyph('map-pin-check', <DsIconElement>[
    DsIconPathElement('M19.43 12.935c.357-.967.57-1.955.57-2.935a8 8 0 0 0-16 0c0 4.993 5.539 10.193 7.399 11.799a1 1 0 0 0 1.202 0 32.197 32.197 0 0 0 .813-.728'), // key: 1dq61d
    DsIconCircleElement(12, 10, 3), // key: ilqhr7
    DsIconPathElement('m16 18 2 2 4-4'), // key: 1mkfmb
  ]);

  /// `map-pin-house.mjs`
  static const DsLucideGlyph mapPinHouse =
      DsLucideGlyph('map-pin-house', <DsIconElement>[
    DsIconPathElement('M15 22a1 1 0 0 1-1-1v-4a1 1 0 0 1 .445-.832l3-2a1 1 0 0 1 1.11 0l3 2A1 1 0 0 1 22 17v4a1 1 0 0 1-1 1z'), // key: 1p1rcz
    DsIconPathElement('M18 10a8 8 0 0 0-16 0c0 4.993 5.539 10.193 7.399 11.799a1 1 0 0 0 .601.2'), // key: mcbcs9
    DsIconPathElement('M18 22v-3'), // key: 1t1ugv
    DsIconCircleElement(10, 10, 3), // key: 1ns7v1
  ]);

  /// `map-pin-minus-inside.mjs`
  static const DsLucideGlyph mapPinMinusInside =
      DsLucideGlyph('map-pin-minus-inside', <DsIconElement>[
    DsIconPathElement('M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0'), // key: 1r0f0z
    DsIconPathElement('M9 10h6'), // key: 9gxzsh
  ]);

  /// `map-pin-minus.mjs`
  static const DsLucideGlyph mapPinMinus =
      DsLucideGlyph('map-pin-minus', <DsIconElement>[
    DsIconPathElement('M18.977 14C19.6 12.701 20 11.343 20 10a8 8 0 0 0-16 0c0 4.993 5.539 10.193 7.399 11.799a1 1 0 0 0 1.202 0 32 32 0 0 0 .824-.738'), // key: 11uxia
    DsIconCircleElement(12, 10, 3), // key: ilqhr7
    DsIconPathElement('M16 18h6'), // key: 987eiv
  ]);

  /// `map-pin-off.mjs`
  static const DsLucideGlyph mapPinOff =
      DsLucideGlyph('map-pin-off', <DsIconElement>[
    DsIconPathElement('M12.75 7.09a3 3 0 0 1 2.16 2.16'), // key: 1d4wjd
    DsIconPathElement('M17.072 17.072c-1.634 2.17-3.527 3.912-4.471 4.727a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 1.432-4.568'), // key: 12yil7
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M8.475 2.818A8 8 0 0 1 20 10c0 1.183-.31 2.377-.81 3.533'), // key: lhrkcz
    DsIconPathElement('M9.13 9.13a3 3 0 0 0 3.74 3.74'), // key: 13wojd
  ]);

  /// `map-pin-pen.mjs`
  static const DsLucideGlyph mapPinPen =
      DsLucideGlyph('map-pin-pen', <DsIconElement>[
    DsIconPathElement('M17.97 9.304A8 8 0 0 0 2 10c0 4.69 4.887 9.562 7.022 11.468'), // key: 1fahp3
    DsIconPathElement('M21.378 16.626a1 1 0 0 0-3.004-3.004l-4.01 4.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z'), // key: 1817ys
    DsIconCircleElement(10, 10, 3), // key: 1ns7v1
  ]);

  /// `map-pin-plus-inside.mjs`
  static const DsLucideGlyph mapPinPlusInside =
      DsLucideGlyph('map-pin-plus-inside', <DsIconElement>[
    DsIconPathElement('M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0'), // key: 1r0f0z
    DsIconPathElement('M12 7v6'), // key: lw1j43
    DsIconPathElement('M9 10h6'), // key: 9gxzsh
  ]);

  /// `map-pin-plus.mjs`
  static const DsLucideGlyph mapPinPlus =
      DsLucideGlyph('map-pin-plus', <DsIconElement>[
    DsIconPathElement('M19.914 11.105A7.298 7.298 0 0 0 20 10a8 8 0 0 0-16 0c0 4.993 5.539 10.193 7.399 11.799a1 1 0 0 0 1.202 0 32 32 0 0 0 .824-.738'), // key: fcdtly
    DsIconCircleElement(12, 10, 3), // key: ilqhr7
    DsIconPathElement('M16 18h6'), // key: 987eiv
    DsIconPathElement('M19 15v6'), // key: 10aioa
  ]);

  /// `map-pin-search.mjs`
  static const DsLucideGlyph mapPinSearch =
      DsLucideGlyph('map-pin-search', <DsIconElement>[
    DsIconPathElement('M 12.248 21.969 a 1 1 0 0 1 -0.849 -0.17 C 9.539 20.193 4 14.993 4 10 a 8 8 0 0 1 16 0 C 20 10.42 19.961 10.841 19.888 11.262'), // key: 1jho5b
    DsIconPathElement('m22 22-1.88-1.88'), // key: 1bgjp0
    DsIconCircleElement(12, 10, 3), // key: ilqhr7
    DsIconCircleElement(18, 18, 3), // key: 1xkwt0
  ]);

  /// `map-pin-x-inside.mjs`
  static const DsLucideGlyph mapPinXInside =
      DsLucideGlyph('map-pin-x-inside', <DsIconElement>[
    DsIconPathElement('M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0'), // key: 1r0f0z
    DsIconPathElement('m14.5 7.5-5 5'), // key: 3lb6iw
    DsIconPathElement('m9.5 7.5 5 5'), // key: ko136h
  ]);

  /// `map-pin-x.mjs`
  static const DsLucideGlyph mapPinX =
      DsLucideGlyph('map-pin-x', <DsIconElement>[
    DsIconPathElement('M19.752 11.901A7.78 7.78 0 0 0 20 10a8 8 0 0 0-16 0c0 4.993 5.539 10.193 7.399 11.799a1 1 0 0 0 1.202 0 19 19 0 0 0 .09-.077'), // key: y0ewhp
    DsIconCircleElement(12, 10, 3), // key: ilqhr7
    DsIconPathElement('m21.5 15.5-5 5'), // key: 11iqnx
    DsIconPathElement('m21.5 20.5-5-5'), // key: 1bylgx
  ]);

  /// `map-pin.mjs`
  static const DsLucideGlyph mapPin =
      DsLucideGlyph('map-pin', <DsIconElement>[
    DsIconPathElement('M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0'), // key: 1r0f0z
    DsIconCircleElement(12, 10, 3), // key: ilqhr7
  ]);

  /// `map-pinned.mjs`
  static const DsLucideGlyph mapPinned =
      DsLucideGlyph('map-pinned', <DsIconElement>[
    DsIconPathElement('M18 8c0 3.613-3.869 7.429-5.393 8.795a1 1 0 0 1-1.214 0C9.87 15.429 6 11.613 6 8a6 6 0 0 1 12 0'), // key: 11u0oz
    DsIconCircleElement(12, 8, 2), // key: 1822b1
    DsIconPathElement('M8.714 14h-3.71a1 1 0 0 0-.948.683l-2.004 6A1 1 0 0 0 3 22h18a1 1 0 0 0 .948-1.316l-2-6a1 1 0 0 0-.949-.684h-3.712'), // key: q8zwxj
  ]);

  /// `map-plus.mjs`
  static const DsLucideGlyph mapPlus =
      DsLucideGlyph('map-plus', <DsIconElement>[
    DsIconPathElement('m11 19-1.106-.552a2 2 0 0 0-1.788 0l-3.659 1.83A1 1 0 0 1 3 19.381V6.618a1 1 0 0 1 .553-.894l4.553-2.277a2 2 0 0 1 1.788 0l4.212 2.106a2 2 0 0 0 1.788 0l3.659-1.83A1 1 0 0 1 21 4.619V12'), // key: svfegj
    DsIconPathElement('M15 5.764V12'), // key: 1ocw4k
    DsIconPathElement('M18 15v6'), // key: 9wciyi
    DsIconPathElement('M21 18h-6'), // key: 139f0c
    DsIconPathElement('M9 3.236v15'), // key: 1uimfh
  ]);

  /// `map.mjs`
  static const DsLucideGlyph map =
      DsLucideGlyph('map', <DsIconElement>[
    DsIconPathElement('M14.106 5.553a2 2 0 0 0 1.788 0l3.659-1.83A1 1 0 0 1 21 4.619v12.764a1 1 0 0 1-.553.894l-4.553 2.277a2 2 0 0 1-1.788 0l-4.212-2.106a2 2 0 0 0-1.788 0l-3.659 1.83A1 1 0 0 1 3 19.381V6.618a1 1 0 0 1 .553-.894l4.553-2.277a2 2 0 0 1 1.788 0z'), // key: 169xi5
    DsIconPathElement('M15 5.764v15'), // key: 1pn4in
    DsIconPathElement('M9 3.236v15'), // key: 1uimfh
  ]);

  /// `mars-stroke.mjs`
  static const DsLucideGlyph marsStroke =
      DsLucideGlyph('mars-stroke', <DsIconElement>[
    DsIconPathElement('m14 6 4 4'), // key: 1q72g9
    DsIconPathElement('M17 3h4v4'), // key: 19p9u1
    DsIconPathElement('m21 3-7.75 7.75'), // key: 1cjbfd
    DsIconCircleElement(9, 15, 6), // key: bx5svt
  ]);

  /// `mars.mjs`
  static const DsLucideGlyph mars =
      DsLucideGlyph('mars', <DsIconElement>[
    DsIconPathElement('M16 3h5v5'), // key: 1806ms
    DsIconPathElement('m21 3-6.75 6.75'), // key: pv0uzu
    DsIconCircleElement(10, 14, 6), // key: 1qwbdc
  ]);

  /// `martini.mjs`
  static const DsLucideGlyph martini =
      DsLucideGlyph('martini', <DsIconElement>[
    DsIconPathElement('M12 12 4.207 4.207A.707.707 0 0 1 4.707 3h14.586a.707.707 0 0 1 .5 1.207z'), // key: vxdekd
    DsIconPathElement('M12 12v10'), // key: 1nesaz
    DsIconPathElement('M7 22h10'), // key: 10w4w3
  ]);

  /// `maximize-2.mjs`
  static const DsLucideGlyph maximize2 =
      DsLucideGlyph('maximize-2', <DsIconElement>[
    DsIconPathElement('M15 3h6v6'), // key: 1q9fwt
    DsIconPathElement('m21 3-7 7'), // key: 1l2asr
    DsIconPathElement('m3 21 7-7'), // key: tjx5ai
    DsIconPathElement('M9 21H3v-6'), // key: wtvkvv
  ]);

  /// `maximize.mjs`
  static const DsLucideGlyph maximize =
      DsLucideGlyph('maximize', <DsIconElement>[
    DsIconPathElement('M8 3H5a2 2 0 0 0-2 2v3'), // key: 1dcmit
    DsIconPathElement('M21 8V5a2 2 0 0 0-2-2h-3'), // key: 1e4gt3
    DsIconPathElement('M3 16v3a2 2 0 0 0 2 2h3'), // key: wsl5sc
    DsIconPathElement('M16 21h3a2 2 0 0 0 2-2v-3'), // key: 18trek
  ]);

  /// `medal.mjs`
  static const DsLucideGlyph medal =
      DsLucideGlyph('medal', <DsIconElement>[
    DsIconPathElement('M7.21 15 2.66 7.14a2 2 0 0 1 .13-2.2L4.4 2.8A2 2 0 0 1 6 2h12a2 2 0 0 1 1.6.8l1.6 2.14a2 2 0 0 1 .14 2.2L16.79 15'), // key: 143lza
    DsIconPathElement('M11 12 5.12 2.2'), // key: qhuxz6
    DsIconPathElement('m13 12 5.88-9.8'), // key: hbye0f
    DsIconPathElement('M8 7h8'), // key: i86dvs
    DsIconCircleElement(12, 17, 5), // key: qbz8iq
    DsIconPathElement('M12 18v-2h-.5'), // key: fawc4q
  ]);

  /// `megaphone-off.mjs`
  static const DsLucideGlyph megaphoneOff =
      DsLucideGlyph('megaphone-off', <DsIconElement>[
    DsIconPathElement('M11.636 6A13 13 0 0 0 19.4 3.2 1 1 0 0 1 21 4v11.344'), // key: bycexp
    DsIconPathElement('M14.378 14.357A13 13 0 0 0 11 14H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h1'), // key: 1t17s6
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M6 14a12 12 0 0 0 2.4 7.2 2 2 0 0 0 3.2-2.4A8 8 0 0 1 10 14'), // key: 1853fq
    DsIconPathElement('M8 8v6'), // key: aieo6v
  ]);

  /// `megaphone.mjs`
  static const DsLucideGlyph megaphone =
      DsLucideGlyph('megaphone', <DsIconElement>[
    DsIconPathElement('M11 6a13 13 0 0 0 8.4-2.8A1 1 0 0 1 21 4v12a1 1 0 0 1-1.6.8A13 13 0 0 0 11 14H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2z'), // key: q8bfy3
    DsIconPathElement('M6 14a12 12 0 0 0 2.4 7.2 2 2 0 0 0 3.2-2.4A8 8 0 0 1 10 14'), // key: 1853fq
    DsIconPathElement('M8 6v8'), // key: 15ugcq
  ]);

  /// `meh.mjs`
  static const DsLucideGlyph meh =
      DsLucideGlyph('meh', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconLineElement(8, 15, 16, 15), // key: 1xb1d9
    DsIconLineElement(9, 9, 9.01, 9), // key: yxxnd0
    DsIconLineElement(15, 9, 15.01, 9), // key: 1p4y9e
  ]);

  /// `memory-stick.mjs`
  static const DsLucideGlyph memoryStick =
      DsLucideGlyph('memory-stick', <DsIconElement>[
    DsIconPathElement('M12 12v-2'), // key: fwoke6
    DsIconPathElement('M12 18v-2'), // key: qj6yno
    DsIconPathElement('M16 12v-2'), // key: heuere
    DsIconPathElement('M16 18v-2'), // key: s1ct0w
    DsIconPathElement('M2 11h1.5'), // key: 15p63e
    DsIconPathElement('M20 18v-2'), // key: 12ehxp
    DsIconPathElement('M20.5 11H22'), // key: khsy7a
    DsIconPathElement('M4 18v-2'), // key: 1c3oqr
    DsIconPathElement('M8 12v-2'), // key: 1mwtfd
    DsIconPathElement('M8 18v-2'), // key: qcmpov
    DsIconRectElement(2, 6, 20, 10, 2), // key: 1qcswk
  ]);

  /// `menu.mjs`
  static const DsLucideGlyph menu =
      DsLucideGlyph('menu', <DsIconElement>[
    DsIconPathElement('M4 5h16'), // key: 1tepv9
    DsIconPathElement('M4 12h16'), // key: 1lakjw
    DsIconPathElement('M4 19h16'), // key: 1djgab
  ]);

  /// `merge.mjs`
  static const DsLucideGlyph merge =
      DsLucideGlyph('merge', <DsIconElement>[
    DsIconPathElement('m8 6 4-4 4 4'), // key: ybng9g
    DsIconPathElement('M12 2v10.3a4 4 0 0 1-1.172 2.872L4 22'), // key: 1hyw0i
    DsIconPathElement('m20 22-5-5'), // key: 1m27yz
  ]);

  /// `message-circle-check.mjs`
  static const DsLucideGlyph messageCircleCheck =
      DsLucideGlyph('message-circle-check', <DsIconElement>[
    DsIconPathElement('M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719'), // key: 1sd12s
    DsIconPathElement('m9 12 2 2 4-4'), // key: dzmm74
  ]);

  /// `message-circle-code.mjs`
  static const DsLucideGlyph messageCircleCode =
      DsLucideGlyph('message-circle-code', <DsIconElement>[
    DsIconPathElement('m10 9-3 3 3 3'), // key: 1oro0q
    DsIconPathElement('m14 15 3-3-3-3'), // key: bz13h7
    DsIconPathElement('M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719'), // key: 1sd12s
  ]);

  /// `message-circle-dashed.mjs`
  static const DsLucideGlyph messageCircleDashed =
      DsLucideGlyph('message-circle-dashed', <DsIconElement>[
    DsIconPathElement('M10.1 2.182a10 10 0 0 1 3.8 0'), // key: 5ilxe3
    DsIconPathElement('M13.9 21.818a10 10 0 0 1-3.8 0'), // key: 11zvb9
    DsIconPathElement('M17.609 3.72a10 10 0 0 1 2.69 2.7'), // key: jiglxs
    DsIconPathElement('M2.182 13.9a10 10 0 0 1 0-3.8'), // key: c0bmvh
    DsIconPathElement('M20.28 17.61a10 10 0 0 1-2.7 2.69'), // key: elg7ff
    DsIconPathElement('M21.818 10.1a10 10 0 0 1 0 3.8'), // key: qkgqxc
    DsIconPathElement('M3.721 6.391a10 10 0 0 1 2.7-2.69'), // key: 1mcia2
    DsIconPathElement('m6.163 21.117-2.906.85a1 1 0 0 1-1.236-1.169l.965-2.98'), // key: 1qsu07
  ]);

  /// `message-circle-heart.mjs`
  static const DsLucideGlyph messageCircleHeart =
      DsLucideGlyph('message-circle-heart', <DsIconElement>[
    DsIconPathElement('M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719'), // key: 1sd12s
    DsIconPathElement('M7.828 13.07A3 3 0 0 1 12 8.764a3 3 0 0 1 5.004 2.224 3 3 0 0 1-.832 2.083l-3.447 3.62a1 1 0 0 1-1.45-.001z'), // key: hoo97p
  ]);

  /// `message-circle-more.mjs`
  static const DsLucideGlyph messageCircleMore =
      DsLucideGlyph('message-circle-more', <DsIconElement>[
    DsIconPathElement('M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719'), // key: 1sd12s
    DsIconPathElement('M8 12h.01'), // key: czm47f
    DsIconPathElement('M12 12h.01'), // key: 1mp3jc
    DsIconPathElement('M16 12h.01'), // key: 1l6xoz
  ]);

  /// `message-circle-off.mjs`
  static const DsLucideGlyph messageCircleOff =
      DsLucideGlyph('message-circle-off', <DsIconElement>[
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M4.93 4.929a10 10 0 0 0-1.938 11.412 2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 0 0 11.302-1.989'), // key: 7il5tn
    DsIconPathElement('M8.35 2.69A10 10 0 0 1 21.3 15.65'), // key: 1pfsoa
  ]);

  /// `message-circle-plus.mjs`
  static const DsLucideGlyph messageCirclePlus =
      DsLucideGlyph('message-circle-plus', <DsIconElement>[
    DsIconPathElement('M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719'), // key: 1sd12s
    DsIconPathElement('M8 12h8'), // key: 1wcyev
    DsIconPathElement('M12 8v8'), // key: napkw2
  ]);

  /// `message-circle-question-mark.mjs`
  static const DsLucideGlyph messageCircleQuestionMark =
      DsLucideGlyph('message-circle-question-mark', <DsIconElement>[
    DsIconPathElement('M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719'), // key: 1sd12s
    DsIconPathElement('M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3'), // key: 1u773s
    DsIconPathElement('M12 17h.01'), // key: p32p05
  ]);

  /// `message-circle-reply.mjs`
  static const DsLucideGlyph messageCircleReply =
      DsLucideGlyph('message-circle-reply', <DsIconElement>[
    DsIconPathElement('M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719'), // key: 1sd12s
    DsIconPathElement('m10 15-3-3 3-3'), // key: 1pgupc
    DsIconPathElement('M7 12h8a2 2 0 0 1 2 2v1'), // key: 89sh1g
  ]);

  /// `message-circle-warning.mjs`
  static const DsLucideGlyph messageCircleWarning =
      DsLucideGlyph('message-circle-warning', <DsIconElement>[
    DsIconPathElement('M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719'), // key: 1sd12s
    DsIconPathElement('M12 8v4'), // key: 1got3b
    DsIconPathElement('M12 16h.01'), // key: 1drbdi
  ]);

  /// `message-circle-x.mjs`
  static const DsLucideGlyph messageCircleX =
      DsLucideGlyph('message-circle-x', <DsIconElement>[
    DsIconPathElement('M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719'), // key: 1sd12s
    DsIconPathElement('m15 9-6 6'), // key: 1uzhvr
    DsIconPathElement('m9 9 6 6'), // key: z0biqf
  ]);

  /// `message-circle.mjs`
  static const DsLucideGlyph messageCircle =
      DsLucideGlyph('message-circle', <DsIconElement>[
    DsIconPathElement('M2.992 16.342a2 2 0 0 1 .094 1.167l-1.065 3.29a1 1 0 0 0 1.236 1.168l3.413-.998a2 2 0 0 1 1.099.092 10 10 0 1 0-4.777-4.719'), // key: 1sd12s
  ]);

  /// `message-square-check.mjs`
  static const DsLucideGlyph messageSquareCheck =
      DsLucideGlyph('message-square-check', <DsIconElement>[
    DsIconPathElement('M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.7.7 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z'), // key: m0kn7k
    DsIconPathElement('m9 11 2 2 4-4'), // key: kz4plv
  ]);

  /// `message-square-code.mjs`
  static const DsLucideGlyph messageSquareCode =
      DsLucideGlyph('message-square-code', <DsIconElement>[
    DsIconPathElement('M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z'), // key: 18887p
    DsIconPathElement('m10 8-3 3 3 3'), // key: fp6dz7
    DsIconPathElement('m14 14 3-3-3-3'), // key: 1yrceu
  ]);

  /// `message-square-dashed.mjs`
  static const DsLucideGlyph messageSquareDashed =
      DsLucideGlyph('message-square-dashed', <DsIconElement>[
    DsIconPathElement('M14 3h2'), // key: 1d12a5
    DsIconPathElement('M16 19h-2'), // key: 1agirb
    DsIconPathElement('M2 12v-2'), // key: 1ey295
    DsIconPathElement('M2 16v5.286a.71.71 0 0 0 1.212.502l1.149-1.149'), // key: 120k8q
    DsIconPathElement('M20 19a2 2 0 0 0 2-2v-1'), // key: ior8tn
    DsIconPathElement('M22 10v2'), // key: rmlecy
    DsIconPathElement('M22 6V5a2 2 0 0 0-2-2'), // key: sp3k6r
    DsIconPathElement('M4 3a2 2 0 0 0-2 2v1'), // key: 11zt7s
    DsIconPathElement('M8 19h2'), // key: jnunrx
    DsIconPathElement('M8 3h2'), // key: ysbsee
  ]);

  /// `message-square-diff.mjs`
  static const DsLucideGlyph messageSquareDiff =
      DsLucideGlyph('message-square-diff', <DsIconElement>[
    DsIconPathElement('M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z'), // key: 18887p
    DsIconPathElement('M10 15h4'), // key: 192ueg
    DsIconPathElement('M10 9h4'), // key: u4k05v
    DsIconPathElement('M12 7v4'), // key: xawao1
  ]);

  /// `message-square-dot.mjs`
  static const DsLucideGlyph messageSquareDot =
      DsLucideGlyph('message-square-dot', <DsIconElement>[
    DsIconPathElement('M12.7 3H4a2 2 0 0 0-2 2v16.286a.71.71 0 0 0 1.212.502l2.202-2.202A2 2 0 0 1 6.828 19H20a2 2 0 0 0 2-2v-4.7'), // key: wjb7ig
    DsIconCircleElement(19, 6, 3), // key: 108a5v
  ]);

  /// `message-square-heart.mjs`
  static const DsLucideGlyph messageSquareHeart =
      DsLucideGlyph('message-square-heart', <DsIconElement>[
    DsIconPathElement('M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z'), // key: 18887p
    DsIconPathElement('M7.5 9.5c0 .687.265 1.383.697 1.844l3.009 3.264a1.14 1.14 0 0 0 .407.314 1 1 0 0 0 .783-.004 1.14 1.14 0 0 0 .398-.31l3.008-3.264A2.77 2.77 0 0 0 16.5 9.5 2.5 2.5 0 0 0 12 8a2.5 2.5 0 0 0-4.5 1.5'), // key: 1faxuh
  ]);

  /// `message-square-lock.mjs`
  static const DsLucideGlyph messageSquareLock =
      DsLucideGlyph('message-square-lock', <DsIconElement>[
    DsIconPathElement('M22 8.5V5a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v16.286a.71.71 0 0 0 1.212.502l2.202-2.202A2 2 0 0 1 6.828 19H10'), // key: fu6chl
    DsIconPathElement('M20 15v-2a2 2 0 0 0-4 0v2'), // key: vl8a78
    DsIconRectElement(14, 15, 8, 5, 1), // key: 37aafw
  ]);

  /// `message-square-more.mjs`
  static const DsLucideGlyph messageSquareMore =
      DsLucideGlyph('message-square-more', <DsIconElement>[
    DsIconPathElement('M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z'), // key: 18887p
    DsIconPathElement('M12 11h.01'), // key: z322tv
    DsIconPathElement('M16 11h.01'), // key: xkw8gn
    DsIconPathElement('M8 11h.01'), // key: 1dfujw
  ]);

  /// `message-square-off.mjs`
  static const DsLucideGlyph messageSquareOff =
      DsLucideGlyph('message-square-off', <DsIconElement>[
    DsIconPathElement('M19 19H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.7.7 0 0 1 2 21.286V5a2 2 0 0 1 1.184-1.826'), // key: 1wyg69
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M8.656 3H20a2 2 0 0 1 2 2v11.344'), // key: mhl4k6
  ]);

  /// `message-square-plus.mjs`
  static const DsLucideGlyph messageSquarePlus =
      DsLucideGlyph('message-square-plus', <DsIconElement>[
    DsIconPathElement('M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z'), // key: 18887p
    DsIconPathElement('M12 8v6'), // key: 1ib9pf
    DsIconPathElement('M9 11h6'), // key: 1fldmi
  ]);

  /// `message-square-quote.mjs`
  static const DsLucideGlyph messageSquareQuote =
      DsLucideGlyph('message-square-quote', <DsIconElement>[
    DsIconPathElement('M14 14a2 2 0 0 0 2-2V8h-2'), // key: 1r06pg
    DsIconPathElement('M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z'), // key: 18887p
    DsIconPathElement('M8 14a2 2 0 0 0 2-2V8H8'), // key: 1jzu5j
  ]);

  /// `message-square-reply.mjs`
  static const DsLucideGlyph messageSquareReply =
      DsLucideGlyph('message-square-reply', <DsIconElement>[
    DsIconPathElement('M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z'), // key: 18887p
    DsIconPathElement('m10 8-3 3 3 3'), // key: fp6dz7
    DsIconPathElement('M17 14v-1a2 2 0 0 0-2-2H7'), // key: 1tkjnz
  ]);

  /// `message-square-share.mjs`
  static const DsLucideGlyph messageSquareShare =
      DsLucideGlyph('message-square-share', <DsIconElement>[
    DsIconPathElement('M12 3H4a2 2 0 0 0-2 2v16.286a.71.71 0 0 0 1.212.502l2.202-2.202A2 2 0 0 1 6.828 19H20a2 2 0 0 0 2-2v-4'), // key: 11da1y
    DsIconPathElement('M16 3h6v6'), // key: 1bx56c
    DsIconPathElement('m16 9 6-6'), // key: m4dnic
  ]);

  /// `message-square-text.mjs`
  static const DsLucideGlyph messageSquareText =
      DsLucideGlyph('message-square-text', <DsIconElement>[
    DsIconPathElement('M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z'), // key: 18887p
    DsIconPathElement('M7 11h10'), // key: 1twpyw
    DsIconPathElement('M7 15h6'), // key: d9of3u
    DsIconPathElement('M7 7h8'), // key: af5zfr
  ]);

  /// `message-square-warning.mjs`
  static const DsLucideGlyph messageSquareWarning =
      DsLucideGlyph('message-square-warning', <DsIconElement>[
    DsIconPathElement('M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z'), // key: 18887p
    DsIconPathElement('M12 15h.01'), // key: q59x07
    DsIconPathElement('M12 7v4'), // key: xawao1
  ]);

  /// `message-square-x.mjs`
  static const DsLucideGlyph messageSquareX =
      DsLucideGlyph('message-square-x', <DsIconElement>[
    DsIconPathElement('M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z'), // key: 18887p
    DsIconPathElement('m14.5 8.5-5 5'), // key: 19tnj2
    DsIconPathElement('m9.5 8.5 5 5'), // key: 1oa8ql
  ]);

  /// `message-square.mjs`
  static const DsLucideGlyph messageSquare =
      DsLucideGlyph('message-square', <DsIconElement>[
    DsIconPathElement('M22 17a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 21.286V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2z'), // key: 18887p
  ]);

  /// `messages-square.mjs`
  static const DsLucideGlyph messagesSquare =
      DsLucideGlyph('messages-square', <DsIconElement>[
    DsIconPathElement('M16 10a2 2 0 0 1-2 2H6.828a2 2 0 0 0-1.414.586l-2.202 2.202A.71.71 0 0 1 2 14.286V4a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z'), // key: 1n2ejm
    DsIconPathElement('M20 9a2 2 0 0 1 2 2v10.286a.71.71 0 0 1-1.212.502l-2.202-2.202A2 2 0 0 0 17.172 19H10a2 2 0 0 1-2-2v-1'), // key: 1qfcsi
  ]);

  /// `metronome.mjs`
  static const DsLucideGlyph metronome =
      DsLucideGlyph('metronome', <DsIconElement>[
    DsIconPathElement('M12 11.4V9.1'), // key: audfby
    DsIconPathElement('m12 17 6.59-6.59'), // key: c0sb7j
    DsIconPathElement('m15.05 5.7-.218-.691a3 3 0 0 0-5.663 0L4.418 19.695A1 1 0 0 0 5.37 21h13.253a1 1 0 0 0 .951-1.31L18.45 16.2'), // key: 1pkfrk
    DsIconCircleElement(20, 9, 2), // key: 1udoqf
  ]);

  /// `mic-audio-lines.mjs`
  static const DsLucideGlyph micAudioLines =
      DsLucideGlyph('mic-audio-lines', <DsIconElement>[
    DsIconPathElement('M10 3v2.341'), // key: d00509
    DsIconPathElement('M12 17v4'), // key: 1riwvh
    DsIconPathElement('M14 5v.341'), // key: 72nt6x
    DsIconPathElement('M18 5v13'), // key: 123xd1
    DsIconPathElement('M2 10v3'), // key: 1fnikh
    DsIconPathElement('M22 10v3'), // key: 154ddg
    DsIconPathElement('M6 6v11'), // key: 11sgs0
    DsIconPathElement('M9 21h6'), // key: 1udhl7
    DsIconRectElement(10, 9, 4, 8, 2), // key: 1d9qhd
  ]);

  /// `mic-off.mjs`
  static const DsLucideGlyph micOff =
      DsLucideGlyph('mic-off', <DsIconElement>[
    DsIconPathElement('M12 19v3'), // key: npa21l
    DsIconPathElement('M15 9.34V5a3 3 0 0 0-5.68-1.33'), // key: 1gzdoj
    DsIconPathElement('M16.95 16.95A7 7 0 0 1 5 12v-2'), // key: cqa7eg
    DsIconPathElement('M18.89 13.23A7 7 0 0 0 19 12v-2'), // key: 16hl24
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M9 9v3a3 3 0 0 0 5.12 2.12'), // key: r2i35w
  ]);

  /// `mic-signal.mjs`
  static const DsLucideGlyph micSignal =
      DsLucideGlyph('mic-signal', <DsIconElement>[
    DsIconPathElement('M12 17v4'), // key: 1riwvh
    DsIconPathElement('M18 11a6 6 0 00-3-5.197'), // key: 1lvu40
    DsIconPathElement('M2 11a10 10 0 015-8.662'), // key: bida4p
    DsIconPathElement('M22 11a10 10 0 00-5-8.662'), // key: idvinr
    DsIconPathElement('M6 11a6 6 0 013-5.197'), // key: 17n2ii
    DsIconPathElement('M9 21h6'), // key: 1udhl7
    DsIconRectElement(10, 9, 4, 8, 2), // key: 1l8p2f
  ]);

  /// `mic-vocal.mjs`
  static const DsLucideGlyph micVocal =
      DsLucideGlyph('mic-vocal', <DsIconElement>[
    DsIconPathElement('m11 7.601-5.994 8.19a1 1 0 0 0 .1 1.298l.817.818a1 1 0 0 0 1.314.087L15.09 12'), // key: 80a601
    DsIconPathElement('M16.5 21.174C15.5 20.5 14.372 20 13 20c-2.058 0-3.928 2.356-6 2-2.072-.356-2.775-3.369-1.5-4.5'), // key: j0ngtp
    DsIconCircleElement(16, 7, 5), // key: d08jfb
  ]);

  /// `mic.mjs`
  static const DsLucideGlyph mic =
      DsLucideGlyph('mic', <DsIconElement>[
    DsIconPathElement('M12 19v3'), // key: npa21l
    DsIconPathElement('M19 10v2a7 7 0 0 1-14 0v-2'), // key: 1vc78b
    DsIconRectElement(9, 2, 6, 13, 3), // key: s6n7sd
  ]);

  /// `microchip.mjs`
  static const DsLucideGlyph microchip =
      DsLucideGlyph('microchip', <DsIconElement>[
    DsIconPathElement('M10 12h4'), // key: a56b0p
    DsIconPathElement('M10 17h4'), // key: pvmtpo
    DsIconPathElement('M10 7h4'), // key: 1vgcok
    DsIconPathElement('M18 12h2'), // key: quuxs7
    DsIconPathElement('M18 18h2'), // key: 4scel
    DsIconPathElement('M18 6h2'), // key: 1ptzki
    DsIconPathElement('M4 12h2'), // key: 1ltxp0
    DsIconPathElement('M4 18h2'), // key: 1xrofg
    DsIconPathElement('M4 6h2'), // key: 1cx33n
    DsIconRectElement(6, 2, 12, 20, 2), // key: 749fme
  ]);

  /// `microscope.mjs`
  static const DsLucideGlyph microscope =
      DsLucideGlyph('microscope', <DsIconElement>[
    DsIconPathElement('M6 18h8'), // key: 1borvv
    DsIconPathElement('M3 22h18'), // key: 8prr45
    DsIconPathElement('M14 22a7 7 0 1 0 0-14h-1'), // key: 1jwaiy
    DsIconPathElement('M9 14h2'), // key: 197e7h
    DsIconPathElement('M9 12a2 2 0 0 1-2-2V6h6v4a2 2 0 0 1-2 2Z'), // key: 1bmzmy
    DsIconPathElement('M12 6V3a1 1 0 0 0-1-1H9a1 1 0 0 0-1 1v3'), // key: 1drr47
  ]);

  /// `microwave.mjs`
  static const DsLucideGlyph microwave =
      DsLucideGlyph('microwave', <DsIconElement>[
    DsIconRectElement(2, 4, 20, 15, 2), // key: 2no95f
    DsIconRectElement(6, 8, 8, 7, 1), // key: zh9wx
    DsIconPathElement('M18 8v7'), // key: o5zi4n
    DsIconPathElement('M6 19v2'), // key: 1loha6
    DsIconPathElement('M18 19v2'), // key: 1dawf0
  ]);

  /// `milestone.mjs`
  static const DsLucideGlyph milestone =
      DsLucideGlyph('milestone', <DsIconElement>[
    DsIconPathElement('M12 13v8'), // key: 1l5pq0
    DsIconPathElement('M12 3v3'), // key: 1n5kay
    DsIconPathElement('M18.172 6a2 2 0 0 1 1.414.586l2.06 2.06a1.207 1.207 0 0 1 0 1.708l-2.06 2.06a2 2 0 0 1-1.414.586H4a1 1 0 0 1-1-1V7a1 1 0 0 1 1-1z'), // key: 8gz4t4
  ]);

  /// `milk-off.mjs`
  static const DsLucideGlyph milkOff =
      DsLucideGlyph('milk-off', <DsIconElement>[
    DsIconPathElement('M8 2h8'), // key: 1ssgc1
    DsIconPathElement('M9 2v1.343M15 2v2.789a4 4 0 0 0 .672 2.219l.656.984a4 4 0 0 1 .672 2.22v1.131M7.8 7.8l-.128.192A4 4 0 0 0 7 10.212V20a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2v-3'), // key: y0ejgx
    DsIconPathElement('M7 15a6.47 6.47 0 0 1 5 0 6.472 6.472 0 0 0 3.435.435'), // key: iaxqsy
    DsIconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `milk.mjs`
  static const DsLucideGlyph milk =
      DsLucideGlyph('milk', <DsIconElement>[
    DsIconPathElement('M8 2h8'), // key: 1ssgc1
    DsIconPathElement('M9 2v2.789a4 4 0 0 1-.672 2.219l-.656.984A4 4 0 0 0 7 10.212V20a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2v-9.789a4 4 0 0 0-.672-2.219l-.656-.984A4 4 0 0 1 15 4.788V2'), // key: qtp12x
    DsIconPathElement('M7 15a6.472 6.472 0 0 1 5 0 6.47 6.47 0 0 0 5 0'), // key: ygeh44
  ]);

  /// `minimize-2.mjs`
  static const DsLucideGlyph minimize2 =
      DsLucideGlyph('minimize-2', <DsIconElement>[
    DsIconPathElement('m14 10 7-7'), // key: oa77jy
    DsIconPathElement('M20 10h-6V4'), // key: mjg0md
    DsIconPathElement('m3 21 7-7'), // key: tjx5ai
    DsIconPathElement('M4 14h6v6'), // key: rmj7iw
  ]);

  /// `minimize.mjs`
  static const DsLucideGlyph minimize =
      DsLucideGlyph('minimize', <DsIconElement>[
    DsIconPathElement('M8 3v3a2 2 0 0 1-2 2H3'), // key: hohbtr
    DsIconPathElement('M21 8h-3a2 2 0 0 1-2-2V3'), // key: 5jw1f3
    DsIconPathElement('M3 16h3a2 2 0 0 1 2 2v3'), // key: 198tvr
    DsIconPathElement('M16 21v-3a2 2 0 0 1 2-2h3'), // key: ph8mxp
  ]);

  /// `minus.mjs`
  static const DsLucideGlyph minus =
      DsLucideGlyph('minus', <DsIconElement>[
    DsIconPathElement('M5 12h14'), // key: 1ays0h
  ]);

  /// `mirror-rectangular.mjs`
  static const DsLucideGlyph mirrorRectangular =
      DsLucideGlyph('mirror-rectangular', <DsIconElement>[
    DsIconPathElement('M11 6 8 9'), // key: 7zt14w
    DsIconPathElement('m16 7-8 8'), // key: tkgtvu
    DsIconRectElement(4, 2, 16, 20, 2), // key: 1uxh74
  ]);

  /// `mirror-round.mjs`
  static const DsLucideGlyph mirrorRound =
      DsLucideGlyph('mirror-round', <DsIconElement>[
    DsIconPathElement('M10 6.6 8.6 8'), // key: itrr7k
    DsIconPathElement('M12 18v4'), // key: jadmvz
    DsIconPathElement('M15 7.5 9.5 13'), // key: 1vyrsv
    DsIconPathElement('M7 22h10'), // key: 10w4w3
    DsIconCircleElement(12, 10, 8), // key: 1gshiw
  ]);

  /// `monitor-check.mjs`
  static const DsLucideGlyph monitorCheck =
      DsLucideGlyph('monitor-check', <DsIconElement>[
    DsIconPathElement('m9 10 2 2 4-4'), // key: 1gnqz4
    DsIconRectElement(2, 3, 20, 14, 2), // key: 48i651
    DsIconPathElement('M12 17v4'), // key: 1riwvh
    DsIconPathElement('M8 21h8'), // key: 1ev6f3
  ]);

  /// `monitor-cloud.mjs`
  static const DsLucideGlyph monitorCloud =
      DsLucideGlyph('monitor-cloud', <DsIconElement>[
    DsIconPathElement('M11 13a3 3 0 1 1 2.83-4H14a2 2 0 0 1 0 4z'), // key: 1da4q6
    DsIconPathElement('M12 17v4'), // key: 1riwvh
    DsIconPathElement('M8 21h8'), // key: 1ev6f3
    DsIconRectElement(2, 3, 20, 14, 2), // key: x3v2xh
  ]);

  /// `monitor-cog.mjs`
  static const DsLucideGlyph monitorCog =
      DsLucideGlyph('monitor-cog', <DsIconElement>[
    DsIconPathElement('M12 17v4'), // key: 1riwvh
    DsIconPathElement('m14.305 7.53.923-.382'), // key: 1mlnsw
    DsIconPathElement('m15.228 4.852-.923-.383'), // key: 82mpwg
    DsIconPathElement('m16.852 3.228-.383-.924'), // key: ln4sir
    DsIconPathElement('m16.852 8.772-.383.923'), // key: 1dejw0
    DsIconPathElement('m19.148 3.228.383-.924'), // key: 192kgf
    DsIconPathElement('m19.53 9.696-.382-.924'), // key: fiavlr
    DsIconPathElement('m20.772 4.852.924-.383'), // key: 1j8mgp
    DsIconPathElement('m20.772 7.148.924.383'), // key: zix9be
    DsIconPathElement('M22 13v2a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h7'), // key: 1tnzv8
    DsIconPathElement('M8 21h8'), // key: 1ev6f3
    DsIconCircleElement(18, 6, 3), // key: 1h7g24
  ]);

  /// `monitor-dot.mjs`
  static const DsLucideGlyph monitorDot =
      DsLucideGlyph('monitor-dot', <DsIconElement>[
    DsIconPathElement('M12 17v4'), // key: 1riwvh
    DsIconPathElement('M22 12.307V15a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h8.693'), // key: 1dx6ho
    DsIconPathElement('M8 21h8'), // key: 1ev6f3
    DsIconCircleElement(19, 6, 3), // key: 108a5v
  ]);

  /// `monitor-down.mjs`
  static const DsLucideGlyph monitorDown =
      DsLucideGlyph('monitor-down', <DsIconElement>[
    DsIconPathElement('M12 13V7'), // key: h0r20n
    DsIconPathElement('m15 10-3 3-3-3'), // key: lzhmyn
    DsIconRectElement(2, 3, 20, 14, 2), // key: 48i651
    DsIconPathElement('M12 17v4'), // key: 1riwvh
    DsIconPathElement('M8 21h8'), // key: 1ev6f3
  ]);

  /// `monitor-off.mjs`
  static const DsLucideGlyph monitorOff =
      DsLucideGlyph('monitor-off', <DsIconElement>[
    DsIconPathElement('M12 17v4'), // key: 1riwvh
    DsIconPathElement('M17 17H4a2 2 0 0 1-2-2V5a2 2 0 0 1 1.184-1.826'), // key: cv7jms
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M8 21h8'), // key: 1ev6f3
    DsIconPathElement('M8.656 3H20a2 2 0 0 1 2 2v10a2 2 0 0 1-.293 1.042'), // key: z8ni2w
  ]);

  /// `monitor-pause.mjs`
  static const DsLucideGlyph monitorPause =
      DsLucideGlyph('monitor-pause', <DsIconElement>[
    DsIconPathElement('M10 13V7'), // key: 1u13u9
    DsIconPathElement('M14 13V7'), // key: 1vj9om
    DsIconRectElement(2, 3, 20, 14, 2), // key: 48i651
    DsIconPathElement('M12 17v4'), // key: 1riwvh
    DsIconPathElement('M8 21h8'), // key: 1ev6f3
  ]);

  /// `monitor-play.mjs`
  static const DsLucideGlyph monitorPlay =
      DsLucideGlyph('monitor-play', <DsIconElement>[
    DsIconPathElement('M15.033 9.44a.647.647 0 0 1 0 1.12l-4.065 2.352a.645.645 0 0 1-.968-.56V7.648a.645.645 0 0 1 .967-.56z'), // key: vbtd3f
    DsIconPathElement('M12 17v4'), // key: 1riwvh
    DsIconPathElement('M8 21h8'), // key: 1ev6f3
    DsIconRectElement(2, 3, 20, 14, 2), // key: x3v2xh
  ]);

  /// `monitor-smartphone.mjs`
  static const DsLucideGlyph monitorSmartphone =
      DsLucideGlyph('monitor-smartphone', <DsIconElement>[
    DsIconPathElement('M18 8V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v7a2 2 0 0 0 2 2h8'), // key: 10dyio
    DsIconPathElement('M10 19v-3.96 3.15'), // key: 1irgej
    DsIconPathElement('M7 19h5'), // key: qswx4l
    DsIconRectElement(16, 12, 6, 10, 2), // key: 1egngj
  ]);

  /// `monitor-speaker.mjs`
  static const DsLucideGlyph monitorSpeaker =
      DsLucideGlyph('monitor-speaker', <DsIconElement>[
    DsIconPathElement('M5.5 20H8'), // key: 1k40s5
    DsIconPathElement('M17 9h.01'), // key: 1j24nn
    DsIconRectElement(12, 4, 10, 16, 2), // key: ixliua
    DsIconPathElement('M8 6H4a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h4'), // key: 1mp6e1
    DsIconCircleElement(17, 15, 1), // key: tqvash
  ]);

  /// `monitor-stop.mjs`
  static const DsLucideGlyph monitorStop =
      DsLucideGlyph('monitor-stop', <DsIconElement>[
    DsIconPathElement('M12 17v4'), // key: 1riwvh
    DsIconPathElement('M8 21h8'), // key: 1ev6f3
    DsIconRectElement(2, 3, 20, 14, 2), // key: x3v2xh
    DsIconRectElement(9, 7, 6, 6, 1), // key: 5m2oou
  ]);

  /// `monitor-up.mjs`
  static const DsLucideGlyph monitorUp =
      DsLucideGlyph('monitor-up', <DsIconElement>[
    DsIconPathElement('m9 10 3-3 3 3'), // key: 11gsxs
    DsIconPathElement('M12 13V7'), // key: h0r20n
    DsIconRectElement(2, 3, 20, 14, 2), // key: 48i651
    DsIconPathElement('M12 17v4'), // key: 1riwvh
    DsIconPathElement('M8 21h8'), // key: 1ev6f3
  ]);

  /// `monitor-x.mjs`
  static const DsLucideGlyph monitorX =
      DsLucideGlyph('monitor-x', <DsIconElement>[
    DsIconPathElement('m14.5 12.5-5-5'), // key: 1jahn5
    DsIconPathElement('m9.5 12.5 5-5'), // key: 1k2t7b
    DsIconRectElement(2, 3, 20, 14, 2), // key: 48i651
    DsIconPathElement('M12 17v4'), // key: 1riwvh
    DsIconPathElement('M8 21h8'), // key: 1ev6f3
  ]);

  /// `monitor.mjs`
  static const DsLucideGlyph monitor =
      DsLucideGlyph('monitor', <DsIconElement>[
    DsIconRectElement(2, 3, 20, 14, 2), // key: 48i651
    DsIconLineElement(8, 21, 16, 21), // key: 1svkeh
    DsIconLineElement(12, 17, 12, 21), // key: vw1qmm
  ]);

  /// `moon-star.mjs`
  static const DsLucideGlyph moonStar =
      DsLucideGlyph('moon-star', <DsIconElement>[
    DsIconPathElement('M18 5h4'), // key: 1lhgn2
    DsIconPathElement('M20 3v4'), // key: 1olli1
    DsIconPathElement('M20.985 12.486a9 9 0 1 1-9.473-9.472c.405-.022.617.46.402.803a6 6 0 0 0 8.268 8.268c.344-.215.825-.004.803.401'), // key: kfwtm
  ]);

  /// `moon.mjs`
  static const DsLucideGlyph moon =
      DsLucideGlyph('moon', <DsIconElement>[
    DsIconPathElement('M20.985 12.486a9 9 0 1 1-9.473-9.472c.405-.022.617.46.402.803a6 6 0 0 0 8.268 8.268c.344-.215.825-.004.803.401'), // key: kfwtm
  ]);

  /// `mosque.mjs`
  static const DsLucideGlyph mosque =
      DsLucideGlyph('mosque', <DsIconElement>[
    DsIconPathElement('M12.268 2a2 2 0 003.465 2'), // key: 3in8xp
    DsIconPathElement('M14 5 L14 8'), // key: 1fhhfb
    DsIconPathElement('M16 22v-3a2 2 0 00-4 0v3'), // key: 1p6nbd
    DsIconPathElement('M21 13c-.662-1.497-1.666-2.753-2.9-3.63C16.825 8.47 15.422 8 14 8s-2.826.47-4.1 1.37C8.668 10.248 7.663 11.504 7 13z'), // key: ck3r5y
    DsIconPathElement('M3 9h4'), // key: rnfnj5
    DsIconPathElement('M7 22V6a5 5 0 00-2-4 5 5 0 00-2 4v14a2 2 0 002 2h14a2 2 0 002-2v-7'), // key: 28kgc3
  ]);

  /// `motorbike.mjs`
  static const DsLucideGlyph motorbike =
      DsLucideGlyph('motorbike', <DsIconElement>[
    DsIconPathElement('m18 14-1-3'), // key: bdajw9
    DsIconPathElement('m3 9 6 2a2 2 0 0 1 2-2h2a2 2 0 0 1 1.99 1.81'), // key: f5fotj
    DsIconPathElement('M8 17h3a1 1 0 0 0 1-1 6 6 0 0 1 6-6 1 1 0 0 0 1-1v-.75A5 5 0 0 0 17 5'), // key: 3i90e2
    DsIconCircleElement(19, 17, 3), // key: 1otbdv
    DsIconCircleElement(5, 17, 3), // key: 1d8p0c
  ]);

  /// `mountain-snow.mjs`
  static const DsLucideGlyph mountainSnow =
      DsLucideGlyph('mountain-snow', <DsIconElement>[
    DsIconPathElement('m8 3 4 8 5-5 5 15H2L8 3z'), // key: otkl63
    DsIconPathElement('M4.14 15.08c2.62-1.57 5.24-1.43 7.86.42 2.74 1.94 5.49 2 8.23.19'), // key: 1pvmmp
  ]);

  /// `mountain.mjs`
  static const DsLucideGlyph mountain =
      DsLucideGlyph('mountain', <DsIconElement>[
    DsIconPathElement('m8 3 4 8 5-5 5 15H2L8 3z'), // key: otkl63
  ]);

  /// `mouse-left.mjs`
  static const DsLucideGlyph mouseLeft =
      DsLucideGlyph('mouse-left', <DsIconElement>[
    DsIconPathElement('M12 7.318V10'), // key: 17s7lh
    DsIconPathElement('M5 10v5a7 7 0 0 0 14 0V9c0-3.527-2.608-6.515-6-7'), // key: imk5ea
    DsIconCircleElement(7, 4, 2), // key: ra7k3
  ]);

  /// `mouse-off.mjs`
  static const DsLucideGlyph mouseOff =
      DsLucideGlyph('mouse-off', <DsIconElement>[
    DsIconPathElement('M12 6v.343'), // key: 1gyhex
    DsIconPathElement('M18.218 18.218A7 7 0 0 1 5 15V9a7 7 0 0 1 .782-3.218'), // key: ukzz01
    DsIconPathElement('M19 13.343V9A7 7 0 0 0 8.56 2.902'), // key: 104jy9
    DsIconPathElement('M22 22 2 2'), // key: 1r8tn9
  ]);

  /// `mouse-pointer-2-off.mjs`
  static const DsLucideGlyph mousePointer2Off =
      DsLucideGlyph('mouse-pointer-2-off', <DsIconElement>[
    DsIconPathElement('m15.55 8.45 5.138 2.087a.5.5 0 0 1-.063.947l-6.124 1.58a2 2 0 0 0-1.438 1.435l-1.579 6.126a.5.5 0 0 1-.947.063L8.45 15.551'), // key: 1qoshx
    DsIconPathElement('M22 2 2 22'), // key: y4kqgn
    DsIconPathElement('m6.816 11.528-2.779-6.84a.495.495 0 0 1 .651-.651l6.84 2.779'), // key: mymuvk
  ]);

  /// `mouse-pointer-2.mjs`
  static const DsLucideGlyph mousePointer2 =
      DsLucideGlyph('mouse-pointer-2', <DsIconElement>[
    DsIconPathElement('M4.037 4.688a.495.495 0 0 1 .651-.651l16 6.5a.5.5 0 0 1-.063.947l-6.124 1.58a2 2 0 0 0-1.438 1.435l-1.579 6.126a.5.5 0 0 1-.947.063z'), // key: edeuup
  ]);

  /// `mouse-pointer-ban.mjs`
  static const DsLucideGlyph mousePointerBan =
      DsLucideGlyph('mouse-pointer-ban', <DsIconElement>[
    DsIconPathElement('M2.034 2.681a.498.498 0 0 1 .647-.647l9 3.5a.5.5 0 0 1-.033.944L8.204 7.545a1 1 0 0 0-.66.66l-1.066 3.443a.5.5 0 0 1-.944.033z'), // key: 11pp1i
    DsIconCircleElement(16, 16, 6), // key: qoo3c4
    DsIconPathElement('m11.8 11.8 8.4 8.4'), // key: oogvdj
  ]);

  /// `mouse-pointer-click.mjs`
  static const DsLucideGlyph mousePointerClick =
      DsLucideGlyph('mouse-pointer-click', <DsIconElement>[
    DsIconPathElement('M14 4.1 12 6'), // key: ita8i4
    DsIconPathElement('m5.1 8-2.9-.8'), // key: 1go3kf
    DsIconPathElement('m6 12-1.9 2'), // key: mnht97
    DsIconPathElement('M7.2 2.2 8 5.1'), // key: 1cfko1
    DsIconPathElement('M9.037 9.69a.498.498 0 0 1 .653-.653l11 4.5a.5.5 0 0 1-.074.949l-4.349 1.041a1 1 0 0 0-.74.739l-1.04 4.35a.5.5 0 0 1-.95.074z'), // key: s0h3yz
  ]);

  /// `mouse-pointer.mjs`
  static const DsLucideGlyph mousePointer =
      DsLucideGlyph('mouse-pointer', <DsIconElement>[
    DsIconPathElement('M12.586 12.586 19 19'), // key: ea5xo7
    DsIconPathElement('M3.688 3.037a.497.497 0 0 0-.651.651l6.5 15.999a.501.501 0 0 0 .947-.062l1.569-6.083a2 2 0 0 1 1.448-1.479l6.124-1.579a.5.5 0 0 0 .063-.947z'), // key: 277e5u
  ]);

  /// `mouse-right.mjs`
  static const DsLucideGlyph mouseRight =
      DsLucideGlyph('mouse-right', <DsIconElement>[
    DsIconPathElement('M12 7.318V10'), // key: 17s7lh
    DsIconPathElement('M19 10v5a7 7 0 0 1-14 0V9c0-3.527 2.608-6.515 6-7'), // key: 2es5nn
    DsIconCircleElement(17, 4, 2), // key: y5j2s2
  ]);

  /// `mouse.mjs`
  static const DsLucideGlyph mouse =
      DsLucideGlyph('mouse', <DsIconElement>[
    DsIconRectElement(5, 2, 14, 20, 7), // key: 11ol66
    DsIconPathElement('M12 6v4'), // key: 16clxf
  ]);

  /// `move-3d.mjs`
  static const DsLucideGlyph move3d =
      DsLucideGlyph('move-3d', <DsIconElement>[
    DsIconPathElement('M5 3v16h16'), // key: 1mqmf9
    DsIconPathElement('m5 19 6-6'), // key: jh6hbb
    DsIconPathElement('m2 6 3-3 3 3'), // key: tkyvxa
    DsIconPathElement('m18 16 3 3-3 3'), // key: 1d4glt
  ]);

  /// `move-diagonal-2.mjs`
  static const DsLucideGlyph moveDiagonal2 =
      DsLucideGlyph('move-diagonal-2', <DsIconElement>[
    DsIconPathElement('M19 13v6h-6'), // key: 1hxl6d
    DsIconPathElement('M5 11V5h6'), // key: 12e2xe
    DsIconPathElement('m5 5 14 14'), // key: 11anup
  ]);

  /// `move-diagonal.mjs`
  static const DsLucideGlyph moveDiagonal =
      DsLucideGlyph('move-diagonal', <DsIconElement>[
    DsIconPathElement('M11 19H5v-6'), // key: 8awifj
    DsIconPathElement('M13 5h6v6'), // key: 7voy1q
    DsIconPathElement('M19 5 5 19'), // key: wwaj1z
  ]);

  /// `move-down-left.mjs`
  static const DsLucideGlyph moveDownLeft =
      DsLucideGlyph('move-down-left', <DsIconElement>[
    DsIconPathElement('M11 19H5V13'), // key: 1akmht
    DsIconPathElement('M19 5L5 19'), // key: 72u4yj
  ]);

  /// `move-down-right.mjs`
  static const DsLucideGlyph moveDownRight =
      DsLucideGlyph('move-down-right', <DsIconElement>[
    DsIconPathElement('M19 13V19H13'), // key: 10vkzq
    DsIconPathElement('M5 5L19 19'), // key: 5zm2fv
  ]);

  /// `move-down.mjs`
  static const DsLucideGlyph moveDown =
      DsLucideGlyph('move-down', <DsIconElement>[
    DsIconPathElement('M8 18L12 22L16 18'), // key: cskvfv
    DsIconPathElement('M12 2V22'), // key: r89rzk
  ]);

  /// `move-horizontal.mjs`
  static const DsLucideGlyph moveHorizontal =
      DsLucideGlyph('move-horizontal', <DsIconElement>[
    DsIconPathElement('m18 8 4 4-4 4'), // key: 1ak13k
    DsIconPathElement('M2 12h20'), // key: 9i4pu4
    DsIconPathElement('m6 8-4 4 4 4'), // key: 15zrgr
  ]);

  /// `move-left.mjs`
  static const DsLucideGlyph moveLeft =
      DsLucideGlyph('move-left', <DsIconElement>[
    DsIconPathElement('M6 8L2 12L6 16'), // key: kyvwex
    DsIconPathElement('M2 12H22'), // key: 1m8cig
  ]);

  /// `move-right.mjs`
  static const DsLucideGlyph moveRight =
      DsLucideGlyph('move-right', <DsIconElement>[
    DsIconPathElement('M18 8L22 12L18 16'), // key: 1r0oui
    DsIconPathElement('M2 12H22'), // key: 1m8cig
  ]);

  /// `move-up-left.mjs`
  static const DsLucideGlyph moveUpLeft =
      DsLucideGlyph('move-up-left', <DsIconElement>[
    DsIconPathElement('M5 11V5H11'), // key: 3q78g9
    DsIconPathElement('M5 5L19 19'), // key: 5zm2fv
  ]);

  /// `move-up-right.mjs`
  static const DsLucideGlyph moveUpRight =
      DsLucideGlyph('move-up-right', <DsIconElement>[
    DsIconPathElement('M13 5H19V11'), // key: 1n1gyv
    DsIconPathElement('M19 5L5 19'), // key: 72u4yj
  ]);

  /// `move-up.mjs`
  static const DsLucideGlyph moveUp =
      DsLucideGlyph('move-up', <DsIconElement>[
    DsIconPathElement('M8 6L12 2L16 6'), // key: 1yvkyx
    DsIconPathElement('M12 2V22'), // key: r89rzk
  ]);

  /// `move-vertical.mjs`
  static const DsLucideGlyph moveVertical =
      DsLucideGlyph('move-vertical', <DsIconElement>[
    DsIconPathElement('M12 2v20'), // key: t6zp3m
    DsIconPathElement('m8 18 4 4 4-4'), // key: bh5tu3
    DsIconPathElement('m8 6 4-4 4 4'), // key: ybng9g
  ]);

  /// `move.mjs`
  static const DsLucideGlyph move =
      DsLucideGlyph('move', <DsIconElement>[
    DsIconPathElement('M12 2v20'), // key: t6zp3m
    DsIconPathElement('m15 19-3 3-3-3'), // key: 11eu04
    DsIconPathElement('m19 9 3 3-3 3'), // key: 1mg7y2
    DsIconPathElement('M2 12h20'), // key: 9i4pu4
    DsIconPathElement('m5 9-3 3 3 3'), // key: j64kie
    DsIconPathElement('m9 5 3-3 3 3'), // key: l8vdw6
  ]);

  /// `music-2.mjs`
  static const DsLucideGlyph music2 =
      DsLucideGlyph('music-2', <DsIconElement>[
    DsIconCircleElement(8, 18, 4), // key: 1fc0mg
    DsIconPathElement('M12 18V2l7 4'), // key: g04rme
  ]);

  /// `music-3.mjs`
  static const DsLucideGlyph music3 =
      DsLucideGlyph('music-3', <DsIconElement>[
    DsIconCircleElement(12, 18, 4), // key: m3r9ws
    DsIconPathElement('M16 18V2'), // key: 40x2m5
  ]);

  /// `music-4.mjs`
  static const DsLucideGlyph music4 =
      DsLucideGlyph('music-4', <DsIconElement>[
    DsIconPathElement('M9 18V5l12-2v13'), // key: 1jmyc2
    DsIconPathElement('m9 9 12-2'), // key: 1e64n2
    DsIconCircleElement(6, 18, 3), // key: fqmcym
    DsIconCircleElement(18, 16, 3), // key: 1hluhg
  ]);

  /// `music.mjs`
  static const DsLucideGlyph music =
      DsLucideGlyph('music', <DsIconElement>[
    DsIconPathElement('M9 18V5l12-2v13'), // key: 1jmyc2
    DsIconCircleElement(6, 18, 3), // key: fqmcym
    DsIconCircleElement(18, 16, 3), // key: 1hluhg
  ]);

  /// `navigation-2-off.mjs`
  static const DsLucideGlyph navigation2Off =
      DsLucideGlyph('navigation-2-off', <DsIconElement>[
    DsIconPathElement('M9.31 9.31 5 21l7-4 7 4-1.17-3.17'), // key: qoq2o2
    DsIconPathElement('M14.53 8.88 12 2l-1.17 3.17'), // key: k3sjzy
    DsIconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `navigation-2.mjs`
  static const DsLucideGlyph navigation2 =
      DsLucideGlyph('navigation-2', <DsIconElement>[
    DsIconPolygonElement(<Offset>[Offset(12, 2), Offset(19, 21), Offset(12, 17), Offset(5, 21), Offset(12, 2)]), // key: x8c0qg
  ]);

  /// `navigation-off.mjs`
  static const DsLucideGlyph navigationOff =
      DsLucideGlyph('navigation-off', <DsIconElement>[
    DsIconPathElement('M8.43 8.43 3 11l8 2 2 8 2.57-5.43'), // key: 1vdtb7
    DsIconPathElement('M17.39 11.73 22 2l-9.73 4.61'), // key: tya3r6
    DsIconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `navigation.mjs`
  static const DsLucideGlyph navigation =
      DsLucideGlyph('navigation', <DsIconElement>[
    DsIconPolygonElement(<Offset>[Offset(3, 11), Offset(22, 2), Offset(13, 21), Offset(11, 13), Offset(3, 11)]), // key: 1ltx0t
  ]);

  /// `network.mjs`
  static const DsLucideGlyph network =
      DsLucideGlyph('network', <DsIconElement>[
    DsIconRectElement(16, 16, 6, 6, 1), // key: 4q2zg0
    DsIconRectElement(2, 16, 6, 6, 1), // key: 8cvhb9
    DsIconRectElement(9, 2, 6, 6, 1), // key: 1egb70
    DsIconPathElement('M5 16v-3a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1v3'), // key: 1jsf9p
    DsIconPathElement('M12 12V8'), // key: 2874zd
  ]);

  /// `newspaper.mjs`
  static const DsLucideGlyph newspaper =
      DsLucideGlyph('newspaper', <DsIconElement>[
    DsIconPathElement('M15 18h-5'), // key: 95g1m2
    DsIconPathElement('M18 14h-8'), // key: sponae
    DsIconPathElement('M4 22h16a2 2 0 0 0 2-2V4a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v16a2 2 0 0 1-4 0v-9a2 2 0 0 1 2-2h2'), // key: 39pd36
    DsIconRectElement(10, 6, 8, 4, 1), // key: aywv1n
  ]);

  /// `nfc.mjs`
  static const DsLucideGlyph nfc =
      DsLucideGlyph('nfc', <DsIconElement>[
    DsIconPathElement('M6 8.32a7.43 7.43 0 0 1 0 7.36'), // key: 9iaqei
    DsIconPathElement('M9.46 6.21a11.76 11.76 0 0 1 0 11.58'), // key: 1yha7l
    DsIconPathElement('M12.91 4.1a15.91 15.91 0 0 1 .01 15.8'), // key: 4iu2gk
    DsIconPathElement('M16.37 2a20.16 20.16 0 0 1 0 20'), // key: sap9u2
  ]);

  /// `non-binary.mjs`
  static const DsLucideGlyph nonBinary =
      DsLucideGlyph('non-binary', <DsIconElement>[
    DsIconPathElement('M12 2v10'), // key: mnfbl
    DsIconPathElement('m8.5 4 7 4'), // key: m1xjk3
    DsIconPathElement('m8.5 8 7-4'), // key: t0m5j6
    DsIconCircleElement(12, 17, 5), // key: qbz8iq
  ]);

  /// `notebook-pen.mjs`
  static const DsLucideGlyph notebookPen =
      DsLucideGlyph('notebook-pen', <DsIconElement>[
    DsIconPathElement('M13.4 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-7.4'), // key: re6nr2
    DsIconPathElement('M2 6h4'), // key: aawbzj
    DsIconPathElement('M2 10h4'), // key: l0bgd4
    DsIconPathElement('M2 14h4'), // key: 1gsvsf
    DsIconPathElement('M2 18h4'), // key: 1bu2t1
    DsIconPathElement('M21.378 5.626a1 1 0 1 0-3.004-3.004l-5.01 5.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z'), // key: pqwjuv
  ]);

  /// `notebook-tabs.mjs`
  static const DsLucideGlyph notebookTabs =
      DsLucideGlyph('notebook-tabs', <DsIconElement>[
    DsIconPathElement('M2 6h4'), // key: aawbzj
    DsIconPathElement('M2 10h4'), // key: l0bgd4
    DsIconPathElement('M2 14h4'), // key: 1gsvsf
    DsIconPathElement('M2 18h4'), // key: 1bu2t1
    DsIconRectElement(4, 2, 16, 20, 2), // key: 1nb95v
    DsIconPathElement('M15 2v20'), // key: dcj49h
    DsIconPathElement('M15 7h5'), // key: 1xj5lc
    DsIconPathElement('M15 12h5'), // key: w5shd9
    DsIconPathElement('M15 17h5'), // key: 1qaofu
  ]);

  /// `notebook-text.mjs`
  static const DsLucideGlyph notebookText =
      DsLucideGlyph('notebook-text', <DsIconElement>[
    DsIconPathElement('M2 6h4'), // key: aawbzj
    DsIconPathElement('M2 10h4'), // key: l0bgd4
    DsIconPathElement('M2 14h4'), // key: 1gsvsf
    DsIconPathElement('M2 18h4'), // key: 1bu2t1
    DsIconRectElement(4, 2, 16, 20, 2), // key: 1nb95v
    DsIconPathElement('M9.5 8h5'), // key: 11mslq
    DsIconPathElement('M9.5 12H16'), // key: ktog6x
    DsIconPathElement('M9.5 16H14'), // key: p1seyn
  ]);

  /// `notebook.mjs`
  static const DsLucideGlyph notebook =
      DsLucideGlyph('notebook', <DsIconElement>[
    DsIconPathElement('M2 6h4'), // key: aawbzj
    DsIconPathElement('M2 10h4'), // key: l0bgd4
    DsIconPathElement('M2 14h4'), // key: 1gsvsf
    DsIconPathElement('M2 18h4'), // key: 1bu2t1
    DsIconRectElement(4, 2, 16, 20, 2), // key: 1nb95v
    DsIconPathElement('M16 2v20'), // key: rotuqe
  ]);

  /// `notepad-text-dashed.mjs`
  static const DsLucideGlyph notepadTextDashed =
      DsLucideGlyph('notepad-text-dashed', <DsIconElement>[
    DsIconPathElement('M8 2v4'), // key: 1cmpym
    DsIconPathElement('M12 2v4'), // key: 3427ic
    DsIconPathElement('M16 2v4'), // key: 4m81vk
    DsIconPathElement('M16 4h2a2 2 0 0 1 2 2v2'), // key: j91f56
    DsIconPathElement('M20 12v2'), // key: w8o0tu
    DsIconPathElement('M20 18v2a2 2 0 0 1-2 2h-1'), // key: 1c9ggx
    DsIconPathElement('M13 22h-2'), // key: 191ugt
    DsIconPathElement('M7 22H6a2 2 0 0 1-2-2v-2'), // key: 1rt9px
    DsIconPathElement('M4 14v-2'), // key: 1v0sqh
    DsIconPathElement('M4 8V6a2 2 0 0 1 2-2h2'), // key: 1mwabg
    DsIconPathElement('M8 10h6'), // key: 3oa6kw
    DsIconPathElement('M8 14h8'), // key: 1fgep2
    DsIconPathElement('M8 18h5'), // key: 17enja
  ]);

  /// `notepad-text.mjs`
  static const DsLucideGlyph notepadText =
      DsLucideGlyph('notepad-text', <DsIconElement>[
    DsIconPathElement('M8 2v4'), // key: 1cmpym
    DsIconPathElement('M12 2v4'), // key: 3427ic
    DsIconPathElement('M16 2v4'), // key: 4m81vk
    DsIconRectElement(4, 4, 16, 18, 2), // key: 1u9h20
    DsIconPathElement('M8 10h6'), // key: 3oa6kw
    DsIconPathElement('M8 14h8'), // key: 1fgep2
    DsIconPathElement('M8 18h5'), // key: 17enja
  ]);

  /// `nut-off.mjs`
  static const DsLucideGlyph nutOff =
      DsLucideGlyph('nut-off', <DsIconElement>[
    DsIconPathElement('M12 4V2'), // key: 1k5q1u
    DsIconPathElement('M5 10v4a7.004 7.004 0 0 0 5.277 6.787c.412.104.802.292 1.102.592L12 22l.621-.621c.3-.3.69-.488 1.102-.592a7.01 7.01 0 0 0 4.125-2.939'), // key: 1xcvy9
    DsIconPathElement('M19 10v3.343'), // key: 163tfc
    DsIconPathElement('M12 12c-1.349-.573-1.905-1.005-2.5-2-.546.902-1.048 1.353-2.5 2-1.018-.644-1.46-1.08-2-2-1.028.71-1.69.918-3 1 1.081-1.048 1.757-2.03 2-3 .194-.776.84-1.551 1.79-2.21m11.654 5.997c.887-.457 1.28-.891 1.556-1.787 1.032.916 1.683 1.157 3 1-1.297-1.036-1.758-2.03-2-3-.5-2-4-4-8-4-.74 0-1.461.068-2.15.192'), // key: 17914v
    DsIconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `nut.mjs`
  static const DsLucideGlyph nut =
      DsLucideGlyph('nut', <DsIconElement>[
    DsIconPathElement('M12 4V2'), // key: 1k5q1u
    DsIconPathElement('M5 10v4a7.004 7.004 0 0 0 5.277 6.787c.412.104.802.292 1.102.592L12 22l.621-.621c.3-.3.69-.488 1.102-.592A7.003 7.003 0 0 0 19 14v-4'), // key: 1tgyif
    DsIconPathElement('M12 4C8 4 4.5 6 4 8c-.243.97-.919 1.952-2 3 1.31-.082 1.972-.29 3-1 .54.92.982 1.356 2 2 1.452-.647 1.954-1.098 2.5-2 .595.995 1.151 1.427 2.5 2 1.31-.621 1.862-1.058 2.5-2 .629.977 1.162 1.423 2.5 2 1.209-.548 1.68-.967 2-2 1.032.916 1.683 1.157 3 1-1.297-1.036-1.758-2.03-2-3-.5-2-4-4-8-4Z'), // key: tnsqj
  ]);

  /// `octagon-alert.mjs`
  static const DsLucideGlyph octagonAlert =
      DsLucideGlyph('octagon-alert', <DsIconElement>[
    DsIconPathElement('M12 16h.01'), // key: 1drbdi
    DsIconPathElement('M12 8v4'), // key: 1got3b
    DsIconPathElement('M15.312 2a2 2 0 0 1 1.414.586l4.688 4.688A2 2 0 0 1 22 8.688v6.624a2 2 0 0 1-.586 1.414l-4.688 4.688a2 2 0 0 1-1.414.586H8.688a2 2 0 0 1-1.414-.586l-4.688-4.688A2 2 0 0 1 2 15.312V8.688a2 2 0 0 1 .586-1.414l4.688-4.688A2 2 0 0 1 8.688 2z'), // key: 1fd625
  ]);

  /// `octagon-minus.mjs`
  static const DsLucideGlyph octagonMinus =
      DsLucideGlyph('octagon-minus', <DsIconElement>[
    DsIconPathElement('M2.586 16.726A2 2 0 0 1 2 15.312V8.688a2 2 0 0 1 .586-1.414l4.688-4.688A2 2 0 0 1 8.688 2h6.624a2 2 0 0 1 1.414.586l4.688 4.688A2 2 0 0 1 22 8.688v6.624a2 2 0 0 1-.586 1.414l-4.688 4.688a2 2 0 0 1-1.414.586H8.688a2 2 0 0 1-1.414-.586z'), // key: 2d38gg
    DsIconPathElement('M8 12h8'), // key: 1wcyev
  ]);

  /// `octagon-pause.mjs`
  static const DsLucideGlyph octagonPause =
      DsLucideGlyph('octagon-pause', <DsIconElement>[
    DsIconPathElement('M10 15V9'), // key: 1lckn7
    DsIconPathElement('M14 15V9'), // key: 1muqhk
    DsIconPathElement('M2.586 16.726A2 2 0 0 1 2 15.312V8.688a2 2 0 0 1 .586-1.414l4.688-4.688A2 2 0 0 1 8.688 2h6.624a2 2 0 0 1 1.414.586l4.688 4.688A2 2 0 0 1 22 8.688v6.624a2 2 0 0 1-.586 1.414l-4.688 4.688a2 2 0 0 1-1.414.586H8.688a2 2 0 0 1-1.414-.586z'), // key: 2d38gg
  ]);

  /// `octagon-x.mjs`
  static const DsLucideGlyph octagonX =
      DsLucideGlyph('octagon-x', <DsIconElement>[
    DsIconPathElement('m15 9-6 6'), // key: 1uzhvr
    DsIconPathElement('M2.586 16.726A2 2 0 0 1 2 15.312V8.688a2 2 0 0 1 .586-1.414l4.688-4.688A2 2 0 0 1 8.688 2h6.624a2 2 0 0 1 1.414.586l4.688 4.688A2 2 0 0 1 22 8.688v6.624a2 2 0 0 1-.586 1.414l-4.688 4.688a2 2 0 0 1-1.414.586H8.688a2 2 0 0 1-1.414-.586z'), // key: 2d38gg
    DsIconPathElement('m9 9 6 6'), // key: z0biqf
  ]);

  /// `octagon.mjs`
  static const DsLucideGlyph octagon =
      DsLucideGlyph('octagon', <DsIconElement>[
    DsIconPathElement('M2.586 16.726A2 2 0 0 1 2 15.312V8.688a2 2 0 0 1 .586-1.414l4.688-4.688A2 2 0 0 1 8.688 2h6.624a2 2 0 0 1 1.414.586l4.688 4.688A2 2 0 0 1 22 8.688v6.624a2 2 0 0 1-.586 1.414l-4.688 4.688a2 2 0 0 1-1.414.586H8.688a2 2 0 0 1-1.414-.586z'), // key: 2d38gg
  ]);

  /// `omega.mjs`
  static const DsLucideGlyph omega =
      DsLucideGlyph('omega', <DsIconElement>[
    DsIconPathElement('M3 20h4.5a.5.5 0 0 0 .5-.5v-.282a.52.52 0 0 0-.247-.437 8 8 0 1 1 8.494-.001.52.52 0 0 0-.247.438v.282a.5.5 0 0 0 .5.5H21'), // key: 1x94xo
  ]);

  /// `option.mjs`
  static const DsLucideGlyph option =
      DsLucideGlyph('option', <DsIconElement>[
    DsIconPathElement('M14 3h7'), // key: 16f0ms
    DsIconPathElement('M3 3h5.28a1 1 0 0 1 .948.684l5.544 16.632a1 1 0 0 0 .949.684H21'), // key: 1qf1im
  ]);

  /// `orbit.mjs`
  static const DsLucideGlyph orbit =
      DsLucideGlyph('orbit', <DsIconElement>[
    DsIconPathElement('M20.341 6.484A10 10 0 0 1 10.266 21.85'), // key: 1enhxb
    DsIconPathElement('M3.659 17.516A10 10 0 0 1 13.74 2.152'), // key: 1crzgf
    DsIconCircleElement(12, 12, 3), // key: 1v7zrd
    DsIconCircleElement(19, 5, 2), // key: mhkx31
    DsIconCircleElement(5, 19, 2), // key: v8kfzx
  ]);

  /// `origami.mjs`
  static const DsLucideGlyph origami =
      DsLucideGlyph('origami', <DsIconElement>[
    DsIconPathElement('M12 12V4a1 1 0 0 1 1-1h6.297a1 1 0 0 1 .651 1.759l-4.696 4.025'), // key: 1bx4vc
    DsIconPathElement('m12 21-7.414-7.414A2 2 0 0 1 4 12.172V6.415a1.002 1.002 0 0 1 1.707-.707L20 20.009'), // key: 1h3km6
    DsIconPathElement('m12.214 3.381 8.414 14.966a1 1 0 0 1-.167 1.199l-1.168 1.163a1 1 0 0 1-.706.291H6.351a1 1 0 0 1-.625-.219L3.25 18.8a1 1 0 0 1 .631-1.781l4.165.027'), // key: 1hj4wg
  ]);

  /// `package-2.mjs`
  static const DsLucideGlyph package2 =
      DsLucideGlyph('package-2', <DsIconElement>[
    DsIconPathElement('M12 3v6'), // key: 1holv5
    DsIconPathElement('M16.76 3a2 2 0 0 1 1.8 1.1l2.23 4.479a2 2 0 0 1 .21.891V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V9.472a2 2 0 0 1 .211-.894L5.45 4.1A2 2 0 0 1 7.24 3z'), // key: 187q7i
    DsIconPathElement('M3.054 9.013h17.893'), // key: grwhos
  ]);

  /// `package-check.mjs`
  static const DsLucideGlyph packageCheck =
      DsLucideGlyph('package-check', <DsIconElement>[
    DsIconPathElement('M12 22V12'), // key: d0xqtd
    DsIconPathElement('m16 17 2 2 4-4'), // key: uh5qu3
    DsIconPathElement('M21 11.127V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.729l7 4a2 2 0 0 0 2 .001l1.32-.753'), // key: kpkbpo
    DsIconPathElement('M3.29 7 12 12l8.71-5'), // key: 19ckod
    DsIconPathElement('m7.5 4.27 8.997 5.148'), // key: 9yrvtv
  ]);

  /// `package-minus.mjs`
  static const DsLucideGlyph packageMinus =
      DsLucideGlyph('package-minus', <DsIconElement>[
    DsIconPathElement('M12 22V12'), // key: d0xqtd
    DsIconPathElement('M16 17h6'), // key: 1ook5g
    DsIconPathElement('M21 13V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.729l7 4a2 2 0 0 0 2 .001l1.675-.955'), // key: zu9avd
    DsIconPathElement('M3.29 7 12 12l8.71-5'), // key: 19ckod
    DsIconPathElement('m7.5 4.27 8.997 5.148'), // key: 9yrvtv
  ]);

  /// `package-open.mjs`
  static const DsLucideGlyph packageOpen =
      DsLucideGlyph('package-open', <DsIconElement>[
    DsIconPathElement('M12 22v-9'), // key: x3hkom
    DsIconPathElement('M15.17 2.21a1.67 1.67 0 0 1 1.63 0L21 4.57a1.93 1.93 0 0 1 0 3.36L8.82 14.79a1.655 1.655 0 0 1-1.64 0L3 12.43a1.93 1.93 0 0 1 0-3.36z'), // key: 2ntwy6
    DsIconPathElement('M20 13v3.87a2.06 2.06 0 0 1-1.11 1.83l-6 3.08a1.93 1.93 0 0 1-1.78 0l-6-3.08A2.06 2.06 0 0 1 4 16.87V13'), // key: 1pmm1c
    DsIconPathElement('M21 12.43a1.93 1.93 0 0 0 0-3.36L8.83 2.2a1.64 1.64 0 0 0-1.63 0L3 4.57a1.93 1.93 0 0 0 0 3.36l12.18 6.86a1.636 1.636 0 0 0 1.63 0z'), // key: 12ttoo
  ]);

  /// `package-plus.mjs`
  static const DsLucideGlyph packagePlus =
      DsLucideGlyph('package-plus', <DsIconElement>[
    DsIconPathElement('M12 22V12'), // key: d0xqtd
    DsIconPathElement('M16 17h6'), // key: 1ook5g
    DsIconPathElement('M19 14v6'), // key: 1ckrd5
    DsIconPathElement('M21 10.535V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.729l7 4a2 2 0 0 0 2 .001l1.675-.955'), // key: 28k6lz
    DsIconPathElement('M3.29 7 12 12l8.71-5'), // key: 19ckod
    DsIconPathElement('m7.5 4.27 8.997 5.148'), // key: 9yrvtv
  ]);

  /// `package-search.mjs`
  static const DsLucideGlyph packageSearch =
      DsLucideGlyph('package-search', <DsIconElement>[
    DsIconPathElement('M12 22V12'), // key: d0xqtd
    DsIconPathElement('M20.27 18.27 22 20'), // key: er2am
    DsIconPathElement('M21 10.498V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.729l7 4a2 2 0 0 0 2 .001l.98-.559'), // key: tok1h1
    DsIconPathElement('M3.29 7 12 12l8.71-5'), // key: 19ckod
    DsIconPathElement('m7.5 4.27 8.997 5.148'), // key: 9yrvtv
    DsIconCircleElement(18.5, 16.5, 2.5), // key: ke13xx
  ]);

  /// `package-x.mjs`
  static const DsLucideGlyph packageX =
      DsLucideGlyph('package-x', <DsIconElement>[
    DsIconPathElement('M12 22V12'), // key: d0xqtd
    DsIconPathElement('m16.5 14.5 5 5'), // key: ozpm51
    DsIconPathElement('m16.5 19.5 5-5'), // key: syf6b9
    DsIconPathElement('M21 10.5V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.729l7 4a2 2 0 0 0 2 .001l.13-.074'), // key: isw6gs
    DsIconPathElement('M3.29 7 12 12l8.71-5'), // key: 19ckod
    DsIconPathElement('m7.5 4.27 8.997 5.148'), // key: 9yrvtv
  ]);

  /// `package.mjs`
  static const DsLucideGlyph package =
      DsLucideGlyph('package', <DsIconElement>[
    DsIconPathElement('M11 21.73a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73z'), // key: 1a0edw
    DsIconPathElement('M12 22V12'), // key: d0xqtd
    DsIconPolylineElement(<Offset>[Offset(3.29, 7), Offset(12, 12), Offset(20.71, 7)]), // key: ousv84
    DsIconPathElement('m7.5 4.27 9 5.15'), // key: 1c824w
  ]);

  /// `paint-bucket.mjs`
  static const DsLucideGlyph paintBucket =
      DsLucideGlyph('paint-bucket', <DsIconElement>[
    DsIconPathElement('M11 7 6 2'), // key: 1jwth8
    DsIconPathElement('M18.992 12H2.041'), // key: xw1gg
    DsIconPathElement('M21.145 18.38A3.34 3.34 0 0 1 20 16.5a3.3 3.3 0 0 1-1.145 1.88c-.575.46-.855 1.02-.855 1.595A2 2 0 0 0 20 22a2 2 0 0 0 2-2.025c0-.58-.285-1.13-.855-1.595'), // key: 1nkol4
    DsIconPathElement('m8.5 4.5 2.148-2.148a1.205 1.205 0 0 1 1.704 0l7.296 7.296a1.205 1.205 0 0 1 0 1.704l-7.592 7.592a3.615 3.615 0 0 1-5.112 0l-3.888-3.888a3.615 3.615 0 0 1 0-5.112L5.67 7.33'), // key: 1nk1rd
  ]);

  /// `paint-roller.mjs`
  static const DsLucideGlyph paintRoller =
      DsLucideGlyph('paint-roller', <DsIconElement>[
    DsIconRectElement(2, 2, 16, 6, 2), // key: jcyz7m
    DsIconPathElement('M10 16v-2a2 2 0 0 1 2-2h8a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2'), // key: 1b9h7c
    DsIconRectElement(8, 16, 4, 6, 1), // key: d6e7yl
  ]);

  /// `paintbrush-vertical.mjs`
  static const DsLucideGlyph paintbrushVertical =
      DsLucideGlyph('paintbrush-vertical', <DsIconElement>[
    DsIconPathElement('M10 2v2'), // key: 7u0qdc
    DsIconPathElement('M14 2v4'), // key: qmzblu
    DsIconPathElement('M17 2a1 1 0 0 1 1 1v9H6V3a1 1 0 0 1 1-1z'), // key: ycvu00
    DsIconPathElement('M6 12a1 1 0 0 0-1 1v1a2 2 0 0 0 2 2h2a1 1 0 0 1 1 1v2.9a2 2 0 1 0 4 0V17a1 1 0 0 1 1-1h2a2 2 0 0 0 2-2v-1a1 1 0 0 0-1-1'), // key: iw4wnp
  ]);

  /// `paintbrush.mjs`
  static const DsLucideGlyph paintbrush =
      DsLucideGlyph('paintbrush', <DsIconElement>[
    DsIconPathElement('m14.622 17.897-10.68-2.913'), // key: vj2p1u
    DsIconPathElement('M18.376 2.622a1 1 0 1 1 3.002 3.002L17.36 9.643a.5.5 0 0 0 0 .707l.944.944a2.41 2.41 0 0 1 0 3.408l-.944.944a.5.5 0 0 1-.707 0L8.354 7.348a.5.5 0 0 1 0-.707l.944-.944a2.41 2.41 0 0 1 3.408 0l.944.944a.5.5 0 0 0 .707 0z'), // key: 18tc5c
    DsIconPathElement('M9 8c-1.804 2.71-3.97 3.46-6.583 3.948a.507.507 0 0 0-.302.819l7.32 8.883a1 1 0 0 0 1.185.204C12.735 20.405 16 16.792 16 15'), // key: ytzfxy
  ]);

  /// `palette.mjs`
  static const DsLucideGlyph palette =
      DsLucideGlyph('palette', <DsIconElement>[
    DsIconPathElement('M12 22a1 1 0 0 1 0-20 10 9 0 0 1 10 9 5 5 0 0 1-5 5h-2.25a1.75 1.75 0 0 0-1.4 2.8l.3.4a1.75 1.75 0 0 1-1.4 2.8z'), // key: e79jfc
    DsIconCircleElement(13.5, 6.5, 0.5, filled: true), // key: 1okk4w
    DsIconCircleElement(17.5, 10.5, 0.5, filled: true), // key: f64h9f
    DsIconCircleElement(6.5, 12.5, 0.5, filled: true), // key: qy21gx
    DsIconCircleElement(8.5, 7.5, 0.5, filled: true), // key: fotxhn
  ]);

  /// `panda.mjs`
  static const DsLucideGlyph panda =
      DsLucideGlyph('panda', <DsIconElement>[
    DsIconPathElement('M11.25 17.25h1.5L12 18z'), // key: 1wmwwj
    DsIconPathElement('m15 12 2 2'), // key: k60wz4
    DsIconPathElement('M18 6.5a.5.5 0 0 0-.5-.5'), // key: 1ch4h4
    DsIconPathElement('M20.69 9.67a4.5 4.5 0 1 0-7.04-5.5 8.35 8.35 0 0 0-3.3 0 4.5 4.5 0 1 0-7.04 5.5C2.49 11.2 2 12.88 2 14.5 2 19.47 6.48 22 12 22s10-2.53 10-7.5c0-1.62-.48-3.3-1.3-4.83'), // key: 1c660l
    DsIconPathElement('M6 6.5a.495.495 0 0 1 .5-.5'), // key: eviuep
    DsIconPathElement('m9 12-2 2'), // key: 326nkw
  ]);

  /// `panel-bottom-close.mjs`
  static const DsLucideGlyph panelBottomClose =
      DsLucideGlyph('panel-bottom-close', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M3 15h18'), // key: 5xshup
    DsIconPathElement('m15 8-3 3-3-3'), // key: 1oxy1z
  ]);

  /// `panel-bottom-dashed.mjs`
  static const DsLucideGlyph panelBottomDashed =
      DsLucideGlyph('panel-bottom-dashed', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M14 15h1'), // key: 171nev
    DsIconPathElement('M19 15h2'), // key: 1vnucp
    DsIconPathElement('M3 15h2'), // key: 8bym0q
    DsIconPathElement('M9 15h1'), // key: 1tg3ks
  ]);

  /// `panel-bottom-open.mjs`
  static const DsLucideGlyph panelBottomOpen =
      DsLucideGlyph('panel-bottom-open', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M3 15h18'), // key: 5xshup
    DsIconPathElement('m9 10 3-3 3 3'), // key: 11gsxs
  ]);

  /// `panel-bottom.mjs`
  static const DsLucideGlyph panelBottom =
      DsLucideGlyph('panel-bottom', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M3 15h18'), // key: 5xshup
  ]);

  /// `panel-left-close.mjs`
  static const DsLucideGlyph panelLeftClose =
      DsLucideGlyph('panel-left-close', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M9 3v18'), // key: fh3hqa
    DsIconPathElement('m16 15-3-3 3-3'), // key: 14y99z
  ]);

  /// `panel-left-dashed.mjs`
  static const DsLucideGlyph panelLeftDashed =
      DsLucideGlyph('panel-left-dashed', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M9 14v1'), // key: askpd8
    DsIconPathElement('M9 19v2'), // key: 16tejx
    DsIconPathElement('M9 3v2'), // key: 1noubl
    DsIconPathElement('M9 9v1'), // key: 19ebxg
  ]);

  /// `panel-left-open.mjs`
  static const DsLucideGlyph panelLeftOpen =
      DsLucideGlyph('panel-left-open', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M9 3v18'), // key: fh3hqa
    DsIconPathElement('m14 9 3 3-3 3'), // key: 8010ee
  ]);

  /// `panel-left-right-dashed.mjs`
  static const DsLucideGlyph panelLeftRightDashed =
      DsLucideGlyph('panel-left-right-dashed', <DsIconElement>[
    DsIconPathElement('M15 10V9'), // key: 4dkmfx
    DsIconPathElement('M15 15v-1'), // key: 6a4afx
    DsIconPathElement('M15 21v-2'), // key: 1qshmc
    DsIconPathElement('M15 5V3'), // key: 1fk0mb
    DsIconPathElement('M9 10V9'), // key: 1lazqi
    DsIconPathElement('M9 15v-1'), // key: 9lx740
    DsIconPathElement('M9 21v-2'), // key: 1fwk0n
    DsIconPathElement('M9 5V3'), // key: 2q8zi6
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `panel-left.mjs`
  static const DsLucideGlyph panelLeft =
      DsLucideGlyph('panel-left', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M9 3v18'), // key: fh3hqa
  ]);

  /// `panel-right-close.mjs`
  static const DsLucideGlyph panelRightClose =
      DsLucideGlyph('panel-right-close', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M15 3v18'), // key: 14nvp0
    DsIconPathElement('m8 9 3 3-3 3'), // key: 12hl5m
  ]);

  /// `panel-right-dashed.mjs`
  static const DsLucideGlyph panelRightDashed =
      DsLucideGlyph('panel-right-dashed', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M15 14v1'), // key: ilsfch
    DsIconPathElement('M15 19v2'), // key: 1fst2f
    DsIconPathElement('M15 3v2'), // key: z204g4
    DsIconPathElement('M15 9v1'), // key: z2a8b1
  ]);

  /// `panel-right-open.mjs`
  static const DsLucideGlyph panelRightOpen =
      DsLucideGlyph('panel-right-open', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M15 3v18'), // key: 14nvp0
    DsIconPathElement('m10 15-3-3 3-3'), // key: 1pgupc
  ]);

  /// `panel-right.mjs`
  static const DsLucideGlyph panelRight =
      DsLucideGlyph('panel-right', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M15 3v18'), // key: 14nvp0
  ]);

  /// `panel-top-bottom-dashed.mjs`
  static const DsLucideGlyph panelTopBottomDashed =
      DsLucideGlyph('panel-top-bottom-dashed', <DsIconElement>[
    DsIconPathElement('M14 15h1'), // key: 171nev
    DsIconPathElement('M14 9h1'), // key: l0svgy
    DsIconPathElement('M19 15h2'), // key: 1vnucp
    DsIconPathElement('M19 9h2'), // key: te2zfg
    DsIconPathElement('M3 15h2'), // key: 8bym0q
    DsIconPathElement('M3 9h2'), // key: 1h4ldw
    DsIconPathElement('M9 15h1'), // key: 1tg3ks
    DsIconPathElement('M9 9h1'), // key: 15jzuz
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `panel-top-close.mjs`
  static const DsLucideGlyph panelTopClose =
      DsLucideGlyph('panel-top-close', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('m9 16 3-3 3 3'), // key: 1idcnm
  ]);

  /// `panel-top-dashed.mjs`
  static const DsLucideGlyph panelTopDashed =
      DsLucideGlyph('panel-top-dashed', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M14 9h1'), // key: l0svgy
    DsIconPathElement('M19 9h2'), // key: te2zfg
    DsIconPathElement('M3 9h2'), // key: 1h4ldw
    DsIconPathElement('M9 9h1'), // key: 15jzuz
  ]);

  /// `panel-top-open.mjs`
  static const DsLucideGlyph panelTopOpen =
      DsLucideGlyph('panel-top-open', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('m15 14-3 3-3-3'), // key: g215vf
  ]);

  /// `panel-top.mjs`
  static const DsLucideGlyph panelTop =
      DsLucideGlyph('panel-top', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M3 9h18'), // key: 1pudct
  ]);

  /// `panels-left-bottom.mjs`
  static const DsLucideGlyph panelsLeftBottom =
      DsLucideGlyph('panels-left-bottom', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M9 3v18'), // key: fh3hqa
    DsIconPathElement('M9 15h12'), // key: 5ijen5
  ]);

  /// `panels-right-bottom.mjs`
  static const DsLucideGlyph panelsRightBottom =
      DsLucideGlyph('panels-right-bottom', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M3 15h12'), // key: 1wkqb3
    DsIconPathElement('M15 3v18'), // key: 14nvp0
  ]);

  /// `panels-top-left.mjs`
  static const DsLucideGlyph panelsTopLeft =
      DsLucideGlyph('panels-top-left', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('M9 21V9'), // key: 1oto5p
  ]);

  /// `paper-bag.mjs`
  static const DsLucideGlyph paperBag =
      DsLucideGlyph('paper-bag', <DsIconElement>[
    DsIconPathElement('M5.364 3.848C4 6 3 9.652 3 12.652V19a2 2 0 002 2h14a2 2 0 002-2v-5c0-2.334-1.816-4.668-2.622-7.002'), // key: vlsvfu
    DsIconPathElement('M7 3h11.379a2 2 0 011.789 1.106l.723 1.447A1 1 0 0119.997 7h-8.525a2 2 0 01-1.789-1.106L8.79 4.105a2 2 0 10-3.579 1.789l2.261 4.522A5 5 0 018 12.652V21'), // key: 12exh5
  ]);

  /// `paperclip.mjs`
  static const DsLucideGlyph paperclip =
      DsLucideGlyph('paperclip', <DsIconElement>[
    DsIconPathElement('m16 6-8.414 8.586a2 2 0 0 0 2.829 2.829l8.414-8.586a4 4 0 1 0-5.657-5.657l-8.379 8.551a6 6 0 1 0 8.485 8.485l8.379-8.551'), // key: 1miecu
  ]);

  /// `parasol.mjs`
  static const DsLucideGlyph parasol =
      DsLucideGlyph('parasol', <DsIconElement>[
    DsIconPathElement('M12.5 11.134 18.196 21'), // key: gf58kt
    DsIconPathElement('M20.425 5.299a10 10 0 0 0-16.941 9.78c.183.563.843.774 1.355.478L20.16 6.711c.512-.296.66-.973.264-1.413'), // key: znqfe4
    DsIconPathElement('M21 21H3'), // key: oafrgs
  ]);

  /// `parentheses.mjs`
  static const DsLucideGlyph parentheses =
      DsLucideGlyph('parentheses', <DsIconElement>[
    DsIconPathElement('M8 21s-4-3-4-9 4-9 4-9'), // key: uto9ud
    DsIconPathElement('M16 3s4 3 4 9-4 9-4 9'), // key: 4w2vsq
  ]);

  /// `parking-meter.mjs`
  static const DsLucideGlyph parkingMeter =
      DsLucideGlyph('parking-meter', <DsIconElement>[
    DsIconPathElement('M11 15h2'), // key: 199qp6
    DsIconPathElement('M12 12v3'), // key: 158kv8
    DsIconPathElement('M12 19v3'), // key: npa21l
    DsIconPathElement('M15.282 19a1 1 0 0 0 .948-.68l2.37-6.988a7 7 0 1 0-13.2 0l2.37 6.988a1 1 0 0 0 .948.68z'), // key: 1jofit
    DsIconPathElement('M9 9a3 3 0 1 1 6 0'), // key: jdoeu8
  ]);

  /// `party-popper.mjs`
  static const DsLucideGlyph partyPopper =
      DsLucideGlyph('party-popper', <DsIconElement>[
    DsIconPathElement('M5.8 11.3 2 22l10.7-3.79'), // key: gwxi1d
    DsIconPathElement('M4 3h.01'), // key: 1vcuye
    DsIconPathElement('M22 8h.01'), // key: 1mrtc2
    DsIconPathElement('M15 2h.01'), // key: 1cjtqr
    DsIconPathElement('M22 20h.01'), // key: 1mrys2
    DsIconPathElement('m22 2-2.24.75a2.9 2.9 0 0 0-1.96 3.12c.1.86-.57 1.63-1.45 1.63h-.38c-.86 0-1.6.6-1.76 1.44L14 10'), // key: hbicv8
    DsIconPathElement('m22 13-.82-.33c-.86-.34-1.82.2-1.98 1.11c-.11.7-.72 1.22-1.43 1.22H17'), // key: 1i94pl
    DsIconPathElement('m11 2 .33.82c.34.86-.2 1.82-1.11 1.98C9.52 4.9 9 5.52 9 6.23V7'), // key: 1cofks
    DsIconPathElement('M11 13c1.93 1.93 2.83 4.17 2 5-.83.83-3.07-.07-5-2-1.93-1.93-2.83-4.17-2-5 .83-.83 3.07.07 5 2Z'), // key: 4kbmks
  ]);

  /// `pause.mjs`
  static const DsLucideGlyph pause =
      DsLucideGlyph('pause', <DsIconElement>[
    DsIconRectElement(14, 3, 5, 18, 1), // key: kaeet6
    DsIconRectElement(5, 3, 5, 18, 1), // key: 1wsw3u
  ]);

  /// `paw-print.mjs`
  static const DsLucideGlyph pawPrint =
      DsLucideGlyph('paw-print', <DsIconElement>[
    DsIconCircleElement(11, 4, 2), // key: vol9p0
    DsIconCircleElement(18, 8, 2), // key: 17gozi
    DsIconCircleElement(20, 16, 2), // key: 1v9bxh
    DsIconPathElement('M9 10a5 5 0 0 1 5 5v3.5a3.5 3.5 0 0 1-6.84 1.045Q6.52 17.48 4.46 16.84A3.5 3.5 0 0 1 5.5 10Z'), // key: 1ydw1z
  ]);

  /// `pc-case.mjs`
  static const DsLucideGlyph pcCase =
      DsLucideGlyph('pc-case', <DsIconElement>[
    DsIconRectElement(5, 2, 14, 20, 2), // key: 1uq1d7
    DsIconPathElement('M15 14h.01'), // key: 1kp3bh
    DsIconPathElement('M9 6h6'), // key: dgm16u
    DsIconPathElement('M9 10h6'), // key: 9gxzsh
  ]);

  /// `pen-line.mjs`
  static const DsLucideGlyph penLine =
      DsLucideGlyph('pen-line', <DsIconElement>[
    DsIconPathElement('M13 21h8'), // key: 1jsn5i
    DsIconPathElement('M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z'), // key: 1a8usu
  ]);

  /// `pen-off.mjs`
  static const DsLucideGlyph penOff =
      DsLucideGlyph('pen-off', <DsIconElement>[
    DsIconPathElement('m10 10-6.157 6.162a2 2 0 0 0-.5.833l-1.322 4.36a.5.5 0 0 0 .622.624l4.358-1.323a2 2 0 0 0 .83-.5L14 13.982'), // key: bjo8r8
    DsIconPathElement('m12.829 7.172 4.359-4.346a1 1 0 1 1 3.986 3.986l-4.353 4.353'), // key: 16h5ne
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `pen-tool.mjs`
  static const DsLucideGlyph penTool =
      DsLucideGlyph('pen-tool', <DsIconElement>[
    DsIconPathElement('M15.707 21.293a1 1 0 0 1-1.414 0l-1.586-1.586a1 1 0 0 1 0-1.414l5.586-5.586a1 1 0 0 1 1.414 0l1.586 1.586a1 1 0 0 1 0 1.414z'), // key: nt11vn
    DsIconPathElement('m18 13-1.375-6.874a1 1 0 0 0-.746-.776L3.235 2.028a1 1 0 0 0-1.207 1.207L5.35 15.879a1 1 0 0 0 .776.746L13 18'), // key: 15qc1e
    DsIconPathElement('m2.3 2.3 7.286 7.286'), // key: 1wuzzi
    DsIconCircleElement(11, 11, 2), // key: xmgehs
  ]);

  /// `pen.mjs`
  static const DsLucideGlyph pen =
      DsLucideGlyph('pen', <DsIconElement>[
    DsIconPathElement('M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z'), // key: 1a8usu
  ]);

  /// `pencil-line.mjs`
  static const DsLucideGlyph pencilLine =
      DsLucideGlyph('pencil-line', <DsIconElement>[
    DsIconPathElement('M13 21h8'), // key: 1jsn5i
    DsIconPathElement('m15 5 4 4'), // key: 1mk7zo
    DsIconPathElement('M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z'), // key: 1a8usu
  ]);

  /// `pencil-off.mjs`
  static const DsLucideGlyph pencilOff =
      DsLucideGlyph('pencil-off', <DsIconElement>[
    DsIconPathElement('m10 10-6.157 6.162a2 2 0 0 0-.5.833l-1.322 4.36a.5.5 0 0 0 .622.624l4.358-1.323a2 2 0 0 0 .83-.5L14 13.982'), // key: bjo8r8
    DsIconPathElement('m12.829 7.172 4.359-4.346a1 1 0 1 1 3.986 3.986l-4.353 4.353'), // key: 16h5ne
    DsIconPathElement('m15 5 4 4'), // key: 1mk7zo
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `pencil-ruler.mjs`
  static const DsLucideGlyph pencilRuler =
      DsLucideGlyph('pencil-ruler', <DsIconElement>[
    DsIconPathElement('M13 7 8.7 2.7a2.41 2.41 0 0 0-3.4 0L2.7 5.3a2.41 2.41 0 0 0 0 3.4L7 13'), // key: orapub
    DsIconPathElement('m8 6 2-2'), // key: 115y1s
    DsIconPathElement('m18 16 2-2'), // key: ee94s4
    DsIconPathElement('m17 11 4.3 4.3c.94.94.94 2.46 0 3.4l-2.6 2.6c-.94.94-2.46.94-3.4 0L11 17'), // key: cfq27r
    DsIconPathElement('M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z'), // key: 1a8usu
    DsIconPathElement('m15 5 4 4'), // key: 1mk7zo
  ]);

  /// `pencil-sparkles.mjs`
  static const DsLucideGlyph pencilSparkles =
      DsLucideGlyph('pencil-sparkles', <DsIconElement>[
    DsIconPathElement('M10 3H8'), // key: mzdi2d
    DsIconPathElement('m15.007 5.008 3.987 3.986'), // key: 1scubj
    DsIconPathElement('M20 15v4'), // key: nmhudv
    DsIconPathElement('M21.174 6.813a2.82 2.82 0 0 0-3.986-3.987L3.842 16.175a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z'), // key: fs0856
    DsIconPathElement('M22 17h-4'), // key: 1sj068
    DsIconPathElement('M4 5v4'), // key: 13jjxc
    DsIconPathElement('M6 7H2'), // key: 8zbtv0
    DsIconPathElement('M9 2v2'), // key: 165o2o
  ]);

  /// `pencil.mjs`
  static const DsLucideGlyph pencil =
      DsLucideGlyph('pencil', <DsIconElement>[
    DsIconPathElement('M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z'), // key: 1a8usu
    DsIconPathElement('m15 5 4 4'), // key: 1mk7zo
  ]);

  /// `pentagon.mjs`
  static const DsLucideGlyph pentagon =
      DsLucideGlyph('pentagon', <DsIconElement>[
    DsIconPathElement('M10.83 2.38a2 2 0 0 1 2.34 0l8 5.74a2 2 0 0 1 .73 2.25l-3.04 9.26a2 2 0 0 1-1.9 1.37H7.04a2 2 0 0 1-1.9-1.37L2.1 10.37a2 2 0 0 1 .73-2.25z'), // key: 2hea0t
  ]);

  /// `percent.mjs`
  static const DsLucideGlyph percent =
      DsLucideGlyph('percent', <DsIconElement>[
    DsIconLineElement(19, 5, 5, 19), // key: 1x9vlm
    DsIconCircleElement(6.5, 6.5, 2.5), // key: 4mh3h7
    DsIconCircleElement(17.5, 17.5, 2.5), // key: 1mdrzq
  ]);

  /// `person-standing.mjs`
  static const DsLucideGlyph personStanding =
      DsLucideGlyph('person-standing', <DsIconElement>[
    DsIconCircleElement(12, 5, 1), // key: gxeob9
    DsIconPathElement('m9 20 3-6 3 6'), // key: se2kox
    DsIconPathElement('m6 8 6 2 6-2'), // key: 4o3us4
    DsIconPathElement('M12 10v4'), // key: 1kjpxc
  ]);

  /// `phi.mjs`
  static const DsLucideGlyph phi =
      DsLucideGlyph('phi', <DsIconElement>[
    DsIconPathElement('M12 2v20'), // key: t6zp3m
    DsIconCircleElement(12, 12, 7), // key: fim9np
  ]);

  /// `philippine-peso.mjs`
  static const DsLucideGlyph philippinePeso =
      DsLucideGlyph('philippine-peso', <DsIconElement>[
    DsIconPathElement('M20 11H4'), // key: 6ut86h
    DsIconPathElement('M20 7H4'), // key: zbl0bi
    DsIconPathElement('M7 21V4a1 1 0 0 1 1-1h4a1 1 0 0 1 0 12H7'), // key: 1ana5r
  ]);

  /// `phone-call.mjs`
  static const DsLucideGlyph phoneCall =
      DsLucideGlyph('phone-call', <DsIconElement>[
    DsIconPathElement('M13 2a9 9 0 0 1 9 9'), // key: 1itnx2
    DsIconPathElement('M13 6a5 5 0 0 1 5 5'), // key: 11nki7
    DsIconPathElement('M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384'), // key: 9njp5v
  ]);

  /// `phone-forwarded.mjs`
  static const DsLucideGlyph phoneForwarded =
      DsLucideGlyph('phone-forwarded', <DsIconElement>[
    DsIconPathElement('M14 6h8'), // key: yd68k4
    DsIconPathElement('m18 2 4 4-4 4'), // key: pucp1d
    DsIconPathElement('M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384'), // key: 9njp5v
  ]);

  /// `phone-incoming.mjs`
  static const DsLucideGlyph phoneIncoming =
      DsLucideGlyph('phone-incoming', <DsIconElement>[
    DsIconPathElement('M16 2v6h6'), // key: 1mfrl5
    DsIconPathElement('m22 2-6 6'), // key: 6f0sa0
    DsIconPathElement('M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384'), // key: 9njp5v
  ]);

  /// `phone-missed.mjs`
  static const DsLucideGlyph phoneMissed =
      DsLucideGlyph('phone-missed', <DsIconElement>[
    DsIconPathElement('m16 2 6 6'), // key: 1gw87d
    DsIconPathElement('m22 2-6 6'), // key: 6f0sa0
    DsIconPathElement('M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384'), // key: 9njp5v
  ]);

  /// `phone-off.mjs`
  static const DsLucideGlyph phoneOff =
      DsLucideGlyph('phone-off', <DsIconElement>[
    DsIconPathElement('M10.1 13.9a14 14 0 0 0 3.732 2.668 1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2 18 18 0 0 1-12.728-5.272'), // key: 1wngk7
    DsIconPathElement('M22 2 2 22'), // key: y4kqgn
    DsIconPathElement('M4.76 13.582A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 .244.473'), // key: 10hv5p
  ]);

  /// `phone-outgoing.mjs`
  static const DsLucideGlyph phoneOutgoing =
      DsLucideGlyph('phone-outgoing', <DsIconElement>[
    DsIconPathElement('m16 8 6-6'), // key: oawc05
    DsIconPathElement('M22 8V2h-6'), // key: oqy2zc
    DsIconPathElement('M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384'), // key: 9njp5v
  ]);

  /// `phone.mjs`
  static const DsLucideGlyph phone =
      DsLucideGlyph('phone', <DsIconElement>[
    DsIconPathElement('M13.832 16.568a1 1 0 0 0 1.213-.303l.355-.465A2 2 0 0 1 17 15h3a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2A18 18 0 0 1 2 4a2 2 0 0 1 2-2h3a2 2 0 0 1 2 2v3a2 2 0 0 1-.8 1.6l-.468.351a1 1 0 0 0-.292 1.233 14 14 0 0 0 6.392 6.384'), // key: 9njp5v
  ]);

  /// `pi.mjs`
  static const DsLucideGlyph pi =
      DsLucideGlyph('pi', <DsIconElement>[
    DsIconLineElement(9, 4, 9, 20), // key: ovs5a5
    DsIconPathElement('M4 7c0-1.7 1.3-3 3-3h13'), // key: 10pag4
    DsIconPathElement('M18 20c-1.7 0-3-1.3-3-3V4'), // key: 1gaosr
  ]);

  /// `piano.mjs`
  static const DsLucideGlyph piano =
      DsLucideGlyph('piano', <DsIconElement>[
    DsIconPathElement('M18.5 8c-1.4 0-2.6-.8-3.2-2A6.87 6.87 0 0 0 2 9v11a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-8.5C22 9.6 20.4 8 18.5 8'), // key: lag0yf
    DsIconPathElement('M2 14h20'), // key: myj16y
    DsIconPathElement('M6 14v4'), // key: 9ng0ue
    DsIconPathElement('M10 14v4'), // key: 1v8uk5
    DsIconPathElement('M14 14v4'), // key: 1tqops
    DsIconPathElement('M18 14v4'), // key: 18uqwm
  ]);

  /// `pickaxe.mjs`
  static const DsLucideGlyph pickaxe =
      DsLucideGlyph('pickaxe', <DsIconElement>[
    DsIconPathElement('m14 13-8.381 8.38a1 1 0 0 1-3.001-3L11 9.999'), // key: 1lw9ds
    DsIconPathElement('M15.973 4.027A13 13 0 0 0 5.902 2.373c-1.398.342-1.092 2.158.277 2.601a19.9 19.9 0 0 1 5.822 3.024'), // key: ffj4ej
    DsIconPathElement('M16.001 11.999a19.9 19.9 0 0 1 3.024 5.824c.444 1.369 2.26 1.676 2.603.278A13 13 0 0 0 20 8.069'), // key: 8tj4zw
    DsIconPathElement('M18.352 3.352a1.205 1.205 0 0 0-1.704 0l-5.296 5.296a1.205 1.205 0 0 0 0 1.704l2.296 2.296a1.205 1.205 0 0 0 1.704 0l5.296-5.296a1.205 1.205 0 0 0 0-1.704z'), // key: hh6h97
  ]);

  /// `picture-in-picture-2.mjs`
  static const DsLucideGlyph pictureInPicture2 =
      DsLucideGlyph('picture-in-picture-2', <DsIconElement>[
    DsIconPathElement('M21 9V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v10c0 1.1.9 2 2 2h4'), // key: daa4of
    DsIconRectElement(12, 13, 10, 7, 2), // key: 1nb8gs
  ]);

  /// `picture-in-picture.mjs`
  static const DsLucideGlyph pictureInPicture =
      DsLucideGlyph('picture-in-picture', <DsIconElement>[
    DsIconPathElement('M2 10h6V4'), // key: zwrco
    DsIconPathElement('m2 4 6 6'), // key: ug085t
    DsIconPathElement('M21 10V7a2 2 0 0 0-2-2h-7'), // key: git5jr
    DsIconPathElement('M3 14v2a2 2 0 0 0 2 2h3'), // key: 1f7fh3
    DsIconRectElement(12, 14, 10, 7, 1), // key: 1wjs3o
  ]);

  /// `piggy-bank.mjs`
  static const DsLucideGlyph piggyBank =
      DsLucideGlyph('piggy-bank', <DsIconElement>[
    DsIconPathElement('M11 17h3v2a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1v-3a3.16 3.16 0 0 0 2-2h1a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1h-1a5 5 0 0 0-2-4V3a4 4 0 0 0-3.2 1.6l-.3.4H11a6 6 0 0 0-6 6v1a5 5 0 0 0 2 4v3a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1z'), // key: 1piglc
    DsIconPathElement('M16 10h.01'), // key: 1m94wz
    DsIconPathElement('M2 8v1a2 2 0 0 0 2 2h1'), // key: 1env43
  ]);

  /// `pilcrow-left.mjs`
  static const DsLucideGlyph pilcrowLeft =
      DsLucideGlyph('pilcrow-left', <DsIconElement>[
    DsIconPathElement('M14 3v11'), // key: mlfb7b
    DsIconPathElement('M14 9h-3a3 3 0 0 1 0-6h9'), // key: 1ulc19
    DsIconPathElement('M18 3v11'), // key: 1phi0r
    DsIconPathElement('M22 18H2l4-4'), // key: yt65j9
    DsIconPathElement('m6 22-4-4'), // key: 6jgyf5
  ]);

  /// `pilcrow-right.mjs`
  static const DsLucideGlyph pilcrowRight =
      DsLucideGlyph('pilcrow-right', <DsIconElement>[
    DsIconPathElement('M10 3v11'), // key: o3l5kj
    DsIconPathElement('M10 9H7a1 1 0 0 1 0-6h8'), // key: 1wb1nc
    DsIconPathElement('M14 3v11'), // key: mlfb7b
    DsIconPathElement('m18 14 4 4H2'), // key: 4r8io1
    DsIconPathElement('m22 18-4 4'), // key: 1hjjrd
  ]);

  /// `pilcrow.mjs`
  static const DsLucideGlyph pilcrow =
      DsLucideGlyph('pilcrow', <DsIconElement>[
    DsIconPathElement('M13 4v16'), // key: 8vvj80
    DsIconPathElement('M17 4v16'), // key: 7dpous
    DsIconPathElement('M19 4H9.5a4.5 4.5 0 0 0 0 9H13'), // key: sh4n9v
  ]);

  /// `pill-bottle.mjs`
  static const DsLucideGlyph pillBottle =
      DsLucideGlyph('pill-bottle', <DsIconElement>[
    DsIconPathElement('M18 11h-4a1 1 0 0 0-1 1v5a1 1 0 0 0 1 1h4'), // key: 17ldeb
    DsIconPathElement('M6 7v13a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V7'), // key: nc37y6
    DsIconRectElement(4, 2, 16, 5, 1), // key: 3jeezo
  ]);

  /// `pill.mjs`
  static const DsLucideGlyph pill =
      DsLucideGlyph('pill', <DsIconElement>[
    DsIconPathElement('m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z'), // key: wa1lgi
    DsIconPathElement('m8.5 8.5 7 7'), // key: rvfmvr
  ]);

  /// `pin-off.mjs`
  static const DsLucideGlyph pinOff =
      DsLucideGlyph('pin-off', <DsIconElement>[
    DsIconPathElement('M12 17v5'), // key: bb1du9
    DsIconPathElement('M15 9.34V7a1 1 0 0 1 1-1 2 2 0 0 0 0-4H7.89'), // key: znwnzq
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M9 9v1.76a2 2 0 0 1-1.11 1.79l-1.78.9A2 2 0 0 0 5 15.24V16a1 1 0 0 0 1 1h11'), // key: c9qhm2
  ]);

  /// `pin.mjs`
  static const DsLucideGlyph pin =
      DsLucideGlyph('pin', <DsIconElement>[
    DsIconPathElement('M12 17v5'), // key: bb1du9
    DsIconPathElement('M9 10.76a2 2 0 0 1-1.11 1.79l-1.78.9A2 2 0 0 0 5 15.24V16a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-.76a2 2 0 0 0-1.11-1.79l-1.78-.9A2 2 0 0 1 15 10.76V7a1 1 0 0 1 1-1 2 2 0 0 0 0-4H8a2 2 0 0 0 0 4 1 1 0 0 1 1 1z'), // key: 1nkz8b
  ]);

  /// `pipette.mjs`
  static const DsLucideGlyph pipette =
      DsLucideGlyph('pipette', <DsIconElement>[
    DsIconPathElement('m12 9-8.414 8.414A2 2 0 0 0 3 18.828v1.344a2 2 0 0 1-.586 1.414A2 2 0 0 1 3.828 21h1.344a2 2 0 0 0 1.414-.586L15 12'), // key: 1y3wsu
    DsIconPathElement('m18 9 .4.4a1 1 0 1 1-3 3l-3.8-3.8a1 1 0 1 1 3-3l.4.4 3.4-3.4a1 1 0 1 1 3 3z'), // key: 110lr1
    DsIconPathElement('m2 22 .414-.414'), // key: jhxm08
  ]);

  /// `pizza.mjs`
  static const DsLucideGlyph pizza =
      DsLucideGlyph('pizza', <DsIconElement>[
    DsIconPathElement('m12 14-1 1'), // key: 11onhr
    DsIconPathElement('m13.75 18.25-1.25 1.42'), // key: 1yisr3
    DsIconPathElement('M17.775 5.654a15.68 15.68 0 0 0-12.121 12.12'), // key: 1qtqk6
    DsIconPathElement('M18.8 9.3a1 1 0 0 0 2.1 7.7'), // key: fbbbr2
    DsIconPathElement('M21.964 20.732a1 1 0 0 1-1.232 1.232l-18-5a1 1 0 0 1-.695-1.232A19.68 19.68 0 0 1 15.732 2.037a1 1 0 0 1 1.232.695z'), // key: 1hyfdd
  ]);

  /// `plane-landing.mjs`
  static const DsLucideGlyph planeLanding =
      DsLucideGlyph('plane-landing', <DsIconElement>[
    DsIconPathElement('M2 22h20'), // key: 272qi7
    DsIconPathElement('M3.77 10.77 2 9l2-4.5 1.1.55c.55.28.9.84.9 1.45s.35 1.17.9 1.45L8 8.5l3-6 1.05.53a2 2 0 0 1 1.09 1.52l.72 5.4a2 2 0 0 0 1.09 1.52l4.4 2.2c.42.22.78.55 1.01.96l.6 1.03c.49.88-.06 1.98-1.06 2.1l-1.18.15c-.47.06-.95-.02-1.37-.24L4.29 11.15a2 2 0 0 1-.52-.38Z'), // key: 1ma21e
  ]);

  /// `plane-takeoff.mjs`
  static const DsLucideGlyph planeTakeoff =
      DsLucideGlyph('plane-takeoff', <DsIconElement>[
    DsIconPathElement('M2 22h20'), // key: 272qi7
    DsIconPathElement('M6.36 17.4 4 17l-2-4 1.1-.55a2 2 0 0 1 1.8 0l.17.1a2 2 0 0 0 1.8 0L8 12 5 6l.9-.45a2 2 0 0 1 2.09.2l4.02 3a2 2 0 0 0 2.1.2l4.19-2.06a2.41 2.41 0 0 1 1.73-.17L21 7a1.4 1.4 0 0 1 .87 1.99l-.38.76c-.23.46-.6.84-1.07 1.08L7.58 17.2a2 2 0 0 1-1.22.18Z'), // key: fkigj9
  ]);

  /// `plane.mjs`
  static const DsLucideGlyph plane =
      DsLucideGlyph('plane', <DsIconElement>[
    DsIconPathElement('M17.8 19.2 16 11l3.5-3.5C21 6 21.5 4 21 3c-1-.5-3 0-4.5 1.5L13 8 4.8 6.2c-.5-.1-.9.1-1.1.5l-.3.5c-.2.5-.1 1 .3 1.3L9 12l-2 3H4l-1 1 3 2 2 3 1-1v-3l3-2 3.5 5.3c.3.4.8.5 1.3.3l.5-.2c.4-.3.6-.7.5-1.2z'), // key: 1v9wt8
  ]);

  /// `play-off.mjs`
  static const DsLucideGlyph playOff =
      DsLucideGlyph('play-off', <DsIconElement>[
    DsIconPathElement('m10.215 4.56 9.79 5.71a2 2 0 0 1 .003 3.458l-.393.23'), // key: fdtkwz
    DsIconPathElement('m16.042 16.042-8.034 4.686A2 2 0 0 1 5 19V5'), // key: 1c8hxg
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `play.mjs`
  static const DsLucideGlyph play =
      DsLucideGlyph('play', <DsIconElement>[
    DsIconPathElement('M5 5a2 2 0 0 1 3.008-1.728l11.997 6.998a2 2 0 0 1 .003 3.458l-12 7A2 2 0 0 1 5 19z'), // key: 10ikf1
  ]);

  /// `plug-2.mjs`
  static const DsLucideGlyph plug2 =
      DsLucideGlyph('plug-2', <DsIconElement>[
    DsIconPathElement('M9 2v6'), // key: 17ngun
    DsIconPathElement('M15 2v6'), // key: s7yy2p
    DsIconPathElement('M12 17v5'), // key: bb1du9
    DsIconPathElement('M5 8h14'), // key: pcz4l3
    DsIconPathElement('M6 11V8h12v3a6 6 0 1 1-12 0Z'), // key: wtfw2c
  ]);

  /// `plug-zap.mjs`
  static const DsLucideGlyph plugZap =
      DsLucideGlyph('plug-zap', <DsIconElement>[
    DsIconPathElement('M6.3 20.3a2.4 2.4 0 0 0 3.4 0L12 18l-6-6-2.3 2.3a2.4 2.4 0 0 0 0 3.4Z'), // key: goz73y
    DsIconPathElement('m2 22 3-3'), // key: 19mgm9
    DsIconPathElement('M7.5 13.5 10 11'), // key: 7xgeeb
    DsIconPathElement('M10.5 16.5 13 14'), // key: 10btkg
    DsIconPathElement('m18 3-4 4h6l-4 4'), // key: 16psg9
  ]);

  /// `plug.mjs`
  static const DsLucideGlyph plug =
      DsLucideGlyph('plug', <DsIconElement>[
    DsIconPathElement('M12 22v-5'), // key: 1ega77
    DsIconPathElement('M15 8V2'), // key: 18g5xt
    DsIconPathElement('M17 8a1 1 0 0 1 1 1v4a4 4 0 0 1-4 4h-4a4 4 0 0 1-4-4V9a1 1 0 0 1 1-1z'), // key: 1xoxul
    DsIconPathElement('M9 8V2'), // key: 14iosj
  ]);

  /// `plus.mjs`
  static const DsLucideGlyph plus =
      DsLucideGlyph('plus', <DsIconElement>[
    DsIconPathElement('M5 12h14'), // key: 1ays0h
    DsIconPathElement('M12 5v14'), // key: s699le
  ]);

  /// `pocket-knife.mjs`
  static const DsLucideGlyph pocketKnife =
      DsLucideGlyph('pocket-knife', <DsIconElement>[
    DsIconPathElement('M3 2v1c0 1 2 1 2 2S3 6 3 7s2 1 2 2-2 1-2 2 2 1 2 2'), // key: 19w3oe
    DsIconPathElement('M18 6h.01'), // key: 1v4wsw
    DsIconPathElement('M6 18h.01'), // key: uhywen
    DsIconPathElement('M20.83 8.83a4 4 0 0 0-5.66-5.66l-12 12a4 4 0 1 0 5.66 5.66Z'), // key: 6fykxj
    DsIconPathElement('M18 11.66V22a4 4 0 0 0 4-4V6'), // key: 1utzek
  ]);

  /// `podium.mjs`
  static const DsLucideGlyph podium =
      DsLucideGlyph('podium', <DsIconElement>[
    DsIconPathElement('M12 6V2h-1'), // key: 1hv4eo
    DsIconPathElement('M9 15a1 1 0 0 0-1-1H4a1 1 0 0 0-1 1v5a1 1 0 0 0 1 1h16a1 1 0 0 0 1-1v-3a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1'), // key: 1jvw5n
    DsIconPathElement('M9 21V11a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v10'), // key: rgi5dp
  ]);

  /// `pointer-off.mjs`
  static const DsLucideGlyph pointerOff =
      DsLucideGlyph('pointer-off', <DsIconElement>[
    DsIconPathElement('M10 4.5V4a2 2 0 0 0-2.41-1.957'), // key: jsi14n
    DsIconPathElement('M13.9 8.4a2 2 0 0 0-1.26-1.295'), // key: hirc7f
    DsIconPathElement('M21.7 16.2A8 8 0 0 0 22 14v-3a2 2 0 1 0-4 0v-1a2 2 0 0 0-3.63-1.158'), // key: 1jxb2e
    DsIconPathElement('m7 15-1.8-1.8a2 2 0 0 0-2.79 2.86L6 19.7a7.74 7.74 0 0 0 6 2.3h2a8 8 0 0 0 5.657-2.343'), // key: 10r7hm
    DsIconPathElement('M6 6v8'), // key: tv5xkp
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `pointer.mjs`
  static const DsLucideGlyph pointer =
      DsLucideGlyph('pointer', <DsIconElement>[
    DsIconPathElement('M22 14a8 8 0 0 1-8 8'), // key: 56vcr3
    DsIconPathElement('M18 11v-1a2 2 0 0 0-2-2a2 2 0 0 0-2 2'), // key: 1agjmk
    DsIconPathElement('M14 10V9a2 2 0 0 0-2-2a2 2 0 0 0-2 2v1'), // key: wdbh2u
    DsIconPathElement('M10 9.5V4a2 2 0 0 0-2-2a2 2 0 0 0-2 2v10'), // key: 1ibuk9
    DsIconPathElement('M18 11a2 2 0 1 1 4 0v3a8 8 0 0 1-8 8h-2c-2.8 0-4.5-.86-5.99-2.34l-3.6-3.6a2 2 0 0 1 2.83-2.82L7 15'), // key: g6ys72
  ]);

  /// `popcorn.mjs`
  static const DsLucideGlyph popcorn =
      DsLucideGlyph('popcorn', <DsIconElement>[
    DsIconPathElement('M18 8a2 2 0 0 0 0-4 2 2 0 0 0-4 0 2 2 0 0 0-4 0 2 2 0 0 0-4 0 2 2 0 0 0 0 4'), // key: 10td1f
    DsIconPathElement('M10 22 9 8'), // key: yjptiv
    DsIconPathElement('m14 22 1-14'), // key: 8jwc8b
    DsIconPathElement('M20 8c.5 0 .9.4.8 1l-2.6 12c-.1.5-.7 1-1.2 1H7c-.6 0-1.1-.4-1.2-1L3.2 9c-.1-.6.3-1 .8-1Z'), // key: 1qo33t
  ]);

  /// `popsicle.mjs`
  static const DsLucideGlyph popsicle =
      DsLucideGlyph('popsicle', <DsIconElement>[
    DsIconPathElement('M18.6 14.4c.8-.8.8-2 0-2.8l-8.1-8.1a4.95 4.95 0 1 0-7.1 7.1l8.1 8.1c.9.7 2.1.7 2.9-.1Z'), // key: 1o68ps
    DsIconPathElement('m22 22-5.5-5.5'), // key: 17o70y
  ]);

  /// `pound-sterling.mjs`
  static const DsLucideGlyph poundSterling =
      DsLucideGlyph('pound-sterling', <DsIconElement>[
    DsIconPathElement('M18 7c0-5.333-8-5.333-8 0'), // key: 1prm2n
    DsIconPathElement('M10 7v14'), // key: 18tmcs
    DsIconPathElement('M6 21h12'), // key: 4dkmi1
    DsIconPathElement('M6 13h10'), // key: ybwr4a
  ]);

  /// `power-off.mjs`
  static const DsLucideGlyph powerOff =
      DsLucideGlyph('power-off', <DsIconElement>[
    DsIconPathElement('M18.36 6.64A9 9 0 0 1 20.77 15'), // key: dxknvb
    DsIconPathElement('M6.16 6.16a9 9 0 1 0 12.68 12.68'), // key: 1x7qb5
    DsIconPathElement('M12 2v4'), // key: 3427ic
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `power.mjs`
  static const DsLucideGlyph power =
      DsLucideGlyph('power', <DsIconElement>[
    DsIconPathElement('M12 2v10'), // key: mnfbl
    DsIconPathElement('M18.4 6.6a9 9 0 1 1-12.77.04'), // key: obofu9
  ]);

  /// `presentation.mjs`
  static const DsLucideGlyph presentation =
      DsLucideGlyph('presentation', <DsIconElement>[
    DsIconPathElement('M2 3h20'), // key: 91anmk
    DsIconPathElement('M21 3v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V3'), // key: 2k9sn8
    DsIconPathElement('m7 21 5-5 5 5'), // key: bip4we
  ]);

  /// `printer-check.mjs`
  static const DsLucideGlyph printerCheck =
      DsLucideGlyph('printer-check', <DsIconElement>[
    DsIconPathElement('M13.5 22H7a1 1 0 0 1-1-1v-6a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v.5'), // key: qeb09x
    DsIconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
    DsIconPathElement('M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v2'), // key: 1md90i
    DsIconPathElement('M6 9V3a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v6'), // key: 1itne7
  ]);

  /// `printer-x.mjs`
  static const DsLucideGlyph printerX =
      DsLucideGlyph('printer-x', <DsIconElement>[
    DsIconPathElement('M12.531 22H7a1 1 0 0 1-1-1v-6a1 1 0 0 1 1-1h6.377'), // key: 1w39xo
    DsIconPathElement('m16.5 16.5 5 5'), // key: zc9lw7
    DsIconPathElement('m16.5 21.5 5-5'), // key: 1fr29m
    DsIconPathElement('M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v1.5'), // key: 18he39
    DsIconPathElement('M6 9V3a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v6'), // key: 1itne7
  ]);

  /// `printer.mjs`
  static const DsLucideGlyph printer =
      DsLucideGlyph('printer', <DsIconElement>[
    DsIconPathElement('M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2'), // key: 143wyd
    DsIconPathElement('M6 9V3a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v6'), // key: 1itne7
    DsIconRectElement(6, 14, 12, 8, 1), // key: 1ue0tg
  ]);

  /// `projector.mjs`
  static const DsLucideGlyph projector =
      DsLucideGlyph('projector', <DsIconElement>[
    DsIconPathElement('M5 7 3 5'), // key: 1yys58
    DsIconPathElement('M9 6V3'), // key: 1ptz9u
    DsIconPathElement('m13 7 2-2'), // key: 1w3vmq
    DsIconCircleElement(9, 13, 3), // key: 1mma13
    DsIconPathElement('M11.83 12H20a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-4a2 2 0 0 1 2-2h2.17'), // key: 2frwzc
    DsIconPathElement('M16 16h2'), // key: dnq2od
  ]);

  /// `proportions.mjs`
  static const DsLucideGlyph proportions =
      DsLucideGlyph('proportions', <DsIconElement>[
    DsIconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
    DsIconPathElement('M12 9v11'), // key: 1fnkrn
    DsIconPathElement('M2 9h13a2 2 0 0 1 2 2v9'), // key: 11z3ex
  ]);

  /// `puzzle.mjs`
  static const DsLucideGlyph puzzle =
      DsLucideGlyph('puzzle', <DsIconElement>[
    DsIconPathElement('M15.39 4.39a1 1 0 0 0 1.68-.474 2.5 2.5 0 1 1 3.014 3.015 1 1 0 0 0-.474 1.68l1.683 1.682a2.414 2.414 0 0 1 0 3.414L19.61 15.39a1 1 0 0 1-1.68-.474 2.5 2.5 0 1 0-3.014 3.015 1 1 0 0 1 .474 1.68l-1.683 1.682a2.414 2.414 0 0 1-3.414 0L8.61 19.61a1 1 0 0 0-1.68.474 2.5 2.5 0 1 1-3.014-3.015 1 1 0 0 0 .474-1.68l-1.683-1.682a2.414 2.414 0 0 1 0-3.414L4.39 8.61a1 1 0 0 1 1.68.474 2.5 2.5 0 1 0 3.014-3.015 1 1 0 0 1-.474-1.68l1.683-1.682a2.414 2.414 0 0 1 3.414 0z'), // key: w46dr5
  ]);

  /// `pyramid.mjs`
  static const DsLucideGlyph pyramid =
      DsLucideGlyph('pyramid', <DsIconElement>[
    DsIconPathElement('M2.5 16.88a1 1 0 0 1-.32-1.43l9-13.02a1 1 0 0 1 1.64 0l9 13.01a1 1 0 0 1-.32 1.44l-8.51 4.86a2 2 0 0 1-1.98 0Z'), // key: aenxs0
    DsIconPathElement('M12 2v20'), // key: t6zp3m
  ]);

  /// `qr-code.mjs`
  static const DsLucideGlyph qrCode =
      DsLucideGlyph('qr-code', <DsIconElement>[
    DsIconRectElement(3, 3, 5, 5, 1), // key: 1tu5fj
    DsIconRectElement(16, 3, 5, 5, 1), // key: 1v8r4q
    DsIconRectElement(3, 16, 5, 5, 1), // key: 1x03jg
    DsIconPathElement('M21 16h-3a2 2 0 0 0-2 2v3'), // key: 177gqh
    DsIconPathElement('M21 21v.01'), // key: ents32
    DsIconPathElement('M12 7v3a2 2 0 0 1-2 2H7'), // key: 8crl2c
    DsIconPathElement('M3 12h.01'), // key: nlz23k
    DsIconPathElement('M12 3h.01'), // key: n36tog
    DsIconPathElement('M12 16v.01'), // key: 133mhm
    DsIconPathElement('M16 12h1'), // key: 1slzba
    DsIconPathElement('M21 12v.01'), // key: 1lwtk9
    DsIconPathElement('M12 21v-1'), // key: 1880an
  ]);

  /// `quote.mjs`
  static const DsLucideGlyph quote =
      DsLucideGlyph('quote', <DsIconElement>[
    DsIconPathElement('M16 3a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2 1 1 0 0 1 1 1v1a2 2 0 0 1-2 2 1 1 0 0 0-1 1v2a1 1 0 0 0 1 1 6 6 0 0 0 6-6V5a2 2 0 0 0-2-2z'), // key: rib7q0
    DsIconPathElement('M5 3a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2 1 1 0 0 1 1 1v1a2 2 0 0 1-2 2 1 1 0 0 0-1 1v2a1 1 0 0 0 1 1 6 6 0 0 0 6-6V5a2 2 0 0 0-2-2z'), // key: 1ymkrd
  ]);

  /// `rabbit.mjs`
  static const DsLucideGlyph rabbit =
      DsLucideGlyph('rabbit', <DsIconElement>[
    DsIconPathElement('M13 16a3 3 0 0 1 2.24 5'), // key: 1epib5
    DsIconPathElement('M18 12h.01'), // key: yjnet6
    DsIconPathElement('M18 21h-8a4 4 0 0 1-4-4 7 7 0 0 1 7-7h.2L9.6 6.4a1 1 0 1 1 2.8-2.8L15.8 7h.2c3.3 0 6 2.7 6 6v1a2 2 0 0 1-2 2h-1a3 3 0 0 0-3 3'), // key: ue9ozu
    DsIconPathElement('M20 8.54V4a2 2 0 1 0-4 0v3'), // key: 49iql8
    DsIconPathElement('M7.612 12.524a3 3 0 1 0-1.6 4.3'), // key: 1e33i0
  ]);

  /// `radar.mjs`
  static const DsLucideGlyph radar =
      DsLucideGlyph('radar', <DsIconElement>[
    DsIconPathElement('M19.07 4.93A10 10 0 0 0 6.99 3.34'), // key: z3du51
    DsIconPathElement('M4 6h.01'), // key: oypzma
    DsIconPathElement('M2.29 9.62A10 10 0 1 0 21.31 8.35'), // key: qzzz0
    DsIconPathElement('M16.24 7.76A6 6 0 1 0 8.23 16.67'), // key: 1yjesh
    DsIconPathElement('M12 18h.01'), // key: mhygvu
    DsIconPathElement('M17.99 11.66A6 6 0 0 1 15.77 16.67'), // key: 1u2y91
    DsIconCircleElement(12, 12, 2), // key: 1c9p78
    DsIconPathElement('m13.41 10.59 5.66-5.66'), // key: mhq4k0
  ]);

  /// `radiation.mjs`
  static const DsLucideGlyph radiation =
      DsLucideGlyph('radiation', <DsIconElement>[
    DsIconPathElement('M12 12h.01'), // key: 1mp3jc
    DsIconPathElement('M14 15.4641a4 4 0 0 1-4 0L7.52786 19.74597 A 1 1 0 0 0 7.99303 21.16211 10 10 0 0 0 16.00697 21.16211 1 1 0 0 0 16.47214 19.74597z'), // key: 1y4lzb
    DsIconPathElement('M16 12a4 4 0 0 0-2-3.464l2.472-4.282a1 1 0 0 1 1.46-.305 10 10 0 0 1 4.006 6.94A1 1 0 0 1 21 12z'), // key: 163ggk
    DsIconPathElement('M8 12a4 4 0 0 1 2-3.464L7.528 4.254a1 1 0 0 0-1.46-.305 10 10 0 0 0-4.006 6.94A1 1 0 0 0 3 12z'), // key: 1l9i0b
  ]);

  /// `radical.mjs`
  static const DsLucideGlyph radical =
      DsLucideGlyph('radical', <DsIconElement>[
    DsIconPathElement('M3 12h3.28a1 1 0 0 1 .948.684l2.298 7.934a.5.5 0 0 0 .96-.044L13.82 4.771A1 1 0 0 1 14.792 4H21'), // key: 1mqj8i
  ]);

  /// `radio-off.mjs`
  static const DsLucideGlyph radioOff =
      DsLucideGlyph('radio-off', <DsIconElement>[
    DsIconPathElement('M13.414 13.414a2 2 0 1 1-2.828-2.828'), // key: srl686
    DsIconPathElement('M16.247 7.761a6 6 0 0 1 1.744 4.572'), // key: 1h86sp
    DsIconPathElement('M19.075 4.933a10 10 0 0 1 2.234 10.72'), // key: 1n13k4
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M4.925 19.067a10 10 0 0 1 0-14.134'), // key: 1q22gi
    DsIconPathElement('M7.753 16.239a6 6 0 0 1 0-8.478'), // key: r2q7qm
  ]);

  /// `radio-receiver.mjs`
  static const DsLucideGlyph radioReceiver =
      DsLucideGlyph('radio-receiver', <DsIconElement>[
    DsIconPathElement('M5 16v2'), // key: g5qcv5
    DsIconPathElement('M19 16v2'), // key: 1gbaio
    DsIconRectElement(2, 8, 20, 8, 2), // key: vjsjur
    DsIconPathElement('M18 12h.01'), // key: yjnet6
  ]);

  /// `radio-tower.mjs`
  static const DsLucideGlyph radioTower =
      DsLucideGlyph('radio-tower', <DsIconElement>[
    DsIconPathElement('M4.9 16.1C1 12.2 1 5.8 4.9 1.9'), // key: s0qx1y
    DsIconPathElement('M7.8 4.7a6.14 6.14 0 0 0-.8 7.5'), // key: 1idnkw
    DsIconCircleElement(12, 9, 2), // key: 1092wv
    DsIconPathElement('M16.2 4.8c2 2 2.26 5.11.8 7.47'), // key: ojru2q
    DsIconPathElement('M19.1 1.9a9.96 9.96 0 0 1 0 14.1'), // key: rhi7fg
    DsIconPathElement('M9.5 18h5'), // key: mfy3pd
    DsIconPathElement('m8 22 4-11 4 11'), // key: 25yftu
  ]);

  /// `radio.mjs`
  static const DsLucideGlyph radio =
      DsLucideGlyph('radio', <DsIconElement>[
    DsIconPathElement('M16.247 7.761a6 6 0 0 1 0 8.478'), // key: 1fwjs5
    DsIconPathElement('M19.075 4.933a10 10 0 0 1 0 14.134'), // key: ehdyv1
    DsIconPathElement('M4.925 19.067a10 10 0 0 1 0-14.134'), // key: 1q22gi
    DsIconPathElement('M7.753 16.239a6 6 0 0 1 0-8.478'), // key: r2q7qm
    DsIconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `radius.mjs`
  static const DsLucideGlyph radius =
      DsLucideGlyph('radius', <DsIconElement>[
    DsIconPathElement('M20.34 17.52a10 10 0 1 0-2.82 2.82'), // key: fydyku
    DsIconCircleElement(19, 19, 2), // key: 17f5cg
    DsIconPathElement('m13.41 13.41 4.18 4.18'), // key: 1gqbwc
    DsIconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `rainbow.mjs`
  static const DsLucideGlyph rainbow =
      DsLucideGlyph('rainbow', <DsIconElement>[
    DsIconPathElement('M22 17a10 10 0 0 0-20 0'), // key: ozegv
    DsIconPathElement('M6 17a6 6 0 0 1 12 0'), // key: 5giftw
    DsIconPathElement('M10 17a2 2 0 0 1 4 0'), // key: gnsikk
  ]);

  /// `rat.mjs`
  static const DsLucideGlyph rat =
      DsLucideGlyph('rat', <DsIconElement>[
    DsIconPathElement('M13 22H4a2 2 0 0 1 0-4h12'), // key: bt3f23
    DsIconPathElement('M13.236 18a3 3 0 0 0-2.2-5'), // key: 1tbvmo
    DsIconPathElement('M16 9h.01'), // key: 1bdo4e
    DsIconPathElement('M16.82 3.94a3 3 0 1 1 3.237 4.868l1.815 2.587a1.5 1.5 0 0 1-1.5 2.1l-2.872-.453a3 3 0 0 0-3.5 3'), // key: 9ch7kn
    DsIconPathElement('M17 4.988a3 3 0 1 0-5.2 2.052A7 7 0 0 0 4 14.015 4 4 0 0 0 8 18'), // key: 3s7e9i
  ]);

  /// `ratio.mjs`
  static const DsLucideGlyph ratio =
      DsLucideGlyph('ratio', <DsIconElement>[
    DsIconRectElement(6, 2, 12, 20, 2), // key: 1oxtiu
    DsIconRectElement(2, 6, 20, 12, 2), // key: 9lu3g6
  ]);

  /// `receipt-cent.mjs`
  static const DsLucideGlyph receiptCent =
      DsLucideGlyph('receipt-cent', <DsIconElement>[
    DsIconPathElement('M12 7v10'), // key: jspqdw
    DsIconPathElement('M14.828 14.829a4 4 0 0 1-5.656 0 4 4 0 0 1 0-5.657 4 4 0 0 1 5.656 0'), // key: qvqont
    DsIconPathElement('M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z'), // key: ycz6yz
  ]);

  /// `receipt-euro.mjs`
  static const DsLucideGlyph receiptEuro =
      DsLucideGlyph('receipt-euro', <DsIconElement>[
    DsIconPathElement('M15.828 14.829a4 4 0 0 1-5.656 0 4 4 0 0 1 0-5.657 4 4 0 0 1 5.656 0'), // key: 16zdw4
    DsIconPathElement('M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z'), // key: ycz6yz
    DsIconPathElement('M8 12h5'), // key: 1g6qi8
  ]);

  /// `receipt-indian-rupee.mjs`
  static const DsLucideGlyph receiptIndianRupee =
      DsLucideGlyph('receipt-indian-rupee', <DsIconElement>[
    DsIconPathElement('M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z'), // key: ycz6yz
    DsIconPathElement('M8 11h8'), // key: vwpz6n
    DsIconPathElement('M8 7h8'), // key: i86dvs
    DsIconPathElement('M9 7a4 4 0 0 1 0 8H8l3 2'), // key: 1xaco0
  ]);

  /// `receipt-japanese-yen.mjs`
  static const DsLucideGlyph receiptJapaneseYen =
      DsLucideGlyph('receipt-japanese-yen', <DsIconElement>[
    DsIconPathElement('m12 10 3-3'), // key: 1mc12w
    DsIconPathElement('M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z'), // key: ycz6yz
    DsIconPathElement('M9 11h6'), // key: 1fldmi
    DsIconPathElement('M9 15h6'), // key: cctwl0
    DsIconPathElement('m9 7 3 3v7'), // key: 1x0cue
  ]);

  /// `receipt-pound-sterling.mjs`
  static const DsLucideGlyph receiptPoundSterling =
      DsLucideGlyph('receipt-pound-sterling', <DsIconElement>[
    DsIconPathElement('M10 17V9.5a1 1 0 0 1 5 0'), // key: td22vl
    DsIconPathElement('M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z'), // key: ycz6yz
    DsIconPathElement('M8 13h5'), // key: 1k9z8w
    DsIconPathElement('M8 17h7'), // key: 8mjdqu
  ]);

  /// `receipt-russian-ruble.mjs`
  static const DsLucideGlyph receiptRussianRuble =
      DsLucideGlyph('receipt-russian-ruble', <DsIconElement>[
    DsIconPathElement('M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z'), // key: ycz6yz
    DsIconPathElement('M8 11h5a2 2 0 0 0 0-4h-3v10'), // key: agnv0r
    DsIconPathElement('M8 15h5'), // key: vxg57a
  ]);

  /// `receipt-swiss-franc.mjs`
  static const DsLucideGlyph receiptSwissFranc =
      DsLucideGlyph('receipt-swiss-franc', <DsIconElement>[
    DsIconPathElement('M10 11h4'), // key: 1i0mka
    DsIconPathElement('M10 17V7h5'), // key: k7jq18
    DsIconPathElement('M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z'), // key: ycz6yz
    DsIconPathElement('M8 15h5'), // key: vxg57a
  ]);

  /// `receipt-text.mjs`
  static const DsLucideGlyph receiptText =
      DsLucideGlyph('receipt-text', <DsIconElement>[
    DsIconPathElement('M13 16H8'), // key: wsln4y
    DsIconPathElement('M14 8H8'), // key: 1l3xfs
    DsIconPathElement('M16 12H8'), // key: 1fr5h0
    DsIconPathElement('M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z'), // key: ycz6yz
  ]);

  /// `receipt-turkish-lira.mjs`
  static const DsLucideGlyph receiptTurkishLira =
      DsLucideGlyph('receipt-turkish-lira', <DsIconElement>[
    DsIconPathElement('M10 7v10a5 5 0 0 0 5-5'), // key: 1blmz7
    DsIconPathElement('m14 8-6 3'), // key: 2tb98i
    DsIconPathElement('M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z'), // key: ycz6yz
  ]);

  /// `receipt.mjs`
  static const DsLucideGlyph receipt =
      DsLucideGlyph('receipt', <DsIconElement>[
    DsIconPathElement('M12 17V7'), // key: pyj7ub
    DsIconPathElement('M16 8h-6a2 2 0 0 0 0 4h4a2 2 0 0 1 0 4H8'), // key: 1elt7d
    DsIconPathElement('M4 3a1 1 0 0 1 1-1 1.3 1.3 0 0 1 .7.2l.933.6a1.3 1.3 0 0 0 1.4 0l.934-.6a1.3 1.3 0 0 1 1.4 0l.933.6a1.3 1.3 0 0 0 1.4 0l.933-.6a1.3 1.3 0 0 1 1.4 0l.934.6a1.3 1.3 0 0 0 1.4 0l.933-.6A1.3 1.3 0 0 1 19 2a1 1 0 0 1 1 1v18a1 1 0 0 1-1 1 1.3 1.3 0 0 1-.7-.2l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.934.6a1.3 1.3 0 0 1-1.4 0l-.933-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-1.4 0l-.934-.6a1.3 1.3 0 0 0-1.4 0l-.933.6a1.3 1.3 0 0 1-.7.2 1 1 0 0 1-1-1z'), // key: ycz6yz
  ]);

  /// `rectangle-circle.mjs`
  static const DsLucideGlyph rectangleCircle =
      DsLucideGlyph('rectangle-circle', <DsIconElement>[
    DsIconPathElement('M14 4v16H3a1 1 0 0 1-1-1V5a1 1 0 0 1 1-1z'), // key: 1m5n7q
    DsIconCircleElement(14, 12, 8), // key: 1pag6k
  ]);

  /// `rectangle-ellipsis.mjs`
  static const DsLucideGlyph rectangleEllipsis =
      DsLucideGlyph('rectangle-ellipsis', <DsIconElement>[
    DsIconRectElement(2, 6, 20, 12, 2), // key: 9lu3g6
    DsIconPathElement('M12 12h.01'), // key: 1mp3jc
    DsIconPathElement('M17 12h.01'), // key: 1m0b6t
    DsIconPathElement('M7 12h.01'), // key: eqddd0
  ]);

  /// `rectangle-goggles.mjs`
  static const DsLucideGlyph rectangleGoggles =
      DsLucideGlyph('rectangle-goggles', <DsIconElement>[
    DsIconPathElement('M20 6a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-4a2 2 0 0 1-1.6-.8l-1.6-2.13a1 1 0 0 0-1.6 0L9.6 17.2A2 2 0 0 1 8 18H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2z'), // key: d5y1f
  ]);

  /// `rectangle-horizontal.mjs`
  static const DsLucideGlyph rectangleHorizontal =
      DsLucideGlyph('rectangle-horizontal', <DsIconElement>[
    DsIconRectElement(2, 6, 20, 12, 2), // key: 9lu3g6
  ]);

  /// `rectangle-vertical.mjs`
  static const DsLucideGlyph rectangleVertical =
      DsLucideGlyph('rectangle-vertical', <DsIconElement>[
    DsIconRectElement(6, 2, 12, 20, 2), // key: 1oxtiu
  ]);

  /// `recycle.mjs`
  static const DsLucideGlyph recycle =
      DsLucideGlyph('recycle', <DsIconElement>[
    DsIconPathElement('M7 19H4.815a1.83 1.83 0 0 1-1.57-.881 1.785 1.785 0 0 1-.004-1.784L7.196 9.5'), // key: x6z5xu
    DsIconPathElement('M11 19h8.203a1.83 1.83 0 0 0 1.556-.89 1.784 1.784 0 0 0 0-1.775l-1.226-2.12'), // key: 1x4zh5
    DsIconPathElement('m14 16-3 3 3 3'), // key: f6jyew
    DsIconPathElement('M8.293 13.596 7.196 9.5 3.1 10.598'), // key: wf1obh
    DsIconPathElement('m9.344 5.811 1.093-1.892A1.83 1.83 0 0 1 11.985 3a1.784 1.784 0 0 1 1.546.888l3.943 6.843'), // key: 9tzpgr
    DsIconPathElement('m13.378 9.633 4.096 1.098 1.097-4.096'), // key: 1oe83g
  ]);

  /// `redo-2.mjs`
  static const DsLucideGlyph redo2 =
      DsLucideGlyph('redo-2', <DsIconElement>[
    DsIconPathElement('m15 14 5-5-5-5'), // key: 12vg1m
    DsIconPathElement('M20 9H9.5A5.5 5.5 0 0 0 4 14.5A5.5 5.5 0 0 0 9.5 20H13'), // key: 6uklza
  ]);

  /// `redo-dot.mjs`
  static const DsLucideGlyph redoDot =
      DsLucideGlyph('redo-dot', <DsIconElement>[
    DsIconCircleElement(12, 17, 1), // key: 1ixnty
    DsIconPathElement('M21 7v6h-6'), // key: 3ptur4
    DsIconPathElement('M3 17a9 9 0 0 1 9-9 9 9 0 0 1 6 2.3l3 2.7'), // key: 1kgawr
  ]);

  /// `redo.mjs`
  static const DsLucideGlyph redo =
      DsLucideGlyph('redo', <DsIconElement>[
    DsIconPathElement('M21 7v6h-6'), // key: 3ptur4
    DsIconPathElement('M3 17a9 9 0 0 1 9-9 9 9 0 0 1 6 2.3l3 2.7'), // key: 1kgawr
  ]);

  /// `refresh-ccw-dot.mjs`
  static const DsLucideGlyph refreshCcwDot =
      DsLucideGlyph('refresh-ccw-dot', <DsIconElement>[
    DsIconPathElement('M21 12a9 9 0 0 0-9-9 9.75 9.75 0 0 0-6.74 2.74L3 8'), // key: 14sxne
    DsIconPathElement('M3 3v5h5'), // key: 1xhq8a
    DsIconPathElement('M3 12a9 9 0 0 0 9 9 9.75 9.75 0 0 0 6.74-2.74L21 16'), // key: 1hlbsb
    DsIconPathElement('M16 16h5v5'), // key: ccwih5
    DsIconCircleElement(12, 12, 1), // key: 41hilf
  ]);

  /// `refresh-ccw.mjs`
  static const DsLucideGlyph refreshCcw =
      DsLucideGlyph('refresh-ccw', <DsIconElement>[
    DsIconPathElement('M21 12a9 9 0 0 0-9-9 9.75 9.75 0 0 0-6.74 2.74L3 8'), // key: 14sxne
    DsIconPathElement('M3 3v5h5'), // key: 1xhq8a
    DsIconPathElement('M3 12a9 9 0 0 0 9 9 9.75 9.75 0 0 0 6.74-2.74L21 16'), // key: 1hlbsb
    DsIconPathElement('M16 16h5v5'), // key: ccwih5
  ]);

  /// `refresh-cw-off.mjs`
  static const DsLucideGlyph refreshCwOff =
      DsLucideGlyph('refresh-cw-off', <DsIconElement>[
    DsIconPathElement('M21 8L18.74 5.74A9.75 9.75 0 0 0 12 3C11 3 10.03 3.16 9.13 3.47'), // key: 1krf6h
    DsIconPathElement('M8 16H3v5'), // key: 1cv678
    DsIconPathElement('M3 12C3 9.51 4 7.26 5.64 5.64'), // key: ruvoct
    DsIconPathElement('m3 16 2.26 2.26A9.75 9.75 0 0 0 12 21c2.49 0 4.74-1 6.36-2.64'), // key: 19q130
    DsIconPathElement('M21 12c0 1-.16 1.97-.47 2.87'), // key: 4w8emr
    DsIconPathElement('M21 3v5h-5'), // key: 1q7to0
    DsIconPathElement('M22 22 2 2'), // key: 1r8tn9
  ]);

  /// `refresh-cw.mjs`
  static const DsLucideGlyph refreshCw =
      DsLucideGlyph('refresh-cw', <DsIconElement>[
    DsIconPathElement('M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8'), // key: v9h5vc
    DsIconPathElement('M21 3v5h-5'), // key: 1q7to0
    DsIconPathElement('M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16'), // key: 3uifl3
    DsIconPathElement('M8 16H3v5'), // key: 1cv678
  ]);

  /// `refrigerator.mjs`
  static const DsLucideGlyph refrigerator =
      DsLucideGlyph('refrigerator', <DsIconElement>[
    DsIconPathElement('M5 6a4 4 0 0 1 4-4h6a4 4 0 0 1 4 4v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6Z'), // key: fpq118
    DsIconPathElement('M5 10h14'), // key: elsbfy
    DsIconPathElement('M15 7v6'), // key: 1nx30x
  ]);

  /// `regex.mjs`
  static const DsLucideGlyph regex =
      DsLucideGlyph('regex', <DsIconElement>[
    DsIconPathElement('M17 3v10'), // key: 15fgeh
    DsIconPathElement('m12.67 5.5 8.66 5'), // key: 1gpheq
    DsIconPathElement('m12.67 10.5 8.66-5'), // key: 1dkfa6
    DsIconPathElement('M9 17a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v2a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2v-2z'), // key: swwfx4
  ]);

  /// `remove-formatting.mjs`
  static const DsLucideGlyph removeFormatting =
      DsLucideGlyph('remove-formatting', <DsIconElement>[
    DsIconPathElement('M4 7V4h16v3'), // key: 9msm58
    DsIconPathElement('M5 20h6'), // key: 1h6pxn
    DsIconPathElement('M13 4 8 20'), // key: kqq6aj
    DsIconPathElement('m15 15 5 5'), // key: me55sn
    DsIconPathElement('m20 15-5 5'), // key: 11p7ol
  ]);

  /// `repeat-1.mjs`
  static const DsLucideGlyph repeat1 =
      DsLucideGlyph('repeat-1', <DsIconElement>[
    DsIconPathElement('m17 2 4 4-4 4'), // key: nntrym
    DsIconPathElement('M3 11v-1a4 4 0 0 1 4-4h14'), // key: 84bu3i
    DsIconPathElement('m7 22-4-4 4-4'), // key: 1wqhfi
    DsIconPathElement('M21 13v1a4 4 0 0 1-4 4H3'), // key: 1rx37r
    DsIconPathElement('M11 10h1v4'), // key: 70cz1p
  ]);

  /// `repeat-2.mjs`
  static const DsLucideGlyph repeat2 =
      DsLucideGlyph('repeat-2', <DsIconElement>[
    DsIconPathElement('m2 9 3-3 3 3'), // key: 1ltn5i
    DsIconPathElement('M13 18H7a2 2 0 0 1-2-2V6'), // key: 1r6tfw
    DsIconPathElement('m22 15-3 3-3-3'), // key: 4rnwn2
    DsIconPathElement('M11 6h6a2 2 0 0 1 2 2v10'), // key: 2f72bc
  ]);

  /// `repeat-off.mjs`
  static const DsLucideGlyph repeatOff =
      DsLucideGlyph('repeat-off', <DsIconElement>[
    DsIconPathElement('M11.656 6H21l-4-4'), // key: w9pozh
    DsIconPathElement('M17.898 17.898A4 4 0 0 1 17 18H3l4-4'), // key: 156mfe
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M21 13v1a4 4 0 0 1-.171 1.159'), // key: 2p1713
    DsIconPathElement('m21 6-4 4'), // key: p7opkf
    DsIconPathElement('M3 11v-1a4 4 0 0 1 3.102-3.898'), // key: 8cius9
    DsIconPathElement('m7 22-4-4'), // key: 1kl3a3
  ]);

  /// `repeat.mjs`
  static const DsLucideGlyph repeat =
      DsLucideGlyph('repeat', <DsIconElement>[
    DsIconPathElement('m17 2 4 4-4 4'), // key: nntrym
    DsIconPathElement('M3 11v-1a4 4 0 0 1 4-4h14'), // key: 84bu3i
    DsIconPathElement('m7 22-4-4 4-4'), // key: 1wqhfi
    DsIconPathElement('M21 13v1a4 4 0 0 1-4 4H3'), // key: 1rx37r
  ]);

  /// `replace-all.mjs`
  static const DsLucideGlyph replaceAll =
      DsLucideGlyph('replace-all', <DsIconElement>[
    DsIconPathElement('M14 14a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1'), // key: zg1ipl
    DsIconPathElement('M14 4a1 1 0 0 1 1-1'), // key: dhj8ez
    DsIconPathElement('M15 10a1 1 0 0 1-1-1'), // key: 1mnyi5
    DsIconPathElement('M19 14a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1'), // key: txt6k4
    DsIconPathElement('M21 4a1 1 0 0 0-1-1'), // key: sfs9ap
    DsIconPathElement('M21 9a1 1 0 0 1-1 1'), // key: mp6qeo
    DsIconPathElement('m3 7 3 3 3-3'), // key: x25e72
    DsIconPathElement('M6 10V5a2 2 0 0 1 2-2h2'), // key: 15xut4
    DsIconRectElement(3, 14, 7, 7, 1), // key: 1bkyp8
  ]);

  /// `replace.mjs`
  static const DsLucideGlyph replace =
      DsLucideGlyph('replace', <DsIconElement>[
    DsIconPathElement('M14 4a1 1 0 0 1 1-1'), // key: dhj8ez
    DsIconPathElement('M15 10a1 1 0 0 1-1-1'), // key: 1mnyi5
    DsIconPathElement('M21 4a1 1 0 0 0-1-1'), // key: sfs9ap
    DsIconPathElement('M21 9a1 1 0 0 1-1 1'), // key: mp6qeo
    DsIconPathElement('m3 7 3 3 3-3'), // key: x25e72
    DsIconPathElement('M6 10V5a2 2 0 0 1 2-2h2'), // key: 15xut4
    DsIconRectElement(3, 14, 7, 7, 1), // key: 1bkyp8
  ]);

  /// `reply-all.mjs`
  static const DsLucideGlyph replyAll =
      DsLucideGlyph('reply-all', <DsIconElement>[
    DsIconPathElement('m12 17-5-5 5-5'), // key: 1s3y5u
    DsIconPathElement('M22 18v-2a4 4 0 0 0-4-4H7'), // key: 1fcyog
    DsIconPathElement('m7 17-5-5 5-5'), // key: 1ed8i2
  ]);

  /// `reply.mjs`
  static const DsLucideGlyph reply =
      DsLucideGlyph('reply', <DsIconElement>[
    DsIconPathElement('M20 18v-2a4 4 0 0 0-4-4H4'), // key: 5vmcpk
    DsIconPathElement('m9 17-5-5 5-5'), // key: nvlc11
  ]);

  /// `rewind.mjs`
  static const DsLucideGlyph rewind =
      DsLucideGlyph('rewind', <DsIconElement>[
    DsIconPathElement('M12 6a2 2 0 0 0-3.414-1.414l-6 6a2 2 0 0 0 0 2.828l6 6A2 2 0 0 0 12 18z'), // key: 2a1g8i
    DsIconPathElement('M22 6a2 2 0 0 0-3.414-1.414l-6 6a2 2 0 0 0 0 2.828l6 6A2 2 0 0 0 22 18z'), // key: rg3s36
  ]);

  /// `ribbon.mjs`
  static const DsLucideGlyph ribbon =
      DsLucideGlyph('ribbon', <DsIconElement>[
    DsIconPathElement('M12 11.22C11 9.997 10 9 10 8a2 2 0 0 1 4 0c0 1-.998 2.002-2.01 3.22'), // key: 1rnhq3
    DsIconPathElement('m12 18 2.57-3.5'), // key: 116vt7
    DsIconPathElement('M6.243 9.016a7 7 0 0 1 11.507-.009'), // key: 10dq0b
    DsIconPathElement('M9.35 14.53 12 11.22'), // key: tdsyp2
    DsIconPathElement('M9.35 14.53C7.728 12.246 6 10.221 6 7a6 5 0 0 1 12 0c-.005 3.22-1.778 5.235-3.43 7.5l3.557 4.527a1 1 0 0 1-.203 1.43l-1.894 1.36a1 1 0 0 1-1.384-.215L12 18l-2.679 3.593a1 1 0 0 1-1.39.213l-1.865-1.353a1 1 0 0 1-.203-1.422z'), // key: nmifey
  ]);

  /// `road.mjs`
  static const DsLucideGlyph road =
      DsLucideGlyph('road', <DsIconElement>[
    DsIconPathElement('M12 17v4'), // key: 1riwvh
    DsIconPathElement('M12 5V3'), // key: vd5es
    DsIconPathElement('M12 9v3'), // key: qyerrc
    DsIconPathElement('M2.077 18.449A2 2 0 0 0 4 21h16a2 2 0 0 0 1.924-2.55l-4-14A2 2 0 0 0 16 3H8a2 2 0 0 0-1.924 1.45z'), // key: 1cuxct
  ]);

  /// `rocket.mjs`
  static const DsLucideGlyph rocket =
      DsLucideGlyph('rocket', <DsIconElement>[
    DsIconPathElement('M12 15v5s3.03-.55 4-2c1.08-1.62 0-5 0-5'), // key: qeys4
    DsIconPathElement('M4.5 16.5c-1.5 1.26-2 5-2 5s3.74-.5 5-2c.71-.84.7-2.13-.09-2.91a2.18 2.18 0 0 0-2.91-.09'), // key: u4xsad
    DsIconPathElement('M9 12a22 22 0 0 1 2-3.95A12.88 12.88 0 0 1 22 2c0 2.72-.78 7.5-6 11a22.4 22.4 0 0 1-4 2z'), // key: 676m9
    DsIconPathElement('M9 12H4s.55-3.03 2-4c1.62-1.08 5 .05 5 .05'), // key: 92ym6u
  ]);

  /// `rocking-chair.mjs`
  static const DsLucideGlyph rockingChair =
      DsLucideGlyph('rocking-chair', <DsIconElement>[
    DsIconPathElement('m15 13 3.708 7.416'), // key: 1edxn9
    DsIconPathElement('M3 19a15 15 0 0 0 18 0'), // key: d0d1c4
    DsIconPathElement('m3 2 3.21 9.633A2 2 0 0 0 8.109 13H18'), // key: tpa4et
    DsIconPathElement('m9 13-3.708 7.416'), // key: 1oplxx
  ]);

  /// `roller-coaster.mjs`
  static const DsLucideGlyph rollerCoaster =
      DsLucideGlyph('roller-coaster', <DsIconElement>[
    DsIconPathElement('M6 19V5'), // key: 1r845m
    DsIconPathElement('M10 19V6.8'), // key: 9j2tfs
    DsIconPathElement('M14 19v-7.8'), // key: 10s8qv
    DsIconPathElement('M18 5v4'), // key: 1tajlv
    DsIconPathElement('M18 19v-6'), // key: ielfq3
    DsIconPathElement('M22 19V9'), // key: 158nzp
    DsIconPathElement('M2 19V9a4 4 0 0 1 4-4c2 0 4 1.33 6 4s4 4 6 4a4 4 0 1 0-3-6.65'), // key: 1930oh
  ]);

  /// `rose.mjs`
  static const DsLucideGlyph rose =
      DsLucideGlyph('rose', <DsIconElement>[
    DsIconPathElement('M17 10h-1a4 4 0 1 1 4-4v.534'), // key: 7qf5zm
    DsIconPathElement('M17 6h1a4 4 0 0 1 1.42 7.74l-2.29.87a6 6 0 0 1-5.339-10.68l2.069-1.31'), // key: 1et29u
    DsIconPathElement('M4.5 17c2.8-.5 4.4 0 5.5.8s1.8 2.2 2.3 3.7c-2 .4-3.5.4-4.8-.3-1.2-.6-2.3-1.9-3-4.2'), // key: kiv2lz
    DsIconPathElement('M9.77 12C4 15 2 22 2 22'), // key: h28rw0
    DsIconCircleElement(17, 8, 2), // key: 1330xn
  ]);

  /// `rotate-3d.mjs`
  static const DsLucideGlyph rotate3d =
      DsLucideGlyph('rotate-3d', <DsIconElement>[
    DsIconPathElement('m15.194 13.707 3.814 1.86-1.86 3.814'), // key: 16shm9
    DsIconPathElement('M16.47214 7.52786 A 5 10 0 1 0 13 21.79796'), // key: 1245p8
    DsIconPathElement('M21.79796 11 A 10 5 0 1 0 19 15.57071'), // key: 1i40ks
  ]);

  /// `rotate-ccw-clock.mjs`
  static const DsLucideGlyph rotateCcwClock =
      DsLucideGlyph('rotate-ccw-clock', <DsIconElement>[
    DsIconPathElement('M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8'), // key: 1357e3
    DsIconPathElement('M3 3v5h5'), // key: 1xhq8a
    DsIconPathElement('M12 7v5l4 2'), // key: 1fdv2h
  ]);

  /// `rotate-ccw-key.mjs`
  static const DsLucideGlyph rotateCcwKey =
      DsLucideGlyph('rotate-ccw-key', <DsIconElement>[
    DsIconPathElement('M12 7v6'), // key: lw1j43
    DsIconPathElement('M12 9h2'), // key: 1lpap9
    DsIconPathElement('M3 12a9 9 0 1 0 9-9 9.74 9.74 0 0 0-6.74 2.74L3 8'), // key: g2jlw
    DsIconPathElement('M3 3v5h5'), // key: 1xhq8a
    DsIconCircleElement(12, 15, 2), // key: 1vpstw
  ]);

  /// `rotate-ccw-square.mjs`
  static const DsLucideGlyph rotateCcwSquare =
      DsLucideGlyph('rotate-ccw-square', <DsIconElement>[
    DsIconPathElement('M20 9V7a2 2 0 0 0-2-2h-6'), // key: 19z8uc
    DsIconPathElement('m15 2-3 3 3 3'), // key: 177bxs
    DsIconPathElement('M20 13v5a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2h2'), // key: d36hnl
  ]);

  /// `rotate-ccw.mjs`
  static const DsLucideGlyph rotateCcw =
      DsLucideGlyph('rotate-ccw', <DsIconElement>[
    DsIconPathElement('M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8'), // key: 1357e3
    DsIconPathElement('M3 3v5h5'), // key: 1xhq8a
  ]);

  /// `rotate-cw-fading-clock.mjs`
  static const DsLucideGlyph rotateCwFadingClock =
      DsLucideGlyph('rotate-cw-fading-clock', <DsIconElement>[
    DsIconPathElement('M12 3a9.75 9.75 0 0 1 6.74 2.74'), // key: 1k3kxf
    DsIconPathElement('M18.74 5.74 21 8'), // key: 1eb40o
    DsIconPathElement('M21 8V3'), // key: 1et280
    DsIconPathElement('M7.5 19.794c-6-3.464-6-12.124 0-15.588'), // key: 19r0lp
    DsIconPathElement('M7.5 4.206A9 9 0 0 1 12 3'), // key: s8r11
    DsIconPathElement('M12 7v5l4 2'), // key: 1fdv2h
    DsIconPathElement('M14 20.775A9 9 0 0 1 12 21'), // key: 184rgu
    DsIconPathElement('M19 17.656a9 9 0 0 1-1.5 1.456'), // key: 7qgp6l
    DsIconPathElement('M21 12a9 9 0 0 1-.228 2'), // key: 1h378y
    DsIconPathElement('M21 8h-5'), // key: k0yzmk
  ]);

  /// `rotate-cw-square.mjs`
  static const DsLucideGlyph rotateCwSquare =
      DsLucideGlyph('rotate-cw-square', <DsIconElement>[
    DsIconPathElement('M12 5H6a2 2 0 0 0-2 2v3'), // key: l96uqu
    DsIconPathElement('m9 8 3-3-3-3'), // key: 1gzgc3
    DsIconPathElement('M4 14v4a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2'), // key: 1w2k5h
  ]);

  /// `rotate-cw.mjs`
  static const DsLucideGlyph rotateCw =
      DsLucideGlyph('rotate-cw', <DsIconElement>[
    DsIconPathElement('M21 12a9 9 0 1 1-9-9c2.52 0 4.93 1 6.74 2.74L21 8'), // key: 1p45f6
    DsIconPathElement('M21 3v5h-5'), // key: 1q7to0
  ]);

  /// `route-off.mjs`
  static const DsLucideGlyph routeOff =
      DsLucideGlyph('route-off', <DsIconElement>[
    DsIconCircleElement(6, 19, 3), // key: 1kj8tv
    DsIconPathElement('M9 19h8.5c.4 0 .9-.1 1.3-.2'), // key: 1effex
    DsIconPathElement('M5.2 5.2A3.5 3.53 0 0 0 6.5 12H12'), // key: k9y2ds
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M21 15.3a3.5 3.5 0 0 0-3.3-3.3'), // key: 11nlu2
    DsIconPathElement('M15 5h-4.3'), // key: 6537je
    DsIconCircleElement(18, 5, 3), // key: gq8acd
  ]);

  /// `route.mjs`
  static const DsLucideGlyph route =
      DsLucideGlyph('route', <DsIconElement>[
    DsIconCircleElement(6, 19, 3), // key: 1kj8tv
    DsIconPathElement('M9 19h8.5a3.5 3.5 0 0 0 0-7h-11a3.5 3.5 0 0 1 0-7H15'), // key: 1d8sl
    DsIconCircleElement(18, 5, 3), // key: gq8acd
  ]);

  /// `router.mjs`
  static const DsLucideGlyph router =
      DsLucideGlyph('router', <DsIconElement>[
    DsIconRectElement(2, 14, 20, 8, 2), // key: w68u3i
    DsIconPathElement('M6.01 18H6'), // key: 19vcac
    DsIconPathElement('M10.01 18H10'), // key: uamcmx
    DsIconPathElement('M15 10v4'), // key: qjz1xs
    DsIconPathElement('M17.84 7.17a4 4 0 0 0-5.66 0'), // key: 1rif40
    DsIconPathElement('M20.66 4.34a8 8 0 0 0-11.31 0'), // key: 6a5xfq
  ]);

  /// `rows-2.mjs`
  static const DsLucideGlyph rows2 =
      DsLucideGlyph('rows-2', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M3 12h18'), // key: 1i2n21
  ]);

  /// `rows-3.mjs`
  static const DsLucideGlyph rows3 =
      DsLucideGlyph('rows-3', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M21 9H3'), // key: 1338ky
    DsIconPathElement('M21 15H3'), // key: 9uk58r
  ]);

  /// `rows-4.mjs`
  static const DsLucideGlyph rows4 =
      DsLucideGlyph('rows-4', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M21 7.5H3'), // key: 1hm9pq
    DsIconPathElement('M21 12H3'), // key: 2avoz0
    DsIconPathElement('M21 16.5H3'), // key: n7jzkj
  ]);

  /// `rss.mjs`
  static const DsLucideGlyph rss =
      DsLucideGlyph('rss', <DsIconElement>[
    DsIconPathElement('M4 11a9 9 0 0 1 9 9'), // key: pv89mb
    DsIconPathElement('M4 4a16 16 0 0 1 16 16'), // key: k0647b
    DsIconCircleElement(5, 19, 1), // key: bfqh0e
  ]);

  /// `ruler-dimension-line.mjs`
  static const DsLucideGlyph rulerDimensionLine =
      DsLucideGlyph('ruler-dimension-line', <DsIconElement>[
    DsIconPathElement('M10 15v-3'), // key: 1pjskw
    DsIconPathElement('M14 15v-3'), // key: 1o1mqj
    DsIconPathElement('M18 15v-3'), // key: cws6he
    DsIconPathElement('M2 8V4'), // key: 3jv1jz
    DsIconPathElement('M22 6H2'), // key: 1iqbfk
    DsIconPathElement('M22 8V4'), // key: 16f4ou
    DsIconPathElement('M6 15v-3'), // key: 1ij1qe
    DsIconRectElement(2, 12, 20, 8, 2), // key: 1tqiko
  ]);

  /// `ruler.mjs`
  static const DsLucideGlyph ruler =
      DsLucideGlyph('ruler', <DsIconElement>[
    DsIconPathElement('M21.3 15.3a2.4 2.4 0 0 1 0 3.4l-2.6 2.6a2.4 2.4 0 0 1-3.4 0L2.7 8.7a2.41 2.41 0 0 1 0-3.4l2.6-2.6a2.41 2.41 0 0 1 3.4 0Z'), // key: icamh8
    DsIconPathElement('m14.5 12.5 2-2'), // key: inckbg
    DsIconPathElement('m11.5 9.5 2-2'), // key: fmmyf7
    DsIconPathElement('m8.5 6.5 2-2'), // key: vc6u1g
    DsIconPathElement('m17.5 15.5 2-2'), // key: wo5hmg
  ]);

  /// `russian-ruble.mjs`
  static const DsLucideGlyph russianRuble =
      DsLucideGlyph('russian-ruble', <DsIconElement>[
    DsIconPathElement('M6 11h8a4 4 0 0 0 0-8H9v18'), // key: 18ai8t
    DsIconPathElement('M6 15h8'), // key: 1y8f6l
  ]);

  /// `sailboat.mjs`
  static const DsLucideGlyph sailboat =
      DsLucideGlyph('sailboat', <DsIconElement>[
    DsIconPathElement('M10 2v15'), // key: 1qf71f
    DsIconPathElement('M7 22a4 4 0 0 1-4-4 1 1 0 0 1 1-1h16a1 1 0 0 1 1 1 4 4 0 0 1-4 4z'), // key: 1pxcvx
    DsIconPathElement('M9.159 2.46a1 1 0 0 1 1.521-.193l9.977 8.98A1 1 0 0 1 20 13H4a1 1 0 0 1-.824-1.567z'), // key: 5oog16
  ]);

  /// `salad.mjs`
  static const DsLucideGlyph salad =
      DsLucideGlyph('salad', <DsIconElement>[
    DsIconPathElement('M7 21h10'), // key: 1b0cd5
    DsIconPathElement('M12 21a9 9 0 0 0 9-9H3a9 9 0 0 0 9 9Z'), // key: 4rw317
    DsIconPathElement('M11.38 12a2.4 2.4 0 0 1-.4-4.77 2.4 2.4 0 0 1 3.2-2.77 2.4 2.4 0 0 1 3.47-.63 2.4 2.4 0 0 1 3.37 3.37 2.4 2.4 0 0 1-1.1 3.7 2.51 2.51 0 0 1 .03 1.1'), // key: 10xrj0
    DsIconPathElement('m13 12 4-4'), // key: 1hckqy
    DsIconPathElement('M10.9 7.25A3.99 3.99 0 0 0 4 10c0 .73.2 1.41.54 2'), // key: 1p4srx
  ]);

  /// `sandwich.mjs`
  static const DsLucideGlyph sandwich =
      DsLucideGlyph('sandwich', <DsIconElement>[
    DsIconPathElement('m2.37 11.223 8.372-6.777a2 2 0 0 1 2.516 0l8.371 6.777'), // key: f1wd0e
    DsIconPathElement('M21 15a1 1 0 0 1 1 1v2a1 1 0 0 1-1 1h-5.25'), // key: 1pfu07
    DsIconPathElement('M3 15a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1h9'), // key: 1oq9qw
    DsIconPathElement('m6.67 15 6.13 4.6a2 2 0 0 0 2.8-.4l3.15-4.2'), // key: 1fnwu5
    DsIconRectElement(2, 11, 20, 4, 1), // key: itshg
  ]);

  /// `satellite-dish.mjs`
  static const DsLucideGlyph satelliteDish =
      DsLucideGlyph('satellite-dish', <DsIconElement>[
    DsIconPathElement('M4 10a7.31 7.31 0 0 0 10 10Z'), // key: 1fzpp3
    DsIconPathElement('m9 15 3-3'), // key: 88sc13
    DsIconPathElement('M17 13a6 6 0 0 0-6-6'), // key: 15cc6u
    DsIconPathElement('M21 13A10 10 0 0 0 11 3'), // key: 11nf8s
  ]);

  /// `satellite.mjs`
  static const DsLucideGlyph satellite =
      DsLucideGlyph('satellite', <DsIconElement>[
    DsIconPathElement('m13.5 6.5-3.148-3.148a1.205 1.205 0 0 0-1.704 0L6.352 5.648a1.205 1.205 0 0 0 0 1.704L9.5 10.5'), // key: dzhfyz
    DsIconPathElement('M16.5 7.5 19 5'), // key: 1ltcjm
    DsIconPathElement('m17.5 10.5 3.148 3.148a1.205 1.205 0 0 1 0 1.704l-2.296 2.296a1.205 1.205 0 0 1-1.704 0L13.5 14.5'), // key: nfoymv
    DsIconPathElement('M9 21a6 6 0 0 0-6-6'), // key: 1iajcf
    DsIconPathElement('M9.352 10.648a1.205 1.205 0 0 0 0 1.704l2.296 2.296a1.205 1.205 0 0 0 1.704 0l4.296-4.296a1.205 1.205 0 0 0 0-1.704l-2.296-2.296a1.205 1.205 0 0 0-1.704 0z'), // key: nv9zqy
  ]);

  /// `saudi-riyal.mjs`
  static const DsLucideGlyph saudiRiyal =
      DsLucideGlyph('saudi-riyal', <DsIconElement>[
    DsIconPathElement('m20 19.5-5.5 1.2'), // key: 1aenhr
    DsIconPathElement('M14.5 4v11.22a1 1 0 0 0 1.242.97L20 15.2'), // key: 2rtezt
    DsIconPathElement('m2.978 19.351 5.549-1.363A2 2 0 0 0 10 16V2'), // key: 1kbm92
    DsIconPathElement('M20 10 4 13.5'), // key: 8nums9
  ]);

  /// `save-all.mjs`
  static const DsLucideGlyph saveAll =
      DsLucideGlyph('save-all', <DsIconElement>[
    DsIconPathElement('M10 2v3a1 1 0 0 0 1 1h5'), // key: 1xspal
    DsIconPathElement('M18 18v-6a1 1 0 0 0-1-1h-6a1 1 0 0 0-1 1v6'), // key: 1ra60u
    DsIconPathElement('M18 22H4a2 2 0 0 1-2-2V6'), // key: pblm9e
    DsIconPathElement('M8 18a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9.172a2 2 0 0 1 1.414.586l2.828 2.828A2 2 0 0 1 22 6.828V16a2 2 0 0 1-2.01 2z'), // key: 1yve0x
  ]);

  /// `save-check.mjs`
  static const DsLucideGlyph saveCheck =
      DsLucideGlyph('save-check', <DsIconElement>[
    DsIconPathElement('M12.5 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h10.2a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4v4.35'), // key: 6jbevg
    DsIconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
    DsIconPathElement('M17 15.13V14a1 1 0 0 0-1-1H8a1 1 0 0 0-1 1v7'), // key: 1bzeol
    DsIconPathElement('M7 3v4a1 1 0 0 0 1 1h7'), // key: t51u73
  ]);

  /// `save-off.mjs`
  static const DsLucideGlyph saveOff =
      DsLucideGlyph('save-off', <DsIconElement>[
    DsIconPathElement('M13 13H8a1 1 0 0 0-1 1v7'), // key: h8g396
    DsIconPathElement('M14 8h1'), // key: 1lfen6
    DsIconPathElement('M17 21v-4'), // key: 1yknxs
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M20.41 20.41A2 2 0 0 1 19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 .59-1.41'), // key: 1t4vdl
    DsIconPathElement('M29.5 11.5s5 5 4 5'), // key: zzn4i6
    DsIconPathElement('M9 3h6.2a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4V15'), // key: 24cby9
  ]);

  /// `save-pen.mjs`
  static const DsLucideGlyph savePen =
      DsLucideGlyph('save-pen', <DsIconElement>[
    DsIconPathElement('M13.33 13H8a1 1 0 00-1 1v7'), // key: 60fs50
    DsIconPathElement('M14.363 17.634a2 2 0 00-.506.854l-.837 2.87a.5.5 0 00.62.62l2.87-.837a2 2 0 00.854-.506l4.013-4.009a1 1 0 10-3.004-3.004z'), // key: dpj1he
    DsIconPathElement('M7 3v4a1 1 0 001 1h7'), // key: vkun1b
    DsIconPathElement('M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h10.2a2 2 0 011.4.6l3.8 3.8a2 2 0 01.6 1.4v.3'), // key: 1oj3yb
  ]);

  /// `save-plus.mjs`
  static const DsLucideGlyph savePlus =
      DsLucideGlyph('save-plus', <DsIconElement>[
    DsIconPathElement('M12.5 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h10.2a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4V12'), // key: bhibzn
    DsIconPathElement('M16 13H8a1 1 0 0 0-1 1v7'), // key: 164ge7
    DsIconPathElement('M19 22v-6'), // key: qhmiwi
    DsIconPathElement('M22 19h-6'), // key: vcuq98
    DsIconPathElement('M7 3v4a1 1 0 0 0 1 1h7'), // key: t51u73
  ]);

  /// `save.mjs`
  static const DsLucideGlyph save =
      DsLucideGlyph('save', <DsIconElement>[
    DsIconPathElement('M15.2 3a2 2 0 0 1 1.4.6l3.8 3.8a2 2 0 0 1 .6 1.4V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2z'), // key: 1c8476
    DsIconPathElement('M17 21v-7a1 1 0 0 0-1-1H8a1 1 0 0 0-1 1v7'), // key: 1ydtos
    DsIconPathElement('M7 3v4a1 1 0 0 0 1 1h7'), // key: t51u73
  ]);

  /// `scale-3d.mjs`
  static const DsLucideGlyph scale3d =
      DsLucideGlyph('scale-3d', <DsIconElement>[
    DsIconPathElement('M5 7v11a1 1 0 0 0 1 1h11'), // key: 13dt1j
    DsIconPathElement('M5.293 18.707 11 13'), // key: ezgbsx
    DsIconCircleElement(19, 19, 2), // key: 17f5cg
    DsIconCircleElement(5, 5, 2), // key: 1gwv83
  ]);

  /// `scale.mjs`
  static const DsLucideGlyph scale =
      DsLucideGlyph('scale', <DsIconElement>[
    DsIconPathElement('M12 3v18'), // key: 108xh3
    DsIconPathElement('m19 8 3 8a5 5 0 0 1-6 0zV7'), // key: zcdpyk
    DsIconPathElement('M3 7h1a17 17 0 0 0 8-2 17 17 0 0 0 8 2h1'), // key: 1yorad
    DsIconPathElement('m5 8 3 8a5 5 0 0 1-6 0zV7'), // key: eua70x
    DsIconPathElement('M7 21h10'), // key: 1b0cd5
  ]);

  /// `scaling.mjs`
  static const DsLucideGlyph scaling =
      DsLucideGlyph('scaling', <DsIconElement>[
    DsIconPathElement('M12 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7'), // key: 1m0v6g
    DsIconPathElement('M14 15H9v-5'), // key: pi4jk9
    DsIconPathElement('M16 3h5v5'), // key: 1806ms
    DsIconPathElement('M21 3 9 15'), // key: 15kdhq
  ]);

  /// `scan-barcode.mjs`
  static const DsLucideGlyph scanBarcode =
      DsLucideGlyph('scan-barcode', <DsIconElement>[
    DsIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    DsIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    DsIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    DsIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
    DsIconPathElement('M8 7v10'), // key: 23sfjj
    DsIconPathElement('M12 7v10'), // key: jspqdw
    DsIconPathElement('M17 7v10'), // key: 578dap
  ]);

  /// `scan-box.mjs`
  static const DsLucideGlyph scanBox =
      DsLucideGlyph('scan-box', <DsIconElement>[
    DsIconPathElement('M12 12v5.5'), // key: 1fezw7
    DsIconPathElement('M17 3h2a2 2 0 012 2v2'), // key: sxhzt8
    DsIconPathElement('M21 17v2a2 2 0 01-2 2h-2'), // key: b4b27w
    DsIconPathElement('M3 7V5a2 2 0 012-2h2'), // key: 5quapj
    DsIconPathElement('M7 21H5a2 2 0 01-2-2v-2'), // key: rx7q13
    DsIconPathElement('M7.264 9.252 12 12l4.737-2.748'), // key: 176tmc
    DsIconPathElement('M7.995 8.514A2 2 0 007 10.244v3.516a2 2 0 00.996 1.73l3 1.74a2 2 0 002.008 0l3-1.74A2 2 0 0017 13.76v-3.517a2 2 0 00-.995-1.73l-3-1.742a2 2 0 00-1.892-.064z'), // key: 7zy66p
  ]);

  /// `scan-eye.mjs`
  static const DsLucideGlyph scanEye =
      DsLucideGlyph('scan-eye', <DsIconElement>[
    DsIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    DsIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    DsIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    DsIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
    DsIconCircleElement(12, 12, 1), // key: 41hilf
    DsIconPathElement('M18.944 12.33a1 1 0 0 0 0-.66 7.5 7.5 0 0 0-13.888 0 1 1 0 0 0 0 .66 7.5 7.5 0 0 0 13.888 0'), // key: 11ak4c
  ]);

  /// `scan-face.mjs`
  static const DsLucideGlyph scanFace =
      DsLucideGlyph('scan-face', <DsIconElement>[
    DsIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    DsIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    DsIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    DsIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
    DsIconPathElement('M8 14s1.5 2 4 2 4-2 4-2'), // key: 1y1vjs
    DsIconPathElement('M9 9h.01'), // key: 1q5me6
    DsIconPathElement('M15 9h.01'), // key: x1ddxp
  ]);

  /// `scan-heart.mjs`
  static const DsLucideGlyph scanHeart =
      DsLucideGlyph('scan-heart', <DsIconElement>[
    DsIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    DsIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    DsIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    DsIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
    DsIconPathElement('M7.828 13.07A3 3 0 0 1 12 8.764a3 3 0 0 1 4.172 4.306l-3.447 3.62a1 1 0 0 1-1.449 0z'), // key: 1ak1ef
  ]);

  /// `scan-line.mjs`
  static const DsLucideGlyph scanLine =
      DsLucideGlyph('scan-line', <DsIconElement>[
    DsIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    DsIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    DsIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    DsIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
    DsIconPathElement('M7 12h10'), // key: b7w52i
  ]);

  /// `scan-qr-code.mjs`
  static const DsLucideGlyph scanQrCode =
      DsLucideGlyph('scan-qr-code', <DsIconElement>[
    DsIconPathElement('M17 12v4a1 1 0 0 1-1 1h-4'), // key: uk4fdo
    DsIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    DsIconPathElement('M17 8V7'), // key: q2g9wo
    DsIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    DsIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    DsIconPathElement('M7 17h.01'), // key: 19xn7k
    DsIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
    DsIconRectElement(7, 7, 5, 5, 1), // key: m9kyts
  ]);

  /// `scan-search.mjs`
  static const DsLucideGlyph scanSearch =
      DsLucideGlyph('scan-search', <DsIconElement>[
    DsIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    DsIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    DsIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    DsIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
    DsIconCircleElement(12, 12, 3), // key: 1v7zrd
    DsIconPathElement('m16 16-1.9-1.9'), // key: 1dq9hf
  ]);

  /// `scan-square.mjs`
  static const DsLucideGlyph scanSquare =
      DsLucideGlyph('scan-square', <DsIconElement>[
    DsIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    DsIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    DsIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    DsIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
    DsIconRectElement(8, 8, 8, 8, 1), // key: 69yp3k
  ]);

  /// `scan-text.mjs`
  static const DsLucideGlyph scanText =
      DsLucideGlyph('scan-text', <DsIconElement>[
    DsIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    DsIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    DsIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    DsIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
    DsIconPathElement('M7 8h8'), // key: 1jbsf9
    DsIconPathElement('M7 12h10'), // key: b7w52i
    DsIconPathElement('M7 16h6'), // key: 1vyc9m
  ]);

  /// `scan.mjs`
  static const DsLucideGlyph scan =
      DsLucideGlyph('scan', <DsIconElement>[
    DsIconPathElement('M3 7V5a2 2 0 0 1 2-2h2'), // key: aa7l1z
    DsIconPathElement('M17 3h2a2 2 0 0 1 2 2v2'), // key: 4qcy5o
    DsIconPathElement('M21 17v2a2 2 0 0 1-2 2h-2'), // key: 6vwrx8
    DsIconPathElement('M7 21H5a2 2 0 0 1-2-2v-2'), // key: ioqczr
  ]);

  /// `school.mjs`
  static const DsLucideGlyph school =
      DsLucideGlyph('school', <DsIconElement>[
    DsIconPathElement('M14 21v-3a2 2 0 0 0-4 0v3'), // key: 1rgiei
    DsIconPathElement('M18 4.933V21'), // key: tjwmp4
    DsIconPathElement('m4 6 7.106-3.79a2 2 0 0 1 1.788 0L20 6'), // key: zywc2d
    DsIconPathElement('m6 11-3.52 2.147a1 1 0 0 0-.48.854V19a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-5a1 1 0 0 0-.48-.853L18 11'), // key: 1d4ql0
    DsIconPathElement('M6 4.933V21'), // key: 1ufz1j
    DsIconCircleElement(12, 9, 2), // key: 1092wv
  ]);

  /// `scissors-line-dashed.mjs`
  static const DsLucideGlyph scissorsLineDashed =
      DsLucideGlyph('scissors-line-dashed', <DsIconElement>[
    DsIconPathElement('M5.42 9.42 8 12'), // key: 12pkuq
    DsIconCircleElement(4, 8, 2), // key: 107mxr
    DsIconPathElement('m14 6-8.58 8.58'), // key: gvzu5l
    DsIconCircleElement(4, 16, 2), // key: 1ehqvc
    DsIconPathElement('M10.8 14.8 14 18'), // key: ax7m9r
    DsIconPathElement('M16 12h-2'), // key: 10asgb
    DsIconPathElement('M22 12h-2'), // key: 14jgyd
  ]);

  /// `scissors.mjs`
  static const DsLucideGlyph scissors =
      DsLucideGlyph('scissors', <DsIconElement>[
    DsIconCircleElement(6, 6, 3), // key: 1lh9wr
    DsIconPathElement('M8.12 8.12 12 12'), // key: 1alkpv
    DsIconPathElement('M20 4 8.12 15.88'), // key: xgtan2
    DsIconCircleElement(6, 18, 3), // key: fqmcym
    DsIconPathElement('M14.8 14.8 20 20'), // key: ptml3r
  ]);

  /// `scooter.mjs`
  static const DsLucideGlyph scooter =
      DsLucideGlyph('scooter', <DsIconElement>[
    DsIconPathElement('M21 4h-3.5l2 11.05'), // key: 1gktiw
    DsIconPathElement('M6.95 17h5.142c.523 0 .95-.406 1.063-.916a6.5 6.5 0 0 1 5.345-5.009'), // key: 1bq3u3
    DsIconCircleElement(19.5, 17.5, 2.5), // key: e4zhv9
    DsIconCircleElement(4.5, 17.5, 2.5), // key: 50vk4p
  ]);

  /// `screen-share-off.mjs`
  static const DsLucideGlyph screenShareOff =
      DsLucideGlyph('screen-share-off', <DsIconElement>[
    DsIconPathElement('M13 3H4a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-3'), // key: i8wdob
    DsIconPathElement('M8 21h8'), // key: 1ev6f3
    DsIconPathElement('M12 17v4'), // key: 1riwvh
    DsIconPathElement('m22 3-5 5'), // key: 12jva0
    DsIconPathElement('m17 3 5 5'), // key: k36vhe
  ]);

  /// `screen-share.mjs`
  static const DsLucideGlyph screenShare =
      DsLucideGlyph('screen-share', <DsIconElement>[
    DsIconPathElement('M13 3H4a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-3'), // key: i8wdob
    DsIconPathElement('M8 21h8'), // key: 1ev6f3
    DsIconPathElement('M12 17v4'), // key: 1riwvh
    DsIconPathElement('m17 8 5-5'), // key: fqif7o
    DsIconPathElement('M17 3h5v5'), // key: 1o3tu8
  ]);

  /// `scroll-text.mjs`
  static const DsLucideGlyph scrollText =
      DsLucideGlyph('scroll-text', <DsIconElement>[
    DsIconPathElement('M15 12h-5'), // key: r7krc0
    DsIconPathElement('M15 8h-5'), // key: 1khuty
    DsIconPathElement('M19 17V5a2 2 0 0 0-2-2H4'), // key: zz82l3
    DsIconPathElement('M8 21h12a2 2 0 0 0 2-2v-1a1 1 0 0 0-1-1H11a1 1 0 0 0-1 1v1a2 2 0 1 1-4 0V5a2 2 0 1 0-4 0v2a1 1 0 0 0 1 1h3'), // key: 1ph1d7
  ]);

  /// `scroll.mjs`
  static const DsLucideGlyph scroll =
      DsLucideGlyph('scroll', <DsIconElement>[
    DsIconPathElement('M19 17V5a2 2 0 0 0-2-2H4'), // key: zz82l3
    DsIconPathElement('M8 21h12a2 2 0 0 0 2-2v-1a1 1 0 0 0-1-1H11a1 1 0 0 0-1 1v1a2 2 0 1 1-4 0V5a2 2 0 1 0-4 0v2a1 1 0 0 0 1 1h3'), // key: 1ph1d7
  ]);

  /// `search-alert.mjs`
  static const DsLucideGlyph searchAlert =
      DsLucideGlyph('search-alert', <DsIconElement>[
    DsIconCircleElement(11, 11, 8), // key: 4ej97u
    DsIconPathElement('m21 21-4.3-4.3'), // key: 1qie3q
    DsIconPathElement('M11 7v4'), // key: m2edmq
    DsIconPathElement('M11 15h.01'), // key: k85uqc
  ]);

  /// `search-check.mjs`
  static const DsLucideGlyph searchCheck =
      DsLucideGlyph('search-check', <DsIconElement>[
    DsIconPathElement('m8 11 2 2 4-4'), // key: 1sed1v
    DsIconCircleElement(11, 11, 8), // key: 4ej97u
    DsIconPathElement('m21 21-4.3-4.3'), // key: 1qie3q
  ]);

  /// `search-code.mjs`
  static const DsLucideGlyph searchCode =
      DsLucideGlyph('search-code', <DsIconElement>[
    DsIconPathElement('m13 13.5 2-2.5-2-2.5'), // key: 1rvxrh
    DsIconPathElement('m21 21-4.3-4.3'), // key: 1qie3q
    DsIconPathElement('M9 8.5 7 11l2 2.5'), // key: 6ffwbx
    DsIconCircleElement(11, 11, 8), // key: 4ej97u
  ]);

  /// `search-slash.mjs`
  static const DsLucideGlyph searchSlash =
      DsLucideGlyph('search-slash', <DsIconElement>[
    DsIconPathElement('m13.5 8.5-5 5'), // key: 1cs55j
    DsIconCircleElement(11, 11, 8), // key: 4ej97u
    DsIconPathElement('m21 21-4.3-4.3'), // key: 1qie3q
  ]);

  /// `search-x.mjs`
  static const DsLucideGlyph searchX =
      DsLucideGlyph('search-x', <DsIconElement>[
    DsIconPathElement('m13.5 8.5-5 5'), // key: 1cs55j
    DsIconPathElement('m8.5 8.5 5 5'), // key: a8mexj
    DsIconCircleElement(11, 11, 8), // key: 4ej97u
    DsIconPathElement('m21 21-4.3-4.3'), // key: 1qie3q
  ]);

  /// `search.mjs`
  static const DsLucideGlyph search =
      DsLucideGlyph('search', <DsIconElement>[
    DsIconPathElement('m21 21-4.34-4.34'), // key: 14j7rj
    DsIconCircleElement(11, 11, 8), // key: 4ej97u
  ]);

  /// `section.mjs`
  static const DsLucideGlyph section =
      DsLucideGlyph('section', <DsIconElement>[
    DsIconPathElement('M16 5a4 3 0 0 0-8 0c0 4 8 3 8 7a4 3 0 0 1-8 0'), // key: vqan6v
    DsIconPathElement('M8 19a4 3 0 0 0 8 0c0-4-8-3-8-7a4 3 0 0 1 8 0'), // key: wdjd8o
  ]);

  /// `send-horizontal.mjs`
  static const DsLucideGlyph sendHorizontal =
      DsLucideGlyph('send-horizontal', <DsIconElement>[
    DsIconPathElement('M3.714 3.048a.498.498 0 0 0-.683.627l2.843 7.627a2 2 0 0 1 0 1.396l-2.842 7.627a.498.498 0 0 0 .682.627l18-8.5a.5.5 0 0 0 0-.904z'), // key: 117uat
    DsIconPathElement('M6 12h16'), // key: s4cdu5
  ]);

  /// `send-to-back.mjs`
  static const DsLucideGlyph sendToBack =
      DsLucideGlyph('send-to-back', <DsIconElement>[
    DsIconRectElement(14, 14, 8, 8, 2), // key: 1b0bso
    DsIconRectElement(2, 2, 8, 8, 2), // key: 1x09vl
    DsIconPathElement('M7 14v1a2 2 0 0 0 2 2h1'), // key: pao6x6
    DsIconPathElement('M14 7h1a2 2 0 0 1 2 2v1'), // key: 19tdru
  ]);

  /// `send.mjs`
  static const DsLucideGlyph send =
      DsLucideGlyph('send', <DsIconElement>[
    DsIconPathElement('M14.536 21.686a.5.5 0 0 0 .937-.024l6.5-19a.496.496 0 0 0-.635-.635l-19 6.5a.5.5 0 0 0-.024.937l7.93 3.18a2 2 0 0 1 1.112 1.11z'), // key: 1ffxy3
    DsIconPathElement('m21.854 2.147-10.94 10.939'), // key: 12cjpa
  ]);

  /// `separator-horizontal.mjs`
  static const DsLucideGlyph separatorHorizontal =
      DsLucideGlyph('separator-horizontal', <DsIconElement>[
    DsIconPathElement('m16 16-4 4-4-4'), // key: 3dv8je
    DsIconPathElement('M3 12h18'), // key: 1i2n21
    DsIconPathElement('m8 8 4-4 4 4'), // key: 2bscm2
  ]);

  /// `separator-vertical.mjs`
  static const DsLucideGlyph separatorVertical =
      DsLucideGlyph('separator-vertical', <DsIconElement>[
    DsIconPathElement('M12 3v18'), // key: 108xh3
    DsIconPathElement('m16 16 4-4-4-4'), // key: 1js579
    DsIconPathElement('m8 8-4 4 4 4'), // key: 1whems
  ]);

  /// `server-cog.mjs`
  static const DsLucideGlyph serverCog =
      DsLucideGlyph('server-cog', <DsIconElement>[
    DsIconPathElement('m10.852 14.772-.383.923'), // key: 11vil6
    DsIconPathElement('M13.148 14.772a3 3 0 1 0-2.296-5.544l-.383-.923'), // key: 1v3clb
    DsIconPathElement('m13.148 9.228.383-.923'), // key: t2zzyc
    DsIconPathElement('m13.53 15.696-.382-.924a3 3 0 1 1-2.296-5.544'), // key: 1bxfiv
    DsIconPathElement('m14.772 10.852.923-.383'), // key: k9m8cz
    DsIconPathElement('m14.772 13.148.923.383'), // key: 1xvhww
    DsIconPathElement('M4.5 10H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2h-.5'), // key: tn8das
    DsIconPathElement('M4.5 14H4a2 2 0 0 0-2 2v4a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-4a2 2 0 0 0-2-2h-.5'), // key: 1g2pve
    DsIconPathElement('M6 18h.01'), // key: uhywen
    DsIconPathElement('M6 6h.01'), // key: 1utrut
    DsIconPathElement('m9.228 10.852-.923-.383'), // key: 1wtb30
    DsIconPathElement('m9.228 13.148-.923.383'), // key: 1a830x
  ]);

  /// `server-crash.mjs`
  static const DsLucideGlyph serverCrash =
      DsLucideGlyph('server-crash', <DsIconElement>[
    DsIconPathElement('M6 10H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2h-2'), // key: 4b9dqc
    DsIconPathElement('M6 14H4a2 2 0 0 0-2 2v4a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-4a2 2 0 0 0-2-2h-2'), // key: 22nnkd
    DsIconPathElement('M6 6h.01'), // key: 1utrut
    DsIconPathElement('M6 18h.01'), // key: uhywen
    DsIconPathElement('m13 6-4 6h6l-4 6'), // key: 14hqih
  ]);

  /// `server-off.mjs`
  static const DsLucideGlyph serverOff =
      DsLucideGlyph('server-off', <DsIconElement>[
    DsIconPathElement('M7 2h13a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2h-5'), // key: bt2siv
    DsIconPathElement('M10 10 2.5 2.5C2 2 2 2.5 2 5v3a2 2 0 0 0 2 2h6z'), // key: 1hjrv1
    DsIconPathElement('M22 17v-1a2 2 0 0 0-2-2h-1'), // key: 1iynyr
    DsIconPathElement('M4 14a2 2 0 0 0-2 2v4a2 2 0 0 0 2 2h16.5l1-.5.5.5-8-8H4z'), // key: 161ggg
    DsIconPathElement('M6 18h.01'), // key: uhywen
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `server-plus.mjs`
  static const DsLucideGlyph serverPlus =
      DsLucideGlyph('server-plus', <DsIconElement>[
    DsIconPathElement('M12.5 10H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v2'), // key: s66i12
    DsIconPathElement('M16 12h6'), // key: 15xry1
    DsIconPathElement('M19 9v6'), // key: 1kf5t6
    DsIconPathElement('M22 18v2a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2v-4a2 2 0 0 1 2-2h8.5'), // key: lo70fm
    DsIconPathElement('M6 18h.01'), // key: uhywen
    DsIconPathElement('M6 6h.01'), // key: 1utrut
  ]);

  /// `server.mjs`
  static const DsLucideGlyph server =
      DsLucideGlyph('server', <DsIconElement>[
    DsIconRectElement(2, 2, 20, 8, 2, ry: 2), // key: ngkwjq
    DsIconRectElement(2, 14, 20, 8, 2, ry: 2), // key: iecqi9
    DsIconLineElement(6, 6, 6.01, 6), // key: 16zg32
    DsIconLineElement(6, 18, 6.01, 18), // key: nzw8ys
  ]);

  /// `settings-2.mjs`
  static const DsLucideGlyph settings2 =
      DsLucideGlyph('settings-2', <DsIconElement>[
    DsIconPathElement('M14 17H5'), // key: gfn3mx
    DsIconPathElement('M19 7h-9'), // key: 6i9tg
    DsIconCircleElement(17, 17, 3), // key: 18b49y
    DsIconCircleElement(7, 7, 3), // key: dfmy0x
  ]);

  /// `settings.mjs`
  static const DsLucideGlyph settings =
      DsLucideGlyph('settings', <DsIconElement>[
    DsIconPathElement('M9.671 4.136a2.34 2.34 0 0 1 4.659 0 2.34 2.34 0 0 0 3.319 1.915 2.34 2.34 0 0 1 2.33 4.033 2.34 2.34 0 0 0 0 3.831 2.34 2.34 0 0 1-2.33 4.033 2.34 2.34 0 0 0-3.319 1.915 2.34 2.34 0 0 1-4.659 0 2.34 2.34 0 0 0-3.32-1.915 2.34 2.34 0 0 1-2.33-4.033 2.34 2.34 0 0 0 0-3.831A2.34 2.34 0 0 1 6.35 6.051a2.34 2.34 0 0 0 3.319-1.915'), // key: 1i5ecw
    DsIconCircleElement(12, 12, 3), // key: 1v7zrd
  ]);

  /// `shapes.mjs`
  static const DsLucideGlyph shapes =
      DsLucideGlyph('shapes', <DsIconElement>[
    DsIconPathElement('M8.3 10a.7.7 0 0 1-.626-1.079L11.4 3a.7.7 0 0 1 1.198-.043L16.3 8.9a.7.7 0 0 1-.572 1.1Z'), // key: 1bo67w
    DsIconRectElement(3, 14, 7, 7, 1), // key: 1bkyp8
    DsIconCircleElement(17.5, 17.5, 3.5), // key: w3z12y
  ]);

  /// `share-2.mjs`
  static const DsLucideGlyph share2 =
      DsLucideGlyph('share-2', <DsIconElement>[
    DsIconCircleElement(18, 5, 3), // key: gq8acd
    DsIconCircleElement(6, 12, 3), // key: w7nqdw
    DsIconCircleElement(18, 19, 3), // key: 1xt0gg
    DsIconLineElement(8.59, 13.51, 15.42, 17.49), // key: 47mynk
    DsIconLineElement(15.41, 6.51, 8.59, 10.49), // key: 1n3mei
  ]);

  /// `share.mjs`
  static const DsLucideGlyph share =
      DsLucideGlyph('share', <DsIconElement>[
    DsIconPathElement('M12 2v13'), // key: 1km8f5
    DsIconPathElement('m16 6-4-4-4 4'), // key: 13yo43
    DsIconPathElement('M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8'), // key: 1b2hhj
  ]);

  /// `sheet.mjs`
  static const DsLucideGlyph sheet =
      DsLucideGlyph('sheet', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    DsIconLineElement(3, 9, 21, 9), // key: 1vqk6q
    DsIconLineElement(3, 15, 21, 15), // key: o2sbyz
    DsIconLineElement(9, 9, 9, 21), // key: 1ib60c
    DsIconLineElement(15, 9, 15, 21), // key: 1n26ft
  ]);

  /// `shell.mjs`
  static const DsLucideGlyph shell =
      DsLucideGlyph('shell', <DsIconElement>[
    DsIconPathElement('M14 11a2 2 0 1 1-4 0 4 4 0 0 1 8 0 6 6 0 0 1-12 0 8 8 0 0 1 16 0 10 10 0 1 1-20 0 11.93 11.93 0 0 1 2.42-7.22 2 2 0 1 1 3.16 2.44'), // key: 1cn552
  ]);

  /// `shelving-unit.mjs`
  static const DsLucideGlyph shelvingUnit =
      DsLucideGlyph('shelving-unit', <DsIconElement>[
    DsIconPathElement('M12 12V9a1 1 0 0 0-1-1H9a1 1 0 0 0-1 1v3'), // key: wiz68x
    DsIconPathElement('M16 20v-3a1 1 0 0 0-1-1h-2a1 1 0 0 0-1 1v3'), // key: 1b59c4
    DsIconPathElement('M20 22V2'), // key: 1bnhr8
    DsIconPathElement('M4 12h16'), // key: 1lakjw
    DsIconPathElement('M4 20h16'), // key: 14thso
    DsIconPathElement('M4 2v20'), // key: gtpd5x
    DsIconPathElement('M4 4h16'), // key: 1bkgr1
  ]);

  /// `shield-alert.mjs`
  static const DsLucideGlyph shieldAlert =
      DsLucideGlyph('shield-alert', <DsIconElement>[
    DsIconPathElement('M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z'), // key: oel41y
    DsIconPathElement('M12 8v4'), // key: 1got3b
    DsIconPathElement('M12 16h.01'), // key: 1drbdi
  ]);

  /// `shield-ban.mjs`
  static const DsLucideGlyph shieldBan =
      DsLucideGlyph('shield-ban', <DsIconElement>[
    DsIconPathElement('M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z'), // key: oel41y
    DsIconPathElement('m4.243 5.21 14.39 12.472'), // key: 1c9a7c
  ]);

  /// `shield-check.mjs`
  static const DsLucideGlyph shieldCheck =
      DsLucideGlyph('shield-check', <DsIconElement>[
    DsIconPathElement('M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z'), // key: oel41y
    DsIconPathElement('m9 12 2 2 4-4'), // key: dzmm74
  ]);

  /// `shield-cog-corner.mjs`
  static const DsLucideGlyph shieldCogCorner =
      DsLucideGlyph('shield-cog-corner', <DsIconElement>[
    DsIconPathElement('M11 22c-3.806-1.45-7-3.966-7-9V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1v4'), // key: hf1sz5
    DsIconPathElement('M14.923 16.547 14 16.164'), // key: 41f878
    DsIconPathElement('m14.923 18.843-.923.383'), // key: 82rvv5
    DsIconPathElement('M16.547 14.923 16.164 14'), // key: 1r7ypn
    DsIconPathElement('m16.547 20.467-.383.924'), // key: au4kyj
    DsIconPathElement('m18.843 14.923.383-.923'), // key: 1cbrwq
    DsIconPathElement('m19.225 21.391-.382-.924'), // key: 1u2bh9
    DsIconPathElement('m20.467 16.547.923-.383'), // key: cprboc
    DsIconPathElement('m20.467 18.843.923.383'), // key: inm8l2
    DsIconCircleElement(17.695, 17.695, 3), // key: 1i1rmh
  ]);

  /// `shield-cog.mjs`
  static const DsLucideGlyph shieldCog =
      DsLucideGlyph('shield-cog', <DsIconElement>[
    DsIconPathElement('m10.929 14.467-.383.924'), // key: hdyevy
    DsIconPathElement('M10.929 8.923 10.546 8'), // key: 1nr44d
    DsIconPathElement('M13.225 8.923 13.608 8'), // key: aewley
    DsIconPathElement('m13.607 15.391-.382-.924'), // key: m37gf1
    DsIconPathElement('m14.849 10.547.923-.383'), // key: 1d3c4q
    DsIconPathElement('m14.849 12.843.923.383'), // key: lmvhy3
    DsIconPathElement('M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z'), // key: oel41y
    DsIconPathElement('m9.305 10.547-.923-.383'), // key: 1d13ox
    DsIconPathElement('m9.305 12.843-.923.383'), // key: 7wxwh5
    DsIconCircleElement(12.077, 11.695, 3), // key: fse9k8
  ]);

  /// `shield-ellipsis.mjs`
  static const DsLucideGlyph shieldEllipsis =
      DsLucideGlyph('shield-ellipsis', <DsIconElement>[
    DsIconPathElement('M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z'), // key: oel41y
    DsIconPathElement('M8 12h.01'), // key: czm47f
    DsIconPathElement('M12 12h.01'), // key: 1mp3jc
    DsIconPathElement('M16 12h.01'), // key: 1l6xoz
  ]);

  /// `shield-half.mjs`
  static const DsLucideGlyph shieldHalf =
      DsLucideGlyph('shield-half', <DsIconElement>[
    DsIconPathElement('M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z'), // key: oel41y
    DsIconPathElement('M12 22V2'), // key: zs6s6o
  ]);

  /// `shield-keyhole.mjs`
  static const DsLucideGlyph shieldKeyhole =
      DsLucideGlyph('shield-keyhole', <DsIconElement>[
    DsIconPathElement('M12 13v3'), // key: gkc6qb
    DsIconPathElement('M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 01-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 011-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 011.52 0C14.51 3.81 17 5 19 5a1 1 0 011 1z'), // key: 1buusj
    DsIconCircleElement(12, 11, 2), // key: 1yggc4
  ]);

  /// `shield-minus.mjs`
  static const DsLucideGlyph shieldMinus =
      DsLucideGlyph('shield-minus', <DsIconElement>[
    DsIconPathElement('M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z'), // key: oel41y
    DsIconPathElement('M9 12h6'), // key: 1c52cq
  ]);

  /// `shield-off.mjs`
  static const DsLucideGlyph shieldOff =
      DsLucideGlyph('shield-off', <DsIconElement>[
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M5 5a1 1 0 0 0-1 1v7c0 5 3.5 7.5 7.67 8.94a1 1 0 0 0 .67.01c2.35-.82 4.48-1.97 5.9-3.71'), // key: 1jlk70
    DsIconPathElement('M9.309 3.652A12.252 12.252 0 0 0 11.24 2.28a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1v7a9.784 9.784 0 0 1-.08 1.264'), // key: 18rp1v
  ]);

  /// `shield-plus.mjs`
  static const DsLucideGlyph shieldPlus =
      DsLucideGlyph('shield-plus', <DsIconElement>[
    DsIconPathElement('M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z'), // key: oel41y
    DsIconPathElement('M9 12h6'), // key: 1c52cq
    DsIconPathElement('M12 9v6'), // key: 199k2o
  ]);

  /// `shield-question-mark.mjs`
  static const DsLucideGlyph shieldQuestionMark =
      DsLucideGlyph('shield-question-mark', <DsIconElement>[
    DsIconPathElement('M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z'), // key: oel41y
    DsIconPathElement('M9.1 9a3 3 0 0 1 5.82 1c0 2-3 3-3 3'), // key: mhlwft
    DsIconPathElement('M12 17h.01'), // key: p32p05
  ]);

  /// `shield-user.mjs`
  static const DsLucideGlyph shieldUser =
      DsLucideGlyph('shield-user', <DsIconElement>[
    DsIconPathElement('M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z'), // key: oel41y
    DsIconPathElement('M6.376 18.91a6 6 0 0 1 11.249.003'), // key: hnjrf2
    DsIconCircleElement(12, 11, 4), // key: 1gt34v
  ]);

  /// `shield-x.mjs`
  static const DsLucideGlyph shieldX =
      DsLucideGlyph('shield-x', <DsIconElement>[
    DsIconPathElement('M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z'), // key: oel41y
    DsIconPathElement('m14.5 9.5-5 5'), // key: 17q4r4
    DsIconPathElement('m9.5 9.5 5 5'), // key: 18nt4w
  ]);

  /// `shield.mjs`
  static const DsLucideGlyph shield =
      DsLucideGlyph('shield', <DsIconElement>[
    DsIconPathElement('M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z'), // key: oel41y
  ]);

  /// `ship-wheel.mjs`
  static const DsLucideGlyph shipWheel =
      DsLucideGlyph('ship-wheel', <DsIconElement>[
    DsIconCircleElement(12, 12, 8), // key: 46899m
    DsIconPathElement('M12 2v7.5'), // key: 1e5rl5
    DsIconPathElement('m19 5-5.23 5.23'), // key: 1ezxxf
    DsIconPathElement('M22 12h-7.5'), // key: le1719
    DsIconPathElement('m19 19-5.23-5.23'), // key: p3fmgn
    DsIconPathElement('M12 14.5V22'), // key: dgcmos
    DsIconPathElement('M10.23 13.77 5 19'), // key: qwopd4
    DsIconPathElement('M9.5 12H2'), // key: r7bup8
    DsIconPathElement('M10.23 10.23 5 5'), // key: k2y7lj
    DsIconCircleElement(12, 12, 2.5), // key: ix0uyj
  ]);

  /// `ship.mjs`
  static const DsLucideGlyph ship =
      DsLucideGlyph('ship', <DsIconElement>[
    DsIconPathElement('M12 10.189V14'), // key: 1p8cqu
    DsIconPathElement('M12 2v3'), // key: qbqxhf
    DsIconPathElement('M19 13V7a2 2 0 0 0-2-2H7a2 2 0 0 0-2 2v6'), // key: qpkstq
    DsIconPathElement('M19.38 20A11.6 11.6 0 0 0 21 14l-8.188-3.639a2 2 0 0 0-1.624 0L3 14a11.6 11.6 0 0 0 2.81 7.76'), // key: 7tigtc
    DsIconPathElement('M2 21c.6.5 1.2 1 2.5 1 2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1s1.2 1 2.5 1c2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1'), // key: 1924j5
  ]);

  /// `shirt.mjs`
  static const DsLucideGlyph shirt =
      DsLucideGlyph('shirt', <DsIconElement>[
    DsIconPathElement('M20.38 3.46 16 2a4 4 0 0 1-8 0L3.62 3.46a2 2 0 0 0-1.34 2.23l.58 3.47a1 1 0 0 0 .99.84H6v10c0 1.1.9 2 2 2h8a2 2 0 0 0 2-2V10h2.15a1 1 0 0 0 .99-.84l.58-3.47a2 2 0 0 0-1.34-2.23z'), // key: 1wgbhj
  ]);

  /// `shopping-bag.mjs`
  static const DsLucideGlyph shoppingBag =
      DsLucideGlyph('shopping-bag', <DsIconElement>[
    DsIconPathElement('M16 10a4 4 0 0 1-8 0'), // key: 1ltviw
    DsIconPathElement('M3.103 6.034h17.794'), // key: awc11p
    DsIconPathElement('M3.4 5.467a2 2 0 0 0-.4 1.2V20a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6.667a2 2 0 0 0-.4-1.2l-2-2.667A2 2 0 0 0 17 2H7a2 2 0 0 0-1.6.8z'), // key: o988cm
  ]);

  /// `shopping-basket.mjs`
  static const DsLucideGlyph shoppingBasket =
      DsLucideGlyph('shopping-basket', <DsIconElement>[
    DsIconPathElement('m15 11-1 9'), // key: 5wnq3a
    DsIconPathElement('m19 11-4-7'), // key: cnml18
    DsIconPathElement('M2 11h20'), // key: 3eubbj
    DsIconPathElement('m3.5 11 1.6 7.4a2 2 0 0 0 2 1.6h9.8a2 2 0 0 0 2-1.6l1.7-7.4'), // key: yiazzp
    DsIconPathElement('M4.5 15.5h15'), // key: 13mye1
    DsIconPathElement('m5 11 4-7'), // key: 116ra9
    DsIconPathElement('m9 11 1 9'), // key: 1ojof7
  ]);

  /// `shopping-cart.mjs`
  static const DsLucideGlyph shoppingCart =
      DsLucideGlyph('shopping-cart', <DsIconElement>[
    DsIconCircleElement(8, 21, 1), // key: jimo8o
    DsIconCircleElement(19, 21, 1), // key: 13723u
    DsIconPathElement('M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12'), // key: 9zh506
  ]);

  /// `shovel.mjs`
  static const DsLucideGlyph shovel =
      DsLucideGlyph('shovel', <DsIconElement>[
    DsIconPathElement('M21.56 4.56a1.5 1.5 0 0 1 0 2.122l-.47.47a3 3 0 0 1-4.212-.03 3 3 0 0 1 0-4.243l.44-.44a1.5 1.5 0 0 1 2.121 0z'), // key: 1gcedi
    DsIconPathElement('M3 22a1 1 0 0 1-1-1v-3.586a1 1 0 0 1 .293-.707l3.355-3.355a1.205 1.205 0 0 1 1.704 0l3.296 3.296a1.205 1.205 0 0 1 0 1.704l-3.355 3.355a1 1 0 0 1-.707.293z'), // key: pg9kv3
    DsIconPathElement('m9 15 7.879-7.878'), // key: 1o1zgh
  ]);

  /// `shower-head.mjs`
  static const DsLucideGlyph showerHead =
      DsLucideGlyph('shower-head', <DsIconElement>[
    DsIconPathElement('m4 4 2.5 2.5'), // key: uv2vmf
    DsIconPathElement('M13.5 6.5a4.95 4.95 0 0 0-7 7'), // key: frdkwv
    DsIconPathElement('M15 5 5 15'), // key: 1ag8rq
    DsIconPathElement('M14 17v.01'), // key: eokfpp
    DsIconPathElement('M10 16v.01'), // key: 14uyyl
    DsIconPathElement('M13 13v.01'), // key: 1v1k97
    DsIconPathElement('M16 10v.01'), // key: 5169yg
    DsIconPathElement('M11 20v.01'), // key: cj92p8
    DsIconPathElement('M17 14v.01'), // key: 11cswd
    DsIconPathElement('M20 11v.01'), // key: 19e0od
  ]);

  /// `shredder.mjs`
  static const DsLucideGlyph shredder =
      DsLucideGlyph('shredder', <DsIconElement>[
    DsIconPathElement('M4 13V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v5'), // key: 1eob4r
    DsIconPathElement('M14 2v5a1 1 0 0 0 1 1h5'), // key: wfsgrz
    DsIconPathElement('M10 22v-5'), // key: sfixh4
    DsIconPathElement('M14 19v-2'), // key: pdve8j
    DsIconPathElement('M18 20v-3'), // key: uox2gk
    DsIconPathElement('M2 13h20'), // key: 5evz65
    DsIconPathElement('M6 20v-3'), // key: c6pdcb
  ]);

  /// `shrimp.mjs`
  static const DsLucideGlyph shrimp =
      DsLucideGlyph('shrimp', <DsIconElement>[
    DsIconPathElement('M11 12h.01'), // key: 1lr4k6
    DsIconPathElement('M13 22c.5-.5 1.12-1 2.5-1-1.38 0-2-.5-2.5-1'), // key: fatpdi
    DsIconPathElement('M14 2a3.28 3.28 0 0 1-3.227 1.798l-6.17-.561A2.387 2.387 0 1 0 4.387 8H15.5a1 1 0 0 1 0 13 1 1 0 0 0 0-5H12a7 7 0 0 1-7-7V8'), // key: kehrqe
    DsIconPathElement('M14 8a8.5 8.5 0 0 1 0 8'), // key: 1imjx2
    DsIconPathElement('M16 16c2 0 4.5-4 4-6'), // key: z0nejz
  ]);

  /// `shrink.mjs`
  static const DsLucideGlyph shrink =
      DsLucideGlyph('shrink', <DsIconElement>[
    DsIconPathElement('m15 15 6 6m-6-6v4.8m0-4.8h4.8'), // key: 17vawe
    DsIconPathElement('M9 19.8V15m0 0H4.2M9 15l-6 6'), // key: chjx8e
    DsIconPathElement('M15 4.2V9m0 0h4.8M15 9l6-6'), // key: lav6yq
    DsIconPathElement('M9 4.2V9m0 0H4.2M9 9 3 3'), // key: 1pxi2q
  ]);

  /// `shrub.mjs`
  static const DsLucideGlyph shrub =
      DsLucideGlyph('shrub', <DsIconElement>[
    DsIconPathElement('M12 22v-5.172a2 2 0 0 0-.586-1.414L9.5 13.5'), // key: 1p17fm
    DsIconPathElement('M14.5 14.5 12 17'), // key: dy5w4y
    DsIconPathElement('M17 8.8A6 6 0 0 1 13.8 20H10A6.5 6.5 0 0 1 7 8a5 5 0 0 1 10 0z'), // key: 6z7b3o
  ]);

  /// `shuffle.mjs`
  static const DsLucideGlyph shuffle =
      DsLucideGlyph('shuffle', <DsIconElement>[
    DsIconPathElement('m18 14 4 4-4 4'), // key: 10pe0f
    DsIconPathElement('m18 2 4 4-4 4'), // key: pucp1d
    DsIconPathElement('M2 18h1.973a4 4 0 0 0 3.3-1.7l5.454-8.6a4 4 0 0 1 3.3-1.7H22'), // key: 1ailkh
    DsIconPathElement('M2 6h1.972a4 4 0 0 1 3.6 2.2'), // key: km57vx
    DsIconPathElement('M22 18h-6.041a4 4 0 0 1-3.3-1.8l-.359-.45'), // key: os18l9
  ]);

  /// `sigma.mjs`
  static const DsLucideGlyph sigma =
      DsLucideGlyph('sigma', <DsIconElement>[
    DsIconPathElement('M18 7V5a1 1 0 0 0-1-1H6.5a.5.5 0 0 0-.4.8l4.5 6a2 2 0 0 1 0 2.4l-4.5 6a.5.5 0 0 0 .4.8H17a1 1 0 0 0 1-1v-2'), // key: wuwx1p
  ]);

  /// `signal-high.mjs`
  static const DsLucideGlyph signalHigh =
      DsLucideGlyph('signal-high', <DsIconElement>[
    DsIconPathElement('M2 20h.01'), // key: 4haj6o
    DsIconPathElement('M7 20v-4'), // key: j294jx
    DsIconPathElement('M12 20v-8'), // key: i3yub9
    DsIconPathElement('M17 20V8'), // key: 1tkaf5
  ]);

  /// `signal-low.mjs`
  static const DsLucideGlyph signalLow =
      DsLucideGlyph('signal-low', <DsIconElement>[
    DsIconPathElement('M2 20h.01'), // key: 4haj6o
    DsIconPathElement('M7 20v-4'), // key: j294jx
  ]);

  /// `signal-medium.mjs`
  static const DsLucideGlyph signalMedium =
      DsLucideGlyph('signal-medium', <DsIconElement>[
    DsIconPathElement('M2 20h.01'), // key: 4haj6o
    DsIconPathElement('M7 20v-4'), // key: j294jx
    DsIconPathElement('M12 20v-8'), // key: i3yub9
  ]);

  /// `signal-zero.mjs`
  static const DsLucideGlyph signalZero =
      DsLucideGlyph('signal-zero', <DsIconElement>[
    DsIconPathElement('M2 20h.01'), // key: 4haj6o
  ]);

  /// `signal.mjs`
  static const DsLucideGlyph signal =
      DsLucideGlyph('signal', <DsIconElement>[
    DsIconPathElement('M2 20h.01'), // key: 4haj6o
    DsIconPathElement('M7 20v-4'), // key: j294jx
    DsIconPathElement('M12 20v-8'), // key: i3yub9
    DsIconPathElement('M17 20V8'), // key: 1tkaf5
    DsIconPathElement('M22 4v16'), // key: sih9yq
  ]);

  /// `signature.mjs`
  static const DsLucideGlyph signature =
      DsLucideGlyph('signature', <DsIconElement>[
    DsIconPathElement('m21 17-2.156-1.868A.5.5 0 0 0 18 15.5v.5a1 1 0 0 1-1 1h-2a1 1 0 0 1-1-1c0-2.545-3.991-3.97-8.5-4a1 1 0 0 0 0 5c4.153 0 4.745-11.295 5.708-13.5a2.5 2.5 0 1 1 3.31 3.284'), // key: y32ogt
    DsIconPathElement('M3 21h18'), // key: itz85i
  ]);

  /// `signpost-big.mjs`
  static const DsLucideGlyph signpostBig =
      DsLucideGlyph('signpost-big', <DsIconElement>[
    DsIconPathElement('M10 9H4L2 7l2-2h6'), // key: 1hq7x2
    DsIconPathElement('M14 5h6l2 2-2 2h-6'), // key: bv62ej
    DsIconPathElement('M10 22V4a2 2 0 1 1 4 0v18'), // key: eqpcf2
    DsIconPathElement('M8 22h8'), // key: rmew8v
  ]);

  /// `signpost.mjs`
  static const DsLucideGlyph signpost =
      DsLucideGlyph('signpost', <DsIconElement>[
    DsIconPathElement('M12 13v8'), // key: 1l5pq0
    DsIconPathElement('M12 3v3'), // key: 1n5kay
    DsIconPathElement('M2.354 10.354a1.207 1.207 0 0 1 0-1.708l2.06-2.06A2 2 0 0 1 5.828 6h12.344a2 2 0 0 1 1.414.586l2.06 2.06a1.207 1.207 0 0 1 0 1.708l-2.06 2.06a2 2 0 0 1-1.414.586H5.828a2 2 0 0 1-1.414-.586z'), // key: 1tm261
  ]);

  /// `siren.mjs`
  static const DsLucideGlyph siren =
      DsLucideGlyph('siren', <DsIconElement>[
    DsIconPathElement('M7 18v-6a5 5 0 1 1 10 0v6'), // key: pcx96s
    DsIconPathElement('M5 21a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-1a2 2 0 0 0-2-2H7a2 2 0 0 0-2 2z'), // key: 1b4s83
    DsIconPathElement('M21 12h1'), // key: jtio3y
    DsIconPathElement('M18.5 4.5 18 5'), // key: g5sp9y
    DsIconPathElement('M2 12h1'), // key: 1uaihz
    DsIconPathElement('M12 2v1'), // key: 11qlp1
    DsIconPathElement('m4.929 4.929.707.707'), // key: 1i51kw
    DsIconPathElement('M12 12v6'), // key: 3ahymv
  ]);

  /// `skip-back.mjs`
  static const DsLucideGlyph skipBack =
      DsLucideGlyph('skip-back', <DsIconElement>[
    DsIconPathElement('M17.971 4.285A2 2 0 0 1 21 6v12a2 2 0 0 1-3.029 1.715l-9.997-5.998a2 2 0 0 1-.003-3.432z'), // key: 15892j
    DsIconPathElement('M3 20V4'), // key: 1ptbpl
  ]);

  /// `skip-forward.mjs`
  static const DsLucideGlyph skipForward =
      DsLucideGlyph('skip-forward', <DsIconElement>[
    DsIconPathElement('M21 4v16'), // key: 7j8fe9
    DsIconPathElement('M6.029 4.285A2 2 0 0 0 3 6v12a2 2 0 0 0 3.029 1.715l9.997-5.998a2 2 0 0 0 .003-3.432z'), // key: zs4d6
  ]);

  /// `skull.mjs`
  static const DsLucideGlyph skull =
      DsLucideGlyph('skull', <DsIconElement>[
    DsIconPathElement('m12.5 17-.5-1-.5 1h1z'), // key: 3me087
    DsIconPathElement('M15 22a1 1 0 0 0 1-1v-1a2 2 0 0 0 1.56-3.25 8 8 0 1 0-11.12 0A2 2 0 0 0 8 20v1a1 1 0 0 0 1 1z'), // key: 1o5pge
    DsIconCircleElement(15, 12, 1), // key: 1tmaij
    DsIconCircleElement(9, 12, 1), // key: 1vctgf
  ]);

  /// `slash.mjs`
  static const DsLucideGlyph slash =
      DsLucideGlyph('slash', <DsIconElement>[
    DsIconPathElement('M22 2 2 22'), // key: y4kqgn
  ]);

  /// `slice.mjs`
  static const DsLucideGlyph slice =
      DsLucideGlyph('slice', <DsIconElement>[
    DsIconPathElement('M11 16.586V19a1 1 0 0 1-1 1H2L18.37 3.63a1 1 0 1 1 3 3l-9.663 9.663a1 1 0 0 1-1.414 0L8 14'), // key: 1sllp5
  ]);

  /// `sliders-horizontal.mjs`
  static const DsLucideGlyph slidersHorizontal =
      DsLucideGlyph('sliders-horizontal', <DsIconElement>[
    DsIconPathElement('M10 5H3'), // key: 1qgfaw
    DsIconPathElement('M12 19H3'), // key: yhmn1j
    DsIconPathElement('M14 3v4'), // key: 1sua03
    DsIconPathElement('M16 17v4'), // key: 1q0r14
    DsIconPathElement('M21 12h-9'), // key: 1o4lsq
    DsIconPathElement('M21 19h-5'), // key: 1rlt1p
    DsIconPathElement('M21 5h-7'), // key: 1oszz2
    DsIconPathElement('M8 10v4'), // key: tgpxqk
    DsIconPathElement('M8 12H3'), // key: a7s4jb
  ]);

  /// `sliders-vertical.mjs`
  static const DsLucideGlyph slidersVertical =
      DsLucideGlyph('sliders-vertical', <DsIconElement>[
    DsIconPathElement('M10 8h4'), // key: 1sr2af
    DsIconPathElement('M12 21v-9'), // key: 17s77i
    DsIconPathElement('M12 8V3'), // key: 13r4qs
    DsIconPathElement('M17 16h4'), // key: h1uq16
    DsIconPathElement('M19 12V3'), // key: o1uvq1
    DsIconPathElement('M19 21v-5'), // key: qua636
    DsIconPathElement('M3 14h4'), // key: bcjad9
    DsIconPathElement('M5 10V3'), // key: cb8scm
    DsIconPathElement('M5 21v-7'), // key: 1w1uti
  ]);

  /// `smartphone-charging.mjs`
  static const DsLucideGlyph smartphoneCharging =
      DsLucideGlyph('smartphone-charging', <DsIconElement>[
    DsIconRectElement(5, 2, 14, 20, 2, ry: 2), // key: 1yt0o3
    DsIconPathElement('M12.667 8 10 12h4l-2.667 4'), // key: h9lk2d
  ]);

  /// `smartphone-nfc.mjs`
  static const DsLucideGlyph smartphoneNfc =
      DsLucideGlyph('smartphone-nfc', <DsIconElement>[
    DsIconRectElement(2, 6, 7, 12, 1), // key: 5nje8w
    DsIconPathElement('M13 8.32a7.43 7.43 0 0 1 0 7.36'), // key: 1g306n
    DsIconPathElement('M16.46 6.21a11.76 11.76 0 0 1 0 11.58'), // key: uqvjvo
    DsIconPathElement('M19.91 4.1a15.91 15.91 0 0 1 .01 15.8'), // key: ujntz3
  ]);

  /// `smartphone.mjs`
  static const DsLucideGlyph smartphone =
      DsLucideGlyph('smartphone', <DsIconElement>[
    DsIconRectElement(5, 2, 14, 20, 2, ry: 2), // key: 1yt0o3
    DsIconPathElement('M12 18h.01'), // key: mhygvu
  ]);

  /// `smile-plus.mjs`
  static const DsLucideGlyph smilePlus =
      DsLucideGlyph('smile-plus', <DsIconElement>[
    DsIconPathElement('M22 11v1a10 10 0 1 1-9-10'), // key: ew0xw9
    DsIconPathElement('M8 14s1.5 2 4 2 4-2 4-2'), // key: 1y1vjs
    DsIconLineElement(9, 9, 9.01, 9), // key: yxxnd0
    DsIconLineElement(15, 9, 15.01, 9), // key: 1p4y9e
    DsIconPathElement('M16 5h6'), // key: 1vod17
    DsIconPathElement('M19 2v6'), // key: 4bpg5p
  ]);

  /// `smile.mjs`
  static const DsLucideGlyph smile =
      DsLucideGlyph('smile', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconPathElement('M8 14s1.5 2 4 2 4-2 4-2'), // key: 1y1vjs
    DsIconLineElement(9, 9, 9.01, 9), // key: yxxnd0
    DsIconLineElement(15, 9, 15.01, 9), // key: 1p4y9e
  ]);

  /// `snail.mjs`
  static const DsLucideGlyph snail =
      DsLucideGlyph('snail', <DsIconElement>[
    DsIconPathElement('M2 13a6 6 0 1 0 12 0 4 4 0 1 0-8 0 2 2 0 0 0 4 0'), // key: hneq2s
    DsIconCircleElement(10, 13, 8), // key: 194lz3
    DsIconPathElement('M2 21h12c4.4 0 8-3.6 8-8V7a2 2 0 1 0-4 0v6'), // key: ixqyt7
    DsIconPathElement('M18 3 19.1 5.2'), // key: 9tjm43
    DsIconPathElement('M22 3 20.9 5.2'), // key: j3odrs
  ]);

  /// `snowflake.mjs`
  static const DsLucideGlyph snowflake =
      DsLucideGlyph('snowflake', <DsIconElement>[
    DsIconPathElement('m10 20-1.25-2.5L6 18'), // key: 18frcb
    DsIconPathElement('M10 4 8.75 6.5 6 6'), // key: 7mghy3
    DsIconPathElement('m14 20 1.25-2.5L18 18'), // key: 1chtki
    DsIconPathElement('m14 4 1.25 2.5L18 6'), // key: 1b4wsy
    DsIconPathElement('m17 21-3-6h-4'), // key: 15hhxa
    DsIconPathElement('m17 3-3 6 1.5 3'), // key: 11697g
    DsIconPathElement('M2 12h6.5L10 9'), // key: kv9z4n
    DsIconPathElement('m20 10-1.5 2 1.5 2'), // key: 1swlpi
    DsIconPathElement('M22 12h-6.5L14 15'), // key: 1mxi28
    DsIconPathElement('m4 10 1.5 2L4 14'), // key: k9enpj
    DsIconPathElement('m7 21 3-6-1.5-3'), // key: j8hb9u
    DsIconPathElement('m7 3 3 6h4'), // key: 1otusx
  ]);

  /// `soap-dispenser-droplet.mjs`
  static const DsLucideGlyph soapDispenserDroplet =
      DsLucideGlyph('soap-dispenser-droplet', <DsIconElement>[
    DsIconPathElement('M10.5 2v4'), // key: 1xt6in
    DsIconPathElement('M14 2H7a2 2 0 0 0-2 2'), // key: e6xig3
    DsIconPathElement('M19.29 14.76A6.67 6.67 0 0 1 17 11a6.6 6.6 0 0 1-2.29 3.76c-1.15.92-1.71 2.04-1.71 3.19 0 2.22 1.8 4.05 4 4.05s4-1.83 4-4.05c0-1.16-.57-2.26-1.71-3.19'), // key: adq7uc
    DsIconPathElement('M9.607 21H6a2 2 0 0 1-2-2v-7a2 2 0 0 1 2-2h7V7a1 1 0 0 0-1-1H9a1 1 0 0 0-1 1v3'), // key: t9hm96
  ]);

  /// `sofa.mjs`
  static const DsLucideGlyph sofa =
      DsLucideGlyph('sofa', <DsIconElement>[
    DsIconPathElement('M20 9V6a2 2 0 0 0-2-2H6a2 2 0 0 0-2 2v3'), // key: 1dgpiv
    DsIconPathElement('M2 16a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-5a2 2 0 0 0-4 0v1.5a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5V11a2 2 0 0 0-4 0z'), // key: xacw8m
    DsIconPathElement('M4 18v2'), // key: jwo5n2
    DsIconPathElement('M20 18v2'), // key: 1ar1qi
    DsIconPathElement('M12 4v9'), // key: oqhhn3
  ]);

  /// `solar-panel.mjs`
  static const DsLucideGlyph solarPanel =
      DsLucideGlyph('solar-panel', <DsIconElement>[
    DsIconPathElement('M11 2h2'), // key: isr7bz
    DsIconPathElement('m14.28 14-4.56 8'), // key: 4anwcf
    DsIconPathElement('m21 22-1.558-4H4.558'), // key: enk13h
    DsIconPathElement('M3 10v2'), // key: w8mti9
    DsIconPathElement('M6.245 15.04A2 2 0 0 1 8 14h12a1 1 0 0 1 .864 1.505l-3.11 5.457A2 2 0 0 1 16 22H4a1 1 0 0 1-.863-1.506z'), // key: pouggg
    DsIconPathElement('M7 2a4 4 0 0 1-4 4'), // key: 78s8of
    DsIconPathElement('m8.66 7.66 1.41 1.41'), // key: 1vaqj8
  ]);

  /// `soup.mjs`
  static const DsLucideGlyph soup =
      DsLucideGlyph('soup', <DsIconElement>[
    DsIconPathElement('M12 21a9 9 0 0 0 9-9H3a9 9 0 0 0 9 9Z'), // key: 4rw317
    DsIconPathElement('M7 21h10'), // key: 1b0cd5
    DsIconPathElement('M19.5 12 22 6'), // key: shfsr5
    DsIconPathElement('M16.25 3c.27.1.8.53.75 1.36-.06.83-.93 1.2-1 2.02-.05.78.34 1.24.73 1.62'), // key: rpc6vp
    DsIconPathElement('M11.25 3c.27.1.8.53.74 1.36-.05.83-.93 1.2-.98 2.02-.06.78.33 1.24.72 1.62'), // key: 1lf63m
    DsIconPathElement('M6.25 3c.27.1.8.53.75 1.36-.06.83-.93 1.2-1 2.02-.05.78.34 1.24.74 1.62'), // key: 97tijn
  ]);

  /// `space.mjs`
  static const DsLucideGlyph space =
      DsLucideGlyph('space', <DsIconElement>[
    DsIconPathElement('M22 17v1c0 .5-.5 1-1 1H3c-.5 0-1-.5-1-1v-1'), // key: lt2kga
  ]);

  /// `spade.mjs`
  static const DsLucideGlyph spade =
      DsLucideGlyph('spade', <DsIconElement>[
    DsIconPathElement('M12 18v4'), // key: jadmvz
    DsIconPathElement('M2 14.499a5.5 5.5 0 0 0 9.591 3.675.6.6 0 0 1 .818.001A5.5 5.5 0 0 0 22 14.5c0-2.29-1.5-4-3-5.5l-5.492-5.312a2 2 0 0 0-3-.02L5 8.999c-1.5 1.5-3 3.2-3 5.5'), // key: 1aw2pz
  ]);

  /// `sparkle.mjs`
  static const DsLucideGlyph sparkle =
      DsLucideGlyph('sparkle', <DsIconElement>[
    DsIconPathElement('M11.017 2.814a1 1 0 0 1 1.966 0l1.051 5.558a2 2 0 0 0 1.594 1.594l5.558 1.051a1 1 0 0 1 0 1.966l-5.558 1.051a2 2 0 0 0-1.594 1.594l-1.051 5.558a1 1 0 0 1-1.966 0l-1.051-5.558a2 2 0 0 0-1.594-1.594l-5.558-1.051a1 1 0 0 1 0-1.966l5.558-1.051a2 2 0 0 0 1.594-1.594z'), // key: 1s2grr
  ]);

  /// `sparkles.mjs`
  static const DsLucideGlyph sparkles =
      DsLucideGlyph('sparkles', <DsIconElement>[
    DsIconPathElement('M11.017 2.814a1 1 0 0 1 1.966 0l1.051 5.558a2 2 0 0 0 1.594 1.594l5.558 1.051a1 1 0 0 1 0 1.966l-5.558 1.051a2 2 0 0 0-1.594 1.594l-1.051 5.558a1 1 0 0 1-1.966 0l-1.051-5.558a2 2 0 0 0-1.594-1.594l-5.558-1.051a1 1 0 0 1 0-1.966l5.558-1.051a2 2 0 0 0 1.594-1.594z'), // key: 1s2grr
    DsIconPathElement('M20 2v4'), // key: 1rf3ol
    DsIconPathElement('M22 4h-4'), // key: gwowj6
    DsIconCircleElement(4, 20, 2), // key: 6kqj1y
  ]);

  /// `speaker.mjs`
  static const DsLucideGlyph speaker =
      DsLucideGlyph('speaker', <DsIconElement>[
    DsIconRectElement(4, 2, 16, 20, 2), // key: 1nb95v
    DsIconPathElement('M12 6h.01'), // key: 1vi96p
    DsIconCircleElement(12, 14, 4), // key: 1jruaj
    DsIconPathElement('M12 14h.01'), // key: 1etili
  ]);

  /// `speech.mjs`
  static const DsLucideGlyph speech =
      DsLucideGlyph('speech', <DsIconElement>[
    DsIconPathElement('M8.8 20v-4.1l1.9.2a2.3 2.3 0 0 0 2.164-2.1V8.3A5.37 5.37 0 0 0 2 8.25c0 2.8.656 3.054 1 4.55a5.77 5.77 0 0 1 .029 2.758L2 20'), // key: 11atix
    DsIconPathElement('M19.8 17.8a7.5 7.5 0 0 0 .003-10.603'), // key: yol142
    DsIconPathElement('M17 15a3.5 3.5 0 0 0-.025-4.975'), // key: ssbmkc
  ]);

  /// `spell-check-2.mjs`
  static const DsLucideGlyph spellCheck2 =
      DsLucideGlyph('spell-check-2', <DsIconElement>[
    DsIconPathElement('m6 16 6-12 6 12'), // key: 1b4byz
    DsIconPathElement('M8 12h8'), // key: 1wcyev
    DsIconPathElement('M4 21c1.1 0 1.1-1 2.3-1s1.1 1 2.3 1c1.1 0 1.1-1 2.3-1 1.1 0 1.1 1 2.3 1 1.1 0 1.1-1 2.3-1 1.1 0 1.1 1 2.3 1 1.1 0 1.1-1 2.3-1'), // key: 8mdmtu
  ]);

  /// `spell-check.mjs`
  static const DsLucideGlyph spellCheck =
      DsLucideGlyph('spell-check', <DsIconElement>[
    DsIconPathElement('m6 16 6-12 6 12'), // key: 1b4byz
    DsIconPathElement('M8 12h8'), // key: 1wcyev
    DsIconPathElement('m16 20 2 2 4-4'), // key: 13tcca
  ]);

  /// `spline-pointer.mjs`
  static const DsLucideGlyph splinePointer =
      DsLucideGlyph('spline-pointer', <DsIconElement>[
    DsIconPathElement('M12.034 12.681a.498.498 0 0 1 .647-.647l9 3.5a.5.5 0 0 1-.033.943l-3.444 1.068a1 1 0 0 0-.66.66l-1.067 3.443a.5.5 0 0 1-.943.033z'), // key: xwnzip
    DsIconPathElement('M5 17A12 12 0 0 1 17 5'), // key: 1okkup
    DsIconCircleElement(19, 5, 2), // key: mhkx31
    DsIconCircleElement(5, 19, 2), // key: v8kfzx
  ]);

  /// `spline.mjs`
  static const DsLucideGlyph spline =
      DsLucideGlyph('spline', <DsIconElement>[
    DsIconCircleElement(19, 5, 2), // key: mhkx31
    DsIconCircleElement(5, 19, 2), // key: v8kfzx
    DsIconPathElement('M5 17A12 12 0 0 1 17 5'), // key: 1okkup
  ]);

  /// `split.mjs`
  static const DsLucideGlyph split =
      DsLucideGlyph('split', <DsIconElement>[
    DsIconPathElement('M16 3h5v5'), // key: 1806ms
    DsIconPathElement('M8 3H3v5'), // key: 15dfkv
    DsIconPathElement('M12 22v-8.3a4 4 0 0 0-1.172-2.872L3 3'), // key: 1qrqzj
    DsIconPathElement('m15 9 6-6'), // key: ko1vev
  ]);

  /// `spool.mjs`
  static const DsLucideGlyph spool =
      DsLucideGlyph('spool', <DsIconElement>[
    DsIconPathElement('M17 13.44 4.442 17.082A2 2 0 0 0 4.982 21H19a2 2 0 0 0 .558-3.921l-1.115-.32A2 2 0 0 1 17 14.837V7.66'), // key: 13vns8
    DsIconPathElement('m7 10.56 12.558-3.642A2 2 0 0 0 19.018 3H5a2 2 0 0 0-.558 3.921l1.115.32A2 2 0 0 1 7 9.163v7.178'), // key: s8x3u0
  ]);

  /// `sport-shoe.mjs`
  static const DsLucideGlyph sportShoe =
      DsLucideGlyph('sport-shoe', <DsIconElement>[
    DsIconPathElement('m15 10.42 4.8-5.07'), // key: 10at9d
    DsIconPathElement('M19 18h3'), // key: nnkd4d
    DsIconPathElement('M9.5 22 21.414 9.415A2 2 0 0 0 21.2 6.4l-5.61-4.208A1 1 0 0 0 14 3v2a2 2 0 0 1-1.394 1.906L8.677 8.053A1 1 0 0 0 8 9c-.155 6.393-2.082 9-4 9a2 2 0 0 0 0 4h14'), // key: v410ed
  ]);

  /// `spotlight.mjs`
  static const DsLucideGlyph spotlight =
      DsLucideGlyph('spotlight', <DsIconElement>[
    DsIconPathElement('M15.295 19.562 16 22'), // key: 31jsb7
    DsIconPathElement('m17 16 3.758 2.098'), // key: 121ar7
    DsIconPathElement('m19 12.5 3.026-.598'), // key: 19ukd3
    DsIconPathElement('M7.61 6.3a3 3 0 0 0-3.92 1.3l-1.38 2.79a3 3 0 0 0 1.3 3.91l6.89 3.597a1 1 0 0 0 1.342-.447l3.106-6.211a1 1 0 0 0-.447-1.341z'), // key: lwb9l9
    DsIconPathElement('M8 9V2'), // key: 1xa0v7
  ]);

  /// `spray-can.mjs`
  static const DsLucideGlyph sprayCan =
      DsLucideGlyph('spray-can', <DsIconElement>[
    DsIconPathElement('M3 3h.01'), // key: 159qn6
    DsIconPathElement('M7 5h.01'), // key: 1hq22a
    DsIconPathElement('M11 7h.01'), // key: 1osv80
    DsIconPathElement('M3 7h.01'), // key: 1xzrh3
    DsIconPathElement('M7 9h.01'), // key: 19b3jx
    DsIconPathElement('M3 11h.01'), // key: 1eifu7
    DsIconRectElement(15, 5, 4, 4, 0), // key: mri9e4; rx,ry absent
    DsIconPathElement('m19 9 2 2v10c0 .6-.4 1-1 1h-6c-.6 0-1-.4-1-1V11l2-2'), // key: aib6hk
    DsIconPathElement('m13 14 8-2'), // key: 1d7bmk
    DsIconPathElement('m13 19 8-2'), // key: 1y2vml
  ]);

  /// `sprout.mjs`
  static const DsLucideGlyph sprout =
      DsLucideGlyph('sprout', <DsIconElement>[
    DsIconPathElement('M14 9.536V7a4 4 0 0 1 4-4h1.5a.5.5 0 0 1 .5.5V5a4 4 0 0 1-4 4 4 4 0 0 0-4 4c0 2 1 3 1 5a5 5 0 0 1-1 3'), // key: 139s4v
    DsIconPathElement('M4 9a5 5 0 0 1 8 4 5 5 0 0 1-8-4'), // key: 1dlkgp
    DsIconPathElement('M5 21h14'), // key: 11awu3
  ]);

  /// `square-activity.mjs`
  static const DsLucideGlyph squareActivity =
      DsLucideGlyph('square-activity', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M17 12h-2l-2 5-2-10-2 5H7'), // key: 15hlnc
  ]);

  /// `square-arrow-down-left.mjs`
  static const DsLucideGlyph squareArrowDownLeft =
      DsLucideGlyph('square-arrow-down-left', <DsIconElement>[
    DsIconPathElement('M15 15H9l6-6'), // key: 1w52wt
    DsIconPathElement('M9 15V9'), // key: 1kwqze
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `square-arrow-down-right.mjs`
  static const DsLucideGlyph squareArrowDownRight =
      DsLucideGlyph('square-arrow-down-right', <DsIconElement>[
    DsIconPathElement('M15 15 9 9'), // key: qb9ybb
    DsIconPathElement('M9 15h6V9'), // key: 1wezwn
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `square-arrow-down.mjs`
  static const DsLucideGlyph squareArrowDown =
      DsLucideGlyph('square-arrow-down', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M12 8v8'), // key: napkw2
    DsIconPathElement('m8 12 4 4 4-4'), // key: k98ssh
  ]);

  /// `square-arrow-left.mjs`
  static const DsLucideGlyph squareArrowLeft =
      DsLucideGlyph('square-arrow-left', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('m12 8-4 4 4 4'), // key: 15vm53
    DsIconPathElement('M16 12H8'), // key: 1fr5h0
  ]);

  /// `square-arrow-out-down-left.mjs`
  static const DsLucideGlyph squareArrowOutDownLeft =
      DsLucideGlyph('square-arrow-out-down-left', <DsIconElement>[
    DsIconPathElement('M13 21h6a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v6'), // key: 14qz4y
    DsIconPathElement('m3 21 9-9'), // key: 1jfql5
    DsIconPathElement('M9 21H3v-6'), // key: wtvkvv
  ]);

  /// `square-arrow-out-down-right.mjs`
  static const DsLucideGlyph squareArrowOutDownRight =
      DsLucideGlyph('square-arrow-out-down-right', <DsIconElement>[
    DsIconPathElement('M21 11V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h6'), // key: 14rsvq
    DsIconPathElement('m21 21-9-9'), // key: 1et2py
    DsIconPathElement('M21 15v6h-6'), // key: 1jko0i
  ]);

  /// `square-arrow-out-up-left.mjs`
  static const DsLucideGlyph squareArrowOutUpLeft =
      DsLucideGlyph('square-arrow-out-up-left', <DsIconElement>[
    DsIconPathElement('M13 3h6a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-6'), // key: 14mv1t
    DsIconPathElement('m3 3 9 9'), // key: rks13r
    DsIconPathElement('M3 9V3h6'), // key: ira0h2
  ]);

  /// `square-arrow-out-up-right.mjs`
  static const DsLucideGlyph squareArrowOutUpRight =
      DsLucideGlyph('square-arrow-out-up-right', <DsIconElement>[
    DsIconPathElement('M21 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h6'), // key: y09zxi
    DsIconPathElement('m21 3-9 9'), // key: mpx6sq
    DsIconPathElement('M15 3h6v6'), // key: 1q9fwt
  ]);

  /// `square-arrow-right-enter.mjs`
  static const DsLucideGlyph squareArrowRightEnter =
      DsLucideGlyph('square-arrow-right-enter', <DsIconElement>[
    DsIconPathElement('m10 16 4-4-4-4'), // key: w9835o
    DsIconPathElement('M3 12h11'), // key: pmja8f
    DsIconPathElement('M3 8V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-3'), // key: 1bqs5q
  ]);

  /// `square-arrow-right-exit.mjs`
  static const DsLucideGlyph squareArrowRightExit =
      DsLucideGlyph('square-arrow-right-exit', <DsIconElement>[
    DsIconPathElement('M10 12h11'), // key: 6m4ad9
    DsIconPathElement('m17 16 4-4-4-4'), // key: iin4zf
    DsIconPathElement('M21 6.344V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-1.344'), // key: 1ojbhp
  ]);

  /// `square-arrow-right.mjs`
  static const DsLucideGlyph squareArrowRight =
      DsLucideGlyph('square-arrow-right', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M8 12h8'), // key: 1wcyev
    DsIconPathElement('m12 16 4-4-4-4'), // key: 1i9zcv
  ]);

  /// `square-arrow-up-left.mjs`
  static const DsLucideGlyph squareArrowUpLeft =
      DsLucideGlyph('square-arrow-up-left', <DsIconElement>[
    DsIconPathElement('M15 15 9 9'), // key: qb9ybb
    DsIconPathElement('M9 15V9h6'), // key: 1pdr5l
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `square-arrow-up-right.mjs`
  static const DsLucideGlyph squareArrowUpRight =
      DsLucideGlyph('square-arrow-up-right', <DsIconElement>[
    DsIconPathElement('M15 15V9H9'), // key: vxyd2h
    DsIconPathElement('m9 15 6-6'), // key: 1ygkhp
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `square-arrow-up.mjs`
  static const DsLucideGlyph squareArrowUp =
      DsLucideGlyph('square-arrow-up', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('m16 12-4-4-4 4'), // key: 177agl
    DsIconPathElement('M12 16V8'), // key: 1sbj14
  ]);

  /// `square-asterisk.mjs`
  static const DsLucideGlyph squareAsterisk =
      DsLucideGlyph('square-asterisk', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M12 8v8'), // key: napkw2
    DsIconPathElement('m8.5 14 7-4'), // key: 12hpby
    DsIconPathElement('m8.5 10 7 4'), // key: wwy2dy
  ]);

  /// `square-bottom-dashed-scissors.mjs`
  static const DsLucideGlyph squareBottomDashedScissors =
      DsLucideGlyph('square-bottom-dashed-scissors', <DsIconElement>[
    DsIconPathElement('M14 21h1'), // key: v9vybs
    DsIconPathElement('m17 17-2.18-2.18'), // key: 1y7dt1
    DsIconPathElement('M5 21a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v14a2 2 0 01-2 2'), // key: 2q1jq4
    DsIconPathElement('M9 21h1'), // key: 15o7lz
    DsIconPathElement('M9.56 14.44 17 7'), // key: ue8l15
    DsIconPathElement('M9.56 9.56 12 12'), // key: rml9qv
    DsIconCircleElement(8.5, 15.5, 1.5), // key: 12hfy1
    DsIconCircleElement(8.5, 8.5, 1.5), // key: cn5opk
  ]);

  /// `square-centerline-dashed-horizontal.mjs`
  static const DsLucideGlyph squareCenterlineDashedHorizontal =
      DsLucideGlyph('square-centerline-dashed-horizontal', <DsIconElement>[
    DsIconPathElement('M8 3H5a2 2 0 0 0-2 2v14c0 1.1.9 2 2 2h3'), // key: 1i73f7
    DsIconPathElement('M16 3h3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-3'), // key: saxlbk
    DsIconPathElement('M12 20v2'), // key: 1lh1kg
    DsIconPathElement('M12 14v2'), // key: 8jcxud
    DsIconPathElement('M12 8v2'), // key: 1woqiv
    DsIconPathElement('M12 2v2'), // key: tus03m
  ]);

  /// `square-centerline-dashed-vertical.mjs`
  static const DsLucideGlyph squareCenterlineDashedVertical =
      DsLucideGlyph('square-centerline-dashed-vertical', <DsIconElement>[
    DsIconPathElement('M21 8V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v3'), // key: 14bfxa
    DsIconPathElement('M21 16v3a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-3'), // key: 14rx03
    DsIconPathElement('M4 12H2'), // key: rhcxmi
    DsIconPathElement('M10 12H8'), // key: s88cx1
    DsIconPathElement('M16 12h-2'), // key: 10asgb
    DsIconPathElement('M22 12h-2'), // key: 14jgyd
  ]);

  /// `square-chart-gantt.mjs`
  static const DsLucideGlyph squareChartGantt =
      DsLucideGlyph('square-chart-gantt', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M9 8h7'), // key: kbo1nt
    DsIconPathElement('M8 12h6'), // key: ikassy
    DsIconPathElement('M11 16h5'), // key: oq65wt
  ]);

  /// `square-check-big.mjs`
  static const DsLucideGlyph squareCheckBig =
      DsLucideGlyph('square-check-big', <DsIconElement>[
    DsIconPathElement('M21 10.656V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h12.344'), // key: 2acyp4
    DsIconPathElement('m9 11 3 3L22 4'), // key: 1pflzl
  ]);

  /// `square-check.mjs`
  static const DsLucideGlyph squareCheck =
      DsLucideGlyph('square-check', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('m9 12 2 2 4-4'), // key: dzmm74
  ]);

  /// `square-chevron-down.mjs`
  static const DsLucideGlyph squareChevronDown =
      DsLucideGlyph('square-chevron-down', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('m16 10-4 4-4-4'), // key: 894hmk
  ]);

  /// `square-chevron-left.mjs`
  static const DsLucideGlyph squareChevronLeft =
      DsLucideGlyph('square-chevron-left', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('m14 16-4-4 4-4'), // key: ojs7w8
  ]);

  /// `square-chevron-right.mjs`
  static const DsLucideGlyph squareChevronRight =
      DsLucideGlyph('square-chevron-right', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('m10 8 4 4-4 4'), // key: 1wy4r4
  ]);

  /// `square-chevron-up.mjs`
  static const DsLucideGlyph squareChevronUp =
      DsLucideGlyph('square-chevron-up', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('m8 14 4-4 4 4'), // key: fy2ptz
  ]);

  /// `square-code.mjs`
  static const DsLucideGlyph squareCode =
      DsLucideGlyph('square-code', <DsIconElement>[
    DsIconPathElement('m10 9-3 3 3 3'), // key: 1oro0q
    DsIconPathElement('m14 15 3-3-3-3'), // key: bz13h7
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `square-dashed-bottom-code.mjs`
  static const DsLucideGlyph squareDashedBottomCode =
      DsLucideGlyph('square-dashed-bottom-code', <DsIconElement>[
    DsIconPathElement('M10 9.5 8 12l2 2.5'), // key: 3mjy60
    DsIconPathElement('M14 21h1'), // key: v9vybs
    DsIconPathElement('m14 9.5 2 2.5-2 2.5'), // key: 1bir2l
    DsIconPathElement('M5 21a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2'), // key: as5y1o
    DsIconPathElement('M9 21h1'), // key: 15o7lz
  ]);

  /// `square-dashed-bottom.mjs`
  static const DsLucideGlyph squareDashedBottom =
      DsLucideGlyph('square-dashed-bottom', <DsIconElement>[
    DsIconPathElement('M5 21a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2'), // key: as5y1o
    DsIconPathElement('M9 21h1'), // key: 15o7lz
    DsIconPathElement('M14 21h1'), // key: v9vybs
  ]);

  /// `square-dashed-kanban.mjs`
  static const DsLucideGlyph squareDashedKanban =
      DsLucideGlyph('square-dashed-kanban', <DsIconElement>[
    DsIconPathElement('M8 7v7'), // key: 1x2jlm
    DsIconPathElement('M12 7v4'), // key: xawao1
    DsIconPathElement('M16 7v9'), // key: 1hp2iy
    DsIconPathElement('M5 3a2 2 0 0 0-2 2'), // key: y57alp
    DsIconPathElement('M9 3h1'), // key: 1yesri
    DsIconPathElement('M14 3h1'), // key: 1ec4yj
    DsIconPathElement('M19 3a2 2 0 0 1 2 2'), // key: 18rm91
    DsIconPathElement('M21 9v1'), // key: mxsmne
    DsIconPathElement('M21 14v1'), // key: 169vum
    DsIconPathElement('M21 19a2 2 0 0 1-2 2'), // key: 1j7049
    DsIconPathElement('M14 21h1'), // key: v9vybs
    DsIconPathElement('M9 21h1'), // key: 15o7lz
    DsIconPathElement('M5 21a2 2 0 0 1-2-2'), // key: sbafld
    DsIconPathElement('M3 14v1'), // key: vnatye
    DsIconPathElement('M3 9v1'), // key: 1r0deq
  ]);

  /// `square-dashed-mouse-pointer.mjs`
  static const DsLucideGlyph squareDashedMousePointer =
      DsLucideGlyph('square-dashed-mouse-pointer', <DsIconElement>[
    DsIconPathElement('M12.034 12.681a.498.498 0 0 1 .647-.647l9 3.5a.5.5 0 0 1-.033.943l-3.444 1.068a1 1 0 0 0-.66.66l-1.067 3.443a.5.5 0 0 1-.943.033z'), // key: xwnzip
    DsIconPathElement('M5 3a2 2 0 0 0-2 2'), // key: y57alp
    DsIconPathElement('M19 3a2 2 0 0 1 2 2'), // key: 18rm91
    DsIconPathElement('M5 21a2 2 0 0 1-2-2'), // key: sbafld
    DsIconPathElement('M9 3h1'), // key: 1yesri
    DsIconPathElement('M9 21h2'), // key: 1qve2z
    DsIconPathElement('M14 3h1'), // key: 1ec4yj
    DsIconPathElement('M3 9v1'), // key: 1r0deq
    DsIconPathElement('M21 9v2'), // key: p14lih
    DsIconPathElement('M3 14v1'), // key: vnatye
  ]);

  /// `square-dashed-text.mjs`
  static const DsLucideGlyph squareDashedText =
      DsLucideGlyph('square-dashed-text', <DsIconElement>[
    DsIconPathElement('M14 21h1'), // key: v9vybs
    DsIconPathElement('M14 3h1'), // key: 1ec4yj
    DsIconPathElement('M19 3a2 2 0 0 1 2 2'), // key: 18rm91
    DsIconPathElement('M21 14v1'), // key: 169vum
    DsIconPathElement('M21 19a2 2 0 0 1-2 2'), // key: 1j7049
    DsIconPathElement('M21 9v1'), // key: mxsmne
    DsIconPathElement('M3 14v1'), // key: vnatye
    DsIconPathElement('M3 9v1'), // key: 1r0deq
    DsIconPathElement('M5 21a2 2 0 0 1-2-2'), // key: sbafld
    DsIconPathElement('M5 3a2 2 0 0 0-2 2'), // key: y57alp
    DsIconPathElement('M7 12h10'), // key: b7w52i
    DsIconPathElement('M7 16h6'), // key: 1vyc9m
    DsIconPathElement('M7 8h8'), // key: 1jbsf9
    DsIconPathElement('M9 21h1'), // key: 15o7lz
    DsIconPathElement('M9 3h1'), // key: 1yesri
  ]);

  /// `square-dashed-top-solid.mjs`
  static const DsLucideGlyph squareDashedTopSolid =
      DsLucideGlyph('square-dashed-top-solid', <DsIconElement>[
    DsIconPathElement('M14 21h1'), // key: v9vybs
    DsIconPathElement('M21 14v1'), // key: 169vum
    DsIconPathElement('M21 19a2 2 0 0 1-2 2'), // key: 1j7049
    DsIconPathElement('M21 9v1'), // key: mxsmne
    DsIconPathElement('M3 14v1'), // key: vnatye
    DsIconPathElement('M3 5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2'), // key: 89voep
    DsIconPathElement('M3 9v1'), // key: 1r0deq
    DsIconPathElement('M5 21a2 2 0 0 1-2-2'), // key: sbafld
    DsIconPathElement('M9 21h1'), // key: 15o7lz
  ]);

  /// `square-dashed.mjs`
  static const DsLucideGlyph squareDashed =
      DsLucideGlyph('square-dashed', <DsIconElement>[
    DsIconPathElement('M5 3a2 2 0 0 0-2 2'), // key: y57alp
    DsIconPathElement('M19 3a2 2 0 0 1 2 2'), // key: 18rm91
    DsIconPathElement('M21 19a2 2 0 0 1-2 2'), // key: 1j7049
    DsIconPathElement('M5 21a2 2 0 0 1-2-2'), // key: sbafld
    DsIconPathElement('M9 3h1'), // key: 1yesri
    DsIconPathElement('M9 21h1'), // key: 15o7lz
    DsIconPathElement('M14 3h1'), // key: 1ec4yj
    DsIconPathElement('M14 21h1'), // key: v9vybs
    DsIconPathElement('M3 9v1'), // key: 1r0deq
    DsIconPathElement('M21 9v1'), // key: mxsmne
    DsIconPathElement('M3 14v1'), // key: vnatye
    DsIconPathElement('M21 14v1'), // key: 169vum
  ]);

  /// `square-divide.mjs`
  static const DsLucideGlyph squareDivide =
      DsLucideGlyph('square-divide', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    DsIconLineElement(8, 12, 16, 12), // key: 1jonct
    DsIconLineElement(12, 16, 12, 16), // key: aqc6ln
    DsIconLineElement(12, 8, 12, 8), // key: 1mkcni
  ]);

  /// `square-dot.mjs`
  static const DsLucideGlyph squareDot =
      DsLucideGlyph('square-dot', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconCircleElement(12, 12, 1), // key: 41hilf
  ]);

  /// `square-equal.mjs`
  static const DsLucideGlyph squareEqual =
      DsLucideGlyph('square-equal', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M7 10h10'), // key: 1101jm
    DsIconPathElement('M7 14h10'), // key: 1mhdw3
  ]);

  /// `square-function.mjs`
  static const DsLucideGlyph squareFunction =
      DsLucideGlyph('square-function', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    DsIconPathElement('M9 17c2 0 2.8-1 2.8-2.8V10c0-2 1-3.3 3.2-3'), // key: m1af9g
    DsIconPathElement('M9 11.2h5.7'), // key: 3zgcl2
  ]);

  /// `square-kanban.mjs`
  static const DsLucideGlyph squareKanban =
      DsLucideGlyph('square-kanban', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M8 7v7'), // key: 1x2jlm
    DsIconPathElement('M12 7v4'), // key: xawao1
    DsIconPathElement('M16 7v9'), // key: 1hp2iy
  ]);

  /// `square-library.mjs`
  static const DsLucideGlyph squareLibrary =
      DsLucideGlyph('square-library', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M7 7v10'), // key: d5nglc
    DsIconPathElement('M11 7v10'), // key: pptsnr
    DsIconPathElement('m15 7 2 10'), // key: 1m7qm5
  ]);

  /// `square-m.mjs`
  static const DsLucideGlyph squareM =
      DsLucideGlyph('square-m', <DsIconElement>[
    DsIconPathElement('M8 16V8.5a.5.5 0 0 1 .9-.3l2.7 3.599a.5.5 0 0 0 .8 0l2.7-3.6a.5.5 0 0 1 .9.3V16'), // key: 1ywlsj
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `square-menu.mjs`
  static const DsLucideGlyph squareMenu =
      DsLucideGlyph('square-menu', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M7 8h10'), // key: 1jw688
    DsIconPathElement('M7 12h10'), // key: b7w52i
    DsIconPathElement('M7 16h10'), // key: wp8him
  ]);

  /// `square-minus.mjs`
  static const DsLucideGlyph squareMinus =
      DsLucideGlyph('square-minus', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M8 12h8'), // key: 1wcyev
  ]);

  /// `square-mouse-pointer.mjs`
  static const DsLucideGlyph squareMousePointer =
      DsLucideGlyph('square-mouse-pointer', <DsIconElement>[
    DsIconPathElement('M12.034 12.681a.498.498 0 0 1 .647-.647l9 3.5a.5.5 0 0 1-.033.943l-3.444 1.068a1 1 0 0 0-.66.66l-1.067 3.443a.5.5 0 0 1-.943.033z'), // key: xwnzip
    DsIconPathElement('M21 11V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h6'), // key: 14rsvq
  ]);

  /// `square-off.mjs`
  static const DsLucideGlyph squareOff =
      DsLucideGlyph('square-off', <DsIconElement>[
    DsIconPathElement('M20.4 20.4a2 2 0 01-1.4.6H5a2 2 0 01-2-2V5a2 2 0 01.59-1.41'), // key: 7ym6nm
    DsIconPathElement('M21 15.3V5a2 2 0 00-2-2H8.7'), // key: m4nk5y
    DsIconPathElement('M22 22 2 2'), // key: 1r8tn9
  ]);

  /// `square-parking-off.mjs`
  static const DsLucideGlyph squareParkingOff =
      DsLucideGlyph('square-parking-off', <DsIconElement>[
    DsIconPathElement('M3.6 3.6A2 2 0 0 1 5 3h14a2 2 0 0 1 2 2v14a2 2 0 0 1-.59 1.41'), // key: 9l1ft6
    DsIconPathElement('M3 8.7V19a2 2 0 0 0 2 2h10.3'), // key: 17knke
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M13 13a3 3 0 1 0 0-6H9v2'), // key: uoagbd
    DsIconPathElement('M9 17v-2.3'), // key: 1jxgo2
  ]);

  /// `square-parking.mjs`
  static const DsLucideGlyph squareParking =
      DsLucideGlyph('square-parking', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M9 17V7h4a3 3 0 0 1 0 6H9'), // key: 1dfk2c
  ]);

  /// `square-pause.mjs`
  static const DsLucideGlyph squarePause =
      DsLucideGlyph('square-pause', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconLineElement(10, 15, 10, 9), // key: c1nkhi
    DsIconLineElement(14, 15, 14, 9), // key: h65svq
  ]);

  /// `square-pen.mjs`
  static const DsLucideGlyph squarePen =
      DsLucideGlyph('square-pen', <DsIconElement>[
    DsIconPathElement('M12 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7'), // key: 1m0v6g
    DsIconPathElement('M18.375 2.625a1 1 0 0 1 3 3l-9.013 9.014a2 2 0 0 1-.853.505l-2.873.84a.5.5 0 0 1-.62-.62l.84-2.873a2 2 0 0 1 .506-.852z'), // key: ohrbg2
  ]);

  /// `square-percent.mjs`
  static const DsLucideGlyph squarePercent =
      DsLucideGlyph('square-percent', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('m15 9-6 6'), // key: 1uzhvr
    DsIconPathElement('M9 9h.01'), // key: 1q5me6
    DsIconPathElement('M15 15h.01'), // key: lqbp3k
  ]);

  /// `square-pi.mjs`
  static const DsLucideGlyph squarePi =
      DsLucideGlyph('square-pi', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M7 7h10'), // key: udp07y
    DsIconPathElement('M10 7v10'), // key: i1d9ee
    DsIconPathElement('M16 17a2 2 0 0 1-2-2V7'), // key: ftwdc7
  ]);

  /// `square-pilcrow.mjs`
  static const DsLucideGlyph squarePilcrow =
      DsLucideGlyph('square-pilcrow', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M12 12H9.5a2.5 2.5 0 0 1 0-5H17'), // key: 1l9586
    DsIconPathElement('M12 7v10'), // key: jspqdw
    DsIconPathElement('M16 7v10'), // key: lavkr4
  ]);

  /// `square-play.mjs`
  static const DsLucideGlyph squarePlay =
      DsLucideGlyph('square-play', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    DsIconPathElement('M9 9.003a1 1 0 0 1 1.517-.859l4.997 2.997a1 1 0 0 1 0 1.718l-4.997 2.997A1 1 0 0 1 9 14.996z'), // key: kmsa83
  ]);

  /// `square-plus.mjs`
  static const DsLucideGlyph squarePlus =
      DsLucideGlyph('square-plus', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M8 12h8'), // key: 1wcyev
    DsIconPathElement('M12 8v8'), // key: napkw2
  ]);

  /// `square-power.mjs`
  static const DsLucideGlyph squarePower =
      DsLucideGlyph('square-power', <DsIconElement>[
    DsIconPathElement('M12 7v4'), // key: xawao1
    DsIconPathElement('M7.998 9.003a5 5 0 1 0 8-.005'), // key: 1pek45
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `square-radical.mjs`
  static const DsLucideGlyph squareRadical =
      DsLucideGlyph('square-radical', <DsIconElement>[
    DsIconPathElement('M7 12h2l2 5 2-10h4'), // key: 1fxv6h
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `square-round-corner.mjs`
  static const DsLucideGlyph squareRoundCorner =
      DsLucideGlyph('square-round-corner', <DsIconElement>[
    DsIconPathElement('M21 11a8 8 0 0 0-8-8'), // key: 1lxwo5
    DsIconPathElement('M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4'), // key: 1dv2y5
  ]);

  /// `square-scissors.mjs`
  static const DsLucideGlyph squareScissors =
      DsLucideGlyph('square-scissors', <DsIconElement>[
    DsIconPathElement('m17 17-2.18-2.18'), // key: 1y7dt1
    DsIconPathElement('M9.56 14.44 17 7'), // key: ue8l15
    DsIconPathElement('M9.56 9.56 12 12'), // key: rml9qv
    DsIconCircleElement(8.5, 15.5, 1.5), // key: 12hfy1
    DsIconCircleElement(8.5, 8.5, 1.5), // key: cn5opk
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `square-sigma.mjs`
  static const DsLucideGlyph squareSigma =
      DsLucideGlyph('square-sigma', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M16 8.9V7H8l4 5-4 5h8v-1.9'), // key: 9nih0i
  ]);

  /// `square-slash.mjs`
  static const DsLucideGlyph squareSlash =
      DsLucideGlyph('square-slash', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconLineElement(9, 15, 15, 9), // key: 1dfufj
  ]);

  /// `square-split-horizontal.mjs`
  static const DsLucideGlyph squareSplitHorizontal =
      DsLucideGlyph('square-split-horizontal', <DsIconElement>[
    DsIconPathElement('M8 19H5c-1 0-2-1-2-2V7c0-1 1-2 2-2h3'), // key: lubmu8
    DsIconPathElement('M16 5h3c1 0 2 1 2 2v10c0 1-1 2-2 2h-3'), // key: 1ag34g
    DsIconLineElement(12, 4, 12, 20), // key: 1tx1rr
  ]);

  /// `square-split-vertical.mjs`
  static const DsLucideGlyph squareSplitVertical =
      DsLucideGlyph('square-split-vertical', <DsIconElement>[
    DsIconPathElement('M5 8V5c0-1 1-2 2-2h10c1 0 2 1 2 2v3'), // key: 1pi83i
    DsIconPathElement('M19 16v3c0 1-1 2-2 2H7c-1 0-2-1-2-2v-3'), // key: ido5k7
    DsIconLineElement(4, 12, 20, 12), // key: 1e0a9i
  ]);

  /// `square-square.mjs`
  static const DsLucideGlyph squareSquare =
      DsLucideGlyph('square-square', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
    DsIconRectElement(8, 8, 8, 8, 1), // key: z9xiuo
  ]);

  /// `square-stack.mjs`
  static const DsLucideGlyph squareStack =
      DsLucideGlyph('square-stack', <DsIconElement>[
    DsIconPathElement('M4 10c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h4c1.1 0 2 .9 2 2'), // key: 4i38lg
    DsIconPathElement('M10 16c-1.1 0-2-.9-2-2v-4c0-1.1.9-2 2-2h4c1.1 0 2 .9 2 2'), // key: mlte4a
    DsIconRectElement(14, 14, 8, 8, 2), // key: 1fa9i4
  ]);

  /// `square-star.mjs`
  static const DsLucideGlyph squareStar =
      DsLucideGlyph('square-star', <DsIconElement>[
    DsIconPathElement('M11.035 7.69a1 1 0 0 1 1.909.024l.737 1.452a1 1 0 0 0 .737.535l1.634.256a1 1 0 0 1 .588 1.806l-1.172 1.168a1 1 0 0 0-.282.866l.259 1.613a1 1 0 0 1-1.541 1.134l-1.465-.75a1 1 0 0 0-.912 0l-1.465.75a1 1 0 0 1-1.539-1.133l.258-1.613a1 1 0 0 0-.282-.866l-1.156-1.153a1 1 0 0 1 .572-1.822l1.633-.256a1 1 0 0 0 .737-.535z'), // key: 13edca
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `square-stop.mjs`
  static const DsLucideGlyph squareStop =
      DsLucideGlyph('square-stop', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconRectElement(9, 9, 6, 6, 1), // key: 1ssd4o
  ]);

  /// `square-terminal.mjs`
  static const DsLucideGlyph squareTerminal =
      DsLucideGlyph('square-terminal', <DsIconElement>[
    DsIconPathElement('m7 11 2-2-2-2'), // key: 1lz0vl
    DsIconPathElement('M11 13h4'), // key: 1p7l4v
    DsIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
  ]);

  /// `square-user-round.mjs`
  static const DsLucideGlyph squareUserRound =
      DsLucideGlyph('square-user-round', <DsIconElement>[
    DsIconPathElement('M18 21a6 6 0 0 0-12 0'), // key: kaz2du
    DsIconCircleElement(12, 11, 4), // key: 1gt34v
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
  ]);

  /// `square-user.mjs`
  static const DsLucideGlyph squareUser =
      DsLucideGlyph('square-user', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconCircleElement(12, 10, 3), // key: ilqhr7
    DsIconPathElement('M7 21v-2a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v2'), // key: 1m6ac2
  ]);

  /// `square-x.mjs`
  static const DsLucideGlyph squareX =
      DsLucideGlyph('square-x', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2, ry: 2), // key: 1m3agn
    DsIconPathElement('m15 9-6 6'), // key: 1uzhvr
    DsIconPathElement('m9 9 6 6'), // key: z0biqf
  ]);

  /// `square.mjs`
  static const DsLucideGlyph square =
      DsLucideGlyph('square', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
  ]);

  /// `squares-exclude.mjs`
  static const DsLucideGlyph squaresExclude =
      DsLucideGlyph('squares-exclude', <DsIconElement>[
    DsIconPathElement('M16 12v2a2 2 0 0 1-2 2H9a1 1 0 0 0-1 1v3a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V10a2 2 0 0 0-2-2h0'), // key: 1mcohs
    DsIconPathElement('M4 16a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v3a1 1 0 0 1-1 1h-5a2 2 0 0 0-2 2v2'), // key: 1r1efp
  ]);

  /// `squares-intersect.mjs`
  static const DsLucideGlyph squaresIntersect =
      DsLucideGlyph('squares-intersect', <DsIconElement>[
    DsIconPathElement('M10 22a2 2 0 0 1-2-2'), // key: i7yj1i
    DsIconPathElement('M14 2a2 2 0 0 1 2 2'), // key: 170a0m
    DsIconPathElement('M16 22h-2'), // key: 18d249
    DsIconPathElement('M2 10V8'), // key: 7yj4fe
    DsIconPathElement('M2 4a2 2 0 0 1 2-2'), // key: ddgnws
    DsIconPathElement('M20 8a2 2 0 0 1 2 2'), // key: 1770vt
    DsIconPathElement('M22 14v2'), // key: iot8ja
    DsIconPathElement('M22 20a2 2 0 0 1-2 2'), // key: qj8q6g
    DsIconPathElement('M4 16a2 2 0 0 1-2-2'), // key: 1dnafg
    DsIconPathElement('M8 10a2 2 0 0 1 2-2h5a1 1 0 0 1 1 1v5a2 2 0 0 1-2 2H9a1 1 0 0 1-1-1z'), // key: ci6f0b
    DsIconPathElement('M8 2h2'), // key: 1gmkwm
  ]);

  /// `squares-subtract.mjs`
  static const DsLucideGlyph squaresSubtract =
      DsLucideGlyph('squares-subtract', <DsIconElement>[
    DsIconPathElement('M10 22a2 2 0 0 1-2-2'), // key: i7yj1i
    DsIconPathElement('M16 22h-2'), // key: 18d249
    DsIconPathElement('M16 4a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h3a1 1 0 0 0 1-1v-5a2 2 0 0 1 2-2h5a1 1 0 0 0 1-1z'), // key: 1njgbb
    DsIconPathElement('M20 8a2 2 0 0 1 2 2'), // key: 1770vt
    DsIconPathElement('M22 14v2'), // key: iot8ja
    DsIconPathElement('M22 20a2 2 0 0 1-2 2'), // key: qj8q6g
  ]);

  /// `squares-unite.mjs`
  static const DsLucideGlyph squaresUnite =
      DsLucideGlyph('squares-unite', <DsIconElement>[
    DsIconPathElement('M4 16a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v3a1 1 0 0 0 1 1h3a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H10a2 2 0 0 1-2-2v-3a1 1 0 0 0-1-1z'), // key: 17jnth
  ]);

  /// `squircle-dashed.mjs`
  static const DsLucideGlyph squircleDashed =
      DsLucideGlyph('squircle-dashed', <DsIconElement>[
    DsIconPathElement('M13.77 3.043a34 34 0 0 0-3.54 0'), // key: 1oaobr
    DsIconPathElement('M13.771 20.956a33 33 0 0 1-3.541.001'), // key: 95iq0j
    DsIconPathElement('M20.18 17.74c-.51 1.15-1.29 1.93-2.439 2.44'), // key: 1u6qty
    DsIconPathElement('M20.18 6.259c-.51-1.148-1.291-1.929-2.44-2.438'), // key: 1ew6g6
    DsIconPathElement('M20.957 10.23a33 33 0 0 1 0 3.54'), // key: 1l9npr
    DsIconPathElement('M3.043 10.23a34 34 0 0 0 .001 3.541'), // key: 1it6jm
    DsIconPathElement('M6.26 20.179c-1.15-.508-1.93-1.29-2.44-2.438'), // key: 14uchd
    DsIconPathElement('M6.26 3.82c-1.149.51-1.93 1.291-2.44 2.44'), // key: 8k4agb
  ]);

  /// `squircle.mjs`
  static const DsLucideGlyph squircle =
      DsLucideGlyph('squircle', <DsIconElement>[
    DsIconPathElement('M12 3c7.2 0 9 1.8 9 9s-1.8 9-9 9-9-1.8-9-9 1.8-9 9-9'), // key: garfkc
  ]);

  /// `squirrel.mjs`
  static const DsLucideGlyph squirrel =
      DsLucideGlyph('squirrel', <DsIconElement>[
    DsIconPathElement('M15.236 22a3 3 0 0 0-2.2-5'), // key: 21bitc
    DsIconPathElement('M16 20a3 3 0 0 1 3-3h1a2 2 0 0 0 2-2v-2a4 4 0 0 0-4-4V4'), // key: oh0fg0
    DsIconPathElement('M18 13h.01'), // key: 9veqaj
    DsIconPathElement('M18 6a4 4 0 0 0-4 4 7 7 0 0 0-7 7c0-5 4-5 4-10.5a4.5 4.5 0 1 0-9 0 2.5 2.5 0 0 0 5 0C7 10 3 11 3 17c0 2.8 2.2 5 5 5h10'), // key: 980v8a
  ]);

  /// `stamp.mjs`
  static const DsLucideGlyph stamp =
      DsLucideGlyph('stamp', <DsIconElement>[
    DsIconPathElement('M14 13V8.5C14 7 15 7 15 5a3 3 0 0 0-6 0c0 2 1 2 1 3.5V13'), // key: i9gjdv
    DsIconPathElement('M20 15.5a2.5 2.5 0 0 0-2.5-2.5h-11A2.5 2.5 0 0 0 4 15.5V17a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1z'), // key: 1vzg3v
    DsIconPathElement('M5 22h14'), // key: ehvnwv
  ]);

  /// `star-check.mjs`
  static const DsLucideGlyph starCheck =
      DsLucideGlyph('star-check', <DsIconElement>[
    DsIconPathElement('m19.06 12.501 2.78-2.707a.53.53 0 0 0-.294-.905l-5.166-.755a2.1 2.1 0 0 1-1.595-1.16l-2.31-4.68a.53.53 0 0 0-.95.001L9.216 6.974a2.1 2.1 0 0 1-1.597 1.16l-5.165.755a.53.53 0 0 0-.294.906l3.736 3.637a2.1 2.1 0 0 1 .611 1.879l-.88 5.139a.53.53 0 0 0 .769.56l4.617-2.428.027-.014'), // key: 14g7km
    DsIconPathElement('m15 18 2 2 4-4'), // key: 1szwhi
  ]);

  /// `star-half.mjs`
  static const DsLucideGlyph starHalf =
      DsLucideGlyph('star-half', <DsIconElement>[
    DsIconPathElement('M12 18.338a2.1 2.1 0 0 0-.987.244L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.12 2.12 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.12 2.12 0 0 0 1.597-1.16l2.309-4.679A.53.53 0 0 1 12 2'), // key: 2ksp49
  ]);

  /// `star-minus.mjs`
  static const DsLucideGlyph starMinus =
      DsLucideGlyph('star-minus', <DsIconElement>[
    DsIconPathElement('M15 18h6'), // key: 3b3c90
    DsIconPathElement('M17.688 14a2.1 2.1 0 0 1 .416-.568l3.736-3.638a.53.53 0 0 0-.294-.905l-5.166-.755a2.1 2.1 0 0 1-1.595-1.16l-2.31-4.68a.53.53 0 0 0-.95.001L9.216 6.974a2.1 2.1 0 0 1-1.597 1.16l-5.165.755a.53.53 0 0 0-.294.906l3.736 3.637a2.1 2.1 0 0 1 .611 1.879l-.88 5.139a.53.53 0 0 0 .769.56l4.617-2.428.027-.014'), // key: rwo527
  ]);

  /// `star-off.mjs`
  static const DsLucideGlyph starOff =
      DsLucideGlyph('star-off', <DsIconElement>[
    DsIconPathElement('m10.344 4.688 1.181-2.393a.53.53 0 0 1 .95 0l2.31 4.679a2.12 2.12 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.237 3.152'), // key: 19ctli
    DsIconPathElement('m17.945 17.945.43 2.505a.53.53 0 0 1-.771.56l-4.618-2.428a2.12 2.12 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.12 2.12 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a8 8 0 0 0 .4-.099'), // key: ptqqvy
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `star-plus.mjs`
  static const DsLucideGlyph starPlus =
      DsLucideGlyph('star-plus', <DsIconElement>[
    DsIconPathElement('M11.013 18.582 6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.12 2.12 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.12 2.12 0 0 0 1.597-1.16l2.309-4.679a.53.53 0 0 1 .95 0l2.31 4.679a2.12 2.12 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904L20 11.5'), // key: 1hs8rk
    DsIconPathElement('M15 18h6'), // key: 3b3c90
    DsIconPathElement('M18 15v6'), // key: 9wciyi
  ]);

  /// `star-x.mjs`
  static const DsLucideGlyph starX =
      DsLucideGlyph('star-x', <DsIconElement>[
    DsIconPathElement('m15.5 15.5 5 5'), // key: 1ky94l
    DsIconPathElement('m20.063 11.525 1.777-1.731a.53.53 0 0 0-.294-.905l-5.166-.755a2.1 2.1 0 0 1-1.595-1.16l-2.31-4.68a.53.53 0 0 0-.95.001L9.216 6.974a2.1 2.1 0 0 1-1.597 1.16l-5.165.755a.53.53 0 0 0-.294.906l3.736 3.637a2.1 2.1 0 0 1 .611 1.879l-.88 5.139a.53.53 0 0 0 .769.56l4.617-2.428a2.1 2.1 0 0 1 .987-.243 2 2 0 0 1 .132.004'), // key: 6uuto3
    DsIconPathElement('m20.5 15.5-5 5'), // key: 1w5am3
  ]);

  /// `star.mjs`
  static const DsLucideGlyph star =
      DsLucideGlyph('star', <DsIconElement>[
    DsIconPathElement('M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z'), // key: r04s7s
  ]);

  /// `step-back.mjs`
  static const DsLucideGlyph stepBack =
      DsLucideGlyph('step-back', <DsIconElement>[
    DsIconPathElement('M13.971 4.285A2 2 0 0 1 17 6v12a2 2 0 0 1-3.029 1.715l-9.997-5.998a2 2 0 0 1-.003-3.432z'), // key: 19qhus
    DsIconPathElement('M21 20V4'), // key: cb8qj8
  ]);

  /// `step-forward.mjs`
  static const DsLucideGlyph stepForward =
      DsLucideGlyph('step-forward', <DsIconElement>[
    DsIconPathElement('M10.029 4.285A2 2 0 0 0 7 6v12a2 2 0 0 0 3.029 1.715l9.997-5.998a2 2 0 0 0 .003-3.432z'), // key: 1ystz2
    DsIconPathElement('M3 4v16'), // key: 1ph11n
  ]);

  /// `stethoscope.mjs`
  static const DsLucideGlyph stethoscope =
      DsLucideGlyph('stethoscope', <DsIconElement>[
    DsIconPathElement('M11 2v2'), // key: 1539x4
    DsIconPathElement('M5 2v2'), // key: 1yf1q8
    DsIconPathElement('M5 3H4a2 2 0 0 0-2 2v4a6 6 0 0 0 12 0V5a2 2 0 0 0-2-2h-1'), // key: rb5t3r
    DsIconPathElement('M8 15a6 6 0 0 0 12 0v-3'), // key: x18d4x
    DsIconCircleElement(20, 10, 2), // key: ts1r5v
  ]);

  /// `sticker.mjs`
  static const DsLucideGlyph sticker =
      DsLucideGlyph('sticker', <DsIconElement>[
    DsIconPathElement('M21 9a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 15 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2z'), // key: 1dfntj
    DsIconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
    DsIconPathElement('M8 13h.01'), // key: 1sbv64
    DsIconPathElement('M16 13h.01'), // key: wip0gl
    DsIconPathElement('M10 16s.8 1 2 1c1.3 0 2-1 2-1'), // key: 1vvgv3
  ]);

  /// `sticky-note-check.mjs`
  static const DsLucideGlyph stickyNoteCheck =
      DsLucideGlyph('sticky-note-check', <DsIconElement>[
    DsIconPathElement('m15 19 2 2 4-4'), // key: 1wqv71
    DsIconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
    DsIconPathElement('M21 13V9a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 15 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h6.5'), // key: 1onoss
  ]);

  /// `sticky-note-minus.mjs`
  static const DsLucideGlyph stickyNoteMinus =
      DsLucideGlyph('sticky-note-minus', <DsIconElement>[
    DsIconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
    DsIconPathElement('M21 14V9a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 15 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h7.35'), // key: g18rj4
    DsIconPathElement('M21 18h-6'), // key: 139f0c
  ]);

  /// `sticky-note-off.mjs`
  static const DsLucideGlyph stickyNoteOff =
      DsLucideGlyph('sticky-note-off', <DsIconElement>[
    DsIconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M3.586 3.586A2 2 0 0 0 3 5v14a2 2 0 0 0 2 2h14a2 2 0 0 0 1.414-.586'), // key: 12nghy
    DsIconPathElement('M8.656 3H15a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 21 9v6.344'), // key: 134c6x
  ]);

  /// `sticky-note-plus.mjs`
  static const DsLucideGlyph stickyNotePlus =
      DsLucideGlyph('sticky-note-plus', <DsIconElement>[
    DsIconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
    DsIconPathElement('M18 15v6'), // key: 9wciyi
    DsIconPathElement('M21 12.356V9a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 15 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h7.355'), // key: 12ish9
    DsIconPathElement('M21 18h-6'), // key: 139f0c
  ]);

  /// `sticky-note-x.mjs`
  static const DsLucideGlyph stickyNoteX =
      DsLucideGlyph('sticky-note-x', <DsIconElement>[
    DsIconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
    DsIconPathElement('m16 16 5 5'), // key: 8tpb07
    DsIconPathElement('M21 12V9a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 15 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h7'), // key: 156tez
    DsIconPathElement('m21 16-5 5'), // key: kplof2
  ]);

  /// `sticky-note.mjs`
  static const DsLucideGlyph stickyNote =
      DsLucideGlyph('sticky-note', <DsIconElement>[
    DsIconPathElement('M21 9a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 15 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2z'), // key: 1dfntj
    DsIconPathElement('M15 3v5a1 1 0 0 0 1 1h5'), // key: 6s6qgf
  ]);

  /// `sticky-notes.mjs`
  static const DsLucideGlyph stickyNotes =
      DsLucideGlyph('sticky-notes', <DsIconElement>[
    DsIconPathElement('M10 8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 16 14v6a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V10a2 2 0 0 1 2-2z'), // key: 19nc0g
    DsIconPathElement('M10 8v5a1 1 0 0 0 1 1h5'), // key: m3law1
    DsIconPathElement('M8 4a2 2 0 0 1 2-2h6a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 22 8v6a2 2 0 0 1-2 2'), // key: 1iu1qd
    DsIconPathElement('M16 2v5a1 1 0 0 0 1 1h5'), // key: af171p
  ]);

  /// `stone.mjs`
  static const DsLucideGlyph stone =
      DsLucideGlyph('stone', <DsIconElement>[
    DsIconPathElement('M11.264 2.205A4 4 0 0 0 6.42 4.211l-4 8a4 4 0 0 0 1.359 5.117l6 4a4 4 0 0 0 4.438 0l6-4a4 4 0 0 0 1.576-4.592l-2-6a4 4 0 0 0-2.53-2.53z'), // key: 1si4ox
    DsIconPathElement('M11.99 22 14 12l7.822 3.184'), // key: 1u8to0
    DsIconPathElement('M14 12 8.47 2.302'), // key: guo3d5
  ]);

  /// `store.mjs`
  static const DsLucideGlyph store =
      DsLucideGlyph('store', <DsIconElement>[
    DsIconPathElement('M15 21v-5a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v5'), // key: slp6dd
    DsIconPathElement('M17.774 10.31a1.12 1.12 0 0 0-1.549 0 2.5 2.5 0 0 1-3.451 0 1.12 1.12 0 0 0-1.548 0 2.5 2.5 0 0 1-3.452 0 1.12 1.12 0 0 0-1.549 0 2.5 2.5 0 0 1-3.77-3.248l2.889-4.184A2 2 0 0 1 7 2h10a2 2 0 0 1 1.653.873l2.895 4.192a2.5 2.5 0 0 1-3.774 3.244'), // key: o0xfot
    DsIconPathElement('M4 10.95V19a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8.05'), // key: wn3emo
  ]);

  /// `stretch-horizontal.mjs`
  static const DsLucideGlyph stretchHorizontal =
      DsLucideGlyph('stretch-horizontal', <DsIconElement>[
    DsIconRectElement(2, 4, 20, 6, 2), // key: qdearl
    DsIconRectElement(2, 14, 20, 6, 2), // key: 1xrn6j
  ]);

  /// `stretch-vertical.mjs`
  static const DsLucideGlyph stretchVertical =
      DsLucideGlyph('stretch-vertical', <DsIconElement>[
    DsIconRectElement(4, 2, 6, 20, 2), // key: 19qu7m
    DsIconRectElement(14, 2, 6, 20, 2), // key: 24v0nk
  ]);

  /// `strikethrough.mjs`
  static const DsLucideGlyph strikethrough =
      DsLucideGlyph('strikethrough', <DsIconElement>[
    DsIconPathElement('M16 4H9a3 3 0 0 0-2.83 4'), // key: 43sutm
    DsIconPathElement('M14 12a4 4 0 0 1 0 8H6'), // key: nlfj13
    DsIconLineElement(4, 12, 20, 12), // key: 1e0a9i
  ]);

  /// `subscript.mjs`
  static const DsLucideGlyph subscript =
      DsLucideGlyph('subscript', <DsIconElement>[
    DsIconPathElement('m4 5 8 8'), // key: 1eunvl
    DsIconPathElement('m12 5-8 8'), // key: 1ah0jp
    DsIconPathElement('M20 19h-4c0-1.5.44-2 1.5-2.5S20 15.33 20 14c0-.47-.17-.93-.48-1.29a2.11 2.11 0 0 0-2.62-.44c-.42.24-.74.62-.9 1.07'), // key: e8ta8j
  ]);

  /// `summary.mjs`
  static const DsLucideGlyph summary =
      DsLucideGlyph('summary', <DsIconElement>[
    DsIconPathElement('M15 4H7'), // key: oyc4c8
    DsIconPathElement('m18 16 3 3-3 3'), // key: 1d4glt
    DsIconPathElement('M3 4v13a2 2 0 0 0 2 2h16'), // key: o3n0ii
    DsIconPathElement('M7 14h7'), // key: 16kgpy
    DsIconPathElement('M7 9h12'), // key: ihq7ma
  ]);

  /// `sun-dim.mjs`
  static const DsLucideGlyph sunDim =
      DsLucideGlyph('sun-dim', <DsIconElement>[
    DsIconCircleElement(12, 12, 4), // key: 4exip2
    DsIconPathElement('M12 4h.01'), // key: 1ujb9j
    DsIconPathElement('M20 12h.01'), // key: 1ykeid
    DsIconPathElement('M12 20h.01'), // key: zekei9
    DsIconPathElement('M4 12h.01'), // key: 158zrr
    DsIconPathElement('M17.657 6.343h.01'), // key: 31pqzk
    DsIconPathElement('M17.657 17.657h.01'), // key: jehnf4
    DsIconPathElement('M6.343 17.657h.01'), // key: gdk6ow
    DsIconPathElement('M6.343 6.343h.01'), // key: 1uurf0
  ]);

  /// `sun-medium.mjs`
  static const DsLucideGlyph sunMedium =
      DsLucideGlyph('sun-medium', <DsIconElement>[
    DsIconCircleElement(12, 12, 4), // key: 4exip2
    DsIconPathElement('M12 3v1'), // key: 1asbbs
    DsIconPathElement('M12 20v1'), // key: 1wcdkc
    DsIconPathElement('M3 12h1'), // key: lp3yf2
    DsIconPathElement('M20 12h1'), // key: 1vloll
    DsIconPathElement('m18.364 5.636-.707.707'), // key: 1hakh0
    DsIconPathElement('m6.343 17.657-.707.707'), // key: 18m9nf
    DsIconPathElement('m5.636 5.636.707.707'), // key: 1xv1c5
    DsIconPathElement('m17.657 17.657.707.707'), // key: vl76zb
  ]);

  /// `sun-moon.mjs`
  static const DsLucideGlyph sunMoon =
      DsLucideGlyph('sun-moon', <DsIconElement>[
    DsIconPathElement('M12 2v2'), // key: tus03m
    DsIconPathElement('M14.837 16.385a6 6 0 1 1-7.223-7.222c.624-.147.97.66.715 1.248a4 4 0 0 0 5.26 5.259c.589-.255 1.396.09 1.248.715'), // key: xlf6rm
    DsIconPathElement('M16 12a4 4 0 0 0-4-4'), // key: 6vsxu
    DsIconPathElement('m19 5-1.256 1.256'), // key: 1yg6a6
    DsIconPathElement('M20 12h2'), // key: 1q8mjw
  ]);

  /// `sun-snow.mjs`
  static const DsLucideGlyph sunSnow =
      DsLucideGlyph('sun-snow', <DsIconElement>[
    DsIconPathElement('M10 21v-1'), // key: 1u8rkd
    DsIconPathElement('M10 4V3'), // key: pkzwkn
    DsIconPathElement('M10 9a3 3 0 0 0 0 6'), // key: gv75dk
    DsIconPathElement('m14 20 1.25-2.5L18 18'), // key: 1chtki
    DsIconPathElement('m14 4 1.25 2.5L18 6'), // key: 1b4wsy
    DsIconPathElement('m17 21-3-6 1.5-3H22'), // key: o5qa3v
    DsIconPathElement('m17 3-3 6 1.5 3'), // key: 11697g
    DsIconPathElement('M2 12h1'), // key: 1uaihz
    DsIconPathElement('m20 10-1.5 2 1.5 2'), // key: 1swlpi
    DsIconPathElement('m3.64 18.36.7-.7'), // key: 105rm9
    DsIconPathElement('m4.34 6.34-.7-.7'), // key: d3unjp
  ]);

  /// `sun.mjs`
  static const DsLucideGlyph sun =
      DsLucideGlyph('sun', <DsIconElement>[
    DsIconCircleElement(12, 12, 4), // key: 4exip2
    DsIconPathElement('M12 2v2'), // key: tus03m
    DsIconPathElement('M12 20v2'), // key: 1lh1kg
    DsIconPathElement('m4.93 4.93 1.41 1.41'), // key: 149t6j
    DsIconPathElement('m17.66 17.66 1.41 1.41'), // key: ptbguv
    DsIconPathElement('M2 12h2'), // key: 1t8f8n
    DsIconPathElement('M20 12h2'), // key: 1q8mjw
    DsIconPathElement('m6.34 17.66-1.41 1.41'), // key: 1m8zz5
    DsIconPathElement('m19.07 4.93-1.41 1.41'), // key: 1shlcs
  ]);

  /// `sunrise.mjs`
  static const DsLucideGlyph sunrise =
      DsLucideGlyph('sunrise', <DsIconElement>[
    DsIconPathElement('M12 2v8'), // key: 1q4o3n
    DsIconPathElement('m4.93 10.93 1.41 1.41'), // key: 2a7f42
    DsIconPathElement('M2 18h2'), // key: j10viu
    DsIconPathElement('M20 18h2'), // key: wocana
    DsIconPathElement('m19.07 10.93-1.41 1.41'), // key: 15zs5n
    DsIconPathElement('M22 22H2'), // key: 19qnx5
    DsIconPathElement('m8 6 4-4 4 4'), // key: ybng9g
    DsIconPathElement('M16 18a4 4 0 0 0-8 0'), // key: 1lzouq
  ]);

  /// `sunset.mjs`
  static const DsLucideGlyph sunset =
      DsLucideGlyph('sunset', <DsIconElement>[
    DsIconPathElement('M12 10V2'), // key: 16sf7g
    DsIconPathElement('m4.93 10.93 1.41 1.41'), // key: 2a7f42
    DsIconPathElement('M2 18h2'), // key: j10viu
    DsIconPathElement('M20 18h2'), // key: wocana
    DsIconPathElement('m19.07 10.93-1.41 1.41'), // key: 15zs5n
    DsIconPathElement('M22 22H2'), // key: 19qnx5
    DsIconPathElement('m16 6-4 4-4-4'), // key: 6wukr
    DsIconPathElement('M16 18a4 4 0 0 0-8 0'), // key: 1lzouq
  ]);

  /// `superscript.mjs`
  static const DsLucideGlyph superscript =
      DsLucideGlyph('superscript', <DsIconElement>[
    DsIconPathElement('m4 19 8-8'), // key: hr47gm
    DsIconPathElement('m12 19-8-8'), // key: 1dhhmo
    DsIconPathElement('M20 12h-4c0-1.5.442-2 1.5-2.5S20 8.334 20 7.002c0-.472-.17-.93-.484-1.29a2.105 2.105 0 0 0-2.617-.436c-.42.239-.738.614-.899 1.06'), // key: 1dfcux
  ]);

  /// `swatch-book.mjs`
  static const DsLucideGlyph swatchBook =
      DsLucideGlyph('swatch-book', <DsIconElement>[
    DsIconPathElement('M11 17a4 4 0 0 1-8 0V5a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2Z'), // key: 1ldrpk
    DsIconPathElement('M16.7 13H19a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2H7'), // key: 11i5po
    DsIconPathElement('M 7 17h.01'), // key: 1euzgo
    DsIconPathElement('m11 8 2.3-2.3a2.4 2.4 0 0 1 3.404.004L18.6 7.6a2.4 2.4 0 0 1 .026 3.434L9.9 19.8'), // key: o2gii7
  ]);

  /// `swiss-franc.mjs`
  static const DsLucideGlyph swissFranc =
      DsLucideGlyph('swiss-franc', <DsIconElement>[
    DsIconPathElement('M10 21V3h8'), // key: br2l0g
    DsIconPathElement('M6 16h9'), // key: 2py0wn
    DsIconPathElement('M10 9.5h7'), // key: 13dmhz
  ]);

  /// `switch-camera.mjs`
  static const DsLucideGlyph switchCamera =
      DsLucideGlyph('switch-camera', <DsIconElement>[
    DsIconPathElement('M11 19H4a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2h5'), // key: mtk2lu
    DsIconPathElement('M13 5h7a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2h-5'), // key: 120jsl
    DsIconCircleElement(12, 12, 3), // key: 1v7zrd
    DsIconPathElement('m18 22-3-3 3-3'), // key: kgdoj7
    DsIconPathElement('m6 2 3 3-3 3'), // key: 1fnbkv
  ]);

  /// `sword.mjs`
  static const DsLucideGlyph sword =
      DsLucideGlyph('sword', <DsIconElement>[
    DsIconPathElement('m11 19-6-6'), // key: s7kpr
    DsIconPathElement('m5 21-2-2'), // key: 1kw20b
    DsIconPathElement('m8 16-4 4'), // key: 1oqv8h
    DsIconPathElement('M9.5 17.5 21 6V3h-3L6.5 14.5'), // key: pkxemp
  ]);

  /// `swords.mjs`
  static const DsLucideGlyph swords =
      DsLucideGlyph('swords', <DsIconElement>[
    DsIconPolylineElement(<Offset>[Offset(14.5, 17.5), Offset(3, 6), Offset(3, 3), Offset(6, 3), Offset(17.5, 14.5)]), // key: 1hfsw2
    DsIconLineElement(13, 19, 19, 13), // key: 1vrmhu
    DsIconLineElement(16, 16, 20, 20), // key: 1bron3
    DsIconLineElement(19, 21, 21, 19), // key: 13pww6
    DsIconPolylineElement(<Offset>[Offset(14.5, 6.5), Offset(18, 3), Offset(21, 3), Offset(21, 6), Offset(17.5, 9.5)]), // key: hbey2j
    DsIconLineElement(5, 14, 9, 18), // key: 1hf58s
    DsIconLineElement(7, 17, 4, 20), // key: pidxm4
    DsIconLineElement(3, 19, 5, 21), // key: 1pehsh
  ]);

  /// `syringe.mjs`
  static const DsLucideGlyph syringe =
      DsLucideGlyph('syringe', <DsIconElement>[
    DsIconPathElement('m18 2 4 4'), // key: 22kx64
    DsIconPathElement('m17 7 3-3'), // key: 1w1zoj
    DsIconPathElement('M19 9 8.7 19.3c-1 1-2.5 1-3.4 0l-.6-.6c-1-1-1-2.5 0-3.4L15 5'), // key: 1exhtz
    DsIconPathElement('m9 11 4 4'), // key: rovt3i
    DsIconPathElement('m5 19-3 3'), // key: 59f2uf
    DsIconPathElement('m14 4 6 6'), // key: yqp9t2
  ]);

  /// `table-2.mjs`
  static const DsLucideGlyph table2 =
      DsLucideGlyph('table-2', <DsIconElement>[
    DsIconPathElement('M9 3H5a2 2 0 0 0-2 2v4m6-6h10a2 2 0 0 1 2 2v4M9 3v18m0 0h10a2 2 0 0 0 2-2V9M9 21H5a2 2 0 0 1-2-2V9m0 0h18'), // key: gugj83
  ]);

  /// `table-cells-merge.mjs`
  static const DsLucideGlyph tableCellsMerge =
      DsLucideGlyph('table-cells-merge', <DsIconElement>[
    DsIconPathElement('M12 21v-6'), // key: lihzve
    DsIconPathElement('M12 9V3'), // key: da5inc
    DsIconPathElement('M3 15h18'), // key: 5xshup
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
  ]);

  /// `table-cells-split.mjs`
  static const DsLucideGlyph tableCellsSplit =
      DsLucideGlyph('table-cells-split', <DsIconElement>[
    DsIconPathElement('M12 15V9'), // key: 8c7uyn
    DsIconPathElement('M3 15h18'), // key: 5xshup
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
  ]);

  /// `table-columns-split.mjs`
  static const DsLucideGlyph tableColumnsSplit =
      DsLucideGlyph('table-columns-split', <DsIconElement>[
    DsIconPathElement('M14 14v2'), // key: w2a1xv
    DsIconPathElement('M14 20v2'), // key: 1lq872
    DsIconPathElement('M14 2v2'), // key: 6buw04
    DsIconPathElement('M14 8v2'), // key: i67w9a
    DsIconPathElement('M2 15h8'), // key: 82wtch
    DsIconPathElement('M2 3h6a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H2'), // key: up0l64
    DsIconPathElement('M2 9h8'), // key: yelfik
    DsIconPathElement('M22 15h-4'), // key: 1es58f
    DsIconPathElement('M22 3h-2a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h2'), // key: pdjoqf
    DsIconPathElement('M22 9h-4'), // key: 1luja7
    DsIconPathElement('M5 3v18'), // key: 14hmio
  ]);

  /// `table-of-contents.mjs`
  static const DsLucideGlyph tableOfContents =
      DsLucideGlyph('table-of-contents', <DsIconElement>[
    DsIconPathElement('M16 5H3'), // key: m91uny
    DsIconPathElement('M16 12H3'), // key: 1a2rj7
    DsIconPathElement('M16 19H3'), // key: zzsher
    DsIconPathElement('M21 5h.01'), // key: wa75ra
    DsIconPathElement('M21 12h.01'), // key: msek7k
    DsIconPathElement('M21 19h.01'), // key: qvbq2j
  ]);

  /// `table-properties.mjs`
  static const DsLucideGlyph tableProperties =
      DsLucideGlyph('table-properties', <DsIconElement>[
    DsIconPathElement('M15 3v18'), // key: 14nvp0
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M21 9H3'), // key: 1338ky
    DsIconPathElement('M21 15H3'), // key: 9uk58r
  ]);

  /// `table-rows-split.mjs`
  static const DsLucideGlyph tableRowsSplit =
      DsLucideGlyph('table-rows-split', <DsIconElement>[
    DsIconPathElement('M14 10h2'), // key: 1lstlu
    DsIconPathElement('M15 22v-8'), // key: 1fwwgm
    DsIconPathElement('M15 2v4'), // key: 1044rn
    DsIconPathElement('M2 10h2'), // key: 1r8dkt
    DsIconPathElement('M20 10h2'), // key: 1ug425
    DsIconPathElement('M3 19h18'), // key: awlh7x
    DsIconPathElement('M3 22v-6a2 2 135 0 1 2-2h14a2 2 45 0 1 2 2v6'), // key: ibqhof
    DsIconPathElement('M3 2v2a2 2 45 0 0 2 2h14a2 2 135 0 0 2-2V2'), // key: 1uenja
    DsIconPathElement('M8 10h2'), // key: 66od0
    DsIconPathElement('M9 22v-8'), // key: fmnu31
    DsIconPathElement('M9 2v4'), // key: j1yeou
  ]);

  /// `table.mjs`
  static const DsLucideGlyph table =
      DsLucideGlyph('table', <DsIconElement>[
    DsIconPathElement('M12 3v18'), // key: 108xh3
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconPathElement('M3 9h18'), // key: 1pudct
    DsIconPathElement('M3 15h18'), // key: 5xshup
  ]);

  /// `tablet-smartphone.mjs`
  static const DsLucideGlyph tabletSmartphone =
      DsLucideGlyph('tablet-smartphone', <DsIconElement>[
    DsIconRectElement(3, 8, 10, 14, 2), // key: 1vrsiq
    DsIconPathElement('M5 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v16a2 2 0 0 1-2 2h-2.4'), // key: 1j4zmg
    DsIconPathElement('M8 18h.01'), // key: lrp35t
  ]);

  /// `tablet.mjs`
  static const DsLucideGlyph tablet =
      DsLucideGlyph('tablet', <DsIconElement>[
    DsIconRectElement(4, 2, 16, 20, 2, ry: 2), // key: 76otgf
    DsIconLineElement(12, 18, 12.01, 18), // key: 1dp563
  ]);

  /// `tablets.mjs`
  static const DsLucideGlyph tablets =
      DsLucideGlyph('tablets', <DsIconElement>[
    DsIconCircleElement(7, 7, 5), // key: x29byf
    DsIconCircleElement(17, 17, 5), // key: 1op1d2
    DsIconPathElement('M12 17h10'), // key: ls21zv
    DsIconPathElement('m3.46 10.54 7.08-7.08'), // key: 1rehiu
  ]);

  /// `tag-plus.mjs`
  static const DsLucideGlyph tagPlus =
      DsLucideGlyph('tag-plus', <DsIconElement>[
    DsIconPathElement('M16 13h6'), // key: 1um0mj
    DsIconPathElement('m16.5 6.5-3.914-3.914A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l1.79-1.79'), // key: dp0yc9
    DsIconPathElement('M19 10v6'), // key: 13mz7b
    DsIconCircleElement(7.5, 7.5, 0.5, filled: true), // key: kqv944
  ]);

  /// `tag-x.mjs`
  static const DsLucideGlyph tagX =
      DsLucideGlyph('tag-x', <DsIconElement>[
    DsIconPathElement('m16.5 6.5-3.914-3.914A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.43 2.43 0 0 0 3.42 0l1.79-1.79'), // key: hu94c9
    DsIconPathElement('m16.5 10.5 5 5'), // key: 1jo8bf
    DsIconPathElement('m21.5 10.5-5 5'), // key: jzei60
    DsIconCircleElement(7.5, 7.5, 0.5, filled: true), // key: kqv944
  ]);

  /// `tag.mjs`
  static const DsLucideGlyph tag =
      DsLucideGlyph('tag', <DsIconElement>[
    DsIconPathElement('M12.586 2.586A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l6.58-6.58a2.426 2.426 0 0 0 0-3.42z'), // key: vktsd0
    DsIconCircleElement(7.5, 7.5, 0.5, filled: true), // key: kqv944
  ]);

  /// `tags.mjs`
  static const DsLucideGlyph tags =
      DsLucideGlyph('tags', <DsIconElement>[
    DsIconPathElement('M13.172 2a2 2 0 0 1 1.414.586l6.71 6.71a2.4 2.4 0 0 1 0 3.408l-4.592 4.592a2.4 2.4 0 0 1-3.408 0l-6.71-6.71A2 2 0 0 1 6 9.172V3a1 1 0 0 1 1-1z'), // key: 16rjxf
    DsIconPathElement('M2 7v6.172a2 2 0 0 0 .586 1.414l6.71 6.71a2.4 2.4 0 0 0 3.191.193'), // key: 178nd4
    DsIconCircleElement(10.5, 6.5, 0.5, filled: true), // key: 12ikhr
  ]);

  /// `tally-1.mjs`
  static const DsLucideGlyph tally1 =
      DsLucideGlyph('tally-1', <DsIconElement>[
    DsIconPathElement('M4 4v16'), // key: 6qkkli
  ]);

  /// `tally-2.mjs`
  static const DsLucideGlyph tally2 =
      DsLucideGlyph('tally-2', <DsIconElement>[
    DsIconPathElement('M4 4v16'), // key: 6qkkli
    DsIconPathElement('M9 4v16'), // key: 81ygyz
  ]);

  /// `tally-3.mjs`
  static const DsLucideGlyph tally3 =
      DsLucideGlyph('tally-3', <DsIconElement>[
    DsIconPathElement('M4 4v16'), // key: 6qkkli
    DsIconPathElement('M9 4v16'), // key: 81ygyz
    DsIconPathElement('M14 4v16'), // key: 12vmem
  ]);

  /// `tally-4.mjs`
  static const DsLucideGlyph tally4 =
      DsLucideGlyph('tally-4', <DsIconElement>[
    DsIconPathElement('M4 4v16'), // key: 6qkkli
    DsIconPathElement('M9 4v16'), // key: 81ygyz
    DsIconPathElement('M14 4v16'), // key: 12vmem
    DsIconPathElement('M19 4v16'), // key: 8ij5ei
  ]);

  /// `tally-5.mjs`
  static const DsLucideGlyph tally5 =
      DsLucideGlyph('tally-5', <DsIconElement>[
    DsIconPathElement('M4 4v16'), // key: 6qkkli
    DsIconPathElement('M9 4v16'), // key: 81ygyz
    DsIconPathElement('M14 4v16'), // key: 12vmem
    DsIconPathElement('M19 4v16'), // key: 8ij5ei
    DsIconPathElement('M22 6 2 18'), // key: h9moai
  ]);

  /// `tangent.mjs`
  static const DsLucideGlyph tangent =
      DsLucideGlyph('tangent', <DsIconElement>[
    DsIconCircleElement(17, 4, 2), // key: y5j2s2
    DsIconPathElement('M15.59 5.41 5.41 15.59'), // key: l0vprr
    DsIconCircleElement(4, 17, 2), // key: 9p4efm
    DsIconPathElement('M12 22s-4-9-1.5-11.5S22 12 22 12'), // key: 1twk4o
  ]);

  /// `target.mjs`
  static const DsLucideGlyph target =
      DsLucideGlyph('target', <DsIconElement>[
    DsIconCircleElement(12, 12, 10), // key: 1mglay
    DsIconCircleElement(12, 12, 6), // key: 1vlfrh
    DsIconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `telescope.mjs`
  static const DsLucideGlyph telescope =
      DsLucideGlyph('telescope', <DsIconElement>[
    DsIconPathElement('m10.065 12.493-6.18 1.318a.934.934 0 0 1-1.108-.702l-.537-2.15a1.07 1.07 0 0 1 .691-1.265l13.504-4.44'), // key: k4qptu
    DsIconPathElement('m13.56 11.747 4.332-.924'), // key: 19l80z
    DsIconPathElement('m16 21-3.105-6.21'), // key: 7oh9d
    DsIconPathElement('M16.485 5.94a2 2 0 0 1 1.455-2.425l1.09-.272a1 1 0 0 1 1.212.727l1.515 6.06a1 1 0 0 1-.727 1.213l-1.09.272a2 2 0 0 1-2.425-1.455z'), // key: m7xp4m
    DsIconPathElement('m6.158 8.633 1.114 4.456'), // key: 74o979
    DsIconPathElement('m8 21 3.105-6.21'), // key: 1fvxut
    DsIconCircleElement(12, 13, 2), // key: 1c1ljs
  ]);

  /// `tent-tree.mjs`
  static const DsLucideGlyph tentTree =
      DsLucideGlyph('tent-tree', <DsIconElement>[
    DsIconCircleElement(4, 4, 2), // key: bt5ra8
    DsIconPathElement('m14 5 3-3 3 3'), // key: 1sorif
    DsIconPathElement('m14 10 3-3 3 3'), // key: 1jyi9h
    DsIconPathElement('M17 14V2'), // key: 8ymqnk
    DsIconPathElement('M17 14H7l-5 8h20Z'), // key: 13ar7p
    DsIconPathElement('M8 14v8'), // key: 1ghmqk
    DsIconPathElement('m9 14 5 8'), // key: 13pgi6
  ]);

  /// `tent.mjs`
  static const DsLucideGlyph tent =
      DsLucideGlyph('tent', <DsIconElement>[
    DsIconPathElement('M3.5 21 14 3'), // key: 1szst5
    DsIconPathElement('M20.5 21 10 3'), // key: 1310c3
    DsIconPathElement('M15.5 21 12 15l-3.5 6'), // key: 1ddtfw
    DsIconPathElement('M2 21h20'), // key: 1nyx9w
  ]);

  /// `terminal.mjs`
  static const DsLucideGlyph terminal =
      DsLucideGlyph('terminal', <DsIconElement>[
    DsIconPathElement('M12 19h8'), // key: baeox8
    DsIconPathElement('m4 17 6-6-6-6'), // key: 1yngyt
  ]);

  /// `test-tube-diagonal.mjs`
  static const DsLucideGlyph testTubeDiagonal =
      DsLucideGlyph('test-tube-diagonal', <DsIconElement>[
    DsIconPathElement('M21 7 6.82 21.18a2.83 2.83 0 0 1-3.99-.01a2.83 2.83 0 0 1 0-4L17 3'), // key: 1ub6xw
    DsIconPathElement('m16 2 6 6'), // key: 1gw87d
    DsIconPathElement('M12 16H4'), // key: 1cjfip
  ]);

  /// `test-tube.mjs`
  static const DsLucideGlyph testTube =
      DsLucideGlyph('test-tube', <DsIconElement>[
    DsIconPathElement('M14.5 2v17.5c0 1.4-1.1 2.5-2.5 2.5c-1.4 0-2.5-1.1-2.5-2.5V2'), // key: 125lnx
    DsIconPathElement('M8.5 2h7'), // key: csnxdl
    DsIconPathElement('M14.5 16h-5'), // key: 1ox875
  ]);

  /// `test-tubes.mjs`
  static const DsLucideGlyph testTubes =
      DsLucideGlyph('test-tubes', <DsIconElement>[
    DsIconPathElement('M9 2v17.5A2.5 2.5 0 0 1 6.5 22A2.5 2.5 0 0 1 4 19.5V2'), // key: 1hjrqt
    DsIconPathElement('M20 2v17.5a2.5 2.5 0 0 1-2.5 2.5a2.5 2.5 0 0 1-2.5-2.5V2'), // key: 16lc8n
    DsIconPathElement('M3 2h7'), // key: 7s29d5
    DsIconPathElement('M14 2h7'), // key: 7sicin
    DsIconPathElement('M9 16H4'), // key: 1bfye3
    DsIconPathElement('M20 16h-5'), // key: ddnjpe
  ]);

  /// `text-align-center.mjs`
  static const DsLucideGlyph textAlignCenter =
      DsLucideGlyph('text-align-center', <DsIconElement>[
    DsIconPathElement('M21 5H3'), // key: 1fi0y6
    DsIconPathElement('M17 12H7'), // key: 16if0g
    DsIconPathElement('M19 19H5'), // key: vjpgq2
  ]);

  /// `text-align-end.mjs`
  static const DsLucideGlyph textAlignEnd =
      DsLucideGlyph('text-align-end', <DsIconElement>[
    DsIconPathElement('M21 5H3'), // key: 1fi0y6
    DsIconPathElement('M21 12H9'), // key: dn1m92
    DsIconPathElement('M21 19H7'), // key: 4cu937
  ]);

  /// `text-align-justify.mjs`
  static const DsLucideGlyph textAlignJustify =
      DsLucideGlyph('text-align-justify', <DsIconElement>[
    DsIconPathElement('M3 5h18'), // key: 1u36vt
    DsIconPathElement('M3 12h18'), // key: 1i2n21
    DsIconPathElement('M3 19h18'), // key: awlh7x
  ]);

  /// `text-align-start.mjs`
  static const DsLucideGlyph textAlignStart =
      DsLucideGlyph('text-align-start', <DsIconElement>[
    DsIconPathElement('M21 5H3'), // key: 1fi0y6
    DsIconPathElement('M15 12H3'), // key: 6jk70r
    DsIconPathElement('M17 19H3'), // key: z6ezky
  ]);

  /// `text-cursor-input.mjs`
  static const DsLucideGlyph textCursorInput =
      DsLucideGlyph('text-cursor-input', <DsIconElement>[
    DsIconPathElement('M12 20h-1a2 2 0 0 1-2-2 2 2 0 0 1-2 2H6'), // key: 1528k5
    DsIconPathElement('M13 8h7a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2h-7'), // key: 13ksps
    DsIconPathElement('M5 16H4a2 2 0 0 1-2-2v-4a2 2 0 0 1 2-2h1'), // key: 1n9rhb
    DsIconPathElement('M6 4h1a2 2 0 0 1 2 2 2 2 0 0 1 2-2h1'), // key: 1mj8rg
    DsIconPathElement('M9 6v12'), // key: velyjx
  ]);

  /// `text-cursor.mjs`
  static const DsLucideGlyph textCursor =
      DsLucideGlyph('text-cursor', <DsIconElement>[
    DsIconPathElement('M17 22h-1a4 4 0 0 1-4-4V6a4 4 0 0 1 4-4h1'), // key: uvaxm9
    DsIconPathElement('M7 22h1a4 4 0 0 0 4-4'), // key: 1l7xii
    DsIconPathElement('M7 2h1a4 4 0 0 1 4 4'), // key: 1vrvvh
  ]);

  /// `text-initial.mjs`
  static const DsLucideGlyph textInitial =
      DsLucideGlyph('text-initial', <DsIconElement>[
    DsIconPathElement('M15 5h6'), // key: 1pr8yx
    DsIconPathElement('M15 12h6'), // key: upa0zy
    DsIconPathElement('M3 19h18'), // key: awlh7x
    DsIconPathElement('m3 12 3.553-7.724a.5.5 0 0 1 .894 0L11 12'), // key: 6lvno8
    DsIconPathElement('M3.92 10h6.16'), // key: 1tl8ex
  ]);

  /// `text-quote.mjs`
  static const DsLucideGlyph textQuote =
      DsLucideGlyph('text-quote', <DsIconElement>[
    DsIconPathElement('M17 5H3'), // key: 1cn7zz
    DsIconPathElement('M21 12H8'), // key: scolzb
    DsIconPathElement('M21 19H8'), // key: 13qgcb
    DsIconPathElement('M3 12v7'), // key: 1ri8j3
  ]);

  /// `text-search.mjs`
  static const DsLucideGlyph textSearch =
      DsLucideGlyph('text-search', <DsIconElement>[
    DsIconPathElement('M21 5H3'), // key: 1fi0y6
    DsIconPathElement('M10 12H3'), // key: 1ulcyk
    DsIconPathElement('M10 19H3'), // key: 108z41
    DsIconCircleElement(17, 15, 3), // key: 1upz2a
    DsIconPathElement('m21 19-1.9-1.9'), // key: dwi7p8
  ]);

  /// `text-wrap.mjs`
  static const DsLucideGlyph textWrap =
      DsLucideGlyph('text-wrap', <DsIconElement>[
    DsIconPathElement('m16 16-3 3 3 3'), // key: 117b85
    DsIconPathElement('M3 12h14.5a1 1 0 0 1 0 7H13'), // key: 18xa6z
    DsIconPathElement('M3 19h6'), // key: 1ygdsz
    DsIconPathElement('M3 5h18'), // key: 1u36vt
  ]);

  /// `theater.mjs`
  static const DsLucideGlyph theater =
      DsLucideGlyph('theater', <DsIconElement>[
    DsIconPathElement('M2 10s3-3 3-8'), // key: 3xiif0
    DsIconPathElement('M22 10s-3-3-3-8'), // key: ioaa5q
    DsIconPathElement('M10 2c0 4.4-3.6 8-8 8'), // key: 16fkpi
    DsIconPathElement('M14 2c0 4.4 3.6 8 8 8'), // key: b9eulq
    DsIconPathElement('M2 10s2 2 2 5'), // key: 1au1lb
    DsIconPathElement('M22 10s-2 2-2 5'), // key: qi2y5e
    DsIconPathElement('M8 15h8'), // key: 45n4r
    DsIconPathElement('M2 22v-1a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v1'), // key: 1vsc2m
    DsIconPathElement('M14 22v-1a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v1'), // key: hrha4u
  ]);

  /// `thermometer-snowflake.mjs`
  static const DsLucideGlyph thermometerSnowflake =
      DsLucideGlyph('thermometer-snowflake', <DsIconElement>[
    DsIconPathElement('m10 20-1.25-2.5L6 18'), // key: 18frcb
    DsIconPathElement('M10 4 8.75 6.5 6 6'), // key: 7mghy3
    DsIconPathElement('M10.585 15H10'), // key: 4nqulp
    DsIconPathElement('M2 12h6.5L10 9'), // key: kv9z4n
    DsIconPathElement('M20 14.54a4 4 0 1 1-4 0V4a2 2 0 0 1 4 0z'), // key: yu0u2z
    DsIconPathElement('m4 10 1.5 2L4 14'), // key: k9enpj
    DsIconPathElement('m7 21 3-6-1.5-3'), // key: j8hb9u
    DsIconPathElement('m7 3 3 6h2'), // key: 1bbqgq
  ]);

  /// `thermometer-sun.mjs`
  static const DsLucideGlyph thermometerSun =
      DsLucideGlyph('thermometer-sun', <DsIconElement>[
    DsIconPathElement('M12 2v2'), // key: tus03m
    DsIconPathElement('M12 8a4 4 0 0 0-1.645 7.647'), // key: wz5p04
    DsIconPathElement('M2 12h2'), // key: 1t8f8n
    DsIconPathElement('M20 14.54a4 4 0 1 1-4 0V4a2 2 0 0 1 4 0z'), // key: yu0u2z
    DsIconPathElement('m4.93 4.93 1.41 1.41'), // key: 149t6j
    DsIconPathElement('m6.34 17.66-1.41 1.41'), // key: 1m8zz5
  ]);

  /// `thermometer.mjs`
  static const DsLucideGlyph thermometer =
      DsLucideGlyph('thermometer', <DsIconElement>[
    DsIconPathElement('M14 4v10.54a4 4 0 1 1-4 0V4a2 2 0 0 1 4 0Z'), // key: 17jzev
  ]);

  /// `thumbs-down.mjs`
  static const DsLucideGlyph thumbsDown =
      DsLucideGlyph('thumbs-down', <DsIconElement>[
    DsIconPathElement('M9 18.12 10 14H4.17a2 2 0 0 1-1.92-2.56l2.33-8A2 2 0 0 1 6.5 2H20a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-2.76a2 2 0 0 0-1.79 1.11L12 22a3.13 3.13 0 0 1-3-3.88Z'), // key: m61m77
    DsIconPathElement('M17 14V2'), // key: 8ymqnk
  ]);

  /// `thumbs-up.mjs`
  static const DsLucideGlyph thumbsUp =
      DsLucideGlyph('thumbs-up', <DsIconElement>[
    DsIconPathElement('M15 5.88 14 10h5.83a2 2 0 0 1 1.92 2.56l-2.33 8A2 2 0 0 1 17.5 22H4a2 2 0 0 1-2-2v-8a2 2 0 0 1 2-2h2.76a2 2 0 0 0 1.79-1.11L12 2a3.13 3.13 0 0 1 3 3.88Z'), // key: emmmcr
    DsIconPathElement('M7 10v12'), // key: 1qc93n
  ]);

  /// `ticket-check.mjs`
  static const DsLucideGlyph ticketCheck =
      DsLucideGlyph('ticket-check', <DsIconElement>[
    DsIconPathElement('M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z'), // key: qn84l0
    DsIconPathElement('m9 12 2 2 4-4'), // key: dzmm74
  ]);

  /// `ticket-minus.mjs`
  static const DsLucideGlyph ticketMinus =
      DsLucideGlyph('ticket-minus', <DsIconElement>[
    DsIconPathElement('M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z'), // key: qn84l0
    DsIconPathElement('M9 12h6'), // key: 1c52cq
  ]);

  /// `ticket-percent.mjs`
  static const DsLucideGlyph ticketPercent =
      DsLucideGlyph('ticket-percent', <DsIconElement>[
    DsIconPathElement('M2 9a3 3 0 1 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 1 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z'), // key: 1l48ns
    DsIconPathElement('M9 9h.01'), // key: 1q5me6
    DsIconPathElement('m15 9-6 6'), // key: 1uzhvr
    DsIconPathElement('M15 15h.01'), // key: lqbp3k
  ]);

  /// `ticket-plus.mjs`
  static const DsLucideGlyph ticketPlus =
      DsLucideGlyph('ticket-plus', <DsIconElement>[
    DsIconPathElement('M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z'), // key: qn84l0
    DsIconPathElement('M9 12h6'), // key: 1c52cq
    DsIconPathElement('M12 9v6'), // key: 199k2o
  ]);

  /// `ticket-slash.mjs`
  static const DsLucideGlyph ticketSlash =
      DsLucideGlyph('ticket-slash', <DsIconElement>[
    DsIconPathElement('M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z'), // key: qn84l0
    DsIconPathElement('m9.5 14.5 5-5'), // key: qviqfa
  ]);

  /// `ticket-x.mjs`
  static const DsLucideGlyph ticketX =
      DsLucideGlyph('ticket-x', <DsIconElement>[
    DsIconPathElement('M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z'), // key: qn84l0
    DsIconPathElement('m9.5 14.5 5-5'), // key: qviqfa
    DsIconPathElement('m9.5 9.5 5 5'), // key: 18nt4w
  ]);

  /// `ticket.mjs`
  static const DsLucideGlyph ticket =
      DsLucideGlyph('ticket', <DsIconElement>[
    DsIconPathElement('M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z'), // key: qn84l0
    DsIconPathElement('M13 5v2'), // key: dyzc3o
    DsIconPathElement('M13 17v2'), // key: 1ont0d
    DsIconPathElement('M13 11v2'), // key: 1wjjxi
  ]);

  /// `tickets-plane.mjs`
  static const DsLucideGlyph ticketsPlane =
      DsLucideGlyph('tickets-plane', <DsIconElement>[
    DsIconPathElement('M10.5 17h1.227a2 2 0 0 0 1.345-.52L18 12'), // key: 16muxl
    DsIconPathElement('m12 13.5 3.794.506'), // key: 6v5z87
    DsIconPathElement('m3.173 8.18 11-5a2 2 0 0 1 2.647.993L18.56 8'), // key: 15hfpj
    DsIconPathElement('M6 10V8'), // key: 1y41hn
    DsIconPathElement('M6 14v1'), // key: cao2tf
    DsIconPathElement('M6 19v2'), // key: 1loha6
    DsIconRectElement(2, 8, 20, 13, 2), // key: p3bz5l
  ]);

  /// `tickets.mjs`
  static const DsLucideGlyph tickets =
      DsLucideGlyph('tickets', <DsIconElement>[
    DsIconPathElement('m3.173 8.18 11-5a2 2 0 0 1 2.647.993L18.56 8'), // key: 15hfpj
    DsIconPathElement('M6 10V8'), // key: 1y41hn
    DsIconPathElement('M6 14v1'), // key: cao2tf
    DsIconPathElement('M6 19v2'), // key: 1loha6
    DsIconRectElement(2, 8, 20, 13, 2), // key: p3bz5l
  ]);

  /// `timeline.mjs`
  static const DsLucideGlyph timeline =
      DsLucideGlyph('timeline', <DsIconElement>[
    DsIconPathElement('M4 12h.01'), // key: 158zrr
    DsIconPathElement('M4 16h.01'), // key: jrnfb7
    DsIconPathElement('M4 20h.01'), // key: orx0iu
    DsIconPathElement('M4 4h.01'), // key: cieki8
    DsIconPathElement('M4 8h.01'), // key: 43g258
    DsIconPathElement('M9.414 13.414a2 2 0 0 0 1.414.586H19a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1h-8.172a2 2 0 0 0-1.414.586L8 12z'), // key: 1pvxkf
    DsIconPathElement('M9.414 21.414a2 2 0 0 0 1.414.586H19a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1h-8.172a2 2 0 0 0-1.414.586L8 20z'), // key: 1k13gh
    DsIconPathElement('M9.414 5.414A2 2 0 0 0 10.828 6H19a1 1 0 0 0 1-1V3a1 1 0 0 0-1-1h-8.172a2 2 0 0 0-1.414.586L8 4z'), // key: 12x0hd
  ]);

  /// `timer-off.mjs`
  static const DsLucideGlyph timerOff =
      DsLucideGlyph('timer-off', <DsIconElement>[
    DsIconPathElement('M10 2h4'), // key: n1abiw
    DsIconPathElement('M4.6 11a8 8 0 0 0 1.7 8.7 8 8 0 0 0 8.7 1.7'), // key: 10he05
    DsIconPathElement('M7.4 7.4a8 8 0 0 1 10.3 1 8 8 0 0 1 .9 10.2'), // key: 15f7sh
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M12 12v-2'), // key: fwoke6
  ]);

  /// `timer-reset.mjs`
  static const DsLucideGlyph timerReset =
      DsLucideGlyph('timer-reset', <DsIconElement>[
    DsIconPathElement('M10 2h4'), // key: n1abiw
    DsIconPathElement('M12 14v-4'), // key: 1evpnu
    DsIconPathElement('M4 13a8 8 0 0 1 8-7 8 8 0 1 1-5.3 14L4 17.6'), // key: 1ts96g
    DsIconPathElement('M9 17H4v5'), // key: 8t5av
  ]);

  /// `timer.mjs`
  static const DsLucideGlyph timer =
      DsLucideGlyph('timer', <DsIconElement>[
    DsIconLineElement(10, 2, 14, 2), // key: 14vaq8
    DsIconLineElement(12, 14, 15, 11), // key: 17fdiu
    DsIconCircleElement(12, 14, 8), // key: 1e1u0o
  ]);

  /// `toggle-left.mjs`
  static const DsLucideGlyph toggleLeft =
      DsLucideGlyph('toggle-left', <DsIconElement>[
    DsIconCircleElement(9, 12, 3), // key: u3jwor
    DsIconRectElement(2, 5, 20, 14, 7), // key: g7kal2
  ]);

  /// `toggle-right.mjs`
  static const DsLucideGlyph toggleRight =
      DsLucideGlyph('toggle-right', <DsIconElement>[
    DsIconCircleElement(15, 12, 3), // key: 1afu0r
    DsIconRectElement(2, 5, 20, 14, 7), // key: g7kal2
  ]);

  /// `toilet.mjs`
  static const DsLucideGlyph toilet =
      DsLucideGlyph('toilet', <DsIconElement>[
    DsIconPathElement('M7 12h13a1 1 0 0 1 1 1 5 5 0 0 1-5 5h-.598a.5.5 0 0 0-.424.765l1.544 2.47a.5.5 0 0 1-.424.765H5.402a.5.5 0 0 1-.424-.765L7 18'), // key: kc4kqr
    DsIconPathElement('M8 18a5 5 0 0 1-5-5V4a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v8'), // key: 1tqs57
  ]);

  /// `tool-case.mjs`
  static const DsLucideGlyph toolCase =
      DsLucideGlyph('tool-case', <DsIconElement>[
    DsIconPathElement('M10 15h4'), // key: 192ueg
    DsIconPathElement('m14.817 10.995-.971-1.45 1.034-1.232a2 2 0 0 0-2.025-3.238l-1.82.364L9.91 3.885a2 2 0 0 0-3.625.748L6.141 6.55l-1.725.426a2 2 0 0 0-.19 3.756l.657.27'), // key: xbnumr
    DsIconPathElement('m18.822 10.995 2.26-5.38a1 1 0 0 0-.557-1.318L16.954 2.9a1 1 0 0 0-1.281.533l-.924 2.122'), // key: eaw7gc
    DsIconPathElement('M4 12.006A1 1 0 0 1 4.994 11H19a1 1 0 0 1 1 1v7a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2z'), // key: 1vaooh
  ]);

  /// `toolbox.mjs`
  static const DsLucideGlyph toolbox =
      DsLucideGlyph('toolbox', <DsIconElement>[
    DsIconPathElement('M16 12v4'), // key: vf1vip
    DsIconPathElement('M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2'), // key: llnzfg
    DsIconPathElement('M17 6a2 2 0 011.414.586l3 3A2 2 0 0122 11v8a2 2 0 01-2 2H4a2 2 0 01-2-2v-8a2 2 0 01.586-1.414l3-3A2 2 0 017 6z'), // key: 1hprxj
    DsIconPathElement('M2 14h20'), // key: myj16y
    DsIconPathElement('M8 12v4'), // key: 1w4uao
  ]);

  /// `tornado.mjs`
  static const DsLucideGlyph tornado =
      DsLucideGlyph('tornado', <DsIconElement>[
    DsIconPathElement('M21 4H3'), // key: 1hwok0
    DsIconPathElement('M18 8H6'), // key: 41n648
    DsIconPathElement('M19 12H9'), // key: 1g4lpz
    DsIconPathElement('M16 16h-6'), // key: 1j5d54
    DsIconPathElement('M11 20H9'), // key: 39obr8
  ]);

  /// `torus.mjs`
  static const DsLucideGlyph torus =
      DsLucideGlyph('torus', <DsIconElement>[
    DsIconEllipseElement(12, 11, 3, 2), // key: 1b2qxu
    DsIconEllipseElement(12, 12.5, 10, 8.5), // key: h8emeu
  ]);

  /// `touchpad-off.mjs`
  static const DsLucideGlyph touchpadOff =
      DsLucideGlyph('touchpad-off', <DsIconElement>[
    DsIconPathElement('M12 20v-6'), // key: 1rm09r
    DsIconPathElement('M19.656 14H22'), // key: 170xzr
    DsIconPathElement('M2 14h12'), // key: d8icqz
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M20 20H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2'), // key: s23sx2
    DsIconPathElement('M9.656 4H20a2 2 0 0 1 2 2v10.344'), // key: ovjcvl
  ]);

  /// `touchpad.mjs`
  static const DsLucideGlyph touchpad =
      DsLucideGlyph('touchpad', <DsIconElement>[
    DsIconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
    DsIconPathElement('M2 14h20'), // key: myj16y
    DsIconPathElement('M12 20v-6'), // key: 1rm09r
  ]);

  /// `towel-rack.mjs`
  static const DsLucideGlyph towelRack =
      DsLucideGlyph('towel-rack', <DsIconElement>[
    DsIconPathElement('M22 7h-2'), // key: 1okbx2
    DsIconPathElement('M6.5 3h11A2.5 2.5 0 0 1 20 5.5V20a1 1 0 0 1-1 1h-9a1 1 0 0 1-1-1V5.5a1 1 0 0 0-5 0V17a1 1 0 0 0 1 1h4'), // key: kc32tg
    DsIconPathElement('M9 7H2'), // key: ahf7b7
  ]);

  /// `tower-control.mjs`
  static const DsLucideGlyph towerControl =
      DsLucideGlyph('tower-control', <DsIconElement>[
    DsIconPathElement('M18.2 12.27 20 6H4l1.8 6.27a1 1 0 0 0 .95.73h10.5a1 1 0 0 0 .96-.73Z'), // key: 1pledb
    DsIconPathElement('M8 13v9'), // key: hmv0ci
    DsIconPathElement('M16 22v-9'), // key: ylnf1u
    DsIconPathElement('m9 6 1 7'), // key: dpdgam
    DsIconPathElement('m15 6-1 7'), // key: ls7zgu
    DsIconPathElement('M12 6V2'), // key: 1pj48d
    DsIconPathElement('M13 2h-2'), // key: mj6ths
  ]);

  /// `toy-brick.mjs`
  static const DsLucideGlyph toyBrick =
      DsLucideGlyph('toy-brick', <DsIconElement>[
    DsIconRectElement(3, 8, 18, 12, 1), // key: 158fvp
    DsIconPathElement('M10 8V5c0-.6-.4-1-1-1H6a1 1 0 0 0-1 1v3'), // key: s0042v
    DsIconPathElement('M19 8V5c0-.6-.4-1-1-1h-3a1 1 0 0 0-1 1v3'), // key: 9wmeh2
  ]);

  /// `tractor.mjs`
  static const DsLucideGlyph tractor =
      DsLucideGlyph('tractor', <DsIconElement>[
    DsIconPathElement('m10 11 11 .9a1 1 0 0 1 .8 1.1l-.665 4.158a1 1 0 0 1-.988.842H20'), // key: she1j9
    DsIconPathElement('M16 18h-5'), // key: bq60fd
    DsIconPathElement('M18 5a1 1 0 0 0-1 1v5.573'), // key: 1kv8ia
    DsIconPathElement('M3 4h8.129a1 1 0 0 1 .99.863L13 11.246'), // key: 1q1ert
    DsIconPathElement('M4 11V4'), // key: 9ft8pt
    DsIconPathElement('M7 15h.01'), // key: k5ht0j
    DsIconPathElement('M8 10.1V4'), // key: 1jgyzo
    DsIconCircleElement(18, 18, 2), // key: 1emm8v
    DsIconCircleElement(7, 15, 5), // key: ddtuc
  ]);

  /// `traffic-cone.mjs`
  static const DsLucideGlyph trafficCone =
      DsLucideGlyph('traffic-cone', <DsIconElement>[
    DsIconPathElement('M16.05 10.966a5 2.5 0 0 1-8.1 0'), // key: m5jpwb
    DsIconPathElement('m16.923 14.049 4.48 2.04a1 1 0 0 1 .001 1.831l-8.574 3.9a2 2 0 0 1-1.66 0l-8.574-3.91a1 1 0 0 1 0-1.83l4.484-2.04'), // key: rbg3g8
    DsIconPathElement('M16.949 14.14a5 2.5 0 1 1-9.9 0L10.063 3.5a2 2 0 0 1 3.874 0z'), // key: vap8c8
    DsIconPathElement('M9.194 6.57a5 2.5 0 0 0 5.61 0'), // key: 15hn5c
  ]);

  /// `train-front-tunnel.mjs`
  static const DsLucideGlyph trainFrontTunnel =
      DsLucideGlyph('train-front-tunnel', <DsIconElement>[
    DsIconPathElement('M2 22V12a10 10 0 1 1 20 0v10'), // key: o0fyp0
    DsIconPathElement('M15 6.8v1.4a3 2.8 0 1 1-6 0V6.8'), // key: m8q3n9
    DsIconPathElement('M10 15h.01'), // key: 44in9x
    DsIconPathElement('M14 15h.01'), // key: 5mohn5
    DsIconPathElement('M10 19a4 4 0 0 1-4-4v-3a6 6 0 1 1 12 0v3a4 4 0 0 1-4 4Z'), // key: hckbmu
    DsIconPathElement('m9 19-2 3'), // key: iij7hm
    DsIconPathElement('m15 19 2 3'), // key: npx8sa
  ]);

  /// `train-front.mjs`
  static const DsLucideGlyph trainFront =
      DsLucideGlyph('train-front', <DsIconElement>[
    DsIconPathElement('M8 3.1V7a4 4 0 0 0 8 0V3.1'), // key: 1v71zp
    DsIconPathElement('m9 15-1-1'), // key: 1yrq24
    DsIconPathElement('m15 15 1-1'), // key: 1t0d6s
    DsIconPathElement('M9 19c-2.8 0-5-2.2-5-5v-4a8 8 0 0 1 16 0v4c0 2.8-2.2 5-5 5Z'), // key: 1p0hjs
    DsIconPathElement('m8 19-2 3'), // key: 13i0xs
    DsIconPathElement('m16 19 2 3'), // key: xo31yx
  ]);

  /// `train-track.mjs`
  static const DsLucideGlyph trainTrack =
      DsLucideGlyph('train-track', <DsIconElement>[
    DsIconPathElement('M2 17 17 2'), // key: 18b09t
    DsIconPathElement('m2 14 8 8'), // key: 1gv9hu
    DsIconPathElement('m5 11 8 8'), // key: 189pqp
    DsIconPathElement('m8 8 8 8'), // key: 1imecy
    DsIconPathElement('m11 5 8 8'), // key: ummqn6
    DsIconPathElement('m14 2 8 8'), // key: 1vk7dn
    DsIconPathElement('M7 22 22 7'), // key: 15mb1i
  ]);

  /// `tram-front.mjs`
  static const DsLucideGlyph tramFront =
      DsLucideGlyph('tram-front', <DsIconElement>[
    DsIconRectElement(4, 3, 16, 16, 2), // key: 1wxw4b
    DsIconPathElement('M4 11h16'), // key: mpoxn0
    DsIconPathElement('M12 3v8'), // key: 1h2ygw
    DsIconPathElement('m8 19-2 3'), // key: 13i0xs
    DsIconPathElement('m18 22-2-3'), // key: 1p0ohu
    DsIconPathElement('M8 15h.01'), // key: a7atzg
    DsIconPathElement('M16 15h.01'), // key: rnfrdf
  ]);

  /// `transgender.mjs`
  static const DsLucideGlyph transgender =
      DsLucideGlyph('transgender', <DsIconElement>[
    DsIconPathElement('M12 16v6'), // key: c8a4gj
    DsIconPathElement('M14 20h-4'), // key: m8m19d
    DsIconPathElement('M18 2h4v4'), // key: 1341mj
    DsIconPathElement('m2 2 7.17 7.17'), // key: 13q8l2
    DsIconPathElement('M2 5.355V2h3.357'), // key: 18136r
    DsIconPathElement('m22 2-7.17 7.17'), // key: 1epvy4
    DsIconPathElement('M8 5 5 8'), // key: mgbjhz
    DsIconCircleElement(12, 12, 4), // key: 4exip2
  ]);

  /// `trash-2.mjs`
  static const DsLucideGlyph trash2 =
      DsLucideGlyph('trash-2', <DsIconElement>[
    DsIconPathElement('M10 11v6'), // key: nco0om
    DsIconPathElement('M14 11v6'), // key: outv1u
    DsIconPathElement('M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6'), // key: miytrc
    DsIconPathElement('M3 6h18'), // key: d0wm0j
    DsIconPathElement('M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2'), // key: e791ji
  ]);

  /// `trash.mjs`
  static const DsLucideGlyph trash =
      DsLucideGlyph('trash', <DsIconElement>[
    DsIconPathElement('M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6'), // key: miytrc
    DsIconPathElement('M3 6h18'), // key: d0wm0j
    DsIconPathElement('M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2'), // key: e791ji
  ]);

  /// `tree-deciduous.mjs`
  static const DsLucideGlyph treeDeciduous =
      DsLucideGlyph('tree-deciduous', <DsIconElement>[
    DsIconPathElement('M8 19a4 4 0 0 1-2.24-7.32A3.5 3.5 0 0 1 9 6.03V6a3 3 0 1 1 6 0v.04a3.5 3.5 0 0 1 3.24 5.65A4 4 0 0 1 16 19Z'), // key: oadzkq
    DsIconPathElement('M12 19v3'), // key: npa21l
  ]);

  /// `tree-palm.mjs`
  static const DsLucideGlyph treePalm =
      DsLucideGlyph('tree-palm', <DsIconElement>[
    DsIconPathElement('M13 8c0-2.76-2.46-5-5.5-5S2 5.24 2 8h2l1-1 1 1h4'), // key: foxbe7
    DsIconPathElement('M13 7.14A5.82 5.82 0 0 1 16.5 6c3.04 0 5.5 2.24 5.5 5h-3l-1-1-1 1h-3'), // key: 18arnh
    DsIconPathElement('M5.89 9.71c-2.15 2.15-2.3 5.47-.35 7.43l4.24-4.25.7-.7.71-.71 2.12-2.12c-1.95-1.96-5.27-1.8-7.42.35'), // key: ywahnh
    DsIconPathElement('M11 15.5c.5 2.5-.17 4.5-1 6.5h4c2-5.5-.5-12-1-14'), // key: ft0feo
  ]);

  /// `tree-pine.mjs`
  static const DsLucideGlyph treePine =
      DsLucideGlyph('tree-pine', <DsIconElement>[
    DsIconPathElement('m17 14 3 3.3a1 1 0 0 1-.7 1.7H4.7a1 1 0 0 1-.7-1.7L7 14h-.3a1 1 0 0 1-.7-1.7L9 9h-.2A1 1 0 0 1 8 7.3L12 3l4 4.3a1 1 0 0 1-.8 1.7H15l3 3.3a1 1 0 0 1-.7 1.7H17Z'), // key: cpyugq
    DsIconPathElement('M12 22v-3'), // key: kmzjlo
  ]);

  /// `trees.mjs`
  static const DsLucideGlyph trees =
      DsLucideGlyph('trees', <DsIconElement>[
    DsIconPathElement('M10 10v.2A3 3 0 0 1 8.9 16H5a3 3 0 0 1-1-5.8V10a3 3 0 0 1 6 0Z'), // key: 1l6gj6
    DsIconPathElement('M7 16v6'), // key: 1a82de
    DsIconPathElement('M13 19v3'), // key: 13sx9i
    DsIconPathElement('M12 19h8.3a1 1 0 0 0 .7-1.7L18 14h.3a1 1 0 0 0 .7-1.7L16 9h.2a1 1 0 0 0 .8-1.7L13 3l-1.4 1.5'), // key: 1sj9kv
  ]);

  /// `trending-down.mjs`
  static const DsLucideGlyph trendingDown =
      DsLucideGlyph('trending-down', <DsIconElement>[
    DsIconPathElement('M16 17h6v-6'), // key: t6n2it
    DsIconPathElement('m22 17-8.5-8.5-5 5L2 7'), // key: x473p
  ]);

  /// `trending-up-down.mjs`
  static const DsLucideGlyph trendingUpDown =
      DsLucideGlyph('trending-up-down', <DsIconElement>[
    DsIconPathElement('M14.828 14.828 21 21'), // key: ar5fw7
    DsIconPathElement('M21 16v5h-5'), // key: 1ck2sf
    DsIconPathElement('m21 3-9 9-4-4-6 6'), // key: 1h02xo
    DsIconPathElement('M21 8V3h-5'), // key: 1qoq8a
  ]);

  /// `trending-up.mjs`
  static const DsLucideGlyph trendingUp =
      DsLucideGlyph('trending-up', <DsIconElement>[
    DsIconPathElement('M16 7h6v6'), // key: box55l
    DsIconPathElement('m22 7-8.5 8.5-5-5L2 17'), // key: 1t1m79
  ]);

  /// `triangle-alert.mjs`
  static const DsLucideGlyph triangleAlert =
      DsLucideGlyph('triangle-alert', <DsIconElement>[
    DsIconPathElement('m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3'), // key: wmoenq
    DsIconPathElement('M12 9v4'), // key: juzpu7
    DsIconPathElement('M12 17h.01'), // key: p32p05
  ]);

  /// `triangle-dashed.mjs`
  static const DsLucideGlyph triangleDashed =
      DsLucideGlyph('triangle-dashed', <DsIconElement>[
    DsIconPathElement('M10.17 4.193a2 2 0 0 1 3.666.013'), // key: pltmmw
    DsIconPathElement('M14 21h2'), // key: v4qezv
    DsIconPathElement('m15.874 7.743 1 1.732'), // key: 10m0iw
    DsIconPathElement('m18.849 12.952 1 1.732'), // key: zadnam
    DsIconPathElement('M21.824 18.18a2 2 0 0 1-1.835 2.824'), // key: fvwuk4
    DsIconPathElement('M4.024 21a2 2 0 0 1-1.839-2.839'), // key: 1e1kah
    DsIconPathElement('m5.136 12.952-1 1.732'), // key: 1u4ldi
    DsIconPathElement('M8 21h2'), // key: i9zjee
    DsIconPathElement('m8.102 7.743-1 1.732'), // key: 1zzo4u
  ]);

  /// `triangle-right.mjs`
  static const DsLucideGlyph triangleRight =
      DsLucideGlyph('triangle-right', <DsIconElement>[
    DsIconPathElement('M22 18a2 2 0 0 1-2 2H3c-1.1 0-1.3-.6-.4-1.3L20.4 4.3c.9-.7 1.6-.4 1.6.7Z'), // key: 183wce
  ]);

  /// `triangle.mjs`
  static const DsLucideGlyph triangle =
      DsLucideGlyph('triangle', <DsIconElement>[
    DsIconPathElement('M13.73 4a2 2 0 0 0-3.46 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z'), // key: 14u9p9
  ]);

  /// `trophy.mjs`
  static const DsLucideGlyph trophy =
      DsLucideGlyph('trophy', <DsIconElement>[
    DsIconPathElement('M10 14.66V17a1 1 0 0 1-1 1 2 2 0 0 0-2 2v2'), // key: pwuv1l
    DsIconPathElement('M14 14.66V17a1 1 0 0 0 1 1 2 2 0 0 1 2 2v2'), // key: 1y54w1
    DsIconPathElement('M17.916 10H19.5A2.5 2.5 0 0 0 22 7.5V5a1 1 0 0 0-1-1h-3'), // key: e30mpu
    DsIconPathElement('M4 22h16'), // key: 57wxv0
    DsIconPathElement('M6 9a6 6 0 0 0 12 0V3a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1z'), // key: 1mhfuq
    DsIconPathElement('M6.084 10H4.5A2.5 2.5 0 0 1 2 7.5V5a1 1 0 0 1 1-1h3'), // key: i0yafy
  ]);

  /// `truck-electric.mjs`
  static const DsLucideGlyph truckElectric =
      DsLucideGlyph('truck-electric', <DsIconElement>[
    DsIconPathElement('M14 19V7a2 2 0 0 0-2-2H9'), // key: 15peso
    DsIconPathElement('M15 19H9'), // key: 18q6dt
    DsIconPathElement('M19 19h2a1 1 0 0 0 1-1v-3.65a1 1 0 0 0-.22-.62L18.3 9.38a1 1 0 0 0-.78-.38H14'), // key: 1dkp3j
    DsIconPathElement('M2 13v5a1 1 0 0 0 1 1h2'), // key: pkmmzz
    DsIconPathElement('M4 3 2.15 5.15a.495.495 0 0 0 .35.86h2.15a.47.47 0 0 1 .35.86L3 9.02'), // key: 1n26pd
    DsIconCircleElement(17, 19, 2), // key: 1nxcgd
    DsIconCircleElement(7, 19, 2), // key: gzo7y7
  ]);

  /// `truck.mjs`
  static const DsLucideGlyph truck =
      DsLucideGlyph('truck', <DsIconElement>[
    DsIconPathElement('M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2'), // key: wrbu53
    DsIconPathElement('M15 18H9'), // key: 1lyqi6
    DsIconPathElement('M19 18h2a1 1 0 0 0 1-1v-3.65a1 1 0 0 0-.22-.624l-3.48-4.35A1 1 0 0 0 17.52 8H14'), // key: lysw3i
    DsIconCircleElement(17, 18, 2), // key: 332jqn
    DsIconCircleElement(7, 18, 2), // key: 19iecd
  ]);

  /// `turkish-lira.mjs`
  static const DsLucideGlyph turkishLira =
      DsLucideGlyph('turkish-lira', <DsIconElement>[
    DsIconPathElement('M15 4 5 9'), // key: 14bkc9
    DsIconPathElement('m15 8.5-10 5'), // key: 1grtsx
    DsIconPathElement('M18 12a9 9 0 0 1-9 9V3'), // key: 1sst7f
  ]);

  /// `turntable.mjs`
  static const DsLucideGlyph turntable =
      DsLucideGlyph('turntable', <DsIconElement>[
    DsIconPathElement('M10 12.01h.01'), // key: 7rp0yl
    DsIconPathElement('M18 8v4a8 8 0 0 1-1.07 4'), // key: 1st48v
    DsIconCircleElement(10, 12, 4), // key: 19levz
    DsIconRectElement(2, 4, 20, 16, 2), // key: izxlao
  ]);

  /// `turtle.mjs`
  static const DsLucideGlyph turtle =
      DsLucideGlyph('turtle', <DsIconElement>[
    DsIconPathElement('m12 10 2 4v3a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1v-3a8 8 0 1 0-16 0v3a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1v-3l2-4h4Z'), // key: 1lbbv7
    DsIconPathElement('M4.82 7.9 8 10'), // key: m9wose
    DsIconPathElement('M15.18 7.9 12 10'), // key: p8dp2u
    DsIconPathElement('M16.93 10H20a2 2 0 0 1 0 4H2'), // key: 12nsm7
  ]);

  /// `tv-minimal-play.mjs`
  static const DsLucideGlyph tvMinimalPlay =
      DsLucideGlyph('tv-minimal-play', <DsIconElement>[
    DsIconPathElement('M15.033 9.44a.647.647 0 0 1 0 1.12l-4.065 2.352a.645.645 0 0 1-.968-.56V7.648a.645.645 0 0 1 .967-.56z'), // key: vbtd3f
    DsIconPathElement('M7 21h10'), // key: 1b0cd5
    DsIconRectElement(2, 3, 20, 14, 2), // key: 48i651
  ]);

  /// `tv-minimal.mjs`
  static const DsLucideGlyph tvMinimal =
      DsLucideGlyph('tv-minimal', <DsIconElement>[
    DsIconPathElement('M7 21h10'), // key: 1b0cd5
    DsIconRectElement(2, 3, 20, 14, 2), // key: 48i651
  ]);

  /// `tv.mjs`
  static const DsLucideGlyph tv =
      DsLucideGlyph('tv', <DsIconElement>[
    DsIconPathElement('m17 2-5 5-5-5'), // key: 16satq
    DsIconRectElement(2, 7, 20, 15, 2), // key: 1e6viu
  ]);

  /// `type-outline.mjs`
  static const DsLucideGlyph typeOutline =
      DsLucideGlyph('type-outline', <DsIconElement>[
    DsIconPathElement('M14 16.5a.5.5 0 0 0 .5.5h.5a2 2 0 0 1 0 4H9a2 2 0 0 1 0-4h.5a.5.5 0 0 0 .5-.5v-9a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5V8a2 2 0 0 1-4 0V5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v3a2 2 0 0 1-4 0v-.5a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5Z'), // key: 1reda3
  ]);

  /// `type.mjs`
  static const DsLucideGlyph type =
      DsLucideGlyph('type', <DsIconElement>[
    DsIconPathElement('M12 4v16'), // key: 1654pz
    DsIconPathElement('M4 7V5a1 1 0 0 1 1-1h14a1 1 0 0 1 1 1v2'), // key: e0r10z
    DsIconPathElement('M9 20h6'), // key: s66wpe
  ]);

  /// `umbrella-off.mjs`
  static const DsLucideGlyph umbrellaOff =
      DsLucideGlyph('umbrella-off', <DsIconElement>[
    DsIconPathElement('M12 13v7a2 2 0 0 0 4 0'), // key: rpgb42
    DsIconPathElement('M12 2v2'), // key: tus03m
    DsIconPathElement('M18.656 13h2.336a1 1 0 0 0 .97-1.274 10.284 10.284 0 0 0-12.07-7.51'), // key: yawknk
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M5.961 5.957a10.28 10.28 0 0 0-3.922 5.769A1 1 0 0 0 3 13h10'), // key: 5sfalc
  ]);

  /// `umbrella.mjs`
  static const DsLucideGlyph umbrella =
      DsLucideGlyph('umbrella', <DsIconElement>[
    DsIconPathElement('M12 13v7a2 2 0 0 0 4 0'), // key: rpgb42
    DsIconPathElement('M12 2v2'), // key: tus03m
    DsIconPathElement('M20.992 13a1 1 0 0 0 .97-1.274 10.284 10.284 0 0 0-19.923 0A1 1 0 0 0 3 13z'), // key: 124nyo
  ]);

  /// `underline.mjs`
  static const DsLucideGlyph underline =
      DsLucideGlyph('underline', <DsIconElement>[
    DsIconPathElement('M6 4v6a6 6 0 0 0 12 0V4'), // key: 9kb039
    DsIconLineElement(4, 20, 20, 20), // key: nun2al
  ]);

  /// `undo-2.mjs`
  static const DsLucideGlyph undo2 =
      DsLucideGlyph('undo-2', <DsIconElement>[
    DsIconPathElement('M9 14 4 9l5-5'), // key: 102s5s
    DsIconPathElement('M4 9h10.5a5.5 5.5 0 0 1 5.5 5.5a5.5 5.5 0 0 1-5.5 5.5H11'), // key: f3b9sd
  ]);

  /// `undo-dot.mjs`
  static const DsLucideGlyph undoDot =
      DsLucideGlyph('undo-dot', <DsIconElement>[
    DsIconPathElement('M21 17a9 9 0 0 0-15-6.7L3 13'), // key: 8mp6z9
    DsIconPathElement('M3 7v6h6'), // key: 1v2h90
    DsIconCircleElement(12, 17, 1), // key: 1ixnty
  ]);

  /// `undo.mjs`
  static const DsLucideGlyph undo =
      DsLucideGlyph('undo', <DsIconElement>[
    DsIconPathElement('M3 7v6h6'), // key: 1v2h90
    DsIconPathElement('M21 17a9 9 0 0 0-9-9 9 9 0 0 0-6 2.3L3 13'), // key: 1r6uu6
  ]);

  /// `unfold-horizontal.mjs`
  static const DsLucideGlyph unfoldHorizontal =
      DsLucideGlyph('unfold-horizontal', <DsIconElement>[
    DsIconPathElement('M16 12h6'), // key: 15xry1
    DsIconPathElement('M8 12H2'), // key: 1jqql6
    DsIconPathElement('M12 2v2'), // key: tus03m
    DsIconPathElement('M12 8v2'), // key: 1woqiv
    DsIconPathElement('M12 14v2'), // key: 8jcxud
    DsIconPathElement('M12 20v2'), // key: 1lh1kg
    DsIconPathElement('m19 15 3-3-3-3'), // key: wjy7rq
    DsIconPathElement('m5 9-3 3 3 3'), // key: j64kie
  ]);

  /// `unfold-vertical.mjs`
  static const DsLucideGlyph unfoldVertical =
      DsLucideGlyph('unfold-vertical', <DsIconElement>[
    DsIconPathElement('M12 22v-6'), // key: 6o8u61
    DsIconPathElement('M12 8V2'), // key: 1wkif3
    DsIconPathElement('M4 12H2'), // key: rhcxmi
    DsIconPathElement('M10 12H8'), // key: s88cx1
    DsIconPathElement('M16 12h-2'), // key: 10asgb
    DsIconPathElement('M22 12h-2'), // key: 14jgyd
    DsIconPathElement('m15 19-3 3-3-3'), // key: 11eu04
    DsIconPathElement('m15 5-3-3-3 3'), // key: itvq4r
  ]);

  /// `ungroup.mjs`
  static const DsLucideGlyph ungroup =
      DsLucideGlyph('ungroup', <DsIconElement>[
    DsIconRectElement(11, 14, 10, 7, 2), // key: nfm8rk
    DsIconRectElement(3, 3, 10, 7, 2), // key: 1ljebb
  ]);

  /// `university.mjs`
  static const DsLucideGlyph university =
      DsLucideGlyph('university', <DsIconElement>[
    DsIconPathElement('M14 21v-3a2 2 0 0 0-4 0v3'), // key: 1rgiei
    DsIconPathElement('M18 12h.01'), // key: yjnet6
    DsIconPathElement('M18 16h.01'), // key: plv8zi
    DsIconPathElement('M22 7a1 1 0 0 0-1-1h-2a2 2 0 0 1-1.143-.359L13.143 2.36a2 2 0 0 0-2.286-.001L6.143 5.64A2 2 0 0 1 5 6H3a1 1 0 0 0-1 1v12a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2z'), // key: 1ogmi3
    DsIconPathElement('M6 12h.01'), // key: c2rlol
    DsIconPathElement('M6 16h.01'), // key: 1pmjb7
    DsIconCircleElement(12, 10, 2), // key: 1yojzk
  ]);

  /// `unlink-2.mjs`
  static const DsLucideGlyph unlink2 =
      DsLucideGlyph('unlink-2', <DsIconElement>[
    DsIconPathElement('M15 7h2a5 5 0 0 1 0 10h-2m-6 0H7A5 5 0 0 1 7 7h2'), // key: 1re2ne
  ]);

  /// `unlink.mjs`
  static const DsLucideGlyph unlink =
      DsLucideGlyph('unlink', <DsIconElement>[
    DsIconPathElement('m18.84 12.25 1.72-1.71h-.02a5.004 5.004 0 0 0-.12-7.07 5.006 5.006 0 0 0-6.95 0l-1.72 1.71'), // key: yqzxt4
    DsIconPathElement('m5.17 11.75-1.71 1.71a5.004 5.004 0 0 0 .12 7.07 5.006 5.006 0 0 0 6.95 0l1.71-1.71'), // key: 4qinb0
    DsIconLineElement(8, 2, 8, 5), // key: 1041cp
    DsIconLineElement(2, 8, 5, 8), // key: 14m1p5
    DsIconLineElement(16, 19, 16, 22), // key: rzdirn
    DsIconLineElement(19, 16, 22, 16), // key: ox905f
  ]);

  /// `unplug.mjs`
  static const DsLucideGlyph unplug =
      DsLucideGlyph('unplug', <DsIconElement>[
    DsIconPathElement('m19 5 3-3'), // key: yk6iyv
    DsIconPathElement('m2 22 3-3'), // key: 19mgm9
    DsIconPathElement('M6.3 20.3a2.4 2.4 0 0 0 3.4 0L12 18l-6-6-2.3 2.3a2.4 2.4 0 0 0 0 3.4Z'), // key: goz73y
    DsIconPathElement('M7.5 13.5 10 11'), // key: 7xgeeb
    DsIconPathElement('M10.5 16.5 13 14'), // key: 10btkg
    DsIconPathElement('m12 6 6 6 2.3-2.3a2.4 2.4 0 0 0 0-3.4l-2.6-2.6a2.4 2.4 0 0 0-3.4 0Z'), // key: 1snsnr
  ]);

  /// `upload.mjs`
  static const DsLucideGlyph upload =
      DsLucideGlyph('upload', <DsIconElement>[
    DsIconPathElement('M12 3v12'), // key: 1x0j5s
    DsIconPathElement('m17 8-5-5-5 5'), // key: 7q97r8
    DsIconPathElement('M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4'), // key: ih7n3h
  ]);

  /// `usb.mjs`
  static const DsLucideGlyph usb =
      DsLucideGlyph('usb', <DsIconElement>[
    DsIconCircleElement(10, 7, 1), // key: dypaad
    DsIconCircleElement(4, 20, 1), // key: 22iqad
    DsIconPathElement('M4.7 19.3 19 5'), // key: 1enqfc
    DsIconPathElement('m21 3-3 1 2 2Z'), // key: d3ov82
    DsIconPathElement('M9.26 7.68 5 12l2 5'), // key: 1esawj
    DsIconPathElement('m10 14 5 2 3.5-3.5'), // key: v8oal5
    DsIconPathElement('m18 12 1-1 1 1-1 1Z'), // key: 1bh22v
  ]);

  /// `user-check.mjs`
  static const DsLucideGlyph userCheck =
      DsLucideGlyph('user-check', <DsIconElement>[
    DsIconPathElement('m16 11 2 2 4-4'), // key: 9rsbq5
    DsIconPathElement('M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2'), // key: 1yyitq
    DsIconCircleElement(9, 7, 4), // key: nufk8
  ]);

  /// `user-cog.mjs`
  static const DsLucideGlyph userCog =
      DsLucideGlyph('user-cog', <DsIconElement>[
    DsIconPathElement('M10 15H6a4 4 0 0 0-4 4v2'), // key: 1nfge6
    DsIconPathElement('m14.305 16.53.923-.382'), // key: 1itpsq
    DsIconPathElement('m15.228 13.852-.923-.383'), // key: eplpkm
    DsIconPathElement('m16.852 12.228-.383-.923'), // key: 13v3q0
    DsIconPathElement('m16.852 17.772-.383.924'), // key: 1i8mnm
    DsIconPathElement('m19.148 12.228.383-.923'), // key: 1q8j1v
    DsIconPathElement('m19.53 18.696-.382-.924'), // key: vk1qj3
    DsIconPathElement('m20.772 13.852.924-.383'), // key: n880s0
    DsIconPathElement('m20.772 16.148.924.383'), // key: 1g6xey
    DsIconCircleElement(18, 15, 3), // key: gjjjvw
    DsIconCircleElement(9, 7, 4), // key: nufk8
  ]);

  /// `user-key.mjs`
  static const DsLucideGlyph userKey =
      DsLucideGlyph('user-key', <DsIconElement>[
    DsIconPathElement('M20 11v6'), // key: d77pzp
    DsIconPathElement('M20 13h2'), // key: 16rner
    DsIconPathElement('M3 21v-2a4 4 0 0 1 4-4h6a4 4 0 0 1 2.072.578'), // key: 1yxgtw
    DsIconCircleElement(10, 7, 4), // key: e45bow
    DsIconCircleElement(20, 19, 2), // key: 1obnsp
  ]);

  /// `user-lock.mjs`
  static const DsLucideGlyph userLock =
      DsLucideGlyph('user-lock', <DsIconElement>[
    DsIconPathElement('M19 16v-2a2 2 0 0 0-4 0v2'), // key: 17sujf
    DsIconPathElement('M9.5 15H7a4 4 0 0 0-4 4v2'), // key: 9it25y
    DsIconCircleElement(10, 7, 4), // key: e45bow
    DsIconRectElement(13, 16, 8, 5, 0.899), // key: ur80nz
  ]);

  /// `user-minus.mjs`
  static const DsLucideGlyph userMinus =
      DsLucideGlyph('user-minus', <DsIconElement>[
    DsIconPathElement('M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2'), // key: 1yyitq
    DsIconCircleElement(9, 7, 4), // key: nufk8
    DsIconLineElement(22, 11, 16, 11), // key: 1shjgl
  ]);

  /// `user-pen.mjs`
  static const DsLucideGlyph userPen =
      DsLucideGlyph('user-pen', <DsIconElement>[
    DsIconPathElement('M11.5 15H7a4 4 0 0 0-4 4v2'), // key: 15lzij
    DsIconPathElement('M21.378 16.626a1 1 0 0 0-3.004-3.004l-4.01 4.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z'), // key: 1817ys
    DsIconCircleElement(10, 7, 4), // key: e45bow
  ]);

  /// `user-plus.mjs`
  static const DsLucideGlyph userPlus =
      DsLucideGlyph('user-plus', <DsIconElement>[
    DsIconPathElement('M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2'), // key: 1yyitq
    DsIconCircleElement(9, 7, 4), // key: nufk8
    DsIconLineElement(19, 8, 19, 14), // key: 1bvyxn
    DsIconLineElement(22, 11, 16, 11), // key: 1shjgl
  ]);

  /// `user-round-arrow-left.mjs`
  static const DsLucideGlyph userRoundArrowLeft =
      DsLucideGlyph('user-round-arrow-left', <DsIconElement>[
    DsIconPathElement('m19 16-3 3'), // key: lp3y45
    DsIconPathElement('M2 21a8 8 0 0 1 12.664-6.5'), // key: 1ap0vn
    DsIconPathElement('M22 19h-6l3 3'), // key: 13fjle
    DsIconCircleElement(10, 8, 5), // key: o932ke
  ]);

  /// `user-round-check.mjs`
  static const DsLucideGlyph userRoundCheck =
      DsLucideGlyph('user-round-check', <DsIconElement>[
    DsIconPathElement('M2 21a8 8 0 0 1 13.292-6'), // key: bjp14o
    DsIconCircleElement(10, 8, 5), // key: o932ke
    DsIconPathElement('m16 19 2 2 4-4'), // key: 1b14m6
  ]);

  /// `user-round-cog.mjs`
  static const DsLucideGlyph userRoundCog =
      DsLucideGlyph('user-round-cog', <DsIconElement>[
    DsIconPathElement('m14.305 19.53.923-.382'), // key: 3m78fa
    DsIconPathElement('m15.228 16.852-.923-.383'), // key: npixar
    DsIconPathElement('m16.852 15.228-.383-.923'), // key: 5xggr7
    DsIconPathElement('m16.852 20.772-.383.924'), // key: dpfhf9
    DsIconPathElement('m19.148 15.228.383-.923'), // key: 1reyyz
    DsIconPathElement('m19.53 21.696-.382-.924'), // key: 1goivc
    DsIconPathElement('M2 21a8 8 0 0 1 10.434-7.62'), // key: 1yezr2
    DsIconPathElement('m20.772 16.852.924-.383'), // key: htqkph
    DsIconPathElement('m20.772 19.148.924.383'), // key: 9w9pjp
    DsIconCircleElement(10, 8, 5), // key: o932ke
    DsIconCircleElement(18, 18, 3), // key: 1xkwt0
  ]);

  /// `user-round-key.mjs`
  static const DsLucideGlyph userRoundKey =
      DsLucideGlyph('user-round-key', <DsIconElement>[
    DsIconPathElement('M19 11v6'), // key: rcqigv
    DsIconPathElement('M19 13h2'), // key: 1gch44
    DsIconPathElement('M2 21a8 8 0 0 1 12.868-6.349'), // key: 1lryzn
    DsIconCircleElement(10, 8, 5), // key: o932ke
    DsIconCircleElement(19, 19, 2), // key: 17f5cg
  ]);

  /// `user-round-minus.mjs`
  static const DsLucideGlyph userRoundMinus =
      DsLucideGlyph('user-round-minus', <DsIconElement>[
    DsIconPathElement('M2 21a8 8 0 0 1 13.292-6'), // key: bjp14o
    DsIconCircleElement(10, 8, 5), // key: o932ke
    DsIconPathElement('M22 19h-6'), // key: vcuq98
  ]);

  /// `user-round-pen.mjs`
  static const DsLucideGlyph userRoundPen =
      DsLucideGlyph('user-round-pen', <DsIconElement>[
    DsIconPathElement('M2 21a8 8 0 0 1 10.821-7.487'), // key: 1c8h7z
    DsIconPathElement('M21.378 16.626a1 1 0 0 0-3.004-3.004l-4.01 4.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z'), // key: 1817ys
    DsIconCircleElement(10, 8, 5), // key: o932ke
  ]);

  /// `user-round-plus.mjs`
  static const DsLucideGlyph userRoundPlus =
      DsLucideGlyph('user-round-plus', <DsIconElement>[
    DsIconPathElement('M2 21a8 8 0 0 1 13.292-6'), // key: bjp14o
    DsIconCircleElement(10, 8, 5), // key: o932ke
    DsIconPathElement('M19 16v6'), // key: tddt3s
    DsIconPathElement('M22 19h-6'), // key: vcuq98
  ]);

  /// `user-round-search.mjs`
  static const DsLucideGlyph userRoundSearch =
      DsLucideGlyph('user-round-search', <DsIconElement>[
    DsIconCircleElement(10, 8, 5), // key: o932ke
    DsIconPathElement('M2 21a8 8 0 0 1 10.434-7.62'), // key: 1yezr2
    DsIconCircleElement(18, 18, 3), // key: 1xkwt0
    DsIconPathElement('m22 22-1.9-1.9'), // key: 1e5ubv
  ]);

  /// `user-round-x.mjs`
  static const DsLucideGlyph userRoundX =
      DsLucideGlyph('user-round-x', <DsIconElement>[
    DsIconPathElement('M2 21a8 8 0 0 1 11.873-7'), // key: 74fkxq
    DsIconCircleElement(10, 8, 5), // key: o932ke
    DsIconPathElement('m17 17 5 5'), // key: p7ous7
    DsIconPathElement('m22 17-5 5'), // key: gqnmv0
  ]);

  /// `user-round.mjs`
  static const DsLucideGlyph userRound =
      DsLucideGlyph('user-round', <DsIconElement>[
    DsIconCircleElement(12, 8, 5), // key: 1hypcn
    DsIconPathElement('M20 21a8 8 0 0 0-16 0'), // key: rfgkzh
  ]);

  /// `user-search.mjs`
  static const DsLucideGlyph userSearch =
      DsLucideGlyph('user-search', <DsIconElement>[
    DsIconCircleElement(10, 7, 4), // key: e45bow
    DsIconPathElement('M10.3 15H7a4 4 0 0 0-4 4v2'), // key: 3bnktk
    DsIconCircleElement(17, 17, 3), // key: 18b49y
    DsIconPathElement('m21 21-1.9-1.9'), // key: 1g2n9r
  ]);

  /// `user-shield.mjs`
  static const DsLucideGlyph userShield =
      DsLucideGlyph('user-shield', <DsIconElement>[
    DsIconPathElement('M10 15H6a4 4 0 0 0-4 4v2'), // key: 1nfge6
    DsIconPathElement('M22 17.5c0 2.499-1.75 3.749-3.83 4.474a.5.5 0 0 1-.335-.005c-2.085-.72-3.835-1.97-3.835-4.47V14a.5.5 0 0 1 .5-.499c1 0 2.25-.6 3.12-1.36a.6.6 0 0 1 .76-.001c.875.765 2.12 1.36 3.12 1.36a.5.5 0 0 1 .5.5z'), // key: 16j3tf
    DsIconCircleElement(9, 7, 4), // key: nufk8
  ]);

  /// `user-star.mjs`
  static const DsLucideGlyph userStar =
      DsLucideGlyph('user-star', <DsIconElement>[
    DsIconPathElement('M16.051 12.616a1 1 0 0 1 1.909.024l.737 1.452a1 1 0 0 0 .737.535l1.634.256a1 1 0 0 1 .588 1.806l-1.172 1.168a1 1 0 0 0-.282.866l.259 1.613a1 1 0 0 1-1.541 1.134l-1.465-.75a1 1 0 0 0-.912 0l-1.465.75a1 1 0 0 1-1.539-1.133l.258-1.613a1 1 0 0 0-.282-.866l-1.156-1.153a1 1 0 0 1 .572-1.822l1.633-.256a1 1 0 0 0 .737-.535z'), // key: 1m8t9f
    DsIconPathElement('M8 15H7a4 4 0 0 0-4 4v2'), // key: l9tmp8
    DsIconCircleElement(10, 7, 4), // key: e45bow
  ]);

  /// `user-x.mjs`
  static const DsLucideGlyph userX =
      DsLucideGlyph('user-x', <DsIconElement>[
    DsIconPathElement('M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2'), // key: 1yyitq
    DsIconCircleElement(9, 7, 4), // key: nufk8
    DsIconLineElement(17, 8, 22, 13), // key: 3nzzx3
    DsIconLineElement(22, 8, 17, 13), // key: 1swrse
  ]);

  /// `user.mjs`
  static const DsLucideGlyph user =
      DsLucideGlyph('user', <DsIconElement>[
    DsIconPathElement('M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2'), // key: 975kel
    DsIconCircleElement(12, 7, 4), // key: 17ys0d
  ]);

  /// `users-round.mjs`
  static const DsLucideGlyph usersRound =
      DsLucideGlyph('users-round', <DsIconElement>[
    DsIconPathElement('M18 21a8 8 0 0 0-16 0'), // key: 3ypg7q
    DsIconCircleElement(10, 8, 5), // key: o932ke
    DsIconPathElement('M22 20c0-3.37-2-6.5-4-8a5 5 0 0 0-.45-8.3'), // key: 10s06x
  ]);

  /// `users.mjs`
  static const DsLucideGlyph users =
      DsLucideGlyph('users', <DsIconElement>[
    DsIconPathElement('M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2'), // key: 1yyitq
    DsIconPathElement('M16 3.128a4 4 0 0 1 0 7.744'), // key: 16gr8j
    DsIconPathElement('M22 21v-2a4 4 0 0 0-3-3.87'), // key: kshegd
    DsIconCircleElement(9, 7, 4), // key: nufk8
  ]);

  /// `utensils-crossed.mjs`
  static const DsLucideGlyph utensilsCrossed =
      DsLucideGlyph('utensils-crossed', <DsIconElement>[
    DsIconPathElement('m16 2-2.3 2.3a3 3 0 0 0 0 4.2l1.8 1.8a3 3 0 0 0 4.2 0L22 8'), // key: n7qcjb
    DsIconPathElement('M15 15 3.3 3.3a4.2 4.2 0 0 0 0 6l7.3 7.3c.7.7 2 .7 2.8 0L15 15Zm0 0 7 7'), // key: d0u48b
    DsIconPathElement('m2.1 21.8 6.4-6.3'), // key: yn04lh
    DsIconPathElement('m19 5-7 7'), // key: 194lzd
  ]);

  /// `utensils.mjs`
  static const DsLucideGlyph utensils =
      DsLucideGlyph('utensils', <DsIconElement>[
    DsIconPathElement('M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2'), // key: cjf0a3
    DsIconPathElement('M7 2v20'), // key: 1473qp
    DsIconPathElement('M21 15V2a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3Zm0 0v7'), // key: j28e5
  ]);

  /// `utility-pole.mjs`
  static const DsLucideGlyph utilityPole =
      DsLucideGlyph('utility-pole', <DsIconElement>[
    DsIconPathElement('M12 2v20'), // key: t6zp3m
    DsIconPathElement('M2 5h20'), // key: 1fs1ex
    DsIconPathElement('M3 3v2'), // key: 9imdir
    DsIconPathElement('M7 3v2'), // key: n0os7
    DsIconPathElement('M17 3v2'), // key: 1l2re6
    DsIconPathElement('M21 3v2'), // key: 1duuac
    DsIconPathElement('m19 5-7 7-7-7'), // key: 133zxf
  ]);

  /// `van.mjs`
  static const DsLucideGlyph van =
      DsLucideGlyph('van', <DsIconElement>[
    DsIconPathElement('M13 6v5a1 1 0 0 0 1 1h6.102a1 1 0 0 1 .712.298l.898.91a1 1 0 0 1 .288.702V17a1 1 0 0 1-1 1h-3'), // key: k3s650
    DsIconPathElement('M5 18H3a1 1 0 0 1-1-1V8a2 2 0 0 1 2-2h12c1.1 0 2.1.8 2.4 1.8l1.176 4.2'), // key: fnd93u
    DsIconPathElement('M9 18h5'), // key: lrx6i
    DsIconCircleElement(16, 18, 2), // key: 1v4tcr
    DsIconCircleElement(7, 18, 2), // key: 19iecd
  ]);

  /// `variable.mjs`
  static const DsLucideGlyph variable =
      DsLucideGlyph('variable', <DsIconElement>[
    DsIconPathElement('M8 21s-4-3-4-9 4-9 4-9'), // key: uto9ud
    DsIconPathElement('M16 3s4 3 4 9-4 9-4 9'), // key: 4w2vsq
    DsIconLineElement(15, 9, 9, 15), // key: f7djnv
    DsIconLineElement(9, 9, 15, 15), // key: 1shsy8
  ]);

  /// `vault.mjs`
  static const DsLucideGlyph vault =
      DsLucideGlyph('vault', <DsIconElement>[
    DsIconRectElement(3, 3, 18, 18, 2), // key: afitv7
    DsIconCircleElement(7.5, 7.5, 0.5, filled: true), // key: kqv944
    DsIconPathElement('m7.9 7.9 2.7 2.7'), // key: hpeyl3
    DsIconCircleElement(16.5, 7.5, 0.5, filled: true), // key: w0ekpg
    DsIconPathElement('m13.4 10.6 2.7-2.7'), // key: 264c1n
    DsIconCircleElement(7.5, 16.5, 0.5, filled: true), // key: nkw3mc
    DsIconPathElement('m7.9 16.1 2.7-2.7'), // key: p81g5e
    DsIconCircleElement(16.5, 16.5, 0.5, filled: true), // key: fubopw
    DsIconPathElement('m13.4 13.4 2.7 2.7'), // key: abhel3
    DsIconCircleElement(12, 12, 2), // key: 1c9p78
  ]);

  /// `vector-square.mjs`
  static const DsLucideGlyph vectorSquare =
      DsLucideGlyph('vector-square', <DsIconElement>[
    DsIconPathElement('M19.5 7a24 24 0 0 1 0 10'), // key: 8n60xe
    DsIconPathElement('M4.5 7a24 24 0 0 0 0 10'), // key: 2lmadr
    DsIconPathElement('M7 19.5a24 24 0 0 0 10 0'), // key: 1q94o2
    DsIconPathElement('M7 4.5a24 24 0 0 1 10 0'), // key: 2z8ypa
    DsIconRectElement(17, 17, 5, 5, 1), // key: 1ac74s
    DsIconRectElement(17, 2, 5, 5, 1), // key: 1e7h5j
    DsIconRectElement(2, 17, 5, 5, 1), // key: 1t4eah
    DsIconRectElement(2, 2, 5, 5, 1), // key: 940dhs
  ]);

  /// `vegan.mjs`
  static const DsLucideGlyph vegan =
      DsLucideGlyph('vegan', <DsIconElement>[
    DsIconPathElement('M16 8q6 0 6-6-6 0-6 6'), // key: qsyyc4
    DsIconPathElement('M17.41 3.59a10 10 0 1 0 3 3'), // key: 41m9h7
    DsIconPathElement('M2 2a26.6 26.6 0 0 1 10 20c.9-6.82 1.5-9.5 4-14'), // key: qiv7li
  ]);

  /// `venetian-mask.mjs`
  static const DsLucideGlyph venetianMask =
      DsLucideGlyph('venetian-mask', <DsIconElement>[
    DsIconPathElement('M18 11c-1.5 0-2.5.5-3 2'), // key: 1fod00
    DsIconPathElement('M4 6a2 2 0 0 0-2 2v4a5 5 0 0 0 5 5 8 8 0 0 1 5 2 8 8 0 0 1 5-2 5 5 0 0 0 5-5V8a2 2 0 0 0-2-2h-3a8 8 0 0 0-5 2 8 8 0 0 0-5-2z'), // key: d70hit
    DsIconPathElement('M6 11c1.5 0 2.5.5 3 2'), // key: 136fht
  ]);

  /// `venus-and-mars.mjs`
  static const DsLucideGlyph venusAndMars =
      DsLucideGlyph('venus-and-mars', <DsIconElement>[
    DsIconPathElement('M10 20h4'), // key: ni2waw
    DsIconPathElement('M12 16v6'), // key: c8a4gj
    DsIconPathElement('M17 2h4v4'), // key: vhe59
    DsIconPathElement('m21 2-5.46 5.46'), // key: 19kypf
    DsIconCircleElement(12, 11, 5), // key: 16gxyc
  ]);

  /// `venus.mjs`
  static const DsLucideGlyph venus =
      DsLucideGlyph('venus', <DsIconElement>[
    DsIconPathElement('M12 15v7'), // key: t2xh3l
    DsIconPathElement('M9 19h6'), // key: 456am0
    DsIconCircleElement(12, 9, 6), // key: 1nw4tq
  ]);

  /// `vibrate-off.mjs`
  static const DsLucideGlyph vibrateOff =
      DsLucideGlyph('vibrate-off', <DsIconElement>[
    DsIconPathElement('m2 8 2 2-2 2 2 2-2 2'), // key: sv1b1
    DsIconPathElement('m22 8-2 2 2 2-2 2 2 2'), // key: 101i4y
    DsIconPathElement('M8 8v10c0 .55.45 1 1 1h6c.55 0 1-.45 1-1v-2'), // key: 1hbad5
    DsIconPathElement('M16 10.34V6c0-.55-.45-1-1-1h-4.34'), // key: 1x5tf0
    DsIconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `vibrate.mjs`
  static const DsLucideGlyph vibrate =
      DsLucideGlyph('vibrate', <DsIconElement>[
    DsIconPathElement('m2 8 2 2-2 2 2 2-2 2'), // key: sv1b1
    DsIconPathElement('m22 8-2 2 2 2-2 2 2 2'), // key: 101i4y
    DsIconRectElement(8, 5, 8, 14, 1), // key: 1oyrl4
  ]);

  /// `video-off.mjs`
  static const DsLucideGlyph videoOff =
      DsLucideGlyph('video-off', <DsIconElement>[
    DsIconPathElement('M10.66 6H14a2 2 0 0 1 2 2v2.5l5.248-3.062A.5.5 0 0 1 22 7.87v8.196'), // key: w8jjjt
    DsIconPathElement('M16 16a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h2'), // key: 1xawa7
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `video.mjs`
  static const DsLucideGlyph video =
      DsLucideGlyph('video', <DsIconElement>[
    DsIconPathElement('m16 13 5.223 3.482a.5.5 0 0 0 .777-.416V7.87a.5.5 0 0 0-.752-.432L16 10.5'), // key: ftymec
    DsIconRectElement(2, 6, 14, 12, 2), // key: 158x01
  ]);

  /// `videotape.mjs`
  static const DsLucideGlyph videotape =
      DsLucideGlyph('videotape', <DsIconElement>[
    DsIconRectElement(2, 4, 20, 16, 2), // key: 18n3k1
    DsIconPathElement('M2 8h20'), // key: d11cs7
    DsIconCircleElement(8, 14, 2), // key: 1k2qr5
    DsIconPathElement('M8 12h8'), // key: 1wcyev
    DsIconCircleElement(16, 14, 2), // key: 14k7lr
  ]);

  /// `view.mjs`
  static const DsLucideGlyph view =
      DsLucideGlyph('view', <DsIconElement>[
    DsIconPathElement('M21 17v2a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-2'), // key: mrq65r
    DsIconPathElement('M21 7V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v2'), // key: be3xqs
    DsIconCircleElement(12, 12, 1), // key: 41hilf
    DsIconPathElement('M18.944 12.33a1 1 0 0 0 0-.66 7.5 7.5 0 0 0-13.888 0 1 1 0 0 0 0 .66 7.5 7.5 0 0 0 13.888 0'), // key: 11ak4c
  ]);

  /// `voicemail.mjs`
  static const DsLucideGlyph voicemail =
      DsLucideGlyph('voicemail', <DsIconElement>[
    DsIconCircleElement(6, 12, 4), // key: 1ehtga
    DsIconCircleElement(18, 12, 4), // key: 4vafl8
    DsIconLineElement(6, 16, 18, 16), // key: pmt8us
  ]);

  /// `volleyball.mjs`
  static const DsLucideGlyph volleyball =
      DsLucideGlyph('volleyball', <DsIconElement>[
    DsIconPathElement('M11 7a16 16 20 0 1 10.98 4.362'), // key: 1mmfx7
    DsIconPathElement('M12 12a13 13 0 0 1-8.66 5'), // key: 14sm5y
    DsIconPathElement('M16.83 13.634a16 16 0 0 1-9.267 7.328'), // key: j0eyj5
    DsIconPathElement('M20.66 17A13 13 0 0 0 12 12a13 13 0 0 1 0-10'), // key: qaetsw
    DsIconPathElement('M8.17 15.366a16 16 0 0 1-1.713-11.69'), // key: 17ewdd
    DsIconCircleElement(12, 12, 10), // key: 1mglay
  ]);

  /// `volume-1.mjs`
  static const DsLucideGlyph volume1 =
      DsLucideGlyph('volume-1', <DsIconElement>[
    DsIconPathElement('M11 4.702a.705.705 0 0 0-1.203-.498L6.413 7.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298z'), // key: uqj9uw
    DsIconPathElement('M16 9a5 5 0 0 1 0 6'), // key: 1q6k2b
  ]);

  /// `volume-2.mjs`
  static const DsLucideGlyph volume2 =
      DsLucideGlyph('volume-2', <DsIconElement>[
    DsIconPathElement('M11 4.702a.705.705 0 0 0-1.203-.498L6.413 7.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298z'), // key: uqj9uw
    DsIconPathElement('M16 9a5 5 0 0 1 0 6'), // key: 1q6k2b
    DsIconPathElement('M19.364 18.364a9 9 0 0 0 0-12.728'), // key: ijwkga
  ]);

  /// `volume-off.mjs`
  static const DsLucideGlyph volumeOff =
      DsLucideGlyph('volume-off', <DsIconElement>[
    DsIconPathElement('M16 9a5 5 0 0 1 .95 2.293'), // key: 1fgyg8
    DsIconPathElement('M19.364 5.636a9 9 0 0 1 1.889 9.96'), // key: l3zxae
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('m7 7-.587.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298V11'), // key: 1gbwow
    DsIconPathElement('M9.828 4.172A.686.686 0 0 1 11 4.657v.686'), // key: s2je0y
  ]);

  /// `volume-x.mjs`
  static const DsLucideGlyph volumeX =
      DsLucideGlyph('volume-x', <DsIconElement>[
    DsIconPathElement('M11 4.702a.705.705 0 0 0-1.203-.498L6.413 7.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298z'), // key: uqj9uw
    DsIconLineElement(22, 9, 16, 15), // key: 1ewh16
    DsIconLineElement(16, 9, 22, 15), // key: 5ykzw1
  ]);

  /// `volume.mjs`
  static const DsLucideGlyph volume =
      DsLucideGlyph('volume', <DsIconElement>[
    DsIconPathElement('M11 4.702a.705.705 0 0 0-1.203-.498L6.413 7.587A1.4 1.4 0 0 1 5.416 8H3a1 1 0 0 0-1 1v6a1 1 0 0 0 1 1h2.416a1.4 1.4 0 0 1 .997.413l3.383 3.384A.705.705 0 0 0 11 19.298z'), // key: uqj9uw
  ]);

  /// `vote.mjs`
  static const DsLucideGlyph vote =
      DsLucideGlyph('vote', <DsIconElement>[
    DsIconPathElement('m9 12 2 2 4-4'), // key: dzmm74
    DsIconPathElement('M5 7c0-1.1.9-2 2-2h10a2 2 0 0 1 2 2v12H5V7Z'), // key: 1ezoue
    DsIconPathElement('M22 19H2'), // key: nuriw5
  ]);

  /// `wallet-cards.mjs`
  static const DsLucideGlyph walletCards =
      DsLucideGlyph('wallet-cards', <DsIconElement>[
    DsIconPathElement('M3 11h3.75a2 2 0 0 1 1.6.8l.45.6a4 4 0 0 0 6.4 0l.45-.6a2 2 0 0 1 1.6-.8H21'), // key: 1vwh6y
    DsIconPathElement('M3 7h18'), // key: 1uiuf2
    DsIconRectElement(3, 3, 18, 18, 2), // key: h1oib
  ]);

  /// `wallet-minimal.mjs`
  static const DsLucideGlyph walletMinimal =
      DsLucideGlyph('wallet-minimal', <DsIconElement>[
    DsIconPathElement('M17 14h.01'), // key: 7oqj8z
    DsIconPathElement('M7 7h12a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14'), // key: u1rqew
  ]);

  /// `wallet.mjs`
  static const DsLucideGlyph wallet =
      DsLucideGlyph('wallet', <DsIconElement>[
    DsIconPathElement('M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1'), // key: 18etb6
    DsIconPathElement('M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4'), // key: xoc0q4
  ]);

  /// `wallpaper.mjs`
  static const DsLucideGlyph wallpaper =
      DsLucideGlyph('wallpaper', <DsIconElement>[
    DsIconPathElement('M12 17v4'), // key: 1riwvh
    DsIconPathElement('M8 21h8'), // key: 1ev6f3
    DsIconPathElement('m9 17 6.1-6.1a2 2 0 0 1 2.81.01L22 15'), // key: 1sl52q
    DsIconCircleElement(8, 9, 2), // key: gjzl9d
    DsIconRectElement(2, 3, 20, 14, 2), // key: x3v2xh
  ]);

  /// `wand-sparkles.mjs`
  static const DsLucideGlyph wandSparkles =
      DsLucideGlyph('wand-sparkles', <DsIconElement>[
    DsIconPathElement('m21.64 3.64-1.28-1.28a1.21 1.21 0 0 0-1.72 0L2.36 18.64a1.21 1.21 0 0 0 0 1.72l1.28 1.28a1.2 1.2 0 0 0 1.72 0L21.64 5.36a1.2 1.2 0 0 0 0-1.72'), // key: ul74o6
    DsIconPathElement('m14 7 3 3'), // key: 1r5n42
    DsIconPathElement('M5 6v4'), // key: ilb8ba
    DsIconPathElement('M19 14v4'), // key: blhpug
    DsIconPathElement('M10 2v2'), // key: 7u0qdc
    DsIconPathElement('M7 8H3'), // key: zfb6yr
    DsIconPathElement('M21 16h-4'), // key: 1cnmox
    DsIconPathElement('M11 3H9'), // key: 1obp7u
  ]);

  /// `wand.mjs`
  static const DsLucideGlyph wand =
      DsLucideGlyph('wand', <DsIconElement>[
    DsIconPathElement('M15 4V2'), // key: z1p9b7
    DsIconPathElement('M15 16v-2'), // key: px0unx
    DsIconPathElement('M8 9h2'), // key: 1g203m
    DsIconPathElement('M20 9h2'), // key: 19tzq7
    DsIconPathElement('M17.8 11.8 19 13'), // key: yihg8r
    DsIconPathElement('M15 9h.01'), // key: x1ddxp
    DsIconPathElement('M17.8 6.2 19 5'), // key: fd4us0
    DsIconPathElement('m3 21 9-9'), // key: 1jfql5
    DsIconPathElement('M12.2 6.2 11 5'), // key: i3da3b
  ]);

  /// `warehouse.mjs`
  static const DsLucideGlyph warehouse =
      DsLucideGlyph('warehouse', <DsIconElement>[
    DsIconPathElement('M18 21V10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1v11'), // key: pb2vm6
    DsIconPathElement('M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V8a2 2 0 0 1 1.132-1.803l7.95-3.974a2 2 0 0 1 1.837 0l7.948 3.974A2 2 0 0 1 22 8z'), // key: doq5xv
    DsIconPathElement('M6 13h12'), // key: yf64js
    DsIconPathElement('M6 17h12'), // key: 1jwigz
  ]);

  /// `washing-machine.mjs`
  static const DsLucideGlyph washingMachine =
      DsLucideGlyph('washing-machine', <DsIconElement>[
    DsIconPathElement('M3 6h3'), // key: 155dbl
    DsIconPathElement('M17 6h.01'), // key: e2y6kg
    DsIconRectElement(3, 2, 18, 20, 2), // key: od3kk9
    DsIconCircleElement(12, 13, 5), // key: nlbqau
    DsIconPathElement('M12 18a2.5 2.5 0 0 0 0-5 2.5 2.5 0 0 1 0-5'), // key: 17lach
  ]);

  /// `watch.mjs`
  static const DsLucideGlyph watch =
      DsLucideGlyph('watch', <DsIconElement>[
    DsIconPathElement('M12 10v2.2l1.6 1'), // key: n3r21l
    DsIconPathElement('m16.13 7.66-.81-4.05a2 2 0 0 0-2-1.61h-2.68a2 2 0 0 0-2 1.61l-.78 4.05'), // key: 18k57s
    DsIconPathElement('m7.88 16.36.8 4a2 2 0 0 0 2 1.61h2.72a2 2 0 0 0 2-1.61l.81-4.05'), // key: 16ny36
    DsIconCircleElement(12, 12, 6), // key: 1vlfrh
  ]);

  /// `waves-arrow-down.mjs`
  static const DsLucideGlyph wavesArrowDown =
      DsLucideGlyph('waves-arrow-down', <DsIconElement>[
    DsIconPathElement('M12 10L12 2'), // key: jvb0aw
    DsIconPathElement('M16 6L12 10L8 6'), // key: 9j6vje
    DsIconPathElement('M2 15C2.6 15.5 3.2 16 4.5 16C7 16 7 14 9.5 14C12.1 14 11.9 16 14.5 16C17 16 17 14 19.5 14C20.8 14 21.4 14.5 22 15'), // key: s2zepw
    DsIconPathElement('M2 21C2.6 21.5 3.2 22 4.5 22C7 22 7 20 9.5 20C12.1 20 11.9 22 14.5 22C17 22 17 20 19.5 20C20.8 20 21.4 20.5 22 21'), // key: u68omc
  ]);

  /// `waves-arrow-up.mjs`
  static const DsLucideGlyph wavesArrowUp =
      DsLucideGlyph('waves-arrow-up', <DsIconElement>[
    DsIconPathElement('M12 2v8'), // key: 1q4o3n
    DsIconPathElement('M2 15c.6.5 1.2 1 2.5 1 2.5 0 2.5-2 5-2 2.6 0 2.4 2 5 2 2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1'), // key: 1p9f19
    DsIconPathElement('M2 21c.6.5 1.2 1 2.5 1 2.5 0 2.5-2 5-2 2.6 0 2.4 2 5 2 2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1'), // key: vbxynw
    DsIconPathElement('m8 6 4-4 4 4'), // key: ybng9g
  ]);

  /// `waves-horizontal.mjs`
  static const DsLucideGlyph wavesHorizontal =
      DsLucideGlyph('waves-horizontal', <DsIconElement>[
    DsIconPathElement('M2 12q2.5 2 5 0t5 0 5 0 5 0'), // key: 8ddzzs
    DsIconPathElement('M2 19q2.5 2 5 0t5 0 5 0 5 0'), // key: 1wj4st
    DsIconPathElement('M2 5q2.5 2 5 0t5 0 5 0 5 0'), // key: 69x50u
  ]);

  /// `waves-ladder.mjs`
  static const DsLucideGlyph wavesLadder =
      DsLucideGlyph('waves-ladder', <DsIconElement>[
    DsIconPathElement('M19 5a2 2 0 0 0-2 2v11'), // key: s41o68
    DsIconPathElement('M2 18c.6.5 1.2 1 2.5 1 2.5 0 2.5-2 5-2 2.6 0 2.4 2 5 2 2.5 0 2.5-2 5-2 1.3 0 1.9.5 2.5 1'), // key: rd2r6e
    DsIconPathElement('M7 13h10'), // key: 1rwob1
    DsIconPathElement('M7 9h10'), // key: 12czzb
    DsIconPathElement('M9 5a2 2 0 0 0-2 2v11'), // key: x0q4gh
  ]);

  /// `waves-vertical.mjs`
  static const DsLucideGlyph wavesVertical =
      DsLucideGlyph('waves-vertical', <DsIconElement>[
    DsIconPathElement('M12 2q2 2.5 0 5t0 5 0 5 0 5'), // key: 13jdbg
    DsIconPathElement('M19 2q2 2.5 0 5t0 5 0 5 0 5'), // key: 1ozhzu
    DsIconPathElement('M5 2q2 2.5 0 5t0 5 0 5 0 5'), // key: 1bi6v5
  ]);

  /// `waypoints.mjs`
  static const DsLucideGlyph waypoints =
      DsLucideGlyph('waypoints', <DsIconElement>[
    DsIconPathElement('m10.586 5.414-5.172 5.172'), // key: 4mc350
    DsIconPathElement('m18.586 13.414-5.172 5.172'), // key: 8c96vv
    DsIconPathElement('M6 12h12'), // key: 8npq4p
    DsIconCircleElement(12, 20, 2), // key: 144qzu
    DsIconCircleElement(12, 4, 2), // key: muu5ef
    DsIconCircleElement(20, 12, 2), // key: 1xzzfp
    DsIconCircleElement(4, 12, 2), // key: 1hvhnz
  ]);

  /// `webcam-off.mjs`
  static const DsLucideGlyph webcamOff =
      DsLucideGlyph('webcam-off', <DsIconElement>[
    DsIconPathElement('M12 22v-4'), // key: 1utk9m
    DsIconPathElement('M12.754 7.096a3 3 0 0 1 2.15 2.15'), // key: 1v0qsm
    DsIconPathElement('M12.863 12.873a3 3 0 0 1-3.736-3.735'), // key: 13aqxl
    DsIconPathElement('M16.566 16.57A8 8 0 0 1 5.43 5.433'), // key: 1hliph
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('M7 22h10'), // key: 10w4w3
    DsIconPathElement('M8.478 2.817a8 8 0 0 1 10.705 10.705'), // key: r097k8
  ]);

  /// `webcam.mjs`
  static const DsLucideGlyph webcam =
      DsLucideGlyph('webcam', <DsIconElement>[
    DsIconCircleElement(12, 10, 8), // key: 1gshiw
    DsIconCircleElement(12, 10, 3), // key: ilqhr7
    DsIconPathElement('M7 22h10'), // key: 10w4w3
    DsIconPathElement('M12 22v-4'), // key: 1utk9m
  ]);

  /// `webhook-off.mjs`
  static const DsLucideGlyph webhookOff =
      DsLucideGlyph('webhook-off', <DsIconElement>[
    DsIconPathElement('M17 17h-5c-1.09-.02-1.94.92-2.5 1.9A3 3 0 1 1 2.57 15'), // key: 1tvl6x
    DsIconPathElement('M9 3.4a4 4 0 0 1 6.52.66'), // key: q04jfq
    DsIconPathElement('m6 17 3.1-5.8a2.5 2.5 0 0 0 .057-2.05'), // key: azowf0
    DsIconPathElement('M20.3 20.3a4 4 0 0 1-2.3.7'), // key: 5joiws
    DsIconPathElement('M18.6 13a4 4 0 0 1 3.357 3.414'), // key: cangb8
    DsIconPathElement('m12 6 .6 1'), // key: tpjl1n
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `webhook.mjs`
  static const DsLucideGlyph webhook =
      DsLucideGlyph('webhook', <DsIconElement>[
    DsIconPathElement('M18 16.98h-5.99c-1.1 0-1.95.94-2.48 1.9A4 4 0 0 1 2 17c.01-.7.2-1.4.57-2'), // key: q3hayz
    DsIconPathElement('m6 17 3.13-5.78c.53-.97.1-2.18-.5-3.1a4 4 0 1 1 6.89-4.06'), // key: 1go1hn
    DsIconPathElement('m12 6 3.13 5.73C15.66 12.7 16.9 13 18 13a4 4 0 0 1 0 8'), // key: qlwsc0
  ]);

  /// `weight-tilde.mjs`
  static const DsLucideGlyph weightTilde =
      DsLucideGlyph('weight-tilde', <DsIconElement>[
    DsIconPathElement('M6.5 8a2 2 0 0 0-1.906 1.46L2.1 18.5A2 2 0 0 0 4 21h16a2 2 0 0 0 1.925-2.54L19.4 9.5A2 2 0 0 0 17.48 8z'), // key: 1wl739
    DsIconPathElement('M7.999 15a2.5 2.5 0 0 1 4 0 2.5 2.5 0 0 0 4 0'), // key: 1egezo
    DsIconCircleElement(12, 5, 3), // key: rqqgnr
  ]);

  /// `weight.mjs`
  static const DsLucideGlyph weight =
      DsLucideGlyph('weight', <DsIconElement>[
    DsIconCircleElement(12, 5, 3), // key: rqqgnr
    DsIconPathElement('M6.5 8a2 2 0 0 0-1.905 1.46L2.1 18.5A2 2 0 0 0 4 21h16a2 2 0 0 0 1.925-2.54L19.4 9.5A2 2 0 0 0 17.48 8Z'), // key: 56o5sh
  ]);

  /// `wheat-off.mjs`
  static const DsLucideGlyph wheatOff =
      DsLucideGlyph('wheat-off', <DsIconElement>[
    DsIconPathElement('m2 22 10-10'), // key: 28ilpk
    DsIconPathElement('m16 8-1.17 1.17'), // key: 1qqm82
    DsIconPathElement('M3.47 12.53 5 11l1.53 1.53a3.5 3.5 0 0 1 0 4.94L5 19l-1.53-1.53a3.5 3.5 0 0 1 0-4.94Z'), // key: 1rdhi6
    DsIconPathElement('m8 8-.53.53a3.5 3.5 0 0 0 0 4.94L9 15l1.53-1.53c.55-.55.88-1.25.98-1.97'), // key: 4wz8re
    DsIconPathElement('M10.91 5.26c.15-.26.34-.51.56-.73L13 3l1.53 1.53a3.5 3.5 0 0 1 .28 4.62'), // key: rves66
    DsIconPathElement('M20 2h2v2a4 4 0 0 1-4 4h-2V6a4 4 0 0 1 4-4Z'), // key: 19rau1
    DsIconPathElement('M11.47 17.47 13 19l-1.53 1.53a3.5 3.5 0 0 1-4.94 0L5 19l1.53-1.53a3.5 3.5 0 0 1 4.94 0Z'), // key: tc8ph9
    DsIconPathElement('m16 16-.53.53a3.5 3.5 0 0 1-4.94 0L9 15l1.53-1.53a3.49 3.49 0 0 1 1.97-.98'), // key: ak46r
    DsIconPathElement('M18.74 13.09c.26-.15.51-.34.73-.56L21 11l-1.53-1.53a3.5 3.5 0 0 0-4.62-.28'), // key: 1tw520
    DsIconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `wheat.mjs`
  static const DsLucideGlyph wheat =
      DsLucideGlyph('wheat', <DsIconElement>[
    DsIconPathElement('M2 22 16 8'), // key: 60hf96
    DsIconPathElement('M3.47 12.53 5 11l1.53 1.53a3.5 3.5 0 0 1 0 4.94L5 19l-1.53-1.53a3.5 3.5 0 0 1 0-4.94Z'), // key: 1rdhi6
    DsIconPathElement('M7.47 8.53 9 7l1.53 1.53a3.5 3.5 0 0 1 0 4.94L9 15l-1.53-1.53a3.5 3.5 0 0 1 0-4.94Z'), // key: 1sdzmb
    DsIconPathElement('M11.47 4.53 13 3l1.53 1.53a3.5 3.5 0 0 1 0 4.94L13 11l-1.53-1.53a3.5 3.5 0 0 1 0-4.94Z'), // key: eoatbi
    DsIconPathElement('M20 2h2v2a4 4 0 0 1-4 4h-2V6a4 4 0 0 1 4-4Z'), // key: 19rau1
    DsIconPathElement('M11.47 17.47 13 19l-1.53 1.53a3.5 3.5 0 0 1-4.94 0L5 19l1.53-1.53a3.5 3.5 0 0 1 4.94 0Z'), // key: tc8ph9
    DsIconPathElement('M15.47 13.47 17 15l-1.53 1.53a3.5 3.5 0 0 1-4.94 0L9 15l1.53-1.53a3.5 3.5 0 0 1 4.94 0Z'), // key: 2m8kc5
    DsIconPathElement('M19.47 9.47 21 11l-1.53 1.53a3.5 3.5 0 0 1-4.94 0L13 11l1.53-1.53a3.5 3.5 0 0 1 4.94 0Z'), // key: vex3ng
  ]);

  /// `whole-word.mjs`
  static const DsLucideGlyph wholeWord =
      DsLucideGlyph('whole-word', <DsIconElement>[
    DsIconCircleElement(7, 12, 3), // key: 12clwm
    DsIconPathElement('M10 9v6'), // key: 17i7lo
    DsIconCircleElement(17, 12, 3), // key: gl7c2s
    DsIconPathElement('M14 7v8'), // key: dl84cr
    DsIconPathElement('M22 17v1c0 .5-.5 1-1 1H3c-.5 0-1-.5-1-1v-1'), // key: lt2kga
  ]);

  /// `wifi-cog.mjs`
  static const DsLucideGlyph wifiCog =
      DsLucideGlyph('wifi-cog', <DsIconElement>[
    DsIconPathElement('m14.305 19.53.923-.382'), // key: 3m78fa
    DsIconPathElement('m15.228 16.852-.923-.383'), // key: npixar
    DsIconPathElement('m16.852 15.228-.383-.923'), // key: 5xggr7
    DsIconPathElement('m16.852 20.772-.383.924'), // key: dpfhf9
    DsIconPathElement('m19.148 15.228.383-.923'), // key: 1reyyz
    DsIconPathElement('m19.53 21.696-.382-.924'), // key: 1goivc
    DsIconPathElement('M2 7.82a15 15 0 0 1 20 0'), // key: 1ovjuk
    DsIconPathElement('m20.772 16.852.924-.383'), // key: htqkph
    DsIconPathElement('m20.772 19.148.924.383'), // key: 9w9pjp
    DsIconPathElement('M5 11.858a10 10 0 0 1 11.5-1.785'), // key: 3sn16i
    DsIconPathElement('M8.5 15.429a5 5 0 0 1 2.413-1.31'), // key: 1pxovh
    DsIconCircleElement(18, 18, 3), // key: 1xkwt0
  ]);

  /// `wifi-high.mjs`
  static const DsLucideGlyph wifiHigh =
      DsLucideGlyph('wifi-high', <DsIconElement>[
    DsIconPathElement('M12 20h.01'), // key: zekei9
    DsIconPathElement('M5 12.859a10 10 0 0 1 14 0'), // key: 1x1e6c
    DsIconPathElement('M8.5 16.429a5 5 0 0 1 7 0'), // key: 1bycff
  ]);

  /// `wifi-low.mjs`
  static const DsLucideGlyph wifiLow =
      DsLucideGlyph('wifi-low', <DsIconElement>[
    DsIconPathElement('M12 20h.01'), // key: zekei9
    DsIconPathElement('M8.5 16.429a5 5 0 0 1 7 0'), // key: 1bycff
  ]);

  /// `wifi-off.mjs`
  static const DsLucideGlyph wifiOff =
      DsLucideGlyph('wifi-off', <DsIconElement>[
    DsIconPathElement('M12 20h.01'), // key: zekei9
    DsIconPathElement('M8.5 16.429a5 5 0 0 1 7 0'), // key: 1bycff
    DsIconPathElement('M5 12.859a10 10 0 0 1 5.17-2.69'), // key: 1dl1wf
    DsIconPathElement('M19 12.859a10 10 0 0 0-2.007-1.523'), // key: 4k23kn
    DsIconPathElement('M2 8.82a15 15 0 0 1 4.177-2.643'), // key: 1grhjp
    DsIconPathElement('M22 8.82a15 15 0 0 0-11.288-3.764'), // key: z3jwby
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `wifi-pen.mjs`
  static const DsLucideGlyph wifiPen =
      DsLucideGlyph('wifi-pen', <DsIconElement>[
    DsIconPathElement('M2 8.82a15 15 0 0 1 20 0'), // key: dnpr2z
    DsIconPathElement('M21.378 16.626a1 1 0 0 0-3.004-3.004l-4.01 4.012a2 2 0 0 0-.506.854l-.837 2.87a.5.5 0 0 0 .62.62l2.87-.837a2 2 0 0 0 .854-.506z'), // key: 1817ys
    DsIconPathElement('M5 12.859a10 10 0 0 1 10.5-2.222'), // key: rpb7oy
    DsIconPathElement('M8.5 16.429a5 5 0 0 1 3-1.406'), // key: r8bmzl
  ]);

  /// `wifi-sync.mjs`
  static const DsLucideGlyph wifiSync =
      DsLucideGlyph('wifi-sync', <DsIconElement>[
    DsIconPathElement('M11.965 10.105v4L13.5 12.5a5 5 0 0 1 8 1.5'), // key: 1immaq
    DsIconPathElement('M11.965 14.105h4'), // key: uejny8
    DsIconPathElement('M17.965 18.105h4L20.43 19.71a5 5 0 0 1-8-1.5'), // key: 1i3a7e
    DsIconPathElement('M2 8.82a15 15 0 0 1 20 0'), // key: dnpr2z
    DsIconPathElement('M21.965 22.105v-4'), // key: 1ku6vx
    DsIconPathElement('M5 12.86a10 10 0 0 1 3-2.032'), // key: pemdtu
    DsIconPathElement('M8.5 16.429h.01'), // key: 2bm739
  ]);

  /// `wifi-zero.mjs`
  static const DsLucideGlyph wifiZero =
      DsLucideGlyph('wifi-zero', <DsIconElement>[
    DsIconPathElement('M12 20h.01'), // key: zekei9
  ]);

  /// `wifi.mjs`
  static const DsLucideGlyph wifi =
      DsLucideGlyph('wifi', <DsIconElement>[
    DsIconPathElement('M12 20h.01'), // key: zekei9
    DsIconPathElement('M2 8.82a15 15 0 0 1 20 0'), // key: dnpr2z
    DsIconPathElement('M5 12.859a10 10 0 0 1 14 0'), // key: 1x1e6c
    DsIconPathElement('M8.5 16.429a5 5 0 0 1 7 0'), // key: 1bycff
  ]);

  /// `wind-arrow-down.mjs`
  static const DsLucideGlyph windArrowDown =
      DsLucideGlyph('wind-arrow-down', <DsIconElement>[
    DsIconPathElement('M10 2v8'), // key: d4bbey
    DsIconPathElement('M12.8 21.6A2 2 0 1 0 14 18H2'), // key: 19kp1d
    DsIconPathElement('M17.5 10a2.5 2.5 0 1 1 2 4H2'), // key: 19kpjc
    DsIconPathElement('m6 6 4 4 4-4'), // key: k13n16
  ]);

  /// `wind.mjs`
  static const DsLucideGlyph wind =
      DsLucideGlyph('wind', <DsIconElement>[
    DsIconPathElement('M12.8 19.6A2 2 0 1 0 14 16H2'), // key: 148xed
    DsIconPathElement('M17.5 8a2.5 2.5 0 1 1 2 4H2'), // key: 1u4tom
    DsIconPathElement('M9.8 4.4A2 2 0 1 1 11 8H2'), // key: 75valh
  ]);

  /// `wine-off.mjs`
  static const DsLucideGlyph wineOff =
      DsLucideGlyph('wine-off', <DsIconElement>[
    DsIconPathElement('M8 22h8'), // key: rmew8v
    DsIconPathElement('M7 10h3m7 0h-1.343'), // key: v48bem
    DsIconPathElement('M12 15v7'), // key: t2xh3l
    DsIconPathElement('M7.307 7.307A12.33 12.33 0 0 0 7 10a5 5 0 0 0 7.391 4.391M8.638 2.981C8.75 2.668 8.872 2.34 9 2h6c1.5 4 2 6 2 8 0 .407-.05.809-.145 1.198'), // key: 1ymjlu
    DsIconLineElement(2, 2, 22, 22), // key: a6p6uj
  ]);

  /// `wine.mjs`
  static const DsLucideGlyph wine =
      DsLucideGlyph('wine', <DsIconElement>[
    DsIconPathElement('M8 22h8'), // key: rmew8v
    DsIconPathElement('M7 10h10'), // key: 1101jm
    DsIconPathElement('M12 15v7'), // key: t2xh3l
    DsIconPathElement('M12 15a5 5 0 0 0 5-5c0-2-.5-4-2-8H9c-1.5 4-2 6-2 8a5 5 0 0 0 5 5Z'), // key: 10ffi3
  ]);

  /// `workflow.mjs`
  static const DsLucideGlyph workflow =
      DsLucideGlyph('workflow', <DsIconElement>[
    DsIconRectElement(3, 3, 8, 8, 2), // key: by2w9f
    DsIconPathElement('M7 11v4a2 2 0 0 0 2 2h4'), // key: xkn7yn
    DsIconRectElement(13, 13, 8, 8, 2), // key: 1cgmvn
  ]);

  /// `worm.mjs`
  static const DsLucideGlyph worm =
      DsLucideGlyph('worm', <DsIconElement>[
    DsIconPathElement('m19 12-1.5 3'), // key: 9bcu4o
    DsIconPathElement('M19.63 18.81 22 20'), // key: 121v98
    DsIconPathElement('M6.47 8.23a1.68 1.68 0 0 1 2.44 1.93l-.64 2.08a6.76 6.76 0 0 0 10.16 7.67l.42-.27a1 1 0 1 0-2.73-4.21l-.42.27a1.76 1.76 0 0 1-2.63-1.99l.64-2.08A6.66 6.66 0 0 0 3.94 3.9l-.7.4a1 1 0 1 0 2.55 4.34z'), // key: 1tij6q
  ]);

  /// `wrench-off.mjs`
  static const DsLucideGlyph wrenchOff =
      DsLucideGlyph('wrench-off', <DsIconElement>[
    DsIconPathElement('M10.747 5.093a6 6 0 0 1 6.841-2.882c.438.12.54.662.219.984L14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.106-3.105c.32-.322.863-.22.983.218a6 6 0 0 1-2.882 6.842'), // key: sded7h
    DsIconPathElement('m13.5 13.5-7.88 7.88a1 1 0 0 1-2.999-3l7.88-7.88'), // key: 66etnh
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
  ]);

  /// `wrench.mjs`
  static const DsLucideGlyph wrench =
      DsLucideGlyph('wrench', <DsIconElement>[
    DsIconPathElement('M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.106-3.105c.32-.322.863-.22.983.218a6 6 0 0 1-8.259 7.057l-7.91 7.91a1 1 0 0 1-2.999-3l7.91-7.91a6 6 0 0 1 7.057-8.259c.438.12.54.662.219.984z'), // key: 1ngwbx
  ]);

  /// `x-line-top.mjs`
  static const DsLucideGlyph xLineTop =
      DsLucideGlyph('x-line-top', <DsIconElement>[
    DsIconPathElement('M18 4H6'), // key: 1hsngl
    DsIconPathElement('M18 8 6 20'), // key: xspwia
    DsIconPathElement('m6 8 12 12'), // key: qb1veh
  ]);

  /// `x.mjs`
  static const DsLucideGlyph x =
      DsLucideGlyph('x', <DsIconElement>[
    DsIconPathElement('M18 6 6 18'), // key: 1bl5f8
    DsIconPathElement('m6 6 12 12'), // key: d8bk6v
  ]);

  /// `zap-off.mjs`
  static const DsLucideGlyph zapOff =
      DsLucideGlyph('zap-off', <DsIconElement>[
    DsIconPathElement('M10.768 5.111 13.44 2.44a1.5 1.5 0 012.474 1.561l-1.633 4.625'), // key: l6h226
    DsIconPathElement('m18.889 13.232.672-.672A1.5 1.5 0 0018.5 10h-2.844'), // key: 1717b9
    DsIconPathElement('m2 2 20 20'), // key: 1ooewy
    DsIconPathElement('m7.94 7.94-3.5 3.499A1.5 1.5 0 005.5 14h4.002a.5.5 0 01.471.666L8.086 20a1.5 1.5 0 002.475 1.56l5.5-5.5'), // key: 1bjzrh
  ]);

  /// `zap.mjs`
  static const DsLucideGlyph zap =
      DsLucideGlyph('zap', <DsIconElement>[
    DsIconPathElement('M15.914 4a1.5 1.5 0 00-2.474-1.561l-9 9A1.5 1.5 0 005.5 14h4.002a.5.5 0 01.471.666L8.086 20a1.5 1.5 0 002.475 1.56l9-9A1.5 1.5 0 0018.5 10h-3.997a.5.5 0 01-.472-.667z'), // key: 1v7up4
  ]);

  /// `zodiac-aquarius.mjs`
  static const DsLucideGlyph zodiacAquarius =
      DsLucideGlyph('zodiac-aquarius', <DsIconElement>[
    DsIconPathElement('m2 10 2.456-3.684a.7.7 0 0 1 1.106-.013l2.39 3.413a.7.7 0 0 0 1.096-.001l2.402-3.432a.7.7 0 0 1 1.098 0l2.402 3.432a.7.7 0 0 0 1.098 0l2.389-3.413a.7.7 0 0 1 1.106.013L22 10'), // key: 1o8iok
    DsIconPathElement('m2 18.002 2.456-3.684a.7.7 0 0 1 1.106-.013l2.39 3.413a.7.7 0 0 0 1.097 0l2.402-3.432a.7.7 0 0 1 1.098 0l2.402 3.432a.7.7 0 0 0 1.098 0l2.389-3.413a.7.7 0 0 1 1.106.013L22 18.002'), // key: 112qy7
  ]);

  /// `zodiac-aries.mjs`
  static const DsLucideGlyph zodiacAries =
      DsLucideGlyph('zodiac-aries', <DsIconElement>[
    DsIconPathElement('M12 7.5a4.5 4.5 0 1 1 5 4.5'), // key: k987hv
    DsIconPathElement('M7 12a4.5 4.5 0 1 1 5-4.5V21'), // key: mjup0w
  ]);

  /// `zodiac-cancer.mjs`
  static const DsLucideGlyph zodiacCancer =
      DsLucideGlyph('zodiac-cancer', <DsIconElement>[
    DsIconPathElement('M21 14.5A9 6.5 0 0 1 5.5 19'), // key: 1xj2o6
    DsIconPathElement('M3 9.5A9 6.5 0 0 1 18.5 5'), // key: 1gln3t
    DsIconCircleElement(17.5, 14.5, 3.5), // key: 1ccu1t
    DsIconCircleElement(6.5, 9.5, 3.5), // key: x5tc2d
  ]);

  /// `zodiac-capricorn.mjs`
  static const DsLucideGlyph zodiacCapricorn =
      DsLucideGlyph('zodiac-capricorn', <DsIconElement>[
    DsIconPathElement('M11 21a3 3 0 0 0 3-3V6.5a1 1 0 0 0-7 0'), // key: 1kkncs
    DsIconPathElement('M7 19V6a3 3 0 0 0-3-3h0'), // key: 1jg5y1
    DsIconCircleElement(17, 17, 3), // key: 18b49y
  ]);

  /// `zodiac-gemini.mjs`
  static const DsLucideGlyph zodiacGemini =
      DsLucideGlyph('zodiac-gemini', <DsIconElement>[
    DsIconPathElement('M16 4.525v14.948'), // key: bgoxo0
    DsIconPathElement('M20 3A17 17 0 0 1 4 3'), // key: 1djemw
    DsIconPathElement('M4 21a17 17 0 0 1 16 0'), // key: onoyo7
    DsIconPathElement('M8 4.525v14.948'), // key: u5iyof
  ]);

  /// `zodiac-leo.mjs`
  static const DsLucideGlyph zodiacLeo =
      DsLucideGlyph('zodiac-leo', <DsIconElement>[
    DsIconPathElement('M10 16c0-4-3-4.5-3-8a5 5 0 0 1 10 0c0 3.466-3 6.196-3 10a3 3 0 0 0 6 0'), // key: 1qj6nb
    DsIconCircleElement(7, 16, 3), // key: yyv3zl
  ]);

  /// `zodiac-libra.mjs`
  static const DsLucideGlyph zodiacLibra =
      DsLucideGlyph('zodiac-libra', <DsIconElement>[
    DsIconPathElement('M3 16h6.857c.162-.012.19-.323.038-.38a6 6 0 1 1 4.212 0c-.153.057-.125.368.038.38H21'), // key: 1novf0
    DsIconPathElement('M3 20h18'), // key: 1l19wn
  ]);

  /// `zodiac-ophiuchus.mjs`
  static const DsLucideGlyph zodiacOphiuchus =
      DsLucideGlyph('zodiac-ophiuchus', <DsIconElement>[
    DsIconPathElement('M3 10A6.06 6.06 0 0 1 12 10 A6.06 6.06 0 0 0 21 10'), // key: 13lfmc
    DsIconPathElement('M6 3v12a6 6 0 0 0 12 0V3'), // key: 1jnivp
  ]);

  /// `zodiac-pisces.mjs`
  static const DsLucideGlyph zodiacPisces =
      DsLucideGlyph('zodiac-pisces', <DsIconElement>[
    DsIconPathElement('M19 21a15 15 0 0 1 0-18'), // key: br2vug
    DsIconPathElement('M20 12H4'), // key: 1mtusc
    DsIconPathElement('M5 3a15 15 0 0 1 0 18'), // key: 1w7hae
  ]);

  /// `zodiac-sagittarius.mjs`
  static const DsLucideGlyph zodiacSagittarius =
      DsLucideGlyph('zodiac-sagittarius', <DsIconElement>[
    DsIconPathElement('M15 3h6v6'), // key: 1q9fwt
    DsIconPathElement('M21 3 3 21'), // key: 1011np
    DsIconPathElement('m9 9 6 6'), // key: z0biqf
  ]);

  /// `zodiac-scorpio.mjs`
  static const DsLucideGlyph zodiacScorpio =
      DsLucideGlyph('zodiac-scorpio', <DsIconElement>[
    DsIconPathElement('M10 19V5.5a1 1 0 0 1 5 0V17a2 2 0 0 0 2 2h5l-3-3'), // key: 1w8g0z
    DsIconPathElement('m22 19-3 3'), // key: 1ix4wq
    DsIconPathElement('M5 19V5.5a1 1 0 0 1 5 0'), // key: 1d4oa3
    DsIconPathElement('M5 5.5A2.5 2.5 0 0 0 2.5 3'), // key: gp646f
  ]);

  /// `zodiac-taurus.mjs`
  static const DsLucideGlyph zodiacTaurus =
      DsLucideGlyph('zodiac-taurus', <DsIconElement>[
    DsIconCircleElement(12, 15, 6), // key: lhqcmb
    DsIconPathElement('M18 3A6 6 0 0 1 6 3'), // key: 1p399e
  ]);

  /// `zodiac-virgo.mjs`
  static const DsLucideGlyph zodiacVirgo =
      DsLucideGlyph('zodiac-virgo', <DsIconElement>[
    DsIconPathElement('M11 5.5a1 1 0 0 1 5 0V16a5 5 0 0 0 5 5'), // key: 1szkuh
    DsIconPathElement('M16 11.5a1 1 0 0 1 5 0V16a5 5 0 0 1-5 5'), // key: pyq0k2
    DsIconPathElement('M6 19V6a3 3 0 0 0-3-3h0'), // key: pvee4g
    DsIconPathElement('M6 5.5a1 1 0 0 1 5 0V19'), // key: vncctg
  ]);

  /// `zoom-in.mjs`
  static const DsLucideGlyph zoomIn =
      DsLucideGlyph('zoom-in', <DsIconElement>[
    DsIconCircleElement(11, 11, 8), // key: 4ej97u
    DsIconLineElement(21, 21, 16.65, 16.65), // key: 13gj7c
    DsIconLineElement(11, 8, 11, 14), // key: 1vmskp
    DsIconLineElement(8, 11, 14, 11), // key: durymu
  ]);

  /// `zoom-out.mjs`
  static const DsLucideGlyph zoomOut =
      DsLucideGlyph('zoom-out', <DsIconElement>[
    DsIconCircleElement(11, 11, 8), // key: 4ej97u
    DsIconLineElement(21, 21, 16.65, 16.65), // key: 13gj7c
    DsIconLineElement(8, 11, 14, 11), // key: durymu
  ]);
}
