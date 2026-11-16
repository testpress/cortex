## Why

Learners need reliable and seamless access to AI Chat workspace navigation, accurate representation of conversation lifecycle states (including stopped responses), and automatic synchronization of conversation state when returning from the background. Currently, student-level access gating needs to be verified against the learner's policy, stopped assistant generations require distinctive non-error presentation, and app backgrounding requires state re-synchronization with LearnLens.

## What Changes

- Gate AI Chat tab access and workspace availability based on learner eligibility (`can_generate` policy).
- Implement canonical conversation state synchronization in the chat controller and screen when the app transitions to `AppLifecycleState.resumed`.
- Support `stopped` status in `AiGenerationDto`, message view models, and `AiAssistantCard`, rendering partial retained text with a "Stopped" indicator rather than failure banners.
- Parse `can_generate` in `AiChatPolicyDto`.
- Update navigation and screen handling to gracefully handle restricted student access states.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `ai-tab`: Add learner-level access eligibility gating to navigation tab computation and screen access.
- `generic-ai-chat-controller`: Add canonical state synchronization (`syncCanonicalState`) on resumption and parse `can_generate` policy.
- `generic-ai-chat-screen`: Add application lifecycle observation (`AppLifecycleState.resumed`) and stopped generation rendering in message cards.

## Impact

- Affected models: `packages/core/lib/data/models/learnlens_dto.dart` (`AiChatPolicyDto`, `AiGenerationDto`).
- Affected providers: `packages/core/lib/data/providers/generic_ai_chat_provider.dart`.
- Affected UI widgets and screens: `packages/core/lib/screens/ai_screen.dart`, `packages/core/lib/widgets/ai_assistant_card.dart`, `packages/testpress/lib/navigation/app_router.dart`.
- Affected tests: `packages/core/test/data/providers/generic_ai_chat_provider_test.dart`, `packages/core/test/screens/ai_screen_test.dart`, `packages/core/test/widgets/ai_assistant_card_test.dart`.
