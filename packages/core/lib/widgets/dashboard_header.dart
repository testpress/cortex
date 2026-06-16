import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.title,
    this.isLandscape = false,
    this.titleTextStyle,
    this.showTitle = true,
    this.backgroundColor,
    this.showBottomBorder = true,
    this.greeting,
    this.greetingSubtitle,
    this.useSafeArea = true,
    this.customTopPadding,
    this.onMenuPressed,
  });

  final String title;
  final bool isLandscape;
  final TextStyle? titleTextStyle;
  final bool showTitle;
  final Color? backgroundColor;
  final bool showBottomBorder;
  final String? greeting;
  final String? greetingSubtitle;
  final bool useSafeArea;
  final double? customTopPadding;
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final padding = MediaQuery.paddingOf(context);
    final effectiveBgColor = backgroundColor ?? design.colors.card;

    final topPadding =
        customTopPadding ??
        (useSafeArea ? padding.top + design.spacing.md : design.spacing.md);
    final bottomPadding = design.spacing.md;

    return Container(
      padding: EdgeInsets.fromLTRB(
        padding.left > design.spacing.md ? padding.left : design.spacing.md,
        topPadding,
        padding.right > design.spacing.md ? padding.right : design.spacing.md,
        bottomPadding,
      ),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        border: showBottomBorder
            ? Border(bottom: BorderSide(color: design.colors.border, width: 1))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onMenuPressed != null) ...[
            AppFocusable(
              onTap: onMenuPressed,
              borderRadius: BorderRadius.circular(design.radius.full),
              child: Padding(
                padding: EdgeInsets.all(design.spacing.xs),
                child: Icon(
                  LucideIcons.menu,
                  color: design.colors.textPrimary,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: design.spacing.sm),
          ],
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showTitle)
                  AppText.headline(
                    title,
                    color: design.colors.textPrimary,
                    style: titleTextStyle,
                  ),
                if (greeting != null)
                  AppText.headline(greeting!, color: design.colors.textPrimary),
                if (greetingSubtitle != null)
                  AppText.bodySmall(
                    greetingSubtitle!,
                    color: design.colors.textSecondary,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
