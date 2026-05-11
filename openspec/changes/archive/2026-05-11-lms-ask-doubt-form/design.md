## Context
The "Ask a Doubt" form is the entry point for students to get personalized help. It needs to handle rich text (Quill Delta) and multiple file attachments while maintaining the premium Cortex design aesthetic.

## Goals / Non-Goals

**Goals:**
- Implement local persistence for new doubts in `DoubtRepository`.

**Non-Goals:**
- Implementation of the remote API sync logic (staying with mock responses).
- Rich-text editor support for inline images.

## Decisions

### 1. Rich Text Engine: flutter_quill
- **Rationale**: Industry standard for Flutter, supports Quill Delta (used by the backend).

### 2. Local Persistence: DoubtsTable Insertion
- **Rationale**: Inserting new doubts into the local Drift DB ensures they appear in the `DoubtsListScreen` immediately via the existing stream.
- **Mocking**: Use a mock delay and success response to simulate the API call.

### 2. Attachment System: Thumbnail Strip
- **Rationale**: A horizontal scrollable strip below the editor provides clear visibility without occupying too much vertical space.
- **Interaction**: Use `AppCard` with an overlay close button for removal.

### 3. Category Selection: ChoiceChips
- **Rationale**: Using the design system's `AppSubjectChip` (or similar) ensures visual consistency and easy one-tap selection.

## Risks / Trade-offs

- [Risk] → Quill editor focus issues inside a scrollable column.
- [Mitigation] → Use `SingleChildScrollView` with `ClampingScrollPhysics` and ensure the editor has its own internal scroll or fixed height.

- [Risk] → Memory issues with multiple high-res image previews.
- [Mitigation] → Use `ResizeImage` or `FileImage` with cache dimensions for thumbnails.
