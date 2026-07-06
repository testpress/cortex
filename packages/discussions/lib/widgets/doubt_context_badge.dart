import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class DoubtContextBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final List<String> breadcrumbs;

  const DoubtContextBadge({
    super.key,
    required this.icon,
    required this.text,
    this.breadcrumbs = const [],
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final hasHierarchy = breadcrumbs.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasHierarchy) ...[
          _BreadcrumbHeader(breadcrumbs: breadcrumbs),
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

    final validBreadcrumbs = breadcrumbs.where((b) => b.isNotEmpty).toList();
    final semanticLabel = validBreadcrumbs.join(', ');

    return AppSemantics.container(
      label: semanticLabel,
      child: Row(
        children: validBreadcrumbs.asMap().entries.expand((entry) {
          final isLast = entry.key == validBreadcrumbs.length - 1;

          final textWidget = AppText.labelBold(
            entry.value,
            color: design.colors.textPrimary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );

          return [
            Flexible(flex: 1, fit: FlexFit.loose, child: textWidget),
            if (!isLast)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: design.spacing.xs),
                child: Icon(
                  LucideIcons.chevronRight,
                  size: design.iconSize.sm,
                  color: design.colors.textTertiary,
                ),
              ),
          ];
        }).toList(),
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
            child: AppSemantics.container(
              label: text,
              child: AppHtmlV2(
                data: text,
                textColor: design.colors.accent2,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
