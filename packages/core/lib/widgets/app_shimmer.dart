import 'package:flutter/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../design/design_provider.dart';

/// Shared shimmer wrapper used by module-specific skeleton widgets.
class AppShimmer extends StatelessWidget {
  const AppShimmer({
    super.key,
    required this.child,
    this.enabled = true,
    this.ignoreContainers = true,
  });

  final Widget child;
  final bool enabled;
  final bool ignoreContainers;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Skeletonizer(
      enabled: enabled,
      ignoreContainers: ignoreContainers,
      effect: ShimmerEffect(
        baseColor: design.colors.skeleton,
        highlightColor: design.colors.onSkeleton,
      ),
      child: child,
    );
  }
}
