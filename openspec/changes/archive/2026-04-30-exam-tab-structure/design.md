## Context

The Android app includes a "Tests" tab that displays courses specifically tagged for exams. This is implemented by filtering the standard course list by the `exams` tag and ensuring the course is compatible with `mobile` devices. Currently, the Flutter SDK's course models and database schema do not include these fields.

## Goals / Non-Goals

**Goals:**
- Extend `CourseDto` and `CoursesTable` in the `core` package to include `tags` (List of Strings) and `allowedDevices` (List of Strings).
- Update the API mapping in `CourseDto.fromJson` to handle these new fields from the `/api/v3/courses/` (or v2.4) response.
- Implement a filtered view of courses in the `ExamsScreen` within the `exams` package.
- Ensure the `ExamsScreen` uses the existing `Design` system for consistent look and feel.

**Non-Goals:**
- Implementing the actual exam-taking interface (this is a separate phase).
- Implementing deep navigation into exam categories or detailed analytics.

## Decisions

### 1. Model Extension
We will add `tags` and `allowedDevices` directly to `CourseDto` and `CoursesTable` rather than creating a separate `Exam` model for the listing.
- **Rationale**: The backend uses the Course API for the initial listing in the Tests tab. Maintaining a single model reduces duplication and complexity.

### 2. Filtering Logic
Filtering will be applied in the repository or a dedicated Riverpod provider.
- **Rationale**: Keeps the UI (ExamsScreen) focused on presentation and allows for easy unit testing of the filtering logic.

### 3. Database Schema Update
`CoursesTable` will be updated with two new `TextColumn`s that store JSON-encoded strings of tags and allowed devices.
- **Rationale**: Drift handles basic types; storing lists as JSON strings is a common pattern for simple tag lists.

## Risks / Trade-offs

- **Risk**: API version mismatch. The reference mentions v2.4, but current spec uses v3.
- **Mitigation**: Verify if v3 includes `tags` and `allowed_devices`. If not, we may need to use v2.4 for the exams tab specifically or update the v3 mapping if the fields exist but are unmapped.
- **Trade-off**: Storing lists as JSON strings in the DB makes SQL-level filtering slightly more complex, but since the list size is small, local filtering in Dart after fetching from DB is acceptable and simpler.
