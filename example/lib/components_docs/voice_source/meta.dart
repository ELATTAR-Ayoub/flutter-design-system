/// Public documentation metadata for the `voice-source` component.
///
/// `voice-source` HAS a real `registry/components/voice-source.json`
/// manifest: [dependencies] below is that manifest's own
/// `registryDependencies` list, copied verbatim — empty. `voice-source` is
/// the seam behind [MicControl] ([AgentConsole.voiceSource]), not a
/// consumer of anything else in the registry.
///
/// One file, three exports, read end to end from
/// `lib/src/components/ui/voice_source.dart`,
/// `lib/src/components/ui/voice_source_base.dart` (the interface: the
/// `VoiceSource` abstract class and `VoiceSourceStatus` enum) and
/// `lib/src/components/ui/voice_source_stub.dart` (`createVoiceSource`, the
/// package's own honest no-op).
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry voiceSourceDoc = ComponentDocEntry(
  name: 'voice_source',
  title: 'Voice Source',
  description:
      'The microphone seam behind MicControl: an interface for real audio '
      'capture, a status enum a caller can put into words, and this '
      "package's own honest no-op — real capture is a consuming app's to "
      'supply.',
  // registry/components/voice-source.json's own registryDependencies,
  // verbatim: empty.
  dependencies: <String>[],
  exports: <String>['VoiceSource', 'VoiceSourceStatus', 'createVoiceSource'],
  sourcePath: 'lib/src/components/ui/voice_source.dart',
);
