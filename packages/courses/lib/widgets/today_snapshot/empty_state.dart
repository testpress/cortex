import 'package:flutter/material.dart';
import 'package:core/core.dart';

class TodayEmptyState extends StatelessWidget {
  const TodayEmptyState({super.key, required this.design});

  final DesignConfig design;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
      child: AppCard(
        child: Center(
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: design.colors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  size: 24,
                  color: design.colors.success,
                ),
              ),
              const SizedBox(height: 12),
              AppText.title(
                l10n.allCaughtUpTitle,
                color: design.colors.textPrimary,
              ),
              AppText.bodySmall(
                l10n.noScheduledActivitiesSubtitle,
                color: design.colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
