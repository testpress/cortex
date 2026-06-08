/// Unified Foundation for the Cortex App.
/// This barrel file re-exports all shared models, database infrastructure,
/// auth providers, and repositories.
library;

// Config
export 'config/app_config.dart';
export 'config/sdk_initialization.dart';

// DTOs
export 'models/course_dto.dart';
export 'models/chapter_dto.dart';
export 'models/course_curriculum_dto.dart';
export 'models/lesson_dto.dart';
export 'models/live_class_dto.dart';
export 'models/forum_thread_dto.dart';
export 'models/user_progress_dto.dart';
export 'models/user_dto.dart';
export 'models/settings_models.dart';
export 'models/study_momentum_dto.dart';
export 'models/explore_models.dart';
export 'models/paginated_response_dto.dart';
export 'models/client_config.dart';
export 'models/dashboard_dto.dart';
export 'models/exam_dto.dart';
export 'models/attempt_dto.dart';
export 'models/review_models.dart';
export 'models/section_dto.dart';
export 'models/question_dto.dart';
export 'models/answer_dto.dart';
export 'models/download_item.dart';
export 'models/doubt_dto.dart';
export 'models/bookmark_dto.dart';
export 'models/login_activity_dto.dart';
export 'models/post_dto.dart';

// Database
export 'db/tables/dashboard_tables.dart';
export 'db/tables/leaderboard_tables.dart';
export 'db/tables/subject_analytics_table.dart';
export 'db/app_database.dart';
export 'repositories/dashboard_repository.dart';
export 'repositories/downloads_repository.dart';
export 'repositories/leaderboard_repository.dart';
export 'db/database_provider.dart';

// Auth
export 'auth/auth_provider.dart';
export 'auth/types/auth_exception.dart';

// Sources
export 'sources/data_source.dart';
export 'sources/mock_data_source.dart';
export 'sources/http_data_source.dart';
export 'sources/data_source_provider.dart';
export 'sources/study_momentum_provider.dart';
export 'sources/client_config_provider.dart';

// Network Endpoints
export '../network/api_endpoints.dart';

// Repositories
export 'repositories/user_progress_repository.dart';
export 'repositories/bookmark_repository.dart';
export 'repositories/repository_providers.dart';
export 'providers/bookmark_provider.dart';
export 'providers/announcements_provider.dart';

//service
export 'services/downloads_service.dart';
export 'services/pagination_service.dart';

// Infra & Mocks
export 'sources/mock_data.dart';
