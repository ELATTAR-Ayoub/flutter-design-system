import 'package:elattar_cli/elattar_cli.dart';

Future<void> main() async {
  // The executable is the normal integration. The library entry point is
  // useful when another Dart tool needs Elattar's command dispatcher in the
  // same process.
  final int exitCode = await runElattarCli(<String>['--version']);
  if (exitCode != 0) {
    throw StateError('Elattar exited with code $exitCode.');
  }
}
