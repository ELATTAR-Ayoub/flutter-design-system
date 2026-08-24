/// Public component documentation for the textarea component.
///
/// `textareaDoc` (from `meta.dart`) is the data source, not
/// `componentDoc('textarea')`; this page keeps its typed metadata import.
///
/// Section shape mirrors https://ui.shadcn.com/docs/components/base/textarea:
/// Preview, Installation, Usage, then that page's own literal sections
/// (Field, Disabled, Invalid, Button, RTL) in their order, one section this
/// page has that theirs does not (Textarea vs. input), an API Reference this
/// page adds because ElTextarea has documentable props even though the
/// counterpart page carries none, and finally the six sections shadcn does
/// not have at all (States, Accessibility, Responsive, Dependencies,
/// Theming, Source).
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
      breadcrumbs: const <ElBreadcrumbEntry>[
        ElBreadcrumbEntry.link('Components'),
        ElBreadcrumbEntry.page('Textarea'),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Installation', anchor: 'install'),
        DocsTocEntry(title: 'Usage', anchor: 'usage'),
        DocsTocEntry(title: 'Textarea vs. input', anchor: 'textarea-vs-input'),
        DocsTocEntry(title: 'Field', anchor: 'field'),
        DocsTocEntry(title: 'Disabled', anchor: 'disabled'),
        DocsTocEntry(title: 'Invalid', anchor: 'invalid'),
        DocsTocEntry(title: 'Button', anchor: 'button'),
        DocsTocEntry(title: 'RTL', anchor: 'rtl'),
        DocsTocEntry(title: 'API Reference', anchor: 'api'),
        DocsTocEntry(title: 'States', anchor: 'states'),
        DocsTocEntry(title: 'Accessibility', anchor: 'accessibility'),
        DocsTocEntry(title: 'Responsive', anchor: 'responsive'),
        DocsTocEntry(title: 'Dependencies', anchor: 'dependencies'),
        DocsTocEntry(title: 'Theming', anchor: 'theming'),
        DocsTocEntry(title: 'Source', anchor: 'source'),
      ],
      // Wave 2's alphabetical order (Phase J plan inventory): `button_group
      // combobox field form input_group input_otp native_select radio
      // selection_control slider textarea`: textarea is last, so there is
      // no "next" within the wave. Neither route is registered yet either —
      // the whole chain is stitched together once the supervisor aggregates
      // every meta.dart, the same as this page's own route is not reachable
      // until then.
      previous: const DocsPageLink(
        title: 'Slider',
        route: '/components/slider',
      ),
      onNavigate: onNavigate,
      child: _TextareaArticle(theme: ElTheme.of(context)),
    );
  }
}

class _TextareaArticle extends StatelessWidget {
  const _TextareaArticle({required this.theme});

  final ElThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey<String>('textarea-doc-article'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ElWidths.prose),
          child: ElText(
            'Six live specimens, all built from the same ElTextarea '
            'constructor. Rest and Focused are real EditableText '
            'instances: type into Rest to try it. Read-only, Disabled '
            'and Auto-grow are seeded with initialValue so their '
            'behaviour is visible without typing.',
            ElType.body,
          ),
        ),
        SizedBox(height: el(6)),
        DocsCodeExample(
          title: 'Textarea specimens',
          description: 'Every cell below renders a real ElTextarea.',
          preview: const _TextareaPreview(),
          manualFiles: <DocsCodeFile>[
            DocsCodeFile(
              path: textareaDoc.sourcePath,
              code:
                  '${textareaDoc.command}\n'
                  '// Installs the generated @ui/textarea.dart payload.',
            ),
          ],
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'install',
          title: 'Installation',
          description:
              'Command install is available: read this before '
              'reaching for elattar add textarea.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DocsInstallFacts(
                facts: <DocsInstallFact>[
                  const DocsInstallFact(
                    label: 'CLI',
                    value: 'registry/components/textarea.json',
                    description:
                        'textarea is a registry item, so `elattar add '
                        'textarea` resolves it and its dependencies and '
                        'copies the source into your project.',
                  ),
                  const DocsInstallFact(
                    label: 'Manual: package mode (supported today)',
                    value:
                        "import 'package:elattar_design_system/elattar_design_system.dart';",
                    description:
                        'Depend on the package and use ElTextarea directly, '
                        'exactly as this page does.',
                  ),
                  DocsInstallFact(
                    label: 'Manual: source mode (not recommended yet)',
                    value: textareaDoc.sourcePath,
                    description:
                        'Copying this one file will not compile on its own: it '
                        'needs field.dart and input.dart with it (see '
                        'Dependencies and files below), and no manifest exists '
                        'yet to resolve them for you.',
                  ),
                ],
              ),
              SizedBox(height: el(5)),
              DocsInstallFacts(
                title: 'Status',
                facts: <DocsInstallFact>[
                  const DocsInstallFact(
                    label: 'Status',
                    value: 'Stable, installable through elattar add textarea',
                    description:
                        'Ported and tested against lib/src/components/textarea.dart, '
                        'and shipped as a registry item, so elattar add '
                        'textarea resolves it.',
                  ),
                  DocsInstallFact(
                    label: 'Version',
                    value: '0.0.1',
                    description:
                        'Tracks the package version; there is no registry schema '
                        'version; the shipped manifest installs it.',
                  ),
                  const DocsInstallFact(
                    label: 'Platforms',
                    value: 'Android, iOS, Web, macOS, Windows, Linux',
                    description:
                        'A pure Flutter widget tree over EditableText: no '
                        'platform channel and no platform-specific branch.',
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'usage',
          title: 'Usage',
          description:
              'The smallest correct example, then how to control it from '
              'outside.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElPanel(
                label: 'DART',
                note: 'SMALLEST CORRECT EXAMPLE',
                child: DocsSelectableCodeBlock(code: _smallestUsageCode),
              ),
              SizedBox(height: el(5)),
              ElText(
                'That form is uncontrolled: ElTextarea builds and owns its '
                'own TextEditingController. Reach for controller instead '
                'when the value needs to be read or written from outside '
                'the widget, autosave, a live character count, syncing two '
                'fields, and ElTextarea will use it in place of building '
                'its own:',
                ElType.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: el(3)),
              ElPanel(
                label: 'DART',
                note: 'CONTROLLED VALUE',
                child: DocsSelectableCodeBlock(code: _controlledDraftCode),
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'textarea-vs-input',
          title: 'Textarea vs. input',
          description:
              'What holding more than one line actually changes, and when '
              'a neighbouring control answers the same need better.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElText(
                'ElTextarea is for a value a user may reasonably want to '
                'spread across more than one line: a comment, a bio, a '
                'shipping note, free-form feedback: and it genuinely grows '
                'with what is typed: there is an 80px floor '
                '(ElTextarea.minHeight) and no ceiling, so the box gets '
                'taller as the value gets longer instead of scrolling or '
                'clipping. Reach for ElInput instead when the value is '
                'naturally one line: an email address, a name, a search '
                'query: even a long one, because ElInput never grows '
                'past its fixed 40px height no matter what is typed into '
                'it; giving it more vertical space would only pad empty '
                'space around a single line, not make it a text area. That '
                'is the real difference between the two controls: it is '
                'not "the same field, taller," it is a different sizing '
                'model entirely: field-sizing: content behaviour with a '
                'floor and no cap, against a fixed single-line height.',
                ElType.body,
              ),
              SizedBox(height: el(4)),
              ElText(
                'Everything ElTextarea shares with ElInput it shares '
                'exactly: the same border, fill, focus ring and invalid '
                'ring, the same 250ms transition, the same selection wash. '
                'Four things differ, and all four are consequences of '
                'holding more than one line rather than independent '
                'styling choices: the radius drops from the family\'s '
                'usual 999px pill to ElRadii.lg (12px): a pill\'s radius '
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
                'disabled input additionally refuses hit-testing: see '
                'Disabled below for what that means for a reader.',
                ElType.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'field',
          title: 'Field',
          description:
              'ElTextarea renders no visible caption of its own: pair it '
              'with ElField for a visible label, description and error '
              'wiring.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElText(
                'label only supplies the accessible name. ElField\'s '
                'ElFieldScope threads that label straight through, so the '
                'field only needs to name itself once:',
                ElType.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: el(3)),
              const _ShippingNoteExample(),
              SizedBox(height: el(3)),
              ElPanel(
                label: 'DART',
                note: 'IN A FIELD',
                child: DocsSelectableCodeBlock(code: _fieldUsageCode),
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'disabled',
          title: 'Disabled',
          description:
              'enabled: false, and the one way it deliberately does not '
              'match ElInput.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElText(
                'enabled: false drops the field to 45% opacity and forces '
                'readOnly, but unlike ElInput the class list adds no '
                'pointer-events-none of its own: the cursor becomes '
                '"forbidden" and a tap still lands on the GestureDetector '
                'underneath. It is dimmed and non-editable, not removed '
                'from hit-testing.',
                ElType.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: el(4)),
              const ElStateCell(
                label: 'Disabled',
                note: 'Dims, but the pointer still lands',
                child: ElTextarea(
                  initialValue: 'Cannot be edited right now.',
                  enabled: false,
                  label: 'Disabled',
                ),
              ),
              SizedBox(height: el(4)),
              ElPanel(
                label: 'DART',
                note: 'DISABLED',
                child: DocsSelectableCodeBlock(code: _disabledUsageCode),
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'invalid',
          title: 'Invalid',
          description:
              'invalid, ORed with the enclosing ElFieldScope, paired with '
              'an error message.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElText(
                'invalid: true swaps the border and ring to '
                'theme.destructive, and it beats focus-visible at equal '
                'specificity: a focused, invalid textarea looks '
                'pixel-identical to an unfocused invalid one, reproduced '
                'from the reference exactly.',
                ElType.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: el(4)),
              const ElStateCell(
                label: 'Error',
                note: 'invalid: true',
                child: ElTextarea(
                  initialValue: 'Too short',
                  invalid: true,
                  label: 'Error',
                ),
              ),
              SizedBox(height: el(4)),
              ElPanel(
                label: 'DART',
                note: 'FIELD WITH AN ERROR',
                child: DocsSelectableCodeBlock(code: _fieldErrorCode),
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'button',
          title: 'Button',
          description:
              'A textarea paired with a submit button, the shape a '
              'feedback form actually takes.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const _TextareaWithButtonExample(),
              SizedBox(height: el(4)),
              ElPanel(
                label: 'DART',
                note: 'WITH A BUTTON',
                child: DocsSelectableCodeBlock(code: _textareaWithButtonCode),
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'rtl',
          title: 'RTL',
          description:
              'ElTextarea has no textDirection parameter of its own: it '
              'reads the ambient Directionality, the same as EditableText '
              'always does.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElText(
                'The placeholder is positioned with AlignmentDirectional, '
                'and the padding is symmetric rather than left/right, so '
                'wrapping the field in a Directionality(textDirection: '
                'TextDirection.rtl) ancestor is the whole story: nothing '
                'inside ElTextarea itself needs to change.',
                ElType.small,
                color: theme.mutedForeground,
              ),
              SizedBox(height: el(4)),
              const _TextareaRtlExample(),
              SizedBox(height: el(4)),
              ElPanel(
                label: 'DART',
                note: 'RTL',
                child: DocsSelectableCodeBlock(code: _textareaRtlCode),
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'api',
          title: 'API Reference',
          description:
              'ElTextarea has no variant or size parameter, and no rows: '
              'field-sizing: content plus the 80px floor already decide '
              'the height, so a row count would contribute nothing to the '
              'rendered result even if it were exposed.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const DocsApiTable(
                title: 'ElTextarea',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'controller',
                    type: 'TextEditingController?',
                    description:
                        'Controls the value externally. Mutually exclusive '
                        'with initialValue: the constructor asserts '
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
                        'Overrides the node a ElFieldScope would otherwise '
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
                        'opacity and makes it non-editable: but, unlike '
                        'ElInput, does not add pointer-events-none, so it '
                        'still receives the pointer and shows a '
                        '"forbidden" cursor rather than being skipped '
                        'entirely.',
                  ),
                  DocsApiFact(
                    name: 'readOnly',
                    type: 'bool',
                    description:
                        'Defaults to false. true blocks editing while '
                        'keeping full opacity: the field stays focusable '
                        'and its text stays selectable, unlike enabled: '
                        'false.',
                  ),
                  DocsApiFact(
                    name: 'invalid',
                    type: 'bool',
                    description:
                        'Defaults to false. true paints the destructive '
                        'border and ring. ORed with the enclosing '
                        'ElFieldScope\'s own invalid flag, and beats focus '
                        'when both apply.',
                  ),
                  DocsApiFact(
                    name: 'label',
                    type: 'String?',
                    description:
                        'The accessible name. Not rendered as visible text '
                        '— pair with ElField (or ElFieldLabel) for a '
                        'visible caption. Falls back to the enclosing '
                        'ElFieldScope\'s label when omitted.',
                  ),
                  DocsApiFact(
                    name: 'hint',
                    type: 'String?',
                    description:
                        'Read after the label: the aria-describedby '
                        'analogue, resolved through Semantics.hint. Falls '
                        'back to the enclosing ElFieldScope\'s describedBy '
                        'when omitted.',
                  ),
                ],
              ),
              SizedBox(height: el(5)),
              const DocsApiTable(
                title: 'Static geometry',
                facts: <DocsApiFact>[
                  DocsApiFact(
                    name: 'ElTextarea.minHeight',
                    type: 'static double',
                    description:
                        'The 80px floor (min-h-20) the border box never '
                        'shrinks below. There is no matching maximum, '
                        'field-sizing: content grows the box with the '
                        'value and the class list declares no max-h.',
                  ),
                  DocsApiFact(
                    name: 'ElTextarea.insets',
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
        SizedBox(height: el(6)),
        ElSection(
          id: 'states',
          title: 'States',
          description:
              'Hover, Pressed, Selected, Loading, Empty, Success and a '
              'character limit are omitted below: reasons follow the '
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
                        'pressed-style shadow: the socket never rises. '
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
                        'A visible ring around the field: beaten by Error '
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
                        'unfocused invalid one: reproduced faithfully '
                        'from the reference, matching ElInput exactly.',
                  ),
                  DocsStateFact(
                    state: 'Read-only',
                    treatment:
                        'readOnly: true blocks EditableText from '
                        'accepting edits. Opacity, border, fill and shadow '
                        'are all unchanged from Rest.',
                    userSignal:
                        'Looks exactly like an editable field: still '
                        'focusable, still lets a reader select and copy '
                        'the text: only typing has no effect. Distinct '
                        'from Disabled below, which does dim.',
                  ),
                  DocsStateFact(
                    state: 'Disabled',
                    treatment:
                        'enabled: false drops opacity to 45% and forces '
                        'readOnly, but the widget adds no pointer-events '
                        'block of its own: the cursor becomes '
                        '"forbidden" and a tap still lands on the '
                        'GestureDetector underneath.',
                    userSignal:
                        'Visibly dimmed. Reproduced from the reference on '
                        'purpose: unlike ElInput, a disabled textarea is '
                        'not removed from hit-testing, only the cursor and '
                        'the EditableText editability change.',
                  ),
                  DocsStateFact(
                    state: 'Reduced motion',
                    treatment:
                        'The border/ring colour tween (TweenAnimationBuilder '
                        'over ElDurations.transitionDefault) resolves '
                        'through elAnimationDuration, the same mechanism '
                        'ElInput uses.',
                    userSignal:
                        'The same end colours, with the 250ms cross-fade '
                        'shortened or removed in a reduced-motion context.',
                  ),
                ],
              ),
              SizedBox(height: el(4)),
              ElText(
                'Omitted: Hover: the class list carries no hover skin of '
                'its own, shared with ElInput; only the pointer cursor '
                'changes (text I-beam when enabled, forbidden when not). '
                'Pressed: a text field has no pressed skin; a tap simply '
                'requests the keyboard. Selected: that state belongs to '
                'choice controls (checkbox, radio); a text primitive has '
                'nothing analogous. Loading and Empty, ElTextarea is a '
                'synchronous primitive with no async operation, and an '
                'empty value is not a distinct visual state, only whether '
                'the placeholder is visible, which Rest above already '
                'covers. Success: the component defines no success '
                'semantics of its own. Character limit: there is no '
                'maxLength, inputFormatters or counter parameter on '
                'ElTextarea; the box has no ceiling to cap against, so '
                'nothing is invented here that the API does not support.',
                ElType.small,
                color: theme.mutedForeground,
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'accessibility',
          title: 'Accessibility',
          child: DocsInstallFacts(
            title: 'Accessibility',
            facts: <DocsInstallFact>[
              const DocsInstallFact(
                label: 'Semantic role',
                value: 'Semantics(textField: true, multiline: true)',
                description:
                    'Merged in only when label, hint or invalid is set, '
                    'when none of the three apply, the widget wraps '
                    'nothing extra and relies purely on EditableText\'s '
                    'own built-in text-field semantics.',
              ),
              const DocsInstallFact(
                label: 'Label association',
                value: 'label',
                description:
                    'Feeds the control\'s accessible name directly. It is '
                    'never rendered as visible text: compose with ElField '
                    '(or a ElFieldLabel) for a caption a sighted user can '
                    'read.',
              ),
              const DocsInstallFact(
                label: 'Keyboard behavior',
                value: 'Native multi-line text editing',
                description:
                    'Unlike the choice-control family, no key handling is '
                    'wired by hand, EditableText\'s own platform text '
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
                    'No separate hit-area widget: unlike ElCheckbox\'s '
                    'ElHitArea, the GestureDetector wraps the entire '
                    'ElFieldSurface, so the tappable region already spans '
                    'the whole field and comfortably clears a touch '
                    'target floor.',
              ),
              const DocsInstallFact(
                label: 'Non-colour signal',
                value: 'None: colour is the only invalid signal',
                description:
                    'Unlike ElCheckbox, which draws a different glyph per '
                    'state, an invalid textarea changes only its border '
                    'and ring colour. A reader who cannot perceive that '
                    'change still gets SemanticsValidationResult.invalid '
                    'through the merged semantics node: recorded as a '
                    'real limitation, not fixed silently.',
              ),
              const DocsInstallFact(
                label: 'Error wiring',
                value: 'invalid, ORed with the enclosing ElFieldScope',
                description:
                    'A ElField around the control folds its own invalid '
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
        SizedBox(height: el(6)),
        ElSection(
          id: 'responsive',
          title: 'Responsive',
          child: ElText(
            'ElTextarea has no responsive breakpoints of its own: its '
            'width comes from the ambient constraints (it fills whatever '
            'box it is given) and its height grows from an 80px floor with '
            'no cap, identical across mobile, tablet, desktop and web. The '
            'one platform-shaped behaviour it does carry is '
            'ElFieldVisibility, shared with the rest of the field family, '
            'a focused textarea is kept clear of the software keyboard, '
            'gated purely on MediaQuery.viewInsets.bottom > 0, so a '
            'desktop or web build where no software keyboard ever opens '
            'renders byte-identical to one without the wrapper at all.',
            ElType.small,
            color: theme.mutedForeground,
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'dependencies',
          title: 'Dependencies',
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
                    'ElFieldScope wiring, and input.dart for '
                    'ElFieldSurface (the shared socket surface) and '
                    'ElFieldVisibility (the shared mobile keyboard-'
                    'avoidance wrapper): deliberately reused rather than '
                    'duplicated, so the textarea cannot drift from the '
                    'input. Neither file is copyable in isolation: see '
                    'Installation.',
              ),
              const DocsInstallFact(
                label: 'Foundation dependencies',
                value:
                    'foundation/spacing.dart, foundation/theme.dart, '
                    'foundation/typography.dart, theme_scope.dart',
                description:
                    'Token sources: the el() spacing scale and ElRadii, '
                    'the live theme, ElText/ElComponentType.textareaBody, '
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
                    'The field surface is drawn by ElMachineSurface (via '
                    'ElFieldSurface); there is no image or icon-font glyph.',
              ),
              const DocsInstallFact(
                label: 'Fonts',
                value: 'none of its own',
                description:
                    'Text renders through ElComponentType.textareaBody, the '
                    'app\'s own type scale: no font file is bundled by '
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
        SizedBox(height: el(6)),
        ElSection(
          id: 'theming',
          title: 'Theming',
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
                    'Resolved in that precedence order: invalid always '
                    'wins, exactly as on ElInput.',
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
                    'ElComponentType.textareaBody / theme.foreground '
                    '(cursor) / theme.mutedForeground (placeholder, '
                    'background cursor)',
                description:
                    'The typed text inherits whatever colour Field applies '
                    '— including invalid ink: because the style carries '
                    'no colour of its own.',
              ),
              DocsInstallFact(
                label: 'Selection wash',
                value: 'theme.primary at 35% alpha',
                description:
                    'ElFieldSurface.selectionAlpha: shared exactly with '
                    'ElInput so the two fields cannot select differently '
                    'from one another.',
              ),
              DocsInstallFact(
                label: 'Shadow',
                value:
                    'ElShadows.pressed, composed with the focus/invalid ring',
                description:
                    'The permanent recessed-socket shadow; never replaced, '
                    'only ever added to.',
              ),
              DocsInstallFact(
                label: 'Radius',
                value: 'ElRadii.lg (12px)',
                description:
                    'The one member of the field family on the radius '
                    'ladder rather than the 999px pill curve: see '
                    'Textarea vs. input for why.',
              ),
              DocsInstallFact(
                label: 'Motion',
                value: 'ElDurations.transitionDefault via elAnimationDuration',
                description:
                    'Drives the border/ring colour tween; a reduced-motion '
                    'context shortens or removes it automatically, the '
                    'same mechanism ElInput uses.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElSection(
          id: 'source',
          title: 'Source',
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
                    'ElFieldSurface and ElFieldVisibility: shared with '
                    'ElInput and documented on its own component page.',
              ),
              const DocsInstallFact(
                label: 'Package tests',
                value: 'test/inputs_test.dart',
                description:
                    'The "ElTextarea" group covers geometry, growth and the '
                    'disabled state for ElTextarea in the package itself.',
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

ElTextarea(
  label: 'Feedback',
  placeholder: 'Tell us what happened…',
  onChanged: (String next) => setState(() => feedback = next),
)''';

const String _fieldUsageCode = '''ElField(
  label: 'Shipping note',
  description: 'Grows as you type. Minimum height is 80px.',
  child: const ElTextarea(
    placeholder: 'Anything the packing team should know',
  ),
)''';

const String _fieldErrorCode = '''ElField(
  label: 'Feedback',
  errors: const <String>['Please provide at least 20 characters.'],
  invalid: true,
  child: ElTextarea(
    initialValue: 'Too short',
    invalid: true,
  ),
)''';

const String _controlledDraftCode =
    '''// draftController is created once and disposed with its owner.
final TextEditingController draftController = TextEditingController();

ElField(
  label: 'Draft',
  description: 'Autosaved locally while you type.',
  child: ElTextarea(
    controller: draftController,
    onChanged: (String next) => autosave(next),
  ),
)''';

const String _disabledUsageCode = '''const ElTextarea(
  enabled: false,
  initialValue: 'Cannot be edited right now.',
  label: 'Disabled',
)''';

const String _textareaWithButtonCode = '''Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: <Widget>[
    ElTextarea(
      label: 'Message',
      placeholder: 'Write your message',
    ),
    SizedBox(height: el(3)),
    ElButton(
      onPressed: submit,
      child: const Text('Send message'),
    ),
  ],
)''';

const String _textareaRtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ElTextarea(
    label: 'ملاحظة',
    placeholder: 'اكتب ملاحظتك هنا',
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
      spacing: el(3),
      runSpacing: el(3),
      children: <Widget>[
        const ElStateCell(
          label: 'Rest',
          note: 'Type to try it',
          child: ElTextarea(
            key: ValueKey<String>('textarea-live-specimen'),
            label: 'Rest',
            placeholder: 'Type here to try it',
          ),
        ),
        ElStateCell(
          label: 'Focus-visible',
          note: 'Actually focused, not forced',
          child: ElTextarea(
            focusNode: _focusNode,
            label: 'Focus-visible',
            placeholder: 'Focused on mount',
          ),
        ),
        const ElStateCell(
          label: 'Error',
          note: 'invalid: true',
          child: ElTextarea(
            initialValue: 'Too short',
            invalid: true,
            label: 'Error',
          ),
        ),
        const ElStateCell(
          label: 'Read-only',
          note: 'Focusable and selectable, not editable',
          child: ElTextarea(
            initialValue: '0xA71c…4F2b delivered 2 days ago.',
            readOnly: true,
            label: 'Read-only',
          ),
        ),
        const ElStateCell(
          label: 'Disabled',
          note: 'Dims, but the pointer still lands',
          child: ElTextarea(
            initialValue: 'Cannot be edited right now.',
            enabled: false,
            label: 'Disabled',
          ),
        ),
        const ElStateCell(
          label: 'Auto-grow',
          note: 'No max height: the value decides',
          child: ElTextarea(
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

/// A live, functioning `ElField`-wrapped textarea for the "Field" section,
/// proof the composition it documents actually renders and accepts typed
/// text, not just a code excerpt.
class _ShippingNoteExample extends StatelessWidget {
  const _ShippingNoteExample();

  @override
  Widget build(BuildContext context) {
    return ElField(
      label: 'Shipping note',
      description: 'Grows as you type. Minimum height is 80px.',
      child: const ElTextarea(
        placeholder: 'Anything the packing team should know',
      ),
    );
  }
}

/// A live textarea-plus-submit-button composition for the "Button" section:
/// the shadcn counterpart page has no such prop of ours to demonstrate, so
/// this specimen is new (per the reshape brief's rule 6 exception).
class _TextareaWithButtonExample extends StatelessWidget {
  const _TextareaWithButtonExample();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ElTextarea(
          key: ValueKey<String>('textarea-with-button-specimen'),
          label: 'Message',
          placeholder: 'Write your message',
        ),
        SizedBox(height: el(3)),
        ElButton(onPressed: () {}, child: const Text('Send message')),
      ],
    );
  }
}

/// A live right-to-left textarea for the "RTL" section: proof that ambient
/// Directionality is the whole mechanism, nothing inside ElTextarea itself
/// needs a direction-specific parameter.
class _TextareaRtlExample extends StatelessWidget {
  const _TextareaRtlExample();

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: ElTextarea(
        key: ValueKey<String>('textarea-rtl-specimen'),
        label: 'ملاحظة',
        placeholder: 'اكتب ملاحظتك هنا',
      ),
    );
  }
}
