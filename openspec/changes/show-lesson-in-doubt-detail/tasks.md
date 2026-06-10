## 1. Data Layer Integration

- [x] 1.1 Identify or create a Riverpod provider to fetch the lesson details (specifically the lesson title) using the `lessonId`. (Found: `lessonDetailProvider`)

## 2. UI Implementation

- [x] 2.1 Update `_DoubtHeaderCard` in `packages/discussions/lib/screens/doubt_detail_screen.dart` to check if `doubt.lessonId` is present.
- [x] 2.2 If `lessonId` is present, `ref.watch` the lesson provider and display the lesson title (e.g., using a small badge or text element) alongside or below the topic badge.
- [x] 2.3 Ensure loading and error states for the lesson fetch are handled gracefully without breaking the rest of the doubt header.
