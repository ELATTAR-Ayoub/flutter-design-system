/// The catalog and the registry manifests state the same facts twice.
///
/// `example/lib/shots_docs/catalog.dart` tells the website what a Shot depends
/// on and which files it installs. `registry/shots/<name>.json` tells the CLI
/// the same two things. Nothing made them agree — the Phase G scope names this
/// as a carried risk — so a dependency added to a Shot and declared in only one
/// of the two places would ship a documentation page that describes an install
/// the CLI does not perform.
///
/// This is the cross-check. It is modelled on the route- and search-completeness
/// assertions in `site_routes_test.dart`: read both registries, compare, and
/// name the file that is wrong.
///
/// The last group checks a third statement of the same facts — the asset
/// declarations in `example/pubspec.yaml` that let `/shots/<slug>` render the
/// real source. There the check is stronger than parity: the bytes the page
/// shows must be the bytes on disk, so there is no copy of a Shot's source to
/// go stale.
library;

import 'dart:convert';
import 'dart:io';

import 'package:example/main.dart';
import 'package:example/shots_docs/catalog.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

/// The repository root, from the example package the suite runs in.
Directory get _root => Directory('..');

String _rooted(String relative) => '${_root.path}/$relative';

Directory get _manifestDirectory => Directory(_rooted('registry/shots'));

File _manifestFile(String name) =>
    File('${_manifestDirectory.path}/$name.json');

Map<String, Object?> _manifest(String name) =>
    jsonDecode(_manifestFile(name).readAsStringSync()) as Map<String, Object?>;

List<String> _strings(Map<String, Object?> json, String key) => <String>[
  for (final Object? value in json[key]! as List<Object?>) value! as String,
];

List<String> _fileField(Map<String, Object?> json, String field) => <String>[
  for (final Object? entry in json['files']! as List<Object?>)
    (entry! as Map<String, Object?>)[field]! as String,
];

void main() {
  group('catalog and registry manifests', () {
    test('every catalog entry has a manifest, and nothing else does', () {
      final Set<String> catalogued = <String>{
        for (final ShotDocEntry entry in shotDocs) entry.name,
      };
      final Set<String> manifested = <String>{
        for (final File file
            in _manifestDirectory.listSync().whereType<File>().where(
              (File file) => file.path.endsWith('.json'),
            ))
          (jsonDecode(file.readAsStringSync()) as Map<String, Object?>)['name']!
              as String,
      };

      expect(catalogued, isNotEmpty, reason: 'The Shots catalog is empty.');
      expect(
        manifested,
        catalogued,
        reason:
            'A Shot documented but not manifested cannot be installed; a Shot '
            'manifested but not documented ships to nobody.',
      );
    });

    for (final ShotDocEntry entry in shotDocs) {
      group(entry.name, () {
        test('declares the same registry dependencies, in the same order', () {
          expect(
            _strings(_manifest(entry.name), 'registryDependencies'),
            entry.dependencies,
            reason:
                'registry/shots/${entry.name}.json and the catalog disagree '
                'about what ${entry.name} installs. The dependency list is what '
                'the detail page prints and what the CLI resolves; they cannot '
                'be allowed to differ.',
          );
        });

        test('declares the same files, sources and install targets', () {
          final Map<String, Object?> manifest = _manifest(entry.name);

          expect(
            _fileField(manifest, 'source'),
            entry.sourcePaths,
            reason:
                'The manifest hashes different files than the catalog lists '
                'for ${entry.name}.',
          );
          expect(
            _fileField(manifest, 'target'),
            entry.logicalTargets,
            reason:
                'The manifest installs ${entry.name} somewhere other than the '
                '@app/ location the catalog documents.',
          );

          for (final String source in entry.sourcePaths) {
            expect(
              File(_rooted(source)).existsSync(),
              isTrue,
              reason: '$source is declared but does not exist.',
            );
          }
        });

        test('agrees on the name, the kind, the blurb and the route', () {
          final Map<String, Object?> manifest = _manifest(entry.name);

          expect(manifest['name'], entry.name);
          expect(manifest['type'], 'shot');
          expect(manifest['description'], entry.description);
          expect(
            manifest['documentationRoute'],
            entry.route,
            reason:
                'The manifest points readers at a route the site does not '
                'serve for ${entry.name}.',
          );
        });
      });
    }
  });

  group('shot sources reach the page through the asset bundle', () {
    // `rootBundle` is a `CachingAssetBundle`: it caches the *Future*, not the
    // string. A test that awaits a key an earlier test already loaded gets a
    // future created in a scope that has since ended, and hangs until the ten
    // minute timeout. Evicting between tests keeps each load in its own scope.
    setUp(rootBundle.clear);

    for (final ShotDocEntry entry in shotDocs) {
      testWidgets('${entry.name} loads byte-for-byte from disk', (
        WidgetTester tester,
      ) async {
        // `shotSourceFor` is the production path — the same call `main.dart`
        // makes to fill `ShotDetailPage.fileSource`. A Shot whose directory is
        // missing from `example/pubspec.yaml`'s asset list loads nothing and
        // fails here, which is the only warning before a release build renders
        // "source is not loaded in this build" to readers.
        final Map<String, String> loaded = await shotSourceFor(entry);

        expect(
          loaded.keys,
          unorderedEquals(entry.files),
          reason:
              '${entry.name} did not load every file it declares. Add '
              '"- lib/shots/${entry.directory}/" to the assets in '
              'example/pubspec.yaml.',
        );

        for (int index = 0; index < entry.files.length; index++) {
          expect(
            loaded[entry.files[index]],
            File(_rooted(entry.sourcePaths[index])).readAsStringSync(),
            reason:
                '${entry.files[index]} in the bundle differs from the file on '
                'disk. The page must show the source the registry hashes.',
          );
        }
      });
    }
  });
}
