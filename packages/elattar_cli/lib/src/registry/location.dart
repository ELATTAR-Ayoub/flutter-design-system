/// Where a registry lives, and how a string turns into that answer.
///
/// One string — `--registry`, the `registry:` key in `elattar.yaml`, or
/// nothing at all — has to resolve to either a directory on this machine or a
/// URL on the network. Putting that decision in one place is what stops the
/// two shapes leaking into every command, and what makes the resolution order
/// something a person can read rather than reconstruct from six call sites.
library;

import 'dart:io';

import '../identity.dart';

/// A resolved registry: local directory or remote base URL.
sealed class RegistryLocation {
  const RegistryLocation();

  /// A short word for diagnostics: `local` or `remote`.
  String get kind;

  /// What to show a user. Never a machine-specific cache path.
  String get display;

  /// What `elattar.yaml` should record, or null when it must record nothing.
  ///
  /// A remote registry is portable and always recorded. A local one is
  /// recorded only when it sits inside the project, because an absolute path
  /// committed to a repository is a value that works on exactly one machine —
  /// the bug that made `elattar.yaml` unusable in version control before.
  String? configValueFor(String projectRoot);
}

/// A `registry/generated/latest` directory on this machine.
class LocalRegistryLocation extends RegistryLocation {
  const LocalRegistryLocation(this.directory, {this.discovered = false});

  final Directory directory;

  /// True when nobody asked for this directory and it was found by walking up
  /// from the working directory. Worth saying out loud, because it means the
  /// CLI chose a source the user did not name.
  final bool discovered;

  @override
  String get kind => 'local';

  @override
  String get display => directory.path;

  @override
  String? configValueFor(String projectRoot) {
    final String root = _posix(projectRoot);
    final String value = _posix(directory.absolute.path);
    if (value == root) return '.';
    if (!value.startsWith('$root/')) return null;
    return value.substring(root.length + 1);
  }
}

/// A registry served over HTTP.
class RemoteRegistryLocation extends RegistryLocation {
  const RemoteRegistryLocation(this.baseUri);

  final Uri baseUri;

  @override
  String get kind => 'remote';

  @override
  String get display => baseUri.toString();

  @override
  String? configValueFor(String projectRoot) => baseUri.toString();
}

/// Raised for a registry value this CLI cannot use. Callers map it to exit 64.
class RegistryLocationException implements Exception {
  const RegistryLocationException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Anything with a scheme of two or more characters, so a Windows drive
/// letter (`C:\src\registry`) reads as a path rather than a `c:` scheme.
final RegExp _schemePattern = RegExp(r'^[A-Za-z][A-Za-z0-9+.\-]+:');

/// Resolves the registry to use.
///
/// In order:
///
///   1. [explicit] — what `--registry` was given.
///   2. `ELATTAR_REGISTRY_URL` in the environment. Between the flag and the
///      config file on the usual grounds: a flag is this invocation, an
///      environment variable is this shell or this CI job, and
///      `elattar.yaml` is this project and outlives both. It is what lets a
///      release rehearsal, a staging host or a fork be pointed somewhere
///      else without editing a checked-in file — and, unlike a `.env`, it
///      reaches a CLI that was compiled and published months earlier.
///   3. [configured] — the `registry:` key in `elattar.yaml`.
///   4. A `registry/generated/latest` directory at or above [workingDirectory].
///      This is the contributor convenience: inside a checkout of the design
///      system it is almost always what you meant, and outside one it finds
///      nothing, so it cannot hijack a released CLI in a consumer project.
///      When it wins, the caller is expected to say so — see
///      [LocalRegistryLocation.discovered].
///   5. [defaultRegistryUri], the versioned public registry this CLI pins.
///
/// A value with an `http` or `https` scheme is remote; a value with any other
/// scheme is refused by name rather than being handed to `Directory(...)`,
/// which is how a mistyped `ftp://` used to surface as a raw
/// `FileSystemException`.
/// The environment variable that overrides the registry for one shell or one
/// CI job. See [resolveRegistryLocation].
const String registryUrlEnvVar = 'ELATTAR_REGISTRY_URL';

RegistryLocation resolveRegistryLocation({
  String? explicit,
  String? configured,
  Directory? workingDirectory,
  Map<String, String>? environment,
}) {
  // Injectable rather than read straight off `Platform.environment`, so a
  // test can exercise the precedence without mutating the process it runs
  // in — the same seam `file_cache.dart` already uses for
  // `ELATTAR_CACHE_DIR`.
  final Map<String, String> env = environment ?? Platform.environment;
  final String? named = _firstNonEmpty(<String?>[
    explicit,
    env[registryUrlEnvVar],
    configured,
  ]);
  if (named != null) return _parse(named, workingDirectory);

  final Directory? discovered = discoverGeneratedRegistry(
    workingDirectory ?? Directory.current,
  );
  if (discovered != null) {
    return LocalRegistryLocation(discovered, discovered: true);
  }
  return RemoteRegistryLocation(defaultRegistryUri);
}

RegistryLocation _parse(String raw, Directory? workingDirectory) {
  final String value = raw.trim();
  if (_schemePattern.hasMatch(value)) {
    final Uri? uri = Uri.tryParse(value);
    if (uri == null) {
      throw RegistryLocationException('Registry is not a valid URL: $value');
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      throw RegistryLocationException(
        'Unsupported registry scheme "${uri.scheme}" in $value\n'
        'A registry is either a local directory or an http/https URL.',
      );
    }
    return RemoteRegistryLocation(_withTrailingSlash(uri));
  }

  final Directory base = workingDirectory ?? Directory.current;
  final Directory directory = _resolveAgainst(base, value);
  if (!directory.existsSync()) {
    throw RegistryLocationException(
      'Registry path does not exist: ${directory.path}',
    );
  }
  return LocalRegistryLocation(directory);
}

/// Walks up from [start] looking for `registry/generated/latest`.
Directory? discoverGeneratedRegistry(Directory start) {
  Directory current = start.absolute;
  while (true) {
    final Directory candidate = Directory(
      <String>[
        current.path.replaceAll(RegExp(r'[\\/]+$'), ''),
        'registry',
        'generated',
        'latest',
      ].join(Platform.pathSeparator),
    );
    if (candidate.existsSync()) return candidate;
    final Directory parent = current.parent;
    if (parent.path == current.path) return null;
    current = parent;
  }
}

/// Every relative path this CLI reads resolves against `baseUri`, and
/// `Uri.resolve` drops the last segment of a path that does not end in a
/// slash. Without this, `.../registry/0.0.1` would fetch
/// `.../registry/index.json` — a 404 that looks like a missing registry
/// rather than a missing slash.
Uri _withTrailingSlash(Uri uri) {
  if (uri.path.endsWith('/')) return uri;
  return uri.replace(path: '${uri.path}/');
}

Directory _resolveAgainst(Directory base, String value) {
  final Directory candidate = Directory(value);
  if (candidate.isAbsolute) return candidate.absolute;
  return Directory(
    '${base.absolute.path.replaceAll(RegExp(r'[\\/]+$'), '')}'
    '${Platform.pathSeparator}$value',
  ).absolute;
}

String? _firstNonEmpty(List<String?> values) {
  for (final String? value in values) {
    if (value != null && value.trim().isNotEmpty) return value.trim();
  }
  return null;
}

String _posix(String value) =>
    value.replaceAll('\\', '/').replaceAll(RegExp(r'/+$'), '');
