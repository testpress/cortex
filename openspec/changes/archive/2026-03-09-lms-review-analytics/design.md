## Context

After a user finishes a test and reviews their performance via the `ReviewAnswerDetailScreen`, they need a higher-level summary that visualizes their testing metrics (time taken, accuracy, score percentiles) and provides section-wise breakdowns. We need to implement `ReviewAnalyticsScreen` based on the design requirements, which uses rich data visualization like donut charts, score gradient bars, and detailed metric tables. 
This change sits in Phase 3 ("Assessment & Testing") as change #14.

## Goals / Non-Goals

**Goals:**
- Implement `ReviewAnalyticsScreen` in Flutter, specifically within the `exams` package.
- Build a custom `DonutChart` widget to visualize correct, incorrect, and unanswered percentages using standard Flutter custom painting capabilities.
- Implement the "Performance Overview" section providing stats (Total Score, Accuracy, Percentile, etc.) along with the "Overall Performance" gradient visualizer.
- Implement the "Section Performance" breakdown table and corresponding subject-wise donut charts.
- Implement the "Explore More Details" quick-navigation grid to launch into subsequent views (e.g., Exam Review, Insights, Overall Performance).

**Non-Goals:**
- Backend integration (we will continue to use mock data for analytics data).
- The implementation of `InsightsScreen`, `OverallPerformanceScreen`, and `SubjectWisePerformanceScreen` (These screens belong to Phase 6: `lms-insights`, and will just be placeholders/empty routing stubs for now).

## Decisions

1. **Custom visualizers using `CustomPaint`**:
   - To maintain high performance without heavy charting packages, we will use Flutter's `CustomPaint` with arcs to draw the correct (green), incorrect (red), and unanswered (orange) segments. 
   - A similar approach will be taken for the Overall Performance gradient bar, taking advantage of a typical `Container` with `LinearGradient` and a positioned indicator slider.

2. **Data Structure Strategy**: 
   - We will create an `AnalyticsOverview` mock data class capturing things like total score, max score, percentile, and rank.
   - We will create a `SectionPerformanceOverview` class indicating correct, incorrect, metrics, and time spent on specific components like Quantitative Aptitude or English.

3. **Navigation Interconnectivity**:
   - To ensure smooth transitions within Flutter's `app_router`, the dashboard options (like navigating to "Exam Review") will perform `context.push` targeting the existing routes, passing the appropriate test identifiers.

## Risks / Trade-offs

- **Risk: Recreating complex tables on small mobile screens**
  - **Mitigation:** We will ensure the Section Performance table supports horizontal scrolling. We will wrap the table in a `SingleChildScrollView(scrollDirection: Axis.horizontal)` to prevent overflow pixels and allow horizontal scrolling.
  
- **Risk: Maintainability of custom-drawn graphics**
  - **Mitigation:** Keep the `CustomPaint` components isolated and decoupled from data logic, explicitly requiring just raw metrics (`correct`, `incorrect`, `unanswered`) so they are 100% reusable across other reporting widgets.
