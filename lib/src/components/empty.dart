/// `components/ui/empty.tsx` — six parts, and two of them are drifts.
///
/// *"An empty state must explain why it is empty and give one clear way out. A
/// blank panel with 'No results' is an unfinished screen."*
///
/// | part | class list | rendered *(measured)* |
/// |---|---|---|
/// | [DsEmpty] | `flex w-full min-w-0 flex-1 flex-col items-center justify-center gap-4 rounded-xl border-dashed p-6 text-center text-balance` | 24px padding, 16px gap, r**16**, centred |
/// | [DsEmptyHeader] | `flex max-w-sm flex-col items-center gap-2` | **384px**, 8px gap |
/// | [DsEmptyMedia] | `mb-2 flex shrink-0 items-center justify-center` + `size-8 rounded-lg bg-muted text-foreground` | **32 × 32**, r12, `--muted`, 8px below |
/// | [DsEmptyTitle] | `font-heading text-sm font-medium tracking-tight` | 13 / 500 / 18.5714 / −0.26px |
/// | [DsEmptyDescription] | `text-sm/relaxed text-muted-foreground` | 13 / 21.125 / `--muted-foreground` |
/// | [DsEmptyContent] | `flex w-full max-w-sm min-w-0 flex-col items-center gap-2.5 text-sm text-balance` | **384px**, 10px gap |
///
/// ## DRIFT 8 — the dashed border never paints
///
/// *(measured: `border-style: dashed`, `border-width: **0px**`.)* `empty.tsx`
/// L10 writes `rounded-xl border-dashed` and **no width class at all**.
/// Tailwind's `border-dashed` sets only `border-style`, and Preflight resets
/// every border to `0`, so the style has nothing to apply to. Both empty states
/// on the page render as borderless centred blocks.
///
/// [DsEmpty] therefore paints **no border**, which is not an omission: a port
/// that read the class list instead of the render would draw a dashed rectangle
/// that is nowhere on the reference. The corner radius is still real — it
/// clips nothing today and would shape the border the moment someone adds a
/// width — so it is kept.
///
/// ## DRIFT 9 — `EmptyMedia` defeats `Icon size="xl"`
///
/// *(measured: `width`/`height` attributes 24, computed box **16 × 16**,
/// `stroke-width` **2**.)* `emptyMediaVariants.icon` carries
/// `[&_svg:not([class*='size-'])]:size-4`, and `Icon` sets its size as
/// **presentation attributes** plus a class list containing no `size-` token —
/// so the CSS wins the box and the attributes lose. The glyph is drawn at 16px
/// with the stroke computed for 24 (`icon.tsx` L82: `48/24 = 2`, not the 2.4 a
/// 16px glyph normally gets), i.e. **visibly thinner than every other 16px
/// glyph on the page**.
///
/// Both halves are reproduced by [DsEmptyMedia.glyphSize] and
/// [DsEmptyMedia.glyphStroke], each derived from the rung it comes from rather
/// than typed — so the quirk survives a change to the ladder instead of
/// silently becoming a different quirk.
///
/// ## `text-balance`, recorded
///
/// [DsEmpty] and [DsEmptyContent] both carry it. Flutter's line breaker has no
/// balanced mode, so both wrap greedily — supervisor ruling F3: unreachable,
/// not skipped, and the parity probe measures against a greedy reference.
library;

import 'package:flutter/widgets.dart';

import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../text_layout.dart';
import '../theme_scope.dart';
import 'icon.dart';
import 'icon_paths.dart';

/// The root — a centred column with nothing around it.
class DsEmpty extends StatelessWidget {
  const DsEmpty({super.key, required this.children});

  /// `p-6`.
  static double get padding => ds(6);

  /// `gap-4`.
  static double get gap => ds(4);

  /// `rounded-xl` — 16px, and the only `rounded-xl` on the feedback page.
  ///
  /// It shapes nothing at present (drift 8: there is no border to shape and no
  /// background to clip); it is transcribed because the class is written and
  /// because it is what a future `border` width would follow.
  static double get radius => DsRadii.xl;

  /// `EmptyHeader` and `EmptyContent`, in order.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        // `flex-col items-center justify-center`.
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 0; i < children.length; i++) ...<Widget>[
            if (i > 0) SizedBox(height: gap),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// `EmptyHeader` — the media, the title and the description, on a short
/// measure.
class DsEmptyHeader extends StatelessWidget {
  const DsEmptyHeader({super.key, required this.children});

  /// `gap-2`.
  static double get gap => ds(2);

  /// `max-w-sm` — 384px.
  static double get maxWidth => DsContainers.sm;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 0; i < children.length; i++) ...<Widget>[
            if (i > 0) SizedBox(height: gap),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// `EmptyMedia variant="icon"` — a 32px muted tile with a glyph in it.
class DsEmptyMedia extends StatelessWidget {
  const DsEmptyMedia({
    super.key,
    required this.glyph,
    this.tone = DsIconTone.normal,
  });

  /// `size-8` — the tile.
  static double get box => ds(8);

  /// `rounded-lg` — 12px.
  static double get radius => DsRadii.lg;

  /// `mb-2` — the gap to the title, on top of `EmptyHeader`'s own `gap-2`.
  static double get marginBottom => ds(2);

  /// The box the glyph is **actually** drawn in: `size-4`, forced by
  /// `[&_svg:not([class*='size-'])]:size-4` over the `size="xl"` attribute.
  static double get glyphSize => DsIcon.pxFor(DsIconSize.md);

  /// …and the stroke it is drawn with, which the class list does **not**
  /// override: `icon.tsx` computes `strokeWidth` from the size **prop**, so it
  /// is still the 24px rung's **2**, not the 2.4 a 16px glyph gets.
  ///
  /// Derived from the rung the prop names, so the drift tracks the ladder.
  static double get glyphStroke => DsIcon.strokeFor(DsIcon.pxFor(DsIconSize.xl));

  final DsIconGlyph glyph;

  /// `tone="action"` on the first specimen, `tone="subtle"` on the second.
  final DsIconTone tone;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom),
      child: Container(
        width: box,
        height: box,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.muted,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: DsIcon(
          glyph,
          sizePx: glyphSize,
          strokeOverride: glyphStroke,
          tone: tone,
        ),
      ),
    );
  }
}

/// `EmptyTitle` — `font-heading text-sm font-medium tracking-tight`.
class DsEmptyTitle extends StatelessWidget {
  const DsEmptyTitle(this.text, {super.key});

  final String text;

  /// The resolved style — 13 / 500 / 18.5714 / **−0.26px**.
  ///
  /// Built from [DsComponentType.buttonLabel] plus one override rather than
  /// from a spec of its own, because `typography.dart` has a single writer this
  /// wave and this class list has no spec yet. Two of its four classes are
  /// already exactly that spec (`text-sm font-medium` → 13 / 500 / Tailwind's
  /// surviving `--text-sm--line-height` ratio), and of the other two:
  ///
  ///  * `font-heading` is a **no-op in the rendered result** —
  ///    `DsFonts.heading` and `DsFonts.sans` are both `"Inter Local"`
  ///    (globals.css L169 / L171 declare two tokens for one face), so the class
  ///    changes which token is read and not which face renders;
  ///  * `tracking-tight` is `--tracking-tight` −0.02em, read off
  ///    [DsType.h1] — the one spec in the type layer that transcribes exactly
  ///    that token — rather than typed here, so a retune of the token carries.
  ///
  /// FOLLOW-UP: fold this into a `DsComponentType.emptyTitle` when
  /// `typography.dart` is next open to this phase.
  static TextStyle styleOf(BuildContext context, {Color? color}) {
    final DsTypeSpec spec = DsComponentType.buttonLabel;
    return DsText.styleOf(context, spec, color: color).copyWith(
      letterSpacing: DsType.h1.tracking! * spec.size!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final TextStyle style = styleOf(context, color: theme.foreground);
    return DsLineBox(
      style: style,
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }
}

/// `EmptyDescription` — `text-sm/relaxed text-muted-foreground`.
class DsEmptyDescription extends StatelessWidget {
  const DsEmptyDescription(this.text, {super.key});

  /// 13 / 400 / **1.625** — the same resolved rung
  /// [DsComponentType.textareaBody] carries.
  ///
  /// Named for the textarea because that is the class list it was transcribed
  /// from, and reused here rather than duplicated: `text-sm/relaxed` and
  /// `text-sm leading-relaxed` are two spellings of one declaration, and a
  /// second spec would be two names for one style.
  static DsTypeSpec get spec => DsComponentType.textareaBody;

  final String text;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsText(
      text,
      spec,
      color: theme.mutedForeground,
      align: TextAlign.center,
    );
  }
}

/// `EmptyContent` — the way out, on the same short measure as the header.
class DsEmptyContent extends StatelessWidget {
  const DsEmptyContent({super.key, required this.children});

  /// `gap-2.5` — 10px, one step wider than the header's.
  static double get gap => ds(2.5);

  /// `max-w-sm`.
  static double get maxWidth => DsContainers.sm;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      // `text-sm` — the ambient style the actions inside inherit.
      child: DefaultTextStyle.merge(
        style: DsText.styleOf(
          context,
          DsComponentType.textSm,
          color: theme.foreground,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int i = 0; i < children.length; i++) ...<Widget>[
              if (i > 0) SizedBox(height: gap),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}
