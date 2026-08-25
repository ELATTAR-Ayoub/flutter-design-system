/// The Registry page reports the registry, so the test that matters compares
/// what it renders against the generated files in this same commit.
///
/// Every other state — loading, empty, parse error, retry — is driven through
/// the injected loader. Nothing here opens a bundle or a socket: a docs test
/// that needed either would be skipped in CI within a month.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs_pages/registry_document.dart';
import 'package:example/docs_pages/registry_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// `flutter test` runs with `example/` as the working directory.
const String _generated = '../registry/generated/latest';

Widget host(
  Widget child, {
  Size size = const Size(1440, 900),
  ElThemeMode mode = ElThemeMode.dark,
  double textScale = 1,
}) {
  return MediaQuery(
    data: MediaQueryData(size: size, textScaler: TextScaler.linear(textScale)),
    child: ElTheme(
      controller: ElThemeController(mode: mode),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SingleChildScrollView(child: child),
      ),
    ),
  );
}

/// The real generated files, read with `dart:io` rather than through a
/// bundle — so the assertion is against the artifact on disk in this commit.
RegistrySnapshot realSnapshot() => parseRegistrySnapshot(
  catalogJson: File('$_generated/registry.json').readAsStringSync(),
  indexJson: File('$_generated/index.json').readAsStringSync(),
);

/// A minimal, structurally valid registry for the states that are not about
/// the real one.
String catalogJson({
  int schemaVersion = 1,
  String registryVersion = '0.0.1',
  List<Map<String, Object?>> items = const <Map<String, Object?>>[],
}) => jsonEncode(<String, Object?>{
  'schemaVersion': schemaVersion,
  'registryVersion': registryVersion,
  'items': items,
});

String indexJson({
  int schemaVersion = 1,
  String registryVersion = '0.0.1',
  int itemCount = 0,
}) => jsonEncode(<String, Object?>{
  'schemaVersion': schemaVersion,
  'registryVersion': registryVersion,
  'items': <Object?>[
    for (int i = 0; i < itemCount; i++)
      <String, Object?>{
        'name': 'item$i',
        'type': 'component',
        'version': '0.0.1',
        'documentationRoute': '/components/item$i',
      },
  ],
});

Map<String, Object?> item({
  String name = 'thing',
  String type = 'component',
  List<String> dependencies = const <String>[],
  List<String> semantic = const <String>[],
  List<Map<String, Object?>> files = const <Map<String, Object?>>[],
  List<Map<String, Object?>> licenses = const <Map<String, Object?>>[],
  bool deprecated = false,
}) => <String, Object?>{
  'name': name,
  'type': type,
  'version': '0.0.1',
  'registryDependencies': dependencies,
  'semanticDependencies': semantic,
  'files': files,
  'assets': <Object?>[],
  'fonts': <Object?>[],
  'shaders': <Object?>[],
  'licenses': licenses,
  'deprecated': deprecated,
};

Map<String, Object?> file(String target) => <String, Object?>{
  'source': 'lib/src/x.dart',
  'target': target,
  'sha256': 'a' * 64,
};

void main() {
  group('the document model', () {
    test('counts what the real registry contains', () {
      final RegistrySnapshot s = realSnapshot();
      expect(s.schemaVersion, 1);
      expect(s.registryVersion, isNotEmpty);
      expect(s.itemCount, greaterThan(0));
      expect(s.kinds, isNotEmpty);
      expect(
        s.kinds.fold<int>(0, (int a, RegistryKindCount k) => a + k.count),
        s.itemCount,
        reason: 'the per-kind counts must add up to the item count',
      );
      expect(s.distributedFiles, greaterThan(0));
      expect(s.dependencyEdges, greaterThan(0));
      expect(
        s.semanticEdges,
        lessThanOrEqualTo(s.dependencyEdges),
        reason: 'semantic dependencies are a subset of registry dependencies',
      );
    });

    test('kinds and targets come back largest first', () {
      final RegistrySnapshot s = realSnapshot();
      for (int i = 1; i < s.kinds.length; i++) {
        expect(s.kinds[i - 1].count, greaterThanOrEqualTo(s.kinds[i].count));
      }
      for (int i = 1; i < s.targets.length; i++) {
        expect(
          s.targets[i - 1].count,
          greaterThanOrEqualTo(s.targets[i].count),
        );
      }
    });

    test('every target prefix maps to a known destination', () {
      // A prefix the registry uses and the page cannot name would render as a
      // dash. Better to find out here than on the page.
      for (final RegistryTargetCount target in realSnapshot().targets) {
        expect(
          target.destination,
          isNotEmpty,
          reason:
              '${target.prefix} has no destination in '
              'registryTargetDestinations',
        );
      }
    });

    test('an item count mismatch between the two files is an error', () {
      // The defect this guards: the CLI resolves through the index and
      // installs through the catalog, so a release that shipped them
      // disagreeing would mislead a reader with the very file meant to
      // prevent it.
      expect(
        () => parseRegistrySnapshot(
          catalogJson: catalogJson(items: <Map<String, Object?>>[item()]),
          indexJson: indexJson(itemCount: 2),
        ),
        throwsA(
          isA<RegistryDocumentException>().having(
            (RegistryDocumentException e) => e.message,
            'message',
            contains('disagrees with itself'),
          ),
        ),
      );
    });

    test('a version mismatch between the two files is an error', () {
      expect(
        () => parseRegistrySnapshot(
          catalogJson: catalogJson(registryVersion: '0.0.1'),
          indexJson: indexJson(registryVersion: '0.0.2'),
        ),
        throwsA(isA<RegistryDocumentException>()),
      );
    });

    test('malformed JSON is an error with a sentence, not a decoder dump', () {
      expect(
        () => parseRegistrySnapshot(
          catalogJson: '{not json',
          indexJson: indexJson(),
        ),
        throwsA(
          isA<RegistryDocumentException>().having(
            (RegistryDocumentException e) => e.message,
            'message',
            contains('not valid JSON'),
          ),
        ),
      );
    });

    test('a missing items array is an error', () {
      expect(
        () => parseRegistrySnapshot(
          catalogJson: jsonEncode(<String, Object?>{
            'schemaVersion': 1,
            'registryVersion': '0.0.1',
          }),
          indexJson: indexJson(),
        ),
        throwsA(isA<RegistryDocumentException>()),
      );
    });

    test('licenses are optional', () {
      final RegistrySnapshot s = parseRegistrySnapshot(
        catalogJson: catalogJson(
          items: <Map<String, Object?>>[
            item(files: <Map<String, Object?>>[file('@ui/a.dart')]),
          ],
        ),
        indexJson: indexJson(itemCount: 1),
      );
      expect(s.itemsWithLicenses, 0);
      expect(s.distributedFiles, 1);
    });

    test('an item carrying a notice is counted once', () {
      final RegistrySnapshot s = parseRegistrySnapshot(
        catalogJson: catalogJson(
          items: <Map<String, Object?>>[
            item(
              files: <Map<String, Object?>>[file('@ui/a.dart')],
              licenses: <Map<String, Object?>>[file('@license/A.txt')],
            ),
          ],
        ),
        indexJson: indexJson(itemCount: 1),
      );
      expect(s.itemsWithLicenses, 1);
      expect(s.distributedFiles, 2);
    });
  });

  group('the page reports the registry in this commit', () {
    testWidgets('the rendered version and counts match the generated files', (
      WidgetTester tester,
    ) async {
      // The gate: displayed figures equal the generated files in the same
      // commit. Written as a comparison rather than as literals, so adding a
      // component does not turn this into a failing test to be edited.
      final RegistrySnapshot expected = realSnapshot();
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        host(RegistryDocsPage(loader: () async => expected)),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('${expected.itemCount}'), findsWidgets);
      expect(
        find.textContaining(
          'Registry ${expected.registryVersion}, schema v'
          '${expected.schemaVersion}',
        ),
        findsOneWidget,
      );
      for (final RegistryKindCount kind in expected.kinds) {
        expect(
          find.textContaining('${kind.count} ${kind.kind}'),
          findsWidgets,
          reason: 'the ${kind.kind} count is not shown',
        );
      }
    });

    test('no count is hardcoded in the page source', () {
      // The plan's rule, enforced rather than trusted: the day 99 becomes
      // 100, a literal here would be the only wrong number on the site.
      final String source = File(
        'lib/docs_pages/registry_page.dart',
      ).readAsStringSync();
      for (final String forbidden in <String>['99 items', '84 components']) {
        expect(source, isNot(contains(forbidden)));
      }
    });

    testWidgets('every target the registry uses is listed with where it goes', (
      WidgetTester tester,
    ) async {
      final RegistrySnapshot expected = realSnapshot();
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        host(RegistryDocsPage(loader: () async => expected)),
      );
      await tester.pumpAndSettle();

      for (final RegistryTargetCount target in expected.targets) {
        expect(find.text(target.prefix), findsWidgets, reason: target.prefix);
        expect(
          find.textContaining(target.destination),
          findsWidgets,
          reason: '${target.prefix} does not say where it installs',
        );
      }
    });
  });

  group('the default loader reads the declared assets', () {
    testWidgets('loadBundledRegistrySnapshot returns the shipped figures', (
      WidgetTester tester,
    ) async {
      // The production path, uninjected. Every other test here supplies a
      // loader, which means none of them would notice the asset declaration
      // disappearing from the root pubspec — and the only symptom in a
      // release build would be an error card where the figures should be.
      final RegistrySnapshot bundled = await loadBundledRegistrySnapshot();
      final RegistrySnapshot onDisk = realSnapshot();

      expect(bundled.registryVersion, onDisk.registryVersion);
      expect(bundled.schemaVersion, onDisk.schemaVersion);
      expect(bundled.itemCount, onDisk.itemCount);
      expect(bundled.distributedFiles, onDisk.distributedFiles);
      expect(bundled.dependencyEdges, onDisk.dependencyEdges);
    });
  });

  group('states', () {
    // **No `pumpAndSettle` in the error tests.** `ElAlert` renders an
    // `ElBloomCosmic`, whose controllers `repeat(reverse: true)` forever, so
    // settling waits for an animation that never finishes. The same note
    // exists in `components_docs/alert_test.dart`; `tester.pump()` is what
    // every alert-bearing test in this repository uses.

    testWidgets('loading shows a layout-preserving skeleton', (
      WidgetTester tester,
    ) async {
      final Completer<RegistrySnapshot> never = Completer<RegistrySnapshot>();
      await tester.pumpWidget(
        host(RegistryDocsPage(loader: () => never.future)),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('registry-loading')),
        findsWidgets,
      );
      expect(find.byType(ElSkeleton), findsWidgets);
      expect(
        find.byKey(const ValueKey<String>('registry-figures')),
        findsNothing,
      );
    });

    testWidgets('loaded replaces the skeleton', (WidgetTester tester) async {
      final Completer<RegistrySnapshot> completer =
          Completer<RegistrySnapshot>();
      await tester.pumpWidget(
        host(RegistryDocsPage(loader: () => completer.future)),
      );
      await tester.pump();
      expect(find.byType(ElSkeleton), findsWidgets);

      completer.complete(realSnapshot());
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('registry-figures')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('registry-loading')),
        findsNothing,
      );
    });

    testWidgets('an empty registry gets an explanation, not a blank', (
      WidgetTester tester,
    ) async {
      final RegistrySnapshot empty = parseRegistrySnapshot(
        catalogJson: catalogJson(),
        indexJson: indexJson(),
      );
      await tester.pumpWidget(
        host(RegistryDocsPage(loader: () async => empty)),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('registry-empty')),
        findsOneWidget,
      );
      expect(find.byType(ElEmpty), findsWidgets);
      expect(find.textContaining('empty'), findsWidgets);
    });

    testWidgets('a parse failure shows the sentence and a retry', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          RegistryDocsPage(
            loader: () async =>
                throw const RegistryDocumentException('It did not parse.'),
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('registry-error')),
        findsOneWidget,
      );
      expect(find.textContaining('It did not parse.'), findsWidgets);
      expect(find.widgetWithText(ElButton, 'Try again'), findsOneWidget);
    });

    testWidgets('retry re-runs the loader and can succeed', (
      WidgetTester tester,
    ) async {
      int calls = 0;
      Future<RegistrySnapshot> loader() async {
        calls++;
        if (calls == 1) {
          throw const RegistryDocumentException('Transient.');
        }
        return realSnapshot();
      }

      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(host(RegistryDocsPage(loader: loader)));
      await tester.pump();
      expect(
        find.byKey(const ValueKey<String>('registry-error')),
        findsOneWidget,
      );

      await tester.tap(find.widgetWithText(ElButton, 'Try again'));
      // A frame for the tap, a frame for the rebuilt future, and one more for
      // the resolved data. Not `pumpAndSettle`: if the retry failed the alert
      // would still be on screen looping, and the test would hang rather than
      // report.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 32));
      await tester.pump(const Duration(milliseconds: 32));

      expect(calls, 2);
      expect(
        find.byKey(const ValueKey<String>('registry-error')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey<String>('registry-figures')),
        findsOneWidget,
      );
    });

    testWidgets('the failure is legible without colour, and announced', (
      WidgetTester tester,
    ) async {
      // The gate: failure states keyboard-accessible and non-colour-only. The
      // alert carries an icon and a title as well as its variant, and the
      // recovery is a real focusable button rather than a coloured word.
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        host(
          RegistryDocsPage(
            loader: () async =>
                throw const RegistryDocumentException('It did not parse.'),
          ),
        ),
      );
      await tester.pump();

      expect(
        find.textContaining('could not be read'),
        findsWidgets,
        reason: 'the state must be stated in words, not only in colour',
      );
      expect(find.byType(ElIcon), findsWidgets);

      // Reachable and operable from the keyboard.
      final Finder retry = find.widgetWithText(ElButton, 'Try again');
      expect(tester.getSemantics(retry), isNotNull);
      handle.dispose();
    });

    testWidgets('the targets table says why it is unavailable', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          RegistryDocsPage(
            loader: () async => throw const RegistryDocumentException('Nope.'),
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byKey(const ValueKey<String>('registry-targets-unavailable')),
        findsOneWidget,
      );
    });
  });

  group('the page holds up', () {
    testWidgets('narrow renders without exception', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        host(
          RegistryDocsPage(loader: () async => realSnapshot()),
          size: const Size(390, 844),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        find.byKey(const ValueKey<String>('registry-doc-article')),
        findsOneWidget,
      );
    });

    testWidgets('light theme renders the figures', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        host(
          RegistryDocsPage(loader: () async => realSnapshot()),
          mode: ElThemeMode.light,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        find.byKey(const ValueKey<String>('registry-figures')),
        findsOneWidget,
      );
    });

    testWidgets('text scaling does not break it', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        host(
          RegistryDocsPage(loader: () async => realSnapshot()),
          textScale: 1.6,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('installation stays the one primary action', (
      WidgetTester tester,
    ) async {
      // The page is informational. It links to Installation rather than
      // growing a second quickstart, and this is what keeps that true.
      final List<String> navigated = <String>[];
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        host(
          RegistryDocsPage(
            loader: () async => realSnapshot(),
            onNavigate: navigated.add,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final Finder link = find.widgetWithText(ElButton, 'Installation');
      await tester.ensureVisible(link);
      await tester.tap(link);
      await tester.pumpAndSettle();
      expect(navigated, contains('/docs/installation'));

      // And no `elattar init` on this page: that command belongs to the page
      // that owns setting a project up.
      expect(find.textContaining('elattar init'), findsNothing);
    });
  });
}
