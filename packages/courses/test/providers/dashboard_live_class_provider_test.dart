import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:core/data/data.dart';
import 'package:courses/providers/dashboard_providers.dart';

class FakeLiveClassesRepository extends LiveClassesRepository {
  FakeLiveClassesRepository(this.classesToReturn)
      : super(AppDatabase(NativeDatabase.memory()), MockDataSource());

  List<LiveClassDto> classesToReturn;

  @override
  Future<List<LiveClassDto>> getTodayLiveClasses({
    String? date,
    String? status,
  }) async {
    return classesToReturn;
  }
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  group('dashboardLiveClassProvider', () {
    test('returns null when getTodayLiveClasses is empty', () async {
      final fakeRepo = FakeLiveClassesRepository([]);
      final container = ProviderContainer(
        overrides: [
          liveClassesRepositoryProvider.overrideWith(
            (ref) async => fakeRepo,
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(dashboardLiveClassProvider.future);
      expect(result, isNull);
    });

    test('returns live class as Priority 1 even when upcoming classes exist',
        () async {
      final futureTime =
          DateTime.now().add(const Duration(hours: 2)).toIso8601String();
      const liveClass = LiveClassDto(
        id: '1',
        title: 'Active Session',
        courseName: 'Physics',
        status: LiveClassStatus.live,
      );
      final upcomingClass = LiveClassDto(
        id: '2',
        title: 'Future Session',
        courseName: 'Chemistry',
        start: futureTime,
        status: LiveClassStatus.upcoming,
      );

      final fakeRepo = FakeLiveClassesRepository([upcomingClass, liveClass]);
      final container = ProviderContainer(
        overrides: [
          liveClassesRepositoryProvider.overrideWith(
            (ref) async => fakeRepo,
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(dashboardLiveClassProvider.future);
      expect(result, isNotNull);
      expect(result!.id, '1');
      expect(result.status, LiveClassStatus.live);
    });

    test(
        'returns next upcoming class with future start time as Priority 2 when no live class exists',
        () async {
      final futureTime =
          DateTime.now().add(const Duration(hours: 1)).toIso8601String();
      final upcomingClass = LiveClassDto(
        id: '2',
        title: 'Upcoming Session',
        courseName: 'Maths',
        start: futureTime,
        status: LiveClassStatus.upcoming,
      );

      final fakeRepo = FakeLiveClassesRepository([upcomingClass]);
      final container = ProviderContainer(
        overrides: [
          liveClassesRepositoryProvider.overrideWith(
            (ref) async => fakeRepo,
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(dashboardLiveClassProvider.future);
      expect(result, isNotNull);
      expect(result!.id, '2');
      expect(result.title, 'Upcoming Session');
    });

    test('returns null when upcoming class start time is in the past',
        () async {
      final pastTime =
          DateTime.now().subtract(const Duration(hours: 1)).toIso8601String();
      final expiredUpcoming = LiveClassDto(
        id: '3',
        title: 'Past Upcoming Session',
        courseName: 'Biology',
        start: pastTime,
        status: LiveClassStatus.upcoming,
      );

      final fakeRepo = FakeLiveClassesRepository([expiredUpcoming]);
      final container = ProviderContainer(
        overrides: [
          liveClassesRepositoryProvider.overrideWith(
            (ref) async => fakeRepo,
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(dashboardLiveClassProvider.future);
      expect(result, isNull);
    });
  });
}
