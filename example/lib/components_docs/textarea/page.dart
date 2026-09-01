/// Public documentation page for the `textarea` component.
///
/// **Re-housed onto the documentation kit** (matching
/// `components_docs/button/page.dart`'s own reference shape): the page is
/// now a `ComponentDocSpec` declaration plus a ten-line widget handing it to
/// `DocsLayout`, rather than a hand-composed `_TextareaArticle`. Every
/// specimen and every code string below moved across unchanged from the
/// previous hand-composed page; nothing here was rewritten or reworded.
/// Three changes are new: the live six-cell preview grid is promoted to its
/// own `Preview` `ShowcaseSection` (it used to render ahead of any heading,
/// with no rail entry of its own); Installation now reads
/// `InstallSection.command` off `textareaDoc.command` instead of embedding
/// the CLI line as a value string inside a facts panel; and a `Keyboard`
/// disclosure is added between Accessibility and Responsive — split out of
/// the old Accessibility panel's own "Keyboard behavior" fact, which is
/// moved here verbatim rather than duplicated. The old Usage section's
/// second code block (the controlled-value example) is promoted to its own
/// `Controlled value` section, since `SnippetSection` renders one code block
/// each and the house Usage section is "the smallest correct import and
/// construction" only, matching every other migrated page.
///
/// Section shape mirrors https://ui.shadcn.com/docs/components/base/textarea:
/// Preview, Installation, Usage, then that page's own literal sections
/// (Field, Disabled, Invalid, Button, RTL) in their order, one section this
/// page has that theirs does not (Textarea vs. input), an API Reference this
/// page adds because Textarea has documentable props even though the
/// counterpart page carries none, and finally the eight disclosures shadcn
/// does not have at all.
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
import '../../kit.dart' show StateCell;
import 'meta.dart';

final ComponentDocSpec textareaDocSpec = ComponentDocSpec(
  name: 'textarea',
  title: textareaDoc.title,
  description: textareaDoc.description,
  sections: <DocsPageSection>[
    ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'Six live specimens, all built from the same Textarea '
          'constructor. Rest and Focus-visible are real EditableText '
          'instances: type into Rest to try it. Read-only, Disabled and '
          'Auto-grow are seeded with initialValue so their behaviour is '
          'visible without typing.',
      specimen: const _TextareaPreview(),
      code: _previewCode,
      label: 'Preview specimen view',
      minHeight: space(160),
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'textarea is a registry item, so `elattar add textarea` resolves '
          'it and its dependencies and copies the source into your '
          'project. Depend on the package directly and use Textarea, '
          'exactly as this page does, for manual mode.',
      command: textareaDoc.command,
      manualFiles: <DocsCodeFile>[
        const DocsCodeFile(
          path: 'lib/main.dart',
          title: 'Package mode (supported today)',
          description:
              'Depend on the package and use Textarea directly, exactly '
              'as this page does.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              'Textarea(\n'
              "  label: 'Feedback',\n"
              "  placeholder: 'Tell us what happened…',\n"
              ')',
        ),
        DocsCodeFile(
          path: textareaDoc.sourcePath,
          title: 'Source mode (not recommended yet)',
          description:
              'Copying this one file will not compile on its own: it '
              'needs field.dart and input.dart with it (see Dependencies '
              'below), and no manifest exists yet to resolve them for you.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy lib/src/components/ui/textarea.dart, field.dart, and '
              'input.dart together.',
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'The smallest correct example. That form is uncontrolled: '
          'Textarea builds and owns its own TextEditingController.',
      code: _smallestUsageCode,
    ),
    SnippetSection(
      id: 'controlled-value',
      title: 'Controlled value',
      description:
          'Reach for controller instead when the value needs to be read '
          'or written from outside the widget: autosave, a live character '
          'count, syncing two fields. Textarea will use it in place of '
          'building its own.',
      code: _controlledDraftCode,
    ),
    SnippetSection(
      id: 'textarea-vs-input',
      title: 'Textarea vs. input',
      description:
          'Textarea is for a value a user may reasonably want to spread '
          'across more than one line: a comment, a bio, a shipping note, '
          'free-form feedback: and it genuinely grows with what is typed: '
          'there is an 80px floor (Textarea.minHeight) and no ceiling. '
          'Reach for Input instead when the value is naturally one '
          'line: an email address, a name, a search query, because '
          'Input never grows past its fixed 40px height no matter what '
          'is typed into it. Everything Textarea shares with Input it '
          'shares exactly: the same border, fill, focus ring and invalid '
          'ring, the same 250ms transition, the same selection wash. Four '
          'things differ, all consequences of holding more than one '
          'line: the radius drops from the family\'s usual 999px pill to '
          'Radii.lg (12px); the height floor is 80px with no cap '
          'instead of a fixed 40px; the padding is 14px / 10px instead of '
          '16px / 4px; and the line height is 1.625 rather than '
          'inheriting the ambient default. One more difference is '
          'behavioural, not visual: disabling a textarea drops it to 45% '
          'opacity but never blocks the pointer, while a disabled input '
          'additionally refuses hit-testing.',
      code: _vsInputCode,
    ),
    ShowcaseSection(
      id: 'field',
      title: 'Field',
      description:
          'Textarea renders no visible caption of its own: pair it '
          'with Field for a visible label, description and error '
          'wiring. label only supplies the accessible name. Field\'s '
          'FieldScope threads that label straight through, so the '
          'field only needs to name itself once.',
      specimen: const _ShippingNoteExample(),
      code: _fieldUsageCode,
      label: 'Field specimen view',
    ),
    ShowcaseSection(
      id: 'disabled',
      title: 'Disabled',
      description:
          'enabled: false drops the field to 45% opacity and forces '
          'readOnly, but unlike Input the class list adds no '
          'pointer-events-none of its own: the cursor becomes '
          '"forbidden" and a tap still lands on the GestureDetector '
          'underneath. It is dimmed and non-editable, not removed from '
          'hit-testing.',
      specimen: const StateCell(
        label: 'Disabled',
        note: 'Dims, but the pointer still lands',
        child: Textarea(
          initialValue: 'Cannot be edited right now.',
          enabled: false,
          label: 'Disabled',
        ),
      ),
      code: _disabledUsageCode,
      label: 'Disabled specimen view',
    ),
    ShowcaseSection(
      id: 'invalid',
      title: 'Invalid',
      description:
          'invalid: true swaps the border and ring to theme.destructive, '
          'and it beats focus-visible at equal specificity: a focused, '
          'invalid textarea looks pixel-identical to an unfocused invalid '
          'one, reproduced from the reference exactly.',
      specimen: const StateCell(
        label: 'Error',
        note: 'invalid: true',
        child: Textarea(
          initialValue: 'Too short',
          invalid: true,
          label: 'Error',
        ),
      ),
      code: _fieldErrorCode,
      label: 'Invalid specimen view',
    ),
    ShowcaseSection(
      id: 'button',
      title: 'Button',
      description:
          'A textarea paired with a submit button, the shape a feedback '
          'form actually takes.',
      specimen: const _TextareaWithButtonExample(),
      code: _textareaWithButtonCode,
      label: 'Button specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'Textarea has no textDirection parameter of its own: it '
          'reads the ambient Directionality, the same as EditableText '
          'always does. The placeholder is positioned with '
          'AlignmentDirectional, and the padding is symmetric rather than '
          'left/right, so wrapping the field in a Directionality ancestor '
          'is the whole story.',
      specimen: const _TextareaRtlExample(),
      code: _textareaRtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Textarea has no variant or size parameter, and no rows: '
          'field-sizing: content plus the 80px floor already decide the '
          'height, so a row count would contribute nothing to the '
          'rendered result even if it were exposed.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'Textarea', anchor: 'api-eltextarea'),
        DocsTocEntry(title: 'Static geometry', anchor: 'api-static-geometry'),
      ],
      child: _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'Hover, Pressed, Selected, Loading, Empty, Success and a '
          'character limit are omitted below: reasons follow the table.',
      child: _StatesContent(),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: DocsInstallFacts(
        title: 'Accessibility',
        facts: const <DocsInstallFact>[
          DocsInstallFact(
            label: 'Semantic role',
            value: 'Semantics(textField: true, multiline: true)',
            description:
                'Merged in only when label, hint or invalid is set, when '
                'none of the three apply, the widget wraps nothing extra '
                'and relies purely on EditableText\'s own built-in '
                'text-field semantics.',
          ),
          DocsInstallFact(
            label: 'Label association',
            value: 'label',
            description:
                'Feeds the control\'s accessible name directly. It is '
                'never rendered as visible text: compose with Field (or '
                'a FieldLabel) for a caption a sighted user can read.',
          ),
          DocsInstallFact(
            label: 'Focus behavior',
            value: 'theme.primary/50 border plus a 3px ring at 35% alpha',
            description:
                'aria-invalid beats focus-visible at equal specificity, '
                'reproduced from the reference: a focused, invalid '
                'textarea shows no visible change from an unfocused '
                'invalid one.',
          ),
          DocsInstallFact(
            label: 'Touch target',
            value: 'The full padded surface, minimum 80px tall',
            description:
                'No separate hit-area widget: unlike Checkbox\'s '
                'HitArea, the GestureDetector wraps the entire '
                'FieldSurfaceRecipe, so the tappable region already spans the '
                'whole field and comfortably clears a touch target floor.',
          ),
          DocsInstallFact(
            label: 'Non-colour signal',
            value: 'None: colour is the only invalid signal',
            description:
                'Unlike Checkbox, which draws a different glyph per '
                'state, an invalid textarea changes only its border and '
                'ring colour. A reader who cannot perceive that change '
                'still gets SemanticsValidationResult.invalid through the '
                'merged semantics node: recorded as a real limitation, '
                'not fixed silently.',
          ),
          DocsInstallFact(
            label: 'Error wiring',
            value: 'invalid, ORed with the enclosing FieldScope',
            description:
                'A Field around the control folds its own invalid flag '
                'in, and colours the field\'s text with '
                'theme.destructiveText when either is true.',
          ),
          DocsInstallFact(
            label: 'Screen-reader announcements',
            value: 'No live region',
            description:
                'State changes are exposed purely through the merged '
                'semantics node\'s flags (when present); no extra '
                'announcement is authored.',
          ),
          DocsInstallFact(
            label: 'Known platform differences',
            value: 'None',
            description:
                'EditableText\'s own IME and platform text-input handling '
                'is uniform across every Flutter target this package '
                'supports; keyboardType is TextInputType.multiline '
                'everywhere.',
          ),
        ],
      ),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      description:
          'New: split out of the old Accessibility panel\'s own '
          '"Keyboard behavior" fact, moved here unchanged rather than '
          'duplicated.',
      child: DocsInstallFacts(
        title: 'Keyboard',
        facts: const <DocsInstallFact>[
          DocsInstallFact(
            label: 'Keyboard behavior',
            value: 'Native multi-line text editing',
            description:
                'Unlike the choice-control family, no key handling is '
                'wired by hand, EditableText\'s own platform text input '
                'connection drives everything, so Enter inserts a newline '
                'rather than doing anything special, and Tab moves focus '
                'through the ambient FocusTraversalGroup like any other '
                'focusable node.',
          ),
        ],
      ),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
        child: Builder(
          builder: (BuildContext context) => StyledText(
            'Textarea has no responsive breakpoints of its own: its '
            'width comes from the ambient constraints (it fills whatever '
            'box it is given) and its height grows from an 80px floor '
            'with no cap, identical across mobile, tablet, desktop and '
            'web. The one platform-shaped behaviour it does carry is '
            'FieldVisibility, shared with the rest of the field family, '
            'a focused textarea is kept clear of the software keyboard, '
            'gated purely on MediaQuery.viewInsets.bottom > 0, so a '
            'desktop or web build where no software keyboard ever opens '
            'renders byte-identical to one without the wrapper at all.',
            TextStyles.small,
            color: ThemeScope.of(context).mutedForeground,
          ),
        ),
      ),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: _DependenciesContent(),
    ),
    DisclosureSection(
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
                'Resolved in that precedence order: invalid always wins, '
                'exactly as on Input.',
          ),
          DocsInstallFact(
            label: 'Ring',
            value:
                'transparent (rest) / theme.ring at 35% alpha (focus) / '
                'theme.destructive at 20% alpha (invalid)',
            description: 'Added to the socket shadow, never replacing it.',
          ),
          DocsInstallFact(
            label: 'Text and cursor',
            value:
                'TextStyles.body / theme.foreground (cursor) '
                '/ theme.mutedForeground (placeholder, background cursor)',
            description:
                'The typed text inherits whatever colour Field applies — '
                'including invalid ink: because the style carries no '
                'colour of its own.',
          ),
          DocsInstallFact(
            label: 'Selection wash',
            value: 'theme.primary at 35% alpha',
            description:
                'FieldSurfaceRecipe.selectionAlpha: shared exactly with '
                'Input so the two fields cannot select differently from '
                'one another.',
          ),
          DocsInstallFact(
            label: 'Shadow',
            value: 'Shadows.inset, composed with the focus/invalid ring',
            description:
                'The permanent recessed-socket shadow; never replaced, '
                'only ever added to.',
          ),
          DocsInstallFact(
            label: 'Radius',
            value: 'Radii.lg (12px)',
            description:
                'The one member of the field family on the radius ladder '
                'rather than the 999px pill curve: see Textarea vs. '
                'input for why.',
          ),
          DocsInstallFact(
            label: 'Motion',
            value: 'MotionDurations.normal via effectiveMotionDuration',
            description:
                'Drives the border/ring colour tween; a reduced-motion '
                'context shortens or removes it automatically, the same '
                'mechanism Input uses.',
          ),
        ],
      ),
    ),
    DisclosureSection(
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
            value: 'lib/src/components/ui/input.dart',
            description:
                'FieldSurfaceRecipe and FieldVisibility: shared with '
                'Input and documented on its own component page.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/inputs_test.dart',
            description:
                'The "Textarea" group covers geometry, growth and the '
                'disabled state for Textarea in the package itself.',
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

class TextareaDocPage extends StatelessWidget {
  const TextareaDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: textareaDoc.route,
    intro: DocsPageIntro(
      title: textareaDoc.title,
      description: textareaDoc.description,
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Components'),
      BreadcrumbEntry.page('Textarea'),
    ],
    toc: textareaDocSpec.toc,
    previous: const DocsPageLink(title: 'Slider', route: '/components/slider'),
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('textarea-doc-article'),
      child: ComponentDocPage(spec: textareaDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

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
      spacing: space(3),
      runSpacing: space(3),
      children: <Widget>[
        const StateCell(
          label: 'Rest',
          note: 'Type to try it',
          child: Textarea(
            key: ValueKey<String>('textarea-live-specimen'),
            label: 'Rest',
            placeholder: 'Type here to try it',
          ),
        ),
        StateCell(
          label: 'Focus-visible',
          note: 'Actually focused, not forced',
          child: Textarea(
            focusNode: _focusNode,
            label: 'Focus-visible',
            placeholder: 'Focused on mount',
          ),
        ),
        const StateCell(
          label: 'Error',
          note: 'invalid: true',
          child: Textarea(
            initialValue: 'Too short',
            invalid: true,
            label: 'Error',
          ),
        ),
        const StateCell(
          label: 'Read-only',
          note: 'Focusable and selectable, not editable',
          child: Textarea(
            initialValue: '0xA71c…4F2b delivered 2 days ago.',
            readOnly: true,
            label: 'Read-only',
          ),
        ),
        const StateCell(
          label: 'Disabled',
          note: 'Dims, but the pointer still lands',
          child: Textarea(
            initialValue: 'Cannot be edited right now.',
            enabled: false,
            label: 'Disabled',
          ),
        ),
        const StateCell(
          label: 'Auto-grow',
          note: 'No max height: the value decides',
          child: Textarea(
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

/// A live, functioning `Field`-wrapped textarea for the "Field" section,
/// proof the composition it documents actually renders and accepts typed
/// text, not just a code excerpt.
class _ShippingNoteExample extends StatelessWidget {
  const _ShippingNoteExample();

  @override
  Widget build(BuildContext context) {
    return Field(
      label: 'Shipping note',
      description: 'Grows as you type. Minimum height is 80px.',
      child: const Textarea(
        placeholder: 'Anything the packing team should know',
      ),
    );
  }
}

/// A live textarea-plus-submit-button composition for the "Button" section:
/// the shadcn counterpart page has no such prop of ours to demonstrate, so
/// this specimen is new (documented drift, not a fabricated capability).
class _TextareaWithButtonExample extends StatelessWidget {
  const _TextareaWithButtonExample();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Textarea(
          key: ValueKey<String>('textarea-with-button-specimen'),
          label: 'Message',
          placeholder: 'Write your message',
        ),
        SizedBox(height: space(3)),
        Button(onPressed: () {}, child: const Text('Send message')),
      ],
    );
  }
}

/// A live right-to-left textarea for the "RTL" section: proof that ambient
/// Directionality is the whole mechanism, nothing inside Textarea itself
/// needs a direction-specific parameter.
class _TextareaRtlExample extends StatelessWidget {
  const _TextareaRtlExample();

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: Textarea(
        key: ValueKey<String>('textarea-rtl-specimen'),
        label: 'ملاحظة',
        placeholder: 'اكتب ملاحظتك هنا',
      ),
    );
  }
}

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _previewCode =
    '''Textarea(label: 'Rest', placeholder: 'Type here to try it')
Textarea(focusNode: liveNode, label: 'Focus-visible')
Textarea(initialValue: 'Too short', invalid: true, label: 'Error')
Textarea(initialValue: '...', readOnly: true, label: 'Read-only')
Textarea(initialValue: '...', enabled: false, label: 'Disabled')
Textarea(initialValue: 'Line one\\nLine two\\n...', label: 'Auto-grow')''';

const String _smallestUsageCode = '''String feedback = '';

Textarea(
  label: 'Feedback',
  placeholder: 'Tell us what happened…',
  onChanged: (String next) => setState(() => feedback = next),
)''';

const String _controlledDraftCode =
    '''// draftController is created once and disposed with its owner.
final TextEditingController draftController = TextEditingController();

Field(
  label: 'Draft',
  description: 'Autosaved locally while you type.',
  child: Textarea(
    controller: draftController,
    onChanged: (String next) => autosave(next),
  ),
)''';

const String _vsInputCode = '''Textarea(
  label: 'Bio',
  placeholder: 'Tell us about yourself',
) // grows from an 80px floor, no ceiling

Input(
  label: 'Email',
  placeholder: 'you@example.com',
) // fixed 40px, never grows''';

const String _fieldUsageCode = '''Field(
  label: 'Shipping note',
  description: 'Grows as you type. Minimum height is 80px.',
  child: const Textarea(
    placeholder: 'Anything the packing team should know',
  ),
)''';

const String _fieldErrorCode = '''Field(
  label: 'Feedback',
  errors: const <String>['Please provide at least 20 characters.'],
  invalid: true,
  child: Textarea(
    initialValue: 'Too short',
    invalid: true,
  ),
)''';

const String _disabledUsageCode = '''const Textarea(
  enabled: false,
  initialValue: 'Cannot be edited right now.',
  label: 'Disabled',
)''';

const String _textareaWithButtonCode = '''Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: <Widget>[
    Textarea(
      label: 'Message',
      placeholder: 'Write your message',
    ),
    SizedBox(height: space(3)),
    Button(
      onPressed: submit,
      child: const Text('Send message'),
    ),
  ],
)''';

const String _textareaRtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: Textarea(
    label: 'ملاحظة',
    placeholder: 'اكتب ملاحظتك هنا',
  ),
)''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsAnchor(
        id: 'api-eltextarea',
        child: const DocsApiTable(
          title: 'Textarea',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'controller',
              type: 'TextEditingController?',
              description:
                  'Controls the value externally. Mutually exclusive with '
                  'initialValue: the constructor asserts against '
                  'supplying both, since a controller already carries the '
                  'value.',
            ),
            DocsApiFact(
              name: 'initialValue',
              type: 'String?',
              description:
                  'defaultValue, read once when the field builds its own '
                  'controller for uncontrolled usage.',
            ),
            DocsApiFact(
              name: 'focusNode',
              type: 'FocusNode?',
              description:
                  'Overrides the node a FieldScope would otherwise '
                  'supply.',
            ),
            DocsApiFact(
              name: 'placeholder',
              type: 'String?',
              description:
                  'Shown only while the value is empty, positioned so it '
                  'never contributes to the box\'s height.',
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
                  'Input, does not add pointer-events-none, so it still '
                  'receives the pointer and shows a "forbidden" cursor '
                  'rather than being skipped entirely.',
            ),
            DocsApiFact(
              name: 'readOnly',
              type: 'bool',
              description:
                  'Defaults to false. true blocks editing while keeping '
                  'full opacity: the field stays focusable and its text '
                  'stays selectable, unlike enabled: false.',
            ),
            DocsApiFact(
              name: 'invalid',
              type: 'bool',
              description:
                  'Defaults to false. true paints the destructive border '
                  'and ring. ORed with the enclosing FieldScope\'s own '
                  'invalid flag, and beats focus when both apply.',
            ),
            DocsApiFact(
              name: 'label',
              type: 'String?',
              description:
                  'The accessible name. Not rendered as visible text — '
                  'pair with Field (or FieldLabel) for a visible '
                  'caption. Falls back to the enclosing FieldScope\'s '
                  'label when omitted.',
            ),
            DocsApiFact(
              name: 'hint',
              type: 'String?',
              description:
                  'Read after the label: the aria-describedby analogue, '
                  'resolved through Semantics.hint. Falls back to the '
                  'enclosing FieldScope\'s describedBy when omitted.',
            ),
          ],
        ),
      ),
      SizedBox(height: space(6)),
      DocsAnchor(
        id: 'api-static-geometry',
        child: const DocsApiTable(
          title: 'Static geometry',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'Textarea.minHeight',
              type: 'static double',
              description:
                  'The 80px floor (min-h-20) the border box never '
                  'shrinks below. There is no matching maximum, '
                  'field-sizing: content grows the box with the value '
                  'and the class list declares no max-h.',
            ),
            DocsApiFact(
              name: 'Textarea.insets',
              type: 'static EdgeInsets',
              description:
                  'The 14px horizontal / 10px vertical padding (px-3.5 '
                  'py-2.5) paid for from inside the 80px floor, along '
                  'with the 1px border.',
            ),
          ],
        ),
      ),
    ],
  );
}

class _StatesContent extends StatelessWidget {
  const _StatesContent();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const DocsStateMatrix(
          facts: <DocsStateFact>[
            DocsStateFact(
              state: 'Rest',
              treatment:
                  'theme.card fill, theme.input border, a permanent '
                  'pressed-style shadow: the socket never rises. The '
                  'placeholder (if any) shows only while the value is '
                  'empty and never affects the box height.',
              userSignal:
                  'An 80px-tall recessed field, growing taller only once '
                  'there is enough text to need it.',
            ),
            DocsStateFact(
              state: 'Focus-visible',
              treatment:
                  'Border tweens to theme.primary at 50% alpha and a 3px '
                  'ring appears at theme.ring 35% alpha, added to (not '
                  'replacing) the socket shadow.',
              userSignal:
                  'A visible ring around the field: beaten by Error below '
                  'when both apply.',
            ),
            DocsStateFact(
              state: 'Error',
              treatment:
                  'invalid: true swaps the border and ring to '
                  'theme.destructive, ring at 20% alpha, with no '
                  'dark-mode variant.',
              userSignal:
                  'aria-invalid beats focus-visible: a focused, invalid '
                  'textarea looks pixel-identical to an unfocused invalid '
                  'one: reproduced faithfully from the reference, '
                  'matching Input exactly.',
            ),
            DocsStateFact(
              state: 'Read-only',
              treatment:
                  'readOnly: true blocks EditableText from accepting '
                  'edits. Opacity, border, fill and shadow are all '
                  'unchanged from Rest.',
              userSignal:
                  'Looks exactly like an editable field: still focusable, '
                  'still lets a reader select and copy the text: only '
                  'typing has no effect. Distinct from Disabled below, '
                  'which does dim.',
            ),
            DocsStateFact(
              state: 'Disabled',
              treatment:
                  'enabled: false drops opacity to 45% and forces '
                  'readOnly, but the widget adds no pointer-events block '
                  'of its own: the cursor becomes "forbidden" and a tap '
                  'still lands on the GestureDetector underneath.',
              userSignal:
                  'Visibly dimmed. Reproduced from the reference on '
                  'purpose: unlike Input, a disabled textarea is not '
                  'removed from hit-testing, only the cursor and the '
                  'EditableText editability change.',
            ),
            DocsStateFact(
              state: 'Reduced motion',
              treatment:
                  'The border/ring colour tween (TweenAnimationBuilder '
                  'over MotionDurations.normal) resolves through '
                  'effectiveMotionDuration, the same mechanism Input uses.',
              userSignal:
                  'The same end colours, with the 250ms cross-fade '
                  'shortened or removed in a reduced-motion context.',
            ),
          ],
        ),
        SizedBox(height: space(4)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
          child: StyledText(
            'Omitted: Hover: the class list carries no hover skin of its '
            'own, shared with Input; only the pointer cursor changes '
            '(text I-beam when enabled, forbidden when not). Pressed: a '
            'text field has no pressed skin; a tap simply requests the '
            'keyboard. Selected: that state belongs to choice controls '
            '(checkbox, radio); a text primitive has nothing analogous. '
            'Loading and Empty, Textarea is a synchronous primitive '
            'with no async operation, and an empty value is not a '
            'distinct visual state, only whether the placeholder is '
            'visible, which Rest above already covers. Success: the '
            'component defines no success semantics of its own. '
            'Character limit: there is no maxLength, inputFormatters or '
            'counter parameter on Textarea; the box has no ceiling to '
            'cap against, so nothing is invented here that the API does '
            'not support.',
            TextStyles.small,
            color: theme.mutedForeground,
          ),
        ),
      ],
    );
  }
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsInstallFacts(
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
                'FieldScope wiring, and input.dart for FieldSurfaceRecipe '
                '(the shared socket surface) and FieldVisibility (the '
                'shared mobile keyboard-avoidance wrapper): deliberately '
                'reused rather than duplicated, so the textarea cannot '
                'drift from the input. Neither file is copyable in '
                'isolation: see Installation.',
          ),
          const DocsInstallFact(
            label: 'Foundation dependencies',
            value:
                'foundation/spacing.dart, foundation/theme.dart, '
                'foundation/typography.dart, theme_scope.dart',
            description:
                'Token sources: the space() spacing scale and Radii, the '
                'live theme, StyledText/TextStyles.body, and the '
                'theme scope.',
          ),
          DocsInstallFact(
            label: 'Exports',
            value: textareaDoc.exports.join(', '),
            description: 'The public symbols this component makes available.',
          ),
          const DocsInstallFact(
            label: 'Assets',
            value: 'none',
            description:
                'The field surface is drawn by Surface (via '
                'FieldSurfaceRecipe); there is no image or icon-font glyph.',
          ),
          const DocsInstallFact(
            label: 'Fonts',
            value: 'none of its own',
            description:
                'Text renders through TextStyles.body, the '
                'app\'s own type scale: no font file is bundled by this '
                'component.',
          ),
          const DocsInstallFact(
            label: 'Shaders',
            value: 'none',
            description: 'No fragment shader is used.',
          ),
        ],
      ),
      SizedBox(height: space(2)),
      DocsLinkRow(
        links: const <DocsLink>[
          DocsLink(label: 'Field', route: '/components/field'),
          DocsLink(label: 'Input', route: '/components/input'),
          DocsLink(
            label: 'Source Foundation',
            route: '/components/source_foundation',
          ),
        ],
      ),
    ],
  );
}
