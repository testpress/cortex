## Context

The current custom exam flow supports only a single subject configuration. To support multi-subject block configurations (sending an array of `questionnaires`), we need to revamp the UI and state management. We are taking a "Builder" screen approach to reduce friction and keep the user in a single context while building their exam.

## Goals / Non-Goals

**Goals:**
- Implement a unified "Builder" screen where users can select nested subjects and configure their difficulty/types without leaving the screen (e.g., using Bottom Sheets for selection).
- Support building an array of `questionnaire` blocks in the state.
- Provide a clear UI to view and remove added blocks before starting the exam.
- Handle API rate limit errors (HTTP 403) gracefully and show the error detail message.

**Non-Goals:**
- Changing the initial Course Selection screen.
- Redesigning the exam player itself.

## Decisions

- **UI Flow (The Builder Screen)**: We will replace the linear wizard screens (`custom_exam_config_screen.dart`, `custom_exam_options_screen.dart`) with a single `CustomExamBuilderScreen`. Interactions for selecting subjects and setting filters will happen via Bottom Sheets to keep the UI clean.
- **State Management**: We will introduce a new `CustomExamBuilderState` (using the app's standard state management, e.g., Riverpod/Notifier or Bloc) to hold the `List<QuestionnaireBlock>`. This is cleaner than trying to hack the existing single-item provider to support arrays.
- **Payload Generation**: The state will map directly to the required POST payload structure. Selecting "All" for a subject or leaving filters blank will correctly map to empty arrays `[]` in the API request.

## Risks / Trade-offs

- **Risk:** The single Builder screen could become visually cluttered if a user adds many subject blocks.
  - **Mitigation:** Display added blocks as compact, summarized cards.
- **Risk:** Legacy state providers might be tied to other features.
  - **Mitigation:** Creating a fresh state holder isolates our new logic, ensuring we don't break existing features during development.
