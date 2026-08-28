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

import 'showcase_shell_scope.dart';
import 'showcase_share_dialog.dart';

/// A content-first, vertically paged reel viewer for the Signal Studio shell.
class SignalStudioReelsPage extends StatefulWidget {
  const SignalStudioReelsPage({super.key, required this.toasts});

  final ToastController toasts;

  @override
  State<SignalStudioReelsPage> createState() => _SignalStudioReelsPageState();
}

class _SignalStudioReelsPageState extends State<SignalStudioReelsPage> {
  final PageController _controller = PageController();
  final Set<int> _liked = <int>{};
  final Set<int> _saved = <int>{};
  final Set<int> _expanded = <int>{};
  bool _following = false;
  _UnavailableReelState _unavailableState = _UnavailableReelState.error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _retryUnavailable() async {
    if (_unavailableState == _UnavailableReelState.loading) return;
    setState(() => _unavailableState = _UnavailableReelState.loading);
    final int toast = widget.toasts.loading(
      'Recovering reel',
      description: 'Reconnecting this cut without moving your place.',
    );
    await Future<void>.delayed(MotionDurations.slow);
    if (!mounted) return;
    setState(() => _unavailableState = _UnavailableReelState.recovered);
    widget.toasts.settle(
      toast,
      const ToastMessage(
        title: 'Reel restored',
        description: 'Blue-hour studies is ready to watch.',
        type: ToastType.success,
        promise: true,
      ),
    );
  }

  void _toggleLike(int reel) => setState(() {
    if (!_liked.add(reel)) _liked.remove(reel);
  });

  void _toggleSave(int reel) => setState(() {
    if (!_saved.add(reel)) _saved.remove(reel);
  });

  void _toggleExpanded(int reel) => setState(() {
    if (!_expanded.add(reel)) _expanded.remove(reel);
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double height = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : space(96);
        return SizedBox(
          height: height,
          child: PageView(
            controller: _controller,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              _ReelFrame(
                reelIndex: 0,
                asset: const AssetImage('assets/imgs/sample-card.png'),
                title: 'A quiet system for louder work.',
                caption:
                    'The sharpest creative routines make room for the unexpected.',
                views: '84.2K',
                expanded: _expanded.contains(0),
                liked: _liked.contains(0),
                saved: _saved.contains(0),
                following: _following,
                onFollow: () => setState(() => _following = !_following),
                onToggleDetails: () => _toggleExpanded(0),
                onLike: () => _toggleLike(0),
                onSave: () => _toggleSave(0),
                toasts: widget.toasts,
              ),
              _ReelFrame(
                reelIndex: 1,
                asset: const AssetImage('assets/imgs/sample-pack.jpg'),
                title: 'Field notes from the night desk.',
                caption:
                    'A small collection of materials, light, and late ideas.',
                views: '61.7K',
                expanded: _expanded.contains(1),
                liked: _liked.contains(1),
                saved: _saved.contains(1),
                following: _following,
                onFollow: () => setState(() => _following = !_following),
                onToggleDetails: () => _toggleExpanded(1),
                onLike: () => _toggleLike(1),
                onSave: () => _toggleSave(1),
                toasts: widget.toasts,
              ),
              switch (_unavailableState) {
                _UnavailableReelState.error => _UnavailableReel(
                  onRetry: _retryUnavailable,
                ),
                _UnavailableReelState.loading => const _RetryTitleSkeleton(),
                _UnavailableReelState.recovered => _ReelFrame(
                  reelIndex: 2,
                  asset: const AssetImage('assets/imgs/sample-pack.jpg'),
                  title: 'Blue-hour studies, back in frame.',
                  caption:
                      'Recovered material studies from the studio archive.',
                  views: '37.9K',
                  expanded: _expanded.contains(2),
                  liked: _liked.contains(2),
                  saved: _saved.contains(2),
                  following: _following,
                  onFollow: () => setState(() => _following = !_following),
                  onToggleDetails: () => _toggleExpanded(2),
                  onLike: () => _toggleLike(2),
                  onSave: () => _toggleSave(2),
                  toasts: widget.toasts,
                ),
              },
            ],
          ),
        );
      },
    );
  }
}

enum _UnavailableReelState { error, loading, recovered }

class _ReelFrame extends StatelessWidget {
  const _ReelFrame({
    required this.reelIndex,
    required this.asset,
    required this.title,
    required this.caption,
    required this.views,
    required this.expanded,
    required this.liked,
    required this.saved,
    required this.following,
    required this.onFollow,
    required this.onToggleDetails,
    required this.onLike,
    required this.onSave,
    required this.toasts,
  });

  final int reelIndex;
  final ImageProvider<Object> asset;
  final String title;
  final String caption;
  final String views;
  final bool expanded;
  final bool liked;
  final bool saved;
  final bool following;
  final VoidCallback onFollow;
  final VoidCallback onToggleDetails;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final ToastController toasts;

  @override
  Widget build(BuildContext context) => _PortraitReelStage(
    stageKey: ValueKey<String>('reel-stage-$reelIndex'),
    semanticsLabel: 'Reel: $title',
    child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image(image: asset, fit: BoxFit.cover),
        const Positioned.fill(child: MediaScrim(child: SizedBox.expand())),
        if (expanded)
          const Positioned.fill(
            child: IgnorePointer(child: MediaScrim(child: SizedBox.expand())),
          ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: DefaultTextStyle(
              style: StyledText.styleOf(
                context,
                TextStyles.body,
                color: MediaScrimTokens.foreground,
              ),
              child: Padding(
                padding: EdgeInsets.all(space(4)),
                child: Collapsible(
                  open: expanded,
                  trigger: _ReelTrigger(
                    reelIndex: reelIndex,
                    title: title,
                    expanded: expanded,
                    onToggleDetails: onToggleDetails,
                  ),
                  content: Padding(
                    padding: EdgeInsets.only(top: space(3)),
                    child: _ReelMenu(
                      reelIndex: reelIndex,
                      title: title,
                      caption: caption,
                      views: views,
                      liked: liked,
                      saved: saved,
                      following: following,
                      onFollow: onFollow,
                      onLike: onLike,
                      onSave: onSave,
                      toasts: toasts,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _PortraitReelStage extends StatelessWidget {
  const _PortraitReelStage({
    required this.stageKey,
    required this.semanticsLabel,
    required this.child,
  });

  final Key stageKey;
  final String semanticsLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double dock = ShowcaseShellScope.bottomOverlayClearanceOf(context);
    return Padding(
      padding: SafeArea.scrollPaddingOf(
        context,
        base: EdgeInsets.only(
          left: space(4),
          top: space(4),
          right: space(4),
          bottom: space(4) + dock,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Containers.md),
          child: Semantics(
            container: true,
            label: semanticsLabel,
            child: AspectRatio(
              key: stageKey,
              ratio: AspectRatios.portrait,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Radii.xl3),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReelTrigger extends StatelessWidget {
  const _ReelTrigger({
    required this.reelIndex,
    required this.title,
    required this.expanded,
    required this.onToggleDetails,
  });

  final int reelIndex;
  final String title;
  final bool expanded;
  final VoidCallback onToggleDetails;

  @override
  Widget build(BuildContext context) {
    final double glyph = Button.iconPxFor(ButtonSize.icon);
    return Row(
      children: <Widget>[
        Expanded(
          child: StyledText(
            title,
            TextStyles.h3,
            color: MediaScrimTokens.foreground,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: space(3)),
        Semantics(
          expanded: expanded,
          child: Button(
            size: ButtonSize.icon,
            variant: ButtonVariant.secondary,
            label: expanded ? 'Hide reel details' : 'Show reel details',
            onPressed: onToggleDetails,
            child: IconSwap(
              key: ValueKey<String>('reel-menu-icon-swap-$reelIndex'),
              activeIndex: expanded ? 1 : 0,
              window: space(5),
              cell: glyph,
              icons: const <Widget>[
                Icon.lucide(Lucide.ellipsis, size: IconSize.sm),
                Icon.lucide(Lucide.chevronUp, size: IconSize.sm),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReelMenu extends StatelessWidget {
  const _ReelMenu({
    required this.reelIndex,
    required this.title,
    required this.caption,
    required this.views,
    required this.liked,
    required this.saved,
    required this.following,
    required this.onFollow,
    required this.onLike,
    required this.onSave,
    required this.toasts,
  });

  final int reelIndex;
  final String title;
  final String caption;
  final String views;
  final bool liked;
  final bool saved;
  final bool following;
  final VoidCallback onFollow;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final ToastController toasts;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText(
          caption,
          TextStyles.small,
          color: MediaScrimTokens.foreground,
        ),
        SizedBox(height: space(2)),
        Row(
          children: <Widget>[
            const Icon.lucide(Lucide.eye, size: IconSize.sm),
            SizedBox(width: space(2)),
            StyledText(
              '$views views',
              TextStyles.small,
              color: MediaScrimTokens.foreground,
            ),
            SizedBox(width: space(3)),
            const Icon.lucide(Lucide.clock, size: IconSize.sm),
            SizedBox(width: space(2)),
            StyledText(
              '0:24',
              TextStyles.small,
              color: MediaScrimTokens.foreground,
            ),
          ],
        ),
        SizedBox(height: space(3)),
        Row(
          children: <Widget>[
            Avatar(
              fallback: 'AR',
              size: AvatarSize.sm,
              fallbackFill: theme.secondary,
              fallbackInk: theme.actionText,
            ),
            SizedBox(width: space(3)),
            Expanded(
              child: StyledText(
                'Ari Rocha',
                TextStyles.cardTitle,
                color: MediaScrimTokens.foreground,
              ),
            ),
            Button(
              size: ButtonSize.sm,
              variant: following
                  ? ButtonVariant.secondary
                  : ButtonVariant.primary,
              onPressed: onFollow,
              child: StyledText(
                following ? 'Following' : 'Follow',
                TextStyles.buttonLabel,
              ),
            ),
          ],
        ),
        SizedBox(height: space(3)),
        _ReelActions(
          reelIndex: reelIndex,
          title: title,
          liked: liked,
          saved: saved,
          onLike: onLike,
          onSave: onSave,
          toasts: toasts,
        ),
      ],
    );
  }
}

class _ReelActions extends StatelessWidget {
  const _ReelActions({
    required this.reelIndex,
    required this.title,
    required this.liked,
    required this.saved,
    required this.onLike,
    required this.onSave,
    required this.toasts,
  });

  final int reelIndex;
  final String title;
  final bool liked;
  final bool saved;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final ToastController toasts;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      _ReelAction(
        swapKey: ValueKey<String>('reel-like-icon-swap-$reelIndex'),
        label: liked ? 'Remove like' : 'Like reel',
        inactiveGlyph: Lucide.heart,
        activeGlyph: Lucide.heartPulse,
        activeTone: IconTone.action,
        value: 'Like',
        active: liked,
        onPressed: onLike,
      ),
      ShowcaseShareDialog(
        dialogTitle: 'Share this reel',
        description:
            'Copy the public link or prepare “$title” for a social post.',
        subject: title,
        link: 'https://signal.studio/share?reel=${Uri.encodeComponent(title)}',
        toasts: toasts,
        trigger: (BuildContext context, VoidCallback open) => _ReelStaticAction(
          label: 'Share reel',
          glyph: Lucide.share2,
          value: 'Share',
          onPressed: open,
        ),
      ),
      _CommentsDialog(title: title),
      _ReelAction(
        swapKey: ValueKey<String>('reel-bookmark-icon-swap-$reelIndex'),
        label: saved ? 'Remove saved reel' : 'Save reel',
        inactiveGlyph: Lucide.bookmark,
        activeGlyph: Lucide.bookmarkCheck,
        activeTone: IconTone.value,
        value: 'Bookmark',
        active: saved,
        onPressed: onSave,
      ),
    ],
  );
}

class _CommentsDialog extends StatelessWidget {
  const _CommentsDialog({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Dialog(
    trigger: (BuildContext context, VoidCallback open) => _ReelStaticAction(
      label: 'Open comments',
      glyph: Lucide.messageCircle,
      value: 'Comments',
      onPressed: open,
    ),
    content: (BuildContext context, VoidCallback close) => DialogContent(
      onClose: close,
      children: <Widget>[
        DialogHeader(
          children: <Widget>[
            const DialogTitle('Studio conversation'),
            DialogDescription('Audience notes on “$title”'),
          ],
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _Comment(
              author: 'Mina Chen',
              handle: '@minamakes · 12m',
              body: 'The pacing makes the final reveal feel earned.',
            ),
            Separator(),
            _Comment(
              author: 'Jon Bell',
              handle: '@joninframes · 28m',
              body: 'Would love a breakdown of the lighting setup next.',
            ),
            Separator(),
            _Comment(
              author: 'Leila Studio',
              handle: '@leilastudio · 41m',
              body: 'Saved this for our next process review.',
            ),
          ],
        ),
        DialogFooter(
          children: <Widget>[
            Button(
              variant: ButtonVariant.secondary,
              onPressed: close,
              child: StyledText('Close', TextStyles.buttonLabel),
            ),
          ],
        ),
      ],
    ),
  );
}

class _Comment extends StatelessWidget {
  const _Comment({
    required this.author,
    required this.handle,
    required this.body,
  });

  final String author;
  final String handle;
  final String body;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: space(3)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Avatar(fallback: author.substring(0, 1), size: AvatarSize.sm),
        SizedBox(width: space(3)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StyledText(author, TextStyles.cardTitle),
              StyledText(handle, TextStyles.small),
              SizedBox(height: space(1)),
              StyledText(body, TextStyles.body),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ReelAction extends StatelessWidget {
  const _ReelAction({
    required this.swapKey,
    required this.label,
    required this.inactiveGlyph,
    required this.activeGlyph,
    required this.activeTone,
    required this.value,
    required this.active,
    required this.onPressed,
  });

  final Key swapKey;
  final String label;
  final LucideGlyph inactiveGlyph;
  final LucideGlyph activeGlyph;
  final IconTone activeTone;
  final String value;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final double glyph = Button.iconPxFor(ButtonSize.icon);
    final Widget control = Button(
      size: ButtonSize.icon,
      variant: active ? ButtonVariant.secondary : ButtonVariant.ghost,
      label: label,
      onPressed: onPressed,
      child: IconSwap(
        key: swapKey,
        activeIndex: active ? 1 : 0,
        window: space(5),
        cell: glyph,
        icons: <Widget>[
          Icon.lucide(inactiveGlyph, size: IconSize.sm),
          Icon.lucide(activeGlyph, size: IconSize.sm, tone: activeTone),
        ],
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Semantics(toggled: active, child: control),
        SizedBox(height: space(1)),
        StyledText(value, TextStyles.small, color: MediaScrimTokens.foreground),
      ],
    );
  }
}

class _ReelStaticAction extends StatelessWidget {
  const _ReelStaticAction({
    required this.label,
    required this.glyph,
    required this.value,
    required this.onPressed,
  });

  final String label;
  final LucideGlyph glyph;
  final String value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Button(
        size: ButtonSize.icon,
        variant: ButtonVariant.secondary,
        label: label,
        onPressed: onPressed,
        child: Icon.lucide(glyph, size: IconSize.sm),
      ),
      SizedBox(height: space(1)),
      StyledText(value, TextStyles.small, color: MediaScrimTokens.foreground),
    ],
  );
}

class _UnavailableReel extends StatelessWidget {
  const _UnavailableReel({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => _PortraitReelStage(
    stageKey: const Key('reel-stage-unavailable'),
    semanticsLabel: 'Unavailable reel',
    child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ColoredBox(color: ThemeScope.of(context).muted),
        Positioned.fill(
          child: MediaScrim(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(space(4)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: StyledText(
                        'Reel unavailable.',
                        TextStyles.h3,
                        color: MediaScrimTokens.foreground,
                      ),
                    ),
                    SizedBox(width: space(3)),
                    Button(
                      size: ButtonSize.sm,
                      variant: ButtonVariant.secondary,
                      label: 'Retry reel',
                      onPressed: onRetry,
                      child: StyledText('Retry', TextStyles.buttonLabelSm),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _RetryTitleSkeleton extends StatelessWidget {
  const _RetryTitleSkeleton();

  @override
  Widget build(BuildContext context) => _PortraitReelStage(
    stageKey: const Key('reel-stage-loading'),
    semanticsLabel: 'Recovering reel',
    child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ColoredBox(color: ThemeScope.of(context).muted),
        Positioned.fill(
          child: MediaScrim(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(space(4)),
                child: Skeleton(
                  key: const Key('reel-retry-title-skeleton'),
                  width: space(48),
                  height: space(7),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
