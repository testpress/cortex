import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

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
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: design.colors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.lock,
            size: design.iconSize.xs,
            color: design.colors.textSecondary,
          ),
          SizedBox(width: design.spacing.xs),
          AppText.caption(
            l10n.storeBuyToUnlock,
            color: design.colors.textSecondary,
          ),
        ],
      ),
    );

    final Widget badge;
    if (onBuyTap != null) {
      badge = AppSemantics.button(
        label: l10n.storeBuyToUnlock,
        onTap: onBuyTap,
        child: GestureDetector(
          onTap: onBuyTap,
          behavior: HitTestBehavior.opaque,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 48,
              minWidth: 48,
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
      label: '${content.title}, ${l10n.storeBuyToUnlock}',
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
