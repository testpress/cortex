import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'live_stream_card.dart';

class LiveStreamCalendarView extends StatefulWidget {
  const LiveStreamCalendarView({super.key, required this.items});

  final List<LiveStreamItem> items;

  @override
  State<LiveStreamCalendarView> createState() => _LiveStreamCalendarViewState();
}

class _LiveStreamCalendarViewState extends State<LiveStreamCalendarView> {
  DateTime _selectedDate = DateTime.now();

  List<LiveStreamItem> get _selectedDayItems {
    return widget.items.where((item) {
      return item.start.year == _selectedDate.year &&
          item.start.month == _selectedDate.month &&
          item.start.day == _selectedDate.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final selectedItems = _selectedDayItems;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: design.radius.card,
            child: Container(
              height: 340, // Height to keep the month grid cells proportional
              decoration: BoxDecoration(
                color: design.colors.card,
                borderRadius: design.radius.card,
                border: Border.all(color: design.colors.divider, width: 1),
              ),
              child: SfCalendar(
                view: CalendarView.month,
                dataSource: _LiveStreamDataSource(widget.items, design),
                todayHighlightColor: design.colors.primary,
                cellBorderColor: design.colors.divider,
                headerStyle: CalendarHeaderStyle(
                  backgroundColor: design.colors.card,
                  textStyle: TextStyle(
                    color: design.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                viewHeaderStyle: ViewHeaderStyle(
                  dayTextStyle: TextStyle(
                    color: design.colors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                monthViewSettings: const MonthViewSettings(
                  showAgenda: false, // Disables Syncfusion's fixed agenda
                ),
                onTap: (CalendarTapDetails details) {
                  if (details.date != null) {
                    setState(() {
                      _selectedDate = details.date!;
                    });
                  }
                },
              ),
            ),
          ),
          SizedBox(height: design.spacing.md),
          // Scrollable agenda cards list that flows inline with the calendar grid card
          if (selectedItems.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: design.spacing.xl),
                child: AppText.bodySmall(
                  L10n.of(context).liveClassesNoClassesScheduledForDay,
                  color: design.colors.textSecondary,
                ),
              ),
            )
          else
            AppSemantics.scrollableList(
              label: 'Live classes agenda',
              itemCount: selectedItems.length,
              child: ListView.separated(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Scroll managed by outer SingleChildScrollView
                padding: EdgeInsets.zero,
                itemCount: selectedItems.length,
                separatorBuilder: (_, _) => SizedBox(height: design.spacing.md),
                itemBuilder: (context, index) =>
                    LiveStreamCard(item: selectedItems[index]),
              ),
            ),
        ],
      ),
    );
  }
}

class LiveStreamAppointment extends Appointment {
  LiveStreamAppointment({
    required super.startTime,
    required super.endTime,
    required super.subject,
    required super.color,
    required super.notes,
    required super.id,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.item,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final LiveStreamItem item;
}

class _LiveStreamDataSource extends CalendarDataSource {
  _LiveStreamDataSource(List<LiveStreamItem> source, DesignConfig design) {
    appointments = source.map((item) {
      final (bg, fg) = switch (item.status) {
        LiveStreamStatus.live => (
          design.statusColors.live.background,
          design.statusColors.live.foreground,
        ),
        LiveStreamStatus.upcoming => (
          design.statusColors.upcoming.background,
          design.statusColors.upcoming.foreground,
        ),
        LiveStreamStatus.completed => (
          design.statusColors.completed.background,
          design.statusColors.completed.foreground,
        ),
        LiveStreamStatus.cancelled => (
          design.statusColors.locked.background,
          design.statusColors.locked.foreground,
        ),
      };

      return LiveStreamAppointment(
        startTime: item.start,
        endTime: item.start.add(Duration(minutes: item.durationMinutes ?? 60)),
        subject: item.title,
        color: fg, // Foreground color for monthly cell dots
        notes: item.courseName,
        id: item.id,
        backgroundColor: bg,
        foregroundColor: fg,
        item: item,
      );
    }).toList();
  }
}
