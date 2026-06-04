## Context

The Flutter application provides offline video learning capabilities using the TPStreams SDK. Currently, attachment downloads are fully functional, but video download management relies on a mocked layer (`_mockVideoDownloads` inside `DownloadsService`). TPStreams recently introduced download support built directly into their SDK and player widget, allowing users to initiate downloads natively from the player UI, manage states via `TPStreamsDownloadManager`, and stream offline.

## Goals / Non-Goals

**Goals:**
- Enable the native download button in `TPStreamPlayer` (`showDownloadOption: true`).
- Allow playing downloaded videos seamlessly offline using `TPStreamPlayer.offline()`.
- Keep the app's overall `DownloadsScreen` and local Drift DB synced with the `TPStreamsDownloadManager` via its `downloadsStream`.
- Replace the mock download methods in `DownloadsService` with actual SDK implementations (`pauseDownload`, `resumeDownload`, `deleteDownload`, `getAllDownloads`).

**Non-Goals:**
- Building a custom UI button to trigger video downloads outside the player. The TPStreams player handles this natively.
- Background sync optimization beyond what's already provided by TPStreams SDK.

## Decisions

### 1. Unified State Synchronization Strategy
**Decision:** We will subscribe to `TPStreamsDownloadManager.downloadsStream` inside our `DownloadsService` or `DownloadsRepository` to continuously sync state to our existing Drift DB.
**Rationale:** The app relies on a central `downloadsProvider` reading from `DownloadsRepository` for UI rendering in `DownloadsScreen`. To maintain consistency across the app, we'll listen to the SDK stream, map `DownloadAsset` to our domain `DownloadItem`, and call `upsertDownload` on the DB.
**Alternatives Considered:** Reading directly from the TPStreams SDK stream in the `DownloadsScreen` UI. This was rejected because the UI groups and combines attachments (custom download logic) and videos (TPStreams logic), so a unified local database cache (`AppDatabase`) remains the best single source of truth.

### 2. Handling Offline Playback in Player Widget
**Decision:** Modify `CustomVideoPlayer` to check the `DownloadsRepository` for the video's status. If `DownloadStatus.completed`, initialize the player via `TPStreamPlayer.offline(assetId: ...)`. Otherwise, initialize via standard `TPStreamPlayer(assetId: ...)`.
**Rationale:** The user expects seamless playback of downloaded content to save bandwidth.

## Risks / Trade-offs

- **Risk**: Desynchronization between `TPStreamsDownloadManager` state and our Drift `AppDatabase`.
  - **Mitigation**: Re-sync completely on app startup (in `synchronize()`) by calling `getAllDownloads()` and matching it with Drift records.
- **Risk**: Conflicting iOS/Android behavior (e.g., `pauseDownload` is unsupported on iOS).
  - **Mitigation**: Only expose pause/resume actions in the UI if platform is Android, or wrap the SDK calls in try-catch to swallow `UnsupportedError`.
