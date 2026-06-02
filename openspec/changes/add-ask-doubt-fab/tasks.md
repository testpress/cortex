## 1. Routing and Navigation

- [x] 1.1 Check the route registration for `AskDoubtFormScreen` (e.g., in `home_routes.dart`) to ensure it can accept `lessonTitle` via route parameters or the `extra` object, alongside `chapterContentId`.

## 2. Update AskDoubtFormScreen

- [x] 2.1 Add `String? lessonTitle` property to `AskDoubtFormScreen` and its constructor.
- [x] 2.2 Update `_contextLinkBadge` in `AskDoubtFormScreen` to display the actual `lessonTitle` when available, instead of just the generic "Linked to Lesson ID: {id}".

## 3. Wire Up AskDoubtFab

- [x] 3.1 In `LessonDetailOrchestrator`, wire the `AskDoubtFab.onTap` to navigate to the ask doubt route (e.g., via `context.push`), passing the parsed `lesson.id` as `chapterContentId` and `lesson.title` as `lessonTitle`.
- [x] 3.2 Verify that the `context.pop()` inside `AskDoubtFormScreen` properly navigates back to the lesson detail screen upon successful submission.
