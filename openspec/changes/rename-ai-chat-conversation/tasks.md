## 1. Network and Data Layer

- [x] 1.1 Add `renameConversation` method to `LearnLensNetworkClient` invoking `PATCH /chats/{chat_id}/`
- [x] 1.2 Expose `renameConversation` in `LearnLensRepository`
- [x] 1.3 Add `renameConversation` to `GenericAiChat` provider with short-circuiting for unchanged titles
- [x] 1.4 Route rename requests via route navigation parameter instead of global state

## 2. History Screen Inline Renaming

- [x] 2.1 Add Rename action to conversation 3-dot options menu in `AiChatHistoryScreen`
- [x] 2.2 Support `initialRenamingChatId` and auto-renaming on history drawer opening
- [x] 2.3 Implement inline `EditableText` with context design tokens (`design.colors.primary`)
- [x] 2.4 Add accessible semantics (`Semantics(textField: true, label: ...)`) and `ExcludeSemantics` on menu labels
- [x] 2.5 Handle blur and touch interactions safely without trapped retry loops

## 3. Header Action Integration & Route Handling

- [x] 3.1 Route header "Rename" action to open history drawer in rename mode for active conversation
- [x] 3.2 Support `/ai/history` route extra parameter in `AiRoutes`

## 4. Localization and Verification

- [x] 4.1 Verify localized strings in `app_en.arb`, `app_ar.arb`, `app_ml.arb`, `app_ta.arb`
- [x] 4.2 Update unit and widget tests across repository, provider, header, and history screen
