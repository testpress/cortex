import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:intl/intl.dart';

class LoginActivityItem extends StatelessWidget {
  final LoginActivityDto activity;

  const LoginActivityItem({
    super.key,
    required this.activity,
  });

  IconData _getDeviceIcon(String deviceType) {
    final type = deviceType.toLowerCase();
    if (type.contains('app')) return LucideIcons.smartphone;
    if (type.contains('mobile')) return LucideIcons.globe;
    if (type.contains('pc')) return LucideIcons.monitor;
    if (type.contains('tablet')) return LucideIcons.tablet;
    return LucideIcons.circleHelp;
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    
    final date = DateFormat.yMMMd().format(activity.lastUsed);
    final time = DateFormat.jm().format(activity.lastUsed);
    final formattedDate = '$date, $time';

    return Container(
      padding: EdgeInsets.all(design.spacing.md),
      margin: EdgeInsets.only(bottom: design.spacing.sm),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(design.radius.md),
        boxShadow: design.shadows.surfaceSoft,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(design.spacing.sm),
            decoration: BoxDecoration(
              color: design.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(design.radius.sm),
            ),
            child: Icon(
              _getDeviceIcon(activity.device),
              color: activity.currentDevice ? design.colors.primary : design.colors.textSecondary,
              size: 24,
            ),
          ),
          SizedBox(width: design.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppText.cardTitle(
                        '${activity.os} - ${activity.deviceName}',
                        color: design.colors.textPrimary,
                      ),
                    ),
                    if (activity.currentDevice)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: design.spacing.xs,
                          vertical: design.spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: design.colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(design.radius.sm),
                        ),
                        child: AppText.labelSmall(
                          l10n.loginActivityCurrentDevice,
                          color: design.colors.primary,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: design.spacing.xs),
                Row(
                  children: [
                    Icon(LucideIcons.mapPin, size: 14, color: design.colors.textSecondary),
                    SizedBox(width: design.spacing.xs),
                    AppText.cardSubtitle(
                      '${activity.location} · ${activity.ipAddress}',
                      color: design.colors.textSecondary,
                    ),
                  ],
                ),
                SizedBox(height: design.spacing.xs),
                Row(
                  children: [
                    Icon(LucideIcons.clock, size: 14, color: design.colors.textSecondary),
                    SizedBox(width: design.spacing.xs),
                    AppText.cardSubtitle(
                      formattedDate,
                      color: design.colors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
