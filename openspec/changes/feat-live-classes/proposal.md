## Why

Students need a centralized view to find, track, and filter upcoming, ongoing (live), completed, or cancelled live class sessions to stay on top of their live schedule. Currently, there is only a list section on the dashboard and no full screen calendar or list view.

## What Changes

- **Core Data & APIs**: Add `/api/v3/live-classes/` API endpoint. Extend `LiveClassDto` to support cancelled status, custom start times, duration, and provider mapping.
- **Offline Caching**: Sync paginated live class payloads via `LiveClassesRepository` into a Drift SQLite database table `liveClassesTable`, making local database cache the single source of truth.
- **State Management**: Create Riverpod `@riverpod` stream notifier `LiveStreamList` to auto-sync repository data and expose stream updates.
- **UI & Views**:
  - Add full screen `LiveStreamListScreen` in `packages/testpress` with tabbed status filters (All, Live, Upcoming, Completed, Cancelled).
  - Add alternative toggleable `LiveStreamCalendarView` using `syncfusion_flutter_calendar` to display class listings inside an interactive month calendar layout.
  - Link the new flow as a 'Live Classes' option inside the `DashboardDrawer`.

## Capabilities

### New Capabilities
- `live-classes`: User-facing Live Classes screen with list, calendar view, status filters, caching, and background sync.

### Modified Capabilities
