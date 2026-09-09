/// `voice_source.dart`'s one and only implementation *inside this package* —
/// on every platform, the web included.
///
/// Two independent reasons converge on the same file:
///
///  * **Mobile is explicitly out of scope.** Real capture there needs a
///    platform plugin, which is a dependency this zero-dependency package
///    does not take.
///  * **The web needs `dart:js_interop` to capture anything, and
///    `test/flutter_authority_test.dart` forbids that import — any
///    `dart:js`-family import — anywhere under this package's `lib/`.**
///    *"The shipped package is native Flutter with no browser runtime seam"*
///    is a harder rule than "no pub dependency," so real `getUserMedia`
///    capture cannot live here even hand-written against SDK-only APIs.
///
/// So this is not a lesser [VoiceSource] waiting for a plugin — it is the
/// documented ceiling of what this package can offer on its own, and it
/// costs nothing: [start] never touches [status], [samples] or [spectrum],
/// which is exactly [MicControl]'s behaviour before this seam existed.
/// [MicControl] still arms on press — that bit is pure UI state its owner
/// holds — and [BarVisualizer] still falls back to its own `active`
/// oscillator, because [spectrum] never receives a frame to fall back
/// *from*. A consuming web app that wants real audio supplies its own
/// [VoiceSource] to `AgentConsole.voiceSource` — this repository's own
/// example gallery does exactly that (`example/lib/voice_source_web.dart`).
///
/// **On purpose, not [VoiceSourceStatus.unavailable].** A status flip would
/// be true — there genuinely is no microphone behind *this*
/// implementation — but it would also un-arm [MicControl] the instant it is
/// pressed on every platform this package ships to on its own, which is not
/// "unaffected," it is a regression dressed as honesty. The
/// [VoiceSourceStatus.unavailable] branch exists for a source whose
/// permission model actually has a rejection to report (see
/// `example/lib/voice_source_web.dart`); a stub with no permission model in
/// the first place has nothing dishonest to correct.
library;

import 'package:flutter/foundation.dart';

import 'voice_source_base.dart';

/// The stub — see this file's own docs for why it never leaves
/// [VoiceSourceStatus.idle].
VoiceSource createVoiceSource() => _StubVoiceSource();

class _StubVoiceSource implements VoiceSource {
  final ValueNotifier<VoiceSourceStatus> _status =
      ValueNotifier<VoiceSourceStatus>(VoiceSourceStatus.idle);
  final ValueNotifier<Float32List> _samples = ValueNotifier<Float32List>(
    Float32List(0),
  );
  final ValueNotifier<Float32List> _spectrum = ValueNotifier<Float32List>(
    Float32List(0),
  );

  @override
  ValueListenable<VoiceSourceStatus> get status => _status;

  @override
  ValueListenable<Float32List> get samples => _samples;

  @override
  ValueListenable<Float32List> get spectrum => _spectrum;

  @override
  Future<void> start() async {
    // No-op, deliberately — see the library docs above.
  }

  @override
  void stop() {
    // Nothing was ever started.
  }

  @override
  void dispose() {
    _status.dispose();
    _samples.dispose();
    _spectrum.dispose();
  }
}
