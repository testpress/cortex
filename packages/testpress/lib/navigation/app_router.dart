import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes.dart';
import 'package:core/core.dart';
import 'package:core/legacy_icons.dart' as legacy;
import 'package:core/data/data.dart';
import 'package:profile/profile.dart';
import '../widgets/dashboard_drawer.dart';



/// The root navigator key for the whole app
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');


/// Provider that exposes the application router.
final goRouterProvider = Provider<GoRouter>((ref) {
  // Only watch the boolean login status to prevent the router from rebuilding
  // on every loading state change or refresh.
  final isLoggedIn = ref.watch(authProvider).valueOrNull ?? false;
  final config = ref.watch(clientConfigProvider);
  const allTabs = NavTab.values;

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/onboarding',
    redirect: (context, state) =>
        AuthRoutes.redirect(context, state, isLoggedIn),
    routes: [
      ...AuthRoutes.routes,
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => _AppShellBuilder(
          navigationShell: navigationShell,
          config: config,
          allTabs: allTabs,
        ),
        branches: allTabs.map((tab) {
          final routes = switch (tab) {
            NavTab.home => HomeRoutes.routes(_rootNavigatorKey),
            NavTab.study => StudyRoutes.routes(_rootNavigatorKey),
            NavTab.exams => ExamsRoutes.routes(_rootNavigatorKey),
            NavTab.explore => GlobalRoutes.exploreRoutes,
            NavTab.info => GlobalRoutes.infoRoutes(_rootNavigatorKey),
            NavTab.profile => ProfileRoutes.routes(_rootNavigatorKey),
          };
          return StatefulShellBranch(routes: routes);
        }).toList(),
      ),
      ...GlobalRoutes.immersiveRoutes(_rootNavigatorKey),
    ],
  );
});

enum NavTab {
  home('/home', 'Home', LucideIcons.home),
  study('/study', 'Study', LucideIcons.bookOpen),
  exams('/exams', 'Exam', LucideIcons.fileText),
  explore('/explore', 'Explore', LucideIcons.compass),
  info('/info', 'Info', legacy.LucideIcons.youtube),
  profile('/profile', 'Profile', LucideIcons.user);

  final String id;
  final String label;
  final IconData icon;

  const NavTab(this.id, this.label, this.icon);

  AppTabItem toTabItem() => AppTabItem(id: id, label: label, icon: icon);

  static List<NavTab> active(ClientConfig config) {
    return values.where((tab) {
      return switch (tab) {
        NavTab.exams => config.showExamTab,
        NavTab.info => config.showInfoTab,
        NavTab.explore => config.showExploreTab,
        NavTab.profile => config.showProfileTab,
        _ => true,
      };
    }).toList();
  }
}

List<AppTabItem> buildPrimaryNavigationItems({
  required ClientConfig config,
}) {
  return NavTab.active(config).map((tab) => tab.toTabItem()).toList();
}





class _AppShellBuilder extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  final ClientConfig config;
  final List<NavTab> allTabs;

  const _AppShellBuilder({
    required this.navigationShell,
    required this.config,
    required this.allTabs,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTabs = NavTab.active(config);
    final items = activeTabs.map((tab) => tab.toTabItem()).toList();
    final isLogoutSheetOpen = ref.watch(isLogoutSheetOpenProvider);
    final activeTabId = allTabs[navigationShell.currentIndex].id;

    void closeSheet() =>
        ref.read(isLogoutSheetOpenProvider.notifier).state = false;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;

        return AppShell(
          bottomNavigationBar: AppTabBar(
            items: items,
            activeItemId: activeTabId,
            onTabChange: (id) =>
                _onTabItemTapped(navigationShell, id, allTabs: allTabs),
          ),
          navigationRail: AppNavigationRail(
            items: items,
            activeItemId: activeTabId,
            onTabChange: (id) =>
                _onTabItemTapped(navigationShell, id, allTabs: allTabs),
          ),
          drawer: DashboardDrawer(isLandscape: isLandscape),
          bottomSheet: AppBottomSheet(
            isOpen: isLogoutSheetOpen,
            onClose: closeSheet,
            child: LogoutConfirmationSheet(
              onConfirm: () {
                closeSheet();
                ref.read(authProvider.notifier).logout();
              },
              onCancel: closeSheet,
            ),
          ),
          child: navigationShell,
        );
      },
    );
  }
}


void _onTabItemTapped(
  StatefulNavigationShell navigationShell,
  String id, {
  required List<NavTab> allTabs,
}) {
  final index = allTabs.indexWhere((tab) => tab.id == id);
  navigationShell.goBranch(index != -1 ? index : 0);
}

