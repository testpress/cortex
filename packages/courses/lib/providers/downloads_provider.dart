import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';

part 'downloads_provider.g.dart';

@riverpod
Stream<List<DownloadItem>> downloads(Ref ref) async* {
  final repository = await ref.watch(downloadsRepositoryProvider.future);
  yield* repository.watchAllDownloads();
}

/// Triggers a background sync on every screen visit.
/// Auto-dispose ensures it re-runs each time the screen subscribes.
@riverpod
Future<void> downloadsBootstrap(Ref ref) async {
  final repository = await ref.read(downloadsRepositoryProvider.future);
  await repository.synchronize();
}

@riverpod
Future<void> pauseDownload(Ref ref, String id) async {
  final repository = await ref.read(downloadsRepositoryProvider.future);
  await repository.pauseDownload(id);
}

@riverpod
Future<void> resumeDownload(Ref ref, String id) async {
  final repository = await ref.read(downloadsRepositoryProvider.future);
  await repository.resumeDownload(id);
}

@riverpod
Future<void> deleteDownload(Ref ref, String id) async {
  final repository = await ref.read(downloadsRepositoryProvider.future);
  await repository.deleteDownload(id);
}
