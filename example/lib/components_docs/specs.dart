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
import 'button/page.dart' as button;

/// Keyed by [ComponentDocSpec.name] — the registry item's own name, with
/// hyphens, so it matches `registry.json` and `ComponentDocEntry.name`.
final Map<String, ComponentDocSpec> componentDocSpecs =
    <String, ComponentDocSpec>{
      for (final ComponentDocSpec spec in <ComponentDocSpec>[
        button.buttonDocSpec,
      ])
        spec.name: spec,
    };
