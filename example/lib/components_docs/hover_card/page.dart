/// Public documentation page for the `hover_card` component.
///
/// **Shape.** Mirrors `button/page.dart`'s reference shape: an unheaded live
/// demo above the first heading, then Installation, Usage, and this
/// component's own sections named plainly, API Reference last of the
/// shadcn-mirrored sections, then States, Accessibility, Responsive,
/// Dependencies, Theming, Source.
///
/// **shadcn parity.** Fetched fresh from
/// `https://ui.shadcn.com/docs/components/base/hover-card`: Hover Card,
/// Installation, Usage, Composition, Trigger Delays, Positioning, Basic,
/// Sides, RTL, API Reference. Positioning and Sides are both skipped and
/// named here instead: `HoverCardContent`'s `side`/`align` configure
/// placement in the reference, and [ElHoverCard] has no such parameters —
/// placement is fully automatic (collision-aware, via
/// [elPopoverPlacement]). Every other section survives as a top-level
/// `ElSection`.
///
/// **Split history.** This component used to be documented on the
/// `navigation_menu` page alongside `navigation_menu`, `menubar`, and
/// `context_menu`, its sections prefixed `Hover Card: ...`. Phase F/J split
/// each component onto its own page; that prefix is dropped here since the
/// page is now about exactly one component.
///
/// **Known bug, carried across correctly.** `_HoverCardSpecimen` takes a
/// `specimenKey` field because this page mounts it three times: the
/// unheaded live demo, Trigger Delays, and Basic. A `ValueKey` baked into
/// `build()` would collide across all three.
///
/// **API tables, verified.** Built from
/// `lib/src/components/hover_card.dart`'s real constructors: `openDelay`
/// and `closeDelay` default to the real `ElDurations.hoverCardOpenDelay`
/// (700ms) and `ElDurations.hoverCardCloseDelay` (300ms) tokens, not bare
/// literals as the merged page's prose implied. `width` defaults to null,
/// which falls back to the static `ElHoverCard.defaultWidth` getter (288,
/// `w-72`) — that fallback is now its own row rather than folded into
/// `width`'s description.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

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
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Hover Card'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Trigger Delays', anchor: 'trigger-delays'),
      DocsTocEntry(title: 'Basic', anchor: 'basic'),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(
        title: 'API Reference',
        anchor: 'api',
        children: <DocsTocEntry>[
          DocsTocEntry(title: 'ElHoverCard', anchor: 'api-elhovercard'),
          DocsTocEntry(
            title: 'ElHoverCard static helpers',
            anchor: 'api-elhovercard-static',
          ),
          DocsTocEntry(
            title: 'ElHoverCardContent',
            anchor: 'api-elhovercardcontent',
          ),
        ],
      ),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: null,
    onNavigate: onNavigate,
    child: const _HoverCardArticle(),
  );
}

class _HoverCardArticle extends StatelessWidget {
  const _HoverCardArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('hover-card-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _preview(),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        SizedBox(height: el(6)),
        _composition(),
        _triggerDelays(),
        _basic(),
        _rtl(),
        _api(),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _theming(theme),
        _source(),
      ],
    );
  }

  Widget _preview() => const DocsCodeExample(
    title: 'Hover Card',
    description:
        'Move your pointer over the text (not on touch) to see the '
        'preview.',
    preview: Center(
      child: _HoverCardSpecimen(specimenKey: 'hover-card-specimen'),
    ),
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        '`elattar add hover-card` installs the component and its declared '
        'dependency closure.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsCodeExample(
          title: 'Manual installation',
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/hover_card.dart',
              code:
                  "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                  '// Copy hover_card.dart source from the package when needed.',
            ),
          ],
        ),
        SizedBox(height: el(4)),
        const DocsInstallFacts(
          title: 'Status',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Status',
              value: 'Stable: registry manifest',
              description:
                  'ElHoverCard and ElHoverCardContent are exported from '
                  'the public barrel and ship in the registry, so '
                  'cannot be installed through the CLI yet.',
            ),
            DocsInstallFact(
              label: 'Dart / Flutter',
              value: '>=3.12.2 <4.0.0 / >=3.12.2',
              description: 'Same constraints as the port.',
            ),
            DocsInstallFact(
              label: 'Platforms',
              value: 'Android, iOS, Web, macOS, Windows, Linux',
              description:
                  'Pure widget composition: nothing is platform-gated, '
                  'though the card itself never opens on a touch-only '
                  'device.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _usage() => ElSection(
    id: 'usage',
    title: 'Usage',
    description:
        'The card opens and closes automatically on pointer entry and '
        'exit; there is no caller-owned open state to manage.',
    child: ElPanel(
      label: 'DART',
      note: 'MINIMAL',
      child: DocsSelectableCodeBlock(code: _hoverCardCode),
    ),
  );

  Widget _composition() => ElSection(
    id: 'composition',
    title: 'Composition',
    description:
        'What the constructor assembles internally. ElHoverCard composes '
        '[elPopoverPlacement] and [ElPopoverSurface] directly rather than '
        '[ElPopover] itself: ElPopover\'s full-screen dismiss barrier '
        'would take the pointer off the trigger and the card would close '
        'and reopen forever.',
    child: ElPanel(
      label: 'Hover Card',
      child: DocsSelectableCodeBlock(code: _hoverCardCompositionCode),
    ),
  );

  Widget _triggerDelays() => ElSection(
    id: 'trigger-delays',
    title: 'Trigger Delays',
    description:
        'openDelay (default 700ms, ElDurations.hoverCardOpenDelay: Radix\'s '
        'own default) is how long the pointer must rest on the trigger '
        'before the card opens. closeDelay (default 300ms, '
        'ElDurations.hoverCardCloseDelay) is the window in which the '
        'pointer can cross the gap into the card itself before it closes.',
    child: const DocsCodeExample(
      title: 'Default delays',
      preview: _HoverCardSpecimen(specimenKey: 'hover-card-delays-specimen'),
    ),
  );

  Widget _basic() => ElSection(
    id: 'basic',
    title: 'Basic',
    description:
        'The same specimen shown at the top of this page, mounted again '
        'under its own key: hover the trigger text to see the preview.',
    child: const DocsCodeExample(
      title: 'Basic hover card',
      preview: _HoverCardSpecimen(specimenKey: 'hover-card-basic-specimen'),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'hover_card_basic.dart', code: _hoverCardCode),
      ],
    ),
  );

  Widget _rtl() => ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'The card\'s content reads right-to-left. Placement is '
        'unaffected: ElHoverCard positions from the trigger\'s own box, '
        'which Directionality does not move.',
    child: const DocsCodeExample(
      title: 'Right-to-left hover card',
      preview: _HoverCardRtl(),
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(path: 'hover_card_rtl.dart', code: _hoverCardRtlCode),
      ],
    ),
  );

  Widget _api() => ElSection(
    id: 'api',
    title: 'API Reference',
    description:
        'Every constructor parameter ElHoverCard and ElHoverCardContent '
        'declare, plus the static layout helpers a width or offset falls '
        'back to.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-elhovercard'),
          child: const DocsApiTable(
            title: 'ElHoverCard',
            facts: _hoverCardApiFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elhovercard-static'),
          child: const DocsApiTable(
            title: 'ElHoverCard static helpers',
            facts: _hoverCardStaticFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elhovercardcontent'),
          child: const DocsApiTable(
            title: 'ElHoverCardContent',
            facts: _hoverCardContentApiFacts,
          ),
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description:
        'Read straight off _DsHoverCardState, not inferred: every timing '
        'cited is the real ElDurations token the source names.',
    child: const DocsStateMatrix(facts: _stateFacts),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _bullets(theme, <String>[
          'Pointer only: opens on pointer entry after openDelay, closes '
              'on pointer exit after closeDelay (the gap-crossing '
              'window). Never appears on touch.',
          'No focus: the card does not trap focus and cannot be focused '
              'itself; it is announcement-only. A screen reader must read '
              'the trigger to learn about the preview.',
          'No keyboard: the card cannot be opened from the keyboard.',
        ]),
        SizedBox(height: el(3)),
        ElNote(
          tone: ElNoteTone.error,
          title: 'A hover-only affordance is invisible on a phone',
          child: ElText(
            'Use a hover card for optional detail, not required content: '
            'do not put anything a touch user must read inside one.',
            ElType.small,
          ),
        ),
      ],
    ),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'Pointer entry and exit only, on every platform with a pointer. '
          'Completely hidden on touch: not just disabled, but unmounted '
          '(the OverlayPortal never shows).',
      'Placement comes from elPopoverPlacement\'s own collision handling '
          'near a viewport edge, the same algorithm the combobox and the '
          'date picker use, and snaps without transition when it flips.',
      'No breakpoint branching, and no dart:io Platform branch, anywhere '
          'in hover_card.dart.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: DocsInstallFacts(
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'None: unregistered',
          description:
              'ElHoverCard is in the package but has no manifest and '
              'cannot be installed through the CLI yet.',
        ),
        const DocsInstallFact(
          label: 'Primary dependency',
          value: 'elPopoverPlacement, ElPopoverSurface',
          description:
              'Composes the popover positioner and surface directly, not '
              'ElPopover itself: see Composition above for why.',
        ),
        const DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description: 'Pure widget composition; unmounted entirely on touch.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'example/test/components_docs/hover_card_test.dart',
          description:
              'This page\'s own three live specimens, section order, and '
              'API table coverage: 390x844 and 1440x900, both themes.',
        ),
      ],
    ),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'Surface: theme.popover fill, theme.popoverForeground text, via '
          'ElPopoverSurface, which also applies the ring and shadow '
          '(theme.foreground at 10% alpha).',
      'Animation: fade-in-0, zoom-in-95, and a slide-in-from-top-2 run '
          'through ElDurations.overlay (320ms) on ElCurves.out; the exit '
          'drops the slide.',
      'Every duration and curve is read live; nothing is a page-local '
          'constant.',
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
          value: hoverCardDoc.sourcePath,
          description:
              'Authoritative implementation: the truth this page '
              'was written from.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/hover_card_test.dart',
          description:
              'Covers this page: the article mounts, all three '
              'live specimens, the full API table, and both themes at two '
              'viewport widths.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/hover_card/page.dart',
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

/// This page mounts a hover card three times: the unheaded live demo,
/// Trigger Delays, and Basic. `specimenKey` gives each mount its own
/// [ValueKey] — a key baked into `build()` would collide across all three,
/// since the page renders as one continuous scroll.
class _HoverCardSpecimen extends StatelessWidget {
  const _HoverCardSpecimen({this.specimenKey = 'hover-card-specimen'});

  final String specimenKey;

  @override
  Widget build(BuildContext context) {
    return ElHoverCard(
      key: ValueKey<String>(specimenKey),
      trigger: ElText(
        'Hover here to see a preview',
        ElType.small,
        color: ElTheme.of(context).actionInk,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElText('Preview Title', ElType.section),
          SizedBox(height: el(1)),
          ElText(
            'This is a hover card: it opens on pointer entry and closes '
            'when the pointer leaves. Not available on touch.',
            ElType.small,
            color: ElTheme.of(context).mutedForeground,
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
      child: ElHoverCard(
        trigger: ElText(
          'مرر فوق هذا النص للمعاينة',
          ElType.small,
          color: ElTheme.of(context).actionInk,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElText('عنوان المعاينة', ElType.section),
            SizedBox(height: el(1)),
            ElText(
              'هذه بطاقة معاينة تظهر عند دخول المؤشر وتختفي عند خروجه.',
              ElType.small,
              color: ElTheme.of(context).mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}

const String _hoverCardCode = '''return ElHoverCard(
  trigger: const ElText('Hover to preview'),
  content: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      ElText('Card Title', ElType.section),
      SizedBox(height: el(1)),
      ElText(
        'A preview that opens on hover. Pointer-only: not on touch.',
        ElType.small,
      ),
    ],
  ),
);''';

const String _hoverCardCompositionCode = '''ElHoverCard(
  trigger: ...,                        // pointer entry opens the card
  content: ...,                        // laid out inside ElHoverCardContent
)''';

const String _hoverCardRtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ElHoverCard(
    trigger: const ElText('مرر فوق هذا النص للمعاينة'),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElText('عنوان المعاينة', ElType.section),
        SizedBox(height: el(1)),
        ElText(
          'هذه بطاقة معاينة تظهر عند دخول المؤشر وتختفي عند خروجه.',
          ElType.small,
        ),
      ],
    ),
  ),
)''';

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
        'ElHoverCardContent\'s own padding.',
  ),
  DocsApiFact(
    name: 'width',
    type: 'double?',
    description:
        'Optional. Defaults to null, which falls back to '
        'ElHoverCard.defaultWidth (288, w-72). A literal width, not a '
        'max-width.',
  ),
  DocsApiFact(
    name: 'openDelay',
    type: 'Duration',
    description:
        'Optional. Defaults to ElDurations.hoverCardOpenDelay (700ms: '
        'Radix HoverCard\'s own openDelay default). How long the pointer '
        'must rest on the trigger before the card opens.',
  ),
  DocsApiFact(
    name: 'closeDelay',
    type: 'Duration',
    description:
        'Optional. Defaults to ElDurations.hoverCardCloseDelay (300ms). '
        'How long the card stays open after the pointer leaves: the '
        'gap-crossing window.',
  ),
];

const List<DocsApiFact> _hoverCardStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElHoverCard.defaultWidth',
    type: 'static double',
    description:
        '288 (w-72): what width falls back to when null. The '
        'component\'s own w-64 (256) default is never rendered anywhere '
        'in this port and is not what null resolves to.',
  ),
  DocsApiFact(
    name: 'ElHoverCard.sideOffset',
    type: 'static double',
    description: 'Gap between the trigger and the card: 4px.',
  ),
  DocsApiFact(
    name: 'ElHoverCard.slide',
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
        '(ElDurations.hoverCardOpenDelay). Nothing is visible until it '
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
        'ElDurations.overlay (320ms) on ElCurves.out.',
    userSignal: 'The card fades, zooms, and slides in from above.',
  ),
  DocsStateFact(
    state: 'Closing',
    treatment:
        'The pointer leaving either the trigger or the card starts a '
        '300ms closeDelay timer (ElDurations.hoverCardCloseDelay). '
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
    treatment: 'ElHoverCard carries no disable parameter.',
    userSignal: 'N/A.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'The open/close animation routes through elAnimationDuration, '
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
