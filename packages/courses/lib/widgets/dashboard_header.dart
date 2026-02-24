import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:core/core.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + design.spacing.sm,
        bottom: design.spacing.sm,
        left: design.spacing.sm,
        right: design.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: design.isDark ? design.colors.surface : design.colors.card,
        border: Border(
          bottom: BorderSide(color: design.colors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.menu_rounded, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: AppText.body(title, color: design.colors.textPrimary),
          ),
        ],
      ),
    );
  }
}
