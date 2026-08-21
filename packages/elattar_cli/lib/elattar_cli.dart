library;

export 'src/commands/app.dart' show ElattarCli;

import 'src/commands/app.dart';

Future<int> runElattarCli(List<String> arguments) {
  return ElattarCli().run(arguments);
}
