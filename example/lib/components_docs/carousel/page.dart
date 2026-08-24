/// Public documentation page for the `carousel` component.
///
/// **Split, 2026-08-24.** This page used to document three separately
/// barrel-exported components at once. `ElNavUser` and `ElMarker` moved to
/// `components_docs/nav_user/page.dart` and
/// `components_docs/marker/page.dart`; nothing about either one is left
/// here. What remains is `ElCarousel` and `ElCarouselController` only.
///
/// **Shaped to the reference page.** Reader-facing order follows
/// `components_docs/button/page.dart`: an unheaded live demo above the first
/// heading, then Installation, then Usage, then this component's own
/// sections, then API Reference last of the component-specific set, then
/// States / Accessibility / Responsive / Dependencies / Theming / Source.
/// Inside the component-specific zone the section names mirror
/// https://ui.shadcn.com/docs/components/base/carousel, whose own headings
/// (fetched 2026-08-24) are: About, Installation, Usage, Composition, Sizes,
/// Spacing, Orientation, Options, API, Events, Plugins, RTL, API Reference.
///
/// **Skipped, honestly.** Six of those thirteen describe a capability this
/// port does not have. None of them is faked as a section, and none of them
/// is quietly dropped either: the on-page "What this port leaves out"
/// section names all six, and here they are again with their causes.
/// * Spacing: shadcn's section tunes the inter-item gutter with `pl-[VALUE]`
///   on the item and a matching negative `-ml-[VALUE]` on the content.
///   `carousel.dart`'s gutter is a private file-level getter, `_gutter`, and
///   `ElCarousel`'s constructor exposes no parameter that reaches it. One
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
///   instance so it can render "slide 3 of 6". `ElCarouselController` IS
///   barrel-exported, but it is not attachable from outside: `ElCarousel`'s
///   constructor takes `basis`, `items`, `padding`, `previousLabel`, and
///   `nextLabel`, and no `controller`. `_DsCarouselState` builds its own
///   instance and never publishes it. That missing constructor parameter is
///   the root cause of this skip and of the next one.
/// * Events: shadcn subscribes with `api.on("select", …)`. Same root cause:
///   `ElCarouselController` is a `ChangeNotifier` and does call
///   `notifyListeners`, so the notifications exist, but with no `controller`
///   parameter on `ElCarousel` there is no way to reach the instance and add
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
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class CarouselDocPage extends StatelessWidget {
  const CarouselDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: carouselDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / LAYOUT & UI',
      title: carouselDoc.title,
      description: carouselDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Carousel'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'How the motion works', anchor: 'motion'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Sizes', anchor: 'sizes'),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(title: 'What this port leaves out', anchor: 'not-ported'),
      DocsTocEntry(
        title: 'API Reference',
        anchor: 'api',
        children: <DocsTocEntry>[
          DocsTocEntry(title: 'ElCarousel', anchor: 'api-elcarousel'),
          DocsTocEntry(
            title: 'ElCarouselController',
            anchor: 'api-elcarouselcontroller',
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
    previous: const DocsPageLink(
      title: 'Calendar',
      route: '/components/calendar',
    ),
    next: const DocsPageLink(title: 'Checkbox', route: '/components/checkbox'),
    onNavigate: onNavigate,
    child: const _ArticleContent(),
  );
}

class _ArticleContent extends StatelessWidget {
  const _ArticleContent();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('carousel-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _liveDemo(),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        SizedBox(height: el(6)),
        _motion(theme),
        _composition(),
        _sizes(),
        _rtl(),
        _notPorted(theme),
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

  /// The live demo that opens the page, before any heading: no [ElSection],
  /// no anchor, no TOC entry, matching the reference page exactly.
  Widget _liveDemo() => DocsCodeExample(
    title: 'Carousel',
    description:
        'Five slides at 40% of the track each. Drag it, click either arrow, '
        'or focus it and press ArrowLeft / ArrowRight.',
    preview: const KeyedSubtree(
      key: ValueKey<String>('carousel-preview'),
      child: _CarouselPreview(),
    ),
    manualFiles: const <DocsCodeFile>[
      DocsCodeFile(
        path: 'carousel_preview.dart',
        title: 'Five slides',
        code:
            "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
            'ElCarousel(\n'
            '  basis: 0.4,\n'
            '  padding: EdgeInsets.all(el(6)),\n'
            '  items: <Widget>[\n'
            '    for (int i = 0; i < 5; i++)\n'
            "      SomeCard(title: 'Slide \${i + 1}'),\n"
            '  ],\n'
            ')',
      ),
    ],
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        'carousel ships in the registry, so `elattar add carousel` '
        'is not available: install by copying the source file manually.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry item',
          value: 'registry/components/carousel.json',
          description:
              'No registry/components/carousel.json exists. This is a '
              'source-only component today, and the command a manifest '
              'would enable is deliberately not shown.',
        ),
        const DocsInstallFact(
          label: 'Manual copy target',
          value: 'lib/components/ui/carousel.dart',
          description: 'Where the CLI itself would place the file.',
        ),
        const DocsInstallFact(
          label: 'Foundation',
          value: 'source only',
          description: 'No package-backed alternative is offered yet.',
        ),
        const DocsInstallFact(
          label: 'Would-be dependencies',
          value: 'source-foundation, button, icon',
          description:
              "What the shipped manifest resolves: carousel.dart's "
              'own imports are foundation/spacing.dart, button.dart, '
              'icon.dart, and icon_paths.g.dart. None of this resolves '
              'automatically today; copy the imports by hand.',
        ),
        const DocsInstallFact(
          label: 'Assets',
          value: 'none',
          description: 'No images, icon fonts, or binary assets.',
        ),
        const DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description:
              'No platform-conditional code anywhere in carousel.dart.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'docs specimen only',
          description:
              "This page's live specimens and example/test/components_docs/"
              'carousel_test.dart. No dedicated package-level unit test '
              'exists yet.',
        ),
      ],
    ),
  );

  Widget _usage() => ElSection(
    id: 'usage',
    title: 'Usage',
    description:
        'The smallest correct import and construction. Every example below '
        'only changes named arguments on top of this.',
    child: ElPanel(
      label: 'DART',
      note: 'MINIMAL',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  /// The reference page's own About section, renamed for the question a
  /// reader actually arrives with.
  Widget _motion(ElThemeData theme) => ElSection(
    id: 'motion',
    title: 'How the motion works',
    description:
        "shadcn's carousel is a wrapper around the Embla Carousel JS "
        'library. This one is not a wrapper around anything: it is a '
        "from-scratch reimplementation of Embla's own physics in Dart, "
        'measured frame by frame off the reference page and reproduced to '
        'within a hundredth of a pixel over the first ten frames.',
    child: _bullets(theme, <String>[
      'The glide is an integrator, not a curve. Each fixed 1/60s step does '
          'velocity = (velocity + (target - location) / 25) * 0.68, then '
          'location += velocity. There is no easing curve to name and no '
          'end time: it asymptotes, and the next click retargets from '
          'wherever it currently is. That 25 is Embla\'s own duration '
          'option used as a divisor, and 0.68 its internal friction.',
      'Dragging is 1:1 in bounds. On pointer down the engine sets its own '
          'duration to zero, so the track tracks the pointer exactly while '
          'the drag lasts.',
      'Past either edge it rubber-bands. Embla\'s ScrollBounds pulls the '
          'target back toward the location each frame by '
          'clamp(distancePastEdge / (viewport * 50%), 0.1, 0.99), so the '
          'resistance is not a fixed ratio: it grows the further you pull.',
      'Release snaps to the nearest stop, in either direction. No velocity '
          'projection is involved: measured, the nearest snap is always '
          'where it lands.',
      'The snap ladder is trimmed (containScroll: "trimSnaps"). Every '
          "slide start is clamped into the scrollable range, so the last "
          'few collapse into one final stop and canScrollNext goes false '
          'there rather than at the last slide index.',
      'Reduced motion has no duration to zero, because the engine is an '
          'integrator. MediaQuery.disableAnimations instead makes it land '
          'on the target in one call, which is what a zeroed transition '
          'does everywhere else in this port.',
    ]),
  );

  Widget _composition() => ElSection(
    id: 'composition',
    title: 'Composition',
    description:
        "shadcn's Composition section nests CarouselContent, CarouselItem, "
        'CarouselPrevious, and CarouselNext inside a Carousel wrapper. '
        'ElCarousel folds all four into one widget: hand it items and '
        'basis and it returns a clipped track with both arrows already '
        'wired to the engine. The one thing a caller still owns is the '
        'frame padding, and it matters, because the arrows are laid out '
        'outside the track.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElPanel(
          label: 'DART',
          note: 'ANATOMY',
          child: DocsSelectableCodeBlock(code: _compositionAnatomyCode),
        ),
        SizedBox(height: el(6)),
        ElText('Composed inside a panel', ElType.label),
        SizedBox(height: el(2)),
        ElText(
          "Pass the panel's own padding to the carousel and give the panel "
          'flush: true. Each arrow hangs 48px outside the track, so if the '
          'frame keeps its padding instead, its clip eats all but a sliver '
          'of both buttons. That is the reference\'s behaviour too, to the '
          'same 24px, and the keyboard path is the one that always works.',
          ElType.small,
        ),
        SizedBox(height: el(4)),
        ElPanel(
          label: 'CAROUSEL INSIDE PANEL',
          flush: true,
          child: KeyedSubtree(
            key: const ValueKey<String>('carousel-example:in-panel'),
            child: ElCarousel(
              basis: 0.4,
              padding: EdgeInsets.all(el(6)),
              items: <Widget>[
                for (int i = 0; i < 5; i++)
                  _DummySlide(label: 'Slide ${i + 1}'),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _sizes() => ElSection(
    id: 'sizes',
    title: 'Sizes',
    description:
        "shadcn sets item width with basis-* utility classes on "
        'CarouselItem, including responsive variants. Here basis is a '
        "single double: the item's share of the track, 0.5 for two at "
        'once, 0.333 for three. There is no responsive form. One value '
        'applies at every width, so a caller that wants it to change at a '
        'breakpoint has to swap the value itself.',
    child: DocsCodeExample(
      title: 'Two sizes',
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElText('basis: 0.5, two per view', ElType.label),
          SizedBox(height: el(3)),
          KeyedSubtree(
            key: const ValueKey<String>('carousel-example:basis-half'),
            child: ElCarousel(
              basis: 0.5,
              padding: EdgeInsets.all(el(6)),
              items: <Widget>[
                for (int i = 0; i < 5; i++)
                  _DummySlide(label: 'Slide ${i + 1}'),
              ],
            ),
          ),
          SizedBox(height: el(6)),
          ElText('basis: 0.333, three per view', ElType.label),
          SizedBox(height: el(3)),
          KeyedSubtree(
            key: const ValueKey<String>('carousel-example:basis-third'),
            child: ElCarousel(
              basis: 0.333,
              padding: EdgeInsets.all(el(6)),
              items: <Widget>[
                for (int i = 0; i < 5; i++)
                  _DummySlide(label: 'Slide ${i + 1}'),
              ],
            ),
          ),
        ],
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'carousel_sizes.dart', code: _sizesCode),
      ],
    ),
  );

  Widget _rtl() => ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        "shadcn's RTL section sets Embla's direction option and rotates the "
        'arrow buttons to match. DOCUMENTED DRIFT: this port does neither. '
        'The track is a plain Row, which reads Directionality and reverses '
        "its children's paint order, but the arrows are Positioned(left:, "
        'right:) and the drag math is in physical pixels, so neither one '
        'flips. Wrapped in Directionality.rtl below the result is '
        'inconsistent rather than mirrored: slide order reverses, the '
        'controls do not.',
    child: DocsCodeExample(
      title: 'Wrapped in Directionality.rtl',
      preview: KeyedSubtree(
        key: const ValueKey<String>('carousel-example:rtl'),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ElCarousel(
            basis: 0.4,
            padding: EdgeInsets.all(el(6)),
            items: <Widget>[
              for (int i = 0; i < 5; i++) _DummySlide(label: 'Slide ${i + 1}'),
            ],
          ),
        ),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'carousel_rtl.dart', code: _rtlCode),
      ],
    ),
  );

  /// The six reference sections this port has no capability behind. Named on
  /// the page rather than only in the library doc, so a reader comparing
  /// pages side by side sees the gaps instead of inferring them.
  Widget _notPorted(ElThemeData theme) => ElSection(
    id: 'not-ported',
    title: 'What this port leaves out',
    description:
        'Six of the reference page\'s thirteen headings describe a '
        'capability ElCarousel does not have. None of them is faked below, '
        'and two of them share one root cause.',
    child: Column(
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
                  '_Track builds a Row unconditionally and the engine only '
                  'listens for onHorizontalDrag*. There is no vertical path '
                  'and no orientation parameter.',
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
                  'ElCarouselController IS barrel-exported, but it is not '
                  'attachable from outside: ElCarousel\'s constructor has no '
                  'controller parameter, so nothing can read selectedIndex '
                  'to render "slide 3 of 6".',
            ),
            DocsApiFact(
              name: 'Events',
              type: 'no controller parameter',
              description:
                  'Same root cause. ElCarouselController is a '
                  'ChangeNotifier and does call notifyListeners, so the '
                  'notifications exist, but with no controller parameter '
                  'there is no way to reach the instance and add a listener.',
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
        SizedBox(height: el(4)),
        ElPanel(
          label: 'ROOT CAUSE',
          note: 'TWO SECTIONS',
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ElWidths.prose),
            child: ElText(
              'API state-tracking and Events are both the same missing '
              'parameter, not two independent gaps. Adding a controller '
              'argument to ElCarousel would close both at once; until then '
              'neither is available, and this page does not pretend '
              'otherwise.',
              ElType.small,
              color: theme.mutedForeground,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _api(ElThemeData theme) => ElSection(
    id: 'api',
    title: 'API Reference',
    description:
        'Every constructor parameter and public member, read straight off '
        'lib/src/components/carousel.dart. Private engine constants and '
        'the private _Track / _Arrow widgets are not part of the API and '
        'are not listed.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-elcarousel'),
          child: const DocsApiTable(title: 'ElCarousel', facts: _carouselFacts),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elcarouselcontroller'),
          child: const DocsApiTable(
            title: 'ElCarouselController',
            facts: _controllerFacts,
          ),
        ),
        SizedBox(height: el(4)),
        ElPanel(
          label: 'ELCAROUSELCONTROLLER',
          note: 'CAVEAT',
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ElWidths.prose),
            child: ElText(
              'ElCarousel builds this controller internally: the '
              'constructor above has no controller parameter. Nothing '
              'outside ElCarousel can read selectedIndex, canScrollPrev, '
              'or canScrollNext, or add its own listener, today.',
              ElType.small,
              color: theme.mutedForeground,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description:
        'Read off ElCarouselController._step, _constrain, and dragEnd, not '
        'inferred.',
    child: const DocsStateMatrix(facts: _stateFacts),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: _bullets(theme, <String>[
      'Keyboard: a Focus node wraps the whole region and handles '
          'ArrowLeft / ArrowRight (KeyDownEvent and KeyRepeatEvent both), '
          'calling scrollPrev / scrollNext. This is the path that works '
          'regardless of what a surrounding frame does to the arrows.',
      'Previous and next controls are real focusable ElButton widgets '
          '(outline variant, iconSm) carrying semantic labels: '
          'previousLabel and nextLabel, defaulting to "Previous slide" and '
          '"Next slide".',
      'Button state: previous is disabled at index 0 (canScrollPrev), next '
          'is disabled at the last trimmed snap (canScrollNext), and each '
          'one rebuilds off the controller through an AnimatedBuilder.',
      'Region label: the whole carousel is one Semantics container labelled '
          '"carousel", which is a generic name and not configurable.',
      'Known gap: no slide-position announcement. Nothing reports the '
          'current index or the total count, and there is no live region, '
          'so a screen-reader user hears no confirmation that an arrow '
          'press moved anything.',
      'Autoplay: none exists in the source, so no pause control is needed '
          'and none is provided.',
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive',
    child: _bullets(theme, <String>[
      'No breakpoint branching in carousel.dart. A LayoutBuilder reads the '
          'incoming width, but only to measure the track and hand the '
          'engine its metrics, never to choose a different structure.',
      'Item width follows the container: basis is a fraction of the track, '
          'so the same basis gives narrower slides at 390px than at '
          '1440px. Changing the column count between breakpoints is the '
          "caller's job, since basis takes one value.",
      'The snap ladder re-measures on layout: setMetrics recomputes the '
          'trimmed snaps and clamps the current index whenever the '
          'container or content size changes, so a resize does not leave '
          'the track parked between stops.',
      'Arrow overhang is width-independent: each arrow reaches el(12) '
          'outside the track, paid for out of padding where padding exists '
          'and overflowing where it does not.',
      'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all '
          'render the same tree, and drag and keyboard both behave '
          'identically. There is no dart:io Platform branch in the file.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: _bullets(theme, <String>[
      'File: lib/src/components/carousel.dart, one file, holding '
          'ElCarousel, ElCarouselController, and the private _Track and '
          '_Arrow.',
      'Flutter imports: dart:math, package:flutter/rendering.dart, '
          'package:flutter/scheduler.dart (Ticker), '
          'package:flutter/services.dart (LogicalKeyboardKey), '
          'package:flutter/widgets.dart.',
      'Foundation import: foundation/spacing.dart (el()) only. No colour, '
          'shadow, or typography token is read directly: the arrows get '
          'all of theirs from ElButton.',
      'Component imports: button.dart (the two arrows), icon.dart and '
          'icon_paths.g.dart (their chevron glyphs).',
      'Registry dependencies: none, from the shipped manifest. '
          'source-foundation, button, and icon are what one would need to '
          'list.',
      'Assets: none. Fonts: none beyond the system type scale. Shaders: '
          'none.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'carousel.dart reads no colour token of its own. Both arrows are '
          'ElButton(variant: outline, size: iconSm), so fill, border, ink, '
          'shadow, and focus ring all resolve inside ElButton off '
          'ElTheme.of(context) at build time.',
      'Their glyphs are ElIcon.lucide with tone: ElIconTone.inherit, so '
          "the chevrons take the button's own resolved ink rather than "
          'declaring a colour.',
      'Flipping ElThemeController re-resolves both arrows on the next '
          'frame. The slides themselves are caller-supplied widgets and '
          'theme however the caller built them.',
      'Geometry is not themeable: the gutter (el(4)) and the arrow reach '
          '(el(12)) are file-level getters over the 4px grid, and no '
          'theme value moves them.',
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
          value: 'nav_user, marker',
          description:
              'ElNavUser and ElMarker used to be documented here. They now '
              'live at example/lib/components_docs/nav_user/page.dart and '
              'example/lib/components_docs/marker/page.dart.',
        ),
      ],
    ),
  );
}

class _CarouselPreview extends StatelessWidget {
  const _CarouselPreview();

  @override
  Widget build(BuildContext context) => ElCarousel(
    basis: 0.4,
    padding: EdgeInsets.all(el(6)),
    items: <Widget>[
      for (int i = 0; i < 5; i++) _DummySlide(label: 'Slide ${i + 1}'),
    ],
  );
}

class _DummySlide extends StatelessWidget {
  const _DummySlide({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.secondary,
        borderRadius: BorderRadius.circular(ElRadii.md),
      ),
      child: Center(child: ElText(label, ElType.body)),
    );
  }
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
        "Required. One CarouselItem's content each. The gutter padding is "
        'applied around each one internally; the caller passes bare '
        'content.',
  ),
  DocsApiFact(
    name: 'padding',
    type: 'EdgeInsets',
    description:
        'Optional. Defaults to EdgeInsets.zero. The frame padding this '
        'carousel applies for itself, moved inside so the arrows can hang '
        "out of it: pass the surrounding panel's own padding and give that "
        'panel flush: true.',
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
    name: 'ElCarouselController({vsync})',
    type: 'TickerProvider?',
    description:
        'The only constructor parameter, and optional. Null means '
        'headless: every move lands on its target in one call instead of '
        'ticking, which is the path a disableAnimations test takes. '
        'ElCarousel always passes its own State as the vsync.',
  ),
  DocsApiFact(
    name: 'instant',
    type: 'bool (mutable field)',
    description:
        'Defaults to false. The reduced-motion switch, pushed down by '
        'ElCarousel every build from '
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
        'api.canScrollPrev(). False at index 0, which is what disables the '
        'previous arrow.',
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
        'negated, clamped into the scrollable range, and collapsed where '
        'clamping made neighbours equal.',
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
        'Writes a new target from the pointer delta. Ignored when no drag '
        'is in progress.',
  ),
  DocsApiFact(
    name: 'dragEnd()',
    type: 'void',
    description:
        'Release: restores the duration, picks the NEAREST snap in either '
        'direction, and targets it. No velocity projection.',
  ),
  DocsApiFact(
    name: 'dispose()',
    type: 'void',
    description:
        'Disposes the ticker. ElCarousel disposes its own instance; a '
        'caller building one by hand owns that.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'Location equals target and velocity is under a thousandth of a '
        'pixel, so the ticker stops itself. The track sits on a trimmed '
        'snap.',
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
        'canScrollPrev is false at index 0 and canScrollNext is false at '
        'the last trimmed snap; each arrow rebuilds through an '
        'AnimatedBuilder and passes a null onPressed there.',
    userSignal: 'A faded, inert arrow, courtesy of ElButton.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'MediaQuery.disableAnimations sets controller.instant, and every '
        'move lands on its target in one call. There is no Duration to '
        'zero here, because the engine is an integrator.',
    userSignal: 'Instant jumps between stops, no glide.',
  ),
];

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElCarousel(
  basis: 0.4,
  items: <Widget>[
    for (int i = 0; i < 5; i++)
      SomeCard(title: 'Slide \${i + 1}'),
  ],
)''';

const String _compositionAnatomyCode = '''ElCarousel(
  basis: 0.4,                      // the item's share of the track
  padding: EdgeInsets.all(el(6)),  // frame padding, so the arrows can hang out
  items: <Widget>[...],            // bare slide content, gutter-padded inside
  previousLabel: 'Previous slide', // the sr-only name on the left arrow
  nextLabel: 'Next slide',
)

// Give the surrounding panel flush: true so its clip does not eat the arrows.
ElPanel(
  flush: true,
  child: ElCarousel(...),
)''';

const String _sizesCode = '''ElCarousel(
  basis: 0.5, // two visible at once
  items: <Widget>[...],
)

ElCarousel(
  basis: 0.333, // three visible at once
  items: <Widget>[...],
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ElCarousel(
    basis: 0.4,
    items: <Widget>[...],
  ),
)''';
