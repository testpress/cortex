## 1. UI Layout Updates

- [x] 1.1 In `_LearnerCard` (`packages/courses/lib/widgets/top_learners_section.dart`), move the `PointsDisplay` widget from the top row to below the learner's name text.
- [x] 1.2 In `_LearnerCard`, ensure the name `AppText.subtitle` is properly truncated with `TextOverflow.ellipsis` to handle the narrower width constraint.
- [x] 1.3 In `_LearnersCarousel`, reduce the `width` parameter of the `SizedBox` from `260` to a tighter constraint (e.g., `160`).
- [x] 1.4 Test the dashboard locally to verify the layout displays cleanly without overflow or unnecessary empty space.
