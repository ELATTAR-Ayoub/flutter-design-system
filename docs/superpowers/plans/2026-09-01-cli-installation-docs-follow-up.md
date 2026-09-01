# CLI installation documentation follow-up

## Status

Complete in the working tree. The public GitHub marketplace round trip is verified: Claude Code
accepted `ELATTAR-Ayoub/flutter-design-system`, installed
`elattar-design-system@elattar`, and showed the plugin enabled. The earlier
local-directory marketplace had to be removed first because Claude Code does
not allow one marketplace name to silently change sources.

Implementation verification:

- `claude plugin validate .` passed.
- Root and example analysis passed.
- The CLI analyzer and all 129 CLI tests passed.
- The focused documentation suite passed all 62 tests.
- `flutter build web --release` completed successfully.
- `git diff --check` passed.

## Confirmed problems

1. `dart install elattar_cli` installs the Windows launcher in
   `%LOCALAPPDATA%\Dart\install\bin`.
2. Current documentation tells Windows users to add
   `%LOCALAPPDATA%\Pub\Cache\bin`, which belongs to the older
   `dart pub global activate` workflow.
3. Some public documentation and release facts still report `0.0.1` after the
   successful publication of `elattar_cli 0.0.2`.
4. `elattar doctor` reports missing `elattar.yaml` and
   `.elattar/manifest.json` before `elattar init`; the docs must make that
   ordering and expected state clear.
5. The Skills page still calls the GitHub plugin route pending, even though the
   public round trip now works.
6. The Skills page publishes the valid `/plugin list` command, but omits the
   easier `/plugin` manager, conditional `/reload-plugins` activation step,
   and explicit skill invocation.
7. The Skills page leads with verification machinery, licensing history, and a
   full source tree instead of the short user path: what it does, install,
   example requests, what is included, how it works, and deeper links.
8. `SKILL.md` applies its full UI contract and verification gate to every task,
   including small reviews and documentation edits. Keep the contract for
   substantial UI work, but make the workflow proportional to task scope.

## Execution plan

### 1. Record the completed skill-installation test

- Record the verified marketplace and plugin names.
- Document replacement of a conflicting local marketplace as troubleshooting,
  not as part of the normal installation path.
- Publish `/reload-plugins`, `/plugin`, and an explicit skill invocation as the
  verification path.
- Mark the GitHub plugin route verified today.

### 2. Establish the CLI installation facts

- Rehearse `dart install elattar_cli` in a clean Windows environment.
- Confirm the installed launcher path, first-run warning, version output, and
  behavior in both the current terminal and a newly opened terminal.
- Verify the older `dart pub global activate elattar_cli` path independently.
- Document each installation method with its own PATH directory; do not mix
  their instructions.

### 3. Correct every public documentation surface

- Update the root `README.md`.
- Update `packages/elattar_cli/README.md`.
- Update the website Installation and CLI pages and their shared release facts.
- Replace stale `0.0.1` public-release claims with `0.0.2` where they describe
  the current CLI or registry. Preserve historical changelog entries.
- Explain that users run `elattar init` inside their Flutter application before
  expecting `elattar doctor` to report configuration and manifest success.
- Provide a direct-launch fallback for Windows that matches `dart install`.
- Rewrite the public Skills page in the same concise order as shadcn's page:
  purpose, examples, recommended install, what's included, how it works, and
  compact management/source details.
- Move repository and manual-copy alternatives behind the recommended Claude
  Code route instead of presenting three equal choices.
- Remove obsolete pending-verification and licensing-gate copy.
- Keep detailed reference files available without making the complete file tree
  part of the first-use path.
- Make `SKILL.md` choose a light, standard, or full workflow based on task risk;
  preserve token, API, accessibility, and Flutter-authority rules.

### 4. Add regression protection

- Add documentation assertions for the Windows `dart install` directory.
- Assert that the `dart install` and global-activation PATH instructions remain
  distinct.
- Assert that current release facts consistently report `0.0.2`.
- Assert that the GitHub skill route is verified, uses `/plugin`, includes
  `/reload-plugins`, and exposes an invocation check.
- Assert that no public skill copy still claims the GitHub route is pending.
- Keep version values sourced from the existing release-facts/identity owners
  instead of duplicating hardcoded claims where practical.

### 5. Verify efficiently

Run focused checks first, then expensive Flutter checks once:

1. CLI documentation and identity tests.
2. Website documentation tests affected by Installation, CLI, and release facts.
3. CLI analyzer and test suite.
4. Example analyzer and complete example test suite.
5. Production web build and `git diff --check`.
6. Clean Windows consumer rehearsal: install, PATH setup, `elattar --version`,
   `elattar init`, component add, and `elattar doctor`.

### 6. Release the correction

- Commit and push the documentation/test correction to `main`.
- Deploy the documentation website.
- Do not publish another CLI version unless investigation finds an executable
  defect; a PATH documentation correction alone does not require `0.0.3`.
- Verify the live pages and repeat the copy-pasted public commands exactly as a
  new user would.

## Completion criteria

- A Windows user can install and invoke `elattar 0.0.2` using only the published
  instructions.
- Both supported Dart installation flows name the correct executable directory.
- Public current-version claims agree on `0.0.2`.
- The documented `init` then `doctor` flow passes in a clean Flutter project.
- Skill installation and CLI installation each have independently verified,
  copy-pasteable instructions.
- The public Skills page is short enough to scan and places the recommended
  installation before implementation details.
- Small skill tasks do not inherit the full UI delivery gate unless their scope
  warrants it.
