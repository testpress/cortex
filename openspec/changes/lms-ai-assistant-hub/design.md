## Context

Implementing the `AIAssistantPage` dashboard for the Cortex Flutter SDK. This page serves as the "AI Support" hub for paid active users, replacing the "Explore" tab. The design is based on the approved Figma direction emphasizing personalized greetings, activity status, and performance-driven recommendations.

## Goals / Non-Goals

**Goals:**
- Implement the dashboard layout with personalized greeting and study insights.
- Provide primary "Ask a Doubt" and "Practice Exam" action cards.
- Display a "Recommended for You" section highlighting weak topics.
- Include "More Topics to Practice" and "Recent Help" section headers with trailing "View All" affordances.
- Show "Recent Help" activity log with status indicators (Answered, Processing, Revisit).
- Ensure visual consistency with the existing `DesignConfig` and `AppCard` primitives.

**Non-Goals:**
- Implementing the actual AI chat/doubt flow (separate change).
- Implementing the "Practice Exam" generation wizard (separate change).
- Navigation logic to sub-screens (will be handled in a follow-up task).

## Decisions

### 1. Component Architecture
- **Location**: `packages/ai_assistant/lib/`
- **Main Widget**: `AIAssistantPage` (Stateless, composed from local mock data and reusable widgets).
- **Sub-widgets**: 
    - `AIGreetingHeader`: Custom header with `Sparkles` icon and user stats.
    - `AIQuickActionCard`: Reusable wrapper around `AppCard` for primary actions.
    - `AIRecommendationCard`: Highlight card for the top weak topic with a CTA.
    - `AIActivityItem`: Card row for recent AI interactions and their status.
    - Secondary weak-topic cards inside `AIAssistantPage`: compact recommendation rows with a trailing chevron, inline progress bar, and percentage label.

### 2. Design Tokens & Primitives
- **Cards**: Use `AppCard` with `showBorder: true` for the standard dashboard look.
- **Quick action elevation**: The "Ask a Doubt" and "Practice Exam" cards should use the subtle surface shadow (`design.shadows.surfaceSoft`) rather than the stronger floating shadow so they read as grounded list cards from the approved design.
- **Greeting hierarchy**: The personalized greeting should remain prominent, but the user-name line should sit slightly below hero scale so it does not overpower the quick actions section.
- **Greeting icon balance**: The leading sparkles icon should be slightly smaller than the largest icon token so it supports the greeting without dominating the header row.
- **Greeting trust line**: The header should include a small explanatory line clarifying that AI suggestions are powered by the learner's progress and exam performance.
- **Secondary text legibility**: Supporting copy, metadata rows, and section labels should prefer `textSecondary` or only lightly reduced alpha so they remain readable against the light dashboard background.
- **Section headers**: AI Support section labels such as "Quick Actions" and "Recent Help" should use a semantic typography token from `DesignTypography`, not file-local `TextStyle` overrides.
- **Section affordances**: "More Topics to Practice" and "Recent Help" should expose compact trailing "View All" actions, while individual secondary recommendation rows should expose a chevron to signal drill-in navigation.
- **Colors**: 
    - Use `design.colors.accent1` (Purple) for AI-related highlights.
    - Expose the exact recommendation highlight color `#FE9A00` through the design context as a semantic token, then use that token for the recommendation CTA, border, and progress fill.
    - Use the same semantic recommendation accent token for the "More Topics to Practice" progress fills and percentage labels to keep recommendation emphasis consistent.
    - Use `design.subjectPalette` for subject-specific progress bars in weak topics.
- **Icons**: Use `LucideIcons` via the `lucide_icons` package (ensure it's in `pubspec.yaml`).

### 3. Data Flow
- Use local mock models in `packages/ai_assistant/lib/models/ai_models.dart` and seeded values from `packages/ai_assistant/lib/data/ai_mock_data.dart`.
- Future state can replace the mock layer with repository-backed data without changing the widget composition.

## Risks / Trade-offs

- **[Risk] High UI Density** → [Mitigation] Use consistent spacing from `design.spacing.cardPadding` and ensure text scaling is handled via `DesignTypography`.
- **[Risk] Quick action cards feel too elevated** → [Mitigation] Reuse the existing soft surface shadow token instead of introducing a custom shadow recipe.
- **[Risk] Important navigation cues get lost** → [Mitigation] Preserve section-level "View All" affordances and row-level chevrons from the approved design.
- **[Risk] Mock Data Consistency** → [Mitigation] Keep the mock models and seeded examples inside `packages/ai_assistant` until the production data layer is finalized.
