## 1. Data Layer (Drift)

- [x] 1.1 Add `source` `TextColumn` (nullable) to `DoubtRepliesTable` in `doubts_table.dart`.
- [x] 1.2 Run Drift build runner to generate the updated database code.

## 2. Network & Repository Layer

- [x] 2.1 Update the API response parsing logic (e.g., `DoubtReply` model / fromJson or the Helpdesk network parser) to extract the `"source"` field.
- [x] 2.2 Ensure the parsed `source` string is correctly passed to the Drift companion when inserting/updating local records in the Repository.

## 3. UI Layer (Doubt Thread Detail)

- [x] 3.1 Locate the doubt reply card widget (usually in the `doubt-thread-detail` or `doubts-ui` feature).
- [x] 3.2 Update author name logic: If `reply.source == 'Bot'`, display "AI Bot Response".
- [x] 3.3 Update mentor badge logic: If `reply.source == 'Bot'` AND `reply.isMentor == true`, display "Bot" instead of the standard "Mentor" label.
- [x] 3.4 Test the UI rendering with a mocked or real Bot response to ensure the label and name update correctly.
