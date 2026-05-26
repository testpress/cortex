## Why
The Cortex app currently forces users to start a new exam attempt every time they enter an exam, ignoring any previous progress (e.g., from the web platform). This lacks feature parity with the legacy Android SDK, which properly resumes paused exams. Additionally, there is no confirmation dialog when exiting or pausing an active exam, leading to abrupt user experiences.

## What Changes
- Parse `paused_attempts_count` from the exam metadata API.
- If `paused_attempts_count > 0`, fetch the existing attempts and extract the active one.
- Update the exam prescreen CTA to "Resume Exam Online".
- Intercept back navigation and exit actions during an exam.
- Show a "Pause Exam" confirmation dialog to prevent accidental exits.
- Pause the exam locally by clearing state and popping the screen (letting the heartbeat naturally stop).
- Prevent custom exam option indicators (radio/checkboxes) from being stripped out by the HTML clean-up script in the WebView.
- Replicate the legacy Android SDK hotfix by replacing the `v2.3` API version with `v2.2.1` in the attempt questions URL, ensuring correct subject category names are populated while fully preserving the user's attempt progress (`selected_answers`).

## Capabilities

### New Capabilities

### Modified Capabilities
- `exam-attendance-flow`: The exam attendance capabilities are expanding to support resuming paused attempts, showing an exit/pause confirmation dialog during the test, ensuring correct visual rendering of option indicators inside the test WebView, and resolving correct subject name mappings for the subject tab bar.

## Impact
- **Affected Code**: `ExamDto`, `ExamRepository`, `ExamPrescreen`, `TestDetailScreen`, `TestHeader`, `AppHtml`, `HttpDataSource`.
- **APIs**: Relies on existing `/attempts/` and `/attempts/{id}/start/` endpoints, and translates `/api/v2.3/attempts/{id}/questions/` requests to `/api/v2.2.1/attempts/{id}/questions/`.
