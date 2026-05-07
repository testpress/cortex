## 1. Foundation

- [x] 1.1 Create `DownloadItem` data model and database tables.
- [x] 1.2 Register the `DownloadsScreen` route in the navigation system.
- [x] 1.3 Implement `DownloadsRepository` for data coordination.
- [x] 1.4 Implement `DownloadsService` for SDK integration.

## 2. UI Implementation

- [x] 2.1 Implement `DownloadsScreen` shell with back button and tabbed navigation.
- [x] 2.2 Build the `DownloadVideoItem` widget with duration, size, and metadata.
- [x] 2.3 Build the `DownloadAttachmentItem` widget with file-type icons.
- [x] 2.4 Implement the empty state view for both tabs.
- [x] 2.5 Implement the storage info footer with dynamic total size calculation.

## 3. Integration & Aesthetics

- [x] 3.1 Add the "Downloads" menu item to `DashboardDrawer`.
- [x] 3.2 Implement navigation from the drawer to the `DownloadsScreen`.
- [x] 3.3 Implement `downloadsBootstrapProvider` for automatic background sync.
- [x] 3.4 Integrate `Skeletonizer` with `ShimmerEffect` and custom visibility rules (e.g., hiding duration badges).
- [x] 3.5 Implement persistent deletion and action providers.
