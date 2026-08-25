/// Public documentation page for the `tabs` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose [ElSection]
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button` established. Every specimen
/// widget and every code string below is the same one the hand-composed
/// page carried. Four sections that used to be a code block with no live
/// specimen beside it — the "with panels" half of Usage, the "account
/// settings" half of Composition, and Line's own variant demo — are now
/// genuinely live, built from the exact same quoted source: Panels, Account
/// settings, and Line respectively. Section switcher (Line's second code
/// block) stays a snippet: it names `ProductOverview`/`ProductSpecs`/
/// `ProductReviews`, widgets that exist only in the hypothetical app the
/// comment describes, not in this file, so a live stage would have to
/// invent them rather than show the real thing. New: a Keyboard
/// disclosure, between Accessibility and Responsive — tabs.dart wires none,
/// and the Accessibility disclosure's own former "Keyboard interactions"
/// fact moves there in full, with a one-line pointer left behind.
///
/// **Section order**, matching `button`'s own house shape: Preview,
/// Installation, Usage, Panels, Composition, Account settings, Line,
/// Section switcher, Empty tab, RTL, then the eight disclosures. Vertical
/// and Icons have no counterpart: ElTabs records an `orientation` axis in
/// its own doc comment but never wires it to a real parameter (see Line's
/// description), and ElTabItem takes a label and a content widget only,
/// with no leading-icon slot to fill. Disabled has no counterpart either,
/// folded into States' own omission note, because ElTabItem carries no
/// enabled flag at all: every tab this component renders is always
/// operable.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec tabsDocSpec = ComponentDocSpec(
  name: 'tabs',
  title: tabsDoc.title,
  description: tabsDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Two live specimens, one per variant, both built from the same '
          'ElTabs constructor: tap a trigger on either to switch its '
          'panel. The standard specimen\'s third trigger, More, carries '
          'no content: tapping it moves the mark and shows nothing '
          'underneath, which is Empty tab below, not a gap in this page.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'tabs is a registry item: elattar add tabs installs '
          'lib/src/components/tabs.dart and resolves button, '
          'machine-surface, sliding-pill and source-foundation '
          'automatically. The Manual tab is for a project not using the '
          'CLI — copying tabs.dart alone will not compile without those '
          'same sibling files.',
      command: tabsDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/tabs.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/tabs.dart's generated "
              '@ui/tabs.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated tabs source here when using manual '
              'mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElTabs, ElTabItem and '
              'ElTabsVariant are reachable the same way the CLI path '
              'already makes them.',
          code: "export 'tabs.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description: 'The smallest correct example: two triggers, no panels.',
      code: _smallestUsageCode,
    ),
    ShowcaseSection(
      id: 'panels',
      title: 'Panels',
      description:
          'A trigger with no content renders nothing when selected: the '
          'Usage example above never mounts a panel at all. Give an item '
          'a content widget and ElTabs shows it under the track whenever '
          'that trigger is active.',
      specimen: _PanelsSpecimen(),
      code: _panelsUsageCode,
      label: 'Panels specimen view',
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'ElTabs has no separate TabsList, TabsTrigger, or TabsContent '
          'to assemble by hand: items builds the whole track and its '
          'panel in one call, and the mark itself is ElSlidingPillGroup, '
          'the same travelling-indicator primitive ElToggleGroup and the '
          'theme toggle share. This is what a single ElTabs(items: …) '
          'call assembles internally, read out of tabs.dart\'s own '
          'build() — a structure diagram, not code a caller would write, '
          'so it stays a snippet rather than a stage with nothing live '
          'to show. See Account settings below for the same composition '
          'in a real page.',
      code: _compositionCode,
    ),
    ShowcaseSection(
      id: 'account-settings',
      title: 'Account settings',
      description:
          'The composition above, in its usual home: a settings page '
          'with two real panels and a third trigger, Team, that carries '
          'no content on purpose — selecting it moves the mark and shows '
          'nothing, the exact Empty tab state below, not an authoring '
          'gap in this example. Three real triggers run wider than a '
          'narrow stage, so the live specimen wraps them in a horizontal '
          'scroll view — the exact mitigation Responsive below names for '
          'a caller in the same spot; the quoted code stays the bare '
          'construction.',
      specimen: _AccountSettingsSpecimen(),
      code: _accountSettingsCode,
      label: 'Account settings specimen view',
    ),
    ShowcaseSection(
      id: 'line',
      title: 'Line',
      description:
          'ElTabsVariant carries the two rungs the source ports from '
          'tabsListVariants: standard, the filled pill sliding on a '
          'muted track, and line, a bare row with a 2px underline rule '
          'sliding beneath the active label instead. There is no size '
          'parameter at all: every trigger is fixed at '
          'ElTabs.triggerHeight (32px) in both variants, unlike ElButton '
          'or ElToggle, which each expose a size enum. Two shadcn '
          'examples this page cannot mirror for the same reason a size '
          'section would be empty: Vertical, because the source\'s own '
          'doc comment names orientation as a third axis that is '
          'recorded in prose but never wired to a real parameter, so '
          'nothing here can be switched into it, and Icons, because '
          'ElTabItem takes a label and a content widget only, with no '
          'leading-icon slot to fill.',
      specimen: _LineSpecimen(),
      code: _lineUsageCode,
      label: 'Line specimen view',
    ),
    SnippetSection(
      id: 'section-switcher',
      title: 'Section switcher',
      description:
          'A product page\'s own section switcher, not a route change: '
          'every panel already exists on the screen and ElTabs only '
          'picks which one shows. This names ProductOverview, '
          'ProductSpecs and ProductReviews, widgets that exist only in '
          'the hypothetical product page the comment describes, not in '
          'this file — a live stage here would have to invent an app '
          'around them rather than show the real thing, so this one '
          'stays a snippet.',
      code: _sectionSwitcherCode,
    ),
    SnippetSection(
      id: 'empty-tab',
      title: 'Empty tab',
      description:
          'A ElTabItem with content: null is a real, source-documented '
          'state (see the doc comment on ElTabItem.content), not an '
          'authoring mistake: the reference simply renders nothing for a '
          'value with no registered TabsContent, and ElTabs matches that '
          'by omitting its content branch entirely when the active '
          'item\'s content is null. The mark still travels to a '
          'contentless trigger and the trigger still takes its full '
          'selected treatment (ink, and the pill or rule); only the '
          'panel beneath is silently absent. The Preview specimen above '
          'demonstrates this directly: its third trigger, More, carries '
          'no content, so tapping it slides the mark across with '
          'nothing appearing underneath — the same as Team in Account '
          'settings above. This has no counterpart on the reference '
          'page: Radix\'s uncontrolled defaultValue always names a '
          'TabsContent that exists, so the gap never surfaces there the '
          'way an always-present null does here.',
      code: _emptyTabCode,
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'ElTabs takes no direction parameter of its own: it reads '
          'whatever Directionality is already in scope, the same as '
          'every other widget in the tree. The track\'s own alignment is '
          'AlignmentDirectional.centerStart (tabs.dart), which is '
          'directional-aware and hugs the trailing edge under an RTL '
          'Directionality rather than staying pinned to the physical '
          'left. More importantly, ElSlidingPillGroup never computes the '
          'travelling mark\'s position from a formula that assumes a '
          'direction: its _measure() (sliding_pill.dart) reads each '
          'trigger\'s real, already-laid-out rect with localToGlobal, '
          'and the mark\'s own AnimatedPositioned paints straight from '
          'that measurement. Because Flutter\'s own Row resolves its '
          'child order from the ambient Directionality before '
          'ElSlidingPillGroup ever measures it, the rects it reads are '
          'already mirrored, so the mark lands on the correct trigger '
          'with no RTL-specific branch anywhere in this component.',
      specimen: _RtlSpecimen(),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElTabs', anchor: 'api-eltabs'),
        DocsTocEntry(title: 'ElTabItem', anchor: 'api-eltabitem'),
        DocsTocEntry(
          title: 'ElTabsVariant and statics',
          anchor: 'api-eltabsvariant',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Pressed, Disabled, Loading, Error and Success are omitted '
          'below: reasons follow the table.',
      child: _StatesContent(),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'tabs.dart wires no key handling of its own — every fact here '
          'is about what does NOT happen, read off _DsTabsTrigger and '
          'ElSlidingPillGroup directly.',
      child: _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      description: 'What happens when the triggers do not fit.',
      child: _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      description: 'Tokens this component reads.',
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
                'theme.mutedForeground (rest) / theme.foreground (hover, '
                'or selected on line) / theme.primaryForeground (selected '
                'on standard)',
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
                'The trigger\'s own colour tween, and '
                'ElSlidingPillGroup\'s travel and jelly squash: all '
                'resolved through elAnimationDuration, so reduced '
                'motion shortens them automatically.',
          ),
        ],
      ),
    ),
    DisclosureSection(
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
                'ElSlidingPillGroup: shared with ElToggleGroup and the '
                'theme toggle.',
          ),
          const DocsInstallFact(
            label: 'Docs page tests',
            value: 'example/test/components_docs/tabs_test.dart',
            description:
                'Coverage for this page: API completeness, the live '
                'specimens\' panel switching, the absent-Focus '
                'regression check backing the Accessibility and '
                'Keyboard claims above, the 390px overflow reproduction '
                'backing the Responsive claims above, the RTL mirroring '
                'backing the RTL claims above, and both themes.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/tabs/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class TabsDocPage extends StatelessWidget {
  const TabsDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
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
    toc: tabsDocSpec.toc,
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
    child: KeyedSubtree(
      key: const ValueKey<String>('tabs-doc-article'),
      child: ComponentDocPage(spec: tabsDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// The two-cell live specimen for the Preview section, one [ElTabsVariant]
/// per cell, each a real, switchable [ElTabs].
class _PreviewSpecimen extends StatefulWidget {
  const _PreviewSpecimen();

  @override
  State<_PreviewSpecimen> createState() => _PreviewSpecimenState();
}

class _PreviewSpecimenState extends State<_PreviewSpecimen> {
  int _standardIndex = 0;
  int _lineIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElText('Standard', ElType.section, color: theme.mutedForeground),
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
        ElText('Line', ElType.section, color: theme.mutedForeground),
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

/// The Panels section's own live specimen: the exact two-trigger,
/// two-panel composition [_panelsUsageCode] quotes.
class _PanelsSpecimen extends StatefulWidget {
  const _PanelsSpecimen();

  @override
  State<_PanelsSpecimen> createState() => _PanelsSpecimenState();
}

class _PanelsSpecimenState extends State<_PanelsSpecimen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) => ElTabs(
    key: const ValueKey<String>('tabs-panels-specimen'),
    items: <ElTabItem>[
      ElTabItem(
        label: 'Account',
        content: ElText('Update your account details here.', ElType.small),
      ),
      ElTabItem(
        label: 'Password',
        content: ElText('Change your password here.', ElType.small),
      ),
    ],
    selectedIndex: _selectedIndex,
    onChanged: (int next) => setState(() => _selectedIndex = next),
  );
}

/// The Account settings section's own live specimen: the exact
/// three-trigger composition [_accountSettingsCode] quotes, including the
/// contentless Team trigger.
class _AccountSettingsSpecimen extends StatefulWidget {
  const _AccountSettingsSpecimen();

  @override
  State<_AccountSettingsSpecimen> createState() =>
      _AccountSettingsSpecimenState();
}

class _AccountSettingsSpecimenState extends State<_AccountSettingsSpecimen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    // Three real triggers (Account, Password, Team) run wider than a
    // narrow docs column: Responsive below names exactly this mitigation
    // ("a caller with more triggers than fit a narrow layout must wrap
    // ElTabs in its own horizontal scroll view"), so this specimen does
    // it. The quoted code beside it stays the bare construction — the
    // wrapper is a caller's own choice, not something ElTabs does itself.
    scrollDirection: Axis.horizontal,
    child: SizedBox(
      width: el(95),
      child: ElTabs(
        key: const ValueKey<String>('tabs-account-settings-specimen'),
        items: <ElTabItem>[
          ElTabItem(
            label: 'Account',
            content: ElText(
              'Update your name, email, and time zone.',
              ElType.small,
            ),
          ),
          ElTabItem(
            label: 'Password',
            content: ElText(
              'Change your password and manage two-factor login.',
              ElType.small,
            ),
          ),
          // No content: selecting Team moves the mark and shows nothing.
          // Real, documented behaviour, not an accident of this example.
          ElTabItem(label: 'Team'),
        ],
        selectedIndex: _selectedIndex,
        onChanged: (int next) => setState(() => _selectedIndex = next),
      ),
    ),
  );
}

/// The Line section's own live specimen: the same line-variant shape
/// [_lineUsageCode] quotes (`overviewPanel`/`analyticsPanel` there are
/// placeholder variables, not literal content — the code panel is
/// illustrative, same as Section switcher below). The second trigger reads
/// Stats rather than Analytics here: at a narrow, 390px-class viewport the
/// longer label pushes this track's own RenderFlex 30px past its available
/// width, the same unwrapped, unscrolled overflow Responsive documents —
/// real, but not a fact this specimen needs to demonstrate a second time.
class _LineSpecimen extends StatefulWidget {
  const _LineSpecimen();

  @override
  State<_LineSpecimen> createState() => _LineSpecimenState();
}

class _LineSpecimenState extends State<_LineSpecimen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) => ElTabs(
    key: const ValueKey<String>('tabs-line-variant-specimen'),
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
    selectedIndex: _selectedIndex,
    onChanged: (int next) => setState(() => _selectedIndex = next),
  );
}

/// The RTL section's own live specimen: the same [ElTabs] constructor, under
/// a right-to-left [Directionality] with Arabic labels and content, backing
/// the RTL section's mirroring claim.
class _RtlSpecimen extends StatefulWidget {
  const _RtlSpecimen();

  @override
  State<_RtlSpecimen> createState() => _RtlSpecimenState();
}

class _RtlSpecimenState extends State<_RtlSpecimen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) => Directionality(
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

/* ── Source strings ─────────────────────────────────────────────────────── */

const String _previewCode = '''// Standard
ElTabs(
  items: <ElTabItem>[
    ElTabItem(label: 'Info', content: ElText('Update your account details here.', ElType.small)),
    ElTabItem(label: 'Team', content: ElText('See who else has access to this workspace.', ElType.small)),
    const ElTabItem(label: 'More'), // content: null
  ],
  selectedIndex: selectedIndex,
  onChanged: (int next) => setState(() => selectedIndex = next),
)

// Line
ElTabs(
  variant: ElTabsVariant.line,
  items: <ElTabItem>[
    ElTabItem(label: 'Overview', content: ElText('The dashboard\\'s top-level summary panel.', ElType.small)),
    ElTabItem(label: 'Stats', content: ElText('Traffic and conversion, broken down by channel.', ElType.small)),
  ],
  selectedIndex: selectedIndex,
  onChanged: (int next) => setState(() => selectedIndex = next),
)''';

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

const String _emptyTabCode = '''// content: null — a real, source-documented
// state, not an omission. Selecting it still moves the mark; nothing
// mounts underneath.
const ElTabItem(label: 'Team')''';

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

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-eltabs',
        child: DocsApiTable(
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
                  'Which tab is active: Radix\'s value, resolved to an '
                  'index for ElSlidingPillGroup\'s positional substrate. '
                  'Out of range hides the mark and mounts no panel.',
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
                  'Defaults to ElTabsVariant.standard. standard is the '
                  'filled travelling pill on a muted track; line is the '
                  '2px underline rule on a bare row.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-eltabitem',
        child: DocsApiTable(
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
                  'source-documented state rather than an omission, see '
                  'Empty tab above.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-eltabsvariant',
        child: DocsApiTable(
          title: 'ElTabsVariant and statics',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'ElTabsVariant.standard',
              type: 'enum value',
              description:
                  'The filled pill on a --muted track: theme.primary '
                  'fill, ElShadows.chip, primaryForeground ink on the '
                  'active label.',
            ),
            DocsApiFact(
              name: 'ElTabsVariant.line',
              type: 'enum value',
              description:
                  'A 2px rule under a bare row: theme.actionInk fill, '
                  'no track background, no radius spent on the row '
                  'itself.',
            ),
            DocsApiFact(
              name: 'ElTabs.trackHeight',
              type: 'static double',
              description:
                  '40px: the ladder\'s own top rung ("40px track, 4px '
                  'inset, 32px triggers").',
            ),
            DocsApiFact(
              name: 'ElTabs.triggerHeight',
              type: 'static double',
              description:
                  '32px: every trigger\'s fixed height, standard and '
                  'line alike.',
            ),
            DocsApiFact(
              name: 'ElTabs.triggerPaddingX',
              type: 'static double',
              description: '16px horizontal padding inside a trigger.',
            ),
            DocsApiFact(
              name: 'ElTabs.ruleHeight',
              type: 'static double',
              description: '2px: the line variant\'s underline thickness.',
            ),
            DocsApiFact(
              name: 'ElTabs.rootGap',
              type: 'static double',
              description: '8px: the space between the track and the content panel.',
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
              description: 'The space between triggers: 4px on standard, 8px on line.',
            ),
          ],
        ),
      ),
    ],
  );
}

class _StatesContent extends StatelessWidget {
  const _StatesContent();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsStateMatrix(
          facts: <DocsStateFact>[
            DocsStateFact(
              state: 'Rest (unselected)',
              treatment:
                  'Transparent fill, a transparent ${ElWidths.hairline}px '
                  'hairline border, theme.mutedForeground ink.',
              userSignal:
                  'Only the label is visible, in a dimmer ink than the '
                  'selected trigger; nothing else marks it as a tab.',
            ),
            const DocsStateFact(
              state: 'Hover (unselected)',
              treatment:
                  'Ink alone brightens to theme.foreground over a 250ms '
                  'colour tween; no background fill is painted on hover.',
              userSignal:
                  'A cursor-only affordance: the pointer becomes a click '
                  'cursor and the label recolours, with no hover '
                  'background at all, unlike ElToggleGroup\'s own item, '
                  'which paints theme.muted on hover.',
            ),
            const DocsStateFact(
              state: 'Selected',
              treatment:
                  'standard: the travelling pill (theme.primary, '
                  'ElShadows.chip, pill radius) slides under the trigger '
                  'and its ink becomes theme.primaryForeground. line: a '
                  '2px rule (theme.actionInk) slides to the trigger\'s '
                  'bottom edge and its ink becomes theme.foreground. Both '
                  'squash once via the shared jelly on every change.',
              userSignal:
                  'The one mark travels from the old tab to the new one '
                  'rather than the old tab fading and the new one fading '
                  'in: "selection travels, never blinks" per the '
                  'source\'s own rule.',
            ),
            const DocsStateFact(
              state: 'Focus-visible',
              treatment:
                  'Coded, not live: the trigger\'s shadow spec calls '
                  'ElButton.withFocusRing(ElShadows.none, theme.ring at '
                  '50% alpha, progress: 0). Progress is a hardcoded '
                  'literal 0, not read from any FocusNode, so the '
                  'ring\'s spread and alpha are multiplied by zero on '
                  'every build.',
              userSignal:
                  'No focus ring is ever painted, because nothing in '
                  'ElTabs ever focuses a trigger in the first place: see '
                  'Accessibility and Keyboard.',
            ),
            const DocsStateFact(
              state: 'Empty',
              treatment:
                  'ElTabItem.content: null. Selecting that item still '
                  'runs the trigger\'s own selected treatment; the '
                  'column below the track omits its content branch '
                  'entirely, so no gap and no panel is inserted.',
              userSignal:
                  'The mark still travels, but nothing renders '
                  'underneath: a real, source-documented state (see the '
                  'ElTabItem.content doc comment and Empty tab above), '
                  'not a bug.',
            ),
            const DocsStateFact(
              state: 'Reduced motion',
              treatment:
                  'The pill\'s travel and jelly squash '
                  '(ElSlidingPillGroup) and the trigger\'s own colour '
                  'tween all resolve their duration through '
                  'elAnimationDuration, which '
                  'MediaQueryData(disableAnimations: true) collapses '
                  'toward zero.',
              userSignal:
                  'The mark still relocates and the ink still recolours, '
                  'just without the travel, the squash, or the tween '
                  'reading as motion.',
            ),
          ],
        ),
        SizedBox(height: el(4)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ElWidths.prose),
          child: ElText(
            'Omitted. Pressed: no separate pointer-down look is '
            'authored; only the post-selection jelly squash marks a '
            'change, the same "no held-down state, only a post-toggle '
            'reveal" precedent ElCheckbox documents for its own squash. '
            'Disabled: neither ElTabs nor ElTabItem exposes an enabled '
            'or disabled parameter (contrast ElToggleGroupItem.enabled, '
            'which ElTabItem has no equivalent of); every trigger this '
            'component renders is always operable. Loading: ElTabs is a '
            'synchronous layout primitive with no async operation of '
            'its own. Error and Success: the component defines neither '
            'invalid nor success semantics.',
            ElType.small,
            color: theme.mutedForeground,
          ),
        ),
      ],
    );
  }
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Semantic role: each trigger reports Semantics(button: true, '
            'selected: active, inMutuallyExclusiveGroup: true) and its '
            'label — Flutter has no distinct tab SemanticsFlag, so this '
            'is the framework\'s own nearest analogue. Nothing wraps the '
            'track itself with a container role naming it a tab list, '
            'and the content panel underneath carries no semantic link '
            'back to the trigger that revealed it.',
        'Keyboard interactions: none. See Keyboard below for the full '
            'account, read directly off the source.',
        'Focus behavior: the ring is coded but permanently inert — '
            'ElButton.withFocusRing is called with progress: 0 '
            'hardcoded, and with no FocusNode in the tree there is no '
            'real focus state that could ever change that value.',
        'Touch target: ElTabs.triggerHeight (32px) tall, label-width '
            'wide, no hit-area growth. Unlike ElCheckbox\'s 42x34 '
            'ElHitArea, tabs.dart wraps each trigger in a plain '
            'GestureDetector with no hit-area expansion: the tappable '
            'region is exactly the visible 32px-tall box, under the '
            '~44px platform target floor on the vertical axis.',
        'Non-colour signal: the selected trigger is marked by the '
            'travelling pill or underline\'s position, not only by an '
            'ink colour change, though on the line variant that '
            'position is the sole non-textual cue, with no icon or '
            'glyph reinforcing it.',
        'Error wiring: none, ElTabs defines no invalid or error '
            'concept.',
        'Screen-reader announcements: no live region. Nothing announces '
            'a tab switch beyond whatever the reader happens to read '
            'next; the content panel has no semantic link back to the '
            'trigger that revealed it, so there is no announced '
            'relationship between the two.',
        'Known platform differences: none. Pure Dart layout and paint: '
            'no platform channel and no platform-specific branch.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Read plainly rather than described as the ARIA ideal: no '
            'keyboard interaction is wired at all. Neither '
            '_DsTabsTrigger nor ElSlidingPillGroup contains a Focus '
            'widget, a FocusNode, a Shortcuts or Actions mapping, or an '
            'onKeyEvent handler anywhere in the file.',
        'A tab list is conventionally one keyboard tab stop with arrow '
            'keys moving between tabs and Enter/Space (or automatic '
            'activation) selecting one: none of that exists here.',
        'Tab order: a trigger cannot be reached with the Tab key at '
            'all; tapping or clicking through the plain GestureDetector '
            'is the only way to operate one.',
        'No custom FocusTraversalPolicy: moot, since nothing here ever '
            'enters the focus tree to traverse.',
        'If this ever changes, `tabs_test.dart`\'s own regression check '
            '(asserting no Focus descendant under the live specimen) '
            'starts failing first, and this section and Accessibility '
            'above both need updating to match.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: ElWidths.prose),
    child: ElText(
      'ElTabs neither scrolls nor wraps its triggers when they exceed '
      'the available width, and it does not clip them either: the '
      'track\'s Row (inside ElSlidingPillGroup) keeps Flutter\'s '
      'Row/Flex default clipBehavior of Clip.none, so content that does '
      'not fit paints straight past the track\'s right edge instead of '
      'being cut off at it. Verified directly at a 390px-class width: '
      'five triggers reading Overview, Analytics dashboard, '
      'Notification preferences, Billing and subscriptions and '
      'Security settings inside a 358px-wide column report "A '
      'RenderFlex overflowed by 1068 pixels on the right", a live '
      'RenderFlex assertion, not a cosmetic warning (see tabs_test.dart '
      'for the reproduction this page\'s claim is checked against). In '
      'an unclipped ancestor that bleed can overlap whatever sits to '
      'the right of the tab set; in a clipped one (a ListView tile, a '
      'Card with ClipBehavior.hardEdge) it is invisibly cut instead. '
      'Either way, a caller with more triggers than fit a narrow layout '
      'must wrap ElTabs in its own horizontal scroll view or reduce the '
      'trigger count itself. The component supplies neither. Beyond '
      'that, ElTabs has no other responsive behaviour: no breakpoint '
      'changes shape and keyboard versus pointer operation is identical '
      'on every Flutter target this package supports (there is no '
      'keyboard operation to differ, per Keyboard above).',
      ElType.small,
      color: ElTheme.of(context).mutedForeground,
    ),
  );
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'Source file: ${tabsDoc.sourcePath}.',
        'Local file dependencies: tabs.dart imports '
            'motion/sliding_pill.dart directly, for ElSlidingPillGroup, '
            'the travelling-mark primitive it shares with ElToggleGroup '
            'and the theme toggle; effects/machine_surface.dart, for '
            'ElMachineSurface, the trigger\'s own fill/border/shadow '
            'machinery; and button.dart, pulled in for exactly one '
            'symbol, ElButton.withFocusRing, which drags in Button\'s own '
            'dependency tree even though ElTabs never renders a '
            'ElButton.',
        'Foundation dependencies: foundation/colors.dart, '
            'foundation/motion.dart, foundation/shadows.dart, '
            'foundation/spacing.dart, foundation/theme.dart, '
            'foundation/typography.dart, theme_scope.dart — token '
            'sources: colours, durations and curves, shadow specs, the '
            'el() spacing scale, type specs, and the live theme.',
        'Exports: ${tabsDoc.exports.join(', ')}.',
        'Platforms: Android, iOS, Web, macOS, Windows, Linux — a pure '
            'Flutter widget tree of Row/Stack/DecoratedBox: no platform '
            'channel and no platform-specific branch, so nothing here '
            'differs by target.',
        'Assets: none. The pill and the underline rule are DecoratedBox '
            'fills inside ElMachineSurface, not images or drawn '
            'CustomPainter glyphs.',
        'Fonts: none dedicated. Trigger labels and panel text resolve '
            'through the ambient ElComponentType.buttonLabel and '
            'ElComponentType.textSm type specs: the same system type '
            'scale every other component reads, not a font loaded for '
            'tabs itself.',
        'Shaders: none. No fragment shader is used.',
      ]),
      SizedBox(height: el(2)),
      const DocsLinkRow(
        links: <DocsLink>[DocsLink(label: 'Button', route: '/components/button')],
      ),
    ],
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
