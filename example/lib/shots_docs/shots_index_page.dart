/// The Shots index — a filterable catalog of installable Shots.
///
/// Website chrome (`docs/superpowers/plans/2026-08-22-phase-g-shots-scope.md`
/// ruling 2): this page documents `shotDocs`, it is never shipped, and it is
/// free to use `DsGrid`/`DsPageHeader` from the example app's own kit even
/// though those two are off-limits inside an actual Shot composition.
///
/// Mirrors `PublicComponentsPage` in `site/pages/public_pages.dart` — header,
/// then a card grid — but that file's `_PublicPage` and `_PublicLinkCard` are
/// private to it, so the equivalent shell and card are recomposed here from
/// public `Ds*` widgets and the kit.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';
import '../site/pages/public_pages.dart';
import 'catalog.dart';

String _familyLabel(ShotFamily family) => switch (family) {
  ShotFamily.account => 'Account',
  ShotFamily.authentication => 'Authentication',
  ShotFamily.dashboard => 'Dashboard',
};

String _platformLabel(ShotPlatform platform) => switch (platform) {
  ShotPlatform.responsive => 'Responsive',
  ShotPlatform.desktop => 'Desktop',
  ShotPlatform.mobile => 'Mobile',
};

/// [ShotFamily] plus a leading "all" state — the family filter's options.
enum _FamilyFilter {
  all,
  account(ShotFamily.account),
  authentication(ShotFamily.authentication),
  dashboard(ShotFamily.dashboard);

  const _FamilyFilter([this.family]);

  /// Null only for [all].
  final ShotFamily? family;

  String get label => family == null ? 'All' : _familyLabel(family!);

  bool matches(ShotDocEntry entry) => family == null || entry.family == family;
}

/// [ShotPlatform] plus a leading "all" state — the platform filter's options.
enum _PlatformFilter {
  all,
  responsive(ShotPlatform.responsive),
  desktop(ShotPlatform.desktop),
  mobile(ShotPlatform.mobile);

  const _PlatformFilter([this.platform]);

  /// Null only for [all].
  final ShotPlatform? platform;

  String get label => platform == null ? 'All' : _platformLabel(platform!);

  bool matches(ShotDocEntry entry) =>
      platform == null || entry.platform == platform;
}

/// A filterable catalog of every entry in [shotDocs].
///
/// Filter state (family, platform) is local to the page — neither filter
/// reads from or writes to a route, so the "all" state is simply index 0 of
/// each [DsToggleGroup].
class ShotsIndexPage extends StatefulWidget {
  const ShotsIndexPage({super.key, this.onNavigate});

  final PublicNavigate? onNavigate;

  @override
  State<ShotsIndexPage> createState() => _ShotsIndexPageState();
}

class _ShotsIndexPageState extends State<ShotsIndexPage> {
  int _familyIndex = 0;
  int _platformIndex = 0;

  _FamilyFilter get _family => _FamilyFilter.values[_familyIndex];
  _PlatformFilter get _platform => _PlatformFilter.values[_platformIndex];

  void _resetFilters() => setState(() {
    _familyIndex = 0;
    _platformIndex = 0;
  });

  @override
  Widget build(BuildContext context) {
    final List<ShotDocEntry> entries = <ShotDocEntry>[
      for (final ShotDocEntry entry in shotDocs)
        if (_family.matches(entry) && _platform.matches(entry)) entry,
    ];

    return _ShotsPage(
      child: Column(
        key: const ValueKey<String>('shots-index-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const DsPageHeader(
            eyebrow: 'COMPOSED EXAMPLES',
            title: 'Shots',
            blurb:
                'Installable, product-neutral screens assembled from stable registry components. Filter by family or platform, then copy the CLI command to add one to your project.',
          ),
          _FilterBar(
            familyIndex: _familyIndex,
            platformIndex: _platformIndex,
            onFamilyChanged: (int? index) =>
                setState(() => _familyIndex = index ?? 0),
            onPlatformChanged: (int? index) =>
                setState(() => _platformIndex = index ?? 0),
          ),
          SizedBox(height: ds(6)),
          if (entries.isEmpty)
            _EmptyFilterState(onReset: _resetFilters)
          else
            DsGrid(
              key: const ValueKey<String>('shots-index-grid'),
              sm: 2,
              xl: 3,
              children: <Widget>[
                for (final ShotDocEntry entry in entries)
                  _ShotEntryCard(entry: entry, onNavigate: widget.onNavigate),
              ],
            ),
        ],
      ),
    );
  }
}

/// `_PublicPage`'s equivalent, recomposed: safe area, page padding, and a
/// centred column capped at [DsBreakpoints.xl].
class _ShotsPage extends StatelessWidget {
  const _ShotsPage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DsSafeArea(
    top: false,
    bottom: true,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: ds(4), vertical: ds(8)),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DsBreakpoints.xl),
          child: child,
        ),
      ),
    ),
  );
}

/// The two filter controls: family and platform, each a [DsToggleGroup] with
/// a leading "all" option.
class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.familyIndex,
    required this.platformIndex,
    required this.onFamilyChanged,
    required this.onPlatformChanged,
  });

  final int familyIndex;
  final int platformIndex;
  final ValueChanged<int?> onFamilyChanged;
  final ValueChanged<int?> onPlatformChanged;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: ds(8),
    runSpacing: ds(5),
    children: <Widget>[
      _FilterGroup(
        label: 'FAMILY',
        // Horizontal scroll rather than a fixed-width row: at narrow
        // viewports, four items (one of them "Authentication") do not fit —
        // `DsSlidingPillGroup`'s Row has no wrap of its own, so it is given
        // room to size to its own intrinsic width instead of overflowing.
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DsToggleGroup(
            key: const ValueKey<String>('shots-filter-family'),
            items: <DsToggleGroupItem>[
              for (final _FamilyFilter filter in _FamilyFilter.values)
                DsToggleGroupItem(label: filter.label),
            ],
            selectedIndex: familyIndex,
            onChanged: onFamilyChanged,
          ),
        ),
      ),
      _FilterGroup(
        label: 'PLATFORM',
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DsToggleGroup(
            key: const ValueKey<String>('shots-filter-platform'),
            items: <DsToggleGroupItem>[
              for (final _PlatformFilter filter in _PlatformFilter.values)
                DsToggleGroupItem(label: filter.label),
            ],
            selectedIndex: platformIndex,
            onChanged: onPlatformChanged,
          ),
        ),
      ),
    ],
  );
}

class _FilterGroup extends StatelessWidget {
  const _FilterGroup({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DsText(label, DsType.label, color: theme.mutedForeground),
        SizedBox(height: ds(2)),
        // A named container around the toggle group only — not the label
        // above, which is a plain, non-boundary text node and would merge
        // into this one's own label rather than stay separate (the same
        // merge hazard `docs_file_tree.dart` documents on its own panel).
        // Without this, the FAMILY and PLATFORM groups each lead with an
        // item labelled "All", indistinguishable from one another to a
        // screen-reader user; each toggle inside remains its own
        // actionable node, so this only adds a group name around them.
        Semantics(container: true, label: '$label filter', child: child),
      ],
    );
  }
}

/// One [shotDocs] entry: title, CLI command, description, and a link to
/// [ShotDocEntry.route].
class _ShotEntryCard extends StatelessWidget {
  const _ShotEntryCard({required this.entry, this.onNavigate});

  final ShotDocEntry entry;
  final PublicNavigate? onNavigate;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsCard(
      key: ValueKey<String>('shot-card-${entry.name}'),
      children: <Widget>[
        DsCardHeader(
          title: DsText(entry.title, DsType.h4, color: theme.foreground),
          description: DsText(
            entry.command,
            DsType.code,
            color: theme.actionInk,
          ),
        ),
        DsCardContent(child: DsText(entry.description, DsType.small)),
        DsCardFooter(
          child: DsButton(
            variant: DsButtonVariant.ghost,
            // Every card's button otherwise shares the one accessible name
            // "View shot" — indistinguishable to a screen-reader user
            // skimming a grid of them (see `shot_detail_page.dart`'s
            // "Open live preview of ${entry.title}" for the same fix
            // elsewhere).
            label: 'View shot: ${entry.title}',
            onPressed: onNavigate == null
                ? null
                : () => onNavigate!(entry.route),
            child: const Text('View shot'),
          ),
        ),
      ],
    );
  }
}

/// Rendered instead of the grid when the active filters match nothing.
class _EmptyFilterState extends StatelessWidget {
  const _EmptyFilterState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) => DsPanel(
    key: const ValueKey<String>('shots-index-empty'),
    child: DsEmpty(
      children: <Widget>[
        const DsEmptyHeader(
          children: <Widget>[
            DsEmptyMedia(glyph: DsIconGlyph.search, tone: DsIconTone.subtle),
            DsEmptyTitle('No shots match those filters'),
            // Accurate for either a single active filter or both together —
            // the reachable path is not always the two-filter combination
            // the old copy implied.
            DsEmptyDescription(
              'Nothing in the catalog matches the selected filters. Try a '
              'different combination or reset the filters.',
            ),
          ],
        ),
        DsEmptyContent(
          children: <Widget>[
            DsButton(
              variant: DsButtonVariant.outline,
              onPressed: onReset,
              child: const Text('Reset filters'),
            ),
          ],
        ),
      ],
    ),
  );
}
