import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'custom_video_player.dart';
import 'video_processing_view.dart';
import 'video_tabs.dart';
import 'video_mcq_tab.dart';

/// A rich video viewer component that includes the player, title, and tabs.
/// Designed to be used within [LessonDetailOrchestrator].
class VideoLessonViewer extends ConsumerStatefulWidget {
  const VideoLessonViewer({
    super.key,
    required this.lesson,
    this.onComplete,
    this.footerBuilder,
    this.onOpenMcqFilterSheet,
    this.mcqDifficulty = 'medium',
    this.mcqQuestionCount = 10,
  });

  final LessonDto lesson;
  final VoidCallback? onComplete;
  final WidgetBuilder? footerBuilder;
  final VoidCallback? onOpenMcqFilterSheet;
  final String mcqDifficulty;
  final int mcqQuestionCount;

  @override
  ConsumerState<VideoLessonViewer> createState() => _VideoLessonViewerState();
}

class _VideoLessonViewerState extends ConsumerState<VideoLessonViewer>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<VideoLessonTab> _activeTabs;
  final _videoPlayerKey = GlobalKey<CustomVideoPlayerState>();
  final _videoPositionNotifier = ValueNotifier<Duration>(Duration.zero);
  final _isAutoScrollEnabledNotifier = ValueNotifier<bool>(true);
  int _currentTabIndex = 0;
  double? _pendingSpeedForRememberPrompt;
  bool _isSavingPrompt = false;

  void _handleSeek(Duration target) {
    _videoPlayerKey.currentState?.seek(target);
  }

  Future<void> _onPlaybackSpeedChanged(double speed) async {
    if (speed == 1.0) {
      if (_pendingSpeedForRememberPrompt != null) {
        setState(() {
          _pendingSpeedForRememberPrompt = null;
        });
      }
      return;
    }
    try {
      final playbackState = ref.read(playbackSettingsNotifierProvider);
      final settings = playbackState.hasValue
          ? playbackState.requireValue
          : await ref.read(playbackSettingsNotifierProvider.future);
      if (!mounted) return;
      if (settings.rememberPlaybackSpeed) {
        await ref
            .read(playbackSettingsNotifierProvider.notifier)
            .updateGlobalPlaybackSpeed(speed);
        if (_pendingSpeedForRememberPrompt != null) {
          setState(() {
            _pendingSpeedForRememberPrompt = null;
          });
        }
        return;
      }

      final hasDismissed = ref.read(playbackSpeedPromptDismissedProvider);
      if (hasDismissed) return;

      setState(() {
        _pendingSpeedForRememberPrompt = speed;
      });
    } catch (e, st) {
      if (!mounted) return;
      ref.read(sentryServiceProvider).captureException(e, stackTrace: st);
    }
  }

  Future<void> _onAcceptRememberSpeed() async {
    final speed = _pendingSpeedForRememberPrompt;
    if (speed == null || _isSavingPrompt) return;

    setState(() {
      _isSavingPrompt = true;
    });

    try {
      await ref
          .read(playbackSettingsNotifierProvider.notifier)
          .enableRememberPlaybackSpeedAndSave(speed);
      if (!mounted) return;
      setState(() {
        _pendingSpeedForRememberPrompt = null;
        _isSavingPrompt = false;
      });
    } catch (e, st) {
      if (!mounted) return;
      ref.read(sentryServiceProvider).captureException(e, stackTrace: st);
      setState(() {
        _isSavingPrompt = false;
      });
      AppToast.show(
        context,
        message: L10n.of(context).errorGenericMessage,
        isError: true,
      );
    }
  }

  Future<void> _onDismissRememberSpeed() async {
    if (_isSavingPrompt) return;
    setState(() {
      _pendingSpeedForRememberPrompt = null;
    });
    try {
      await ref.read(playbackSpeedPromptDismissedProvider.notifier).dismiss();
    } catch (e, st) {
      if (!mounted) return;
      ref.read(sentryServiceProvider).captureException(e, stackTrace: st);
    }
  }

  Widget _buildRememberSpeedBanner(DesignConfig design) {
    final l10n = L10n.of(context);
    final speed = _pendingSpeedForRememberPrompt ?? 1.0;
    final speedLabel =
        speed == speed.roundToDouble() ? speed.toInt().toString() : '$speed';
    final promptText = l10n.rememberPlaybackSpeedPrompt(speedLabel);

    return AppSemantics.container(
      label: promptText,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
          vertical: design.spacing.xs,
        ),
        decoration: BoxDecoration(
          color: design.colors.card,
          borderRadius: design.radius.card,
          border: Border.all(
            color: design.colors.divider,
          ),
          boxShadow: design.shadows.floating,
        ),
        child: Row(
          children: [
            Expanded(
              child: AppText.bodySmall(
                promptText,
                color: design.colors.textPrimary,
                maxLines: 2,
              ),
            ),
            SizedBox(width: design.spacing.sm),
            _buildPromptButton(
              design: design,
              label: l10n.actionNo,
              onTap: _isSavingPrompt ? null : _onDismissRememberSpeed,
              backgroundColor: design.colors.surfaceVariant,
              textColor: design.colors.textPrimary,
            ),
            SizedBox(width: design.spacing.xs),
            _buildPromptButton(
              design: design,
              label: l10n.actionYes,
              onTap: _isSavingPrompt ? null : _onAcceptRememberSpeed,
              backgroundColor: _isSavingPrompt
                  ? design.colors.border
                  : design.colors.primary,
              textColor: design.colors.onPrimary,
              loading: _isSavingPrompt,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptButton({
    required DesignConfig design,
    required String label,
    required VoidCallback? onTap,
    required Color backgroundColor,
    required Color textColor,
    bool loading = false,
  }) {
    return AppSemantics.button(
      label: label,
      onTap: onTap,
      child: AppFocusable(
        onTap: onTap,
        borderRadius: design.radius.button,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 48.0,
            minHeight: 48.0,
          ),
          child: Center(
            child: Container(
              height: 36,
              padding: EdgeInsets.symmetric(
                horizontal: design.spacing.md,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: design.radius.button,
              ),
              child: loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: AppLoadingIndicator(
                        size: 16,
                      ),
                    )
                  : AppText.labelBold(
                      label,
                      color: textColor,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  List<VideoLessonTab> _getTabsForLesson(
    LessonDto lesson, {
    required bool helpdeskEnabled,
  }) {
    final tabs = <VideoLessonTab>[];
    if (lesson.isAiEnabled &&
        lesson.aiNotesUrl != null &&
        lesson.aiNotesUrl!.isNotEmpty) {
      tabs.add(VideoLessonTab.notes);
    }
    if (lesson.enableTranscript) {
      tabs.add(VideoLessonTab.transcript);
    }
    if (helpdeskEnabled) {
      tabs.add(VideoLessonTab.askDoubt);
    }

    final bool isAiAvailable = lesson.isAiEnabled &&
        lesson.canEnableLearnlensAi &&
        lesson.learnlensAssetStatus?.toLowerCase() == 'completed';

    if (isAiAvailable) {
      tabs.add(VideoLessonTab.aiSupport);
      tabs.add(VideoLessonTab.aiMcq);
    }
    return tabs;
  }

  bool _areTabsEqual(List<VideoLessonTab> a, List<VideoLessonTab> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _syncTabs(bool helpdeskEnabled) {
    final newTabs =
        _getTabsForLesson(widget.lesson, helpdeskEnabled: helpdeskEnabled);
    if (!_areTabsEqual(_activeTabs, newTabs)) {
      if (_activeTabs.isNotEmpty) {
        _tabController.removeListener(_handleTabSelection);
        _tabController.dispose();
      }
      _activeTabs = newTabs;
      if (_activeTabs.isNotEmpty) {
        _tabController = TabController(
          length: _activeTabs.length,
          vsync: this,
          animationDuration: Duration.zero,
        );
        _currentTabIndex =
            _currentTabIndex < _activeTabs.length ? _currentTabIndex : 0;
        _tabController.addListener(_handleTabSelection);
      } else {
        _currentTabIndex = 0;
      }
    }
  }

  void _initTabController(bool helpdeskEnabled) {
    _activeTabs =
        _getTabsForLesson(widget.lesson, helpdeskEnabled: helpdeskEnabled);
    if (_activeTabs.isNotEmpty) {
      _tabController = TabController(
        length: _activeTabs.length,
        vsync: this,
        animationDuration: Duration.zero,
      );
      _currentTabIndex = _tabController.index;
      _tabController.addListener(_handleTabSelection);
    }
  }

  void _handleTabSelection() {
    if (_activeTabs.isEmpty) return;
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
    final helpdeskEnabled =
        ref.read(instituteSettingsProvider)?.helpdeskEnabled ?? false;
    _initTabController(helpdeskEnabled);
  }

  @override
  void didUpdateWidget(VideoLessonViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final helpdeskEnabled =
        ref.read(instituteSettingsProvider)?.helpdeskEnabled ?? false;
    _syncTabs(helpdeskEnabled);
  }

  static const double _kFooterBottomOffset = 88.0;
  static const double _kDefaultBottomOffset = 16.0;

  @override
  void dispose() {
    if (_activeTabs.isNotEmpty) {
      _tabController.removeListener(_handleTabSelection);
      _tabController.dispose();
    }
    _videoPositionNotifier.dispose();
    _isAutoScrollEnabledNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final settings = ref.watch(instituteSettingsProvider);
    final helpdeskEnabled = settings?.helpdeskEnabled ?? false;
    _syncTabs(helpdeskEnabled);

    final showRememberPrompt =
        _pendingSpeedForRememberPrompt != null && !isLandscape;

    final Widget content;
    if (_activeTabs.isEmpty) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLandscape)
            Expanded(child: _buildVideoSection(design))
          else
            _buildVideoSection(design),
          Expanded(
            child: ColoredBox(color: design.colors.surface),
          ),
          if (widget.footerBuilder != null) widget.footerBuilder!(context),
        ],
      );
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLandscape)
            Expanded(child: _buildVideoSection(design))
          else
            _buildVideoSection(design),
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

    return Stack(
      children: [
        content,
        Positioned(
          bottom: (widget.footerBuilder != null
                  ? _kFooterBottomOffset
                  : _kDefaultBottomOffset) +
              MediaQuery.of(context).padding.bottom,
          left: design.spacing.md,
          right: design.spacing.md,
          child: AnimatedSwitcher(
            duration: MotionPreferences.duration(
              context,
              design.motion.normal,
            ),
            reverseDuration: MotionPreferences.duration(
              context,
              design.motion.fast,
            ),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.25),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: MotionPreferences.curve(
                      context,
                      design.motion.easeOut,
                    ),
                  )),
                  child: child,
                ),
              );
            },
            child: showRememberPrompt
                ? KeyedSubtree(
                    key: const ValueKey('remember_speed_banner'),
                    child: _buildRememberSpeedBanner(design),
                  )
                : const SizedBox.shrink(key: ValueKey('empty_banner')),
          ),
        ),
        if (_activeTabs.isNotEmpty)
          ValueListenableBuilder<bool>(
            valueListenable: _isAutoScrollEnabledNotifier,
            builder: (context, isAutoScrollEnabled, _) {
              final isTranscriptTab = _activeTabs[_tabController.index] ==
                  VideoLessonTab.transcript;
              if (!isAutoScrollEnabled && isTranscriptTab) {
                return Positioned(
                  bottom: widget.footerBuilder != null ? 60 : 12,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AppButton.primary(
                      label: L10n.of(context).videoLessonSyncToVideo,
                      onPressed: () {
                        _isAutoScrollEnabledNotifier.value = true;
                      },
                      height: 48.0,
                      padding:
                          EdgeInsets.symmetric(horizontal: design.spacing.md),
                      leading: Icon(
                        LucideIcons.refreshCw,
                        size: design.iconSize.sm,
                        color: design.colors.onPrimary,
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
    if (widget.lesson.isTranscodingProcessing) {
      return VideoProcessingView(lessonId: widget.lesson.id);
    }

    final isCompleted =
        widget.lesson.progressStatus == LessonProgressStatus.completed;
    final durationStr = widget.lesson.lastWatchedDuration;
    final initialPos = isCompleted || durationStr == null || durationStr.isEmpty
        ? 0.0
        : (TimeFormatter.parseDuration(durationStr).inMilliseconds / 1000.0);

    return CustomVideoPlayer(
      key: _videoPlayerKey,
      lessonId: widget.lesson.id,
      assetId: widget.lesson.uuid,
      thumbnailUrl: widget.lesson.image,
      initialPosition: initialPos,
      onComplete: widget.onComplete,
      onPositionChanged: (pos) {
        _videoPositionNotifier.value = pos;
      },
      onSeekOccurred: () {
        _isAutoScrollEnabledNotifier.value = true;
      },
      onPlaybackSpeedChanged: _onPlaybackSpeedChanged,
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

enum VideoLessonTab { notes, transcript, askDoubt, aiSupport, aiMcq }
