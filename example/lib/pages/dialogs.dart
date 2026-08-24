/// `/design-system/components/base/dialogs`: nine overlays, and every one of
/// them opens.
///
/// The page the modal family arrives on. `ElPopover` shipped with `selects` and
/// `ElSheet`'s left-hand route with the shell; everything else is new here —
/// `ElDialog`, `ElAlertDialog`, `ElDrawer`, `ElTooltip`, `ElHoverCard`,
/// `ElBadge`, and the sheet's own four sides and three-zone banding.
///
/// **The fidelity bar is that they open.** A reader can press Open Pack and
/// watch the jelly, drag the drawer down to dismiss it, hover an icon button
/// for 200ms and get a label, hover a link for 700 and get a card, press Delete
/// account and take the confirmation through to a toast: and press the failing
/// one and watch the inline alert arrive. A page that renders these as stills
/// fails, however exact the pixels.
///
/// ## What is page-local and why
///
/// [_DangerZone] is `components/el/danger-zone-demo.tsx`, which the reference
/// itself keeps out of `components/ui/`: *"It is a composition, not a new
/// primitive… RULES §5 says a screen is composition before it is creation, and
/// the pieces this needs all existed."* It stays here on the same reasoning and
/// on the B10 precedent: kit promotion wants a second consuming page.
///
/// ## Drift register: recorded, shipped as written
///
///  1. **Nine chips, eleven sections, and the last two get none.** `contents`
///     is `[Dialog, Media Dialog, Alert Dialog, Danger Zone, Sheet, Drawer,
///     Popover, Hover Card, Tooltip]`; the sections are those nine plus `api`
///     and `rules`. The same shape `feedback` and `selection` carry.
///  2. **"No escape-to-cancel by accident" is half true.** §3's description
///     promises the alert dialog is *"deliberately harder to dismiss: no
///     overlay click, no escape-to-cancel by accident"*. Measured: a click on
///     the overlay leaves it mounted, and Escape closes it. Radix's
///     `AlertDialog` blocks `onPointerDownOutside` only, and the reference
///     passes no `onEscapeKeyDown`. Both the copy and the behaviour ship as
///     they are.
///  3. **Every alert-dialog button carries a tooltip of its own label.**
///     `AlertDialogAction`/`Cancel` fall back to `children` when no `tooltip`
///     is passed, so hovering "Sell all for $2,481.00" shows a tooltip reading
///     "Sell all for $2,481.00". Reproduced.
///  4. **The Rules note names `--duration-base` for the exit and is right** —
///     the one place in the corpus where a duration-word in prose matches what
///     runs, because `anim-jelly-out` reads the variable directly rather than
///     through a `duration-*` utility.
///  5. **`showCloseButton={false}` on the media dialog leaves two `DialogClose`
///     wrappers in the footer**, so the announcement has two buttons that both
///     close and no X. Reproduced: "Not now" and "See what's new" both dismiss.
///  6. **The tooltip section's prose says "opens after 200ms"** and the
///     provider agrees: measured 232.5ms to first frame, which is 200 plus a
///     frame. The one timing claim on the page that survives measurement
///     unchanged.
///  7. **The hover card's trigger is a `Button variant="link"`**, so the
///     preview hangs off a 40px pill rather than off a run of text: the
///     component's own `h-10` wins over the inline look the copy implies.
///  8. **The drawer is full-bleed on a 1440 desktop.** `inset-x-0` has no
///     `sm:` cap, so *"the mobile bottom sheet"* renders 1440 wide with its
///     content in a 1408px column. Reproduced exactly.
///  9. **The danger zone's row is `flex-wrap justify-between`**, which means
///     the wide instance puts its button on the right and the three narrow ones
///     wrap it onto a second line at the *left*. Measured 99px and 155px rows
///     from the same markup.
/// 10. **`ElGrid` stretches where CSS grid does not.** The four bad-day zones
///     sit in `lg:grid-cols-2`, and the reference's two rows are sized by their
///     tallest cell while each zone keeps its own height. The port's grid hands
///     each cell a tight height, so every cell is a plain [Column]: which
///     packs at the top and leaves its children their natural heights.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart';

import '../kit.dart';
import '../nav.dart';
import '../shell.dart';

/* ── Page constants ──────────────────────────────────────────────────────── */

/// `max-w-2xl`: the settings column the first danger zone is centred in.
final double _measure2xl = ElContainers.xl2;

/// `max-w-md`: the danger zone's description column.
final double _measureMd = ElContainers.md;

/// `<strong>` inside a `.type-small` sentence. The same helper `feedback.dart`
/// carries, and for the same reason: a bare `FontWeight.bold` would drop the
/// `opsz` entry `font-optical-sizing: auto` puts on the variable face.
const double _bolder = 700;

TextStyle _strong(TextStyle base) => base.copyWith(
  fontWeight: FontWeight.bold,
  fontVariations: <FontVariation>[
    for (final FontVariation v
        in base.fontVariations ?? const <FontVariation>[])
      if (v.axis != 'wght') v,
    const FontVariation('wght', _bolder),
  ],
);

/// `<em>`: the alert-dialog note has one.
const TextStyle _em = TextStyle(fontStyle: FontStyle.italic);

/// A `.type-small` paragraph under a specimen row, `className="type-small
/// mt-5"`, which every panel on this page spells the same way.
class _Prose extends StatelessWidget {
  const _Prose(this.text, {this.top});

  final String text;

  /// `mt-5` on the four specimen panels; the danger zone's own paragraph is
  /// the one that says `mt-6`.
  final double? top;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: top ?? el(5)),
    child: ElText(text, ElType.small),
  );
}

/* ── The page ────────────────────────────────────────────────────────────── */

class DialogsPage extends StatelessWidget {
  const DialogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ElCategoryHit here = findCategory('base', 'dialogs');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElPageHeader(
          eyebrow: '${here.group.title} · Base',
          title: here.category.title,
          blurb: here.category.blurb,
          // DRIFT 1: nine chips against eleven sections.
          contents: here.category.contents,
        ),
        // `className="mb-12"`, 48px, the Note outside every section.
        Padding(
          padding: EdgeInsets.only(bottom: el(12)),
          child: const ElNote(
            title: 'Picking the right overlay',
            child: _PickingBody(),
          ),
        ),
        const _DialogSection(),
        const _MediaDialogSection(),
        const _AlertDialogSection(),
        const _DangerZoneSection(),
        const _SheetSection(),
        const _DrawerSection(),
        const _PopoverSection(),
        const _HoverCardSection(),
        const _TooltipSection(),
        const _ApiSection(),
        const _RulesSection(),
        const ElPageFootNav(groupId: 'base', slug: 'dialogs'),
      ],
    );
  }
}

/// Six `<strong className="text-foreground">` runs stepping up out of the
/// Note's own `--muted-foreground`.
class _PickingBody extends StatelessWidget {
  const _PickingBody();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final TextStyle base = ElText.styleOf(context, ElType.small);
    final TextStyle strong = _strong(base).copyWith(color: theme.foreground);

    return ElRichText(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(text: 'Dialog', style: strong),
          const TextSpan(text: ' interrupts for a decision. '),
          TextSpan(text: 'Alert Dialog', style: strong),
          const TextSpan(
            text:
                ' interrupts for a decision that cannot be undone, and '
                'cannot be dismissed by clicking outside. ',
          ),
          TextSpan(text: 'Sheet', style: strong),
          const TextSpan(
            text: ' slides in from an edge for filters and secondary panels. ',
          ),
          TextSpan(text: 'Drawer', style: strong),
          const TextSpan(text: ' is the mobile bottom sheet. '),
          TextSpan(text: 'Popover', style: strong),
          const TextSpan(
            text: ' is a small non-modal panel attached to a control. ',
          ),
          TextSpan(text: 'Tooltip', style: strong),
          const TextSpan(text: ' is a label, never content.'),
        ],
      ),
      ElType.small,
    );
  }
}

/* ── §1 Dialog ───────────────────────────────────────────────────────────── */

class _DialogSection extends StatelessWidget {
  const _DialogSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'dialog',
    title: 'Dialog',
    description:
        "Modal, dismissible, for a decision that needs the "
        "user's full attention. Purchase confirmation is the canonical "
        'case.',
    child: ElPanel(
      label: 'Purchase confirmation',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ElRow(
            children: <Widget>[
              ElDialog(
                trigger: (BuildContext context, VoidCallback open) => ElButton(
                  onPressed: open,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ElIcon(ElIconGlyph.packageOpen, size: ElIconSize.sm),
                      _ButtonGap(),
                      Text('Open Pack'),
                    ],
                  ),
                ),
                content: (BuildContext context, VoidCallback close) =>
                    _PurchaseDialog(close: close),
              ),
              ElDialog(
                trigger: (BuildContext context, VoidCallback open) => ElButton(
                  variant: ElButtonVariant.secondary,
                  onPressed: open,
                  child: const Text('Form dialog'),
                ),
                content: (BuildContext context, VoidCallback close) =>
                    _ShipmentDialog(close: close),
              ),
            ],
          ),
          const _Prose(
            'Three zones: a muted header band (title, description, close), '
            'the lit body you are deciding on, and a muted footer band for '
            'the CTAs. A dialog is a container for a task, and the banding '
            'is what makes that structure readable at a glance. Escape and '
            'clicking the overlay both close it, because nothing here is '
            'destructive.',
          ),
        ],
      ),
    ),
  );
}

/// `gap-2` inside a `size="default"` button: the reference's own
/// `[&_svg]:shrink-0` row.
class _ButtonGap extends StatelessWidget {
  const _ButtonGap();

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: ElButton.gapFor(ElButtonSize.md));
}

class _PurchaseDialog extends StatelessWidget {
  const _PurchaseDialog({required this.close});

  final VoidCallback close;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return ElDialogContent(
      onClose: close,
      children: <Widget>[
        const ElDialogHeader(
          children: <Widget>[
            ElDialogTitle('Confirm your purchase'),
            ElDialogDescription(
              'You are about to open 3 packs of Eclipse Vault. This cannot be '
              'reversed once the cards are revealed.',
            ),
          ],
        ),
        // `my-2`: the one child on the page that carries a margin of its own,
        // which is why the measured gap above and below it is 24 and not 16.
        Padding(
          padding: EdgeInsets.symmetric(vertical: el(2)),
          // [Container], not [DecoratedBox]: the receipt's 138px is a BORDER
          // box, and only Container pays `decoration.padding` for a border.
          child: Container(
            decoration: BoxDecoration(
              color: theme.background,
              borderRadius: BorderRadius.circular(ElRadii.lg),
              border: Border.all(color: theme.border, width: ElWidths.hairline),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const _LineItem(k: '3 × Eclipse Vault', v: r'$144.00'),
                _Divider(theme: theme),
                const _LineItem(k: 'Bonus balance applied', v: r'−$20.00'),
                _Divider(theme: theme),
                const _LineItem(k: 'Total', v: r'$124.00', total: true),
              ],
            ),
          ),
        ),
        ElDialogFooter(
          children: <Widget>[
            ElButton(
              variant: ElButtonVariant.ghost,
              onPressed: close,
              child: const Text('Cancel'),
            ),
            ElButton(
              variant: ElButtonVariant.premium,
              onPressed: () {},
              child: const Text('Confirm & Open'),
            ),
          ],
        ),
      ],
    );
  }
}

/// `divide-y divide-border`: a 1px rule between rows and none at the ends.
class _Divider extends StatelessWidget {
  const _Divider({required this.theme});

  final ElThemeData theme;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: ElWidths.hairline,
    child: ColoredBox(color: theme.border),
  );
}

/// One `flex justify-between px-4 py-3` row of the receipt.
class _LineItem extends StatelessWidget {
  const _LineItem({required this.k, required this.v, this.total = false});

  final String k;
  final String v;

  /// The last row swaps `.type-small`/`.type-num` for `.type-label`/
  /// `.type-num-md text-value-ink`, and grows from 44.5 to 47 tall doing it.
  final bool total;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: el(4), vertical: el(3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ElText(
            k,
            total ? ElType.label : ElType.small,
            color: theme.mutedForeground,
          ),
          ElText(
            v,
            total ? ElType.numMd : ElType.numBase,
            color: total ? theme.valueInk : theme.foreground,
          ),
        ],
      ),
    );
  }
}

class _ShipmentDialog extends StatelessWidget {
  const _ShipmentDialog({required this.close});

  final VoidCallback close;

  @override
  Widget build(BuildContext context) => ElDialogContent(
    onClose: close,
    children: <Widget>[
      const ElDialogHeader(
        children: <Widget>[
          ElDialogTitle('Request shipment'),
          ElDialogDescription(
            'Physical cards ship from our vault once a request is '
            'approved.',
          ),
        ],
      ),
      const ElFieldGroup(
        children: <Widget>[
          ElField(
            label: 'Full name',
            child: ElInput(placeholder: 'As it appears on ID'),
          ),
          ElField(
            label: 'Address',
            child: ElInput(placeholder: 'Street address'),
          ),
        ],
      ),
      ElDialogFooter(
        children: <Widget>[
          ElButton(
            variant: ElButtonVariant.ghost,
            onPressed: close,
            child: const Text('Cancel'),
          ),
          ElButton(
            onPressed: () {},
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElIcon(ElIconGlyph.truck, size: ElIconSize.sm),
                _ButtonGap(),
                Text('Request Shipment'),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

/* ── §2 Media dialog ─────────────────────────────────────────────────────── */

class _MediaDialogSection extends StatelessWidget {
  const _MediaDialogSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'media-dialog',
    title: 'Media dialog',
    description:
        'The existing Dialog with a full-bleed visual lead. Use '
        'it for announcements, product news, onboarding updates and '
        'promotions—not confirmations.',
    child: ElPanel(
      label: 'Announcement with image header',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ElRow(
            children: <Widget>[
              ElDialog(
                trigger: (BuildContext context, VoidCallback open) => ElButton(
                  variant: ElButtonVariant.secondary,
                  onPressed: open,
                  child: const Text('Show announcement'),
                ),
                content: (BuildContext context, VoidCallback close) =>
                    _AnnouncementDialog(close: close),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: el(5)),
            child: const _MediaProse(),
          ),
        ],
      ),
    ),
  );
}

/// The paragraph with a `<Code>` chip in the middle of it.
class _MediaProse extends StatelessWidget {
  const _MediaProse();

  @override
  Widget build(BuildContext context) => ElRichText(
    TextSpan(
      children: <InlineSpan>[
        const TextSpan(text: 'This is '),
        // U+201C / U+201D: the reference writes `&quot;` inside the chip.
        ElCode.span('DialogContent variant="media"'),
        const TextSpan(
          text:
              ', not a separate modal. It keeps the same focus trap, '
              'overlay, dismissal, motion, title/description wiring and '
              'action components.',
        ),
      ],
    ),
    ElType.small,
  );
}

class _AnnouncementDialog extends StatelessWidget {
  const _AnnouncementDialog({required this.close});

  final VoidCallback close;

  @override
  Widget build(BuildContext context) => ElDialogContent(
    variant: ElDialogVariant.media,
    // DRIFT 5: no X, and both footer buttons close.
    showCloseButton: false,
    onClose: close,
    children: <Widget>[
      const ElDialogMedia(
        child: Image(
          image: AssetImage('assets/imgs/sample-pack.jpg'),
          fit: BoxFit.cover,
          // `object-center`.
          alignment: Alignment.center,
          semanticLabel: 'Silver Tempest pack artwork',
        ),
      ),
      const ElDialogHeader(
        children: <Widget>[
          // `w-fit`: the chip is as wide as its label.
          ElBadge(label: 'New release', variant: ElBadgeVariant.action),
          ElDialogTitle('Silver Tempest has arrived'),
          ElDialogDescription(
            'A new set is live with fresh pulls, published odds and a '
            'limited first release. See what changed before opening a '
            'pack.',
          ),
        ],
      ),
      ElDialogFooter(
        children: <Widget>[
          ElButton(
            variant: ElButtonVariant.ghost,
            onPressed: close,
            child: const Text('Not now'),
          ),
          ElButton(
            onPressed: close,
            // U+2019, `See what&rsquo;s new`.
            child: const Text('See what’s new'),
          ),
        ],
      ),
    ],
  );
}

/* ── §3 Alert dialog ─────────────────────────────────────────────────────── */

class _AlertDialogSection extends StatelessWidget {
  const _AlertDialogSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'alert-dialog',
    title: 'Alert Dialog',
    description:
        'For actions that cannot be undone. Deliberately harder '
        'to dismiss: no overlay click, no escape-to-cancel by accident, '
        'and the confirming button states the consequence.',
    child: ElPanel(
      label: 'Destructive confirmations',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ElRow(
            children: <Widget>[
              ElAlertDialog(
                trigger: (BuildContext context, VoidCallback open) => ElButton(
                  variant: ElButtonVariant.destructive,
                  onPressed: open,
                  child: const Text('Sell All Cards'),
                ),
                content: (BuildContext context, VoidCallback close) =>
                    ElAlertDialogContent(
                      header: const ElAlertDialogHeader(
                        title: ElAlertDialogTitle(
                          r'Sell all 12 cards for $2,481.00?',
                        ),
                        description: ElAlertDialogDescription(
                          'Every card in this pull will be sold back at its '
                          'current listed value and removed from your Stash. '
                          'This cannot be undone, and the cards cannot be '
                          'bought back.',
                        ),
                      ),
                      footer: ElAlertDialogFooter(
                        cancel: ElAlertDialogCancel(
                          label: 'Keep my cards',
                          onPressed: close,
                        ),
                        action: ElAlertDialogAction(
                          label: r'Sell all for $2,481.00',
                          onPressed: close,
                        ),
                      ),
                    ),
              ),
              ElAlertDialog(
                trigger: (BuildContext context, VoidCallback open) => ElButton(
                  variant: ElButtonVariant.outline,
                  onPressed: open,
                  child: const Text('Close account'),
                ),
                content: (BuildContext context, VoidCallback close) =>
                    ElAlertDialogContent(
                      header: const ElAlertDialogHeader(
                        title: ElAlertDialogTitle('Close your account?'),
                        description: ElAlertDialogDescription(
                          r'Your remaining balance of $1,204.80 will be '
                          'returned to your payment method. Pending shipments '
                          'will still be delivered. Your Stash and pull '
                          'history will be permanently deleted.',
                        ),
                      ),
                      footer: ElAlertDialogFooter(
                        cancel: ElAlertDialogCancel(
                          label: 'Cancel',
                          onPressed: close,
                        ),
                        action: ElAlertDialogAction(
                          label: 'Close my account',
                          onPressed: close,
                        ),
                      ),
                    ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: el(6)),
            child: const ElNote(
              title: 'Two zones here, not three',
              child: _TwoZonesBody(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: el(6)),
            child: const ElNote(
              tone: ElNoteTone.error,
              title: 'Write the consequence into the button',
              child: _ConsequenceBody(),
            ),
          ),
        ],
      ),
    ),
  );
}

class _TwoZonesBody extends StatelessWidget {
  const _TwoZonesBody();

  @override
  Widget build(BuildContext context) => ElRichText(
    const TextSpan(
      children: <InlineSpan>[
        TextSpan(text: 'The alert dialog is the one overlay that does '),
        TextSpan(text: 'not', style: _em),
        TextSpan(
          text:
              ' band its header. A dialog is a container for a task, so '
              'three zones make its structure readable. An alert dialog is '
              'a single question, and the question ',
        ),
        TextSpan(text: 'is', style: _em),
        TextSpan(
          text:
              ' the content: putting it in a card box demotes the most '
              'important words on the screen into a caption for whatever '
              'sits beneath them. Title and description sit straight on '
              'the panel; only the footer is banded, because only the '
              'footer is the decision.',
        ),
      ],
    ),
    ElType.small,
  );
}

class _ConsequenceBody extends StatelessWidget {
  const _ConsequenceBody();

  @override
  Widget build(BuildContext context) => ElText(
    // U+201C / U+201D throughout, `&ldquo;` / `&rdquo;`.
    '“Sell all for \$2,481.00” beats “Confirm”. The user should be able to '
    'read only the button and still know exactly what happens. The cancel '
    'option is also phrased as the safe choice, “Keep my cards”, not just '
    '“Cancel”.',
    ElType.small,
  );
}

/* ── §4 Danger zone ──────────────────────────────────────────────────────── */

class _DangerZoneSection extends StatelessWidget {
  const _DangerZoneSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'danger-zone',
    title: 'Danger Zone',
    description:
        'Where an Alert Dialog actually lives. A settings page '
        'collects its irreversible actions into one bordered region, apart '
        'from everything reversible above it, so nothing destructive is '
        'ever the next control after a text field.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElPanel(
          label: 'Settings · Account',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // `mx-auto max-w-2xl space-y-8`.
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: _measure2xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const _AccountHeading(),
                      SizedBox(height: el(8)),
                      const _DangerZone(),
                    ],
                  ),
                ),
              ),
              _Prose(
                top: el(6),
                'The region is bordered, not filled. A red block beside '
                'three neutral settings blocks reads as an error that has '
                'already happened; the hairline and the heading say '
                '“careful”, and the tint is spent on the button, which is '
                'the thing that acts. Confirm it and the button spins, a '
                'success toast fires, and the row itself changes: because '
                'a toast is gone in four seconds and the page must still '
                'show what happened.',
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        ElPanel(
          label: 'The states that only exist on a bad day',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElGrid(
                lg: 2,
                gap: el(6),
                children: <Widget>[
                  _BadDayCell(
                    label: 'Failing · the request rejects',
                    // The injectable seam, live: a rejecting `onDelete`.
                    zone: _DangerZone(onDelete: _rejects),
                  ),
                  const _BadDayCell(
                    label: 'Unavailable · with the reason',
                    zone: _DangerZone(
                      unavailableReason: r'Settle your $412.00 balance first.',
                    ),
                  ),
                  const _BadDayCell(
                    label: 'Loading · same footprint',
                    zone: _DangerZone(loading: true),
                  ),
                  const _BadDayCell(
                    label: 'Rest · for comparison',
                    zone: _DangerZone(),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: el(6)),
                child: const ElNote(
                  tone: ElNoteTone.error,
                  title: 'The failure path is live, not drawn',
                  child: _FailurePathBody(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: el(6)),
        const ElMeta(
          items: <ElMetaItem>[
            (
              k: 'onDelete',
              v: TextSpan(
                text:
                    '() => Promise<void>. The injectable effect. '
                    'Defaults to a call that resolves, so the happy path '
                    'needs no wiring; reject it to reach the error state.',
              ),
            ),
            (
              k: 'unavailableReason',
              v: TextSpan(
                text:
                    'A sentence. Present = the action is disabled and '
                    'this says why. The control is exempt from contrast '
                    '(WCAG 1.4.3); the sentence beside it is not.',
              ),
            ),
            (
              k: 'loading',
              v: TextSpan(
                text:
                    'Renders the same row with its content replaced, so '
                    'the footprint cannot drift.',
              ),
            ),
            (
              k: 'States',
              v: TextSpan(
                text:
                    "rest · hover / focus / pressed (Button's own) · "
                    'loading · success · error · disabled. No empty state: '
                    'a danger zone with no actions is not rendered at all.',
              ),
            ),
          ],
        ),
      ],
    ),
  );

  /// `() => Promise.reject(new Error("The billing service is offline."))`.
  static Future<void> _rejects() =>
      Future<void>.error(StateError('The billing service is offline.'));
}

class _AccountHeading extends StatelessWidget {
  const _AccountHeading();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      ElText('Account', ElType.h4, color: ElTheme.of(context).foreground),
      Padding(
        padding: EdgeInsets.only(top: el(1)),
        child: ElText(
          'Workspace name, members and billing. Changes here save as you '
          'type.',
          ElType.small,
        ),
      ),
    ],
  );
}

/// One cell of `grid gap-6 lg:grid-cols-2`: a `.type-label mb-3` caption over
/// a zone.
class _BadDayCell extends StatelessWidget {
  const _BadDayCell({required this.label, required this.zone});

  final String label;
  final Widget zone;

  @override
  Widget build(BuildContext context) => Column(
    // DRIFT 10: a plain [Column] packs at the top and leaves the zone its
    // own height inside the grid's tight cell.
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      ElText(label, ElType.label, color: ElTheme.of(context).mutedForeground),
      SizedBox(height: el(3)),
      zone,
    ],
  );
}

class _FailurePathBody extends StatelessWidget {
  const _FailurePathBody();

  @override
  Widget build(BuildContext context) => ElRichText(
    TextSpan(
      children: <InlineSpan>[
        const TextSpan(text: 'The second zone above takes a rejecting '),
        ElCode.span('onDelete'),
        TextSpan(
          text:
              '. That seam exists so the error state is reachable on the '
              'page instead of described in prose: press it and the '
              'toast, the inline alert and the return to rest all happen '
              'for real. A destructive button whose only tested path is '
              'success is the one that ships broken.',
        ),
      ],
    ),
    ElType.small,
  );
}

/* ── The danger zone itself ──────────────────────────────────────────────── */

/// `DeleteStatus`.
enum _DeleteStatus { idle, deleting, deleted, failed }

/// `components/el/danger-zone-demo.tsx`.
///
/// *"Why the region is bordered rather than tinted: RULES §5, Alert: one
/// surface, five meanings. A filled red block beside three neutral settings
/// blocks reads as an error that has already happened. The hairline and the
/// heading say 'careful'; the tint is spent on the button, which is the thing
/// that acts."*
///
/// Measured (2026-08-16): `rounded-lg` 12px, a 1px `--destructive`/30 border,
/// `--card` fill, `overflow-hidden`; a `px-5 py-3` heading band on
/// `--destructive`/8 with a 1px rule under it; a `px-5 py-4` row that wraps.
class _DangerZone extends StatefulWidget {
  const _DangerZone({
    this.onDelete,
    this.unavailableReason,
    this.loading = false,
  });

  /// *"The effect. Defaults to a call that resolves, so the happy path works
  /// with no wiring. Reject to reach the error state."*
  final Future<void> Function()? onDelete;

  /// *"Present = the action is unavailable, and this is the sentence saying
  /// why."*
  final String? unavailableReason;

  final bool loading;

  /// `border-destructive/30`.
  static const double borderAlpha = 0.30;

  /// `bg-destructive/8`.
  static const double bandAlpha = 0.08;

  /// `const DEFAULT_DELETE = () => new Promise((resolve) =>
  /// setTimeout(resolve, 1400))`: the demo's own latency.
  static const Duration defaultLatency = Duration(
    milliseconds: 1400,
  ); // allow-hardcoded: the page's own demo latency, a call-site constant and not a --duration-* token

  @override
  State<_DangerZone> createState() => _DangerZoneState();
}

class _DangerZoneState extends State<_DangerZone> {
  _DeleteStatus _status = _DeleteStatus.idle;
  String? _failure;

  Future<void> _runDelete() async {
    setState(() {
      _status = _DeleteStatus.deleting;
      _failure = null;
    });
    try {
      await (widget.onDelete ??
          () => Future<void>.delayed(_DangerZone.defaultLatency))();
      if (!mounted) return;
      setState(() => _status = _DeleteStatus.deleted);
      docsToasts.success(
        'Account deleted',
        description: 'You have been signed out everywhere.',
      );
    } catch (error) {
      if (!mounted) return;
      final String reason = error is StateError
          ? error.message
          : 'The server did not respond.';
      setState(() {
        _status = _DeleteStatus.failed;
        _failure = reason;
      });
      docsToasts.error('Could not delete your account', description: reason);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    final Color hairline = theme.destructive.withValues(
      alpha: _DangerZone.borderAlpha,
    );

    // The zone's 140px is a border box: `box-sizing: border-box` spends two of
    // them on the hairline, which [Container] pays and [DecoratedBox] does not.
    return Container(
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(ElRadii.lg),
        border: Border.all(color: hairline, width: ElWidths.hairline),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ElRadii.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _DangerHeading(hairline: hairline),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: el(5), vertical: el(4)),
              child: _row(theme),
            ),
            if (_status == _DeleteStatus.failed && _failure != null)
              Padding(
                padding: EdgeInsets.fromLTRB(el(5), 0, el(5), el(5)),
                child: ElAlert(
                  variant: ElAlertVariant.destructive,
                  icon: const ElIcon(
                    ElIconGlyph.alertTriangle,
                    tone: ElIconTone.error,
                  ),
                  title: 'Account not deleted',
                  description:
                      '$_failure Nothing was removed. Try again, or '
                      'contact support if it keeps failing.',
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _row(ElThemeData theme) {
    if (widget.loading) return const _DangerZoneRowSkeleton();
    if (_status == _DeleteStatus.deleted) return const _DeletedRow();
    return Wrap(
      // `flex flex-wrap items-center justify-between gap-4`: two items on one
      // line push apart, and a wrapped line starts at the left.
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: el(4),
      runSpacing: el(4),
      children: <Widget>[
        const _DeleteCopy(),
        if (widget.unavailableReason != null)
          _Unavailable(reason: widget.unavailableReason!)
        else
          ElAlertDialog(
            trigger: (BuildContext context, VoidCallback open) => ElButton(
              variant: ElButtonVariant.destructive,
              loading: _status == _DeleteStatus.deleting,
              onPressed: open,
              child: const Text('Delete account'),
            ),
            content: (BuildContext context, VoidCallback close) =>
                ElAlertDialogContent(
                  header: const ElAlertDialogHeader(
                    title: ElAlertDialogTitle('Delete your account?'),
                    description: ElAlertDialogDescription(
                      'Your workspace, its 14 members and all 2,480 files are '
                      'removed immediately. Support cannot restore them, and the '
                      'workspace name becomes available to anyone.',
                    ),
                  ),
                  footer: ElAlertDialogFooter(
                    cancel: ElAlertDialogCancel(
                      label: 'Keep my account',
                      onPressed: close,
                    ),
                    action: ElAlertDialogAction(
                      label: 'Delete my account and all files',
                      onPressed: () {
                        close();
                        _runDelete();
                      },
                    ),
                  ),
                ),
          ),
      ],
    );
  }
}

/// The heading band: icon, rule, `.type-label` in `--destructive-ink`.
class _DangerHeading extends StatelessWidget {
  const _DangerHeading({required this.hairline});

  final Color hairline;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.destructive.withValues(alpha: _DangerZone.bandAlpha),
        border: Border(
          bottom: BorderSide(color: hairline, width: ElWidths.hairline),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: el(5), vertical: el(3)),
        child: Row(
          children: <Widget>[
            const ElIcon(
              ElIconGlyph.shieldAlert,
              size: ElIconSize.sm,
              tone: ElIconTone.error,
            ),
            SizedBox(width: el(2)),
            ElText('Danger zone', ElType.label, color: theme.destructiveInk),
          ],
        ),
      ),
    );
  }
}

/// The resting copy, `.type-body` over a `.type-small max-w-md`.
class _DeleteCopy extends StatelessWidget {
  const _DeleteCopy();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: BoxConstraints(maxWidth: _measureMd),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ElText(
          'Delete account',
          ElType.body,
          color: ElTheme.of(context).foreground,
        ),
        Padding(
          padding: EdgeInsets.only(top: el(1)),
          child: ElText(
            'Your workspace, its members and every file in it are removed '
            'immediately. This cannot be undone.',
            ElType.small,
          ),
        ),
      ],
    ),
  );
}

/// `flex flex-col items-end gap-1.5`: a disabled button and the sentence that
/// says why.
class _Unavailable extends StatelessWidget {
  const _Unavailable({required this.reason});

  final String reason;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: <Widget>[
      const ElButton(
        variant: ElButtonVariant.destructive,
        // No handler: `disabled`.
        child: Text('Delete account'),
      ),
      SizedBox(height: el(1.5)),
      // *"Active text beside a disabled control. The control is exempt from
      // contrast (trap 9); this sentence is not."*
      ElText(
        reason,
        ElType.caption,
        align: TextAlign.right,
        color: ElTheme.of(context).mutedForeground,
      ),
    ],
  );
}

/// *"The outcome, on the page rather than only in the toast."*
class _DeletedRow extends StatelessWidget {
  const _DeletedRow();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: BoxConstraints(maxWidth: _measureMd),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ElText(
          'Account deleted',
          ElType.body,
          color: ElTheme.of(context).foreground,
        ),
        Padding(
          padding: EdgeInsets.only(top: el(1)),
          child: ElText(
            'Deleted a moment ago. You will be signed out of every device '
            'shortly.',
            ElType.small,
          ),
        ),
      ],
    ),
  );
}

/// *"The same row with its content replaced, which is the only reliable way to
/// keep the footprint identical. Measured against the resting row: same
/// height, to the pixel."*
class _DangerZoneRowSkeleton extends StatelessWidget {
  const _DangerZoneRowSkeleton();

  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.spaceBetween,
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: el(4),
    runSpacing: el(4),
    children: <Widget>[
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // `<p className="type-body"><Skeleton as="span" className="h-4
          // w-36 align-middle" /></p>`: an inline placeholder in a real
          // line box, so the row keeps the resting row's 24px line.
          _SkeletonLine(spec: ElType.body, width: el(36), height: el(4)),
          Padding(
            padding: EdgeInsets.only(top: el(1)),
            child: _SkeletonLine(
              spec: ElType.small,
              width: el(72),
              height: el(3.5),
            ),
          ),
        ],
      ),
      // `h-10 w-36 rounded-pill`.
      ElSkeleton(width: el(36), height: el(10), radius: ElRadii.pill),
    ],
  );
}

/// A `Skeleton as="span"` inside a paragraph of [spec], which is what keeps the
/// loading row exactly as tall as the resting one.
class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({
    required this.spec,
    required this.width,
    required this.height,
  });

  final ElTypeSpec spec;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => ElRichText(
    TextSpan(
      children: <InlineSpan>[
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: ElSkeleton(width: width, height: height),
        ),
      ],
    ),
    spec,
  );
}

/* ── §5 Sheet ────────────────────────────────────────────────────────────── */

class _SheetSection extends StatelessWidget {
  const _SheetSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'sheet',
    title: 'Sheet',
    description:
        'Slides in from an edge. The filter panel on the '
        'marketplace becomes a sheet below 1200px, and the account panel '
        'uses it on every size.',
    child: ElPanel(
      label: 'Filter sheet',
      child: ElRow(
        children: <Widget>[
          for (final ElSheetSide side in <ElSheetSide>[
            ElSheetSide.left,
            ElSheetSide.right,
          ])
            ElSheetOverlay(
              side: side,
              trigger: (BuildContext context, VoidCallback open) => ElButton(
                variant: ElButtonVariant.outline,
                onPressed: open,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ElIcon(
                      ElIconGlyph.slidersHorizontal,
                      size: ElIconSize.sm,
                    ),
                    const _ButtonGap(),
                    Text('Filters (${side.name})'),
                  ],
                ),
              ),
              content: (BuildContext context, VoidCallback close) =>
                  _FilterSheet(side: side, close: close),
            ),
        ],
      ),
    ),
  );
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.side, required this.close});

  final ElSheetSide side;
  final VoidCallback close;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  /// `defaultValue={[10, 240]} max={500} step={5}`.
  List<double> _price = <double>[10, 240];

  /// Four uncontrolled `Checkbox`es.
  final Set<String> _rarities = <String>{};

  static const List<String> _floor = <String>[
    'Rare',
    'Epic',
    'Legendary',
    'Mythic',
  ];

  @override
  Widget build(BuildContext context) => ElSheetContent(
    side: widget.side,
    onClose: widget.close,
    children: <Widget>[
      const ElSheetHeader(
        children: <Widget>[
          ElSheetTitle('Filter packs'),
          ElSheetDescription('184 packs match your current filters.'),
        ],
      ),
      // `space-y-8 px-4`.
      Padding(
        padding: EdgeInsets.symmetric(horizontal: el(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElText('Price range', ElType.label),
                SizedBox(height: el(4)),
                ElSlider(
                  values: _price,
                  max: 500,
                  step: 5,
                  onChanged: (List<double> v) => setState(() => _price = v),
                ),
              ],
            ),
            SizedBox(height: el(8)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElText('Rarity floor', ElType.label),
                SizedBox(height: el(4)),
                for (int i = 0; i < _floor.length; i++) ...<Widget>[
                  if (i > 0) SizedBox(height: el(3)),
                  _RarityRow(
                    label: _floor[i],
                    checked: _rarities.contains(_floor[i]),
                    onChanged: (bool on) => setState(() {
                      if (on) {
                        _rarities.add(_floor[i]);
                      } else {
                        _rarities.remove(_floor[i]);
                      }
                    }),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
      ElSheetFooter(
        children: <Widget>[
          ElButton(onPressed: () {}, child: const Text('Apply filters')),
          ElButton(
            variant: ElButtonVariant.ghost,
            onPressed: () {},
            child: const Text('Reset'),
          ),
        ],
      ),
    ],
  );
}

/// ```tsx
/// <label className="flex items-center gap-3 type-small text-muted-foreground">
///   <Checkbox /> {r}
/// </label>
/// ```
///
/// A raw `label`, so the words are a target: the same thing the selection
/// page's option cards buy with `htmlFor`.
class _RarityRow extends StatelessWidget {
  const _RarityRow({
    required this.label,
    required this.checked,
    required this.onChanged,
  });

  final String label;
  final bool checked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => onChanged(!checked),
    child: Row(
      children: <Widget>[
        ElCheckbox(
          state: checked ? ElCheckboxState.checked : ElCheckboxState.unchecked,
          onChanged: (ElCheckboxState s) =>
              onChanged(s == ElCheckboxState.checked),
        ),
        SizedBox(width: el(3)),
        ElText(label, ElType.small),
      ],
    ),
  );
}

/* ── §6 Drawer ───────────────────────────────────────────────────────────── */

class _DrawerSection extends StatelessWidget {
  const _DrawerSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'drawer',
    title: 'Drawer',
    description:
        'The mobile bottom sheet. Draggable, and the correct '
        'container for card actions on a phone where a dialog would feel '
        'oversized.',
    child: ElPanel(
      label: 'Bottom drawer',
      child: Align(
        // The reference puts the trigger straight in the panel, with no
        // `Row` around it, so it keeps its own width and starts at the
        // content edge.
        alignment: AlignmentDirectional.centerStart,
        child: ElDrawer(
          trigger: (BuildContext context, VoidCallback open) => ElButton(
            variant: ElButtonVariant.secondary,
            onPressed: open,
            child: const Text('Card actions'),
          ),
          content: (BuildContext context, VoidCallback close) =>
              _CardActionsDrawer(close: close),
        ),
      ),
    ),
  );
}

class _CardActionsDrawer extends StatelessWidget {
  const _CardActionsDrawer({required this.close});

  final VoidCallback close;

  @override
  Widget build(BuildContext context) => ElDrawerContent(
    children: <Widget>[
      const ElDrawerHeader(
        children: <Widget>[
          ElDrawerTitle('Voidwing Ascendant'),
          ElDrawerDescription(
            r'Eclipse Vault · #044 · Legendary · Estimated $1,240.00',
          ),
        ],
      ),
      // `grid gap-2 px-4`.
      Padding(
        padding: EdgeInsets.symmetric(horizontal: el(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElButton(
              variant: ElButtonVariant.premium,
              onPressed: () {},
              child: const Text(r'Sell for $1,240.00'),
            ),
            SizedBox(height: el(2)),
            ElButton(
              variant: ElButtonVariant.secondary,
              onPressed: () {},
              child: const Text('Add to Shipment'),
            ),
            SizedBox(height: el(2)),
            ElButton(
              variant: ElButtonVariant.outline,
              onPressed: () {},
              child: const Text('Inspect Card'),
            ),
          ],
        ),
      ),
      ElDrawerFooter(
        children: <Widget>[
          ElButton(
            variant: ElButtonVariant.ghost,
            onPressed: close,
            child: const Text('Close'),
          ),
        ],
      ),
    ],
  );
}

/* ── §7 Popover ──────────────────────────────────────────────────────────── */

class _PopoverSection extends StatefulWidget {
  const _PopoverSection();

  @override
  State<_PopoverSection> createState() => _PopoverSectionState();
}

class _PopoverSectionState extends State<_PopoverSection> {
  bool _odds = false;
  bool _sort = false;

  /// `w-80` and `w-56`: the two `className` widths, which beat
  /// `PopoverContent`'s own `w-72`.
  static double get _oddsWidth => el(80);
  static double get _sortWidth => el(56);

  /// `sideOffset={4}`.
  static double get _sideOffset => el(1);

  static const List<(String, String)> _odds5 = <(String, String)>[
    ('Common', '68.00%'),
    ('Uncommon', '21.00%'),
    ('Rare', '8.00%'),
    ('Epic', '2.58%'),
    ('Legendary', '0.42%'),
  ];

  static const List<String> _sorts = <String>[
    'Most popular',
    'Newest',
    'Price: low to high',
    'Volatility',
  ];

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'popover',
    title: 'Popover',
    description:
        'Non-modal, anchored to a control. Used for the odds '
        'explainer, quick filters and the notification panel. The page '
        'underneath stays usable.',
    child: ElPanel(
      label: 'Odds explainer',
      child: ElRow(
        children: <Widget>[
          ElPopover(
            open: _odds,
            sideOffset: _sideOffset,
            onDismiss: () => setState(() => _odds = false),
            anchor: ElButton(
              variant: ElButtonVariant.outline,
              size: ElButtonSize.sm,
              onPressed: () => setState(() => _odds = !_odds),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ElIcon(ElIconGlyph.info, size: ElIconSize.sm),
                  SizedBox(width: 6), // allow-hardcoded: `gap-1.5` on `sm`.
                  Text('How odds work'),
                ],
              ),
            ),
            content: (BuildContext context, ElPopoverAnchorMetrics _) =>
                SizedBox(
                  width: _oddsWidth,
                  child: _PopoverPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const _PopoverHeader(
                          title: 'Per-card odds',
                          description:
                              'Every card in a pack is rolled independently.',
                        ),
                        // `mt-4 space-y-2`.
                        Padding(
                          padding: EdgeInsets.only(top: el(4)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              for (
                                int i = 0;
                                i < _odds5.length;
                                i++
                              ) ...<Widget>[
                                if (i > 0) SizedBox(height: el(2)),
                                _OddsRow(
                                  name: _odds5[i].$1,
                                  value: _odds5[i].$2,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
          ElPopover(
            open: _sort,
            sideOffset: _sideOffset,
            onDismiss: () => setState(() => _sort = false),
            anchor: ElButton(
              variant: ElButtonVariant.ghost,
              size: ElButtonSize.sm,
              onPressed: () => setState(() => _sort = !_sort),
              child: const Text('Quick sort'),
            ),
            content: (BuildContext context, ElPopoverAnchorMetrics _) =>
                SizedBox(
                  width: _sortWidth,
                  child: _PopoverPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        for (int i = 0; i < _sorts.length; i++) ...<Widget>[
                          if (i > 0) SizedBox(height: el(1)),
                          ElButton(
                            variant: ElButtonVariant.ghost,
                            size: ElButtonSize.sm,
                            onPressed: () {},
                            child: Align(
                              // `justify-start`.
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(_sorts[i]),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
          ),
        ],
      ),
    ),
  );
}

/// `PopoverContent`: the surface plus its `p-2.5`.
class _PopoverPanel extends StatelessWidget {
  const _PopoverPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => ElPopoverSurface(
    child: Padding(padding: EdgeInsets.all(el(2.5)), child: child),
  );
}

/// `PopoverHeader` + `PopoverTitle` + `PopoverDescription`.
class _PopoverHeader extends StatelessWidget {
  const _PopoverHeader({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ElText(
          title,
          ElComponentType.popoverTitle,
          color: theme.popoverForeground,
        ),
        // `gap-0.5`.
        SizedBox(height: el(0.5)),
        ElText(
          description,
          ElComponentType.sheetBody,
          color: theme.mutedForeground,
        ),
      ],
    );
  }
}

class _OddsRow extends StatelessWidget {
  const _OddsRow({required this.name, required this.value});

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ElText(name, ElType.small, color: theme.mutedForeground),
        ElText(value, ElType.numSm, color: theme.foreground),
      ],
    );
  }
}

/* ── §8 Hover card ───────────────────────────────────────────────────────── */

class _HoverCardSection extends StatelessWidget {
  const _HoverCardSection();

  /// `h-32` on the preview swatch.
  static double get _swatchHeight => el(32);

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'hover-card',
    title: 'Hover Card',
    description:
        'A richer preview on hover, for pointer users only. Used '
        'to preview a card from a live-pull row without leaving the feed. '
        'Never put an action inside one.',
    child: ElPanel(
      label: 'Card preview',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: ElHoverCard(
              trigger: ElButton(
                variant: ElButtonVariant.link,
                onPressed: () {},
                child: const Text('Voidwing Ascendant'),
              ),
              content: _CardPreview(swatchHeight: _swatchHeight),
            ),
          ),
          const _Prose(
            'Because hover does not exist on touch, anything inside a '
            'hover card must also be reachable another way: here, by '
            'opening the card inspection modal.',
          ),
        ],
      ),
    ),
  );
}

class _CardPreview extends StatelessWidget {
  const _CardPreview({required this.swatchHeight});

  final double swatchHeight;

  /// `border-value/30` and `bg-value/12`.
  static const double _swatchBorderAlpha = 0.30;
  static const double _swatchFillAlpha = 0.12;

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // `mb-3 h-32 rounded-md border border-value/30 bg-value/12`.
        Container(
          height: swatchHeight,
          margin: EdgeInsets.only(bottom: el(3)),
          decoration: BoxDecoration(
            color: ElPalette.value.withValues(alpha: _swatchFillAlpha),
            borderRadius: BorderRadius.circular(ElRadii.md),
            border: Border.all(
              color: ElPalette.value.withValues(alpha: _swatchBorderAlpha),
              width: ElWidths.hairline,
            ),
          ),
        ),
        ElText('Voidwing Ascendant', ElType.h4, color: theme.foreground),
        Padding(
          padding: EdgeInsets.only(top: el(1)),
          child: ElText('Eclipse Vault · #044 of 250', ElType.small),
        ),
        // `mt-3 flex items-baseline justify-between border-t border-border
        // pt-3`.
        Container(
          margin: EdgeInsets.only(top: el(3)),
          padding: EdgeInsets.only(top: el(3)),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: theme.border, width: ElWidths.hairline),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElText('Legendary', ElType.label, color: theme.valueInk),
              ElText(r'$1,240.00', ElType.numMd, color: theme.valueInk),
            ],
          ),
        ),
      ],
    );
  }
}

/* ── §9 Tooltip ──────────────────────────────────────────────────────────── */

class _TooltipSection extends StatelessWidget {
  const _TooltipSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'tooltip',
    title: 'Tooltip',
    description:
        'A short label for a control whose purpose is not '
        'obvious. It is not a place for content, and it is never the only '
        'way to learn something.',
    child: ElPanel(
      label: 'Icon-button labels',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ElRow(
            children: <Widget>[
              ElTooltip(
                label: 'Open this pack',
                child: ElButton(
                  variant: ElButtonVariant.ghost,
                  size: ElButtonSize.icon,
                  label: 'Add to favourites',
                  onPressed: () {},
                  child: const ElIcon(
                    ElIconGlyph.packageOpen,
                    size: ElIconSize.md,
                  ),
                ),
              ),
              ElTooltip(
                label: 'Filter and sort',
                child: ElButton(
                  variant: ElButtonVariant.ghost,
                  size: ElButtonSize.icon,
                  label: 'Filters',
                  onPressed: () {},
                  child: const ElIcon(
                    ElIconGlyph.slidersHorizontal,
                    size: ElIconSize.md,
                  ),
                ),
              ),
              const ElTooltip(
                label: '412 packs remaining of a 2,000 print run',
                child: _DashedCount(),
              ),
            ],
          ),
          const _Prose(
            'Opens after 200ms, set once on the provider in the root '
            'layout so timing cannot vary between screens.',
          ),
        ],
      ),
    ),
  );
}

/// `<span className="type-num-sm cursor-help border-b border-dashed
/// border-input text-muted-foreground">`: the one tooltip trigger on the page
/// that is not a button.
///
/// The dashed underline is **not** ported as a dash pattern: Flutter's
/// [TextDecoration.underline] with [TextDecorationStyle.dashed] is the same
/// declaration, and it is the border that the reference draws rather than a
/// text decoration. Both land as a dashed rule under the digits at the same
/// colour; the difference is a fraction of a pixel of offset, recorded.
class _DashedCount extends StatelessWidget {
  const _DashedCount();

  @override
  Widget build(BuildContext context) {
    final ElThemeData theme = ElTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.input, width: ElWidths.hairline),
        ),
      ),
      child: ElText('412 / 2,000', ElType.numSm, color: theme.mutedForeground),
    );
  }
}

/* ── §10 API ─────────────────────────────────────────────────────────────── */

class _ApiSection extends StatelessWidget {
  const _ApiSection();

  @override
  Widget build(BuildContext context) => const ElSection(
    id: 'api',
    title: 'API',
    child: ElMeta(
      items: <ElMetaItem>[
        (
          k: 'Dialog',
          v: TextSpan(
            text:
                'Dialog + DialogTrigger asChild + DialogContent + '
                'DialogHeader/Title/Description + DialogFooter. Set '
                'DialogContent variant="media" and add DialogMedia for an '
                'image-led announcement.',
          ),
        ),
        (
          k: 'AlertDialog',
          v: TextSpan(
            text:
                'Same shape, but AlertDialogCancel and AlertDialogAction '
                'instead of a footer of buttons. Not dismissible by '
                'overlay click. AlertDialogAction is destructive by '
                'default: that is what the component is for.',
          ),
        ),
        (
          k: 'Sheet',
          v: TextSpan(text: 'side="top" | "right" | "bottom" | "left".'),
        ),
        (
          k: 'Drawer',
          v: TextSpan(text: 'Bottom sheet with drag-to-dismiss. Mobile-first.'),
        ),
        (
          k: 'Popover',
          v: TextSpan(
            text:
                'Non-modal. align and side control placement. Set an '
                'explicit width on the content.',
          ),
        ),
        (
          k: 'Tooltip',
          v: TextSpan(
            text:
                'TooltipProvider lives in app/layout.tsx with '
                'delayDuration 200. Content must be a short label.',
          ),
        ),
      ],
    ),
  );
}

/* ── §11 Rules ───────────────────────────────────────────────────────────── */

class _RulesSection extends StatelessWidget {
  const _RulesSection();

  @override
  Widget build(BuildContext context) => ElSection(
    id: 'rules',
    title: 'Rules',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ElDoDont(
          dos: <String>[
            'Use Alert Dialog for anything irreversible: selling, '
                'deleting, closing an account.',
            'Let the confirming button stay destructive; it is the default '
                'for a reason.',
            'Write the consequence into the confirming button, including '
                'the amount.',
            "Phrase the cancel option as the safe choice: 'Keep my cards'.",
            'Give every overlay a title and a description; both are '
                'announced on open.',
            'Use the media Dialog variant for announcements, editorial '
                'news and promotions with a meaningful image.',
            'Collect irreversible settings actions into one bordered '
                'danger zone, away from everything reversible.',
            'Leave a visible trace on the page after a destructive action; '
                'a toast is gone in four seconds.',
            'Keep tooltips to a few words and put the real explanation in '
                'a popover.',
          ],
          donts: <String>[
            "Don't put a form inside a tooltip or hover card.",
            "Don't allow overlay-click dismissal on a destructive "
                'confirmation.',
            "Don't stack a dialog on top of another dialog.",
            "Don't use the media variant for destructive confirmation; the "
                'image competes with the consequence.',
            "Don't make hover the only way to reach information: touch "
                'users have no hover.',
            "Don't use a Sheet where a Popover would do; sheets cover the "
                'page.',
            "Don't fill a danger zone with red: a tinted block reads as "
                'an error that already happened.',
            "Don't ship the destructive button without its failure path; "
                'that is the one users hit on their worst day.',
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: el(4)),
          child: const ElNote(child: _MotionNoteBody()),
        ),
      ],
    ),
  );
}

/// The Rules note, with its five code chips.
class _MotionNoteBody extends StatelessWidget {
  const _MotionNoteBody();

  @override
  Widget build(BuildContext context) => ElRichText(
    TextSpan(
      children: <InlineSpan>[
        const TextSpan(
          text: 'Modal overlays, Dialog, Alert Dialog: arrive on ',
        ),
        ElCode.span('anim-jelly-in'),
        TextSpan(text: ' ('),
        ElCode.span('--duration-jelly'),
        TextSpan(text: ', 420ms on '),
        ElCode.span('--ease-spring'),
        TextSpan(text: ') and leave on '),
        ElCode.span('anim-jelly-out'),
        TextSpan(text: ' at '),
        ElCode.span('--duration-base'),
        TextSpan(
          text:
              '. Leaving is deliberately faster than arriving. Anchored '
              'and edge overlays, Popover, Tooltip, Sheet, Drawer: keep '
              'their own fade or slide on ',
        ),
        ElCode.span('--duration-overlay'),
        TextSpan(text: ' (320ms). Never override either per-instance.'),
      ],
    ),
    ElType.small,
  );
}
