import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';

final pdfCacheServiceProvider = Provider((ref) {
  final fileDownloader = ref.watch(fileDownloaderProvider);
  return PdfCacheService(fileDownloader);
});

final pdfFileProvider =
    FutureProvider.family<File, PdfCacheRequest>((ref, request) {
  final cacheService = ref.watch(pdfCacheServiceProvider);
  return cacheService.getPdf(
    lessonId: request.lessonId,
    url: request.url,
  );
});

@immutable
class PdfCacheRequest {
  const PdfCacheRequest({
    required this.lessonId,
    required this.url,
  });

  final String lessonId;
  final String url;

  @override
  bool operator ==(Object other) {
    return other is PdfCacheRequest &&
        other.lessonId == lessonId &&
        other.url == url;
  }

  @override
  int get hashCode => Object.hash(lessonId, url);
}

class PdfCacheService {
  PdfCacheService(this._fileDownloader);

  final FileDownloader _fileDownloader;
  final Map<String, Future<File>> _inFlight = {};

  Future<File> getPdf({
    required String lessonId,
    required String url,
    void Function(int count, int total)? onReceiveProgress,
  }) async {
    final cacheKey = _cacheKeyFor(lessonId);
    final cachedFile = await _getCachedFile(cacheKey);
    if (cachedFile != null) return cachedFile;

    final activeDownload = _inFlight[cacheKey];
    if (activeDownload != null) return activeDownload;

    late final Future<File> downloadFuture;
    downloadFuture = _downloadAndPromote(
      cacheKey: cacheKey,
      url: url,
      onReceiveProgress: onReceiveProgress,
    ).whenComplete(() {
      if (identical(_inFlight[cacheKey], downloadFuture)) {
        _inFlight.remove(cacheKey);
      }
    });

    _inFlight[cacheKey] = downloadFuture;
    return downloadFuture;
  }

  Future<void> prefetchPdf({
    required String lessonId,
    required String url,
  }) async {
    try {
      await getPdf(lessonId: lessonId, url: url);
    } catch (e, stackTrace) {
      debugPrint('Failed to prefetch PDF $lessonId: $e\n$stackTrace');
    }
  }

  Future<File?> _getCachedFile(String cacheKey) async {
    final path = await _pathFor(cacheKey);
    final file = File(path);
    if (await _isUsableFile(file)) return file;
    return null;
  }

  Future<File> _downloadAndPromote({
    required String cacheKey,
    required String url,
    void Function(int count, int total)? onReceiveProgress,
  }) async {
    final finalPath = await _pathFor(cacheKey);
    final finalFile = File(finalPath);
    final tempFile = File('$finalPath.downloading');

    if (await tempFile.exists()) {
      await tempFile.delete();
    }

    try {
      await _fileDownloader.downloadToPath(
        url: url,
        savePath: tempFile.path,
        onReceiveProgress: onReceiveProgress,
        requireAuth: false,
      );

      if (!await _isUsableFile(tempFile)) {
        throw const FileSystemException('Downloaded PDF cache file is empty');
      }

      if (await finalFile.exists()) {
        await finalFile.delete();
      }

      return await tempFile.rename(finalFile.path);
    } catch (_) {
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
      rethrow;
    }
  }

  Future<String> _pathFor(String cacheKey) async {
    final dir = await _fileDownloader.getDirectory(StorageType.internalCache);
    return '${dir.path}/$cacheKey.pdf';
  }

  Future<bool> _isUsableFile(File file) async {
    return await file.exists() && await file.length() > 0;
  }

  String _cacheKeyFor(String lessonId) {
    final safeLessonId = lessonId
        .replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_')
        .replaceAll(RegExp(r'_+'), '_');

    return 'lesson_pdf_${safeLessonId.isNotEmpty ? safeLessonId : 'unknown'}';
  }
}
