import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courses/courses.dart';

class QuickAccessSectionWidget extends ConsumerWidget {
  const QuickAccessSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shortcuts = ref.watch(quickShortcutsProvider);

    return shortcuts.when(
      data: (data) => QuickAccessGrid(
        shortcuts: data
            .map(
              (d) => Shortcut(
                id: d.id,
                label: d.label,
                icon: switch (d.iconType) {
                  ShortcutIconType.video => ShortcutIcon.video,
                  ShortcutIconType.practice => ShortcutIcon.practice,
                  ShortcutIconType.tests => ShortcutIcon.tests,
                  ShortcutIconType.notes => ShortcutIcon.notes,
                  ShortcutIconType.doubts => ShortcutIcon.doubts,
                  ShortcutIconType.schedule => ShortcutIcon.schedule,
                },
              ),
            )
            .toList(),
      ),
      loading: () => const SizedBox(height: 150),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}
