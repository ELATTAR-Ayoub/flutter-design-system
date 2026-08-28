import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/shell.dart';
import 'package:example/site/site_routes.dart';
import 'package:example/site/site_shell.dart';
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
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart' as flutter show RichText;

/// [WidgetsApp]'s `_errorTextStyle`, the style a [Text] inherits when nothing
/// above it declares one — "consider putting your text in a Material".
///
/// Restated here rather than imported because it is private to the framework,
/// and because a test that hard-codes the exact ink is a test that keeps
/// failing if the shell ever loses its [DefaultTextStyle] again.
const Color _fallbackInk = Color(0xD0FF0000);
const Color _fallbackUnderline = Color(0xFFFFFF00);

/// The style a rendered string actually resolves to — read off the paragraph
/// the framework laid out, not off the widget that asked for it, so the
/// inherited half of the cascade is included.
///
/// Reached through the [RichText] rather than straight off the [Text] element:
/// inside a [SelectionArea] — which the reading column is — a `Text` builds a
/// `MouseRegion` first, and that is the render object the element resolves to.
TextStyle _paintedStyle(WidgetTester tester, String text) => tester
    .firstRenderObject<RenderParagraph>(
      find.descendant(
        of: find.text(text),
        matching: find.byType(flutter.RichText),
      ),
    )
    .text
    .style!;

Widget _harness({required AppRouter router, required Widget child}) {
  final ThemeController theme = ThemeController(mode: ColorMode.dark);
  return ThemeScope(
    controller: theme,
    child: AppRouterScope(
      router: router,
      child: MaterialApp(debugShowCheckedModeBanner: false, home: child),
    ),
  );
}

extension on WidgetTester {
  void useViewport(Size size) {
    view.devicePixelRatio = 1;
    view.physicalSize = size;
    addTearDown(view.reset);
  }
}

void main() {
  testWidgets('desktop shell renders top destinations', (
    WidgetTester tester,
  ) async {
    tester.useViewport(const Size(1440, 900));
    final AppRouter router = AppRouter(route: homeRoute);

    await tester.pumpWidget(
      _harness(
        router: router,
        child: SiteShell(
          route: router.route,
          child: const SizedBox(height: 200, child: Text('Body')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // The header carries exactly two destinations. Introduction, Installation,
    // Theming, CLI and Skills are all documentation pages, so they live in the
    // documentation shell's left rail, not beside `Documentation` as its
    // peers. Home is reachable from the wordmark.
    expect(find.text('Documentation'), findsWidgets);
    expect(find.text('Components'), findsWidgets);
    expect(find.text('Skills'), findsNothing);
    expect(find.text('Installation'), findsNothing);
  });

  // Catches: deleting the `DefaultTextStyle` from `_SiteShellState.build`.
  //
  // Without it the shell has no text style of its own, so every string on
  // every public route falls back to `WidgetsApp`'s error style — error-red
  // ink under a double yellow underline. 2476 tests passed while that shipped
  // because none of them looked at a *resolved* style; this one does, on a
  // `.type-*` class that declares no colour of its own and therefore inherits
  // whatever the ancestor sets.
  testWidgets('public site text is not the SDK "missing Material" style', (
    WidgetTester tester,
  ) async {
    tester.useViewport(const Size(1440, 900));
    final AppRouter router = AppRouter(route: homeRoute);

    await tester.pumpWidget(
      _harness(
        router: router,
        child: SiteShell(
          route: router.route,
          // `.type-body` declares no `color`, so its ink is whatever the
          // enclosing `DefaultTextStyle` supplies — which is the leak.
          child: StyledText('Inherited probe paragraph', TextStyles.body),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final TextStyle probe = _paintedStyle(tester, 'Inherited probe paragraph');
    expect(probe.color, isNot(_fallbackInk));
    expect(probe.color, ThemeTokens.dark.foreground);
    expect(probe.decoration ?? TextDecoration.none, TextDecoration.none);
    expect(probe.decorationColor, isNot(_fallbackUnderline));
    expect(probe.decorationStyle, isNot(TextDecorationStyle.double));

    // The shell's own furniture, not just what a page hands it.
    final TextStyle footer = _paintedStyle(tester, 'Build with Elattar');
    expect(footer.decoration ?? TextDecoration.none, TextDecoration.none);
    expect(footer.decorationStyle, isNot(TextDecorationStyle.double));
  });

  // Catches: re-adding an unwired repository CTA to the header, the mobile
  // navigation sheet or the footer. It shipped raising a developer's to-do
  // note as a toast at every visitor who pressed it.
  testWidgets('no repository CTA is offered while the repository is private', (
    WidgetTester tester,
  ) async {
    for (final Size size in <Size>[
      const Size(1440, 900),
      const Size(390, 844),
    ]) {
      tester.useViewport(size);
      final AppRouter router = AppRouter(route: homeRoute);
      await tester.pumpWidget(
        _harness(
          router: router,
          child: SiteShell(
            route: router.route,
            child: const SizedBox(height: 200, child: Text('Body')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('GitHub'), findsNothing, reason: '$size');
      expect(find.text('Open GitHub'), findsNothing, reason: '$size');
      expect(
        find.bySemanticsLabel('Open GitHub repository'),
        findsNothing,
        reason: '$size',
      );
      expect(
        find.text('GitHub action not wired'),
        findsNothing,
        reason: '$size',
      );
    }
  });

  testWidgets('search opens, navigates, and exposes an empty state', (
    WidgetTester tester,
  ) async {
    tester.useViewport(const Size(1440, 900));
    final AppRouter router = AppRouter(route: homeRoute);

    await tester.pumpWidget(
      _harness(
        router: router,
        child: SiteShell(
          route: router.route,
          child: const SizedBox(height: 200, child: Text('Body')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Search documentation'));
    await tester.pumpAndSettle();

    expect(find.text('Search the public site'), findsOneWidget);
    expect(find.text('Quick open'), findsOneWidget);
    expect(find.text('Documentation'), findsWidgets);

    await tester.enterText(find.byType(EditableText).first, 'buttons');
    await tester.pumpAndSettle();
    expect(find.text('Components'), findsWidgets);

    await tester.tap(find.text('Buttons').first);
    await tester.pumpAndSettle();
    expect(router.route, '/design-system/components/base/buttons');

    await tester.tap(find.bySemanticsLabel('Search documentation'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText).first, 'not-a-real-route');
    await tester.pumpAndSettle();
    expect(find.text('Nothing matched that search'), findsOneWidget);

    await tester.tap(find.text('Open documentation'));
    await tester.pumpAndSettle();
    expect(router.route, docsRoute);
  });

  testWidgets('mobile shell opens navigation sheet and routes from it', (
    WidgetTester tester,
  ) async {
    tester.useViewport(const Size(390, 844));
    final AppRouter router = AppRouter(route: homeRoute);

    await tester.pumpWidget(
      _harness(
        router: router,
        child: SiteShell(
          route: router.route,
          child: const SizedBox(height: 200, child: Text('Body')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Open site navigation'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Open site navigation'));
    await tester.pumpAndSettle();

    expect(find.byType(SheetPanel), findsOneWidget);
    expect(find.text('DESIGN SYSTEM'), findsWidgets);

    // Skills is a documentation page now, so it is reached from the
    // documentation shell's left rail rather than from the site navigation
    // sheet. The sheet carries the same two destinations the header does.
    await tester.tap(find.text('Components').last);
    await tester.pumpAndSettle();
    expect(router.route, componentsRoute);
    expect(find.byType(SheetPanel), findsNothing);
  });
}
