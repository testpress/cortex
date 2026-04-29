# Proposal: lms-forum-thread

## Why

Currently, the forum module allows users to see a list of discussions but lacks a detailed view to read full questions and participate in conversations. A dedicated detail screen is essential for student engagement and collaborative learning.

## What Changes

This change introduces the `ForumPostDetailScreen` (Discussion Forum Details Page).
- Displays the original thread title and full body question at the top.
- Lists all replies (comments) in chronological order.
- Provides a persistent reply input field at the bottom of the screen.
- Integrates with mock data for both threads and comments.

## Capabilities

### New Capabilities
- `forum-thread-detail`: A detailed view displaying the primary thread content and a scrollable list of replies.
- `forum-reply-interaction`: UI and logic for students to draft and submit replies to an existing discussion thread.

### Modified Capabilities
- None

## Impact

- **Packages**: `packages/forum` hosts the screen, providers, and forum repository integration.
- **Data**: Thread detail/comments providers are implemented in `packages/forum/lib/providers/forum_providers.dart`.
- **Navigation**: `ForumPostsListScreen` will be updated to navigate to the new detail screen.
