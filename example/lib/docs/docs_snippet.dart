// example/lib/docs/docs_snippet.dart
/// The only code renderer in the documentation.
///
/// The docs used to carry their own tokenizer. The agent family already
/// shipped the real VS Code Dark Plus palette — `ElAgentCodeBlock` over
/// `ElPrismPalette` — so there is one syntax theme on the site and it is that
/// one. A second one is a second thing to keep true.
///
/// DEVIATION from the task-2 brief, ruled by the repository owner: the brief
/// had this widget render through `ElAgentCodeBlock` itself. That widget's
/// `normalise` looks the language up in `elLanguageAliases`
/// (`lib/src/components/agent_markdown.dart`), which registers bash, css,
/// js/javascript, json, jsx, md/markdown, py/python, sh/shell, sql, ts/tsx/
/// typescript — and no `dart`. Since `dart` is the default language and
/// nearly all documentation code, routing through `ElAgentCodeBlock` would
/// render every Dart snippet flat and unhighlighted. This widget instead
/// paints its own header strip and body — mirroring `ElAgentCodeBlock.build`
/// structurally — over tokens from `docsTokenise` (`docs_syntax.dart`), which
/// adds the missing Dart grammar and still routes every other language
/// through the package's own `elTokenise`. The palette is unchanged:
/// `ElPrismPalette`, the same VS Code Dark Plus colours `ElAgentCodeBlock`
/// uses, so the site still carries exactly one syntax theme.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import 'docs_copy_button.dart';
import 'docs_syntax.dart';

class DocsSnippet extends StatelessWidget {
  const DocsSnippet({
    super.key,
    required this.code,
    this.language = 'dart',
    this.maxHeight,
  });

  /// The source, verbatim. What is displayed and what is copied are the same
  /// string, read from the same field.
  final String code;

  /// A language `docsTokenise` recognises. An unrecognised one renders
  /// un-highlighted rather than failing.
  final String language;

  /// When set, the body is clipped to this height with an expansion control.
  /// Null leaves the block at its natural height.
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    final Widget block = _DocsSnippetBody(code: code, language: language);
    final double? cap = maxHeight;

    if (cap == null) return block;
    return DocsSnippetOverflow(maxHeight: cap, child: block);
  }
}

/// The header strip plus the highlighted body, mirroring
/// `ElAgentCodeBlock.build`'s known-language branch structurally: a
/// [ColoredBox] on `theme.muted`, a bottom-bordered language strip, then the
/// body on [ElPrismPalette.ground].
class _DocsSnippetBody extends StatelessWidget {
  const _DocsSnippetBody({required this.code, required this.language});

  final String code;
  final String language;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final String label = ElAgentCodeBlock.normalise(language) ?? language;
    final List<List<ElCodeToken>> lines = docsTokenise(code, language);
    final TextStyle base = ElText.styleOf(
      context,
      ElType.code,
      color: ElPrismPalette.plain,
    );

    return ColoredBox(
      color: theme.muted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            key: const ValueKey<String>('docs-snippet-strip'),
            padding: EdgeInsets.symmetric(
              horizontal: ElAgentCodeBlock.stripPadX,
              vertical: ElAgentCodeBlock.stripPadY,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.border,
                  width: ElWidths.hairline,
                ),
              ),
            ),
            // The strip's own bounds fix the row's height — governed by the
            // language label alone, exactly as before the control moved in
            // here — and the control rides a Positioned confined to *this*
            // Container rather than the whole block, so it reads as part of
            // the strip instead of floating over it. `clipBehavior: Clip.none`
            // lets its ~32px rung overflow the ~30px strip by under a pixel a
            // side without being cut, and without the strip growing to fit it.
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElText(
                    label,
                    ElType.caption,
                    color: theme.mutedForeground,
                  ),
                ),
                Positioned(
                  top: el(0),
                  bottom: el(0),
                  right: el(0),
                  child: Center(child: DocsCopyButton(text: code)),
                ),
              ],
            ),
          ),
          Container(
            key: const ValueKey<String>('docs-snippet-code-body'),
            color: ElPrismPalette.ground,
            margin: const EdgeInsets.symmetric(
              vertical: ElPrismPalette.margin,
            ),
            padding: const EdgeInsets.all(ElPrismPalette.padding),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (final List<ElCodeToken> line in lines)
                    SizedBox(
                      height: ElPrismPalette.lineHeight,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            children: <InlineSpan>[
                              for (final ElCodeToken token in line)
                                TextSpan(
                                  text: token.text,
                                  style: base.copyWith(color: token.color),
                                ),
                            ],
                          ),
                          style: base,
                          softWrap: false,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Clips [child] to [maxHeight] and offers to unfold it.
///
/// Separate from [DocsSnippet] because the showcase caps its code pane at the
/// same 640 the preview uses, while a Usage snippet is never capped — the same
/// clipping behaviour, two different callers.
class DocsSnippetOverflow extends StatefulWidget {
  const DocsSnippetOverflow({
    super.key,
    required this.maxHeight,
    required this.child,
    this.showMoreLabel = 'Show more',
    this.showLessLabel = 'Show less',
  });

  final double maxHeight;
  final Widget child;
  final String showMoreLabel;
  final String showLessLabel;

  @override
  State<DocsSnippetOverflow> createState() => _DocsSnippetOverflowState();
}

class _DocsSnippetOverflowState extends State<DocsSnippetOverflow> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (_open)
          widget.child
        else
          ClipRect(
            child: SizedBox(
              height: widget.maxHeight,
              child: OverflowBox(
                alignment: Alignment.topLeft,
                maxHeight: double.infinity,
                child: widget.child,
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(top: el(2)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ElButton(
              variant: ElButtonVariant.ghost,
              size: ElButtonSize.sm,
              onPressed: () => setState(() => _open = !_open),
              child: Text(
                _open ? widget.showLessLabel : widget.showMoreLabel,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
