## Context
Currently, the Cortex app does not support resuming exam attempts that were paused or left incomplete on other platforms (like the web). The app forcefully creates a new attempt every time. Additionally, there are no safeguards (like a confirmation dialog) to prevent a user from accidentally exiting an active exam session. 

## Goals / Non-Goals

**Goals:**
- Provide feature parity with the legacy Android SDK by honoring the `paused_attempts_count` field from the backend.
- Automatically resume the first active attempt if one exists.
- Prevent accidental exits during exams with a confirmation dialog.
- Persist the paused state locally and safely pop the navigation stack.
- Ensure custom selection indicators (radio/checkboxes) in question cards are rendered correctly by preserving empty structural HTML tags in WebView.

**Non-Goals:**
- Support for multiple concurrent running attempts (the system implicitly assumes only one active attempt per exam).
- Refactoring the entire `ExamRepository` state management.

## Decisions
- **Attempt Fetching**: If `paused_attempts_count > 0`, we fetch the list of attempts via `_dataSource.getAttempts()` and find the one with `state == 'Running'`. This avoids introducing a new specific API call and reuses existing pagination/fetching logic.
- **Resumption Endpoint**: We will trigger the attempt's `startUrl` to inform the server that the session is active again.
- **Exit Interception**: We will intercept `PopScope` and the `onExit` callback in `TestHeader`. A new `PauseConfirmationDialog` will be presented.
- **Pause Action**: We will clear the `ExamAttemptState` and pop the screen. The backend considers it paused since heartbeat updates will cease.
- **HTML Option Indicator Preservation**: The clean-up logic in `AppHtml` (`removeEmptyNodes`) will check for `.indicator` elements or their descendants and bypass them, ensuring custom radio and checkbox indicators are not stripped from the DOM.
- **Subject Mapping / API URL Swap**: To resolve correct subject names (like `PHYSICS`, `CHEMISTRY`, `BIOLOGY`) for the tab bar while fully preserving user attempt progress state, the app will replicate the legacy Android SDK hotfix. When invoking the questions endpoint URL in `HttpDataSource`, any occurrence of `v2.3` will be replaced with `v2.2.1` before the GET request is made.

## Risks / Trade-offs
- [Risk] What if `paused_attempts_count` is 0 but an active attempt actually exists? → Mitigation: The backend is assumed to be the source of truth, aligning perfectly with the legacy Android SDK logic.
- [Risk] Intercepting the Android back button might clash with other navigation logic. → Mitigation: `PopScope` ensures we capture the event regardless of whether it was triggered via gestures or hardware buttons.
- [Risk] Swapping `v2.3` to `v2.2.1` could affect other question endpoints. → Mitigation: We target it specifically inside the HTTP data source's `getQuestions` method, which is dedicated solely to fetching attempt questions.
