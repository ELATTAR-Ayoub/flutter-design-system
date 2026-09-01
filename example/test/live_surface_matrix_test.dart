/// The surface that actually ships, across the matrix it claims to support.
///
/// **This is a different surface from `responsive_text_scale_test.dart`.** That
/// file drives `pageFor`, the `/design-system/...` specimen tree. This one
/// drives `publicPageFor`, which is what `main.dart`'s router reaches: the
/// hundred `/components/<name>` reference pages built from
/// `components_docs/catalog.dart`, plus the site routes in
/// `site/site_routes.dart`. A reader of the docs site sees these; the router
/// falls every other path back to the documentation shell.
///
/// Both tests are worth having. The specimen tree is still the denser exercise
/// of the component catalogue and is still where the reflow work landed, but a
/// responsive claim about the shipped documentation has to be made against the
/// shipped documentation.
///
/// **Two configurations for the hundred component pages, four for the eleven
/// site routes.** A component reference page is one component and a table; the
/// two corners that break it are narrowest-at-200% and widest-at-100%, and a
/// four-way matrix over a hundred pages buys repetition rather than coverage.
/// The site routes are hand-composed marketing and index pages, where the
/// middle of the range is where the layout actually changes, so those take the
/// full four.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/catalog.dart';
import 'package:example/main.dart';
import 'package:example/site/site_routes.dart';
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

class _Config {
  const _Config({
    required this.label,
    required this.size,
    required this.mode,
    required this.scale,
  });

  final String label;
  final Size size;
  final ColorMode mode;
  final double scale;
}

const Size _mobile = Size(390, 844);
const Size _tablet = Size(768, 1024);
const Size _desktop = Size(1440, 900);

/// The two corners that break a component reference page.
const List<_Config> _componentMatrix = <_Config>[
  _Config(
    label: 'mobile dark 200%',
    size: _mobile,
    mode: ColorMode.dark,
    scale: 2,
  ),
  _Config(
    label: 'desktop light 100%',
    size: _desktop,
    mode: ColorMode.light,
    scale: 1,
  ),
];

/// The full four, for the hand-composed pages.
const List<_Config> _siteMatrix = <_Config>[
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

Widget _host(String route, _Config config) => ThemeScope(
  controller: ThemeController(mode: config.mode),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MediaQuery(
      data: MediaQueryData(
        size: config.size,
        textScaler: TextScaler.linear(config.scale),
      ),
      child: Builder(
        builder: (BuildContext context) => DefaultTextStyle(
          style: StyledText.styleOf(
            context,
            TextStyles.body,
            color: ThemeScope.of(context).foreground,
          ),
          // `publicPageFor` returns the page, not the shell that scrolls it.
          child: Material(
            child: SingleChildScrollView(child: publicPageFor(route)),
          ),
        ),
      ),
    ),
  ),
);

/// Pumps one route in one configuration and returns whatever it threw.
///
/// `pump` with a named duration rather than `pumpAndSettle`: several reference
/// pages mount `Alert`, `Skeleton` or `Spinner`, all of which animate forever,
/// so a settle would never return.
Future<Object?> _pumpRoute(WidgetTester t, String route, _Config config) async {
  t.view.physicalSize = config.size;
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.reset);

  await t.pumpWidget(_host(route, config));
  await t.pump(MotionDurations.open);
  return t.takeException();
}

void main() {
  group('component reference pages', () {
    for (final ComponentDocEntry entry in componentDocs) {
      for (final _Config config in _componentMatrix) {
        testWidgets('${entry.route} survives ${config.label}', (
          WidgetTester t,
        ) async {
          expect(await _pumpRoute(t, entry.route, config), isNull);
        });
      }
    }
  });

  group('site routes', () {
    for (final SiteRoute route in siteRoutes) {
      for (final _Config config in _siteMatrix) {
        testWidgets('${route.path} survives ${config.label}', (
          WidgetTester t,
        ) async {
          expect(await _pumpRoute(t, route.path, config), isNull);
        });
      }
    }
  });
}
