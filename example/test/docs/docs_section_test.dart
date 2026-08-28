// example/test/docs/docs_section_test.dart
/// The section heading, and the anchor the table of contents scrolls to.
///
/// DEVIATION from the task-3 brief: `_host` wraps `child` in `Center`, which
/// the brief's version does not. Without it, `pumpWidget`'s root gives a
/// constraint tight to `tester.view.physicalSize` (1440x900 here), and a
/// `SizedBox(width: 640)` directly under that root cannot shrink below
/// 1440 — `BoxConstraints.enforce` clamps the 640 into the tight [1440,1440]
/// range, so `getSize` reports 1440 regardless of what `DocsSection` does.
/// Verified empirically with a throwaway probe test before concluding this;
/// it is not specific to this widget. `docs_copy_button_test.dart`'s `_host`
/// already wraps in `Center` for the same reason — this brings this file's
/// helper in line with that convention so the first test actually exercises
/// the column-width claim it names.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_section.dart';
import 'package:example/kit.dart';
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

Widget _host(Widget child) => MediaQuery(
  data: const MediaQueryData(size: Size(1440, 900)),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: ThemeScope(
      controller: ThemeController(mode: ColorMode.dark),
      child: Center(child: child),
    ),
  ),
);

void main() {
  testWidgets('the description fills the column rather than a private cap', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsSection(
            id: 'variants',
            title: 'Variants',
            description: 'Seven of them.',
            child: SizedBox(height: 10, width: double.infinity),
          ),
        ),
      ),
    );
    await tester.pump();

    // The section is as wide as the column it was given. A capped description
    // used to leave a gap on the right of every section on the page.
    expect(tester.getSize(find.byType(DocsSection)).width, 640);
  });

  testWidgets('it uses no uppercase type role', (WidgetTester tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 640,
          child: DocsSection(
            id: 'a',
            title: 'Title',
            description: 'Description.',
            child: SizedBox.shrink(),
          ),
        ),
      ),
    );
    await tester.pump();

    for (final StyledText text in tester.widgetList<StyledText>(
      find.byType(StyledText),
    )) {
      expect(
        text.spec.uppercase,
        isFalse,
        reason: '"${text.text}" renders through an uppercase role',
      );
    }
  });

  testWidgets('the anchor registry is shared with Section', (
    WidgetTester tester,
  ) async {
    // `docs_layout.dart` scrolls by `Section.anchorKey`. If the split gave
    // the two classes separate registries, every table-of-contents link on
    // the site would silently stop working.
    expect(DocsAnchor.keyFor('shared'), same(Section.anchorKey('shared')));
  });
}
