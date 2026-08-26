/// The site's own configuration, resolved the same way in every context that
/// builds it: a local machine, CI, and Vercel.
///
/// **One spelling, injected, never repeated** — see
/// `packages/elattar_cli/lib/src/identity.dart`'s doc comment on `siteOrigin`,
/// which this mirrors. `ELATTAR_SITE_ORIGIN` and `ELATTAR_SITE_BASE_HREF`
/// come from (in order of precedence) the real process environment, a `.env`
/// file at the repository root, and finally the same defaults `.env.example`
/// documents. Nothing in this file may hardcode either value: a wrong value
/// here is a white screen, not a build error, so both are validated before
/// anything expensive happens.
library;

/// Raised for a missing-where-required or malformed configuration value.
/// Caught at the CLI boundary and reported without a stack trace, because the
/// message is meant to be read by a human fixing `.env`, not debugged.
class BuildConfigException implements Exception {
  BuildConfigException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Parses a `.env` file: `KEY=VALUE` lines, blank lines and `#` comments
/// ignored, surrounding single or double quotes on the value stripped. Not a
/// general-purpose dotenv implementation — just enough for the four
/// variables `.env.example` documents.
Map<String, String> parseDotEnv(String contents) {
  final Map<String, String> result = <String, String>{};
  for (final String rawLine in contents.split('\n')) {
    final String line = rawLine.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final int equals = line.indexOf('=');
    if (equals <= 0) continue;
    final String key = line.substring(0, equals).trim();
    String value = line.substring(equals + 1).trim();
    if (value.length >= 2 &&
        ((value.startsWith('"') && value.endsWith('"')) ||
            (value.startsWith("'") && value.endsWith("'")))) {
      value = value.substring(1, value.length - 1);
    }
    result[key] = value;
  }
  return result;
}

/// Resolves one variable: real environment wins over `.env`, `.env` wins over
/// [fallback]. Real environment wins first so CI (which sets no `.env` file
/// and may export the variable directly) and a developer overriding a `.env`
/// value for one shell both behave the way they'd expect.
String resolveVar({
  required String key,
  required Map<String, String> processEnv,
  required Map<String, String> dotEnv,
  required String fallback,
}) {
  final String? fromProcess = processEnv[key];
  if (fromProcess != null && fromProcess.isNotEmpty) return fromProcess;
  final String? fromFile = dotEnv[key];
  if (fromFile != null && fromFile.isNotEmpty) return fromFile;
  return fallback;
}

/// The same default [siteOrigin] falls back to in
/// `packages/elattar_cli/lib/src/identity.dart`, restated here because a Dart
/// script cannot import Flutter package code without pulling in the Flutter
/// SDK. Both spellings are exercised by
/// `test/version_identity_test.dart`-style guards would be the next step if
/// this default and that one are ever allowed to diverge; today they are
/// compared directly in `build_site_test.dart`.
const String defaultSiteOrigin = 'https://flutter.elattar.dev';

/// The default `.env.example` documents: a domain of its own, not a GitHub
/// Pages project subpath.
const String defaultBaseHref = '/';

/// Validates a resolved origin. Required: an absolute URI, `http` or `https`
/// scheme, non-empty host, no trailing slash (the build passes it straight
/// into `--dart-define`, and `defaultRegistryUrl` in `identity.dart` builds
/// `'$siteOrigin/registry/...'` — a trailing slash would double up to `//`).
void validateOrigin(String origin) {
  if (origin.isEmpty) {
    throw BuildConfigException('ELATTAR_SITE_ORIGIN is empty.');
  }
  final Uri? uri = Uri.tryParse(origin);
  if (uri == null ||
      !uri.isAbsolute ||
      (uri.scheme != 'http' && uri.scheme != 'https') ||
      uri.host.isEmpty) {
    throw BuildConfigException(
      'ELATTAR_SITE_ORIGIN "$origin" is not a valid absolute http(s) URL '
      '(expected something like https://flutter.elattar.dev).',
    );
  }
  if (origin.endsWith('/')) {
    throw BuildConfigException(
      'ELATTAR_SITE_ORIGIN "$origin" must not end with "/" '
      '(defaultRegistryUrl in identity.dart builds "\$siteOrigin/registry/..." '
      'and a trailing slash would double it up).',
    );
  }
}

/// Validates a resolved base href. Required: starts and ends with `/`,
/// because that is what `flutter build web --base-href` requires — anything
/// else is accepted by the build and produces a page whose every asset 404s.
void validateBaseHref(String baseHref) {
  if (baseHref.isEmpty ||
      !baseHref.startsWith('/') ||
      !baseHref.endsWith('/')) {
    throw BuildConfigException(
      'ELATTAR_SITE_BASE_HREF "$baseHref" must start and end with "/" '
      '(for example "/" or "/flutter-design-system/"). '
      'flutter build web accepts anything here and a wrong value is a '
      'white screen, not a build error.',
    );
  }
}

/// Resolved, validated configuration for one build.
class SiteBuildConfig {
  const SiteBuildConfig({
    required this.origin,
    required this.baseHref,
    required this.registryVersion,
  });

  /// Reads `ELATTAR_SITE_ORIGIN` / `ELATTAR_SITE_BASE_HREF` from
  /// [processEnv] and [dotEnv] (see [resolveVar] for precedence), applies the
  /// same defaults `.env.example` documents, and validates both. Throws
  /// [BuildConfigException] on anything malformed — deliberately, before any
  /// process is spawned.
  factory SiteBuildConfig.resolve({
    required Map<String, String> processEnv,
    required Map<String, String> dotEnv,
    required String registryVersion,
  }) {
    final String origin = resolveVar(
      key: 'ELATTAR_SITE_ORIGIN',
      processEnv: processEnv,
      dotEnv: dotEnv,
      fallback: defaultSiteOrigin,
    );
    final String baseHref = resolveVar(
      key: 'ELATTAR_SITE_BASE_HREF',
      processEnv: processEnv,
      dotEnv: dotEnv,
      fallback: defaultBaseHref,
    );
    validateOrigin(origin);
    validateBaseHref(baseHref);
    return SiteBuildConfig(
      origin: origin,
      baseHref: baseHref,
      registryVersion: registryVersion,
    );
  }

  final String origin;
  final String baseHref;
  final String registryVersion;
}

/// Pulls `cliVersion` out of `packages/elattar_cli/lib/src/identity.dart`
/// verbatim rather than restating a version number here, so the registry
/// staged into the site is always the one the released CLI actually pins —
/// the whole point of `defaultRegistryUrl` being versioned in the first
/// place. Throws [BuildConfigException] if the file has moved or the
/// constant no longer matches the expected shape, rather than silently
/// staging under a guessed version.
String extractCliVersion(String identityDartSource) {
  final RegExp pattern = RegExp(
    r"""const String cliVersion = '([^']+)';""",
  );
  final RegExpMatch? match = pattern.firstMatch(identityDartSource);
  if (match == null) {
    throw BuildConfigException(
      'Could not find `const String cliVersion = \'...\';` in '
      'packages/elattar_cli/lib/src/identity.dart. That file is the single '
      'source of truth for the registry version this build stages; refusing '
      'to guess.',
    );
  }
  return match.group(1)!;
}
