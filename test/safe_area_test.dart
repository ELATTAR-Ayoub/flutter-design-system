/// [DsSafeArea] — the system-bar contract, driven.
///
/// A user-ordered mobile adaptation (2026-08-16), so there is no reference
/// behaviour to compare against and no oracle to measure: what is pinned here
/// is the ruling itself, in the three parts a caller can get wrong.
///
///  1. **Content moves, paint does not.** The box around a [DsSafeArea] keeps
///     its size and position; only what is inside comes in.
///  2. **Nothing is paid twice.** The insets a [DsSafeArea] spends are removed
///     from the [MediaQuery] it hands down, so a wrapper inside a wrapper — a
///     panel inside a sheet — adds nothing.
///  3. **Zero costs nothing.** With no bars, no widget joins the tree. This is
///     what keeps every desktop geometry pin in the suite measuring the tree it
///     measured before this file existed, and it is asserted directly rather
///     than inferred from those pins staying green.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// A portrait phone: the status bar over a notch, the gesture pill below.
const EdgeInsets _phone = EdgeInsets.only(top: 47, bottom: 34);

/// The same phone rotated — the notch is now a side, and the pill is shorter.
const EdgeInsets _landscape =
    EdgeInsets.only(left: 47, right: 34, bottom: 21);

/// A software keyboard, which is **not** this file's inset.
const EdgeInsets _keyboard = EdgeInsets.only(bottom: 336);

const Key _outer = Key('outer');
const Key _inner = Key('inner');

extension on WidgetTester {
  /// Pumps [child] under a [MediaQuery] carrying [bars] as its `padding`.
  Future<void> pumpBars(
    Widget child, {
    EdgeInsets bars = _phone,
    EdgeInsets viewInsets = EdgeInsets.zero,
  }) =>
      pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: MediaQueryData(padding: bars, viewInsets: viewInsets),
            child: child,
          ),
        ),
      );

  /// A 200×200 box with [child] inside it — the "background" whose geometry
  /// must not move, wrapped around the content that must.
  Widget boxed(Widget child) => Center(
        child: SizedBox(
          key: _outer,
          width: 200,
          height: 200,
          child: child,
        ),
      );

  /// How far [_inner]'s edges sit inside [_outer]'s, side by side.
  EdgeInsets get spend {
    final Rect outer = getRect(find.byKey(_outer));
    final Rect inner = getRect(find.byKey(_inner));
    return EdgeInsets.fromLTRB(
      inner.left - outer.left,
      inner.top - outer.top,
      outer.right - inner.right,
      outer.bottom - inner.bottom,
    );
  }
}

/// Reads [DsSafeArea]'s statics at the point in the tree it is mounted.
class _Probe extends StatelessWidget {
  const _Probe({this.onBuild});

  final void Function(BuildContext context)? onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild?.call(context);
    return const SizedBox.expand(key: _inner);
  }
}

void main() {
  group('insetsOf', () {
    testWidgets('reads MediaQueryData.padding', (WidgetTester tester) async {
      late EdgeInsets read;
      await tester.pumpBars(
        _Probe(onBuild: (BuildContext c) => read = DsSafeArea.insetsOf(c)),
      );
      expect(read, _phone);
    });

    testWidgets('is zero where there is no MediaQuery at all', (
      WidgetTester tester,
    ) async {
      late EdgeInsets read;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: _Probe(
            onBuild: (BuildContext c) => read = DsSafeArea.insetsOf(c),
          ),
        ),
      );
      expect(read, EdgeInsets.zero);
    });

    testWidgets('ignores the keyboard — that inset is the composer\'s', (
      WidgetTester tester,
    ) async {
      late EdgeInsets read;
      await tester.pumpBars(
        _Probe(onBuild: (BuildContext c) => read = DsSafeArea.insetsOf(c)),
        viewInsets: _keyboard,
      );
      // `viewInsets.bottom` is 336 and this is 34: the two are different
      // obstructions with different owners, and reading the wrong one would put
      // a third of the screen of dead space under every page.
      expect(read, _phone);
    });
  });

  group('the widget', () {
    testWidgets('moves its child and leaves the box around it alone', (
      WidgetTester tester,
    ) async {
      await tester.pumpBars(tester.boxed(const DsSafeArea(child: _Probe())));

      expect(tester.spend, _phone);
      // The half of the ruling that says what *not* to inset: whatever paints
      // here is still 200×200 and still where it was.
      expect(tester.getSize(find.byKey(_outer)), const Size(200, 200));
    });

    testWidgets('pays only the sides it is asked for', (
      WidgetTester tester,
    ) async {
      await tester.pumpBars(
        tester.boxed(const DsSafeArea(top: false, child: _Probe())),
      );
      expect(tester.spend, const EdgeInsets.only(bottom: 34));
    });

    testWidgets('spends the horizontal insets in landscape', (
      WidgetTester tester,
    ) async {
      await tester.pumpBars(
        tester.boxed(const DsSafeArea(bottom: false, child: _Probe())),
        bars: _landscape,
      );
      expect(tester.spend, const EdgeInsets.only(left: 47, right: 34));
    });

    testWidgets('removes what it spends, so nesting cannot double-pay', (
      WidgetTester tester,
    ) async {
      late EdgeInsets nested;
      await tester.pumpBars(
        tester.boxed(
          DsSafeArea(
            child: DsSafeArea(
              child: _Probe(
                onBuild: (BuildContext c) => nested = DsSafeArea.insetsOf(c),
              ),
            ),
          ),
        ),
      );

      // The inner one read zero, so it added nothing: the pair spent the bars
      // exactly once. This is what makes a [DsSafeArea] safe to write on a
      // panel that may or may not be inside a sheet that already paid.
      expect(nested, EdgeInsets.zero);
      expect(tester.spend, _phone);
    });

    testWidgets('adds no widget at all when there is nothing to pay', (
      WidgetTester tester,
    ) async {
      await tester.pumpBars(
        tester.boxed(const DsSafeArea(child: _Probe())),
        bars: EdgeInsets.zero,
      );

      // The desktop path, stated directly: no [Padding], no [MediaQuery], the
      // child mounted where it stood. Every geometry pin taken at 1440×900
      // measures the same tree it did before this component existed.
      expect(
        find.descendant(
          of: find.byType(DsSafeArea),
          matching: find.byType(Padding),
        ),
        findsNothing,
      );
      expect(
        find.descendant(
          of: find.byType(DsSafeArea),
          matching: find.byType(MediaQuery),
        ),
        findsNothing,
      );
      expect(tester.spend, EdgeInsets.zero);
    });
  });

  group('topBarHeightOf', () {
    testWidgets('grows a top-pinned bar by the status bar', (
      WidgetTester tester,
    ) async {
      late double height;
      await tester.pumpBars(
        _Probe(
          onBuild: (BuildContext c) =>
              height = DsSafeArea.topBarHeightOf(c, DsWidths.siteHeader),
        ),
      );
      expect(height, DsWidths.siteHeader + 47);
    });

    testWidgets('is the bar\'s own height on a desktop', (
      WidgetTester tester,
    ) async {
      late double height;
      await tester.pumpBars(
        _Probe(
          onBuild: (BuildContext c) =>
              height = DsSafeArea.topBarHeightOf(c, DsWidths.siteHeader),
        ),
        bars: EdgeInsets.zero,
      );
      expect(height, DsWidths.siteHeader);
    });
  });

  group('scrollPaddingOf', () {
    testWidgets('adds the bottom bar to the end of the content', (
      WidgetTester tester,
    ) async {
      late EdgeInsets padding;
      await tester.pumpBars(
        _Probe(
          onBuild: (BuildContext c) => padding = DsSafeArea.scrollPaddingOf(
            c,
            base: const EdgeInsets.only(top: DsWidths.siteHeader),
          ),
        ),
      );
      // The top is the caller's: a scroll view is not inset out of the header,
      // it scrolls *under* it, and 64 is the room it leaves for it.
      expect(
        padding,
        const EdgeInsets.only(top: DsWidths.siteHeader, bottom: 34),
      );
    });

    testWidgets('adds the horizontal insets too, on top of the base\'s own', (
      WidgetTester tester,
    ) async {
      late EdgeInsets padding;
      await tester.pumpBars(
        _Probe(
          onBuild: (BuildContext c) => padding = DsSafeArea.scrollPaddingOf(
            c,
            base: const EdgeInsets.all(24),
          ),
        ),
        bars: _landscape,
      );
      expect(
        padding,
        const EdgeInsets.fromLTRB(24 + 47, 24, 24 + 34, 24 + 21),
      );
    });

    testWidgets('hands the base straight back on a desktop', (
      WidgetTester tester,
    ) async {
      const EdgeInsets base = EdgeInsets.only(top: DsWidths.siteHeader);
      late EdgeInsets padding;
      await tester.pumpBars(
        _Probe(
          onBuild: (BuildContext c) =>
              padding = DsSafeArea.scrollPaddingOf(c, base: base),
        ),
        bars: EdgeInsets.zero,
      );
      expect(padding, base);
    });
  });
}
