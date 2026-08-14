/// `/design-system` — the overview page (`app/design-system/page.tsx`).
///
/// The index of the whole system, and the only page in the tree that carries no
/// specimens: a header, the six foundations as index cards, the three component
/// families as larger group cards, the six rules that outrank taste, and a
/// closing scope note.
///
/// Nothing here retypes a card's copy. The reference maps `DS_GROUPS` straight
/// into the grids — titles, blurbs and chip lists all come out of
/// `lib/ds/nav.ts` — so this page reads [dsGroups] for exactly the same reason:
/// a card that disagreed with the sidebar would be the drift that file exists
/// to prevent. The only strings authored here are the ones the reference itself
/// authors inline: the header, the three section headings, and the rules.
///
/// Copy is verbatim, drift included — rule 4 names **Space Grotesk** while the
/// tokens load Inter (fonts follow tokens, copy follows the reference).
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';
import '../nav.dart';

/// One row of the `#rules` list: the bold lead sentence, then its detail.
typedef _Rule = ({String lead, String detail});

/// `const foundations = DS_GROUPS.find((g) => g.id === "foundations")!`.
final DsGroup _foundations = dsGroupById('foundations');

/// `const componentGroups = DS_GROUPS.filter((g) => g.id !== "foundations")` —
/// base, agent, site, in the registry's order.
final List<DsGroup> _componentGroups = dsGroups
    .where((DsGroup group) => group.id != _foundations.id)
    .toList(growable: false);

/// The six non-negotiables, verbatim from the reference's inline array.
const List<_Rule> _rules = <_Rule>[
  (
    lead: 'Two complete themes.',
    detail:
        'Dark is the default, and light is equally supported. Roughly 70% of any screen is neutral surface from the five-step ladder, 20% blue, 10% lime.',
  ),
  (
    lead: 'Blue acts, lime values.',
    detail:
        'Blue is interaction: primary buttons, selection, active nav, focus. Lime is worth: balances, rewards, rankings, premium actions. Never swap them.',
  ),
  (
    lead: 'Glow is rationed.',
    detail:
        'Only selected packs, rare cards, primary CTAs, opening moments and reward moments may glow. Ordinary surfaces stay flat and readable.',
  ),
  // The typeface drift, kept: the copy says Space Grotesk, the token says
  // Inter, and this page renders both — these words, in that face.
  (
    lead: 'Two faces only.',
    detail:
        'Space Grotesk for words. Geist Mono, tabular, for numerical values, serials and code through the named typography foundations.',
  ),
  (
    lead: 'Rarity is never color alone.',
    detail:
        'Every rarity indicator carries its label and tier pips as well as its hue, so it survives grayscale and color blindness.',
  ),
  (
    lead: 'Nothing unskippable.',
    detail:
        'The pack-opening sequence may be long, but skip and turbo are always reachable, and reduced-motion preferences are honoured.',
  ),
];

/// The page. A fragment in the reference (`<>…</>`), so it is a plain column
/// here: the shell owns the gutter, the measure and the scrolling.
class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // No `contents`: this is the one header in the tree that renders no
        // chip row.
        const DsPageHeader(
          eyebrow: "Elattar's Design System",
          title: 'Design System',
          blurb:
              'The operating manual. Two brand roles named for what they mean rather than what they look like, two complete themes, and every value measured out of the live stylesheet rather than claimed. Everything here is a live component, not a picture of one.',
        ),
        DsSection(
          id: 'foundations',
          title: 'Foundations',
          description:
              'The decisions everything else inherits. Change something here and it propagates through every base component and the entire agent console.',
          // `grid gap-4 sm:grid-cols-2 xl:grid-cols-3`.
          child: DsIndexGrid(
            children: <Widget>[
              for (final DsCategory category in _foundations.categories)
                DsIndexCard(
                  href: categoryHref(_foundations, category),
                  title: category.title,
                  blurb: category.blurb,
                  contents: category.contents,
                ),
            ],
          ),
        ),
        DsSection(
          id: 'components',
          title: 'Components',
          description:
              'Three families, deliberately separated. Base is the generic chassis any product could use. Agent is a complete AI console, written from scratch and pointed at a transport you supply. Site pages own no visual values of their own — only the composition rules that assemble the other two into a page.',
          // `grid gap-4 md:grid-cols-2` — the third card wraps to the left cell
          // of row two.
          child: DsGrid(
            base: 1,
            md: 2,
            gap: ds(4),
            children: <Widget>[
              for (final DsGroup group in _componentGroups)
                DsIndexCard.group(
                  href: group.href,
                  // `{group.categories.length} sets` — counted, never typed.
                  label: '${group.categories.length} sets',
                  title: group.title,
                  blurb: group.blurb,
                  contents: <String>[
                    for (final DsCategory category in group.categories)
                      category.title,
                  ],
                ),
            ],
          ),
        ),
        DsSection(
          id: 'rules',
          title: 'The rules that outrank taste',
          description:
              'Six non-negotiables. If a screen breaks one of these, the screen is wrong — not the rule.',
          // `ol.divide-y.divide-border.overflow-hidden.rounded-xl.border.bg-card`
          // — one card, hairlines between the rows and none at its edges.
          child: DsDividedList(
            radius: DsRadii.xl,
            children: <Widget>[
              for (int i = 0; i < _rules.length; i++)
                _RuleRow(
                  // `String(i + 1).padStart(2, "0")`.
                  number: '${i + 1}'.padLeft(2, '0'),
                  rule: _rules[i],
                ),
            ],
          ),
        ),
        // Outside every section: no `mb-20`, just the last child of the page.
        DsNote(
          tone: DsNoteTone.value,
          title: 'Scope of this phase',
          child: DsText(
            'This is the design system and component library. The ten product screens are built on top of it and are tracked separately — nothing in here implements a real wallet, payment, blockchain or shipping integration. All figures, packs, cards and users are placeholder data.',
            DsType.small,
          ),
        ),
      ],
    );
  }
}

/// `li.flex.gap-5.px-6.py-5` — a zero-padded serial beside its rule.
class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.number, required this.rule});

  /// `01`–`06`, `.type-num-sm text-action-ink`.
  final String number;

  final _Rule rule;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    // `<strong class="font-semibold text-foreground">` inside a
    // `.type-small` paragraph: the paragraph's own family, size and leading,
    // lifted to the semibold step. `.type-section` is that step at this exact
    // size, so its axis is the token rather than a number typed here.
    final TextStyle strong = DsText.styleOf(
      context,
      DsType.small,
      color: theme.foreground,
    ).copyWith(
      fontWeight: DsType.section.weight,
      fontVariations: DsType.section.variations,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ds(6), vertical: ds(5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // `shrink-0` — the serial keeps its width, the copy takes the slack.
          DsText(number, DsType.numSm, color: theme.actionInk),
          SizedBox(width: ds(5)),
          Expanded(
            child: DsRichText(
              TextSpan(
                children: <InlineSpan>[
                  TextSpan(text: rule.lead, style: strong),
                  // The reference's literal `{" "}` between the two.
                  TextSpan(text: ' ${rule.detail}'),
                ],
              ),
              DsType.small,
              color: theme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
