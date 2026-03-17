## 1. Setup & Foundations

- [x] 1.1 Verify and update `pubspec.yaml` in `packages/ai_assistant` for `lucide_icons` dependency.
- [x] 1.2 Define AI-related mock models (`AIRecommendation`, `WeakTopic`, `AIActivity`) in `packages/ai_assistant/lib/models/ai_models.dart`.

## 2. Component Implementation

- [x] 2.1 Create `AIGreetingHeader` with personalized name and study insights in `packages/ai_assistant/lib/widgets/ai_greeting_header.dart`.
- [x] 2.6 Reduce the greeting name text size slightly in `AIGreetingHeader` so the header hierarchy better matches the approved design.
- [x] 2.7 Reduce the greeting sparkles icon size slightly in `AIGreetingHeader` so it stays visually balanced with the smaller heading.
- [x] 2.8 Increase secondary text contrast across the AI assistant header and metadata rows so supporting copy stays readable on the light background.
- [x] 2.9 Apply the exact recommendation highlight color `#FE9A00` to the recommendation CTA and progress treatment.
- [x] 2.10 Apply the exact `#FE9A00` accent to the "More Topics to Practice" progress bars and percentage labels.
- [x] 2.11 Move the recommendation accent `#FE9A00` into the design context and replace hardcoded widget color literals with that token.
- [x] 2.12 Reflect the greeting trust line, "View All" section actions, row chevrons, and activity time metadata in the AI Support documentation so implementation guidance matches the approved design.
- [x] 2.13 Move AI Support section-header styling into a semantic typography token and remove stale `AppCard` implementation comments that no longer match behavior.
- [x] 2.2 Create `AIQuickActionCard` using existing `AppCard` primitive in `packages/ai_assistant/lib/widgets/ai_quick_action_card.dart`.
- [x] 2.5 Adjust `AIQuickActionCard` to use the standard surface shadow instead of the floating shadow so the quick actions match the approved low-elevation design.
- [x] 2.3 Create `AIRecommendationCard` with subject-specific progress bars in `packages/ai_assistant/lib/widgets/ai_recommendation_card.dart`.
- [x] 2.4 Create `AIActivityItem` with status badges in `packages/ai_assistant/lib/widgets/ai_activity_item.dart`.
- [x] 2.13 Refactor AI activity item colors to use semantic `conceptAccent` and `conceptBackground` tokens instead of brittle hardcoded palette indices.

## 3. Page Assembly

- [x] 3.1 Assemble `AIAssistantPage` dashboard in `packages/ai_assistant/lib/screens/ai_assistant_page.dart`.
- [x] 3.2 Ensure scrolling behavior and consistent padding matching the design system.

## 4. Integration & Navigation

- [x] 4.1 Update navigation shell labeling to expose "AI Support" for the paid-user dashboard flow.
- [x] 4.2 Register `AIAssistantPage` in the app router for the AI assistant tab.

## 5. Verification

- [x] 5.1 Verify UI layout against the approved Figma design direction (personalized greeting, cards, activity list).
- [x] 5.2 Test dark mode transitions for AI dashboard components.
