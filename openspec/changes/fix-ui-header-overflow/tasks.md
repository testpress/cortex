## 1. Fix Header Paddings

- [x] 1.1 Update `DownloadsHeader` in `packages/courses/lib/widgets/downloads_header.dart` to use a smaller left padding (`design.spacing.md`) instead of `design.spacing.screenPadding`
- [x] 1.2 Identify the Bookmarks screen header and update its left padding similarly
- [x] 1.3 Identify the Ask Doubt screen header and update its left padding similarly
- [x] 1.4 Identify the Announcements screen header and update its left padding similarly
- [x] 1.5 Update the App Settings screen header to align the back button and title
- [x] 1.6 Update the Analytics screen header to align the back button and fix CrossAxisAlignment

## 2. Fix Ask Doubt Layout Overflow

- [x] 2.1 Locate the doubt item card widget used in the Ask Doubt screen (likely in `packages/discussions`)
- [x] 2.2 Modify the Doubt card layout to place the timeline text on the third row and the status badge on the fourth row
- [x] 2.3 Ensure the lesson title on the second row spans the full width without right overflow

## 3. App Drawer Cleanup

- [x] 3.1 Remove the "Reports" option from the DashboardDrawer
