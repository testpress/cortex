import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';

part 'downloads_provider.g.dart';

/// Single entry point for all download state and actions.
/// Mirrors the [Auth] notifier pattern from auth_provider.dart.
///
/// Usage:
///   - Watch state: `ref.watch(downloadsProvider)`
///   - Dispatch actions: `ref.read(downloadsProvider.notifier).startAttachmentDownload(...)`
@Riverpod(keepAlive: true)
class Downloads extends _$Downloads {
  @override
  Stream<List<DownloadItem>> build() async* {
    final repo = await ref.watch(downloadsRepositoryProvider.future);
    yield* repo.watchAllDownloads();
  }

  /// Synchronizes the local database with active SDK state.
  /// Removes orphaned records for files deleted outside the app.
  Future<void> synchronize() async {
    final repo = await ref.read(downloadsRepositoryProvider.future);
    await repo.synchronize();
  }

  /// Starts an attachment download. The repository owns the full lifecycle.
  Future<void> startAttachmentDownload(DownloadItem item, String url) async {
    final repo = await ref.read(downloadsRepositoryProvider.future);
    await repo.startAttachmentDownload(item, url);
  }

  /// Pauses an active download (video only — Android).
  Future<void> pause(String id) async {
    final repo = await ref.read(downloadsRepositoryProvider.future);
    await repo.pauseDownload(id);
  }

  /// Resumes a paused download (video only — Android).
  Future<void> resume(String id) async {
    final repo = await ref.read(downloadsRepositoryProvider.future);
    await repo.resumeDownload(id);
  }

  /// Deletes a download record and its associated file.
  Future<void> delete(DownloadItem item) async {
    final repo = await ref.read(downloadsRepositoryProvider.future);
    await repo.deleteDownload(item);
  }
}
