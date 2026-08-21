library;

import 'dart:convert';

abstract class RegistryCache {
  Future<List<int>?> readBytes(String key);

  Future<void> writeBytes(String key, List<int> value);

  Future<void> clear();

  Future<String?> readText(String key) async {
    final List<int>? bytes = await readBytes(key);
    if (bytes == null) return null;
    return utf8.decode(bytes);
  }

  Future<void> writeText(String key, String value) {
    return writeBytes(key, utf8.encode(value));
  }
}

class InMemoryRegistryCache extends RegistryCache {
  final Map<String, List<int>> _entries = <String, List<int>>{};

  @override
  Future<void> clear() async {
    _entries.clear();
  }

  @override
  Future<List<int>?> readBytes(String key) async {
    final List<int>? bytes = _entries[key];
    if (bytes == null) return null;
    return List<int>.from(bytes);
  }

  @override
  Future<void> writeBytes(String key, List<int> value) async {
    _entries[key] = List<int>.from(value);
  }
}
