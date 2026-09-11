import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_screenshot/secure_widget.dart';
import 'package:no_screenshot/overlay_mode.dart';
import 'lesson_detail_skeleton.dart';
import 'watermark_overlay.dart';

class AppPdfViewer extends ConsumerStatefulWidget {
  final String? url;
  final File? file;
  final ValueChanged<double>? onProgressChanged;

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

  @visibleForTesting
  static bool isSameResource(AppPdfViewer oldW, AppPdfViewer newW) {
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
  double _lastProgress = -1;
  int _pageCount = 1;

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

  @override
  void didUpdateWidget(covariant AppPdfViewer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!AppPdfViewer.isSameResource(oldWidget, widget)) {
      _resetViewer();
      _load();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_trackProgress);
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

      if (!_isValidRequest(id)) return;

      _setupViewer(id);
    } catch (e, st) {
      if (e is! ApiException) {
        sentry.captureException(e, stackTrace: st);
      }
      if (!_isValidRequest(id)) return;

      _handleError(id, e);
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
      _lastProgress = -1;
      _pageCount = 1;
      _pdfViewerWidget = null;
    });
  }

  void _setupViewer(int id) {
    final design = Design.of(context);
    final params = PdfViewerParams(
      backgroundColor: design.colors.surface,
      limitRenderingCache: false,
      verticalCacheExtent: 3.0,
      maxImageBytesCachedOnMemory: 256 * 1024 * 1024,
      onViewerReady: (document, controller) {
        _onViewerReady(id, document);
      },
      onDocumentLoadFinished: (documentRef, loadSucceeded) {
        if (!loadSucceeded && _isValidRequest(id)) {
          _handleError(id, const ApiException('Failed to load PDF document'));
        }
      },
      errorBannerBuilder: (context, error, stackTrace, documentRef) {
        if (_isValidRequest(id)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleError(id, error);
          });
        }
        return const SizedBox.shrink();
      },
      viewerOverlayBuilder: (context, size, handleLinkTap) => [
        PdfViewerScrollThumb(
          controller: _controller,
          orientation: ScrollbarOrientation.right,
          thumbSize: const Size(68, 48),
          margin: 8,
          thumbBuilder: (context, thumbSize, pageNumber, controller) {
            if (pageNumber == null) return const SizedBox.shrink();
            final count =
                controller.isReady ? controller.pageCount : _pageCount;
            return Semantics(
              label: 'Page $pageNumber of $count',
              value: '$pageNumber of $count',
              slider: true,
              child: Center(
                child: Container(
                  height: 28,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: design.colors.surfaceVariant.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: design.colors.border),
                    boxShadow: design.shadows.floating,
                  ),
                  child: Center(
                    child: AppText.caption(
                      '$pageNumber / $count',
                      color: design.colors.onSurface,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
      pageOverlaysBuilder: (context, pageRect, page) {
        if (_watermarkText.isEmpty) return const [];
        return [
          Positioned.fill(
            child: WatermarkOverlay(
              text: _watermarkText,
              color: design.colors.onSurface.withValues(alpha: 0.15),
            ),
          ),
        ];
      },
    );

    setState(() {
      if (widget.url != null && widget.url!.isNotEmpty) {
        _pdfViewerWidget = PdfViewer.uri(
          Uri.parse(widget.url!),
          preferRangeAccess: true,
          controller: _controller,
          params: params,
        );
      } else if (widget.file != null) {
        _pdfViewerWidget = PdfViewer.file(
          widget.file!.path,
          controller: _controller,
          params: params,
        );
      }
    });
  }

  Future<void> _handleError(int id, Object error) async {
    final isConnected = await hasInternetConnection();
    if (!_isValidRequest(id)) return;

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

    return Stack(
      children: [
        AnimatedOpacity(
          opacity: _isVisible ? 1 : 0,
          duration: MotionPreferences.duration(
              context, Design.of(context).motion.normal),
          child: viewer,
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

    if (_isLoading && _pdfViewerWidget == null) {
      return LessonDetailSkeleton(lessonType: LessonType.pdf);
    }
    if (_error != null) {
      return _buildError();
    }

    return SecureWidget(
      mode: OverlayMode.secure,
      child: _buildViewer(),
    );
  }

  // ---------------- EVENTS ----------------

  void _onViewerReady(int id, PdfDocument document) {
    if (!_isValidRequest(id)) return;
    _pageCount = document.pages.length;

    if (mounted) {
      setState(() {
        _isVisible = true;
        _isLoading = false;
      });
    }

    // Progressively stream and decode subsequent pages in background so scrolling is instant without white flashes
    unawaited(document.loadPagesProgressively());
  }

  void _trackProgress() {
    if (_pageCount > 0 && _controller.isReady) {
      final pageNumber = _controller.pageNumber ?? 1;
      final progress = (pageNumber / _pageCount).clamp(0.0, 1.0);

      if ((progress - _lastProgress).abs() > 0.001) {
        _lastProgress = progress;
        widget.onProgressChanged?.call(progress);
      }
    }
  }

  // ---------------- HELPERS ----------------

  void _resetViewer() {
    _controller.removeListener(_trackProgress);
    _initController();
  }
}
