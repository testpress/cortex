## 1. UI Component Updates

- [x] 1.1 Refactor the `DoubtContextBadge` and `_BreadcrumbHeader` properties to use `List<String> breadcrumbs` instead of `courseName` and `chapterName`.
- [x] 1.2 Update `AskDoubtFormScreen` and `DoubtDetailScreen` to pass the correct `breadcrumbs` list (e.g., `[data.courseTitle, data.chapterTitle]` or `[examTitle]`).
- [x] 1.3 Update the exam review routing (e.g. `review_answer_detail_screen.dart` and `home_routes.dart`) to pass the `assessmentTitle` (Exam Title) along with the stripped question text.
- [x] 1.4 Update the Ask Doubt compose screen to display the Exam Title in the breadcrumb and the stripped question text inside the context box.
