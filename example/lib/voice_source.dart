/// The gallery's microphone seam: real `getUserMedia` capture on the web,
/// the package's own no-op everywhere else.
///
/// Same shape as `scroll_bridge.dart` and for the same reason: the real
/// implementation (`voice_source_web.dart`) imports `dart:js_interop`,
/// which does not exist on the Dart VM this app's own widget tests run on,
/// so a conditional export keeps [createExampleVoiceSource] compiling
/// everywhere while only ever choosing one implementation per platform.
///
/// This lives in the app rather than the package on purpose — see
/// `voice_source_web.dart`'s own docs for why real capture cannot live
/// inside `elattar_design_system`'s `lib/`.
library;

export 'voice_source_fallback.dart'
    if (dart.library.js_interop) 'voice_source_web.dart'
    show createExampleVoiceSource;
