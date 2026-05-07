## Context

The application currently lacks a centralized view for downloaded course content. This change introduces a high-fidelity "Downloads" screen, following the design system established in the Figma prototype (`figma/project-1`).

## Goals / Non-Goals

**Goals:**
- Implement a fully functional UI for the Downloads screen with "Videos" and "Attachments" tabs.
- **Database Persistence**: Use Drift and `AppDatabase` to persist download records locally.
- **Reactive State**: Use Riverpod providers (`downloadsProvider`, `downloadsBootstrapProvider`) for reactive UI updates and background synchronization.
- **High-Fidelity Loading**: Implement `Skeletonizer` with custom `ShimmerEffect` to provide a premium wait experience.
- **Dynamic Metadata**: Real-time progress bars for active downloads and dynamic storage usage calculation in the footer.
- Integrate the screen into the `DashboardDrawer` in the `testpress` package.
- Ensure the screen supports both Light and Dark modes using the project's design tokens.

**Non-Goals:**
- Real-time video player integration (handled by Player SDK).
- Multi-threaded file downloading logic (handled by existing SDKs).

## Decisions

- **Placement**: The `DownloadsScreen` will be placed in `packages/courses/lib/screens/` as the current designs focus on course-specific content.
- **State Management**: A functional Riverpod stream provider (`downloadsProvider`) watches the repository. A thin action provider layer (e.g., `deleteDownloadProvider`) handles user interactions to ensure clean separation between UI and data logic.
- **Data Layer**: Adopted the Repository pattern (`DownloadsRepository`) to coordinate between `DownloadsService` (SDK integration) and `AppDatabase` (Local cache).
- **UI Components**:
    - Use `AppDrawerItem` for the entry point in the drawer.
    - Use `ListView.separated` or `SliverList.separated` for the download items.
    - **Aesthetics**: Use `Skeletonizer` with `ShimmerEffect` for loading states. Custom `Skeleton.ignore` and `Skeleton.hidden` rules ensure the shimmer looks premium (e.g., hiding duration badges during loading).
    - Leverage `LucideIcons` as per the design.
- **Navigation**: Use the established `GoRouter` patterns (or context-based navigation if specific to the drawer) to push the `DownloadsScreen`.

## Risks / Trade-offs

- **Risk**: The Figma design uses specific hex codes and Tailwind classes that might not map 1:1 to the Flutter `Design` system.
- **Mitigation**: Use the closest available tokens from the `Design` system (e.g., `design.colors.surface`, `design.colors.textPrimary`) to ensure theme compatibility, only overriding when necessary for specific branding colors.
- **Risk**: Hardcoded mock data might lead to extra work during future integration.
- **Mitigation**: Define clean data models (`DownloadItem`) that can be easily replaced by actual entities later.
