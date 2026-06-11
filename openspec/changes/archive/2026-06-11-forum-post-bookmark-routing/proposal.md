## Why

Currently, when a user clicks on a bookmark for a forum post or discussion thread, the app fails to open the post and displays a "Not Found" error unless the user had recently visited the main Forum screen. This happens because the bookmark only saves the thread's slug, and the local database does not have the full thread data. Without a specific API endpoint to fetch a single missing thread, the app cannot retrieve the content on demand. Shantanu has recently deployed the `GET /api/v2.5/discussions/<slug>/` endpoint, allowing us to fix this gap.

## What Changes

- Add the new `GET /api/v2.5/discussions/<slug>/` endpoint to `HttpDataSource`.
- Add `fetchThread(String slug)` to `ForumRepository` to securely fetch and insert a single thread into the local SQLite database.
- Update `globalForumThreadDetailProvider` to fetch the thread from the network in the background if the local database returns null, providing a seamless loading experience.
- Route bookmarks of type `forumpost` directly to the `ForumPostDetailScreen`.
- Add distinct bookmark icons and shortcut palette colors for forum posts, notices, and questions in the bookmark list UI.

## Capabilities

### New Capabilities

- None

### Modified Capabilities

- `forum-thread-detail`: The provider must now support fetching a missing thread from the network via slug.
- `bookmarks`: The bookmarks screen must properly route discussion bookmarks to the forum detail screen and display custom icons for community post types.

## Impact

- **Code:** `HttpDataSource`, `ApiEndpoints`, `ForumRepository`, `forum_providers.dart`, `bookmarks_screen.dart`, `bookmark_item.dart`
- **APIs:** Integrates the newly available `GET /api/v2.5/discussions/<slug>/` endpoint.
- **Systems:** Improves deep linking and cross-module routing between the Bookmarks feed and the Discussions module.
