# Agent brief — component documentation page kit

Copy the block below as the opening prompt for the implementing agent.

---

Implement the plan at
`docs/superpowers/plans/2026-08-25-component-doc-page-kit.md`.

Read these first, in order:

1. `AGENTS.md`, then the complete `skills/elattar-flutter-ui-director/SKILL.md`
   **with all seven of its references**. Its non-negotiable contract governs
   every line you write.
2. The design this plan implements:
   `docs/superpowers/specs/2026-08-25-component-doc-page-kit-design.md`.
3. The plan itself, including its **Global Constraints** — they apply to every
   task and are not repeated per task.

Work on branch `public-release-v0.0.1`, at commit `64b7427` or later. Never
create a `codex/`-prefixed branch.

Use `superpowers:subagent-driven-development` — one fresh subagent per task,
reviewed between tasks. Tasks 1 through 8 are the kit and are ordered by
dependency; 9 and 10 are independent and may run in either order; 11 depends on
everything before it; 12 is the gate.

## What you are building

Thirteen documentation components in `example/lib/docs/`, then `/components/button`
rebuilt entirely from them. The Button page already carries the right content in
the right order — this is a re-housing, **not a content rewrite**. Every
existing specimen widget and code string moves across unchanged.

## Stop conditions

- **Stop after Task 12.** Do not roll the kit out to a second page. The Button
  page is the review gate and the user reviews it before anything else moves.
- Do not write the 49 missing component pages. This work makes them cheap; it
  does not do them.

## Repository traps that are NOT in the plan

- **`pumpAndSettle` hangs on any page containing `ElAlert`.** It renders
  `ElBloomCosmic`, whose controllers `repeat(reverse: true)` forever. Use
  `tester.pump()`. The symptom is a timeout, not a failure.
- **`Directory.current` is process-wide** and `dart test` runs test files in
  separate isolates of one process. Never mutate it.
- **`.gitattributes` pins everything to LF** and it is load-bearing — the
  generated registry records a sha256 per file computed from the working tree.
  Do not weaken it.
- **`tool/generate_icons.mjs` runs `dart format` on its own output.** Do not
  undo that; without it a header change becomes a 21,000-line diff.
- **The example suite takes ~16 minutes**, the root suite ~2.5. Neither is a
  candidate for a tight loop. Run focused tests while implementing and the full
  ladder once, at Task 12.
- **On Git Bash for Windows**, `flutter build web --base-href /x/` has its
  argument rewritten into a Windows path. Prefix the command with
  `MSYS_NO_PATHCONV=1`.
- **Serve captures from a short path** (`C:/elx/...`). A capture root under a
  long temp path pushes the deepest bundled assets past Windows MAX_PATH (260):
  the files exist, `os.listdir` lists them, `os.path.exists` is False, and the
  static server 404s them.
- **`capture.js` needs `--nav domcontentloaded`** for any page rendering
  `ElAlert` — such a page never goes network-idle and the capture dies on its
  navigation timeout. Narrow widths use `shot.js`, not `capture.js`; the
  stitcher's content clip is the wide shell's own geometry.

## Boundaries

Do not touch, and do not revert:

- Anything under `lib/src/`, and no foundation token. This is product code.
- `lib/pages/` — the gallery every `/design-system/...` route already falls
  back away from.
- The four unpushed release commits already on this branch (`c2c2e91`,
  `d7b98c2`, `4a7db85`, `64b7427`). There is separate release work in flight:
  Tasks 10 and 11 of
  `docs/superpowers/plans/2026-08-24-public-v0.0.1-mit-cli-docs-release.md` are
  done, and its verification report is still unwritten. Leave it alone.

Do not, under any circumstances, without the owner saying so explicitly in the
conversation: change repository visibility, create or push a tag, deploy GitHub
Pages, run `dart pub publish` without `--dry-run`, or create a GitHub release.

## Reporting

Report after Task 8 (the kit is complete, nothing is wired up yet) and again
after Task 12. In both reports, distinguish commands you actually ran from
commands you planned, and give exit codes and measured counts rather than
adjectives.
