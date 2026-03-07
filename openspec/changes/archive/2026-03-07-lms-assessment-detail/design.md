## Context

The Assessment Detail screen provides a guided practice experience. Unlike standard tests, it focuses on immediate feedback and the ability to "Try Again". The current implementation diverges visually from the React-based design reference and lacks specific navigation states required for the practice flow.

## Goals / Non-Goals

**Goals:**
- Implement a 3-state action bar (Default Navigation, Submission State, Post-Submission Navigation).
- Standardize the `OptionCard` component to handle assessment-specific feedback (correct/incorrect states).
- Redesign the `AssessmentPalette` to match React's square-tile aesthetic and vertical legend.
- Fix color discrepancies by mapping incorrect feedback to the Amber subject palette.

**Non-Goals:**
- Modifying general test logic or scoring algorithms.
- Changing the layout of the Curriculum or Chapter screens.

## Decisions

- **Color Mapping**: Use `design.subjectPalette.atIndex(6)` (Amber) for incorrect feedback. This provides a consistent "caution" look that works across themes, unlike a hard red which is reserved for critical failures.
- **Navigation Flow**:
  - **Initial**: Show "Previous" and "Next".
  - **Selection**: Hide "Previous/Next" and show a full-width "Check Answer" button to focus the user on their immediate choice.
  - **Result**: Show "Previous/Next" again and include a "Try Again" button for incorrect answers.
- **Palette Layout**: Use `GridView` with `shrinkWrap: true` and `MainAxisSize.min` in the parent column to ensure the bottom sheet fits the content exactly without forcing 70% screen height.

## Risks / Trade-offs

- **[Risk: Component Bloat]** → **[Mitigation]**: Refactored `OptionCard` to accept optional feedback params rather than creating a new `AssessmentOptionCard`.
- **[Trade-off: Layout Flexibility]** → Using `Flexible` instead of `Expanded` in the palette allow it to be more responsive to different question counts.
