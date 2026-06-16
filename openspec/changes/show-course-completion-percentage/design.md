## Context

The backend team has exposed a list of `user_course_credits` inside the `/api/v3/courses/` endpoint response. Each credit contains progress statistics for a course:
- `course_completion_percentage`: The precise percentage of the course completed (represented as a floating point number, e.g. `5.41`).
- `total_unique_attempts`: The number of unique content items completed (represented as an integer).

We need to update the client data model, SQLite cache, and UI widgets to parse, persist, and render these new values.

## Goals / Non-Goals

**Goals:**
- Parse `user_course_credits` from the course listing response.
- Map `course_completion_percentage` to the course's progress and `total_unique_attempts` to the completed contents metric.
- Update `CoursesTable` in the Drift database to persist decimal progress values correctly.
- Update the UI to display the formatted completion percentage and lessons completion ratio.

**Non-Goals:**
- Sync other elements of `user_course_credits` (e.g. video watched duration, exam attempts, etc.).

## Decisions

### 1. Encapsulate User Course Credits Merging at DTO Layer
- **RATIONALE**: Merging the `user_course_credits` list into `CourseDto` belongs in the data/model deserialization layer, not in the `HttpDataSource` (which should remain a simple API caller) nor in the `CourseRepository` (which should focus on database caching and synchronization coordination). We encapsulate this in `CourseDto.fromListResponse(json)` to return fully-enriched `CourseDto` objects directly from the JSON deserializer.
- **ALTERNATIVES**: Merging in the repositories or sources layer. This was rejected because it either pollutes the network fetching layer or duplicates mapping logic inside repositories (like in search vs sync).

### 2. Update `CoursesTable` Schema in Drift
- **RATIONALE**: Since `course_completion_percentage` is a float, we will change the `progress` column in `CoursesTable` from `IntColumn` to `RealColumn`. We will also increment the `schemaVersion` in `AppDatabase` to `29`.
- **MIGRATION**: The database already uses a drop-and-recreate strategy on upgrades (`onUpgrade`) for development builds, which ensures a smooth transition.

### 3. Dynamic Progress Value Formatting
- **RATIONALE**: Showing trailing zeros or long decimals (e.g. `5.00%` or `5.41000%`) is unappealing. We will add a utility property `formattedProgress` to `CourseDto` that formats the progress nicely:
  - If progress has no decimal part (e.g. `10.0`), display as an integer (`10%`).
  - Otherwise, display with up to 2 decimal places (e.g. `5.41%`).

## Risks / Trade-offs

- **[Risk]**: Recreating the local database during upgrades wipes out the cached courses.
  - **Mitigation**: This is the default strategy defined in `AppDatabase` and is safe because the repository automatically fetches fresh data from the network on entry to the Study tab.
