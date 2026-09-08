import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import '../../providers/course_list_provider.dart';

/// A 16:9 video player area placeholder displayed when a video is in the backend transcoding or processing queue.
class VideoProcessingView extends ConsumerStatefulWidget {
  const VideoProcessingView({
    super.key,
    required this.lessonId,
    this.onRetry,
  });

  final String lessonId;
  final VoidCallback? onRetry;

  @override
  ConsumerState<VideoProcessingView> createState() =>
      _VideoProcessingViewState();
}

class _VideoProcessingViewState extends ConsumerState<VideoProcessingView> {
  bool _isLoading = false;

  Future<void> _handleRetry() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      if (widget.onRetry != null) {
        widget.onRetry!();
      } else {
        final repo = await ref.read(courseRepositoryProvider.future);
        await repo.refreshLesson(widget.lessonId);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: const Color(0xFF000000),
        padding: EdgeInsets.all(design.spacing.md),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.clapperboard,
                size: design.iconSize.xl,
                color: design.colors.primary,
              ),
              SizedBox(height: design.spacing.md),
              AppText.cardTitle(
                L10n.of(context).videoProcessingTitle,
                color: design.colors.textInverse,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: design.spacing.xs),
              AppText.cardSubtitle(
                L10n.of(context).videoTranscodingProcessing,
                color: design.colors.textInverse.withValues(alpha: 0.7),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: design.spacing.md),
              AppButton.primary(
                label: L10n.of(context).labelRetry,
                loading: _isLoading,
                backgroundColor: design.colors.primary,
                foregroundColor: design.colors.onPrimary,
                height: 36.0,
                padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
                onPressed: _handleRetry,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
