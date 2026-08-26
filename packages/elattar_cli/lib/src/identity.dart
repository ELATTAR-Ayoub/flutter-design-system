library;

const String cliName = 'elattar';
const String cliVersion = '0.0.1';
const int supportedConfigSchemaVersion = 1;
const int supportedRegistrySchemaVersion = 1;
const String configSchemaUri = 'https://elattar.dev/schema/config.json';

/// The origin the documentation site and the registry are served from.
///
/// **One spelling, injected, never repeated.** Everything else that needs the
/// host — [defaultRegistryUrl] below, the site build's `--dart-define`, the
/// deploy — derives from this rather than restating it, so moving the site
/// is one value in one place instead of a grep across four file types.
///
/// Three layers, because a published CLI and a local build need different
/// things:
///
///   1. **This default** is what a stranger gets. `dart pub global activate`
///      compiles from source on their machine with no defines, so whatever
///      is written here is what ships. It must therefore be a real, live
///      origin and not a placeholder.
///   2. **`--define=ELATTAR_SITE_ORIGIN=...` at compile time**, for building
///      against a staging host or a fork without editing the source.
///   3. **`ELATTAR_REGISTRY_URL` at run time** (see
///      `registry/location.dart`), for pointing one invocation somewhere
///      else — which is what CI and the consumer rehearsal use.
///
/// A `.env` file cannot serve layer 1: it would have to exist on the user's
/// machine, and it does not. `.env.example` at the repository root documents
/// the variable for layers 2 and 3, and the site build reads it.
const String siteOrigin = String.fromEnvironment(
  'ELATTAR_SITE_ORIGIN',
  defaultValue: 'https://flutter.elattar.dev',
);

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
/// Same origin as the documentation site ([siteOrigin]), so there is one host
/// to make public and one host to keep reachable. The trailing slash is not
/// decoration: `Uri.resolve('index.json')` against a path without it drops
/// the last segment, so [defaultRegistryUri] would silently point one
/// directory up.
const String defaultRegistryUrl = '$siteOrigin/registry/$cliVersion/';

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
