import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/badge/meta.dart';
import 'package:example/components_docs/badge/page.dart';
import 'package:example/docs/docs_disclosure.dart';
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

/// The house-shape section order (`components_docs/button/page.dart`'s own
/// reference shape): Preview, Installation, Usage, then one section per
/// variant/state, then the eight fixed disclosures in their required order.
/// `Link` and `Custom Colors` are shadcn sections this component genuinely
/// cannot do (Badge has no href/asChild and no colour-override parameter)
/// and are asserted absent.
const List<String> _expectedSectionHeadings = <String>[
  'Preview',
  'Installation',
  'Usage',
  'Variants',
  'With icon',
  'With spinner',
  'RTL',
  'Composed with other primitives',
  'API Reference',
  'States',
  'Accessibility',
  'Keyboard',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

/// The single `DocsDisclosure` whose title is [title]. `DocsDisclosure`'s
/// own trigger key is one constant shared by every instance on the page, so
/// a bare `find.byKey` would match all eight — this narrows to the one panel
/// by its title first.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

Widget _harness({required Widget child, required ThemeController controller}) =>
    ThemeScope(
      controller: controller,
      child: MaterialApp(home: SingleChildScrollView(child: child)),
    );

/// Reads the resolved ink colour off the labelled specimen for [variant].
///
/// `page.dart` wraps each preview specimen in a `KeyedSubtree` keyed
/// `badge-preview:<variant.name>` specifically so a test can locate one
/// variant's rendered [StyledText] without reaching into `Badge`'s private
/// `_ink`/`_fill` resolution.
Color _inkOf(WidgetTester tester, BadgeVariant variant) {
  final Finder key = find.byKey(
    ValueKey<String>('badge-preview:${variant.name}'),
  );
  final StyledText text = tester.widget<StyledText>(
    find.descendant(of: key, matching: find.byType(StyledText)).first,
  );
  return text.color!;
}

/// Pairs whose ink is expected to coincide: asserted in the source itself
/// (`badge.dart`'s `_ink`): outline/ghost both fall back to
/// `mutedForeground`, and link/action both resolve to `actionText`.
const List<(BadgeVariant, BadgeVariant)> _sharedInkPairs =
    <(BadgeVariant, BadgeVariant)>[
      (BadgeVariant.outline, BadgeVariant.ghost),
      (BadgeVariant.link, BadgeVariant.action),
    ];

bool _expectedShared(BadgeVariant a, BadgeVariant b) => _sharedInkPairs.any(
  ((BadgeVariant, BadgeVariant) pair) =>
      (pair.$1 == a && pair.$2 == b) || (pair.$1 == b && pair.$2 == a),
);

/// Every variant not in [_sharedInkPairs] must remain visually distinguishable
/// from every other variant within one theme.
void _assertVariantsDistinguishable(Map<BadgeVariant, Color> inks) {
  for (final BadgeVariant a in BadgeVariant.values) {
    for (final BadgeVariant b in BadgeVariant.values) {
      if (a == b) continue;
      if (_expectedShared(a, b)) {
        expect(
          inks[a],
          inks[b],
          reason: '$a and $b are documented to share an ink token',
        );
      } else {
        expect(
          inks[a],
          isNot(inks[b]),
          reason: '$a and $b should read as visually distinct variants',
        );
      }
    }
  }
}

void main() {
  group('badge docs page', () {
    testWidgets(
      'renders the article, the full API table, and a live specimen of every variant',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: BadgeDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('badge-doc-article')),
          findsOneWidget,
        );

        // The API table lives inside the API Reference disclosure, closed by
        // default (a closed DocsDisclosure mounts no content at all), so
        // open it before reading any of its rows.
        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.normal);

        // The API table lists every Badge constructor parameter found in
        // lib/src/components/badge.dart.
        for (final String param in <String>[
          'label',
          'variant',
          'spec',
          'paddingX',
          'minWidth',
          'glyph',
        ]) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }

        // A live specimen of every BadgeVariant mounts somewhere on the
        // page: not just the ones with distinct ink.
        final Set<BadgeVariant> mounted = tester
            .widgetList<Badge>(find.byType(Badge))
            .map((Badge badge) => badge.variant)
            .toSet();
        expect(mounted, containsAll(BadgeVariant.values));

        expect(badgeDoc.name, 'badge');
        expect(
          badgeDoc.exports,
          containsAll(<String>['Badge', 'BadgeVariant']),
        );
        expect(destination, isNull);
      },
    );

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const BadgeDocPage(),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('badge-doc-article')),
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
      'variant inks stay grouped correctly and shift when the live theme flips',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ThemeController controller = ThemeController(
          mode: ColorMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const BadgeDocPage()),
        );

        final Map<BadgeVariant, Color> darkInks = <BadgeVariant, Color>{
          for (final BadgeVariant v in BadgeVariant.values)
            v: _inkOf(tester, v),
        };
        _assertVariantsDistinguishable(darkInks);

        // Flip the SAME controller in place: not a fresh widget tree, the
        // same object every real theme toggle mutates.
        controller.setMode(ColorMode.light);
        await tester.pump();

        final Map<BadgeVariant, Color> lightInks = <BadgeVariant, Color>{
          for (final BadgeVariant v in BadgeVariant.values)
            v: _inkOf(tester, v),
        };
        _assertVariantsDistinguishable(lightInks);

        // The semantic inks are theme-resolved tokens (Palette.*Deep in
        // light, Palette.* in dark): they must actually move when the
        // theme flips, not just stay internally distinguishable.
        for (final BadgeVariant v in <BadgeVariant>[
          BadgeVariant.destructive,
          BadgeVariant.outline,
          BadgeVariant.ghost,
          BadgeVariant.link,
          BadgeVariant.action,
          BadgeVariant.premium,
          BadgeVariant.success,
          BadgeVariant.warning,
          BadgeVariant.info,
        ]) {
          expect(
            lightInks[v],
            isNot(darkInks[v]),
            reason: '$v ink did not change when the theme flipped',
          );
        }
      },
    );

    testWidgets(
      'renders the shadcn-parity section headings in order, and skips '
      'Link and Custom Colors',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const BadgeDocPage(),
          ),
        );

        // Two sources, because the page renders section names two ways and
        // both are load bearing. A plain section prints its title as
        // `DocsSection`'s own `.type-h3`; a disclosure prints it as its
        // trigger row's `.type-h4`, beside the chevron that opens it, and
        // `DocsSection` deliberately prints no heading above that — see
        // `DocsSection.heading`. Reading only the h3s would silently stop
        // asserting the eight trailing disclosures, which is most of the
        // house shape.
        final List<String> headings = <String>[
          ...tester
              .widgetList<StyledText>(find.byType(StyledText))
              .where((StyledText text) => text.spec == TextStyles.h3)
              .map((StyledText text) => text.text),
          ...tester
              .widgetList<DocsDisclosure>(find.byType(DocsDisclosure))
              .map((DocsDisclosure disclosure) => disclosure.title),
        ];

        expect(headings, _expectedSectionHeadings);

        expect(find.text('Link'), findsNothing);
        expect(find.text('Custom Colors'), findsNothing);
      },
    );
  });
}
