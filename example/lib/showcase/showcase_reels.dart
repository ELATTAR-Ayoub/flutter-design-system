import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import 'showcase_shell_scope.dart';
import 'showcase_share_dialog.dart';

/// A content-first, vertically paged reel viewer for the Signal Studio shell.
class SignalStudioReelsPage extends StatefulWidget {
  const SignalStudioReelsPage({super.key, required this.toasts});

  final DsToastController toasts;

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
    await Future<void>.delayed(DsDurations.slow);
    if (!mounted) return;
    setState(() => _unavailableState = _UnavailableReelState.recovered);
    widget.toasts.settle(
      toast,
      const DsToastMessage(
        title: 'Reel restored',
        description: 'Blue-hour studies is ready to watch.',
        type: DsToastType.success,
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
            : ds(96);
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
  final DsToastController toasts;

  @override
  Widget build(BuildContext context) => _PortraitReelStage(
    stageKey: ValueKey<String>('reel-stage-$reelIndex'),
    semanticsLabel: 'Reel: $title',
    child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image(image: asset, fit: BoxFit.cover),
        const Positioned.fill(child: DsMediaScrim(child: SizedBox.expand())),
        if (expanded)
          const Positioned.fill(
            child: IgnorePointer(child: DsMediaScrim(child: SizedBox.expand())),
          ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: DefaultTextStyle(
              style: DsText.styleOf(
                context,
                DsType.body,
                color: DsMediaScrimTokens.foreground,
              ),
              child: Padding(
                padding: EdgeInsets.all(ds(4)),
                child: DsCollapsible(
                  open: expanded,
                  trigger: _ReelTrigger(
                    reelIndex: reelIndex,
                    title: title,
                    expanded: expanded,
                    onToggleDetails: onToggleDetails,
                  ),
                  content: Padding(
                    padding: EdgeInsets.only(top: ds(3)),
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
      padding: DsSafeArea.scrollPaddingOf(
        context,
        base: EdgeInsets.only(
          left: ds(4),
          top: ds(4),
          right: ds(4),
          bottom: ds(4) + dock,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DsContainers.md),
          child: Semantics(
            container: true,
            label: semanticsLabel,
            child: DsAspectRatio(
              key: stageKey,
              ratio: DsMediaRatios.portrait,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(DsRadii.xl3),
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
    final double glyph = DsButton.iconPxFor(DsButtonSize.icon);
    return Row(
      children: <Widget>[
        Expanded(
          child: DsText(
            title,
            DsType.h3,
            color: DsMediaScrimTokens.foreground,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: ds(3)),
        Semantics(
          expanded: expanded,
          child: DsButton(
            size: DsButtonSize.icon,
            variant: DsButtonVariant.secondary,
            label: expanded ? 'Hide reel details' : 'Show reel details',
            onPressed: onToggleDetails,
            child: DsIconSwap(
              key: ValueKey<String>('reel-menu-icon-swap-$reelIndex'),
              activeIndex: expanded ? 1 : 0,
              window: ds(5),
              cell: glyph,
              icons: const <Widget>[
                DsIcon.lucide(DsLucide.ellipsis, size: DsIconSize.sm),
                DsIcon.lucide(DsLucide.chevronUp, size: DsIconSize.sm),
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
  final DsToastController toasts;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DsText(caption, DsType.small, color: DsMediaScrimTokens.foreground),
        SizedBox(height: ds(2)),
        Row(
          children: <Widget>[
            const DsIcon.lucide(DsLucide.eye, size: DsIconSize.sm),
            SizedBox(width: ds(2)),
            DsText(
              '$views views',
              DsType.small,
              color: DsMediaScrimTokens.foreground,
            ),
            SizedBox(width: ds(3)),
            const DsIcon.lucide(DsLucide.clock, size: DsIconSize.sm),
            SizedBox(width: ds(2)),
            DsText('0:24', DsType.small, color: DsMediaScrimTokens.foreground),
          ],
        ),
        SizedBox(height: ds(3)),
        Row(
          children: <Widget>[
            DsAvatar(
              fallback: 'AR',
              size: DsAvatarSize.sm,
              fallbackFill: theme.secondary,
              fallbackInk: theme.actionInk,
            ),
            SizedBox(width: ds(3)),
            Expanded(
              child: DsText(
                'Ari Rocha',
                DsComponentType.cardTitle,
                color: DsMediaScrimTokens.foreground,
              ),
            ),
            DsButton(
              size: DsButtonSize.sm,
              variant: following
                  ? DsButtonVariant.secondary
                  : DsButtonVariant.primary,
              onPressed: onFollow,
              child: DsText(
                following ? 'Following' : 'Follow',
                DsComponentType.buttonLabel,
              ),
            ),
          ],
        ),
        SizedBox(height: ds(3)),
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
  final DsToastController toasts;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      _ReelAction(
        swapKey: ValueKey<String>('reel-like-icon-swap-$reelIndex'),
        label: liked ? 'Remove like' : 'Like reel',
        inactiveGlyph: DsLucide.heart,
        activeGlyph: DsLucide.heartPulse,
        activeTone: DsIconTone.action,
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
          glyph: DsLucide.share2,
          value: 'Share',
          onPressed: open,
        ),
      ),
      _CommentsDialog(title: title),
      _ReelAction(
        swapKey: ValueKey<String>('reel-bookmark-icon-swap-$reelIndex'),
        label: saved ? 'Remove saved reel' : 'Save reel',
        inactiveGlyph: DsLucide.bookmark,
        activeGlyph: DsLucide.bookmarkCheck,
        activeTone: DsIconTone.value,
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
  Widget build(BuildContext context) => DsDialog(
    trigger: (BuildContext context, VoidCallback open) => _ReelStaticAction(
      label: 'Open comments',
      glyph: DsLucide.messageCircle,
      value: 'Comments',
      onPressed: open,
    ),
    content: (BuildContext context, VoidCallback close) => DsDialogContent(
      onClose: close,
      children: <Widget>[
        DsDialogHeader(
          children: <Widget>[
            const DsDialogTitle('Studio conversation'),
            DsDialogDescription('Audience notes on “$title”'),
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
            DsSeparator(),
            _Comment(
              author: 'Jon Bell',
              handle: '@joninframes · 28m',
              body: 'Would love a breakdown of the lighting setup next.',
            ),
            DsSeparator(),
            _Comment(
              author: 'Leila Studio',
              handle: '@leilastudio · 41m',
              body: 'Saved this for our next process review.',
            ),
          ],
        ),
        DsDialogFooter(
          children: <Widget>[
            DsButton(
              variant: DsButtonVariant.secondary,
              onPressed: close,
              child: DsText('Close', DsComponentType.buttonLabel),
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
    padding: EdgeInsets.symmetric(vertical: ds(3)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsAvatar(fallback: author.substring(0, 1), size: DsAvatarSize.sm),
        SizedBox(width: ds(3)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(author, DsComponentType.cardTitle),
              DsText(handle, DsType.small),
              SizedBox(height: ds(1)),
              DsText(body, DsType.body),
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
  final DsLucideGlyph inactiveGlyph;
  final DsLucideGlyph activeGlyph;
  final DsIconTone activeTone;
  final String value;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final double glyph = DsButton.iconPxFor(DsButtonSize.icon);
    final Widget control = DsButton(
      size: DsButtonSize.icon,
      variant: active ? DsButtonVariant.secondary : DsButtonVariant.ghost,
      label: label,
      onPressed: onPressed,
      child: DsIconSwap(
        key: swapKey,
        activeIndex: active ? 1 : 0,
        window: ds(5),
        cell: glyph,
        icons: <Widget>[
          DsIcon.lucide(inactiveGlyph, size: DsIconSize.sm),
          DsIcon.lucide(activeGlyph, size: DsIconSize.sm, tone: activeTone),
        ],
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Semantics(toggled: active, child: control),
        SizedBox(height: ds(1)),
        DsText(value, DsType.small, color: DsMediaScrimTokens.foreground),
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
  final DsLucideGlyph glyph;
  final String value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      DsButton(
        size: DsButtonSize.icon,
        variant: DsButtonVariant.secondary,
        label: label,
        onPressed: onPressed,
        child: DsIcon.lucide(glyph, size: DsIconSize.sm),
      ),
      SizedBox(height: ds(1)),
      DsText(value, DsType.small, color: DsMediaScrimTokens.foreground),
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
        ColoredBox(color: DsTheme.of(context).muted),
        Positioned.fill(
          child: DsMediaScrim(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(ds(4)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: DsText(
                        'Reel unavailable.',
                        DsType.h3,
                        color: DsMediaScrimTokens.foreground,
                      ),
                    ),
                    SizedBox(width: ds(3)),
                    DsButton(
                      size: DsButtonSize.sm,
                      variant: DsButtonVariant.secondary,
                      label: 'Retry reel',
                      onPressed: onRetry,
                      child: DsText('Retry', DsComponentType.buttonLabelSm),
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
        ColoredBox(color: DsTheme.of(context).muted),
        Positioned.fill(
          child: DsMediaScrim(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(ds(4)),
                child: DsSkeleton(
                  key: const Key('reel-retry-title-skeleton'),
                  width: ds(48),
                  height: ds(7),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
