# GitHub publishing checklist

These settings live on GitHub rather than in the repository, so verify them
after every major positioning change.

## About panel

Description:

> Production-ready Flutter components delivered as source you own.

Website: `https://flutter.elattar.dev`

Topics, in this order:

`flutter`, `dart`, `design-system`, `flutter-ui`, `ui-components`,
`accessibility`, `developer-tools`, `source-code`, `motion`, `ai-coding`

## Social preview

Upload `docs/assets/readme/hero.png` in **Settings → General → Social preview**.
The checked-in image is 1774×887, a 2:1 image under 1 MB, so it is suitable for
GitHub's link preview without generating another source of truth.

## Release page

Every release description should answer, in order:

1. What changed for a user.
2. How to install or update.
3. What the result looks like.
4. What is intentionally unsupported.
5. Where to report a problem.

Attach the 45-second demo described in `docs/launch/demo-script.md`. Use the
same verified commit for the Git tag, CLI package, registry, and release notes.
