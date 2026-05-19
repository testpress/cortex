## 1. DTO and Model Definitions

- [x] 1.1 Create `packages/core/lib/data/models/review_models.dart` defining `ReviewItemDto`, `ReviewQuestionDto`, `ReviewAnswerDto`, and `SubjectAnalyticsDto`
- [x] 1.2 Export new review models in `packages/core/lib/data/data.dart`
- [x] 1.3 Update `AttemptDto` (packages/core/lib/data/models/attempt_dto.dart) to parse extra statistics fields (accuracy, percentile, percentage, rank, maxRank, rankEnabled, and reviewUrl)

## 2. API Data Sources Integration

- [x] 2.1 Add `getReviewItems` and `getSubjectAnalytics` signatures to `DataSource`
- [x] 2.2 Implement backend parsing and network requests in `HttpDataSource`
- [x] 2.3 Implement baseline mock responses in `MockDataSource`

## 3. Exam Repository Integration

- [x] 3.1 Define solutions fetching and subject analytics methods in `ExamRepository`

## 4. Analytics Screen Real Data Binding

- [x] 4.1 Update `ReviewAnalyticsScreen` to load and display real attempt summary and subject analytics metrics instead of local mock generation
- [x] 4.2 Create `ReviewAnalyticsState` and `ReviewAnalyticsController` (Riverpod Notifier) to encapsulate DTO parsing, API integration, and competitive marking mathematics
- [x] 4.3 Refactor `ReviewAnalyticsScreen` into a declarative, stateless view that observes `ReviewAnalyticsController`

## 5. Solutions Review Screen Real Data Binding

- [x] 5.1 Transition `ReviewAnswerDetailScreen` and `ReviewStateLogic` to fetch and display paginated server solution items instead of active local session

## 6. Exam Multi-Section Page Controller Synchronization

- [x] 6.1 Add a listener to reset PageView and `_currentQuestionIndex` to 0 when section switches in `TestDetailScreen`

## 7. Multi-Section Header and Answered Counts Alignment

- [x] 7.1 Parse `questionsCount` in `SectionDto` and map it through repository state updates
- [x] 7.2 Align top progress section to show overall answered count out of total questions from all sections
- [x] 7.3 Align bottom button to show section-wise answered count and section-wise total questions count
- [x] 7.4 Synchronize pre-selected answers (`selected_options`) from the server in `QuestionDto` and populate them in `ExamRepository` when questions load to prevent answered count mismatch on resume/section switches


## 8. Review Analytics Controller Code Optimization

- [x] 8.1 Map `markPerQuestion` and `negativeMarks` fields inside `AttemptDto` and parse them dynamically from the attempt response payload to eliminate hardcoding/magic numbers
- [x] 8.2 Derive overall exam totalTime and timeTaken dynamically from section durations and remaining times
- [x] 8.3 Set subject-wise timeSpent and totalTime placeholders to Duration.zero since they are not tracked by the API
- [x] 8.4 Map the backend review `result` field to `AnswerDto` and evaluate it inside `ReviewStateLogic` to correctly distinguish between unvisited questions (which must be marked as unanswered) and actual incorrect answers

