/// A documentation link behaves like a link.
///
/// The `/components` index has always rendered its entries as real links: a
/// pointer cursor, an ink cross-fade on hover, `Semantics(link: true)`.
/// Nothing inside an article did, because that shape was private to that one
/// page. `DocsLink` is the extraction, and this pins the three registers a
/// reader and a screen reader actually use to tell a link from a caption.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_link.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) {
  final ElThemeController controller = ElThemeController(
    mode: ElThemeMode.dark,
  );
  return ElTheme(
    controller: controller,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  testWidgets('a link wears a pointer cursor', (WidgetTester tester) async {
    await tester.pumpWidget(
      _host(DocsLink(label: 'Button', onTap: () {})),
    );
    await tester.pump();

    final Iterable<MouseRegion> regions = tester.widgetList<MouseRegion>(
      find.descendant(
        of: find.byType(DocsLink),
        matching: find.byType(MouseRegion),
      ),
    );
    expect(
      regions.any(
        (MouseRegion region) => region.cursor == SystemMouseCursors.click,
      ),
      isTrue,
      reason: 'a link must read as a tap target under the pointer',
    );
  });

  testWidgets('a link announces itself as a link', (
    WidgetTester tester,
  ) async {
    // Disposed inline, not via addTearDown: the framework's
    // `_endOfTestVerifications` runs BEFORE teardown callbacks and fails the
    // test on a live handle.
    final SemanticsHandle handle = tester.ensureSemantics();

    await tester.pumpWidget(
      _host(DocsLink(label: 'Button', onTap: () {})),
    );
    await tester.pump();

    final SemanticsNode node = tester.getSemantics(
      find.descendant(
        of: find.byType(DocsLink),
        matching: find.byType(GestureDetector),
      ),
    );
    expect(
      node.hasFlag(SemanticsFlag.isLink),
      isTrue,
      reason: 'a screen reader must be told this is a link, not a label',
    );
    expect(
      node.label,
      'Button',
      reason: 'and it must be announced by the text a reader sees',
    );
    handle.dispose();
  });

  testWidgets('a link changes ink on hover', (WidgetTester tester) async {
    await tester.pumpWidget(
      _host(DocsLink(label: 'Button', onTap: () {})),
    );
    await tester.pump();

    Color? ink() => tester.widget<ElText>(find.byType(ElText)).color;

    final Color? resting = ink();
    expect(resting, isNotNull);

    final TestGesture gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    addTearDown(gesture.removePointer);
    await gesture.addPointer(location: Offset.zero);
    await gesture.moveTo(tester.getCenter(find.byType(DocsLink)));
    // The cross-fade is a TweenAnimationBuilder, so it needs time, not just
    // a frame.
    await tester.pump();
    await tester.pump(ElDurations.transitionDefault);

    expect(
      ink(),
      isNot(equals(resting)),
      reason:
          'hovering a link must change its ink — colour is the only hover '
          'feedback a plain text link has',
    );
  });

  testWidgets('a link runs its callback when tapped', (
    WidgetTester tester,
  ) async {
    int taps = 0;
    await tester.pumpWidget(
      _host(DocsLink(label: 'Button', onTap: () => taps++)),
    );
    await tester.pump();

    await tester.tap(find.byType(DocsLink));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('a link with nothing to open renders as plain text', (
    WidgetTester tester,
  ) async {
    // A link that does nothing is worse than no link: it teaches a reader
    // that this page's links are broken. So a DocsLink handed neither a
    // callback nor a route deliberately declines to look like one.
    await tester.pumpWidget(_host(const DocsLink(label: 'Button')));
    await tester.pump();

    expect(find.byType(GestureDetector), findsNothing);
    expect(find.text('Button'), findsOneWidget);
  });

  testWidgets('a link row lays out every link it is given', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        DocsLinkRow(
          links: <DocsLink>[
            DocsLink(label: 'Button', onTap: () {}),
            DocsLink(label: 'Icon', onTap: () {}),
            DocsLink(label: 'Slot', onTap: () {}),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(DocsLink), findsNWidgets(3));
  });
}
