## Why

Users currently lack visibility into their historical exam performances in the Flutter Cortex monorepo. Specifically, there is no way for users to:
1. View a post-submission score summary, rank, speed, or accuracy report.
2. Review individual question-by-question correctness, correct answers, or detailed step-by-step explanations.
3. Understand subject/topic performance breakdowns to identify weak areas.

Integrating a premium, highly aesthetic Exam Analytics and Review answers module will close the feedback loop for learners and ensure complete parity with our native mobile SDKs.

## What Changes

- **DTO and Data Source Modifications**:
  - Extend `AttemptDto` or related models to include metrics such as `reviewUrl`, `accuracy`, `percentile`, `percentage`, `rank`, `maxRank`, and `rankEnabled`.
  - Create standard data structures/DTOs for `ReviewItemDto`, `ReviewQuestionDto`, and `ReviewAnswerDto`.
  - Create `SubjectAnalyticsDto` to capture subject performance stats.
  - Implement corresponding parsing in HTTP and Mock data sources.
- **Exam Repository Modifications**:
  - Add API fetchers to `ExamRepository` for `getReviewItems(String reviewUrl)` and `getSubjectAnalytics(String analyticsUrl)`.
- **UI & Screens Integration**:
  - Integrate real data fetching into the already scaffolded `ReviewAnalyticsScreen` and `ReviewAnswerDetailScreen` widgets, replacing static mock generation with seamless API data binding.
  - Correctly hook up "Review Answers" and "Analytics" buttons to load actual attempt results and map them dynamically.

## Capabilities

### New Capabilities
- `exam-review-analytics`: Integrates Attempt performance cards, Subject-wise analytics breakdowns, and comprehensive Interactive Question review flows using direct backend SDK endpoints.

### Modified Capabilities
- `lms-review-analytics`: Update the existing review analytics specifications to fetch and render real statistics and subject breakdown data from the server.
- `lms-exam-review`: Update the existing exam review specifications to fetch actual paginated review questions, answers, and explanations from the backend.

## Impact

- **Affected Code**:
  - `packages/core/lib/data/models/attempt_dto.dart` (modified)
  - `packages/core/lib/data/sources/data_source.dart` (modified)
  - `packages/core/lib/data/sources/http_data_source.dart` (modified)
  - `packages/core/lib/data/sources/mock_data_source.dart` (modified)
  - `packages/exams/lib/repositories/exam_repository.dart` (modified)
  - `packages/exams/lib/screens/review_analytics/review_analytics_screen.dart` (modified)
  - `packages/exams/lib/screens/review_answer/review_answer_detail_screen.dart` (modified)
- **New Files**:
  - `packages/core/lib/data/models/review_models.dart` (New DTOs for `ReviewItemDto`, `ReviewQuestionDto`, `ReviewAnswerDto`, `SubjectAnalyticsDto`)
- **APIs**:
  - `GET /api/v2.2.1/attempts/<id>/review/`
  - `GET /api/v2.4/attempts/<id>/review/subjects/`
