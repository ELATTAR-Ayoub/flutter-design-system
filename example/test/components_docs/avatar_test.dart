/// Tests for the avatar documentation page.
///
/// Two of these tests feed [Avatar] bytes that never touch the network: a
/// tiny valid PNG (so the "image loads" state is real, not asserted on
/// faith) and four bytes that are not a decodable image at all (so the
/// "decode fails" state is exercised the same way: locally, deterministically,
/// and without an `errorBuilder` to paper over what actually happens). Both
/// byte arrays were verified against the live [Avatar] widget before this
/// file was written: the valid PNG mounts an [Image] with no exception, and
/// the corrupt bytes still leave the fallback initials on screen while
/// [WidgetTester.takeException] reports the decode failure: which is why the
/// state matrix on the page describes the error path the way it does, rather
/// than guessing.
library;

import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/avatar/meta.dart';
import 'package:example/components_docs/avatar/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_facts.dart';
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

/// The 1x1 transparent PNG the `transparent_image` package ships as
/// `kTransparentImage`: a real, fully local, decodable image.
final Uint8List _validPng = Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, //
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, //
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, //
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, //
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82, //
]);

/// Four bytes that decode as nothing: no network round trip needed to fail.
final Uint8List _corruptBytes = Uint8List.fromList(<int>[1, 2, 3, 4]);

/// The page's own declared section order — mirrors `avatarDocSpec.toc`.
const List<String> _avatarSectionOrder = <String>[
  'Preview',
  'Installation',
  'Usage',
  'Composition',
  'Basic',
  'Badge',
  'Badge with icon',
  'Avatar group',
  'Avatar group count',
  'Sizes',
  'Dropdown',
  'RTL',
  'API Reference',
  'States',
  'Accessibility',
  'Keyboard',
  'Responsive',
  'Dependencies',
  'Theming',
  'Source',
];

Widget _harness({required Widget child, required ThemeController controller}) =>
    ThemeScope(
      controller: controller,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SingleChildScrollView(child: child),
      ),
    );

/// The single `DocsDisclosure` whose title is [title]. `DocsDisclosure`'s
/// own trigger key ([DocsDisclosure.triggerKey]) is one constant shared by
/// every instance on the page, so a bare `find.byKey` would match all eight
/// — this narrows to the one panel by its title first, matching `button`'s
/// own docs test.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

void main() {
  group('avatar docs page', () {
    testWidgets(
      'renders the article, the full API table, and a live specimen of '
      'every image state this page claims to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final ThemeController controller = ThemeController(
          mode: ColorMode.dark,
        );

        await tester.pumpWidget(
          _harness(controller: controller, child: const AvatarDocPage()),
        );
        // One frame: nothing on this page loops, and `pumpAndSettle` is
        // forbidden on a documentation page (see the rollout brief).
        await tester.pump();

        // The Preview specimen deliberately includes a corrupt-bytes
        // Avatar: that specimen reports exactly the decode failure this
        // page's state matrix describes, so it must be drained here rather
        // than read as a real test failure.
        expect(tester.takeException(), isNotNull);

        expect(
          find.byKey(const ValueKey<String>('avatar-doc-article')),
          findsOneWidget,
        );
        expect(find.byType(Avatar), findsAtLeastNWidgets(1));
        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsOneWidget,
        );

        // The API table lives inside the API Reference disclosure, closed
        // by default (a closed `DocsDisclosure` mounts no content at all),
        // so it must be opened before reading any of its rows.
        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(MotionDurations.open);

        final DocsApiTable elAvatarTable = tester.widget<DocsApiTable>(
          find.byWidgetPredicate(
            (Widget w) => w is DocsApiTable && w.title == 'Avatar',
          ),
        );
        final Set<String> documented = elAvatarTable.facts
            .map((DocsApiFact fact) => fact.name)
            .toSet();
        expect(
          documented,
          containsAll(<String>[
            'fallback',
            'image',
            'size',
            'fallbackSpec',
            'sizePx',
            'ring',
            'badge',
            'fallbackFill',
            'fallbackInk',
          ]),
        );
        // The other two API tables this page claims (AvatarSize,
        // Supporting types) are both mounted too, not just named.
        expect(
          find.byWidgetPredicate(
            (Widget w) => w is DocsApiTable && w.title == 'AvatarSize',
          ),
          findsOneWidget,
        );
        expect(
          find.byWidgetPredicate(
            (Widget w) => w is DocsApiTable && w.title == 'Supporting types',
          ),
          findsOneWidget,
        );

        // A live specimen of the real widget mounts, fallback path included.
        expect(find.text('AB'), findsWidgets);

        // The new component-specific specimens actually mount real widgets,
        // not just section prose: badge-with-icon, the dropdown trigger,
        // and the overflow count.
        expect(find.byType(DropdownMenu), findsOneWidget);
        expect(find.byType(Icon), findsWidgets);
        expect(find.text('+248'), findsOneWidget);

        expect(avatarDoc.name, 'avatar');
        expect(
          avatarDoc.exports,
          containsAll(<String>[
            'Avatar',
            'AvatarSize',
            'AvatarRing',
            'avatarRingWidth',
            'AvatarBadge',
            'AvatarGroup',
            'AvatarGroupCount',
            'AvatarRimPainter',
          ]),
        );
        expect(avatarDoc.command, 'elattar add avatar');
        // avatar has a real registry manifest (registry/components/
        // avatar.json), unlike the stale claim this page used to carry:
        // its one registry dependency is source-foundation.
        expect(avatarDoc.dependencies, <String>['source-foundation']);

        // The theme controller flips in place: no second widget tree.
        controller.setMode(ColorMode.light);
        await tester.pump();
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'the page is declared, and every section is a kit component, in '
      'the house order',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 6000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.dark),
            child: const AvatarDocPage(),
          ),
        );
        await tester.pump();
        // The corrupt-bytes Avatar only reports its decode failure the
        // first time anything resolves it: Flutter's global ImageCache
        // caches the resolved (failed) ImageStream keyed by image bytes,
        // so every later mount within this same test run replays the
        // cached stream without a second FlutterError. Verified against
        // the real widget: only the very first test in this file needs to
        // drain an exception.
        expect(tester.takeException(), isNull);

        // Nine specimen stages: Preview, Basic, Badge, Badge with icon,
        // Avatar group, Avatar group count, Sizes, Dropdown, RTL — plus
        // Composition, which is a `SnippetSection` (no live specimen: see
        // the page's own library doc for why).
        expect(find.byType(DocsShowcase), findsNWidgets(9));
        expect(find.byType(DocsInstall), findsOneWidget);
        // Eight collapsed disclosures: API Reference, States,
        // Accessibility, Keyboard, Responsive, Dependencies, Theming,
        // Source.
        expect(find.byType(DocsDisclosure), findsNWidgets(8));

        expect(
          avatarDocSpec.toc.map((DocsTocEntry e) => e.title).toList(),
          _avatarSectionOrder,
        );

        // Reading each mounted `DocsSection`'s own `title` field sidesteps
        // the duplicate-string hazard `find.text` carries here (a section
        // heading and its own TOC link render the same string).
        final List<String> titles = tester
            .widgetList<DocsSection>(find.byType(DocsSection))
            .map((DocsSection section) => section.title)
            .toList();
        expect(titles, _avatarSectionOrder);
      },
    );

    testWidgets(
      'avatar docs expose the narrow anchor strip and hide the sidebar',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final ThemeController controller = ThemeController(
          mode: ColorMode.dark,
        );

        await tester.pumpWidget(
          _harness(controller: controller, child: const AvatarDocPage()),
        );
        await tester.pump();
        expect(tester.takeException(), isNull);

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
      'avatar docs render at 1440x900 in light mode without exceptions',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.light),
            child: const AvatarDocPage(),
          ),
        );
        await tester.pump();
        expect(find.byType(AvatarDocPage), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'avatar docs render at 390x844 in light mode without exceptions',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          _harness(
            controller: ThemeController(mode: ColorMode.light),
            child: const AvatarDocPage(),
          ),
        );
        await tester.pump();
        expect(find.byType(AvatarDocPage), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  });

  testWidgets('a Avatar with no image renders its fallback initials outright', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(800, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      _harness(
        controller: ThemeController(mode: ColorMode.dark),
        child: const Center(child: Avatar(fallback: 'ZZ')),
      ),
    );
    await tester.pump();

    expect(find.text('ZZ'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets(
    'a Avatar with a locally decodable image swaps the fallback for the image',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: Center(
            child: Avatar(fallback: 'ZZ', image: MemoryImage(_validPng)),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Image), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'a Avatar whose image fails to decode still leaves readable fallback text on screen',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _harness(
          controller: ThemeController(mode: ColorMode.dark),
          child: Center(
            child: Avatar(fallback: 'ZZ', image: MemoryImage(_corruptBytes)),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('ZZ'), findsOneWidget);
      expect(tester.takeException(), isNotNull);
    },
  );
}
