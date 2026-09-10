/// The VS Code **Dark Plus** palette, as `react-syntax-highlighter` writes it.
///
/// A third-party syntax theme, not tokens of this system: `vscDarkPlus`
/// arrives as an inline style object, so it beats every class on the
/// element — the `bg-muted` on the wrapper never reaches the `<pre>`, and
/// `--foreground` never reaches its text. Deriving these from this system's
/// theme would change what the reference renders, which is the one thing the
/// port may not do. Every value below was read off the live page, and is
/// declared a token source in its own right in the guard's `_exemptDirs` —
/// see test/token_guard_test.dart — for exactly that reason: it is the vendored
/// theme's own palette, transcribed whole, read as a token by nothing outside
/// [agent_markdown.dart].
library;

import 'package:flutter/painting.dart' show Color;

/// The vendored VS Code Dark Plus theme [AgentCodeBlock][] and its tokeniser
/// read colour and metrics from.
///
/// [AgentCodeBlock]: agent_markdown.dart
class PrismPalette {
  const PrismPalette._();

  /// `pre[class*="language-"] { background: #1e1e1e }`.
  static const Color ground = Color(0xFF1E1E1E);

  /// The theme's plain-text colour.
  static const Color plain = Color(0xFFD4D4D4);

  static const Color keyword = Color(0xFF569CD6);
  static const Color string = Color(0xFFCE9178);
  static const Color number = Color(0xFFB5CEA8);
  static const Color function = Color(0xFFDCDCAA);
  static const Color comment = Color(0xFF6A9955);
  static const Color type = Color(0xFF4EC9B0);

  /// `padding: 1em` at the theme's own 13px.
  static const double padding = 13;

  /// `margin: .5em 0` — real vertical space in the block, above and below.
  static const double margin = 6.5;

  /// The theme's `font-size: 13px` over Preflight's 1.5 — 19.5px per line, and
  /// what actually sets the height of the body.
  static const double lineHeight = 19.5;
}
