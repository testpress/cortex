import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class DoubtContextBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? courseName;
  final String? chapterName;

  const DoubtContextBadge({
    super.key,
    required this.icon,
    required this.text,
    this.courseName,
    this.chapterName,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final course = courseName ?? '';
    final chapter = chapterName ?? '';
    final hasHierarchy = course.isNotEmpty || chapter.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasHierarchy) ...[
          _BreadcrumbHeader(courseName: course, chapterName: chapter),
          SizedBox(height: design.spacing.sm),
        ],
        _ContextPill(icon: icon, text: text),
      ],
    );
  }
}

class _BreadcrumbHeader extends StatelessWidget {
  final String courseName;
  final String chapterName;

  const _BreadcrumbHeader({
    required this.courseName,
    required this.chapterName,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final semanticLabel = [
      if (courseName.isNotEmpty) courseName,
      if (chapterName.isNotEmpty) chapterName,
    ].join(', ');

    return AppSemantics.container(
      label: semanticLabel,
      child: Row(
        children: [
          if (courseName.isNotEmpty)
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: AppText.labelBold(
                courseName,
                color: design.colors.textPrimary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (courseName.isNotEmpty && chapterName.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: design.spacing.xs),
              child: Icon(
                LucideIcons.chevronRight,
                size: design.iconSize.sm,
                color: design.colors.textTertiary,
              ),
            ),
          if (chapterName.isNotEmpty)
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: AppText.labelBold(
                chapterName,
                color: design.colors.textPrimary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
