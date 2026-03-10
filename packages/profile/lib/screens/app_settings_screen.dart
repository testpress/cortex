import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
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
          error: (_, __) => const AppErrorView(),
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
          error: (_, __) => const AppErrorView(),
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
          error: (_, __) => const AppErrorView(),
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

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? design.colors.accent2 : design.colors.border,
          width: 2,
        ),
        color: isSelected ? design.colors.accent2 : null,
      ),
      padding: const EdgeInsets.all(3),
      child: isSelected
          ? Container(
              decoration: BoxDecoration(
                color: design.colors.textInverse,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
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
