## 1. UI Infrastructure

- [x] 1.1 Create `OfflineExamsListScreen` widget skeleton
- [x] 1.2 Register route `/exams/offline` to point to `OfflineExamsListScreen` in router configuration
- [x] 1.3 Add any necessary translation strings (e.g. "No downloaded exam available") to `.arb` files and regenerate l10n

## 2. State Management

- [x] 2.1 Create Riverpod provider to fetch all downloaded offline exams from local storage
- [x] 2.2 Create method in local data source/repository to delete a downloaded exam (if not already present)

## 3. UI Implementation

- [x] 3.1 Implement empty state for when no offline exams are present
- [x] 3.2 Implement list view displaying downloaded exams
- [x] 3.3 Create list item UI with exam details, "Delete", and "Attend" buttons
- [x] 3.4 Wire "Attend" button to navigate to exam detail page
- [x] 3.5 Wire "Delete" button to remove the exam via the repository and update state
