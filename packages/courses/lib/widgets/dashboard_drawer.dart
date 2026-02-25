import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import '../providers/dashboard_providers.dart';

class DashboardDrawer extends ConsumerWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final isOpen = ref.watch(isHomeDrawerOpenProvider);

    final l10n = L10n.of(context);

    return AppDrawer(
      isOpen: isOpen,
      title: l10n.drawerMenuTitle,
      onClose: () {
        ref.read(isHomeDrawerOpenProvider.notifier).state = false;
      },
      sections: [
        AppDrawerSection(
          items: [
            AppDrawerItem(
              icon: LucideIcons.bookmark,
              label: l10n.drawerBookmark,
              action: () {},
            ),
            AppDrawerItem(
              icon: LucideIcons.fileText,
              label: l10n.drawerPosts,
              action: () {},
            ),
            AppDrawerItem(
              icon: LucideIcons.pieChart,
              label: l10n.drawerAnalytics,
              action: () {},
            ),
            AppDrawerItem(
              icon: LucideIcons.messageSquare,
              label: l10n.drawerForum,
              action: () {},
            ),
            AppDrawerItem(
              icon: LucideIcons.messageCircle,
              label: l10n.drawerDoubts,
              action: () {},
            ),
            AppDrawerItem(
              icon: LucideIcons.fileCheck,
              label: l10n.drawerCustomExam,
              action: () {},
            ),
            AppDrawerItem(
              icon: LucideIcons.barChart,
              label: l10n.drawerReports,
              action: () {},
            ),
          ],
        ),
        AppDrawerSection(
          items: [
            AppDrawerItem(
              icon: LucideIcons.user,
              label: l10n.drawerProfile,
              action: () {},
            ),
            AppDrawerItem(
              icon: LucideIcons.settings,
              label: l10n.drawerSettings,
              action: () {},
            ),
            AppDrawerItem(
              icon: LucideIcons.lock,
              label: l10n.drawerLoginActivity,
              action: () {},
            ),
            AppDrawerItem(
              icon: LucideIcons.logOut,
              label: l10n.drawerLogout,
              action: () {},
              isRed: true,
            ),
          ],
        ),
        AppDrawerSection(
          items: [
            AppDrawerItem(
              icon: LucideIcons.shield,
              label: l10n.drawerPrivacy,
              action: () {},
            ),
            AppDrawerItem(
              icon: design.isDark ? LucideIcons.sun : LucideIcons.moon,
              label: design.isDark
                  ? l10n.drawerThemeLight
                  : l10n.drawerThemeDark,
              action: () {
                final currentMode = ref.read(designModeProvider);
                final newMode = currentMode == DesignMode.dark
                    ? DesignMode.light
                    : DesignMode.dark;
                ref.read(designModeProvider.notifier).state = newMode;
              },
              keepMenuOpen: true,
            ),
            AppDrawerItem(
              icon: LucideIcons.info,
              label: l10n.drawerVersion('1.1.7'),
              action: _dummyAction,
              disabled: true,
            ),
          ],
        ),
      ],
    );
  }

  static void _dummyAction() {}
}
