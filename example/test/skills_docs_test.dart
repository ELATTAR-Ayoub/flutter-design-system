/// Tests for `skills_docs/catalog.dart` and `skills_docs/skills_page.dart`'s
/// [SkillsPage] — the public Skills documentation page.
///
/// Real test-view sizing throughout (`tester.view.physicalSize` +
/// `addTearDown(tester.view.reset)`), never synthetic `MediaQuery` — the same
/// discipline `buttons_page_test.dart` carries.
///
/// This suite runs with cwd = `example/` (the package root `flutter test`
/// uses), so repository-root files are read as `../skills/...` and
/// `../.claude-plugin/...`.
///
/// The core of this file is the anti-invention guard the Phase H scope names
/// directly: the site previously shipped
/// `npx skills add ELATTAR-Ayoub/flutter-design-system`, a command nothing in
/// the repository implemented. Every command `SkillsPage` renders must come
/// from `catalog.dart`'s `verifiedCommands` allowlist — checked here both at
/// the data level (every `SkillCommand` in the catalog) and at the rendered
/// level (every `DocsSelectableCodeBlock` the widget tree actually shows).
library;

import 'dart:convert';
import 'dart:io';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:example/docs/docs_code.dart';
import 'package:example/docs/docs_file_tree.dart';
import 'package:example/skills_docs/catalog.dart';
import 'package:example/skills_docs/skills_page.dart';
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

const Size _wide = Size(1440, 900);
const Size _narrow = Size(390, 844);

/// The repository root, from the `example/` package the suite runs in.
Directory get _root => Directory('..');

String _rooted(String relative) => '${_root.path}/$relative';

Directory get _skillDirectory =>
    Directory(_rooted('skills/elattar-flutter-ui-director'));

final SkillDocEntry _entry = skillDoc('elattar-flutter-ui-director');

Future<ThemeController> _pumpSkills(
  WidgetTester tester, {
  SkillDocEntry? entry,
  Map<String, String> fileSource = const <String, String>{},
  ValueChanged<String>? onNavigate,
  Size size = _wide,
  ColorMode mode = ColorMode.dark,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ThemeController theme = ThemeController(mode: mode);
  addTearDown(theme.dispose);

  await tester.pumpWidget(
    ThemeScope(
      controller: theme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SkillsPage(
              entry: entry,
              fileSource: fileSource,
              onNavigate: onNavigate,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return theme;
}

void main() {
  group('catalog facts', () {
    test('the catalog file tree matches the real skill directory listing', () {
      const String marker = 'elattar-flutter-ui-director/';
      final List<String> onDisk =
          _skillDirectory
              .listSync(recursive: true)
              .whereType<File>()
              .map((File file) => file.path.replaceAll('\\', '/'))
              .map((String path) {
                final int index = path.indexOf(marker);
                expect(
                  index,
                  greaterThanOrEqualTo(0),
                  reason: 'unexpected path shape: $path',
                );
                return path.substring(index + marker.length);
              })
              .toList()
            ..sort();

      final List<String> catalogued = <String>[..._entry.files]..sort();

      expect(
        catalogued,
        onDisk,
        reason:
            "catalog.dart's referenceFiles must list exactly the files under "
            'skills/elattar-flutter-ui-director/, in a set sense, or the '
            'published file tree goes stale the moment a reference is added, '
            'renamed, or removed.',
      );
    });

    test('the summary is the plugin manifest\'s own description', () {
      final Map<String, Object?> plugin =
          jsonDecode(
                File(_rooted('.claude-plugin/plugin.json')).readAsStringSync(),
              )
              as Map<String, Object?>;
      expect(
        _entry.summary,
        plugin['description'],
        reason:
            'the one-line summary is the plugin manifest\'s own, restated '
            'here only so the page can render it without reading the '
            'filesystem',
      );
    });

    test('the description is SKILL.md\'s own frontmatter description', () {
      final String skill = File(
        _rooted('skills/elattar-flutter-ui-director/SKILL.md'),
      ).readAsStringSync();
      final RegExpMatch? match = RegExp(
        r'^description:\s*(.+)$',
        multiLine: true,
      ).firstMatch(skill);
      expect(match, isNotNull, reason: 'SKILL.md declares no description');
      // The value is a double-quoted YAML scalar: the sentence contains
      // "complete: loading skeletons", and a bare colon inside a plain
      // scalar makes the whole frontmatter unparsable, which it was until
      // the quotes went on.
      String declared = match!.group(1)!.trim();
      if (declared.startsWith('"') && declared.endsWith('"')) {
        declared = declared.substring(1, declared.length - 1);
      }
      expect(
        _entry.description,
        declared,
        reason:
            'the description is the text an agent harness matches on. A '
            'paraphrase here describes a skill that does not exist.',
      );
    });

    test('the workflow lists one line per step SKILL.md declares', () {
      final String skill = File(
        _rooted('skills/elattar-flutter-ui-director/SKILL.md'),
      ).readAsStringSync();
      final int start = skill.indexOf('## Workflow');
      expect(start, greaterThanOrEqualTo(0));
      final int end = skill.indexOf('\n## ', start + 1);
      final String section = skill.substring(
        start,
        end < 0 ? skill.length : end,
      );
      final int steps = RegExp(
        r'^\d+\. ',
        multiLine: true,
      ).allMatches(section).length;
      expect(steps, greaterThan(1), reason: 'the step parse found nothing');
      expect(
        _entry.workflow.length,
        steps,
        reason:
            'SKILL.md declares $steps steps and the catalog lists '
            '${_entry.workflow.length}',
      );
    });

    test('no retired API spelling survives in the catalog', () {
      // The public names carry no prefix. `El*` in a user-facing string names
      // an API that does not exist, and this catalog carried four of them.
      final RegExp retired = RegExp(r'\bEl[A-Z*]');
      final String source = File(
        'lib/skills_docs/catalog.dart',
      ).readAsStringSync();
      expect(
        retired.hasMatch(source),
        isFalse,
        reason: 'skills_docs/catalog.dart still names the retired prefix',
      );
    });

    test(
      'the catalog version and plugin name match .claude-plugin/plugin.json',
      () {
        final Map<String, Object?> plugin =
            jsonDecode(
                  File(
                    _rooted('.claude-plugin/plugin.json'),
                  ).readAsStringSync(),
                )
                as Map<String, Object?>;

        expect(
          _entry.version,
          plugin['version'],
          reason:
              'A skill with no verified version makes "update" unverifiable '
              '(Decision 005). The catalog and plugin.json must agree.',
        );
        expect(_entry.pluginName, plugin['name']);
      },
    );

    test(
      'the catalog marketplace name matches .claude-plugin/marketplace.json',
      () {
        final Map<String, Object?> marketplace =
            jsonDecode(
                  File(
                    _rooted('.claude-plugin/marketplace.json'),
                  ).readAsStringSync(),
                )
                as Map<String, Object?>;

        expect(_entry.marketplaceName, marketplace['name']);
      },
    );

    test('every command in every install route is in verifiedCommands', () {
      expect(_entry.allCommands, isNotEmpty);
      for (final SkillCommand command in _entry.allCommands) {
        expect(
          verifiedCommands,
          contains(command.command),
          reason:
              '"${command.command}" is rendered by an install route but is '
              'not in verifiedCommands — the allowlist a human must '
              'consciously edit before a command can publish.',
        );
      }
    });

    test('verifiedCommands contains no npx text', () {
      for (final String command in verifiedCommands) {
        expect(
          command.contains('npx'),
          isFalse,
          reason:
              '"npx skills add ..." was the invented command Phase H deletes '
              'from the site; it must never come back in verifiedCommands.',
        );
      }
    });

    test('exactly one route is verified today; the rest are pending', () {
      final Iterable<SkillInstallRoute> verified = _entry.installRoutes.where(
        (SkillInstallRoute route) =>
            route.status == SkillRouteStatus.verifiedToday,
      );
      expect(
        verified.length,
        1,
        reason:
            'Only the AGENTS.md route is demonstrated by this checkout today; '
            'every other route must stay pendingVerification until a '
            'transcript and a licensing decision back it.',
      );
      for (final SkillInstallRoute route in _entry.installRoutes) {
        if (route.status == SkillRouteStatus.pendingVerification) {
          expect(
            route.blockedBy,
            isNotNull,
            reason: '${route.id} is pending but names no reason why.',
          );
        }
      }
    });
  });

  group('rendered page', () {
    testWidgets('renders the header, overview, and workflow steps', (
      WidgetTester tester,
    ) async {
      await _pumpSkills(tester);

      expect(find.text(_entry.title), findsWidgets);
      expect(find.text(_entry.description), findsOneWidget);
      expect(find.text(_entry.summary), findsOneWidget);
      for (final String step in _entry.workflow) {
        expect(find.text(step), findsOneWidget, reason: step);
      }
    });

    testWidgets('renders exactly the supported agents named in the catalog', (
      WidgetTester tester,
    ) async {
      await _pumpSkills(tester);

      for (final String agent in _entry.supportedAgents) {
        expect(find.text(agent), findsOneWidget, reason: agent);
      }
      // Decision 005 deleted the Codex claim (`agents/openai.yaml`, no
      // recorded run, no self-serve install route). It must not reappear.
      expect(find.textContaining('Codex'), findsNothing);
    });

    testWidgets(
      'every command DocsSelectableCodeBlock the page renders is a verified command',
      (WidgetTester tester) async {
        await _pumpSkills(tester);

        // `DocsSelectableCodeBlock` is reused for two different jobs on this
        // page: `_CommandBlock` renders a copyable command with it, and
        // `DocsFileTree` renders a reference file's *source* with it (the
        // honest "not loaded" placeholder by default). Only the former is a
        // command, so this guard scopes to the `skill-command:` keys
        // `_CommandBlock` assigns rather than every block on the page —
        // otherwise the file placeholder's own prose would have to be added
        // to `verifiedCommands`, which is not a command at all.
        final Iterable<DocsSelectableCodeBlock> commandBlocks = tester
            .widgetList<DocsSelectableCodeBlock>(
              find.byType(DocsSelectableCodeBlock),
            )
            .where((DocsSelectableCodeBlock block) {
              final Key? key = block.key;
              return key is ValueKey<String> &&
                  key.value.startsWith('skill-command:');
            });

        expect(commandBlocks, isNotEmpty);
        for (final DocsSelectableCodeBlock block in commandBlocks) {
          expect(
            verifiedCommands,
            contains(block.code),
            reason:
                'Rendered command "${block.code}" is not in '
                "catalog.dart's verifiedCommands allowlist.",
          );
        }
      },
    );

    testWidgets('renders no npx text anywhere on the page', (
      WidgetTester tester,
    ) async {
      await _pumpSkills(tester);

      expect(find.textContaining('npx'), findsNothing);
    });

    testWidgets('renders every command from every install route', (
      WidgetTester tester,
    ) async {
      await _pumpSkills(tester);

      for (final SkillInstallRoute route in _entry.installRoutes) {
        for (final SkillCommand command in route.allCommands) {
          expect(
            find.text(command.command),
            findsOneWidget,
            reason: command.command,
          );
        }
      }
    });

    testWidgets(
      'marks each route Works today or Pending verification, never both',
      (WidgetTester tester) async {
        await _pumpSkills(tester);

        for (final SkillInstallRoute route in _entry.installRoutes) {
          final Finder card = find.byKey(
            ValueKey<String>('skill-route:${route.id}'),
          );
          expect(card, findsOneWidget, reason: route.id);

          final Badge rendered = tester.widget<Badge>(
            find.descendant(of: card, matching: find.byType(Badge)),
          );
          expect(
            rendered.label,
            route.status == SkillRouteStatus.pendingVerification
                ? 'Pending verification'
                : 'Works today',
            reason: route.id,
          );
        }
      },
    );

    testWidgets('renders the reference file tree over the catalog files', (
      WidgetTester tester,
    ) async {
      await _pumpSkills(tester);

      expect(find.byType(DocsFileTree), findsOneWidget);
      final String firstFile = _entry.referenceFiles.first.path;
      expect(find.bySemanticsLabel('Selected file $firstFile'), findsOneWidget);
      expect(
        find.textContaining('is not loaded in this build'),
        findsOneWidget,
        reason:
            'With no fileSource supplied, the tree must show the honest '
            'placeholder, never invented content.',
      );
    });

    testWidgets(
      'a supplied fileSource renders the real code instead of the placeholder',
      (WidgetTester tester) async {
        final String skillFile = _entry.referenceFiles.first.path;
        await _pumpSkills(
          tester,
          fileSource: <String, String>{skillFile: '# Real skill content'},
        );

        expect(find.text('# Real skill content'), findsOneWidget);
        expect(
          find.textContaining('is not loaded in this build'),
          findsNothing,
        );
      },
    );

    testWidgets('renders the version facts', (WidgetTester tester) async {
      await _pumpSkills(tester);

      expect(find.text(_entry.version), findsOneWidget);
      expect(find.text(_entry.pluginName), findsOneWidget);
      expect(find.text(_entry.marketplaceName), findsOneWidget);
      expect(find.text(_entry.repository), findsOneWidget);
    });
  });

  group('viewport widths', () {
    testWidgets('a wide viewport exposes the sidebar and table of contents', (
      WidgetTester tester,
    ) async {
      await _pumpSkills(tester, size: _wide);

      expect(
        find.byKey(const ValueKey<String>('docs-layout-sidebar')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-toc')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey<String>('skill-doc-article')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'a narrow viewport drops the sidebar and toc for an anchor strip, and keeps content reachable',
      (WidgetTester tester) async {
        await _pumpSkills(tester, size: _narrow);

        expect(
          find.byKey(const ValueKey<String>('docs-layout-sidebar')),
          findsNothing,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-toc')),
          findsNothing,
        );
        expect(
          find.byKey(const ValueKey<String>('docs-layout-anchor-strip')),
          findsOneWidget,
        );
        expect(
          find.byKey(const ValueKey<String>('skill-doc-article')),
          findsOneWidget,
        );
        expect(find.text(_entry.title), findsWidgets);
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('both themes', () {
    testWidgets('renders the same structure on light', (
      WidgetTester tester,
    ) async {
      await _pumpSkills(tester, mode: ColorMode.light);

      expect(find.text(_entry.title), findsWidgets);
      expect(find.byType(DocsFileTree), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders the same structure on dark', (
      WidgetTester tester,
    ) async {
      await _pumpSkills(tester, mode: ColorMode.dark);

      expect(find.text(_entry.title), findsWidgets);
      expect(find.byType(DocsFileTree), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('flipping the theme in place keeps the page intact', (
      WidgetTester tester,
    ) async {
      final ThemeController theme = await _pumpSkills(
        tester,
        mode: ColorMode.dark,
      );

      expect(find.text(_entry.title), findsWidgets);

      theme.setMode(ColorMode.light);
      await tester.pump();

      expect(find.text(_entry.title), findsWidgets);
      expect(find.byType(DocsFileTree), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
