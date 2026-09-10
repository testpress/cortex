import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:background_downloader/background_downloader.dart' as bg;
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../network/file_downloader.dart';
import '../../utils/watermark_params.dart';

class PdfDownloader {
  final FileDownloader _fileDownloader;
  final Stream<bg.TaskUpdate> _attachmentUpdates;

  PdfDownloader(this._fileDownloader, this._attachmentUpdates);

  /// Sanitizes a lesson title into a safe filename by stripping characters
  /// that are illegal on common filesystems. Falls back to 'lesson' if the
  /// result is empty. This is the single source of truth for PDF filenames.
  static String safeTitle(String title) {
    final s = title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();
    return s.isEmpty ? 'lesson' : s;
  }

  /// Downloads the PDF, applies the watermark (if enabled), and saves it to public storage.
  /// Returns the background_downloader task ID, final file size in bytes, and final file path.
  ///
  /// The fetch step uses background_downloader for pause/resume support.
  /// The watermark step (Syncfusion, in memory) runs after a complete fetch.
  Future<(String, int, String)> downloadAndWatermark({
    required String url,
    required String title,
    required bool applyWatermark,
    String? taskId,
    String? watermarkText,
    void Function(int progressPercent)? onProgress,
  }) async {
    // 1. Download raw file via background_downloader to a temp path
    final resolvedTaskId =
        taskId ?? 'pdf_temp_${DateTime.now().millisecondsSinceEpoch}';
    final filename = '${safeTitle(title)}_temp_$resolvedTaskId.pdf';

    final task = bg.DownloadTask(
      taskId: resolvedTaskId,
      url: url,
      filename: filename,
      baseDirectory: bg.BaseDirectory.temporary,
      updates: bg.Updates.statusAndProgress,
      allowPause: true,
      retries: 0,
    );

    int lastProgress = 0;
    final completer = Completer<void>();

    final subscription = _attachmentUpdates.listen((update) {
      if (update.task.taskId != task.taskId) return;
      if (update is bg.TaskProgressUpdate && onProgress != null) {
        if (update.progress < 0 || update.progress.isNaN) return;
        final percent = ((update.progress * 90)).toInt().clamp(0, 90);
        if (percent > lastProgress) {
          onProgress(percent);
          lastProgress = percent;
        }
      } else if (update is bg.TaskStatusUpdate) {
        if (update.status == bg.TaskStatus.complete) {
          if (!completer.isCompleted) completer.complete();
        } else if (update.status == bg.TaskStatus.failed ||
            update.status == bg.TaskStatus.notFound ||
            update.status == bg.TaskStatus.canceled) {
          if (!completer.isCompleted) {
            completer.completeError(
              Exception('PDF fetch failed: ${update.status}'),
            );
          }
        }
      }
    });

    try {
      await bg.FileDownloader().enqueue(task);
      await completer.future;
    } finally {
      await subscription.cancel();
    }

    final tempPath = await task.filePath();
    final tempFile = File(tempPath);
    List<int> bytes = await tempFile.readAsBytes();
    try {
      await tempFile.delete();
    } catch (_) {}

    // 2 & 3. Apply watermark in memory if enabled
    if (applyWatermark && watermarkText != null && watermarkText.isNotEmpty) {
      bytes = await compute(_applyWatermarkToPdfSync, {
        'pdfBytes': bytes,
        'watermarkText': watermarkText,
        'fontSize': WatermarkParams.fontSize,
        'opacity': WatermarkParams.opacity,
        'angleDeg': WatermarkParams.angleDeg,
      });
    }

    if (onProgress != null) {
      onProgress(95);
    }

    // 4. Save to final destination in public storage
    await _fileDownloader.ensurePublicStoragePermission();
    final pubDir = await _fileDownloader.getDirectory(
      StorageType.publicDownload,
    );
    final name = PdfDownloader.safeTitle(title);

    String finalName = '$name.pdf';

    if (await File('${pubDir.path}/$finalName').exists()) {
      int counter = 1;
      while (await File('${pubDir.path}/$name-$counter.pdf').exists()) {
        counter++;
      }
      finalName = '$name-$counter.pdf';
    }

    String savePath = '${pubDir.path}/$finalName';
    final outFile = File(savePath);
    await outFile.writeAsBytes(bytes);

    // 5. Return size and path
    final size = await outFile.length();
    if (onProgress != null) {
      onProgress(100);
    }
    return (task.taskId, size, savePath);
  }
}

List<int> _applyWatermarkToPdfSync(Map<String, dynamic> data) {
  final pdfBytes = data['pdfBytes'] as List<int>;
  final watermarkText = data['watermarkText'] as String;
  final fontSize = data['fontSize'] as double;
  final opacity = data['opacity'] as double;
  final angleDeg = data['angleDeg'] as double;

  final document = PdfDocument(inputBytes: pdfBytes);
  try {
    final font = PdfStandardFont(PdfFontFamily.helvetica, fontSize);
    final size = font.measureString(watermarkText);

    for (int i = 0; i < document.pages.count; i++) {
      final page = document.pages[i];
      final graphics = page.graphics;

      graphics.save();
      graphics.setTransparency(opacity);

      // Move to center of page
      graphics.translateTransform(
        page.getClientSize().width / 2,
        page.getClientSize().height / 2,
      );

      // Rotate to match in-app overlay angle
      graphics.rotateTransform(angleDeg);

      // Draw string centered
      graphics.drawString(
        watermarkText,
        font,
        bounds: Rect.fromLTWH(
          -size.width / 2,
          -size.height / 2,
          size.width,
          size.height,
        ),
      );

      graphics.restore();
    }

    return document.saveSync();
  } finally {
    document.dispose();
  }
}
