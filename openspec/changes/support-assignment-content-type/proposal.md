## Why

The backend provides assignments as chapter contents (content type "Assignment", content_type = 9). The API often omits `content_url` (e.g. filtered V3 contents API) and detail responses omit `content_type` and `title`. Currently, Cortex treats assignments as `LessonType.unknown`, and merging detail responses overwrites cached list attributes. Furthermore, opening web-based assignments requires dynamic institute domain resolution, presigned SSO authentication, and WebView navigation protection to prevent students from navigating away to other portal pages.

## What Changes

- **Core Model & Parsing**:
  - Add `LessonType.assignment` to `LessonType` in `packages/core`.
  - Update `LessonDto._identifyLessonType` to detect content type "assignment".
  - Update `LessonDto.mergeWith` to safely retain assignment type, title, and `contentUrl` when merged with partial detail responses.
  - Update `CourseRepository` (`_parseType`) and `LessonsTable` to persist and restore assignment lessons.

- **Dynamic Domain Resolution & SSO Web URL**:
  - Construct target web path using canonical format: `/chapters/<chapter_slug>/<content_id>/`.
  - Resolve domain dynamically from `InstituteSettings.domainUrl` (falling back to API host) matching the pattern established in `MyReportScreen`.
  - Authenticate using `UserRepository.getPresignedSsoUrl()` with `next=/chapters/<chapter_slug>/<content_id>/`.

- **Protected WebView Viewer**:
  - Render assignment in a protected WebView within `LessonDetailOrchestrator`.
  - Protect page navigations in `onNavigationRequest` to restrict student browsing strictly to the assignment workflow.
  - Map assignment icon and label in `ChapterContentItem` (no curriculum filter chip badge needed).

## Capabilities

### New Capabilities
- `assignment-lesson-support`: Defines assignment parsing, local table persistence, dynamic SSO URL construction using institute domain settings, and protected WebView lesson viewing.

### Modified Capabilities

## Impact

- `packages/core`: `LessonType`, `LessonDto` parsing and merge safety.
- `packages/courses`: `CourseRepository` table mapping, assignment SSO resolution, protected WebView viewer, and `LessonDetailOrchestrator` integration.
