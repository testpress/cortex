import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/material.dart'
    show TextField, InputDecoration, InputBorder, Icon, Material, MaterialType;
import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
    this.backgroundColor,
  });

  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? design.colors.surface,
        borderRadius: BorderRadius.circular(design.radius.lg),
        border: Border.all(color: design.colors.border.withValues(alpha: 0.5)),
      ),
      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
      child: Row(
        children: [
          Icon(LucideIcons.search, color: design.colors.textTertiary, size: 20),
          SizedBox(width: design.spacing.sm),
          Expanded(
            child: Material(
              type: MaterialType.transparency,
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: design.typography.body.copyWith(
                  color: design.colors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: design.typography.body.copyWith(
                    color: design.colors.textTertiary,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: design.spacing.sm,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
