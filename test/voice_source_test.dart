/// `voice_source_stub.dart` — what every non-web platform gets.
///
/// This suite runs on the Dart VM, which has no `dart:js_interop`, so
/// `createVoiceSource()` always resolves to the stub here — this file pins
/// exactly the platform the root suite actually runs on. The real
/// `getUserMedia` capture in `voice_source_web.dart` cannot be unit-tested
/// this way: it needs a browser, which is why `AgentConsole`'s own tests
/// (`agent_console_test.dart`) drive the seam through an injected fake
/// instead of the real implementation on either side of it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VoiceSource — non-web stub', () {
    test('starts idle, and start() never leaves it there', () async {
      final VoiceSource source = createVoiceSource();
      addTearDown(source.dispose);

      expect(source.status.value, VoiceSourceStatus.idle);
      await source.start();
      expect(source.status.value, VoiceSourceStatus.idle);
    });

    test(
      'samples and spectrum stay empty — nothing here fabricates a signal',
      () async {
        final VoiceSource source = createVoiceSource();
        addTearDown(source.dispose);

        await source.start();
        expect(source.samples.value, isEmpty);
        expect(source.spectrum.value, isEmpty);
      },
    );

    test('stop() is a no-op, safe before, during or after start()', () async {
      final VoiceSource source = createVoiceSource();
      addTearDown(source.dispose);

      expect(source.stop, returnsNormally);
      await source.start();
      expect(source.stop, returnsNormally);
      expect(source.stop, returnsNormally);
      expect(source.status.value, VoiceSourceStatus.idle);
    });
  });
}
