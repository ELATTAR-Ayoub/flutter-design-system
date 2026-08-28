import 'dart:io';

void main() {
  final Map<String, List<String>> targets = <String, List<String>>{
    'example/lib/docs/docs_layout.dart': <String>['ScrollPosition'],
    'example/lib/docs/docs_section.dart': <String>['ScrollPosition'],
    'example/test/components_docs/agent_markdown_test.dart': <String>[
      'RichText',
    ],
  };
  var changed = 0;
  for (final MapEntry<String, List<String>> entry in targets.entries) {
    final File file = File(entry.key);
    final String source = file.readAsStringSync();
    String updated = source;
    for (final String name in entry.value) {
      updated = updated.replaceAllMapped(
        RegExp('(?<!flutter\\.)\\b${RegExp.escape(name)}\\b'),
        (_) => 'flutter.$name',
      );
    }
    // Import combinators name the unqualified declaration.
    updated = updated.replaceAll('show flutter.', 'show ');
    for (final String name in entry.value) {
      updated = updated.replaceAll('        flutter.$name,', '        $name,');
    }
    if (updated == source) continue;
    file.writeAsStringSync(updated);
    changed++;
  }
  stdout.writeln('qualified Flutter types in $changed example files');
}
