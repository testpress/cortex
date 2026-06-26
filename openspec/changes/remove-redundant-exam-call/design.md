## Context

The current exam flow involves an architectural inefficiency. When users launch a course-linked exam (e.g., from a syllabus list), the app fetches the course content details (`/api/v2.4/contents/{id}/`). This endpoint returns the fully-populated `exam` payload nested inside the content. However, the `LessonDto` drops this nested data during parsing. Because `LessonDto` doesn't retain the data, the UI screens (`TestDetailScreen` and `ExamPrescreen`) are forced to invoke `examDetailProvider(slug)` to manually hit `/api/v2.4/exams/{slug}/` just to acquire the exact same data to populate the UI (e.g., marks, sections, instructions).

## Goals / Non-Goals

**Goals:**
- Eliminate the redundant network request to `/api/v2.4/exams/{slug}/`.
- Update `LessonDto` to parse and retain the nested `ExamDto`.
- Refactor `TestDetailScreen` and `ExamPrescreen` to source their exam data strictly from the `LessonDto`.
- Remove the legacy `getExamBySlug` network path entirely from the frontend to enforce a single source of truth.

**Non-Goals:**
- Refactoring how exams are submitted or synced.
- Changing the backend API structures.
- Altering the visual design of the `ExamPrescreen`.

## Decisions

**Decision 1: Use Composition in LessonDto over Inheritance/Bloat**
- *Rationale*: Instead of adding a dozen exam-specific fields (like `sections`, `negativeMarks`) directly to `LessonDto`, we will add a single `ExamDto? exam` property. This maintains separation of concerns since `LessonDto` also represents Videos, PDFs, etc.
- *Alternatives Considered*: Flattening the fields into `LessonDto`, which would cause severe model bloat.

**Decision 2: Complete Removal of the standalone Exam Slug API call**
- *Rationale*: By entirely stripping out the `examDetailProvider` and the `getExamBySlug` data source methods, we enforce that the application *must* rely on the course content hierarchy.
- *Alternatives Considered*: Keeping the slug endpoint as an emergency fallback for deep links. Rejected because the platform strictly considers all exams as part of a course curriculum, rendering standalone slug lookups logically invalid.

## Risks / Trade-offs

- **[Risk] Deep link parsing failure**: If a deep link is received containing only an exam slug (without a content ID), the app will no longer be able to resolve it.
  - *Mitigation*: Ensure all routing structures rely on `contentId` rather than exam slug.

## Migration Plan

1. Update `LessonDto` model and its `.fromJson` parser.
2. Refactor `TestDetailScreen` and `ExamPrescreen` to extract `exam` directly from `lesson.exam`.
3. Delete `examDetailProvider`, `ExamRemoteDataSource.getExamBySlug`, and `ApiEndpoints.examDetail`.
4. Fix any compilation errors in test suites or unused imports.
