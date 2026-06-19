## Why

The Top Learners section on the dashboard currently displays the trophies and their count in the top-right corner of the learner card. By moving the trophies and count directly underneath the learner's name, we can utilize the vertical space more effectively and remove the unnecessary empty space on the right side of the card. This tighter layout allows us to reduce the width of the card, improving the carousel's density and displaying more cards on the screen simultaneously.

## What Changes

- **Modify layout of `_LearnerCard`**: Move the `PointsDisplay` widget (which shows the trophy icon and the count) from the top-right corner to be underneath the learner's name.
- **Reduce card width**: Decrease the `width` of the card in the `_LearnersCarousel` (from `260` to a smaller size, or use constraints/wrap) to eliminate the empty horizontal space on the right.

## Capabilities

### New Capabilities

### Modified Capabilities
- `ui-top-learners`: Updated layout requirement for the Top Learners dashboard card

## Impact

- `packages/courses/lib/widgets/top_learners_section.dart`: Layout updates to the `_LearnerCard` and `_LearnersCarousel` widgets.
- No other systems, APIs, or dependencies are affected.
