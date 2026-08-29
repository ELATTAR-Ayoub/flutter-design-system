/// Public documentation page for the `breadcrumb` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose [Section]
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button` established. Every specimen
/// widget and every code string below is the same one the hand-composed page
/// carried, with two additions: a live Page header specimen for the
/// composition example that used to have a specimen but no matching code
/// (now paired), and a live specimen for Link component (its `onTap` seam
/// substitutes a local state update for `Navigator.of(context).pushNamed`,
/// since this page has no route table to push against — the code panel
/// still quotes the real router call unchanged). A new Keyboard disclosure
/// is added, between Accessibility and Responsive.
///
/// `breadcrumb` is Wave 1 of the component-documentation plan and carries no
/// `registry/components/breadcrumb.json` manifest yet: Installation says so
/// plainly rather than pretending the CLI command resolves. See `meta.dart`
/// for the same note against [ComponentDocEntry.command]. The command is
/// still read off `breadcrumbDoc.command`, never typed as a literal — the
/// same rule every migrated page follows, manifest or not.
///
/// **Section order**, matching `button`'s own house shape: Preview,
/// Installation, Usage, Composition (the internal-assembly structure
/// diagram: a "what this call builds" breakdown, not code a caller would
/// write, so it stays a [SnippetSection] rather than a stage with nothing
/// live on it), Page header (the same composition, live, in its usual
/// home above a page title), Basic, Link component, RTL, then the eight
/// disclosures. Custom separator, Dropdown, and Collapsed have no
/// counterpart here and never did: `Breadcrumb` has no separator
/// override, no widget slot for a crumb-embedded trigger, and no widget
/// that collapses a trail — see Composition, Link component, and
/// Responsive respectively for where each gap is named.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import 'meta.dart';

final ComponentDocSpec breadcrumbDocSpec = ComponentDocSpec(
  name: 'breadcrumb',
  title: breadcrumbDoc.title,
  description: breadcrumbDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'A typical multi-step trail, and a single current-page crumb, '
          'which renders no separator at all. Hover a link crumb to see '
          'the ink brighten; the current page never responds to hover '
          'or tap.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'breadcrumb has no registry/components/breadcrumb.json manifest '
          'yet: elattar add breadcrumb is not resolvable against the real '
          'registry client. The Manual tab is the only install path this '
          'component has today.',
      command: breadcrumbDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/breadcrumb.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/breadcrumb.dart's source into "
              'components/ui — there is no generated @ui/breadcrumb.dart '
              'payload to pull from yet.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the breadcrumb source here; no manifest exists to '
              'do this for you yet.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so Breadcrumb and BreadcrumbEntry '
              'are reachable the same way every other component is.',
          code: "export 'breadcrumb.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct composition: three steps, the last one '
          'the current page.',
      code: _usageCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'Breadcrumb has no BreadcrumbList, BreadcrumbItem, or '
          'BreadcrumbSeparator to assemble by hand: items builds the '
          'whole trail, and a chevron separator is derived between every '
          'adjacent pair. This is what a single Breadcrumb(items: …) '
          'call assembles internally — a structure diagram, not code a '
          'caller would write, so it stays a snippet rather than a stage '
          'with nothing live to show. See Page header below for the same '
          'composition, live.',
      code: _compositionCode,
    ),
    ShowcaseSection(
      id: 'page-header',
      title: 'Page header',
      description:
          'Breadcrumb sitting above a page title and an action: its '
          'usual home, rather than the isolated specimen in Preview '
          'above.',
      specimen: _PageHeaderSpecimen(),
      code: _pageHeaderCode,
      label: 'Page header specimen view',
    ),
    ShowcaseSection(
      id: 'basic',
      title: 'Basic',
      description:
          'The simplest real trail: two ancestor links and the current, '
          'non-clickable page.',
      specimen: _BasicSpecimen(),
      code: _usageCode,
      label: 'Basic specimen view',
    ),
    ShowcaseSection(
      id: 'link-component',
      title: 'Link component',
      description:
          'Flutter has no anchor tag to swap in: onTap is the '
          'equivalent seam. BreadcrumbEntry.link(label, {onTap}) hands '
          'you a bare VoidCallback, so plugging in a router (go_router, '
          'Navigator, or anything else) is the caller\'s own onTap body, '
          'not a render prop Breadcrumb has to know about. This page '
          'has no route table to push against, so the live specimen '
          'below substitutes a local state update for the '
          'Navigator.of(context).pushNamed call the code panel shows — '
          'the same seam, no real navigation.',
      specimen: _LinkComponentSpecimen(),
      code: _linkComponentCode,
      label: 'Link component specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'The same composition read right-to-left under a '
          'Directionality: the port\'s own proof that direction is '
          'context, not a second set of controls. The chevron does not '
          'flip: nothing in the source mirrors it, and it points the '
          'same way in both directions.',
      specimen: _RtlSpecimen(),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every public class, constructor, field, and static layout '
          'constant the source declares. There is no BreadcrumbVariant '
          'or BreadcrumbSize to choose from: the only per-crumb '
          'decision is which constructor built the entry, .link or '
          '.page, both named below.',
      child: const DocsApiTable(title: 'Breadcrumb', facts: _apiFacts),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Rows that do not apply to a synchronous, variant-free '
          'primitive are marked N/A with the reason, rather than '
          'invented.',
      child: const DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      description: 'What the semantics tree actually carries.',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'breadcrumb.dart wires no key handling of its own — every fact '
          'here is about what does NOT happen, read off _CrumbState '
          'directly.',
      child: _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      description:
          "Breadcrumb's real overflow story: it wraps, it does not "
          'truncate or collapse.',
      child: _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      description:
          "Elattar's own technical-transparency panel: what this "
          'component needs, and what has not been wired into the '
          'registry yet.',
      child: _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      description: 'What actually varies with the theme.',
      child: _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Source and tests',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: breadcrumbDoc.sourcePath,
            description: 'The authoritative package source.',
          ),
          const DocsInstallFact(
            label: 'GitHub',
            value:
                'github.com/ELATTAR-Ayoub/flutter-design-system/blob/v0.0.1/'
                'lib/src/components/ui/breadcrumb.dart',
            description:
                "The same blob path every published registry item's "
                'sourceLink points at.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/navigation_test.dart (Breadcrumb group)',
            description:
                'Package-level behavioral coverage: spacing constants, '
                'derived separators, current-page semantics and taps, RTL '
                'reading order.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/breadcrumb_test.dart',
            description:
                "This page's own responsive, theme, and "
                'API-completeness coverage.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/breadcrumb/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class BreadcrumbDocPage extends StatelessWidget {
  const BreadcrumbDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: breadcrumbDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: breadcrumbDoc.title,
      description:
          'Breadcrumb shows where the current page sits inside a '
          'hierarchy and gives a way back to each ancestor. Reach for it on '
          'a detail page the user drilled into: not for switching between '
          'sibling views (that is Tabs), paging through one list '
          '(Pagination), or a site\'s top-level sections (Navigation Menu). '
          'The trail derives its own separators and wraps onto a new line '
          'instead of collapsing when it runs out of room.',
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Breadcrumb'),
    ],
    toc: breadcrumbDocSpec.toc,
    previous: const DocsPageLink(title: 'Badge', route: '/components/badge'),
    next: const DocsPageLink(title: 'Checkbox', route: '/components/checkbox'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('breadcrumb-doc-article'),
      child: ComponentDocPage(spec: breadcrumbDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      StyledText('Typical trail', TextStyles.section),
      SizedBox(height: space(2)),
      const Breadcrumb(
        items: <BreadcrumbEntry>[
          BreadcrumbEntry.link('Dashboard'),
          BreadcrumbEntry.link('Projects'),
          BreadcrumbEntry.page('Nova Redesign'),
        ],
      ),
      SizedBox(height: space(6)),
      StyledText('Single crumb: no separator to derive', TextStyles.section),
      SizedBox(height: space(2)),
      const Breadcrumb(
        items: <BreadcrumbEntry>[BreadcrumbEntry.page('Only crumb')],
      ),
    ],
  );
}

class _BasicSpecimen extends StatelessWidget {
  const _BasicSpecimen();

  @override
  Widget build(BuildContext context) => const Breadcrumb(
    items: <BreadcrumbEntry>[
      BreadcrumbEntry.link('Dashboard'),
      BreadcrumbEntry.link('Projects'),
      BreadcrumbEntry.page('Nova Redesign'),
    ],
  );
}

class _RtlSpecimen extends StatelessWidget {
  const _RtlSpecimen();

  @override
  Widget build(BuildContext context) => const Directionality(
    textDirection: TextDirection.rtl,
    child: Breadcrumb(
      items: <BreadcrumbEntry>[
        BreadcrumbEntry.link('الرئيسية'),
        BreadcrumbEntry.page('الإعدادات'),
      ],
    ),
  );
}

class _PageHeaderSpecimen extends StatelessWidget {
  const _PageHeaderSpecimen();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Breadcrumb(
        items: <BreadcrumbEntry>[
          BreadcrumbEntry.link('Dashboard'),
          BreadcrumbEntry.link('Projects'),
          BreadcrumbEntry.page('Nova Redesign'),
        ],
      ),
      SizedBox(height: space(3)),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: StyledText(
              'Nova Redesign',
              TextStyles.h3,
              color: ThemeScope.of(context).foreground,
            ),
          ),
          SizedBox(width: space(3)),
          Button(
            variant: ButtonVariant.outline,
            onPressed: () {},
            child: const Text('Share'),
          ),
        ],
      ),
    ],
  );
}

/// Demonstrates the real onTap seam without a real router: tapping
/// "Projects" substitutes a local state update for
/// `Navigator.of(context).pushNamed('/projects')`, since this page has no
/// route table to push against. The code panel beside it still quotes the
/// real router call unchanged.
class _LinkComponentSpecimen extends StatefulWidget {
  const _LinkComponentSpecimen();

  @override
  State<_LinkComponentSpecimen> createState() => _LinkComponentSpecimenState();
}

class _LinkComponentSpecimenState extends State<_LinkComponentSpecimen> {
  String _destination = '/dashboard';

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Breadcrumb(
          items: <BreadcrumbEntry>[
            BreadcrumbEntry.link(
              'Dashboard',
              onTap: () => setState(() => _destination = '/dashboard'),
            ),
            BreadcrumbEntry.link(
              'Projects',
              onTap: () => setState(() => _destination = '/projects'),
            ),
            const BreadcrumbEntry.page('Nova Redesign'),
          ],
        ),
        SizedBox(height: space(3)),
        StyledText(
          'onTap fired: $_destination',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

/* ── Source strings ─────────────────────────────────────────────────────── */

const String _previewCode = '''Breadcrumb(
  items: <BreadcrumbEntry>[
    BreadcrumbEntry.link('Dashboard'),
    BreadcrumbEntry.link('Projects'),
    BreadcrumbEntry.page('Nova Redesign'),
  ],
)

// A single crumb derives no separator.
Breadcrumb(
  items: <BreadcrumbEntry>[BreadcrumbEntry.page('Only crumb')],
)''';

const String _usageCode =
    '''import 'package:elattar_design_system/elattar_design_system.dart';

Breadcrumb(
  items: <BreadcrumbEntry>[
    BreadcrumbEntry.link('Dashboard', onTap: () {}),
    BreadcrumbEntry.link('Projects', onTap: () {}),
    BreadcrumbEntry.page('Nova Redesign'),
  ],
)''';

const String _compositionCode =
    '''// nav: Semantics(container: true, label: 'breadcrumb')
//  ol: DefaultTextStyle(text-sm, muted-foreground) around a Wrap
//   li: one _DsCrumb per entry, gap 6px
//    a / span: BreadcrumbEntry.link renders a tappable crumb,
//              BreadcrumbEntry.page renders the inert current page
//   li (separator): a derived 14px chevron between every adjacent pair,
//                   excluded from the semantics tree''';

const String _pageHeaderCode = '''Breadcrumb(
  items: <BreadcrumbEntry>[
    BreadcrumbEntry.link('Dashboard'),
    BreadcrumbEntry.link('Projects'),
    BreadcrumbEntry.page('Nova Redesign'),
  ],
),
SizedBox(height: space(3)),
Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: <Widget>[
    Expanded(
      child: StyledText(
        'Nova Redesign',
        TextStyles.h3,
        color: ThemeScope.of(context).foreground,
      ),
    ),
    SizedBox(width: space(3)),
    Button(
      variant: ButtonVariant.outline,
      onPressed: () {},
      child: const Text('Share'),
    ),
  ],
)''';

const String _linkComponentCode = '''BreadcrumbEntry.link(
  'Projects',
  // Swap in whatever routing this app already uses: go_router,
  // Navigator, or anything else. Breadcrumb never imports a router
  // itself, onTap is the whole seam.
  onTap: () => Navigator.of(context).pushNamed('/projects'),
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: Breadcrumb(
    items: <BreadcrumbEntry>[
      BreadcrumbEntry.link('الرئيسية'),
      BreadcrumbEntry.page('الإعدادات'),
    ],
  ),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Semantic role: the root wraps every crumb in Semantics(container: '
            "true, label: 'breadcrumb', explicitChildNodes: true): a "
            'labelled container, read by a screen reader as a group named '
            '"breadcrumb".',
        'Per-crumb role: each link crumb carries Semantics(link: true); '
            'the current page adds enabled: false on top of that. Both '
            'derive their accessible name from the rendered label: no '
            'separate override is passed.',
        'Keyboard interactions: none today. The link crumb has no Focus/'
            'FocusNode, so a keyboard-only user cannot Tab to a crumb or '
            'activate one with Enter or Space; only pointer and touch taps '
            'are wired. See Keyboard below for the full account.',
        'Focus behavior: nothing to describe beyond Keyboard: the widget '
            'never receives focus.',
        'Touch target: no minimum tap-area padding is applied: the hit '
            "region is exactly the rendered text's box. Keep crumb labels "
            'short on mobile rather than relying on a generous tap target.',
        'Non-color signal: the current page also stops responding to '
            'hover and tap, so it is not distinguished by ink color alone. '
            'Link crumbs among themselves are told apart only by their '
            'labels.',
        'Error wiring: none, Breadcrumb never participates in form '
            'validation or an error state.',
        'Screen-reader announcements: none beyond the static labels above; '
            'nothing here is live or dynamic.',
        'Platform differences: none observed: the same Semantics tree '
            'renders identically across every Flutter platform target.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No Focus or FocusNode anywhere in breadcrumb.dart: the link '
            'crumb wraps a MouseRegion and a GestureDetector only, never a '
            'Focus widget.',
        'Tab order: a crumb never enters keyboard traversal. There is no '
            'FocusNode to request focus on, so canRequestFocus does not '
            'apply.',
        'Activation: onTap fires from a pointer or touch tap only. There '
            'is no KeyEvent handling anywhere in the file, so Enter and '
            'Space do nothing to a crumb — there is nothing focused for '
            'them to act on.',
        'No custom FocusTraversalPolicy: moot, since nothing here ever '
            'enters the focus tree to traverse.',
        'Known gap: a keyboard-only visitor cannot reach or activate a '
            'crumb today. See Accessibility above for the same gap named '
            'against the semantics tree.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'The list lays out as a Wrap (spacing and runSpacing both set to '
            'Breadcrumb.gap, crossAxisAlignment centered), the same '
            "shape Tailwind's flex flex-wrap gives the reference, not a "
            'fixed single-line Row.',
        'Once a row of crumbs and separators would overflow the '
            'available width, the trail wraps onto a second line. Nothing '
            'is clipped, scrolled, or replaced with an ellipsis.',
        "BreadcrumbEllipsis is recorded in the source's own doc comment "
            'as an export the underlying reference carries, but no '
            'Flutter widget builds a collapsed trail: the port renders '
            'none because the page it was measured against never mounts '
            'one either. Do not reach for a collapsing behavior this '
            'component does not have.',
        'The pointer hover transition needs a mouse; on touch-only '
            'platforms the tap still fires immediately, it just never '
            'shows the intermediate brightening color.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/breadcrumb.dart: one file, no '
            'companions.',
        'Real transitive needs: the foundation modules (motion, spacing, '
            'theme, typography) source-foundation already stands for '
            'across every other entry, plus icon for the chevron '
            'separator.',
        'No registry/components/breadcrumb.json manifest wires either '
            'name in automatically yet: see Installation above for the '
            'manual-only story this leaves.',
        'Assets: none. Shaders: none. Platforms: Android, iOS, Web, '
            'macOS, Windows, Linux — pure widget composition, nothing '
            'platform-gated.',
      ]),
      SizedBox(height: space(2)),
      const DocsLinkRow(
        links: <DocsLink>[DocsLink(label: 'Icon', route: '/components/icon')],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Breadcrumb carries no fill, border, or surface of its own: it '
            'only sets type and ink. Every crumb, link and page alike, '
            'renders at TextStyles.bodySmall; the weight never changes.',
        'Ink is the whole story: theme.mutedForeground at rest, '
            'theme.foreground on hover or for the current page. Both come '
            'from the DefaultTextStyle that wraps the entire Wrap, and '
            "the separator's IconTone.inherit reads that same ambient "
            'style: the Flutter equivalent of a currentColor stroke.',
        'Because color is the only token in play, a custom theme only '
            'has to keep mutedForeground and foreground legibly distinct '
            'in both light and dark: there is no dedicated breadcrumb-*, '
            'background, or border role to override.',
      ]);
}

Widget _bullets(ThemeTokens theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: StyledText(
          '•  $line',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
      ),
      SizedBox(height: space(2)),
    ],
  ],
);

/* ── Facts ───────────────────────────────────────────────────────────────── */

const List<DocsApiFact> _apiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'items',
    type: 'List<BreadcrumbEntry>',
    description:
        'Required. The ordered trail. A chevron separator is derived '
        'between every adjacent pair: there is no way to place two crumbs '
        'with no separator between them.',
  ),
  DocsApiFact(
    name: 'gap',
    type: 'static double (get)',
    description:
        "6px: the list's own Wrap spacing and runSpacing, on both axes, "
        'since it can wrap onto more than one line.',
  ),
  DocsApiFact(
    name: 'separatorPx',
    type: 'static double (get)',
    description: "14px: the derived chevron separator's own box.",
  ),
  DocsApiFact(
    name: 'BreadcrumbEntry.link(label, {onTap})',
    type: 'const factory',
    description:
        'A step back in the trail. label is required and positional; '
        'onTap is optional (default null): a link with no onTap is inert '
        'but still styled and semantically a link.',
  ),
  DocsApiFact(
    name: 'BreadcrumbEntry.page(label)',
    type: 'const factory',
    description:
        'The current page. label is required and positional. Renders at '
        'theme.foreground, is never tappable, and is marked disabled in '
        'the semantics tree.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String',
    description: 'The crumb text, from whichever constructor built the entry.',
  ),
  DocsApiFact(
    name: 'onTap',
    type: 'VoidCallback?',
    description:
        'Only ever set by BreadcrumbEntry.link; always null on a page '
        'entry.',
  ),
  DocsApiFact(
    name: 'isPage',
    type: 'bool',
    description:
        'Derived, not a constructor parameter of its own: true for '
        'entries built with .page, false for .link. Read-only.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest (link crumb)',
    treatment: 'TextStyles.bodySmall at theme.mutedForeground.',
    userSignal: 'Reads as secondary, quiet text until interacted with.',
  ),
  DocsStateFact(
    state: 'Hover (link crumb)',
    treatment:
        'Animates to theme.foreground over effectiveMotionDuration(context, '
        'MotionDurations.normal) on MotionCurves.enter.',
    userSignal:
        'The crumb brightens toward full-strength text and the cursor '
        'becomes a pointer.',
  ),
  DocsStateFact(
    state: 'Current page (BreadcrumbEntry.page)',
    treatment:
        'theme.foreground at all times; Semantics(link: true, enabled: '
        'false); no GestureDetector is attached.',
    userSignal:
        'The strongest-contrast crumb in the trail; does not respond to '
        'hover or tap.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        'N/A: the link crumb wraps a MouseRegion and a GestureDetector '
        'but no Focus/FocusNode, so it never enters keyboard Tab order '
        'and paints no focus ring.',
    userSignal:
        'A keyboard-only visitor cannot reach a crumb today: see '
        'Accessibility and Keyboard.',
  ),
  DocsStateFact(
    state: 'Pressed',
    treatment:
        'N/A, GestureDetector.onTap fires with no intermediate pressed-'
        'state paint; there is no Press scale or opacity step here.',
    userSignal: 'A tap or click resolves in a single frame.',
  ),
  DocsStateFact(
    state: 'Loading / Error / Success',
    treatment:
        'N/A, Breadcrumb is a synchronous rendering primitive with no '
        'future, stream, or error boundary of its own.',
    userSignal: 'Not applicable.',
  ),
  DocsStateFact(
    state: 'Empty items',
    treatment:
        'N/A as a dedicated state, Breadcrumb(items: const []) renders '
        'a zero-size Wrap: no crumbs, no separators, no placeholder text.',
    userSignal: 'The control disappears rather than showing a message.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'N/A as a whole-widget state: the nearest equivalent is per-'
        'entry: BreadcrumbEntry.page is permanently non-interactive.',
    userSignal: 'See Current page above.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'The hover transition is read through effectiveMotionDuration, which '
        'collapses to Duration.zero under MediaQuery.disableAnimations.',
    userSignal: 'The ink still changes on hover; it snaps instead of easing.',
  ),
];
