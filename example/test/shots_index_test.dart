/// The Shots index page: catalog coverage, family/platform filters, the
/// empty state, responsive reflow, and both themes.
///
/// No `pumpAndSettle` anywhere, mirroring `buttons_page_test.dart`: the
/// harness mounts under `disableAnimations`, the reduced-motion gate every
/// controller in the package routes through (including the toggle group's
/// travelling pill), so a single `pump` is a finished frame.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/shots_docs/catalog.dart';
import 'package:example/shots_docs/shots_index_page.dart';
// `PublicNavigate` is declared here, and only here. The index page used to
// declare a second copy of the typedef; that duplicate is gone.
import 'package:example/site/pages/public_pages.dart' show PublicNavigate;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Map<ShotFamily, String> _familyLabels = <ShotFamily, String>{
  ShotFamily.account: 'Account',
  ShotFamily.authentication: 'Authentication',
  ShotFamily.dashboard: 'Dashboard',
};

const Map<ShotPlatform, String> _platformLabels = <ShotPlatform, String>{
  ShotPlatform.responsive: 'Responsive',
  ShotPlatform.desktop: 'Desktop',
  ShotPlatform.mobile: 'Mobile',
};

Finder _shotCard(ShotDocEntry entry) =>
    find.byKey(ValueKey<String>('shot-card-${entry.name}'));

Finder _familyGroup = find.byKey(const ValueKey<String>('shots-filter-family'));
Finder _platformGroup = find.byKey(
  const ValueKey<String>('shots-filter-platform'),
);

Widget _harness(DsThemeController controller, {PublicNavigate? onNavigate}) =>
    DsTheme(
      controller: controller,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (BuildContext context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: DefaultTextStyle(
              style: DsText.styleOf(
                context,
                DsType.body,
                color: DsTheme.of(context).foreground,
              ),
              child: SingleChildScrollView(
                child: ShotsIndexPage(onNavigate: onNavigate),
              ),
            ),
          ),
        ),
      ),
    );

Future<DsThemeController> _pumpPage(
  WidgetTester tester, {
  required Size size,
  DsThemeMode mode = DsThemeMode.dark,
  PublicNavigate? onNavigate,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final DsThemeController theme = DsThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(_harness(theme, onNavigate: onNavigate));
  await tester.pump();
  return theme;
}

/// A platform that no current [shotDocs] entry declares — used to exercise
/// the empty state without hardcoding a catalog fact that might stop being
/// true.
ShotPlatform _unusedPlatform() {
  final Set<ShotPlatform> used = shotDocs
      .map((ShotDocEntry e) => e.platform)
      .toSet();
  return ShotPlatform.values.firstWhere(
    (ShotPlatform p) => !used.contains(p),
    orElse: () => ShotPlatform.values.first,
  );
}

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

void main() {
  group('catalog coverage', () {
    testWidgets('every shotDocs entry renders a card', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester, size: _wide);

      expect(find.byType(DsCard), findsNWidgets(shotDocs.length));
      for (final ShotDocEntry entry in shotDocs) {
        expect(_shotCard(entry), findsOneWidget, reason: entry.name);
        expect(
          find.descendant(
            of: _shotCard(entry),
            matching: find.text(entry.title),
          ),
          findsOneWidget,
          reason: entry.name,
        );
        expect(
          find.descendant(
            of: _shotCard(entry),
            matching: find.text(entry.command),
          ),
          findsOneWidget,
          reason: entry.name,
        );
      }
    });

    testWidgets('both filter groups default to All', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester, size: _wide);

      final DsToggleGroup family = tester.widget<DsToggleGroup>(_familyGroup);
      final DsToggleGroup platform = tester.widget<DsToggleGroup>(
        _platformGroup,
      );
      expect(family.selectedIndex, 0);
      expect(platform.selectedIndex, 0);
      expect(family.items.first.label, 'All');
      expect(platform.items.first.label, 'All');
    });

    testWidgets('tapping a card\'s button navigates to its route', (
      WidgetTester tester,
    ) async {
      String? destination;
      await _pumpPage(
        tester,
        size: _wide,
        onNavigate: (String route) => destination = route,
      );

      final ShotDocEntry first = shotDocs.first;
      await tester.tap(
        find.descendant(of: _shotCard(first), matching: find.text('View shot')),
      );
      await tester.pump();

      expect(destination, first.route);
    });
  });

  group('family filter', () {
    for (final ShotFamily family in ShotFamily.values) {
      testWidgets('${_familyLabels[family]} narrows to exactly its entries', (
        WidgetTester tester,
      ) async {
        await _pumpPage(tester, size: _wide);

        await tester.tap(
          find.descendant(
            of: _familyGroup,
            matching: find.text(_familyLabels[family]!),
          ),
        );
        await tester.pump();

        expect(
          tester.widget<DsToggleGroup>(_familyGroup).selectedIndex,
          ShotFamily.values.indexOf(family) + 1,
        );

        for (final ShotDocEntry entry in shotDocs) {
          expect(
            _shotCard(entry),
            entry.family == family ? findsOneWidget : findsNothing,
            reason: entry.name,
          );
        }
      });
    }
  });

  group('platform filter', () {
    for (final ShotPlatform platform in ShotPlatform.values) {
      testWidgets(
        '${_platformLabels[platform]} narrows to exactly its entries',
        (WidgetTester tester) async {
          await _pumpPage(tester, size: _wide);

          await tester.tap(
            find.descendant(
              of: _platformGroup,
              matching: find.text(_platformLabels[platform]!),
            ),
          );
          await tester.pump();

          for (final ShotDocEntry entry in shotDocs) {
            expect(
              _shotCard(entry),
              entry.platform == platform ? findsOneWidget : findsNothing,
              reason: entry.name,
            );
          }
        },
      );
    }
  });

  group('empty state', () {
    testWidgets('an unmatched combination renders the empty state, not a '
        'blank region', (WidgetTester tester) async {
      await _pumpPage(tester, size: _wide);

      final ShotPlatform empty = _unusedPlatform();
      await tester.tap(
        find.descendant(
          of: _platformGroup,
          matching: find.text(_platformLabels[empty]!),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('shots-index-empty')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('shots-index-grid')),
        findsNothing,
      );
      expect(find.byType(DsCard), findsNothing);
      expect(find.text('No shots match those filters'), findsOneWidget);
      // This path only ever narrows by a single filter (platform); the copy
      // must not claim a two-filter cause ("this family and platform
      // together") the reachable path here does not produce.
      expect(
        find.text(
          'Nothing in the catalog matches the selected filters. Try a '
          'different combination or reset the filters.',
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Reset filters'));
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('shots-index-empty')),
        findsNothing,
      );
      expect(find.byType(DsCard), findsNWidgets(shotDocs.length));
      expect(tester.widget<DsToggleGroup>(_platformGroup).selectedIndex, 0);
    });
  });

  group('responsive', () {
    testWidgets('renders narrow without overflow', (WidgetTester tester) async {
      await _pumpPage(tester, size: _narrow);
      expect(tester.takeException(), isNull);
      expect(find.byType(DsCard), findsNWidgets(shotDocs.length));
    });

    testWidgets('renders wide without overflow', (WidgetTester tester) async {
      await _pumpPage(tester, size: _wide);
      expect(tester.takeException(), isNull);
      expect(find.byType(DsCard), findsNWidgets(shotDocs.length));
    });
  });

  group('both themes', () {
    testWidgets('renders on light', (WidgetTester tester) async {
      await _pumpPage(tester, size: _wide, mode: DsThemeMode.light);
      expect(tester.takeException(), isNull);
      expect(find.byType(DsCard), findsNWidgets(shotDocs.length));
    });

    testWidgets('renders on dark and survives a live flip to light', (
      WidgetTester tester,
    ) async {
      final DsThemeController theme = await _pumpPage(
        tester,
        size: _wide,
        mode: DsThemeMode.dark,
      );
      expect(find.byType(DsCard), findsNWidgets(shotDocs.length));

      theme.setMode(DsThemeMode.light);
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(DsCard), findsNWidgets(shotDocs.length));
    });
  });

  group('re-tapping the selected filter clears it', () {
    // `DsToggleGroup` only emits `null` when the already-selected item is
    // tapped again (`toggle_group.dart`'s `onChanged: (bool on) =>
    // onChanged(on ? i : null)`), so this is the only way to exercise the
    // `index ?? 0` fallback in `_ShotsIndexPageState` — no other tap ever
    // passes `null` through.
    testWidgets('re-tapping the selected family filter returns to All', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester, size: _wide);

      final ShotFamily first = ShotFamily.values.first;
      final Finder item = find.descendant(
        of: _familyGroup,
        matching: find.text(_familyLabels[first]!),
      );

      await tester.tap(item);
      await tester.pump();
      expect(
        tester.widget<DsToggleGroup>(_familyGroup).selectedIndex,
        ShotFamily.values.indexOf(first) + 1,
      );

      await tester.tap(item);
      await tester.pump();

      expect(tester.widget<DsToggleGroup>(_familyGroup).selectedIndex, 0);
      expect(find.byType(DsCard), findsNWidgets(shotDocs.length));
    });

    testWidgets('re-tapping the selected platform filter returns to All', (
      WidgetTester tester,
    ) async {
      await _pumpPage(tester, size: _wide);

      final ShotPlatform first = ShotPlatform.values.first;
      final Finder item = find.descendant(
        of: _platformGroup,
        matching: find.text(_platformLabels[first]!),
      );

      await tester.tap(item);
      await tester.pump();
      expect(
        tester.widget<DsToggleGroup>(_platformGroup).selectedIndex,
        ShotPlatform.values.indexOf(first) + 1,
      );

      await tester.tap(item);
      await tester.pump();

      expect(tester.widget<DsToggleGroup>(_platformGroup).selectedIndex, 0);
      expect(find.byType(DsCard), findsNWidgets(shotDocs.length));
    });
  });

  group('accessibility', () {
    testWidgets(
      "each card's view-shot control has an accessible name including its title",
      (WidgetTester tester) async {
        await _pumpPage(tester, size: _wide);

        for (final ShotDocEntry entry in shotDocs) {
          expect(
            find.descendant(
              of: _shotCard(entry),
              matching: find.bySemanticsLabel('View shot: ${entry.title}'),
            ),
            findsOneWidget,
            reason: entry.name,
          );
        }
      },
    );

    testWidgets('the FAMILY and PLATFORM filter groups are each named, '
        'disambiguating their two "All" items', (WidgetTester tester) async {
      await _pumpPage(tester, size: _wide);

      expect(find.bySemanticsLabel('FAMILY filter'), findsOneWidget);
      expect(find.bySemanticsLabel('PLATFORM filter'), findsOneWidget);
    });
  });
}
