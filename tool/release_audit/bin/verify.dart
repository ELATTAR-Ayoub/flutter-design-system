/// `dart run tool/release_audit/bin/verify.dart [repo-root]`
///
/// One command that fails if the release is not shippable. It needs the Dart
/// SDK and nothing else — no `pub get`, no Flutter, no network — so CI can run
/// it in its first minute rather than after eighteen.
library;

import 'dart:io';

// The generator's own sha256 — the exact implementation that wrote the hashes
// this audit recomputes. See `Sha256Hex` in audit.dart for why it arrives by
// injection rather than by import.
import '../../registry_builder/lib/generator.dart' show sha256Hex;
import '../lib/audit.dart';

void main(List<String> arguments) {
  if (arguments.length > 1) {
    stderr.writeln('usage: verify.dart [repo-root]');
    exit(64);
  }

  final String root = arguments.isEmpty
      ? Directory.current.path
      : arguments.single;

  if (!File('$root/pubspec.yaml').existsSync()) {
    stderr.writeln('release audit: $root is not a checkout of this repository');
    exit(66);
  }

  final AuditReport report = auditRelease(root, sha256Hex: sha256Hex);
  stdout.write(report.render());

  if (!report.ok) {
    stderr.writeln(
      'Release audit failed. Nothing above is a style preference: each '
      'failure is a statement the release would publish and could not '
      'support.',
    );
    exit(1);
  }
}
