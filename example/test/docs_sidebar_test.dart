import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_sidebar.dart';
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

/// Real test-view sizing only — [tester.view.physicalSize] plus
/// [WidgetTester.view]'s own reset, never a synthetic `MediaQuery` override.
/// [controller] is a single live [ThemeController] a test can flip in place
/// with [ThemeController.setMode] instead of rebuilding a second tree for
/// the other theme.
Widget _harness({required Widget child, required ThemeController controller}) {
  return ThemeScope(
    controller: controller,
    child: MaterialApp(home: Material(child: child)),
  );
}

void _setViewSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Finds a [StyledText] by its authored string, not by the [Text] widget it
/// paints. A group label uses `.type-label`, which renders uppercase —
/// [StyledText.build] calls `text.toUpperCase()` before handing the string to
/// Flutter's own `Text` — so `find.text('Sections')` finds nothing; the
/// source string only survives on [StyledText] itself.
Finder _dsText(String text) => find.byWidgetPredicate(
  (Widget widget) => widget is StyledText && widget.text == text,
);

/// The reference two groups — "Sections" then "Components" — with "Button"
/// marked as the active page.
List<DocsSidebarGroup> _groups() => const <DocsSidebarGroup>[
  DocsSidebarGroup(
    label: 'Sections',
    items: <DocsSidebarEntry>[
      DocsSidebarEntry(title: 'Introduction', route: '/docs'),
      DocsSidebarEntry(title: 'Installation', route: '/docs/install'),
      DocsSidebarEntry(title: 'Theming', route: '/docs/theming'),
    ],
  ),
  DocsSidebarGroup(
    label: 'Components',
    items: <DocsSidebarEntry>[
      DocsSidebarEntry(title: 'Accordion', route: '/components/accordion'),
      DocsSidebarEntry(
        title: 'Button',
        route: '/components/button',
        selected: true,
      ),
      DocsSidebarEntry(title: 'Calendar', route: '/components/calendar'),
    ],
  ),
];

void main() {
  testWidgets(
    'both groups render with their labels, and every supplied item appears',
    (WidgetTester tester) async {
      _setViewSize(tester, const Size(1440, 900));
      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: DocsSidebar(groups: _groups(), onNavigate: (_) {}),
        ),
      );

      expect(
        find.byKey(const ValueKey<String>('docs-sidebar-group:Sections')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-sidebar-group:Components')),
        findsOneWidget,
      );
      expect(_dsText('Sections'), findsOneWidget);
      expect(_dsText('Components'), findsOneWidget);

      for (final String title in <String>[
        'Introduction',
        'Installation',
        'Theming',
        'Accordion',
        'Button',
        'Calendar',
      ]) {
        expect(find.text(title), findsOneWidget, reason: title);
      }
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('the active item is marked distinctly from the rest', (
    WidgetTester tester,
  ) async {
    _setViewSize(tester, const Size(1440, 900));
    await tester.pumpWidget(
      _harness(
        controller: ThemeController(mode: ColorMode.dark),
        child: DocsSidebar(groups: _groups(), onNavigate: (_) {}),
      ),
    );

    final Finder active = find.byKey(
      const ValueKey<String>('docs-sidebar:/components/button'),
    );
    final Finder inactive = find.byKey(
      const ValueKey<String>('docs-sidebar:/components/accordion'),
    );
    expect(active, findsOneWidget);
    expect(inactive, findsOneWidget);

    final Semantics activeSemantics = tester.widget<Semantics>(
      find.ancestor(of: active, matching: find.byType(Semantics)).first,
    );
    final Semantics inactiveSemantics = tester.widget<Semantics>(
      find.ancestor(of: inactive, matching: find.byType(Semantics)).first,
    );
    expect(activeSemantics.properties.selected, isTrue);
    expect(inactiveSemantics.properties.selected, isFalse);

    // The visual marker is a distinct background fill — no fill for the rest.
    final BoxDecoration activeDecoration =
        tester.widget<Container>(active).decoration! as BoxDecoration;
    final BoxDecoration inactiveDecoration =
        tester.widget<Container>(inactive).decoration! as BoxDecoration;
    expect(activeDecoration.color, isNotNull);
    expect(inactiveDecoration.color, isNull);
    expect(activeDecoration.color, isNot(inactiveDecoration.color));

    final StyledText activeText = tester.widget<StyledText>(
      find.descendant(of: active, matching: find.byType(StyledText)).first,
    );
    final StyledText inactiveText = tester.widget<StyledText>(
      find.descendant(of: inactive, matching: find.byType(StyledText)).first,
    );
    expect(activeText.color, isNot(inactiveText.color));
  });

  testWidgets('every entry wears a pointer cursor, selected or not', (
    WidgetTester tester,
  ) async {
    _setViewSize(tester, const Size(1440, 900));
    await tester.pumpWidget(
      _harness(
        controller: ThemeController(mode: ColorMode.dark),
        child: DocsSidebar(groups: _groups(), onNavigate: (_) {}),
      ),
    );

    for (final String route in <String>[
      '/docs',
      '/components/button',
      '/components/accordion',
    ]) {
      final Finder entry = find.byKey(ValueKey<String>('docs-sidebar:$route'));
      final MouseRegion region = tester.widget<MouseRegion>(
        find.ancestor(of: entry, matching: find.byType(MouseRegion)).first,
      );
      expect(region.cursor, SystemMouseCursors.click, reason: route);
    }
  });

  testWidgets('tapping an entry calls onNavigate with its route', (
    WidgetTester tester,
  ) async {
    _setViewSize(tester, const Size(1440, 900));
    final List<String> routes = <String>[];
    await tester.pumpWidget(
      _harness(
        controller: ThemeController(mode: ColorMode.dark),
        child: DocsSidebar(groups: _groups(), onNavigate: routes.add),
      ),
    );

    await tester.tap(find.text('Theming'));
    await tester.tap(find.text('Calendar'));

    expect(routes, <String>['/docs/theming', '/components/calendar']);
  });

  testWidgets('an empty group list renders nothing', (
    WidgetTester tester,
  ) async {
    _setViewSize(tester, const Size(1440, 900));
    await tester.pumpWidget(
      _harness(
        controller: ThemeController(mode: ColorMode.dark),
        child: DocsSidebar(
          groups: const <DocsSidebarGroup>[],
          onNavigate: (_) {},
        ),
      ),
    );

    expect(find.byType(DocsSidebar), findsOneWidget);
    expect(find.text('Sections'), findsNothing);
    expect(find.text('Components'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'renders without exception in both themes, flipped in place on one live '
    'controller',
    (WidgetTester tester) async {
      _setViewSize(tester, const Size(1440, 900));
      final ThemeController controller = ThemeController(mode: ColorMode.dark);
      await tester.pumpWidget(
        _harness(
          controller: controller,
          child: DocsSidebar(groups: _groups(), onNavigate: (_) {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Button'), findsOneWidget);

      controller.setMode(ColorMode.light);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Button'), findsOneWidget);
    },
  );

  testWidgets('renders without overflow at a narrow width too', (
    WidgetTester tester,
  ) async {
    // DocsSidebar has no breakpoint logic of its own — DocsLayout decides
    // whether to mount it at all below desktop width — but the rail's own
    // content must not overflow if it is ever given a narrow constraint.
    _setViewSize(tester, const Size(390, 844));
    await tester.pumpWidget(
      _harness(
        controller: ThemeController(mode: ColorMode.dark),
        child: SizedBox(
          width: 260,
          child: DocsSidebar(groups: _groups(), onNavigate: (_) {}),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
