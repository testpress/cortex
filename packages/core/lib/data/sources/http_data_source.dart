import 'dart:io';
import 'package:dio/dio.dart';
import 'package:core/data/data.dart';
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
          'tags': ?tags,
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
  Future<List<ChapterDto>> getChapters(
    String courseId, {
    String? parentId,
  }) async {
    return performNetworkRequest(
      _dio.get(
        ApiEndpoints.courseChapters(courseId),
        queryParameters: {'parent_id': parentId ?? 'null'},
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
  Stream<CourseCurriculumDto> getCourseContents(
    String courseId, {
    String? chapterId,
    String? type,
  }) async* {
    final String initialUrl = ApiEndpoints.courseContents(courseId);
    String? nextUrl = initialUrl;
    final Map<String, dynamic> queryParameters = {};
    if (chapterId != null) queryParameters['chapter'] = chapterId;
    if (type != null) queryParameters['type'] = type;

    while (nextUrl != null) {
      final responseData = await performNetworkRequest(
        _dio.get(
          nextUrl,
          queryParameters: nextUrl == initialUrl ? queryParameters : null,
        ),
        fromJson: (data) => data,
      );

      final curriculum = CurriculumParser.parseFullCurriculum(responseData);
      yield curriculum;

      // Extract next page URL, handling both absolute and relative paths.
      final next = responseData['next'] as String?;
      if (next != null && !next.startsWith('http')) {
        nextUrl = '${AppConfig.apiBaseUrl}$next';
      } else {
        nextUrl = next;
      }
    }
  }

  @override
  Future<CourseCurriculumDto> getRunningContents(
    String courseId, {
    String? chapterId,
  }) async {
    return _fetchFullCurriculum(
      ApiEndpoints.runningContents(courseId),
      queryParameters: {'chapter': chapterId},
    );
  }

  @override
  Future<CourseCurriculumDto> getUpcomingContents(
    String courseId, {
    String? chapterId,
  }) async {
    return _fetchFullCurriculum(
      ApiEndpoints.upcomingContents(courseId),
      queryParameters: {'chapter': chapterId},
    );
  }

  @override
  Future<CourseCurriculumDto> getContentAttempts(
    String courseId, {
    String? chapterId,
  }) async {
    return _fetchFullCurriculum(
      ApiEndpoints.contentAttempts(courseId),
      queryParameters: {'chapter': chapterId},
    );
  }

  /// Helper to fetch and merge all pages of a curriculum endpoint into a single DTO.
  Future<CourseCurriculumDto> _fetchFullCurriculum(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final List<LessonDto> lessons = [];
    final List<ChapterDto> chapters = [];
    String? nextUrl = url;

    while (nextUrl != null) {
      final responseData = await performNetworkRequest(
        _dio.get(
          nextUrl,
          queryParameters: nextUrl == url ? queryParameters : null,
        ),
        fromJson: (data) => data,
      );

      final curriculum = CurriculumParser.parseFullCurriculum(responseData);
      lessons.addAll(curriculum.lessons);
      chapters.addAll(curriculum.chapters);

      final next = responseData['next'] as String?;
      if (next != null && !next.startsWith('http')) {
        nextUrl = '${AppConfig.apiBaseUrl}$next';
      } else {
        nextUrl = next;
      }
    }

    return CourseCurriculumDto(lessons: lessons, chapters: chapters);
  }

  @override
  Future<List<LessonDto>> getLessons(String chapterId) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.chapterContents(chapterId)),
      fromJson: (data) =>
          CurriculumParser.mapLessons(data, chapterId: chapterId),
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
  Future<List<ForumCategoryDto>> getForumCategories() async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.forumCategories),
      fromJson: (data) {
        final results = data['results'] as List<dynamic>? ?? [];
        return results
            .map((e) => ForumCategoryDto.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<PaginatedResponseDto<ForumThreadDto>> getForumThreads({
    int page = 1,
    int? categoryId,
    String? searchQuery,
  }) async {
    return performNetworkRequest(
      _dio.get(
        ApiEndpoints.forumThreads,
        queryParameters: {
          'page': page,
          'category': ?categoryId,
          if (searchQuery != null && searchQuery.isNotEmpty)
            'search': searchQuery,
        },
      ),
      fromJson: (json) => PaginatedResponseDto<ForumThreadDto>.fromJson(
        json,
        (item) => ForumThreadDto.fromJson(item),
      ),
    );
  }

  @override
  Future<PaginatedResponseDto<ForumCommentDto>> getForumComments({
    required int threadId,
    int page = 1,
  }) async {
    return performNetworkRequest(
      _dio.get(
        ApiEndpoints.forumComments(threadId),
        queryParameters: {'page': page, 'o': '-created'},
      ),
      fromJson: (json) => PaginatedResponseDto<ForumCommentDto>.fromJson(
        json,
        (item) => ForumCommentDto.fromJson(item),
      ),
    );
  }

  @override
  Future<ForumCommentDto> postForumComment({
    required int threadId,
    required String content,
  }) async {
    return performNetworkRequest(
      _dio.post(
        ApiEndpoints.forumComments(threadId),
        data: {'comment': content},
      ),
      fromJson: (json) => ForumCommentDto.fromJson(json),
    );
  }

  @override
  Future<String> uploadImage(File file) async {
    final fileName = file.path.split('/').last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    return performNetworkRequest(
      _dio.post(ApiEndpoints.imageUpload, data: formData),
      fromJson: (json) => json['url'] as String,
    );
  }

  @override
  Future<ForumThreadDto> postForumThread({
    required String title,
    required String contentHtml,
    required String categorySlug,
    String? courseId,
  }) async {
    return performNetworkRequest(
      _dio.post(
        ApiEndpoints.forumThreads,
        data: {
          'title': title,
          'content_html': contentHtml,
          'category': categorySlug,
          'course_id': ?courseId,
        },
      ),
      fromJson: (json) => ForumThreadDto.fromJson(json),
    );
  }

  @override
  Future<List<UserProgressDto>> getUserProgress(String userId) =>
      throw UnimplementedError(
        'HttpDataSource.getUserProgress is not yet implemented.',
      );

  @override
  Future<List<ExploreBannerDto>> getExploreBanners() async =>
      mockExploreBanners;

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
                ?.map(
                  (e) => DashboardBannerDto.fromJson(e as Map<String, dynamic>),
                )
                .whereType<DashboardBannerDto>()
                .toList() ??
            [];
      },
    );
  }

  @override
  Future<List<LearnerDto>> fetchLeaderboard({
    required LeaderboardTimeline timeline,
    int limit = 10,
    int page = 1,
  }) async {
    final Map<String, dynamic> params = {'limit': limit, 'page': page};
    final timelineStr = timeline.timelineQuery;
    if (timelineStr != null) {
      params['timeline'] = timelineStr;
    }

    return performNetworkRequest(
      _dio.get(ApiEndpoints.leaderboard, queryParameters: params),
      fromJson: (data) {
        final results = data['results'] as List<dynamic>?;
        if (results == null) return [];
        final learners = <LearnerDto>[];
        for (var i = 0; i < results.length; i++) {
          final calculatedRank = (page - 1) * limit + i + 1;
          learners.add(
            LearnerDto.fromJson(
              results[i] as Map<String, dynamic>,
              calculatedRank,
            ),
          );
        }
        return learners;
      },
    );
  }

  @override
  Future<LearnerDto> fetchMyRank() async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.myRank),
      fromJson: (data) => LearnerDto.fromJson(
        data as Map<String, dynamic>,
        data['rank'] as int? ?? 0,
      ),
    );
  }

  @override
  Future<List<LearnerDto>> fetchCompetitorTargets() async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.competitorTargets),
      fromJson: (data) {
        final list = data is List ? data : (data['results'] as List? ?? []);
        return list
            .map((e) => LearnerDto.fromJson(e as Map<String, dynamic>, 0))
            .toList();
      },
    );
  }

  @override
  Future<List<LearnerDto>> fetchCompetitorThreats() async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.competitorThreats),
      fromJson: (data) {
        final list = data is List ? data : (data['results'] as List? ?? []);
        return list
            .map((e) => LearnerDto.fromJson(e as Map<String, dynamic>, 0))
            .toList();
      },
    );
  }

  @override
  Future<DashboardContentsDto> getWhatsNewFeed(
    DashboardSectionType sectionType,
  ) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.whatsNewFeed),
      fromJson: (data) =>
          DashboardContentsDto.fromJson(data, sectionType: sectionType),
    );
  }

  @override
  Future<DashboardContentsDto> getResumeLearningFeed(
    DashboardSectionType sectionType,
  ) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.resumeLearning),
      fromJson: (data) =>
          DashboardContentsDto.fromJson(data, sectionType: sectionType),
    );
  }

  // ── Posts / Announcements ────────────────────────────────────────────────

  @override
  Future<PaginatedResponseDto<PostDto>> getPosts({
    int page = 1,
    String? categorySlug,
  }) async {
    return performNetworkRequest(
      _dio.get(
        ApiEndpoints.posts,
        queryParameters: {
          'order_by': '-created',
          'page': page,
          if (categorySlug != null && categorySlug.isNotEmpty)
            'category': categorySlug,
        },
      ),
      fromJson: (data) =>
          PostDto.fromListResponse(data as Map<String, dynamic>),
    );
  }

  @override
  Future<List<PostCategoryDto>> getPostCategories() async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.postCategories),
      fromJson: (data) {
        final list = data as List<dynamic>? ?? [];
        return list
            .map((e) => PostCategoryDto.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<DashboardContentsDto> getRecentlyCompletedFeed(
    DashboardSectionType sectionType,
  ) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.recentlyCompleted),
      fromJson: (data) =>
          DashboardContentsDto.fromJson(data, sectionType: sectionType),
    );
  }

  @override
  Future<PaginatedLoginActivityDto> getLoginActivity({int page = 1}) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.loginActivity, queryParameters: {'page': page}),
      fromJson: (data) =>
          PaginatedLoginActivityDto.fromJson(data as Map<String, dynamic>),
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
  Future<PaginatedResponseDto<DoubtDto>> getDoubts({
    int page = 1,
    String? searchQuery,
  }) async {
    final queryParameters = <String, dynamic>{'page': page};
    if (searchQuery != null && searchQuery.isNotEmpty) {
      queryParameters['search'] = searchQuery;
    }

    return performNetworkRequest(
      _dio.get(ApiEndpoints.helpdeskTickets, queryParameters: queryParameters),
      fromJson: (data) =>
          DoubtDto.fromListResponse(data as Map<String, dynamic>),
    );
  }

  @override
  Future<({DoubtDto doubt, List<DoubtReplyDto> replies})> getDoubtReplies(
    String doubtId,
  ) async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.helpdeskTicketDetail(doubtId)),
      fromJson: (data) {
        final map = data as Map<String, dynamic>;
        return (
          doubt: DoubtDto.fromDetailJson(map),
          replies: DoubtReplyDto.fromDetailResponse(map, doubtId),
        );
      },
    );
  }

  @override
  Future<List<DoubtTopicDto>> getDoubtTopics() async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.helpdeskTopics),
      fromJson: DoubtTopicDto.fromListResponse,
    );
  }

  @override
  Future<DoubtDto> createDoubt({
    required String title,
    required String description,
    int? topicId,
    int? chapterContentId,
    int? questionId,
    int? queryType,
  }) async {
    final Map<String, dynamic> body = {
      'title': title,
      'description': description,
    };
    if (topicId != null) body['topic'] = topicId;
    if (chapterContentId != null) body['chapter_content'] = chapterContentId;
    if (questionId != null) body['question'] = questionId;
    if (queryType != null) body['query_type'] = queryType;

    return performNetworkRequest(
      _dio.post(ApiEndpoints.helpdeskTickets, data: body),
      fromJson: (data) => DoubtDto.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<DoubtReplyDto> postDoubtReply({
    required String doubtId,
    String? comment,
    bool? shouldResolve,
    bool? shouldClose,
  }) async {
    final Map<String, dynamic> body = {};
    if (comment != null) body['comment'] = comment;
    if (shouldResolve != null) body['should_resolve'] = shouldResolve;
    if (shouldClose != null) body['should_close'] = shouldClose;

    return performNetworkRequest(
      _dio.post(ApiEndpoints.helpdeskTicketFollowup(doubtId), data: body),
      fromJson: (data) =>
          DoubtReplyDto.fromJson(data as Map<String, dynamic>, doubtId),
    );
  }

  @override
  Future<String> uploadDoubtImage(File file, {int? ticketId}) async {
    final fileName = file.path.split('/').last;
    final Map<String, dynamic> map = {
      'image': await MultipartFile.fromFile(file.path, filename: fileName),
      'uploaded_for': 'doubts',
    };
    if (ticketId != null) {
      map['uploaded_for_object_id'] = ticketId;
    }
    final formData = FormData.fromMap(map);

    return performNetworkRequest(
      _dio.post(ApiEndpoints.imageUploadV3, data: formData),
      fromJson: (json) => json['url'] as String,
    );
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
      fromJson: (json) =>
          PaginatedResponseDto<AttemptDto>.fromJson(json, AttemptDto.fromJson),
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

    final String resolvedUrl = questionsUrl.replaceAll('v2.3', 'v2.2.1');

    final dynamic firstPageData = await performNetworkRequest(
      _dio.get(resolvedUrl),
      fromJson: (json) => json,
    );

    final List<QuestionDto> allQuestions = [];
    final List<dynamic> firstPageList;
    String? nextUrl;
    int count = 0;
    int perPage = 0;

    if (firstPageData is List) {
      firstPageList = firstPageData;
    } else if (firstPageData is Map && firstPageData['results'] is List) {
      firstPageList = firstPageData['results'] as List<dynamic>;
      nextUrl = firstPageData['next'] as String?;
      count = (firstPageData['count'] as int?) ?? 0;
      perPage = (firstPageData['per_page'] as int?) ?? firstPageList.length;
    } else {
      firstPageList = [];
    }

    allQuestions.addAll(
      firstPageList.map((e) => QuestionDto.fromJson(e as Map<String, dynamic>)),
    );

    if (nextUrl != null && nextUrl.isNotEmpty && count > 0 && perPage > 0) {
      final int totalPages = (count / perPage).ceil();
      if (totalPages > 1) {
        final uri = Uri.parse(resolvedUrl);
        final List<Future<dynamic>> futureRequests = [];

        for (int page = 2; page <= totalPages; page++) {
          final queryParams = Map<String, String>.from(uri.queryParameters);
          queryParams['page'] = page.toString();
          final pageUri = uri.replace(queryParameters: queryParams);
          futureRequests.add(
            performNetworkRequest(
              _dio.get(pageUri.toString()),
              fromJson: (json) => json,
            ),
          );
        }

        final List<dynamic> pagesData = await Future.wait(futureRequests);
        for (final pageData in pagesData) {
          if (pageData is Map && pageData['results'] is List) {
            final list = pageData['results'] as List<dynamic>;
            allQuestions.addAll(
              list.map((e) => QuestionDto.fromJson(e as Map<String, dynamic>)),
            );
          }
        }
      }
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
  Future<String?> getLastWatchedPosition(String attemptsUrl) async {
    final dynamic data = await performNetworkRequest(
      _dio.get(attemptsUrl),
      fromJson: (json) => json,
    );
    if (data is Map<String, dynamic>) {
      if (data['results'] is List) {
        final results = data['results'] as List;
        if (results.isNotEmpty) {
          final attempt = results.first;
          if (attempt is Map<String, dynamic> &&
              attempt['video'] is Map<String, dynamic>) {
            final lastPosition = attempt['video']['last_position']?.toString();
            return lastPosition;
          }
        }
      }
    }
    return null;
  }

  @override
  Future<void> updateVideoAttempt({
    required int chapterContentId,
    required String lastWatchPosition,
    required List<List<double>> watchedTimeRanges,
  }) async {
    try {
      await performNetworkRequest(
        _dio.post(
          ApiEndpoints.updateVideoAttempt,
          data: {
            'chapter_content_id': chapterContentId,
            'last_watch_position': lastWatchPosition,
            'watched_time_ranges': watchedTimeRanges,
          },
        ),
        fromJson: (data) => data,
      );
    } catch (e) {
      rethrow;
    }
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
  Future<List<ReviewItemDto>> getReviewItems(String reviewUrl) async {
    if (reviewUrl.isEmpty) return [];

    final dynamic firstPageData = await performNetworkRequest(
      _dio.get(reviewUrl),
      fromJson: (json) => json,
    );

    final List<ReviewItemDto> allReviewItems = [];
    final List<dynamic> firstPageList;
    String? nextUrl;
    int count = 0;
    int perPage = 0;

    if (firstPageData is List) {
      firstPageList = firstPageData;
    } else if (firstPageData is Map && firstPageData['results'] is List) {
      firstPageList = firstPageData['results'] as List<dynamic>;
      nextUrl = firstPageData['next'] as String?;
      count = (firstPageData['count'] as int?) ?? 0;
      perPage = (firstPageData['per_page'] as int?) ?? firstPageList.length;
    } else {
      firstPageList = [];
    }

    allReviewItems.addAll(
      firstPageList.map(
        (e) => ReviewItemDto.fromJson(e as Map<String, dynamic>),
      ),
    );

    if (nextUrl != null && nextUrl.isNotEmpty && count > 0 && perPage > 0) {
      final int totalPages = (count / perPage).ceil();
      if (totalPages > 1) {
        final uri = Uri.parse(reviewUrl);
        final List<Future<dynamic>> futureRequests = [];

        for (int page = 2; page <= totalPages; page++) {
          final queryParams = Map<String, String>.from(uri.queryParameters);
          queryParams['page'] = page.toString();
          final pageUri = uri.replace(queryParameters: queryParams);
          futureRequests.add(
            performNetworkRequest(
              _dio.get(pageUri.toString()),
              fromJson: (json) => json,
            ),
          );
        }

        final List<dynamic> pagesData = await Future.wait(futureRequests);
        for (final pageData in pagesData) {
          if (pageData is Map && pageData['results'] is List) {
            final list = pageData['results'] as List<dynamic>;
            allReviewItems.addAll(
              list.map(
                (e) => ReviewItemDto.fromJson(e as Map<String, dynamic>),
              ),
            );
          }
        }
      }
    }

    // Sort review items by index to preserve order
    allReviewItems.sort((a, b) => a.index.compareTo(b.index));

    return allReviewItems;
  }

  @override
  Future<List<SubjectAnalyticsDto>> getSubjectAnalytics(
    String analyticsUrl,
  ) async {
    if (analyticsUrl.isEmpty) return [];

    final dynamic firstPageData = await performNetworkRequest(
      _dio.get(analyticsUrl),
      fromJson: (json) => json,
    );

    final List<SubjectAnalyticsDto> allSubjects = [];
    final List<dynamic> firstPageList;
    String? nextUrl;
    int count = 0;
    int perPage = 0;

    if (firstPageData is List) {
      firstPageList = firstPageData;
    } else if (firstPageData is Map && firstPageData['results'] is List) {
      firstPageList = firstPageData['results'] as List<dynamic>;
      nextUrl = firstPageData['next'] as String?;
      count = (firstPageData['count'] as int?) ?? 0;
      perPage = (firstPageData['per_page'] as int?) ?? firstPageList.length;
    } else {
      firstPageList = [];
    }

    allSubjects.addAll(
      firstPageList.map(
        (e) => SubjectAnalyticsDto.fromJson(e as Map<String, dynamic>),
      ),
    );

    if (nextUrl != null && nextUrl.isNotEmpty && count > 0 && perPage > 0) {
      final int totalPages = (count / perPage).ceil();
      if (totalPages > 1) {
        final uri = Uri.parse(analyticsUrl);
        final List<Future<dynamic>> futureRequests = [];

        for (int page = 2; page <= totalPages; page++) {
          final queryParams = Map<String, String>.from(uri.queryParameters);
          queryParams['page'] = page.toString();
          final pageUri = uri.replace(queryParameters: queryParams);
          futureRequests.add(
            performNetworkRequest(
              _dio.get(pageUri.toString()),
              fromJson: (json) => json,
            ),
          );
        }

        final List<dynamic> pagesData = await Future.wait(futureRequests);
        for (final pageData in pagesData) {
          if (pageData is Map && pageData['results'] is List) {
            final list = pageData['results'] as List<dynamic>;
            allSubjects.addAll(
              list.map(
                (e) => SubjectAnalyticsDto.fromJson(e as Map<String, dynamic>),
              ),
            );
          }
        }
      }
    }

    return allSubjects;
  }

  @override
  Future<List<SubjectAnalyticsDto>> getAnalyticsData() async {
    return mockSubjectAnalytics;
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
      options: Options(extra: {'requireAuth': requireAuth}),
    );
  }

  @override
  Future<List<BookmarkFolderDto>> getBookmarkFolders() async {
    return performNetworkRequest(
      _dio.get(ApiEndpoints.bookmarkFolders),
      fromJson: (data) {
        final results = data['results'] as List<dynamic>?;
        return results
                ?.map(
                  (e) => BookmarkFolderDto.fromJson(e as Map<String, dynamic>),
                )
                .toList() ??
            [];
      },
    );
  }

  @override
  Future<PaginatedResponseDto<BookmarkDto>> getBookmarks({
    int page = 1,
    String? folder,
    String? order,
    String? filter,
  }) async {
    final queryParams = <String, dynamic>{'page': page};
    if (folder != null) queryParams['folder'] = folder;
    if (order != null) queryParams['order'] = order;
    if (filter != null) queryParams['filter'] = filter;

    return performNetworkRequest(
      _dio.get(ApiEndpoints.bookmarksV2_4, queryParameters: queryParams),
      fromJson: (data) {
        final items = BookmarkDto.fromListResponse(
          data as Map<String, dynamic>,
        );
        return PaginatedResponseDto<BookmarkDto>(
          results: items,
          count: data['count'] as int? ?? items.length,
          next: data['next']?.toString(),
          previous: data['previous']?.toString(),
        );
      },
    );
  }

  @override
  Future<BookmarkFolderDto> createBookmarkFolder(String name) async {
    return performNetworkRequest(
      _dio.post(ApiEndpoints.createBookmarkFolder, data: {'name': name}),
      fromJson: (data) =>
          BookmarkFolderDto.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<BookmarkFolderDto> updateBookmarkFolder(int id, String name) async {
    return performNetworkRequest(
      _dio.patch(
        ApiEndpoints.updateBookmarkFolder(id.toString()),
        data: {'name': name},
      ),
      fromJson: (data) =>
          BookmarkFolderDto.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<void> deleteBookmarkFolder(int id) async {
    await performNetworkRequest(
      _dio.delete(ApiEndpoints.deleteBookmarkFolder(id.toString())),
      fromJson: (data) => null,
    );
  }

  @override
  Future<BookmarkDto> createBookmark({
    required String category,
    required int lessonId,
    String? folder,
    String? bookmarkType,
  }) async {
    return performNetworkRequest(
      _dio.post(
        ApiEndpoints.bookmarks,
        data: {
          'category': category,
          'object_id': lessonId,
          'folder': ?folder,
          'bookmark_type': ?bookmarkType,
        },
      ),
      fromJson: (data) => BookmarkDto.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<void> deleteBookmark(String bookmarkId) async {
    await performNetworkRequest(
      _dio.delete(ApiEndpoints.deleteBookmark(bookmarkId)),
      fromJson: (data) => null,
    );
  }
}
