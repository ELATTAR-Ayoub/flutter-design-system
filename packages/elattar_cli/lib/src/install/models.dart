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

/// A font file together with the family it must be registered under.
///
/// [family] is required rather than optional: the family a face renders as is
/// a property of the registry entry, never of its file name, and a font whose
/// family cannot be stated is a font the consumer cannot reach.
class InstallFont extends InstallResource {
  const InstallFont({
    required super.source,
    required super.target,
    super.sha256,
    required this.family,
    this.style,
  });

  final String family;

  /// `normal` or `italic`; null when the face declares no style.
  final String? style;
}

/// One `flutter: fonts:` entry as it will be written into the consumer's
/// `pubspec.yaml`: a family name and a project-relative asset path.
class FontRegistration {
  const FontRegistration({
    required this.family,
    required this.asset,
    this.style,
  });

  final String family;
  final String asset;
  final String? style;
}

class InstallItem {
  const InstallItem({
    required this.name,
    required this.version,
    required this.files,
    this.assets = const <InstallResource>[],
    this.fonts = const <InstallFont>[],
    this.shaders = const <InstallResource>[],
    this.licenses = const <InstallResource>[],
    this.dependencies = const <String>[],
    this.pubDependencies = const <String, String>{},
  });

  final String name;
  final String version;
  final List<InstallFile> files;
  final List<InstallResource> assets;
  final List<InstallFont> fonts;
  final List<InstallResource> shaders;

  /// Third-party notices copied verbatim into the consumer's `LICENSES/`.
  ///
  /// Byte copies, never rewritten: a license text that had its imports
  /// "transformed" would no longer be the text the upstream project
  /// published, which is the one property that makes it a valid notice.
  final List<InstallResource> licenses;
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
