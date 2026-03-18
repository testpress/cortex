## ADDED Requirements

### Requirement: AI Assistant Dashboard Layout
The `AIAssistantPage` SHALL display a scrollable dashboard containing a personalized greeting, quick action cards, performance-based recommendations, and a recent activity log.

#### Scenario: Visual Dashboard Appearance
- **WHEN** a paid active user navigates to the "AI Support" tab
- **THEN** the system displays a header with "Sparkles" icon, user name greeting, and a study time insight ("You studied X minutes yesterday"), with the greeting sized to feel prominent but not oversized relative to the quick action cards below.
- **AND** it MUST show a trust line explaining that AI assistance is powered by learning progress and exam performance.
- **AND** secondary copy and metadata labels MUST remain clearly legible on the dashboard background.

#### Scenario: Quick Action Section
- **WHEN** the dashboard loads
- **THEN** it MUST show a high-weight Hero card for "Ask a Doubt" (using the primary assistant accent `#2563EB`) as the focal entry point.
- **AND** it MUST show a secondary action card for "Practice Exam" (purple themed) using a low-elevation, softly shadowed surface treatment.

#### Scenario: Personalized Recommendations
- **WHEN** the user has performance data available
- **THEN** the "Recommended For You" section displays a "Improve Weak Topics Today" card featuring a specific subject, topic name, and a progress bar representing accuracy, with a visually toned-down styling (e.g. no thick borders or large CTA buttons).
- **AND** its progress highlight MUST use the semantic recommendation accent token, whose current value is `#FE9A00`.
- **AND** the "More Topics to Practice" progress bars and accuracy labels MUST use the same semantic recommendation accent token.
- **AND** the "More Topics to Practice" section MUST expose a trailing "View All" affordance and row-level chevrons for each secondary weak-topic card.

#### Scenario: Recent Activity List
- **WHEN** the user has previous AI interactions
- **THEN** the "Recent Help" section displays a list of activities with type-specific icons and status badges (Answered, Processing, Revisit).
- **AND** it MUST expose a trailing "View All" affordance and show time metadata for each activity row.

### Requirement: Navigation Tab Adaptation
The navigation shell SHALL dynamically update the "Explore" tab to "AI Support" for users with an active paid subscription status.

#### Scenario: Adaptive Tab Label
- **WHEN** a user is identified as "Paid Active"
- **THEN** the third navigation tab displays the label "AI Support" and routes to the `AIAssistantPage`.
