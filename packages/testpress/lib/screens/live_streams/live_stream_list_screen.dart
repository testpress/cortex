import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:core/core.dart';
import 'widgets/live_stream_card.dart';
import 'widgets/live_stream_calendar_view.dart';
import '../../providers/live_stream_provider.dart';

/// Displays all live classes in a tabbed list view.
class LiveStreamListScreen extends ConsumerStatefulWidget {
  const LiveStreamListScreen({super.key});

  @override
  ConsumerState<LiveStreamListScreen> createState() =>
      _LiveStreamListScreenState();
}

class _LiveStreamListScreenState extends ConsumerState<LiveStreamListScreen> {
  LiveStreamStatus? _selectedFilter; // null = All
  bool _isCalendarView = false;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final liveStreamsAsync = ref.watch(liveStreamListProvider);
    final isSyncingInitial = ref.watch(isSyncingInitialPageProvider);
    final syncError = ref.watch(liveStreamSyncErrorProvider);

    final items = liveStreamsAsync.valueOrNull ?? const [];
    final filtered = _selectedFilter == null
        ? items
        : items.where((i) => i.status == _selectedFilter).toList();

    final showSkeleton = isSyncingInitial && items.isEmpty;

    final dummyItems = List.generate(
      5,
      (index) => LiveStreamItem(
        id: index.toString(),
        title: 'Loading live class title placeholder text',
        courseName: 'Course Placement',
        start: DateTime.now(),
        status: LiveStreamStatus.upcoming,
      ),
    );

    final displayItems = showSkeleton ? dummyItems : filtered;

    return AppShell(
      backgroundColor: design.colors.surface,
      child: Column(
        children: [
          AppHeader(
            title: l10n.liveClassesTitle,
            leading: AppBackButton(onTap: () => context.pop()),
            showDivider: true,
            bottomContent: _FilterChips(
              selected: _selectedFilter,
              onSelected: (status) => setState(() => _selectedFilter = status),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              design.spacing.md,
              design.spacing.md,
              design.spacing.md,
              0,
            ),
            child: _CalendarToggleCard(
              value: _isCalendarView,
              onChanged: (val) {
                setState(() {
                  _isCalendarView = val;
                });
              },
            ),
          ),
          Expanded(
            child: AppRefreshIndicator(
              onRefresh: () =>
                  ref.read(liveStreamListProvider.notifier).refresh(),
              child: SkeletonizerConfig(
                data: SkeletonizerConfigData(
                  effect: ShimmerEffect(
                    baseColor: design.colors.skeleton,
                    highlightColor: design.colors.onSkeleton,
                    duration: MotionPreferences.duration(
                      context,
                      const Duration(milliseconds: 800),
                    ),
                  ),
                ),
                child: Skeletonizer(
                  enabled: showSkeleton,
                  child: _isCalendarView
                      ? Padding(
                          padding: EdgeInsets.all(design.spacing.md),
                          child: LiveStreamCalendarView(items: displayItems),
                        )
                      : (displayItems.isEmpty
                            ? (syncError != null && items.isEmpty
                                  ? Center(
                                      child: AppErrorView(
                                        error: syncError,
                                        onRetry: () => ref
                                            .read(
                                              liveStreamListProvider.notifier,
                                            )
                                            .refresh(),
                                      ),
                                    )
                                  : _buildEmptyState(design))
                            : AppSemantics.scrollableList(
                                label: L10n.of(
                                  context,
                                ).liveClassesListSemanticsLabel,
                                itemCount: displayItems.length,
                                child: ListView.separated(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.all(design.spacing.md),
                                  itemCount: displayItems.length,
                                  separatorBuilder: (_, _) =>
                                      SizedBox(height: design.spacing.md),
                                  itemBuilder: (context, index) => LiveStreamCard(
                                    item: displayItems[index],
                                    onTap: () => context.push(
                                      '/live-classes/${displayItems[index].id}',
                                    ),
                                  ),
                                ),
                              )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(DesignConfig design) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: 400,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.video,
              size: 48,
              color: design.colors.textSecondary,
            ),
            SizedBox(height: design.spacing.md),
            AppText.body(
              L10n.of(context).liveClassesNoClassesFound,
              color: design.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selected, required this.onSelected});

  final LiveStreamStatus? selected;
  final ValueChanged<LiveStreamStatus?> onSelected;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final l10n = L10n.of(context);

    final tabs = <(String, LiveStreamStatus?)>[
      (l10n.liveClassesFilterAll, null),
      (l10n.liveClassesFilterLive, LiveStreamStatus.live),
      (l10n.liveClassesFilterUpcoming, LiveStreamStatus.upcoming),
      (l10n.liveClassesFilterCompleted, LiveStreamStatus.completed),
      (l10n.liveClassesFilterCancelled, LiveStreamStatus.cancelled),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: tabs.map((tab) {
          final (label, status) = tab;
          final isSelected = selected == status;
          return Padding(
            padding: EdgeInsets.only(right: design.spacing.xs),
            child: AppChip(
              label: label,
              isSelected: isSelected,
              onTap: () => onSelected(status),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CalendarToggleCard extends StatelessWidget {
  const _CalendarToggleCard({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppCard(
      padding: EdgeInsets.all(design.spacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: design.colors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                LucideIcons.calendar,
                color: design.colors.primary,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: design.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.cardTitle(L10n.of(context).liveClassesCalendarView),
                SizedBox(height: design.spacing.xs / 2),
                AppText.caption(L10n.of(context).liveClassesCalendarSubtitle),
              ],
            ),
          ),
          _CustomSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _CustomSwitch extends StatelessWidget {
  const _CustomSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppSemantics.button(
      label: L10n.of(context).liveClassesToggleCalendarSemantics,
      onTap: () => onChanged(!value),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: MotionPreferences.duration(
              context,
              const Duration(milliseconds: 200),
            ),
            curve: design.motion.easeOut,
            width: 48,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: value
                  ? design.colors.primary
                  : design.colors.divider.withValues(alpha: 0.5),
              border: Border.all(
                color: value ? design.colors.primary : design.colors.divider,
                width: 1.5,
              ),
            ),
            child: AnimatedAlign(
              duration: MotionPreferences.duration(
                context,
                const Duration(milliseconds: 200),
              ),
              curve: design.motion.easeOut,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFFFFF),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
