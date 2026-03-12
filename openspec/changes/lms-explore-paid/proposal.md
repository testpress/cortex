## Why

The current application has a placeholder for the "Explore" tab in the main navigation. This placeholder provides no value to the user and lacks the discovery features present in the original design. Implementing a fully-featured Explore page is essential for facilitating content discovery, promoting new courses, and increasing user engagement.

## What Changes

- **New Explore Module**: Implementation of a new dedicated `explore` package to encapsulate all discovery and community features.
- **Search & Discovery**: Integrated search bar at the top of the Explore tab for finding courses, lessons, and topics.
- **Dynamic Content Sections**:
    - **Hero Carousel**: Featured banners for new launches, updates, or motivational content.
    - **Trending & Recommended**: Horizontal scrolling sections for course discovery.
    - **Short Lessons**: Quick-access video/PDF content for micro-learning.
    - **Popular Tests**: Promotion of Mock and Practice tests.
- **Educational Content**:
    - **Study Tips**: A section for blog-style articles and motivational tips.

## Capabilities

### New Capabilities
- `lms-explore-dashboard`: The main landing experience for the Explore tab, coordinating the layout of featured content and discovery sections.
- `lms-explore-search`: Search and filtering logic specifically for the discovery flow.
- `lms-study-tips`: A system for viewing study tips and help articles (referenced from Explore).

### Modified Capabilities
- (None)

## Impact

- **New Package**: `packages/explore` will be created.
- **Router**: `packages/testpress/lib/navigation/app_router.dart` will be updated to replace the placeholder with the new `ExplorePage`.
- **Data Layer**: Requires new mock data in `packages/core` for banners and study tips.
