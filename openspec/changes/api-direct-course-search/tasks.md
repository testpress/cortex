## 1. API & Data Layer

- [x] 1.1 Update `DataSource` interface to support `search` in `getCourses`.
- [x] 1.2 Implement `search` in `HttpDataSource`.
- [x] 1.3 Add manual filtering to `MockDataSource` to support search for development.

## 2. Repository Layer

- [x] 2.1 Add `searchCourses` method to `CourseRepository` (API-direct, non-persistent).
- [x] 2.2 Re-evaluate `fetchAndPersistCourses` to ensure it only handles regular browse mode.

## 3. State Management (Riverpod)

- [x] 3.1 Update `CourseList` provider to hold `_searchQuery` and `_searchResults` (for search mode).
- [x] 3.2 Implement mode-switching logic in `build()` (DB stream vs Search results).
- [x] 3.3 Add `search(String query)` method to `CourseList`.
- [x] 3.4 Update `loadMore` and `_performSync` to choose correctly between persistent and non-persistent fetch.

## 4. UI Layer

- [x] 4.1 Update `StudyScreen` with search controller and debounce logic.
- [x] 4.2 Connect search field to `CourseList.search()`.
- [x] 4.3 Ensure pagination footer works correctly for search results.

## 5. Verification

- [x] 5.1 Verify that search results are fetched directly from the API.
- [x] 5.2 Confirm that search results are NOT saved to the local database.
- [x] 5.3 Verify search pagination continues to fetch subsequent results from the API.
- [x] 5.4 Check that clearing search restores the regular DB-backed browse state.
