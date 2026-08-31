/// Public documentation page for `/docs/registry`.
///
/// The registry is the thing between "I typed a command" and "files appeared
/// in my project", and it is the part a reader has the least visibility into.
/// So this page explains the mechanism — what an item is, how a name becomes
/// an install set, what the hashes are for, why the URL carries a version —
/// and reports the shipped registry's own figures rather than any written
/// down here.
///
/// **Informational, deliberately.** Installation is one action and it lives on
/// one page. Nothing here competes with it: the commands shown are the ones
/// for reading the registry, and the page ends by pointing at Installation
/// rather than by growing a second quickstart.
///
/// Every figure is loaded from the bundled generated registry through an
/// injectable loader, so the widget tests exercise the real states — loading,
/// loaded, empty, error and retry — without a bundle or a network.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RadioGroup,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import '../docs/docs_disclosure.dart';
import '../docs/docs_facts.dart';
import '../docs/docs_layout.dart';
import '../docs/docs_section.dart';
import '../docs/docs_snippet.dart';
import 'catalog.dart';
import 'registry_document.dart';

class RegistryDocsPage extends StatefulWidget {
  const RegistryDocsPage({super.key, this.onNavigate, this.loader});

  final ValueChanged<String>? onNavigate;

  /// Where the figures come from. Defaults to the bundled generated registry.
  final RegistrySnapshotLoader? loader;

  @override
  State<RegistryDocsPage> createState() => _RegistryDocsPageState();
}

class _RegistryDocsPageState extends State<RegistryDocsPage> {
  late Future<RegistrySnapshot> _snapshot = _load();

  Future<RegistrySnapshot> _load() =>
      (widget.loader ?? loadBundledRegistrySnapshot)();

  void _retry() {
    // A block body, not an arrow. `setState(() => _snapshot = _load())`
    // returns the assignment's value — a Future — and Flutter asserts that
    // a setState callback is not async, because work done inside one is not
    // covered by the rebuild. The retry button did nothing visible until the
    // test caught this.
    setState(() {
      _snapshot = _load();
    });
  }

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: docsRegistryRoute,
    intro: const DocsPageIntro(
      eyebrow: 'DOCS',
      title: 'Registry',
      description:
          'How a component name becomes files you own: what arrives, where '
          'it lands, and what the hashes promise.',
    ),
    breadcrumbs: const <BreadcrumbEntry>[
      BreadcrumbEntry.link('Docs'),
      BreadcrumbEntry.page('Registry'),
    ],
    toc: const <DocsTocEntry>[
      DocsTocEntry(title: 'What ships today', anchor: 'shipped'),
      DocsTocEntry(title: 'Where files land', anchor: 'targets'),
      DocsTocEntry(title: 'Source ownership', anchor: 'ownership'),
      DocsTocEntry(title: 'Hashes', anchor: 'hashes'),
      DocsTocEntry(title: 'What an item is', anchor: 'item'),
      DocsTocEntry(title: 'How dependencies resolve', anchor: 'dependencies'),
      DocsTocEntry(title: 'Versioned and hosted', anchor: 'hosted'),
      DocsTocEntry(title: 'Cache and offline', anchor: 'offline'),
      DocsTocEntry(title: 'Reading the registry', anchor: 'commands'),
      DocsTocEntry(title: 'What this is not', anchor: 'not-included'),
    ],
    previous: const DocsPageLink(title: 'Typeset', route: docsTypesetRoute),
    next: const DocsPageLink(title: 'Changelog', route: docsChangelogRoute),
    onNavigate: widget.onNavigate,
    child: _RegistryArticle(
      snapshot: _snapshot,
      onRetry: _retry,
      onNavigate: widget.onNavigate,
    ),
  );
}

class _RegistryArticle extends StatelessWidget {
  const _RegistryArticle({
    required this.snapshot,
    required this.onRetry,
    this.onNavigate,
  });

  final Future<RegistrySnapshot> snapshot;
  final VoidCallback onRetry;
  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('registry-doc-article'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      DocsSection(
        id: 'shipped',
        title: 'What ships today',
        description:
            'Read from the generated registry in this build, not written '
            'down here. If these figures are wrong, the registry is.',
        child: FutureBuilder<RegistrySnapshot>(
          future: snapshot,
          builder:
              (BuildContext context, AsyncSnapshot<RegistrySnapshot> state) =>
                  switch (state) {
                    AsyncSnapshot<RegistrySnapshot>(
                      connectionState: ConnectionState.waiting,
                    ) =>
                      const _Loading(),
                    AsyncSnapshot<RegistrySnapshot>(hasError: true) => _Failed(
                      error: state.error!,
                      onRetry: onRetry,
                    ),
                    AsyncSnapshot<RegistrySnapshot>(
                      data: final RegistrySnapshot s,
                    )
                        when s.itemCount == 0 =>
                      const _Empty(),
                    AsyncSnapshot<RegistrySnapshot>(
                      data: final RegistrySnapshot s,
                    ) =>
                      _Figures(snapshot: s),
                    _ => const _Loading(),
                  },
        ),
      ),
      _targets(),
      _ownership(context),
      _hashes(),
      _item(),
      _dependencies(),
      _hosted(),
      _offline(),
      _commands(),
      _notIncluded(),
    ],
  );

  Widget _prose(String text, {TextStyleToken? spec}) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: LayoutWidths.prose),
    child: StyledText(text, spec ?? TextStyles.body),
  );

  Widget _item() => DocsSection(
    id: 'item',
    title: 'What an item is',
    description:
        'One JSON manifest per installable thing. It declares what it '
        'distributes, where each file goes, what it depends on, and the '
        'sha256 of every byte.',
    child: const DocsApiTable(
      title: 'Manifest fields',
      facts: <DocsApiFact>[
        DocsApiFact(
          name: 'name, version, type',
          type: 'String',
          description:
              'The identity you type. `type` is component, effect, motion or '
              'foundation, and decides nothing about installation — it is how '
              'the catalog is grouped, not how it is resolved.',
        ),
        DocsApiFact(
          name: 'files',
          type: 'List',
          description:
              'Dart sources. Each carries a source path, a logical target, '
              'and a sha256.',
        ),
        DocsApiFact(
          name: 'assets, fonts, shaders',
          type: 'List',
          description:
              'Non-Dart payloads. Fonts additionally carry the family name '
              'they must register under — it is not derivable from the '
              'filename, and guessing it renders every glyph in the fallback '
              'face.',
        ),
        DocsApiFact(
          name: 'licenses',
          type: 'List',
          description:
              'Third-party notices that install with the item, into your '
              'LICENSES/ directory. Optional: most items redistribute '
              'nothing.',
        ),
        DocsApiFact(
          name: 'registryDependencies',
          type: 'List<String>',
          description:
              'Other items that must be installed for this one to compile.',
        ),
        DocsApiFact(
          name: 'semanticDependencies',
          type: 'List<String>',
          description:
              'The subset this item genuinely uses, as opposed to what it '
              'merely needs present. Documentation reads this; the installer '
              'reads the one above.',
        ),
        DocsApiFact(
          name: 'pubDependencies',
          type: 'Map<String, String>',
          description:
              'Package constraints the installer merges into your '
              'pubspec.yaml.',
        ),
        DocsApiFact(
          name: 'minDart, minFlutter',
          type: 'String',
          description: 'The SDK floor the item was built against.',
        ),
      ],
    ),
  );

  Widget _dependencies() => DocsSection(
    id: 'dependencies',
    title: 'How dependencies resolve',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'You name one item. The CLI walks its registryDependencies depth '
          'first, then theirs, and installs the closure in dependency order '
          'so a file never lands before something it imports. Cycles are '
          'detected and reported by name rather than followed.',
        ),
        SizedBox(height: space(4)),
        const DocsSnippet(
          language: 'bash',
          code:
              '# button depends on icon, field, surface and the\n'
              '# foundation, so all of them are installed with it.\n'
              'elattar add button\n\n'
              '# See the closure without writing anything.\n'
              'elattar add button --dry-run',
        ),
        SizedBox(height: space(4)),
        _prose(
          'An item appears once however many times it is depended on, and '
          'installing something twice is a no-op rather than a conflict — the '
          'installer compares bytes before it writes.',
          spec: TextStyles.small,
        ),
      ],
    ),
  );

  Widget _targets() => DocsSection(
    id: 'targets',
    title: 'Where files land',
    description:
        'A manifest never names a path in your project. It names a logical '
        'target, and the installer maps it. That indirection is what lets '
        'the same registry serve a project whose layout it has never seen.',
    child: FutureBuilder<RegistrySnapshot>(
      future: snapshot,
      builder: (BuildContext context, AsyncSnapshot<RegistrySnapshot> state) =>
          switch (state) {
            AsyncSnapshot<RegistrySnapshot>(data: final RegistrySnapshot s) =>
              DocsApiTable(
                title: 'Logical targets in this registry',
                facts: <DocsApiFact>[
                  for (final RegistryTargetCount target in s.targets)
                    DocsApiFact(
                      name: target.prefix,
                      type: target.destination.isEmpty
                          ? '—'
                          : target.destination,
                      description:
                          '${target.count} file'
                          '${target.count == 1 ? '' : 's'} in this '
                          'registry install here.',
                    ),
                ],
              ),
            AsyncSnapshot<RegistrySnapshot>(hasError: true) =>
              const _TargetsUnavailable(),
            _ => const _Loading(),
          },
    ),
  );

  Widget _hashes() => DocsSection(
    id: 'hashes',
    title: 'Hashes',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Every file a manifest declares carries the sha256 of its bytes. '
          'The CLI checks each one after downloading and before writing, and '
          'a mismatch aborts the whole command — not the file, the command. '
          'Nothing is written until everything has arrived and verified, so a '
          'dropped connection or a substituted payload leaves your project '
          'exactly as it was rather than half-installed behind a barrel that '
          'references files which never came.',
        ),
        SizedBox(height: space(4)),
        _prose(
          'The same hashes are recorded in your .elattar/manifest.json when '
          'the files land, which is how a later add knows whether you edited '
          'an installed file or not.',
          spec: TextStyles.small,
        ),
      ],
    ),
  );

  Widget _hosted() => DocsSection(
    id: 'hosted',
    title: 'Versioned and hosted',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'The CLI reads a registry pinned to its own version. elattar_cli '
          '0.0.1 reads /registry/0.0.1/, and that path is immutable: a '
          'change ships as a new version rather than as a rewrite of a '
          'released one. The publishing tool refuses to overwrite a '
          'published version with different bytes, which is what makes the '
          'pin mean something.',
        ),
        SizedBox(height: space(4)),
        const DocsSnippet(
          language: 'bash',
          code:
              '# A mirror.\n'
              'elattar list --registry https://example.com/elattar/0.0.1/\n\n'
              '# A registry you generated yourself.\n'
              'elattar list --registry ../flutter-design-system/registry/generated/latest',
        ),
        SizedBox(height: space(4)),
        _prose(
          'A URL is recorded in elattar.yaml and is safe to commit. A local '
          'path is recorded only when it sits inside your project: an '
          'absolute path in a committed config works on exactly one machine.',
          spec: TextStyles.small,
        ),
      ],
    ),
  );

  Widget _offline() => DocsSection(
    id: 'offline',
    title: 'Cache and offline',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'Downloads are cached per user, under the platform cache directory, '
          'with ELATTAR_CACHE_DIR as the override. --offline reads only that '
          'cache and never opens a connection.',
        ),
        SizedBox(height: space(4)),
        const DocsSnippet(
          language: 'bash',
          code:
              'elattar add button            # populates the cache\n'
              'elattar list --offline        # reads only the cache',
        ),
        SizedBox(height: space(4)),
        _prose(
          'A cache miss and a network failure are reported differently, '
          'because they have different fixes: one asks you to run the command '
          'once online, the other to check your connection. A successful '
          'online install also warms the catalog, so list and search work '
          'offline afterwards rather than missing on a file no install '
          'fetched.',
          spec: TextStyles.small,
        ),
      ],
    ),
  );

  Widget _commands() => DocsSection(
    id: 'commands',
    title: 'Reading the registry',
    description:
        'Four commands answer questions about the registry without changing '
        'anything in your project.',
    child: const DocsSnippet(
      language: 'bash',
      code:
          'elattar list                  # every item, with type and description\n'
          'elattar search chart          # ranked matches\n'
          'elattar info button           # one item: files, targets, dependencies\n'
          'elattar doctor                # what registry would be used, and whether it answers',
    ),
  );

  Widget _ownership(BuildContext context) => DocsSection(
    id: 'ownership',
    title: 'Source ownership',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _prose(
          'The registry is a distribution format, not a runtime. Nothing in '
          'your project depends on it after an install: the files are yours, '
          'the imports point at your own code, and deleting the CLI changes '
          'nothing. The only thing that reaches back in is elattar add '
          '--overwrite, and only for the files it installed.',
        ),
        SizedBox(height: space(4)),
        _prose(
          'Items that redistribute somebody else\'s work bring the notice '
          'with them. Keep those files: carrying the notice is the condition '
          'their licenses attach to the grant.',
        ),
        SizedBox(height: space(5)),
        Button(
          variant: ButtonVariant.outline,
          onPressed: onNavigate == null
              ? null
              : () => onNavigate!(docsInstallationRoute),
          child: const Text('Installation'),
        ),
      ],
    ),
  );

  Widget _notIncluded() => DocsSection(
    id: 'not-included',
    title: 'What this is not',
    description:
        'Named so a reader stops looking. These are things a registry can '
        'have and this one does not.',
    child: const DocsApiTable(
      title: 'Not Elattar features',
      facts: <DocsApiFact>[
        DocsApiFact(
          name: 'Authentication',
          type: 'not implemented',
          description:
              'Every registry this CLI reads is public and unauthenticated. '
              'There are no tokens, accounts or private items.',
        ),
        DocsApiFact(
          name: 'Namespaces',
          type: 'not implemented',
          description:
              'An item name is a bare slug. Nothing scopes the names of one '
              'registry against those of another, so a mirror is a copy '
              'rather than a namespace.',
        ),
        DocsApiFact(
          name: 'Server-side search',
          type: 'not implemented',
          description:
              'search runs locally over the catalog the CLI already has. '
              'The registry serves static files and answers no queries.',
        ),
        DocsApiFact(
          name: 'An MCP server',
          type: 'not implemented',
          description:
              'Nothing here exposes the registry to an agent over a '
              'protocol. An agent reads the same files a person does.',
        ),
      ],
    ),
  );
}

/// The loaded figures.
class _Figures extends StatelessWidget {
  const _Figures({required this.snapshot});

  final RegistrySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final RegistrySnapshot s = snapshot;
    return DocsInstallFacts(
      key: const ValueKey<String>('registry-figures'),
      title: 'Registry ${s.registryVersion}, schema v${s.schemaVersion}',
      facts: <DocsInstallFact>[
        DocsInstallFact(
          label: 'Items',
          value: '${s.itemCount}',
          description: <String>[
            for (final RegistryKindCount kind in s.kinds)
              '${kind.count} ${kind.kind}',
          ].join(', '),
        ),
        DocsInstallFact(
          label: 'Distributed files',
          value: '${s.distributedFiles}',
          description:
              'Dart sources, assets, fonts, shaders and license notices, '
              'each with a recorded sha256.',
        ),
        DocsInstallFact(
          label: 'Dependency edges',
          value: '${s.dependencyEdges}',
          description:
              '${s.semanticEdges} of them are semantic — a component actually '
              'using another, rather than merely needing it installed.',
        ),
        DocsInstallFact(
          label: 'Items carrying a notice',
          value: '${s.itemsWithLicenses}',
          description:
              'Each installs its third-party license text into your '
              'LICENSES/ directory alongside the source it covers.',
        ),
        if (s.deprecatedCount > 0)
          DocsInstallFact(
            label: 'Deprecated',
            value: '${s.deprecatedCount}',
            description:
                'Still installable, and each names its replacement in the '
                'manifest.',
          ),
      ],
    );
  }
}

/// Layout-preserving loading. The figures block is a fixed set of rows, so a
/// skeleton of the same shape keeps the page from jumping when they arrive.
class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Loading the registry figures',
    liveRegion: true,
    child: Column(
      key: const ValueKey<String>('registry-loading'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (int row = 0; row < 4; row++) ...<Widget>[
          Skeleton(height: space(10)),
          SizedBox(height: space(3)),
        ],
      ],
    ),
  );
}

/// A registry that parsed and contains nothing.
///
/// Not reachable from a correct build, and worth rendering anyway: the
/// alternative is a page that silently shows a heading with nothing under it
/// and looks like a rendering bug.
class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) => Empty(
    key: const ValueKey<String>('registry-empty'),
    children: <Widget>[
      const EmptyHeader(
        children: <Widget>[
          EmptyMedia(glyph: IconGlyph.package),
          EmptyTitle('This registry is empty'),
          EmptyDescription(
            'It parsed correctly and declares no items. A registry built from '
            'a tree with no manifests looks like this.',
          ),
        ],
      ),
    ],
  );
}

/// The failure state, with the one action that can help.
class _Failed extends StatelessWidget {
  const _Failed({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Column(
    key: const ValueKey<String>('registry-error'),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      // `Alert`'s destructive variant carries an icon and a title as well as
      // its colour, so the state is legible without relying on hue — and it is
      // announced rather than merely coloured.
      // What happened and what to do, in words a reader can act on. The
      // parser's own sentence is a diagnostic, not an instruction, so it
      // goes behind the disclosure rather than into the alert: a public
      // reader can do nothing with it, and it is the first thing a
      // maintainer asks for.
      const Alert(
        variant: AlertVariant.destructive,
        icon: Icon(IconGlyph.circleX),
        title: 'The registry figures could not be read',
        description:
            'The rest of this page is unaffected. Try again, and if it keeps '
            'failing the published registry is the thing at fault, not your '
            'setup.',
      ),
      SizedBox(height: space(4)),
      Align(
        alignment: Alignment.centerLeft,
        child: Button(onPressed: onRetry, child: const Text('Try again')),
      ),
      SizedBox(height: space(4)),
      DocsDisclosure(
        title: 'Technical detail',
        // The raw message is the point here: this is the diagnostic
        // disclosure, not the copy. The alert above it carries what
        // happened and what to do.
        child: StyledText('$error', TextStyles.small), // ui-check: ignore
      ),
    ],
  );
}

/// The targets table has nothing to show when the load failed. The figures
/// block above already carries the error and the retry, so this says only
/// that it is downstream of the same problem.
class _TargetsUnavailable extends StatelessWidget {
  const _TargetsUnavailable();

  @override
  Widget build(BuildContext context) => Alert(
    key: const ValueKey<String>('registry-targets-unavailable'),
    variant: AlertVariant.warning,
    icon: const Icon(IconGlyph.alertTriangle),
    title: 'Target counts unavailable',
    description:
        'These are counted from the same registry the figures above could '
        'not read.',
  );
}
