import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:drift/native.dart';
import 'package:core/data/data.dart';
import 'user_repository_test.mocks.dart';

void main() {
  late AppDatabase db;
  late MockMockitoDataSource mockSource;
  late DashboardRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    mockSource = MockMockitoDataSource();
    repository = DashboardRepository(db: db, dataSource: mockSource);
  });

  tearDown(() async {
    await db.close();
  });

  group('DashboardRepository - refreshDashboard', () {
    test(
      'successfully fetches and inserts all dashboard sections into DB',
      () async {
        // 1. Prepare fake unified response DTO
        final fakeBanners = [
          const DashboardBannerDto(
            id: '1',
            imageUrl: 'https://example.com/banner.png',
            title: 'Banner Title',
          ),
        ];

        final fakeWhatsNew = const WhatsNewDto(
          chapters: [
            ChapterSummaryDto(id: 'ch1', name: 'Introduction to Biology'),
          ],
          chapterContents: [
            ChapterContentSummaryDto(
              id: 'cc1',
              title: 'Cell Organelles',
              contentType: 'video',
              chapterId: 'ch1',
              coverImageMedium: 'https://example.com/image.png',
            ),
          ],
        );

        final fakeResumeLearning = const ResumeLearningDto(
          contentAttempts: [
            ContentAttemptDto(
              id: 'att1',
              chapterContentId: 'cc2',
              contentType: 'video',
              state: 'Started',
              userVideoId: 'uv1',
              courseId: 'course1',
            ),
            ContentAttemptDto(
              id: 'att2',
              chapterContentId: 'cc3',
              contentType: 'exam',
              state: 'Started',
              remainingTime: '3600',
              courseId: 'course1',
            ),
            ContentAttemptDto(
              id: 'att3',
              chapterContentId: 'cc4',
              contentType: 'pdf', // Non-video/non-exam type, should be skipped
              state: 'Started',
              courseId: 'course1',
            ),
          ],
          userVideos: [
            UserVideoDto(
              id: 'uv1',
              watchedPercentage: 45.0,
              remainingDuration: '120',
              videoContent: VideoContentDto(
                id: 'v1',
                title: 'Mitosis Lecture',
                duration: '300',
              ),
            ),
          ],
          courses: [
            CourseSummaryDto(
              id: 'course1',
              title: 'AP Biology 2026',
              slug: 'ap-biology-2026',
            ),
          ],
          chapters: [ChapterSummaryDto(id: 'ch2', name: 'Cell Division')],
          chapterContents: [
            ChapterContentSummaryDto(
              id: 'cc2',
              title: 'Mitosis Lecture',
              contentType: 'video',
              chapterId: 'ch2',
              coverImageMedium: 'https://example.com/mitosis.png',
            ),
            ChapterContentSummaryDto(
              id: 'cc3',
              title: 'Mitosis Quiz',
              contentType: 'exam',
              chapterId: 'ch2',
              coverImageMedium: 'https://example.com/quiz.png',
            ),
            ChapterContentSummaryDto(
              id: 'cc4',
              title: 'Cell division PDF notes',
              contentType: 'pdf',
              chapterId: 'ch2',
              coverImageMedium: 'https://example.com/pdf.png',
            ),
          ],
          userExams: [],
        );

        final fakeCompletedLearning = const CompletedLearningDto(
          contentAttempts: [
            ContentAttemptDto(
              id: 'att4',
              chapterContentId: 'cc5',
              contentType: 'video',
              state: 'Completed',
              userVideoId: 'uv2',
              courseId: 'course1',
            ),
            ContentAttemptDto(
              id: 'att5',
              chapterContentId: 'cc6',
              contentType:
                  'pdf', // Non-video/non-exam type, should be kept with progress=100 in Completed Learning
              state: 'Completed',
              courseId: 'course1',
            ),
          ],
          userVideos: [
            UserVideoDto(
              id: 'uv2',
              watchedPercentage: 100.0,
              remainingDuration: '0',
              videoContent: VideoContentDto(
                id: 'v2',
                title: 'Photosynthesis Lecture',
                duration: '400',
              ),
            ),
          ],
          courses: [],
          chapters: [],
          chapterContents: [
            ChapterContentSummaryDto(
              id: 'cc5',
              title: 'Photosynthesis Lecture',
              contentType: 'video',
              chapterId: 'ch3',
              coverImageMedium: 'https://example.com/photo.png',
            ),
            ChapterContentSummaryDto(
              id: 'cc6',
              title: 'Photosynthesis Notes',
              contentType: 'pdf',
              chapterId: 'ch3',
              coverImageMedium: 'https://example.com/photo_notes.png',
            ),
          ],
          userExams: [],
        );

        final fakeLeaderboard = [
          const LearnerDto(
            id: 'learner1',
            rank: 1,
            name: 'Jane Doe',
            avatar: 'https://example.com/jane.png',
            points: 1500.0,
          ),
        ];

        final fakeDashboardResponse = DashboardResponseDto(
          bannerAds: fakeBanners,
          whatsNew: fakeWhatsNew,
          resumeLearning: fakeResumeLearning,
          completedLearning: fakeCompletedLearning,
          leaderboard: fakeLeaderboard,
        );

        // 2. Mock network DataSource call
        when(
          mockSource.getDashboard(),
        ).thenAnswer((_) async => fakeDashboardResponse);

        // 3. Trigger refresh
        await repository.refreshDashboard();

        // 4. Verify DB content via streams
        // Verify Banners
        final banners = await db.watchDashboardBanners().first;
        expect(banners.length, 1);
        expect(banners[0].id, '1');
        expect(banners[0].title, 'Banner Title');

        // Verify What's New Feed
        final whatsNewFeed = await db
            .watchDashboardSection(DashboardSectionType.whatsNew)
            .first;
        expect(whatsNewFeed.length, 1);
        expect(whatsNewFeed[0].lessonId, 'cc1');
        expect(whatsNewFeed[0].title, 'Cell Organelles');
        expect(whatsNewFeed[0].chapterTitle, 'Introduction to Biology');

        // Verify Resume Learning Feed
        final resumeFeed = await db
            .watchDashboardSection(DashboardSectionType.resumeLearning)
            .first;
        // Should have cc2 (video) and cc3 (exam). cc4 (pdf) should be filtered out.
        expect(resumeFeed.length, 2);

        final videoItem = resumeFeed.firstWhere((e) => e.lessonId == 'cc2');
        expect(videoItem.title, 'Mitosis Lecture');
        expect(videoItem.progress, 45.0);
        expect(videoItem.totalDuration, '300');
        expect(videoItem.remainingDuration, '120');

        final examItem = resumeFeed.firstWhere((e) => e.lessonId == 'cc3');
        expect(examItem.title, 'Mitosis Quiz');
        expect(examItem.progress, 0.0);
        expect(examItem.remainingDuration, '3600');

        // Verify Completed Learning Feed
        final completedFeed = await db
            .watchDashboardSection(DashboardSectionType.completedLearning)
            .first;
        // Should have cc5 (video) and cc6 (pdf)
        expect(completedFeed.length, 2);

        final compVideo = completedFeed.firstWhere((e) => e.lessonId == 'cc5');
        expect(compVideo.progress, 100.0);

        final compPdf = completedFeed.firstWhere((e) => e.lessonId == 'cc6');
        expect(compPdf.progress, 100.0);

        // Verify Leaderboard
        final allTimeLeaderboard = await db.watchAllTimeLeaderboard().first;
        expect(allTimeLeaderboard.length, 1);
        expect(allTimeLeaderboard[0].id, 'learner1');
        expect(allTimeLeaderboard[0].name, 'Jane Doe');
        expect(allTimeLeaderboard[0].rank, 1);
      },
    );
  });
}
