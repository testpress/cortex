import 'package:flutter/cupertino.dart' show CupertinoSliverRefreshControl;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../widgets/login_activity_item.dart';
import '../providers/profile_providers.dart';

class LoginActivityScreen extends ConsumerStatefulWidget {
  const LoginActivityScreen({super.key, this.restrictionMessage});

  /// When set, a restriction banner is displayed at the top of the screen.
  /// Used when navigated from the login flow due to a parallel login restriction.
  final String? restrictionMessage;

  @override
  ConsumerState<LoginActivityScreen> createState() =>
      _LoginActivityScreenState();
}

class _LoginActivityScreenState extends ConsumerState<LoginActivityScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<LoginActivityDto> _activities = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchData();
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && !_isLoadingMore && _hasMore && _error == null) {
        _fetchMore();
      }
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repo = await ref.read(userRepositoryProvider.future);
      final newItems = await repo.getLoginActivity(page: _currentPage);

      setState(() {
        _activities.addAll(newItems.results);
        _hasMore = newItems.next != null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    final repo = await ref.read(userRepositoryProvider.future);
    final newItems = await repo.getLoginActivity(page: 1);

    if (mounted) {
      setState(() {
        _currentPage = 1;
        _activities.clear();
        _activities.addAll(newItems.results);
        _hasMore = newItems.next != null;
        _error = null;
      });
    }
  }

  Future<void> _fetchMore() async {
    setState(() {
      _isLoadingMore = true;
      _error = null;
    });

    try {
      final nextPage = _currentPage + 1;
      final repo = await ref.read(userRepositoryProvider.future);
      final newItems = await repo.getLoginActivity(page: nextPage);

      setState(() {
        _currentPage = nextPage;
        _activities.addAll(newItems.results);
        _hasMore = newItems.next != null;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _logoutDevices() async {
    if (_isLoggingOut) return;
    setState(() => _isLoggingOut = true);

    try {
      await ref.read(authProvider.notifier).logoutOtherDevices();
      if (mounted) {
        if (widget.restrictionMessage != null) {
          context.pop(true);
        } else {
          AppToast.show(
            context,
            message: L10n.of(context).loginActivityLogoutSuccess,
          );
          _currentPage = 1;
          _activities.clear();
          _fetchData();
        }
      }
    } catch (e) {
      if (mounted) {
        AppToast.show(
          context,
          message: '${L10n.of(context).loginActivityLogoutFailed}: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      color: design.colors.surface,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // App Bar
            Container(
              decoration: BoxDecoration(
                color: design.colors.card,
                border: Border(
                  bottom: BorderSide(color: design.colors.divider),
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  design.spacing.screenPadding,
                  design.spacing.md,
                  design.spacing.screenPadding,
                  design.spacing.md,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (context.canPop())
                      GestureDetector(
                        onTap: () => context.pop(),
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(
                            LucideIcons.arrowLeft,
                            size: 22,
                            color: design.colors.textPrimary,
                          ),
                        ),
                      ),
                    if (context.canPop()) SizedBox(width: design.spacing.sm),
                    Expanded(
                      child: AppText.title(
                        l10n.drawerLoginActivity,
                        color: design.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Restriction Banner
            if (widget.restrictionMessage != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: design.spacing.screenPadding,
                  vertical: design.spacing.sm,
                ),
                color: design.colors.error.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.alertTriangle,
                      size: 16,
                      color: design.colors.error,
                    ),
                    SizedBox(width: design.spacing.xs),
                    Expanded(
                      child: AppText.bodySmall(
                        widget.restrictionMessage!,
                        color: design.colors.error,
                      ),
                    ),
                  ],
                ),
              ),

            // Content
            Expanded(
              child: SkeletonizerConfig(
                data: SkeletonizerConfigData(
                  effect: ShimmerEffect(
                    baseColor: design.colors.surfaceVariant,
                    highlightColor: const Color(0xFFFFFFFF),
                  ),
                ),
                child: Skeletonizer(
                  enabled: _isLoading,
                  child: _error != null && _activities.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText.body(_error!, color: design.colors.error),
                              SizedBox(height: design.spacing.md),
                              AppButton.secondary(
                                label: l10n.labelRetry,
                                onPressed: _fetchData,
                              ),
                            ],
                          ),
                        )
                      : (_activities.isEmpty && !_isLoading)
                      ? Center(
                          child: AppText.body(
                            l10n.loginActivityNoActivityFound,
                            color: design.colors.textSecondary,
                          ),
                        )
                      : CustomScrollView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          slivers: [
                            CupertinoSliverRefreshControl(
                              onRefresh: _refreshData,
                              builder:
                                  (
                                    context,
                                    refreshState,
                                    pulledExtent,
                                    refreshTriggerPullDistance,
                                    refreshIndicatorExtent,
                                  ) {
                                    return Opacity(
                                      opacity:
                                          (pulledExtent /
                                                  refreshTriggerPullDistance)
                                              .clamp(0.0, 1.0),
                                      child: Center(
                                        child: AppLoadingIndicator(
                                          color: design.colors.primary,
                                        ),
                                      ),
                                    );
                                  },
                            ),
                            SliverPadding(
                              padding: EdgeInsets.all(design.spacing.md),
                              sliver: SliverList.builder(
                                itemCount: _isLoading
                                    ? 4
                                    : (_activities.length +
                                          (_isLoadingMore ? 1 : 0)),
                                itemBuilder: (context, index) {
                                  if (_isLoading) {
                                    return LoginActivityItem(
                                      activity: _skeletonActivity,
                                    );
                                  }
                                  if (index < _activities.length) {
                                    return LoginActivityItem(
                                      activity: _activities[index],
                                    );
                                  }
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: design.spacing.md,
                                    ),
                                    child: Center(
                                      child: AppLoadingIndicator(
                                        color: design.colors.primary,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),

            // Static Logout Button
            if (_activities.isNotEmpty && !_isLoading && _error == null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(design.spacing.md),
                decoration: BoxDecoration(color: design.colors.surface),
                child: AppButton.primary(
                  label: l10n.loginActivityLogoutOtherDevices,
                  fullWidth: true,
                  loading: _isLoggingOut,
                  backgroundColor: design.colors.error,
                  foregroundColor: design.colors.onError,
                  onPressed: _logoutDevices,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final _skeletonActivity = LoginActivityDto(
  id: 0,
  userAgent: 'Mozilla/5.0...',
  ipAddress: '192.168.1.1',
  device: 'Mobile',
  deviceName: 'Device placeholder',
  browser: 'Browser placeholder',
  os: 'OS placeholder',
  lastUsed: DateTime.now(),
  location: 'Location placeholder',
  currentDevice: false,
);
