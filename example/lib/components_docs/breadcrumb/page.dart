/// Public component documentation for the breadcrumb component.
///
/// `breadcrumb` is Wave 1 of the component-documentation plan and carries no
/// `registry/components/breadcrumb.json` manifest yet: the Installation
/// section says so plainly rather than rendering `elattar add breadcrumb` as
/// if it worked. See `meta.dart` for the same note against
/// [ComponentDocEntry.command].
///
/// Section shape mirrors `https://ui.shadcn.com/docs/components/base/breadcrumb`
/// section for section. A live demo renders ahead of any heading, the same
/// as the reference's own top-of-page preview: no Overview, Status, or
/// Preview heading precedes Installation. Then Installation, Usage,
/// Composition, Basic, Link component, RTL, and API Reference, in that
/// order. Custom separator, Dropdown, and Collapsed have no counterpart
/// here: ElBreadcrumb has no separator override, no widget slot for a
/// crumb-embedded trigger, and no widget that collapses a trail (see the
/// Composition, Link component, and Responsive sections respectively).
/// States, Accessibility, Responsive, Dependencies, Theming, and Source are
/// this package's own six sections, added after API Reference, named
/// exactly that with no extra words. Each gets its own [ElSection];
/// title/description and previous/next come from [DocsLayout].
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import '../catalog.dart';
import 'meta.dart';

class BreadcrumbDocPage extends StatelessWidget {
  const BreadcrumbDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ComponentDocEntry entry = breadcrumbDoc;
    return DocsLayout(
      route: entry.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / BASE',
        title: entry.title,
        description:
            'Breadcrumb shows where the current page sits inside a '
            'hierarchy and gives a way back to each ancestor. Reach for it on '
            'a detail page the user drilled into: not for switching between '
            'sibling views (that is Tabs), paging through one list '
            '(Pagination), or a site\'s top-level sections (Navigation Menu). '
            'The trail derives its own separators and wraps onto a new line '
            'instead of collapsing when it runs out of room.',
      ),
      breadcrumbs: const <ElBreadcrumbEntry>[
        ElBreadcrumbEntry.link('Components'),
        ElBreadcrumbEntry.page('Breadcrumb'),
      ],
      sidebar: const <DocsSidebarEntry>[
        DocsSidebarEntry(title: 'Badge', route: '/components/badge'),
        DocsSidebarEntry(
          title: 'Breadcrumb',
          route: '/components/breadcrumb',
          selected: true,
        ),
        DocsSidebarEntry(title: 'Checkbox', route: '/components/checkbox'),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(title: 'Basic', anchor: 'basic'),
        DocsTocEntry(title: 'Link component', anchor: 'link-component'),
        DocsTocEntry(title: 'RTL', anchor: 'rtl'),
        DocsTocEntry(title: 'API Reference', anchor: 'api'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      previous: const DocsPageLink(title: 'Badge', route: '/components/badge'),
      next: const DocsPageLink(
        title: 'Checkbox',
        route: '/components/checkbox',
      ),
      onNavigate: onNavigate,
      child: _BreadcrumbArticle(entry: entry),
    );
  }
}

class _BreadcrumbArticle extends StatelessWidget {
  const _BreadcrumbArticle({required this.entry});

  final ComponentDocEntry entry;

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('breadcrumb-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      // The live demo, ahead of any heading: the same shape the reference
      // page itself opens with. No ElSection wraps it, so it carries no
      // Overview/Status/Preview heading of its own before Installation.
      DocsCodeExample(
        title: 'Breadcrumb specimens',
        description:
            'A typical multi-step trail, and a single current-page crumb, '
            'which renders no separator at all. Hover a link crumb to see '
            'the ink brighten; the current page never responds to hover '
            'or tap.',
        preview: const _BreadcrumbPreview(),
        manualFiles: const <DocsCodeFile>[
          DocsCodeFile(
            path: 'lib/components/ui/breadcrumb.dart',
            code:
                "import 'package:flutter/widgets.dart';\n\n"
                '// Install with: elattar add breadcrumb',
          ),
        ],
      ),
      SizedBox(height: el(8)),
      ElSection(
        id: 'install',
        title: 'Installation',
        description:
            'breadcrumb has no CLI install path yet. This section says so '
            'directly instead of showing a command that would fail.',
        child: DocsInstallFacts(
          title: 'Installation',
          facts: <DocsInstallFact>[
            const DocsInstallFact(
              label: 'CLI',
              value: 'elattar add breadcrumb',
              description:
                  'Installs registry/components/breadcrumb.json and its '
                  'declared dependency closure.',
            ),
            DocsInstallFact(
              label: 'Manual',
              value: entry.sourcePath,
              description:
                  'Copy the source file into lib/components/ui/breadcrumb.dart '
                  'and update its relative imports to wherever your copied '
                  'foundation and icon files live.',
            ),
            DocsInstallFact(
              label: 'Barrel export',
              value: entry.exports.join(', '),
              description:
                  'Export both symbols from your ui barrel so callers only '
                  'import one file.',
            ),
          ],
        ),
      ),
      ElSection(
        id: 'usage',
        title: 'Usage',
        description:
            'The smallest correct composition: three steps, the last one '
            'the current page.',
        child: ElPanel(
          label: 'DART',
          note: 'COMPOSE',
          child: DocsSelectableCodeBlock(code: _usageCode),
        ),
      ),
      ElSection(
        id: 'composition',
        title: 'Composition',
        description:
            'ElBreadcrumb has no BreadcrumbList, BreadcrumbItem, or '
            'BreadcrumbSeparator to assemble by hand: items builds the '
            'whole trail, and a chevron separator is derived between every '
            'adjacent pair. What follows is what that single call builds '
            'internally, and how it composes into a real page.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElPanel(
              label: 'What ElBreadcrumb(items: …) assembles',
              child: DocsSelectableCodeBlock(code: _compositionCode),
            ),
            SizedBox(height: el(6)),
            const DocsCodeExample(
              title: 'Page header composition',
              description:
                  'Breadcrumb sitting above a page title and an action: '
                  'its usual home, rather than the isolated specimen above.',
              preview: _BreadcrumbComposition(),
            ),
          ],
        ),
      ),
      ElSection(
        id: 'basic',
        title: 'Basic',
        description:
            'The simplest real trail: two ancestor links and the current, '
            'non-clickable page.',
        child: const DocsCodeExample(
          title: 'Basic breadcrumb',
          preview: _BreadcrumbBasic(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(path: 'basic_breadcrumb.dart', code: _usageCode),
          ],
        ),
      ),
      ElSection(
        id: 'link-component',
        title: 'Link component',
        description:
            'Flutter has no anchor tag to swap in: onTap is the '
            'equivalent seam. ElBreadcrumbEntry.link(label, {onTap}) hands '
            'you a bare VoidCallback, so plugging in a router (go_router, '
            'Navigator, or anything else) is the caller\'s own onTap body, '
            'not a render prop ElBreadcrumb has to know about.',
        child: ElPanel(
          label: 'DART',
          note: 'ROUTE',
          child: DocsSelectableCodeBlock(code: _linkComponentCode),
        ),
      ),
      ElSection(
        id: 'rtl',
        title: 'RTL',
        description:
            'The same composition read right-to-left under a '
            'Directionality: the port\'s own proof that direction is '
            'context, not a second set of controls. The chevron does not '
            'flip: nothing in the source mirrors it, and it points the '
            'same way in both directions.',
        child: const DocsCodeExample(
          title: 'Right-to-left breadcrumb',
          preview: _BreadcrumbRtl(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(path: 'rtl_breadcrumb.dart', code: _rtlCode),
          ],
        ),
      ),
      ElSection(
        id: 'api',
        title: 'API Reference',
        description:
            'Every public class, constructor, field, and static layout '
            'constant the source declares. There is no ElBreadcrumbVariant '
            'or ElBreadcrumbSize to choose from: the only per-crumb '
            'decision is which constructor built the entry, .link or '
            '.page, both named below.',
        child: const DocsApiTable(
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'items',
              type: 'List<ElBreadcrumbEntry>',
              description:
                  'Required. The ordered trail. A chevron separator is '
                  'derived between every adjacent pair: there is no way to '
                  'place two crumbs with no separator between them.',
            ),
            DocsApiFact(
              name: 'gap',
              type: 'static double (get)',
              description:
                  "6px: the list's own Wrap spacing and runSpacing, on "
                  'both axes, since it can wrap onto more than one line.',
            ),
            DocsApiFact(
              name: 'separatorPx',
              type: 'static double (get)',
              description: "14px: the derived chevron separator's own box.",
            ),
            DocsApiFact(
              name: 'ElBreadcrumbEntry.link(label, {onTap})',
              type: 'const factory',
              description:
                  'A step back in the trail. label is required and '
                  'positional; onTap is optional (default null): a link '
                  'with no onTap is inert but still styled and semantically '
                  'a link.',
            ),
            DocsApiFact(
              name: 'ElBreadcrumbEntry.page(label)',
              type: 'const factory',
              description:
                  'The current page. label is required and positional. '
                  'Renders at theme.foreground, is never tappable, and is '
                  'marked disabled in the semantics tree.',
            ),
            DocsApiFact(
              name: 'label',
              type: 'String',
              description:
                  'The crumb text, from whichever constructor built the '
                  'entry.',
            ),
            DocsApiFact(
              name: 'onTap',
              type: 'VoidCallback?',
              description:
                  'Only ever set by ElBreadcrumbEntry.link; always null on '
                  'a page entry.',
            ),
            DocsApiFact(
              name: 'isPage',
              type: 'bool',
              description:
                  'Derived, not a constructor parameter of its own: true '
                  'for entries built with .page, false for .link. Read-only.',
            ),
          ],
        ),
      ),
      ElSection(
        id: 'states',
        title: 'States',
        description:
            'Rows that do not apply to a synchronous, variant-free '
            'primitive are marked N/A with the reason, rather than invented.',
        child: const DocsStateMatrix(
          facts: <DocsStateFact>[
            DocsStateFact(
              state: 'Rest (link crumb)',
              treatment: 'ElComponentType.textSm at theme.mutedForeground.',
              userSignal:
                  'Reads as secondary, quiet text until interacted with.',
            ),
            DocsStateFact(
              state: 'Hover (link crumb)',
              treatment:
                  'Animates to theme.foreground over '
                  'elAnimationDuration(context, ElDurations.transitionDefault) '
                  'on ElCurves.out.',
              userSignal:
                  'The crumb brightens toward full-strength text and the '
                  'cursor becomes a pointer.',
            ),
            DocsStateFact(
              state: 'Current page (ElBreadcrumbEntry.page)',
              treatment:
                  'theme.foreground at all times; Semantics(link: true, '
                  'enabled: false); no GestureDetector is attached.',
              userSignal:
                  'The strongest-contrast crumb in the trail; does not '
                  'respond to hover or tap.',
            ),
            DocsStateFact(
              state: 'Focus-visible',
              treatment:
                  'N/A: the link crumb wraps a MouseRegion and a '
                  'GestureDetector but no Focus/FocusNode, so it never '
                  'enters keyboard Tab order and paints no focus ring.',
              userSignal:
                  'A keyboard-only visitor cannot reach a crumb today: see '
                  'Accessibility.',
            ),
            DocsStateFact(
              state: 'Pressed',
              treatment:
                  'N/A, GestureDetector.onTap fires with no intermediate '
                  'pressed-state paint; there is no ElPress scale or '
                  'opacity step here.',
              userSignal: 'A tap or click resolves in a single frame.',
            ),
            DocsStateFact(
              state: 'Loading / Error / Success',
              treatment:
                  'N/A, ElBreadcrumb is a synchronous rendering primitive '
                  'with no future, stream, or error boundary of its own.',
              userSignal: 'Not applicable.',
            ),
            DocsStateFact(
              state: 'Empty items',
              treatment:
                  'N/A as a dedicated state, ElBreadcrumb(items: const '
                  '[]) renders a zero-size Wrap: no crumbs, no separators, '
                  'no placeholder text.',
              userSignal:
                  'The control disappears rather than showing a '
                  'message.',
            ),
            DocsStateFact(
              state: 'Disabled',
              treatment:
                  'N/A as a whole-widget state: the nearest equivalent is '
                  'per-entry: ElBreadcrumbEntry.page is permanently '
                  'non-interactive.',
              userSignal: 'See Current page above.',
            ),
            DocsStateFact(
              state: 'Reduced motion',
              treatment:
                  'The hover transition is read through '
                  'elAnimationDuration, which collapses to Duration.zero '
                  'under MediaQuery.disableAnimations.',
              userSignal:
                  'The ink still changes on hover; it snaps instead of '
                  'easing.',
            ),
          ],
        ),
      ),
      ElSection(
        id: 'accessibility',
        title: 'Accessibility',
        child: ElPanel(
          label: 'What the semantics tree actually carries',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _A11yRow(
                'Semantic role',
                'The root wraps every crumb in Semantics(container: true, '
                    "label: 'breadcrumb', explicitChildNodes: true): a "
                    'labelled container, read by a screen reader as a group '
                    "named \"breadcrumb\".",
              ),
              _A11yRow(
                'Per-crumb role',
                'Each link crumb carries Semantics(link: true); the current '
                    'page adds enabled: false on top of that. Both derive '
                    'their accessible name from the rendered label: no '
                    'separate override is passed.',
              ),
              _A11yRow(
                'Keyboard interactions',
                'None today. The link crumb has no Focus/FocusNode, so a '
                    'keyboard-only user cannot Tab to a crumb or activate one '
                    'with Enter or Space; only pointer and touch taps are '
                    'wired.',
              ),
              _A11yRow(
                'Focus behavior',
                'Nothing to describe beyond Keyboard above: the widget '
                    'never receives focus.',
              ),
              _A11yRow(
                'Touch target',
                "No minimum tap-area padding is applied: the hit region "
                    "is exactly the rendered text's box. Keep crumb labels "
                    'short on mobile rather than relying on a generous tap '
                    'target.',
              ),
              _A11yRow(
                'Non-color signal',
                'The current page also stops responding to hover and tap, '
                    'so it is not distinguished by ink color alone. Link '
                    'crumbs among themselves are told apart only by their '
                    'labels.',
              ),
              _A11yRow(
                'Error wiring',
                'None, ElBreadcrumb never participates in form validation '
                    'or an error state.',
              ),
              _A11yRow(
                'Screen-reader announcements',
                'None beyond the static labels above; nothing here is '
                    'live or dynamic.',
              ),
              _A11yRow(
                'Platform differences',
                'None observed: the same Semantics tree renders '
                    'identically across every Flutter platform target.',
                last: true,
              ),
            ],
          ),
        ),
      ),
      ElSection(
        id: 'responsive',
        title: 'Responsive',
        description:
            "Breadcrumb's real overflow story: it wraps, it does not "
            'truncate or collapse.',
        child: ElPanel(
          label: 'What happens on a narrow viewport',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ElText(
                'The list lays out as a Wrap (spacing and runSpacing both '
                'set to ElBreadcrumb.gap, crossAxisAlignment centered), '
                "the same shape Tailwind's flex flex-wrap gives the "
                'reference, not a fixed single-line Row.',
                ElType.small,
              ),
              SizedBox(height: el(3)),
              ElText(
                'Once a row of crumbs and separators would overflow the '
                'available width, the trail wraps onto a second line. '
                'Nothing is clipped, scrolled, or replaced with an ellipsis.',
                ElType.small,
              ),
              SizedBox(height: el(3)),
              ElText(
                'BreadcrumbEllipsis is recorded in the source\'s own doc '
                'comment as an export the underlying reference carries, but '
                'no Flutter widget builds a collapsed trail: the port '
                'renders none because the page it was measured against '
                'never mounts one either. Do not reach for a collapsing '
                'behavior this component does not have.',
                ElType.small,
              ),
              SizedBox(height: el(3)),
              ElText(
                'The pointer hover transition needs a mouse; on touch-only '
                'platforms the tap still fires immediately, it just never '
                'shows the intermediate brightening color.',
                ElType.small,
              ),
            ],
          ),
        ),
      ),
      ElSection(
        id: 'dependencies',
        title: 'Dependencies',
        description:
            "Elattar's own technical-transparency panel: what this "
            'component needs, and what has not been wired into the '
            'registry yet.',
        child: DocsInstallFacts(
          title: 'Install facts',
          facts: <DocsInstallFact>[
            const DocsInstallFact(
              label: 'Status',
              value: 'Stable primitive: no variants, sizes, or async states',
              description:
                  'ElBreadcrumb and ElBreadcrumbEntry are both exported from '
                  'the public barrel today.',
            ),
            const DocsInstallFact(
              label: 'Version',
              value: '0.0.1',
              description: 'Package version this page was written against.',
            ),
            const DocsInstallFact(
              label: 'Registry item',
              value: 'registry/components/breadcrumb.json',
              description:
                  'No registry/components/breadcrumb.json exists in this '
                  'checkout: breadcrumb has not been wired into the CLI '
                  'registry yet.',
            ),
            const DocsInstallFact(
              label: 'Destination',
              value: 'lib/components/ui/breadcrumb.dart',
              description:
                  'The same lib/components/ui/ target every other '
                  'component installs to, in both foundation modes: once a '
                  'manifest exists to carry it there.',
            ),
            const DocsInstallFact(
              label: 'Foundation',
              value: 'source or package compatible',
              description:
                  'The source only imports foundation/*, theme_scope.dart, '
                  'and icon.dart: nothing package-mode-only.',
            ),
            DocsInstallFact(
              label: 'Dependencies',
              value: entry.dependencies.join(', '),
              description:
                  'Real transitive needs: the foundation modules and the '
                  'already-published icon registry item: not yet resolved '
                  'automatically, because no manifest names them.',
            ),
            const DocsInstallFact(
              label: 'Assets',
              value: 'none',
              description: 'No image, font, or shader asset is referenced.',
            ),
            const DocsInstallFact(
              label: 'Shaders',
              value: 'none',
              description: 'Not applicable.',
            ),
            const DocsInstallFact(
              label: 'Platforms',
              value: 'Android, iOS, Web, macOS, Windows, Linux',
              description: 'Pure widget composition; nothing platform-gated.',
            ),
            const DocsInstallFact(
              label: 'Verified',
              value: 'package tests + this docs specimen',
              description:
                  "test/navigation_test.dart's ElBreadcrumb group "
                  '(spacing, derived separators, current-page semantics and '
                  'taps, RTL reading order) plus this page\'s live specimen. '
                  'Fixture install coverage is still missing, even though a registry manifest '
                  'does.',
            ),
          ],
        ),
      ),
      ElSection(
        id: 'theming',
        title: 'Theming',
        child: ElPanel(
          label: 'What actually varies with the theme',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ElText(
                'ElBreadcrumb carries no fill, border, or surface of its '
                'own: it only sets type and ink. Every crumb, link and '
                'page alike, renders at ElComponentType.textSm; the weight '
                'never changes.',
                ElType.small,
              ),
              SizedBox(height: el(3)),
              ElText(
                'Ink is the whole story: theme.mutedForeground at rest, '
                'theme.foreground on hover or for the current page. Both '
                'come from the DefaultTextStyle that wraps the entire Wrap, '
                'and the separator\'s ElIconTone.inherit reads that same '
                'ambient style: the Flutter equivalent of a currentColor '
                'stroke.',
                ElType.small,
              ),
              SizedBox(height: el(3)),
              ElText(
                'Because color is the only token in play, a custom theme '
                'only has to keep mutedForeground and foreground legibly '
                'distinct in both light and dark: there is no dedicated '
                'breadcrumb-*, background, or border role to override.',
                ElType.small,
              ),
            ],
          ),
        ),
      ),
      ElSection(
        id: 'source',
        title: 'Source',
        child: DocsInstallFacts(
          title: 'Source and tests',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Source',
              value: entry.sourcePath,
              description: 'The authoritative package source.',
            ),
            const DocsInstallFact(
              label: 'GitHub',
              value:
                  'github.com/ELATTAR-Ayoub/flutter-design-system/blob/v0.0.1/'
                  'lib/src/components/breadcrumb.dart',
              description:
                  "The same blob path every published registry item's "
                  'sourceLink points at.',
            ),
            const DocsInstallFact(
              label: 'Tests',
              value: 'test/navigation_test.dart (ElBreadcrumb group)',
              description:
                  'Package-level behavioral coverage: spacing constants, '
                  'derived separators, current-page semantics and taps, RTL '
                  'reading order.',
            ),
            const DocsInstallFact(
              label: 'Docs specimen',
              value: 'example/test/components_docs/breadcrumb_test.dart',
              description:
                  "This page's own responsive, theme, and "
                  'API-completeness coverage.',
            ),
          ],
        ),
      ),
    ],
  );
}

const String _usageCode =
    '''import 'package:elattar_design_system/elattar_design_system.dart';

ElBreadcrumb(
  items: <ElBreadcrumbEntry>[
    ElBreadcrumbEntry.link('Dashboard', onTap: () {}),
    ElBreadcrumbEntry.link('Projects', onTap: () {}),
    ElBreadcrumbEntry.page('Nova Redesign'),
  ],
)''';

const String _compositionCode =
    '''// nav: Semantics(container: true, label: 'breadcrumb')
//  ol: DefaultTextStyle(text-sm, muted-foreground) around a Wrap
//   li: one _DsCrumb per entry, gap 6px
//    a / span: ElBreadcrumbEntry.link renders a tappable crumb,
//              ElBreadcrumbEntry.page renders the inert current page
//   li (separator): a derived 14px chevron between every adjacent pair,
//                   excluded from the semantics tree''';

const String _linkComponentCode = '''ElBreadcrumbEntry.link(
  'Projects',
  // Swap in whatever routing this app already uses: go_router,
  // Navigator, or anything else. ElBreadcrumb never imports a router
  // itself, onTap is the whole seam.
  onTap: () => Navigator.of(context).pushNamed('/projects'),
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ElBreadcrumb(
    items: <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('الرئيسية'),
      ElBreadcrumbEntry.page('الإعدادات'),
    ],
  ),
)''';

class _A11yRow extends StatelessWidget {
  const _A11yRow(this.label, this.body, {this.last = false});

  final String label;
  final String body;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : el(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElText(label, ElType.section, color: theme.actionInk),
          SizedBox(height: el(1)),
          ElText(body, ElType.small),
        ],
      ),
    );
  }
}

class _BreadcrumbPreview extends StatelessWidget {
  const _BreadcrumbPreview();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      ElText('Typical trail', ElType.section),
      SizedBox(height: el(2)),
      const ElBreadcrumb(
        items: <ElBreadcrumbEntry>[
          ElBreadcrumbEntry.link('Dashboard'),
          ElBreadcrumbEntry.link('Projects'),
          ElBreadcrumbEntry.page('Nova Redesign'),
        ],
      ),
      SizedBox(height: el(6)),
      ElText('Single crumb: no separator to derive', ElType.section),
      SizedBox(height: el(2)),
      const ElBreadcrumb(
        items: <ElBreadcrumbEntry>[ElBreadcrumbEntry.page('Only crumb')],
      ),
    ],
  );
}

class _BreadcrumbBasic extends StatelessWidget {
  const _BreadcrumbBasic();

  @override
  Widget build(BuildContext context) => const ElBreadcrumb(
    items: <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Dashboard'),
      ElBreadcrumbEntry.link('Projects'),
      ElBreadcrumbEntry.page('Nova Redesign'),
    ],
  );
}

class _BreadcrumbRtl extends StatelessWidget {
  const _BreadcrumbRtl();

  @override
  Widget build(BuildContext context) => const Directionality(
    textDirection: TextDirection.rtl,
    child: ElBreadcrumb(
      items: <ElBreadcrumbEntry>[
        ElBreadcrumbEntry.link('الرئيسية'),
        ElBreadcrumbEntry.page('الإعدادات'),
      ],
    ),
  );
}

class _BreadcrumbComposition extends StatelessWidget {
  const _BreadcrumbComposition();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const ElBreadcrumb(
        items: <ElBreadcrumbEntry>[
          ElBreadcrumbEntry.link('Dashboard'),
          ElBreadcrumbEntry.link('Projects'),
          ElBreadcrumbEntry.page('Nova Redesign'),
        ],
      ),
      SizedBox(height: el(3)),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ElText(
              'Nova Redesign',
              ElType.h3,
              color: ElTheme.of(context).foreground,
            ),
          ),
          SizedBox(width: el(3)),
          ElButton(
            variant: ElButtonVariant.outline,
            onPressed: () {},
            child: const Text('Share'),
          ),
        ],
      ),
    ],
  );
}
