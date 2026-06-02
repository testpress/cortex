import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class AskDoubtFab extends StatelessWidget {
  const AskDoubtFab({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppFocusable(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: design.colors.primary,
          borderRadius: BorderRadius.circular(50),
          boxShadow: design.shadows.floating,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.messageCircleQuestionMark,
              color: design.colors.onPrimary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              L10n.of(context).labelAskDoubt,
              style: design.typography.labelBold.copyWith(
                color: design.colors.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
