## Context
The current file management in lesson viewers (`AppPdfViewer` and `AttachmentViewer`) handles storage paths, permissions, and download progress directly in the UI. This leads to UX and privacy issues: PDFs are exposed to users, and attachments are hidden from them. We need a clear architectural boundary between downloading files and presenting them.

## Goals / Non-Goals

**Goals:**
- **Architectural Cleanup:** Create a `FileDownloader` utility in the `core` package to centralize path resolution and downloads.
- **Silent PDF Caching:** Store PDFs in the internal `Application Support` directory. Remove explicit download progress UI from the PDF viewer. Implement background pre-fetching via the repository.
- **Explicit Attachment Downloads:** Store attachments in the public `Downloads` folder so users can access them externally. Retain the download progress UI for attachments.

**Non-Goals:**
- Implementing a complex foreground service for large downloads.
- Providing an in-app file manager for downloaded attachments.

## Decisions

- **Decision 1: Centralized `FileDownloader`** → Create a utility class that accepts a `StorageType` enum (`internalCache` vs `publicDownload`) to dictate the destination directory and handle necessary permissions natively.
- **Decision 2: Storage Destinations** → 
  - `internalCache` = `getApplicationSupportDirectory()` (Hidden from users).
  - `publicDownload` = `getDownloadsDirectory()` with a fallback to `/storage/emulated/0/Download` on Android.
- **Decision 3: Direct Provider Usage** → UI widgets (`AttachmentViewer`, `AppPdfViewer`) and providers (`lessonDetailProvider`) will use `fileDownloaderProvider` directly. `CourseRepository` will remain decoupled from file downloading to avoid bleeding UI concerns (like `CancelToken` and progress tracking) into the data layer.

## Risks / Trade-offs
- [Risk] Public Downloads permission handling on varied Android OS versions.
- [Mitigation] The `FileDownloader` will centralize permission handling (`permission_handler`) ensuring robust fallback mechanisms for scoped storage.
