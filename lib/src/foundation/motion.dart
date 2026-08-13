/// Motion tokens — a transcript of the reference's timing layer.
///
/// Source of truth: `design-system/app/globals.css` L395–432.
/// This file is inside `lib/src/foundation/`, the one place literals live.
library;

import 'package:flutter/animation.dart';

/// Every `--duration-*` token.
///
/// The scale's own thesis (globals.css L390–391): *"`tick` is the machine
/// beat: a press registers in 80ms, then springs back over `base`. That
/// asymmetry — instant in, springy out — is the whole feel."*
class DsDurations {
  const DsDurations._();

  /// `--duration-tick: 80ms` (L398) — the press-down beat.
  static const Duration tick = Duration(milliseconds: 80);

  /// `--duration-fast: 150ms` (L399).
  static const Duration fast = Duration(milliseconds: 150);

  /// `--duration-base: 250ms` (L400).
  ///
  /// Also `--default-transition-duration` (L395): the framework's own default
  /// is pointed at this token so nothing can beat it on the same element.
  static const Duration base = Duration(milliseconds: 250);

  /// `--duration-slow: 400ms` (L401).
  static const Duration slow = Duration(milliseconds: 400);

  /// `--duration-overlay: 320ms` (L402) — every overlay enter/exit.
  static const Duration overlay = Duration(milliseconds: 320);

  /// `--duration-jelly: 420ms` (L406). Longer than [overlay] because
  /// [DsCurves.spring] spends its last stretch settling an overshoot.
  static const Duration jelly = Duration(milliseconds: 420);

  /// `--duration-reward: 550ms` (L407).
  static const Duration reward = Duration(milliseconds: 550);

  /// `--duration-bloom: 1000ms` (L411) — ambient, not interactive.
  static const Duration bloom = Duration(milliseconds: 1000);

  /// `--duration-sway: 44s` (L417) — the starfield's slow sway.
  static const Duration sway = Duration(seconds: 44);

  /// `--duration-sway-alt: 33s` (L418). Deliberately not a multiple of
  /// [sway]: sways that share a period re-sync and the field reads as one
  /// rigid sheet.
  static const Duration swayAlt = Duration(seconds: 33);
}

/// Every `--ease-*` token, as Flutter [Cubic] curves.
///
/// The CSS names map one-to-one; only `--ease-in` is renamed ([curveIn]),
/// because `in` is a reserved-ish identifier in Dart call sites.
class DsCurves {
  const DsCurves._();

  /// `--ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1)` (L420) —
  /// overshoot + settle.
  static const Cubic spring = Cubic(0.34, 1.56, 0.64, 1);

  /// `--ease-out: cubic-bezier(0.22, 1, 0.36, 1)` (L421).
  ///
  /// Also `--default-transition-timing-function` (L396): the system default.
  static const Cubic out = Cubic(0.22, 1, 0.36, 1);

  /// `--ease-in: cubic-bezier(0.7, 0, 0.84, 0)` (L428) — the accelerating
  /// exit. Deliberately NOT Tailwind's gentler `cubic-bezier(0.4, 0, 1, 1)`.
  static const Cubic curveIn = Cubic(0.7, 0, 0.84, 0);

  /// `--ease-in-out: cubic-bezier(0.65, 0, 0.35, 1)` (L429).
  static const Cubic inOut = Cubic(0.65, 0, 0.35, 1);

  /// `--ease-settle: cubic-bezier(0.16, 1, 0.3, 1)` (L431) — long travel,
  /// lands soft.
  static const Cubic settle = Cubic(0.16, 1, 0.3, 1);

  /// `--ease-standard: cubic-bezier(0.4, 0, 0.2, 1)` (L432).
  static const Cubic standard = Cubic(0.4, 0, 0.2, 1);

  /// `--ease-out-flex: cubic-bezier(0.05, 0.6, 0.4, 0.9)` (L430).
  static const Cubic outFlex = Cubic(0.05, 0.6, 0.4, 0.9);

  /// All seven easings, in the order globals.css declares them.
  static const List<Cubic> all = <Cubic>[
    spring,
    out,
    curveIn,
    inOut,
    outFlex,
    settle,
    standard,
  ];
}
