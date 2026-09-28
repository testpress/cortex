# Cortex Architecture Overview

Welcome to **Cortex**! This document provides a comprehensive guide to understanding the architecture, design principles, and data patterns of the Cortex monorepo. It is designed to help new engineers ramp up quickly and build features confidently without breaking system-wide architectural rules.

---

## Table of Contents
1. [Core Architectural Philosophy](#1-core-architectural-philosophy)
2. [Monorepo Structure & Package Boundaries](#2-monorepo-structure--package-boundaries)
3. [Design Governance vs. State Management](#3-design-governance-vs-state-management)
4. [Neutral UI & Accessibility Contract](#4-neutral-ui--accessibility-contract)
5. [Offline-First Reactive Pattern (Drift + Dio)](#5-offline-first-reactive-pattern-drift--dio)
6. [State Management & Dependency Injection (Riverpod)](#6-state-management--dependency-injection-riverpod)
7. [Navigation & Routing (GoRouter + AppRoute)](#7-navigation--routing-gorouter--approute)
8. [Code Generation & Build Workflow](#8-code-generation--build-workflow)
9. [Fresher Cheatsheet: Dos & Don'ts](#9-fresher-cheatsheet-dos--donts)

---

## 1. Core Architectural Philosophy

Cortex is architected from first principles with four core tenets:

1. **Flutter as a Rendering Engine, Not a Widget Library**  
   We do not use Material or Cupertino visual styling widgets. All UI components are built from low-level Flutter rendering primitives (`Container`, `GestureDetector`, `CustomPaint`, `Text`).
2. **Platform Neutrality**  
   The application must look and behave consistently across Android and iOS. Platform branching for visual behavior (`if (Platform.isIOS)`) is **strictly forbidden**. Platform checks are only allowed for device capabilities (e.g., camera, file system, or push notification tokens).
3. **SDK-First Monorepo**  
   Features are organized as standalone, reusable SDK modules under `packages/`. The consumer application under `app/` is purely a thin reference shell.
4. **Runtime Design Token Governance**  
   Design tokens (colors, typography, spacing, radius, motion) are injected at runtime via an inherited context rather than hardcoded or statically imported.

---

## 2. Monorepo Structure & Package Boundaries

Cortex is organized as a multi-package Flutter monorepo with strict dependency isolation:

```
cortex/
├── app/                        # Reference consumer application shell
│
├── packages/
│   ├── core/                  # Foundation SDK: Design system, primitives, DB, network, auth
│   │
│   ├── courses/               # Domain SDK: Courses, chapters, lessons, video player, downloads
│   ├── exams/                 # Domain SDK: Exams, tests, question review, offline exams
│   ├── discussions/           # Domain SDK: Q&A forums, post threads, comments
│   ├── profile/               # Domain SDK: User profile settings, certificates, bookmarks
│   ├── zoom/                  # Domain SDK: Zoom live-class SDK integration
│   │
│   └── testpress/             # Public SDK Aggregator: Combines domains, routes, and public API
│
└── docs/                      # Central documentation & setup guides
```

### Strict Import Boundaries

The layer hierarchy is strictly unidirectional:

```text
┌────────────────────────────────────────────────────────┐
│               app (Consumer Shell)                     │
└───────────────────────────┬────────────────────────────┘
                            │ imports only
                            ▼
┌────────────────────────────────────────────────────────┐
│       packages/testpress (Public SDK Aggregator)       │
└───────┬──────────────┬──────────────┬───────────┬──────┘
        │              │              │           │
        ▼              ▼              ▼           ▼
   ┌─────────┐    ┌─────────┐    ┌───────────┐   ┌─────────┐
   │ courses │    │  exams  │    │discussions│   │ profile │  (Domain Packages)
   └────┬────┘    └────┬────┘    └─────┬─────┘   └───┬─────┘
        │              │               │             │
        └──────────────┴───────┬───────┴─────────────┘
                               │ imports
                               ▼
┌────────────────────────────────────────────────────────┐
│            packages/core (Platform Foundation)         │
└────────────────────────────────────────────────────────┘
```

| Package | May Import | Must NEVER Import |
|---|---|---|
| `packages/core` | Flutter SDK, third-party libraries | Any domain package (`courses`, `exams`, etc.) or `testpress` |
| Domain Packages (`courses`, `exams`, etc.) | `package:core/core.dart` | Other domain packages (no circular links) or `testpress` |
| `packages/testpress` | `core`, `courses`, `exams`, `discussions`, `profile`, `zoom` | `app` |
| `app/` | `package:testpress/testpress.dart` **ONLY** | `core` or individual domain packages directly |

> [!IMPORTANT]
> **Domain Isolation Rule**: Never import `courses` from `exams`, or `profile` from `courses`. If data needs to be shared across domains (for example, the authenticated `User` profile or bookmarks), that entity belongs in `packages/core/lib/data/`.

---

## 3. Design Governance vs. State Management

New engineers commonly confuse **DesignProvider** with application state management. They serve completely different purposes:

### `DesignProvider` (Visual Tokens Only)
- Implemented as an `InheritedWidget` in `packages/core/lib/design/`.
- Injected at the root of the widget tree:
  ```dart
  DesignProvider(
    config: DesignConfig.defaults(),
    child: CortexApp(),
  )
  ```
- **Usage**: Read design tokens in widgets:
  ```dart
  final design = Design.of(context);
  Container(
    color: design.colors.primary,
    padding: EdgeInsets.all(design.spacing.md),
  );
  ```
- **Do not** use `DesignProvider` to hold business data, user state, or API responses.

### `Riverpod` (Application State & Logic)
- Used for all dependency injection, repository access, network calls, and async state caching.
- See [Section 6](#6-state-management--dependency-injection-riverpod) for patterns.

---

## 4. Neutral UI & Accessibility Contract

To maintain white-label capabilities and cross-platform visual consistency, Cortex follows ADR 0001 (Neutral UI Philosophy):

### Avoid Material and Cupertino Visual Widgets
We avoid platform-coupled widgets such as `Scaffold`, `AppBar`, `ElevatedButton`, `TextButton`, `Card`, `ListTile`, `FloatingActionButton`, `CupertinoNavigationBar`, and `CupertinoButton`.

### Core Neutral Primitives
Always import `package:core/core.dart` and use our custom primitives built from first principles:

| Avoid | Recommended Core Primitive |
|---|---|
| `Scaffold` | `AppShell` or custom layout with `Container` |
| `AppBar` | `AppHeader(title: '...', actions: [...])` |
| `Text` (styled) | `AppText.headline('...')`, `AppText.body('...')`, `AppText.caption('...')` |
| `ElevatedButton` | `AppButton.primary(label: '...', onPressed: ...)` |
| `OutlinedButton` | `AppButton.secondary(label: '...', onPressed: ...)` |
| `Card` | `AppCard(child: ...)` |
| `SingleChildScrollView` | `AppScroll(children: [...])` |

### Mandatory Accessibility (WCAG AA)
1. **Semantic Wrapping**: All interactive elements must be wrapped with `AppSemantics`:
   ```dart
   AppSemantics.button(
     label: 'Start Quiz',
     onTap: handleStartQuiz,
     enabled: isReady,
     child: buttonWidget,
   )
   ```
2. **Touch Targets**: Minimum **48x48 dp** hit area for all buttons and tap handlers.
3. **Motion Preferences**: Respect system animation preferences before triggering animations:
   ```dart
   if (MotionPreferences.shouldAnimate(context)) {
     // Run animation
   }
   ```

---

## 5. Offline-First Reactive Pattern (Drift + Dio)

Cortex uses an **offline-first single-source-of-truth (SSOT)** architecture powered by [Drift](https://drift.simonbinder.eu/) (SQLite) and [Dio](https://pub.dev/packages/dio).

### The Core Reactive Pipeline

```
[UI / ConsumerWidget]
       ▲
       │  1. watchStream() (Reactive updates)
       │
[Repository] ─── reads/watches ───► [AppDatabase (Drift SQLite)]
       │                                       ▲
       │  2. refresh() (Background sync)       │ 3. upsert / transaction
       ▼                                       │
[DataSource / Dio HTTP] ───────────────────────┘
```

1. **The DB is the Single Source of Truth**: The UI reads and watches streams from `AppDatabase` (Drift), **never** directly from raw HTTP responses.
2. **Instant Render**: On app start or screen load, cached data from Drift is emitted immediately. There are zero blocking spinners if data was previously cached.
3. **Background Sync**: The Repository initiates a network call via `DataSource` / `Dio`.
4. **Reactive Push**: When fresh data arrives, it is written to the Drift DB via transactions (`upsertX(...)`). Drift automatically detects table modifications and emits new values down the active stream to the UI.

### Concrete Example: Repository Pattern

Look at `packages/core/lib/data/repositories/dashboard_repository.dart`:

```dart
class DashboardRepository {
  final DataSource _dataSource;
  final AppDatabase _db;

  DashboardRepository({required DataSource dataSource, required AppDatabase db})
      : _dataSource = dataSource,
        _db = db;

  /// 1. Reactive Stream from Drift DB:
  Stream<List<DashboardBannerDto>> watchHeroBanners() async* {
    yield* _db.watchDashboardBanners().map((rows) {
      return rows.map((row) => row.toDto()).toList();
    });
  }

  /// 2. Sync from Network to DB:
  Future<void> refreshDashboard() async {
    try {
      final freshDashboard = await _dataSource.getDashboard();

      await _db.transaction(() async {
        // Upsert fresh data into SQLite
        await _db.upsertDashboardBanners(
          freshDashboard.bannerAds.map((dto) => dto.toCompanion()).toList(),
        );
      });
    } catch (e) {
      // Offline fallback: Error is logged, but UI continues rendering cached DB data
    }
  }
}
```

---

## 6. State Management & Dependency Injection (Riverpod)

We use **Riverpod 2.x** with code generation (`riverpod_annotation`).

### Dependency Layering

```
[DataSourceProvider]  (Dio HTTP Client)
       │
       ▼
[AppDatabaseProvider] (Drift SQLite Instance)
       │
       ▼
[RepositoryProvider]  (@riverpod Future<DashboardRepository>)
       │
       ▼
[FeatureStateProvider] (StreamProvider / AsyncNotifier)
       │
       ▼
[UI Screen / ConsumerWidget]
```

### Exposing Repositories with `@riverpod`

```dart
@riverpod
Future<DashboardRepository> dashboardRepository(DashboardRepositoryRef ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final dataSource = ref.watch(dataSourceProvider);
  return DashboardRepository(dataSource: dataSource, db: db);
}
```

### Consuming State in UI (`ConsumerWidget`)

Always follow standard Riverpod rules when accessing providers:

```dart
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. ref.watch: Use inside build() for reactive updates
    final bannersAsync = ref.watch(heroBannersStreamProvider);

    return bannersAsync.when(
      data: (banners) => BannerCarousel(banners: banners),
      loading: () => const ShimmerPlaceholder(),
      error: (err, stack) => ErrorDisplay(error: err),
    );
  }

  void _onRefresh(WidgetRef ref) {
    // 2. ref.read: Use inside callbacks/event handlers (never in build())
    ref.read(dashboardRepositoryProvider).valueOrNull?.refreshDashboard();
  }
}
```

- **`ref.watch`**: In `build()` methods to trigger rebuilds when state changes.
- **`ref.read`**: In event handlers (`onPressed`, `onTap`) for one-off operations.
- **`ref.listen`**: In `build()` or `initState()` for side effects (navigation, dialogs, error toasts).

---

## 7. Navigation & Routing (GoRouter + AppRoute)

Navigation in Cortex is split into two layers:

### 1. App-Wide Shell Routing (`GoRouter`)
Managed centrally in `packages/testpress/lib/navigation/app_router.dart`:
- Uses `StatefulShellRoute.indexedStack` to host the persistent bottom tab bar (`NavTab`):
  - `/home`: Dashboard & announcements
  - `/study`: Enrolled courses & chapter breakdown
  - `/exams`: Available & completed tests
  - `/ai`: AI study assistant
  - `/store`: Paid courses & store products
  - `/info`: Institutional information
  - `/profile`: User settings & account details
- **Auth Guard**: `AuthRoutes.redirect` validates authentication status before mounting routes. Unauthenticated sessions are redirected to `/onboarding`.
- **Session Expiry**: Handles HTTP 401s gracefully by prompting a re-login dialog rather than unmounting the app abruptly.

### 2. Platform-Neutral Page Pushes (`AppRoute`)
Defined in `packages/core/lib/navigation/app_route.dart`:
- For navigating between sub-screens within a domain (e.g., from chapter list to lesson player):
  ```dart
  Navigator.of(context).push(
    AppRoute(page: LessonDetailScreen(lessonId: 123)),
  );
  ```
- Enforces standardized transition durations (250ms) and curves (`easeOut`) without platform-specific animations.

---

## 8. Code Generation & Build Workflow

Cortex uses code generation for **Drift databases**, **Riverpod providers**, and **JSON serialization**.

### Running Code Generation
When modifying Drift tables (`*table.dart`), Riverpod annotations (`@riverpod`), or models:

```bash
# In packages/core (for DB & core providers)
cd packages/core
dart run build_runner build --delete-conflicting-outputs

# In domain packages (e.g. packages/courses)
cd packages/courses
dart run build_runner build --delete-conflicting-outputs
```

> [!TIP]
> If you are actively modifying models or tables, run `dart run build_runner watch --delete-conflicting-outputs` to recompile automatically on save.

---

## 9. Fresher Cheatsheet: Dos & Don'ts

| Area | What to Avoid | Recommended Practice |
|---|---|---|
| **Package Imports** | Importing `package:courses` from `packages/exams` | Move shared entities to `packages/core` |
| **App Shell** | Importing `package:core` or `package:courses` directly in `app/` | Import only `package:testpress/testpress.dart` in `app/` |
| **UI Widgets** | Using `Scaffold`, `AppBar`, `ElevatedButton`, `Card` | Use `AppShell`, `AppHeader`, `AppButton`, `AppCard` |
| **Platform Checks** | `if (Platform.isIOS) { ... Cupertino style ... }` | Use identical neutral primitives on all platforms |
| **Design Tokens** | `import '../tokens/colors.dart'` or static hex values | Read from context: `Design.of(context).colors.primary` |
| **Data Fetching** | Calling `Dio.get(...)` inside a Widget's `initState` | Read a Riverpod provider backed by a Repository |
| **Offline Data** | Bypassing SQLite and relying solely on network responses | Write network responses to Drift; stream from Drift to UI |
| **Touch Targets** | Adding tiny clickable icons (< 48x48 dp) | Wrap in `AppSemantics.button` with minimum 48dp hit area |
| **Riverpod** | Calling `ref.watch()` inside an `onPresse  d` callback | Use `ref.read()` inside callbacks; `ref.watch()` only in `build()` |
