## Context

Currently, `SubjectAnalyticsScreen` provides global analytics data, broken down into "Overall Reports" (bar charts) and "Individual Reports" (table with correct/incorrect breakdown). Users can tap on root subjects and navigate into their sub-subjects (children). However, when the user reaches a leaf subject (a topic with no children), the row becomes non-interactive. The goal is to provide a detailed analytics breakdown for those leaf topics.

## Goals / Non-Goals

**Goals:**
- Provide an interactive navigation experience all the way to the leaf topic level.
- Display topic-specific analytics (e.g., correct, incorrect, unanswered counts) in a dedicated, uncluttered view.
- Maintain existing routing paradigms for analytics.

**Non-Goals:**
- Altering the backend or `SubjectAnalyticsRepository`. The data layer (`subjectAnalyticsByIdProvider`) is already sufficient.
- Modifying the global user assessment logic; this is purely a UI/Routing feature.

## Decisions

### 1. Dedicated Screen vs Reusing SubjectAnalyticsScreen
**Decision:** Create a new dedicated `TopicAnalyticsScreen` rather than reusing `SubjectAnalyticsScreen`.
**Rationale:** `SubjectAnalyticsScreen` is heavily tailored around displaying *lists of children* (both in the table and the bar chart). A leaf topic explicitly has no children. Reusing the main screen would require adding complex empty-state guards and `isLeaf` checks to `OverallReportsView` and `IndividualReportsView` to render single-entity donut cards instead of lists. A dedicated screen avoids bloating the main views and allows a specialized, single-topic UI layout.

### 2. Navigation Routing
**Decision:** Add a nested route `topic/:id` under `/exams/analytics/`.
**Rationale:** It keeps the routing hierarchical and logically sound (e.g. `/exams/analytics/topic/123`). The screen will accept the `SubjectAnalyticsDto` as `extra` to prevent loading state flashes where possible.

### 3. Tap Handling Updates
**Decision:** Both `OverallReportsView` and `IndividualReportsView` will have their `isLeaf` tap guards updated to perform a `context.push()` to the new topic screen.

## Risks / Trade-offs

- **Risk:** Flash of loading states if the user navigates into a topic deeply and we only pass the ID.
  **Mitigation:** Pass the `SubjectAnalyticsDto` as the `extra` object in the GoRoute push, which the new screen can use to render immediately while (or instead of) fetching from the provider.
