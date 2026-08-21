# Phase F — Component documentation

## Outcome

Phase F adds the first five complete, public, registry-backed component guides for release `0.0.1`:

- `/components/button`
- `/components/input`
- `/components/card`
- `/components/dialog`
- `/components/select`

Each guide is composed from the Phase C documentation primitives and the real public `Ds*` API. Every page includes a live specimen, CLI and manual installation, usage, API reference, variants or states, accessibility guidance, dependency facts, source location, and previous/next navigation.

## Architecture delivered

- `example/lib/components_docs/catalog.dart` is the shared source for titles, routes, CLI commands, registry dependencies, public exports, and source paths.
- The five pages live in `example/lib/components_docs/`; they are product-site compositions and do not enter `lib/src/components/`.
- `siteRouteFor` resolves component detail deep links while `siteRoutes` remains the five-item header contract.
- `searchableRoutes` indexes the five component guides in the Components section, including their public Dart exports.
- `PublicComponentsPage` presents the five installable guides first and preserves the established design-system reference groups below them.
- `publicPageFor` maps every new route without changing the legacy `/design-system/...` specimen route table.

## Verification performed

- `dart format` completed for the route, catalog, page, and test changes.
- `flutter analyze` passed for the example application.
- Focused tests passed for all five documentation pages, public-page catalog integration, and route/search integration.
- The focused widget tests exercise live `DsButton`, `DsInput`, `DsCard`, `DsDialog`, and `DsSelect` specimens and narrow/wide layout behavior.

The final full-suite and release-web-build wrapper was attempted after the focused gate. On this Windows runner the Flutter launcher stopped emitting output and left no Dart driver process; the stalled wrappers were terminated. This is recorded as an environment verification follow-up, not as a passing gate or a product failure. The previous Phase E full suite and release build remain the latest completed global gates.

## Revisions made during review

- Corrected breadcrumb construction to the public `DsBreadcrumbEntry.link` and `.page` factories.
- Replaced test-only synthetic `MediaQuery` widths with real test-view sizing so responsive assertions exercise the actual layout surface.
- Replaced brittle copy-text assertions with live-widget and documentation-block assertions.
- Kept the stable component routes separate from the legacy grouped documentation routes.

## Files added

- `example/lib/components_docs/catalog.dart`
- `example/lib/components_docs/button_card_pages.dart`
- `example/lib/components_docs/input_select_pages.dart`
- `example/lib/components_docs/dialog_page.dart`
- `example/test/component_docs_button_card_test.dart`
- `example/test/component_docs_input_select_test.dart`
- `example/test/component_docs_dialog_test.dart`

## Files integrated

- `example/lib/main.dart`
- `example/lib/site/site_routes.dart`
- `example/lib/site/pages/public_pages.dart`
- `example/test/site_routes_test.dart`
- `example/test/public_pages_test.dart`

## Open blockers

- Replace the placeholder `LICENSE` and confirm component redistribution rights.
- Build a real `elattar_core` package or remove/hide package foundation mode.
- Complete browser visual and accessibility captures for the five routes.
- Re-run the full example suite and release web build in a fresh Flutter runner; retain the existing CupertinoIcons warning for audit.
- Publication and deployment remain unauthorized; `publish_to: 'none'` is unchanged.

## Next phase

Phase G should harden the public preview: browser-review the five component routes across narrow and wide viewports, close accessibility findings, resolve the foundation/package and licensing blockers, and complete the global verification gate before any deployment.

## Resume commands

```powershell
Push-Location example
flutter analyze
flutter test
flutter build web --release --base-href /flutter-design-system/
Pop-Location
```
