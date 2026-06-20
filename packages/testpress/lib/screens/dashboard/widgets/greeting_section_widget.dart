import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/data/data.dart' as dto;
import 'package:core/core.dart';
import 'package:profile/profile.dart';
import 'package:courses/courses.dart';

class GreetingSectionWidget extends ConsumerWidget {
  const GreetingSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final user = userAsync.valueOrNull;

    return HomeGreetingSection(
      userName: user?.name ?? L10n.of(context).defaultStudentName,
      showName: dto.AppConfig.showProfileTab,
    );
  }
}
