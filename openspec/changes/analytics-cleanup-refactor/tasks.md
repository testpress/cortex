## 1. DTO & Table Changes (data layer)

- [x] 1.1 Rename `leaf` → `isLeaf` in SubjectAnalyticsDto
- [x] 1.2 Rename `leaf` → `isLeaf` in SubjectAnalyticsTable
- [x] 1.3 Rename `parent` → `parentId` in SubjectAnalyticsDto and Table
- [x] 1.4 Remove `analyticsUrl` from SubjectAnalyticsTable

## 2. Data Source Updates (data layer)

- [x] 2.1 MockDataSource: Update field references
- [x] 2.2 HttpDataSource: Remove URL parsing, construct from ID
- [x] 2.3 SubjectAnalyticsRepository: Pass constructed URLs

## 3. UI & Screen Updates (presentation layer)

- [x] 3.1 Update all widget/screen references to renamed fields
- [x] 3.2 Clarify screen labels and headers
- [x] 3.3 Standardize text sizing to `AppText.title` on Subject Analytics Screen

## 4. Testing & Verification

- [x] 4.1 Compile without errors
- [x] 4.2 Schema update verification (bump schemaVersion to 29)
- [x] 4.3 Verify analytics screens render correctly in emulator
