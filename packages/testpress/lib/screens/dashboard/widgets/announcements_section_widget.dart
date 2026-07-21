import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart' as dto;
import 'package:courses/courses.dart';
import '../../announcements/announcements_list_screen.dart';
import '../../announcements/announcement_detail_screen.dart';

class AnnouncementsSectionWidget extends ConsumerWidget {
  const AnnouncementsSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(dto.instituteSettingsProvider);
    if (!(settings?.postsEnabled ?? false)) {
      return const SizedBox.shrink();
    }

    final announcements = ref.watch(dto.announcementsProvider);

    return announcements.when(
      data: (data) => UpdatesAnnouncementsSection(
        title: settings?.postsLabel,
        posts: data.take(3).toList(),
        onViewAll: () {
          Navigator.of(
            context,
            rootNavigator: true,
          ).push(AppRoute(page: const AnnouncementsListScreen()));
        },
        onItemTap: (post) {
          Navigator.of(
            context,
            rootNavigator: true,
          ).push(AppRoute(page: AnnouncementDetailScreen(post: post)));
        },
      ),
      loading: () => const SizedBox(height: 100),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}
