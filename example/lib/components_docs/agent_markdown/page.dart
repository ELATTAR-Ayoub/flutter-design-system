/// Public documentation page for the `agent-markdown` component.
///
/// `agent_markdown.dart` declares three widgets — [AgentMarkdown] (the
/// public entry point), [AgentCodeBlock] and [PreformattedCode] — plus
/// two supporting classes, [PrismPalette] and [CodeToken], and the
/// safety function [safeHref]. API Reference gives each its own table.
///
/// **Scoped, deliberately.** The file also declares a whole markdown block
/// model ([MarkdownBlock] and its seven subclasses), the parser that
/// produces it ([parseMarkdown]), the inline-span renderer
/// ([renderMarkdownInline]) and a small syntax tokeniser
/// ([tokenise]). All four are public Dart symbols, because the language
/// gives no way to export a widget without exporting what it is built
/// from — but the class doc is explicit about what the *public surface*
/// is: *"a string in, a block tree out."* [AgentMarkdown.text] is the
/// only door a caller is meant to use; nobody constructs an
/// [MarkdownFence] by hand. Giving the parser's own internal vocabulary
/// six more API tables would document an interface this file does not
/// intend, so this page covers what a caller actually touches and states
/// this scoping choice once, here, rather than leaving it unexplained.
///
/// **Links are styled, not interactive.** Read directly off
/// `renderMarkdownInline`'s own `link()` helper: it returns a `TextSpan`
/// with an underline and `theme.agentAccent` ink and nothing else — no
/// `recognizer`, no `TapGestureRecognizer`, no `onTap`. A markdown link
/// and a bare `https://` URL both render as text that *looks* like a
/// link and cannot be tapped. The Links section below shows this
/// honestly rather than assuming the conventional shape.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
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

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec agentMarkdownDocSpec = ComponentDocSpec(
  name: 'agent_markdown',
  title: 'Agent Markdown',
  description:
      'Renders formatted text — headings, bold and italic, lists, a '
      'blockquote, tables, fenced code — to a Flutter widget tree with no '
      'HTML parser and no dangerouslySetInnerHTML in the path.',
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'One message combining a heading, bold and italic text, a '
          'bullet list, a numbered list, a blockquote and a link — the '
          'subset a model actually writes. Anything outside that subset '
          'falls through as plain text: a stray backtick reads as a '
          'stray backtick, never as a broken renderer.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: space(96),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'agent-markdown has a real registry manifest, `elattar add '
          'agent-markdown` installs lib/src/components/ui/'
          'agent_markdown.dart and resolves source-foundation '
          'automatically. The Manual tab is for a project not using the '
          'CLI.',
      command: agentMarkdownDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/agent_markdown.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/agent_markdown.dart's generated "
              '@ui/agent_markdown.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated agent_markdown source here when '
              'using manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so AgentMarkdown and its two '
              'sibling widgets are reachable the same way the CLI path '
              'already makes them.',
          code: "export 'agent_markdown.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction. Renders nothing '
          '(SizedBox.shrink()) when parsing text produces no blocks — an '
          'empty string among them.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'lists',
      title: 'Lists',
      description:
          'A blank line closes whatever list is open, so a model writing '
          'four findings as two two-item groups produces two separate '
          'MarkdownNumbers blocks — but each item carries the number '
          'its author actually wrote (MarkdownOrderedItem.n), not a '
          'freshly-counted position, so 1 2 3 4 reads continuously '
          'across the split rather than resetting to 1 2 1 2.',
      specimen: _ListsSpecimen(),
      code: _listsCode,
      label: 'Lists specimen view',
    ),
    ShowcaseSection(
      id: 'table',
      title: 'Table',
      description:
          'Column alignment comes from the delimiter row\'s own colons — '
          ':--- left, :---: center, ---: right — read once by '
          'parseMarkdown, not re-parsed per cell. Right-aligned columns '
          'render in a tabular-figure type spec (numeric by convention) '
          'rather than the proportional face every other cell uses.',
      specimen: _TableSpecimen(),
      code: _tableCode,
      label: 'Table specimen view',
    ),
    ShowcaseSection(
      id: 'code-block',
      title: 'Code block',
      description:
          'A recognized language (languageAliases has an entry for it) '
          'gets a header strip naming the normalised language over a '
          'Prism-tokenised body on PrismPalette\'s vscDarkPlus colours. '
          'An unrecognized one — this fence opens ```swift, which the '
          'alias map does not carry — falls back to a plain, '
          'un-highlighted --muted block instead of guessing.',
      specimen: _CodeBlockSpecimen(),
      code: _codeBlockCode,
      label: 'Code block specimen view',
      minHeight: space(64),
    ),
    ShowcaseSection(
      id: 'links',
      title: 'Links',
      description:
          'Three inline forms, none of them tappable: a markdown link to '
          'an https destination, a bare https:// URL, and a markdown link '
          'to a javascript: URL. safeHref refuses every scheme but '
          'http:, https:, and the two document-relative forms — the '
          'refused one keeps its label and loses its underline/colour '
          'entirely, rendering as the same plain text as everything '
          'around it.',
      specimen: _LinksSpecimen(),
      code: _linksCode,
      label: 'Links specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter and public static the three '
          'exported widgets declare, the two supporting classes, and '
          'safeHref / languageAliases. See this page\'s own library '
          'doc for why the markdown block model and its parser are not '
          'given tables of their own.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'AgentMarkdown', anchor: 'api-elagentmarkdown'),
        DocsTocEntry(title: 'AgentCodeBlock', anchor: 'api-elagentcodeblock'),
        DocsTocEntry(
          title: 'PreformattedCode',
          anchor: 'api-elpreformattedcode',
        ),
        DocsTocEntry(title: 'PrismPalette', anchor: 'api-elprismpalette'),
        DocsTocEntry(title: 'CodeToken', anchor: 'api-elcodetoken'),
        DocsTocEntry(
          title: 'Top-level functions',
          anchor: 'api-top-level-functions',
        ),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off AgentMarkdown._block, AgentCodeBlock.build and '
          'renderMarkdownInline, not inferred.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      child: _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: agentMarkdownDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/agent_markdown_test.dart',
            description:
                'Covers this page: the article mounts, the full API '
                'table, and every live specimen this page claims to '
                'show.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/agent_markdown/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class AgentMarkdownDocPage extends StatelessWidget {
  const AgentMarkdownDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: agentMarkdownDoc.route,
    intro: DocsPageIntro(
      title: agentMarkdownDoc.title,
      description: agentMarkdownDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Agent Markdown'),
    ],
    toc: agentMarkdownDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('agent-markdown-doc-article'),
      child: ComponentDocPage(spec: agentMarkdownDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

const String _previewSource = '''
### Findings

This deal is **strong**: comps average *12% below* list.

- Comparable #1 sold for \$420
- Comparable #2 sold for \$455

1. Confirm condition grade
2. Counter at \$410

> Sourced from three closed auctions in the last 30 days.

[View the comps](https://example.com/comps)''';

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: AgentMarkdown(
      key: ValueKey<String>('agent-markdown-preview:body'),
      text: _previewSource,
    ),
  );
}

const String _previewCode = r"""
AgentMarkdown(text: '''
### Findings

This deal is **strong**: comps average *12% below* list.

- Comparable #1 sold for \$420
- Comparable #2 sold for \$455

1. Confirm condition grade
2. Counter at \$410

> Sourced from three closed auctions in the last 30 days.

[View the comps](https://example.com/comps)
''')""";

const String _listsSource = '''
1. Confirm condition grade
2. Photograph all four corners

3. Counter at \$410
4. Include shipping in the offer

- First pull
- Second pull
- Third pull''';

class _ListsSpecimen extends StatelessWidget {
  const _ListsSpecimen();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: AgentMarkdown(
      key: ValueKey<String>('agent-markdown-example:lists'),
      text: _listsSource,
    ),
  );
}

const String _listsCode = r"""
AgentMarkdown(text: '''
1. Confirm condition grade
2. Photograph all four corners

3. Counter at \$410
4. Include shipping in the offer

- First pull
- Second pull
- Third pull
''')""";

const String _tableSource = '''
| Card | Grade | Price |
|:-----|:-----:|------:|
| Charizard | PSA 9 | \$420 |
| Blastoise | PSA 8 | \$180 |''';

class _TableSpecimen extends StatelessWidget {
  const _TableSpecimen();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: AgentMarkdown(
      key: ValueKey<String>('agent-markdown-example:table'),
      text: _tableSource,
    ),
  );
}

const String _tableCode = r"""
AgentMarkdown(text: '''
| Card | Grade | Price |
|:-----|:-----:|------:|
| Charizard | PSA 9 | \$420 |
| Blastoise | PSA 8 | \$180 |
''')""";

const String _codeBlockSource = '''
```ts
function total(items: Item[]): number {
  return items.reduce((sum, i) => sum + i.price, 0);
}
```

```swift
func total(items: [Item]) -> Int {
  items.reduce(0) { \$0 + \$1.price }
}
```''';

class _CodeBlockSpecimen extends StatelessWidget {
  const _CodeBlockSpecimen();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: AgentMarkdown(
      key: ValueKey<String>('agent-markdown-example:code-block'),
      text: _codeBlockSource,
    ),
  );
}

const String _codeBlockCode = r"""
AgentMarkdown(text: '''
```ts
function total(items: Item[]): number {
  return items.reduce((sum, i) => sum + i.price, 0);
}
```

```swift
func total(items: [Item]) -> Int {
  items.reduce(0) { \$0 + \$1.price }
}
```
''')""";

const String _linksSource = '''
[View the comps](https://example.com/comps)

https://example.com/bare-url

[Click me](javascript:evil)''';

class _LinksSpecimen extends StatelessWidget {
  const _LinksSpecimen();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: AgentMarkdown(
      key: ValueKey<String>('agent-markdown-example:links'),
      text: _linksSource,
    ),
  );
}

const String _linksCode = r"""
AgentMarkdown(text: '''
[View the comps](https://example.com/comps)

https://example.com/bare-url

[Click me](javascript:evil)
''')""";

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

AgentMarkdown(text: 'Model output, **bold** and all.')''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elagentmarkdown',
        child: DocsApiTable(title: 'AgentMarkdown', facts: _agentMarkdownFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elagentcodeblock',
        child: DocsApiTable(title: 'AgentCodeBlock', facts: _codeBlockFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elpreformattedcode',
        child: DocsApiTable(
          title: 'PreformattedCode',
          facts: _preformattedCodeFacts,
        ),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elprismpalette',
        child: DocsApiTable(title: 'PrismPalette', facts: _prismPaletteFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elcodetoken',
        child: DocsApiTable(title: 'CodeToken', facts: _codeTokenFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-top-level-functions',
        child: DocsApiTable(
          title: 'Top-level functions',
          facts: _functionFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _agentMarkdownFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String',
    description:
        'Required. The markdown source. parseMarkdown(text) '
        'runs on every build.',
  ),
  DocsApiFact(
    name: 'textAlign',
    type: 'TextAlign?',
    description:
        'Optional. Defaults to null (the reference\'s own inherited '
        'start). Applied to every paragraph-level block; a heading and a '
        'blockquote both honour it too.',
  ),
  DocsApiFact(
    name: 'blockGap',
    type: 'double',
    description:
        'Static. space(2) — 8. Margin-bottom on every block but the '
        'last.',
  ),
  DocsApiFact(
    name: 'listInset',
    type: 'double',
    description: 'Static. space(6) — 24. Both list forms\' own left inset.',
  ),
  DocsApiFact(
    name: 'itemGap',
    type: 'double',
    description: 'Static. space(1) — 4. Between list items.',
  ),
  DocsApiFact(
    name: 'quoteInset',
    type: 'double',
    description:
        'Static. space(4) — 16. Between a blockquote\'s rule and its '
        'text.',
  ),
  DocsApiFact(
    name: 'quoteRule',
    type: 'double',
    description:
        'Static. space(0.5) — 2. The blockquote\'s own left rule '
        'width.',
  ),
  DocsApiFact(
    name: 'quoteRuleAlpha',
    type: 'double',
    description:
        'Static. 0.40. theme.agentAccent at this alpha paints the rule.',
  ),
  DocsApiFact(
    name: 'cellPadX',
    type: 'double',
    description:
        'Static. space(3) — 12. Horizontal padding in every table '
        'cell.',
  ),
  DocsApiFact(
    name: 'cellPadY',
    type: 'double',
    description:
        'Static. space(2) — 8. Vertical padding in every table '
        'cell, before the half-hairline border correction.',
  ),
  DocsApiFact(
    name: 'headingTop',
    type: 'double',
    description: 'Static. space(1) — 4. A heading\'s own top margin.',
  ),
];

const List<DocsApiFact> _codeBlockFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'code',
    type: 'String',
    description: 'Required. The fence\'s own body, joined with newlines.',
  ),
  DocsApiFact(
    name: 'language',
    type: 'String?',
    description:
        'Optional. The fence\'s opening tag, e.g. "ts" — normalised '
        'through languageAliases before it decides which of the two '
        'render paths runs.',
  ),
  DocsApiFact(
    name: 'plainPadding',
    type: 'double',
    description:
        'Static. space(3) — 12. Padding on the un-highlighted '
        '(unrecognised-language) form.',
  ),
  DocsApiFact(
    name: 'stripPadX',
    type: 'double',
    description:
        'Static. space(3) — 12. Horizontal padding on the language '
        'header strip.',
  ),
  DocsApiFact(
    name: 'stripPadY',
    type: 'double',
    description:
        'Static. space(2) — 8. Vertical padding on the language '
        'header strip.',
  ),
  DocsApiFact(
    name: 'normalise(language)',
    type: 'String? Function(String?)',
    description:
        'Static method. Null for a null/empty language, or one not '
        'present in languageAliases — the exact condition that routes '
        'a fence to the plain, un-highlighted form.',
  ),
];

const List<DocsApiFact> _preformattedCodeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'code',
    type: 'String',
    description:
        'Required. Rendered one Text per line, unwrapped '
        '(softWrap: false).',
  ),
  DocsApiFact(
    name: 'color',
    type: 'Color?',
    description: 'Optional. Defaults to theme.foreground.',
  ),
];

const List<DocsApiFact> _prismPaletteFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ground',
    type: 'Color',
    description:
        'allow-hardcoded: #1e1e1e, vscDarkPlus\'s own background — never '
        'a theme token, on purpose. See Theming below.',
  ),
  DocsApiFact(
    name: 'plain',
    type: 'Color',
    description:
        'allow-hardcoded: #d4d4d4, the theme\'s plain-text '
        'colour.',
  ),
  DocsApiFact(
    name: 'keyword',
    type: 'Color',
    description: 'allow-hardcoded: #569cd6.',
  ),
  DocsApiFact(
    name: 'string',
    type: 'Color',
    description: 'allow-hardcoded: #ce9178.',
  ),
  DocsApiFact(
    name: 'number',
    type: 'Color',
    description: 'allow-hardcoded: #b5cea8.',
  ),
  DocsApiFact(
    name: 'function',
    type: 'Color',
    description: 'allow-hardcoded: #dcdcaa.',
  ),
  DocsApiFact(
    name: 'comment',
    type: 'Color',
    description: 'allow-hardcoded: #6a9955.',
  ),
  DocsApiFact(
    name: 'type',
    type: 'Color',
    description:
        'allow-hardcoded: #4ec9b0 (vscDarkPlus\'s class-name '
        'colour).',
  ),
  DocsApiFact(
    name: 'padding',
    type: 'double',
    description: 'allow-hardcoded: 13 (1em at the theme\'s own 13px).',
  ),
  DocsApiFact(
    name: 'margin',
    type: 'double',
    description:
        'allow-hardcoded: 6.5 (.5em) — real vertical space above '
        'and below the highlighted body.',
  ),
  DocsApiFact(
    name: 'lineHeight',
    type: 'double',
    description:
        'allow-hardcoded: 19.5 — 13px over Preflight\'s 1.5, and '
        'what actually sets a highlighted line\'s own height.',
  ),
];

const List<DocsApiFact> _codeTokenFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'text',
    type: 'String',
    description: 'Required. One coloured run of a tokenised line.',
  ),
  DocsApiFact(
    name: 'color',
    type: 'Color',
    description: 'Required. One of PrismPalette\'s own colours.',
  ),
];

const List<DocsApiFact> _functionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'safeHref(raw)',
    type: 'String? Function(String)',
    description:
        'A leading "/" or "#" passes through untouched (document-'
        'relative). Anything else must parse as a URL with scheme http '
        'or https, or this returns null. Refused input keeps its label '
        'and loses its link — see the Links specimen above.',
  ),
  DocsApiFact(
    name: 'languageAliases',
    type: 'Map<String, String>',
    description:
        'Fourteen keys — bash, css, js, javascript, json, jsx, md, '
        'markdown, py, python, sh, shell, sql, ts, tsx, typescript — '
        'each mapped to its normalised, printed name (js and jsx both '
        'print "javascript"/"jsx" as authored; sh and shell both '
        'normalise to "bash").',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No Semantics node of its own anywhere in agent_markdown.dart: '
            'the rendered Text/RichText widgets carry whatever default '
            'semantics Flutter gives a text node, and nothing here adds '
            'a role, a label, or a live region.',
        'A heading (### Findings) is not announced as a heading: '
            'RichText renders it in TextStyles.h4\'s visual style only — '
            'there is no Semantics.headingLevel or equivalent.',
        'A styled link is not announced as a link either, because it is '
            'not a link in Flutter\'s terms: a screen reader hears '
            'exactly the same plain text a sighted, non-interactive '
            'reader sees. See the Keyboard disclosure and the library '
            'doc above for the same fact from the other direction.',
        'Table cells carry no header/data cell distinction beyond visual '
            "weight (the header row's own bolder label type spec against "
            "body rows' smaller one): no Semantics-level table structure.",
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'AgentMarkdown takes no focus and binds no key: there is no '
            'Focus, no FocusNode, no onKeyEvent anywhere in '
            'agent_markdown.dart.',
        'A rendered link cannot be tabbed to, and cannot be activated by '
            'Enter or Space, because it is a TextSpan with a style and no '
            'recognizer — read straight off renderMarkdownInline\'s own '
            'link() helper. This is not a keyboard gap layered on top of '
            'a mouse-only control; there is no interaction at all to '
            'reach by any input method.',
        'A fenced code block\'s horizontal scroll (_Scroller, a bare '
            'SingleChildScrollView) answers a trackpad or a mouse wheel '
            'but has no keyboard scroll binding of its own beyond '
            'whatever Flutter\'s default Scrollable gives a focused '
            'scroll view.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching anywhere in agent_markdown.dart: '
            'BuildContext width is never read for a layout decision.',
        'A table does not scroll horizontally — DOCUMENTED DRIFT the '
            'source itself flags: the reference wraps its table in '
            'overflow-x-auto, a Flutter Table shrink-wraps to its box '
            'instead, matching CSS table-layout: auto until the '
            'min-content width is exceeded.',
        'A fenced code block does scroll horizontally '
            '(SingleChildScrollView, Axis.horizontal): white-space: pre '
            'gives the reference no choice either.',
        'Column widths split the leftover space equally rather than '
            'proportionally to content, a second documented divergence '
            'from Chrome\'s own table layout — every cell in this page\'s '
            'own specimens is one line at either width, so no row height '
            'moves either way.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/agent_markdown.dart. No companion '
            'parts.',
        'Flutter imports: package:flutter/widgets.dart.',
        'Foundation imports: spacing.dart (space()), theme.dart, '
            'typography.dart, text_layout.dart (LineBox, InlineBox, '
            'engineLineHeight — for the code block\'s own line-box '
            'math), theme_scope.dart (StyledText, RichText, ThemeScope).',
        'No component imports at all: agent_markdown.dart reaches for no '
            'other file under lib/src/components/ui/, which is the whole of '
            'why registryDependencies is exactly one entry.',
        'registryDependencies, resolved automatically by `elattar add '
            'agent-markdown`: source-foundation — copied verbatim from '
            'registry/components/agent-markdown.json.',
        'This component has no cross-component links to offer: nothing '
            'else on this system is named in its Dependencies.',
      ]);
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Prose colours are read live off ThemeScope.of(context) at build '
            'time: theme.foreground (body text, table headers-row text '
            'colour choice aside), theme.mutedForeground (a blockquote), '
            'theme.agentAccent (a link\'s ink and a blockquote\'s rule), '
            'theme.border (a fence\'s and a table\'s own frame), '
            'theme.muted (inline code\'s chip fill and a plain code '
            'block\'s background). Flipping ThemeController re-'
            'resolves every one on the next frame.',
        'The highlighted code body is the one deliberate exception: '
            'PrismPalette is a fixed vscDarkPlus palette, never a '
            'theme.* getter, and stays visually identical in both light '
            'and dark ColorMode — the source\'s own comment says why, '
            'react-syntax-highlighter writes the theme as inline styles '
            'that beat every class on the element, so the port keeps '
            'that same fixed appearance rather than inventing a '
            'theme-aware syntax palette the reference never had.',
        'No override hatch: AgentMarkdown takes no colour parameter of '
            'its own beyond textAlign\'s layout effect. Restyling prose '
            'colours means changing the active ThemeTokens, not passing '
            'an argument here.',
      ]);
}

Widget _bullets(ThemeTokens theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: StyledText(
          '•  $line',
          TextStyles.small,
          color: theme.mutedForeground,
        ),
      ),
      SizedBox(height: space(2)),
    ],
  ],
);

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Empty / unparsed',
    treatment:
        'parseMarkdown(text) produces no blocks: '
        'AgentMarkdown.build returns SizedBox.shrink().',
    userSignal:
        'An empty string, or one that parses to nothing, renders '
        'nothing at all.',
  ),
  DocsStateFact(
    state: 'Recognised language fence',
    treatment:
        'AgentCodeBlock.normalise(language) is non-null: a '
        'header strip plus a Prism-tokenised body on PrismPalette.',
    userSignal: 'The ts block in Code block above.',
  ),
  DocsStateFact(
    state: 'Unrecognised or missing language',
    treatment:
        'normalise(language) is null: a plain --muted block, no '
        'strip, no tokenising — PreformattedCode on theme.foreground.',
    userSignal: 'The swift block in Code block above.',
  ),
  DocsStateFact(
    state: 'Safe link',
    treatment:
        'safeHref resolves a scheme: link() renders an '
        'underlined, theme.agentAccent-coloured TextSpan.',
    userSignal:
        'Styled, but still not tappable — see the library doc '
        'and Keyboard above.',
  ),
  DocsStateFact(
    state: 'Refused link',
    treatment:
        'safeHref returns null: the label renders as a plain, '
        'unstyled TextSpan.',
    userSignal: 'Reads identically to the surrounding sentence.',
  ),
];
