/// Public documentation page for the `safe-area` component.
///
/// **A user-ordered mobile adaptation, not a port.** Say so plainly: every
/// other page in this rollout documents something the reference already
/// had. `ElSafeArea` exists because screenshots on 2026-08-16 showed the
/// docs header sitting behind a phone's clock and the reading column
/// running under the gesture bar — a real bug report, not a translated
/// spec. There is no `app/globals.css` line to cite; the class doc states
/// the ruling itself and this page documents that ruling.
///
/// **Why `EffectSection`, not `ShowcaseSection`.** `ElSafeArea` carries no
/// variant enum and paints nothing of its own: it either inserts a
/// [Padding] and a narrowed [MediaQuery] around `child`, or — the zero
/// short-circuit the class doc calls out — returns `child` completely
/// unwrapped. What is worth looking at is what it does to a host under a
/// simulated system-bar inset, not a specimen of the widget alone.
///
/// **Responsive is the disclosure that matters here.** Every other
/// component's Responsive section is a paragraph about breakpoints;
/// `ElSafeArea` has none — its entire reason to exist IS a device-class
/// distinction, so that disclosure carries the real content and the
/// States disclosure is comparatively thin.
///
/// **The inset numbers on this page are illustrative, not measured.** A
/// real iPhone's status bar and gesture-pill insets vary by model; this
/// page simulates a representative top and bottom inset via a nested
/// `MediaQuery`, sized off `el(...)` like everything else under
/// `example/lib/`, rather than a literal device measurement copied from a
/// spec sheet.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../../docs/component_doc_page.dart';
import '../../docs/docs_facts.dart';
import '../../docs/docs_layout.dart';
import '../../docs/docs_section.dart' show DocsAnchor;
import 'meta.dart';

/// A representative status-bar inset for the mock phone stages on this
/// page — not a measured device value, an `el()` step close to one.
double get _mockTopInset => el(12);

/// A representative gesture-pill inset.
double get _mockBottomInset => el(8);

final ComponentDocSpec safeAreaDocSpec = ComponentDocSpec(
  name: 'safe_area',
  title: 'Safe Area',
  description: safeAreaDoc.description,
  sections: <DocsPageSection>[
    EffectSection(
      id: 'preview',
      title: 'Preview',
      description:
          'The same mock phone frame, under the same simulated system-bar '
          'padding, twice. The left one has no ElSafeArea at all: its row '
          'of controls sits at the raw top-left and collides with the '
          'status-bar strip painted over it. The right one wraps only the '
          'controls in ElSafeArea(bottom: false): the background keeps '
          'painting edge-to-edge behind the strip, but the row itself '
          'moves down to clear it.',
      host: const _PreviewHost(),
      code: _previewCode,
      label: 'Preview specimen view',
    ),
    InstallSection(
      id: 'install',
      title: 'Installation',
      description:
          'safe-area has a real registry manifest, `elattar add '
          'safe-area` installs lib/src/components/safe_area.dart. Its '
          'registryDependencies list is empty — the Manual tab is for a '
          'project not using the CLI.',
      command: safeAreaDoc.command,
      manualFiles: <DocsCodeFile>[
        DocsCodeFile(
          path: 'lib/components/ui/safe_area.dart',
          title: '1. Copy the source',
          description:
              "Copy lib/src/components/safe_area.dart's generated "
              '@ui/safe_area.dart payload into components/ui.',
          code:
              "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
              '// Copy the generated safe-area source here when using '
              'manual mode.',
        ),
        DocsCodeFile(
          path: 'lib/components/ui/ui.dart',
          title: '2. Export it from your barrel',
          description:
              'Add the export line so ElSafeArea is reachable the same '
              'way the CLI path already makes it.',
          code: "export 'safe_area.dart';",
        ),
      ],
    ),
    SnippetSection(
      id: 'usage',
      title: 'Usage',
      description:
          'Pay the top inset on a bar that paints to the screen edge, and '
          'move only its controls: bottom: false, because a bar pinned to '
          'the top of the window owes the gesture bar nothing.',
      code: _usageCode,
    ),
    EffectSection(
      id: 'scroll-content',
      title: 'Scroll Content',
      description:
          'ElSafeArea.scrollPaddingOf adds the bottom and both horizontal '
          'insets to a scroll view\'s own padding — never the top, which '
          'belongs to the bar\'s own height instead. The left list uses '
          'plain EdgeInsets.zero and its last row sits under the '
          'simulated gesture pill. The right list uses scrollPaddingOf and '
          'its last row comes to rest clear of it, still draggable past '
          'the strip rather than trapped under a dead margin.',
      host: const _ScrollContentHost(),
      code: _scrollContentCode,
      label: 'Scroll content specimen view',
      minHeight: el(80),
    ),
    EffectSection(
      id: 'desktop',
      title: 'Desktop (Zero Insets)',
      description:
          'The same wrapped row under a MediaQuery carrying '
          'EdgeInsets.zero — a desktop window, a browser tab, or any test '
          'that never sets view.padding. ElSafeArea\'s own build() '
          'short-circuits when the insets it would spend are all zero and '
          'returns child completely unwrapped: no Padding, no narrowed '
          'MediaQuery, nothing joins the tree. The row below sits exactly '
          'where it would with no ElSafeArea present at all.',
      host: const _DesktopHost(),
      code: _desktopCode,
      label: 'Desktop specimen view',
    ),
    DisclosureSection(
      id: 'api',
      title: 'API Reference',
      description:
          'Every constructor parameter ElSafeArea declares, plus its '
          'three static helpers, read off '
          'lib/src/components/safe_area.dart.',
      children: const <DocsTocEntry>[
        DocsTocEntry(title: 'ElSafeArea', anchor: 'api-elsafearea'),
        DocsTocEntry(
          title: 'ElSafeArea static',
          anchor: 'api-elsafearea-static',
        ),
      ],
      child: const _ApiReferenceContent(),
    ),
    DisclosureSection(
      id: 'states',
      title: 'States',
      child: const _StatesContent(),
    ),
    DisclosureSection(
      id: 'accessibility',
      title: 'Accessibility',
      child: const _AccessibilityContent(),
    ),
    DisclosureSection(
      id: 'keyboard',
      title: 'Keyboard',
      child: const _KeyboardContent(),
    ),
    DisclosureSection(
      id: 'responsive',
      title: 'Responsive',
      child: const _ResponsiveContent(),
    ),
    DisclosureSection(
      id: 'dependencies',
      title: 'Dependencies',
      child: const _DependenciesContent(),
    ),
    DisclosureSection(
      id: 'theming',
      title: 'Theming',
      child: const _ThemingContent(),
    ),
    DisclosureSection(
      id: 'source',
      title: 'Source',
      child: DocsInstallFacts(
        title: 'Reference',
        facts: <DocsInstallFact>[
          DocsInstallFact(
            label: 'Source',
            value: safeAreaDoc.sourcePath,
            description:
                'Authoritative implementation: the truth this page was '
                'written from.',
          ),
          const DocsInstallFact(
            label: 'Package tests',
            value: 'test/safe_area_test.dart',
            description:
                'The dedicated suite: content moves and paint does not, '
                'nothing is paid twice, and zero costs nothing — the '
                'three parts of the ruling, each asserted directly.',
          ),
          const DocsInstallFact(
            label: 'Docs test',
            value: 'example/test/components_docs/safe_area_test.dart',
            description:
                'Covers this page: the article mounts, the full API '
                'table, a live mounted comparison under a simulated '
                'inset, and both themes.',
          ),
          const DocsInstallFact(
            label: 'Edit these docs',
            value: 'example/lib/components_docs/safe_area/page.dart',
            description: 'This file.',
          ),
        ],
      ),
    ),
  ],
);

class SafeAreaDocPage extends StatelessWidget {
  const SafeAreaDocPage({super.key, this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => DocsLayout(
    route: safeAreaDoc.route,
    intro: DocsPageIntro(
      eyebrow: 'COMPONENTS / PRIMITIVES',
      title: safeAreaDoc.title,
      description: safeAreaDoc.description,
    ),
    breadcrumbs: const <ElBreadcrumbEntry>[
      ElBreadcrumbEntry.link('Components'),
      ElBreadcrumbEntry.page('Safe Area'),
    ],
    toc: safeAreaDocSpec.toc,
    previous: null,
    next: null,
    onNavigate: onNavigate,
    child: KeyedSubtree(
      key: const ValueKey<String>('safe-area-doc-article'),
      child: ComponentDocPage(spec: safeAreaDocSpec, header: false),
    ),
  );
}

/* ── Shared specimen shape ──────────────────────────────────────────────── */

class _Captioned extends StatelessWidget {
  const _Captioned({required this.caption, required this.child});

  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      child,
      SizedBox(height: el(2)),
      ElText(caption, ElType.section, color: ElTheme.of(context).mutedForeground),
    ],
  );
}

class _Row extends StatelessWidget {
  const _Row({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: el(2)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < children.length; i++) ...<Widget>[
            if (i > 0) SizedBox(width: el(6)),
            children[i],
          ],
        ],
      ),
    ),
  );
}

/// The device outline every stage on this page paints inside — full-bleed
/// background, a status-bar strip drawn ON TOP of it (never inset), clipped
/// to rounded corners the way a phone's own screen is.
class _PhoneFrame extends StatelessWidget {
  const _PhoneFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(ElRadii.xl2),
      child: Container(
        width: el(36),
        height: el(60),
        color: theme.background,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // The background: painted edge-to-edge, full bleed, exactly as
            // the ruling asks — nothing here is ever inset.
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    theme.primary.withValues(alpha: 0.16),
                    theme.background,
                  ],
                ),
              ),
            ),
            // The simulated status bar, painted OVER the background — this
            // is the obstruction the content below either collides with or
            // clears.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: _mockTopInset,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.foreground.withValues(alpha: 0.14),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: _mockBottomInset,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.foreground.withValues(alpha: 0.14),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(el(3)), child: child),
          ],
        ),
      ),
    );
  }
}

class _ControlsRow extends StatelessWidget {
  const _ControlsRow();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.card,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: EdgeInsets.all(el(1)),
            child: const ElIcon(ElIconGlyph.menu, size: ElIconSize.sm),
          ),
        ),
        SizedBox(width: el(2)),
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.card,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: EdgeInsets.all(el(1)),
            child: const ElIcon(ElIconGlyph.search, size: ElIconSize.sm),
          ),
        ),
      ],
    );
  }
}

/* ── Preview ─────────────────────────────────────────────────────────────── */

class _PreviewHost extends StatelessWidget {
  const _PreviewHost();

  @override
  Widget build(BuildContext context) => MediaQuery(
    data: MediaQuery.of(context).copyWith(
      padding: EdgeInsets.only(top: _mockTopInset, bottom: _mockBottomInset),
    ),
    child: _Row(
      children: <Widget>[
        _Captioned(
          caption: 'without ElSafeArea',
          child: SizedBox(
            key: const ValueKey<String>('safe-area-example:without'),
            child: _PhoneFrame(
              child: Align(
                alignment: Alignment.topLeft,
                child: const _ControlsRow(),
              ),
            ),
          ),
        ),
        _Captioned(
          caption: 'ElSafeArea(bottom: false, child: controls)',
          child: SizedBox(
            key: const ValueKey<String>('safe-area-example:with'),
            child: _PhoneFrame(
              child: Align(
                alignment: Alignment.topLeft,
                child: ElSafeArea(
                  bottom: false,
                  child: const _ControlsRow(),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

const String _previewCode =
    "import 'package:elattar_design_system/elattar_design_system.dart';\n\n"
    '// Without: the row sits at the raw top and collides with the status\n'
    '// bar painted over the same edge-to-edge background.\n'
    'Align(alignment: Alignment.topLeft, child: controls)\n\n'
    '// With: only the row moves. The background is untouched.\n'
    'Align(\n'
    '  alignment: Alignment.topLeft,\n'
    '  child: ElSafeArea(bottom: false, child: controls),\n'
    ')';

/* ── Scroll Content ──────────────────────────────────────────────────────── */

class _MockList extends StatelessWidget {
  const _MockList({required this.padding});

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ListView(
      padding: padding,
      children: <Widget>[
        for (int i = 1; i <= 6; i++)
          Container(
            margin: EdgeInsets.only(bottom: el(2)),
            padding: EdgeInsets.symmetric(horizontal: el(3), vertical: el(2)),
            decoration: BoxDecoration(
              color: theme.card,
              borderRadius: BorderRadius.circular(ElRadii.sm),
            ),
            child: ElText('Row $i', ElType.small, color: theme.foreground),
          ),
      ],
    );
  }
}

class _ScrollContentHost extends StatelessWidget {
  const _ScrollContentHost();

  @override
  Widget build(BuildContext context) => MediaQuery(
    data: MediaQuery.of(context).copyWith(
      padding: EdgeInsets.only(bottom: _mockBottomInset),
    ),
    child: Builder(
      builder: (BuildContext context) => _Row(
        children: <Widget>[
          _Captioned(
            caption: 'EdgeInsets.zero',
            child: SizedBox(
              key: const ValueKey<String>('safe-area-example:scroll-zero'),
              child: _PhoneFrame(
                child: const _MockList(padding: EdgeInsets.zero),
              ),
            ),
          ),
          _Captioned(
            caption: 'ElSafeArea.scrollPaddingOf(context)',
            child: SizedBox(
              key: const ValueKey<String>('safe-area-example:scroll-padded'),
              child: _PhoneFrame(
                child: _MockList(
                  padding: ElSafeArea.scrollPaddingOf(context),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

const String _scrollContentCode =
    'ListView(\n'
    '  padding: ElSafeArea.scrollPaddingOf(context),\n'
    '  children: rows,\n'
    ')';

/* ── Desktop (Zero Insets) ───────────────────────────────────────────────── */

class _DesktopHost extends StatelessWidget {
  const _DesktopHost();

  @override
  Widget build(BuildContext context) => MediaQuery(
    data: MediaQuery.of(context).copyWith(padding: EdgeInsets.zero),
    child: SizedBox(
      key: const ValueKey<String>('safe-area-example:desktop'),
      child: _PhoneFrame(
        child: Align(
          alignment: Alignment.topLeft,
          child: ElSafeArea(bottom: false, child: const _ControlsRow()),
        ),
      ),
    ),
  );
}

const String _desktopCode =
    '// MediaQueryData.padding is EdgeInsets.zero on a desktop window:\n'
    "// ElSafeArea's build() returns child unwrapped, and this line and\n"
    '// the one above it render byte-identical trees.\n'
    'ElSafeArea(bottom: false, child: controls)';

/* ── Disclosure content ─────────────────────────────────────────────────── */

const String _usageCode = '''
import 'package:elattar_design_system/elattar_design_system.dart';

DecoratedBox(
  decoration: const BoxDecoration(/* paints to the screen edge */),
  child: ElSafeArea(bottom: false, child: headerControls),
)''';

class _ApiReferenceContent extends StatelessWidget {
  const _ApiReferenceContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      DocsAnchor(
        id: 'api-elsafearea',
        child: const DocsApiTable(title: 'ElSafeArea', facts: _apiFacts),
      ),
      SizedBox(height: el(4)),
      DocsAnchor(
        id: 'api-elsafearea-static',
        child: const DocsApiTable(
          title: 'ElSafeArea static',
          facts: _staticFacts,
        ),
      ),
    ],
  );
}

const List<DocsApiFact> _apiFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'left',
    type: 'bool',
    description:
        'Optional. Defaults to true. Pay the left inset — a notch or a '
        'rounded corner in landscape.',
  ),
  DocsApiFact(
    name: 'top',
    type: 'bool',
    description: 'Optional. Defaults to true. Pay the top inset — the '
        'status bar.',
  ),
  DocsApiFact(
    name: 'right',
    type: 'bool',
    description: 'Optional. Defaults to true. Pay the right inset.',
  ),
  DocsApiFact(
    name: 'bottom',
    type: 'bool',
    description:
        'Optional. Defaults to true. Pay the bottom inset — the gesture '
        'pill or the navigation bar.',
  ),
  DocsApiFact(
    name: 'child',
    type: 'Widget',
    description:
        'Required. What gets moved. Whatever paints AROUND this widget '
        'does not.',
  ),
];

const List<DocsApiFact> _staticFacts = <DocsApiFact>[
  DocsApiFact(
    name: 'insetsOf',
    type: 'static EdgeInsets Function(BuildContext)',
    description:
        'The system bars\' insets in context: MediaQueryData.padding, '
        'never viewInsets — the keyboard is a different surface\'s '
        'problem. EdgeInsets.zero where there is no MediaQuery at all.',
  ),
  DocsApiFact(
    name: 'topBarHeightOf',
    type: 'static double Function(BuildContext, double)',
    description:
        'The height a bar pinned to the top of the window must reserve '
        'to render `height` of content below the status bar: '
        'height + insetsOf(context).top.',
  ),
  DocsApiFact(
    name: 'scrollPaddingOf',
    type: 'static EdgeInsets Function(BuildContext, {EdgeInsets base})',
    description:
        'base plus what a scroll view owes the bars it scrolls under: '
        'the bottom and both horizontal insets, never the top — the top '
        'bar\'s own height already reserves that room.',
  ),
];

class _StatesContent extends StatelessWidget {
  const _StatesContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElSafeArea carries no internal state of its own: build() reads '
            'MediaQuery.paddingOf(context) fresh on every rebuild and '
            'either wraps child in a Padding plus a narrowed MediaQuery, '
            'or returns it unwrapped when every inset it would spend is '
            'zero.',
        'The one real variable is the ambient MediaQueryData.padding '
            'itself, which this widget never sets — only reads. A caller '
            'rotating a device, or a test that changes tester.view.'
            'padding, changes what ElSafeArea spends on the next frame; '
            'nothing here animates the transition.',
      ]);
}

class _AccessibilityContent extends StatelessWidget {
  const _AccessibilityContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElSafeArea renders no Semantics node of its own: build() '
            'returns either child directly or a Padding wrapping it, '
            'neither of which declares accessibility metadata. Whatever '
            'semantics child carries pass through untouched.',
        'The effect is itself an accessibility fix rather than a purely '
            'visual one: content that a system bar physically occludes is '
            'also unreachable to a sighted user\'s pointer, and moving it '
            'clear keeps both the visual and the interactive surface in '
            'the same place.',
      ]);
}

class _KeyboardContent extends StatelessWidget {
  const _KeyboardContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'Takes no focus and handles no key: safe_area.dart declares no '
            'Focus, no FocusNode and no onKeyEvent. It reads '
            'MediaQueryData.padding, never viewInsets — the library note '
            'is explicit that the software keyboard is deliberately not '
            'this file\'s inset, so it never enters this widget\'s '
            'calculation at all.',
      ]);
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'This is the disclosure the whole component exists for. '
            'ElSafeArea is not a breakpoint switch — it reads no width at '
            'all — but it is the one thing on this kit that is entirely a '
            'device-class distinction: a phone with a notch and a gesture '
            'bar behaves one way, and a desktop window behaves as if the '
            'widget were not there.',
        'The zero short-circuit is the mechanism, not an optimisation '
            'bolted on afterward: build() compares the spend it would '
            'make against EdgeInsets.zero and returns child completely '
            'unwrapped when they match — no Padding, no MediaQuery.'
            'removePadding — which is what keeps every desktop geometry '
            'pin in the package\'s own test suite measuring the exact '
            'tree it measured before this file existed. See the Desktop '
            '(Zero Insets) section above.',
        'Nesting is safe by construction: whatever insets a wrapper '
            'spends are removed from the MediaQuery it hands its child '
            'via MediaQuery.removePadding, so a ElSafeArea inside a sheet '
            'that already paid the bottom bar reads zero there and adds '
            'nothing — never a double margin.',
        'Three insets exist on MediaQueryData and this file reads '
            'exactly one: padding (the bars, always present) — never '
            'viewInsets (the keyboard, transient, owned by whatever is '
            'focused) and never viewPadding (padding as it would read '
            'with no keyboard up, which would fight the keyboard for the '
            'same pixels). See the Keyboard disclosure above.',
      ]);
}

class _DependenciesContent extends StatelessWidget {
  const _DependenciesContent();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _bullets(ElTheme.of(context), <String>[
        'File: lib/src/components/safe_area.dart: one file, no '
            'companions.',
        'Flutter imports: package:flutter/widgets.dart only.',
        'No foundation import at all: ElSafeArea reads MediaQuery, not a '
            'design token — the one component page in this rollout whose '
            'registryDependencies list is genuinely empty.',
        'registryDependencies, per `elattar add safe-area`: none — '
            'copied verbatim from registry/components/safe-area.json.',
        'Real use in this corpus: example/lib/shell.dart wraps the whole '
            'app frame\'s landscape sides once, the sticky header (bottom: '
            'false), and each scroll view\'s own padding via '
            'scrollPaddingOf — the drawer, the sheet and the toaster '
            'pages reach for it the same way.',
      ]),
      SizedBox(height: el(2)),
      DocsLinkRow(
        links: <DocsLink>[
          DocsLink(label: 'Sheet', route: '/components/sheet'),
          DocsLink(label: 'Drawer', route: '/components/drawer'),
        ],
      ),
    ],
  );
}

class _ThemingContent extends StatelessWidget {
  const _ThemingContent();

  @override
  Widget build(BuildContext context) =>
      _bullets(ElTheme.of(context), <String>[
        'ElSafeArea reads no Color and no ElTheme at all: it is pure '
            'geometry, MediaQuery in and Padding out. Every colour on '
            'this page\'s specimens — the mock status-bar strip, the '
            'phone frame\'s own background — comes from the demo host '
            'this page builds around it, never from safe_area.dart '
            'itself.',
        'Because it carries no colour of its own, it never needs a '
            'light/dark branch: the same insets are spent the same way '
            'in both themes, which is exactly what the "renders in both '
            'themes without throwing" test below checks for.',
      ]);
}

Widget _bullets(ElThemeData theme, List<String> lines) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    for (final String line in lines) ...<Widget>[
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ElWidths.prose),
        child: ElText('•  $line', ElType.small, color: theme.mutedForeground),
      ),
      SizedBox(height: el(2)),
    ],
  ],
);
