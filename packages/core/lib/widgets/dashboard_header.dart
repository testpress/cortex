import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:core/core.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.isLandscape = false,
    this.showTitle = true,
    this.backgroundColor,
    this.showBottomBorder = true,
    this.greeting,
    this.greetingSubtitle,
    this.useSafeArea = true,
    this.customTopPadding,
  });

  final String title;
  final VoidCallback? onMenuPressed;
  final bool isLandscape;
  final bool showTitle;
  final Color? backgroundColor;
  final bool showBottomBorder;
  final String? greeting;
  final String? greetingSubtitle;
  final bool useSafeArea;
  final double? customTopPadding;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final padding = MediaQuery.of(context).padding;
    final effectiveBgColor = backgroundColor ??
        (design.isDark ? design.colors.surface : design.colors.card);

    final topPadding = customTopPadding ??
        (useSafeArea ? padding.top + design.spacing.md : design.spacing.md);

    return Container(
      padding: EdgeInsets.only(
        top: topPadding,
        bottom: design.spacing.md,
        left: (isLandscape
            ? design.spacing.md
            : (padding.left > 0 ? padding.left : design.spacing.md)),
        right: (isLandscape
            ? (padding.right > 0 ? padding.right : design.spacing.md)
            : design.spacing.md),
      ),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        border: showBottomBorder
            ? Border(
                bottom: BorderSide(color: design.colors.border, width: 1),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isLandscape) ...[
            if (onMenuPressed != null) ...[
              GestureDetector(
                onTap: onMenuPressed,
                child: const Icon(Icons.menu_rounded, size: 28),
              ),
              const SizedBox(width: 12),
            ],
          ],
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showTitle)
                  AppText.headline(title, color: design.colors.textPrimary),
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
          if (isLandscape) ...[
            if (onMenuPressed != null) ...[
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onMenuPressed,
                child: const Icon(Icons.menu_rounded, size: 28),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
