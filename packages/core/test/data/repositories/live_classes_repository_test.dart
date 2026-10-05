import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:drift/native.dart';
import 'package:core/data/data.dart';

import 'user_repository_test.mocks.dart';

void main() {
  late AppDatabase db;
  late MockMockitoDataSource mockSource;
  late LiveClassesRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    mockSource = MockMockitoDataSource();
    repository = LiveClassesRepository(db, mockSource);
  });

  tearDown(() async {
    await db.close();
  });

  group('LiveClassesRepository getTodayLiveClasses offline fallback', () {
    test(
      'returns only today classes and never returns other day classes when offline',
      () async {
        // 1. Seed database with a class from yesterday and a class from today
        const yesterdayClass = LiveClassDto(
          id: '1',
          title: 'Yesterday Class',
          courseName: 'Physics',
          start: '2026-10-04T10:00:00.000',
          faculty: 'Dr. Smith',
          status: LiveClassStatus.upcoming,
          durationMinutes: 60,
        );

        const todayClass = LiveClassDto(
          id: '2',
          title: 'Today Class',
          courseName: 'Chemistry',
          start: '2026-10-05T10:00:00.000',
          faculty: 'Dr. Jones',
          status: LiveClassStatus.live,
          durationMinutes: 45,
        );

        // Upsert both into DB
        await db.upsertLiveClasses([
          LiveClassesTableCompanion.insert(
            id: yesterdayClass.id,
            subject: yesterdayClass.courseName,
            topic: yesterdayClass.title,
            time: yesterdayClass.start,
            faculty: yesterdayClass.faculty ?? '',
            status: 'upcoming',
          ),
          LiveClassesTableCompanion.insert(
            id: todayClass.id,
            subject: todayClass.courseName,
            topic: todayClass.title,
            time: todayClass.start,
            faculty: todayClass.faculty ?? '',
            status: 'live',
          ),
        ]);

        // Mock remote failure (offline)
        when(
          mockSource.getLiveClasses(
            page: anyNamed('page'),
            status: anyNamed('status'),
            ordering: anyNamed('ordering'),
            listRangeFrom: anyNamed('listRangeFrom'),
            listRangeTo: anyNamed('listRangeTo'),
          ),
        ).thenThrow(Exception('Network offline'));

        // Query for 2026-10-05
        final results = await repository.getTodayLiveClasses(
          date: '2026-10-05',
        );

        expect(results.length, 1);
        final item = results.first;
        expect(item.id, '2');
        expect(item.title, 'Today Class');
        expect(item.courseName, 'Chemistry');
        expect(item.start, '2026-10-05T10:00:00.000');
        expect(item.startDateTime, isNotNull);
        expect(item.status, LiveClassStatus.live);
      },
    );

    test(
      'returns empty list when offline and no classes match target date',
      () async {
        // Seed database only with yesterday's class
        await db.upsertLiveClasses([
          LiveClassesTableCompanion.insert(
            id: '1',
            subject: 'Physics',
            topic: 'Yesterday Class',
            time: '2026-10-04T10:00:00.000',
            faculty: 'Dr. Smith',
            status: 'completed',
          ),
        ]);

        // Mock remote failure (offline)
        when(
          mockSource.getLiveClasses(
            page: anyNamed('page'),
            status: anyNamed('status'),
            ordering: anyNamed('ordering'),
            listRangeFrom: anyNamed('listRangeFrom'),
            listRangeTo: anyNamed('listRangeTo'),
          ),
        ).thenThrow(Exception('Network offline'));

        // Query for 2026-10-05
        final results = await repository.getTodayLiveClasses(
          date: '2026-10-05',
        );

        // MUST be empty — must NOT fall back to returning all cached rows
        expect(results, isEmpty);
      },
    );

    test('filters by status when offline', () async {
      await db.upsertLiveClasses([
        LiveClassesTableCompanion.insert(
          id: '1',
          subject: 'Physics',
          topic: 'Upcoming Class',
          time: '2026-10-05T10:00:00.000',
          faculty: 'Dr. Smith',
          status: 'upcoming',
        ),
        LiveClassesTableCompanion.insert(
          id: '2',
          subject: 'Chemistry',
          topic: 'Live Class',
          time: '2026-10-05T11:00:00.000',
          faculty: 'Dr. Jones',
          status: 'live',
        ),
      ]);

      when(
        mockSource.getLiveClasses(
          page: anyNamed('page'),
          status: anyNamed('status'),
          ordering: anyNamed('ordering'),
          listRangeFrom: anyNamed('listRangeFrom'),
          listRangeTo: anyNamed('listRangeTo'),
        ),
      ).thenThrow(Exception('Network offline'));

      final liveResults = await repository.getTodayLiveClasses(
        date: '2026-10-05',
        status: 'live',
      );

      expect(liveResults.length, 1);
      expect(liveResults.first.id, '2');
      expect(liveResults.first.status, LiveClassStatus.live);
    });
  });
}
