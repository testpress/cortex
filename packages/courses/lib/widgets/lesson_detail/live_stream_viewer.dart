import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../../models/course_content.dart';
import 'custom_video_player.dart';

/// Viewer for live stream content, combining a video player and a chat interface.
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: lesson.isScheduled
              ? _ScheduledMessageView(message: lesson.scheduledMessage)
              : CustomVideoPlayer(
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

class _ScheduledMessageView extends StatelessWidget {
  const _ScheduledMessageView({this.message});

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
