import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// Minimum interactive touch target dimension (48dp) per WCAG 2.5.5 / Android & iOS standards.
const double kMinTouchTargetSize = 48.0;

/// Renders an individual lesson/exam item in the store curriculum tree.
class StoreContentTile extends StatelessWidget {
  final LessonDto content;
  final VoidCallback? onBuyTap;
  final ValueChanged<LessonDto>? onPreviewTap;

  const StoreContentTile({
    super.key,
    required this.content,
    this.onBuyTap,
    this.onPreviewTap,
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

    final isPreview = content.isFreePreview;
    final badgeColor =
        isPreview ? design.colors.success : design.colors.accent2;
    final badgeIcon = isPreview ? LucideIcons.playCircle : LucideIcons.lock;
    final badgeLabel =
        isPreview ? l10n.storeFreePreview : l10n.storeBuyToUnlock;
    final activeAction = isPreview
        ? (onPreviewTap != null ? () => onPreviewTap!(content) : null)
        : onBuyTap;

    final badgeWidget = Container(
      padding: EdgeInsets.symmetric(
        horizontal: isPreview
            ? (design.spacing.sm + design.spacing.xs)
            : design.spacing.sm,
        vertical: design.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(design.radius.sm),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            badgeIcon,
            size: design.iconSize.xs,
            color: badgeColor,
          ),
          SizedBox(width: design.spacing.xs),
          AppText.caption(
            badgeLabel,
            color: badgeColor,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );

    final Widget badge;
    if (activeAction != null) {
      badge = AppSemantics.button(
        label: badgeLabel,
        onTap: activeAction,
        child: AppFocusable(
          onTap: activeAction,
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
      label: activeAction != null
          ? content.title
          : '${content.title}, $badgeLabel',
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical:
              activeAction != null ? design.spacing.xs : design.spacing.sm,
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
