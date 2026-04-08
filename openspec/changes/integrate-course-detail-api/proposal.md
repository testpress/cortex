# Proposal: Integrate Course Detail API V3

## Goal
Integrate the V3 Course Detail, Chapters, and Contents APIs into the LMS SDK to support rich course metadata and curriculum views.

## What Changes
- Add `courseDetail`, `courseChapters`, and `courseContents` endpoints to `ApiEndpoints`.
- Implement data structures and providers for fetching course-specific metadata (Title, Description, Counts).
- Implement hierarchical (chapters) and flat (contents) fetching strategies for course curriculum.
- Ensure the `courseList` implementation can be extended or used for individual course lookup.

## Capabilities

### New Capabilities
- `lms-course-detail-v3`: Capability to fetch full metadata for a single course via `/api/v3/courses/{id}/`.
- `lms-course-chapters-v3`: Capability to fetch a hierarchical list of chapters and contents via `/api/v3/courses/{id}/chapters/`.
- `lms-course-contents-v3`: Capability to fetch a flat list of all lessons in a course via `/api/v3/courses/{id}/contents/`.

### Modified Capabilities
- `lms-study-chapters-list`: Update requirements to reflect use of V3 APIs and rich metadata (currently TBD in spec).

## Impact
- `packages/core/lib/network/api_endpoints.dart`: New constants.
- `packages/core/lib/data/models/course_detail_dto.dart`: (New) DTO for v3 detail response.
- `packages/core/lib/data/models/chapter_dto.dart`: (New/Update) DTO for hierarchical chapters.
- `packages/courses`: Adaptation to consume v3 endpoints for the study experience.
