## Why

The backend API (`/api/v3/courses/`) now returns a list of `user_course_credits` containing precise learning progress metadata, specifically `course_completion_percentage` and `total_unique_attempts`. Incorporating these fields allows the cortex client to display real-time, accurate course completion percentages and completed content metrics to the user.

## What Changes

- Parse `user_course_credits` in the course list network responses and associate completion percentage and total unique attempts with each course DTO.
- Show the new completion percentage and completed/total contents ratio in the course cards within the Study tab.
- Persist the completion percentage and completed lessons to the local database to support offline-first rendering.

## Capabilities

### New Capabilities
<!-- Capabilities being introduced. Replace <name> with kebab-case identifier (e.g., user-auth, data-export, api-rate-limiting). Each creates specs/<name>/spec.md -->

### Modified Capabilities
<!-- Existing capabilities whose REQUIREMENTS are changing (not just implementation).
     Only list here if spec-level behavior changes. Each needs a delta spec file.
     Use existing spec names from openspec/specs/. Leave empty if no requirement changes. -->
- `course-api`: Parse and map `user_course_credits` elements (completion percentage and unique attempts) from the `/api/v3/courses/` endpoint response into course DTO structures and database records.

## Impact

- `packages/core/lib/data/models/course_dto.dart`: Add a static `fromListResponse` method to deserialize and merge course progress metrics from `user_course_credits`.
- `packages/core/lib/data/sources/http_data_source.dart`: Keep clean by delegating paginated response parsing to `CourseDto.fromListResponse`.
- `packages/courses/lib/repositories/course_repository.dart`: Keep clean by removing any custom merging logic and saving already enriched results.
- `packages/courses/lib/widgets/course_card.dart`: Display completion percentage and contents progress based on the mapped API fields.
