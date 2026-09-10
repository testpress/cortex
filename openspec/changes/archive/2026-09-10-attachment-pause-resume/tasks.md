## 1. Dependency & Native Setup

- [x] 1.1 Add `background_downloader` to `packages/core/pubspec.yaml`
- [x] 1.2 Configure Android WorkManager in `app/android/` — add `androidx.work:work-runtime-ktx` dependency and `WorkManagerInitializer` (or `FileDownloaderPlugin` initializer) per `background_downloader` setup docs
- [x] 1.3 Configure iOS background modes in `app/ios/Runner/Info.plist` — add `UIBackgroundModes: fetch` and `remote-notification` (or `background-processing`) per `background_downloader` setup docs
- [x] 1.4 Verify `flutter pub get` resolves cleanly and run `dart run build_runner build` to confirm no conflicts

## 2. Data Model & DB Migration

- [x] 2.1 Add `taskId` nullable `TextColumn` to `DownloadsTable` in `packages/core/lib/data/db/tables/downloads_table.dart`
- [x] 2.2 Add `taskId` nullable `String?` field to `DownloadItem` model in `packages/core/lib/data/models/download_item.dart`, including `copyWith` parameter
- [x] 2.3 ~~Bump `schemaVersion` from `1` to `2`~~ — N/A: app not yet in production, `schemaVersion` stays at `1`
- [x] 2.4 ~~Add `onUpgrade` migration case~~ — N/A: no migration needed, `onCreate → createAll()` includes `taskId` automatically
- [x] 2.5 Update all `DownloadItem(...)` constructors and `upsertDownload()` in `DownloadsRepository` to pass `taskId` through the DB companion (`DownloadsTableCompanion`)
- [x] 2.6 Run `dart run build_runner build --delete-conflicting-outputs` to regenerate `app_database.g.dart` and `downloads_repository.g.dart`

## 3. Service Layer — `DownloadsService`

- [x] 3.1 Add `BackgroundDownloader` instance to `DownloadsService` and initialise it in the constructor (configure a `FileDownloadTask` default group)
- [x] 3.2 Implement `downloadAttachment(url, {onProgress})` using `background_downloader`: create a `DownloadTask` with a stable `taskId`, enqueue it, listen for `TaskStatus` and `TaskProgress` updates, return the completed file path and size
- [x] 3.3 Implement `pauseAttachmentDownload(String taskId)` via `BackgroundDownloader.pause(task)` — look up active task by `taskId`
- [x] 3.4 Implement `resumeAttachmentDownload(String taskId, String url)` via `BackgroundDownloader.resume(task)` — reconstruct the task from stored `taskId` + `url` and re-enqueue
- [x] 3.5 Update `PdfDownloader.downloadAndWatermark()` to replace `_fileDownloader.downloadToPath()` with a `background_downloader` task that downloads to the temp path — watermark and save-to-public steps remain unchanged
- [x] 3.6 Keep `FileDownloader` (Dio) in service for thumbnail downloads; do not remove it

## 4. Repository Layer — `DownloadsRepository`

- [x] 4.1 Update `startAttachmentDownload()` to capture the `taskId` returned from `_service.downloadAttachment()` and persist it via `upsertDownload(item.copyWith(taskId: taskId, ...))`
- [x] 4.2 Update `startWatermarkedPdfDownload()` similarly to capture and persist `taskId`
- [x] 4.3 Update `pauseDownload(id)` to be type-aware: look up the item type from DB and branch to `_service.pauseAttachmentDownload(taskId)` for `DownloadType.attachment`
- [x] 4.4 Update `resumeDownload(id)` to be type-aware: for `DownloadType.attachment`, retrieve `taskId` and `contentUrl` from DB and call `_service.resumeAttachmentDownload(taskId, url)`
- [x] 4.5 Update `synchronize()` to reconnect `background_downloader` progress listeners to any attachment tasks that are still in-flight (status `downloading` or `paused` in DB)

## 5. Provider Layer — `DownloadsProvider`

- [x] 5.1 Remove the "video only" doc comments from `pause()` and `resume()` in `packages/courses/lib/providers/downloads_provider.dart` — no signature change needed

## 6. UI — Downloads Screen

- [x] 6.1 In `DownloadsScreen._handleAction()`, remove the `item.type == DownloadType.video` guard from the `DownloadStatus.downloading` case so pause is dispatched for attachments too
- [x] 6.2 Remove the `DownloadType.video` guard from the `DownloadStatus.paused` case so resume is dispatched for attachments too
- [x] 6.3 Update `DownloadStatusX.actionIcon()` extension in `downloads_screen.dart` — remove the `type == DownloadType.video` condition so pause/resume icons render for all types

## 7. UI — Attachment Viewer

- [x] 7.1 Add paused state detection to `AttachmentViewer` (`isPaused = item?.status == DownloadStatus.paused`)
- [x] 7.2 Show pause button when `isDownloading` — tapping calls `ref.read(downloadsProvider.notifier).pause(widget.id)`
- [x] 7.3 Show resume button when `isPaused` — tapping calls `ref.read(downloadsProvider.notifier).resume(widget.id)`
- [x] 7.4 Update `_openFile()` to use `item.filePath` directly (already done) — verify no reference to `fileDownloaderProvider.getLocalPath` remains for completed attachment path resolution

## 8. Verification

- [x] 8.1 Manually test: start an attachment download → pause mid-way → verify status shows `paused` and progress is preserved in DB
- [x] 8.2 Manually test: resume from paused → verify download continues from where it left off
- [x] 8.3 Manually test: kill the app while paused → relaunch → verify item still shows as `paused` and can be resumed
- [x] 8.4 Manually test: navigate away during a download → verify download continues and progress is visible on Downloads screen on return
- [x] 8.5 Manually test: PDF download pause/resume (no watermark, then with watermark)
- [x] 8.6 Run `flutter analyze` in `packages/core` and `packages/courses` — zero new errors
- [x] 8.7 ~~Test on a device with existing downloads (pre-migration data)~~ — N/A: schemaVersion remains at 1 pre-production
