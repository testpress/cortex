## Context

The `TopLearnersSection` widget (`packages/courses/lib/widgets/top_learners_section.dart`) renders a list of top learners on the dashboard. In its current design, the `_LearnerCard` displays the `PointsDisplay` (trophy icon and count) in the top-right corner, while the avatar is on the top-left. This wastes horizontal space. The objective is to move the `PointsDisplay` to be directly underneath the learner's name and reduce the overall width of the card, allowing more cards to fit on the screen without scrolling.

## Goals / Non-Goals

**Goals:**
- Move `PointsDisplay` under the learner's name inside `_LearnerCard`.
- Reduce the fixed horizontal width of `_LearnerCard` in the carousel (currently set to 260) to eliminate empty whitespace.

**Non-Goals:**
- Refactoring the underlying logic for fetching top learners.
- Adjusting the overall layout of the full leaderboard screen.

## Decisions

- **Layout Structure Change**: In `_LearnerCard`, we will modify the existing `Column` and `Row` layout. We will remove the `PointsDisplay` from the top `Row` (where it was spaced opposite the avatar). Then, we will append `PointsDisplay` below the name text.
- **Card Width Reduction**: In `_LearnersCarousel`, the `width` of the `SizedBox` wrapping the `_LearnerCard` is currently hardcoded to `260`. We will reduce this to approximately `180` (or `160`, whichever visually fits the content without clipping) since the right-hand padding is no longer needed.

## Risks / Trade-offs

- **Risk: Content Overflow** -> Mitigation: Ensure the text element for the learner's name is truncated with `TextOverflow.ellipsis` to prevent overflow errors in the narrower card constraint.
