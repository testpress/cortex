import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lesson_detail_skeleton.dart';
import 'watermark_overlay.dart';

class AppPdfViewer extends ConsumerStatefulWidget {
  final String url;
  final ValueChanged<double>? onProgressChanged;

  const AppPdfViewer({
    super.key,
    required this.url,
    this.onProgressChanged,
  });

  @override
  ConsumerState<AppPdfViewer> createState() => _AppPdfViewerState();
}

class _AppPdfViewerState extends ConsumerState<AppPdfViewer>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late PdfViewerController _controller;
  late final Ticker _ticker;

  String? _error;
  bool _isLoading = true;
  bool _isVisible = false;
  String _watermarkText = '';
  Widget? _cachedViewer;
  String? _localPath;

  int _requestId = 0;

  double _totalHeight = 0;
  double _viewportHeight = 0;
  double _viewportWidth = 0;
  double _lastProgress = -1;

  @override
  bool get wantKeepAlive => true;

  // ---------------- INIT ----------------

  @override
  void initState() {
    super.initState();
    _initController();
    _initTicker();
    _load();
  }

  void _initController() {
    _controller = PdfViewerController();
  }

  void _initTicker() {
    _ticker = createTicker((_) => _trackProgress())
      ..muted = true
      ..start();
  }

  @override
  void didUpdateWidget(covariant AppPdfViewer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_isSameDocument(oldWidget.url, widget.url)) {
      _resetViewer();
      _load();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ---------------- LOAD FLOW ----------------

  Future<void> _load() async {
    final id = ++_requestId;

    _prepareState();

    try {
      unawaited(_fetchWatermark(id));

      final path = await _resolveSource();

      if (!_isValidRequest(id)) return;

      _handleSuccess(path);
    } catch (e) {
      if (!_isValidRequest(id)) return;

      _handleError(e);
    }
  }

  Future<void> _fetchWatermark(int id) async {
    try {
      final currentUser = await ref.read(userProvider.future);
      if (!_isValidRequest(id)) return;

      setState(() {
        _watermarkText = currentUser?.username ?? '';
      });
    } catch (e, stackTrace) {
      debugPrint('Failed to fetch user for watermark: $e\n$stackTrace');
    }
  }

  void _prepareState() {
    _muteTicker(true);

    setState(() {
      _isLoading = true;
      _error = null;
      _localPath = null;
      _isVisible = false;
      _watermarkText = '';
      _totalHeight = 0;
      _lastProgress = -1;
      _cachedViewer = null;
    });
  }

  Future<String?> _resolveSource() async {
    if (_localPath != null) return _localPath;

    final fileDownloader = ref.read(fileDownloaderProvider);
    final path = await fileDownloader.getLocalPath(
      widget.url,
      StorageType.internalCache,
    );

    final file = File(path);
    if (await file.exists() && (await file.length()) > 0) {
      _localPath = path;
      return path;
    }

    _cacheInBackground(widget.url);
    return null;
  }

  Future<void> _cacheInBackground(String url) async {
    if (_localPath != null) return;
    try {
      final downloader = ref.read(fileDownloaderProvider);
      final path = await downloader.download(
        url: url,
        type: StorageType.internalCache,
        requireAuth: false,
      );
      if (mounted) {
        _localPath = path;
      }
    } catch (_) {}
  }

  void _handleSuccess(String? path) {
    setState(() {
      _isLoading = false;
      _cachedViewer = path != null
          ? SfPdfViewer.file(
              File(path),
              controller: _controller,
              onDocumentLoaded: _onDocumentLoaded,
            )
          : SfPdfViewer.network(
              widget.url,
              controller: _controller,
              onDocumentLoaded: _onDocumentLoaded,
            );
    });
  }

  void _handleError(Object error) {
    setState(() {
      _error = error.toString();
      _isLoading = false;
    });
  }

  bool _isValidRequest(int id) {
    return mounted && id == _requestId;
  }

  Widget _buildViewer() {
    final viewer = _cachedViewer ?? const SizedBox.shrink();
    final design = Design.of(context);

    return Stack(
      children: [
        AnimatedOpacity(
          opacity: _isVisible ? 1 : 0,
          duration: MotionPreferences.duration(context, design.motion.normal),
          child: viewer,
        ),
        if (_isVisible &&
            (InstituteSettings.current?.enableCoursePdfWatermarking ?? false))
          WatermarkOverlay(
            text: _watermarkText,
            color: design.colors.onSurface.withValues(alpha: 0.15),
          ),
        if (!_isVisible) LessonDetailSkeleton(lessonType: LessonType.pdf),
      ],
    );
  }

  Widget _buildError() => Center(child: AppText(_error!));

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final design = Design.of(context);

    if (_isLoading) {
      return LessonDetailSkeleton(lessonType: LessonType.pdf);
    }
    if (_error != null) {
      return _buildError();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        _viewportHeight = constraints.maxHeight;
        _viewportWidth = constraints.maxWidth;

        return SfPdfViewerTheme(
          data: SfPdfViewerThemeData(
            backgroundColor: design.colors.surface,
          ),
          child: _buildViewer(),
        );
      },
    );
  }

  // ---------------- EVENTS ----------------

  void _onDocumentLoaded(PdfDocumentLoadedDetails details) {
    _totalHeight = _calculateTotalHeight(details);
    _muteTicker(false);

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() => _isVisible = true);
      }
    });
  }

  double _calculateTotalHeight(PdfDocumentLoadedDetails details) {
    if (_viewportWidth <= 0) return 0;

    double height = 0;

    for (int i = 0; i < details.document.pages.count; i++) {
      final page = details.document.pages[i];
      // Accurately scale height to match actual screen rendering (fit to width)
      final scale = _viewportWidth / page.size.width;
      height += (page.size.height * scale);
    }

    // Add standard page spacing (4px by default in SfPdfViewer)
    height += (details.document.pages.count - 1) * 4.0;

    return height;
  }

  void _trackProgress() {
    if (_ticker.muted) return;

    if (_totalHeight > 0 && _viewportHeight > 0) {
      final offset = _controller.scrollOffset.dy;
      final max = _totalHeight - _viewportHeight;

      final progress = max > 0 ? (offset / max).clamp(0.0, 1.0) : 1.0;

      if ((progress - _lastProgress).abs() > 0.001) {
        _lastProgress = progress;
        widget.onProgressChanged?.call(progress);
      }
    }
  }

  // ---------------- HELPERS ----------------

  void _muteTicker(bool value) {
    if (_ticker.muted != value) {
      _ticker.muted = value;
    }
  }

  void _resetViewer() {
    _controller.dispose();
    _initController();
  }

  bool _isSameDocument(String a, String b) {
    final uriA = Uri.parse(a);
    final uriB = Uri.parse(b);

    return uriA.host == uriB.host && uriA.path == uriB.path;
  }
}
