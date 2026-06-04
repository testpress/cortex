import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';
import 'package:core/data/data.dart';

import '../../providers/course_list_provider.dart';

class CustomVideoPlayer extends ConsumerStatefulWidget {
  final String? assetId;
  final String? lessonId;
  final String? thumbnailUrl;
  final VoidCallback? onComplete;

  const CustomVideoPlayer({
    super.key,
    this.assetId,
    this.lessonId,
    this.thumbnailUrl,
    this.onComplete,
  });

  @override
  ConsumerState<CustomVideoPlayer> createState() => CustomVideoPlayerState();
}

class CustomVideoPlayerState extends ConsumerState<CustomVideoPlayer> {
  TestpressPlayerController? _controller;
  bool _isFetchingMetadata = true;
  String _courseName = '';
  String _chapterName = '';

  @override
  void initState() {
    super.initState();
    _fetchMetadata();
  }

  Future<void> _fetchMetadata() async {
    if (widget.lessonId == null) {
      if (mounted) {
        setState(() {
          _isFetchingMetadata = false;
        });
      }
      return;
    }

    try {
      final repo = await ref.read(courseRepositoryProvider.future);
      final details = await repo.getLessonDetails(widget.lessonId!);
      if (mounted) {
        setState(() {
          _courseName = details?.courseTitle ?? '';
          _chapterName = details?.chapterTitle ?? '';
          _isFetchingMetadata = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isFetchingMetadata = false;
        });
      }
    }
  }

  Future<void> seek(Duration position) async {
    await _controller?.seek(position);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.assetId != null && widget.assetId!.isNotEmpty) {
      if (_isFetchingMetadata) {
        return const SizedBox.shrink(); // Wait for local DB to provide metadata (extremely fast)
      }

      final downloadItemAsync = ref.watch(watchDownloadItemProvider(widget.assetId!));
      final isCompleted = downloadItemAsync.valueOrNull?.status == DownloadStatus.completed;

      if (isCompleted) {
        return TestpressPlayer.offline(
          assetId: widget.assetId!,
          autoPlay: true,
          onPlayerCreated: (TestpressPlayerController controller) {
            _controller = controller;
            controller.addListener(() {
              if (controller.value.position >= controller.value.duration &&
                  controller.value.duration != Duration.zero) {
                widget.onComplete?.call();
              }
            });
          },
        );
      } else {
        return TestpressPlayer(
          assetId: widget.assetId!,
          autoPlay: true,
          showDownloadOption: true,
          metadata: {
            'course': _courseName,
            'chapter': _chapterName,
          },
          onPlayerCreated: (TestpressPlayerController controller) {
            _controller = controller;
            controller.addListener(() {
              if (controller.value.position >= controller.value.duration &&
                  controller.value.duration != Duration.zero) {
                widget.onComplete?.call();
              }
            });
          },
        );
      }
    }
    return const SizedBox.shrink();
  }
}
