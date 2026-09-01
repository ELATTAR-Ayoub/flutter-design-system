/// Public documentation page for the `selection_control` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose `Section`
/// panels; it now declares a `ComponentDocSpec`
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// `ComponentDocPage`, the same shape `button` established. Every specimen
/// widget and every code string below is the same one the hand-composed page
/// carried; only where it lives changed.
///
/// **selection_control** documents [SelectionControl], [HitArea], and
/// [StateChangeFeedback]: the shared socket, focus ring, hit-area expander and
/// jelly squash that [Checkbox], [RadioGroup], and [Switch] each wear.
/// It has no shadcn/Base UI counterpart page of any kind: it is an invented
/// internal primitive, so its content is "ours only" throughout.
///
/// **Section order**, matching `button`'s own house shape: Preview (the old
/// page's own un-headed hero demo, promoted to a real section with a rail
/// entry), Installation, Usage, then four sections named for the reader
/// problems the source actually solves (Hit area, Focus ring, Inert vs
/// disabled, Jelly replay), then the eight disclosures. New: a Keyboard
/// disclosure, between Accessibility and Responsive; the old page's single
/// Accessibility panel split in two, activation facts moving into Keyboard
/// and semantic/hit-area facts staying in Accessibility, matching how
/// `checkbox` and `button` separate the two concerns.
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

final ComponentDocSpec selectionControlDocSpec = ComponentDocSpec(
  name: 'selection-control',
  title: selectionControlDoc.title,
  description: selectionControlDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'SelectionControl in rest and checked states (focus-visible is '
          'painted separately: see Focus ring below).',
      specimen: _SelectionControlPreview(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'selection-control is a registry item: elattar add '
          'selection-control resolves it and its dependencies and copies '
          'the source into your project. The Manual tab is for a project '
          'not using the CLI.',
      command: selectionControlDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/selection_control.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/ui/selection_control.dart's generated "
              '@ui/selection_control.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated selection_control source here when '
              'using manual mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so SelectionControl, HitArea and '
              'StateChangeFeedback are reachable the same way the CLI path '
              'already makes them.',
          code: "export 'selection_control.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'SelectionControl is rarely constructed at a call site — '
          'Checkbox, RadioGroup, and Switch each wrap it with their '
          'own skin — but it is a public, directly usable widget.',
      code: _usageCode,
    ),
    ShowcaseSection(
      id: 'hit-area',
      title: 'Hit area',
      description:
          'The painted control (width x height) is smaller than the area '
          'that answers a tap: HitArea grows the pointer target past the '
          'padding box by 12px each side horizontally and 8px each side '
          "vertically (a checkbox's 20x20 box answers a 42x34 tap), "
          'without moving any neighbouring widget — the margin is a '
          'hit-test expansion, not a layout box.',
      specimen: _HitAreaPreview(),
      code: _hitAreaCode,
      label: 'Hit area specimen view',
    ),
    ShowcaseSection(
      id: 'focus-ring',
      title: 'Focus ring',
      description:
          'forceFocusRing overrides whether the ring paints: null (the '
          'default) follows real keyboard focus, true pins it open — for a '
          "static specimen, exactly what this page's own Preview above "
          'uses — and false withholds it even while the control genuinely '
          'has focus. invalid always beats it.',
      specimen: _FocusRingPreview(),
      code: _focusRingCode,
      label: 'Focus ring specimen view',
    ),
    ShowcaseSection(
      id: 'inert-vs-disabled',
      title: 'Inert vs disabled',
      description:
          'Operable, inert, and enabled: false are three distinct states, '
          'not two. inert paints at full strength and stays in the tab '
          'order but answers no pointer or key — the indeterminate-checkbox '
          'case, a control Radix holds at a value forever with no '
          'onCheckedChange. enabled: false dims to 50% opacity and leaves '
          'the tab order entirely.',
      specimen: _InertVsDisabledPreview(),
      code: _inertVsDisabledCode,
      label: 'Inert vs disabled specimen view',
    ),
    ShowcaseSection(
      id: 'jelly-replay',
      title: 'Jelly replay',
      description:
          'jellyState is handed to StateChangeFeedback: a squash animation '
          'replays every time it changes to a genuinely new value, and '
          'never on first mount — a MutationObserver-style guard, because '
          'the naive "animate on every data-state" approach would fire the '
          'squash for every unchecked control on the page as soon as it '
          'appeared.',
      specimen: _JellyReplayPreview(),
      code: _jellyReplayCode,
      label: 'Jelly replay specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter SelectionControl, HitArea, and '
          'StateChangeFeedback each declare.',
      children: const <DocsTocEntry>[
        DocsTocEntry(
          title: 'SelectionControl',
          anchor: 'api-elselectioncontrol',
        ),
        DocsTocEntry(title: 'HitArea', anchor: 'api-elhitarea'),
        DocsTocEntry(title: 'StateChangeFeedback', anchor: 'api-eljellyreplay'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'SelectionControl is configured by its caller (fill, border, '
          'shadow per state) rather than owning a fixed palette of its own '
          '— Checkbox, RadioGroup, and Switch each paint their own '
          'states using this socket.',
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
      description:
          "Read off lib/src/components/ui/selection_control.dart's own "
          '_onKey directly: the shared handler every Checkbox, '
          'RadioGroup and Switch answers keyboard input through.',
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
      description: 'What this component needs to install and run.',
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
        title: 'Source and tests',
        facts: <DocsInstallFact>[
          const DocsInstallFact(
            label: 'Source',
            value: 'lib/src/components/ui/selection_control.dart',
            description: 'The one source file.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/selection_feedback_test.dart',
            description: 'Tests for the shared primitive.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/selection_control_test.dart',
            description:
                "This page's own live preview, API-completeness check, "
                'and theme coverage.',
          ),
          DocsInstallFact(
            label: 'Edit these docs',
            value: selectionControlDoc.sourcePath.replaceFirst(
              'lib/src/components/ui/selection_control.dart',
              'example/lib/components_docs/selection_control/page.dart',
            ),
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class SelectionControlDocPage extends StatelessWidget {
  const SelectionControlDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: selectionControlDoc.route,
    intro: DocsPageIntro(
      title: selectionControlDoc.title,
      description: selectionControlDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Selection Control'),
    ],
    toc: selectionControlDocSpec.toc,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('selection-control-doc-article'),
      child: ComponentDocPage(spec: selectionControlDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

/// Builds one square SelectionControl for the previews below: a bare
/// checkbox-shaped socket with no indicator painted inside it, since this
/// page documents the socket rather than any one skin.
Widget _socket(
  ThemeTokens theme, {
  required bool on,
  bool forceFocusRing = false,
  bool inert = false,
  bool enabled = true,
  Key? key,
}) => SelectionControl(
  key: key,
  width: space(20),
  height: space(20),
  radius: BorderRadius.circular(Radii.sm),
  fill: on ? theme.primary : theme.background,
  border: on ? theme.primary : theme.input,
  shadow: on ? Shadows.controlPrimary : Shadows.inset,
  duration: MotionDurations.normal,
  jellyState: on,
  forceFocusRing: forceFocusRing,
  inert: inert,
  enabled: enabled,
  onTap: () {},
  child: const SizedBox(),
);

class _SelectionControlPreview extends StatefulWidget {
  const _SelectionControlPreview();

  @override
  State<_SelectionControlPreview> createState() =>
      _SelectionControlPreviewState();
}

class _SelectionControlPreviewState extends State<_SelectionControlPreview> {
  bool _forceFocusRing = false;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Button(
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          onPressed: () => setState(() => _forceFocusRing = !_forceFocusRing),
          child: StyledText(
            _forceFocusRing ? 'Hide focus ring' : 'Show focus ring',
            TextStyles.nav,
          ),
        ),
        SizedBox(height: space(3)),
        Wrap(
          spacing: space(5),
          runSpacing: space(5),
          children: <Widget>[
            SizedBox(
              width: space(32),
              height: space(32),
              child: _socket(
                theme,
                on: false,
                forceFocusRing: _forceFocusRing,
                key: const ValueKey<String>('selection-control-rest'),
              ),
            ),
            SizedBox(
              width: space(32),
              height: space(32),
              child: _socket(
                theme,
                on: true,
                forceFocusRing: _forceFocusRing,
                key: const ValueKey<String>('selection-control-checked'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

const String _previewCode = '''Wrap(
  spacing: 20,
  runSpacing: 20,
  children: [
    SelectionControl(
      width: space(20),
      height: space(20),
      radius: BorderRadius.circular(Radii.sm),
      fill: theme.background,
      border: theme.input,
      shadow: Shadows.inset,
      duration: MotionDurations.normal,
      jellyState: false,
      onTap: () {},
      child: const SizedBox(),
    ),
    SelectionControl(
      width: space(20),
      height: space(20),
      radius: BorderRadius.circular(Radii.sm),
      fill: theme.primary,
      border: theme.primary,
      shadow: Shadows.controlPrimary,
      duration: MotionDurations.normal,
      jellyState: true,
      onTap: () {},
      child: const SizedBox(),
    ),
  ],
)''';

const String _usageCode = '''SelectionControl(
  width: space(20),
  height: space(20),
  radius: BorderRadius.circular(Radii.sm),
  fill: checked ? theme.primary : theme.background,
  border: checked ? theme.primary : theme.input,
  shadow: checked ? Shadows.controlPrimary : Shadows.inset,
  duration: MotionDurations.normal,
  jellyState: checked,
  onTap: () => setState(() => checked = !checked),
  child: checked ? const Icon(IconGlyph.check, size: IconSize.xs) : const SizedBox(),
)''';

class _HitAreaPreview extends StatelessWidget {
  const _HitAreaPreview();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        DecoratedBox(
          // The dashed-look outline stands in for the invisible hit area:
          // 42 x 34 around a 20 x 20 checkbox-shaped control.
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.mutedForeground,
              width: BorderWidths.hairline,
            ),
            borderRadius: BorderRadius.circular(Radii.sm),
          ),
          child: SizedBox(
            key: const ValueKey<String>('selection-control-hit-area'),
            width: space(10.5),
            height: space(8.5),
            child: Center(child: _socket(theme, on: false)),
          ),
        ),
        SizedBox(width: space(4)),
        // Expanded, not a bare ConstrainedBox: at a narrow viewport the
        // panel this preview sits inside is far short of Containers.xs
        // (320px), and a fixed-width child in an unconstrained Row
        // overflows instead of wrapping.
        Expanded(
          child: StyledText(
            'The 20x20 box paints in the middle; the muted border marks the '
            '42x34 rect a tap anywhere inside still answers.',
            TextStyles.small,
            color: theme.mutedForeground,
          ),
        ),
      ],
    );
  }
}

const String _hitAreaCode =
    '''// SelectionControl wraps itself in HitArea internally: a 20x20
// checkbox-shaped control answers a pointer anywhere inside a 42x34 rect,
// without moving any neighbouring widget.
SelectionControl(
  width: space(20),
  height: space(20),
  // ...
)''';

class _FocusRingPreview extends StatefulWidget {
  const _FocusRingPreview();

  @override
  State<_FocusRingPreview> createState() => _FocusRingPreviewState();
}

class _FocusRingPreviewState extends State<_FocusRingPreview> {
  bool? _forced;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: space(2),
          children: <Widget>[
            Button(
              key: const ValueKey<String>('selection-control-focus-ring-null'),
              variant: _forced == null
                  ? ButtonVariant.secondary
                  : ButtonVariant.outline,
              size: ButtonSize.sm,
              onPressed: () => setState(() => _forced = null),
              child: StyledText('null (follow focus)', TextStyles.nav),
            ),
            Button(
              key: const ValueKey<String>('selection-control-focus-ring-true'),
              variant: _forced == true
                  ? ButtonVariant.secondary
                  : ButtonVariant.outline,
              size: ButtonSize.sm,
              onPressed: () => setState(() => _forced = true),
              child: StyledText('true (forced on)', TextStyles.nav),
            ),
            Button(
              key: const ValueKey<String>('selection-control-focus-ring-false'),
              variant: _forced == false
                  ? ButtonVariant.secondary
                  : ButtonVariant.outline,
              size: ButtonSize.sm,
              onPressed: () => setState(() => _forced = false),
              child: StyledText('false (withheld)', TextStyles.nav),
            ),
          ],
        ),
        SizedBox(height: space(4)),
        SizedBox(
          width: space(32),
          height: space(32),
          child: _socket(
            theme,
            on: false,
            forceFocusRing: _forced ?? false,
            key: const ValueKey<String>('selection-control-focus-ring'),
          ),
        ),
      ],
    );
  }
}

const String _focusRingCode = '''SelectionControl(
  // ...
  forceFocusRing: true, // pins the ring open for a static specimen
)''';

class _InertVsDisabledPreview extends StatelessWidget {
  const _InertVsDisabledPreview();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Wrap(
      spacing: space(6),
      runSpacing: space(4),
      children: <Widget>[
        _labelled(
          theme,
          'Operable',
          _socket(
            theme,
            on: false,
            key: const ValueKey<String>('selection-control-operable'),
          ),
        ),
        _labelled(
          theme,
          'Inert',
          _socket(
            theme,
            on: true,
            inert: true,
            key: const ValueKey<String>('selection-control-inert'),
          ),
        ),
        _labelled(
          theme,
          'enabled: false',
          _socket(
            theme,
            on: false,
            enabled: false,
            key: const ValueKey<String>('selection-control-disabled'),
          ),
        ),
      ],
    );
  }

  Widget _labelled(ThemeTokens theme, String label, Widget child) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      StyledText(label, TextStyles.small, color: theme.mutedForeground),
      SizedBox(height: space(2)),
      SizedBox(width: space(32), height: space(32), child: child),
    ],
  );
}

const String _inertVsDisabledCode =
    '''// Operable: paints normally, answers taps and Enter/Space.
SelectionControl(onTap: () {}, /* ... */)

// Inert: full strength, in the tab order, deaf to input.
SelectionControl(inert: true, onTap: null, /* ... */)

// Disabled: 50% opacity, out of the tab order.
SelectionControl(enabled: false, onTap: () {}, /* ... */)''';

class _JellyReplayPreview extends StatefulWidget {
  const _JellyReplayPreview();

  @override
  State<_JellyReplayPreview> createState() => _JellyReplayPreviewState();
}

class _JellyReplayPreviewState extends State<_JellyReplayPreview> {
  bool _on = false;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Button(
          key: const ValueKey<String>('selection-control-jelly-toggle'),
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          onPressed: () => setState(() => _on = !_on),
          child: StyledText('Toggle', TextStyles.nav),
        ),
        SizedBox(height: space(3)),
        SizedBox(
          width: space(32),
          height: space(32),
          child: _socket(
            theme,
            on: _on,
            key: const ValueKey<String>('selection-control-jelly'),
          ),
        ),
      ],
    );
  }
}

const String _jellyReplayCode =
    '''// SelectionControl threads jellyState into StateChangeFeedback internally:
// the squash replays every time this value actually changes.
SelectionControl(
  jellyState: checked,
  onTap: () => setState(() => checked = !checked),
  // ...
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elselectioncontrol',
        child: DocsApiTable(
          title: 'SelectionControl',
          facts: _selectionControlFacts,
        ),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-elhitarea',
        child: DocsApiTable(title: 'HitArea', facts: _hitAreaFacts),
      ),
      SizedBox(height: space(6)),
      const DocsAnchor(
        id: 'api-eljellyreplay',
        child: DocsApiTable(
          title: 'StateChangeFeedback',
          facts: _jellyReplayFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _selectionControlFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'width',
    type: 'double',
    description: 'Required. Painted size; the hit area expands beyond this.',
  ),
  DocsApiFact(
    name: 'height',
    type: 'double',
    description: 'Required. Painted size.',
  ),
  DocsApiFact(
    name: 'radius',
    type: 'BorderRadius',
    description: 'Required. Control shape.',
  ),
  DocsApiFact(
    name: 'fill',
    type: 'Color',
    description: "Required. Background at rest for the state the caller is in.",
  ),
  DocsApiFact(
    name: 'border',
    type: 'Color',
    description:
        'Required. Border at rest; overridden while focused or invalid.',
  ),
  DocsApiFact(
    name: 'shadow',
    type: 'ShadowStyle',
    description:
        'Required. The token for the state: shadow-pressed at rest, '
        'shadow-btn-primary when checked/on.',
  ),
  DocsApiFact(
    name: 'duration',
    type: 'Duration',
    description:
        'Required. The colour-transition length: all three callers pass '
        'MotionDurations.normal.',
  ),
  DocsApiFact(
    name: 'jellyState',
    type: 'Object?',
    description:
        'Required (nullable). Handed to StateChangeFeedback; a change replays '
        'the squash animation.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        'Required. The indicator (checkbox check, radio dot, switch '
        'knob), centred in the socket.',
  ),
  DocsApiFact(
    name: 'onTap',
    type: 'VoidCallback?',
    description: 'Optional. Defaults to null, which disables the control.',
  ),
  DocsApiFact(
    name: 'enabled',
    type: 'bool',
    description:
        'Optional. Defaults to true. Separate from inert: a control can '
        'be enabled but inert.',
  ),
  DocsApiFact(
    name: 'inert',
    type: 'bool',
    description:
        'Optional. Defaults to false. Indeterminate checkbox: '
        'full-strength paint, deaf, in tab order. See Inert vs disabled '
        'above.',
  ),
  DocsApiFact(
    name: 'invalid',
    type: 'bool',
    description:
        'Optional. Defaults to false. aria-invalid="true"; colours the '
        'border and ring red.',
  ),
  DocsApiFact(
    name: 'forceFocusRing',
    type: 'bool?',
    description:
        'Optional. Defaults to null (follow real focus). true paints the '
        'ring always; false withholds it. See Focus ring above.',
  ),
  DocsApiFact(
    name: 'focusNode',
    type: 'FocusNode?',
    description:
        'Optional. Defaults to null. The node for focus and roving '
        'tabindex.',
  ),
  DocsApiFact(
    name: 'skipTraversal',
    type: 'bool',
    description:
        'Optional. Defaults to false. Roving tabindex: used by radio '
        'groups.',
  ),
  DocsApiFact(
    name: 'onKey',
    type: 'KeyEventResult Function(KeyEvent)?',
    description:
        'Optional. Defaults to null. For group-level keyboard (arrows in '
        'a radio group), consulted before Enter and Space.',
  ),
  DocsApiFact(
    name: 'semantics',
    type: 'Widget Function(Widget)?',
    description:
        'Optional. Defaults to null. Applied inside the hit-area '
        'expander so a tap in the margin is not rejected before '
        'semantics.',
  ),
];

const List<DocsApiFact> _hitAreaFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'insets',
    type: 'EdgeInsets',
    description:
        'Required. How far past the padding box the control answers a '
        'pointer.',
  ),
  DocsApiFact(
    name: 'border',
    type: 'double?',
    description:
        'Optional. Defaults to null, which falls back to '
        'BorderWidths.hairline: the border insets is measured inside. Pass 0 '
        'for a wrapper that paints no border of its own.',
  ),
  DocsApiFact(name: 'child', type: 'Widget', description: 'Required.'),
  DocsApiFact(
    name: 'HitArea.debugExpanded(box)',
    type: 'static Rect',
    description:
        '@visibleForTesting. The expanded rect a render object answers, '
        'in its own coordinates.',
  ),
];

const List<DocsApiFact> _jellyReplayFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'state',
    type: 'Object?',
    description:
        'Required (nullable). Any value whose == changes on a real '
        'transition; a change replays the squash. Never fires on first '
        'mount.',
  ),
  DocsApiFact(name: 'child', type: 'Widget', description: 'Required.'),
];

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest / checked (caller-driven)',
    treatment:
        "fill, border, and shadow come straight from the caller's own "
        'arguments: this widget applies no per-state colour of its own.',
    userSignal:
        'Whatever the wrapping Checkbox/RadioGroup/Switch decided '
        'to hand it for the current state.',
  ),
  DocsStateFact(
    state: 'Focus-visible',
    treatment:
        'border and ring both become theme.ring; the ring springs from '
        'zero alpha to ring-ring/50 over the duration argument, unless '
        'forceFocusRing overrides it.',
    userSignal: 'A ring opens around the control.',
  ),
  DocsStateFact(
    state: 'Invalid',
    treatment:
        'border and ring both become theme.destructive (20% alpha on '
        'the ring), beating focus-visible even when both are true — '
        'aria-invalid wins.',
    userSignal:
        'A red border and ring, even while genuinely focused: the one '
        'place this system contradicts "focus is always visible" '
        '(reproduced exactly; measured against the reference).',
  ),
  DocsStateFact(
    state: 'Inert',
    treatment: 'Full-strength paint; canRequestFocus true; onTap never runs.',
    userSignal: 'Looks live, does nothing. See Inert vs disabled above.',
  ),
  DocsStateFact(
    state: 'Disabled',
    treatment:
        'Opacity drops to 50%; IgnorePointer stops all input; '
        'canRequestFocus becomes false.',
    userSignal: 'Dimmed and unreachable by keyboard or pointer.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'Colour transitions route through effectiveMotionDuration, which is '
        'Duration.zero under MediaQuery.disableAnimations. StateChangeFeedback '
        "still plays: the reference's own jelly plays in reduced motion "
        'mode too (measured).',
    userSignal:
        'Colours hard-cut instead of transitioning; the squash still '
        'animates.',
  ),
];

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Semantic role: entirely caller-supplied. semantics wraps the '
            'hit-area expander in whatever Semantics node Checkbox, '
            'RadioGroup or Switch build for their own state '
            '(checked/mixed, toggled, or a radio\'s own selected flag): '
            'SelectionControl itself declares no role of its own.',
        'Hit area: the visible control is 20x20 (checkbox/radio) or '
            '44x24 (switch), but the hit area expands to 42x34, 66x38, '
            'and 34x34 respectively. Margin expansion, not padding: '
            'neighbours stay in place, and a tap anywhere inside the '
            'margin still reaches semantics because HitArea applies '
            'the caller\'s semantics wrapper INSIDE the expander.',
        'Focus behavior: focus-visible:border-ring plus a ring, beaten '
            'by aria-invalid:border-destructive at equal specificity: a '
            'focused, invalid control renders identically to an '
            'unfocused invalid one. See States above.',
        'Non-colour signal: SelectionControl paints none of its own; '
            'the shape-based signal (a drawn tick or bar, a thumb\'s '
            'left/right position) belongs entirely to whichever skin '
            'wraps this socket, documented on that component\'s own '
            'page.',
      ]);
}

/// Read directly off `lib/src/components/ui/selection_control.dart`'s own
/// `_onKey`: the shared handler every `Checkbox`, `RadioGroup` and
/// `Switch` answers keyboard input through.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Activation: Enter and Space activate an operable control — it '
            'is a button. onKey is consulted FIRST, before Enter/Space: '
            'a radio group supplies one for its own arrow-key '
            'navigation, and a non-ignored result from it short-circuits '
            'the default activation check entirely.',
        '_onKey only inspects KeyDownEvent; a matching KeyUpEvent is '
            'ignored, and any key that is neither owned by onKey nor '
            'Enter/Space/NumpadEnter returns KeyEventResult.ignored so '
            'it keeps propagating.',
        'Tab order: canRequestFocus is wired to enabled && (inert || '
            'onTap != null), deliberately NOT the same predicate as '
            '_enabled (enabled && !inert && onTap != null): disabled '
            'removes a control from the tab order; inert does not, '
            'which is the whole of what inert exists to fix. See Inert '
            'vs disabled above.',
        'skipTraversal exists for a roving-tabindex group: a radio '
            'group\'s own items pass it on every member but the '
            'selected one, so Tab lands on the group once rather than '
            'stepping through every option.',
        'Pointer vs keyboard: a bare pointer tap never requests focus '
            'on the node; only keyboard traversal, or an explicit '
            'focusNode.requestFocus() from outside, does — the same '
            "asymmetry Button's own Keyboard section documents.",
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ThemeScope.of(context), <String>[
        'Sized entirely by its caller (width, height): no responsive '
            'breakpoints of its own.',
        'No BuildContext width is ever read for a layout decision; the '
            'same widget tree renders at 390px and 1440px.',
        'Platform parity: Android, iOS, Web, macOS, Windows and Linux '
            'all render the same widget tree: selection_control.dart '
            'imports no dart:io Platform and branches on nothing.',
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
            value: 'registry/components/selection-control.json',
            description:
                'Shipped and resolved by `elattar add selection-control`.',
          ),
          const DocsInstallFact(
            label: 'Source file',
            value: 'selection_control.dart',
            description:
                'lib/src/components/ui/selection_control.dart, exported '
                'from the public barrel.',
          ),
          DocsInstallFact(
            label: 'Dependencies',
            value: selectionControlDoc.dependencies.join(', '),
            description:
                'Surface paints the socket; KeyframePlayer '
                '(motion/keyframes.dart) drives the jelly squash; '
                'button.dart supplies Button.withFocusRing, the shared '
                'ring-compositing helper.',
          ),
          const DocsInstallFact(
            label: 'Platforms',
            value: 'Android, iOS, Web, macOS, Windows, Linux',
            description: 'Pure widget composition; nothing platform-gated.',
          ),
          const DocsInstallFact(
            label: 'Verified',
            value: 'package tests + this docs specimen',
            description:
                'test/selection_feedback_test.dart and '
                'example/test/components_docs/'
                'selection_control_test.dart.',
          ),
        ],
      ),
      SizedBox(height: space(4)),
      const DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Button', route: '/components/button'),
          DocsLink(label: 'Surface', route: '/components/surface'),
          DocsLink(label: 'Keyframes', route: '/components/keyframes'),
          DocsLink(
            label: 'Source Foundation',
            route: '/components/source_foundation',
          ),
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
        'SelectionControl reads no theme colours for its own resting '
            'paint: fill, border, and shadow all come from the '
            "caller's own arguments.",
        'Only the focus ring (theme.ring) and the invalid ring/border '
            '(theme.destructive) are resolved here, straight off '
            'ThemeScope.of(context) at build time: the two states this '
            'widget owns outright rather than delegating to its caller.',
      ]);
}

/// Bulleted prose at reading width, matching `button/page.dart`'s own
/// private `_bullets` helper.
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
