## Why

Currently, when a user accesses a course-linked exam, the app fetches the content details from `/api/v2.4/contents/{id}/` which contains the fully populated nested `exam` object. However, `LessonDto` drops this data, forcing the app to make a redundant API call to `/api/v2.4/exams/{slug}/` just to fetch the exact same exam metadata (such as duration, marks, and sections) for the UI. Eliminating this redundant network request will improve app performance, reduce backend load, and simplify the data flow.

## What Changes

- Add a new `exam` field (`ExamDto?`) to `LessonDto`.
- Update `LessonDto.fromJson` to parse the nested `exam` JSON block into an `ExamDto`.
- Remove the redundant calls to `examDetailProvider(slug)` in `TestDetailScreen` and `ExamPrescreen`, replacing them with direct access via `lesson.exam`.
- **BREAKING**: Complete removal of `examDetailProvider`, `getExamBySlug` from `ExamRepository` and `ExamRemoteDataSource`, and the `examDetail` slug endpoint from `api_endpoints.dart` to strictly enforce the content-driven exam lookup.

## Capabilities

### New Capabilities
*(None)*

### Modified Capabilities
- `lesson-exam-metadata`: Incorporating the full `ExamDto` directly into the `LessonDto` payload to retain all nested exam metadata from the backend.
- `exam-prescreen-ui`: Updating the prescreen to consume exam metadata directly from the lesson object instead of falling back to a separate exam detail network call.

## Impact

- **Code**: Modifications to `LessonDto`, `ExamPrescreen`, `TestDetailScreen`, `ExamRepository`, `ExamRemoteDataSource`, `exam_providers.dart`, and `api_endpoints.dart`.
- **APIs**: The client will no longer invoke the `/api/v2.4/exams/{slug}/` endpoint.
- **Dependencies**: No external dependencies are affected.
