library;

const String cliName = 'elattar';
const String cliVersion = '0.0.1';
const int supportedConfigSchemaVersion = 1;
const int supportedRegistrySchemaVersion = 1;
const String configSchemaUri = 'https://elattar.dev/schema/config.json';

/// The registry this CLI version reads when nothing overrides it.
///
/// **Versioned, and pinned to [cliVersion] on purpose.** A released CLI that
/// silently followed a mutable `/registry/latest/` would change behaviour
/// under a user who upgraded nothing: a schema or payload change published
/// months later would reach every installed copy at once. This path is
/// immutable — the release process refuses to overwrite a published version
/// with different bytes — so `elattar_cli 0.0.1` installs the same sources in
/// a year that it installs today.
///
/// Same origin as the documentation site, so there is one host to make public
/// and one host to keep reachable. The trailing slash is not decoration:
/// `Uri.resolve('index.json')` against a path without it drops the last
/// segment, so [defaultRegistryUri] would silently point one directory up.
const String defaultRegistryUrl =
    'https://elattar-ayoub.github.io/flutter-design-system/registry/'
    '$cliVersion/';

/// [defaultRegistryUrl] parsed, for callers that want the `Uri`.
final Uri defaultRegistryUri = Uri.parse(defaultRegistryUrl);

/// The git tag a given CLI version is released under.
///
/// Stated in code rather than only in a runbook so
/// `test/version_identity_test.dart` can check it: the tag, the pubspec
/// version, the string `--version` prints, and the versioned registry path
/// are four spellings of one number, and the release breaks quietly if any
/// of them drifts.
String releaseTagFor(String version) => 'v$version';

enum FoundationMode { source, package }

class CliIdentity {
  const CliIdentity._();

  static const String name = cliName;
  static const String version = cliVersion;
  static const int configSchemaVersion = supportedConfigSchemaVersion;
  static const int registrySchemaVersion = supportedRegistrySchemaVersion;
}
