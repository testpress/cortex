import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../widgets/login_activity_item.dart';

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
  Object? _error;
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
    final isInitial = _activities.isEmpty && _error == null;
    if (isInitial) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final repo = await ref.read(userRepositoryProvider.future);
      final newItems = await repo.getLoginActivity(page: _currentPage);

      if (mounted) {
        setState(() {
          _activities.addAll(newItems.results);
          _hasMore = newItems.next != null;
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e, stack) {
      ref.read(sentryServiceProvider).captureException(e, stackTrace: stack);
      if (mounted) {
        setState(() {
          _error = e;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshData() async {
    try {
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
    } catch (e, stack) {
      ref.read(sentryServiceProvider).captureException(e, stackTrace: stack);
      if (mounted) {
        setState(() {
          _error = e;
        });
      }
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
    } catch (e, stack) {
      ref.read(sentryServiceProvider).captureException(e, stackTrace: stack);
      setState(() {
        _error = e;
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
    } catch (e, stack) {
      ref.read(sentryServiceProvider).captureException(e, stackTrace: stack);
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

    return AppShell(
      backgroundColor: design.colors.surface,
      child: Column(
        children: [
          // App Bar
          AppHeader(
            title: l10n.drawerLoginActivity,
            leading: context.canPop()
                ? AppBackButton(onTap: () => context.pop())
                : null,
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
            child: _isLoading && _activities.isEmpty
                ? const Center(child: AppLoadingIndicator())
                : _error != null && _activities.isEmpty
                ? AppErrorView(error: _error, onRetry: _fetchData)
                : (_activities.isEmpty && !_isLoading)
                ? Center(
                    child: AppText.body(
                      l10n.loginActivityNoActivityFound,
                      color: design.colors.textSecondary,
                    ),
                  )
                : AppRefreshIndicator(
                    onRefresh: _refreshData,
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.all(design.spacing.md),
                          sliver: SliverList.builder(
                            itemCount:
                                _activities.length + (_isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
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

          // Static Logout Button
          if (_activities.isNotEmpty && !_isLoading && _error == null)
            Container(
              width: double.infinity,
              padding: EdgeInsetsDirectional.fromSTEB(
                design.spacing.md,
                design.spacing.md,
                design.spacing.md,
                design.spacing.md + MediaQuery.paddingOf(context).bottom,
              ),
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
    );
  }
}
