/// Public documentation metadata for the `voice` component.
///
/// `voice` HAS a real `registry/components/voice.json` manifest:
/// [dependencies] below is that manifest's own `registryDependencies` list,
/// copied verbatim: `button`, `icon`, `source-foundation`.
///
/// Three widgets from two reference files — `voice/visualisers.tsx`
/// ([ElLiveWaveform], [ElBarVisualizer]) and `voice/pickers.tsx`
/// ([ElMicControl]) — read end to end from `lib/src/components/voice.dart`
/// and from `test/agent_voice_test.dart`.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry voiceDoc = ComponentDocEntry(
  name: 'voice',
  title: 'Voice',
  description:
      'The listening surface: a time-domain waveform, a twelve-band '
      'frequency visualiser, and the mic pill that arms them — none of '
      'which ever invents a signal it was not given.',
  // registry/components/voice.json's own registryDependencies, verbatim.
  dependencies: <String>['button', 'icon', 'source-foundation'],
  exports: <String>['ElLiveWaveform', 'ElBarVisualizer', 'ElMicControl'],
  sourcePath: 'lib/src/components/voice.dart',
);
