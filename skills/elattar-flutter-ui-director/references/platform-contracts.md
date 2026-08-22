# Platform and responsive contracts

Use `DsSafeArea` at app/page boundaries and read its source/tests before combining it with bars, bottom navigation, sheets, or nested scroll views. Do not spend system insets twice.

Use `MediaQuery`/`LayoutBuilder` only to choose structure. Use `DsBreakpoints`, `DsWidths`, `DsContainers`, `ds(...)`, or component contracts for resulting values. Adapt information structure (column-to-stack, sidebar-to-sheet, dense-to-scrollable navigation), not merely desktop cards scaled down.

Verify light/dark; narrow/mobile/tablet/wide paths; supported orientation/resizing; keyboard reachability; top/bottom insets; text scale; long content; and `MediaQuery.disableAnimations`. Use existing motion or `DsDurations`/`DsCurves`; never hardcode device offsets, gesture areas, density, or iOS/Android visual values.
