## 1. UI Infrastructure

- [x] 1.1 Update `AppHeader` to accept a `backgroundColor` parameter
- [x] 1.2 Update `AskDoubtFormScreen` to accept an `isAskAi` flag
- [x] 1.3 Modify `AskDoubtFormScreen` logic to use `DoubtQueryType.ai` when `isAskAi` is true
- [x] 1.4 Update the doubt form context badge to show "ASKING AI" and sparkles icon when in AI mode

## 2. Navigation

- [x] 2.1 Add `NavTab.ai` to `AppRouter` configuration
- [x] 2.2 Create `AiRoutes` module and configure route paths for `/ai`
- [x] 2.3 Ensure navigation allows `AskDoubtFormScreen` to be pushed with `isAskAi` parameter
