/// Public documentation page for the `bubble` component.
///
/// `bubble` is not one widget but a small family: [Bubble] owns the box —
/// `w-fit max-w-[80%]`, the alignment, the reactions rail's anchor point —
/// and paints nothing itself; [BubbleContent] is the surface that knows a
/// variant's fill, border and ink, and can become a real control by passing
/// [BubbleContent.onPressed]; [BubbleReactions] is the pill rail that
/// hangs off any corner; [BubbleGroup] stacks a run of bubbles with the
/// reference's own 8px gap.
///
/// This page is new — `bubble` had no page before this pass — built from
/// `lib/src/components/ui/bubble.dart` end to end and from the live specimens
/// already staged on `example/lib/pages/chat.dart`'s "Bubble" section, reused
/// here rather than invented fresh, per the rollout's own brief.
///
/// **Section order**, matching the house shape: Preview, Installation,
/// Usage, then one showcase per variant the `BubbleVariant` enum actually
/// has (seven), then Alignment, As Child, Reactions and Reactions with
/// Counts, then the eight disclosures.
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

final ComponentDocSpec bubbleDocSpec = ComponentDocSpec(
  name: 'bubble',
  title: bubbleDoc.title,
  description: bubbleDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'All seven BubbleVariant values, side by side, each carrying '
          'the same one-line copy so the fill is the only thing that '
          'changes.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'bubble has a real registry manifest, `elattar add bubble` '
          'installs lib/src/components/ui/bubble.dart and resolves '
          'press and source-foundation automatically. The Manual '
          'tab is for a project not using the CLI.',
      command: bubbleDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/bubble.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/bubble.dart's generated "
              '@ui/bubble.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated bubble source here when using manual '
              'mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so Bubble and its five companion '
              'classes and four enums are reachable the same way the CLI '
              'path already makes them.',
          code: "export 'bubble.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction. Every example '
          'below only changes named arguments on top of this.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'default',
      title: 'Default',
      description:
          "BubbleVariant.normal — the constructor's own default, named "
          '`default` in the cva source but BubbleVariant.normal here '
          'because default is a Dart keyword. theme.primary fill under '
          'theme.primaryForeground text: the sender\'s own turn.',
      specimen: _DefaultSpecimen(),
      code: _defaultCode,
      label: 'Default specimen view',
    ),
    ShowcaseSection(
      id: 'secondary',
      title: 'Secondary',
      description:
          'BubbleVariant.secondary: theme.secondary fill under '
          'theme.secondaryForeground text — the other party in the '
          'exchange.',
      specimen: _SecondarySpecimen(),
      code: _secondaryCode,
      label: 'Secondary specimen view',
    ),
    ShowcaseSection(
      id: 'muted',
      title: 'Muted',
      description:
          'BubbleVariant.muted: theme.muted fill under theme.foreground '
          'text — a quieter turn, often shown on a card surface.',
      specimen: _MutedSpecimen(),
      code: _mutedCode,
      label: 'Muted specimen view',
    ),
    ShowcaseSection(
      id: 'tinted',
      title: 'Tinted',
      description:
          'BubbleVariant.tinted: theme.messageAccent, a brand wash token '
          'derived from theme.primary rather than an inline dark: twin — '
          'lightness 0.93 in light, 0.30 in dark.',
      specimen: _TintedSpecimen(),
      code: _tintedCode,
      label: 'Tinted specimen view',
    ),
    ShowcaseSection(
      id: 'outline',
      title: 'Outline',
      description:
          'BubbleVariant.outline: theme.background fill, theme.border '
          'border — the one variant whose border is not transparent at '
          'rest.',
      specimen: _OutlineSpecimen(),
      code: _outlineCode,
      label: 'Outline specimen view',
    ),
    ShowcaseSection(
      id: 'ghost',
      title: 'Ghost',
      description:
          'BubbleVariant.ghost: no fill, no padding, no radius, and the '
          'only variant exempt from the 80% width cap — reach for it to '
          'set a long answer flush in the column rather than boxed in a '
          'bubble.',
      specimen: _GhostSpecimen(),
      code: _ghostCode,
      label: 'Ghost specimen view',
    ),
    ShowcaseSection(
      id: 'destructive',
      title: 'Destructive',
      description:
          'BubbleVariant.destructive: theme.destructive at 10% alpha '
          '(20% in dark) under theme.destructiveText — not '
          'theme.destructive text, which the source flags as a fill-end '
          'colour that does not carry text on its own.',
      specimen: _DestructiveSpecimen(),
      code: _destructiveCode,
      label: 'Destructive specimen view',
    ),
    ShowcaseSection(
      id: 'alignment',
      title: 'Alignment',
      description:
          'align is start (default) or end, the only alignment control in '
          'the family. Inside a Message it also follows that message\'s own '
          'align, which is why setting both is redundant rather than '
          'wrong.',
      specimen: _AlignmentSpecimen(),
      code: _alignmentCode,
      label: 'Alignment specimen view',
    ),
    ShowcaseSection(
      id: 'as-child',
      title: 'As Child',
      description:
          'Pass BubbleContent.onPressed and the whole surface becomes '
          'the control: hover, a 250ms colour sweep on MotionCurves.enter, and a '
          'focus ring all activate — none of which paint on the inert div '
          'form above. Hover this specimen to see the fill move.',
      specimen: _AsChildSpecimen(),
      code: _asChildCode,
      label: 'As Child specimen view',
    ),
    ShowcaseSection(
      id: 'reactions',
      title: 'Reactions',
      description:
          "The bare rail — pass BubbleReactions.children instead of "
          'reactions — at all four side x align corners. The rail rings '
          'in theme.card, so it needs a card surface under it or the ring '
          'reads as a halo; this specimen supplies one.',
      specimen: _ReactionsSpecimen(),
      code: _reactionsCode,
      label: 'Reactions specimen view',
      minHeight: space(160),
    ),
    ShowcaseSection(
      id: 'reactions-counts',
      title: 'Reactions with Counts',
      description:
          'Pass BubbleReactions.reactions instead, and each pill grows a '
          'count. showCount.hover collapses it until hover or focus; '
          'showCount.always keeps it open — the accessible name carries '
          'the count either way, so no information ever lives in the '
          'hover state alone. The first pill in each rail is mine: true, '
          'carrying its own border, fill and aria-pressed.',
      specimen: _ReactionCountsSpecimen(),
      code: _reactionCountsCode,
      label: 'Reactions with Counts specimen view',
      minHeight: space(160),
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter each exported class declares, '
          'every field BubbleReaction carries, and every value of the '
          'four enums bubble.dart exports: one table per class or enum.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'Bubble', anchor: 'api-elbubble'),
        DocsTocEntry(title: 'BubbleContent', anchor: 'api-elbubblecontent'),
        DocsTocEntry(title: 'BubbleGroup', anchor: 'api-elbubblegroup'),
        DocsTocEntry(title: 'BubbleReactions', anchor: 'api-elbubblereactions'),
        DocsTocEntry(title: 'BubbleReaction', anchor: 'api-elbubblereaction'),
        DocsTocEntry(title: 'BubbleVariant', anchor: 'api-elbubblevariant'),
        DocsTocEntry(title: 'BubbleAlign', anchor: 'api-elbubblealign'),
        DocsTocEntry(title: 'BubbleSide', anchor: 'api-elbubbleside'),
        DocsTocEntry(title: 'ShowCount', anchor: 'api-elshowcount'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read off _BubbleContentState._fill / _ink and '
          '_ReactionPillState.build, not inferred.',
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
            value: bubbleDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/chat_test.dart',
            description:
                'Bubble, BubbleContent and BubbleReactions are '
                'covered inside the shared chat-family suite alongside '
                'message and message-scroller: there is no dedicated '
                'bubble_test.dart in the package yet.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/bubble_test.dart',
            description:
                'Covers this page: the article mounts, the full API '
                'table, a live specimen of every variant, and both themes '
                'at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/bubble/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class BubbleDocPage extends StatelessWidget {
  const BubbleDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: bubbleDoc.route,
    intro: DocsPageIntro(
      title: bubbleDocSpec.title,
      description: bubbleDocSpec.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Bubble'),
    ],
    toc: bubbleDocSpec.toc,
    previous: const DocsPageLink(title: 'Card', route: '/components/card'),
    next: const DocsPageLink(title: 'Message', route: '/components/message'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('bubble-doc-article'),
      child: ComponentDocPage(spec: bubbleDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

const List<(BubbleVariant, String)> _variants = <(BubbleVariant, String)>[
  (BubbleVariant.normal, "the sender's own turn"),
  (BubbleVariant.secondary, 'the other party'),
  (BubbleVariant.muted, 'quieter, on a card'),
  (BubbleVariant.tinted, 'brand wash, per theme'),
  (BubbleVariant.outline, 'hairline, no fill'),
  (BubbleVariant.ghost, 'no bubble at all'),
  (BubbleVariant.destructive, 'failed to send'),
];

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: space(2)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final (BubbleVariant variant, String note) in _variants) ...[
            KeyedSubtree(
              key: ValueKey<String>('bubble-preview:${variant.name}'),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Bubble(
                    variant: variant,
                    child: BubbleContent(child: Text(variant.label)),
                  ),
                  SizedBox(height: space(2)),
                  StyledText(note, TextStyles.small, align: TextAlign.center),
                ],
              ),
            ),
            SizedBox(width: space(4)),
          ],
        ],
      ),
    ),
  );
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'Row(\n'
    '  children: [\n'
    '    Bubble(child: BubbleContent(child: Text(\'default\'))),\n'
    '    Bubble(\n'
    '      variant: BubbleVariant.secondary,\n'
    "      child: BubbleContent(child: Text('secondary')),\n"
    '    ),\n'
    '    Bubble(\n'
    '      variant: BubbleVariant.muted,\n'
    "      child: BubbleContent(child: Text('muted')),\n"
    '    ),\n'
    '    Bubble(\n'
    '      variant: BubbleVariant.tinted,\n'
    "      child: BubbleContent(child: Text('tinted')),\n"
    '    ),\n'
    '    Bubble(\n'
    '      variant: BubbleVariant.outline,\n'
    "      child: BubbleContent(child: Text('outline')),\n"
    '    ),\n'
    '    Bubble(\n'
    '      variant: BubbleVariant.ghost,\n'
    "      child: BubbleContent(child: Text('ghost')),\n"
    '    ),\n'
    '    Bubble(\n'
    '      variant: BubbleVariant.destructive,\n'
    "      child: BubbleContent(child: Text('destructive')),\n"
    '    ),\n'
    '  ],\n'
    ')';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

Bubble(
  child: BubbleContent(
    child: Text('Up 14% overnight'),
  ),
)''';

class _DefaultSpecimen extends StatelessWidget {
  const _DefaultSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('bubble-example:default'),
    child: const Bubble(
      child: BubbleContent(child: Text('Eclipse Vault is up 14% overnight.')),
    ),
  );
}

const String _defaultCode = '''
Bubble(
  child: BubbleContent(
    child: Text('Eclipse Vault is up 14% overnight.'),
  ),
)''';

class _SecondarySpecimen extends StatelessWidget {
  const _SecondarySpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('bubble-example:secondary'),
    child: const Bubble(
      variant: BubbleVariant.secondary,
      child: BubbleContent(child: Text('Which three?')),
    ),
  );
}

const String _secondaryCode = '''
Bubble(
  variant: BubbleVariant.secondary,
  child: BubbleContent(child: Text('Which three?')),
)''';

class _MutedSpecimen extends StatelessWidget {
  const _MutedSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('bubble-example:muted'),
    child: const Bubble(
      variant: BubbleVariant.muted,
      child: BubbleContent(child: Text('Nice pull')),
    ),
  );
}

const String _mutedCode = '''
Bubble(
  variant: BubbleVariant.muted,
  child: BubbleContent(child: Text('Nice pull')),
)''';

class _TintedSpecimen extends StatelessWidget {
  const _TintedSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('bubble-example:tinted'),
    child: const Bubble(
      variant: BubbleVariant.tinted,
      child: BubbleContent(child: Text('Set. I will watch it.')),
    ),
  );
}

const String _tintedCode = '''
Bubble(
  variant: BubbleVariant.tinted,
  child: BubbleContent(child: Text('Set. I will watch it.')),
)''';

class _OutlineSpecimen extends StatelessWidget {
  const _OutlineSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('bubble-example:outline'),
    child: const Bubble(
      variant: BubbleVariant.outline,
      child: BubbleContent(child: Text('Six cards, two of them graded.')),
    ),
  );
}

const String _outlineCode = '''
Bubble(
  variant: BubbleVariant.outline,
  child: BubbleContent(child: Text('Six cards, two of them graded.')),
)''';

class _GhostSpecimen extends StatelessWidget {
  const _GhostSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('bubble-example:ghost'),
    child: const Bubble(
      variant: BubbleVariant.ghost,
      child: BubbleContent(
        child: Text(
          'It is concentrated: four accounts account for most of the '
          'volume, and all four bought within the same eleven minutes.',
        ),
      ),
    ),
  );
}

const String _ghostCode = '''
Bubble(
  variant: BubbleVariant.ghost,
  child: BubbleContent(
    child: Text('It is concentrated: four accounts account for most of it.'),
  ),
)''';

class _DestructiveSpecimen extends StatelessWidget {
  const _DestructiveSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('bubble-example:destructive'),
    child: const Bubble(
      variant: BubbleVariant.destructive,
      child: BubbleContent(child: Text('Failed to send. Tap to retry.')),
    ),
  );
}

const String _destructiveCode = '''
Bubble(
  variant: BubbleVariant.destructive,
  child: BubbleContent(child: Text('Failed to send. Tap to retry.')),
)''';

class _AlignmentSpecimen extends StatelessWidget {
  const _AlignmentSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('bubble-example:alignment'),
    child: BubbleGroup(
      children: const <Widget>[
        Bubble(
          variant: BubbleVariant.secondary,
          child: BubbleContent(child: Text('Which three?')),
        ),
        Bubble(
          align: BubbleAlign.end,
          child: BubbleContent(
            child: Text('Eclipse, Origin Pulse and Nightfall.'),
          ),
        ),
      ],
    ),
  );
}

const String _alignmentCode = '''
BubbleGroup(
  children: [
    Bubble(
      variant: BubbleVariant.secondary,
      child: BubbleContent(child: Text('Which three?')),
    ),
    Bubble(
      align: BubbleAlign.end,
      child: BubbleContent(
        child: Text('Eclipse, Origin Pulse and Nightfall.'),
      ),
    ),
  ],
)''';

class _AsChildSpecimen extends StatelessWidget {
  const _AsChildSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('bubble-example:as-child'),
    child: Bubble(
      child: BubbleContent(onPressed: () {}, child: const Text('Open the set')),
    ),
  );
}

const String _asChildCode = '''
Bubble(
  child: BubbleContent(
    onPressed: () {},
    child: const Text('Open the set'),
  ),
)''';

class _ReactionsSpecimen extends StatelessWidget {
  const _ReactionsSpecimen();

  static const List<(BubbleSide, BubbleAlign)> _corners =
      <(BubbleSide, BubbleAlign)>[
        (BubbleSide.bottom, BubbleAlign.end),
        (BubbleSide.bottom, BubbleAlign.start),
        (BubbleSide.top, BubbleAlign.end),
        (BubbleSide.top, BubbleAlign.start),
      ];

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return KeyedSubtree(
      key: const ValueKey<String>('bubble-example:reactions'),
      child: ColoredBox(
        color: theme.card,
        child: Padding(
          padding: EdgeInsets.all(space(6)),
          child: Wrap(
            spacing: space(8),
            runSpacing: space(8),
            children: <Widget>[
              for (final (BubbleSide side, BubbleAlign align) in _corners)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Bubble(
                      variant: BubbleVariant.muted,
                      reactions: BubbleReactions(
                        side: side,
                        align: align,
                        children: const <Widget>[Text('🔥'), Text('❤️')],
                      ),
                      child: const BubbleContent(child: Text('Nice pull')),
                    ),
                    SizedBox(height: space(6)),
                    StyledText(
                      '${side.name} · ${align.name}',
                      TextStyles.small,
                      align: TextAlign.center,
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

const String _reactionsCode = '''
Bubble(
  variant: BubbleVariant.muted,
  reactions: BubbleReactions(
    side: BubbleSide.bottom,
    align: BubbleAlign.end,
    children: [Text('🔥'), Text('❤️')],
  ),
  child: const BubbleContent(child: Text('Nice pull')),
)''';

class _ReactionCountsSpecimen extends StatelessWidget {
  const _ReactionCountsSpecimen();

  static const List<BubbleReaction> _reactions = <BubbleReaction>[
    BubbleReaction(emoji: '🔥', count: 12, label: 'fire', mine: true),
    BubbleReaction(emoji: '❤️', count: 8, label: 'a heart'),
    BubbleReaction(emoji: '👏', count: 3, label: 'applause'),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return KeyedSubtree(
      key: const ValueKey<String>('bubble-example:reactions-counts'),
      child: ColoredBox(
        color: theme.card,
        child: Padding(
          padding: EdgeInsets.all(space(6)),
          child: Wrap(
            spacing: space(10),
            runSpacing: space(8),
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Bubble(
                    variant: BubbleVariant.muted,
                    reactions: const BubbleReactions(reactions: _reactions),
                    child: const BubbleContent(child: Text('Nice pull')),
                  ),
                  SizedBox(height: space(6)),
                  StyledText(
                    'showCount: hover (default)',
                    TextStyles.small,
                    align: TextAlign.center,
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Bubble(
                    variant: BubbleVariant.muted,
                    reactions: const BubbleReactions(
                      reactions: _reactions,
                      showCount: ShowCount.always,
                    ),
                    child: const BubbleContent(child: Text('Nice pull')),
                  ),
                  SizedBox(height: space(6)),
                  StyledText(
                    'showCount: always',
                    TextStyles.small,
                    align: TextAlign.center,
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

const String _reactionCountsCode = '''
const reactions = [
  BubbleReaction(emoji: '🔥', count: 12, label: 'fire', mine: true),
  BubbleReaction(emoji: '❤️', count: 8, label: 'a heart'),
  BubbleReaction(emoji: '👏', count: 3, label: 'applause'),
];

Bubble(
  variant: BubbleVariant.muted,
  reactions: BubbleReactions(reactions: reactions),
  child: const BubbleContent(child: Text('Nice pull')),
)''';

/* ── API Reference ──────────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsAnchor(
        id: 'api-elbubble',
        child: const DocsApiTable(title: 'Bubble', facts: _bubbleFacts),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elbubblecontent',
        child: const DocsApiTable(
          title: 'BubbleContent',
          facts: _bubbleContentFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elbubblegroup',
        child: const DocsApiTable(
          title: 'BubbleGroup',
          facts: _bubbleGroupFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elbubblereactions',
        child: const DocsApiTable(
          title: 'BubbleReactions',
          facts: _bubbleReactionsFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elbubblereaction',
        child: const DocsApiTable(
          title: 'BubbleReaction',
          facts: _bubbleReactionFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elbubblevariant',
        child: const DocsApiTable(
          title: 'BubbleVariant',
          facts: _bubbleVariantFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elbubblealign',
        child: const DocsApiTable(
          title: 'BubbleAlign',
          facts: _bubbleAlignFacts,
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elbubbleside',
        child: const DocsApiTable(title: 'BubbleSide', facts: _bubbleSideFacts),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-elshowcount',
        child: const DocsApiTable(title: 'ShowCount', facts: _showCountFacts),
      ),
    ],
  );
}

const List<DocsApiFact> _bubbleFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        'Required. Usually an BubbleContent, or whatever the call site '
        'stacks in the column.',
  ),
  DocsApiFact(
    name: 'variant',
    type: 'BubbleVariant',
    description:
        'Optional. Defaults to BubbleVariant.normal. Forwarded to the '
        'child BubbleContent through an inherited scope.',
  ),
  DocsApiFact(
    name: 'align',
    type: 'BubbleAlign',
    description:
        'Optional. Defaults to BubbleAlign.start. Inside a Message the '
        "message's own align wins when this is left at its default.",
  ),
  DocsApiFact(
    name: 'reactions',
    type: 'BubbleReactions?',
    description:
        'Optional. Defaults to null. Absolutely positioned against this '
        "bubble and pulled three quarters outside it — needs vertical "
        'room around it.',
  ),
];

const List<DocsApiFact> _bubbleContentFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description: 'Required. The bubble copy — usually a Text.',
  ),
  DocsApiFact(
    name: 'onPressed',
    type: 'VoidCallback?',
    description:
        'Optional. Defaults to null. Passing one is the port of asChild: '
        'the whole surface becomes a control, with a hover fill and a '
        'focus ring. Left null the surface is inert.',
  ),
  DocsApiFact(
    name: 'semanticsLabel',
    type: 'String?',
    description:
        'Optional. Defaults to null. The accessible name when the '
        'surface is a control and its child is not a plain string.',
  ),
];

const List<DocsApiFact> _bubbleGroupFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>',
    description:
        'Required. A run of Bubble in a column, 8px apart — one per '
        'conversation, or one per run of turns from the same sender.',
  ),
];

const List<DocsApiFact> _bubbleReactionsFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'side',
    type: 'BubbleSide',
    description: 'Optional. Defaults to BubbleSide.bottom.',
  ),
  DocsApiFact(
    name: 'align',
    type: 'BubbleAlign',
    description: 'Optional. Defaults to BubbleAlign.end.',
  ),
  DocsApiFact(
    name: 'reactions',
    type: 'List<BubbleReaction>?',
    description:
        'Optional. Defaults to null. Draws data pills with counts; '
        'exclusive with children.',
  ),
  DocsApiFact(
    name: 'showCount',
    type: 'ShowCount',
    description: 'Optional. Defaults to ShowCount.hover.',
  ),
  DocsApiFact(
    name: 'onReact',
    type: 'void Function(String label)?',
    description:
        "Optional. Defaults to null. Fired with the reaction's label when "
        'a pill is pressed.',
  ),
  DocsApiFact(
    name: 'children',
    type: 'List<Widget>?',
    description:
        'Optional. Defaults to null. The bare rail form — exclusive with '
        'reactions.',
  ),
];

const List<DocsApiFact> _bubbleReactionFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'emoji',
    type: 'String',
    description:
        'Required. The one place in the corpus the "no emoji as UI" rule '
        'does not apply.',
  ),
  DocsApiFact(name: 'count', type: 'int', description: 'Required.'),
  DocsApiFact(
    name: 'label',
    type: 'String',
    description:
        'Required. What the emoji means, for the accessible name — '
        '"a heart".',
  ),
  DocsApiFact(
    name: 'mine',
    type: 'bool',
    description:
        'Optional. Defaults to false. Has the reader already reacted '
        'this way? Carries a border and a fill and aria-pressed, never '
        'a hue alone.',
  ),
];

const List<DocsApiFact> _bubbleVariantFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'normal',
    type: 'enum value',
    description:
        "The constructor default (label: 'default'). theme.primary fill, "
        'theme.primaryForeground text.',
  ),
  DocsApiFact(
    name: 'secondary',
    type: 'enum value',
    description: 'theme.secondary fill, theme.secondaryForeground text.',
  ),
  DocsApiFact(
    name: 'muted',
    type: 'enum value',
    description: 'theme.muted fill, theme.foreground text.',
  ),
  DocsApiFact(
    name: 'tinted',
    type: 'enum value',
    description:
        'theme.messageAccent fill, theme.foreground text: a token derived '
        'from theme.primary, not an inline dark: twin.',
  ),
  DocsApiFact(
    name: 'outline',
    type: 'enum value',
    description:
        'theme.background fill, theme.border border, theme.foreground '
        'text — the one variant whose border is not transparent.',
  ),
  DocsApiFact(
    name: 'ghost',
    type: 'enum value',
    description:
        'No fill, no padding, no radius, exempt from the 80% width cap.',
  ),
  DocsApiFact(
    name: 'destructive',
    type: 'enum value',
    description:
        'theme.destructive at 10%/20% alpha fill, theme.destructiveText '
        'text.',
  ),
];

const List<DocsApiFact> _bubbleAlignFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'start',
    type: 'enum value',
    description: 'The default. Aligned to the start of the column.',
  ),
  DocsApiFact(
    name: 'end',
    type: 'enum value',
    description: 'Aligned to the end — the sender\'s own turn.',
  ),
];

const List<DocsApiFact> _bubbleSideFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'top',
    type: 'enum value',
    description: 'The reactions rail hangs off the top-0 corner.',
  ),
  DocsApiFact(
    name: 'bottom',
    type: 'enum value',
    description: 'The default. The rail hangs off the bottom-0 corner.',
  ),
];

const List<DocsApiFact> _showCountFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'hover',
    type: 'enum value',
    description:
        'The default. The count is 0-width and transparent until hover '
        'or focus, then opens to 16px over 250ms.',
  ),
  DocsApiFact(
    name: 'always',
    type: 'enum value',
    description: 'The count stays open, with no transition of its own.',
  ),
];

/* ── States ──────────────────────────────────────────────────────────────── */

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest (div form)',
    treatment:
        "Each variant's own fill/border/ink, painted with a 0s "
        'transition — nothing about an inert bubble ever animates.',
    userSignal: 'A static surface.',
  ),
  DocsStateFact(
    state: 'Hover (asChild only)',
    treatment:
        'Pointer-only, and only when onPressed is set. Fill and ink '
        'sweep over 250ms on MotionCurves.enter.',
    userSignal: 'A lit surface under the pointer — never on a bare div.',
  ),
  DocsStateFact(
    state: 'Focus-visible (asChild only)',
    treatment:
        'A 3px ring at theme.ring 50% alpha springs open on the same '
        'colour clock.',
    userSignal: 'A ring around the bubble on keyboard focus.',
  ),
  DocsStateFact(
    state: 'Reaction hover/focus',
    treatment:
        "A pill's count reveals from 0 to 16px width over 250ms on "
        'MotionCurves.enter — unless showCount is always, which never '
        'transitions.',
    userSignal: 'The number widens out of nothing under the pointer.',
  ),
  DocsStateFact(
    state: 'Reaction pressed',
    treatment:
        'Press: 40ms down to 0.94 scale, 250ms spring back — the same '
        'press primitive Button uses.',
    userSignal: 'A physical squish on tap.',
  ),
  DocsStateFact(
    state: 'Reaction mine',
    treatment:
        'BubbleReaction.mine: true tints the pill border and fill at '
        'Palette.action and sets aria-pressed.',
    userSignal:
        'A reacted-to pill reads differently at rest, not only on '
        'hover.',
  ),
];

/* ── Prose disclosures ──────────────────────────────────────────────────── */

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Semantic role: the inert div form mounts no Semantics node of its '
            'own. The asChild form (BubbleContent.onPressed set) wraps '
            'itself in Semantics(button: true), with semanticsLabel as an '
            'override when the child is not a plain string.',
        'Reaction pills always carry Semantics(button: true, toggled: '
            'r.mine, label: "8 reacted with a heart") — the count is in the '
            'accessible name at rest, in both showCount modes, so a screen '
            'reader or keyboard user never has to trigger a hover to learn '
            'it.',
        'Focus ring: 3px spread at theme.ring 50% alpha, on the asChild '
            'surface and every reaction pill, keyboard-only — Flutter does '
            'not focus a bare pointer tap.',
        'Contrast: two of the seven variants measure under AA — normal at '
            '4.39:1 in both themes (inherited from theme.primary under '
            'theme.primaryForeground, the same figure every primary '
            'surface in the corpus shares) and destructive at 4.12:1 on '
            'light. Recorded here rather than corrected: the fix is a '
            'token move that reaches every call site of those two colours, '
            'not a change local to this component.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'The div form takes no focus and answers no key: bubble.dart wires '
            'no Focus or key handler on it at all.',
        'The asChild form (onPressed set) wraps a Focus that tracks '
            'hasFocus for the ring, and a GestureDetector for the tap — '
            'but the source wires no explicit key handler either; '
            'activation on Enter/Space is whatever the ambient '
            'GestureDetector/Focus stack in the surrounding app already '
            'provides, not a bubble.dart-specific onKey.',
        'A reaction pill wraps its own Focus for the ring and its own '
            'Press for the tap, the same pattern.',
        'No custom traversal order: nothing here declares a '
            'FocusTraversalPolicy.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching anywhere in bubble.dart: BuildContext '
            'width is never read for a layout decision.',
        'Every bubble caps itself at 80% of the column it is in — a '
            '_MaxWidthFraction render object, not a LayoutBuilder, so '
            'intrinsic queries (Grid measuring a cell) still pass '
            'through. ghost is exempt at 100%.',
        'Every measurement (padding, gap, focus ring, rail inset) is a '
            'fixed 4px-grid value from space(), never keyed to viewport.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/bubble.dart — one file, no companions; '
            'the registry manifest lists exactly one entry under "files".',
        'Flutter imports: package:flutter/rendering.dart '
            '(RenderProxyBox/RenderStack, the width-cap and reactions-'
            'overflow render objects), package:flutter/widgets.dart.',
        'Foundation imports: foundation/colors.dart (OklabColor, '
            'transparent), foundation/motion.dart (effectiveMotionDuration), '
            'foundation/shadows.dart (the focus ring), '
            'foundation/spacing.dart (space()), foundation/theme.dart, '
            'foundation/typography.dart, theme_scope.dart.',
        'Motion import: motion/press.dart (Press — the reaction pill\'s '
            'own press feedback).',
        'registryDependencies, resolved automatically by `elattar add '
            'bubble`: press, source-foundation — copied verbatim '
            'from registry/components/bubble.json.',
      ]),
      SizedBox(height: space(2)),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: DocsLinkRow(
          links: <DocsLink>[
            DocsLink(label: 'Message', route: '/components/message'),
            DocsLink(
              label: 'Message Scroller',
              route: '/components/message-scroller',
            ),
            DocsLink(label: 'Press Motion', route: '/components/press'),
          ],
        ),
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Every colour is read live off ThemeScope.of(context) at build time: '
            'theme.primary/primaryForeground (normal), theme.secondary/'
            'secondaryForeground (secondary), theme.muted/foreground '
            '(muted), theme.messageAccent/messageAccentHover/foreground '
            '(tinted), theme.background/border/foreground (outline), '
            'theme.muted/foreground (ghost hover), theme.destructive/'
            'destructiveText (destructive), theme.ring (the focus ring on '
            'every variant, no destructive-only special case here unlike '
            'Button).',
        'tinted is a token, not an inline dark: twin: theme.messageAccent is '
            'declared once per theme block and derived from theme.primary, '
            'so it follows a rebrand automatically.',
        'Shape: rounded-xl (Radii.xl) on every variant but ghost, which '
            'drops to rounded-none — bubble.dart exposes no radius '
            'override at all.',
        'The reactions rail rings in theme.card at a fixed 3px spread — '
            'not a theme-aware default with an override field the way '
            'Card exposes ringColor. A caller wanting a different ring '
            'colour has no escape hatch here.',
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
