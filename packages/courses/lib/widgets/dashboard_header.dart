import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:core/core.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.isTablet = false,
  });

  final String title;
  final VoidCallback? onMenuPressed;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final padding = MediaQuery.of(context).padding;

    return Container(
      padding: EdgeInsets.only(
        top: padding.top + design.spacing.md,
        bottom: design.spacing.md,
        left: (isTablet
            ? design.spacing.md
            : (padding.left > 0 ? padding.left : design.spacing.md)),
        right: (isTablet
            ? (padding.right > 0 ? padding.right : design.spacing.md)
            : design.spacing.md),
      ),
      decoration: BoxDecoration(
        color: design.isDark ? design.colors.surface : design.colors.card,
        border: Border(
          bottom: BorderSide(color: design.colors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          if (!isTablet) ...[
            GestureDetector(
              onTap: onMenuPressed,
              child: const Icon(Icons.menu_rounded, size: 28),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: AppText.headline(title, color: design.colors.textPrimary),
          ),
          if (isTablet)
            GestureDetector(
              onTap: onMenuPressed,
              child: const Icon(Icons.menu_rounded, size: 28),
            ),
        ],
      ),
    );
  }
}
