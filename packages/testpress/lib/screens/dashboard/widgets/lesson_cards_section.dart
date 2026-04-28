import 'package:flutter/material.dart';
import 'package:core/core.dart'; // Assumes Design, AppCarousel, etc.
import 'package:core/data/data.dart';

class LessonCardModel {
  final String id;
  final String title;
  final String chapterName;
  final String subject;
  final double? progress; // 0 to 100
  final String? duration;
  final String? coverImage;
  final String? instructor;

  const LessonCardModel({
    required this.id,
    required this.title,
    required this.chapterName,
    required this.subject,
    this.progress,
    this.duration,
    this.coverImage,
    this.instructor,
  });
}

class LessonCardWidget extends StatelessWidget {
  final LessonCardModel lesson;
  final bool isCompleted;

  const LessonCardWidget({
    super.key,
    required this.lesson,
    this.isCompleted = false,
  });

  Color _getSubjectColor(String subject) {
    switch (subject) {
      case 'Physics':
        return Colors.purple;
      case 'Chemistry':
        return Colors.teal; // using teal for emerald
      case 'Mathematics':
        return Colors.orange;
      case 'Biology':
        return Colors.green;
      case 'English':
        return Colors.pink;
      default:
        return Colors.blue;
    }
  }

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
            SizedBox(
              height: 92,
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
                            color: _getSubjectColor(lesson.subject),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.menu_book,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),

                  // Subject Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getSubjectColor(lesson.subject),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        lesson.subject,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
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
                            const SizedBox(height: 1),
                            Text(
                              lesson.chapterName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                height: 16 / 12,
                                color: textSecondary,
                              ),
                            ),
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
                  Row(
                    children: [
                      if (lesson.instructor != null) ...[
                        Expanded(
                          child: Text(
                            lesson.instructor!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: textMuted,
                            ),
                          ),
                        ),
                        if (lesson.duration != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              '•',
                              style: TextStyle(fontSize: 11, color: textMuted),
                            ),
                          ),
                      ],
                      if (lesson.duration != null)
                        Text(
                          lesson.duration!,
                          style: TextStyle(
                            fontSize: 11,
                            color: textMuted,
                          ),
                        ),
                    ],
                  ),
                  // Progress Bar
                  if (lesson.progress != null && lesson.progress! > 0) ...[
                    const Spacer(),
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
                            color: Colors.blue,
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
  final List<LessonCardModel> resumeLessons;
  final List<LessonCardModel> whatsNewLessons;
  final List<LessonCardModel> recentlyCompletedLessons;
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
    List<LessonCardModel> lessons, {
    bool isCompleted = false,
  }) {
    if (lessons.isEmpty) return const SizedBox.shrink();

    final design = Design.of(context);

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
          height: 204, // Increased height for better aspect ratio
          viewportFraction: 0.45, // Slightly narrower cards for better balance
          padEnds: false, // Align items to the left
          itemPadding: EdgeInsets.only(left: design.spacing.md), // Reduced gap
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            return Container(
               margin: const EdgeInsets.only(bottom: 16.0), // For Box Shadow
               child: LessonCardWidget(
                 lesson: lesson,
                 isCompleted: isCompleted,
               ),
            );
          },
        ),
        SizedBox(height: design.spacing.xs),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (config.showResumeSection)
          _buildCarouselSection(
            context,
            'Resume',
            resumeLessons,
          ),
        if (config.showWhatsNewSection)
          _buildCarouselSection(
            context,
            "What's New",
            whatsNewLessons,
          ),
        if (config.showRecentlyCompletedSection)
          _buildCarouselSection(
            context,
            'Recently Completed',
            recentlyCompletedLessons,
            isCompleted: true,
          ),
      ],
    );
  }
}
