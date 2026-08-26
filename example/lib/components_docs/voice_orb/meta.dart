/// Public documentation metadata for the `voice-orb` registry item.
///
/// `voice-orb` is typed `effect` in `registry/generated/latest/registry.json`
/// (`lib/src/effects/voice_orb.dart`), but unlike this port's other nine
/// effects it is a real, always-visible surface — the voice face itself —
/// not a treatment layered on top of a host a caller supplies. So this page
/// stages it with `ShowcaseSection`, the same kit case every component page
/// uses, rather than `EffectSection`.
///
/// [dependencies] is `registry/generated/latest/registry.json`'s own
/// `registryDependencies` for `voice-orb`, copied verbatim:
/// `source-foundation` alone — the shader and its perlin texture ship as
/// the item's own `assets`/`shaders` fields, not as a second registry item.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry voiceOrbDoc = ComponentDocEntry(
  name: 'voice_orb',
  title: 'Voice Orb',
  description:
      'The voice face: a shader-painted disc that reacts to a level '
      'the caller feeds it, coloured from the theme and never from a '
      'microphone this package opens itself.',
  // registry/generated/latest/registry.json's "voice-orb" entry, verbatim.
  dependencies: <String>['source-foundation'],
  exports: <String>['ElOrbState', 'ElOrbProgram', 'ElVoiceOrb'],
  sourcePath: 'lib/src/effects/voice_orb.dart',
);
