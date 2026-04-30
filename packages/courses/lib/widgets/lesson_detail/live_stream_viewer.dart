import 'package:flutter/widgets.dart';
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
