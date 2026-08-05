import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:core/core.dart';
import '../../models/course_content.dart';
import '../../providers/video_subtabs_provider.dart';
import '../../utils/vtt_parser.dart';

class TranscriptsTab extends ConsumerStatefulWidget {
  final Lesson lesson;
  final void Function(Duration)? onSeek;
  final ValueNotifier<Duration>? videoPositionNotifier;
  final ValueNotifier<bool>? isAutoScrollEnabledNotifier;
  final bool isActive;

  const TranscriptsTab({
    super.key,
    required this.lesson,
    this.onSeek,
    this.videoPositionNotifier,
    this.isAutoScrollEnabledNotifier,
    required this.isActive,
  });

  @override
  ConsumerState<TranscriptsTab> createState() => _TranscriptsTabState();
}

class _TranscriptsTabState extends ConsumerState<TranscriptsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int? _activeCueIndex;
  int? _scrollingToIndex;
  List<VttCue>? _currentCues;
  final Map<int, GlobalKey> _itemKeys = {};
  final ScrollController _scrollController = ScrollController();
  DateTime? _ignorePositionUpdatesUntil;

  ValueNotifier<Duration>? _oldPositionNotifier;
  ValueNotifier<bool>? _oldAutoScrollNotifier;

  @override
  void initState() {
    super.initState();
    _setupPositionListener();
    _setupAutoScrollListener();
  }

  @override
  void didUpdateWidget(TranscriptsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoPositionNotifier != oldWidget.videoPositionNotifier) {
      _oldPositionNotifier?.removeListener(_onPositionChanged);
      _setupPositionListener();
    }
    if (widget.isAutoScrollEnabledNotifier !=
        oldWidget.isAutoScrollEnabledNotifier) {
      _oldAutoScrollNotifier?.removeListener(_onAutoScrollNotifierChanged);
      _setupAutoScrollListener();
    }
    if (widget.isActive && !oldWidget.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _onPositionChanged(forceScroll: true);
      });
    }
  }

  @override
  void dispose() {
    _oldPositionNotifier?.removeListener(_onPositionChanged);
    _oldAutoScrollNotifier?.removeListener(_onAutoScrollNotifierChanged);
    _scrollController.dispose();
    super.dispose();
  }

  void _setupPositionListener() {
    _oldPositionNotifier = widget.videoPositionNotifier;
    widget.videoPositionNotifier?.addListener(_onPositionChanged);
  }

  void _setupAutoScrollListener() {
    _oldAutoScrollNotifier = widget.isAutoScrollEnabledNotifier;
    widget.isAutoScrollEnabledNotifier
        ?.addListener(_onAutoScrollNotifierChanged);
  }

  void _onAutoScrollNotifierChanged() {
    if (widget.isAutoScrollEnabledNotifier?.value == true) {
      _scrollToActiveCue();
    }
  }

  void _onPositionChanged({bool forceScroll = false}) {
    if (!widget.isActive) {
      return;
    }
    if (_currentCues == null || _currentCues!.isEmpty) return;

    if (_ignorePositionUpdatesUntil != null &&
        DateTime.now().isBefore(_ignorePositionUpdatesUntil!)) {
      return;
    }

    final currentPosition =
        widget.videoPositionNotifier?.value ?? Duration.zero;

    int matchedIndex = _findCueIndexAtPosition(currentPosition);

    if (matchedIndex == -1) {
      // Position falls between cues; keep the previous cue highlighted.
      return;
    }

    if (matchedIndex != _activeCueIndex) {
      setState(() {
        _activeCueIndex = matchedIndex;
      });

      final isAutoScrollEnabled =
          widget.isAutoScrollEnabledNotifier?.value ?? true;
      if (isAutoScrollEnabled || forceScroll) {
        _scrollToActiveCue();
      }
    } else if (forceScroll) {
      _scrollToActiveCue();
    }
  }

  int _findCueIndexAtPosition(Duration position) {
    final cues = _currentCues!;
    int low = 0;
    int high = cues.length - 1;
    int matchedIndex = -1;

    while (low <= high) {
      final mid = (low + high) >> 1;
      if (_parseVttDuration(cues[mid].startTime) <= position) {
        matchedIndex = mid;
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }

    if (matchedIndex == -1) return -1;
    if (position > _parseVttDuration(cues[matchedIndex].endTime)) return -1;
    return matchedIndex;
  }

  void _scrollToActiveCue() {
    final index = _activeCueIndex;
    if (index == null) return;

    _scrollingToIndex = index;

    final duration = MotionPreferences.duration(
      context,
      Design.of(context).motion.normal,
    );
    final curve = MotionPreferences.curve(
      context,
      Design.of(context).motion.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _scrollingToIndex != index) {
        return;
      }

      final key = _itemKeys[index];
      final targetContext = key?.currentContext;
      if (targetContext == null) {
        return;
      }

      Scrollable.ensureVisible(
        targetContext,
        duration: duration,
        curve: curve,
        alignment: 0.3,
      );
    });
  }

  Duration _parseVttDuration(String timeStr) {
    final normalized = timeStr.replaceAll(',', '.');
    final parts = normalized.split('.');
    final mainTime = parts[0].split(':');
    final ms = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

    if (mainTime.length == 3) {
      final hrs = int.tryParse(mainTime[0]) ?? 0;
      final mins = int.tryParse(mainTime[1]) ?? 0;
      final secs = int.tryParse(mainTime[2]) ?? 0;
      return Duration(
          hours: hrs, minutes: mins, seconds: secs, milliseconds: ms);
    } else if (mainTime.length == 2) {
      final mins = int.tryParse(mainTime[0]) ?? 0;
      final secs = int.tryParse(mainTime[1]) ?? 0;
      return Duration(minutes: mins, seconds: secs, milliseconds: ms);
    }
    return Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final shimmerDuration = MotionPreferences.duration(
      context,
      const Duration(milliseconds: 400),
    );

    // If subtitle URL is empty or null, transcription is not complete/in progress
    final subtitleUrl = widget.lesson.videoSubtitleUrl;
    if (subtitleUrl == null || subtitleUrl.isEmpty) {
      return _buildInProgressState(context, design);
    }

    final transcriptAsync = ref.watch(fetchTranscriptProvider(subtitleUrl));

    return transcriptAsync.when(
      data: (cues) {
        final firstLoad = _currentCues == null;
        _currentCues = cues;
        if (firstLoad) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _onPositionChanged(forceScroll: true);
          });
        }
        if (cues.isEmpty) {
          final emptyChild = Center(
            child: Padding(
              padding: EdgeInsets.all(design.spacing.md),
              child: AppText.body(
                l10n.videoLessonNoTranscriptAvailable,
                color: design.colors.textSecondary,
              ),
            ),
          );
          return emptyChild;
        }

        return _buildTranscriptList(cues, design);
      },
      loading: () => SkeletonizerConfig(
        data: SkeletonizerConfigData(
          effect: ShimmerEffect(
            baseColor: design.colors.skeleton,
            highlightColor: design.colors.onSkeleton,
            duration: shimmerDuration,
          ),
        ),
        child: Skeletonizer(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.all(design.spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                8,
                (index) => _buildTranscriptLine(
                  '00:00',
                  BoneMock.words(5),
                  design,
                  isLast: index == 7,
                ),
              ),
            ),
          ),
        ),
      ),
      error: (err, stack) {
        final errorChild = Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: design.spacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText.body(
                  l10n.videoLessonFailedToLoadTranscript,
                  color: design.colors.error,
                ),
                const SizedBox(height: 8),
                AppButton.secondary(
                  label: l10n.labelRetry,
                  onPressed: () =>
                      ref.invalidate(fetchTranscriptProvider(subtitleUrl)),
                ),
              ],
            ),
          ),
        );
        return errorChild;
      },
    );
  }

  Widget _buildInProgressState(BuildContext context, DesignConfig design) {
    final l10n = L10n.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.xl * 2,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(design.spacing.md),
              decoration: BoxDecoration(
                color: design.colors.accent2.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.clock,
                color: design.colors.accent2,
                size: 40,
              ),
            ),
            SizedBox(height: design.spacing.md),
            AppText.subtitle(
              l10n.videoLessonTranscriptionInProgress,
              color: design.colors.textPrimary,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: design.spacing.xs),
            AppText.body(
              l10n.videoLessonTranscriptionInProgressDesc,
              color: design.colors.textSecondary,
              textAlign: TextAlign.center,
              style: const TextStyle(height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSeek(String timeStr) {
    if (widget.onSeek == null) return;
    final duration = TimeFormatter.parseDuration(timeStr);
    widget.onSeek?.call(duration);
  }

  Widget _buildTranscriptLine(
    String time,
    String text,
    DesignConfig design, {
    bool isLast = false,
    VoidCallback? onTap,
    bool isActive = false,
  }) {
    final bodyStyle = design.typography.body;
    final baseSize = bodyStyle.fontSize ?? 14.0;

    final textStyle = bodyStyle.copyWith(
      height: 1.5,
      fontSize: baseSize,
      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
      color: isActive ? design.colors.textPrimary : design.colors.textSecondary,
    );

    final timeStyle = TextStyle(
      fontSize: baseSize,
      fontWeight: FontWeight.bold,
      color: design.colors.accent2,
    );

    final lineContent = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : design.spacing.lg),
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$time  ',
                    style: timeStyle,
                  ),
                  TextSpan(
                    text: text,
                    style: textStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (onTap == null) {
      return lineContent;
    }

    return AppSemantics.button(
      label: '$time. $text',
      onTap: onTap,
      child: lineContent,
    );
  }

  Widget _buildTranscriptList(List<VttCue> cues, DesignConfig design) {
    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (notification.depth == 0 &&
            notification.metrics.axis == Axis.vertical &&
            notification.direction != ScrollDirection.idle) {
          widget.isAutoScrollEnabledNotifier?.value = false;
        }
        return false;
      },
      child: AppSemantics.scrollableList(
        itemCount: cues.length,
        label: L10n.of(context).videoLessonTranscript,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.all(design.spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int index = 0; index < cues.length; index++)
                Container(
                  key: _itemKeys.putIfAbsent(index, () => GlobalKey()),
                  child: _buildTranscriptLine(
                    cues[index].displayStartTime,
                    cues[index].text,
                    design,
                    isLast: index == cues.length - 1,
                    isActive: index == _activeCueIndex,
                    onTap: () {
                      setState(() {
                        _activeCueIndex = index;
                        _ignorePositionUpdatesUntil = DateTime.now()
                            .add(const Duration(milliseconds: 1500));
                      });
                      widget.isAutoScrollEnabledNotifier?.value = true;
                      _handleSeek(cues[index].displayStartTime);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
