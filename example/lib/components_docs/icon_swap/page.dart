/// Public documentation page for the `icon-swap` effect.
///
/// **Why `EffectSection`, not `ShowcaseSection`.** `IconSwap` has no variant
/// enum and, per its own class doc, is never placed "beside" the control it
/// belongs to: it is always the `child:` of some other pressable — an
/// `Button` in both real corpus call sites this page cites
/// (`lib/src/components/ui/attachment.dart`, `lib/src/components/ui/sidebar.dart`).
/// A `ShowcaseSection` stages a specimen on its own; `EffectSection` stages
/// the **host it is applied to**, which is what a reader actually needs to
/// see to understand a control that changed meaning. Every non-Preview
/// section below is one real corpus use, not an invented one.
///
/// **Section list.** Preview stages the roll beside a plain instant swap, the
/// contrast the source's own docstring draws ("It is a carousel, not a
/// fade"). Sidebar Trigger and Download Confirmation are the port's only two
/// live call sites, reproduced faithfully — two icons each, ghost `Button`
/// each, the exact glyphs and `window`/`cell` values the source uses. The
/// eight disclosures close the page, in the fixed order every page uses.
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

final ComponentDocSpec iconSwapDocSpec = ComponentDocSpec(
  name: 'icon_swap',
  title: 'Icon Swap',
  description:
      'A fixed clip window that rolls one glyph out through the top and the '
      'next in from below, with a squash on arrival: the standard way a '
      'two-state icon control shows you it changed, never a crossfade or an '
      'instant swap.',
  sections: <DocsPageSection>[
    EffectSection(
      id: 'preview',
      title: 'Preview',
      description:
          "The source's own claim: \"it is a carousel, not a fade.\" The "
          'left button rolls its glyph through the clip window on every tap '
          '(IconSwap); the right one swaps its Icon child outright, no '
          'transition of any kind, so the difference is legible mid-motion, '
          'not just at rest.',
      host: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'icon-swap has a real registry manifest: `elattar add icon-swap` '
          'installs lib/src/components/ui/icon_swap.dart and resolves both '
          'registryDependencies automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: iconSwapDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/icon_swap.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/icon_swap.dart's generated "
              '@ui/icon_swap.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated icon-swap source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so IconSwap is reachable the same way '
              'the CLI path already makes it.',
          code: "export 'icon_swap.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'IconSwap is decorative by itself: put it inside a pressable as '
          'the child, never beside one — the accessible name belongs on the '
          'control that contains it.',
      code: _usageCode,
    ),
    EffectSection(
      id: 'sidebar-trigger',
      title: 'Sidebar Trigger',
      description:
          "lib/src/components/ui/sidebar.dart's SidebarTrigger: a ghost "
          'iconSm Button whose glyph rolls between panelLeftClose and '
          'panelLeft as the panel opens and closes. Tap it a few times: '
          'collapsing rolls one way through the strip, expanding rolls '
          'back — neither direction is special-cased, both fall out of the '
          'same offset arithmetic, so the reversal is the genuine inverse '
          'rather than a replayed forward pass.',
      host: _SidebarTriggerSpecimen(),
      code: _sidebarTriggerCode,
      label: 'Sidebar Trigger specimen view',
    ),
    EffectSection(
      id: 'download-confirmation',
      title: 'Download Confirmation',
      description:
          "lib/src/components/ui/attachment.dart's download action: a ghost "
          'iconXs Button rolling from a download glyph to a check on tap. '
          'The real call site also auto-reverts the check back to download '
          'after MotionDurations.attachmentSaving, on a timer AttachmentAction '
          'owns — outside IconSwap itself, so this specimen tap-toggles '
          'both ways instead of replaying that timer.',
      host: _DownloadConfirmationSpecimen(),
      code: _downloadConfirmationCode,
      label: 'Download Confirmation specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter IconSwap declares, plus its one '
          'public static helper.',
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read straight off _IconSwapState: initState, '
          'didChangeDependencies, didUpdateWidget and _readMotion, not '
          'inferred.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      child: _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
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
      child: _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: iconSwapDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/components_test.dart',
            description:
                'IconSwap is covered inside the shared base-components '
                'suite: there is no dedicated icon_swap_test.dart in the '
                'package yet.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/icon_swap_test.dart',
            description:
                'Covers this page: the article mounts, the full API table, '
                'both real call sites, and both themes.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/icon_swap/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class IconSwapDocPage extends StatelessWidget {
  const IconSwapDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: iconSwapDoc.route,
    intro: DocsPageIntro(
      title: iconSwapDoc.title,
      description: iconSwapDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Icon Swap'),
    ],
    toc: iconSwapDocSpec.toc,
    previous: null,
    next: const DocsPageLink(
      title: 'Hover Builder',
      route: '/components/hover_builder',
    ),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('icon-swap-doc-article'),
      child: ComponentDocPage(spec: iconSwapDocSpec, header: false),
    ),
  );
}

/* ── Effect specimens ───────────────────────────────────────────────────── */

class _PreviewColumn extends StatelessWidget {
  const _PreviewColumn({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        StyledText(label, TextStyles.small, color: theme.mutedForeground),
        SizedBox(height: space(3)),
        child,
      ],
    );
  }
}

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  // Two side-by-side labeled columns fit comfortably at the desktop corner,
  // but at 200% text scale on mobile the pair of labels alone outgrows the
  // available width. `LayoutBuilder` stacks them instead of shrinking the
  // gap, so desktop keeps its side-by-side comparison and mobile gets a
  // narrow, non-overflowing column.
  static const double _stackBreakpoint = 480;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final bool stacked = constraints.maxWidth < _stackBreakpoint;
      final List<Widget> columns = <Widget>[
        _PreviewColumn(
          label: 'Rolls',
          child: KeyedSubtree(
            key: const ValueKey<String>('icon-swap-preview:rolling'),
            child: const _RollingToggleButton(),
          ),
        ),
        _PreviewColumn(
          label: 'Swaps instantly',
          child: KeyedSubtree(
            key: const ValueKey<String>('icon-swap-preview:instant'),
            child: const _InstantToggleButton(),
          ),
        ),
      ];
      if (stacked) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            columns[0],
            SizedBox(height: space(6)),
            columns[1],
          ],
        );
      }
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          columns[0],
          SizedBox(width: space(10)),
          columns[1],
        ],
      );
    },
  );
}

const String _previewCode =
    '// Rolls — the effect this page documents\n'
    'Button(\n'
    '  variant: ButtonVariant.ghost,\n'
    '  size: ButtonSize.iconSm,\n'
    "  label: 'Toggle panel',\n"
    '  onPressed: () => setState(() => open = !open),\n'
    '  child: IconSwap(\n'
    '    activeIndex: open ? 0 : 1,\n'
    '    window: Icon.pxFor(IconSize.md),\n'
    '    cell: Icon.pxFor(IconSize.md),\n'
    '    icons: const [\n'
    '      Icon.lucide(Lucide.panelLeftClose),\n'
    '      Icon.lucide(Lucide.panelLeft),\n'
    '    ],\n'
    '  ),\n'
    ')\n\n'
    '// Swaps instantly — no IconSwap, the plain comparison\n'
    'Button(\n'
    '  variant: ButtonVariant.ghost,\n'
    '  size: ButtonSize.iconSm,\n'
    "  label: 'Toggle panel',\n"
    '  onPressed: () => setState(() => open = !open),\n'
    '  child: open\n'
    '      ? const Icon.lucide(Lucide.panelLeftClose)\n'
    '      : const Icon.lucide(Lucide.panelLeft),\n'
    ')';

class _RollingToggleButton extends StatefulWidget {
  const _RollingToggleButton();

  @override
  State<_RollingToggleButton> createState() => _RollingToggleButtonState();
}

class _RollingToggleButtonState extends State<_RollingToggleButton> {
  bool _open = true;

  @override
  Widget build(BuildContext context) {
    final double px = Icon.pxFor(IconSize.md);
    return Button(
      variant: ButtonVariant.ghost,
      size: ButtonSize.iconSm,
      label: 'Toggle panel',
      onPressed: () => setState(() => _open = !_open),
      child: IconSwap(
        activeIndex: _open ? 0 : 1,
        window: px,
        cell: px,
        icons: const <Widget>[
          Icon.lucide(Lucide.panelLeftClose),
          Icon.lucide(Lucide.panelLeft),
        ],
      ),
    );
  }
}

class _InstantToggleButton extends StatefulWidget {
  const _InstantToggleButton();

  @override
  State<_InstantToggleButton> createState() => _InstantToggleButtonState();
}

class _InstantToggleButtonState extends State<_InstantToggleButton> {
  bool _open = true;

  @override
  Widget build(BuildContext context) => Button(
    variant: ButtonVariant.ghost,
    size: ButtonSize.iconSm,
    label: 'Toggle panel',
    onPressed: () => setState(() => _open = !_open),
    child: _open
        ? const Icon.lucide(Lucide.panelLeftClose)
        : const Icon.lucide(Lucide.panelLeft),
  );
}

class _SidebarTriggerSpecimen extends StatefulWidget {
  const _SidebarTriggerSpecimen();

  @override
  State<_SidebarTriggerSpecimen> createState() =>
      _SidebarTriggerSpecimenState();
}

class _SidebarTriggerSpecimenState extends State<_SidebarTriggerSpecimen> {
  bool _open = true;

  @override
  Widget build(BuildContext context) {
    final double px = Icon.pxFor(IconSize.md);
    return KeyedSubtree(
      key: const ValueKey<String>('icon-swap-example:sidebar-trigger'),
      child: Button(
        variant: ButtonVariant.ghost,
        size: ButtonSize.iconSm,
        label: 'Toggle Sidebar',
        onPressed: () => setState(() => _open = !_open),
        child: IconSwap(
          activeIndex: _open ? 0 : 1,
          window: px,
          cell: px,
          icons: const <Widget>[
            Icon.lucide(Lucide.panelLeftClose),
            Icon.lucide(Lucide.panelLeft),
          ],
        ),
      ),
    );
  }
}

const String _sidebarTriggerCode =
    'Button(\n'
    '  variant: ButtonVariant.ghost,\n'
    '  size: ButtonSize.iconSm,\n'
    "  label: 'Toggle Sidebar',\n"
    '  onPressed: () => scope.toggleSidebar(),\n'
    '  child: IconSwap(\n'
    '    activeIndex: scope.open ? 0 : 1,\n'
    '    window: Icon.pxFor(IconSize.md),\n'
    '    cell: Icon.pxFor(IconSize.md),\n'
    '    icons: const [\n'
    '      Icon.lucide(Lucide.panelLeftClose),\n'
    '      Icon.lucide(Lucide.panelLeft),\n'
    '    ],\n'
    '  ),\n'
    ')';

class _DownloadConfirmationSpecimen extends StatefulWidget {
  const _DownloadConfirmationSpecimen();

  @override
  State<_DownloadConfirmationSpecimen> createState() =>
      _DownloadConfirmationSpecimenState();
}

class _DownloadConfirmationSpecimenState
    extends State<_DownloadConfirmationSpecimen> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final double px = Button.iconPxFor(ButtonSize.iconXs);
    return KeyedSubtree(
      key: const ValueKey<String>('icon-swap-example:download-confirmation'),
      child: Button(
        variant: ButtonVariant.ghost,
        size: ButtonSize.iconXs,
        label: _saving ? 'Downloaded' : 'Download file',
        onPressed: () => setState(() => _saving = !_saving),
        child: IconSwap(
          activeIndex: _saving ? 1 : 0,
          window: px,
          cell: px,
          icons: <Widget>[
            Icon.lucide(Lucide.download, sizePx: px),
            Icon.lucide(Lucide.check, sizePx: px),
          ],
        ),
      ),
    );
  }
}

const String _downloadConfirmationCode =
    'final double px = Button.iconPxFor(ButtonSize.iconXs);\n\n'
    'Button(\n'
    '  variant: ButtonVariant.ghost,\n'
    '  size: ButtonSize.iconXs,\n'
    "  label: saving ? null : 'Download \$downloadName',\n"
    '  onPressed: press,\n'
    '  child: IconSwap(\n'
    '    activeIndex: saving ? 1 : 0,\n'
    '    window: px,\n'
    '    cell: px,\n'
    '    icons: [\n'
    '      Icon.lucide(Lucide.download, sizePx: px),\n'
    '      Icon.lucide(Lucide.check, sizePx: px),\n'
    '    ],\n'
    '  ),\n'
    ')';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

Button(
  variant: ButtonVariant.ghost,
  size: ButtonSize.iconSm,
  label: 'Toggle',
  onPressed: () => setState(() => open = !open),
  child: IconSwap(
    activeIndex: open ? 0 : 1,
    window: Icon.pxFor(IconSize.md),
    cell: Icon.pxFor(IconSize.md),
    icons: const [
      Icon.lucide(Lucide.panelLeftClose),
      Icon.lucide(Lucide.panelLeft),
    ],
  ),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(title: 'IconSwap', facts: _iconSwapApiFacts),
      SizedBox(height: space(6)),
      const DocsApiTable(
        title: 'IconSwap static helpers',
        facts: _iconSwapStaticFacts,
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Decorative by itself: IconSwap sets no Semantics node and '
            'contributes no accessible name of its own. The name belongs '
            'on whatever pressable contains it — both real call sites put '
            'it inside an Button and set that button\'s own label.',
        'Inactive cells excluded: every strip cell but the active one is '
            'wrapped ExcludeSemantics(excluding: true), so a screen reader '
            'walking the tree only ever finds the glyph currently at '
            'centre, never the ones mid-roll off to the side.',
        'The active cell is not itself excluded — ExcludeSemantics.'
            'excluding resolves to i != _to, false for the active index — '
            'so whatever semantics the icon widget itself carries (usually '
            'none, Icon sets no label by default) still reaches the '
            'tree, layered under the containing button\'s own label.',
        'No aria-hidden equivalent leaks the motion itself: a screen '
            'reader announces only the button\'s label and pressed state, '
            'exactly as it would if the icon changed with no animation at '
            'all.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'IconSwap takes no focus and handles no key: no Focus, no '
            'FocusNode, no onKeyEvent anywhere in icon_swap.dart. It is a '
            'SizedBox/ClipRect/Stack tree over AnimatedBuilder, nothing '
            'more.',
        'Every keyboard story on this page belongs to the Button that '
            'contains the glyph: Enter, NumpadEnter and Space activate it '
            'exactly as they would with a plain Icon child, and the roll '
            'plays because activeIndex changed, not because a key was '
            'pressed.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching anywhere in icon_swap.dart: BuildContext '
            'width is never read. window and cell are fixed px the caller '
            'passes in — 16px (IconSize.md) on the sidebar trigger, '
            'Button.iconPxFor(ButtonSize.iconXs) on the attachment '
            'action — and neither changes with viewport.',
        'IconSwap.resolveIndex clamps an out-of-range activeIndex to 0 '
            'rather than throwing, mirroring the reference\'s '
            'Math.max(0, keys.indexOf(active)): the strip always shows '
            'something, even a caller error resolves to the first icon.',
        'Platform parity: no dart:io Platform branch in the file: Android, '
            'iOS, Web, macOS, Windows and Linux all render the same widget '
            'tree.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/icon_swap.dart: one file, no companions; '
            'the registry manifest lists exactly one entry under "files".',
        'Flutter imports: package:flutter/foundation.dart (clampDouble), '
            'package:flutter/widgets.dart.',
        'Foundation imports: motion/keyframes.dart (StateChangeMotion, the arrival '
            'squash table), theme_scope.dart (effectiveMotionDuration).',
        'registryDependencies, resolved automatically by `elattar add '
            'icon-swap`: keyframes, source-foundation — copied verbatim '
            'from registry/components/icon-swap.json.',
        'Not a dependency of icon_swap.dart itself, but its only two live '
            'consumers in the corpus: Sidebar (the collapse trigger) and '
            'the attachment download action.',
      ]),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Keyframes', route: '/components/keyframes'),
          DocsLink(label: 'Sidebar', route: '/components/sidebar'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No colour of its own: icon_swap.dart never reads ThemeScope.of'
            '(context) and paints nothing but the Widgets in icons. Colour '
            'comes entirely from whatever those widgets are — an '
            'Icon.lucide\'s own tone, or the ambient icon colour of '
            'whatever contains it.',
        'Flipping ThemeController changes nothing at this layer '
            'directly: each icon re-resolves its own colour on the next '
            'frame the same way it would with no IconSwap wrapping it '
            'at all.',
        'The one thing this file does read through the theme scope is '
            'motion: effectiveMotionDuration(context, …) on both the roll and '
            'the squash, so MediaQuery.disableAnimations (prefers-reduced-'
            'motion) collapses both to zero — see States above.',
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

const List<DocsApiFact> _iconSwapApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'icons',
    type: 'List<Widget>',
    description:
        'Required. The strip, in wheel order — index 0 sits at the top. The '
        'reference reads a Record\'s insertion order for the same list; '
        'every call site in this port is a static pair or trio, so the '
        'honest shape here is the list and the index.',
  ),
  DocsApiFact(
    name: 'activeIndex',
    type: 'int',
    description:
        'Required. Which cell is at centre. Out of range clamps to 0 via '
        'IconSwap.resolveIndex, mirroring Math.max(0, keys.indexOf'
        '(active)).',
  ),
  DocsApiFact(
    name: 'window',
    type: 'double',
    description:
        'Required. The clip box side length — size-5 (20px) on three of '
        'the reference\'s demos, size-6 (24px) on play/pause. A required '
        'parameter, not derived: it is a fact about the demos that it is '
        '4px larger than the glyph, not a rule the widget enforces.',
  ),
  DocsApiFact(
    name: 'cell',
    type: 'double',
    description:
        "Required. The strip cell's own height — the glyph's height, not "
        'window. One roll step is 160% of this value '
        '(ContentSwapMotion.travelFor). Passing a cell that disagrees with the '
        "glyph's real box changes the travel exactly as a differently-"
        'sized glyph would, uncorrected: there is nothing to correct it '
        'against.',
  ),
];

const List<DocsApiFact> _iconSwapStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'resolveIndex(index, count)',
    type: 'static int',
    description:
        'index >= 0 && index < count ? index : 0 — the same clamp '
        'activeIndex applies internally, exposed so a caller can pre-'
        'resolve it.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Mount',
    treatment:
        '_roll lands on its upper bound immediately (a CSS transition does '
        'not run on the initial style); _squash plays once from '
        'didChangeDependencies, the first-mount squash the reference '
        'itself replays via a mandatory ResizeObserver callback.',
    userSignal:
        'No travel on load — the strip is already in place — but every '
        'demo squashes once, on the active glyph only.',
  ),
  DocsStateFact(
    state: 'activeIndex changes (advance or reverse)',
    treatment:
        '_from and _fromOpacity capture the current frame before '
        're-aiming, then _roll.forward(from: 0) over ContentSwapMotion.duration '
        '(400ms, MotionCurves.emphasized) and _squash.forward(from: 0) over the '
        'delayed 750ms clock (150ms delay + StateChangeMotion.duration 600ms).',
    userSignal:
        'The old glyph exits the direction the offset arithmetic implies '
        'and overshoots ≈9.8% of one step before settling; the arriving '
        'glyph squashes 150ms into the same run. A roll interrupted '
        'mid-flight restarts from wherever it actually is, not from the '
        'target it was leaving.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        '_readMotion routes both controllers through effectiveMotionDuration, '
        'collapsing them to Duration.zero. Flipping the OS switch mid-roll '
        'jumps both controllers to their upper bound on the same frame.',
    userSignal:
        'The swap still happens and still lands, on the frame it was '
        'asked for — instant, never disabled.',
  ),
];
