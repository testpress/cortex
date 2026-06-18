## 1. Screen Scaffold

- [x] 1.1 Create `custom_exam_options_screen.dart` in `packages/exams/lib/screens/`
- [x] 1.2 Set up screen as a `ConsumerStatefulWidget` using core primitives (`AppScroll`, `AppHeader`)
- [x] 1.3 Register the route in the exams package router
- [x] 1.4 Add the entry point on the Exams screen that navigates to the Custom Exam Options screen

## 2. Configuration Options UI

- [x] 2.1 Add practice scope selector (Full course practice / Select course)
- [x] 2.2 Add course selection floating bottom sheet linked to global `courseListProvider`
- [x] 2.3 Implement sticky search bar within the bottom sheet for course filtering
- [x] 2.4 Add question source display with selection
- [x] 2.5 Add number of questions field
- [x] 2.6 Add difficulty level selector
- [x] 2.7 Add attempt mode selector (Test / Quiz)

## 3. Course Selection Flow

- [x] 3.1 Show bottom sheet when "Select course" scope is selected
- [x] 3.2 Fetch all enrolled courses globally rather than just exams-tab courses
- [x] 3.3 Ensure bottom sheet is styled as a floating card with matching design tokens

## 4. Primary Action

- [x] 4.1 Add primary action button at the bottom of the screen
- [x] 4.2 Disable primary action when required options are not selected
- [x] 4.3 On activation, pass configuration and navigate to the exam session

## 5. Accessibility & Design Compliance

- [x] 5.1 Wrap all interactive elements with `AppSemantics`
- [x] 5.2 Ensure all design tokens are accessed via `Design.of(context)` — no static imports
- [x] 5.3 Verify 48dp minimum touch targets on all interactive elements
