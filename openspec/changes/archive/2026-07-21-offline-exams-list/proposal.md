## Why

Users who have downloaded exams for offline use currently have no dedicated place to view and manage these downloaded exams. A dedicated offline exams list page is needed so that users can easily access their downloaded exams without an internet connection.

## What Changes

- Add a new "Offline Exams" list screen to display all locally downloaded exams.
- If there are no downloaded exams, display an empty state indicating "No downloaded exam available".
- If downloaded exams exist, display a list of exams.
- Each list item will include an option to delete the downloaded exam and an option to attend the exam.
- Tapping on an exam list item or the attend button will navigate to the exam detail page.

## Capabilities

### New Capabilities
- `offline-exams-list`: Viewing and managing downloaded offline exams (listing, deleting, and launching).

### Modified Capabilities

## Impact

- **UI/UX**: New empty state and list layout for offline exams.
- **Local Storage**: Fetching and deleting exams from local storage/database.
- **Routing**: Wiring the drawer item to the new screen and navigating from list items to the exam detail page.
