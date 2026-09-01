/// What this build of the site is allowed to say about the release it ships
/// alongside.
///
/// Four facts drive every install instruction on the site, and each one has an
/// owner outside this file: the version and the registry URL belong to
/// `packages/elattar_cli/lib/src/identity.dart`, the tag belongs to git, and
/// whether the CLI is on pub.dev belongs to pub.dev.
/// `example/test/release_facts_test.dart` holds this file to the first three
/// and makes the fourth decide which command the pages print, so the site
/// cannot describe one release while the artifacts are another.
///
/// **[cliOnPubDev] is a release-ordering switch, not a preference.** It is
/// true for the 0.0.1 release, which publishes the CLI before the site is
/// deployed. Deploying a build with it true while the package is unpublished
/// prints a command that does not resolve, and a reader cannot tell that
/// apart from a broken setup of their own. If the publish is deferred, flip
/// it, rebuild, and the pages and their guard move together.
///
/// Dependency-free on purpose, the same discipline `catalog.dart` keeps: no
/// Flutter import, so the guard can read it without a widget binding.
library;

/// The release the site is describing.
class ReleaseFacts {
  const ReleaseFacts({
    required this.version,
    required this.registryUrl,
    required this.cliOnPubDev,
  });

  /// The CLI and registry version. Checked against `identity.dart`.
  final String version;

  /// The registry a released CLI reads by default. Checked against the URL
  /// `identity.dart` composes, trailing slash included.
  final String registryUrl;

  /// Whether `elattar_cli` resolves on pub.dev for a reader of this build.
  final bool cliOnPubDev;

  /// The git tag the release is cut at, and the ref a package dependency can
  /// pin to. `identity.dart`'s `releaseTagFor` states the same rule in code.
  String get tag => 'v$version';

  /// The install line the pages lead with.
  String get installCommand =>
      cliOnPubDev ? pubDevInstallCommand : gitInstallCommand;
}

/// The published spelling. One resolve, one small dependency tree.
const String pubDevInstallCommand = 'dart install elattar_cli';

/// The from-source spelling: no pub.dev, no clone, compiled from the public
/// repository. Kept documented because it is what a contributor and anyone
/// tracking the default branch uses, and what worked before the publish.
const String gitInstallCommand =
    'dart pub global activate --source git \\\n'
    '  https://github.com/ELATTAR-Ayoub/flutter-design-system.git \\\n'
    '  --git-path packages/elattar_cli';

const ReleaseFacts releaseFacts = ReleaseFacts(
  version: '0.0.2',
  registryUrl: 'https://flutter.elattar.dev/registry/0.0.2/',
  cliOnPubDev: true,
);
