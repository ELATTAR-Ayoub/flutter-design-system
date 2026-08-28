/// Tests for `components_docs/dropdown_menu/meta.dart` and
/// `components_docs/dropdown_menu/page.dart`: the public documentation page
/// for **both** `DropdownMenu` (`lib/src/components/dropdown_menu.dart`)
/// and the shared menu engine it is built from
/// (`lib/src/components/menu.dart`).
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery`. Theme
/// coverage uses a live `ThemeController` flipped in place.
///
/// `DropdownMenu` mounts its content through `Popover`'s `OverlayPortal`,
/// so the live specimen needs a real `Overlay`: the harness wraps the page
/// in a `MaterialApp`, the same fix `tooltip_test.dart` and `menus_test.dart`
/// (the package-level suite) both needed. A bare `Directionality`/`Material`
/// host would let the page render but the menu would never actually open.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/dropdown_menu/meta.dart';
import 'package:example/components_docs/dropdown_menu/page.dart';
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
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
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

Future<ThemeController> _pumpDropdownMenuDoc(
  WidgetTester tester, {
  ValueChanged<String>? onNavigate,
  Size size = _wide,
  ColorMode mode = ColorMode.dark,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ThemeController theme = ThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ThemeScope(
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
/// behind it: `Popover` starts its reverse from a post-frame callback, so
/// this needs one frame beyond the naive count. Mirrors `menus_test.dart`'s
/// own `runOverlay`.
Future<void> _runOverlay(WidgetTester tester) async {
  for (int i = 0; i < 4; i++) {
    await tester.pump(MotionDurations.overlayEnter);
  }
  await tester.pump();
}

Future<void> _openSpecimenMenu(WidgetTester tester) async {
  final Finder trigger = find.byKey(
    const ValueKey<String>('dropdown-menu-doc-specimen-trigger'),
  );
  await tester.ensureVisible(trigger);
  await tester.pump();
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump();
  await tester.pump(MotionDurations.overlayEnter);
}

/// The single `DocsDisclosure` whose title is [title]. `DocsDisclosure`'s
/// own trigger key (`DocsDisclosure.triggerKey`) is one constant shared by
/// every instance on the page, so a bare `find.byKey` would match all eight
/// — this narrows to the one panel by its title first, matching
/// `button_test.dart`'s own convention.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Opens the disclosure titled [title]: scrolls its trigger into view (no
/// `pumpAndSettle` — a menu doc page never settles, see the library note),
/// taps it, and lets the panel's own expand animation finish.
Future<void> _openDisclosure(WidgetTester tester, String title) async {
  final Finder trigger = _disclosureTrigger(title);
  await tester.ensureVisible(trigger);
  await tester.pump();
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(MotionDurations.open);
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
          'DropdownMenu',
          'MenuTriggerScope',
          'MenuChild',
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
          'Menu',
          'MenuSurfaceVariant',
          'MenuSurface',
          'MenuContent',
          'MenuPointerDown',
          'MenuMotion',
        ]),
      );
      expect(dropdownMenuDoc.dependencies, <String>[
        'button',
        'menu',
        'popover',
        'source-foundation',
      ]);
      expect(dropdownMenuDoc.description, isNot(contains('..')));
      expect(dropdownMenuDoc.description.trim(), dropdownMenuDoc.description);
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
      expect(find.byType(MenuContent), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'renders the shadcn-mirrored section list, top to bottom, in order',
      (WidgetTester tester) async {
        await _pumpDropdownMenuDoc(tester);

        // The kit house shape: Preview, Installation, Usage, Composition,
        // one section per row shape/pattern, then the eight disclosures.
        const List<String> headingsInOrder = <String>[
          'Preview',
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
          'States',
          'Accessibility',
          'Keyboard',
          'Responsive',
          'Dependencies',
          'Theming',
          'Source',
        ];

        // Read the mounted DocsSection widgets in tree order rather than
        // text-finding each heading: the section heading and a nested
        // sub-heading (e.g. inside "Complex") can render the same string,
        // which makes a find.text-based check ambiguous even when scoped to
        // the article.
        final List<String> titles = tester
            .widgetList<DocsSection>(find.byType(DocsSection))
            .map((DocsSection section) => section.title)
            .toList();

        expect(titles, headingsInOrder);
      },
    );

    testWidgets(
      'the API tables document every constructor parameter found in the '
      'source, for both DropdownMenu and the shared menu.dart engine',
      (WidgetTester tester) async {
        await _pumpDropdownMenuDoc(tester, size: const Size(1440, 4000));
        await _openDisclosure(tester, 'API Reference');

        // MenuTriggerScope.
        expect(find.textContaining('MenuTriggerScope'), findsWidgets);
        expect(find.text('open'), findsWidgets);

        // DropdownMenu's own constructor.
        expect(find.text('trigger'), findsOneWidget);
        expect(find.text('children'), findsWidgets);
        expect(find.text('width'), findsWidgets);
        expect(find.text('align'), findsOneWidget);
        expect(find.text('side'), findsWidgets);
        expect(find.text('enabled'), findsWidgets);
        expect(find.text('sideOffset'), findsOneWidget);
        expect(find.text('pressScaleSuppressed'), findsOneWidget);

        // The row model: MenuItem.
        expect(find.text('label'), findsWidgets);
        expect(find.text('icon'), findsWidgets);
        expect(find.text('lucideIcon'), findsOneWidget);
        expect(find.text('subtitle'), findsWidgets);
        expect(find.text('shortcut'), findsWidgets);
        expect(find.text('variant'), findsWidgets);
        expect(find.text('inset'), findsWidgets);
        expect(find.text('onSelect'), findsWidgets);

        // MenuCheckboxItem / MenuRadioItem / MenuRadioGroup.
        expect(find.text('checked'), findsWidgets);
        expect(find.text('value'), findsWidgets);
        expect(find.text('onChanged'), findsOneWidget);

        // MenuLabel / MenuSeparator / MenuGroup / MenuSub.
        expect(find.text('text'), findsWidgets);
        expect(find.text('child'), findsWidgets);
        expect(find.textContaining('MenuSeparator'), findsWidgets);
        expect(find.textContaining('MenuGroup'), findsWidgets);
        expect(find.textContaining('MenuSub'), findsWidgets);

        // Menu's static geometry.
        expect(find.text('itemHeight'), findsOneWidget);
        expect(find.text('twoLineItemHeight'), findsOneWidget);
        expect(find.text('labelHeight'), findsOneWidget);
        expect(find.text('separatorHeight'), findsOneWidget);
        expect(find.text('minWidthDropdown'), findsOneWidget);
        expect(find.text('minWidthMenu'), findsOneWidget);
        expect(find.text('insetPadding'), findsOneWidget);
        expect(find.text('iconSize'), findsOneWidget);

        // MenuContent's own constructor.
        expect(find.text('onClose'), findsOneWidget);
        expect(find.text('minWidth'), findsOneWidget);
        expect(find.text('kind'), findsWidgets);
        expect(find.text('indicatorSide'), findsOneWidget);
        expect(find.text('autofocus'), findsOneWidget);
        expect(find.text('initialHighlight'), findsOneWidget);
        expect(find.text('onEscape'), findsOneWidget);

        // MenuSurfaceVariant's three values, and MenuIndicatorSide's two.
        expect(find.text('content'), findsWidgets);
        expect(find.text('subRinged'), findsOneWidget);
        expect(find.text('subBordered'), findsOneWidget);
        expect(find.text('end'), findsWidgets);
        expect(find.text('start'), findsWidgets);
      },
    );

    testWidgets(
      'installation documents that elattar add dropdown-menu resolves '
      'both files through the shipped manifest',
      (WidgetTester tester) async {
        await _pumpDropdownMenuDoc(tester);

        expect(find.textContaining('elattar add dropdown-menu'), findsWidgets);
        expect(
          find.textContaining('registry/components/dropdown-menu.json'),
          findsWidgets,
        );
      },
    );

    testWidgets('accessibility and keyboard sections plainly document the '
        'keyboard-open gap and the missing menu-level semantics', (
      WidgetTester tester,
    ) async {
      await _pumpDropdownMenuDoc(tester, size: const Size(1440, 4000));
      await _openDisclosure(tester, 'Accessibility');
      await _openDisclosure(tester, 'Keyboard');

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

      expect(find.byType(MenuContent), findsNothing);

      final Button before = tester.widget<Button>(
        find.byKey(
          const ValueKey<String>('dropdown-menu-doc-specimen-trigger'),
        ),
      );
      expect(before.expanded, isFalse);

      await _openSpecimenMenu(tester);

      expect(find.byType(MenuContent), findsOneWidget);
      final Button after = tester.widget<Button>(
        find.byKey(
          const ValueKey<String>('dropdown-menu-doc-specimen-trigger'),
        ),
      );
      expect(
        after.expanded,
        isTrue,
        reason:
            'MenuTriggerScope.openOf should flip the trigger to expanded '
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
        find.byType(MenuContent),
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
        expect(find.byType(MenuContent), findsNothing);

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
              (Widget w) => w is Icon && w.glyph == IconGlyph.check,
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
      expect(find.byType(MenuContent), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await _runOverlay(tester);
      expect(find.byType(MenuContent), findsNothing);
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
        await tester.pump();

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
        await tester.pump(MotionDurations.overlayEnter);
        expect(
          find.byType(MenuContent),
          findsNothing,
          reason:
              'MenuPointerDown only opens on a real PointerDownEvent; '
              "Button's own Enter/Space handling calls the trigger's own "
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
        await tester.pump(MotionDurations.overlayEnter);
        expect(find.byType(MenuContent), findsOneWidget);
      },
    );

    testWidgets('GAP: a submenu under DropdownMenu renders subBordered, not '
        "subRinged: the file's own DRIFT-4 table names for a dropdown's "
        'sub-content', (WidgetTester tester) async {
      await _pumpDropdownMenuDoc(tester);
      await _openSpecimenMenu(tester);

      expect(find.text('Invite users'), findsOneWidget);
      await tester.tap(find.text('Invite users'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pump(MotionDurations.overlayEnter);

      final List<MenuSurface> surfaces = tester
          .widgetList<MenuSurface>(find.byType(MenuSurface))
          .toList();
      expect(surfaces.length, greaterThanOrEqualTo(2));
      expect(surfaces.last.kind, MenuSurfaceVariant.subBordered);
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
      await _pumpDropdownMenuDoc(tester, mode: ColorMode.light);
      expect(
        find.byKey(
          const ValueKey<String>('dropdown-menu-doc-specimen-trigger'),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders on dark', (WidgetTester tester) async {
      await _pumpDropdownMenuDoc(tester, mode: ColorMode.dark);
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
      final ThemeController theme = await _pumpDropdownMenuDoc(
        tester,
        mode: ColorMode.dark,
      );
      expect(
        find.byKey(
          const ValueKey<String>('dropdown-menu-doc-specimen-trigger'),
        ),
        findsOneWidget,
      );

      theme.setMode(ColorMode.light);
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
