import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class AiRoutes {
  static List<RouteBase> routes(GlobalKey<NavigatorState> rootNavigatorKey) => [
    GoRoute(
      name: 'ai',
      path: '/ai',
      builder: (context, state) => const AiScreen(),
    ),
  ];
}
