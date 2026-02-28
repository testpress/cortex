import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

/// A part of the sticky header for the Chapters list page.
///
/// Displays the back button, course title, and chapter count.
class CurriculumHeader extends StatelessWidget {
  const CurriculumHeader({
    super.key,
    required this.courseTitle,
    required this.chapterCount,
    this.onBack,
  });

  final String courseTitle;
  final int chapterCount;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    // Get the safe area padding
    final padding = MediaQuery.of(context).padding;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16, // px-4
        padding.top + 12, // py-3
        16,
        12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button
          AppSemantics.button(
            label: l10n.curriculumBackButton,
            onTap: onBack ?? () {},
            child: AppFocusable(
              onTap: onBack,
              borderRadius: design.radius.button,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.chevronLeft,
                    size: 20,
                    color: design.colors.textPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.curriculumBackButton,
                    style: design.typography.label.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: design.colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Course Title
          Text(
            courseTitle,
            style: design.typography.headline.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              height: 1.4,
              color: design.colors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Metadata
          Text(
            l10n.curriculumChaptersCount(chapterCount),
            style: design.typography.caption.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.33,
              color: design.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
