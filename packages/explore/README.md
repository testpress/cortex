# Explore & Discovery

The `explore` module provides discovery features, course recommendations, and community-driven learning highlights.

## Purpose
This module acts as the central hub for content discovery, search, and featured learning material in the Cortex LMS.

## Standards
- Depends on `package:core/core.dart` for all UI primitives.
- Must follow the **Neutral UI** and **Accessibility** contracts defined in `core`.
- No direct dependencies on standard Material/Cupertino widgets.

# Accessibility Integration

### Semantic Compositions
The explore module inherits its accessibility foundation from `core`. Components must compose these foundations into domain-specific semantics:
- **Featured Carousels**: Carousel items use `AppSemantics.banner` to announce promotional content and offer clear navigation controls.
- **Discovery Lists**: Horizontal and vertical lists use `AppSemantics.collection` to announce the number of available items.
- **Search Experience**: The `AppSearchBar` provides semantic hints and live region updates during filtering activity.
