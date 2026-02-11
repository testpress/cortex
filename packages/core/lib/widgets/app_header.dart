import 'package:flutter/widgets.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import 'app_text.dart';

/// Platform-neutral app header (replaces AppBar/CupertinoNavigationBar).
///
/// Provides consistent header styling without Material or Cupertino
/// platform-specific visuals.
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
  });

  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.xl,
        AppSpacing.screenPadding,
        AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.headline(title, color: AppColors.textPrimary),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  AppText.bodySmall(subtitle!, color: AppColors.textSecondary),
                ],
              ],
            ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
