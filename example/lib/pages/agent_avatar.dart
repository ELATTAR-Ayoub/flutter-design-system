/// `/design-system/components/agent/avatar` — twenty isometric cube scenes,
/// one per state, plus the voice orb.
///
/// The shortest agent page and the busiest render in the corpus: §states alone
/// draws twenty avatars, nineteen of them isometric scenes holding up to twenty
/// animated cubes each, and §playground, §sizes and §accent add nine more.
/// **Two hundred and thirty-one cubes are in motion before the reader touches
/// anything**, on nineteen different periods. Supervisor ruling F2 applies as
/// it does on the feedback page: all of them build and all of them run, and the
/// only gate is `dsAnimationDuration`.
///
/// ## What is page-local, and why
///
/// [_StatusLine] ports `parts/agent-face.tsx`'s `StatusLine`, which belongs to
/// the console family. It has exactly one consumer here, so it stays on this
/// page on the B10 precedent — promotion to the package needs a second one.
/// Its shimmer is `@utility anim-shimmer-text`, which is `pulls-shimmer` (the
/// keyframes `DsSkeleton` already runs) at [DsDurations.shimmerText] over a
/// **three-stop, 100deg, 220%-wide** gradient clipped to the glyphs — a
/// different utility from both `anim-shimmer` and the `shimmer` one
/// `DsShimmerText` carries, and the reason it is spelled out rather than
/// reused.
///
/// [_Matrix] is `components/ds/agent-demo.tsx`'s `AvatarMatrix` and
/// [_Playground] its `AvatarPlayground`. Both are docs-side components in the
/// reference too, and both are page-local grids rather than kit ones: the
/// matrix is `grid-cols-2 sm:grid-cols-4 lg:grid-cols-5`, which is **none** of
/// the kit's five column maps (`cols={5}` is `2 / 3 / 5`), so only the lattice
/// frame is shared. That is what [DsStateGrid.columns] is for.
///
/// ## Probes
///
/// `scratchpad/ag-avatar-inv.js` → `ag-avatar-light.{json,txt}`, 1440 × 900,
/// 2026-08-16, plus `tool/verify/section-oracle.js` on the same route. The
/// inventory walked all twenty specimens for viewBox, resolved width, every
/// polygon's four paint properties and every animated group's live `animation`
/// shorthand; the idle cube was read separately for `perspective`, face size
/// and its six face transforms. Both themes report identical geometry.
///
/// ## Probe corrections — what the source said and the browser did not
///
///  1. **`--agent-cube-error-right` is one 8-bit step apart.**
///     `hsl(0 60% 75%)` puts the red channel on 0.9 × 255 = **229.5 exactly**;
///     Chrome rounds it up to 230 and `dsHsl` down to 229. One channel of one
///     token, in the foundation's hsl conversion rather than in this family.
///     Nothing else in the twelve-token block differs at all.
///  2. **`scenes.ts`'s durations are rounded before the browser ever sees
///     them.** `anim()` builds the shorthand with `(seconds / speed).toFixed(2)`,
///     so `speed` is applied to two decimal places and not to full precision —
///     visible the moment `speed` is not 1, and reproduced.
///  3. **The `<g>` counts are one higher than the cube counts on two scenes.**
///     `delegating` reports 10 groups for 9 cubes and `searching` 16 for 15,
///     because `CubeShape` wraps a cube carrying `outer` in a second `<g>`.
///     The other seventeen match exactly.
///  4. **A cube's right face is invisible unless nothing stands in front of
///     it.** Measured on `queued`: the accented cube's `--agent-cube-accent`
///     right face contributes **zero** pixels, because its neighbour's top and
///     left faces tile over it exactly. Only the last cube in a row shows one.
///  5. **`type-chip` is 11.5px, not the 12 the class name suggests**, and the
///     status line is the only `.type-chip` on the page.
///
/// ## Drift register — recorded, shipped as written
///
///  1. **The eyebrow says "Agent" against a group already called "Agent".**
///     `` `${group.title} · Components` `` with `group.title = "Agent"`, so the
///     header reads *Agent · Components* — the base pages' *"Base twice"* drift
///     in its agent-group form.
///  2. **Five contents chips against seven sections.** `nav.ts` lists *State
///     set*, *Sizes*, *Accent knob*, *Voice orb* and *Reduced motion*;
///     §playground and §renderer are unlisted, and not one chip's text matches
///     the section title it points at (*State set* against *Twenty states*).
///  3. **The playground's buttons are labelled with wire ids, not labels.**
///     `{s}` renders `awaiting_approval` and `calling_tools` — snake_case, in
///     a system whose every other control is sentence case — while the status
///     line beside them renders the sentence. Both are correct for what they
///     are and the page never says so.
///  4. **§renderer documents a `className` prop the page does not list.**
///     `AvatarRendererProps` has five members; the Meta block shows four.
///  5. **The page's own copy says "twenty scenes" and there are nineteen.**
///     `scenes.ts` holds nineteen generators; idle is *"the one exception and
///     has no entry"*, being a real 3D cube. The Note's *"recolours all twenty
///     scenes"* counts it, and so does §states' title, which is right about
///     states and wrong about scenes.
///  6. **`AvatarMatrix` takes an `accent` prop the page never passes.** The
///     matrix is always the default `var(--agent)`; §accent is where the knob
///     is shown, one avatar at a time.
///  7. **The `sm` breakpoint of §states is the one grid in the corpus the kit
///     cannot express.** `grid-cols-2 sm:grid-cols-4 lg:grid-cols-5` against
///     `StateGrid cols={5}`'s `2 / 3 / 5` — a page-local map in the reference
///     too, so the drift is that two grids that look identical at 1440 part
///     company at 640.
///  8. **§orb's Panel note names three.js.** It is the one caption in the
///     system that advertises a third-party renderer by name, on a page whose
///     whole argument is that the face is swappable.
///  9. **`speed` is documented as *"every duration in the set divides by it"*
///     and the idle cube's does not divide cleanly.** `spin3d` is a 9s linear
///     rotation and the only duration outside `scenes.ts`; it does divide, but
///     nothing on the page or in `types.ts` says the resting state is included.
/// 10. **The reduced-motion Note describes a rule the page cannot show.**
///     Its whole subject is what `globals.css` does under
///     `prefers-reduced-motion`, which is by construction invisible to a reader
///     who does not have it set — the one section on the page with no specimen.
library;

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';
import '../nav.dart';

/* ── Page ────────────────────────────────────────────────────────────────── */

class AgentAvatarPage extends StatelessWidget {
  const AgentAvatarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DsCategoryHit here = findCategory('agent', 'avatar');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DsPageHeader(
          // DRIFT 1 — the group is already called "Agent".
          eyebrow: '${here.group.title} · Components',
          title: here.category.title,
          blurb: here.category.blurb,
          // DRIFT 2 — five chips against seven sections.
          contents: here.category.contents,
        ),
        // `className="mb-12"` — 48px, and the only Note on this page outside a
        // section, so the only one at the full 1080.
        Padding(
          padding: EdgeInsets.only(bottom: ds(12)),
          child: const DsNote(
            title: 'The agent acts, so the agent is blue',
            child: _BlueBody(),
          ),
        ),
        const _StatesSection(),
        const _PlaygroundSection(),
        const _SizesSection(),
        const _AccentSection(),
        const _OrbSection(),
        const _RendererSection(),
        const _ReducedMotionSection(),
        const DsPageFootNav(groupId: 'agent', slug: 'avatar'),
      ],
    );
  }
}

/// The page Note — three `<Code>` chips in one paragraph.
class _BlueBody extends StatelessWidget {
  const _BlueBody();

  @override
  Widget build(BuildContext context) => DsRichText(
        TextSpan(
          children: <InlineSpan>[
            const TextSpan(
              text: 'Rule 2 of the seven: blue acts, lime values. An agent '
                  'doing work is an action, so every scene below is lit from ',
            ),
            DsCode.span('--agent-cube-accent'),
            const TextSpan(
              text: ', which points at the blue ramp. The accent’s top and '
                  'right faces are mixed from that one value in ',
            ),
            DsCode.span('oklab'),
            const TextSpan(text: ', so re-pointing a single line in '),
            DsCode.span('globals.css'),
            // DRIFT 5 — nineteen scenes and one 3D cube.
            const TextSpan(
              text: ' recolours all twenty scenes correctly — three lit faces, '
                  'not three unrelated colours.',
            ),
          ],
        ),
        DsType.small,
      );
}

/* ── §1 · states ─────────────────────────────────────────────────────────── */

class _StatesSection extends StatelessWidget {
  const _StatesSection();

  @override
  Widget build(BuildContext context) => const DsSection(
        id: 'states',
        title: 'Twenty states',
        description:
            "Taken from the avatar handoff's enum, so the vocabulary and the "
            'artwork can never drift apart. The list is deliberately closed: a '
            'caller who needs a state that is not here is describing something '
            "the avatar cannot draw, and silently falling back to a generic "
            "'working' is how a status indicator starts lying.",
        child: _Matrix(),
      );
}

/// `AvatarMatrix` — *"Every state in the machine, drawn at once."*
///
/// DRIFT 7. `grid-cols-2 sm:grid-cols-4 lg:grid-cols-5` is a page-local column
/// map, so only the lattice frame comes from the kit.
class _Matrix extends StatelessWidget {
  // DRIFT 6 is the analyzer's finding as well as the register's: the seam is
  // kept because `AvatarMatrix({ accent })` is what the reference declares, and
  // deleting it would silently mend a drift the page is meant to record.
  // ignore: unused_element_parameter
  const _Matrix({this.accent});

  /// DRIFT 6 — the prop exists and the page never passes it.
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    return DsStateGrid.columns(
      base: 2,
      sm: 4,
      lg: 5,
      children: <Widget>[
        for (final DsAgentState state in DsAgentState.values)
          DsStateCell.bare(
            // `p-5`, not the bare cell's own `p-4`.
            padding: EdgeInsets.all(ds(5)),
            child: Column(
              // `flex flex-col items-center gap-3`.
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DsCubeAvatar(
                  state: state,
                  size: DsAgentAvatarSize.lg,
                  accent: accent,
                ),
                SizedBox(height: ds(3)),
                DsText(
                  state.label,
                  DsType.micro,
                  color: theme.mutedForeground,
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/* ── §2 · playground ─────────────────────────────────────────────────────── */

class _PlaygroundSection extends StatelessWidget {
  const _PlaygroundSection();

  @override
  Widget build(BuildContext context) => const DsSection(
        id: 'playground',
        title: 'Face and status line',
        description:
            'The face never appears alone. Present participles with an '
            'ellipsis for anything ongoing, bare words for the three resting '
            'states — the punctuation is doing work, so a glance at the text '
            'alone tells you whether to wait.',
        child: _Playground(),
      );
}

/// `AvatarPlayground` — *"The face plus its status line, cycling under the
/// reader's control."*
class _Playground extends StatefulWidget {
  const _Playground();

  @override
  State<_Playground> createState() => _PlaygroundState();
}

class _PlaygroundState extends State<_Playground> {
  DsAgentState _state = DsAgentState.thinking;

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);

    return Column(
      // `flex flex-col gap-6`.
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // `flex items-center gap-5 rounded-lg border border-border
        //  bg-background p-6`.
        Container(
          padding: EdgeInsets.all(ds(6)),
          decoration: BoxDecoration(
            color: theme.background,
            borderRadius: BorderRadius.circular(DsRadii.lg),
            border: Border.all(color: theme.border, width: DsWidths.hairline),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DsCubeAvatar(state: _state, size: DsAgentAvatarSize.xl),
              SizedBox(width: ds(5)),
              // `min-w-0` on the status line, so the label truncates rather
              // than pushing the row wider than the panel.
              Expanded(child: _StatusLine(state: _state)),
            ],
          ),
        ),
        SizedBox(height: ds(6)),
        // `flex flex-wrap gap-2`.
        Wrap(
          spacing: ds(2),
          runSpacing: ds(2),
          children: <Widget>[
            for (final DsAgentState s in DsAgentState.values)
              DsButton(
                size: DsButtonSize.sm,
                variant: s == _state
                    ? DsButtonVariant.primary
                    : DsButtonVariant.outline,
                onPressed: () => setState(() => _state = s),
                // DRIFT 3 — the wire id, not the label.
                child: Text(s.wire),
              ),
          ],
        ),
      ],
    );
  }
}

/// `StatusLine` — *"The sentence beside the face."*
///
/// *"Shimmers while the agent is working and sits still when it is not, so the
/// status can be read at a glance without parsing the word."*
///
/// `@utility anim-shimmer-text` (globals.css L3051–3070):
///
/// ```css
/// background-image: linear-gradient(100deg,
///   var(--muted-foreground) 30%, var(--agent) 50%, var(--muted-foreground) 70%);
/// background-size: 220% 100%;
/// background-clip: text;
/// color: transparent;
/// animation: pulls-shimmer 2.6s var(--ease-in-out) infinite;
/// ```
///
/// Three mechanics, all of them measured on the live line:
///
/// * `background-clip: text` with `color: transparent` is a [ShaderMask] in
///   [BlendMode.srcIn] over the painted glyphs — the gradient shows *through*
///   the letters and nowhere else.
/// * `pulls-shimmer` is [DsShimmer]'s own table, `200% 0 → −200% 0`, and a
///   `background-position` percentage resolves against `container − image`. At
///   **220%** that is `−1.2W` per unit rather than `−W`, so the band travels
///   `±2.4W` and not `±2W`; [DsShimmer.offsetAt] assumes the 200% tile, so the
///   offset is computed here from the same two stops.
/// * `background-repeat` defaults to `repeat`, so the box is never empty at the
///   extremes — the same fact [DsSkeleton]'s own note records.
///
/// The gradient's `100deg` leans the band ten degrees off vertical. Over a
/// 13.8px line box that is 2.4px of vertical run against ~130px of horizontal,
/// which is why it still reads as a horizontal sweep; it is reproduced anyway,
/// because the axis is what the declaration says.
class _StatusLine extends StatefulWidget {
  const _StatusLine({required this.state});

  final DsAgentState state;

  /// `background-size: 220% 100%`.
  static const double tileFactor = 2.2;

  /// `linear-gradient(100deg, …)`.
  static const double angleDegrees = 100;

  /// The three stops the utility declares.
  static const List<double> stops = <double>[0.30, 0.50, 0.70];

  @override
  State<_StatusLine> createState() => _StatusLineState();
}

class _StatusLineState extends State<_StatusLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: DsDurations.shimmerText,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // `animation: none` under reduced motion, with no fill mode — so the band
    // reverts to stop 0 rather than holding wherever it was.
    if (dsAnimationDuration(context, DsDurations.shimmerText) ==
        Duration.zero) {
      _c.stop();
      _c.value = 0;
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DsThemeData theme = DsTheme.of(context);
    final Widget label = DsText(
      widget.state.label,
      DsType.chip,
      color: theme.mutedForeground,
      // `truncate` — `overflow:hidden white-space:nowrap text-overflow:ellipsis`.
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    );

    // *"…while the agent is working"* — `isBusy(state)`, so the three resting
    // states sit still in `--muted-foreground`.
    if (!widget.state.isBusy) return label;

    return AnimatedBuilder(
      animation: _c,
      builder: (BuildContext context, Widget? child) => ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (Rect bounds) {
          final double tile = bounds.width * _StatusLine.tileFactor;
          // `background-position: X%` puts the image's X% point on the box's
          // X% point: `offset = (W − tileW) · X`. DsShimmer states the two
          // ends; only the tile factor differs.
          final double eased = DsShimmer.curve.transform(_c.value);
          final double percent = DsShimmer.fromPercent +
              (DsShimmer.toPercent - DsShimmer.fromPercent) * eased;
          final double offset = (bounds.width - tile) * percent;
          final double radians = _StatusLine.angleDegrees * math.pi / 180;
          // CSS gradient angles run clockwise from "to top", so the axis is
          // (sin θ, −cos θ) in a y-down space.
          final Offset axis = Offset(math.sin(radians), -math.cos(radians));
          final Offset centre =
              Offset(offset + tile / 2, bounds.height / 2);
          return ui.Gradient.linear(
            centre - axis * (tile / 2),
            centre + axis * (tile / 2),
            <Color>[theme.mutedForeground, theme.agent, theme.mutedForeground],
            _StatusLine.stops,
            TileMode.repeated,
          );
        },
        child: child,
      ),
      child: label,
    );
  }
}

/* ── §3 · sizes ──────────────────────────────────────────────────────────── */

class _SizesSection extends StatelessWidget {
  const _SizesSection();

  @override
  Widget build(BuildContext context) => const DsSection(
        id: 'sizes',
        title: 'Sizes',
        description:
            'Four scales. The scene sizes itself within the box rather than '
            'being transform-scaled, so strokes stay one pixel at every size.',
        child: DsStateGrid(
          children: <Widget>[
            DsStateCell(
              label: 'sm',
              note: '32px · inline, beside a chip',
              child: DsCubeAvatar(
                state: DsAgentState.thinking,
                size: DsAgentAvatarSize.sm,
              ),
            ),
            DsStateCell(
              label: 'md',
              note: '48px · launcher, console header',
              child: DsCubeAvatar(
                state: DsAgentState.thinking,
                size: DsAgentAvatarSize.md,
              ),
            ),
            DsStateCell(
              label: 'lg',
              note: '80px · welcome card',
              child: DsCubeAvatar(
                state: DsAgentState.thinking,
                size: DsAgentAvatarSize.lg,
              ),
            ),
            DsStateCell(
              label: 'xl',
              note: '128px · empty state, hero',
              child: DsCubeAvatar(
                state: DsAgentState.thinking,
                size: DsAgentAvatarSize.xl,
              ),
            ),
          ],
        ),
      );
}

/* ── §4 · accent ─────────────────────────────────────────────────────────── */

class _AccentSection extends StatelessWidget {
  const _AccentSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'accent',
      title: 'One knob',
      description:
          'The accent is a prop, so one avatar set serves several products. '
          'Any CSS colour works — a token, a hex, a color-mix. This is the '
          'seam that makes the face rebrandable without touching a scene.',
      child: DsStateGrid(
        children: <Widget>[
          const DsStateCell(
            label: 'var(--agent)',
            note: 'the default',
            child: DsCubeAvatar(
              state: DsAgentState.callingTools,
              size: DsAgentAvatarSize.lg,
            ),
          ),
          DsStateCell(
            label: 'var(--color-value)',
            note: 'values, not actions',
            child: DsCubeAvatar(
              state: DsAgentState.callingTools,
              size: DsAgentAvatarSize.lg,
              accent: DsPalette.value,
            ),
          ),
          DsStateCell(
            label: 'var(--color-success)',
            note: 'a different product',
            child: DsCubeAvatar(
              state: DsAgentState.callingTools,
              size: DsAgentAvatarSize.lg,
              accent: DsPalette.success,
            ),
          ),
          DsStateCell(
            label: 'var(--color-info)',
            note: 'a different product',
            child: DsCubeAvatar(
              state: DsAgentState.callingTools,
              size: DsAgentAvatarSize.lg,
              accent: DsPalette.info,
            ),
          ),
        ],
      ),
    );
  }
}

/* ── §5 · orb ────────────────────────────────────────────────────────────── */

class _OrbSection extends StatelessWidget {
  const _OrbSection();

  @override
  Widget build(BuildContext context) {
    return DsSection(
      id: 'orb',
      title: 'Voice orb',
      description:
          'The other face. Where the cube says what the agent is doing, the '
          'orb says that it is listening — it reacts to level rather than to '
          'state, which is why it appears only around the microphone.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const DsPanel(
            label: 'Orb',
            // DRIFT 8 — the one caption in the system naming a renderer.
            note: 'three.js · reads --orb-from and --orb-to',
            child: _OrbWell(),
          ),
          // `className="type-small mt-6"`.
          SizedBox(height: ds(6)),
          const _OrbNote(),
        ],
      ),
    );
  }
}

/// `<div className="flex items-center justify-center py-8">` — 32px of vertical
/// padding inside the Panel's own `p-6`, measured 1030 × 224.
class _OrbWell extends StatelessWidget {
  const _OrbWell();

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: ds(8)),
        child: const Center(
          child: DsVoiceOrb(state: DsOrbState.idle, size: 160),
        ),
      );
}

class _OrbNote extends StatelessWidget {
  const _OrbNote();

  @override
  Widget build(BuildContext context) => DsRichText(
        TextSpan(
          children: <InlineSpan>[
            const TextSpan(
              text: 'A shader cannot resolve a CSS variable, so the wrapper '
                  'reads ',
            ),
            DsCode.span('--orb-from'),
            const TextSpan(text: ' and '),
            DsCode.span('--orb-to'),
            const TextSpan(text: ' through '),
            DsCode.span('getComputedStyle'),
            const TextSpan(
              text: ' — which returns a real colour — and hands that to THREE. '
                  'They are separate tokens from ',
            ),
            DsCode.span('--agent'),
            const TextSpan(
              text: ' so the orb can be tuned without moving the accent every '
                  'icon uses.',
            ),
          ],
        ),
        DsType.small,
      );
}

/* ── §6 · renderer ───────────────────────────────────────────────────────── */

class _RendererSection extends StatelessWidget {
  const _RendererSection();

  @override
  Widget build(BuildContext context) => const DsSection(
        id: 'renderer',
        title: 'The renderer contract',
        description:
            'The console never imports a specific avatar. It takes an '
            'AvatarRenderer and calls it — which is what makes the face '
            'genuinely swappable. A mascot, a video, a Lottie or a photograph '
            'is one module satisfying this type, and nothing in the state '
            'machine, the transcript or the transport moves.',
        // DRIFT 4 — four rows for a five-member type.
        child: DsMeta(
          items: <DsMetaItem>[
            (
              k: 'state',
              v: TextSpan(
                text: 'AgentState — the only required prop. Which of the '
                    'twenty to draw.',
              ),
            ),
            (
              k: 'size?',
              v: TextSpan(
                text: '"sm" | "md" | "lg" | "xl" — a renderer may ignore this',
              ),
            ),
            (
              k: 'accent?',
              v: TextSpan(
                text: 'string — any CSS colour, passed through to '
                    '--agent-cube-accent',
              ),
            ),
            (
              k: 'speed?',
              v: TextSpan(
                text: 'number — multiplier; every duration in the set divides '
                    'by it',
              ),
            ),
          ],
        ),
      );
}

/* ── §7 · reduced motion ─────────────────────────────────────────────────── */

class _ReducedMotionSection extends StatelessWidget {
  const _ReducedMotionSection();

  @override
  Widget build(BuildContext context) => const DsSection(
        id: 'reduced-motion',
        title: 'Reduced motion is handled explicitly',
        description: 'Not inherited, and this is the trap worth knowing about.',
        child: DsNote(
          tone: DsNoteTone.value,
          title: 'Why the blanket rule is not enough',
          child: _ReducedMotionBody(),
        ),
      );
}

/// `<em>end</em>` is the page's one italic run.
const TextStyle _em = TextStyle(fontStyle: FontStyle.italic);

class _ReducedMotionBody extends StatelessWidget {
  const _ReducedMotionBody();

  @override
  Widget build(BuildContext context) => DsRichText(
        TextSpan(
          children: <InlineSpan>[
            const TextSpan(
              text: 'The global reduced-motion rule collapses every animation '
                  'to 0.01ms and one iteration, which for most things is a '
                  'freeze at the final keyframe. But ',
            ),
            DsCode.span('appear'),
            const TextSpan(text: ' and '),
            DsCode.span('drop'),
            const TextSpan(text: ' deliberately '),
            const TextSpan(text: 'end', style: _em),
            const TextSpan(
              text: ' at opacity 0 — cubes arrive one by one and then hard-cut '
                  'back, Game Boy logo style — so the blanket rule would '
                  'freeze half these scenes to nothing at all. The handoff’s '
                  'instruction is to fall back to the static cube layout, so '
                  'that is stated in ',
            ),
            DsCode.span('globals.css'),
            const TextSpan(
              text: ' rather than inherited: no animation, everything visible, '
                  'no transforms.',
            ),
          ],
        ),
        DsType.small,
      );
}
