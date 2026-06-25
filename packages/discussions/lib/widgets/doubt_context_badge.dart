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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textStyle = design.typography.bodySmall.copyWith(
            color: design.colors.textPrimary,
          );
          final chevronWidth = design.iconSize.sm + (design.spacing.xs * 2);
          final textScaler = MediaQuery.textScalerOf(context);

          double getWidth(String text) {
            if (text.isEmpty) return 0;
            final painter = TextPainter(
              text: TextSpan(text: text, style: textStyle),
              maxLines: 1,
              textDirection:
                  Directionality.maybeOf(context) ?? TextDirection.ltr,
              textScaler: textScaler,
            )..layout();
            final width = painter.size.width;
            painter.dispose();
            return width;
          }

          final courseWidth = getWidth(courseName);
          final chapterWidth = getWidth(chapterName);

          double courseMaxWidth = 0;
          double chapterMaxWidth = 0;

          if (courseName.isNotEmpty && chapterName.isEmpty) {
            courseMaxWidth = constraints.maxWidth;
          } else if (courseName.isEmpty && chapterName.isNotEmpty) {
            chapterMaxWidth = constraints.maxWidth;
          } else {
            final availableWidth = (constraints.maxWidth - chevronWidth).clamp(
              0.0,
              double.infinity,
            );
            if (courseWidth + chapterWidth <= availableWidth) {
              courseMaxWidth = courseWidth;
              chapterMaxWidth = chapterWidth;
            } else if (courseWidth > availableWidth / 2 &&
                chapterWidth > availableWidth / 2) {
              courseMaxWidth = availableWidth / 2;
              chapterMaxWidth = availableWidth / 2;
            } else if (courseWidth <= availableWidth / 2) {
              courseMaxWidth = courseWidth;
              chapterMaxWidth = availableWidth - courseWidth;
            } else {
              chapterMaxWidth = chapterWidth;
              courseMaxWidth = availableWidth - chapterWidth;
            }
          }

          return Row(
            children: [
              if (courseName.isNotEmpty)
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: courseMaxWidth),
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
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: chapterMaxWidth),
                  child: AppText.labelBold(
                    chapterName,
                    color: design.colors.textPrimary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          );
        },
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
