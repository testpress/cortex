# ai-chat-history Specification

## Purpose
Displays a list of recent and archived chat sessions with formatted timestamps.
## Requirements
### Requirement: Chat Session History List
The system SHALL list previous chat sessions classified into chronological sections based on local device date boundaries: "Today", "Yesterday", "Previous 7 days", and past month/year groups in descending order. Empty sections SHALL be excluded from the view. Conversation items SHALL display the session title and actions without redundant relative date captions, as temporal grouping is communicated by the section headers.

#### Scenario: View chat history with sectioning
- **WHEN** the user opens the chat history drawer
- **THEN** the system renders past sessions grouped under localized headers ("Today", "Yesterday", "Previous 7 days", and month/year headers), sorted descending within each section, displaying clean single-line conversation titles with no divider lines or redundant timestamp subtitles.

#### Scenario: Active conversation highlighting
- **WHEN** a conversation with ID `activeChatId` is currently open in the chat screen
- **THEN** that conversation row in the drawer is highlighted with a rounded surface card (`design.colors.surfaceVariant`), while the "+ New chat" button is displayed in an unselected state.

#### Scenario: New chat active highlighting
- **WHEN** no conversation is open (`currentChatId == null`)
- **THEN** the "+ New chat" button at the top of the drawer is highlighted with the active card styling and black accent styling, while all conversation items in the list appear in their default unselected state.

### Requirement: Deterministic Temporal Bucketing
The system SHALL normalize conversation timestamps to device local time and deterministically bucket them into:
1. "Today": timestamp >= today's midnight.
2. "Yesterday": timestamp >= yesterday's midnight and < today's midnight.
3. "Previous 7 days": timestamp >= 7 calendar days before today's midnight and < yesterday's midnight.
4. "Month/Year": timestamp < 7 calendar days before today's midnight, grouped by unique (year, month) descending.
Conversations with null `updatedAt` SHALL be treated as the current moment and sorted deterministically at the top of "Today".

#### Scenario: Bucketing across midnight boundaries
- **WHEN** the history contains conversations from today, yesterday, 4 days ago, and 20 days ago
- **THEN** the view model builds sections for "Today", "Yesterday", "Previous 7 days", and the corresponding month/year, excluding any section that has 0 items.

#### Scenario: Calendar-based midnight calculation
- **WHEN** boundary calculations are performed across Daylight Saving Time transitions or month boundaries
- **THEN** boundaries are anchored to local calendar midnight (00:00:00.000) using calendar arithmetic rather than fixed duration offsets.

### Requirement: Lifecycle Boundary Recalculation
The system SHALL observe app lifecycle changes and recalculate history section boundaries when the app resumes (`AppLifecycleState.resumed`).

#### Scenario: App kept open past midnight
- **WHEN** the app transitions from background to `AppLifecycleState.resumed`
- **THEN** the drawer recalculates date boundaries to reflect the current calendar day without requiring a manual refresh.

