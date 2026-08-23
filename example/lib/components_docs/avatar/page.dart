/// Public component documentation for the avatar component.
///
/// `avatar` is not backed by a registry manifest yet — see the Installation
/// section below for exactly what that means today. Two of the live
/// specimens on this page feed [DsAvatar] bytes that never touch the
/// network: a tiny valid local PNG for the "image loads" state, and four
/// bytes that are not a decodable image at all for the "decode fails" state.
/// Both were verified against the real widget before being written here —
/// see `example/test/components_docs/avatar_test.dart`.
library;

import 'dart:typed_data';

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class AvatarDocPage extends StatelessWidget {
  const AvatarDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    return DocsLayout(
      route: avatarDoc.route,
      intro: const DocsPageIntro(
        eyebrow: 'COMPONENTS / BASE',
        title: 'Avatar',
        description:
            'Use DsAvatar to represent a person or account: a photo when one '
            'loads, initials underneath when it does not. Reach for DsIcon '
            'instead when the mark is a generic glyph rather than an '
            'identity; reach for DsItemMedia or a plain image when the '
            'content is not a person or account at all; and use the '
            'separate agent_avatar.dart family (DsCubeAvatar / DsAgentCube) '
            'for the animated isometric agent face — a different component '
            'with a different rendering model, not a variant of this one.',
      ),
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Avatar'),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Overview', anchor: 'overview'),
        DocsTocEntry(title: 'Status', anchor: 'status'),
        DocsTocEntry(title: 'Preview', anchor: 'preview'),
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'API', anchor: 'api'),
        DocsTocEntry(title: 'Variants and sizes', anchor: 'variants'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive behavior', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      onNavigate: onNavigate,
      child: const _AvatarArticle(),
    );
  }
}

class _AvatarArticle extends StatelessWidget {
  const _AvatarArticle();

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('avatar-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DsSection(
        id: 'overview',
        title: 'Overview',
        description: avatarDoc.description,
        child: const _OverviewPanel(),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'status',
        title: 'Status',
        child: const DocsInstallFacts(
          title: 'Status',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Status',
              value: 'Package-only — not yet in the public registry',
              description:
                  'DsAvatar ships in the package today; there is no CLI '
                  'install path yet.',
            ),
            DocsInstallFact(
              label: 'Version',
              value: '0.0.1',
              description: 'Tracks the elattar_design_system package version.',
            ),
            DocsInstallFact(
              label: 'Platforms',
              value: 'Android, iOS, Web, macOS, Windows, Linux',
              description:
                  'DsAvatar is built entirely from Flutter framework '
                  'primitives (CustomPaint, DecoratedBox, Image) with no '
                  'platform channels, so it renders the same everywhere '
                  'Flutter itself runs.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'preview',
        title: 'Live preview',
        description:
            'Sizes, the sizePx override, a status badge, and a value ring on '
            'the left; a locally-decodable image and a deliberately '
            'corrupted one on the right, so the loaded and failed image '
            'states are both real rather than described from memory.',
        child: DocsCodeExample(
          title: 'Avatar specimens',
          description:
              'The fallback initials render immediately in every case; the '
              'image (when supplied and decodable) paints over them.',
          preview: const _AvatarPreview(),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'main.dart',
              title: 'Import from the package',
              description:
                  'avatar has no registry manifest yet, so it is not copied '
                  'into lib/components/ui/. Import it directly instead.',
              code:
                  "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                  '// DsAvatar, DsAvatarBadge, DsAvatarGroup and\n'
                  '// DsAvatarGroupCount are all exported from the barrel.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'install',
        title: 'Installation',
        description:
            'Manual only, for now — there is no elattar add avatar command.',
        child: const DocsInstallFacts(
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'CLI',
              value: 'Not available yet',
              description:
                  'avatar has no registry/components/avatar.json manifest, '
                  'so elattar add avatar does not exist. Adding one means '
                  'declaring its real transitive dependencies, which is '
                  'tracked separately rather than invented here.',
            ),
            DocsInstallFact(
              label: 'Package import',
              value:
                  "import 'package:elattar_design_system/elattar_design_system.dart';",
              description: 'Use DsAvatar straight from the package today.',
            ),
            DocsInstallFact(
              label: 'Source path',
              value: 'lib/src/components/avatar.dart',
              description: 'The single authoritative source file.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'usage',
        title: 'Usage',
        description:
            'Start from a bare fallback, then add an image, a ring, or a '
            'badge as the identity needs them.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsPanel(
              label: 'DART',
              note: 'SMALLEST EXAMPLE',
              child: DocsSelectableCodeBlock(code: _smallestUsageCode),
            ),
            SizedBox(height: ds(4)),
            DsPanel(
              label: 'DART',
              note: 'IMAGE WITH A FALLBACK',
              child: DocsSelectableCodeBlock(code: _imageUsageCode),
            ),
            SizedBox(height: ds(4)),
            DsPanel(
              label: 'DART',
              note: 'RING AND BADGE',
              child: DocsSelectableCodeBlock(code: _ringBadgeUsageCode),
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'api',
        title: 'API',
        description:
            'Every public constructor parameter on DsAvatar, followed by the '
            'size rungs and the supporting types (DsAvatarBadge, '
            'DsAvatarGroup, DsAvatarGroupCount, DsAvatarRing, '
            'dsAvatarRingWidth, DsAvatarRimPainter) it is built from.',
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DocsApiTable(title: 'DsAvatar', facts: _dsAvatarFacts),
            SizedBox(height: 24),
            DocsApiTable(title: 'DsAvatarSize', facts: _dsAvatarSizeFacts),
            SizedBox(height: 24),
            DocsApiTable(title: 'Supporting types', facts: _supportingFacts),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'variants',
        title: 'Variants and sizes',
        description:
            'size picks a rung (sm/md/lg); sizePx overrides only the box. '
            'The badge dot always scales off size, even when sizePx has '
            'overridden the diameter — the same class-beats-attribute split '
            'DsIcon.sizePx carries, verified in the package\'s own '
            'test/data_display_test.dart.',
        child: const _Bullets(
          items: <String>[
            'DsAvatarSize.sm — 24px avatar, 8px badge dot.',
            'DsAvatarSize.md — 32px avatar (the default), 10px badge dot.',
            'DsAvatarSize.lg — 40px avatar, 12px badge dot.',
            'sizePx: 40 with size left at its default md still draws a '
                '10px badge, not the 12px an lg avatar would carry — the '
                'attribute (size) drives the badge; the class (sizePx) '
                'drives only the box.',
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'states',
        title: 'States',
        description:
            'DsAvatar is not interactive on its own, so hover, focus, press, '
            'select, and disabled do not apply to it directly — wrap it in a '
            'pressable ancestor, as NavUser wraps it in a '
            'DsSidebarMenuButton, if the composition needs one of those.',
        child: const DocsStateMatrix(
          facts: <DocsStateFact>[
            DocsStateFact(
              state: 'Rest (fallback only)',
              treatment: 'image is null; the fallback renders outright.',
              userSignal:
                  'A muted circular fill with initials — no spinner, no '
                  'empty state.',
            ),
            DocsStateFact(
              state: 'Loading (image)',
              treatment:
                  'An image is supplied and is still resolving; the '
                  'fallback content sits underneath the (still-empty) '
                  'Image in the same Stack.',
              userSignal:
                  'Initials stay legible instead of a blank gap while the '
                  'photo resolves.',
            ),
            DocsStateFact(
              state: 'Success (image)',
              treatment:
                  'The decoded image paints in a ClipRRect over the '
                  'fallback, BoxFit.cover.',
              userSignal: 'The photo fully replaces the initials.',
            ),
            DocsStateFact(
              state: 'Error (image)',
              treatment:
                  'DsAvatar wires no errorBuilder, so a decode/load failure '
                  'is reported to FlutterError and the Image paints '
                  'nothing — the fallback beneath keeps showing through.',
              userSignal:
                  'Initials remain readable instead of a broken-image icon '
                  '— verified in this page\'s own test with a corrupt '
                  'MemoryImage.',
            ),
            DocsStateFact(
              state: 'Hover / Focus-visible / Pressed / Selected / Disabled',
              treatment:
                  'N/A — DsAvatar takes no onTap/onPressed and paints no '
                  'interactive state of its own.',
              userSignal:
                  'Add these by wrapping DsAvatar in an interactive '
                  'ancestor; they are that ancestor\'s states, not this '
                  'widget\'s.',
            ),
            DocsStateFact(
              state: 'Empty',
              treatment:
                  'N/A — fallback is a required constructor parameter, so '
                  'there is always something to render.',
              userSignal: 'There is no "no avatar at all" state to design.',
            ),
            DocsStateFact(
              state: 'Reduced motion',
              treatment: 'N/A — DsAvatar performs no animation.',
              userSignal: 'Nothing to freeze; there is nothing moving.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'accessibility',
        title: 'Accessibility',
        description:
            'DsAvatar does not wrap itself in a Semantics node — read '
            'directly from lib/src/components/avatar.dart, there is none in '
            'the class.',
        child: const _Bullets(
          items: <String>[
            'Give a standalone avatar its own label: wrap it in '
                'Semantics(label: "…profile photo", image: true, child: '
                'DsAvatar(...)).',
            'When the avatar sits beside visible identity text — as it does '
                'in the sidebar footer\'s NavUser — that adjacent text '
                'already names the person, so no extra label is needed '
                'there.',
            'DsAvatar is not focusable and defines no keyboard behavior of '
                'its own; keyboard interaction belongs to whatever '
                'interactive ancestor wraps it.',
            'The default 24-40px box can sit under common touch-target '
                'minimums when the avatar itself is the tappable element — '
                'add touch-target padding on the wrapping control rather '
                'than shrinking it there.',
            'Identity itself is never carried by color alone. ring and '
                'badge are color-only decorations, though — pair a badge '
                'that communicates real status with a label or tooltip on '
                'its wrapper, not the dot alone.',
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'responsive',
        title: 'Responsive behavior',
        description:
            'DsAvatar has no internal breakpoints and no platform-specific '
            'behavior; it is a fixed-size visual mark start to finish.',
        child: const _Bullets(
          items: <String>[
            'Choose a DsAvatarSize rung per breakpoint, or compute an '
                'explicit sizePx from the surrounding layout — the widget '
                'does not adapt on its own.',
            'DsAvatarGroup.overlap is a fixed 8px constant; it does not '
                'scale with viewport width.',
            'No platform channels are used, so behavior is identical on '
                'every Flutter target this package supports.',
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'dependencies',
        title: 'Dependencies',
        description:
            'No registry item exists yet, so there are no registry '
            'dependencies to list — see Installation above.',
        child: const DocsInstallFacts(
          title: 'Files and assets',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Files',
              value: 'lib/src/components/avatar.dart',
              description: 'One file; DsAvatar is not split across sources.',
            ),
            DocsInstallFact(
              label: 'Assets',
              value: 'None',
              description:
                  'DsAvatar takes any ImageProvider the caller supplies; it '
                  'ships no bundled asset of its own.',
            ),
            DocsInstallFact(
              label: 'Fonts and shaders',
              value: 'None beyond the foundation',
              description:
                  'The fallback text uses whichever DsTypeSpec is passed or '
                  'defaulted (DsFonts.mono for avatarFallback, DsFonts.sans '
                  'for avatarInitials) — both already shipped by the '
                  'foundation, not by this component.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'composition',
        title: 'Composition examples',
        description:
            'Two real shapes from the corpus: an identity row (name beside '
            'an avatar, as the sidebar footer composes it) and an overflow '
            'group (who did something, plus a remainder count).',
        child: const _CompositionPreview(),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'theming',
        title: 'Theming',
        description:
            'Toggle the site theme control to compare — the rim recomputes '
            'automatically; nothing on this page hardcodes either mode.',
        child: const _Bullets(
          items: <String>[
            'The fallback fill/ink default to theme.muted / '
                'theme.mutedForeground; fallbackFill and fallbackInk '
                'override either independently, as the leaderboard leader '
                'specimen does with DsPalette.value.',
            'The hairline rim always resolves to theme.border — there is '
                'no parameter that overrides its color.',
            'The rim blends darken against a light theme and lighten '
                'against a dark one (theme.kind == DsThemeKind.dark), so '
                'the same rim reads on a photo and on a flat fill in both '
                'modes without ever being drawn as a solid line over the '
                'subject.',
            'ring and badge take explicit colors from the call site — '
                'DsAvatarGroup.ringOf(context) is the one built-in helper, '
                'resolving to theme.background at the shared '
                'dsAvatarRingWidth.',
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'source',
        title: 'Source',
        description:
            'Where to read the implementation and the tests that already '
            'cover it.',
        child: const DocsInstallFacts(
          title: 'Source references',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Package file',
              value: 'lib/src/components/avatar.dart',
              description: 'The authoritative source for this component.',
            ),
            DocsInstallFact(
              label: 'Exports',
              value:
                  'DsAvatar, DsAvatarSize, DsAvatarRing, dsAvatarRingWidth, '
                  'DsAvatarBadge, DsAvatarGroup, DsAvatarGroupCount, '
                  'DsAvatarRimPainter',
              description: 'Public symbols available after import.',
            ),
            DocsInstallFact(
              label: 'Tests',
              value:
                  'test/data_display_test.dart (DsAvatar group), '
                  'example/test/components_docs/avatar_test.dart',
              description:
                  'The package\'s own behavioral tests, and this '
                  'documentation page\'s own coverage.',
            ),
          ],
        ),
      ),
    ],
  );
}

const String _smallestUsageCode = '''const DsAvatar(fallback: 'AB')''';

const String _imageUsageCode = '''DsAvatar(
  fallback: 'AB',
  image: NetworkImage(user.photoUrl),
  fallbackSpec: DsComponentType.avatarFallback,
)''';

const String _ringBadgeUsageCode = '''DsAvatar(
  fallback: '#1',
  sizePx: ds(10),
  ring: (color: DsPalette.value, width: dsAvatarRingWidth),
  badge: DsAvatarBadge(fill: DsPalette.value),
)''';

const List<DocsApiFact> _dsAvatarFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'fallback',
    type: 'String',
    description:
        'Required. The initials shown while there is no image, or while it '
        'has not resolved.',
  ),
  DocsApiFact(
    name: 'image',
    type: 'ImageProvider<Object>?',
    description:
        'Null renders the fallback outright — the same thing Radix does '
        'while an image is missing or still loading.',
  ),
  DocsApiFact(
    name: 'size',
    type: 'DsAvatarSize',
    description: 'sm, md (default), or lg. Always drives the badge rung.',
  ),
  DocsApiFact(
    name: 'fallbackSpec',
    type: 'DsTypeSpec?',
    description:
        'The fallback text\'s type. Defaults to DsComponentType.textSm; '
        'avatarFallback and avatarInitials are the two named specs the '
        'corpus reaches for instead.',
  ),
  DocsApiFact(
    name: 'sizePx',
    type: 'double?',
    description:
        'Overrides the box diameter directly. Wins over size for the box '
        'only — size still governs the badge.',
  ),
  DocsApiFact(
    name: 'ring',
    type: 'DsAvatarRing?',
    description:
        'An outset colored ring — costs the box nothing, so a ringed '
        'avatar still measures exactly its own diameter.',
  ),
  DocsApiFact(
    name: 'badge',
    type: 'DsAvatarBadge?',
    description: 'A status dot pinned to the bottom-right corner.',
  ),
  DocsApiFact(
    name: 'fallbackFill',
    type: 'Color?',
    description: 'Overrides the fallback circle\'s background fill.',
  ),
  DocsApiFact(
    name: 'fallbackInk',
    type: 'Color?',
    description: 'Overrides the fallback initials\' text color.',
  ),
];

const List<DocsApiFact> _dsAvatarSizeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'sm',
    type: 'DsAvatarSize',
    description: '24px avatar (ds(6)); 8px badge dot (ds(2)).',
  ),
  DocsApiFact(
    name: 'md',
    type: 'DsAvatarSize',
    description:
        '32px avatar (ds(8)) — the default, and the only rung the corpus '
        'renders live today; 10px badge dot (ds(2.5)).',
  ),
  DocsApiFact(
    name: 'lg',
    type: 'DsAvatarSize',
    description: '40px avatar (ds(10)); 12px badge dot (ds(3)).',
  ),
];

const List<DocsApiFact> _supportingFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'DsAvatarBadge.fill',
    type: 'Color',
    description:
        'Required — every real call site overrides the dot\'s fill, so '
        'there is no default color.',
  ),
  DocsApiFact(
    name: 'DsAvatarBadge.child',
    type: 'Widget?',
    description:
        'An optional glyph inside the dot. No corpus call site sets one.',
  ),
  DocsApiFact(
    name: 'DsAvatarGroup.children',
    type: 'List<Widget>',
    description: 'The avatars, then optionally a DsAvatarGroupCount last.',
  ),
  DocsApiFact(
    name: 'DsAvatarGroup.overlap',
    type: 'static double',
    description:
        '8px (ds(2)) — how far each child after the first is pulled left.',
  ),
  DocsApiFact(
    name: 'DsAvatarGroup.ringOf(context)',
    type: 'static DsAvatarRing',
    description:
        'theme.background at dsAvatarRingWidth — the ring every child in '
        'a group should wear so overlapping circles stay separated.',
  ),
  DocsApiFact(
    name: "DsAvatarGroupCount(label, {spec})",
    type: 'Widget',
    description:
        'A "+248"-style overflow count, sized and ringed like a group '
        'avatar (32px, the group\'s default rung).',
  ),
  DocsApiFact(
    name: 'DsAvatarRing',
    type: 'typedef ({Color color, double width})',
    description: 'The record type ring expects.',
  ),
  DocsApiFact(
    name: 'dsAvatarRingWidth',
    type: 'double',
    description: '2 — the width both ring call sites in the corpus use.',
  ),
  DocsApiFact(
    name: 'DsAvatarRimPainter',
    type: 'CustomPainter',
    description:
        'Paints the always-on hairline rim in theme.border, blended '
        'darken (light) or lighten (dark). Built internally by DsAvatar; '
        'not meant to be constructed directly.',
  ),
];

/// The one-sentence short description plus the decision guidance the intro
/// banner already carries, restated compactly for a reader who lands mid
/// page.
class _OverviewPanel extends StatelessWidget {
  const _OverviewPanel();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsPanel(
      label: 'What DsAvatar is',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(avatarDoc.description, DsType.body, color: theme.foreground),
          SizedBox(height: ds(3)),
          DsText(
            'Not documented here: agent_avatar.dart\'s DsCubeAvatar / '
            'DsAgentCube family. That is a separate, isometric animated '
            'agent face with its own scene and keyframe system — the source '
            'file itself draws this line, and this page keeps it.',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ],
      ),
    );
  }
}

/// A tiny, fully local, decodable PNG — the same bytes the
/// `transparent_image` package ships as `kTransparentImage`. Used so the
/// "image loads" specimen never touches the network.
final Uint8List _validAvatarPng = Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, //
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, //
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, //
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, //
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82, //
]);

/// Four bytes that are not a decodable image — the "decode fails" specimen,
/// exercised deterministically and without a network round trip.
final Uint8List _corruptAvatarBytes = Uint8List.fromList(<int>[1, 2, 3, 4]);

class _AvatarPreview extends StatelessWidget {
  const _AvatarPreview();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Wrap(
      spacing: ds(6),
      runSpacing: ds(4),
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Wrap(
              spacing: ds(3),
              runSpacing: ds(3),
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                DsAvatar(
                  fallback: 'AB',
                  size: DsAvatarSize.sm,
                  fallbackSpec: DsComponentType.avatarInitials,
                ),
                DsAvatar(
                  fallback: 'AB',
                  fallbackSpec: DsComponentType.avatarFallback,
                ),
                const DsAvatar(fallback: 'AB', size: DsAvatarSize.lg),
                DsAvatar(
                  fallback: '#1',
                  sizePx: 40,
                  ring: (color: DsPalette.value, width: dsAvatarRingWidth),
                ),
                DsAvatar(
                  fallback: 'AB',
                  size: DsAvatarSize.lg,
                  badge: DsAvatarBadge(fill: DsPalette.value),
                ),
              ],
            ),
            SizedBox(height: ds(2)),
            DsText(
              'sm, md, lg, a value ring, and a status badge',
              DsType.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Wrap(
              spacing: ds(3),
              runSpacing: ds(3),
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                DsAvatar(
                  fallback: 'AB',
                  size: DsAvatarSize.lg,
                  image: MemoryImage(_validAvatarPng),
                ),
                DsAvatar(
                  fallback: 'AB',
                  size: DsAvatarSize.lg,
                  image: MemoryImage(_corruptAvatarBytes),
                ),
              ],
            ),
            SizedBox(height: ds(2)),
            DsText(
              'A decodable local image, and a deliberately corrupt one — '
              'the initials stay on screen either way',
              DsType.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
      ],
    );
  }
}

class _CompositionPreview extends StatelessWidget {
  const _CompositionPreview();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPanel(
          label: 'Identity row',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DsAvatar(
                fallback: 'AV',
                fallbackSpec: DsComponentType.avatarFallback,
              ),
              SizedBox(width: ds(2)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DsText('Astra Vale', DsType.nav, color: theme.foreground),
                  DsText(
                    'astra@elattar.dev',
                    DsType.small,
                    color: theme.mutedForeground,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: ds(4)),
        DsPanel(
          label: 'Avatar group — who opened this pack',
          child: Builder(
            builder: (BuildContext context) => DsAvatarGroup(
              children: <Widget>[
                for (final String initials in <String>['VW', 'EM', 'TC', 'SW'])
                  DsAvatar(
                    fallback: initials,
                    fallbackSpec: DsComponentType.avatarFallback,
                    ring: DsAvatarGroup.ringOf(context),
                  ),
                const DsAvatarGroupCount('+248'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Bullets extends StatelessWidget {
  const _Bullets({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsPanel(
      label: 'Guidance',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < items.length; i++) ...<Widget>[
            if (i > 0) SizedBox(height: ds(2)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DsText('•  ', DsType.small, color: theme.mutedForeground),
                Expanded(
                  child: DsText(
                    items[i],
                    DsType.small,
                    color: theme.mutedForeground,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
