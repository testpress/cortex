import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:core/core.dart';
import '../../models/course_content.dart';
import '../../providers/video_subtabs_provider.dart';

class TranscriptsTab extends ConsumerStatefulWidget {
  final Lesson lesson;
  final bool isSliver;
  final void Function(Duration)? onSeek;

  const TranscriptsTab({
    super.key,
    required this.lesson,
    this.isSliver = false,
    this.onSeek,
  });

  @override
  ConsumerState<TranscriptsTab> createState() => _TranscriptsTabState();
}

class _TranscriptsTabState extends ConsumerState<TranscriptsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
      final child = _buildInProgressState(context, design);
      return widget.isSliver ? SliverToBoxAdapter(child: child) : child;
    }

    final transcriptAsync = ref.watch(fetchTranscriptProvider(subtitleUrl));

    return transcriptAsync.when(
      data: (cues) {
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
          return widget.isSliver
              ? SliverToBoxAdapter(child: emptyChild)
              : emptyChild;
        }

        if (widget.isSliver) {
          return SliverPadding(
            padding: EdgeInsets.all(design.spacing.md),
            sliver: SliverList.builder(
              itemCount: cues.length,
              itemBuilder: (context, index) {
                final cue = cues[index];
                return _buildTranscriptLine(
                  cue.displayStartTime,
                  cue.text,
                  design,
                  isLast: index == cues.length - 1,
                  onTap: () {
                    _handleSeek(cue.displayStartTime);
                  },
                );
              },
            ),
          );
        }

        return ListView.builder(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.all(design.spacing.md),
          itemCount: cues.length,
          itemBuilder: (context, index) {
            final cue = cues[index];
            return _buildTranscriptLine(
              cue.displayStartTime,
              cue.text,
              design,
              isLast: index == cues.length - 1,
              onTap: () {
                _handleSeek(cue.displayStartTime);
              },
            );
          },
        );
      },
      loading: () => SkeletonizerConfig(
        data: SkeletonizerConfigData(
          effect: ShimmerEffect(
            baseColor: design.colors.skeleton,
            highlightColor: design.colors.onSkeleton,
            duration: shimmerDuration,
          ),
        ),
        child: widget.isSliver
            ? Skeletonizer.sliver(
                child: SliverPadding(
                  padding: EdgeInsets.all(design.spacing.md),
                  sliver: SliverList.builder(
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return _buildTranscriptLine(
                        '00:00',
                        BoneMock.words(10),
                        design,
                        isLast: index == 7,
                      );
                    },
                  ),
                ),
              )
            : Skeletonizer(
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.all(design.spacing.md),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return _buildTranscriptLine(
                      '00:00',
                      BoneMock.words(5),
                      design,
                      isLast: index == 7,
                    );
                  },
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
        return widget.isSliver
            ? SliverToBoxAdapter(child: errorChild)
            : errorChild;
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
  }) {
    Widget timeWidget = SizedBox(
      width: 64,
      child: AppText.caption(
        time,
        color: design.colors.accent2,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      ),
    );

    if (onTap != null) {
      timeWidget = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: timeWidget,
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : design.spacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          timeWidget,
          SizedBox(width: design.spacing.md),
          Expanded(
            child: AppText.body(
              text,
              color: design.colors.textSecondary,
              style: const TextStyle(height: 1.5, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
