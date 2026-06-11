## 1. Network & API Layer

- [x] 1.1 Add `getForumThread(String slug)` to `DataSource` interface.
- [x] 1.2 Implement `getForumThread(String slug)` in `HttpDataSource` using `ApiEndpoints.forumThreadDetail`.
- [x] 1.3 Add `ApiEndpoints.forumThreadDetail(String slug)` definition.
- [x] 1.4 Implement mock response in `MockDataSource`.

## 2. Persistence & State Layer

- [x] 2.1 Add `fetchThread(String slug)` to `ForumRepository` to fetch and upsert to SQLite.
- [x] 2.2 Update `globalForumThreadDetailProvider` to fetch from network if local database lookup returns null.

## 3. UI & Routing

- [x] 3.1 Update `_getIconForType` and `_getThemeForType` in `bookmark_item.dart` for community post types.
- [x] 3.2 Update `_navigateToBookmark` in `bookmarks_screen.dart` to route `forumpost` to the forum detail screen.
