/// `components/agent/parts/markdown.tsx` + `parts/code-block.tsx` — formatted
/// text, in both directions.
///
/// The model writes markdown — bold headings, numbered findings, bullet lists,
/// fenced code, the occasional link — and rendering it as plain text throws all
/// of that away, so a finance answer arrives as a wall of asterisks. The user's
/// own messages go through the same renderer, because someone pasting a code
/// block or a bulleted list into the composer means it the same way the model
/// does, and showing it back to them as literal backticks looks like a bug.
///
/// The reference renders to **React elements** rather than to an HTML string,
/// and says why: model output is untrusted input, and `dangerouslySetInnerHTML`
/// on untrusted input is an XSS hole a sanitiser then has to be perfect to
/// close. This port inherits that property for free — a Flutter widget tree has
/// no HTML parser in the path at all — and keeps the other half of the
/// contract, which is the part that actually needs porting: [elSafeHref] refuses
/// every scheme but `http:`/`https:` and the two document-relative forms, so a
/// `javascript:` link keeps its label and loses its link.
///
/// It covers the subset that actually gets written. Anything it does not know
/// falls through as text, which is the correct failure: a stray backtick reads
/// as a stray backtick, never as a broken renderer.
///
/// ## What the port had to decide
///
///  * **`leading-relaxed` is the root's, and it reaches everything.** The
///    wrapper is `type-body space-y-2 leading-relaxed break-words`, measured
///    15px/**24.375px** — not `.type-body`'s own 24. Every block box under it
///    inherits that strut, which is why the code block's language strip is
///    41.38px tall rather than the 27 its 10.5px label would suggest. See
///    [_MdType.body] and [ElAgentCodeBlock].
///  * **`space-y-2` is 8px of *margin-bottom* on all but the last child**, not
///    a flex gap — Tailwind v4 compiles it that way, and the probe reads
///    `m=0px 0px 8px` on every block but the last.
///  * **A table's row heights come out of `border-collapse`.** The shared 1px
///    rule between two rows is split half above and half below, so the header
///    row measures 27.5 (27 + one half-border) and a body row 36.5 (35.5 + two
///    halves), with the last row 36. Reproduced by a Flutter [Table] with a
///    1px `horizontalInside` border and nothing else.
///  * **The Prism body is not on this system's tokens.**
///    `react-syntax-highlighter` writes `vscDarkPlus` as *inline* styles, so
///    the vendored theme beats every class on the element. Measured live:
///    `#1e1e1e` ground, `#d4d4d4` ink, 13px padding, 6.5px vertical margin,
///    19.5px per line. Those literals carry `allow-hardcoded:` with the reason
///    that they are a third-party syntax theme rather than tokens of this
///    system — the same footing the reference's own stand-in photograph gets.
///
/// ## Recorded divergences
///
///  1. **A table does not scroll horizontally.** The reference wraps it in
///     `overflow-x-auto`; a Flutter [Table] shrink-wraps to its box instead,
///     which is what CSS `table-layout: auto` does anyway until the min-content
///     width is exceeded. No table on the transcript page reaches that width in
///     either the 1030px panel or the 499px `MarkdownCase` column.
///  2. **Column widths are an equal split of the leftover, not Chrome's
///     content-proportional one.** Both engines size to content first; they
///     part company only over how the *surplus* is shared. Every cell in the
///     corpus is one line at either width, so no height moves.
///  3. **`<pre>` does scroll**, because `white-space: pre` gives it no choice.
library;

import 'package:flutter/widgets.dart';

import '../foundation/spacing.dart';
import '../foundation/theme.dart';
import '../foundation/typography.dart';
import '../text_layout.dart';
import '../theme_scope.dart';

/* ── Type ────────────────────────────────────────────────────────────────── */

/// The `.type-*` rungs this renderer resolves, at the leading its root sets.
///
/// Declared here rather than in `foundation/typography.dart` because the
/// markdown body is the one site in the corpus that wears `leading-relaxed`
/// over `.type-body`; every ratio below is a named constant so no line-height
/// literal reaches a `height:` argument.
class _MdType {
  const _MdType._();

  /// `leading-relaxed` — the root's own, inherited by every block under it.
  static const double relaxed = 1.625;

  /// `type-body leading-relaxed` — 15px / 24.375px / 400.
  static final ElTypeSpec body = ElTypeSpec(
    family: ElFonts.sans,
    size: ElType.body.size,
    height: relaxed,
    wght: 400,
  );

  /// `<strong className="font-semibold">` inside the body.
  static final ElTypeSpec strong = ElTypeSpec(
    family: ElFonts.sans,
    size: ElType.body.size,
    height: relaxed,
    wght: 600,
  );

  /// `<em className="italic">` inside the body.
  static final ElTypeSpec emphasis = ElTypeSpec(
    family: ElFonts.sans,
    size: ElType.body.size,
    height: relaxed,
    wght: 400,
    fontStyle: FontStyle.italic,
  );

  /// A blockquote — the body face, italic, on `--muted-foreground`.
  static final ElTypeSpec quote = emphasis;

  /// `type-small` inside a table cell, with tabular figures for the
  /// right-aligned (numeric by convention) columns.
  static final ElTypeSpec cellTabular = ElTypeSpec(
    family: ElFonts.sans,
    size: ElType.small.size,
    height: ElType.small.height,
    wght: 400,
    tabular: true,
  );
}

/// `safeHref` — the only schemes a link may safely carry.
///
/// `javascript:` is the reason this exists. A root-relative path and a fragment
/// pass through untouched; everything else has to parse as a URL and land on
/// `http:` or `https:`. A refused destination returns null, and the caller keeps
/// the label and drops the link rather than dropping the text.
String? elSafeHref(String raw) {
  final String href = raw.trim();
  if (href.startsWith('/') || href.startsWith('#')) return href;
  final Uri? url = Uri.tryParse(href);
  if (url == null || !url.hasScheme) return null;
  return url.scheme == 'http' || url.scheme == 'https' ? url.toString() : null;
}

/* ── The parser ──────────────────────────────────────────────────────────── */

/// One `<li>` of an ordered list, carrying the number its author wrote.
///
/// The number is captured, not discarded. A blank line — or a bullet sub-list
/// under an item, which the model writes constantly — closes the open list, so
/// a run of findings becomes several one-item lists and every one of them
/// restarts at 1. Carrying the author's own number onto the item means the
/// sequence survives however the blocks split.
@immutable
class ElMarkdownOrderedItem {
  const ElMarkdownOrderedItem(this.n, this.text);

  final int n;
  final String text;
}

/// Column alignment, from the delimiter row's colons.
enum ElMarkdownAlign { left, right, center }

/// The block vocabulary `parse()` produces.
sealed class ElMarkdownBlock {
  const ElMarkdownBlock();
}

class ElMarkdownParagraph extends ElMarkdownBlock {
  ElMarkdownParagraph(this.lines);
  final List<String> lines;
}

class ElMarkdownBullets extends ElMarkdownBlock {
  ElMarkdownBullets(this.items);
  final List<String> items;
}

class ElMarkdownNumbers extends ElMarkdownBlock {
  ElMarkdownNumbers(this.items);
  final List<ElMarkdownOrderedItem> items;
}

class ElMarkdownHeading extends ElMarkdownBlock {
  const ElMarkdownHeading(this.level, this.text);
  final int level;
  final String text;
}

class ElMarkdownFence extends ElMarkdownBlock {
  const ElMarkdownFence(this.lang, this.lines);
  final String lang;
  final List<String> lines;
}

class ElMarkdownQuote extends ElMarkdownBlock {
  ElMarkdownQuote(this.lines);
  final List<String> lines;
}

class ElMarkdownTable extends ElMarkdownBlock {
  const ElMarkdownTable(this.head, this.rows, this.align);
  final List<String> head;
  final List<List<String>> rows;
  final List<ElMarkdownAlign> align;
}

final RegExp _bullet = RegExp(r'^\s*[-*•]\s+(.*)$');
final RegExp _number = RegExp(r'^\s*(\d+)[.)]\s+(.*)$');
final RegExp _heading = RegExp(r'^\s*(#{1,4})\s+(.*)$');
final RegExp _fence = RegExp(r'^\s*```(\w*)\s*$');
final RegExp _quote = RegExp(r'^\s*>\s?(.*)$');

/// A table is only a table if the second line is the delimiter.
///
/// That check is what keeps a sentence containing a pipe from being promoted
/// into a one-column table, and it is the same rule GitHub uses.
final RegExp _tableDelimiter = RegExp(
  r'^\s*\|?\s*:?-{1,}:?\s*(\|\s*:?-{1,}:?\s*)*\|?\s*$',
);

/// Split a row on unescaped pipes, dropping the leading and trailing ones.
List<String> _cells(String line) {
  final String trimmed = line
      .trim()
      .replaceFirst(RegExp(r'^\|'), '')
      .replaceFirst(RegExp(r'\|$'), '');
  return trimmed
      .split(RegExp(r'(?<!\\)\|'))
      .map((String c) => c.trim().replaceAll(r'\|', '|'))
      .toList(growable: false);
}

List<ElMarkdownAlign> _alignments(String delimiter) => _cells(delimiter)
    .map((String c) {
      final bool left = c.startsWith(':');
      final bool right = c.endsWith(':');
      if (left && right) return ElMarkdownAlign.center;
      if (right) return ElMarkdownAlign.right;
      return ElMarkdownAlign.left;
    })
    .toList(growable: false);

/// Group lines into blocks. A blank line closes whatever is open.
List<ElMarkdownBlock> elParseMarkdown(String source) {
  final List<ElMarkdownBlock> blocks = <ElMarkdownBlock>[];
  ElMarkdownBlock? open;
  void close() {
    if (open != null) blocks.add(open!);
    open = null;
  }

  final List<String> lines = source.split('\n');

  for (int i = 0; i < lines.length; i += 1) {
    final String line = lines[i];

    // Fenced code is consumed whole and never scanned for other syntax — that
    // is the entire point of a fence, and a `# ` inside one is a comment, not a
    // heading. An unterminated fence runs to the end rather than being
    // abandoned: the model streams, so the closing fence may simply not have
    // arrived yet, and dropping the block would make code flicker in and out.
    final RegExpMatch? fence = _fence.firstMatch(line);
    if (fence != null) {
      close();
      final List<String> body = <String>[];
      i += 1;
      while (i < lines.length && !_fence.hasMatch(lines[i])) {
        body.add(lines[i]);
        i += 1;
      }
      blocks.add(ElMarkdownFence(fence[1] ?? '', body));
      continue;
    }

    if (line.trim().isEmpty) {
      close();
      continue;
    }

    final RegExpMatch? heading = _heading.firstMatch(line);
    if (heading != null) {
      close();
      blocks.add(ElMarkdownHeading(heading[1]!.length, heading[2]!));
      continue;
    }

    // A header row plus a delimiter row, then every following row until the
    // block ends. Consumed whole here rather than accumulated in `open`,
    // because a table is the one block whose first two lines decide whether it
    // is a block at all.
    if (line.contains('|') &&
        i + 1 < lines.length &&
        _tableDelimiter.hasMatch(lines[i + 1])) {
      close();
      final List<String> head = _cells(line);
      final List<ElMarkdownAlign> align = _alignments(lines[i + 1]);
      final List<List<String>> rows = <List<String>>[];
      i += 2;
      while (i < lines.length &&
          lines[i].trim().isNotEmpty &&
          lines[i].contains('|')) {
        final List<String> row = _cells(lines[i]).toList();
        // Ragged rows are padded rather than dropped. The model is streaming,
        // so the last row may simply be half-written.
        while (row.length < head.length) {
          row.add('');
        }
        rows.add(row.sublist(0, head.length));
        i += 1;
      }
      i -= 1;
      blocks.add(ElMarkdownTable(head, rows, align));
      continue;
    }

    final RegExpMatch? quote = _quote.firstMatch(line);
    if (quote != null) {
      if (open is! ElMarkdownQuote) close();
      if (open is! ElMarkdownQuote) open = ElMarkdownQuote(<String>[]);
      (open! as ElMarkdownQuote).lines.add(quote[1]!);
      continue;
    }

    final RegExpMatch? bullet = _bullet.firstMatch(line);
    if (bullet != null) {
      if (open is! ElMarkdownBullets) close();
      if (open is! ElMarkdownBullets) open = ElMarkdownBullets(<String>[]);
      (open! as ElMarkdownBullets).items.add(bullet[1]!);
      continue;
    }

    final RegExpMatch? numbered = _number.firstMatch(line);
    if (numbered != null) {
      if (open is! ElMarkdownNumbers) close();
      if (open is! ElMarkdownNumbers) {
        open = ElMarkdownNumbers(<ElMarkdownOrderedItem>[]);
      }
      (open! as ElMarkdownNumbers).items.add(
        ElMarkdownOrderedItem(int.parse(numbered[1]!), numbered[2]!),
      );
      continue;
    }

    // A plain line directly under a list item is that item's continuation,
    // which is how the model wraps a long finding.
    if (open is ElMarkdownBullets) {
      final List<String> items = (open! as ElMarkdownBullets).items;
      items[items.length - 1] = '${items[items.length - 1]} ${line.trim()}';
      continue;
    }
    if (open is ElMarkdownNumbers) {
      final List<ElMarkdownOrderedItem> items =
          (open! as ElMarkdownNumbers).items;
      final ElMarkdownOrderedItem last = items[items.length - 1];
      items[items.length - 1] = ElMarkdownOrderedItem(
        last.n,
        '${last.text} ${line.trim()}',
      );
      continue;
    }

    if (open is! ElMarkdownParagraph) close();
    if (open is! ElMarkdownParagraph) open = ElMarkdownParagraph(<String>[]);
    (open! as ElMarkdownParagraph).lines.add(line.trim());
  }

  close();
  return blocks;
}

/* ── Inline ──────────────────────────────────────────────────────────────── */

/// Inline formatting, resolved in one pass.
///
/// Code is matched first and its contents are not re-scanned, so `**` inside a
/// backtick span stays literal — otherwise a code sample containing asterisks
/// would silently turn bold halfway through.
final RegExp _inline = RegExp(
  r'(`[^`]+`)'
  r'|(\[[^\]]+\]\([^)\s]+\))'
  r'|(\*\*[^*]+\*\*)'
  r'|(\*[^*]+\*|(?<![A-Za-z0-9])_[^_]+_(?![A-Za-z0-9]))'
  r'|(https?://[^\s<>()]+)',
);

/// `<code className="bg-muted type-code rounded-sm px-1 py-1">` — an inline
/// chip whose border box is glyph-tall plus its padding, and which contributes
/// only its own line height to the sentence around it.
class _InlineCode extends StatelessWidget {
  const _InlineCode(this.text);

  /// `px-1 py-1`.
  static double get pad => el(1);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ElInlineBox(
      trim: pad * 2,
      child: Container(
        padding: EdgeInsets.all(pad),
        decoration: BoxDecoration(
          color: theme.muted,
          borderRadius: BorderRadius.circular(ElRadii.sm),
        ),
        child: ElText(text, ElType.code, color: theme.foreground, inline: true),
      ),
    );
  }
}

/// The one-pass inline renderer, as spans.
InlineSpan elRenderMarkdownInline(BuildContext context, String text) {
  final ElThemeData theme = ElTheme.of(context);
  final List<InlineSpan> out = <InlineSpan>[];
  int last = 0;

  TextStyle style(ElTypeSpec spec, {Color? color}) =>
      ElText.styleOf(context, spec, color: color);

  InlineSpan link(String label, String href) => TextSpan(
    text: label,
    style: style(_MdType.body, color: theme.agent).copyWith(
      decoration: TextDecoration.underline,
      decorationColor: theme.agent,
    ),
  );

  for (final RegExpMatch match in _inline.allMatches(text)) {
    if (match.start > last) {
      out.add(TextSpan(text: text.substring(last, match.start)));
    }
    final String? code = match[1];
    final String? anchor = match[2];
    final String? strong = match[3];
    final String? em = match[4];
    final String? bare = match[5];

    if (code != null) {
      out.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: _InlineCode(code.substring(1, code.length - 1)),
        ),
      );
    } else if (anchor != null) {
      final int split = anchor.indexOf('](');
      final String label = anchor.substring(1, split);
      final String? href = elSafeHref(
        anchor.substring(split + 2, anchor.length - 1),
      );
      // A refused scheme keeps its label and loses its link, rather than
      // vanishing — the reader should still see what was written.
      out.add(href == null ? TextSpan(text: label) : link(label, href));
    } else if (strong != null) {
      out.add(
        TextSpan(
          text: strong.substring(2, strong.length - 2),
          style: style(_MdType.strong),
        ),
      );
    } else if (em != null) {
      out.add(
        TextSpan(
          text: em.substring(1, em.length - 1),
          style: style(_MdType.emphasis),
        ),
      );
    } else if (bare != null) {
      final String? href = elSafeHref(bare);
      out.add(href == null ? TextSpan(text: bare) : link(bare, href));
    }
    last = match.start + match[0]!.length;
  }

  if (last < text.length) out.add(TextSpan(text: text.substring(last)));
  return TextSpan(children: out);
}

/* ── The renderer ────────────────────────────────────────────────────────── */

/// `<Markdown text={…} />`.
///
/// The public surface the transcript, the composer echo and the console all
/// code against: a string in, a block tree out. Renders nothing at all when the
/// parse produces no blocks, which is the reference's `if (blocks.length === 0)
/// return null`.
class ElAgentMarkdown extends StatelessWidget {
  const ElAgentMarkdown({super.key, required this.text, this.textAlign});

  final String text;

  /// Alignment for every paragraph-level block. Null is the reference's own
  /// (inherited `start`); the questionnaire and the welcome card are the two
  /// places a caller centres a whole message.
  final TextAlign? textAlign;

  /// `space-y-2` — 8px, paid as margin-bottom on every block but the last.
  static double get blockGap => el(2);

  /// `pl-6` on both list forms.
  static double get listInset => el(6);

  /// `space-y-1` between list items.
  static double get itemGap => el(1);

  /// `pl-4` on a blockquote, over a 2px left rule.
  static double get quoteInset => el(4);

  /// `border-l-2`.
  static double get quoteRule => el(0.5);

  /// `border-agent/40`.
  static const double quoteRuleAlpha = 0.40;

  /// `px-3 py-2` in every table cell.
  static double get cellPadX => el(3);
  static double get cellPadY => el(2);

  /// `mt-1` on a heading.
  static double get headingTop => el(1);

  @override
  Widget build(BuildContext context) {
    final List<ElMarkdownBlock> blocks = elParseMarkdown(text);
    if (blocks.isEmpty) return const SizedBox.shrink();

    final ElThemeData theme = ElTheme.of(context);

    return DefaultTextStyle(
      style: ElText.styleOf(context, _MdType.body, color: theme.foreground),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 0; i < blocks.length; i += 1)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == blocks.length - 1 ? 0 : blockGap,
              ),
              child: _block(context, blocks[i], theme),
            ),
        ],
      ),
    );
  }

  Widget _block(
    BuildContext context,
    ElMarkdownBlock block,
    ElThemeData theme,
  ) => switch (block) {
    // `<p className="type-h4 mt-1">` — all four levels take the same
    // treatment, so model output cannot create page-level hierarchy inside
    // a message.
    ElMarkdownHeading(:final String text) => Padding(
      padding: EdgeInsets.only(top: headingTop),
      child: ElRichText(
        elRenderMarkdownInline(context, text),
        ElType.h4,
        color: theme.foreground,
        align: textAlign,
      ),
    ),
    ElMarkdownFence(:final String lang, :final List<String> lines) =>
      DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ElRadii.md),
          border: Border.all(color: theme.border, width: ElWidths.hairline),
        ),
        child: Padding(
          padding: const EdgeInsets.all(ElWidths.hairline),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ElRadii.md - ElWidths.hairline),
            child: ElAgentCodeBlock(code: lines.join('\n'), language: lang),
          ),
        ),
      ),
    // `border-l-2 pl-4` — the rule runs the full height of the quote, so
    // the row has to know that height before it can stretch to it.
    // `CrossAxisAlignment.stretch` alone asks the incoming constraint for
    // it, and inside a `Column` that constraint is `h=Infinity`.
    ElMarkdownQuote(:final List<String> lines) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: quoteRule,
            color: theme.agent.withValues(alpha: quoteRuleAlpha),
          ),
          SizedBox(width: quoteInset),
          Expanded(
            child: ElRichText(
              elRenderMarkdownInline(context, lines.join(' ')),
              _MdType.quote,
              color: theme.mutedForeground,
              align: textAlign,
            ),
          ),
        ],
      ),
    ),
    ElMarkdownBullets(:final List<String> items) => _list(
      context,
      theme,
      <_ListRow>[for (final String item in items) (marker: '•', text: item)],
      markerWeight: null,
    ),
    // `value` rather than relying on position: a list split across blocks
    // must still read 1, 2, 3 rather than 1, 1, 1.
    ElMarkdownNumbers(:final List<ElMarkdownOrderedItem> items) =>
      _list(context, theme, <_ListRow>[
        for (final ElMarkdownOrderedItem item in items)
          (marker: '${item.n}.', text: item.text),
      ], markerWeight: ElType.small),
    ElMarkdownTable() => _table(context, theme, block),
    ElMarkdownParagraph(:final List<String> lines) => ElRichText(
      elRenderMarkdownInline(context, lines.join(' ')),
      _MdType.body,
      color: theme.foreground,
      align: textAlign,
    ),
  };

  Widget _list(
    BuildContext context,
    ElThemeData theme,
    List<_ListRow> rows, {
    required ElTypeSpec? markerWeight,
  }) {
    // `marker:font-medium` on the ordered form only; both markers take
    // `--muted-foreground`.
    final TextStyle marker = ElText.styleOf(
      context,
      markerWeight == null ? _MdType.body : _MdType.strong,
      color: theme.mutedForeground,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < rows.length; i += 1)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == rows.length - 1 ? 0 : itemGap,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // The marker box lives inside `pl-6`, right-aligned against the
                // content edge — which is where a CSS `::marker` is drawn.
                SizedBox(
                  width: listInset,
                  child: Padding(
                    padding: EdgeInsets.only(right: itemGap * 2),
                    child: ElLineBox(
                      style: marker,
                      child: Text(
                        rows[i].marker,
                        style: marker,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElRichText(
                    elRenderMarkdownInline(context, rows[i].text),
                    _MdType.body,
                    color: theme.foreground,
                    align: textAlign,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _table(
    BuildContext context,
    ElThemeData theme,
    ElMarkdownTable block,
  ) {
    ElMarkdownAlign alignOf(int j) =>
        j < block.align.length ? block.align[j] : ElMarkdownAlign.left;

    TextAlign flutterAlign(ElMarkdownAlign a) => switch (a) {
      ElMarkdownAlign.left => TextAlign.left,
      ElMarkdownAlign.right => TextAlign.right,
      ElMarkdownAlign.center => TextAlign.center,
    };

    // `border-collapse` splits the 1px rule between two rows half above and
    // half below, which is where the reference's 27.5 / 36.5 / 36 come from —
    // and Flutter's `Table` paints `horizontalInside` **without allocating
    // space for it**, so the half has to be paid as padding or the table comes
    // out one pixel short per body row. Measured: 133.5 against 136.5 before
    // this, on the three-row specimen.
    const double half = ElWidths.hairline / 2;
    Widget cell(
      Widget child, {
      required bool firstRow,
      required bool lastRow,
    }) => Padding(
      padding: EdgeInsets.only(
        left: cellPadX,
        right: cellPadX,
        top: cellPadY + (firstRow ? 0 : half),
        bottom: cellPadY + (lastRow ? 0 : half),
      ),
      child: child,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ElRadii.md),
        border: Border.all(color: theme.border, width: ElWidths.hairline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ElWidths.hairline),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ElRadii.md - ElWidths.hairline),
          child: Table(
            defaultColumnWidth: const IntrinsicColumnWidth(flex: 1),
            border: TableBorder(
              horizontalInside: BorderSide(
                color: theme.border,
                width: ElWidths.hairline,
              ),
            ),
            children: <TableRow>[
              TableRow(
                decoration: BoxDecoration(color: theme.muted),
                children: <Widget>[
                  for (int j = 0; j < block.head.length; j += 1)
                    cell(
                      ElRichText(
                        elRenderMarkdownInline(context, block.head[j]),
                        ElType.label,
                        color: theme.mutedForeground,
                        align: flutterAlign(alignOf(j)),
                      ),
                      firstRow: true,
                      lastRow: block.rows.isEmpty,
                    ),
                ],
              ),
              for (int r = 0; r < block.rows.length; r += 1)
                TableRow(
                  children: <Widget>[
                    for (int j = 0; j < block.rows[r].length; j += 1)
                      cell(
                        ElRichText(
                          elRenderMarkdownInline(context, block.rows[r][j]),
                          // Right-aligned columns are numeric by convention,
                          // and numeric UI in this system is tabular so the
                          // column actually lines up.
                          alignOf(j) == ElMarkdownAlign.right
                              ? _MdType.cellTabular
                              : ElType.small,
                          color: theme.foreground,
                          align: flutterAlign(alignOf(j)),
                        ),
                        firstRow: false,
                        lastRow: r == block.rows.length - 1,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef _ListRow = ({String marker, String text});

/* ── Code block ──────────────────────────────────────────────────────────── */

/// `LANGUAGE_ALIASES` — ported verbatim from `code-block.tsx`.
///
/// The value is the *normalised* name, and it is what the header strip prints:
/// a fence opened with ` ```ts ` shows **`typescript`**.
const Map<String, String> elLanguageAliases = <String, String>{
  'bash': 'bash',
  'css': 'css',
  'js': 'javascript',
  'javascript': 'javascript',
  'json': 'json',
  'jsx': 'jsx',
  'md': 'markdown',
  'markdown': 'markdown',
  'py': 'python',
  'python': 'python',
  'sh': 'bash',
  'shell': 'bash',
  'sql': 'sql',
  'ts': 'typescript',
  'tsx': 'tsx',
  'typescript': 'typescript',
};

/// The VS Code **Dark Plus** palette, as `react-syntax-highlighter` writes it.
///
/// allow-hardcoded: a third-party syntax theme, not tokens of this system.
/// `vscDarkPlus` arrives as an inline style object, so it beats every class on
/// the element — the `bg-muted` on the wrapper never reaches the `<pre>`, and
/// `--foreground` never reaches its text. Deriving these from the theme would
/// change what the reference renders, which is the one thing the port may not
/// do. Every value below was read off the live page.
class ElPrismPalette {
  const ElPrismPalette._();

  /// `pre[class*="language-"] { background: #1e1e1e }`.
  static const Color ground = Color(
    0xFF1E1E1E,
  ); // allow-hardcoded: vscDarkPlus ground

  /// The theme's plain-text colour.
  static const Color plain = Color(
    0xFFD4D4D4,
  ); // allow-hardcoded: vscDarkPlus plain

  static const Color keyword = Color(
    0xFF569CD6,
  ); // allow-hardcoded: vscDarkPlus keyword
  static const Color string = Color(
    0xFFCE9178,
  ); // allow-hardcoded: vscDarkPlus string
  static const Color number = Color(
    0xFFB5CEA8,
  ); // allow-hardcoded: vscDarkPlus number
  static const Color function = Color(
    0xFFDCDCAA,
  ); // allow-hardcoded: vscDarkPlus function
  static const Color comment = Color(
    0xFF6A9955,
  ); // allow-hardcoded: vscDarkPlus comment
  static const Color type = Color(
    0xFF4EC9B0,
  ); // allow-hardcoded: vscDarkPlus class-name

  /// `padding: 1em` at the theme's own 13px.
  static const double padding = 13; // allow-hardcoded: vscDarkPlus 1em @ 13px

  /// `margin: .5em 0` — real vertical space in the block, above and below.
  static const double margin = 6.5; // allow-hardcoded: vscDarkPlus .5em

  /// The theme's `font-size: 13px` over Preflight's 1.5 — 19.5px per line, and
  /// what actually sets the height of the body.
  static const double lineHeight = 19.5; // allow-hardcoded: vscDarkPlus strut
}

/// One coloured run inside a line of highlighted code.
@immutable
class ElCodeToken {
  const ElCodeToken(this.text, this.color);
  final String text;
  final Color color;
}

/// `<CodeBlock code language>`.
///
/// An unknown language is a plain `<pre className="bg-muted p-3">` on
/// `--foreground`; a known one gets a header strip naming the normalised
/// language over a Prism-tokenised body in [ElPrismPalette].
class ElAgentCodeBlock extends StatelessWidget {
  const ElAgentCodeBlock({super.key, required this.code, this.language});

  final String code;
  final String? language;

  /// `p-3` on the un-highlighted form.
  static double get plainPadding => el(3);

  /// `px-3 py-2` on the header strip.
  static double get stripPadX => el(3);
  static double get stripPadY => el(2);

  /// The normalised language, or null when the fence named one this file does
  /// not register.
  static String? normalise(String? language) {
    if (language == null || language.isEmpty) return null;
    return elLanguageAliases[language.toLowerCase()];
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final String? normalized = normalise(language);

    if (normalized == null) {
      return Container(
        color: theme.muted,
        padding: EdgeInsets.all(plainPadding),
        child: _Scroller(
          child: ElPreformattedCode(code: code, color: theme.foreground),
        ),
      );
    }

    // The strip's own line box is the markdown root's `leading-relaxed` strut,
    // not the 10.5px label's — measured 24.375, which is what makes the strip
    // 41.38 tall rather than 27.
    final double strut =
        ElText.styleOf(context, _MdType.body).fontSize! * _MdType.relaxed;

    return ColoredBox(
      color: theme.muted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: stripPadX,
              vertical: stripPadY,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.border,
                  width: ElWidths.hairline,
                ),
              ),
            ),
            child: SizedBox(
              height: strut,
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElText(
                  normalized,
                  ElType.micro,
                  color: theme.mutedForeground,
                ),
              ),
            ),
          ),
          Container(
            color: ElPrismPalette.ground,
            margin: const EdgeInsets.symmetric(vertical: ElPrismPalette.margin),
            padding: const EdgeInsets.all(ElPrismPalette.padding),
            child: _Scroller(child: _HighlightedCode(code, normalized)),
          ),
        ],
      ),
    );
  }
}

/// `overflow-x-auto` on a `<pre>`, which `white-space: pre` gives no choice
/// about: the content is intrinsically sized, so it genuinely scrolls.
class _Scroller extends StatelessWidget {
  const _Scroller({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: child);
}

/// A `<pre>` whose own `line-height` is the one it **inherits**, holding a
/// `<code class="type-code">`.
///
/// PROBE CORRECTION. The obvious reading — a block of `.type-code` is 17.5px
/// per line — is wrong wherever the class sits on the `<code>` rather than on
/// the `<pre>`. Preflight gives `pre` `font-size: 1em`, so the block keeps the
/// page's own 16px/24px strut and the 12.5px glyphs ride inside it: the
/// transcript page's four-line source blocks measure **122** (24 padding + 2
/// border + 4 × **24**), not the 96 the class alone would give. Where
/// `.type-code` *is* on the `pre` — the tool chip's disclosure, the approval
/// card's parameter block — the line box really is 17.5, and those two sites
/// use a plain [ElText] instead.
class ElPreformattedCode extends StatelessWidget {
  const ElPreformattedCode({super.key, required this.code, this.color});

  final String code;

  /// Defaults to `--foreground`.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final TextStyle style = ElText.styleOf(
      context,
      ElType.code,
      color: color ?? theme.foreground,
    );
    final TextStyle ambient = DefaultTextStyle.of(context).style;
    final double? size = ambient.fontSize;
    final double? ratio = ambient.height;
    final double line = size == null || ratio == null
        ? elEngineLineHeight(style)
        : size * ratio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final String row in code.split('\n'))
          SizedBox(
            height: line,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(row, style: style, softWrap: false),
            ),
          ),
      ],
    );
  }
}

class _HighlightedCode extends StatelessWidget {
  const _HighlightedCode(this.code, this.language);

  final String code;
  final String language;

  @override
  Widget build(BuildContext context) {
    final List<List<ElCodeToken>> lines = elTokenise(code, language);
    final TextStyle base = ElText.styleOf(
      context,
      ElType.code,
      color: ElPrismPalette.plain,
    );

    return Column(
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
    );
  }
}

/* ── Tokeniser ───────────────────────────────────────────────────────────── */

/// Prism, reduced to the token classes the palette actually paints.
///
/// **What is tokenised.** Three grammars cover the ten registered languages:
///
///  * *C-like* — `typescript`, `tsx`, `javascript`, `jsx`, `css`, `sql`,
///    `json`: line and block comments, single/double/backtick strings, numbers,
///    a reserved-word list per family, an identifier immediately followed by
///    `(` as a **function**, `PascalCase` identifiers as a **class-name**, and
///    every remaining operator or bracket as plain punctuation.
///  * *hash-comment* — `bash`, `python`: the same machinery with `#` for a line
///    comment and each language's own reserved words.
///  * *markdown* — fences, headings, emphasis runs and links as strings; the
///    rest plain.
///
/// The transcript page only ever renders `ts`, and that path is pinned against
/// the live reference span for span. The other nine are structurally the same
/// walk with a different word list.
List<List<ElCodeToken>> elTokenise(String code, String language) =>
    <List<ElCodeToken>>[
      for (final String line in code.split('\n')) _tokeniseLine(line, language),
    ];

const Set<String> _jsKeywords = <String>{
  'as',
  'async',
  'await',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'debugger',
  'default',
  'delete',
  'do',
  'else',
  'enum',
  'export',
  'extends',
  'false',
  'finally',
  'for',
  'from',
  'function',
  'get',
  'if',
  'implements',
  'import',
  'in',
  'instanceof',
  'interface',
  'let',
  'new',
  'null',
  'of',
  'package',
  'private',
  'protected',
  'public',
  'readonly',
  'return',
  'satisfies',
  'set',
  'static',
  'super',
  'switch',
  'this',
  'throw',
  'true',
  'try',
  'type',
  'typeof',
  'undefined',
  'var',
  'void',
  'while',
  'with',
  'yield',
};

const Set<String> _pyKeywords = <String>{
  'and',
  'as',
  'assert',
  'async',
  'await',
  'break',
  'class',
  'continue',
  'def',
  'del',
  'elif',
  'else',
  'except',
  'False',
  'finally',
  'for',
  'from',
  'global',
  'if',
  'import',
  'in',
  'is',
  'lambda',
  'None',
  'nonlocal',
  'not',
  'or',
  'pass',
  'raise',
  'return',
  'True',
  'try',
  'while',
  'with',
  'yield',
};

const Set<String> _shKeywords = <String>{
  'case',
  'do',
  'done',
  'echo',
  'elif',
  'else',
  'esac',
  'export',
  'fi',
  'for',
  'function',
  'if',
  'in',
  'local',
  'return',
  'then',
  'until',
  'while',
};

const Set<String> _sqlKeywords = <String>{
  'and',
  'as',
  'asc',
  'by',
  'delete',
  'desc',
  'distinct',
  'from',
  'group',
  'having',
  'inner',
  'insert',
  'into',
  'join',
  'left',
  'limit',
  'not',
  'null',
  'on',
  'or',
  'order',
  'outer',
  'right',
  'select',
  'set',
  'update',
  'values',
  'where',
};

const Set<String> _jsonKeywords = <String>{'true', 'false', 'null'};

Set<String> _keywordsFor(String language) => switch (language) {
  'python' => _pyKeywords,
  'bash' => _shKeywords,
  'sql' => _sqlKeywords,
  'json' => _jsonKeywords,
  _ => _jsKeywords,
};

bool _hashComments(String language) =>
    language == 'python' || language == 'bash';

final RegExp _identStart = RegExp(r'[A-Za-z_$]');
final RegExp _identPart = RegExp(r'[A-Za-z0-9_$]');
final RegExp _digit = RegExp(r'[0-9]');

List<ElCodeToken> _tokeniseLine(String line, String language) {
  if (language == 'markdown') return _tokeniseMarkdownLine(line);

  final Set<String> keywords = _keywordsFor(language);
  final bool hash = _hashComments(language);
  final List<ElCodeToken> out = <ElCodeToken>[];
  final StringBuffer plain = StringBuffer();

  void flush() {
    if (plain.isEmpty) return;
    out.add(ElCodeToken(plain.toString(), ElPrismPalette.plain));
    plain.clear();
  }

  int i = 0;
  while (i < line.length) {
    final String c = line[i];

    // Comments run to the end of the line, whichever marker opens them.
    if ((hash && c == '#') ||
        (!hash && c == '/' && i + 1 < line.length && line[i + 1] == '/')) {
      flush();
      out.add(ElCodeToken(line.substring(i), ElPrismPalette.comment));
      return out;
    }

    if (c == '"' || c == "'" || c == '`') {
      flush();
      final int start = i;
      i += 1;
      while (i < line.length) {
        if (line[i] == r'\') {
          i += 2;
          continue;
        }
        if (line[i] == c) {
          i += 1;
          break;
        }
        i += 1;
      }
      out.add(
        ElCodeToken(
          line.substring(start, i.clamp(0, line.length)),
          ElPrismPalette.string,
        ),
      );
      continue;
    }

    if (_digit.hasMatch(c)) {
      flush();
      final int start = i;
      while (i < line.length &&
          (_digit.hasMatch(line[i]) || line[i] == '.' || line[i] == '_')) {
        i += 1;
      }
      out.add(ElCodeToken(line.substring(start, i), ElPrismPalette.number));
      continue;
    }

    if (_identStart.hasMatch(c)) {
      flush();
      final int start = i;
      while (i < line.length && _identPart.hasMatch(line[i])) {
        i += 1;
      }
      final String word = line.substring(start, i);
      if (keywords.contains(word)) {
        out.add(ElCodeToken(word, ElPrismPalette.keyword));
      } else if (i < line.length && line[i] == '(') {
        out.add(ElCodeToken(word, ElPrismPalette.function));
      } else if (word.isNotEmpty &&
          word[0].toUpperCase() == word[0] &&
          word[0].toLowerCase() != word[0]) {
        out.add(ElCodeToken(word, ElPrismPalette.type));
      } else {
        out.add(ElCodeToken(word, ElPrismPalette.plain));
      }
      continue;
    }

    plain.write(c);
    i += 1;
  }

  flush();
  return out;
}

final RegExp _mdHeading = RegExp(r'^\s*#{1,6}\s');
final RegExp _mdFence = RegExp(r'^\s*```');
final RegExp _mdEmphasis = RegExp(r'(\*\*[^*]+\*\*|\*[^*]+\*|`[^`]+`)');

List<ElCodeToken> _tokeniseMarkdownLine(String line) {
  if (_mdFence.hasMatch(line) || _mdHeading.hasMatch(line)) {
    return <ElCodeToken>[ElCodeToken(line, ElPrismPalette.keyword)];
  }
  final List<ElCodeToken> out = <ElCodeToken>[];
  int last = 0;
  for (final RegExpMatch m in _mdEmphasis.allMatches(line)) {
    if (m.start > last) {
      out.add(ElCodeToken(line.substring(last, m.start), ElPrismPalette.plain));
    }
    out.add(ElCodeToken(m[0]!, ElPrismPalette.string));
    last = m.end;
  }
  if (last < line.length) {
    out.add(ElCodeToken(line.substring(last), ElPrismPalette.plain));
  }
  return out;
}
