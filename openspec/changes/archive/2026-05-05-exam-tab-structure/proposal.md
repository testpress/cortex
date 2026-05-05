## Why

Replicate the "Tests" tab functionality from the Android app into the Flutter SDK. This allows users to view courses specifically tagged for exams, ensuring a consistent experience across platforms.

## What Changes

- **Modified**: `CourseDto` and `CoursesTable` in `packages/core` will be extended to include `tags` and `allowedDevices` fields.
- **Modified**: `ExamsScreen` in `packages/exams` will be updated from a placeholder to a functional screen that lists courses.
- **New**: Logic to filter courses by the `exams` tag and `mobile` device allowance, mirroring the Android app's behavior.
- **New**: Basic structure for navigating to exam categories or exam lists (to be fully implemented in a later phase).

## Capabilities

### New Capabilities
- `exam-course-list`: Capability to fetch, store, and display a list of courses filtered by tags (specifically the `exams` tag).

### Modified Capabilities
- `course-api`: Requirements updated to include `tags` and `allowed_devices` in the course data contract.
- `lms-navigation-shell`: Ensure the Exams tab routes correctly to the new structure.

## Impact

- `packages/core`: Changes to data models and database schema (requires code generation).
- `packages/exams`: Implementation of the primary exams listing UI.
- `packages/courses`: Potential reuse or coordination of course listing logic.
