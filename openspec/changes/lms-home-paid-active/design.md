# Design Doc: LMS Paid Active User Home Screen (`lms-home-paid-active`)

## Context
The "Home" screen for paid active users is the most critical surface in the app. It must aggregate data from multiple domains (Classes, Courses, Assessments) and present it in a personalized, scannable format. Currently, the "Home" tab is likely a placeholder or basic list.

## Goals / Non-Goals

**Goals:**
- Replicate the high-fidelity Figma design dashboard experience in Flutter.
- Implement `TodaySnapshot` with its multi-carousel grouping logic.
- Implement `StudyMomentum` with intensity-based activity visualization.
- Ensure pixel-perfect alignment with the design system (colors, spacing, typography).
- Support smooth transitions between user types (if applicable in future).

**Non-Goals:**
- Modifying the underlying data models (handled by `lms-data-layer`).
- Implementing the actual lesson players or test-taking interfaces (these are separate changes in Phase 2/3).
- Implementing non-paid variants of the home screen (Phase 7).

## Decisions

### 1. High-Density Widget Composition
The `PaidActiveHomeScreen` will be a `CustomScrollView` to allow for a flexible, scrollable layout. Individual sections (`Greeting`, `Banners`, `Snapshot`, `Momentum`) will be implemented as modular widgets within the `packages/courses` library.

### 2. Snapshot Grouping Logic
Following the Figma design implementation, `TodaySnapshot` will perform "smart grouping":
- **Now & Next**: Classes with status `live` or the first `upcoming` class.
- **Deadlines**: `overdue` or `pending` assignments/assessments.
- **Upcoming Tests**: Important/regular tests from the `test` data source.
- **Later Today**: Remaining `upcoming` and `completed` classes.

### 3. Carousel Component
Since `packages/core` lacks a carousel, we will implement a simple `AppCarousel` (internal or shared) using `PageView` or `ListView.builder` with `ScrollPhysics` to match the "peek" behavior of the Figma design implementation (`slidesToShow: 1.15`).

### 4. State Management
We will use Riverpod providers to fetch data:
- `todayClassesProvider`: Aggregates classes for today.
- `pendingAssignmentsProvider`: Fetches overdue/pending assessments.
- `studyMomentumProvider`: Calculates activity data for the current week.

## Risks / Trade-offs

- **Performance**: High widget density could impact frame rates on low-end devices. Mitigation: Use efficient `ListView` patterns and avoid complex re-renders in carousels.
- **State Complexity**: Managing 4-5 different carousels on one screen. Mitigation: Isolate state management within each section widget.
