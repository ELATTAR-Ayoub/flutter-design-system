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
import 'alert_dialog/page.dart' as alert_dialog;
import 'badge/page.dart' as badge;
import 'breadcrumb/page.dart' as breadcrumb;
import 'button/page.dart' as button;
import 'button_group/page.dart' as button_group;
import 'checkbox/page.dart' as checkbox;
import 'combobox/page.dart' as combobox;
import 'command/page.dart' as command;
import 'context_menu/page.dart' as context_menu;
import 'drawer/page.dart' as drawer;
import 'dropdown_menu/page.dart' as dropdown_menu;
import 'field/page.dart' as field;
import 'form/page.dart' as form;
import 'input_group/page.dart' as input_group;
import 'input_otp/page.dart' as input_otp;
import 'menubar/page.dart' as menubar;
import 'native_select/page.dart' as native_select;
import 'popover/page.dart' as popover;
import 'radio/page.dart' as radio;
import 'selection_control/page.dart' as selection_control;
import 'sheet/page.dart' as sheet;
import 'slider/page.dart' as slider;
import 'switch/page.dart' as switch_;
import 'textarea/page.dart' as textarea;
import 'toggle/page.dart' as toggle;
import 'toggle_group/page.dart' as toggle_group;

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
      ])
        spec.name: spec,
    };
