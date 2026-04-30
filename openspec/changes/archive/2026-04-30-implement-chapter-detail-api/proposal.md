## Why

The curriculum filters (Video, Lesson, etc.) in the Course Detail view are currently non-functional because the application does not yet integrate with the Testpress V3 Content List API. Without this data, the flattened list of lessons across chapters remains empty, preventing users from browsing or filtering course content.

## What Changes

- **Content API Integration** - Implement the synchronization of course curriculum contents via the `/api/v3/courses/{id}/contents/` endpoint, as well as status-specific endpoints for Running, Upcoming, and History (Attempts).
- **Status-Specific Sync** - Integrate `/running_contents/`, `/upcoming_contents/`, and `/content_attempts/` to provide a complete view of the student's progress and schedule.
- **Filtering Logic** - Fix the `allCourseLessonsProvider` and `ChapterDetailProvider` to correctly consume the synchronized content from the local database, enabling the functional use of curriculum filters.
- **Data Persistence** - Ensure that fetched course contents are stored in the existing local database structure to support offline-ready filtering.

## Capabilities

### New Capabilities
- `course-content-sync`: Synchronization of full course curriculum contents from the remote API.

### Modified Capabilities
- `chapter-detail`: Enhanced to support a fully populated content list and functional filtering.

## Impact

- **Repository**: `CourseRepository` needs to handle the `/contents/` API response and database upserts.
- **Providers**: `allCourseLessonsProvider` must be updated to ensure data is available before returning.
- **UI**: `ChaptersListPage` filters will become functional once data is flowing.
