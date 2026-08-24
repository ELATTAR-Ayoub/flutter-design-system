/// `/design-system/components/agent/history`: every conversation, as cards
/// you can pin, rename, share and delete.
///
/// **The fidelity bar is that every card is live.** The page's own lead Note
/// says so: *"Rename them, pin them, delete them. Nothing resets between
/// sections because each specimen owns its own state: which also means you can
/// break one and see what that looks like."* A reader can rename a title inline
/// and watch the row not move, delete one and watch the confirm slide in from
/// the trailing edge and fade out where it stands, pin a row and watch the list
/// reorder, open the palette and type `odds`, and open the drawer inside the
/// console. Nine specimens, none of them a still.
///
/// ## The clock is load-bearing
///
/// Every timestamp on this page is relative, *"14 minutes ago"*, *"yesterday"*,
/// *"last week"*: so the rendered strings are a function of when the store was
/// seeded. `useMockConversations` pins "now" to mount through `useState`'s
/// initialiser; the port pins it to [ElClock.nowOf], which is the `?clock=`
/// seam the parity rig freezes both renderers on.
///
/// ## Drift register: recorded, shipped as written
///
///  1. **The eyebrow says "Components" after a group already called "Agent
///     Components"**, `` `${group.title} · Components` ``. The agent family's
///     version of the base pages' doubled eyebrow.
///  2. **`ItemDescription`'s `type-caption` never applies.** The card passes
///     `className="type-caption"` and `item.tsx` writes `text-sm
///     leading-normal`: utilities beat an `@layer components` class, so the
///     timestamp line renders **13px/19.5px**, not 10.5/14.175 *(measured)*.
///     Every other `.type-caption` on the page does apply, which is what makes
///     this one visible: the strip above the list is genuinely 10.5px.
///  3. **The FLIP never paints.** `useFlip` measures, inverts and releases
///     correctly, and `anim-row-in`'s `animation-fill-mode: both` outranks the
///     inline transform it writes. Pinning teleports the row and replays the
///     entrance on the one neighbour React re-places. Carried by
///     `agent_history.dart`, whose library note has the trace.
///  4. **`anim-row-in` is built to stagger and never does.** Its delay is
///     `calc(--duration-tick + var(--row-index, 0) * --duration-tick / 2)` and
///     no specimen on this page sets `--row-index`, so all seven rows animate
///     together at a flat 80ms *(measured)*.
///  5. **§1's list is one flat group with no headings**, while the drawer the
///     section is labelled `ChatHistory` for splits Pinned from Recents. The
///     Panel's own label names a component the specimen is not.
///  6. **The specimen list and the drawer disagree about what `onOpen` does.**
///     `HistoryListDemo` passes `switchTo`, so a click blurs; `ChatHistory`
///     passes `openConversation`, which also closes the drawer. Same card, two
///     contracts, and the page documents only the first.
///  7. **The inline confirm's copy is "Delete this?"** while the AlertDialog
///     beside it asks *"Delete this conversation?"*. The card's own source says
///     the long form *"pushed them off the end of the card"*: so the two
///     shapes ask different questions, and §3's prose treats them as the same
///     decision at two sizes.
///  8. **The rename dialog's Save is disabled on an empty draft; the inline
///     rename simply discards one.** `commit` drops a blank either way, so the
///     dialog surfaces a rule the inline form enforces silently.
///  9. **The AlertDialog's description interpolates the title into a
///     `text-foreground` span**, `<span>{title}</span> and everything in it
///     will be removed.`: which the port renders as one string, because
///     [ElAlertDialogDescription] takes text. Recorded; the words are the same.
/// 10. **§6's Note calls `shouldFilter` off "which is also why"**, attributing
///     the flag to the preview matching. The flag is off because cmdk would
///     re-score by the row's rendered text; the preview matching is what would
///     be lost. Cause and consequence are the right way round in the component
///     and inverted in the prose.
library;

import 'dart:ui' as ui;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../agent/mock_transport.dart';
import '../kit.dart';
import '../nav.dart';

/* ═══════════════════════════════════════════════════════════════════════════
   The page
   ═══════════════════════════════════════════════════════════════════════════ */

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ElCategoryHit here = findCategory('agent', 'history');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElPageHeader(
          // DRIFT 1.
          eyebrow: '${here.group.title} · Components',
          title: here.category.title,
          blurb: here.category.blurb,
          contents: here.category.contents,
        ),
        // `className="mb-12"`, 48px.
        Padding(
          padding: EdgeInsets.only(bottom: el(12)),
          child: ElNote(
            title: 'Every card below is live',
            child: ElText(
              'Rename them, pin them, delete them. Nothing resets between '
              'sections because each specimen owns its own state: which also '
              'means you can break one and see what that looks like.',
              ElType.small,
            ),
          ),
        ),
        const _ListSection(),
        const _RenameSection(),
        const _DeleteSection(),
        const _PinSection(),
        const _CapabilitiesSection(),
        const _SearchSection(),
        const _SwitchSection(),
        const ElPageFootNav(groupId: 'agent', slug: 'history'),
      ],
    );
  }
}

/* ═══════════════════════════════════════════════════════════════════════════
   §1 · The list
   ═══════════════════════════════════════════════════════════════════════════ */

class _ListSection extends StatelessWidget {
  const _ListSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'list',
    title: 'The list',
    description:
        'Pinned conversations sit above the rest; everything else is '
        'newest first. Sorting happens in the list rather than in the '
        'store, because a store\'s natural order is whatever its query '
        'returned and every store would otherwise reimplement the same '
        'two-key sort.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // DRIFT 5: the label names `ChatHistory`; the specimen is the
        // flat list, without the drawer's own two headings.
        const ElPanel(
          label: 'ChatHistory',
          note: 'live · pin, rename, delete, switch',
          child: HistoryListDemo(),
        ),
        SizedBox(height: el(6)),
        ElRichText(
          TextSpan(
            children: <InlineSpan>[
              const TextSpan(
                text:
                    'The panel above the list shows which conversation '
                    'is open. Click a title and watch it: the transcript '
                    'does not cut, it blurs out, swaps, and blurs back '
                    'in. See ',
              ),
              ElCode.span('useBlurSwitch'),
              const TextSpan(text: ' below.'),
            ],
          ),
          ElType.small,
        ),
      ],
    ),
  );
}

/// `HistoryListDemo`: the list, live, with every capability the store offers.
class HistoryListDemo extends StatefulWidget {
  const HistoryListDemo({super.key, this.capabilities = true});

  /// Drops `pin` and `share` from the store, to show the degraded list.
  final bool capabilities;

  /// `flex flex-col gap-3`: the strip over the group.
  static double get gap => el(3);

  @override
  State<HistoryListDemo> createState() => _HistoryListDemoState();
}

class _HistoryListDemoState extends State<HistoryListDemo> {
  MockConversationStore? _store;
  late final ElBlurSwitchController _switch = ElBlurSwitchController(
    open: (String id) => _store!.open(id),
  );
  final ElFlipController _flip = ElFlipController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _store ??= MockConversationStore(
      now: ElClock.nowOf(context),
      capabilities: widget.capabilities,
    );
  }

  @override
  void dispose() {
    _switch.dispose();
    _flip.dispose();
    _store?.dispose();
    super.dispose();
  }

  void Function(String, bool)? get _pin {
    final void Function(String, bool)? pin = _store!.pin;
    if (pin == null) return null;
    return (String id, bool pinned) {
      _flip.measure();
      pin(id, pinned);
    };
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ListenableBuilder(
      listenable: Listenable.merge(<Listenable>[_store!, _switch]),
      builder: (BuildContext context, Widget? _) {
        final MockConversationStore store = _store!;

        /* Same two-key order the drawer uses: pinned first, then newest.
           Without it this specimen would show a pin that changes an icon and
           nothing else, which is not what pinning does. */
        final List<ElConversationSummary> ordered =
            List<ElConversationSummary>.of(store.conversations)
              ..sort((ElConversationSummary a, ElConversationSummary b) {
                if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
                return b.updatedAt.compareTo(a.updatedAt);
              });
        _flip.reconcile(<String>[
          for (final ElConversationSummary c in ordered) c.id,
        ]);

        final String? activeTitle = store.activeId == null
            ? null
            : ordered
                  .where((ElConversationSummary c) => c.id == store.activeId)
                  .map((ElConversationSummary c) => c.title)
                  .followedBy(const <String>['—'])
                  .first;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElBlurSwitch(
              phase: _switch.phase,
              child: Container(
                padding: EdgeInsets.all(el(3)),
                decoration: BoxDecoration(
                  color: theme.background,
                  borderRadius: BorderRadius.circular(ElRadii.lg),
                  border: Border.all(
                    color: theme.border,
                    width: ElWidths.hairline,
                  ),
                ),
                child: ElText(
                  activeTitle == null
                      ? 'New conversation'
                      : 'Open: $activeTitle',
                  ElType.caption,
                  color: theme.mutedForeground,
                ),
              ),
            ),
            SizedBox(height: HistoryListDemo.gap),
            ElItemGroup(
              gapOverride: el(1),
              children: <Widget>[
                for (final ElConversationSummary c in ordered)
                  ElHistoryCard(
                    key: _flip.keyFor(c.id),
                    conversation: c,
                    active: c.id == store.activeId,
                    entranceGeneration: _flip.generationOf(c.id),
                    onOpen: _switch.switchTo,
                    onRename: store.rename,
                    onRemove: store.remove,
                    onPin: _pin,
                    onShare: store.share,
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/* ═══════════════════════════════════════════════════════════════════════════
   §2 · Renaming moves nothing
   ═══════════════════════════════════════════════════════════════════════════ */

class _RenameSection extends StatelessWidget {
  const _RenameSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'rename',
    title: 'Renaming moves nothing',
    description:
        'The icon, the timestamp, the preview and the card\'s own box all '
        'hold their exact positions. Only the title swaps for an input of '
        'the same height on the same baseline.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ElGrid(
          base: 1,
          md: 2,
          children: <Widget>[
            ElPanel(
              label: 'rename=inline',
              note: 'the default',
              child: HistoryCardSpecimen(rename: ElHistoryRename.inline),
            ),
            ElPanel(
              label: 'rename=dialog',
              note: 'menu → Rename',
              child: HistoryCardSpecimen(rename: ElHistoryRename.dialog),
            ),
          ],
        ),
        SizedBox(height: el(6)),
        ElNote(
          tone: ElNoteTone.value,
          title: 'Why two',
          child: ElText(
            'Inline is faster and keeps the list you are renaming inside '
            'of on screen, Enter commits, Escape abandons, blur commits, '
            'which is what every inline rename already does and therefore '
            'needs no instructions. The dialog earns its ceremony when '
            'titles are long enough that a row-width input is cramped, or '
            'when renaming is rare enough that being able to find it beats '
            'being able to do it quickly. Both ship; pick per surface '
            'rather than inheriting one.',
            ElType.small,
          ),
        ),
      ],
    ),
  );
}

/// `HistoryCardSpecimen`: one card, with the destructive and rename shapes
/// selectable.
class HistoryCardSpecimen extends StatefulWidget {
  const HistoryCardSpecimen({
    super.key,
    this.confirm = ElHistoryConfirm.inline,
    this.rename = ElHistoryRename.inline,
    this.pinned = false,
    this.active = false,
  });

  final ElHistoryConfirm confirm;
  final ElHistoryRename rename;
  final bool pinned;
  final bool active;

  /// The specimen's own timestamp, `Date.now() - 14 * 60_000`.
  static const Duration age = Duration(minutes: 14);

  @override
  State<HistoryCardSpecimen> createState() => _HistoryCardSpecimenState();
}

class _HistoryCardSpecimenState extends State<HistoryCardSpecimen> {
  String _title = 'Sealed inventory check';
  late bool _pinned = widget.pinned;
  bool _gone = false;

  /// Pinned at mount rather than read during render. `relativeTime` needs a
  /// real timestamp, and reading the clock in the render body is impure: it
  /// would also re-derive on every keystroke of a rename.
  DateTime? _updatedAt;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updatedAt ??= ElClock.nowOf(context).subtract(HistoryCardSpecimen.age);
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);

    if (_gone) {
      return Container(
        padding: EdgeInsets.all(el(3)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ElRadii.lg),
          border: Border.all(
            color: theme.border,
            width: ElWidths.hairline,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        foregroundDecoration: _DashedRing(theme.border),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElText(
                'Deleted.',
                ElType.caption,
                color: theme.mutedForeground,
              ),
            ),
            SizedBox(width: el(3)),
            ElButton(
              size: ElButtonSize.sm,
              variant: ElButtonVariant.outline,
              onPressed: () => setState(() => _gone = false),
              child: const Text('Put it back'),
            ),
          ],
        ),
      );
    }

    return ElHistoryCard(
      conversation: ElConversationSummary(
        id: 'spec-card',
        title: _title,
        updatedAt: _updatedAt!,
        preview: 'What sealed boxes are left, and what is the best one?',
        pinned: _pinned,
      ),
      active: widget.active,
      confirm: widget.confirm,
      rename: widget.rename,
      onOpen: (_) {},
      onRename: (_, String next) => setState(() => _title = next),
      onRemove: (_) => setState(() => _gone = true),
      onPin: (_, bool next) => setState(() => _pinned = next),
      onShare: (_) {},
    );
  }
}

/// `border-dashed`: the one dashed border in the corpus, and the reason this
/// is a `foregroundDecoration` rather than a `BoxDecoration.border`: Flutter's
/// [Border] paints solid only.
class _DashedRing extends Decoration {
  const _DashedRing(this.color);

  final Color color;

  /// Tailwind's `border-dashed` is `border-style: dashed`, which Chrome draws
  /// as a 3 : 3 dash at a 1px width.
  // allow-hardcoded: the UA's dash geometry, not a spacing token.
  static const double dash = 3;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _DashedRingPainter(color);
}

class _DashedRingPainter extends BoxPainter {
  _DashedRingPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Size size = configuration.size ?? Size.zero;
    final RRect rect = RRect.fromRectAndRadius(
      (offset & size).deflate(ElWidths.hairline / 2),
      const Radius.circular(ElRadii.lg),
    );
    final Path path = Path()..addRRect(rect);
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ElWidths.hairline
      ..color = color;
    for (final ui.PathMetric metric in path.computeMetrics()) {
      double at = 0;
      while (at < metric.length) {
        canvas.drawPath(metric.extractPath(at, at + _DashedRing.dash), paint);
        at += _DashedRing.dash * 2;
      }
    }
  }
}

/* ═══════════════════════════════════════════════════════════════════════════
   §3 · Two ways to ask before deleting
   ═══════════════════════════════════════════════════════════════════════════ */

class _DeleteSection extends StatelessWidget {
  const _DeleteSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'delete',
    title: 'Two ways to ask before deleting',
    description:
        'Both are destructive confirmations. They differ in how much of '
        'the screen they take, and that difference should be a decision.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ElGrid(
          base: 1,
          md: 2,
          children: <Widget>[
            ElPanel(
              label: 'confirm=inline',
              note: 'slides in from the trailing edge',
              child: HistoryCardSpecimen(confirm: ElHistoryConfirm.inline),
            ),
            ElPanel(
              label: 'confirm=dialog',
              note: 'the system AlertDialog',
              child: HistoryCardSpecimen(confirm: ElHistoryConfirm.dialog),
            ),
          ],
        ),
        SizedBox(height: el(6)),
        ElNote(
          title: 'The inline confirm lands on top, not beside',
          child: ElRichText(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(
                  text:
                      'It covers the whole card rather than appearing '
                      'next to the delete button. That is the point: a '
                      'confirmation sitting beside the control it confirms '
                      'can be dismissed by muscle memory before it has '
                      'been read. Occupying the same space takes the '
                      'delete button physically out of reach and makes the '
                      'question unavoidable. It arrives on ',
                ),
                ElCode.span('anim-confirm-in'),
                const TextSpan(
                  text:
                      ' and leaves on a plain fade, because retracing '
                      'the slide on the way out drags attention away from '
                      'the row you are meant to be looking at again.',
                ),
              ],
            ),
            ElType.small,
          ),
        ),
        SizedBox(height: el(6)),
        const ElDoDont(
          dos: <String>[
            'Collapse the row as it leaves, so the rows below rise into '
                'the gap in one movement.',
            'Keep the confirmation inside the row for something '
                'recoverable and cheap.',
            'Reach for the system AlertDialog when deletion is genuinely '
                'costly: it takes the whole screen, which is the point.',
          ],
          donts: <String>[
            'Fade a row out and then let the list snap shut. Two motions '
                'read as a bug.',
            'Put a bare destructive icon with no confirmation on anything '
                'you cannot undo.',
            'Use a full modal for something the user will do twenty times '
                'in a session.',
          ],
        ),
      ],
    ),
  );
}

/* ═══════════════════════════════════════════════════════════════════════════
   §4 · Pinning
   ═══════════════════════════════════════════════════════════════════════════ */

class _PinSection extends StatelessWidget {
  const _PinSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'pin',
    title: 'Pinning',
    description:
        'A pinned card holds its pin visible; an unpinned one reveals it '
        'on hover, so a long list is not a wall of grey icons. Pinned '
        'conversations lift to their own section above the rest.',
    child: ElGrid(
      base: 1,
      md: 2,
      children: <Widget>[
        ElPanel(
          label: 'pinned',
          note: 'pin stays lit',
          child: HistoryCardSpecimen(pinned: true),
        ),
        ElPanel(
          label: 'unpinned · active',
          note: 'pin appears on hover',
          child: HistoryCardSpecimen(active: true),
        ),
      ],
    ),
  );
}

/* ═══════════════════════════════════════════════════════════════════════════
   §5 · Capabilities come from the store
   ═══════════════════════════════════════════════════════════════════════════ */

class _CapabilitiesSection extends StatelessWidget {
  const _CapabilitiesSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'capabilities',
    title: 'Capabilities come from the store',
    description:
        'Not from props. The pin button exists because store.pin exists; '
        'the share item exists because store.share does. A control that '
        'cannot do anything should never be drawn.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ElPanel(
          label: 'a store with no pin and no share',
          note: 'the same list, degraded',
          child: HistoryListDemo(capabilities: false),
        ),
        SizedBox(height: el(6)),
        ElText(
          'Nothing about the list special-cases this. The affordances are '
          'absent because the functions are, which means a store backed by '
          'something that cannot persist a pin never has to pretend it '
          'can: and nobody has to keep a second list of feature flags in '
          'sync with the first.',
          ElType.small,
        ),
      ],
    ),
  );
}

/* ═══════════════════════════════════════════════════════════════════════════
   §6 · Search
   ═══════════════════════════════════════════════════════════════════════════ */

class _SearchSection extends StatelessWidget {
  const _SearchSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'search',
    title: 'Search',
    description:
        'A palette rather than a filter box, because the list lives inside '
        'a console inside a dialog: roughly forty characters wide: and '
        'the thing being searched for is a sentence.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ElPanel(
          label: 'HistorySearch',
          note: 'recent chats by default',
          child: HistorySearchDemo(),
        ),
        SizedBox(height: el(6)),
        ElNote(
          tone: ElNoteTone.value,
          title: 'Recent chats are the empty state',
          child: ElRichText(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(
                  text:
                      'Opening a search box onto nothing is a dead end: '
                      'it asks a question before you have one. Opening it '
                      'onto what you were last working on means the most '
                      'likely destination is already on screen, and search '
                      'is only needed for the rest. Matching runs over the '
                      'title ',
                ),
                const TextSpan(
                  text: 'and the preview',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                const TextSpan(
                  text:
                      ', because what people remember about a '
                      'conversation is usually what they asked, not what '
                      'it got named afterwards: which is also why ',
                ),
                ElCode.span('shouldFilter'),
                const TextSpan(
                  text:
                      ' is off, or cmdk would re-filter by title and '
                      'drop exactly those matches.',
                ),
              ],
            ),
            ElType.small,
          ),
        ),
      ],
    ),
  );
}

/// `HistorySearchDemo`: the palette, opened from a button.
class HistorySearchDemo extends StatefulWidget {
  const HistorySearchDemo({super.key});

  @override
  State<HistorySearchDemo> createState() => _HistorySearchDemoState();
}

class _HistorySearchDemoState extends State<HistorySearchDemo> {
  MockConversationStore? _store;
  bool _open = false;
  String _query = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _store ??= MockConversationStore(now: ElClock.nowOf(context));
  }

  @override
  void dispose() {
    _store?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElButton(
            variant: ElButtonVariant.outline,
            onPressed: () => setState(() => _open = true),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ElIcon.lucide(ElLucide.search, size: ElIconSize.sm),
                SizedBox(width: ElButton.gapFor(ElButtonSize.md)),
                const Text('Search conversations'),
              ],
            ),
          ),
          SizedBox(height: el(3)),
          ElRichText(
            const TextSpan(
              children: <InlineSpan>[
                TextSpan(text: 'Opens on recent chats. Try '),
                TextSpan(
                  text: 'odds',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(text: ', '),
                TextSpan(
                  text: 'export',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(text: ' or '),
                TextSpan(
                  text: 'balance',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(
                  text: ': it matches the preview text as well as the title.',
                ),
              ],
            ),
            ElType.caption,
            color: theme.mutedForeground,
          ),
          ElHistorySearch(
            conversations: _store!.conversations,
            open: _open,
            onOpenChange: (bool v) => setState(() => _open = v),
            onOpen: _store!.open,
            query: _query,
            onQueryChange: (String v) => setState(() => _query = v),
          ),
        ],
      ),
    );
  }
}

/* ═══════════════════════════════════════════════════════════════════════════
   §7 · Switching conversations
   ═══════════════════════════════════════════════════════════════════════════ */

class _SwitchSection extends StatelessWidget {
  const _SwitchSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'switch',
    title: 'Switching conversations',
    description:
        'The transcript defocuses, swaps, and refocuses. Blur rather than '
        'fade: a fade to nothing reads as loading: the surface leaves and '
        'something arrives later. Blur holds the shape while making it '
        'unreadable, which reads as one surface changing what it holds.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ElPanel(flush: true, child: ConsoleWithHistory()),
        SizedBox(height: el(6)),
        ElNote(
          title: 'Why this needs a hook and not an effect',
          child: ElRichText(
            TextSpan(
              children: <InlineSpan>[
                const TextSpan(
                  text:
                      'The obvious version: watch the conversation id, '
                      'animate when it changes: cannot work. By the time '
                      'the id has changed the old messages are already '
                      'gone, so it would blur the ',
                ),
                const TextSpan(
                  text: 'new',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                const TextSpan(
                  text:
                      ' conversation out and then back in: a flicker '
                      'with extra steps. ',
                ),
                ElCode.span('useBlurSwitch'),
                const TextSpan(
                  text:
                      ' inverts the order. It owns the transition and '
                      'calls the store in the middle of it: blur out '
                      'while the old conversation is still on screen, swap '
                      'at the point where nothing is legible anyway, then '
                      'blur in. The swap is hidden inside the movement '
                      'rather than decorated by it.',
                ),
              ],
            ),
            ElType.small,
          ),
        ),
        SizedBox(height: el(6)),
        ElMeta(
          items: <ElMetaItem>[
            (
              k: 'useBlurSwitch(open)',
              v: const TextSpan(
                text:
                    'returns { phase, switchTo }. Call switchTo instead '
                    'of store.open.',
              ),
            ),
            (k: 'phase', v: const TextSpan(text: '"idle" | "out" | "in"')),
            (
              k: 'blurClass(phase)',
              v: const TextSpan(
                text: 'the utility a transcript wears for that phase',
              ),
            ),
            (
              k: 'AgentConsole switchPhase',
              v: const TextSpan(
                text:
                    'hand the phase down; undefined means the transcript '
                    'never transitions',
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

/// `ConsoleWithHistory`: the console with history wired into its header slot.
///
/// **The one narrow surface this page has on `agent_console.dart`.** Every
/// reference to [ElAgentConsole] on this page is inside this widget, so a
/// signature drift in the console family costs one edit.
///
/// KNOWN GAP, `switchPhase`. The reference passes `switchPhase={phase}` and
/// the console wears `blurClass(switchPhase)` on its transcript;
/// [ElAgentConsole] does not take one yet. The controller is built and driven
/// here, and the drawer already calls [ElBlurSwitchController.switchTo], so the
/// only missing wire is the prop. Until it lands the transcript swaps without
/// blurring: named as a residual rather than faked by blurring the whole
/// console, which would take the header and the composer with it.
class ConsoleWithHistory extends StatefulWidget {
  const ConsoleWithHistory({super.key});

  /// `className="h-152"`, 608px *(measured: the console 1078 × 608 inside a
  /// 1080 × 610 flush Panel)*.
  static double get height => el(152);

  @override
  State<ConsoleWithHistory> createState() => _ConsoleWithHistoryState();
}

class _ConsoleWithHistoryState extends State<ConsoleWithHistory> {
  /// The box the drawer is laid over: the console's own root, which is
  /// `relative` on the reference for exactly this reason.
  final GlobalKey _surface = GlobalKey();
  final ElMockTransport _transport = ElMockTransport();

  MockConversationStore? _store;
  late final ElBlurSwitchController _switch = ElBlurSwitchController(
    open: (String id) => _store!.open(id),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _store ??= MockConversationStore(now: ElClock.nowOf(context));
  }

  @override
  void dispose() {
    _switch.dispose();
    _store?.dispose();
    _transport.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    key: _surface,
    height: ConsoleWithHistory.height,
    child: ElAgentConsole(
      transport: _transport,
      persona: agentPersona,
      toolStates: agentToolStates,
      commands: agentCommands,
      models: agentModels,
      describeApproval: describeAgentApproval,
      height: ConsoleWithHistory.height,
      headerSlot: ListenableBuilder(
        listenable: _switch,
        builder: (BuildContext context, Widget? _) => ElChatHistory(
          store: _store!,
          surfaceKey: _surface,
          // `{ ...store, open: switchTo }`: the drawer opens through the
          // blur rather than through the store.
          onOpenConversation: _switch.switchTo,
        ),
      ),
    ),
  );
}

/* ═══════════════════════════════════════════════════════════════════════════
   Shared fixtures, `agent-demo.tsx`'s own
   ═══════════════════════════════════════════════════════════════════════════ */

/// `PERSONA`.
const ElAgentPersona agentPersona = ElAgentPersona(
  name: 'Vault',
  blurb: 'Ask about packs, pulls, prices and your wallet.',
  suggestions: <String>[
    'What sealed boxes are left?',
    'Export my last 30 days',
    'Buy me an Eclipse Vault pack',
    'What is Eclipse Vault worth right now?',
  ],
  placeholder: 'Ask about a pack, a pull or your balance…',
);

/// `TOOL_STATES`, *"only the caller knows whether `export_activity` is
/// reading, writing or running, and a status line that guesses is a status line
/// that lies."*
const ElToolStateMap agentToolStates = <String, ElAgentState>{
  'search_inventory': ElAgentState.searching,
  'read_wallet': ElAgentState.retrieving,
  'export_activity': ElAgentState.writing,
  'fetch_market_price': ElAgentState.retrieving,
};

/// `COMMANDS`.
const List<ElAgentCommand> agentCommands = <ElAgentCommand>[
  ElAgentCommand(
    id: 'inventory',
    label: 'inventory',
    hint: 'What is in stock',
    group: ElAgentCommandGroup.skill,
    icon: ElLucide.search,
  ),
  ElAgentCommand(
    id: 'wallet',
    label: 'wallet',
    hint: 'Balance and recent movement',
    group: ElAgentCommandGroup.skill,
    icon: ElLucide.wallet,
  ),
  ElAgentCommand(
    id: 'export',
    label: 'export',
    hint: 'Download activity as CSV',
    group: ElAgentCommandGroup.skill,
    icon: ElLucide.download,
  ),
  ElAgentCommand(
    id: 'guide',
    label: 'guide',
    hint: 'How pack odds work',
    group: ElAgentCommandGroup.command,
    icon: ElLucide.bookOpen,
  ),
];

/// `MODELS`.
const List<ElAgentModel> agentModels = <ElAgentModel>[
  ElAgentModel(id: 'fast', label: 'Fast', hint: 'Answers in a second'),
  ElAgentModel(id: 'deep', label: 'Deep', hint: 'Slower, checks its work'),
];

/// `describeApproval`: turns a held action into a sentence a human can decide
/// on.
String describeAgentApproval(String action, Map<String, Object?> params) {
  if (action == 'purchase_pack') {
    final double price = (params['price'] as num?)?.toDouble() ?? 0;
    return 'Buy ${params['pack']} for \$${price.toStringAsFixed(2)}. '
        'This spends real money and cannot be undone.';
  }
  return 'Run $action.';
}

/* ═══════════════════════════════════════════════════════════════════════════
   The mock store
   ═══════════════════════════════════════════════════════════════════════════ */

/// `lib/agent/mock-conversations.ts`: a conversation store with nothing behind
/// it.
///
/// It implements the whole [ElConversationStore] interface **including the two
/// optional capabilities**, which is what lets the page show the list both with
/// and without them. A store that omits `pin` gets no pin button and no pinned
/// section, and that is not a special case in the list, it is the absence of a
/// function.
///
/// Timestamps are the one thing that cannot be a literal: `relativeTime`
/// renders "3 hours ago" against the clock, so fixed ISO strings would drift
/// into "8 months ago" and the page would quietly rot. They are offsets from
/// [now] instead: and [now] comes from [ElClock], so the parity rig can freeze
/// both renderers on the same instant.
class MockConversationStore extends ElConversationStore {
  MockConversationStore({required DateTime now, this.capabilities = true})
    : _conversations = _seed(now);

  /// Drop `pin` and `share` from the store, to show the degraded list.
  final bool capabilities;

  /// `ago(minutes, from)`: an instant N minutes before the store was created.
  static DateTime _ago(int minutes, DateTime from) =>
      from.subtract(Duration(minutes: minutes));

  /// The seed, verbatim.
  static List<ElConversationSummary> _seed(DateTime now) =>
      <ElConversationSummary>[
        ElConversationSummary(
          id: 'c-vault',
          title: 'Sealed inventory check',
          updatedAt: _ago(14, now),
          preview: 'What sealed boxes are left, and what is the best one?',
          pinned: true,
        ),
        ElConversationSummary(
          id: 'c-export',
          title: 'Thirty-day activity export',
          updatedAt: _ago(95, now),
          preview: 'Export my last 30 days as a CSV',
          pinned: true,
        ),
        ElConversationSummary(
          id: 'c-pricing',
          title: 'Pricing service outage',
          updatedAt: _ago(260, now),
          preview: 'What is Eclipse Vault worth right now?',
        ),
        ElConversationSummary(
          id: 'c-hold',
          title: 'Putting a pack on hold',
          updatedAt: _ago(1500, now),
          preview: 'Buy me an Eclipse Vault pack',
        ),
        ElConversationSummary(
          id: 'c-odds',
          title: 'How pack odds actually work',
          updatedAt: _ago(4300, now),
          preview: 'Explain the odds on a sealed box',
        ),
        ElConversationSummary(
          id: 'c-balance',
          title: 'Balance and recent movement',
          updatedAt: _ago(11000, now),
          preview: 'How much do I have available?',
        ),
        ElConversationSummary(
          id: 'c-grading',
          title: 'Grading a first edition',
          updatedAt: _ago(26000, now),
          preview: 'Is it worth grading a 1st edition?',
        ),
      ];

  List<ElConversationSummary> _conversations;
  String? _activeId = 'c-vault';

  @override
  List<ElConversationSummary> get conversations =>
      List<ElConversationSummary>.unmodifiable(_conversations);

  @override
  String? get activeId => _activeId;

  @override
  bool get isLoading => false;

  @override
  String? get error => null;

  @override
  void open(String id) {
    if (_activeId == id) return;
    _activeId = id;
    notifyListeners();
  }

  @override
  void create() {
    _activeId = null;
    notifyListeners();
  }

  @override
  void rename(String id, String title) {
    _conversations = <ElConversationSummary>[
      for (final ElConversationSummary c in _conversations)
        if (c.id == id) c.copyWith(title: title) else c,
    ];
    notifyListeners();
  }

  @override
  void remove(String id) {
    _conversations = _conversations
        .where((ElConversationSummary c) => c.id != id)
        .toList();
    if (_activeId == id) _activeId = null;
    notifyListeners();
  }

  @override
  void refresh() {}

  @override
  void Function(String id, bool pinned)? get pin => capabilities ? _pin : null;

  void _pin(String id, bool pinned) {
    _conversations = <ElConversationSummary>[
      for (final ElConversationSummary c in _conversations)
        if (c.id == id) c.copyWith(pinned: pinned) else c,
    ];
    notifyListeners();
  }

  /// A real store would mint a link or export a transcript. The interface does
  /// not say which, on purpose: it only says the product has one.
  @override
  void Function(String id)? get share => capabilities ? _share : null;

  void _share(String id) {
    // `window.console.info("[mock] share …")`: the reference's own no-op.
  }
}
