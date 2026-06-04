## 1. TPStreams Service Integration

- [x] 1.1 Update `DownloadsService` to instantiate `TPStreamsDownloadManager` and remove the `_mockVideoDownloads`.
- [x] 1.2 Replace `pauseVideoDownload`, `resumeVideoDownload`, `deleteVideoDownload`, and `getActiveVideoDownloads` in `DownloadsService` with actual `TPStreamsDownloadManager` calls.
- [x] 1.3 Add a getter or method in `DownloadsService` to expose the `downloadsStream` from the SDK.

## 2. State Management & Repository Sync

- [x] 2.1 Update `DownloadsRepository` to listen to the `downloadsStream` from `DownloadsService` upon initialization or first access.
- [x] 2.2 Create a mapper function to convert the SDK's `DownloadAsset` to our domain `DownloadItem` model.
- [x] 2.3 Update `DownloadsRepository.synchronize()` to ensure it fetches real active videos via `getAllDownloads()` and purges orphaned DB records appropriately.
- [x] 2.4 In the stream listener, call `upsertDownload` whenever an update is received to keep the Drift DB fresh.

## 3. Video Player UI Updates

- [x] 3.1 Modify `CustomVideoPlayer` (`packages/courses/lib/widgets/lesson_detail/custom_video_player.dart`) to watch `watchDownloadItemProvider` for its specific `assetId`.
- [x] 3.2 Update `CustomVideoPlayer` to instantiate `TPStreamPlayer.offline(assetId: assetId)` if the status is `completed`.
- [x] 3.3 Set `showDownloadOption: true` on the standard `TPStreamPlayer` constructor for non-downloaded videos.

## 4. Verification & Polish

- [x] 4.1 Ensure `DownloadsScreen` gracefully handles the new `DownloadItem`s and that pause/resume actions trigger correctly.
- [x] 4.2 Verify that the download status correctly reaches 100% and transitions to `completed`.
- [x] 4.3 Verify offline playback starts without errors when a fully downloaded video is opened.

## 5. Metadata Integration

- [x] 5.1 Update `CustomVideoPlayer` to accept `lessonId` and `thumbnailUrl`.
- [x] 5.2 In `CustomVideoPlayerState.initState`, fetch the course and chapter titles via `CourseRepository.getLessonDetails()`.
- [x] 5.3 Pass the fetched metadata directly into `TestpressPlayer(metadata: {...})`.
- [x] 5.4 Update `VideoLessonDetailScreen` to pass `lessonId` and `thumbnailUrl` down to `CustomVideoPlayer`.
- [x] 5.5 Update `DownloadsService._mapAssetToDownloadItem` to read `thumbnail_url` from metadata.

## 6. Offline Video Player UI

- [x] 6.1 Implement `OfflineVideoPlayerScreen` for playing downloaded videos directly from the downloads page.
- [x] 6.2 Format the course and chapter breadcrumb dynamically using `Text.rich` with primary colors.
- [x] 6.3 Add a "More Options" (`moreVertical`) button to the screen header.
- [x] 6.4 Implement an `AppBottomSheet` triggered by the options menu to house the "Delete Download" action, matching the floating card design from the discussions screen.
