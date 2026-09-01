/// The public Skills page: what the skill does, how to install and try it,
/// what it includes, how it works, and where to inspect the source.
///
/// An article built on `docs/docs_layout.dart`'s [DocsLayout], with the same
/// breadcrumb / sidebar / TOC / prev-next chrome every other public
/// documentation page carries. The file tree reuses `docs/docs_file_tree.dart`'s
/// [DocsFileTree]; commands reuse `docs/docs_code.dart`'s [DocsCodeCommand]
/// and [DocsSelectableCodeBlock]; the version block reuses
/// `docs/docs_facts.dart`'s [DocsInstallFacts]. None of those three files are
/// modified here.
///
/// Every command this page renders comes from a [SkillDocEntry]'s
/// [SkillInstallRoute]s, which are themselves drawn from `catalog.dart`'s
/// [verifiedCommands] allowlist: see that file's library doc for why. This
/// page never constructs a command string of its own.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
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

import '../docs/docs_code.dart';
import '../docs/docs_disclosure.dart';
import '../docs/docs_file_tree.dart';
import '../docs/docs_layout.dart';
import '../kit.dart';
import 'catalog.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({
    super.key,
    this.entry,
    this.fileSource = const <String, String>{},
    this.onNavigate,
  });

  /// The catalog entry this page documents. Defaults to [skillDocs]' single
  /// entry: a parameter rather than a hardcoded read so a future multi-skill
  /// catalog can route more than one slug through this same widget.
  final SkillDocEntry? entry;

  /// Source for each [SkillReferenceFile] in [SkillDocEntry.referenceFiles],
  /// keyed by that file's [SkillReferenceFile.path] (e.g. `SKILL.md` or
  /// `references/system-map.md`), **not** the repo-relative path
  /// [SkillDocEntry.sourcePaths] returns.
  ///
  /// A widget has no business reading the filesystem at build time, and
  /// `skills/` sits outside `example/`'s own project root besides: a Flutter
  /// asset path cannot climb above it (see `example/pubspec.yaml`'s shader
  /// comment for the same constraint hitting a different file). So this page
  /// takes file contents as data, the same contract `ShotDetailPage.fileSource`
  /// uses. A path missing from this map renders a placeholder explaining that
  /// instead of throwing.
  final Map<String, String> fileSource;

  final ValueChanged<String>? onNavigate;

  SkillDocEntry get _resolvedEntry => entry ?? skillDocs.first;

  static List<DocsSidebarEntry> _sidebar(String route) => <DocsSidebarEntry>[
    for (final SkillDocEntry skill in skillDocs)
      DocsSidebarEntry(
        title: skill.title,
        route: skill.route,
        selected: skill.route == route,
      ),
  ];

  @override
  Widget build(BuildContext context) {
    final SkillDocEntry skill = _resolvedEntry;

    return DocsLayout(
      route: skill.route,
      intro: DocsPageIntro(
        eyebrow: 'SKILL · v${skill.version}',
        title: skill.title,
        description: skill.description,
      ),
      breadcrumbs: const <BreadcrumbEntry>[BreadcrumbEntry.page('Skills')],
      sidebar: _sidebar(skill.route),
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Install', anchor: 'install'),
        DocsTocEntry(title: 'Try it', anchor: 'examples'),
        DocsTocEntry(title: 'What is included', anchor: 'included'),
        DocsTocEntry(title: 'How it works', anchor: 'how-it-works'),
        DocsTocEntry(title: 'Manage', anchor: 'manage'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      onNavigate: onNavigate,
      child: _SkillArticle(entry: skill, fileSource: fileSource),
    );
  }
}

class _SkillArticle extends StatelessWidget {
  const _SkillArticle({required this.entry, required this.fileSource});

  final SkillDocEntry entry;
  final Map<String, String> fileSource;

  // Project-relative display path, like every other `DocsCodeFile` caller —
  // not the bare `SkillReferenceFile.path` alone. `fileSource` stays keyed by
  // that bare path (see the field doc on `SkillsPage.fileSource`); only the
  // display path changes.
  List<DocsCodeFile> get _files => <DocsCodeFile>[
    for (final SkillReferenceFile file in entry.referenceFiles)
      DocsCodeFile(
        path: '${entry.directory}/${file.path}',
        title: file.title,
        description: file.description,
        code: fileSource[file.path] ?? _placeholderSource(file),
      ),
  ];

  String _placeholderSource(SkillReferenceFile file) =>
      '// Source for ${file.path} is not loaded in this build.\n'
      '//\n'
      '// SkillsPage.fileSource is keyed by the path relative to the skill\n'
      "// directory; wire in the contents of '${entry.directory}/${file.path}' "
      '(see SkillDocEntry.sourcePaths).\n';

  @override
  // Each section is marked with `docs_layout.dart`'s [docsAnchorKey] so the
  // page's own table of contents can reach it: an unmarked section has no
  // anchor for `DocsLayout` to scroll to, and its TOC row silently does
  // nothing.
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('skill-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      KeyedSubtree(
        key: docsAnchorKey('install'),
        child: _InstallPanel(entry: entry),
      ),
      SizedBox(height: space(6)),
      KeyedSubtree(
        key: docsAnchorKey('examples'),
        child: _ExamplesPanel(entry: entry),
      ),
      SizedBox(height: space(6)),
      KeyedSubtree(
        key: docsAnchorKey('included'),
        child: _NumberedPanel(label: 'What is included', items: entry.included),
      ),
      SizedBox(height: space(6)),
      KeyedSubtree(
        key: docsAnchorKey('how-it-works'),
        child: _NumberedPanel(label: 'How it works', items: entry.howItWorks),
      ),
      SizedBox(height: space(6)),
      KeyedSubtree(
        key: docsAnchorKey('manage'),
        child: _ManagePanel(entry: entry),
      ),
      SizedBox(height: space(6)),
      KeyedSubtree(
        key: docsAnchorKey('source'),
        child: _SourcePanel(entry: entry, files: _files),
      ),
    ],
  );
}

class _ExamplesPanel extends StatelessWidget {
  const _ExamplesPanel({required this.entry});

  final SkillDocEntry entry;

  @override
  Widget build(BuildContext context) => Panel(
    key: const ValueKey<String>('skill-examples'),
    label: 'Try it',
    note: '${entry.examples.length} examples',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int i = 0; i < entry.examples.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: space(3)),
          StyledText('“${entry.examples[i]}”', TextStyles.body),
        ],
      ],
    ),
  );
}

class _NumberedPanel extends StatelessWidget {
  const _NumberedPanel({required this.label, required this.items});

  final String label;
  final List<String> items;

  @override
  Widget build(BuildContext context) => Panel(
    label: label,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int i = 0; i < items.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: space(2)),
          _NumberedItem(index: i + 1, text: items[i]),
        ],
      ],
    ),
  );
}

class _NumberedItem extends StatelessWidget {
  const _NumberedItem({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Semantics(
      container: true,
      label: '$index. $text',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: space(6),
            child: StyledText(
              '$index.',
              TextStyles.small,
              color: theme.mutedForeground,
            ),
          ),
          Expanded(child: StyledText(text, TextStyles.small)),
        ],
      ),
    );
  }
}

class _InstallPanel extends StatelessWidget {
  const _InstallPanel({required this.entry});

  final SkillDocEntry entry;

  SkillInstallRoute get _plugin => entry.installRoutes.singleWhere(
    (SkillInstallRoute route) => route.id == 'plugin',
  );

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Semantics(
      key: const ValueKey<String>('skill-install'),
      container: true,
      label: 'Install for Claude Code',
      child: Panel(
        label: 'Install',
        note: 'Claude Code',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StyledText(
              'Run these inside Claude Code. The public GitHub marketplace '
              'route is verified.',
              TextStyles.body,
              color: theme.foreground,
            ),
            SizedBox(height: space(3)),
            StyledText(
              'Slash commands are not PowerShell commands. If the install '
              'summary says the plugin is already active, skip reload.',
              TextStyles.small,
              color: theme.mutedForeground,
            ),
            _RouteAction(label: 'Install', commands: _plugin.install),
          ],
        ),
      ),
    );
  }
}

class _ManagePanel extends StatelessWidget {
  const _ManagePanel({required this.entry});

  final SkillDocEntry entry;

  SkillInstallRoute get _plugin => entry.installRoutes.singleWhere(
    (SkillInstallRoute route) => route.id == 'plugin',
  );

  @override
  Widget build(BuildContext context) => Panel(
    key: const ValueKey<String>('skill-manage'),
    label: 'Manage',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _RouteAction(label: 'Update', commands: _plugin.update),
        _RouteAction(label: 'Inspect and try', commands: _plugin.inspect),
        _RouteAction(label: 'Remove', commands: _plugin.remove),
      ],
    ),
  );
}

class _SourcePanel extends StatelessWidget {
  const _SourcePanel({required this.entry, required this.files});

  final SkillDocEntry entry;
  final List<DocsCodeFile> files;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Panel(
      key: const ValueKey<String>('skill-source'),
      label: 'Source',
      note: 'v${entry.version}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SpecimenRow(
            children: <Widget>[
              for (final String agent in entry.supportedAgents)
                Badge(label: agent, variant: BadgeVariant.success),
            ],
          ),
          SizedBox(height: space(3)),
          StyledText(entry.repository, TextStyles.identifier),
          SizedBox(height: space(2)),
          StyledText(
            '${entry.licenseStatus} Detailed rules and templates ship with '
            'the plugin and load only when relevant.',
            TextStyles.small,
            color: theme.mutedForeground,
          ),
          SizedBox(height: space(4)),
          DocsDisclosure(
            title: 'Browse skill files',
            child: DocsFileTree(
              key: ValueKey<String>('docs-file-tree:${entry.slug}'),
              label: 'Files',
              files: files,
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteAction extends StatelessWidget {
  const _RouteAction({required this.label, required this.commands});

  final String label;
  final List<SkillCommand> commands;

  @override
  Widget build(BuildContext context) {
    if (commands.isEmpty) return const SizedBox.shrink();
    final ThemeTokens theme = ThemeScope.of(context);
    return Padding(
      padding: EdgeInsets.only(top: space(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StyledText(
            label.toUpperCase(),
            TextStyles.small,
            color: theme.mutedForeground,
          ),
          SizedBox(height: space(2)),
          for (int i = 0; i < commands.length; i++) ...<Widget>[
            if (i > 0) SizedBox(height: space(3)),
            _CommandBlock(command: commands[i]),
          ],
        ],
      ),
    );
  }
}

class _CommandBlock extends StatelessWidget {
  const _CommandBlock({required this.command});

  final SkillCommand command;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    // Mapped onto `docs_code.dart`'s own command type rather than a
    // hand-rolled equivalent: see that file's `DocsCodeCommand` and this
    // page's library doc.
    final DocsCodeCommand docsCommand = DocsCodeCommand(
      command: command.command,
      label: command.label,
      description: command.description,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StyledText(
          docsCommand.label,
          TextStyles.small,
          color: theme.foreground,
        ),
        if (docsCommand.description != null) ...<Widget>[
          SizedBox(height: space(1)),
          StyledText(
            docsCommand.description!,
            TextStyles.small,
            color: theme.mutedForeground,
          ),
        ],
        SizedBox(height: space(2)),
        DocsSelectableCodeBlock(
          key: ValueKey<String>('skill-command:${docsCommand.command}'),
          code: docsCommand.command,
        ),
      ],
    );
  }
}
