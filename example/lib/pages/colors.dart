/// `/design-system/colors` — the whole colour system on one page, and nothing
/// else (`app/design-system/colors/page.tsx`).
///
/// The reference's premise is *measured, not asserted*: no hex on this page is
/// typed by hand and no contrast claim is written down. The engine that reads
/// the live theme and does the WCAG arithmetic lives in `token_swatch.dart`;
/// this file is the page itself — its copy, and the order it runs in.
/// Eighteen swatches across four ramps, four notes, two panels naming the two
/// things this system refuses to express as a colour, and the foot nav.
///
/// Every string is verbatim from the reference, including the copy that
/// disagrees with what the page then measures (colors-map §12): the muted
/// foreground note says "about 13:1" where the badge above it computes 13.5,
/// the accent row claims an alias that only holds on dark, and the state note
/// ships the doubled word "in the same same row" — JSX collapses the line
/// break, so that is what a reader sees. The header's chips are the page's own
/// five, not the nav registry's eight.
///
/// The page is assembled out of the kit and the swatch engine only. It has no
/// local components, no ramp or gradient specimens, and no interactions —
/// the only things that move on it are the chrome's theme toggle and the two
/// links at the very bottom.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';
import '../nav.dart';
import '../token_swatch.dart';

/// `const { group, category } = findCategory("foundations", "colors")`.
///
/// The header's eyebrow and title come from the nav registry rather than from
/// this file, so a page cannot end up named one thing in the sidebar and
/// another at the top of itself. The blurb and the chips below are the page's
/// own — the registry's differ, and that drift is the reference's (§12.1).
final DsCategoryHit _here = findCategory('foundations', 'colors');

/* ── The four ramps, as the reference declares them ──────────────────────── */

/// `#monochrome` — six steps on shadcn's own token names.
///
/// The first four are pure fills: nothing is ever written in `--background`,
/// `--card`, `--muted` or `--accent`, so a ratio for them would be a number
/// without a question, and the reference passes `measure: false`.
const List<Widget> _monochrome = <Widget>[
  DsTokenSwatch(
    token: '--background',
    name: 'Background',
    use: 'The page. White on light, zinc 950 on dark. Utility: bg-background.',
    measure: false,
  ),
  DsTokenSwatch(
    token: '--card',
    name: 'Card',
    use: 'Containers. Aliased by --popover and --sidebar. '
        'Utilities: bg-card, bg-popover.',
    measure: false,
  ),
  DsTokenSwatch(
    token: '--muted',
    name: 'Muted',
    use: 'Fills and hairlines. Aliased by --secondary and --border. '
        'Utilities: bg-muted, border-border.',
    measure: false,
  ),
  DsTokenSwatch(
    token: '--accent',
    name: 'Accent',
    use: 'Hover surfaces and stronger borders. Aliased by --input. '
        'Utilities: bg-accent, border-input.',
    measure: false,
  ),
  DsTokenSwatch(
    token: '--foreground',
    name: 'Foreground',
    use: 'All primary text. Utility: text-foreground.',
  ),
  DsTokenSwatch(
    token: '--muted-foreground',
    name: 'Muted foreground',
    use: 'Secondary text, metadata, helper copy. The one step that is not a '
        'mirror between themes — see the note below. '
        'Utility: text-muted-foreground.',
  ),
];

/// `#action` — the ink first, then the three ends of the ramp.
const List<Widget> _action = <Widget>[
  DsTokenSwatch(
    token: '--color-action-ink',
    name: 'Action ink',
    use: 'The text-safe end, resolved for whichever theme you are in. The ONLY '
        'action colour allowed on text, icons and links. '
        'Utility: text-action-ink.',
  ),
  DsTokenSwatch(
    token: '--color-action-bright',
    name: 'Action bright',
    use: 'The lifted end. Ink on dark, and the focus ring there. Illegible as '
        'text on light — never name it directly.',
  ),
  DsTokenSwatch(
    token: '--color-action',
    name: 'Action',
    use: 'The fill. Drives --primary: buttons, selection, active nav. Never '
        'carries a glyph — put text-primary-foreground on top.',
  ),
  DsTokenSwatch(
    token: '--color-action-dark',
    name: 'Action dark',
    use: "The deep end. Ink on light, plus gradient floors and the foil ramp's "
        'base.',
  ),
];

/// `#value` — ink, mid, bright, dark.
///
/// The order is not the action ramp's: mid comes second here and last-but-one
/// there. Kept as shipped.
const List<Widget> _value = <Widget>[
  DsTokenSwatch(
    token: '--color-value-ink',
    name: 'Value ink',
    use: 'The text-safe end, resolved per theme. Every figure, label and glyph '
        'that means worth.',
  ),
  DsTokenSwatch(
    token: '--color-value',
    name: 'Value',
    use: 'Balances, rankings, premium actions, reward surfaces.',
  ),
  DsTokenSwatch(
    token: '--color-value-bright',
    name: 'Value bright',
    use: "Reward moments and the foil gradient's top stop.",
  ),
  DsTokenSwatch(
    token: '--color-value-dark',
    name: 'Value dark',
    use: 'Foil gradient floor, and ink on light.',
  ),
];

/// `#state` — four meanings, fixed.
///
/// Three of the four are `@theme static` hues; the fourth queries the semantic
/// `--destructive`, which is shadcn's own and the only one of the four with a
/// theme block behind it.
const List<Widget> _state = <Widget>[
  DsTokenSwatch(
    token: '--color-success',
    name: 'Success',
    use: 'Completed, cleared, live, gained. Emerald rather than a plain green, '
        'to open a gap against lime.',
  ),
  DsTokenSwatch(
    token: '--color-warning',
    name: 'Warning',
    use: 'Pending, needs attention, purchase limit approaching.',
  ),
  DsTokenSwatch(
    token: '--color-info',
    name: 'Information',
    use: 'Neutral notices and explainers. Cyan rather than blue, so a notice '
        'cannot be mistaken for the brand.',
  ),
  DsTokenSwatch(
    token: '--destructive',
    name: 'Destructive',
    use: "shadcn's own. Deletes, failed payments, validation errors.",
  ),
];

/* ── The page ────────────────────────────────────────────────────────────── */

class ColorsPage extends StatelessWidget {
  const ColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPageHeader(
          eyebrow: _here.group.title,
          title: _here.category.title,
          blurb: 'Zinc for everything structural, blue for action, lime for '
              'worth, four state colours, and nothing else. Two roles, two '
              'themes, and every value on this page measured rather than '
              'claimed.',
          // The page's own list — the nav registry's eight are what the
          // sidebar and the index card show (colors-map §12).
          contents: const <String>[
            'Monochrome',
            'Action ramp',
            'Value ramp',
            'State',
            'What is not a token',
          ],
        ),

        // `Note … className="mb-12"`, before any section.
        Padding(
          padding: EdgeInsets.only(bottom: ds(12)),
          child: DsNote(
            title: 'Measured, not asserted',
            child: DsRichText(
              TextSpan(
                children: <InlineSpan>[
                  const TextSpan(
                    text: 'Every value below is read from the live stylesheet '
                        'and every contrast ratio is computed from it at '
                        'runtime. Nothing on this page is typed by hand, so it '
                        'cannot disagree with ',
                  ),
                  DsCode.span('app/globals.css'),
                  const TextSpan(
                    text: ' — and it re-measures when you flip the theme, so '
                        'the ratios you are reading are the ratios for the '
                        'mode you are actually in. The rules that govern all '
                        'of it live in ',
                  ),
                  DsCode.span('RULES.md'),
                  const TextSpan(text: '.'),
                ],
              ),
              DsType.small,
            ),
          ),
        ),

        DsSection(
          id: 'monochrome',
          title: 'Monochrome — zinc',
          description: "Six steps on shadcn's own token names, read downward "
              'on light and upward on dark. There is no second naming system.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DsTokenSwatchList(rows: _monochrome),
              SizedBox(height: ds(4)), // `mt-4`
              DsNote(
                tone: DsNoteTone.value,
                title: 'The one step that is not a mirror',
                child: DsRichText(
                  TextSpan(
                    children: <InlineSpan>[
                      const TextSpan(
                        text: 'Every other neutral inverts cleanly between the '
                            'two themes. Muted foreground does not. On dark it '
                            'is zinc 300, which measures about 13:1; the '
                            'mirror image would be zinc 400 on white, which '
                            'measures 3.1:1 and fails AA outright. Nor is it '
                            'zinc 500, which this system shipped for a long '
                            'time: that clears AA on ',
                      ),
                      DsCode.span('--background'),
                      const TextSpan(text: ' and misses it on '),
                      DsCode.span('--muted'),
                      const TextSpan(
                        text: ' by a tenth of a point — and muted text on a '
                            'muted fill is the most repeated pair in the whole '
                            'system. Light sits one step deeper than zinc 500 '
                            'so both pairs clear. Flip the theme and watch the '
                            'ratio above: it stays legal in both, and it gets '
                            'there by different means.',
                      ),
                    ],
                  ),
                  DsType.small,
                ),
              ),
            ],
          ),
        ),

        DsSection(
          id: 'action',
          title: 'Action — the thing that acts',
          description: 'Buttons, links, focus, selection, the agent. It '
              'answers one question: can I act on this, or is this the thing I '
              'picked? It is a blue today; it has been purple and wine before, '
              'and no component knew.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DsTokenSwatchList(rows: _action),
              SizedBox(height: ds(4)),
              DsNote(
                title: 'One text-safe shade per theme — and it is not the same '
                    'shade',
                child: DsRichText(
                  TextSpan(
                    children: <InlineSpan>[
                      const TextSpan(
                        text: 'The ratios above are measured live, so flip the '
                            'theme and watch them trade places. On dark, ',
                      ),
                      DsCode.span('--color-action-bright'),
                      const TextSpan(
                        text: ' clears AA and the deep end fails. On light it '
                            'is exactly reversed. A component cannot know '
                            'which surface it is sitting on, so it never names '
                            'either end — it writes ',
                      ),
                      DsCode.span('text-action-ink'),
                      const TextSpan(
                        text: ', and the theme block answers. The mid shade is '
                            'a fill in both themes and can never carry a '
                            'glyph; put ',
                      ),
                      DsCode.span('text-primary-foreground'),
                      const TextSpan(text: ' on top of it.'),
                    ],
                  ),
                  DsType.small,
                ),
              ),
            ],
          ),
        ),

        // The one section with no note: the value ramp follows the action
        // ramp's rule, and the reference does not restate it.
        const DsSection(
          id: 'value',
          title: 'Value — the thing that is worth something',
          description: 'Balances, rankings, rewards, premium actions. Nothing '
              'else. It is lime today, and it follows the same ink rule the '
              'action ramp does.',
          child: DsTokenSwatchList(rows: _value),
        ),

        DsSection(
          id: 'state',
          title: 'State',
          description: 'Four meanings, fixed. Two of them moved when the brand '
              'did, and both moves were forced rather than aesthetic.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DsTokenSwatchList(rows: _state),
              SizedBox(height: ds(4)),
              DsNote(
                tone: DsNoteTone.value,
                title: 'Why info is cyan and success is emerald',
                // "in the same same row" — the source breaks the line between
                // the two, JSX collapses it, and the doubled word ships.
                child: DsText(
                  'A state colour has one job: to be unmistakable for anything '
                  'else on the screen. Information used to be blue 400, which '
                  'stopped working the moment action became blue — a neutral '
                  'notice read as a promotion. Success used to be green 400, a '
                  'few degrees from lime, which is too close when a completed '
                  'sale and a valuable one appear in the same same row. '
                  'Warning did not move and gained separation for free: it is '
                  'amber, and lime sits forty degrees away from it, where the '
                  'old value hue sat almost on top of it. That collision is '
                  'the one this rebrand fixed by accident.',
                  DsType.small,
                ),
              ),
            ],
          ),
        ),

        DsSection(
          id: 'beyond',
          title: 'What is deliberately not a colour token',
          description: 'Two things this system refuses to express as a colour, '
              'because a colour is the wrong tool for both.',
          child: DsGrid(
            sm: 2,
            children: <Widget>[
              DsPanel(
                label: 'Texture',
                child: DsRichText(
                  TextSpan(
                    style: DsText.styleOf(context, DsType.small),
                    children: <InlineSpan>[
                      const TextSpan(
                        text: 'A surface that has to feel rare, precious or '
                            'alive is a ',
                      ),
                      // `<em>` — the browser slants the same face; so does
                      // Flutter, and neither has a real italic Inter.
                      const TextSpan(
                        text: 'texture',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      const TextSpan(
                        text: ', not a hue — a moving gradient, a foil ramp, '
                            'an iridescent bloom. Those live in ',
                      ),
                      DsCode.span('globals.css'),
                      const TextSpan(text: ' as utilities ('),
                      DsCode.span('foil-value'),
                      const TextSpan(text: ', '),
                      DsCode.span('bloom-cosmic'),
                      const TextSpan(text: ', '),
                      DsCode.span('sheen-action'),
                      const TextSpan(
                        text: ') and are built from the two ramps above, so '
                            'they follow a rebrand without carrying colour '
                            'tokens of their own.',
                      ),
                    ],
                  ),
                  DsType.small,
                ),
              ),
              DsPanel(
                label: 'Meaning',
                child: DsText(
                  'Nothing may be communicated by colour alone. A state ships '
                  'its glyph and its label as well as its hue; a status ships '
                  'its sentence. The four state colours above are a second '
                  'signal on top of a first one, never the only one — which is '
                  'also what keeps this system legible when both themes and '
                  'every form of colour-blindness are accounted for.',
                  DsType.small,
                ),
              ),
            ],
          ),
        ),

        // Colors is index 0 of foundations: no previous, next is Typography.
        const DsPageFootNav(groupId: 'foundations', slug: 'colors'),
      ],
    );
  }
}
