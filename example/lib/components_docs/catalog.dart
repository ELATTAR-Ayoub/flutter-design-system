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
import 'aspect_ratio/meta.dart' as aspect_ratio;
import 'button/meta.dart' as button;
import 'button_group/meta.dart' as button_group;
import 'combobox/meta.dart' as combobox;
import 'context_menu/meta.dart' as context_menu;
import 'drawer/meta.dart' as drawer;
import 'rule/meta.dart' as rule;
import 'empty/meta.dart' as empty;
import 'form/meta.dart' as form;
import 'hover_card/meta.dart' as hover_card;
import 'input_otp/meta.dart' as input_otp;
import 'item/meta.dart' as item;
import 'kbd/meta.dart' as kbd;
import 'marker/meta.dart' as marker;
import 'menubar/meta.dart' as menubar;
import 'nav_user/meta.dart' as nav_user;
import 'resizable/meta.dart' as resizable;
import 'selection_control/meta.dart' as selection_control;
import 'skeleton/meta.dart' as skeleton;
import 'spinner/meta.dart' as spinner;
import 'toggle_group/meta.dart' as toggle_group;

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
  String get command => 'elattar add ${name.replaceAll('_', '-')}';
}

/// Every publicly documented component, alphabetical by [ComponentDocEntry.title].
///
/// `input`, `card`, `dialog`, and `select` are declared inline here. Every
/// other entry is a per-component `<name>Doc` const imported with a prefix so
/// the metadata files cannot collide by name.
///
/// `rule` and `spinner` are meta-only (no `page.dart`) and are
/// deliberately absent from this list: including them would synthesize a
/// route and a search entry with nothing to render at the other end.
const List<ComponentDocEntry> componentDocs = <ComponentDocEntry>[
  accordion.accordionDoc,
  alert.alertDoc,
  alert_dialog.alertDialogDoc,
  avatar.avatarDoc,
  badge.badgeDoc,
  breadcrumb.breadcrumbDoc,
  button.buttonDoc,
  calendar.calendarDoc,
  ComponentDocEntry(
    name: 'card',
    title: 'Card',
    description:
        'A structured surface with header, action, content, and footer regions.',
    dependencies: <String>['source-foundation'],
    exports: <String>[
      'ElCard',
      'ElCardHeader',
      'ElCardTitle',
      'ElCardDescription',
      'ElCardContent',
      'ElCardFooter',
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
      'ElDialog',
      'ElDialogVariant',
      'ElDialogContent',
      'ElDialogHeader',
      'ElDialogFooter',
      'ElDialogTitle',
      'ElDialogDescription',
      'ElDialogMedia',
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
      'rule',
      'machine-surface',
    ],
    exports: <String>['ElInput'],
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
      'ElSelect',
      'ElSelectSize',
      'ElSelectOption',
      'ElSelectGroup',
      'ElSelectSeparator',
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
  aspect_ratio.aspectRatioDoc,
  button_group.buttonGroupDoc,
  combobox.comboboxDoc,
  context_menu.contextMenuDoc,
  drawer.drawerDoc,
  rule.elRuleDoc,
  empty.emptyDoc,
  form.formDoc,
  hover_card.hoverCardDoc,
  input_otp.inputOtpDoc,
  item.itemDoc,
  kbd.kbdDoc,
  marker.markerDoc,
  menubar.menubarDoc,
  nav_user.navUserDoc,
  resizable.resizableDoc,
  selection_control.selectionControlDoc,
  skeleton.skeletonDoc,
  spinner.spinnerDoc,
  toggle_group.toggleGroupDoc,
];

ComponentDocEntry? componentDocForRoute(String route) {
  for (final ComponentDocEntry entry in componentDocs) {
    if (entry.route == route) return entry;
  }
  return null;
}

ComponentDocEntry componentDoc(String name) =>
    componentDocs.singleWhere((ComponentDocEntry entry) => entry.name == name);
