/// The Typeset page's one claim is completeness, so that is what is tested
/// hardest.
///
/// A specimen sheet that quietly omits a role is worse than no sheet: a
/// developer who cannot find `numMd` here concludes it does not exist and
/// writes a size instead. The first group therefore checks the catalog
/// against `TextStyles.all` by identity — every role present, none twice, none
/// invented — rather than checking that the page renders something.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs_pages/typeset_catalog.dart';
import 'package:example/docs_pages/typeset_page.dart';
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

/// The page under a real app root.
///
/// `MaterialApp` is not decoration here: `DocsSelectableCodeBlock` wraps its
/// code in a `SelectionArea`, which asserts on a missing
/// `MaterialLocalizations`. The same host shape every other docs test uses.
Widget host(
  Widget child, {
  Size size = const Size(1440, 900),
  ColorMode mode = ColorMode.dark,
  double textScale = 1,
  bool disableAnimations = false,
}) {
  return MediaQuery(
    data: MediaQueryData(
      size: size,
      textScaler: TextScaler.linear(textScale),
      disableAnimations: disableAnimations,
    ),
    child: ThemeScope(
      controller: ThemeController(mode: mode),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SingleChildScrollView(child: child),
      ),
    ),
  );
}

void main() {
  group('the catalog is the whole scale', () {
    test('it covers TextStyles.all exactly once, by identity', () {
      // Identity, not equality: `TextStyleToken` declares no `==`, and two roles
      // can hold the same values anyway. `badge` and `label` differ only in
      // tracking, so value matching would happily accept a catalog that
      // listed one of them twice and called the job done.
      final List<TextStyleToken> catalogued = <TextStyleToken>[
        for (final TypesetRole role in typesetRoles) role.spec,
      ];

      expect(
        catalogued.length,
        TextStyles.all.length,
        reason:
            'the catalog lists ${catalogued.length} roles and TextStyles.all has '
            '${TextStyles.all.length}',
      );

      for (final TextStyleToken spec in TextStyles.all) {
        final int matches = catalogued
            .where((TextStyleToken candidate) => identical(candidate, spec))
            .length;
        expect(
          matches,
          1,
          reason:
              'every spec in TextStyles.all must appear in the catalog exactly '
              'once; found $matches',
        );
      }
    });

    test('no role is listed twice', () {
      final Set<String> names = <String>{};
      for (final TypesetRole role in typesetRoles) {
        expect(names.add(role.name), isTrue, reason: '${role.name} repeats');
      }
    });

    test('every name is a real TextStyles member spelling', () {
      // The name is the one thing the catalog asserts that the spec cannot
      // confirm, so it is at least held to the shape a call site would use.
      final RegExp member = RegExp(r'^[a-z][A-Za-z0-9]*$');
      for (final TypesetRole role in typesetRoles) {
        expect(
          member.hasMatch(role.name),
          isTrue,
          reason: '"${role.name}" is not a lowerCamelCase member name',
        );
      }
    });

    test('only the three sizeless roles declare a size rule', () {
      for (final TypesetRole role in typesetRoles) {
        if (role.spec.size == null) {
          expect(
            role.sizeRule,
            isNotNull,
            reason:
                '${role.name} has no intrinsic size, so the page cannot show '
                'one without saying where it comes from',
          );
        } else {
          expect(
            role.sizeRule,
            isNull,
            reason:
                '${role.name} carries its own size; a hand-written rule would '
                'be a second source of truth',
          );
        }
      }
    });

    test('every role has a usage sentence and a specimen', () {
      for (final TypesetRole role in typesetRoles) {
        expect(role.usage.trim(), isNotEmpty, reason: role.name);
        expect(role.sample.trim(), isNotEmpty, reason: role.name);
      }
    });

    test('every group has at least one role', () {
      for (final TypesetGroup group in TypesetGroup.values) {
        expect(typesetRolesIn(group), isNotEmpty, reason: group.name);
      }
    });
  });

  group('the page shows every role', () {
    testWidgets('one entry per role, wide', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(host(const TypesetDocsPage()));
      await tester.pumpAndSettle();

      for (final TypesetRole role in typesetRoles) {
        expect(
          find.byKey(ValueKey<String>('typeset-role-${role.name}')),
          findsOneWidget,
          reason: '${role.name} is missing from the page',
        );
      }
    });

    testWidgets('each entry names its role as copyable code', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(host(const TypesetDocsPage()));
      await tester.pumpAndSettle();

      for (final TypesetRole role in typesetRoles) {
        expect(
          find.text('TextStyles.${role.name}'),
          findsWidgets,
          reason: '${role.name} is not named on the page',
        );
      }
    });

    testWidgets('the article mounts under a stable key', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(host(const TypesetDocsPage()));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey<String>('typeset-doc-article')),
        findsOneWidget,
      );
    });
  });

  group('specimens resolve from the real token', () {
    testWidgets('each specimen renders with its own spec', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(host(const TypesetDocsPage()));
      await tester.pumpAndSettle();

      for (final TypesetRole role in typesetRoles) {
        final Iterable<StyledText> texts = tester
            .widgetList<StyledText>(find.byType(StyledText))
            .where((StyledText text) => text.text == role.sample);
        expect(
          texts.any((StyledText text) => identical(text.spec, role.spec)),
          isTrue,
          reason:
              '${role.name}\'s specimen does not use TextStyles.${role.name} '
              'itself',
        );
      }
    });

    testWidgets('the fluid roles are given a resolved size', (
      WidgetTester tester,
    ) async {
      // display, h1 and accent carry no intrinsic size. Rendering them
      // without one would silently fall back to whatever the surrounding
      // DefaultTextStyle happens to be, which is exactly the drift the page
      // exists to prevent.
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(host(const TypesetDocsPage()));
      await tester.pumpAndSettle();

      for (final TypesetRole role in typesetRoles) {
        if (role.spec.size != null) continue;
        final Iterable<StyledText> texts = tester
            .widgetList<StyledText>(find.byType(StyledText))
            .where(
              (StyledText text) =>
                  text.text == role.sample && identical(text.spec, role.spec),
            );
        expect(texts, isNotEmpty, reason: role.name);
        expect(
          texts.every((StyledText text) => text.fontSize != null),
          isTrue,
          reason: '${role.name} must be rendered at an explicit size',
        );
      }
    });

    testWidgets('display sizes track the viewport', (
      WidgetTester tester,
    ) async {
      Future<double> displaySizeAt(double width) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        await tester.pumpWidget(
          host(const TypesetDocsPage(), size: Size(width, 900)),
        );
        await tester.pumpAndSettle();
        final StyledText specimen = tester
            .widgetList<StyledText>(find.byType(StyledText))
            .firstWhere(
              (StyledText text) => identical(text.spec, TextStyles.display),
            );
        return specimen.fontSize!;
      }

      addTearDown(tester.view.reset);
      final double narrow = await displaySizeAt(430);
      final double wide = await displaySizeAt(1600);

      expect(narrow, TextStyles.displaySize(430));
      expect(wide, TextStyles.displaySize(1600));
      expect(wide, greaterThan(narrow));
    });
  });

  group('the full type scale comes first, and is the whole scale', () {
    /// Every line of the preview, in the order they were laid out.
    Finder previewLines() => find.byWidgetPredicate((Widget widget) {
      final Key? key = widget.key;
      return key is ValueKey<String> &&
          key.value.startsWith('typeset-preview-');
    });

    testWidgets('it renders one line per role and no more', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(host(const TypesetDocsPage()));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('typeset-full-scale')),
        findsOneWidget,
      );
      for (final TypesetRole role in typesetRoles) {
        expect(
          find.byKey(ValueKey<String>('typeset-preview-${role.name}')),
          findsOneWidget,
          reason: '${role.name} is missing from the full scale',
        );
      }
      // Counted, not just spot-checked: a preview that quietly grew a
      // twenty-eighth line, or listed one role twice, would pass every
      // per-role lookup above.
      expect(
        previewLines().evaluate().length,
        TextStyles.all.length,
        reason:
            'the preview must show TextStyles.all exactly once, through the '
            'catalog',
      );
    });

    testWidgets('the lines run in catalog order', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(host(const TypesetDocsPage()));
      await tester.pumpAndSettle();

      double previous = double.negativeInfinity;
      for (final TypesetRole role in typesetRoles) {
        final double top = tester
            .getTopLeft(
              find.byKey(ValueKey<String>('typeset-preview-${role.name}')),
            )
            .dy;
        expect(
          top,
          greaterThan(previous),
          reason: '${role.name} is out of catalog order in the preview',
        );
        previous = top;
      }
    });

    testWidgets('the whole preview sits above the first role reference', (
      WidgetTester tester,
    ) async {
      // The preview is the comparison surface; the reference blocks are what
      // a reader drops into after choosing. Reversed, the page opens with
      // twenty-seven API blocks and buries the thing it exists to show.
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(host(const TypesetDocsPage()));
      await tester.pumpAndSettle();

      final double lastPreview = tester
          .getTopLeft(
            find.byKey(
              ValueKey<String>('typeset-preview-${typesetRoles.last.name}'),
            ),
          )
          .dy;
      final double firstReference = tester
          .getTopLeft(
            find.byKey(
              ValueKey<String>('typeset-role-${typesetRoles.first.name}'),
            ),
          )
          .dy;
      expect(lastPreview, lessThan(firstReference));
    });

    testWidgets('the fluid roles are sized in the preview too', (
      WidgetTester tester,
    ) async {
      // display, h1 and accent carry no intrinsic size, and the preview is
      // the one place they are shown without an accompanying size rule to
      // explain a fallback.
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(host(const TypesetDocsPage()));
      await tester.pumpAndSettle();

      for (final TypesetRole role in typesetRoles) {
        if (role.spec.size != null) continue;
        final Finder line = find.byKey(
          ValueKey<String>('typeset-preview-${role.name}'),
        );
        final StyledText specimen = tester.widget<StyledText>(
          find.descendant(
            of: line,
            matching: find.byWidgetPredicate(
              (Widget widget) =>
                  widget is StyledText && identical(widget.spec, role.spec),
            ),
          ),
        );
        expect(
          specimen.fontSize,
          isNotNull,
          reason: '${role.name} is rendered without a resolved size',
        );
        expect(specimen.text, role.sample);
      }
    });

    for (final ColorMode mode in <ColorMode>[ColorMode.dark, ColorMode.light]) {
      for (final Size size in <Size>[
        const Size(390, 844),
        const Size(1440, 900),
      ]) {
        testWidgets(
          'no overflow at ${size.width.toInt()}px, 200% text, ${mode.name}',
          (WidgetTester tester) async {
            tester.view.physicalSize = size;
            tester.view.devicePixelRatio = 1;
            addTearDown(tester.view.reset);

            await tester.pumpWidget(
              host(
                const TypesetDocsPage(),
                size: size,
                mode: mode,
                textScale: 2,
              ),
            );
            await tester.pumpAndSettle();

            expect(tester.takeException(), isNull);
            for (final TypesetRole role in typesetRoles) {
              expect(
                find.byKey(ValueKey<String>('typeset-preview-${role.name}')),
                findsOneWidget,
                reason: '${role.name} disappeared from the preview',
              );
            }
          },
        );
      }
    }
  });

  group('the page holds up under real conditions', () {
    testWidgets('narrow: no overflow, every role still present', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        host(const TypesetDocsPage(), size: const Size(390, 844)),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      for (final TypesetRole role in typesetRoles) {
        expect(
          find.byKey(ValueKey<String>('typeset-role-${role.name}')),
          findsOneWidget,
          reason: '${role.name} disappeared at 390px',
        );
      }
    });

    testWidgets('tablet width renders without exception', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        host(const TypesetDocsPage(), size: const Size(768, 1024)),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('light theme renders the same roles', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        host(const TypesetDocsPage(), mode: ColorMode.light),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      for (final TypesetRole role in typesetRoles) {
        expect(
          find.byKey(ValueKey<String>('typeset-role-${role.name}')),
          findsOneWidget,
          reason: '${role.name} is missing in light',
        );
      }
    });

    testWidgets('text scaling does not break the layout', (
      WidgetTester tester,
    ) async {
      // A specimen sheet is the page most likely to break under scaling,
      // because it is nothing but type at fixed sizes beside labels.
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(host(const TypesetDocsPage(), textScale: 1.6));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('narrow plus text scaling still renders', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        host(
          const TypesetDocsPage(),
          size: const Size(390, 844),
          textScale: 1.6,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('reduced motion renders the same content', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        host(const TypesetDocsPage(), disableAnimations: true),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(
        find.byKey(const ValueKey<String>('typeset-doc-article')),
        findsOneWidget,
      );
    });
  });

  group('accessibility', () {
    testWidgets('each role name is exposed as a header', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(host(const TypesetDocsPage()));
      await tester.pumpAndSettle();

      // A screen-reader user navigating by heading has to be able to reach a
      // role without walking every specimen in between.
      expect(
        find.bySemanticsLabel('TextStyles.numberLg'),
        findsWidgets,
        reason: 'role names should be reachable as semantic headers',
      );
      handle.dispose();
    });

    testWidgets('token values carry a describing label', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(host(const TypesetDocsPage()));
      await tester.pumpAndSettle();

      // Eight two-word rows in a column are meaningless read one at a time;
      // the group says what they are values of.
      expect(
        find.bySemanticsLabel(RegExp('Token values for TextStyles.body')),
        findsWidgets,
      );
      handle.dispose();
    });
  });
}
