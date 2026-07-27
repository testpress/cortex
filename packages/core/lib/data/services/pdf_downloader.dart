import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../network/file_downloader.dart';
import '../../utils/watermark_params.dart';

class PdfDownloader {
  final FileDownloader _fileDownloader;

  PdfDownloader(this._fileDownloader);

  /// Sanitizes a lesson title into a safe filename by stripping characters
  /// that are illegal on common filesystems. Falls back to 'lesson' if the
  /// result is empty. This is the single source of truth for PDF filenames.
  static String safeTitle(String title) {
    final s = title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();
    return s.isEmpty ? 'lesson' : s;
  }

  /// Downloads the PDF, applies the watermark (if enabled), and saves it to public storage.
  /// Returns the final file size in bytes, and the final file path.
  Future<(int, String)> downloadAndWatermark({
    required String url,
    required String title,
    required bool applyWatermark,
    String? watermarkText,
    void Function(int progressPercent)? onProgress,
  }) async {
    // 1. Download raw file to a temporary directory with a unique path to prevent concurrent collisions
    int lastProgress = 0;
    final tempDir = await Directory.systemTemp.createTemp('pdf_download_');
    final tempPath =
        '${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.pdf';

    await _fileDownloader.downloadToPath(
      url: url,
      savePath: tempPath,
      onReceiveProgress: (count, total) {
        if (total > 0 && onProgress != null) {
          final percent = ((count / total) * 90)
              .toInt(); // First 90% is download
          if (percent != lastProgress) {
            onProgress(percent);
            lastProgress = percent;
          }
        }
      },
    );

    final tempFile = File(tempPath);
    List<int> bytes = await tempFile.readAsBytes();

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

    // 5. Delete temp file and directory
    try {
      await tempDir.delete(recursive: true);
    } catch (_) {
      // Ignore if temp directory deletion fails
    }

    // 6. Return size and path
    final size = await outFile.length();
    if (onProgress != null) {
      onProgress(100);
    }
    return (size, savePath);
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
