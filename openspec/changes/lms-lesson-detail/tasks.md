## 1. Foundation & Data Models

- [x] 1.1 Define `LessonContentItem` sealed class and its variants (Heading, Paragraph, Image, List, Callout) in `packages/courses`.
- [x] 1.2 Update the mock data repository with a representative lesson containing all content types for verification.

## 2. Shared Components

- [x] 2.1 Implement `LessonDetailHeader` widget featuring a back button, bookmark toggle, and download icon.
- [x] 2.2 Implement `LessonReadingProgressBar` using a linear progress indicator driven by scroll state.
- [x] 2.3 Implement `LessonNavigationFooter` with "Previous Lesson" and "Next Lesson" navigation buttons.

## 3. Content Rendering System

- [x] 3.1 Implement `LessonHeading` widget supporting three levels of hierarchy.
- [x] 3.2 Implement `LessonParagraph` widget with optimized line height and typography.
- [x] 3.3 Implement `LessonCallout` widget with subject-specific color coding and iconography.
- [x] 3.4 Implement `LessonImage` widget with rounded borders and lazy loading support.
- [x] 3.5 Implement `LessonList` widget with custom bullets and proper indentation.

## 4. Main Screen Implementation

- [x] 4.1 Assemble `LessonDetailScreen` using a `CustomScrollView` for smooth scrolling and header stickiness.
- [x] 4.2 Implement scroll listener logic to calculate reading progress percentage.
- [x] 4.3 Integrate navigation routing to launch `LessonDetailScreen` from the curriculum list.
- [x] 4.4 Apply `SubjectColors` design tokens to ensure subject-consistent branding across the screen.
