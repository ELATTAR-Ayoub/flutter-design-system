library;

import 'dart:io';

import 'package:yaml/yaml.dart';

class FlutterProjectNotFound implements Exception {
  const FlutterProjectNotFound(this.message);

  final String message;

  @override
  String toString() => message;
}

class FlutterProject {
  const FlutterProject({
    required this.root,
    required this.pubspec,
    required this.data,
  });

  final Directory root;
  final File pubspec;
  final YamlMap data;

  bool get isFlutterProject =>
      _hasFlutterSdk(data['dependencies']) ||
      _hasFlutterSdk(data['dev_dependencies']);

  static bool _hasFlutterSdk(Object? section) {
    if (section is! YamlMap) return false;
    final Object? flutter = section['flutter'];
    return flutter is YamlMap && flutter['sdk'] == 'flutter';
  }
}

FlutterProject discoverFlutterProject({Directory? start, String? projectPath}) {
  Directory current = Directory(
    projectPath ?? start?.path ?? Directory.current.path,
  ).absolute;
  if (projectPath != null && !current.existsSync()) {
    throw FlutterProjectNotFound(
      'Project directory does not exist: ${current.path}',
    );
  }
  while (true) {
    final File pubspec = File(_join(current.path, 'pubspec.yaml'));
    if (pubspec.existsSync()) {
      final Object parsed = loadYaml(pubspec.readAsStringSync());
      if (parsed is YamlMap) {
        final FlutterProject project = FlutterProject(
          root: current,
          pubspec: pubspec,
          data: parsed,
        );
        if (project.isFlutterProject) return project;
        if (projectPath != null) {
          throw FlutterProjectNotFound(
            'The project pubspec does not depend on the Flutter SDK: ${pubspec.path}',
          );
        }
      }
    }
    final Directory parent = current.parent;
    if (parent.path == current.path) break;
    current = parent;
  }
  throw FlutterProjectNotFound(
    'No Flutter pubspec.yaml found from ${start?.path ?? projectPath ?? Directory.current.path}.',
  );
}

String _join(String first, String second) =>
    '$first${Platform.pathSeparator}$second';
