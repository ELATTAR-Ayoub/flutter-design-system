library;

import 'dart:convert';
import 'dart:io';

import 'cache.dart';

class RegistryFetchResponse {
  const RegistryFetchResponse({
    required this.statusCode,
    required this.bodyBytes,
  });

  final int statusCode;
  final List<int> bodyBytes;

  String get body => utf8.decode(bodyBytes);
}

typedef RegistryFetcher = Future<RegistryFetchResponse> Function(Uri uri);

abstract class RegistrySource {
  Future<List<int>> readBytes(String relativePath);

  Future<String> readText(String relativePath) async {
    return utf8.decode(await readBytes(relativePath));
  }
}

class LocalRegistrySource extends RegistrySource {
  LocalRegistrySource(this.rootDirectory);

  final Directory rootDirectory;

  @override
  Future<List<int>> readBytes(String relativePath) async {
    final File file = File(_join(rootDirectory.path, relativePath));
    if (!await file.exists()) {
      throw RegistrySourceException(
        'Local registry resource not found: $relativePath',
      );
    }
    return file.readAsBytes();
  }
}

class RemoteRegistrySource extends RegistrySource {
  RemoteRegistrySource({
    required this.baseUri,
    required this.fetcher,
    required this.cache,
    this.offline = false,
  });

  final Uri baseUri;
  final RegistryFetcher fetcher;
  final RegistryCache cache;
  final bool offline;

  @override
  Future<List<int>> readBytes(String relativePath) async {
    final String cacheKey = _cacheKey(relativePath);
    if (offline) {
      final List<int>? cached = await cache.readBytes(cacheKey);
      if (cached == null) {
        throw RegistrySourceException(
          'Registry cache miss for "$relativePath" in offline mode.',
        );
      }
      return cached;
    }
    final Uri uri = baseUri.resolve(relativePath.replaceAll(r'\', '/'));
    final RegistryFetchResponse response = await fetcher(uri);
    if (response.statusCode == 200) {
      await cache.writeBytes(cacheKey, response.bodyBytes);
      return List<int>.from(response.bodyBytes);
    }
    // A stale cache entry beats a failed request: the registry is immutable
    // at a versioned URL, so anything cached for this key is still correct.
    final List<int>? cached = await cache.readBytes(cacheKey);
    if (cached != null) return cached;
    if (response.statusCode == 404) {
      throw RegistrySourceException(
        'No registry at $uri (HTTP 404). '
        'Check the --registry URL, or the `registry:` key in elattar.yaml.',
      );
    }
    throw RegistrySourceException(
      'Registry request failed for $uri with HTTP ${response.statusCode}.',
    );
  }

  String _cacheKey(String relativePath) {
    return '${baseUri.toString()}::$relativePath';
  }
}

class RegistrySourceException implements Exception {
  RegistrySourceException(this.message);

  final String message;

  @override
  String toString() => 'RegistrySourceException: $message';
}

String _join(String first, String second) {
  final String normalizedFirst = first.replaceAll('\\', '/');
  final String normalizedSecond = second.replaceAll('\\', '/');
  return '$normalizedFirst/$normalizedSecond'.replaceAll('//', '/');
}
