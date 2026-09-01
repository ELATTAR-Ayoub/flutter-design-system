/// A line box is `font-size × line-height`, exactly, however the engine
/// rounds.
///
/// The reference's own numbers, read off Chrome at 1440 dark: a `.type-small`
/// line is 19.5px, `.type-h3` is 27.3, `.type-lead` is 28.05, `.type-micro` is
/// 10.5. Flutter's engine rounds each line to a whole pixel — 20, 27, 28, 11 —
/// and the error accumulates down a page until the port is a full scroll
/// deeper than the reference. These tests hold the corrected geometry.
///
/// Real font binaries, not the test engine's default: line metrics come from
/// the font, so measuring Ahem would prove nothing about Inter.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/services.dart' show FontLoader;
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

/// Anything opaque; these tests measure boxes, not colour.
const Color _ink = Color(0xFF000000); // allow-hardcoded: test ink.

Future<void> _loadFont(String family, String file) async {
  final ByteData bytes = ByteData.sublistView(
    File('assets/fonts/$file').readAsBytesSync(),
  );
  final FontLoader loader = FontLoader('packages/elattar_design_system/$family')
    ..addFont(Future<ByteData>.value(bytes));
  await loader.load();
}

/// Pumps [child] under a theme, at [width], with no height constraint.
Future<Size> _measure(
  WidgetTester tester,
  Widget child, {
  double width = 400,
}) async {
  final GlobalKey key = GlobalKey();
  final ThemeController controller = ThemeController();
  addTearDown(controller.dispose);

  await tester.pumpWidget(
    ThemeScope(
      controller: controller,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: width,
            child: KeyedSubtree(key: key, child: child),
          ),
        ),
      ),
    ),
  );
  return tester.renderObject<RenderBox>(find.byKey(key)).size;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _loadFont('InterLocal', 'InterVariable.ttf');
    await _loadFont('GeistMono', 'GeistMono-Variable.ttf');
  });

  group('one line is font-size × line-height', () {
    testWidgets('for every class the four foundation pages set', (
      WidgetTester tester,
    ) async {
      for (final TextStyleToken role in TextStyles.all) {
        // The scope pins the width the role resolves against, so the assertion
        // does not depend on the test surface.
        final TypeStep step = role.mobile;
        final Size box = await _measure(
          tester,
          TypeWidthScope(
            width: 600,
            // allow-hardcoded: a specimen word, not copy.
            child: StyledText('Hxg', role, color: _ink),
          ),
          width: 600,
        );
        expect(
          box.height,
          closeTo(step.leading, 0.001),
          reason: '${role.name} is one line of ${step.leading}px',
        );
      }
    });

    testWidgets('and n lines are n of them', (WidgetTester tester) async {
      // Narrow enough that this wraps to four lines of `.type-small`.
      final Size box = await _measure(
        tester,
        StyledText(
          'A state colour has one job: to be unmistakable for anything else '
          'on the screen, in either theme, at any size.',
          TextStyles.small,
          color: _ink,
        ),
        width: 260,
      );
      final double line = TextStyles.small.step.leading;
      expect(box.height % line, closeTo(0, 0.001));
      expect(box.height / line, greaterThan(1));
    });
  });

  group('an inline box', () {
    testWidgets('is the font content area, not the line box', (
      WidgetTester tester,
    ) async {
      // `.type-code` is 12.5px/1.4 — a 17.5px line box, but a `<code>` chip in
      // a sentence is only as tall as Geist Mono's own ascent + descent.
      final Size block = await _measure(
        tester,
        StyledText('globals.css', TextStyles.code, color: _ink),
      );
      final Size inline = await _measure(
        tester,
        StyledText('globals.css', TextStyles.code, color: _ink, inline: true),
      );
      expect(block.height, closeTo(TextStyles.code.step.leading, 0.001));
      expect(inline.height, lessThan(block.height));
    });

    testWidgets('hides its frame from the line it sits in', (
      WidgetTester tester,
    ) async {
      const double frame = 6; // allow-hardcoded: the trim under test.
      final Size chip = await _measure(
        tester,
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2), // allow-hardcoded
          color: _ink,
          child: StyledText('x', TextStyles.code, color: _ink, inline: true),
        ),
      );
      final Size hidden = await _measure(
        tester,
        InlineBox(
          trim: frame,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2), // allow-hardcoded
            color: _ink,
            child: StyledText('x', TextStyles.code, color: _ink, inline: true),
          ),
        ),
      );
      expect(hidden.height, chip.height - frame);
      expect(hidden.width, chip.width);
    });
  });
}
