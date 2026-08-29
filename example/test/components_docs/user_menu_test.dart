/// Tests for `components_docs/user_menu/meta.dart` and
/// `components_docs/user_menu/page.dart`: the public User Menu component
/// documentation page.
///
/// **Re-housed onto `ComponentDocSpec`/`ComponentDocPage`**, the same shape
/// `button_test.dart` and `popover_test.dart` assert against: sections read
/// through `DocsSection.title`, and the API table (now inside a
/// `DocsDisclosure`, closed by default) is opened before its rows are read.
/// No `pumpAndSettle` is used anywhere on this page.
///
/// New on 2026-08-24, with the page: `UserMenu` was documented inside
/// `carousel/page.dart` until the split.
///
/// `MaterialApp` + `Scaffold` so the account dropdown has a real `Overlay` to
/// mount into: without one it silently never opens.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/user_menu/meta.dart';
import 'package:example/components_docs/user_menu/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
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

const List<String> _sectionOrder = <String>[
  'Preview',
  'Installation',
  'Usage',
  'Sitting in a sidebar footer',
  'Naming the account',
  'Filling the menu',
  'Where the menu opens',
  'API Reference',
  'States',
  'Accessibility',
  'Keyboard',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

/// Every named constructor parameter each exported class declares
/// (`lib/src/components/ui/user_menu.dart`), excluding `key`.
const List<String> _userMenuParams = <String>['user', 'items'];
const List<String> _accountParams = <String>['name', 'email', 'avatar'];
const List<String> _itemParams = <String>[
  'label',
  'icon',
  'onSelect',
  'destructive',
];

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// `MaterialApp` + `Scaffold` so the account dropdown has a real `Overlay` to
/// mount into: without one it silently never opens.
Widget _harness({required Widget child, required ThemeController controller}) =>
    ThemeScope(
      controller: controller,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    );

void main() {
  group('meta', () {
    test('userMenuDoc names the real public API surface', () {
      expect(userMenuDoc.name, 'user_menu');
      expect(userMenuDoc.title, 'User Menu');
      expect(userMenuDoc.route, '/components/user_menu');
      expect(userMenuDoc.command, 'elattar add user-menu');
      expect(userMenuDoc.sourcePath, 'lib/src/components/ui/user_menu.dart');
      expect(userMenuDoc.exports, <String>[
        'UserMenu',
        'UserMenuAccount',
        'UserMenuItem',
      ]);
      // Nothing from the two families this page was split away from.
      expect(userMenuDoc.exports, isNot(contains('Carousel')));
      expect(userMenuDoc.exports, isNot(contains('Marker')));
    });

    test('UserMenuAccount.initials is what the page documents', () {
      const UserMenuAccount two = UserMenuAccount(
        name: 'Alex Johnson',
        email: 'alex@example.com',
      );
      expect(two.initials, 'AJ');

      // The first letter of each of the FIRST TWO words only.
      const UserMenuAccount three = UserMenuAccount(
        name: 'Marguerite Okonkwo Adeyemi',
        email: 'alex@example.com',
      );
      expect(three.initials, 'MO');
    });

    test('the table of contents matches the declared sections', () {
      expect(
        userMenuDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        _sectionOrder,
      );
    });
  });

  group('user_menu docs page', () {
    testWidgets('renders the article and the live specimens at desktop size', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      String? destination;
      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: UserMenuDocPage(
            onNavigate: (String route) => destination = route,
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('user-menu-doc-article')),
        findsOneWidget,
      );

      for (final String key in <String>[
        'user-menu-preview',
        'user-menu-example:footer',
        'user-menu-example:initials',
      ]) {
        expect(
          find.byKey(ValueKey<String>(key)),
          findsOneWidget,
          reason: 'missing specimen $key',
        );
      }

      // Three live account rows, and the destructive row is real rather
      // than merely described.
      final List<UserMenu> mounted = tester
          .widgetList<UserMenu>(find.byType(UserMenu))
          .toList();
      expect(mounted.length, 3);
      for (final UserMenu userMenu in mounted) {
        expect(
          userMenu.items.where((UserMenuItem i) => i.destructive),
          isNotEmpty,
          reason: 'no destructive item in a specimen',
        );
        expect(
          userMenu.items.every((UserMenuItem i) => i.label.isNotEmpty),
          isTrue,
        );
      }

      // The initials specimen really does carry the long, three-word name
      // its section is about.
      final UserMenu initialsSpecimen = tester.widget<UserMenu>(
        find.descendant(
          of: find.byKey(const ValueKey<String>('user-menu-example:initials')),
          matching: find.byType(UserMenu),
        ),
      );
      expect(initialsSpecimen.user.initials, 'MO');

      expect(find.text('alex@example.com'), findsWidgets);
      expect(destination, isNull);
    });

    testWidgets(
      'the API tables document every constructor parameter found in the source',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 4000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const UserMenuDocPage(),
          ),
        );
        await tester.pump();

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        for (final String param in <String>[
          ..._userMenuParams,
          ..._accountParams,
          ..._itemParams,
        ]) {
          expect(
            find.text(param),
            findsWidgets,
            reason: 'missing param $param',
          );
        }

        // The two members the pre-split tables omitted entirely: the static
        // menu floor, and the whole UserMenuItem class.
        expect(find.text('UserMenu.menuMinWidth'), findsWidgets);
        expect(find.text('UserMenuItem'), findsWidgets);
        expect(find.text('initials'), findsWidgets);
      },
    );

    testWidgets('keyboard plainly documents the shared menu engine and the '
        'component\'s own silence', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const UserMenuDocPage(),
        ),
      );
      await tester.pump();

      final Finder keyboardTrigger = _disclosureTrigger('Keyboard');
      await tester.ensureVisible(keyboardTrigger);
      await tester.pump();
      await tester.tap(keyboardTrigger);
      await tester.pump();
      await tester.pump(MotionDurations.open);

      expect(find.textContaining('ArrowDown'), findsWidgets);
      expect(find.textContaining('wires no key handling'), findsWidgets);
    });

    testWidgets('installation shows the real, registry-backed CLI command', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const UserMenuDocPage(),
        ),
      );
      await tester.pump();

      expect(find.text('elattar add user-menu'), findsWidgets);
      expect(find.textContaining('avatar'), findsWidgets);
    });

    testWidgets('the page is declared, and every section is a kit component', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 4000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const UserMenuDocPage(),
        ),
      );
      await tester.pump();

      // Three specimen stages: Preview, Sitting in a sidebar footer,
      // Naming the account.
      expect(find.byType(DocsShowcase), findsNWidgets(3));
      expect(find.byType(DocsInstall), findsOneWidget);
      // Eight collapsed sections: API Reference, States, Accessibility,
      // Keyboard, Responsive, Dependencies, Theming, Source.
      expect(find.byType(DocsDisclosure), findsNWidgets(8));
    });

    testWidgets(
      'sections render in the documented order, section for section',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const UserMenuDocPage(),
          ),
        );
        await tester.pump();

        final List<String> titles = tester
            .widgetList<DocsSection>(find.byType(DocsSection))
            .map((DocsSection section) => section.title)
            .toList();
        expect(titles, _sectionOrder);
      },
    );

    testWidgets('a tap on the account row opens the menu into a real Overlay', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: const UserMenuDocPage(),
        ),
      );
      await tester.pump();

      // The page-opening specimen, which sits above the fold but is scrolled
      // into view anyway rather than assumed to be hittable.
      final Finder trigger = find
          .descendant(
            of: find.byKey(const ValueKey<String>('user-menu-preview')),
            matching: find.byType(SidebarMenuButton),
          )
          .first;
      await tester.ensureVisible(trigger);
      await tester.pump();

      final int rowsBefore = find.text('Sign out').evaluate().length;
      // `MenuItem` is a row MODEL (a `MenuChild`), not a widget, so the
      // proof the overlay mounted is `MenuContent`, which only exists
      // while the portal is up.
      expect(find.byType(MenuContent), findsNothing);

      await tester.tap(trigger);
      await tester.pump();
      await tester.pump();
      await tester.pump(MotionDurations.overlayEnter);

      expect(
        find.byType(MenuContent),
        findsOneWidget,
        reason: 'the account menu did not reach an Overlay',
      );

      // Every row the specimen declares reaches the open menu, including
      // the destructive one below its separator. Counted against the
      // baseline, because this page also prints these labels inside its own
      // code samples.
      expect(find.text('Profile').evaluate().length, greaterThan(0));
      expect(find.text('Settings').evaluate().length, greaterThan(0));
      expect(
        find.text('Sign out').evaluate().length,
        greaterThan(rowsBefore),
        reason: 'the destructive row is not in the open menu',
      );
    });

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const UserMenuDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('user-menu-doc-article')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'survives a live theme flip in place without losing a specimen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ThemeController controller = ThemeController(
          mode: ColorMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const UserMenuDocPage()),
        );
        await tester.pump();

        final ThemeTokens darkTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('user-menu-doc-article')),
          ),
        );

        // Flip the SAME controller in place. A single pump(), never
        // pumpAndSettle().
        controller.setMode(ColorMode.light);
        await tester.pump();

        final ThemeTokens lightTheme = ThemeScope.of(
          tester.element(
            find.byKey(const ValueKey<String>('user-menu-doc-article')),
          ),
        );
        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        for (final String key in <String>[
          'user-menu-preview',
          'user-menu-example:footer',
          'user-menu-example:initials',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
        expect(find.byType(UserMenu), findsNWidgets(3));
      },
    );
  });
}
