/// Signal Studio's performance dashboard.
library;

import 'dart:async';

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
import 'showcase_feedback.dart';
import 'showcase_shell_scope.dart';

class ShowcaseDashboard extends StatefulWidget {
  const ShowcaseDashboard({super.key});

  @override
  State<ShowcaseDashboard> createState() => _ShowcaseDashboardState();
}

class _ShowcaseDashboardState extends State<ShowcaseDashboard> {
  bool _loading = true;
  bool _failed = false;
  bool _hasLoaded = false;
  int _reloads = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _load() {
    _timer?.cancel();
    setState(() {
      _loading = true;
      _failed = false;
    });
    _timer = Timer(MotionDurations.fast, () {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _reloads++;
      });
      if (_hasLoaded) {
        ShowcaseFeedback.of(context).success(
          'Studio data is current',
          description: 'Your latest creator signals are ready.',
        );
      }
      _hasLoaded = true;
    });
  }

  void _showUnavailable() {
    _timer?.cancel();
    setState(() {
      _loading = false;
      _failed = true;
    });
    ShowcaseFeedback.of(context).error(
      'Signal refresh paused',
      description: 'Retry when the connection is ready.',
      action: ToastAction(label: 'Retry', onPressed: _load),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(space(5), space(2), space(5), 0),
    child: Semantics(
      label: 'Signal Studio dashboard',
      child: _loading
          ? const _DashboardSkeleton()
          : _failed
          ? _DashboardFailure(onRetry: _load)
          : ContentChange(
              replayKey: _reloads,
              child: _DashboardContent(
                onRefresh: _load,
                onShowUnavailable: _showUnavailable,
              ),
            ),
    ),
  );
}

class _DashboardContent extends StatefulWidget {
  const _DashboardContent({
    required this.onRefresh,
    required this.onShowUnavailable,
  });

  final VoidCallback onRefresh;
  final VoidCallback onShowUnavailable;

  @override
  State<_DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<_DashboardContent> {
  static const List<SelectOption<String>> _ranges = <SelectOption<String>>[
    SelectOption<String>(value: '7d', label: 'Last 7 days'),
    SelectOption<String>(value: '30d', label: 'Last 30 days'),
    SelectOption<String>(value: '90d', label: 'Last 3 months'),
  ];

  String _range = '7d';
  final Set<String> _scheduled = <String>{};

  String get _rangeLabel => switch (_range) {
    '30d' => 'Last 30 days',
    '90d' => 'Last 3 months',
    _ => 'Last 7 days',
  };

  String get _qualifiedPlays => switch (_range) {
    '30d' => '318.6K',
    '90d' => '914.2K',
    _ => '82.4K',
  };

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    key: const Key('dashboard-scroll'),
    padding: SafeArea.scrollPaddingOf(
      context,
      base: EdgeInsets.only(
        bottom: space(5) + ShowcaseShellScope.bottomOverlayClearanceOf(context),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Select<String>(
            width: space(40),
            label: 'Dashboard range',
            value: _range,
            onChanged: (String value) => setState(() => _range = value),
            options: _ranges,
          ),
        ),
        SizedBox(height: space(4)),
        _DashboardHero(
          onRefresh: widget.onRefresh,
          rangeLabel: _rangeLabel,
          qualifiedPlays: _qualifiedPlays,
        ),
        SizedBox(height: space(5)),
        _MetricsStrip(range: _range),
        SizedBox(height: space(5)),
        _MomentumFocus(rangeLabel: _rangeLabel),
        SizedBox(height: space(5)),
        Grid(
          lg: 2,
          gap: space(5),
          children: <Widget>[
            _ContentQueue(
              scheduled: _scheduled,
              onSchedule: (String id) => setState(() {
                if (!_scheduled.add(id)) _scheduled.remove(id);
              }),
            ),
            _StudioPulse(onShowUnavailable: widget.onShowUnavailable),
          ],
        ),
        SizedBox(height: space(5)),
        const _AudienceInsight(),
        SizedBox(height: space(5)),
        const _RecentActivity(),
        SizedBox(height: space(5)),
        const Alert(
          key: Key('dashboard-scroll-end'),
          title: 'Plan the next cut around the strongest signal.',
          description:
              'Behind-the-scenes retention is rising before the final reveal.',
          variant: AlertVariant.info,
          icon: Icon.lucide(Lucide.sparkles, tone: IconTone.inherit),
        ),
      ],
    ),
  );
}

class _DashboardHero extends StatelessWidget {
  const _DashboardHero({
    required this.onRefresh,
    required this.rangeLabel,
    required this.qualifiedPlays,
  });

  final VoidCallback onRefresh;
  final String rangeLabel;
  final String qualifiedPlays;

  @override
  Widget build(BuildContext context) => Glass(
    variant: GlassVariant.prominent,
    key: const Key('dashboard-hero-surface'),
    radius: BorderRadius.circular(Radii.xl3),
    padding: EdgeInsets.all(space(5)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StyledText('This week in motion', TextStyles.small),
                  SizedBox(height: space(1)),
                  StyledText(
                    'One clear read on what your audience carried forward.',
                    TextStyles.small,
                  ),
                ],
              ),
            ),
            Button(
              variant: ButtonVariant.primary,
              size: ButtonSize.sm,
              label: 'Refresh dashboard',
              onPressed: onRefresh,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon.lucide(Lucide.refreshCw, size: IconSize.sm),
                  SizedBox(width: Button.gapFor(ButtonSize.sm)),
                  StyledText('Refresh', TextStyles.nav),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: space(6)),
        StyledText(qualifiedPlays, TextStyles.numberXl),
        SizedBox(height: space(2)),
        StyledText(
          'TOTAL QUALIFIED PLAYS · ${rangeLabel.toUpperCase()}',
          TextStyles.small,
        ),
        SizedBox(height: space(3)),
        const Badge(
          label: '+18.6% week over week',
          variant: BadgeVariant.success,
          glyph: Icon.lucide(Lucide.trendingUp),
        ),
      ],
    ),
  );
}

class _MetricsStrip extends StatelessWidget {
  const _MetricsStrip({required this.range});

  final String range;

  @override
  Widget build(BuildContext context) {
    final bool extended = range != '7d';
    return Grid(
      sm: 2,
      xl: 4,
      gap: space(4),
      children: <Widget>[
        Stat(
          label: 'Saves',
          value: extended ? '24,610' : '6,820',
          delta: const (value: '14.2%', direction: StatDirection.up),
          hint: 'vs last week',
        ),
        Stat(
          label: 'Shares',
          value: extended ? '8,972' : '2,146',
          delta: const (value: '8.1%', direction: StatDirection.up),
          hint: 'vs last week',
        ),
        const Stat(
          label: 'Completion',
          value: '71.8%',
          delta: (value: '4.4%', direction: StatDirection.up),
          hint: 'vs last week',
        ),
        Stat(
          label: 'New followers',
          value: extended ? '5,408' : '1,284',
          delta: const (value: '2.6%', direction: StatDirection.up),
          hint: 'vs last week',
        ),
      ],
    );
  }
}

class _MomentumFocus extends StatelessWidget {
  const _MomentumFocus({required this.rangeLabel});

  final String rangeLabel;

  static const List<Map<String, Object?>> _data = <Map<String, Object?>>[
    <String, Object?>{'day': 'Mon', 'plays': 48},
    <String, Object?>{'day': 'Tue', 'plays': 63},
    <String, Object?>{'day': 'Wed', 'plays': 57},
    <String, Object?>{'day': 'Thu', 'plays': 79},
    <String, Object?>{'day': 'Fri', 'plays': 88},
    <String, Object?>{'day': 'Sat', 'plays': 96},
    <String, Object?>{'day': 'Sun', 'plays': 82},
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeTokens theme = ThemeScope.of(context);
    return Glass(
      variant: GlassVariant.panel,
      key: const Key('dashboard-chart-focus'),
      radius: BorderRadius.circular(Radii.xl),
      padding: EdgeInsets.all(space(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StyledText('Momentum', TextStyles.small),
          SizedBox(height: space(1)),
          StyledText('Qualified plays · $rangeLabel.', TextStyles.small),
          SizedBox(height: space(4)),
          ChartContainer(
            height: space(52),
            config: ChartConfig(<String, ChartSeries>{
              'plays': ChartSeries(
                label: 'Qualified plays',
                color: theme.chart1,
              ),
            }),
            child: CartesianChart(
              data: _data,
              grid: const ChartGrid(vertical: false),
              xAxis: const ChartAxis(
                dataKey: 'day',
                tickLine: false,
                axisLine: false,
              ),
              tooltip: const ChartTooltipSpec(
                cursor: false,
                indicator: ChartIndicator.line,
              ),
              series: <ChartSeriesSpec>[
                ChartSeriesSpec(
                  kind: ChartSeriesKind.line,
                  dataKey: 'plays',
                  curve: CurveType.natural,
                  stroke: theme.chart1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentQueue extends StatelessWidget {
  const _ContentQueue({required this.scheduled, required this.onSchedule});

  final Set<String> scheduled;
  final ValueChanged<String> onSchedule;

  @override
  Widget build(BuildContext context) => _OutlinedSection(
    title: 'Content queue',
    description: 'Cuts ready for a publish decision.',
    child: ItemGroup(
      gapOverride: space(2),
      children: <Widget>[
        _QueueItem(
          id: 'night-desk',
          title: 'Night desk field notes',
          detail: 'Ready · Best window today at 8:40 PM',
          scheduled: scheduled.contains('night-desk'),
          onSchedule: onSchedule,
        ),
        _QueueItem(
          id: 'quiet-system',
          title: 'A quiet system for louder work',
          detail: 'Review passed · Caption needs approval',
          scheduled: scheduled.contains('quiet-system'),
          onSchedule: onSchedule,
        ),
        _QueueItem(
          id: 'materials',
          title: 'Materials in motion',
          detail: 'Ready · Audience overlap is low',
          scheduled: scheduled.contains('materials'),
          onSchedule: onSchedule,
        ),
      ],
    ),
  );
}

class _QueueItem extends StatelessWidget {
  const _QueueItem({
    required this.id,
    required this.title,
    required this.detail,
    required this.scheduled,
    required this.onSchedule,
  });

  final String id;
  final String title;
  final String detail;
  final bool scheduled;
  final ValueChanged<String> onSchedule;

  @override
  Widget build(BuildContext context) => Item(
    variant: ItemVariant.outline,
    alignStart: true,
    media: ItemMedia(
      child: Icon.lucide(
        scheduled ? Lucide.calendarCheck : Lucide.clapperboard,
        size: IconSize.sm,
        tone: scheduled ? IconTone.success : IconTone.muted,
      ),
    ),
    content: ItemContent(
      children: <Widget>[
        ItemTitle(title),
        ItemDescription(detail),
        Badge(
          label: scheduled ? 'SCHEDULED' : 'READY',
          variant: scheduled ? BadgeVariant.success : BadgeVariant.secondary,
        ),
      ],
    ),
    actions: ItemActions(
      children: <Widget>[
        Button(
          size: ButtonSize.sm,
          variant: scheduled ? ButtonVariant.ghost : ButtonVariant.secondary,
          onPressed: () => onSchedule(id),
          child: StyledText(scheduled ? 'Undo' : 'Schedule', TextStyles.nav),
        ),
      ],
    ),
  );
}

class _StudioPulse extends StatelessWidget {
  const _StudioPulse({required this.onShowUnavailable});

  final VoidCallback onShowUnavailable;

  @override
  Widget build(BuildContext context) => _OutlinedSection(
    title: 'Studio pulse',
    description: 'What needs a decision today.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _PulseItem(
          glyph: Lucide.circleCheck,
          tone: IconTone.success,
          title: 'Edit approved',
          detail: 'Quiet architecture is ready to publish.',
        ),
        SizedBox(height: space(3)),
        const _PulseItem(
          glyph: Lucide.bell,
          tone: IconTone.action,
          title: 'Audience peak ahead',
          detail: 'Your next publish window opens in 42 minutes.',
        ),
        SizedBox(height: space(4)),
        Button(
          variant: ButtonVariant.outline,
          size: ButtonSize.sm,
          onPressed: onShowUnavailable,
          child: StyledText('Test recovery feedback', TextStyles.nav),
        ),
      ],
    ),
  );
}

class _PulseItem extends StatelessWidget {
  const _PulseItem({
    required this.glyph,
    required this.tone,
    required this.title,
    required this.detail,
  });

  final LucideGlyph glyph;
  final IconTone tone;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Item(
    media: ItemMedia(
      child: Icon.lucide(glyph, size: IconSize.sm, tone: tone),
    ),
    content: ItemContent(
      children: <Widget>[ItemTitle(title), ItemDescription(detail)],
    ),
  );
}

class _AudienceInsight extends StatelessWidget {
  const _AudienceInsight();

  @override
  Widget build(BuildContext context) => Alert(
    title: 'Audience insight',
    description:
        'Returning viewers are at 38.6%, the strongest result in 12 weeks.',
    variant: AlertVariant.info,
    icon: const Icon.lucide(Lucide.usersRound, tone: IconTone.inherit),
    action: Button(
      variant: ButtonVariant.secondary,
      size: ButtonSize.sm,
      onPressed: () => ShowcaseFeedback.of(context).info(
        'Insight saved',
        description: 'A reminder is waiting in your next planning session.',
      ),
      child: StyledText('Save insight', TextStyles.nav),
    ),
  );
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context) => _OutlinedSection(
    title: 'Recent activity',
    description: 'Small events worth carrying into the next cut.',
    child: const ItemGroup(
      children: <Widget>[
        _ActivityItem(
          title: 'Work in progress passed 10K saves',
          detail: 'Community signal · 18 minutes ago',
          glyph: Lucide.bookmarkCheck,
        ),
        _ActivityItem(
          title: 'Three collaborators joined your review queue',
          detail: 'Workflow signal · 46 minutes ago',
          glyph: Lucide.usersRound,
        ),
        _ActivityItem(
          title: 'A returning viewer finished your new sequence',
          detail: 'Retention signal · 1 hour ago',
          glyph: Lucide.arrowUpRight,
        ),
      ],
    ),
  );
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({
    required this.title,
    required this.detail,
    required this.glyph,
  });

  final String title;
  final String detail;
  final LucideGlyph glyph;

  @override
  Widget build(BuildContext context) => Item(
    media: ItemMedia(
      child: Icon.lucide(glyph, size: IconSize.sm, tone: IconTone.muted),
    ),
    content: ItemContent(
      children: <Widget>[ItemTitle(title), ItemDescription(detail)],
    ),
  );
}

class _OutlinedSection extends StatelessWidget {
  const _OutlinedSection({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      StyledText(title, TextStyles.small),
      SizedBox(height: space(1)),
      StyledText(description, TextStyles.small),
      SizedBox(height: space(3)),
      child,
    ],
  );
}

class _DashboardFailure extends StatelessWidget {
  const _DashboardFailure({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Alert(
      title: 'The studio signals are temporarily unavailable.',
      description:
          'No dashboard data was changed. Retry when you are ready to reconnect.',
      variant: AlertVariant.destructive,
      icon: const Icon.lucide(Lucide.circleAlert, tone: IconTone.inherit),
      action: Button(
        variant: ButtonVariant.secondary,
        size: ButtonSize.sm,
        onPressed: onRetry,
        child: StyledText('Retry', TextStyles.nav),
      ),
    ),
  );
}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.only(
      bottom: ShowcaseShellScope.bottomOverlayClearanceOf(context),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Skeleton(height: ChartContainer.plotHeight),
        SizedBox(height: space(5)),
        Grid(
          sm: 2,
          xl: 4,
          gap: space(4),
          children: <Widget>[
            Skeleton(height: space(20)),
            Skeleton(height: space(20)),
            Skeleton(height: space(20)),
            Skeleton(height: space(20)),
          ],
        ),
        SizedBox(height: space(5)),
        Skeleton(height: ChartContainer.plotHeight),
      ],
    ),
  );
}
