## Why

Provide a centralized dashboard for AI-powered learning features, enabling paid students to quickly resume study sessions, resolve doubts, and practice weak topics based on personalized performance data. 

## What Changes

- Implementation of the `AIAssistantPage` dashboard layout.
- Introduction of personalized greeting headers with study insights.
- Inclusion of the greeting trust line that explains AI personalization from learning progress and exam performance.
- Refinement of greeting typography so the user name feels less dominant and aligns with the approved design proportions.
- implementation of primary action cards for "Ask a Doubt" and "Practice Exam".
- Refinement of quick action card elevation to use the lower-emphasis surface treatment from the approved design.
- Integration of a "Recommended for You" section for targeted weak-topic practice.
- Inclusion of "View All" affordances for secondary recommendation and recent-help sections.
- Implementation of a "Recent Help" activity log to track AI interactions.

## Capabilities

### New Capabilities
- `lms-ai-assistant-hub`: A personalized dashboard providing entry points for AI doubt resolution and automated custom exam generation based on user performance.

### Modified Capabilities
- `lms-navigation-shell`: Update navigation logic to show "AI Support" tab instead of "Explore" for paid active users.

## Impact

- `packages/ai_assistant`: Dashboard layout, mock data models, and AI assistant widgets.
- `packages/testpress`: Routing and tab configuration updates.
- `packages/core`: Shared design primitives, localization, and shell integration.
