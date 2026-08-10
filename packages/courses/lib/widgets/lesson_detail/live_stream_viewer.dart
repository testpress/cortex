import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../../models/course_content.dart';
import 'custom_video_player.dart';
import 'fermion_lobby_view.dart';

/// Viewer for live stream content.
///
/// Branches on [Lesson.liveStreamProvider]:
/// - **Fermion**: renders a lobby screen ([FermionLobbyView]) with a
///   context-aware action button that opens the session embed URL in a
///   full-screen [AppWebView].
/// - **TpStreams / null**: renders the existing inline [CustomVideoPlayer].
class LiveStreamViewer extends StatelessWidget {
  const LiveStreamViewer({
    super.key,
    required this.lesson,
    this.onComplete,
    this.footerBuilder,
  });

  final Lesson lesson;
  final VoidCallback? onComplete;
  final WidgetBuilder? footerBuilder;

  bool get _isFermion => lesson.isFermion;

  @override
  Widget build(BuildContext context) {
    if (lesson.isScheduled) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ScheduledMessageView(message: lesson.scheduledMessage),
          ),
          if (footerBuilder != null) footerBuilder!(context),
        ],
      );
    }

    if (_isFermion) {
      return FermionLobbyView(
        lesson: lesson,
        footerBuilder: footerBuilder,
      );
    }

    // TpStreams / null provider — existing inline video player
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: CustomVideoPlayer(
            assetId: lesson.contentUrl,
          ),
        ),
        const Expanded(
          child: ColoredBox(color: Color(0xFF000000)),
        ),
        if (footerBuilder != null) footerBuilder!(context),
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
