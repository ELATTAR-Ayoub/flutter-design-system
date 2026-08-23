/// Public component documentation for the breadcrumb component.
///
/// `breadcrumb` is Wave 1 of the component-documentation plan and carries no
/// `registry/components/breadcrumb.json` manifest yet — the Installation
/// section says so plainly rather than rendering `elattar add breadcrumb` as
/// if it worked. See `meta.dart` for the same note against
/// [ComponentDocEntry.command].
///
/// The eighteen IA §9.1 sections map onto this page as: breadcrumb/family,
/// title and short description come from [DocsLayout] itself; the expanded
/// "when to use this instead of a neighbour" guidance lives in
/// [DocsPageIntro.description] below; status/version/platform metadata get
/// their own compact panel; preview, installation, usage, API, entry types
/// (this component's honest answer to "variants and sizes"), states,
/// accessibility, responsive behaviour, the full install-facts disclosure,
/// a composition example, theming notes, and source/tests each get a
/// [DsSection]; previous/next comes from [DocsLayout] again.
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
            'a detail page the user drilled into — not for switching between '
            'sibling views (that is Tabs), paging through one list '
            '(Pagination), or a site\'s top-level sections (Navigation Menu). '
            'The trail derives its own separators and wraps onto a new line '
            'instead of collapsing when it runs out of room.',
      ),
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Breadcrumb'),
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
        DocsTocEntry(title: 'Status', anchor: 'status'),
        DocsTocEntry(title: 'Preview', anchor: 'preview'),
        DocsTocEntry(title: 'Install', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'API', anchor: 'api'),
        DocsTocEntry(title: 'Entry types', anchor: 'entry-types'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
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
      DsSection(
        id: 'status',
        title: 'Status',
        child: const DocsInstallFacts(
          title: 'Status',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Status',
              value: 'Stable primitive — no variants, sizes, or async states',
              description:
                  'DsBreadcrumb and DsBreadcrumbEntry are both exported from '
                  'the public barrel today.',
            ),
            DocsInstallFact(
              label: 'Version',
              value: '0.0.1',
              description: 'Package version this page was written against.',
            ),
            DocsInstallFact(
              label: 'Platforms',
              value: 'Android, iOS, Web, macOS, Windows, Linux',
              description:
                  'Pure Flutter composition — nothing here is platform-gated.',
            ),
          ],
        ),
      ),
      DsSection(
        id: 'preview',
        title: 'Preview',
        description:
            'A typical multi-step trail, a single current-page crumb '
            '(which renders no separator at all), and the same composition '
            'read right-to-left under a Directionality — the port\'s own '
            'proof that direction is context, not a second set of controls.',
        child: const DocsCodeExample(
          title: 'Breadcrumb specimens',
          description:
              'Hover a link crumb to see the ink brighten; the current page '
              'never responds to hover or tap.',
          preview: _BreadcrumbPreview(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/breadcrumb.dart',
              code:
                  "import 'package:flutter/widgets.dart';\n\n"
                  '// No registry manifest exists for breadcrumb yet — copy\n'
                  '// lib/src/components/breadcrumb.dart directly and update its\n'
                  '// relative imports (foundation/*, theme_scope.dart, icon.dart)\n'
                  '// to wherever you land them. See the Installation section below.',
            ),
          ],
        ),
      ),
      DsSection(
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
              value: 'Not available yet',
              description:
                  'registry/components/breadcrumb.json does not exist in '
                  'this checkout, so `elattar add breadcrumb` has nothing to '
                  'resolve and will fail against the real registry client.',
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
      DsSection(
        id: 'usage',
        title: 'Usage',
        description:
            'The smallest correct composition — three steps, the last one '
            'the current page.',
        child: DsPanel(
          label: 'DART',
          note: 'COMPOSE',
          child: DocsSelectableCodeBlock(code: _usageCode),
        ),
      ),
      DsSection(
        id: 'api',
        title: 'API',
        description:
            'Every public class, constructor, field, and static layout '
            'constant the source declares.',
        child: const DocsApiTable(
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'items',
              type: 'List<DsBreadcrumbEntry>',
              description:
                  'Required. The ordered trail. A chevron separator is '
                  'derived between every adjacent pair — there is no way to '
                  'place two crumbs with no separator between them.',
            ),
            DocsApiFact(
              name: 'gap',
              type: 'static double (get)',
              description:
                  "6px — the list's own Wrap spacing and runSpacing, on "
                  'both axes, since it can wrap onto more than one line.',
            ),
            DocsApiFact(
              name: 'separatorPx',
              type: 'static double (get)',
              description: "14px — the derived chevron separator's own box.",
            ),
            DocsApiFact(
              name: 'DsBreadcrumbEntry.link(label, {onTap})',
              type: 'const factory',
              description:
                  'A step back in the trail. label is required and '
                  'positional; onTap is optional (default null) — a link '
                  'with no onTap is inert but still styled and semantically '
                  'a link.',
            ),
            DocsApiFact(
              name: 'DsBreadcrumbEntry.page(label)',
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
                  'Only ever set by DsBreadcrumbEntry.link; always null on '
                  'a page entry.',
            ),
            DocsApiFact(
              name: 'isPage',
              type: 'bool',
              description:
                  'Derived, not a constructor parameter of its own — true '
                  'for entries built with .page, false for .link. Read-only.',
            ),
          ],
        ),
      ),
      DsSection(
        id: 'entry-types',
        title: 'Entry types — no variant or size enum',
        description:
            'There is no DsBreadcrumbVariant or DsBreadcrumbSize to choose '
            'from. The only per-crumb decision is which constructor built '
            'the entry, and the API table above already names both.',
        child: DsPanel(
          label: 'The two constructors, side by side',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(
                'DsBreadcrumbEntry.link — a step in the trail. Muted at '
                'rest, brightens on hover, and calls onTap when pressed.',
                DsType.small,
              ),
              SizedBox(height: ds(2)),
              DsText(
                'DsBreadcrumbEntry.page — the current page. Always at full '
                "ink strength, never a link, and inert to both hover and "
                'tap.',
                DsType.small,
              ),
            ],
          ),
        ),
      ),
      DsSection(
        id: 'states',
        title: 'States and feedback',
        description:
            'Rows that do not apply to a synchronous, variant-free '
            'primitive are marked N/A with the reason, rather than invented.',
        child: const DocsStateMatrix(
          facts: <DocsStateFact>[
            DocsStateFact(
              state: 'Rest (link crumb)',
              treatment: 'DsComponentType.textSm at theme.mutedForeground.',
              userSignal:
                  'Reads as secondary, quiet text until interacted with.',
            ),
            DocsStateFact(
              state: 'Hover (link crumb)',
              treatment:
                  'Animates to theme.foreground over '
                  'dsAnimationDuration(context, DsDurations.transitionDefault) '
                  'on DsCurves.out.',
              userSignal:
                  'The crumb brightens toward full-strength text and the '
                  'cursor becomes a pointer.',
            ),
            DocsStateFact(
              state: 'Current page (DsBreadcrumbEntry.page)',
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
                  'N/A — the link crumb wraps a MouseRegion and a '
                  'GestureDetector but no Focus/FocusNode, so it never '
                  'enters keyboard Tab order and paints no focus ring.',
              userSignal:
                  'A keyboard-only visitor cannot reach a crumb today — see '
                  'Accessibility.',
            ),
            DocsStateFact(
              state: 'Pressed',
              treatment:
                  'N/A — GestureDetector.onTap fires with no intermediate '
                  'pressed-state paint; there is no DsPress scale or '
                  'opacity step here.',
              userSignal: 'A tap or click resolves in a single frame.',
            ),
            DocsStateFact(
              state: 'Loading / Error / Success',
              treatment:
                  'N/A — DsBreadcrumb is a synchronous rendering primitive '
                  'with no future, stream, or error boundary of its own.',
              userSignal: 'Not applicable.',
            ),
            DocsStateFact(
              state: 'Empty items',
              treatment:
                  'N/A as a dedicated state — DsBreadcrumb(items: const '
                  '[]) renders a zero-size Wrap: no crumbs, no separators, '
                  'no placeholder text.',
              userSignal:
                  'The control disappears rather than showing a '
                  'message.',
            ),
            DocsStateFact(
              state: 'Disabled',
              treatment:
                  'N/A as a whole-widget state — the nearest equivalent is '
                  'per-entry: DsBreadcrumbEntry.page is permanently '
                  'non-interactive.',
              userSignal: 'See Current page above.',
            ),
            DocsStateFact(
              state: 'Reduced motion',
              treatment:
                  'The hover transition is read through '
                  'dsAnimationDuration, which collapses to Duration.zero '
                  'under MediaQuery.disableAnimations.',
              userSignal:
                  'The ink still changes on hover; it snaps instead of '
                  'easing.',
            ),
          ],
        ),
      ),
      DsSection(
        id: 'accessibility',
        title: 'Accessibility and keyboard behavior',
        child: DsPanel(
          label: 'What the semantics tree actually carries',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _A11yRow(
                'Semantic role',
                'The root wraps every crumb in Semantics(container: true, '
                    "label: 'breadcrumb', explicitChildNodes: true) — a "
                    'labelled container, read by a screen reader as a group '
                    "named \"breadcrumb\".",
              ),
              _A11yRow(
                'Per-crumb role',
                'Each link crumb carries Semantics(link: true); the current '
                    'page adds enabled: false on top of that. Both derive '
                    'their accessible name from the rendered label — no '
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
                'Nothing to describe beyond Keyboard above — the widget '
                    'never receives focus.',
              ),
              _A11yRow(
                'Touch target',
                "No minimum tap-area padding is applied — the hit region "
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
                'None — DsBreadcrumb never participates in form validation '
                    'or an error state.',
              ),
              _A11yRow(
                'Screen-reader announcements',
                'None beyond the static labels above; nothing here is '
                    'live or dynamic.',
              ),
              _A11yRow(
                'Platform differences',
                'None observed — the same Semantics tree renders '
                    'identically across every Flutter platform target.',
                last: true,
              ),
            ],
          ),
        ),
      ),
      DsSection(
        id: 'responsive',
        title: 'Responsive and platform behavior',
        description:
            "Breadcrumb's real overflow story: it wraps, it does not "
            'truncate or collapse.',
        child: DsPanel(
          label: 'What happens on a narrow viewport',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(
                'The list lays out as a Wrap (spacing and runSpacing both '
                'set to DsBreadcrumb.gap, crossAxisAlignment centered) — '
                "the same shape Tailwind's flex flex-wrap gives the "
                'reference, not a fixed single-line Row.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'Once a row of crumbs and separators would overflow the '
                'available width, the trail wraps onto a second line. '
                'Nothing is clipped, scrolled, or replaced with an ellipsis.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'BreadcrumbEllipsis is recorded in the source\'s own doc '
                'comment as an export the underlying reference carries, but '
                'no Flutter widget builds a collapsed trail — the port '
                'renders none because the page it was measured against '
                'never mounts one either. Do not reach for a collapsing '
                'behavior this component does not have.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'The pointer hover transition needs a mouse; on touch-only '
                'platforms the tap still fires immediately, it just never '
                'shows the intermediate brightening color.',
                DsType.small,
              ),
            ],
          ),
        ),
      ),
      DsSection(
        id: 'dependencies',
        title: 'Dependencies, files, and disclosure',
        description:
            "Elattar's own technical-transparency panel — what this "
            'component needs, and what has not been wired into the '
            'registry yet.',
        child: DocsInstallFacts(
          title: 'Install facts',
          facts: <DocsInstallFact>[
            const DocsInstallFact(
              label: 'Registry item',
              value: 'Not yet published',
              description:
                  'No registry/components/breadcrumb.json exists in this '
                  'checkout — breadcrumb has not been wired into the CLI '
                  'registry yet.',
            ),
            const DocsInstallFact(
              label: 'Destination',
              value: 'lib/components/ui/breadcrumb.dart',
              description:
                  'The same lib/components/ui/ target every other '
                  'component installs to, in both foundation modes — once a '
                  'manifest exists to carry it there.',
            ),
            const DocsInstallFact(
              label: 'Foundation',
              value: 'source or package compatible',
              description:
                  'The source only imports foundation/*, theme_scope.dart, '
                  'and icon.dart — nothing package-mode-only.',
            ),
            DocsInstallFact(
              label: 'Dependencies',
              value: entry.dependencies.join(', '),
              description:
                  'Real transitive needs — the foundation modules and the '
                  'already-published icon registry item — not yet resolved '
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
                  "test/navigation_test.dart's DsBreadcrumb group "
                  '(spacing, derived separators, current-page semantics and '
                  'taps, RTL reading order) plus this page\'s live specimen. '
                  'No fixture install exists, because no registry manifest '
                  'does.',
            ),
          ],
        ),
      ),
      DsSection(
        id: 'composition',
        title: 'Composition example',
        description:
            'Breadcrumb sitting above a page title and an action — its '
            'usual home, rather than the isolated specimen above.',
        child: const DocsCodeExample(
          title: 'Page header composition',
          preview: _BreadcrumbComposition(),
        ),
      ),
      DsSection(
        id: 'theming',
        title: 'Theming notes',
        child: DsPanel(
          label: 'What actually varies with the theme',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(
                'DsBreadcrumb carries no fill, border, or surface of its '
                'own — it only sets type and ink. Every crumb, link and '
                'page alike, renders at DsComponentType.textSm; the weight '
                'never changes.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'Ink is the whole story: theme.mutedForeground at rest, '
                'theme.foreground on hover or for the current page. Both '
                'come from the DefaultTextStyle that wraps the entire Wrap, '
                'and the separator\'s DsIconTone.inherit reads that same '
                'ambient style — the Flutter equivalent of a currentColor '
                'stroke.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'Because color is the only token in play, a custom theme '
                'only has to keep mutedForeground and foreground legibly '
                'distinct in both light and dark — there is no dedicated '
                'breadcrumb-*, background, or border role to override.',
                DsType.small,
              ),
            ],
          ),
        ),
      ),
      DsSection(
        id: 'source',
        title: 'Source and tests',
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
                  'github.com/ELATTAR-Ayoub/flutter-design-system/blob/main/'
                  'lib/src/components/breadcrumb.dart',
              description:
                  "The same blob path every published registry item's "
                  'sourceLink points at.',
            ),
            const DocsInstallFact(
              label: 'Tests',
              value: 'test/navigation_test.dart (DsBreadcrumb group)',
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

DsBreadcrumb(
  items: <DsBreadcrumbEntry>[
    DsBreadcrumbEntry.link('Dashboard', onTap: () {}),
    DsBreadcrumbEntry.link('Projects', onTap: () {}),
    DsBreadcrumbEntry.page('Nova Redesign'),
  ],
)''';

class _A11yRow extends StatelessWidget {
  const _A11yRow(this.label, this.body, {this.last = false});

  final String label;
  final String body;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : ds(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(label, DsType.label, color: theme.actionInk),
          SizedBox(height: ds(1)),
          DsText(body, DsType.small),
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
      DsText('Typical trail', DsType.label),
      SizedBox(height: ds(2)),
      const DsBreadcrumb(
        items: <DsBreadcrumbEntry>[
          DsBreadcrumbEntry.link('Dashboard'),
          DsBreadcrumbEntry.link('Projects'),
          DsBreadcrumbEntry.page('Nova Redesign'),
        ],
      ),
      SizedBox(height: ds(6)),
      DsText('Single crumb — no separator to derive', DsType.label),
      SizedBox(height: ds(2)),
      const DsBreadcrumb(
        items: <DsBreadcrumbEntry>[DsBreadcrumbEntry.page('Only crumb')],
      ),
      SizedBox(height: ds(6)),
      DsText('Right-to-left, same composition', DsType.label),
      SizedBox(height: ds(2)),
      const Directionality(
        textDirection: TextDirection.rtl,
        child: DsBreadcrumb(
          items: <DsBreadcrumbEntry>[
            DsBreadcrumbEntry.link('الرئيسية'),
            DsBreadcrumbEntry.page('الإعدادات'),
          ],
        ),
      ),
    ],
  );
}

class _BreadcrumbComposition extends StatelessWidget {
  const _BreadcrumbComposition();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const DsBreadcrumb(
        items: <DsBreadcrumbEntry>[
          DsBreadcrumbEntry.link('Dashboard'),
          DsBreadcrumbEntry.link('Projects'),
          DsBreadcrumbEntry.page('Nova Redesign'),
        ],
      ),
      SizedBox(height: ds(3)),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: DsText(
              'Nova Redesign',
              DsType.h3,
              color: DsTheme.of(context).foreground,
            ),
          ),
          SizedBox(width: ds(3)),
          DsButton(
            variant: DsButtonVariant.outline,
            onPressed: () {},
            child: const Text('Share'),
          ),
        ],
      ),
    ],
  );
}
