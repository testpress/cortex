## Why

Various screens and widgets across `packages/testpress`, `packages/courses`, and `packages/profile` (excluding `packages/exams`) currently use raw `Text` widgets with manual inline `TextStyle` properties. This violates the project's strict styling guidelines in `packages/core/docs/ai_context.md`, causing inconsistent typography rendering, ignoring semantic design tokens, and failing to cleanly integrate with global typography scale adjustments.

## What Changes

Migrate all occurrences of raw `Text` widgets in the following areas to use the semantic variants of `AppText`:
- Category section headers, lesson card titles, subtitles, metadata, and progress badges in `lesson_cards_section.dart` (Dashboard).
- Bookmark screens generic error displays.
- Downloads screen video thumbnail duration labels, file type badges, and download error SnackBars.
- Ask Doubt FAB labels.
- Attachment viewer title, caption, download progress, download failure, and warning SnackBars.
- Video quality setting recommendations/defaults labels in the App Settings screen.

## Capabilities

### New Capabilities
<!-- None -->

### Modified Capabilities
- `lms-home-paid-active`: Require all text elements on the dashboard home screen to resolve style primarily through semantic `AppText` constructors.
- `bookmarks`: Ensure all text elements on the bookmarks screen use semantic `AppText` primitives.
- `attachment-downloads`: Ensure all text elements on the downloads screen and attachment viewer use semantic `AppText` primitives.
- `ask-doubt-fab`: Ensure all text elements on the ask doubt FAB use semantic `AppText` primitives.
- `app-settings`: Ensure all settings labels on the app settings screen use semantic `AppText` primitives.

## Impact

Refactor raw `Text` instances to semantic `AppText` widgets in:
- `packages/testpress/lib/screens/dashboard/widgets/lesson_cards_section.dart`
- `packages/testpress/lib/screens/bookmarks/bookmarks_screen.dart`
- `packages/courses/lib/screens/downloads_screen.dart`
- `packages/courses/lib/widgets/lesson_detail/ask_doubt_fab.dart`
- `packages/courses/lib/widgets/lesson_detail/attachment_viewer.dart`
- `packages/profile/lib/screens/app_settings_screen.dart`
