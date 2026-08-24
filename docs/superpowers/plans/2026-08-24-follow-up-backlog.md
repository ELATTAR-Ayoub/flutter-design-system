# Follow-up backlog, opened 2026-08-24

Everything below was found while reshaping the component docs and was deliberately
NOT fixed in that pass, either because it is out of that plan's scope or because
fixing it needs a decision this session was not entitled to make.

Nothing here is a blocker for the current work. Every item is recorded rather than
silently closed, which is the point: several of these were discovered only because
a check that looked clean turned out to be unable to fail.

Status key: OPEN, needs a decision from the repository owner. READY, scoped and
safe for a worker to pick up. LATENT, harmless today, breaks under a stated
future condition.

---

## Needs the owner's decision

### 1. Does the no-em-dash rule cover quotations? OPEN

The house rule is that a spaced em dash never appears in this project's writing.
A bulk sweep applied it to `example/lib` and rewrote rendered Dart strings that are
verbatim transcriptions of the reference site's own copy. Shortening `" X "` to
`": "` moved word-wrap points, which changed rendered column heights and broke
`vertical_parity_probe`, `wrap_parity_probe` and two exact-string assertions in
`selects_page`. Ten files were repaired by restoring the dash in RENDERED strings
while keeping the replacement in COMMENTS.

That resolution encodes an assumption: the rule governs our prose, not our
quotation of someone else's. Confirm or overturn it. If overturned, the parity
probes and the assertions they protect have to change with it, since they assert
the reference's wording.

### 2. Sweep `lib/src` for em dashes? OPEN

Validated counts, whole repo, `.dart .md .json .yaml .yml .txt`:

| Area | Spaced em dashes |
|---|---|
| `lib/src` shipped source | 3836 |
| `docs/superpowers` internal | 2545 |
| `registry/generated` | 1273 |
| `example/test` | 876 |
| root `test/` | ~700 |
| `example/lib` | 304 |
| `packages/` CLI | 16 |
| **Total** | **9913** |

The `example/lib` sweep is the one that broke three test files, and `lib/src` is
twelve times larger. `registry/generated` should be regenerated, never edited.
Decide scope and timing. Doing it late in a release is how the parity probes broke.

### 3. Fidelity audit of `components_docs` rendered strings? OPEN

The sweep rewrote rendered strings in the component doc pages exactly as it did in
the legacy pages. It broke nothing there only because those pages have no parity
oracle: nothing compares their rendered output against a reference. So some pages
now carry a paraphrase of the reference's copy where the standard is to carry its
words, and no test can detect it. Auditing means diffing each page's prose against
its counterpart page. Reverting blind would be guessing.

### 4. `RegistryKind.shot` in the CLI. OPEN

`registry/shots/` and all three manifests were deleted. `packages/elattar_cli`
still carries the capability: `RegistryKind.shot`, the `@app/shots/x/y.dart` to
`lib/shots/x/y.dart` mapping in `target_mapper.dart`, and a comment in
`import_transformer.dart`. Nothing is broken.

Recommendation is to KEEP it. The objection was to the Shots documentation pages,
not to the CLI installing app-level source into a consumer's `lib/`, which is the
only thing the `@app/` prefix exists for.

Note when deciding: `shot_install_test.dart` passing is weak evidence. It builds
its own scratch registry, so it covers the installer unit, not the end-to-end path
now that the shipped manifests are gone.

UPDATE, later on 2026-08-24. The shots deletion had ALSO removed `'shots'` from
the folder list in `RegistryGenerator._manifestFiles()`
(`tool/registry_builder/lib/generator.dart`), uncommitted. That went beyond
deleting the manifests: it removed the generator's ability to discover this kind
of manifest at all, and it broke `registry_builder_test.dart`, whose fixture is
synthetic and self-contained and was never the problem.

Restored to HEAD. The loop's very next line is `if (!directory.existsSync())
continue;`, so listing a folder that does not exist costs nothing. The removal
bought no cleanliness and silently pre-decided this open question by making the
capability unusable before anyone chose to remove it.

So the capability is now intact end to end and the decision below is still open
and still reversible. `flutter test test/registry_builder_test.dart` reports
`00:00 +9: All tests passed!` with the line restored.

---

## Ready to pick up

### 5. Three Sections pages do not exist. READY

`docs_pages/catalog.dart` declares `docsTypesetRoute`, `docsRegistryRoute` and
`docsChangelogRoute`. No page file backs any of them. The sidebar is meant to list
nine entries: Introduction, Components, Installation, Theming, CLI, Typeset,
Skills, Registry, Changelog. Six are reachable or being wired. These three need
authoring. Never ship a sidebar link that navigates to a blank screen.

### 6. Section-order assertions. CLOSED, was never a real gap

RETRACTED on 2026-08-24. This item originally read "missing from 21 of 35 docs
tests". That was wrong when it was written.

Recounted across all 35 page tests:

| Mechanism | Files |
|---|---|
| `widgetList<ElSection>` | 23 |
| ordered `anchorKey` loop | 10 |
| heading text plus `getTopLeft` dy ordering | 2 (alert_dialog, badge) |
| no order assertion at all | 0 |

35 of 35 assert section order. The original "only 14" came from grepping for
`widgetList<ElSection>` alone, which is one of three mechanisms in use, so the
absence of the other two forms was reported as absence of the property. It was
also stale by the time it was recorded, since several tests were converted during
the day's work.

Kept in this file rather than deleted, because a retracted item is evidence and a
deleted one is not. It is the seventh instance of the same failure: a check that
counted the form its author had in mind and reported a verdict on the rest.

### 7. Sections that no test touches. READY, but RE-DERIVE FIRST

The claim is that `checkbox` defines 17 sections and `toaster` 6 that no assertion
references. It has NOT been rechecked since item 6 was found wrong, and it was
produced by the same session with the same method on the same day.

Do not work this item from the numbers above. Re-derive them first, and count
every mechanism a test might use to reference a section, not just the one that
comes to mind. If the gap is real, fix it. If it is not, retract it here the way
item 6 was retracted.

### 8. Legacy flat page files still serve live routes. READY

`button_card_pages.dart`, `input_select_pages.dart` and `dialog_page.dart` still
back live routes, and 28 files remain under `example/lib/pages/`. They predate the
`components_docs` structure.

### 9. No mobile drawer below the desktop breakpoint. READY

The docs shell has no navigation affordance on a phone. Related: several component
pages had genuine `RenderFlex` overflows at 390x844 from demo `Row`s authored
without narrow-width handling, against roughly 298px of usable width inside the
panel chrome. Those specific overflows are being fixed, but narrow-width demo
content has no guard, so the next demo authored will reintroduce it.

### 10. About 77 pre-existing format-dirty files. READY

From a Dart formatter version change, unrelated to any current work. Keeps CI red.
Should be one mechanical commit touching nothing else.

### 11. 35 components have no documentation page at all. READY

12 agent-family, 4 charts, plus `attachment`, `bubble`, `message`,
`message_scroller`, `questionnaire`, `voice`, `el_safe_area`, `icon_swap`.
Out of scope for the parity plan, which reshapes pages that already exist.

### 16. Two strings in `buttons.dart` still carry the sweep's colon. READY

Found while repairing the sweep damage on 2026-08-24, and left deliberately.

`example/test/buttons_page_test.dart` was ITSELF swept and has uncommitted
changes: its assertions now read `:` where they previously read the em dash. So
restoring `buttons.dart` fully to HEAD broke two tests that had been passing,
because source and test had been swept CONSISTENTLY and therefore still matched
each other.

The repair worker could not edit tests, so it left two strings in `buttons.dart`
as `:` to match: the `_SizeUse` separator and the `#states` description. Net
effect is two fewer restorations than a pure HEAD diff would give.

This is internally consistent and green. It is NOT faithful to the reference,
which is the standard those strings exist to meet. Resolving it means restoring
both the source strings AND the corresponding test assertions together, and it
depends on decision 1 above.

Related and also stale: the doc comment above `_sizeUse` in `buttons.dart` still
describes the separator as "a literal space, U+2014, and another space", which is
no longer what the code does.

---

## Latent, do not fix pre-emptively

### 12. `button` on 'States' is a latent `find.text` ambiguity. LATENT

`find.text` on a section title matches twice at viewport widths of 1280 and above,
because the ON THIS PAGE rail renders and repeats every title. `button`'s 'States'
assertion resolves to one hit today by luck of what is on the page. It becomes a
failure the moment a 'States' sub-heading is added. Fix by scoping the finder with
`find.descendant`, keeping exactly-one, never loosening to `findsWidgets`.

### 13. `nav-menu-specimen` and `menubar-specimen` hardcode a key in `build()`. LATENT

Safe only while each is mounted exactly once. Parameterising them was ATTEMPTED and
correctly reverted: `flutter analyze` reported `unused_element_parameter`, because
with a single mount the parameter is dead API. The constraint is now stated in a
doc comment on each, naming `_ContextMenuSpecimen` and `_HoverCardSpecimen` as the
pattern to copy.

Fix when a second mount appears, not before. A blanket "parameterise every
hardcoded key" rule would add unused surface and lint warnings at many of the 196
sites where the pattern appears but cannot fail.

### 14. `showcase_app.dart` `_DestinationNavigation` mounts twice with hardcoded keys. LATENT

Keys `showcase-compact-dock`, `showcase-destination-pill-group`,
`showcase-destination-pill`. The two mounts are `compact: true` in a positioned
bottom dock and `compact: false` inline, which READ as mutually exclusive by
breakpoint. Reading as exclusive is not the same as being exclusive. Confirm it
rather than assume it: if a future layout ever renders both at once, it breaks
silently. Fails no test today.

### 15. Testing a settled spinner: use reduced motion, never TickerMode. READY

Recorded as a convention, not a defect. `ElSpinner` calls
`AnimationController.repeat()`, so `pumpAndSettle()` on a page containing one
never terminates.

There are two correct answers and both already exist in this codebase:

1. Bounded pumping. `await tester.pump()` then `await tester.pump(const
   Duration(milliseconds: 100))`. Precedent: `icon_test.dart`, the test named
   "spinner rotates under normal motion", which also reads
   `RotationTransition.turns.value` before and after to prove the ticker
   advanced rather than merely existed.
2. If a test genuinely needs a SETTLED spinner, wrap in
   `MediaQuery(data: ...copyWith(disableAnimations: true))`. That exercises the
   real reduced-motion path a user gets: `elAnimationDuration` in
   `theme_scope.dart:332` returns `Duration.zero`, and `ElSpinner` reads exactly
   that to still itself, stopping at 0 degrees upright because that is the
   resting style the reference holds.

Never use `TickerMode(enabled: false)`, a zero duration, a static placeholder, or
a conditional that swaps the spinner out under test. All four freeze the rotation
wherever it happens to be, which is not the same frame the component's own
reduced-motion path produces, and all four locally reimplement a capability the
component already has.

This was attempted once on 2026-08-24 and reverted.

---

## Why several of these were nearly missed

Recorded because the pattern repeated all day and the traps section of the parity
plan now carries 21 entries drawn from it.

Six separate checks returned a confident verdict on input they could not read.
An em-dash grep using a shell escape that did not expand matched nothing and was
quoted as "0 em dashes" four times. A `find -newermt` comparison against a
timestamp later than the current clock could not match any file and was quoted as
proof nothing had changed. A test run piped through `tail -40` discarded every
early failure and was reported as a green suite. An anchor cross-reference skipped
a file that does not use the attribute it keys on and still reported "0 orphans".
A `find.text` audit could not see `find.text(variable)` and called a
currently-failing file clean. A scan for uncollected tests required the wrong
import and called five valid files defective.

The structural fix is in the traps file: three outcomes, never two, and the third
one is loud. Report the skipped count next to the pass count, and treat
pass + fail < total as a defect in the check itself. Before trusting a clean
result, show the check failing on a case it must catch.
