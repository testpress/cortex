## 1. Core Model and DTO Updates

- [x] 1.1 Add `LessonType.assignment` to `LessonType` enum in `packages/core/lib/data/models/lesson_dto.dart`
- [x] 1.2 Update `LessonDto.isComplete` for `LessonType.assignment`
- [x] 1.3 Update `LessonDto._identifyLessonType` to detect content type "assignment"
- [x] 1.4 Implement `LessonDto._parseAssignmentLesson` in `packages/core/lib/data/models/lesson_dto.dart`
- [x] 1.5 Update `LessonDto.mergeWith` to preserve assignment type, title, and `contentUrl` against partial detail responses

## 2. Table and Repository Updates

- [x] 2.1 Update `course_repository.dart` (`_parseType`) in `packages/courses/lib/repositories/course_repository.dart` to map `assignment` to `LessonType.assignment`
- [x] 2.2 Verify Drift `LessonsTable` persistence and roundtrip mapping for `LessonType.assignment`

## 3. Dynamic Domain & SSO URL Resolution

- [x] 3.1 Create assignment SSO URL resolver provider in `packages/courses` that resolves formatted `domainUrl` from `InstituteSettings` and requests `userRepo.getPresignedSsoUrl()` with `next=/chapters/<chapter_slug>/<content_id>/`

## 4. Protected WebView Viewer & Orchestrator

- [x] 4.1 Implement `AssignmentLessonViewer` in `packages/courses` with `onNavigationRequest` protection restricting navigation to the assignment flow
- [x] 4.2 Connect `LessonType.assignment` in `LessonDetailOrchestrator` to `AssignmentLessonViewer`
- [x] 4.3 Update `ChapterContentItem` to display assignment icon (`LucideIcons.fileCheck`) and label

## 5. Verification

- [x] 5.1 Add unit tests for assignment lesson parsing and safe merging in `packages/core/test/data/models/lesson_dto_test.dart`
- [x] 5.2 Run `dart analyze` across `packages/core` and `packages/courses` to verify zero errors or lints

## 6. Assignment Detail UI & File Interactions

- [x] 6.1 Hide "Mark as completed" and header title for assignment details in `LessonDetailOrchestrator` / `LessonDetailShell`
- [x] 6.2 Hide sticky footer (`< Previous` / `< Next`) for assignment details in `LessonDetailOrchestrator`
- [x] 6.3 Remove header gap in `AppWebView` media mode by disabling top SafeArea and resetting outer margin/padding
- [x] 6.4 Enable file upload via `setOnShowFileSelector` in `AppWebView` using `FilePicker`
- [x] 6.5 Enable attachment downloading via `url_launcher` in `AssignmentLessonViewer` and `isDownloadOrMediaUrl` helper
