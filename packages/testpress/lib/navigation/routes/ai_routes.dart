import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class AiRoutes {
  static List<RouteBase> routes(GlobalKey<NavigatorState> rootNavigatorKey) => [
    GoRoute(
      name: 'ai',
      path: '/ai',
      builder: (context, state) => AiScreen(
        onAskAiPressed: () =>
            context.push('/home/discussions/doubts/ask?isAskAi=true'),
        onCreateCustomExamPressed: () =>
            context.push('/exams/create-custom-exam'),
        onViewAllDoubtsPressed: () =>
            context.push('/home/discussions/doubts?filter=ai'),
        onDoubtTapped: (doubtId) =>
            context.push('/home/discussions/doubts/$doubtId'),
      ),
    ),
  ];
}
