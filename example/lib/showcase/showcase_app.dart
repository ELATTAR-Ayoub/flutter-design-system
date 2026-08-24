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
  final ElThemeController _theme = ElThemeController();

  @override
  void dispose() {
    _theme.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget app = ElTheme(
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
  final ElToastController _toasts = ElToastController();
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
  final ElToastController toaster;
  final VoidCallback? onOpenDesignSystem;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final bool compact = MediaQuery.sizeOf(context).width < ElBreakpoints.lg;
    final List<Widget> pages = <Widget>[
      profileBuilder?.call(context) ?? SignalStudioProfilePage(toasts: toaster),
      const ShowcaseDashboard(),
      reelsBuilder?.call(context) ?? SignalStudioReelsPage(toasts: toaster),
    ];

    return DefaultTextStyle(
      style: ElText.styleOf(context, ElType.body, color: theme.foreground),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const ElPageGlow(),
          ElSafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    compact ? el(4) : el(5),
                    el(3),
                    compact ? el(4) : el(5),
                    el(3),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: compact ? ElContainers.md : ElWidths.page,
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
                        maxWidth: ElWidths.page,
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
              left: el(0),
              right: el(0),
              bottom: el(0),
              child: ElSafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(el(5), 0, el(5), el(3)),
                  child: _DestinationNavigation(
                    compact: true,
                    destination: destination,
                    onChanged: onDestinationChanged,
                  ),
                ),
              ),
            ),
          Positioned.fill(child: ElToaster(controller: toaster)),
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
    final Widget identity = ElButton(
      key: const Key('showcase-header-profile'),
      variant: ElButtonVariant.ghost,
      size: ElButtonSize.sm,
      padding: compact
          ? EdgeInsets.only(
              left: el(4) - ElWidths.hairline,
              right: ElButton.paddingXFor(ElButtonSize.sm),
            )
          : null,
      label: 'Open Ari Rocha profile',
      onPressed: () => onDestinationChanged(ShowcaseDestination.profile),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ElAvatar(
            key: Key('showcase-header-avatar'),
            fallback: 'AR',
            image: AssetImage('assets/imgs/sample-card.png'),
            size: ElAvatarSize.sm,
          ),
          SizedBox(width: el(2)),
          ElText('Ari Rocha', ElType.nav),
        ],
      ),
    );

    final Widget controls = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (onOpenDesignSystem case final VoidCallback openDocs) ...<Widget>[
          ElButton(
            variant: ElButtonVariant.outline,
            size: compact ? ElButtonSize.icon : ElButtonSize.sm,
            label: 'Back to design system',
            onPressed: openDocs,
            child: compact
                ? ElIcon.lucide(ElLucide.arrowLeft, size: ElIconSize.sm)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ElIcon.lucide(ElLucide.arrowLeft, size: ElIconSize.sm),
                      SizedBox(width: ElButton.gapFor(ElButtonSize.sm)),
                      ElText('System', ElComponentType.buttonLabel),
                    ],
                  ),
          ),
          SizedBox(width: el(2)),
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
          SizedBox(width: el(2)),
          controls,
        ],
      );
    }

    return Row(
      children: <Widget>[
        identity,
        SizedBox(width: el(2)),
        Expanded(
          child: _DestinationNavigation(
            compact: false,
            destination: destination,
            onChanged: onDestinationChanged,
          ),
        ),
        SizedBox(width: el(3)),
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
    ({ShowcaseDestination destination, String label, ElLucideGlyph glyph})
  >
  _items =
      <({ShowcaseDestination destination, String label, ElLucideGlyph glyph})>[
        (
          destination: ShowcaseDestination.profile,
          label: 'Profile',
          glyph: ElLucide.userRound,
        ),
        (
          destination: ShowcaseDestination.dashboard,
          label: 'Dashboard',
          glyph: ElLucide.layoutDashboard,
        ),
        (
          destination: ShowcaseDestination.reels,
          label: 'Reels',
          glyph: ElLucide.clapperboard,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return ElGlassPanelClear(
        key: const Key('showcase-compact-dock'),
        radius: BorderRadius.circular(ElRadii.xl3),
        padding: EdgeInsets.all(el(2)),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final ElThemeData theme = ElTheme.of(context);
            final double slotWidth = constraints.maxWidth / _items.length;
            return FocusTraversalGroup(
              policy: WidgetOrderTraversalPolicy(),
              child: ElSlidingPillGroup(
                key: const Key('showcase-destination-pill-group'),
                activeIndex: destination.index,
                pill: ElMachineSurface(
                  key: const Key('showcase-destination-pill'),
                  spec: ElShadows.chip,
                  radius: BorderRadius.circular(ElRadii.lg),
                  fill: theme.secondary,
                  child: const SizedBox.expand(),
                ),
                children: <Widget>[
                  for (final ({
                        ShowcaseDestination destination,
                        String label,
                        ElLucideGlyph glyph,
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
                ElLucideGlyph glyph,
              })
              item
              in _items)
            Expanded(child: _destinationButton(item)),
        ],
      ),
    );
    return ElCard(children: <Widget>[ElCardContent(child: destinations)]);
  }

  Widget _destinationButton(
    ({ShowcaseDestination destination, String label, ElLucideGlyph glyph}) item,
  ) {
    final bool selected = item.destination == destination;
    return Semantics(
      selected: selected,
      child: ElButton(
        variant: compact
            ? ElButtonVariant.ghost
            : selected
            ? ElButtonVariant.secondary
            : ElButtonVariant.ghost,
        size: ElButtonSize.md,
        autoHeight: compact,
        radius: compact ? BorderRadius.circular(ElRadii.lg) : null,
        padding: compact
            ? EdgeInsets.symmetric(horizontal: el(2), vertical: el(2))
            : null,
        label: item.label,
        onPressed: () => onChanged(item.destination),
        child: compact
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ElIcon.lucide(item.glyph, size: ElIconSize.lg),
                  SizedBox(height: el(1)),
                  ElText(item.label, ElComponentType.buttonLabelSm),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ElIcon.lucide(item.glyph, size: ElIconSize.sm),
                  SizedBox(width: ElButton.gapFor(ElButtonSize.md)),
                  ElText(item.label, ElComponentType.buttonLabel),
                ],
              ),
      ),
    );
  }
}
