# AutoDispose & Sync Metadata Architecture Specification

This document details the implementation design to convert `CourseList`, `ExamList`, and `InfoList` to `autoDispose` providers, using root-scoped sync metadata to guard against redundant API calls.

---

## 1. Provider Lifecycle & Sync Metadata

All providers remain in the flat root scope. Their lifecycle is bound to widget unmounting (on logout) and the global authentication state.

| Provider | AutoDispose? | Sync Tracker | Reset on Logout? | Reason |
| :--- | :---: | :---: | :---: | :--- |
| `CourseList` | **Yes** | `courseSyncMetadataProvider` | Yes | Disposes on logout when tab screens are unmounted. |
| `ExamList` | **Yes** | `examSyncMetadataProvider` | Yes | Disposes on logout when tab screens are unmounted. |
| `InfoList` | **Yes** | `infoSyncMetadataProvider` | Yes | Disposes on logout when tab screens are unmounted. |

---

## 2. Sync Tracker Design

The sync trackers store the last sync timestamp and watch `authProvider`. When the user logs out, Riverpod automatically resets their state to `null`.

```dart
@riverpod
class CourseSyncMetadata extends _$CourseSyncMetadata {
  @override
  DateTime? build() {
    ref.watch(authProvider); // Reset automatically when auth state transitions
    return null;
  }

  void markSynced() => state = DateTime.now();
}
```

---

## 3. List Provider Implementation

### CourseList Notifier

```dart
@riverpod
class CourseList extends _$CourseList {
  PaginationState _paginationTracker = const PaginationState();
  Future<void>? _pendingSyncRequest;

  @override
  Stream<List<CourseDto>> build() async* {
    final search = ref.watch(courseSearchProvider);

    if (search.query.isEmpty) {
      final repo = await ref.watch(courseRepositoryProvider.future);
      yield* repo.watchStudyCourses().map(
            (rows) => rows.map((row) => repo.rowToCourseDto(row)).toList(),
          );
    } else {
      yield search.results;
    }
  }

  Future<void> initialize() async {
    final lastSync = ref.read(courseSyncMetadataProvider);
    if (lastSync != null && DateTime.now().difference(lastSync).inMinutes < 5) return;
    if (_pendingSyncRequest != null) return _pendingSyncRequest;

    ref.read(isSyncingInitialPage.notifier).state = true;

    final auth = await ref.read(authProvider.future);
    if (!auth) {
      ref.read(isSyncingInitialPage.notifier).state = false;
      return;
    }

    _pendingSyncRequest = _performSync(isReset: true);
    try {
      await _pendingSyncRequest;
      ref.read(courseSyncMetadataProvider.notifier).markSynced();
    } finally {
      _pendingSyncRequest = null;
    }
  }
}
```
