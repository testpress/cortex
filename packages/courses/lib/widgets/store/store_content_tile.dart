import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// Minimum interactive touch target dimension (48dp) per WCAG 2.5.5 / Android & iOS standards.
const double kMinTouchTargetSize = 48.0;

/// Renders an individual lesson/exam item in the store curriculum tree.
class StoreContentTile extends StatelessWidget {
  final LessonDto content;
  final VoidCallback? onBuyTap;

  const StoreContentTile({
    super.key,
    required this.content,
    this.onBuyTap,
  });

  IconData _getContentIcon(LessonType type) {
    switch (type) {
      case LessonType.video:
      case LessonType.liveStream:
      case LessonType.videoConference:
      case LessonType.embedContent:
        return LucideIcons.playCircle;
      case LessonType.test:
      case LessonType.assessment:
      case LessonType.assignment:
        return LucideIcons.fileCheck2;
      case LessonType.attachment:
        return LucideIcons.paperclip;
      case LessonType.notes:
      case LessonType.pdf:
      case LessonType.unknown:
        return LucideIcons.fileText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final badgeWidget = Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.sm,
        vertical: design.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: design.colors.accent2.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(design.radius.sm),
        border: Border.all(
          color: design.colors.accent2.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.lock,
            size: design.iconSize.xs,
            color: design.colors.accent2,
          ),
          SizedBox(width: design.spacing.xs),
          AppText.caption(
            l10n.storeBuyToUnlock,
            color: design.colors.accent2,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );

    final Widget badge;
    if (onBuyTap != null) {
      badge = AppSemantics.button(
        label: l10n.storeBuyToUnlock,
        onTap: onBuyTap,
        child: AppFocusable(
          onTap: onBuyTap,
          borderRadius: BorderRadius.circular(design.radius.sm),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: kMinTouchTargetSize,
              minWidth: kMinTouchTargetSize,
            ),
            child: Center(
              child: badgeWidget,
            ),
          ),
        ),
      );
    } else {
      badge = badgeWidget;
    }

    return AppSemantics.container(
      label: onBuyTap != null
          ? content.title
          : '${content.title}, ${l10n.storeBuyToUnlock}',
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: onBuyTap != null ? design.spacing.xs : design.spacing.sm,
        ),
        child: Row(
          children: [
            // Content Type Icon
            Icon(
              _getContentIcon(content.type),
              size: design.iconSize.sm,
              color: design.colors.textSecondary,
            ),
            SizedBox(width: design.spacing.md),

            // Content Title
            Expanded(
              child: AppText.bodySmall(
                content.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: design.spacing.sm),

            // Status Badge / Lock
            badge,
          ],
        ),
      ),
    );
  }
}
