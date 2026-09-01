import 'dart:io';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/catalog.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/main.dart';
import 'package:example/skills_docs/catalog.dart';
import 'package:example/skills_docs/skills_page.dart';
import 'package:example/site/pages/home_showcase.dart' show homeShowcaseCards;
import 'package:example/site/pages/public_pages.dart';
import 'package:example/site/site_routes.dart' show skillsRoute;
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
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

/// The ambient ink every route inherits, as the shell sets it for the real app.
///
/// A surface mounted bare in a test has no shell above it, so the nearest
/// `DefaultTextStyle` is `WidgetsApp`'s red fallback — which `StyledText`
/// asserts on rather than quietly painting over. Threaded through
/// `MaterialApp.builder` so it covers routes and overlays too, not just `home`.
Widget _ambientInk(BuildContext context, Widget? child) => DefaultTextStyle(
  style: StyledText.styleOf(
    context,
    TextStyles.body,
    color: ThemeScope.of(context).foreground,
  ),
  child: child!,
);

/// The Skill `/skills` serves. Read from the catalog rather than spelled out,
/// so a renamed slug fails at the catalog and not here.
final SkillDocEntry _skill = skillDocs.first;

/// The repository root, from the `example/` package this suite runs in — the
/// skill's real files live above it, at `skills/<slug>/…`.
String _rooted(String relative) => '../$relative';

Widget _harness(Widget child) => ThemeScope(
  controller: ThemeController(mode: ColorMode.dark),
  child: MaterialApp(
    builder: _ambientInk,
    debugShowCheckedModeBanner: false,
    home: SingleChildScrollView(child: child),
  ),
);

void _sizeTo(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('home exposes the pill, headline, subhead and live grid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_harness(const PublicHomePage()));

    expect(find.text('Browse components'), findsOneWidget);
    expect(find.text('Build the interface\nyou mean.'), findsOneWidget);
    expect(find.text('Start building'), findsOneWidget);
    // The grid is the point: a live composition's own card title, not a
    // screenshot or a description of one.
    expect(find.text('Building blocks'), findsOneWidget);
  });

  testWidgets('the home grid renders every live card it declares', (
    WidgetTester tester,
  ) async {
    // Wide and tall on purpose: the masonry reads the viewport for its column
    // count, and every card is built eagerly, so a short view would only
    // measure overflow.
    _sizeTo(tester, const Size(1600, 6000));
    await tester.pumpWidget(_harness(const PublicHomePage()));

    expect(homeShowcaseCards(), hasLength(14));

    // One string per card, each unique to it. Titles alone will not do: the
    // navigation card's rows are spelled 'Analytics', 'Notifications' and
    // 'Profile' too, which are three other cards' headings.
    const List<String> fingerprints = <String>[
      'Building blocks',
      'Contribution history',
      'Set a new milestone',
      'Switch metric',
      'Distribute your first track',
      'Payout threshold',
      'Choose which email and push alerts you want to receive.',
      'Recent activity',
      'Say something',
      'Last 6 months, one real chart.',
      'Claimable balance',
      // The sign-in card's own title is also its submit button's label, so the
      // description is the only string in it that appears exactly once.
      'A real form: validated fields and a submit.',
      'Workspace navigation',
      'How this account is addressed, edited live.',
    ];
    for (final String fingerprint in fingerprints) {
      expect(
        find.text(fingerprint),
        findsOneWidget,
        reason: 'the home grid dropped the card holding "$fingerprint"',
      );
    }
  });

  testWidgets('public page actions report their route without owning routing', (
    WidgetTester tester,
  ) async {
    final List<String> routes = <String>[];
    await tester.pumpWidget(_harness(PublicHomePage(onNavigate: routes.add)));

    final Finder startBuilding = find.text('Start building');
    await tester.ensureVisible(startBuilding);
    await tester.tap(startBuilding);
    await tester.pump();
    expect(routes, <String>[publicDocsRoute]);

    final Finder browseGrid = find.text('Browse components');
    await tester.ensureVisible(browseGrid);
    await tester.tap(browseGrid);
    await tester.pump();
    expect(routes, <String>[publicDocsRoute, publicComponentsRoute]);
  });

  testWidgets('components page renders the four taxonomy sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_harness(const PublicComponentsPage()));

    // `/components` renders inside `DocsLayout` now, so each group title
    // appears twice on a wide viewport: once as the section heading in the
    // article, and once as its entry in the right-hand "ON THIS PAGE" rail.
    // A bare `find.text` is therefore ambiguous and reports "is too many",
    // which reads confusingly as a missing heading. Assert `findsWidgets` for
    // the titles the rail echoes.
    //
    // The `elGroups` sections (Base Components, Site Pages) are gone from
    // this index: every entry in them linked into the legacy `/space/...`
    // tree, which no longer exists, and an index must not list pages a reader
    // cannot open. The one heading that came back — "Agent" — is a
    // `ComponentDocFamily` now, listing real `/components/<name>` pages, not
    // an `elGroups` category. The single "Ready to install" section it
    // replaced is gone with it.
    expect(find.text('Base Components'), findsNothing);
    expect(find.text('Site Pages'), findsNothing);
    expect(find.text('Ready to install'), findsNothing);
    for (final ComponentDocFamily family in ComponentDocFamily.values) {
      expect(find.text(family.label), findsWidgets, reason: family.label);
    }
    expect(find.text('Button'), findsWidgets);
    // Reshaped to match https://ui.shadcn.com/docs/components: a dense list
    // of plain-name links, not a card with a description and a command
    // caption. `elattar add button` is no longer printed on this page (it
    // still is on /components/button, the page the link opens) — asserted
    // below by driving the tap instead of reading a caption that no longer
    // exists.
    expect(find.text('elattar add button'), findsNothing);
  });

  testWidgets('a component link in the dense grid opens its own reference', (
    WidgetTester tester,
  ) async {
    final List<String> routes = <String>[];
    await tester.pumpWidget(
      _harness(PublicComponentsPage(onNavigate: routes.add)),
    );

    final Finder buttonLink = find.text('Button');
    await tester.ensureVisible(buttonLink);
    await tester.tap(buttonLink);
    await tester.pump();

    expect(routes, <String>['/components/button']);
  });

  // `/skills` is no longer served from this library either — `PublicSkillsPage`
  // and its three hand-written cards were retired when `SkillsPage` took the
  // route. These tests are the old ones re-pointed at the real page, at the
  // route rather than at the widget, and they are the stricter half of the
  // guard: `skills_docs_test.dart` checks `SkillsPage` in isolation, this file
  // checks what `/skills` actually mounts, with the skill's REAL source loaded.
  group('the skills route', () {
    // `rootBundle` is a `CachingAssetBundle`: it caches the *Future*, not the
    // string, so a test that awaits a key an earlier test already loaded gets a
    // future from a scope that has ended and hangs.
    setUp(rootBundle.clear);

    testWidgets('resolves to the real Skills page, not the placeholder', (
      WidgetTester tester,
    ) async {
      _sizeTo(tester, const Size(1440, 900));

      // `skillsRoute`, not a literal: one spelling of `/skills` in the
      // repository, and the constant `site_routes.dart` publishes.
      await tester.pumpWidget(_harness(publicPageFor(skillsRoute)));
      await tester.pump();

      final SkillsPage page = tester.widget<SkillsPage>(
        find.byType(SkillsPage),
      );
      expect(page.entry?.slug, _skill.slug);

      // The retired page's own copy. A rewrite that quietly restored the
      // hand-written summary would fail here rather than pass by resembling
      // the real thing.
      expect(find.text('A shared way of working.'), findsNothing);
    });

    testWidgets('stays legible at a narrow viewport', (
      WidgetTester tester,
    ) async {
      _sizeTo(tester, const Size(390, 844));

      await tester.pumpWidget(_harness(publicPageFor(skillsRoute)));
      await tester.pump();

      expect(find.byType(SkillsPage), findsOneWidget);
      expect(find.textContaining(_skill.title), findsWidgets);
    });

    testWidgets('publishes no npx text and no command outside the allowlist', (
      WidgetTester tester,
    ) async {
      _sizeTo(tester, const Size(1440, 900));

      // Loaded FIRST, in this test's own scope, so the assertions below run
      // against the page as a reader sees it — every reference file's real
      // bytes rendered, not the "not loaded in this build" placeholder. A
      // narrower guard that only ever saw the placeholder would not notice an
      // invented command arriving through the skill's own Markdown.
      final Map<String, String> loaded = await skillSourceFor(_skill);
      expect(loaded, isNotEmpty);

      await tester.pumpWidget(_harness(publicPageFor(skillsRoute)));
      await tester.pump();

      // The page used to print `npx skills add ELATTAR-Ayoub/flutter-design-system`,
      // a command nothing in this repository implements, publishes or verifies.
      // Deleting it once is not enough: this is what stops it coming back.
      expect(find.textContaining('npx'), findsNothing);

      // The old page asserted `find.byType(AgentCodeBlock), findsNothing`.
      // That was a proxy for "prints no unverified command", available only
      // because the placeholder had no install section at all. `SkillsPage`
      // legitimately prints commands, so the proxy is replaced by the thing it
      // stood for — a strictly stronger check, since it also fails on a
      // rendered command the allowlist has never seen.
      //
      // Scoped to the `skill-command:` keys `_CommandBlock` assigns:
      // `DocsSelectableCodeBlock` also renders a reference file's *source* in
      // the file tree, and with the real bytes loaded above that is 6 KB of
      // Markdown, not a published command.
      final Iterable<DocsSelectableCodeBlock> blocks = tester
          .widgetList<DocsSelectableCodeBlock>(
            find.byType(DocsSelectableCodeBlock),
          )
          .where((DocsSelectableCodeBlock block) {
            final Key? key = block.key;
            return key is ValueKey<String> &&
                key.value.startsWith('skill-command:');
          });
      expect(
        blocks,
        isNotEmpty,
        reason:
            'The install section renders nothing; the allowlist check below '
            'would then pass vacuously.',
      );
      for (final DocsSelectableCodeBlock block in blocks) {
        expect(
          verifiedCommands,
          contains(block.code),
          reason:
              '"${block.code}" is rendered at /skills but is not in '
              "skills_docs/catalog.dart's verifiedCommands. A command reaches "
              'the public site only after a human puts it on that list.',
        );
      }
    });

    testWidgets('renders the real bytes of the skill on disk', (
      WidgetTester tester,
    ) async {
      _sizeTo(tester, const Size(1440, 900));

      // `skillSourceFor` is the production path — the same call `main.dart`
      // makes to fill `SkillsPage.fileSource`. The skill's directory sits above
      // `example/`, so it is declared as an asset by the PACKAGE pubspec at the
      // repository root and reached as `packages/elattar_design_system/skills/…`;
      // a missing declaration loads nothing and fails here, which is the only
      // warning before a release build shows readers "not loaded in this build".
      final Map<String, String> loaded = await skillSourceFor(_skill);

      expect(
        loaded.keys,
        unorderedEquals(_skill.files),
        reason:
            '${_skill.slug} did not load every file it declares. Check the '
            'skills/ asset lines in the repository-root pubspec.yaml.',
      );

      // There is exactly one copy of the skill — Decision 005 — so this is not
      // a parity check between two trees. It is the assertion that the page
      // shows THAT copy, byte for byte, and therefore cannot go stale when the
      // skill is edited.
      for (int index = 0; index < _skill.files.length; index++) {
        expect(
          loaded[_skill.files[index]],
          File(_rooted(_skill.sourcePaths[index])).readAsStringSync(),
          reason:
              '${_skill.files[index]} in the bundle differs from the file on '
              'disk. The page must show the source an agent actually loads.',
        );
      }

      // …and that the mounted route hands exactly that map to the page.
      await tester.pumpWidget(_harness(publicPageFor(skillsRoute)));
      await tester.pump();

      final SkillsPage page = tester.widget<SkillsPage>(
        find.byType(SkillsPage),
      );
      expect(page.fileSource, loaded);

      // …and that the file tree renders it. The tree shows the selected file,
      // which is the first one, as a single Text — so this compares the pixels
      // a reader gets against `File.readAsStringSync`, with nothing in between.
      expect(
        find.text(File(_rooted(_skill.sourcePaths.first)).readAsStringSync()),
        findsOneWidget,
        reason:
            '${_skill.files.first} is not rendered verbatim. The page must '
            'show the file, not a description of it.',
      );
      expect(find.textContaining('is not loaded in this build'), findsNothing);
    });
  });
}
