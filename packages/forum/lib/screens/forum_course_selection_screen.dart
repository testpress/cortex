import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import '../providers/forum_providers.dart';
import '../widgets/forum_header.dart';

class ForumCourseSelectionScreen extends ConsumerStatefulWidget {
  const ForumCourseSelectionScreen({super.key});

  @override
  ConsumerState<ForumCourseSelectionScreen> createState() => _ForumCourseSelectionScreenState();
}

class _ForumCourseSelectionScreenState extends ConsumerState<ForumCourseSelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Use the official post-frame callback pattern used in StudyScreen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(courseListProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(color: design.colors.surface),
      child: Column(
        children: [
          ForumHeader(title: l10n.forumTitle),
          Expanded(child: _ForumBody()),
        ],
      ),
    );
  }
}

class _ForumBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(courseListProvider);
    final isSyncing = ref.watch(isSyncingInitialPage);

    return coursesAsync.when(
      data: (courses) {
        if (courses.isEmpty && isSyncing) {
          return const Center(child: AppLoadingIndicator());
        }
        return _CourseSelectionList(courses: courses);
      },
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (error, _) => _ErrorMessage(message: error.toString()),
    );
  }
}

class _CourseSelectionList extends StatelessWidget {
  final List<CourseDto> courses;

  const _CourseSelectionList({required this.courses});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    if (courses.isEmpty) {
      return Center(
        child: AppText.body(
          l10n.forumNoDiscussions,
          color: design.colors.textSecondary,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.md,
      ),
      itemCount: courses.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.only(bottom: design.spacing.sm),
            child: AppText.bodySmall(
              l10n.forumSelectCourse,
              color: design.colors.textSecondary,
            ),
          );
        }
        return _CourseItem(course: courses[index - 1]);
      },
    );
  }
}

class _CourseItem extends StatelessWidget {
  final CourseDto course;

  const _CourseItem({required this.course});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: design.spacing.sm),
      child: AppCard(
        onTap: () => context.push('/home/forum/posts/${course.id}'),
        showShadow: true,
        padding: EdgeInsets.all(design.spacing.md),
        child: Row(
          children: [
            _CourseInfo(course: course),
            Icon(
              LucideIcons.chevronRight,
              size: 20,
              color: design.colors.textSecondary.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseInfo extends ConsumerWidget {
  final CourseDto course;

  const _CourseInfo({required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final threadsAsync = ref.watch(courseForumThreadsProvider(course.id));

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.cardTitle(
            course.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          threadsAsync.when(
            data: (threads) => AppText.caption(
              l10n.forumThreadsCount(threads.length),
              color: design.colors.textSecondary,
            ),
            loading: () => AppText.caption(
              '...',
              color: design.colors.textSecondary.withValues(alpha: 0.5),
            ),
            error: (_, __) => AppText.caption(
              '--',
              color: design.colors.textSecondary.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  final String message;

  const _ErrorMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppText.body('Error: $message'),
    );
  }
}
