/// `/design-system/components/base/feedback`: five ways of saying what
/// happened, and sixty-nine of them are moving.
///
/// The simplest page structure in the base group and the busiest render in the
/// corpus. The reference is 520 lines with **no page-local components at all**
///: one module-level const and one default export: because everything hard
/// about it lives in the effects: two bloom drifts and two starfield sways on
/// each of five Alerts, the same four on each of five toast previews,
/// twenty-four shimmers and five spins. **Sixty-nine infinite animations before
/// a toast is fired**, and supervisor ruling F2 builds every one of them:
/// `?motion=reduced` is the only gate, and there is deliberately no
/// out-of-view pause, because the reference has none.
///
/// ## The one structural thing about this page
///
/// **The page-level Note sits outside every section** (`page.tsx` L72–80) —
/// `Note tone="action" className="mb-12"`, between the header and `#alert`, at
/// the full 1080px. No other base page has a callout outside a section, and it
/// is the reason a Note's width is worth watching here: 1080 outside a Panel,
/// **1030 inside one**. §1's Note and §4's second Note are both inside their
/// Panels; every other Note on the page is a sibling.
///
/// ## What is page-local, and why
///
/// [_ToastPreview] and [_ToastPreviewStack] port `components/space/toast-preview.tsx`
///: a **docs-side** component, like `Panel` and `Note`, and the port's docs
/// side is this package. It has exactly one consumer, so it stays here on the
/// B10 precedent. Three things make it a different object from [Toast] rather
/// than a call of it:
///
///  * it renders **the preview's own numbers**, which are measurably not the
///    live toast's: see the divergence note below;
///  * it writes its own `[data-button]`. `toast-preview.tsx` L42–46 spells the
///    `<button>` inline rather than letting sonner render one, so
///    [_ToastActionPill] is that element and not a stand-in for the live pill.
///    The live one now comes from `ToastAction`, which [_ToastSectionState._error]
///    passes and `Toast` paints: the two are the same 32px secondary pill
///    because `.cn-toast [data-button]` styles both, exactly as the preview's
///    own doc-comment claims of the whole object;
///  * it is static. No queue, no lifetime, no dismissal: a `<li>` in a list.
///
/// [_PackCardSkeleton]'s and [_PullRowSkeletons]'s containers are inline
/// `div`s on the reference and stay inline here. [_SeamedList] is the
/// `space-y-px` container `selection.dart` already met: it **cannot** be
/// `DividedList`, which fills with `--card` and draws each seam as a border
/// on the row. This one declares no background at all, so its seams are the
/// panel's `--background` showing through and every row supplies its own fill.
///
/// ## PINNED DIVERGENCE: the preview is not the live toast
///
/// The page states (`page.tsx` L186–190) that the two differ only by the
/// missing `data-sonner-toast` attribute. *Measured, they do not*: drift 4
/// below. The preview is `.cn-toast` **without sonner's stylesheet**, and
/// sonner's stylesheet is injected unlayered at runtime, so on the live toast
/// it adds `[data-icon] { margin-left: -3px; margin-right: 4px }` and a 1.4
/// leading on `[data-description]` that `.cn-toast` never overrides.
///
/// | | live | preview |
/// |---|---|---|
/// | icon left, from the toast edge | 14px | **17px** |
/// | icon → content | 16px | **12px** |
/// | description leading | 18.2 (1.4) | **19.5 (1.5)** |
/// | the error specimen, total | 93.88 | **96.5** |
///
/// **This file renders the right-hand column**, because this file renders the
/// preview. The live toaster the five buttons fire into is `Toaster`, mounted
/// once by the shell, and its choreography is wave B2's.
///
/// ## Drift register: recorded, shipped as written (feedback-map §16)
///
///  1. **Seven chips, five content sections, and they do not correspond.**
///     `contents` promises `Alert · Toast · Skeleton · Progress · Progress
///     tones · Spinner · Empty`. "Progress tones" and "Spinner" are **Panel
///     labels inside `#progress`**, which is itself titled "Progress &
///     Spinner"; `API` and `Rules` get no chip. Rendered as written.
///  2. **PINNED: the warning toast blooms lime under an amber glyph.** A
///     warning *Alert* blooms `--color-warning` over `--color-action`; a
///     warning *toast* still carries `--color-value-bright` over
///     `--color-value-dark`, the pair the Alert was moved off after
///     `alert.tsx` recorded that it *"worked only by accident"*. Both ship as
///     written, [FeedbackSurface.toastWarning] is that pair.
///  3. **Specimen 5 is `variant="info"` wearing an `AlertTriangle`** and
///     warning copy. A cyan triangle over a cyan bloom; every other specimen's
///     glyph matches its variant.
///  4. **The toast preview is not the live toast**: the table above.
///  5. **The `Meta` in "Inline placeholders" has no margin.** `page.tsx` L313
///     writes `<Meta items={…}/>` with no `className`; every other `Meta` in
///     the corpus carries `mt-6`. The list butts straight into the paragraph.
///  6. **The first progress bar has no accessible name.** `page.tsx` L339 is a
///     bare `<Progress value={20.6} />`; the other six all pass an
///     `aria-label`, including the two beside an identical `type-label`. Its
///     readout "412 / 2,000" is a sibling span, unassociated: so
///     [Progress.label] goes unpassed exactly once.
///  7. **[_progressTones]' comment contradicts its contents**: see the
///     comment, transcribed verbatim above the array.
///  8. **`Empty`'s dashed border never paints.** `border-dashed` with no width
///     class; carried by `Empty`.
///  9. **`EmptyMedia` defeats `Icon size="xl"`**: a 16px box drawn with the
///     24px rung's stroke; carried by `EmptyMedia`.
/// 10. **`Spinner`'s `role="status"` and `aria-label="Loading"` are dropped**
///     by `Icon`'s destructure; carried by `Spinner` under ruling B9.
/// 11. **`size-5` / `size-6` spinners keep the 16px stroke.** `Icon` computes
///     `strokeWidth` from the size **prop** and the class overrides only the
///     box, so the 20px and 24px spinners are drawn at 2.4 where the ladder
///     would give 2. The port's `Spinner` takes a box and derives its stroke
///     from it, so it renders those two at the ladder's own 2: the one place
///     on this page where the port is *more* consistent than the reference.
///     Recorded here rather than worked around from the call site: the fix is
///     one `strokeOverride` inside `spinner.dart`, which is not this file.
/// 12. **`Alert` is `role="alert"` with no `aria-live`**: five permanently
///     mounted live regions on one page. `Alert` already sets `liveRegion`.
/// 13. **The live toast carries no role at all** and sonner announces through
///     a separate visually-hidden region; `Toast` labels itself instead: an
///     already-shipped, deliberate divergence.
/// 14. **Two reduced-motion regimes.** `globals.css` collapses durations to
///     0.01ms; sonner's own sheet sets `animation: none`. The port has one
///     switch, `?motion=reduced`, and both regimes land on the resting frame.
/// 15. **The bloom reaches the border but not past it.** `overflow: hidden`
///     clips to the padding box, so the 1px `--border` stroke sits outside the
///     light. Modelled by `Alert` and by [_ToastPreview] here.
/// 16. **`.cn-toast`'s selector is written three times** to beat sonner's
///     unlayered sheet. The port has no cascade; the values are just the
///     values.
/// 17. **`--front-toast-height` is measured, not declared**: sonner reads it
///     off the DOM and pins every collapsed back toast to it. A live-stack
///     fact, and wave B2's.
/// 18. **The section is titled "Progress & Spinner" and its `id` is
///     `progress`.** Anchor and title disagree; the chip list splits them.
library;

import 'dart:async';
import 'dart:math' as math;

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

import '../kit.dart';
import '../nav.dart';
import '../shell.dart';

/* ── Page constants ──────────────────────────────────────────────────────── */

/// `max-w-md`, `--container-md`, 28rem. Both progress panels.
// allow-hardcoded: framework container scale with no token to read it from.
const double _measureMd = 448;

/// `max-w-prose`, Tailwind's `65ch`, which is 65 advances of the `0` glyph in
/// the paragraph's own face and size and therefore not a px token anywhere.
/// Measured at the one site that wears it: a `.type-body` paragraph, 15px
/// Inter.
// allow-hardcoded: a `ch`-relative framework measure; Flutter has no ch unit.
const double _measureProse = 614.136;

/// `--strong`, as Preflight sets it: `b, strong { font-weight: bolder }`, which
/// against the body's 400 resolves to 700. The page-level Note's five component
/// names step up to it.
// allow-hardcoded: Preflight's own `bolder`, resolved; there is no `--` token for it.
const double _bolder = 700;

/// `font-medium`: the weight `[data-title]` and `[data-button]` both declare.
// allow-hardcoded: `font-weight: 500`; the weight ladder has no `--` token.
const double _medium = 500;

/// `new Promise((res) => setTimeout(res, 1800))`: the Promise button's demo.
const Duration _promiseLatency = Duration(
  milliseconds: 1800,
); // allow-hardcoded: the page's own demo latency, a call-site constant and not a --duration-* token

/// `[data-title]` and `[data-button]`, 13px at **1.5**, at 500.
///
/// The leading is `.cn-toast`'s own 1.5, which both slots inherit because
/// neither declares one of their own; the size is `--text-small`. Both are
/// read off [TextStyles.small]: the one spec that already transcribes that pair —
/// so the only number written here is the weight.
///
/// It is deliberately **not** `TextStyles.buttonLabel`, which is the same
/// 13/500 at `text-sm`'s 1.428571. On a five-toast stack that ratio is 8.4px of
/// accumulated shortfall, and it is the whole of drift 4's leading column.
final TextStyleToken _toastMedium = TextStyleToken(
  family: Fonts.sans,
  size: TextStyles.small.size,
  height: TextStyles.small.height,
  wght: _medium,
);

/// The stroke lucide authors its 24px grid with, and the one a glyph rendered
/// **raw** keeps.
///
/// `TOAST_ICONS[type]` is a lucide component, not the Elattar `Icon` wrapper, so the
/// preview's glyphs never meet `icon.tsx`'s ladder: they are `size-4` at
/// lucide's default 2, next to five `<Spinner/>`s of the same glyph at 2.4.
/// Spelled as the ladder's own answer at the grid's own size rather than typed,
/// which is the `theme_toggle.dart` precedent.
final double _lucideStroke = Icon.strokeFor(IconPaths.viewBox);

/* Every tone the bar ships, rendered live rather than described. `default` and
   `value` are shown above in their own context, so this row is the four that
   say something about the reading itself. */
const List<_ToneRow> _progressTones = <_ToneRow>[
  (tone: ProgressTone.normal, label: 'Steps today', value: 72),
  (tone: ProgressTone.success, label: 'Hydration goal met', value: 100),
  (tone: ProgressTone.warning, label: 'Storage used', value: 86),
  (
    tone: ProgressTone.destructive,
    label: 'Sleep against an 8h need',
    value: 67,
  ),
];

/// One row of [_progressTones], `as const`, so the shape is the array's.
typedef _ToneRow = ({ProgressTone tone, String label, double value});

/* ── Page helpers ────────────────────────────────────────────────────────── */

/// [base] at [_bolder], keeping every other variable axis.
///
/// The `wght` entry is replaced in place rather than a bare `fontVariations`
/// override being handed to the span, because that would drop the `opsz` entry
/// `font-optical-sizing: auto` puts there.
TextStyle _strong(TextStyle base) => base.copyWith(
  fontWeight: FontWeight.bold,
  fontVariations: <FontVariation>[
    for (final FontVariation v
        in base.fontVariations ?? const <FontVariation>[])
      if (v.axis != 'wght') v,
    const FontVariation('wght', _bolder),
  ],
);

/// `<em>`: the page has two, both inside a Note.
const TextStyle _em = TextStyle(fontStyle: FontStyle.italic);

/// A block box with a width of its own, at the start of its line.
///
/// The skeleton columns stretch, so their `w-full` placeholders take the
/// measure the way a block element does: and a `w-24` box then has to be told
/// not to. CSS needs no telling: an explicit width on a block box leaves the
/// rest of the line empty, which is what this reproduces.
Widget _atLineStart(Widget child) =>
    Align(alignment: Alignment.centerLeft, child: child);

/// A block box wearing a `max-w-*`.
///
/// CSS caps a block box's width and leaves it at the start of its line. A bare
/// [ConstrainedBox] cannot say that here: handed a **tight** width: which is
/// what every stretched column and every `Padding` inside one passes down: it
/// *enforces* that width and the cap is silently lost, so `max-w-md` renders at
/// the panel's full 982. [Align] is what turns the incoming constraint loose
/// again, and its own start alignment is the rest of the declaration.
Widget _measured(double maxWidth, Widget child) => Align(
  alignment: Alignment.centerLeft,
  child: ConstrainedBox(
    constraints: BoxConstraints(maxWidth: maxWidth),
    child: child,
  ),
);

/* ── Page ────────────────────────────────────────────────────────────────── */

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryHit here = findCategory('base', 'feedback');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        PageHeader(
          // The eyebrow says "Base" twice, on all fourteen base pages: the
          // group is already called "Base Components" and the page interpolates
          // a second literal after a U+00B7 anyway.
          eyebrow: '${here.group.title} · Base',
          title: here.category.title,
          blurb: here.category.blurb,
          // DRIFT 1: seven chips against five content sections.
          contents: here.category.contents,
        ),
        // `className="mb-12"`, 48px. The only Note in the corpus that sits
        // outside every section, and therefore the only one at the full 1080.
        Padding(
          padding: EdgeInsets.only(bottom: space(12)),
          child: const Note(
            title: 'Which one to reach for',
            child: _WhichOneBody(),
          ),
        ),
        const _AlertSection(),
        const _ToastSection(),
        const _SkeletonSection(),
        const _ProgressSection(),
        const _EmptySection(),
        const _ApiSection(),
        const _RulesSection(),
        const PageFootNav(groupId: 'base', slug: 'feedback'),
      ],
    );
  }
}

/// Five `<strong className="text-foreground">` runs stepping up out of the
/// Note's own `--muted-foreground`.
class _WhichOneBody extends StatelessWidget {
  const _WhichOneBody();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final TextStyle base = StyledText.styleOf(context, TextStyles.small);
    final TextStyle strong = _strong(base).copyWith(color: theme.foreground);

    return RichText(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(text: 'Alert', style: strong),
          const TextSpan(text: ' stays on the page and explains a condition. '),
          TextSpan(text: 'Toast', style: strong),
          const TextSpan(
            text:
                ' is transient confirmation of something the user just '
                'did. ',
          ),
          TextSpan(text: 'Skeleton', style: strong),
          const TextSpan(
            text: ' holds the shape of content that is arriving. ',
          ),
          TextSpan(text: 'Progress', style: strong),
          const TextSpan(text: ' shows how far through something is. '),
          TextSpan(text: 'Empty', style: strong),
          const TextSpan(
            text:
                ' is for when there is genuinely nothing, and it always '
                'offers a way forward.',
          ),
        ],
      ),
      TextStyles.small,
    );
  }
}

/* ── §1 · alert ──────────────────────────────────────────────────────────── */

class _AlertSection extends StatelessWidget {
  const _AlertSection();

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'alert',
      title: 'Alert',
      description:
          'Five variants. Stock shadcn only ships default and '
          'destructive, so success, warning and information were added to '
          'cover the states the brief requires.',
      child: Panel(
        label: 'All five variants',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // `div.space-y-4`: five alerts, 16px between them.
            const Alert(
              icon: Icon(
                IconGlyph.info,
                size: IconSize.md,
                tone: IconTone.inherit,
              ),
              title: 'Provably fair',
              description:
                  'Every pack roll is seeded and verifiable. The seed '
                  'for this pack is published after opening.',
            ),
            SizedBox(height: space(4)),
            const Alert(
              variant: AlertVariant.success,
              icon: Icon(
                IconGlyph.circleCheck,
                size: IconSize.md,
                tone: IconTone.inherit,
              ),
              title: 'Deposit cleared',
              description: r'$250.00 was added to your available balance.',
            ),
            SizedBox(height: space(4)),
            Alert(
              variant: AlertVariant.warning,
              icon: const Icon(
                IconGlyph.hourglass,
                size: IconSize.md,
                tone: IconTone.inherit,
              ),
              title: 'Withdrawal under review',
              description:
                  r'Withdrawals over $1,000 are reviewed manually and '
                  'usually clear within one business day.',
              // `<AlertAction><Button variant="secondary" size="sm"/></…>` —
              // a slot, and the button inside it is the page's. Its `onClick`
              // is absent on the reference, so it is live and does nothing;
              // a null handler here would dim it instead.
              action: Button(
                variant: ButtonVariant.secondary,
                size: ButtonSize.sm,
                onPressed: () {},
                child: const Text('Details'),
              ),
            ),
            SizedBox(height: space(4)),
            Alert(
              variant: AlertVariant.destructive,
              icon: const Icon(
                IconGlyph.circleX,
                size: IconSize.md,
                tone: IconTone.inherit,
              ),
              title: 'Payment failed',
              description:
                  'Your card was declined. No packs were opened and '
                  'nothing was charged.',
              action: Button(
                variant: ButtonVariant.secondary,
                size: ButtonSize.sm,
                onPressed: () {},
                child: const Text('Retry'),
              ),
            ),
            SizedBox(height: space(4)),
            // DRIFT 3: the `info` variant wearing an `AlertTriangle`, over
            // warning copy. A cyan triangle on a cyan bloom.
            const Alert(
              variant: AlertVariant.info,
              icon: Icon(
                IconGlyph.alertTriangle,
                size: IconSize.md,
                tone: IconTone.inherit,
              ),
              title: 'Purchase limit approaching',
              description:
                  r'You have used $840 of your $1,000 weekly limit. '
                  'Limits are set in Preferences and exist to help you stay in '
                  'control.',
            ),
            // `className="mt-6"`. This Note is INSIDE the Panel, which is what
            // makes it 1030 wide where the page-level one is 1080.
            SizedBox(height: space(6)),
            const Note(
              title: 'One surface, five meanings',
              child: _OneSurfaceBody(),
            ),
          ],
        ),
      ),
    );
  }
}

class _OneSurfaceBody extends StatelessWidget {
  const _OneSurfaceBody();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final TextStyle base = StyledText.styleOf(context, TextStyles.small);
    final TextStyle strong = _strong(base).copyWith(color: theme.foreground);

    return RichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(
            text:
                'Every variant shares the same background, border and text '
                'colour. Only the ',
          ),
          TextSpan(text: 'icon', style: strong),
          const TextSpan(text: ' and the '),
          TextSpan(text: 'bloom', style: strong),
          const TextSpan(
            text:
                ' behind it change — three declarations. Stock shadcn tints '
                'the whole card and recolours the copy; five tinted cards on '
                'one page read as a traffic light rather than as one '
                'component, and body text is the least legible place to spend '
                'a hue.',
          ),
        ],
      ),
      TextStyles.small,
    );
  }
}

/* ── §2 · toast ──────────────────────────────────────────────────────────── */

/// Stateful for one reason: the Promise button starts a clock that outlives the
/// tap, and a page that leaves it running would leak a pending timer into
/// whatever mounts next.
class _ToastSection extends StatefulWidget {
  const _ToastSection();

  @override
  State<_ToastSection> createState() => _ToastSectionState();
}

class _ToastSectionState extends State<_ToastSection> {
  /// The demo's `setTimeout`, held so the page can take it down with itself.
  Timer? _clock;

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  /// `toast("Added to favourites")`: the untyped call, which is the one the
  /// controller spells as [ToastController.show].
  void _neutral() =>
      docsToasts.show(const ToastMessage(title: 'Added to favourites'));

  /// `toast.success(…, { description })`.
  ///
  /// **No `glyph:` override anywhere on this page.** `TOAST_ICONS` is
  /// [ToastType.glyph]'s table to answer, and a call site that passed the
  /// geometry by hand would be routing around it.
  void _success() => docsToasts.success(
    r'Sold 3 cards for $2,481.00',
    description: 'Credited to your available balance.',
  );

  /// `toast.error(…, { description, action })`.
  ///
  /// The reference's options carry
  /// `action: { label: "Retry", onClick: () => {} }` (`page.tsx` L227), and the
  /// live toast renders it as `[data-button]`. `ToastMessage.action` landed
  /// with wave B2's toaster, so the fired toast now carries the pill itself and
  /// the preview one panel up is no longer the only place it can be looked at.
  ///
  /// No `onPressed`: the reference's handler is an empty arrow, and the
  /// dismissal that follows a press is sonner's own, [ToastAction] runs the
  /// handler and `Toaster` deletes the toast after it, handler or not.
  void _error() => docsToasts.error(
    'Could not reach the vault',
    description: 'Nothing was charged. Try again in a moment.',
    action: const ToastAction(label: 'Retry'),
  );

  /// `toast.warning(…)`.
  void _warning() => docsToasts.warning('Only 12 packs left in this print run');

  /// `toast.promise(new Promise((res) => setTimeout(res, 1800)), {…})`.
  ///
  /// The future is a [Completer]'s rather than a bare `Future.delayed` so the
  /// page owns the clock: `setTimeout` dies with the document, and a page that
  /// left a real timer running would settle a toast into whatever mounted
  /// after it. Disposed mid-flight the completer is simply never completed,
  /// which is what navigating away from the reference does: the loading toast
  /// goes with the page and nothing settles.
  void _firePromise() {
    _clock?.cancel();
    final Completer<void> settled = Completer<void>();
    _clock = Timer(_promiseLatency, () {
      if (!settled.isCompleted) settled.complete();
    });
    docsToasts.promise<void>(
      settled.future,
      loading: 'Requesting withdrawal…',
      success: 'Withdrawal requested',
      error: 'Request failed',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'toast',
      title: 'Toast',
      description:
          'Transient confirmation, bottom-right. Never used for '
          'errors that require a decision — those get an Alert or a Dialog, '
          'because a toast disappears.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Panel(
            label: 'All five, side by side',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const _ToastPreviewStack(
                  children: <Widget>[
                    _ToastPreview(title: 'Added to favourites'),
                    _ToastPreview(
                      type: ToastType.success,
                      title: r'Sold 3 cards for $2,481.00',
                      description: 'Credited to your available balance.',
                    ),
                    _ToastPreview(
                      type: ToastType.error,
                      title: 'Could not reach the vault',
                      description:
                          'Nothing was charged. Try again in a '
                          'moment.',
                      action: 'Retry',
                    ),
                    _ToastPreview(
                      type: ToastType.warning,
                      title: 'Only 12 packs left in this print run',
                    ),
                    _ToastPreview(
                      type: ToastType.loading,
                      title: 'Requesting withdrawal…',
                      description: 'This usually takes a few seconds.',
                    ),
                  ],
                ),
                // `className="mt-6"`.
                SizedBox(height: space(6)),
                const _NotMockUpsBody(),
                // `className="mt-3"`.
                SizedBox(height: space(3)),
                const _BloomIsSharedBody(),
              ],
            ),
          ),
          // `className="mt-4"`.
          SizedBox(height: space(4)),
          Panel(
            label: 'Click to fire a real one',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SpecimenRow(
                  children: <Widget>[
                    Button(
                      variant: ButtonVariant.outline,
                      onPressed: _neutral,
                      child: const Text('Neutral'),
                    ),
                    Button(
                      variant: ButtonVariant.outline,
                      onPressed: _success,
                      child: const Text('Success'),
                    ),
                    Button(
                      variant: ButtonVariant.outline,
                      onPressed: _error,
                      child: const Text('Error'),
                    ),
                    Button(
                      variant: ButtonVariant.outline,
                      onPressed: _warning,
                      child: const Text('Warning'),
                    ),
                    Button(
                      variant: ButtonVariant.outline,
                      onPressed: _firePromise,
                      child: const Text('Promise'),
                    ),
                  ],
                ),
                // `className="mt-5"`.
                SizedBox(height: space(5)),
                const _ConfiguredOnceBody(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// `ul.flex.list-none.flex-col.gap-4`, *"a `<li>` needs a list to be valid."*
///
/// `align-items` defaults to `stretch`, and every child sets `width: 356px`, so
/// the stack is left-aligned rather than full-bleed.
class _ToastPreviewStack extends StatelessWidget {
  const _ToastPreviewStack({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      for (int i = 0; i < children.length; i++) ...<Widget>[
        if (i > 0) SizedBox(height: space(4)),
        children[i],
      ],
    ],
  );
}

/// `components/space/toast-preview.tsx`, *"a toast, rendered where you can look
/// at one."*
///
/// The same tree sonner builds, `[data-icon]`, `[data-content]`,
/// `[data-title]`, `[data-description]`, `[data-button]` inside `.cn-toast` —
/// minus the `data-sonner-toast` attribute that carries the fixed positioning
/// and the enter animation. `.cn-toast` styles both; sonner's own stylesheet
/// styles only the live one, which is the whole of drift 4.
///
/// | declaration | value |
/// |---|---|
/// | `width: var(--width, 22.25rem)` | **356px**, [Toaster.width] |
/// | `display: flex; align-items: flex-start` | icon beside content, both top-aligned |
/// | `gap: calc(--spacing * 3)` | 12px |
/// | `padding: calc(--spacing * 4)` | 16px |
/// | `border-radius: var(--radius-lg)` | 12px |
/// | `background-color: var(--popover)` | the shorthand would reset `background-image` too |
/// | `box-shadow: var(--shadow-e3)` |, |
/// | `font-size: var(--text-small)` + a 1.5 leading | 13 / 19.5 |
/// | `overflow: hidden` | the bloom's clip |
///
/// The bloom is mounted per `data-type`, and it brings the starfield with it —
/// `.feedback-surface [data-content]::before` is a **descendant** selector against
/// an unpositioned `[data-content]`, so the sparkle box resolves against the
/// whole toast. Four infinite animations per preview, twenty across the stack.
class _ToastPreview extends StatelessWidget {
  const _ToastPreview({
    this.type = ToastType.normal,
    required this.title,
    this.description,
    this.action,
  });

  /// `data-type`, `default` renders no glyph at all.
  final ToastType type;

  final String title;
  final String? description;

  /// `[data-button]`'s label, on the one preview that has it.
  final String? action;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final BorderRadius radius = BorderRadius.circular(Radii.lg);
    // `const Icon = type === "default" ? null : TOAST_ICONS[type]`.
    final IconGlyph? glyph = type.glyph;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StyledText(title, _toastMedium, color: theme.foreground),
        if (description != null) ...<Widget>[
          // `[data-content] { gap: calc(--spacing * 1) }`.
          SizedBox(height: space(1)),
          // `[data-description]` sets font-size and colour and **no leading**,
          // so it keeps `.cn-toast`'s 1.5: which is `.type-small` exactly.
          StyledText(description!, TextStyles.small),
        ],
      ],
    );

    if (glyph != null || action != null) {
      content = Row(
        // `align-items: flex-start`.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (glyph != null) ...<Widget>[
            Padding(
              // `[data-icon] { margin-top: calc(--spacing * 0.5) }`.
              padding: EdgeInsets.only(top: space(0.5)),
              child: type == ToastType.loading
                  // `className="size-4 anim-spin"`, `pulls-spin`, 900ms,
                  // linear, forever. Reduced motion holds it at 0°, which is
                  // where a fill-less animation reverts to.
                  ? KeyframePlayer(
                      duration: MotionDurations.spin,
                      fill: KeyframeFill.none,
                      repeat: true,
                      builder:
                          (BuildContext context, double t, Widget? child) =>
                              Transform.rotate(
                                angle: t * 2 * math.pi,
                                child: child,
                              ),
                      child: _previewGlyph(glyph, theme),
                    )
                  : _previewGlyph(glyph, theme),
            ),
            // `gap: calc(--spacing * 3)`.
            SizedBox(width: space(3)),
          ],
          // `[data-content] { min-width: 0 }`: it shrinks, and the pill's
          // `margin-left: auto` takes whatever is left over.
          Expanded(child: content),
          if (action != null) ...<Widget>[
            SizedBox(width: space(3)),
            _ToastActionPill(label: action!),
          ],
        ],
      );
    }

    Widget toast = Padding(
      // `padding: calc(--spacing * 4)`.
      padding: EdgeInsets.all(space(4)),
      child: content,
    );

    toast = _bloomFor(type, radius: radius, fill: theme.popover, child: toast);

    // `box-shadow: var(--shadow-e3)` and `border: 1px solid var(--border)`,
    // outside the bloom's clip because `overflow: hidden` clips to the padding
    // box: so the border stroke sits outside the light (drift 15).
    toast = Surface(
      spec: Shadows.lg,
      radius: radius,
      border: Border.all(color: theme.border, width: BorderWidths.hairline),
      child: toast,
    );

    return SizedBox(width: Toaster.width, child: toast);
  }

  /// `<Icon className="size-4"/>`, raw, 16px at lucide's own stroke, in the
  /// type's `-ink`.
  Widget _previewGlyph(IconGlyph glyph, ThemeTokens theme) => Icon(
    glyph,
    sizePx: space(4),
    strokeOverride: _lucideStroke,
    tone: IconTone.inherit,
  );

  /// `.cn-toast[data-type="…"]`'s `--bloom-1` / `--bloom-2` pair.
  ///
  /// Four of the five agree with the Alert variant of the same name. `warning`
  /// does not, DRIFT 2, and [FeedbackSurface.toastWarning] is the pair the Alert
  /// was moved off.
  static Widget _bloomFor(
    ToastType type, {
    required BorderRadius radius,
    required Color fill,
    required Widget child,
  }) => switch (type) {
    ToastType.success => FeedbackSurface(
      variant: FeedbackVariant.success,
      radius: radius,
      fill: fill,
      child: child,
    ),
    ToastType.info => FeedbackSurface(
      variant: FeedbackVariant.info,
      radius: radius,
      fill: fill,
      child: child,
    ),
    ToastType.warning => FeedbackSurface(
      variant: FeedbackVariant.warning,
      radius: radius,
      fill: fill,
      child: child,
    ),
    ToastType.error => FeedbackSurface(
      variant: FeedbackVariant.error,
      radius: radius,
      fill: fill,
      child: child,
    ),
    ToastType.loading => FeedbackSurface(
      variant: FeedbackVariant.loading,
      radius: radius,
      fill: fill,
      child: child,
    ),
    ToastType.normal => FeedbackSurface(
      variant: FeedbackVariant.neutral,
      radius: radius,
      fill: fill,
      child: child,
    ),
  };
}

/// `[data-button]`, `variant="secondary" size="sm"` written out by hand,
/// because sonner renders the button itself and never sees the cva.
///
/// **The preview's own element**, not the live indicator: `toast-preview.tsx`
/// L42–46 writes `<button type="button" data-button="">` into its own markup,
/// so this is a port of that `<button>`. The live toast's pill is
/// `ToastAction`'s, painted by `Toast`; both are the same 32px secondary
/// pill because the one `.cn-toast [data-button]` block styles both.
///
/// `flex-shrink: 0; margin-left: auto; height: calc(--spacing * 8);
/// padding-inline: calc(--spacing * 3.5); border: 1px solid transparent;
/// border-radius: var(--radius-pill); background: var(--secondary);
/// box-shadow: none; color: var(--secondary-foreground); font-size:
/// var(--text-small); font-weight: 500; transition: background-color
/// var(--duration-base) var(--ease-out)`.
///
/// **Secondary, not outline** (`globals.css` L2790–2795): a bordered
/// transparent control over moving light reads as a hole. The hover goes to
/// `--accent`, and `--duration-base` is read from the variable directly here
/// rather than through a `duration-<word>` utility, so it is genuinely
/// [MotionDurations.normal].
class _ToastActionPill extends StatefulWidget {
  const _ToastActionPill({required this.label});

  final String label;

  /// `height: calc(--spacing * 8)`.
  static double get height => space(8);

  /// `padding-inline: calc(--spacing * 3.5)`.
  static double get paddingX => space(3.5);

  @override
  State<_ToastActionPill> createState() => _ToastActionPillState();
}

class _ToastActionPillState extends State<_ToastActionPill> {
  bool _hovered = false;

  void _hover(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    final Color fill = _hovered ? theme.accent : theme.secondary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _hover(true),
      onExit: (_) => _hover(false),
      child: TweenAnimationBuilder<Color?>(
        tween: ColorTween(end: fill),
        duration: effectiveMotionDuration(context, MotionDurations.normal),
        curve: MotionCurves.enter,
        builder: (BuildContext context, Color? wash, Widget? child) =>
            DecoratedBox(
              decoration: BoxDecoration(
                color: wash ?? fill,
                borderRadius: BorderRadius.circular(Radii.full),
                // `border: 1px solid transparent`: declared, and it still costs
                // the pill its pixel on each side.
                border: Border.all(
                  color: transparent,
                  width: BorderWidths.hairline,
                ),
              ),
              child: child,
            ),
        child: SizedBox(
          height: _ToastActionPill.height,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _ToastActionPill.paddingX - BorderWidths.hairline,
            ),
            child: Center(
              widthFactor: 1,
              child: StyledText(
                widget.label,
                _toastMedium,
                color: theme.secondaryForeground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotMockUpsBody extends StatelessWidget {
  const _NotMockUpsBody();

  @override
  Widget build(BuildContext context) {
    return RichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(
            text:
                'These are not mock-ups. They render the same markup sonner '
                'produces and are styled by the same ',
          ),
          Code.span('.cn-toast'),
          const TextSpan(text: ' block in '),
          Code.span('globals.css'),
          const TextSpan(text: ' — the only difference is the missing '),
          Code.span('data-sonner-toast'),
          const TextSpan(
            text:
                ' attribute that would make them fixed to the corner of the '
                'viewport. Change a value there and both these and the live '
                'toast move together.',
          ),
        ],
      ),
      TextStyles.small,
    );
  }
}

class _BloomIsSharedBody extends StatelessWidget {
  const _BloomIsSharedBody();

  @override
  Widget build(BuildContext context) {
    return RichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(text: 'The bloom is '),
          Code.span('feedback-surface'),
          const TextSpan(
            text:
                ', shared with Alert. Two layers drift at different speeds '
                'and rotate against each other — a deep field over 18s and a '
                'brighter near field over 11s — so they never line up and the '
                'surface reads as two distances rather than one flat wash. '
                'Each type sets two hues and nothing else. It is CSS rather '
                'than a ',
          ),
          Code.span('ShaderSurface'),
          const TextSpan(
            text:
                ' because sonner builds the live toast and offers nowhere to '
                'mount a canvas, and because a 160×72 zone renders at 80×36 — '
                'far too few pixels for a noise field. Same call as the '
                'premium button.',
          ),
        ],
      ),
      TextStyles.small,
    );
  }
}

class _ConfiguredOnceBody extends StatelessWidget {
  const _ConfiguredOnceBody();

  @override
  Widget build(BuildContext context) {
    return RichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(
            text: 'Position and theme are configured once on the ',
          ),
          Code.span('<Toaster />'),
          const TextSpan(
            text: ' in the root layout, so no screen can move them.',
          ),
        ],
      ),
      TextStyles.small,
    );
  }
}

/* ── §3 · skeleton ───────────────────────────────────────────────────────── */

class _SkeletonSection extends StatelessWidget {
  const _SkeletonSection();

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'skeleton',
      title: 'Skeleton',
      description:
          'A skeleton must match the footprint of what it replaces. A '
          'generic grey rectangle where a pack card will appear causes a '
          'layout jump, which is worse than a spinner.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Grid(
            lg: 2,
            children: <Widget>[
              Panel(label: 'Pack card skeleton', child: _PackCardSkeleton()),
              Panel(
                label: 'Live pull row skeleton',
                child: _PullRowSkeletons(),
              ),
            ],
          ),
          SizedBox(height: space(4)),
          Panel(
            label: 'Inline placeholders',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SpecimenRow(
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: _measureProse,
                      ),
                      child: const _InlinePlaceholderBody(),
                    ),
                  ],
                ),
                // DRIFT 5: no `mt-6`, and no gap at all. The list butts
                // straight into the paragraph above it.
                const Meta(
                  items: <MetaItem>[
                    (
                      k: 'Default',
                      v: TextSpan(text: 'div — use for block placeholders'),
                    ),
                    (
                      k: 'as="span"',
                      v: TextSpan(text: 'inline-block, for text placeholders'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: space(4)),
          const Note(
            tone: NoteTone.error,
            title: 'The common mistake',
            child: _CommonMistakeBody(),
          ),
        ],
      ),
    );
  }
}

/// `div.rounded-lg.border.border-border.bg-card.p-4`: seven placeholders in
/// the shape of a pack card. Measured 482 × 348.
class _PackCardSkeleton extends StatelessWidget {
  const _PackCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      child: Padding(
        // `p-4` plus the border it is measured inside: `box-sizing:
        // border-box` pays for the frame out of the box, and [DecoratedBox]
        // paints a border without reserving space for it.
        padding: EdgeInsets.all(space(4) + BorderWidths.hairline),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // `mb-4 h-32 w-full rounded-md`: the art.
            Skeleton(height: space(32)),
            SizedBox(height: space(4)),
            // `h-3 w-24`: the set name.
            _atLineStart(Skeleton(width: space(24), height: space(3))),
            // `mt-2.5 h-4 w-40`: the card name.
            SizedBox(height: space(2.5)),
            _atLineStart(Skeleton(width: space(40), height: space(4))),
            // `mt-4 flex gap-2`: two rarity pills.
            SizedBox(height: space(4)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Skeleton(
                  width: space(20),
                  height: space(5),
                  radius: Radii.full,
                ),
                SizedBox(width: space(2)),
                Skeleton(
                  width: space(16),
                  height: space(5),
                  radius: Radii.full,
                ),
              ],
            ),
            // `mt-4 h-6 w-20`: the price.
            SizedBox(height: space(4)),
            _atLineStart(Skeleton(width: space(20), height: space(6))),
            // `mt-4 h-10 w-full rounded-md`: the buy button.
            SizedBox(height: space(4)),
            Skeleton(height: space(10)),
          ],
        ),
      ),
    );
  }
}

/// Four `flex items-center gap-3 bg-card px-4 py-3` rows inside a
/// [_SeamedList]. Measured 482 × 237: 4 × 58 + 3 seams + the container's own
/// two border pixels.
class _PullRowSkeletons extends StatelessWidget {
  const _PullRowSkeletons();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return _SeamedList(
      children: <Widget>[
        for (int i = 0; i < 4; i++)
          ColoredBox(
            color: theme.card,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: space(4),
                vertical: space(3),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // `size-8 rounded-pill`: the avatar.
                  Skeleton(
                    width: space(8),
                    height: space(8),
                    radius: Radii.full,
                  ),
                  SizedBox(width: space(3)),
                  // `div.min-w-0.flex-1`.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _atLineStart(
                          Skeleton(width: space(20), height: space(3)),
                        ),
                        SizedBox(height: space(2)),
                        _atLineStart(
                          Skeleton(width: space(36), height: space(3.5)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: space(3)),
                  Skeleton(width: space(16), height: space(4)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// `div.space-y-px.overflow-hidden.rounded-lg.border.border-border`.
///
/// **The seams are not a fill.** The container declares no background, so what
/// shows in each `space-y-px` gap is whatever is behind it: the panel's own
/// `--background`. `space-y-px` is a bottom **margin** on every child but the
/// last, not a gap, and the measured height only works out with the container's
/// own two border pixels: 4 × 58 + 3 × 1 + 2 × 1 = 237.
class _SeamedList extends StatelessWidget {
  const _SeamedList({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: theme.border, width: BorderWidths.hairline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(BorderWidths.hairline),
        child: ClipRRect(
          // `overflow-hidden` against the border's inner edge, so the first
          // and last rows take the container's corners.
          borderRadius: BorderRadius.circular(Radii.lg - BorderWidths.hairline),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0; i < children.length; i++) ...<Widget>[
                if (i > 0) const SizedBox(height: BorderWidths.hairline),
                children[i],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The page's one `as="span"` placeholder, inside the sentence explaining why
/// it exists.
class _InlinePlaceholderBody extends StatelessWidget {
  const _InlinePlaceholderBody();

  @override
  Widget build(BuildContext context) {
    return RichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(
            text: 'Standing in for words inside a sentence needs ',
          ),
          Code.span('as="span"'),
          const TextSpan(text: ' — like '),
          // `h-3.5 w-28 align-middle`, `inline-block`, centred on the
          // surrounding lowercase, which is what `vertical-align: middle` is.
          Skeleton.span(width: space(28), height: space(3.5)),
          const TextSpan(text: ' here — because a '),
          Code.span('<div>'),
          const TextSpan(text: ' inside a '),
          Code.span('<p>'),
          const TextSpan(
            text: ' is invalid HTML that every guard in this repo passes.',
          ),
        ],
      ),
      TextStyles.body,
    );
  }
}

class _CommonMistakeBody extends StatelessWidget {
  const _CommonMistakeBody();

  @override
  Widget build(BuildContext context) {
    return RichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(text: 'Do not build one '),
          Code.span('SkeletonCard'),
          const TextSpan(
            text:
                ' and use it everywhere. Each component that loads gets a '
                'skeleton shaped like ',
          ),
          const TextSpan(text: 'itself', style: _em),
          const TextSpan(
            text: '. The shimmer animation is shared; the geometry is not.',
          ),
        ],
      ),
      TextStyles.small,
    );
  }
}

/* ── §4 · progress ───────────────────────────────────────────────────────── */

class _ProgressSection extends StatelessWidget {
  const _ProgressSection();

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Section(
      id: 'progress',
      // DRIFT 18: the title and the `id` disagree, and the chip list splits
      // the two halves into separate entries.
      title: 'Progress & Spinner',
      description:
          'Progress when the total is known — pack supply, XP toward '
          'the next rank, a reveal sequence. Spinner when it is not.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Panel(
            label: 'Progress',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _measured(
                  _measureMd,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // DRIFT 6: the one bar with no `aria-label`.
                      _ProgressReading(
                        label: 'Pack supply remaining',
                        readout: '412 / 2,000',
                        value: 20.6,
                      ),
                      // `space-y-8`, 32px between rows.
                      SizedBox(height: space(8)),
                      _ProgressReading(
                        label: 'XP to Rank 25',
                        readout: '3,480 / 5,000',
                        readoutColor: theme.premiumText,
                        value: 69.6,
                        tone: ProgressTone.value,
                        ariaLabel: 'XP to Rank 25',
                      ),
                      SizedBox(height: space(8)),
                      _ProgressReading(
                        label: 'Revealing cards',
                        readout: '4 of 6',
                        value: 66.7,
                        ariaLabel: 'Revealing cards',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: space(6)),
                StyledText(
                  'The XP bar is the one place a progress track leaves the '
                  'action ramp — progression toward a reward is a value '
                  'signal.',
                  TextStyles.small,
                ),
                SizedBox(height: space(4)),
                // No title, default `action` tone: and inside the Panel.
                const Note(child: _SunkenChannelBody()),
              ],
            ),
          ),
          SizedBox(height: space(4)),
          Panel(
            // U+2014 in the label.
            label: 'Tone — the shape of the reading, not its direction',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _measured(
                  _measureMd,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      for (
                        int i = 0;
                        i < _progressTones.length;
                        i++
                      ) ...<Widget>[
                        if (i > 0) SizedBox(height: space(8)),
                        _ProgressReading(
                          label: _progressTones[i].label,
                          readout: '${_progressTones[i].value.toInt()}%',
                          value: _progressTones[i].value,
                          tone: _progressTones[i].tone,
                          ariaLabel: _progressTones[i].label,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: space(6)),
                const _InkEndBody(),
                SizedBox(height: space(4)),
                const Note(tone: NoteTone.error, child: _SafeBandBody()),
              ],
            ),
          ),
          SizedBox(height: space(4)),
          Panel(
            label: 'Spinner',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SpecimenRow(
                  children: <Widget>[
                    const Spinner(),
                    // `className="size-5"` / `"size-6"`: the class beats the
                    // attribute and only the box changes (drift 11).
                    Spinner(size: space(5)),
                    DefaultTextStyle.merge(
                      style: TextStyle(color: theme.actionText),
                      child: Spinner(size: space(6)),
                    ),
                    const Button(loading: true, child: Text('Opening pack')),
                    const Button(
                      variant: ButtonVariant.premium,
                      loading: true,
                      child: Text('Processing deposit'),
                    ),
                  ],
                ),
                SizedBox(height: space(5)),
                const _LoadingPropBody(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One reading: `div.mb-2.5.flex.items-baseline.justify-between` over the bar.
class _ProgressReading extends StatelessWidget {
  const _ProgressReading({
    required this.label,
    required this.readout,
    required this.value,
    this.readoutColor,
    this.tone = ProgressTone.normal,
    this.ariaLabel,
  });

  /// `span.type-label`.
  final String label;

  /// `span.type-num-sm`: the real figures, which RULES asks every bar to
  /// carry.
  final String readout;

  final double value;

  /// `text-value-ink` on the XP row; `--muted-foreground` on the other six.
  final Color? readoutColor;

  final ProgressTone tone;

  /// `aria-label`, absent exactly once: drift 6.
  final String? ariaLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            StyledText(label, TextStyles.eyebrow),
            StyledText(
              readout,
              TextStyles.numberSm,
              color: readoutColor ?? theme.mutedForeground,
            ),
          ],
        ),
        // `mb-2.5`, 10px.
        SizedBox(height: space(2.5)),
        Progress(value: value, tone: tone, label: ariaLabel),
      ],
    );
  }
}

class _SunkenChannelBody extends StatelessWidget {
  const _SunkenChannelBody();

  @override
  Widget build(BuildContext context) {
    return StyledText(
      // `&rsquo;`: a real right single quotation mark.
      'Same 10px sunken channel as the Slider’s track, because it is the same '
      'object — a filled channel. The only difference is the missing thumb, '
      'because you cannot grab this one. Stock shadcn ships a 4px hair, which '
      'reads as a different component entirely next to a price filter.',
      TextStyles.small,
    );
  }
}

class _InkEndBody extends StatelessWidget {
  const _InkEndBody();

  @override
  Widget build(BuildContext context) {
    return RichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(text: 'Every fill names the '),
          Code.span('-ink'),
          const TextSpan(
            text:
                ' end of its ramp rather than the raw token, for the reason '
                'a glyph does: a filled channel carries no foreground, so the '
                'only thing that makes it visible is its contrast with the '
                'track. Measured on this page, ',
          ),
          Code.span('--primary'),
          const TextSpan(text: ' is 1.63:1 against '),
          Code.span('--muted'),
          const TextSpan(text: ' and '),
          Code.span('--action-ink'),
          const TextSpan(text: ' is 6.97:1; on light, raw '),
          Code.span('--color-success'),
          const TextSpan(text: ' is 1.73:1 and '),
          Code.span('--success-ink'),
          const TextSpan(text: ' is 4.93:1.'),
        ],
      ),
      TextStyles.small,
    );
  }
}

class _SafeBandBody extends StatelessWidget {
  const _SafeBandBody();

  @override
  Widget build(BuildContext context) {
    return RichText(
      TextSpan(
        children: <InlineSpan>[
          Code.span('destructive'),
          const TextSpan(text: ' is for a reading '),
          const TextSpan(text: 'outside its safe band', style: _em),
          const TextSpan(
            text:
                ', never for one that merely fell. A figure moving the wrong '
                'way is news, not a fault — RULES §1.4 — and it stays on the '
                'default tone.',
          ),
        ],
      ),
      TextStyles.small,
    );
  }
}

class _LoadingPropBody extends StatelessWidget {
  const _LoadingPropBody();

  @override
  Widget build(BuildContext context) {
    return RichText(
      TextSpan(
        children: <InlineSpan>[
          const TextSpan(text: 'Inside a button, use the '),
          Code.span('loading'),
          const TextSpan(
            text: ' prop rather than placing a spinner by hand — it also sets ',
          ),
          Code.span('aria-busy'),
          const TextSpan(text: ' and disables the control.'),
        ],
      ),
      TextStyles.small,
    );
  }
}

/* ── §5 · empty ──────────────────────────────────────────────────────────── */

class _EmptySection extends StatelessWidget {
  const _EmptySection();

  @override
  Widget build(BuildContext context) {
    return Section(
      id: 'empty',
      title: 'Empty states',
      // Straight single quotes around 'No results', here and in §7's fourth
      // don't.
      description:
          "An empty state must explain why it is empty and give one "
          "clear way out. A blank panel with 'No results' is an unfinished "
          'screen.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Grid(
            lg: 2,
            children: <Widget>[
              Panel(
                // U+2014 in both labels.
                label: 'Empty Stash — first-time user',
                child: Empty(
                  children: <Widget>[
                    const EmptyHeader(
                      children: <Widget>[
                        EmptyMedia(
                          glyph: IconGlyph.packageOpen,
                          tone: IconTone.action,
                        ),
                        EmptyTitle('Your Stash is empty'),
                        EmptyDescription(
                          'Cards land here the moment a pack finishes '
                          'opening. Open your first pack to start a '
                          'collection.',
                        ),
                      ],
                    ),
                    EmptyContent(
                      children: <Widget>[
                        Button(
                          onPressed: () {},
                          child: const Text('Browse Packs'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Panel(
                label: 'No search results — filters too narrow',
                child: Empty(
                  children: <Widget>[
                    const EmptyHeader(
                      children: <Widget>[
                        EmptyMedia(
                          glyph: IconGlyph.search,
                          tone: IconTone.subtle,
                        ),
                        EmptyTitle('No packs match those filters'),
                        EmptyDescription(
                          r'Nothing between $0 and $10 has a legendary floor. '
                          'Widening the price range will help.',
                        ),
                      ],
                    ),
                    EmptyContent(
                      children: <Widget>[
                        Button(
                          variant: ButtonVariant.outline,
                          onPressed: () {},
                          child: const Text('Reset filters'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: space(4)),
          StyledText(
            'Note the difference: the first is empty because the user is new, '
            'the second because their filters are too narrow. Same component, '
            'completely different copy and action. Brand-specific empty states '
            'belong to the product that needs them, not to the chassis.',
            TextStyles.small,
          ),
        ],
      ),
    );
  }
}

/* ── §6 · api ────────────────────────────────────────────────────────────── */

class _ApiSection extends StatelessWidget {
  const _ApiSection();

  @override
  Widget build(BuildContext context) {
    return const Section(
      id: 'api',
      title: 'API',
      child: Meta(
        items: <MetaItem>[
          (
            k: 'Alert variant',
            v: TextSpan(
              // U+00B7 between the five names.
              text:
                  'default · destructive · success · warning · info. The '
                  'last three were added for this product.',
            ),
          ),
          (
            k: 'AlertAction',
            v: TextSpan(
              text:
                  'Absolutely positioned top-right slot for a single small '
                  'action.',
            ),
          ),
          (
            k: 'toast()',
            v: TextSpan(
              text:
                  'toast, toast.success, toast.error, toast.warning, '
                  'toast.promise. Options: description, action.',
            ),
          ),
          (
            k: 'Skeleton',
            v: TextSpan(
              text:
                  "Size it with Tailwind classes to match the real "
                  "content's geometry.",
            ),
          ),
          (
            k: 'Progress value',
            v: TextSpan(
              // U+2013 in the range.
              text:
                  '0–100. Always pair with a readout showing the underlying '
                  'figures.',
            ),
          ),
          (
            k: 'Empty',
            v: TextSpan(
              text:
                  'Empty + EmptyHeader + EmptyMedia + EmptyTitle + '
                  'EmptyDescription + EmptyContent.',
            ),
          ),
        ],
      ),
    );
  }
}

/* ── §7 · rules ──────────────────────────────────────────────────────────── */

class _RulesSection extends StatelessWidget {
  const _RulesSection();

  @override
  Widget build(BuildContext context) {
    return const Section(
      id: 'rules',
      title: 'Rules',
      // Five and five. Every apostrophe inside an item is straight; only the
      // panel heading's own "Don’t" carries U+2019, and that is `DoDont`'s.
      child: DoDont(
        dos: <String>[
          'Shape every skeleton like the component it stands in for.',
          "Pair a progress bar with the real numbers — '412 / 2,000', not just "
              'a bar.',
          'Give every empty state a reason and exactly one primary way '
              'forward.',
          'Use an Alert, not a toast, for anything the user must act on.',
          "Use the button's loading prop instead of hand-placing a spinner.",
        ],
        donts: <String>[
          "Don't put a decision inside a toast — it vanishes.",
          "Don't reuse one generic skeleton block for every layout.",
          "Don't show a spinner when you know the total; use progress.",
          "Don't write 'No results' with nothing else on screen.",
          "Don't stack more than one alert at the top of a page.",
        ],
      ),
    );
  }
}
