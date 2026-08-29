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
import 'press/meta.dart' as press;
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
import 'validation_rule/meta.dart' as rule;
import 'safe_area/meta.dart' as safe_area;
import 'empty/meta.dart' as empty;
import 'premium_surface/meta.dart' as premium_surface;
import 'form/meta.dart' as form;
import 'glass/meta.dart' as glass;
import 'hover_card/meta.dart' as hover_card;
import 'input_otp/meta.dart' as input_otp;
import 'item/meta.dart' as item;
import 'kbd/meta.dart' as kbd;
import 'keyframes/meta.dart' as keyframes;
import 'surface/meta.dart' as surface;
import 'marker/meta.dart' as marker;
import 'media_scrim/meta.dart' as media_scrim;
import 'menu/meta.dart' as menu;
import 'menubar/meta.dart' as menubar;
import 'message/meta.dart' as message;
import 'message_scroller/meta.dart' as message_scroller;
import 'user_menu/meta.dart' as user_menu;
import 'resizable/meta.dart' as resizable;
import 'selection_control/meta.dart' as selection_control;
import 'skeleton/meta.dart' as skeleton;
import 'spinner/meta.dart' as spinner;
import 'toggle_group/meta.dart' as toggle_group;
import 'voice/meta.dart' as voice;
import 'voice_indicator/meta.dart' as voice_indicator;
import 'icon_swap/meta.dart' as icon_swap;
import 'hover_builder/meta.dart' as lift;
import 'active_indicator/meta.dart' as active_indicator;
import 'content_change/meta.dart' as content_change;
import 'feedback_surface/meta.dart' as feedback_surface;
import 'background_effect/meta.dart' as background_effect;
import 'action_feedback/meta.dart' as action_feedback;
import 'ambient_pattern/meta.dart' as starfield;

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
/// `rule` and `spinner` were meta-only once, and this note used to say they
/// were deliberately absent because listing them would synthesize a route
/// with nothing at the other end. Both have had a real `page.dart` since the
/// rollout, and both are listed below. The note is kept, corrected, because
/// the reasoning still holds for any future meta-only entry: an item belongs
/// in this list when — and only when — something renders at its route.
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
  press.pressDoc,
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
  rule.validationRuleDoc,
  safe_area.safeAreaDoc,
  empty.emptyDoc,
  premium_surface.premiumSurfaceDoc,
  form.formDoc,
  glass.glassDoc,
  hover_card.hoverCardDoc,
  input_otp.inputOtpDoc,
  item.itemDoc,
  kbd.kbdDoc,
  keyframes.keyframesDoc,
  surface.surfaceDoc,
  marker.markerDoc,
  media_scrim.mediaScrimDoc,
  menu.menuDoc,
  menubar.menubarDoc,
  message.messageDoc,
  message_scroller.messageScrollerDoc,
  user_menu.userMenuDoc,
  resizable.resizableDoc,
  selection_control.selectionControlDoc,
  skeleton.skeletonDoc,
  spinner.spinnerDoc,
  toggle_group.toggleGroupDoc,
  voice.voiceDoc,
  voice_indicator.voiceIndicatorDoc,
  icon_swap.iconSwapDoc,
  lift.hoverBuilderDoc,
  active_indicator.activeIndicatorDoc,
  content_change.contentChangeDoc,
  feedback_surface.feedbackSurfaceDoc,
  background_effect.backgroundEffectDoc,
  action_feedback.actionFeedbackDoc,
  starfield.ambientPatternDoc,
];

ComponentDocEntry? componentDocForRoute(String route) {
  for (final ComponentDocEntry entry in componentDocs) {
    if (entry.route == route) return entry;
  }
  return null;
}

ComponentDocEntry componentDoc(String name) =>
    componentDocs.singleWhere((ComponentDocEntry entry) => entry.name == name);

/// The five documentation families the site groups [componentDocs] into.
///
/// [componentDocs] itself stays the complete, flat route and search catalog:
/// this is a view over it, not a second list. The left rail
/// (`../docs/docs_layout.dart`) and the `/components` index
/// (`../site/pages/public_pages.dart`) both read the families from here, so a
/// component can never appear in one and not the other, or land in two groups.
///
/// The names are the site's, not the registry's: `effects` collects the
/// reusable visual, interaction, and motion surfaces, which may be static,
/// animated, or both — hence "Effects" rather than "Animations", a label that
/// would stop being true the moment a reader replaces the implementation.
enum ComponentDocFamily {
  components('Components'),
  effects('Effects'),
  agent('Agent'),
  charts('Charts');

  const ComponentDocFamily(this.label);

  /// The sidebar and index heading for this family.
  final String label;
}

/// Reusable visual, interaction, and motion effects.
///
/// Ordinary state components — Skeleton, Spinner, Progress — stay under
/// Components: they are things a reader places, not effects a reader applies.
const Set<String> effectsDocNames = <String>{
  'action_feedback',
  'active_indicator',
  'ambient_pattern',
  'background_effect',
  'content_change',
  'feedback_surface',
  'glass',
  'hover_builder',
  'icon_swap',
  'keyframes',
  'media_scrim',
  'premium_surface',
  'press',
  'surface',
};

/// The agent family, plus the two voice surfaces that only exist for it.
///
/// Generic conversation primitives — Attachment, Bubble, Message,
/// MessageScroller, Questionnaire — stay under Components: they are useful
/// without an agent behind them.
const Set<String> agentDocNames = <String>{
  'agent_attach_menu',
  'agent_attachments',
  'agent_avatar',
  'agent_composer',
  'agent_console',
  'agent_core',
  'agent_face',
  'agent_history',
  'agent_launcher',
  'agent_markdown',
  'agent_slash_palette',
  'agent_transcript',
  'voice',
  'voice_indicator',
};

/// The charts family.
const Set<String> chartsDocNames = <String>{
  'chart',
  'chart_cartesian',
  'chart_geometry',
  'chart_polar',
};

/// One spelling of a catalog name, for membership tests only.
///
/// [ComponentDocEntry.name] is inconsistent by history — `agent-console` and
/// `agent_attach_menu` are both real, and both feed `/components/<name>` —
/// and the routes are public, so neither spelling can be normalised away.
/// Family membership compares the underscored form so a set entry is never
/// silently a miss.
String _familyKey(String name) => name.replaceAll('-', '_');

/// Which family [entry] belongs to.
///
/// Membership is by explicit name set, so a new catalog entry lands in
/// [ComponentDocFamily.components] until somebody deliberately says otherwise
/// — the safe default, and the one `catalog_wiring_test.dart` proves is
/// exhaustive and non-overlapping.
ComponentDocFamily componentDocFamily(ComponentDocEntry entry) {
  final String key = _familyKey(entry.name);
  if (effectsDocNames.contains(key)) return ComponentDocFamily.effects;
  if (agentDocNames.contains(key)) return ComponentDocFamily.agent;
  if (chartsDocNames.contains(key)) return ComponentDocFamily.charts;
  return ComponentDocFamily.components;
}

/// Whether [name], in either spelling, is configured into a non-default
/// family. Used by the taxonomy test to prove no set entry is a typo.
bool isConfiguredFamilyName(String name) {
  final String key = _familyKey(name);
  return effectsDocNames.contains(key) ||
      agentDocNames.contains(key) ||
      chartsDocNames.contains(key);
}

/// Every [componentDocs] entry in [family], alphabetical by title.
///
/// [componentDocs] is already alphabetical by title per its own contract; the
/// sort is kept so that contract failing cannot silently reorder a rail.
List<ComponentDocEntry> componentDocsIn(ComponentDocFamily family) {
  final List<ComponentDocEntry> entries = componentDocs
      .where((ComponentDocEntry entry) => componentDocFamily(entry) == family)
      .toList();
  entries.sort(
    (ComponentDocEntry a, ComponentDocEntry b) => a.title.compareTo(b.title),
  );
  return entries;
}
