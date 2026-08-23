/// Public component documentation for the tabs component.
///
/// `tabsDoc` (from `meta.dart`) is the data source, not `componentDoc('tabs')`
/// — tabs is not yet registered in `catalog.dart`'s `componentDocs` list, so
/// calling that would throw. Adding it there is a supervisor-owned
/// aggregation step (Phase J plan).
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class TabsDocPage extends StatelessWidget {
  const TabsDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    return DocsLayout(
      route: tabsDoc.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / BASE',
        title: tabsDoc.title,
        description: tabsDoc.description,
      ),
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Tabs'),
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
      // Wave 3's alphabetical neighbours (Phase J plan inventory). Neither
      // route is registered yet either — the whole wave's previous/next chain
      // is stitched together once the supervisor aggregates every meta.dart,
      // the same as this page's own route is not reachable until then.
      previous: const DocsPageLink(
        title: 'Sidebar',
        route: '/components/sidebar',
      ),
      next: const DocsPageLink(title: 'Toaster', route: '/components/toaster'),
      onNavigate: onNavigate,
      child: _TabsArticle(theme: DsTheme.of(context)),
    );
  }
}

class _TabsArticle extends StatelessWidget {
  const _TabsArticle({required this.theme});

  final DsThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey<String>('tabs-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsSection(
          id: 'overview',
          title: 'When to use tabs',
          description:
              'What it solves, and when a neighbouring control answers the '
              'same interaction better.',
          child: DsText(
            'Tabs switch which panel of a single page is visible — every '
            'panel already belongs to the same screen, and picking a '
            'trigger swaps which one is shown while everything else (the '
            'route, the scaffold, the rest of the page) stays put. Reach '
            'for DsToggleGroup instead when there is no panel to reveal at '
            'all: a toggle group\'s selection is itself the payload the '
            'caller reads back (a sort order, a filter, a unit system), '
            'with nothing hidden underneath and shown on change. Reach for '
            'a navigation control (DsNavigationMenu, a sidebar entry, a '
            'route push) instead when picking an option should change the '
            'page itself — a new route, new browser history, a '
            'deep-linkable location — rather than swap a child within the '
            'one you are already on. Tabs and DsToggleGroup share their '
            'entire selection mechanism (the same DsSlidingPillGroup '
            'travelling mark this file\'s own docstring points at), so the '
            'two look and move identically; the only difference is what '
            'the selection means afterward. One more distinction worth '
            'knowing before reaching for either: DsToggleGroupItem carries '
            'its own enabled flag so a single option can be turned off, '
            'and DsTabItem has no equivalent — every tab this component '
            'renders is always operable.',
            DsType.body,
          ),
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
                    'Ported and tested against lib/src/components/tabs.dart. '
                    'It is not yet a registry item, so elattar add tabs '
                    'will not resolve — see Installation below.',
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
                    'A pure Flutter widget tree of Row/Stack/DecoratedBox — '
                    'no platform channel and no platform-specific branch.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'preview',
          title: 'Preview',
          description:
              'Two live specimens, one per variant, both built from the '
              'same DsTabs constructor — tap a trigger on either to switch '
              'its panel. The standard specimen\'s third trigger, More, '
              'carries no content: tapping it moves the mark and shows '
              'nothing underneath, which is Empty in States below, not a '
              'gap in this page.',
          child: DocsCodeExample(
            title: 'Tabs specimens',
            description:
                'Both cells below render a real DsTabs; this preview panel '
                'is itself built out of DsTabs to switch between its own '
                'Preview and Manual tabs.',
            preview: const _TabsPreview(),
            manualFiles: <DocsCodeFile>[
              DocsCodeFile(
                path: tabsDoc.sourcePath,
                code:
                    '// tabs has no registry manifest yet, so there is no\n'
                    '// generated @ui/tabs.dart payload to copy here.\n'
                    '// See "Installation" below for what actually works today.',
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
              'reaching for elattar add tabs.',
          child: DocsInstallFacts(
            facts: <DocsInstallFact>[
              const DocsInstallFact(
                label: 'CLI',
                value: 'Not available',
                description:
                    'tabs is not yet a registry item, so `elattar add '
                    'tabs` will not resolve. It is one of the Wave 3 '
                    'overlay-and-navigation components still awaiting a '
                    'manifest — see the Phase J documentation plan.',
              ),
              const DocsInstallFact(
                label: 'Manual — package mode (supported today)',
                value:
                    "import 'package:elattar_design_system/elattar_design_system.dart';",
                description:
                    'Depend on the package and use DsTabs directly, exactly '
                    'as this page does.',
              ),
              DocsInstallFact(
                label: 'Manual — source mode (not recommended yet)',
                value: tabsDoc.sourcePath,
                description:
                    'Copying this one file will not compile on its own — it '
                    'needs the sibling files listed under Dependencies and '
                    'files below, and no manifest exists yet to resolve '
                    'them for you.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'usage',
          title: 'Usage',
          description: 'The smallest correct example, then one with panels.',
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
                'A trigger with no content renders nothing when selected — '
                'the example above never mounts a panel at all. Give an '
                'item a content widget and DsTabs shows it under the '
                'track whenever that trigger is active:',
                DsType.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: ds(3)),
              DsPanel(
                label: 'DART',
                note: 'WITH PANELS',
                child: DocsSelectableCodeBlock(code: _panelsUsageCode),
              ),
              SizedBox(height: ds(3)),
              DsText(
                'variant: DsTabsVariant.line swaps the filled pill for a '
                '2px underline rule; nothing else about the call changes:',
                DsType.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: ds(3)),
              DsPanel(
                label: 'DART',
                note: 'LINE VARIANT',
                child: DocsSelectableCodeBlock(code: _lineUsageCode),
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
                title: 'DsTabs',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'items',
                    type: 'List<DsTabItem>',
                    description:
                        'Every tab: its trigger\'s label, and the optional '
                        'panel it reveals when selected.',
                  ),
                  DocsApiFact(
                    name: 'selectedIndex',
                    type: 'int',
                    description:
                        'Which tab is active — Radix\'s value, resolved to '
                        'an index for DsSlidingPillGroup\'s positional '
                        'substrate. Out of range hides the mark and mounts '
                        'no panel.',
                  ),
                  DocsApiFact(
                    name: 'onChanged',
                    type: 'ValueChanged<int>',
                    description:
                        'Called with the tapped trigger\'s index. Not '
                        'nullable: DsTabs is controlled only (see the '
                        'source\'s own "Controlled, where the reference is '
                        'uncontrolled" note), so there is no '
                        'null-disables-the-control convention here — the '
                        'caller always owns the value.',
                  ),
                  DocsApiFact(
                    name: 'variant',
                    type: 'DsTabsVariant',
                    description:
                        'Defaults to DsTabsVariant.standard. standard is '
                        'the filled travelling pill on a muted track; line '
                        'is the 2px underline rule on a bare row.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'DsTabItem',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'DsTabItem.label',
                    type: 'String',
                    description:
                        'The trigger\'s label — what it says and what its '
                        'Semantics node announces.',
                  ),
                  DocsApiFact(
                    name: 'DsTabItem.content',
                    type: 'Widget?',
                    description:
                        'The panel this trigger reveals when selected. '
                        'Defaults to null, and null is a real, '
                        'source-documented state rather than an omission — '
                        'see States below.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'DsTabsVariant and statics',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'DsTabsVariant.standard',
                    type: 'enum value',
                    description:
                        'The filled pill on a --muted track: theme.primary '
                        'fill, DsShadows.chip, primaryForeground ink on '
                        'the active label.',
                  ),
                  DocsApiFact(
                    name: 'DsTabsVariant.line',
                    type: 'enum value',
                    description:
                        'A 2px rule under a bare row: theme.actionInk '
                        'fill, no track background, no radius spent on '
                        'the row itself.',
                  ),
                  DocsApiFact(
                    name: 'DsTabs.trackHeight',
                    type: 'static double',
                    description:
                        '40px — the ladder\'s own top rung ("40px track, '
                        '4px inset, 32px triggers").',
                  ),
                  DocsApiFact(
                    name: 'DsTabs.triggerHeight',
                    type: 'static double',
                    description:
                        '32px — every trigger\'s fixed height, standard '
                        'and line alike.',
                  ),
                  DocsApiFact(
                    name: 'DsTabs.triggerPaddingX',
                    type: 'static double',
                    description: '16px horizontal padding inside a trigger.',
                  ),
                  DocsApiFact(
                    name: 'DsTabs.ruleHeight',
                    type: 'static double',
                    description:
                        '2px — the line variant\'s underline thickness.',
                  ),
                  DocsApiFact(
                    name: 'DsTabs.rootGap',
                    type: 'static double',
                    description:
                        '8px — the space between the track and the '
                        'content panel.',
                  ),
                  DocsApiFact(
                    name: 'DsTabs.trackPadding',
                    type: 'static double',
                    description:
                        '4px — the standard track\'s own inset around its '
                        'triggers; line spends nothing here (see gapFor).',
                  ),
                  DocsApiFact(
                    name: 'DsTabs.gapFor',
                    type: 'static double Function(DsTabsVariant)',
                    description:
                        'The space between triggers: 4px on standard, 8px '
                        'on line.',
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
              'Two variants, no size parameter — recorded rather than '
              'silently skipped.',
          child: DsText(
            'DsTabsVariant carries the two rungs the source ports from '
            'tabsListVariants: standard, the filled pill on a muted track, '
            'and line, a bare row with a 2px underline rule. There is no '
            'size parameter at all — every trigger is fixed at '
            'DsTabs.triggerHeight (32px) in both variants, unlike '
            'DsButton or DsToggle, which both expose a size enum. The '
            'source\'s own docstring also names a third axis, orientation, '
            'that is recorded in prose but never built as a real '
            'parameter: the CSS the file transcribes has a vertical '
            'branch, but DsTabs takes no orientation argument, so nothing '
            'here can be switched into it — the same "an absent parameter '
            'beats a parameter that selects an unbuilt branch" precedent '
            'this port follows elsewhere.',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'states',
          title: 'States and feedback',
          description:
              'Pressed, Disabled, Loading, Error and Success are omitted '
              'below — reasons follow the table.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DocsStateMatrix(
                facts: <DocsStateFact>[
                  DocsStateFact(
                    state: 'Rest (unselected)',
                    treatment:
                        'Transparent fill, a transparent ${DsWidths.hairline}'
                        'px hairline border, theme.mutedForeground ink.',
                    userSignal:
                        'Only the label is visible, in a dimmer ink than '
                        'the selected trigger; nothing else marks it as a '
                        'tab.',
                  ),
                  const DocsStateFact(
                    state: 'Hover (unselected)',
                    treatment:
                        'Ink alone brightens to theme.foreground over a '
                        '250ms colour tween; no background fill is painted '
                        'on hover.',
                    userSignal:
                        'A cursor-only affordance — the pointer becomes a '
                        'click cursor and the label recolours, with no '
                        'hover background at all, unlike DsToggleGroup\'s '
                        'own item, which paints theme.muted on hover.',
                  ),
                  const DocsStateFact(
                    state: 'Selected',
                    treatment:
                        'standard: the travelling pill (theme.primary, '
                        'DsShadows.chip, pill radius) slides under the '
                        'trigger and its ink becomes '
                        'theme.primaryForeground. line: a 2px rule '
                        '(theme.actionInk) slides to the trigger\'s bottom '
                        'edge and its ink becomes theme.foreground. Both '
                        'squash once via the shared jelly on every change.',
                    userSignal:
                        'The one mark travels from the old tab to the new '
                        'one rather than the old tab fading and the new '
                        'one fading in — "selection travels, never '
                        'blinks" per the source\'s own rule.',
                  ),
                  const DocsStateFact(
                    state: 'Focus-visible',
                    treatment:
                        'Coded, not live: the trigger\'s shadow spec calls '
                        'DsButton.withFocusRing(DsShadows.none, '
                        'theme.ring at 50% alpha, progress: 0) — progress '
                        'is a hardcoded literal 0, not read from any '
                        'FocusNode, so the ring\'s spread and alpha are '
                        'multiplied by zero on every build.',
                    userSignal:
                        'No focus ring is ever painted, because nothing '
                        'in DsTabs ever focuses a trigger in the first '
                        'place — see Accessibility.',
                  ),
                  const DocsStateFact(
                    state: 'Empty',
                    treatment:
                        'DsTabItem.content: null. Selecting that item '
                        'still runs the trigger\'s own selected treatment; '
                        'the column below the track omits its content '
                        'branch entirely, so no gap and no panel is '
                        'inserted.',
                    userSignal:
                        'The mark still travels, but nothing renders '
                        'underneath — a real, source-documented state '
                        '(see the DsTabItem.content doc comment), not a '
                        'bug.',
                  ),
                  const DocsStateFact(
                    state: 'Reduced motion',
                    treatment:
                        'The pill\'s travel and jelly squash '
                        '(DsSlidingPillGroup) and the trigger\'s own '
                        'colour tween all resolve their duration through '
                        'dsAnimationDuration, which '
                        'MediaQueryData(disableAnimations: true) collapses '
                        'toward zero.',
                    userSignal:
                        'The mark still relocates and the ink still '
                        'recolours, just without the travel, the squash, '
                        'or the tween reading as motion.',
                  ),
                ],
              ),
              SizedBox(height: ds(4)),
              DsText(
                'Omitted: Pressed — no separate pointer-down look is '
                'authored; only the post-selection jelly squash marks a '
                'change, the same "no held-down state, only a post-toggle '
                'reveal" precedent DsCheckbox documents for its own '
                'squash. Disabled — neither DsTabs nor DsTabItem exposes '
                'an enabled or disabled parameter (contrast '
                'DsToggleGroupItem.enabled, which DsTabItem has no '
                'equivalent of); every trigger this component renders is '
                'always operable. Loading — DsTabs is a synchronous '
                'layout primitive with no async operation of its own. '
                'Error and Success — the component defines neither '
                'invalid nor success semantics.',
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
                value:
                    'Semantics(button:, selected:, inMutuallyExclusiveGroup:)',
                description:
                    'Each trigger reports button: true, selected: '
                    'active, inMutuallyExclusiveGroup: true and its label '
                    '— Flutter has no distinct tab SemanticsFlag, so this '
                    'is the framework\'s own nearest analogue. Nothing '
                    'wraps the track itself with a container role naming '
                    'it a tab list, and the content panel underneath '
                    'carries no semantic link back to the trigger that '
                    'revealed it.',
              ),
              const DocsInstallFact(
                label: 'Keyboard interactions',
                value: 'None wired',
                description:
                    'Read plainly rather than described as the ARIA '
                    'ideal: no keyboard interaction is wired at all. '
                    'Neither _DsTabsTrigger nor DsSlidingPillGroup '
                    'contains a Focus widget, a FocusNode, a Shortcuts or '
                    'Actions mapping, or an onKeyEvent handler anywhere in '
                    'the file. A tab list is conventionally one keyboard '
                    'tab stop with arrow keys moving between tabs and '
                    'Enter/Space (or automatic activation) selecting one — '
                    'none of that exists here. A trigger cannot be reached '
                    'with the Tab key at all; tapping or clicking through '
                    'the GestureDetector is the only way to operate one.',
              ),
              const DocsInstallFact(
                label: 'Focus behavior',
                value: 'Ring is coded but permanently inert',
                description:
                    'DsButton.withFocusRing is called with progress: 0 '
                    'hardcoded — the ring\'s spread and alpha are always '
                    'zero, and with no FocusNode in the tree there is no '
                    'real focus state that could ever change that value.',
              ),
              const DocsInstallFact(
                label: 'Touch target',
                value:
                    'DsTabs.triggerHeight (32px) tall, label-width wide — '
                    'no hit-area growth',
                description:
                    'Unlike DsCheckbox\'s 42x34 DsHitArea, tabs.dart wraps '
                    'each trigger in a plain GestureDetector with no '
                    'hit-area expansion: the tappable region is exactly '
                    'the visible 32px-tall box, under the ~44px platform '
                    'target floor on the vertical axis.',
              ),
              const DocsInstallFact(
                label: 'Non-colour signal',
                value: 'The mark\'s shape and position, not colour alone',
                description:
                    'The selected trigger is marked by the travelling '
                    'pill or underline\'s position, not only by an ink '
                    'colour change — though on the line variant that '
                    'position is the sole non-textual cue, with no icon '
                    'or glyph reinforcing it.',
              ),
              const DocsInstallFact(
                label: 'Error wiring',
                value: 'None',
                description: 'DsTabs defines no invalid or error concept.',
              ),
              const DocsInstallFact(
                label: 'Screen-reader announcements',
                value: 'No live region',
                description:
                    'Nothing announces a tab switch beyond whatever the '
                    'reader happens to read next; the content panel has '
                    'no semantic link back to the trigger that revealed '
                    'it, so there is no announced relationship between '
                    'the two.',
              ),
              const DocsInstallFact(
                label: 'Known platform differences',
                value: 'None',
                description:
                    'Pure Dart layout and paint — no platform channel and '
                    'no platform-specific branch.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'responsive',
          title: 'Responsive and platform behavior',
          description: 'What happens when the triggers do not fit.',
          child: DsText(
            'DsTabs neither scrolls nor wraps its triggers when they '
            'exceed the available width, and it does not clip them '
            'either — the track\'s Row (inside DsSlidingPillGroup) keeps '
            'Flutter\'s Row/Flex default clipBehavior of Clip.none, so '
            'content that does not fit paints straight past the track\'s '
            'right edge instead of being cut off at it. Verified directly '
            'at a 390px-class width: five triggers reading Overview, '
            'Analytics dashboard, Notification preferences, Billing and '
            'subscriptions and Security settings inside a 358px-wide '
            'column report "A RenderFlex overflowed by 1068 pixels on '
            'the right" — a live RenderFlex assertion, not a cosmetic '
            'warning (see tabs_test.dart for the reproduction this page\'s '
            'claim is checked against). In an unclipped ancestor that '
            'bleed can overlap whatever sits to the right of the tab set; '
            'in a clipped one (a ListView tile, a Card with '
            'ClipBehavior.hardEdge) it is invisibly cut instead. Either '
            'way, a caller with more triggers than fit a narrow layout '
            'must wrap DsTabs in its own horizontal scroll view or reduce '
            'the trigger count itself — the component supplies neither. '
            'Beyond that, DsTabs has no other responsive behaviour: no '
            'breakpoint changes shape and keyboard versus pointer '
            'operation is identical on every Flutter target this package '
            'supports (there is no keyboard operation to differ, per '
            'Accessibility above).',
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
                label: 'Source file',
                value: tabsDoc.sourcePath,
                description: 'The authoritative implementation.',
              ),
              const DocsInstallFact(
                label: 'Local file dependencies',
                value:
                    'motion/sliding_pill.dart, effects/machine_surface.dart, '
                    'button.dart',
                description:
                    'tabs.dart imports these directly: '
                    'motion/sliding_pill.dart for DsSlidingPillGroup, the '
                    'travelling-mark primitive it shares with DsToggleGroup '
                    'and the theme toggle; effects/machine_surface.dart for '
                    'DsMachineSurface, the trigger\'s own fill/border/shadow '
                    'machinery; and button.dart, pulled in for exactly one '
                    'symbol, DsButton.withFocusRing, which drags in '
                    'Button\'s own dependency tree even though DsTabs never '
                    'renders a DsButton.',
              ),
              const DocsInstallFact(
                label: 'Foundation dependencies',
                value:
                    'foundation/colors.dart, foundation/motion.dart, '
                    'foundation/shadows.dart, foundation/spacing.dart, '
                    'foundation/theme.dart, foundation/typography.dart, '
                    'theme_scope.dart',
                description:
                    'Token sources: colours, durations and curves, shadow '
                    'specs, the ds() spacing scale, type specs, and the '
                    'live theme.',
              ),
              DocsInstallFact(
                label: 'Exports',
                value: tabsDoc.exports.join(', '),
                description:
                    'The public symbols this component makes available.',
              ),
              const DocsInstallFact(
                label: 'Assets',
                value: 'none',
                description:
                    'The pill and the underline rule are DecoratedBox '
                    'fills inside DsMachineSurface, not images or drawn '
                    'CustomPainter glyphs.',
              ),
              const DocsInstallFact(
                label: 'Fonts',
                value: 'none dedicated',
                description:
                    'Trigger labels and panel text resolve through the '
                    'ambient DsComponentType.buttonLabel and '
                    'DsComponentType.textSm type specs — the same system '
                    'type scale every other component reads, not a font '
                    'loaded for tabs itself.',
              ),
              const DocsInstallFact(
                label: 'Shaders',
                value: 'none',
                description: 'No fragment shader is used.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'composition',
          title: 'Composition examples',
          description:
              'Two larger, real patterns built from the same constructor — '
              'not manufactured examples the Dart API cannot support.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DsPanel(
                label: 'DART',
                note: 'ACCOUNT SETTINGS',
                child: DocsSelectableCodeBlock(code: _accountSettingsCode),
              ),
              SizedBox(height: ds(5)),
              DsPanel(
                label: 'DART',
                note: 'LINE VARIANT AS A SECTION SWITCHER',
                child: DocsSelectableCodeBlock(code: _sectionSwitcherCode),
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
                label: 'Track fill',
                value: 'theme.muted (standard) / none (line)',
                description: 'The track\'s own background, standard only.',
              ),
              DocsInstallFact(
                label: 'Mark fill',
                value:
                    'theme.primary (standard pill) / theme.actionInk (line '
                    'rule)',
                description:
                    'The travelling mark\'s own colour — different tokens '
                    'per variant, per the source\'s own note on why the '
                    'rule uses -ink rather than the pill\'s -primary.',
              ),
              DocsInstallFact(
                label: 'Trigger ink',
                value:
                    'theme.mutedForeground (rest) / theme.foreground '
                    '(hover, or selected on line) / theme.primaryForeground '
                    '(selected on standard)',
                description: 'Resolved in _DsTabsTrigger._ink().',
              ),
              DocsInstallFact(
                label: 'Shadow',
                value: 'DsShadows.chip',
                description: 'The standard variant\'s pill shadow spec.',
              ),
              DocsInstallFact(
                label: 'Radius',
                value: 'DsRadii.pill',
                description: 'Both the pill and the underline rule.',
              ),
              DocsInstallFact(
                label: 'Motion',
                value:
                    'DsDurations.transitionDefault, DsDurations.base, '
                    'DsDurations.animJelly',
                description:
                    'The trigger\'s own colour tween, and DsSlidingPillGroup\'s '
                    'travel and jelly squash — all resolved through '
                    'dsAnimationDuration, so reduced motion shortens them '
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
                label: 'Component source',
                value: tabsDoc.sourcePath,
                description: 'Authoritative implementation.',
              ),
              const DocsInstallFact(
                label: 'Shared machinery',
                value: 'lib/src/motion/sliding_pill.dart',
                description:
                    'DsSlidingPillGroup — shared with DsToggleGroup and '
                    'the theme toggle, documented on its own component '
                    'page.',
              ),
              const DocsInstallFact(
                label: 'Docs page tests',
                value: 'example/test/components_docs/tabs_test.dart',
                description:
                    'Coverage for this page: API completeness, the live '
                    'specimen\'s panel switching, the absent-Focus '
                    'regression check backing the Accessibility claims '
                    'above, the 390px overflow reproduction backing the '
                    'Responsive claims above, and both themes.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

const String _smallestUsageCode = '''int selectedIndex = 0;

DsTabs(
  items: const <DsTabItem>[
    DsTabItem(label: 'Overview'),
    DsTabItem(label: 'Analytics'),
  ],
  selectedIndex: selectedIndex,
  onChanged: (int next) => setState(() => selectedIndex = next),
)''';

const String _panelsUsageCode = '''DsTabs(
  items: <DsTabItem>[
    DsTabItem(
      label: 'Account',
      content: DsText(
        'Update your account details here.',
        DsType.small,
      ),
    ),
    DsTabItem(
      label: 'Password',
      content: DsText(
        'Change your password here.',
        DsType.small,
      ),
    ),
  ],
  selectedIndex: selectedIndex,
  onChanged: (int next) => setState(() => selectedIndex = next),
)''';

const String _lineUsageCode = '''DsTabs(
  variant: DsTabsVariant.line,
  items: <DsTabItem>[
    DsTabItem(label: 'Overview', content: overviewPanel),
    DsTabItem(label: 'Analytics', content: analyticsPanel),
  ],
  selectedIndex: selectedIndex,
  onChanged: (int next) => setState(() => selectedIndex = next),
)''';

const String _accountSettingsCode =
    '''// selectedIndex is owned by the enclosing State.
DsTabs(
  items: <DsTabItem>[
    DsTabItem(
      label: 'Account',
      content: AccountSettingsForm(user: user),
    ),
    DsTabItem(
      label: 'Password',
      content: PasswordSettingsForm(user: user),
    ),
    // No content: selecting Team moves the mark and shows nothing —
    // real, documented behaviour, not an accident of this example.
    const DsTabItem(label: 'Team'),
  ],
  selectedIndex: selectedIndex,
  onChanged: (int next) => setState(() => selectedIndex = next),
)''';

const String _sectionSwitcherCode =
    '''// A product page's own section switcher, not a route change: every
// panel already exists on this screen and DsTabs only picks which one
// shows.
DsTabs(
  variant: DsTabsVariant.line,
  items: <DsTabItem>[
    DsTabItem(label: 'Overview', content: ProductOverview(product: product)),
    DsTabItem(label: 'Specs', content: ProductSpecs(product: product)),
    DsTabItem(label: 'Reviews', content: ProductReviews(product: product)),
  ],
  selectedIndex: section,
  onChanged: (int next) => setState(() => section = next),
)''';

/// The two-cell live specimen for the "Preview" section — one [DsTabsVariant]
/// per cell, each a real, switchable [DsTabs].
class _TabsPreview extends StatefulWidget {
  const _TabsPreview();

  @override
  State<_TabsPreview> createState() => _TabsPreviewState();
}

class _TabsPreviewState extends State<_TabsPreview> {
  int _standardIndex = 0;
  int _lineIndex = 0;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsText('Standard', DsType.label, color: theme.mutedForeground),
        SizedBox(height: ds(3)),
        DsTabs(
          key: const ValueKey<String>('tabs-live-specimen'),
          items: <DsTabItem>[
            DsTabItem(
              label: 'Info',
              content: DsText(
                'Update your account details here.',
                DsType.small,
              ),
            ),
            DsTabItem(
              label: 'Team',
              content: DsText(
                'See who else has access to this workspace.',
                DsType.small,
              ),
            ),
            const DsTabItem(label: 'More'),
          ],
          selectedIndex: _standardIndex,
          onChanged: (int next) => setState(() => _standardIndex = next),
        ),
        SizedBox(height: ds(8)),
        DsText('Line', DsType.label, color: theme.mutedForeground),
        SizedBox(height: ds(3)),
        DsTabs(
          key: const ValueKey<String>('tabs-line-specimen'),
          variant: DsTabsVariant.line,
          items: <DsTabItem>[
            DsTabItem(
              label: 'Overview',
              content: DsText(
                'The dashboard\'s top-level summary panel.',
                DsType.small,
              ),
            ),
            DsTabItem(
              label: 'Stats',
              content: DsText(
                'Traffic and conversion, broken down by channel.',
                DsType.small,
              ),
            ),
          ],
          selectedIndex: _lineIndex,
          onChanged: (int next) => setState(() => _lineIndex = next),
        ),
      ],
    );
  }
}
