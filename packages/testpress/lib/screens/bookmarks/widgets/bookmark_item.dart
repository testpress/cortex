import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

class BookmarkItem extends StatelessWidget {
  const BookmarkItem({
    super.key,
    required this.item,
    required this.onTap,
    this.onMoreTap,
  });

  final Map<String, dynamic> item;
  final VoidCallback onTap;
  final VoidCallback? onMoreTap;

  bool get _isQuestion {
    final type = (item['contentType'] as String?)?.toLowerCase() ?? '';
    return type == 'question' || type == 'userselectedanswer';
  }

  static final RegExp _htmlTagRegExp = RegExp(r'<[^>]*>', multiLine: true);

  String get _plainTitle {
    final raw = item['title'] as String? ?? '';
    return raw.replaceAll(_htmlTagRegExp, '').trim();
  }

  LessonType _parseLessonType(String type) {
    switch (type.toLowerCase()) {
      case 'video':
      case 'livestream':
        return LessonType.video;
      case 'pdf':
      case 'attachment':
        return LessonType.pdf;
      case 'notes':
      case 'html':
        return LessonType.notes;
      case 'test':
      case 'exam':
      case 'quiz':
      case 'assessment':
        return LessonType.test;
      case 'post':
      case 'notice':
        return LessonType.notes;
      case 'question':
      default:
        return LessonType.unknown;
    }
  }

  IconData _getIconForType(String type, LessonType lessonType) {
    switch (type.toLowerCase()) {
      case 'forumpost':
        return LucideIcons.messageSquare;
      case 'post':
        return LucideIcons.fileText;
      case 'notice':
        return LucideIcons.bell;
      case 'question':
        return LucideIcons.helpCircle;
      default:
        return lessonType.icon;
    }
  }

  ShortcutColors _getThemeForType(
    String type,
    LessonType lessonType,
    DesignConfig design,
  ) {
    switch (type.toLowerCase()) {
      case 'forumpost':
        return design.shortcutPalette.atIndex(3); // green
      case 'post':
        return design.shortcutPalette.atIndex(0); // Purple
      case 'notice':
        return design.shortcutPalette.atIndex(2); // Orange
      case 'question':
        return design.shortcutPalette.atIndex(4); // Cyan
      default:
        return switch (lessonType) {
          LessonType.video ||
          LessonType.liveStream ||
          LessonType.embedContent => design.study.video,
          LessonType.pdf ||
          LessonType.notes ||
          LessonType.attachment => design.study.pdf,
          LessonType.assessment => design.study.assessment,
          LessonType.test => design.study.test,
          LessonType.unknown => design.study.video,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final lessonType = _parseLessonType(item['contentType'] as String);
    final typeTheme = _getThemeForType(
      item['contentType'] as String,
      lessonType,
      design,
    );

    return AppCard(
      showShadow: true,
      onTap: onTap,
      padding: EdgeInsets.all(design.spacing.md),
      child: Row(
        children: [
          // Thumbnail
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color:
                      item['thumbnailColor'] as Color? ?? typeTheme.background,
                  borderRadius: BorderRadius.circular(design.radius.md),
                ),
                child: Center(
                  child: Icon(
                    _getIconForType(item['contentType'] as String, lessonType),
                    color: item['iconColor'] as Color? ?? typeTheme.foreground,
                    size: 28,
                  ),
                ),
              ),
              if (item.containsKey('duration'))
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: design.colors.textPrimary.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(design.radius.sm),
                    ),
                    child: AppText.xs(
                      item['duration'] as String,
                      color: design.colors.canvas,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: design.spacing.md),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isQuestion
                    ? AppHtmlV2(
                        data: item['title'] as String? ?? '',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textHeight: 1.4,
                        maxLines: 2,
                        disableImageZoom: true,
                      )
                    : AppText.bodySmall(
                        _plainTitle,
                        color: design.colors.textPrimary,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                SizedBox(height: design.spacing.xs),
                Builder(
                  builder: (context) {
                    final chapterName = item['chapterName'] as String?;

                    if (chapterName == null || chapterName.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: EdgeInsets.only(bottom: design.spacing.xs),
                      child: AppText.xs(
                        chapterName,
                        color: design.colors.textSecondary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
                Row(
                  children: [
                    AppText.xs(
                      item['savedDate'] as String,
                      color: design.colors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onMoreTap != null)
            AppFocusable(
              onTap: onMoreTap,
              child: Padding(
                padding: EdgeInsets.only(left: design.spacing.sm),
                child: Icon(
                  LucideIcons.moreVertical,
                  size: 20,
                  color: design.colors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
