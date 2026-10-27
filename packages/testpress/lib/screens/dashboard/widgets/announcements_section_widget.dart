import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';

class AnnouncementsSectionWidget extends ConsumerWidget {
  const AnnouncementsSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(instituteSettingsProvider);
    if (!(settings?.postsEnabled ?? false)) {
      return const SizedBox.shrink();
    }

    final announcements = ref.watch(announcementsProvider);

    return announcements.when(
      data: (data) => UpdatesAnnouncementsSection(
        title: settings?.postsLabel,
        posts: data.take(3).toList(),
        onViewAll: () => context.push('/home/posts'),
        onItemTap: (post) =>
            context.push('/home/posts/${post.slug}', extra: post),
      ),
      loading: () => const SizedBox(height: 100),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}
