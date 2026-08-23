/// `/design-system/spacing`: the Spacing & Layout foundation page.
///
/// Every number on this page is a demo of itself: the bars in `#scale` are the
/// step they name, the boxes in `#radius` are cut to the corner they print, and
/// the twelve cells in `#grid` are the grid they describe. Nothing here is a
/// picture of a value; it is the value.
///
/// Three claims disagree with the tokens, and all three ship as written
/// (spacing-map §11: copy is the page, tokens are the system):
/// * the Meta copy calls `--width-page` **1320px**: twice, in `#grid` and in
///   the `2xl` breakpoint row: while the token declares 1200
///   ([DsWidths.page], which carries the same drift note);
/// * `#radius` is labelled "Seven steps" and calls `3xl` the largest allowed,
///   while [DsRadii] carries nine (`xs` 2px and `4xl` 32px are undocumented
///   here);
/// * `#scale` rules that a gap off the ten-step list is wrong, while the docs
///   chrome it is printed on uses 6/10/20/28/56px steps of its own.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';
import '../nav.dart';

/// `bg-action/12`: the grid demo's cells.
const double _gridCellAlpha = 0.12;

/// `border-action/40`, `border-value/40`: the two glow boxes' rims.
const double _glowBorderAlpha = 0.40;

/// Tailwind's `leading-snug` ratio, which the two specimen captions override
/// `.type-small`'s own 1.5 with. `globals.css` declares no `--leading-*` token
/// for it, so it cannot come from the foundation layer.
// allow-hardcoded: framework default with no token to read it from.
const double _leadingSnug = 1.375;

/// `w-36`: the column one radius specimen occupies.
final double _radiusCellWidth = ds(36);

/// `h-24`: the height every specimen box on this page shares.
final double _specimenHeight = ds(24);

/* ── Page data (the reference's three module-level arrays) ───────────────── */

/// One row of the spacing table.
///
/// [n] is the Tailwind class number, which *is* the pixel value divided by
/// four: the page's whole argument: so the bar's width, the printed px and
/// the class name all derive from it through [ds] rather than being restated.
typedef _Step = ({int n, String use});

const List<_Step> _scale = <_Step>[
  (n: 1, use: 'Icon-to-label inside a badge. Pip gaps.'),
  (n: 2, use: 'Between related controls. Chip gaps.'),
  (n: 3, use: 'Inside compact rows. Grid gutters on mobile.'),
  (n: 4, use: 'Default card padding. Standard grid gutter.'),
  (n: 6, use: 'Card padding on desktop. Between cards in a grid.'),
  (n: 8, use: 'Between modules inside a section.'),
  (n: 10, use: 'Section inner spacing.'),
  (n: 12, use: 'Between page sections.'),
  (n: 16, use: 'Between major page sections.'),
  (n: 20, use: 'Above and below a hero. The largest step.'),
];

/// One rung of the radius ladder. [px] is the token, and the demo box is cut
/// to it.
typedef _Radius = ({String name, double px, String use});

final List<_Radius> _radii = <_Radius>[
  (name: 'sm', px: DsRadii.sm, use: 'Badges, pips, small chips, inline code.'),
  (
    name: 'md',
    px: DsRadii.md,
    use: 'Buttons, inputs, rows, dropdown items. The default.',
  ),
  (
    name: 'lg',
    px: DsRadii.lg,
    use: 'Cards, pack cards, collectible tiles, panels.',
  ),
  (name: 'xl', px: DsRadii.xl, use: 'Large cards, dialogs, feature panels.'),
  (name: '2xl', px: DsRadii.xl2, use: 'Promotional panels, pack stage.'),
  (
    name: '3xl',
    px: DsRadii.xl3,
    use: 'The landing hero panel. Largest allowed.',
  ),
  (
    name: 'pill',
    px: DsRadii.pill,
    use: 'Pills, filter chips, avatars, live indicator.',
  ),
];

/// One neutral depth step: the class the box wears, the token it prints, and
/// the spec that paints it.
typedef _Elevation = ({
  String token,
  String cls,
  DsShadowSpec spec,
  String use,
});

final List<_Elevation> _elevation = <_Elevation>[
  (
    token: '--shadow-e1',
    cls: 'shadow-e1',
    spec: DsShadows.e1,
    use: 'Resting rows, chips, table headers. Barely there.',
  ),
  (
    token: '--shadow-e2',
    cls: 'shadow-e2',
    spec: DsShadows.e2,
    use: 'Cards and pack cards at rest.',
  ),
  (
    token: '--shadow-e3',
    cls: 'shadow-e3',
    spec: DsShadows.e3,
    use: 'Hovered cards, popovers, dropdowns, sticky bars.',
  ),
  (
    token: '--shadow-e4',
    cls: 'shadow-e4',
    spec: DsShadows.e4,
    use: 'Dialogs, drawers, the pack-opening stage.',
  ),
];

/* ── Page ────────────────────────────────────────────────────────────────── */

class SpacingPage extends StatelessWidget {
  const SpacingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The header reads its own copy out of the nav registry, exactly as
    // `findCategory("foundations", "spacing")` does in the reference.
    final DsCategoryHit here = findCategory('foundations', 'spacing');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPageHeader(
          eyebrow: here.group.title,
          title: here.category.title,
          blurb: here.category.blurb,
          contents: here.category.contents,
        ),
        const _ScaleSection(),
        const _RadiusSection(),
        const _ElevationSection(),
        const _GridSection(),
        const _BreakpointsSection(),
        const DsSection(
          id: 'rules',
          title: 'Rules',
          child: DsDoDont(
            dos: <String>[
              'Pick gaps from the scale — 4, 8, 12, 16, 24, 32, 40, 48, 64, 80.',
              'Let radius follow surface size: badges 6, buttons 10, cards 12, '
                  'dialogs 16.',
              'Use the surface ladder for depth first, and add a shadow only to '
                  'confirm it.',
              'Ask for a measure by token — --width-page, --width-content, '
                  '--width-prose — never by number.',
            ],
            donts: <String>[
              "Don't invent in-between spacing values to make something 'fit'.",
              "Don't put a glow on a resting surface — glow means selected, "
                  'rare or premium.',
              "Don't let a card and its inner input share the same radius; the "
                  'ladder should read.',
              "Don't write a measure as an arbitrary value; if the token is "
                  'missing, add it to globals.css rather than working around it.',
            ],
          ),
        ),
        const DsPageFootNav(groupId: 'foundations', slug: 'spacing'),
      ],
    );
  }
}

/* ── #scale ──────────────────────────────────────────────────────────────── */

class _ScaleSection extends StatelessWidget {
  const _ScaleSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'scale',
      title: 'Spacing scale',
      description: 'An 8-point system with a 4px half-step for tight interior '
          "spacing. Tailwind's default 0.25rem unit already matches, so the "
          'class number is simply the pixel value divided by four.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // `overflow-hidden rounded-xl border border-border bg-card` with a
          // hairline between rows and none at the card's edges.
          DsDividedList(
            radius: DsRadii.xl,
            children: <Widget>[
              for (final _Step step in _scale) _ScaleRow(step: step),
            ],
          ),
          SizedBox(height: ds(4)),
          DsNote(
            tone: DsNoteTone.error,
            title: 'The only spacing rule',
            child: DsText(
              'If a gap is not on this scale, it is wrong. There is no 18px, '
              'no 30px and no 50px anywhere in the product.',
              DsType.small,
            ),
          ),
        ],
      ),
    );
  }
}

/// `grid items-center gap-4 border-b border-border px-6 py-4 last:border-b-0
/// sm:grid-cols-[4rem_5rem_1fr] sm:gap-6`.
class _ScaleRow extends StatelessWidget {
  const _ScaleRow({required this.step});

  final _Step step;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final bool wide = MediaQuery.sizeOf(context).width >= DsBreakpoints.sm;
    final double px = ds(step.n);

    final Widget size = DsText(
      '${px.toInt()}px',
      DsType.numBase,
      color: theme.foreground,
    );
    final Widget className = DsText(
      'gap-${step.n}',
      DsType.numSm,
      color: theme.actionInk,
    );
    // `flex items-center gap-4`: the bar, then what the step is for.
    final Widget demo = Row(
      children: <Widget>[
        SizedBox(
          // `style={{ width: s.px }}`: the specimen is the measure, so this
          // is the one width on the page that is stated in pixels.
          width: px,
          height: ds(3),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: DsPalette.action,
              borderRadius: BorderRadius.circular(DsRadii.sm),
            ),
          ),
        ),
        SizedBox(width: ds(4)),
        Expanded(child: DsText(step.use, DsType.small)),
      ],
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ds(6), vertical: ds(4)),
      child: wide
          ? Row(
              children: <Widget>[
                // `4rem` / `5rem`, then the rest of the row.
                SizedBox(width: ds(16), child: size),
                SizedBox(width: ds(6)),
                SizedBox(width: ds(20), child: className),
                SizedBox(width: ds(6)),
                Expanded(child: demo),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                size,
                SizedBox(height: ds(4)),
                className,
                SizedBox(height: ds(4)),
                demo,
              ],
            ),
    );
  }
}

/* ── #radius ─────────────────────────────────────────────────────────────── */

class _RadiusSection extends StatelessWidget {
  const _RadiusSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'radius',
      title: 'Radius ladder',
      description: 'Radius encodes size: the bigger the surface, the softer '
          "the corner. This overrides shadcn's computed radius scale with "
          'explicit values.',
      // "Seven steps" of nine: `--radius-xs` and `--radius-4xl` exist and are
      // not shown here. The label is the reference's, kept.
      child: DsPanel(
        label: 'Seven steps',
        child: Wrap(
          spacing: ds(5),
          runSpacing: ds(5),
          children: <Widget>[
            for (final _Radius radius in _radii) _RadiusCell(radius: radius),
          ],
        ),
      ),
    );
  }
}

/// `999` for the pill, `6px`… for every other rung: the reference's own
/// special case, printed off the token either way.
String _radiusLabel(double px) =>
    px == DsRadii.pill ? '${px.toInt()}' : '${px.toInt()}px';

class _RadiusCell extends StatelessWidget {
  const _RadiusCell({required this.radius});

  final _Radius radius;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return SizedBox(
      width: _radiusCellWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: _specimenHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.muted,
              // `style={{ borderRadius: r.px }}`: the specimen is the value.
              borderRadius: BorderRadius.circular(radius.px),
              border: Border.all(color: theme.input, width: DsWidths.hairline),
            ),
            child: DsText(
              _radiusLabel(radius.px),
              DsType.numSm,
              color: theme.mutedForeground,
            ),
          ),
          SizedBox(height: ds(3)),
          DsText(
            'rounded-${radius.name}',
            DsType.numSm,
            color: theme.actionInk,
          ),
          SizedBox(height: ds(1)),
          _UseCopy(radius.use),
        ],
      ),
    );
  }
}

/* ── #elevation ──────────────────────────────────────────────────────────── */

class _ElevationSection extends StatelessWidget {
  const _ElevationSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'elevation',
      title: 'Elevation',
      description: 'Four neutral depth steps, plus two glows that are strictly '
          'rationed. On a near-black background a shadow reads as a soft '
          'darkening, so depth mostly comes from the surface ladder — shadows '
          'only confirm it.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DsPanel(
            label: 'Neutral depth',
            child: DsGrid(
              sm: 2,
              lg: 4,
              gap: ds(6),
              children: <Widget>[
                for (final _Elevation step in _elevation)
                  _ElevationCell(step: step),
              ],
            ),
          ),
          SizedBox(height: ds(4)),
          DsPanel(
            label: 'Rationed glow',
            note: 'Selected · rare · premium only',
            child: DsGrid(
              sm: 2,
              gap: ds(6),
              children: const <Widget>[_ActionGlowCell(), _ValueGlowCell()],
            ),
          ),
        ],
      ),
    );
  }
}

class _ElevationCell extends StatelessWidget {
  const _ElevationCell({required this.step});

  final _Elevation step;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: _specimenHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius: BorderRadius.circular(DsRadii.lg),
            border: Border.all(color: theme.border, width: DsWidths.hairline),
            // `e1`–`e4` are outer-only, so a plain decoration paints them all.
            boxShadow: step.spec.outerShadows(theme),
          ),
          child: DsText(
            step.cls,
            DsType.numSm,
            color: theme.mutedForeground,
          ),
        ),
        SizedBox(height: ds(3)),
        DsText(step.token, DsType.numSm, color: theme.actionInk),
        SizedBox(height: ds(1)),
        _UseCopy(step.use),
      ],
    );
  }
}

/// `glow-action`: selection, and the one caption that names what it means.
class _ActionGlowCell extends StatelessWidget {
  const _ActionGlowCell();

  @override
  Widget build(BuildContext context) {
    return _GlowCell(
      spec: DsShadows.glowAction,
      rim: DsPalette.action,
      label: 'glow-action',
      ink: DsTheme.of(context).actionInk,
      lead: 'Selected pack, focused primary CTA, active opening stage. '
          'Signals ',
      emphasis: 'this is the thing you chose',
    );
  }
}

/// `glow-value`: reward, mirrored on the value ramp.
class _ValueGlowCell extends StatelessWidget {
  const _ValueGlowCell();

  @override
  Widget build(BuildContext context) {
    return _GlowCell(
      spec: DsShadows.glowValue,
      rim: DsPalette.value,
      label: 'glow-value',
      ink: DsTheme.of(context).valueInk,
      lead: 'Legendary or mythic reveal, reward unlock, premium action. '
          'Signals ',
      emphasis: 'this is worth something',
    );
  }
}

class _GlowCell extends StatelessWidget {
  const _GlowCell({
    required this.spec,
    required this.rim,
    required this.label,
    required this.ink,
    required this.lead,
    required this.emphasis,
  });

  final DsShadowSpec spec;

  /// The ramp the `border-<ramp>/40` rim is cut from.
  final Color rim;

  final String label;
  final Color ink;

  /// The caption up to its `<em>`…
  final String lead;

  /// …and the clause inside it.
  final String emphasis;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: _specimenHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius: BorderRadius.circular(DsRadii.lg),
            border: Border.all(
              color: rim.withValues(alpha: _glowBorderAlpha),
              width: DsWidths.hairline,
            ),
            boxShadow: spec.outerShadows(theme),
          ),
          child: DsText(label, DsType.numSm, color: ink),
        ),
        SizedBox(height: ds(3)),
        DsRichText(
          TextSpan(
            children: <InlineSpan>[
              TextSpan(text: lead),
              TextSpan(
                text: emphasis,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const TextSpan(text: '.'),
            ],
          ),
          DsType.small,
        ),
      ],
    );
  }
}

/* ── #grid ───────────────────────────────────────────────────────────────── */

class _GridSection extends StatelessWidget {
  const _GridSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'grid',
      title: 'Grid and content width',
      description: 'Desktop-first on a 1440px frame. Content is capped so that '
          'grids never stretch into unreadable rows on ultrawide displays. '
          'Every measure below is a token; this section used to state three of '
          'them as prose only, which meant a container had nothing to read and '
          'an arbitrary max-width was the only way to obey it.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const DsMeta(
            items: <DsMetaItem>[
              (
                k: 'Design frame',
                v: TextSpan(
                  text: '1440px wide — the canvas everything is composed '
                      'against. Not a token: it is the canvas, not a measure '
                      'anything renders at.',
                ),
              ),
              (
                k: '--width-shell',
                v: TextSpan(
                  text: '1680px. The outer frame the sidebar and main column '
                      'share on the documentation site.',
                ),
              ),
              // DRIFT, kept: `--width-page` is 1200px in globals.css. The copy
              // has said 1320 since before the token existed.
              (
                k: '--width-page',
                v: TextSpan(
                  text: '1320px. The cap for customer-facing pages — FAQ, '
                      'about, contact, help, legal.',
                ),
              ),
              (
                k: '--width-content',
                v: TextSpan(
                  text: '1080px. A documentation column: copy with specimens, '
                      'panels and tables beside it.',
                ),
              ),
              (
                k: '--width-prose',
                v: TextSpan(
                  text: '720px. A reading column carrying nothing but '
                      'sentences. See Typography → Prose.',
                ),
              ),
              (
                k: '--height-site-header',
                v: TextSpan(
                  text: '4rem. Every sticky header. --scroll-offset derives '
                      'from it, so an anchored heading cannot land underneath '
                      'one.',
                ),
              ),
              (
                k: 'Page margin',
                v: TextSpan(
                  text: 'px-6 md:px-8 lg:px-12 — 24px mobile · 32px tablet · '
                      '48px desktop. All on the scale above.',
                ),
              ),
              (
                k: 'Columns',
                v: TextSpan(text: '12-column grid on desktop, 24px gutters.'),
              ),
            ],
          ),
          SizedBox(height: ds(4)),
          DsPanel(
            label: '12 columns · 24px gutters',
            // `grid-cols-12` with no responsive step: twelve columns at every
            // width, which is the claim being demonstrated.
            child: DsGrid(
              base: 12,
              gap: ds(6),
              children: <Widget>[
                for (int i = 1; i <= 12; i++) _GridCell(column: i),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GridCell extends StatelessWidget {
  const _GridCell({required this.column});

  final int column;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Container(
      height: ds(20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: DsPalette.action.withValues(alpha: _gridCellAlpha),
        borderRadius: BorderRadius.circular(DsRadii.sm),
      ),
      child: DsText('$column', DsType.numSm, color: theme.actionInk),
    );
  }
}

/* ── #breakpoints ────────────────────────────────────────────────────────── */

class _BreakpointsSection extends StatelessWidget {
  const _BreakpointsSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'breakpoints',
      title: 'Breakpoints',
      description: "Tailwind's stock scale, unmodified, and these are the real "
          'numbers rather than an intent. This section described a 1200px '
          'desktop boundary that no breakpoint has ever fired at; the values '
          'below are the ones every component in this repository is actually '
          'written against.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const DsMeta(
            items: <DsMetaItem>[
              (
                k: 'sm — 640px',
                v: TextSpan(
                  text: 'The first column split. Two-up state grids, '
                      'side-by-side panels.',
                ),
              ),
              (
                k: 'md — 768px',
                v: TextSpan(
                  text: 'The mobile boundary, and the one the old prose got '
                      'right. Tables stop becoming card lists; the section '
                      'spacing steps up.',
                ),
              ),
              (
                k: 'lg — 1024px',
                v: TextSpan(
                  text: 'The documentation sidebar appears; page gutters reach '
                      '48px.',
                ),
              ),
              (
                k: 'xl — 1280px',
                v: TextSpan(
                  text: 'The true desktop layout switch. Four-up grids, full '
                      '12 columns.',
                ),
              ),
              // The 1320-vs-1200 drift, stated a second time.
              (
                k: '2xl — 1536px',
                v: TextSpan(
                  text: 'Rarely reached for. --width-page caps at 1320px, so '
                      'most layouts have stopped growing by here.',
                ),
              ),
            ],
          ),
          SizedBox(height: ds(4)),
          DsNote(
            title: 'Why the scale was not overridden',
            child: DsRichText(
              TextSpan(
                children: <InlineSpan>[
                  const TextSpan(
                    text: 'The obvious fix for a 1200px intent is a ',
                  ),
                  DsCode.span('--breakpoint-xl'),
                  const TextSpan(
                    text: ' override. It was rejected: every one of the '
                        'sixty-eight base components is written against the '
                        'stock scale, so moving a boundary re-flows all of '
                        'them silently and nothing in the build reports it. '
                        'The prose was wrong, not the scale. Use ',
                  ),
                  DsCode.span('xl:'),
                  const TextSpan(text: ' for the desktop switch and '),
                  DsCode.span('md:'),
                  const TextSpan(text: ' for the mobile boundary.'),
                ],
              ),
              DsType.small,
            ),
          ),
        ],
      ),
    );
  }
}

/* ── Shared ──────────────────────────────────────────────────────────────── */

/// `type-small mt-1 leading-snug`: the one-line note under a specimen.
///
/// The only place on this page a `.type-*` class is overridden, and it is
/// overridden in exactly one property: the leading tightens so a two-line
/// caption stays a caption.
class _UseCopy extends StatelessWidget {
  const _UseCopy(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = DsText.styleOf(context, DsType.small)
        .copyWith(height: _leadingSnug);
    // Not a `.type-*` class, so it cannot go through [DsText]: but the line
    // box still has to be the one CSS lays out.
    return DsLineBox(style: style, child: Text(text, style: style));
  }
}
