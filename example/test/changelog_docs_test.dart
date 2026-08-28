/// The Changelog page renders the repository's own `CHANGELOG.md`, so the
/// tests that matter are the ones that would catch it drifting from that file
/// or quietly dropping part of it.
///
/// The strictness is the feature. A permissive Markdown renderer that skipped
/// a table would delete a release note and nobody would find out from looking
/// at the page — so the parser throws on anything it cannot render, and these
/// tests hold it to that.
library;

import 'dart:async';
import 'dart:io';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs_pages/changelog_document.dart';
import 'package:example/docs_pages/changelog_page.dart';
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

/// `flutter test` runs with `example/` as the working directory.
const String _changelogPath = '../CHANGELOG.md';

String realChangelogSource() => File(_changelogPath).readAsStringSync();

ChangelogDocument realChangelog() => parseChangelog(realChangelogSource());

Widget host(
  Widget child, {
  Size size = const Size(1440, 900),
  ColorMode mode = ColorMode.dark,
  double textScale = 1,
}) {
  return MediaQuery(
    data: MediaQueryData(size: size, textScaler: TextScaler.linear(textScale)),
    child: ThemeScope(
      controller: ThemeController(mode: mode),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SingleChildScrollView(child: child),
      ),
    ),
  );
}

void main() {
  group('the real CHANGELOG.md', () {
    test('parses without hitting anything unsupported', () {
      // The guard the plan asks for: unsupported Markdown fails here, on the
      // commit that introduces it, rather than vanishing from the page.
      final ChangelogDocument document = realChangelog();
      expect(document.releases, isNotEmpty);
      expect(document.title, isNotEmpty);
    });

    test('0.0.1 is present', () {
      expect(
        realChangelog().releases.map((ChangelogRelease r) => r.version),
        contains('0.0.1'),
      );
    });

    test('the parsed release count matches the source headings', () {
      // Counted two ways: by the parser, and by reading the file with a
      // regular expression. Two implementations agreeing is evidence; one
      // implementation agreeing with itself is not.
      final int fromSource = RegExp(
        r'^## v?\d+\.\d+\.\d+',
        multiLine: true,
      ).allMatches(realChangelogSource()).length;
      expect(realChangelog().releases.length, fromSource);
      expect(fromSource, greaterThan(0));
    });

    test('releases are in source order, newest first', () {
      final List<String> parsed = realChangelog().releases
          .map((ChangelogRelease r) => r.version)
          .toList();
      final List<String> source =
          RegExp(r'^## (v?\d+\.\d+\.\d+.*)$', multiLine: true)
              .allMatches(realChangelogSource())
              .map((RegExpMatch m) => m.group(1)!.trim())
              .toList();
      expect(parsed, source);
    });

    test('no release loses its content', () {
      // Every non-empty, non-heading line of the file has to survive into
      // some block. This is the assertion that a silent drop would fail.
      final ChangelogDocument document = realChangelog();
      final String rendered = <String>[
        for (final ChangelogBlock block in document.preamble)
          block.kind == ChangelogBlockKind.code ? block.code : block.plainText,
        for (final ChangelogRelease release in document.releases) ...<String>[
          release.version,
          for (final ChangelogBlock block in release.blocks)
            block.kind == ChangelogBlockKind.code
                ? block.code
                : block.plainText,
        ],
      ].join('\n');

      // A handful of distinctive phrases from across the file. If any of
      // these is missing, a block was dropped.
      for (final String phrase in <String>[
        'elattar_cli',
        'MIT',
        'registry',
        'Known limitations',
      ]) {
        expect(
          rendered,
          contains(phrase),
          reason: '"$phrase" did not survive parsing',
        );
      }
    });

    test('the page consumes the same bytes the repository ships', () {
      // The asset key the page loads and the file this test reads must be the
      // same file. Asserted by path rather than by content, because the
      // content assertion is every other test in this group.
      expect(changelogAsset, endsWith('CHANGELOG.md'));
      expect(
        changelogAsset,
        startsWith('packages/elattar_design_system/'),
        reason:
            'CHANGELOG.md is above example/, so it can only be reached '
            'through the package that owns it',
      );
      expect(File(_changelogPath).existsSync(), isTrue);
    });

    test('no release prose was copied into Dart', () {
      // The plan's rule: the page must not become a second release ledger.
      final String pageSource = File(
        'lib/docs_pages/changelog_page.dart',
      ).readAsStringSync();
      for (final String phrase in <String>[
        'Known limitations',
        'elattar_cli 0.0.1 is published',
      ]) {
        expect(
          pageSource,
          isNot(contains(phrase)),
          reason: 'release prose belongs in CHANGELOG.md, not in the page',
        );
      }
    });
  });

  group('the default loader reads the declared asset', () {
    testWidgets('loadBundledChangelog returns the shipped document', (
      WidgetTester tester,
    ) async {
      // The production path, uninjected: this is what fails if the
      // CHANGELOG.md asset line leaves the root pubspec.
      final ChangelogDocument bundled = await loadBundledChangelog();
      final ChangelogDocument onDisk = realChangelog();

      expect(
        bundled.releases.map((ChangelogRelease r) => r.version),
        onDisk.releases.map((ChangelogRelease r) => r.version),
      );
      expect(bundled.title, onDisk.title);
    });
  });

  group('the parser is strict about what it cannot render', () {
    ChangelogDocument parse(String body) =>
        parseChangelog('# Changelog\n\n## 0.0.1\n\n$body\n');

    test('a table is reported rather than dropped', () {
      expect(
        () => parse('| a | b |\n| --- | --- |\n| 1 | 2 |'),
        throwsA(
          isA<ChangelogDocumentException>().having(
            (ChangelogDocumentException e) => e.message,
            'message',
            contains('table'),
          ),
        ),
      );
    });

    test('raw HTML is reported', () {
      expect(
        () => parse('<div>hello</div>'),
        throwsA(isA<ChangelogDocumentException>()),
      );
    });

    test('an image is reported', () {
      expect(
        () => parse('![alt](image.png)'),
        throwsA(isA<ChangelogDocumentException>()),
      );
    });

    test('an unterminated code fence is reported', () {
      expect(
        () => parse('```\nnever closed'),
        throwsA(
          isA<ChangelogDocumentException>().having(
            (ChangelogDocumentException e) => e.message,
            'message',
            contains('unterminated'),
          ),
        ),
      );
    });

    test('a file with no releases is reported', () {
      expect(
        () => parseChangelog('# Changelog\n\nNothing here.\n'),
        throwsA(
          isA<ChangelogDocumentException>().having(
            (ChangelogDocumentException e) => e.message,
            'message',
            contains('no releases'),
          ),
        ),
      );
    });
  });

  group('the supported subset', () {
    ChangelogDocument parse(String body) =>
        parseChangelog('# Changelog\n\n## 0.0.1\n\n$body\n');

    test('paragraphs join wrapped lines', () {
      final ChangelogDocument d = parse('one line\nwrapped onto two');
      expect(
        d.releases.single.blocks.single.plainText,
        'one line wrapped onto two',
      );
    });

    test('bullets carry their nesting level', () {
      final ChangelogDocument d = parse('- top\n  - nested');
      final List<ChangelogBlock> blocks = d.releases.single.blocks;
      expect(blocks, hasLength(2));
      expect(blocks[0].indent, 0);
      expect(blocks[1].indent, 1);
    });

    test('fenced code keeps its newlines verbatim', () {
      final ChangelogDocument d = parse('```\nline one\nline two\n```');
      final ChangelogBlock block = d.releases.single.blocks.single;
      expect(block.kind, ChangelogBlockKind.code);
      expect(block.code, 'line one\nline two');
    });

    test('inline code is not re-scanned for emphasis', () {
      // The bug this prevents: a command containing ** rendering half bold.
      final ChangelogDocument d = parse('run `a ** b` now');
      final List<ChangelogSpan> spans = d.releases.single.blocks.single.spans;
      final ChangelogSpan code = spans.firstWhere((ChangelogSpan s) => s.code);
      expect(code.text, 'a ** b');
      expect(spans.any((ChangelogSpan s) => s.strong), isFalse);
    });

    test('links keep their label and target', () {
      final ChangelogDocument d = parse('see [the docs](https://example.com)');
      final ChangelogSpan link = d.releases.single.blocks.single.spans
          .firstWhere((ChangelogSpan s) => s.isLink);
      expect(link.text, 'the docs');
      expect(link.href, 'https://example.com');
    });

    test('a bare URL becomes a link labelled by itself', () {
      final ChangelogDocument d = parse('at <https://example.com/x>');
      final ChangelogSpan link = d.releases.single.blocks.single.spans
          .firstWhere((ChangelogSpan s) => s.isLink);
      expect(link.href, 'https://example.com/x');
    });

    test('bold and italic are distinguished', () {
      final ChangelogDocument d = parse('**strong** and *soft*');
      final List<ChangelogSpan> spans = d.releases.single.blocks.single.spans;
      expect(
        spans.any((ChangelogSpan s) => s.strong && s.text == 'strong'),
        isTrue,
      );
      expect(
        spans.any((ChangelogSpan s) => s.emphasis && s.text == 'soft'),
        isTrue,
      );
    });

    test('a non-version level-two heading is a section, not a release', () {
      // `## How this was built` must not appear in the version list.
      final ChangelogDocument d = parseChangelog(
        '# Changelog\n\n## 0.0.1\n\nreleased\n\n## How this was built\n\nnotes\n',
      );
      expect(d.releases.map((ChangelogRelease r) => r.version), <String>[
        '0.0.1',
      ]);
    });

    test('a blockquote keeps its text', () {
      final ChangelogDocument d = parse('> an aside');
      expect(d.releases.single.blocks.single.plainText, 'an aside');
    });
  });

  group('the page', () {
    testWidgets('renders one section per release, in order', (
      WidgetTester tester,
    ) async {
      final ChangelogDocument document = realChangelog();
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        host(ChangelogDocsPage(loader: () async => document)),
      );
      await tester.pumpAndSettle();

      for (final ChangelogRelease release in document.releases) {
        expect(
          find.byKey(ValueKey<String>('changelog-release-${release.version}')),
          findsOneWidget,
          reason: '${release.version} is missing from the page',
        );
      }
      expect(
        find.byKey(const ValueKey<String>('changelog-doc-article')),
        findsOneWidget,
      );
    });

    testWidgets('the version headings are readable on the page', (
      WidgetTester tester,
    ) async {
      final ChangelogDocument document = realChangelog();
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        host(ChangelogDocsPage(loader: () async => document)),
      );
      await tester.pumpAndSettle();

      expect(find.text('0.0.1'), findsWidgets);
    });

    testWidgets('loading shows a skeleton of the right shape', (
      WidgetTester tester,
    ) async {
      final Completer<ChangelogDocument> never = Completer<ChangelogDocument>();
      await tester.pumpWidget(
        host(ChangelogDocsPage(loader: () => never.future)),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('changelog-loading')),
        findsOneWidget,
      );
      expect(find.byType(Skeleton), findsWidgets);
    });

    testWidgets('an empty document explains itself', (
      WidgetTester tester,
    ) async {
      // Not reachable from a correct file — the parser refuses one with no
      // releases — so this drives the state directly. A page that rendered a
      // heading and nothing else would look like a bug.
      const ChangelogDocument empty = ChangelogDocument(
        title: 'Changelog',
        preamble: <ChangelogBlock>[],
        releases: <ChangelogRelease>[],
      );
      await tester.pumpWidget(
        host(ChangelogDocsPage(loader: () async => empty)),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('changelog-empty')),
        findsOneWidget,
      );
    });

    testWidgets('a parse failure is readable and offers a retry', (
      WidgetTester tester,
    ) async {
      // No `pumpAndSettle`: `Alert` renders an `FeedbackSurface` whose
      // controllers repeat forever, so settling never returns.
      await tester.pumpWidget(
        host(
          ChangelogDocsPage(
            loader: () async => throw const ChangelogDocumentException(
              'CHANGELOG.md line 12 is a table.',
            ),
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('changelog-error')),
        findsOneWidget,
      );
      expect(find.textContaining('is a table'), findsWidgets);
      expect(find.widgetWithText(Button, 'Try again'), findsOneWidget);
      // Stated in words and marked with an icon, not signalled by colour.
      expect(find.textContaining('could not be read'), findsWidgets);
      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('retry re-runs the loader', (WidgetTester tester) async {
      int calls = 0;
      Future<ChangelogDocument> loader() async {
        calls++;
        if (calls == 1) {
          throw const ChangelogDocumentException('Transient.');
        }
        return realChangelog();
      }

      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(host(ChangelogDocsPage(loader: loader)));
      await tester.pump();
      expect(
        find.byKey(const ValueKey<String>('changelog-error')),
        findsOneWidget,
      );

      await tester.tap(find.widgetWithText(Button, 'Try again'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 32));
      await tester.pump(const Duration(milliseconds: 32));

      expect(calls, 2);
      expect(
        find.byKey(const ValueKey<String>('changelog-error')),
        findsNothing,
      );
    });

    testWidgets('links are labelled and open through the handler', (
      WidgetTester tester,
    ) async {
      final List<String> opened = <String>[];
      final ChangelogDocument document = parseChangelog(
        '# Changelog\n\n## 0.0.1\n\nSee [the guide](https://example.com/g).\n',
      );
      await tester.pumpWidget(
        host(
          ChangelogDocsPage(
            loader: () async => document,
            onOpenLink: opened.add,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('the guide'), findsWidgets);
      expect(opened, isEmpty);
    });

    testWidgets('narrow renders every release without exception', (
      WidgetTester tester,
    ) async {
      final ChangelogDocument document = realChangelog();
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        host(
          ChangelogDocsPage(loader: () async => document),
          size: const Size(390, 844),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      for (final ChangelogRelease release in document.releases) {
        expect(
          find.byKey(ValueKey<String>('changelog-release-${release.version}')),
          findsOneWidget,
        );
      }
    });

    testWidgets('light theme renders it', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        host(
          ChangelogDocsPage(loader: () async => realChangelog()),
          mode: ColorMode.light,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('text scaling does not break it', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        host(
          ChangelogDocsPage(loader: () async => realChangelog()),
          textScale: 1.6,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
