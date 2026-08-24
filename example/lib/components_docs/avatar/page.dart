/// Public component documentation for the avatar component.
///
/// Reshaped to the shadcn parity frame (Phase J supervisor's shadcn-parity
/// pass): the reader knows https://ui.shadcn.com/docs/components/base/avatar
/// and finds the same answers, in the same order, on this page. The live
/// demo sits above the first heading, exactly as the reference has it, with
/// no `Overview`, `Status`, or `Preview` heading anywhere; the Version and
/// Platforms facts a Status section would have carried live inside
/// Installation instead, since avatar ships in the registry.
///
/// `avatar` is not backed by a registry manifest yet: see the Installation
/// section below for exactly what that means today. Three of the live
/// specimens on this page feed [ElAvatar] bytes that never touch the
/// network: a tiny valid local PNG for the "image loads" state, and four
/// bytes that are not a decodable image at all for the "decode fails" state.
/// Both were verified against the real widget before being written here,
/// see `example/test/components_docs/avatar_test.dart`.
///
/// **Skipped from the reference:** "Avatar Group with Icon". [ElAvatarGroup]
/// composes [ElAvatarGroupCount] for its overflow indicator, and
/// [ElAvatarGroupCount] takes only a `String label`, there is no icon slot
/// on it to swap the count text for a glyph. Faking one here would draw a
/// capability this widget does not have, so the section is not built.
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
            'Use ElAvatar to represent a person or account: a photo when one '
            'loads, initials underneath when it does not. Reach for ElIcon '
            'instead when the mark is a generic glyph rather than an '
            'identity; reach for ElItemMedia or a plain image when the '
            'content is not a person or account at all; and use the '
            'separate agent_avatar.dart family (ElCubeAvatar / ElAgentCube) '
            'for the animated isometric agent face: a different component '
            'with a different rendering model, not a variant of this one.',
      ),
      breadcrumbs: const <ElBreadcrumbEntry>[
        ElBreadcrumbEntry.link('Components'),
        ElBreadcrumbEntry.page('Avatar'),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(title: 'Basic', anchor: 'basic'),
        DocsTocEntry(title: 'Badge', anchor: 'badge'),
        DocsTocEntry(title: 'Badge with icon', anchor: 'badge-icon'),
        DocsTocEntry(title: 'Avatar group', anchor: 'avatar-group'),
        DocsTocEntry(title: 'Avatar group count', anchor: 'avatar-group-count'),
        DocsTocEntry(title: 'Sizes', anchor: 'sizes'),
        DocsTocEntry(title: 'Dropdown', anchor: 'dropdown'),
        DocsTocEntry(title: 'RTL', anchor: 'rtl'),
        DocsTocEntry(title: 'API Reference', anchor: 'api'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
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
      // shadcn: the live demo that opens the page, before any heading. No
      // ElSection, no id, no TOC entry: matching the reference exactly,
      // "before any heading" means before Installation's own heading too.
      DocsCodeExample(
        title: 'Avatar specimens',
        description:
            'Sizes, the sizePx override, a status badge, and a value ring on '
            'the left; a locally-decodable image and a deliberately '
            'corrupted one on the right, so the loaded and failed image '
            'states are both real rather than described from memory. The '
            'fallback initials render immediately in every case; the image '
            '(when supplied and decodable) paints over them.',
        preview: const _AvatarPreview(),
        manualFiles: const <DocsCodeFile>[
          DocsCodeFile(
            path: 'main.dart',
            title: 'Import from the package',
            description:
                'avatar ships in the registry, so it is not copied '
                'into lib/components/ui/. Import it directly instead.',
            code:
                "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                '// ElAvatar, ElAvatarBadge, ElAvatarGroup and\n'
                '// ElAvatarGroupCount are all exported from the barrel.',
          ),
        ],
      ),
      SizedBox(height: el(8)),
      // shadcn: Installation, Command and Manual tabs.
      ElSection(
        id: 'install',
        title: 'Installation',
        description:
            'Install with `elattar add avatar`, or copy the source file manually when you need a local fork.',
        child: const DocsInstallFacts(
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'CLI',
              value: 'elattar add avatar',
              description:
                  'Installs registry/components/avatar.json and its declared '
                  'dependency closure.',
            ),
            DocsInstallFact(
              label: 'Package import',
              value:
                  "import 'package:elattar_design_system/elattar_design_system.dart';",
              description: 'Use ElAvatar straight from the package today.',
            ),
            DocsInstallFact(
              label: 'Source path',
              value: 'lib/src/components/avatar.dart',
              description: 'The single authoritative source file.',
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
                  'ElAvatar is built entirely from Flutter framework '
                  'primitives (CustomPaint, DecoratedBox, Image) with no '
                  'platform channels, so it renders the same everywhere '
                  'Flutter itself runs.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      // shadcn: Usage, imports plus basic construction.
      ElSection(
        id: 'usage',
        title: 'Usage',
        description:
            'Start from a bare fallback, then add an image, a ring, or a '
            'badge as the identity needs them.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElPanel(
              label: 'DART',
              note: 'SMALLEST EXAMPLE',
              child: DocsSelectableCodeBlock(code: _smallestUsageCode),
            ),
            SizedBox(height: el(4)),
            ElPanel(
              label: 'DART',
              note: 'IMAGE WITH A FALLBACK',
              child: DocsSelectableCodeBlock(code: _imageUsageCode),
            ),
            SizedBox(height: el(4)),
            ElPanel(
              label: 'DART',
              note: 'RING AND BADGE',
              child: DocsSelectableCodeBlock(code: _ringBadgeUsageCode),
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      // shadcn: Composition, the widget-hierarchy tree. ElAvatar is one
      // widget with a Stack of optional layers, not a family of separate
      // subcomponents the way Avatar/AvatarImage/AvatarFallback are on the
      // reference; ElAvatarGroup is the one real parent/child composition
      // this family has, so both anatomies are shown together here.
      ElSection(
        id: 'composition',
        title: 'Composition',
        description:
            'ElAvatar folds AvatarImage and AvatarFallback into one '
            'widget\'s Stack rather than two composable subcomponents. '
            'ElAvatarGroup is the family\'s one real parent/child tree.',
        child: ElPanel(
          label: 'DART',
          note: 'ANATOMY',
          child: const DocsSelectableCodeBlock(code: _compositionAnatomyCode),
        ),
      ),
      SizedBox(height: el(6)),
      // shadcn: Basic, a simple avatar with an image and a fallback.
      ElSection(
        id: 'basic',
        title: 'Basic',
        description:
            'A bare fallback, and the same avatar once a decodable image '
            'is supplied.',
        child: DocsCodeExample(
          title: 'Basic',
          preview: const _BasicPreview(),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'avatar_basic.dart',
              title: 'Basic',
              code: _basicCode,
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      // shadcn: Badge, a status dot pinned to the corner.
      ElSection(
        id: 'badge',
        title: 'Badge',
        description: 'A status dot pinned to the bottom-right corner.',
        child: DocsCodeExample(
          title: 'Badge',
          preview: const Center(child: _BadgePreview()),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'avatar_badge.dart',
              title: 'Badge',
              code: _badgeCode,
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      // shadcn: Badge with Icon, a glyph inside the badge instead of no
      // content at all.
      ElSection(
        id: 'badge-icon',
        title: 'Badge with icon',
        description:
            'ElAvatarBadge.child takes any widget; no corpus call site '
            'used it until this specimen, so this is new code exercising a '
            'real, already-public slot rather than a fabricated one.',
        child: DocsCodeExample(
          title: 'Badge with icon',
          preview: const Center(child: _BadgeIconPreview()),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'avatar_badge_icon.dart',
              title: 'Badge with icon',
              code: _badgeIconCode,
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      // shadcn: Avatar Group, overlapping circles.
      ElSection(
        id: 'avatar-group',
        title: 'Avatar group',
        description:
            'ElAvatarGroup overlaps its children by 8px each and forces '
            'ElAvatarGroup.ringOf(context) onto every one of them, so the '
            'circles stay separated against the page background.',
        child: DocsCodeExample(
          title: 'Avatar group',
          preview: const _AvatarGroupPreview(),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'avatar_group.dart',
              title: 'Avatar group',
              code: _avatarGroupCode,
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      // shadcn: Avatar Group Count, a "+N" overflow indicator at the end of
      // the group.
      ElSection(
        id: 'avatar-group-count',
        title: 'Avatar group count',
        description:
            'ElAvatarGroupCount reads the group\'s own ring rather than '
            'carrying one of its own, so it slots in as the group\'s last '
            'child like any other overflow indicator would.',
        child: DocsCodeExample(
          title: 'Avatar group count',
          description: 'Who opened this pack.',
          preview: const _AvatarGroupCountPreview(),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'avatar_group_count.dart',
              title: 'Avatar group count',
              code: _avatarGroupCountCode,
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      // shadcn: Sizes.
      ElSection(
        id: 'sizes',
        title: 'Sizes',
        description:
            'size picks a rung (sm/md/lg); sizePx overrides only the box. '
            'The badge dot always scales off size, even when sizePx has '
            'overridden the diameter: the same class-beats-attribute split '
            'ElIcon.sizePx carries, verified in the package\'s own '
            'test/data_display_test.dart.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const DocsCodeExample(
              title: 'Sizes',
              preview: _SizesPreview(),
              manualFiles: <DocsCodeFile>[
                DocsCodeFile(
                  path: 'avatar_sizes.dart',
                  title: 'Sizes',
                  code: _sizesCode,
                ),
              ],
            ),
            SizedBox(height: el(4)),
            const _Bullets(
              items: <String>[
                'ElAvatarSize.sm, 24px avatar, 8px badge dot.',
                'ElAvatarSize.md, 32px avatar (the default), 10px badge dot.',
                'ElAvatarSize.lg, 40px avatar, 12px badge dot.',
                'sizePx: 40 with size left at its default md still draws a '
                    '10px badge, not the 12px an lg avatar would carry: the '
                    'attribute (size) drives the badge; the class (sizePx) '
                    'drives only the box.',
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      // shadcn: Dropdown, an avatar used as a menu trigger.
      ElSection(
        id: 'dropdown',
        title: 'Dropdown',
        description:
            'ElAvatar takes no onTap of its own, so any pressable ancestor '
            'can use one as its trigger: here, ElDropdownMenu.trigger, the '
            'same pattern the sidebar footer\'s NavUser composes.',
        child: DocsCodeExample(
          title: 'Dropdown',
          preview: const _DropdownPreview(),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'avatar_dropdown.dart',
              title: 'Dropdown',
              code: _dropdownCode,
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      // shadcn: RTL.
      ElSection(
        id: 'rtl',
        title: 'RTL',
        description:
            'The circle itself has no direction to flip; what does flip is '
            'a composition around it, an identity row\'s avatar and text '
            'trade sides under a Directionality the same way ElBreadcrumb\'s '
            'own RTL specimen does.',
        child: DocsCodeExample(
          title: 'RTL',
          preview: const _RtlPreview(),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(path: 'avatar_rtl.dart', title: 'RTL', code: _rtlCode),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      ElSection(
        id: 'api',
        title: 'API Reference',
        description:
            'Every public constructor parameter on ElAvatar, followed by the '
            'size rungs and the supporting types (ElAvatarBadge, '
            'ElAvatarGroup, ElAvatarGroupCount, ElAvatarRing, '
            'elAvatarRingWidth, ElAvatarRimPainter) it is built from.',
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DocsApiTable(title: 'ElAvatar', facts: _dsAvatarFacts),
            SizedBox(height: 24),
            DocsApiTable(title: 'ElAvatarSize', facts: _dsAvatarSizeFacts),
            SizedBox(height: 24),
            DocsApiTable(title: 'Supporting types', facts: _supportingFacts),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      ElSection(
        id: 'states',
        title: 'States',
        description:
            'ElAvatar is not interactive on its own, so hover, focus, press, '
            'select, and disabled do not apply to it directly: wrap it in a '
            'pressable ancestor, as NavUser wraps it in a '
            'ElSidebarMenuButton, if the composition needs one of those.',
        child: const DocsStateMatrix(
          facts: <DocsStateFact>[
            DocsStateFact(
              state: 'Rest (fallback only)',
              treatment: 'image is null; the fallback renders outright.',
              userSignal:
                  'A muted circular fill with initials: no spinner, no '
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
                  'ElAvatar wires no errorBuilder, so a decode/load failure '
                  'is reported to FlutterError and the Image paints '
                  'nothing: the fallback beneath keeps showing through.',
              userSignal:
                  'Initials remain readable instead of a broken-image icon, '
                  'verified in this page\'s own test with a corrupt '
                  'MemoryImage.',
            ),
            DocsStateFact(
              state: 'Hover / Focus-visible / Pressed / Selected / Disabled',
              treatment:
                  'N/A, ElAvatar takes no onTap/onPressed and paints no '
                  'interactive state of its own.',
              userSignal:
                  'Add these by wrapping ElAvatar in an interactive '
                  'ancestor; they are that ancestor\'s states, not this '
                  'widget\'s.',
            ),
            DocsStateFact(
              state: 'Empty',
              treatment:
                  'N/A: fallback is a required constructor parameter, so '
                  'there is always something to render.',
              userSignal: 'There is no "no avatar at all" state to design.',
            ),
            DocsStateFact(
              state: 'Reduced motion',
              treatment: 'N/A, ElAvatar performs no animation.',
              userSignal: 'Nothing to freeze; there is nothing moving.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      ElSection(
        id: 'accessibility',
        title: 'Accessibility',
        description:
            'ElAvatar does not wrap itself in a Semantics node: read '
            'directly from lib/src/components/avatar.dart, there is none in '
            'the class.',
        child: const _Bullets(
          items: <String>[
            'Give a standalone avatar its own label: wrap it in '
                'Semantics(label: "…profile photo", image: true, child: '
                'ElAvatar(...)).',
            'When the avatar sits beside visible identity text: as it does '
                'in the sidebar footer\'s NavUser: that adjacent text '
                'already names the person, so no extra label is needed '
                'there.',
            'ElAvatar is not focusable and defines no keyboard behavior of '
                'its own; keyboard interaction belongs to whatever '
                'interactive ancestor wraps it.',
            'The default 24-40px box can sit under common touch-target '
                'minimums when the avatar itself is the tappable element, '
                'add touch-target padding on the wrapping control rather '
                'than shrinking it there.',
            'Identity itself is never carried by color alone. ring and '
                'badge are color-only decorations, though: pair a badge '
                'that communicates real status with a label or tooltip on '
                'its wrapper, not the dot alone.',
          ],
        ),
      ),
      SizedBox(height: el(6)),
      ElSection(
        id: 'responsive',
        title: 'Responsive',
        description:
            'ElAvatar has no internal breakpoints and no platform-specific '
            'behavior; it is a fixed-size visual mark start to finish.',
        child: const _Bullets(
          items: <String>[
            'Choose a ElAvatarSize rung per breakpoint, or compute an '
                'explicit sizePx from the surrounding layout: the widget '
                'does not adapt on its own.',
            'ElAvatarGroup.overlap is a fixed 8px constant; it does not '
                'scale with viewport width.',
            'No platform channels are used, so behavior is identical on '
                'every Flutter target this package supports.',
          ],
        ),
      ),
      SizedBox(height: el(6)),
      ElSection(
        id: 'dependencies',
        title: 'Dependencies',
        description:
            'No registry item exists yet, so there are no registry '
            'dependencies to list: see Installation above.',
        child: const DocsInstallFacts(
          title: 'Files and assets',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Files',
              value: 'lib/src/components/avatar.dart',
              description: 'One file; ElAvatar is not split across sources.',
            ),
            DocsInstallFact(
              label: 'Assets',
              value: 'None',
              description:
                  'ElAvatar takes any ImageProvider the caller supplies; it '
                  'ships no bundled asset of its own.',
            ),
            DocsInstallFact(
              label: 'Fonts and shaders',
              value: 'None beyond the foundation',
              description:
                  'The fallback text uses whichever ElTypeSpec is passed or '
                  'defaulted (ElFonts.mono for avatarFallback, ElFonts.sans '
                  'for avatarInitials): both already shipped by the '
                  'foundation, not by this component.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      ElSection(
        id: 'theming',
        title: 'Theming',
        description:
            'Toggle the site theme control to compare: the rim recomputes '
            'automatically; nothing on this page hardcodes either mode.',
        child: const _Bullets(
          items: <String>[
            'The fallback fill/ink default to theme.muted / '
                'theme.mutedForeground; fallbackFill and fallbackInk '
                'override either independently, as the leaderboard leader '
                'specimen does with ElPalette.value.',
            'The hairline rim always resolves to theme.border: there is '
                'no parameter that overrides its color.',
            'The rim blends darken against a light theme and lighten '
                'against a dark one (theme.kind == ElThemeKind.dark), so '
                'the same rim reads on a photo and on a flat fill in both '
                'modes without ever being drawn as a solid line over the '
                'subject.',
            'ring and badge take explicit colors from the call site, '
                'ElAvatarGroup.ringOf(context) is the one built-in helper, '
                'resolving to theme.background at the shared '
                'elAvatarRingWidth.',
          ],
        ),
      ),
      SizedBox(height: el(6)),
      ElSection(
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
                  'ElAvatar, ElAvatarSize, ElAvatarRing, elAvatarRingWidth, '
                  'ElAvatarBadge, ElAvatarGroup, ElAvatarGroupCount, '
                  'ElAvatarRimPainter',
              description: 'Public symbols available after import.',
            ),
            DocsInstallFact(
              label: 'Tests',
              value:
                  'test/data_display_test.dart (ElAvatar group), '
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

const String _smallestUsageCode = '''const ElAvatar(fallback: 'AB')''';

const String _imageUsageCode = '''ElAvatar(
  fallback: 'AB',
  image: NetworkImage(user.photoUrl),
  fallbackSpec: ElComponentType.avatarFallback,
)''';

const String _ringBadgeUsageCode = '''ElAvatar(
  fallback: '#1',
  sizePx: el(10),
  ring: (color: ElPalette.value, width: elAvatarRingWidth),
  badge: ElAvatarBadge(fill: ElPalette.value),
)''';

const String _compositionAnatomyCode = '''ElAvatar
  Stack
    fallback circle        // DecoratedBox + ElText, always painted first
    Image                  // only when `image` is supplied and decodes
    ElAvatarRimPainter     // the always-on hairline rim, painted last
    _AvatarBadgeBox        // only when `badge` is supplied

ElAvatarGroup
  children: [
    ElAvatar(...), ElAvatar(...), ...,
    ElAvatarGroupCount('+N'),   // optional, always last
  ]''';

const String _basicCode = '''ElAvatar(fallback: 'AB')

ElAvatar(
  fallback: 'AB',
  image: NetworkImage(user.photoUrl),
)''';

const String _badgeCode = '''ElAvatar(
  fallback: 'AB',
  size: ElAvatarSize.lg,
  badge: ElAvatarBadge(fill: ElPalette.value),
)''';

const String _badgeIconCode = '''ElAvatar(
  fallback: 'AB',
  size: ElAvatarSize.lg,
  badge: ElAvatarBadge(
    fill: ElPalette.value,
    child: const ElIcon(
      ElIconGlyph.plus,
      size: ElIconSize.xs,
      tone: ElIconTone.normal,
    ),
  ),
)''';

const String _avatarGroupCode = '''ElAvatarGroup(
  children: <Widget>[
    for (final String initials in <String>['VW', 'EM', 'TC', 'SW'])
      ElAvatar(
        fallback: initials,
        fallbackSpec: ElComponentType.avatarFallback,
        ring: ElAvatarGroup.ringOf(context),
      ),
  ],
)''';

const String _avatarGroupCountCode = '''ElAvatarGroup(
  children: <Widget>[
    for (final String initials in <String>['VW', 'EM', 'TC', 'SW'])
      ElAvatar(
        fallback: initials,
        fallbackSpec: ElComponentType.avatarFallback,
        ring: ElAvatarGroup.ringOf(context),
      ),
    const ElAvatarGroupCount('+248'),
  ],
)''';

const String _sizesCode = '''ElAvatar(fallback: 'AB', size: ElAvatarSize.sm)
ElAvatar(fallback: 'AB') // size: ElAvatarSize.md, the default
ElAvatar(fallback: 'AB', size: ElAvatarSize.lg)''';

const String _dropdownCode = '''ElDropdownMenu(
  trigger: const ElAvatar(
    fallback: 'AB',
    fallbackSpec: ElComponentType.avatarFallback,
  ),
  children: <ElMenuChild>[
    const ElMenuLabel('My Account'),
    const ElMenuSeparator(),
    ElMenuItem(label: 'Profile', icon: ElIconGlyph.user, onSelect: () {}),
    ElMenuItem(label: 'Billing', icon: ElIconGlyph.creditCard, onSelect: () {}),
    const ElMenuSeparator(),
    ElMenuItem(label: 'Log out', icon: ElIconGlyph.logOut, onSelect: () {}),
  ],
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: Row(
    children: <Widget>[
      ElAvatar(fallback: 'أف', fallbackSpec: ElComponentType.avatarFallback),
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
    type: 'ElAvatarSize',
    description: 'sm, md (default), or lg. Always drives the badge rung.',
  ),
  DocsApiFact(
    name: 'fallbackSpec',
    type: 'ElTypeSpec?',
    description:
        'The fallback text\'s type. Defaults to ElComponentType.textSm; '
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
    type: 'ElAvatarRing?',
    description:
        'An outset colored ring: costs the box nothing, so a ringed '
        'avatar still measures exactly its own diameter.',
  ),
  DocsApiFact(
    name: 'badge',
    type: 'ElAvatarBadge?',
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
    type: 'ElAvatarSize',
    description: '24px avatar (el(6)); 8px badge dot (el(2)).',
  ),
  DocsApiFact(
    name: 'md',
    type: 'ElAvatarSize',
    description:
        '32px avatar (el(8)): the default, and the only rung the corpus '
        'renders live today; 10px badge dot (el(2.5)).',
  ),
  DocsApiFact(
    name: 'lg',
    type: 'ElAvatarSize',
    description: '40px avatar (el(10)); 12px badge dot (el(3)).',
  ),
];

const List<DocsApiFact> _supportingFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'ElAvatarBadge.fill',
    type: 'Color',
    description:
        'Required: every real call site overrides the dot\'s fill, so '
        'there is no default color.',
  ),
  DocsApiFact(
    name: 'ElAvatarBadge.child',
    type: 'Widget?',
    description:
        'An optional glyph inside the dot: the Badge with icon section '
        'above is this page\'s own specimen of it.',
  ),
  DocsApiFact(
    name: 'ElAvatarGroup.children',
    type: 'List<Widget>',
    description: 'The avatars, then optionally a ElAvatarGroupCount last.',
  ),
  DocsApiFact(
    name: 'ElAvatarGroup.overlap',
    type: 'static double',
    description:
        '8px (el(2)): how far each child after the first is pulled left.',
  ),
  DocsApiFact(
    name: 'ElAvatarGroup.ringOf(context)',
    type: 'static ElAvatarRing',
    description:
        'theme.background at elAvatarRingWidth: the ring every child in '
        'a group should wear so overlapping circles stay separated.',
  ),
  DocsApiFact(
    name: "ElAvatarGroupCount(label, {spec})",
    type: 'Widget',
    description:
        'A "+248"-style overflow count, sized and ringed like a group '
        'avatar (32px, the group\'s default rung).',
  ),
  DocsApiFact(
    name: 'ElAvatarRing',
    type: 'typedef ({Color color, double width})',
    description: 'The record type ring expects.',
  ),
  DocsApiFact(
    name: 'elAvatarRingWidth',
    type: 'double',
    description: '2: the width both ring call sites in the corpus use.',
  ),
  DocsApiFact(
    name: 'ElAvatarRimPainter',
    type: 'CustomPainter',
    description:
        'Paints the always-on hairline rim in theme.border, blended '
        'darken (light) or lighten (dark). Built internally by ElAvatar; '
        'not meant to be constructed directly.',
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

class _AvatarPreview extends StatelessWidget {
  const _AvatarPreview();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Wrap(
      spacing: el(6),
      runSpacing: el(4),
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Wrap(
              spacing: el(3),
              runSpacing: el(3),
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                ElAvatar(
                  fallback: 'AB',
                  size: ElAvatarSize.sm,
                  fallbackSpec: ElComponentType.avatarInitials,
                ),
                ElAvatar(
                  fallback: 'AB',
                  fallbackSpec: ElComponentType.avatarFallback,
                ),
                const ElAvatar(fallback: 'AB', size: ElAvatarSize.lg),
                ElAvatar(
                  fallback: '#1',
                  sizePx: 40,
                  ring: (color: ElPalette.value, width: elAvatarRingWidth),
                ),
                ElAvatar(
                  fallback: 'AB',
                  size: ElAvatarSize.lg,
                  badge: ElAvatarBadge(fill: ElPalette.value),
                ),
              ],
            ),
            SizedBox(height: el(2)),
            ElText(
              'sm, md, lg, a value ring, and a status badge',
              ElType.small,
              color: theme.mutedForeground,
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Wrap(
              spacing: el(3),
              runSpacing: el(3),
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                ElAvatar(
                  fallback: 'AB',
                  size: ElAvatarSize.lg,
                  image: MemoryImage(_validAvatarPng),
                ),
                ElAvatar(
                  fallback: 'AB',
                  size: ElAvatarSize.lg,
                  image: MemoryImage(_corruptAvatarBytes),
                ),
              ],
            ),
            SizedBox(height: el(2)),
            ElText(
              'A decodable local image, and a deliberately corrupt one, '
              'the initials stay on screen either way',
              ElType.small,
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
    final ElThemeData theme = ElTheme.of(context);
    return Wrap(
      spacing: el(6),
      runSpacing: el(4),
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ElAvatar(fallback: 'AB'),
            SizedBox(height: el(2)),
            ElText('Fallback only', ElType.small, color: theme.mutedForeground),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElAvatar(fallback: 'AB', image: MemoryImage(_validAvatarPng)),
            SizedBox(height: el(2)),
            ElText(
              'Image and fallback',
              ElType.small,
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
  Widget build(BuildContext context) => ElAvatar(
    fallback: 'AB',
    size: ElAvatarSize.lg,
    badge: ElAvatarBadge(fill: ElPalette.value),
  );
}

class _BadgeIconPreview extends StatelessWidget {
  const _BadgeIconPreview();

  @override
  Widget build(BuildContext context) => ElAvatar(
    fallback: 'AB',
    size: ElAvatarSize.lg,
    badge: ElAvatarBadge(
      fill: ElPalette.value,
      child: const ElIcon(
        ElIconGlyph.plus,
        size: ElIconSize.xs,
        tone: ElIconTone.normal,
      ),
    ),
  );
}

class _AvatarGroupPreview extends StatelessWidget {
  const _AvatarGroupPreview();

  @override
  Widget build(BuildContext context) => Builder(
    builder: (BuildContext context) => ElAvatarGroup(
      children: <Widget>[
        for (final String initials in <String>['VW', 'EM', 'TC', 'SW'])
          ElAvatar(
            fallback: initials,
            fallbackSpec: ElComponentType.avatarFallback,
            ring: ElAvatarGroup.ringOf(context),
          ),
      ],
    ),
  );
}

class _AvatarGroupCountPreview extends StatelessWidget {
  const _AvatarGroupCountPreview();

  @override
  Widget build(BuildContext context) => Builder(
    builder: (BuildContext context) => ElAvatarGroup(
      children: <Widget>[
        for (final String initials in <String>['VW', 'EM', 'TC', 'SW'])
          ElAvatar(
            fallback: initials,
            fallbackSpec: ElComponentType.avatarFallback,
            ring: ElAvatarGroup.ringOf(context),
          ),
        const ElAvatarGroupCount('+248'),
      ],
    ),
  );
}

class _SizesPreview extends StatelessWidget {
  const _SizesPreview();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: el(4),
    runSpacing: el(3),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      ElAvatar(
        fallback: 'AB',
        size: ElAvatarSize.sm,
        fallbackSpec: ElComponentType.avatarInitials,
      ),
      ElAvatar(fallback: 'AB', fallbackSpec: ElComponentType.avatarFallback),
      const ElAvatar(fallback: 'AB', size: ElAvatarSize.lg),
    ],
  );
}

class _DropdownPreview extends StatelessWidget {
  const _DropdownPreview();

  @override
  Widget build(BuildContext context) => ElDropdownMenu(
    width: el(52),
    trigger: ElAvatar(
      fallback: 'AB',
      fallbackSpec: ElComponentType.avatarFallback,
    ),
    children: <ElMenuChild>[
      const ElMenuLabel('My Account'),
      const ElMenuSeparator(),
      ElMenuItem(label: 'Profile', icon: ElIconGlyph.user, onSelect: () {}),
      ElMenuItem(
        label: 'Billing',
        icon: ElIconGlyph.creditCard,
        onSelect: () {},
      ),
      const ElMenuSeparator(),
      ElMenuItem(label: 'Log out', icon: ElIconGlyph.logOut, onSelect: () {}),
    ],
  );
}

class _RtlPreview extends StatelessWidget {
  const _RtlPreview();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElAvatar(
            fallback: 'أف',
            fallbackSpec: ElComponentType.avatarFallback,
          ),
          SizedBox(width: el(2)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElText('أسترا فالي', ElType.nav, color: theme.foreground),
              ElText(
                'astra@elattar.dev',
                ElType.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  const _Bullets({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ElPanel(
      label: 'Guidance',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < items.length; i++) ...<Widget>[
            if (i > 0) SizedBox(height: el(2)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ElText('•  ', ElType.small, color: theme.mutedForeground),
                Expanded(
                  child: ElText(
                    items[i],
                    ElType.small,
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
