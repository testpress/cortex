## 1. Database and Data Models

- [x] 1.1 Update `DoubtsTable` in `doubts_table.dart` to add a `TextColumn` named `queryType` that is nullable.
- [x] 1.2 Update `DoubtDto` in `doubt_dto.dart` to add `final DoubtQueryType? queryType;` and map it in `fromJson` (reading `json['query_type']` and parsing "Mentor" or "AI").
- [x] 1.3 Update `_mapToDto` and `_mapToCompanion` in `DoubtRepository` to handle the `queryType` field (storing `dto.queryType?.name`).

## 2. Repository and Network

- [x] 2.1 Update `watchDoubts` in `DoubtRepository` to accept `{DoubtQueryType? queryType}` and add a `.where()` clause if it's provided.
- [x] 2.2 Update `syncDoubts` in `DoubtRepository` and the `DataSource` methods to accept `{DoubtQueryType? queryType}` and pass it as a `query_type` parameter to the API (`?query_type=ai` or `mentor`).

## 3. UI and State Management

- [x] 3.1 Create or update the provider for the Doubts List (e.g., `doubtsListProvider`) to track the currently selected `DoubtQueryType?` (null for ALL, `DoubtQueryType.ai`, or `DoubtQueryType.mentor`).
- [x] 3.2 Add a filter chips row (ALL, AI, MENTOR) at the top of the Doubts List UI, similar to the Forum pages.
- [x] 3.3 Ensure that changing the selected chip updates the state provider, triggering a new `watchDoubts` stream and a new `syncDoubts` fetch.
