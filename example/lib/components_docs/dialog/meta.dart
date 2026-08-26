/// Public documentation metadata for the `dialog` component.
///
/// `dialog` has a real `registry/components/dialog.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `button`, `icon`, `machine-surface`,
/// `source-foundation`. [exports] is the manifest's own `exports` list,
/// also verbatim: the modal portal machinery (`ElModalPortal`,
/// `ElDialogOverlay`, `ElJellyTransition`) that a sheet, a drawer, and the
/// alert dialog all ride too, plus the dialog-specific composition
/// (`ElDialog` down through `ElDialogMedia`). `page.dart` renders the real
/// `elattar add dialog` command from it rather than a "not available yet"
/// disclosure.
///
/// **Re-housed, not re-invented.** This page used to be `DialogDocPage` in
/// `example/lib/components_docs/dialog_page.dart`, hand-composing
/// `ElSection` panels rather than declaring a `ComponentDocSpec`. It has
/// moved into its own directory, onto the kit `button` and `field` already
/// use; the live preview specimen moved with it, rebuilt as two named
/// `ShowcaseSection`s instead of one combined `DocsCodeExample`. See
/// `page.dart`'s own library doc for what the re-housing added.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry dialogDoc = ComponentDocEntry(
  name: 'dialog',
  title: 'Dialog',
  description:
      'An accessible modal portal with normal and media compositions.',
  // registry/components/dialog.json's own registryDependencies, verbatim.
  dependencies: <String>[
    'button',
    'icon',
    'machine-surface',
    'source-foundation',
  ],
  // registry/components/dialog.json's own exports, verbatim.
  exports: <String>[
    'ElModalPortal',
    'ElDialogOverlay',
    'ElJellyTransition',
    'ElDialog',
    'ElDialogVariant',
    'ElDialogContent',
    'ElDialogContentGroup',
    'ElDialogHeader',
    'ElDialogFooter',
    'ElDialogTitle',
    'ElDialogDescription',
    'ElDialogMedia',
  ],
  sourcePath: 'lib/src/components/dialog.dart',
);
