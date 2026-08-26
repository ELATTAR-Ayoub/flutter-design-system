/// Public documentation page for the `media-scrim` effect.
///
/// **Not a component.** `lib/src/effects/media_scrim.dart` exports one
/// `StatelessWidget`, `ElMediaScrim`, with exactly one constructor
/// parameter (`child`) and no variant, size, or enum of its own: a
/// `DecoratedBox` painting a fixed top-to-bottom `LinearGradient` — fully
/// transparent at the top, a neutral ink rising only toward the bottom
/// edge — so title and action copy laid over media stays legible without
/// an opaque information card.
///
/// **House shape, effect edition.** Preview, Installation, Usage, then one
/// `EffectSection` per facet the effect actually has, then the same eight
/// disclosures every component page carries. Both `EffectSection`s below
/// stage a media block standing in for a real asset (a themed gradient,
/// since this page ships no binary image) beside the same block without
/// the scrim, so the legibility difference is the thing on screen.
///
/// **Real use, not invented.** `example/lib/showcase/showcase_reels.dart`
/// (`_ReelOverlay.build`) is the one real caller in the corpus:
/// `Positioned.fill(child: ElMediaScrim(child: SizedBox.expand()))` sits
/// over a full-bleed `Image`, with the title/caption laid as a *separate*
/// `Positioned.fill` + `Align(bottomCenter)` sibling, styled with
/// `ElMediaScrimTokens.foreground` — not as `ElMediaScrim.child` itself.
/// The Overlaid Copy specimen below reproduces that exact arrangement.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

final ComponentDocSpec mediaScrimDocSpec = ComponentDocSpec(
  name: 'media_scrim',
  title: 'Media Scrim',
  description: mediaScrimDoc.description,
  sections: <DocsPageSection>[
    EffectSection(
      id: 'preview',
      title: 'Preview',
      description:
          'A caption laid directly on media beside the same caption '
          'behind an ElMediaScrim. The gradient is fully transparent at '
          'the top (stops[0] = 0, alpha 0) and reaches '
          'ElMediaScrimTokens.bottomAlpha (0.82) by the bottom edge, so '
          'the media stays visible while the text gains the contrast it '
          'needs.',
      host: const _PreviewHost(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'media-scrim has a real registry manifest, `elattar add '
          'media-scrim` installs lib/src/effects/media_scrim.dart and '
          'resolves its one registryDependency, source-foundation, '
          'automatically. The Manual tab is for a project not using the '
          'CLI.',
      command: mediaScrimDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/effects/media_scrim.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/effects/media_scrim.dart's generated "
              '@effects/media_scrim.dart payload into effects.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated media-scrim source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/effects/effects.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElMediaScrim is reachable the same '
              'way the CLI path already makes it.',
          code: "export 'media_scrim.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct import and construction: place over the '
          'full media bounds, commonly with Positioned.fill, and compose '
          'title/action content as a sibling — see Overlaid Copy below '
          'for why it is a sibling rather than ElMediaScrim.child.',
      code: _usageCode,
    ),
    EffectSection(
      id: 'overlaid-copy',
      title: 'Overlaid Copy',
      description:
          'showcase_reels.dart\'s own arrangement: ElMediaScrim(child: '
          'SizedBox.expand()) — an empty sizing box — as one '
          'Positioned.fill layer, and the title/caption as a second, '
          'separate Positioned.fill + Align(bottomCenter) layer above '
          'it, styled with ElMediaScrimTokens.foreground so the text '
          'colour stays fixed regardless of the surrounding app theme.',
      host: const _OverlaidCopyHost(),
      code: _overlaidCopyCode,
      label: 'Overlaid copy specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'ElMediaScrim\'s own constructor parameter, plus the '
          'foundation-owned ElMediaScrimTokens fields this effect reads '
          'every value from (foundation/media.dart, part of the '
          'source-foundation dependency, not this file).',
      child: const _ApiReferenceContent(),
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElMediaScrim', anchor: 'api-elmediascrim'),
        DocsTocEntry(
          title: 'ElMediaScrimTokens',
          anchor: 'api-elmediascrimtokens',
        ),
      ],
    ),
    DisclosureSection(id: 'states', title: 'States', child: const _StatesContent()),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: const _AccessibilityContent(),
    ),
    DisclosureSection(id: 'keyboard', title: 'Keyboard', child: const _KeyboardContent()),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: const _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: const _DependenciesContent(),
    ),
    DisclosureSection(id: 'theming', title: 'Theming', child: const _ThemingContent()),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: mediaScrimDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/effects_test.dart',
            description:
                'The "media primitives" group asserts the gradient is '
                'transparent at the top and readable at the bottom, and '
                'that the wrapper adopts its incoming constraints.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/media_scrim_test.dart',
            description:
                'Covers this page: the article mounts, the full API '
                'table, and both themes at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/media_scrim/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class MediaScrimDocPage extends StatelessWidget {
  const MediaScrimDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: mediaScrimDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / EFFECTS',
      title: mediaScrimDoc.title,
      description: mediaScrimDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Media Scrim'),
    ],
    toc: mediaScrimDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('media-scrim-doc-article'),
      child: ComponentDocPage(spec: mediaScrimDocSpec, header: false),
    ),
  );
}

/* ── Shared specimen shape ──────────────────────────────────────────────── */

class _CaptionedPair extends StatelessWidget {
  const _CaptionedPair({
    required this.leftCaption,
    required this.left,
    required this.rightCaption,
    required this.right,
  });

  final String leftCaption;
  final Widget left;
  final String rightCaption;
  final Widget right;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: el(2)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Captioned(caption: leftCaption, child: left),
          SizedBox(width: el(8)),
          _Captioned(caption: rightCaption, child: right),
        ],
      ),
    ),
  );
}

class _Captioned extends StatelessWidget {
  const _Captioned({required this.caption, required this.child});

  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        child,
        SizedBox(height: el(2)),
        ElText(caption, ElType.section, color: theme.mutedForeground),
      ],
    );
  }
}

/// A stand-in for a real photo/video asset: this page ships no binary
/// image, so a themed gradient plays the part `Image(image: asset, fit:
/// BoxFit.cover)` does in showcase_reels.dart.
class _MediaStandIn extends StatelessWidget {
  const _MediaStandIn({required this.child, this.keyValue});

  final Widget child;
  final String? keyValue;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Container(
      key: keyValue == null ? null : ValueKey<String>(keyValue!),
      width: el(48),
      height: el(64),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ElRadii.lg),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[theme.accent, theme.primary],
        ),
      ),
      child: Stack(fit: StackFit.expand, children: <Widget>[child]),
    );
  }
}

/* ── Specimens ───────────────────────────────────────────────────────────── */

class _PreviewHost extends StatelessWidget {
  const _PreviewHost();

  @override
  Widget build(BuildContext context) => _CaptionedPair(
    leftCaption: 'Caption on media, no scrim',
    left: _MediaStandIn(
      keyValue: 'media-scrim-example:no-scrim',
      child: const Align(
        alignment: Alignment.bottomLeft,
        child: _CaptionText(),
      ),
    ),
    rightCaption: 'Behind an ElMediaScrim',
    right: _MediaStandIn(
      keyValue: 'media-scrim-example:preview',
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const Positioned.fill(
            child: ElMediaScrim(child: SizedBox.expand()),
          ),
          const Align(alignment: Alignment.bottomLeft, child: _CaptionText()),
        ],
      ),
    ),
  );
}

class _CaptionText extends StatelessWidget {
  const _CaptionText();

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.all(el(3)),
    child: ElText(
      'Late-night skyline',
      ElType.small,
      color: ElMediaScrimTokens.foreground,
    ),
  );
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    '// Without: text sits directly on the media, contrast depends on '
    'the frame.\n'
    'Stack(\n'
    '  fit: StackFit.expand,\n'
    '  children: [\n'
    '    Image(image: asset, fit: BoxFit.cover),\n'
    '    Align(\n'
    '      alignment: Alignment.bottomLeft,\n'
    "      child: Text('Late-night skyline'),\n"
    '    ),\n'
    '  ],\n'
    ')\n\n'
    '// With: the scrim guarantees the bottom-edge contrast the media '
    'cannot.\n'
    'Stack(\n'
    '  fit: StackFit.expand,\n'
    '  children: [\n'
    '    Image(image: asset, fit: BoxFit.cover),\n'
    '    const Positioned.fill(child: ElMediaScrim(child: SizedBox.expand())),\n'
    '    Align(\n'
    '      alignment: Alignment.bottomLeft,\n'
    '      child: Text(\n'
    "        'Late-night skyline',\n"
    '        style: TextStyle(color: ElMediaScrimTokens.foreground),\n'
    '      ),\n'
    '    ),\n'
    '  ],\n'
    ')';

class _OverlaidCopyHost extends StatelessWidget {
  const _OverlaidCopyHost();

  @override
  Widget build(BuildContext context) => _MediaStandIn(
    keyValue: 'media-scrim-example:overlaid-copy',
    child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const Positioned.fill(child: ElMediaScrim(child: SizedBox.expand())),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(el(4)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ElText(
                    'Late-night skyline',
                    ElType.h4,
                    color: ElMediaScrimTokens.foreground,
                  ),
                  SizedBox(height: el(1)),
                  ElText(
                    'Shot on the roof, no filter · 12.4k views',
                    ElType.small,
                    color: ElMediaScrimTokens.foreground,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

const String _overlaidCopyCode =
    '// showcase_reels.dart\'s own arrangement: the scrim and the copy\n'
    '// are SIBLING Positioned.fill layers, not parent and child.\n'
    'Stack(\n'
    '  fit: StackFit.expand,\n'
    '  children: [\n'
    '    Image(image: asset, fit: BoxFit.cover),\n'
    '    const Positioned.fill(child: ElMediaScrim(child: SizedBox.expand())),\n'
    '    Positioned.fill(\n'
    '      child: Align(\n'
    '        alignment: Alignment.bottomCenter,\n'
    '        child: DefaultTextStyle(\n'
    '          style: TextStyle(color: ElMediaScrimTokens.foreground),\n'
    '          child: Column(\n'
    '            crossAxisAlignment: CrossAxisAlignment.start,\n'
    '            children: [\n'
    "              Text('Late-night skyline'),\n"
    "              Text('Shot on the roof, no filter · 12.4k views'),\n"
    '            ],\n'
    '          ),\n'
    '        ),\n'
    '      ),\n'
    '    ),\n'
    '  ],\n'
    ')';

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

Stack(
  fit: StackFit.expand,
  children: [
    Image(image: asset, fit: BoxFit.cover),
    const Positioned.fill(child: ElMediaScrim(child: SizedBox.expand())),
  ],
)''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elmediascrim',
        child: DocsApiTable(title: 'ElMediaScrim', facts: _apiFacts),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elmediascrimtokens',
        child: DocsApiTable(
          title: 'ElMediaScrimTokens (foundation/media.dart)',
          facts: _tokensFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _apiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        'Required. The content the scrim wraps. The wrapper adopts its '
        'incoming constraints and child\'s natural size — it is a '
        'DecoratedBox, not a Stack, so it never composes the caption '
        'itself; see Overlaid Copy above for why the real caption is a '
        'sibling layer, not this parameter.',
  ),
];

const List<DocsApiFact> _tokensFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ink',
    type: 'static Color',
    description:
        'A theme-independent neutral (elHsl(0, 0, 0) — pure black in '
        'both themes): media contrast must not invert when the '
        'surrounding application switches theme.',
  ),
  DocsApiFact(
    name: 'foreground',
    type: 'static Color',
    description:
        'Theme-independent foreground for copy placed over ink '
        '(elHsl(0, 0, 100) — pure white in both themes): media\'s '
        'contrast pair must stay stable too.',
  ),
  DocsApiFact(
    name: 'stops',
    type: 'static List<double>',
    description:
        '[0, 0.58, 1]. The ramp stays fully transparent through the top '
        '58% of the media.',
  ),
  DocsApiFact(
    name: 'middleAlpha',
    type: 'static double',
    description: '0.18 — a restrained bridge between transparent and readable.',
  ),
  DocsApiFact(
    name: 'bottomAlpha',
    type: 'static double',
    description:
        '0.82 — enough contrast for white title copy without becoming '
        'an opaque slab.',
  ),
];

class _StatesContent extends StatelessWidget {
  const _StatesContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElMediaScrim is a StatelessWidget: no hover, press, focus, or '
            'runtime state of any kind — no States matrix in the sense a '
            'control has one.',
        'It varies with nothing at all: build() returns the same fixed '
            'DecoratedBox(gradient: debugGradient) every time, reading no '
            'theme, no MediaQuery, and no constructor parameter besides '
            'child.',
        'Reduced motion has nothing to answer here either: no '
            'AnimationController, no Ticker — the gradient is a static '
            'paint.',
      ]);
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElMediaScrim renders no Semantics node of its own: build() '
            'returns a plain DecoratedBox. Whatever semantics child '
            'carries pass through untouched.',
        'It carries no accessible name and defines no role: it is a '
            'purely visual contrast aid. The caption text it makes '
            'legible is what needs its own Semantics, supplied by the '
            'caller exactly as showcase_reels.dart\'s own ElText does.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElMediaScrim takes no focus and handles no key: media_scrim.dart '
            'declares no Focus, no FocusNode, no onKeyEvent, no '
            'GestureDetector. It is a layout box.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No breakpoint branching anywhere in media_scrim.dart: '
            'BuildContext width is never read for a layout decision.',
        'The gradient is a LinearGradient painted by a DecoratedBox, so '
            'Flutter stretches it to whatever box the caller gives it — '
            'the stops (fractions of the box, not fixed pixels) hold '
            'their proportion at every size, matching CSS\'s own '
            'percentage-based gradient stops.',
        'The wrapper adopts its incoming constraints and the child\'s '
            'natural size (the class doc\'s own words): it neither grows '
            'nor shrinks the layout on its own at any viewport.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/effects/media_scrim.dart: one file, one class, no '
            'companions.',
        'Flutter imports: package:flutter/widgets.dart only.',
        'Foundation imports: foundation/media.dart (ElMediaScrimTokens). '
            'The same file also declares ElMediaRatios.portrait, a '
            'separate 9:16 aspect-ratio contract this effect does not '
            'read.',
        'registryDependencies, resolved automatically by `elattar add '
            'media-scrim`: source-foundation — copied verbatim from '
            'registry/effects/media-scrim.json. No semanticDependencies.',
        'Real use in this corpus: example/lib/showcase/showcase_reels.dart '
            '(_ReelOverlay.build) is the one caller, wrapping every reel\'s '
            'full-bleed image; example/test/showcase_content_depth_test.dart '
            'and showcase_profile_reels_test.dart both assert it mounts '
            'there.',
      ]),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElMediaScrim never calls ElTheme.of(context): its gradient is '
            'built entirely from ElMediaScrimTokens, and every one of '
            'those fields is a plain Color or double, not a Color '
            'Function(ElThemeData) the way an ElShadowLayer is.',
        'That is deliberate, per the token class\'s own doc: "Media does '
            'not change when the surrounding application theme changes, '
            'so its contrast pair must stay stable as well." ink '
            '(elHsl(0, 0, 0)) and foreground (elHsl(0, 0, 100)) render '
            'identically whether ElThemeController is set to light or '
            'dark.',
        'The one thing that DOES flip with the app theme is whatever '
            'sits outside the scrim — the surrounding chrome, any '
            'ElText not styled with ElMediaScrimTokens.foreground — but '
            'that is the caller\'s theme, not this effect\'s.',
      ]);
}

Widget _bullets(ElThemeData theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText('•  $line', ElType.small, color: theme.mutedForeground),
      ),
      SizedBox(height: el(2)),
    ],
  ],
);
