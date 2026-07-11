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
    final validBreadcrumbs = breadcrumbs
        .where((b) => b.trim().isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (validBreadcrumbs.isNotEmpty) ...[
          _BreadcrumbHeader(breadcrumbs: validBreadcrumbs),
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

    if (breadcrumbs.isEmpty) {
      return const SizedBox.shrink();
    }

    final semanticLabel = breadcrumbs.join(', ');

    final children = <Widget>[];
    for (int i = 0; i < breadcrumbs.length; i++) {
      children.add(
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
      );
      if (i < breadcrumbs.length - 1) {
        children.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.xs),
            child: Icon(
              LucideIcons.chevronRight,
              size: design.iconSize.sm,
              color: design.colors.textTertiary,
            ),
          ),
        );
      }
    }

    return AppSemantics.container(
      label: semanticLabel,
      child: Row(mainAxisSize: MainAxisSize.min, children: children),
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
            child: AppHtmlV2(
              data: text,
              textColor: design.colors.accent2,
              fontSize: 12,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
