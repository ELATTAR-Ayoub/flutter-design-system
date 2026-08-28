import 'dart:io';

const Map<String, String> _special = <String, String>{
  'Row': 'SpecimenRow',
  'RowAlign': 'SpecimenRowAlign',
};

const List<String> _ownerFiles = <String>[
  'example/lib/kit.dart',
  'example/lib/nav.dart',
  'example/lib/logo.dart',
  'example/lib/token_swatch.dart',
  'example/lib/shell.dart',
  'example/lib/agent/mock_transport.dart',
  'example/lib/pages/transcript.dart',
  'example/lib/components_docs/validation_rule/page.dart',
];

void main() {
  final Directory root = Directory.current;
  final RegExp declaration = RegExp(
    r'\b(?:class|enum|mixin|typedef|extension(?:\s+type)?)\s+(El[A-Z][A-Za-z0-9_]*)\b',
  );
  final List<File> files = <File>[
    for (final FileSystemEntity entity in Directory(
      '${root.path}${Platform.pathSeparator}example',
    ).listSync(recursive: true))
      if (entity is File && entity.path.endsWith('.dart')) entity,
  ];
  final Set<String> localNames = <String>{
    for (final String relative in _ownerFiles)
      for (final File file in <File>[
        File(
          '${root.path}${Platform.pathSeparator}${relative.replaceAll('/', Platform.pathSeparator)}',
        ),
      ])
        for (final RegExpMatch match in declaration.allMatches(
          file.readAsStringSync(),
        ))
          match.group(1)!,
  };
  var changed = 0;
  for (final File file in files) {
    final String source = file.readAsStringSync();
    String updated = source;
    for (final String current in localNames) {
      updated = updated.replaceAll(
        RegExp('\\b${RegExp.escape(current)}\\b'),
        _special[current] ?? current.substring(2),
      );
    }
    if (updated == source) continue;
    file.writeAsStringSync(updated);
    changed++;
  }
  stdout.writeln(
    'renamed ${localNames.length} local example types in $changed files',
  );
}
