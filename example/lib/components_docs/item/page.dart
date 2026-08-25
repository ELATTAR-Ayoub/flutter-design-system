/// Public documentation page for the `item` component.
///
/// **Re-housed onto the kit.** This page used to hand-compose [ElSection]
/// panels; it now declares a [ComponentDocSpec]
/// (`example/lib/docs/component_doc_page.dart`) and hands it to
/// [ComponentDocPage], the same shape `button`, `field`, `popover`,
/// `hover_card`, and `kbd` established. Every specimen widget is the one
/// the hand-composed page carried; new in this pass: real Dart `code:`
/// strings for Variant, Icon, Avatar, Group, and RTL, all of which were
/// live-only panels before (a `ElPanel` around a specimen, no quoted
/// source) — a `ShowcaseSection` is a specimen AND its source, so each now
/// carries both. Item vs Field, which was prose with nothing live to show,
/// becomes a `SnippetSection` illustrating the two constructions side by
/// side rather than staging an empty box. A dedicated Keyboard disclosure
/// is split out of Accessibility's own "Keyboard" bullet.
///
/// **Corrected, not carried across.** `meta.dart`'s own doc comment said
/// "`item` has no `registry/components/item.json` yet." That was false the
/// whole time this page existed: `registry/components/item.json` is a real
/// manifest — `files`, `registryDependencies: [source-foundation]`, a
/// `documentationRoute` — and `elattar add item` installs from it today,
/// exactly what this page's own Installation section already said
/// correctly; only the metadata file's comment was stale.
///
/// **Reference shape**, unchanged from before, mirrored from shadcn's own
/// `ui.shadcn.com/docs/components/base/item`, fetched fresh: Installation,
/// Usage, Composition, Item vs Field, Variant, Size, Icon, Avatar, Image,
/// Group, Header, Link, Dropdown, RTL, API Reference.
///
/// **Skipped, honestly**, five of those fourteen — each one traced to
/// `item.dart`'s own "Not ported" note:
/// * **Size**: the reference ships three rungs (default/sm/xs). The port's
///   own doc comment says the two smaller rungs "are byte-identical to
///   `default`" and were never built: there is no ElItemSize to demonstrate,
///   so a "Size" section would show the same row three times under three
///   names.
/// * **Image**: `ElItemMedia`'s only forced shape is the icon variant
///   (`size-4`, 16px). There is no separate, larger `variant="image"` slot:
///   passing an `Image` widget as `child` still renders it in the same 16px
///   box an icon gets, not the reference's larger album-art treatment.
/// * **Header**: `item.dart`'s own doc comment lists `ItemHeader` (along
///   with `ItemSeparator` and `ItemFooter`) under "Not ported… no call
///   site."
/// * **Link**: the reference's Link section uses `asChild`/`render` to turn
///   an Item into a real anchor. `item.dart`'s doc comment: "Not ported:
///   `asChild` and with it the whole `[a]:hover:bg-muted` … pair — the hover
///   surface is keyed to the element the row *is*", and this port has no
///   such polymorphic render prop.
/// * **Dropdown**: the reference composes a `<Select>` inside an Item to
///   show any interactive control can sit in its content/actions slots —
///   which Icon, Avatar, and Group below already demonstrate with real
///   controls of their own. A dedicated section would repeat that same fact
///   with a different child widget, so it is folded into those instead of
///   duplicated.
///
/// [ComponentDocEntry.description] is the page's only rendered description;
/// no second hero paragraph renders beneath it.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

/// The declaration: every section this page shows, in TOC order. `final`,
/// not `const`: `InstallSection.command` reads `itemDoc.command`, a
/// computed getter, which is not a constant expression.
final ComponentDocSpec itemDocSpec = ComponentDocSpec(
  name: 'item',
  title: itemDoc.title,
  description: itemDoc.description,
  sections: <DocsPageSection>[
    const ShowcaseSection(
      id: 'preview',
      title: 'Preview',
      description:
          'ElItem is a structured list row: optional media (usually an '
          'icon), required content (usually a title and description), and '
          'optional actions. The row carries a border option (normal, '
          'outline, muted) and an alignment override (center or top). Reach '
          'for it over a bare Row when the content has a standard shape and '
          'the container needs semantic consistency across several rows. '
          'ElItemGroup is the list wrapper: it enforces a vertical gap and '
          'stretches all children to the column width.',
      specimen: _PreviewSpecimen(),
      code: _previewCode,
      label: 'Item specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'item has a real registry manifest, `elattar add item` installs '
          'lib/src/components/item.dart and resolves source-foundation '
          'automatically. The Manual tab is for a project not using the '
          'CLI.',
      command: itemDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/item.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/item.dart's generated @ui/item.dart "
              'payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated item source here when using manual '
              'mode.',
        ),
        const DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElItem and the rest of the item '
              'family are reachable the same way the CLI path already '
              'makes them.',
          code: "export 'item.dart';",
        ),
      ],
    ),
    const SnippetSection(
      id: 'usage',
      title: 'Usage',
      description: 'A row in a group, or standalone.',
      code: _usageCode,
    ),
    const SnippetSection(
      id: 'composition',
      title: 'Composition',
      description:
          'ElItemGroup is a list wrapper, not a variant switch. Item\'s '
          'only real axis is ElItemVariant (see Variant below); '
          'alignStart is a bool, not an enum. A part tree, not a runnable '
          'snippet: there is nothing to stage live beyond the Preview '
          'specimen above.',
      code: _compositionTreeCode,
    ),
    const SnippetSection(
      id: 'item-vs-field',
      title: 'Item vs Field',
      description:
          'Both stack a label-like part over supporting text, and it is '
          'easy to reach for the wrong one. ElItem is a display row: '
          'media, a title, a description, and actions, with no form '
          'semantics and no validation state. ElField (documented on its '
          'own page) is a form control wrapper: it owns a label, a '
          'control, a description, and an error, wired so a screen reader '
          'announces them as one field with Semantics(hint:) and '
          'Semantics(validationResult:). Reach for ElItem for a '
          'notification, a search result, or a list row a user reads. '
          'Reach for ElField the moment the row holds something the user '
          'types into, checks, or submits. Nothing live to stage: this is '
          'a choice between two different widgets, not a state of one.',
      code: _itemVsFieldCode,
    ),
    ShowcaseSection(
      id: 'variant',
      title: 'Variant',
      description:
          'ElItemVariant is Item\'s only enum: no separate size axis '
          'exists (sm and xs are byte-identical to the default and were '
          'never built; see API Reference).',
      specimen: const _VariantSpecimen(),
      code: _variantCode,
      label: 'Variant specimen view',
    ),
    ShowcaseSection(
      id: 'icon',
      title: 'Icon',
      description:
          'ElItemMedia forces its child into a 16px square and, whenever '
          'the row carries a description, nudges it 2px down so it lines '
          "up with the title's cap height instead of the row's centre.",
      specimen: const _IconSpecimen(),
      code: _iconCode,
      label: 'Icon specimen view',
    ),
    ShowcaseSection(
      id: 'avatar',
      title: 'Avatar',
      description:
          'ElItemMedia takes any widget, including ElAvatar: passing '
          'sizePx: ElItemMedia.size keeps the fallback initials centred in '
          'the same 16px square an icon would occupy, instead of relying '
          'on the forced square to squash a larger default. (ElEmptyMedia, '
          'on the empty page, cannot do this: it only takes a glyph.)',
      specimen: const _AvatarSpecimen(),
      code: _avatarCode,
      label: 'Avatar specimen view',
    ),
    ShowcaseSection(
      id: 'group',
      title: 'Group',
      description:
          'ElItemGroup is the list wrapper: it enforces a vertical gap and '
          'stretches every row to the column width. The gap tightens from '
          '10px to a hidden 2.5px when the rows contain size=sm buttons, a '
          'CSS descendant-selector quirk reproduced as measured (see '
          'Theming).',
      specimen: const _GroupSpecimen(),
      code: _groupCode,
      label: 'Group specimen view',
    ),
    ShowcaseSection(
      id: 'rtl',
      title: 'RTL',
      description:
          'ElItem paints no direction-specific layout of its own: it '
          'sizes to its content and reads right-to-left under a plain '
          'Directionality, the same composition either way.',
      specimen: const _RtlSpecimen(),
      code: _rtlCode,
      label: 'RTL specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'One prop table per exported class, plus a static-tokens table '
          'for two of them. Every row below is a real constructor '
          'parameter, verified against lib/src/components/item.dart '
          'directly.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElItemGroup', anchor: 'api-elitemgroup'),
        DocsTocEntry(title: 'ElItem', anchor: 'api-elitem'),
        DocsTocEntry(title: 'ElItemVariant', anchor: 'api-elitemvariant'),
        DocsTocEntry(title: 'ElItemMedia', anchor: 'api-elitemmedia'),
        DocsTocEntry(title: 'ElItemContent', anchor: 'api-elitemcontent'),
        DocsTocEntry(title: 'ElItemTitle', anchor: 'api-elitemtitle'),
        DocsTocEntry(
          title: 'ElItemDescription',
          anchor: 'api-elitemdescription',
        ),
        DocsTocEntry(title: 'ElItemActions', anchor: 'api-elitemactions'),
      ],
      child: const _ApiReferenceContent(),
    ),
    const DisclosureSection(
      id: 'states',
      title: 'States',
      description:
          'ElItem and every part are static, presentational '
          'StatelessWidgets: none owns onPressed/enabled, a '
          'GestureDetector, a FocusNode, or an async flag.',
      child: DocsStateMatrix(facts: _stateFacts),
    ),
    DisclosureSection(id: 'accessibility', title: 'Accessibility', child: const _AccessibilityContent()),
    DisclosureSection(id: 'keyboard', title: 'Keyboard', child: const _KeyboardContent()),
    DisclosureSection(id: 'responsive', title: 'Responsive', child: const _ResponsiveContent()),
    DisclosureSection(id: 'dependencies', title: 'Dependencies', child: const _DependenciesContent()),
    DisclosureSection(id: 'theming', title: 'Theming', child: const _ThemingContent()),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: itemDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'none yet',
            description:
                'No dedicated unit test exists for item.dart in the '
                'package test suite as of this page.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/item_test.dart',
            description:
                'Covers this page: the API tables, live specimens, and '
                'both themes.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/item/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class ItemDocPage extends StatelessWidget {
  const ItemDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: itemDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / BASE',
      title: itemDoc.title,
      description: itemDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Item'),
    ],
    toc: itemDocSpec.toc,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('item-doc-article'),
      child: ComponentDocPage(spec: itemDocSpec, header: false),
    ),
  );
}

/* ── Showcase specimens ─────────────────────────────────────────────────── */

class _PreviewSpecimen extends StatelessWidget {
  const _PreviewSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('item-preview'),
    child: ElItem(
      media: ElItemMedia(
        child: ElIcon.lucide(
          ElLucide.messageSquare,
          size: ElIconSize.sm,
          tone: ElIconTone.normal,
        ),
      ),
      content: ElItemContent(
        children: <Widget>[
          const ElItemTitle('Draft response'),
          ElItemDescription('You started typing something here on August 14'),
        ],
      ),
      actions: ElItemActions(
        children: <Widget>[
          ElButton(
            variant: ElButtonVariant.ghost,
            size: ElButtonSize.sm,
            onPressed: () {},
            child: ElText('Edit', ElComponentType.buttonLabel),
          ),
        ],
      ),
    ),
  );
}

class _VariantSpecimen extends StatelessWidget {
  const _VariantSpecimen();

  @override
  Widget build(BuildContext context) => ElItemGroup(
    children: <Widget>[
      KeyedSubtree(
        key: const ValueKey<String>('item-example:variant-normal'),
        child: const ElItem(
          content: ElItemContent(
            children: <Widget>[
              ElItemTitle('Normal'),
              ElItemDescription('border-transparent: no border, no fill.'),
            ],
          ),
        ),
      ),
      KeyedSubtree(
        key: const ValueKey<String>('item-example:variant-outline'),
        child: const ElItem(
          variant: ElItemVariant.outline,
          content: ElItemContent(
            children: <Widget>[
              ElItemTitle('Outline'),
              ElItemDescription('A 1px border in theme.border.'),
            ],
          ),
        ),
      ),
      KeyedSubtree(
        key: const ValueKey<String>('item-example:variant-muted'),
        child: const ElItem(
          variant: ElItemVariant.muted,
          content: ElItemContent(
            children: <Widget>[
              ElItemTitle('Muted'),
              ElItemDescription('A semi-transparent muted fill.'),
            ],
          ),
        ),
      ),
    ],
  );
}

class _IconSpecimen extends StatelessWidget {
  const _IconSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('item-example:icon'),
    child: ElItem(
      media: ElItemMedia(
        child: ElIcon.lucide(
          ElLucide.bell,
          size: ElIconSize.sm,
          tone: ElIconTone.normal,
        ),
      ),
      content: const ElItemContent(
        children: <Widget>[
          ElItemTitle('New comment'),
          ElItemDescription('Sarah replied to your thread'),
        ],
      ),
    ),
  );
}

class _AvatarSpecimen extends StatelessWidget {
  const _AvatarSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('item-example:avatar'),
    child: ElItem(
      media: ElItemMedia(
        child: ElAvatar(fallback: 'JD', sizePx: ElItemMedia.size),
      ),
      content: const ElItemContent(
        children: <Widget>[
          ElItemTitle('Jordan Diaz'),
          ElItemDescription('Commented 2 hours ago'),
        ],
      ),
    ),
  );
}

class _GroupSpecimen extends StatelessWidget {
  const _GroupSpecimen();

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<String>('item-example:group'),
    child: ElItemGroup(
      children: <Widget>[
        ElItem(
          media: ElItemMedia(
            child: ElIcon.lucide(ElLucide.fileText, size: ElIconSize.sm),
          ),
          content: const ElItemContent(
            children: <Widget>[
              ElItemTitle('Quarterly report'),
              ElItemDescription('Jan 1 – Mar 31, 2026'),
            ],
          ),
        ),
        ElItem(
          media: ElItemMedia(
            child: ElIcon.lucide(ElLucide.download, size: ElIconSize.sm),
          ),
          content: const ElItemContent(
            children: <Widget>[ElItemTitle('Download Q4 data')],
          ),
          actions: ElItemActions(
            children: <Widget>[
              ElButton(
                variant: ElButtonVariant.ghost,
                size: ElButtonSize.sm,
                onPressed: () {},
                child: ElText('Manage', ElComponentType.buttonLabel),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _RtlSpecimen extends StatelessWidget {
  const _RtlSpecimen();

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: const KeyedSubtree(
      key: ValueKey<String>('rtl-example:item'),
      child: ElItem(
        content: ElItemContent(
          children: <Widget>[
            ElItemTitle('المستند النهائي'),
            ElItemDescription('تم التحديث اليوم'),
          ],
        ),
      ),
    ),
  );
}

const String _previewCode = '''ElItem(
  media: ElItemMedia(
    child: ElIcon.lucide(ElLucide.messageSquare, size: ElIconSize.sm),
  ),
  content: ElItemContent(
    children: [
      ElItemTitle('Draft response'),
      ElItemDescription('You started typing something here on August 14'),
    ],
  ),
  actions: ElItemActions(
    children: [
      ElButton(
        variant: ElButtonVariant.ghost,
        size: ElButtonSize.sm,
        onPressed: () {},
        child: ElText('Edit', ElComponentType.buttonLabel),
      ),
    ],
  ),
)''';

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

ElItemGroup(
  children: [
    ElItem(
      media: ElItemMedia(child: ElIcon.lucide(ElLucide.mail, size: ElIconSize.sm)),
      content: ElItemContent(
        children: [
          ElItemTitle('Inbox'),
          ElItemDescription('12 unread messages'),
        ],
      ),
      actions: ElItemActions(
        children: [
          ElButton(
            variant: ElButtonVariant.ghost,
            size: ElButtonSize.sm,
            onPressed: () {},
            child: ElText('Mark read', ElComponentType.buttonLabel),
          ),
        ],
      ),
    ),
  ],
)''';

const String _compositionTreeCode = '''ElItemGroup
└─ ElItem
   ├─ ElItemMedia      (optional)
   ├─ ElItemContent
   │  ├─ ElItemTitle
   │  └─ ElItemDescription
   └─ ElItemActions    (optional)''';

const String _itemVsFieldCode = '''// A display row: no form semantics, no validation state.
ElItem(
  media: ElItemMedia(child: ElIcon.lucide(ElLucide.bell, size: ElIconSize.sm)),
  content: ElItemContent(
    children: [
      ElItemTitle('New comment'),
      ElItemDescription('Sarah replied to your thread'),
    ],
  ),
)

// A form control wrapper: owns label, description, and error semantics.
ElField(
  label: 'Email',
  description: 'We will never share your email.',
  child: ElInput(controller: emailController),
)''';

const String _variantCode = '''ElItemGroup(
  children: [
    ElItem(
      content: ElItemContent(
        children: [
          ElItemTitle('Normal'),
          ElItemDescription('border-transparent: no border, no fill.'),
        ],
      ),
    ),
    ElItem(
      variant: ElItemVariant.outline,
      content: ElItemContent(
        children: [
          ElItemTitle('Outline'),
          ElItemDescription('A 1px border in theme.border.'),
        ],
      ),
    ),
    ElItem(
      variant: ElItemVariant.muted,
      content: ElItemContent(
        children: [
          ElItemTitle('Muted'),
          ElItemDescription('A semi-transparent muted fill.'),
        ],
      ),
    ),
  ],
)''';

const String _iconCode = '''ElItem(
  media: ElItemMedia(
    child: ElIcon.lucide(ElLucide.bell, size: ElIconSize.sm),
  ),
  content: ElItemContent(
    children: [
      ElItemTitle('New comment'),
      ElItemDescription('Sarah replied to your thread'),
    ],
  ),
)''';

const String _avatarCode = '''ElItem(
  media: ElItemMedia(
    child: ElAvatar(fallback: 'JD', sizePx: ElItemMedia.size),
  ),
  content: ElItemContent(
    children: [
      ElItemTitle('Jordan Diaz'),
      ElItemDescription('Commented 2 hours ago'),
    ],
  ),
)''';

const String _groupCode = '''ElItemGroup(
  children: [
    ElItem(
      media: ElItemMedia(child: ElIcon.lucide(ElLucide.fileText, size: ElIconSize.sm)),
      content: ElItemContent(
        children: [
          ElItemTitle('Quarterly report'),
          ElItemDescription('Jan 1 – Mar 31, 2026'),
        ],
      ),
    ),
    ElItem(
      media: ElItemMedia(child: ElIcon.lucide(ElLucide.download, size: ElIconSize.sm)),
      content: ElItemContent(children: [ElItemTitle('Download Q4 data')]),
      actions: ElItemActions(
        children: [
          ElButton(
            variant: ElButtonVariant.ghost,
            size: ElButtonSize.sm,
            onPressed: () {},
            child: ElText('Manage', ElComponentType.buttonLabel),
          ),
        ],
      ),
    ),
  ],
)''';

const String _rtlCode = '''Directionality(
  textDirection: TextDirection.rtl,
  child: ElItem(
    content: ElItemContent(
      children: [
        ElItemTitle('المستند النهائي'),
        ElItemDescription('تم التحديث اليوم'),
      ],
    ),
  ),
)''';

/* ── Disclosure content ─────────────────────────────────────────────────── */

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const DocsAnchor(
        id: 'api-elitemgroup',
        child: DocsApiTable(
          title: 'ElItemGroup',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'children',
              type: 'List<Widget>',
              description: 'Required. List rows, joined by a gap.',
            ),
            DocsApiFact(
              name: 'gapOverride',
              type: 'double?',
              description:
                  'Optional. Defaults to null, which keeps ElItemGroup.gap. '
                  'Overrides the gap for this group only.',
            ),
            DocsApiFact(
              name: 'ElItemGroup.gap',
              type: 'static double',
              description:
                  '10px between rows. Tightens to a hidden 2.5px when the '
                  'rows contain size=sm buttons: see Group above.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elitem',
        child: DocsApiTable(
          title: 'ElItem',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'media',
              type: 'Widget?',
              description:
                  'Optional. Defaults to null. Usually a ElItemMedia with '
                  'an icon or avatar. Sits at the row start.',
            ),
            DocsApiFact(
              name: 'content',
              type: 'Widget',
              description:
                  'Required. Usually ElItemContent with title and '
                  'description. Fills the middle space.',
            ),
            DocsApiFact(
              name: 'actions',
              type: 'Widget?',
              description:
                  'Optional. Defaults to null. Usually ElItemActions with '
                  'buttons. Sits at the row end.',
            ),
            DocsApiFact(
              name: 'variant',
              type: 'ElItemVariant',
              description:
                  'Optional. Defaults to ElItemVariant.normal. Selects the '
                  'border: see the ElItemVariant table below.',
            ),
            DocsApiFact(
              name: 'alignStart',
              type: 'bool',
              description:
                  'Optional. Defaults to false. When true, aligns media '
                  'and actions to the top instead of the centre.',
            ),
            DocsApiFact(
              name: 'ElItem.gap',
              type: 'static double',
              description: '10px between media, content, and actions.',
            ),
            DocsApiFact(
              name: 'ElItem.padding',
              type: 'static EdgeInsets',
              description: '12px horizontal, 10px vertical.',
            ),
            DocsApiFact(
              name: 'ElItem.radius',
              type: 'static double',
              description: '12px corners.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elitemvariant',
        child: DocsApiTable(
          title: 'ElItemVariant',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'normal',
              type: 'the default',
              description:
                  'A transparent 1px border: no visible border, no fill.',
            ),
            DocsApiFact(
              name: 'outline',
              type: 'enum value',
              description:
                  'A real 1px border in theme.border. The one real call '
                  "site in the corpus: the agent family's history card.",
            ),
            DocsApiFact(
              name: 'muted',
              type: 'enum value',
              description:
                  'A transparent border plus a 50%-alpha theme.muted '
                  'fill. Recorded, not built beyond the constant: no real '
                  'call site paints it yet.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elitemmedia',
        child: DocsApiTable(
          title: 'ElItemMedia',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'child',
              type: 'Widget',
              description:
                  'Required. Any widget: an icon or a ElAvatar are the two '
                  'real shapes in this corpus (see Icon and Avatar above). '
                  'Forced into a 16px square either way.',
            ),
            DocsApiFact(
              name: 'nudged',
              type: 'bool',
              description:
                  'Optional. Defaults to true. When the row carries a '
                  "description, pins the media to the top and drops it 2px "
                  "so it lines up with the title's cap height instead of "
                  "the row's centre.",
            ),
            DocsApiFact(
              name: 'ElItemMedia.size',
              type: 'static double',
              description: '16px, the forced glyph/avatar square.',
            ),
            DocsApiFact(
              name: 'ElItemMedia.nudge',
              type: 'static double',
              description: '2px, the top offset nudged applies.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elitemcontent',
        child: DocsApiTable(
          title: 'ElItemContent',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'children',
              type: 'List<Widget>',
              description:
                  'Required. Usually ElItemTitle and ElItemDescription, '
                  'joined by a 4px gap.',
            ),
            DocsApiFact(
              name: 'ElItemContent.gap',
              type: 'static double',
              description: '4px between children.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elitemtitle',
        child: DocsApiTable(
          title: 'ElItemTitle',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'text',
              type: 'String (positional)',
              description:
                  "Required. The row's heading. Clips to one line and "
                  'ellipsizes.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elitemdescription',
        child: DocsApiTable(
          title: 'ElItemDescription',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'text',
              type: 'String (positional)',
              description:
                  'Required. The supporting sentence, '
                  'theme.mutedForeground. Clips to two lines and '
                  'ellipsizes.',
            ),
          ],
        ),
      ),
      SizedBox(height: el(6)),
      const DocsAnchor(
        id: 'api-elitemactions',
        child: DocsApiTable(
          title: 'ElItemActions',
          facts: <DocsApiFact>[
            DocsApiFact(
              name: 'children',
              type: 'List<Widget>',
              description:
                  'Required. Buttons or other controls, joined by an 8px '
                  'gap.',
            ),
            DocsApiFact(
              name: 'ElItemActions.gap',
              type: 'static double',
              description: '8px between children.',
            ),
          ],
        ),
      ),
    ],
  );
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Semantic role: none of its own, ElItem, ElItemContent, and '
            'ElItemActions are plain Row/Column widgets with no Semantics '
            'wrapper.',
        'Text is not silent: ElItemTitle and ElItemDescription render '
            "through ElText, which carries Flutter's default static-text "
            'semantics: both are individually reachable by a screen '
            'reader.',
        "Actions inherit semantics from ElItemActions' children (buttons), "
            'which own their own focus and labels; see Keyboard for that '
            'story in full.',
        'ItemGroup carries `role="list"` in the reference; this port\'s '
            'ElItemGroup is a plain Column with no Semantics(container: '
            'true) or list-role marker of its own — a real, currently '
            'harmless gap, reported rather than silently fixed.',
        'Known platform differences: none observed.',
      ]);
}

/// Split out of Accessibility's own "Keyboard" bullet. Read straight off
/// `item.dart`: `ElItem`, `ElItemGroup`, and every part class are
/// `StatelessWidget`s with no `Focus`, `FocusNode`, or `GestureDetector` of
/// their own.
class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No keyboard behaviour of its own: ElItem and every part class '
            '(ElItemGroup, ElItemMedia, ElItemContent, ElItemTitle, '
            'ElItemDescription, ElItemActions) wire no Focus, FocusNode, '
            'or GestureDetector. None of them ever appears in Tab order.',
        'Whatever is focusable lives inside ElItemActions: when a caller '
            'places buttons or other interactive controls there (see '
            'Preview and Group above), those children own their own '
            'focus, activation, and key handling — the row around them '
            'contributes only layout.',
        'A row with no actions is not reachable by keyboard at all: '
            'there is nothing on it a screen-reader user can tab to '
            'beyond whatever static text ElItemTitle/ElItemDescription '
            'already expose.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'No responsive branching: renders identically across widths. '
            'Media is fixed-square, content fills flex space, actions are '
            'right-aligned or top-aligned depending on the alignStart '
            'flag.',
        'Long titles clip to one line and ellipsize; long descriptions '
            'clip to two.',
        'Platform parity: Android, iOS, Web, macOS, Windows, and Linux '
            'all render the same widget tree.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/components/item.dart, one file, no companions; '
            'the registry manifest lists exactly one entry under "files".',
        'Imports: foundation/colors.dart (elTransparent), '
            'foundation/spacing.dart, foundation/theme.dart, '
            'foundation/typography.dart, theme_scope.dart. '
            'ElItem.mutedFillAlpha (0.50) is a static const declared '
            'inside ElItem itself, not imported from colors.dart. No '
            'component or effect dependency.',
        'registryDependencies, resolved automatically by `elattar add '
            'item`: source-foundation only: copied verbatim from '
            'registry/components/item.json.',
        'Assets: none. Fonts: none beyond the system type scale every '
            'ElText call already depends on. Shaders: none.',
      ]);
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Borders use theme.border (variant=outline) or a transparent '
            'stroke (variant=normal/muted); the muted fill is theme.muted '
            'at 50% alpha (ElItem.mutedFillAlpha). Content text uses '
            'theme.foreground/mutedForeground from ElItemContent and '
            'ElItemDescription. All re-resolve on a live theme flip.',
        "The group gap drift, reproduced as measured: item.dart's own "
            'doc comment traces it to the reference\'s '
            '`has-data-[size=sm]:gap-2.5` rule, which is meant to read '
            '"when the *items* in me are small, tighten" but compiles to '
            '"when ANY descendant carries that attribute", so a row '
            'ending in a size=sm button tightens the WHOLE group\'s gap, '
            'not just that row. ElItemGroup.gap is 10px by default; a '
            'caller wanting the tightened 2.5px passes gapOverride '
            'explicitly, since Flutter has no descendant-selector '
            'equivalent to reproduce the quirk automatically.',
        'No colour-override parameter of its own on any class: every '
            'colour is theme- or variant-derived, never a bare Color '
            'argument.',
      ]);
}

Widget _bullets(ElThemeData theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText('•  $line', ElType.small, color: theme.mutedForeground),
      ),
      SizedBox(height: el(2)),
    ],
  ],
);

const List<DocsStateFact> _stateFacts = <DocsStateFact>[
  DocsStateFact(
    state: 'Rest',
    treatment:
        'Paints its variant border, the media icon or avatar, content '
        'rows, and action buttons.',
    userSignal: 'The resting paint is the only paint.',
  ),
  DocsStateFact(
    state: 'Loading / Error / Success / Disabled',
    treatment:
        'N/A: ElItem carries none of these as its own state. A caller '
        'renders a different row, or disables the buttons it places in '
        'ElItemActions itself.',
    userSignal:
        'Compose with a stateful control at the call site: ElItem does '
        'not.',
  ),
  DocsStateFact(
    state: 'Hover / Focus-visible / Pressed / Selected',
    treatment:
        'N/A for ElItem itself: no GestureDetector, FocusNode, or '
        'onPressed/enabled parameter. ElItemActions can *hold* '
        'interactive children (buttons) whose own states apply to them, '
        'not to the row.',
    userSignal: 'Compose with an interactive component at the call site.',
  ),
  DocsStateFact(
    state: 'Reduced motion',
    treatment:
        'N/A: no AnimationController and no motion token appears in '
        'item.dart.',
    userSignal: 'Nothing animates, so nothing needs to still.',
  ),
];
