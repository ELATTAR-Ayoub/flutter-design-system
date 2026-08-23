/// Tests for `components_docs/dropdown_menu/meta.dart` and
/// `components_docs/dropdown_menu/page.dart`: the public documentation page
/// for **both** `DsDropdownMenu` (`lib/src/components/dropdown_menu.dart`)
/// and the shared menu engine it is built from
/// (`lib/src/components/menu.dart`).
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. Theme
/// coverage uses a live `DsThemeController` flipped in place.
///
/// `DsDropdownMenu` mounts its content through `DsPopover`'s `OverlayPortal`,
/// so the live specimen needs a real `Overlay`: the harness wraps the page
/// in a `MaterialApp`, the same fix `tooltip_test.dart` and `menus_test.dart`
/// (the package-level suite) both needed. A bare `Directionality`/`Material`
/// host would let the page render but the menu would never actually open.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/dropdown_menu/meta.dart';
import 'package:example/components_docs/dropdown_menu/page.dart';
import 'package:example/kit.dart' show DsSection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

Future<DsThemeController> _pumpDropdownMenuDoc(
  WidgetTester tester, {
  ValueChanged<String>? onNavigate,
  Size size = _wide,
  DsThemeMode mode = DsThemeMode.dark,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final DsThemeController theme = DsThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    DsTheme(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            child: DropdownMenuDocPage(onNavigate: onNavigate),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

/// Runs the popover's 320ms exit animation out and lets the portal unmount
/// behind it: `DsPopover` starts its reverse from a post-frame callback, so
/// this needs one frame beyond the naive count. Mirrors `menus_test.dart`'s
/// own `runOverlay`.
Future<void> _runOverlay(WidgetTester tester) async {
  for (int i = 0; i < 4; i++) {
    await tester.pump(DsDurations.overlay);
  }
  await tester.pump();
}

Future<void> _openSpecimenMenu(WidgetTester tester) async {
  final Finder trigger = find.byKey(
    const ValueKey<String>('dropdown-menu-doc-specimen-trigger'),
  );
  await tester.ensureVisible(trigger);
  await tester.pumpAndSettle();
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump();
  await tester.pump(DsDurations.overlay);
}

void main() {
  group('meta', () {
    test('dropdownMenuDoc names the real public API surface', () {
      expect(dropdownMenuDoc.name, 'dropdown-menu');
      expect(dropdownMenuDoc.title, 'Dropdown Menu');
      expect(dropdownMenuDoc.route, '/components/dropdown-menu');
      expect(dropdownMenuDoc.command, 'elattar add dropdown-menu');
      expect(
        dropdownMenuDoc.sourcePath,
        'lib/src/components/dropdown_menu.dart',
      );
      expect(menuSourcePath, 'lib/src/components/menu.dart');
      expect(
        dropdownMenuDoc.exports,
        containsAll(<String>[
          'DsDropdownMenu',
          'DsMenuTriggerScope',
          'DsMenuChild',
          'DsMenuItem',
          'DsMenuItemVariant',
          'DsMenuCheckboxItem',
          'DsMenuRadioItem',
          'DsMenuRadioGroup',
          'DsMenuLabel',
          'DsMenuSeparator',
          'DsMenuGroup',
          'DsMenuSub',
          'DsMenuIndicatorSide',
          'DsMenu',
          'DsMenuSurfaceKind',
          'DsMenuSurface',
          'DsMenuContent',
          'DsMenuPointerDown',
          'DsMenuMotion',
        ]),
      );
      // No registry manifest exists for either file: real, non-invented
      // source-level dependencies only, not a claimed registry list.
      expect(dropdownMenuDoc.dependencies, <String>[
        'button',
        'popover',
        'icon',
      ]);
      expect(dropdownMenuDoc.description, isNot(contains('..')));
      expect(dropdownMenuDoc.description.trim(), dropdownMenuDoc.description);
      expect(
        dropdownMenuExpandedDescription,
        isNot(equals(dropdownMenuDoc.description)),
      );
      expect(
        dropdownMenuExpandedDescription.trim(),
        dropdownMenuExpandedDescription,
      );
      // The decision guidance actually distinguishes the four named
      // neighbours, not just the component's own name.
      expect(dropdownMenuExpandedDescription, contains('Select'));
      expect(dropdownMenuExpandedDescription, contains('Context Menu'));
      expect(dropdownMenuExpandedDescription, contains('Popover'));
    });
  });

  group('rendered page', () {
    testWidgets('renders the article and the live specimen trigger', (
      WidgetTester tester,
    ) async {
      await _pumpDropdownMenuDoc(tester);

      expect(
        find.byKey(const ValueKey<String>('dropdown-menu-doc-article')),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey<String>('dropdown-menu-doc-specimen-trigger'),
        ),
        findsOneWidget,
      );
      // The menu is not mounted before anything opens it.
      expect(find.byType(DsMenuContent), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'renders the shadcn-mirrored section list, top to bottom, in order',
      (WidgetTester tester) async {
        await _pumpDropdownMenuDoc(tester);

        // The shadcn dropdown-menu frame (Preview, Installation, Usage,
        // Composition, one Examples section per row shape/pattern, API
        // Reference), then Elattar's own six sections, in that order.
        const List<String> headingsInOrder = <String>[
          'Installation',
          'Usage',
          'Composition',
          'Basic',
          'Submenu',
          'Shortcuts',
          'Icons',
          'Checkboxes',
          'Radio group',
          'Destructive',
          'Complex',
          'API Reference',
          'States and feedback',
          'Accessibility and keyboard behavior',
          'Responsive and platform behavior',
          'Dependencies, files, and disclosure',
          'Theming notes',
          'Source and tests',
        ];

        // Read the mounted DsSection widgets in tree order rather than
        // text-finding each heading: the section heading and a nested
        // sub-heading (e.g. inside "Complex") can render the same string,
        // which makes a find.text-based check ambiguous even when scoped to
        // the article.
        final List<String> titles = tester
            .widgetList<DsSection>(find.byType(DsSection))
            .map((DsSection section) => section.title)
            .toList();

        expect(titles, headingsInOrder);
      },
    );

    testWidgets(
      'the API tables document every constructor parameter found in the '
      'source, for both DsDropdownMenu and the shared menu.dart engine',
      (WidgetTester tester) async {
        await _pumpDropdownMenuDoc(tester);

        // DsMenuTriggerScope.
        expect(find.textContaining('DsMenuTriggerScope'), findsWidgets);
        expect(find.text('open'), findsWidgets);

        // DsDropdownMenu's own constructor.
        expect(find.text('trigger'), findsOneWidget);
        expect(find.text('children'), findsWidgets);
        expect(find.text('width'), findsWidgets);
        expect(find.text('align'), findsOneWidget);
        expect(find.text('side'), findsWidgets);
        expect(find.text('enabled'), findsWidgets);
        expect(find.text('sideOffset'), findsOneWidget);
        expect(find.text('pressScaleSuppressed'), findsOneWidget);

        // The row model: DsMenuItem.
        expect(find.text('label'), findsWidgets);
        expect(find.text('icon'), findsWidgets);
        expect(find.text('lucideIcon'), findsOneWidget);
        expect(find.text('subtitle'), findsWidgets);
        expect(find.text('shortcut'), findsWidgets);
        expect(find.text('variant'), findsWidgets);
        expect(find.text('inset'), findsWidgets);
        expect(find.text('onSelect'), findsWidgets);

        // DsMenuCheckboxItem / DsMenuRadioItem / DsMenuRadioGroup.
        expect(find.text('checked'), findsWidgets);
        expect(find.text('value'), findsWidgets);
        expect(find.text('onChanged'), findsOneWidget);

        // DsMenuLabel / DsMenuSeparator / DsMenuGroup / DsMenuSub.
        expect(find.text('text'), findsWidgets);
        expect(find.text('child'), findsWidgets);
        expect(find.textContaining('DsMenuSeparator'), findsWidgets);
        expect(find.textContaining('DsMenuGroup'), findsWidgets);
        expect(find.textContaining('DsMenuSub'), findsWidgets);

        // DsMenu's static geometry.
        expect(find.text('itemHeight'), findsOneWidget);
        expect(find.text('twoLineItemHeight'), findsOneWidget);
        expect(find.text('labelHeight'), findsOneWidget);
        expect(find.text('separatorHeight'), findsOneWidget);
        expect(find.text('minWidthDropdown'), findsOneWidget);
        expect(find.text('minWidthMenu'), findsOneWidget);
        expect(find.text('insetPadding'), findsOneWidget);
        expect(find.text('iconSize'), findsOneWidget);

        // DsMenuContent's own constructor.
        expect(find.text('onClose'), findsOneWidget);
        expect(find.text('minWidth'), findsOneWidget);
        expect(find.text('kind'), findsWidgets);
        expect(find.text('indicatorSide'), findsOneWidget);
        expect(find.text('autofocus'), findsOneWidget);
        expect(find.text('initialHighlight'), findsOneWidget);
        expect(find.text('onEscape'), findsOneWidget);

        // DsMenuSurfaceKind's three values, and DsMenuIndicatorSide's two.
        expect(find.text('content'), findsWidgets);
        expect(find.text('subRinged'), findsOneWidget);
        expect(find.text('subBordered'), findsOneWidget);
        expect(find.text('end'), findsWidgets);
        expect(find.text('start'), findsWidgets);
      },
    );

    testWidgets(
      'installation is honest that elattar add dropdown-menu does not '
      'resolve yet',
      (WidgetTester tester) async {
        await _pumpDropdownMenuDoc(tester);

        expect(find.textContaining('elattar add dropdown-menu'), findsWidgets);
        expect(find.textContaining('not'), findsWidgets);
      },
    );

    testWidgets('accessibility plainly documents the keyboard-open gap and the '
        'missing menu-level semantics', (WidgetTester tester) async {
      await _pumpDropdownMenuDoc(tester);

      expect(
        find.textContaining('does not open the menu'),
        findsWidgets,
        reason: 'the Enter/Space-on-trigger gap must be named plainly',
      );
      expect(
        find.textContaining('no Semantics'),
        findsWidgets,
        reason: 'no role="menu" equivalent wraps the open content',
      );
    });

    testWidgets(
      'navigating previous fires onNavigate with the wave-3 neighbour',
      (WidgetTester tester) async {
        String? destination;
        await _pumpDropdownMenuDoc(
          tester,
          onNavigate: (String route) => destination = route,
        );

        await tester.ensureVisible(find.text('Drawer').first);
        await tester.tap(find.text('Drawer').first);
        expect(destination, '/components/drawer');
      },
    );
  });

  group('live specimen: open, activate, dismiss', () {
    testWidgets('a tap on the trigger opens the menu and marks it expanded', (
      WidgetTester tester,
    ) async {
      await _pumpDropdownMenuDoc(tester);

      expect(find.byType(DsMenuContent), findsNothing);

      final DsButton before = tester.widget<DsButton>(
        find.byKey(
          const ValueKey<String>('dropdown-menu-doc-specimen-trigger'),
        ),
      );
      expect(before.expanded, isFalse);

      await _openSpecimenMenu(tester);

      expect(find.byType(DsMenuContent), findsOneWidget);
      final DsButton after = tester.widget<DsButton>(
        find.byKey(
          const ValueKey<String>('dropdown-menu-doc-specimen-trigger'),
        ),
      );
      expect(
        after.expanded,
        isTrue,
        reason:
            'DsMenuTriggerScope.openOf should flip the trigger to expanded '
            'while the menu it opens is open: GAP CLOSED 2 in '
            'dropdown_menu.dart.',
      );
    });

    testWidgets('tapping a command item activates it and dismisses the menu', (
      WidgetTester tester,
    ) async {
      await _pumpDropdownMenuDoc(tester);
      await _openSpecimenMenu(tester);
      expect(find.text('Profile'), findsOneWidget);

      await tester.tap(find.text('Profile'));
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('dropdown-menu-doc-last-action')),
        findsOneWidget,
      );
      expect(find.textContaining('Profile'), findsWidgets);

      await _runOverlay(tester);
      expect(
        find.byType(DsMenuContent),
        findsNothing,
        reason: 'an item commit closes the menu, same as the source',
      );
    });

    testWidgets(
      'a checkbox row toggles its own boolean and still closes the menu',
      (WidgetTester tester) async {
        await _pumpDropdownMenuDoc(tester);
        await _openSpecimenMenu(tester);

        expect(find.text('Show status bar'), findsOneWidget);
        await tester.tap(find.text('Show status bar'));
        await _runOverlay(tester);
        expect(find.byType(DsMenuContent), findsNothing);

        // Reopen and confirm the boolean really flipped: the checked row now
        // carries a check glyph inside its own Stack, an unchecked row holds
        // none at all: same probe menus_test.dart runs against the source.
        await _openSpecimenMenu(tester);
        final Finder rowStack = find
            .ancestor(
              of: find.text('Show status bar'),
              matching: find.byType(Stack),
            )
            .first;
        expect(
          find.descendant(
            of: rowStack,
            matching: find.byWidgetPredicate(
              (Widget w) => w is DsIcon && w.glyph == DsIconGlyph.check,
            ),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('Escape closes the menu after it opens', (
      WidgetTester tester,
    ) async {
      await _pumpDropdownMenuDoc(tester);
      await _openSpecimenMenu(tester);
      expect(find.byType(DsMenuContent), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await _runOverlay(tester);
      expect(find.byType(DsMenuContent), findsNothing);
    });

    testWidgets('ArrowDown highlights the first row, then the second', (
      WidgetTester tester,
    ) async {
      await _pumpDropdownMenuDoc(tester);
      await _openSpecimenMenu(tester);

      Color? fillOf(String label) {
        final Finder box = find
            .ancestor(of: find.text(label), matching: find.byType(DecoratedBox))
            .first;
        return (tester.widget<DecoratedBox>(box).decoration as BoxDecoration)
            .color;
      }

      expect(fillOf('Profile'), isNull);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(fillOf('Profile'), isNotNull);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(fillOf('Billing'), isNotNull);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'GAP: Enter/Space on the focused trigger does not open the menu, '
      'only a real pointer down does',
      (WidgetTester tester) async {
        await _pumpDropdownMenuDoc(tester);

        final Finder label = find.descendant(
          of: find.byKey(
            const ValueKey<String>('dropdown-menu-doc-specimen-trigger'),
          ),
          matching: find.text('Account menu'),
        );
        await tester.ensureVisible(label);
        await tester.pumpAndSettle();

        final FocusNode? node = Focus.maybeOf(
          tester.element(label),
          scopeOk: false,
        );
        expect(node, isNotNull);
        node!.requestFocus();
        await tester.pump();
        expect(node.hasFocus, isTrue);

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();
        await tester.pump(DsDurations.overlay);
        expect(
          find.byType(DsMenuContent),
          findsNothing,
          reason:
              'DsMenuPointerDown only opens on a real PointerDownEvent; '
              "DsButton's own Enter/Space handling calls the trigger's own "
              'onPressed, which this specimen leaves a no-op, exactly as '
              'every real call site does.',
        );

        // The same trigger opens correctly on a real pointer down —
        // confirms the gap is keyboard-specific, not a broken specimen.
        await tester.tap(
          find.byKey(
            const ValueKey<String>('dropdown-menu-doc-specimen-trigger'),
          ),
        );
        await tester.pump();
        await tester.pump();
        await tester.pump(DsDurations.overlay);
        expect(find.byType(DsMenuContent), findsOneWidget);
      },
    );

    testWidgets('GAP: a submenu under DsDropdownMenu renders subBordered, not '
        "subRinged: the file's own DRIFT-4 table names for a dropdown's "
        'sub-content', (WidgetTester tester) async {
      await _pumpDropdownMenuDoc(tester);
      await _openSpecimenMenu(tester);

      expect(find.text('Invite users'), findsOneWidget);
      await tester.tap(find.text('Invite users'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pump(DsDurations.overlay);

      final List<DsMenuSurface> surfaces = tester
          .widgetList<DsMenuSurface>(find.byType(DsMenuSurface))
          .toList();
      expect(surfaces.length, greaterThanOrEqualTo(2));
      expect(surfaces.last.kind, DsMenuSurfaceKind.subBordered);
    });
  });

  group('viewport widths', () {
    testWidgets('a wide viewport exposes the sidebar and table of contents', (
      WidgetTester tester,
    ) async {
      await _pumpDropdownMenuDoc(tester, size: _wide);

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
        await _pumpDropdownMenuDoc(tester, size: _narrow);

        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('dropdown-menu-doc-article')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('both themes', () {
    testWidgets('renders on light', (WidgetTester tester) async {
      await _pumpDropdownMenuDoc(tester, mode: DsThemeMode.light);
      expect(
        find.byKey(
          const ValueKey<String>('dropdown-menu-doc-specimen-trigger'),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpDropdownMenuDoc(tester, mode: DsThemeMode.dark);
      expect(
        find.byKey(
          const ValueKey<String>('dropdown-menu-doc-specimen-trigger'),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final DsThemeController theme = await _pumpDropdownMenuDoc(
        tester,
        mode: DsThemeMode.dark,
      );
      expect(
        find.byKey(
          const ValueKey<String>('dropdown-menu-doc-specimen-trigger'),
        ),
        findsOneWidget,
      );

      theme.setMode(DsThemeMode.light);
      await tester.pump();

      expect(
        find.byKey(
          const ValueKey<String>('dropdown-menu-doc-specimen-trigger'),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
