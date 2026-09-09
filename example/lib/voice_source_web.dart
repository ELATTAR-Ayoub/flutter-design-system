/// The web half of `voice_source.dart`: real `getUserMedia` capture for the
/// gallery's own `AgentConsole`.
///
/// **Why this lives here and not in the package.** `elattar_design_system`
/// ships `VoiceSource`/`VoiceSourceStatus` (see `voice_source_base.dart` in
/// the package) and a stub `createVoiceSource()` that never leaves it —
/// the package's own `test/flutter_authority_test.dart` pins *"the shipped
/// package is native Flutter with no browser runtime seam,"* which forbids
/// any `dart:js`-family import under the package's `lib/`, not only a pub
/// dependency. Real capture therefore has to live in the app that wants it,
/// exactly where `scroll_bridge_web.dart` already put the capture rig's own
/// `dart:js_interop` code for the same reason.
///
/// *"`dart:js_interop` ships with the SDK"* — so this reaches `navigator.
/// mediaDevices.getUserMedia`, `AudioContext` and `AnalyserNode` by hand,
/// with a handful of private `extension type`s over `JSObject` declared just
/// below, rather than `package:web`. Each one exposes only the members this
/// file actually calls.
///
/// ## The graph
///
/// `getUserMedia({audio: true})` → a `MediaStream` → `AudioContext.
/// createMediaStreamSource` → an `AnalyserNode`. The analyser is never
/// connected to `context.destination`: this reads the microphone, it does
/// not play it back through the user's speakers.
///
/// A `Timer.periodic` (there is no widget here to own a `Ticker`) drains it
/// roughly sixty times a second: `getFloatTimeDomainData` into `samples`
/// unchanged (−1 … 1, exactly what `LiveWaveform` wants), and
/// `getFloatFrequencyData` into `spectrum` through `_toByteScale` — see that
/// method for why a conversion is needed at all.
///
/// ## Permission and the secure-context rule
///
/// `getUserMedia` is unavailable on any origin that is not HTTPS or
/// `localhost`; asking anyway throws rather than prompting. `start` checks
/// `window.isSecureContext` and `navigator.mediaDevices` itself and reports
/// `VoiceSourceStatus.unavailable` without ever calling the browser, so the
/// failure is this file's own rather than an uncaught JS exception.
///
/// Once the prompt is live, `getUserMedia`'s promise rejects with a
/// `DOMException` for every other failure — denial or dismissal
/// (`NotAllowedError`, `SecurityError`), no input device
/// (`NotFoundError`, `OverconstrainedError`) — read off its `.name` in
/// `_domExceptionName` and sorted into `VoiceSourceStatus.denied` or
/// `VoiceSourceStatus.unavailable`; anything else lands in
/// `VoiceSourceStatus.error` rather than being swallowed.
///
/// ## Release
///
/// `stop` — called on every disarm and from `dispose` — cancels the frame
/// timer, calls `.stop()` on every track `MediaStream.getTracks()` returns,
/// and closes the `AudioContext`. A stream nobody stops keeps the browser's
/// own recording indicator lit after the user has closed the mic control;
/// nulling the field without calling `.stop()` on each track would do
/// exactly that while looking, from this file, like cleanup.
library;

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/foundation.dart';

/// The gallery's web source.
VoiceSource createExampleVoiceSource() => _WebVoiceSource();

/* ── raw browser bindings ────────────────────────────────────────────────
 * Hand-declared rather than `package:web`: each `extension type` below
 * wraps `JSObject` and exposes only the members this file calls. */

@JS('window.isSecureContext')
external bool get _isSecureContext;

@JS('navigator.mediaDevices')
external JSObject? get _mediaDevicesOrNull;

extension type _MediaDevices._(JSObject _) implements JSObject {
  external JSPromise<JSObject> getUserMedia(JSObject constraints);
}

extension type _MediaStream._(JSObject _) implements JSObject {
  external JSArray<JSObject> getTracks();
}

extension type _MediaStreamTrack._(JSObject _) implements JSObject {
  external void stop();
}

@JS('AudioContext')
extension type _AudioContext._(JSObject _) implements JSObject {
  external factory _AudioContext();
  external _AnalyserNode createAnalyser();
  external _MediaStreamAudioSourceNode createMediaStreamSource(
    JSObject stream,
  );
  external JSPromise<JSAny?> close();
}

extension type _AnalyserNode._(JSObject _) implements JSObject {
  external set fftSize(int value);
  external int get frequencyBinCount;
  external set minDecibels(num value);
  external set maxDecibels(num value);
  external void getFloatTimeDomainData(JSFloat32Array array);
  external void getFloatFrequencyData(JSFloat32Array array);
}

extension type _MediaStreamAudioSourceNode._(JSObject _) implements JSObject {
  external void connect(JSObject destination);
}

/* ── the source ─────────────────────────────────────────────────────────── */

class _WebVoiceSource implements VoiceSource {
  final ValueNotifier<VoiceSourceStatus> _status =
      ValueNotifier<VoiceSourceStatus>(VoiceSourceStatus.idle);
  final ValueNotifier<Float32List> _samples = ValueNotifier<Float32List>(
    Float32List(0),
  );
  final ValueNotifier<Float32List> _spectrum = ValueNotifier<Float32List>(
    Float32List(0),
  );

  _MediaStream? _stream;
  _AudioContext? _context;
  Timer? _frameTimer;
  bool _disposed = false;

  /// Bumped by [stop] (and so by [dispose], which calls it). `getUserMedia`'s
  /// promise can still be pending when the user disarms — the pill answers a
  /// press instantly, the browser's permission prompt does not — and without
  /// this, a grant that arrives *after* [stop] would start the graph anyway,
  /// which is precisely the "leaked stream nobody asked for" [stop] exists to
  /// prevent. [start] captures this before awaiting and checks it after;
  /// a mismatch means a [stop] happened in between and the result is
  /// released unused rather than adopted.
  int _generation = 0;

  /// Samples per channel `getFloatTimeDomainData` fills. `AnalyserNode`
  /// requires a power of two; the reference's own default.
  static const int _fftSize = 1024;

  /// `AnalyserNode`'s own default decibel range, set explicitly rather than
  /// left implicit so [_toByteScale]'s inverse of it can never drift out
  /// from under a browser default that changed.
  static const num _minDecibels = -100;
  static const num _maxDecibels = -30;
  static const num _decibelRange = _maxDecibels - _minDecibels;

  /// ~60Hz. Not a design-system motion duration — a polling interval for a
  /// data source with no `Ticker` of its own to drive it.
  // allow-hardcoded: audio frame-loop interval, not layout/motion.
  static const Duration _frameInterval = Duration(milliseconds: 16);

  @override
  ValueListenable<VoiceSourceStatus> get status => _status;

  @override
  ValueListenable<Float32List> get samples => _samples;

  @override
  ValueListenable<Float32List> get spectrum => _spectrum;

  @override
  Future<void> start() async {
    if (_status.value == VoiceSourceStatus.active ||
        _status.value == VoiceSourceStatus.requesting) {
      return;
    }

    // The secure-context rule: `getUserMedia` throws rather than prompting
    // on an origin that is not HTTPS or `localhost`. Caught here, honestly,
    // instead of surfacing as an uncaught JS exception from the call below.
    final JSObject? mediaDevices = _mediaDevicesOrNull;
    if (!_isSecureContext || mediaDevices == null) {
      _status.value = VoiceSourceStatus.unavailable;
      return;
    }

    _status.value = VoiceSourceStatus.requesting;
    final int myGeneration = ++_generation;

    final JSObject constraints = JSObject();
    constraints.setProperty('audio'.toJS, true.toJS);

    try {
      final JSObject rawStream = await (mediaDevices as _MediaDevices)
          .getUserMedia(constraints)
          .toDart;
      if (_disposed || myGeneration != _generation) {
        // Disposed, or stopped while the prompt was still pending: keep
        // nothing the user already asked to release, however late it
        // arrived.
        _stopTracks(rawStream as _MediaStream);
        return;
      }
      _stream = rawStream as _MediaStream;
      _startGraph(_stream!);
      _status.value = VoiceSourceStatus.active;
    } catch (error) {
      if (_disposed || myGeneration != _generation) return;
      _status.value = switch (_domExceptionName(error)) {
        'NotAllowedError' || 'SecurityError' => VoiceSourceStatus.denied,
        'NotFoundError' || 'OverconstrainedError' =>
          VoiceSourceStatus.unavailable,
        _ => VoiceSourceStatus.error,
      };
    }
  }

  void _startGraph(_MediaStream stream) {
    final _AudioContext context = _AudioContext();
    final _AnalyserNode analyser = context.createAnalyser()
      ..fftSize = _fftSize
      ..minDecibels = _minDecibels
      ..maxDecibels = _maxDecibels;
    // Source → analyser only. Never `.connect(context.destination)` — this
    // reads the microphone, it does not play it back.
    context.createMediaStreamSource(stream).connect(analyser);
    _context = context;

    final int binCount = analyser.frequencyBinCount;
    _frameTimer = Timer.periodic(_frameInterval, (_) {
      final JSFloat32Array timeBuffer = JSFloat32Array.withLength(_fftSize);
      analyser.getFloatTimeDomainData(timeBuffer);
      _samples.value = Float32List.fromList(timeBuffer.toDart);

      final JSFloat32Array freqBuffer = JSFloat32Array.withLength(binCount);
      analyser.getFloatFrequencyData(freqBuffer);
      _spectrum.value = _toByteScale(freqBuffer.toDart);
    });
  }

  /// `getFloatFrequencyData` fills decibels across `[minDecibels,
  /// maxDecibels]`; `BarVisualizer` expects the 0 … 255 scale
  /// `getByteFrequencyData` would have written — precisely what a browser
  /// derives from the float data internally (`byte = (db − minDb) / (maxDb
  /// − minDb) × 255`, clamped). Same formula, run here instead of asking the
  /// browser for the byte view directly, so the analyser's own settings stay
  /// in one place.
  static Float32List _toByteScale(Float32List decibels) {
    final Float32List out = Float32List(decibels.length);
    for (int i = 0; i < decibels.length; i++) {
      final double scaled = (decibels[i] - _minDecibels) / _decibelRange * 255;
      out[i] = scaled.clamp(0, 255).toDouble();
    }
    return out;
  }

  void _stopTracks(_MediaStream stream) {
    for (final JSObject track in stream.getTracks().toDart) {
      (track as _MediaStreamTrack).stop();
    }
  }

  @override
  void stop() {
    _generation++;
    _frameTimer?.cancel();
    _frameTimer = null;

    final _MediaStream? stream = _stream;
    _stream = null;
    if (stream != null) _stopTracks(stream);

    final _AudioContext? context = _context;
    _context = null;
    if (context != null) unawaited(context.close().toDart);

    // A denied/unavailable/error status is itself the honest resting state
    // — stop() must not paper over it back to idle. Only a source that was
    // actually running (or mid-prompt) returns to idle here.
    if (_status.value == VoiceSourceStatus.active ||
        _status.value == VoiceSourceStatus.requesting) {
      _status.value = VoiceSourceStatus.idle;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    stop();
    _status.dispose();
    _samples.dispose();
    _spectrum.dispose();
  }
}

/// The rejection from `getUserMedia`'s promise is the `DOMException` itself
/// (or, per `NullRejectionException`, nothing usable) — its `.name` is the
/// browser's own vocabulary (`NotAllowedError`, `NotFoundError`, …).
String _domExceptionName(Object error) {
  // `error` is typed `Object` because a caught exception can, in principle,
  // be a plain Dart one — this check is exactly what tells a `DOMException`
  // apart from that, so it cannot be replaced with `isA`, which only applies
  // once a value is already known to be a JS one.
  // ignore: invalid_runtime_check_with_js_interop_types
  if (error is JSObject) {
    final JSAny? name = error['name'];
    if (name.isA<JSString>()) return (name as JSString).toDart;
  }
  return '';
}
