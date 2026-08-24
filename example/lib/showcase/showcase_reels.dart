import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import 'showcase_shell_scope.dart';
import 'showcase_share_dialog.dart';

/// A content-first, vertically paged reel viewer for the Signal Studio shell.
class SignalStudioReelsPage extends StatefulWidget {
  const SignalStudioReelsPage({super.key, required this.toasts});

  final ElToastController toasts;

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
    await Future<void>.delayed(ElDurations.slow);
    if (!mounted) return;
    setState(() => _unavailableState = _UnavailableReelState.recovered);
    widget.toasts.settle(
      toast,
      const ElToastMessage(
        title: 'Reel restored',
        description: 'Blue-hour studies is ready to watch.',
        type: ElToastType.success,
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
            : el(96);
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
  final ElToastController toasts;

  @override
  Widget build(BuildContext context) => _PortraitReelStage(
    stageKey: ValueKey<String>('reel-stage-$reelIndex'),
    semanticsLabel: 'Reel: $title',
    child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image(image: asset, fit: BoxFit.cover),
        const Positioned.fill(child: ElMediaScrim(child: SizedBox.expand())),
        if (expanded)
          const Positioned.fill(
            child: IgnorePointer(child: ElMediaScrim(child: SizedBox.expand())),
          ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: DefaultTextStyle(
              style: ElText.styleOf(
                context,
                ElType.body,
                color: ElMediaScrimTokens.foreground,
              ),
              child: Padding(
                padding: EdgeInsets.all(el(4)),
                child: ElCollapsible(
                  open: expanded,
                  trigger: _ReelTrigger(
                    reelIndex: reelIndex,
                    title: title,
                    expanded: expanded,
                    onToggleDetails: onToggleDetails,
                  ),
                  content: Padding(
                    padding: EdgeInsets.only(top: el(3)),
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
      padding: ElSafeArea.scrollPaddingOf(
        context,
        base: EdgeInsets.only(
          left: el(4),
          top: el(4),
          right: el(4),
          bottom: el(4) + dock,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ElContainers.md),
          child: Semantics(
            container: true,
            label: semanticsLabel,
            child: ElAspectRatio(
              key: stageKey,
              ratio: ElMediaRatios.portrait,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(ElRadii.xl3),
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
    final double glyph = ElButton.iconPxFor(ElButtonSize.icon);
    return Row(
      children: <Widget>[
        Expanded(
          child: ElText(
            title,
            ElType.h3,
            color: ElMediaScrimTokens.foreground,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: el(3)),
        Semantics(
          expanded: expanded,
          child: ElButton(
            size: ElButtonSize.icon,
            variant: ElButtonVariant.secondary,
            label: expanded ? 'Hide reel details' : 'Show reel details',
            onPressed: onToggleDetails,
            child: ElIconSwap(
              key: ValueKey<String>('reel-menu-icon-swap-$reelIndex'),
              activeIndex: expanded ? 1 : 0,
              window: el(5),
              cell: glyph,
              icons: const <Widget>[
                ElIcon.lucide(ElLucide.ellipsis, size: ElIconSize.sm),
                ElIcon.lucide(ElLucide.chevronUp, size: ElIconSize.sm),
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
  final ElToastController toasts;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElText(caption, ElType.small, color: ElMediaScrimTokens.foreground),
        SizedBox(height: el(2)),
        Row(
          children: <Widget>[
            const ElIcon.lucide(ElLucide.eye, size: ElIconSize.sm),
            SizedBox(width: el(2)),
            ElText(
              '$views views',
              ElType.small,
              color: ElMediaScrimTokens.foreground,
            ),
            SizedBox(width: el(3)),
            const ElIcon.lucide(ElLucide.clock, size: ElIconSize.sm),
            SizedBox(width: el(2)),
            ElText('0:24', ElType.small, color: ElMediaScrimTokens.foreground),
          ],
        ),
        SizedBox(height: el(3)),
        Row(
          children: <Widget>[
            ElAvatar(
              fallback: 'AR',
              size: ElAvatarSize.sm,
              fallbackFill: theme.secondary,
              fallbackInk: theme.actionInk,
            ),
            SizedBox(width: el(3)),
            Expanded(
              child: ElText(
                'Ari Rocha',
                ElComponentType.cardTitle,
                color: ElMediaScrimTokens.foreground,
              ),
            ),
            ElButton(
              size: ElButtonSize.sm,
              variant: following
                  ? ElButtonVariant.secondary
                  : ElButtonVariant.primary,
              onPressed: onFollow,
              child: ElText(
                following ? 'Following' : 'Follow',
                ElComponentType.buttonLabel,
              ),
            ),
          ],
        ),
        SizedBox(height: el(3)),
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
  final ElToastController toasts;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      _ReelAction(
        swapKey: ValueKey<String>('reel-like-icon-swap-$reelIndex'),
        label: liked ? 'Remove like' : 'Like reel',
        inactiveGlyph: ElLucide.heart,
        activeGlyph: ElLucide.heartPulse,
        activeTone: ElIconTone.action,
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
          glyph: ElLucide.share2,
          value: 'Share',
          onPressed: open,
        ),
      ),
      _CommentsDialog(title: title),
      _ReelAction(
        swapKey: ValueKey<String>('reel-bookmark-icon-swap-$reelIndex'),
        label: saved ? 'Remove saved reel' : 'Save reel',
        inactiveGlyph: ElLucide.bookmark,
        activeGlyph: ElLucide.bookmarkCheck,
        activeTone: ElIconTone.value,
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
  Widget build(BuildContext context) => ElDialog(
    trigger: (BuildContext context, VoidCallback open) => _ReelStaticAction(
      label: 'Open comments',
      glyph: ElLucide.messageCircle,
      value: 'Comments',
      onPressed: open,
    ),
    content: (BuildContext context, VoidCallback close) => ElDialogContent(
      onClose: close,
      children: <Widget>[
        ElDialogHeader(
          children: <Widget>[
            const ElDialogTitle('Studio conversation'),
            ElDialogDescription('Audience notes on “$title”'),
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
            ElSeparator(),
            _Comment(
              author: 'Jon Bell',
              handle: '@joninframes · 28m',
              body: 'Would love a breakdown of the lighting setup next.',
            ),
            ElSeparator(),
            _Comment(
              author: 'Leila Studio',
              handle: '@leilastudio · 41m',
              body: 'Saved this for our next process review.',
            ),
          ],
        ),
        ElDialogFooter(
          children: <Widget>[
            ElButton(
              variant: ElButtonVariant.secondary,
              onPressed: close,
              child: ElText('Close', ElComponentType.buttonLabel),
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
    padding: EdgeInsets.symmetric(vertical: el(3)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ElAvatar(fallback: author.substring(0, 1), size: ElAvatarSize.sm),
        SizedBox(width: el(3)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ElText(author, ElComponentType.cardTitle),
              ElText(handle, ElType.small),
              SizedBox(height: el(1)),
              ElText(body, ElType.body),
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
  final ElLucideGlyph inactiveGlyph;
  final ElLucideGlyph activeGlyph;
  final ElIconTone activeTone;
  final String value;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final double glyph = ElButton.iconPxFor(ElButtonSize.icon);
    final Widget control = ElButton(
      size: ElButtonSize.icon,
      variant: active ? ElButtonVariant.secondary : ElButtonVariant.ghost,
      label: label,
      onPressed: onPressed,
      child: ElIconSwap(
        key: swapKey,
        activeIndex: active ? 1 : 0,
        window: el(5),
        cell: glyph,
        icons: <Widget>[
          ElIcon.lucide(inactiveGlyph, size: ElIconSize.sm),
          ElIcon.lucide(activeGlyph, size: ElIconSize.sm, tone: activeTone),
        ],
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Semantics(toggled: active, child: control),
        SizedBox(height: el(1)),
        ElText(value, ElType.small, color: ElMediaScrimTokens.foreground),
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
  final ElLucideGlyph glyph;
  final String value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ElButton(
        size: ElButtonSize.icon,
        variant: ElButtonVariant.secondary,
        label: label,
        onPressed: onPressed,
        child: ElIcon.lucide(glyph, size: ElIconSize.sm),
      ),
      SizedBox(height: el(1)),
      ElText(value, ElType.small, color: ElMediaScrimTokens.foreground),
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
        ColoredBox(color: ElTheme.of(context).muted),
        Positioned.fill(
          child: ElMediaScrim(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(el(4)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElText(
                        'Reel unavailable.',
                        ElType.h3,
                        color: ElMediaScrimTokens.foreground,
                      ),
                    ),
                    SizedBox(width: el(3)),
                    ElButton(
                      size: ElButtonSize.sm,
                      variant: ElButtonVariant.secondary,
                      label: 'Retry reel',
                      onPressed: onRetry,
                      child: ElText('Retry', ElComponentType.buttonLabelSm),
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
        ColoredBox(color: ElTheme.of(context).muted),
        Positioned.fill(
          child: ElMediaScrim(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(el(4)),
                child: ElSkeleton(
                  key: const Key('reel-retry-title-skeleton'),
                  width: el(48),
                  height: el(7),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
