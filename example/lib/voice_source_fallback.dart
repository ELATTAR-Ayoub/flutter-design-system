/// The non-web half of `voice_source.dart`: see that library for the why.
///
/// Every widget test in this app mounts its pages on the Dart VM, and a
/// non-web build of the gallery has nowhere to ask `getUserMedia` either —
/// both simply get the package's own honest no-op, `createVoiceSource()`
/// from `elattar_design_system`. There is nothing gallery-specific to add
/// here; this file exists only so `voice_source.dart`'s conditional export
/// has a non-web half to fall back to, exactly as `scroll_bridge_stub.dart`
/// does for the capture rig's scroll seam.
library;

import 'package:elattar_design_system/elattar_design_system.dart';

/// The gallery's non-web source: the package's own stub.
VoiceSource createExampleVoiceSource() => createVoiceSource();
