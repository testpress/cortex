# Proposal: LMS Paid Active User Home Screen (`lms-home-paid-active`)

## Objective
Implement the primary dashboard for authenticated students with an active subscription. This screen serves as the "cockpit" for their daily learning journey, providing immediate access to live classes, pending assignments, performance insights, and quick actions.

## What Changes
This change introduces the `PaidActiveHome` screen and its associated sub-components. It integrates data from the mock data layer (Courses, Classes, Assessments, Tests) to provide a rich, interactive experience.

### New Components (Internal to `packages/courses` or moved to `packages/core` if generic):
- **TodaySnapshot**: A multi-section carousel stack for:
    - **Now & Next**: Live and immediate upcoming classes.
    - **Deadlines**: Urgent assignments/assessments.
    - **Upcoming Tests**: Scheduled examinations.
    - **Later Today**: Rest of the day's schedule.
- **StudyMomentum**: A performance dashboard including:
    - **7-Day Activity Strip**: Visual representation of study intensity.
    - **Learning Stats**: Lessons finished, tests attempted, assessments completed.
    - **Subject Insights**: Visual cues for strongest and "need focus" subjects.
- **QuickAccess**: A grid of shortcuts for common activities (Doubts, Schedule, Practice, etc.).
- **GreetingSection**: Personalized user welcome with time-of-day awareness.
- **ContextualHeroCard**: A prominent card highlighting the single most important action (e.g., "Join Live Class Now").

## Capabilities

### New Capabilities
- `lms-home-paid-active`: Dashboard experience for active paid users, aggregating daily schedules and performance metrics into a single high-density view.

### Modified Capabilities
- `lms-navigation-shell`: Update the "Home" tab to route to `PaidActiveHome` when the user is authenticated and paid.

## Impact
- **Modules**: `packages/courses` (main implementation), `app` (routing/integration).
- **Data**: Consumes data from `CourseRepository`, `ClassRepository`, and `AssessmentRepository`.
- **UI**: High reliance on `AppCard`, `AppBadge`, and `DesignProvider` tokens.
