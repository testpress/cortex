import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class AccountPreferencesSection extends StatelessWidget {
  const AccountPreferencesSection({super.key, this.onNotificationsTap});

  final VoidCallback? onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          child: AppText.title(
            l10n.profileAccountSettingsTitle,
            color: design.colors.textPrimary,
          ),
        ),
        SizedBox(height: design.spacing.md),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          child: AppCard(
            showShadow: true,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _PreferenceItem(
                  icon: LucideIcons.user,
                  label: l10n.profileEditProfile,
                  iconColor: design.colors.accent2,
                  onTap: () {},
                ),
                _Divider(),
                _PreferenceItem(
                  icon: LucideIcons.bell,
                  label: l10n.profileNotifications,
                  iconColor: design.colors.rank1,
                  onTap: onNotificationsTap ?? () {},
                ),
                _Divider(),
                _PreferenceItem(
                  icon: LucideIcons.download,
                  label: l10n.profileCertificates,
                  iconColor: design.colors.success,
                  onTap: () {},
                ),
                _Divider(),
                _PreferenceItem(
                  icon: LucideIcons.settings,
                  label: l10n.drawerSettings,
                  iconColor: design.colors.accent1,
                  onTap: () {},
                ),
                _Divider(),
                _PreferenceItem(
                  icon: LucideIcons.logOut,
                  label: l10n.profileLogout,
                  iconColor: design.colors.error,
                  labelColor: design.colors.error,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PreferenceItem extends StatelessWidget {
  const _PreferenceItem({
    required this.icon,
    required this.label,
    required this.iconColor,
    this.labelColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color iconColor;
  final Color? labelColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
          vertical: design.spacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(design.radius.md),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: design.iconSize.md,
              ),
            ),
            SizedBox(width: design.spacing.md),
            Expanded(
              child: AppText.label(
                label,
                color: labelColor ?? design.colors.textPrimary,
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: design.iconSize.md,
              color: design.colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      height: 1,
      color: design.colors.divider,
    );
  }
}
