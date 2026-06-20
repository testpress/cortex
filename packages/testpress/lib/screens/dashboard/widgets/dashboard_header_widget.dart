import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart' as dto;
import 'package:courses/courses.dart';

class DashboardHeaderWidget extends ConsumerWidget {
  final bool isLandscape;
  const DashboardHeaderWidget({super.key, required this.isLandscape});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final overrideLogoUrl = dto.AppConfig.instituteLogoUrl;
    final apiLogoUrl = dto.InstituteSettings.current?.photo;
    final logoUrl = overrideLogoUrl.isNotEmpty
        ? overrideLogoUrl
        : (apiLogoUrl ?? '');
    final instituteName = dto.InstituteSettings.current?.name ?? '';

    return DashboardHeader(
      title: instituteName.isNotEmpty
          ? instituteName
          : L10n.of(context).homeHeaderTitle,
      logoUrl: logoUrl.isNotEmpty ? logoUrl : null,
      isLandscape: isLandscape,
      backgroundColor: design.colors.card,
      onMenuPressed: () {
        ref.read(isHomeDrawerOpenProvider.notifier).state = true;
      },
    );
  }
}
