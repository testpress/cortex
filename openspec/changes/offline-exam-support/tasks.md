## 1. Local Database & Models

- [x] 1.1 Set up Drift database tables (`OfflineCourseAttemptTable`, `OfflineAttemptSectionTable`, etc.)
- [x] 1.2 Implement DTOs for data parsing and Repositories to handle offline exam storage logic
- [x] 1.3 Write unit tests for local storage CRUD operations
- [x] 1.4 Rename `OfflineCourseAttemptsTable` to `OfflineExamDownloadsTable` and update schema.
- [x] 1.5 Rename `OfflineAttemptItemsTable` to `OfflineExamAnswersTable`.
- [x] 1.6 Delete `OfflineAttemptSectionsTable` (dead schema).
- [x] 1.7 Remove domain logic (`createLocalAttempt`, `getLocalQuestions`, `endLocalExam`) from `app_database.dart`.

## 2. HTML Asset Caching & Serving

- [x] 2.1 Implement HTML parser to intercept and download `<img>` assets during exam caching
- [x] 2.2 Modify Exam WebView to intercept `<img>` tags or preprocess HTML to use local cached files instead of network requests
- [x] 2.3 Restore MathJax initialization script in `app_html.dart` — bundle MathJax as a Flutter asset (not CDN) so it works offline.
- [x] 2.4 Fix `FileDownloader` to use a plain unauthenticated Dio for public CDN downloads (`requireAuth: false`) — prevents JWT token leaking to CloudFront.
- [x] 2.5 Fix offline image rendering — migrated `TestQuestionCard` and `OptionCard` to `AppHtmlV2` (native Flutter renderer). Uses `Image.file()` for `file://` URIs via `buildImageWidget` override — no CORS, no CDN dependency.

## 3. Background Sync & Network Logic

- [x] 3.1 Implement background sync worker using `workmanager`
- [x] 3.2 Add `connectivity_plus` listener for aggressive foreground syncing
- [x] 3.3 Implement `endDate` + grace period validation in the local sync queue
- [x] 3.4 Build specific backend payload builder for pushing offline answers and files
- [x] 3.5 Extract `buildOfflineDio()` factory in `offline_dio_factory.dart`.
- [x] 3.6 Update `offline_exam_sync_worker.dart` to use `buildOfflineDio` and avoid recreating `AppDatabase`.
- [x] 3.7 Update `SyncManager` to only schedule background sync on foreground sync failure.

## 4. Exam Engine & UI Updates

- [x] 4.1 Update `ExamPrescreen` UI to include the vertically stacked `[ Download Exam ]` button
- [x] 4.2 Modify state machine to seamlessly transition from `Download Exam` to `Start offline exam`
- [x] 4.3 Add prominent UI banners for "Pending Sync" and "Deadline Passed"
- [x] 4.4 Hook up the UI actions to the local DB layer (Force `ExamMode.regular` only for offline exams)
- [x] 4.5 Delete `offline_mode_providers.dart`.
- [x] 4.6 Pass `isOffline` through navigation params in `exam_prescreen.dart`, `exams_routes.dart`, and `test_detail_screen.dart`.
- [x] 4.7 Fix `ExamAttemptState` to allow nullable `AttemptDto`.
- [x] 4.8 Replace hardcoded color literals in `offline_exam_action_button.dart` with design tokens.
- [x] 4.9 Remove unsafe `Future.microtask` state mutation in `test_detail_screen.dart`'s `dispose()`.

## 5. Unified Exam Engine Architecture

- [x] 5.1 Keep the interface named `ExamRepository` to prevent UI disruption
- [x] 5.2 Rename existing `OnlineExamRepository` (which was acting as the base repo) to `OnlineExamRepository` (Wait, it will just be `OnlineExamRepository`)
- [x] 5.3 Implement `OfflineExamRepository` as the dedicated offline state manager and repository
- [x] 5.4 Merge raw Drift queries directly into `AppDatabase` and delete the intermediate DAO wrapper.
- [x] 5.5 Move `downloadExam` logic natively into `OfflineExamRepository` so the repository orchestrates both fetching and saving locally.
- [x] 5.6 Fix API call in `downloadExam` to use `examData.id` instead of content ID.
- [x] 5.7 Remove the insertion of the dummy `AttemptDto(id: -1)` and `remote_attempt` JSON nesting from `downloadExam`.
- [x] 5.8 Make `offlineExamRepositoryFactory` an async provider to fix `.requireValue` startup crash.
- [x] 5.9 Guard debug prints in sync code with `kDebugMode`.
