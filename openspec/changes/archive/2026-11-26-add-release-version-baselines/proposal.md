## Why

Migrated apps can have store versions beyond the values in Cortex. Release operators need to seed those values without editing the database.

## What Changes

- Add optional app version, Android version code, and iOS build number baselines to the release dispatch and bump request.
- Keep existing bump behavior when baselines are omitted.

## Capabilities

### New Capabilities

- `release-version-baselines`: Allocate release versions above supplied store baselines.

## Impact

Cortex release dispatch and the Testpress Cortex version endpoint.
