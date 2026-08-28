/// Public documentation page for `/docs/changelog`.
///
/// The page renders the root `CHANGELOG.md` and owns none of its words.
/// Editing that file changes this page; there is no second file to update and
/// no way for the two to disagree, which is the only arrangement that stays
/// true after the third release.
///
/// Everything comes through an injectable loader, so the tests drive the
/// loading, loaded, empty and error states without a bundle.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import '../docs/docs_layout.dart';
import '../docs/docs_section.dart';
import '../docs/docs_snippet.dart';
import 'catalog.dart';
import 'changelog_document.dart';

/// Opens a link from the changelog. Null renders labels as plain text.
typedef ChangelogLinkHandler = void Function(String href);

class ChangelogDocsPage extends StatefulWidget {
  const ChangelogDocsPage({
    super.key,
    this.onNavigate,
    this.loader,
    this.onOpenLink,
  });

  final ValueChanged<String>? onNavigate;

  /// Where the document comes from. Defaults to the bundled `CHANGELOG.md`.
  final ChangelogLoader? loader;

  /// What to do with an external link. Left null, links render as labelled
  /// text rather than as controls that do nothing when pressed.
  final ChangelogLinkHandler? onOpenLink;

  @override
  State<ChangelogDocsPage> createState() => _ChangelogDocsPageState();
}

class _ChangelogDocsPageState extends State<ChangelogDocsPage> {
  late Future<ChangelogDocument> _document = _load();

  Future<ChangelogDocument> _load() =>
      (widget.loader ?? loadBundledChangelog)();

  void _retry() {
    setState(() {
      _document = _load();
    });
  }

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: docsChangelogRoute,
    intro: const DocsPageIntro(
      eyebrow: 'DOCS',
      title: 'Changelog',
      description:
          'Every release, newest first, rendered from the repository\'s own '
          'CHANGELOG.md.',
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Docs'),
      BreadcrumbEntry.page('Changelog'),
    ],
    previous: const DocsPageLink(title: 'Registry', route: docsRegistryRoute),
    next: const DocsPageLink(title: 'Skills', route: '/skills'),
    onNavigate: widget.onNavigate,
    // The article root carries its key in every state, not only when the
    // document loads. A key that appeared only on success meant a routing
    // test could not tell "the page mounted and is reporting an error" from
    // "the route resolved to something else entirely" — which is precisely
    // the failure this page exists to fix.
    child: Column(
      key: const ValueKey<String>('changelog-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        FutureBuilder<ChangelogDocument>(
          future: _document,
          builder:
              (BuildContext context, AsyncSnapshot<ChangelogDocument> state) =>
                  switch (state) {
                    AsyncSnapshot<ChangelogDocument>(
                      connectionState: ConnectionState.waiting,
                    ) =>
                      const _Loading(),
                    AsyncSnapshot<ChangelogDocument>(hasError: true) => _Failed(
                      error: state.error!,
                      onRetry: _retry,
                    ),
                    AsyncSnapshot<ChangelogDocument>(
                      data: final ChangelogDocument document,
                    )
                        when document.releases.isEmpty =>
                      const _Empty(),
                    AsyncSnapshot<ChangelogDocument>(
                      data: final ChangelogDocument document,
                    ) =>
                      _Document(
                        document: document,
                        onOpenLink: widget.onOpenLink,
                      ),
                    _ => const _Loading(),
                  },
        ),
      ],
    ),
  );
}

/// The rendered document.
///
/// One `DocsSection` per release, so each gets the same anchor, heading
/// semantics and spacing every other docs page uses — and so a link to a
/// version lands on it.
class _Document extends StatelessWidget {
  const _Document({required this.document, this.onOpenLink});

  final ChangelogDocument document;
  final ChangelogLinkHandler? onOpenLink;

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('changelog-doc-releases'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      if (document.preamble.isNotEmpty)
        _Blocks(blocks: document.preamble, onOpenLink: onOpenLink),
      for (final ChangelogRelease release in document.releases)
        DocsSection(
          key: ValueKey<String>('changelog-release-${release.version}'),
          id: _anchorFor(release.version),
          title: release.version,
          child: _Blocks(blocks: release.blocks, onOpenLink: onOpenLink),
        ),
    ],
  );

  /// `0.0.1` -> `0-0-1`: an anchor is a URL fragment, and a dot in one is a
  /// needless escaping problem for a value that is already unique without it.
  static String _anchorFor(String version) =>
      version.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
}

class _Blocks extends StatelessWidget {
  const _Blocks({required this.blocks, this.onOpenLink});

  final List<ChangelogBlock> blocks;
  final ChangelogLinkHandler? onOpenLink;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      for (final ChangelogBlock block in blocks) ...<Widget>[
        _Block(block: block, onOpenLink: onOpenLink),
        SizedBox(height: space(3)),
      ],
    ],
  );
}

class _Block extends StatelessWidget {
  const _Block({required this.block, this.onOpenLink});

  final ChangelogBlock block;
  final ChangelogLinkHandler? onOpenLink;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    switch (block.kind) {
      case ChangelogBlockKind.code:
        return DocsSnippet(code: block.code);

      case ChangelogBlockKind.heading:
        // `header: true` so a screen reader can jump between them. A release
        // page read linearly is unusable; heading navigation is how anyone
        // finds the version they came for.
        return Semantics(
          header: true,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
            child: _RichBlock(
              block: block,
              base: _headingSpec(block.level),
              onOpenLink: onOpenLink,
            ),
          ),
        );

      case ChangelogBlockKind.paragraph:
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
          child: _RichBlock(
            block: block,
            base: TextStyles.body,
            onOpenLink: onOpenLink,
          ),
        );

      case ChangelogBlockKind.bullet:
        return Padding(
          // Indent by nesting level, from the spacing scale.
          padding: EdgeInsets.only(left: space(4) * (block.indent + 1)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // A rendered marker rather than a literal bullet character in
                // the text: the text is the changelog's, and prefixing it
                // would put a glyph into content that is meant to be copied.
                StyledText('•', TextStyles.body, color: theme.mutedForeground),
                SizedBox(width: space(3)),
                Expanded(
                  child: _RichBlock(
                    block: block,
                    base: TextStyles.body,
                    onOpenLink: onOpenLink,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  static TextStyleToken _headingSpec(int level) => switch (level) {
    1 => TextStyles.h1,
    2 => TextStyles.h2,
    3 => TextStyles.h3,
    _ => TextStyles.h4,
  };
}

/// One block's spans, as a single selectable rich-text run.
///
/// A `Row` of separate `StyledText`s would break selection at every mark and wrap
/// badly mid-sentence, so the marks become `TextSpan`s inside one paragraph.
/// The styles still come from `TextStyles` — this is a composition of tokens, not
/// a place where a font size gets written down.
class _RichBlock extends StatefulWidget {
  const _RichBlock({required this.block, required this.base, this.onOpenLink});

  final ChangelogBlock block;
  final TextStyleToken base;
  final ChangelogLinkHandler? onOpenLink;

  @override
  State<_RichBlock> createState() => _RichBlockState();
}

class _RichBlockState extends State<_RichBlock> {
  /// One recognizer per link span, created once and disposed with the widget.
  /// Building them in `build` would leak a recognizer per frame.
  final List<TapGestureRecognizer> _recognizers = <TapGestureRecognizer>[];

  @override
  void dispose() {
    for (final TapGestureRecognizer recognizer in _recognizers) {
      recognizer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    for (final TapGestureRecognizer recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();

    final double size = widget.base.size ?? TextStyles.body.size!;
    final TextStyle baseStyle = widget.base.resolve(size, theme.foreground);

    // No `SelectionArea` here: `shell.dart` already wraps the whole docs
    // article in one, so every block is selectable as part of a single
    // continuous run. A nested area per block would break selection at each
    // paragraph boundary, which is the opposite of what a changelog needs.
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          for (final ChangelogSpan span in widget.block.spans)
            _span(span, theme, size, baseStyle),
        ],
      ),
      style: baseStyle,
    );
  }

  InlineSpan _span(
    ChangelogSpan span,
    ThemeTokens theme,
    double size,
    TextStyle base,
  ) {
    if (span.isLink) {
      final ChangelogLinkHandler? open = widget.onOpenLink;
      TapGestureRecognizer? recognizer;
      if (open != null) {
        recognizer = TapGestureRecognizer()..onTap = () => open(span.href!);
        _recognizers.add(recognizer);
      }
      return TextSpan(
        text: span.text,
        style: base.copyWith(
          color: theme.actionText,
          decoration: TextDecoration.underline,
          decorationColor: theme.actionText,
        ),
        recognizer: recognizer,
        // The label a screen reader reads. Without it a bare URL is read
        // character by character, which is unusable.
        semanticsLabel: span.text == span.href
            ? 'Link: ${span.href}'
            : '${span.text}, link',
      );
    }
    if (span.code) {
      return TextSpan(
        text: span.text,
        style: TextStyles.code.resolveInline(
          TextStyles.code.size!,
          theme.foreground,
        ),
      );
    }
    if (span.strong) {
      return TextSpan(
        text: span.text,
        // The weight comes from the heading scale rather than a literal:
        // `h4` is the system's own "this is emphasised prose" weight.
        style: base.copyWith(
          fontWeight: TextStyles.h4.weight,
          fontVariations: TextStyles.h4.variations,
        ),
      );
    }
    if (span.emphasis) {
      return TextSpan(
        text: span.text,
        style: base.copyWith(fontStyle: FontStyle.italic),
      );
    }
    return TextSpan(text: span.text);
  }
}

/// Layout-preserving loading: a title-sized bar and a few lines of prose,
/// which is the shape of every release entry.
class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Loading the changelog',
    liveRegion: true,
    child: Column(
      key: const ValueKey<String>('changelog-loading'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int release = 0; release < 2; release++) ...<Widget>[
          Skeleton(width: space(40), height: space(8)),
          SizedBox(height: space(4)),
          for (int line = 0; line < 3; line++) ...<Widget>[
            Skeleton(height: space(5)),
            SizedBox(height: space(2)),
          ],
          SizedBox(height: space(6)),
        ],
      ],
    ),
  );
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) => const Empty(
    key: ValueKey<String>('changelog-empty'),
    children: <Widget>[
      EmptyHeader(
        children: <Widget>[
          EmptyMedia(glyph: IconGlyph.clock),
          EmptyTitle('No releases yet'),
          EmptyDescription(
            'CHANGELOG.md parsed and declares no versions. The first release '
            'will appear here.',
          ),
        ],
      ),
    ],
  );
}

class _Failed extends StatelessWidget {
  const _Failed({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('changelog-error'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      Alert(
        variant: AlertVariant.destructive,
        icon: const Icon(IconGlyph.circleX),
        title: 'The changelog could not be read',
        description: error is ChangelogDocumentException
            ? '$error'
            : 'CHANGELOG.md could not be rendered: $error',
      ),
      SizedBox(height: space(4)),
      Align(
        alignment: Alignment.centerLeft,
        child: Button(onPressed: onRetry, child: const Text('Try again')),
      ),
    ],
  );
}
