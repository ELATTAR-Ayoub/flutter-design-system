import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/badge/meta.dart';
import 'package:example/components_docs/badge/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required DsThemeController controller,
}) => DsTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
);

/// Reads the resolved ink colour off the labelled specimen for [variant].
///
/// `page.dart` wraps each preview specimen in a `KeyedSubtree` keyed
/// `badge-preview:<variant.name>` specifically so a test can locate one
/// variant's rendered [DsText] without reaching into `DsBadge`'s private
/// `_ink`/`_fill` resolution.
Color _inkOf(WidgetTester tester, DsBadgeVariant variant) {
  final Finder key = find.byKey(
    ValueKey<String>('badge-preview:${variant.name}'),
  );
  final DsText text = tester.widget<DsText>(
    find.descendant(of: key, matching: find.byType(DsText)).first,
  );
  return text.color!;
}

/// Pairs whose ink is expected to coincide — asserted in the source itself
/// (`badge.dart`'s `_ink`): outline/ghost both fall back to
/// `mutedForeground`, and link/action both resolve to `actionInk`.
const List<(DsBadgeVariant, DsBadgeVariant)> _sharedInkPairs =
    <(DsBadgeVariant, DsBadgeVariant)>[
      (DsBadgeVariant.outline, DsBadgeVariant.ghost),
      (DsBadgeVariant.link, DsBadgeVariant.action),
    ];

bool _expectedShared(DsBadgeVariant a, DsBadgeVariant b) => _sharedInkPairs.any(
  ((DsBadgeVariant, DsBadgeVariant) pair) =>
      (pair.$1 == a && pair.$2 == b) || (pair.$1 == b && pair.$2 == a),
);

/// Every variant not in [_sharedInkPairs] must remain visually distinguishable
/// from every other variant within one theme.
void _assertVariantsDistinguishable(Map<DsBadgeVariant, Color> inks) {
  for (final DsBadgeVariant a in DsBadgeVariant.values) {
    for (final DsBadgeVariant b in DsBadgeVariant.values) {
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
            controller: DsThemeController(mode: DsThemeMode.dark),
            child: BadgeDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );

        expect(
          find.byKey(const ValueKey<String>('badge-doc-article')),
          findsOneWidget,
        );

        // The API table lists every DsBadge constructor parameter found in
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

        // A live specimen of every DsBadgeVariant mounts somewhere on the
        // page — not just the ones with distinct ink.
        final Set<DsBadgeVariant> mounted = tester
            .widgetList<DsBadge>(find.byType(DsBadge))
            .map((DsBadge badge) => badge.variant)
            .toSet();
        expect(mounted, containsAll(DsBadgeVariant.values));

        expect(badgeDoc.name, 'badge');
        expect(
          badgeDoc.exports,
          containsAll(<String>['DsBadge', 'DsBadgeVariant']),
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
            controller: DsThemeController(mode: DsThemeMode.dark),
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

        final DsThemeController controller = DsThemeController(
          mode: DsThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const BadgeDocPage()),
        );

        final Map<DsBadgeVariant, Color> darkInks = <DsBadgeVariant, Color>{
          for (final DsBadgeVariant v in DsBadgeVariant.values)
            v: _inkOf(tester, v),
        };
        _assertVariantsDistinguishable(darkInks);

        // Flip the SAME controller in place — not a fresh widget tree — the
        // same object every real theme toggle mutates.
        controller.setMode(DsThemeMode.light);
        await tester.pump();

        final Map<DsBadgeVariant, Color> lightInks = <DsBadgeVariant, Color>{
          for (final DsBadgeVariant v in DsBadgeVariant.values)
            v: _inkOf(tester, v),
        };
        _assertVariantsDistinguishable(lightInks);

        // The semantic inks are theme-resolved tokens (DsPalette.*Deep in
        // light, DsPalette.* in dark) — they must actually move when the
        // theme flips, not just stay internally distinguishable.
        for (final DsBadgeVariant v in <DsBadgeVariant>[
          DsBadgeVariant.destructive,
          DsBadgeVariant.outline,
          DsBadgeVariant.ghost,
          DsBadgeVariant.link,
          DsBadgeVariant.action,
          DsBadgeVariant.premium,
          DsBadgeVariant.success,
          DsBadgeVariant.warning,
          DsBadgeVariant.info,
        ]) {
          expect(
            lightInks[v],
            isNot(darkInks[v]),
            reason: '$v ink did not change when the theme flipped',
          );
        }
      },
    );
  });
}
