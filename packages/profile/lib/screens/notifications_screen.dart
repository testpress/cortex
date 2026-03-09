import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/notification_preferences_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final preferences = ref.watch(notificationPreferencesProvider);
    final notifier = ref.read(notificationPreferencesProvider.notifier);

    return ColoredBox(
      color: design.colors.canvas,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _NotificationsHeader(onBack: onBack),
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
                  l10n.profileNotifications,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    height: 1.33,
                  ),
                ),
                SizedBox(height: design.spacing.xs),
                AppText.sm(
                  l10n.notificationsManagePreferences,
                  color: design.colors.textSecondary,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: design.spacing.lg),
                AppCard(
                  showShadow: true,
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _NotificationRow(
                        key: const ValueKey('notifications-row-live'),
                        type: NotificationPreferenceType.liveClassReminders,
                        label: l10n.notificationsLiveClassReminders,
                        description: l10n.notificationsLiveClassRemindersDesc,
                        icon: LucideIcons.calendar,
                        iconColor: design.colors.accent6,
                        iconBackground: design.colors.accent6.withValues(
                          alpha: 0.12,
                        ),
                        enabled: preferences.liveClassReminders,
                        onToggle: () => notifier.toggle(
                          NotificationPreferenceType.liveClassReminders,
                        ),
                      ),
                      _RowDivider(),
                      _NotificationRow(
                        key: const ValueKey('notifications-row-test'),
                        type: NotificationPreferenceType.testAssessmentAlerts,
                        label: l10n.notificationsTestAssessmentAlerts,
                        description: l10n.notificationsTestAssessmentAlertsDesc,
                        icon: LucideIcons.bell,
                        iconColor: design.colors.accent3,
                        iconBackground: design.colors.accent3.withValues(
                          alpha: 0.12,
                        ),
                        enabled: preferences.testAssessmentAlerts,
                        onToggle: () => notifier.toggle(
                          NotificationPreferenceType.testAssessmentAlerts,
                        ),
                      ),
                      _RowDivider(),
                      _NotificationRow(
                        key: const ValueKey('notifications-row-announcements'),
                        type: NotificationPreferenceType.announcementsUpdates,
                        label: l10n.notificationsAnnouncementsUpdates,
                        description: l10n.notificationsAnnouncementsUpdatesDesc,
                        icon: LucideIcons.megaphone,
                        iconColor: design.colors.accent1,
                        iconBackground: design.colors.accent1.withValues(
                          alpha: 0.12,
                        ),
                        enabled: preferences.announcementsUpdates,
                        onToggle: () => notifier.toggle(
                          NotificationPreferenceType.announcementsUpdates,
                        ),
                      ),
                      _RowDivider(),
                      _NotificationRow(
                        key: const ValueKey('notifications-row-achievements'),
                        type: NotificationPreferenceType.achievementsBadges,
                        label: l10n.notificationsAchievementsBadges,
                        description: l10n.notificationsAchievementsBadgesDesc,
                        icon: LucideIcons.trophy,
                        iconColor: design.colors.rank1,
                        iconBackground: design.colors.rank1.withValues(
                          alpha: 0.12,
                        ),
                        enabled: preferences.achievementsBadges,
                        onToggle: () => notifier.toggle(
                          NotificationPreferenceType.achievementsBadges,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsHeader extends StatelessWidget {
  const _NotificationsHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final padding = MediaQuery.of(context).padding;

    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.only(
          top: padding.top + design.spacing.md,
          bottom: design.spacing.md,
          left: design.spacing.md,
          right: design.spacing.md,
        ),
        decoration: BoxDecoration(
          color: design.isDark ? design.colors.surface : design.colors.card,
          border: Border(bottom: BorderSide(color: design.colors.border)),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: AppSemantics.button(
            label: l10n.curriculumBackButton,
            onTap: onBack,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onBack,
              child: SizedBox(
                height: design.iconSize.lg + design.spacing.xs,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.chevronLeft,
                      size: design.iconSize.md,
                      color: design.colors.textPrimary,
                    ),
                    SizedBox(width: design.spacing.sm),
                    AppText.subtitle(
                      l10n.curriculumBackButton,
                      color: design.colors.textPrimary,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    super.key,
    required this.type,
    required this.label,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.enabled,
    required this.onToggle,
  });

  final NotificationPreferenceType type;
  final String label;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final bool enabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppSemantics.button(
      label:
          '$label, ${enabled ? l10n.notificationsStateOn : l10n.notificationsStateOff}',
      onTap: onToggle,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onToggle,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.md,
          ),
          child: Row(
            children: [
              Container(
                width: design.spacing.xl + design.spacing.sm,
                height: design.spacing.xl + design.spacing.sm,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(design.radius.lg),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: design.iconSize.md, color: iconColor),
              ),
              SizedBox(width: design.spacing.sm + design.spacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.body(
                      label,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: design.spacing.xs / 2),
                    AppText.subtitle(
                      description,
                      color: design.colors.textSecondary,
                    ),
                  ],
                ),
              ),
              SizedBox(width: design.spacing.sm),
              _ToggleControl(
                key: ValueKey('notifications-toggle-${type.name}'),
                enabled: enabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleControl extends StatelessWidget {
  const _ToggleControl({super.key, required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final trackWidth = design.spacing.xxl;
    final trackHeight = design.spacing.lg;
    final knobSize = design.spacing.md + design.spacing.xs;

    return SizedBox(
      width: design.spacing.xxl,
      height: design.spacing.xxl,
      child: Center(
        child: AnimatedContainer(
          duration: MotionPreferences.duration(context, design.motion.fast),
          curve: MotionPreferences.curve(context, design.motion.easeInOut),
          width: trackWidth,
          height: trackHeight,
          padding: EdgeInsets.all((trackHeight - knobSize) / 2),
          decoration: BoxDecoration(
            color: enabled
                ? design.colors.accent2
                : design.colors.surfaceVariant,
            borderRadius: BorderRadius.circular(design.radius.full),
          ),
          child: AnimatedAlign(
            duration: MotionPreferences.duration(context, design.motion.fast),
            curve: MotionPreferences.curve(context, design.motion.easeInOut),
            alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: knobSize,
              height: knobSize,
              decoration: BoxDecoration(
                color: design.colors.textInverse,
                borderRadius: BorderRadius.circular(design.radius.full),
                boxShadow: design.shadows.surfaceSoft,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(height: 1, color: design.colors.divider);
  }
}
