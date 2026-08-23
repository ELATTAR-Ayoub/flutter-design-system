/// Public component documentation for the textarea component.
///
/// `textareaDoc` (from `meta.dart`) is the data source, not
/// `componentDoc('textarea')` — textarea is not yet registered in
/// `catalog.dart`'s `componentDocs` list, so calling that would throw. Adding
/// it there is a supervisor-owned aggregation step (Phase J plan).
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import 'meta.dart';

class TextareaDocPage extends StatelessWidget {
  const TextareaDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    return DocsLayout(
      route: textareaDoc.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / BASE',
        title: textareaDoc.title,
        description: textareaDoc.description,
      ),
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Textarea'),
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
        DocsTocEntry(title: 'Dependencies and files', anchor: 'dependencies'),
        DocsTocEntry(title: 'Composition', anchor: 'composition'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      // Wave 2's alphabetical order (Phase J plan inventory): `button_group
      // combobox field form input_group input_otp native_select radio
      // selection_control slider textarea` — textarea is last, so there is
      // no "next" within the wave. Neither route is registered yet either —
      // the whole chain is stitched together once the supervisor aggregates
      // every meta.dart, the same as this page's own route is not reachable
      // until then.
      previous: const DocsPageLink(
        title: 'Slider',
        route: '/components/slider',
      ),
      onNavigate: onNavigate,
      child: _TextareaArticle(theme: DsTheme.of(context)),
    );
  }
}

class _TextareaArticle extends StatelessWidget {
  const _TextareaArticle({required this.theme});

  final DsThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey<String>('textarea-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsSection(
          id: 'overview',
          title: 'When to use a textarea instead of an input',
          description:
              'What holding more than one line actually changes, and when '
              'a neighbouring control answers the same need better.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DsText(
                'DsTextarea is for a value a user may reasonably want to '
                'spread across more than one line — a comment, a bio, a '
                'shipping note, free-form feedback — and it genuinely grows '
                'with what is typed: there is an 80px floor '
                '(DsTextarea.minHeight) and no ceiling, so the box gets '
                'taller as the value gets longer instead of scrolling or '
                'clipping. Reach for DsInput instead when the value is '
                'naturally one line — an email address, a name, a search '
                'query — even a long one, because DsInput never grows '
                'past its fixed 40px height no matter what is typed into '
                'it; giving it more vertical space would only pad empty '
                'space around a single line, not make it a text area. That '
                'is the real difference between the two controls: it is '
                'not "the same field, taller," it is a different sizing '
                'model entirely — field-sizing: content behaviour with a '
                'floor and no cap, against a fixed single-line height.',
                DsType.body,
              ),
              SizedBox(height: ds(4)),
              DsText(
                'Everything DsTextarea shares with DsInput it shares '
                'exactly — the same border, fill, focus ring and invalid '
                'ring, the same 250ms transition, the same selection wash. '
                'Four things differ, and all four are consequences of '
                'holding more than one line rather than independent '
                'styling choices: the radius drops from the family\'s '
                'usual 999px pill to DsRadii.lg (12px) — a pill\'s radius '
                'is half its height, and half of an 80px field is a 40px '
                'sweep that would swallow the first and last lines of '
                'text, so this is the one control in the family on the '
                'radius ladder rather than the pill curve; the height '
                'floor is 80px with no cap instead of a fixed 40px; the '
                'padding is 14px / 10px instead of 16px / 4px; and the '
                'line height is 1.625 (a 21.125px line box) rather than '
                'inheriting the ambient default, because a multi-line '
                'field needs breathing room between lines that a one-line '
                'field never has to think about. One more difference is '
                'behavioural, not visual: disabling a textarea drops it to '
                '45% opacity but never blocks the pointer, while a '
                'disabled input additionally refuses hit-testing — see '
                'States below for what that means for a reader.',
                DsType.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'status',
          title: 'Status',
          child: DocsInstallFacts(
            title: 'Status',
            facts: <DocsInstallFact>[
              const DocsInstallFact(
                label: 'Status',
                value: 'Stable, not yet a registry item',
                description:
                    'Ported and tested against lib/src/components/textarea.dart. '
                    'It is not yet a registry item, so elattar add textarea '
                    'will not resolve — see Installation below.',
              ),
              DocsInstallFact(
                label: 'Version',
                value: '0.0.1',
                description:
                    'Tracks the package version; there is no registry schema '
                    'version yet because there is no manifest.',
              ),
              const DocsInstallFact(
                label: 'Platforms',
                value: 'Android, iOS, Web, macOS, Windows, Linux',
                description:
                    'A pure Flutter widget tree over EditableText — no '
                    'platform channel and no platform-specific branch.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'preview',
          title: 'Preview',
          description:
              'Six live specimens, all built from the same DsTextarea '
              'constructor. Rest and Focused are real EditableText '
              'instances — type into Rest to try it. Read-only, Disabled '
              'and Auto-grow are seeded with initialValue so their '
              'behaviour is visible without typing.',
          child: DocsCodeExample(
            title: 'Textarea specimens',
            description: 'Every cell below renders a real DsTextarea.',
            preview: const _TextareaPreview(),
            manualFiles: <DocsCodeFile>[
              DocsCodeFile(
                path: textareaDoc.sourcePath,
                code:
                    '// textarea has no registry manifest yet, so there is no\n'
                    '// generated @ui/textarea.dart payload to copy here.\n'
                    '// See "Installation" below for what actually works today.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'install',
          title: 'Installation',
          description:
              'Command install is not available yet — read this before '
              'reaching for elattar add textarea.',
          child: DocsInstallFacts(
            facts: <DocsInstallFact>[
              const DocsInstallFact(
                label: 'CLI',
                value: 'Not available',
                description:
                    'textarea is not yet a registry item, so `elattar add '
                    'textarea` will not resolve. It is one of the Wave 2 '
                    'form and input components still awaiting a manifest — '
                    'see the Phase J documentation plan.',
              ),
              const DocsInstallFact(
                label: 'Manual — package mode (supported today)',
                value:
                    "import 'package:elattar_design_system/elattar_design_system.dart';",
                description:
                    'Depend on the package and use DsTextarea directly, '
                    'exactly as this page does.',
              ),
              DocsInstallFact(
                label: 'Manual — source mode (not recommended yet)',
                value: textareaDoc.sourcePath,
                description:
                    'Copying this one file will not compile on its own — it '
                    'needs field.dart and input.dart with it (see '
                    'Dependencies and files below), and no manifest exists '
                    'yet to resolve them for you.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'usage',
          title: 'Usage',
          description: 'The smallest correct example, then a labelled field.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DsPanel(
                label: 'DART',
                note: 'SMALLEST CORRECT EXAMPLE',
                child: DocsSelectableCodeBlock(code: _smallestUsageCode),
              ),
              SizedBox(height: ds(5)),
              DsText(
                'DsTextarea renders no visible caption of its own — label '
                'only supplies the accessible name. Pair it with DsField '
                'for a visible label, description and error wiring, and '
                'its DsFieldScope threads the label straight through:',
                DsType.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: ds(3)),
              const _ShippingNoteExample(),
              SizedBox(height: ds(3)),
              DsPanel(
                label: 'DART',
                note: 'IN A FIELD',
                child: DocsSelectableCodeBlock(code: _fieldUsageCode),
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'api',
          title: 'API',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DocsApiTable(
                title: 'DsTextarea',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'controller',
                    type: 'TextEditingController?',
                    description:
                        'Controls the value externally. Mutually exclusive '
                        'with initialValue — the constructor asserts '
                        'against supplying both, since a controller already '
                        'carries the value.',
                  ),
                  DocsApiFact(
                    name: 'initialValue',
                    type: 'String?',
                    description:
                        'defaultValue, read once when the field builds its '
                        'own controller for uncontrolled usage.',
                  ),
                  DocsApiFact(
                    name: 'focusNode',
                    type: 'FocusNode?',
                    description:
                        'Overrides the node a DsFieldScope would otherwise '
                        'supply.',
                  ),
                  DocsApiFact(
                    name: 'placeholder',
                    type: 'String?',
                    description:
                        'Shown only while the value is empty, positioned so '
                        'it never contributes to the box\'s height.',
                  ),
                  DocsApiFact(
                    name: 'onChanged',
                    type: 'ValueChanged<String>?',
                    description: 'Called with the full text on every edit.',
                  ),
                  DocsApiFact(
                    name: 'enabled',
                    type: 'bool',
                    description:
                        'Defaults to true. false drops the control to 45% '
                        'opacity and makes it non-editable — but, unlike '
                        'DsInput, does not add pointer-events-none, so it '
                        'still receives the pointer and shows a '
                        '"forbidden" cursor rather than being skipped '
                        'entirely.',
                  ),
                  DocsApiFact(
                    name: 'readOnly',
                    type: 'bool',
                    description:
                        'Defaults to false. true blocks editing while '
                        'keeping full opacity — the field stays focusable '
                        'and its text stays selectable, unlike enabled: '
                        'false.',
                  ),
                  DocsApiFact(
                    name: 'invalid',
                    type: 'bool',
                    description:
                        'Defaults to false. true paints the destructive '
                        'border and ring. ORed with the enclosing '
                        'DsFieldScope\'s own invalid flag, and beats focus '
                        'when both apply.',
                  ),
                  DocsApiFact(
                    name: 'label',
                    type: 'String?',
                    description:
                        'The accessible name. Not rendered as visible text '
                        '— pair with DsField (or DsFieldLabel) for a '
                        'visible caption. Falls back to the enclosing '
                        'DsFieldScope\'s label when omitted.',
                  ),
                  DocsApiFact(
                    name: 'hint',
                    type: 'String?',
                    description:
                        'Read after the label — the aria-describedby '
                        'analogue, resolved through Semantics.hint. Falls '
                        'back to the enclosing DsFieldScope\'s describedBy '
                        'when omitted.',
                  ),
                ],
              ),
              SizedBox(height: ds(5)),
              const DocsApiTable(
                title: 'Static geometry',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'DsTextarea.minHeight',
                    type: 'static double',
                    description:
                        'The 80px floor (min-h-20) the border box never '
                        'shrinks below. There is no matching maximum — '
                        'field-sizing: content grows the box with the '
                        'value and the class list declares no max-h.',
                  ),
                  DocsApiFact(
                    name: 'DsTextarea.insets',
                    type: 'static EdgeInsets',
                    description:
                        'The 14px horizontal / 10px vertical padding '
                        '(px-3.5 py-2.5) paid for from inside the 80px '
                        'floor, along with the 1px border.',
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'variants',
          title: 'Variants and sizes',
          description:
              'Not applicable — recorded rather than silently skipped.',
          child: DsText(
            'DsTextarea has no variant or size parameter — one geometry, '
            'the 80px floor and 12px radius described above, with no '
            'smaller or larger option to choose between. There is also no '
            'rows parameter: the reference passes rows={3} on its own '
            'composed form, but field-sizing: content sizes the box from '
            'its value and min-h-20 is the floor under it, so a row count '
            'would contribute nothing to the rendered height even if it '
            'were exposed — it is dropped rather than ported unused.',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'states',
          title: 'States and feedback',
          description:
              'Hover, Pressed, Selected, Loading, Empty, Success and a '
              'character limit are omitted below — reasons follow the '
              'table.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DocsStateMatrix(
                facts: <DocsStateFact>[
                  DocsStateFact(
                    state: 'Rest',
                    treatment:
                        'theme.card fill, theme.input border, a permanent '
                        'pressed-style shadow — the socket never rises. '
                        'The placeholder (if any) shows only while the '
                        'value is empty and never affects the box height.',
                    userSignal:
                        'An 80px-tall recessed field, growing taller only '
                        'once there is enough text to need it.',
                  ),
                  DocsStateFact(
                    state: 'Focus-visible',
                    treatment:
                        'Border tweens to theme.primary at 50% alpha and a '
                        '3px ring appears at theme.ring 35% alpha, added '
                        'to (not replacing) the socket shadow.',
                    userSignal:
                        'A visible ring around the field — beaten by Error '
                        'below when both apply.',
                  ),
                  DocsStateFact(
                    state: 'Error',
                    treatment:
                        'invalid: true swaps the border and ring to '
                        'theme.destructive, ring at 20% alpha, with no '
                        'dark-mode variant.',
                    userSignal:
                        'aria-invalid beats focus-visible: a focused, '
                        'invalid textarea looks pixel-identical to an '
                        'unfocused invalid one — reproduced faithfully '
                        'from the reference, matching DsInput exactly.',
                  ),
                  DocsStateFact(
                    state: 'Read-only',
                    treatment:
                        'readOnly: true blocks EditableText from '
                        'accepting edits. Opacity, border, fill and shadow '
                        'are all unchanged from Rest.',
                    userSignal:
                        'Looks exactly like an editable field — still '
                        'focusable, still lets a reader select and copy '
                        'the text — only typing has no effect. Distinct '
                        'from Disabled below, which does dim.',
                  ),
                  DocsStateFact(
                    state: 'Disabled',
                    treatment:
                        'enabled: false drops opacity to 45% and forces '
                        'readOnly, but the widget adds no pointer-events '
                        'block of its own — the cursor becomes '
                        '"forbidden" and a tap still lands on the '
                        'GestureDetector underneath.',
                    userSignal:
                        'Visibly dimmed. Reproduced from the reference on '
                        'purpose: unlike DsInput, a disabled textarea is '
                        'not removed from hit-testing, only the cursor and '
                        'the EditableText editability change.',
                  ),
                  DocsStateFact(
                    state: 'Reduced motion',
                    treatment:
                        'The border/ring colour tween (TweenAnimationBuilder '
                        'over DsDurations.transitionDefault) resolves '
                        'through dsAnimationDuration, the same mechanism '
                        'DsInput uses.',
                    userSignal:
                        'The same end colours, with the 250ms cross-fade '
                        'shortened or removed in a reduced-motion context.',
                  ),
                ],
              ),
              SizedBox(height: ds(4)),
              DsText(
                'Omitted: Hover — the class list carries no hover skin of '
                'its own, shared with DsInput; only the pointer cursor '
                'changes (text I-beam when enabled, forbidden when not). '
                'Pressed — a text field has no pressed skin; a tap simply '
                'requests the keyboard. Selected — that state belongs to '
                'choice controls (checkbox, radio); a text primitive has '
                'nothing analogous. Loading and Empty — DsTextarea is a '
                'synchronous primitive with no async operation, and an '
                'empty value is not a distinct visual state, only whether '
                'the placeholder is visible, which Rest above already '
                'covers. Success — the component defines no success '
                'semantics of its own. Character limit — there is no '
                'maxLength, inputFormatters or counter parameter on '
                'DsTextarea; the box has no ceiling to cap against, so '
                'nothing is invented here that the API does not support.',
                DsType.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'accessibility',
          title: 'Accessibility',
          child: DocsInstallFacts(
            title: 'Accessibility',
            facts: <DocsInstallFact>[
              const DocsInstallFact(
                label: 'Semantic role',
                value: 'Semantics(textField: true, multiline: true)',
                description:
                    'Merged in only when label, hint or invalid is set — '
                    'when none of the three apply, the widget wraps '
                    'nothing extra and relies purely on EditableText\'s '
                    'own built-in text-field semantics.',
              ),
              const DocsInstallFact(
                label: 'Label association',
                value: 'label',
                description:
                    'Feeds the control\'s accessible name directly. It is '
                    'never rendered as visible text — compose with DsField '
                    '(or a DsFieldLabel) for a caption a sighted user can '
                    'read.',
              ),
              const DocsInstallFact(
                label: 'Keyboard behavior',
                value: 'Native multi-line text editing',
                description:
                    'Unlike the choice-control family, no key handling is '
                    'wired by hand — EditableText\'s own platform text '
                    'input connection drives everything, so Enter inserts '
                    'a newline rather than doing anything special, and Tab '
                    'moves focus through the ambient FocusTraversalGroup '
                    'like any other focusable node.',
              ),
              const DocsInstallFact(
                label: 'Focus behavior',
                value: 'theme.primary/50 border plus a 3px ring at 35% alpha',
                description:
                    'aria-invalid beats focus-visible at equal '
                    'specificity, reproduced from the reference: a '
                    'focused, invalid textarea shows no visible change '
                    'from an unfocused invalid one.',
              ),
              const DocsInstallFact(
                label: 'Touch target',
                value: 'The full padded surface, minimum 80px tall',
                description:
                    'No separate hit-area widget — unlike DsCheckbox\'s '
                    'DsHitArea, the GestureDetector wraps the entire '
                    'DsFieldSurface, so the tappable region already spans '
                    'the whole field and comfortably clears a touch '
                    'target floor.',
              ),
              const DocsInstallFact(
                label: 'Non-colour signal',
                value: 'None — colour is the only invalid signal',
                description:
                    'Unlike DsCheckbox, which draws a different glyph per '
                    'state, an invalid textarea changes only its border '
                    'and ring colour. A reader who cannot perceive that '
                    'change still gets SemanticsValidationResult.invalid '
                    'through the merged semantics node — recorded as a '
                    'real limitation, not fixed silently.',
              ),
              const DocsInstallFact(
                label: 'Error wiring',
                value: 'invalid, ORed with the enclosing DsFieldScope',
                description:
                    'A DsField around the control folds its own invalid '
                    'flag in, and colours the field\'s text with '
                    'theme.destructiveInk when either is true.',
              ),
              const DocsInstallFact(
                label: 'Screen-reader announcements',
                value: 'No live region',
                description:
                    'State changes are exposed purely through the merged '
                    'semantics node\'s flags (when present); no extra '
                    'announcement is authored.',
              ),
              const DocsInstallFact(
                label: 'Known platform differences',
                value: 'None',
                description:
                    'EditableText\'s own IME and platform text-input '
                    'handling is uniform across every Flutter target this '
                    'package supports; keyboardType is '
                    'TextInputType.multiline everywhere.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'responsive',
          title: 'Responsive and platform behavior',
          child: DsText(
            'DsTextarea has no responsive breakpoints of its own: its '
            'width comes from the ambient constraints (it fills whatever '
            'box it is given) and its height grows from an 80px floor with '
            'no cap, identical across mobile, tablet, desktop and web. The '
            'one platform-shaped behaviour it does carry is '
            'DsFieldVisibility, shared with the rest of the field family — '
            'a focused textarea is kept clear of the software keyboard, '
            'gated purely on MediaQuery.viewInsets.bottom > 0, so a '
            'desktop or web build where no software keyboard ever opens '
            'renders byte-identical to one without the wrapper at all.',
            DsType.small,
            color: theme.mutedForeground,
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'dependencies',
          title: 'Dependencies, files, assets, fonts and shaders',
          child: DocsInstallFacts(
            title: 'Dependencies and files',
            facts: <DocsInstallFact>[
              DocsInstallFact(
                label: 'Source file',
                value: textareaDoc.sourcePath,
                description: 'The authoritative implementation.',
              ),
              const DocsInstallFact(
                label: 'Local file dependencies',
                value: 'field.dart, input.dart',
                description:
                    'textarea.dart imports these directly: field.dart for '
                    'DsFieldScope wiring, and input.dart for '
                    'DsFieldSurface (the shared socket surface) and '
                    'DsFieldVisibility (the shared mobile keyboard-'
                    'avoidance wrapper) — deliberately reused rather than '
                    'duplicated, so the textarea cannot drift from the '
                    'input. Neither file is copyable in isolation — see '
                    'Installation.',
              ),
              const DocsInstallFact(
                label: 'Foundation dependencies',
                value:
                    'foundation/spacing.dart, foundation/theme.dart, '
                    'foundation/typography.dart, theme_scope.dart',
                description:
                    'Token sources: the ds() spacing scale and DsRadii, '
                    'the live theme, DsText/DsComponentType.textareaBody, '
                    'and the theme scope.',
              ),
              DocsInstallFact(
                label: 'Exports',
                value: textareaDoc.exports.join(', '),
                description:
                    'The public symbols this component makes available.',
              ),
              const DocsInstallFact(
                label: 'Assets',
                value: 'none',
                description:
                    'The field surface is drawn by DsMachineSurface (via '
                    'DsFieldSurface); there is no image or icon-font glyph.',
              ),
              const DocsInstallFact(
                label: 'Fonts',
                value: 'none of its own',
                description:
                    'Text renders through DsComponentType.textareaBody, the '
                    'app\'s own type scale — no font file is bundled by '
                    'this component.',
              ),
              const DocsInstallFact(
                label: 'Shaders',
                value: 'none',
                description: 'No fragment shader is used.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'composition',
          title: 'Composition examples',
          description:
              'Two larger, real patterns built from the same constructor — '
              'not manufactured examples the Dart API cannot support.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DsPanel(
                label: 'DART',
                note: 'FIELD WITH AN ERROR',
                child: DocsSelectableCodeBlock(code: _fieldErrorCode),
              ),
              SizedBox(height: ds(5)),
              DsPanel(
                label: 'DART',
                note: 'CONTROLLED DRAFT',
                child: DocsSelectableCodeBlock(code: _controlledDraftCode),
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'theming',
          title: 'Theming notes',
          child: DocsInstallFacts(
            title: 'Tokens this component reads',
            facts: const <DocsInstallFact>[
              DocsInstallFact(
                label: 'Fill',
                value: 'theme.card',
                description: 'Socket background, in every state.',
              ),
              DocsInstallFact(
                label: 'Border',
                value:
                    'theme.input (rest) / theme.primary at 50% alpha '
                    '(focus-visible) / theme.destructive (invalid)',
                description:
                    'Resolved in that precedence order — invalid always '
                    'wins, exactly as on DsInput.',
              ),
              DocsInstallFact(
                label: 'Ring',
                value:
                    'transparent (rest) / theme.ring at 35% alpha (focus) '
                    '/ theme.destructive at 20% alpha (invalid)',
                description: 'Added to the socket shadow, never replacing it.',
              ),
              DocsInstallFact(
                label: 'Text and cursor',
                value:
                    'DsComponentType.textareaBody / theme.foreground '
                    '(cursor) / theme.mutedForeground (placeholder, '
                    'background cursor)',
                description:
                    'The typed text inherits whatever colour Field applies '
                    '— including invalid ink — because the style carries '
                    'no colour of its own.',
              ),
              DocsInstallFact(
                label: 'Selection wash',
                value: 'theme.primary at 35% alpha',
                description:
                    'DsFieldSurface.selectionAlpha — shared exactly with '
                    'DsInput so the two fields cannot select differently '
                    'from one another.',
              ),
              DocsInstallFact(
                label: 'Shadow',
                value:
                    'DsShadows.pressed, composed with the focus/invalid ring',
                description:
                    'The permanent recessed-socket shadow; never replaced, '
                    'only ever added to.',
              ),
              DocsInstallFact(
                label: 'Radius',
                value: 'DsRadii.lg (12px)',
                description:
                    'The one member of the field family on the radius '
                    'ladder rather than the 999px pill curve — see '
                    'Overview for why.',
              ),
              DocsInstallFact(
                label: 'Motion',
                value: 'DsDurations.transitionDefault via dsAnimationDuration',
                description:
                    'Drives the border/ring colour tween; a reduced-motion '
                    'context shortens or removes it automatically, the '
                    'same mechanism DsInput uses.',
              ),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        DsSection(
          id: 'source',
          title: 'Source and tests',
          child: DocsInstallFacts(
            facts: <DocsInstallFact>[
              DocsInstallFact(
                label: 'Component source',
                value: textareaDoc.sourcePath,
                description: 'Authoritative implementation.',
              ),
              const DocsInstallFact(
                label: 'Shared machinery',
                value: 'lib/src/components/input.dart',
                description:
                    'DsFieldSurface and DsFieldVisibility — shared with '
                    'DsInput and documented on its own component page.',
              ),
              const DocsInstallFact(
                label: 'Package tests',
                value: 'test/inputs_test.dart',
                description:
                    'The "DsTextarea" group covers geometry, growth and the '
                    'disabled state for DsTextarea in the package itself.',
              ),
              const DocsInstallFact(
                label: 'Docs page tests',
                value: 'example/test/components_docs/textarea_test.dart',
                description:
                    'Coverage for this page: API completeness, the live '
                    'specimen accepting typed text, and both themes.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

const String _smallestUsageCode = '''String feedback = '';

DsTextarea(
  label: 'Feedback',
  placeholder: 'Tell us what happened…',
  onChanged: (String next) => setState(() => feedback = next),
)''';

const String _fieldUsageCode = '''DsField(
  label: 'Shipping note',
  description: 'Grows as you type. Minimum height is 80px.',
  child: const DsTextarea(
    placeholder: 'Anything the packing team should know',
  ),
)''';

const String _fieldErrorCode = '''DsField(
  label: 'Feedback',
  errors: const <String>['Please provide at least 20 characters.'],
  invalid: true,
  child: DsTextarea(
    initialValue: 'Too short',
    invalid: true,
  ),
)''';

const String _controlledDraftCode =
    '''// draftController is created once and disposed with its owner.
final TextEditingController draftController = TextEditingController();

DsField(
  label: 'Draft',
  description: 'Autosaved locally while you type.',
  child: DsTextarea(
    controller: draftController,
    onChanged: (String next) => autosave(next),
  ),
)''';

/// The six-cell live specimen grid for the "Preview" section.
class _TextareaPreview extends StatefulWidget {
  const _TextareaPreview();

  @override
  State<_TextareaPreview> createState() => _TextareaPreviewState();
}

class _TextareaPreviewState extends State<_TextareaPreview> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: ds(3),
      runSpacing: ds(3),
      children: <Widget>[
        const DsStateCell(
          label: 'Rest',
          note: 'Type to try it',
          child: DsTextarea(
            key: ValueKey<String>('textarea-live-specimen'),
            label: 'Rest',
            placeholder: 'Type here to try it',
          ),
        ),
        DsStateCell(
          label: 'Focus-visible',
          note: 'Actually focused, not forced',
          child: DsTextarea(
            focusNode: _focusNode,
            label: 'Focus-visible',
            placeholder: 'Focused on mount',
          ),
        ),
        const DsStateCell(
          label: 'Error',
          note: 'invalid: true',
          child: DsTextarea(
            initialValue: 'Too short',
            invalid: true,
            label: 'Error',
          ),
        ),
        const DsStateCell(
          label: 'Read-only',
          note: 'Focusable and selectable, not editable',
          child: DsTextarea(
            initialValue: '0xA71c…4F2b delivered 2 days ago.',
            readOnly: true,
            label: 'Read-only',
          ),
        ),
        const DsStateCell(
          label: 'Disabled',
          note: 'Dims, but the pointer still lands',
          child: DsTextarea(
            initialValue: 'Cannot be edited right now.',
            enabled: false,
            label: 'Disabled',
          ),
        ),
        const DsStateCell(
          label: 'Auto-grow',
          note: 'No max height — the value decides',
          child: DsTextarea(
            initialValue:
                'Line one\nLine two\nLine three\nLine four grows the box '
                'past the 80px floor.',
            label: 'Auto-grow',
          ),
        ),
      ],
    );
  }
}

/// A live, functioning `DsField`-wrapped textarea for the "Usage" section —
/// proof the composition it documents actually renders and accepts typed
/// text, not just a code excerpt.
class _ShippingNoteExample extends StatelessWidget {
  const _ShippingNoteExample();

  @override
  Widget build(BuildContext context) {
    return DsField(
      label: 'Shipping note',
      description: 'Grows as you type. Minimum height is 80px.',
      child: const DsTextarea(
        placeholder: 'Anything the packing team should know',
      ),
    );
  }
}
