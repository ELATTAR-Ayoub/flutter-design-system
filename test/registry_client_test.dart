import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../packages/elattar_cli/lib/src/registry/registry.dart';

void main() {
  test(
    'local generated registry supports list, search, info, and resolve',
    () async {
      final Directory root = await _createRegistryFixture();
      addTearDown(() => root.deleteSync(recursive: true));

      final RegistryClient client = RegistryClient.localGenerated(root);

      final List<RegistryItem> components = await client.list(
        type: RegistryItemType.component,
      );
      expect(
        components.map((RegistryItem item) => item.name).toList(),
        <String>['button', 'card', 'icon'],
      );

      final List<RegistrySearchResult> search = await client.search('but');
      expect(search.first.item.name, 'button');

      final RegistryItem button = await client.info('button');
      expect(button.registryDependencies, <String>[
        'source-foundation',
        'icon',
      ]);

      final List<RegistryItem> resolved = await client.resolve(<String>[
        'button',
      ]);
      expect(resolved.map((RegistryItem item) => item.name).toList(), <String>[
        'source-foundation',
        'icon',
        'button',
      ]);
    },
  );

  test('integrity verification checks payload hashes', () async {
    final Directory root = await _createRegistryFixture();
    addTearDown(() => root.deleteSync(recursive: true));
    final File payload = File(
      '${root.path}/versions/button/0.0.1/logical/ui/button.dart',
    );
    await payload.writeAsString('tampered');

    final RegistryClient client = RegistryClient.localGenerated(root);

    await expectLater(
      client.info('button', verifyIntegrity: true),
      throwsA(isA<RegistryIntegrityException>()),
    );
  });

  test('dependency resolution reports missing items and cycles', () async {
    final Directory root = await _createRegistryFixture(
      overrideCatalogItems: <Map<String, Object?>>[
        _foundationItem(),
        _iconItem(),
        _buttonItem(
          registryDependencies: <String>['source-foundation', 'ghost'],
        ),
      ],
    );
    addTearDown(() => root.deleteSync(recursive: true));
    final RegistryClient missingClient = RegistryClient.localGenerated(root);

    await expectLater(
      missingClient.resolve(<String>['button']),
      throwsA(
        isA<RegistryItemNotFoundException>().having(
          (RegistryItemNotFoundException error) => error.name,
          'name',
          'ghost',
        ),
      ),
    );

    final Directory cycleRoot = await _createRegistryFixture(
      overrideCatalogItems: <Map<String, Object?>>[
        _foundationItem(registryDependencies: <String>['button']),
        _iconItem(),
        _buttonItem(registryDependencies: <String>['source-foundation']),
      ],
    );
    addTearDown(() => cycleRoot.deleteSync(recursive: true));
    final RegistryClient cycleClient = RegistryClient.localGenerated(cycleRoot);

    await expectLater(
      cycleClient.resolve(<String>['button']),
      throwsA(
        isA<RegistryDependencyCycleException>().having(
          (RegistryDependencyCycleException error) => error.cycle,
          'cycle',
          <String>['button', 'source-foundation', 'button'],
        ),
      ),
    );
  });

  test(
    'remote registry source uses fetcher and cached offline reads',
    () async {
      final Directory root = await _createRegistryFixture();
      addTearDown(() => root.deleteSync(recursive: true));

      final InMemoryRegistryCache cache = InMemoryRegistryCache();
      final RegistryFetcher warmFetcher = (Uri uri) async {
        final String relativePath = uri.pathSegments
            .skipWhile((String segment) {
              return segment != 'latest';
            })
            .skip(1)
            .join('/');
        final File file = File('${root.path}/$relativePath');
        return RegistryFetchResponse(
          statusCode: await file.exists() ? 200 : 404,
          bodyBytes: await file.readAsBytes(),
        );
      };

      final RegistryClient warmClient = RegistryClient.remote(
        baseUri: Uri.parse('https://example.com/registry/generated/latest/'),
        fetcher: warmFetcher,
        cache: cache,
      );

      // Warm the complete dependency closure, not just the catalog and button
      // manifest. Offline resolution must be able to read source-foundation and
      // icon manifests from the same cache as well.
      expect(
        (await warmClient.resolve(<String>['button'])).last.name,
        'button',
      );

      final RegistryClient offlineClient = RegistryClient.remote(
        baseUri: Uri.parse('https://example.com/registry/generated/latest/'),
        fetcher: (_) async => throw StateError('network should not be used'),
        cache: cache,
        offline: true,
      );

      final List<RegistryItem> items = await offlineClient.resolve(<String>[
        'button',
      ]);
      expect(items.last.name, 'button');
    },
  );
}

Future<Directory> _createRegistryFixture({
  List<Map<String, Object?>>? overrideCatalogItems,
}) async {
  final Directory root = await Directory.systemTemp.createTemp(
    'registry-fixture-',
  );
  await Directory('${root.path}/versions').create(recursive: true);

  final List<Map<String, Object?>> items =
      overrideCatalogItems ??
      <Map<String, Object?>>[
        _foundationItem(),
        _iconItem(),
        _cardItem(),
        _buttonItem(),
      ];

  final List<Map<String, Object?>> indexItems = <Map<String, Object?>>[
    for (final Map<String, Object?> item in items)
      <String, Object?>{
        'name': item['name'],
        'type': item['type'],
        'version': item['version'],
        'documentationRoute': item['documentationRoute'],
      },
  ];

  await File('${root.path}/index.json').writeAsString(
    const JsonEncoder.withIndent('  ').convert(<String, Object?>{
      'schemaVersion': 1,
      'registryVersion': '0.0.1',
      'items': indexItems,
    }),
  );

  await File('${root.path}/registry.json').writeAsString(
    const JsonEncoder.withIndent('  ').convert(<String, Object?>{
      'schemaVersion': 1,
      'registryVersion': '0.0.1',
      'items': items,
    }),
  );

  for (final Map<String, Object?> item in items) {
    final String name = item['name']! as String;
    final String version = item['version']! as String;
    final Directory versionDirectory = Directory(
      '${root.path}/versions/$name/$version',
    );
    await versionDirectory.create(recursive: true);
    await File(
      '${versionDirectory.path}/manifest.json',
    ).writeAsString(const JsonEncoder.withIndent('  ').convert(item));
    for (final Map<String, Object?> file
        in (item['files']! as List<Object?>).cast<Map<String, Object?>>()) {
      final String target = file['target']! as String;
      final String payloadPath = _payloadPath(target);
      final File payload = File('${versionDirectory.path}/$payloadPath');
      await payload.create(recursive: true);
      await payload.writeAsString('// $name -> $target\n');
      final String hash = sha256Hex(await payload.readAsBytes());
      file['sha256'] = hash;
    }
    for (final String bucket in <String>['assets', 'fonts', 'shaders']) {
      for (final Map<String, Object?> resource
          in (item[bucket]! as List<Object?>).cast<Map<String, Object?>>()) {
        final String target = resource['target']! as String;
        final String payloadPath = _payloadPath(target);
        final File payload = File('${versionDirectory.path}/$payloadPath');
        await payload.create(recursive: true);
        await payload.writeAsString('// $name -> $target\n');
        resource['sha256'] = sha256Hex(await payload.readAsBytes());
      }
    }
    await File(
      '${versionDirectory.path}/manifest.json',
    ).writeAsString(const JsonEncoder.withIndent('  ').convert(item));
  }

  // The aggregate catalog is written after payload hashes are assigned so its
  // item metadata passes the same integrity schema as per-item manifests.
  await File('${root.path}/registry.json').writeAsString(
    const JsonEncoder.withIndent('  ').convert(<String, Object?>{
      'schemaVersion': 1,
      'registryVersion': '0.0.1',
      'items': items,
    }),
  );

  return root;
}

Map<String, Object?> _foundationItem({List<String>? registryDependencies}) {
  return <String, Object?>{
    'name': 'source-foundation',
    'type': 'foundation',
    'version': '0.0.1',
    'description': 'Foundation files.',
    'minDart': '>=3.12.2 <4.0.0',
    'minFlutter': '>=3.44.8',
    'files': <Map<String, Object?>>[
      <String, Object?>{
        'source': 'lib/src/foundation/colors.dart',
        'target': '@foundation/colors.dart',
        'sha256': '',
      },
    ],
    'registryDependencies': registryDependencies ?? <String>[],
    'semanticDependencies': <String>[],
    'pubDependencies': <String, String>{},
    'assets': <Map<String, Object?>>[],
    'fonts': <Map<String, Object?>>[],
    'shaders': <Map<String, Object?>>[],
    'documentationRoute': '/docs/foundations',
    'sourceLink': 'https://example.com/foundation.dart',
    'deprecated': false,
  };
}

Map<String, Object?> _iconItem() {
  return <String, Object?>{
    'name': 'icon',
    'type': 'component',
    'version': '0.0.1',
    'description': 'Icon component.',
    'minDart': '>=3.12.2 <4.0.0',
    'minFlutter': '>=3.44.8',
    'files': <Map<String, Object?>>[
      <String, Object?>{
        'source': 'lib/src/components/icon.dart',
        'target': '@ui/icon.dart',
        'sha256': '',
      },
    ],
    'registryDependencies': <String>['source-foundation'],
    'semanticDependencies': <String>[],
    'pubDependencies': <String, String>{},
    'assets': <Map<String, Object?>>[],
    'fonts': <Map<String, Object?>>[],
    'shaders': <Map<String, Object?>>[],
    'documentationRoute': '/components/icon',
    'sourceLink': 'https://example.com/icon.dart',
    'deprecated': false,
  };
}

Map<String, Object?> _cardItem() {
  return <String, Object?>{
    'name': 'card',
    'type': 'component',
    'version': '0.0.1',
    'description': 'Card component.',
    'minDart': '>=3.12.2 <4.0.0',
    'minFlutter': '>=3.44.8',
    'files': <Map<String, Object?>>[
      <String, Object?>{
        'source': 'lib/src/components/card.dart',
        'target': '@ui/card.dart',
        'sha256': '',
      },
    ],
    'registryDependencies': <String>['source-foundation'],
    'semanticDependencies': <String>[],
    'pubDependencies': <String, String>{},
    'assets': <Map<String, Object?>>[],
    'fonts': <Map<String, Object?>>[],
    'shaders': <Map<String, Object?>>[],
    'documentationRoute': '/components/card',
    'sourceLink': 'https://example.com/card.dart',
    'deprecated': false,
  };
}

Map<String, Object?> _buttonItem({List<String>? registryDependencies}) {
  return <String, Object?>{
    'name': 'button',
    'type': 'component',
    'version': '0.0.1',
    'description': 'Button component.',
    'minDart': '>=3.12.2 <4.0.0',
    'minFlutter': '>=3.44.8',
    'files': <Map<String, Object?>>[
      <String, Object?>{
        'source': 'lib/src/components/button.dart',
        'target': '@ui/button.dart',
        'sha256': '',
      },
    ],
    'registryDependencies':
        registryDependencies ?? <String>['source-foundation', 'icon'],
    'semanticDependencies': <String>['icon'],
    'pubDependencies': <String, String>{},
    'assets': <Map<String, Object?>>[],
    'fonts': <Map<String, Object?>>[],
    'shaders': <Map<String, Object?>>[],
    'documentationRoute': '/components/button',
    'sourceLink': 'https://example.com/button.dart',
    'deprecated': false,
  };
}

String _payloadPath(String target) {
  for (final String prefix in <String>[
    '@ui/',
    '@foundation/',
    '@effects/',
    '@motion/',
    '@assets/',
    '@shaders/',
  ]) {
    if (target.startsWith(prefix)) return 'logical/${target.substring(1)}';
  }
  return 'logical/$target';
}
