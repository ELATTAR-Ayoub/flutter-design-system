# Measuring Elattar adoption

The project measures a funnel, not a vanity total:

1. **Awareness** — documentation and GitHub visitors.
2. **Discovery** — pub.dev downloads and GitHub referrers.
3. **Trust** — pub.dev score, likes, stars, and forks.
4. **Activation** — completed quickstarts or successful installs.
5. **Retention** — projects still using Elattar after 30 days.

The CLI collects no telemetry. `.github/workflows/adoption-metrics.yml` creates
an aggregate weekly artifact from pub.dev and GitHub. Run the same report
locally with:

```bash
dart run tool/adoption_metrics/bin/report.dart
```

Pass `GITHUB_TOKEN` to include repository traffic that GitHub exposes only to
maintainers. Four optional aggregate environment values fill metrics that the
public platforms cannot provide:

- `ELATTAR_DOCS_VISITORS_7D`
- `ELATTAR_DOCS_UNIQUE_VISITORS_7D`
- `ELATTAR_SUCCESSFUL_INSTALLS_7D`
- `ELATTAR_ACTIVE_PROJECTS_30D`

Leave a value disconnected rather than estimating it. If site analytics is
added later, prefer a first-party or cookieless aggregate and document the
provider, retention period, data fields, and opt-out before deployment. Do not
add identifiers or installation event collection to the CLI merely to fill a
dashboard.

The `Showcase` issue form supplies qualitative evidence: what someone built,
whether they finished the quickstart, and what nearly stopped them. Review that
friction alongside the weekly totals before choosing roadmap work.
