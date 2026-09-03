import 'package:adoption_metrics/adoption_metrics.dart';
import 'package:test/test.dart';

void main() {
  test('renders missing private metrics explicitly', () {
    final String report = renderAdoptionMarkdown(
      AdoptionSnapshot(
        generatedAt: DateTime.utc(2026, 9, 4),
        pubScore: 130,
        pubMaxScore: 160,
        pubLikes: 0,
        pubDownloads30Days: 0,
        githubStars: 2,
        githubForks: 1,
        githubViews14Days: null,
        githubUniqueVisitors14Days: null,
        githubClones14Days: null,
        githubUniqueCloners14Days: null,
        docsVisitors7Days: null,
        docsUniqueVisitors7Days: null,
        successfulInstalls7Days: null,
        activeProjects30Days: null,
        referrers: const [],
        notes: const <String>['No user-level telemetry is collected.'],
      ),
    );

    expect(report, contains('| Trust | pub.dev score | 130/160 | pub.dev |'));
    expect(report, contains('Not connected'));
    expect(report, contains('The Elattar CLI collects no telemetry.'));
  });
}
