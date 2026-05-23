import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../widgets/login_activity_item.dart';
import '../providers/profile_providers.dart';

class LoginActivityScreen extends ConsumerStatefulWidget {
  const LoginActivityScreen({super.key});

  @override
  ConsumerState<LoginActivityScreen> createState() => _LoginActivityScreenState();
}

class _LoginActivityScreenState extends ConsumerState<LoginActivityScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<LoginActivityDto> _activities = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchData();
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
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

  Future<void> _fetchMore() async {
    setState(() {
      _isLoadingMore = true;
      _error = null;
    });

    try {
      _currentPage++;
      final repo = await ref.read(userRepositoryProvider.future);
      final newItems = await repo.getLoginActivity(page: _currentPage);
      
      setState(() {
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
                border: Border(bottom: BorderSide(color: design.colors.divider)),
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
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
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
                    SizedBox(width: design.spacing.sm),
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
            
            // Content
            Expanded(
              child: _isLoading
                  ? Center(child: AppLoadingIndicator(color: design.colors.primary))
                  : _error != null && _activities.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText.body(_error!, color: design.colors.error),
                              SizedBox(height: design.spacing.md),
                              AppButton.secondary(
                                label: 'Retry',
                                onPressed: _fetchData,
                              ),
                            ],
                          ),
                        )
                      : _activities.isEmpty
                          ? Center(
                              child: AppText.body(
                                'No login activity found',
                                color: design.colors.textSecondary,
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.all(design.spacing.md),
                              itemCount: _activities.length + (_isLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index < _activities.length) {
                                  return LoginActivityItem(activity: _activities[index]);
                                }
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: design.spacing.md),
                                  child: Center(
                                    child: AppLoadingIndicator(color: design.colors.primary),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
