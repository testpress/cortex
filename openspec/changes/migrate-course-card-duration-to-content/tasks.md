## 1. Data Layer (Core Package)

- [x] 1.1 Update `CourseDto` to include the `totalContents` (int) field and deprecate `totalDuration`.
- [x] 1.2 Update `RemoteCourseDto` to map the API field `total_contents` to `totalContents`.
- [x] 1.3 Add `totalContents` column to `CoursesTable` in the Drift database schema.
- [x] 1.4 Increment `AppDatabase` schema version and implement the non-destructive migration in `onUpgrade`.
- [x] 1.5 Run `build_runner` to regenerate Drift database code.
- [x] 1.6 Update `MockDataSource` to provide `totalContents` for development environments.

## 2. UI & Localization (Domain Package)

- [x] 2.1 Add `labelContentsPlural` to localization files (`app_en.arb`, etc.).
- [x] 2.2 Update `CourseCard` to display `totalContents` from `CourseDto` instead of `totalDuration`.
