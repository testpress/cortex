import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../../models/course_content.dart';
import 'custom_video_player.dart';
import 'video_tabs.dart';

/// A rich video viewer component that includes the player, title, and tabs.
/// Designed to be used within [LessonDetailOrchestrator].
class VideoLessonViewer extends StatefulWidget {
  const VideoLessonViewer({
    super.key,
    required this.lesson,
    this.onComplete,
    this.footerBuilder,
  });

  final Lesson lesson;
  final VoidCallback? onComplete;
  final WidgetBuilder? footerBuilder;

  @override
  State<VideoLessonViewer> createState() => _VideoLessonViewerState();
}

class _VideoLessonViewerState extends State<VideoLessonViewer>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<VideoLessonTab> _activeTabs;
  final _videoPlayerKey = GlobalKey<CustomVideoPlayerState>();

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
    if (lesson.isAiEnabled) {
      tabs.add(VideoLessonTab.aiSupport);
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
      _tabController.dispose();
      _activeTabs = newTabs;
      _tabController = TabController(
        length: _activeTabs.length,
        vsync: this,
        animationDuration: Duration.zero,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Column(
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
        return _buildTabContent(
            TranscriptsTab(
                lesson: widget.lesson, isSliver: true, onSeek: _handleSeek),
            isSliver: true);
      case VideoLessonTab.askDoubt:
        return DoubtTab(
          lesson: widget.lesson,
          footerBuilder: widget.footerBuilder,
          onBeforeNavigate: () =>
              _videoPlayerKey.currentState?.finalizePlayback(),
          onResumeVideo: () => _videoPlayerKey.currentState?.restorePlayback(),
        );
      case VideoLessonTab.aiSupport:
        return _buildTabContent(AITab(lesson: widget.lesson));
    }
  }

  Widget _buildTabContent(Widget child, {bool isSliver = false}) {
    final design = Design.of(context);
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        isSliver ? child : SliverToBoxAdapter(child: child),
        if (widget.footerBuilder != null)
          SliverToBoxAdapter(child: widget.footerBuilder!(context)),
        SliverToBoxAdapter(child: SizedBox(height: design.spacing.sm)),
      ],
    );
  }

  Widget _buildVideoSection(DesignConfig design) {
    final initialPos =
        double.tryParse(widget.lesson.lastWatchedDuration ?? '0') ?? 0.0;

    return CustomVideoPlayer(
      key: _videoPlayerKey,
      lessonId: widget.lesson.id,
      assetId: widget.lesson.contentUrl,
      thumbnailUrl: widget.lesson.image,
      initialPosition: initialPos,
      onComplete: widget.onComplete,
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
