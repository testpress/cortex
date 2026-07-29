## Context

Several delete and remove actions within the app currently execute immediately when triggered. This lacks a fail-safe against accidental taps. We need to introduce a generic confirmation pattern to wrap these destructive actions.

## Goals / Non-Goals

**Goals:**
- Provide a consistent dialog-based confirmation for all destructive actions (e.g. deleting attachments, deleting videos, removing bookmarks, closing doubts).
- Ensure the user interface for the dialog aligns with the app's overall design system.

**Non-Goals:**
- Refactoring the actual deletion logic or back-end API endpoints.
- Introducing undo functionality (snackbars with "Undo"); we are strictly adding pre-action confirmation dialogs.

## Decisions

- **Dialog Component**: We will create a centralized helper function `showConfirmationDialog` in `packages/core/lib/widgets/app_confirmation_dialog.dart`. This custom component will leverage `showGeneralDialog` with a responsive layout and sizing to guarantee uniformity across all destructive actions.
- **Action Wrapping**: We will replace direct deletion calls and disparate custom dialogs by wrapping the `onPressed` handlers of the relevant buttons with the `showConfirmationDialog` helper.

## Risks / Trade-offs

- **Risk**: Missing some delete actions if they are obscurely named or hidden deep in widget trees.
  - *Mitigation*: Perform a comprehensive search for terms like "delete", "remove", "close doubt", and "clear" across the codebase.
