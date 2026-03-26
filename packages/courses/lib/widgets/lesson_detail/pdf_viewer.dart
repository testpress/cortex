import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:core/core.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// A premium PDF viewer with perfectly synced, real-time scroll progress.
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

  double _estimatedTotalHeight = 0;
  double _viewportHeight = 0;
  double _lastReportedProgress = -1;

  @override
  void initState() {
    super.initState();
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

  void _tick() {
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

    return LayoutBuilder(
      builder: (context, constraints) {
        _viewportHeight = constraints.maxHeight;
        return SfPdfViewerTheme(
          data: SfPdfViewerThemeData(
            backgroundColor: design.colors.surface,
          ),
          child: SfPdfViewer.network(
            widget.url,
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
                    content: Text('Failed to load PDF: ${details.description}')),
              );
            },
          ),
        );
      },
    );
  }
}
