/// `components/agent/parts/attachments.tsx` — files, going both ways.
///
/// One component set draws what the user is about to send and what the agent
/// has produced, because they are the same object — see `agent_core.dart`. The
/// only difference on screen is the remove button, which exists in the
/// composer's tray and nowhere else.
///
/// [DsAgentAttachmentCard] is a thin wrapper over `attachment.dart`, the
/// vendored primitive: it composes [DsAttachment], [DsAttachmentMedia],
/// [DsAttachmentContent] and friends rather than drawing its own row. The one
/// thing the primitive cannot express is the **delivery badge**, which is agent
/// semantics rather than file semantics: whether the file's bytes reached the
/// model or only its filename did. An attachment whose bytes reached the model
/// and one whose filename did are visually distinct, and the second says so on
/// hover. A paperclip that means two different things depending on the file
/// type is how a user ends up asking an agent about a chart it was never shown.
///
/// `DsAgentAttachment` carries no upload lifecycle — no `error`, no
/// `uploading`, nothing between "picked" and "gone" — so [DsAttachmentState] is
/// always `done` here. The primitive's other two states are real and shown
/// honestly on `/design-system/components/base/chat#attachment`, against data
/// this domain type cannot produce.
///
/// ## Recorded divergences
///
///  1. **`ImageAttachment`'s well is drawn here, not by [DsAttachmentMedia].**
///     The reference does the same thing by a different route: it *does* mount
///     `AttachmentMedia`, but outside any `Attachment` root and under
///     `aspect-auto w-full rounded-none`, which deletes the three declarations
///     that make the primitive a 40px square. The port's [DsAttachmentMedia]
///     reads its well size from [DsAttachmentScope] and has no override for
///     any of the three, so the large treatment composes the same box locally
///     — `relative flex w-full items-center justify-center overflow-hidden
///     bg-muted`, measured 1028×320 — plus the same [DsAttachmentTrigger] over
///     the same [DsModalPortal]. Nothing in `attachment.dart` is forked; only
///     the three deleted declarations are not asked for.
///  2. **Image bytes arrive through [DsAgentAttachmentList.imageBuilder].**
///     `DsAgentAttachment.url` is a string, and the one specimen in the corpus
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
DsLucideGlyph dsAgentAttachmentGlyph(DsAgentAttachmentKind kind) =>
    switch (kind) {
      DsAgentAttachmentKind.image => DsLucide.image,
      DsAgentAttachmentKind.document => DsLucide.fileText,
      DsAgentAttachmentKind.data => DsLucide.sheet,
      DsAgentAttachmentKind.code => DsLucide.fileCode,
      DsAgentAttachmentKind.audio => DsLucide.music2,
      DsAgentAttachmentKind.other => DsLucide.file,
    };

/// Video is not a `DsAgentAttachmentKind` — the domain classifies it `other` —
/// so the lightbox asks the MIME type directly rather than widening the model.
bool dsAgentAttachmentIsVideo(DsAgentAttachment attachment) =>
    attachment.mime.startsWith('video/');

/* ── Delivery badge ──────────────────────────────────────────────────────── */

/// `DeliveryBadge` — *Read*, *Name only*, or nothing at all.
///
/// Nothing at all for `produced`, since delivery does not apply to a file the
/// agent made itself.
class DsAgentDeliveryBadge extends StatelessWidget {
  const DsAgentDeliveryBadge({super.key, required this.attachment});

  /// `gap-1` between the glyph and the words on the `reference` badge.
  static double get gap => ds(1);

  /// `max-w-xs` on the tooltip that carries `delivery.reason` — which is what
  /// `TooltipContent` already caps itself at, so the class is a no-op and the
  /// port asks for nothing.
  static double get tooltipMaxWidth => DsContainers.xs;

  final DsAgentAttachment attachment;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final DsAgentDelivery? delivery = attachment.delivery;
    if (delivery == null ||
        delivery.sent == DsAgentDeliverySent.produced) {
      return const SizedBox.shrink();
    }

    if (delivery.sent == DsAgentDeliverySent.content) {
      return Semantics(
        tooltip: 'The agent can read this file',
        child: DsText('Read', DsType.caption, color: theme.successInk),
      );
    }

    return DsTooltip(
      label: delivery.reason ?? '',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const DsIcon.lucide(
            DsLucide.info,
            size: DsIconSize.xs,
            tone: DsIconTone.warning,
          ),
          SizedBox(width: gap),
          DsText('Name only', DsType.caption, color: theme.warningInk),
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
class DsAgentAttachmentCard extends StatelessWidget {
  const DsAgentAttachmentCard({
    super.key,
    required this.attachment,
    this.onRemove,
    this.onDownload,
    this.imageBuilder,
  });

  /// `gap-2` between the size string and the delivery badge.
  static double get descriptionGap => ds(2);

  final DsAgentAttachment attachment;
  final void Function(String id)? onRemove;

  /// Where the *Saving …* toast is raised from — the primitive's own seam.
  final void Function(String name)? onDownload;

  /// Renders the thumbnail for an image with a url. See the library note.
  final Widget Function(BuildContext, DsAgentAttachment)? imageBuilder;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final bool isImage =
        attachment.kind == DsAgentAttachmentKind.image && attachment.url != null;
    final bool isPreviewable = attachment.url != null &&
        (attachment.kind == DsAgentAttachmentKind.image ||
            dsAgentAttachmentIsVideo(attachment));
    final String meta = attachment.size > 0
        ? dsFormatBytes(attachment.size)
        : attachment.mime;
    final Widget? thumbnail =
        isImage ? imageBuilder?.call(context, attachment) : null;

    return DsAttachment(
      media: DsAttachmentMedia(
        variant: isImage
            ? DsAttachmentMediaVariant.image
            : DsAttachmentMediaVariant.icon,
        preview: isPreviewable ? thumbnail : null,
        previewName: attachment.name,
        previewDescription: meta,
        child: thumbnail ??
            DsIcon.lucide(
              dsAgentAttachmentGlyph(attachment.kind),
              sizePx: DsAttachmentMedia.glyphFor(
                DsAttachmentSize.md,
                DsAttachmentOrientation.horizontal,
              ),
              tone: DsIconTone.muted,
            ),
      ),
      content: DsAttachmentContent(
        title: DsAttachmentTitle(attachment.name),
        // `<AttachmentDescription className="flex items-center gap-2">` — the
        // description element *is* the flex row, so its own `mt-0.5` wraps both
        // the size string and the badge rather than the string alone.
        description: Padding(
          padding: EdgeInsets.only(top: DsAttachmentDescription.topGap),
          child: Row(
            children: <Widget>[
              Flexible(
                child: DsText(
                  meta,
                  DsComponentType.attachmentDescription,
                  color: theme.mutedForeground,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
              SizedBox(width: descriptionGap),
              DsAgentDeliveryBadge(attachment: attachment),
            ],
          ),
        ),
      ),
      actions: DsAttachmentActions(
        children: <Widget>[
          if (attachment.url != null && onRemove == null)
            DsAttachmentAction(
              downloadName: attachment.name,
              onDownload: onDownload,
            ),
          if (onRemove != null)
            DsAttachmentAction(
              label: 'Remove ${attachment.name}',
              onPressed: () => onRemove!(attachment.id),
              child: DsIcon.lucide(
                DsLucide.x,
                sizePx: DsButton.iconPxFor(DsButtonSize.iconXs),
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
  static double get transcriptCap => ds(80);
  static double get trayCap => ds(32);

  /// `px-3 py-2` on the caption, and `gap-2` inside it.
  static double get captionPadX => ds(3);
  static double get captionPadY => ds(2);
  static double get captionGap => ds(2);

  /// `size-7` on the caption's own control.
  static double get controlSize => ds(7);

  final DsAgentAttachment attachment;
  final void Function(String id)? onRemove;
  final bool compact;
  final void Function(String name)? onDownload;
  final Widget Function(BuildContext, DsAgentAttachment)? imageBuilder;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final double cap = compact ? trayCap : transcriptCap;
    final String meta = attachment.size > 0
        ? dsFormatBytes(attachment.size)
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
        borderRadius: BorderRadius.circular(DsRadii.md),
        border: Border.all(color: theme.border, width: DsWidths.hairline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DsWidths.hairline),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DsRadii.md - DsWidths.hairline),
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
                      child: DsModalPortal(
                        transition: (
                          BuildContext context,
                          Animation<double> animation,
                          Widget child,
                        ) =>
                            DsJellyTransition(
                          animation: animation,
                          child: child,
                        ),
                        trigger: (BuildContext context, VoidCallback open) =>
                            DsAttachmentTrigger(
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
                      child: DsText(
                        attachment.name,
                        DsType.caption,
                        color: theme.mutedForeground,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    SizedBox(width: captionGap),
                    DsAgentDeliveryBadge(attachment: attachment),
                    if (attachment.url != null && onRemove == null) ...<Widget>[
                      SizedBox(width: captionGap),
                      SizedBox(
                        width: controlSize,
                        height: controlSize,
                        child: DsAttachmentAction(
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
                        child: DsButton(
                          variant: DsButtonVariant.ghost,
                          size: DsButtonSize.icon,
                          label: 'Remove ${attachment.name}',
                          onPressed: () => onRemove!(attachment.id),
                          child: DsIcon.lucide(
                            DsLucide.x,
                            sizePx: DsButton.iconPxFor(DsButtonSize.sm),
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
    final DsThemeData theme = DsTheme.of(context);
    final double maxHeight = MediaQuery.sizeOf(context).height *
        DsAttachmentMedia.previewMaxHeightFraction;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: DsAttachmentMedia.previewMaxWidth),
      child: Semantics(
        container: true,
        label: description == null ? name : '$name. $description',
        child: Container(
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius: BorderRadius.circular(DsRadii.xl),
            boxShadow: DsShadowSpec(<DsShadowLayer>[
              DsShadowLayer(
                0,
                0,
                0,
                DsWidths.hairline,
                (DsThemeData t) => t.foreground
                    .withValues(alpha: DsAttachmentMedia.previewRingAlpha),
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
                top: DsAttachmentMedia.previewCloseInset,
                end: DsAttachmentMedia.previewCloseInset,
                child: DsButton(
                  variant: DsButtonVariant.secondary,
                  size: DsButtonSize.icon,
                  label: 'Close',
                  onPressed: onClose,
                  child: DsIcon.lucide(
                    DsLucide.x,
                    sizePx: DsButton.iconPxFor(DsButtonSize.icon),
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
class DsAgentAttachmentList extends StatelessWidget {
  const DsAgentAttachmentList({
    super.key,
    required this.attachments,
    this.onRemove,
    this.compact = false,
    this.imageBuilder,
    this.onDownload,
  });

  /// `space-y-2` between the two groups, and `gap-2` inside each.
  static double get gap => ds(2);

  final List<DsAgentAttachment> attachments;

  /// Set by the composer tray, which is the only place a file can be taken
  /// back.
  final void Function(String id)? onRemove;

  /// Set by the composer tray, where previews must stay small.
  final bool compact;

  /// See the library note — the seam an image's bytes arrive through.
  final Widget Function(BuildContext, DsAgentAttachment)? imageBuilder;

  /// Where the *Saving …* toast is raised from.
  final void Function(String name)? onDownload;

  bool _isImage(DsAgentAttachment a) =>
      a.kind == DsAgentAttachmentKind.image && a.url != null;

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) return const SizedBox.shrink();

    final List<DsAgentAttachment> images =
        attachments.where(_isImage).toList(growable: false);
    final List<DsAgentAttachment> rest =
        attachments.where((DsAgentAttachment a) => !_isImage(a)).toList(
              growable: false,
            );
    final bool wide = MediaQuery.sizeOf(context).width >= DsBreakpoints.sm;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (images.isNotEmpty)
          _Grid(
            columns: wide && images.length > 1 ? 2 : 1,
            gap: gap,
            children: <Widget>[
              for (final DsAgentAttachment attachment in images)
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
              for (final DsAgentAttachment attachment in rest)
                DsAgentAttachmentCard(
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
