import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) {
  if (arguments.length != 1) {
    stderr.writeln(
      'Usage: dart run tool/report_test_failures.dart <report.json>',
    );
    exitCode = 64;
    return;
  }

  final report = File(arguments.single);
  if (!report.existsSync()) {
    stdout.writeln('No Dart test report was produced at ${report.path}.');
    return;
  }

  final tests = <int, Map<String, Object?>>{};
  var reported = 0;

  for (final line in report.readAsLinesSync()) {
    final event = jsonDecode(line) as Map<String, Object?>;
    switch (event['type']) {
      case 'testStart':
        final test = event['test'] as Map<String, Object?>;
        tests[test['id']! as int] = test;
      case 'error':
        if (event['isFailure'] != true) continue;
        final test = tests[event['testID']! as int];
        final name = test?['name'] as String? ?? 'unknown test';
        final stage = _knownStage(event['error'] as String? ?? '');
        stdout.writeln(
          '::error title=CLI test failure::${_escape(name)} [$stage]',
        );
        reported++;
    }
  }

  if (reported == 0) {
    stdout.writeln(
      '::warning title=CLI test report::The test command failed, but the JSON '
      'report contained no test failure event.',
    );
  }
}

String _knownStage(String error) {
  const stages = <(String, String)>[
    ('init\n', 'init'),
    ('add button\n', 'add button'),
    ('pub get\n', 'dependency resolution'),
    ('doctor\n', 'doctor'),
    ('the CLI never fetched the served index', 'registry index fetch'),
    ('button\'s payload was not fetched', 'button payload fetch'),
    ('was not installed', 'installed-file check'),
    ('analyze\n', 'consumer analysis'),
    ('flutter test\n', 'consumer widget test'),
    ('silently-empty test directory', 'consumer test report'),
  ];
  for (final (marker, label) in stages) {
    if (error.contains(marker)) return label;
  }
  return 'assertion';
}

String _escape(String value) => value
    .replaceAll('%', '%25')
    .replaceAll('\r', '%0D')
    .replaceAll('\n', '%0A');
