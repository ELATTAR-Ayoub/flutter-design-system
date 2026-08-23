/// Public component documentation for the toggle and toggle-group
/// components — one page, because `toggle_group.dart`'s own library doc
/// states the reason: a `ToggleGroupItem` **is** a [DsToggle] underneath
/// (`toggleVariants(...)` plus two trailing overrides), so the group's
/// semantics only make sense read alongside the item's.
///
/// `toggleDoc` (from `meta.dart`) is the data source, not
/// `componentDoc('toggle')` — toggle is not yet registered in
/// `catalog.dart`'s `componentDocs` list, so calling that would throw. Adding
/// it there is a supervisor-owned aggregation step (Phase J plan).
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class ToggleDocPage extends StatelessWidget {
  const ToggleDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    return DocsLayout(
      route: toggleDoc.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / BASE',
        title: toggleDoc.title,
        description: toggleDoc.description,
      ),
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Toggle'),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Overview', anchor: 'overview'),
        DocsTocEntry(title: 'Status', anchor: 'status'),
        DocsTocEntry(title: 'Preview', anchor: 'preview'),
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'API', anchor: 'api'),
        DocsTocEntry(title: 'Variants and sizes', anchor: 'variants'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive behavior', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies and files', anchor: 'dependencies'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      // Wave 1's alphabetical neighbours (Phase J plan inventory). Neither
      // route is registered yet either — the whole wave's previous/next chain
      // is stitched together once the supervisor aggregates every meta.dart,
      // the same as this page's own route is not reachable until then.
      previous: const DocsPageLink(
        title: 'Switch',
        route: '/components/switch',
      ),
      next: const DocsPageLink(title: 'Tooltip', route: '/components/tooltip'),
      onNavigate: onNavigate,
      child: _ToggleArticle(theme: DsTheme.of(context)),
    );
  }
}

class _ToggleArticle extends StatelessWidget {
  const _ToggleArticle({required this.theme});

  final DsThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey<String>('toggle-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsSection(
          id: 'overview',
          title: 'When to use a toggle',
          description:
              'What each one solves, and when a neighbouring control '
              'answers the same interaction better.',
          child: DsText(toggleExpandedDescription, DsType.body),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'status',
          title: 'Status',
          child: DocsInstallFacts(
            title: 'Status',
            facts: <DocsInstallFact>[
              const DocsInstallFact(
                label: 'Status',
                value: 'Stable, not yet a registry item',
                description:
                    'Ported and tested against lib/src/components/toggle.dart '
                    'and lib/src/components/toggle_group.dart. Neither is '
                    'yet a registry item, so elattar add toggle will not '
                    'resolve — see Installation below.',
              ),
              DocsInstallFact(
                label: 'Version',
                value: '0.0.1',
                description:
                    'Tracks the package version; there is no registry schema '
                    'version yet because there is no manifest.',
              ),
              const DocsInstallFact(
                label: 'Platforms',
                value: 'Android, iOS, Web, macOS, Windows, Linux',
                description:
                    'A pure Flutter widget tree — no platform channel and no '
                    'platform-specific branch in either component.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'preview',
          title: 'Preview',
          description:
              'Five standalone DsToggle specimens, then a live DsToggleGroup. '
              'Rest, Selected, Outline variant and Focus-visible are '
              'operable — tap or Tab to them. Disabled is deliberately '
              'inert. The group specimen states its own selectedIndex live, '
              'including the moment it becomes null.',
          child: DocsCodeExample(
            title: 'Toggle and toggle-group specimens',
            description:
                'Every cell below renders a real DsToggle or DsToggleGroup.',
            preview: const _TogglePreview(),
            manualFiles: <DocsCodeFile>[
              DocsCodeFile(
                path: toggleDoc.sourcePath,
                code:
                    '// toggle has no registry manifest yet, so there is no\n'
                    '// generated @ui/toggle.dart payload to copy here.\n'
                    '// See "Installation" below for what actually works '
                    'today.',
              ),
              const DocsCodeFile(
                path: toggleGroupSourcePath,
                code:
                    '// toggle-group has no registry manifest either — it\n'
                    '// depends on toggle.dart, so it could not resolve on\n'
                    '// its own even if it did.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'install',
          title: 'Installation',
          description:
              'Command install is not available yet — read this before '
              'reaching for elattar add toggle.',
          child: DocsInstallFacts(
            facts: <DocsInstallFact>[
              const DocsInstallFact(
                label: 'CLI',
                value: 'Not available',
                description:
                    'toggle and toggle-group are not yet registry items, so '
                    '`elattar add toggle` will not resolve. They are among '
                    'the Wave 1 base components still awaiting a manifest — '
                    'see the Phase J documentation plan.',
              ),
              const DocsInstallFact(
                label: 'Manual — package mode (supported today)',
                value:
                    "import 'package:elattar_design_system/elattar_design_system.dart';",
                description:
                    'Depend on the package and use DsToggle and '
                    'DsToggleGroup directly, exactly as this page does.',
              ),
              DocsInstallFact(
                label: 'Manual — source mode (not recommended yet)',
                value: '${toggleDoc.sourcePath}, $toggleGroupSourcePath',
                description:
                    'Copying these two files will not compile on their own '
                    '— they need sibling files with them (see Dependencies '
                    'and files below), and no manifest exists yet to '
                    'resolve them for you.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'usage',
          title: 'Usage',
          description:
              'The smallest correct standalone example, then the group '
              'and its nullable selection.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DsPanel(
                label: 'DART',
                note: 'SMALLEST CORRECT EXAMPLE',
                child: DocsSelectableCodeBlock(code: _smallestUsageCode),
              ),
              SizedBox(height: ds(5)),
              DsText(
                'DsToggleGroup.onChanged is ValueChanged<int?> — tapping an '
                'unselected option calls it with that option\'s index, and '
                'tapping the already-selected option calls it with null. '
                'selectedIndex has to accept both: the group never decides '
                'on its own whether "nothing selected" is a state your UI '
                'allows, it only reports the tap. A live specimen of '
                'exactly this — including the moment selectedIndex becomes '
                'null — follows:',
                DsType.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: ds(3)),
              const _SortControlExample(),
              SizedBox(height: ds(3)),
              DsPanel(
                label: 'DART',
                note: 'A NULLABLE GROUP',
                child: DocsSelectableCodeBlock(code: _groupUsageCode),
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'api',
          title: 'API',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DocsApiTable(
                title: 'DsToggle',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'child',
                    type: 'Widget',
                    description:
                        'The content — a label, an icon, or a row of both '
                        'spaced by DsToggle.gap. This widget installs the '
                        'resolved text style as a DefaultTextStyle, so a '
                        'bare Text child is the right choice for a '
                        'labelled toggle.',
                  ),
                  DocsApiFact(
                    name: 'pressed',
                    type: 'bool',
                    description:
                        'Which of the two states is rendered — on when '
                        'true. The control never holds its own state: it '
                        'is fully governed by the caller, because a group '
                        'above it may need to clear the selection '
                        'entirely.',
                  ),
                  DocsApiFact(
                    name: 'onChanged',
                    type: 'ValueChanged<bool>?',
                    description:
                        'Called with the value the control is asking to '
                        'move to — always !pressed, since a toggle has '
                        'exactly one other state. Null disables the '
                        'control.',
                  ),
                  DocsApiFact(
                    name: 'variant',
                    type: 'DsToggleVariant',
                    description:
                        'Defaults to DsToggleVariant.standard (no border '
                        'box at all). outline adds a 1px theme.input '
                        'border.',
                  ),
                  DocsApiFact(
                    name: 'size',
                    type: 'DsToggleSize',
                    description:
                        'Defaults to DsToggleSize.md (32px tall). sm is '
                        '28px, lg is 36px.',
                  ),
                  DocsApiFact(
                    name: 'label',
                    type: 'String?',
                    description:
                        'The accessible name — overrides, rather than '
                        'adds to, whatever name the child\'s own content '
                        'would supply. Required for an icon-only toggle to '
                        'have any accessible name; optional for a '
                        'text-labelled one, whose own text already names '
                        'it.',
                  ),
                  DocsApiFact(
                    name: 'focusNode',
                    type: 'FocusNode?',
                    description:
                        'Supply one to drive focus-visible from outside; '
                        'otherwise the control owns its own node.',
                  ),
                  DocsApiFact(
                    name: 'pressedFill',
                    type: 'Color?',
                    description:
                        'The fill painted while pressed is true. Null '
                        'keeps the default on-fill, theme.muted. Exists '
                        'for DsToggleGroup alone, which overrides it to a '
                        'transparent fill so its travelling pill shows '
                        'through.',
                  ),
                  DocsApiFact(
                    name: 'pressedInk',
                    type: 'Color?',
                    description:
                        'The ink painted while pressed is true. Null '
                        'keeps the inherited theme.foreground. '
                        'DsToggleGroup overrides it to '
                        'theme.primaryForeground for the selected item.',
                  ),
                  DocsApiFact(
                    name: 'inExclusiveGroup',
                    type: 'bool',
                    description:
                        'Defaults to false. true changes only the '
                        'semantics node: a standalone toggle announces as '
                        'a button with an on/off state; one option of a '
                        'single-select group announces as a choice among '
                        'others instead (selected + '
                        'inMutuallyExclusiveGroup).',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'DsToggleVariant, DsToggleSize and statics',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'DsToggleVariant.standard',
                    type: 'enum value',
                    description:
                        'bg-transparent, no border box at all — the '
                        'default.',
                  ),
                  DocsApiFact(
                    name: 'DsToggleVariant.outline',
                    type: 'enum value',
                    description: 'A 1px theme.input border, still no fill.',
                  ),
                  DocsApiFact(
                    name: 'DsToggleSize.sm',
                    type: 'enum value',
                    description: '28px tall.',
                  ),
                  DocsApiFact(
                    name: 'DsToggleSize.md',
                    type: 'enum value',
                    description: '32px tall — the default.',
                  ),
                  DocsApiFact(
                    name: 'DsToggleSize.lg',
                    type: 'enum value',
                    description: '36px tall.',
                  ),
                  DocsApiFact(
                    name: 'DsToggle.heightFor',
                    type: 'static double Function(DsToggleSize)',
                    description: '28 / 32 / 36 for sm / md / lg.',
                  ),
                  DocsApiFact(
                    name: 'DsToggle.minWidthFor',
                    type: 'static double Function(DsToggleSize)',
                    description:
                        'The same 28 / 32 / 36 floor, so a 16px icon-only '
                        'toggle does not collapse onto its glyph.',
                  ),
                  DocsApiFact(
                    name: 'DsToggle.paddingX',
                    type: 'static double',
                    description: '10px of horizontal padding, on every size.',
                  ),
                  DocsApiFact(
                    name: 'DsToggle.gap',
                    type: 'static double',
                    description:
                        '4px between an icon and a label, when a caller '
                        'composes both into one child Row.',
                  ),
                  DocsApiFact(
                    name: 'DsToggle.radiusFor',
                    type: 'static double Function(DsToggleSize)',
                    description: '12px on md and lg; a clamped ~10px on sm.',
                  ),
                  DocsApiFact(
                    name: 'DsToggle.iconSizeFor',
                    type: 'static DsIconSize Function(DsToggleSize)',
                    description:
                        'The icon rung a child DsIcon should render at to '
                        'match this control\'s size — DsIconSize.sm on '
                        'DsToggleSize.sm, DsIconSize.md otherwise.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'DsToggleGroupItem',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'label',
                    type: 'String',
                    description:
                        'The option\'s name — both what it renders as its '
                        'default child and what a screen reader '
                        'announces.',
                  ),
                  DocsApiFact(
                    name: 'child',
                    type: 'Widget?',
                    description:
                        'What the item renders in place of its own label '
                        'text. Null — the default — renders label as a '
                        'bare Text in the toggle\'s resolved style.',
                  ),
                  DocsApiFact(
                    name: 'enabled',
                    type: 'bool',
                    description:
                        'Defaults to true. false disables just this one '
                        'option; DsToggleGroup wires its onChanged to null '
                        'for a disabled item, the same as a standalone '
                        'DsToggle.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'DsToggleGroup',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'items',
                    type: 'List<DsToggleGroupItem>',
                    description: 'The options, in paint order.',
                  ),
                  DocsApiFact(
                    name: 'selectedIndex',
                    type: 'int?',
                    description:
                        'Which option is selected, or null for none — '
                        'the state the travelling pill reads. Null or '
                        'out-of-range is what DsSlidingPillGroup treats as '
                        '"deselected": the pill fades to 0 opacity and '
                        'stays parked where it last was.',
                  ),
                  DocsApiFact(
                    name: 'onChanged',
                    type: 'ValueChanged<int?>',
                    description:
                        'Called with the new selection: the tapped index, '
                        'or null when the tapped option was already '
                        'selected — Radix type="single" deselect '
                        'semantics. Not nullable itself: a group always '
                        'needs a way to hear both an index and a clear.',
                  ),
                  DocsApiFact(
                    name: 'variant',
                    type: 'DsToggleVariant',
                    description:
                        'Passed to every item. Defaults to '
                        'DsToggleVariant.standard.',
                  ),
                  DocsApiFact(
                    name: 'size',
                    type: 'DsToggleSize',
                    description:
                        'Passed to every item. Defaults to '
                        'DsToggleSize.md.',
                  ),
                  DocsApiFact(
                    name: 'label',
                    type: 'String?',
                    description:
                        'The group\'s own accessible name. Null — the '
                        'default — emits no extra container semantics '
                        'node; supply one when nothing else on the screen '
                        'names the group.',
                  ),
                  DocsApiFact(
                    name: 'DsToggleGroup.gap',
                    type: 'static double',
                    description:
                        '8px between items — also the gap the travelling '
                        'pill\'s own geometry is measured against.',
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'variants',
          title: 'Variants and sizes',
          description:
              'Two variants times three sizes — all six combinations are '
              'real and tappable below, unlike DsCheckbox\'s fixed geometry.',
          child: const _ToggleSizeVariantGrid(),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'states',
          title: 'States and feedback',
          description:
              'Pressed, Loading, Empty, Error and Success are omitted '
              'below — reasons follow the table.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DocsStateMatrix(
                facts: <DocsStateFact>[
                  DocsStateFact(
                    state: 'Rest',
                    treatment:
                        'standard: no fill, no border. outline: a 1px '
                        'theme.input border. Ink is theme.foreground '
                        'either way — hover:text-foreground in the '
                        'reference restates a colour the element already '
                        'has and changes nothing.',
                    userSignal:
                        'An unfilled control, distinguishable from '
                        'Selected only once a fill or border tells them '
                        'apart.',
                  ),
                  DocsStateFact(
                    state: 'Hover',
                    treatment:
                        'theme.muted fill, on both variants — the same '
                        'fill Selected paints outside a group, so hover '
                        'and on are visually identical there.',
                    userSignal:
                        'A grey wash appears under the pointer; the '
                        'cursor becomes a click cursor.',
                  ),
                  DocsStateFact(
                    state: 'Selected (on) — standalone',
                    treatment:
                        'theme.muted fill (the class hover also paints), '
                        'theme.foreground ink. Unlike DsSwitch and '
                        'DsCheckbox, the on-state is not the brand colour '
                        'here.',
                    userSignal:
                        'A filled control that stays filled after the '
                        'pointer leaves — the only way Rest and Selected '
                        'are told apart outside a group.',
                  ),
                  DocsStateFact(
                    state: 'Selected — in a group',
                    treatment:
                        'pressedFill: transparent, pressedInk: '
                        'theme.primaryForeground — the item gives up its '
                        'own fill so DsSlidingPillGroup\'s single '
                        'theme.primary pill, already travelling '
                        'underneath it, shows through.',
                    userSignal:
                        'White-on-blue ink over the travelling pill — the '
                        'one place selection reads as the brand colour on '
                        'this page.',
                  ),
                  DocsStateFact(
                    state: 'Focus-visible',
                    treatment:
                        'A 3px ring at theme.ring, 50% alpha. On outline '
                        'the border also swaps to theme.ring; on standard '
                        'there is no border box to colour, so only the '
                        'ring paints.',
                    userSignal:
                        'A ring that appears only after keyboard focus — '
                        'a bare pointer tap does not request focus, so a '
                        'tapped-and-released toggle shows no ring.',
                  ),
                  DocsStateFact(
                    state: 'Disabled',
                    treatment:
                        'onChanged: null — 50% opacity, and an '
                        'IgnorePointer that removes the control from '
                        'hit-testing and hover tracking together, and '
                        'from the tab order.',
                    userSignal:
                        'Dimmed and inert — the one state that visibly '
                        'dims, matching DsButton\'s own disabled '
                        'treatment.',
                  ),
                  DocsStateFact(
                    state: 'Reduced motion',
                    treatment:
                        'The fill/ink/border/ring tween chain and '
                        'DsSlidingPillGroup\'s own travel both resolve '
                        'through dsAnimationDuration, which reduced '
                        'motion shortens toward zero.',
                    userSignal:
                        'State changes land on their finished colours and '
                        'position immediately, with no transition or '
                        'travel to sit through.',
                  ),
                ],
              ),
              SizedBox(height: ds(4)),
              DsText(
                'Omitted: Pressed — the class list carries no :active rule '
                'and no press-motion utility; a toggle does nothing at all '
                'between pointer-down and pointer-up, unlike DsButton\'s '
                'spring squash (a documented drift in toggle.dart\'s own '
                'header). Loading and Empty — both components are '
                'synchronous primitives with no async operation and '
                'nothing to list. Error — aria-invalid is never set on '
                'this control anywhere in the reference; neither DsToggle '
                'nor DsToggleGroup exposes an invalid parameter at all. '
                'Success — neither component defines success semantics of '
                'its own.',
                DsType.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'accessibility',
          title: 'Accessibility',
          child: DocsInstallFacts(
            title: 'Accessibility',
            facts: <DocsInstallFact>[
              const DocsInstallFact(
                label: 'Semantic role',
                value: 'Semantics(button:, toggled:/selected:)',
                description:
                    'A standalone toggle (inExclusiveGroup: false) exposes '
                    'toggled: pressed. One option of a DsToggleGroup '
                    '(inExclusiveGroup: true, set by the group for every '
                    'item) exposes selected: pressed and '
                    'inMutuallyExclusiveGroup: true instead, with toggled '
                    'left null — a choice among others, not an '
                    'independent on/off switch.',
              ),
              const DocsInstallFact(
                label: 'Label association',
                value: 'label',
                description:
                    'Overrides, rather than adds to, the child\'s own '
                    'content-derived name (excludeSemantics: true '
                    'whenever label is set). Required for an icon-only '
                    'toggle to have any accessible name; '
                    'DsToggleGroupItem.label is passed straight through as '
                    'this for every item the group builds.',
              ),
              const DocsInstallFact(
                label: 'Keyboard activation',
                value: 'Enter, numpad Enter, Space',
                description:
                    'Hand-wired through Focus.onKeyEvent, the same wiring '
                    'DsButton and DsCheckbox use — the control is not a '
                    'native button, so nothing arrives for free.',
              ),
              const DocsInstallFact(
                label: 'Focus behavior',
                value: 'A 3px ring at theme.ring, 50% alpha — keyboard-only',
                description:
                    'focus-visible, not focus. Flutter does not move focus '
                    'on a bare pointer tap, so hasFocus here already is the '
                    'keyboard-only predicate CSS means; a '
                    'tapped-and-released toggle never shows the ring.',
              ),
              const DocsInstallFact(
                label: 'Touch target',
                value: 'Exactly the visual box — no cushion',
                description:
                    '28×28 / 32×32 / 36×36 depending on size. Unlike '
                    'DsCheckbox\'s DsHitArea, DsToggle wraps its '
                    'GestureDetector directly around the sized box with no '
                    'extra hit-test padding. Every size sits below the '
                    'system\'s 44px touch-target floor; recorded rather '
                    'than corrected, because it is what the source '
                    'renders.',
              ),
              const DocsInstallFact(
                label: 'Non-colour signal',
                value: 'The toggled/selected semantics flag itself',
                description:
                    'Visually, the only change between Rest and Selected '
                    'outside a group is a fill colour; a sighted user who '
                    'cannot rely on that has no drawn glyph to fall back '
                    'on the way DsCheckbox\'s tick provides. A screen '
                    'reader is told regardless, through the toggled or '
                    'selected flag.',
              ),
              const DocsInstallFact(
                label: 'Error wiring',
                value: 'N/A — no invalid parameter exists',
                description:
                    'Neither DsToggle nor DsToggleGroup declares an '
                    'invalid/aria-invalid path; the source states '
                    'aria-invalid is "never set on this control anywhere '
                    'in the reference." There is nothing to wire.',
              ),
              const DocsInstallFact(
                label: 'Screen-reader announcements',
                value: 'No live region',
                description:
                    'State changes are exposed purely through the '
                    'semantics flags above; no extra announcement is '
                    'authored.',
              ),
              const DocsInstallFact(
                label: 'Known divergence',
                value: 'Roving focus is not ported',
                description:
                    'Radix wraps a ToggleGroup\'s items in a '
                    'RovingFocusGroup — one Tab stop for the whole group, '
                    'arrow keys to move within it. Flutter\'s default '
                    'traversal gives every item its own Tab stop instead; '
                    'toggle_group.dart states this divergence rather than '
                    'approximating half of the reference behaviour.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'responsive',
          title: 'Responsive and platform behavior',
          child: DsText(
            'Neither component has breakpoints of its own: DsToggle is a '
            'fixed-height atomic control (28 / 32 / 36px) and DsToggleGroup '
            'is a Row of them plus a travelling pill, sized to its own '
            'content. What changes with layout belongs to whatever composes '
            'them — example/lib/shots_docs/shots_index_page.dart wraps its '
            'two DsToggleGroup filters in a SingleChildScrollView because a '
            'four-item family filter does not fit every narrow viewport, '
            'and DsSlidingPillGroup has no wrap of its own to fall back on. '
            'Keyboard activation and pointer activation behave identically '
            'on every Flutter target this package supports; there is no '
            'platform channel and nothing here is web-only or '
            'desktop-only.',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'dependencies',
          title: 'Dependencies, files, assets, fonts and shaders',
          child: DocsInstallFacts(
            title: 'Dependencies and files',
            facts: <DocsInstallFact>[
              DocsInstallFact(
                label: 'Source files',
                value: '${toggleDoc.sourcePath}, $toggleGroupSourcePath',
                description:
                    'The authoritative implementations. toggle_group.dart '
                    'imports toggle.dart directly — every group item is a '
                    'DsToggle underneath.',
              ),
              const DocsInstallFact(
                label: 'Local file dependencies',
                value:
                    'button.dart, icon.dart, effects/machine_surface.dart, '
                    'motion/sliding_pill.dart',
                description:
                    'toggle.dart imports button.dart for '
                    'DsButton.withFocusRing and icon.dart for the '
                    'DsIconSize return type of iconSizeFor; both files '
                    'import effects/machine_surface.dart for '
                    'DsMachineSurface. toggle_group.dart additionally '
                    'imports motion/sliding_pill.dart for '
                    'DsSlidingPillGroup, the travelling-pill machinery it '
                    'shares with DsTabs, DsSidebar and IconSwap. None are '
                    'copyable in isolation — see Installation.',
              ),
              const DocsInstallFact(
                label: 'Foundation dependencies',
                value:
                    'foundation/colors.dart, foundation/motion.dart, '
                    'foundation/shadows.dart, foundation/spacing.dart, '
                    'foundation/theme.dart, foundation/typography.dart, '
                    'theme_scope.dart',
                description:
                    'Token sources: the transparent-colour constant, '
                    'durations and curves, shadow specs, the ds() spacing '
                    'scale, the live theme, and the resolved toggle-label '
                    'text style.',
              ),
              DocsInstallFact(
                label: 'Exports',
                value: toggleDoc.exports.join(', '),
                description:
                    'The public symbols these two components make '
                    'available.',
              ),
              const DocsInstallFact(
                label: 'Assets',
                value: 'none',
                description:
                    'Both components paint fills, borders, rings and the '
                    'travelling pill with plain box decoration — no image '
                    'and no icon-font glyph of their own. An icon child, '
                    'if one is composed in, brings its own geometry from '
                    'icon_paths.dart, not an asset file.',
              ),
              const DocsInstallFact(
                label: 'Fonts',
                value: 'none',
                description:
                    'Neither component renders text of its own; a text '
                    'child inherits whatever the app\'s theme already '
                    'resolves.',
              ),
              const DocsInstallFact(
                label: 'Shaders',
                value: 'none',
                description: 'No fragment shader is used by either file.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'composition',
          title: 'Composition examples',
          description:
              'Three larger, real patterns built from the same '
              'constructors — not manufactured examples the Dart API '
              'cannot support.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DsPanel(
                label: 'DART',
                note: 'INDEPENDENT TOOLBAR TOGGLES',
                child: DocsSelectableCodeBlock(code: _toolbarCode),
              ),
              SizedBox(height: ds(4)),
              DsText(
                'Two DsToggles, not a DsToggleGroup: Bold and Italic can '
                'both be on, both be off, or any mix — there is no mutual '
                'exclusivity between them, so a group (which always has at '
                'most one selection) would be the wrong tool.',
                DsType.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: ds(5)),
              DsPanel(
                label: 'DART',
                note: 'HETEROGENEOUS GROUP CHILDREN',
                child: DocsSelectableCodeBlock(code: _viewSwitcherCode),
              ),
              SizedBox(height: ds(4)),
              DsText(
                'DsToggleGroupItem.child is per-item and optional: two '
                'options here supply an icon-and-label row, and the third '
                'omits child entirely and falls back to a bare '
                'Text(label).',
                DsType.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: ds(5)),
              DsPanel(
                label: 'DART',
                note: 'TWO VALID DESELECTION POLICIES',
                child: DocsSelectableCodeBlock(code: _policyCode),
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'theming',
          title: 'Theming notes',
          child: DocsInstallFacts(
            title: 'Tokens this component reads',
            facts: const <DocsInstallFact>[
              DocsInstallFact(
                label: 'Fill',
                value:
                    'theme.muted (hover / on, standalone) / transparent '
                    '(on, inside a group)',
                description: 'The control\'s own background.',
              ),
              DocsInstallFact(
                label: 'Border',
                value:
                    'theme.input (outline, rest) / theme.ring (outline, '
                    'focus-visible)',
                description:
                    'Only painted on DsToggleVariant.outline — standard '
                    'has no border box at all.',
              ),
              DocsInstallFact(
                label: 'Ink',
                value:
                    'theme.foreground (rest and on, standalone) / '
                    'theme.primaryForeground (on, inside a group)',
                description: 'The child\'s resolved text/icon colour.',
              ),
              DocsInstallFact(
                label: 'Ring',
                value: 'theme.ring at 50% alpha',
                description: 'The focus-visible ring.',
              ),
              DocsInstallFact(
                label: 'Pill (group only)',
                value: 'theme.primary, DsShadows.chip, DsRadii.pill',
                description:
                    'The one blue selection surface either component '
                    'paints — DsSlidingPillGroup\'s travelling pill.',
              ),
              DocsInstallFact(
                label: 'Radius',
                value: 'DsRadii.lg (md/lg) / a clamped ~DsRadii.md (sm)',
                description:
                    'The item\'s own corner. The group\'s pill is always '
                    'DsRadii.pill regardless of item size — a stadium '
                    'over a rounded rect in the same slot, a documented '
                    'drift in toggle_group.dart\'s own header.',
              ),
              DocsInstallFact(
                label: 'Motion',
                value:
                    'DsDurations.transitionDefault, DsCurves.out, '
                    'DsSlidingPillGroup',
                description:
                    'The toggle\'s own fill/ink/border/ring tween chain, '
                    'and the pill\'s 250ms spring travel plus jelly '
                    'squash — all resolved through dsAnimationDuration, so '
                    'reduced motion shortens or removes them '
                    'automatically.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'source',
          title: 'Source and tests',
          child: DocsInstallFacts(
            facts: <DocsInstallFact>[
              DocsInstallFact(
                label: 'Toggle source',
                value: toggleDoc.sourcePath,
                description: 'Authoritative implementation of DsToggle.',
              ),
              const DocsInstallFact(
                label: 'Toggle-group source',
                value: toggleGroupSourcePath,
                description:
                    'Authoritative implementation of DsToggleGroup and '
                    'DsToggleGroupItem.',
              ),
              const DocsInstallFact(
                label: 'Shared machinery',
                value: 'lib/src/motion/sliding_pill.dart',
                description:
                    'DsSlidingPillGroup — shared with DsTabs, DsSidebar '
                    'and IconSwap, and documented on their own component '
                    'pages.',
              ),
              const DocsInstallFact(
                label: 'Package tests',
                value: 'test/components_test.dart',
                description:
                    'The DsToggle and DsToggleGroup groups within that '
                    'file cover geometry, statics and state behaviour for '
                    'both components in the package itself.',
              ),
              const DocsInstallFact(
                label: 'Docs page tests',
                value: 'example/test/components_docs/toggle_test.dart',
                description:
                    'Coverage for this page: API completeness for both '
                    'components, the live toggle and group specimens '
                    '(including the group\'s deselect-to-null path), and '
                    'both themes.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

const String _smallestUsageCode = '''bool bold = false;

DsToggle(
  pressed: bold,
  label: 'Bold',
  onChanged: (bool next) => setState(() => bold = next),
  child: const Text('B'),
)''';

const String _groupUsageCode = '''int? sortIndex = 0;

DsToggleGroup(
  items: const <DsToggleGroupItem>[
    DsToggleGroupItem(label: 'Newest'),
    DsToggleGroupItem(label: 'Price'),
    DsToggleGroupItem(label: 'Popular'),
  ],
  selectedIndex: sortIndex,
  // Receives the tapped index, or null when the tap re-selected the
  // option that was already active.
  onChanged: (int? next) => setState(() => sortIndex = next),
)''';

const String _toolbarCode = '''bool bold = false;
bool italic = false;

Row(
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    DsToggle(
      pressed: bold,
      label: 'Bold',
      onChanged: (bool next) => setState(() => bold = next),
      child: const Text('B'),
    ),
    SizedBox(width: DsToggle.gap),
    DsToggle(
      pressed: italic,
      label: 'Italic',
      onChanged: (bool next) => setState(() => italic = next),
      child: const Text('I'),
    ),
  ],
)''';

const String _viewSwitcherCode =
    '''// DsToggleGroupItem.child is optional per item: two options here supply
// an icon-and-label row, and the third omits child and falls back to a
// bare Text(label).
int? viewIndex = 0;

DsToggleGroup(
  items: <DsToggleGroupItem>[
    DsToggleGroupItem(
      label: 'Grid',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DsIcon(
            DsIconGlyph.layoutGrid,
            size: DsToggle.iconSizeFor(DsToggleSize.md),
          ),
          SizedBox(width: DsToggle.gap),
          const Text('Grid'),
        ],
      ),
    ),
    DsToggleGroupItem(
      label: 'List',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DsIcon(
            DsIconGlyph.rows3,
            size: DsToggle.iconSizeFor(DsToggleSize.md),
          ),
          SizedBox(width: DsToggle.gap),
          const Text('List'),
        ],
      ),
    ),
    const DsToggleGroupItem(label: 'Table'),
  ],
  selectedIndex: viewIndex,
  onChanged: (int? next) => setState(() => viewIndex = next),
)''';

const String _policyCode =
    '''// DsToggleGroup has no opinion on what null means to your screen — it
// only reports it. Two real policies, both valid:

// 1. Keep the null: "nothing selected" is a real, distinct state.
onChanged: (int? next) => setState(() => sortIndex = next),

// 2. Coerce it: never let the group end up with nothing selected.
// example/lib/shots_docs/shots_index_page.dart makes this choice for its
// own family and platform filters:
onFamilyChanged: (int? index) => setState(() => familyIndex = index ?? 0),''';

/// The Preview section's live specimens: five standalone [DsToggle]s in a
/// [Wrap], then a live [DsToggleGroup].
class _TogglePreview extends StatefulWidget {
  const _TogglePreview();

  @override
  State<_TogglePreview> createState() => _TogglePreviewState();
}

class _TogglePreviewState extends State<_TogglePreview> {
  bool _rest = false;
  bool _selected = true;
  bool _outline = false;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Wrap(
          spacing: ds(3),
          runSpacing: ds(3),
          children: <Widget>[
            DsStateCell(
              label: 'Rest',
              note: 'Tap to toggle',
              child: DsToggle(
                key: const ValueKey<String>('toggle-live-specimen'),
                pressed: _rest,
                label: 'Favorite',
                onChanged: (bool next) => setState(() => _rest = next),
                child: DsIcon(
                  DsIconGlyph.heart,
                  size: DsToggle.iconSizeFor(DsToggleSize.md),
                ),
              ),
            ),
            DsStateCell(
              label: 'Selected (on)',
              note: 'Tap to toggle',
              child: DsToggle(
                pressed: _selected,
                label: 'Favorite',
                onChanged: (bool next) => setState(() => _selected = next),
                child: DsIcon(
                  DsIconGlyph.heart,
                  size: DsToggle.iconSizeFor(DsToggleSize.md),
                ),
              ),
            ),
            DsStateCell(
              label: 'Outline variant',
              note: 'Tap to toggle',
              child: DsToggle(
                variant: DsToggleVariant.outline,
                pressed: _outline,
                label: 'Bold',
                onChanged: (bool next) => setState(() => _outline = next),
                child: const Text('B'),
              ),
            ),
            const DsStateCell(
              label: 'Focus-visible',
              note: 'Real keyboard focus, not a forced prop',
              child: _ToggleFocusDemo(),
            ),
            DsStateCell(
              label: 'Disabled',
              child: DsToggle(
                pressed: false,
                label: 'Favorite',
                child: DsIcon(
                  DsIconGlyph.heart,
                  size: DsToggle.iconSizeFor(DsToggleSize.md),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        DsText('DsToggleGroup — segmented, single-select', DsType.label),
        SizedBox(height: ds(3)),
        const _ToggleGroupPreview(),
        SizedBox(height: ds(3)),
        DsText(
          'The pill above is theme.primary; the fading of "nothing '
          'selected" is what DsSlidingPillGroup renders whenever '
          'selectedIndex is null.',
          DsType.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

/// A [DsToggle] that requests real keyboard focus on mount, rather than a
/// forced prop — DsToggle exposes no `forceFocusRing`, so this is what
/// showing focus-visible genuinely means for this control.
class _ToggleFocusDemo extends StatefulWidget {
  const _ToggleFocusDemo();

  @override
  State<_ToggleFocusDemo> createState() => _ToggleFocusDemoState();
}

class _ToggleFocusDemoState extends State<_ToggleFocusDemo> {
  final FocusNode _node = FocusNode(debugLabel: 'toggle-focus-demo');
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (mounted) _node.requestFocus();
    });
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DsToggle(
      focusNode: _node,
      pressed: _pressed,
      label: 'Favorite',
      onChanged: (bool next) => setState(() => _pressed = next),
      child: DsIcon(
        DsIconGlyph.heart,
        size: DsToggle.iconSizeFor(DsToggleSize.md),
      ),
    );
  }
}

/// The live [DsToggleGroup] specimen — three sort options, one of which
/// starts selected, and the exact deselect-to-null behaviour the page exists
/// to document.
class _ToggleGroupPreview extends StatefulWidget {
  const _ToggleGroupPreview();

  @override
  State<_ToggleGroupPreview> createState() => _ToggleGroupPreviewState();
}

class _ToggleGroupPreviewState extends State<_ToggleGroupPreview> {
  static const List<String> _labels = <String>['Newest', 'Price', 'Popular'];

  int? _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // DsSlidingPillGroup's Row has no wrap of its own — at a narrow
        // viewport three segments can ask for more width than this column
        // has, exactly as example/lib/shots_docs/shots_index_page.dart's own
        // comment on its filter groups explains. Same fix here.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DsToggleGroup(
            key: const ValueKey<String>('toggle-group-live-specimen'),
            items: const <DsToggleGroupItem>[
              DsToggleGroupItem(label: 'Newest'),
              DsToggleGroupItem(label: 'Price'),
              DsToggleGroupItem(label: 'Popular'),
            ],
            selectedIndex: _selectedIndex,
            onChanged: (int? next) => setState(() => _selectedIndex = next),
          ),
        ),
        SizedBox(height: ds(3)),
        DsText(
          _selectedIndex == null
              ? 'selectedIndex: null — tap any option to select it.'
              : 'selectedIndex: $_selectedIndex — tap '
                    '"${_labels[_selectedIndex!]}" again to deselect it.',
          DsType.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

/// The Usage section's live "sort control" — the same nullable contract as
/// [_ToggleGroupPreview], composed a second time with its own state so the
/// section that explains the contract in prose also proves it live.
class _SortControlExample extends StatefulWidget {
  const _SortControlExample();

  @override
  State<_SortControlExample> createState() => _SortControlExampleState();
}

class _SortControlExampleState extends State<_SortControlExample> {
  static const List<String> _labels = <String>['Newest', 'Price', 'Popular'];

  int? _sortIndex = 0;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Same narrow-viewport overflow shots_index_page.dart's own filter
        // groups guard against — see _ToggleGroupPreview above.
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DsToggleGroup(
            items: const <DsToggleGroupItem>[
              DsToggleGroupItem(label: 'Newest'),
              DsToggleGroupItem(label: 'Price'),
              DsToggleGroupItem(label: 'Popular'),
            ],
            selectedIndex: _sortIndex,
            onChanged: (int? next) => setState(() => _sortIndex = next),
          ),
        ),
        SizedBox(height: ds(2)),
        DsText(
          _sortIndex == null
              ? 'Sorting by: none selected'
              : 'Sorting by: ${_labels[_sortIndex!]}',
          DsType.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

/// The Variants and sizes section's live grid: [DsToggleVariant] ×
/// [DsToggleSize], all six combinations real and independently tappable.
class _ToggleSizeVariantGrid extends StatefulWidget {
  const _ToggleSizeVariantGrid();

  @override
  State<_ToggleSizeVariantGrid> createState() => _ToggleSizeVariantGridState();
}

class _ToggleSizeVariantGridState extends State<_ToggleSizeVariantGrid> {
  static const List<DsToggleVariant> _variants = <DsToggleVariant>[
    DsToggleVariant.standard,
    DsToggleVariant.outline,
  ];
  static const List<DsToggleSize> _sizes = <DsToggleSize>[
    DsToggleSize.sm,
    DsToggleSize.md,
    DsToggleSize.lg,
  ];

  final List<bool> _pressed = List<bool>.filled(
    _variants.length * _sizes.length,
    false,
  );

  @override
  Widget build(BuildContext context) {
    final List<Widget> cells = <Widget>[];
    int index = 0;
    for (final DsToggleVariant variant in _variants) {
      for (final DsToggleSize size in _sizes) {
        final int cellIndex = index;
        cells.add(
          DsStateCell(
            label: '${variant.name} · ${size.name}',
            note: 'Tap to toggle',
            child: DsToggle(
              variant: variant,
              size: size,
              pressed: _pressed[cellIndex],
              label: 'Favorite',
              onChanged: (bool next) =>
                  setState(() => _pressed[cellIndex] = next),
              child: DsIcon(
                DsIconGlyph.heart,
                size: DsToggle.iconSizeFor(size),
              ),
            ),
          ),
        );
        index++;
      }
    }
    return Wrap(spacing: ds(3), runSpacing: ds(3), children: cells);
  }
}
