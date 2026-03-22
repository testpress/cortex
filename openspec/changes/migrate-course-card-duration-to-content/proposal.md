## Why

The current `CourseCard` displays `totalDuration` (e.g., "180 hrs"), which is often an approximation and less informative than the actual count of learning items. To provide students with a better sense of course volume, we are migrating to `totalContents`. This provides a more granular metric that includes lessons, assessments, and tests, aligning with the Testpress API standard.

## What Changes

- **Core Data Model**: Update `CourseDto` to include a `totalContents` field.
- **API Mapping**: Update `RemoteCourseDto` to parse `total_contents` from the Testpress API and map it to `CourseDto`.
- **Local Persistence**: Add a `total_contents` column to `CoursesTable` in Drift and implement a non-destructive migration in `AppDatabase`.
- **Mock Data**: Update `MockDataSource` to provide realistic `totalContents` values for development.
- **UI Components**: Update `CourseCard` in the `courses` package to display the content count (e.g., "120 contents") instead of the duration string.

## Capabilities

### New Capabilities
- None.

### Modified Capabilities
- `study-curriculum-list`: The metadata displayed for each course in the curriculum list is updated to show the total number of contents instead of the total duration.

## Impact

- **Drift DB**: Requires a schema migration (v7 -> v8).
- **Domain Models**: `CourseDto` modification affects any consumers of this DTO.
- **UI**: Direct change to `CourseCard`'s metadata row.
