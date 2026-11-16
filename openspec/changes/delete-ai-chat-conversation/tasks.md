## 1. Network & Repository Integration

- [x] 1.1 Add `deleteConversation` to `LearnLensNetworkClient` in `packages/core/lib/network/learnlens_network_client.dart`
- [x] 1.2 Expose `deleteConversation` in `LearnLensRepository` in `packages/core/lib/data/repositories/learnlens_repository.dart`

## 2. State Controller Logic

- [x] 2.1 Add `deleteConversation` method to `GenericAiChatNotifier` in `packages/core/lib/data/providers/generic_ai_chat_provider.dart`
- [x] 2.2 Reconcile in-memory state: filter conversation from `state.conversations` and reset active chat (`startNewChat()`) if the deleted conversation is active
- [x] 2.3 Prevent deletion while generation is active and handle HTTP 409 conflicts gracefully

## 3. UI & Localization

- [x] 3.1 Add localized strings for deletion prompt and notifications across ARB files and regenerate L10n
- [x] 3.2 Add accessible delete action button (`LucideIcons.trash2`) to conversation items in `packages/core/lib/screens/ai_chat_history_screen.dart`
- [x] 3.3 Implement confirmation dialog prior to dispatching deletion and surface feedback toast

## 4. Testing & Verification

- [x] 4.1 Add unit tests in `learnlens_network_client_test.dart` verifying `DELETE $baseUrl/chats/{chatId}/` sends correct headers and returns 204
- [x] 4.2 Add unit tests in `generic_ai_chat_provider_test.dart` for deleting active and inactive conversations, list updates, and 409 handling
- [x] 4.3 Add widget tests in `ai_chat_history_screen_test.dart` verifying delete button visibility, confirmation dialog interaction, and drawer item removal
- [x] 4.4 Run code analyzer and test suite to ensure clean verification
