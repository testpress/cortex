import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart' as dto;
import 'package:courses/courses.dart';

class StudyMomentumSectionWidget extends ConsumerWidget {
  const StudyMomentumSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final momentum = ref.watch(dto.studyMomentumProvider);

    return momentum.when(
      data: (data) => StudyMomentumGrid(momentum: data),
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}
