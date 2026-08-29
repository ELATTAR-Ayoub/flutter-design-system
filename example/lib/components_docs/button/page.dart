/// Public documentation page for the `button` component.
///
/// **Reference shape, reshaped again.** Phase J asked this page to mirror
/// https://ui.shadcn.com/docs/components/base/button's own literal section
/// list, not shadcn's variant names read as if they were enum values.
/// Fetched fresh, that page's `<h2>`s are, in order: Installation, Usage,
/// Cursor, Size, Default, Outline, Secondary, Ghost, Destructive, Link,
/// Icon, With Icon, Rounded, Spinner, Button Group, As Link, RTL, API
/// Reference (one nested `<h3>`, Button, its own prop table). Every one of
/// those but three is a TOP-LEVEL section on their page, a sibling of
/// Installation, never a child of some "Examples" wrapper, so this page
/// carries no Examples wrapper either: the thirteen former `example-*`
/// subsections are promoted to the same level as Installation, matching
/// shadcn's own flat shape. The live all-variants specimen mounts above
/// Installation too, now the page's own `Preview` section rather than a
/// bare, TOC-less `DocsCodeExample`: see **TOC** below.
///
/// **Skipped, honestly.** Three of shadcn's eighteen sections describe a
/// capability this Flutter port does not have, and rather than fake one,
/// each is left off the page and named here instead:
/// * Cursor: shadcn's section is a Tailwind v4 CSS snippet (or a
///   `shadcn init --pointer` flag) that opts a whole PROJECT back into
///   `cursor: pointer`. There is no CSS layer and no per-project toggle in
///   this port: `_DsButtonState.build`'s `MouseRegion` hardcodes
///   `SystemMouseCursors.click` whenever the button is enabled, on every
///   variant, unconditionally. Nothing here is a switch a caller can flip.
/// * As Link: shadcn's section uses `buttonVariants()`, a pure style
///   function, to paint a real `<a>` like a Button without the polymorphic
///   Button-as-anchor render prop. `button.dart` exposes no such
///   style-only function: `_skin`/`_ButtonSkin`/`_surface` are private to
///   `_DsButtonState.build`, and this system has no anchor widget to paint
///   them onto.
/// * RTL: no `Directionality`/`TextDirection` branch anywhere in
///   `button.dart`, and the docs shell this page renders inside carries no
///   locale or direction toggle to demonstrate one against.
///
/// **Added, in their style.** `Button` carries three things shadcn's
/// Button does not: a `premium` variant, a third `emphasis` axis, and, via
/// the sibling `ButtonGroup` file, a segmented-control composition. Each
/// gets a section named for what it does, not for its enum value, inserted
/// next to the shadcn section it is closest kin to: Premium beside Default
/// (both solid fills), Emphasis and Disabled beside Spinner (all three are
/// modifiers layered on top of a variant), and Button Group where shadcn's
/// own equivalent section sits, last before API Reference.
///
/// **TOC.** Flat, with no exception now. This page is declared as a
/// `ComponentDocSpec` (`example/lib/docs/component_doc_page.dart`), whose
/// `toc` getter derives exactly one rail entry per declared section, in
/// declaration order: a section cannot exist without a link, and a link
/// cannot point at nothing. Two differences from the section list this
/// library doc described before: the hero all-variants specimen is now a
/// real `ShowcaseSection`, `Preview`, so it finally owns a rail entry; and
/// API Reference's six prop tables no longer get their own nested anchors —
/// `DocsPageSection` is sealed into four cases with no fifth, so all six
/// move inside the single API Reference `DisclosureSection`, keeping their
/// own `title:` labels but losing the standalone `api-elbutton`,
/// `api-elbutton-static`, `api-elbutton-variant`, `api-elbutton-size`,
/// `api-elbutton-emphasis`, and `api-elbutton-surface` rail links. One
/// section this page lacked before is added here: Keyboard, between
/// Accessibility and Responsive.
///
/// [ComponentDocEntry.description] is the page's only rendered description:
/// the short, one-sentence form (nav/search, and this page's own hero
/// paragraph). No second, longer paragraph renders beneath it; Installation
/// is the first section after the hero.
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
import 'meta.dart';

/// The declaration: every section this page shows, in TOC order. `final`,
/// not `const`: `InstallSection.command` reads `buttonDoc.command`, a
/// computed getter (`'elattar add ${name.replaceAll('_', '-')}'`), which is
/// not a constant expression. Every specimen is still its own small widget
/// class with a `const` constructor, so nothing here is rebuilt from
/// scratch on every page rebuild the way an inline closure would be.
final ComponentDocSpec buttonDocSpec = ComponentDocSpec(
  name: 'button',
  title: 'Button',
  description:
      'A pill-shaped control with seven variants, nine sizes, loading and '
      'disabled states, and a springing focus ring: for triggering an '
      'action, never for navigating to one.',
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'All seven ButtonVariant values, side by side. '
          'Every size and state gets its own live specimen '
          'further down the page.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'button has a real registry manifest, `elattar add button` '
          'installs lib/src/components/ui/button.dart and resolves all seven '
          'registryDependencies automatically. The Manual tab is for a '
          'project not using the CLI.',
      command: buttonDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/button.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/button.dart's generated "
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
              'Add the export line so Button and its four enums/'
              'classes are reachable the same way the CLI path already '
              'makes them.',
          code: "export 'button.dart';",
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
      id: 'size',
      title: 'Size',
      description:
          "shadcn's own Size demo shows four rungs: Extra Small, Small, "
          'Default, Large. ButtonSize ships five text rungs instead, xs '
          'through xl. Each changes height, horizontal padding, and the '
          'icon-child gap, and three of the five steps also change the type '
          'spec: xs is unique, sm and md share 13px, lg and xl share 15px. '
          'The four icon-only squares get their own section, in Icon below.',
      specimen: _SizeSpecimen(),
      code: _sizeCode,
      label: 'Size specimen view',
    ),
    ShowcaseSection(
      id: 'default',
      title: 'Default',
      description:
          "ButtonVariant.primary: the constructor's own default. Painted "
          'through ActionFeedback over theme.primary; shadow-btn-primary at '
          'rest, shadow-btn-down while pressed.',
      specimen: _DefaultSpecimen(),
      code: _defaultCode,
      label: 'Default specimen view',
    ),
    ShowcaseSection(
      id: 'premium',
      title: 'Premium',
      description:
          'Not in shadcn\'s own set: ButtonVariant.premium is one this '
          'system adds, the one glowing variant. Painted through PremiumSurface '
          '(a metal-ramp gradient, not a flat fill), with '
          'Palette.valueForeground text that deliberately does not flip '
          'between themes. Reserve it for reward and money actions.',
      specimen: _PremiumSpecimen(),
      code: _premiumCode,
      label: 'Premium specimen view',
    ),
    ShowcaseSection(
      id: 'outline',
      title: 'Outline',
      description:
          'ButtonVariant.outline: a bordered Surface you can '
          'press: theme.card fill, theme.input border, shadow-btn at rest '
          'and shadow-btn-down while pressed. For actions that must not '
          'compete with a primary button.',
      specimen: _OutlineSpecimen(),
      code: _outlineCode,
      label: 'Outline specimen view',
    ),
    ShowcaseSection(
      id: 'secondary',
      title: 'Secondary',
      description:
          'ButtonVariant.secondary: a neutral action beside a primary '
          'one. Carries no shadow class at all; hover and an open '
          'aria-expanded trigger both resolve to the same accent fill.',
      specimen: _SecondarySpecimen(),
      code: _secondaryCode,
      label: 'Secondary specimen view',
    ),
    ShowcaseSection(
      id: 'ghost',
      title: 'Ghost',
      description:
          'ButtonVariant.ghost: no fill, no border, and no elevation '
          'until touched. The one variant that answers hover, pressed, and '
          'an open aria-expanded trigger with three different fills of its '
          'own.',
      specimen: _GhostSpecimen(),
      code: _ghostCode,
      label: 'Ghost specimen view',
    ),
    ShowcaseSection(
      id: 'destructive',
      title: 'Destructive',
      description:
          'ButtonVariant.destructive: a 10% tint of theme.destructive '
          'rather than a solid fill: a solid fill measures under AA against '
          'white text, the tint clears it and still reads unmistakably as '
          'danger. Reach for it for an irreversible or dangerous action.',
      specimen: _DestructiveSpecimen(),
      code: _destructiveCode,
      label: 'Destructive specimen view',
    ),
    ShowcaseSection(
      id: 'link',
      title: 'Link',
      description:
          'ButtonVariant.link: text-only, theme.actionText, underlines on '
          'hover. Still a Button underneath: the rendered Semantics node '
          'reports button: true, not link, and the control carries no href '
          'or route: reach for a real navigation primitive instead whenever '
          'the tap should change the visible page.',
      specimen: _LinkSpecimen(),
      code: _linkCode,
      label: 'Link specimen view',
    ),
    ShowcaseSection(
      id: 'icon',
      title: 'Icon',
      description:
          'The four square ButtonSize rungs: iconXs, iconSm, icon, '
          'iconLg. Button.isSquare(size) is true, gapFor and paddingXFor '
          'both go to zero, and the button centres a single glyph. label is '
          'required here: with no visible text, it becomes the whole '
          "accessible name (Semantics.excludeSemantics: true).",
      specimen: _IconSpecimen(),
      code: _iconCode,
      label: 'Icon specimen view',
    ),
    ShowcaseSection(
      id: 'with-icon',
      title: 'With Icon',
      description:
          'Button takes exactly one child: an icon-and-label composition '
          'is the caller\'s own Row, spaced by Button.gapFor(size), the '
          'same gap the loading spinner uses in front of its own label.',
      specimen: _WithIconSpecimen(),
      code: _withIconCode,
      label: 'With Icon specimen view',
    ),
    ShowcaseSection(
      id: 'rounded',
      title: 'Rounded',
      description:
          "shadcn's own Rounded demo adds rounded-full to round off its "
          'default rounded-md button. Button starts there already: '
          'BorderRadius.circular(Radii.full) is the base list\'s own '
          'shape, on every variant, so there is nothing left to round '
          'further. The real override axis runs the other way: radius '
          'lets a caller pull IN from the pill. The sidebar is the one '
          'place in the corpus that does it, SidebarMenuButton and '
          'SidebarMenuSubButton both dropping to Radii.lg, '
          'SidebarMenuAction dropping further to Radii.md, both shown '
          'below, "a 240px pill is a lozenge."',
      specimen: _RoundedSpecimen(),
      code: _roundedCode,
      label: 'Rounded specimen view',
    ),
    ShowcaseSection(
      id: 'spinner',
      title: 'Spinner',
      description:
          'shadcn composes a <Spinner /> child by hand and tags it '
          'data-icon for spacing. Button takes a single loading: true '
          'flag instead, which prepends a Spinner and forces the button '
          'disabled (enabled = onPressed != null && !loading). DOCUMENTED '
          'DRIFT the source itself flags: the spinner\'s width is not '
          'reserved in advance, so the button grows by Spinner.px + '
          'gapFor(size) the instant loading starts, rather than holding a '
          'fixed width from the beginning.',
      specimen: _SpinnerSpecimen(),
      code: _spinnerCode,
      label: 'Spinner specimen view',
    ),
    ShowcaseSection(
      id: 'disabled',
      title: 'Disabled',
      description:
          'onPressed: null is the only disabled switch Button has: there '
          'is no separate enabled flag. Opacity springs to 45% on the same '
          'clock the colour legs use; IgnorePointer kills input in the same '
          'frame, unanimated.',
      specimen: _DisabledSpecimen(),
      code: _disabledCode,
      label: 'Disabled specimen view',
    ),
    ShowcaseSection(
      id: 'emphasis',
      title: 'Emphasis',
      description:
          'ButtonEmphasis.caps: the third cva axis, independent of '
          'variant and size, and shadcn has no equivalent. Uppercases the '
          'visible label (a screen reader still hears the original casing, '
          'via semanticsLabel) and switches to font-weight 600, matching '
          'the reference\'s pack and money CTA treatment.',
      specimen: _EmphasisSpecimen(),
      code: _emphasisCode,
      label: 'Emphasis specimen view',
    ),
    ShowcaseSection(
      id: 'button-group',
      title: 'Button Group',
      description:
          "shadcn's Button Group section points at a separate ButtonGroup "
          'component and shows Archive, Report, and Snooze composed inside '
          'it. This system keeps the same split: ButtonGroup '
          '(lib/src/components/ui/button_group.dart) is its own file, not '
          'part of button.dart, and reshapes a row of Button members into '
          'one segmented control, squaring interior corners and dropping '
          'interior borders to one hairline per seam. It has no catalog '
          'page of its own yet in this port, so the live specimen below '
          'stands in for it: two outline icon buttons composed as a view '
          'switcher, the exact use button_group.dart\'s own docstring names '
          'first, "view switching, quantity steppers and split actions."',
      specimen: _ButtonGroupSpecimen(),
      code: _buttonGroupCode,
      label: 'Button Group specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter Button declares, every ButtonVariant '
          'and ButtonSize and ButtonEmphasis value, and ButtonStyleRecipe\'s '
          'own six override fields: one table per exported class or enum, '
          'plus a bonus table for the static helpers callers actually reach '
          'for.',
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Read straight off _DsButtonState._skin and _DsButtonState.build, '
          'not inferred: every duration cited is the real token the source '
          'names.',
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
            value: buttonDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/components_test.dart',
            description:
                'Button is covered inside the shared base-components '
                'suite (294 Button references at the time this page was '
                'written): there is no dedicated button_test.dart in the '
                'package yet.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/button_test.dart',
            description:
                'Covers this page: the article mounts, every ButtonVariant '
                'and ButtonSize this page claims to show, the full API '
                'table, and both themes at two viewport widths.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/button/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

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
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Button'),
    ],
    toc: buttonDocSpec.toc,
    previous: null,
    next: const DocsPageLink(title: 'Card', route: '/components/card'),
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('button-doc-article'),
      child: ComponentDocPage(spec: buttonDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */
// Each specimen is its own widget class so the section list above stays
// `const`. None of these sixteen need to hold their own state, so each is
// itself `const`-constructible; a future specimen that does would keep its
// state the same way, just without the `const` constructor.

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
          KeyedSubtree(
            key: const ValueKey<String>('button-preview:primary'),
            child: Button(onPressed: () {}, child: const Text('Primary')),
          ),
          SizedBox(width: space(2)),
          KeyedSubtree(
            key: const ValueKey<String>('button-preview:premium'),
            child: Button(
              variant: ButtonVariant.premium,
              onPressed: () {},
              child: const Text('Premium'),
            ),
          ),
          SizedBox(width: space(2)),
          KeyedSubtree(
            key: const ValueKey<String>('button-preview:secondary'),
            child: Button(
              variant: ButtonVariant.secondary,
              onPressed: () {},
              child: const Text('Secondary'),
            ),
          ),
          SizedBox(width: space(2)),
          KeyedSubtree(
            key: const ValueKey<String>('button-preview:outline'),
            child: Button(
              variant: ButtonVariant.outline,
              onPressed: () {},
              child: const Text('Outline'),
            ),
          ),
          SizedBox(width: space(2)),
          KeyedSubtree(
            key: const ValueKey<String>('button-preview:ghost'),
            child: Button(
              variant: ButtonVariant.ghost,
              onPressed: () {},
              child: const Text('Ghost'),
            ),
          ),
          SizedBox(width: space(2)),
          KeyedSubtree(
            key: const ValueKey<String>('button-preview:destructive'),
            child: Button(
              variant: ButtonVariant.destructive,
              onPressed: () {},
              child: const Text('Destructive'),
            ),
          ),
          SizedBox(width: space(2)),
          KeyedSubtree(
            key: const ValueKey<String>('button-preview:link'),
            child: Button(
              variant: ButtonVariant.link,
              onPressed: () {},
              child: const Text('Link'),
            ),
          ),
        ],
      ),
    ),
  );
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    'Row(\n'
    '  children: [\n'
    '    Button(\n'
    '      onPressed: () {},\n'
    "      child: const Text('Primary'),\n"
    '    ),\n'
    '    Button(\n'
    '      variant: ButtonVariant.premium,\n'
    '      onPressed: () {},\n'
    "      child: const Text('Premium'),\n"
    '    ),\n'
    '    Button(\n'
    '      variant: ButtonVariant.secondary,\n'
    '      onPressed: () {},\n'
    "      child: const Text('Secondary'),\n"
    '    ),\n'
    '    Button(\n'
    '      variant: ButtonVariant.outline,\n'
    '      onPressed: () {},\n'
    "      child: const Text('Outline'),\n"
    '    ),\n'
    '    Button(\n'
    '      variant: ButtonVariant.ghost,\n'
    '      onPressed: () {},\n'
    "      child: const Text('Ghost'),\n"
    '    ),\n'
    '    Button(\n'
    '      variant: ButtonVariant.destructive,\n'
    '      onPressed: () {},\n'
    "      child: const Text('Destructive'),\n"
    '    ),\n'
    '    Button(\n'
    '      variant: ButtonVariant.link,\n'
    '      onPressed: () {},\n'
    "      child: const Text('Link'),\n"
    '    ),\n'
    '  ],\n'
    ')';

class _SizeSpecimen extends StatelessWidget {
  const _SizeSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(3),
    runSpacing: space(3),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      KeyedSubtree(
        key: const ValueKey<String>('button-example:sizes-xs'),
        child: Button(
          size: ButtonSize.xs,
          onPressed: () {},
          child: const Text('Extra small'),
        ),
      ),
      KeyedSubtree(
        key: const ValueKey<String>('button-example:sizes-sm'),
        child: Button(
          size: ButtonSize.sm,
          onPressed: () {},
          child: const Text('Small'),
        ),
      ),
      KeyedSubtree(
        key: const ValueKey<String>('button-example:sizes-md'),
        child: Button(onPressed: () {}, child: const Text('Medium')),
      ),
      KeyedSubtree(
        key: const ValueKey<String>('button-example:sizes-lg'),
        child: Button(
          size: ButtonSize.lg,
          onPressed: () {},
          child: const Text('Large'),
        ),
      ),
      KeyedSubtree(
        key: const ValueKey<String>('button-example:sizes-xl'),
        child: Button(
          size: ButtonSize.xl,
          onPressed: () {},
          child: const Text('Extra large'),
        ),
      ),
    ],
  );
}

const String _sizeCode =
    'Button(size: ButtonSize.xs, onPressed: () {}, child: const Text(\'Extra small\'))\n'
    'Button(size: ButtonSize.sm, onPressed: () {}, child: const Text(\'Small\'))\n'
    'Button(onPressed: () {}, child: const Text(\'Medium\')) // size defaults to md\n'
    'Button(size: ButtonSize.lg, onPressed: () {}, child: const Text(\'Large\'))\n'
    'Button(size: ButtonSize.xl, onPressed: () {}, child: const Text(\'Extra large\'))';

class _DefaultSpecimen extends StatelessWidget {
  const _DefaultSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('button-example:default'),
    child: Button(onPressed: () {}, child: const Text('Button')),
  );
}

const String _defaultCode =
    "Button(\n  onPressed: () {},\n  child: const Text('Button'),\n)";

class _PremiumSpecimen extends StatelessWidget {
  const _PremiumSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('button-example:premium'),
    child: Button(
      variant: ButtonVariant.premium,
      onPressed: () {},
      child: const Text('Upgrade to Pro'),
    ),
  );
}

const String _premiumCode =
    'Button(\n'
    '  variant: ButtonVariant.premium,\n'
    '  onPressed: () {},\n'
    "  child: const Text('Upgrade to Pro'),\n"
    ')';

class _OutlineSpecimen extends StatelessWidget {
  const _OutlineSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('button-example:outline'),
    child: Button(
      variant: ButtonVariant.outline,
      onPressed: () {},
      child: const Text('Outline'),
    ),
  );
}

const String _outlineCode =
    'Button(\n'
    '  variant: ButtonVariant.outline,\n'
    '  onPressed: () {},\n'
    "  child: const Text('Outline'),\n"
    ')';

class _SecondarySpecimen extends StatelessWidget {
  const _SecondarySpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('button-example:secondary'),
    child: Button(
      variant: ButtonVariant.secondary,
      onPressed: () {},
      child: const Text('Secondary'),
    ),
  );
}

const String _secondaryCode =
    'Button(\n'
    '  variant: ButtonVariant.secondary,\n'
    '  onPressed: () {},\n'
    "  child: const Text('Secondary'),\n"
    ')';

class _GhostSpecimen extends StatelessWidget {
  const _GhostSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('button-example:ghost'),
    child: Button(
      variant: ButtonVariant.ghost,
      onPressed: () {},
      child: const Text('Ghost'),
    ),
  );
}

const String _ghostCode =
    'Button(\n'
    '  variant: ButtonVariant.ghost,\n'
    '  onPressed: () {},\n'
    "  child: const Text('Ghost'),\n"
    ')';

class _DestructiveSpecimen extends StatelessWidget {
  const _DestructiveSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('button-example:destructive'),
    child: Button(
      variant: ButtonVariant.destructive,
      onPressed: () {},
      child: const Text('Delete account'),
    ),
  );
}

const String _destructiveCode =
    'Button(\n'
    '  variant: ButtonVariant.destructive,\n'
    '  onPressed: () {},\n'
    "  child: const Text('Delete account'),\n"
    ')';

class _LinkSpecimen extends StatelessWidget {
  const _LinkSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('button-example:link'),
    child: Button(
      variant: ButtonVariant.link,
      onPressed: () {},
      child: const Text('Link'),
    ),
  );
}

const String _linkCode =
    'Button(\n'
    '  variant: ButtonVariant.link,\n'
    '  onPressed: () {},\n'
    "  child: const Text('Link'),\n"
    ')';

class _IconSpecimen extends StatelessWidget {
  const _IconSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(3),
    runSpacing: space(3),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      KeyedSubtree(
        key: const ValueKey<String>('button-example:icon-iconXs'),
        child: Button(
          variant: ButtonVariant.outline,
          size: ButtonSize.iconXs,
          label: 'Add item',
          onPressed: () {},
          child: const Icon(IconGlyph.plus, size: IconSize.xs),
        ),
      ),
      KeyedSubtree(
        key: const ValueKey<String>('button-example:icon-iconSm'),
        child: Button(
          variant: ButtonVariant.outline,
          size: ButtonSize.iconSm,
          label: 'Search',
          onPressed: () {},
          child: const Icon(IconGlyph.search, size: IconSize.sm),
        ),
      ),
      KeyedSubtree(
        key: const ValueKey<String>('button-example:icon-icon'),
        child: Button(
          variant: ButtonVariant.secondary,
          size: ButtonSize.icon,
          label: 'Settings',
          onPressed: () {},
          child: const Icon(IconGlyph.settings, size: IconSize.md),
        ),
      ),
      KeyedSubtree(
        key: const ValueKey<String>('button-example:icon-iconLg'),
        child: Button(
          variant: ButtonVariant.destructive,
          size: ButtonSize.iconLg,
          label: 'Delete',
          onPressed: () {},
          child: const Icon(IconGlyph.trash2, size: IconSize.lg),
        ),
      ),
    ],
  );
}

const String _iconCode =
    '// iconXs (24px), iconSm (32px), icon (40px), iconLg (48px): each\n'
    '// forces its own icon px (Button.iconPxFor) and requires a\n'
    '// label, since there is no visible text.\n'
    'Button(\n'
    '  variant: ButtonVariant.outline,\n'
    '  size: ButtonSize.icon,\n'
    "  label: 'Settings',\n"
    '  onPressed: () {},\n'
    '  child: const Icon(IconGlyph.settings, size: IconSize.md),\n'
    ')';

class _WithIconSpecimen extends StatelessWidget {
  const _WithIconSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('button-example:with-icon'),
    child: Button(
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(IconGlyph.download, size: IconSize.sm),
          SizedBox(width: Button.gapFor(ButtonSize.md)),
          const Text('Download'),
        ],
      ),
    ),
  );
}

const String _withIconCode =
    'Button(\n'
    '  onPressed: () {},\n'
    '  child: Row(\n'
    '    mainAxisSize: MainAxisSize.min,\n'
    '    children: <Widget>[\n'
    '      const Icon(IconGlyph.download, size: IconSize.sm),\n'
    '      SizedBox(width: Button.gapFor(ButtonSize.md)),\n'
    "      const Text('Download'),\n"
    '    ],\n'
    '  ),\n'
    ')';

class _RoundedSpecimen extends StatelessWidget {
  const _RoundedSpecimen();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: space(3),
    runSpacing: space(3),
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      KeyedSubtree(
        key: const ValueKey<String>('button-example:rounded-pill'),
        child: Button(onPressed: () {}, child: const Text('Pill (default)')),
      ),
      KeyedSubtree(
        key: const ValueKey<String>('button-example:rounded-lg'),
        child: Button(
          radius: BorderRadius.circular(Radii.lg),
          onPressed: () {},
          child: const Text('Sidebar row'),
        ),
      ),
      KeyedSubtree(
        key: const ValueKey<String>('button-example:rounded-md'),
        child: Button(
          radius: BorderRadius.circular(Radii.md),
          onPressed: () {},
          child: const Text('Sidebar action'),
        ),
      ),
    ],
  );
}

const String _roundedCode =
    "// Pill is the base list's own shape, on every variant.\n"
    'Button(onPressed: () {}, child: const Text(\'Pill (default)\'))\n'
    '\n'
    '// SidebarMenuButton / SidebarMenuSubButton override to rounded-lg.\n'
    'Button(\n'
    '  radius: BorderRadius.circular(Radii.lg),\n'
    '  onPressed: () {},\n'
    '  child: const Text(\'Sidebar row\'),\n'
    ')\n'
    '\n'
    '// SidebarMenuAction overrides further to rounded-md.\n'
    'Button(\n'
    '  radius: BorderRadius.circular(Radii.md),\n'
    '  onPressed: () {},\n'
    '  child: const Text(\'Sidebar action\'),\n'
    ')';

class _SpinnerSpecimen extends StatelessWidget {
  const _SpinnerSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('button-example:loading'),
    child: Button(
      loading: true,
      onPressed: () {},
      child: const Text('Please wait'),
    ),
  );
}

const String _spinnerCode =
    'Button(\n'
    '  loading: true,\n'
    '  onPressed: () {},\n'
    "  child: const Text('Please wait'),\n"
    ')';

class _DisabledSpecimen extends StatelessWidget {
  const _DisabledSpecimen();

  @override
  Widget build(BuildContext context) => const KeyedSubtree(
    key: ValueKey<String>('button-example:disabled'),
    child: Button(onPressed: null, child: Text('Disabled')),
  );
}

const String _disabledCode =
    "Button(\n  onPressed: null,\n  child: const Text('Disabled'),\n)";

class _EmphasisSpecimen extends StatelessWidget {
  const _EmphasisSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('button-example:emphasis'),
    child: Button(
      variant: ButtonVariant.premium,
      emphasis: ButtonEmphasis.caps,
      onPressed: () {},
      child: const Text('Claim reward'),
    ),
  );
}

const String _emphasisCode =
    'Button(\n'
    '  variant: ButtonVariant.premium,\n'
    '  emphasis: ButtonEmphasis.caps,\n'
    '  onPressed: () {},\n'
    "  child: const Text('Claim reward'),\n"
    ')';

class _ButtonGroupSpecimen extends StatelessWidget {
  const _ButtonGroupSpecimen();

  @override
  Widget build(BuildContext context) => ButtonGroup(
    children: <Widget>[
      Button(
        key: const ValueKey<String>('button-example:button-group-grid'),
        variant: ButtonVariant.outline,
        size: ButtonSize.icon,
        label: 'Grid view',
        onPressed: () {},
        child: const Icon(IconGlyph.layoutGrid, size: IconSize.md),
      ),
      Button(
        key: const ValueKey<String>('button-example:button-group-list'),
        variant: ButtonVariant.outline,
        size: ButtonSize.icon,
        label: 'List view',
        onPressed: () {},
        child: const Icon(IconGlyph.rows3, size: IconSize.md),
      ),
    ],
  );
}

const String _buttonGroupCode =
    'ButtonGroup(\n'
    '  children: [\n'
    '    Button(\n'
    '      variant: ButtonVariant.outline,\n'
    '      size: ButtonSize.icon,\n'
    "      label: 'Grid view',\n"
    '      onPressed: () {},\n'
    '      child: const Icon(IconGlyph.layoutGrid, size: IconSize.md),\n'
    '    ),\n'
    '    Button(\n'
    '      variant: ButtonVariant.outline,\n'
    '      size: ButtonSize.icon,\n'
    "      label: 'List view',\n"
    '      onPressed: () {},\n'
    '      child: const Icon(IconGlyph.rows3, size: IconSize.md),\n'
    '    ),\n'
    '  ],\n'
    ')';

/* ── Disclosure content ─────────────────────────────────────────────────── */
// Each of these reads `ThemeScope.of(context)` at build time, so it is its own
// widget rather than a value computed while `buttonDocSpec` is declared.

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

Button(
  onPressed: () {},
  child: const Text('Button'),
)''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsApiTable(title: 'Button', facts: _buttonApiFacts),
      SizedBox(height: space(6)),
      const DocsApiTable(
        title: 'Button static helpers',
        facts: _buttonStaticFacts,
      ),
      SizedBox(height: space(6)),
      const DocsApiTable(title: 'ButtonVariant', facts: _variantFacts),
      SizedBox(height: space(6)),
      const DocsApiTable(title: 'ButtonSize', facts: _sizeFacts),
      SizedBox(height: space(6)),
      const DocsApiTable(title: 'ButtonEmphasis', facts: _emphasisFacts),
      SizedBox(height: space(6)),
      const DocsApiTable(title: 'ButtonStyleRecipe', facts: _surfaceFacts),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Semantic role: Semantics(button: true) on the rendered node, on '
            'every variant without exception: including link, which is '
            'still a button underneath its anchor-like paint.',
        'Accessible name: label, when given, REPLACES the content\'s name '
            '(excludeSemantics: true) rather than joining it: required for '
            'an icon-only button. Omitted, the visible child (usually a '
            'Text) supplies the name instead.',
        'Keyboard interactions: Enter, NumpadEnter, and Space activate a '
            'focused, enabled button. Flutter gives a bare pointer widget '
            'none of that for free, Focus.onKeyEvent wires it by hand.',
        'Focus behavior: :focus-visible, not :focus. Flutter does not move '
            'focus on a bare pointer tap, only on keyboard traversal or an '
            'explicit request, so hasFocus here already is the '
            'keyboard-only signal CSS means.',
        'Focus ring: springs open 0 -> 3px spread on the same clock as '
            'everything else, at theme.ring 50% alpha: theme.destructive '
            '25% alpha (and a different border colour) on the destructive '
            'variant only.',
        'Touch target: not uniformly 44px. heightFor ranges from 24px '
            '(xs / iconXs) to 56px (xl), and the four icon squares are that '
            'size wide as well as tall, ButtonSize.iconXs is a 24x24 '
            'target. Button enforces no floor; a caller reaching for a '
            'dense icon button owns that trade-off.',
        'Known gap: expanded is visual only: _DsButtonState.build\'s '
            'Semantics node sets button / enabled / label / excludeSemantics '
            'and nothing else. Button.expanded changes which fill paints '
            'but is never surfaced as Semantics.expanded: an open trigger '
            'looks lit but is not announced as expanded.',
        'Loading and aria-busy: loading forces enabled: false, the same '
            'branch an ordinary disabled button takes: the one half of the '
            'reference\'s aria-busy behaviour Flutter can reproduce. '
            'SemanticsProperties in the pinned SDK (3.44.8) declares no busy '
            'flag at all, so assistive tech learns the control is not '
            'actionable but not why. Documented drift, not an oversight, '
            'the source docstring says so directly.',
        'suppressPressScale is visual only too: it cancels the 0.95 press '
            'scale for a trigger button (aria-haspopup\'s equivalent) but '
            'carries no semantic signal: nothing tells a screen reader this '
            'control opens something.',
      ]);
}

/// New: the design calls for this page to carry its own Keyboard section,
/// separate from the interaction facts folded into Accessibility above.
/// Every claim here is read off the same source Accessibility already
/// cites (`lib/src/components/ui/button.dart`'s `_onKey` and its `Focus`
/// wrapper), not inferred.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Activation: Enter, NumpadEnter, and Space activate a focused, '
            'enabled button. _onKey only inspects KeyDownEvent, a matching '
            'KeyUpEvent is ignored, and any other key returns '
            'KeyEventResult.ignored so it keeps propagating.',
        'Tab order: canRequestFocus is wired straight to _enabled, so a '
            'disabled button (onPressed: null) or a loading one (loading: '
            'true forces the same disabled branch) is removed from '
            'keyboard traversal entirely, not just dimmed in place.',
        'No custom ordering: button.dart wires no FocusTraversalPolicy of '
            'its own. Tab and Shift+Tab walk whatever order the '
            'surrounding page already declares.',
        'Pointer vs keyboard: a bare pointer tap never requests focus on '
            'the node; only keyboard traversal, or an explicit '
            'focusNode.requestFocus() from outside, does. That asymmetry '
            'is what lets hasFocus stand in for :focus-visible, see '
            'Accessibility above for the ring it drives.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'No breakpoint branching anywhere in button.dart, BuildContext '
            'width is never read for a layout decision; the same widget '
            'tree renders at 390px and 1440px.',
        'Every measurement (heightFor, gapFor, paddingXFor, iconPxFor) is a '
            'fixed 4px-grid value (space()) keyed only to ButtonSize, never '
            'to viewport.',
        'The one place a button\'s own width follows its surroundings is '
            'expanded: true (with contentAlignment): w-full justify-start '
            'instead of the default hug-content pill. Nothing in this file '
            'reads a breakpoint to decide when to pass it; that decision '
            'lives entirely at the call site.',
        'autoHeight drops the rung\'s fixed height (h-auto) and lets content '
            'set it instead: what the sidebar\'s own row sizes use in '
            'place of the 24/32/40/48/56 ladder above.',
        'Long labels are not truncated or wrapped specially: a Text child '
            'overflows however Text normally would; Button adds no '
            'ellipsis or maxLines of its own.',
        'Platform parity: Android, iOS, Web, macOS, Windows, and Linux all '
            'render the same widget tree: no dart:io Platform branch '
            'anywhere in the file.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ThemeScope.of(context), <String>[
        'File: lib/src/components/ui/button.dart: one file, no companions; '
            'the registry manifest lists exactly one entry under "files".',
        'Flutter imports: package:flutter/foundation.dart (clampDouble), '
            'package:flutter/services.dart (LogicalKeyboardKey, KeyEvent), '
            'package:flutter/widgets.dart.',
        'Foundation imports: foundation/colors.dart, foundation/motion.dart, '
            'foundation/shadows.dart, foundation/spacing.dart (space()), '
            'foundation/theme.dart, foundation/typography.dart, '
            'theme_scope.dart (StyledText, ThemeScope, effectiveMotionDuration).',
        'Effect imports: effects/action_feedback.dart (ActionFeedback, '
            'primary), effects/premium_surface.dart (PremiumSurface: premium), '
            'effects/surface.dart (Surface: secondary, '
            'outline, ghost, destructive, link).',
        'Component import: spinner.dart (Spinner: loading only).',
        'registryDependencies, resolved automatically by `elattar add '
            'button`: source-foundation, press, icon, spinner, '
            'premium-surface, surface, action-feedback: copied verbatim '
            'from registry/components/button.json.',
        'semanticDependencies (the manifest\'s own, narrower field): '
            'press, icon: a hint at what a button is commonly '
            'composed WITH, not a second import list; button.dart does not '
            'import icon.dart itself.',
      ]),
      SizedBox(height: space(2)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(
            label: 'Premium Surface',
            route: '/components/premium_surface',
          ),
          DocsLink(label: 'Icon', route: '/components/icon'),
          DocsLink(label: 'Surface', route: '/components/surface'),
          DocsLink(label: 'Press Motion', route: '/components/press'),
          DocsLink(
            label: 'Action Feedback',
            route: '/components/action_feedback',
          ),
          DocsLink(label: 'Spinner', route: '/components/spinner'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Every colour is read live off ThemeScope.of(context) at build time, '
            'theme.primary/primaryForeground (primary), theme.secondary/'
            'secondaryForeground/accent (secondary), theme.card/muted/'
            'input/foreground (outline), theme.mutedForeground/secondary/'
            'foreground (ghost), theme.destructive/destructiveText '
            '(destructive), theme.actionText (link), and theme.ring (the '
            'focus ring on every variant but destructive, which rings at '
            'theme.destructive instead). Flipping ThemeController '
            're-resolves every one on the next frame: nothing is cached.',
        'premium partially opts out: Palette.value and '
            'Palette.valueForeground are fixed tokens rather than theme.* '
            'getters, and the source says why, "the one foreground in the '
            'system that deliberately does NOT flip with the theme": the '
            'metal foil reads as the same lime-on-dark-text in both themes.',
        'Shape: the pill (BorderRadius.circular(Radii.full)) is a default '
            'a caller can override with radius: the sidebar\'s own row '
            'buttons are the one real caller that does, dropping to '
            'rounded-lg / rounded-md because "a 240px pill is a lozenge," '
            'see Rounded above for a live specimen of that override.',
        'Elevation is always a ShadowStyle token per variant and state, '
            'Shadows.controlPrimary / btnDown / btnValue / glowValue / btn / '
            'none: never a bespoke shadow at a call site. secondary and '
            'destructive both carry Shadows.none, which the shadows '
            'page\'s own copy contradicts (documented drift in button.dart\'s '
            'own class doc).',
        'surface (ButtonStyleRecipe) is the one escape hatch for a call site '
            'that must restyle fill / border / ink without forking a new '
            'variant: six optional Color? fields layered on top of the '
            'variant\'s own resolved skin, hover-aware. Used by exactly one '
            'real call site in the corpus (MessageScrollerButton) as of '
            'this port.',
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

const List<DocsApiFact> _buttonApiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        "Required. The button's content: an icon, a label, or a "
        'caller-built row of both spaced by Button.gapFor.',
  ),
  DocsApiFact(
    name: 'variant',
    type: 'ButtonVariant',
    description:
        'Optional. Defaults to ButtonVariant.primary. Selects fill, '
        'border, ink, and shadow: see the ButtonVariant table below.',
  ),
  DocsApiFact(
    name: 'size',
    type: 'ButtonSize',
    description:
        'Optional. Defaults to ButtonSize.md. Selects height, '
        'horizontal padding, icon gap, and forced icon-child px: see the '
        'ButtonSize table below.',
  ),
  DocsApiFact(
    name: 'emphasis',
    type: 'ButtonEmphasis',
    description:
        'Optional. Defaults to ButtonEmphasis.none. caps uppercases '
        "the visible label and switches to font-weight 600, beating "
        "whatever text style the size rung declared.",
  ),
  DocsApiFact(
    name: 'loading',
    type: 'bool',
    description:
        'Optional. Defaults to false. Prepends a Spinner, and, ORed '
        'with a null onPressed: disables the button: 45% opacity, no '
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
        'rather than joining it: required for an icon-only button.',
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
        "Button.paddingXFor(size) in charge. Replaces the rung's "
        "horizontal padding, Pagination's Previous/Next buttons are the "
        'one real caller that overrides it.',
  ),
  DocsApiFact(
    name: 'surface',
    type: 'ButtonStyleRecipe?',
    description:
        'Optional. Defaults to null. Fill/border/ink overrides layered '
        'on top of the resolved variant skin: see the ButtonStyleRecipe '
        'table below.',
  ),
  DocsApiFact(
    name: 'expanded',
    type: 'bool',
    description:
        "Optional. Defaults to false. Holds the variant's own hover fill "
        'open: the aria-expanded equivalent for a trigger whose popup '
        'is open. Paints on secondary, outline, and ghost only.',
  ),
  DocsApiFact(
    name: 'suppressPressScale',
    type: 'bool',
    description:
        'Optional. Defaults to false. Cancels the 0.95 press-scale for a '
        'button that opens something (a menu, a popover): the '
        'aria-haspopup equivalent. The shadow and colour legs still fire.',
  ),
  DocsApiFact(
    name: 'radius',
    type: 'BorderRadius?',
    description:
        'Optional. Defaults to null, which keeps the pill '
        '(BorderRadius.circular(Radii.full)). The sidebar\'s own row '
        'buttons are the one real caller that overrides it.',
  ),
  DocsApiFact(
    name: 'autoHeight',
    type: 'bool',
    description:
        "Optional. Defaults to false. Drops the rung's fixed height and "
        'lets the content set it instead: h-auto. Every other '
        'measurement the rung declares still applies.',
  ),
  DocsApiFact(
    name: 'contentAlignment',
    type: 'AlignmentGeometry?',
    description:
        'Optional. Defaults to null, which centres content on a '
        'hug-content pill. Non-null fills the incoming width at that '
        'alignment: w-full justify-start.',
  ),
];

const List<DocsApiFact> _buttonStaticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'Button.heightFor(size)',
    type: 'static double',
    description:
        "The rung's fixed height, 24 / 32 / 40 / 48 / 56 for the five "
        'text rungs, matching square for the four icon rungs.',
  ),
  DocsApiFact(
    name: 'Button.gapFor(size)',
    type: 'static double',
    description:
        "The gap between an icon and its label at this rung, 0 on "
        'every icon-only square. Exposed, not applied: a two-child '
        'button composes its own Row and asks here for the spacing.',
  ),
  DocsApiFact(
    name: 'Button.paddingXFor(size)',
    type: 'static double',
    description:
        "The rung's horizontal padding, 0 on every icon-only square, "
        'which centres the glyph instead.',
  ),
  DocsApiFact(
    name: 'Button.iconPxFor(size)',
    type: 'static double',
    description:
        "The px an icon child should render at for this rung: the "
        'caller\'s job to pass to Icon(size:) or sizePx:, since a '
        'Flutter parent cannot resize its child the way a CSS descendant '
        'selector can.',
  ),
  DocsApiFact(
    name: 'Button.typeFor(size, emphasis)',
    type: 'static TextStyleToken?',
    description:
        'The resolved text spec, or null on the four icon-only rungs, '
        'which set no font-size of their own and inherit the ambient '
        'DefaultTextStyle instead.',
  ),
  DocsApiFact(
    name: 'Button.isSquare(size)',
    type: 'static bool',
    description: 'True for iconXs, iconSm, icon, and iconLg.',
  ),
  DocsApiFact(
    name: 'Button.withFocusRing(spec, ring, {progress})',
    type: 'static ShadowStyle',
    description:
        'Composites a focus-visible ring in front of a shadow spec, '
        'the shared helper this widget and Input both reach for.',
  ),
];

const List<DocsApiFact> _variantFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'primary',
    type: 'enum value',
    description:
        "The constructor default. ActionFeedback over theme.primary; "
        'shadow-btn-primary at rest, shadow-btn-down while pressed.',
  ),
  DocsApiFact(
    name: 'premium',
    type: 'enum value',
    description:
        'PremiumSurface over Palette.value; Palette.valueForeground '
        'text, which does not flip with the theme. shadow-btn-value at '
        'rest, a glow on hover: the only variant with a hover glow.',
  ),
  DocsApiFact(
    name: 'secondary',
    type: 'enum value',
    description:
        'theme.secondary, moving to theme.accent on hover or an open '
        'trigger. No shadow at all (Shadows.none).',
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
        'solid fill: measured to clear AA where a solid fill would not. '
        'No shadow.',
  ),
  DocsApiFact(
    name: 'link',
    type: 'enum value',
    description:
        'Transparent, theme.actionText text, underlines on hover. Still '
        'reports Semantics(button: true), not link.',
  ),
];

const List<DocsApiFact> _sizeFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'xs',
    type: '24px · text',
    description:
        'Dense internal use only: chips inside a combobox or an '
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
    description: 'Hero CTA only: a landing page or a pack-opening moment.',
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
    description: 'Forces a 16px icon child: the default square.',
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
        "beating every rung's own text style: including the four icon "
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
        "Each variant's own resolved fill/border/ink/shadow: see the "
        'ButtonVariant table above.',
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
        'Transform.scale to 0.95, NOT animated; the exact frame the '
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
        'loading: true prepends a Spinner and forces the same disabled '
        'branch as above, regardless of onPressed. DOCUMENTED DRIFT: the '
        'spinner is not pre-reserved, so the button grows by '
        'Spinner.px + gapFor(size) the instant loading starts.',
    userSignal:
        'A spinner appears in front of the label; the control stops '
        'responding.',
  ),
  DocsStateFact(
    state: 'Expanded (aria-expanded)',
    treatment:
        'Holds the hover fill open on secondary, outline, and ghost '
        'only: the other four variants declare no such class. Not '
        'surfaced through Semantics (see Accessibility).',
    userSignal: 'The trigger stays lit while what it opened is still open.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'Every TweenAnimationBuilder duration routes through '
        'effectiveMotionDuration, which is Duration.zero under '
        'MediaQuery.disableAnimations. The press scale was never '
        'animated to begin with.',
    userSignal:
        'Colour, ring, and opacity all hard-cut instead of springing; '
        'nothing about the press changes.',
  ),
];
