## 1. Repository Sentry Integration

- [x] 1.1 Update `OnlineExamRepository` constructor to accept `SentryService` and update `catch`/`catchError` blocks to capture exceptions to Sentry.
- [x] 1.2 Update `OfflineExamRepository` constructor to accept `SentryService` and update `catch`/`catchError` blocks to capture exceptions to Sentry.
- [x] 1.3 Update `SubjectAnalyticsRepository` constructor to accept `SentryService` and update `catch`/`catchError` blocks to capture exceptions to Sentry.

## 2. Riverpod Provider Updates

- [x] 2.1 Update `examRepositoryProvider` to watch `sentryServiceProvider` and pass it to `OnlineExamRepository`.
- [x] 2.2 Update `offlineExamRepositoryFactoryProvider` to watch `sentryServiceProvider` and pass it to `OfflineExamRepository`.
- [x] 2.3 Update `subjectAnalyticsRepositoryProvider` to watch `sentryServiceProvider` and pass it to `SubjectAnalyticsRepository`.
- [x] 2.4 Update `GenerateCustomExam.generate` to capture errors to Sentry.
- [x] 2.5 Update `SubjectAnalyticsPagination.loadMore` to capture errors to Sentry.
- [x] 2.6 Update `ExamList` sync methods to capture errors to Sentry.

## 3. UI Screens & Controllers

- [x] 3.1 Update `OfflineExamActionButton` download method to capture download failures to Sentry.
- [x] 3.2 Update `ReviewAnalyticsController` to capture section mapping errors to Sentry.
- [x] 3.3 Update `ReviewAnswerDetailScreen` bookmark deletion and loading catch blocks to capture errors to Sentry.
- [x] 3.4 Update `test_detail_screen.dart` quiz answer checking catch block to capture errors to Sentry.
