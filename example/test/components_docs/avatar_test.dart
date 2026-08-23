/// Tests for the avatar documentation page.
///
/// Two of these tests feed [DsAvatar] bytes that never touch the network: a
/// tiny valid PNG (so the "image loads" state is real, not asserted on
/// faith) and four bytes that are not a decodable image at all (so the
/// "decode fails" state is exercised the same way: locally, deterministically,
/// and without an `errorBuilder` to paper over what actually happens). Both
/// byte arrays were verified against the live [DsAvatar] widget before this
/// file was written: the valid PNG mounts an [Image] with no exception, and
/// the corrupt bytes still leave the fallback initials on screen while
/// [WidgetTester.takeException] reports the decode failure: which is why the
/// state matrix on the page describes the error path the way it does, rather
/// than guessing.
library;

import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/avatar/page.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_facts.dart';
import 'package:example/kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The page's own section order, live demo excluded (it has no heading):
/// shadcn parity brief requires this exact order and this exact set, see
/// `example/lib/components_docs/avatar/page.dart`'s own library doc for the
/// "Avatar Group with Icon" section it deliberately skips.
const List<String> _avatarSectionOrder = <String>[
  'install',
  'usage',
  'composition',
  'basic',
  'badge',
  'badge-icon',
  'avatar-group',
  'avatar-group-count',
  'sizes',
  'dropdown',
  'rtl',
  'api',
  'states',
  'accessibility',
  'responsive',
  'dependencies',
  'theming',
  'source',
];

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

Widget _harness({
  required Widget child,
  required DsThemeController controller,
}) => DsTheme(
  controller: controller,
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SingleChildScrollView(child: child),
  ),
);

void main() {
  testWidgets(
    'avatar docs render the article, a complete API table, and a live fallback specimen at desktop width',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final DsThemeController controller = DsThemeController(
        mode: DsThemeMode.dark,
      );

      await tester.pumpWidget(
        _harness(controller: controller, child: const AvatarDocPage()),
      );
      await tester.pumpAndSettle();

      // The live preview deliberately includes a corrupt-bytes DsAvatar (see
      // the file-level doc comment): that specimen reports exactly the
      // decode failure this page's state matrix describes, so it must be
      // drained here rather than read as a real test failure.
      expect(tester.takeException(), isNotNull);

      expect(find.text('Avatar'), findsWidgets);
      expect(find.byType(DocsCodeExample), findsAtLeastNWidgets(1));
      expect(find.byType(DsAvatar), findsAtLeastNWidgets(1));
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );

      // The API table lists every public DsAvatar constructor parameter this
      // worker found by reading lib/src/components/avatar.dart directly.
      final DocsApiTable dsAvatarTable = tester.widget<DocsApiTable>(
        find.byWidgetPredicate(
          (Widget w) => w is DocsApiTable && w.title == 'DsAvatar',
        ),
      );
      final Set<String> documented = dsAvatarTable.facts
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

      // A live specimen of the real widget mounts, fallback path included.
      expect(find.text('AB'), findsWidgets);

      // Every shadcn-mirrored section renders, in exactly the order the
      // reshape brief requires.
      double? previousTop;
      for (final String id in _avatarSectionOrder) {
        final Finder finder = find.byKey(DsSection.anchorKey(id));
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

      // The new component-specific specimens actually mount real widgets,
      // not just section prose: badge-with-icon, the dropdown trigger, and
      // the overflow count.
      expect(find.byType(DsDropdownMenu), findsOneWidget);
      expect(find.byType(DsIcon), findsWidgets);
      expect(find.text('+248'), findsOneWidget);

      // The theme controller flips in place: no second widget tree.
      controller.setMode(DsThemeMode.light);
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'avatar docs expose the narrow anchor strip and hide the sidebar',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final DsThemeController controller = DsThemeController(
        mode: DsThemeMode.dark,
      );

      await tester.pumpWidget(
        _harness(controller: controller, child: const AvatarDocPage()),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
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
          controller: DsThemeController(mode: DsThemeMode.light),
          child: const AvatarDocPage(),
        ),
      );
      await tester.pumpAndSettle();
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
          controller: DsThemeController(mode: DsThemeMode.light),
          child: const AvatarDocPage(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AvatarDocPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'a DsAvatar with no image renders its fallback initials outright',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _harness(
          controller: DsThemeController(mode: DsThemeMode.dark),
          child: const Center(child: DsAvatar(fallback: 'ZZ')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ZZ'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    },
  );

  testWidgets(
    'a DsAvatar with a locally decodable image swaps the fallback for the image',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _harness(
          controller: DsThemeController(mode: DsThemeMode.dark),
          child: Center(
            child: DsAvatar(fallback: 'ZZ', image: MemoryImage(_validPng)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'a DsAvatar whose image fails to decode still leaves readable fallback text on screen',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _harness(
          controller: DsThemeController(mode: DsThemeMode.dark),
          child: Center(
            child: DsAvatar(fallback: 'ZZ', image: MemoryImage(_corruptBytes)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ZZ'), findsOneWidget);
      expect(tester.takeException(), isNotNull);
    },
  );
}
