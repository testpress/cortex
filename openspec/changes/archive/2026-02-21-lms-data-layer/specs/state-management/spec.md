## ADDED Requirements

### Requirement: State management uses Riverpod with code generation
The system SHALL use `flutter_riverpod` with `riverpod_annotation` code generation for all provider definitions. All data providers SHALL be defined using `@riverpod` annotations in the `packages/data/lib/providers/` directory.

#### Scenario: Provider correctly exposes AsyncValue
- **WHEN** a `@riverpod` provider function returns a `Stream<T>`
- **THEN** the generated provider wraps it in `AsyncValue<T>` accessible from any `ConsumerWidget`

#### Scenario: Repository provider is available globally
- **WHEN** the app starts and `ProviderScope` wraps the root widget
- **THEN** any widget in the tree can access `ref.watch(courseListProvider)` without further setup

---

### Requirement: ProviderScope wraps app root
The system SHALL add `ProviderScope` as the outermost widget in `app/lib/main.dart`, wrapping `LocalizationProvider` and `DesignProvider`.

#### Scenario: ProviderScope enables Riverpod access
- **WHEN** the app launches
- **THEN** all widgets below the root can call `ref.watch(...)` and `ref.read(...)` on any defined provider

---

### Requirement: AsyncValue states are handled in all consumer widgets
Consumer widgets subscribing to data providers SHALL handle all three `AsyncValue` states: loading, error, and data.

#### Scenario: Loading skeleton shown before data arrives
- **WHEN** `asyncValue.isLoading` is true
- **THEN** the widget displays a loading placeholder (skeleton or spinner)

#### Scenario: Error message shown with retry
- **WHEN** `asyncValue.hasError` is true
- **THEN** the widget displays a descriptive error message and a retry button that calls `ref.refresh(provider)`
