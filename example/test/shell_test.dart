/// The shell's contract: the chrome renders, the whole tree is reachable, and
/// the route you are on is the one the nav marks.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/main.dart';
import 'package:example/nav.dart';
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
    expect(find.text('Not ported yet'), findsOneWidget);
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

    // A link routes the page and closes the sheet.
    await tester.tap(colorsRow);
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

  testWidgets('every nav href resolves to a page', (WidgetTester tester) async {
    tester.useViewport(_desktop);
    await tester.pumpApp();

    for (final DsGroup group in dsGroups) {
      expect(pageFor(group.href), isNotNull);
      for (final DsCategory category in group.categories) {
        expect(pageFor(categoryHref(group, category)), isNotNull);
      }
    }
  });
}
