/// Public documentation metadata for the avatar component.
///
/// `avatar` has no `registry/components/avatar.json` manifest yet: see
/// `AvatarDocPage`'s installation section for what that means today. Because
/// there is no manifest, [avatarDoc.dependencies] is deliberately empty
/// rather than naming registry items nothing has verified; a worker that
/// invents a dependency name here is exactly the failure mode Phase J's
/// supervisor notes are warning about.
library;

import '../catalog.dart' show ComponentDocEntry;

/// `avatar`: a round identity mark: [DsAvatar]'s own image if it loads,
/// initials underneath if it does not.
const ComponentDocEntry avatarDoc = ComponentDocEntry(
  name: 'avatar',
  title: 'Avatar',
  description:
      'A round identity mark that shows a photo when it loads and initials underneath when it does not.',
  dependencies: <String>[],
  exports: <String>[
    'DsAvatar',
    'DsAvatarSize',
    'DsAvatarRing',
    'dsAvatarRingWidth',
    'DsAvatarBadge',
    'DsAvatarGroup',
    'DsAvatarGroupCount',
    'DsAvatarRimPainter',
  ],
  sourcePath: 'lib/src/components/avatar.dart',
);
