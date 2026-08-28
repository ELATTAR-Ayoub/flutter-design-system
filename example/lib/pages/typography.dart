/// `/design-system/typography`: the Typography foundation page.
///
/// A transcript of `app/design-system/typography/page.tsx`: the two-face rule,
/// the ten word-scale specimens, the five numeric ones, the tabular argument,
/// the canonical pairings, the full `.prose` demo, and the rules.
///
/// **The drift this page is built on.** Every line of visible copy here names
/// *Space Grotesk* as the word face: the panel label, the rule note, the
/// pairing description, the second don't. The tokens say otherwise:
/// `--font-sans` is `"Inter Local"`, the woff2 behind it is genuinely Inter
/// Variable, and there is no Space Grotesk asset anywhere in the reference.
/// The recorded decision is *fonts follow tokens, copy follows the reference*:
/// this page renders [Fonts.sans] (Inter) and still says Space Grotesk,
/// exactly as the reference does. Two more of its own claims are kept the same
/// way: "Nine classes" over ten specimen rows, and `.type-micro` called "the
/// floor … never smaller" while `.type-tag` ships a step below it.
///
/// **One deliberate departure, added at the v0.0.1 public release.** The
/// transcript above is faithful, and it is also reachable by a public reader
/// who has no way to know that "Space Grotesk" is the reference's error
/// rather than this system's contract. A correction banner now sits at the
/// top of the page, pointing at `/docs/typeset`, which is canonical and reads
/// its values from the tokens. That banner adds height this page's parity
/// captures do not have: it is the one intentional difference, and it is here
/// rather than in the transcript so the specimens themselves stay comparable.
///
/// `Spec` is a page-local component in the reference, so [_Spec] is local here
/// too; `.prose` is a CSS layer with no component at all, so [_Prose] is this
/// file's own: a Flutter widget set carrying the rhythm of globals.css
/// L1322–1507 and nothing else.
library;

import 'dart:math' as math;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart';
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
import 'package:flutter/widgets.dart' as flutter show Table;

import '../kit.dart';
import '../nav.dart';

/// `lg:grid-cols-[15rem_1fr]`: the specimen row's left column.
///
/// 15rem is 240px, which is `--width-rail`; the reference writes the length
/// rather than the token, and they are the same measure.
const double _specColumn = LayoutWidths.rail;

/// The four figures both columns of the tabular demo print, in source order.
const List<String> _tabularValues = <String>[
  r'$1,240.00',
  r'$48.00',
  r'$7.15',
  r'$11,908.40',
];

/// `/design-system/typography`.
class TypographyPage extends StatelessWidget {
  const TypographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    // `findCategory("foundations", "typography")`: the header's copy is the
    // nav registry's, so the page cannot drift from the tree that links to it.
    final CategoryHit here = findCategory('foundations', 'typography');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        PageHeader(
          eyebrow: here.group.title,
          title: here.category.title,
          blurb: here.category.blurb,
          contents: here.category.contents,
        ),
        // See the library note: this page transcribes the reference, and the
        // reference's copy names a face it does not ship. Correcting the
        // transcript would make the page stop being one; leaving it alone
        // would let a public reader walk away with the wrong font name. So
        // the transcript stands and the correction sits above it.
        SizedBox(height: space(6)),
        const Alert(
          variant: AlertVariant.info,
          icon: Icon(IconGlyph.info),
          title: 'This page transcribes the reference, including its error',
          description:
              'The copy below names Space Grotesk as the word face. The '
              'tokens do not: --font-sans is Inter, and no Space Grotesk '
              'asset exists here or in the reference. Everything on this page '
              'renders in Inter. For the token contract, with values read '
              'from the tokens themselves, see Typeset under Docs.',
        ),
        SizedBox(height: space(6)),
        const _RuleSection(),
        const _WordScaleSection(),
        const _NumericScaleSection(),
        const _PairingSection(),
        const _ProseSection(),
        const Section(
          id: 'rules',
          title: 'Rules',
          child: DoDont(
            dos: <String>[
              'Always apply a .type-* or .type-num-* class — never a raw pixel size in a utility.',
              'Put numerical values in the Geist Mono type-num foundation so comparable figures stay tabular.',
              'Keep .type-micro as the absolute floor at 10.5px, and only for uppercase labels.',
              'Use .type-display once per screen at most, and only for hero or reveal moments.',
            ],
            donts: <String>[
              "Don't apply font families or numeric weights at the call site; choose a named foundation class.",
              "Don't add a third typeface for display; heavy Space Grotesk at tight tracking already carries the hero.",
              "Don't put important text below 12px, or inside decorative pack artwork.",
              "Don't use proportional figures anywhere money, odds or counts appear.",
            ],
          ),
        ),
        const PageFootNav(groupId: 'foundations', slug: 'typography'),
      ],
    );
  }
}

/* ── #rule ───────────────────────────────────────────────────────────────── */

/// The two faces, side by side, and the sentence that is the whole system.
class _RuleSection extends StatelessWidget {
  const _RuleSection();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Section(
      id: 'rule',
      title: 'Two foundation faces',
      description:
          'The whole type system is a single rule with no exceptions, which is '
          'what keeps it consistent across every screen and component.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Grid(
            sm: 2,
            children: <Widget>[
              Panel(
                // Says Space Grotesk; renders Inter. See the library note.
                label: 'Space Grotesk — words',
                child: _FaceSpecimen(
                  token: '--font-sans',
                  copy:
                      'Headings, body, buttons, labels, navigation, card names, '
                      'pack names. A geometric grotesk: technical enough to feel '
                      'engineered, open enough to stay readable at 11px.',
                  specimen: StyledText(
                    'Aa',
                    TextStyles.display,
                    fontSize: Fluid.display(context),
                    color: theme.foreground,
                  ),
                ),
              ),
              Panel(
                label: 'Geist Mono — numerical values',
                child: _FaceSpecimen(
                  token: '--font-mono',
                  copy:
                      'Prices, balances, dates, quantities, statistics, serials '
                      'and code. Numerical variants are tabular so aligned '
                      'values do not jitter.',
                  specimen: StyledText(
                    '0123',
                    TextStyles.numberXl,
                    color: theme.premiumText,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: space(4)),
          Note(
            title: 'The rule',
            child: RichText(
              TextSpan(
                children: <InlineSpan>[
                  const TextSpan(text: 'Words use Space Grotesk through '),
                  Code.span('.type-*'),
                  const TextSpan(
                    text: '. Numerical values use Geist Mono through ',
                  ),
                  Code.span('.type-num-*'),
                  const TextSpan(
                    text:
                        '. Each named foundation owns its complete font, '
                        'size, line-height, weight and tracking.',
                  ),
                ],
              ),
              TextStyles.small,
            ),
          ),
        ],
      ),
    );
  }
}

/// One face panel's body: the specimen, `mt-5` copy, `mt-4` token line.
class _FaceSpecimen extends StatelessWidget {
  const _FaceSpecimen({
    required this.specimen,
    required this.copy,
    required this.token,
  });

  final Widget specimen;
  final String copy;

  /// The CSS variable, in `.type-code text-muted-foreground`: the class sets
  /// no colour of its own, so the call site states one.
  final String token;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        specimen,
        SizedBox(height: space(5)),
        StyledText(copy, TextStyles.small),
        SizedBox(height: space(4)),
        StyledText(token, TextStyles.code, color: theme.mutedForeground),
      ],
    );
  }
}

/* ── Spec row ────────────────────────────────────────────────────────────── */

/// One specimen row: the class name and what it is for, beside a live sample.
///
/// `grid gap-4 border-b border-border px-6 py-7 last:border-b-0
/// lg:grid-cols-[15rem_1fr] lg:gap-8`: the hairline and the corner clipping
/// belong to the [DividedList] these are stacked in, so this is the cell
/// padding and the two-column split only.
class _Spec extends StatelessWidget {
  const _Spec({required this.cls, required this.use, required this.child});

  /// The class name **without** its leading dot: the reference writes
  /// `.{cls}`, so the dot is punctuation the row adds, not part of the name.
  final String cls;

  final String use;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final bool wide = MediaQuery.sizeOf(context).width >= Breakpoints.lg;

    final Widget meta = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StyledText('.$cls', TextStyles.code, color: theme.actionText),
        SizedBox(height: space(2)),
        StyledText(use, TextStyles.small),
      ],
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: space(6), vertical: space(7)),
      child: wide
          ? IntrinsicHeight(
              child: Row(
                // Grid cells stretch; the sample then centres itself inside
                // its own (`self-center`), while the meta column stays top-set.
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(width: _specColumn, child: meta),
                  SizedBox(width: space(8)),
                  Expanded(
                    child: Align(alignment: Alignment.centerLeft, child: child),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                meta,
                SizedBox(height: space(4)),
                child,
              ],
            ),
    );
  }
}

/* ── #words ──────────────────────────────────────────────────────────────── */

/// Ten classes under a description that says nine: the reference's own slack.
class _WordScaleSection extends StatelessWidget {
  const _WordScaleSection();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Section(
      id: 'words',
      title: 'Word scale',
      description:
          'Nine classes cover every piece of text in the product. Display is '
          'reserved for the landing hero and pack-opening moments — nothing '
          'else earns it.',
      child: DividedList(
        radius: Radii.xl,
        children: <Widget>[
          _Spec(
            cls: 'type-display',
            use: 'Landing hero. Pack-opening reveal. Once per page, at most.',
            child: StyledText(
              'Pull something legendary',
              TextStyles.display,
              fontSize: Fluid.display(context),
              color: theme.foreground,
            ),
          ),
          _Spec(
            cls: 'type-h1',
            use: 'The page heading. Exactly one per screen.',
            child: StyledText(
              'Pack Marketplace',
              TextStyles.h1,
              fontSize: Fluid.h1(context),
              color: theme.foreground,
            ),
          ),
          _Spec(
            cls: 'type-h2',
            use:
                'Major page sections — Featured Packs, Live Pulls, Top Grails.',
            child: StyledText(
              'Featured Packs',
              TextStyles.h2,
              color: theme.foreground,
            ),
          ),
          _Spec(
            cls: 'type-h3',
            use: 'Card titles, module headings, modal titles.',
            child: StyledText(
              'Eclipse Vault — Series I',
              TextStyles.h3,
              color: theme.foreground,
            ),
          ),
          _Spec(
            cls: 'type-h4',
            use: 'Pack names on cards, collectible card names, row titles.',
            child: StyledText(
              'Voidwing Ascendant',
              TextStyles.h4,
              color: theme.foreground,
            ),
          ),
          // The four rows below pass no colour: `.type-lead`, `.type-small`,
          // `.type-label` and `.type-micro` each declare muted-foreground on
          // themselves, and the reference overrides none of them here.
          _Spec(
            cls: 'type-lead',
            use: 'The sentence under a page heading. One per screen.',
            child: StyledText(
              'Every pack lists its odds, its remaining supply and its top '
              'possible hit before you spend anything.',
              TextStyles.lead,
            ),
          ),
          _Spec(
            cls: 'type-body',
            use: 'Standard interface copy, descriptions, dialog content.',
            child: StyledText(
              'Cards land in your Stash the moment a pack finishes opening. '
              'From there you can keep them, sell them back at the listed '
              'value, or add them to a shipment.',
              TextStyles.body,
              color: theme.mutedForeground,
            ),
          ),
          _Spec(
            cls: 'type-small',
            use: 'Helper text, secondary detail, table cells, filter labels.',
            child: StyledText(
              'Sell-back values are quoted at the time of sale and may move '
              'with the market.',
              TextStyles.small,
            ),
          ),
          _Spec(
            cls: 'type-label',
            use: 'Section eyebrows, panel labels, field labels, rarity names.',
            child: StyledText('Remaining supply', TextStyles.eyebrow),
          ),
          _Spec(
            cls: 'type-micro',
            use:
                'The floor. Badge text, pip captions, chart axes. Never smaller.',
            child: StyledText('Limited edition', TextStyles.eyebrowSmall),
          ),
        ],
      ),
    );
  }
}

/* ── #numbers ────────────────────────────────────────────────────────────── */

/// Five of the six numeric steps, then the argument for tabular figures.
class _NumericScaleSection extends StatelessWidget {
  const _NumericScaleSection();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Section(
      id: 'numbers',
      title: 'Numeric scale',
      description:
          "Five sizes, all tabular, all semibold. Numbers carry the product's "
          'meaning — what things cost and what they are worth — so they are '
          'given more weight than the words around them.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DividedList(
            radius: Radii.xl,
            children: <Widget>[
              _Spec(
                cls: 'type-num-xl',
                use:
                    'Wallet available balance. Total inventory value. Hero figures.',
                child: StyledText(
                  r'$12,480.65',
                  TextStyles.numberXl,
                  color: theme.foreground,
                ),
              ),
              _Spec(
                cls: 'type-num-lg',
                use:
                    'Card value in the inspection modal. Reward amounts. Stat tiles.',
                child: StyledText(
                  r'$1,240.00',
                  TextStyles.numberLg,
                  color: theme.premiumText,
                ),
              ),
              _Spec(
                cls: 'type-num-md',
                use: 'Pack price. Card value on a tile. Leaderboard points.',
                child: StyledText(
                  r'$48.00',
                  TextStyles.numberMd,
                  color: theme.premiumText,
                ),
              ),
              _Spec(
                cls: 'type-num',
                use: 'Table figures, transaction amounts, quantities, odds.',
                child: StyledText(
                  '1,284',
                  TextStyles.numberBase,
                  color: theme.foreground,
                ),
              ),
              _Spec(
                cls: 'type-num-sm',
                use:
                    'Timestamps, supply counters, token names, metadata figures.',
                child: StyledText(
                  '412 / 2,000',
                  TextStyles.numberSm,
                  color: theme.mutedForeground,
                ),
              ),
            ],
          ),
          SizedBox(height: space(4)),
          Panel(
            label: 'Why tabular matters',
            note: 'font-variant-numeric: tabular-nums',
            child: Grid(
              sm: 2,
              gap: space(6),
              children: <Widget>[
                _FigureColumn(
                  heading: 'Tabular — the product',
                  headingInk: theme.premiumText,
                  spec: TextStyles.numberBase,
                  valueColor: theme.foreground,
                  caption:
                      'Decimal points align. Digits keep their column as values '
                      'update live, so a ticking balance does not shuffle '
                      'sideways.',
                ),
                // The rejected column is not mono at all: `.type-section` is
                // the sans face at 13px/600/muted, so it differs in family,
                // size, weight, colour AND figure spacing. Proportional
                // figures are simply the absence of `tabular-nums`, which is
                // what every non-numeric spec already is.
                _FigureColumn(
                  heading: 'Proportional — rejected',
                  headingInk: theme.destructiveText,
                  spec: TextStyles.section,
                  caption:
                      'Proportional figures do not align, and every live update '
                      'nudges the layout.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One half of the tabular demo: a label, the four figures, a caption.
class _FigureColumn extends StatelessWidget {
  const _FigureColumn({
    required this.heading,
    required this.headingInk,
    required this.spec,
    required this.caption,
    this.valueColor,
  });

  final String heading;
  final Color headingInk;

  /// `.type-num` on the left, `.type-section` on the right.
  final TextStyleToken spec;

  /// Only the tabular column states one; the rejected column takes the muted
  /// colour `.type-section` brings with it.
  final Color? valueColor;

  final String caption;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StyledText(heading, TextStyles.eyebrow, color: headingInk),
        SizedBox(height: space(3)),
        for (int i = 0; i < _tabularValues.length; i++) ...<Widget>[
          // `space-y-1.5`.
          if (i > 0) SizedBox(height: space(1.5)),
          Container(
            padding: EdgeInsets.only(bottom: space(1.5)),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.border,
                  width: BorderWidths.hairline,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StyledText('Row', TextStyles.small),
                StyledText(_tabularValues[i], spec, color: valueColor),
              ],
            ),
          ),
        ],
        SizedBox(height: space(3)),
        StyledText(caption, TextStyles.small),
      ],
    );
  }
}

/* ── #pairing ────────────────────────────────────────────────────────────── */

/// Three cards where a word class and a numeric class meet.
class _PairingSection extends StatelessWidget {
  const _PairingSection();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Section(
      id: 'pairing',
      title: 'Pairing the foundations',
      description:
          'Words stay in Space Grotesk while numerical values use Geist Mono. '
          'The named classes carry each treatment without page-level '
          'typography values.',
      child: Panel(
        label: 'Canonical pairings',
        child: Grid(
          sm: 2,
          lg: 3,
          gap: space(5),
          children: <Widget>[
            _PairingCard(
              label: 'Pack price',
              figure: StyledText(
                r'$48.00',
                TextStyles.numberMd,
                color: theme.premiumText,
              ),
              caption: const TextSpan(text: '6 cards per pack'),
            ),
            _PairingCard(
              label: 'Available balance',
              figure: StyledText(
                r'$1,204.80',
                TextStyles.numberLg,
                color: theme.foreground,
              ),
              caption: TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: r'+$120.00',
                    style: TextStyle(color: theme.premiumText),
                  ),
                  const TextSpan(text: ' today'),
                ],
              ),
            ),
            _PairingCard(
              label: 'Legendary odds',
              figure: StyledText(
                '1 in 240',
                TextStyles.numberMd,
                color: theme.foreground,
              ),
              caption: const TextSpan(text: '0.42% per card'),
            ),
          ],
        ),
      ),
    );
  }
}

/// `rounded-lg border border-border bg-card p-5`.
class _PairingCard extends StatelessWidget {
  const _PairingCard({
    required this.label,
    required this.figure,
    required this.caption,
  });

  final String label;
  final Widget figure;

  /// An [InlineSpan] because one of the three tints a fragment value-ink.
  final InlineSpan caption;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Container(
      padding: EdgeInsets.all(space(5)),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StyledText(label, TextStyles.eyebrow),
          SizedBox(height: space(2)),
          figure,
          SizedBox(height: space(1)),
          RichText(caption, TextStyles.small),
        ],
      ),
    );
  }
}

/* ── #prose ──────────────────────────────────────────────────────────────── */

/// The same scale reached a second way, plus what `.prose` does and does not
/// own.
class _ProseSection extends StatelessWidget {
  const _ProseSection();

  /// `Meta`: six rows, verbatim.
  static const List<MetaItem> _meta = <MetaItem>[
    (
      k: 'What it owns',
      v: TextSpan(
        text:
            'Vertical rhythm on the 8-point scale, list markers and indents, '
            'link treatment, quote rule, and code and table chrome.',
      ),
    ),
    (
      k: 'Anchors',
      v: TextSpan(
        text:
            'Nothing. html carries scroll-padding-block-start: '
            'var(--scroll-offset), derived from --height-site-header. A '
            'scroll-margin here as well would add to it — measured at 192px '
            'below a 64px header before it was removed.',
      ),
    ),
    (
      k: 'Wide tables scroll',
      v: TextSpan(
        text:
            'A table is display:block with width:max-content capped at 100%, '
            "so it is its own scroll port on the system's thin rail. It takes "
            'content width rather than filling the measure — the trade for '
            'never being clipped, which is what happened at 375px before the '
            'rule existed.',
      ),
    ),
    (
      k: 'What it does not own',
      v: TextSpan(
        text:
            'Sizes. Every one lives in the .type-* role it shares a '
            'declaration block with. It also sets no max-width — the measure '
            'belongs to the page container, and two owners for one number is '
            'how --width-page spent months as prose on the Spacing page.',
      ),
    ),
    (
      k: '--width-prose',
      v: TextSpan(
        text:
            '720px. Narrower than --width-content (1080px) because that '
            'column carries specimens and panels beside the copy, while this '
            'one carries nothing but sentences.',
      ),
    ),
    (
      k: 'Headings start at h2',
      v: TextSpan(
        text:
            "The page heading is the page's own h1. .prose styles h1 anyway, "
            'because an unstyled browser default is worse than a heading level '
            'used wrongly — but a document that opens with h2 is the '
            'convention.',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // `bodyClassName="p-6 sm:p-10"`.
    final bool wide = MediaQuery.sizeOf(context).width >= Breakpoints.sm;

    return Section(
      id: 'prose',
      title: 'Prose',
      description:
          'The same scale, reached a second way. A policy, a help article or '
          'the output of a markdown renderer has no call site to put a class '
          'on, so .prose styles the elements instead — and it does it by '
          'adding a selector to the type roles above rather than by owning a '
          'second set of sizes.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Panel(
            label: 'Long-form content',
            note: 'max-w-(--width-prose) · 720px',
            bodyPadding: EdgeInsets.all(wide ? space(10) : space(6)),
            child: Align(
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                // `max-w-(--width-prose)`: the measure, stated once.
                constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
                child: const _Prose(),
              ),
            ),
          ),
          SizedBox(height: space(4)),
          const Meta(items: _meta),
          SizedBox(height: space(4)),
          Note(
            tone: NoteTone.error,
            title: 'Two mechanisms that do not work',
            child: RichText(
              TextSpan(
                children: <InlineSpan>[
                  Code.span('@apply type-h2'),
                  const TextSpan(text: ' inside a '),
                  Code.span('.prose h2'),
                  const TextSpan(text: ' rule fails the build outright — '),
                  const TextSpan(
                    text: 'Cannot apply unknown utility class',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const TextSpan(text: ' — because '),
                  Code.span('@apply'),
                  const TextSpan(text: ' reaches Tailwind utilities and '),
                  Code.span('@utility'),
                  const TextSpan(
                    text: ' registrations, and the type scale lives in ',
                  ),
                  Code.span('@layer components'),
                  const TextSpan(text: '. The call-site spelling '),
                  Code.span('[&_h2]:type-h2'),
                  const TextSpan(
                    text: ' is the same wall from the other side and fails ',
                  ),
                  const TextSpan(
                    text: 'silently',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const TextSpan(
                    text:
                        ', which is the worse of the two: no error, no class, '
                        'every guard green, and the size quietly falling back '
                        'to inherited.',
                  ),
                ],
              ),
              TextStyles.small,
            ),
          ),
        ],
      ),
    );
  }
}

/* ── The prose widget set ────────────────────────────────────────────────── */

/// One block-level element and the `margin-block` its selector declares.
typedef _ProseBlock = ({double top, double bottom, Widget child});

/// `<div class="prose">`: unclassed markup, styled by element.
///
/// Every value below is globals.css L1322–1507 (globals-map §6). Two CSS
/// behaviours have to be performed rather than declared:
///
/// * **Margin collapsing.** Adjacent block margins collapse to the larger of
///   the two, so a `p` (16px bottom) before an `h3` (32px top) is separated by
///   32px, not 48. [_column] inserts `max(previous.bottom, next.top)` between
///   blocks: and nothing before the first or after the last, which is the
///   `> :first-child` / `> :last-child` reset.
/// * **List markers.** `list-style-position: outside` puts the marker in the
///   list's `padding-inline-start`, so each item is a 24px gutter carrying a
///   right-set marker beside its content.
class _Prose extends StatelessWidget {
  const _Prose();

  /// Stacks [blocks] with their margins collapsed.
  static Widget _column(List<_ProseBlock> blocks) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      for (int i = 0; i < blocks.length; i++) ...<Widget>[
        if (i > 0)
          SizedBox(height: math.max(blocks[i - 1].bottom, blocks[i].top)),
        blocks[i].child,
      ],
    ],
  );

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    // `.prose { color: var(--foreground) }`: inherited by every element that
    // does not state a colour, which is all of them but the blockquote.
    final TextStyle paragraph = StyledText.styleOf(
      context,
      TextStyles.body,
      color: theme.foreground,
    );

    return _column(<_ProseBlock>[
      // h2, `margin-block: 40px 16px`.
      (
        top: space(10),
        bottom: space(4),
        child: StyledText(
          'Refunds and cancellations',
          TextStyles.h2,
          color: theme.foreground,
        ),
      ),
      // p, `margin-block: 16px`.
      (
        top: space(4),
        bottom: space(4),
        child: RichText(
          TextSpan(
            children: <InlineSpan>[
              const TextSpan(
                text: 'Every element here is unstyled markup inside a single ',
              ),
              Code.span('prose'),
              const TextSpan(
                text:
                    ' wrapper. The heading above is the same declaration '
                    'block as ',
              ),
              Code.span('.type-h2'),
              const TextSpan(
                text:
                    ' — not a copy of its size, the block itself — so '
                    'retuning the scale moves both and neither can drift from '
                    'the other.',
              ),
            ],
          ),
          TextStyles.body,
          color: theme.foreground,
        ),
      ),
      (top: space(4), bottom: space(4), child: const _ProseLinkParagraph()),
      // h3, `margin-block: 32px 12px`.
      (
        top: space(8),
        bottom: space(3),
        child: StyledText(
          'What a reader is entitled to',
          TextStyles.h3,
          color: theme.foreground,
        ),
      ),
      (
        top: space(4),
        bottom: space(4),
        child: _ProseList(
          style: paragraph,
          items: <_ProseListItem>[
            (text: 'A refund within fourteen days of purchase.', nested: null),
            (
              // The reference's JSX puts the nested list straight after the
              // text with no space and no full stop: kept.
              text: 'A written reason when a request is refused, including',
              nested: <String>[
                'the clause it was refused under, and',
                'the address an appeal goes to.',
              ],
            ),
            (text: 'A reply inside one working week.', nested: null),
          ],
        ),
      ),
      (
        top: space(4),
        bottom: space(4),
        child: _ProseQuote(
          'Nested lists take the interior step rather than the block step, so '
          'a sub-clause reads as part of its parent rather than as a new '
          'paragraph.',
        ),
      ),
      (
        top: space(8),
        bottom: space(3),
        child: StyledText(
          'Ordered steps',
          TextStyles.h3,
          color: theme.foreground,
        ),
      ),
      (
        top: space(4),
        bottom: space(4),
        child: _ProseList(
          ordered: true,
          style: paragraph,
          items: const <_ProseListItem>[
            (text: 'Open the order from your account.', nested: null),
            (text: 'Choose the items you are returning.', nested: null),
            (
              text: 'Print the label and post it within seven days.',
              nested: null,
            ),
          ],
        ),
      ),
      // h4, `margin-block: 24px 8px`. The override demo: an `h4` carrying
      // `.type-label`, so it renders 11px uppercase muted, not 17px foreground.
      // `:where(.prose) h4` weighs one element; the class beats it.
      (
        top: space(6),
        bottom: space(2),
        child: StyledText(
          'An explicit class still wins inside prose',
          TextStyles.eyebrow,
        ),
      ),
      (
        top: space(4),
        bottom: space(4),
        child: RichText(
          TextSpan(
            children: <InlineSpan>[
              const TextSpan(text: 'That heading is an '),
              Code.span('h4'),
              const TextSpan(text: ' carrying '),
              Code.span('.type-label'),
              const TextSpan(text: '. The prose selector is wrapped in '),
              Code.span(':where()'),
              const TextSpan(
                text:
                    ', so it weighs one element and any real class beats '
                    'it — ',
              ),
              Code.span('.prose'),
              const TextSpan(text: ' is a default, not a cage.'),
            ],
          ),
          TextStyles.body,
          color: theme.foreground,
        ),
      ),
      // hr, `margin-block: 40px; border: 0; border-block-start: 1px solid
      // var(--border)`.
      (
        top: space(10),
        bottom: space(10),
        child: SizedBox(
          height: BorderWidths.hairline,
          child: ColoredBox(color: theme.border),
        ),
      ),
      (top: space(4), bottom: space(4), child: const _ProseTable()),
    ]);
  }
}

/// The one paragraph with a link in it: and the page's one prose animation.
///
/// `:where(.prose) a` is action-ink and underlined at rest; hover fades
/// `text-decoration-color` to transparent over 150ms on `--ease-out`. The href
/// is `#prose`, so the tap scrolls this very section back under the header.
class _ProseLinkParagraph extends StatefulWidget {
  const _ProseLinkParagraph();

  @override
  State<_ProseLinkParagraph> createState() => _ProseLinkParagraphState();
}

class _ProseLinkParagraphState extends State<_ProseLinkParagraph> {
  late final TapGestureRecognizer _tap;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _tap = TapGestureRecognizer()..onTap = () => Section.scrollTo('prose');
  }

  @override
  void dispose() {
    _tap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: _hovered ? transparent : theme.actionText),
      duration: effectiveMotionDuration(context, MotionDurations.fast),
      curve: MotionCurves.enter,
      builder: (BuildContext context, Color? underline, Widget? child) {
        return RichText(
          TextSpan(
            children: <InlineSpan>[
              const TextSpan(text: 'Links take '),
              Code.span('--color-action-ink'),
              const TextSpan(
                text:
                    ', which is the only shade of the action ramp that reads '
                    'in both themes, and they are underlined at rest because ',
              ),
              TextSpan(
                text: 'a link identified by hue alone',
                style: TextStyle(
                  color: theme.actionText,
                  decoration: TextDecoration.underline,
                  decorationColor: underline,
                ),
                recognizer: _tap,
                mouseCursor: SystemMouseCursors.click,
                onEnter: (PointerEnterEvent event) =>
                    setState(() => _hovered = true),
                onExit: (PointerExitEvent event) =>
                    setState(() => _hovered = false),
              ),
              const TextSpan(
                text:
                    ' is one signal where the accessibility contract asks '
                    'for two.',
              ),
            ],
          ),
          TextStyles.body,
          color: theme.foreground,
        );
      },
    );
  }
}

/// One `<li>`: its text, and the nested list it may carry.
typedef _ProseListItem = ({String text, List<String>? nested});

/// `<ul>` / `<ol>`: disc or decimal markers in a 24px gutter.
class _ProseList extends StatelessWidget {
  const _ProseList({
    required this.items,
    required this.style,
    this.ordered = false,
  });

  final List<_ProseListItem> items;

  /// The `.type-body` style the items and their markers share.
  final TextStyle style;

  final bool ordered;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    // `li::marker { color: var(--muted-foreground) }`.
    final TextStyle marker = style.copyWith(color: theme.mutedForeground);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int i = 0; i < items.length; i++) ...<Widget>[
          // `li + li { margin-block-start: 8px }`.
          if (i > 0) SizedBox(height: space(2)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                // `padding-inline-start: 24px` on the list: the marker sits
                // inside it, set against the content edge.
                width: space(6),
                child: Padding(
                  padding: EdgeInsets.only(right: space(2)),
                  child: LineBox(
                    style: marker,
                    child: Text(
                      ordered ? '${i + 1}.' : '•',
                      style: marker,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    LineBox(
                      style: style,
                      child: Text(items[i].text, style: style),
                    ),
                    if (items[i].nested != null) ...<Widget>[
                      // Nested `li > ul { margin-block: 8px }`.
                      SizedBox(height: space(2)),
                      _ProseList(
                        style: style,
                        items: <_ProseListItem>[
                          for (final String text in items[i].nested!)
                            (text: text, nested: null),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// `<blockquote>`: the `--input` hairline, the interior step, muted italic.
class _ProseQuote extends StatelessWidget {
  const _ProseQuote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    // `blockquote`, `.type-body`, muted and italic.
    final TextStyle quote = StyledText.styleOf(
      context,
      TextStyles.body,
      color: theme.mutedForeground,
    ).copyWith(fontStyle: FontStyle.italic);

    return Container(
      padding: EdgeInsets.only(left: space(4)),
      decoration: BoxDecoration(
        border: Border(
          // `border-inline-start: 2px solid var(--input)`: the stronger
          // hairline, at double width.
          left: BorderSide(color: theme.input, width: space(0.5)),
        ),
      ),
      child: LineBox(
        style: quote,
        child: Text(text, style: quote),
      ),
    );
  }
}

/// `<table>`, `display:block; width:max-content; max-width:100%;
/// overflow-x:auto`.
///
/// It is its own scroll port: [IntrinsicWidth] gives the [Table] the finite
/// width it requires inside a horizontal viewport, and the viewport then takes
/// the smaller of that width and the measure: content width when it fits,
/// a scroller when it does not.
class _ProseTable extends StatelessWidget {
  const _ProseTable();

  static const List<String> _head = <String>[
    'Request',
    'Window',
    'Refunded to',
  ];

  static const List<List<String>> _rows = <List<String>>[
    <String>['Unopened item', '14 days', 'Original payment method'],
    <String>['Faulty item', '30 days', 'Original payment method'],
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    Widget cell(Widget child) => Container(
      // `padding: 12px 16px`.
      padding: EdgeInsets.symmetric(horizontal: space(4), vertical: space(3)),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.border, width: BorderWidths.hairline),
        ),
      ),
      child: child,
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: flutter.Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            defaultVerticalAlignment: TableCellVerticalAlignment.top,
            children: <TableRow>[
              TableRow(
                // `th { background: var(--muted) }`, plus the `.type-label`
                // treatment `:where(.prose) th` shares with it.
                decoration: BoxDecoration(color: theme.muted),
                children: <Widget>[
                  for (final String head in _head)
                    cell(StyledText(head, TextStyles.eyebrow)),
                ],
              ),
              for (final List<String> row in _rows)
                TableRow(
                  children: <Widget>[
                    for (final String value in row)
                      cell(
                        StyledText(
                          value,
                          TextStyles.body,
                          color: theme.foreground,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
