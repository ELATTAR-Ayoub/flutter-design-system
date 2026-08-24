import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/nav_user/meta.dart';
import 'package:example/components_docs/nav_user/page.dart';
import 'package:example/kit.dart' show ElSection;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// New on 2026-08-24, with the page: `ElNavUser` was documented inside
/// `carousel/page.dart` until the split.
///
/// The page's own section order, live demo excluded (it has no heading).
const List<String> _sectionOrder = <String>[
  'install',
  'usage',
  'footer',
  'account',
  'menu',
  'placement',
  'api',
  'states',
  'accessibility',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

/// The same list by title. A section title also renders in the right-rail
/// TOC at desktop width, so `find.text` would match each twice: the order is
/// read off the mounted `ElSection` widgets instead.
const List<String> _sectionTitles = <String>[
  'Installation',
  'Usage',
  'Sitting in a sidebar footer',
  'Naming the account',
  'Filling the menu',
  'Where the menu opens',
  'API Reference',
  'States',
  'Accessibility',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

/// Every named constructor parameter each exported class declares
/// (`lib/src/components/nav_user.dart`), excluding `key`.
const List<String> _navUserParams = <String>['user', 'items'];
const List<String> _accountParams = <String>['name', 'email', 'avatar'];
const List<String> _itemParams = <String>[
  'label',
  'icon',
  'onSelect',
  'destructive',
];

/// `MaterialApp` + `Scaffold` so the account dropdown has a real `Overlay` to
/// mount into: without one it silently never opens.
Widget _harness({
  required Widget child,
  required ElThemeController controller,
}) => ElTheme(
  controller: controller,
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  ),
);

void main() {
  group('meta', () {
    test('navUserDoc names the real public API surface', () {
      expect(navUserDoc.name, 'nav_user');
      expect(navUserDoc.title, 'Nav User');
      expect(navUserDoc.route, '/components/nav_user');
      expect(navUserDoc.sourcePath, 'lib/src/components/nav_user.dart');
      expect(navUserDoc.exports, <String>[
        'ElNavUser',
        'ElNavUserAccount',
        'ElNavUserItem',
      ]);
      // Nothing from the two families this page was split away from.
      expect(navUserDoc.exports, isNot(contains('ElCarousel')));
      expect(navUserDoc.exports, isNot(contains('ElMarker')));
    });

    test('ElNavUserAccount.initials is what the page documents', () {
      const ElNavUserAccount two = ElNavUserAccount(
        name: 'Alex Johnson',
        email: 'alex@example.com',
      );
      expect(two.initials, 'AJ');

      // The first letter of each of the FIRST TWO words only.
      const ElNavUserAccount three = ElNavUserAccount(
        name: 'Marguerite Okonkwo Adeyemi',
        email: 'alex@example.com',
      );
      expect(three.initials, 'MO');
    });
  });

  group('nav_user docs page', () {
    testWidgets(
      'renders the article, all three API tables, and the live specimens '
      'at desktop size',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: NavUserDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('nav-user-doc-article')),
          findsOneWidget,
        );

        for (final String param in <String>[
          ..._navUserParams,
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
        // menu floor, and the whole ElNavUserItem class.
        expect(find.text('ElNavUser.menuMinWidth'), findsWidgets);
        expect(find.text('ElNavUserItem'), findsWidgets);
        expect(find.text('initials'), findsWidgets);

        for (final String key in <String>[
          'nav-user-preview',
          'nav-user-example:footer',
          'nav-user-example:initials',
        ]) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing specimen $key',
          );
        }

        // Three live account rows, and the destructive row is real rather
        // than merely described.
        final List<ElNavUser> mounted = tester
            .widgetList<ElNavUser>(find.byType(ElNavUser))
            .toList();
        expect(mounted.length, 3);
        for (final ElNavUser navUser in mounted) {
          expect(
            navUser.items.where((ElNavUserItem i) => i.destructive),
            isNotEmpty,
            reason: 'no destructive item in a specimen',
          );
          expect(
            navUser.items.every((ElNavUserItem i) => i.label.isNotEmpty),
            isTrue,
          );
        }

        // The initials specimen really does carry the long, three-word name
        // its section is about.
        final ElNavUser initialsSpecimen = tester.widget<ElNavUser>(
          find.descendant(
            of: find.byKey(const ValueKey<String>('nav-user-example:initials')),
            matching: find.byType(ElNavUser),
          ),
        );
        expect(initialsSpecimen.user.initials, 'MO');

        expect(find.text('alex@example.com'), findsWidgets);
        expect(destination, isNull);
      },
    );

    testWidgets(
      'sections render in the documented order, section for section',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const NavUserDocPage(),
          ),
        );
        await tester.pump();

        final List<String> titles = tester
            .widgetList<ElSection>(find.byType(ElSection))
            .map((ElSection section) => section.title)
            .toList();
        expect(titles, _sectionTitles);

        double? previousTop;
        for (final String id in _sectionOrder) {
          final Finder finder = find.byKey(ElSection.anchorKey(id));
          expect(finder, findsOneWidget, reason: 'missing section "$id"');
          final double top = tester.getTopLeft(finder).dy;
          if (previousTop != null) {
            expect(
              top,
              greaterThan(previousTop),
              reason: '"$id" is out of order',
            );
          }
          previousTop = top;
        }
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
          controller: ElThemeController(mode: ElThemeMode.dark),
          child: const NavUserDocPage(),
        ),
      );
      await tester.pump();

      // The page-opening specimen, which sits above the fold but is scrolled
      // into view anyway rather than assumed to be hittable.
      final Finder trigger = find
          .descendant(
            of: find.byKey(const ValueKey<String>('nav-user-preview')),
            matching: find.byType(ElSidebarMenuButton),
          )
          .first;
      await tester.ensureVisible(trigger);
      await tester.pump();

      final int rowsBefore = find.text('Sign out').evaluate().length;
      // `ElMenuItem` is a row MODEL (a `ElMenuChild`), not a widget, so the
      // proof the overlay mounted is `ElMenuContent`, which only exists
      // while the portal is up.
      expect(find.byType(ElMenuContent), findsNothing);

      await tester.tap(trigger);
      await tester.pump();
      await tester.pump();
      await tester.pump(ElDurations.overlay);

      expect(
        find.byType(ElMenuContent),
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
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const NavUserDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('nav-user-doc-article')),
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

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const NavUserDocPage()),
        );
        await tester.pump();

        final ElThemeData darkTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('nav-user-doc-article')),
          ),
        );

        // Flip the SAME controller in place. A single pump(), never
        // pumpAndSettle().
        controller.setMode(ElThemeMode.light);
        await tester.pump();

        final ElThemeData lightTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('nav-user-doc-article')),
          ),
        );
        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        for (final String key in <String>[
          'nav-user-preview',
          'nav-user-example:footer',
          'nav-user-example:initials',
        ]) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
        expect(find.byType(ElNavUser), findsNWidgets(3));
      },
    );
  });
}
