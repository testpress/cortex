import 'package:flutter/widgets.dart';
import '../design/design_config.dart';
import '../design/design_provider.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.semanticStatus,
    this.icon,
    this.isPill = false,
  });

  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final StatusColors? semanticStatus;
  final IconData? icon;
  final bool isPill;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final bg =
        semanticStatus?.background ?? backgroundColor ?? design.colors.surface;
    final fg =
        semanticStatus?.foreground ??
        foregroundColor ??
        design.colors.onSurface;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.sm,
        vertical: design.spacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: isPill
            ? design.radius.pill
            : BorderRadius.circular(design.radius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            SizedBox(width: design.spacing.xs / 2),
          ],
          Text(
            label,
            style: design.typography.labelSmall.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
