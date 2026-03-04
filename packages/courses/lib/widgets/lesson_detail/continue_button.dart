import 'package:flutter/material.dart';
import 'package:core/core.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback onTap;
  const ContinueButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: design.spacing.lg,
        bottom: design.spacing.xl,
      ),
      child: AppButton.primary(
        label: L10n.of(context).videoLessonContinueNext,
        trailing: Icon(
          LucideIcons.chevronRight,
          size: 16,
          color: design.colors.onPrimary,
        ),
        onPressed: onTap,
        fullWidth: true,
        backgroundColor: design.isDark
            ? design.colors.card
            : design.colors.textPrimary,
        height: 44,
      ),
    );
  }
}
