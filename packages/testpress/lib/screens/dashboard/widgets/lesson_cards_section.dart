import 'package:flutter/material.dart';
import 'package:core/core.dart'; 
import 'package:core/data/data.dart';

class LessonCardWidget extends StatelessWidget {
  final DashboardContentDto lesson;
  final bool isCompleted;

  const LessonCardWidget({
    super.key,
    required this.lesson,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final cardBgColor =
        design.isDark ? const Color(0xFF202023) : Colors.white;
    final textPrimary = design.colors.textPrimary;
    final textSecondary = design.colors.textSecondary;
    final textMuted = design.colors.textSecondary.withValues(alpha: 0.7);

    return Opacity(
      opacity: isCompleted ? 0.75 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(design.spacing.md),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: design.isDark ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cover Image Area
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (lesson.coverImage != null)
                    Image.network(
                      lesson.coverImage!,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: design.isDark
                              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                              : [const Color(0xFFF1F5F9), const Color(0xFFE2E8F0)],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: design.colors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.menu_book,
                            color: design.colors.primary,
                            size: 24,
                          ),
                        ),
                      ),
                    ),

                  // Progress Badge
                  if (lesson.progress != null && lesson.progress! > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${lesson.progress!.toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Content Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lesson.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 20 / 14,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                              ),
                              if (lesson.chapterTitle != null) ...[
                                const SizedBox(height: 1),
                                Text(
                                  lesson.chapterTitle!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 16 / 12,
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: textMuted,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Metadata
                    if (lesson.duration != null)
                      Text(
                        lesson.duration!,
                        style: TextStyle(
                          fontSize: 11,
                          color: textMuted,
                        ),
                      ),
                    // Progress Bar
                    if (lesson.progress != null && lesson.progress! > 0) ...[
                      const SizedBox(height: 10),
                      Container(
                        height: 4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: design.isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: (lesson.progress! / 100).clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: design.colors.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LessonCardsSectionWidget extends StatelessWidget {
  static const double _cardContentHeightWithMetadata = 90.0;
  static const double _cardContentHeightCompact = 65.0;
  static const double _carouselBottomMargin = 16.0;

  final List<DashboardContentDto> resumeLessons;
  final List<DashboardContentDto> whatsNewLessons;
  final List<DashboardContentDto> recentlyCompletedLessons;
  final ClientConfig config;

  const LessonCardsSectionWidget({
    super.key,
    required this.resumeLessons,
    required this.whatsNewLessons,
    required this.recentlyCompletedLessons,
    required this.config,
  });

  Widget _buildCarouselSection(
    BuildContext context,
    String title,
    List<DashboardContentDto> lessons, {
    bool isCompleted = false,
    bool showMetadata = true,
  }) {
    if (lessons.isEmpty) return const SizedBox.shrink();

    final design = Design.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth * 0.45; // viewportFraction is 0.45
        
        // Image height (16:9) + Content & Padding + Carousel margin
        final contentHeight = showMetadata 
            ? _cardContentHeightWithMetadata 
            : _cardContentHeightCompact;
            
        final calculatedHeight = (itemWidth / (16 / 9)) + contentHeight + _carouselBottomMargin;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: design.spacing.lg),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: design.colors.textPrimary,
                ),
              ),
            ),
            SizedBox(height: design.spacing.sm),
            AppCarousel(
              itemCount: lessons.length,
              height: calculatedHeight, 
              viewportFraction: 0.45, 
              padEnds: false, 
              itemPadding: EdgeInsets.only(left: design.spacing.md), 
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return Container(
                   margin: const EdgeInsets.only(bottom: 16.0), 
                   child: AppFocusable(
                     onTap: () => LessonRouter.navigateToLesson(
                       context,
                       id: lesson.id,
                       type: lesson.contentType,
                     ),
                     borderRadius: BorderRadius.circular(design.spacing.md),
                     child: LessonCardWidget(
                       lesson: lesson,
                       isCompleted: isCompleted,
                     ),
                   ),
                );
              },
            ),
            SizedBox(height: design.spacing.xs),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (config.showResumeSection)
          _buildCarouselSection(
            context,
            l10n.dashboardResumeTitle,
            resumeLessons,
            showMetadata: true,
          ),
        if (config.showWhatsNewSection)
          _buildCarouselSection(
            context,
            l10n.dashboardWhatsNewTitle,
            whatsNewLessons,
            showMetadata: false,
          ),
        if (config.showRecentlyCompletedSection)
          _buildCarouselSection(
            context,
            l10n.dashboardRecentlyCompletedTitle,
            recentlyCompletedLessons,
            isCompleted: true,
            showMetadata: true,
          ),
      ],
    );
  }
}
