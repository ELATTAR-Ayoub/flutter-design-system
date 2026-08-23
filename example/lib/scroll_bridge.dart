/// The capture rig's scroll seam, `window.__dsScrollTo`, `__dsScrollY` and
/// `__dsScrollMax`.
///
/// **Why this exists.** The rig photographs a page taller than the viewport in
/// passes and stitches them. On the web app it drives that with `window.scrollY`
///: ground truth, read back after every move, so a pass that clamps short at
/// the bottom is *known* to have clamped and by how much. Flutter web has no
/// document scroll: the reading column is a [ScrollController] inside a canvas,
/// and `window.scrollY` is 0 forever.
///
/// The obvious substitute: infer the offset by matching the overlap between
/// two shots: cannot work here, and the reason is a design decision three
/// files away. `--body-glow` is `background-attachment: fixed`, so [DsPageGlow]
/// sits at the bottom of the shell's [Stack], **outside both scroll views**.
/// Scrolled content is therefore never a pure translation: every pass repaints
/// the same fixed gradient behind different content, so the overlap at the
/// *true* offset is never pixel-identical and a sum-of-absolute-differences
/// matcher has no zero to find. On the motion page it settled on a wrong 810
/// with SAD 2661. A better matcher would not fix it; there is nothing to match.
///
/// So the rig drives and verifies scrolling through this seam instead, exactly
/// as it does through `window.scrollY` on the web side. Three functions, no
/// query-param gate: always installed in the gallery app, because a capture
/// tool that has to ask for the instrumentation is a capture tool that will one
/// day forget.
///
/// **Web builds only.** The implementation imports `dart:js_interop`, which
/// does not exist on the VM, so a conditional export picks a no-op stub
/// everywhere else: without it every widget test that mounts `DocsShell`
/// would fail to compile.
library;

export 'scroll_bridge_stub.dart'
    if (dart.library.js_interop) 'scroll_bridge_web.dart';
