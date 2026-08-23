/// The persistent left navigation rail for the documentation shell.
///
/// Modelled on the target reference layout
/// (https://ui.shadcn.com/docs/installation): one rail, identical on every
/// docs and component route, holding labelled groups — "Sections" then
/// "Components" in the reference — where only the active entry differs from
/// page to page. [DocsSidebar] renders whatever [DocsSidebarGroup]s it is
/// given, in order; it does not know about routes, a catalog, or which page
/// is "current" beyond the [DocsSidebarEntry.selected] flag each entry
/// already carries in.
///
/// `DocsLayout` is the only caller today. It also still accepts the older,
/// ungrouped `sidebar` list (one flat `List<DocsSidebarEntry>`, no group
/// label) for the pages that predate this file — see the adapter in
/// `docs_layout.dart`'s build method, which wraps that list in a single
/// unlabelled-by-default group rather than asking every existing call site to
/// migrate at once.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart';

/// One page in the left rail.
class DocsSidebarEntry {
  const DocsSidebarEntry({
    required this.title,
    required this.route,
    this.selected = false,
  });

  final String title;
  final String route;

  /// Whether this entry is the page currently on screen. Exactly one entry
  /// across all groups should carry `true` for a given route; [DocsSidebar]
  /// does not enforce that itself, it only renders whatever it is handed.
  final bool selected;
}

/// A labelled group of [DocsSidebarEntry] — e.g. "Sections" holding
/// Introduction/Installation/Theming, or "Components" holding every component
/// page. Groups render in the order given, each under its own label.
class DocsSidebarGroup {
  const DocsSidebarGroup({required this.label, required this.items});

  final String label;
  final List<DocsSidebarEntry> items;
}

/// The left rail itself: every [groups] entry, grouped and labelled, each a
/// tap target that calls [onNavigate] with its route.
///
/// Renders nothing when [groups] is empty — a page that supplies no
/// navigation data pays nothing for an empty labelled box, which is what lets
/// `DocsLayout` keep rendering the surrounding rail chrome unconditionally at
/// desktop width regardless of whether any given page has wired real data in
/// yet.
class DocsSidebar extends StatelessWidget {
  const DocsSidebar({
    super.key,
    required this.groups,
    required this.onNavigate,
  });

  final List<DocsSidebarGroup> groups;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) return const SizedBox.shrink();
    return Semantics(
      container: true,
      label: 'Documentation navigation',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (int i = 0; i < groups.length; i++) ...<Widget>[
            if (i > 0) SizedBox(height: ds(6)),
            _SidebarGroup(group: groups[i], onNavigate: onNavigate),
          ],
        ],
      ),
    );
  }
}

class _SidebarGroup extends StatelessWidget {
  const _SidebarGroup({required this.group, required this.onNavigate});

  final DocsSidebarGroup group;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey<String>('docs-sidebar-group:${group.label}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsText(group.label, DsType.label),
        SizedBox(height: ds(3)),
        for (final DocsSidebarEntry entry in group.items)
          _SidebarRow(entry: entry, onNavigate: onNavigate),
      ],
    );
  }
}

class _SidebarRow extends StatelessWidget {
  const _SidebarRow({required this.entry, required this.onNavigate});

  final DocsSidebarEntry entry;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Semantics(
      link: true,
      selected: entry.selected,
      child: GestureDetector(
        onTap: () => onNavigate(entry.route),
        behavior: HitTestBehavior.opaque,
        child: Container(
          key: ValueKey<String>('docs-sidebar:${entry.route}'),
          padding: EdgeInsets.symmetric(horizontal: ds(3), vertical: ds(2)),
          decoration: BoxDecoration(
            color: entry.selected ? theme.muted : null,
            borderRadius: BorderRadius.circular(DsRadii.md),
          ),
          child: DsText(
            entry.title,
            DsType.small,
            color: entry.selected ? theme.foreground : theme.mutedForeground,
          ),
        ),
      ),
    );
  }
}
