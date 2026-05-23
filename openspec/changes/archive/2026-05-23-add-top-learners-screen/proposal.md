## Why

Users currently see a summary of top learners on the dashboard but lack a way to view the complete list or see their direct competition. Adding a dedicated Top Learners page solves this by providing a full leaderboard view and a dedicated "Competitors" tab (showing users immediately above and below their rank) when users click the "View All" button, significantly improving gamification and user engagement.

## What Changes

- Add a new `TopLearnersScreen` to display the complete list of top learners and a personalized Competitors tab.
- Create a dedicated `leaderboard` folder structure inside `packages/courses/lib/screens/` and `packages/courses/lib/widgets/`.
- Enhance the data layer (`DataSource`, `LeaderboardRepository`) to support fetching competitor threats and targets.
- Wire up the "View All" button on the dashboard's `TopLearnersSection` to navigate to the new screen.

## Capabilities

### New Capabilities
- `ui-top-learners`: Defines the UI requirements and behaviors for the full-page Top Learners leaderboard screen with rank list and competitors tabs.

### Modified Capabilities
- `data-leaderboard`: Expanded to fetch and assemble competitor targets and threats.

## Impact

- **`packages/courses`**: Will house the new screen, tabs, and specific widgets (`CompetitorsBody`, `CompetitorListItem`).
- **`packages/core`**: The data layer (`LeaderboardRepository`, `DataSource`, `ApiEndpoints`) will be updated to fetch and format competitor data.
- **`packages/testpress`**: The dashboard screen (`paid_active_home_screen.dart`) will be updated to handle the "View All" action and navigate to the new screen.
