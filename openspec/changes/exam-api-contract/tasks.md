## 1. Core Model and Pubspec Updates

- [x] 1.1 Create `SectionDto` class in `packages/core/lib/data/models/section_dto.dart`
- [x] 1.2 Export `SectionDto` in `packages/core/lib/data/data.dart`
- [ ] 1.3 Update `webview_flutter` dependency in `packages/core/pubspec.yaml` (Deferred to PR 3)
- [x] 1.4 Update `ExamDto` parsing and fields in `packages/core/lib/data/models/exam_dto.dart`
- [x] 1.5 Update `AttemptDto` with sections list and parsing in `packages/core/lib/data/models/attempt_dto.dart`
- [x] 1.6 Align `AnswerDto` JSON fields and mapping in `packages/core/lib/data/models/answer_dto.dart`
- [x] 1.7 Refactor `QuestionDto` parsing and handling in `packages/core/lib/data/models/question_dto.dart`

## 2. API Endpoint and Utility Additions

- [x] 2.1 Add `examDetail` endpoint in `packages/core/lib/network/api_endpoints.dart`
- [x] 2.2 Add `performDynamicNetworkRequest` helper in `packages/core/lib/network/network_utils.dart`

## 3. DataSource Layer Updates

- [x] 3.1 Define new abstract methods on `DataSource` interface in `packages/core/lib/data/sources/data_source.dart`
- [x] 3.2 Implement methods in `HttpDataSource` in `packages/core/lib/data/sources/http_data_source.dart`
- [x] 3.3 Implement and mock responses in `MockDataSource` in `packages/core/lib/data/sources/mock_data_source.dart`
