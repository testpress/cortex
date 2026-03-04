# Proposal: lms-test-detail

## Subject
Implement LMS Test Detail Screen

## Status
draft

## Context
The goal is to implement a comprehensive test-taking interface for the LMS app, following the design reference. This includes question navigation, an interactive question palette, instant feedback (if configured), and a summary result screen.

## What Changes
- Create `TestDetailScreen` in `packages/courses/lib/screens/`.
- Implement a real-time countdown timer in the header.
- Implement question-by-question navigation using a custom UI (avoiding standard Material widgets).
- Add an interactive "Question Palette" (sidebar on desktop, bottom drawer on mobile).
- Implement a "Check Answer" flow with instant feedback and explanations.
- Build a "Test Completed" result view with scoring and "Retake" capability.
- Ensure the UI matches the premium design tokens and aesthetics of the reference design.

## Capabilities

### New Capabilities
- `lms-test-detail`: Interactive test-taking experience with navigation, palette, feedback, and scoring.

### Modified Capabilities
- None.

## Impact
- **New Screen**: `TestDetailScreen` will be added to `packages/courses`.
- **Navigation**: New routes may need to be registered in the app shell.
- **Components**: Potential new internal components for the question palette and attempt indicators.
