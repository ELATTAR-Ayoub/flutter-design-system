/// The microphone seam behind [MicControl]: [VoiceSource] and
/// [VoiceSourceStatus], plus the package's own default source.
///
/// *"There is no `AnalyserNode`, and there is no microphone… this port takes
/// no third-party dependency."* — `voice.dart`'s own words, written when
/// [LiveWaveform] and [BarVisualizer] were built to take real data but had
/// none to take. [VoiceSource] is that data's interface.
///
/// **This package ships only the honest no-op.** `test/flutter_authority_test.dart`
/// pins a second, harder rule than "no pub dependency": *"the shipped
/// package is native Flutter with no browser runtime seam"* — no
/// `dart:js`-family import anywhere under `lib/`, full stop, so
/// `getUserMedia`/Web Audio capture cannot live here even hand-written
/// against `dart:js_interop` alone. [createVoiceSource] therefore always
/// resolves to `voice_source_stub.dart`'s no-op, on every platform including
/// the web — which is exactly [MicControl]'s behaviour before this file
/// existed, so a console that never sees a different [VoiceSource] is
/// unaffected by any of this.
///
/// **A consuming app can still capture real audio.** `AgentConsole.voiceSource`
/// takes any [VoiceSource]; a web app supplies its own, real,
/// `dart:js_interop`-backed implementation and passes it in — this
/// repository's own example gallery does exactly that
/// (`example/lib/voice_source.dart`, `example/lib/voice_source_web.dart`),
/// using the identical conditional-import shape `scroll_bridge.dart` already
/// established for the capture rig's scroll seam, because the constraint is
/// the same one: the real implementation imports `dart:js_interop`, which
/// does not exist on the Dart VM this package's own test suite runs on.
library;

export 'voice_source_base.dart';
export 'voice_source_stub.dart' show createVoiceSource;
