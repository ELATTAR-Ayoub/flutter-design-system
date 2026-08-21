# Phase B — Website shell report

## Status

Accepted with visual follow-up.

## Objective

Add the public Home, Docs, Components, Shots, and Skills destinations without breaking the established component gallery.

## Completed work

- Added immutable public route and search metadata, including GitHub Pages-safe query links.
- Added a responsive public shell with desktop/mobile navigation, documentation search, theme selection, footer, and GitHub callback seam.
- Added useful first-pass Home, Docs, Components, Shots, and Skills pages.
- Kept the existing `dsGroups`, `DocsShell`, specimen routes, and `pageFor` contract intact.
- Made the deployed web build open the public Home route while non-web tests retain the legacy overview default.
- Replaced generic Flutter web title, description, manifest name, colors, and orientation.
- Rebuilt the web target and confirmed the earlier CupertinoIcons warning is not reproducible.

## Files changed

- `example/lib/main.dart`
- `example/lib/site/site_routes.dart`
- `example/lib/site/site_navigation.dart`
- `example/lib/site/site_shell.dart`
- `example/lib/site/pages/public_pages.dart`
- `example/test/site_routes_test.dart`
- `example/test/site_shell_test.dart`
- `example/test/public_pages_test.dart`
- `example/web/index.html`
- `example/web/manifest.json`

## Agent assignments

- B1, Luna: route metadata/search index; accepted, 10 focused tests.
- B2, GPT-5.4: public shell/navigation/search; accepted after analyzer cleanup.
- B3, Luna: five top-level page compositions; accepted, 4 focused tests.
- Supervisor: route dispatch, web-only default, web metadata, full integration review.

## Decisions made

- Public-site metadata is separate from the heavily tested component/specimen tree.
- GitHub Pages deep links use the existing `?route=` contract in this phase; pretty-path browser history is deferred.
- The GitHub action stays an injectable callback until an external-link dependency is deliberately selected.
- No Cupertino dependency was added because a clean release build contains no Cupertino font reference or warning.

## Verification performed

- `flutter analyze` in `example/`: passed.
- `flutter test` in `example/`: 840 tests passed.
- Focused route, shell, and public-page tests passed.
- `flutter build web --release --base-href /flutter-design-system/`: passed during the build audit.

## Supervisor review

Reviewed worker ownership, public API use, token compliance, route compatibility, search states, mobile navigation, and the integration diff. The only required integration was the supervisor-owned `main.dart` dispatch.

## Independent audit

The build/deep-link audit found no reproducible Cupertino warning and confirmed the Pages base href. It also confirmed query routing is the currently safe deep-link strategy.

## Known limitations

- Browser captures of the new routes remain required before public release.
- GitHub opening is a callback seam, not an external navigation implementation.
- Public licensing and bundled-asset redistribution remain release blockers.

## What is next

Phase C builds the reusable documentation article, preview/code, command-copy, API-table, state-matrix, and install-facts compositions.

## Restart instructions

Read `STATUS.md`, this report, the Flutter UI skill, and `example/lib/site/**`; then run `Push-Location example; flutter analyze; flutter test; Pop-Location`.
