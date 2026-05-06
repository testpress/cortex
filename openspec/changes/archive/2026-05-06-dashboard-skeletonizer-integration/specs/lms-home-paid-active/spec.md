## ADDED Requirements

### Requirement: Smooth Loading Experience (Skeletonization)
The home screen SHALL provide a smooth, flicker-free loading experience by utilizing structural skeletons while data is being fetched.

#### Scenario: Home screen initial load with skeletons
- **WHEN** the `PaidActiveHomeScreen` is first rendered and data providers are in a loading or empty state
- **THEN** the screen MUST display `Skeletonizer` placeholders for the `HeroBannerCarousel`, `LessonCardsSection`, and `TopLearnersSection`
- **AND** the screen MUST remain scrollable to allow users to explore the layout structure immediately
