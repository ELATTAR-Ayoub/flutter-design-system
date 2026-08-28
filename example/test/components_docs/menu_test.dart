/// Tests for `components_docs/menu/meta.dart` and
/// `components_docs/menu/page.dart`: the public documentation page for the
/// shared engine `dropdown-menu`, `context-menu` and `menubar` all mount.
///
/// `MenuContent` composes an `Popover` for its own submenu row, and
/// `Popover` walks up to a real `Overlay` (`Overlay.maybeOf`), so every
/// harness here wraps the page in a `MaterialApp` — the same reason
/// `select_test.dart` and `dropdown_menu_test.dart` both give.
///
/// No `pumpAndSettle` anywhere a menu specimen is mounted: `MenuContent`'s
/// own submenu can be timer-driven (a hover schedules a 100ms open), and a
/// `DocsDisclosure` on the same page drives a chevron controller — both are
/// advanced with an explicit `pump()`/`pump(duration)` pair instead.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/menu/meta.dart';
import 'package:example/components_docs/menu/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_link.dart' show DocsLink, DocsLinkRow;
import 'package:example/docs/docs_section.dart' show DocsSection;
import 'package:example/docs/docs_showcase.dart';
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

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

Widget _harness({required Widget child, required ThemeController controller}) =>
    ThemeScope(
      controller: controller,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SingleChildScrollView(child: child),
      ),
    );

Future<ThemeController> _pumpMenuDoc(
  WidgetTester tester, {
  ValueChanged<String>? onNavigate,
  Size size = _wide,
  ColorMode mode = ColorMode.dark,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ThemeController theme = ThemeController(mode: mode);
  await tester.pumpWidget(
    _harness(
      controller: theme,
      child: MenuDocPage(onNavigate: onNavigate),
    ),
  );
  await tester.pump();
  return theme;
}

/// The single `DocsSection` whose own `title` field is [title]. A section
/// heading and its own TOC/rail link render the same string, so a bare
/// `find.text` finds two widgets, not one — reading each mounted
/// `DocsSection`'s own `title` field sidesteps that, matching
/// `button_test.dart`'s own convention.
Finder _sectionByTitle(String title) => find.byWidgetPredicate(
  (Widget widget) => widget is DocsSection && widget.title == title,
);

/// The single `DocsDisclosure` whose title is [title]: `DocsDisclosure`'s
/// own trigger key is one constant shared by every instance on the page, so
/// a bare `find.byKey` would match all eight — this narrows to the one
/// panel by its title first, matching `button_test.dart`'s own convention.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Every named constructor parameter each of menu.dart's seventeen exports
/// declares, excluding `key`: the same set the page's own API tables claim
/// to cover. Parameter names that repeat across classes (`label`, `child`,
/// `children`, `enabled`, `inset`, `icon`, `onSelect`, `kind`, `value`) are
/// listed once.
const List<String> _menuApiParams = <String>[
  // MenuItem.
  'label',
  'icon',
  'lucideIcon',
  'subtitle',
  'shortcut',
  'variant',
  'enabled',
  'inset',
  'onSelect',
  // MenuCheckboxItem.
  'checked',
  // MenuRadioItem / MenuRadioGroup.
  'value',
  'children',
  'onChanged',
  // MenuLabel.
  'text',
  'child',
  // MenuContent.
  'onClose',
  'width',
  'minWidth',
  'kind',
  'indicatorSide',
  'autofocus',
  'initialHighlight',
  'onEscape',
  // MenuPointerDown.
  'onPointerDown',
];

const List<String> _menuApiTables = <String>[
  'MenuItem',
  'MenuItemVariant',
  'MenuCheckboxItem',
  'MenuRadioItem',
  'MenuRadioGroup',
  'MenuLabel',
  'MenuSeparator',
  'MenuGroup',
  'MenuSub',
  'MenuIndicatorSide',
  'MenuSurfaceVariant',
  'MenuSurface',
  'MenuContent',
  'MenuPointerDown',
  'MenuMotion',
];

void main() {
  group('meta', () {
    test('menuDoc names the real public API surface', () {
      expect(menuDoc.name, 'menu');
      expect(menuDoc.title, 'Menu');
      expect(menuDoc.route, '/components/menu');
      expect(menuDoc.command, 'elattar add menu');
      expect(menuDoc.sourcePath, 'lib/src/components/menu.dart');
      // registry/components/menu.json's own registryDependencies, verbatim.
      expect(menuDoc.dependencies, <String>[
        'icon',
        'popover',
        'source-foundation',
      ]);
      expect(
        menuDoc.exports,
        containsAll(<String>[
          'MenuChild',
          'MenuItemVariant',
          'MenuItem',
          'MenuCheckboxItem',
          'MenuRadioItem',
          'MenuRadioGroup',
          'MenuLabel',
          'MenuSeparator',
          'MenuGroup',
          'MenuSub',
          'MenuIndicatorSide',
          'MenuSurfaceVariant',
          'Menu',
          'MenuSurface',
          'MenuContent',
          'MenuPointerDown',
          'MenuMotion',
        ]),
      );
      expect(menuDoc.description, isNot(contains('..')));
      expect(menuDoc.description.trim(), menuDoc.description);
    });
  });

  group('rendered page', () {
    testWidgets('renders the article and the three live preview columns', (
      WidgetTester tester,
    ) async {
      await _pumpMenuDoc(tester);

      expect(
        find.byKey(const ValueKey<String>('menu-doc-article')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('menu-preview:dropdown')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('menu-preview:context')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('menu-preview:menubar')),
        findsOneWidget,
      );
      expect(find.byType(MenuContent), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('sections render top to bottom in the declared house order', (
      WidgetTester tester,
    ) async {
      await _pumpMenuDoc(tester, size: const Size(1440, 5200));

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Preview',
        'Installation',
        'Usage',
        'Row kinds',
        'Surface kinds',
        'Indicator side',
        'API Reference',
        'States',
        'Accessibility',
        'Keyboard',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ]);
    });

    test('the table of contents matches the declared sections', () {
      expect(
        menuDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Row kinds',
          'Surface kinds',
          'Indicator side',
          'API Reference',
          'States',
          'Accessibility',
          'Keyboard',
          'Responsive',
          'Dependencies',
          'Theming',
          'Source',
        ],
      );
    });

    testWidgets(
      'the layout is exactly three specimen stages, one install, eight '
      'disclosures',
      (WidgetTester tester) async {
        await _pumpMenuDoc(tester, size: const Size(1440, 5200));

        // Three specimen stages: Row kinds, Surface kinds, Indicator side.
        // Preview is its own ShowcaseSection too, for four total.
        expect(find.byType(DocsShowcase), findsNWidgets(4));
        expect(find.byType(DocsInstall), findsOneWidget);
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    testWidgets(
      'the API tables document every constructor parameter found in the '
      'source, and every export gets a table',
      (WidgetTester tester) async {
        await _pumpMenuDoc(tester, size: const Size(1440, 5200));

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String param in _menuApiParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        for (final String table in _menuApiTables) {
          expect(
            find.textContaining(table),
            findsWidgets,
            reason: 'missing $table',
          );
        }
      },
    );

    testWidgets('installation shows the real, registry-backed CLI command', (
      WidgetTester tester,
    ) async {
      await _pumpMenuDoc(tester);

      expect(find.text('elattar add menu'), findsWidgets);
      expect(find.textContaining('icon'), findsWidgets);
      expect(find.textContaining('popover'), findsWidgets);
    });

    testWidgets(
      'dependencies links out to all three consumers, not just names them',
      (WidgetTester tester) async {
        await _pumpMenuDoc(tester, size: const Size(1440, 5200));

        final Finder depsTrigger = _disclosureTrigger('Dependencies');
        await tester.ensureVisible(depsTrigger);
        await tester.pump();
        await tester.tap(depsTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        // Scoped to the DocsLinkRow itself: the sidebar's own component nav
        // renders links with the same names, and a bare find.text('Menubar')
        // matches both.
        final DocsLinkRow links = tester.widget<DocsLinkRow>(
          find.byType(DocsLinkRow),
        );
        final List<String> labels = links.links
            .map((DocsLink link) => link.label)
            .toList();
        expect(labels, contains('Dropdown Menu'));
        expect(labels, contains('Context Menu'));
        expect(labels, contains('Menubar'));
      },
    );

    testWidgets('keyboard documents the no-wrap and Tab-closes facts', (
      WidgetTester tester,
    ) async {
      await _pumpMenuDoc(tester, size: const Size(1440, 5200));

      final Finder keyboardTrigger = _disclosureTrigger('Keyboard');
      await tester.ensureVisible(keyboardTrigger);
      await tester.pump();
      await tester.tap(keyboardTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

      expect(find.textContaining('NO WRAP'), findsWidgets);
      expect(find.textContaining('Tab closes'), findsWidgets);
    });

    testWidgets('navigating next fires onNavigate with the linked page', (
      WidgetTester tester,
    ) async {
      String? destination;
      await _pumpMenuDoc(
        tester,
        onNavigate: (String route) => destination = route,
      );

      final Finder nextLink = find.widgetWithText(Button, 'Menubar').last;
      await tester.ensureVisible(nextLink);
      await tester.tap(nextLink);
      expect(destination, '/components/menubar');
    });
  });

  group('live specimens', () {
    testWidgets(
      'the Preview dropdown column commits an item and toggles a check row',
      (WidgetTester tester) async {
        await _pumpMenuDoc(tester);

        expect(find.text('Last action: Nothing yet'), findsOneWidget);

        await tester.tap(find.text('Profile'));
        await tester.pump();
        expect(find.text('Last action: Profile'), findsOneWidget);

        final MenuContent dropdown = tester.widget<MenuContent>(
          find.descendant(
            of: find.byKey(const ValueKey<String>('menu-preview:dropdown')),
            matching: find.byType(MenuContent),
          ),
        );
        expect(dropdown.minWidth, Menu.minWidthDropdown);

        final Finder checkboxRow = find.text('Show sidebar');
        await tester.ensureVisible(checkboxRow);
        await tester.pump();
        await tester.tap(checkboxRow);
        await tester.pump();
        // The checkbox commits through onSelect; the row's own checked value
        // is read back off the rebuilt MenuCheckboxItem in the child list.
        final MenuContent dropdownAfter = tester.widget<MenuContent>(
          find.descendant(
            of: find.byKey(const ValueKey<String>('menu-preview:dropdown')),
            matching: find.byType(MenuContent),
          ),
        );
        final MenuCheckboxItem checkbox = dropdownAfter.children
            .whereType<MenuCheckboxItem>()
            .first;
        expect(checkbox.checked, isFalse);
      },
    );

    testWidgets('the Preview menubar column uses indicatorSide.start', (
      WidgetTester tester,
    ) async {
      await _pumpMenuDoc(tester);

      final MenuContent menubar = tester.widget<MenuContent>(
        find.descendant(
          of: find.byKey(const ValueKey<String>('menu-preview:menubar')),
          matching: find.byType(MenuContent),
        ),
      );
      expect(menubar.indicatorSide, MenuIndicatorSide.start);
    });

    testWidgets('the Preview context column opens its submenu and reads back '
        'MenuSurfaceVariant.subBordered — the documented gap', (
      WidgetTester tester,
    ) async {
      await _pumpMenuDoc(tester, size: const Size(1440, 1400));

      // The page's own Surface kinds section mounts a static subBordered
      // sample regardless of this submenu, so the fact under test is not
      // "a subBordered surface exists somewhere" but "opening the
      // submenu adds exactly one more of them" — counted before and
      // after, rather than singled out through an ancestor chain that
      // OverlayEntry-based submenu placement makes ambiguous to walk.
      int subBorderedCount() => tester
          .widgetList<MenuSurface>(find.byType(MenuSurface))
          .where((MenuSurface s) => s.kind == MenuSurfaceVariant.subBordered)
          .length;
      final int before = subBorderedCount();

      await tester.ensureVisible(find.text('Share'));
      await tester.pump();
      await tester.tap(find.text('Share'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pump(MotionDurations.overlayEnter);

      expect(find.text('Copy link'), findsOneWidget);
      expect(subBorderedCount(), before + 1);
    });

    testWidgets('Row kinds mounts one of every MenuChild case', (
      WidgetTester tester,
    ) async {
      await _pumpMenuDoc(tester);

      final Finder host = find.byKey(
        const ValueKey<String>('menu-example:row-kinds'),
      );
      await tester.ensureVisible(host);
      await tester.pump();

      final MenuContent content = tester.widget<MenuContent>(
        find.descendant(of: host, matching: find.byType(MenuContent)),
      );
      expect(content.children.whereType<MenuLabel>(), isNotEmpty);
      expect(content.children.whereType<MenuSeparator>(), isNotEmpty);
      expect(content.children.whereType<MenuGroup>(), isNotEmpty);
      expect(content.children.whereType<MenuCheckboxItem>(), isNotEmpty);
      expect(content.children.whereType<MenuRadioGroup>(), isNotEmpty);
      expect(content.children.whereType<MenuSub>(), isNotEmpty);
      expect(
        content.children.whereType<MenuItem>().where(
          (MenuItem i) => i.variant == MenuItemVariant.destructive,
        ),
        isNotEmpty,
      );
    });

    testWidgets('Surface kinds mounts all three MenuSurfaceVariant values', (
      WidgetTester tester,
    ) async {
      await _pumpMenuDoc(tester);

      final Finder section = _sectionByTitle('Surface kinds');
      await tester.ensureVisible(section);
      await tester.pump();

      final Set<MenuSurfaceVariant> kinds = tester
          .widgetList<MenuSurface>(
            find.descendant(of: section, matching: find.byType(MenuSurface)),
          )
          .map((MenuSurface surface) => surface.kind)
          .toSet();
      expect(kinds, containsAll(MenuSurfaceVariant.values));
    });

    testWidgets('Indicator side mounts one end column and one start column', (
      WidgetTester tester,
    ) async {
      await _pumpMenuDoc(tester);

      final Finder section = _sectionByTitle('Indicator side');
      await tester.ensureVisible(section);
      await tester.pump();

      final Set<MenuIndicatorSide> sides = tester
          .widgetList<MenuContent>(
            find.descendant(of: section, matching: find.byType(MenuContent)),
          )
          .map((MenuContent content) => content.indicatorSide)
          .toSet();
      expect(sides, <MenuIndicatorSide>{
        MenuIndicatorSide.end,
        MenuIndicatorSide.start,
      });
    });
  });

  group('viewport widths', () {
    testWidgets('a wide viewport exposes the sidebar and table of contents', (
      WidgetTester tester,
    ) async {
      await _pumpMenuDoc(tester, size: _wide);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-toc')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'a narrow viewport drops to the anchor strip and stays reachable',
      (WidgetTester tester) async {
        await _pumpMenuDoc(tester, size: _narrow);

        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('menu-doc-article')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('both themes', () {
    testWidgets('renders on light', (WidgetTester tester) async {
      await _pumpMenuDoc(tester, mode: ColorMode.light);
      expect(find.byType(MenuContent), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpMenuDoc(tester, mode: ColorMode.dark);
      expect(find.byType(MenuContent), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final ThemeController theme = await _pumpMenuDoc(
        tester,
        mode: ColorMode.dark,
      );
      expect(find.byType(MenuContent), findsWidgets);

      theme.setMode(ColorMode.light);
      await tester.pump();

      expect(find.byType(MenuContent), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });
}
