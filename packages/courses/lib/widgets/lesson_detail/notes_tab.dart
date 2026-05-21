import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:core/core.dart';
import '../../models/course_content.dart';
import '../../providers/video_subtabs_provider.dart';

class NotesTab extends ConsumerStatefulWidget {
  final Lesson lesson;
  final bool isSliver;
  final void Function(Duration)? onSeek;

  const NotesTab({
    super.key,
    required this.lesson,
    this.isSliver = false,
    this.onSeek,
  });

  @override
  ConsumerState<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends ConsumerState<NotesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _processMarkdown(String raw) {
    // Strip style tags
    var processed =
        raw.replaceAll(RegExp(r'<style>.*?</style>', dotAll: true), '');

    // Convert timestamp spans to markdown links
    processed = processed.replaceAllMapped(
      RegExp(r'<span class="video-timestamp">(.*?)</span>'),
      (match) => '[${match.group(1)}](timestamp:${match.group(1)})',
    );

    return processed;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final notesUrl = widget.lesson.aiNotesUrl;
    final shimmerDuration = MotionPreferences.duration(
      context,
      const Duration(milliseconds: 400),
    );

    if (notesUrl == null || notesUrl.isEmpty) {
      final child = Padding(
        padding: EdgeInsets.all(design.spacing.md),
        child: Center(
          child: AppText.body(
            l10n.videoLessonNoNotesAvailable,
            color: design.colors.textSecondary,
          ),
        ),
      );
      return widget.isSliver ? SliverToBoxAdapter(child: child) : child;
    }

    final notesAsync = ref.watch(fetchNotesMarkdownProvider(notesUrl));

    return notesAsync.when(
      data: (markdownContent) {
        if (markdownContent.trim().isEmpty) {
          final emptyChild = Padding(
            padding: EdgeInsets.symmetric(vertical: design.spacing.xl),
            child: Center(
              child: AppText.body(
                l10n.videoLessonNotesEmpty,
                color: design.colors.textSecondary,
              ),
            ),
          );
          return widget.isSliver
              ? SliverToBoxAdapter(child: emptyChild)
              : emptyChild;
        }

        final processedContent = _processMarkdown(markdownContent);

        final markdownBody = AppMarkdown(
          data: processedContent,
          selectable: true,
          onTapLink: (url) {
            if (url.startsWith('timestamp:')) {
              final timeStr = url.substring('timestamp:'.length);
              final duration = TimeFormatter.parseDuration(timeStr);
              widget.onSeek?.call(duration);
            }
          },
        );

        if (widget.isSliver) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(design.spacing.md),
              child: markdownBody,
            ),
          );
        }

        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.all(design.spacing.md),
          child: markdownBody,
        );
      },
      loading: () {
        final skeletonChild = SkeletonizerConfig(
          data: SkeletonizerConfigData(
            effect: ShimmerEffect(
              baseColor: design.colors.skeleton,
              highlightColor: design.colors.onSkeleton,
              duration: shimmerDuration,
            ),
          ),
          child: Skeletonizer(
            child: Padding(
              padding: EdgeInsets.all(design.spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Bone.text(words: 3, fontSize: 24),
                  SizedBox(height: design.spacing.md),
                  const Bone.multiText(lines: 4),
                  SizedBox(height: design.spacing.lg),
                  const Bone.text(words: 2, fontSize: 20),
                  SizedBox(height: design.spacing.md),
                  const Bone.multiText(lines: 6),
                  SizedBox(height: design.spacing.lg),
                  const Bone.multiText(lines: 3),
                  SizedBox(height: design.spacing.lg),
                  const Bone.multiText(lines: 5),
                ],
              ),
            ),
          ),
        );
        return widget.isSliver
            ? SliverToBoxAdapter(child: skeletonChild)
            : skeletonChild;
      },
      error: (err, stack) {
        final errorChild = Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: design.spacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText.body(
                  l10n.videoLessonFailedToLoadNotes,
                  color: design.colors.error,
                ),
                const SizedBox(height: 8),
                AppButton.secondary(
                  label: l10n.labelRetry,
                  onPressed: () =>
                      ref.invalidate(fetchNotesMarkdownProvider(notesUrl)),
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
}
