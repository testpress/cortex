## Why

After completing an assessment, students need a comprehensive breakdown of their performance to gauge their understanding, identify weak areas, and strategize their future studies. The Review Analytics dashboard bridges the gap between test completion and detailed subjective review, offering high-level metrics and section-wise feedback at a glance.

## What Changes

- Introduce the `ReviewAnalyticsScreen` to serve as a post-assessment performance dashboard.
- Display high-level metrics: Total Score, Attempted Questions, Percentile, Accuracy, Time Taken, and Overall Rank.
- Include a visual "Overall Performance" gradient bar and Donut Charts for correct/incorrect/unanswered breakdowns.
- Provide a "Section Performance" breakdown featuring donut charts per subject and a comprehensive data table showing scores, accuracy, and time spent.
- Add an "Explore More Details" quick-navigation section directing users to deeper analytical views (Overall Performance, Subject-wise Performance, Exam Review, and Insights).

## Capabilities

### New Capabilities
- `lms-review-analytics`: Core dashboard for reviewing top-level exam analytics, section breakdowns, and branching out into deeper dive performance screens.

### Modified Capabilities


## Impact

- **UI/UX**: Adds a high-density, data-rich screen with complex visual elements like custom styled donut charts, gradient performance bars, and extensive data tables.
- **Navigation Flow**: Seamlessly integrates into the post-assessment user journey, acting as a gateway to the previously built `ReviewAnswerDetailScreen`.
- **Data Models**: Requires robust data structures to compute and supply percentile, rank, accuracy, and section-wise aggregations (mock data initially).
