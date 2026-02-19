/// Barrel export for the data package.
library data;

// Config
export 'config/app_config.dart';

// DTOs
export 'models/course_dto.dart';
export 'models/chapter_dto.dart';
export 'models/lesson_dto.dart';
export 'models/live_class_dto.dart';
export 'models/forum_thread_dto.dart';
export 'models/user_progress_dto.dart';

// Database
export 'db/app_database.dart';

// Sources
export 'sources/data_source.dart';
export 'sources/mock_data_source.dart';
export 'sources/http_data_source.dart';

// Repositories
export 'repositories/course_repository.dart';
export 'repositories/user_repository.dart';
export 'repositories/forum_repository.dart';
export 'repositories/exam_repository.dart';

// Providers
export 'providers/database_provider.dart';
export 'providers/data_source_provider.dart';
export 'providers/repository_providers.dart';
export 'providers/course_list_provider.dart';
