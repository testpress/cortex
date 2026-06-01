## Context

The cortex app drawer features an "Ask Mentor" item which navigates to private doubt discussion threads between students and human mentors. Currently, the list, details, comments, and form submission screens rely on stub data and local database stubs. This design integrates the actual backend Helpdesk API (v3 & v2.5 endpoints) to replace these stubs with active REST communication.

## Goals / Non-Goals

**Goals:**
*   Establish HTTP communication for fetching, creating, and replying to doubts, supporting both Human Mentor (`query_type: 1`) and Ask AI (`query_type: 2`) routing via the Helpdesk API.
*   Implement a routing options Bottom Sheet that opens on "Next" action, styling clean option cards with plain large icons (`LucideIcons.bot`, `LucideIcons.user`) in standard text colors without colored background container boxes.
*   Implement a Confirmed Success/Failure UX flow showing a modal loading spinner overlay during API request, navigating/toasting on success, and keeping user input while displaying error toast on failure.
*   Implement a recursive hierarchical topic selector for correct doubt routing to mentors.
*   Implement a pre-upload attachment pipeline that embeds uploaded file URLs as HTML image tags in the editor/reply bodies.
*   Support routing entry points with query parameters for course contents and exam questions.
*   Support locking inputs and showing resolution banners based on doubt states.

**Non-Goals:**
*   AI follow-up limits, or AI-specific badges in threads.
*   Client-side archive or delete actions (soft delete).

## Decisions

### 1. Hierarchical Topic Selection
*   **Choice**: A dynamic drill-down list view within a Bottom Sheet modal.
*   **Rationale**: The topics API (`/api/v2.5/helpdesk/topics/`) returns a tree-like hierarchy (`parent_id`, `has_children`). A bottom sheet allows students to recursively click down categories (e.g. Mathematics -> Calculus -> Integration) in a clean mobile UI. Only leaves (where `has_children: false`) will be selectable.
*   **Alternative**: Flat selector chips. Rejected because it would cause bad classification of tickets, making automatic assignee routing on the backend fail.

### 2. Pre-Upload Attachments Pipeline
*   **Choice**: Pre-upload images via `POST /api/v3/upload-image/` with `uploaded_for: "doubts"` immediately after selection, and embed returning URLs as `<img src="url" />` tags in the document/comment text body.
*   **Rationale**: The create and follow-up REST endpoints do not accept file multipart arrays; they parse description HTML tags to extract attachments.
*   **Alternative**: Batch upload during ticket submission. Rejected because uploading files sequentially during form submit causes long loading pauses and lacks visual feedback in the rich text editor.

### 3. Detail Lock States and Resolution Banners
*   **Choice**: Read-only status checks on doubt details.
*   *   If `status == "Closed"`, hide/disable the message entry field and display a locked thread message.
*   *   If `status == "Resolved"`, display a resolution banner. Any sent reply will automatically be handled by the backend to revert the state back to `"Active"`, without manual state manipulation from the app.
*   **Rationale**: Keeps the UI synchronized with backend validation rules and prevents unnecessary network exceptions (like 403 or 400).

### 4. Ask AI / Ask Mentor Selection and Confirmed Flow
*   **Choice**: A floating card Bottom Sheet (`_SubmitOptionsSheet`) styled to match `doubt_detail_screen.dart` featuring clean options with plain un-colored text-primary icons of larger size, followed by a blocking screen-level loading overlay during execution to implement Confirmed Success/Failure toasts.
*   **Rationale**: This fulfills the request for instant choice close, no loading indicator on the "Next" button itself, and strict state preservation/accurate error handling if submission fails.

## Risks / Trade-offs

*   **[Risk]**: Attachment upload fails or takes too long.
    *   *Mitigation*: Show an inline spinner/progress indicator in the composition screen toolbar and disable the "Post" button until the upload completes or is cancelled.
*   **[Risk]**: Dynamic topic fetching causing sluggish selector loading.
    *   *Mitigation*: Cache loaded topics in a Riverpod family provider (`doubtSubtopicsProvider(parentId)`) so going back and forth between parent/child categories does not trigger duplicate HTTP requests.
