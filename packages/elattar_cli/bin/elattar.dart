import 'dart:io';

import 'package:elattar_cli/elattar_cli.dart';

Future<void> main(List<String> arguments) async {
  final int code = await runElattarCli(arguments);
  exit(code);
}
