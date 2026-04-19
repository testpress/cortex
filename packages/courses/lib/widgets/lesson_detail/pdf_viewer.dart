import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:core/core.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

/// A premium PDF viewer with perfectly synced, real-time scroll progress.
/// Now features transparent local caching for instant sub-second viewing.
class AppPdfViewer extends StatefulWidget {
  final String url;
  final ValueChanged<double>? onProgressChanged;

  const AppPdfViewer({
    super.key,
    required this.url,
    this.onProgressChanged,
  });

  @override
  State<AppPdfViewer> createState() => _AppPdfViewerState();
}

class _AppPdfViewerState extends State<AppPdfViewer>
    with SingleTickerProviderStateMixin {
  late final PdfViewerController _pdfViewerController = PdfViewerController();
  late final Ticker _ticker;

  // Caching state
  String? _localPath;
  bool _isLoading = true;
  double _downloadProgress = 0;

  double _estimatedTotalHeight = 0;
  double _viewportHeight = 0;
  double _lastReportedProgress = -1;

  @override
  void initState() {
    super.initState();
    _initPdf();
    // Use a high-frequency ticker to poll scroll offset every frame (60fps)
    // for perfectly smooth real-time progress updates.
    _ticker = createTicker((_) => _tick());
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _pdfViewerController.dispose();
    super.dispose();
  }

  Future<void> _initPdf() async {
    try {
      final fileName = widget.url.split('/').last.split('?').first;
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');

      if (await file.exists()) {
        if (mounted) {
          setState(() {
            _localPath = file.path;
            _isLoading = false;
          });
        }
      } else {
        await _downloadPdf(file.path);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _downloadPdf(String savePath) async {
    try {
      await Dio().download(
        widget.url,
        savePath,
        onReceiveProgress: (count, total) {
          if (total != -1 && mounted) {
            setState(() => _downloadProgress = count / total);
          }
        },
      );
      if (mounted) {
        setState(() {
          _localPath = savePath;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _tick() {
    if (_localPath == null) return;
    if (_estimatedTotalHeight > 0 && _viewportHeight > 0) {
      final currentOffset = _pdfViewerController.scrollOffset.dy;
      final maxScroll = _estimatedTotalHeight - _viewportHeight;

      double progress;
      if (maxScroll > 0) {
        progress = (currentOffset / maxScroll).clamp(0.0, 1.0);
      } else {
        // PDF fits entire screen, so it's already "read"
        progress = 1.0;
      }

      // Only notify if progress has actually changed to optimize performance
      if (progress != _lastReportedProgress) {
        _lastReportedProgress = progress;
        widget.onProgressChanged?.call(progress);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLoadingIndicator(),
            if (_downloadProgress > 0) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  value: _downloadProgress,
                  backgroundColor: design.colors.surfaceVariant,
                  color: design.colors.primary,
                ),
              ),
              const SizedBox(height: 8),
              AppText.caption(
                'Downloading PDF: ${(_downloadProgress * 100).toInt()}%',
                color: design.colors.textSecondary,
              ),
            ],
          ],
        ),
      );
    }

    if (_localPath == null) {
      return Center(
        child: AppText.body(
          'Failed to load PDF content.',
          color: design.colors.textSecondary,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        _viewportHeight = constraints.maxHeight;
        return SfPdfViewerTheme(
          data: SfPdfViewerThemeData(
            backgroundColor: design.colors.surface,
          ),
          child: SfPdfViewer.file(
            File(_localPath!),
            controller: _pdfViewerController,
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              setState(() {
                final viewportWidth = constraints.maxWidth;
                _estimatedTotalHeight = 0;

                for (int i = 0; i < details.document.pages.count; i++) {
                  final page = details.document.pages[i];
                  // Accurately scale height to match actual screen rendering
                  final scale = viewportWidth / page.size.width;
                  _estimatedTotalHeight += (page.size.height * scale);
                }

                // Add standard page spacing (4px by default)
                _estimatedTotalHeight +=
                    (details.document.pages.count - 1) * 4.0;
              });
            },
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Failed to load PDF: ${details.description}')),
              );
            },
          ),
        );
      },
    );
  }
}
