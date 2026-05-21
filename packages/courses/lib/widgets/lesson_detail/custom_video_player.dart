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
  State<CustomVideoPlayer> createState() => CustomVideoPlayerState();
}

class CustomVideoPlayerState extends State<CustomVideoPlayer> {
  TestpressPlayerController? _controller;

  Future<void> seek(Duration position) async {
    await _controller?.seek(position);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.assetId != null && widget.assetId!.isNotEmpty) {
      return TestpressPlayer(
        assetId: widget.assetId!,
        autoPlay: true,
        showDownloadOption: true,
        onPlayerCreated: (TestpressPlayerController controller) {
          _controller = controller;
          // controller.disableAutoFullscreenOnRotate();
          controller.addListener(() {
            if (controller.value.position >= controller.value.duration &&
                controller.value.duration != Duration.zero) {
              widget.onComplete?.call();
            }
          });
        },
      );
    }
    return const SizedBox.shrink();
  }
}
