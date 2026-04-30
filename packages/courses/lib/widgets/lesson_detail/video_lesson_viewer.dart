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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(child: _buildVideoSection(design)),
        Container(
          color: design.colors.surface,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              design.spacing.md,
              design.spacing.sm,
              design.spacing.md,
              design.spacing.md,
            ),
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
                    height: 1.1,
                  ),
                ),
                if (widget.lesson.subtitle?.isNotEmpty ?? false) ...[
                  SizedBox(height: design.spacing.xs),
                  AppText.body(
                    widget.lesson.subtitle!,
                    color: design.colors.textSecondary,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
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
            children: [
              _buildTabContent(NotesTab(
                lesson: widget.lesson,
              )),
              _buildTabContent(TranscriptsTab(lesson: widget.lesson)),
              _buildTabContent(DoubtTab(lesson: widget.lesson)),
              _buildTabContent(AITab(lesson: widget.lesson)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent(Widget child) {
    final design = Design.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          child,
          if (widget.footerBuilder != null) widget.footerBuilder!(context),
          SizedBox(height: design.spacing.sm),
        ],
      ),
    );
  }

  Widget _buildVideoSection(DesignConfig design) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: CustomVideoPlayer(
        assetId: widget.lesson.contentUrl,
        onComplete: widget.onComplete,
      ),
    );
  }


  Widget _buildTabBar(BuildContext context, DesignConfig design) {
    return TabBar(
      controller: _tabController,
      labelColor: design.colors.primary,
      unselectedLabelColor: design.colors.textSecondary,
      indicatorColor: design.colors.primary,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      tabs: [
        Tab(text: L10n.of(context).videoLessonTabNotes),
        Tab(text: L10n.of(context).videoLessonTabTranscript),
        Tab(text: L10n.of(context).videoLessonTabAskDoubt),
        Tab(text: L10n.of(context).videoLessonTabAiSupport),
      ],
    );
  }
}
