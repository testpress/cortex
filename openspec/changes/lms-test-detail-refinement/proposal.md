# Proposal: lms-test-detail-refinement

## Subject
Refine Test Submission Flow and UI Polish

## Status
done

## Context
After implementing the basic test detail screen, we need to improve the user experience for finalizing and submitting tests. The goal is to provide a safety confirmation step and a more dynamic, overlay-based success message, while also refining the visual density of the test UI.

## What Changes
- Implement a `SubmitConfirmationDialog` modal overlay to prevent accidental submissions.
- Redesign `TestResultView` as an overlay success message ("Test Submitted!") that keeps the test content visible in the background.
- Update terminology from "Assessment" to "Test" across all related widgets.
- Refine UI density by scaling down card padding, icon sizes, and button dimensions for a sleeker look.
- Update `OptionCard` and `TestQuestionCard` to use more compact sizing and refined typography.

## Capabilities

### New Capabilities
- `test-submission-confirmation`: A modal step to review test status (answered vs unanswered) before finalizing.
- `test-submission-overlay`: A non-blocking success overlay with actions for reviewing answers and analytics.

### Modified Capabilities
- `lms-test-detail`: Visual refinements and terminology updates.

## Impact
- **UI Architecture**: Shift from full-screen result pages to overlay-based transitions.
- **Design Tokens**: Increased use of overlay colors and refined spacing/scaling.
