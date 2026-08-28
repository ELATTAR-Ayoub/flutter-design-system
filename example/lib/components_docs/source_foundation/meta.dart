/// Public documentation metadata for the `source-foundation` foundation.
///
/// `source-foundation` is registry `type: "foundation"` —
/// `registry/foundations/source.json`, the only registry item of that type
/// — and [dependencies] is that manifest's own `registryDependencies` list,
/// copied verbatim: empty. It is the copy-first Flutter foundation: eleven
/// files (`lib/src/foundation/*.dart`, plus `lib/src/text_layout.dart` and
/// `lib/src/theme_scope.dart`), covering semantic colours, both themes,
/// typography, spacing, motion, shadows and surfaces — every token every
/// other registry item is built from.
library;

import '../catalog.dart' show ComponentDocEntry;

const ComponentDocEntry sourceFoundationDoc = ComponentDocEntry(
  name: 'source_foundation',
  title: 'Source Foundation',
  description:
      'The copy-first Flutter foundation: semantic colors, both themes, '
      'typography, spacing, motion, shadows, surfaces, dates and text '
      'layout — eleven files, and the one dependency almost every other '
      'registry item lists.',
  // registry/foundations/source.json's own registryDependencies, verbatim:
  // empty — this is the root of the dependency graph, not a leaf of it.
  dependencies: <String>[],
  exports: <String>[
    'space',
    'LayoutWidths',
    'Radii',
    'Blurs',
    'Containers',
    'Breakpoints',
    'ThemeScope',
    'ThemeTokens',
    'ThemeController',
    'ColorMode',
    'ResolvedColorMode',
    'Palette',
    'OklabColor',
    'Fonts',
    'TextStyles',
    'ComponentTextStyles',
    'TextStyleToken',
    'TextColorRole',
    'StyledText',
    'LineBox',
    'MotionDurations',
    'MotionCurves',
    'MotionTransforms',
    'effectiveMotionDuration',
    'Shadows',
    'ShadowStyle',
    'ShadowLayer',
    'SurfaceOpacity',
    'DateFormat',
    'Fluid',
  ],
  sourcePath: 'lib/src/foundation/',
);
