import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:core/core.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:core/data/data.dart';
import 'lesson_detail_skeleton.dart';

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

  String? _localPath;
  String? _error;
  bool _isLoading = true;
  bool _isVisible = false;

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
      final path = await _resolveSource();

      if (!_isValidRequest(id)) return;

      _handleSuccess(path);
    } catch (e) {
      if (!_isValidRequest(id)) return;

      _handleError(e);
    }
  }

  void _prepareState() {
    _muteTicker(true);

    setState(() {
      _isLoading = true;
      _error = null;
      _localPath = null;
      _isVisible = false;
      _totalHeight = 0;
      _lastProgress = -1;
    });
  }

  Future<String?> _resolveSource() async {
    final downloader = ref.read(fileDownloaderProvider);

    final path = await downloader.getLocalPath(
      widget.url,
      StorageType.internalCache,
    );

    final file = File(path);

    final isCached = await file.exists() && (await file.length()) > 0;

    if (isCached) return path;

    _cacheInBackground(widget.url);
    return null;
  }

  void _handleSuccess(String? path) {
    setState(() {
      _localPath = path;
      _isLoading = false;
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

  // ---------------- CACHE ----------------

  Future<void> _cacheInBackground(String url) async {
    try {
      final downloader = ref.read(fileDownloaderProvider);
      await downloader.download(
        url: url,
        type: StorageType.internalCache,
        requireAuth: false,
      );
    } catch (_) {}
  }

  // ---------------- VIEWER ----------------

  Widget _buildViewer(DesignConfig design) {
    final viewer = _localPath != null
        ? SfPdfViewer.file(
            File(_localPath!),
            controller: _controller,
            onDocumentLoaded: _onDocumentLoaded,
          )
        : SfPdfViewer.network(
            widget.url,
            controller: _controller,
            onDocumentLoaded: _onDocumentLoaded,
          );

    return Stack(
      children: [
        AnimatedOpacity(
          opacity: _isVisible ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: viewer,
        ),
        if (!_isVisible) _buildLoadingSkeleton(design),
      ],
    );
  }

  Widget _buildLoadingSkeleton(DesignConfig design) {
    return SkeletonizerConfig(
      data: SkeletonizerConfigData(
        effect: ShimmerEffect(
          baseColor: design.colors.skeleton,
          highlightColor: design.colors.onSkeleton,
        ),
      ),
      child: const Skeletonizer(
        child: LessonDetailSkeleton(lessonType: LessonType.pdf),
      ),
    );
  }

  Widget _buildError() => Center(child: Text(_error!));

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final design = Design.of(context);

    if (_isLoading) return _buildLoadingSkeleton(design);
    if (_error != null) return _buildError();

    return LayoutBuilder(
      builder: (context, constraints) {
        _viewportHeight = constraints.maxHeight;
        _viewportWidth = constraints.maxWidth;

        return SfPdfViewerTheme(
          data: SfPdfViewerThemeData(
            backgroundColor: design.colors.surface,
          ),
          child: _buildViewer(design),
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
