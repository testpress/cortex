## Why

The current implementation of attachment downloads ties the download execution and progress tracking directly to the UI lifecycle (`AttachmentViewer`). If a user starts a download and navigates away from the screen, the widget unmounts. While the low-level `FileDownloader` may complete the file transfer in the background, the UI loses the ability to push the final "completed" state to the database. This creates a bug where downloads appear permanently stuck in the "downloading" state.

Furthermore, assembling and tracking the `DownloadItem` inside the UI violates separation of concerns, and the previous implementation introduced a circular dependency between `DownloadsService` and `DownloadsRepository`.

This refactor resolves both problems by establishing a clean layered architecture that mirrors the existing `Auth` feature pattern in this codebase.

## What Changes

- **Introduce `Downloads` Notifier:** A Riverpod `AsyncNotifier` class (`Downloads`) in `downloads_provider.dart` acts as the single entry point for all download actions and state (list, start, pause, resume, delete). The UI talks only to this notifier.
- **`DownloadsRepository` as Orchestrator:** Mirrors the `AuthRepository` pattern. It coordinates between `DownloadsService` (network/SDK worker) and `AppDatabase` (local DB). Owns the full download lifecycle: insert → progress updates → completion/error.
- **`DownloadsService` as Pure Worker:** Stripped of all DB dependencies (`_ref` removed). It only executes HTTP downloads via `FileDownloader` and exposes TPStreams SDK operations (mocked for now). Progress is reported via callbacks.
- **Decouple UI:** `AttachmentViewer` constructs the initial `DownloadItem` and delegates to `ref.read(downloadsProvider.notifier).startAttachmentDownload(...)`. No direct access to `DownloadsService` or `DownloadsRepository` from the UI.

## Architecture

```
AttachmentViewer / DownloadsScreen (UI)
         ↓
Downloads Notifier — downloads_provider.dart  (courses package)
         ↓
DownloadsRepository  (Orchestrator — core package)
    ├─ AppDatabase (Drift/SQLite writes)
    └─ DownloadsService (Worker)
              ├─ FileDownloader (HTTP — attachments)
              └─ TPStreamsDownloadManager (Video SDK — mocked)
```

## Capabilities

### New Capabilities
None. This is purely an architectural refactoring to improve reliability and consistency.

### Modified Capabilities
- `attachment-downloads`: Moves download orchestration from `DownloadsService` to `DownloadsRepository`, breaking the circular dependency.
- `downloads-management`: Replaces scattered functional providers in `downloads_provider.dart` with a unified `Downloads` Notifier class, consistent with the `Auth` notifier pattern.

## Impact

- `packages/core/lib/data/services/downloads_service.dart`: Becomes a pure worker. `_ref` constructor parameter removed. `startAttachmentDownload` replaced with `downloadAttachment(url, {onProgress})`.
- `packages/core/lib/data/repositories/downloads_repository.dart`: Gains `startAttachmentDownload(DownloadItem, url)` as the orchestrator method. Circular dependency on `DownloadsService` resolved — service is injected via constructor, not held as a mutual reference.
- `packages/courses/lib/providers/downloads_provider.dart`: Converted from functional providers to a `Downloads` `AsyncNotifier` class exposing `startAttachmentDownload`, `pause`, `resume`, `delete`, and `synchronize`.
- `packages/courses/lib/widgets/lesson_detail/attachment_viewer.dart`: `_startDownload` now calls `ref.read(downloadsProvider.notifier).startAttachmentDownload(item, widget.url)`. Direct usage of `downloadsServiceProvider` removed.
