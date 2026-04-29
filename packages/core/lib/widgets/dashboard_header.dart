import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:core/core.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.isLandscape = false,
    this.titleTextStyle,
  });

  final String title;
  final VoidCallback? onMenuPressed;
  final bool isLandscape;
  final TextStyle? titleTextStyle;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final padding = MediaQuery.of(context).padding;

    return Container(
      padding: EdgeInsets.only(
        top: padding.top + design.spacing.md,
        bottom: design.spacing.md,
        left: (isLandscape
            ? design.spacing.md
            : (padding.left > 0 ? padding.left : design.spacing.md)),
        right: (isLandscape
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
            child: AppText.headline(
              title,
              color: design.colors.textPrimary,
              style: titleTextStyle,
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
