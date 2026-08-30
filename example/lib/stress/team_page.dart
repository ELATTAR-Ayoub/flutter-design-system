/// Team access management.
///
/// A member list with a role control per row, an invite dialog, and a
/// destructive remove confirmation. Both overlays trap focus, close on Escape,
/// and return focus to the control that opened them, which the design system's
/// [Dialog] does not do on its own.
library;

import 'package:elattar_design_system/elattar_design_system.dart';
import 'package:flutter/widgets.dart'
    hide
        AspectRatio,
        Form,
        FormField,
        Icon,
        OverlayPortal,
        RichText,
        SafeArea,
        ScrollPosition,
        Table,
        TableColumnWidth;

import 'stress_error.dart';
import 'stress_feedback.dart';
import 'stress_repository.dart';
import 'stress_state.dart';
import 'stress_ui.dart';

enum MemberFilter { everyone, admins, pending }

extension on MemberFilter {
  String get label => switch (this) {
    MemberFilter.everyone => 'Everyone',
    MemberFilter.admins => 'Admins and owners',
    MemberFilter.pending => 'Pending invites',
  };

  bool get isActive => this != MemberFilter.everyone;
}

extension MemberRolePresentation on MemberRole {
  String get label => switch (this) {
    MemberRole.owner => 'Owner',
    MemberRole.admin => 'Admin',
    MemberRole.editor => 'Editor',
    MemberRole.viewer => 'Viewer',
  };

  /// The owner's role is fixed: there is exactly one, and demoting it from a
  /// row would strand the account.
  bool get isFixed => this == MemberRole.owner;
}

extension MemberStatusPresentation on MemberStatus {
  String get label => switch (this) {
    MemberStatus.active => 'Active',
    MemberStatus.invited => 'Invited',
    MemberStatus.suspended => 'Suspended',
  };

  /// Word plus glyph, so the state survives a monochrome or color-blind read.
  IconGlyph get glyph => switch (this) {
    MemberStatus.active => IconGlyph.circleCheck,
    MemberStatus.invited => IconGlyph.clock,
    MemberStatus.suspended => IconGlyph.ban,
  };

  BadgeVariant get variant => switch (this) {
    MemberStatus.active => BadgeVariant.secondary,
    MemberStatus.invited => BadgeVariant.outline,
    MemberStatus.suspended => BadgeVariant.destructive,
  };
}

class TeamPage extends StatefulWidget {
  const TeamPage({super.key, required this.repository});

  final StressRepository repository;

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  UiState<List<Member>> _members = const UiState<List<Member>>.idle();
  MemberFilter _filter = MemberFilter.everyone;
  String? _selectedId;

  /// Optimistic role changes, keyed by member. Small, reversible, and rolled
  /// back on failure.
  final Map<String, MemberRole> _roleOverrides = <String, MemberRole>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool refresh = false}) async {
    final List<Member>? current = _members.dataOrNull;
    setState(() {
      _members = refresh && current != null
          ? UiState<List<Member>>.refreshing(current)
          : const UiState<List<Member>>.loading();
    });
    try {
      final List<Member> all = await widget.repository.members(
        filtered: false,
      );
      final List<Member> shown = all.where(_matchesFilter).toList();
      if (!mounted) return;
      setState(
        () => _members = all.isEmpty
            ? const UiState<List<Member>>.empty()
            : collectionState<Member>(shown, filtered: _filter.isActive),
      );
      announce(context, '${shown.length} team members');
    } on Object catch (error) {
      if (!mounted) return;
      setState(
        () => _members = UiState<List<Member>>.failed(
          AppError.from(error),
          stale: current,
        ),
      );
    }
  }

  bool _matchesFilter(Member member) => switch (_filter) {
    MemberFilter.everyone => true,
    MemberFilter.admins =>
      member.role == MemberRole.admin || member.role == MemberRole.owner,
    MemberFilter.pending => member.status == MemberStatus.invited,
  };

  MemberRole _roleOf(Member member) =>
      _roleOverrides[member.id] ?? member.role;

  /// Optimistic: the control answers immediately and rolls back if the write
  /// fails. Legitimate here because a role change is small and reversible.
  Future<void> _changeRole(Member member, MemberRole next) async {
    final MemberRole previous = _roleOf(member);
    if (next == previous) return;
    setState(() => _roleOverrides[member.id] = next);
    try {
      await widget.repository.removeMember(member.id); // same scripted route
      if (!mounted) return;
      announce(context, '${member.name} is now ${next.label}');
      StressFeedback.of(context).success(
        '${member.name} is now ${next.label}',
        action: ToastAction(
          label: 'Undo',
          onPressed: () => setState(
            () => _roleOverrides[member.id] = previous,
          ),
        ),
      );
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _roleOverrides[member.id] = previous);
      StressFeedback.reportError(
        context,
        AppError.from(error),
        onRetry: () => _changeRole(member, next),
      );
    }
  }

  Future<void> _remove(Member member) async {
    try {
      await widget.repository.removeMember(member.id);
      if (!mounted) return;
      announce(context, '${member.name} removed');
      StressFeedback.of(context).success('${member.name} removed');
      await _load(refresh: true);
    } on Object catch (error) {
      if (!mounted) return;
      StressFeedback.reportError(context, AppError.from(error));
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final bool wide = constraints.maxWidth >= Breakpoints.lg;
      final List<Member> shown = _members.dataOrNull ?? const <Member>[];
      final Member? selected = shown
          .where((Member m) => m.id == _selectedId)
          .firstOrNull;

      final Widget header = _Header(
        wide: wide,
        filter: _filter,
        enabled: _members is! UiLoading<List<Member>>,
        onFilterChanged: (MemberFilter next) {
          setState(() => _filter = next);
          _load(refresh: true);
        },
        onInvited: () => _load(refresh: true),
        repository: widget.repository,
      );

      final Widget list = _MembersRegion(
        state: _members,
        filter: _filter,
        wide: wide,
        roleOf: _roleOf,
        selectedId: _selectedId,
        onSelect: (Member member) => setState(() => _selectedId = member.id),
        onRoleChanged: _changeRole,
        onRemove: _remove,
        onRetry: () => _load(refresh: true),
        onClearFilter: () {
          setState(() => _filter = MemberFilter.everyone);
          _load(refresh: true);
        },
      );

      final EdgeInsets gutter = EdgeInsets.symmetric(
        horizontal: space(wide ? 6 : 4),
      );

      // Narrow scrolls the whole page, header included. A header that cannot
      // fit the viewport at 200 percent text must not squeeze the content to a
      // negative height, which is what a pinned header plus Expanded does.
      if (!wide) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: gutter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  header,
                  list,
                  SizedBox(height: space(10)),
                ],
              ),
            ),
          ),
        );
      }

      return SafeArea(
        child: Padding(
          padding: gutter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              header,
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      // Not ScrollArea: its IntrinsicWidth lets wide content
                      // size past the viewport and puts the right-hand
                      // controls out of reach.
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            list,
                            SizedBox(height: space(10)),
                          ],
                        ),
                      ),
                    ),
                    // The detail sits beside the list here. Narrow opens it as
                    // a sheet from the row instead.
                    if (selected != null) ...<Widget>[
                      SizedBox(width: space(6)),
                      SizedBox(
                        width: LayoutWidths.sidebar,
                        child: _MemberDetail(
                          member: selected,
                          role: _roleOf(selected),
                          onClose: () => setState(() => _selectedId = null),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _Header extends StatelessWidget {
  const _Header({
    required this.wide,
    required this.filter,
    required this.enabled,
    required this.onFilterChanged,
    required this.onInvited,
    required this.repository,
  });

  final bool wide;
  final MemberFilter filter;
  final bool enabled;
  final ValueChanged<MemberFilter> onFilterChanged;
  final VoidCallback onInvited;
  final StressRepository repository;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: space(5)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Title and action share a line only while there is room for both.
        // At 200 percent text on a phone there is not, so they stack.
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: space(4),
          runSpacing: space(3),
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Containers.xl2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  StyledText('Team access', TextStyles.h2),
                  StyledText(
                    'Who can reach this workspace, and what they can do.',
                    TextStyles.small,
                  ),
                ],
              ),
            ),
            InviteMemberAction(
              repository: repository,
              onInvited: onInvited,
              compact: !wide,
            ),
          ],
        ),
        SizedBox(height: space(4)),
        Align(
          alignment: Alignment.centerLeft,
          child: Select<MemberFilter>(
            value: filter,
            enabled: enabled,
            label: 'Filter team members',
            options: <SelectChild<MemberFilter>>[
              for (final MemberFilter option in MemberFilter.values)
                SelectOption<MemberFilter>(
                  value: option,
                  label: option.label,
                ),
            ],
            onChanged: (MemberFilter? next) {
              if (next != null) onFilterChanged(next);
            },
          ),
        ),
      ],
    ),
  );
}

/* ── The list ────────────────────────────────────────────────────────────── */

class _MembersRegion extends StatelessWidget {
  const _MembersRegion({
    required this.state,
    required this.filter,
    required this.wide,
    required this.roleOf,
    required this.selectedId,
    required this.onSelect,
    required this.onRoleChanged,
    required this.onRemove,
    required this.onRetry,
    required this.onClearFilter,
  });

  final UiState<List<Member>> state;
  final MemberFilter filter;
  final bool wide;
  final MemberRole Function(Member) roleOf;
  final String? selectedId;
  final ValueChanged<Member> onSelect;
  final void Function(Member, MemberRole) onRoleChanged;
  final ValueChanged<Member> onRemove;
  final VoidCallback onRetry;
  final VoidCallback onClearFilter;

  @override
  Widget build(BuildContext context) => Card(
    children: <Widget>[
      const CardHeader(
        title: CardTitle('Members'),
        description: CardDescription('Roles apply to every project.'),
      ),
      CardContent(child: _body(context)),
    ],
  );

  Widget _body(BuildContext context) => switch (state) {
    UiIdle<List<Member>>() || UiLoading<List<Member>>() =>
      const RegionSkeleton(),

    UiRefreshing<List<Member>>(:final List<Member> data) => _rows(
      context,
      data,
      refreshing: true,
    ),

    UiReady<List<Member>>(:final List<Member> data) => _rows(context, data),

    UiEmpty<List<Member>>() => RegionEmpty(
      glyph: IconGlyph.user,
      title: 'You are the only person here',
      description: 'Invite someone to share this workspace with them.',
      actionLabel: 'Invite member',
      onAction: onRetry,
    ),

    UiNoResults<List<Member>>() => RegionEmpty(
      glyph: IconGlyph.search,
      title: 'Nobody matches this filter',
      description: 'No member on this team has that role or status.',
      actionLabel: 'Show everyone',
      actionVariant: ButtonVariant.outline,
      onAction: onClearFilter,
    ),

    UiFailed<List<Member>>(:final AppError error, :final List<Member>? stale) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RegionFailure(error: error, onRetry: onRetry),
          if (stale != null && stale.isNotEmpty) ...<Widget>[
            SizedBox(height: space(4)),
            _rows(context, stale),
          ],
        ],
      ),
  };

  Widget _rows(
    BuildContext context,
    List<Member> members, {
    bool refreshing = false,
  }) {
    final int pending = members
        .where((Member m) => m.status == MemberStatus.invited)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (refreshing)
          Padding(
            padding: EdgeInsets.only(bottom: space(3)),
            child: Row(
              children: <Widget>[
                Spinner(size: space(4)),
                SizedBox(width: space(2)),
                StyledText('Updating members', TextStyles.caption),
              ],
            ),
          ),
        // Pending invites are their own condition, not an empty team and not
        // an error.
        if (pending > 0 && filter != MemberFilter.pending)
          Padding(
            padding: EdgeInsets.only(bottom: space(4)),
            child: Alert(
              variant: AlertVariant.info,
              icon: const Icon(IconGlyph.clock),
              title: pending == 1
                  ? '1 invite is still pending'
                  : '$pending invites are still pending',
              description:
                  'They join the team once they accept the email invitation.',
            ),
          ),
        for (final Member member in members)
          Padding(
            padding: EdgeInsets.only(bottom: space(2)),
            child: _MemberRow(
              member: member,
              role: roleOf(member),
              wide: wide,
              selected: member.id == selectedId,
              onSelect: () => onSelect(member),
              onRoleChanged: (MemberRole next) => onRoleChanged(member, next),
              onRemove: () => onRemove(member),
            ),
          ),
      ],
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({
    required this.member,
    required this.role,
    required this.wide,
    required this.selected,
    required this.onSelect,
    required this.onRoleChanged,
    required this.onRemove,
  });

  final Member member;
  final MemberRole role;
  final bool wide;
  final bool selected;
  final VoidCallback onSelect;
  final ValueChanged<MemberRole> onRoleChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final Widget identity = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Avatar(fallback: member.initials),
        SizedBox(width: space(3)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StyledText(
                member.name,
                TextStyles.itemTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // A long address truncates rather than widening the row past
              // the viewport.
              StyledText(
                member.email,
                TextStyles.itemDescription,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );

    final Widget status = Badge(
      label: member.status.label,
      glyph: Icon(member.status.glyph, size: IconSize.xs),
      variant: member.status.variant,
    );

    final Widget roleControl = role.isFixed
        ? Tooltip(
            label: 'An owner cannot be demoted from this list.',
            child: Badge(label: role.label, variant: BadgeVariant.secondary),
          )
        : Select<MemberRole>(
            value: role,
            label: 'Role for ${member.name}',
            options: <SelectChild<MemberRole>>[
              for (final MemberRole option in MemberRole.values)
                SelectOption<MemberRole>(
                  value: option,
                  label: option.label,
                  enabled: option != MemberRole.owner,
                ),
            ],
            onChanged: (MemberRole? next) {
              if (next != null) onRoleChanged(next);
            },
          );

    final Widget remove = RemoveMemberAction(
      member: member,
      onConfirmed: onRemove,
    );

    if (wide) {
      return Item(
        variant: selected ? ItemVariant.outline : ItemVariant.normal,
        content: ItemContent(children: <Widget>[identity]),
        actions: ItemActions(
          children: <Widget>[
            status,
            SizedBox(width: space(3)),
            roleControl,
            SizedBox(width: space(2)),
            Button(
              variant: ButtonVariant.ghost,
              size: ButtonSize.sm,
              onPressed: onSelect,
              label: 'Open details for ${member.name}',
              child: const Icon(IconGlyph.chevronRight, size: IconSize.sm),
            ),
            remove,
          ],
        ),
      );
    }

    // Narrow: everything stacks, and the detail is a sheet reached from one
    // control rather than a side panel that has nowhere to sit.
    return Card(
      children: <Widget>[
        CardContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              identity,
              SizedBox(height: space(3)),
              // At 200 percent text the badge and the role control cannot
              // share a line on a phone, so they wrap instead of overflowing.
              Wrap(
                spacing: space(2),
                runSpacing: space(2),
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[status, roleControl],
              ),
              SizedBox(height: space(3)),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _MemberDetailSheet(
                      member: member,
                      role: role,
                    ),
                  ),
                  SizedBox(width: space(2)),
                  remove,
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/* ── Detail ──────────────────────────────────────────────────────────────── */

class _MemberDetail extends StatelessWidget {
  const _MemberDetail({
    required this.member,
    required this.role,
    this.onClose,
  });

  final Member member;
  final MemberRole role;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) => Card(
    children: <Widget>[
      CardHeader(
        title: CardTitle(member.name),
        description: const CardDescription('Access details'),
        action: onClose == null
            ? null
            : Button(
                variant: ButtonVariant.ghost,
                size: ButtonSize.sm,
                onPressed: onClose,
                label: 'Close details',
                child: const Icon(IconGlyph.x, size: IconSize.sm),
              ),
      ),
      CardContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _DetailRow(label: 'Email', value: member.email),
            _DetailRow(label: 'Role', value: role.label),
            _DetailRow(label: 'Status', value: member.status.label),
            _DetailRow(label: 'Last active', value: member.lastActive),
          ],
        ),
      ),
    ],
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: space(3)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StyledText(label, TextStyles.caption),
        StyledText(value, TextStyles.body, softWrap: true),
      ],
    ),
  );
}

/// The narrow detail: one control that opens a sheet, and returns focus to
/// itself when the sheet closes.
class _MemberDetailSheet extends StatefulWidget {
  const _MemberDetailSheet({required this.member, required this.role});

  final Member member;
  final MemberRole role;

  @override
  State<_MemberDetailSheet> createState() => _MemberDetailSheetState();
}

class _MemberDetailSheetState extends State<_MemberDetailSheet> {
  final FocusNode _trigger = FocusNode(debugLabel: 'member detail trigger');

  @override
  void dispose() {
    _trigger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SheetOverlay(
    side: SheetSide.bottom,
    trigger: (BuildContext context, VoidCallback open) => Button(
      variant: ButtonVariant.outline,
      expanded: true,
      focusNode: _trigger,
      onPressed: open,
      child: StyledText('Details', TextStyles.buttonLabel),
    ),
    content: (BuildContext context, VoidCallback close) => SheetContent(
      side: SheetSide.bottom,
      onClose: () {
        close();
        // Focus restoration is ours to do: the overlay traps focus but does
        // not hand it back.
        _trigger.requestFocus();
      },
      children: <Widget>[
        SheetHeader(
          children: <Widget>[
            SheetTitle(widget.member.name),
            const SheetDescription('Access details'),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(space(4)),
          child: _MemberDetail(member: widget.member, role: widget.role),
        ),
      ],
    ),
  );
}

/* ── Invite ──────────────────────────────────────────────────────────────── */

/// The invite dialog: a visibly labelled field, per-field validation, and
/// submitting, success and failure states.
class InviteMemberAction extends StatefulWidget {
  const InviteMemberAction({
    super.key,
    required this.repository,
    required this.onInvited,
    this.compact = false,
  });

  final StressRepository repository;
  final VoidCallback onInvited;
  final bool compact;

  @override
  State<InviteMemberAction> createState() => _InviteMemberActionState();
}

class _InviteMemberActionState extends State<InviteMemberAction> {
  final FocusNode _trigger = FocusNode(debugLabel: 'invite trigger');
  final TextEditingController _email = TextEditingController();
  SubmitState _submit = SubmitState.idle;
  String? _emailError;
  AppError? _formError;

  @override
  void dispose() {
    _trigger.dispose();
    _email.dispose();
    super.dispose();
  }

  void _reset() {
    _email.clear();
    setState(() {
      _submit = SubmitState.idle;
      _emailError = null;
      _formError = null;
    });
  }

  Future<void> _send(VoidCallback close) async {
    if (!_submit.canSubmit) return;
    setState(() {
      _submit = SubmitState.submitting;
      _emailError = null;
      _formError = null;
    });
    try {
      await widget.repository.invite(_email.text);
      if (!mounted) return;
      setState(() => _submit = SubmitState.succeeded);
      announce(context, 'Invitation sent to ${_email.text}');
      StressFeedback.of(context).success('Invitation sent');
      close();
      _trigger.requestFocus();
      _reset();
      widget.onInvited();
    } on Object catch (error) {
      if (!mounted) return;
      final AppError failure = AppError.from(error);
      setState(() {
        _submit = SubmitState.failed;
        // Validation lands on the field. Everything else is a form level
        // message, because it is not the user's typing that is wrong.
        _emailError = failure.fieldErrors['email'];
        _formError = failure.kind == ErrorKind.validation ? null : failure;
      });
      announce(context, failure.title);
    }
  }

  @override
  Widget build(BuildContext context) => Dialog(
    trigger: (BuildContext context, VoidCallback open) => Button(
      focusNode: _trigger,
      size: widget.compact ? ButtonSize.sm : ButtonSize.md,
      onPressed: open,
      child: StyledText('Invite member', TextStyles.buttonLabel),
    ),
    content: (BuildContext context, VoidCallback close) => DialogContent(
      onClose: () {
        close();
        _trigger.requestFocus();
        _reset();
      },
      children: <Widget>[
        const DialogHeader(
          children: <Widget>[
            DialogTitle('Invite a member'),
            DialogDescription(
              'They receive an email and pick their own password.',
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: space(6),
            vertical: space(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ?switch (_formError) {
                final AppError error => Padding(
                  padding: EdgeInsets.only(bottom: space(4)),
                  child: RegionFailure(error: error),
                ),
                _ => null,
              },
              Field(
                label: 'Work email',
                description: 'They will sign in with this address.',
                errors: <String>[?_emailError],
                child: Input(
                  controller: _email,
                  placeholder: 'name@company.com',
                  enabled: !_submit.isBusy,
                  invalid: _emailError != null,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const <String>[AutofillHints.email],
                  onSubmitted: (_) => _send(close),
                ),
              ),
            ],
          ),
        ),
        DialogFooter(
          children: <Widget>[
            Button(
              variant: ButtonVariant.ghost,
              onPressed: _submit.isBusy
                  ? null
                  : () {
                      close();
                      _trigger.requestFocus();
                      _reset();
                    },
              child: StyledText('Cancel', TextStyles.buttonLabel),
            ),
            Button(
              loading: _submit.isBusy,
              onPressed: _submit.canSubmit ? () => _send(close) : null,
              child: StyledText('Send invitation', TextStyles.buttonLabel),
            ),
          ],
        ),
      ],
    ),
  );
}

/* ── Remove ──────────────────────────────────────────────────────────────── */

/// Destructive work confirms first, and the confirmation names the person and
/// the consequence rather than asking "Are you sure?".
class RemoveMemberAction extends StatefulWidget {
  const RemoveMemberAction({
    super.key,
    required this.member,
    required this.onConfirmed,
  });

  final Member member;
  final VoidCallback onConfirmed;

  @override
  State<RemoveMemberAction> createState() => _RemoveMemberActionState();
}

class _RemoveMemberActionState extends State<RemoveMemberAction> {
  final FocusNode _trigger = FocusNode(debugLabel: 'remove trigger');

  @override
  void dispose() {
    _trigger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    trigger: (BuildContext context, VoidCallback open) => Button(
      variant: ButtonVariant.ghost,
      size: ButtonSize.sm,
      focusNode: _trigger,
      onPressed: widget.member.role.isFixed ? null : open,
      label: 'Remove ${widget.member.name}',
      child: const Icon(IconGlyph.trash2, size: IconSize.sm),
    ),
    content: (BuildContext context, VoidCallback close) => AlertDialogContent(
      header: AlertDialogHeader(
        title: AlertDialogTitle('Remove ${widget.member.name}?'),
        description: const AlertDialogDescription(
          'They lose access to this workspace immediately. '
          'Their work stays where it is, and you can invite them again.',
        ),
      ),
      footer: AlertDialogFooter(
        // Cancel is the safe default, and it is the one the overlay focuses.
        cancel: AlertDialogCancel(
          label: 'Cancel',
          onPressed: () {
            close();
            _trigger.requestFocus();
          },
        ),
        // The verb, not "OK": the button has to be enough on its own.
        action: AlertDialogAction(
          label: 'Remove member',
          onPressed: () {
            close();
            _trigger.requestFocus();
            widget.onConfirmed();
          },
        ),
      ),
    ),
  );
}
