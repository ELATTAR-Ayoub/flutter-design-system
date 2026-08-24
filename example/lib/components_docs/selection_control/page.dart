/// Public component documentation for the `selection_control` component.
///
/// **selection_control** documents [ElSelectionControl], [ElHitArea], and
/// [ElJellyReplay].
///
/// selection_control has no shadcn counterpart page of any kind: it is an
/// invented internal primitive, so its content is "ours only" throughout.
/// Section shape: a live demo ahead of any heading, then Installation,
/// Usage, then four sections named for the reader problems the source
/// actually solves — Hit area, Focus ring, Inert vs disabled, Jelly replay —
/// then API Reference, then this package's own six trailing sections
/// (States, Accessibility, Responsive, Dependencies, Theming, Source).
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import '../catalog.dart';
import 'meta.dart';

class SelectionControlDocPage extends StatelessWidget {
  const SelectionControlDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ComponentDocEntry entry = selectionControlDoc;
    return DocsLayout(
      route: entry.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / BASE',
        title: entry.title,
        description: entry.description,
      ),
      breadcrumbs: const <ElBreadcrumbEntry>[
        ElBreadcrumbEntry.link('Components'),
        ElBreadcrumbEntry.page('Selection Control'),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Hit area', anchor: 'hit-area'),
        DocsTocEntry(title: 'Focus ring', anchor: 'focus-ring'),
        DocsTocEntry(title: 'Inert vs disabled', anchor: 'inert-vs-disabled'),
        DocsTocEntry(title: 'Jelly replay', anchor: 'jelly-replay'),
        DocsTocEntry(
          title: 'API Reference',
          anchor: 'api',
          children: <DocsTocEntry>[
            DocsTocEntry(
              title: 'ElSelectionControl',
              anchor: 'api-elselectioncontrol',
            ),
            DocsTocEntry(title: 'ElHitArea', anchor: 'api-elhitarea'),
            DocsTocEntry(title: 'ElJellyReplay', anchor: 'api-eljellyreplay'),
          ],
        ),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      onNavigate: onNavigate,
      child: _SelectionControlArticle(entry: entry),
    );
  }
}

class _SelectionControlArticle extends StatelessWidget {
  const _SelectionControlArticle({required this.entry});

  final ComponentDocEntry entry;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      key: const ValueKey<String>('selection-control-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DocsCodeExample(
          title: 'Live specimen',
          description:
              'ElSelectionControl in rest and checked states (focus-visible '
              'is painted here, not simulated).',
          preview: const _SelectionControlPreview(),
          command: DocsCodeCommand(command: entry.command),
        ),
        SizedBox(height: el(8)),
        ElSection(
          id: 'install',
          title: 'Installation',
          description:
              'Install with elattar add selection-control, or import from the package barrel when you depend on the package directly.',
          child: DocsCodeExample(
            title: 'Package import',
            command: DocsCodeCommand(
              command: entry.command,
              description:
                  'Import ElSelectionControl from the public barrel: no '
                  'CLI command yet.',
            ),
            manualFiles: const <DocsCodeFile>[
              DocsCodeFile(
                path: 'lib/selection_control.dart',
                code:
                    "import 'package:elattar_design_system/"
                    "elattar_design_system.dart';\n\n"
                    '// Install with `elattar add selection-control`, or import from the package barrel when you depend on the package directly.',
              ),
            ],
          ),
        ),
        ElSection(
          id: 'usage',
          title: 'Usage',
          description:
              'ElSelectionControl is rarely constructed at a call site — '
              'ElCheckbox, ElRadioGroup, and ElSwitch each wrap it with '
              'their own skin — but it is a public, directly usable widget.',
          child: ElPanel(
            label: 'DART',
            note: 'MINIMAL',
            child: DocsSelectableCodeBlock(code: _usageCode),
          ),
        ),
        ElSection(
          id: 'hit-area',
          title: 'Hit area',
          description:
              'The painted control (width x height) is smaller than the '
              'area that answers a tap: ElHitArea grows the pointer target '
              'past the padding box by 12px each side horizontally and 8px '
              'each side vertically (a checkbox\'s 20x20 box answers a '
              '42x34 tap), without moving any neighbouring widget — the '
              'margin is a hit-test expansion, not a layout box.',
          child: DocsCodeExample(
            title: 'Painted box vs hit area',
            preview: const _HitAreaPreview(),
            manualFiles: const <DocsCodeFile>[
              DocsCodeFile(path: 'hit_area.dart', code: _hitAreaCode),
            ],
          ),
        ),
        ElSection(
          id: 'focus-ring',
          title: 'Focus ring',
          description:
              'forceFocusRing overrides whether the ring paints: null (the '
              'default) follows real keyboard focus, true pins it open — '
              'for a static specimen, exactly what this page\'s own live '
              'demo above uses — and false withholds it even while the '
              'control genuinely has focus. invalid always beats it.',
          child: DocsCodeExample(
            title: 'Forcing the ring open',
            preview: const _FocusRingPreview(),
            manualFiles: const <DocsCodeFile>[
              DocsCodeFile(path: 'focus_ring.dart', code: _focusRingCode),
            ],
          ),
        ),
        ElSection(
          id: 'inert-vs-disabled',
          title: 'Inert vs disabled',
          description:
              'Operable, inert, and enabled: false are three distinct '
              'states, not two. inert paints at full strength and stays in '
              'the tab order but answers no pointer or key — the '
              'indeterminate-checkbox case, a control Radix holds at a '
              'value forever with no onCheckedChange. enabled: false dims '
              'to 50% opacity and leaves the tab order entirely.',
          child: DocsCodeExample(
            title: 'Three states, side by side',
            preview: const _InertVsDisabledPreview(),
            manualFiles: const <DocsCodeFile>[
              DocsCodeFile(
                path: 'inert_vs_disabled.dart',
                code: _inertVsDisabledCode,
              ),
            ],
          ),
        ),
        ElSection(
          id: 'jelly-replay',
          title: 'Jelly replay',
          description:
              'jellyState is handed to ElJellyReplay: a squash animation '
              'replays every time it changes to a genuinely new value, and '
              'never on first mount — a MutationObserver-style guard, '
              'because the naive "animate on every data-state" approach '
              'would fire the squash for every unchecked control on the '
              'page as soon as it appeared.',
          child: DocsCodeExample(
            title: 'Toggle to replay the squash',
            preview: const _JellyReplayPreview(),
            manualFiles: const <DocsCodeFile>[
              DocsCodeFile(path: 'jelly_replay.dart', code: _jellyReplayCode),
            ],
          ),
        ),
        ElSection(
          id: 'api',
          title: 'API Reference',
          description:
              'Every constructor parameter ElSelectionControl, ElHitArea, '
              'and ElJellyReplay each declare.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              KeyedSubtree(
                key: docsAnchorKey('api-elselectioncontrol'),
                child: const DocsApiTable(
                  title: 'ElSelectionControl',
                  facts: <DocsApiFact>[
                    DocsApiFact(
                      name: 'width',
                      type: 'double',
                      description:
                          'Required. Painted size; the hit area expands '
                          'beyond this.',
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
                      description:
                          'Required. Background at rest for the state the '
                          'caller is in.',
                    ),
                    DocsApiFact(
                      name: 'border',
                      type: 'Color',
                      description:
                          'Required. Border at rest; overridden while '
                          'focused or invalid.',
                    ),
                    DocsApiFact(
                      name: 'shadow',
                      type: 'ElShadowSpec',
                      description:
                          'Required. The token for the state: shadow-pressed '
                          'at rest, shadow-btn-primary when checked/on.',
                    ),
                    DocsApiFact(
                      name: 'duration',
                      type: 'Duration',
                      description:
                          'Required. The colour-transition length: all three '
                          'callers pass ElDurations.transitionDefault.',
                    ),
                    DocsApiFact(
                      name: 'jellyState',
                      type: 'Object?',
                      description:
                          'Required (nullable). Handed to ElJellyReplay; a '
                          'change replays the squash animation.',
                    ),
                    DocsApiFact(
                      name: 'child',
                      type: 'Widget',
                      description:
                          'Required. The indicator (checkbox check, radio '
                          'dot, switch knob), centred in the socket.',
                    ),
                    DocsApiFact(
                      name: 'onTap',
                      type: 'VoidCallback?',
                      description:
                          'Optional. Defaults to null, which disables the '
                          'control.',
                    ),
                    DocsApiFact(
                      name: 'enabled',
                      type: 'bool',
                      description:
                          'Optional. Defaults to true. Separate from inert: '
                          'a control can be enabled but inert.',
                    ),
                    DocsApiFact(
                      name: 'inert',
                      type: 'bool',
                      description:
                          'Optional. Defaults to false. Indeterminate '
                          'checkbox: full-strength paint, deaf, in tab '
                          'order. See Inert vs disabled above.',
                    ),
                    DocsApiFact(
                      name: 'invalid',
                      type: 'bool',
                      description:
                          'Optional. Defaults to false. aria-invalid="true"; '
                          'colours the border and ring red.',
                    ),
                    DocsApiFact(
                      name: 'forceFocusRing',
                      type: 'bool?',
                      description:
                          'Optional. Defaults to null (follow real focus). '
                          'true paints the ring always; false withholds it. '
                          'See Focus ring above.',
                    ),
                    DocsApiFact(
                      name: 'focusNode',
                      type: 'FocusNode?',
                      description:
                          'Optional. Defaults to null. The node for focus '
                          'and roving tabindex.',
                    ),
                    DocsApiFact(
                      name: 'skipTraversal',
                      type: 'bool',
                      description:
                          'Optional. Defaults to false. Roving tabindex: '
                          'used by radio groups.',
                    ),
                    DocsApiFact(
                      name: 'onKey',
                      type: 'KeyEventResult Function(KeyEvent)?',
                      description:
                          'Optional. Defaults to null. For group-level '
                          'keyboard (arrows in a radio group), consulted '
                          'before Enter and Space.',
                    ),
                    DocsApiFact(
                      name: 'semantics',
                      type: 'Widget Function(Widget)?',
                      description:
                          'Optional. Defaults to null. Applied inside the '
                          'hit-area expander so a tap in the margin is not '
                          'rejected before semantics.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: el(6)),
              KeyedSubtree(
                key: docsAnchorKey('api-elhitarea'),
                child: const DocsApiTable(
                  title: 'ElHitArea',
                  facts: <DocsApiFact>[
                    DocsApiFact(
                      name: 'insets',
                      type: 'EdgeInsets',
                      description:
                          'Required. How far past the padding box the '
                          'control answers a pointer.',
                    ),
                    DocsApiFact(
                      name: 'border',
                      type: 'double?',
                      description:
                          'Optional. Defaults to null, which falls back to '
                          'ElWidths.hairline: the border insets is measured '
                          'inside. Pass 0 for a wrapper that paints no '
                          'border of its own.',
                    ),
                    DocsApiFact(
                      name: 'child',
                      type: 'Widget',
                      description: 'Required.',
                    ),
                    DocsApiFact(
                      name: 'ElHitArea.debugExpanded(box)',
                      type: 'static Rect',
                      description:
                          '@visibleForTesting. The expanded rect a render '
                          'object answers, in its own coordinates.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: el(6)),
              KeyedSubtree(
                key: docsAnchorKey('api-eljellyreplay'),
                child: const DocsApiTable(
                  title: 'ElJellyReplay',
                  facts: <DocsApiFact>[
                    DocsApiFact(
                      name: 'state',
                      type: 'Object?',
                      description:
                          'Required (nullable). Any value whose == changes '
                          'on a real transition; a change replays the '
                          'squash. Never fires on first mount.',
                    ),
                    DocsApiFact(
                      name: 'child',
                      type: 'Widget',
                      description: 'Required.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ElSection(
          id: 'states',
          title: 'States',
          description:
              'ElSelectionControl is configured by its caller (fill, '
              'border, shadow per state) rather than owning a fixed palette '
              'of its own — ElCheckbox, ElRadioGroup, and ElSwitch each '
              'paint their own states using this socket.',
          child: const DocsStateMatrix(
            facts: <DocsStateFact>[
              DocsStateFact(
                state: 'Rest / checked (caller-driven)',
                treatment:
                    'fill, border, and shadow come straight from the '
                    'caller\'s own arguments: this widget applies no '
                    'per-state colour of its own.',
                userSignal:
                    'Whatever the wrapping ElCheckbox/ElRadioGroup/'
                    'ElSwitch decided to hand it for the current state.',
              ),
              DocsStateFact(
                state: 'Focus-visible',
                treatment:
                    'border and ring both become theme.ring; the ring '
                    'springs from zero alpha to ring-ring/50 over the '
                    'duration argument, unless forceFocusRing overrides it.',
                userSignal: 'A ring opens around the control.',
              ),
              DocsStateFact(
                state: 'Invalid',
                treatment:
                    'border and ring both become theme.destructive '
                    '(20% alpha on the ring), beating focus-visible even '
                    'when both are true — aria-invalid wins.',
                userSignal:
                    'A red border and ring, even while genuinely focused: '
                    'the one place this system contradicts "focus is '
                    'always visible" (reproduced exactly; measured against '
                    'the reference).',
              ),
              DocsStateFact(
                state: 'Inert',
                treatment:
                    'Full-strength paint; canRequestFocus true; '
                    'onTap never runs.',
                userSignal:
                    'Looks live, does nothing. See Inert vs disabled '
                    'above.',
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
                    'Colour transitions route through elAnimationDuration, '
                    'which is Duration.zero under '
                    'MediaQuery.disableAnimations. ElJellyReplay still '
                    'plays: the reference\'s own jelly plays in reduced '
                    'motion mode too (measured).',
                userSignal:
                    'Colours hard-cut instead of transitioning; the squash '
                    'still animates.',
              ),
            ],
          ),
        ),
        ElSection(
          id: 'accessibility',
          title: 'Accessibility',
          description: 'The keyboard and semantic contract.',
          child: ElPanel(
            label: 'Keyboard',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const _A11yRow(
                  'Activation',
                  'Enter and Space activate the control: it is a button. A '
                      'custom onKey handler is consulted first (for radio '
                      'group arrows).',
                ),
                const _A11yRow(
                  'Hit area',
                  'The visible control is 20x20 (checkbox/radio) or 44x24 '
                      '(switch), but the hit area expands to 42x34, 66x38, '
                      'and 34x34 respectively. Margin expansion, not '
                      'padding: neighbours stay in place.',
                ),
                _A11yRow(
                  'Semantics',
                  'The semantics wrapper is optional and caller-supplied; '
                      'ElCheckbox, ElRadioGroup, and ElSwitch each supply '
                      'their own.',
                  last: true,
                ),
              ],
            ),
          ),
        ),
        ElSection(
          id: 'responsive',
          title: 'Responsive',
          child: _bullets(theme, <String>[
            'Sized entirely by its caller (width, height): no responsive '
                'breakpoints of its own.',
            'No BuildContext width is ever read for a layout decision; the '
                'same widget tree renders at 390px and 1440px.',
          ]),
        ),
        ElSection(
          id: 'dependencies',
          title: 'Dependencies',
          description: 'What this component needs to install and run.',
          child: DocsInstallFacts(
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
                    'lib/src/components/selection_control.dart, exported '
                    'from the public barrel.',
              ),
              const DocsInstallFact(
                label: 'Dependencies',
                value:
                    'source-foundation, machine-surface, keyframes, '
                    'button',
                description:
                    'ElMachineSurface paints the socket; ElKeyframePlayer '
                    '(motion/keyframes.dart) drives the jelly squash; '
                    'button.dart supplies ElButton.withFocusRing, the '
                    'shared ring-compositing helper.',
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
                    'test/selection_control_test.dart and '
                    'example/test/components_docs/selection_control_test.dart.',
              ),
            ],
          ),
        ),
        ElSection(
          id: 'theming',
          title: 'Theming',
          child: ElPanel(
            label: 'What varies with the theme',
            child: ElText(
              'ElSelectionControl reads no theme colours itself: fill, '
              'border, and shadow all come from the caller\'s own '
              'arguments. Only the focus ring (theme.ring) and the invalid '
              'ring/border (theme.destructive) are resolved here, straight '
              'off ElTheme.of(context) at build time.',
              ElType.small,
            ),
          ),
        ),
        ElSection(
          id: 'source',
          title: 'Source',
          child: DocsInstallFacts(
            title: 'Source and tests',
            facts: const <DocsInstallFact>[
              DocsInstallFact(
                label: 'Source',
                value: 'lib/src/components/selection_control.dart',
                description: 'The one source file.',
              ),
              DocsInstallFact(
                label: 'Package tests',
                value: 'test/selection_control_test.dart',
                description: 'Tests for the shared primitive.',
              ),
              DocsInstallFact(
                label: 'Docs specimen',
                value:
                    'example/test/components_docs/selection_control_test.dart',
                description:
                    'This page\'s own live preview, API-completeness check, '
                    'and theme coverage.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _bullets(ElThemeData theme, List<String> lines) => ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: ElWidths.prose),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      for (final String line in lines) ...<Widget>[
        ElText('•  $line', ElType.small, color: theme.mutedForeground),
        SizedBox(height: el(2)),
      ],
    ],
  ),
);

class _A11yRow extends StatelessWidget {
  const _A11yRow(this.label, this.body, {this.last = false});

  final String label;
  final String body;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : el(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ElText(label, ElType.label, color: theme.actionInk),
          SizedBox(height: el(1)),
          ElText(body, ElType.small),
        ],
      ),
    );
  }
}

/// Builds one square ElSelectionControl for the previews below: a bare
/// checkbox-shaped socket with no indicator painted inside it, since this
/// page documents the socket rather than any one skin.
Widget _socket(
  ElThemeData theme, {
  required bool on,
  bool forceFocusRing = false,
  bool inert = false,
  bool enabled = true,
  Key? key,
}) => ElSelectionControl(
  key: key,
  width: el(20),
  height: el(20),
  radius: BorderRadius.circular(ElRadii.sm),
  fill: on ? theme.primary : theme.background,
  border: on ? theme.primary : theme.input,
  shadow: on ? ElShadows.btnPrimary : ElShadows.pressed,
  duration: ElDurations.transitionDefault,
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
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ElButton(
          variant: ElButtonVariant.outline,
          size: ElButtonSize.sm,
          onPressed: () => setState(() => _forceFocusRing = !_forceFocusRing),
          child: ElText(
            _forceFocusRing ? 'Hide focus ring' : 'Show focus ring',
            ElComponentType.buttonLabel,
          ),
        ),
        SizedBox(height: el(3)),
        Wrap(
          spacing: el(5),
          runSpacing: el(5),
          children: <Widget>[
            SizedBox(
              width: el(32),
              height: el(32),
              child: _socket(
                theme,
                on: false,
                forceFocusRing: _forceFocusRing,
                key: const ValueKey<String>('selection-control-rest'),
              ),
            ),
            SizedBox(
              width: el(32),
              height: el(32),
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

class _HitAreaPreview extends StatelessWidget {
  const _HitAreaPreview();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        DecoratedBox(
          // The dashed-look outline stands in for the invisible hit area:
          // 42 x 34 around a 20 x 20 checkbox-shaped control.
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.mutedForeground,
              width: ElWidths.hairline,
            ),
            borderRadius: BorderRadius.circular(ElRadii.sm),
          ),
          child: SizedBox(
            key: const ValueKey<String>('selection-control-hit-area'),
            width: el(10.5),
            height: el(8.5),
            child: Center(child: _socket(theme, on: false)),
          ),
        ),
        SizedBox(width: el(4)),
        // Expanded, not a bare ConstrainedBox: at a narrow viewport the
        // panel this preview sits inside is far short of ElContainers.xs
        // (320px), and a fixed-width child in an unconstrained Row
        // overflows instead of wrapping.
        Expanded(
          child: ElText(
            'The 20x20 box paints in the middle; the muted border marks the '
            '42x34 rect a tap anywhere inside still answers.',
            ElType.small,
            color: theme.mutedForeground,
          ),
        ),
      ],
    );
  }
}

class _FocusRingPreview extends StatefulWidget {
  const _FocusRingPreview();

  @override
  State<_FocusRingPreview> createState() => _FocusRingPreviewState();
}

class _FocusRingPreviewState extends State<_FocusRingPreview> {
  bool? _forced;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: el(2),
          children: <Widget>[
            ElButton(
              key: const ValueKey<String>('selection-control-focus-ring-null'),
              variant: _forced == null
                  ? ElButtonVariant.secondary
                  : ElButtonVariant.outline,
              size: ElButtonSize.sm,
              onPressed: () => setState(() => _forced = null),
              child: ElText('null (follow focus)', ElComponentType.buttonLabel),
            ),
            ElButton(
              key: const ValueKey<String>('selection-control-focus-ring-true'),
              variant: _forced == true
                  ? ElButtonVariant.secondary
                  : ElButtonVariant.outline,
              size: ElButtonSize.sm,
              onPressed: () => setState(() => _forced = true),
              child: ElText('true (forced on)', ElComponentType.buttonLabel),
            ),
            ElButton(
              key: const ValueKey<String>('selection-control-focus-ring-false'),
              variant: _forced == false
                  ? ElButtonVariant.secondary
                  : ElButtonVariant.outline,
              size: ElButtonSize.sm,
              onPressed: () => setState(() => _forced = false),
              child: ElText('false (withheld)', ElComponentType.buttonLabel),
            ),
          ],
        ),
        SizedBox(height: el(4)),
        SizedBox(
          width: el(32),
          height: el(32),
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

class _InertVsDisabledPreview extends StatelessWidget {
  const _InertVsDisabledPreview();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Wrap(
      spacing: el(6),
      runSpacing: el(4),
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

  Widget _labelled(ElThemeData theme, String label, Widget child) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      ElText(label, ElType.label, color: theme.mutedForeground),
      SizedBox(height: el(2)),
      SizedBox(width: el(32), height: el(32), child: child),
    ],
  );
}

class _JellyReplayPreview extends StatefulWidget {
  const _JellyReplayPreview();

  @override
  State<_JellyReplayPreview> createState() => _JellyReplayPreviewState();
}

class _JellyReplayPreviewState extends State<_JellyReplayPreview> {
  bool _on = false;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ElButton(
          key: const ValueKey<String>('selection-control-jelly-toggle'),
          variant: ElButtonVariant.outline,
          size: ElButtonSize.sm,
          onPressed: () => setState(() => _on = !_on),
          child: ElText('Toggle', ElComponentType.buttonLabel),
        ),
        SizedBox(height: el(3)),
        SizedBox(
          width: el(32),
          height: el(32),
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

const String _usageCode = '''ElSelectionControl(
  width: el(20),
  height: el(20),
  radius: BorderRadius.circular(ElRadii.sm),
  fill: checked ? theme.primary : theme.background,
  border: checked ? theme.primary : theme.input,
  shadow: checked ? ElShadows.btnPrimary : ElShadows.pressed,
  duration: ElDurations.transitionDefault,
  jellyState: checked,
  onTap: () => setState(() => checked = !checked),
  child: checked ? const ElIcon(ElIconGlyph.check, size: ElIconSize.xs) : const SizedBox(),
)''';

const String _hitAreaCode =
    '''// ElSelectionControl wraps itself in ElHitArea internally: a 20x20
// checkbox-shaped control answers a pointer anywhere inside a 42x34 rect,
// without moving any neighbouring widget.
ElSelectionControl(
  width: el(20),
  height: el(20),
  // ...
)''';

const String _focusRingCode = '''ElSelectionControl(
  // ...
  forceFocusRing: true, // pins the ring open for a static specimen
)''';

const String _inertVsDisabledCode =
    '''// Operable: paints normally, answers taps and Enter/Space.
ElSelectionControl(onTap: () {}, /* ... */)

// Inert: full strength, in the tab order, deaf to input.
ElSelectionControl(inert: true, onTap: null, /* ... */)

// Disabled: 50% opacity, out of the tab order.
ElSelectionControl(enabled: false, onTap: () {}, /* ... */)''';

const String _jellyReplayCode =
    '''// ElSelectionControl threads jellyState into ElJellyReplay internally:
// the squash replays every time this value actually changes.
ElSelectionControl(
  jellyState: checked,
  onTap: () => setState(() => checked = !checked),
  // ...
)''';
