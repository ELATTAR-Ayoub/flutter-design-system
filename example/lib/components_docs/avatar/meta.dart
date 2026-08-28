/// Public documentation metadata for the avatar component.
///
/// **Correction.** This file previously claimed `avatar` had no
/// `registry/components/avatar.json` manifest yet. That was false:
/// `registry/components/avatar.json` exists, lists exactly one file
/// (`lib/src/components/avatar.dart`) and one registry dependency
/// (`source-foundation`), and its own `documentationRoute` already points
/// at `/components/avatar`. [dependencies] below mirrors that shipped
/// manifest, not an invented list.
library;

import '../catalog.dart' show ComponentDocEntry;

/// `avatar`: a round identity mark: [Avatar]'s own image if it loads,
/// initials underneath if it does not.
const ComponentDocEntry avatarDoc = ComponentDocEntry(
  name: 'avatar',
  title: 'Avatar',
  description:
      'A round identity mark that shows a photo when it loads and initials underneath when it does not.',
  dependencies: <String>['source-foundation'],
  exports: <String>[
    'Avatar',
    'AvatarSize',
    'AvatarRing',
    'avatarRingWidth',
    'AvatarBadge',
    'AvatarGroup',
    'AvatarGroupCount',
    'AvatarRimPainter',
  ],
  sourcePath: 'lib/src/components/avatar.dart',
);
