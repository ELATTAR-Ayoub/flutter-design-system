/// `components/agent/parts/attachments.tsx` — files, going both ways.
///
/// One component set draws what the user is about to send and what the agent
/// has produced, because they are the same object — see `agent_core.dart`. The
/// only difference on screen is the remove button, which exists in the
/// composer's tray and nowhere else.
///
/// [ElAgentAttachmentCard] is a thin wrapper over `attachment.dart`, the
/// vendored primitive: it composes [ElAttachment], [ElAttachmentMedia],
/// [ElAttachmentContent] and friends rather than drawing its own row. The one
/// thing the primitive cannot express is the **delivery badge**, which is agent
/// semantics rather than file semantics: whether the file's bytes reached the
/// model or only its filename did. An attachment whose bytes reached the model
/// and one whose filename did are visually distinct, and the second says so on
/// hover. A paperclip that means two different things depending on the file
/// type is how a user ends up asking an agent about a chart it was never shown.
///
/// `ElAgentAttachment` carries no upload lifecycle — no `error`, no
/// `uploading`, nothing between "picked" and "gone" — so [ElAttachmentState] is
/// always `done` here. The primitive's other two states are real and shown
/// honestly on `/design-system/components/base/chat#attachment`, against data
/// this domain type cannot produce.
///
/// ## Recorded divergences
///
///  1. **`ImageAttachment`'s well is drawn here, not by [ElAttachmentMedia].**
///     The reference does the same thing by a different route: it *does* mount
///     `AttachmentMedia`, but outside any `Attachment` root and under
///     `aspect-auto w-full rounded-none`, which deletes the three declarations
///     that make the primitive a 40px square. The port's [ElAttachmentMedia]
///     reads its well size from [ElAttachmentScope] and has no override for
///     any of the three, so the large treatment composes the same box locally
///     — `relative flex w-full items-center justify-center overflow-hidden
///     bg-muted`, measured 1028×320 — plus the same [ElAttachmentTrigger] over
///     the same [ElModalPortal]. Nothing in `attachment.dart` is forked; only
///     the three deleted declarations are not asked for.
///  2. **Image bytes arrive through [ElAgentAttachmentList.imageBuilder].**
///     `ElAgentAttachment.url` is a string, and the one specimen in the corpus
///     is a `data:image/svg+xml` URI, which Flutter has no decoder for and
///     which no third-party dependency may be added to read. The hook is the
///     seam: a caller that holds real bytes hands back an `Image`, and the page
///     that holds a vector hands back a painter. With no builder the well is a
///     `--muted` plate at the same height, so geometry is unaffected either
///     way.
library;

import 'package:flutter/widgets.dart';

import '../foundation/shadows.dart';
import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../theme_scope.dart';
import 'agent_core.dart';
import 'attachment.dart';
import 'button.dart';
import 'dialog.dart';
import 'icon.dart';
import 'icon_paths.g.dart';
import 'tooltip.dart';

/// `ICON` — one glyph per `AttachmentKind`.
ElLucideGlyph elAgentAttachmentGlyph(ElAgentAttachmentKind kind) =>
    switch (kind) {
      ElAgentAttachmentKind.image => ElLucide.image,
      ElAgentAttachmentKind.document => ElLucide.fileText,
      ElAgentAttachmentKind.data => ElLucide.sheet,
      ElAgentAttachmentKind.code => ElLucide.fileCode,
      ElAgentAttachmentKind.audio => ElLucide.music2,
      ElAgentAttachmentKind.other => ElLucide.file,
    };

/// Video is not a `ElAgentAttachmentKind` — the domain classifies it `other` —
/// so the lightbox asks the MIME type directly rather than widening the model.
bool elAgentAttachmentIsVideo(ElAgentAttachment attachment) =>
    attachment.mime.startsWith('video/');

/* ── Delivery badge ──────────────────────────────────────────────────────── */

/// `DeliveryBadge` — *Read*, *Name only*, or nothing at all.
///
/// Nothing at all for `produced`, since delivery does not apply to a file the
/// agent made itself.
class ElAgentDeliveryBadge extends StatelessWidget {
  const ElAgentDeliveryBadge({super.key, required this.attachment});

  /// `gap-1` between the glyph and the words on the `reference` badge.
  static double get gap => el(1);

  /// `max-w-xs` on the tooltip that carries `delivery.reason` — which is what
  /// `TooltipContent` already caps itself at, so the class is a no-op and the
  /// port asks for nothing.
  static double get tooltipMaxWidth => ElContainers.xs;

  final ElAgentAttachment attachment;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final ElAgentDelivery? delivery = attachment.delivery;
    if (delivery == null || delivery.sent == ElAgentDeliverySent.produced) {
      return const SizedBox.shrink();
    }

    if (delivery.sent == ElAgentDeliverySent.content) {
      return Semantics(
        tooltip: 'The agent can read this file',
        child: ElText('Read', ElType.caption, color: theme.successInk),
      );
    }

    return ElTooltip(
      label: delivery.reason ?? '',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ElIcon.lucide(
            ElLucide.info,
            size: ElIconSize.xs,
            tone: ElIconTone.warning,
          ),
          SizedBox(width: gap),
          ElText('Name only', ElType.caption, color: theme.warningInk),
        ],
      ),
    );
  }
}

/* ── One file ────────────────────────────────────────────────────────────── */

/// `AttachmentCard` — one file, drawn on the vendored `Attachment`.
///
/// Shows a download action when the file has a url and no [onRemove], a remove
/// action when [onRemove] is passed — never both.
class ElAgentAttachmentCard extends StatelessWidget {
  const ElAgentAttachmentCard({
    super.key,
    required this.attachment,
    this.onRemove,
    this.onDownload,
    this.imageBuilder,
  });

  /// `gap-2` between the size string and the delivery badge.
  static double get descriptionGap => el(2);

  final ElAgentAttachment attachment;
  final void Function(String id)? onRemove;

  /// Where the *Saving …* toast is raised from — the primitive's own seam.
  final void Function(String name)? onDownload;

  /// Renders the thumbnail for an image with a url. See the library note.
  final Widget Function(BuildContext, ElAgentAttachment)? imageBuilder;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final bool isImage =
        attachment.kind == ElAgentAttachmentKind.image &&
        attachment.url != null;
    final bool isPreviewable =
        attachment.url != null &&
        (attachment.kind == ElAgentAttachmentKind.image ||
            elAgentAttachmentIsVideo(attachment));
    final String meta = attachment.size > 0
        ? elFormatBytes(attachment.size)
        : attachment.mime;
    final Widget? thumbnail = isImage
        ? imageBuilder?.call(context, attachment)
        : null;

    return ElAttachment(
      media: ElAttachmentMedia(
        variant: isImage
            ? ElAttachmentMediaVariant.image
            : ElAttachmentMediaVariant.icon,
        preview: isPreviewable ? thumbnail : null,
        previewName: attachment.name,
        previewDescription: meta,
        child:
            thumbnail ??
            ElIcon.lucide(
              elAgentAttachmentGlyph(attachment.kind),
              sizePx: ElAttachmentMedia.glyphFor(
                ElAttachmentSize.md,
                ElAttachmentOrientation.horizontal,
              ),
              tone: ElIconTone.muted,
            ),
      ),
      content: ElAttachmentContent(
        title: ElAttachmentTitle(attachment.name),
        // `<AttachmentDescription className="flex items-center gap-2">` — the
        // description element *is* the flex row, so its own `mt-0.5` wraps both
        // the size string and the badge rather than the string alone.
        description: Padding(
          padding: EdgeInsets.only(top: ElAttachmentDescription.topGap),
          child: Row(
            children: <Widget>[
              Flexible(
                child: ElText(
                  meta,
                  ElComponentType.attachmentDescription,
                  color: theme.mutedForeground,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
              SizedBox(width: descriptionGap),
              ElAgentDeliveryBadge(attachment: attachment),
            ],
          ),
        ),
      ),
      actions: ElAttachmentActions(
        children: <Widget>[
          if (attachment.url != null && onRemove == null)
            ElAttachmentAction(
              downloadName: attachment.name,
              onDownload: onDownload,
            ),
          if (onRemove != null)
            ElAttachmentAction(
              label: 'Remove ${attachment.name}',
              onPressed: () => onRemove!(attachment.id),
              child: ElIcon.lucide(
                ElLucide.x,
                sizePx: ElButton.iconPxFor(ElButtonSize.iconXs),
              ),
            ),
        ],
      ),
    );
  }
}

/* ── An image, actually shown ────────────────────────────────────────────── */

/// The large-image treatment, module-private in the reference and here.
///
/// `ui/attachment.tsx` has no large-image treatment — its `AttachmentMedia` is
/// a 40px well, icon-sized, because the primitive is built for a file row, not
/// a picture. A photo reduced to a 40px chip beside its filename is not a
/// photo: the entire reason someone attaches a screenshot is that looking at it
/// beats describing it, and that stays true after the message is sent. So
/// images keep this separate treatment in the transcript — rendered at a
/// readable size, capped in height so a tall screenshot cannot push the
/// conversation off screen, and clickable to open full size.
class _ImageAttachment extends StatelessWidget {
  const _ImageAttachment({
    required this.attachment,
    this.onRemove,
    this.compact = false,
    this.onDownload,
    this.imageBuilder,
  });

  /// `max-h-32` in the composer tray, `max-h-80` in the transcript.
  ///
  /// Shorter in the tray than in the transcript. Before sending, the image is a
  /// confirmation that the right file is attached and it must not push the
  /// composer off the screen; afterwards it is content, and content deserves
  /// the room.
  static double get transcriptCap => el(80);
  static double get trayCap => el(32);

  /// `px-3 py-2` on the caption, and `gap-2` inside it.
  static double get captionPadX => el(3);
  static double get captionPadY => el(2);
  static double get captionGap => el(2);

  /// `size-7` on the caption's own control.
  static double get controlSize => el(7);

  final ElAgentAttachment attachment;
  final void Function(String id)? onRemove;
  final bool compact;
  final void Function(String name)? onDownload;
  final Widget Function(BuildContext, ElAgentAttachment)? imageBuilder;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final double cap = compact ? trayCap : transcriptCap;
    final String meta = attachment.size > 0
        ? elFormatBytes(attachment.size)
        : attachment.mime;

    final Widget? picture = imageBuilder?.call(context, attachment);

    // `relative flex w-full items-center justify-center overflow-hidden
    // bg-muted` — the primitive's base list with `aspect-square`, `w-10` and
    // `rounded-lg` taken back off it.
    final Widget well = ColoredBox(
      color: theme.muted,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: cap),
        child: SizedBox(
          width: double.infinity,
          height: picture == null ? cap : null,
          child: picture == null
              ? const SizedBox.shrink()
              : FittedBox(fit: BoxFit.contain, child: picture),
        ),
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(ElRadii.md),
        border: Border.all(color: theme.border, width: ElWidths.hairline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ElWidths.hairline),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ElRadii.md - ElWidths.hairline),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Opening media in a new tab hands the reader to the browser's
              // own image viewer and loses the conversation. A dialog keeps
              // them here and is reversible, which is what §5's table says a
              // dialog is for — an alert dialog would be wrong, there is
              // nothing here to decide.
              if (attachment.url == null || picture == null)
                well
              else
                Stack(
                  children: <Widget>[
                    well,
                    Positioned.fill(
                      child: ElModalPortal(
                        transition:
                            (
                              BuildContext context,
                              Animation<double> animation,
                              Widget child,
                            ) => ElJellyTransition(
                              animation: animation,
                              child: child,
                            ),
                        trigger: (BuildContext context, VoidCallback open) =>
                            ElAttachmentTrigger(
                              onPressed: open,
                              cursor: SystemMouseCursors.zoomIn,
                              label: 'Open ${attachment.name} full size',
                            ),
                        content: (BuildContext context, VoidCallback close) =>
                            _ImagePreviewPanel(
                              name: attachment.name,
                              description: meta,
                              onClose: close,
                              child: picture,
                            ),
                      ),
                    ),
                  ],
                ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: captionPadX,
                  vertical: captionPadY,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElText(
                        attachment.name,
                        ElType.caption,
                        color: theme.mutedForeground,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    SizedBox(width: captionGap),
                    ElAgentDeliveryBadge(attachment: attachment),
                    if (attachment.url != null && onRemove == null) ...<Widget>[
                      SizedBox(width: captionGap),
                      SizedBox(
                        width: controlSize,
                        height: controlSize,
                        child: ElAttachmentAction(
                          downloadName: attachment.name,
                          onDownload: onDownload,
                        ),
                      ),
                    ],
                    if (onRemove != null) ...<Widget>[
                      SizedBox(width: captionGap),
                      SizedBox(
                        width: controlSize,
                        height: controlSize,
                        child: ElButton(
                          variant: ElButtonVariant.ghost,
                          size: ElButtonSize.icon,
                          label: 'Remove ${attachment.name}',
                          onPressed: () => onRemove!(attachment.id),
                          child: ElIcon.lucide(
                            ElLucide.x,
                            sizePx: ElButton.iconPxFor(ElButtonSize.sm),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The lightbox panel — `max-w-3xl overflow-hidden p-0`, a `secondary` close.
///
/// Composed rather than reused because `attachment.dart` keeps its own copy
/// module-private; every number below is read off that file's public statics,
/// so the two cannot drift.
class _ImagePreviewPanel extends StatelessWidget {
  const _ImagePreviewPanel({
    required this.name,
    required this.description,
    required this.onClose,
    required this.child,
  });

  final String name;
  final String? description;
  final VoidCallback onClose;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final double maxHeight =
        MediaQuery.sizeOf(context).height *
        ElAttachmentMedia.previewMaxHeightFraction;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: ElAttachmentMedia.previewMaxWidth),
      child: Semantics(
        container: true,
        label: description == null ? name : '$name. $description',
        child: Container(
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius: BorderRadius.circular(ElRadii.xl),
            boxShadow: ElShadowSpec(<ElShadowLayer>[
              ElShadowLayer(
                0,
                0,
                0,
                ElWidths.hairline,
                (ElThemeData t) => t.foreground.withValues(
                  alpha: ElAttachmentMedia.previewRingAlpha,
                ),
              ),
            ]).outerShadows(theme),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: ColoredBox(
                  color: theme.muted,
                  child: SizedBox(
                    width: double.infinity,
                    child: FittedBox(fit: BoxFit.contain, child: child),
                  ),
                ),
              ),
              PositionedDirectional(
                top: ElAttachmentMedia.previewCloseInset,
                end: ElAttachmentMedia.previewCloseInset,
                child: ElButton(
                  variant: ElButtonVariant.secondary,
                  size: ElButtonSize.icon,
                  label: 'Close',
                  onPressed: onClose,
                  child: ElIcon.lucide(
                    ElLucide.x,
                    sizePx: ElButton.iconPxFor(ElButtonSize.icon),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ── The list ────────────────────────────────────────────────────────────── */

/// `AttachmentList` — the files under a message, or above the composer.
///
/// Images and everything else are laid out separately rather than forced into
/// one grid: a picture wants width, and a spreadsheet wants a row.
class ElAgentAttachmentList extends StatelessWidget {
  const ElAgentAttachmentList({
    super.key,
    required this.attachments,
    this.onRemove,
    this.compact = false,
    this.imageBuilder,
    this.onDownload,
  });

  /// `space-y-2` between the two groups, and `gap-2` inside each.
  static double get gap => el(2);

  final List<ElAgentAttachment> attachments;

  /// Set by the composer tray, which is the only place a file can be taken
  /// back.
  final void Function(String id)? onRemove;

  /// Set by the composer tray, where previews must stay small.
  final bool compact;

  /// See the library note — the seam an image's bytes arrive through.
  final Widget Function(BuildContext, ElAgentAttachment)? imageBuilder;

  /// Where the *Saving …* toast is raised from.
  final void Function(String name)? onDownload;

  bool _isImage(ElAgentAttachment a) =>
      a.kind == ElAgentAttachmentKind.image && a.url != null;

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) return const SizedBox.shrink();

    final List<ElAgentAttachment> images = attachments
        .where(_isImage)
        .toList(growable: false);
    final List<ElAgentAttachment> rest = attachments
        .where((ElAgentAttachment a) => !_isImage(a))
        .toList(growable: false);
    final bool wide = MediaQuery.sizeOf(context).width >= ElBreakpoints.sm;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (images.isNotEmpty)
          _Grid(
            columns: wide && images.length > 1 ? 2 : 1,
            gap: gap,
            children: <Widget>[
              for (final ElAgentAttachment attachment in images)
                _ImageAttachment(
                  attachment: attachment,
                  onRemove: onRemove,
                  compact: compact,
                  onDownload: onDownload,
                  imageBuilder: imageBuilder,
                ),
            ],
          ),
        if (images.isNotEmpty && rest.isNotEmpty) SizedBox(height: gap),
        if (rest.isNotEmpty)
          _Grid(
            columns: wide ? 2 : 1,
            gap: gap,
            children: <Widget>[
              for (final ElAgentAttachment attachment in rest)
                ElAgentAttachmentCard(
                  attachment: attachment,
                  onRemove: onRemove,
                  onDownload: onDownload,
                  imageBuilder: imageBuilder,
                ),
            ],
          ),
      ],
    );
  }
}

/// `grid gap-2 sm:grid-cols-2` — an equal-column grid whose rows are as tall as
/// their tallest cell, which is what a CSS grid row does.
class _Grid extends StatelessWidget {
  const _Grid({
    required this.columns,
    required this.gap,
    required this.children,
  });

  final int columns;
  final double gap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final List<List<Widget>> rows = <List<Widget>>[];
    for (int i = 0; i < children.length; i += columns) {
      rows.add(
        children.sublist(
          i,
          i + columns > children.length ? children.length : i + columns,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int r = 0; r < rows.length; r += 1)
          Padding(
            padding: EdgeInsets.only(bottom: r == rows.length - 1 ? 0 : gap),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  for (int c = 0; c < columns; c += 1) ...<Widget>[
                    if (c > 0) SizedBox(width: gap),
                    Expanded(
                      child: c < rows[r].length
                          ? rows[r][c]
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
