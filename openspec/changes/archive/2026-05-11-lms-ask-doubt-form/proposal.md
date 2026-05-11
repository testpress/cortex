## Why
Enable students to compose and submit detailed academic doubts with rich-text context and file attachments. This provides a structured way to ask complex questions that require more than just plain text (e.g., math formulas, code snippets, or photos of handwritten notes).

## What Changes
1.  **UI (Ask Doubt Form)**: Implement `AskDoubtFormScreen` with a title field, category selection, and a rich-text editor.
2.  **Interaction Layer**: Implement multi-file selection UI for images and PDFs (max 5 files) with thumbnail previews and removal logic.
3.  **Local Persistence**: Implement `createDoubt` method in `DoubtRepository` to handle local persistence and immediate UI updates.

## Capabilities

### New Capabilities
- `doubts-compose-ui`: Requirements for the doubt composition interface, layout, and user interactions.

### Modified Capabilities
- `doubts-core`: Update repository requirements to support local creation and optimistic UI updates.

## Impact
- **Discussions Package**: Addition of the composition screen and UI-related providers.
- **Core Package**: Expansion of `DoubtRepository` to support local doubt creation.
- **Navigation**: Integration of the form into the existing doubts landing screen.
