## Summary

Describe the change in a few sentences.

## Why

Explain the problem, regression, or improvement this pull request addresses.

## Verification

List the commands you ran and the results you observed.

```powershell
flutter analyze
flutter test
flutter test test/token_guard_test.dart
```

If the example app changed, also include:

```powershell
Push-Location example
flutter analyze
flutter test
Pop-Location
```

## Checklist

- [ ] The change is scoped and intentional.
- [ ] Public `Ds*` APIs and token rules are respected.
- [ ] Tests or docs were added or updated where needed.
- [ ] UI changes include screenshots or recordings when useful.
- [ ] Accessibility impact was considered.
- [ ] Future CLI or registry references do not claim unimplemented behavior as shipped.
