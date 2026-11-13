## 1. DTO & Model Updates

- [x] 1.1 Add `canGenerate` field to `AiChatPolicyDto` in `packages/core/lib/data/models/learnlens_dto.dart`
- [x] 1.2 Add `isStopped` getter to `AiGenerationDto` in `packages/core/lib/data/models/learnlens_dto.dart`
- [x] 1.3 Add `isStopped` property to `GenericAiChatMessage` view model in `packages/core/lib/data/providers/generic_ai_chat_provider.dart`

## 2. State Controller & Lifecycle

- [x] 2.1 Implement `syncCanonicalState()` in `GenericAiChatNotifier` to re-fetch canonical conversation status and messages
- [x] 2.2 Update `_handleTurnResponse` and message mapper to propagate `isStopped` state
- [x] 2.3 Handle access restriction in `GenericAiChatNotifier` when `canGenerate == false` or session creation is denied

## 3. UI & Lifecycle Resumption

- [x] 3.1 Add `WidgetsBindingObserver` to `AiScreen` to trigger `syncCanonicalState()` on `AppLifecycleState.resumed`
- [x] 3.2 Update `AiAssistantCard` to render partial text and subtle "Stopped" label when `isStopped == true`
- [x] 3.3 Add access-restricted card (`_AiRestrictedAccessCard`) with lock icon, title, description, and lock composer in `AiScreen`
- [x] 3.4 Add localized string `aiStoppedResponse` to arb files and regenerate l10n

## 4. Verification & Testing

- [x] 4.1 Add unit tests in `generic_ai_chat_provider_test.dart` for `canGenerate` and `syncCanonicalState()`
- [x] 4.2 Add widget test in `ai_assistant_card_test.dart` verifying non-error stopped rendering
- [x] 4.3 Add widget test in `ai_screen_test.dart` verifying canonical state synchronization on app resume
- [x] 4.4 Run analyzer and test suite to ensure clean verification

## 5. PR Review Feedback Fixes

- [x] 5.1 Remove unused localization key `aiAccessRestrictedBanner` from all 4 ARB files and generated classes
- [x] 5.2 Add `_operationToken` guard and stream state check to `syncCanonicalState()` in `generic_ai_chat_provider.dart`
- [x] 5.3 Wrap `_AiRestrictedAccessCard` with `AppSemantics.container()` in `ai_screen.dart`
- [x] 5.4 Add unit test verifying `syncCanonicalState()` discards update on conversation switch
