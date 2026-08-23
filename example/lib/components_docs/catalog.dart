/// Public documentation metadata for stable, installable registry components.
library;

import 'accordion/meta.dart' as accordion;
import 'alert/meta.dart' as alert;
import 'alert_dialog/meta.dart' as alert_dialog;
import 'avatar/meta.dart' as avatar;
import 'badge/meta.dart' as badge;
import 'breadcrumb/meta.dart' as breadcrumb;
import 'calendar/meta.dart' as calendar;
import 'carousel/meta.dart' as carousel;
import 'checkbox/meta.dart' as checkbox;
import 'collapsible/meta.dart' as collapsible;
import 'command/meta.dart' as command;
import 'dropdown_menu/meta.dart' as dropdown_menu;
import 'field/meta.dart' as field;
import 'icon/meta.dart' as icon;
import 'input_group/meta.dart' as input_group;
import 'native_select/meta.dart' as native_select;
import 'navigation_menu/meta.dart' as navigation_menu;
import 'pagination/meta.dart' as pagination;
import 'popover/meta.dart' as popover;
import 'progress/meta.dart' as progress;
import 'radio/meta.dart' as radio;
import 'scroll_area/meta.dart' as scroll_area;
import 'separator/meta.dart' as separator;
import 'sheet/meta.dart' as sheet;
import 'sidebar/meta.dart' as sidebar;
import 'slider/meta.dart' as slider;
import 'stat/meta.dart' as stat;
import 'switch/meta.dart' as switch_;
import 'table/meta.dart' as table;
import 'tabs/meta.dart' as tabs;
import 'textarea/meta.dart' as textarea;
import 'toaster/meta.dart' as toaster;
import 'toggle/meta.dart' as toggle;
import 'tooltip/meta.dart' as tooltip;

class ComponentDocEntry {
  const ComponentDocEntry({
    required this.name,
    required this.title,
    required this.description,
    required this.dependencies,
    required this.exports,
    required this.sourcePath,
  });

  final String name;
  final String title;
  final String description;
  final List<String> dependencies;
  final List<String> exports;
  final String sourcePath;

  String get route => '/components/$name';
  String get command => 'elattar add $name';
}

/// Every publicly documented component, alphabetical by [ComponentDocEntry.title].
///
/// `button`, `input`, `card`, `dialog`, and `select` are declared inline here
/// (Phase F) rather than as a per-component `meta.dart`, and stay that way —
/// they are not migrated. Every other entry is a worker-owned `<name>Doc`
/// const, imported with a prefix so none of the ~35 `meta.dart` files can
/// collide by name; this file only ever reads those consts, never edits them.
///
/// `ds_rule` and `spinner` are meta-only (no `page.dart`) and are
/// deliberately absent from this list: including them would synthesize a
/// route and a search entry with nothing to render at the other end.
const List<ComponentDocEntry> componentDocs = <ComponentDocEntry>[
  accordion.accordionDoc,
  alert.alertDoc,
  alert_dialog.alertDialogDoc,
  avatar.avatarDoc,
  badge.badgeDoc,
  breadcrumb.breadcrumbDoc,
  ComponentDocEntry(
    name: 'button',
    title: 'Button',
    description:
        'Semantic actions with variants, sizes, loading, focus, and disabled behavior.',
    dependencies: <String>[
      'source-foundation',
      'press-motion',
      'icon',
      'spinner',
      'foil-value',
      'machine-surface',
      'sheen-action',
    ],
    exports: <String>[
      'DsButton',
      'DsButtonVariant',
      'DsButtonSize',
      'DsButtonEmphasis',
      'DsButtonSurface',
    ],
    sourcePath: 'lib/src/components/button.dart',
  ),
  calendar.calendarDoc,
  ComponentDocEntry(
    name: 'card',
    title: 'Card',
    description:
        'A structured surface with header, action, content, and footer regions.',
    dependencies: <String>['source-foundation'],
    exports: <String>[
      'DsCard',
      'DsCardHeader',
      'DsCardTitle',
      'DsCardDescription',
      'DsCardContent',
      'DsCardFooter',
    ],
    sourcePath: 'lib/src/components/card.dart',
  ),
  carousel.carouselDoc,
  checkbox.checkboxDoc,
  collapsible.collapsibleDoc,
  command.commandDoc,
  ComponentDocEntry(
    name: 'dialog',
    title: 'Dialog',
    description:
        'An accessible modal portal with normal and media compositions.',
    dependencies: <String>[
      'source-foundation',
      'button',
      'icon',
      'machine-surface',
    ],
    exports: <String>[
      'DsDialog',
      'DsDialogVariant',
      'DsDialogContent',
      'DsDialogHeader',
      'DsDialogFooter',
      'DsDialogTitle',
      'DsDialogDescription',
      'DsDialogMedia',
    ],
    sourcePath: 'lib/src/components/dialog.dart',
  ),
  dropdown_menu.dropdownMenuDoc,
  field.fieldDoc,
  icon.iconDoc,
  ComponentDocEntry(
    name: 'input',
    title: 'Input',
    description:
        'Accessible text entry with focus, invalid, disabled, read-only, and grouped states.',
    dependencies: <String>[
      'source-foundation',
      'button',
      'field',
      'ds-rule',
      'machine-surface',
    ],
    exports: <String>['DsInput'],
    sourcePath: 'lib/src/components/input.dart',
  ),
  input_group.inputGroupDoc,
  native_select.nativeSelectDoc,
  navigation_menu.navigationMenuDoc,
  pagination.paginationDoc,
  popover.popoverDoc,
  progress.progressDoc,
  radio.radioDoc,
  scroll_area.scrollAreaDoc,
  ComponentDocEntry(
    name: 'select',
    title: 'Select',
    description:
        'Typed selection with sizes, groups, separators, disabled options, and keyboard navigation.',
    dependencies: <String>[
      'source-foundation',
      'button',
      'field',
      'icon',
      'popover',
      'machine-surface',
    ],
    exports: <String>[
      'DsSelect',
      'DsSelectSize',
      'DsSelectOption',
      'DsSelectGroup',
      'DsSelectSeparator',
    ],
    sourcePath: 'lib/src/components/select.dart',
  ),
  separator.separatorDoc,
  sheet.sheetDoc,
  sidebar.sidebarDoc,
  slider.sliderDoc,
  stat.statDoc,
  switch_.switchDoc,
  table.tableDoc,
  tabs.tabsDoc,
  textarea.textareaDoc,
  toaster.toasterDoc,
  toggle.toggleDoc,
  tooltip.tooltipDoc,
];

ComponentDocEntry? componentDocForRoute(String route) {
  for (final ComponentDocEntry entry in componentDocs) {
    if (entry.route == route) return entry;
  }
  return null;
}

ComponentDocEntry componentDoc(String name) =>
    componentDocs.singleWhere((ComponentDocEntry entry) => entry.name == name);
