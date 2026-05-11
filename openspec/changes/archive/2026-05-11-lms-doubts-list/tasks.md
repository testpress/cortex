## 1. Data Layer Implementation
- [x] 1.1 Implement `DoubtDto` and `DoubtReplyDto` in `packages/core/lib/data/models/doubt_dto.dart`
- [x] 1.2 Define `DoubtsTable` and `DoubtRepliesTable` in `packages/core/lib/data/db/tables/doubts_table.dart`
- [x] 1.3 Register new tables in `AppDatabase` and run `build_runner` (Schema v17)
- [x] 1.4 Add `getDoubts` (List) and `getDoubtReplies` to `DataSource` interface and implement in Mock/Http

## 2. Domain Layer
- [x] 2.1 Create `DoubtRepository` in `packages/discussions/lib/repositories/doubt_repository.dart`
- [x] 2.2 Implement Riverpod providers for doubts list in `packages/discussions/lib/providers/doubt_providers.dart`

## 3. UI Implementation
- [x] 3.1 Create `DoubtsListScreen` using `core` primitives (`AppShell`, `AppHeader`, `AppCard`)
- [x] 3.2 Implement Search Bar as a UI-only placeholder for visual parity with other modules
- [x] 3.3 Implement "Unanswered" status badge for pending doubts using `AppBadge`
- [x] 3.4 Update Navigation Drawer and App Router to link to `/home/discussions/doubts`
