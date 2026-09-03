/// Programmatic entry points for Elattar's source-owned Flutter UI installer.
library;

export 'src/commands/app.dart' show ElattarCli;

import 'src/commands/app.dart';

/// Runs the Elattar command with [arguments] and returns its process exit code.
///
/// Most consumers install the `elattar` executable. This function exists for
/// Dart integrations and test harnesses that need the same command dispatcher
/// without starting another process.
Future<int> runElattarCli(List<String> arguments) {
  return ElattarCli().run(arguments);
}
