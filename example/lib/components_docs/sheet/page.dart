/// Public documentation page for the `sheet` component.
///
/// **Split from a combined page.** `sheet` and `drawer` used to share one
/// page and one [ComponentDocEntry] because they read as the same idea at
/// different edges. The owner asked for one component per page instead: this
/// file now documents `lib/src/components/sheet.dart` alone.
/// `lib/src/components/drawer.dart` has its own page and its own directory,
/// `../drawer/page.dart`, not this one.
///
/// **Shape.** Copies `button/page.dart`'s own frame, the reference shape
/// named by Phase J: an unheaded live demo above the first heading, then
/// Installation, Usage, then this component's own sections named for a
/// reader's problem (matching https://ui.shadcn.com/docs/components/base/sheet's
/// own `<h2>` list: Installation, Usage, Composition, Side, No Close Button,
/// RTL, API Reference), then API Reference last of the shadcn sections — one
/// prop table per real exported class or enum in `sheet.dart`, each its own
/// nested TOC entry — then exactly States, Accessibility, Responsive,
/// Dependencies, Theming, Source.
///
/// No expanded hero paragraph: the short one-line `description` on
/// [sheetDoc] is the only prose above Installation.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class SheetDocPage extends StatelessWidget {
  const SheetDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: sheetDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / OVERLAYS',
      title: sheetDoc.title,
      description: sheetDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Sheet'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(title: 'Composition', anchor: 'composition'),
      DocsTocEntry(title: 'Side', anchor: 'side'),
      DocsTocEntry(title: 'No close button', anchor: 'no-close-button'),
      DocsTocEntry(title: 'RTL', anchor: 'rtl'),
      DocsTocEntry(
        title: 'API Reference',
        anchor: 'api',
        children: <DocsTocEntry>[
          DocsTocEntry(title: 'ElSheetOverlay', anchor: 'api-elsheetoverlay'),
          DocsTocEntry(title: 'ElSheetContent', anchor: 'api-elsheetcontent'),
          DocsTocEntry(
            title: 'ElSheetContent static helpers',
            anchor: 'api-elsheetcontent-static',
          ),
          DocsTocEntry(title: 'ElSheetHeader', anchor: 'api-elsheetheader'),
          DocsTocEntry(title: 'ElSheetFooter', anchor: 'api-elsheetfooter'),
          DocsTocEntry(title: 'ElSheetTitle', anchor: 'api-elsheettitle'),
          DocsTocEntry(
            title: 'ElSheetDescription',
            anchor: 'api-elsheetdescription',
          ),
          DocsTocEntry(title: 'ElSheetSide', anchor: 'api-elsheetside'),
          DocsTocEntry(
            title: 'ElSheetTransition',
            anchor: 'api-elsheettransition',
          ),
          DocsTocEntry(
            title: 'ElSheetContentGroup',
            anchor: 'api-elsheetcontentgroup',
          ),
          DocsTocEntry(
            title: 'ElSheet static helpers',
            anchor: 'api-elsheet-static',
          ),
          DocsTocEntry(title: 'ElSheetPanel', anchor: 'api-elsheetpanel'),
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
    next: const DocsPageLink(title: 'Sidebar', route: '/components/sidebar'),
    onNavigate: onNavigate,
    child: const _SheetArticle(),
  );
}

class _SheetArticle extends StatelessWidget {
  const _SheetArticle();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('sheet-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _preview(),
        SizedBox(height: el(6)),
        _install(),
        SizedBox(height: el(6)),
        _usage(),
        SizedBox(height: el(6)),
        _composition(),
        _side(),
        _noCloseButton(),
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

  /// shadcn: the live demo that opens the page, before any heading. One
  /// [ElSheetOverlay] per [ElSheetSide] value, each a real trigger.
  Widget _preview() => DocsCodeExample(
    title: 'Sheet',
    description:
        'Every edge ElSheetOverlay supports. Open one, then dismiss it by '
        'tapping the scrim, pressing Escape, or the close button.',
    preview: const _SheetSidesPreview(keyPrefix: 'sheet-preview'),
    manualFiles: const <DocsCodeFile>[
      DocsCodeFile(path: 'sheet_preview.dart', code: _sheetUsageCode),
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
              value: 'elattar add sheet',
              description:
                  'Resolves the shipped registry/components/sheet.json '
                  'manifest. Use the package import above when you want the '
                  'published package, or use the CLI when you want the '
                  'generated local copy.',
            ),
            DocsInstallFact(
              label: 'Manual copy target',
              value: 'lib/components/ui/sheet.dart',
              description:
                  'Copy ${sheetDoc.sourcePath} into components/ui and keep '
                  'its relative imports pointed at the same foundation and '
                  'sibling-component files (dialog.dart in particular: see '
                  'Dependencies).',
            ),
            DocsInstallFact(
              label: 'Registry dependencies',
              value: sheetDoc.dependencies.join(', '),
              description:
                  'What registry/components/sheet.json lists as '
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
        'ElModalPortal and the trigger only ever gets a callback. '
        'ElSheetOverlay exposes no onOpenChange callback the way ElDialog '
        'does: a real gap against the dialog\'s own API, not an omission '
        'from this page.',
    child: ElPanel(
      label: 'DART',
      note: 'MINIMAL USAGE',
      child: const DocsSelectableCodeBlock(code: _sheetUsageCode),
    ),
  );

  Widget _composition() => ElSection(
    id: 'composition',
    title: 'Composition',
    description:
        'children accepts any Widget, not just header/footer/title/'
        'description: the reference\'s own filter sheet on the dialogs page '
        '(example/lib/pages/dialogs.dart) puts a live ElSlider straight '
        'inside a ElSheetContent.',
    child: ElPanel(
      label: 'DART',
      note: "REAL EXCERPT, dialogs.dart's filter sheet",
      child: const DocsSelectableCodeBlock(code: _compositionCode),
    ),
  );

  Widget _side() => ElSection(
    id: 'side',
    title: 'Side',
    description:
        'ElSheetSide chooses which edge the panel anchors to and slides '
        'from: top, right (the component\'s own default), bottom, or left. '
        'ElSheetSide.bottom is NOT the same component as Drawer: a '
        'bottom-side sheet has no grip handle and no drag gesture, and '
        'animates on the 320ms overlay ease-out curve, not the drawer\'s '
        '500ms cubic-bezier. See the Drawer page for that component.',
    child: DocsCodeExample(
      title: 'One trigger per side',
      preview: const _SheetSidesPreview(keyPrefix: 'sheet-example-side'),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'sheet_side.dart',
          code:
              "ElSheetOverlay(\n"
              "  side: ElSheetSide.left,\n"
              "  trigger: (context, open) => ElButton(\n"
              "    onPressed: open,\n"
              "    child: const Text('Open left'),\n"
              "  ),\n"
              "  content: (context, close) => ElSheetContent(\n"
              "    side: ElSheetSide.left,\n"
              "    onClose: close,\n"
              "    children: const <Widget>[\n"
              "      ElSheetHeader(children: <Widget>[\n"
              "        ElSheetTitle('Notification settings'),\n"
              "      ]),\n"
              "    ],\n"
              "  ),\n"
              ")",
        ),
      ],
    ),
  );

  Widget _noCloseButton() => ElSection(
    id: 'no-close-button',
    title: 'No close button',
    description:
        'showCloseButton: false on ElSheetContent drops the labelled X in '
        'the corner entirely: no X mounts, and the header\'s own right '
        'padding collapses from 48px back down to 16px, the same padding '
        'it reserves on every other side. The caller becomes responsible '
        'for supplying its own way to close the panel.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Center(child: _NoCloseButtonPreview()),
        SizedBox(height: el(4)),
        ElPanel(
          label: 'DART',
          note: 'NO CLOSE BUTTON',
          child: const DocsSelectableCodeBlock(code: _noCloseButtonCode),
        ),
      ],
    ),
  );

  Widget _rtl() => ElSection(
    id: 'rtl',
    title: 'RTL',
    description:
        'DOCUMENTED DRIFT: side is a physical edge, not a logical '
        'start/end. ElSheetSide.left always renders against the screen\'s '
        'physical left, even under a right-to-left Directionality, because '
        'ElSheetOverlay aligns with Alignment.centerLeft/centerRight rather '
        'than an AlignmentDirectional pair. Only the panel\'s own text '
        '(title, description, and any body content) picks up RTL reading '
        'order and cross-axis alignment automatically. A caller building a '
        'fully mirrored RTL layout has to flip left and right explicitly '
        'at the call site; ElSheetOverlay does not do it for them.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Center(child: _RtlPreview()),
        SizedBox(height: el(4)),
        ElPanel(
          label: 'DART',
          note: 'RTL',
          child: const DocsSelectableCodeBlock(code: _rtlCode),
        ),
      ],
    ),
  );

  Widget _api() => ElSection(
    id: 'api',
    title: 'API Reference',
    description:
        'Every public constructor parameter declared on every public class '
        'or enum in lib/src/components/sheet.dart: one table each.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        KeyedSubtree(
          key: docsAnchorKey('api-elsheetoverlay'),
          child: const DocsApiTable(
            title: 'ElSheetOverlay',
            facts: _overlayFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elsheetcontent'),
          child: const DocsApiTable(
            title: 'ElSheetContent',
            facts: _contentFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elsheetcontent-static'),
          child: const DocsApiTable(
            title: 'ElSheetContent static helpers',
            facts: _contentStaticFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elsheetheader'),
          child: const DocsApiTable(
            title: 'ElSheetHeader',
            facts: _headerFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elsheetfooter'),
          child: const DocsApiTable(
            title: 'ElSheetFooter',
            facts: _footerFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elsheettitle'),
          child: const DocsApiTable(title: 'ElSheetTitle', facts: _titleFacts),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elsheetdescription'),
          child: const DocsApiTable(
            title: 'ElSheetDescription',
            facts: _descriptionFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elsheetside'),
          child: const DocsApiTable(
            title: 'ElSheetSide (enum)',
            facts: _sideFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elsheettransition'),
          child: const DocsApiTable(
            title: 'ElSheetTransition',
            facts: _transitionFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elsheetcontentgroup'),
          child: const DocsApiTable(
            title: 'ElSheetContentGroup',
            facts: _contentGroupFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elsheet-static'),
          child: const DocsApiTable(
            title: 'ElSheet static helpers',
            facts: _dsSheetStaticFacts,
          ),
        ),
        SizedBox(height: el(6)),
        KeyedSubtree(
          key: docsAnchorKey('api-elsheetpanel'),
          child: const DocsApiTable(title: 'ElSheetPanel', facts: _panelFacts),
        ),
      ],
    ),
  );

  Widget _states() => ElSection(
    id: 'states',
    title: 'States',
    description:
        'Read straight off ElSheetOverlay, ElSheetContent, and the shared '
        'ElModalPortal both ride.',
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
      'ElSheetContent does not wrap its body in a '
          'Semantics(scopesRoute: true) / named-route announcement the way '
          'a platform sheet convention would; ElSheetTitle and '
          'ElSheetDescription are plain ElText, not wired to the panel as '
          'an accessible name/description pair.',
      'The close button carries an explicit accessible label ("Close") '
          'via ElButton\'s own label parameter.',
      'ElSheetContent insets its body from the device\'s safe areas via '
          'ElSafeArea, excluding the edge the panel detaches from (top on '
          'a bottom sheet, bottom on a top sheet, both on left/right).',
    ]),
  );

  Widget _responsive(ElThemeData theme) => ElSection(
    id: 'responsive',
    title: 'Responsive and platform behavior',
    child: _bullets(theme, <String>[
      'Opts OUT of ElModalPortal\'s compact viewport clamp '
          '(clampToViewport: false): a centred dialog is capped to 90vw x '
          '75vh on a phone, but an edge-anchored panel is already '
          'viewport-relative by definition, so that cap would crop it '
          'instead of protecting it.',
      'Clamps its own horizontal width instead, through '
          'ElSheetContent.widthFor: 384px everywhere above the 600px '
          'compact breakpoint (ElModalCompact.breakpoint), 90% of viewport '
          'width (ElModalCompact.maxWidthFraction) at or below it.',
      'A vertical sheet (top or bottom) has no analogous height clamp of '
          'its own: its content sizes the panel directly, so tall content '
          'on a short viewport can overflow (see the "Long content" state '
          'above).',
      'No breakpoint branching for the layout decision itself: the same '
          'widget tree renders at 390px and 1440px, only the resolved '
          'width value changes.',
      'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all '
          'render the same widget tree: no dart:io Platform branch '
          'anywhere in the file.',
    ]),
  );

  Widget _dependencies(ElThemeData theme) => ElSection(
    id: 'dependencies',
    title: 'Dependencies, files, and install facts',
    child: _bullets(theme, <String>[
      'File: lib/src/components/sheet.dart: one file, no companions.',
      'Flutter imports: dart:ui (ImageFilter, the mobile-nav backdrop '
          'blur only), package:flutter/widgets.dart.',
      'Foundation imports: foundation/motion.dart, foundation/shadows.dart, '
          'foundation/spacing.dart (el(), ElWidths, ElContainers), '
          'foundation/theme.dart, foundation/typography.dart, '
          'theme_scope.dart (ElText, ElTheme).',
      'Component imports: button.dart (ElButton: the close affordance), '
          'dialog.dart (ElModalPortal, ElModalTriggerBuilder, '
          'ElModalContentBuilder, ElModalCompact), el_safe_area.dart '
          '(ElSafeArea), icon.dart and icon_paths.dart (ElIcon, the X '
          'glyph).',
      'registryDependencies, read directly from the shipped manifest (no manifest yet): '
          'source-foundation, dialog, button, icon, safe-area.',
      'Assets, fonts, shaders: none.',
    ]),
  );

  Widget _theming(ElThemeData theme) => ElSection(
    id: 'theming',
    title: 'Theming notes',
    child: _bullets(theme, <String>[
      'theme.popover fills the panel by default; ElSheetContent\'s fill '
          'parameter is the only override point.',
      'theme.border paints the single hairline seam on the edge the panel '
          'detaches from the page along: right sheet, left edge; left '
          'sheet, right edge; and so on.',
      'ElShadows.tailwindLg is the panel\'s one elevation layer, the same '
          'shadow spec dialog\'s content uses.',
      'theme.muted at the system\'s standard 0.5 alpha bands '
          'ElSheetHeader and ElSheetFooter: the same muted-band anatomy '
          'ElDialogHeader/ElDialogFooter use.',
      'No radius at all: every side is a hard-edged rectangle flush with '
          'the viewport edge. (Drawer, the sibling component, rounds only '
          'its top corners: see the Drawer page.)',
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
          value: sheetDoc.sourcePath,
          description:
              'Authoritative implementation: the truth this page was '
              'written from.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'test/dialogs_test.dart, test/sidebar_test.dart',
          description:
              'ElSheetOverlay and ElSheet.showLeft are covered inside '
              'these two suites; there is no dedicated sheet_test.dart in '
              'the package itself.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/sheet_test.dart',
          description:
              'Covers this page: the article mounts, every documented '
              'constructor parameter appears in an API table, the section '
              'order matches this file, and a live ElSheetOverlay actually '
              'opens and dismisses.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/sheet/page.dart',
          description: 'This file.',
        ),
      ],
    ),
  );
}

/// One [ElSheetOverlay] per [ElSheetSide] value, keyed by [keyPrefix] so the
/// same specimen can mount twice on this page (the unheaded top preview and
/// the Side section's own live example) without a duplicate-key collision.
class _SheetSidesPreview extends StatelessWidget {
  const _SheetSidesPreview({required this.keyPrefix});

  final String keyPrefix;

  Widget _specimen(ElSheetSide side) => ElSheetOverlay(
    side: side,
    trigger: (BuildContext context, VoidCallback open) => ElButton(
      key: ValueKey<String>('$keyPrefix:${side.name}'),
      variant: ElButtonVariant.outline,
      onPressed: open,
      child: Text('Open ${side.name}'),
    ),
    content: (BuildContext context, VoidCallback close) => ElSheetContent(
      side: side,
      onClose: close,
      children: <Widget>[
        const ElSheetHeader(
          children: <Widget>[
            ElSheetTitle('Notification settings'),
            ElSheetDescription('Choose what you want to hear about.'),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: el(4)),
          child: ElText(
            'This panel opened from the ${side.name} edge.',
            ElType.body,
          ),
        ),
        ElSheetFooter(
          children: <Widget>[
            ElButton(onPressed: close, child: const Text('Save changes')),
          ],
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(3),
    runSpacing: el(3),
    children: <Widget>[
      for (final ElSheetSide side in ElSheetSide.values) _specimen(side),
    ],
  );
}

/// The No close button section's own live specimen: a static, unopened
/// [ElSheetContent] (no [ElSheetOverlay]/[ElModalPortal] needed, since the
/// panel is presentational and does not require an [Overlay] ancestor) with
/// showCloseButton: false. side: bottom so its width stays natural instead
/// of ElSheetContent's own double.infinity height on a horizontal side.
///
/// A bottom-side [ElSheetContent] still builds a `Column` with the default
/// `mainAxisSize.max`, which asserts if the incoming height is unbounded —
/// as it is here, one level inside the article's own `SingleChildScrollView`
/// so this wraps it in a fixed-height [SizedBox] first, the same way a
/// bounded viewport height would in the real, portal-mounted case.
class _NoCloseButtonPreview extends StatelessWidget {
  const _NoCloseButtonPreview();

  @override
  Widget build(BuildContext context) => SizedBox(
    height: el(64),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: ElWidths.prose),
      child: const ElSheetContent(
        key: ValueKey<String>('sheet-no-close-button'),
        side: ElSheetSide.bottom,
        showCloseButton: false,
        children: <Widget>[
          ElSheetHeader(
            children: <Widget>[
              ElSheetTitle('Share link'),
              ElSheetDescription(
                'Anyone with this link can view this document.',
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// The RTL section's own live specimen: the same static-panel, fixed-height
/// technique as [_NoCloseButtonPreview], wrapped in a right-to-left
/// [Directionality] so the text-direction flip is real and live, not merely
/// described. Arabic title/description prove the text itself reads RTL; the
/// panel keeps its own physical [ElSheetSide.bottom] regardless,
/// illustrating the documented-drift claim in this section's description.
class _RtlPreview extends StatelessWidget {
  const _RtlPreview();

  @override
  Widget build(BuildContext context) => SizedBox(
    height: el(64),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: ElWidths.prose),
      child: const Directionality(
        textDirection: TextDirection.rtl,
        child: ElSheetContent(
          key: ValueKey<String>('sheet-rtl'),
          side: ElSheetSide.bottom,
          children: <Widget>[
            ElSheetHeader(
              children: <Widget>[
                ElSheetTitle('مشاركة الرابط'),
                ElSheetDescription(
                  'يمكن لأي شخص لديه هذا الرابط عرض هذا المستند.',
                ),
              ],
            ),
          ],
        ),
      ),
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

const String _sheetUsageCode = '''ElSheetOverlay(
  side: ElSheetSide.right,
  trigger: (context, open) => ElButton(
    onPressed: open,
    child: const Text('Open filters'),
  ),
  content: (context, close) => ElSheetContent(
    onClose: close,
    children: <Widget>[
      ElSheetHeader(children: <Widget>[
        ElSheetTitle('Filter packs'),
        ElSheetDescription('184 packs match your current filters.'),
      ]),
      ElSheetFooter(children: <Widget>[
        ElButton(onPressed: close, child: const Text('Apply filters')),
      ]),
    ],
  ),
)''';

/// A trimmed, real excerpt of `example/lib/pages/dialogs.dart`'s own filter
/// sheet: proof that `children` takes live, stateful controls and not only
/// the header/footer/title/description anatomy.
const String _compositionCode = '''ElSheetContent(
  side: side,
  onClose: close,
  children: <Widget>[
    ElSheetHeader(children: <Widget>[
      ElSheetTitle('Filter packs'),
      ElSheetDescription('184 packs match your current filters.'),
    ]),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: el(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElText('Price range', ElType.label),
          SizedBox(height: el(4)),
          ElSlider(
            values: price,
            max: 500,
            step: 5,
            onChanged: (values) => setState(() => price = values),
          ),
        ],
      ),
    ),
    ElSheetFooter(children: <Widget>[
      ElButton(onPressed: () {}, child: const Text('Apply filters')),
    ]),
  ],
)''';

const String _noCloseButtonCode = '''ElSheetContent(
  showCloseButton: false,
  children: <Widget>[
    ElSheetHeader(children: <Widget>[
      ElSheetTitle('Share link'),
      ElSheetDescription('Anyone with this link can view this document.'),
    ]),
  ],
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ElSheetContent(
    children: <Widget>[
      ElSheetHeader(children: <Widget>[
        ElSheetTitle('مشاركة الرابط'),
        ElSheetDescription('يمكن لأي شخص لديه هذا الرابط عرض هذا المستند.'),
      ]),
    ],
  ),
)''';

const List<DocsApiFact> _overlayFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'trigger',
    type: 'ElModalTriggerBuilder',
    description: 'Required. Builds the control that opens the portal.',
  ),
  DocsApiFact(
    name: 'content',
    type: 'ElModalContentBuilder',
    description: 'Required. Builds the panel and receives its close callback.',
  ),
  DocsApiFact(
    name: 'side',
    type: 'ElSheetSide',
    description:
        'Optional. Defaults to ElSheetSide.right, the component\'s own '
        'default. Which edge the panel anchors to and slides from.',
  ),
];

const List<DocsApiFact> _contentFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. The column\'s contents, in order. A ElSheetFooter among '
        'them is pushed to the bottom automatically (mt-auto).',
  ),
  DocsApiFact(
    name: 'side',
    type: 'ElSheetSide',
    description:
        'Optional. Defaults to ElSheetSide.right. Which edge to render the '
        'panel against; also decides which side gets the hairline border '
        'and which safe-area edges are excluded.',
  ),
  DocsApiFact(
    name: 'showCloseButton',
    type: 'bool',
    description:
        'Optional. Defaults to true. Adds the labelled X in the corner; '
        'when true, the header also reserves 48px of right padding '
        'instead of 16px.',
  ),
  DocsApiFact(
    name: 'onClose',
    type: 'VoidCallback?',
    description:
        'Optional. Defaults to null. Wired by ElSheetOverlay\'s portal; '
        'the close button calls it.',
  ),
  DocsApiFact(
    name: 'width',
    type: 'double?',
    description:
        'Optional. Defaults to null, which falls back to '
        'ElSheetContent.maxWidth (384px), then ElSheetContent.widthFor\'s '
        'compact clamp. Overrides the panel\'s width on a horizontal side '
        'only.',
  ),
  DocsApiFact(
    name: 'fill',
    type: 'Color?',
    description:
        'Optional. Defaults to null, which falls back to theme.popover. '
        'Overrides the panel\'s background colour.',
  ),
];

const List<DocsApiFact> _contentStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElSheetContent.maxWidth',
    type: 'static double',
    description:
        '384px (ElContainers.sm): the horizontal panel\'s default width '
        'before the width override or the compact-viewport clamp.',
  ),
  DocsApiFact(
    name: 'ElSheetContent.gap',
    type: 'static double',
    description: '16px (el(4)) between children in the column.',
  ),
  DocsApiFact(
    name: 'ElSheetContent.widthFor(width, viewport)',
    type: 'static double Function(double, Size)',
    description:
        'Clamps a horizontal panel to 90% of viewport width '
        '(ElModalCompact.maxWidthFraction) at or below the 600px compact '
        'breakpoint (ElModalCompact.breakpoint).',
  ),
];

const List<DocsApiFact> _headerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. The header\'s stacked contents (2px gap between them). '
        'Painted as a muted band (theme.muted at 50% alpha) with a bottom '
        'hairline rule.',
  ),
];

const List<DocsApiFact> _footerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. The footer\'s stacked CTAs (8px gap): a column, not a '
        'row, since a sheet\'s actions stack. Painted as the same muted '
        'band with a top hairline rule, pushed to the bottom of the panel.',
  ),
];

const List<DocsApiFact> _titleFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String (positional)',
    description:
        'Required. The title\'s only content, rendered in theme.foreground.',
  ),
];

const List<DocsApiFact> _descriptionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String (positional)',
    description:
        'Required. The description\'s only content, rendered in '
        'theme.mutedForeground.',
  ),
];

const List<DocsApiFact> _sideFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'top',
    type: 'ElSheetSide',
    description: 'Panel spans the top edge, sized by height.',
  ),
  DocsApiFact(
    name: 'right',
    type: 'ElSheetSide',
    description:
        'The constructor default on both ElSheetOverlay and ElSheetContent. '
        'Panel pins to the trailing edge, sized by width.',
  ),
  DocsApiFact(
    name: 'bottom',
    type: 'ElSheetSide',
    description:
        'Panel spans the bottom edge, sized by height. Not the same '
        'component as Drawer: see the Drawer page.',
  ),
  DocsApiFact(
    name: 'left',
    type: 'ElSheetSide',
    description: 'Panel pins to the leading edge, sized by width.',
  ),
  DocsApiFact(
    name: 'isHorizontal',
    type: 'bool getter',
    description:
        'True for left and right: the two sides whose panel is sized by '
        'width rather than height.',
  ),
];

const List<DocsApiFact> _transitionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'animation',
    type: 'Animation<double>',
    description:
        'Required. The enter/exit driver ElSheetOverlay wires in through '
        'ElModalPortal\'s transition builder; not something a typical '
        'caller constructs directly.',
  ),
  DocsApiFact(
    name: 'side',
    type: 'ElSheetSide',
    description:
        'Required. Which axis and direction to translate the slide-in '
        'along.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. The content being animated (the panel).',
  ),
  DocsApiFact(
    name: 'ElSheetTransition.fraction',
    type: 'static double',
    description:
        '0.1: the enter/exit travel, as a fraction of the panel\'s own '
        'size on its axis (a FractionalTranslation, not a pixel offset).',
  ),
];

const List<DocsApiFact> _contentGroupFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'showCloseButton',
    type: 'bool',
    description:
        'Required. The value ElSheetHeader reads (via '
        'ElSheetContentGroup.maybeOf) to decide its own right-padding '
        'reservation; set by ElSheetContent, not usually constructed '
        'directly.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget (via super.child)',
    description: 'Required. The subtree the group scopes over.',
  ),
];

const List<DocsApiFact> _dsSheetStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElSheet.showLeft(context, {...})',
    type: 'static Future<void>',
    description:
        'Pushes a left-hand sheet as a real Navigator route (a PopupRoute) '
        'and completes when it closes: a different mounting strategy from '
        'ElSheetOverlay\'s OverlayPortal. example/lib/shell.dart\'s mobile '
        'navigation calls this, not ElSheetOverlay.',
  ),
  DocsApiFact(
    name: 'builder',
    type: 'WidgetBuilder',
    description: 'Required. Builds the sheet\'s content.',
  ),
  DocsApiFact(
    name: 'width',
    type: 'double',
    description:
        'Optional. Defaults to ElWidths.sidebarMobile (288px), '
        'deliberately wider than the 256px docked sidebar.',
  ),
  DocsApiFact(
    name: 'showCloseButton',
    type: 'bool',
    description: 'Optional. Defaults to true.',
  ),
];

const List<DocsApiFact> _panelFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'width',
    type: 'double',
    description:
        'Required. The panel\'s fixed width; full height, pinned to the '
        'left edge.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. The panel\'s content.',
  ),
  DocsApiFact(
    name: 'showCloseButton',
    type: 'bool',
    description: 'Optional. Defaults to true. Adds the labelled X, top-right.',
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
        'Scrim fades in on --duration-overlay (320ms); panel slides in 10% '
        'of its own size on the same clock and --ease-out, fading in '
        'alongside it.',
    userSignal: 'Title, description, and CTAs are visible.',
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
        'ElSheetContent does not wrap its body children in a Flexible + '
        'SingleChildScrollView the way ElDialogContent does. A caller with '
        'content taller than the panel needs to wrap the middle children '
        'in a Scrollable itself.',
    userSignal:
        'Overflow is a real risk on a short viewport unless the caller '
        'adds their own scroll region: a gap against ElDialogContent\'s '
        'built-in scrolling body, not a designed behavior.',
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
