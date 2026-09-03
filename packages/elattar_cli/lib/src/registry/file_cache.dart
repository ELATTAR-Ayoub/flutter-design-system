/// A registry cache that survives the process.
///
/// The in-memory cache in `cache.dart` is populated and discarded within a
/// single command, which makes `--offline` a flag that can only ever report a
/// miss: nothing has ever been written for it to read. This one persists to
/// the user's cache directory, so `elattar add button` warms what `elattar
/// add card --offline` reads an hour later.
///
/// Three properties matter more than speed here.
///
///  * **Writes are atomic.** A cache entry is written to a temporary file and
///    renamed into place. A CLI interrupted mid-download must not leave a
///    truncated payload that later verifies against nothing and installs as
///    real source.
///  * **Keys never become paths.** A cache key contains a full URL. Hashing it
///    means no part of a remote URL can steer a write out of the cache
///    directory, and it sidesteps every filesystem limit on length and
///    character set at once.
///  * **A cache is an optimisation, never a dependency.** If the directory
///    cannot be created or written, the CLI degrades to memory and keeps
///    working. A read-only home directory is a bad day, not a broken install.
library;

import 'dart:io';

import 'cache.dart';
import 'client.dart' show sha256Hex;

/// The directory name used under whichever per-user cache root applies.
const String cacheDirectoryName = 'elattar';

/// Bumped only when the on-disk layout changes in a way old entries cannot
/// satisfy. Entries live under it, so a bump abandons the old ones rather
/// than migrating or deleting them.
const String cacheLayoutVersion = 'v1';

/// A [RegistryCache] backed by files, with an in-memory fallback.
class FileRegistryCache extends RegistryCache {
  FileRegistryCache._(this._directory, this._fallback);

  /// Opens the cache at [directory], or at the platform default.
  ///
  /// Never throws. A cache that cannot be opened returns an instance that
  /// behaves exactly like [InMemoryRegistryCache], and [isPersistent] says so
  /// — which is what `doctor` reports rather than claiming an offline
  /// capability the user does not have.
  factory FileRegistryCache.open({Directory? directory}) {
    final Directory? resolved = directory ?? defaultCacheDirectory();
    if (resolved == null) {
      return FileRegistryCache._(null, <String, List<int>>{});
    }
    try {
      resolved.createSync(recursive: true);
      // Prove writability now rather than at the first download, when the
      // user is midway through an install and the failure is confusing.
      final File probe = File(
        '${resolved.path}${Platform.pathSeparator}.probe',
      );
      probe.writeAsBytesSync(const <int>[]);
      probe.deleteSync();
      return FileRegistryCache._(resolved, <String, List<int>>{});
    } on FileSystemException {
      return FileRegistryCache._(null, <String, List<int>>{});
    }
  }

  final Directory? _directory;
  final Map<String, List<int>> _fallback;

  /// Whether entries actually outlive this process.
  bool get isPersistent => _directory != null;

  /// Where entries are written, or null when running from memory.
  Directory? get directory => _directory;

  /// How many entries are on disk right now.
  int get entryCount {
    final Directory? root = _directory;
    if (root == null) return _fallback.length;
    try {
      return root
          .listSync()
          .whereType<File>()
          .where((File file) => file.path.endsWith('.bin'))
          .length;
    } on FileSystemException {
      return 0;
    }
  }

  File _fileFor(String key) {
    // The key is a URL plus a path. Hashed, so it cannot contain a separator,
    // a drive letter, a `..`, or 4,000 characters.
    final String name = sha256Hex(key.codeUnits);
    return File('${_directory!.path}${Platform.pathSeparator}$name.bin');
  }

  @override
  Future<List<int>?> readBytes(String key) async {
    if (_directory == null) {
      final List<int>? bytes = _fallback[key];
      return bytes == null ? null : List<int>.from(bytes);
    }
    try {
      final File file = _fileFor(key);
      if (!file.existsSync()) return null;
      return file.readAsBytesSync();
    } on FileSystemException {
      return null;
    }
  }

  @override
  Future<void> writeBytes(String key, List<int> value) async {
    if (_directory == null) {
      _fallback[key] = List<int>.from(value);
      return;
    }
    try {
      final File target = _fileFor(key);
      // `.$pid.tmp` rather than a fixed name: two `elattar` processes warming
      // the same entry must not write through each other's temporary file.
      final File temporary = File('${target.path}.$pid.tmp');
      temporary.writeAsBytesSync(value, flush: true);
      temporary.renameSync(target.path);
    } on FileSystemException {
      // Degrade rather than fail the command. The payload is already in hand;
      // failing to memoise it is not a reason to refuse an install.
      _fallback[key] = List<int>.from(value);
    }
  }

  @override
  Future<void> clear() async {
    _fallback.clear();
    final Directory? root = _directory;
    if (root == null) return;
    try {
      for (final FileSystemEntity entity in root.listSync()) {
        if (entity is File && entity.path.endsWith('.bin')) {
          entity.deleteSync();
        }
      }
    } on FileSystemException {
      // Nothing to do: a cache that cannot be cleared is still a cache that
      // verifies every entry by sha256 before use.
    }
  }
}

/// The per-user cache directory for this platform, or null if none applies.
///
/// Follows each platform's own convention rather than inventing one, so the
/// entries land where a user's existing tooling already looks:
///
///  * Windows — `%LOCALAPPDATA%`, the documented home for regenerable data.
///  * macOS — `~/Library/Caches`.
///  * Linux and everything else — `$XDG_CACHE_HOME`, falling back to
///    `~/.cache` as the XDG base directory specification requires.
///
/// `ELATTAR_CACHE_DIR` overrides all of it, which is what CI uses to keep a
/// run's cache inside its own workspace.
Directory? defaultCacheDirectory({Map<String, String>? environment}) {
  final Map<String, String> env = environment ?? Platform.environment;

  final String? override = env['ELATTAR_CACHE_DIR'];
  if (override != null && override.trim().isNotEmpty) {
    return Directory(override.trim());
  }

  String? root;
  if (Platform.isWindows) {
    root = env['LOCALAPPDATA'] ?? env['APPDATA'] ?? env['USERPROFILE'];
  } else if (Platform.isMacOS) {
    final String? home = env['HOME'];
    root = home == null ? null : '$home/Library/Caches';
  } else {
    root = env['XDG_CACHE_HOME'];
    if (root == null || root.trim().isEmpty) {
      final String? home = env['HOME'];
      root = home == null ? null : '$home/.cache';
    }
  }
  if (root == null || root.trim().isEmpty) return null;

  return Directory(
    <String>[
      root,
      cacheDirectoryName,
      'registry',
      cacheLayoutVersion,
    ].join(Platform.pathSeparator),
  );
}
