import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/components_docs/attachment/meta.dart';
import 'package:example/components_docs/attachment/page.dart';
import 'package:example/docs/component_doc_page.dart' show DocsTocEntry;
import 'package:example/docs/docs_disclosure.dart';
import 'package:example/docs/docs_install.dart';
import 'package:example/docs/docs_section.dart' show DocsSection;
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

Finder _disclosureTrigger(String title) => find.descendant(
  of: find.byWidgetPredicate(
    (Widget widget) => widget is DocsDisclosure && widget.title == title,
  ),
  matching: find.byKey(DocsDisclosure.triggerKey),
);

/// Every named constructor parameter `ElAttachment` itself declares
/// (`lib/src/components/attachment.dart`), excluding `key`.
const List<String> _attachmentParams = <String>[
  'media',
  'content',
  'actions',
  'state',
  'size',
  'orientation',
];

const List<String> _specimenKeys = <String>[
  'attachment-preview:idle',
  'attachment-preview:uploading',
  'attachment-preview:processing',
  'attachment-preview:error',
  'attachment-preview:done',
  'attachment-example:size-md',
  'attachment-example:size-sm',
  'attachment-example:size-xs',
  'attachment-example:vertical-empty',
  'attachment-example:vertical-titled',
  'attachment-example:media-image',
  'attachment-example:media-icon',
  'attachment-example:media-uploading',
  'attachment-example:preview',
  'attachment-example:download',
  'attachment-example:group',
];

void main() {
  group('attachment docs page', () {
    testWidgets(
      'renders the article, the full API table, and a live specimen of '
      'every state and variant this page claims to show',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 1600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        String? destination;
        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: AttachmentDocPage(
              onNavigate: (String route) => destination = route,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('attachment-doc-article')),
          findsOneWidget,
        );

        final Finder apiTrigger = _disclosureTrigger('API Reference');
        await tester.ensureVisible(apiTrigger);
        await tester.pump();
        await tester.tap(apiTrigger);
        await tester.pump();
        await tester.pump(ElDurations.jelly);

        for (final String param in _attachmentParams) {
          expect(find.text(param), findsWidgets, reason: 'missing $param');
        }
        for (final ElAttachmentState state in ElAttachmentState.values) {
          expect(
            find.text(state.name),
            findsWidgets,
            reason: 'ElAttachmentState.${state.name} missing',
          );
        }
        for (final ElAttachmentSize size in ElAttachmentSize.values) {
          expect(
            find.text('ElAttachmentSize.${size.name}'),
            findsWidgets,
            reason: 'ElAttachmentSize.${size.name} missing',
          );
        }
        for (final ElAttachmentOrientation orientation
            in ElAttachmentOrientation.values) {
          expect(
            find.text('ElAttachmentOrientation.${orientation.name}'),
            findsWidgets,
            reason: 'ElAttachmentOrientation.${orientation.name} missing',
          );
        }
        for (final ElAttachmentMediaVariant variant
            in ElAttachmentMediaVariant.values) {
          expect(
            find.text('ElAttachmentMediaVariant.${variant.name}'),
            findsWidgets,
            reason: 'ElAttachmentMediaVariant.${variant.name} missing',
          );
        }

        for (final String key in _specimenKeys) {
          expect(
            find.byKey(ValueKey<String>(key)),
            findsOneWidget,
            reason: 'missing example specimen $key',
          );
        }

        // A live ElAttachment of every ElAttachmentState mounts somewhere
        // on the page, this page's own promise, not just the API table's
        // prose.
        final Set<ElAttachmentState> mountedStates = tester
            .widgetList<ElAttachment>(find.byType(ElAttachment))
            .map((ElAttachment a) => a.state)
            .toSet();
        expect(mountedStates, containsAll(ElAttachmentState.values));

        final Set<ElAttachmentSize> mountedSizes = tester
            .widgetList<ElAttachment>(find.byType(ElAttachment))
            .map((ElAttachment a) => a.size)
            .toSet();
        expect(mountedSizes, containsAll(ElAttachmentSize.values));

        final Set<ElAttachmentMediaVariant> mountedVariants = tester
            .widgetList<ElAttachmentMedia>(find.byType(ElAttachmentMedia))
            .map((ElAttachmentMedia m) => m.variant)
            .toSet();
        expect(mountedVariants, containsAll(ElAttachmentMediaVariant.values));

        // The download example actually carries a downloadName, and the
        // preview example actually carries a non-null preview.
        final ElAttachmentMedia downloadMedia = tester.widget<ElAttachmentMedia>(
          find.descendant(
            of: find.byKey(
              const ValueKey<String>('attachment-example:preview'),
            ),
            matching: find.byType(ElAttachmentMedia),
          ),
        );
        expect(downloadMedia.preview, isNotNull);

        expect(attachmentDoc.name, 'attachment');
        expect(
          attachmentDoc.exports,
          containsAll(<String>[
            'ElAttachment',
            'ElAttachmentMedia',
            'ElAttachmentContent',
            'ElAttachmentTitle',
            'ElAttachmentDescription',
            'ElAttachmentActions',
            'ElAttachmentAction',
            'ElAttachmentTrigger',
            'ElAttachmentGroup',
          ]),
        );
        expect(attachmentDoc.command, 'elattar add attachment');
        expect(destination, isNull);
      },
    );

    testWidgets(
      'the page is declared, and every section is a kit component',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 5000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _harness(
            controller: ElThemeController(mode: ElThemeMode.dark),
            child: const AttachmentDocPage(),
          ),
        );
        await tester.pump();

        // Five specimen stages: Preview, Orientation & size, Media,
        // Preview and download, Group.
        expect(find.byType(DocsShowcase), findsNWidgets(5));
        expect(find.byType(DocsInstall), findsOneWidget);
        expect(find.byType(DocsDisclosure), findsNWidgets(8));
      },
    );

    test('the table of contents matches the declared sections', () {
      expect(
        attachmentDocSpec.toc.map((DocsTocEntry entry) => entry.title).toList(),
        <String>[
          'Preview',
          'Installation',
          'Usage',
          'Orientation & size',
          'Media',
          'Preview and download',
          'Group',
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

    testWidgets('sections render in declaration order', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _harness(
          controller: ElThemeController(mode: ElThemeMode.dark),
          child: const AttachmentDocPage(),
        ),
      );
      await tester.pump();

      final List<String> titles = tester
          .widgetList<DocsSection>(find.byType(DocsSection))
          .map((DocsSection section) => section.title)
          .toList();

      expect(titles, <String>[
        'Preview',
        'Installation',
        'Usage',
        'Orientation & size',
        'Media',
        'Preview and download',
        'Group',
        'API Reference',
        'States',
        'Accessibility',
        'Keyboard',
        'Responsive',
        'Dependencies',
        'Theming',
        'Source',
      ]);
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
            child: const AttachmentDocPage(),
          ),
        );
        await tester.pump();

        expect(
          find.byKey(const ValueKey<String>('attachment-doc-article')),
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
      'survives a live theme flip in place, at desktop width, without '
      'losing any example specimen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1440, 1600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final ElThemeController controller = ElThemeController(
          mode: ElThemeMode.dark,
        );
        await tester.pumpWidget(
          _harness(controller: controller, child: const AttachmentDocPage()),
        );
        await tester.pump();

        final ElThemeData darkTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('attachment-doc-article')),
          ),
        );

        controller.setMode(ElThemeMode.light);
        await tester.pump();

        final ElThemeData lightTheme = ElTheme.of(
          tester.element(
            find.byKey(const ValueKey<String>('attachment-doc-article')),
          ),
        );

        expect(lightTheme.background, isNot(darkTheme.background));
        expect(lightTheme.foreground, isNot(darkTheme.foreground));

        for (final String key in _specimenKeys) {
          expect(find.byKey(ValueKey<String>(key)), findsOneWidget);
        }
      },
    );
  });
}
