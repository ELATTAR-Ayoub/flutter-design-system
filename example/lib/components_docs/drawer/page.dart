/// Public documentation page for the `drawer` component.
///
/// **Split from a combined page.** `sheet` and `drawer` used to share one
/// page and one `ComponentDocEntry` because they read as the same idea at
/// different edges. The owner asked for one component per page instead: this
/// file documents `lib/src/components/drawer.dart` alone.
/// `lib/src/components/sheet.dart` has its own page and its own directory,
/// `../sheet/page.dart`, not this one.
///
/// **Shape.** Copies `button/page.dart`'s own frame, the reference shape
/// named by Phase J: an unheaded live demo above the first heading, then
/// Installation, Usage, then this component's own sections named for a
/// reader's problem (matching https://ui.shadcn.com/docs/components/base/drawer's
/// own `<h2>` list: Installation, Usage, Composition, Custom Sizes, renamed
/// Sizing here since nothing on this port is actually per-instance
/// customizable), then API Reference last of the shadcn sections — one prop
/// table per real exported class in `drawer.dart`, each its own nested TOC
/// entry — then exactly States, Accessibility, Responsive, Dependencies,
/// Theming, Source.
///
/// **Skipped, honestly.** Eight of the reference's own sections describe a
/// capability this port genuinely does not have, and rather than fake one,
/// each is recorded in the Sizing section's own SKIPPED panel instead of
/// getting a section of its own: Styling, Position, Swipe handle, Nested,
/// Non modal, Snap points, Responsive-by-composition, and Migrating from
/// Vaul.
///
/// No expanded hero paragraph: the short one-line `description` on
/// [drawerDoc] is the only prose above Installation.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class DrawerDocPage extends StatelessWidget {
  const DrawerDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: drawerDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / OVERLAYS',
      title: drawerDoc.title,
      description: drawerDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Drawer'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Sizing', anchor: 'sizing'),
      DocsTocEntry(
        title: 'API Reference',
        anchor: 'api',
        children: <DocsTocEntry>[
          DocsTocEntry(title: 'ElDrawer', anchor: 'api-eldrawer'),
          DocsTocEntry(title: 'ElDrawerContent', anchor: 'api-eldrawercontent'),
          DocsTocEntry(
            title: 'ElDrawerContent static helpers',
            anchor: 'api-eldrawercontent-static',
          ),
          DocsTocEntry(title: 'ElDrawerHandle', anchor: 'api-eldrawerhandle'),
          DocsTocEntry(title: 'ElDrawerHeader', anchor: 'api-eldrawerheader'),
          DocsTocEntry(title: 'ElDrawerFooter', anchor: 'api-eldrawerfooter'),
          DocsTocEntry(title: 'ElDrawerTitle', anchor: 'api-eldrawertitle'),
          DocsTocEntry(
            title: 'ElDrawerDescription',
            anchor: 'api-eldrawerdescription',
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
    previous: const DocsPageLink(title: 'Dialog', route: '/components/dialog'),
    next: const DocsPageLink(
      title: 'Dropdown Menu',
      route: '/components/dropdown_menu',
    ),
    onNavigate: onNavigate,
    child: const _DrawerArticle(),
  );
}

class _DrawerArticle extends StatelessWidget {
  const _DrawerArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('drawer-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _preview(),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        SizedBox(height: el(6)),
        _composition(),
        _sizing(),
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

  /// shadcn: the live demo that opens the page, before any heading.
  Widget _preview() => DocsCodeExample(
    title: 'Drawer',
    description:
        'Open it, then dismiss it by tapping the scrim, pressing Escape, '
        'or dragging it down past the threshold.',
    preview: const _DrawerPreview(keyPrefix: 'drawer-preview'),
    manualFiles: const <DocsCodeFile>[
      DocsCodeFile(path: 'drawer_preview.dart', code: _drawerUsageCode),
    ],
  );

  Widget _install() => ElSection(
    id: 'install',
    title: 'Installation',
    description:
        'Already reachable today through both the published package and the '
        'registry: it is barrel-exported and its shipped manifest resolves '
        'through the elattar CLI.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElPanel(
          label: 'PACKAGE IMPORT',
          note: 'DART',
          child: const DocsSelectableCodeBlock(
            code:
                "import 'package:elattar_design_system/"
                "elattar_design_system.dart';\n",
          ),
        ),
        SizedBox(height: el(4)),
        DocsInstallFacts(
          title: 'Manual and CLI facts',
          facts: <DocsInstallFact>[
            const DocsInstallFact(
              label: 'CLI',
              value: 'elattar add drawer',
              description:
                  'Resolves the shipped registry/components/drawer.json '
                  'manifest. Use the package import above when you want the '
                  'published package, or use the CLI when you want the '
                  'generated local copy.',
            ),
            DocsInstallFact(
              label: 'Manual copy target',
              value: 'lib/components/ui/drawer.dart',
              description:
                  'Copy ${drawerDoc.sourcePath} into components/ui and '
                  'keep its relative imports pointed at the same '
                  'foundation and sibling-component files (dialog.dart in '
                  'particular: see Dependencies).',
            ),
            DocsInstallFact(
              label: 'Registry dependencies',
              value: drawerDoc.dependencies.join(', '),
              description:
                  'What registry/components/drawer.json lists as '
                  'registryDependencies, read directly from the shipped '
                  'manifest.',
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
        'Uncontrolled, like ElDialog: the open/close boolean lives inside '
        'ElModalPortal and the trigger only ever gets a callback. ElDrawer '
        'exposes no onOpenChange callback the way ElDialog does: a real '
        'gap against the dialog\'s own API, not an omission from this '
        'page.',
    child: ElPanel(
      label: 'DART',
      note: 'MINIMAL USAGE',
      child: const DocsSelectableCodeBlock(code: _drawerUsageCode),
    ),
  );

  Widget _composition() => ElSection(
    id: 'composition',
    title: 'Composition',
    description:
        'Read directly off drawer.dart rather than carried from a live '
        'specimen: ElDrawerHandle mounts itself automatically ahead of '
        'ElDrawerContent.children and never appears in caller code.',
    child: ElPanel(
      label: 'DART',
      note: 'ANATOMY',
      child: const DocsSelectableCodeBlock(code: _drawerCompositionCode),
    ),
  );

  Widget _sizing() => ElSection(
    id: 'sizing',
    title: 'Sizing',
    description:
        'ElDrawerContent takes no width or height parameter of its own: '
        'max-height is always ElDrawerContent.maxHeightFraction (80% of '
        'the viewport) below a fixed ElDrawerContent.topGutter (96px) '
        'strip of page it may never cover. Where the reference lets a '
        'caller override height per instance with a Tailwind class, '
        'ElDrawer exposes no matching parameter: every drawer in the app '
        'is sized identically. See ElDrawerContent below in API Reference '
        'for the fixed layout tokens.',
    child: ElPanel(
      label:
          'STYLING, POSITION, SWIPE HANDLE, NESTED, NON MODAL, SNAP '
          'POINTS, RESPONSIVE, MIGRATING FROM VAUL',
      note: 'SKIPPED',
      child: const _Prose(<String>[
        'Styling: the reference\'s data-[state], '
            'data-[vaul-drawer-direction], and CSS custom-property hooks '
            'have no Flutter analogue; ElDrawer exposes no styling surface '
            'beyond the fixed fill/border/radius already documented under '
            'ElDrawerContent below.',
        'Position: ElDrawer opens from the bottom only. drawer.dart\'s own '
            'doc comment records left, right, and top as "not ported": '
            'there is no swipeDirection-equivalent parameter.',
        'Swipe handle: ElDrawerHandle always mounts, unconditionally, '
            'prepended by ElDrawerContent itself. There is no '
            'showSwipeHandle-style toggle to turn it off.',
        'Nested: opening a second ElDrawer from within an open one is not '
            'demonstrated anywhere in the corpus. ElModalPortal\'s own '
            'stack could plausibly support it, but no specimen exists to '
            'verify the reference\'s parent-stays-mounted behavior '
            'against.',
        'Non modal: ElDrawer always mounts a dismissing scrim; there is '
            'no modal: false to let the page keep receiving input while '
            'it is open.',
        'Snap points: also recorded as "not ported" in drawer.dart\'s own '
            'doc comment. The panel is either open at its natural height '
            'or closed; there is no intermediate resting height.',
        'Responsive (pairing Dialog and Drawer by breakpoint): a real, '
            'valid pattern, but no specimen in this corpus composes the '
            'two by MediaQuery width the way the reference\'s own example '
            'does; see this page\'s own Responsive section below for how '
            'the drawer is individually viewport-aware instead.',
        'Migrating from Vaul: the reference\'s own guidance for updating '
            'an existing Vaul integration. Nothing to migrate on a '
            'from-scratch Flutter port.',
      ]),
    ),
  );

  Widget _api() => ElSection(
    id: 'api',
    title: 'API Reference',
    description:
        'Every public constructor parameter declared on every public class '
        'in lib/src/components/drawer.dart: one table each.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-eldrawer'),
          child: const DocsApiTable(title: 'ElDrawer', facts: _drawerFacts),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-eldrawercontent'),
          child: const DocsApiTable(
            title: 'ElDrawerContent',
            facts: _contentFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-eldrawercontent-static'),
          child: const DocsApiTable(
            title: 'ElDrawerContent static helpers',
            facts: _contentStaticFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-eldrawerhandle'),
          child: const DocsApiTable(
            title: 'ElDrawerHandle',
            facts: _handleFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-eldrawerheader'),
          child: const DocsApiTable(
            title: 'ElDrawerHeader',
            facts: _headerFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-eldrawerfooter'),
          child: const DocsApiTable(
            title: 'ElDrawerFooter',
            facts: _footerFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-eldrawertitle'),
          child: const DocsApiTable(title: 'ElDrawerTitle', facts: _titleFacts),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-eldrawerdescription'),
          child: const DocsApiTable(
            title: 'ElDrawerDescription',
            facts: _descriptionFacts,
          ),
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description:
        'Read straight off ElDrawer, ElDrawerContent, and the shared '
        'ElModalPortal it rides.',
    child: const DocsStateMatrix(facts: _stateFacts),
  );

  Widget _accessibility(ElThemeData theme) => ElSection(
    id: 'accessibility',
    title: 'Accessibility and keyboard behavior',
    child: _bullets(theme, <String>[
      'Focus moves INTO the panel on open: ElModalPortal wraps the '
          'content in FocusScope(autofocus: true), so the FocusScopeNode '
          'itself (not a leaf widget) claims primary focus the moment the '
          'overlay mounts.',
      'Focus is trapped while open in the sense that matters for Tab '
          'traversal: once Tab moves focus to a real control inside the '
          'panel, further presses cycle inside the panel rather than '
          'reaching page content behind the scrim.',
      'Closing DOES return focus to the trigger that opened the overlay, '
          'even though ElModalPortal contains no explicit "restore focus" '
          'code of its own: Flutter\'s FocusManager falls back to the '
          'enclosing scope\'s previously-focused child once the overlay\'s '
          'own FocusScope is removed from the tree, as long as the '
          'trigger\'s FocusNode is still mounted when the overlay closes.',
      'Escape closes the topmost open overlay (ElModalPortalState\'s '
          'static stack), matching dialog\'s own Escape contract.',
      'Android back / predictive back dismisses the topmost overlay '
          'unconditionally, the same USER-ORDERED MOBILE ADAPTATION '
          'dialog.dart documents, shared by every ElModalPortal consumer.',
      'No built-in close button at all: unlike Sheet, drawer.dart imports '
          'neither button.dart nor icon.dart. A caller must compose one '
          'and give it its own accessible label.',
      'ElDrawerContent does NOT use ElSafeArea anywhere: a real gap. On a '
          'device with a bottom home indicator, drawer content is not '
          'inset from it.',
      'Touch target: the grip handle ElDrawerHandle renders is 96 x 4 '
          'logical pixels, far under any reasonable touch-target guidance '
          'on its own. The full-width lane it sits in (the whole top '
          'strip of the panel) is what actually receives the drag '
          'gesture, not the visible bar.',
      'ElDrawerTitle and ElDrawerDescription are plain, centred ElText, '
          'not wired to the panel as a Semantics(scopesRoute: true) '
          'accessible name/description pair.',
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive and platform behavior',
    child: _bullets(theme, <String>[
      'Opts OUT of ElModalPortal\'s compact viewport clamp '
          '(clampToViewport: false): the drawer already IS the phone '
          'container, inset-x-0 is a full-bleed width a 90vw cap would '
          'break.',
      'Clamps its own height instead: max-height is always 80% of the '
          'viewport (ElDrawerContent.maxHeightFraction), on every screen '
          'size, with a fixed 96px top gutter (ElDrawerContent.topGutter) '
          'it may never cover.',
      'The body is deliberately NOT independently scrollable: a nested '
          'Scrollable would win the gesture arena against the '
          'drag-to-dismiss recognizer wrapped around the whole panel. '
          'vaul\'s own answer, only drag when the inner scroller is '
          'already at its top, is not ported.',
      'No breakpoint branching for the layout decision itself: the same '
          'widget tree renders at 390px and 1440px, only the resolved '
          'max-height value changes.',
      'Platform parity: the drag gesture uses '
          'PointerDeviceKind-agnostic recognizers (RawGestureDetector + '
          'VerticalDragGestureRecognizer), so mouse and touch both drive '
          'it identically; no dart:io Platform branch anywhere in the '
          'file.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies, files, and install facts',
    child: _bullets(theme, <String>[
      'File: lib/src/components/drawer.dart: one file, no companions.',
      'Flutter imports: package:flutter/gestures.dart '
          '(VerticalDragGestureRecognizer), package:flutter/rendering.dart '
          '(RenderProxyBox, for the internal height-measuring render '
          'object), package:flutter/widgets.dart.',
      'Foundation imports: foundation/motion.dart, foundation/spacing.dart, '
          'foundation/theme.dart, foundation/typography.dart, '
          'theme_scope.dart (ElText, ElTheme).',
      'Component imports: dialog.dart only (ElModalPortal, '
          'ElModalTriggerBuilder, ElModalContentBuilder). No button.dart, '
          'no icon.dart: matching the lack of a built-in close button.',
      'registryDependencies, read directly from the shipped manifest (no manifest yet): '
          'source-foundation, dialog.',
      'Assets, fonts, shaders: none, though its motion is worth flagging '
          'even without an asset: driven by ElCurves.vaul and '
          'ElDurations.drawer rather than the shared ElDurations.overlay / '
          'ElCurves.out tokens every other ElModalPortal consumer uses.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming notes',
    child: _bullets(theme, <String>[
      'theme.popover always fills the panel; there is no fill override '
          'parameter, a real gap against Sheet\'s own fill parameter.',
      'theme.border paints the single hairline seam on the panel\'s top '
          'edge.',
      'theme.muted paints ElDrawerHandle\'s grip pill. drawer.dart never '
          'reads ElShadows: the panel carries no elevation/shadow spec at '
          'all, unlike Sheet\'s ElShadows.tailwindLg.',
      'ElRadii.xl (16px) rounds the top corners only (rounded-t-xl); the '
          'bottom stays square, flush with the viewport edge.',
      'ElDrawerHeader and ElDrawerFooter carry NO muted band or rule of '
          'their own: plain padded columns, a real anatomy difference '
          'from Sheet\'s own header/footer, which do band and rule.',
      'Every colour is read live off ElTheme.of(context) at build time. '
          'Flipping ElThemeController re-resolves every one on the next '
          'frame: nothing is cached.',
    ]),
  );

  Widget _source() => ElSection(
    id: 'source',
    title: 'Source, tests, and docs',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source',
          value: drawerDoc.sourcePath,
          description:
              'Authoritative implementation: the truth this page was '
              'written from.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'test/dialogs_test.dart',
          description:
              'ElDrawer is covered inside this suite; there is no '
              'dedicated drawer_test.dart in the package itself.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/drawer_test.dart',
          description:
              'Covers this page: the article mounts, every documented '
              'constructor parameter appears in an API table, the section '
              'order matches this file, and a live ElDrawer actually '
              'opens, drags past the close threshold, and dismisses.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/drawer/page.dart',
          description: 'This file.',
        ),
      ],
    ),
  );
}

/// The primary live specimen: one real [ElDrawer], keyed by [keyPrefix] so
/// the same specimen shape can be reused at more than one call site on this
/// page without a duplicate-key collision.
class _DrawerPreview extends StatelessWidget {
  const _DrawerPreview({required this.keyPrefix});

  final String keyPrefix;

  @override
  Widget build(BuildContext context) => ElDrawer(
    trigger: (BuildContext context, VoidCallback open) => ElButton(
      key: ValueKey<String>('$keyPrefix-trigger'),
      variant: ElButtonVariant.secondary,
      onPressed: open,
      child: const Text('Open drawer'),
    ),
    content: (BuildContext context, VoidCallback close) => ElDrawerContent(
      children: <Widget>[
        const ElDrawerHeader(
          children: <Widget>[
            ElDrawerTitle('Card actions'),
            ElDrawerDescription(
              'Drag down to dismiss, or use the buttons below.',
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: el(4)),
          child: ElButton(
            expanded: true,
            onPressed: close,
            child: const Text('Close'),
          ),
        ),
        ElDrawerFooter(
          children: <Widget>[
            ElButton(
              variant: ElButtonVariant.outline,
              onPressed: close,
              child: const Text('Cancel'),
            ),
          ],
        ),
      ],
    ),
  );
}

/// Plain, left-aligned paragraphs constrained to the article's prose
/// measure: used for the Sizing section's SKIPPED note.
class _Prose extends StatelessWidget {
  const _Prose(this.paragraphs);

  final List<String> paragraphs;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: ElWidths.prose),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < paragraphs.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: el(3)),
          ElText(paragraphs[i], ElType.small),
        ],
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

const String _drawerUsageCode = '''ElDrawer(
  trigger: (context, open) => ElButton(
    onPressed: open,
    child: const Text('Card actions'),
  ),
  content: (context, close) => ElDrawerContent(
    children: <Widget>[
      ElDrawerHeader(children: <Widget>[
        ElDrawerTitle('Voidwing Ascendant'),
        ElDrawerDescription('Eclipse Vault · #044 · Legendary'),
      ]),
      ElDrawerFooter(children: <Widget>[
        ElButton(onPressed: close, child: const Text('Sell for \$1,240.00')),
      ]),
    ],
  ),
)''';

/// Drawer's anatomy, read directly off drawer.dart rather than carried from
/// a live specimen: ElDrawerHandle mounts itself automatically ahead of
/// [ElDrawerContent.children] and never appears in caller code.
const String _drawerCompositionCode = '''ElDrawer(
  trigger: (context, open) => ..., // builds the opener
  content: (context, close) => ElDrawerContent(
    children: <Widget>[
      // ElDrawerHandle is NOT listed here: ElDrawerContent prepends it
      // to the column itself, unconditionally, ahead of these children.
      ElDrawerHeader(children: <Widget>[
        ElDrawerTitle('...'),
        ElDrawerDescription('...'),
      ]),
      ..., // the body: any widget, not independently scrollable
      ElDrawerFooter(children: <Widget>[
        ElButton(onPressed: close, child: const Text('...')),
      ]),
    ],
  ),
)''';

const List<DocsApiFact> _drawerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'trigger',
    type: 'ElModalTriggerBuilder',
    description: 'Required. Builds the control that opens the portal.',
  ),
  DocsApiFact(
    name: 'content',
    type: 'ElModalContentBuilder',
    description:
        'Required. Builds the panel and receives its close callback. '
        'ElDrawer wraps the built content in its own vertical drag '
        'gesture detector before mounting it.',
  ),
];

const List<DocsApiFact> _contentFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. The column\'s contents. A ElDrawerHandle is prepended '
        'automatically ahead of these; it is not one of these children '
        'and cannot be turned off.',
  ),
];

const List<DocsApiFact> _contentStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElDrawerContent.topGutter',
    type: 'static double',
    description:
        '96px (el(24)): the strip of page the drawer may never cover, '
        'even at its tallest.',
  ),
  DocsApiFact(
    name: 'ElDrawerContent.maxHeightFraction',
    type: 'static const double',
    description: '0.8: the panel never exceeds 80% of the viewport height.',
  ),
  DocsApiFact(
    name: 'ElDrawerContent.radius',
    type: 'static double',
    description: 'ElRadii.xl (16px): the top corners only.',
  ),
];

const List<DocsApiFact> _handleFacts = <DocsApiFact>[
  DocsApiFact(
    name: '(none)',
    type: 'const ElDrawerHandle({super.key})',
    description:
        'Takes no constructor parameters of its own beyond key. It is the '
        'grip: width and height are fixed statics below, not per-instance '
        'options.',
  ),
  DocsApiFact(
    name: 'ElDrawerHandle.width',
    type: 'static double',
    description: '96px (el(24)) grip width.',
  ),
  DocsApiFact(
    name: 'ElDrawerHandle.height',
    type: 'static double',
    description: '4px (el(1)) grip height.',
  ),
];

const List<DocsApiFact> _headerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. The header\'s stacked contents (2px gap), centred: '
        'unlike Sheet\'s left-aligned header.',
  ),
];

const List<DocsApiFact> _footerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. The footer\'s stacked CTAs (8px gap). The mt-auto '
        'class has nothing to push against here: the panel is h-auto, so '
        'it resolves to zero; the footer\'s top is simply its '
        'predecessor\'s bottom.',
  ),
];

const List<DocsApiFact> _titleFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String (positional)',
    description:
        'Required. The title\'s only content, centre-aligned, rendered in '
        'theme.foreground.',
  ),
];

const List<DocsApiFact> _descriptionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String (positional)',
    description:
        'Required. The description\'s only content, centre-aligned, '
        'rendered in theme.mutedForeground.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Closed',
    treatment: 'Portal content is not mounted.',
    userSignal: 'Trigger remains available.',
  ),
  DocsStateFact(
    state: 'Open',
    treatment:
        'Scrim and panel both animate over 500ms on vaul\'s own '
        'cubic-bezier(0.32, 0.72, 0, 1) (ElDurations.drawer / '
        'ElCurves.vaul): a different clock and curve from every other '
        'overlay in the system.',
    userSignal:
        'The grip handle signals the drawer is draggable before the '
        'user touches it.',
  ),
  DocsStateFact(
    state: 'Dragging',
    treatment:
        'The panel follows the pointer 1:1, downward only: an upward '
        'drag is clamped to zero, since a bottom panel has nowhere '
        'further to go.',
    userSignal:
        'Releasing past 25% of the panel\'s own height (vaul\'s default '
        'closeThreshold) closes it; short of that, it springs back open.',
  ),
  DocsStateFact(
    state: 'Escape / back',
    treatment:
        'Dismisses on Escape (ElModalPortal\'s FocusScope) and on Android '
        'back / predictive back (the shared PopScope stack).',
    userSignal: 'The page remains in place.',
  ),
  DocsStateFact(
    state: 'Scrim tap',
    treatment:
        'Dismisses on a tap outside the panel: dismissOnOverlayTap is not '
        'set to false, so ElModalPortal\'s true default applies.',
    userSignal: 'Any tap outside the panel closes it.',
  ),
  DocsStateFact(
    state: 'Long content',
    treatment:
        'ElDrawerContent clips to its own 80vh cap and does not wrap its '
        'body in a Flexible + SingleChildScrollView. The body is '
        'deliberately NOT independently scrollable: a nested Scrollable '
        'would win the gesture arena against the drag-to-dismiss '
        'recognizer wrapped around the whole panel.',
    userSignal:
        'Content taller than the 80vh cap is clipped, not scrollable, '
        'unless the caller adds its own scroll region below the cap.',
  ),
  DocsStateFact(
    state: 'Disabled, N/A',
    treatment: 'Exposes no enabled/disabled parameter of its own.',
    userSignal:
        'A caller wanting a disabled trigger gates ElButton\'s own '
        'onPressed outside this widget.',
  ),
  DocsStateFact(
    state: 'Loading / Empty / Error / Success, N/A',
    treatment: 'A structural overlay with no async or validation concept.',
    userSignal: 'None of the four states apply directly.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'Rides ElModalPortal, whose durations resolve through '
        'elAnimationDuration(context, ...): collapsing to zero under the '
        'platform\'s disable-animations flag.',
    userSignal: 'The transition still happens, instantly.',
  ),
];
