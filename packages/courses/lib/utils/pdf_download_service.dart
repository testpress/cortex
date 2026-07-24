import 'dart:io';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:core/core.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'watermark_params.dart';

import 'package:core/data/data.dart';
import '../providers/course_list_provider.dart';
import 'pdf_cache_service.dart';

final pdfDownloadServiceProvider = Provider((ref) {
  final fileDownloader = ref.watch(fileDownloaderProvider);
  final pdfCacheService = ref.watch(pdfCacheServiceProvider);
  return PdfDownloadService(ref, fileDownloader, pdfCacheService);
});

class PdfDownloadService {
  final Ref _ref;
  final FileDownloader _fileDownloader;
  final PdfCacheService _pdfCacheService;

  final Map<String, Future<String>> _inFlight = {};

  PdfDownloadService(
    this._ref,
    this._fileDownloader,
    this._pdfCacheService,
  );

  String _getSafeBaseName(String lessonTitle) {
    final safeTitle =
        lessonTitle.replaceAll(RegExp(r'[\\/:*?"<>|]'), '').trim();
    return safeTitle.isNotEmpty ? safeTitle : 'lesson';
  }

  /// Checks if the base file already exists in the Downloads directory.
  Future<String?> getDownloadedPath(String lessonTitle) async {
    final pubDir =
        await _fileDownloader.getDirectory(StorageType.publicDownload);
    final baseName = _getSafeBaseName(lessonTitle);
    final file = File('${pubDir.path}/$baseName.pdf');
    if (await file.exists()) {
      return file.path;
    }
    return null;
  }

  /// Convenience method for the UI to check if it's already downloaded.
  /// Deprecated in favor of watching the DownloadsRepository stream directly.
  Future<bool> checkIfDownloaded(String lessonTitle) async {
    return await getDownloadedPath(lessonTitle) != null;
  }

  /// Downloads the PDF, permanently stamps a watermark on it, and saves it
  /// to the public device storage, logging the download centrally.
  Future<String> downloadAndWatermarkPdf({
    required String lessonId,
    required String url,
    required String lessonTitle,
    required String fallbackWatermarkText,
  }) async {
    final activeDownload = _inFlight[lessonId];
    if (activeDownload != null) {
      return activeDownload;
    }

    final downloadFuture = _executeDownloadAndWatermark(
      lessonId: lessonId,
      url: url,
      lessonTitle: lessonTitle,
      fallbackWatermarkText: fallbackWatermarkText,
    ).whenComplete(() {
      _inFlight.remove(lessonId);
    });

    _inFlight[lessonId] = downloadFuture;
    return downloadFuture;
  }

  Future<String> _executeDownloadAndWatermark({
    required String lessonId,
    required String url,
    required String lessonTitle,
    required String fallbackWatermarkText,
  }) async {
    final downloadsRepo = await _ref.read(downloadsRepositoryProvider.future);
    final courseRepo = await _ref.read(courseRepositoryProvider.future);

    final details = await courseRepo.getLessonDetails(lessonId);
    final courseTitle = details?.courseTitle ?? 'Course';
    final chapterTitle = details?.chapterTitle ?? 'Chapter';

    var downloadItem = DownloadItem(
      id: lessonId,
      title: lessonTitle,
      course: courseTitle,
      chapter: chapterTitle,
      sizeInBytes: 0,
      downloadedDate: DateTime.now().toIso8601String(),
      type: DownloadType.pdf,
      status: DownloadStatus.downloading,
      progress: 0,
      fileType: 'pdf',
      contentUrl: url,
    );

    await downloadsRepo.upsertDownload(downloadItem);

    try {
      final cacheFile = await _pdfCacheService.getPdf(
        lessonId: lessonId,
        url: url,
        onReceiveProgress: (count, total) {
          if (total > 0) {
            final progress = ((count / total) * 90).toInt();
            downloadsRepo.upsertDownload(
              downloadItem.copyWith(progress: progress),
            );
          }
        },
      );
      await downloadsRepo.upsertDownload(downloadItem.copyWith(progress: 90));

      // Get Watermark Text (Username)
      String watermarkText = fallbackWatermarkText;
      try {
        final db = await _ref.read(appDatabaseProvider.future);
        final currentUser = await db.select(db.usersTable).getSingleOrNull();
        if (currentUser?.username != null &&
            currentUser!.username!.isNotEmpty) {
          watermarkText = currentUser.username!;
        }
      } catch (_) {
        // Fallback to fallbackWatermarkText on error
      }

      // Run watermarking in background isolate so we don't freeze the UI thread
      final bytes = await compute(
        _applyWatermarkToPdfSync,
        {
          'pdfPath': cacheFile.path,
          'watermarkText': watermarkText,
          'fontSize': WatermarkParams.fontSize,
          'opacity': WatermarkParams.opacity,
          'angleDeg': WatermarkParams.angleDeg,
        },
      );

      // Handle permissions for public storage (Android mainly)
      await _fileDownloader.ensurePublicStoragePermission();

      // Write to public directory
      final pubDir = await _fileDownloader.getDirectory(
        StorageType.publicDownload,
      );

      final baseName = _getSafeBaseName(lessonTitle);
      String savePath = '${pubDir.path}/$baseName.pdf';
      int suffix = 1;

      // Avoid overwriting by checking if it exists
      while (await File(savePath).exists()) {
        savePath = '${pubDir.path}/$baseName ($suffix).pdf';
        suffix++;
      }

      final outFile = File(savePath);
      await outFile.writeAsBytes(bytes);

      // Use the shared MediaScanner logic from DownloadsService
      final downloadsService = _ref.read(downloadsServiceProvider);
      await downloadsService.scanMediaIfAndroid(savePath);

      await downloadsRepo.upsertDownload(downloadItem.copyWith(
        status: DownloadStatus.completed,
        progress: 100,
        sizeInBytes: await outFile.length(),
        filePath: savePath,
      ));

      return savePath;
    } catch (e) {
      await downloadsRepo.upsertDownload(downloadItem.copyWith(
        status: DownloadStatus.error,
      ));

      rethrow;
    }
  }
}

List<int> _applyWatermarkToPdfSync(Map<String, dynamic> data) {
  final pdfPath = data['pdfPath'] as String;
  final pdfBytes = File(pdfPath).readAsBytesSync();
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
