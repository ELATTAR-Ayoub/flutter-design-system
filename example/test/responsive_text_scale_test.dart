/// Every specimen page, across the matrix the system claims to support.
///
/// The rule the system holds itself to is that a reader who doubles their text
/// size, or turns the lights on, or arrives on a phone, gets a different page
/// rather than a broken one. That is not something a single component test can
/// establish: clipping happens where a fixed height meets a grown line box, and
/// the fixed height is usually two widgets above the text. So the check runs
/// against the real specimen pages, the same ones the docs site ships.
///
/// A failure here is an overflow, a clip, or an assertion thrown during layout
/// or paint. There is no golden and no measurement: the claim is only that the
/// page survives every configuration, which is exactly the claim that was never
/// being made before.
///
/// **Four configurations per route, not the full cross product.** Width x theme
/// x scale is twelve, and twelve pumps of a whole documentation page each is a
/// quarter of an hour nobody will wait for. The four below are chosen so that
/// every value of every axis appears, and so that both hard corners are covered:
/// narrowest at 200% and widest at 200%. A fifth would repeat an axis rather
/// than add one. Reduced motion is a further pass over the animated routes only,
/// because a page with no animation cannot fail it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/main.dart';
import 'package:example/nav.dart';
import 'package:flutter/material.dart' show Material, MaterialApp;
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;
import 'package:flutter_test/flutter_test.dart';

/// One cell of the matrix.
class _Config {
  const _Config({
    required this.label,
    required this.size,
    required this.mode,
    required this.scale,
    this.reducedMotion = false,
  });

  final String label;
  final Size size;
  final ColorMode mode;
  final double scale;
  final bool reducedMotion;
}

/// A small phone, portrait: the narrowest viewport the system claims.
const Size _mobile = Size(390, 844);

/// A tablet, portrait.
const Size _tablet = Size(768, 1024);

/// The width every parity capture in `tool/verify` was taken at.
const Size _desktop = Size(1440, 900);

/// Every axis appears; both 200% corners are covered.
const List<_Config> _matrix = <_Config>[
  _Config(
    label: 'mobile dark 200%',
    size: _mobile,
    mode: ColorMode.dark,
    scale: 2,
  ),
  _Config(
    label: 'mobile light 100%',
    size: _mobile,
    mode: ColorMode.light,
    scale: 1,
  ),
  _Config(
    label: 'tablet dark 100%',
    size: _tablet,
    mode: ColorMode.dark,
    scale: 1,
  ),
  _Config(
    label: 'desktop light 200%',
    size: _desktop,
    mode: ColorMode.light,
    scale: 2,
  ),
];

/// The routes with animation worth turning off.
///
/// Named rather than derived: a route earns a reduced-motion pass by owning a
/// ticker, and reading that off the page tree at test time would be a second,
/// weaker implementation of the sweep that already reads it off the source.
const Set<String> _animated = <String>{
  '/design-system/motion',
  '/design-system/components/base/feedback',
  '/design-system/components/base/charts',
  '/design-system/components/base/dialogs',
  '/design-system/components/agent/voice',
  '/design-system/components/agent/console',
};

/// Every specimen route in the shell, in nav order.
List<String> get _routes => <String>[
  for (final Group group in elGroups)
    for (final Category category in group.categories)
      categoryHref(group, category),
];

Widget _host(String route, _Config config) => ThemeScope(
  controller: ThemeController(mode: config.mode),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MediaQuery(
      data: MediaQueryData(
        size: config.size,
        textScaler: TextScaler.linear(config.scale),
        disableAnimations: config.reducedMotion,
      ),
      child: Builder(
        builder: (BuildContext context) => DefaultTextStyle(
          style: StyledText.styleOf(
            context,
            TextStyles.body,
            color: ThemeScope.of(context).foreground,
          ),
          // The shell scrolls; `pageFor` returns the bare page. Without the
          // scroll parent every page would fail on its own height, which is
          // the harness overflowing rather than the page, and would hide the
          // failures that are real: content that will not fit across the width.
          child: Material(child: SingleChildScrollView(child: pageFor(route))),
        ),
      ),
    ),
  ),
);

/// Pumps one route in one configuration and returns whatever it threw.
///
/// `pump` with a named duration rather than `pumpAndSettle`: several specimen
/// pages mount `Alert`, whose `FeedbackSurface` controllers repeat forever, so
/// a settle would never return. [MotionDurations.open] is the longest entrance
/// in the system, so one beat of it is past the end of anything a page starts
/// on mount.
Future<Object?> _pumpRoute(WidgetTester t, String route, _Config config) async {
  t.view.physicalSize = config.size;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.reset);

  await t.pumpWidget(_host(route, config));
  await t.pump(MotionDurations.open);
  return t.takeException();
}

void main() {
  for (final String route in _routes) {
    group(route, () {
      for (final _Config config in _matrix) {
        testWidgets('survives ${config.label}', (WidgetTester t) async {
          expect(await _pumpRoute(t, route, config), isNull);
        });
      }

      if (_animated.contains(route)) {
        testWidgets('survives with reduced motion asked for', (
          WidgetTester t,
        ) async {
          const _Config reduced = _Config(
            label: 'mobile dark 200% reduced',
            size: _mobile,
            mode: ColorMode.dark,
            scale: 2,
            reducedMotion: true,
          );
          expect(await _pumpRoute(t, route, reduced), isNull);
        });
      }
    });
  }
}
