import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/catalog.dart';
import 'package:example/components_docs/input/meta.dart';
import 'package:example/components_docs/input/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_showcase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Widget child,
  required ElThemeController controller,
}) => ElTheme(
  controller: controller,
  child: MaterialApp(home: SingleChildScrollView(child: child)),
);

/// `DocsDisclosure.triggerKey` is one constant shared by every instance on
/// the page, so a bare `find.byKey` matches all eight disclosures — this
/// narrows to the one panel by its title first.
Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Every named constructor parameter `ElInput`'s own class declares
/// (`lib/src/components/input.dart`), excluding `key`: the same set the
/// page's `ElInput` `DocsApiTable` claims to cover.
const List<String> _inputConstructorParams = <String>[
  'controller',
  'initialValue',
  'focusNode',
  'placeholder',
  'onChanged',
  'onSubmitted',
  'enabled',
  'readOnly',
  'invalid',
  'obscureText',
  'keyboardType',
  'autofillHints',
  'textSpec',
  'label',
  'hint',
  'bare',
  'padding',
  'boxHeight',
  'fill',
  'flat',
  'radius',
];

void main() {
  group('input docs page', () {
    testWidgets(
      'renders the article, the full API table, and a live specimen of '
      'every state this page claims to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: InputDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('input-doc-article')),
          findsOneWidget,
        );
        expect(find.byType(ElInput), findsAtLeastNWidgets(1));

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        for (final String param in _inputConstructorParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        for (final String table in <String>[
          'ElInput',
          'ElFieldSurface',
          'ElFieldVisibility',
        ]) {
          expect(find.text(table), findsWidgets, reason: 'missing $table');
        }

        // The preview toggles a live ElInput between invalid, disabled,
        // and read-only. Opening the API Reference disclosure above
        // scrolled the article down to it, so the Preview section's own
        // toggles need scrolling back into view before they can be tapped.
        final Finder invalidToggle = find
            .widgetWithText(ElButton, 'Invalid')
            .first;
        await tester.ensureVisible(invalidToggle);
        await tester.pump();
        await tester.tap(invalidToggle);
        await tester.pump();
        expect(find.text('That address is missing a valid domain.'), findsWidgets);

        final Finder readOnlyToggle = find
            .widgetWithText(ElButton, 'Read only')
            .first;
        await tester.ensureVisible(readOnlyToggle);
        await tester.pump();
        await tester.tap(readOnlyToggle);
        await tester.pump();
        final EditableText editable = tester.widget<EditableText>(
          find.byType(EditableText).first,
        );
        expect(editable.readOnly, isTrue);

        expect(inputDoc.name, 'input');
        expect(
          inputDoc.exports,
          containsAll(<String>['ElInput', 'ElFieldSurface', 'ElFieldVisibility']),
        );
        expect(inputDoc.command, 'elattar add input');
        expect(destination, isNull);
      },
    );

    testWidgets(
      'the page is declared, and every section is a kit component',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 4000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const InputDocPage(),
          ),
        );
        await tester.pump();

        // Three specimen stages: Preview, Field companion, Read-only & Bare.
        expect(find.byType(DocsShowcase), findsNWidgets(3));
        expect(find.byType(DocsInstall), findsOneWidget);
        // Eight collapsed sections: API Reference, States, Accessibility,
        // Keyboard, Responsive, Dependencies, Theming, Source.
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        inputDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Field companion',
          'Read-only & Bare',
          'API Reference',
          'States',
          'Accessibility',
          'Keyboard',
          'Responsive',
          'Dependencies',
          'Theming',
          'Source',
        ],
      );
    });

    testWidgets(
      'renders at narrow width with the anchor strip instead of a rail',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const InputDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('input-doc-article')),
          findsOneWidget,
        );
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
      'survives a live theme flip in place, at desktop width',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const InputDocPage()),
        );
        await tester.pump();

        final ElThemeData darkTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('input-doc-article')),
          ),
        );

        controller.setMode(ElThemeMode.light);
        await tester.pump();

        final ElThemeData lightTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('input-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));
        expect(find.byType(ElInput), findsAtLeastNWidgets(1));
      },
    );

    // Migrated from the retired component_docs_input_select_test.dart: the
    // pager's "next" link must fire onNavigate with a route that still
    // matches the real catalog entry, so a future rename of input_group's
    // own title cannot leave this page's own DocsPageLink silently stale.
    testWidgets(
      'navigating next fires onNavigate with the linked page, and the '
      'label still matches the real catalog entry',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ComponentDocEntry inputGroup = componentDoc('input_group');

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: InputDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        final Finder nextLink = find
            .widgetWithText(ElButton, inputGroup.title)
            .last;
        await tester.ensureVisible(nextLink);
        await tester.pump();
        await tester.tap(nextLink);
        expect(destination, inputGroup.route);
      },
    );
  });
}
