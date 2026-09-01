/// Wiring tests for the four `docs_pages/` articles (`IntroductionDocsPage`,
/// `InstallationDocsPage`, `ThemingDocsPage`, `CliDocsPage`): that
/// `main.dart`'s `publicPageFor` actually dispatches their route to their
/// widget, and that the documentation shell's "Sections" group — the first
/// of the five the rail now has (`docs/docs_layout.dart`'s
/// `_defaultSidebarGroups`, read from `site/site_routes.dart`'s
/// `siteRoutes`, neither file touched here) — lists them in the required
/// reading order.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs_pages/catalog.dart';
import 'package:example/main.dart';
import 'package:example/site/pages/public_pages.dart';
import 'package:example/site/site_routes.dart';
import 'package:flutter/material.dart'
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
        TableColumnWidth,
        ActionChip,
        AlertDialog,
        Badge,
        Card,
        CarouselController,
        Checkbox,
        Dialog,
        DropdownMenu,
        Drawer,
        DrawerHeader,
        Slider,
        Switch,
        TextFormField,
        Tooltip;
import 'package:flutter_test/flutter_test.dart';

/// The ambient ink every route inherits, as the shell sets it for the real app.
///
/// A surface mounted bare in a test has no shell above it, so the nearest
/// `DefaultTextStyle` is `WidgetsApp`'s red fallback — which `StyledText`
/// asserts on rather than quietly painting over. Threaded through
/// `MaterialApp.builder` so it covers routes and overlays too, not just `home`.
Widget _ambientInk(BuildContext context, Widget? child) => DefaultTextStyle(
  style: StyledText.styleOf(
    context,
    TextStyles.body,
    color: ThemeScope.of(context).foreground,
  ),
  child: child!,
);

Widget _harness(Widget child) => ThemeScope(
  controller: ThemeController(mode: ColorMode.dark),
  child: MaterialApp(
    builder: _ambientInk,
    debugShowCheckedModeBanner: false,
    home: SingleChildScrollView(child: child),
  ),
);

void _sizeTo(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
}

/// The `docs-sidebar:<route>` keys rendered under the "Sections" group, top
/// to bottom, exactly as `DocsSidebar` laid them out.
List<String> _sectionsOrder(WidgetTester tester) {
  final Finder group = find.byKey(
    const ValueKey<String>('docs-sidebar-group:Sections'),
  );
  expect(group, findsOneWidget);

  final Iterable<Element> rows = find
      .descendant(
        of: group,
        matching: find.byWidgetPredicate((Widget widget) {
          final Key? key = widget.key;
          return key is ValueKey<String> &&
              key.value.startsWith('docs-sidebar:');
        }),
      )
      .evaluate();

  return <String>[
    for (final Element element in rows)
      (element.widget.key! as ValueKey<String>).value.substring(
        'docs-sidebar:'.length,
      ),
  ];
}

void main() {
  group('every docs_pages route resolves through publicPageFor', () {
    // All seven the catalog declares. Three of them — typeset, registry and
    // changelog — were declared for weeks with nothing routing to them, so
    // `publicPageFor` fell through to its default arm and served the
    // homepage. A declared route that quietly resolves to a different page
    // is worse than a missing one: it looks like it worked.
    const Map<String, Key> pages = <String, Key>{
      docsIntroductionRoute: ValueKey<String>('introduction-doc-article'),
      docsInstallationRoute: ValueKey<String>('installation-doc-article'),
      docsThemingRoute: ValueKey<String>('theming-doc-article'),
      docsCliRoute: ValueKey<String>('cli-doc-article'),
      docsTypesetRoute: ValueKey<String>('typeset-doc-article'),
      docsRegistryRoute: ValueKey<String>('registry-doc-article'),
      docsChangelogRoute: ValueKey<String>('changelog-doc-article'),
    };

    for (final MapEntry<String, Key> page in pages.entries) {
      testWidgets('${page.key} mounts its article and its own Sections '
          'entry, marked selected', (WidgetTester tester) async {
        _sizeTo(tester, const Size(1440, 900));
        await tester.pumpWidget(_harness(publicPageFor(page.key)));

        // The page's article root mounted: this is the actual widget the
        // route dispatches to, not a fallback like `PublicHomePage`.
        expect(find.byKey(page.value), findsOneWidget);

        final Finder ownEntry = find.byKey(
          ValueKey<String>('docs-sidebar:${page.key}'),
        );
        expect(ownEntry, findsOneWidget);
        final Semantics semantics = tester.widget<Semantics>(
          find.ancestor(of: ownEntry, matching: find.byType(Semantics)).first,
        );
        expect(semantics.properties.selected, isTrue);

        expect(tester.takeException(), isNull);
      });
    }
  });

  testWidgets('an unknown path falls back to the homepage, deliberately', (
    WidgetTester tester,
  ) async {
    // Documented in `publicPageFor`: a path the site never advertised is a
    // stale bookmark or a typo, and a static deep-linked site has nowhere
    // better to send it. The value of asserting it is that the fallback stops
    // being able to absorb a *declared* route by accident — which is what it
    // did to typeset, registry and changelog for weeks.
    _sizeTo(tester, const Size(1440, 900));
    await tester.pumpWidget(_harness(publicPageFor('/docs/not-a-real-page')));
    await tester.pumpAndSettle();

    expect(find.byType(PublicHomePage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'the Sections group lists Introduction, Components, Installation, '
    'Theming, CLI, Typeset, Registry, Changelog and Skills in that order; '
    'Documentation alone has no entry there',
    (WidgetTester tester) async {
      _sizeTo(tester, const Size(1440, 900));
      await tester.pumpWidget(_harness(publicPageFor(docsIntroductionRoute)));

      final List<String> order = _sectionsOrder(tester);
      // `docsRoute` ("Documentation") still resolves through `main.dart`'s
      // `publicPageFor` and still appears in quick search, see the note on
      // `siteRoutes` in `site/site_routes.dart`; it is just excluded from
      // this rail via `SiteRoute.showInSidebar`.
      expect(order, <String>[
        docsIntroductionRoute,
        componentsRoute,
        docsInstallationRoute,
        docsThemingRoute,
        docsCliRoute,
        docsTypesetRoute,
        docsRegistryRoute,
        docsChangelogRoute,
        skillsRoute,
      ]);
      expect(order, isNot(contains(docsRoute)));
      // Asserted absent until each grew a page. Now every route the
      // catalog declares must reach the sidebar, which is the property that
      // stops a declared route from being invisible.
      expect(order, contains(docsTypesetRoute));
      expect(order, contains(docsRegistryRoute));
      expect(order, contains(docsChangelogRoute));

      expect(tester.takeException(), isNull);
    },
  );
}
