# Tasks: lms-test-detail

## 1. Scaffolding & Data Model
- [x] 1.1 Create `test_detail_screen.dart` in `packages/courses/lib/screens/`.
- [x] 1.2 Define internal models for `TestQuestion`, `Option`, and `Attempt`.
- [x] 1.3 Populate mock test data with various question types.

## 2. Shell & Header (Custom UI)
- [x] 2.1 Build a bespoke Header widget (no standard AppBar) with "Exit", Clock icon, Timer text, and Question info.
- [x] 2.2 Implement the Timer logic (`Timer.periodic`) and formatting (MM:SS).
- [x] 2.3 Add the custom progress bar below the header.

## 3. Question Area & Navigation
- [x] 3.1 Implement a `PageView` based question area using custom layouts (no default Material Scaffolding logic).
- [x] 3.2 Build the `OptionCard` with custom inkwell/hover effects and design-token colors.
- [x] 3.3 Logic: Handle selection, persistence, and sequential navigation flow.

## 4. Question Palette
- [x] 4.1 Implement desktop sidebar and mobile bottom drawer (custom styled).
- [x] 4.2 Wire up jump-to-question logic and status indicators.

## 5. Result View & Polish
- [x] 5.1 Implement `SubmitConfirmationDialog` to summarize progress before finishing.
- [x] 5.2 Build the "Test Submitted!" success overlay with Review/Analytics actions.
- [x] 5.3 Ensure the test screen remains visible (dimmed) behind all active overlays.
- [x] 5.4 Final polish: Ensure zero "Material-ish" defaults remain; every margin, corner radius, and color must match the reference.
