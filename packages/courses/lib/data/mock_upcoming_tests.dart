import '../models/today_schedule.dart';

const mockUpcomingTests = [
  ScheduledTest(
    id: 'test-1',
    title: 'Mocked Physics Test',
    time: 'Tomorrow · 09:00 AM',
    duration: '60 mins',
    type: DashboardTestType.mock,
    isImportant: true,
  ),
  ScheduledTest(
    id: 'test-2',
    title: 'Chapter 4 Practice',
    time: 'Tomorrow · 02:00 PM',
    duration: '45 mins',
    type: DashboardTestType.chapter,
  ),
  ScheduledTest(
    id: 'test-3',
    title: 'Weekly Revision',
    time: 'Friday · 05:00 PM',
    duration: '30 mins',
    type: DashboardTestType.practice,
  ),
];
