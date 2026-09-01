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
    this.selectedKey,
  });

  final List<DocsSidebarGroup> groups;
  final ValueChanged<String> onNavigate;

  /// Attached to the one selected row, so an owner can scroll it into view.
  ///
  /// The rail is four groups and ninety-nine rows long: on a cold load of
  /// `/components/voice-indicator` the selected row is far below the fold,
  /// and a reader who followed a link has no way of knowing the rail even
  /// knows where they are. `DocsLayout` uses this to put the current page on
  /// screen the first time it mounts the rail. Null when nothing is
  /// selected, and attached to the first selected row if a caller ever
  /// breaks the one-selected-entry contract, since two widgets cannot share
  /// a [GlobalKey].
  final GlobalKey? selectedKey;

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) return const SizedBox.shrink();
    final DocsSidebarEntry? selected = <DocsSidebarEntry>[
      for (final DocsSidebarGroup group in groups) ...group.items,
    ].where((DocsSidebarEntry entry) => entry.selected).firstOrNull;
    return Semantics(
      container: true,
      label: 'Documentation navigation',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (int i = 0; i < groups.length; i++) ...<Widget>[
            if (i > 0) SizedBox(height: space(6)),
            _SidebarGroup(
              group: groups[i],
              onNavigate: onNavigate,
              selectedKey: selectedKey,
              selected: selected,
            ),
          ],
        ],
      ),
    );
  }
}

class _SidebarGroup extends StatelessWidget {
  const _SidebarGroup({
    required this.group,
    required this.onNavigate,
    required this.selectedKey,
    required this.selected,
  });

  final DocsSidebarGroup group;
  final ValueChanged<String> onNavigate;
  final GlobalKey? selectedKey;
  final DocsSidebarEntry? selected;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      key: ValueKey<String>('docs-sidebar-group:${group.label}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StyledText(group.label, TextStyles.small, color: theme.mutedForeground),
        SizedBox(height: space(3)),
        for (int i = 0; i < group.items.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: space(1)),
          _SidebarRow(
            key: identical(group.items[i], selected) ? selectedKey : null,
            entry: group.items[i],
            onNavigate: onNavigate,
          ),
        ],
      ],
    );
  }
}

/// One row. Tracks its own hover so a resting hover and the active row paint
/// the identical fill. Measured on the reference: its `SidebarMenuButton`
/// carries `hover:bg-sidebar-accent hover:text-sidebar-accent-foreground`
/// beside `data-active:bg-accent`, the same token family for both states. The
/// pill is what carries the hierarchy, the rest of the rail declines to.
///
/// The ink cross-fade follows `_DsCrumbState` in `breadcrumb.dart`, a
/// `MouseRegion` flipping a bool into a `TweenAnimationBuilder<Color?>` that
/// rides [MotionDurations.normal] on [MotionCurves.enter]. The pill itself
/// is not put through the same builder, since `TweenAnimationBuilder` asserts
/// its `tween.end` is non-null, and the resting pill has to be a literal
/// `null` fill, not a zero-alpha colour, for the decoration to read as "no
/// pill" rather than "an invisible one." It swaps directly on the same build
/// that flips [_hovered] instead.
class _SidebarRow extends StatefulWidget {
  const _SidebarRow({super.key, required this.entry, required this.onNavigate});

  final DocsSidebarEntry entry;
  final ValueChanged<String> onNavigate;

  @override
  State<_SidebarRow> createState() => _SidebarRowState();
}

class _SidebarRowState extends State<_SidebarRow> {
  bool _hovered = false;

  void _hover(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final DocsSidebarEntry entry = widget.entry;
    final bool filled = entry.selected || _hovered;
    final Duration duration = effectiveMotionDuration(
      context,
      MotionDurations.normal,
    );

    return Semantics(
      link: true,
      selected: entry.selected,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _hover(true),
        onExit: (_) => _hover(false),
        child: GestureDetector(
          onTap: () => widget.onNavigate(entry.route),
          behavior: HitTestBehavior.opaque,
          child: SelectionContainer.disabled(
            child: Container(
              key: ValueKey<String>('docs-sidebar:${entry.route}'),
              padding: EdgeInsets.symmetric(
                horizontal: space(3),
                vertical: space(2),
              ),
              decoration: BoxDecoration(
                color: filled ? theme.sidebarAccent : null,
                borderRadius: BorderRadius.circular(Radii.md),
              ),
              child: TweenAnimationBuilder<Color?>(
                tween: ColorTween(
                  end: filled
                      ? theme.sidebarAccentForeground
                      : theme.sidebarForeground,
                ),
                duration: duration,
                curve: MotionCurves.enter,
                builder: (BuildContext context, Color? ink, Widget? _) =>
                    StyledText(
                      entry.title,
                      TextStyles.small,
                      color: ink ?? theme.sidebarForeground,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
