/// Public documentation page for the `carousel` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `Section`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button`, `field`, `table`, `stat`
/// and `calendar` established. Every specimen widget and every code string
/// below is the one the hand-composed page carried; only where it lives
/// changed, plus a new required Keyboard disclosure — split out of the old
/// Accessibility bullet list, which already named the real ArrowLeft/
/// ArrowRight handling — and the live demo, which used to render ahead of
/// any heading, is now this page's own `Preview` section.
///
/// **`carousel` ships a real registry manifest.** `registry/components/
/// carousel.json` exists (`registryDependencies: [button, icon,
/// source-foundation]`), so `elattar add carousel` installs today. The
/// previous version of this page said the opposite — "carousel has no
/// registry/components/carousel.json yet" — which was wrong; every
/// install-facing fact below reads off the shipped manifest instead.
///
/// **Shaped to the reference page.** Reader-facing order: Preview, then
/// Installation, Usage, How the motion works, Composition, Sizes, RTL,
/// Not ported, then the eight required disclosures. Inside
/// the component-specific zone the section names mirror
/// https://ui.shadcn.com/docs/components/base/carousel, whose own headings
/// (fetched 2026-08-24) are: About, Installation, Usage, Composition, Sizes,
/// Spacing, Orientation, Options, API, Events, Plugins, RTL, API Reference.
///
/// **Skipped, honestly.** Six of those thirteen describe a capability this
/// port does not have. None of them is faked as a section, and none of them
/// is quietly dropped either: the "Not ported" disclosure
/// names all six, and here they are again with their causes.
/// * Spacing: shadcn's section tunes the inter-item gutter with `pl-[VALUE]`
///   on the item and a matching negative `-ml-[VALUE]` on the content.
///   `carousel.dart`'s gutter is a private file-level getter, `_gutter`, and
///   `Carousel`'s constructor exposes no parameter that reaches it. One
///   gutter, the same on every carousel.
/// * Orientation: shadcn takes an `orientation` prop and switches to a
///   vertical track. `_Track` builds a `Row` unconditionally and the engine's
///   drag handlers are `onHorizontalDrag*` only. There is no vertical path to
///   demonstrate.
/// * Options: shadcn forwards an `opts` object straight into Embla (`align`,
///   `loop`, `duration`, and the rest). Every one of this port's engine
///   constants is a private file-level `const`: `_baseDuration`, `_friction`,
///   `_edgeOffsetTolerance`, `_pullBackThreshold`. Nothing is a knob.
/// * API state-tracking: shadcn's `setApi` hands the caller the live carousel
///   instance so it can render "slide 3 of 6". `CarouselController` IS
///   barrel-exported, but it is not attachable from outside: `Carousel`'s
///   constructor takes `basis`, `items`, `padding`, `previousLabel`, and
///   `nextLabel`, and no `controller`. `_DsCarouselState` builds its own
///   instance and never publishes it. That missing constructor parameter is
///   the root cause of this skip and of the next one.
/// * Events: shadcn subscribes with `api.on("select", …)`. Same root cause:
///   `CarouselController` is a `ChangeNotifier` and does call
///   `notifyListeners`, so the notifications exist, but with no `controller`
///   parameter on `Carousel` there is no way to reach the instance and add
///   a listener to it.
/// * Plugins: shadcn's section adds Embla plugins through a `plugins` prop,
///   Autoplay being its example. This port has no plugin surface of any
///   kind, and no autoplay: there is no `Timer` and no self-advancing loop
///   anywhere in `carousel.dart`.
///
/// [ComponentDocEntry.description] is the page's only hero text. No second,
/// longer paragraph renders beneath it.
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
import 'meta.dart';

final ComponentDocSpec carouselDocSpec = ComponentDocSpec(
  name: 'carousel',
  title: carouselDoc.title,
  description: carouselDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Five slides at 40% of the track each. Drag it, click either '
          'arrow, or focus it and press ArrowLeft / ArrowRight.',
      specimen: const _CarouselPreview(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: space(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'carousel ships a real registry manifest: `elattar add '
          'carousel` installs lib/src/components/ui/carousel.dart and '
          'resolves button, icon, and source-foundation automatically. '
          'The Manual tab is for a project not using the CLI.',
      command: carouselDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/carousel.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/carousel.dart's generated "
              '@ui/carousel.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated carousel source here when using '
              'manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so Carousel and CarouselController '
              'are reachable the same way the CLI path already makes them.',
          code: "export 'carousel.dart';",
        ),
      ],
    ),
    const SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction. Every example '
          'below only changes named arguments on top of this.',
      code: _usageCode,
    ),
    const SnippetSection(
      id: 'motion',
      title: 'How the motion works',
      description:
          "shadcn's carousel is a wrapper around the Embla Carousel JS "
          'library. This one is not a wrapper around anything: it is a '
          "from-scratch reimplementation of Embla's own physics in Dart, "
          'measured frame by frame off the reference page and reproduced '
          'to within a hundredth of a pixel over the first ten frames. '
          'Nothing further to stage live beyond what Preview already '
          'demonstrates, so this stays a code-only note rather than a '
          'second copy of the same specimen.',
      code: _motionCode,
    ),
    ShowcaseSection(
      id: 'composition',
      title: 'Composition',
      description:
          "shadcn's Composition section nests CarouselContent, "
          'CarouselItem, CarouselPrevious, and CarouselNext inside a '
          'Carousel wrapper. Carousel folds all four into one widget: '
          'hand it items and basis and it returns a clipped track with '
          'both arrows already wired to the engine. The one thing a '
          'caller still owns is the frame padding, and it matters, '
          'because the arrows are laid out outside the track: pass the '
          "surrounding frame's own padding to the carousel and clip the "
          'frame itself, or its own overflow eats every pixel of both '
          'arrows but the sliver survives clipping too, exactly as '
          "shadcn's page measures.",
      specimen: const _CompositionSpecimen(),
      code: _compositionCode,
      label: 'Composition specimen view',
      minHeight: space(160),
    ),
    ShowcaseSection(
      id: 'sizes',
      title: 'Sizes',
      description:
          "shadcn sets item width with basis-* utility classes on "
          'CarouselItem, including responsive variants. Here basis is a '
          "single double: the item's share of the track, 0.5 for two at "
          'once, 0.333 for three. There is no responsive form. One value '
          'applies at every width, so a caller that wants it to change at '
          'a breakpoint has to swap the value itself.',
      specimen: const _SizesSpecimen(),
      code: _sizesCode,
      label: 'Sizes specimen view',
      minHeight: space(160),
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          "shadcn's RTL section sets Embla's direction option and rotates "
          'the arrow buttons to match. DOCUMENTED DRIFT: this port does '
          'neither. The track is a plain Row, which reads Directionality '
          "and reverses its children's paint order, but the arrows are "
          'Positioned(left:, right:) and the drag math is in physical '
          'pixels, so neither one flips. Wrapped in Directionality.rtl '
          'below the result is inconsistent rather than mirrored: slide '
          'order reverses, the controls do not.',
      specimen: const _RtlSpecimen(),
      code: _rtlCode,
      label: 'RTL specimen view',
      minHeight: space(160),
    ),
    DisclosureSection(
      id: 'not-ported',
      title: 'Not ported',
      description:
          "Six of the reference page's thirteen headings describe a "
          'capability Carousel does not have. None of them is faked '
          'below, and two of them share one root cause.',
      child: _NotPortedContent(),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter and public member, read straight '
          'off lib/src/components/ui/carousel.dart. Private engine constants '
          'and the private _Track / _Arrow widgets are not part of the '
          'API and are not listed.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'Carousel', anchor: 'api-elcarousel'),
        DocsTocEntry(
          title: 'CarouselController',
          anchor: 'api-elcarouselcontroller',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off CarouselController._step, _constrain, and dragEnd, '
          'not inferred.',
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
      description:
          "Read off _CarouselState._onKey: the region's own Focus "
          'wraps the track and both arrows, and answers exactly two keys.',
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
            value: carouselDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from, including its own measured library note.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'none yet',
            description: 'No dedicated carousel test in the package suite yet.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/carousel_test.dart',
            description:
                'Covers this page: the article mounts, the section order, '
                'both API tables, the live specimens, and a theme flip at '
                'two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/carousel/page.dart',
            description: 'This file.',
          ),
          const DocsInstallFact(
            label: 'Split from this page',
            value: 'user_menu, marker',
            description:
                'UserMenu and Marker used to be documented here. They '
                'now live at example/lib/components_docs/user_menu/page.dart '
                'and example/lib/components_docs/marker/page.dart.',
          ),
        ],
      ),
    ),
  ],
);

class CarouselDocPage extends StatelessWidget {
  const CarouselDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: carouselDoc.route,
    intro: DocsPageIntro(
      title: carouselDoc.title,
      description: carouselDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Carousel'),
    ],
    toc: carouselDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Calendar',
      route: '/components/calendar',
    ),
    next: const DocsPageLink(title: 'Checkbox', route: '/components/checkbox'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('carousel-doc-article'),
      child: ComponentDocPage(spec: carouselDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _CarouselPreview extends StatelessWidget {
  const _CarouselPreview();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('carousel-preview'),
    child: Carousel(
      basis: 0.4,
      padding: EdgeInsets.all(space(6)),
      items: <Widget>[
        for (int i = 0; i < 5; i++) _DummySlide(label: 'Slide ${i + 1}'),
      ],
    ),
  );
}

const String _previewCode = '''Carousel(
  basis: 0.4,
  padding: EdgeInsets.all(space(6)),
  items: <Widget>[
    for (int i = 0; i < 5; i++)
      SomeCard(title: 'Slide \${i + 1}'),
  ],
)''';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

Carousel(
  basis: 0.4,
  items: <Widget>[
    for (int i = 0; i < 5; i++)
      SomeCard(title: 'Slide \${i + 1}'),
  ],
)''';

const String _motionCode = '''
// The glide is an integrator, not a curve. Each fixed 1/60s step does
//   velocity = (velocity + (target - location) / 25) * 0.68
//   location += velocity
// There is no easing curve to name and no end time: it asymptotes, and the
// next click retargets from wherever it currently is. That 25 is Embla's own
// duration option used as a divisor, and 0.68 its internal friction.
//
// Dragging is 1:1 in bounds. On pointer down the engine sets its own
// duration to zero, so the track tracks the pointer exactly while the drag
// lasts.
//
// Past either edge it rubber-bands. Embla's ScrollBounds pulls the target
// back toward the location each frame by
//   clamp(distancePastEdge / (viewport * 50%), 0.1, 0.99)
// so the resistance is not a fixed ratio: it grows the further you pull.
//
// Release snaps to the nearest stop, in either direction. No velocity
// projection is involved: measured, the nearest snap is always where it
// lands.
//
// The snap ladder is trimmed (containScroll: "trimSnaps"). Every slide start
// is clamped into the scrollable range, so the last few collapse into one
// final stop and canScrollNext goes false there rather than at the last
// slide index.
//
// Reduced motion has no duration to zero, because the engine is an
// integrator. MediaQuery.disableAnimations instead makes it land on the
// target in one call, which is what a zeroed transition does everywhere
// else in this port.
''';

/// A themed, clipped frame around one carousel: the minimum a caller needs
/// to reproduce the "hand the frame's own padding to the carousel, and clip
/// the frame" recipe Composition documents. Built from theme tokens rather
/// than a literal, so the border, fill and radius all move with the theme
/// the same way a real panel's would.
class _FlushFrame extends StatelessWidget {
  const _FlushFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(Radii.xl),
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Radii.xl),
        child: child,
      ),
    );
  }
}

class _CompositionSpecimen extends StatelessWidget {
  const _CompositionSpecimen();

  @override
  Widget build(BuildContext context) => _FlushFrame(
    child: KeyedSubtree(
      key: const ValueKey<String>('carousel-example:in-panel'),
      child: Carousel(
        basis: 0.4,
        padding: EdgeInsets.all(space(6)),
        items: <Widget>[
          for (int i = 0; i < 5; i++) _DummySlide(label: 'Slide ${i + 1}'),
        ],
      ),
    ),
  );
}

const String _compositionCode = '''Carousel(
  basis: 0.4,                      // the item's share of the track
  padding: EdgeInsets.all(space(6)),  // frame padding, so the arrows can hang out
  items: <Widget>[...],            // bare slide content, gutter-padded inside
  previousLabel: 'Previous slide', // the sr-only name on the left arrow
  nextLabel: 'Next slide',
)

// Give the surrounding frame the same padding and clip it, so its own edge
// (not a second layer of padding) is what the arrows' 24px sliver survives
// against.
DecoratedBox(
  decoration: BoxDecoration(/* theme.card, theme.border, Radii.xl */),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(Radii.xl),
    child: Carousel(...),
  ),
)''';

class _SizesSpecimen extends StatelessWidget {
  const _SizesSpecimen();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      StyledText('basis: 0.5, two per view', TextStyles.section),
      SizedBox(height: space(3)),
      KeyedSubtree(
        key: const ValueKey<String>('carousel-example:basis-half'),
        child: Carousel(
          basis: 0.5,
          padding: EdgeInsets.all(space(6)),
          items: <Widget>[
            for (int i = 0; i < 5; i++) _DummySlide(label: 'Slide ${i + 1}'),
          ],
        ),
      ),
      SizedBox(height: space(6)),
      StyledText('basis: 0.333, three per view', TextStyles.section),
      SizedBox(height: space(3)),
      KeyedSubtree(
        key: const ValueKey<String>('carousel-example:basis-third'),
        child: Carousel(
          basis: 0.333,
          padding: EdgeInsets.all(space(6)),
          items: <Widget>[
            for (int i = 0; i < 5; i++) _DummySlide(label: 'Slide ${i + 1}'),
          ],
        ),
      ),
    ],
  );
}

const String _sizesCode = '''Carousel(
  basis: 0.5, // two visible at once
  items: <Widget>[...],
)

Carousel(
  basis: 0.333, // three visible at once
  items: <Widget>[...],
)''';

class _RtlSpecimen extends StatelessWidget {
  const _RtlSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('carousel-example:rtl'),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: Carousel(
        basis: 0.4,
        padding: EdgeInsets.all(space(6)),
        items: <Widget>[
          for (int i = 0; i < 5; i++) _DummySlide(label: 'Slide ${i + 1}'),
        ],
      ),
    ),
  );
}

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: Carousel(
    basis: 0.4,
    items: <Widget>[...],
  ),
)''';

class _DummySlide extends StatelessWidget {
  const _DummySlide({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.secondary,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Center(child: StyledText(label, TextStyles.body)),
    );
  }
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _NotPortedContent extends StatelessWidget {
  const _NotPortedContent();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'Skipped sections',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'Spacing',
              type: 'no parameter',
              description:
                  'The inter-item gutter is a private file-level getter, '
                  '_gutter, and no constructor parameter reaches it. One '
                  'gutter, the same on every carousel.',
            ),
            DocsApiFact(
              name: 'Orientation',
              type: 'horizontal only',
              description:
                  '_Track builds a Row unconditionally and the engine '
                  'only listens for onHorizontalDrag*. There is no '
                  'vertical path and no orientation parameter.',
            ),
            DocsApiFact(
              name: 'Options',
              type: 'private consts',
              description:
                  'Every engine constant (_baseDuration, _friction, '
                  '_edgeOffsetTolerance, _pullBackThreshold) is a private '
                  'file-level const. There is no opts equivalent: nothing '
                  'is a knob.',
            ),
            DocsApiFact(
              name: 'API state-tracking',
              type: 'no controller parameter',
              description:
                  'CarouselController IS barrel-exported, but it is '
                  "not attachable from outside: Carousel's constructor "
                  'has no controller parameter, so nothing can read '
                  'selectedIndex to render "slide 3 of 6".',
            ),
            DocsApiFact(
              name: 'Events',
              type: 'no controller parameter',
              description:
                  'Same root cause. CarouselController is a '
                  'ChangeNotifier and does call notifyListeners, so the '
                  'notifications exist, but with no controller parameter '
                  'there is no way to reach the instance and add a '
                  'listener.',
            ),
            DocsApiFact(
              name: 'Plugins',
              type: 'no plugin surface',
              description:
                  'No plugin mechanism of any kind, and no autoplay: '
                  'carousel.dart contains no Timer and no self-advancing '
                  'loop, so there is nothing to pause either.',
            ),
          ],
        ),
        SizedBox(height: space(4)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
          child: StyledText(
            'API state-tracking and Events are both the same missing '
            'parameter, not two independent gaps. Adding a controller '
            'argument to Carousel would close both at once; until then '
            'neither is available, and this page does not pretend '
            'otherwise.',
            TextStyles.small,
            color: theme.mutedForeground,
          ),
        ),
      ],
    );
  }
}

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsAnchor(
          id: 'api-elcarousel',
          child: DocsApiTable(title: 'Carousel', facts: _carouselFacts),
        ),
        SizedBox(height: space(6)),
        const DocsAnchor(
          id: 'api-elcarouselcontroller',
          child: DocsApiTable(
            title: 'CarouselController',
            facts: _controllerFacts,
          ),
        ),
        SizedBox(height: space(4)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
          child: StyledText(
            'Carousel builds this controller internally: the '
            'constructor above has no controller parameter. Nothing '
            'outside Carousel can read selectedIndex, canScrollPrev, '
            'or canScrollNext, or add its own listener, today.',
            TextStyles.small,
            color: theme.mutedForeground,
          ),
        ),
      ],
    );
  }
}

const List<DocsApiFact> _carouselFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'basis',
    type: 'double',
    description:
        "Required. The item's share of the TRACK, which is the viewport "
        'plus one gutter: 0.5 for two visible at once, 0.333 for three.',
  ),
  DocsApiFact(
    name: 'items',
    type: 'List<Widget>',
    description:
        "Required. One CarouselItem's content each. The gutter padding "
        'is applied around each one internally; the caller passes bare '
        'content.',
  ),
  DocsApiFact(
    name: 'padding',
    type: 'EdgeInsets',
    description:
        'Optional. Defaults to EdgeInsets.zero. The frame padding this '
        'carousel applies for itself, moved inside so the arrows can '
        "hang out of it: pass the surrounding frame's own padding and "
        'clip the frame itself.',
  ),
  DocsApiFact(
    name: 'previousLabel',
    type: 'String',
    description:
        "Optional. Defaults to 'Previous slide'. The accessible name on "
        "the previous arrow: the reference's own sr-only span.",
  ),
  DocsApiFact(
    name: 'nextLabel',
    type: 'String',
    description:
        "Optional. Defaults to 'Next slide'. The accessible name on the "
        'next arrow.',
  ),
];

const List<DocsApiFact> _controllerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'CarouselController({vsync})',
    type: 'TickerProvider?',
    description:
        'The only constructor parameter, and optional. Null means '
        'headless: every move lands on its target in one call instead '
        'of ticking, which is the path a disableAnimations test takes. '
        'Carousel always passes its own State as the vsync.',
  ),
  DocsApiFact(
    name: 'instant',
    type: 'bool (mutable field)',
    description:
        'Defaults to false. The reduced-motion switch, pushed down by '
        'Carousel every build from '
        'MediaQuery.maybeDisableAnimationsOf. True makes the engine land '
        'on the target instead of integrating toward it.',
  ),
  DocsApiFact(
    name: 'location',
    type: 'double (read-only)',
    description:
        "The track's translate in pixels: zero at the first slide, "
        'negative onwards.',
  ),
  DocsApiFact(
    name: 'selectedIndex',
    type: 'int (read-only)',
    description: "api.selectedScrollSnap(): the resting snap's index.",
  ),
  DocsApiFact(
    name: 'canScrollPrev',
    type: 'bool (read-only)',
    description:
        'api.canScrollPrev(). False at index 0, which is what disables '
        'the previous arrow.',
  ),
  DocsApiFact(
    name: 'canScrollNext',
    type: 'bool (read-only)',
    description:
        'api.canScrollNext(). False at the last TRIMMED snap, which is '
        'earlier than the last slide index whenever trimming collapsed '
        'stops.',
  ),
  DocsApiFact(
    name: 'snaps',
    type: 'List<double> (read-only)',
    description:
        'Every stop the carousel can rest at, trimmed: each slide start '
        'negated, clamped into the scrollable range, and collapsed '
        'where clamping made neighbours equal.',
  ),
  DocsApiFact(
    name: 'setMetrics({viewSize, slideSizes})',
    type: 'void',
    description:
        'Handed the measured geometry after every layout: rebuilds the '
        'snap ladder, clamps the index, and parks the location on it. '
        '_Track calls this from a post-frame callback.',
  ),
  DocsApiFact(
    name: 'scrollTo(int index)',
    type: 'void',
    description:
        'api.scrollTo(index). Clamps into the snap range and retargets '
        'from wherever the track currently is.',
  ),
  DocsApiFact(
    name: 'scrollPrev()',
    type: 'void',
    description:
        'api.scrollPrev(): scrollTo(index - 1). What the left arrow and '
        'ArrowLeft both call.',
  ),
  DocsApiFact(
    name: 'scrollNext()',
    type: 'void',
    description: 'api.scrollNext(): scrollTo(index + 1).',
  ),
  DocsApiFact(
    name: 'dragStart(double pointerX)',
    type: 'void',
    description:
        "Pointer down: zeroes the engine's own duration so tracking is "
        '1:1, and remembers the start location and pointer.',
  ),
  DocsApiFact(
    name: 'dragUpdate(double pointerX)',
    type: 'void',
    description:
        'Writes a new target from the pointer delta. Ignored when no '
        'drag is in progress.',
  ),
  DocsApiFact(
    name: 'dragEnd()',
    type: 'void',
    description:
        'Release: restores the duration, picks the NEAREST snap in '
        'either direction, and targets it. No velocity projection.',
  ),
  DocsApiFact(
    name: 'dispose()',
    type: 'void',
    description:
        'Disposes the ticker. Carousel disposes its own instance; a '
        'caller building one by hand owns that.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'Location equals target and velocity is under a thousandth of '
        'a pixel, so the ticker stops itself. The track sits on a '
        'trimmed snap.',
    userSignal: 'A still track, with one arrow possibly disabled.',
  ),
  DocsStateFact(
    state: 'Gliding',
    treatment:
        'The integrator runs on a fixed 1/60s step, carrying leftover '
        'frame time forward, and asymptotes toward the target. A second '
        'click retargets mid-glide rather than queueing.',
    userSignal: 'Smooth deceleration with no perceptible end frame.',
  ),
  DocsStateFact(
    state: 'Dragging',
    treatment:
        "Duration is zero for the whole drag, so the target and the "
        'location both follow the pointer exactly while it stays inside '
        'the limits.',
    userSignal: 'The track sticks to the finger or cursor.',
  ),
  DocsStateFact(
    state: 'Past an edge',
    treatment:
        "ScrollBounds pulls the target back each frame by "
        'clamp(distancePastEdge / (viewport * 50%), 0.1, 0.99): '
        'resistance that grows with distance rather than a fixed ratio.',
    userSignal: 'A rubber band that stiffens the further it is pulled.',
  ),
  DocsStateFact(
    state: 'Released',
    treatment:
        'The nearest snap becomes the index and the target, in either '
        'direction, then the integrator takes it from there.',
    userSignal: 'A settle onto the closest stop, never a fling past it.',
  ),
  DocsStateFact(
    state: 'At either end',
    treatment:
        'canScrollPrev is false at index 0 and canScrollNext is false '
        'at the last trimmed snap; each arrow rebuilds through an '
        'AnimatedBuilder and passes a null onPressed there.',
    userSignal: 'A faded, inert arrow, courtesy of Button.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'MediaQuery.disableAnimations sets controller.instant, and '
        'every move lands on its target in one call. There is no '
        'Duration to zero here, because the engine is an integrator.',
    userSignal: 'Instant jumps between stops, no glide.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Previous and next controls are real focusable Button widgets '
            '(outline variant, iconSm) carrying semantic labels: '
            'previousLabel and nextLabel, defaulting to "Previous slide" '
            'and "Next slide".',
        'Button state: previous is disabled at index 0 (canScrollPrev), '
            'next is disabled at the last trimmed snap (canScrollNext), '
            'and each one rebuilds off the controller through an '
            'AnimatedBuilder.',
        'Region label: the whole carousel is one Semantics container '
            'labelled "carousel", which is a generic name and not '
            'configurable.',
        'Known gap: no slide-position announcement. Nothing reports the '
            'current index or the total count, and there is no live '
            'region, so a screen-reader user hears no confirmation that '
            'an arrow press moved anything.',
        'Autoplay: none exists in the source, so no pause control is '
            'needed and none is provided. See Keyboard for the region\'s '
            'own key handling.',
      ]);
}

/// Read directly off `_CarouselState._onKey` (`lib/src/components/ui/
/// carousel.dart`): the region's Focus wraps the track and both arrows and
/// answers exactly two keys, whatever a surrounding frame does to the
/// arrows themselves.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'ArrowLeft: calls controller.scrollPrev(), the same call the '
            'previous arrow makes. Handled on both KeyDownEvent and '
            'KeyRepeatEvent, so holding the key repeats the call.',
        'ArrowRight: calls controller.scrollNext(), on both KeyDownEvent '
            'and KeyRepeatEvent as well.',
        'No other key is handled: onKeyEvent returns '
            'KeyEventResult.ignored for everything else, including '
            'Enter, Space, Home, and End.',
        'This is the path that always works: onKeyDownCapture sits on '
            'the whole region, so it reaches the engine regardless of '
            'what a surrounding frame does to the arrow buttons '
            "themselves — see Composition for the arrows' own clipping "
            'story.',
        'The two arrows are real focusable Button widgets in the tab '
            'order beside the region; each still answers Enter/Space '
            'through its own Button behaviour, independent of the '
            "region's ArrowLeft/ArrowRight handling.",
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching in carousel.dart. A LayoutBuilder reads '
            'the incoming width, but only to measure the track and hand '
            'the engine its metrics, never to choose a different '
            'structure.',
        'Item width follows the container: basis is a fraction of the '
            'track, so the same basis gives narrower slides at 390px '
            'than at 1440px. Changing the column count between '
            "breakpoints is the caller's job, since basis takes one "
            'value.',
        'The snap ladder re-measures on layout: setMetrics recomputes '
            'the trimmed snaps and clamps the current index whenever the '
            'container or content size changes, so a resize does not '
            'leave the track parked between stops.',
        'Arrow overhang is width-independent: each arrow reaches space(12) '
            'outside the track, paid for out of padding where padding '
            'exists and overflowing where it does not.',
        'Platform parity: Android, iOS, Web, macOS, Windows, and Linux '
            'all render the same tree, and drag and keyboard both '
            'behave identically. There is no dart:io Platform branch in '
            'the file.',
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
            value: 'carousel',
            description:
                'registry/components/carousel.json exists and is '
                'installable through the CLI today.',
          ),
          const DocsInstallFact(
            label: 'Destination',
            value: 'lib/components/ui/carousel.dart',
            description:
                'The same lib/components/ui/ target every component '
                'installs to.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: carouselDoc.dependencies.join(', '),
            description:
                "The manifest's registryDependencies, resolved "
                'automatically by the registry client, matching '
                "carousel.dart's own imports: foundation/spacing.dart "
                '(space()), button.dart (the two arrows), and icon.dart / '
                'icon_paths.g.dart (their chevron glyphs). No colour, '
                'shadow, or typography token is read directly: the '
                'arrows get all of theirs from Button.',
          ),
          const DocsInstallFact(
            label: 'Assets',
            value: 'none',
            description: 'No images, icon fonts, or binary assets.',
          ),
          const DocsInstallFact(
            label: 'Shaders',
            value: 'none',
            description: 'No fragment-shader-backed paint anywhere.',
          ),
          const DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description:
                'No platform-conditional code anywhere in carousel.dart.',
          ),
          const DocsInstallFact(
            label: 'Verified',
            value: 'docs specimens only',
            description:
                "This page's live specimens and "
                'example/test/components_docs/carousel_test.dart. No '
                'dedicated package-level unit test exists yet.',
          ),
        ],
      ),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Icon', route: '/components/icon'),
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
        'carousel.dart reads no colour token of its own. Both arrows '
            'are Button(variant: outline, size: iconSm), so fill, '
            'border, ink, shadow, and focus ring all resolve inside '
            'Button off ThemeScope.of(context) at build time.',
        'Their glyphs are Icon.lucide with tone: IconTone.inherit, '
            "so the chevrons take the button's own resolved ink rather "
            'than declaring a colour.',
        'Flipping ThemeController re-resolves both arrows on the next '
            'frame. The slides themselves are caller-supplied widgets '
            'and theme however the caller built them.',
        'Geometry is not themeable: the gutter (space(4)) and the arrow '
            'reach (space(12)) are file-level getters over the 4px grid, '
            'and no theme value moves them.',
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
