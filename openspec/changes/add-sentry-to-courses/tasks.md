## 1. Repositories Update

- [x] 1.1 Inject `sentryServiceProvider` into `CourseRepository` and update `catch` blocks to log unexpected exceptions to Sentry.
- [x] 1.2 Inject `sentryServiceProvider` into `StoreRepository` and update `catch` blocks to log unexpected exceptions to Sentry.

## 2. Providers Update

- [x] 2.1 Update `LessonDetailProvider` to capture exceptions using Sentry.
- [x] 2.2 Update `CourseListProvider` to capture exceptions using Sentry.
- [x] 2.3 Update `CourseDetailProvider` to capture exceptions using Sentry.
- [x] 2.4 Update `VideoAttemptProvider` to capture exceptions using Sentry.
- [x] 2.5 Update `InfoProviders` and `StoreProviders` to capture exceptions using Sentry.

## 3. UI and Screens Update

- [x] 3.1 Update `DownloadsScreen` to capture exceptions in file processing.
- [x] 3.2 Update `PdfViewer`, `CustomVideoPlayer`, and `AttachmentViewer` to capture exceptions.
- [x] 3.3 Update `LessonDetailOrchestrator` and `ChapterDetailPage` to capture exceptions.

## 4. Routing Observers

- [x] 4.1 Check and attach `SentryService.createNavigatorObserver()` to any course-specific routers if applicable.
