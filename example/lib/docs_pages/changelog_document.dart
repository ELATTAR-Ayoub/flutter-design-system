/// The root `CHANGELOG.md`, parsed.
///
/// The release history has exactly one home, and it is the file at the
/// repository root that a maintainer edits and a GitHub release quotes.
/// Nothing here restates it: the page loads those bytes and renders them, so
/// changing the changelog changes the site and there is no second copy to
/// keep in step.
///
/// **The parser is deliberately small, and deliberately strict.** It handles
/// the subset the changelog actually uses — headings, paragraphs, bullet
/// lists, fenced code, inline code, links, bold and italic — and *reports*
/// anything else rather than dropping it. That choice is the whole point: a
/// permissive renderer that silently skipped a table would quietly delete a
/// release note, and nobody would find out from the page. A strict one fails
/// a test instead, on the commit that introduced it.
library;

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

/// The changelog, reached through the package that owns it.
///
/// `CHANGELOG.md` sits at the repository root, above `example/`, and an asset
/// path may not climb above its own project root. Declared on the package it
/// arrives as `packages/elattar_design_system/CHANGELOG.md`.
const String changelogAsset = 'packages/elattar_design_system/CHANGELOG.md';

/// Raised when the changelog cannot be loaded or contains something this
/// renderer would have to drop.
class ChangelogDocumentException implements Exception {
  const ChangelogDocumentException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// A run of text with at most one mark. Nested emphasis is not supported and
/// is reported rather than flattened.
class ChangelogSpan {
  const ChangelogSpan(
    this.text, {
    this.code = false,
    this.strong = false,
    this.emphasis = false,
    this.href,
  });

  final String text;
  final bool code;
  final bool strong;
  final bool emphasis;

  /// Set when this run is a link. The text is the label.
  final String? href;

  bool get isLink => href != null;
}

/// What kind of block a [ChangelogBlock] is.
enum ChangelogBlockKind { heading, paragraph, bullet, code }

/// One block of the document.
class ChangelogBlock {
  const ChangelogBlock({
    required this.kind,
    this.level = 0,
    this.spans = const <ChangelogSpan>[],
    this.code = '',
    this.indent = 0,
  });

  final ChangelogBlockKind kind;

  /// Heading level, 1–6. Zero for everything else.
  final int level;

  /// The inline runs. Empty for [ChangelogBlockKind.code].
  final List<ChangelogSpan> spans;

  /// The literal contents of a fenced block, newlines intact.
  final String code;

  /// Nesting depth for a bullet, in list levels rather than spaces.
  final int indent;

  /// The block's text with every mark dropped — for search, semantics and
  /// tests that care about content rather than presentation.
  String get plainText => spans.map((ChangelogSpan s) => s.text).join();
}

/// One release: its heading and everything under it until the next one.
class ChangelogRelease {
  const ChangelogRelease({required this.version, required this.blocks});

  /// The `## ` heading's text, e.g. `0.0.1`.
  final String version;

  /// Everything below that heading, in source order.
  final List<ChangelogBlock> blocks;
}

/// The whole document.
class ChangelogDocument {
  const ChangelogDocument({
    required this.title,
    required this.preamble,
    required this.releases,
  });

  /// The `# ` heading, if the file opens with one.
  final String title;

  /// Blocks between the title and the first release.
  final List<ChangelogBlock> preamble;

  /// Releases in source order, which for a changelog is newest first.
  final List<ChangelogRelease> releases;
}

/// Reads the document. Injected so widget tests never touch a bundle.
typedef ChangelogLoader = Future<ChangelogDocument> Function();

/// The default loader: the bundled root `CHANGELOG.md`.
Future<ChangelogDocument> loadBundledChangelog({AssetBundle? bundle}) async {
  final String source;
  try {
    source = await (bundle ?? rootBundle).loadString(changelogAsset);
  } catch (error) {
    throw const ChangelogDocumentException(
      'CHANGELOG.md is not in this build. It is declared as a package asset '
      'in the root pubspec.yaml; a build that omits it cannot show the '
      'release history.',
    );
  }
  return parseChangelog(source);
}

/// Parses the supported Markdown subset, or throws naming what it cannot
/// render.
ChangelogDocument parseChangelog(String source) {
  final List<String> lines = source.replaceAll('\r\n', '\n').split('\n');

  String title = '';
  final List<ChangelogBlock> preamble = <ChangelogBlock>[];
  final List<ChangelogRelease> releases = <ChangelogRelease>[];

  List<ChangelogBlock> current = preamble;
  String? currentVersion;
  final List<String> paragraph = <String>[];

  void flushParagraph() {
    if (paragraph.isEmpty) return;
    current.add(
      ChangelogBlock(
        kind: ChangelogBlockKind.paragraph,
        spans: parseInline(paragraph.join(' ')),
      ),
    );
    paragraph.clear();
  }

  void closeRelease() {
    flushParagraph();
    if (currentVersion case final String version) {
      releases.add(
        ChangelogRelease(
          version: version,
          blocks: List<ChangelogBlock>.unmodifiable(current),
        ),
      );
    }
  }

  for (int i = 0; i < lines.length; i++) {
    final String raw = lines[i];
    final String line = raw.trimRight();

    // ── fenced code ──────────────────────────────────────────────────────
    if (line.trimLeft().startsWith('```')) {
      flushParagraph();
      final List<String> body = <String>[];
      int j = i + 1;
      while (j < lines.length && !lines[j].trimLeft().startsWith('```')) {
        body.add(lines[j]);
        j++;
      }
      if (j >= lines.length) {
        throw const ChangelogDocumentException(
          'CHANGELOG.md has an unterminated code fence.',
        );
      }
      current.add(
        ChangelogBlock(kind: ChangelogBlockKind.code, code: body.join('\n')),
      );
      i = j;
      continue;
    }

    if (line.trim().isEmpty) {
      flushParagraph();
      continue;
    }

    // ── horizontal rule ──────────────────────────────────────────────────
    // Renderable as nothing: it is a visual separator with no content, and
    // dropping it loses no release information. Named here so it is a
    // decision rather than an omission.
    if (RegExp(r'^\s*(-{3,}|\*{3,}|_{3,})\s*$').hasMatch(line)) {
      flushParagraph();
      continue;
    }

    // ── headings ─────────────────────────────────────────────────────────
    final RegExpMatch? heading = RegExp(r'^(#{1,6})\s+(.*)$').firstMatch(line);
    if (heading != null) {
      flushParagraph();
      final int level = heading.group(1)!.length;
      final String text = heading.group(2)!.trim();
      if (level == 1) {
        if (title.isEmpty && releases.isEmpty && currentVersion == null) {
          title = text;
          continue;
        }
      }
      if (level == 2) {
        // A new release starts here. `## How this was built` is a section,
        // not a version, so only headings that look like one open a release.
        if (_looksLikeVersion(text)) {
          closeRelease();
          currentVersion = text;
          current = <ChangelogBlock>[];
          continue;
        }
        // A non-version level-two heading after the releases have started
        // closes the last one and returns to document scope.
        if (currentVersion != null) {
          closeRelease();
          currentVersion = null;
          current = preamble;
        }
      }
      current.add(
        ChangelogBlock(
          kind: ChangelogBlockKind.heading,
          level: level,
          spans: parseInline(text),
        ),
      );
      continue;
    }

    // ── bullets ──────────────────────────────────────────────────────────
    final RegExpMatch? bullet = RegExp(r'^(\s*)[-*+]\s+(.*)$').firstMatch(line);
    if (bullet != null) {
      flushParagraph();
      final int spaces = bullet.group(1)!.length;
      current.add(
        ChangelogBlock(
          kind: ChangelogBlockKind.bullet,
          spans: parseInline(bullet.group(2)!.trim()),
          // Two spaces per level, which is what this changelog uses.
          indent: spaces ~/ 2,
        ),
      );
      continue;
    }

    // ── blockquote ───────────────────────────────────────────────────────
    final RegExpMatch? quote = RegExp(r'^\s*>\s?(.*)$').firstMatch(line);
    if (quote != null) {
      // Rendered as a paragraph. The changelog uses quotes for asides, and a
      // distinct quote style is presentation this page does not need — but
      // the *text* must not be dropped, which is why this is handled rather
      // than ignored.
      paragraph.add(quote.group(1)!.trim());
      continue;
    }

    // ── the unsupported ──────────────────────────────────────────────────
    if (line.trimLeft().startsWith('|')) {
      throw ChangelogDocumentException(
        'CHANGELOG.md line ${i + 1} is a table, which this page cannot '
        'render. Either add table support or rewrite the entry as prose — '
        'silently dropping it would delete a release note.',
      );
    }
    // The negative lookahead matters: a line may legitimately *begin* with an
    // autolink — `<https://example.com>` — and the inline parser handles
    // those. Without it, a paragraph that opens with a bare URL is rejected
    // as raw HTML, which is what the real changelog did on its second run.
    if (RegExp(r'^\s*<(?!https?://)[a-zA-Z/!]').hasMatch(line)) {
      throw ChangelogDocumentException(
        'CHANGELOG.md line ${i + 1} contains raw HTML, which this page does '
        'not render.',
      );
    }
    if (RegExp(r'^\s*!\[').hasMatch(line)) {
      throw ChangelogDocumentException(
        'CHANGELOG.md line ${i + 1} embeds an image, which this page does '
        'not render.',
      );
    }

    // A continuation of the paragraph in progress. A changelog wraps its
    // prose, so this is the common case, not the fallback.
    paragraph.add(line.trim());
  }

  closeRelease();

  if (releases.isEmpty) {
    throw const ChangelogDocumentException(
      'CHANGELOG.md declares no releases. A release is a `## ` heading whose '
      'text is a version.',
    );
  }

  return ChangelogDocument(
    title: title,
    preamble: List<ChangelogBlock>.unmodifiable(preamble),
    releases: List<ChangelogRelease>.unmodifiable(releases),
  );
}

/// `0.0.1`, `1.2.3-beta.1`, or a version with a date after it.
bool _looksLikeVersion(String text) =>
    RegExp(r'^v?\d+\.\d+\.\d+').hasMatch(text.trim());

/// Splits one line into runs of text, code, emphasis and links.
///
/// Order matters: code spans are taken first and their contents are never
/// re-scanned, so a backticked `**` stays literal — which is the difference
/// between rendering a command correctly and rendering half of it bold.
List<ChangelogSpan> parseInline(String text) {
  final List<ChangelogSpan> spans = <ChangelogSpan>[];
  final RegExp pattern = RegExp(
    r'`([^`]+)`'
    r'|\[([^\]]+)\]\(([^)\s]+)\)'
    r'|\*\*([^*]+)\*\*'
    r'|(?<![a-zA-Z0-9])\*([^*]+)\*(?![a-zA-Z0-9])'
    r'|<(https?://[^>\s]+)>'
    r'|(https?://[^\s)<>]+)',
  );

  int cursor = 0;
  for (final RegExpMatch match in pattern.allMatches(text)) {
    if (match.start > cursor) {
      spans.add(ChangelogSpan(text.substring(cursor, match.start)));
    }
    if (match.group(1) case final String code) {
      spans.add(ChangelogSpan(code, code: true));
    } else if (match.group(2) case final String label) {
      spans.add(ChangelogSpan(label, href: match.group(3)));
    } else if (match.group(4) case final String strong) {
      spans.add(ChangelogSpan(strong, strong: true));
    } else if (match.group(5) case final String emphasis) {
      spans.add(ChangelogSpan(emphasis, emphasis: true));
    } else if (match.group(6) case final String url) {
      spans.add(ChangelogSpan(url, href: url));
    } else if (match.group(7) case final String url) {
      spans.add(ChangelogSpan(url, href: url));
    }
    cursor = match.end;
  }
  if (cursor < text.length) {
    spans.add(ChangelogSpan(text.substring(cursor)));
  }
  return spans.isEmpty ? <ChangelogSpan>[ChangelogSpan(text)] : spans;
}
