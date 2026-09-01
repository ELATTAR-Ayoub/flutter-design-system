/// Public documentation metadata for installable agent Skills.
///
/// A Skill is a Markdown-and-references bundle that directs a coding agent —
/// today, only Claude Code: to build with this design system correctly. This
/// catalog is the single source of truth for slug, route, version, supported
/// agents, reference titles, and the file tree: the Skills analogue of
/// `components_docs/catalog.dart`.
///
/// The skill's real payload lives at `skills/elattar-flutter-ui-director/` —
/// one copy, read directly by the repository's own agents (via `AGENTS.md`),
/// by the plugin route (`.claude-plugin/marketplace.json` + `plugin.json`,
/// source `"./"`), and by a manual copy. This file never duplicates that
/// content; it only describes it. See
/// `docs/superpowers/reports/public-release/decisions/005-public-skill-location.md`
/// for the full record.
///
/// ## `verifiedCommands`: the anti-invention guard
///
/// The site previously shipped `npx skills add ELATTAR-Ayoub/flutter-design-system`
///: a command nothing in the repository implemented or verified. [SkillsPage]
/// (in `skills_page.dart`) renders commands **only** by reading them out of a
/// [SkillDocEntry]'s [SkillInstallRoute]s, and every one of those commands must
/// appear, verbatim, in [verifiedCommands] below. A command that is not in this
/// list is not published: a human has to consciously add a line here before
/// the page can show it, and `example/test/skills_docs_test.dart` asserts the
/// two never drift apart.
library;

/// Whether an install route is demonstrated working today, or documented and
/// pending a recorded transcript plus the owner's licensing decision.
///
/// Nothing in this catalog is allowed to assert [pendingVerification] as
/// working: see the hard constraint recorded in
/// `docs/superpowers/plans/2026-08-23-phase-h-skills-scope.md`.
enum SkillRouteStatus {
  /// Demonstrated by this checkout itself, no license question, no network
  /// dependency: `AGENTS.md` already routes every agent to the skill.
  verifiedToday,

  /// Documented because the mechanism exists (H1 built the plugin manifests),
  /// but not yet backed by a recorded install → skill-listing transcript, and
  /// blocked on the repository's still-placeholder `LICENSE`.
  pendingVerification,
}

/// One copyable command line, scoped to a single [SkillInstallRoute] action.
///
/// Mirrors `docs/docs_code.dart`'s `DocsCodeCommand` shape exactly (`command`,
/// `label`, `description`) so `skills_page.dart` can map one onto the other at
/// render time: this file stays free of the Flutter import that widget type
/// would pull in, the same discipline `components_docs/catalog.dart` already
/// keeps.
class SkillCommand {
  const SkillCommand({
    required this.command,
    this.label = 'Command',
    this.description,
  });

  /// The literal, copyable command text. Must appear in [verifiedCommands].
  final String command;

  final String label;
  final String? description;
}

/// One documented way to get the skill into an agent's own configuration.
class SkillInstallRoute {
  const SkillInstallRoute({
    required this.id,
    required this.title,
    required this.status,
    required this.summary,
    this.blockedBy,
    this.install = const <SkillCommand>[],
    this.update = const <SkillCommand>[],
    this.inspect = const <SkillCommand>[],
    this.remove = const <SkillCommand>[],
    this.updateNote,
  });

  /// Stable identifier, e.g. `agents-md`, `plugin`, `manual`.
  final String id;

  final String title;
  final SkillRouteStatus status;

  /// One or two sentences: what this route does.
  final String summary;

  /// Why [status] is [SkillRouteStatus.pendingVerification]. `null` when
  /// [status] is [SkillRouteStatus.verifiedToday].
  final String? blockedBy;

  final List<SkillCommand> install;

  /// Empty when there is no distinct update command: see [updateNote].
  final List<SkillCommand> update;
  final List<SkillCommand> inspect;
  final List<SkillCommand> remove;

  /// Prose shown in place of an empty [update] list, e.g. pointing back at
  /// [install] rather than inventing a second command that does the same
  /// thing.
  final String? updateNote;

  List<SkillCommand> get allCommands => <SkillCommand>[
    ...install,
    ...update,
    ...inspect,
    ...remove,
  ];
}

/// One file inside the skill's own directory, in file-tree order.
class SkillReferenceFile {
  const SkillReferenceFile({
    required this.path,
    required this.title,
    required this.description,
  });

  /// Repository-relative to the skill's own directory: e.g. `SKILL.md` or
  /// `references/system-map.md`. Never the repo-root-relative path; see
  /// [SkillDocEntry.sourcePaths] for that.
  final String path;

  final String title;
  final String description;
}

class SkillDocEntry {
  const SkillDocEntry({
    required this.slug,
    required this.name,
    required this.title,
    required this.summary,
    required this.description,
    required this.version,
    required this.pluginName,
    required this.marketplaceName,
    required this.repository,
    required this.licenseStatus,
    required this.supportedAgents,
    required this.examples,
    required this.included,
    required this.howItWorks,
    required this.workflow,
    required this.referenceFiles,
    required this.installRoutes,
  });

  /// Directory name under `skills/`, and the skill's frontmatter `name:`.
  final String slug;

  /// `SKILL.md`'s frontmatter `name:`: identical to [slug] today, kept as a
  /// separate field because the two are allowed to diverge in principle (a
  /// renamed directory need not rename the skill) even though nothing does
  /// that yet.
  final String name;

  final String title;

  /// One line, `.claude-plugin/plugin.json`'s `description`.
  final String summary;

  /// Longer, `SKILL.md`'s frontmatter `description:`, the text an agent
  /// harness actually uses to decide when to load the skill.
  final String description;

  /// Must equal `.claude-plugin/plugin.json`'s `version`. A parity test in
  /// `example/test/skills_docs_test.dart` enforces this; see Decision 005 —
  /// a skill with no version makes "update" unverifiable.
  final String version;

  /// `.claude-plugin/plugin.json`'s `name`.
  final String pluginName;

  /// `.claude-plugin/marketplace.json`'s `name`.
  final String marketplaceName;

  /// `https://github.com/...`: informational only. Never rendered as part of
  /// a copy-pasteable install command; see the hard constraint on GitHub-based
  /// install commands in the Phase H scope.
  final String repository;

  /// Plain statement of the licensing gate: see Decision 005 §"Publication
  /// gate".
  final String licenseStatus;

  /// Agents this skill is actually verified against. Claude Code only —
  /// `agents/openai.yaml` was deleted; there is no self-serve Codex install
  /// route and no recorded Codex run, so Codex is not named here at all.
  final List<String> supportedAgents;

  /// Short requests a reader can paste after installation.
  final List<String> examples;

  /// The capabilities worth knowing before opening the source tree.
  final List<String> included;

  /// The public four-step explanation, kept shorter than the agent workflow.
  final List<String> howItWorks;

  /// Condensed restatement of `SKILL.md`'s ten-step workflow.
  final List<String> workflow;

  final List<SkillReferenceFile> referenceFiles;
  final List<SkillInstallRoute> installRoutes;

  /// The one route this page serves. Equal to `site/site_routes.dart`'s
  /// `skillsRoute` by construction: kept as a literal here (not imported)
  /// the same way `components_docs/catalog.dart` defines its own `route`
  /// getter independently of the site layer.
  String get route => '/skills';

  /// Repository-relative directory the skill's real files live under.
  String get directory => 'skills/$slug';

  /// Bare file-tree paths, relative to [directory], in tree order.
  List<String> get files => <String>[
    for (final SkillReferenceFile file in referenceFiles) file.path,
  ];

  /// Repository-relative source paths, derived from [directory] so this
  /// catalog and the real directory listing cannot drift on layout.
  List<String> get sourcePaths => <String>[
    for (final SkillReferenceFile file in referenceFiles)
      '$directory/${file.path}',
  ];

  List<SkillCommand> get allCommands => <SkillCommand>[
    for (final SkillInstallRoute route in installRoutes) ...route.allCommands,
  ];
}

/// The commands `skills_page.dart` is allowed to render, and the only ones.
///
/// A command belongs here only once a human has read it and decided it is
/// either demonstrably real today (see `SkillRouteStatus.verifiedToday`) or
/// worth documenting as a pending route (see `SkillRouteStatus.pendingVerification`,
/// which the page always labels as such: never as working). Nothing on the
/// page may render text that looks like a command unless it is drawn from
/// this list; `example/test/skills_docs_test.dart` checks every
/// `DocsSelectableCodeBlock` the page renders against it.
const List<String> verifiedCommands = <String>[
  // Verified today: this checkout's own `AGENTS.md` already names the skill.
  // No install step, no network dependency, no licensing question: reading
  // the file is the whole route.
  'cat AGENTS.md',

  // Verified Claude Code plugin route. The GitHub marketplace round trip was
  // completed against the public repository and the installed plugin appeared
  // enabled in Claude Code's plugin manager.
  '/plugin marketplace add ELATTAR-Ayoub/flutter-design-system',
  '/plugin install elattar-design-system@elattar',
  '/plugin marketplace update elattar',
  'claude plugin update elattar-design-system@elattar',
  '/reload-plugins',
  '/plugin',
  '/plugin list',
  '/elattar-design-system:elattar-flutter-ui-director',
  '/plugin uninstall elattar-design-system@elattar',
  '/plugin marketplace remove elattar',

  // Pending verification (manual copy route): same gate as above. Plain
  // POSIX `cp`/`ls`/`rm`; no GitHub dependency, since the source directory is
  // whatever local checkout the reader already has.
  'cp -r skills/elattar-flutter-ui-director ~/.claude/skills/elattar-flutter-ui-director',
  'cp -r skills/elattar-flutter-ui-director .claude/skills/elattar-flutter-ui-director',
  'ls ~/.claude/skills/elattar-flutter-ui-director',
  'rm -rf ~/.claude/skills/elattar-flutter-ui-director',
];

const String _licenseStatus =
    'MIT licensed. The Claude Code plugin is the recommended install.';

const SkillDocEntry _elattarFlutterUiDirector = SkillDocEntry(
  slug: 'elattar-flutter-ui-director',
  name: 'elattar-flutter-ui-director',
  title: 'Elattar Flutter UI Director',
  // Verbatim from `.claude-plugin/plugin.json`'s `description`, checked by
  // `example/test/skills_docs_test.dart`.
  summary:
      "Builds and reviews Flutter UI with Elattar's installed components and "
      'foundation tokens, using project-aware API discovery, responsive and '
      'accessible composition, relevant state coverage, and verification '
      'proportional to the task.',
  // Verbatim from `SKILL.md`'s frontmatter `description:`, the text an agent
  // harness actually matches on. Checked by the same test.
  description:
      "Build and review Flutter UI with Elattar's installed components and "
      'foundation tokens. Applies in the design-system repository and '
      'consumer apps with elattar.yaml when work touches screens, flows, '
      'components, responsive behavior, theming, accessibility, feedback, or '
      'UI documentation.',
  version: '0.0.2',
  pluginName: 'elattar-design-system',
  marketplaceName: 'elattar',
  repository: 'https://github.com/ELATTAR-Ayoub/flutter-design-system',
  licenseStatus: _licenseStatus,
  supportedAgents: <String>['Claude Code'],
  examples: <String>[
    'Build a responsive settings page from the Elattar components already '
        'installed in this project.',
    'Review this Flutter screen for token, accessibility, theme, and '
        'responsive issues. Do not change code.',
    'Add loading, empty, error, and retry states to this existing results '
        'section.',
    'Document this component using its real public API and examples.',
  ],
  included: <String>[
    'Project detection for the design-system repository and CLI-installed '
        'consumer apps.',
    'Public API and registry discovery before a component is composed or '
        'installed.',
    'Native Flutter tokens for type, color, spacing, depth, and motion.',
    'Responsive, theme, keyboard, screen-reader, feedback, and state rules.',
    'Quick, standard, and full verification paths matched to task risk.',
  ],
  howItWorks: <String>[
    'Detects repository or consumer mode from the files in the project.',
    'Reads the public barrels, installed manifest, tests, and examples instead '
        'of guessing APIs.',
    'Composes existing components and foundation tokens, adding only the '
        'states and behavior the surface needs.',
    'Runs focused or full verification according to the size and risk of the '
        'change.',
  ],
  // Condensed from SKILL.md's own numbered workflow, one line per step, in
  // its order. The step count is asserted against that file by test, so a
  // step added to the skill cannot go unreported here.
  workflow: <String>[
    'Resolve the mode, repository or consumer, before reading or writing '
        'anything.',
    'Choose quick, standard, or full depth before acting.',
    'Classify the work: product screen, package component, port, agent '
        'console, documentation, or review and fix.',
    'Inventory the real public APIs: barrel, source, tests, specimens. Never '
        'guess that a widget exists.',
    'Define a focused outcome, a short contract, or the full UI contract '
        'according to the chosen depth.',
    'Set the visual direction only when visuals change.',
    'Design the states that apply before the widgets.',
    'Build by composing exported widgets, keeping product UI outside the '
        'system-owned component directory.',
    'Cover relevant platform, access, theme and copy rules: keyboard '
        'and screen reader, both themes.',
    'Verify and hand off in proportion to the chosen depth, and report only '
        'what was actually run.',
  ],
  referenceFiles: <SkillReferenceFile>[
    SkillReferenceFile(
      path: 'SKILL.md',
      title: 'Skill definition',
      description:
          'Frontmatter, the ten-step workflow, the non-negotiable '
          'contract, and the reference index.',
    ),
    SkillReferenceFile(
      path: 'references/accessibility.md',
      title: 'Accessibility',
      description:
          'Labels, focus order, keyboard reachability, and '
          'announcements.',
    ),
    SkillReferenceFile(
      path: 'references/agent-console.md',
      title: 'Agent console',
      description: 'Agent-facing interaction requirements.',
    ),
    SkillReferenceFile(
      path: 'references/component-spec.md',
      title: 'Component spec',
      description:
          'When a reusable component is finished, and when one is not '
          'warranted.',
    ),
    SkillReferenceFile(
      path: 'references/copy.md',
      title: 'Copy',
      description: 'Microcopy rules for labels, empty states, and failures.',
    ),
    SkillReferenceFile(
      path: 'references/errors.md',
      title: 'Errors',
      description:
          'The failure taxonomy, human error copy, and where a failure '
          'appears.',
    ),
    SkillReferenceFile(
      path: 'references/feedback.md',
      title: 'Feedback',
      description:
          'One channel per trigger, its timing, and the next step it '
          'offers.',
    ),
    SkillReferenceFile(
      path: 'references/page-blueprint.md',
      title: 'Page blueprint',
      description: 'Pages, regions, lists, forms, and multi-step flows.',
    ),
    SkillReferenceFile(
      path: 'references/responsive.md',
      title: 'Responsive',
      description: 'Breakpoints, insets, input modes, and content stress.',
    ),
    SkillReferenceFile(
      path: 'references/states.md',
      title: 'States',
      description: 'The state model, and what renders each state.',
    ),
    SkillReferenceFile(
      path: 'references/system-map.md',
      title: 'System map',
      description:
          'Mode discrimination, repository topology, and discovery '
          'commands.',
    ),
    SkillReferenceFile(
      path: 'references/theming.md',
      title: 'Theming',
      description: 'Tokens, both themes, and effects.',
    ),
    SkillReferenceFile(
      path: 'references/traps.md',
      title: 'Traps',
      description: 'Common failure modes.',
    ),
    SkillReferenceFile(
      path: 'references/ui-contract.md',
      title: 'UI contract',
      description: 'The artifact to write before any widget.',
    ),
    SkillReferenceFile(
      path: 'references/verify.md',
      title: 'Verify',
      description: 'The test, guard, build and visual review ladder.',
    ),
    SkillReferenceFile(
      path: 'references/visual-direction.md',
      title: 'Visual direction',
      description: 'Hierarchy, restraint, and reference handling.',
    ),
    SkillReferenceFile(
      path: 'scripts/check_ui_completeness.dart',
      title: 'Completeness scanner',
      description:
          'The script the verification ladder runs over changed '
          'surfaces.',
    ),
    SkillReferenceFile(
      path: 'templates/app-error.md',
      title: 'Template: app error',
      description: 'Error taxonomy, mapper, and copy table.',
    ),
    SkillReferenceFile(
      path: 'templates/async-section.md',
      title: 'Template: async section',
      description: 'One region, every state.',
    ),
    SkillReferenceFile(
      path: 'templates/component-doc.md',
      title: 'Template: component doc',
      description: 'The component documentation block.',
    ),
    SkillReferenceFile(
      path: 'templates/page-scaffold.md',
      title: 'Template: page scaffold',
      description: 'A page whose regions fail independently.',
    ),
    SkillReferenceFile(
      path: 'templates/ui-state.md',
      title: 'Template: UI state',
      description: 'The sealed state model.',
    ),
  ],
  installRoutes: <SkillInstallRoute>[
    SkillInstallRoute(
      id: 'agents-md',
      title: 'Clone the repository, read AGENTS.md',
      status: SkillRouteStatus.verifiedToday,
      summary:
          "This repository's own AGENTS.md already names the skill and tells "
          'any agent that opens it to use it for Flutter UI work. There is no '
          'install step: having the repository is the whole route, and this '
          'checkout demonstrates it.',
      inspect: <SkillCommand>[
        SkillCommand(
          command: 'cat AGENTS.md',
          label: 'Read the contract',
          description:
              'Confirms the repository root already points every agent at '
              'skills/elattar-flutter-ui-director/SKILL.md.',
        ),
      ],
    ),
    SkillInstallRoute(
      id: 'plugin',
      title: 'Claude Code plugin',
      status: SkillRouteStatus.verifiedToday,
      summary:
          'The repository is its own single-plugin marketplace '
          '(.claude-plugin/marketplace.json + plugin.json, source "./"). '
          "Adding it registers the skill in Claude Code's own plugin manager.",
      install: <SkillCommand>[
        SkillCommand(
          command:
              '/plugin marketplace add ELATTAR-Ayoub/flutter-design-system',
          label: 'Add the marketplace',
          description: 'Registers this repository as a plugin source.',
        ),
        SkillCommand(
          command: '/plugin install elattar-design-system@elattar',
          label: 'Install the plugin',
          description:
              'Installs the elattar-design-system plugin, which '
              'declares this one skill.',
        ),
        SkillCommand(
          command: '/reload-plugins',
          label: 'Activate when prompted',
          description:
              'Run only when the install summary asks for it; otherwise the '
              'plugin is already active.',
        ),
      ],
      update: <SkillCommand>[
        SkillCommand(
          command: 'claude plugin update elattar-design-system@elattar',
          label: 'Update from a terminal',
          description:
              'Fetches and installs the latest public plugin. Restart Claude '
              'Code after it completes.',
        ),
        SkillCommand(
          command: '/plugin marketplace update elattar',
          label: 'Refresh inside Claude Code',
          description:
              'Refreshes the marketplace listing; installed plugins can also '
              'update automatically when marketplace auto-update is enabled.',
        ),
      ],
      inspect: <SkillCommand>[
        SkillCommand(
          command: '/plugin',
          label: 'Open the plugin manager',
          description:
              'The Installed tab shows the plugin enabled and names its skill.',
        ),
        SkillCommand(
          command: '/plugin list',
          label: 'List installed plugins',
          description:
              'Shows whether elattar-design-system is installed and '
              'enabled.',
        ),
        SkillCommand(
          command: '/elattar-design-system:elattar-flutter-ui-director',
          label: 'Invoke the skill',
          description:
              'Loads the skill explicitly; ordinary matching UI requests '
              'also load it automatically.',
        ),
      ],
      remove: <SkillCommand>[
        SkillCommand(
          command: '/plugin uninstall elattar-design-system@elattar',
          label: 'Uninstall the plugin',
          description: 'Removes the plugin and its skill.',
        ),
        SkillCommand(
          command: '/plugin marketplace remove elattar',
          label: 'Remove the marketplace',
          description:
              'Use this only to remove the source or replace an earlier local '
              'elattar marketplace with the public GitHub source.',
        ),
      ],
    ),
    SkillInstallRoute(
      id: 'manual',
      title: 'Manual copy',
      status: SkillRouteStatus.pendingVerification,
      summary:
          "Copies the skill directory straight into an agent's own skills "
          'folder: user-scoped (every project) or project-scoped (one '
          'repository).',
      blockedBy:
          'The mechanism is ordinary file copying and the license permits it, '
          'but no run has been recorded ending in the skill appearing in an '
          'agent listing. Documented, not recommended.',
      install: <SkillCommand>[
        SkillCommand(
          command:
              'cp -r skills/elattar-flutter-ui-director '
              '~/.claude/skills/elattar-flutter-ui-director',
          label: 'Copy: user scope',
          description:
              'Makes the skill available to every project on this '
              'machine.',
        ),
        SkillCommand(
          command:
              'cp -r skills/elattar-flutter-ui-director '
              '.claude/skills/elattar-flutter-ui-director',
          label: 'Copy: project scope',
          description:
              'Makes the skill available only inside the current '
              'project.',
        ),
      ],
      updateNote:
          'Re-run the copy command above: cp -r overwrites the files already '
          'there with the newer ones.',
      inspect: <SkillCommand>[
        SkillCommand(
          command: 'ls ~/.claude/skills/elattar-flutter-ui-director',
          label: 'List the copied files',
          description: 'Confirms the copy landed.',
        ),
      ],
      remove: <SkillCommand>[
        SkillCommand(
          command: 'rm -rf ~/.claude/skills/elattar-flutter-ui-director',
          label: 'Delete the copy',
          description: 'Removes the skill from this agent configuration.',
        ),
      ],
    ),
  ],
);

const List<SkillDocEntry> skillDocs = <SkillDocEntry>[
  _elattarFlutterUiDirector,
];

SkillDocEntry? skillDocForRoute(String route) {
  for (final SkillDocEntry entry in skillDocs) {
    if (entry.route == route) return entry;
  }
  return null;
}

SkillDocEntry skillDoc(String slug) =>
    skillDocs.singleWhere((SkillDocEntry entry) => entry.slug == slug);
