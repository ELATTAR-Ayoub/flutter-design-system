/// Every component page that has been migrated onto the documentation kit,
/// by registry name.
///
/// **Why this is not a field on `ComponentDocEntry`.** The obvious home for a
/// page's [ComponentDocSpec] is the entry that already carries its name,
/// title and description — but that home is a cycle. A spec's
/// `InstallSection.command` reads `<name>Doc.command` off the entry (it must:
/// a literal there is exactly the drift `docs_install_test.dart` exists to
/// catch), so an entry holding its own spec would be a lazy `final`
/// initialising a lazy `final` that reads it back. Dart accepts that at
/// compile time and throws `CyclicInitializationError` the first time
/// anything touches either one — at runtime, on the page, not in the
/// analyzer.
///
/// Keeping the map here breaks the loop and costs one line per page: the
/// entry knows nothing about the spec, the spec reads the entry, and this
/// file reads both. It is also the one place that can answer "which pages
/// are on the kit?", which is what the shape guard iterates and what the
/// rollout is measured against.
library;

import '../docs/component_doc_page.dart' show ComponentDocSpec;
import 'accordion/page.dart' as accordion;
import 'agent_attach_menu/page.dart' as agent_attach_menu;
import 'agent_attachments/page.dart' as agent_attachments;
import 'agent_avatar/page.dart' as agent_avatar;
import 'agent_composer/page.dart' as agent_composer;
import 'agent_console/page.dart' as agent_console;
import 'agent_core/page.dart' as agent_core;
import 'agent_face/page.dart' as agent_face;
import 'agent_history/page.dart' as agent_history;
import 'agent_launcher/page.dart' as agent_launcher;
import 'agent_markdown/page.dart' as agent_markdown;
import 'agent_slash_palette/page.dart' as agent_slash_palette;
import 'agent_transcript/page.dart' as agent_transcript;
import 'alert/page.dart' as alert;
import 'alert_dialog/page.dart' as alert_dialog;
import 'aspect_ratio/page.dart' as aspect_ratio;
import 'attachment/page.dart' as attachment;
import 'avatar/page.dart' as avatar;
import 'badge/page.dart' as badge;
import 'breadcrumb/page.dart' as breadcrumb;
import 'bubble/page.dart' as bubble;
import 'button/page.dart' as button;
import 'button_group/page.dart' as button_group;
import 'calendar/page.dart' as calendar;
import 'card/page.dart' as card;
import 'carousel/page.dart' as carousel;
import 'chart/page.dart' as chart;
import 'chart_cartesian/page.dart' as chart_cartesian;
import 'chart_geometry/page.dart' as chart_geometry;
import 'chart_polar/page.dart' as chart_polar;
import 'checkbox/page.dart' as checkbox;
import 'collapsible/page.dart' as collapsible;
import 'combobox/page.dart' as combobox;
import 'command/page.dart' as command;
import 'context_menu/page.dart' as context_menu;
import 'dialog/page.dart' as dialog;
import 'drawer/page.dart' as drawer;
import 'dropdown_menu/page.dart' as dropdown_menu;
import 'empty/page.dart' as empty;
import 'field/page.dart' as field;
import 'form/page.dart' as form;
import 'hover_card/page.dart' as hover_card;
import 'icon/page.dart' as icon;
import 'input/page.dart' as input;
import 'input_group/page.dart' as input_group;
import 'input_otp/page.dart' as input_otp;
import 'item/page.dart' as item;
import 'kbd/page.dart' as kbd;
import 'marker/page.dart' as marker;
import 'menu/page.dart' as menu;
import 'menubar/page.dart' as menubar;
import 'message/page.dart' as message;
import 'message_scroller/page.dart' as message_scroller;
import 'native_select/page.dart' as native_select;
import 'user_menu/page.dart' as user_menu;
import 'navigation_menu/page.dart' as navigation_menu;
import 'pagination/page.dart' as pagination;
import 'popover/page.dart' as popover;
import 'progress/page.dart' as progress;
import 'questionnaire/page.dart' as questionnaire;
import 'radio/page.dart' as radio;
import 'resizable/page.dart' as resizable;
import 'validation_rule/page.dart' as rule;
import 'scroll_area/page.dart' as scroll_area;
import 'select/page.dart' as select;
import 'selection_control/page.dart' as selection_control;
import 'separator/page.dart' as separator;
import 'sheet/page.dart' as sheet;
import 'sidebar/page.dart' as sidebar;
import 'skeleton/page.dart' as skeleton;
import 'slider/page.dart' as slider;
import 'spinner/page.dart' as spinner;
import 'stat/page.dart' as stat;
import 'switch/page.dart' as switch_;
import 'table/page.dart' as table;
import 'tabs/page.dart' as tabs;
import 'textarea/page.dart' as textarea;
import 'toaster/page.dart' as toaster;
import 'toggle/page.dart' as toggle;
import 'toggle_group/page.dart' as toggle_group;
import 'tooltip/page.dart' as tooltip;
import 'voice/page.dart' as voice;
import 'voice_indicator/page.dart' as voice_indicator;
import 'icon_swap/page.dart' as icon_swap;
import 'hover_builder/page.dart' as lift;
import 'active_indicator/page.dart' as active_indicator;
import 'content_change/page.dart' as content_change;
import 'premium_surface/page.dart' as premium_surface;
import 'glass/page.dart' as glass;
import 'surface/page.dart' as surface;
import 'media_scrim/page.dart' as media_scrim;
import 'feedback_surface/page.dart' as feedback_surface;
import 'background_effect/page.dart' as background_effect;
import 'action_feedback/page.dart' as action_feedback;
import 'ambient_pattern/page.dart' as starfield;
import 'press/page.dart' as press;
import 'keyframes/page.dart' as keyframes;
import 'safe_area/page.dart' as safe_area;
import 'source_foundation/page.dart' as source_foundation;

/// Keyed by [ComponentDocSpec.name] — the registry item's own name, with
/// hyphens, so it matches `registry.json` and `ComponentDocEntry.name`.
final Map<String, ComponentDocSpec> componentDocSpecs =
    <String, ComponentDocSpec>{
      for (final ComponentDocSpec spec in <ComponentDocSpec>[
        button.buttonDocSpec,
        input_group.inputGroupDocSpec,
        input_otp.inputOtpDocSpec,
        checkbox.checkboxDocSpec,
        field.fieldDocSpec,
        form.formDocSpec,
        radio.radioDocSpec,
        badge.badgeDocSpec,
        textarea.textareaDocSpec,
        native_select.nativeSelectDocSpec,
        button_group.buttonGroupDocSpec,
        toggle.toggleDocSpec,
        toggle_group.toggleGroupDocSpec,
        switch_.switchDocSpec,
        alert_dialog.alertDialogDocSpec,
        selection_control.selectionControlDocSpec,
        popover.popoverDocSpec,
        dropdown_menu.dropdownMenuDocSpec,
        slider.sliderDocSpec,
        combobox.comboboxDocSpec,
        sheet.sheetDocSpec,
        context_menu.contextMenuDocSpec,
        menubar.menubarDocSpec,
        drawer.drawerDocSpec,
        command.commandDocSpec,
        breadcrumb.breadcrumbDocSpec,
        accordion.accordionDocSpec,
        collapsible.collapsibleDocSpec,
        tabs.tabsDocSpec,
        separator.separatorDocSpec,
        alert.alertDocSpec,
        resizable.resizableDocSpec,
        pagination.paginationDocSpec,
        toaster.toasterDocSpec,
        navigation_menu.navigationMenuDocSpec,
        skeleton.skeletonDocSpec,
        spinner.spinnerDocSpec,
        empty.emptyDocSpec,
        rule.elRuleDocSpec,
        progress.progressDocSpec,
        table.tableDocSpec,
        marker.markerDocSpec,
        stat.statDocSpec,
        calendar.calendarDocSpec,
        avatar.avatarDocSpec,
        hover_card.hoverCardDocSpec,
        user_menu.navUserDocSpec,
        tooltip.tooltipDocSpec,
        kbd.kbdDocSpec,
        carousel.carouselDocSpec,
        aspect_ratio.aspectRatioDocSpec,
        scroll_area.scrollAreaDocSpec,
        item.itemDocSpec,
        icon.iconDocSpec,
        sidebar.sidebarDocSpec,
        agent_core.agentCoreDocSpec,
        agent_slash_palette.agentSlashPaletteDocSpec,
        agent_avatar.agentAvatarDocSpec,
        agent_composer.agentComposerDocSpec,
        agent_attach_menu.agentAttachMenuDocSpec,
        agent_face.agentFaceDocSpec,
        agent_transcript.agentTranscriptDocSpec,
        agent_launcher.agentLauncherDocSpec,
        agent_attachments.agentAttachmentsDocSpec,
        agent_console.agentConsoleDocSpec,
        agent_history.agentHistoryDocSpec,
        agent_markdown.agentMarkdownDocSpec,
        input.inputDocSpec,
        select.selectDocSpec,
        dialog.dialogDocSpec,
        card.cardDocSpec,
        menu.menuDocSpec,
        chart.chartDocSpec,
        chart_cartesian.chartCartesianDocSpec,
        chart_geometry.chartGeometryDocSpec,
        chart_polar.chartPolarDocSpec,
        bubble.bubbleDocSpec,
        message.messageDocSpec,
        message_scroller.messageScrollerDocSpec,
        attachment.attachmentDocSpec,
        questionnaire.questionnaireDocSpec,
        voice.voiceDocSpec,
        voice_indicator.voiceOrbDocSpec,
        icon_swap.iconSwapDocSpec,
        lift.liftDocSpec,
        active_indicator.slidingPillDocSpec,
        content_change.swapInDocSpec,
        premium_surface.foilValueDocSpec,
        glass.glassDocSpec,
        surface.machineSurfaceDocSpec,
        media_scrim.mediaScrimDocSpec,
        feedback_surface.bloomCosmicDocSpec,
        background_effect.pageGlowDocSpec,
        action_feedback.sheenActionDocSpec,
        starfield.starfieldDocSpec,
        press.pressMotionDocSpec,
        keyframes.keyframesDocSpec,
        safe_area.safeAreaDocSpec,
        source_foundation.sourceFoundationDocSpec,
      ])
        spec.name: spec,
    };
