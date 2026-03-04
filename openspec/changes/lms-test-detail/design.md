# Design: lms-test-detail

## Context
We are implementing the **Test Detail Screen**, which provides a formal examination environment for students. Unlike an assessment, it does **not** provide instant feedback or correct answers during the test. The design is premium, using custom components instead of standard Material widgets, and includes a sophisticated question palette for navigation.

## Goals / Non-Goals

**Goals:**
- Provide a formal test environment with **no instant feedback**.
- Implement a persistent **countdown timer** in the sticky header.
- Support MCQ and Multiple-select question types.
- Feature a **"Mark for Review"** button to flag questions for later revisit.
- Implement a responsive **Question Palette** with specific shape-based status indicators.
- **Zero Hardcoded Colors**: Use `DesignConfig` tokens exclusively for Dark Mode compatibility.

**Non-Goals:**
- Showing correct answers/explanations before final submission.
- Real-time backend sync (will use localized state for now).

## Decisions

### 1. Architectural Splitting (CLEAN CODE)
- To avoid massive file complexity, the `TestDetailScreen` is decomposed into:
  - `TestProgressSection`: Question count and progress bar.
  - `TestQuestionCard`: The question text and options area.
  - `TestNavigationActions`: Bottom controls (Previous/Next/Mark).
  - `TestPaletteTrigger`: The "View All Questions" overlay trigger.
  - `PaletteShapes`: Reusable custom clippers for the palette (Hexagon, Diamond, etc.).

### 2. Custom UI Theme
- **No Material AppBar/Scaffold**: Custom layouts using `Container` and `Stack` to match the localized brand identity.
- **Typography**: Strictly uses `AppText` wrappers for centralized management.

### 3. State Management
- Managed via `StatefulWidget` using local state for:
  - `_currentQuestionIndex`: Tracks progression.
  - `_answers`: A map of question IDs to `TestAttemptAnswer` models.
  - `_timeRemaining`: Countdown logic.
  - `_showPalette`: UI toggle for the navigation overlay.

### 4. Palette Status Mapping
- To provide a quick "at-a-glance" status for the student:
  - **Rectangle Border**: Question not yet answered.
  - **Solid Circle (Green)**: Answered.
  - **Solid Diamond (Orange)**: Marked for Review.
  - **Solid Hexagon (Green)**: Answered AND Marked for Review.

### 5. Mock Data Strategy
- All test content is decoupled from the UI and resides in `MockTestFactory` to simulate a clean API integration transition.

## Risks / Trade-offs
- **State Complexity**: Managing marking vs. answering across a large map requires careful `setState` scoping.
- **Timer Lifecycle**: Ensure the `periodic` timer is cancelled in `dispose` to prevent memory leaks during rapid navigation.
