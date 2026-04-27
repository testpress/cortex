## Context

The Forum module currently lacks a way for users to create new discussion threads. While a rich text editor exists in the `ForumPostDetailScreen`, it is implemented as private sub-widgets. To support thread creation while maintaining consistency, we need to refactor the editor logic and build a new composition screen that aligns with the project's design tokens and the provided design reference.

## Goals / Non-Goals

**Goals:**
- Implement `ForumPostCreateScreen` as a full-page composition form.
- Extract and refactor the rich text editor (based on `flutter_quill`) and its custom toolbar into reusable components.
- Support image attachment UI with previews (up to 3 images).
- Implement field validation (title/description non-empty).

**Non-Goals:**
- Actual backend API integration or data persistence.
- Real file uploads (UI-only previews).
- Implementation of the "Category/Subject" selection logic (will use a placeholder or pre-filled course ID).

## Decisions

### 1. Refactor Editor Logic into Shared Widgets
We will extract `_QuillEditorService`, `_ForumToolbar`, and `_AttachmentPreview` from `ForumPostDetailScreen` into a new shared component file: `packages/courses/lib/widgets/forum/forum_composer.dart`.
- **Rationale**: Both thread creation and replies require identical rich text formatting and attachment behavior. Centralizing this logic ensures consistency and reduces maintenance overhead.
- **Alternatives Considered**: Duplicating the code in the new screen (rejected as it violates DRY principles and creates styling drift).

### 2. Form Architecture
The `ForumPostCreateScreen` will be a `StatefulWidget`.
- **Rationale**: Form validation and transient input state (title, quill controller, attachments) are best managed locally within the screen scope for simplicity.
- **Alternatives Considered**: Using a Riverpod Notifier for the form state. (Rejected as the state is highly transient and restricted to this single screen).

### 3. Submission Simulation
Clicking "Submit" will trigger a simulated loading period (e.g., 500ms) followed by a navigation pop.
- **Rationale**: Since backend integration is out of scope, this provides the expected UX feedback without requiring repository or network modifications.

### 4. Category Contract Alignment
Categories in create-post flow use payload-style objects (`id`, `name`) and the selected value is stored as `id`.
- **Rationale**: This avoids coupling state to presentation and aligns directly with future backend category responses.
- **Model Ownership**: The category model is defined as a shared forum DTO in `packages/core/lib/data/models`, while `mock_data.dart` only provides mock instances.
- **Access Pattern**: The create screen reads categories via provider wiring (`DataSource -> ForumRepository -> forumCategoriesProvider`) and does not import mock constants directly.
- **Alternatives Considered**: Static localization-only category labels (rejected because category values are expected from backend).

## Risks / Trade-offs

- **[Risk] Editor State Complexity** → The `QuillController` and `FocusNode` management can be tricky when extracted.
  - **Mitigation**: Pass the controller and focus node as parameters to the shared widget to allow the host screen/widget to control lifecycle and submission.
- **[Risk] UI-Mock Divergence** → Building the UI without the backend might lead to mismatches in field requirements later.
  - **Mitigation**: Use fields that align with the `ForumThreadDto` and the React prototype to ensure future compatibility.
