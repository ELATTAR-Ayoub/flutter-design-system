/// Public documentation metadata for installable agent Skills.
///
/// A Skill is a Markdown-and-references bundle that directs a coding agent —
/// today, only Claude Code — to build with this design system correctly. This
/// catalog is the single source of truth for slug, route, version, supported
/// agents, reference titles, and the file tree — the Skills analogue of
/// `shots_docs/catalog.dart` and `components_docs/catalog.dart`.
///
/// The skill's real payload lives at `skills/elattar-flutter-ui-director/` —
/// one copy, read directly by the repository's own agents (via `AGENTS.md`),
/// by the plugin route (`.claude-plugin/marketplace.json` + `plugin.json`,
/// source `"./"`), and by a manual copy. This file never duplicates that
/// content; it only describes it. See
/// `docs/superpowers/reports/public-release/decisions/005-public-skill-location.md`
/// for the full record.
///
/// ## `verifiedCommands` — the anti-invention guard
///
/// The site previously shipped `npx skills add ELATTAR-Ayoub/flutter-design-system`
/// — a command nothing in the repository implemented or verified. [SkillsPage]
/// (in `skills_page.dart`) renders commands **only** by reading them out of a
/// [SkillDocEntry]'s [SkillInstallRoute]s, and every one of those commands must
/// appear, verbatim, in [verifiedCommands] below. A command that is not in this
/// list is not published — a human has to consciously add a line here before
/// the page can show it, and `example/test/skills_docs_test.dart` asserts the
/// two never drift apart.
library;

/// Whether an install route is demonstrated working today, or documented and
/// pending a recorded transcript plus the owner's licensing decision.
///
/// Nothing in this catalog is allowed to assert [pendingVerification] as
/// working — see the hard constraint recorded in
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
/// render time — this file stays free of the Flutter import that widget type
/// would pull in, the same discipline `shots_docs/catalog.dart` and
/// `components_docs/catalog.dart` already keep.
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

  /// Empty when there is no distinct update command — see [updateNote].
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

  /// Repository-relative to the skill's own directory — e.g. `SKILL.md` or
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
    required this.workflow,
    required this.referenceFiles,
    required this.installRoutes,
  });

  /// Directory name under `skills/`, and the skill's frontmatter `name:`.
  final String slug;

  /// `SKILL.md`'s frontmatter `name:` — identical to [slug] today, kept as a
  /// separate field because the two are allowed to diverge in principle (a
  /// renamed directory need not rename the skill) even though nothing does
  /// that yet.
  final String name;

  final String title;

  /// One line — `.claude-plugin/plugin.json`'s `description`.
  final String summary;

  /// Longer — `SKILL.md`'s frontmatter `description:`, the text an agent
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

  /// `https://github.com/...` — informational only. Never rendered as part of
  /// a copy-pasteable install command; see the hard constraint on GitHub-based
  /// install commands in the Phase H scope.
  final String repository;

  /// Plain statement of the licensing gate — see Decision 005 §"Publication
  /// gate".
  final String licenseStatus;

  /// Agents this skill is actually verified against. Claude Code only —
  /// `agents/openai.yaml` was deleted; there is no self-serve Codex install
  /// route and no recorded Codex run, so Codex is not named here at all.
  final List<String> supportedAgents;

  /// Condensed restatement of `SKILL.md`'s eight-step workflow.
  final List<String> workflow;

  final List<SkillReferenceFile> referenceFiles;
  final List<SkillInstallRoute> installRoutes;

  /// The one route this page serves. Equal to `site/site_routes.dart`'s
  /// `skillsRoute` by construction — kept as a literal here (not imported)
  /// the same way `shots_docs/catalog.dart` and `components_docs/catalog.dart`
  /// define their own `route` getters independently of the site layer.
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
/// which the page always labels as such — never as working). Nothing on the
/// page may render text that looks like a command unless it is drawn from
/// this list; `example/test/skills_docs_test.dart` checks every
/// `DocsSelectableCodeBlock` the page renders against it.
const List<String> verifiedCommands = <String>[
  // Verified today: this checkout's own `AGENTS.md` already names the skill.
  // No install step, no network dependency, no licensing question — reading
  // the file is the whole route.
  'cat AGENTS.md',

  // Pending verification (Claude Code plugin route) — see
  // `SkillDocEntry.licenseStatus` and Decision 005 §"Publication gate". The
  // exact `/plugin` subcommand syntax below was confirmed against current
  // Claude Code plugin-marketplace documentation, not invented.
  '/plugin marketplace add ELATTAR-Ayoub/flutter-design-system',
  '/plugin install elattar-design-system@elattar',
  '/plugin marketplace update elattar',
  '/plugin list',
  '/plugin uninstall elattar-design-system@elattar',

  // Pending verification (manual copy route) — same gate as above. Plain
  // POSIX `cp`/`ls`/`rm`; no GitHub dependency, since the source directory is
  // whatever local checkout the reader already has.
  'cp -r skills/elattar-flutter-ui-director ~/.claude/skills/elattar-flutter-ui-director',
  'cp -r skills/elattar-flutter-ui-director .claude/skills/elattar-flutter-ui-director',
  'ls ~/.claude/skills/elattar-flutter-ui-director',
  'rm -rf ~/.claude/skills/elattar-flutter-ui-director',
];

const String _licenseStatus =
    'The root LICENSE is still a placeholder ("TODO: Add your license here."). '
    'A plugin marketplace entry and a "copy this into your agent config" '
    'instruction are both invitations to redistribute, with no grant attached '
    'yet — so the routes below are documented, not published as working. See '
    'Decision 005 (docs/superpowers/reports/public-release/decisions/'
    '005-public-skill-location.md).';

const SkillDocEntry _elattarFlutterUiDirector = SkillDocEntry(
  slug: 'elattar-flutter-ui-director',
  name: 'elattar-flutter-ui-director',
  title: 'Elattar Flutter UI Director',
  summary:
      'Directs coding agents to build Flutter UI from the Elattar design '
      'system: public Ds* API discovery, foundation tokens, component '
      'placement, state and accessibility coverage, responsive contracts, and '
      'a verification ladder.',
  description:
      "Direct production Flutter UI with Elattar's design system, in the "
      'design-system repository itself or in a consumer app that installed it '
      'with the elattar CLI. Use when designing, implementing, reviewing, or '
      'documenting Flutter screens, flows, dashboards, mobile navigation, '
      'component specimens, loading/empty/error/success feedback, responsive '
      'behavior, visual verification, or agent-console experiences that must '
      'use the local Ds* APIs and token source of truth.',
  version: '0.0.1',
  pluginName: 'elattar-design-system',
  marketplaceName: 'elattar',
  repository: 'https://github.com/ELATTAR-Ayoub/flutter-design-system',
  licenseStatus: _licenseStatus,
  supportedAgents: <String>['Claude Code'],
  workflow: <String>[
    'Resolve the project mode — repository or consumer — before reading or '
        'writing anything.',
    'Classify the work and name its primary action, critical states, and '
        'supported form factors.',
    'Inventory the relevant public Ds* APIs, foundations, and specimens '
        'before proposing a primitive.',
    'State the dominant visual idea, hierarchy, and one restrained '
        'supporting effect.',
    'Define normal, loading, empty, error, success, disabled, focus, and '
        'recovery states before writing widgets.',
    'Compose Ds* widgets outside the system-owned component directory; keep '
        'system components reusable.',
    'Apply adaptive layout, safe areas, themes, input, and motion contracts.',
    'Add or update a specimen and focused tests, then run the verification '
        'ladder and report the mode, commands, and captures.',
  ],
  referenceFiles: <SkillReferenceFile>[
    SkillReferenceFile(
      path: 'SKILL.md',
      title: 'Skill definition',
      description:
          'Frontmatter, the eight-step workflow, the non-negotiable contract, '
          'and the reference index.',
    ),
    SkillReferenceFile(
      path: 'references/agent-console.md',
      title: 'Agent console',
      description: 'Agent-facing interaction requirements.',
    ),
    SkillReferenceFile(
      path: 'references/platform-contracts.md',
      title: 'Platform contracts',
      description: 'Adaptive layout, safe areas, input, themes, and motion.',
    ),
    SkillReferenceFile(
      path: 'references/state-accessibility.md',
      title: 'State & accessibility',
      description: 'Feedback, semantics, and state coverage.',
    ),
    SkillReferenceFile(
      path: 'references/system-map.md',
      title: 'System map',
      description:
          'Mode discrimination, repository topology, and discovery commands.',
    ),
    SkillReferenceFile(
      path: 'references/traps.md',
      title: 'Traps',
      description: 'Common failure modes.',
    ),
    SkillReferenceFile(
      path: 'references/verify.md',
      title: 'Verify',
      description: 'Test, guard, build, and visual review ladder.',
    ),
    SkillReferenceFile(
      path: 'references/visual-direction.md',
      title: 'Visual direction',
      description: 'Hierarchy, restraint, and reference handling.',
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
      status: SkillRouteStatus.pendingVerification,
      summary:
          'The repository is its own single-plugin marketplace '
          '(.claude-plugin/marketplace.json + plugin.json, source "./"). '
          "Adding it registers the skill in Claude Code's own plugin manager.",
      blockedBy:
          'No dated transcript yet proving the add/install round trip and '
          "the skill's appearance in Claude Code's own skill listing. Also "
          'gated on the licensing decision above.',
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
      ],
      update: <SkillCommand>[
        SkillCommand(
          command: '/plugin marketplace update elattar',
          label: 'Update the marketplace',
          description: 'Fetches the marketplace\'s latest commit.',
        ),
      ],
      inspect: <SkillCommand>[
        SkillCommand(
          command: '/plugin list',
          label: 'List installed plugins',
          description:
              'Shows whether elattar-design-system is installed and '
              'enabled.',
        ),
      ],
      remove: <SkillCommand>[
        SkillCommand(
          command: '/plugin uninstall elattar-design-system@elattar',
          label: 'Uninstall the plugin',
          description: 'Removes the plugin and its skill.',
        ),
      ],
    ),
    SkillInstallRoute(
      id: 'manual',
      title: 'Manual copy',
      status: SkillRouteStatus.pendingVerification,
      summary:
          "Copies the skill directory straight into an agent's own skills "
          'folder — user-scoped (every project) or project-scoped (one '
          'repository).',
      blockedBy:
          'Same licensing gate as the plugin route above; the mechanism is '
          'ordinary file copying and needs no transcript of its own once the '
          'license is decided.',
      install: <SkillCommand>[
        SkillCommand(
          command:
              'cp -r skills/elattar-flutter-ui-director '
              '~/.claude/skills/elattar-flutter-ui-director',
          label: 'Copy — user scope',
          description:
              'Makes the skill available to every project on this '
              'machine.',
        ),
        SkillCommand(
          command:
              'cp -r skills/elattar-flutter-ui-director '
              '.claude/skills/elattar-flutter-ui-director',
          label: 'Copy — project scope',
          description:
              'Makes the skill available only inside the current '
              'project.',
        ),
      ],
      updateNote:
          'Re-run the copy command above — cp -r overwrites the files already '
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
