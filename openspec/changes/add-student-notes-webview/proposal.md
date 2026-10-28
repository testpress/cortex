## Why

Students need a dedicated digital notebook to capture study notes, organize them into folders, tag concepts, and review notes while preparing for exams.

The rich Student Notes interface is already built on the Testpress web platform (`/student-diary/my-notes/?testpress_app=1`). Embedding this interface inside Cortex via `AppWebView` with single sign-on (SSO) gives students seamless in-app access to their notes with zero duplicate rich-text editor development.

## What Changes

- Add `studentNotesEnabled` and `studentNotesLabel` to `InstituteSettings` parsed from `/api/v2.3/settings/`.
- Introduce `studentNotesUrlProvider` in `packages/testpress` resolving the presigned SSO URL targeting `/student-diary/my-notes/?testpress_app=1` with custom institute domain fallback.
- Create `StudentNotesScreen` in `packages/testpress/lib/screens/student_notes_screen.dart` utilizing `AppWebView` with camera/storage permissions, custom header with back navigation, and error/loading states.
- Support Android hardware and gesture back navigation using `PopScope` to navigate backward in internal WebView history before popping the screen.
- Register `/student-notes` in `GlobalRoutes.immersiveRoutes`.
- Add a "Notes" navigation entry point in `DashboardDrawer` gated by `studentNotesEnabled`.
- Add localization strings for Student Notes across supported languages.

## Capabilities

### New Capabilities
- `student-notes-screen`: WebView-based notes screen with presigned SSO authentication, custom navigation header, back navigation delegate, and embedded `AppWebView`.

### Modified Capabilities
- `institute-settings`: Extend `InstituteSettings` to parse and expose `student_notes_enabled` and `student_notes_label`.

## Impact

- **Packages**: `packages/core` (`InstituteSettings`, l10n strings) and `packages/testpress` (`StudentNotesScreen`, `DashboardDrawer`, `GlobalRoutes`, URL provider).
- **APIs**: Consumes existing `getPresignedSsoUrl()` API and institute settings endpoint.
- **Dependencies**: Uses existing `AppWebView` and `permission_handler` from `packages/core`.
