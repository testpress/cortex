# Design: Course Detail API Integration V3

## Context
The current implementation uses a generic course list. To provide a rich learning experience, we need specific endpoints for course metadata, hierarchical chapters, and flat lesson lists. This design outlines how we will integrate these V3 endpoints into the networking and data layers.

## Goals / Non-Goals

**Goals:**
- Add V3 endpoints for course details, chapters, and contents to `ApiEndpoints`.
- Implement `CourseDetailDto` to capture rich metadata (description, total lessons, etc.).
- Map v3 API fields to specialized DTOs (CourseDto, ChapterDto, LessonDto).
- Support **hierarchical chapters** via `parentId` and `isLeaf` properties.
- Implement a **recursive UI navigation** pattern for drilling down into nested curriculum.
- Ensure type-safe mapping from API responses to internal models.
- Optimize data flow using **reactive repository watchers** and non-blocking background refreshes (`.ignore()` pattern).

**Non-Goals:**
- Pagination of course contents (unless explicitly required by the API and user).
- Offline storage for these specific details (to be handled in a separate task/change).
- UI implementation (this change focuses on the API and data layer).

## Decisions

### 1. Endpoint Structure
We will add the following to `ApiEndpoints`:
- `courseDetail(id)` -> `/api/v3/courses/{id}/`
- `courseChapters(id)` -> `/api/v3/courses/{id}/chapters/`
- `courseContents(id)` -> `/api/v3/courses/{id}/contents/`

Wait, since `ApiEndpoints` currently uses static constants, I will use placeholders or static methods if needed, but the convention seems to be static strings where possible. However, IDs are dynamic.
Looking at `api_endpoints.dart`:
```dart
static const String courseList = '/api/v3/courses/';
```
I'll suggest adding methods for dynamic paths if not already present, or just define the base paths.

### 2. DTO Standardisation
We will ensure `fromJson` mappings use snake_case keys as per the Testpress API, and `toJson` (if used for caching) maintains consistency.

### 3. Separation of Concerns
- `Network layer`: Handles the requests via `Dio`.
- `Data layer`: Handles mapping to DTOs.
- `Repository layer`: Consumes DTOs from the data layer and manages live `Stream` watchers for the UI. Refactored to use `StreamGroup.merge` for reactive cross-table updates.
- `Design layer`: Added `transparent` color token to `DesignColors` to remove Material dependencies from the curriculum UI.

## Risks / Trade-offs

- **Data Redundancy**: Some fields might overlap between `CourseDto` (from list) and `CourseDetailDto`. We will prioritize `CourseDetailDto` for the detail view.
- **Flat vs Hierarchical**: The API provides both nested chapters and flat content lists. We will prioritize the hierarchical model (`ChapterDto.parentId`) for navigation while using content totals for progress tracking.
- **Performance**: Use `.ignore()` for background refreshes to ensure the UI remains fully responsive using cached database data while network syncs happen asynchronously.

## Open Questions
- Does `/api/v3/courses/{id}/contents/` support filtering?
- Should we reuse `CourseDto` for the detail endpoint or create a separate `CourseDetailDto`? (Given the metadata like "Description", a separate/extended DTO is likely better).
