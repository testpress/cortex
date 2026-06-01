import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';
import 'app_text.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: design.motion.fast,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? design.colors.accent2 : design.colors.card,
          borderRadius: design.radius.pill,
          border: Border.all(
            color: isSelected ? design.colors.accent2 : design.colors.border,
          ),
        ),
        child: AppText.labelSmall(
          label,
          color: isSelected ? design.colors.textInverse : null,
        ),
      ),
    );
  }
}
