## Why

The current `CourseDto` and `ChapterDto` models contain nested `List` fields (chapters in courses, lessons in chapters) that are never populated by the flat backend. This creates false expectations for developers, leads to potential data inconsistency between the local cache and objects, and adds unnecessary complexity to the network models.

## What Changes

- **REMOVE**: `List<ChapterDto> chapters` from `CourseDto`. **BREAKING**
- **REMOVE**: `List<LessonDto> lessons` from `ChapterDto`. **BREAKING**
- **UPDATE**: `fromJson` and `toJson` methods in both DTOs to reflect the flat structure.
- **UPDATE**: `MockDataSource` to return flat object structures without attempting to inject nested data.

## Capabilities

### New Capabilities
- `dto-flattening`: Defines the strict flat structure for course and chapter DTOs, ensuring they accurately reflect the backend's "Single Object" API design.

### Modified Capabilities
<!-- None -->

## Impact

- **Affected Files**: `packages/core/lib/data/models/course_dto.dart`, `packages/core/lib/data/models/chapter_dto.dart`, `packages/core/lib/data/sources/mock_data_source.dart`.
- **APIs**: No changes to external backend APIs, but internal DTO construction and consumption will change.
- **Dependencies**: No new dependencies.
