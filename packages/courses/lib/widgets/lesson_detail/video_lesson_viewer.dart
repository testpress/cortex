import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../../models/course_content.dart';
import 'custom_video_player.dart';
import 'video_tabs.dart';
import 'video_mcq_tab.dart';

/// A rich video viewer component that includes the player, title, and tabs.
/// Designed to be used within [LessonDetailOrchestrator].
class VideoLessonViewer extends StatefulWidget {
  const VideoLessonViewer({
    super.key,
    required this.lesson,
    this.onComplete,
    this.footerBuilder,
    this.onOpenMcqFilterSheet,
    this.mcqDifficulty = 'medium',
    this.mcqQuestionCount = 10,
  });

  final Lesson lesson;
  final VoidCallback? onComplete;
  final WidgetBuilder? footerBuilder;
  final VoidCallback? onOpenMcqFilterSheet;
  final String mcqDifficulty;
  final int mcqQuestionCount;

  @override
  State<VideoLessonViewer> createState() => _VideoLessonViewerState();
}

class _VideoLessonViewerState extends State<VideoLessonViewer>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<VideoLessonTab> _activeTabs;
  final _videoPlayerKey = GlobalKey<CustomVideoPlayerState>();
  final _videoPositionNotifier = ValueNotifier<Duration>(Duration.zero);
  final _isAutoScrollEnabledNotifier = ValueNotifier<bool>(true);
  int _currentTabIndex = 0;

  void _handleSeek(Duration target) {
    _videoPlayerKey.currentState?.seek(target);
  }

  List<VideoLessonTab> _getTabsForLesson(Lesson lesson) {
    final tabs = <VideoLessonTab>[];
    if (lesson.isAiEnabled &&
        lesson.aiNotesUrl != null &&
        lesson.aiNotesUrl!.isNotEmpty) {
      tabs.add(VideoLessonTab.notes);
    }
    if (lesson.enableTranscript) {
      tabs.add(VideoLessonTab.transcript);
    }
    // Doubt is always enabled
    tabs.add(VideoLessonTab.askDoubt);

    final bool isAiAvailable = lesson.isAiEnabled &&
        lesson.canEnableLearnlensAi &&
        lesson.learnlensAssetStatus?.toLowerCase() == 'completed';

    if (isAiAvailable) {
      tabs.add(VideoLessonTab.aiSupport);
      tabs.add(VideoLessonTab.aiMcq);
    }
    return tabs;
  }

  void _initTabController() {
    _activeTabs = _getTabsForLesson(widget.lesson);
    _tabController = TabController(
      length: _activeTabs.length,
      vsync: this,
      animationDuration: Duration.zero,
    );
    _currentTabIndex = _tabController.index;
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.index != _currentTabIndex) {
      _currentTabIndex = _tabController.index;
      final isTranscriptTab =
          _activeTabs[_currentTabIndex] == VideoLessonTab.transcript;
      if (isTranscriptTab) {
        _isAutoScrollEnabledNotifier.value = true;
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _initTabController();
  }

  @override
  void didUpdateWidget(VideoLessonViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newTabs = _getTabsForLesson(widget.lesson);
    final oldTabs = _getTabsForLesson(oldWidget.lesson);

    bool tabsChanged = newTabs.length != oldTabs.length;
    if (!tabsChanged) {
      for (int i = 0; i < newTabs.length; i++) {
        if (newTabs[i] != oldTabs[i]) {
          tabsChanged = true;
          break;
        }
      }
    }

    if (tabsChanged) {
      _tabController.removeListener(_handleTabSelection);
      _tabController.dispose();
      _activeTabs = newTabs;
      _tabController = TabController(
        length: _activeTabs.length,
        vsync: this,
        animationDuration: Duration.zero,
      );
      _tabController.addListener(_handleTabSelection);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _videoPositionNotifier.dispose();
    _isAutoScrollEnabledNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // By keeping the tree structure identical (Column -> SizedBox -> Player),
            // Flutter will NOT kill and recreate the video player state.
            // We simply shrink its background height in landscape to prevent the 264px overflow.
            SizedBox(
              height: isLandscape ? 0 : null,
              child: _buildVideoSection(design),
            ),
            Container(
              decoration: BoxDecoration(
                color: design.colors.surface,
                border: Border(
                  bottom: BorderSide(
                    color: design.colors.divider.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
              ),
              child: _buildTabBar(context, design),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: _activeTabs.map(_buildTabWidget).toList(),
              ),
            ),
          ],
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _isAutoScrollEnabledNotifier,
          builder: (context, isAutoScrollEnabled, _) {
            final isTranscriptTab =
                _activeTabs[_tabController.index] == VideoLessonTab.transcript;
            if (!isAutoScrollEnabled && isTranscriptTab) {
              return Positioned(
                bottom: widget.footerBuilder != null ? 60 : 12,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(18.0),
                    clipBehavior: Clip.antiAlias,
                    child: AppButton.primary(
                      label: L10n.of(context).videoLessonSyncToVideo,
                      onPressed: () {
                        _isAutoScrollEnabledNotifier.value = true;
                      },
                      height: 36.0,
                      padding:
                          EdgeInsets.symmetric(horizontal: design.spacing.md),
                      leading:
                          const Icon(Icons.sync, size: 16, color: Colors.white),
                      labelStyle: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildTabWidget(VideoLessonTab tab) {
    switch (tab) {
      case VideoLessonTab.notes:
        return _buildTabContent(
            NotesTab(
                lesson: widget.lesson, isSliver: true, onSeek: _handleSeek),
            isSliver: true);
      case VideoLessonTab.transcript:
        return TranscriptsTab(
          lesson: widget.lesson,
          onSeek: _handleSeek,
          videoPositionNotifier: _videoPositionNotifier,
          isAutoScrollEnabledNotifier: _isAutoScrollEnabledNotifier,
          isActive:
              _activeTabs[_tabController.index] == VideoLessonTab.transcript,
        );
      case VideoLessonTab.askDoubt:
        return DoubtTab(
          lesson: widget.lesson,
          footerBuilder: widget.footerBuilder,
          onBeforeNavigate: () =>
              _videoPlayerKey.currentState?.finalizePlayback(),
          onResumeVideo: () => _videoPlayerKey.currentState?.restorePlayback(),
        );
      case VideoLessonTab.aiSupport:
        return AITab(
          lesson: widget.lesson,
          onSeek: _handleSeek,
          footerBuilder: widget.footerBuilder,
        );
      case VideoLessonTab.aiMcq:
        return _buildTabContent(
          VideoMcqTab(
            lesson: widget.lesson,
            onSeek: _handleSeek,
            onOpenFilterSheet: widget.onOpenMcqFilterSheet,
            difficulty: widget.mcqDifficulty,
            questionCount: widget.mcqQuestionCount,
          ),
        );
    }
  }

  Widget _buildTabContent(Widget child, {bool isSliver = false}) {
    final design = Design.of(context);

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        isSliver ? child : SliverToBoxAdapter(child: child),
        if (widget.footerBuilder != null)
          SliverFillRemaining(
            hasScrollBody: false,
            fillOverscroll: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.footerBuilder!(context),
                  SizedBox(height: design.spacing.sm),
                ],
              ),
            ),
          )
        else
          SliverToBoxAdapter(child: SizedBox(height: design.spacing.sm)),
      ],
    );
  }

  Widget _buildVideoSection(DesignConfig design) {
    final isCompleted =
        widget.lesson.progressStatus == LessonProgressStatus.completed;
    final initialPos = isCompleted
        ? 0.0
        : (double.tryParse(widget.lesson.lastWatchedDuration ?? '0') ?? 0.0);

    return CustomVideoPlayer(
      key: _videoPlayerKey,
      lessonId: widget.lesson.id,
      assetId: widget.lesson.contentUrl,
      thumbnailUrl: widget.lesson.image,
      initialPosition: initialPos,
      onComplete: widget.onComplete,
      onPositionChanged: (pos) {
        _videoPositionNotifier.value = pos;
      },
      onSeekOccurred: () {
        _isAutoScrollEnabledNotifier.value = true;
      },
    );
  }

  Tab _buildTabHeader(BuildContext context, VideoLessonTab tab) {
    switch (tab) {
      case VideoLessonTab.notes:
        return Tab(text: L10n.of(context).videoLessonTabNotes);
      case VideoLessonTab.transcript:
        return Tab(text: L10n.of(context).videoLessonTabTranscript);
      case VideoLessonTab.askDoubt:
        return Tab(text: L10n.of(context).videoLessonTabAskDoubt);
      case VideoLessonTab.aiSupport:
        return Tab(text: L10n.of(context).videoLessonTabAiSupport);
      case VideoLessonTab.aiMcq:
        return Tab(text: L10n.of(context).videoLessonTabMcq);
    }
  }

  Widget _buildTabBar(BuildContext context, DesignConfig design) {
    final isSingleTab = _activeTabs.length == 1;
    return TabBar(
      controller: _tabController,
      isScrollable: isSingleTab,
      tabAlignment: isSingleTab ? TabAlignment.start : TabAlignment.fill,
      labelColor: design.colors.primary,
      unselectedLabelColor: design.colors.textSecondary,
      indicatorColor: design.colors.primary,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      unselectedLabelStyle:
          const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      tabs: _activeTabs.map((tab) => _buildTabHeader(context, tab)).toList(),
    );
  }
}
