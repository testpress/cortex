## Why

Currently, the app handles offline downloads for attachments, but video downloads are mocked. The TPStreams SDK provides comprehensive video downloading capabilities (via `TPStreamsDownloadManager`) and offline playback support. Integrating these features allows users to download video lessons and watch them later without an active internet connection, significantly improving the learning experience.

## What Changes

- Enable the download option in the TPStreams player UI (`showDownloadOption: true`) so users can initiate downloads directly from the player.
- Ensure the player switches to offline mode (`TPStreamPlayer.offline`) when attempting to play a fully downloaded video.
- Replace mock implementations in `DownloadsService` with actual `TPStreamsDownloadManager` SDK calls (`pauseDownload`, `resumeDownload`, `deleteDownload`, `getAllDownloads`).
- Listen to the `downloadsStream` provided by `TPStreamsDownloadManager` to keep the UI state (e.g. progress, status) perfectly synchronized with the underlying SDK.
- Support offline metadata by mapping `DownloadAsset` objects from TPStreams to our domain `DownloadItem`s.

## Capabilities

### New Capabilities
- `video-downloads`: Core capability for initiating, managing, and tracking video downloads via the TPStreams SDK, and supporting offline playback mode within the video player.

### Modified Capabilities
- `downloads-management`: Updating the downloads infrastructure to listen to the live stream of `DownloadAsset`s rather than relying strictly on the mock polling mechanism.

## Impact

- **UI**: 
  - `CustomVideoPlayer` will gain a download button and support for `offline` construction.
  - `OfflineVideoPlayerScreen` will be refined to play offline videos from the Downloads list, featuring dynamic breadcrumbs and a floating bottom sheet for management actions (e.g., deleting downloads).
- **Service Layer**: `DownloadsService` will connect directly to `TPStreamsDownloadManager`.
- **State**: The `DownloadsRepository` or `downloadsProvider` will be updated to bridge the real-time `downloadsStream` into our internal `DownloadItem` models, persisting updates effectively.
