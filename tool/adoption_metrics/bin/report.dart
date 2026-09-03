import 'dart:convert';
import 'dart:io';

import 'package:adoption_metrics/adoption_metrics.dart';

const String _pubMetricsUrl =
    'https://pub.dev/api/packages/elattar_cli/metrics';
const String _githubApiRoot =
    'https://api.github.com/repos/ELATTAR-Ayoub/flutter-design-system';

Future<void> main(List<String> arguments) async {
  final String? outputPath = _option(arguments, '--output');
  if (arguments.contains('--help') || arguments.contains('-h')) {
    stdout.writeln(
      'dart run tool/adoption_metrics/bin/report.dart '
      '[--output PATH]',
    );
    return;
  }
  if (arguments.any((String value) => value.startsWith('--')) &&
      outputPath == null) {
    stderr.writeln('Unknown option or missing --output path.');
    exitCode = 64;
    return;
  }

  final List<String> notes = <String>[];
  final String? githubToken = Platform.environment['GITHUB_TOKEN'];
  final JsonMap? pubMetrics = await _fetchJson(
    Uri.parse(_pubMetricsUrl),
    notes: notes,
  );
  final JsonMap? github = await _fetchJson(
    Uri.parse(_githubApiRoot),
    token: githubToken,
    notes: notes,
  );
  final JsonMap? views = githubToken == null
      ? null
      : await _fetchJson(
          Uri.parse('$_githubApiRoot/traffic/views'),
          token: githubToken,
          notes: notes,
        );
  final JsonMap? clones = githubToken == null
      ? null
      : await _fetchJson(
          Uri.parse('$_githubApiRoot/traffic/clones'),
          token: githubToken,
          notes: notes,
        );
  final Object? referrerResponse = githubToken == null
      ? null
      : await _fetchJsonValue(
          Uri.parse('$_githubApiRoot/traffic/popular/referrers'),
          token: githubToken,
          notes: notes,
        );
  if (githubToken == null) {
    notes.add(
      'GITHUB_TOKEN was not supplied, so repository traffic and referrers are not connected.',
    );
  }

  final JsonMap? score = pubMetrics?['score'] is JsonMap
      ? pubMetrics!['score'] as JsonMap
      : null;
  final AdoptionSnapshot snapshot = AdoptionSnapshot(
    generatedAt: DateTime.now().toUtc(),
    pubScore: jsonInt(score, 'grantedPoints'),
    pubMaxScore: jsonInt(score, 'maxPoints'),
    pubLikes: jsonInt(score, 'likeCount'),
    pubDownloads30Days: jsonInt(score, 'downloadCount30Days'),
    githubStars: jsonInt(github, 'stargazers_count'),
    githubForks: jsonInt(github, 'forks_count'),
    githubViews14Days: jsonInt(views, 'count'),
    githubUniqueVisitors14Days: jsonInt(views, 'uniques'),
    githubClones14Days: jsonInt(clones, 'count'),
    githubUniqueCloners14Days: jsonInt(clones, 'uniques'),
    docsVisitors7Days: _environmentInt('ELATTAR_DOCS_VISITORS_7D'),
    docsUniqueVisitors7Days: _environmentInt('ELATTAR_DOCS_UNIQUE_VISITORS_7D'),
    successfulInstalls7Days: _environmentInt('ELATTAR_SUCCESSFUL_INSTALLS_7D'),
    activeProjects30Days: _environmentInt('ELATTAR_ACTIVE_PROJECTS_30D'),
    referrers: _parseReferrers(referrerResponse),
    notes: notes,
  );
  final String report = renderAdoptionMarkdown(snapshot);
  if (outputPath == null) {
    stdout.write(report);
    return;
  }
  final File output = File(outputPath);
  output.parent.createSync(recursive: true);
  output.writeAsStringSync(report);
  stdout.writeln('Wrote ${output.path}');
}

String? _option(List<String> arguments, String name) {
  final int index = arguments.indexOf(name);
  if (index == -1 || index + 1 >= arguments.length) return null;
  return arguments[index + 1];
}

int? _environmentInt(String name) =>
    int.tryParse(Platform.environment[name] ?? '');

Future<JsonMap?> _fetchJson(
  Uri uri, {
  String? token,
  required List<String> notes,
}) async {
  final Object? value = await _fetchJsonValue(uri, token: token, notes: notes);
  return value is JsonMap ? value : null;
}

Future<Object?> _fetchJsonValue(
  Uri uri, {
  String? token,
  required List<String> notes,
}) async {
  final HttpClient client = HttpClient();
  try {
    final HttpClientRequest request = await client.getUrl(uri);
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');
    request.headers.set(HttpHeaders.userAgentHeader, 'elattar-adoption-report');
    if (token != null) {
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
      request.headers.set('X-GitHub-Api-Version', '2022-11-28');
    }
    final HttpClientResponse response = await request.close();
    final String body = await utf8.decoder.bind(response).join();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      notes.add('${uri.path} returned HTTP ${response.statusCode}.');
      return null;
    }
    return jsonDecode(body);
  } on Object catch (error) {
    notes.add('${uri.host}${uri.path} was unavailable: $error');
    return null;
  } finally {
    client.close(force: true);
  }
}

List<({String source, int views, int uniques})> _parseReferrers(Object? value) {
  if (value is! List<Object?>) return const [];
  return <({String source, int views, int uniques})>[
    for (final Object? row in value)
      if (row is JsonMap &&
          row['referrer'] is String &&
          row['count'] is num &&
          row['uniques'] is num)
        (
          source: row['referrer'] as String,
          views: (row['count'] as num).toInt(),
          uniques: (row['uniques'] as num).toInt(),
        ),
  ];
}
