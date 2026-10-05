import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import 'package:skeletonizer/skeletonizer.dart';

const _skeletonLesson = DashboardContentDto(
  id: 'skeleton',
  title: 'Loading lesson title placeholder...',
  chapterTitle: 'Chapter title skeleton',
  contentType: DashboardContentType.video,
);

/// A screen that displays a vertical list of dashboard lessons
/// for Resume Learning, What's New, or Recently Completed feeds.
class DashboardLessonsListScreen extends ConsumerWidget {
  final String title;
  final DashboardSectionType sectionType;
  final List<DashboardContentDto>? initialLessons;
  final bool isCompleted;

  const DashboardLessonsListScreen({
    super.key,
    required this.title,
    required this.sectionType,
    this.initialLessons,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final AsyncValue<List<DashboardContentDto>> streamAsync =
        switch (sectionType) {
          DashboardSectionType.resumeLearning => ref.watch(
            resumeLearningFeedProvider,
          ),
          DashboardSectionType.whatsNew => ref.watch(whatsNewFeedProvider),
          DashboardSectionType.completedLearning => ref.watch(
            recentlyCompletedFeedProvider,
          ),
        };

    final isInitialLoading = ref.watch(isDashboardInitialLoadingProvider);
    final lessons = streamAsync.valueOrNull ?? initialLessons ?? [];
    final showSkeleton = isInitialLoading && lessons.isEmpty;

    return AppShell(
      backgroundColor: design.colors.canvas,
      child: Column(
        children: [
          AppHeader(
            title: title,
            leading: AppBackButton(onTap: () => context.pop()),
            showDivider: true,
          ),
          Expanded(
            child: AppRefreshIndicator(
              semanticsLabel: l10n.pullToRefresh,
              onRefresh: () async {
                try {
                  final repo = await ref.read(
                    dashboardRepositoryProvider.future,
                  );
                  await repo.refreshDashboard();
                } catch (_) {}
              },
              child: Skeletonizer(
                enabled: showSkeleton,
                child: showSkeleton
                    ? ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: EdgeInsets.all(design.spacing.md),
                        itemCount: 5,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: design.spacing.sm),
                        itemBuilder: (context, index) =>
                            DashboardLessonListItem(
                              lesson: _skeletonLesson,
                              isCompleted: false,
                              isResume:
                                  sectionType ==
                                  DashboardSectionType.resumeLearning,
                            ),
                      )
                    : lessons.isEmpty
                    ? LayoutBuilder(
                        builder: (context, constraints) =>
                            SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(design.spacing.xl),
                                    child: AppText.body(
                                      l10n.infoPageEmptyState,
                                      color: design.colors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      )
                    : AppSemantics.scrollableList(
                        itemCount: lessons.length,
                        label: title,
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: EdgeInsets.all(design.spacing.md),
                          itemCount: lessons.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: design.spacing.sm),
                          itemBuilder: (context, index) {
                            final lesson = lessons[index];
                            return DashboardLessonListItem(
                              lesson: lesson,
                              isCompleted: isCompleted,
                              isResume:
                                  sectionType ==
                                  DashboardSectionType.resumeLearning,
                            );
                          },
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardLessonListItem extends StatelessWidget {
  final DashboardContentDto lesson;
  final bool isCompleted;
  final bool isResume;

  const DashboardLessonListItem({
    super.key,
    required this.lesson,
    this.isCompleted = false,
    this.isResume = false,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final textMuted = design.colors.textSecondary.withValues(alpha: 0.7);
    final duration = lesson.totalDuration ?? lesson.remainingDuration;
    final hasChapter =
        lesson.chapterTitle != null && lesson.chapterTitle!.isNotEmpty;
    final hasDuration = duration != null && duration.isNotEmpty;
    final formattedDuration = isResume
        ? (lesson.remainingDuration != null
              ? l10n.testTimeLeft(lesson.remainingDuration!)
              : lesson.totalDuration)
        : duration;

    final semanticLabel = [
      lesson.title,
      if (hasChapter) lesson.chapterTitle!,
      ?formattedDuration,
    ].join(', ');

    void guardedOnTap() {
      if (lesson.id == 'skeleton') return;
      LessonRouter.navigateToLesson(
        context,
        id: lesson.id,
        type: lesson.contentType,
        extra: lesson.toLessonDto(),
      );
    }

    return AppSemantics.button(
      label: semanticLabel,
      onTap: guardedOnTap,
      enabled: lesson.id != 'skeleton',
      child: AppFocusable(
        onTap: guardedOnTap,
        borderRadius: BorderRadius.circular(design.spacing.md),
        child: Container(
          decoration: BoxDecoration(
            color: design.colors.card,
            borderRadius: BorderRadius.circular(design.spacing.md),
            boxShadow: [
              BoxShadow(
                color: design.colors.shadow,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.all(design.spacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Cover Image Area (Strict 16:9 ratio: 128x72)
                ClipRRect(
                  borderRadius: BorderRadius.circular(design.spacing.sm),
                  child: SizedBox(
                    width: 128,
                    height: 72,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (lesson.coverImage != null &&
                            lesson.coverImage!.isNotEmpty)
                          CachedNetworkImage(
                            imageUrl: lesson.coverImage!,
                            fit: BoxFit.cover,
                            fadeInDuration: Duration.zero,
                            filterQuality: FilterQuality.high,
                            memCacheWidth: 300,
                            errorWidget: (context, url, error) => Container(
                              color: design.colors.surfaceVariant,
                              child: Icon(
                                LucideIcons.book,
                                color: design.colors.primary,
                                size: 20,
                              ),
                            ),
                          )
                        else
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  design.colors.surfaceVariant,
                                  design.colors.canvas,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                LucideIcons.book,
                                color: design.colors.primary,
                                size: 20,
                              ),
                            ),
                          ),
                        if (lesson.progress != null)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: design.colors.surface.withValues(
                                  alpha: 0.85,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: AppText.labelSmall(
                                '${lesson.progress!.toInt()}%',
                                color: design.colors.textPrimary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: design.spacing.sm),
                // Content Area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText.cardTitle(
                        lesson.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (isResume) ...[
                        if (hasChapter) ...[
                          const SizedBox(height: 2),
                          AppText.cardSubtitle(
                            lesson.chapterTitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ],
                        if (formattedDuration != null) ...[
                          const SizedBox(height: 4),
                          AppText.cardCaption(
                            formattedDuration,
                            color: textMuted,
                          ),
                        ],
                        if (lesson.progress != null && !isCompleted) ...[
                          const SizedBox(height: 6),
                          AppSemantics.progressValue(
                            value: (lesson.progress! / 100).clamp(0.0, 1.0),
                            label: l10n.labelCourseProgress,
                            child: Container(
                              height: 3,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: design.colors.surfaceVariant,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: (lesson.progress! / 100).clamp(
                                  0.0,
                                  1.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: design.colors.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ] else ...[
                        // Recently Completed and What's New:
                        // Duration shown on the right side of the chapter/Exams
                        if (hasChapter || hasDuration) ...[
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              if (hasChapter)
                                Flexible(
                                  child: AppText.cardSubtitle(
                                    lesson.chapterTitle!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              if (hasChapter && hasDuration) ...[
                                AppText.cardSubtitle(
                                  ' • ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: textMuted,
                                  ),
                                ),
                              ],
                              if (hasDuration)
                                AppText.cardCaption(duration, color: textMuted),
                            ],
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Vertically centered chevron
                Icon(
                  LucideIcons.chevronRight,
                  size: design.iconSize.sm,
                  color: textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
