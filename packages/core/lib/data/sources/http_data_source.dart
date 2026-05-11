import 'package:dio/dio.dart';
import 'package:core/data/data.dart';
import '../../network/api_endpoints.dart';
import '../../network/network_utils.dart';
import 'curriculum_parser.dart';

/// HTTP data source stub — to be implemented when a real backend is available.
/// All methods throw [UnimplementedError] to surface accidental usage in tests.
///
/// Activate via: flutter run --dart-define=USE_MOCK=false
class HttpDataSource implements DataSource {
  final Dio _dio;

  HttpDataSource({required Dio dio}) : _dio = dio;

  @override
  Future<PaginatedResponseDto<CourseDto>> getCourses({
    int page = 1,
    int pageSize = 10,
    String? search,
    dynamic tags,
  }) async {
    return performNetworkRequest(
      _dio.get(
        ApiEndpoints.courseList,
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          if (search != null && search.isNotEmpty) 'q': search,
          if (tags != null) 'tags': tags,
        },
      ),
      fromJson: (json) => PaginatedResponseDto<CourseDto>.fromJson(
        json,
        (item) => CourseDto.fromJson(item),
      ),
    );
  }

  @override
  Future<CourseDto> getCourseDetail(String courseId) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.courseDetail(courseId)),
      fromJson: CourseDto.fromJson,
    );
  }

  @override
  Future<List<ChapterDto>> getChapters(String courseId, {String? parentId}) async {
    return performNetworkRequest(
      _dio.get(
        ApiEndpoints.courseChapters(courseId),
        queryParameters: {
          'parent_id': parentId ?? 'null',
        },
      ),
      fromJson: (data) {
        final results = data['results'] as Map<String, dynamic>?;
        final chaptersList = results?['chapters'] as List<dynamic>?;

        return chaptersList
                ?.map((e) => ChapterDto.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
      },
    );
  }

  @override
  Future<CourseCurriculumDto> getCourseContents(String courseId) async {
    final List<LessonDto> allLessons = [];
    final List<ChapterDto> allChapters = [];
    String? nextUrl = ApiEndpoints.courseContents(courseId);

    // Follow pagination links to ensure a complete blueprint of the course.
    // This prevents the "5 vs 2" lesson count inconsistency.
    while (nextUrl != null) {
      final responseData = await performNetworkRequest(
        _dio.get(nextUrl),
        fromJson: (data) => data,
      );

      final curriculum = CurriculumParser.parseFullCurriculum(responseData);
      allLessons.addAll(curriculum.lessons);
      allChapters.addAll(curriculum.chapters);

      // Extract next page URL, handling both absolute and relative paths.
      final next = responseData['next'] as String?;
      if (next != null && !next.startsWith('http')) {
        nextUrl = '${AppConfig.apiBaseUrl}$next';
      } else {
        nextUrl = next;
      }
    }
    
    return CourseCurriculumDto(
      lessons: allLessons,
      chapters: allChapters,
    );
  }

  @override
  Future<CourseCurriculumDto> getRunningContents(String courseId) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.runningContents(courseId)),
      fromJson: (data) => CurriculumParser.parseFullCurriculum(data),
    );
  }

  @override
  Future<CourseCurriculumDto> getUpcomingContents(String courseId) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.upcomingContents(courseId)),
      fromJson: (data) => CurriculumParser.parseFullCurriculum(data),
    );
  }

  @override
  Future<CourseCurriculumDto> getContentAttempts(String courseId) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.contentAttempts(courseId)),
      fromJson: (data) => CurriculumParser.parseFullCurriculum(data),
    );
  }


  @override
  Future<List<LessonDto>> getLessons(String chapterId) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.chapterContents(chapterId)), 
      fromJson: (data) => CurriculumParser.mapLessons(data, chapterId: chapterId),
    );
  }

  @override
  Future<LessonDto> getLessonDetail(String lessonId) async {
    try {
      return await performNetworkRequest(
        _dio.get(ApiEndpoints.lessonDetail(lessonId)),
        fromJson: LessonDto.fromJson,
      );
    } on ApiException catch (e) {
      final data = e.data;
      if (data is Map<String, dynamic> && data['error_code'] == 'scheduled') {
        return LessonDto.fromJson(data);
      }
      rethrow;
    }
  }

  @override
  Future<List<LiveClassDto>> getLiveClasses() => throw UnimplementedError(
    'HttpDataSource.getLiveClasses is not yet implemented.',
  );

  @override
  Future<List<ForumThreadDto>> getForumThreads(String courseId) =>
      Future.value(mockForumThreads(courseId));

  @override
  Future<List<ForumCategoryDto>> getForumCategories(String courseId) =>
      Future.value(mockForumCategories);

  @override
  Future<List<ForumCommentDto>> getForumComments(String threadId) =>
      Future.value(mockForumComments(threadId));

  @override
  Future<List<UserProgressDto>> getUserProgress(String userId) =>
      throw UnimplementedError(
        'HttpDataSource.getUserProgress is not yet implemented.',
      );

  @override
  Future<List<ExploreBannerDto>> getExploreBanners() async => mockExploreBanners;

  @override
  Future<List<StudyTipDto>> getStudyTips() async => mockStudyTips;

  @override
  Future<List<ShortLessonDto>> getShortLessons() async => mockShortLessons;

  @override
  Future<List<DiscoveryCourseDto>> getDiscoveryCourses() async =>
      mockDiscoveryCourses;

  @override
  Future<List<PopularTestDto>> getPopularTests() async => mockPopularTests;

  @override
  Future<List<DashboardBannerDto>> getDashboardBanners() async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.bannerAds),
      fromJson: (data) {
        final results = data['results'] as List<dynamic>?;
        return results
                ?.map((e) => DashboardBannerDto.fromJson(e as Map<String, dynamic>))
                .whereType<DashboardBannerDto>()
                .toList() ??
            [];
      },
    );
  }

  @override
  Future<List<LearnerDto>> getLearners() async {
    return performNetworkRequest(
      // Top 10 learners for this week
      _dio.get(ApiEndpoints.leaderboard, queryParameters: {
        'timeline': 'this_week',
        'limit': 10,
      }),
      fromJson: (data) {
        final results = data['results'] as List<dynamic>?;
        if (results == null) return [];
        final learners = <LearnerDto>[];
        for (var i = 0; i < results.length; i++) {
          learners.add(LearnerDto.fromJson(results[i] as Map<String, dynamic>, i + 1));
        }
        return learners;
      },
    );
  }

  @override
  Future<DashboardContentsDto> getWhatsNewFeed(DashboardSectionType sectionType) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.whatsNewFeed),
      fromJson: (data) => DashboardContentsDto.fromJson(
        data,
        sectionType: sectionType,
      ),
    );
  }

  @override
  Future<DashboardContentsDto> getResumeLearningFeed(DashboardSectionType sectionType) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.resumeLearning),
      fromJson: (data) => DashboardContentsDto.fromJson(
        data,
        sectionType: sectionType,
      ),
    );
  }

  @override
  Future<DashboardContentsDto> getRecentlyCompletedFeed(DashboardSectionType sectionType) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.recentlyCompleted),
      fromJson: (data) => DashboardContentsDto.fromJson(
        data,
        sectionType: sectionType,
      ),
    );
  }

  @override
  Future<UserDto> getProfile() async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.userProfile),
      fromJson: UserDto.fromJson,
    );
  }

  @override
  Future<UserDto> updateProfile(Map<String, dynamic> data) async {
    final dynamic body;
    // If the data contains a 'photo' key with a file path, we use FormData for multipart upload
    if (data.containsKey('photo') && data['photo'] is String) {
      final map = Map<String, dynamic>.from(data);
      map['photo'] = await MultipartFile.fromFile(
        map['photo'] as String,
        filename: 'profile_image.jpg',
      );
      body = FormData.fromMap(map);
    } else {
      body = data;
    }

    return performNetworkRequest(
      _dio.patch(ApiEndpoints.userProfile, data: body),
      fromJson: UserDto.fromJson,
    );
  }

  @override
  Future<List<DoubtDto>> getDoubts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockDoubts;
  }

  @override
  Future<List<DoubtReplyDto>> getDoubtReplies(String doubtId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return getMockDoubtReplies(doubtId);
  }

  @override
  Future<void> markLessonCompleted(String lessonId) async {
    await performNetworkRequest(
      _dio.post(ApiEndpoints.markCompleted(lessonId)),
      fromJson: (data) => null,
    );
  }

  // --- Exam Attendance ---

  @override
  Future<ExamDto> getExam(String slug) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.examDetail(slug)),
      fromJson: ExamDto.fromJson,
    );
  }

  @override
  Future<List<AttemptDto>> getAttempts(String attemptsUrl) async {
    return performNetworkRequest(
      _dio.get(attemptsUrl),
      fromJson: (json) => PaginatedResponseDto<AttemptDto>.fromJson(
        json,
        AttemptDto.fromJson,
      ),
    ).then((response) => response.results);
  }

  @override
  Future<AttemptDto> createAttempt(String attemptsUrl) async {
    return performNetworkRequest(
      _dio.post(attemptsUrl),
      fromJson: AttemptDto.fromJson,
    );
  }

  @override
  Future<AttemptDto> createContentAttempt(String contentAttemptsUrl) async {
    return performNetworkRequest(
      _dio.post(contentAttemptsUrl),
      fromJson: AttemptDto.fromJson,
    );
  }

  @override
  Future<AttemptDto> startAttempt(String startUrl) async {
    return performNetworkRequest(
      _dio.post(startUrl),
      fromJson: AttemptDto.fromJson,
    );
  }

  @override
  Future<List<QuestionDto>> getQuestions(String questionsUrl) async {
    if (questionsUrl.isEmpty) return [];

    final List<QuestionDto> allQuestions = [];
    String? nextUrl = questionsUrl;
    int pageSafetyBreak = 0;
    String? lastUrl;

    while (nextUrl != null && nextUrl.isNotEmpty && pageSafetyBreak < 50) {
      if (nextUrl == lastUrl) break; // Prevent infinite loops on same URL
      lastUrl = nextUrl;
      pageSafetyBreak++;
      
      final dynamic data = await performDynamicNetworkRequest(
        _dio.get(nextUrl),
        fromJson: (json) => json,
      );

      final List<dynamic> list;
      if (data is List) {
        list = data;
        nextUrl = null;
      } else if (data is Map && data['results'] is List) {
        list = data['results'] as List<dynamic>;
        nextUrl = data['next'] as String?;
      } else {
        list = [];
        nextUrl = null;
      }

      allQuestions.addAll(
        list.map((e) => QuestionDto.fromJson(e as Map<String, dynamic>)),
      );
    }

    // Sort questions by their order field to match the exact sequence on web
    allQuestions.sort((a, b) => a.order.compareTo(b.order));

    return allQuestions;
  }

  @override
  Future<void> submitAnswer(String answerUrl, AnswerDto answer) async {
    await performNetworkRequest(
      _dio.put(answerUrl, data: answer.toJson()),
      fromJson: (data) => null,
    );
  }

  @override
  Future<AttemptDto> sendHeartbeat(String heartbeatUrl) async {
    return performNetworkRequest(
      _dio.put(heartbeatUrl),
      fromJson: AttemptDto.fromJson,
    );
  }

  @override
  Future<AttemptDto> endExam(String endUrl) async {
    if (endUrl.isEmpty) {
      throw Exception('Unable to end exam: End URL is missing.');
    }

    return performNetworkRequest(
      _dio.put(endUrl),
      fromJson: AttemptDto.fromJson,
    );
  }

  @override
  Future<SectionDto> startSection(String startUrl) async {
    if (startUrl.isEmpty) {
      throw Exception('Unable to start section: Start URL is missing.');
    }

    return performNetworkRequest(
      _dio.put(startUrl),
      fromJson: SectionDto.fromJson,
    );
  }

  @override
  Future<SectionDto> endSection(String endUrl) async {
    if (endUrl.isEmpty) {
      throw Exception('Unable to end section: End URL is missing.');
    }

    return performNetworkRequest(
      _dio.put(endUrl),
      fromJson: SectionDto.fromJson,
    );
  }

  @override
  Future<void> downloadFile({
    required String url,
    required String savePath,
    void Function(int count, int total)? onReceiveProgress,
    dynamic cancelToken,
    bool requireAuth = true,
  }) async {
    await _dio.download(
      url,
      savePath,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken as CancelToken?,
      options: Options(
        extra: {'requireAuth': requireAuth},
      ),
    );
  }
}
