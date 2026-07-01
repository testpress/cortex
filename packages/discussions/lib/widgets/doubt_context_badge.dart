import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class DoubtContextBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final List<String>? breadcrumbs;

  const DoubtContextBadge({
    super.key,
    required this.icon,
    required this.text,
    this.breadcrumbs,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final crumbs = (breadcrumbs ?? []).where((s) => s.isNotEmpty).toList();
    final hasHierarchy = crumbs.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasHierarchy) ...[
          _BreadcrumbHeader(breadcrumbs: crumbs),
          SizedBox(height: design.spacing.sm),
        ],
        _ContextPill(icon: icon, text: text),
      ],
    );
  }
}

class _BreadcrumbHeader extends StatelessWidget {
  final List<String> breadcrumbs;

  const _BreadcrumbHeader({required this.breadcrumbs});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final semanticLabel = breadcrumbs.join(', ');

    return AppSemantics.container(
      label: semanticLabel,
      child: Row(
        children: [
          for (int i = 0; i < breadcrumbs.length; i++) ...[
            if (i > 0)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: design.spacing.xs),
                child: Icon(
                  LucideIcons.chevronRight,
                  size: design.iconSize.sm,
                  color: design.colors.textTertiary,
                ),
              ),
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: AppText.labelBold(
                breadcrumbs[i],
                color: design.colors.textPrimary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ContextPill extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContextPill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: design.colors.accent2.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(design.radius.md),
        border: Border.all(color: design.colors.accent2.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: design.iconSize.md, color: design.colors.accent2),
          SizedBox(width: design.spacing.sm),
          Expanded(
            child: AppText.bodySmall(
              text,
              color: design.colors.accent2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
