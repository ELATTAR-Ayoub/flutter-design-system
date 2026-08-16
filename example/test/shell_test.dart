/// The shell's contract: the chrome renders, the whole tree is reachable, and
/// the route you are on is the one the nav marks.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/main.dart';
import 'package:example/nav.dart';
import 'package:example/pages/buttons.dart';
import 'package:example/pages/chat.dart';
import 'package:example/pages/colors.dart';
import 'package:example/pages/dialogs.dart';
import 'package:example/pages/feedback.dart';
import 'package:example/pages/forms.dart';
import 'package:example/pages/icons.dart';
import 'package:example/pages/inputs.dart';
import 'package:example/pages/menus.dart';
import 'package:example/pages/motion.dart';
import 'package:example/pages/navigation.dart';
import 'package:example/pages/overview.dart';
import 'package:example/pages/placeholder.dart';
import 'package:example/pages/selection.dart';
import 'package:example/pages/selects.dart';
import 'package:example/pages/shadows.dart';
import 'package:example/pages/spacing.dart';
import 'package:example/pages/typography.dart';
import 'package:example/shell.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The frame the design bar is set at (design spec §7).
const Size _desktop = Size(1440, 900);

/// Below `lg` — burger territory.
const Size _mobile = Size(800, 900);

extension on WidgetTester {
  /// Sizes the viewport in logical pixels, so `MediaQuery` breakpoints read
  /// the numbers the CSS media queries would.
  void useViewport(Size size) {
    view.devicePixelRatio = 1;
    view.physicalSize = size;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);
  }

  /// One extra pump past `pumpAndSettle`'s first frame: `DsSlidingPillGroup`
  /// measures after layout, so its first paint is one frame behind everything
  /// else.
  Future<void> pumpApp() async {
    await pumpWidget(const DocsApp());
    await pump();
    await pumpAndSettle();
  }
}

/// Every route that is really built, and the page each one must mount.
///
/// Named as types rather than counted, because `isNotNull` cannot tell a real
/// page from the [PlaceholderPage] every unbuilt href falls through to: a route
/// arm dropped by a bad merge would still have satisfied it, and the page would
/// have gone missing behind a title that looks right (ruling B11). Seventeen
/// arms, in `pageFor`'s own order.
const Map<String, Type> _wired = <String, Type>{
  dsRoot: OverviewPage,
  '$dsRoot/colors': ColorsPage,
  '$dsRoot/typography': TypographyPage,
  '$dsRoot/spacing': SpacingPage,
  '$dsRoot/shadows': ShadowsPage,
  '$dsRoot/motion': MotionPage,
  '$dsRoot/icons': IconsPage,
  '$dsRoot/components/base/buttons': ButtonsPage,
  '$dsRoot/components/base/inputs': InputsPage,
  '$dsRoot/components/base/forms': FormsPage,
  '$dsRoot/components/base/selects': SelectsPage,
  '$dsRoot/components/base/selection': SelectionPage,
  '$dsRoot/components/base/dialogs': DialogsPage,
  '$dsRoot/components/base/menus': MenusPage,
  '$dsRoot/components/base/navigation': NavigationPage,
  '$dsRoot/components/base/feedback': FeedbackPage,
  '$dsRoot/components/base/chat': ChatPage,
};

Iterable<({DsGroup group, DsCategory category})> get _everyCategory sync* {
  for (final DsGroup group in dsGroups) {
    for (final DsCategory category in group.categories) {
      yield (group: group, category: category);
    }
  }
}

void main() {
  testWidgets('header renders the chrome copy verbatim', (
    WidgetTester tester,
  ) async {
    tester.useViewport(_desktop);
    await tester.pumpApp();

    // `.type-micro` is `text-transform: uppercase`, so these are the rendered
    // strings, not the authored ones.
    expect(find.text('DESIGN SYSTEM V0.1'), findsOneWidget);
    expect(
      find.text('DESKTOP-FIRST · 1440 FRAME · LIGHT & DARK'),
      findsOneWidget,
    );
    // The wordmark is one rich span: `ELATTAR` + `.DS` in value ink.
    expect(
      find.textContaining('ELATTAR.DS', findRichText: true),
      findsOneWidget,
    );
  });

  testWidgets('sidebar carries all four groups and every category at 1440', (
    WidgetTester tester,
  ) async {
    tester.useViewport(_desktop);
    await tester.pumpApp();

    expect(dsGroups, hasLength(4));
    for (final DsGroup group in dsGroups) {
      // `.type-label`, also uppercase.
      expect(
        find.text(group.title.toUpperCase()),
        findsWidgets,
        reason: 'group label ${group.title} missing from the rail',
      );
    }

    final List<({DsGroup group, DsCategory category})> all =
        _everyCategory.toList();
    expect(all, hasLength(32));
    for (final ({DsGroup group, DsCategory category}) entry in all) {
      final String href = categoryHref(entry.group, entry.category);
      expect(
        find.byKey(ValueKey<String>('nav:$href')),
        findsOneWidget,
        reason: '${entry.category.title} ($href) missing from the rail',
      );
      expect(find.text(entry.category.title), findsWidgets);
    }
  });

  testWidgets('navigating to /design-system/colors marks that row active', (
    WidgetTester tester,
  ) async {
    tester.useViewport(_desktop);
    await tester.pumpApp();

    const String href = '$dsRoot/colors';
    final Finder row = find.byKey(const ValueKey<String>('nav:$href'));

    Border borderOf(Finder finder) =>
        (tester.widget<DecoratedBox>(finder).decoration as BoxDecoration).border!
            as Border;

    // At rest the row is `border-transparent`, letting the list's own hairline
    // show through the pixel it sits on.
    expect(borderOf(row).left.color, dsTransparent);

    await tester.tap(row);
    await tester.pumpAndSettle();

    final BoxDecoration active =
        tester.widget<DecoratedBox>(row).decoration as BoxDecoration;
    // `border-action bg-action/12`.
    expect((active.border! as Border).left.color, DsPalette.action);
    expect(active.color, DsPalette.action.withValues(alpha: 0.12));

    // …and the page under it changed: the title joins the rail entry.
    expect(find.text('Colors'), findsNWidgets(2));
    expect(find.text('MEASURED, NOT ASSERTED'), findsOneWidget);
  });

  testWidgets('the rail is 240px including its rule, and a row label clears '
      'its own', (WidgetTester tester) async {
    tester.useViewport(_desktop);
    await tester.pumpApp();

    // `aside.w-60.border-r` under `box-sizing: border-box`: 240px *including*
    // the right-hand hairline, so the nav content box is 239 and `main`
    // starts at exactly 240. Get this wrong and the centred 1080 column
    // shifts a pixel against the reference.
    final Finder rail = find.ancestor(
      of: find.byType(NavTree),
      matching: find.byType(SingleChildScrollView),
    );
    expect(tester.getSize(rail).width, DsWidths.rail - DsWidths.hairline);
    expect(tester.getTopLeft(rail).dx, 0);

    // The row is `-ml-px border-l pl-4`: its own hairline sits on the list's,
    // and the label starts inside it — 17px from the list's left edge, not 16.
    final Finder row =
        find.byKey(const ValueKey<String>('nav:$dsRoot/colors'));
    expect(
      tester.getTopLeft(find.descendant(of: row, matching: find.text('Colors')))
              .dx -
          tester.getTopLeft(row).dx,
      closeTo(ds(4) + DsWidths.hairline, 0.01),
    );
  });

  testWidgets('below lg the rail is gone and the burger opens the sheet', (
    WidgetTester tester,
  ) async {
    tester.useViewport(_mobile);
    await tester.pumpApp();

    final Finder colorsRow =
        find.byKey(const ValueKey<String>('nav:$dsRoot/colors'));
    expect(colorsRow, findsNothing);
    expect(find.byType(NavTree), findsNothing);

    await tester.tap(find.bySemanticsLabel('Open design system navigation'));
    await tester.pumpAndSettle();

    expect(find.byType(NavTree), findsOneWidget);
    expect(colorsRow, findsOneWidget);

    // A link routes the page *underneath* and leaves the sheet standing: the
    // docs `DsMobileNav` renders `<NavTree />` with no `onNavigate`, so nothing
    // wraps its links in a `SheetClose` (shell-map §3, drift register item 6).
    await tester.tap(colorsRow);
    await tester.pumpAndSettle();
    expect(find.byType(NavTree), findsOneWidget);
    expect(colorsRow, findsOneWidget);

    // And the row the sheet marks moved with the page, the way `usePathname()`
    // re-renders the open tree: `border-action bg-action/12`.
    final BoxDecoration active =
        tester.widget<DecoratedBox>(colorsRow).decoration as BoxDecoration;
    expect((active.border! as Border).left.color, DsPalette.action);
    expect(active.color, DsPalette.action.withValues(alpha: 0.12));
    // The sheet's nav row, plus the title of the page now under it.
    expect(find.text('Colors'), findsNWidgets(2));

    // What does close it: the X the reference leaves in the corner.
    await tester.tap(
      find.descendant(
        of: find.byType(DsSheetPanel),
        matching: find.bySemanticsLabel('Close'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(NavTree), findsNothing);
    expect(find.text('Colors'), findsOneWidget);
  });

  testWidgets('the theme toggle reports the chosen mode, not the resolved one',
      (WidgetTester tester) async {
    tester.useViewport(_desktop);
    await tester.pumpApp();

    int activeIndex() => tester
        .widget<DsSlidingPillGroup>(find.byType(DsSlidingPillGroup))
        .activeIndex;

    // `defaultTheme="dark"` — the third option.
    expect(activeIndex(), 2);

    await tester.tap(find.bySemanticsLabel('Light'));
    await tester.pumpAndSettle();
    expect(activeIndex(), 0);

    await tester.tap(find.bySemanticsLabel('System'));
    await tester.pumpAndSettle();
    expect(activeIndex(), 1);
  });

  testWidgets('every nav href resolves to a page, and a built route to its '
      'own', (WidgetTester tester) async {
    tester.useViewport(_desktop);
    await tester.pumpApp();

    final Set<String> hrefs = <String>{
      for (final DsGroup group in dsGroups) group.href,
      for (final ({DsGroup group, DsCategory category}) entry in _everyCategory)
        categoryHref(entry.group, entry.category),
    };

    // The table is an inventory, so it has to be spent: a route arm pointing at
    // an href the nav does not carry is a page nothing can reach.
    expect(
      _wired.keys.where((String route) => !hrefs.contains(route)),
      isEmpty,
      reason: 'these routes are wired but absent from the nav',
    );

    for (final String href in hrefs) {
      final Widget page = pageFor(href);
      final Type? built = _wired[href];
      if (built == null) {
        expect(
          page,
          isA<PlaceholderPage>(),
          reason: '$href is not built yet, so it falls through to the '
              'placeholder — and nothing else may',
        );
      } else {
        expect(
          page.runtimeType,
          built,
          reason: '$href must mount $built, not ${page.runtimeType}',
        );
      }
    }
  });
}
