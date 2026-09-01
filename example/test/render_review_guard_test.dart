/// The two render-review claims a test can actually hold.
///
/// Most of a render review is not provable by a test: contrast over `Glass`,
/// whether the overlay landed where a reader would look for it, whether the
/// type is the system's face or a fallback that happens to have the same
/// metrics. Those are captures, and they live in `tool/verify`.
///
/// Two of them are provable, and they are the two that fail silently and ship:
/// text painted in Flutter's fallback error style, and a page that throws while
/// laying out. The first has no visible symptom in a passing test suite because
/// nothing asserts it; the second only surfaces if something looks. So both are
/// asserted here, over every specimen route, in both themes.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/main.dart';
import 'package:example/nav.dart';
import 'package:flutter/material.dart' show Material, MaterialApp;
import 'package:flutter/widgets.dart'
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
        TableColumnWidth;
import 'package:flutter/widgets.dart' as flutter show RichText;
import 'package:flutter_test/flutter_test.dart';

/// The colour Flutter underlines its fallback style with.
///
/// `WidgetsApp` installs a red monospace style with a double yellow underline
/// for text that has no `DefaultTextStyle` above it. It is deliberately ugly so
/// that a human notices, which is exactly why it needs a test: a documentation
/// page is long, and the one paragraph wearing it is below the fold.
const Color _fallbackUnderline = Color(0xFFFFFF00);

const Size _desktop = Size(1440, 900);

List<String> get _routes => <String>[
  for (final Group group in elGroups)
    for (final Category category in group.categories)
      categoryHref(group, category),
];

Widget _host(String route, ColorMode mode) => ThemeScope(
  controller: ThemeController(mode: mode),
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MediaQuery(
      data: const MediaQueryData(size: _desktop),
      child: Builder(
        builder: (BuildContext context) => DefaultTextStyle(
          style: StyledText.styleOf(
            context,
            TextStyles.body,
            color: ThemeScope.of(context).foreground,
          ),
          child: Material(child: SingleChildScrollView(child: pageFor(route))),
        ),
      ),
    ),
  ),
);

void main() {
  for (final ColorMode mode in <ColorMode>[ColorMode.dark, ColorMode.light]) {
    group('${mode.name} theme', () {
      for (final String route in _routes) {
        testWidgets('$route paints no text in the fallback error style', (
          WidgetTester t,
        ) async {
          t.view.physicalSize = _desktop;
          t.view.devicePixelRatio = 1;
          addTearDown(t.view.reset);

          await t.pumpWidget(_host(route, mode));
          // Not `pumpAndSettle`: `Skeleton` and `Spinner` animate perpetually,
          // so the tree never reaches a quiet frame. One beat of the longest
          // entrance in the system is past the end of anything a page starts
          // on mount.
          await t.pump(MotionDurations.open);

          for (final flutter.RichText text in t.widgetList<flutter.RichText>(
            find.byType(flutter.RichText),
          )) {
            expect(
              text.text.style?.decorationColor,
              isNot(_fallbackUnderline),
              reason:
                  '$route is missing a root DefaultTextStyle somewhere in its '
                  'tree, and the text under it is painting red monospace with '
                  'a double yellow underline',
            );
          }
          expect(t.takeException(), isNull);
        });
      }
    });
  }
}
