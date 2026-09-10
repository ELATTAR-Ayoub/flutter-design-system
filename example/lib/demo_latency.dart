/// The fake round trips the documentation's live specimens wait on.
///
/// Every value here is a latency the *reference* invented so a demo could be
/// seen working: a `setTimeout` in a React example, a mock transport pacing
/// itself so a stream looks like thinking. They are transcribed whole from
/// those call sites and nothing in this system chooses or tunes them.
///
/// ## Why they live in one file
///
/// They are not motion. [MotionDurations] answers "how long should this
/// transition take", and every answer there is a design decision this system
/// owns. "How long does a pretend server take to reply" is not that question,
/// and putting it beside `MotionDurations.fast` would invite someone to reuse
/// a network delay as a transition, or to retune a transition and silently
/// change how long a demo appears to load.
///
/// They were previously six private constants scattered across six pages,
/// each carrying its own comment excusing itself from the token guard. Several
/// evaded the guard only because their `Duration(` happened to be split
/// across two lines; reformatting one would have failed the build for no
/// reason a reader could see. One named home, declared once as a source of
/// truth, replaces six invisible exceptions.
library;

/// The data table's reload, `RELOAD_MS` in the reference's own demo.
const Duration demoReloadWait = Duration(milliseconds: 1100);

/// The alert dialog's destructive action, `setTimeout(resolve, 1400)`.
const Duration demoDialogLatency = Duration(milliseconds: 1400);

/// The toast promise's settle, so a reader sees pending before resolved.
const Duration demoPromiseLatency = Duration(milliseconds: 1800);

/// The account form's submit, and the transcript composer's, which the
/// reference gives the same 900ms.
const Duration demoAccountLatency = Duration(milliseconds: 900);

/// The server-error form's submit, shorter so the failure reads as prompt
/// rather than as a hang.
const Duration demoServerLatency = Duration(milliseconds: 800);
