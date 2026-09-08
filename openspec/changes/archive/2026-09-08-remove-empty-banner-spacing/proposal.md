## Why

When no home page banners are configured, an unwanted vertical empty gap is left on the home screen between the user greeting ("Good afternoon...") and the next content section ("Resume Learning").
This occurs because standalone `SizedBox` spacing widgets are placed between dashboard sections in `PaidActiveHomeScreen`, which persist even when sections like `TopCarouselSectionWidget` return `SizedBox.shrink()`. Additionally, skeleton loading states can render a empty placeholder block during initial loading.

## What Changes

- Remove standalone `SizedBox` height spacers between section widgets in `PaidActiveHomeScreen`.
- Ensure dashboard section widgets (such as `TopCarouselSectionWidget`, `ContextualHeroSectionWidget`, and `TodayScheduleSectionWidget`) manage their own self-contained bottom padding so that empty sections (`SizedBox.shrink()`) contribute zero height/padding to the layout.
- Ensure the hero banner skeleton loading state in `TopCarouselSectionWidget` does not render a 16:9 box when banners are empty or disabled.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `lms-home-paid-active`: Update requirement so that sections manage self-contained padding and eliminate vertical gaps when banner or schedule sections are empty.

## Impact

- `packages/testpress/lib/screens/dashboard/paid_active_home_screen.dart`
- `packages/testpress/lib/screens/dashboard/widgets/top_carousel_section_widget.dart`
