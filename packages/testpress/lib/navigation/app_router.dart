import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes.dart';
import 'package:core/core.dart';
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
          allTabs: allTabs,
        ),
        branches: allTabs.map((tab) {
          final routes = switch (tab) {
            NavTab.home => HomeRoutes.routes(_rootNavigatorKey),
            NavTab.study => StudyRoutes.routes(_rootNavigatorKey),
            NavTab.exams => ExamsRoutes.routes(_rootNavigatorKey),
            NavTab.store => GlobalRoutes.storeRoutes(_rootNavigatorKey),
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
  store('/store', 'Store', LucideIcons.store),
  info('/info', 'Info', LucideIcons.squarePlay),
  profile('/profile', 'Profile', LucideIcons.user);

  final String id;
  final String label;
  final IconData icon;

  const NavTab(this.id, this.label, this.icon);

  AppTabItem toTabItem([InstituteSettings? settings]) {
    String currentLabel = label;
    if (this == NavTab.store &&
        settings?.storeLabel != null &&
        settings!.storeLabel.isNotEmpty) {
      currentLabel = settings.storeLabel;
    }
    return AppTabItem(id: id, label: currentLabel, icon: icon);
  }

  static List<NavTab> active([InstituteSettings? settings]) {
    return values.where((tab) {
      return switch (tab) {
        NavTab.exams => AppConfig.showExamTab,
        NavTab.info => AppConfig.showInfoTab,
        NavTab.store => settings?.storeEnabled ?? false,
        NavTab.profile => AppConfig.showProfileTab,
        _ => true,
      };
    }).toList();
  }
}

List<AppTabItem> buildPrimaryNavigationItems([InstituteSettings? settings]) {
  return NavTab.active(settings).map((tab) => tab.toTabItem(settings)).toList();
}

class _AppShellBuilder extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  final List<NavTab> allTabs;

  const _AppShellBuilder({
    required this.navigationShell,
    required this.allTabs,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(instituteSettingsProvider);
    final activeTabs = NavTab.active(settings);
    final items = activeTabs.map((tab) => tab.toTabItem(settings)).toList();
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
