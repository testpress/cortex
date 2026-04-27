# Tasks: Course Detail API Integration V3

## 1. Constants & Configuration

- [x] 1.1 Add `courseDetail`, `courseChapters`, and `courseContents` endpoints to `ApiEndpoints` in `packages/core/lib/network/api_endpoints.dart`.

## 2. Models & DTOs

- [x] 2.1 ~~Create `CourseDetailDto`~~ — Not needed. Added `description` field directly to `CourseDto` and updated `fromJson` to map from v3 response.
- [x] 2.2 Updated `ChapterDto` to match v3 `/chapters/` response fields:
  - `name` → `title`
  - `contents_count` → `lessonCount`
  - `exams_count + quizzes_count` → `assessmentCount`
  - `order` → `orderIndex`
  - `id`/`course_id` as int cast to String
  - Added `parentId` and `isLeaf` fields for hierarchical curriculum support.
- [x] 2.3 Updated `LessonDto` to map v3 `/contents/` response fields:
  - `content_type` string → `LessonType` enum (Video, Exam/Quiz, Notes/Attachment, VideoConference, Live Stream)
  - `progressStatus` from `content_attempts[].state` (0=inProgress, 1=completed, absent=notStarted)
  - `duration` resolved by joining exam/video sub-arrays by id
  - Added `courseId` and `icon` fields
- [x] 2.4 Deleted `course_detail_dto.dart` (not needed).

## 3. Data Source & Repository

- [x] 3.1 Added `getCourseDetail` and `getCourseContents` to `DataSource`.
- [x] 3.2 Implemented real network calls in `HttpDataSource`.
- [x] 3.3 Implemented stubs/aggregation in `MockDataSource`.
- [x] 3.4 Added `refreshCourseContents` to `CourseRepository`.
- [x] 3.5 Refactored `watchCourse` and `watchChapters` to use `async*` and `StreamGroup.merge` for simplified reactive logic.
- [x] 3.6 Implemented non-blocking background refreshes using the `.ignore()` pattern in providers.
- [x] 3.7 Fixed all exhaustive switch statements across UI widgets.
- [x] 3.8 Implement network fallback in `watchCourse` to support non-persisted search result navigation.

## 4. Providers & Flow

- [x] 4.1 Updated `courseChaptersProvider` to trigger bulk refresh of chapters and lessons together.
- [x] 4.2 Optimized `courseDetailProvider` and `courseChaptersProvider` to hide network latency via cached DB streaming and background `.ignore()` refreshes.

## 5. UI & Hierarchy
- [x] 5.1 Updated `ChaptersListPage` to filter by `parentId`.
- [x] 5.2 Implemented recursive navigation logic (push self with `parentId`).
- [x] 5.3 Created dynamic header titles and sub-chapter counts.
- [x] 5.4 Standardized `ChapterCurriculumItem` icon logic with system-wide `transparent` color token.
- [x] 5.5 Added `transparent` Color token to `DesignColors` in core package.
