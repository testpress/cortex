## Why

Provide users with a centralized and user-friendly interface to view and manage their downloaded course content, including videos and attachments. This aligns the Flutter app with the modern design standards established in the Figma prototype.

## What Changes

- **Add Downloads Menu Item**: Integrate a "Downloads" option into the `DashboardDrawer` in `packages/testpress`.
- **Create Downloads Screen**: Implement a new `DownloadsScreen` in `packages/courses` featuring a tabbed interface, high-fidelity list items, and empty states.
- **Persistent Data Layer**: Implement a `DownloadsRepository` and `AppDatabase` integration in `packages/core` to persist download records.
- **Reactive Synchronization**: Implement a `downloadsBootstrapProvider` to automatically synchronize local records with SDK state upon screen entry.
- **Aesthetic Loading States**: Integrated `Skeletonizer` with custom shimmer effects for a premium loading experience.
- **Dynamic Storage Calculation**: A footer displaying real-time calculations of item counts and total disk space used based on database content.

## Capabilities

### New Capabilities
- `downloads-management`: A centralized interface for viewing and managing (deleting/retrying) locally stored course content.

### Modified Capabilities
- None

## Impact

- **packages/courses**: Creation of `DownloadsScreen` and related widgets.
- **packages/testpress**: Modification of `DashboardDrawer` to include the new menu item.
- **Navigation**: Potential updates to the app's routing to handle navigation to the Downloads screen.
