import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:core/core.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key, required this.title, this.onMenuPressed});

  final String title;
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + design.spacing.md,
        bottom: design.spacing.md,
        left: design.spacing.md,
        right: design.spacing.md,
      ),
      decoration: BoxDecoration(
        color: design.isDark ? design.colors.surface : design.colors.card,
        border: Border(
          bottom: BorderSide(color: design.colors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onMenuPressed,
            child: const Icon(Icons.menu_rounded, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppText.subtitle(title, color: design.colors.textPrimary),
          ),
        ],
      ),
    );
  }
}
