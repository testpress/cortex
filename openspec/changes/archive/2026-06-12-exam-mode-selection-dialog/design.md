# Design: exam-mode-selection-dialog

## Context

The exam entry flow already supports launching exams from the prescreen and resuming active attempts. This change adds a pre-start choice when the exam metadata indicates quiz mode is available, while preserving the existing regular start behavior for all other exams.

## Goals

- Present a lightweight mode-selection dialog only for quiz-capable exams.
- Keep the visual treatment aligned with the existing Cortex exam UI.
- Preserve the selected mode across the attempt lifecycle, including pause and resume.
- Avoid changing the current exam flow when quiz mode is not available.
- Reuse the existing exam attempt lifecycle and endpoints for both regular and quiz mode.
- Preserve the quiz interaction pattern where selection is separate from checking, and checking is separate from continuing.
- Match the quiz completion experience with a final result card that offers retake and return actions.

## Non-Goals

- Reworking the broader exam player or question renderer.
- Changing the overall exam navigation architecture.
- Introducing new server APIs or new response fields.

## UX Design

The prescreen remains the entry point. When a quiz-capable exam is started, the user is shown a centered modal dialog with two explicit actions:

- Regular Mode
- Quiz Mode

The dialog should be visually consistent with the existing app surfaces, using the current typography, button styles, spacing, and surface elevation patterns. It should not introduce a separate branded experience or a new navigation layer.

Behavior rules:

- If quiz mode is disabled, the exam starts immediately with no dialog.
- If the dialog is canceled or dismissed, no attempt is created or mutated.
- The chosen mode persists for the attempt session so a resumed session does not prompt again.
- Quiz mode is a client-side launch choice. The backend contract stays the same as the regular exam flow, but requires passing `attempt_type=1` when creating the attempt to indicate the mode to the backend.
- Quiz questions should not reveal correctness on option tap; they should wait for an explicit `Check` action before showing the review state.
- Quiz review should not include a retry action; incorrect questions continue through the quiz flow via `Continue`.

## Flow

1. User taps the exam CTA on the prescreen.
2. The app checks the exam metadata for quiz eligibility.
3. If quiz mode is disabled, the standard attempt flow starts immediately.
4. If quiz mode is enabled, the mode-selection dialog is shown.
5. The selected mode is passed into the existing exam start orchestration.
6. The attempt continues in the selected mode until completion, pause, or resume.
7. The same question, answer, heartbeat, and end-session APIs continue to power the flow.
8. In quiz mode, each question goes through a select -> check -> review -> continue loop.
9. The attempt ends with a completion card that summarizes the result and offers retake/back navigation.

## State Considerations

The selected mode should be treated as part of the active attempt context rather than a one-off UI state. That keeps resumed attempts consistent and prevents the selection dialog from reappearing when the same attempt is restored.

## Risks

- If mode selection is stored only in local UI state, resumed attempts could lose the chosen mode.
- If the dialog is triggered too early, it could appear for exams that should start directly in regular mode.
- If the dialog styling drifts from the current UI system, it will feel inconsistent with the rest of Cortex.

## Open Questions

- None at this stage. The spec intentionally keeps the behavior tied to metadata-driven eligibility and the existing exam start flow.
