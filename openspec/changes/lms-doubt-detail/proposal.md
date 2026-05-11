# Proposal: lms-doubt-detail

## Why

Students need to view the full content of their doubts and the subsequent replies from mentors to engage in effective learning. Currently, there is no way to view the thread or participate in a follow-up conversation after a doubt is posted.

## What Changes

- Implement `DoubtDetailScreen` (Discussion/Mentoring Details Page).
- The system SHALL display the original doubt title, metadata (category, time), and full body question (rich-text) at the top.
- The system SHALL list all mentor replies (comments) in chronological order with "Mentor" badges.
- The system SHALL support viewing attachments (Images/PDFs) linked to the doubt or replies.
- The system SHALL provide a persistent reply input field at the bottom for follow-up questions.
- The system SHALL handle loading and error states for the doubt thread.
- Navigation from `DoubtsListScreen` will be updated to link to the detail screen.

## Capabilities

### New Capabilities
- `doubt-thread-detail`: A detailed view displaying the primary doubt content, attachments, and a scrollable list of replies.
- `doubt-reply-interaction`: UI and logic for students to draft and submit follow-up replies to an existing doubt thread.

### Modified Capabilities
- None

## Impact

- **Packages**: `packages/discussions` hosts the new screen and thread providers.
- **Data**: `DoubtRepository` and `DataSource` will be utilized to fetch replies.
- **Navigation**: App router and `DoubtsListScreen` will be updated to support the new route.
