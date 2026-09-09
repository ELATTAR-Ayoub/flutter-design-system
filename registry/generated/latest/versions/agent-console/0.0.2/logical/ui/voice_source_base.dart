/// The neutral half of [VoiceSource]: the interface [MicControl]'s owner
/// wires up, with no `dart:js_interop` in sight.
///
/// Split out of `voice_source.dart` and `voice_source_stub.dart` mainly so
/// the type is easy to find, and so a consuming app's own real
/// implementation (this repository's example gallery has one, in
/// `example/lib/voice_source_web.dart` — real capture cannot live inside
/// this package, see that file's own docs for why) has exactly this and
/// nothing else to depend on.
library;

import 'package:flutter/foundation.dart';

/// Lifecycle and permission state of a [VoiceSource].
///
/// *"The control must end in an honest state the user can understand rather
/// than sitting armed with a flat line pretending to listen."* — every
/// terminal state below (everything except [requesting]) is something
/// [MicControl]'s owner can put into words and show the user.
enum VoiceSourceStatus {
  /// Not capturing. The resting state before [VoiceSource.start] and after
  /// a clean [VoiceSource.stop].
  idle,

  /// [VoiceSource.start] has been called and the platform's permission
  /// prompt, if there is one, has not resolved yet.
  requesting,

  /// Capturing. [VoiceSource.samples] and [VoiceSource.spectrum] receive
  /// frames.
  active,

  /// The user denied the microphone permission, or dismissed the browser's
  /// prompt without answering either way.
  denied,

  /// No capture is possible here: an insecure origin (`getUserMedia` only
  /// runs on HTTPS or `localhost`), no `mediaDevices` API at all, or no
  /// input device connected.
  unavailable,

  /// Permission was granted but the audio graph itself failed to build.
  error,
}

/// A time-domain/frequency-domain audio source — what [VoiceSource.new]
/// hands [MicControl]'s owner instead of the `AnalyserNode` the reference
/// keeps.
///
/// [LiveWaveform.samples] and [BarVisualizer.spectrum] already take exactly
/// these two listenables (see `voice.dart`); this is what fills them with a
/// real microphone instead of leaving them null. This package ships one
/// implementation of its own — `voice_source_stub.dart`'s honest no-op,
/// on every platform it builds for — and `AgentConsole.voiceSource` accepts
/// any other: a consuming web app supplies a real `getUserMedia`-backed one
/// (see `example/lib/voice_source_web.dart` in this repository) the same
/// way a test supplies a fake one.
abstract class VoiceSource {
  /// [start]/[stop] lifecycle and permission state. Starts at
  /// [VoiceSourceStatus.idle].
  ValueListenable<VoiceSourceStatus> get status;

  /// Time-domain samples, −1 … 1, exactly what
  /// `analyser.getFloatTimeDomainData` would have written. Empty
  /// (`Float32List(0)`) until a frame has actually arrived — [LiveWaveform]
  /// already reads an empty or null buffer as "draw the flat line," so a
  /// source that has not started yet costs it nothing.
  ValueListenable<Float32List> get samples;

  /// Frequency bins, 0 … 255 — the same scale `analyser.getByteFrequencyData`
  /// would have written. Empty until a frame has arrived, for the same
  /// reason as [samples]; [BarVisualizer] falls back to its own oscillator
  /// while [spectrum] is empty.
  ValueListenable<Float32List> get spectrum;

  /// Requests the microphone and starts the frame loop. A no-op while
  /// already [VoiceSourceStatus.requesting] or [VoiceSourceStatus.active].
  ///
  /// Never throws — every failure (denial, no device, an insecure origin,
  /// a broken audio graph) lands in [status] instead, because there is no
  /// caller here positioned to show a user a caught exception.
  Future<void> start();

  /// Stops the frame loop and releases every track of the underlying
  /// stream. Safe to call when not capturing. Leaves a [status] of
  /// [VoiceSourceStatus.denied], [VoiceSourceStatus.unavailable] or
  /// [VoiceSourceStatus.error] exactly where it found it — those are not
  /// "stopped," they are the reason capture never ran.
  void stop();

  /// Releases everything, including the listenables themselves. [start]
  /// must not be called again afterwards.
  void dispose();
}
