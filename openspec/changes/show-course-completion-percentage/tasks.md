## 1. Data Model and Database Setup

- [x] 1.1 Update `CourseDto` progress type from `int` to `double` and add `formattedProgress` getter
- [x] 1.2 Update `CoursesTable` Drift schema changing progress from `IntColumn` to `RealColumn`
- [x] 1.3 Increment Drift `schemaVersion` to `29` in `AppDatabase`

## 2. API Integration and Parsing

- [x] 2.1 Update JSON parsing in `HttpDataSource.getCourses` to parse and match `user_course_credits` array items
- [x] 2.2 Update `CourseDto.fromJson` to accept an optional matching `credit` map and populate progress and completedLessons
- [x] 2.3 Update `MockDataSource` to support double progress values in mock courses

## 3. UI and Verification

- [x] 3.1 Update `CourseCard` widget to display the formatted completion percentage and lessons progress ratio
- [x] 3.2 Run database build generation script (`dart run build_runner build`) to update Drift code
- [x] 3.3 Verify changes build and local test suite runs successfully
