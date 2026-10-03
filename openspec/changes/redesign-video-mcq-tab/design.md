# Design

## Context

The video MCQ quiz component in `packages/courses` (`video_mcq_tab.dart` and `mcq/video_mcq_stepper_card.dart`) previously rendered within a bordered card on an outer grey padding container. Tapping an option immediately treated it as answered, triggering immediate validation and displaying explanations without an explicit check step.

## Goals / Non-Goals

**Goals:**
- Provide a flat white background (`card`) layout for the quiz view, opening/initial card (`VideoMcqInitialCard`), and quiz generating/loading states, removing boxed grey padding.
- Retain the subtle grey container background (`surface`) specifically for the docked bottom action button strip.
- Display a concise header with `"Practice Test"` and a question count pill badge.
- Display a progress section with `"Question X of Y"`, `"N answered"`, and a linear progress bar.
- Implement staged option selection where tapping an option marks it selected and activates a **Check Answer** button.
- Reveal correctness and explanation only upon tapping **Check Answer**.
- Replace small chevron icon buttons with prominent side-by-side **Previous** and **Next** buttons.
- Provide a bottom sheet question palette (`"Hey! Review Your Answers"`) for direct question navigation.

**Non-Goals:**
- Modifying backend APIs or network models; answer evaluation remains client-side with cached quiz DTOs.
- Altering the bottom "Continue to Next Lesson" bar layout or position.

## Decisions

### 1. State Management for Check Answer Flow
- **Decision:** Introduce a `Set<int> _checkedQuestions` in `_VideoMcqTabState`.
  - `_selectedAnswers[index]`: stores the currently selected option string for question index `index`.
  - `_checkedQuestions.contains(index)`: boolean flag determining whether question index `index` has been evaluated via the **Check Answer** button.
- **Rationale:** Separates user selection from answer evaluation cleanly. Preserves selections across back-and-forth navigation while locking evaluated questions.

### 2. Header and Progress Component Architecture
- **Decision:** Structure the quiz stepper view into clean modular sections:
  - Header: `"Practice Test"` + `<N> Questions` pill badge in a single row.
  - Progress bar: Row with `Question X of Y` and `N answered` + `AppProgressBar`.
  - Stepper body: Question text (`16px`), radio option cards (`14px`), **Check Answer** button, hint toggle, explanation container, and bottom navigation buttons (`Previous` / `Next`).
  - Review: **View All Questions** trigger button opening `VideoMcqPaletteSheet`.

### 3. Option Item Styling and Radio Indicators
- **Decision:** Use radio-style option items.
  - Unchecked state (selected): Green/accent border with active radio circle indicator.
  - Checked state (correct): Success background tint with green border and check circle icon.
  - Checked state (incorrect selection): Error background tint with red border and x circle icon.

### 4. Question Review Palette Sheet
- **Decision:** Centered 46x46 square grid tiles with 8px radius, bold title `"Hey! Review Your Answers"`, circular legend indicators (Answered, Unanswered), and custom vertical drag absorption to isolate palette interaction from the parent page scroll view.

### 5. Unified Content Surface and Docked Action Bar
- **Decision:** Configure `_buildTabContent` (`video_lesson_viewer.dart`), `VideoMcqInitialCard`, and the quiz generating/loading spinner state to render over `design.colors.card` (flat white), while styling the docked bottom footer container with `design.colors.surface` (`#F1F5F9`).
- **Rationale:** Creates a clean, cohesive white canvas across opening, loading, and quiz-taking views while maintaining distinct visual grounding for bottom action buttons.

## Risks / Trade-offs

- **[Risk]** Learner navigates forward without clicking Check Answer.
  - **Mitigation:** Allow navigation freely; if they return to that question, their un-checked selection remains preserved and ready to check.
- **[Risk]** Screen overflow on smaller devices.
  - **Mitigation:** Use a single vertical scroll view (`SingleChildScrollView`) for the content area while keeping the bottom bar docked.
