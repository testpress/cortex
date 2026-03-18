# Tasks: LMS Ask Doubt (AI Assistant)

## 1. Setup and Navigation

- [x] 1.1 Add `AskDoubtScreen` scaffold in `packages/ai_assistant/lib/screens/`
- [x] 1.2 Implement navigation route in `packages/testpress` (if required) or direct push in `AIAssistantPage`
- [x] 1.3 Update `AIQuickActionCard` in `AIAssistantPage` to trigger navigation to `AskDoubtScreen`

## 2. UI Components Implementation

- [x] 2.1 Implement `DoubtHeader`: Minimal header with Back button and Menu icon (as per reference)
- [x] 2.2 Implement `DoubtEmptyState`: "What can I help with?" title and `QuickSuggestionGrid` (2x2)
- [x] 2.3 Implement `MessageBubble`: Customizable widget for Student and AI roles with premium styling
- [x] 2.4 Implement `DoubtInputBar`: Full-width input with attachment (+) button and integrated Send (Up arrow) button

## 3. State and Logic

- [x] 3.1 Create `DoubtSessionProvider` (Riverpod) to manage the list of messages and "Thinking" state
- [x] 3.2 Implement mock response logic: Simulate AI delayed response when a message is sent
- [x] 3.3 Add mock attachment placeholder logic that injects an image-backed user message without full picker integration
- [x] 3.4 Implement auto-scroll behavior for the message list

## 4. Polishing and Verification

- [x] 4.1 Apply premium design tokens (gradients, custom shadows) to match the "AI Hub" aesthetic
- [x] 4.2 Verify Dark Mode compatibility and accessibility (AppSemantics)
- [x] 4.3 Add micro-animations for message entry and a localized loading indicator for thinking state
- [x] 4.4 Replace remaining hardcoded Ask Doubt UI strings and color literals with shared localizations and design tokens
- [x] 4.5 Align the Ask Doubt OpenSpec artifacts with the current floating light-surface implementation
- [x] 4.6 Split oversized Ask Doubt screen concerns into dedicated widgets so the screen stays focused on orchestration
- [x] 4.7 Keep the floating composer visible above the software keyboard on device
- [x] 4.8 Fix session menu contrast so all actions remain readable in dark mode
- [x] 4.9 Make repeated input taps reliably reopen the keyboard and tighten the composer gap above it
- [x] 4.10 Keep empty-state suggestion cards visually consistent under larger text scales and refine the keyboard lift spacing
- [x] 4.11 Make keyboard reopening robust even when the editable field consumes tap gestures
- [x] 4.12 Keep the composer visible in landscape when the keyboard occupies most of the viewport
- [x] 4.13 Base keyboard avoidance on the actual composer size so portrait and landscape use the same dynamic behavior
- [x] 4.14 Keep Ask Doubt as a dedicated pushed route within the existing shell while tuning its local inset handling
- [x] 4.15 Remove the remaining portrait keyboard gap so the composer sits nearly flush above the keyboard
- [x] 4.16 Make keyboard-visible spacing orientation-aware so portrait and landscape can use different gap rules
- [x] 4.17 Fine-tune portrait inset handling without changing landscape spacing
- [x] 4.18 Tighten the portrait-only keyboard gap further without changing landscape spacing
- [x] 4.19 Tighten the portrait-only keyboard gap again without changing landscape spacing
- [x] 4.20 Center the empty-state suggestion card labels within their tiles
- [x] 4.21 Remove the surrounding bubble surface from AI responses while keeping user messages styled as bubbles
- [x] 4.22 Make the history menu reflect pinned state and keep pinned chats above newly created unpinned chats
- [x] 4.23 Soften the student message bubble from near-black to a neutral grey surface
