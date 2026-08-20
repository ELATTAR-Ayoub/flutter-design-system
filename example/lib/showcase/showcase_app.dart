/// Signal Studio's adaptive product shell.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/material.dart';

import '../theme_toggle.dart';
import 'showcase_dashboard.dart';
import 'showcase_feedback.dart';
import 'showcase_profile.dart';
import 'showcase_reels.dart';
import 'showcase_shell_scope.dart';

/// Three destinations in the creator analytics showcase.
enum ShowcaseDestination { profile, dashboard, reels }

/// A complete, self-contained entry point for the product showcase.
///
/// The destination builders are optional seams for focused widget tests. The
/// production path always mounts the dedicated profile and reels pages.
class SignalStudioApp extends StatefulWidget {
  const SignalStudioApp({
    super.key,
    this.profileBuilder,
    this.reelsBuilder,
    this.reduceMotion,
    this.onOpenDesignSystem,
  });

  final WidgetBuilder? profileBuilder;
  final WidgetBuilder? reelsBuilder;
  final bool? reduceMotion;
  final VoidCallback? onOpenDesignSystem;

  @override
  State<SignalStudioApp> createState() => _SignalStudioAppState();
}

class _SignalStudioAppState extends State<SignalStudioApp> {
  final DsThemeController _theme = DsThemeController();

  @override
  void dispose() {
    _theme.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget app = DsTheme(
      controller: _theme,
      child: MaterialApp(
        title: 'Signal Studio',
        debugShowCheckedModeBanner: false,
        home: SignalStudioShowcase(
          profileBuilder: widget.profileBuilder,
          reelsBuilder: widget.reelsBuilder,
          onOpenDesignSystem: widget.onOpenDesignSystem,
        ),
      ),
    );

    if (widget.reduceMotion == true) {
      final MediaQueryData data =
          MediaQuery.maybeOf(context) ??
          MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.first,
          );
      app = MediaQuery(
        data: data.copyWith(disableAnimations: true),
        child: app,
      );
    }
    return app;
  }
}

/// Signal Studio as an embeddable product route.
///
/// It owns product state and transient feedback, but deliberately owns neither
/// a theme nor a [MaterialApp]. The docs router can therefore mount it beside
/// documentation pages without nesting app-level scopes.
class SignalStudioShowcase extends StatefulWidget {
  const SignalStudioShowcase({
    super.key,
    this.profileBuilder,
    this.reelsBuilder,
    this.onOpenDesignSystem,
  });

  final WidgetBuilder? profileBuilder;
  final WidgetBuilder? reelsBuilder;
  final VoidCallback? onOpenDesignSystem;

  @override
  State<SignalStudioShowcase> createState() => _SignalStudioShowcaseState();
}

class _SignalStudioShowcaseState extends State<SignalStudioShowcase> {
  final DsToastController _toasts = DsToastController();
  ShowcaseDestination _destination = ShowcaseDestination.profile;

  @override
  void dispose() {
    _toasts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ShowcaseFeedback(
    controller: _toasts,
    child: _SignalStudioShell(
      destination: _destination,
      onDestinationChanged: (ShowcaseDestination next) =>
          setState(() => _destination = next),
      profileBuilder: widget.profileBuilder,
      reelsBuilder: widget.reelsBuilder,
      toaster: _toasts,
      onOpenDesignSystem: widget.onOpenDesignSystem,
    ),
  );
}

class _SignalStudioShell extends StatelessWidget {
  const _SignalStudioShell({
    required this.destination,
    required this.onDestinationChanged,
    required this.profileBuilder,
    required this.reelsBuilder,
    required this.toaster,
    required this.onOpenDesignSystem,
  });

  final ShowcaseDestination destination;
  final ValueChanged<ShowcaseDestination> onDestinationChanged;
  final WidgetBuilder? profileBuilder;
  final WidgetBuilder? reelsBuilder;
  final DsToastController toaster;
  final VoidCallback? onOpenDesignSystem;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final bool compact = MediaQuery.sizeOf(context).width < DsBreakpoints.lg;
    final List<Widget> pages = <Widget>[
      profileBuilder?.call(context) ?? SignalStudioProfilePage(toasts: toaster),
      const ShowcaseDashboard(),
      reelsBuilder?.call(context) ?? SignalStudioReelsPage(toasts: toaster),
    ];

    return DefaultTextStyle(
      style: DsText.styleOf(context, DsType.body, color: theme.foreground),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const DsPageGlow(),
          DsSafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    compact ? ds(4) : ds(5),
                    ds(3),
                    compact ? ds(4) : ds(5),
                    ds(3),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: compact ? DsContainers.md : DsWidths.page,
                      ),
                      child: _StudioHeader(
                        compact: compact,
                        destination: destination,
                        onDestinationChanged: onDestinationChanged,
                        onOpenDesignSystem: onOpenDesignSystem,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ShowcaseShellScope(
                    compact: compact,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: DsWidths.page,
                      ),
                      child: IndexedStack(
                        index: destination.index,
                        children: pages,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (compact)
            Positioned(
              left: ds(0),
              right: ds(0),
              bottom: ds(0),
              child: DsSafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(ds(5), 0, ds(5), ds(3)),
                  child: _DestinationNavigation(
                    compact: true,
                    destination: destination,
                    onChanged: onDestinationChanged,
                  ),
                ),
              ),
            ),
          Positioned.fill(child: DsToaster(controller: toaster)),
        ],
      ),
    );
  }
}

class _StudioHeader extends StatelessWidget {
  const _StudioHeader({
    required this.compact,
    required this.destination,
    required this.onDestinationChanged,
    required this.onOpenDesignSystem,
  });

  final bool compact;
  final ShowcaseDestination destination;
  final ValueChanged<ShowcaseDestination> onDestinationChanged;
  final VoidCallback? onOpenDesignSystem;

  @override
  Widget build(BuildContext context) {
    final Widget identity = DsButton(
      key: const Key('showcase-header-profile'),
      variant: DsButtonVariant.ghost,
      size: DsButtonSize.sm,
      padding: compact
          ? EdgeInsets.only(
              left: ds(4) - DsWidths.hairline,
              right: DsButton.paddingXFor(DsButtonSize.sm),
            )
          : null,
      label: 'Open Ari Rocha profile',
      onPressed: () => onDestinationChanged(ShowcaseDestination.profile),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const DsAvatar(
            key: Key('showcase-header-avatar'),
            fallback: 'AR',
            image: AssetImage('assets/imgs/sample-card.png'),
            size: DsAvatarSize.sm,
          ),
          SizedBox(width: ds(2)),
          DsText('Ari Rocha', DsType.nav),
        ],
      ),
    );

    final Widget controls = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (onOpenDesignSystem case final VoidCallback openDocs) ...<Widget>[
          DsButton(
            variant: DsButtonVariant.outline,
            size: compact ? DsButtonSize.icon : DsButtonSize.sm,
            label: 'Back to design system',
            onPressed: openDocs,
            child: compact
                ? DsIcon.lucide(DsLucide.arrowLeft, size: DsIconSize.sm)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      DsIcon.lucide(DsLucide.arrowLeft, size: DsIconSize.sm),
                      SizedBox(width: DsButton.gapFor(DsButtonSize.sm)),
                      DsText('System', DsComponentType.buttonLabel),
                    ],
                  ),
          ),
          SizedBox(width: ds(2)),
        ],
        const ThemeToggle(),
      ],
    );

    if (compact) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Align(alignment: Alignment.centerLeft, child: identity),
          ),
          SizedBox(width: ds(2)),
          controls,
        ],
      );
    }

    return Row(
      children: <Widget>[
        identity,
        SizedBox(width: ds(2)),
        Expanded(
          child: _DestinationNavigation(
            compact: false,
            destination: destination,
            onChanged: onDestinationChanged,
          ),
        ),
        SizedBox(width: ds(3)),
        controls,
      ],
    );
  }
}

class _DestinationNavigation extends StatelessWidget {
  const _DestinationNavigation({
    required this.compact,
    required this.destination,
    required this.onChanged,
  });

  final bool compact;
  final ShowcaseDestination destination;
  final ValueChanged<ShowcaseDestination> onChanged;

  static const List<
    ({ShowcaseDestination destination, String label, DsLucideGlyph glyph})
  >
  _items =
      <({ShowcaseDestination destination, String label, DsLucideGlyph glyph})>[
        (
          destination: ShowcaseDestination.profile,
          label: 'Profile',
          glyph: DsLucide.userRound,
        ),
        (
          destination: ShowcaseDestination.dashboard,
          label: 'Dashboard',
          glyph: DsLucide.layoutDashboard,
        ),
        (
          destination: ShowcaseDestination.reels,
          label: 'Reels',
          glyph: DsLucide.clapperboard,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return DsGlassPanelClear(
        key: const Key('showcase-compact-dock'),
        radius: BorderRadius.circular(DsRadii.xl3),
        padding: EdgeInsets.all(ds(2)),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final DsThemeData theme = DsTheme.of(context);
            final double slotWidth = constraints.maxWidth / _items.length;
            return FocusTraversalGroup(
              policy: WidgetOrderTraversalPolicy(),
              child: DsSlidingPillGroup(
                key: const Key('showcase-destination-pill-group'),
                activeIndex: destination.index,
                pill: DsMachineSurface(
                  key: const Key('showcase-destination-pill'),
                  spec: DsShadows.chip,
                  radius: BorderRadius.circular(DsRadii.lg),
                  fill: theme.secondary,
                  child: const SizedBox.expand(),
                ),
                children: <Widget>[
                  for (final ({
                        ShowcaseDestination destination,
                        String label,
                        DsLucideGlyph glyph,
                      })
                      item
                      in _items)
                    SizedBox(width: slotWidth, child: _destinationButton(item)),
                ],
              ),
            );
          },
        ),
      );
    }

    final Widget destinations = FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Row(
        children: <Widget>[
          for (final ({
                ShowcaseDestination destination,
                String label,
                DsLucideGlyph glyph,
              })
              item
              in _items)
            Expanded(child: _destinationButton(item)),
        ],
      ),
    );
    return DsCard(children: <Widget>[DsCardContent(child: destinations)]);
  }

  Widget _destinationButton(
    ({ShowcaseDestination destination, String label, DsLucideGlyph glyph}) item,
  ) {
    final bool selected = item.destination == destination;
    return Semantics(
      selected: selected,
      child: DsButton(
        variant: compact
            ? DsButtonVariant.ghost
            : selected
            ? DsButtonVariant.secondary
            : DsButtonVariant.ghost,
        size: DsButtonSize.md,
        autoHeight: compact,
        radius: compact ? BorderRadius.circular(DsRadii.lg) : null,
        padding: compact
            ? EdgeInsets.symmetric(horizontal: ds(2), vertical: ds(2))
            : null,
        label: item.label,
        onPressed: () => onChanged(item.destination),
        child: compact
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DsIcon.lucide(item.glyph, size: DsIconSize.lg),
                  SizedBox(height: ds(1)),
                  DsText(item.label, DsComponentType.buttonLabelSm),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DsIcon.lucide(item.glyph, size: DsIconSize.sm),
                  SizedBox(width: DsButton.gapFor(DsButtonSize.md)),
                  DsText(item.label, DsComponentType.buttonLabel),
                ],
              ),
      ),
    );
  }
}
