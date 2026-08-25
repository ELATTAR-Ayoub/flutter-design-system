/// Public documentation page for the `alert-dialog` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose [ElSection]
/// panels shaped to mirror shadcn's own alert-dialog page section for
/// section; it now declares a [ComponentDocSpec]
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// [ComponentDocPage], the same shape `button` and `field` established.
/// Every specimen widget and every code string below is the one the
/// hand-composed page carried; new in this pass: a live Preview hero (the
/// former unheaded demo, now its own `ShowcaseSection`), a live Sizes
/// specimen (the enum table alone before), source code for Destructive (a
/// live specimen with no quoted source before), and a dedicated Keyboard
/// disclosure split out of the old combined "Accessibility and keyboard
/// behavior" section.
///
/// Two findings, resolved in favour of the real source
/// (`lib/src/components/alert_dialog.dart`), which is the documented source
/// of truth here:
///
///  * **`ElAlertDialogSize.sm` is only half-built.** The enum's own doc
///    comment says the whole value is "RECORDED, NOT BUILT", but
///    `ElAlertDialogContent.build` does branch on `size` for the panel's
///    `maxWidth` (`ElDialogContent.maxWidth` for `normal`, `ElContainers.xs`
///    for `sm`): that part ships. What does not ship is the rest of the
///    reference's `sm` anatomy: `ElAlertDialogHeader` and
///    `ElAlertDialogFooter` take no `size` parameter at all, so the
///    centred header and the two-column footer grid the reference's own doc
///    comment describes never happen, for any value of `size`. The Sizes
///    section below says both halves plainly instead of repeating the
///    "not built" label over a case that partially is.
///  * **Escape does not run Cancel's `onPressed`.** `ElModalPortalState._onKey`
///    calls its own `close()` directly: the same bare portal-close every
///    other modal in the family uses. Tapping Cancel calls the `onPressed`
///    a caller passed to `ElAlertDialogCancel`; pressing Escape never does.
///    For a caller that puts real work in Cancel's callback (resetting a
///    field, logging an abandonment), Escape silently skips it. Documented
///    in Keyboard below, not as an ideal-behaviour aspiration.
///
/// The focus story was verified with a live `WidgetTester`, not assumed: see
/// `example/test/components_docs/alert_dialog_test.dart`'s `focus behavior`
/// group. Findings, in order:
///
///  1. **Moves in, but not onto a control.** `FocusScope(autofocus: true,
///     ...)` in `ElModalPortal` does move primary focus off whatever was
///     focused before the dialog opened: but the harness observed
///     `FocusManager.instance.primaryFocus` becoming the panel's own
///     `FocusScopeNode`, identity-equal to `FocusScope.of()` resolved from
///     inside the panel, not a leaf control. The dialog.dart library doc's
///     own note that Radix measures Cancel as the auto-focused element
///     describes the **reference's** behaviour; nothing paints a focus ring
///     at this point because no actual `Focus` leaf holds it yet.
///  2. **The first Tab lands on a real button, and stays trapped from
///     there.** One Tab press moves focus from the bare scope onto Cancel
///     or Action, and six consecutive presses after that never once moved
///     focus onto a `ElButton` planted outside the overlay.
///  3. **Does not return.** Closing via Cancel does **not** hand focus back
///     to the trigger that opened it: nothing in `ElModalPortalState.close()`
///     saves or restores a previous `FocusNode`. This is a real, checked gap.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec alertDialogDocSpec = ComponentDocSpec(
  name: 'alert-dialog',
  title: alertDialogDoc.title,
  description: alertDialogDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'A destructive confirmation. Open it, then try to dismiss it by '
          'tapping outside the panel: the reference and this port both '
          'refuse. Escape and the two footer buttons still work.',
      specimen: _AlertDialogPreview(),
      code: _usageBasicCode,
      label: 'Alert dialog specimen',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'alert-dialog already has a registry manifest: this installs '
          'lib/src/components/alert_dialog.dart and its dependencies, '
          'button, dialog, machine-surface, source-foundation, and '
          'tooltip, resolved automatically.',
      command: alertDialogDoc.command,
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/alert_dialog.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/alert_dialog.dart's generated "
              '@ui/alert_dialog.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated alert_dialog source here when using '
              'manual mode.',
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct composition: a destructive Action beside '
          'a safe Cancel, both wired to the same close callback. Below it, '
          'the shape a caller reaches for when the confirming action is '
          'real async work: the button owns its own loading flag rather '
          'than inheriting one, because there is a Future to await before '
          'the dialog should close.',
      code: '$_usageBasicCode\n\n$_usageLoadingCode',
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'The widget tree a caller actually builds: a trigger and a '
          'content builder, and inside the content, one header and one '
          'footer. No media slot: the reference also composes an '
          'AlertDialogMedia into the header, for an icon or image above '
          'the title. Nothing in this source builds that widget, so '
          'ElAlertDialogHeader has no place to put one.',
      code: _compositionTree,
    ),
    ShowcaseSection(
      id: 'sizes',
      title: 'Sizes',
      description:
          'ElAlertDialogSize is the only variant knob on this component, '
          'and it is only half-built: normal (the default) constrains the '
          'panel to ElDialogContent.maxWidth (384); sm narrows it to '
          'ElContainers.xs and nothing else, ElAlertDialogHeader and '
          'ElAlertDialogFooter both take no size parameter at all, so the '
          "reference's own centred header and two-column footer grid "
          'never happen for either value.',
      specimen: _SizesSpecimen(),
      code: _sizesCode,
      label: 'Sizes specimen view',
    ),
    ShowcaseSection(
      id: 'destructive',
      title: 'Destructive',
      description:
          "A danger-zone row: the shape the source's own library doc "
          'cites, a long consequence label beside a short safe one, '
          'inside a footer narrow enough that only Flexible/shrink keeps '
          'both readable. ElAlertDialogAction already defaults to '
          'ElButtonVariant.destructive, so every specimen on this page '
          'is a destructive confirmation by default.',
      specimen: _AlertDialogComposition(),
      code: _destructiveCode,
      label: 'Destructive specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every public class and constructor parameter the source '
          'declares: eight exported classes plus one enum.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElAlertDialog', anchor: 'api-elalertdialog'),
        DocsTocEntry(
          title: 'ElAlertDialogContent',
          anchor: 'api-elalertdialogcontent',
        ),
        DocsTocEntry(
          title: 'ElAlertDialogHeader',
          anchor: 'api-elalertdialogheader',
        ),
        DocsTocEntry(
          title: 'ElAlertDialogTitle',
          anchor: 'api-elalertdialogtitle',
        ),
        DocsTocEntry(
          title: 'ElAlertDialogDescription',
          anchor: 'api-elalertdialogdescription',
        ),
        DocsTocEntry(
          title: 'ElAlertDialogFooter',
          anchor: 'api-elalertdialogfooter',
        ),
        DocsTocEntry(
          title: 'ElAlertDialogAction',
          anchor: 'api-elalertdialogaction',
        ),
        DocsTocEntry(
          title: 'ElAlertDialogCancel',
          anchor: 'api-elalertdialogcancel',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Cancel and Action are ordinary ElButton instances wrapped in a '
          'ElTooltip, so most of their state behavior is inherited '
          "verbatim rather than reimplemented here. Rows that do not "
          'apply to this decision-only primitive are marked N/A with the '
          'reason.',
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
          'Read off ElButton\'s own key handler (shared by Cancel and '
          'Action) and ElModalPortalState\'s Escape branch '
          '(lib/src/components/dialog.dart), not inferred.',
      child: _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      description:
          'Shares ElModalCompact with every other centred modal in the '
          'family: a phone-sized viewport clamps the panel rather than '
          'letting it run to the edges or off the screen.',
      child: _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      description:
          "Elattar's own technical-transparency panel: what this "
          'component needs to install and run.',
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
            value: alertDialogDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value:
                "test/dialogs_test.dart (ElModalPortal: the alert dialog "
                'scrim/Escape group)',
            description:
                'Package-level behavioral coverage: the overlay-tap '
                'refusal and the Escape-yields drift.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/alert_dialog_test.dart',
            description:
                "This page's own responsive, theme, API-completeness, "
                'live open/close/Escape, and focus-behavior coverage.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/alert_dialog/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class AlertDialogDocPage extends StatelessWidget {
  const AlertDialogDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: alertDialogDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / OVERLAYS',
      title: alertDialogDoc.title,
      description: alertDialogDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Alert Dialog'),
    ],
    toc: alertDialogDocSpec.toc,
    previous: const DocsPageLink(
      title: 'Dialog',
      route: '/components/dialog',
    ),
    next: const DocsPageLink(title: 'Command', route: '/components/command'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('alert-dialog-doc-article'),
      child: ComponentDocPage(spec: alertDialogDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

const String _usageBasicCode =
    '''import 'package:elattar_design_system/elattar_design_system.dart';

ElAlertDialog(
  trigger: (context, open) => ElButton(
    variant: ElButtonVariant.destructive,
    label: 'Delete account',
    onPressed: open,
    child: const Text('Delete account'),
  ),
  content: (context, close) => ElAlertDialogContent(
    header: ElAlertDialogHeader(
      title: const ElAlertDialogTitle('Are you absolutely sure?'),
      description: const ElAlertDialogDescription(
        'This will permanently delete your account and remove your data '
        'from our servers. This action cannot be undone.',
      ),
    ),
    footer: ElAlertDialogFooter(
      cancel: ElAlertDialogCancel(label: 'Cancel', onPressed: close),
      action: ElAlertDialogAction(
        label: 'Delete account',
        onPressed: close,
      ),
    ),
  ),
)''';

const String _usageLoadingCode = '''// The confirming button owns its own
// loading flag: the source declares it here rather than inheriting
// Button's, because a caller has real async work to await (an API call
// that actually deletes the account) before the dialog should close.
class _DeleteAccountAction extends StatefulWidget {
  const _DeleteAccountAction({required this.close});
  final VoidCallback close;

  @override
  State<_DeleteAccountAction> createState() => _DeleteAccountActionState();
}

class _DeleteAccountActionState extends State<_DeleteAccountAction> {
  bool _loading = false;

  Future<void> _delete() async {
    setState(() => _loading = true);
    await deleteAccount(); // caller-owned async work
    if (mounted) widget.close();
  }

  @override
  Widget build(BuildContext context) => ElAlertDialogAction(
    label: 'Delete account',
    loading: _loading,
    onPressed: _delete,
  );
}''';

/// The plain-text widget tree shown in the Composition section, built
/// directly from the constructor parameter names above: no AlertDialogMedia
/// slot, because nothing in the source builds that widget.
const String _compositionTree = '''ElAlertDialog
├── trigger: (context, open) => ...
└── content: (context, close) => ElAlertDialogContent
    ├── header: ElAlertDialogHeader
    │   ├── title: ElAlertDialogTitle
    │   └── description: ElAlertDialogDescription
    └── footer: ElAlertDialogFooter
        ├── cancel: ElAlertDialogCancel
        └── action: ElAlertDialogAction''';

const String _sizesCode = '''// normal (the default): 384px maxWidth.
ElAlertDialog(
  trigger: (context, open) => ElButton(
    variant: ElButtonVariant.outline,
    label: 'Normal',
    onPressed: open,
    child: const Text('Normal'),
  ),
  content: (context, close) => ElAlertDialogContent(
    header: ElAlertDialogHeader(
      title: const ElAlertDialogTitle('Update dimensions?'),
      description: const ElAlertDialogDescription(
        'ElAlertDialogSize.normal is the default: 384px maxWidth, the '
        'same as a plain dialog.',
      ),
    ),
    footer: ElAlertDialogFooter(
      cancel: ElAlertDialogCancel(label: 'Cancel', onPressed: close),
      action: ElAlertDialogAction(label: 'Continue', onPressed: close),
    ),
  ),
)

// sm: narrows the panel to ElContainers.xs. Nothing else changes: the
// header stays left-aligned and the footer stays a single row, unlike
// the reference's own centred/two-column sm anatomy.
ElAlertDialog(
  trigger: (context, open) => ElButton(
    variant: ElButtonVariant.outline,
    label: 'Small',
    onPressed: open,
    child: const Text('Small'),
  ),
  content: (context, close) => ElAlertDialogContent(
    size: ElAlertDialogSize.sm,
    header: ElAlertDialogHeader(
      title: const ElAlertDialogTitle('Update dimensions?'),
      description: const ElAlertDialogDescription(
        'ElAlertDialogSize.sm narrows the panel to ElContainers.xs; '
        'header and footer anatomy are unchanged.',
      ),
    ),
    footer: ElAlertDialogFooter(
      cancel: ElAlertDialogCancel(label: 'Cancel', onPressed: close),
      action: ElAlertDialogAction(label: 'Continue', onPressed: close),
    ),
  ),
)''';

const String _destructiveCode = '''Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: <Widget>[
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElText('Delete this workspace', ElType.section),
          SizedBox(height: el(1)),
          ElText(
            'Every project, member, and file inside it is removed '
            'immediately.',
            ElType.small,
          ),
        ],
      ),
    ),
    SizedBox(width: el(4)),
    ElAlertDialog(
      trigger: (context, open) => ElButton(
        variant: ElButtonVariant.destructive,
        size: ElButtonSize.sm,
        label: 'Delete workspace',
        onPressed: open,
        child: const Text('Delete'),
      ),
      content: (context, close) => ElAlertDialogContent(
        header: ElAlertDialogHeader(
          title: const ElAlertDialogTitle('Delete this workspace?'),
          description: const ElAlertDialogDescription(
            'Every project, member, and file inside it is removed '
            'immediately and cannot be recovered.',
          ),
        ),
        footer: ElAlertDialogFooter(
          cancel: ElAlertDialogCancel(
            label: 'Keep workspace',
            onPressed: close,
          ),
          action: ElAlertDialogAction(
            label: 'Delete my workspace and all its files',
            onPressed: close,
          ),
        ),
      ),
    ),
  ],
)''';

/// The live specimen: a real ElAlertDialog with an overlay-tap probe built
/// in.
class _AlertDialogPreview extends StatelessWidget {
  const _AlertDialogPreview();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElAlertDialog(
          trigger: (BuildContext context, VoidCallback open) => ElButton(
            key: const ValueKey<String>('alert-dialog-doc-trigger'),
            variant: ElButtonVariant.destructive,
            label: 'Delete account',
            onPressed: open,
            child: const Text('Delete account'),
          ),
          content: (BuildContext context, VoidCallback close) =>
              ElAlertDialogContent(
                header: ElAlertDialogHeader(
                  title: const ElAlertDialogTitle('Are you absolutely sure?'),
                  description: const ElAlertDialogDescription(
                    'This will permanently delete your account and remove '
                    'your data from our servers. This action cannot be '
                    'undone.',
                  ),
                ),
                footer: ElAlertDialogFooter(
                  cancel: ElAlertDialogCancel(
                    key: const ValueKey<String>('alert-dialog-doc-cancel'),
                    label: 'Cancel',
                    onPressed: close,
                  ),
                  action: ElAlertDialogAction(
                    key: const ValueKey<String>('alert-dialog-doc-action'),
                    label: 'Delete account',
                    onPressed: close,
                  ),
                ),
              ),
        ),
        SizedBox(height: el(4)),
        ElText(
          'Tapping outside the panel leaves it open; Cancel, the '
          'destructive Action, and Escape all close it.',
          ElType.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

/// The Sizes section's own live specimen: one trigger per [ElAlertDialogSize]
/// value.
class _SizesSpecimen extends StatelessWidget {
  const _SizesSpecimen();

  Widget _dialog({
    required Key key,
    required String label,
    required ElAlertDialogSize size,
    required String description,
  }) => ElAlertDialog(
    trigger: (BuildContext context, VoidCallback open) => ElButton(
      key: key,
      variant: ElButtonVariant.outline,
      label: label,
      onPressed: open,
      child: Text(label),
    ),
    content: (BuildContext context, VoidCallback close) =>
        ElAlertDialogContent(
          size: size,
          header: ElAlertDialogHeader(
            title: const ElAlertDialogTitle('Update dimensions?'),
            description: ElAlertDialogDescription(description),
          ),
          footer: ElAlertDialogFooter(
            cancel: ElAlertDialogCancel(label: 'Cancel', onPressed: close),
            action: ElAlertDialogAction(
              label: 'Continue',
              onPressed: close,
            ),
          ),
        ),
  );

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      _dialog(
        key: const ValueKey<String>('alert-dialog-example:size-normal'),
        label: 'Normal',
        size: ElAlertDialogSize.normal,
        description:
            'ElAlertDialogSize.normal is the default: 384px maxWidth, the '
            'same as a plain dialog.',
      ),
      SizedBox(width: el(3)),
      _dialog(
        key: const ValueKey<String>('alert-dialog-example:size-sm'),
        label: 'Small',
        size: ElAlertDialogSize.sm,
        description:
            'ElAlertDialogSize.sm narrows the panel to ElContainers.xs; '
            'header and footer anatomy are unchanged.',
      ),
    ],
  );
}

/// A realistic danger-zone row: a long consequence beside a short safe
/// choice, the exact shape `alert_dialog.dart`'s own library doc cites.
class _AlertDialogComposition extends StatelessWidget {
  const _AlertDialogComposition();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElText(
                'Delete this workspace',
                ElType.section,
                color: theme.foreground,
              ),
              SizedBox(height: el(1)),
              ElText(
                'Every project, member, and file inside it is removed '
                'immediately.',
                ElType.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
        ),
        SizedBox(width: el(4)),
        ElAlertDialog(
          trigger: (BuildContext context, VoidCallback open) => ElButton(
            key: const ValueKey<String>(
              'alert-dialog-example:destructive-trigger',
            ),
            variant: ElButtonVariant.destructive,
            size: ElButtonSize.sm,
            label: 'Delete workspace',
            onPressed: open,
            child: const Text('Delete'),
          ),
          content: (BuildContext context, VoidCallback close) =>
              ElAlertDialogContent(
                header: ElAlertDialogHeader(
                  title: const ElAlertDialogTitle('Delete this workspace?'),
                  description: const ElAlertDialogDescription(
                    'Every project, member, and file inside it is removed '
                    'immediately and cannot be recovered.',
                  ),
                ),
                footer: ElAlertDialogFooter(
                  cancel: ElAlertDialogCancel(
                    label: 'Keep workspace',
                    onPressed: close,
                  ),
                  action: ElAlertDialogAction(
                    label: 'Delete my workspace and all its files',
                    onPressed: close,
                  ),
                ),
              ),
        ),
      ],
    );
  }
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elalertdialog',
        child: DocsApiTable(title: 'ElAlertDialog', facts: _dialogFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elalertdialogcontent',
        child: DocsApiTable(
          title: 'ElAlertDialogContent',
          facts: _contentFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elalertdialogheader',
        child: DocsApiTable(
          title: 'ElAlertDialogHeader',
          facts: _headerFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elalertdialogtitle',
        child: DocsApiTable(title: 'ElAlertDialogTitle', facts: _titleFacts),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elalertdialogdescription',
        child: DocsApiTable(
          title: 'ElAlertDialogDescription',
          facts: _descriptionFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elalertdialogfooter',
        child: DocsApiTable(
          title: 'ElAlertDialogFooter',
          facts: _footerFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elalertdialogaction',
        child: DocsApiTable(
          title: 'ElAlertDialogAction',
          facts: _actionFacts,
        ),
      ),
      SizedBox(height: el(5)),
      const DocsAnchor(
        id: 'api-elalertdialogcancel',
        child: DocsApiTable(
          title: 'ElAlertDialogCancel',
          facts: _cancelFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _dialogFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'trigger',
    type: 'ElModalTriggerBuilder',
    description:
        'Required. Widget Function(BuildContext, VoidCallback open): '
        'builds the control that opens the portal.',
  ),
  DocsApiFact(
    name: 'content',
    type: 'ElModalContentBuilder',
    description:
        'Required. Widget Function(BuildContext, VoidCallback close): '
        'builds the panel and receives its close callback.',
  ),
  DocsApiFact(
    name: 'onOpenChange',
    type: 'ValueChanged<bool>?',
    description:
        'Default null. Fires with the new open state whenever the '
        'overlay opens or closes.',
  ),
];

const List<DocsApiFact> _contentFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'header',
    type: 'ElAlertDialogHeader',
    description: 'Required. The question, straight on the panel.',
  ),
  DocsApiFact(
    name: 'footer',
    type: 'ElAlertDialogFooter',
    description: 'Required. The banded row that holds the decision.',
  ),
  DocsApiFact(
    name: 'size',
    type: 'ElAlertDialogSize',
    description:
        'Default ElAlertDialogSize.normal. Only changes the panel\'s '
        'maxWidth: see Sizes above for what it does not change.',
  ),
];

const List<DocsApiFact> _headerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'title',
    type: 'Widget',
    description:
        'Required. Almost always a ElAlertDialogTitle, but typed as '
        'Widget rather than that concrete class.',
  ),
  DocsApiFact(
    name: 'description',
    type: 'Widget',
    description:
        'Required. Almost always a ElAlertDialogDescription, for the '
        'same reason.',
  ),
];

const List<DocsApiFact> _titleFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String',
    description:
        'Required, positional: ElAlertDialogTitle(text). Rendered at '
        'ElComponentType.overlayTitle with no leading override.',
  ),
];

const List<DocsApiFact> _descriptionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String',
    description:
        'Required, positional: ElAlertDialogDescription(text). Rendered '
        'muted, wrapped greedily rather than balanced: see Responsive '
        'below.',
  ),
];

const List<DocsApiFact> _footerFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'cancel',
    type: 'Widget',
    description:
        'Required. Rendered first: the safe choice on the left. Almost '
        'always a ElAlertDialogCancel.',
  ),
  DocsApiFact(
    name: 'action',
    type: 'Widget',
    description: 'Required. Almost always a ElAlertDialogAction.',
  ),
];

const List<DocsApiFact> _actionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'label',
    type: 'String',
    description:
        'Required. Rendered through an internal Text widget, not '
        'forwarded to ElButton.label: see Accessibility.',
  ),
  DocsApiFact(
    name: 'onPressed',
    type: 'VoidCallback?',
    description: 'Default null (disabled).',
  ),
  DocsApiFact(
    name: 'variant',
    type: 'ElButtonVariant',
    description:
        'Default ElButtonVariant.destructive, "that is what an alert '
        'dialog is for."',
  ),
  DocsApiFact(
    name: 'size',
    type: 'ElButtonSize',
    description: 'Default ElButtonSize.md.',
  ),
  DocsApiFact(
    name: 'loading',
    type: 'bool',
    description:
        'Default false. Prepends a spinner, forces ElButton.enabled '
        'false, and the constructor\'s own onPressed: loading ? null : '
        'onPressed blocks a second press ahead of ElButton\'s own guard.',
  ),
  DocsApiFact(
    name: 'tooltip',
    type: 'String?',
    description:
        'Default null, which falls back to label: passing null does NOT '
        'mean "no tooltip". See Accessibility.',
  ),
];

const List<DocsApiFact> _cancelFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'label',
    type: 'String',
    description: 'Required. Same rendering path as Action\'s.',
  ),
  DocsApiFact(
    name: 'onPressed',
    type: 'VoidCallback?',
    description: 'Default null (disabled).',
  ),
  DocsApiFact(
    name: 'variant',
    type: 'ElButtonVariant',
    description: 'Default ElButtonVariant.outline.',
  ),
  DocsApiFact(
    name: 'size',
    type: 'ElButtonSize',
    description: 'Default ElButtonSize.md.',
  ),
  DocsApiFact(
    name: 'tooltip',
    type: 'String?',
    description:
        'Default null, falls back to label: same rule as Action\'s. '
        'ElAlertDialogCancel has no loading parameter at all.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'The portal content is not mounted; only the trigger renders.',
    userSignal: 'Nothing besides the trigger is on screen.',
  ),
  DocsStateFact(
    state: 'Hover',
    treatment:
        "Cancel and Action inherit their variant's own ElButton hover "
        "fill (outline's and destructive's respectively), nothing "
        'alert-dialog-specific is added.',
    userSignal: 'Matches every other ElButton in the system.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        "ElButton's own keyboard-only focus ring paints on whichever of "
        'Cancel or Action Tab reaches; a pointer tap does not paint it.',
    userSignal:
        'Ring is visible only after keyboard traversal, never after a '
        "mouse click: verified live in this page's own focus tests.",
  ),
  DocsStateFact(
    state: 'Pressed',
    treatment:
        "ElButton's own press-scale and active shadow apply identically "
        'on both footer buttons.',
    userSignal: 'A brief squash on press, released on lift.',
  ),
  DocsStateFact(
    state: 'Selected',
    treatment:
        'N/A: a decision dialog has no selection concept beyond open or '
        'closed.',
    userSignal: 'N/A',
  ),
  DocsStateFact(
    state: 'Loading',
    treatment:
        'Action-only: ElAlertDialogCancel has no loading parameter. '
        'loading: true on Action prepends a spinner, disables the '
        "button through ElButton's own enabled logic, and the "
        'constructor guard blocks a second press.',
    userSignal: 'Spinner shows on Action; Cancel stays fully interactive.',
  ),
  DocsStateFact(
    state: 'Empty',
    treatment:
        'N/A: label, title and description are all required Strings; '
        'the API has no path to an empty one to design for.',
    userSignal: 'N/A',
  ),
  DocsStateFact(
    state: 'Error',
    treatment: 'N/A: no validation or error state exists on this component.',
    userSignal: 'N/A',
  ),
  DocsStateFact(
    state: 'Success',
    treatment:
        'N/A: onPressed is a synchronous VoidCallback, not a Future; '
        'there is no async outcome to confirm.',
    userSignal: 'N/A',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'Neither Cancel nor Action has an explicit enabled/disabled '
        'parameter: onPressed: null is the only path, same as any '
        'ElButton.',
    userSignal:
        "Matches ElButton's own disabled visual: lower opacity, no "
        'pointer events.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'The whole panel rides ElJellyTransition through '
        'elAnimationDuration, exactly like the plain dialog: the '
        '420ms/250ms jelly and the 320ms scrim fade collapse to zero.',
    userSignal:
        'The dialog still opens and closes, just without the spring '
        'travel.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const <Widget>[
      _A11yRow(
        'Semantic role',
        'Cancel and Action each publish Semantics(button: true, enabled: '
            '<onPressed != null && !loading>) through the ElButton they '
            "wrap. Neither passes its label to ElButton's own label "
            'parameter: the accessible name instead comes from Semantics '
            'merging upward over the internal Text child, which still '
            'resolves to the same string.',
      ),
      _A11yRow(
        'Required labels',
        'title, description, and both button labels are all required: '
            'there is no path to a nameless control or a captionless '
            'question.',
      ),
      _A11yRow(
        'Focus behavior: verified, not assumed',
        'Opening moves focus off whatever held it before, but not onto a '
            'control: FocusManager.primaryFocus becomes the panel\'s own '
            'bare FocusScopeNode, identity-checked live: not the Cancel '
            "button, despite the dialog.dart library doc describing that "
            'as what the reference (Radix) measures. One Tab press moves '
            'focus from that scope onto a real control (Cancel or '
            'Action), and from there Tab is trapped: six consecutive '
            "presses in this page's own test never reached a control "
            'planted outside the overlay.',
      ),
      _A11yRow(
        'Known gap: closing does not return focus to the trigger',
        'Verified live: after opening the panel and dismissing it via '
            'Cancel, focus does not return to the button that opened it. '
            'Nothing in ElModalPortalState.close() saves a FocusNode '
            'before autofocus moves it, so there is nothing to restore. '
            'A keyboard user who opens and cancels the dialog does not '
            'automatically land back on the trigger.',
      ),
      _A11yRow(
        'Touch target',
        "Cancel and Action are md ElButtons (40px tall) unless a caller "
            'overrides size: no touch-target reduction is applied inside '
            'the footer band.',
      ),
      _A11yRow(
        'Non-colour signal',
        "Action's destructive tint is never the only signal, the label "
            'itself always states the consequence ("Delete account", not '
            'just a red button), and the title/description pair states '
            'the question in full sentences above it.',
      ),
      _A11yRow(
        'Error wiring',
        'None: this family never participates in form validation.',
      ),
      _A11yRow(
        'Screen-reader announcements',
        'None beyond whatever the platform announces for a newly focused '
            'control: opening the panel raises no live region of its '
            'own, so a screen-reader user learns the question only by '
            'having focus land on Cancel and reading from there.',
      ),
      _A11yRow(
        'Known platform differences',
        'Android/predictive back always dismisses the dialog '
            '(ElModalPortalState\'s own PopScope), unconditionally: '
            'unlike Escape and the overlay tap, back admits no '
            'destructive-action exception.',
        last: true,
      ),
    ],
  );
}

/// Read directly off `ElButton`'s own key handler (`lib/src/components/
/// button.dart`, shared by Cancel and Action) and `ElModalPortalState._onKey`
/// (`lib/src/components/dialog.dart`), not inferred.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Activation: Enter, NumpadEnter, and Space activate whichever of '
            'Cancel or Action is focused, through the same _onKey every '
            'plain ElButton uses: see the Button page\'s own Keyboard '
            'section for the mechanism.',
        'Tab order: Tab and Shift+Tab move between Cancel and Action in '
            'source order (cancel first, then action). alert_dialog.dart '
            'wires no FocusTraversalPolicy of its own; the order comes '
            'from ElModalPortal\'s enclosing FocusScope.',
        'Trapped while open: verified live, six consecutive Tab presses '
            'never moved focus onto a control planted outside the '
            'overlay. See Accessibility for the full focus-behavior '
            'finding.',
        'Known gap: Escape does not run Cancel\'s own onPressed. '
            'ElModalPortalState._onKey calls close() directly on Escape: '
            'the same bare portal-close every modal in the family uses. '
            'Tapping the Cancel button calls whatever onPressed a caller '
            'passed to ElAlertDialogCancel; pressing Escape does not '
            'call it. A caller that relies on Cancel\'s callback for '
            'real work (resetting a field, logging an abandoned '
            'confirmation) has that work silently skipped when the '
            'dialog closes on Escape instead.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'At 600 logical pixels of viewport width or below, the panel is '
            'held inside 90vw x 75vh, ElModalCompact, shared with the '
            'plain dialog. Above that width the desktop geometry is '
            'untouched.',
        'The header and question scroll inside a loose Flexible; the '
            'footer band does not: the decision stays reachable even '
            'when the question runs long enough to need scrolling on a '
            '375px phone.',
        "Cancel and Action are both wrapped in Flexible with min-width "
            "0 inside the footer's Row, and ElButton's child is a "
            'single-line Text with TextOverflow.ellipsis: so a long '
            'consequence label truncates to fit a narrow footer instead '
            'of pushing the panel wider or overflowing it.',
        "text-balance and text-pretty on the description are recorded "
            "and unreachable: Flutter's line breaker has no balanced or "
            'pretty mode, so a long description wraps greedily rather '
            'than evenly.',
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
            value: 'alert-dialog',
            description:
                'registry/components/alert-dialog.json exists and is '
                'installable through the CLI today.',
          ),
          const DocsInstallFact(
            label: 'Version',
            value: '0.0.1',
            description: "The registry manifest's own version field.",
          ),
          const DocsInstallFact(
            label: 'Dart / Flutter',
            value: '>=3.12.2 <4.0.0 / >=3.44.8',
            description: "The manifest's minDart and minFlutter constraints.",
          ),
          const DocsInstallFact(
            label: 'Destination',
            value: 'lib/components/ui/alert_dialog.dart',
            description:
                'The same lib/components/ui/ target every component '
                'installs to, in both foundation modes.',
          ),
          const DocsInstallFact(
            label: 'Foundation',
            value: 'source or package compatible',
            description:
                "The manifest names source-foundation plus three "
                'sibling components: nothing here is package-mode-only.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: alertDialogDoc.dependencies.join(', '),
            description:
                "The manifest's registryDependencies, resolved "
                'automatically by the registry client: button for '
                'Cancel and Action, dialog for the shared panel '
                'machinery, and tooltip for the two footer tooltips.',
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
            description:
                'Pure widget composition; the only platform-shaped '
                'behavior is the Android back button dismissing the '
                'dialog, which every ElModalPortal already wires.',
          ),
          const DocsInstallFact(
            label: 'Verified',
            value: 'package tests + this docs specimen',
            description:
                "test/dialogs_test.dart's own ElAlertDialog scrim/Escape "
                "group, plus this page's own live open/close/Escape and "
                'focus-behavior tests. No fixture install was run as '
                'part of writing this page.',
          ),
        ],
      ),
      SizedBox(height: el(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Tooltip', route: '/components/tooltip'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'The panel itself is ElDialogContent\'s own ElMachineSurface: '
            'theme.popover fill, a single 1px theme.foreground-at-10% '
            'ring, no elevation: reused directly rather than restated, '
            'so the two panels cannot drift apart.',
        'The footer band is theme.muted at 50% alpha with a 1px '
            'theme.border rule on top: identical to the dialog\'s own '
            'footer, unlike the header, which carries no band at all '
            'here.',
        "The title paints theme.foreground and the description "
            'theme.mutedForeground: the same pairing as the plain '
            "dialog's title and description.",
        "Action's destructive variant and Cancel's outline variant are "
            'the only per-instance color choices; both can be '
            'overridden through the variant parameter, though every '
            'real call site in the corpus leaves them at their '
            'defaults.',
      ]),
      const DocsApiTable(
        title: 'Layout tokens',
        facts: <DocsApiFact>[
          DocsApiFact(
            name: 'ElAlertDialogHeader.gap',
            type: 'static double (get)',
            description: 'gap-1.5, ~6px, between title and description.',
          ),
        ],
      ),
    ],
  );
}

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
