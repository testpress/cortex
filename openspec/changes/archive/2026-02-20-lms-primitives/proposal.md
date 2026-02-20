## Why

We need to establish a set of core, highly reusable UI components (primitives) for the LMS app before building out the complex feature screens. Building these primitives now ensures visual consistency across the app, prevents code duplication, and provides a solid foundation that adheres strictly to our new design system tokens (colors, corners, typography).

## What Changes

We are introducing four foundational UI components to the `packages/core` directory:
- `AppBadge`: A flexible badge component used for displaying statuses (e.g., Completed, Live, Locked), tags, and roles.
- `AppSearchBar`: A standardized, styled text input component optimized for search operations (with a built-in search icon and standardized padding/styling).
- `AppTabBar`: A customizable bottom navigation bar to serve as the main routing shell for the application (Home, Study, Explore, Profile).
- `AppSubjectChip`: An interactive filter chip that utilizes our new color tokens for content type and subject-based filtering.

## Capabilities

### New Capabilities
- `lms-primitives`: Establishes the core UI component library (Search Bar, Badge, Tab Bar, Subject Chip) within the Flutter SDK.

### Modified Capabilities


## Impact

- **Core Package**: `packages/core` will be expanded to house and export these new custom widgets.
- **Future Development**: All subsequent screen implementations (Study Page, Home Page, Explore Page) will mock up their layouts using these primitives, significantly speeding up workflow and guaranteeing cross-screen consistency.
