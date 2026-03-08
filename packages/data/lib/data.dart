/// Barrel export for the data package.
library data;

// Config
export 'config/app_config.dart';

// DTOs
export 'models/course_dto.dart';
export 'models/chapter_dto.dart';
export 'models/lesson_dto.dart';
export 'models/live_class_dto.dart';
export 'models/assignment_dto.dart';
export 'models/test_dto.dart';
export 'models/study_momentum_dto.dart';
export 'models/forum_thread_dto.dart';
export 'models/user_progress_dto.dart';
export 'models/user_dto.dart';
export 'models/dashboard_banner_dto.dart';
export 'models/learner_dto.dart';
export 'models/quick_shortcut_dto.dart';
export 'models/recent_activity_dto.dart';

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
export 'providers/enrollment_provider.dart';
export 'providers/recent_activity_provider.dart';
export 'providers/study_momentum_provider.dart';
export 'providers/auth_provider.dart';
export 'providers/initialization_provider.dart';
export 'providers/lesson_providers.dart';
