# Proposal: lms-doubts-list

## Why
Implement a dedicated space for students to engage in private 1-on-1 communication with mentors for academic doubts. This complements the public forum by providing a safe, direct channel for personalized help.

## What Changes
1.  **Data Layer**: Implement normalized Drift tables for `doubts` and `doubt_replies` in `packages/core`.
2.  **Domain Layer**: Create `DoubtRepository` inside `packages/discussions`.
3.  **UI (Landing)**: Implement the `DoubtsListScreen` with a UI-only search bar (for visual parity) and "Unanswered" status badges.

## Capabilities

### New Capabilities
- `doubts-core`: The foundational data and repository layer for private doubt management.
- `doubts-ui`: The landing screen and search interface for the doubts hub.

## Impact
- **Discussions Package**: Addition of doubt-specific logic and UI.
- **Core Package**: Database schema expansion.
- **Navigation**: Integration of the doubts list into the app router.
