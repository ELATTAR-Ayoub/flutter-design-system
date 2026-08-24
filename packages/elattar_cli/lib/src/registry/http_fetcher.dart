/// The one place this CLI talks to the network.
///
/// Everything below exists because the thing on the other end is not trusted
/// to be well behaved: a hosted registry can redirect forever, hang, or return
/// a response far larger than any real payload. Each of those has a bound
/// here, and each failure comes back as a sentence rather than a Dart stack
/// trace — a user who typed a URL wrong should read one line, not an
/// exception dump from inside `dart:io`.
library;

import 'dart:async';
import 'dart:io';

import 'source.dart';

/// The largest response this CLI will read into memory.
///
/// The biggest real payload in the `0.0.1` registry is the generated lucide
/// geometry at roughly 750 KB, so 16 MiB is two orders of magnitude of
/// headroom and still small enough that a hostile or misconfigured endpoint
/// cannot exhaust memory before the limit trips.
const int defaultMaxResponseBytes = 16 * 1024 * 1024;

/// How long a single request may take, end to end.
const Duration defaultRequestTimeout = Duration(seconds: 30);

/// How many redirects to follow before giving up.
///
/// A hosted registry legitimately needs one or two — `http` to `https`, or a
/// Pages host normalising a path. A chain longer than this is a loop or a
/// misconfiguration, and following it forever is how a CLI appears to hang.
const int defaultMaxRedirects = 5;

/// Builds a [RegistryFetcher] backed by real HTTP.
///
/// Returned as a closure rather than a class so the whole network surface is
/// one function that tests can substitute — which is what lets the suites in
/// `test/remote_registry_test.dart` run against a local `HttpServer` and
/// never touch the internet.
RegistryFetcher httpRegistryFetcher({
  HttpClient? client,
  int maxResponseBytes = defaultMaxResponseBytes,
  Duration timeout = defaultRequestTimeout,
  int maxRedirects = defaultMaxRedirects,
}) {
  return (Uri uri) async {
    final HttpClient http = client ?? HttpClient();
    http.connectionTimeout = timeout;
    http.userAgent = 'elattar-cli';
    try {
      return await _fetch(
        http,
        uri,
        maxResponseBytes: maxResponseBytes,
        maxRedirects: maxRedirects,
      ).timeout(
        timeout,
        onTimeout: () => throw RegistrySourceException(
          'Registry request to $uri timed out after '
          '${timeout.inSeconds}s. Check the URL, or pass --offline to work '
          'from the cache.',
        ),
      );
    } on RegistrySourceException {
      rethrow;
    } on SocketException catch (error) {
      // The common case, and the one whose default `toString()` is least
      // useful: it names an OS errno and a port. Say what a person can act on.
      throw RegistrySourceException(
        'Cannot reach ${uri.host}: ${error.osError?.message ?? error.message}. '
        'Check your connection, or pass --offline to work from the cache.',
      );
    } on HandshakeException catch (error) {
      throw RegistrySourceException(
        'TLS handshake with ${uri.host} failed: ${error.message}',
      );
    } on HttpException catch (error) {
      throw RegistrySourceException(
        'Registry request to $uri failed: ${error.message}',
      );
    } finally {
      if (client == null) http.close(force: true);
    }
  };
}

Future<RegistryFetchResponse> _fetch(
  HttpClient http,
  Uri uri, {
  required int maxResponseBytes,
  required int maxRedirects,
}) async {
  // Redirects are followed by hand rather than by `followRedirects`, for one
  // reason: the automatic path reports a redirect-limit breach as an
  // `HttpException` whose message does not name the chain, and a redirect
  // loop is exactly the failure a user needs to see the chain for.
  final List<Uri> chain = <Uri>[uri];
  Uri current = uri;
  for (int redirect = 0; redirect <= maxRedirects; redirect++) {
    final HttpClientRequest request = await http.getUrl(current);
    request.followRedirects = false;
    final HttpClientResponse response = await request.close();

    if (_isRedirect(response.statusCode)) {
      final String? location = response.headers.value(
        HttpHeaders.locationHeader,
      );
      await response.drain<void>();
      if (location == null || location.isEmpty) {
        throw RegistrySourceException(
          'Registry redirected from $current with no Location header.',
        );
      }
      final Uri next = current.resolve(location);
      if (chain.contains(next)) {
        throw RegistrySourceException(
          'Registry redirect loop: ${chain.map((Uri u) => u.toString()).join(' -> ')} '
          '-> $next',
        );
      }
      if (redirect == maxRedirects) {
        throw RegistrySourceException(
          'Registry exceeded $maxRedirects redirects: '
          '${chain.map((Uri u) => u.toString()).join(' -> ')} -> $next',
        );
      }
      chain.add(next);
      current = next;
      continue;
    }

    // A declared length over the cap is refused before a single byte is read.
    // The streaming check below is the backstop for a server that lies or
    // omits the header.
    final int declared = response.contentLength;
    if (declared > maxResponseBytes) {
      await response.drain<void>();
      throw RegistrySourceException(
        'Registry response for $current declares ${declared} bytes, over the '
        '$maxResponseBytes byte limit.',
      );
    }

    final List<int> bytes = await _readBounded(
      response,
      current,
      maxResponseBytes,
    );
    return RegistryFetchResponse(
      statusCode: response.statusCode,
      bodyBytes: bytes,
    );
  }
  throw RegistrySourceException('Registry redirect handling fell through.');
}

bool _isRedirect(int statusCode) =>
    statusCode == HttpStatus.movedPermanently ||
    statusCode == HttpStatus.found ||
    statusCode == HttpStatus.seeOther ||
    statusCode == HttpStatus.temporaryRedirect ||
    statusCode == HttpStatus.permanentRedirect;

/// Accumulates the body, aborting the moment it crosses [limit].
///
/// Deliberately not `response.fold`/`toList`: those read the whole stream
/// before anyone can object, which makes the size limit advisory. This stops
/// at the first chunk that takes the total over the line.
Future<List<int>> _readBounded(
  HttpClientResponse response,
  Uri uri,
  int limit,
) async {
  final List<int> bytes = <int>[];
  await for (final List<int> chunk in response) {
    bytes.addAll(chunk);
    if (bytes.length > limit) {
      throw RegistrySourceException(
        'Registry response for $uri exceeded the $limit byte limit.',
      );
    }
  }
  return bytes;
}
