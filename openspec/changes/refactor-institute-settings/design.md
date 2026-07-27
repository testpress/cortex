## Context

The `InstituteSettings.current` static singleton pattern in the core data config led to bugs during hot reload and when settings are updated remotely, because UI widgets (StatelessWidgets) and dependencies reading it do not receive reactivity updates. In modern Riverpod architectures, this pattern breaks unidirectional data flow and reactive updates.

## Goals / Non-Goals

**Goals:**
- Completely remove the `static InstituteSettings? current` variable.
- Refactor backend and UI components to depend on `instituteSettingsProvider`.
- Ensure hot reloads maintain the settings state properly and correctly rebuild the UI.

**Non-Goals:**
- Refactoring the entire `AppConfig` or other legacy globals right now; focusing only on `InstituteSettings`.

## Decisions

1. **Use `ref.watch` in UI**: Convert `StatelessWidget` to `ConsumerWidget` where `InstituteSettings.current` was used, and watch `instituteSettingsProvider`.
2. **Pass settings as parameters to isolated classes**: `PaymentGatewayFactory` does not have access to a `ref` internally without tight coupling. Update `startPayment` to accept the settings dynamically so `PaymentProcessingScreen` can provide it via Riverpod.
3. **Initialize Provider explicitly**: `instituteSettingsProvider` will start with `null` state, and the existing `initialization_provider.dart` will fetch and populate the provider on startup.

## Risks / Trade-offs

- **Risk**: Missed a dependency on `InstituteSettings.current`.
  - **Mitigation**: Use `grep` to systematically search the entire project and confirm all instances are removed.
