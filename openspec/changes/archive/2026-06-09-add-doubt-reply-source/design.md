## Context

The helpdesk API now provides a `source` field in doubt replies indicating whether the reply originated from a human or an AI bot. The current system does not persist this data or use it in the UI. We need to store this new attribute and leverage it to conditionally display the reply's author name as "AI Bot Response" and modify the mentor badge to "Bot".

## Goals / Non-Goals

**Goals:**
- Store the `source` field efficiently in the local database.
- Parse the `source` field from the API payload.
- Update the UI to seamlessly distinguish Bot replies from Human replies.

**Non-Goals:**
- Handling custom icons or avatars for the Bot (the current avatar is fine).
- Handling any other new fields from the API.

## Decisions

1. **Drift Database Schema Change:** We will add a `TextColumn` named `source` to `DoubtRepliesTable` (nullable text, or text with default). We chose a simple `TextColumn` because the API provides a string ("Bot"), and this avoids unnecessary enum mappings for a simple UI condition. It is also consistent with other similar string fields in the database like `status` in `DoubtsTable`.
2. **UI Implementation Strategy:** In the presentation layer (likely `DoubtThreadDetail` or the relevant Reply Card widget), we will add a conditional check on `reply.source == 'Bot'`. If true, override `reply.authorName` to "AI Bot Response". If `isMentor` is also true, override the mentor label text from "Mentor" (or whatever the default is) to "Bot".

## Risks / Trade-offs

- **Risk:** The Drift database requires a migration since we are adding a column to an existing table.
  - **Mitigation:** We will ensure `source` is either nullable or has a default value so that existing records do not break upon migration.
- **Trade-off:** Hardcoding the "AI Bot Response" string in the frontend instead of the backend. The API might send localized names eventually.
  - **Mitigation:** The requirement explicitly states "if the source is AI we should show Name as this - AI Bot Response". We'll follow the requirement and can introduce translation keys if needed.
