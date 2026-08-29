/// Public documentation page for the `avatar` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `Section`
/// panels reshaped to mirror shadcn's own flat section order; it now
/// declares a `ComponentDocSpec` (`example/lib/docs/component_doc_page.dart`)
/// and hands it to `ComponentDocPage`, the same shape `button` and `field`
/// established. Every specimen widget and every code string below is the
/// same one the hand-composed page carried, re-typed into `ShowcaseSection`s
/// so each is finally its own specimen AND its own visible source, not a
/// live demo with no code toggle (the old top-of-page live block) or prose
/// next to a `DocsCodeExample` (every section under it).
///
/// **Corrected, not just moved.** The hand-composed page's own library doc
/// and its Installation and Dependencies sections all claimed `avatar` "is
/// not backed by a registry manifest yet." That was false the whole time:
/// `registry/components/avatar.json` exists, lists exactly one file
/// (`lib/src/components/ui/avatar.dart`) and one registry dependency
/// (`source-foundation`), and its `documentationRoute` already points at
/// this page. `avatar/meta.dart`'s own doc comment repeated the same claim
/// and is corrected alongside this file.
///
/// **Skipped from the reference:** "Avatar Group with Icon". [AvatarGroup]
/// composes [AvatarGroupCount] for its overflow indicator, and
/// [AvatarGroupCount] takes only a `String label`, there is no icon slot
/// on it to swap the count text for a glyph. Faking one here would draw a
/// capability this widget does not have, so the section is not built.
///
/// New: a Keyboard disclosure, between Accessibility and Responsive — read
/// directly off `avatar.dart`: the file wires no `Focus` node and no key
/// handling anywhere, so `Avatar` is not focusable at all.
library;

import 'dart:typed_data';

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

final ComponentDocSpec avatarDocSpec = ComponentDocSpec(
  name: 'avatar',
  title: avatarDoc.title,
  description: avatarDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Sizes, the sizePx override, a status badge, and a value ring on '
          'the left; a locally-decodable image and a deliberately corrupted '
          'one on the right, so the loaded and failed image states are both '
          'real rather than described from memory. The fallback initials '
          'render immediately in every case; the image (when supplied and '
          'decodable) paints over them.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'avatar has a real registry manifest, `elattar add avatar` '
          'installs lib/src/components/ui/avatar.dart and resolves '
          'source-foundation automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: avatarDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/avatar.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/avatar.dart's generated "
              '@ui/avatar.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated avatar source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so Avatar and its supporting types '
              'are reachable the same way the CLI path already makes '
              'them.',
          code: "export 'avatar.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'Start from a bare fallback, then add an image, a ring, or a '
          'badge as the identity needs them.',
      code: _usageCode,
    ),
    SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'Avatar folds AvatarImage and AvatarFallback into one widget\'s '
          'Stack rather than two composable subcomponents, so there is no '
          'live specimen to toggle here beyond the ones below: a structural '
          'sketch of the Stack and the group tree, not runnable Dart.',
      code: _compositionAnatomyCode,
    ),
    ShowcaseSection(
      id: 'basic',
      title: 'Basic',
      description:
          'A bare fallback, and the same avatar once a decodable image is '
          'supplied.',
      specimen: _BasicPreview(),
      code: _basicCode,
      label: 'Basic specimen view',
    ),
    ShowcaseSection(
      id: 'badge',
      title: 'Badge',
      description: 'A status dot pinned to the bottom-right corner.',
      specimen: _BadgePreview(),
      code: _badgeCode,
      label: 'Badge specimen view',
    ),
    ShowcaseSection(
      id: 'badge-icon',
      title: 'Badge with icon',
      description:
          'AvatarBadge.child takes any widget; no corpus call site used '
          'it until this specimen, so this is new code exercising a real, '
          'already-public slot rather than a fabricated one.',
      specimen: _BadgeIconPreview(),
      code: _badgeIconCode,
      label: 'Badge with icon specimen view',
    ),
    ShowcaseSection(
      id: 'avatar-group',
      title: 'Avatar group',
      description:
          'AvatarGroup overlaps its children by 8px each and forces '
          'AvatarGroup.ringOf(context) onto every one of them, so the '
          'circles stay separated against the page background.',
      specimen: _AvatarGroupPreview(),
      code: _avatarGroupCode,
      label: 'Avatar group specimen view',
    ),
    ShowcaseSection(
      id: 'avatar-group-count',
      title: 'Avatar group count',
      description:
          'AvatarGroupCount reads the group\'s own ring rather than '
          'carrying one of its own, so it slots in as the group\'s last '
          'child like any other overflow indicator would. "Who opened this '
          'pack."',
      specimen: _AvatarGroupCountPreview(),
      code: _avatarGroupCountCode,
      label: 'Avatar group count specimen view',
    ),
    ShowcaseSection(
      id: 'sizes',
      title: 'Sizes',
      description:
          'size picks a rung; sizePx overrides only the box. The badge dot '
          'always scales off size, even when sizePx has overridden the '
          'diameter: the same class-beats-attribute split Icon.sizePx '
          'carries, verified in the package\'s own test/data_display_test.dart. '
          'AvatarSize.sm is a 24px avatar with an 8px badge dot; md '
          '(the default) is 32px with a 10px dot; lg is 40px with a 12px '
          'dot. sizePx: 40 with size left at its default md still draws a '
          '10px badge, not the 12px an lg avatar would carry: the '
          'attribute (size) drives the badge; the class (sizePx) drives '
          'only the box.',
      specimen: _SizesPreview(),
      code: _sizesCode,
      label: 'Sizes specimen view',
    ),
    ShowcaseSection(
      id: 'dropdown',
      title: 'Dropdown',
      description:
          'Avatar takes no onTap of its own, so any pressable ancestor '
          'can use one as its trigger: here, DropdownMenu.trigger, the '
          'same pattern the sidebar footer\'s UserMenu composes.',
      specimen: _DropdownPreview(),
      code: _dropdownCode,
      label: 'Dropdown specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'The circle itself has no direction to flip; what does flip is a '
          'composition around it, an identity row\'s avatar and text trade '
          'sides under a Directionality the same way Breadcrumb\'s own '
          'RTL specimen does.',
      specimen: _RtlPreview(),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every public constructor parameter on Avatar, followed by the '
          'size rungs and the supporting types (AvatarBadge, '
          'AvatarGroup, AvatarGroupCount, AvatarRing, '
          'avatarRingWidth, AvatarRimPainter) it is built from.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'Avatar', anchor: 'api-elavatar'),
        DocsTocEntry(title: 'AvatarSize', anchor: 'api-elavatarsize'),
        DocsTocEntry(title: 'Supporting types', anchor: 'api-supporting'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Avatar is not interactive on its own, so hover, focus, press, '
          'select, and disabled do not apply to it directly: wrap it in a '
          'pressable ancestor, as UserMenu wraps it in a '
          'SidebarMenuButton, if the composition needs one of those.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      description:
          'Avatar does not wrap itself in a Semantics node: read directly '
          'from lib/src/components/ui/avatar.dart, there is none in the '
          'class.',
      child: _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'avatar.dart wires no Focus node and no key handling of its own '
          'anywhere — every fact here is about what does NOT happen, read '
          'off Avatar.build directly.',
      child: _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      description:
          'Avatar has no internal breakpoints and no platform-specific '
          'behavior; it is a fixed-size visual mark start to finish.',
      child: _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      description:
          "Elattar's own technical-transparency panel: what this "
          'component needs to install and run.',
      child: _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      description:
          'Toggle the site theme control to compare: the rim recomputes '
          'automatically; nothing on this page hardcodes either mode.',
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
            value: avatarDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/data_display_test.dart (Avatar group)',
            description:
                "The package's own behavioral tests, covering "
                'Avatar and AvatarGroup together.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/avatar_test.dart',
            description:
                "This documentation page's own coverage, including the "
                'locally-decodable and deliberately corrupt image bytes '
                'the Preview specimen renders.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/avatar/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class AvatarDocPage extends StatelessWidget {
  const AvatarDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: avatarDoc.route,
    intro: DocsPageIntro(
      title: avatarDoc.title,
      description:
          'Use Avatar to represent a person or account: a photo when one '
          'loads, initials underneath when it does not. Reach for Icon '
          'instead when the mark is a generic glyph rather than an '
          'identity; reach for ItemMedia or a plain image when the '
          'content is not a person or account at all; and use the '
          'separate agent_avatar.dart family (AgentAvatar / AgentCube) '
          'for the animated isometric agent face: a different component '
          'with a different rendering model, not a variant of this one.',
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Avatar'),
    ],
    toc: avatarDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('avatar-doc-article'),
      child: ComponentDocPage(spec: avatarDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

const String _usageCode = '''const Avatar(fallback: 'AB')

Avatar(
  fallback: 'AB',
  image: NetworkImage(user.photoUrl),
  fallbackSpec: TextStyles.avatarFallback,
)

Avatar(
  fallback: '#1',
  sizePx: space(10),
  ring: (color: Palette.value, width: avatarRingWidth),
  badge: AvatarBadge(fill: Palette.value),
)''';

const String _previewCode = '''Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    Avatar(
      fallback: 'AB',
      size: AvatarSize.sm,
      fallbackSpec: TextStyles.avatarInitials,
    ),
    Avatar(fallback: 'AB'), // size: AvatarSize.md, the default
    const Avatar(fallback: 'AB', size: AvatarSize.lg),
    Avatar(
      fallback: '#1',
      sizePx: 40,
      ring: (color: Palette.value, width: avatarRingWidth),
    ),
    Avatar(
      fallback: 'AB',
      size: AvatarSize.lg,
      badge: AvatarBadge(fill: Palette.value),
    ),
    // Image states: a decodable local image, and a deliberately corrupt
    // one. The fallback initials stay on screen either way.
    Avatar(
      fallback: 'AB',
      size: AvatarSize.lg,
      image: NetworkImage(user.photoUrl),
    ),
  ],
)''';

const String _compositionAnatomyCode = '''Avatar
  Stack
    fallback circle        // DecoratedBox + StyledText, always painted first
    Image                  // only when `image` is supplied and decodes
    AvatarRimPainter     // the always-on hairline rim, painted last
    _AvatarBadgeBox        // only when `badge` is supplied

AvatarGroup
  children: [
    Avatar(...), Avatar(...), ...,
    AvatarGroupCount('+N'),   // optional, always last
  ]''';

const String _basicCode = '''Avatar(fallback: 'AB')

Avatar(
  fallback: 'AB',
  image: NetworkImage(user.photoUrl),
)''';

const String _badgeCode = '''Avatar(
  fallback: 'AB',
  size: AvatarSize.lg,
  badge: AvatarBadge(fill: Palette.value),
)''';

const String _badgeIconCode = '''Avatar(
  fallback: 'AB',
  size: AvatarSize.lg,
  badge: AvatarBadge(
    fill: Palette.value,
    child: const Icon(
      IconGlyph.plus,
      size: IconSize.xs,
      tone: IconTone.normal,
    ),
  ),
)''';

const String _avatarGroupCode = '''AvatarGroup(
  children: <Widget>[
    for (final String initials in <String>['VW', 'EM', 'TC', 'SW'])
      Avatar(
        fallback: initials,
        fallbackSpec: TextStyles.avatarFallback,
        ring: AvatarGroup.ringOf(context),
      ),
  ],
)''';

const String _avatarGroupCountCode = '''AvatarGroup(
  children: <Widget>[
    for (final String initials in <String>['VW', 'EM', 'TC', 'SW'])
      Avatar(
        fallback: initials,
        fallbackSpec: TextStyles.avatarFallback,
        ring: AvatarGroup.ringOf(context),
      ),
    const AvatarGroupCount('+248'),
  ],
)''';

const String _sizesCode = '''Avatar(fallback: 'AB', size: AvatarSize.sm)
Avatar(fallback: 'AB') // size: AvatarSize.md, the default
Avatar(fallback: 'AB', size: AvatarSize.lg)''';

const String _dropdownCode = '''DropdownMenu(
  trigger: const Avatar(
    fallback: 'AB',
    fallbackSpec: TextStyles.avatarFallback,
  ),
  children: <MenuChild>[
    const MenuLabel('My Account'),
    const MenuSeparator(),
    MenuItem(label: 'Profile', icon: IconGlyph.user, onSelect: () {}),
    MenuItem(label: 'Billing', icon: IconGlyph.creditCard, onSelect: () {}),
    const MenuSeparator(),
    MenuItem(label: 'Log out', icon: IconGlyph.logOut, onSelect: () {}),
  ],
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: Row(
    children: <Widget>[
      Avatar(fallback: 'أف', fallbackSpec: TextStyles.avatarFallback),
      // name and email column, same as the LTR identity row
    ],
  ),
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
        'Null renders the fallback outright: the same thing Radix does '
        'while an image is missing or still loading.',
  ),
  DocsApiFact(
    name: 'size',
    type: 'AvatarSize',
    description: 'sm, md (default), or lg. Always drives the badge rung.',
  ),
  DocsApiFact(
    name: 'fallbackSpec',
    type: 'TextStyleToken?',
    description:
        'The fallback text\'s type. Defaults to TextStyles.bodySmall; '
        'avatarFallback and avatarInitials are the two named specs the '
        'corpus reaches for instead.',
  ),
  DocsApiFact(
    name: 'sizePx',
    type: 'double?',
    description:
        'Overrides the box diameter directly. Wins over size for the box '
        'only: size still governs the badge.',
  ),
  DocsApiFact(
    name: 'ring',
    type: 'AvatarRing?',
    description:
        'An outset colored ring: costs the box nothing, so a ringed '
        'avatar still measures exactly its own diameter.',
  ),
  DocsApiFact(
    name: 'badge',
    type: 'AvatarBadge?',
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
    type: 'AvatarSize',
    description: '24px avatar (space(6)); 8px badge dot (space(2)).',
  ),
  DocsApiFact(
    name: 'md',
    type: 'AvatarSize',
    description:
        '32px avatar (space(8)): the default, and the only rung the corpus '
        'renders live today; 10px badge dot (space(2.5)).',
  ),
  DocsApiFact(
    name: 'lg',
    type: 'AvatarSize',
    description: '40px avatar (space(10)); 12px badge dot (space(3)).',
  ),
];

const List<DocsApiFact> _supportingFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'AvatarBadge.fill',
    type: 'Color',
    description:
        'Required: every real call site overrides the dot\'s fill, so '
        'there is no default color.',
  ),
  DocsApiFact(
    name: 'AvatarBadge.child',
    type: 'Widget?',
    description:
        'An optional glyph inside the dot: the Badge with icon section '
        'above is this page\'s own specimen of it.',
  ),
  DocsApiFact(
    name: 'AvatarGroup.children',
    type: 'List<Widget>',
    description: 'The avatars, then optionally a AvatarGroupCount last.',
  ),
  DocsApiFact(
    name: 'AvatarGroup.overlap',
    type: 'static double',
    description:
        '8px (space(2)): how far each child after the first is pulled left.',
  ),
  DocsApiFact(
    name: 'AvatarGroup.ringOf(context)',
    type: 'static AvatarRing',
    description:
        'theme.background at avatarRingWidth: the ring every child in '
        'a group should wear so overlapping circles stay separated.',
  ),
  DocsApiFact(
    name: "AvatarGroupCount(label, {spec})",
    type: 'Widget',
    description:
        'A "+248"-style overflow count, sized and ringed like a group '
        'avatar (32px, the group\'s default rung).',
  ),
  DocsApiFact(
    name: 'AvatarRing',
    type: 'typedef ({Color color, double width})',
    description: 'The record type ring expects.',
  ),
  DocsApiFact(
    name: 'avatarRingWidth',
    type: 'double',
    description: '2: the width both ring call sites in the corpus use.',
  ),
  DocsApiFact(
    name: 'AvatarRimPainter',
    type: 'CustomPainter',
    description:
        'Paints the always-on hairline rim in theme.border, blended '
        'darken (light) or lighten (dark). Built internally by Avatar; '
        'not meant to be constructed directly.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest (fallback only)',
    treatment: 'image is null; the fallback renders outright.',
    userSignal:
        'A muted circular fill with initials: no spinner, no empty state.',
  ),
  DocsStateFact(
    state: 'Loading (image)',
    treatment:
        'An image is supplied and is still resolving; the fallback '
        'content sits underneath the (still-empty) Image in the same '
        'Stack.',
    userSignal:
        'Initials stay legible instead of a blank gap while the photo '
        'resolves.',
  ),
  DocsStateFact(
    state: 'Success (image)',
    treatment:
        'The decoded image paints in a ClipRRect over the fallback, '
        'BoxFit.cover.',
    userSignal: 'The photo fully replaces the initials.',
  ),
  DocsStateFact(
    state: 'Error (image)',
    treatment:
        'Avatar wires no errorBuilder, so a decode/load failure is '
        'reported to FlutterError and the Image paints nothing: the '
        'fallback beneath keeps showing through.',
    userSignal:
        'Initials remain readable instead of a broken-image icon, '
        "verified in this page's own test with a corrupt MemoryImage.",
  ),
  DocsStateFact(
    state: 'Hover / Focus-visible / Pressed / Selected / Disabled',
    treatment:
        'N/A, Avatar takes no onTap/onPressed and paints no '
        'interactive state of its own.',
    userSignal:
        'Add these by wrapping Avatar in an interactive ancestor; '
        "they are that ancestor's states, not this widget's.",
  ),
  DocsStateFact(
    state: 'Empty',
    treatment:
        'N/A: fallback is a required constructor parameter, so there is '
        'always something to render.',
    userSignal: 'There is no "no avatar at all" state to design.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment: 'N/A, Avatar performs no animation.',
    userSignal: 'Nothing to freeze; there is nothing moving.',
  ),
];

/// A tiny, fully local, decodable PNG: the same bytes the
/// `transparent_image` package ships as `kTransparentImage`. Used so the
/// "image loads" specimens never touch the network.
final Uint8List _validAvatarPng = Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, //
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, //
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, //
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, //
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82, //
]);

/// Four bytes that are not a decodable image: the "decode fails" specimen,
/// exercised deterministically and without a network round trip.
final Uint8List _corruptAvatarBytes = Uint8List.fromList(<int>[1, 2, 3, 4]);

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Wrap(
      spacing: space(6),
      runSpacing: space(4),
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Wrap(
              spacing: space(3),
              runSpacing: space(3),
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Avatar(
                  fallback: 'AB',
                  size: AvatarSize.sm,
                  fallbackSpec: TextStyles.avatarInitials,
                ),
                Avatar(fallback: 'AB', fallbackSpec: TextStyles.avatarFallback),
                const Avatar(fallback: 'AB', size: AvatarSize.lg),
                Avatar(
                  fallback: '#1',
                  sizePx: 40,
                  ring: (color: Palette.value, width: avatarRingWidth),
                ),
                Avatar(
                  fallback: 'AB',
                  size: AvatarSize.lg,
                  badge: AvatarBadge(fill: Palette.value),
                ),
              ],
            ),
            SizedBox(height: space(2)),
            StyledText(
              'sm, md, lg, a value ring, and a status badge',
              TextStyles.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Wrap(
              spacing: space(3),
              runSpacing: space(3),
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Avatar(
                  fallback: 'AB',
                  size: AvatarSize.lg,
                  image: MemoryImage(_validAvatarPng),
                ),
                Avatar(
                  fallback: 'AB',
                  size: AvatarSize.lg,
                  image: MemoryImage(_corruptAvatarBytes),
                ),
              ],
            ),
            SizedBox(height: space(2)),
            StyledText(
              'A decodable local image, and a deliberately corrupt one, '
              'the initials stay on screen either way',
              TextStyles.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
      ],
    );
  }
}

class _BasicPreview extends StatelessWidget {
  const _BasicPreview();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Wrap(
      spacing: space(6),
      runSpacing: space(4),
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Avatar(fallback: 'AB'),
            SizedBox(height: space(2)),
            StyledText(
              'Fallback only',
              TextStyles.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Avatar(fallback: 'AB', image: MemoryImage(_validAvatarPng)),
            SizedBox(height: space(2)),
            StyledText(
              'Image and fallback',
              TextStyles.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
      ],
    );
  }
}

class _BadgePreview extends StatelessWidget {
  const _BadgePreview();

  @override
  Widget build(BuildContext context) => Avatar(
    fallback: 'AB',
    size: AvatarSize.lg,
    badge: AvatarBadge(fill: Palette.value),
  );
}

class _BadgeIconPreview extends StatelessWidget {
  const _BadgeIconPreview();

  @override
  Widget build(BuildContext context) => Avatar(
    fallback: 'AB',
    size: AvatarSize.lg,
    badge: AvatarBadge(
      fill: Palette.value,
      child: const Icon(
        IconGlyph.plus,
        size: IconSize.xs,
        tone: IconTone.normal,
      ),
    ),
  );
}

class _AvatarGroupPreview extends StatelessWidget {
  const _AvatarGroupPreview();

  @override
  Widget build(BuildContext context) => Builder(
    builder: (BuildContext context) => AvatarGroup(
      children: <Widget>[
        for (final String initials in <String>['VW', 'EM', 'TC', 'SW'])
          Avatar(
            fallback: initials,
            fallbackSpec: TextStyles.avatarFallback,
            ring: AvatarGroup.ringOf(context),
          ),
      ],
    ),
  );
}

class _AvatarGroupCountPreview extends StatelessWidget {
  const _AvatarGroupCountPreview();

  @override
  Widget build(BuildContext context) => Builder(
    builder: (BuildContext context) => AvatarGroup(
      children: <Widget>[
        for (final String initials in <String>['VW', 'EM', 'TC', 'SW'])
          Avatar(
            fallback: initials,
            fallbackSpec: TextStyles.avatarFallback,
            ring: AvatarGroup.ringOf(context),
          ),
        const AvatarGroupCount('+248'),
      ],
    ),
  );
}

class _SizesPreview extends StatelessWidget {
  const _SizesPreview();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(4),
    runSpacing: space(3),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      Avatar(
        fallback: 'AB',
        size: AvatarSize.sm,
        fallbackSpec: TextStyles.avatarInitials,
      ),
      Avatar(fallback: 'AB', fallbackSpec: TextStyles.avatarFallback),
      const Avatar(fallback: 'AB', size: AvatarSize.lg),
    ],
  );
}

class _DropdownPreview extends StatelessWidget {
  const _DropdownPreview();

  @override
  Widget build(BuildContext context) => DropdownMenu(
    width: space(52),
    trigger: Avatar(fallback: 'AB', fallbackSpec: TextStyles.avatarFallback),
    children: <MenuChild>[
      const MenuLabel('My Account'),
      const MenuSeparator(),
      MenuItem(label: 'Profile', icon: IconGlyph.user, onSelect: () {}),
      MenuItem(label: 'Billing', icon: IconGlyph.creditCard, onSelect: () {}),
      const MenuSeparator(),
      MenuItem(label: 'Log out', icon: IconGlyph.logOut, onSelect: () {}),
    ],
  );
}

class _RtlPreview extends StatelessWidget {
  const _RtlPreview();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Avatar(fallback: 'أف', fallbackSpec: TextStyles.avatarFallback),
          SizedBox(width: space(2)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StyledText('أسترا فالي', TextStyles.nav, color: theme.foreground),
              StyledText(
                'astra@elattar.dev',
                TextStyles.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elavatar',
        child: DocsApiTable(title: 'Avatar', facts: _dsAvatarFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-elavatarsize',
        child: DocsApiTable(title: 'AvatarSize', facts: _dsAvatarSizeFacts),
      ),
      SizedBox(height: space(5)),
      const DocsAnchor(
        id: 'api-supporting',
        child: DocsApiTable(title: 'Supporting types', facts: _supportingFacts),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Give a standalone avatar its own label: wrap it in '
            'Semantics(label: "…profile photo", image: true, child: '
            'Avatar(...)).',
        'When the avatar sits beside visible identity text: as it does '
            'in the sidebar footer\'s UserMenu: that adjacent text already '
            'names the person, so no extra label is needed there.',
        'Avatar is not focusable and defines no keyboard behavior of '
            'its own; keyboard interaction belongs to whatever '
            'interactive ancestor wraps it (see Keyboard below).',
        'The default 24-40px box can sit under common touch-target '
            'minimums when the avatar itself is the tappable element, '
            'add touch-target padding on the wrapping control rather '
            'than shrinking it there.',
        'Identity itself is never carried by color alone. ring and badge '
            'are color-only decorations, though: pair a badge that '
            'communicates real status with a label or tooltip on its '
            'wrapper, not the dot alone.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No key handling of its own: avatar.dart wires no '
            'Focus.onKeyEvent anywhere. Avatar is a plain StatelessWidget '
            'built from DecoratedBox, Stack, and CustomPaint: none of '
            'those request focus.',
        'Not focusable: with no Focus node of its own, Avatar cannot '
            'receive keyboard focus and has no key binding — a keyboard '
            'user tabs straight past it to whatever interactive ancestor '
            'wraps it (the Dropdown section above is that ancestor).',
        'Tab order: avatar.dart declares no FocusTraversalPolicy. Tab and '
            'Shift+Tab walk whatever order the surrounding page already '
            'declares.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Choose a AvatarSize rung per breakpoint, or compute an '
            'explicit sizePx from the surrounding layout: the widget does '
            'not adapt on its own.',
        'AvatarGroup.overlap is a fixed 8px constant; it does not scale '
            'with viewport width.',
        'No platform channels are used, so behavior is identical on '
            'every Flutter target this package supports.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
        facts: <DocsInstallFact>[
          const DocsInstallFact(
            label: 'Registry item',
            value: 'avatar',
            description:
                'registry/components/avatar.json exists and is '
                'installable through the CLI today.',
          ),
          const DocsInstallFact(
            label: 'Destination',
            value: 'lib/components/ui/avatar.dart',
            description:
                'The same lib/components/ui/ target every component '
                'installs to.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: avatarDoc.dependencies.join(', '),
            description:
                "The manifest's registryDependencies, resolved "
                'automatically by the registry client.',
          ),
          const DocsInstallFact(
            label: 'Assets',
            value: 'None',
            description:
                'Avatar takes any ImageProvider the caller supplies; it '
                'ships no bundled asset of its own.',
          ),
          const DocsInstallFact(
            label: 'Fonts and shaders',
            value: 'None beyond the foundation',
            description:
                'The fallback text uses whichever TextStyleToken is passed or '
                'defaulted (Fonts.mono for avatarFallback, Fonts.sans '
                'for avatarInitials): both already shipped by the '
                'foundation, not by this component.',
          ),
          const DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description:
                'Avatar is built entirely from Flutter framework '
                'primitives (CustomPaint, DecoratedBox, Image) with no '
                'platform channels, so it renders the same everywhere '
                'Flutter itself runs.',
          ),
        ],
      ),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(label: 'Dropdown Menu', route: '/components/dropdown-menu'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(
    BuildContext context,
  ) => _bullets(ThemeScope.of(context), <String>[
    'The fallback fill/ink default to theme.muted / '
        'theme.mutedForeground; fallbackFill and fallbackInk override '
        'either independently, as the leaderboard leader specimen '
        'does with Palette.value.',
    'The hairline rim always resolves to theme.border: there is no '
        'parameter that overrides its color.',
    'The rim blends darken against a light theme and lighten against '
        'a dark one (theme.kind == ResolvedColorMode.dark), so the same rim '
        'reads on a photo and on a flat fill in both modes without '
        'ever being drawn as a solid line over the subject.',
    'ring and badge take explicit colors from the call site, '
        'AvatarGroup.ringOf(context) is the one built-in helper, '
        'resolving to theme.background at the shared '
        'avatarRingWidth.',
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
