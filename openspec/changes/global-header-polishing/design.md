## Context

The app currently uses top padding on several main screens (like the `DashboardHeader` on the Profile page, and the inline `SliverToBoxAdapter` header on the Study page) that pushes the header below the transparent status bar, creating a disconnected, boxed-in look. On the other hand, screens like Notifications and Certificates draw their background fully under the status bar, resulting in a seamless and polished appearance. Additionally, there are minor UI inconsistencies in the back button alignment and color on the profile sub-screens (Edit Profile, Notifications, Certificates).

## Goals / Non-Goals

**Goals:**
- Update `DashboardHeader` and inline tab headers (e.g., `StudyScreen`, `ExamsScreen`) to properly extend their background color behind the status bar, creating a seamless visual merge.
- Standardize the internal alignment of the back arrow and text on the Edit Profile, Notifications, and Certificates screens so they match perfectly.
- Standardize the color of the back button on the Certificates screen to match the other two screens.

**Non-Goals:**
- Completely refactoring or redesigning the entire app header architecture into a single unified widget (we will fix the padding behavior where it currently lives).
- Changing the sizes of the back button icons (we are only fixing their alignment and color).

## Decisions

- **Status Bar Merging**: We will modify `DashboardHeader` and any custom inline headers (such as the one in the Study screen) to explicitly extend their background color to the top edge of the screen. We will preserve the necessary safe area padding for the actual content, ensuring the background color is drawn seamlessly under the status bar.
- **Button Alignment**: For the three profile sub-screens, we will align the back icon and text to the center vertically and ensure they share identical layout constraints.
- **Button Color**: Update the back button color on the certificates screen so it explicitly matches the active design tokens used by the other profile screens.

## Risks / Trade-offs

- **Risk**: Modifying `DashboardHeader` and inline tab headers could cause unintended layout shifts or overlapping content in screens that currently rely on the "boxed" behavior.
  - **Mitigation**: We will verify the visual layout across all main tabs to ensure the header content remains safely bounded while the background extends gracefully.
