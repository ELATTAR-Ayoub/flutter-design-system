/// Public documentation page for the `carousel`, `nav_user`, and `marker` components.
///
/// Reshaped to the shadcn parity frame: the reader knows
/// https://ui.shadcn.com/docs/components/base/carousel and finds the same
/// answers, in the same order, on this page's carousel sections. `nav_user`
/// and `marker` have no shadcn counterpart at all, so their sections (Nav
/// user, Marker variants) are ours only, kept in the component-specific
/// zone between Composition and API Reference rather than folded silently
/// into a carousel section.
///
/// None of the three has a registry manifest yet: every install-facing
/// panel below says so honestly rather than presenting a CLI command that
/// would fail.
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
    breadcrumbs: const <DsBreadcrumbEntry>[
      DsBreadcrumbEntry.link('Components'),
      DsBreadcrumbEntry.page('Carousel, Nav User, Marker'),
    ],
    sidebar: _sidebar,
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Sizes', anchor: 'sizes'),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(title: 'Nav user', anchor: 'nav-user'),
      DocsTocEntry(title: 'Marker variants', anchor: 'marker-variants'),
      DocsTocEntry(title: 'API Reference', anchor: 'api'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: const DocsPageLink(title: 'Avatar', route: '/components/avatar'),
    next: const DocsPageLink(title: 'Badge', route: '/components/badge'),
    onNavigate: onNavigate,
    child: const _ArticleContent(),
  );
}

const List<DocsSidebarEntry> _sidebar = <DocsSidebarEntry>[
  DocsSidebarEntry(title: 'Carousel', route: '/components/carousel'),
  DocsSidebarEntry(title: 'Nav User', route: '/components/nav-user'),
  DocsSidebarEntry(title: 'Marker', route: '/components/marker'),
];

class _ArticleContent extends StatelessWidget {
  const _ArticleContent();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      key: const ValueKey<String>('carousel-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _liveDemo(),
        SizedBox(height: ds(8)),
        _about(theme),
        _install(),
        _usage(),
        _composition(),
        _sizes(),
        _rtl(theme),
        _navUser(),
        _markerVariants(),
        _apiReference(theme),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _theming(theme),
        _source(),
      ],
    );
  }

  // shadcn: the live demo that opens the page, before any heading. No
  // DsSection, no id, no TOC entry: matching the reference exactly.
  Widget _liveDemo() => DocsCodeExample(
    title: 'Component specimens',
    manualFiles: const <DocsCodeFile>[
      DocsCodeFile(
        path: 'lib/components/ui/carousel.dart',
        code:
            "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
            '// Carousel, nav_user, and marker have no registry manifest yet\n'
            '//: copy from the package source directly.',
      ),
    ],
    preview: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText('Carousel with 5 slides', DsType.label),
        SizedBox(height: ds(3)),
        _CarouselPreview(),
        SizedBox(height: ds(6)),
        DsText('Nav User in sidebar context', DsType.label),
        SizedBox(height: ds(3)),
        _NavUserPreview(),
        SizedBox(height: ds(6)),
        DsText('Marker variants', DsType.label),
        SizedBox(height: ds(3)),
        _MarkerVariantsPreview(),
      ],
    ),
  );

  // shadcn: About. Explains what the carousel is built on, the way the
  // reference explains it is built on Embla Carousel.
  Widget _about(DsThemeData theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: DsWidths.prose),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(
            "DsCarousel is a from-scratch reimplementation of Embla "
            "Carousel's own physics, not a wrapper around the JS library: "
            'an integrator loop for the glide (velocity = (velocity + '
            '(target minus location) divided by 25, times 0.68), a '
            'rubber-banded ScrollBounds past either edge, and '
            'containScroll: trimSnaps for the snap ladder. Previous/next '
            'buttons and the ArrowLeft/ArrowRight keys both drive the '
            'same DsCarouselController.',
            DsType.body,
          ),
          SizedBox(height: ds(4)),
          DsText(
            'This page also documents DsNavUser and DsMarker, a sidebar '
            'account footer and a quiet list separator. Neither has a '
            'shadcn counterpart: their sections below (Nav user, Marker '
            'variants) are ours only.',
            DsType.body,
          ),
        ],
      ),
    ),
    ],
  );

  // shadcn: Installation, Command and Manual tabs.
  Widget _install() => DsSection(
    id: 'install',
    title: 'Installation',
    description:
        'None of these components has a registry manifest yet, so '
        '`elattar add carousel` is not available: install by copying source files manually.',
    child: DocsInstallFacts(
      title: 'Installation facts',
      facts: <DocsInstallFact>[
        const DocsInstallFact(
          label: 'Registry items',
          value: 'not yet registered',
          description:
              'No registry/components/carousel.json, nav_user.json, or '
              'marker.json exist. These are source-only components today.',
        ),
        const DocsInstallFact(
          label: 'Destinations',
          value: 'lib/components/ui/{carousel,nav_user,marker}.dart',
          description: 'Where manual copies of the source belong.',
        ),
        const DocsInstallFact(
          label: 'Foundation',
          value: 'source only',
          description: 'No package-backed alternative is offered yet.',
        ),
        const DocsInstallFact(
          label: 'Dependencies',
          value: 'source-foundation, button, icon, avatar, dropdown_menu',
          description:
              'What a future manifest would need to resolve: colors, '
              'shadows, spacing, theme, typography, button, icon, and '
              'other UI components. None of this is resolved automatically '
              'today; copy the imports by hand.',
        ),
        const DocsInstallFact(
          label: 'Assets',
          value: 'none',
          description: 'No images, icon fonts, or binary assets.',
        ),
        const DocsInstallFact(
          label: 'Shaders',
          value: 'none',
          description:
              'All effects are widget-based or CSS-derived, not shaders.',
        ),
        DocsInstallFact(
          label: 'Platforms',
          value: 'Android, iOS, Web, macOS, Windows, Linux',
          description: 'No platform-conditional code in any of the three.',
        ),
        const DocsInstallFact(
          label: 'Verified',
          value: 'docs specimen only',
          description:
              'This page\'s live preview and example/test/components_docs/'
              'carousel_test.dart. No dedicated package-level unit test exists yet.',
        ),
      ],
    ),
  );

  // shadcn: Usage, imports plus basic construction.
  Widget _usage() => DsSection(
    id: 'usage',
    title: 'Usage',
    description: 'The smallest correct call for each component.',
    child: DsPanel(
      label: 'DART',
      note: 'COMPOSE',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  // shadcn: Composition, the widget-hierarchy tree. DsCarousel folds
  // CarouselContent/CarouselItem/CarouselPrevious/CarouselNext into one
  // widget rather than a family of composable subcomponents; NavUser and
  // Marker are the same shape, one widget each.
  Widget _composition() => DsSection(
    id: 'composition',
    title: 'Composition',
    description:
        'DsCarousel folds CarouselContent, CarouselItem, '
        'CarouselPrevious, and CarouselNext into one widget: hand it '
        'items and basis, get back a scrollable track with both buttons '
        'already wired up. DsNavUser and DsMarker are likewise single '
        'widgets, not subcomponent families.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPanel(
          label: 'DART',
          note: 'ANATOMY',
          child: DocsSelectableCodeBlock(code: _compositionAnatomyCode),
        ),
        SizedBox(height: ds(6)),
        DsText('Composed inside a panel', DsType.label),
        SizedBox(height: ds(2)),
        DsText(
          "Pass the panel's padding and set flush: true so the arrows "
          'can hang outside it.',
          DsType.small,
        ),
        SizedBox(height: ds(4)),
        DsPanel(
          label: 'CAROUSEL INSIDE PANEL',
          flush: true,
          child: DsCarousel(
            basis: 0.4,
            padding: EdgeInsets.all(ds(6)),
            items: <Widget>[
              for (int i = 0; i < 5; i++) _DummySlide(label: 'Slide ${i + 1}'),
            ],
          ),
        ),
      ],
    ),
  );

  // shadcn: Sizes, utility classes controlling item width.
  Widget _sizes() => DsSection(
    id: 'sizes',
    title: 'Sizes',
    description:
        "basis is the item's share of the track: 0.5 shows two at once, "
        '0.333 shows three. There is no responsive basis: one value '
        'applies at every width, so a caller that wants it to change at a '
        'breakpoint has to swap it itself.',
    child: DocsCodeExample(
      title: 'Two sizes',
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText('basis: 0.5, two per view', DsType.label),
          SizedBox(height: ds(3)),
          DsCarousel(
            basis: 0.5,
            padding: EdgeInsets.all(ds(6)),
            items: <Widget>[
              for (int i = 0; i < 5; i++) _DummySlide(label: 'Slide ${i + 1}'),
            ],
          ),
          SizedBox(height: ds(6)),
          DsText('basis: 0.333, three per view', DsType.label),
          SizedBox(height: ds(3)),
          DsCarousel(
            basis: 0.333,
            padding: EdgeInsets.all(ds(6)),
            items: <Widget>[
              for (int i = 0; i < 5; i++) _DummySlide(label: 'Slide ${i + 1}'),
            ],
          ),
        ],
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'carousel_sizes.dart', code: _sizesCode),
      ],
    ),
  );

  // shadcn: RTL. DOCUMENTED DRIFT, see the section description.
  Widget _rtl(DsThemeData theme) => DsSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'DOCUMENTED DRIFT: the track is a plain Row, which reads '
        "Directionality and reverses its children's paint order under "
        'RTL, but the arrow buttons are Positioned(left:, right:) and the '
        'drag math is physical pixels, so neither one flips. Wrapping in '
        'Directionality.rtl below is inconsistent rather than mirrored: '
        'slide order reverses, the controls do not.',
    child: DocsCodeExample(
      title: 'Wrapped in Directionality.rtl',
      preview: Directionality(
        textDirection: TextDirection.rtl,
        child: DsCarousel(
          basis: 0.4,
          padding: EdgeInsets.all(ds(6)),
          items: <Widget>[
            for (int i = 0; i < 5; i++) _DummySlide(label: 'Slide ${i + 1}'),
          ],
        ),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'carousel_rtl.dart', code: _rtlCode),
      ],
    ),
  );

  // Ours only: DsNavUser has no shadcn counterpart. Grouped under its own
  // name in the component-specific zone, the way the frame asks for it.
  Widget _navUser() => DsSection(
    id: 'nav-user',
    title: 'Nav user',
    description:
        'Ours only: the account block a sidebar footer is incomplete '
        'without. One widget, one required account and one required item '
        'list; the dropdown, avatar fallback, and destructive-item '
        'styling all come along automatically.',
    child: DocsCodeExample(
      title: 'Nav user',
      preview: const _NavUserPreview(),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(path: 'nav_user_example.dart', code: _navUserCode),
      ],
    ),
  );

  // Ours only: DsMarker has no shadcn counterpart. One section for all
  // three variant values, per rule 5, not three separate sections.
  Widget _markerVariants() => DsSection(
    id: 'marker-variants',
    title: 'Marker variants',
    description:
        'Ours only: DsMarker has three variants, documented together in '
        'one section rather than one section per value.',
    child: const DocsApiTable(
      title: 'DsMarkerVariant',
      facts: <DocsApiFact>[
        DocsApiFact(
          name: 'normal',
          type: 'default',
          description:
              'Bare row: for a container that already frames it. No rules '
              'or borders.',
        ),
        DocsApiFact(
          name: 'separator',
          type: 'divider',
          description:
              'Rule, label, rule. Divides before from after, the rules '
              'flex to fill available width.',
        ),
        DocsApiFact(
          name: 'border',
          type: 'border',
          description:
              'Label with a 1px bottom border. Heads what follows, good for '
              'section breaks.',
        ),
      ],
    ),
  );

  // shadcn: API Reference, the last shadcn section, one prop table per
  // class in the family.
  Widget _apiReference(DsThemeData theme) => DsSection(
    id: 'api',
    title: 'API Reference',
    description:
        'Every constructor parameter, read directly from '
        'lib/src/components/carousel.dart, nav_user.dart, and marker.dart.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(
          title: 'DsCarousel properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'basis',
              type: 'double',
              description:
                  'Required. The item\'s share of the track as a '
                  'fraction, 0.5 for 2 columns, 0.333 for 3.',
            ),
            DocsApiFact(
              name: 'items',
              type: 'List<Widget>',
              description:
                  'Required. The carousel slides, each wrapped automatically.',
            ),
            DocsApiFact(
              name: 'padding',
              type: 'EdgeInsets',
              description:
                  'The frame padding the carousel applies for itself. '
                  'Pass the panel\'s padding and set panel flush: true.',
            ),
            DocsApiFact(
              name: 'previousLabel',
              type: 'String',
              description:
                  'Accessibility label for the previous button. Defaults to '
                  '"Previous slide".',
            ),
            DocsApiFact(
              name: 'nextLabel',
              type: 'String',
              description:
                  'Accessibility label for the next button. Defaults to '
                  '"Next slide".',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsCarouselController',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'selectedIndex',
              type: 'int (read-only)',
              description: 'The current slide index.',
            ),
            DocsApiFact(
              name: 'canScrollPrev',
              type: 'bool (read-only)',
              description:
                  'Whether the previous button should be enabled. False at '
                  'index 0.',
            ),
            DocsApiFact(
              name: 'canScrollNext',
              type: 'bool (read-only)',
              description:
                  'Whether the next button should be enabled. False at the '
                  'last snap.',
            ),
            DocsApiFact(
              name: 'snaps',
              type: 'List<double> (read-only)',
              description:
                  'Every snap point the carousel can rest at (trimmed).',
            ),
            DocsApiFact(
              name: 'scrollTo(int)',
              type: 'void',
              description: 'Scroll to a specific index.',
            ),
            DocsApiFact(
              name: 'scrollPrev()',
              type: 'void',
              description: 'Scroll to the previous slide.',
            ),
            DocsApiFact(
              name: 'scrollNext()',
              type: 'void',
              description: 'Scroll to the next slide.',
            ),
          ],
        ),
        SizedBox(height: ds(4)),
        DsPanel(
          label: 'DSCAROUSELCONTROLLER',
          note: 'CAVEAT',
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: DsWidths.prose),
            child: DsText(
              'DsCarousel builds this controller internally: the '
              'constructor above has no controller parameter. Nothing '
              'outside DsCarousel can read selectedIndex, canScrollPrev, '
              'or canScrollNext, or add its own listener, today.',
              DsType.small,
              color: theme.mutedForeground,
            ),
          ),
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsNavUser properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'user',
              type: 'DsNavUserAccount',
              description:
                  'Required. The account details: name, email, optional avatar image.',
            ),
            DocsApiFact(
              name: 'items',
              type: 'List<DsNavUserItem>',
              description:
                  'Required. Menu items shown in the dropdown, split into '
                  'normal and destructive sections.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsNavUserAccount properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'name',
              type: 'String',
              description: 'The user\'s display name.',
            ),
            DocsApiFact(
              name: 'email',
              type: 'String',
              description: 'The user\'s email address.',
            ),
            DocsApiFact(
              name: 'avatar',
              type: 'ImageProvider<Object>?',
              description:
                  'Optional avatar image. Falls back to initials if omitted.',
            ),
            DocsApiFact(
              name: 'initials',
              type: 'String (read-only)',
              description:
                  'First letter of each of the first two words in the name, '
                  'uppercased.',
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsMarker properties',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'label',
              type: 'String',
              description: 'Required. The separator label text.',
            ),
            DocsApiFact(
              name: 'variant',
              type: 'DsMarkerVariant',
              description:
                  'Defaults to normal. Controls the visual treatment: bare, '
                  'separator (with rules), or border.',
            ),
            DocsApiFact(
              name: 'icon',
              type: 'Widget?',
              description: 'Optional leading icon (forced to 16px square).',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _states() => DsSection(
    id: 'states',
    title: 'States',
    description:
        'DsCarousel animates location changes via an Embla-like integrator. '
        'DsNavUser and DsMarker are static.',
    child: const DocsStateMatrix(
      facts: <DocsStateFact>[
        DocsStateFact(
          state: 'Rest',
          treatment:
              'Carousel rests at a snap point. NavUser shows avatar, name, '
              'email. Marker shows label.',
          userSignal: 'Visual state only.',
        ),
        DocsStateFact(
          state: 'Carousel scrolling',
          treatment:
              'Location animates toward target via an integrator loop. '
              'Previous/next buttons enable/disable based on canScrollPrev/Next.',
          userSignal: 'Smooth motion. Buttons enable/disable.',
        ),
        DocsStateFact(
          state: 'Carousel dragging',
          treatment:
              'Target follows the pointer 1:1. Release snaps to nearest '
              'stop.',
          userSignal: 'Pointer drag. Snap on release.',
        ),
        DocsStateFact(
          state: 'Reduced motion',
          treatment:
              'Carousel lands on target instantly (no integrator animation). '
              'NavUser and Marker unaffected.',
          userSignal: 'No motion, instant jumps.',
        ),
      ],
    ),
  );

  Widget _accessibility(DsThemeData theme) => DsSection(
    id: 'accessibility',
    title: 'Accessibility',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText('Carousel:', DsType.label),
        SizedBox(height: ds(2)),
        ..._bulletWidgets(theme, <String>[
          'Keyboard: ArrowLeft/ArrowRight navigate prev/next; also handled '
              'via the real button focus paths.',
          'Previous and next controls: Real focusable DsButton widgets with '
              'semantic labels ("Previous slide", "Next slide" by default).',
          'Slide count announcement: Not implemented: no live region or '
              'ARIA attribute announces the current slide index or total count. '
              'The carousel has a generic label ("carousel") only.',
          'Autoplay: No autoplay mechanism exists in the source: there is no '
              'auto-scrolling Timer or animation loop. No pause control needed.',
          'Button state: Previous button disabled at index 0; next button '
              'disabled at the last snap.',
        ]),
        SizedBox(height: ds(4)),
        DsText('Nav User:', DsType.label),
        SizedBox(height: ds(2)),
        ..._bulletWidgets(theme, <String>[
          'The account row carries an accessible name via tooltip (user.name) '
              'and the menu structure. The button is a DsSidebarMenuButton with '
              'size lg.',
          'Dropdown menu contains a menu header repeating the identity, '
              'followed by menu items separated by destructive actions.',
          'The component itself does not announce a semantic role beyond its '
              'menu parent.',
        ]),
        SizedBox(height: ds(4)),
        DsText('Marker:', DsType.label),
        SizedBox(height: ds(2)),
        ..._bulletWidgets(theme, <String>[
          'Static presentational widget: no interaction, focus, or animation.',
          'Rendered as ordinary text, not as a semantic boundary or landmark. '
              'Screenreader reads the label text as prose.',
          'Use in a list or timeline where the label semantically marks a '
              'transition (e.g., "Today", "Messages hidden").',
        ]),
      ],
    ),
  );

  Widget _responsive(DsThemeData theme) => DsSection(
    id: 'responsive',
    title: 'Responsive',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText('Carousel:', DsType.label),
        SizedBox(height: ds(2)),
        ..._bulletWidgets(theme, <String>[
          'Basis determines the item width as a fraction of the track. Change '
              'basis between breakpoints to adjust columns (0.5 = 2 col, 0.333 '
              '= 3 col). See Sizes above.',
          'Previous/next buttons hang outside the carousel by --reach (12px ds '
              'unit). Arrows clipped by the panel\'s overflow-hidden.',
          'Keyboard and drag work identically on all platforms.',
        ]),
        SizedBox(height: ds(4)),
        DsText('Nav User:', DsType.label),
        SizedBox(height: ds(2)),
        ..._bulletWidgets(theme, <String>[
          'On mobile (inside a DsSidebarScope with isMobile: true), the '
              'dropdown opens below (DsPopoverSide.bottom). On desktop, it opens '
              'to the right.',
          'Responsive inside DsSidebar: works identically on all platforms.',
        ]),
        SizedBox(height: ds(4)),
        DsText('Marker:', DsType.label),
        SizedBox(height: ds(2)),
        ..._bulletWidgets(theme, <String>[
          'No responsive branching: rendered identically at all widths.',
          'In separator variant, the two rules flex to fill available space; '
              'the label stays flexible.',
        ]),
      ],
    ),
  );

  Widget _dependencies(DsThemeData theme) => DsSection(
    id: 'dependencies',
    title: 'Dependencies',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText('Files:', DsType.label),
        SizedBox(height: ds(2)),
        ..._bulletWidgets(theme, <String>[
          'lib/src/components/carousel.dart, Carousel, DsCarouselController, '
              '_Track, _Arrow.',
          'lib/src/components/nav_user.dart, DsNavUser, DsNavUserAccount, '
              'DsNavUserItem, _IdentityText.',
          'lib/src/components/marker.dart, DsMarker, DsMarkerVariant.',
        ]),
        SizedBox(height: ds(4)),
        DsText('Foundation imports:', DsType.label),
        SizedBox(height: ds(2)),
        ..._bulletWidgets(theme, <String>[
          'foundation/spacing.dart (ds()).',
          'foundation/theme.dart (DsThemeData, DsTheme).',
          'foundation/typography.dart (DsType, DsComponentType, DsText).',
          'foundation/colors.dart (for theme color access).',
        ]),
        SizedBox(height: ds(4)),
        DsText('Component imports:', DsType.label),
        SizedBox(height: ds(2)),
        ..._bulletWidgets(theme, <String>[
          'Carousel: button.dart, icon.dart, icon_paths.g.dart.',
          'NavUser: avatar.dart, dropdown_menu.dart, menu.dart, popover.dart, '
              'sidebar.dart.',
          'Marker: none beyond foundation.',
        ]),
        SizedBox(height: ds(4)),
        DsText(
          'Assets: none. Fonts: none beyond the system type scale. '
          'Shaders: none.',
          DsType.small,
          color: theme.mutedForeground,
        ),
      ],
    ),
  );

  Widget _theming(DsThemeData theme) => DsSection(
    id: 'theming',
    title: 'Theming',
    child: _bullets(theme, <String>[
      'Carousel: Previous/next buttons resolve their colors from DsButton '
          '(outline variant). Flipping DsThemeController updates both.',
      'Nav User: Avatar, name, email colors all theme-resolved. Dropdown menu '
          'inherits theme.',
      'Marker: Label color is theme.mutedForeground. Rules use theme.border. '
          'All re-resolve when theme flips.',
    ]),
  );

  Widget _source() => DsSection(
    id: 'source',
    title: 'Source',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Carousel source',
          value: carouselDoc.sourcePath,
          description: 'Authoritative implementation.',
        ),
        const DocsInstallFact(
          label: 'Nav User source',
          value: 'lib/src/components/nav_user.dart',
          description: 'Authoritative implementation.',
        ),
        const DocsInstallFact(
          label: 'Marker source',
          value: 'lib/src/components/marker.dart',
          description: 'Authoritative implementation.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'none yet',
          description: 'No dedicated unit tests in the package suite yet.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/carousel_test.dart',
          description:
              'Covers this page: live specimens, API table verification, '
              'and theme switching on real sizes.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/carousel/page.dart',
          description: 'This file.',
        ),
      ],
    ),
  );
}

class _CarouselPreview extends StatefulWidget {
  const _CarouselPreview();

  @override
  State<_CarouselPreview> createState() => _CarouselPreviewState();
}

class _CarouselPreviewState extends State<_CarouselPreview>
    with SingleTickerProviderStateMixin {
  late final DsCarouselController _controller = DsCarouselController(
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.instant = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    return DsCarousel(
      basis: 0.4,
      padding: EdgeInsets.all(ds(6)),
      items: <Widget>[
        for (int i = 0; i < 5; i++) _DummySlide(label: 'Slide ${i + 1}'),
      ],
    );
  }
}

class _DummySlide extends StatelessWidget {
  const _DummySlide({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.secondary,
        borderRadius: BorderRadius.circular(ds(2)),
      ),
      child: Center(child: DsText(label, DsType.body)),
    );
  }
}

class _NavUserPreview extends StatelessWidget {
  const _NavUserPreview();

  @override
  Widget build(BuildContext context) {
    return DsNavUser(
      user: const DsNavUserAccount(
        name: 'Alex Johnson',
        email: 'alex@example.com',
      ),
      items: <DsNavUserItem>[
        DsNavUserItem(label: 'Profile', icon: DsLucide.user),
        DsNavUserItem(label: 'Settings', icon: DsLucide.settings),
        DsNavUserItem(
          label: 'Sign out',
          icon: DsLucide.logOut,
          destructive: true,
        ),
      ],
    );
  }
}

class _MarkerVariantsPreview extends StatelessWidget {
  const _MarkerVariantsPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsMarker(variant: DsMarkerVariant.normal, label: 'Normal variant'),
        SizedBox(height: ds(4)),
        DsMarker(
          variant: DsMarkerVariant.separator,
          label: 'Separator with rules',
        ),
        SizedBox(height: ds(4)),
        DsMarker(
          variant: DsMarkerVariant.border,
          label: 'Border bottom variant',
        ),
      ],
    );
  }
}

List<Widget> _bulletWidgets(DsThemeData theme, List<String> lines) {
  final List<Widget> widgets = <Widget>[];
  for (final String line in lines) {
    widgets.add(
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: DsWidths.prose),
        child: DsText('•  $line', DsType.small, color: theme.mutedForeground),
      ),
    );
    widgets.add(SizedBox(height: ds(2)));
  }
  return widgets;
}

Widget _bullets(DsThemeData theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: _bulletWidgets(theme, lines),
);

const String _usageCode = '''
// Carousel with 5 slides at 40% width each
DsCarousel(
  basis: 0.4,
  items: <Widget>[
    for (int i = 0; i < 5; i++)
      SomeCard(title: 'Slide \${i + 1}'),
  ],
)

// Nav User in sidebar footer
DsNavUser(
  user: const DsNavUserAccount(
    name: 'Alex Johnson',
    email: 'alex@example.com',
  ),
  items: <DsNavUserItem>[
    DsNavUserItem(label: 'Profile'),
    DsNavUserItem(
      label: 'Sign out',
      destructive: true,
    ),
  ],
)

// Marker separating list sections
DsMarker(
  variant: DsMarkerVariant.separator,
  label: 'Today',
)''';

const String _compositionAnatomyCode = '''DsCarousel(
  basis: 0.4,          // the item's share of the track
  padding: EdgeInsets.all(24), // frame padding, so arrows can hang outside it
  items: <Widget>[...], // the slides, each wrapped and gutter-padded internally
  previousLabel: 'Previous slide', // sr-only style label on the prev button
  nextLabel: 'Next slide',
)''';

const String _sizesCode = '''DsCarousel(
  basis: 0.5, // two visible at once
  items: <Widget>[...],
)

DsCarousel(
  basis: 0.333, // three visible at once
  items: <Widget>[...],
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: DsCarousel(
    basis: 0.4,
    items: <Widget>[...],
  ),
)''';

const String _navUserCode = '''DsNavUser(
  user: const DsNavUserAccount(
    name: 'Alex Johnson',
    email: 'alex@example.com',
  ),
  items: <DsNavUserItem>[
    DsNavUserItem(label: 'Profile', icon: DsLucide.user),
    DsNavUserItem(label: 'Settings', icon: DsLucide.settings),
    DsNavUserItem(
      label: 'Sign out',
      icon: DsLucide.logOut,
      destructive: true,
    ),
  ],
)''';
