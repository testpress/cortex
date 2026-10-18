import 'package:flutter/widgets.dart';

import '../core.dart';

/// Tappable prompt starter shown on the empty AI chat.
class AiSuggestionCard extends StatelessWidget {
  const AiSuggestionCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  /// Null disables the card.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppSemantics.button(
      label: label,
      onTap: onTap,
      enabled: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          constraints: const BoxConstraints(minHeight: 48.0),
          padding: EdgeInsets.all(design.spacing.md),
          decoration: BoxDecoration(
            color: design.colors.card,
            borderRadius: design.radius.card,
            border: Border.all(color: design.colors.border, width: 1.0),
          ),
          // Keeps a one-line label centered when a taller neighbor stretches
          // the card.
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            heightFactor: 1.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: design.iconSize.md, color: iconColor),
                SizedBox(width: design.spacing.sm),
                Expanded(
                  child: ExcludeSemantics(
                    child: AppText.bodySmall(
                      label,
                      color: design.colors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
