/// Signal Studio's adaptive product shell.
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
  final ThemeController _theme = ThemeController();

  @override
  void dispose() {
    _theme.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget app = ThemeScope(
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
  final ToastController _toasts = ToastController();
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
  final ToastController toaster;
  final VoidCallback? onOpenDesignSystem;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final bool compact = MediaQuery.sizeOf(context).width < Breakpoints.lg;
    final List<Widget> pages = <Widget>[
      profileBuilder?.call(context) ?? SignalStudioProfilePage(toasts: toaster),
      const ShowcaseDashboard(),
      reelsBuilder?.call(context) ?? SignalStudioReelsPage(toasts: toaster),
    ];

    return DefaultTextStyle(
      style: StyledText.styleOf(
        context,
        TextStyles.body,
        color: theme.foreground,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const BackgroundEffect(),
          SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    compact ? space(4) : space(5),
                    space(3),
                    compact ? space(4) : space(5),
                    space(3),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: compact ? Containers.md : LayoutWidths.page,
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
                        maxWidth: LayoutWidths.page,
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
              left: space(0),
              right: space(0),
              bottom: space(0),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(space(5), 0, space(5), space(3)),
                  child: _DestinationNavigation(
                    compact: true,
                    destination: destination,
                    onChanged: onDestinationChanged,
                  ),
                ),
              ),
            ),
          Positioned.fill(child: Toaster(controller: toaster)),
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
    final Widget identity = Button(
      key: const Key('showcase-header-profile'),
      variant: ButtonVariant.ghost,
      size: ButtonSize.sm,
      padding: compact
          ? EdgeInsets.only(
              left: space(4) - BorderWidths.hairline,
              right: Button.paddingXFor(ButtonSize.sm),
            )
          : null,
      label: 'Open Ari Rocha profile',
      onPressed: () => onDestinationChanged(ShowcaseDestination.profile),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Avatar(
            key: Key('showcase-header-avatar'),
            fallback: 'AR',
            image: AssetImage('assets/imgs/sample-card.png'),
            size: AvatarSize.sm,
          ),
          SizedBox(width: space(2)),
          StyledText('Ari Rocha', TextStyles.nav),
        ],
      ),
    );

    final Widget controls = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (onOpenDesignSystem case final VoidCallback openDocs) ...<Widget>[
          Button(
            variant: ButtonVariant.outline,
            size: compact ? ButtonSize.icon : ButtonSize.sm,
            label: 'Back to design system',
            onPressed: openDocs,
            child: compact
                ? Icon.lucide(Lucide.arrowLeft, size: IconSize.sm)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon.lucide(Lucide.arrowLeft, size: IconSize.sm),
                      SizedBox(width: Button.gapFor(ButtonSize.sm)),
                      StyledText('System', TextStyles.buttonLabel),
                    ],
                  ),
          ),
          SizedBox(width: space(2)),
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
          SizedBox(width: space(2)),
          controls,
        ],
      );
    }

    return Row(
      children: <Widget>[
        identity,
        SizedBox(width: space(2)),
        Expanded(
          child: _DestinationNavigation(
            compact: false,
            destination: destination,
            onChanged: onDestinationChanged,
          ),
        ),
        SizedBox(width: space(3)),
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
    ({ShowcaseDestination destination, String label, LucideGlyph glyph})
  >
  _items =
      <({ShowcaseDestination destination, String label, LucideGlyph glyph})>[
        (
          destination: ShowcaseDestination.profile,
          label: 'Profile',
          glyph: Lucide.userRound,
        ),
        (
          destination: ShowcaseDestination.dashboard,
          label: 'Dashboard',
          glyph: Lucide.layoutDashboard,
        ),
        (
          destination: ShowcaseDestination.reels,
          label: 'Reels',
          glyph: Lucide.clapperboard,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Glass(
        variant: GlassVariant.navigation,
        key: const Key('showcase-compact-dock'),
        radius: BorderRadius.circular(Radii.xl3),
        padding: EdgeInsets.all(space(2)),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final ThemeTokens theme = ThemeScope.of(context);
            final double slotWidth = constraints.maxWidth / _items.length;
            return FocusTraversalGroup(
              policy: WidgetOrderTraversalPolicy(),
              child: ActiveIndicator(
                key: const Key('showcase-destination-pill-group'),
                activeIndex: destination.index,
                indicator: Surface(
                  key: const Key('showcase-destination-pill'),
                  spec: Shadows.compactControl,
                  radius: BorderRadius.circular(Radii.lg),
                  fill: theme.secondary,
                  child: const SizedBox.expand(),
                ),
                children: <Widget>[
                  for (final ({
                        ShowcaseDestination destination,
                        String label,
                        LucideGlyph glyph,
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
                LucideGlyph glyph,
              })
              item
              in _items)
            Expanded(child: _destinationButton(item)),
        ],
      ),
    );
    return Card(children: <Widget>[CardContent(child: destinations)]);
  }

  Widget _destinationButton(
    ({ShowcaseDestination destination, String label, LucideGlyph glyph}) item,
  ) {
    final bool selected = item.destination == destination;
    return Semantics(
      selected: selected,
      child: Button(
        variant: compact
            ? ButtonVariant.ghost
            : selected
            ? ButtonVariant.secondary
            : ButtonVariant.ghost,
        size: ButtonSize.md,
        autoHeight: compact,
        radius: compact ? BorderRadius.circular(Radii.lg) : null,
        padding: compact
            ? EdgeInsets.symmetric(horizontal: space(2), vertical: space(2))
            : null,
        label: item.label,
        onPressed: () => onChanged(item.destination),
        child: compact
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon.lucide(item.glyph, size: IconSize.lg),
                  SizedBox(height: space(1)),
                  StyledText(item.label, TextStyles.buttonLabelSm),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon.lucide(item.glyph, size: IconSize.sm),
                  SizedBox(width: Button.gapFor(ButtonSize.md)),
                  StyledText(item.label, TextStyles.buttonLabel),
                ],
              ),
      ),
    );
  }
}
