import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';
import 'package:core/data/data.dart';

import '../../providers/course_list_provider.dart';
import '../../providers/video_attempt_provider.dart';

class CustomVideoPlayer extends ConsumerStatefulWidget {
  final String? assetId;
  final String? lessonId;
  final String? thumbnailUrl;
  final double initialPosition;
  final VoidCallback? onComplete;

  const CustomVideoPlayer({
    super.key,
    this.assetId,
    this.lessonId,
    this.thumbnailUrl,
    this.initialPosition = 0.0,
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

  // Track the playback intervals
  double _currentIntervalStart = 0.0;
  double _lastPosition = 0.0;
  final List<List<double>> _watchedTimeRanges = [];
  bool _isPlayingTracker = false;

  late final VideoAttemptNotifier? _videoAttemptNotifier;
  late final int? _contentId;
  
  @override
  void initState() {
    super.initState();
    _fetchMetadata();
    
    if (widget.lessonId != null) {
      _contentId = int.tryParse(widget.lessonId!);
      if (_contentId != null) {
        _videoAttemptNotifier = ref.read(videoAttemptNotifierProvider(_contentId!).notifier);
      } else {
        _videoAttemptNotifier = null;
      }
    } else {
      _contentId = null;
      _videoAttemptNotifier = null;
    }
  }

  @override
  void dispose() {
    _finalizeCurrentInterval();
    if (_contentId != null && _videoAttemptNotifier != null) {
      // Force a final sync before leaving using the safe notifier reference
      _videoAttemptNotifier!.forceSync();
    }
    super.dispose();
  }

  void _finalizeCurrentInterval() {
    if (_controller == null || !_isPlayingTracker) return;
    
    final currentPos = _controller!.value.position.inMilliseconds / 1000.0;
    if (currentPos > _currentIntervalStart) {
      _watchedTimeRanges.add([_currentIntervalStart, currentPos]);
    }
    _isPlayingTracker = false;
    
    _syncVideoAttempt(currentPos);
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
    // Watch the provider to keep it alive while the video player is open
    if (_contentId != null) {
      ref.watch(videoAttemptNotifierProvider(_contentId!));
    }

    if (widget.assetId != null && widget.assetId!.isNotEmpty) {
      if (_isFetchingMetadata) {
        return const SizedBox.shrink(); // Wait for local DB to provide metadata (extremely fast)
      }

      final downloadItemAsync = ref.watch(watchDownloadItemProvider(widget.assetId!));
      
      if (!downloadItemAsync.hasValue) {
        return const SizedBox.shrink(); // Wait for database to emit initial status to avoid online player flicker
      }

      final isCompleted = downloadItemAsync.value?.status == DownloadStatus.completed;

      if (isCompleted) {
        return TestpressPlayer.offline(
          assetId: widget.assetId!,
          autoPlay: true,
          onPlayerCreated: _onPlayerCreated,
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
          onPlayerCreated: _onPlayerCreated,
        );
      }
    }
    return const SizedBox.shrink();
  }

  bool _hasSeekedToInitial = false;

  void _onPlayerCreated(TestpressPlayerController controller) {
    _controller = controller;

    controller.addListener(() {
      final isPlaying = controller.value.isPlaying;
      final currentPos = controller.value.position.inMilliseconds / 1000.0;

      // Ensure we only seek once the video is loaded (duration > 0)
      final needsInitialSeek = widget.initialPosition > 0 && !_hasSeekedToInitial;
      if (needsInitialSeek) {
        if (controller.value.duration != Duration.zero) {
          controller.seek(Duration(milliseconds: (widget.initialPosition * 1000).toInt()));
          _lastPosition = widget.initialPosition;
          _currentIntervalStart = widget.initialPosition;
          _hasSeekedToInitial = true;
        }
        return;
      }

      // Detect seek (position jumped by more than 1.5s or went backwards)
      final isSeeking = (currentPos - _lastPosition).abs() > 1.5;
      if (isSeeking) {
        if (_isPlayingTracker) {
          if (_lastPosition > _currentIntervalStart) {
            _watchedTimeRanges.add([_currentIntervalStart, _lastPosition]);
          }
          _currentIntervalStart = currentPos;
        }
        _syncVideoAttempt(currentPos);
      }

      // Track watched ranges
      if (isPlaying && !_isPlayingTracker) {
        _currentIntervalStart = currentPos;
        _isPlayingTracker = true;
      } else if (!isPlaying && _isPlayingTracker) {
        _finalizeCurrentInterval();
      }

      // Check for completion
      if (controller.value.position >= controller.value.duration &&
          controller.value.duration != Duration.zero) {
        widget.onComplete?.call();
      }

      _lastPosition = currentPos;
    });
  }

  void _syncVideoAttempt(double currentPos) {
    if (_contentId != null && _videoAttemptNotifier != null) {
      _videoAttemptNotifier!.updatePositionAndRanges(
        currentPos.toString(),
        List<List<double>>.from(_watchedTimeRanges),
      );
      _watchedTimeRanges.clear();
    }
  }
}
