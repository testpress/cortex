import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';

part 'explore_providers.g.dart';

@riverpod
class ExploreSearchQuery extends _$ExploreSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

@riverpod
Future<List<ExploreBannerDto>> exploreBanners(ExploreBannersRef ref) {
  return ref.watch(dataSourceProvider).getExploreBanners();
}

@riverpod
Future<List<StudyTipDto>> exploreStudyTips(ExploreStudyTipsRef ref) {
  return ref.watch(dataSourceProvider).getStudyTips();
}

@riverpod
Future<List<ShortLessonDto>> exploreShortLessons(ExploreShortLessonsRef ref) {
  return ref.watch(dataSourceProvider).getShortLessons();
}

@riverpod
Future<List<DiscoveryCourseDto>> discoveryCourses(DiscoveryCoursesRef ref) {
  return ref.watch(dataSourceProvider).getDiscoveryCourses();
}

@riverpod
Future<List<PopularTestDto>> popularTests(PopularTestsRef ref) async {
  return ref.watch(dataSourceProvider).getPopularTests();
}


// Filtered Providers

@riverpod
Future<List<DiscoveryCourseDto>> filteredDiscoveryCourses(
  FilteredDiscoveryCoursesRef ref,
) async {
  final query = ref.watch(exploreSearchQueryProvider).toLowerCase();
  final courses = await ref.watch(discoveryCoursesProvider.future);
  if (query.isEmpty) return courses;
  return courses.where((c) => c.title.toLowerCase().contains(query)).toList();
}

@riverpod
Future<List<ShortLessonDto>> filteredShortLessons(
  FilteredShortLessonsRef ref,
) async {
  final query = ref.watch(exploreSearchQueryProvider).toLowerCase();
  final lessons = await ref.watch(exploreShortLessonsProvider.future);
  if (query.isEmpty) return lessons;
  return lessons.where((l) => l.title.toLowerCase().contains(query)).toList();
}

@riverpod
Future<List<PopularTestDto>> filteredPopularTests(FilteredPopularTestsRef ref) async {
  final query = ref.watch(exploreSearchQueryProvider).toLowerCase();
  final tests = await ref.watch(popularTestsProvider.future);
  if (query.isEmpty) return tests;
  return tests.where((t) => t.title.toLowerCase().contains(query)).toList();
}


@riverpod
Future<List<StudyTipDto>> filteredStudyTips(FilteredStudyTipsRef ref) async {
  final query = ref.watch(exploreSearchQueryProvider).toLowerCase();
  final tips = await ref.watch(exploreStudyTipsProvider.future);
  if (query.isEmpty) return tips;
  return tips
      .where(
        (t) =>
            t.title.toLowerCase().contains(query) ||
            t.description.toLowerCase().contains(query) ||
            (t.tag?.toLowerCase().contains(query) ?? false),
      )
      .toList();
}
