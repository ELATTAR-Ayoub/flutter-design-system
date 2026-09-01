import 'dart:io';

const Map<String, String> replacements = <String, String>{
  'LayoutWidths.sidebarIcon': 'LayoutWidths.sidebarCollapsed',
  'LayoutWidths.siteHeader': 'LayoutHeights.siteHeader',
  'LayoutWidths.hairline': 'BorderWidths.hairline',
  'LayoutWidths.scrollOffset': 'ScrollOffsets.anchoredHeading',
  'Radii.pill': 'Radii.full',
  'ComponentTextStyles.': 'TextStyles.',
  'TextStyles.label': 'TextStyles.eyebrow',
  'TextStyles.micro': 'TextStyles.eyebrowSmall',
  'TextStyles.textSm': 'TextStyles.bodySmall',
  'TextStyles.sheetBody': 'TextStyles.bodyCompact',
  'TextStyles.serial': 'TextStyles.identifier',
  'TextStyles.numXs': 'TextStyles.numberXs',
  'TextStyles.numSm': 'TextStyles.numberSm',
  'TextStyles.numBase': 'TextStyles.numberBase',
  'TextStyles.numMd': 'TextStyles.numberMd',
  'TextStyles.numLg': 'TextStyles.numberLg',
  'TextStyles.numXl': 'TextStyles.numberXl',
  'TextStyles.inputNum': 'TextStyles.inputNumber',
  'TextStyles.messageMeta': 'TextStyles.messageMetadata',
  'TextStyles.attachmentTitleSm': 'TextStyles.attachmentTitleSmall',
  'Shadows.e1': 'Shadows.sm',
  'Shadows.e2': 'Shadows.md',
  'Shadows.e3': 'Shadows.lg',
  'Shadows.e4': 'Shadows.xl',
  'Shadows.keyDown': 'Shadows.keyPressed',
  'Shadows.key': 'Shadows.keyRaised',
  'Shadows.pressed': 'Shadows.inset',
  'Shadows.btnPrimary': 'Shadows.controlPrimary',
  'Shadows.btnValue': 'Shadows.controlPremium',
  'Shadows.btnDown': 'Shadows.controlPressed',
  'Shadows.btn': 'Shadows.control',
  'Shadows.chip': 'Shadows.compactControl',
  'MotionDurations.tooltipDelay': 'MotionDurations.tooltipShowDelay',
  'MotionDurations.hoverCardOpenDelay': 'MotionDurations.hoverCardShowDelay',
  'MotionDurations.hoverCardCloseDelay': 'MotionDurations.hoverCardHideDelay',
  'MotionDurations.pressDown': 'MotionDurations.pressIn',
  'MotionDurations.animJelly': 'MotionDurations.stateChange',
  'MotionDurations.transitionDefault': 'MotionDurations.normal',
  'MotionDurations.base': 'MotionDurations.normal',
  'MotionDurations.overlay': 'MotionDurations.overlayEnter',
  'MotionDurations.jelly': 'MotionDurations.open',
  'MotionDurations.drawer': 'MotionDurations.drawerOpen',
  'MotionCurves.spring': 'MotionCurves.emphasized',
  'MotionCurves.out': 'MotionCurves.enter',
  'MotionCurves.curveIn': 'MotionCurves.exit',
  'MotionCurves.inOut': 'MotionCurves.move',
  'MotionTransforms.pressScale': 'MotionTransforms.press',
  'MotionTransforms.buttonScale': 'MotionTransforms.buttonPress',
  'GlassPanelClear(': 'Glass(variant: GlassVariant.navigation, ',
  'GlassPanelDeep(': 'Glass(variant: GlassVariant.prominent, ',
  'GlassControl(': 'Glass(variant: GlassVariant.control, ',
  'GlassPanel(': 'Glass(variant: GlassVariant.panel, ',
  'travelDuration': 'moveDuration',
  'SlidingPillDocPage': 'ActiveIndicatorDocPage',
  'pill:': 'indicator:',
  'GlassPanelDeep.debugFill(': 'Glass.debugFill(GlassVariant.prominent, ',
  'GlassPanelClear.debugFill(': 'Glass.debugFill(GlassVariant.navigation, ',
  'GlassControl.debugFill(': 'Glass.debugFill(GlassVariant.control, ',
  'GlassPanel.debugFill(': 'Glass.debugFill(GlassVariant.panel, ',
  'GlassPanelDeep.debugShadow': 'Glass.debugShadow(GlassVariant.prominent)',
  'GlassPanelClear.debugShadow': 'Glass.debugShadow(GlassVariant.navigation)',
  'GlassControl.debugShadow': 'Glass.debugShadow(GlassVariant.control)',
  'GlassPanel.debugShadow': 'Glass.debugShadow(GlassVariant.panel)',
  'GlassPanelDeep.debugBackdrop': 'Glass.debugBackdrop(GlassVariant.prominent)',
  'GlassPanelClear.debugBackdrop':
      'Glass.debugBackdrop(GlassVariant.navigation)',
  'GlassControl.debugBackdrop': 'Glass.debugBackdrop(GlassVariant.control)',
  'GlassPanel.debugBackdrop': 'Glass.debugBackdrop(GlassVariant.panel)',
  'GlassPanelDeep.debugAmbientClip(': 'Glass.debugAmbientClip(',
  'GlassPanelClear.debugAmbientClip(': 'Glass.debugAmbientClip(',
  'GlassPanel.debugAmbientClip(': 'Glass.debugAmbientClip(',
  'GlassPanelClear': 'GlassVariant.navigation',
  'GlassPanelDeep': 'GlassVariant.prominent',
  'GlassControl': 'GlassVariant.control',
  'GlassPanel': 'GlassVariant.panel',
  'actionInk': 'actionText',
  'valueInk': 'premiumText',
  'successInk': 'successText',
  'warningInk': 'warningText',
  'infoInk': 'infoText',
  'destructiveInk': 'destructiveText',
  'bubbleTintedHover': 'messageAccentHover',
  'bubbleTinted': 'messageAccent',
  'agentMuted': 'agentAccentMuted',
  '.agent': '.agentAccent',
  'agent:': 'agentAccent:',
  'BloomCosmicDocPage': 'FeedbackSurfaceDocPage',
  'bloomCosmicDoc': 'feedbackSurfaceDoc',
  'bloom_cosmic': 'feedback_surface',
  'bloom-cosmic': 'feedback-surface',
  'FoilValueDocPage': 'PremiumSurfaceDocPage',
  'foilValueDoc': 'premiumSurfaceDoc',
  'foil_value': 'premium_surface',
  'foil-value': 'premium-surface',
  'MachineSurfaceDocPage': 'SurfaceDocPage',
  'machineSurfaceDoc': 'surfaceDoc',
  'machine_surface': 'surface',
  'machine-surface': 'surface',
  'PageGlowDocPage': 'BackgroundEffectDocPage',
  'pageGlowDoc': 'backgroundEffectDoc',
  'page_glow': 'background_effect',
  'page-glow': 'background-effect',
  'SheenActionDocPage': 'ActionFeedbackDocPage',
  'sheenActionDoc': 'actionFeedbackDoc',
  'sheen_action': 'action_feedback',
  'sheen-action': 'action-feedback',
  'StarfieldDocPage': 'AmbientPatternDocPage',
  'starfieldDoc': 'ambientPatternDoc',
  'VoiceOrbDocPage': 'VoiceIndicatorDocPage',
  'voiceOrbDoc': 'voiceIndicatorDoc',
  'voice_orb': 'voice_indicator',
  'voice-orb': 'voice-indicator',
  'LiftDocPage': 'HoverBuilderDocPage',
  'liftDoc': 'hoverBuilderDoc',
  'PressMotionDocPage': 'PressDocPage',
  'pressMotionDoc': 'pressDoc',
  'press_motion': 'press',
  'press-motion': 'press',
  'slidingPillDoc': 'activeIndicatorDoc',
  'sliding_pill': 'active_indicator',
  'sliding-pill': 'active-indicator',
  'SwapInDocPage': 'ContentChangeDocPage',
  'swapInDoc': 'contentChangeDoc',
  'swap_in': 'content_change',
  'swap-in': 'content-change',
  'lib/src/effects/': 'lib/src/components/ui/',
  'lib/src/motion/': 'lib/src/components/ui/',
  'registry/effects/': 'registry/components/',
  'registry/motion/': 'registry/components/',
  '@effects/': '@ui/',
  '@motion/': '@ui/',
  'FeedbackSurface.toastWarning(':
      'FeedbackSurface(variant: FeedbackVariant.warning, ',
  'FeedbackSurface.destructive(':
      'FeedbackSurface(variant: FeedbackVariant.error, ',
  'FeedbackSurface.success(':
      'FeedbackSurface(variant: FeedbackVariant.success, ',
  'FeedbackSurface.warning(':
      'FeedbackSurface(variant: FeedbackVariant.warning, ',
  'FeedbackSurface.loading(':
      'FeedbackSurface(variant: FeedbackVariant.loading, ',
  'FeedbackSurface.info(': 'FeedbackSurface(variant: FeedbackVariant.info, ',
  'FeedbackSurface.action(':
      'FeedbackSurface(variant: FeedbackVariant.neutral, ',
  'nav_user.dart': 'user_menu.dart',
  'nav-user': 'user-menu',
  'nav_user': 'user_menu',
  'NavUserDocPage': 'UserMenuDocPage',
  'navUserDoc': 'userMenuDoc',
  'rule.dart': 'validation_rule.dart',
  'RuleDocPage': 'ValidationRuleDocPage',
  'ruleDoc': 'validationRuleDoc',
  'elRuleDoc': 'validationRuleDoc',
  'components_docs/rule': 'components_docs/validation_rule',
  'rule_test.dart': 'validation_rule_test.dart',
  'elattar add rule': 'elattar add validation-rule',
  'lib/src/components/user_menu.dart': 'lib/src/components/ui/user_menu.dart',
  'nav_user_test.dart': 'user_menu_test.dart',
  'ShimmerText': 'AttachmentStatusText',
};

const List<String> roots = <String>[
  'lib',
  'example',
  'test',
  'tool',
  'packages',
  'registry',
  'docs',
];

void main() {
  var changed = 0;
  for (final root in roots) {
    final directory = Directory(root);
    if (!directory.existsSync()) continue;
    for (final entity in _sourceFiles(directory)) {
      final path = entity.path.replaceAll('\\', '/');
      if (path.endsWith('tool/migration/apply_semantic_member_renames.dart'))
        continue;
      if (path.endsWith('lib/src/components/ui/glass.dart')) continue;
      if (!const <String>{
        '.dart',
        '.md',
        '.json',
        '.yaml',
        '.yml',
      }.contains(_extension(entity.path)))
        continue;
      var text = entity.readAsStringSync();
      final before = text;
      for (final entry in replacements.entries) {
        final leadingBoundary = RegExp(r'^[A-Za-z0-9_]').hasMatch(entry.key)
            ? r'(?<![A-Za-z0-9_])'
            : '';
        final trailingBoundary = RegExp(r'[A-Za-z0-9_]$').hasMatch(entry.key)
            ? '(?![A-Za-z0-9_])'
            : '';
        text = text.replaceAll(
          RegExp(
            '$leadingBoundary${RegExp.escape(entry.key)}$trailingBoundary',
          ),
          entry.value,
        );
      }
      text = text
          .replaceAll(
            RegExp(r'validation_(?:validation_)+rule'),
            'validation_rule',
          )
          .replaceAll(
            RegExp(r'validation-(?:validation-)+rule'),
            'validation-rule',
          )
          .replaceAll(
            RegExp(r'(?:Validation)+RuleDocPage'),
            'ValidationRuleDocPage',
          )
          .replaceAll(
            RegExp(r'validation(?:Validation)+RuleDoc'),
            'validationRuleDoc',
          );
      text = text.replaceAllMapped(
        RegExp(r'\b_El([A-Z][A-Za-z0-9_]*)'),
        (match) => '_${match.group(1)!}',
      );
      text = text.replaceAllMapped(
        RegExp(r'\bEl([A-Z][A-Za-z0-9_]*)'),
        (match) => match.group(1)!,
      );
      if (text != before) {
        entity.writeAsStringSync(text);
        changed++;
      }
    }
  }
  stdout.writeln('Updated $changed files.');
}

Iterable<File> _sourceFiles(Directory directory) sync* {
  for (final entity in directory.listSync()) {
    if (entity is File) {
      yield entity;
      continue;
    }
    if (entity is! Directory) continue;
    final name = entity.uri.pathSegments.where((part) => part.isNotEmpty).last;
    if (name == 'node_modules' ||
        name == '.dart_tool' ||
        name == '.git' ||
        name == 'build' ||
        name == 'out' ||
        entity.path.replaceAll('\\', '/').endsWith('/registry/generated')) {
      continue;
    }
    yield* _sourceFiles(entity);
  }
}

String _extension(String path) {
  final name = path.replaceAll('\\', '/').split('/').last;
  final dot = name.lastIndexOf('.');
  return dot < 0 ? '' : name.substring(dot);
}
