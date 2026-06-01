## Why

Currently, the "Ask Mentor / Doubts" features in the app are implemented using mock/local-only data. Integrating this feature with the real helpdesk API (v3 & v2.5 endpoints) will enable students to submit academic doubts, navigate hierarchical topics, upload attachments, view responses, and follow up in real-time, providing a private 1-on-1 support experience.

## What Changes

*   **Doubt Creation & Query Routing**: Connect `POST /api/v3/helpdesk/` to submit new doubts, supporting context links via GoRouter query parameters (`chapter_content_id`, `question_id`). Add routing options for "Ask AI" (`query_type: 2`) and "Ask Mentor" (`query_type: 1`) using a unified `DoubtQueryType` enum.
*   **Routing Selection Sheet**: Present a custom floating bottom sheet when the user clicks "Next" on the doubt form, allowing them to route to AI or Mentor with distinct icons (`LucideIcons.bot` and `LucideIcons.user`), using standard layout, typography, and styling without colored background boxes.
*   **Confirmed Success/Failure UX Flow**: Show a screen-blocking loading overlay during doubt submission. Upon successful API response, display a localized success toast and navigate back. Upon API failure, keep the form open with input preserved, remove the loading overlay, and display a localized failure toast.
*   **Hierarchical Topic Selector**: Replace the flat categories with a drill-down nested topic picker utilizing `/api/v2.5/helpdesk/topics/` recursively.
*   **Image Uploads & Embedding**: Post attachments to `/api/v3/upload-image/` (with `uploaded_for: "doubts"`) and embed returned URLs as HTML `<img>` tags in description/comment bodies.
*   **Doubt Threads & Replies**:
    *   Retrieve doubts and comments via `GET /api/v3/helpdesk/` and `GET /api/v3/helpdesk/<pk>/`.
    *   Post replies to `/api/v3/helpdesk/<pk>/followup/`.
    *   If a doubt's status is `"Closed"`, disable the composer interface.
    *   If a doubt's status is `"Resolved"`, display a resolution banner. Replying will transition it back to `"Active"`.
    *   Add a "Mark as Resolved" action triggering the followup endpoint with `should_resolve: true`.
*   **Drift Local Cache**: Sync data from HTTP requests to local tables to maintain smooth offline support.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
*   `doubts-core`: Require real HTTP API endpoints communication for listing, details, and creating doubts instead of local-only mock data.
*   `doubts-ui`: Enable real search functionality querying `/api/v3/helpdesk/` with search params.
*   `doubts-compose-ui`: Update category chip picker to a hierarchical topics selector. Implement image upload and inline HTML embedding.
*   `doubt-thread-detail`: Render doubt descriptions and replies dynamically. Show resolved/closed banners, and add "Mark as Resolved" action.
*   `doubt-reply-interaction`: Handle composer lock states when closed. Attachments are uploaded and embedded as HTML image tags.

## Impact

*   `packages/core`: Add endpoints to `ApiEndpoints`, update DTOs, and implement API operations in `HttpDataSource`.
*   `packages/discussions`: Update `DoubtRepository` and providers to handle real requests and sync with the database.
*   `packages/discussions`: Update the screen widgets (`doubts_list_screen.dart`, `ask_doubt_form_screen.dart`, `doubt_detail_screen.dart`) to implement the new UI interactions (hierarchical selector, lock states, resolution banners, and attachment upload loaders).
