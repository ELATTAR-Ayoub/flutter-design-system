/// The chart fixtures, `components/space/charts/data.ts`.
///
/// Every dataset every family reuses, moved out of the reference page
/// verbatim: the values and the reasoning behind them belong to the charts
/// as a whole, not to any one family or the page that lists them.
library;

import 'package:elattar_design_system/elattar_design_system.dart';

/* ── Fixtures, `components/space/charts/data.ts` ───────────────────────────── */

/// One footprint, shared by every chart specimen and by the skeleton that
/// stands in for it.
///
/// `data.ts`'s own reasoning: §5 asks a skeleton to match what replaces it —
/// same height, same padding, same radius: and the only way to be sure of that
/// across seventy charts is for all of them to name the same constant. It is
/// [ChartContainer.plotHeight], 256, and nothing here restates it.
double get plotHeight => ChartContainer.plotHeight;

/// 9 variants: area default/linear/step · bar default/horizontal/label · line
/// default/linear/step.
const List<Map<String, Object?>> monthsDesktop = <Map<String, Object?>>[
  <String, Object?>{'month': 'January', 'desktop': 186},
  <String, Object?>{'month': 'February', 'desktop': 305},
  <String, Object?>{'month': 'March', 'desktop': 237},
  <String, Object?>{'month': 'April', 'desktop': 73},
  <String, Object?>{'month': 'May', 'desktop': 209},
  <String, Object?>{'month': 'June', 'desktop': 214},
];

/// 17 variants: the most reused set in the registry.
const List<Map<String, Object?>> monthsDesktopMobile = <Map<String, Object?>>[
  <String, Object?>{'month': 'January', 'desktop': 186, 'mobile': 80},
  <String, Object?>{'month': 'February', 'desktop': 305, 'mobile': 200},
  <String, Object?>{'month': 'March', 'desktop': 237, 'mobile': 120},
  <String, Object?>{'month': 'April', 'desktop': 73, 'mobile': 190},
  <String, Object?>{'month': 'May', 'desktop': 209, 'mobile': 130},
  <String, Object?>{'month': 'June', 'desktop': 214, 'mobile': 140},
];

/// 5 radar variants. Identical to [monthsDesktop] except April, which is 273
/// rather than 73, *"a radar polygon whose fourth vertex sits at 27% of the
/// radius reads as a fold rather than as a shape."*
const List<Map<String, Object?>> radarMonths = <Map<String, Object?>>[
  <String, Object?>{'month': 'January', 'desktop': 186},
  <String, Object?>{'month': 'February', 'desktop': 305},
  <String, Object?>{'month': 'March', 'desktop': 237},
  <String, Object?>{'month': 'April', 'desktop': 273},
  <String, Object?>{'month': 'May', 'desktop': 209},
  <String, Object?>{'month': 'June', 'desktop': 214},
];

/// 2 radar variants. Flatter still, *"because a filled polygon shows every
/// dent."*
const List<Map<String, Object?>> radarMonthsFill = <Map<String, Object?>>[
  <String, Object?>{'month': 'January', 'desktop': 186},
  <String, Object?>{'month': 'February', 'desktop': 285},
  <String, Object?>{'month': 'March', 'desktop': 237},
  <String, Object?>{'month': 'April', 'desktop': 203},
  <String, Object?>{'month': 'May', 'desktop': 209},
  <String, Object?>{'month': 'June', 'desktop': 264},
];

/// The five browser rows, with the slot each one's colour comes from.
///
/// The reference carries `fill: "var(--color-chart-N)"` on the datum itself,
/// because `Pie`, `RadialBar` and `Cell` all read it per row. A Dart map cannot
/// hold an unresolved token, so the row carries the **slot** and [ChartInk]
/// resolves it: which is the same indirection with the theme lookup moved from
/// CSS to the build.
const List<Map<String, Object?>> browsers = <Map<String, Object?>>[
  <String, Object?>{'browser': 'chrome', 'visitors': 275, 'slot': 1},
  <String, Object?>{'browser': 'safari', 'visitors': 200, 'slot': 2},
  <String, Object?>{'browser': 'firefox', 'visitors': 187, 'slot': 3},
  <String, Object?>{'browser': 'edge', 'visitors': 173, 'slot': 4},
  <String, Object?>{'browser': 'other', 'visitors': 90, 'slot': 5},
];

/// All 9 tooltip variants. The one dataset with a real date axis and two
/// comparable series.
const List<Map<String, Object?>> sportDays = <Map<String, Object?>>[
  <String, Object?>{'date': '2024-07-15', 'running': 450, 'swimming': 300},
  <String, Object?>{'date': '2024-07-16', 'running': 380, 'swimming': 420},
  <String, Object?>{'date': '2024-07-17', 'running': 520, 'swimming': 120},
  <String, Object?>{'date': '2024-07-18', 'running': 140, 'swimming': 550},
  <String, Object?>{'date': '2024-07-19', 'running': 600, 'swimming': 350},
  <String, Object?>{'date': '2024-07-20', 'running': 480, 'swimming': 400},
];

/// 2 pie variants: stacked (both rings) · interactive (the desktop ring only).
const List<Map<String, Object?>> pieMonthsDesktop = <Map<String, Object?>>[
  <String, Object?>{'month': 'january', 'desktop': 186, 'slot': 1},
  <String, Object?>{'month': 'february', 'desktop': 305, 'slot': 2},
  <String, Object?>{'month': 'march', 'desktop': 237, 'slot': 3},
  <String, Object?>{'month': 'april', 'desktop': 173, 'slot': 4},
  <String, Object?>{'month': 'may', 'desktop': 209, 'slot': 5},
];

/// The inner ring of `pie-stacked`.
const List<Map<String, Object?>> pieMonthsMobile = <Map<String, Object?>>[
  <String, Object?>{'month': 'january', 'mobile': 80, 'slot': 1},
  <String, Object?>{'month': 'february', 'mobile': 200, 'slot': 2},
  <String, Object?>{'month': 'march', 'mobile': 120, 'slot': 3},
  <String, Object?>{'month': 'april', 'mobile': 190, 'slot': 4},
  <String, Object?>{'month': 'may', 'mobile': 130, 'slot': 5},
];

/// 91 days, 2024-04-01 to 2024-06-30, *"long on purpose: the three
/// interactive variants exist to demonstrate a range filter, and a filter over
/// six points demonstrates nothing."*
final List<Map<String, Object?>> dailyVisits = buildDailyVisits();

List<Map<String, Object?>> buildDailyVisits() {
  const List<List<int>> pairs = <List<int>>[
    <int>[222, 150],
    <int>[97, 180],
    <int>[167, 120],
    <int>[242, 260],
    <int>[373, 290],
    <int>[301, 340],
    <int>[245, 180],
    <int>[409, 320],
    <int>[59, 110],
    <int>[261, 190],
    <int>[327, 350],
    <int>[292, 210],
    <int>[342, 380],
    <int>[137, 220],
    <int>[120, 170],
    <int>[138, 190],
    <int>[446, 360],
    <int>[364, 410],
    <int>[243, 180],
    <int>[89, 150],
    <int>[137, 200],
    <int>[224, 170],
    <int>[138, 230],
    <int>[387, 290],
    <int>[215, 250],
    <int>[75, 130],
    <int>[383, 420],
    <int>[122, 180],
    <int>[315, 240],
    <int>[454, 380],
    <int>[165, 220],
    <int>[293, 310],
    <int>[247, 190],
    <int>[385, 420],
    <int>[481, 390],
    <int>[498, 520],
    <int>[388, 300],
    <int>[149, 210],
    <int>[227, 180],
    <int>[293, 330],
    <int>[335, 270],
    <int>[197, 240],
    <int>[197, 160],
    <int>[448, 490],
    <int>[473, 380],
    <int>[338, 400],
    <int>[499, 420],
    <int>[315, 350],
    <int>[235, 180],
    <int>[177, 230],
    <int>[82, 140],
    <int>[81, 120],
    <int>[252, 290],
    <int>[294, 220],
    <int>[201, 250],
    <int>[213, 170],
    <int>[420, 460],
    <int>[233, 190],
    <int>[78, 130],
    <int>[340, 280],
    <int>[178, 230],
    <int>[178, 200],
    <int>[470, 410],
    <int>[103, 160],
    <int>[439, 380],
    <int>[88, 140],
    <int>[294, 250],
    <int>[323, 370],
    <int>[385, 320],
    <int>[438, 480],
    <int>[155, 200],
    <int>[92, 150],
    <int>[492, 420],
    <int>[81, 130],
    <int>[426, 380],
    <int>[307, 350],
    <int>[371, 310],
    <int>[475, 520],
    <int>[107, 170],
    <int>[341, 290],
    <int>[408, 450],
    <int>[169, 210],
    <int>[317, 270],
    <int>[480, 530],
    <int>[132, 180],
    <int>[141, 190],
    <int>[434, 380],
    <int>[448, 490],
    <int>[149, 200],
    <int>[103, 160],
    <int>[446, 400],
  ];
  final DateTime first = DateTime(2024, 4);
  return <Map<String, Object?>>[
    for (int i = 0; i < pairs.length; i++)
      <String, Object?>{
        'date': DateFormat.dayKey(first.add(Duration(days: i))),
        'desktop': pairs[i][0],
        'mobile': pairs[i][1],
      },
  ];
}
