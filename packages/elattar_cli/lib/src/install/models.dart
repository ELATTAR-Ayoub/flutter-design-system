import 'dart:collection';

class InstallFile {
  const InstallFile({
    required this.source,
    required this.target,
    this.sha256 = '',
  });

  final String source;
  final String target;
  final String sha256;
}

class InstallResource {
  const InstallResource({
    required this.source,
    required this.target,
    this.sha256 = '',
  });

  final String source;
  final String target;
  final String sha256;
}

class InstallItem {
  const InstallItem({
    required this.name,
    required this.version,
    required this.files,
    this.assets = const <InstallResource>[],
    this.fonts = const <InstallResource>[],
    this.shaders = const <InstallResource>[],
    this.dependencies = const <String>[],
    this.pubDependencies = const <String, String>{},
  });

  final String name;
  final String version;
  final List<InstallFile> files;
  final List<InstallResource> assets;
  final List<InstallResource> fonts;
  final List<InstallResource> shaders;
  final List<String> dependencies;
  final Map<String, String> pubDependencies;
}

class InstallOperation {
  const InstallOperation({
    required this.source,
    required this.destination,
    required this.content,
  });

  final String source;
  final String destination;
  final Object content;
}

class InstallConflict {
  const InstallConflict({required this.destination, required this.reason});

  final String destination;
  final String reason;
}

class InstallPlan {
  InstallPlan({
    required List<InstallOperation> operations,
    required List<InstallConflict> conflicts,
    required this.pubspec,
    required this.uiBarrel,
    required this.foundationBarrel,
  }) : operations = UnmodifiableListView<InstallOperation>(operations),
       conflicts = UnmodifiableListView<InstallConflict>(conflicts);

  final List<InstallOperation> operations;
  final List<InstallConflict> conflicts;
  final String pubspec;
  final String uiBarrel;
  final String foundationBarrel;

  bool get canApply => conflicts.isEmpty;
  bool get isEmpty => operations.isEmpty && pubspec.isEmpty;
}
