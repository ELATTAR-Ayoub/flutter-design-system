library;

import 'dart:convert';
import 'dart:io';

import 'cache.dart';
import 'models.dart';
import 'source.dart';

// Keep in sync with `logicalTargetPrefixes` in the registry builder: this list
// drives payload lookup for integrity verification, so a missing prefix makes
// the payload unfindable rather than merely unverified.
const List<String> _logicalTargetPrefixes = <String>[
  '@ui/',
  '@foundation/',
  '@effects/',
  '@motion/',
  '@app/',
];

class RegistryClient {
  RegistryClient({
    required RegistrySource source,
    this.verifyIntegrityByDefault = false,
  }) : _source = source;

  factory RegistryClient.localGenerated(
    Directory latestDirectory, {
    bool verifyIntegrityByDefault = false,
  }) {
    return RegistryClient(
      source: LocalRegistrySource(latestDirectory),
      verifyIntegrityByDefault: verifyIntegrityByDefault,
    );
  }

  factory RegistryClient.remote({
    required Uri baseUri,
    required RegistryFetcher fetcher,
    RegistryCache? cache,
    bool offline = false,
    bool verifyIntegrityByDefault = false,
  }) {
    return RegistryClient(
      source: RemoteRegistrySource(
        baseUri: baseUri,
        fetcher: fetcher,
        cache: cache ?? InMemoryRegistryCache(),
        offline: offline,
      ),
      verifyIntegrityByDefault: verifyIntegrityByDefault,
    );
  }

  final RegistrySource _source;
  final bool verifyIntegrityByDefault;

  RegistryDocument? _catalogCache;
  RegistryIndexDocument? _indexCache;
  final Map<String, RegistryItem> _itemCache = <String, RegistryItem>{};

  Future<RegistryIndexDocument> loadIndex() async {
    final RegistryIndexDocument? cached = _indexCache;
    if (cached != null) return cached;
    final RegistryIndexDocument document = RegistryIndexDocument.fromJsonString(
      await _source.readText('index.json'),
    );
    _indexCache = document;
    return document;
  }

  Future<RegistryDocument> loadCatalog() async {
    final RegistryDocument? cached = _catalogCache;
    if (cached != null) return cached;
    final RegistryDocument document = RegistryDocument.fromJsonString(
      await _source.readText('registry.json'),
    );
    _catalogCache = document;
    return document;
  }

  Future<List<RegistryItem>> list({
    RegistryItemType? type,
    bool includeDeprecated = false,
  }) async {
    final List<RegistryItem> items = (await loadCatalog()).items
        .where((RegistryItem item) {
          if (!includeDeprecated && item.deprecated) return false;
          if (type != null && item.type != type) return false;
          return true;
        })
        .toList(growable: false);
    items.sort((RegistryItem a, RegistryItem b) => a.name.compareTo(b.name));
    return items;
  }

  Future<List<RegistrySearchResult>> search(
    String query, {
    RegistryItemType? type,
    bool includeDeprecated = false,
  }) async {
    final String normalizedQuery = _normalize(query);
    if (normalizedQuery.isEmpty) {
      return <RegistrySearchResult>[
        for (final RegistryItem item in await list(
          type: type,
          includeDeprecated: includeDeprecated,
        ))
          RegistrySearchResult(item: item, score: 0),
      ];
    }
    final List<RegistrySearchResult> results = <RegistrySearchResult>[];
    for (final RegistryItem item in await list(
      type: type,
      includeDeprecated: includeDeprecated,
    )) {
      final int score = _searchScore(item, normalizedQuery);
      if (score > 0) {
        results.add(RegistrySearchResult(item: item, score: score));
      }
    }
    results.sort((RegistrySearchResult a, RegistrySearchResult b) {
      final int byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      return a.item.name.compareTo(b.item.name);
    });
    return results;
  }

  Future<RegistryItem> info(
    String name, {
    String? version,
    bool? verifyIntegrity,
  }) async {
    final String resolvedVersion = version ?? await _versionFor(name);
    final String cacheKey = '$name@$resolvedVersion';
    final RegistryItem? cached = _itemCache[cacheKey];
    if (cached != null) {
      if (verifyIntegrity ?? verifyIntegrityByDefault) {
        await _verifyItemIntegrity(cached);
      }
      return cached;
    }
    final RegistryItem item = RegistryItem.fromJson(
      jsonDecode(await _source.readText(_manifestPath(name, resolvedVersion))),
      r'$',
    );
    _itemCache[cacheKey] = item;
    if (verifyIntegrity ?? verifyIntegrityByDefault) {
      await _verifyItemIntegrity(item);
    }
    return item;
  }

  Future<List<RegistryItem>> resolve(
    Iterable<String> names, {
    bool? verifyIntegrity,
  }) async {
    final List<String> requested = _stableUnique(names);
    final Map<String, _VisitState> states = <String, _VisitState>{};
    final List<RegistryItem> ordered = <RegistryItem>[];
    final List<String> stack = <String>[];

    Future<void> visit(String name) async {
      final _VisitState state = states[name] ?? _VisitState.unvisited;
      if (state == _VisitState.visited) return;
      if (state == _VisitState.visiting) {
        final int start = stack.indexOf(name);
        final List<String> cycle = <String>[...stack.skip(start), name];
        throw RegistryDependencyCycleException(cycle);
      }
      states[name] = _VisitState.visiting;
      stack.add(name);
      final RegistryItem item;
      try {
        item = await info(name, verifyIntegrity: verifyIntegrity);
      } on RegistryItemNotFoundException {
        rethrow;
      }
      for (final String dependency in item.registryDependencies) {
        await visit(dependency);
      }
      stack.removeLast();
      states[name] = _VisitState.visited;
      ordered.add(item);
    }

    for (final String name in requested) {
      await visit(name);
    }
    return ordered;
  }

  Future<String> _versionFor(String name) async {
    for (final RegistryIndexItem item in (await loadIndex()).items) {
      if (item.name == name) return item.version;
    }
    throw RegistryItemNotFoundException(name);
  }

  Future<void> _verifyItemIntegrity(RegistryItem item) async {
    for (final RegistryResource resource in item.resources) {
      final String relativePath = _versionPayloadPath(
        item.name,
        item.version,
        resource.target,
      );
      final List<int> bytes = await _source.readBytes(relativePath);
      final String actual = sha256Hex(bytes);
      if (actual != resource.sha256) {
        throw RegistryIntegrityException(
          itemName: item.name,
          target: resource.target,
          expectedSha256: resource.sha256,
          actualSha256: actual,
        );
      }
    }
  }
}

class RegistryItemNotFoundException implements Exception {
  RegistryItemNotFoundException(this.name);

  final String name;

  @override
  String toString() => 'RegistryItemNotFoundException: Unknown item "$name".';
}

class RegistryDependencyCycleException implements Exception {
  RegistryDependencyCycleException(this.cycle);

  final List<String> cycle;

  @override
  String toString() =>
      'RegistryDependencyCycleException: ${cycle.join(' -> ')}';
}

class RegistryIntegrityException implements Exception {
  RegistryIntegrityException({
    required this.itemName,
    required this.target,
    required this.expectedSha256,
    required this.actualSha256,
  });

  final String itemName;
  final String target;
  final String expectedSha256;
  final String actualSha256;

  @override
  String toString() {
    return 'RegistryIntegrityException: $itemName $target expected '
        '$expectedSha256 but found $actualSha256.';
  }
}

enum _VisitState { unvisited, visiting, visited }

String _manifestPath(String name, String version) {
  return 'versions/$name/$version/manifest.json';
}

String _versionPayloadPath(String name, String version, String target) {
  return 'versions/$name/$version/${_payloadPath(target)}';
}

String _payloadPath(String target) {
  for (final String prefix in _logicalTargetPrefixes) {
    if (target.startsWith(prefix)) return 'logical/${target.substring(1)}';
  }
  return 'logical/$target';
}

List<String> _stableUnique(Iterable<String> values) {
  final Set<String> seen = <String>{};
  final List<String> output = <String>[];
  for (final String value in values) {
    if (seen.add(value)) output.add(value);
  }
  return output;
}

String _normalize(String value) {
  return value.trim().toLowerCase();
}

int _searchScore(RegistryItem item, String query) {
  final String name = _normalize(item.name);
  final String description = _normalize(item.description);
  final String route = _normalize(item.documentationRoute);
  final String sourceLink = _normalize(item.sourceLink);
  if (name == query) return 400;
  int score = 0;
  if (name.startsWith(query)) score += 300;
  if (name.contains(query)) score += 160;
  if (description.contains(query)) score += 80;
  if (route.contains(query)) score += 40;
  if (sourceLink.contains(query)) score += 20;
  return score;
}

String sha256Hex(List<int> bytes) {
  int rotr(int x, int n) => (x >>> n) | ((x << (32 - n)) & 0xffffffff);
  const List<int> k = <int>[
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
  final List<int> padded = <int>[...bytes, 0x80];
  while ((padded.length % 64) != 56) {
    padded.add(0);
  }
  final int bitLength = bytes.length * 8;
  for (int shift = 56; shift >= 0; shift -= 8) {
    padded.add((bitLength >> shift) & 0xff);
  }
  for (int chunk = 0; chunk < padded.length; chunk += 64) {
    final List<int> w = List<int>.filled(64, 0);
    for (int i = 0; i < 16; i++) {
      final int p = chunk + i * 4;
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
