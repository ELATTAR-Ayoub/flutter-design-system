/// Public documentation metadata for stable, installable registry components.
library;

import 'accordion/meta.dart' as accordion;
import 'agent_attach_menu/meta.dart' as agent_attach_menu;
import 'agent_attachments/meta.dart' as agent_attachments;
import 'agent_avatar/meta.dart' as agent_avatar;
import 'agent_composer/meta.dart' as agent_composer;
import 'agent_console/meta.dart' as agent_console;
import 'agent_core/meta.dart' as agent_core;
import 'agent_face/meta.dart' as agent_face;
import 'agent_history/meta.dart' as agent_history;
import 'agent_launcher/meta.dart' as agent_launcher;
import 'agent_markdown/meta.dart' as agent_markdown;
import 'agent_slash_palette/meta.dart' as agent_slash_palette;
import 'agent_transcript/meta.dart' as agent_transcript;
import 'alert/meta.dart' as alert;
import 'alert_dialog/meta.dart' as alert_dialog;
import 'attachment/meta.dart' as attachment;
import 'avatar/meta.dart' as avatar;
import 'badge/meta.dart' as badge;
import 'breadcrumb/meta.dart' as breadcrumb;
import 'bubble/meta.dart' as bubble;
import 'calendar/meta.dart' as calendar;
import 'card/meta.dart' as card;
import 'carousel/meta.dart' as carousel;
import 'chart/meta.dart' as chart;
import 'chart_cartesian/meta.dart' as chart_cartesian;
import 'chart_geometry/meta.dart' as chart_geometry;
import 'chart_polar/meta.dart' as chart_polar;
import 'checkbox/meta.dart' as checkbox;
import 'collapsible/meta.dart' as collapsible;
import 'command/meta.dart' as command;
import 'dialog/meta.dart' as dialog;
import 'dropdown_menu/meta.dart' as dropdown_menu;
import 'field/meta.dart' as field;
import 'icon/meta.dart' as icon;
import 'input/meta.dart' as input;
import 'input_group/meta.dart' as input_group;
import 'native_select/meta.dart' as native_select;
import 'navigation_menu/meta.dart' as navigation_menu;
import 'pagination/meta.dart' as pagination;
import 'popover/meta.dart' as popover;
import 'press_motion/meta.dart' as press_motion;
import 'progress/meta.dart' as progress;
import 'questionnaire/meta.dart' as questionnaire;
import 'radio/meta.dart' as radio;
import 'scroll_area/meta.dart' as scroll_area;
import 'select/meta.dart' as select;
import 'separator/meta.dart' as separator;
import 'sheet/meta.dart' as sheet;
import 'sidebar/meta.dart' as sidebar;
import 'slider/meta.dart' as slider;
import 'source_foundation/meta.dart' as source_foundation;
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
import 'safe_area/meta.dart' as safe_area;
import 'empty/meta.dart' as empty;
import 'foil_value/meta.dart' as foil_value;
import 'form/meta.dart' as form;
import 'glass/meta.dart' as glass;
import 'hover_card/meta.dart' as hover_card;
import 'input_otp/meta.dart' as input_otp;
import 'item/meta.dart' as item;
import 'kbd/meta.dart' as kbd;
import 'keyframes/meta.dart' as keyframes;
import 'machine_surface/meta.dart' as machine_surface;
import 'marker/meta.dart' as marker;
import 'media_scrim/meta.dart' as media_scrim;
import 'menu/meta.dart' as menu;
import 'menubar/meta.dart' as menubar;
import 'message/meta.dart' as message;
import 'message_scroller/meta.dart' as message_scroller;
import 'nav_user/meta.dart' as nav_user;
import 'resizable/meta.dart' as resizable;
import 'selection_control/meta.dart' as selection_control;
import 'skeleton/meta.dart' as skeleton;
import 'spinner/meta.dart' as spinner;
import 'toggle_group/meta.dart' as toggle_group;
import 'voice/meta.dart' as voice;
import 'voice_orb/meta.dart' as voice_orb;
import 'icon_swap/meta.dart' as icon_swap;
import 'lift/meta.dart' as lift;
import 'sliding_pill/meta.dart' as sliding_pill;
import 'swap_in/meta.dart' as swap_in;
import 'bloom_cosmic/meta.dart' as bloom_cosmic;
import 'page_glow/meta.dart' as page_glow;
import 'sheen_action/meta.dart' as sheen_action;
import 'starfield/meta.dart' as starfield;

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
/// Every entry is a per-component `<name>Doc` const imported with a prefix
/// so the metadata files cannot collide by name. `input`, `dialog`, `card`,
/// and `select` used to be declared inline here, alongside hand-composed
/// pages that lived outside `componentDocs` entirely; all four now have a
/// real `<name>/meta.dart` and a real `<name>/page.dart`, the same as every
/// other entry here.
///
/// `rule` and `spinner` are meta-only (no `page.dart`) and are
/// deliberately absent from this list: including them would synthesize a
/// route and a search entry with nothing to render at the other end.
const List<ComponentDocEntry> componentDocs = <ComponentDocEntry>[
  accordion.accordionDoc,
  agent_attach_menu.agentAttachMenuDoc,
  agent_attachments.agentAttachmentsDoc,
  agent_avatar.agentAvatarDoc,
  agent_composer.agentComposerDoc,
  agent_console.agentConsoleDoc,
  agent_core.agentCoreDoc,
  agent_face.agentFaceDoc,
  agent_history.agentHistoryDoc,
  agent_launcher.agentLauncherDoc,
  agent_markdown.agentMarkdownDoc,
  agent_slash_palette.agentSlashPaletteDoc,
  agent_transcript.agentTranscriptDoc,
  alert.alertDoc,
  alert_dialog.alertDialogDoc,
  attachment.attachmentDoc,
  avatar.avatarDoc,
  badge.badgeDoc,
  breadcrumb.breadcrumbDoc,
  bubble.bubbleDoc,
  button.buttonDoc,
  calendar.calendarDoc,
  card.cardDoc,
  carousel.carouselDoc,
  chart.chartDoc,
  chart_cartesian.chartCartesianDoc,
  chart_geometry.chartGeometryDoc,
  chart_polar.chartPolarDoc,
  checkbox.checkboxDoc,
  collapsible.collapsibleDoc,
  command.commandDoc,
  dialog.dialogDoc,
  dropdown_menu.dropdownMenuDoc,
  field.fieldDoc,
  icon.iconDoc,
  input.inputDoc,
  input_group.inputGroupDoc,
  native_select.nativeSelectDoc,
  navigation_menu.navigationMenuDoc,
  pagination.paginationDoc,
  popover.popoverDoc,
  press_motion.pressMotionDoc,
  progress.progressDoc,
  questionnaire.questionnaireDoc,
  radio.radioDoc,
  scroll_area.scrollAreaDoc,
  select.selectDoc,
  separator.separatorDoc,
  sheet.sheetDoc,
  sidebar.sidebarDoc,
  slider.sliderDoc,
  source_foundation.sourceFoundationDoc,
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
  safe_area.safeAreaDoc,
  empty.emptyDoc,
  foil_value.foilValueDoc,
  form.formDoc,
  glass.glassDoc,
  hover_card.hoverCardDoc,
  input_otp.inputOtpDoc,
  item.itemDoc,
  kbd.kbdDoc,
  keyframes.keyframesDoc,
  machine_surface.machineSurfaceDoc,
  marker.markerDoc,
  media_scrim.mediaScrimDoc,
  menu.menuDoc,
  menubar.menubarDoc,
  message.messageDoc,
  message_scroller.messageScrollerDoc,
  nav_user.navUserDoc,
  resizable.resizableDoc,
  selection_control.selectionControlDoc,
  skeleton.skeletonDoc,
  spinner.spinnerDoc,
  toggle_group.toggleGroupDoc,
  voice.voiceDoc,
  voice_orb.voiceOrbDoc,
  icon_swap.iconSwapDoc,
  lift.liftDoc,
  sliding_pill.slidingPillDoc,
  swap_in.swapInDoc,
  bloom_cosmic.bloomCosmicDoc,
  page_glow.pageGlowDoc,
  sheen_action.sheenActionDoc,
  starfield.starfieldDoc,
];

ComponentDocEntry? componentDocForRoute(String route) {
  for (final ComponentDocEntry entry in componentDocs) {
    if (entry.route == route) return entry;
  }
  return null;
}

ComponentDocEntry componentDoc(String name) =>
    componentDocs.singleWhere((ComponentDocEntry entry) => entry.name == name);
