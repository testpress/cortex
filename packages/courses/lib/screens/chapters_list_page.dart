import 'dart:async';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/course_detail_provider.dart';
import '../providers/course_list_provider.dart';
import '../widgets/chapters_filter_tab_bar.dart';
import '../widgets/chapter_curriculum_item.dart';
import '../widgets/curriculum_header.dart';
import '../widgets/lesson_list_item.dart';

/// Screen displaying the full curriculum (chapters and lessons) of a course.
class ChaptersListPage extends ConsumerStatefulWidget {
  const ChaptersListPage({
    super.key,
    required this.courseId,
    this.parentId,
    this.onBack,
    this.showFilters = true,
    this.basePath = '/study',
  });

  final String courseId;
  final String? parentId;
  final VoidCallback? onBack;
  final bool showFilters;
  final String basePath;

  @override
  ConsumerState<ChaptersListPage> createState() => _ChaptersListPageState();
}

class _ChaptersListPageState extends ConsumerState<ChaptersListPage> {
  CurriculumFilter _activeFilter = CurriculumFilter.all;
  List<LessonDto> _apiResults = [];
  bool _isLoadingFilter = false;
  StreamSubscription<List<LessonDto>>? _filterSub;
  StreamSubscription<List<LessonDto>>? _dbSub;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (_filterSub != null && _filterSub!.isPaused) {
        setState(() => _isLoadingFilter = true);
        _filterSub!.resume();
      }
    }
  }

  void _onFilterChanged(CurriculumFilter filter) {
    _filterSub?.cancel();
    _dbSub?.cancel();
    _apiResults = [];
    setState(() {
      _activeFilter = filter;
      _isLoadingFilter = filter != CurriculumFilter.all;
    });
    if (filter != CurriculumFilter.all) {
      _loadFilteredContents(filter);
    }
  }

  Future<void> _loadFilteredContents(CurriculumFilter filter) async {
    try {
      final repo = ref.read(courseRepositoryProvider).requireValue;
      final type = _apiTypeForFilter(filter);
      
      // 1. Watch the local database for instant results
      final dbStream = repo.watchFilteredLessonsLocal(
        widget.courseId,
        chapterId: widget.parentId,
        type: type,
      );
      _dbSub = dbStream.listen((lessons) {
        if (!mounted) return;
        setState(() => _apiResults = lessons);
      });

      // 2. Run the API stream in the background for sync
      final apiStream = repo.streamFilteredContents(
        widget.courseId,
        chapterId: widget.parentId,
        type: type,
      );
      _filterSub = apiStream.listen((_) {
        _filterSub?.pause();
        if (mounted) {
          setState(() => _isLoadingFilter = false);
        }
      }, onError: (e) {
        if (!mounted) return;
        setState(() => _isLoadingFilter = false);
      }, onDone: () {
        if (!mounted) return;
        setState(() => _isLoadingFilter = false);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingFilter = false);
    }
  }

  String? _apiTypeForFilter(CurriculumFilter filter) {
    return switch (filter) {
      CurriculumFilter.all => null,
      CurriculumFilter.lesson => null,
      CurriculumFilter.video => 'video',
      CurriculumFilter.assessment => 'assessment',
      CurriculumFilter.test => 'test',
    };
  }

  List<LessonDto> _filteredResults() {
    if (_activeFilter == CurriculumFilter.all) return _apiResults;
    if (_activeFilter == CurriculumFilter.lesson) return _apiResults;
    final targetType = switch (_activeFilter) {
      CurriculumFilter.video => LessonType.video,
      CurriculumFilter.assessment => LessonType.assessment,
      CurriculumFilter.test => LessonType.test,
      _ => throw UnimplementedError(),
    };
    return _apiResults.where((l) => l.type == targetType).toList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _filterSub?.cancel();
    _dbSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final chaptersAsync = ref.watch(
      subChaptersProvider(widget.courseId, widget.parentId),
    );
    final courseAsync = ref.watch(courseDetailProvider(widget.courseId));
    return Container(
      color: design.colors.canvas,
      child: chaptersAsync.when(
        data: (chapters) {
          final course = courseAsync.maybeWhen(
            data: (c) => c,
            orElse: () => null,
          );

          final filteredLessons = _filteredResults();
          final showChapters = _activeFilter == CurriculumFilter.all && chapters.isNotEmpty && _apiResults.isEmpty;
          String headerTitle = course?.title ?? 'Curriculum';

          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: design.colors.card,
                  border: Border(
                    bottom: BorderSide(color: design.colors.border, width: 1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CurriculumHeader(
                      courseTitle: headerTitle,
                      chapterCount: chapters.length,
                      onBack: widget.onBack,
                    ),
                    if (widget.showFilters)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ChaptersFilterTabBar(
                          activeFilter: _activeFilter,
                          onFilterChanged: _onFilterChanged,
                        ),
                      ),
                  ],
                ),
              ),

              Expanded(
                child: showChapters
                  ? AppScroll(
                      padding: EdgeInsets.symmetric(
                        horizontal: design.spacing.md,
                        vertical: design.spacing.md,
                      ),
                      children: [
                        ...chapters.asMap().entries.map((entry) {
                          final chapter = entry.value;
                          return ChapterCurriculumItem(
                            chapter: chapter,
                            index: entry.key,
                            onTap: () {
                              if (chapter.isLeaf) {
                                context.push(
                                  '${widget.basePath}/course/${widget.courseId}/chapters/${chapter.id}',
                                );
                              } else {
                                context.push(
                                  '${widget.basePath}/course/${widget.courseId}/chapters?parentId=${chapter.id}',
                                );
                              }
                            },
                          );
                        }),
                        const SizedBox(height: 80),
                      ],
                    )
                  : filteredLessons.isEmpty && !_isLoadingFilter
                      ? Center(
                          child: AppText.body(
                            'No ${widget.showFilters ? _activeFilter.displayName : "exams"} found.',
                            color: design.colors.textSecondary,
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(
                            horizontal: design.spacing.md,
                            vertical: design.spacing.md,
                          ),
                          itemCount: filteredLessons.length + (_isLoadingFilter ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < filteredLessons.length) {
                              final lesson = filteredLessons[index];
                              return LessonListItem(
                                lesson: lesson,
                                onTap: () {
                                  final route = switch (lesson.type) {
                                    LessonType.video ||
                                    LessonType.pdf ||
                                    LessonType.notes ||
                                    LessonType.embedContent ||
                                    LessonType.liveStream ||
                                    LessonType.attachment =>
                                      '${widget.basePath}/lesson/${lesson.id}',
                                    LessonType.assessment =>
                                      '${widget.basePath}/assessment/${lesson.id}',
                                    LessonType.test => '${widget.basePath}/test/${lesson.id}',
                                    LessonType.unknown => null,
                                  };
                                  if (route != null) context.push(route);
                                },
                              );
                            }
                            return const Padding(
                              padding: EdgeInsets.all(24),
                              child: Center(child: AppLoadingIndicator()),
                            );
                          },
                        ),
              ),
            ],
          );
        },
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (error, _) => Center(child: AppText.body(error.toString())),
      ),
    );
  }
}
