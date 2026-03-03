import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import '../models/course_content.dart';
import '../widgets/lesson_detail/custom_video_player.dart';
import '../widgets/lesson_detail/video_tabs.dart';

class VideoLessonDetailScreen extends ConsumerStatefulWidget {
  const VideoLessonDetailScreen({
    super.key,
    required this.lesson,
    this.onNext,
    this.onPrevious,
  });

  final Lesson lesson;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  @override
  ConsumerState<VideoLessonDetailScreen> createState() =>
      _VideoLessonDetailScreenState();
}

class _VideoLessonDetailScreenState
    extends ConsumerState<VideoLessonDetailScreen>
    with TickerProviderStateMixin {
  final _videoPlayerKey = GlobalKey();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      animationDuration: Duration.zero,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    // Extract video URL from lesson content
    final videoContent = widget.lesson.content
        .whereType<VideoContent>()
        .firstOrNull;
    final videoUrl =
        videoContent?.url ??
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';

    final nextCallback = widget.onNext ?? () {};

    final header = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border(
          bottom: BorderSide(
            color: design.colors.divider.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.md,
          ),
          child: Row(
            children: [
              AppFocusable(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(design.radius.md),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.chevronLeft,
                      size: 20,
                      color: design.colors.textPrimary,
                    ),
                    SizedBox(width: design.spacing.xs),
                    AppText.label(
                      L10n.of(context).curriculumBackButton,
                      color: design.colors.textPrimary,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final videoSection = Container(
      width: double.infinity,
      padding: EdgeInsets.all(design.spacing.md),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(design.radius.lg),
          child: Stack(
            children: [
              CustomVideoPlayer(key: _videoPlayerKey, videoUrl: videoUrl),
              Positioned(
                top: design.spacing.md,
                left: design.spacing.md,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: design.colors.overlay,
                    borderRadius: BorderRadius.circular(design.radius.sm),
                  ),
                  child: AppText.caption(
                    'Lesson ${widget.lesson.lessonNumber ?? '?'} of ${widget.lesson.totalLessons ?? '?'}',
                    color: design.colors.textInverse,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final titleSection = Padding(
      padding: EdgeInsets.all(design.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.headline(
            widget.lesson.title,
            color: design.colors.textPrimary,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          if (widget.lesson.subtitle?.isNotEmpty ?? false) ...[
            SizedBox(height: design.spacing.xs),
            AppText.body(
              widget.lesson.subtitle!,
              color: design.colors.textSecondary,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ],
      ),
    );

    final tabBar = TabBar(
      controller: _tabController,
      labelColor: design.colors.accent2,
      unselectedLabelColor: design.colors.textSecondary,
      labelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        fontFamily: 'PlusJakartaSans',
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        fontFamily: 'PlusJakartaSans',
      ),
      labelPadding: EdgeInsets.zero,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        color: design.colors.accent2.withValues(alpha: 0.08),
        border: Border(
          bottom: BorderSide(color: design.colors.accent2, width: 2.5),
        ),
      ),
      tabs: [
        Tab(text: L10n.of(context).videoLessonTabNotes),
        Tab(text: L10n.of(context).videoLessonTabTranscript),
        Tab(text: L10n.of(context).videoLessonTabAskDoubt),
        Tab(text: L10n.of(context).videoLessonTabAiSupport),
      ],
    );

    return Scaffold(
      backgroundColor: design.colors.surface,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(child: header),
            SliverToBoxAdapter(
              child: Container(
                color: design.colors.surface, // Gray middle section
                child: Column(children: [videoSection, titleSection]),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyTabBarDelegate(
                child: Container(
                  decoration: BoxDecoration(
                    color: design.colors.card,
                    border: Border(
                      bottom: BorderSide(
                        color: design.colors.divider.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                  ),
                  child: tabBar,
                ),
              ),
            ),
          ];
        },
        body: Container(
          color: design.colors.card,
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              NotesTab(lesson: widget.lesson, onNext: nextCallback),
              TranscriptsTab(lesson: widget.lesson, onNext: nextCallback),
              DoubtTab(lesson: widget.lesson, onNext: nextCallback),
              AITab(lesson: widget.lesson, onNext: nextCallback),
            ],
          ),
        ),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyTabBarDelegate({required this.child});

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) =>
      oldDelegate.child != child;
}
