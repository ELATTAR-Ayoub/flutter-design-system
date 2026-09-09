# Task 24 — `/agent` gallery rework report

## `AgentFeatures` set

`AgentFeatures.all` (the console's own default; passed explicitly for
clarity at `_IntegratedAgentSurfaceState.build()`). It is the whole point of
the rework — one console, every switch on — and forward-compatible: if a new
flag is ever added, this page picks it up with no edit.

## How history is composed into the page

A rail-in-a-drawer, not a separate panel. `_IntegratedAgentSurface`
(`example/lib/site/pages/agent_gallery_page.dart`) is one `AgentConsole`
wired exactly like `ConsoleWithHistory` in `example/lib/pages/history.dart`
(reused pattern, not reused widget, since that one hard-codes a restricted
default `features` set and this page needed `AgentFeatures.all`):

- `MockConversationStore` (from `history.dart`) seeds the same seven
  conversations `/design-system/components/agent/history` uses.
- `BlurSwitchController` drives the transcript's cross-fade.
- `ChatHistory` (from `agent_history.dart`, exported publicly) is handed to
  `AgentConsole.headerSlot`. It renders a small "Open sidebar" icon button
  inline in the console's own header — that's the trigger — and opens a
  drawer of conversations overlaid on the console's own surface (positioned
  against a `GlobalKey` on the console's root) when pressed.
- `AgentConsole.switchPhase` is now wired to `_switch.phase` (the whole
  `AgentConsole` is rebuilt inside a `ListenableBuilder` on `_switch`, not
  just the header slot — `ConsoleWithHistory` in `history.dart` never passes
  `switchPhase` at all, despite `AgentConsole` supporting it, which is why
  its own doc comment still calls this prop a "KNOWN GAP"; it isn't one
  anymore here).

**What selecting a conversation does:** calls `HistoryCard.onOpen` →
`BlurSwitchController.switchTo(id)`, which (a) closes the drawer immediately,
(b) blurs the console's transcript out (`SwitchPhase.out`), (c) calls
`store.open(id)` mid-blur (updates `MockConversationStore.activeId`), then
(d) blurs the transcript back in (`SwitchPhase.blurIn` → `idle`).

**What it does not do:** it does not change which turns the transcript
shows. `MockTransport` (the console's actual conversation engine) has no
concept of the history store's conversations — there is one scripted
transport, one transcript, for the whole page, matching every other live
console on the site. Swapping in a second, independent transport per
conversation was out of scope and would have made the console's own
scripted demo (typing → transcript turn, the test the task calls out by
name) fragile to which conversation happens to be "active." The observable,
real change on selection is the drawer closing and the transcript's own
`BlurSwitch` leaving `SwitchPhase.idle` — asserted directly in
`agent_gallery_test.dart`.

**Test note:** `ChatHistory`'s drawer paints through an `OverlayPortal`
positioned from a `surfaceKey` rect (`agent_history.dart`'s
`_surfaceRect`). At this page's position inside the outer
`SingleChildScrollView`, that rect resolves off the visible viewport, so a
simulated pointer `tap()` on a row's own screen position does not reliably
hit it in `flutter_test`. Reproduced identically with the untouched
`ConsoleWithHistory` demo from `history.dart` in isolation, so this is a
pre-existing defect in `lib/src/components/ui/agent_history.dart`, not
something this page introduced — out of scope to fix here (`lib/src/` is
off-limits for this task). The test calls the row's own `onOpen` callback
directly instead (the same call a working tap would make), which exercises
every step after the pointer event for real.

## What was deleted

- The whole `_SupportingSurfaces` / `_SurfaceCard` section ("Try the
  surfaces around it"): the History card (`HistoryListDemo`), the Voice
  card (`VoiceDemo`), the Launcher card (`LauncherDemo`), and the
  Transcript/Questionnaire card (`QuestionnaireDemo`).
- The launcher was **not** kept — it does not "actually launch the same
  console/history" per the task's bar for keeping it; it opened its own,
  separate `MockTransport`/`AgentConsole` instance in a dialog, which is a
  second demo, not part of the one integrated surface.
- Hero copy and the "Live agent" section blurb were trimmed to stop
  claiming the microphone or voice surfaces (see gap below); the hero and
  its two buttons, and the component-reference block, are otherwise
  unchanged. The Documentation button's `componentDoc('agent-core').route`
  wiring was not touched.

## `VoiceDemo` / `QuestionnaireDemo`

Both became unused outside their own defining files once the supporting-
surfaces section was removed (confirmed by a repo-wide search of
`example/`). Restored to private:

- `example/lib/pages/agent_voice.dart`: `VoiceDemo` → `_VoiceDemo`.
- `example/lib/pages/transcript.dart`: `QuestionnaireDemo` →
  `_QuestionnaireDemo`.

Both constructors also dropped their now-dead `{super.key}` parameter
(private classes with no caller passing a key trip
`unused_element_parameter`, which `flutter analyze` flagged as a new
warning until removed).

## Concerns / residual issues

1. **The owner's #1 complaint — "audio next to send" — is not actually
   fixed by this page**, and could not be from `example/` alone.
   `AgentFeatures.microphone` is set (as part of `AgentFeatures.all`), but
   `agent_console.dart`'s own doc comment ("Divergences, by construction")
   already documents that this Flutter port honours `microphone`/`speech`
   only as flags — Flutter has no Web Speech API equivalent, and (confirmed
   by grep) `AgentComposer.micControl` — the exact slot the task's brief
   said is already wired — is never populated anywhere under `lib/`. No mic
   renders next to Send regardless of the flag, today. This is a
   pre-existing `lib/src/blocks/agent_console/agent_console.dart` gap, and
   fixing it is out of scope under this task's "never edit `lib/src/`"
   constraint. Flagged as a separate background task
   (`task_e8277992`, "Wire AgentFeatures.microphone into AgentConsole's
   composer"). The gallery page's own doc comment and the
   `agent_gallery_test.dart` assertion both pin this honestly and will
   start passing the moment that fix lands, with no page change required.
2. The history drawer's overlay-positioning defect (above) is the same
   kind of pre-existing, out-of-scope issue — worth folding into the same
   follow-up or a sibling one if it turns out to affect real usage (not
   just this test harness) once someone checks it in a running app.
