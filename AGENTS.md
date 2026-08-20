# Flutter UI contribution contract

Use [`elattar-flutter-ui-director`](.agents/skills/elattar-flutter-ui-director/SKILL.md) for every Flutter UI change: screens, components, navigation, effects, feedback, responsive behavior, and UI review.

Follow its API-inventory, token, state, accessibility, placement, and verification rules. Compose product UI outside `lib/src/components/`; use public `Ds*` APIs and foundation tokens; keep visual/motion literals out of `lib/` and `example/lib/` as enforced by `test/token_guard_test.dart`. The Flutter package is authoritative; the prior web project is lineage, not an implementation source.
