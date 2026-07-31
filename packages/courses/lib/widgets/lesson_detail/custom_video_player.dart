import 'dart:async';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';
import 'package:core/data/data.dart';

import '../../providers/course_list_provider.dart';
import '../../providers/video_attempt_provider.dart';
import '../../providers/video_watermark_config_provider.dart';
import 'playback_rate.dart';

class CustomVideoPlayer extends ConsumerStatefulWidget {
  final String? assetId;
  final String? lessonId;
  final String? thumbnailUrl;
  final double initialPosition;
  final VoidCallback? onComplete;
  final ValueChanged<Duration>? onPositionChanged;
  final VoidCallback? onSeekOccurred;

  const CustomVideoPlayer({
    super.key,
    this.assetId,
    this.lessonId,
    this.thumbnailUrl,
    this.initialPosition = 0.0,
    this.onComplete,
    this.onPositionChanged,
    this.onSeekOccurred,
  });

  @override
  ConsumerState<CustomVideoPlayer> createState() => CustomVideoPlayerState();
}

class CustomVideoPlayerState extends ConsumerState<CustomVideoPlayer> {
  TestpressPlayerController? _controller;
  bool _isFetchingMetadata = true;
  String _courseName = '';
  String _chapterName = '';
  bool _isPlayerDestroyed = false;
  Timer? _seekDebounceTimer;

  // Track the playback intervals
  double _currentIntervalStart = 0.0;
  double _lastPosition = 0.0;
  final List<List<double>> _watchedTimeRanges = [];
  bool _isPlayingTracker = false;

  // Playback speed memory
  double _lastPersistedSpeed = 1.0;
  double? _lastRateSampleTime;
  double _lastRateSamplePos = 0.0;
  int _steadyRateSamples = 0;
  bool _speedToastVisible = false;
  Timer? _speedToastTimer;

  VideoAttemptNotifier? _videoAttemptNotifier;
  late final int? _contentId;

  @override
  void initState() {
    super.initState();
    _fetchMetadata();

    if (widget.lessonId != null) {
      _contentId = int.tryParse(widget.lessonId!);
    } else {
      _contentId = null;
    }
  }

  @override
  void dispose() {
    _seekDebounceTimer?.cancel();
    _speedToastTimer?.cancel();
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

    final sentry = ref.read(sentryServiceProvider);
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
    } catch (e, st) {
      sentry.captureException(e, stackTrace: st);
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

  void finalizePlayback() {
    _finalizeCurrentInterval();
    _pendingSeekPosition = _lastPosition;
    if (_contentId != null && _videoAttemptNotifier != null) {
      _videoAttemptNotifier!.forceSync();
    }
    if (mounted) {
      setState(() => _isPlayerDestroyed = true);
    }
  }

  void restorePlayback() {
    if (mounted) {
      setState(() {
        _isPlayerDestroyed = false;
        _controller = null;
        _hasSeekedToInitial = false;
        _isPlayingTracker = false;
        _currentIntervalStart = 0.0;
        _lastPosition = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(instituteSettingsProvider);
    final design = Design.of(context);

    // Watch the provider to keep it alive while the video player is open
    if (_contentId != null) {
      ref.watch(videoAttemptNotifierProvider(_contentId!));
      // Grab the active notifier instance safely inside build
      _videoAttemptNotifier =
          ref.read(videoAttemptNotifierProvider(_contentId!).notifier);
    }

    if (_isPlayerDestroyed) {
      return const SizedBox.shrink();
    }

    if (widget.assetId != null && widget.assetId!.isNotEmpty) {
      if (_isFetchingMetadata) {
        return const SizedBox
            .shrink(); // Wait for local DB to provide metadata (extremely fast)
      }

      final downloadItemAsync =
          ref.watch(watchDownloadItemProvider(widget.assetId!));

      if (!downloadItemAsync.hasValue) {
        return const SizedBox
            .shrink(); // Wait for database to emit initial status to avoid online player flicker
      }

      final isCompleted =
          downloadItemAsync.value?.status == DownloadStatus.completed;

      final player = isCompleted
          ? TestpressPlayer.offline(
              assetId: widget.assetId!,
              autoPlay: true,
              onPlayerCreated: _onPlayerCreated,
            )
          : TestpressPlayer(
              assetId: widget.assetId!,
              autoPlay: true,
              showDownloadOption: settings?.isVideoDownloadEnabled ?? false,
              metadata: {
                'course': _courseName,
                'chapter': _chapterName,
              },
              onPlayerCreated: _onPlayerCreated,
            );

      return Stack(
        children: [
          player,
          if (_speedToastVisible)
            Positioned(
              top: design.spacing.md,
              left: 0,
              right: 0,
              child: Center(child: _buildSpeedToast(design)),
            ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  bool _hasSeekedToInitial = false;
  double? _pendingSeekPosition;
  bool _shouldIgnoreInitialCompletion = false;
  double _initialSeekPos = 0.0;

  void _onPlayerCreated(TestpressPlayerController controller) {
    _controller = controller;

    final design = Design.of(context);
    final fontSize = design.typography.headline.fontSize ?? 14.0;
    final watermarkConfig = ref.read(videoWatermarkConfigProvider(fontSize));

    if (watermarkConfig != null) {
      controller.setWatermarks([watermarkConfig]).catchError((e, st) {
        if (!mounted) return;
        ref.read(sentryServiceProvider).captureException(e, stackTrace: st);
      });
    }

    _restorePlaybackSpeed(controller);

    controller.addListener(() {
      final isPlaying = controller.value.isPlaying;
      final currentPos = controller.value.position.inMilliseconds / 1000.0;
      final duration = controller.value.duration.inMilliseconds / 1000.0;

      // Ensure we only seek once the video is loaded (duration > 0)
      if (!_hasSeekedToInitial) {
        if (controller.value.duration != Duration.zero) {
          final targetSeek = _pendingSeekPosition ?? widget.initialPosition;
          if (targetSeek > 0) {
            controller
                .seek(Duration(milliseconds: (targetSeek * 1000).toInt()));
            _lastPosition = targetSeek;
            _currentIntervalStart = targetSeek;
            _initialSeekPos = targetSeek;
            // Guard: If the initial position is close to the end, ignore the completion trigger
            final nearEndThreshold = duration > 2.0 ? 2.0 : (duration * 0.5);
            if (targetSeek >= duration - nearEndThreshold) {
              _shouldIgnoreInitialCompletion = true;
            }
          } else {
            _initialSeekPos = 0.0;
          }
          _hasSeekedToInitial = true;
          _pendingSeekPosition = null;
          widget.onPositionChanged?.call(
            Duration(milliseconds: (targetSeek * 1000).toInt()),
          );
        }
        return;
      }

      // Reset the ignore flag if the user seeks backwards or plays forward past the initial seek position
      if (_shouldIgnoreInitialCompletion) {
        final isProgressingForward = currentPos > _initialSeekPos + 0.1;
        final isSeekingBackward = currentPos < _initialSeekPos - 0.5;
        if (isProgressingForward || isSeekingBackward) {
          _shouldIgnoreInitialCompletion = false;
        }
      }

      // Detect seek (position jumped by more than 1.5s or went backwards)
      final isSeeking = (currentPos - _lastPosition).abs() > 1.5;
      if (isSeeking) {
        _seekDebounceTimer?.cancel();
        _seekDebounceTimer = Timer(const Duration(milliseconds: 300), () {
          widget.onSeekOccurred?.call();
        });
        if (_isPlayingTracker) {
          if (_lastPosition > _currentIntervalStart) {
            _watchedTimeRanges.add([_currentIntervalStart, _lastPosition]);
          }
          _currentIntervalStart = currentPos;
        }
        _syncVideoAttempt(currentPos);
      }

      _trackPlaybackRate(controller, currentPos);

      // Track watched ranges
      if (isPlaying && !_isPlayingTracker) {
        _currentIntervalStart = currentPos;
        _isPlayingTracker = true;
      } else if (!isPlaying && _isPlayingTracker) {
        _finalizeCurrentInterval();
      }

      // Check for completion
      if (!_shouldIgnoreInitialCompletion &&
          controller.value.position >= controller.value.duration &&
          controller.value.duration != Duration.zero) {
        widget.onComplete?.call();
      }

      widget.onPositionChanged?.call(controller.value.position);

      _lastPosition = currentPos;
    });
  }

  Future<void> _restorePlaybackSpeed(
      TestpressPlayerController controller) async {
    try {
      final db = await ref.read(appDatabaseProvider.future);
      final settings = await db.getAppSettings();

      if (!mounted) return;
      if (!settings.rememberPlaybackSpeed) return;

      final saved = settings.globalPlaybackSpeed;
      if (saved == null || saved <= 0 || saved == 1.0) return;

      await controller.setPlaybackSpeed(saved);
      _lastPersistedSpeed = saved;

      if (!mounted) return;
      _showSpeedToast();
    } catch (e, st) {
      if (!mounted) return;
      ref.read(sentryServiceProvider).captureException(e, stackTrace: st);
    }
  }

  void _showSpeedToast() {
    _speedToastTimer?.cancel();
    setState(() {
      _speedToastVisible = true;
    });
    _speedToastTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() {
        _speedToastVisible = false;
      });
    });
  }

  Widget _buildSpeedToast(DesignConfig design) {
    final speed = _lastPersistedSpeed;
    final speedLabel =
        speed == speed.roundToDouble() ? speed.toInt().toString() : '$speed';
    final l10n = context.l10n;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.sm * 1.5,
      ),
      decoration: BoxDecoration(
        color: design.colors.textPrimary,
        borderRadius: BorderRadius.circular(design.radius.xl),
        boxShadow: design.shadows.floating,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: AppText.labelBold(
              l10n.playbackSpeedRestored(speedLabel),
              color: design.colors.textInverse,
            ),
          ),
          SizedBox(width: design.spacing.md),
          GestureDetector(
            onTap: () => _resetPlaybackSpeed(_controller!),
            behavior: HitTestBehavior.opaque,
            child: AppText.labelBold(
              l10n.playbackSpeedReset,
              color: design.colors.accent2,
            ),
          ),
        ],
      ),
    );
  }

  void _resetPlaybackSpeed(TestpressPlayerController controller) {
    _speedToastTimer?.cancel();
    if (mounted) {
      setState(() {
        _speedToastVisible = false;
      });
    }
    controller.setPlaybackSpeed(1.0).catchError((e, st) {
      if (!mounted) return;
      ref.read(sentryServiceProvider).captureException(e, stackTrace: st);
    });
    _lastPersistedSpeed = 1.0;
    _persistPlaybackSpeed(1.0);
  }

  void _trackPlaybackRate(TestpressPlayerController controller, double pos) {
    if (!controller.value.isPlaying ||
        controller.value.isBuffering ||
        controller.value.isLoading) {
      _lastRateSampleTime = null;
      _steadyRateSamples = 0;
      return;
    }

    final now =
        DateTime.now().microsecondsSinceEpoch / Duration.microsecondsPerSecond;
    final last = _lastRateSampleTime;
    if (last == null) {
      _lastRateSampleTime = now;
      _lastRateSamplePos = pos;
      return;
    }

    final wallDelta = now - last;
    final posDelta = pos - _lastRateSamplePos;
    _lastRateSampleTime = now;
    _lastRateSamplePos = pos;

    if (wallDelta < 0.4 || posDelta <= 0.05) {
      _steadyRateSamples = 0;
      return;
    }

    final measured = posDelta / wallDelta;
    final nearest = quantizePlaybackSpeed(measured);
    if (nearest == null) {
      _steadyRateSamples = 0;
      return;
    }

    if ((nearest - _lastPersistedSpeed).abs() < 0.01) {
      _steadyRateSamples = 0;
      return;
    }

    _steadyRateSamples++;
    if (_steadyRateSamples >= 3) {
      _steadyRateSamples = 0;
      _lastPersistedSpeed = nearest;
      _persistPlaybackSpeed(nearest);
    }
  }

  Future<void> _persistPlaybackSpeed(double speed) async {
    try {
      final db = await ref.read(appDatabaseProvider.future);
      final settings = await db.getAppSettings();
      if (!mounted) return;
      if (!settings.rememberPlaybackSpeed) return;
      await db.setGlobalPlaybackSpeed(speed);
    } catch (e, st) {
      if (!mounted) return;
      ref.read(sentryServiceProvider).captureException(e, stackTrace: st);
    }
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
