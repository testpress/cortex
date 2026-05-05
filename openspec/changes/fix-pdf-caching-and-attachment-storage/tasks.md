# Implementation Tasks

## 1. Core Architecture: FileDownloader Utility
- [x] 1.1 Create `StorageType` enum (`internalCache`, `publicDownload`).
- [x] 1.2 Implement `FileDownloader` utility in `packages/core/lib/network/file_downloader.dart`.
- [x] 1.3 Add platform-specific directory resolution (`ApplicationSupportDirectory` vs public `Downloads`).
- [x] 1.4 Centralize Android permission handling (`permission_handler`) within `FileDownloader` for public downloads.
- [x] 1.5 Export `fileDownloaderProvider` in `core` package.

## 2. PDF Caching Implementation (Silent & Internal)
- [x] 2.1 Refactor `AppPdfViewer` to remove explicit download progress UI (use simple spinner).
- [x] 2.2 Update `AppPdfViewer` to use `fileDownloaderProvider` for internal path resolution.
- [x] 2.3 Trigger `fileDownloaderProvider` silently in `lessonDetailProvider` when lesson metadata loads.

## 3. Attachment Downloading Implementation (Explicit & Public)
- [x] 3.1 Refactor `AttachmentViewer` to rely entirely on `fileDownloaderProvider` for downloading.
- [x] 3.2 Remove hardcoded path and permission logic from `AttachmentViewer` widget.
- [x] 3.3 Ensure explicit progress UI remains functional for attachments.
