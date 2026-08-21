import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class AiRoutes {
  static List<RouteBase> routes(GlobalKey<NavigatorState> rootNavigatorKey) => [
    GoRoute(
      name: 'ai',
      path: '/ai',
      builder: (context, state) => const AiScreen(),
      routes: [
        GoRoute(
          name: 'ai_chat',
          path: 'chat',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const AiChatImmersiveScreen(),
        ),
        GoRoute(
          name: 'ai_history',
          path: 'history',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const AiChatHistoryScreen(),
        ),
      ],
    ),
  ];
}
