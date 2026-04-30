import 'package:flutter/material.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String? assetId;
  final VoidCallback? onComplete;

  const CustomVideoPlayer({
    super.key,
    this.assetId,
    this.onComplete,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    if (widget.assetId != null && widget.assetId!.isNotEmpty) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: TestpressPlayer(
          assetId: widget.assetId!,
          autoPlay: true,
          showDownloadOption: true,
          onPlayerCreated: (TestpressPlayerController controller) {
            controller.addListener(() {
              // Mark as completed if the video reaches the end
              if (controller.value.position >= controller.value.duration &&
                  controller.value.duration != Duration.zero) {
                widget.onComplete?.call();
              }
            });
          },
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
