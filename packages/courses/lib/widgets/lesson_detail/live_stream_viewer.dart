import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'custom_video_player.dart';
import 'fermion_lobby_view.dart';
import '../../providers/course_list_provider.dart';

/// Viewer for live stream content.
///
/// Branches on [LessonDto.liveStreamProvider]:
/// - **Scheduled**: renders [ScheduledMessageView] with a 5-second polling timer.
/// - **Completed without recording**: renders [LiveStreamEndedMessageView].
/// - **Fermion**: renders a lobby screen ([FermionLobbyView]).
/// - **TpStreams / null**: renders the existing inline [CustomVideoPlayer].
class LiveStreamViewer extends ConsumerStatefulWidget {
  const LiveStreamViewer({
    super.key,
    required this.lesson,
    this.onComplete,
    this.footerBuilder,
  });

  final LessonDto lesson;
  final VoidCallback? onComplete;
  final WidgetBuilder? footerBuilder;

  @override
  ConsumerState<LiveStreamViewer> createState() => _LiveStreamViewerState();
}

class _LiveStreamViewerState extends ConsumerState<LiveStreamViewer> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _checkAndScheduleRefresh();
  }

  @override
  void didUpdateWidget(covariant LiveStreamViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lesson.isScheduled != widget.lesson.isScheduled ||
        oldWidget.lesson.id != widget.lesson.id) {
      _checkAndScheduleRefresh();
    }
  }

  void _checkAndScheduleRefresh() {
    _refreshTimer?.cancel();
    if (widget.lesson.isScheduled) {
      _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
        _triggerRefresh();
      });
    }
  }

  Future<void> _triggerRefresh() async {
    try {
      final repository = await ref.read(courseRepositoryProvider.future);
      await repository.refreshLesson(widget.lesson.id);
    } catch (_) {
      // Ignore network errors during background status polling
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  bool get _isFermion => widget.lesson.isFermion;

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final footerBuilder = widget.footerBuilder;

    if (lesson.isScheduled) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ScheduledMessageView(message: lesson.scheduledMessage),
          ),
          if (footerBuilder != null) footerBuilder(context),
        ],
      );
    }

    if (_isFermion) {
      return FermionLobbyView(
        lesson: lesson,
        footerBuilder: footerBuilder,
      );
    }

    // TpStreams / null provider — inline video player
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: CustomVideoPlayer(
            assetId: lesson.uuid,
          ),
        ),
        const Expanded(
          child: ColoredBox(color: Color(0xFF000000)),
        ),
        if (footerBuilder != null) footerBuilder(context),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared scheduled-state view (used by both providers)
// ---------------------------------------------------------------------------

class ScheduledMessageView extends StatelessWidget {
  const ScheduledMessageView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF000000),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.calendarClock,
              color: Design.of(context).colors.primary,
              size: 48,
            ),
            if (message != null) ...[
              const SizedBox(height: 24),
              AppText.body(
                message!,
                color: const Color(0xFFFFFFFF).withValues(alpha: 0.7),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
