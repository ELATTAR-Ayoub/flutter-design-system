/// The public Skills page: what the skill is, which agents it is actually
/// verified for, how to install/update/inspect/remove it, its reference file
/// tree, and its version: for one [SkillDocEntry].
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
import 'package:flutter/widgets.dart';

import '../docs/docs_code.dart';
import '../docs/docs_facts.dart';
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
      breadcrumbs: const <DsBreadcrumbEntry>[DsBreadcrumbEntry.page('Skills')],
      sidebar: _sidebar(skill.route),
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Overview', anchor: 'overview'),
        DocsTocEntry(title: 'Supported agents', anchor: 'agents'),
        DocsTocEntry(title: 'Install & manage', anchor: 'install'),
        DocsTocEntry(title: 'Files', anchor: 'files'),
        DocsTocEntry(title: 'Version', anchor: 'version'),
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
        key: docsAnchorKey('overview'),
        child: _OverviewPanel(entry: entry),
      ),
      SizedBox(height: ds(6)),
      KeyedSubtree(
        key: docsAnchorKey('agents'),
        child: _AgentsPanel(entry: entry),
      ),
      SizedBox(height: ds(6)),
      KeyedSubtree(
        key: docsAnchorKey('install'),
        child: _InstallPanel(entry: entry),
      ),
      SizedBox(height: ds(6)),
      KeyedSubtree(
        key: docsAnchorKey('files'),
        child: DocsFileTree(
          // A distinct identity per skill, the same reasoning
          // `shot_detail_page.dart` documents on its own `DocsFileTree` call:
          // without this, swapping the `entry` in place could reuse this
          // widget's selected-file state across a different file list.
          key: ValueKey<String>('docs-file-tree:${entry.slug}'),
          label: 'Files',
          files: _files,
        ),
      ),
      SizedBox(height: ds(6)),
      KeyedSubtree(
        key: docsAnchorKey('version'),
        child: _VersionPanel(entry: entry),
      ),
    ],
  );
}

class _OverviewPanel extends StatelessWidget {
  const _OverviewPanel({required this.entry});

  final SkillDocEntry entry;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Semantics(
      key: const ValueKey<String>('skill-overview'),
      container: true,
      label: 'Overview',
      child: DsPanel(
        label: 'Overview',
        note: '${entry.workflow.length} workflow steps',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsText(entry.summary, DsType.body, color: theme.foreground),
            SizedBox(height: ds(5)),
            DsText('WORKFLOW', DsType.label, color: theme.mutedForeground),
            SizedBox(height: ds(3)),
            for (int i = 0; i < entry.workflow.length; i++) ...<Widget>[
              if (i > 0) SizedBox(height: ds(2)),
              _WorkflowStep(index: i + 1, text: entry.workflow[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class _WorkflowStep extends StatelessWidget {
  const _WorkflowStep({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Semantics(
      container: true,
      label: 'Step $index: $text',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: ds(6),
            child: DsText(
              '$index.',
              DsType.small,
              color: theme.mutedForeground,
            ),
          ),
          Expanded(child: DsText(text, DsType.small)),
        ],
      ),
    );
  }
}

class _AgentsPanel extends StatelessWidget {
  const _AgentsPanel({required this.entry});

  final SkillDocEntry entry;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Semantics(
      key: const ValueKey<String>('skill-agents'),
      container: true,
      label: 'Supported agents',
      child: DsPanel(
        label: 'Supported agents',
        note: '${entry.supportedAgents.length} verified',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsRow(
              children: <Widget>[
                for (final String agent in entry.supportedAgents)
                  DsBadge(label: agent, variant: DsBadgeVariant.success),
              ],
            ),
            SizedBox(height: ds(3)),
            DsText(
              'This skill is written for, and verified only against, the '
              'harness named above. No other agent harness has a recorded '
              'install route, so none is claimed here.',
              DsType.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}

class _InstallPanel extends StatelessWidget {
  const _InstallPanel({required this.entry});

  final SkillDocEntry entry;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Semantics(
      key: const ValueKey<String>('skill-install'),
      container: true,
      label: 'Install and manage',
      child: DsPanel(
        label: 'Install & manage',
        note: '${entry.installRoutes.length} routes',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsText(
              entry.licenseStatus,
              DsType.small,
              color: theme.mutedForeground,
            ),
            for (final SkillInstallRoute route
                in entry.installRoutes) ...<Widget>[
              SizedBox(height: ds(6)),
              _RoutePanel(route: route),
            ],
          ],
        ),
      ),
    );
  }
}

class _RoutePanel extends StatelessWidget {
  const _RoutePanel({required this.route});

  final SkillInstallRoute route;

  bool get _pending => route.status == SkillRouteStatus.pendingVerification;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Semantics(
      container: true,
      label:
          '${route.title}, ${_pending ? 'pending verification' : 'works today'}',
      child: Container(
        key: ValueKey<String>('skill-route:${route.id}'),
        padding: EdgeInsets.all(ds(5)),
        decoration: BoxDecoration(
          color: theme.card,
          borderRadius: BorderRadius.circular(DsRadii.lg),
          border: Border.all(color: theme.border, width: DsWidths.hairline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: ds(2),
              spacing: ds(3),
              children: <Widget>[
                DsText(route.title, DsType.label, color: theme.foreground),
                DsBadge(
                  label: _pending ? 'Pending verification' : 'Works today',
                  variant: _pending
                      ? DsBadgeVariant.warning
                      : DsBadgeVariant.success,
                ),
              ],
            ),
            SizedBox(height: ds(2)),
            DsText(route.summary, DsType.small, color: theme.mutedForeground),
            if (route.blockedBy != null) ...<Widget>[
              SizedBox(height: ds(3)),
              DsNote(
                tone: DsNoteTone.error,
                title: 'Pending',
                child: DsText(route.blockedBy!, DsType.small),
              ),
            ],
            _RouteAction(label: 'Install', commands: route.install),
            _RouteAction(
              label: 'Update',
              commands: route.update,
              note: route.updateNote,
            ),
            _RouteAction(label: 'Inspect', commands: route.inspect),
            _RouteAction(label: 'Remove', commands: route.remove),
          ],
        ),
      ),
    );
  }
}

class _RouteAction extends StatelessWidget {
  const _RouteAction({required this.label, required this.commands, this.note});

  final String label;
  final List<SkillCommand> commands;
  final String? note;

  @override
  Widget build(BuildContext context) {
    if (commands.isEmpty && note == null) return const SizedBox.shrink();
    final DsThemeData theme = DsTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: ds(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsText(
            label.toUpperCase(),
            DsType.label,
            color: theme.mutedForeground,
          ),
          SizedBox(height: ds(2)),
          if (commands.isEmpty)
            DsText(note!, DsType.small, color: theme.mutedForeground)
          else
            for (int i = 0; i < commands.length; i++) ...<Widget>[
              if (i > 0) SizedBox(height: ds(3)),
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
    final DsThemeData theme = DsTheme.of(context);
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
        DsText(docsCommand.label, DsType.small, color: theme.foreground),
        if (docsCommand.description != null) ...<Widget>[
          SizedBox(height: ds(1)),
          DsText(
            docsCommand.description!,
            DsType.small,
            color: theme.mutedForeground,
          ),
        ],
        SizedBox(height: ds(2)),
        DocsSelectableCodeBlock(
          key: ValueKey<String>('skill-command:${docsCommand.command}'),
          code: docsCommand.command,
        ),
      ],
    );
  }
}

class _VersionPanel extends StatelessWidget {
  const _VersionPanel({required this.entry});

  final SkillDocEntry entry;

  @override
  Widget build(BuildContext context) => Semantics(
    key: const ValueKey<String>('skill-version'),
    container: true,
    label: 'Version',
    child: DocsInstallFacts(
      title: 'Version',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Skill version',
          value: entry.version,
          description:
              'First release. Version compatibility beyond "tested against '
              'the current Claude Code plugin system" is not claimed.',
        ),
        DocsInstallFact(
          label: 'Plugin name',
          value: entry.pluginName,
          description:
              'The plugin name Claude Code installs once the plugin route '
              'is verified.',
        ),
        DocsInstallFact(
          label: 'Marketplace',
          value: entry.marketplaceName,
          description:
              "This repository's own marketplace name: see "
              '.claude-plugin/marketplace.json.',
        ),
        DocsInstallFact(
          label: 'Repository',
          value: entry.repository,
          description:
              "Source of truth for the skill's files. Not a "
              'copy-pasteable install command: see Install & manage above.',
        ),
      ],
    ),
  );
}
