import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:courses/screens/course_list_screen.dart';

// Placeholder empty screens for the routes that don't exist yet
class ExplorePlaceholderScreen extends StatelessWidget {
  const ExplorePlaceholderScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Explore Tab Content'));
}

class ProfilePlaceholderScreen extends StatelessWidget {
  const ProfilePlaceholderScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Profile Tab Content'));
}

class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Home Tab Content'));
}

/// The root navigator key for the whole app
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Defines the global router for the application using GoRouter.
///
/// We use `StatefulShellRoute` to maintain the state (e.g. scroll position)
/// of each bottom navigation tab independently.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/study',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // AppTabBar items matching the routes exactly
        final items = [
          const AppTabItem(id: '/home', label: 'Home', icon: LucideIcons.home),
          const AppTabItem(
            id: '/study',
            label: 'Study',
            icon: LucideIcons.bookOpen,
          ),
          const AppTabItem(
            id: '/explore',
            label: 'Explore',
            icon: LucideIcons.compass,
          ),
          const AppTabItem(
            id: '/profile',
            label: 'Profile',
            icon: LucideIcons.user,
          ),
        ];

        return AppShell(
          bottomNavigationBar: AppTabBar(
            items: items,
            activeItemId: _getCurrentTabId(navigationShell.currentIndex),
            onTabChange: (id) => _onTabItemTapped(navigationShell, id),
          ),
          child: navigationShell,
        );
      },
      branches: [
        // Home Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePlaceholderScreen(),
            ),
          ],
        ),
        // Study Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/study',
              builder: (context, state) => const CourseListScreen(),
            ),
          ],
        ),
        // Explore Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/explore',
              builder: (context, state) => const ExplorePlaceholderScreen(),
            ),
          ],
        ),
        // Profile Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePlaceholderScreen(),
            ),
          ],
        ),
      ],
    ),

    // Add immersive full screen routes here outside of the StatefulShellRoute
    // They will navigate over the entire AppShell and hide the bottom bar
    GoRoute(
      path: '/lesson/:id',
      parentNavigatorKey: _rootNavigatorKey, // ensures full screen
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return Center(child: Text('Lesson Full-Screen View for ID: $id'));
      },
    ),
    GoRoute(
      path: '/video/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return Center(child: Text('Video Full-Screen View for ID: $id'));
      },
    ),
  ],
);

const _tabPaths = ['/home', '/study', '/explore', '/profile'];

String _getCurrentTabId(int index) => _tabPaths[index];

void _onTabItemTapped(StatefulNavigationShell navigationShell, String id) {
  final index = _tabPaths.indexOf(id);

  // Navigate to the chosen branch, safely preserving state
  navigationShell.goBranch(
    index != -1 ? index : 1, // Fallback to 'study' branch as default
    // Provide true if you want clicking an active tab to reset its stack to root
    initialLocation: index == navigationShell.currentIndex,
  );
}
