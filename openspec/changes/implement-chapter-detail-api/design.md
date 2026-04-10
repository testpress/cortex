## Context

Currently, the app only fetches chapter metadata for courses. The detailed content list (lessons, activities) is not synchronized, which causes the "All", "Video", "Lesson", etc. filters in the curriculum view to appear empty.

## Goals / Non-Goals

**Goals:**
- Integrate the Testpress V3 "Contents" API for courses.
- Populated the local database with all lessons for a specific course.
- Enable curriculum-wide filtering by lesson type.

**Non-Goals:**
- Schema migrations or major database refactoring.
- Implementing playback/viewing logic for individual lessons.

## Decisions

### 1. Unified Content Synchronization
- **Choice**: Add a `refreshCourseContents` method to `CourseRepository` that orchestrates multiple API calls.
- **Rationale**: While `/api/v3/courses/{id}/contents/` provides the bulk of the curriculum, status-specific endpoints like `/running_contents/`, `/upcoming_contents/`, and `/content_attempts/` (History) are necessary to populate progress-related UI components and provide a comprehensive student view.
- **APIs**:
    - `Full Curriculum`: `/api/v3/courses/{id}/contents/`
    - `Running`: `/api/v2.5/courses/{id}/running_contents/`
    - `Upcoming`: `/api/v2.5/courses/{id}/upcoming_contents/`
    - `History (Attempts)`: `/api/v2.5/courses/{id}/content_attempts/`

### 2. Reactive Status Filtering on Leaf Chapters
- **Choice**: Implement "Running", "Upcoming", and "History" filters specifically on the leaf chapter detail page.
- **Rationale**: When a user selects a leaf chapter, they expect to see the curriculum items of that chapter organized by their current status.
- **Logic**:
    - The repository will maintain three set of content IDs (Running, Upcoming, History) synced from their respective APIs.
    - When viewing a chapter, the app will filter the chapter's contents by checking if their IDs exist in the active status set.

## Risks / Trade-offs

- **[Risk] Large Course Data** → [Mitigation] The contents API is paginated; the repository will handle initial pages to satisfy the immediate UI needs.
