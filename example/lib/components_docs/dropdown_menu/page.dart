/// Public component documentation for `DsDropdownMenu`
/// (`lib/src/components/dropdown_menu.dart`) **and** the shared menu engine
/// it is built from (`lib/src/components/menu.dart`) — one page, because
/// `menu.dart`'s own library doc names itself as "the shared body of
/// `dropdown-menu.tsx`, `context-menu.tsx` and `menubar.tsx`": it is not a
/// second component to choose between, it is the row model, geometry,
/// surface and keyboard behaviour [DsDropdownMenu] mounts. See
/// `meta.dart`'s own library doc for the full reasoning, which mirrors the
/// precedent `toggle/meta.dart` set for `toggle.dart` + `toggle_group.dart`.
///
/// `dropdownMenuDoc` (from `meta.dart`) is the data source, not
/// `componentDoc('dropdown-menu')` — dropdown-menu is not yet registered in
/// `catalog.dart`'s `componentDocs` list, so calling that would throw. Adding
/// it there is a supervisor-owned aggregation step (Phase J plan).
///
/// Two corrections against the task brief, both resolved in favour of the
/// real source, which is the documented source of truth here:
///
///  * **Enter/Space on a focused trigger does not open the menu.**
///    [DsMenuPointerDown] opens exclusively on a raw `PointerDownEvent`; a
///    button's own keyboard activation (`DsButton._onKey`) calls the
///    trigger's own `onPressed` directly, bypassing the `Listener` entirely.
///    Every real call site — this page's own specimen included — leaves that
///    `onPressed` a no-op, because the actual open mechanism lives one level
///    up. The Accessibility section documents this plainly, pinned by a live
///    test that focuses the trigger's real `FocusNode` and presses Enter.
///  * **A dropdown's own submenu renders `DsMenuSurfaceKind.subBordered`,
///    not `subRinged`.** `menu.dart`'s own DRIFT-4 comment table says a
///    `DropdownMenuSubContent` should carry `subRinged` (`shadow-lg ring-1`)
///    and only `ContextMenuSubContent` should carry `subBordered`
///    (`shadow-lg border`). But `_buildRow`'s `DsMenuSub` case maps **any**
///    `content`-kind parent to `subBordered`, and neither `DsDropdownMenu`
///    nor `context_menu.dart` nor `menubar.dart` ever passes a `kind`
///    override away from `DsMenuContent`'s own `content` default — so the
///    distinction the comment describes is not what the code does. The
///    Variants section documents this, pinned by a live test that opens a
///    submenu and reads the mounted `DsMenuSurface.kind` back.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/docs_code.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../kit.dart';
import '../catalog.dart';
import 'meta.dart';

class DropdownMenuDocPage extends StatelessWidget {
  const DropdownMenuDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    final ComponentDocEntry entry = dropdownMenuDoc;
    return DocsLayout(
      route: entry.route,
      intro: DocsPageIntro(
        eyebrow: 'COMPONENTS / BASE',
        title: entry.title,
        description: dropdownMenuExpandedDescription,
      ),
      breadcrumbs: const <DsBreadcrumbEntry>[
        DsBreadcrumbEntry.link('Components'),
        DsBreadcrumbEntry.page('Dropdown Menu'),
      ],
      sidebar: const <DocsSidebarEntry>[
        DocsSidebarEntry(title: 'Drawer', route: '/components/drawer'),
        DocsSidebarEntry(
          title: 'Dropdown Menu',
          route: '/components/dropdown-menu',
          selected: true,
        ),
        DocsSidebarEntry(title: 'Hover Card', route: '/components/hover-card'),
      ],
      toc: const <DocsTocEntry>[
        DocsTocEntry(title: 'Status', anchor: 'status'),
        DocsTocEntry(title: 'Preview', anchor: 'preview'),
        DocsTocEntry(title: 'Installation', anchor: 'install'),
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
      // Wave 3's alphabetical neighbours (Phase J plan inventory), skipping
      // `menu` — it is documented on this page rather than a page of its
      // own; see the library doc. Neither route is registered yet either —
      // the whole wave's previous/next chain is stitched together once the
      // supervisor aggregates every meta.dart.
      previous: const DocsPageLink(
        title: 'Drawer',
        route: '/components/drawer',
      ),
      next: const DocsPageLink(
        title: 'Hover Card',
        route: '/components/hover-card',
      ),
      onNavigate: onNavigate,
      child: _DropdownMenuArticle(entry: entry),
    );
  }
}

class _DropdownMenuArticle extends StatelessWidget {
  const _DropdownMenuArticle({required this.entry});

  final ComponentDocEntry entry;

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('dropdown-menu-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
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
                  'Ported and tested against lib/src/components/'
                  'dropdown_menu.dart and lib/src/components/menu.dart, the '
                  'shared row engine it and every other menu root mount. '
                  'Neither file has a manifest yet, so elattar add '
                  'dropdown-menu will not resolve — see Installation below.',
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
                  'A pure Flutter widget tree built on DsPopover’s '
                  'OverlayPortal — no platform channel and no '
                  'platform-specific branch in either file.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'preview',
        title: 'Preview',
        description:
            'A trigger button opens a real DsDropdownMenu built from every '
            'row shape menu.dart declares: a label, a group, a submenu, a '
            'checkbox row with live state, a radio group with live state, '
            'and a destructive item. Tap the trigger, or focus it and '
            'press Enter — only one of those two opens it; the '
            'Accessibility section says which and why.',
        child: DocsCodeExample(
          title: 'Dropdown menu specimen',
          description:
              'A real DsDropdownMenu, not a static mock — open it, pick a '
              'row, watch “Last action” update underneath.',
          preview: const _DropdownMenuPreview(),
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'install',
        title: 'Installation',
        description:
            'Command install is not available yet — read this before '
            'reaching for elattar add dropdown-menu.',
        child: DocsInstallFacts(
          facts: <DocsInstallFact>[
            const DocsInstallFact(
              label: 'CLI',
              value: 'Not available',
              description:
                  'dropdown-menu and its shared menu.dart engine are not '
                  'yet registry items, so `elattar add dropdown-menu` does '
                  'not open the door on its own — they are among the Wave '
                  '3 base components still awaiting a manifest. See the '
                  'Phase J documentation plan.',
            ),
            const DocsInstallFact(
              label: 'Manual — package mode (supported today)',
              value:
                  "import 'package:elattar_design_system/"
                  "elattar_design_system.dart';",
              description:
                  'Depend on the package and use DsDropdownMenu, '
                  'DsMenuItem, and the rest of the row model directly, '
                  'exactly as this page does.',
            ),
            DocsInstallFact(
              label: 'Manual — source mode (not recommended yet)',
              value: '${entry.sourcePath}, $menuSourcePath',
              description:
                  'Copying these two files will not compile on their own: '
                  'dropdown_menu.dart also imports button.dart and '
                  'popover.dart, and menu.dart imports icon.dart, '
                  'icon_paths.dart and icon_paths.g.dart. No manifest '
                  'exists yet to resolve any of it for you.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'usage',
        title: 'Usage',
        description:
            'The smallest correct example, then the two real shapes the '
            'account-menu and view-options patterns need: grouped commands '
            'with a destructive row, and checkbox / radio-group / submenu '
            'rows together.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DsPanel(
              label: 'DART',
              note: 'SMALLEST CORRECT EXAMPLE',
              child: DocsSelectableCodeBlock(code: _usageBasicCode),
            ),
            SizedBox(height: ds(5)),
            DsPanel(
              label: 'DART',
              note: 'GROUPED, WITH A DESTRUCTIVE ROW',
              child: DocsSelectableCodeBlock(code: _usageGroupedCode),
            ),
            SizedBox(height: ds(5)),
            DsPanel(
              label: 'DART',
              note: 'CHECKBOX, RADIO GROUP, SUBMENU',
              child: DocsSelectableCodeBlock(code: _usageCheckboxRadioSubCode),
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'api',
        title: 'API',
        description:
            'Every public class, enum, and constructor parameter declared '
            'in dropdown_menu.dart and menu.dart. Enum value tables live in '
            'Variants below, not here.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const DocsApiTable(
              title: 'DsMenuTriggerScope',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'open',
                  type: 'bool',
                  description:
                      "Required. aria-expanded — whether the menu under "
                      'this trigger is open. Published by DsDropdownMenu '
                      'and read back with the static openOf(context), which '
                      'DsButton.expanded resolves against so an open '
                      "trigger holds its hover fill after the pointer "
                      'leaves it.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsDropdownMenu',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'trigger',
                  type: 'Widget',
                  description:
                      "Required. The caller's own control, rendered "
                      'verbatim (DropdownMenuTrigger asChild) and wrapped '
                      'in DsMenuPointerDown and DsMenuTriggerScope.',
                ),
                DocsApiFact(
                  name: 'children',
                  type: 'List<DsMenuChild>',
                  description: "Required. DropdownMenuContent's own rows.",
                ),
                DocsApiFact(
                  name: 'width',
                  type: 'double?',
                  description:
                      'Default null. An explicit w-* on the content. Null '
                      "falls back to minWidth's floor (DsMenu."
                      "minWidthDropdown, 160, when minWidth is also null).",
                ),
                DocsApiFact(
                  name: 'align',
                  type: 'DsPopoverAlign',
                  description:
                      'Default DsPopoverAlign.start — the file’s '
                      'own default, not DsPopover’s own '
                      '(DsPopoverAlign.center).',
                ),
                DocsApiFact(
                  name: 'side',
                  type: 'DsPopoverSide',
                  description:
                      'Default DsPopoverSide.bottom. The sidebar’s own '
                      'account trigger passes DsPopoverSide.right when '
                      'there is no room under a 256px panel.',
                ),
                DocsApiFact(
                  name: 'enabled',
                  type: 'bool',
                  description:
                      'Default true. False keeps the popover permanently '
                      "closed and stops DsMenuPointerDown from forwarding "
                      "the trigger's own pointer-down at all.",
                ),
                DocsApiFact(
                  name: 'sideOffset',
                  type: 'static double (get)',
                  description:
                      'ds(1), 4px — one spacing unit under the '
                      'trigger, edges flush with align: start.',
                ),
                DocsApiFact(
                  name: 'pressScaleSuppressed',
                  type: 'static bool (get)',
                  description:
                      'Always true. Every DsDropdownMenu trigger suppresses '
                      'the press-scale a plain button takes, matching '
                      'aria-haspopup’s active:not-aria-[haspopup]:'
                      'scale-95.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsMenuItem',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'label',
                  type: 'String',
                  description: "Required. The row's text.",
                ),
                DocsApiFact(
                  name: 'icon',
                  type: 'DsIconGlyph?',
                  description:
                      "The leading glyph, forced to DsMenu.iconSize (16px) "
                      'regardless of the icon’s own default size.',
                ),
                DocsApiFact(
                  name: 'lucideIcon',
                  type: 'DsLucideGlyph?',
                  description:
                      'The same leading slot over the generated lucide '
                      'registry, for a glyph icon does not carry. Ignored '
                      'when icon is also given.',
                ),
                DocsApiFact(
                  name: 'subtitle',
                  type: 'String?',
                  description:
                      "A second line under label — gap-1, "
                      'flex-col items-start. Makes the row DsMenu.'
                      'twoLineItemHeight tall instead of DsMenu.itemHeight.',
                ),
                DocsApiFact(
                  name: 'shortcut',
                  type: 'String?',
                  description:
                      'MenuShortcut’s content — a key hint or a '
                      'real value, right-aligned, muted at rest.',
                ),
                DocsApiFact(
                  name: 'variant',
                  type: 'DsMenuItemVariant',
                  description:
                      'Default DsMenuItemVariant.normal. destructive '
                      'recolours the label, icon and shortcut to '
                      'destructiveInk and tints the highlight instead of '
                      'using accent.',
                ),
                DocsApiFact(
                  name: 'enabled',
                  type: 'bool',
                  description:
                      'Default true. False dims the row to DsMenu’s '
                      'disabled opacity (0.50) and removes it from the '
                      'roving-focus and typeahead set entirely.',
                ),
                DocsApiFact(
                  name: 'inset',
                  type: 'bool',
                  description:
                      'Default false. data-inset:pl-9 — a 36px '
                      'leading gutter so an icon-less row can line up '
                      'under rows that carry one.',
                ),
                DocsApiFact(
                  name: 'onSelect',
                  type: 'VoidCallback?',
                  description:
                      'Called on commit (tap, or Enter/Space while '
                      'highlighted); the menu closes immediately after.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsMenuCheckboxItem',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'label',
                  type: 'String',
                  description: 'Required.',
                ),
                DocsApiFact(
                  name: 'checked',
                  type: 'bool',
                  description:
                      "Required. The tick's ItemIndicator mounts only "
                      'while this is true — an unchecked row holds no '
                      'indicator element at all, not merely a hidden one.',
                ),
                DocsApiFact(
                  name: 'enabled',
                  type: 'bool',
                  description:
                      'Default true. Same effect as DsMenuItem.enabled.',
                ),
                DocsApiFact(
                  name: 'inset',
                  type: 'bool',
                  description: 'Default false.',
                ),
                DocsApiFact(
                  name: 'onSelect',
                  type: 'ValueChanged<bool>?',
                  description:
                      'Called on commit with what the row would become '
                      '(!checked). The menu still closes after, even with '
                      'onSelect left null — a controlled row with no '
                      'handler, the same pattern DsSelect’s own S4 '
                      'precedent names.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsMenuRadioItem',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'value',
                  type: 'String',
                  description: 'Required. What onChanged is called with.',
                ),
                DocsApiFact(
                  name: 'label',
                  type: 'String',
                  description: 'Required.',
                ),
                DocsApiFact(
                  name: 'enabled',
                  type: 'bool',
                  description: 'Default true.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsMenuRadioGroup',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'value',
                  type: 'String?',
                  description:
                      'Which child’s value wears the tick. Null shows '
                      'no row as checked.',
                ),
                DocsApiFact(
                  name: 'children',
                  type: 'List<DsMenuRadioItem>',
                  description: 'Required.',
                ),
                DocsApiFact(
                  name: 'onChanged',
                  type: 'ValueChanged<String>?',
                  description:
                      'Called on commit with the tapped row’s value. '
                      'Null is the same controlled-no-handler shape as '
                      'DsMenuCheckboxItem.onSelect.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsMenuLabel',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'text',
                  type: 'String',
                  description:
                      "Required, positional. Ignored when child is given.",
                ),
                DocsApiFact(
                  name: 'child',
                  type: 'Widget?',
                  description:
                      "The label's own children for a multi-line block "
                      "(a name over a caption). Still sits inside the "
                      'label’s own px-3 py-2.',
                ),
                DocsApiFact(
                  name: 'inset',
                  type: 'bool',
                  description: 'Default false.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            DsPanel(
              label: 'DsMenuSeparator',
              child: DsText(
                'DsMenuSeparator takes no constructor parameters at all '
                '— const DsMenuSeparator() is the whole of it. It '
                'paints a single 1px rule at DsMenu.separatorHeight (17), '
                'running the full content width by cancelling the '
                'content’s own p-2 with a negative margin.',
                DsType.small,
              ),
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsMenuGroup',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'children',
                  type: 'List<DsMenuChild>',
                  description:
                      "Required. A role=\"group\" wrapper that paints "
                      'nothing — its rows sit flush with the rows '
                      'outside it, with no gap of its own.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsMenuSub',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'label',
                  type: 'String',
                  description: 'Required. The sub-trigger row’s text.',
                ),
                DocsApiFact(
                  name: 'children',
                  type: 'List<DsMenuChild>',
                  description: "Required. The submenu's own rows.",
                ),
                DocsApiFact(
                  name: 'icon',
                  type: 'DsIconGlyph?',
                  description: 'The sub-trigger’s own leading glyph.',
                ),
                DocsApiFact(
                  name: 'enabled',
                  type: 'bool',
                  description: 'Default true.',
                ),
                DocsApiFact(
                  name: 'inset',
                  type: 'bool',
                  description: 'Default false.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsMenuContent',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'children',
                  type: 'List<DsMenuChild>',
                  description: 'Required.',
                ),
                DocsApiFact(
                  name: 'onClose',
                  type: 'VoidCallback',
                  description:
                      'Required. Dismisses the whole menu — a '
                      'committed row, Escape at the top level, or a '
                      'pointer outside.',
                ),
                DocsApiFact(
                  name: 'width',
                  type: 'double?',
                  description: 'An explicit w-* on this content.',
                ),
                DocsApiFact(
                  name: 'minWidth',
                  type: 'double?',
                  description:
                      'Null takes DsMenu.minWidthMenu (144). '
                      'DsDropdownMenu itself always passes DsMenu.'
                      'minWidthDropdown (160) here.',
                ),
                DocsApiFact(
                  name: 'kind',
                  type: 'DsMenuSurfaceKind',
                  description:
                      'Default DsMenuSurfaceKind.content — see '
                      'Variants for what a submenu actually resolves to.',
                ),
                DocsApiFact(
                  name: 'indicatorSide',
                  type: 'DsMenuIndicatorSide',
                  description:
                      'Default DsMenuIndicatorSide.end. DsDropdownMenu '
                      'never overrides this — start is reachable only '
                      'from a menubar, documented here because it is '
                      'declared in this same file.',
                ),
                DocsApiFact(
                  name: 'autofocus',
                  type: 'bool',
                  description:
                      'Default true. False for a submenu opened by hover: '
                      'the keyboard stays on the parent’s trigger '
                      'until ArrowRight or Enter promotes it.',
                ),
                DocsApiFact(
                  name: 'initialHighlight',
                  type: 'int',
                  description:
                      'Default -1, Radix’s own "nothing focused yet". '
                      'DsDropdownMenu never overrides this either — '
                      'see the Accessibility section for what that means '
                      'in practice.',
                ),
                DocsApiFact(
                  name: 'onEscape',
                  type: 'VoidCallback?',
                  description:
                      'Escape while this content has focus. Null routes '
                      'to onClose; a submenu passes its own so Escape '
                      'closes exactly one level.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsMenuSurface',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'child',
                  type: 'Widget',
                  description: 'Required.',
                ),
                DocsApiFact(
                  name: 'kind',
                  type: 'DsMenuSurfaceKind',
                  description: 'Default DsMenuSurfaceKind.content.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsMenuPointerDown',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'child',
                  type: 'Widget',
                  description: 'Required.',
                ),
                DocsApiFact(
                  name: 'onPointerDown',
                  type: 'VoidCallback',
                  description:
                      'Required. Fired on a raw PointerDownEvent — '
                      'never on a tap, a click, or a keyboard activation.',
                ),
                DocsApiFact(
                  name: 'enabled',
                  type: 'bool',
                  description: 'Default true. False renders child untouched.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsMenuMotion',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'duration',
                  type: 'static Duration (get)',
                  description: 'DsDurations.overlay, 320ms.',
                ),
                DocsApiFact(
                  name: 'slideSides',
                  type: 'static Set<DsPopoverSide> (get)',
                  description:
                      'All four DsPopoverSide values — the overlay '
                      'slides in from whichever side it actually lands on.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsMenu — static geometry',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'itemHeight',
                  type: 'static double (get)',
                  description: 'py-2 around one text-sm line box — 34.5714.',
                ),
                DocsApiFact(
                  name: 'twoLineItemHeight',
                  type: 'static double (get)',
                  description:
                      'A row carrying subtitle — 52.7464 '
                      '(itemHeight + gap-1 + a caption line box).',
                ),
                DocsApiFact(
                  name: 'labelHeight',
                  type: 'static double (get)',
                  description: 'DsMenuLabel’s own row — 32.',
                ),
                DocsApiFact(
                  name: 'separatorHeight',
                  type: 'static double (get)',
                  description: 'my-2 h-px — 17.',
                ),
                DocsApiFact(
                  name: 'contentPadding',
                  type: 'static double (get)',
                  description: 'p-2 on the content box — 8.',
                ),
                DocsApiFact(
                  name: 'minWidthDropdown',
                  type: 'static double (get)',
                  description: 'min-w-40 — 160.',
                ),
                DocsApiFact(
                  name: 'minWidthMenu',
                  type: 'static double (get)',
                  description: 'min-w-36 — 144.',
                ),
                DocsApiFact(
                  name: 'minWidthSub',
                  type: 'static double (get)',
                  description: 'min-w-40 — 160, unreachable from this page.',
                ),
                DocsApiFact(
                  name: 'minWidthSubDropdown',
                  type: 'static double (get)',
                  description:
                      'min-w-24 — 96, the one dropdown-specific '
                      'sub-content floor. Unreachable from this page’s '
                      'own specimen (no dropdown submenu passes it).',
                ),
                DocsApiFact(
                  name: 'insetPadding',
                  type: 'static double (get)',
                  description: 'data-inset:pl-9 — 36.',
                ),
                DocsApiFact(
                  name: 'iconSize',
                  type: 'static double (get)',
                  description: 'Every row icon is forced into this box — 16.',
                ),
                DocsApiFact(
                  name: 'iconStroke',
                  type: 'static double (get)',
                  description:
                      'The stroke width a size="sm" icon derives, kept '
                      'while iconSize overrules the box itself.',
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'variants',
        title: 'Variants',
        description:
            'Three enums, and one GAP between what a comment in the '
            'source promises and what the code actually renders for a '
            'dropdown’s own submenu.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const DocsApiTable(
              title: 'DsMenuItemVariant',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'normal',
                  type: 'DsMenuItemVariant',
                  description:
                      'The default. accent fill, popoverForeground ink.',
                ),
                DocsApiFact(
                  name: 'destructive',
                  type: 'DsMenuItemVariant',
                  description:
                      'destructiveInk label/icon/shortcut in every state; a '
                      'highlighted row tints with destructive at 10% '
                      '(light) / 20% (dark) instead of accent.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsMenuIndicatorSide',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'end',
                  type: 'DsMenuIndicatorSide',
                  description:
                      'py-2 pr-9 pl-3, tick at right-3. What every row this '
                      'page’s specimen renders uses — '
                      'DsDropdownMenu never changes DsMenuContent’s '
                      'own end default.',
                ),
                DocsApiFact(
                  name: 'start',
                  type: 'DsMenuIndicatorSide',
                  description:
                      'py-2 pr-3 pl-9, tick at left-1.5 — the '
                      'menubar’s own mirror image, alone. Declared '
                      'here because it lives in menu.dart; not reachable '
                      'from DsDropdownMenu itself.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            const DocsApiTable(
              title: 'DsMenuSurfaceKind',
              facts: <DocsApiFact>[
                DocsApiFact(
                  name: 'content',
                  type: 'DsMenuSurfaceKind',
                  description:
                      'shadow-md ring-1 ring-foreground/10 — what '
                      'every top-level DsMenuContent renders with, '
                      'DsDropdownMenu’s own content included.',
                ),
                DocsApiFact(
                  name: 'subRinged',
                  type: 'DsMenuSurfaceKind',
                  description:
                      'shadow-lg ring-1 ring-foreground/10. Declared, and '
                      'reachable if a caller builds DsMenuContent directly '
                      'and passes it — but nothing in this file ever '
                      'does. See the GAP note below.',
                ),
                DocsApiFact(
                  name: 'subBordered',
                  type: 'DsMenuSurfaceKind',
                  description:
                      'shadow-lg border, no ring. What a DsDropdownMenu '
                      'submenu actually renders — see the GAP note '
                      'below.',
                ),
              ],
            ),
            SizedBox(height: ds(5)),
            DsNote(
              tone: DsNoteTone.error,
              title:
                  'GAP — a dropdown’s own submenu is subBordered, '
                  'not subRinged',
              child: DsText(
                'menu.dart’s own DRIFT-4 comment table names '
                'DropdownMenuSubContent and MenubarSubContent as '
                'shadow-lg ring-1 (subRinged), and ContextMenuSubContent '
                'alone as shadow-lg border (subBordered). The code does '
                'not draw that distinction: _buildRow’s DsMenuSub '
                'case maps ANY content-kind parent to subBordered '
                '(`kind: widget.kind == DsMenuSurfaceKind.content ? '
                'DsMenuSurfaceKind.subBordered : widget.kind`), and '
                'DsDropdownMenu never passes a kind override away from '
                'DsMenuContent’s own content default — confirmed '
                'by reading dropdown_menu.dart’s content builder, '
                'which passes children, width, minWidth and onClose only. '
                'A live test on this page opens the specimen’s '
                '“Invite users” submenu and reads the mounted '
                'DsMenuSurface.kind back as subBordered, pinning this as '
                'observed behaviour rather than a reading of the comment.',
                DsType.small,
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'states',
        title: 'States and feedback',
        description:
            'Rows that do not apply to this synchronous, pointer/keyboard '
            'driven primitive are marked N/A with the reason, rather than '
            'invented.',
        child: const DocsStateMatrix(
          facts: <DocsStateFact>[
            DocsStateFact(
              state: 'Rest',
              treatment:
                  'DsMenuContent is not mounted; only the trigger renders.',
              userSignal: 'Nothing besides the trigger is on screen.',
            ),
            DocsStateFact(
              state: 'Hover',
              treatment:
                  'A pointer resting on a row snaps — transition-'
                  'duration: 0s in the source — to theme.accent fill '
                  'and theme.accentForeground ink, recolouring the icon '
                  'and shortcut too. Resting on a sub-trigger additionally '
                  'schedules its submenu to open 100ms later.',
              userSignal: 'The row highlights instantly, no fade.',
            ),
            DocsStateFact(
              state: 'Focus-visible',
              treatment:
                  'There is no per-row FocusNode and no separate focus '
                  'ring — one Focus wraps the whole content, and a '
                  'roving _highlighted index (ArrowUp/Down/Home/End, no '
                  'wrap) paints the identical accent fill hover uses. A '
                  'keyboard-highlighted row and a pointer-hovered row are '
                  'visually identical.',
              userSignal: 'Same highlight as Hover, moved by the keyboard.',
            ),
            DocsStateFact(
              state: 'Pressed',
              treatment:
                  'A row commits on a normal GestureDetector tap (release, '
                  'not pointer-down) — unlike the trigger itself, '
                  'which opens on pointer-down. No row carries a separate '
                  'pressed visual beyond the highlight it already has.',
              userSignal: 'onSelect fires and the menu closes, no extra dip.',
            ),
            DocsStateFact(
              state: 'Selected',
              treatment:
                  'A checked DsMenuCheckboxItem or the active '
                  'DsMenuRadioItem mounts a real check glyph inside its '
                  'own Stack; an unchecked row holds no indicator element '
                  'at all, not merely a hidden one.',
              userSignal: 'A 16px tick appears in the row’s gutter.',
            ),
            DocsStateFact(
              state: 'Loading',
              treatment:
                  'N/A — onSelect / onChanged are synchronous '
                  'callbacks; the API has no async or loading affordance '
                  'anywhere in either file.',
              userSignal: 'N/A',
            ),
            DocsStateFact(
              state: 'Empty',
              treatment:
                  'Not a designed state rather than a guarded one — '
                  'children: <DsMenuChild>[] renders a popup that is only '
                  'its own p-2 twice (16px), with no placeholder.',
              userSignal: 'A near-empty 16px popup, with no explanation.',
            ),
            DocsStateFact(
              state: 'Error',
              treatment:
                  'N/A — no validation or error concept exists in '
                  'either file.',
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
                  'DsDropdownMenu.enabled: false keeps _isOpen permanently '
                  'false and stops DsMenuPointerDown forwarding the '
                  'trigger’s pointer-down at all. Per-row enabled: '
                  'false instead dims just that row to 0.50 opacity and '
                  'drops it from the roving-focus and typeahead set.',
              userSignal:
                  'A disabled root never opens; a disabled row is dim and '
                  'inert but its siblings still work.',
            ),
            DocsStateFact(
              state: 'Reduced motion',
              treatment:
                  'DsPopover resolves its 320ms enter/exit through '
                  'dsAnimationDuration(context, DsDurations.overlay), so '
                  'reduced motion collapses it. The per-row highlight was '
                  'already an instant snap (0s) with nothing to reduce.',
              userSignal:
                  'The menu still opens and closes, just without animated '
                  'travel.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
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
                  const _A11yRow(
                    'Semantic role',
                    'The open menu itself carries no Semantics container, '
                        'role, or label of its own — no equivalent of '
                        'role="menu", and no aria-activedescendant '
                        'relationship. Only individual rows carry real '
                        'semantics: Semantics(button: true, selected: '
                        'checked, enabled: enabled, label: ...) from '
                        '_MenuRow in menu.dart.',
                  ),
                  const _A11yRow(
                    'Required labels',
                    'A row’s accessible name is its own label text '
                        '(and subtitle, concatenated, on a two-line row). '
                        'The trigger’s accessible name is whatever '
                        'DsButton.label the caller supplies — nothing '
                        'here supplies one automatically.',
                  ),
                  const _A11yRow(
                    'Keyboard interactions — once the menu is open',
                    'ArrowDown / ArrowUp move the highlight one row; Home / '
                        'End jump to the first / last — none of them '
                        'wrap, unlike DsSelect’s own menu. ArrowRight '
                        'opens a highlighted sub-trigger’s submenu and '
                        'focuses its first row; ArrowLeft closes one '
                        'submenu level and returns focus to its trigger. '
                        'Enter, NumpadEnter and Space commit the '
                        'highlighted row. Escape closes one submenu level, '
                        'or the whole menu at the top level. Tab closes the '
                        'whole menu outright, rather than moving focus '
                        'onward the way Tab ordinarily does. Any single '
                        'printable character drives real typeahead: it '
                        'jumps to the next row whose text starts with what '
                        'was typed, repeated presses of one letter cycle '
                        'through every match, and the buffer resets after '
                        '1 second idle.',
                  ),
                  _A11yRow(
                    'Keyboard interactions — opening the menu',
                    'GAP: Enter or Space on a focused trigger does not '
                        'open the menu — only a real pointer down '
                        'does. DsMenuPointerDown is a bare Listener that '
                        'reacts exclusively to PointerDownEvent; a '
                        'DsButton’s own keyboard activation '
                        '(DsButton._onKey, on Enter/Space) calls the '
                        'trigger’s own onPressed directly and never '
                        'touches that Listener. Every real call site '
                        '— this page’s own specimen included '
                        '— leaves that onPressed a no-op, because the '
                        'actual open mechanism lives one widget above it. '
                        'By the same mechanism, an assistive activation '
                        'that also routes through Semantics’ tap '
                        'action rather than a literal pointer contact '
                        '— VoiceOver or TalkBack’s '
                        'double-tap-to-activate, external switch control '
                        '— would call the same no-op and not open the '
                        'menu either; that inference follows from the same '
                        'source read rather than from testing against a '
                        'real screen reader in this environment. Pinned by '
                        'a live test that requests focus on the trigger’s '
                        'real FocusNode and sends Enter directly.',
                  ),
                  const _A11yRow(
                    'Focus behavior',
                    'DsMenuContent takes focus itself the frame after it '
                        'mounts (autofocus: true by default — false '
                        'only for a submenu opened by hover, until '
                        'ArrowRight or Enter promotes it). Nothing in '
                        'either file returns focus to the trigger when the '
                        'menu closes: the only two requestFocus calls in '
                        'menu.dart are that initial autofocus, and moving '
                        'focus back to a parent submenu’s own content '
                        'when one level closes — neither reaches back '
                        'out to the original trigger widget.',
                  ),
                  const _A11yRow(
                    'Touch target',
                    'DsMenu.itemHeight is ≈34.57px — below the '
                        '44 / 48px baseline most touch-target guidance '
                        'names — and is not configurable per row or '
                        'per instance.',
                  ),
                  const _A11yRow(
                    'Non-color signal',
                    'A checked row pairs its tick with the row’s own '
                        'label text, never color alone. A destructive row '
                        'pairs its tint with destructiveInk text and the '
                        'word itself ("Log out", "Delete"), not a colour '
                        'shift on its own.',
                  ),
                  const _A11yRow(
                    'Error wiring',
                    'None — no row in either file participates in '
                        'form validation or an error state.',
                  ),
                  const _A11yRow(
                    'Screen-reader announcements',
                    'Opening or closing the menu announces nothing as an '
                        'event — there is no scoped route/live-region '
                        'behaviour. Individual rows are real Semantics '
                        'nodes and are swipe-discoverable once the menu is '
                        'open, but the keyboard-open gap above means a '
                        'keyboard-only screen-reader user may never reach '
                        'that point in the first place.',
                  ),
                  _A11yRow(
                    'Known platform differences',
                    'None observed in the paint or gesture logic — '
                        'the open mechanism is routed by raw pointer '
                        'events, not by platform, and behaves identically '
                        'on a touch tap and a mouse click.',
                    last: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'responsive',
        title: 'Responsive and platform behavior',
        description:
            'Opening is routed by pointer-down regardless of device kind; '
            'once open, every row interaction — tap, arrow keys, '
            'typeahead — works identically on touch, mouse, and '
            'keyboard, with the single exception documented above.',
        child: DsPanel(
          label: 'Touch versus pointer versus keyboard',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DsText(
                'A submenu’s hover-open path (100ms after the pointer '
                'enters its trigger) has no touch equivalent — there '
                'is no hover on a touch screen — but every '
                'DsMenuSub row also carries a real onTap that opens it '
                'directly, so a tap reaches the same submenu a mouse '
                'hover does, just without the dwell.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'Row height (DsMenu.itemHeight, ≈34.57px), the '
                'content’s min-width floor (DsMenu.minWidthDropdown, '
                '160), and every other geometry constant are fixed values '
                '— none scale with platform, density, or text-scale '
                'settings.',
                DsType.small,
              ),
              SizedBox(height: ds(3)),
              DsText(
                'DsPopover’s own collision handling (not part of '
                'this file) is what keeps the popup on-screen when the '
                'trigger sits near a viewport edge — nothing in '
                'dropdown_menu.dart or menu.dart repeats that logic.',
                DsType.small,
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'dependencies',
        title: 'Dependencies, files, and disclosure',
        description:
            "Elattar's own technical-transparency panel — what these "
            'two files need to install and run.',
        child: DocsInstallFacts(
          facts: <DocsInstallFact>[
            const DocsInstallFact(
              label: 'Registry item',
              value: 'none yet',
              description:
                  'No registry/components/dropdown-menu.json or menu.json '
                  'exists — elattar add dropdown-menu is not yet '
                  'wired to anything.',
            ),
            DocsInstallFact(
              label: 'Destination (once a manifest exists)',
              value:
                  'lib/components/ui/dropdown_menu.dart, '
                  'lib/components/ui/menu.dart',
              description:
                  'The same lib/components/ui/ target every component '
                  'installs to, in both foundation modes — both '
                  'files would need to land together.',
            ),
            const DocsInstallFact(
              label: 'Foundation',
              value: 'source or package compatible',
              description:
                  'Nothing observed in either file is package-mode-only.',
            ),
            DocsInstallFact(
              label: 'Dependencies',
              value: entry.dependencies.join(', '),
              description:
                  'Real lib/src/components/ siblings both files import '
                  '— button.dart and popover.dart from '
                  'dropdown_menu.dart, and icon.dart (plus the generated '
                  'icon_paths files) and popover.dart from menu.dart '
                  '— not a verified registry list, since neither '
                  'file has a manifest.',
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
                  'test/menus_test.dart’s DsMenu geometry and '
                  'DsDropdownMenu groups, plus this page’s own live '
                  'open / activate / dismiss / keyboard-gap / '
                  'submenu-surface specimens. No fixture install was run, '
                  'since no manifest exists to install.',
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'composition',
        title: 'Composition example',
        description:
            'A row-actions menu — the shape an ellipsis trigger at '
            'the end of a data-table row actually needs: align: end so '
            'the popup does not overhang the row, and a destructive item '
            'set apart by a separator.',
        child: const DocsCodeExample(
          title: 'Row-actions composition',
          preview: _DropdownMenuComposition(),
        ),
      ),
      SizedBox(height: ds(6)),
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
                    'DsMenuSurface wraps DsPopoverSurface, so the '
                    'content’s fill and ink are theme.popover / '
                    'theme.popoverForeground — the same pairing '
                    'every popover-family surface uses, not a menu-'
                    'specific pair.',
                    DsType.small,
                  ),
                  SizedBox(height: ds(3)),
                  DsText(
                    'A highlighted normal row fills with theme.accent and '
                    'inks with theme.accentForeground. A highlighted '
                    'destructive row instead fills with theme.destructive '
                    'at 10% alpha on light / 20% on dark, and keeps '
                    'theme.destructiveInk for its label, icon and '
                    'shortcut in every state, not only while highlighted.',
                    DsType.small,
                  ),
                  SizedBox(height: ds(3)),
                  DsText(
                    'theme.border draws every separator; theme.'
                    'mutedForeground draws a label’s text, a row’s '
                    'subtitle, and a shortcut at rest. Nothing here reads '
                    'a value or surface variant — DsMenuItem carries '
                    'no such parameter.',
                    DsType.small,
                  ),
                  SizedBox(height: ds(3)),
                  DsText(
                    'The elevation recipe (DsMenuSurfaceKind) is the one '
                    'part of the surface that is not purely color '
                    '— see the GAP note in Variants for what a '
                    'DsDropdownMenu submenu actually renders with.',
                    DsType.small,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: ds(6)),
      DsSection(
        id: 'source',
        title: 'Source and tests',
        child: DocsInstallFacts(
          title: 'Source and tests',
          facts: <DocsInstallFact>[
            DocsInstallFact(
              label: 'Source — the trigger root',
              value: entry.sourcePath,
              description: 'DsDropdownMenu and DsMenuTriggerScope.',
            ),
            DocsInstallFact(
              label: 'Source — the shared engine',
              value: menuSourcePath,
              description:
                  'The row model, geometry, surface and keyboard behaviour '
                  'every menu root — dropdown, context menu, menubar '
                  '— mounts identically.',
            ),
            const DocsInstallFact(
              label: 'GitHub — dropdown_menu.dart',
              value:
                  'github.com/ELATTAR-Ayoub/flutter-design-system/blob/'
                  'main/lib/src/components/dropdown_menu.dart',
              description: 'The authoritative trigger-root source.',
            ),
            const DocsInstallFact(
              label: 'GitHub — menu.dart',
              value:
                  'github.com/ELATTAR-Ayoub/flutter-design-system/blob/'
                  'main/lib/src/components/menu.dart',
              description: 'The authoritative shared-engine source.',
            ),
            const DocsInstallFact(
              label: 'Tests',
              value: 'test/menus_test.dart',
              description:
                  'Package-level behavioral coverage: DsMenu geometry, '
                  'and the full DsDropdownMenu group — opening, '
                  'placement, highlighting, typeahead, Escape, checkbox '
                  'and radio commit, submenu timing and barrier behaviour.',
            ),
            const DocsInstallFact(
              label: 'Docs specimen',
              value: 'example/test/components_docs/dropdown_menu_test.dart',
              description:
                  "This page's own responsive, theme, API-completeness, "
                  'and live open / activate / dismiss / keyboard-gap / '
                  'submenu-surface coverage.',
            ),
          ],
        ),
      ),
    ],
  );
}

const String _usageBasicCode = '''DsDropdownMenu(
  trigger: DsButton(
    variant: DsButtonVariant.outline,
    label: 'Open menu',
    suppressPressScale: true,
    onPressed: () {},
    child: const DsText('Open menu', DsComponentType.buttonLabel),
  ),
  children: <DsMenuChild>[
    DsMenuItem(label: 'Edit', onSelect: () {}),
    DsMenuItem(label: 'Duplicate', onSelect: () {}),
    const DsMenuSeparator(),
    DsMenuItem(
      label: 'Delete',
      variant: DsMenuItemVariant.destructive,
      onSelect: () {},
    ),
  ],
)''';

const String _usageGroupedCode = '''DsDropdownMenu(
  width: ds(60),
  trigger: accountTrigger, // the caller's own control, rendered as-is
  children: <DsMenuChild>[
    const DsMenuLabel('My Account'),
    const DsMenuSeparator(),
    DsMenuGroup(children: <DsMenuChild>[
      DsMenuItem(
        label: 'Profile',
        icon: DsIconGlyph.user,
        shortcut: '⇧⌘P',
        onSelect: openProfile,
      ),
      DsMenuItem(
        label: 'Billing',
        icon: DsIconGlyph.creditCard,
        shortcut: '⌘B',
        onSelect: openBilling,
      ),
    ]),
    const DsMenuSeparator(),
    DsMenuItem(
      label: 'Log out',
      icon: DsIconGlyph.logOut,
      variant: DsMenuItemVariant.destructive,
      onSelect: signOut,
    ),
  ],
)''';

const String _usageCheckboxRadioSubCode = '''DsDropdownMenu(
  trigger: viewOptionsTrigger,
  children: <DsMenuChild>[
    DsMenuCheckboxItem(
      label: 'Show status bar',
      checked: showStatusBar,
      onSelect: (bool next) => setState(() => showStatusBar = next),
    ),
    const DsMenuSeparator(),
    DsMenuRadioGroup(
      value: panelPosition,
      onChanged: (String next) => setState(() => panelPosition = next),
      children: const <DsMenuRadioItem>[
        DsMenuRadioItem(value: 'left', label: 'Panel on left'),
        DsMenuRadioItem(value: 'right', label: 'Panel on right'),
      ],
    ),
    const DsMenuSeparator(),
    DsMenuSub(
      label: 'Invite users',
      icon: DsIconGlyph.plus,
      children: <DsMenuChild>[
        DsMenuItem(label: 'Email', onSelect: inviteByEmail),
        DsMenuItem(label: 'Message', onSelect: inviteByMessage),
      ],
    ),
  ],
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

/// The live specimen: every real row shape menu.dart declares, wired to
/// genuine state so a checkbox and a radio group truly toggle rather than
/// standing in for the reference’s own controlled-with-no-handler rows.
class _DropdownMenuPreview extends StatefulWidget {
  const _DropdownMenuPreview();

  @override
  State<_DropdownMenuPreview> createState() => _DropdownMenuPreviewState();
}

class _DropdownMenuPreviewState extends State<_DropdownMenuPreview> {
  String _lastAction = 'none yet';
  bool _statusBar = false;
  String _panel = 'left';

  void _act(String action) => setState(() => _lastAction = action);

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DsDropdownMenu(
          width: ds(60),
          trigger: Builder(
            builder: (BuildContext triggerContext) => DsButton(
              key: const ValueKey<String>('dropdown-menu-doc-specimen-trigger'),
              variant: DsButtonVariant.outline,
              label: 'Account menu',
              suppressPressScale: true,
              expanded: DsMenuTriggerScope.openOf(triggerContext),
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const DsIcon(DsIconGlyph.user, size: DsIconSize.sm),
                  SizedBox(width: ds(2)),
                  DsText('Account menu', DsComponentType.buttonLabel),
                  SizedBox(width: ds(2)),
                  const DsIcon(DsIconGlyph.chevronDown, size: DsIconSize.sm),
                ],
              ),
            ),
          ),
          children: <DsMenuChild>[
            const DsMenuLabel('Account'),
            const DsMenuSeparator(),
            DsMenuGroup(
              children: <DsMenuChild>[
                DsMenuItem(
                  label: 'Profile',
                  icon: DsIconGlyph.user,
                  shortcut: '⇧⌘P',
                  onSelect: () => _act('Profile'),
                ),
                DsMenuItem(
                  label: 'Billing',
                  icon: DsIconGlyph.creditCard,
                  shortcut: '⌘B',
                  onSelect: () => _act('Billing'),
                ),
                DsMenuItem(
                  label: 'Settings',
                  icon: DsIconGlyph.settings,
                  onSelect: () => _act('Settings'),
                ),
              ],
            ),
            const DsMenuSeparator(),
            DsMenuSub(
              label: 'Invite users',
              icon: DsIconGlyph.plus,
              children: <DsMenuChild>[
                DsMenuItem(
                  label: 'Email',
                  onSelect: () => _act('Invite by email'),
                ),
                DsMenuItem(
                  label: 'Message',
                  onSelect: () => _act('Invite by message'),
                ),
              ],
            ),
            const DsMenuSeparator(),
            DsMenuCheckboxItem(
              label: 'Show status bar',
              checked: _statusBar,
              onSelect: (bool next) => setState(() => _statusBar = next),
            ),
            const DsMenuSeparator(),
            DsMenuRadioGroup(
              value: _panel,
              onChanged: (String next) => setState(() => _panel = next),
              children: const <DsMenuRadioItem>[
                DsMenuRadioItem(value: 'left', label: 'Panel on left'),
                DsMenuRadioItem(value: 'right', label: 'Panel on right'),
              ],
            ),
            const DsMenuSeparator(),
            DsMenuItem(
              label: 'Log out',
              icon: DsIconGlyph.logOut,
              variant: DsMenuItemVariant.destructive,
              onSelect: () => _act('Log out'),
            ),
          ],
        ),
        SizedBox(height: ds(4)),
        DsText(
          'Last action: $_lastAction',
          DsType.small,
          key: const ValueKey<String>('dropdown-menu-doc-last-action'),
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

/// A realistic row-actions menu — an ellipsis trigger at the end of a
/// data-table row, aligned to the row’s own trailing edge.
class _DropdownMenuComposition extends StatelessWidget {
  const _DropdownMenuComposition();

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: DsText(
            'INV-2049 · Autumn Collection',
            DsType.body,
            color: theme.foreground,
          ),
        ),
        SizedBox(width: ds(3)),
        DsDropdownMenu(
          align: DsPopoverAlign.end,
          trigger: DsButton(
            variant: DsButtonVariant.ghost,
            size: DsButtonSize.icon,
            label: 'Row actions',
            suppressPressScale: true,
            onPressed: () {},
            child: const DsIcon(DsIconGlyph.ellipsis, size: DsIconSize.md),
          ),
          children: <DsMenuChild>[
            DsMenuItem(
              label: 'View invoice',
              icon: DsIconGlyph.eye,
              onSelect: () {},
            ),
            DsMenuItem(
              label: 'Duplicate',
              icon: DsIconGlyph.copy,
              onSelect: () {},
            ),
            const DsMenuSeparator(),
            DsMenuItem(
              label: 'Delete',
              icon: DsIconGlyph.trash2,
              variant: DsMenuItemVariant.destructive,
              onSelect: () {},
            ),
          ],
        ),
      ],
    );
  }
}
