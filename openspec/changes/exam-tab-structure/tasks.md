## 1. Data Model & Database Updates

- [x] 1.1 Update `CourseDto` in `packages/core` to include `tags` and `allowedDevices` (with JSON mapping).
- [x] 1.2 Update `CoursesTable` in `packages/core` to include `tags` and `allowedDevices` as text columns.
- [x] 1.3 Run `dart run build_runner build --delete-conflicting-outputs` in `packages/core` to regenerate database code.

## 2. Business Logic & Filtering

- [x] 2.1 Implement `getExamCourses` logic (filtering by 'exams' tag and 'mobile' allowance) in `CourseRepository`.
- [x] 2.2 Create `examCoursesProvider` to expose the filtered stream of courses to the UI.

## 3. UI Implementation

- [x] 3.1 Update `ExamsScreen` to use `examCoursesProvider` and display a list of courses.
- [x] 3.2 Implement a basic course list layout in `ExamsScreen` using standard design tokens.
- [x] 3.3 Add placeholder for empty state (no exams tagged) and loading state.

## 4. Verification

- [x] 4.1 Verify that only courses with the 'exams' tag and 'mobile' allowance appear in the Exams tab.
- [x] 4.2 Verify navigation shell integration.
