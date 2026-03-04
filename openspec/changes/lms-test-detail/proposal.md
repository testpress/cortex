# Proposal: lms-test-detail

## Subject
Implement LMS Test Detail Screen

## Status
draft

## Context
The goal is to implement a formal test-taking interface for the LMS app. This includes question navigation, an interactive question palette for status tracking, and a comprehensive summary result screen upon completion.

## What Changes
- Create `TestDetailScreen` in `packages/courses/lib/screens/`.
- Implement a real-time countdown timer in the header with auto-submit logic.
- Implement sequential question navigation using a custom localized UI.
- Add an interactive "Question Palette" overlay for rapid navigation and status overview.
- Build a "Test Completed" result view with scoring and "Retake" capability.
- Ensure zero hardcoded colors using the design system tokens.
- Ensure the UI matches the premium design tokens and aesthetics of the reference design.

## Capabilities

### New Capabilities
- `lms-test-detail`: A formal test-taking experience with navigation, status tracking palette, and final scoring.

### Modified Capabilities
- None.

## Impact
- **New Screen**: `TestDetailScreen` will be added to `packages/courses`.
- **Navigation**: New routes may need to be registered in the app shell.
- **Components**: Potential new internal components for the question palette and attempt indicators.
