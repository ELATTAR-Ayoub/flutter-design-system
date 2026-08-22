/// The Shot detail page — install command, file tree, dependencies, preview
/// link — for one [ShotDocEntry].
///
/// Mirrors `components_docs/button_card_pages.dart`'s `ButtonDocPage`: an
/// article built on [DocsLayout], with the same breadcrumb / sidebar / TOC /
/// prev-next chrome every other public documentation page carries. The one
/// new primitive is `docs/docs_file_tree.dart`'s [DocsFileTree], which shows
/// the Shot's file list beside a single-file code pane instead of stacking
/// every file the way `docs_code.dart`'s manual pane does.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../docs/docs_code.dart';
import '../docs/docs_file_tree.dart';
import '../docs/docs_layout.dart';
import '../kit.dart';
import 'catalog.dart';

/// The index route the "Shots" breadcrumb crumb points at.
///
/// `shots_docs/shots_index_page.dart` (a sibling Wave-1 file this worker does
/// not own) is expected to answer at this route; Wave 2 wires the two
/// together in `main.dart`. Kept private and file-local so it cannot collide
/// with whatever route constant that sibling file declares for itself.
const String _shotsIndexRoute = '/shots';

class ShotDetailPage extends StatelessWidget {
  const ShotDetailPage({
    super.key,
    required this.entry,
    this.fileSource = const <String, String>{},
    this.onNavigate,
  });

  /// The catalog entry this page documents.
  final ShotDocEntry entry;

  /// Source for each name in [ShotDocEntry.files], keyed by that plain file
  /// name (e.g. `settings_profile_shot.dart`) — **not** the repo-relative
  /// path [ShotDocEntry.sourcePaths] returns.
  ///
  /// A widget has no business reading the filesystem at build time — that is
  /// unavailable outright on web/mobile targets and cwd-fragile even in a
  /// widget-test host, since [ShotDocEntry.sourcePaths] is repo-root-relative
  /// while `flutter test` runs from the `example/` package root. So this page
  /// takes the file contents as data instead. A file missing from this map
  /// renders a placeholder explaining that instead of throwing.
  ///
  /// Wave 2 is expected to populate this — e.g. by reading
  /// [ShotDocEntry.sourcePaths] at build/generation time and threading the
  /// result down from `main.dart`, the same place that already owns routing
  /// this page in.
  final Map<String, String> fileSource;

  final ValueChanged<String>? onNavigate;

  static String _platformLabel(ShotPlatform platform) => switch (platform) {
        ShotPlatform.responsive => 'RESPONSIVE',
        ShotPlatform.desktop => 'DESKTOP',
        ShotPlatform.mobile => 'MOBILE',
      };

  static ({ShotDocEntry? previous, ShotDocEntry? next}) _siblings(
    ShotDocEntry entry,
  ) {
    final int index = shotDocs.indexWhere(
      (ShotDocEntry candidate) => candidate.name == entry.name,
    );
    if (index < 0) return (previous: null, next: null);
    return (
      previous: index > 0 ? shotDocs[index - 1] : null,
      next: index < shotDocs.length - 1 ? shotDocs[index + 1] : null,
    );
  }

  static List<DocsSidebarEntry> _sidebar(String route) => <DocsSidebarEntry>[
        for (final ShotDocEntry shot in shotDocs)
          DocsSidebarEntry(
            title: shot.title,
            route: shot.route,
            selected: shot.route == route,
          ),
      ];

  @override
  Widget build(BuildContext context) {
    final ({ShotDocEntry? previous, ShotDocEntry? next}) around =
        _siblings(entry);

    return DocsLayout(
      route: entry.route,
      intro: DocsPageIntro(
        eyebrow: 'SHOT · ${_platformLabel(entry.platform)}',
        title: entry.title,
        description: entry.description,
      ),
      breadcrumbs: <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link(
          'Shots',
          onTap: onNavigate == null
              ? null
              : () => onNavigate!.call(_shotsIndexRoute),
        ),
        DsBreadcrumbEntry.page(entry.title),
      ],
      sidebar: _sidebar(entry.route),
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Install', anchor: 'install'),
        DocsTocEntry(title: 'Files', anchor: 'files'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Preview', anchor: 'preview'),
      ],
      previous: around.previous == null
          ? null
          : DocsPageLink(
              title: around.previous!.title,
              route: around.previous!.route,
            ),
      next: around.next == null
          ? null
          : DocsPageLink(title: around.next!.title, route: around.next!.route),
      onNavigate: onNavigate,
      child: _ShotArticle(
        entry: entry,
        fileSource: fileSource,
        onNavigate: onNavigate,
      ),
    );
  }
}

class _ShotArticle extends StatelessWidget {
  const _ShotArticle({
    required this.entry,
    required this.fileSource,
    required this.onNavigate,
  });

  final ShotDocEntry entry;
  final Map<String, String> fileSource;
  final ValueChanged<String>? onNavigate;

  List<DocsCodeFile> get _files => <DocsCodeFile>[
        for (final String file in entry.files)
          DocsCodeFile(
            path: file,
            code: fileSource[file] ?? _placeholderSource(file),
          ),
      ];

  String _placeholderSource(String file) =>
      '// Source for $file is not loaded in this build.\n'
      '//\n'
      '// ShotDetailPage.fileSource is keyed by plain file name; wire in the\n'
      "// contents of '${entry.directory}/$file' "
      '(see ShotDocEntry.sourcePaths).\n';

  @override
  Widget build(BuildContext context) => Column(
        key: const ValueKey<String>('shot-doc-article'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _Anchor(
            'install',
            child: DocsCodeExample(
              title: 'Install',
              description:
                  'Installs ${entry.title} and its declared registry dependencies.',
              command: DocsCodeCommand(
                command: entry.command,
                label: 'Install command',
                description:
                    'Copies the composition into @app/shots/${entry.directory}/.',
              ),
            ),
          ),
          SizedBox(height: ds(6)),
          _Anchor(
            'files',
            child: DocsFileTree(label: 'Files', files: _files),
          ),
          SizedBox(height: ds(6)),
          _Anchor(
            'dependencies',
            child: _DependencyPanel(dependencies: entry.dependencies),
          ),
          SizedBox(height: ds(6)),
          _Anchor(
            'preview',
            child: _PreviewPanel(entry: entry, onNavigate: onNavigate),
          ),
        ],
      );
}

class _DependencyPanel extends StatelessWidget {
  const _DependencyPanel({required this.dependencies});

  final List<String> dependencies;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Semantics(
      container: true,
      label: 'Registry dependencies, ${dependencies.length} items',
      child: DsPanel(
        label: 'Dependencies',
        note: '${dependencies.length} registry items',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsText(
              'Resolved automatically by the registry client when this Shot '
              'is installed.',
              DsType.small,
              color: theme.mutedForeground,
            ),
            SizedBox(height: ds(3)),
            DsRow(
              children: <Widget>[
                for (final String dependency in dependencies) DsCode(dependency),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewPanel extends StatelessWidget {
  const _PreviewPanel({required this.entry, required this.onNavigate});

  final ShotDocEntry entry;
  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Semantics(
      container: true,
      label: 'Live preview',
      child: DsPanel(
        label: 'Preview',
        note: entry.previewRoute,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsText(
              'Open ${entry.title} chrome-free, exactly as it renders in a '
              'consumer app.',
              DsType.small,
              color: theme.mutedForeground,
            ),
            SizedBox(height: ds(4)),
            DsButton(
              variant: DsButtonVariant.secondary,
              size: DsButtonSize.md,
              label: 'Open live preview of ${entry.title}',
              onPressed: onNavigate == null
                  ? null
                  : () => onNavigate!.call(entry.previewRoute),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DsText('Open live preview', DsComponentType.buttonLabel),
                  SizedBox(width: DsButton.gapFor(DsButtonSize.md)),
                  DsIcon.lucide(DsLucide.arrowUpRight, size: DsIconSize.sm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Anchor extends StatelessWidget {
  const _Anchor(this.name, {required this.child});

  final String name;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      KeyedSubtree(key: ValueKey<String>('docs-anchor:$name'), child: child);
}
