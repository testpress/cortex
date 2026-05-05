import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dio_provider.dart';

final fileDownloaderProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return FileDownloader(dio);
});

enum StorageType {
  /// App-private storage for caching (ApplicationSupportDirectory).
  /// Files are not visible to users or other apps.
  internalCache,

  /// Public user-accessible storage (Downloads directory).
  /// Files are visible in the system Downloads folder.
  publicDownload,
}

class FileDownloader {
  final Dio _dio;

  FileDownloader(this._dio);

  /// Gets the appropriate directory based on the [StorageType].
  Future<Directory> getDirectory(StorageType type) async {
    if (type == StorageType.internalCache) {
      return await getApplicationSupportDirectory();
    } else {
      Directory? dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
      } else {
        dir = await getDownloadsDirectory();
      }
      final finalDir = dir ?? await getApplicationDocumentsDirectory();
      
      // Ensure directory exists
      if (!await finalDir.exists()) {
        try {
          await finalDir.create(recursive: true);
        } catch (_) {
          // If we can't create it, it might already exist or we lack permissions.
        }
      }
      return finalDir;
    }
  }

  /// Resolves the local file path for a given URL and [StorageType].
  Future<String> getLocalPath(String url, StorageType type) async {
    final fileName = url.split('/').last.split('?').first;
    final dir = await getDirectory(type);
    return '${dir.path}/$fileName';
  }

  /// Downloads a file from [url] to the path determined by [type].
  /// Automatically handles Android permissions for public downloads.
  Future<String?> download({
    required String url,
    required StorageType type,
    CancelToken? cancelToken,
    void Function(int count, int total)? onReceiveProgress,
    bool requireAuth = false,
  }) async {
    // Permission handling for public downloads on Android
    if (type == StorageType.publicDownload && Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      // On Android 13+, Permission.storage is automatically denied. 
      // However, apps are still allowed to write files to the public Downloads directory.
      // Therefore, we do not abort if the status is denied. We proceed and let the
      // actual file system operation throw an exception if it is truly blocked.
    }

    final savePath = await getLocalPath(url, type);
    final file = File(savePath);

    // Ensure parent directory exists
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    await _dio.download(
      url,
      savePath,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      options: Options(
        extra: {'requireAuth': requireAuth},
      ),
    );

    return savePath;
  }
}
