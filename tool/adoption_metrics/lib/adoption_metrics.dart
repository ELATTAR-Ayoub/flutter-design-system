/// Aggregate metrics and Markdown rendering for Elattar's adoption funnel.
library;

typedef JsonMap = Map<String, Object?>;

/// One point-in-time view of public and voluntarily supplied adoption data.
class AdoptionSnapshot {
  const AdoptionSnapshot({
    required this.generatedAt,
    required this.pubScore,
    required this.pubMaxScore,
    required this.pubLikes,
    required this.pubDownloads30Days,
    required this.githubStars,
    required this.githubForks,
    required this.githubViews14Days,
    required this.githubUniqueVisitors14Days,
    required this.githubClones14Days,
    required this.githubUniqueCloners14Days,
    required this.docsVisitors7Days,
    required this.docsUniqueVisitors7Days,
    required this.successfulInstalls7Days,
    required this.activeProjects30Days,
    required this.referrers,
    required this.notes,
  });

  final DateTime generatedAt;
  final int? pubScore;
  final int? pubMaxScore;
  final int? pubLikes;
  final int? pubDownloads30Days;
  final int? githubStars;
  final int? githubForks;
  final int? githubViews14Days;
  final int? githubUniqueVisitors14Days;
  final int? githubClones14Days;
  final int? githubUniqueCloners14Days;
  final int? docsVisitors7Days;
  final int? docsUniqueVisitors7Days;
  final int? successfulInstalls7Days;
  final int? activeProjects30Days;
  final List<({String source, int views, int uniques})> referrers;
  final List<String> notes;
}

/// Reads an integer from a decoded JSON object.
int? jsonInt(JsonMap? map, String key) {
  final Object? value = map?[key];
  return value is num ? value.toInt() : null;
}

/// Renders a snapshot without embedding identifiers or raw event data.
String renderAdoptionMarkdown(AdoptionSnapshot snapshot) {
  String value(int? metric) => metric?.toString() ?? 'Not connected';
  final String score = snapshot.pubScore == null
      ? 'Not connected'
      : '${snapshot.pubScore}/${snapshot.pubMaxScore ?? '—'}';
  final StringBuffer output = StringBuffer()
    ..writeln('# Elattar adoption snapshot')
    ..writeln()
    ..writeln('Generated ${snapshot.generatedAt.toUtc().toIso8601String()}.')
    ..writeln()
    ..writeln('| Funnel stage | Metric | Value | Source |')
    ..writeln('| --- | --- | ---: | --- |')
    ..writeln(
      '| Awareness | Docs visitors, 7 days | ${value(snapshot.docsVisitors7Days)} | Site analytics |',
    )
    ..writeln(
      '| Awareness | Unique docs visitors, 7 days | ${value(snapshot.docsUniqueVisitors7Days)} | Site analytics |',
    )
    ..writeln(
      '| Awareness | GitHub views, 14 days | ${value(snapshot.githubViews14Days)} | GitHub traffic |',
    )
    ..writeln(
      '| Discovery | pub.dev downloads, 30 days | ${value(snapshot.pubDownloads30Days)} | pub.dev |',
    )
    ..writeln('| Trust | pub.dev score | $score | pub.dev |')
    ..writeln(
      '| Trust | pub.dev likes | ${value(snapshot.pubLikes)} | pub.dev |',
    )
    ..writeln(
      '| Trust | GitHub stars | ${value(snapshot.githubStars)} | GitHub |',
    )
    ..writeln(
      '| Trust | GitHub forks | ${value(snapshot.githubForks)} | GitHub |',
    )
    ..writeln(
      '| Activation | Successful installs, 7 days | ${value(snapshot.successfulInstalls7Days)} | Voluntary aggregate |',
    )
    ..writeln(
      '| Activation | GitHub clones, 14 days | ${value(snapshot.githubClones14Days)} | GitHub traffic |',
    )
    ..writeln(
      '| Retention | Active projects, 30 days | ${value(snapshot.activeProjects30Days)} | Voluntary aggregate |',
    )
    ..writeln(
      '| Retention | Unique GitHub cloners, 14 days | ${value(snapshot.githubUniqueCloners14Days)} | GitHub traffic |',
    );

  if (snapshot.referrers.isNotEmpty) {
    output
      ..writeln()
      ..writeln('## Top GitHub referrers')
      ..writeln()
      ..writeln('| Source | Views | Unique visitors |')
      ..writeln('| --- | ---: | ---: |');
    for (final row in snapshot.referrers) {
      output.writeln('| ${row.source} | ${row.views} | ${row.uniques} |');
    }
  }

  output
    ..writeln()
    ..writeln('## Measurement notes')
    ..writeln()
    ..writeln(
      '- The Elattar CLI collects no telemetry. This report uses aggregate platform data and optional manually supplied totals.',
    );
  for (final String note in snapshot.notes) {
    output.writeln('- $note');
  }
  return output.toString();
}
