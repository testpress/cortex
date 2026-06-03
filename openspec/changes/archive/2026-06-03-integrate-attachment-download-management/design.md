## Context

The previous implementation had two problems:
1. `AttachmentViewer` drove the download lifecycle directly, causing downloads to appear stuck if the user navigated away.
2. `DownloadsService` held a `ProviderRef` to read `DownloadsRepository`, while `DownloadsRepository` also depended on `DownloadsService` — a circular dependency.

## Goals / Non-Goals

**Goals:**
- Establish a clean 3-layer architecture for downloads, consistent with the `Auth` feature pattern.
- `DownloadsRepository` becomes the orchestrator (mirrors `AuthRepository`).
- `DownloadsService` becomes a pure worker with no DB dependencies (mirrors `AuthApiService`).
- A unified `Downloads` Notifier replaces scattered functional providers (mirrors `Auth` notifier).

**Non-Goals:**
- Integrating real `TPStreamsDownloadManager` (mocked for now with TODO markers).
- Changing how `FileDownloader` fundamentally operates.
- Moving `DownloadItem` construction out of `AttachmentViewer` (it stays in the UI per package boundary constraints — `courses` package owns course/chapter metadata resolution).

## Architecture Decision

The architecture mirrors the existing `Auth` pattern in this codebase:

| Role | Auth | Downloads |
|---|---|---|
| UI Layer | `LoginScreen` | `AttachmentViewer` / `DownloadsScreen` |
| Notifier (Provider) | `Auth` notifier | `Downloads` notifier |
| Orchestrator | `AuthRepository` | `DownloadsRepository` |
| Network Worker | `AuthApiService` | `DownloadsService` (FileDownloader, TPStreams) |
| Local Worker | `AuthLocalDataSource` | `AppDatabase` (Drift) |

## Decisions

**1. `DownloadsRepository` as the orchestrator (not `DownloadsService`)**
- *Rationale:* The existing `AuthRepository` already establishes this pattern — the Repository coordinates between a network worker (`AuthApiService`) and a local worker (`AuthLocalDataSource`). `DownloadsRepository` should do the same: coordinate between `DownloadsService` (network/SDK) and `AppDatabase` (local). This removes the circular dependency.

**2. `DownloadsService` accepts progress callbacks instead of reading the Repository**
- *Rationale:* By inverting control via a callback, `DownloadsService` becomes a pure, dependency-free worker. `DownloadsRepository` remains in control of all DB writes, ensuring the database and file system stay in sync from a single place.

**3. `Downloads` `AsyncNotifier` as the single UI-facing entry point**
- *Rationale:* Replaces scattered functional providers (`pauseDownload`, `resumeDownload`, etc.) with a single class that has a clear, discoverable API — exactly how `Auth` works. The UI calls `ref.read(downloadsProvider.notifier).startAttachmentDownload(...)`.

**4. `contentUrl` stored directly in `DownloadItem`**
- *Rationale:* To allow `DownloadsService` to handle attachment file deletions as a pure worker, it needs the original URL to resolve the local file path. By persisting `contentUrl` directly in the `DownloadsTable`, the Service can independently delete files without querying the database or relying on the Repository for lookups, preserving the strict 3-layer boundary.

## Risks / Trade-offs

- [Risk] `DownloadItem` construction still happens in `AttachmentViewer`. If course/chapter name resolution fails (network error), the download record will fall back to `'Unknown Course'`/`'Unknown Chapter'`. → Mitigation: Wrap in try/catch in `_startDownload`, show a Snackbar if the network call fails.
- [Risk] Memory leaks if `DownloadsRepository` holds `CancelToken` references. → Mitigation: Clean up cancel tokens on completion or error inside `startAttachmentDownload`.
