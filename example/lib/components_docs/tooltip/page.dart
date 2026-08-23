/// Public component documentation for the tooltip component.
///
/// `tooltip` is Wave 1 of the component-documentation plan, and — unlike
/// most of its Wave 1 siblings — already carries a real
/// `registry/components/tooltip.json` manifest, so the Installation section
/// below renders the genuine `elattar add tooltip` command rather than a
/// "not available yet" disclosure.
///
/// The eighteen IA §9.1 sections map onto this page as: breadcrumb/family
/// comes from the eyebrow and [DocsLayout.breadcrumbs]; title and short
/// description come from [DocsLayout] itself; the expanded "when to use
/// this instead of a neighbour" guidance is [tooltipExpandedDescription];
/// status, preview, installation, usage, API, variants, states,
/// accessibility, responsive behaviour, the install-facts disclosure, a
/// composition example, theming notes, and source/tests each get their own
/// [DsSection]; previous/next comes from [DocsLayout] again.
///
/// Two corrections against the task brief, both resolved in favour of the
/// real source (`lib/src/components/tooltip.dart`), which is the documented
/// source of truth here:
///
///  * The touch path is a **tap**, not a long press — [DsTooltip] opens on
///    a `PointerDownEvent`, immediately, with no dwell. The Responsive
///    section below documents this as measured from the source, not as the
///    brief's assumption.
///  * The component wires **no `Semantics`** anywhere in its source — no
///    `Semantics(tooltip: ...)`, no accessible-name propagation to the
///    trigger. When a tooltip is a control's only label (the collapsed
///    sidebar-rail row the source's own top-of-file comment names), that is
///    a real accessibility failure. The Accessibility section says so
///    plainly, per the task brief's own instruction to document exactly
///    this.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import '../catalog.dart';
import 'meta.dart';

class TooltipDocPage extends StatelessWidget {
  const TooltipDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ComponentDocEntry entry = tooltipDoc;
    return DocsLayout(
      route: entry.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / BASE',
        title: entry.title,
        description: tooltipExpandedDescription,
      ),
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Tooltip'),
      ],
      sidebar: const <DocsSidebarEntry>[
        DocsSidebarEntry(title: 'Toggle', route: '/components/toggle'),
        DocsSidebarEntry(
          title: 'Tooltip',
          route: '/components/tooltip',
          selected: true,
        ),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Status', anchor: 'status'),
        DocsTocEntry(title: 'Preview', anchor: 'preview'),
        DocsTocEntry(title: 'Install', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'API', anchor: 'api'),
        DocsTocEntry(title: 'Variants', anchor: 'variants'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      previous: const DocsPageLink(
        title: 'Toggle',
        route: '/components/toggle',
      ),
      // tooltip is the last entry in Wave 1's own list — nothing to link
      // forward to yet.
      onNavigate: onNavigate,
      child: _TooltipArticle(entry: entry),
    );
  }
}

class _TooltipArticle extends StatelessWidget {
  const _TooltipArticle({required this.entry});

  final ComponentDocEntry entry;

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('tooltip-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DsSection(
        id: 'status',
        title: 'Status',
        child: const DocsInstallFacts(
          title: 'Status',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Status',
              value: 'Stable — registered in the registry',
              description:
                  'DsTooltip, DsTooltipSide, and DsTooltipContent are all '
                  'exported from the public barrel and installable through '
                  'the CLI today.',
            ),
            DocsInstallFact(
              label: 'Version',
              value: '0.0.1',
              description: "The registry manifest's own version field.",
            ),
            DocsInstallFact(
              label: 'Dart / Flutter',
              value: '>=3.12.2 <4.0.0 / >=3.44.8',
              description: "The manifest's minDart and minFlutter constraints.",
            ),
            DocsInstallFact(
              label: 'Platforms',
              value: 'Android, iOS, Web, macOS, Windows, Linux',
              description:
                  'Pure widget composition — nothing here is platform-gated.',
            ),
          ],
        ),
      ),
      DsSection(
        id: 'preview',
        title: 'Preview',
        description:
            'A pointer resting on a trigger for 200ms opens the label; a '
            'finger opens it on the spot with a single tap, no dwell. Both '
            'paths close automatically — hover on pointer-exit, touch on a '
            'second tap, a tap elsewhere, or after a 1.5s dwell if nothing '
            'else closes it first.',
        child: DocsCodeExample(
          title: 'Tooltip specimens',
          description:
              'Hover a trigger with a mouse, or tap one on a touch device.',
          preview: const _TooltipPreview(),
          command: DocsCodeCommand(command: entry.command),
        ),
      ),
      DsSection(
        id: 'install',
        title: 'Installation',
        description:
            'tooltip already has a registry manifest — this installs '
            'lib/src/components/tooltip.dart and its one dependency, '
            'source-foundation, resolved automatically.',
        child: DocsCodeExample(
          title: 'Installation',
          command: DocsCodeCommand(
            command: entry.command,
            description:
                'Installs tooltip.dart and resolves source-foundation '
                'automatically.',
          ),
          manualFiles: const <DocsCodeFile>[
            DocsCodeFile(
              path: 'lib/components/ui/tooltip.dart',
              code:
                  "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
                  '// Copy the generated tooltip source here when using '
                  'manual mode.',
            ),
          ],
        ),
      ),
      DsSection(
        id: 'usage',
        title: 'Usage',
        description:
            'The smallest correct composition, then the two real shapes '
            'this component ships for: a collapsed sidebar rail row, and '
            'the hidden flag that keeps hover behavior alive without '
            'painting anything.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsPanel(
              label: 'DART',
              note: 'MINIMAL',
              child: DocsSelectableCodeBlock(code: _usageBasicCode),
            ),
            SizedBox(height: ds(5)),
            DsPanel(
              label: 'DART',
              note: 'COLLAPSED RAIL',
              child: DocsSelectableCodeBlock(code: _usageRightSideCode),
            ),
            SizedBox(height: ds(5)),
            DsPanel(
              label: 'DART',
              note: 'HIDDEN',
              child: DocsSelectableCodeBlock(code: _usageHiddenCode),
            ),
          ],
        ),
      ),
      DsSection(
        id: 'api',
        title: 'API',
        description:
            'Every public class, constructor parameter, and static layout '
            'constant the source declares.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const DocsApiTable(
              title: 'DsTooltip',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'label',
                  type: 'String',
                  description:
                      'Required. The content — a short line of text, not a '
                      'place for rich or interactive content.',
                ),
                DocsApiFact(
                  name: 'child',
                  type: 'Widget',
                  description:
                      'Required. The trigger, rendered verbatim '
                      '(TooltipTrigger asChild).',
                ),
                DocsApiFact(
                  name: 'delay',
                  type: 'Duration',
                  description:
                      'Default DsDurations.tooltipDelay (200ms). '
                      'Hover-intent delay before a pointer-opened label '
                      'shows; a tap has no dwell and ignores this.',
                ),
                DocsApiFact(
                  name: 'side',
                  type: 'DsTooltipSide',
                  description:
                      'Default DsTooltipSide.top. Which edge of the '
                      'trigger the content sits on.',
                ),
                DocsApiFact(
                  name: 'hidden',
                  type: 'bool',
                  description:
                      "Default false. Keeps the trigger's hover and tap "
                      'behavior but renders nothing — mirrors a collapsed '
                      'SidebarMenuButton.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsTooltipContent',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'label',
                  type: 'String',
                  description: 'Required. The text the pill renders.',
                ),
                DocsApiFact(
                  name: 'side',
                  type: 'DsTooltipSide',
                  description:
                      'Default DsTooltipSide.top. Which edge the arrow '
                      'lane sits on relative to the pill.',
                ),
              ],
            ),
          ],
        ),
      ),
      DsSection(
        id: 'variants',
        title: 'Variants',
        description:
            'DsTooltipSide is the only variant knob on this component — '
            'there is no size or color variant to choose.',
        child: const DocsApiTable(
          title: 'DsTooltipSide',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'top',
              type: 'DsTooltipSide',
              description:
                  'The default. Content sits above the trigger, centered, '
                  "with the arrow lane below it — the reference's own "
                  'measured shape.',
            ),
            DocsApiFact(
              name: 'right',
              type: 'DsTooltipSide',
              description:
                  "Content sits to the trigger's right, vertically "
                  'centered, arrow lane on its left — the shape a '
                  'collapsed sidebar rail row needs when it has no other '
                  'label.',
            ),
          ],
        ),
      ),
      DsSection(
        id: 'states',
        title: 'States and feedback',
        description:
            'Rows that do not apply to this pointer/touch-driven, '
            'variant-free primitive are marked N/A with the reason, rather '
            'than invented.',
        child: const DocsStateMatrix(
          facts: <DocsStateFact>[
            DocsStateFact(
              state: 'Rest',
              treatment:
                  'The overlay child is not mounted; only child renders, '
                  'untouched.',
              userSignal: 'Nothing besides the trigger itself is on screen.',
            ),
            DocsStateFact(
              state: 'Hover',
              treatment:
                  'A pointer (any PointerDeviceKind other than touch) '
                  'resting on the trigger for delay (200ms default) opens '
                  'the label with a 320ms fade, 8px slide, and zoom.',
              userSignal:
                  'The pill appears on side, arrow pointing at the '
                  'trigger.',
            ),
            DocsStateFact(
              state: 'Focus-visible',
              treatment:
                  'N/A — the source wires no Focus or FocusNode; opening '
                  'is driven only by pointer hover and touch taps, never '
                  'by keyboard focus.',
              userSignal: 'N/A — see Accessibility below.',
            ),
            DocsStateFact(
              state: 'Pressed',
              treatment:
                  'On a touch pointer, PointerDownEvent toggles the label '
                  "open or closed immediately, watched via a Listener so "
                  "the trigger's own press or tap still fires too.",
              userSignal: 'Label appears or disappears instantly, no dwell.',
            ),
            DocsStateFact(
              state: 'Selected',
              treatment:
                  'N/A — a tooltip is either showing or not; there is no '
                  'selection concept to represent.',
              userSignal: 'N/A',
            ),
            DocsStateFact(
              state: 'Loading',
              treatment: 'N/A — label is static text with no async step.',
              userSignal: 'N/A',
            ),
            DocsStateFact(
              state: 'Empty',
              treatment:
                  'N/A — label is a required String; the API has no path '
                  'to an empty label to design for.',
              userSignal: 'N/A',
            ),
            DocsStateFact(
              state: 'Error',
              treatment:
                  'N/A — no validation or error state exists on this '
                  'component.',
              userSignal: 'N/A',
            ),
            DocsStateFact(
              state: 'Success',
              treatment: 'N/A — no async outcome to confirm.',
              userSignal: 'N/A',
            ),
            DocsStateFact(
              state: 'Disabled',
              treatment:
                  'N/A — DsTooltip has no enabled or disabled parameter of '
                  'its own; a caller wraps whatever trigger it likes, '
                  'including a disabled one, and the label still opens.',
              userSignal: 'N/A',
            ),
            DocsStateFact(
              state: 'Reduced motion',
              treatment:
                  'The 320ms fade, zoom, and slide-in transition runs '
                  'through dsAnimationDuration, so it collapses under '
                  'reduced motion. The 200ms hover delay and 1500ms '
                  'touchDwell are timing, not motion, and are unaffected.',
              userSignal:
                  'The label still appears and disappears, just without '
                  'animated travel.',
            ),
          ],
        ),
      ),
      DsSection(
        id: 'accessibility',
        title: 'Accessibility and keyboard behavior',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsPanel(
              label: 'What the semantics tree actually carries',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _A11yRow(
                    'Semantic role',
                    'DsTooltip renders no Semantics node of its own '
                        'anywhere in its source — not on the trigger, not '
                        'on the pill, and nothing wires the label into the '
                        "accessible name of whatever child it wraps.",
                  ),
                  const _A11yRow(
                    'Required labels',
                    'None are set automatically. If a trigger has no '
                        'other accessible name of its own (no visible '
                        'text, no Semantics label, no DsButton.label), the '
                        'tooltip does not supply one either.',
                  ),
                  const _A11yRow(
                    'Keyboard interactions',
                    'None. There is no Focus or FocusNode in the source, '
                        'so Tab-ing to the trigger never shows the label, '
                        'and there is no Escape-to-close path — dismissal '
                        'is pointer and touch only.',
                  ),
                  const _A11yRow(
                    'Focus behavior',
                    'Nothing to describe beyond Keyboard above — the '
                        'tooltip itself never receives focus and never '
                        'moves it.',
                  ),
                  const _A11yRow(
                    'Touch target',
                    'DsTooltip adds no padding of its own; the tap target '
                        "is whatever the wrapped trigger already provides "
                        '(a DsButton icon size, for example).',
                  ),
                  const _A11yRow(
                    'Non-color signal',
                    'The label is plain text on a solid pill — no '
                        'information is carried by color alone.',
                  ),
                  const _A11yRow(
                    'Error wiring',
                    'None — DsTooltip never participates in form '
                        'validation or an error state.',
                  ),
                  const _A11yRow(
                    'Screen-reader announcements',
                    'None. Opening or closing the overlay announces '
                        'nothing; a screen-reader user has no signal that '
                        'a label ever appeared.',
                  ),
                  _A11yRow(
                    'Known platform differences',
                    'None observed in the paint or gesture logic — '
                        'routing is by PointerDeviceKind, not by platform.',
                    last: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: ds(5)),
            DsNote(
              tone: DsNoteTone.error,
              title: "Known gap — a tooltip cannot be a control's only name",
              child: DsText(
                'The source itself composes exactly the risky case: a '
                "SidebarMenuButton-style collapsed rail row, where the "
                "tooltip's label is used as the only name a control has "
                "once its own visible text has collapsed away. A sighted "
                'mouse user gets the name after a 200ms hover; a touch '
                'user gets it after a tap; a screen-reader or '
                'keyboard-only user gets nothing — the control has no '
                'accessible name at all in that state. If a trigger has '
                'no other name, pair the tooltip label with a real '
                'accessible name on the trigger itself (for example '
                'DsButton.label) — do not rely on the tooltip alone to '
                'supply it.',
                DsType.small,
              ),
            ),
          ],
        ),
      ),
      DsSection(
        id: 'responsive',
        title: 'Responsive and platform behavior',
        description:
            "Routed on the event's own PointerDeviceKind, never on the "
            'platform — a hybrid machine gets both paths at once, and '
            'each pointer is judged as it arrives.',
        child: DsPanel(
          label: 'Pointer versus touch',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(
                'Pointer (mouse, a stylus hovering): resting on the '
                'trigger for delay (200ms default, '
                'DsDurations.tooltipDelay) opens the label; the pointer '
                'leaving the trigger closes it.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'Touch: this is a tap, not a long press. A single tap on '
                'the trigger opens the label immediately, with no dwell — '
                'delayDuration is a hover-intent filter, and a tap has '
                'already declared its intent. A second tap on the same '
                'trigger closes it. A tap anywhere else also closes it, '
                'through a translucent barrier that observes the pointer '
                'without stealing it, so the dismissing tap still reaches '
                'whatever it landed on.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'If nothing else closes it first, a tap-opened label '
                'takes itself down automatically after '
                'DsTooltip.touchDwell (1500ms — ten steps of '
                'DsDurations.fast) so it can never be stranded on screen.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'This is a deliberate mobile adaptation ordered on top of '
                'a reference that has no touch path of its own — hover '
                'does not exist on a touch screen. It is documented in '
                "the source's own top-of-file comment.",
                DsType.small,
              ),
            ],
          ),
        ),
      ),
      DsSection(
        id: 'dependencies',
        title: 'Dependencies, files, and disclosure',
        description:
            "Elattar's own technical-transparency panel — what this "
            'component needs to install and run.',
        child: DocsInstallFacts(
          facts: <DocsInstallFact>[
            const DocsInstallFact(
              label: 'Registry item',
              value: 'tooltip',
              description:
                  'registry/components/tooltip.json exists and is '
                  'installable through the CLI today.',
            ),
            const DocsInstallFact(
              label: 'Destination',
              value: 'lib/components/ui/tooltip.dart',
              description:
                  'The same lib/components/ui/ target every component '
                  'installs to, in both foundation modes.',
            ),
            const DocsInstallFact(
              label: 'Foundation',
              value: 'source or package compatible',
              description:
                  'The manifest names only source-foundation — nothing '
                  'here is package-mode-only.',
            ),
            DocsInstallFact(
              label: 'Dependencies',
              value: entry.dependencies.join(', '),
              description:
                  "The manifest's registryDependencies, resolved "
                  'automatically by the registry client.',
            ),
            const DocsInstallFact(
              label: 'Assets',
              value: 'none',
              description: 'No image, font, or shader asset is referenced.',
            ),
            const DocsInstallFact(
              label: 'Shaders',
              value: 'none',
              description: 'Not applicable.',
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
                  "test/dialogs_test.dart's DsTooltip and "
                  "'DsTooltip — the tap path' groups, plus this page's "
                  'own live specimens. No fixture install was run as part '
                  'of writing this page.',
            ),
          ],
        ),
      ),
      DsSection(
        id: 'composition',
        title: 'Composition example',
        description:
            'A toolbar row above a list — the shape the two icon-only '
            "actions in the Preview section actually come from, in the "
            'reference dialogs page.',
        child: const DocsCodeExample(
          title: 'Toolbar composition',
          preview: _TooltipComposition(),
        ),
      ),
      DsSection(
        id: 'theming',
        title: 'Theming notes',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsPanel(
              label: 'What actually varies with the theme',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DsText(
                    'The pill is a fixed, inverted pairing — '
                    'theme.foreground fill, theme.background ink — the '
                    'same relationship a native OS tooltip uses, and it '
                    'does not change with a surface or variant parameter '
                    'because DsTooltip has none.',
                    DsType.small,
                  ),
                  SizedBox(height: ds(3)),
                  DsText(
                    'The label always renders at '
                    'DsComponentType.tooltipLabel (12px, weight 400) and '
                    'the pill corner radius is always DsRadii.md — '
                    'neither is configurable per instance.',
                    DsType.small,
                  ),
                  SizedBox(height: ds(3)),
                  DsText(
                    'The arrow is painted, not composed, and always fills '
                    'with theme.foreground to match the pill exactly, so '
                    'it never reads as a separate shape in either theme.',
                    DsType.small,
                  ),
                ],
              ),
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'Layout tokens',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'arrowSize',
                  type: 'static double (get)',
                  description:
                      "size-2.5, ~10px — the arrow's square before its "
                      '45° turn.',
                ),
                DocsApiFact(
                  name: 'arrowRadius',
                  type: 'static double (get)',
                  description:
                      'rounded-xs corner radius on the arrow, DsRadii.xs.',
                ),
                DocsApiFact(
                  name: 'arrowLift',
                  type: 'static double (get)',
                  description:
                      "How far the arrow's centre is pushed out of its "
                      'lane: half the arrow plus DsRadii.xs.',
                ),
                DocsApiFact(
                  name: 'horizontalPadding',
                  type: 'static double (get)',
                  description: "px-3 — the pill's horizontal padding.",
                ),
                DocsApiFact(
                  name: 'verticalPadding',
                  type: 'static double (get)',
                  description: "py-1.5 — the pill's vertical padding.",
                ),
                DocsApiFact(
                  name: 'slide',
                  type: 'static double (get)',
                  description:
                      'slide-in-from-bottom-2 — the entrance travel '
                      'distance, toward the trigger.',
                ),
                DocsApiFact(
                  name: 'touchDwell',
                  type: 'static Duration (get)',
                  description:
                      '1500ms (ten steps of DsDurations.fast) — how long '
                      'a tap-opened label stays up on its own before it '
                      'closes itself.',
                ),
              ],
            ),
          ],
        ),
      ),
      DsSection(
        id: 'source',
        title: 'Source and tests',
        child: DocsInstallFacts(
          title: 'Source and tests',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Source',
              value: entry.sourcePath,
              description: 'The authoritative package source.',
            ),
            const DocsInstallFact(
              label: 'GitHub',
              value:
                  'github.com/ELATTAR-Ayoub/flutter-design-system/blob/'
                  'main/lib/src/components/tooltip.dart',
              description: "The registry manifest's own sourceLink, verbatim.",
            ),
            const DocsInstallFact(
              label: 'Tests',
              value:
                  'test/dialogs_test.dart (DsTooltip, DsTooltip — the '
                  'tap path)',
              description:
                  'Package-level behavioral coverage: geometry, the '
                  'hover-delay contract, and the full tap-path dismissal '
                  'rules.',
            ),
            const DocsInstallFact(
              label: 'Docs specimen',
              value: 'example/test/components_docs/tooltip_test.dart',
              description:
                  "This page's own responsive, theme, API-completeness, "
                  'and live hover/tap coverage.',
            ),
          ],
        ),
      ),
    ],
  );
}

const String _usageBasicCode =
    '''import 'package:elattar_design_system/elattar_design_system.dart';

DsTooltip(
  label: 'Add to favourites',
  child: DsButton(
    variant: DsButtonVariant.ghost,
    size: DsButtonSize.icon,
    label: 'Add to favourites',
    onPressed: () {},
    child: const DsIcon(DsIconGlyph.heart, size: DsIconSize.md),
  ),
)''';

const String _usageRightSideCode = '''DsTooltip(
  label: 'Dashboard',
  side: DsTooltipSide.right,
  child: DsButton(
    variant: DsButtonVariant.ghost,
    size: DsButtonSize.icon,
    label: 'Dashboard',
    onPressed: () {},
    child: const DsIcon(DsIconGlyph.layoutGrid, size: DsIconSize.md),
  ),
)''';

const String _usageHiddenCode =
    '''// SidebarMenuButton's own pattern: every row stays wrapped in a
// DsTooltip from the start, and `hidden` only turns false once the panel
// has collapsed to a rail and the row's own text label has gone.
DsTooltip(
  label: 'Dashboard',
  side: DsTooltipSide.right,
  hidden: !collapsed,
  child: sidebarRow,
)''';

class _A11yRow extends StatelessWidget {
  const _A11yRow(this.label, this.body, {this.last = false});

  final String label;
  final String body;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : ds(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DsText(label, DsType.label, color: theme.actionInk),
          SizedBox(height: ds(1)),
          DsText(body, DsType.small),
        ],
      ),
    );
  }
}

/// The live specimen: a hover-driven top-side pair, and the right-side,
/// collapsed-rail shape — both real compositions from the reference
/// dialogs page, not invented ones.
class _TooltipPreview extends StatelessWidget {
  const _TooltipPreview();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsText('Top side — the default', DsType.label),
        SizedBox(height: ds(3)),
        Wrap(
          spacing: ds(4),
          runSpacing: ds(4),
          children: <Widget>[
            DsTooltip(
              key: const ValueKey<String>('tooltip-doc-specimen-top'),
              label: 'Add to favourites',
              child: DsButton(
                variant: DsButtonVariant.ghost,
                size: DsButtonSize.icon,
                label: 'Add to favourites',
                onPressed: () {},
                child: const DsIcon(DsIconGlyph.heart, size: DsIconSize.md),
              ),
            ),
            DsTooltip(
              label: 'Settings',
              child: DsButton(
                variant: DsButtonVariant.ghost,
                size: DsButtonSize.icon,
                label: 'Settings',
                onPressed: () {},
                child: const DsIcon(DsIconGlyph.settings, size: DsIconSize.md),
              ),
            ),
          ],
        ),
        SizedBox(height: ds(6)),
        DsText("Right side — a collapsed rail row's only label", DsType.label),
        SizedBox(height: ds(3)),
        DsTooltip(
          key: const ValueKey<String>('tooltip-doc-specimen-right'),
          label: 'Dashboard',
          side: DsTooltipSide.right,
          child: DsButton(
            variant: DsButtonVariant.ghost,
            size: DsButtonSize.icon,
            label: 'Dashboard',
            onPressed: () {},
            child: const DsIcon(DsIconGlyph.layoutGrid, size: DsIconSize.md),
          ),
        ),
        SizedBox(height: ds(6)),
        DsText(
          'A mouse resting on either trigger for 200ms opens the label; a '
          'finger opens it on the spot with a single tap, no dwell.',
          DsType.small,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

/// A realistic toolbar row — the exact icon/label pairing the reference
/// dialogs page composes above a pack list.
class _TooltipComposition extends StatelessWidget {
  const _TooltipComposition();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: DsText(
            'Autumn Collection',
            DsType.h4,
            color: theme.foreground,
          ),
        ),
        SizedBox(width: ds(3)),
        Wrap(
          spacing: ds(2),
          children: <Widget>[
            DsTooltip(
              label: 'Add to favourites',
              child: DsButton(
                variant: DsButtonVariant.ghost,
                size: DsButtonSize.icon,
                label: 'Add to favourites',
                onPressed: () {},
                child: const DsIcon(DsIconGlyph.heart, size: DsIconSize.md),
              ),
            ),
            DsTooltip(
              label: 'Filter and sort',
              child: DsButton(
                variant: DsButtonVariant.ghost,
                size: DsButtonSize.icon,
                label: 'Filters',
                onPressed: () {},
                child: const DsIcon(
                  DsIconGlyph.slidersHorizontal,
                  size: DsIconSize.md,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
