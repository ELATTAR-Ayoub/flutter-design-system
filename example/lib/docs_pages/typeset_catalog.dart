/// What each of the seventeen public type roles is for, and a specimen of it.
///
/// Everything measurable — face, size, line height, weight, tracking, tabular
/// figures, and how the role responds to width — lives on the role itself and
/// is read at render time by `typeset_page.dart`. Only the two things a token
/// cannot carry live here: the sentence explaining when to reach for this role
/// rather than its neighbour, and a specimen string that shows it doing its
/// job.
///
/// `example/test/typeset_docs_test.dart` asserts this list covers
/// `TextStyles.all` exactly once — no role missing, none listed twice, none
/// invented — which is what makes a page built from it a complete inventory
/// rather than a selection somebody curated.
library;

import 'package:elattar_design_system/elattar_design_system.dart';

/// One role, with the prose a token cannot carry.
class TypesetRole {
  const TypesetRole({
    required this.spec,
    required this.usage,
    required this.sample,
  });

  /// The role itself. Compared by identity against `TextStyles.all`.
  final TextStyleToken spec;

  /// The public name, as written at a call site: `TextStyles.<name>`.
  String get name => spec.name;

  /// Which catalog group the role is published under.
  TypeGroup get group => spec.group;

  /// What this role is for, and when to reach for its neighbour instead.
  ///
  /// The one thing a developer needs and cannot get from the values.
  final String usage;

  /// The specimen string, chosen to show the role doing its job.
  final String sample;
}

/// Every role in `TextStyles.all`, in catalog order.
final List<TypesetRole> typesetRoles = <TypesetRole>[
  // ── Words ────────────────────────────────────────────────────────────────
  TypesetRole(
    spec: TextStyles.display,
    usage:
        'The largest thing on a page, and there should be one. It steps up '
        'twice as the window widens so a hero stays proportionate without a '
        'breakpoint of its own. Reach for h1 when the page has a title rather '
        'than a statement.',
    sample: 'Build the interface you mean.',
  ),
  TypesetRole(
    spec: TextStyles.h1,
    usage:
        'A page title. One per page, above everything the page is about. It '
        'steps with display, so the two never collide at any width.',
    sample: 'Typeset',
  ),
  TypesetRole(
    spec: TextStyles.h2,
    usage:
        'A major section heading — the divisions a reader would expect in a '
        'table of contents.',
    sample: 'Choosing a role',
  ),
  TypesetRole(
    spec: TextStyles.h3,
    usage: 'A subsection inside an h2. Rarely the largest thing on a screen.',
    sample: 'Responsive steps',
  ),
  TypesetRole(
    spec: TextStyles.h4,
    usage:
        'The smallest heading: a card title, an alert title, an accordion '
        'trigger. Titles what follows it — use lead to introduce it instead.',
    sample: 'Payment method',
  ),
  TypesetRole(
    spec: TextStyles.lead,
    usage:
        'The standfirst under a title: one paragraph that introduces what '
        'follows. Larger than body, and never a heading.',
    sample:
        'Seventeen roles, resolved for the width they render at, in two faces.',
  ),
  TypesetRole(
    spec: TextStyles.body,
    usage:
        'Reading copy, and the default for anything a person reads in '
        'sentences. If you are unsure which role to use, it is this one.',
    sample:
        'A role is a statement about meaning, not about size. Pick by what '
        'the text is doing and let the scale decide how big it is.',
  ),
  TypesetRole(
    spec: TextStyles.small,
    usage:
        'Supporting copy beside body: a field description, a row second '
        'line, a timestamp. It is a size, not a colour — pass muted ink when '
        'the copy is genuinely secondary.',
    sample: 'Last updated 14 minutes ago',
  ),
  TypesetRole(
    spec: TextStyles.nav,
    usage:
        'Interface words that are targets rather than prose: navigation rows, '
        'tabs, menu items, button labels. Components apply it themselves.',
    sample: 'Components',
  ),
  TypesetRole(
    spec: TextStyles.badge,
    usage:
        'The short status word inside a Badge. Owned by that component; reach '
        'for the component, not the role.',
    sample: 'Beta',
  ),

  // ── Code and identifiers ─────────────────────────────────────────────────
  TypesetRole(
    spec: TextStyles.code,
    usage:
        'Code: a snippet, a command, a keyboard shortcut. Pass inline: true '
        'where it is a chip inside a sentence rather than a line of its own.',
    sample: 'flutter pub add elattar_design_system',
  ),
  TypesetRole(
    spec: TextStyles.identifier,
    usage:
        'An identifier a person must read exactly: a path, a key, an order '
        'number, a hash. Larger than code because it is read character by '
        'character rather than skimmed.',
    sample: 'ord_8Q4KX2M1T',
  ),

  // ── Numerics ─────────────────────────────────────────────────────────────
  TypesetRole(
    spec: TextStyles.numberSm,
    usage:
        'A figure inside dense furniture: a count on a menu row, a page '
        'number, a badge on a tab.',
    sample: '128',
  ),
  TypesetRole(
    spec: TextStyles.numberBase,
    usage: 'A figure in a line of text or a table cell, at reading size.',
    sample: '1,510.20',
  ),
  TypesetRole(
    spec: TextStyles.numberMd,
    usage: 'A stat inside a card, beside a label and a trend.',
    sample: '48,912',
  ),
  TypesetRole(
    spec: TextStyles.numberLg,
    usage: 'The headline metric of a section.',
    sample: '92.4%',
  ),
  TypesetRole(
    spec: TextStyles.numberXl,
    usage:
        'The single number a dashboard exists to show. One per screen, or it '
        'is not the headline.',
    sample: '1,510',
  ),
];

/// The roles of one group, in catalog order.
List<TypesetRole> typesetRolesIn(TypeGroup group) =>
    typesetRoles.where((TypesetRole role) => role.group == group).toList();
