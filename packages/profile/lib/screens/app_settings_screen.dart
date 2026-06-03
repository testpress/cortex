import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../providers/settings_providers.dart';

class AppSettingsScreen extends ConsumerWidget {
  const AppSettingsScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return ColoredBox(
      color: design.colors.canvas,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SettingsHeader(onBack: onBack),
          Expanded(
            child: AppScroll(
              padding: EdgeInsets.fromLTRB(
                design.spacing.md,
                design.spacing.lg,
                design.spacing.md,
                design.spacing.xxl,
              ),
              children: [
                AppText.xl2(
                  l10n.drawerSettings,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    height: 1.33,
                  ),
                ),
                SizedBox(height: design.spacing.xs),
                AppText.sm(
                  l10n.settingsDescription,
                  color: design.colors.textSecondary,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: design.spacing.lg),
                _AppearanceSection(),
                SizedBox(height: design.spacing.xl),
                _PlaybackSection(),
                SizedBox(height: design.spacing.xl),
                _AccessibilitySection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final padding = MediaQuery.of(context).padding;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16, // px-4
        padding.top + 12, // py-3
        16,
        12,
      ),
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border(
          bottom: BorderSide(color: design.colors.border, width: 1),
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AppSemantics.button(
          label: l10n.curriculumBackButton,
          onTap: onBack,
          child: AppFocusable(
            onTap: onBack,
            borderRadius: design.radius.button,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  LucideIcons.chevronLeft,
                  size: 20,
                  color: design.colors.textPrimary,
                ),
                const SizedBox(width: 8),
                AppText.label(
                  l10n.curriculumBackButton,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppearanceSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final settingsAsync = ref.watch(appearanceSettingsNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: l10n.settingsAppearanceTitle),
        SizedBox(height: design.spacing.md),
        settingsAsync.when(
          data: (settings) => AppCard(
            showShadow: true,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildOption(
                  context: context,
                  ref: ref,
                  icon: LucideIcons.sun,
                  iconColor: design.colors.rank1, // amber
                  title: l10n.settingsThemeLightMode,
                  value: DesignMode.light,
                  groupValue: settings.mode,
                  onChanged: (val) => ref
                      .read(appearanceSettingsNotifierProvider.notifier)
                      .updateMode(DesignMode.light),
                ),
                _Divider(),
                _buildOption(
                  context: context,
                  ref: ref,
                  icon: LucideIcons.moon,
                  iconColor: design.colors.primary,
                  title: l10n.settingsThemeDarkMode,
                  value: DesignMode.dark,
                  groupValue: settings.mode,
                  onChanged: (val) => ref
                      .read(appearanceSettingsNotifierProvider.notifier)
                      .updateMode(DesignMode.dark),
                ),
                _Divider(),
                _buildOption(
                  context: context,
                  ref: ref,
                  icon: LucideIcons.monitor,
                  iconColor: design.colors.textTertiary, // slate
                  title: l10n.settingsThemeSystemDefault,
                  value: DesignMode.system,
                  groupValue: settings.mode,
                  onChanged: (val) => ref
                      .read(appearanceSettingsNotifierProvider.notifier)
                      .updateMode(DesignMode.system),
                ),
              ],
            ),
          ),
          loading: () => const Center(child: AppLoadingIndicator()),
          error: (_, _) => const AppErrorView(),
        ),
      ],
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required WidgetRef ref,
    required IconData icon,
    required Color iconColor,
    required String title,
    required DesignMode value,
    required DesignMode groupValue,
    required ValueChanged<DesignMode?> onChanged,
  }) {
    final design = Design.of(context);
    final isSelected = value == groupValue;

    return AppSemantics.button(
      label: '$title, ${isSelected ? 'selected' : 'unselected'}',
      onTap: () => onChanged(value),
      child: GestureDetector(
        onTap: () => onChanged(value),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.only(
            left: design.spacing.md,
            right: design.spacing.xl,
            top: design.spacing.md,
            bottom: design.spacing.md,
          ),
          child: Row(
            children: [
              _IconContainer(icon: icon, color: iconColor),
              SizedBox(width: (design.spacing.md + design.spacing.sm) / 2),
              Expanded(
                child: AppText.body(
                  title,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
              _RadioIndicator(isSelected: isSelected),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaybackSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final settingsAsync = ref.watch(playbackSettingsNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: l10n.settingsPlaybackTitle),
        SizedBox(height: design.spacing.md),
        settingsAsync.when(
          data: (settings) => AppCard(
            showShadow: true,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildVideoQualityGroup(context, ref, settings),
                _Divider(),
                _buildToggleOption(
                  context: context,
                  icon: LucideIcons.play,
                  iconColor: design.colors.accent2, // blue
                  title: l10n.settingsAutoPlay,
                  subtitle: l10n.settingsAutoPlaySubtitle,
                  value: settings.autoPlayNext,
                  onChanged: (val) => ref
                      .read(playbackSettingsNotifierProvider.notifier)
                      .updateAutoPlay(val),
                ),
              ],
            ),
          ),
          loading: () => const Center(child: AppLoadingIndicator()),
          error: (_, _) => const AppErrorView(),
        ),
      ],
    );
  }

  Widget _buildVideoQualityGroup(
    BuildContext context,
    WidgetRef ref,
    PlaybackSettings settings,
  ) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: design.spacing.md,
        right: design.spacing.xl,
        top: design.spacing.md,
        bottom: design.spacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconContainer(
            icon: LucideIcons.video,
            color: design.colors.accent1, // purple
          ),
          SizedBox(width: (design.spacing.md + design.spacing.sm) / 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.body(
                  l10n.settingsVideoQuality,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: design.spacing.xs / 2),
                AppText.labelSmall(l10n.settingsPlaybackDescription),
                SizedBox(height: design.spacing.md),
                ...VideoQuality.values.expand((v) {
                  final isSelected = settings.quality == v;
                  final isLast = v == VideoQuality.values.last;
                  return [
                    GestureDetector(
                      onTap: () => ref
                          .read(playbackSettingsNotifierProvider.notifier)
                          .updateQuality(v),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: design.spacing.sm,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${v.name[0].toUpperCase()}${v.name.substring(1)}',
                                      style: design.typography.bodySmall
                                          .copyWith(
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                            color: design.colors.textPrimary,
                                          ),
                                    ),
                                    if (v == VideoQuality.auto) ...[
                                      const TextSpan(text: ' '),
                                      WidgetSpan(
                                        alignment:
                                            PlaceholderAlignment.baseline,
                                        baseline: TextBaseline.alphabetic,
                                        child: Text(
                                          '(${l10n.settingsRecommended})',
                                          style: design.typography.labelSmall
                                              .copyWith(
                                                color:
                                                    design.colors.textSecondary,
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            _RadioIndicator(
                              isSelected: isSelected,
                              small: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!isLast) SizedBox(height: design.spacing.sm),
                  ];
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccessibilitySection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final settingsAsync = ref.watch(accessibilitySettingsNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: l10n.settingsAccessibilityTitle),
        SizedBox(height: design.spacing.md),
        settingsAsync.when(
          data: (settings) => AppCard(
            showShadow: true,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildTextScaleGroup(context, ref, settings),
                _Divider(),
                _buildToggleOption(
                  context: context,
                  icon: LucideIcons.eye,
                  iconColor: design.colors.textTertiary, // slate
                  title: l10n.settingsHighContrast,
                  subtitle: l10n.settingsHighContrastSubtitle,
                  value: settings.highContrast,
                  onChanged: (val) => ref
                      .read(accessibilitySettingsNotifierProvider.notifier)
                      .updateHighContrast(val),
                ),
              ],
            ),
          ),
          loading: () => const Center(child: AppLoadingIndicator()),
          error: (_, _) => const AppErrorView(),
        ),
      ],
    );
  }

  Widget _buildTextScaleGroup(
    BuildContext context,
    WidgetRef ref,
    AccessibilitySettings settings,
  ) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: design.spacing.md,
        right: design.spacing.xl,
        top: design.spacing.md,
        bottom: design.spacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconContainer(
            icon: LucideIcons.type,
            color: design.colors.accent4, // green
          ),
          SizedBox(width: (design.spacing.md + design.spacing.sm) / 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.body(
                  l10n.settingsTextSize,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: design.spacing.xs / 2),
                AppText.labelSmall(l10n.settingsTextSizeDescription),
                SizedBox(height: design.spacing.md),
                ...TextScaleSize.values.expand((v) {
                  final isSelected = settings.textScale == v;
                  final isLast = v == TextScaleSize.values.last;
                  return [
                    GestureDetector(
                      onTap: () => ref
                          .read(accessibilitySettingsNotifierProvider.notifier)
                          .updateTextScale(v),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: design.spacing.sm,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${v.name[0].toUpperCase()}${v.name.substring(1)}',
                                      style: design.typography.bodySmall
                                          .copyWith(
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                            color: design.colors.textPrimary,
                                          ),
                                    ),
                                    if (v == TextScaleSize.medium) ...[
                                      const TextSpan(text: ' '),
                                      WidgetSpan(
                                        alignment:
                                            PlaceholderAlignment.baseline,
                                        baseline: TextBaseline.alphabetic,
                                        child: Text(
                                          '(${l10n.settingsDefault})',
                                          style: design.typography.labelSmall
                                              .copyWith(
                                                color:
                                                    design.colors.textSecondary,
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            _RadioIndicator(
                              isSelected: isSelected,
                              small: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!isLast) SizedBox(height: design.spacing.sm),
                  ];
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Padding(
      padding: EdgeInsets.only(left: design.spacing.xs),
      child: AppText.title(title),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      height: 1 / MediaQuery.of(context).devicePixelRatio,
      color: design.colors.divider,
      margin: EdgeInsets.zero,
    );
  }
}

class _IconContainer extends StatelessWidget {
  const _IconContainer({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      width: design.spacing.xl + design.spacing.sm,
      height: design.spacing.xl + design.spacing.sm,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(design.radius.lg),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: design.iconSize.md, color: color),
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  const _RadioIndicator({required this.isSelected, this.small = false});

  final bool isSelected;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final size = small ? design.iconSize.sm : design.iconSize.md;
    // Add 1px padding on all sides of the canvas (2px total width/height extension)
    // to prevent anti-aliased edge clipping at the boundary.
    final canvasSize = size + 2.0;

    final shouldAnimate = MotionPreferences.shouldAnimate(context);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: isSelected ? 1.0 : 0.0),
      duration: shouldAnimate ? const Duration(milliseconds: 150) : Duration.zero,
      builder: (context, value, child) {
        return CustomPaint(
          size: Size(canvasSize, canvasSize),
          painter: _RadioPainter(
            borderColor: design.colors.border,
            fillColor: design.colors.accent2,
            dotColor: design.colors.textInverse,
            cardColor: design.colors.card,
            isSelected: isSelected,
            animationValue: value,
          ),
        );
      },
    );
  }
}

class _RadioPainter extends CustomPainter {
  _RadioPainter({
    required this.borderColor,
    required this.fillColor,
    required this.dotColor,
    required this.cardColor,
    required this.isSelected,
    required this.animationValue,
  });

  final Color borderColor;
  final Color fillColor;
  final Color dotColor;
  final Color cardColor;
  final bool isSelected;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width.roundToDouble();
    final height = size.height.roundToDouble();
    final center = Offset(width / 2, height / 2);
    // Draw the circle with the original logical radius, leaving 1px margin inside canvas.
    final radius = (width - 2.0) / 2;

    const strokeWidth = 1.5;

    // 1. Draw the outer ring as a filled circle of the current border/fill color
    final currentBorderColor = Color.lerp(borderColor, fillColor, animationValue)!;
    final paintRing = Paint()
      ..color = currentBorderColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawCircle(center, radius, paintRing);

    // 2. Draw the inner background circle as a filled circle of the card background color
    if (animationValue < 1.0) {
      final paintInner = Paint()
        ..color = cardColor
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
      canvas.drawCircle(center, radius - strokeWidth, paintInner);
    }

    // 3. Draw the inner center dot (grows and fades in as selected)
    if (animationValue > 0) {
      final innerRadius = radius * 0.5 * animationValue;
      final paintDot = Paint()
        ..color = dotColor.withValues(alpha: animationValue)
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
      canvas.drawCircle(center, innerRadius, paintDot);
    }
  }

  @override
  bool shouldRepaint(covariant _RadioPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.dotColor != dotColor ||
        oldDelegate.cardColor != cardColor ||
        oldDelegate.isSelected != isSelected ||
        oldDelegate.animationValue != animationValue;
  }
}

class _ToggleControl extends StatelessWidget {
  const _ToggleControl({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final trackWidth = design.spacing.xxl;
    final trackHeight = design.spacing.lg;
    final knobSize = design.spacing.md + design.spacing.xs;

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: trackWidth,
        height: trackHeight,
        padding: EdgeInsets.all((trackHeight - knobSize) / 2),
        decoration: BoxDecoration(
          color: enabled ? design.colors.accent2 : design.colors.border,
          borderRadius: BorderRadius.circular(design.radius.full),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: knobSize,
            height: knobSize,
            decoration: BoxDecoration(
              color: design.colors.textInverse,
              borderRadius: BorderRadius.circular(design.radius.full),
              boxShadow: [
                BoxShadow(
                  color: design.colors.shadow.withValues(alpha: 0.2),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildToggleOption({
  required BuildContext context,
  required IconData icon,
  required Color iconColor,
  required String title,
  required String subtitle,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  final design = Design.of(context);
  final l10n = L10n.of(context);
  return AppSemantics.button(
    label:
        '$title, ${value ? l10n.notificationsStateOn : l10n.notificationsStateOff}',
    onTap: () => onChanged(!value),
    child: GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(
          left: design.spacing.md,
          right: design.spacing.xl,
          top: design.spacing.md,
          bottom: design.spacing.md,
        ),
        child: Row(
          children: [
            _IconContainer(icon: icon, color: iconColor),
            SizedBox(width: (design.spacing.md + design.spacing.sm) / 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.body(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: design.spacing.xs / 2),
                  AppText.labelSmall(subtitle),
                ],
              ),
            ),
            _ToggleControl(enabled: value),
          ],
        ),
      ),
    ),
  );
}
