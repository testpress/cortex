import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_screenshot/secure_widget.dart';
import 'package:no_screenshot/overlay_mode.dart';
import 'lesson_detail_skeleton.dart';
import 'watermark_overlay.dart';

class AppPdfViewer extends ConsumerStatefulWidget {
  final String? url;
  final File? file;
  final ValueChanged<double>? onProgressChanged;

  const AppPdfViewer({
    super.key,
    this.url,
    this.file,
    this.onProgressChanged,
  }) : assert(
            url != null || file != null, 'Either url or file must be provided');

  const AppPdfViewer.network({
    super.key,
    required String this.url,
    this.onProgressChanged,
  }) : file = null;

  const AppPdfViewer.file({
    super.key,
    required File this.file,
    this.onProgressChanged,
  }) : url = null;

  @override
  ConsumerState<AppPdfViewer> createState() => _AppPdfViewerState();
}

class _AppPdfViewerState extends ConsumerState<AppPdfViewer>
    with AutomaticKeepAliveClientMixin {
  late PdfViewerController _controller;

  String? _error;
  bool _isLoading = true;
  bool _isVisible = false;
  String _watermarkText = '';
  Widget? _pdfViewerWidget;

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
    _load();
  }

  void _initController() {
    _controller = PdfViewerController();
    _controller.addListener(_trackProgress);
  }

  bool _isSameResource(AppPdfViewer oldW, AppPdfViewer newW) {
    if (oldW.file?.path != newW.file?.path) return false;
    if (oldW.url == newW.url) return true;
    if (oldW.url == null || newW.url == null) return false;

    // Compare URLs ignoring query params (which change on refreshed pre-signed CloudFront tokens)
    final uriOld = Uri.tryParse(oldW.url!);
    final uriNew = Uri.tryParse(newW.url!);
    if (uriOld != null && uriNew != null) {
      return uriOld.scheme == uriNew.scheme &&
          uriOld.host == uriNew.host &&
          uriOld.path == uriNew.path;
    }
    return false;
  }

  @override
  void didUpdateWidget(covariant AppPdfViewer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_isSameResource(oldWidget, widget)) {
      _resetViewer();
      _load();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_trackProgress);
    _controller.dispose();
    super.dispose();
  }

  // ---------------- LOAD FLOW ----------------

  Future<void> _load() async {
    final id = ++_requestId;

    _prepareState();

    final sentry = ref.read(sentryServiceProvider);
    try {
      unawaited(_fetchWatermark(id));

      if (widget.url != null && widget.url!.isNotEmpty) {
        final isConnected = await hasInternetConnection();
        if (!isConnected) {
          throw const ApiException('No Internet Connection',
              type: ApiErrorType.noInternet);
        }
      } else if (widget.file != null) {
        final file = widget.file!;
        final exists = await file.exists();
        final len = exists ? await file.length() : 0;
        if (!exists || len == 0) {
          throw FileSystemException('PDF file is missing or empty', file.path);
        }
      }

      if (!_isValidRequest(id)) {
        return;
      }

      _setupViewer();
    } catch (e, st) {
      if (e is! ApiException) {
        sentry.captureException(e, stackTrace: st);
      }
      if (!_isValidRequest(id)) return;

      _handleError(e);
    }
  }

  Future<void> _fetchWatermark(int id) async {
    final sentry = ref.read(sentryServiceProvider);
    try {
      final currentUser = await ref.read(userProvider.future);
      if (!_isValidRequest(id)) return;

      setState(() {
        _watermarkText = currentUser?.username ?? '';
      });
    } catch (e, st) {
      sentry.captureException(e, stackTrace: st);
    }
  }

  bool _isOffline = false;

  void _prepareState() {
    setState(() {
      _isLoading = true;
      _error = null;
      _isOffline = false;
      _isVisible = false;
      _watermarkText = '';
      _totalHeight = 0;
      _lastProgress = -1;
      _pdfViewerWidget = null;
    });
  }

  void _setupViewer() {
    setState(() {
      if (widget.url != null && widget.url!.isNotEmpty) {
        _pdfViewerWidget = SfPdfViewer.network(
          widget.url!,
          controller: _controller,
          onDocumentLoaded: _onDocumentLoaded,
          onDocumentLoadFailed: (details) {
            _handleError(details.description);
          },
        );
      } else if (widget.file != null) {
        _pdfViewerWidget = SfPdfViewer.file(
          widget.file!,
          controller: _controller,
          onDocumentLoaded: _onDocumentLoaded,
          onDocumentLoadFailed: (details) {
            _handleError(details.description);
          },
        );
      }
    });
  }

  Future<void> _handleError(Object error) async {
    final isConnected = await hasInternetConnection();
    if (!mounted) return;

    setState(() {
      _isOffline = !isConnected ||
          (error is ApiException && error.type == ApiErrorType.noInternet);
      _error = error.toString();
      _isLoading = false;
      _pdfViewerWidget = null;
    });
  }

  bool _isValidRequest(int id) {
    return mounted && id == _requestId;
  }

  Widget _buildViewer() {
    final viewer = _pdfViewerWidget ?? const SizedBox.shrink();
    final design = Design.of(context);

    return Stack(
      children: [
        AnimatedOpacity(
          opacity: _isVisible ? 1 : 0,
          duration: MotionPreferences.duration(context, design.motion.normal),
          child: viewer,
        ),
        if (_isVisible)
          WatermarkOverlay(
            text: _watermarkText,
            color: design.colors.onSurface.withValues(alpha: 0.15),
          ),
        if (!_isVisible) LessonDetailSkeleton(lessonType: LessonType.pdf),
      ],
    );
  }

  Widget _buildError() {
    final l10n = L10n.of(context);
    return Center(
      child: AppErrorView(
        title: _isOffline ? l10n.errorNoInternetTitle : l10n.errorGenericTitle,
        message: l10n.errorGenericMessage,
        onRetry: () {
          _resetViewer();
          _load();
        },
      ),
    );
  }

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final design = Design.of(context);

    if (_isLoading && _pdfViewerWidget == null) {
      return LessonDetailSkeleton(lessonType: LessonType.pdf);
    }
    if (_error != null) {
      return _buildError();
    }

    return SecureWidget(
      mode: OverlayMode.secure,
      child: LayoutBuilder(
        builder: (context, constraints) {
          _viewportHeight = constraints.maxHeight;
          _viewportWidth = constraints.maxWidth;

          return ClipRect(
            child: OverflowBox(
              minHeight: constraints.minHeight,
              maxHeight: constraints.maxHeight.isFinite
                  ? constraints.maxHeight + 2.0
                  : double.infinity,
              alignment: Alignment.topCenter,
              child: SfPdfViewerTheme(
                data: SfPdfViewerThemeData(
                  backgroundColor: design.colors.surface,
                ),
                child: _buildViewer(),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------- EVENTS ----------------

  void _onDocumentLoaded(PdfDocumentLoadedDetails details) {
    _totalHeight = _calculateTotalHeight(details);

    if (mounted) {
      setState(() {
        _isVisible = true;
        _isLoading = false;
      });
    }
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

  void _resetViewer() {
    _controller.removeListener(_trackProgress);
    _controller.dispose();
    _initController();
  }
}
