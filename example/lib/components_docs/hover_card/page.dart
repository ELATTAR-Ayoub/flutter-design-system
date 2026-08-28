/// Public documentation page for the `hover_card` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose [Section]
/// panels; it now declares a [ComponentDocSpec]
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// [ComponentDocPage], the same shape `button`, `field`, and `popover`
/// established. Every specimen widget and every code string below is the
/// one the hand-composed page carried; the unheaded live demo above
/// Installation is now the page's own `Preview` `ShowcaseSection`, so it
/// finally owns a rail entry, and a dedicated Keyboard disclosure is split
/// out of the combined Accessibility section, matching `button`'s own
/// house shape.
///
/// **Corrected, not carried across.** The hand-composed page's
/// Installation and Dependencies sections both said `hover-card` had "no
/// registry manifest yet" and was "unregistered." That was false the whole
/// time this page existed: `registry/components/hover-card.json` is a real
/// manifest — `files`, `registryDependencies: [popover, source-foundation]`,
/// a `documentationRoute` — and `elattar add hover-card` installs from it
/// today. Installation and Dependencies below say so.
///
/// **Keyboard, read from the source rather than assumed.** `hover_card.dart`
/// wires no `Focus`, `FocusNode`, or `onKeyEvent` anywhere: the component's
/// `_HoverCardState.build` opens and closes through a bare `MouseRegion`'s
/// `onEnter`/`onExit` only. There is no focus-driven open path to document —
/// the Keyboard disclosure below says exactly that, the same fact
/// Accessibility's own "No focus" and "No keyboard" bullets already named
/// before this pass, now given its own heading instead of being folded in.
///
/// **shadcn parity**, unchanged from before: fetched fresh from
/// `https://ui.shadcn.com/docs/components/base/hover-card`: Hover Card,
/// Installation, Usage, Composition, Trigger Delays, Positioning, Basic,
/// Sides, RTL, API Reference. Positioning and Sides are both skipped and
/// named here instead: `HoverCardContent`'s `side`/`align` configure
/// placement in the reference, and [HoverCard] has no such parameters —
/// placement is fully automatic (collision-aware, via
/// [popoverPlacement]). Every other section survives as its own
/// declared section.
///
/// **Known bug, carried across correctly.** `_HoverCardSpecimen` takes a
/// `specimenKey` field because this page mounts it three times: Preview,
/// Trigger Delays, and Basic. A `ValueKey` baked into `build()` would
/// collide across all three.
///
/// **API tables, verified.** Built from
/// `lib/src/components/hover_card.dart`'s real constructors: `openDelay`
/// and `closeDelay` default to the real `MotionDurations.hoverCardShowDelay`
/// (700ms) and `MotionDurations.hoverCardHideDelay` (300ms) tokens, not bare
/// literals. `width` defaults to null, which falls back to the static
/// `HoverCard.defaultWidth` getter (288, `w-72`) — that fallback is its
/// own row rather than folded into `width`'s description.
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
import '../../docs/docs_section.dart' show DocsAnchor;
import '../../kit.dart' show Note, NoteTone;
import 'meta.dart';

/// The declaration: every section this page shows, in TOC order. `final`,
/// not `const`: `InstallSection.command` reads `hoverCardDoc.command`, a
/// computed getter, which is not a constant expression.
final ComponentDocSpec hoverCardDocSpec = ComponentDocSpec(
  name: 'hover-card',
  title: hoverCardDoc.title,
  description: hoverCardDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Move your pointer over the text (not on touch) to see the '
          'preview.',
      specimen: const _HoverCardSpecimen(specimenKey: 'hover-card-specimen'),
      code: _hoverCardCode,
      label: 'Hover Card specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'hover-card has a real registry manifest, `elattar add '
          'hover-card` installs lib/src/components/hover_card.dart and '
          'resolves popover and source-foundation automatically. The '
          'Manual tab is for a project not using the CLI.',
      command: hoverCardDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/hover_card.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/hover_card.dart's generated "
              '@ui/hover_card.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated hover card source here when using '
              'manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so HoverCard and HoverCardContent '
              'are reachable the same way the CLI path already makes '
              'them.',
          code: "export 'hover_card.dart';",
        ),
      ],
    ),
    const SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The card opens and closes automatically on pointer entry and '
          'exit; there is no caller-owned open state to manage.',
      code: _hoverCardCode,
    ),
    const SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'What the constructor assembles internally, not a runnable '
          'snippet: HoverCard composes popoverPlacement and '
          'PopoverSurface directly rather than Popover itself. '
          "Popover's full-screen dismiss barrier would take the pointer "
          'off the trigger and the card would close and reopen forever, '
          'so there is nothing here to stage live beyond the Preview '
          'specimen above.',
      code: _hoverCardCompositionCode,
    ),
    ShowcaseSection(
      id: 'trigger-delays',
      title: 'Trigger Delays',
      description:
          "openDelay (default 700ms, MotionDurations.hoverCardShowDelay: Radix's "
          'own default) is how long the pointer must rest on the trigger '
          'before the card opens. closeDelay (default 300ms, '
          'MotionDurations.hoverCardHideDelay) is the window in which the '
          'pointer can cross the gap into the card itself before it '
          'closes. Same composition as Usage above, at its default delays.',
      specimen: const _HoverCardSpecimen(
        specimenKey: 'hover-card-delays-specimen',
      ),
      code: _hoverCardCode,
      label: 'Trigger Delays specimen view',
    ),
    ShowcaseSection(
      id: 'basic',
      title: 'Basic',
      description:
          'The same specimen shown in Preview, mounted again under its '
          'own key: hover the trigger text to see the preview.',
      specimen: const _HoverCardSpecimen(
        specimenKey: 'hover-card-basic-specimen',
      ),
      code: _hoverCardCode,
      label: 'Basic specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          "The card's content reads right-to-left. Placement is "
          "unaffected: HoverCard positions from the trigger's own box, "
          'which Directionality does not move.',
      specimen: const _HoverCardRtl(),
      code: _hoverCardRtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter HoverCard and HoverCardContent '
          'declare, plus the static layout helpers a width or offset '
          'falls back to.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'HoverCard', anchor: 'api-elhovercard'),
        DocsTocEntry(
          title: 'HoverCard static helpers',
          anchor: 'api-elhovercard-static',
        ),
        DocsTocEntry(
          title: 'HoverCardContent',
          anchor: 'api-elhovercardcontent',
        ),
      ],
      child: const _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read straight off _HoverCardState, not inferred: every timing '
          'cited is the real MotionDurations token the source names.',
      child: const DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: const _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      child: const _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: const _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: const _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: const _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: hoverCardDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/hover_card_test.dart',
            description:
                'Covers this page: the article mounts, all three live '
                'specimens, the full API table, and both themes at two '
                'viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/hover_card/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class HoverCardDocPage extends StatelessWidget {
  const HoverCardDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: hoverCardDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: hoverCardDoc.title,
      description: hoverCardDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Hover Card'),
    ],
    toc: hoverCardDocSpec.toc,
    previous: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('hover-card-doc-article'),
      child: ComponentDocPage(spec: hoverCardDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// This page mounts a hover card three times: Preview, Trigger Delays, and
/// Basic. `specimenKey` gives each mount its own [ValueKey] — a key baked
/// into `build()` would collide across all three, since the page renders as
/// one continuous scroll.
class _HoverCardSpecimen extends StatelessWidget {
  const _HoverCardSpecimen({this.specimenKey = 'hover-card-specimen'});

  final String specimenKey;

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      key: ValueKey<String>(specimenKey),
      trigger: StyledText(
        'Hover here to see a preview',
        TextStyles.small,
        color: ThemeScope.of(context).actionText,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StyledText('Preview Title', TextStyles.section),
          SizedBox(height: space(1)),
          StyledText(
            'This is a hover card: it opens on pointer entry and closes '
            'when the pointer leaves. Not available on touch.',
            TextStyles.small,
            color: ThemeScope.of(context).mutedForeground,
          ),
        ],
      ),
    );
  }
}

class _HoverCardRtl extends StatelessWidget {
  const _HoverCardRtl();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: HoverCard(
        trigger: StyledText(
          'مرر فوق هذا النص للمعاينة',
          TextStyles.small,
          color: ThemeScope.of(context).actionText,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            StyledText('عنوان المعاينة', TextStyles.section),
            SizedBox(height: space(1)),
            StyledText(
              'هذه بطاقة معاينة تظهر عند دخول المؤشر وتختفي عند خروجه.',
              TextStyles.small,
              color: ThemeScope.of(context).mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}

const String _hoverCardCode = '''return HoverCard(
  trigger: const StyledText('Hover to preview'),
  content: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      StyledText('Card Title', TextStyles.section),
      SizedBox(height: space(1)),
      StyledText(
        'A preview that opens on hover. Pointer-only: not on touch.',
        TextStyles.small,
      ),
    ],
  ),
);''';

const String _hoverCardCompositionCode = '''HoverCard(
  trigger: ...,                        // pointer entry opens the card
  content: ...,                        // laid out inside HoverCardContent
)''';

const String _hoverCardRtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: HoverCard(
    trigger: const StyledText('مرر فوق هذا النص للمعاينة'),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText('عنوان المعاينة', TextStyles.section),
        SizedBox(height: space(1)),
        StyledText(
          'هذه بطاقة معاينة تظهر عند دخول المؤشر وتختفي عند خروجه.',
          TextStyles.small,
        ),
      ],
    ),
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
        id: 'api-elhovercard',
        child: DocsApiTable(title: 'HoverCard', facts: _hoverCardApiFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elhovercard-static',
        child: DocsApiTable(
          title: 'HoverCard static helpers',
          facts: _hoverCardStaticFacts,
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elhovercardcontent',
        child: DocsApiTable(
          title: 'HoverCardContent',
          facts: _hoverCardContentApiFacts,
        ),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _bullets(theme, <String>[
          'Pointer only: opens on pointer entry after openDelay, closes '
              'on pointer exit after closeDelay (the gap-crossing '
              'window). Never appears on touch.',
          'No semantic role of its own: neither HoverCard nor '
              'HoverCardContent wraps its content in a Semantics node; '
              'the card\'s text reaches assistive tech through whatever '
              'default static-text semantics StyledText already carries.',
          'The card does not trap focus and cannot be focused itself: it '
              'is announcement-only. A screen reader must read the '
              'trigger to learn about the preview; see Keyboard for the '
              'focus story in full.',
        ]),
        SizedBox(height: space(3)),
        Note(
          tone: NoteTone.error,
          title: 'A hover-only affordance is invisible on a phone',
          child: StyledText(
            'Use a hover card for optional detail, not required content: '
            'do not put anything a touch user must read inside one.',
            TextStyles.small,
          ),
        ),
      ],
    );
  }
}

/// Read straight off `hover_card.dart`'s `_HoverCardState`: no `Focus`,
/// `FocusNode`, or `onKeyEvent` appears anywhere in the file. Opening and
/// closing both route through a bare `MouseRegion`'s `onEnter`/`onExit`
/// only, so there is no focus-driven or keyboard-driven open path to
/// document — this section says that plainly rather than describing a
/// keyboard story the source does not have.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No keyboard path exists: hover_card.dart wires no Focus, '
            'FocusNode, or onKeyEvent anywhere. The card opens only from '
            'MouseRegion.onEnter (pointer entry) and closes only from '
            'onExit (pointer exit) or the close-delay timer expiring.',
        'Focusing the trigger does nothing here: whatever focus '
            'behaviour the trigger widget itself carries is untouched, '
            'but reaching it by Tab does not open the card — only '
            'pointer entry does.',
        'No keyboard dismissal either: since nothing here opens the card '
            'from the keyboard, there is no Escape handler or keyboard-'
            'driven close path to speak of. The only ways it closes are '
            'the pointer leaving past closeDelay, or the trigger and '
            'card both losing pointer occupancy.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Pointer entry and exit only, on every platform with a pointer. '
            'Completely hidden on touch: not just disabled, but unmounted '
            '(the OverlayPortal never shows).',
        'Placement comes from popoverPlacement\'s own collision handling '
            'near a viewport edge, the same algorithm the combobox and the '
            'date picker use, and snaps without transition when it flips.',
        'No breakpoint branching, and no dart:io Platform branch, anywhere '
            'in hover_card.dart.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        facts: <DocsInstallFact>[
          const DocsInstallFact(
            label: 'Registry item',
            value: 'hover-card',
            description:
                'registry/components/hover-card.json exists and is '
                'installable through the CLI today.',
          ),
          const DocsInstallFact(
            label: 'Destination',
            value: 'lib/components/ui/hover_card.dart',
            description:
                'The same lib/components/ui/ target every component '
                'installs to.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: hoverCardDoc.dependencies.join(', '),
            description:
                "The manifest's own registryDependencies, resolved "
                'automatically by `elattar add hover-card`.',
          ),
          const DocsInstallFact(
            label: 'Primary composition',
            value: 'popoverPlacement, PopoverSurface',
            description:
                'Composes the popover positioner and surface directly, '
                'not Popover itself: Popover\'s full-screen dismiss '
                'barrier would take the pointer off the trigger and the '
                'card would close and reopen forever, see Composition '
                'above.',
          ),
          const DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description:
                'Pure widget composition; unmounted entirely on touch.',
          ),
          const DocsInstallFact(
            label: 'Verified',
            value: 'example/test/components_docs/hover_card_test.dart',
            description:
                "This page's own three live specimens, section order, "
                'and API table coverage: 390x844 and 1440x900, both '
                'themes.',
          ),
        ],
      ),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Popover', route: '/components/popover'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(
    BuildContext context,
  ) => _bullets(ThemeScope.of(context), <String>[
    'Surface: theme.popover fill, theme.popoverForeground text, via '
        'PopoverSurface, which also applies the ring and shadow '
        '(theme.foreground at 10% alpha).',
    'Animation: fade-in-0, zoom-in-95, and a slide-in-from-top-2 run '
        'through MotionDurations.overlayEnter (320ms) on MotionCurves.enter; the exit '
        'drops the slide.',
    'Every duration and curve is read live; nothing is a page-local '
        'constant.',
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

const List<DocsApiFact> _hoverCardApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'trigger',
    type: 'Widget',
    description: 'Required. The target: pointer entry starts the open timer.',
  ),
  DocsApiFact(
    name: 'content',
    type: 'Widget',
    description:
        'Required. The preview content: laid out inside '
        'HoverCardContent\'s own padding.',
  ),
  DocsApiFact(
    name: 'width',
    type: 'double?',
    description:
        'Optional. Defaults to null, which falls back to '
        'HoverCard.defaultWidth (288, w-72). A literal width, not a '
        'max-width.',
  ),
  DocsApiFact(
    name: 'openDelay',
    type: 'Duration',
    description:
        'Optional. Defaults to MotionDurations.hoverCardShowDelay (700ms: '
        'Radix HoverCard\'s own openDelay default). How long the pointer '
        'must rest on the trigger before the card opens.',
  ),
  DocsApiFact(
    name: 'closeDelay',
    type: 'Duration',
    description:
        'Optional. Defaults to MotionDurations.hoverCardHideDelay (300ms). '
        'How long the card stays open after the pointer leaves: the '
        'gap-crossing window.',
  ),
];

const List<DocsApiFact> _hoverCardStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'HoverCard.defaultWidth',
    type: 'static double',
    description:
        '288 (w-72): what width falls back to when null. The '
        'component\'s own w-64 (256) default is never rendered anywhere '
        'in this port and is not what null resolves to.',
  ),
  DocsApiFact(
    name: 'HoverCard.sideOffset',
    type: 'static double',
    description: 'Gap between the trigger and the card: 4px.',
  ),
  DocsApiFact(
    name: 'HoverCard.slide',
    type: 'static double',
    description: 'The enter animation\'s slide-in-from-top distance: 8px.',
  ),
];

const List<DocsApiFact> _hoverCardContentApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        'Required. The preview content, laid out inside this widget\'s '
        'own padding.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment: 'The trigger only; no card mounted.',
    userSignal: 'Looks like ordinary text or content.',
  ),
  DocsStateFact(
    state: 'Hover (opening)',
    treatment:
        'Pointer entry on the trigger starts a 700ms openDelay timer '
        '(MotionDurations.hoverCardShowDelay). Nothing is visible until it '
        'fires.',
    userSignal:
        'A brief pause with no visible change before the card '
        'appears.',
  ),
  DocsStateFact(
    state: 'Open',
    treatment:
        'The card mounts through an OverlayPortal and animates in with '
        'fade-in-0, zoom-in-95, and a slide-in-from-top-2, over '
        'MotionDurations.overlayEnter (320ms) on MotionCurves.enter.',
    userSignal: 'The card fades, zooms, and slides in from above.',
  ),
  DocsStateFact(
    state: 'Closing',
    treatment:
        'The pointer leaving either the trigger or the card starts a '
        '300ms closeDelay timer (MotionDurations.hoverCardHideDelay). '
        'Re-entering the card within that window (crossing the 4px gap) '
        'cancels it.',
    userSignal:
        'A short grace period to move the pointer into the card '
        'itself before it closes.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        'Not applicable: the card cannot receive focus and has no '
        'keyboard opener.',
    userSignal: 'Invisible to keyboard-only navigation.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment: 'HoverCard carries no disable parameter.',
    userSignal: 'N/A.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'The open/close animation routes through effectiveMotionDuration, '
        'which is Duration.zero under reduced motion. The open/close '
        'delays themselves are unaffected: they are dwell timers, not '
        'animations.',
    userSignal:
        'The card still waits for the dwell timers, but appears '
        'and disappears instantly once it does.',
  ),
  DocsStateFact(
    state: 'Touch',
    treatment:
        'No touch path at all: onEnter/onExit are pointer-only '
        'MouseRegion events, so the card never mounts.',
    userSignal: 'Completely absent on a touch-only device.',
  ),
];
