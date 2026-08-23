/// Public documentation page for the `button` component.
///
/// This is the **reference shape** the Phase J supervisor asked for
/// (https://ui.shadcn.com/docs/components/base/button as the visual target):
/// title + one-sentence hero, a primary Preview/Code specimen, Installation
/// (CLI + Manual), Usage, an `Examples` section carrying one Preview/Code
/// pair PER real variant/size/state composition, API Reference (one table
/// per exported class/enum), and finally the Elattar-specific sections —
/// States, Accessibility, Responsive, Dependencies, Theming, Source — below
/// that. Every other component page is expected to be reshaped to match this
/// one, not the other way around.
///
/// **Nested TOC.** [DocsTocEntry] (in `../../docs/docs_layout.dart`) now
/// carries one level of `children`, so `Examples` is a single parent entry
/// and the thirteen `example-*` anchors are its `children` — rendered
/// indented beneath it in the "ON THIS PAGE" rail and flattened back in next
/// to it in the narrow anchor strip. Anchors and section ids are unchanged;
/// only the shape of the list passed to `toc:` nests.
///
/// Two descriptions live in `meta.dart`, the same split `popover` and
/// `tooltip` already use: [ComponentDocEntry.description] is the short,
/// one-sentence form (nav/search, and this page's own hero paragraph);
/// [buttonExpandedDescription] is the longer "button vs link" guidance,
/// rendered as its own unlabelled paragraph directly under the hero —
/// deliberately not wrapped in its own [DsSection]/anchor, so the required
/// section order starts clean at Preview.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class ButtonDocPage extends StatelessWidget {
  const ButtonDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: buttonDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: buttonDoc.title,
      description: buttonDoc.description,
    ),
    breadcrumbs: const <DsBreadcrumbEntry>[
      DsBreadcrumbEntry.link('Components'),
      DsBreadcrumbEntry.page('Button'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'Preview', anchor: 'preview'),
      DocsTocEntry(title: 'Installation', anchor: 'install'),
      DocsTocEntry(title: 'Usage', anchor: 'usage'),
      DocsTocEntry(
        title: 'Examples',
        anchor: 'examples',
        children: <DocsTocEntry>[
          DocsTocEntry(title: 'Default', anchor: 'example-default'),
          DocsTocEntry(title: 'Premium', anchor: 'example-premium'),
          DocsTocEntry(title: 'Secondary', anchor: 'example-secondary'),
          DocsTocEntry(title: 'Destructive', anchor: 'example-destructive'),
          DocsTocEntry(title: 'Outline', anchor: 'example-outline'),
          DocsTocEntry(title: 'Ghost', anchor: 'example-ghost'),
          DocsTocEntry(title: 'Link', anchor: 'example-link'),
          DocsTocEntry(title: 'Icon', anchor: 'example-icon'),
          DocsTocEntry(title: 'With icon', anchor: 'example-with-icon'),
          DocsTocEntry(title: 'Loading', anchor: 'example-loading'),
          DocsTocEntry(title: 'Disabled', anchor: 'example-disabled'),
          DocsTocEntry(title: 'Sizes', anchor: 'example-sizes'),
          DocsTocEntry(title: 'Emphasis (caps)', anchor: 'example-emphasis'),
        ],
      ),
      DocsTocEntry(title: 'API Reference', anchor: 'api'),
      DocsTocEntry(title: 'States', anchor: 'states'),
      DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
      DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
      DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
      DocsTocEntry(title: 'Theming', anchor: 'theming'),
      DocsTocEntry(title: 'Source', anchor: 'source'),
    ],
    previous: null,
    next: const DocsPageLink(title: 'Card', route: '/components/card'),
    onNavigate: onNavigate,
    child: const _ButtonArticle(),
  );
}

class _ButtonArticle extends StatelessWidget {
  const _ButtonArticle();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      key: const ValueKey<String>('button-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _heroExpansion(),
        SizedBox(height: ds(8)),
        _preview(),
        SizedBox(height: ds(6)),
        _install(),
        SizedBox(height: ds(6)),
        _usage(),
        SizedBox(height: ds(6)),
        _examplesIntro(),
        _exampleDefault(),
        _examplePremium(),
        _exampleSecondary(),
        _exampleDestructive(),
        _exampleOutline(),
        _exampleGhost(),
        _exampleLink(),
        _exampleIcon(),
        _exampleWithIcon(),
        _exampleLoading(),
        _exampleDisabled(),
        _exampleSizes(),
        _exampleEmphasis(),
        _api(),
        _states(),
        _accessibility(theme),
        _responsive(theme),
        _dependencies(theme),
        _theming(theme),
        _source(),
      ],
    );
  }

  /// The CONTENT RULES' "expanded description... when to reach for a button
  /// versus a link", rendered as plain hero prose — not a [DsSection], so it
  /// carries no heading and no TOC anchor of its own. See the library doc.
  Widget _heroExpansion() => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: DsWidths.prose),
    child: DsText(buttonExpandedDescription, DsType.body),
  );

  Widget _preview() => DsSection(
    id: 'preview',
    title: 'Preview',
    description:
        'The default DsButton — primary variant, md size, no emphasis. '
        'Every other variant, size, and state gets its own live specimen '
        'further down, in Examples.',
    child: DocsCodeExample(
      title: 'Button',
      preview: Center(
        child: KeyedSubtree(
          key: const ValueKey<String>('button-preview:hero'),
          child: DsButton(onPressed: () {}, child: const Text('Button')),
        ),
      ),
      manualFiles: const <DocsCodeFile>[
        DocsCodeFile(
          path: 'button_preview.dart',
          title: 'Default button',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              'DsButton(\n'
              '  onPressed: () {},\n'
              "  child: const Text('Button'),\n"
              ')',
        ),
      ],
    ),
  );

  Widget _install() => DsSection(
    id: 'install',
    title: 'Installation',
    description:
        'button has a real registry manifest — `elattar add button` '
        'installs lib/src/components/button.dart and resolves all seven '
        'registryDependencies automatically. The Manual tab is for a '
        'project not using the CLI.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsCodeExample(
          title: 'Install button',
          command: DocsCodeCommand(
            command: buttonDoc.command,
            description:
                'Installs button.dart and resolves source-foundation, '
                'press-motion, icon, spinner, foil-value, machine-surface, '
                'and sheen-action automatically.',
          ),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/button.dart',
              title: '1. Copy the source',
              description:
                  "Copy lib/src/components/button.dart's generated "
                  '@ui/button.dart payload into components/ui.',
              code:
                  "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                  '// Copy the generated button source here when using '
                  'manual mode.',
            ),
            DocsCodeFile(
              path: 'lib/components/ui/ui.dart',
              title: '2. Export it from your barrel',
              description:
                  'Add the export line so DsButton and its four enums/'
                  'classes are reachable the same way the CLI path already '
                  'makes them.',
              code: "export 'button.dart';",
            ),
          ],
        ),
        SizedBox(height: ds(5)),
        DocsInstallFacts(
          title: 'Manual install facts',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Registry dependencies',
              value: buttonDoc.dependencies.join(', '),
              description:
                  'registry/components/button.json\'s own '
                  'registryDependencies, verbatim. Resolved automatically by '
                  '`elattar add button`; install each manually, in this '
                  'order, if you are not using the CLI.',
            ),
            const DocsInstallFact(
              label: 'Manual copy target',
              value: 'lib/components/ui/button.dart',
              description: 'Where the CLI itself would place the file.',
            ),
            const DocsInstallFact(
              label: 'Semantic dependencies',
              value: 'press-motion, icon',
              description:
                  "The manifest's own narrower hint — what a button is "
                  'commonly composed WITH (an icon child; the motion tokens '
                  'an icon-button transition reads), not a second import '
                  'list. button.dart does not import icon.dart itself.',
            ),
          ],
        ),
      ],
    ),
  );

  Widget _usage() => DsSection(
    id: 'usage',
    title: 'Usage',
    description:
        'The smallest correct import and construction. Every example '
        'below only changes named arguments on top of this.',
    child: DsPanel(
      label: 'DART',
      note: 'MINIMAL',
      child: DocsSelectableCodeBlock(code: _usageCode),
    ),
  );

  Widget _examplesIntro() => DsSection(
    id: 'examples',
    title: 'Examples',
    description:
        'One live, runnable specimen per real DsButtonVariant, plus every '
        'DsButtonSize and state composition that renders meaningfully '
        'differently from the one before it — nothing here is shadcn\'s '
        'own variant set; every specimen below is built against the real '
        'DsButtonVariant / DsButtonSize / DsButtonEmphasis this package '
        'ships. Each subsection is its own Preview/Code pair with its own '
        'anchor.',
    child: const SizedBox.shrink(),
  );

  Widget _exampleDefault() => _example(
    id: 'example-default',
    title: 'Default',
    description:
        "DsButtonVariant.primary — the constructor's own default. Painted "
        'through DsSheenAction over theme.primary; shadow-btn-primary at '
        'rest, shadow-btn-down while pressed.',
    panelTitle: 'Default (primary)',
    preview: KeyedSubtree(
      key: const ValueKey<String>('button-example:default'),
      child: DsButton(onPressed: () {}, child: const Text('Button')),
    ),
    path: 'button_default.dart',
    code: "DsButton(\n  onPressed: () {},\n  child: const Text('Button'),\n)",
  );

  Widget _examplePremium() => _example(
    id: 'example-premium',
    title: 'Premium',
    description:
        'DsButtonVariant.premium — the one glowing variant. Painted '
        'through DsFoilValue (a metal-ramp gradient, not a flat fill), '
        'with DsPalette.valueForeground text that deliberately does not '
        'flip between themes. Reserve it for reward and money actions.',
    panelTitle: 'Premium',
    preview: KeyedSubtree(
      key: const ValueKey<String>('button-example:premium'),
      child: DsButton(
        variant: DsButtonVariant.premium,
        onPressed: () {},
        child: const Text('Upgrade to Pro'),
      ),
    ),
    path: 'button_premium.dart',
    code:
        'DsButton(\n'
        '  variant: DsButtonVariant.premium,\n'
        '  onPressed: () {},\n'
        "  child: const Text('Upgrade to Pro'),\n"
        ')',
  );

  Widget _exampleSecondary() => _example(
    id: 'example-secondary',
    title: 'Secondary',
    description:
        'DsButtonVariant.secondary — a neutral action beside a primary '
        'one. Carries no shadow class at all; hover and an open '
        'aria-expanded trigger both resolve to the same accent fill.',
    panelTitle: 'Secondary',
    preview: KeyedSubtree(
      key: const ValueKey<String>('button-example:secondary'),
      child: DsButton(
        variant: DsButtonVariant.secondary,
        onPressed: () {},
        child: const Text('Secondary'),
      ),
    ),
    path: 'button_secondary.dart',
    code:
        'DsButton(\n'
        '  variant: DsButtonVariant.secondary,\n'
        '  onPressed: () {},\n'
        "  child: const Text('Secondary'),\n"
        ')',
  );

  Widget _exampleDestructive() => _example(
    id: 'example-destructive',
    title: 'Destructive',
    description:
        'DsButtonVariant.destructive — a 10% tint of theme.destructive '
        'rather than a solid fill: a solid fill measures under AA against '
        'white text, the tint clears it and still reads unmistakably as '
        'danger. Reach for it for an irreversible or dangerous action.',
    panelTitle: 'Destructive',
    preview: KeyedSubtree(
      key: const ValueKey<String>('button-example:destructive'),
      child: DsButton(
        variant: DsButtonVariant.destructive,
        onPressed: () {},
        child: const Text('Delete account'),
      ),
    ),
    path: 'button_destructive.dart',
    code:
        'DsButton(\n'
        '  variant: DsButtonVariant.destructive,\n'
        '  onPressed: () {},\n'
        "  child: const Text('Delete account'),\n"
        ')',
  );

  Widget _exampleOutline() => _example(
    id: 'example-outline',
    title: 'Outline',
    description:
        'DsButtonVariant.outline — a bordered DsMachineSurface you can '
        'press: theme.card fill, theme.input border, shadow-btn at rest '
        'and shadow-btn-down while pressed. For actions that must not '
        'compete with a primary button.',
    panelTitle: 'Outline',
    preview: KeyedSubtree(
      key: const ValueKey<String>('button-example:outline'),
      child: DsButton(
        variant: DsButtonVariant.outline,
        onPressed: () {},
        child: const Text('Outline'),
      ),
    ),
    path: 'button_outline.dart',
    code:
        'DsButton(\n'
        '  variant: DsButtonVariant.outline,\n'
        '  onPressed: () {},\n'
        "  child: const Text('Outline'),\n"
        ')',
  );

  Widget _exampleGhost() => _example(
    id: 'example-ghost',
    title: 'Ghost',
    description:
        'DsButtonVariant.ghost — no fill, no border, and no elevation '
        'until touched. The one variant that answers hover, pressed, and '
        'an open aria-expanded trigger with three different fills of its '
        'own.',
    panelTitle: 'Ghost',
    preview: KeyedSubtree(
      key: const ValueKey<String>('button-example:ghost'),
      child: DsButton(
        variant: DsButtonVariant.ghost,
        onPressed: () {},
        child: const Text('Ghost'),
      ),
    ),
    path: 'button_ghost.dart',
    code:
        'DsButton(\n'
        '  variant: DsButtonVariant.ghost,\n'
        '  onPressed: () {},\n'
        "  child: const Text('Ghost'),\n"
        ')',
  );

  Widget _exampleLink() => _example(
    id: 'example-link',
    title: 'Link',
    description:
        'DsButtonVariant.link — text-only, theme.actionInk, underlines on '
        'hover. Still a DsButton underneath: the rendered Semantics node '
        'reports button: true, not link — see this page\'s hero paragraph '
        'above for what that means for navigation.',
    panelTitle: 'Link',
    preview: KeyedSubtree(
      key: const ValueKey<String>('button-example:link'),
      child: DsButton(
        variant: DsButtonVariant.link,
        onPressed: () {},
        child: const Text('Link'),
      ),
    ),
    path: 'button_link.dart',
    code:
        'DsButton(\n'
        '  variant: DsButtonVariant.link,\n'
        '  onPressed: () {},\n'
        "  child: const Text('Link'),\n"
        ')',
  );

  Widget _exampleIcon() => _example(
    id: 'example-icon',
    title: 'Icon',
    description:
        'The four square DsButtonSize rungs — iconXs, iconSm, icon, '
        'iconLg. DsButton.isSquare(size) is true, gapFor and paddingXFor '
        'both go to zero, and the button centres a single glyph. label is '
        'required here: with no visible text, it becomes the whole '
        "accessible name (Semantics.excludeSemantics: true).",
    panelTitle: 'Icon-only sizes',
    preview: Wrap(
      spacing: ds(3),
      runSpacing: ds(3),
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        KeyedSubtree(
          key: const ValueKey<String>('button-example:icon-iconXs'),
          child: DsButton(
            variant: DsButtonVariant.outline,
            size: DsButtonSize.iconXs,
            label: 'Add item',
            onPressed: () {},
            child: const DsIcon(DsIconGlyph.plus, size: DsIconSize.xs),
          ),
        ),
        KeyedSubtree(
          key: const ValueKey<String>('button-example:icon-iconSm'),
          child: DsButton(
            variant: DsButtonVariant.outline,
            size: DsButtonSize.iconSm,
            label: 'Search',
            onPressed: () {},
            child: const DsIcon(DsIconGlyph.search, size: DsIconSize.sm),
          ),
        ),
        KeyedSubtree(
          key: const ValueKey<String>('button-example:icon-icon'),
          child: DsButton(
            variant: DsButtonVariant.secondary,
            size: DsButtonSize.icon,
            label: 'Settings',
            onPressed: () {},
            child: const DsIcon(DsIconGlyph.settings, size: DsIconSize.md),
          ),
        ),
        KeyedSubtree(
          key: const ValueKey<String>('button-example:icon-iconLg'),
          child: DsButton(
            variant: DsButtonVariant.destructive,
            size: DsButtonSize.iconLg,
            label: 'Delete',
            onPressed: () {},
            child: const DsIcon(DsIconGlyph.trash2, size: DsIconSize.lg),
          ),
        ),
      ],
    ),
    path: 'button_icon.dart',
    code:
        '// iconXs (24px), iconSm (32px), icon (40px), iconLg (48px) — each\n'
        '// forces its own icon px (DsButton.iconPxFor) and requires a\n'
        '// label, since there is no visible text.\n'
        'DsButton(\n'
        '  variant: DsButtonVariant.outline,\n'
        '  size: DsButtonSize.icon,\n'
        "  label: 'Settings',\n"
        '  onPressed: () {},\n'
        '  child: const DsIcon(DsIconGlyph.settings, size: DsIconSize.md),\n'
        ')',
  );

  Widget _exampleWithIcon() => _example(
    id: 'example-with-icon',
    title: 'With icon',
    description:
        'DsButton takes exactly one child — an icon-and-label composition '
        'is the caller\'s own Row, spaced by DsButton.gapFor(size), the '
        'same gap the loading spinner uses in front of its own label.',
    panelTitle: 'With icon',
    preview: KeyedSubtree(
      key: const ValueKey<String>('button-example:with-icon'),
      child: DsButton(
        onPressed: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const DsIcon(DsIconGlyph.download, size: DsIconSize.sm),
            SizedBox(width: DsButton.gapFor(DsButtonSize.md)),
            const Text('Download'),
          ],
        ),
      ),
    ),
    path: 'button_with_icon.dart',
    code:
        'DsButton(\n'
        '  onPressed: () {},\n'
        '  child: Row(\n'
        '    mainAxisSize: MainAxisSize.min,\n'
        '    children: <Widget>[\n'
        '      const DsIcon(DsIconGlyph.download, size: DsIconSize.sm),\n'
        '      SizedBox(width: DsButton.gapFor(DsButtonSize.md)),\n'
        "      const Text('Download'),\n"
        '    ],\n'
        '  ),\n'
        ')',
  );

  Widget _exampleLoading() => _example(
    id: 'example-loading',
    title: 'Loading',
    description:
        'loading: true prepends a DsSpinner and forces the button '
        'disabled (enabled = onPressed != null && !loading). DOCUMENTED '
        'DRIFT the source itself flags: the spinner\'s width is not '
        'reserved in advance, so the button grows by DsSpinner.px + '
        'gapFor(size) the instant loading starts, rather than holding a '
        'fixed width from the beginning.',
    panelTitle: 'Loading',
    preview: KeyedSubtree(
      key: const ValueKey<String>('button-example:loading'),
      child: DsButton(
        loading: true,
        onPressed: () {},
        child: const Text('Please wait'),
      ),
    ),
    path: 'button_loading.dart',
    code:
        'DsButton(\n'
        '  loading: true,\n'
        '  onPressed: () {},\n'
        "  child: const Text('Please wait'),\n"
        ')',
  );

  Widget _exampleDisabled() => _example(
    id: 'example-disabled',
    title: 'Disabled',
    description:
        'onPressed: null is the only disabled switch DsButton has — there '
        'is no separate enabled flag. Opacity springs to 45% on the same '
        'clock the colour legs use; IgnorePointer kills input in the same '
        'frame, unanimated.',
    panelTitle: 'Disabled',
    preview: KeyedSubtree(
      key: const ValueKey<String>('button-example:disabled'),
      child: DsButton(onPressed: null, child: const Text('Disabled')),
    ),
    path: 'button_disabled.dart',
    code: "DsButton(\n  onPressed: null,\n  child: const Text('Disabled'),\n)",
  );

  Widget _exampleSizes() => _example(
    id: 'example-sizes',
    title: 'Sizes',
    description:
        'The five text rungs — xs (24px) through xl (56px). Each changes '
        'height, horizontal padding, and the icon-child gap; three of the '
        'five steps also change the type spec: xs is unique, sm and md '
        'share 13px, lg and xl share 15px.',
    panelTitle: 'Text sizes',
    preview: Wrap(
      spacing: ds(3),
      runSpacing: ds(3),
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        KeyedSubtree(
          key: const ValueKey<String>('button-example:sizes-xs'),
          child: DsButton(
            size: DsButtonSize.xs,
            onPressed: () {},
            child: const Text('Extra small'),
          ),
        ),
        KeyedSubtree(
          key: const ValueKey<String>('button-example:sizes-sm'),
          child: DsButton(
            size: DsButtonSize.sm,
            onPressed: () {},
            child: const Text('Small'),
          ),
        ),
        KeyedSubtree(
          key: const ValueKey<String>('button-example:sizes-md'),
          child: DsButton(onPressed: () {}, child: const Text('Medium')),
        ),
        KeyedSubtree(
          key: const ValueKey<String>('button-example:sizes-lg'),
          child: DsButton(
            size: DsButtonSize.lg,
            onPressed: () {},
            child: const Text('Large'),
          ),
        ),
        KeyedSubtree(
          key: const ValueKey<String>('button-example:sizes-xl'),
          child: DsButton(
            size: DsButtonSize.xl,
            onPressed: () {},
            child: const Text('Extra large'),
          ),
        ),
      ],
    ),
    path: 'button_sizes.dart',
    code:
        'DsButton(size: DsButtonSize.xs, onPressed: () {}, child: const Text(\'Extra small\'))\n'
        'DsButton(size: DsButtonSize.sm, onPressed: () {}, child: const Text(\'Small\'))\n'
        'DsButton(onPressed: () {}, child: const Text(\'Medium\')) // size defaults to md\n'
        'DsButton(size: DsButtonSize.lg, onPressed: () {}, child: const Text(\'Large\'))\n'
        'DsButton(size: DsButtonSize.xl, onPressed: () {}, child: const Text(\'Extra large\'))',
  );

  Widget _exampleEmphasis() => _example(
    id: 'example-emphasis',
    title: 'Emphasis (caps)',
    description:
        'DsButtonEmphasis.caps — the third cva axis, independent of '
        'variant and size. Uppercases the visible label (a screen reader '
        'still hears the original casing, via semanticsLabel) and '
        'switches to font-weight 600, matching the reference\'s pack and '
        'money CTA treatment.',
    panelTitle: 'Emphasis: caps',
    preview: KeyedSubtree(
      key: const ValueKey<String>('button-example:emphasis'),
      child: DsButton(
        variant: DsButtonVariant.premium,
        emphasis: DsButtonEmphasis.caps,
        onPressed: () {},
        child: const Text('Claim reward'),
      ),
    ),
    path: 'button_emphasis.dart',
    code:
        'DsButton(\n'
        '  variant: DsButtonVariant.premium,\n'
        '  emphasis: DsButtonEmphasis.caps,\n'
        '  onPressed: () {},\n'
        "  child: const Text('Claim reward'),\n"
        ')',
  );

  Widget _api() => DsSection(
    id: 'api',
    title: 'API Reference',
    description:
        'Every constructor parameter DsButton declares, every DsButtonVariant '
        'and DsButtonSize and DsButtonEmphasis value, and DsButtonSurface\'s '
        'own six override fields — one table per exported class or enum, '
        'plus a bonus table for the static helpers callers actually reach '
        'for.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsApiTable(title: 'DsButton', facts: _buttonApiFacts),
        SizedBox(height: ds(6)),
        const DocsApiTable(
          title: 'DsButton static helpers',
          facts: _buttonStaticFacts,
        ),
        SizedBox(height: ds(6)),
        const DocsApiTable(title: 'DsButtonVariant', facts: _variantFacts),
        SizedBox(height: ds(6)),
        const DocsApiTable(title: 'DsButtonSize', facts: _sizeFacts),
        SizedBox(height: ds(6)),
        const DocsApiTable(title: 'DsButtonEmphasis', facts: _emphasisFacts),
        SizedBox(height: ds(6)),
        const DocsApiTable(title: 'DsButtonSurface', facts: _surfaceFacts),
      ],
    ),
  );

  Widget _states() => DsSection(
    id: 'states',
    title: 'States',
    description:
        'Read straight off _DsButtonState._skin and _DsButtonState.build, '
        'not inferred — every duration cited is the real token the source '
        'names.',
    child: const DocsStateMatrix(facts: _stateFacts),
  );

  Widget _accessibility(DsThemeData theme) => DsSection(
    id: 'accessibility',
    title: 'Accessibility and keyboard behavior',
    child: _bullets(theme, <String>[
      'Semantic role: Semantics(button: true) on the rendered node, on '
          'every variant without exception — including link, which is '
          'still a button underneath its anchor-like paint.',
      'Accessible name: label, when given, REPLACES the content\'s name '
          '(excludeSemantics: true) rather than joining it — required for '
          'an icon-only button. Omitted, the visible child (usually a '
          'Text) supplies the name instead.',
      'Keyboard interactions: Enter, NumpadEnter, and Space activate a '
          'focused, enabled button. Flutter gives a bare pointer widget '
          'none of that for free — Focus.onKeyEvent wires it by hand.',
      'Focus behavior: :focus-visible, not :focus. Flutter does not move '
          'focus on a bare pointer tap, only on keyboard traversal or an '
          'explicit request, so hasFocus here already is the '
          'keyboard-only signal CSS means.',
      'Focus ring: springs open 0 -> 3px spread on the same clock as '
          'everything else, at theme.ring 50% alpha — theme.destructive '
          '25% alpha (and a different border colour) on the destructive '
          'variant only.',
      'Touch target: not uniformly 44px. heightFor ranges from 24px '
          '(xs / iconXs) to 56px (xl), and the four icon squares are that '
          'size wide as well as tall — DsButtonSize.iconXs is a 24x24 '
          'target. DsButton enforces no floor; a caller reaching for a '
          'dense icon button owns that trade-off.',
      'Known gap — expanded is visual only: _DsButtonState.build\'s '
          'Semantics node sets button / enabled / label / excludeSemantics '
          'and nothing else. DsButton.expanded changes which fill paints '
          'but is never surfaced as Semantics.expanded — an open trigger '
          'looks lit but is not announced as expanded.',
      'Loading and aria-busy: loading forces enabled: false, the same '
          'branch an ordinary disabled button takes — the one half of the '
          'reference\'s aria-busy behaviour Flutter can reproduce. '
          'SemanticsProperties in the pinned SDK (3.44.8) declares no busy '
          'flag at all, so assistive tech learns the control is not '
          'actionable but not why. Documented drift, not an oversight — '
          'the source docstring says so directly.',
      'suppressPressScale is visual only too: it cancels the 0.95 press '
          'scale for a trigger button (aria-haspopup\'s equivalent) but '
          'carries no semantic signal — nothing tells a screen reader this '
          'control opens something.',
    ]),
  );

  Widget _responsive(DsThemeData theme) => DsSection(
    id: 'responsive',
    title: 'Responsive and platform behavior',
    child: _bullets(theme, <String>[
      'No breakpoint branching anywhere in button.dart — BuildContext '
          'width is never read for a layout decision; the same widget '
          'tree renders at 390px and 1440px.',
      'Every measurement (heightFor, gapFor, paddingXFor, iconPxFor) is a '
          'fixed 4px-grid value (ds()) keyed only to DsButtonSize, never '
          'to viewport.',
      'The one place a button\'s own width follows its surroundings is '
          'expanded: true (with contentAlignment) — w-full justify-start '
          'instead of the default hug-content pill. Nothing in this file '
          'reads a breakpoint to decide when to pass it; that decision '
          'lives entirely at the call site.',
      'autoHeight drops the rung\'s fixed height (h-auto) and lets content '
          'set it instead — what the sidebar\'s own row sizes use in '
          'place of the 24/32/40/48/56 ladder above.',
      'Long labels are not truncated or wrapped specially — a Text child '
          'overflows however Text normally would; DsButton adds no '
          'ellipsis or maxLines of its own.',
      'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all '
          'render the same widget tree — no dart:io Platform branch '
          'anywhere in the file.',
    ]),
  );

  Widget _dependencies(DsThemeData theme) => DsSection(
    id: 'dependencies',
    title: 'Dependencies, files, and install facts',
    child: _bullets(theme, <String>[
      'File: lib/src/components/button.dart — one file, no companions; '
          'the registry manifest lists exactly one entry under "files".',
      'Flutter imports: package:flutter/foundation.dart (clampDouble), '
          'package:flutter/services.dart (LogicalKeyboardKey, KeyEvent), '
          'package:flutter/widgets.dart.',
      'Foundation imports: foundation/colors.dart, foundation/motion.dart, '
          'foundation/shadows.dart, foundation/spacing.dart (ds()), '
          'foundation/theme.dart, foundation/typography.dart, '
          'theme_scope.dart (DsText, DsTheme, dsAnimationDuration).',
      'Effect imports: effects/sheen_action.dart (DsSheenAction — '
          'primary), effects/foil_value.dart (DsFoilValue — premium), '
          'effects/machine_surface.dart (DsMachineSurface — secondary, '
          'outline, ghost, destructive, link).',
      'Component import: spinner.dart (DsSpinner — loading only).',
      'registryDependencies, resolved automatically by `elattar add '
          'button`: source-foundation, press-motion, icon, spinner, '
          'foil-value, machine-surface, sheen-action — copied verbatim '
          'from registry/components/button.json.',
      'semanticDependencies (the manifest\'s own, narrower field): '
          'press-motion, icon — a hint at what a button is commonly '
          'composed WITH, not a second import list; button.dart does not '
          'import icon.dart itself.',
    ]),
  );

  Widget _theming(DsThemeData theme) => DsSection(
    id: 'theming',
    title: 'Theming notes',
    child: _bullets(theme, <String>[
      'Every colour is read live off DsTheme.of(context) at build time — '
          'theme.primary/primaryForeground (primary), theme.secondary/'
          'secondaryForeground/accent (secondary), theme.card/muted/'
          'input/foreground (outline), theme.mutedForeground/secondary/'
          'foreground (ghost), theme.destructive/destructiveInk '
          '(destructive), theme.actionInk (link), and theme.ring (the '
          'focus ring on every variant but destructive, which rings at '
          'theme.destructive instead). Flipping DsThemeController '
          're-resolves every one on the next frame — nothing is cached.',
      'premium partially opts out: DsPalette.value and '
          'DsPalette.valueForeground are fixed tokens rather than theme.* '
          'getters, and the source says why — "the one foreground in the '
          'system that deliberately does NOT flip with the theme" — the '
          'metal foil reads as the same lime-on-dark-text in both themes.',
      'Shape: the pill (BorderRadius.circular(DsRadii.pill)) is a default '
          'a caller can override with radius — the sidebar\'s own row '
          'buttons are the one real caller that does, dropping to '
          'rounded-lg / rounded-md because "a 240px pill is a lozenge."',
      'Elevation is always a DsShadowSpec token per variant and state — '
          'DsShadows.btnPrimary / btnDown / btnValue / glowValue / btn / '
          'none — never a bespoke shadow at a call site. secondary and '
          'destructive both carry DsShadows.none, which the shadows '
          'page\'s own copy contradicts (documented drift in button.dart\'s '
          'own class doc).',
      'surface (DsButtonSurface) is the one escape hatch for a call site '
          'that must restyle fill / border / ink without forking a new '
          'variant — six optional Color? fields layered on top of the '
          'variant\'s own resolved skin, hover-aware. Used by exactly one '
          'real call site in the corpus (MessageScrollerButton) as of '
          'this port.',
    ]),
  );

  Widget _source() => DsSection(
    id: 'source',
    title: 'Source, tests, and docs',
    child: DocsInstallFacts(
      title: 'Reference',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Source',
          value: buttonDoc.sourcePath,
          description:
              'Authoritative implementation — the truth this page was '
              'written from.',
        ),
        const DocsInstallFact(
          label: 'Package tests',
          value: 'test/components_test.dart',
          description:
              'DsButton is covered inside the shared base-components '
              'suite (294 DsButton references at the time this page was '
              'written) — there is no dedicated button_test.dart in the '
              'package yet.',
        ),
        const DocsInstallFact(
          label: 'Docs test',
          value: 'example/test/components_docs/button_test.dart',
          description:
              'Covers this page: the article mounts, every DsButtonVariant '
              'and DsButtonSize the Examples section claims to show, the '
              'full API table, and both themes at two viewport widths.',
        ),
        const DocsInstallFact(
          label: 'Edit these docs',
          value: 'example/lib/components_docs/button/page.dart',
          description: 'This file.',
        ),
      ],
    ),
  );
}

/// One Examples subsection: its own [DsSection] (own anchor, own heading)
/// wrapping its own [DocsCodeExample] (own Preview/Manual pair, own copy
/// control).
Widget _example({
  required String id,
  required String title,
  required String description,
  required String panelTitle,
  required Widget preview,
  required String path,
  required String code,
}) => DsSection(
  id: id,
  title: title,
  description: description,
  child: DocsCodeExample(
    title: panelTitle,
    preview: Center(child: preview),
    manualFiles: <DocsCodeFile>[
      DocsCodeFile(path: path, title: title, code: code),
    ],
  ),
);

Widget _bullets(DsThemeData theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: DsWidths.prose),
        child: DsText('•  $line', DsType.small, color: theme.mutedForeground),
      ),
      SizedBox(height: ds(2)),
    ],
  ],
);

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

DsButton(
  onPressed: () {},
  child: const Text('Button'),
)''';

const List<DocsApiFact> _buttonApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        "Required. The button's content — an icon, a label, or a "
        'caller-built row of both spaced by DsButton.gapFor.',
  ),
  DocsApiFact(
    name: 'variant',
    type: 'DsButtonVariant',
    description:
        'Optional. Defaults to DsButtonVariant.primary. Selects fill, '
        'border, ink, and shadow — see the DsButtonVariant table below.',
  ),
  DocsApiFact(
    name: 'size',
    type: 'DsButtonSize',
    description:
        'Optional. Defaults to DsButtonSize.md. Selects height, '
        'horizontal padding, icon gap, and forced icon-child px — see the '
        'DsButtonSize table below.',
  ),
  DocsApiFact(
    name: 'emphasis',
    type: 'DsButtonEmphasis',
    description:
        'Optional. Defaults to DsButtonEmphasis.none. caps uppercases '
        "the visible label and switches to font-weight 600, beating "
        "whatever text style the size rung declared.",
  ),
  DocsApiFact(
    name: 'loading',
    type: 'bool',
    description:
        'Optional. Defaults to false. Prepends a DsSpinner, and — ORed '
        'with a null onPressed — disables the button: 45% opacity, no '
        'pointer events, no focus.',
  ),
  DocsApiFact(
    name: 'onPressed',
    type: 'VoidCallback?',
    description:
        'Optional. Defaults to null, which disables the button on its '
        'own. The callback the button invokes on tap, Enter, or Space.',
  ),
  DocsApiFact(
    name: 'label',
    type: 'String?',
    description:
        "Optional. Defaults to null. The accessible name. When given, it "
        "REPLACES the content's name (Semantics.excludeSemantics: true) "
        'rather than joining it — required for an icon-only button.',
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode?',
    description:
        'Optional. Defaults to null, which lets the button own its own '
        'node. Supply one to drive :focus-visible from outside.',
  ),
  DocsApiFact(
    name: 'padding',
    type: 'EdgeInsets?',
    description:
        'Optional. Defaults to null, which leaves '
        "DsButton.paddingXFor(size) in charge. Replaces the rung's "
        "horizontal padding — Pagination's Previous/Next buttons are the "
        'one real caller that overrides it.',
  ),
  DocsApiFact(
    name: 'surface',
    type: 'DsButtonSurface?',
    description:
        'Optional. Defaults to null. Fill/border/ink overrides layered '
        'on top of the resolved variant skin — see the DsButtonSurface '
        'table below.',
  ),
  DocsApiFact(
    name: 'expanded',
    type: 'bool',
    description:
        "Optional. Defaults to false. Holds the variant's own hover fill "
        'open — the aria-expanded equivalent for a trigger whose popup '
        'is open. Paints on secondary, outline, and ghost only.',
  ),
  DocsApiFact(
    name: 'suppressPressScale',
    type: 'bool',
    description:
        'Optional. Defaults to false. Cancels the 0.95 press-scale for a '
        'button that opens something (a menu, a popover) — the '
        'aria-haspopup equivalent. The shadow and colour legs still fire.',
  ),
  DocsApiFact(
    name: 'radius',
    type: 'BorderRadius?',
    description:
        'Optional. Defaults to null, which keeps the pill '
        '(BorderRadius.circular(DsRadii.pill)). The sidebar\'s own row '
        'buttons are the one real caller that overrides it.',
  ),
  DocsApiFact(
    name: 'autoHeight',
    type: 'bool',
    description:
        "Optional. Defaults to false. Drops the rung's fixed height and "
        'lets the content set it instead — h-auto. Every other '
        'measurement the rung declares still applies.',
  ),
  DocsApiFact(
    name: 'contentAlignment',
    type: 'AlignmentGeometry?',
    description:
        'Optional. Defaults to null, which centres content on a '
        'hug-content pill. Non-null fills the incoming width at that '
        'alignment — w-full justify-start.',
  ),
];

const List<DocsApiFact> _buttonStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'DsButton.heightFor(size)',
    type: 'static double',
    description:
        "The rung's fixed height — 24 / 32 / 40 / 48 / 56 for the five "
        'text rungs, matching square for the four icon rungs.',
  ),
  DocsApiFact(
    name: 'DsButton.gapFor(size)',
    type: 'static double',
    description:
        "The gap between an icon and its label at this rung — 0 on "
        'every icon-only square. Exposed, not applied: a two-child '
        'button composes its own Row and asks here for the spacing.',
  ),
  DocsApiFact(
    name: 'DsButton.paddingXFor(size)',
    type: 'static double',
    description:
        "The rung's horizontal padding — 0 on every icon-only square, "
        'which centres the glyph instead.',
  ),
  DocsApiFact(
    name: 'DsButton.iconPxFor(size)',
    type: 'static double',
    description:
        "The px an icon child should render at for this rung — the "
        'caller\'s job to pass to DsIcon(size:) or sizePx:, since a '
        'Flutter parent cannot resize its child the way a CSS descendant '
        'selector can.',
  ),
  DocsApiFact(
    name: 'DsButton.typeFor(size, emphasis)',
    type: 'static DsTypeSpec?',
    description:
        'The resolved text spec, or null on the four icon-only rungs, '
        'which set no font-size of their own and inherit the ambient '
        'DefaultTextStyle instead.',
  ),
  DocsApiFact(
    name: 'DsButton.isSquare(size)',
    type: 'static bool',
    description: 'True for iconXs, iconSm, icon, and iconLg.',
  ),
  DocsApiFact(
    name: 'DsButton.withFocusRing(spec, ring, {progress})',
    type: 'static DsShadowSpec',
    description:
        'Composites a focus-visible ring in front of a shadow spec — '
        'the shared helper this widget and DsInput both reach for.',
  ),
];

const List<DocsApiFact> _variantFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'primary',
    type: 'enum value',
    description:
        "The constructor default. DsSheenAction over theme.primary; "
        'shadow-btn-primary at rest, shadow-btn-down while pressed.',
  ),
  DocsApiFact(
    name: 'premium',
    type: 'enum value',
    description:
        'DsFoilValue over DsPalette.value; DsPalette.valueForeground '
        'text, which does not flip with the theme. shadow-btn-value at '
        'rest, a glow on hover — the only variant with a hover glow.',
  ),
  DocsApiFact(
    name: 'secondary',
    type: 'enum value',
    description:
        'theme.secondary, moving to theme.accent on hover or an open '
        'trigger. No shadow at all (DsShadows.none).',
  ),
  DocsApiFact(
    name: 'outline',
    type: 'enum value',
    description:
        'theme.card fill, theme.input border, theme.foreground text. '
        'shadow-btn at rest, shadow-btn-down while pressed.',
  ),
  DocsApiFact(
    name: 'ghost',
    type: 'enum value',
    description:
        'Transparent at rest; theme.secondary on hover, theme.muted '
        'while pressed. No shadow.',
  ),
  DocsApiFact(
    name: 'destructive',
    type: 'enum value',
    description:
        'A 10% tint of theme.destructive (20% on hover) rather than a '
        'solid fill — measured to clear AA where a solid fill would not. '
        'No shadow.',
  ),
  DocsApiFact(
    name: 'link',
    type: 'enum value',
    description:
        'Transparent, theme.actionInk text, underlines on hover. Still '
        'reports Semantics(button: true) — see this page\'s hero copy.',
  ),
];

const List<DocsApiFact> _sizeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'xs',
    type: '24px · text',
    description:
        'Dense internal use only — chips inside a combobox or an '
        'attachment row.',
  ),
  DocsApiFact(
    name: 'sm',
    type: '32px · text',
    description: 'Shares its 13px type with md.',
  ),
  DocsApiFact(
    name: 'md',
    type: '40px · text',
    description: 'The default rung.',
  ),
  DocsApiFact(
    name: 'lg',
    type: '48px · text',
    description: 'Shares its 15px type with xl.',
  ),
  DocsApiFact(
    name: 'xl',
    type: '56px · text',
    description: 'Hero CTA only — a landing page or a pack-opening moment.',
  ),
  DocsApiFact(
    name: 'iconXs',
    type: '24px · square',
    description: 'Forces a 12px icon child.',
  ),
  DocsApiFact(
    name: 'iconSm',
    type: '32px · square',
    description: 'Forces a 14px icon child.',
  ),
  DocsApiFact(
    name: 'icon',
    type: '40px · square',
    description: 'Forces a 16px icon child — the default square.',
  ),
  DocsApiFact(
    name: 'iconLg',
    type: '48px · square',
    description: 'Forces a 20px icon child.',
  ),
];

const List<DocsApiFact> _emphasisFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'none',
    type: 'enum value',
    description: "The default. No override on the rung's own type spec.",
  ),
  DocsApiFact(
    name: 'caps',
    type: 'enum value',
    description:
        'Uppercases the visible label (semanticsLabel keeps the '
        "original casing for a screen reader) and sets font-weight 600, "
        "beating every rung's own text style — including the four icon "
        'squares.',
  ),
];

const List<DocsApiFact> _surfaceFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'fill',
    type: 'Color?',
    description: 'Overrides the resolved fill at rest.',
  ),
  DocsApiFact(
    name: 'hoverFill',
    type: 'Color?',
    description:
        'Overrides the fill on hover. Falls back to fill when null, the '
        'same fallback a CSS class list gives.',
  ),
  DocsApiFact(
    name: 'border',
    type: 'Color?',
    description: 'Overrides the resolved border at rest.',
  ),
  DocsApiFact(
    name: 'hoverBorder',
    type: 'Color?',
    description:
        'Overrides the border on hover. Falls back to border when null.',
  ),
  DocsApiFact(
    name: 'ink',
    type: 'Color?',
    description: 'Overrides the resolved text/icon colour at rest.',
  ),
  DocsApiFact(
    name: 'hoverInk',
    type: 'Color?',
    description:
        'Overrides the text/icon colour on hover. Falls back to ink '
        'when null.',
  ),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        "Each variant's own resolved fill/border/ink/shadow — see the "
        'DsButtonVariant table above.',
    userSignal: "The button's baseline paint.",
  ),
  DocsStateFact(
    state: 'Hover',
    treatment:
        'Pointer-only (MouseRegion). Most variants shift fill or ink; '
        'link adds an underline. Colour legs spring over 250ms on '
        '--ease-spring, overshooting past the target.',
    userSignal: 'A lit surface under the pointer.',
  ),
  DocsStateFact(
    state: 'Pressed',
    treatment:
        'Transform.scale to 0.95 — NOT animated; the exact frame the '
        'pointer goes down is the exact frame the scale changes, and the '
        'same going back up. Shadow hard-cuts to shadow-btn-down '
        '(mismatched layer counts block interpolation).',
    userSignal:
        'An instant physical dip into the socket, no spring on the '
        'scale itself.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        'Keyboard-only: Flutter does not focus on a bare pointer tap, so '
        'hasFocus here already is the :focus-visible predicate. The ring '
        'springs 0 -> 3px spread over the same colour clock, at '
        'theme.ring 50% alpha (theme.destructive 25% on the destructive '
        'variant, which also swaps the border colour).',
    userSignal:
        'A ring that opens around the button, never around a '
        'mouse-focused one.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'onPressed: null. Opacity springs to 45% over the same clock; '
        'IgnorePointer kills input in the same frame, unanimated.',
    userSignal: 'Faded and inert, with no perceptible click.',
  ),
  DocsStateFact(
    state: 'Loading',
    treatment:
        'loading: true prepends a DsSpinner and forces the same disabled '
        'branch as above, regardless of onPressed. DOCUMENTED DRIFT: the '
        'spinner is not pre-reserved, so the button grows by '
        'DsSpinner.px + gapFor(size) the instant loading starts.',
    userSignal:
        'A spinner appears in front of the label; the control stops '
        'responding.',
  ),
  DocsStateFact(
    state: 'Expanded (aria-expanded)',
    treatment:
        'Holds the hover fill open on secondary, outline, and ghost '
        'only — the other four variants declare no such class. Not '
        'surfaced through Semantics (see Accessibility).',
    userSignal: 'The trigger stays lit while what it opened is still open.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'Every TweenAnimationBuilder duration routes through '
        'dsAnimationDuration, which is Duration.zero under '
        'MediaQuery.disableAnimations. The press scale was never '
        'animated to begin with.',
    userSignal:
        'Colour, ring, and opacity all hard-cut instead of springing; '
        'nothing about the press changes.',
  ),
];
