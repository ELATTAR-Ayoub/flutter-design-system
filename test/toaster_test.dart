/// Regression coverage for the toast's text-style completeness.
///
/// A toast is mounted beside the routed page rather than inside it —
/// `example/lib/main.dart`'s `MaterialApp.builder` puts `Toaster` in a
/// `Stack` next to `child`, not underneath the app shell's own
/// `DefaultTextStyle` (`example/lib/shell.dart:237`). Whatever
/// `DefaultTextStyle` sits above `MaterialApp` — `WidgetsApp`'s own
/// `_errorTextStyle` fallback in the framework, red ink with a double
/// yellow underline — is what a toast's subtree used to inherit through,
/// because `toaster.dart` built its type-ink wrapper with
/// `DefaultTextStyle.merge`, which chains onto whatever ambient style is
/// already there instead of replacing it.
///
/// This file stands that ambient up explicitly — a `DefaultTextStyle`
/// carrying the framework's own error decoration — and asserts a toast's
/// rendered text never shows it, and always resolves a real colour rather
/// than the framework's diagnostic red.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/rendering.dart' hide ScrollDirection;
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
import 'package:flutter_test/flutter_test.dart';

/// `WidgetsApp`/`MaterialApp`'s own diagnostic fallback —
/// `_errorTextStyle` in `package:flutter/src/material/app.dart`: red ink,
/// double yellow underline. The ambient a toast mounted beside (not
/// inside) the routed page tree can genuinely inherit in the real app,
/// stood up here by hand so the test does not depend on `MaterialApp`
/// internals.
const TextStyle _hostileAmbient = TextStyle(
  color: Color(0xD0FF0000),
  fontFamily: 'monospace',
  fontSize: 48,
  fontWeight: FontWeight.w900,
  decoration: TextDecoration.underline,
  decorationColor: Color(0xFFFFFF00),
  decorationStyle: TextDecorationStyle.double,
);

Widget _host(Widget child) => MediaQuery(
  data: const MediaQueryData(size: Size(1440, 900)),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: ThemeScope(
      controller: ThemeController(mode: ColorMode.dark),
      // Stands in for the hostile ambient the real app can leave above a
      // toast — see the file comment.
      child: DefaultTextStyle(
        style: _hostileAmbient,
        child: SizedBox(width: 1440, height: 900, child: child),
      ),
    ),
  ),
);

/// The [RenderParagraph] painting [text] — the actual merged style, after
/// `Text` folds the ambient [DefaultTextStyle] in, rather than the style
/// literal a widget was constructed with.
RenderParagraph _paragraphFor(WidgetTester t, String text) =>
    t.renderObject<RenderParagraph>(find.text(text));

void main() {
  testWidgets(
    "a toast's title and description carry no underline and resolve a "
    'real colour even under a hostile ambient DefaultTextStyle',
    (WidgetTester t) async {
      final ToastController c = ToastController();
      addTearDown(c.dispose);

      await t.pumpWidget(_host(Toaster(controller: c)));
      c.success(
        'Sold 3 cards for \$2,481.00',
        description: 'Credited to your available balance.',
      );

      // Mount frame, measure/layout round trip, then the entrance — same
      // sequence `feedback_effects_test.dart`'s `arrive` helper pumps.
      await t.pump();
      await t.pump();
      await t.pump(Toaster.transition);
      await t.pump();

      final TextStyle? title =
          _paragraphFor(t, 'Sold 3 cards for \$2,481.00').text.style;
      final TextStyle? description =
          _paragraphFor(t, 'Credited to your available balance.').text.style;

      for (final TextStyle? style in <TextStyle?>[title, description]) {
        expect(
          style?.decoration,
          isNot(TextDecoration.underline),
          reason:
              'the hostile ambient\'s underline must not leak through — '
              'this is exactly the yellow double-underline the toast '
              'showed before toaster.dart installed a real DefaultTextStyle '
              'instead of merging onto whatever ambient it found',
        );
        expect(
          style?.color,
          isNotNull,
          reason: 'a toast must resolve its own colour, not defer to no '
              'colour at all',
        );
        expect(
          style?.color,
          isNot(const Color(0xD0FF0000)),
          reason:
              "the framework's diagnostic red must never survive into a "
              'toast',
        );
      }

      expect(title?.color, ThemeTokens.dark.foreground);
      expect(description?.color, ThemeTokens.dark.mutedForeground);

      c.clear();
      await t.pump();
    },
  );
}
