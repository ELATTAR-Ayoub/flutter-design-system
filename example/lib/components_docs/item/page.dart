/// Public documentation page for the `item` component.
///
/// **Reference shape**, mirrored from shadcn's own
/// `ui.shadcn.com/docs/components/base/item`, fetched fresh: Installation,
/// Usage, Composition, Item vs Field, Variant, Size, Icon, Avatar, Image,
/// Group, Header, Link, Dropdown, RTL, API Reference.
///
/// **Skipped, honestly**, five of those fourteen — each one traced to
/// `item.dart`'s own "Not ported" note:
/// * **Size**: the reference ships three rungs (default/sm/xs). The port's
///   own doc comment says the two smaller rungs "are byte-identical to
///   `default`" and were never built: there is no ElItemSize to demonstrate,
///   so a "Size" section would show the same row three times under three
///   names.
/// * **Image**: `ElItemMedia`'s only forced shape is the icon variant
///   (`size-4`, 16px). There is no separate, larger `variant="image"` slot:
///   passing an `Image` widget as `child` still renders it in the same 16px
///   box an icon gets, not the reference's larger album-art treatment.
/// * **Header**: `item.dart`'s own doc comment lists `ItemHeader` (along
///   with `ItemSeparator` and `ItemFooter`) under "Not ported… no call
///   site."
/// * **Link**: the reference's Link section uses `asChild`/`render` to turn
///   an Item into a real anchor. `item.dart`'s doc comment: "Not ported:
///   `asChild` and with it the whole `[a]:hover:bg-muted` … pair — the hover
///   surface is keyed to the element the row *is*", and this port has no
///   such polymorphic render prop.
/// * **Dropdown**: the reference composes a `<Select>` inside an Item to
///   show any interactive control can sit in its content/actions slots —
///   which Icon, Avatar, and Group below already demonstrate with real
///   controls of their own. A dedicated section would repeat that same fact
///   with a different child widget, so it is folded into those instead of
///   duplicated.
///
/// [ComponentDocEntry.description] is the page's only rendered description;
/// no second hero paragraph renders beneath it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class ItemDocPage extends StatelessWidget {
  const ItemDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: itemDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: itemDoc.title,
      description: itemDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Item'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Item vs Field', anchor: 'item-vs-field'),
      DocsTocEntry(title: 'Variant', anchor: 'variant'),
      DocsTocEntry(title: 'Icon', anchor: 'icon'),
      DocsTocEntry(title: 'Avatar', anchor: 'avatar'),
      DocsTocEntry(title: 'Group', anchor: 'group'),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(title: 'API Reference', anchor: 'api'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    onNavigate: onNavigate,
    child: const _ItemArticle(),
  );
}

const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Accordion', route: '/components/accordion'),
  DocsSidebarEntry(title: 'Alert', route: '/components/alert'),
  DocsSidebarEntry(title: 'Avatar', route: '/components/avatar'),
  DocsSidebarEntry(title: 'Badge', route: '/components/badge'),
  DocsSidebarEntry(title: 'Breadcrumb', route: '/components/breadcrumb'),
  DocsSidebarEntry(title: 'Checkbox', route: '/components/checkbox'),
  DocsSidebarEntry(title: 'Collapsible', route: '/components/collapsible'),
  DocsSidebarEntry(title: 'Empty', route: '/components/empty'),
  DocsSidebarEntry(title: 'Item', route: '/components/item', selected: true),
  DocsSidebarEntry(title: 'Kbd', route: '/components/kbd'),
  DocsSidebarEntry(title: 'Progress', route: '/components/progress'),
  DocsSidebarEntry(title: 'Separator', route: '/components/separator'),
  DocsSidebarEntry(title: 'Skeleton', route: '/components/skeleton'),
  DocsSidebarEntry(title: 'Stat', route: '/components/stat'),
  DocsSidebarEntry(title: 'Switch', route: '/components/switch'),
  DocsSidebarEntry(title: 'Toggle', route: '/components/toggle'),
  DocsSidebarEntry(title: 'Tooltip', route: '/components/tooltip'),
];

class _ItemArticle extends StatelessWidget {
  const _ItemArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('item-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _preview(),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        _composition(),
        _itemVsField(),
        _variant(),
        _icon(),
        _avatar(),
        _group(),
        _rtl(theme),
        _api(theme),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _theming(theme),
        _source(),
      ],
    );
  }

  Widget _preview() => DocsCodeExample(
    title: 'Item',
    description:
        'ElItem is a structured list row: optional media (usually an '
        'icon), required content (usually a title and description), and '
        'optional actions. The row carries a border option (normal, '
        'outline, muted) and an alignment override (center or top). Reach '
        'for it over a bare Row when the content has a standard shape and '
        'the container needs semantic consistency across several rows. '
        'ElItemGroup is the list wrapper: it enforces a vertical gap and '
        'stretches all children to the column width.',
    manualFiles: const <DocsCodeFile>[
      DocsCodeFile(
        path: 'lib/components/ui/item.dart',
        code:
            "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
            '// Install with: elattar add item',
      ),
    ],
    preview: KeyedSubtree(
      key: const ValueKey<String>('item-preview'),
      child: ElItem(
        media: ElItemMedia(
          child: ElIcon.lucide(
            ElLucide.messageSquare,
            size: ElIconSize.sm,
            tone: ElIconTone.normal,
          ),
        ),
        content: ElItemContent(
          children: <Widget>[
            const ElItemTitle('Draft response'),
            ElItemDescription('You started typing something here on August 14'),
          ],
        ),
        actions: ElItemActions(
          children: <Widget>[
            ElButton(
              variant: ElButtonVariant.ghost,
              size: ElButtonSize.sm,
              onPressed: () {},
              child: ElText('Edit', ElComponentType.buttonLabel),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        '`elattar add item` installs the component and its declared '
        'dependency closure.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'registry/components/item.json',
          description: 'Shipped and resolved by `elattar add item`.',
        ),
        const DocsInstallFact(
          label: 'Destination',
          value: 'lib/components/ui/item.dart',
          description: 'Where a manual copy of the source file belongs.',
        ),
        const DocsInstallFact(
          label: 'Foundation',
          value: 'source only',
          description: 'No package-backed alternative is offered yet.',
        ),
        const DocsInstallFact(
          label: 'Dependencies',
          value: 'source-foundation only',
          description:
              'ElItem needs only colors/spacing/theme/typography: no '
              'component or effect import.',
        ),
        const DocsInstallFact(
          label: 'Assets',
          value: 'none',
          description: 'No images, icon fonts, or binary assets.',
        ),
        const DocsInstallFact(
          label: 'Shaders',
          value: 'none',
          description: 'A flat Container fill and border, not a shader.',
        ),
        const DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description: 'No platform-conditional code in item.dart.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'docs specimen only',
          description:
              'This page\'s live preview and '
              'example/test/components_docs/item_test.dart. No dedicated '
              'package-level unit test and no registry fixture install '
              'exist yet.',
        ),
      ],
    ),
  );

  Widget _usage() => ElSection(
    id: 'usage',
    title: 'Usage',
    description: 'A row in a group, or standalone.',
    child: ElPanel(
      label: 'DART',
      note: 'COMPOSE',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  Widget _composition() => ElSection(
    id: 'composition',
    title: 'Composition',
    description:
        'ElItemGroup is a list wrapper, not a variant switch. Item\'s only '
        'real axis is ElItemVariant (see Variant below); alignStart is a '
        'bool, not an enum.',
    child: DocsCodeExample(
      title: 'The part tree',
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'item_tree.txt',
          code: '''ElItemGroup
└─ ElItem
   ├─ ElItemMedia      (optional)
   ├─ ElItemContent
   │  ├─ ElItemTitle
   │  └─ ElItemDescription
   └─ ElItemActions    (optional)''',
        ),
      ],
    ),
  );

  Widget _itemVsField() => ElSection(
    id: 'item-vs-field',
    title: 'Item vs Field',
    description:
        'Both stack a label-like part over supporting text, and it is easy '
        'to reach for the wrong one.',
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: ElWidths.prose),
      child: ElText(
        'ElItem is a display row: media, a title, a description, and '
        'actions, with no form semantics and no validation state. ElField '
        '(documented on its own page) is a form control wrapper: it owns a '
        'label, a control, a description, and an error, wired so a screen '
        'reader announces them as one field with Semantics(hint:) and '
        'Semantics(validationResult:). Reach for ElItem for a notification, '
        'a search result, or a list row a user reads. Reach for ElField the '
        'moment the row holds something the user types into, checks, or '
        'submits.',
        ElType.body,
      ),
    ),
  );

  Widget _variant() => ElSection(
    id: 'variant',
    title: 'Variant',
    description:
        'ElItemVariant is Item\'s only enum: no separate size axis exists '
        '(sm and xs are byte-identical to the default and were never '
        'built; see API Reference).',
    child: ElPanel(
      label: 'PREVIEW',
      child: ElItemGroup(
        children: <Widget>[
          KeyedSubtree(
            key: const ValueKey<String>('item-example:variant-normal'),
            child: const ElItem(
              content: ElItemContent(
                children: <Widget>[
                  ElItemTitle('Normal'),
                  ElItemDescription('border-transparent: no border, no fill.'),
                ],
              ),
            ),
          ),
          KeyedSubtree(
            key: const ValueKey<String>('item-example:variant-outline'),
            child: const ElItem(
              variant: ElItemVariant.outline,
              content: ElItemContent(
                children: <Widget>[
                  ElItemTitle('Outline'),
                  ElItemDescription('A 1px border in theme.border.'),
                ],
              ),
            ),
          ),
          KeyedSubtree(
            key: const ValueKey<String>('item-example:variant-muted'),
            child: const ElItem(
              variant: ElItemVariant.muted,
              content: ElItemContent(
                children: <Widget>[
                  ElItemTitle('Muted'),
                  ElItemDescription('A semi-transparent muted fill.'),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _icon() => ElSection(
    id: 'icon',
    title: 'Icon',
    description:
        'ElItemMedia forces its child into a 16px square and, whenever the '
        'row carries a description, nudges it 2px down so it lines up with '
        'the title\'s cap height instead of the row\'s centre.',
    child: ElPanel(
      label: 'PREVIEW',
      child: KeyedSubtree(
        key: const ValueKey<String>('item-example:icon'),
        child: ElItem(
          media: ElItemMedia(
            child: ElIcon.lucide(
              ElLucide.bell,
              size: ElIconSize.sm,
              tone: ElIconTone.normal,
            ),
          ),
          content: const ElItemContent(
            children: <Widget>[
              ElItemTitle('New comment'),
              ElItemDescription('Sarah replied to your thread'),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _avatar() => ElSection(
    id: 'avatar',
    title: 'Avatar',
    description:
        'ElItemMedia takes any widget, including ElAvatar: passing '
        'sizePx: ElItemMedia.size keeps the fallback initials centred in '
        'the same 16px square an icon would occupy, instead of relying on '
        'the forced square to squash a larger default. (ElEmptyMedia, on '
        'the empty page, cannot do this: it only takes a glyph.)',
    child: ElPanel(
      label: 'PREVIEW',
      child: KeyedSubtree(
        key: const ValueKey<String>('item-example:avatar'),
        child: ElItem(
          media: ElItemMedia(
            child: ElAvatar(fallback: 'JD', sizePx: ElItemMedia.size),
          ),
          content: const ElItemContent(
            children: <Widget>[
              ElItemTitle('Jordan Diaz'),
              ElItemDescription('Commented 2 hours ago'),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _group() => ElSection(
    id: 'group',
    title: 'Group',
    description:
        'ElItemGroup is the list wrapper: it enforces a vertical gap and '
        'stretches every row to the column width. The gap tightens from '
        '10px to a hidden 2.5px when the rows contain size=sm buttons, a '
        'CSS descendant-selector quirk reproduced as measured (see '
        'Theming).',
    child: ElPanel(
      label: 'PREVIEW',
      child: KeyedSubtree(
        key: const ValueKey<String>('item-example:group'),
        child: ElItemGroup(
          children: <Widget>[
            ElItem(
              media: ElItemMedia(
                child: ElIcon.lucide(ElLucide.fileText, size: ElIconSize.sm),
              ),
              content: const ElItemContent(
                children: <Widget>[
                  ElItemTitle('Quarterly report'),
                  ElItemDescription('Jan 1 – Mar 31, 2026'),
                ],
              ),
            ),
            ElItem(
              media: ElItemMedia(
                child: ElIcon.lucide(ElLucide.download, size: ElIconSize.sm),
              ),
              content: const ElItemContent(
                children: <Widget>[ElItemTitle('Download Q4 data')],
              ),
              actions: ElItemActions(
                children: <Widget>[
                  ElButton(
                    variant: ElButtonVariant.ghost,
                    size: ElButtonSize.sm,
                    onPressed: () {},
                    child: ElText('Manage', ElComponentType.buttonLabel),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _rtl(ElThemeData theme) => ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'ElItem paints no direction-specific layout of its own: it sizes '
        'to its content and reads right-to-left under a plain '
        'Directionality, the same composition either way.',
    child: ElPanel(
      label: 'PREVIEW',
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: const KeyedSubtree(
          key: ValueKey<String>('rtl-example:item'),
          child: ElItem(
            content: ElItemContent(
              children: <Widget>[
                ElItemTitle('المستند النهائي'),
                ElItemDescription('تم التحديث اليوم'),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _api(ElThemeData theme) => ElSection(
    id: 'api',
    title: 'API Reference',
    description:
        'One prop table per exported class, plus a static-tokens table for '
        'each. Every row below is a real constructor parameter, verified '
        'against lib/src/components/item.dart directly.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-elitemgroup'),
          child: const DocsApiTable(
            title: 'ElItemGroup',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'children',
                type: 'List<Widget>',
                description: 'Required. List rows, joined by a gap.',
              ),
              DocsApiFact(
                name: 'gapOverride',
                type: 'double?',
                description:
                    'Optional. Defaults to null, which keeps '
                    'ElItemGroup.gap. Overrides the gap for this group '
                    'only.',
              ),
              DocsApiFact(
                name: 'ElItemGroup.gap',
                type: 'static double',
                description:
                    '10px between rows. Tightens to a hidden 2.5px when '
                    'the rows contain size=sm buttons: see Group above.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elitem'),
          child: const DocsApiTable(
            title: 'ElItem',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'media',
                type: 'Widget?',
                description:
                    'Optional. Defaults to null. Usually a ElItemMedia '
                    'with an icon or avatar. Sits at the row start.',
              ),
              DocsApiFact(
                name: 'content',
                type: 'Widget',
                description:
                    'Required. Usually ElItemContent with title and '
                    'description. Fills the middle space.',
              ),
              DocsApiFact(
                name: 'actions',
                type: 'Widget?',
                description:
                    'Optional. Defaults to null. Usually ElItemActions '
                    'with buttons. Sits at the row end.',
              ),
              DocsApiFact(
                name: 'variant',
                type: 'ElItemVariant',
                description:
                    'Optional. Defaults to ElItemVariant.normal. Selects '
                    'the border: see the ElItemVariant table below.',
              ),
              DocsApiFact(
                name: 'alignStart',
                type: 'bool',
                description:
                    'Optional. Defaults to false. When true, aligns media '
                    'and actions to the top instead of the centre.',
              ),
              DocsApiFact(
                name: 'ElItem.gap',
                type: 'static double',
                description: '10px between media, content, and actions.',
              ),
              DocsApiFact(
                name: 'ElItem.padding',
                type: 'static EdgeInsets',
                description: '12px horizontal, 10px vertical.',
              ),
              DocsApiFact(
                name: 'ElItem.radius',
                type: 'static double',
                description: '12px corners.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elitemvariant'),
          child: const DocsApiTable(
            title: 'ElItemVariant',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'normal',
                type: 'the default',
                description:
                    'A transparent 1px border: no visible border, no fill.',
              ),
              DocsApiFact(
                name: 'outline',
                type: 'enum value',
                description:
                    'A real 1px border in theme.border. The one real call '
                    'site in the corpus: the agent family\'s history card.',
              ),
              DocsApiFact(
                name: 'muted',
                type: 'enum value',
                description:
                    'A transparent border plus a 50%-alpha theme.muted '
                    'fill. Recorded, not built beyond the constant: no '
                    'real call site paints it yet.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elitemmedia'),
          child: const DocsApiTable(
            title: 'ElItemMedia',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'child',
                type: 'Widget',
                description:
                    'Required. Any widget: an icon or a ElAvatar are the '
                    'two real shapes in this corpus (see Icon and Avatar '
                    'above). Forced into a 16px square either way.',
              ),
              DocsApiFact(
                name: 'nudged',
                type: 'bool',
                description:
                    'Optional. Defaults to true. When the row carries a '
                    'description, pins the media to the top and drops it '
                    '2px so it lines up with the title\'s cap height '
                    'instead of the row\'s centre.',
              ),
              DocsApiFact(
                name: 'ElItemMedia.size',
                type: 'static double',
                description: '16px, the forced glyph/avatar square.',
              ),
              DocsApiFact(
                name: 'ElItemMedia.nudge',
                type: 'static double',
                description: '2px, the top offset nudged applies.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elitemcontent'),
          child: const DocsApiTable(
            title: 'ElItemContent',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'children',
                type: 'List<Widget>',
                description:
                    'Required. Usually ElItemTitle and ElItemDescription, '
                    'joined by a 4px gap.',
              ),
              DocsApiFact(
                name: 'ElItemContent.gap',
                type: 'static double',
                description: '4px between children.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elitemtitle'),
          child: const DocsApiTable(
            title: 'ElItemTitle',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'text',
                type: 'String (positional)',
                description:
                    'Required. The row\'s heading. Clips to one line and '
                    'ellipsizes.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elitemdescription'),
          child: const DocsApiTable(
            title: 'ElItemDescription',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'text',
                type: 'String (positional)',
                description:
                    'Required. The supporting sentence, '
                    'theme.mutedForeground. Clips to two lines and '
                    'ellipsizes.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elitemactions'),
          child: const DocsApiTable(
            title: 'ElItemActions',
            facts: <DocsApiFact>[
              DocsApiFact(
                name: 'children',
                type: 'List<Widget>',
                description:
                    'Required. Buttons or other controls, joined by an '
                    '8px gap.',
              ),
              DocsApiFact(
                name: 'ElItemActions.gap',
                type: 'static double',
                description: '8px between children.',
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description:
        'ElItem and every part are static, presentational '
        'StatelessWidgets: none owns onPressed/enabled, a GestureDetector, '
        'a FocusNode, or an async flag.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Rest',
          treatment:
              'Paints its variant border, the media icon or avatar, '
              'content rows, and action buttons.',
          userSignal: 'The resting paint is the only paint.',
        ),
        DocsStateFact(
          state: 'Loading / Error / Success / Disabled',
          treatment:
              'N/A: ElItem carries none of these as its own state. A '
              'caller renders a different row, or disables the buttons it '
              'places in ElItemActions itself.',
          userSignal:
              'Compose with a stateful control at the call site: ElItem '
              'does not.',
        ),
        DocsStateFact(
          state: 'Hover / Focus-visible / Pressed / Selected',
          treatment:
              'N/A for ElItem itself: no GestureDetector, FocusNode, or '
              'onPressed/enabled parameter. ElItemActions can *hold* '
              'interactive children (buttons) whose own states apply to '
              'them, not to the row.',
          userSignal: 'Compose with an interactive component at the call site.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'N/A: no AnimationController and no motion token appears in '
              'item.dart.',
          userSignal: 'Nothing animates, so nothing needs to still.',
        ),
      ],
    ),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: _bullets(theme, <String>[
      'Semantic role: none of its own, ElItem, ElItemContent, and '
          'ElItemActions are plain Row/Column widgets with no Semantics '
          'wrapper.',
      'Text is not silent: ElItemTitle and ElItemDescription render '
          'through ElText, which carries Flutter\'s default static-text '
          'semantics: both are individually reachable by a screen '
          'reader.',
      'Actions inherit semantics from ElItemActions\' children (buttons), '
          'which own their own focus and labels.',
      'Keyboard: ElItemActions typically holds button children that own '
          'their own focus behavior; ElItem itself adds none.',
      'ItemGroup carries `role="list"` in the reference; this port\'s '
          'ElItemGroup is a plain Column with no Semantics(container: '
          'true) or list-role marker of its own — a real, currently '
          'harmless gap, reported rather than silently fixed.',
      'Known platform differences: none observed.',
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'No responsive branching: renders identically across widths. Media '
          'is fixed-square, content fills flex space, actions are '
          'right-aligned or top-aligned depending on the alignStart '
          'flag.',
      'Long titles clip to one line and ellipsize; long descriptions '
          'clip to two.',
      'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all '
          'render the same widget tree.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'File: lib/src/components/item.dart, one file, no companions.',
      'Imports: foundation/colors.dart (elTransparent), '
          'foundation/spacing.dart, foundation/theme.dart, '
          'foundation/typography.dart, theme_scope.dart. '
          'ElItem.mutedFillAlpha (0.50) is a static const declared inside '
          'ElItem itself, not imported from colors.dart. No component or '
          'effect dependency.',
      'Assets: none. Fonts: none beyond the system type scale every '
          'ElText call already depends on. Shaders: none.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'Borders use theme.border (variant=outline) or a transparent '
          'stroke (variant=normal/muted); the muted fill is '
          'theme.muted at 50% alpha (ElItem.mutedFillAlpha). Content '
          'text uses theme.foreground/mutedForeground from '
          'ElItemContent and ElItemDescription. All re-resolve on a live '
          'theme flip.',
      'The group gap drift, reproduced as measured: item.dart\'s own doc '
          'comment traces it to the reference\'s '
          '`has-data-[size=sm]:gap-2.5` rule, which is meant to read '
          '"when the *items* in me are small, tighten" but compiles to '
          '"when ANY descendant carries that attribute", so a row ending '
          'in a size=sm button tightens the WHOLE group\'s gap, not just '
          'that row. ElItemGroup.gap is 10px by default; a caller wanting '
          'the tightened 2.5px passes gapOverride explicitly, since '
          'Flutter has no descendant-selector equivalent to reproduce the '
          'quirk automatically.',
      'No colour-override parameter of its own on any class: every '
          'colour is theme- or variant-derived, never a bare Color '
          'argument.',
    ]),
  );

  Widget _source() => ElSection(
    id: 'source',
    title: 'Source',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source',
          value: itemDoc.sourcePath,
          description:
              'Authoritative implementation: the truth this page was '
              'written from.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'none yet',
          description:
              'No dedicated unit test exists for item.dart in the '
              'package test suite as of this page.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/item_test.dart',
          description:
              'Covers this page: the API tables, live specimens, and '
              'both themes.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/item/page.dart',
          description: 'This file.',
        ),
      ],
    ),
  );
}

Widget _bullets(ElThemeData theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText('•  $line', ElType.small, color: theme.mutedForeground),
      ),
      SizedBox(height: el(2)),
    ],
  ],
);

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElItemGroup(
  children: [
    ElItem(
      media: ElItemMedia(child: ElIcon.lucide(ElLucide.mail, size: ElIconSize.sm)),
      content: ElItemContent(
        children: [
          ElItemTitle('Inbox'),
          ElItemDescription('12 unread messages'),
        ],
      ),
      actions: ElItemActions(
        children: [
          ElButton(
            variant: ElButtonVariant.ghost,
            size: ElButtonSize.sm,
            onPressed: () {},
            child: ElText('Mark read', ElComponentType.buttonLabel),
          ),
        ],
      ),
    ),
  ],
)''';
