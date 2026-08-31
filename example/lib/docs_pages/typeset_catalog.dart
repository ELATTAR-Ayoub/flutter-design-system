/// The 27 public type roles, named.
///
/// `TextStyleToken` carries no name. It records what a `.type-*` class declares —
/// family, size, leading, weight, tracking, casing, tabular figures, the
/// colour the class sets on itself — and nothing about what the class is
/// *called* or what it is *for*. Two roles with identical values would be
/// indistinguishable to any code that tried to recover a name by matching on
/// them, and `TextStyles.badge` and `TextStyles.eyebrow` are one tracking value apart.
///
/// So the names live here, written down once, each bound to its spec by
/// identity. `example/test/typeset_docs_test.dart` asserts this list covers
/// `TextStyles.all` exactly once — no role missing, none listed twice, none
/// invented — which is what makes a page built from this list a complete
/// inventory rather than a selection somebody curated.
///
/// **Everything measurable is read from the spec, never repeated here.** Size,
/// leading, weight, tracking, casing, tabular figures and default colour are
/// derived at render time by `typeset_page.dart`. A hand-written metadata
/// column is a second source of truth that goes stale the first time a token
/// moves, and this page's whole job is to be the one place a developer can
/// trust about type.
library;

import 'package:elattar_design_system/elattar_design_system.dart';

/// The reading groups the scale falls into.
///
/// Not a property of any spec — a way of laying 27 roles out so a developer
/// scanning for "the one for a section heading" reaches it without reading
/// all 27.
enum TypesetGroup {
  /// Headings and running prose. The roles that carry meaning as sentences.
  words('Words', 'Headings, prose, and the running text of a page.'),

  /// Eyebrows, chips, and the small uppercase furniture around content.
  labels(
    'Labels and furniture',
    'The small, often uppercase roles that title a group or tag an item. '
        'They label content; they are not content.',
  ),

  /// Monospace: code, and identifiers a reader may need to compare.
  code(
    'Code and serials',
    'Monospace roles. Code inline, and identifiers a reader compares '
        'character by character.',
  ),

  /// The six-step tabular numeric scale.
  numerics(
    'Numerics',
    'Six steps of tabular monospace, so a column of figures aligns on the '
        'digit rather than on the glyph. All six share family, weight and '
        'tabular figures; only size, leading and — at the largest step — '
        'tracking differ.',
  ),

  /// The one italic serif.
  accent(
    'Accent',
    'One italic serif, sized relative to whatever it sits inside.',
  );

  const TypesetGroup(this.title, this.description);

  final String title;
  final String description;
}

/// One named role.
class TypesetRole {
  const TypesetRole({
    required this.name,
    required this.spec,
    required this.group,
    required this.usage,
    required this.sample,
    this.sizeRule,
  });

  /// The `TextStyles` member, exactly as written at a call site: `TextStyles.$name`.
  final String name;

  /// The spec itself. Compared by identity against `TextStyles.all`.
  final TextStyleToken spec;

  final TypesetGroup group;

  /// What this role is for, and when to reach for its neighbour instead.
  ///
  /// The one thing a developer actually needs and cannot get from the values:
  /// `h4` and `lead` are both 17px, and choosing between them is a question
  /// about meaning, not about size.
  final String usage;

  /// The specimen string. Chosen to show the role doing its job — a heading
  /// reads as a heading, a numeric shows digits that would misalign in a
  /// proportional face.
  final String sample;

  /// How the size is decided, for the three roles whose `spec.size` is null.
  ///
  /// Null means the spec carries its own px size and the page reads it.
  final String? sizeRule;
}

/// Every role in `TextStyles.all`, in reading order.
final List<TypesetRole> typesetRoles = <TypesetRole>[
  // ── Words ────────────────────────────────────────────────────────────────
  TypesetRole(
    name: 'display',
    spec: TextStyles.display,
    group: TypesetGroup.words,
    usage:
        'The largest thing on a page, and there should be one. Fluid: it '
        'grows with the viewport between 44 and 64px, so a hero does not '
        'need a breakpoint to stay proportionate. Reach for h1 when the page '
        'has a title rather than a statement.',
    sample: 'Build the interface you mean.',
    sizeRule: 'Fluid — Fluid.display(context), clamped 44–64px',
  ),
  TypesetRole(
    name: 'h1',
    spec: TextStyles.h1,
    group: TypesetGroup.words,
    usage:
        'A page title. Also fluid, on a tighter clamp than display, so the '
        'two never collide at any width.',
    sample: 'Typeset',
    sizeRule: 'Fluid — Fluid.h1(context), clamped 32–40px',
  ),
  TypesetRole(
    name: 'h2',
    spec: TextStyles.h2,
    group: TypesetGroup.words,
    usage:
        'A section heading. The only role whose weight sits between two named '
        'FontWeight steps: it asks the variable axis for 650 and falls back '
        'to w600 where the axis is unavailable.',
    sample: 'The scale',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'h3',
    spec: TextStyles.h3,
    group: TypesetGroup.words,
    usage: 'A subsection heading inside a section.',
    sample: 'Choosing a role',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'h4',
    spec: TextStyles.h4,
    group: TypesetGroup.words,
    usage:
        'The smallest heading. Same size as lead and a different job: h4 '
        'titles what follows, lead introduces it.',
    sample: 'What a spec records',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'lead',
    spec: TextStyles.lead,
    group: TypesetGroup.words,
    usage:
        'The standfirst under a title: one paragraph, generously leaded, '
        'muted by default so it reads as introduction rather than as body.',
    sample:
        'Pick the role that matches the meaning, and the size follows from it.',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'body',
    spec: TextStyles.body,
    group: TypesetGroup.words,
    usage:
        'Running prose. The default for anything a reader reads rather than '
        'scans, and the size the accent role measures itself against.',
    sample:
        'Every visual value resolves from a token, so a screen cannot drift '
        'from the system by accident.',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'small',
    spec: TextStyles.small,
    group: TypesetGroup.words,
    usage:
        'Secondary prose: a caveat, a footnote, a hint under a field. Muted '
        'by default. Still a sentence — reach for caption when it stops '
        'being one.',
    sample: 'Applies to new projects only.',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'nav',
    spec: TextStyles.nav,
    group: TypesetGroup.words,
    usage:
        'A navigation destination. Tighter leading than body because a nav '
        'item is one line by construction.',
    sample: 'Components',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'navSm',
    spec: TextStyles.navSm,
    group: TypesetGroup.words,
    usage:
        'The dense step of nav, for a secondary or nested list. Sentence '
        'case is the point: it stays a destination, not a label.',
    sample: 'Installation',
    sizeRule: null,
  ),

  // ── Labels and furniture ─────────────────────────────────────────────────
  TypesetRole(
    name: 'eyebrow',
    spec: TextStyles.eyebrow,
    group: TypesetGroup.labels,
    usage:
        'The eyebrow above a section: uppercase, widely tracked, muted. The '
        'loudest of the small roles, and the one to use when a group needs '
        'naming.',
    sample: 'Foundations',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'section',
    spec: TextStyles.section,
    group: TypesetGroup.labels,
    usage:
        'The label\'s quiet twin: a group heading in sentence case, for a '
        'sidebar or a settings list where uppercase would shout.',
    sample: 'Appearance',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'chip',
    spec: TextStyles.chip,
    group: TypesetGroup.labels,
    usage:
        'Text inside a small pill or filter chip. Sentence case, unlike tag '
        'and badge.',
    sample: 'Recently added',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'caption',
    spec: TextStyles.caption,
    group: TypesetGroup.labels,
    usage:
        'A caption under a figure or a specimen. The smallest sentence-case '
        'role.',
    sample: 'Rendered at the viewport width shown.',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'eyebrowSmall',
    spec: TextStyles.eyebrowSmall,
    group: TypesetGroup.labels,
    usage:
        'The most widely tracked role in the scale, and muted: metadata that '
        'has to be legible without competing with anything.',
    sample: 'Updated today',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'tag',
    spec: TextStyles.tag,
    group: TypesetGroup.labels,
    usage: 'The smallest step in the scale. A category marker, not a sentence.',
    sample: 'New',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'badge',
    spec: TextStyles.badge,
    group: TypesetGroup.labels,
    usage:
        'Text inside a badge. Same size as label, tracked slightly tighter, '
        'and not muted — a badge carries its own colour.',
    sample: 'Stable',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'wordmark',
    spec: TextStyles.wordmark,
    group: TypesetGroup.labels,
    usage:
        'A product or brand name set in the word face: body size, bold, '
        'leading collapsed to 1 so it sits on its own baseline.',
    sample: 'Elattar',
    sizeRule: null,
  ),

  // ── Code and serials ─────────────────────────────────────────────────────
  TypesetRole(
    name: 'code',
    spec: TextStyles.code,
    group: TypesetGroup.code,
    usage:
        'Inline code and command text. Declares no weight, so it inherits '
        'from whatever it sits in — a code span inside a bold heading stays '
        'bold.',
    sample: 'elattar add button',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'identifier',
    spec: TextStyles.identifier,
    group: TypesetGroup.code,
    usage:
        'An identifier a person reads back: an order number, a hash, a key. '
        'Uppercase and monospace so two of them can be compared character by '
        'character. Declares no weight either.',
    sample: 'a9b6fc1',
    sizeRule: null,
  ),

  // ── Numerics ─────────────────────────────────────────────────────────────
  TypesetRole(
    name: 'numberXs',
    spec: TextStyles.numberXs,
    group: TypesetGroup.numerics,
    usage: 'A figure inside a dense control — a badge count, a table cell.',
    sample: '1,510',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'numberSm',
    spec: TextStyles.numberSm,
    group: TypesetGroup.numerics,
    usage: 'A figure beside a label in a list or a compact row.',
    sample: '99',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'numberBase',
    spec: TextStyles.numberBase,
    group: TypesetGroup.numerics,
    usage:
        'The default figure: body-sized, so a number set inline with prose '
        'sits on the same line without disturbing it.',
    sample: '1,024 rows',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'numberMd',
    spec: TextStyles.numberMd,
    group: TypesetGroup.numerics,
    usage: 'A secondary metric on a dashboard — supporting, not headline.',
    sample: '47 KB',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'numberLg',
    spec: TextStyles.numberLg,
    group: TypesetGroup.numerics,
    usage: 'A stat tile\'s value: the number the tile exists to show.',
    sample: '1,510',
    sizeRule: null,
  ),
  TypesetRole(
    name: 'numberXl',
    spec: TextStyles.numberXl,
    group: TypesetGroup.numerics,
    usage:
        'The headline figure on a page. The only numeric step that overrides '
        'the shared tracking, tightening further because 40px of monospace '
        'sets loose.',
    sample: '0.0.1',
    sizeRule: null,
  ),

  // ── Accent ───────────────────────────────────────────────────────────────
  TypesetRole(
    name: 'accent',
    spec: TextStyles.accent,
    group: TypesetGroup.accent,
    usage:
        'One or two italic words inside a heading, for emphasis the word '
        'face cannot give. Sized as a multiple of what it sits inside, so an '
        'accent word inside a fluid display rides that clamp for free — and '
        'it inherits its leading for the same reason. Use it once on a page '
        'or not at all.',
    sample: 'mean',
    sizeRule: 'Relative — TextStyles.accentSize(inherited), 1.055x its context',
  ),
];

/// The roles in [group], in the order they appear in [typesetRoles].
List<TypesetRole> typesetRolesIn(TypesetGroup group) => <TypesetRole>[
  for (final TypesetRole role in typesetRoles)
    if (role.group == group) role,
];
