# Phase I — independent audit findings (I3: content, licensing, links, registry, docs)

Audited at `cb0cc2a`. Auditor wrote none of the code.

## The one that would have shipped

**F8 — BLOCKER.** `example/lib/site/pages/public_pages.dart:87-105` publishes, under
`QUICKSTART` / "One command to begin.":

    dart run elattar_cli init --foundation source

This cannot work for any reader. `dart run elattar_cli` requires elattar_cli to be a
dependency of their pubspec; it is `publish_to: none` and the repo is private. It is
also the only surface using the `dart run` form — all 14 others use bare `elattar`.

Unlike `/skills`, it carries no badge, no blocker note, no caveat, and it is the first
command a visitor sees. Same class as the deleted `npx skills add` line, on the
highest-traffic surface.

**F27 — BLOCKER.** `.github/workflows/pages.yml` triggers on `push: branches: [main]`
and deploys `example/` to GitHub Pages. One merge to main publishes every finding below
to a public HTTP endpoint simultaneously. Nothing gates it on the licensing decision.

## Licensing — owner decisions required

- **F1** `LICENSE` is `TODO: Add your license here.` Flutter harvests it into the built
  bundle: `example/build/web/assets/NOTICES:2189-2191` publishes that placeholder as the
  project's license notice to every visitor.
- **F2** Three SIL OFL 1.1 fonts redistributed through four channels with zero license
  text anywhere. Inter, Geist Mono, Redaction 35 — all carry intact OFL notices in their
  name tables. `grep -c "SIL Open Font License" NOTICES` -> 0. OFL §2 permits
  redistribution only if each copy carries the notice. Non-compliant today, independent
  of what license the owner picks for their own code. The CLI copies these into user
  projects and writes no license file.
- **F3** `lib/src/components/icon_paths.g.dart` — 714 KB of verbatim Lucide geometry
  (ISC), 1756 glyphs. Header names the license but reproduces neither copyright nor
  permission notice. `icon` is a dependency of `button`, so effectively every install
  carries it.
- **F4** `shaders/orb.frag` — vendored from elevenlabs/ui (MIT), no copyright line, no
  permission notice. Naming MIT is not satisfying MIT.
- **F5** `assets/textures/perlin-noise.png` — byte copy of a file whose original the repo
  cannot even name. 45 KB and trivially regenerable; replacement is cheaper than clearance.
- **F6** The skill ships as a redistributable plugin payload with no license, against
  Decision 005's own "no install route ships until the owner chooses a license."

## Truthfulness

- **F9** 14 `elattar add <name>` commands published with copy buttons; no page tells a
  reader how to obtain `elattar`.
- **F10** `/skills` publishes install routes that Decision 005 says must not ship.
- **F11** Homepage badges `FLUTTER · OPEN SOURCE` while LICENSE is a to-do. This is the
  site's only licensing statement and it is the opposite of true.
- **F12** README's "Planned CLI And Registry" says both are unshipped. Both exist, work,
  and are tested — auditor ran init, add button, add sign-in-flow successfully.
- **F13** `site_shell.dart:78-84` fires a developer toast at public readers from three
  controls: "Pass onOpenGitHub to the public site shell." `onOpenGitHub` is never supplied.
- **F14** `/docs` advertises seven topics; five bounce to the homepage.
- **F15** Six `/components` cards advertise "N references" and land on "Not ported yet".

## Ruling — badged-pending commands are not acceptable publication

The auditor was asked to rule and did: **remove before launch.** Reasoning worth keeping:

- A badge changes the claim, not the outcome. "Pending verification" reads as "probably
  works, not yet blessed" — a copyable code block is an invitation to run it.
- It is worse than npx in one specific way: valid syntax and a valid-looking slug means a
  private-repo failure surfaces as "repository not found", which a reader attributes to
  their own auth, version, or typo. **A plausible broken command costs more than an
  implausible one.**
- The page renders a redistribution invitation directly below its own statement that no
  redistribution grant exists.
- A correct command exists and the site shows the wrong one: the local-path form
  `/plugin marketplace add <absolute-path-to-clone>` works today and is omitted.

Keep the allowlist — it is good engineering. It needs a second predicate: *does this work
for a reader today?* "A human consciously added it" and "it works" are different guarantees.

## Docs

- **F21 — STATUS.md drifted a third time.** Claims last commit `594bb25` (HEAD is
  `cb0cc2a`), claims four Phase H commits (there are five), and claims the tree is NOT
  clean with nine files uncommitted — all nine are in `cb0cc2a`. It was committed inside
  the very commit that invalidated it; line 33's "plus this file" is self-refuting.
- **F22** A blocker listed Open is closed: CI *does* run the CLI suite and registry
  validator (`ci.yml:42-64`, landed in `48c390b`). The row was already false when Phase G
  shipped it and was inherited twice more.
- **F23** `phase-h-skills.md:340` ships a finding marked Open that its own commit fixed.
- **F24** CHANGELOG stops four phases short — zero occurrences of CLI, Shots, Skills,
  plugin, marketplace, or website.
- **F19** All 20 registry `sourceLink` URLs 404. Three would 404 even if public: the shot
  sources do not exist on `main`, which is 17 commits behind. Going public does not fix
  those three; merging to main does.
- **F20** `elattar.dev` is written into every user's config and is not demonstrably live.

## Clean

Registry integrity is immaculate, verified mechanically rather than trusted: 20 items,
every declared sha256 recomputed against source and matching, all source paths exist,
every dependency resolves, no cycles (three-colour DFS), 32 payload files byte-identical
to repo sources, no field drift. The shots parity test was read line-by-line and confirmed
real rather than nominal.

All 47 Markdown files' relative links resolve — zero broken. No fabricated external URLs.
No invented marketing counts anywhere; every count checked matched its manifest.

`skill-install-verification.md` is the most honest document in the program — all four
"Recorded runs" rows genuinely empty, explicitly refusing to fill them.

## Verdict

Not publishable as-is, even once a license is chosen. Every blocker is in the
public-facing layer — license files, website copy, the ledger — not in the system itself.
The engineering is in better shape than the prose.
