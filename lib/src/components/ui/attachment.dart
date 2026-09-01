/// `components/ui/attachment.tsx` — a file, in a conversation.
///
/// Five states, because a file being uploaded, a file being read and a file
/// that failed are three different things and a spinner alone says none of
/// them. The one primitive of this family the agent console actually imports.
///
/// ## Measured
///
/// Every number is a computed style read off
/// `/design-system/components/base/chat` at 1440×900 on 2026-08-16
/// (`scratchpad/ba2-chat-inv.js`, `ba2-chat-media.js`).
///
/// | | `default` | `sm` | `xs` |
/// |---|---|---|---|
/// | padding | **8** | **6** | **4** |
/// | gap | **8** | **10** | **6** |
/// | radius | 16 | 16 | **12** |
/// | root type | 13px | 12px | 12px |
/// | media well | 40 | 32 | 28 |
/// | media radius | 12 | 12 | **10** |
/// | glyph | 16 | 16 | **14** |
///
/// Horizontal is `min-w-40` (160) and `items-center`; vertical is `w-24`
/// widening to **`w-30` (120)** once it carries content, and its glyph is
/// **24px** — which is larger than an `sm` vertical's own 32px well.
///
/// ## Four class lists that never fire, and one that fires larger than it looks
///
/// 1. **`px-2.5 py-2` / `px-2 py-1.5` / `px-1.5 py-1` are dead.** They are
///    `has-data-[slot=attachment-content]:` rules, and the later
///    `has-data-[slot=attachment-media]:p-*` rule wins the whole shorthand at
///    equal specificity. Every specimen on the page has a media well, so the
///    padding is uniform on all four sides — measured 8 / 6 / 4, not 10×8.
/// 2. **`has-[>a,>button]:hover:bg-muted/50` is unreachable.** Probed on all
///    eighteen attachments: not one has a direct `<a>` or `<button>` child —
///    the trigger is nested inside the media well, one level too deep.
/// 3. **`group-data-[orientation=vertical]:*:data-[slot=spinner]:size-6!` never
///    matches.** `icon.tsx` destructures `{icon,size,tone,label,className}` and
///    spreads nothing, so `spinner.tsx`'s `data-slot="spinner"` is dropped
///    before it reaches the DOM — the same drop that makes the spinner silent
///    (ruling B9). Measured: the two vertical spinner cells render **16px**
///    beside three sibling cells rendering **24px**, inside identical wells.
/// 4. **`group-data-[orientation=vertical]:w-full` loses on `sm` and `xs`.**
///    The size rules are written after it, so a vertical `sm` well is 32px wide
///    in a 120px tile while a vertical `default` well is the full 102.
///
/// ## `AttachmentAction` with an `href`
///
/// The save control carries both of §5's signals: the glyph rolls to a check
/// through [IconSwap] for **1600ms**, and a toast reports the outcome. It
/// says *Saving*, never *Saved* — a plain `download` anchor gives the page no
/// completion event.
///
/// ## The media preview dialog
///
/// `AttachmentMedia`'s `src` makes the well expandable, and the reference opens
/// a `Dialog` over the dimmed page rather than a new tab, *"which would hand
/// the reader to the browser's own viewer and lose whatever they were
/// reading"*. The port composes it on [OverlayPortal] — the dialogs family's
/// own portal, overlay and jelly transition — rather than on `DialogContent`,
/// because this panel is neither of that component's two variants. Measured
/// open at 1440×900: **768 × 630** (`max-w-3xl`), fixed and centred, `p-0`,
/// 16px radius on `--card` under a single 1px `foreground/10` ring with no
/// elevation, entering on `yuki-jelly-in` at 420ms; the image is `w-full
/// object-contain` capped at `70vh` over a `--muted` letterbox; the close
/// control is a **`secondary`** 40px icon button at `top-3 right-3`; the header
/// is `sr-only`.
library;

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;
import 'package:flutter/widgets.dart'
    as flutter
    show AspectRatio, ScrollPosition;

import '../../design_system/foundation/motion.dart';
import '../../design_system/foundation/shadows.dart';
import '../../design_system/foundation/spacing.dart';
import '../../design_system/foundation/theme.dart';
import '../../design_system/foundation/typography.dart';
import '../../design_system/foundation/theme_scope.dart';
import './button.dart';
import './dialog.dart';
import './icon.dart';
import './icon_paths.g.dart';
import './icon_swap.dart';

/// `state` — five, and each one says something the others do not.
enum AttachmentState {
  /// A dashed border. Nothing chosen yet.
  idle,

  /// Spinner in the well, the title on a shimmer.
  uploading,

  /// Sent, being read. Same treatment as [uploading].
  processing,

  /// `border-destructive/30`, and the media well turns
  /// `bg-destructive/10 text-destructive-ink`.
  error,

  /// The resting state, and the default.
  done,
}

/// `size` — *"pick by how much room the tray has, not by importance."*
enum AttachmentSize {
  /// 13px text, 40px well. Named [md] because `default` is a Dart keyword.
  md,

  /// 12px, 32px.
  sm,

  /// 12px, 28px, and a tighter radius.
  xs;

  /// The key the `cva` spells this size with.
  String get label => this == AttachmentSize.md ? 'default' : name;
}

/// `orientation` — a row with a 160px floor, or a 96px tile that widens to 120
/// once it carries a title.
enum AttachmentOrientation { horizontal, vertical }

/// `AttachmentMedia variant`.
enum AttachmentMediaVariant {
  /// The default.
  icon,

  /// Expects a real image child and holds it at 60% opacity until the state is
  /// `done` or `idle` — *"which is what makes an upload look like it is still
  /// arriving."*
  image,
}

/// What an [Attachment] publishes to the slots inside it — the port of
/// `group/attachment` plus its three `data-*` attributes.
class AttachmentScope extends InheritedWidget {
  const AttachmentScope({
    super.key,
    required this.state,
    required this.size,
    required this.orientation,
    required super.child,
  });

  final AttachmentState state;
  final AttachmentSize size;
  final AttachmentOrientation orientation;

  static AttachmentScope of(BuildContext context) {
    final AttachmentScope? found = context
        .dependOnInheritedWidgetOfExactType<AttachmentScope>();
    assert(found != null, 'No Attachment above this slot.');
    return found!;
  }

  @override
  bool updateShouldNotify(AttachmentScope old) =>
      old.state != state || old.size != size || old.orientation != orientation;
}

/// The card.
class Attachment extends StatefulWidget {
  const Attachment({
    super.key,
    required this.media,
    this.content,
    this.actions,
    this.state = AttachmentState.done,
    this.size = AttachmentSize.md,
    this.orientation = AttachmentOrientation.horizontal,
  });

  /// `p-2` / `p-1.5` / `p-1` — the rule that wins; see the library note.
  static double paddingFor(AttachmentSize size) => switch (size) {
    AttachmentSize.md => space(2),
    AttachmentSize.sm => space(1.5),
    AttachmentSize.xs => space(1),
  };

  /// `gap-2` / `gap-2.5` / `gap-1.5`. `sm`'s is the widest of the three, which
  /// is the reference's own arrangement.
  static double gapFor(AttachmentSize size) => switch (size) {
    AttachmentSize.md => space(2),
    AttachmentSize.sm => space(2.5),
    AttachmentSize.xs => space(1.5),
  };

  /// `rounded-xl`, `rounded-lg` on `xs`.
  static double radiusFor(AttachmentSize size) =>
      size == AttachmentSize.xs ? Radii.lg : Radii.xl;

  /// `min-w-40` — the horizontal floor.
  static double get horizontalMinWidth => space(40);

  /// `w-24`, widening to `w-30` once there is content.
  static double get verticalWidth => space(24);
  static double get verticalWidthWithContent => space(30);

  /// `focus-within:ring-1 ring-ring/50`.
  static const double focusRingAlpha = 0.50;

  /// `data-[state=error]:border-destructive/30`.
  static const double errorBorderAlpha = 0.30;

  final Widget media;
  final Widget? content;
  final Widget? actions;

  final AttachmentState state;
  final AttachmentSize size;
  final AttachmentOrientation orientation;

  @override
  State<Attachment> createState() => _AttachmentState();
}

class _AttachmentState extends State<Attachment> {
  bool _focusWithin = false;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final bool vertical = widget.orientation == AttachmentOrientation.vertical;
    final double gap = Attachment.gapFor(widget.size);

    final List<Widget> slots = <Widget>[
      widget.media,
      if (widget.content != null) widget.content!,
      // In a vertical card the actions cluster is absolutely positioned and
      // leaves the flow; in a horizontal one it is a plain relative sibling.
      if (widget.actions != null && !vertical) widget.actions!,
    ];

    Widget row = vertical
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0; i < slots.length; i++) ...<Widget>[
                if (i > 0) SizedBox(height: gap),
                slots[i],
              ],
            ],
          )
        // Sizing this the way `flex-1` reads on a `w-fit` card needs the row
        // to shrink-wrap its content unless `min-w-40` forces it wider — only
        // then does the content column have slack to absorb. A bare
        // `Expanded` cannot do that on its own: it needs a bounded width, and
        // a card inside a `Wrap` gets none.
        //
        // Stock `IntrinsicWidth` looks like the fix, and mostly is: when the
        // incoming width is already bounded (the ordinary case — an
        // `Expanded` grid cell) it passes that width straight through with
        // no intrinsic query at all. But it does not extend the same courtesy
        // to *height* — whenever the incoming height is unbounded (any
        // scrollable list, which is most of them) it substitutes a tight
        // height computed from `getMaxIntrinsicHeight`, a second, separate
        // measurement of the very same content the real layout pass is about
        // to measure again. The two do not always agree — an `Expanded`
        // inside the intrinsic pass gets its natural preferred width rather
        // than the width it is actually laid out at, and at large text
        // scales that reports a shorter box than the real one — and when
        // they disagree the row is locked into a height too short for what
        // it goes on to paint, which reads as a horizontal overflow once the
        // wrapped content has nowhere left to go. [_WidthOnlyIntrinsic] is
        // the same width fix with that second measurement removed: it bounds
        // the width exactly as `IntrinsicWidth` does and lets the height
        // constraint pass through untouched, so there is only ever the one
        // real layout pass to agree with.
        : _WidthOnlyIntrinsic(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < slots.length; i++) ...<Widget>[
                  if (i > 0) SizedBox(width: gap),
                  if (slots[i] == widget.content)
                    // `flex-1 min-w-0` — the content column takes the slack
                    // and is allowed to shrink so `truncate` has something to
                    // bite.
                    Expanded(child: slots[i])
                  else
                    slots[i],
                ],
              ],
            ),
          );

    row = Padding(
      padding: EdgeInsets.all(Attachment.paddingFor(widget.size)),
      child: row,
    );

    if (widget.actions != null && vertical) {
      // `absolute top-3 right-3` against the card.
      row = Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          row,
          PositionedDirectional(
            top: space(3),
            end: space(3),
            child: widget.actions!,
          ),
        ],
      );
    }

    final Color borderColor = widget.state == AttachmentState.error
        ? theme.destructive.withValues(alpha: Attachment.errorBorderAlpha)
        : theme.border;

    Widget card = _DashedBorderBox(
      radius: Attachment.radiusFor(widget.size),
      color: borderColor,
      // `data-[state=idle]:border-dashed`.
      dashed: widget.state == AttachmentState.idle,
      fill: theme.card,
      ring: _focusWithin
          ? theme.ring.withValues(alpha: Attachment.focusRingAlpha)
          : null,
      child: row,
    );

    // `w-fit max-w-full shrink-0` plus the orientation's own sizing.
    card = vertical
        ? SizedBox(
            width: widget.content == null
                ? Attachment.verticalWidth
                : Attachment.verticalWidthWithContent,
            child: card,
          )
        : ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: Attachment.horizontalMinWidth,
            ),
            child: card,
          );

    return AttachmentScope(
      state: widget.state,
      size: widget.size,
      orientation: widget.orientation,
      child: DefaultTextStyle.merge(
        // `text-sm` / `text-xs` on the root.
        style: StyledText.styleOf(
          context,
          widget.size == AttachmentSize.md ? TextStyles.body : TextStyles.small,
          color: theme.cardForeground,
        ),
        child: Focus(
          canRequestFocus: false,
          skipTraversal: true,
          onFocusChange: (bool has) => setState(() => _focusWithin = has),
          child: card,
        ),
      ),
    );
  }
}

/// `IntrinsicWidth`, minus the intrinsic *height* pass it also does on the
/// side — see the call site's comment for the mismatch that causes.
///
/// Bounds the width exactly as `IntrinsicWidth` does: a finite incoming
/// `maxWidth` passes straight through, and only an unbounded one falls back
/// to `getMaxIntrinsicWidth`. The height constraint is never touched — no
/// second, intrinsic-only measurement of the child ever runs, so there is
/// nothing for the real layout pass to disagree with.
class _WidthOnlyIntrinsic extends SingleChildRenderObjectWidget {
  const _WidthOnlyIntrinsic({required Widget super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderWidthOnlyIntrinsic();
}

class _RenderWidthOnlyIntrinsic extends RenderProxyBox {
  @override
  void performLayout() {
    final RenderBox? kid = child;
    if (kid == null) {
      size = constraints.smallest;
      return;
    }
    final double width = constraints.hasBoundedWidth
        ? constraints.maxWidth
        : kid.getMaxIntrinsicWidth(constraints.maxHeight);
    kid.layout(
      constraints.copyWith(minWidth: width, maxWidth: width),
      parentUsesSize: true,
    );
    size = constraints.constrain(kid.size);
  }
}

/// The card frame: a fill, a 1px border that may be dashed, and an optional
/// `ring-1`.
///
/// The dash is painted rather than composed: CSS's `border-style: dashed` on a
/// rounded rect is a stroked rounded rect with a dash pattern, which is exactly
/// what a single `drawPath` on a [Path.combine]-free rounded-rect path with a
/// [ui.PathMetric] walk produces. Nothing here blurs anything, and the solid
/// case is a plain [Border] so it stays on Skia's own fast path.
class _DashedBorderBox extends StatelessWidget {
  const _DashedBorderBox({
    required this.radius,
    required this.color,
    required this.dashed,
    required this.fill,
    required this.ring,
    required this.child,
  });

  /// Chrome's own dash rhythm for a 1px border, measured against the rendered
  /// idle card: a 3px dash on a 3px gap.
  static const double dash = 3;
  static const double gap = 3;

  final double radius;
  final Color color;
  final bool dashed;
  final Color fill;
  final Color? ring;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final BorderRadius r = BorderRadius.circular(radius);

    Widget box = DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: r,
        border: dashed
            ? null
            : Border.all(color: color, width: BorderWidths.hairline),
        // `focus-within:ring-1` — a 1px spread-only layer, described through
        // the foundation's own spec rather than written as a shadow.
        boxShadow: ring == null
            ? null
            : ShadowStyle(<ShadowLayer>[
                ShadowLayer(
                  0,
                  0,
                  0,
                  BorderWidths.hairline,
                  (ThemeTokens _) => ring!,
                ),
              ]).outerShadows(ThemeScope.of(context)),
      ),
      child: Padding(
        // `box-sizing: border-box` — the border is paid for out of the card's
        // own box, so the content starts a pixel in either way.
        padding: const EdgeInsets.all(BorderWidths.hairline),
        child: child,
      ),
    );

    if (!dashed) return box;

    return CustomPaint(
      foregroundPainter: _DashPainter(color: color, radius: radius),
      child: box,
    );
  }
}

class _DashPainter extends CustomPainter {
  const _DashPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    // The border box, inset by half the stroke so the 1px line lands on the
    // same pixels a solid `Border.all` would paint.
    final double half = BorderWidths.hairline / 2;
    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            half,
            half,
            size.width - 2 * half,
            size.height - 2 * half,
          ),
          Radius.circular(radius - half),
        ),
      );

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = BorderWidths.hairline;

    for (final ui.PathMetric metric in path.computeMetrics()) {
      double at = 0;
      while (at < metric.length) {
        final double end = math.min(at + _DashedBorderBox.dash, metric.length);
        canvas.drawPath(metric.extractPath(at, end), paint);
        at = end + _DashedBorderBox.gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashPainter old) =>
      old.color != color || old.radius != radius;
}

/// `AttachmentMedia` — the thumbnail well.
class AttachmentMedia extends StatelessWidget {
  const AttachmentMedia({
    super.key,
    required this.child,
    this.variant = AttachmentMediaVariant.icon,
    this.preview,
    this.previewName,
    this.previewDescription,
  });

  /// `w-10` / `w-8` / `w-7`, and `w-full` on a vertical `default`.
  static double? wellFor(AttachmentSize size) => switch (size) {
    AttachmentSize.md => space(10),
    AttachmentSize.sm => space(8),
    AttachmentSize.xs => space(7),
  };

  /// `rounded-lg`, `rounded-md` on `xs`.
  static double radiusFor(AttachmentSize size) =>
      size == AttachmentSize.xs ? Radii.md : Radii.lg;

  /// `[&_svg:not([class*='size-'])]:size-4`, `size-6` in a vertical card,
  /// `size-3.5` on `xs` — and `xs` is written last, so it wins even in a
  /// vertical card.
  static double glyphFor(
    AttachmentSize size,
    AttachmentOrientation orientation,
  ) {
    if (size == AttachmentSize.xs) return 14;
    if (orientation == AttachmentOrientation.vertical) return 24;
    return 16;
  }

  /// `opacity-60` until the state is `done` or `idle`.
  static const double imageDimmed = 0.60;

  /// `group-data-[state=error]/attachment:bg-destructive/10`.
  static const double errorWellAlpha = 0.10;

  /// `max-w-3xl` on the preview panel — measured 768.
  static double get previewMaxWidth => space(192);

  /// `max-h-[70vh]` on the previewed media.
  static const double previewMaxHeightFraction = 0.70;

  /// `ring-1 ring-foreground/10` — the panel's whole box-shadow.
  static const double previewRingAlpha = 0.10;

  /// `top-3 right-3` on the close control.
  static double get previewCloseInset => space(3);

  final Widget child;
  final AttachmentMediaVariant variant;

  /// The full-size media, and the port of `src` + `preview`.
  ///
  /// Supplying one makes the well expandable: an [AttachmentTrigger] covers
  /// it at `cursor: zoom-in`, and pressing it opens the media over the dimmed
  /// page through the shared [OverlayPortal] — a dialog and not an alert
  /// dialog, because §5's table reserves the alert for the irreversible and
  /// there is nothing here to decide. Null leaves the well a static thumbnail,
  /// which is what `preview={false}` does.
  final Widget? preview;

  /// Accessible title for the panel, and the name the trigger's label carries.
  /// Defaults to `"media"`, mirroring the URL-tail fallback.
  final String? previewName;

  /// A second line under the title. Screen-reader only.
  final String? previewDescription;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final AttachmentScope scope = AttachmentScope.of(context);
    final bool error = scope.state == AttachmentState.error;
    final bool vertical = scope.orientation == AttachmentOrientation.vertical;

    // `group-data-[orientation=vertical]:w-full` is overruled by the size rules
    // on `sm` and `xs`, which are written after it.
    final double? width = vertical && scope.size == AttachmentSize.md
        ? null
        : wellFor(scope.size);

    Widget content = child;
    if (variant == AttachmentMediaVariant.image) {
      final bool dim =
          scope.state != AttachmentState.done &&
          scope.state != AttachmentState.idle;
      content = Opacity(
        opacity: dim ? imageDimmed : 1,
        // `*:[img]:aspect-square *:[img]:w-full *:[img]:object-cover`.
        child: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            clipBehavior: Clip.hardEdge,
            child: child,
          ),
        ),
      );
    }

    Widget well = Container(
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: error
            ? theme.destructive.withValues(alpha: errorWellAlpha)
            : theme.muted,
        borderRadius: BorderRadius.circular(radiusFor(scope.size)),
      ),
      // `overflow-hidden`.
      clipBehavior: Clip.antiAlias,
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: error ? theme.destructiveText : theme.foreground,
        ),
        child: content,
      ),
    );

    // `aspect-square`. A known width makes the square known outright — and it
    // has to be spelled that way rather than as `SizedBox(width:) >
    // AspectRatio`, because `RenderConstrainedBox` passes the *incoming* width
    // down to an intrinsic-height query rather than its own. Under
    // `IntrinsicHeight` — which is how `Grid` measures every state cell — a
    // 32px well then answers with the cell's full 175px and stretches the
    // whole row. Measured: the five-cell matrix came out 304.48 tall against
    // the reference's 175.67 until this was a plain square.
    well = width != null
        // A vertical card stretches its children, and a `SizedBox` under a
        // tight constraint is not a width — it is ignored. `Align` is: it
        // fills the column and lays the well out loose at the start, which is
        // what a block-level `w-8` does in CSS.
        ? Align(
            alignment: AlignmentDirectional.centerStart,
            heightFactor: 1,
            child: SizedBox(width: width, height: width, child: well),
          )
        : flutter.AspectRatio(aspectRatio: 1, child: well);

    if (preview == null) return well;

    final String name = previewName ?? 'media';

    // `<DialogTrigger asChild><AttachmentTrigger/></DialogTrigger>` —
    // `AttachmentTrigger` is `absolute inset-0 z-10` at `cursor: zoom-in`, so
    // the content stays a sibling rather than a button's child.
    return Stack(
      children: <Widget>[
        well,
        Positioned.fill(
          child: OverlayPortal(
            transition:
                (
                  BuildContext context,
                  Animation<double> animation,
                  Widget child,
                ) => OpenTransition(animation: animation, child: child),
            trigger: (BuildContext context, VoidCallback open) =>
                AttachmentTrigger(
                  onPressed: open,
                  cursor: SystemMouseCursors.zoomIn,
                  label: 'Open $name full size',
                ),
            content: (BuildContext context, VoidCallback close) =>
                _AttachmentPreview(
                  name: name,
                  description: previewDescription,
                  onClose: close,
                  child: preview!,
                ),
          ),
        ),
      ],
    );
  }
}

/// `<DialogContent data-slot="attachment-preview">` — the media, full size.
///
/// Composed on [OverlayPortal] rather than on `DialogContent`, because this
/// panel is none of that component's two variants: it is **768px** wide
/// (`max-w-3xl` against the dialog family's 384/448), it shows no stock close
/// button, and its whole body is one bled image. Measured open at 1440×900:
/// 768 × 630, fixed and centred, `p-0`, 16px radius on `--card`, a single 1px
/// `foreground/10` ring and no elevation under it, entering on `yuki-jelly-in`
/// at 420ms.
class _AttachmentPreview extends StatelessWidget {
  const _AttachmentPreview({
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
    final ThemeTokens theme = ThemeScope.of(context);
    final double maxHeight =
        MediaQuery.sizeOf(context).height *
        AttachmentMedia.previewMaxHeightFraction;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: AttachmentMedia.previewMaxWidth),
      child: Semantics(
        container: true,
        // `<DialogHeader className="sr-only">` — the title exists for the
        // accessibility tree, which a dialog owes regardless of how it looks.
        label: description == null ? name : '$name. $description',
        child: Container(
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius: BorderRadius.circular(Radii.xl),
            // `ring-1 ring-foreground/10`, and nothing under it.
            boxShadow: ShadowStyle(<ShadowLayer>[
              ShadowLayer(
                0,
                0,
                0,
                BorderWidths.hairline,
                (ThemeTokens t) => t.foreground.withValues(
                  alpha: AttachmentMedia.previewRingAlpha,
                ),
              ),
            ]).outerShadows(theme),
          ),
          // `overflow-hidden p-0`.
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                // `w-full bg-muted object-contain` — the letterbox is the well
                // colour, not the card's.
                child: ColoredBox(
                  color: theme.muted,
                  child: SizedBox(width: double.infinity, child: child),
                ),
              ),
              PositionedDirectional(
                top: AttachmentMedia.previewCloseInset,
                end: AttachmentMedia.previewCloseInset,
                // A **`secondary`** button, not the stock ghost ✕: this panel
                // has no header band for the ✕ to sit on, and a ghost control
                // disappears into whatever pixel of the photograph it lands on.
                child: Button(
                  variant: ButtonVariant.secondary,
                  size: ButtonSize.icon,
                  label: 'Close',
                  onPressed: onClose,
                  child: Icon.lucide(
                    Lucide.x,
                    sizePx: Button.iconPxFor(ButtonSize.icon),
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

/// `AttachmentContent` — `flex-1 min-w-0 leading-tight`, plus `px-1` when the
/// card is vertical.
class AttachmentContent extends StatelessWidget {
  const AttachmentContent({super.key, required this.title, this.description});

  /// `group-data-[orientation=vertical]/attachment:px-1`.
  static double get verticalInset => space(1);

  final Widget title;
  final Widget? description;

  @override
  Widget build(BuildContext context) {
    final AttachmentScope scope = AttachmentScope.of(context);
    final bool vertical = scope.orientation == AttachmentOrientation.vertical;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: vertical ? verticalInset : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[title, ?description],
      ),
    );
  }
}

/// `AttachmentTitle` — `truncate font-medium`, on a shimmer while the file is
/// uploading or processing.
class AttachmentTitle extends StatelessWidget {
  const AttachmentTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final AttachmentScope scope = AttachmentScope.of(context);
    final bool shimmering =
        scope.state == AttachmentState.uploading ||
        scope.state == AttachmentState.processing;

    final Widget label = StyledText(
      text,
      scope.size == AttachmentSize.md ? TextStyles.body : TextStyles.small,
      color: theme.foreground,
      maxLines: 1,
      // `truncate` — `overflow:hidden white-space:nowrap text-overflow:ellipsis`.
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    );

    if (!shimmering) return label;
    return AttachmentStatusText(child: label);
  }
}

/// The `shimmer` utility from `shadcn/tailwind.css` — a highlight band swept
/// across the glyphs themselves.
///
/// `background-clip: text` with `-webkit-text-fill-color: transparent`, which
/// is a [ShaderMask] in [BlendMode.srcIn] over the painted text. Measured on
/// the two shimmering titles (12px):
///
/// * `animation: tw-shimmer 2s linear infinite`, `100% 0 → 0 0`;
/// * spread `calc(3ch + 40px)` — **63.2383px** at 12px Inter;
/// * five stops: base, `mix(highlight, base 50%)`, highlight, the mix again,
///   base, at −S, −S/2, 0, +S/2, +S around the band centre;
/// * the centre travels `−S → W + S` over one cycle;
/// * `--shimmer-angle` resolves to **20°**, so the gradient axis is
///   `90° + 20°` — the band leans, and on a 15px line box that is 5.1px of
///   vertical run against ~300px of horizontal, which is why the sweep still
///   reads as horizontal.
///
/// In dark the highlight is `oklch(from currentColor max(.8, l+.4) c h /
/// alpha+.4)` — measured white at full alpha; in light it is the ink at 20%.
class AttachmentStatusText extends StatefulWidget {
  const AttachmentStatusText({super.key, required this.child});

  /// `--shimmer-duration: 2s`.
  static const Duration period = Duration(seconds: 2);

  /// `calc(3ch + 40px)` — the `ch` half is font-relative, so the widget
  /// measures it rather than pinning 63.2383.
  static const double spreadChars = 3;
  static double get spreadPx => space(10);

  /// `--shimmer-angle` — 20°, added to the gradient's own 90°.
  static const double angleDegrees = 20;

  /// The light theme's `oklch(from currentColor l c h / calc(alpha * .2))`.
  static const double lightHighlightAlpha = 0.20;

  final Widget child;

  @override
  State<AttachmentStatusText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<AttachmentStatusText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: AttachmentStatusText.period,
  );

  @override
  void initState() {
    super.initState();
    if (!(WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations)) {
      _c.repeat();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // `prefers-reduced-motion` stills the sweep; the gradient stays at its
    // first frame, which is the band entirely off the left edge.
    if (effectiveMotionDuration(context, AttachmentStatusText.period) ==
        Duration.zero) {
      _c.stop();
      _c.value = 0;
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Color base = theme.foreground;
    final Color highlight = theme.kind == ResolvedColorMode.dark
        // `oklch(from currentColor max(.8, calc(l + .4)) c h / calc(alpha +
        // .4))` over a `--foreground` that is already near-white, measured as
        // `oklch(1 0.0000489 23.7853)`: pure white at full alpha.
        // allow-hardcoded: the measured resolution of a relative colour whose
        // source is the ink this widget is already painting.
        ? const Color(0xFFFFFFFF) // allow-hardcoded: measured relative colour
        : base.withValues(alpha: AttachmentStatusText.lightHighlightAlpha);
    final Color mid = Color.lerp(highlight, base, 0.5)!;
    final double fontSize =
        StyledText.styleOf(context, TextStyles.small).fontSize ?? 12;
    // `3ch` — the advance of "0" three times over. Inter's digit advance is
    // 0.6455em at these sizes (measured 63.2383 total at 12px against a 40px
    // constant, which puts `1ch` at 7.746px).
    final double spread =
        AttachmentStatusText.spreadChars * fontSize * 0.6455 +
        AttachmentStatusText.spreadPx;

    return AnimatedBuilder(
      animation: _c,
      builder: (BuildContext context, Widget? child) => ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (Rect bounds) {
          final double centre =
              -spread + (bounds.width + 2 * spread) * _c.value;
          final double radians =
              AttachmentStatusText.angleDegrees * math.pi / 180;
          final Offset axis = Offset(math.cos(radians), math.sin(radians));
          return ui.Gradient.linear(
            Offset(centre - spread, bounds.height / 2) - axis * 0,
            Offset(centre + spread, bounds.height / 2) + axis * 0,
            <Color>[base, mid, highlight, mid, base],
            <double>[0, 0.25, 0.5, 0.75, 1],
          );
        },
        child: child,
      ),
      child: widget.child,
    );
  }
}

/// `AttachmentDescription` — `mt-0.5 truncate text-xs text-muted-foreground`.
///
/// The error line drops stock's `/80` and takes the **ink**: rasterised on this
/// page, `text-destructive/80` measured 2.72:1 dark and 3.77:1 light and failed
/// AA in both; `-ink` with no opacity gives 6.40:1 and 4.83:1.
class AttachmentDescription extends StatelessWidget {
  const AttachmentDescription(this.text, {super.key});

  /// `mt-0.5` — 2px.
  static double get topGap => space(0.5);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final AttachmentScope scope = AttachmentScope.of(context);

    return Padding(
      padding: EdgeInsets.only(top: topGap),
      child: StyledText(
        text,
        TextStyles.small,
        color: scope.state == AttachmentState.error
            ? theme.destructiveText
            : theme.mutedForeground,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }
}

/// `AttachmentActions` — the cluster on the right, floating to the top-right
/// corner when the card is vertical.
class AttachmentActions extends StatelessWidget {
  const AttachmentActions({super.key, required this.children});

  /// `group-data-[orientation=vertical]/attachment:gap-1`.
  static double get verticalGap => space(1);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final AttachmentScope scope = AttachmentScope.of(context);
    final double gap = scope.orientation == AttachmentOrientation.vertical
        ? verticalGap
        : 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < children.length; i++) ...<Widget>[
          if (i > 0 && gap > 0) SizedBox(width: gap),
          children[i],
        ],
      ],
    );
  }
}

/// One control in the cluster — remove, retry, or download.
///
/// A ghost `icon-xs` [Button], so it needs a label of its own. Pass
/// [downloadName] and it becomes the save control: the glyph rolls to a check
/// through [IconSwap] for [savingWindow], and [onDownload] is where the toast
/// is fired from.
class AttachmentAction extends StatefulWidget {
  const AttachmentAction({
    super.key,
    this.child,
    this.onPressed,
    this.label,
    this.downloadName,
    this.onDownload,
  });

  /// `window.setTimeout(() => setSaving(false), 1600)`.
  static const Duration savingWindow = MotionDurations.attachmentSaving;

  /// The glyph. Null on the download form, which supplies its own swap.
  final Widget? child;

  final VoidCallback? onPressed;

  /// `aria-label`.
  final String? label;

  /// `downloadName` — turns this into the save control.
  final String? downloadName;

  /// Fired with [downloadName] when the save control is pressed, so the call
  /// site can raise the *"Saving `<name>`"* toast. **Never "Saved"** — a plain
  /// `download` anchor gives the page no completion event.
  final void Function(String name)? onDownload;

  @override
  State<AttachmentAction> createState() => _AttachmentActionState();
}

class _AttachmentActionState extends State<AttachmentAction> {
  bool _saving = false;

  void _press() {
    final String? name = widget.downloadName;
    if (name != null) {
      setState(() => _saving = true);
      widget.onDownload?.call(name);
      Future<void>.delayed(AttachmentAction.savingWindow, () {
        if (mounted) setState(() => _saving = false);
      });
    }
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final double px = Button.iconPxFor(ButtonSize.iconXs);

    final Widget glyph =
        widget.child ??
        IconSwap(
          activeIndex: _saving ? 1 : 0,
          window: px,
          cell: px,
          icons: <Widget>[
            Icon.lucide(Lucide.download, sizePx: px),
            Icon.lucide(Lucide.check, sizePx: px),
          ],
        );

    return Button(
      variant: ButtonVariant.ghost,
      size: ButtonSize.iconXs,
      label:
          widget.label ??
          (widget.downloadName == null
              ? null
              : 'Download ${widget.downloadName}'),
      onPressed: _press,
      child: glyph,
    );
  }
}

/// An overlay control that makes a whole attachment pressable without nesting a
/// button inside a button — `absolute inset-0 z-10 outline-none`.
class AttachmentTrigger extends StatelessWidget {
  const AttachmentTrigger({
    super.key,
    required this.onPressed,
    this.cursor = SystemMouseCursors.click,
    this.label,
  });

  final VoidCallback onPressed;
  final MouseCursor cursor;
  final String? label;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: cursor,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Semantics(button: true, label: label, child: const SizedBox()),
    ),
  );
}

/// `AttachmentGroup` — scrolls sideways, snaps, and fades its edge.
///
/// Measured: `gap-3` (12), `py-1` (4), `scroll-px-1` (4), `snap-x mandatory`
/// with `snap-start` children, `scrollbar-width: none`, and `scroll-fade-x`
/// with a **40px** full fade at each edge (`min(12%, 40px)` where 12% of 1030
/// is far larger than 40).
class AttachmentGroup extends StatefulWidget {
  const AttachmentGroup({super.key, required this.children});

  /// `gap-3`.
  static double get gap => space(3);

  /// `py-1`.
  static double get paddingY => space(1);

  /// `scroll-px-1`.
  static double get scrollPadding => space(1);

  final List<Widget> children;

  @override
  State<AttachmentGroup> createState() => _AttachmentGroupState();
}

class _AttachmentGroupState extends State<AttachmentGroup> {
  final ScrollController _c = ScrollController();

  /// One key per child, so the snap targets are the children's own measured
  /// left edges rather than an assumed pitch — the six cards on the page are
  /// 160, 190.94, 163.56, 160, 160 and 160 wide, and no single stride fits
  /// them.
  late List<GlobalKey> _keys = _makeKeys();

  List<GlobalKey> _makeKeys() =>
      List<GlobalKey>.generate(widget.children.length, (_) => GlobalKey());

  @override
  void didUpdateWidget(AttachmentGroup old) {
    super.didUpdateWidget(old);
    if (old.children.length != widget.children.length) _keys = _makeKeys();
  }

  @override
  void initState() {
    super.initState();
    _c.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  /// `scroll-snap-type: x mandatory` with `scroll-snap-align: start` and
  /// `scroll-padding-inline: 4px`: when the scroll settles, the nearest child's
  /// leading edge is brought to 4px inside the container.
  void _snap() {
    if (!_c.hasClients) return;
    final RenderObject? viewport = context.findRenderObject();
    if (viewport is! RenderBox) return;

    final flutter.ScrollPosition p = _c.position;
    double? best;
    for (final GlobalKey key in _keys) {
      final RenderObject? box = key.currentContext?.findRenderObject();
      if (box is! RenderBox) continue;
      final double target =
          (p.pixels +
                  box.localToGlobal(Offset.zero, ancestor: viewport).dx -
                  AttachmentGroup.scrollPadding)
              .clamp(p.minScrollExtent, p.maxScrollExtent);
      if (best == null || (target - p.pixels).abs() < (best - p.pixels).abs()) {
        best = target;
      }
    }
    if (best == null || (best - p.pixels).abs() < 0.5) return;
    _c.animateTo(
      best,
      duration: effectiveMotionDuration(context, MotionDurations.normal),
      curve: MotionCurves.balanced,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget row = SingleChildScrollView(
      controller: _c,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(vertical: AttachmentGroup.paddingY),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < widget.children.length; i++) ...<Widget>[
            if (i > 0) SizedBox(width: AttachmentGroup.gap),
            // `*:data-[slot=attachment]:flex-none` — the cards keep their own
            // widths and the row overflows.
            KeyedSubtree(key: _keys[i], child: widget.children[i]),
          ],
        ],
      ),
    );

    return ScrollConfiguration(
      // `scrollbar-none`.
      behavior: const _GroupScrollBehavior(),
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (ScrollEndNotification n) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _snap();
          });
          return false;
        },
        child: _ScrollFadeX(controller: _c, child: row),
      ),
    );
  }
}

class _GroupScrollBehavior extends ScrollBehavior {
  const _GroupScrollBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;

  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
}

/// `scroll-fade-x` — the same scroll-driven mask `ScrollFade` runs on the
/// message scroller, on both inline edges.
///
/// Measured at rest on the page's own group (1030 visible over 1055 of
/// content): the leading fade is 0 and the trailing one **5.62px**, which is
/// `1 - easeInOut(0.7448)` of the 40px full fade — the range is
/// `calc(100% - 96px) → 100%` against only 25px of travel, so it opens already
/// most of the way through.
class _ScrollFadeX extends StatelessWidget {
  const _ScrollFadeX({required this.controller, required this.child});

  /// `min(12%, calc(var(--spacing) * 10))`.
  static const double fadeFraction = 0.12;
  static double get fadeCap => space(10);

  /// `--scroll-fade-reveal`.
  static double get reveal => space(24);

  final ScrollController controller;
  final Widget child;

  /// The leading fade grows as the box scrolls away from the start; the
  /// trailing one shrinks as it reaches the end. Both run on
  /// [MotionCurves.symmetric] over [reveal] px.
  static (double start, double end) fadesFor({
    required double width,
    required double offset,
    required double max,
  }) {
    final double full = math.min(width * fadeFraction, fadeCap);
    if (max <= 0) return (0, 0);
    final double sT = (offset / reveal).clamp(0.0, 1.0);
    final double eT = ((offset - (max - reveal)) / reveal).clamp(0.0, 1.0);
    return (
      full * MotionCurves.symmetric.transform(sT),
      full * (1 - MotionCurves.symmetric.transform(eT)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        if (!width.isFinite || width <= 0) return child;
        final double offset = controller.hasClients
            ? controller.position.pixels
            : 0;
        final double max = controller.hasClients
            ? controller.position.maxScrollExtent -
                  controller.position.minScrollExtent
            : 0;
        final (double start, double end) = fadesFor(
          width: width,
          offset: offset,
          max: max,
        );
        // Always mounted, even at zero fade — see `ScrollFade`'s own note:
        // a subtree whose shape changes is rebuilt from scratch, and that
        // discards the `Scrollable` underneath it.
        return ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (Rect bounds) => LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            // A mask stencil, not a colour: `mask-image` reads only the
            // alpha channel, and these are the gradient's own `#000` and
            // `transparent` stops.
            // allow-hardcoded: mask alpha stencil, not a design colour.
            colors: const <Color>[
              Color(0x00000000), // allow-hardcoded: mask alpha stencil
              Color(0xFF000000), // allow-hardcoded: mask alpha stencil
              Color(0xFF000000), // allow-hardcoded: mask alpha stencil
              Color(0x00000000), // allow-hardcoded: mask alpha stencil
            ],
            stops: <double>[
              0,
              (start / width).clamp(0.0, 1.0),
              (1 - end / width).clamp(0.0, 1.0),
              1,
            ],
          ).createShader(bounds),
          child: child,
        );
      },
    );
  }
}
