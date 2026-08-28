/// Single source of truth for the design-system tree: a verbatim port of the
/// reference's `lib/space/nav.ts` (615 lines).
///
/// That file's own header states the contract, which this port inherits
/// unchanged:
///
/// > The sidebar, every index page and every page header read from this file,
/// > so a category can never appear in the nav without a page, or drift out of
/// > sync with the components it claims to hold.
///
/// Every `title`, `blurb` and `contents` string below is the reference's text
/// character for character, and its explanatory comments travel with it —
/// including the ones that admit a blurb is stale. The drift is part of what is
/// being ported: nothing is corrected, reflowed or re-spelled on the way over.
library;

/// One documented page.
///
/// `slug` plus the owning group decide the route (see [categoryHref]); `blurb`
/// and `contents` are what the page header and the index cards render.
class Category {
  const Category({
    required this.slug,
    required this.title,
    required this.blurb,
    required this.contents,
  });

  /// Final URL segment.
  final String slug;

  final String title;

  /// One line describing what the page is for.
  final String blurb;

  /// The component sets shown on that page, in display order.
  ///
  /// The reference states the consequence on the `data` category below: *adding
  /// a string here is a commitment, not a label*: it renders as the page's
  /// chip list, so an entry is a promise that the section exists.
  final List<String> contents;
}

/// One family of pages: a labelled block in the sidebar and one card on the
/// overview page.
class Group {
  const Group({
    required this.id,
    required this.title,
    required this.href,
    required this.blurb,
    required this.categories,
  });

  /// `"foundations" | "base" | "agent" | "site"` in the reference's type.
  ///
  /// Deliberately a [String] and not an enum: it is the shell's routing key,
  /// and [categoryHref] branches on the literal `foundations` exactly as the
  /// reference does. An enum would be a nicer Dart type and a different file.
  final String id;

  final String title;

  /// Index route for the group.
  final String href;

  final String blurb;

  final List<Category> categories;
}

/// `EL_ROOT`: every route in the tree hangs off this one segment.
const String elRoot = '/design-system';

/// Product showcase route, deliberately outside the documentation tree.
///
/// The docs chrome links to it, but it is not a component specimen and must
/// not appear as a design-system category.
const String showcaseRoute = '/signal-studio';

/// A page-foot / sidebar link: what [siblings] hands back for prev and next.
typedef NavLink = ({String title, String href});

/// The pair [siblings] returns. Both sides are null-able because the ends of a
/// group have nothing beyond them.
typedef Siblings = ({NavLink? prev, NavLink? next});

/// The group + category pair [findCategory] resolves.
typedef CategoryHit = ({Group group, Category category});

/* ── Foundations ─────────────────────────────────────────────────────────── */

const List<Category> _foundations = <Category>[
  Category(
    slug: 'colors',
    title: 'Colors',
    blurb:
        'Surfaces, the action and value ramps, text, hairlines, semantic states, and every contrast ratio measured live in both themes.',
    contents: <String>[
      'Surfaces',
      'Action ramp',
      'Value ramp',
      'Text',
      'Borders',
      'Semantic',
      'What is not a token',
      '70 / 20 / 10 balance',
    ],
  ),
  // "Geist for every word" was stale: `--font-sans` is Space Grotesk and has
  // been for some time. A blurb that names the wrong typeface is the same
  // class of drift as a rules file restating a token value.
  //
  // …and the note is now stale a second time over: the tokens this port builds
  // from render Inter, not Space Grotesk. The blurb still says Space Grotesk,
  // so the blurb still says Space Grotesk here. Fonts follow tokens; copy
  // follows the reference.
  Category(
    slug: 'typography',
    title: 'Typography',
    blurb:
        'Two faces only: Space Grotesk for every word, Geist Mono for every number. Full specimen of each type class, plus the prose block that reaches the same scale without one.',
    contents: <String>[
      'Display',
      'Headings',
      'Body',
      'Labels',
      'Numerics',
      // The one entry that is not a `.type-*` class. `.prose` is the same
      // scale reached a second way: for content nobody writes the elements
      // of: so it is documented beside the classes it shares its declaration
      // blocks with rather than on a page of its own.
      'Prose',
      'Rules',
    ],
  ),
  Category(
    slug: 'spacing',
    title: 'Spacing & Layout',
    blurb:
        'The 8-point spacing scale, radius ladder, elevation set, 12-column grid and responsive breakpoints.',
    contents: <String>[
      'Spacing scale',
      'Radius',
      'Elevation',
      'Grid',
      'Breakpoints',
      'Content width',
    ],
  ),
  Category(
    slug: 'shadows',
    title: 'Shadows',
    blurb:
        'Two families: ambient depth, and machine surfaces that look like they can be physically pressed. Ported from Yukirhythm.',
    contents: <String>[
      'Ambient e1–e4',
      'Machine keys',
      'Sunken sockets',
      'Control depth',
      'Rationed glow',
      'Glass',
    ],
  ),
  Category(
    slug: 'motion',
    title: 'Motion',
    blurb:
        'Durations, easing curves and the named animations — each one running live so timing can be judged, not guessed.',
    contents: <String>[
      'Durations',
      'Easing',
      'Interaction utilities',
      'Named animations',
      'Reveal choreography',
      'Reduced motion',
    ],
  ),
  Category(
    slug: 'icons',
    title: 'Icons',
    blurb:
        'The Icon component wrapping Lucide: fixed sizes, stroke rules, and the curated icon set, grouped by domain.',
    contents: <String>[
      'Icon component',
      'Sizes',
      'Tones',
      'Navigation set',
      'Action set',
      'Domain set',
    ],
  ),
];

/* ── Base components: the shadcn chassis, restyled ──────────────────────── */

const List<Category> _base = <Category>[
  Category(
    slug: 'buttons',
    title: 'Buttons',
    blurb:
        'Every variant, size and state, including the lime premium action reserved for money and reward moments.',
    contents: <String>[
      'Button',
      'Button Group',
      'Icon Button',
      'Toggle',
      'Toggle Group',
      'Kbd',
    ],
  ),
  Category(
    slug: 'inputs',
    title: 'Inputs',
    blurb:
        'Text entry in every shape the product needs, with the full validation and state matrix.',
    contents: <String>[
      'Text Input',
      'Email Input',
      'Password Input',
      'Search Input',
      'Number Input',
      'Phone Number Input',
      'Textarea',
      'Verification Code',
      'Input Group',
      'Field & Label',
    ],
  ),
  Category(
    slug: 'forms',
    title: 'Forms',
    blurb:
        'Assembling inputs into something that validates, submits, fails and says so — with the accessible wiring guaranteed rather than remembered.',
    contents: <String>[
      'Form',
      'Validation',
      'Field errors',
      'Submit states',
      'Server errors',
      'Composed fields',
    ],
  ),
  Category(
    slug: 'selects',
    title: 'Selects & Pickers',
    blurb:
        'Choosing from a known set — menus, comboboxes, command palette and dates.',
    contents: <String>[
      'Select',
      'Native Select',
      'Combobox',
      'Command Palette',
      // The two raw calendar modes first, then the recipe that composes one
      // into a popover: which is the order a reader needs them in.
      'Calendar',
      'Date Range',
      'Date Picker',
    ],
  ),
  Category(
    slug: 'selection',
    title: 'Selection Controls',
    blurb: 'Binary and ranged controls: checkbox, radio, switch and slider.',
    contents: <String>[
      'Checkbox',
      'Radio Group',
      'Switch',
      'Slider',
      'Range Slider',
    ],
  ),
  Category(
    slug: 'dialogs',
    title: 'Dialogs & Overlays',
    blurb:
        'Normal dialog, destructive confirmation, the settings danger zone, side sheet, bottom drawer, popover, hover card and tooltip.',
    contents: <String>[
      'Dialog',
      'Media Dialog',
      'Alert Dialog',
      'Danger Zone',
      'Sheet',
      'Drawer',
      'Popover',
      'Hover Card',
      'Tooltip',
    ],
  ),
  Category(
    slug: 'menus',
    title: 'Menus',
    blurb: 'Account dropdown, right-click menus and the application menubar.',
    contents: <String>['Dropdown Menu', 'Context Menu', 'Menubar'],
  ),
  Category(
    slug: 'navigation',
    title: 'Navigation',
    blurb:
        'Tabs, breadcrumbs, pagination, the navigation menu and disclosure patterns.',
    contents: <String>[
      'Tabs',
      'Breadcrumb',
      'Pagination',
      'Navigation Menu',
      'Accordion',
      'Collapsible',
    ],
  ),
  Category(
    slug: 'feedback',
    title: 'Feedback',
    blurb:
        'Telling the user what happened or what is happening: alerts, toasts, skeletons, progress and empty states.',
    contents: <String>[
      'Alert',
      'Toast',
      'Skeleton',
      'Progress',
      'Progress tones',
      'Spinner',
      'Empty',
    ],
  ),
  Category(
    slug: 'chat',
    title: 'Chat',
    blurb:
        'Four product-agnostic conversation primitives — the generic layer under any chat surface, only one of which this system itself uses.',
    contents: <String>[
      'Message',
      'Bubble',
      'Message Scroller',
      'Attachment',
      'Why the agent console uses only one of them',
    ],
  ),
  // `contents` renders as the page's chip list, so an entry here is a promise
  // that the section exists. "Chart" was listed for months without one:
  // `components/ui/chart.tsx` was real, but no specimen rendered it. Removed
  // until the section was built rather than left advertising a phantom. It is
  // built now, as its own `charts` category below, and this page links across.
  //
  // "Date Range" on `selects` was the same bug, found the same way and fixed
  // the other way round: by building the range calendar the entry had been
  // promising. Nothing checks this direction, so it is worth saying twice:
  // adding a string here is a commitment, not a label.
  Category(
    slug: 'data',
    title: 'Data Display',
    blurb: 'Tables, data tables, badges, avatars, cards, stats and list items.',
    contents: <String>[
      'Table',
      'Data Table',
      'Badge',
      'Avatar',
      'Card',
      'Stat',
      'Item',
      'Marker',
      'Separator',
    ],
  ),
  Category(
    slug: 'charts',
    title: 'Charts',
    blurb:
        'Every chart family on recharts, drawn with the five chart tokens, and the one place in this system where motion has to be read out of the stylesheet rather than written as a class.',
    contents: <String>[
      'Area',
      'Bar',
      'Line',
      'Pie',
      'Radar',
      'Radial',
      'Unit activity',
      'Conversion funnel',
      'Tooltips & legends',
      'Animation',
      'States',
    ],
  ),
  // "Sidebar" used to sit here, and the page carried a section for it. The
  // sidebar is twenty-three exports and sixteen sections of its own now, so
  // it has its own category below; leaving the entry here would have been a
  // second home for one component and a chip pointing at a section that had
  // moved.
  Category(
    slug: 'layout',
    title: 'Layout Primitives',
    blurb:
        'Structural helpers: ratio boxes, scroll areas, carousels and resizable panels.',
    contents: <String>[
      'Aspect Ratio',
      'Scroll Area',
      'Browser Scrollbar',
      'Carousel',
      'Resizable',
    ],
  ),
  // Component names, in the order the page reaches them: the same
  // convention `buttons` uses, where `contents` is what is shown rather than
  // what the headings are called. On this page it doubles as the export
  // inventory: every name below has a specimen you can design against.
  Category(
    slug: 'sidebar',
    title: 'Sidebar',
    blurb:
        'The app shell, taken apart. Every region and every control on its own, in each variant and each state, so any one of them can be designed without rebuilding the whole panel.',
    contents: <String>[
      'Sidebar',
      'SidebarProvider',
      'SidebarTrigger',
      'SidebarHeader',
      'SidebarInput',
      'SidebarContent',
      'SidebarSeparator',
      'SidebarGroup',
      'SidebarGroupLabel',
      'SidebarGroupAction',
      'SidebarCollapsibleGroup',
      'SidebarMenuButton',
      'SidebarMenuAction',
      'SidebarMenuBadge',
      'SidebarMenuSub',
      'SidebarMenuSkeleton',
      'SidebarFooter',
      'NavUser',
      'SidebarRail',
      'SidebarInset',
      'useSidebar',
    ],
  ),
];

/* ── Agent ────────────────────────────────────────────────────────────────────
 *
 * The third family, and the odd one out on purpose. Base is shadcn restyled;
 * The agent console is the exception: hand-written rather than vendored, but
 * carrying no product meaning at all, which is what makes it the part of this
 * system most likely to be lifted whole into the next one.
 *
 * (The half-sentence in the middle is the reference's, mid-edit and shipped;
 * it is a comment, so it renders nowhere — but it is left as found.)
 */

const List<Category> _agent = <Category>[
  Category(
    slug: 'console',
    title: 'Console',
    blurb:
        'The whole component, live, on a scripted transport. Send a message and it streams; ask it to buy something and it stops and asks.',
    contents: <String>[
      'Live console',
      'The four seams',
      'Feature flags',
      'Personas',
      'Launcher',
      'Transport contract',
    ],
  ),
  Category(
    slug: 'avatar',
    title: 'Avatar',
    blurb:
        'Twenty isometric cube scenes, one per state, plus the voice orb. One accent token recolours every one of them.',
    contents: <String>[
      'State set',
      'Sizes',
      'Accent knob',
      'Voice orb',
      'Reduced motion',
    ],
  ),
  Category(
    slug: 'composer',
    title: 'Composer',
    blurb:
        'Everything below the transcript: the input, the file tray, the slash palette, dictation and the model picker.',
    contents: <String>[
      'Composer',
      'Attach menu',
      'Slash palette',
      'Dictation',
      'Model picker',
    ],
  ),
  // In the page's order, `contents` is documented above as display order, and
  // this list had drifted out of it as sections were added: it read Markdown
  // second and Welcome card last while the page rendered Markdown fifth and
  // Attachments last. The page's order is the one kept, because Approval card
  // and Questionnaire are deliberately adjacent (the same interaction shape:
  // the agent speaks, the user answers inline) and Attachments closes the page
  // as the one object that travels in both directions.
  Category(
    slug: 'transcript',
    title: 'Transcript',
    blurb:
        'Everything above it: turns, markdown, tool chips, approval cards, attachments in both directions.',
    contents: <String>[
      'Messages',
      'Tool chips',
      'Approval card',
      'Questionnaire',
      'Markdown',
      'Markdown not supported',
      'Welcome card',
      'Attachments',
    ],
  ),
  Category(
    slug: 'history',
    title: 'History',
    blurb:
        'Every conversation, as cards you can pin, rename, share and delete — with the two shapes each of those can take.',
    contents: <String>[
      'The list',
      'Rename inline or in a dialog',
      'Delete inline or by AlertDialog',
      'Pinning',
      'Search palette',
      'Blur switch',
    ],
  ),
  Category(
    slug: 'voice',
    title: 'Voice',
    blurb:
        'The listening and speaking surface — live waveform, bar visualiser, and the controls that arm them.',
    contents: <String>[
      'Live waveform',
      'Bar visualiser',
      'Mic control',
      'Voice picker',
    ],
  ),
];

/* ── Site pages ───────────────────────────────────────────────────────────────
 *
 * The fourth family, for the pages a product has to have and nobody designs:
 * FAQ, about, contact, help, terms, privacy. Base is a chassis of controls;
 * this is a chassis of *pages* — a measure, a rhythm, a surface, a reading
 * column — composing base rather than adding to it.
 *
 * It grows one category at a time, and that is not caution. `contents` renders
 * as a page's chip list and the sidebar renders a link per category, so an
 * entry here is a promise that the route exists; the `data` page carried a
 * "Chart" chip for months with no specimen behind it. Registering the whole
 * plan up front would ship five links to nothing.
 */

const List<Category> _site = <Category>[
  Category(
    slug: 'structure',
    title: 'Page Structure',
    blurb:
        'The four pieces every secondary page is built from: one owner for the measure and the gutter, one for the band, one for an article beside its rail, and one for text nobody wrote the elements of.',
    contents: <String>[
      'PageContainer',
      'Measures',
      'PageSection',
      'Spacing',
      'Surfaces',
      'ContentLayout',
      'Prose',
    ],
  ),
  Category(
    slug: 'intro',
    title: 'Page Introductions',
    blurb:
        'What opens a page and what opens a section: one h1 that never reaches for the display class, one heading that picks its own level, a policy header that cannot forget its effective date, and the byline under all of them.',
    contents: <String>[
      'PageHero',
      'SectionHeader',
      'Levels & alignment',
      'LegalPageHeader',
      'ArticleMetadata',
      'Dates without a locale',
    ],
  ),
  Category(
    slug: 'landing',
    title: 'Landing Hero',
    blurb:
        "The one page that gets the display class, the brand's single chromatic moment and a staged entrance — and the frame that shows a product off by being wider than the page it sits on.",
    contents: <String>[
      'LandingHero',
      'The entrance ladder',
      'The accent word',
      'HeroShowcase',
      'Reduced motion',
      'The whole section',
    ],
  ),
  Category(
    slug: 'navigation',
    title: 'Reading Navigation',
    blurb:
        'Moving inside a long document and out the other end: a rail and a strip that both track where you are, the pair of links that close a page, and the return to the top that also moves the keyboard.',
    contents: <String>[
      'TableOfContents',
      'AnchorNavigation',
      'Scroll-spy',
      'PrevNext',
      'BackToTop',
      'Reduced motion',
    ],
  ),
  Category(
    slug: 'sections',
    title: 'Content Sections',
    blurb:
        'The repeating bodies of a secondary page. Eight components, and two patterns that are deliberately not components because composition already answers them.',
    contents: <String>[
      'CardGrid',
      'CTABanner',
      'IconList',
      'MediaBlock',
      'Steps',
      'Quote',
      'ComparisonTable',
      'ResourceList',
      'What is not a component',
    ],
  ),
  Category(
    slug: 'chrome',
    title: 'Site Chrome',
    blurb:
        'What wraps every page — the skip link this repository did not have, an announcement bar that is honest about what the server cannot know, the header, the footer, and a consent banner built to be answered rather than escaped.',
    contents: <String>[
      'SkipLink',
      'AnnouncementBar',
      'SiteHeader',
      'SiteFooter',
      'ConsentBanner',
      'The live shell',
    ],
  ),
];

/// `EL_GROUPS`: the whole tree, in the order the sidebar renders it.
const List<Group> elGroups = <Group>[
  Group(
    id: 'foundations',
    title: 'Foundations',
    href: elRoot,
    blurb: 'The decisions everything else inherits.',
    categories: _foundations,
  ),
  Group(
    id: 'base',
    title: 'Base Components',
    href: '$elRoot/components/base',
    blurb:
        "The shadcn chassis, restyled onto this system's tokens. Generic, reusable, product-agnostic.",
    categories: _base,
  ),
  Group(
    id: 'agent',
    title: 'Agent',
    href: '$elRoot/components/agent',
    blurb:
        'A complete AI console — transcript, composer, avatar and voice — pointed at a transport you supply. Written from scratch, and product-agnostic by construction.',
    categories: _agent,
  ),
  Group(
    id: 'site',
    title: 'Site Pages',
    href: '$elRoot/components/site',
    blurb:
        'Composition rather than controls: the containers, bands and reading columns that assemble an FAQ, a policy or a help article out of base components without inventing a single new visual value.',
    categories: _site,
  ),
];

/// Absolute href for a category page.
///
/// Foundations pages sit directly under the root, `/design-system/colors`, not
/// `/design-system/foundations/colors`: because Foundations *is* the index of
/// the design system. Every other group nests under its own index.
String categoryHref(Group group, Category category) => group.id == 'foundations'
    ? '$elRoot/${category.slug}'
    : '${group.href}/${category.slug}';

/// The group with this id, or null. The reference inlines `EL_GROUPS.find`
/// three times; the port names it once.
Group? _groupOrNull(String id) {
  for (final Group group in elGroups) {
    if (group.id == id) return group;
  }
  return null;
}

/// The group with this id, or a throw: the strict half of [_groupOrNull].
///
/// Not in the reference (which has no caller that needs a group alone), but the
/// shell keys its sidebar off group ids and a typo there should fail loudly for
/// the same reason [findCategory] throws.
Group elGroupById(String id) {
  final Group? group = _groupOrNull(id);
  if (group == null) {
    throw ArgumentError.value(id, 'id', 'Unknown design-system group');
  }
  return group;
}

/// Look up a group + category from a group id and slug. Used by page headers.
///
/// Throws on either half being unknown, as the reference does: a page header
/// that cannot find itself in the nav is the exact drift this file exists to
/// prevent, so it fails rather than rendering an empty heading.
CategoryHit findCategory(String groupId, String slug) {
  final Group group = elGroupById(groupId);
  for (final Category category in group.categories) {
    if (category.slug == slug) {
      return (group: group, category: category);
    }
  }
  throw ArgumentError.value(slug, 'slug', 'Unknown $groupId category');
}

/// Previous / next category within a group, for page-foot navigation.
///
/// Two behaviours are the reference's rather than this port's, and both are
/// kept because the pages are built against them:
/// * an unknown *group* returns `(null, null)` instead of throwing: unlike
///   [findCategory], the foot nav degrades to nothing rather than breaking a
///   page;
/// * an unknown *slug* leaves `findIndex` at −1, so `prev` is null and `next`
///   resolves to index 0: the group's first category. A foot nav on a page
///   that is not in the tree therefore points at the top of the group.
Siblings siblings(String groupId, String slug) {
  final Group? found = _groupOrNull(groupId);
  if (found == null) return (prev: null, next: null);
  final Group group = found;

  final int i = group.categories.indexWhere((Category c) => c.slug == slug);

  NavLink? at(int n) {
    if (n < 0 || n >= group.categories.length) return null;
    final Category c = group.categories[n];
    return (title: c.title, href: categoryHref(group, c));
  }

  return (prev: i > 0 ? at(i - 1) : null, next: at(i + 1));
}
