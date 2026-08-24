/// Public component documentation for the tabs component.
///
/// `tabsDoc` (from `meta.dart`) is the typed data source for this page.
///
/// Section shape mirrors `https://ui.shadcn.com/docs/components/base/tabs`
/// section for section. A live demo renders ahead of any heading, the same
/// as the reference's own top-of-page preview: no Overview, Status, or
/// Preview heading precedes Installation. Then Installation, Usage,
/// Composition, Line, Empty tab, RTL, and API Reference, in that order.
/// Vertical and Icons have no counterpart here: ElTabs records an
/// `orientation` axis in its own doc comment but never wires it to a real
/// parameter (see Line below), and ElTabItem takes a label and a content
/// widget only, with no leading-icon slot to fill. Disabled has no
/// counterpart either, folded into the "Omitted" paragraph under States
/// instead of a heading of its own, because ElTabItem carries no enabled
/// flag at all: every tab this component renders is always operable.
/// Empty tab has no counterpart on the reference page: it is ours only,
/// covering the real ElTabItem.content: null state the source itself
/// documents. States, Accessibility, Responsive, Dependencies, Theming, and
/// Source are this package's own six sections, added after API Reference,
/// named exactly that with no extra words. Each gets its own [ElSection];
/// title/description and previous/next come from [DocsLayout].
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
      breadcrumbs: const <ElBreadcrumbEntry>[
        ElBreadcrumbEntry.link('Components'),
        ElBreadcrumbEntry.page('Tabs'),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(title: 'Line', anchor: 'line'),
        DocsTocEntry(title: 'Empty tab', anchor: 'empty-tab'),
        DocsTocEntry(title: 'RTL', anchor: 'rtl'),
        DocsTocEntry(title: 'API Reference', anchor: 'api'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      // Wave 3's alphabetical neighbours (Phase J plan inventory). Neither
      // route is registered yet either: the whole wave's previous/next chain
      // is stitched together once the supervisor aggregates every meta.dart,
      // the same as this page's own route is not reachable until then.
      previous: const DocsPageLink(
        title: 'Sidebar',
        route: '/components/sidebar',
      ),
      next: const DocsPageLink(title: 'Toaster', route: '/components/toaster'),
      onNavigate: onNavigate,
      child: _TabsArticle(theme: ElTheme.of(context)),
    );
  }
}

class _TabsArticle extends StatelessWidget {
  const _TabsArticle({required this.theme});

  final ElThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey<String>('tabs-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // The live demo, ahead of any heading: the same shape the reference
        // page itself opens with. No ElSection wraps it, so it carries no
        // Overview/Status/Preview heading of its own before Installation.
        DocsCodeExample(
          title: 'Tabs specimens',
          description:
              'Two live specimens, one per variant, both built from the '
              'same ElTabs constructor: tap a trigger on either to switch '
              'its panel. The standard specimen\'s third trigger, More, '
              'carries no content: tapping it moves the mark and shows '
              'nothing underneath, which is Empty tab below, not a gap in '
              'this page.',
          preview: const _TabsPreview(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: tabsDoc.sourcePath,
              code:
                  '${tabsDoc.command}\n'
                  '// Installs the generated @ui/tabs.dart payload.',
            ),
          ],
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'install',
          title: 'Installation',
          description:
              'Command install is available: read this before '
              'reaching for elattar add tabs.',
          child: DocsInstallFacts(
            facts: <DocsInstallFact>[
              const DocsInstallFact(
                label: 'CLI',
                value: 'registry/components/tabs.json',
                description:
                    'tabs is not yet a registry item, so `elattar add '
                    'tabs` will not resolve. It is one of the Wave 3 '
                    'overlay-and-navigation components still awaiting a '
                    'manifest, see the Phase J documentation plan.',
              ),
              const DocsInstallFact(
                label: 'Manual: package mode (supported today)',
                value:
                    "import 'package:elattar_design_system/elattar_design_system.dart';",
                description:
                    'Depend on the package and use ElTabs directly, exactly '
                    'as this page does.',
              ),
              DocsInstallFact(
                label: 'Manual: source mode (not recommended yet)',
                value: tabsDoc.sourcePath,
                description:
                    'Copying this one file will not compile on its own: it '
                    'needs the sibling files listed under Dependencies '
                    'below, and no manifest exists yet to resolve them for '
                    'you.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'usage',
          title: 'Usage',
          description: 'The smallest correct example, then one with panels.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElPanel(
                label: 'DART',
                note: 'SMALLEST CORRECT EXAMPLE',
                child: DocsSelectableCodeBlock(code: _smallestUsageCode),
              ),
              SizedBox(height: el(5)),
              ElText(
                'A trigger with no content renders nothing when selected: '
                'the example above never mounts a panel at all. Give an '
                'item a content widget and ElTabs shows it under the '
                'track whenever that trigger is active:',
                ElType.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: el(3)),
              ElPanel(
                label: 'DART',
                note: 'WITH PANELS',
                child: DocsSelectableCodeBlock(code: _panelsUsageCode),
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'composition',
          title: 'Composition',
          description:
              'ElTabs has no separate TabsList, TabsTrigger, or TabsContent '
              'to assemble by hand: items builds the whole track and its '
              'panel in one call, and the mark itself is ElSlidingPillGroup, '
              'the same travelling-indicator primitive ElToggleGroup and '
              'the theme toggle share. What follows is what that single '
              'call assembles internally, and how it composes into a real '
              'page.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElPanel(
                label: 'What ElTabs(items: …) assembles',
                child: DocsSelectableCodeBlock(code: _compositionCode),
              ),
              SizedBox(height: el(5)),
              ElPanel(
                label: 'DART',
                note: 'ACCOUNT SETTINGS',
                child: DocsSelectableCodeBlock(code: _accountSettingsCode),
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'line',
          title: 'Line',
          description:
              'ElTabsVariant carries the two rungs the source ports from '
              'tabsListVariants: standard, the filled pill sliding on a '
              'muted track, and line, a bare row with a 2px underline rule '
              'sliding beneath the active label instead. There is no size '
              'parameter at all: every trigger is fixed at '
              'ElTabs.triggerHeight (32px) in both variants, unlike '
              'ElButton or ElToggle, which each expose a size enum. Two '
              'shadcn examples this page cannot mirror for the same reason '
              'a size section would be empty: Vertical, because the '
              'source\'s own doc comment names orientation as a third axis '
              'that is recorded in prose but never wired to a real '
              'parameter, so nothing here can be switched into it, and '
              'Icons, because ElTabItem takes a label and a content widget '
              'only, with no leading-icon slot to fill.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElPanel(
                label: 'DART',
                note: 'LINE VARIANT',
                child: DocsSelectableCodeBlock(code: _lineUsageCode),
              ),
              SizedBox(height: el(5)),
              ElPanel(
                label: 'DART',
                note: 'LINE VARIANT AS A SECTION SWITCHER',
                child: DocsSelectableCodeBlock(code: _sectionSwitcherCode),
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'empty-tab',
          title: 'Empty tab',
          description:
              'A ElTabItem with content: null has no counterpart on the '
              'reference page: Radix\'s uncontrolled defaultValue always '
              'names a TabsContent that exists, so the gap never surfaces '
              'there the way an always-present null does here.',
          child: ElText(
            'ElTabItem.content: null is a real, source-documented state '
            '(see the doc comment on ElTabItem.content), not an authoring '
            'mistake: the reference simply renders nothing for a value with '
            'no registered TabsContent, and ElTabs matches that by omitting '
            'its content branch entirely when the active item\'s content is '
            'null. The mark still travels to a contentless trigger and the '
            'trigger still takes its full selected treatment (ink, and the '
            'pill or rule); only the panel beneath is silently absent. The '
            'standard specimen above demonstrates this directly: its third '
            'trigger, More, carries no content, so tapping it slides the '
            'mark across with nothing appearing underneath, the same as '
            'Team in the account-settings example under Composition.',
            ElType.small,
            color: theme.mutedForeground,
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'rtl',
          title: 'RTL',
          description:
              'ElTabs takes no direction parameter of its own: it reads '
              'whatever Directionality is already in scope, the same as '
              'every other widget in the tree. The track\'s own alignment '
              'is AlignmentDirectional.centerStart (tabs.dart), which is '
              'directional-aware and hugs the trailing edge under an RTL '
              'Directionality rather than staying pinned to the physical '
              'left. More importantly, ElSlidingPillGroup never computes '
              'the travelling mark\'s position from a formula that assumes '
              'a direction: its _measure() (sliding_pill.dart) reads each '
              'trigger\'s real, already-laid-out rect with localToGlobal, '
              'and the mark\'s own AnimatedPositioned paints straight from '
              'that measurement. Because Flutter\'s own Row resolves its '
              'child order from the ambient Directionality before '
              'ElSlidingPillGroup ever measures it, the rects it reads are '
              'already mirrored, so the mark lands on the correct trigger '
              'with no RTL-specific branch anywhere in this component.',
          child: DocsCodeExample(
            title: 'Right-to-left tabs',
            preview: const _TabsRtl(),
            manualFiles: <DocsCodeFile>[
              DocsCodeFile(path: 'rtl_tabs.dart', code: _rtlCode),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'api',
          title: 'API Reference',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DocsApiTable(
                title: 'ElTabs',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'items',
                    type: 'List<ElTabItem>',
                    description:
                        'Every tab: its trigger\'s label, and the optional '
                        'panel it reveals when selected.',
                  ),
                  DocsApiFact(
                    name: 'selectedIndex',
                    type: 'int',
                    description:
                        'Which tab is active: Radix\'s value, resolved to '
                        'an index for ElSlidingPillGroup\'s positional '
                        'substrate. Out of range hides the mark and mounts '
                        'no panel.',
                  ),
                  DocsApiFact(
                    name: 'onChanged',
                    type: 'ValueChanged<int>',
                    description:
                        'Called with the tapped trigger\'s index. Not '
                        'nullable: ElTabs is controlled only (see the '
                        'source\'s own "Controlled, where the reference is '
                        'uncontrolled" note), so there is no '
                        'null-disables-the-control convention here: the '
                        'caller always owns the value.',
                  ),
                  DocsApiFact(
                    name: 'variant',
                    type: 'ElTabsVariant',
                    description:
                        'Defaults to ElTabsVariant.standard. standard is '
                        'the filled travelling pill on a muted track; line '
                        'is the 2px underline rule on a bare row.',
                  ),
                ],
              ),
              SizedBox(height: el(5)),
              const DocsApiTable(
                title: 'ElTabItem',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'ElTabItem.label',
                    type: 'String',
                    description:
                        'The trigger\'s label: what it says and what its '
                        'Semantics node announces.',
                  ),
                  DocsApiFact(
                    name: 'ElTabItem.content',
                    type: 'Widget?',
                    description:
                        'The panel this trigger reveals when selected. '
                        'Defaults to null, and null is a real, '
                        'source-documented state rather than an omission, '
                        'see Empty tab above.',
                  ),
                ],
              ),
              SizedBox(height: el(5)),
              const DocsApiTable(
                title: 'ElTabsVariant and statics',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'ElTabsVariant.standard',
                    type: 'enum value',
                    description:
                        'The filled pill on a --muted track: theme.primary '
                        'fill, ElShadows.chip, primaryForeground ink on '
                        'the active label.',
                  ),
                  DocsApiFact(
                    name: 'ElTabsVariant.line',
                    type: 'enum value',
                    description:
                        'A 2px rule under a bare row: theme.actionInk '
                        'fill, no track background, no radius spent on '
                        'the row itself.',
                  ),
                  DocsApiFact(
                    name: 'ElTabs.trackHeight',
                    type: 'static double',
                    description:
                        '40px: the ladder\'s own top rung ("40px track, '
                        '4px inset, 32px triggers").',
                  ),
                  DocsApiFact(
                    name: 'ElTabs.triggerHeight',
                    type: 'static double',
                    description:
                        '32px: every trigger\'s fixed height, standard '
                        'and line alike.',
                  ),
                  DocsApiFact(
                    name: 'ElTabs.triggerPaddingX',
                    type: 'static double',
                    description: '16px horizontal padding inside a trigger.',
                  ),
                  DocsApiFact(
                    name: 'ElTabs.ruleHeight',
                    type: 'static double',
                    description:
                        '2px: the line variant\'s underline thickness.',
                  ),
                  DocsApiFact(
                    name: 'ElTabs.rootGap',
                    type: 'static double',
                    description:
                        '8px: the space between the track and the '
                        'content panel.',
                  ),
                  DocsApiFact(
                    name: 'ElTabs.trackPadding',
                    type: 'static double',
                    description:
                        '4px: the standard track\'s own inset around its '
                        'triggers; line spends nothing here (see gapFor).',
                  ),
                  DocsApiFact(
                    name: 'ElTabs.gapFor',
                    type: 'static double Function(ElTabsVariant)',
                    description:
                        'The space between triggers: 4px on standard, 8px '
                        'on line.',
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'states',
          title: 'States',
          description:
              'Pressed, Disabled, Loading, Error and Success are omitted '
              'below: reasons follow the table.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DocsStateMatrix(
                facts: <DocsStateFact>[
                  DocsStateFact(
                    state: 'Rest (unselected)',
                    treatment:
                        'Transparent fill, a transparent ${ElWidths.hairline}'
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
                        'A cursor-only affordance: the pointer becomes a '
                        'click cursor and the label recolours, with no '
                        'hover background at all, unlike ElToggleGroup\'s '
                        'own item, which paints theme.muted on hover.',
                  ),
                  const DocsStateFact(
                    state: 'Selected',
                    treatment:
                        'standard: the travelling pill (theme.primary, '
                        'ElShadows.chip, pill radius) slides under the '
                        'trigger and its ink becomes '
                        'theme.primaryForeground. line: a 2px rule '
                        '(theme.actionInk) slides to the trigger\'s bottom '
                        'edge and its ink becomes theme.foreground. Both '
                        'squash once via the shared jelly on every change.',
                    userSignal:
                        'The one mark travels from the old tab to the new '
                        'one rather than the old tab fading and the new '
                        'one fading in: "selection travels, never '
                        'blinks" per the source\'s own rule.',
                  ),
                  const DocsStateFact(
                    state: 'Focus-visible',
                    treatment:
                        'Coded, not live: the trigger\'s shadow spec calls '
                        'ElButton.withFocusRing(ElShadows.none, '
                        'theme.ring at 50% alpha, progress: 0). Progress '
                        'is a hardcoded literal 0, not read from any '
                        'FocusNode, so the ring\'s spread and alpha are '
                        'multiplied by zero on every build.',
                    userSignal:
                        'No focus ring is ever painted, because nothing '
                        'in ElTabs ever focuses a trigger in the first '
                        'place: see Accessibility.',
                  ),
                  const DocsStateFact(
                    state: 'Empty',
                    treatment:
                        'ElTabItem.content: null. Selecting that item '
                        'still runs the trigger\'s own selected treatment; '
                        'the column below the track omits its content '
                        'branch entirely, so no gap and no panel is '
                        'inserted.',
                    userSignal:
                        'The mark still travels, but nothing renders '
                        'underneath: a real, source-documented state '
                        '(see the ElTabItem.content doc comment and Empty '
                        'tab above), not a bug.',
                  ),
                  const DocsStateFact(
                    state: 'Reduced motion',
                    treatment:
                        'The pill\'s travel and jelly squash '
                        '(ElSlidingPillGroup) and the trigger\'s own '
                        'colour tween all resolve their duration through '
                        'elAnimationDuration, which '
                        'MediaQueryData(disableAnimations: true) collapses '
                        'toward zero.',
                    userSignal:
                        'The mark still relocates and the ink still '
                        'recolours, just without the travel, the squash, '
                        'or the tween reading as motion.',
                  ),
                ],
              ),
              SizedBox(height: el(4)),
              ElText(
                'Omitted. Pressed: no separate pointer-down look is '
                'authored; only the post-selection jelly squash marks a '
                'change, the same "no held-down state, only a post-toggle '
                'reveal" precedent ElCheckbox documents for its own '
                'squash. Disabled: neither ElTabs nor ElTabItem exposes '
                'an enabled or disabled parameter (contrast '
                'ElToggleGroupItem.enabled, which ElTabItem has no '
                'equivalent of); every trigger this component renders is '
                'always operable. Loading: ElTabs is a synchronous '
                'layout primitive with no async operation of its own. '
                'Error and Success: the component defines neither '
                'invalid nor success semantics.',
                ElType.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
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
                    ': Flutter has no distinct tab SemanticsFlag, so this '
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
                    'Neither _DsTabsTrigger nor ElSlidingPillGroup '
                    'contains a Focus widget, a FocusNode, a Shortcuts or '
                    'Actions mapping, or an onKeyEvent handler anywhere in '
                    'the file. A tab list is conventionally one keyboard '
                    'tab stop with arrow keys moving between tabs and '
                    'Enter/Space (or automatic activation) selecting one: '
                    'none of that exists here. A trigger cannot be reached '
                    'with the Tab key at all; tapping or clicking through '
                    'the GestureDetector is the only way to operate one.',
              ),
              const DocsInstallFact(
                label: 'Focus behavior',
                value: 'Ring is coded but permanently inert',
                description:
                    'ElButton.withFocusRing is called with progress: 0 '
                    'hardcoded: the ring\'s spread and alpha are always '
                    'zero, and with no FocusNode in the tree there is no '
                    'real focus state that could ever change that value.',
              ),
              const DocsInstallFact(
                label: 'Touch target',
                value:
                    'ElTabs.triggerHeight (32px) tall, label-width wide: '
                    'no hit-area growth',
                description:
                    'Unlike ElCheckbox\'s 42x34 ElHitArea, tabs.dart wraps '
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
                    'colour change, though on the line variant that '
                    'position is the sole non-textual cue, with no icon '
                    'or glyph reinforcing it.',
              ),
              const DocsInstallFact(
                label: 'Error wiring',
                value: 'None',
                description: 'ElTabs defines no invalid or error concept.',
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
                    'Pure Dart layout and paint: no platform channel and '
                    'no platform-specific branch.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'responsive',
          title: 'Responsive',
          description: 'What happens when the triggers do not fit.',
          child: ElText(
            'ElTabs neither scrolls nor wraps its triggers when they '
            'exceed the available width, and it does not clip them '
            'either: the track\'s Row (inside ElSlidingPillGroup) keeps '
            'Flutter\'s Row/Flex default clipBehavior of Clip.none, so '
            'content that does not fit paints straight past the track\'s '
            'right edge instead of being cut off at it. Verified directly '
            'at a 390px-class width: five triggers reading Overview, '
            'Analytics dashboard, Notification preferences, Billing and '
            'subscriptions and Security settings inside a 358px-wide '
            'column report "A RenderFlex overflowed by 1068 pixels on '
            'the right", a live RenderFlex assertion, not a cosmetic '
            'warning (see tabs_test.dart for the reproduction this page\'s '
            'claim is checked against). In an unclipped ancestor that '
            'bleed can overlap whatever sits to the right of the tab set; '
            'in a clipped one (a ListView tile, a Card with '
            'ClipBehavior.hardEdge) it is invisibly cut instead. Either '
            'way, a caller with more triggers than fit a narrow layout '
            'must wrap ElTabs in its own horizontal scroll view or reduce '
            'the trigger count itself. The component supplies neither. '
            'Beyond that, ElTabs has no other responsive behaviour: no '
            'breakpoint changes shape and keyboard versus pointer '
            'operation is identical on every Flutter target this package '
            'supports (there is no keyboard operation to differ, per '
            'Accessibility above).',
            ElType.small,
            color: theme.mutedForeground,
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'dependencies',
          title: 'Dependencies',
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
                    'motion/sliding_pill.dart for ElSlidingPillGroup, the '
                    'travelling-mark primitive it shares with ElToggleGroup '
                    'and the theme toggle; effects/machine_surface.dart for '
                    'ElMachineSurface, the trigger\'s own fill/border/shadow '
                    'machinery; and button.dart, pulled in for exactly one '
                    'symbol, ElButton.withFocusRing, which drags in '
                    'Button\'s own dependency tree even though ElTabs never '
                    'renders a ElButton.',
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
                    'specs, the el() spacing scale, type specs, and the '
                    'live theme.',
              ),
              DocsInstallFact(
                label: 'Exports',
                value: tabsDoc.exports.join(', '),
                description:
                    'The public symbols this component makes available.',
              ),
              const DocsInstallFact(
                label: 'Platforms',
                value: 'Android, iOS, Web, macOS, Windows, Linux',
                description:
                    'A pure Flutter widget tree of Row/Stack/DecoratedBox: '
                    'no platform channel and no platform-specific branch, '
                    'so nothing here differs by target.',
              ),
              const DocsInstallFact(
                label: 'Assets',
                value: 'none',
                description:
                    'The pill and the underline rule are DecoratedBox '
                    'fills inside ElMachineSurface, not images or drawn '
                    'CustomPainter glyphs.',
              ),
              const DocsInstallFact(
                label: 'Fonts',
                value: 'none dedicated',
                description:
                    'Trigger labels and panel text resolve through the '
                    'ambient ElComponentType.buttonLabel and '
                    'ElComponentType.textSm type specs: the same system '
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
        SizedBox(height: el(6)),
        ElSection(
          id: 'theming',
          title: 'Theming',
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
                    'The travelling mark\'s own colour: different tokens '
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
                value: 'ElShadows.chip',
                description: 'The standard variant\'s pill shadow spec.',
              ),
              DocsInstallFact(
                label: 'Radius',
                value: 'ElRadii.pill',
                description: 'Both the pill and the underline rule.',
              ),
              DocsInstallFact(
                label: 'Motion',
                value:
                    'ElDurations.transitionDefault, ElDurations.base, '
                    'ElDurations.animJelly',
                description:
                    'The trigger\'s own colour tween, and ElSlidingPillGroup\'s '
                    'travel and jelly squash: all resolved through '
                    'elAnimationDuration, so reduced motion shortens them '
                    'automatically.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'source',
          title: 'Source',
          child: DocsInstallFacts(
            title: 'Source and tests',
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
                    'ElSlidingPillGroup: shared with ElToggleGroup and '
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
                    'Responsive claims above, the RTL mirroring backing '
                    'the RTL claims above, and both themes.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

const String _smallestUsageCode = '''int selectedIndex = 0;

ElTabs(
  items: const <ElTabItem>[
    ElTabItem(label: 'Overview'),
    ElTabItem(label: 'Analytics'),
  ],
  selectedIndex: selectedIndex,
  onChanged: (int next) => setState(() => selectedIndex = next),
)''';

const String _panelsUsageCode = '''ElTabs(
  items: <ElTabItem>[
    ElTabItem(
      label: 'Account',
      content: ElText(
        'Update your account details here.',
        ElType.small,
      ),
    ),
    ElTabItem(
      label: 'Password',
      content: ElText(
        'Change your password here.',
        ElType.small,
      ),
    ),
  ],
  selectedIndex: selectedIndex,
  onChanged: (int next) => setState(() => selectedIndex = next),
)''';

const String _compositionCode =
    '''// What ElTabs(items: …) builds, read out of tabs.dart's own build():
Column(
  children: [
    Align(
      alignment: AlignmentDirectional.centerStart,
      // The mark paints first, so it sits behind every trigger.
      child: ElSlidingPillGroup(pill: mark, children: triggers),
    ),
    if (selectedItem.content != null)
      DefaultTextStyle.merge(
        style: textSmStyle,
        child: selectedItem.content!,
      ),
  ],
)''';

const String _lineUsageCode = '''ElTabs(
  variant: ElTabsVariant.line,
  items: <ElTabItem>[
    ElTabItem(label: 'Overview', content: overviewPanel),
    ElTabItem(label: 'Analytics', content: analyticsPanel),
  ],
  selectedIndex: selectedIndex,
  onChanged: (int next) => setState(() => selectedIndex = next),
)''';

const String _accountSettingsCode =
    '''// selectedIndex is owned by the enclosing State.
ElTabs(
  items: <ElTabItem>[
    ElTabItem(
      label: 'Account',
      content: AccountSettingsForm(user: user),
    ),
    ElTabItem(
      label: 'Password',
      content: PasswordSettingsForm(user: user),
    ),
    // No content: selecting Team moves the mark and shows nothing.
    // Real, documented behaviour, not an accident of this example.
    const ElTabItem(label: 'Team'),
  ],
  selectedIndex: selectedIndex,
  onChanged: (int next) => setState(() => selectedIndex = next),
)''';

const String _sectionSwitcherCode =
    '''// A product page's own section switcher, not a route change: every
// panel already exists on this screen and ElTabs only picks which one
// shows.
ElTabs(
  variant: ElTabsVariant.line,
  items: <ElTabItem>[
    ElTabItem(label: 'Overview', content: ProductOverview(product: product)),
    ElTabItem(label: 'Specs', content: ProductSpecs(product: product)),
    ElTabItem(label: 'Reviews', content: ProductReviews(product: product)),
  ],
  selectedIndex: section,
  onChanged: (int next) => setState(() => section = next),
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ElTabs(
    items: <ElTabItem>[
      ElTabItem(
        label: 'الحساب',
        content: ElText('تحديث بيانات حسابك هنا.', ElType.small),
      ),
      ElTabItem(
        label: 'الفريق',
        content: ElText('من يملك صلاحية الوصول إلى مساحة العمل هذه.', ElType.small),
      ),
    ],
    selectedIndex: selectedIndex,
    onChanged: (int next) => setState(() => selectedIndex = next),
  ),
)''';

/// The two-cell live specimen for the unheaded top-of-page demo, one
/// [ElTabsVariant] per cell, each a real, switchable [ElTabs].
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
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElText('Standard', ElType.label, color: theme.mutedForeground),
        SizedBox(height: el(3)),
        ElTabs(
          key: const ValueKey<String>('tabs-live-specimen'),
          items: <ElTabItem>[
            ElTabItem(
              label: 'Info',
              content: ElText(
                'Update your account details here.',
                ElType.small,
              ),
            ),
            ElTabItem(
              label: 'Team',
              content: ElText(
                'See who else has access to this workspace.',
                ElType.small,
              ),
            ),
            const ElTabItem(label: 'More'),
          ],
          selectedIndex: _standardIndex,
          onChanged: (int next) => setState(() => _standardIndex = next),
        ),
        SizedBox(height: el(8)),
        ElText('Line', ElType.label, color: theme.mutedForeground),
        SizedBox(height: el(3)),
        ElTabs(
          key: const ValueKey<String>('tabs-line-specimen'),
          variant: ElTabsVariant.line,
          items: <ElTabItem>[
            ElTabItem(
              label: 'Overview',
              content: ElText(
                'The dashboard\'s top-level summary panel.',
                ElType.small,
              ),
            ),
            ElTabItem(
              label: 'Stats',
              content: ElText(
                'Traffic and conversion, broken down by channel.',
                ElType.small,
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

/// The RTL section's own live specimen: the same [ElTabs] constructor, under
/// a right-to-left [Directionality] with Arabic labels and content, backing
/// the RTL section's mirroring claim.
class _TabsRtl extends StatefulWidget {
  const _TabsRtl();

  @override
  State<_TabsRtl> createState() => _TabsRtlState();
}

class _TabsRtlState extends State<_TabsRtl> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ElTabs(
        key: const ValueKey<String>('tabs-rtl-specimen'),
        items: <ElTabItem>[
          ElTabItem(
            label: 'الحساب',
            content: ElText('تحديث بيانات حسابك هنا.', ElType.small),
          ),
          ElTabItem(
            label: 'الفريق',
            content: ElText(
              'من يملك صلاحية الوصول إلى مساحة العمل هذه.',
              ElType.small,
            ),
          ),
        ],
        selectedIndex: _index,
        onChanged: (int next) => setState(() => _index = next),
      ),
    );
  }
}
