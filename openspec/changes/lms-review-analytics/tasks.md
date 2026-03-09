## 1. Foundation & Mock Data

- [x] 1.1 Create `AnalyticsOverview` mock data class capturing fields like total score, max score, percentile, and rank.
- [x] 1.2 Create `SectionPerformanceOverview` mock data class for fields like section name, total questions, correct, incorrect, score, accuracy, and time spent.
- [x] 1.3 Populate a comprehensive mockup test analytics dataset in `packages/exams/lib/data/` for the review.
- [x] 1.4 Scaffold the basic `ReviewAnalyticsScreen` view within `packages/exams/lib/screens/review_analytics/`.
- [x] 1.5 Setup the router configuration in the `app` package to correctly pass assessment identity parameters into `ReviewAnalyticsScreen`.

## 2. Shared Sub-Components

- [x] 2.1 Implement the custom `DonutChart` widget utilizing Flutter's `CustomPaint` to draw green, red, and orange arcs given data points.
- [x] 2.2 Create the `PerformanceGradientBar` widget displaying the standard gradient colors mapped from "Bad" to "Excellent" along with a custom slider dot indicator.

## 3. Performance Overview Dashboard

- [x] 3.1 Implement the metric cards grid (Total Score, Attempted Questions, Percentile, Accuracy, Time Taken, Overall Rank).
- [x] 3.2 Implement the primary Hero Donut Chart utilizing the reusable `DonutChart` sub-component next to/within the metrics card grid.
- [x] 3.3 Integrate the `PerformanceGradientBar` widget directly underneath the metric cards along with its corresponding textual labels.

## 4. Section Breakdown Dashboard

- [x] 4.1 Implement the horizontal Section Donut Chart list, rendering a smaller parameterized `DonutChart` for each core mock subject field.
- [x] 4.2 Implement the detailed scrolling Section Table (`SingleChildScrollView` wrapping a `DataTable` or similar row layout), mapping directly over the `SectionPerformanceOverview` array including an absolute "Overall" row.

## 5. Explore More Details Dashboard

- [x] 5.1 Implement the "Explore More Details" quick-navigation grid.
- [x] 5.2 Execute the routing integration for the "Exam Review" tile that kicks off the user's `ReviewAnswerDetailScreen` instance.
- [x] 5.3 Configure stubbed click handlers (`print` or basic Snackbars) for the "Insights", "Overall Performance", and "Subject-wise" routes.
