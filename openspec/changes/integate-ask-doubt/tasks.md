## 1. Data Layer Setup (DTOs and Endpoints)

- [x] 1.1 Add Helpdesk and Upload endpoints to `ApiEndpoints` in `packages/core`.
- [x] 1.2 Update DTO models (`DoubtDto`, `DoubtReplyDto`) and create `DoubtTopicDto` with JSON serialization inside `packages/core`.
- [x] 1.3 Update the `DataSource` interface with new helpdesk and upload methods.
- [x] 1.4 Implement the REST methods in `HttpDataSource`.
- [x] 1.5 Update the `MockDataSource` to support the updated methods and DTO mappings.

## 2. Repository and State Management

- [x] 2.1 Update `DoubtRepository` in `packages/discussions` to sync data from the REST API to the local Drift database.
- [x] 2.2 Add Riverpod family provider for dynamic subtopic loading (`doubtSubtopicsProvider`).
- [x] 2.3 Add Riverpod notifier for creating doubts (`createDoubtNotifierProvider`).
- [x] 2.4 Add Riverpod notifier for posting followup comments (`postDoubtReplyNotifierProvider`).

## 3. UI Component Enhancements

- [x] 3.1 Update GoRouter paths in `home_routes.dart` to extract `chapter_content_id` and `question_id` query parameters.
- [x] 3.2 Build the hierarchical tree topic picker Bottom Sheet modal in `AskDoubtFormScreen`.
- [x] 3.3 Implement attachment file pre-uploading and insert the resulting `<img />` tag into the Quill text editors.
- [x] 3.4 Update `DoubtDetailScreen` content rendering to use the HTML rich-text renderer instead of plain text.
- [x] 3.5 Implement lock states (Composer disabled on Closed) and the resolution banner on Resolved.
- [x] 3.6 Implement the "Mark Resolved" header action button in `DoubtDetailScreen`.
- [x] 3.7 Build Ask AI / Ask Mentor routing choice floating bottom sheet modal (`_SubmitOptionsSheet`) without background color boxes or colored icons.
- [x] 3.8 Implement Confirmed Success/Failure UX flow with screen-blocking loading overlay and localized success/error toasts.
