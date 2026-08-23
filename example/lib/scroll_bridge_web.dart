/// The web half of [scroll_bridge.dart]: see that library for the why.
///
/// Three globals, all reading the live [ScrollPosition] on every call rather
/// than caching anything: the rig's whole point is to ask *after* it has moved,
/// and a cached extent is a lie the moment a font lands or an image decodes.
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/widgets.dart';

/// The one attached position, or null before the reading column has laid out.
///
/// [ScrollController.position] asserts it has exactly one client, and there is
/// a window: between `initState` and the first frame: where it has none.
ScrollPosition? _positionOf(ScrollController controller) =>
    controller.hasClients ? controller.position : null;

/// Hangs the seam on `window`.
///
/// Idempotent: it assigns three properties, so a hot restart simply rebinds
/// them to the new controller. Nothing detaches them, and nothing needs to —
/// the shell that owns the controller outlives every page in the gallery.
void dsInstallScrollBridge(ScrollController controller) {
  /// `window.__dsScrollTo(y)`: jump, clamped to the scrollable range.
  ///
  /// A jump rather than an animation on purpose: the rig takes a photograph
  /// immediately afterwards, and it must not have to know how long a scroll
  /// takes. Clamping is what makes a short bottom pass *legible* rather than
  /// silent: ask for more than the page has and `__dsScrollY()` reports the
  /// clamp, which is precisely the partial advance pixel matching could not
  /// recover.
  globalContext['__dsScrollTo'] = ((JSNumber y) {
    final ScrollPosition? position = _positionOf(controller);
    if (position == null) return;
    position.jumpTo(
      y.toDartDouble.clamp(0.0, position.maxScrollExtent),
    );
  }).toJS;

  /// `window.__dsScrollY()`: the port of `window.scrollY`.
  globalContext['__dsScrollY'] = (() {
    final ScrollPosition? position = _positionOf(controller);
    return (position?.pixels ?? 0).toJS;
  }).toJS;

  /// `window.__dsScrollMax()`: the port of
  /// `document.body.scrollHeight − innerHeight`.
  globalContext['__dsScrollMax'] = (() {
    final ScrollPosition? position = _positionOf(controller);
    return (position?.maxScrollExtent ?? 0).toJS;
  }).toJS;
}
