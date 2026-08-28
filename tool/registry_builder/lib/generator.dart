/// Deterministic registry payload generation and import transformation plans.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'registry_schema.dart';
import 'registry_validator.dart';

class RegistryGenerationException implements Exception {
  const RegistryGenerationException(this.message);

  final String message;

  @override
  String toString() => message;
}

class GenerationSummary {
  const GenerationSummary({required this.document, required this.outputRoot});

  final RegistryDocument document;
  final Directory outputRoot;
}

class ImportTransformation {
  const ImportTransformation({
    required this.original,
    required this.replacement,
    required this.reason,
  });

  final String original;
  final String replacement;
  final String reason;
}

class ImportTransformationPlan {
  const ImportTransformationPlan(this.transformations);

  final List<ImportTransformation> transformations;
  bool get isEmpty => transformations.isEmpty;
}

/// Builds payloads from the authoritative package source and curated manifests.
class RegistryGenerator {
  RegistryGenerator({
    required this.repositoryRoot,
    this.registryRoot,
    this.outputRoot,
    this.registryVersion = '0.0.1',
  });

  final Directory repositoryRoot;
  final Directory? registryRoot;
  final Directory? outputRoot;
  final String registryVersion;

  Directory get _registry =>
      registryRoot ?? Directory(_join(repositoryRoot.path, 'registry'));
  Directory get _output =>
      outputRoot ?? Directory(_join(_registry.path, 'generated', 'latest'));

  GenerationSummary build() {
    final List<File> manifests = _manifestFiles();
    if (manifests.isEmpty) {
      throw const RegistryGenerationException('No registry manifests found.');
    }
    final List<RegistryItem> items = <RegistryItem>[];
    final Map<String, String> sharedTargets = <String, String>{};
    for (final File manifest in manifests) {
      final Object decoded = jsonDecode(manifest.readAsStringSync());
      final Map<String, Object?> json = _asMap(decoded, manifest.path);
      final RegistryDocument
      parsed = RegistryDocument.fromJson(<String, Object?>{
        // Individual manifests omit this aggregate-only field. Accept an
        // explicit value as well so older schema-v1 manifests remain readable.
        'schemaVersion': json['schemaVersion'] ?? 1,
        'registryVersion': json['version'] ?? registryVersion,
        'items': <Object?>[json],
      });
      final RegistryItem item = _deduplicateSharedTargets(
        parsed.items.single,
        sharedTargets,
      );
      _verifyHashes(item);
      items.add(item);
    }
    items.sort((RegistryItem a, RegistryItem b) => a.name.compareTo(b.name));
    final RegistryDocument document = RegistryDocument(
      schemaVersion: 1,
      registryVersion: registryVersion,
      items: List<RegistryItem>.unmodifiable(items),
    );
    final RegistryValidationResult validation = validateRegistry(document);
    if (!validation.isValid) {
      throw RegistryGenerationException(validation.errors.join('\n'));
    }
    _writePayloads(document);
    return GenerationSummary(document: document, outputRoot: _output);
  }

  RegistryItem _deduplicateSharedTargets(
    RegistryItem item,
    Map<String, String> owners,
  ) {
    List<RegistryFile> files = <RegistryFile>[];
    for (final RegistryFile file in item.files) {
      final String? owner = owners[file.target];
      if (owner == null) {
        owners[file.target] = file.sha256;
        files.add(file);
      } else if (owner != file.sha256) {
        throw RegistryGenerationException(
          '${item.name}: target ${file.target} has conflicting SHA-256 values.',
        );
      }
    }
    List<RegistryResource> resources = <RegistryResource>[];
    for (final RegistryResource resource in <RegistryResource>[
      ...item.assets,
      ...item.fonts,
      ...item.shaders,
    ]) {
      final String? owner = owners[resource.target];
      if (owner == null) {
        owners[resource.target] = resource.sha256;
        resources.add(resource);
      } else if (owner != resource.sha256) {
        throw RegistryGenerationException(
          '${item.name}: target ${resource.target} has conflicting SHA-256 values.',
        );
      }
    }
    return RegistryItem(
      name: item.name,
      type: item.type,
      version: item.version,
      description: item.description,
      minDart: item.minDart,
      minFlutter: item.minFlutter,
      files: files,
      registryDependencies: item.registryDependencies,
      semanticDependencies: item.semanticDependencies,
      pubDependencies: item.pubDependencies,
      assets: <RegistryResource>[
        for (final RegistryResource resource in item.assets)
          if (resources.contains(resource)) resource,
      ],
      fonts: <RegistryFont>[
        for (final RegistryFont resource in item.fonts)
          if (resources.contains(resource)) resource,
      ],
      shaders: <RegistryResource>[
        for (final RegistryResource resource in item.shaders)
          if (resources.contains(resource)) resource,
      ],
      // Licenses pass through whole, deliberately skipping the deduplication
      // above. Dropping a duplicate notice would leave whichever item lost
      // the race redistributing third-party material with nothing that
      // permits it. See `RegistryItem.licenses`.
      licenses: item.licenses,
      documentationRoute: item.documentationRoute,
      sourceLink: item.sourceLink,
      deprecated: item.deprecated,
      replacement: item.replacement,
    );
  }

  List<File> _manifestFiles() {
    final List<File> files = <File>[];
    for (final String folder in <String>[
      'foundations',
      'components',
      'blocks',
      'presets',
    ]) {
      final Directory directory = Directory(_join(_registry.path, folder));
      if (!directory.existsSync()) continue;
      files.addAll(
        directory
            .listSync(recursive: true)
            .whereType<File>()
            .where((File file) => file.path.toLowerCase().endsWith('.json')),
      );
    }
    files.sort((File a, File b) => a.path.compareTo(b.path));
    return files;
  }

  void _verifyHashes(RegistryItem item) {
    for (final RegistryFile file in item.files) {
      final File source = File(_join(repositoryRoot.path, file.source));
      if (!source.existsSync()) {
        throw RegistryGenerationException(
          '${item.name}: missing source ${file.source}.',
        );
      }
      final String actual = sha256Hex(source.readAsBytesSync());
      if (actual.toLowerCase() != file.sha256.toLowerCase()) {
        throw RegistryGenerationException(
          '${item.name}: SHA-256 mismatch for ${file.source}.',
        );
      }
    }
    for (final RegistryResource resource in <RegistryResource>[
      ...item.assets,
      ...item.fonts,
      ...item.shaders,
      ...item.licenses,
    ]) {
      final File source = File(_join(repositoryRoot.path, resource.source));
      if (!source.existsSync()) {
        throw RegistryGenerationException(
          '${item.name}: missing resource ${resource.source}.',
        );
      }
      final String actual = sha256Hex(source.readAsBytesSync());
      if (actual.toLowerCase() != resource.sha256.toLowerCase()) {
        throw RegistryGenerationException(
          '${item.name}: SHA-256 mismatch for ${resource.source}.',
        );
      }
    }
  }

  void _writePayloads(RegistryDocument document) {
    if (_output.existsSync()) {
      _output.deleteSync(recursive: true);
    }
    _output.createSync(recursive: true);
    for (final RegistryItem item in document.items) {
      final Directory itemOutput = Directory(
        _join(_output.path, 'versions', item.name, item.version),
      );
      itemOutput.createSync(recursive: true);
      for (final RegistryFile file in item.files) {
        _copyPayload(item, file.source, file.target, itemOutput);
      }
      for (final RegistryResource resource in <RegistryResource>[
        ...item.assets,
        ...item.fonts,
        ...item.shaders,
        ...item.licenses,
      ]) {
        _copyPayload(item, resource.source, resource.target, itemOutput);
      }
      _writeJson(
        File(_join(itemOutput.path, 'manifest.json')),
        _itemJson(item),
      );
    }
    _writeJson(
      File(_join(_output.path, 'registry.json')),
      _documentJson(document),
    );
    _writeJson(File(_join(_output.path, 'index.json')), <String, Object?>{
      'schemaVersion': document.schemaVersion,
      'registryVersion': document.registryVersion,
      'items': <Object?>[
        for (final RegistryItem item in document.items)
          <String, Object?>{
            'name': item.name,
            'type': item.type.name,
            'version': item.version,
            'documentationRoute': item.documentationRoute,
          },
      ],
    });
  }

  void _copyPayload(
    RegistryItem item,
    String sourcePath,
    String target,
    Directory itemOutput,
  ) {
    final File source = File(_join(repositoryRoot.path, sourcePath));
    final File destination = File(_join(itemOutput.path, _payloadPath(target)));
    destination.parent.createSync(recursive: true);
    source.copySync(destination.path);
  }
}

/// Plans conversion of registry logical imports without changing source.
///
/// ADVISORY ONLY — this has no production caller. The generator copies payload
/// bytes verbatim (`_copyPayload`); the real rewrite happens at install time in
/// `packages/elattar_cli/lib/src/install/import_transformer.dart`, which is the
/// only implementation that must be kept correct. Do not extend this: teach the
/// installer's transformer instead.
ImportTransformationPlan planImportTransformations(
  String source, {
  required String fromTarget,
  String foundationMode = 'source',
  String componentsPath = 'lib/components/ui',
  String foundationPath = 'lib/design_system/foundation',
  String blocksPath = 'lib/blocks',
}) {
  final RegExp imports = RegExp(r'''(['"])@(foundation|ui|block)/([^'"]+)\1''');
  final List<ImportTransformation> result = <ImportTransformation>[];
  for (final RegExpMatch match in imports.allMatches(source)) {
    final String original = match.group(0)!;
    final String family = match.group(2)!;
    final String leaf = match.group(3)!;
    final String destination = switch (family) {
      'foundation' => foundationPath,
      'ui' => componentsPath,
      'block' => blocksPath,
      _ => throw StateError('unreachable'),
    };
    final String replacementPath =
        foundationMode == 'package' && family == 'foundation'
        ? 'package:elattar_core/${destination.split('/').skip(1).join('/')}/$leaf'
        : _relativePath(fromTarget, '$destination/$leaf');
    result.add(
      ImportTransformation(
        original: original,
        replacement: "'${replacementPath.replaceAll('\\', '/')}'",
        reason: 'logical @$family import',
      ),
    );
  }
  for (final String family in <String>[
    'InterLocal',
    'GeistMono',
    'Redaction35',
  ]) {
    if (!source.contains("'$family'")) continue;
    final String replacement = foundationMode == 'package'
        ? 'packages/elattar_core/$family'
        : family;
    result.add(
      ImportTransformation(
        original: family,
        replacement: replacement,
        reason: 'font family package prefix',
      ),
    );
  }
  return ImportTransformationPlan(
    List<ImportTransformation>.unmodifiable(result),
  );
}

String sha256Hex(List<int> bytes) {
  final Uint8List data = Uint8List.fromList(bytes);
  final List<int> h = <int>[
    0x6a09e667,
    0xbb67ae85,
    0x3c6ef372,
    0xa54ff53a,
    0x510e527f,
    0x9b05688c,
    0x1f83d9ab,
    0x5be0cd19,
  ];
  final List<int> padded = <int>[...data, 0x80];
  while ((padded.length + 8) % 64 != 0) {
    padded.add(0);
  }
  final int bitLength = data.length * 8;
  for (int i = 7; i >= 0; i--) {
    padded.add((bitLength >> (i * 8)) & 0xff);
  }
  final List<int> k = <int>[
    0x428a2f98,
    0x71374491,
    0xb5c0fbcf,
    0xe9b5dba5,
    0x3956c25b,
    0x59f111f1,
    0x923f82a4,
    0xab1c5ed5,
    0xd807aa98,
    0x12835b01,
    0x243185be,
    0x550c7dc3,
    0x72be5d74,
    0x80deb1fe,
    0x9bdc06a7,
    0xc19bf174,
    0xe49b69c1,
    0xefbe4786,
    0x0fc19dc6,
    0x240ca1cc,
    0x2de92c6f,
    0x4a7484aa,
    0x5cb0a9dc,
    0x76f988da,
    0x983e5152,
    0xa831c66d,
    0xb00327c8,
    0xbf597fc7,
    0xc6e00bf3,
    0xd5a79147,
    0x06ca6351,
    0x14292967,
    0x27b70a85,
    0x2e1b2138,
    0x4d2c6dfc,
    0x53380d13,
    0x650a7354,
    0x766a0abb,
    0x81c2c92e,
    0x92722c85,
    0xa2bfe8a1,
    0xa81a664b,
    0xc24b8b70,
    0xc76c51a3,
    0xd192e819,
    0xd6990624,
    0xf40e3585,
    0x106aa070,
    0x19a4c116,
    0x1e376c08,
    0x2748774c,
    0x34b0bcb5,
    0x391c0cb3,
    0x4ed8aa4a,
    0x5b9cca4f,
    0x682e6ff3,
    0x748f82ee,
    0x78a5636f,
    0x84c87814,
    0x8cc70208,
    0x90befffa,
    0xa4506ceb,
    0xbef9a3f7,
    0xc67178f2,
  ];
  int rotr(int x, int n) => ((x >> n) | (x << (32 - n))) & 0xffffffff;
  for (int offset = 0; offset < padded.length; offset += 64) {
    final List<int> w = List<int>.filled(64, 0);
    for (int i = 0; i < 16; i++) {
      final int p = offset + (i * 4);
      w[i] =
          (padded[p] << 24) |
          (padded[p + 1] << 16) |
          (padded[p + 2] << 8) |
          padded[p + 3];
    }
    for (int i = 16; i < 64; i++) {
      final int s0 =
          rotr(w[i - 15], 7) ^ rotr(w[i - 15], 18) ^ (w[i - 15] >> 3);
      final int s1 = rotr(w[i - 2], 17) ^ rotr(w[i - 2], 19) ^ (w[i - 2] >> 10);
      w[i] = (w[i - 16] + s0 + w[i - 7] + s1) & 0xffffffff;
    }
    int a = h[0],
        b = h[1],
        c = h[2],
        d = h[3],
        e = h[4],
        f = h[5],
        g = h[6],
        x = h[7];
    for (int i = 0; i < 64; i++) {
      final int s1 = rotr(e, 6) ^ rotr(e, 11) ^ rotr(e, 25);
      final int ch = (e & f) ^ ((~e) & g);
      final int temp1 = (x + s1 + ch + k[i] + w[i]) & 0xffffffff;
      final int s0 = rotr(a, 2) ^ rotr(a, 13) ^ rotr(a, 22);
      final int maj = (a & b) ^ (a & c) ^ (b & c);
      final int temp2 = (s0 + maj) & 0xffffffff;
      x = g;
      g = f;
      f = e;
      e = (d + temp1) & 0xffffffff;
      d = c;
      c = b;
      b = a;
      a = (temp1 + temp2) & 0xffffffff;
    }
    h[0] = (h[0] + a) & 0xffffffff;
    h[1] = (h[1] + b) & 0xffffffff;
    h[2] = (h[2] + c) & 0xffffffff;
    h[3] = (h[3] + d) & 0xffffffff;
    h[4] = (h[4] + e) & 0xffffffff;
    h[5] = (h[5] + f) & 0xffffffff;
    h[6] = (h[6] + g) & 0xffffffff;
    h[7] = (h[7] + x) & 0xffffffff;
  }
  return h.map((int value) => value.toRadixString(16).padLeft(8, '0')).join();
}

String _payloadPath(String target) {
  for (final String prefix in logicalTargetPrefixes) {
    if (target.startsWith(prefix)) return 'logical/${target.substring(1)}';
  }
  return 'logical/$target';
}

String _relativePath(String fromTarget, String destination) {
  final List<String> from = fromTarget.split('/')..removeLast();
  final List<String> to = destination.split('/');
  while (from.isNotEmpty && to.isNotEmpty && from.first == to.first) {
    from.removeAt(0);
    to.removeAt(0);
  }
  return <String>[...List<String>.filled(from.length, '..'), ...to].join('/');
}

Map<String, Object?> _documentJson(RegistryDocument document) =>
    <String, Object?>{
      'schemaVersion': document.schemaVersion,
      'registryVersion': document.registryVersion,
      'items': <Object?>[
        for (final RegistryItem item in document.items) _itemJson(item),
      ],
    };

Map<String, Object?> _itemJson(RegistryItem item) => <String, Object?>{
  'name': item.name,
  'type': item.type.name,
  'version': item.version,
  'description': item.description,
  'minDart': item.minDart,
  'minFlutter': item.minFlutter,
  'files': <Object?>[
    for (final RegistryFile file in item.files)
      <String, Object?>{
        'source': file.source,
        'target': file.target,
        'sha256': file.sha256,
      },
  ],
  'registryDependencies': item.registryDependencies,
  'semanticDependencies': item.semanticDependencies,
  'pubDependencies': item.pubDependencies,
  'assets': <Object?>[
    for (final RegistryResource resource in item.assets)
      _resourceJson(resource),
  ],
  'fonts': <Object?>[
    for (final RegistryFont resource in item.fonts) _fontJson(resource),
  ],
  'shaders': <Object?>[
    for (final RegistryResource resource in item.shaders)
      _resourceJson(resource),
  ],
  'licenses': <Object?>[
    for (final RegistryResource resource in item.licenses)
      _resourceJson(resource),
  ],
  'documentationRoute': item.documentationRoute,
  'sourceLink': item.sourceLink,
  'deprecated': item.deprecated,
  if (item.replacement != null) 'replacement': item.replacement,
};

Map<String, Object?> _resourceJson(RegistryResource resource) =>
    <String, Object?>{
      'source': resource.source,
      'target': resource.target,
      'sha256': resource.sha256,
    };

Map<String, Object?> _fontJson(RegistryFont font) => <String, Object?>{
  ..._resourceJson(font),
  'family': font.family,
  if (font.style case final String style) 'style': style,
};

Map<String, Object?> _asMap(Object value, String path) {
  if (value is Map<String, Object?>) return value;
  throw FormatException('$path must be an object.');
}

String _join(String first, [String? second, String? third, String? fourth]) {
  return <String>[
    first,
    if (second case final String value) value,
    if (third case final String value) value,
    if (fourth case final String value) value,
  ].join(Platform.pathSeparator);
}

void _writeJson(File file, Map<String, Object?> value) {
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(value)}\n',
  );
}
