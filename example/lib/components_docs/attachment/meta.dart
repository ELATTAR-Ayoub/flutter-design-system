/// Public documentation metadata for the `attachment` component.
///
/// `attachment` HAS a real `registry/components/attachment.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `button`, `dialog`, `icon`, `icon-swap`,
/// `source-foundation`.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry attachmentDoc = ComponentDocEntry(
  name: 'attachment',
  title: 'Attachment',
  description:
      'A file, in a conversation. Five states, because a file being '
      'uploaded, a file being read and a file that failed are three '
      'different things and a spinner alone says none of them.',
  // registry/components/attachment.json's own registryDependencies,
  // verbatim.
  dependencies: <String>[
    'button',
    'dialog',
    'icon',
    'icon-swap',
    'source-foundation',
  ],
  exports: <String>[
    'ElAttachmentState',
    'ElAttachmentSize',
    'ElAttachmentOrientation',
    'ElAttachmentMediaVariant',
    'ElAttachmentScope',
    'ElAttachment',
    'ElAttachmentMedia',
    'ElAttachmentContent',
    'ElAttachmentTitle',
    'ElShimmerText',
    'ElAttachmentDescription',
    'ElAttachmentActions',
    'ElAttachmentAction',
    'ElAttachmentTrigger',
    'ElAttachmentGroup',
  ],
  sourcePath: 'lib/src/components/attachment.dart',
);
