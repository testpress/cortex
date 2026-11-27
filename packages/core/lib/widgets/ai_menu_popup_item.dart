import 'package:flutter/widgets.dart';

import '../accessibility/app_focusable.dart';
import '../accessibility/app_semantics.dart';
import '../design/design_provider.dart';
import 'app_text.dart';

/// Shared popup item for header and conversation options menus.
class AiMenuPopupItem extends StatelessWidget {
  const AiMenuPopupItem({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppSemantics.button(
      label: label,
      onTap: onTap,
      child: AppFocusable(
        onTap: onTap,
        borderRadius: BorderRadius.circular(design.radius.sm),
        child: Container(
          constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.sm,
            vertical: design.spacing.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(design.radius.sm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: design.iconSize.sm, color: color),
              SizedBox(width: design.spacing.sm),
              ExcludeSemantics(child: AppText.bodySmall(label, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
