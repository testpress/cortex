import 'package:core/data/data.dart';
import '../models/assignment_dto.dart';
import '../models/quick_shortcut_dto.dart';

// SHARED MOCK DATA (mockCurrentUser, mockStudyMomentum) now lives in the 'data' package.

const mockHeroBanners = [
  DashboardBannerDto(
    id: "1",
    imageUrl:
        "https://images.unsplash.com/photo-1762438135827-428acc0e8941?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzdHVkZW50JTIwYWNoaWV2ZW1lbnQlMjBzdWNjZXNzJTIwY2VsZWJyYXRpb258ZW58MXx8fHwxNzY3OTU5MjY3fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    title: "JEE 2025 Results: 95% Selection Rate",
  ),
  DashboardBannerDto(
    id: "2",
    imageUrl:
        "https://images.unsplash.com/photo-1584792264192-dd873d389386?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxlZHVjYXRpb24lMjBhbm5vdW5jZW1lbnQlMjBiYW5uZXJ8ZW58MXx8fHwxNzY3OTU5MjY3fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    title: "New Batch Starting: JEE 2027 Foundation",
  ),
  DashboardBannerDto(
    id: "3",
    imageUrl:
        "https://images.unsplash.com/photo-1660795864432-6e63a88bfb40?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxleGFtJTIwcmVzdWx0cyUyMGNlbGVicmF0aW9uJTIwc3R1ZGVudHN8ZW58MXx8fHwxNzY3OTU5MjY3fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    title: "Special Merit Scholarship Program",
  ),
];

/// Mock promotional banners (Updates & Announcements)
const mockPromotionBanners = [
  DashboardBannerDto(
    id: '1',
    imageUrl: '',
    title: '📚 Study Smart, Not Hard',
    description:
        'Master complex topics with our structured learning paths - Physics, Chemistry & Math all in one place',
    bgColor: 0xFFEFF6FF,
    textColor: 0xFF1E40AF,
  ),
  DashboardBannerDto(
    id: '2',
    imageUrl: '',
    title: '🎯 Your Daily Study Companion',
    description:
        'Track progress across 45+ chapters with video lessons, practice sets, and chapter tests designed by experts',
    bgColor: 0xFFECFDF5,
    textColor: 0xFF065F46,
  ),
  DashboardBannerDto(
    id: '3',
    imageUrl: '',
    title: '⚡ Learn at Your Pace',
    description:
        '180+ hours of content available 24/7 - watch recordings, download notes, and practice anytime',
    bgColor: 0xFFFAF5FF,
    textColor: 0xFF6B21A8,
  ),
];

/// Mock quick access shortcuts
const mockQuickShortcuts = [
  QuickShortcutDto(
    id: '1',
    label: 'Recordings',
    iconType: ShortcutIconType.video,
  ),
  QuickShortcutDto(
    id: '2',
    label: 'Practice',
    iconType: ShortcutIconType.practice,
  ),
  QuickShortcutDto(id: '3', label: 'Tests', iconType: ShortcutIconType.tests),
  QuickShortcutDto(id: '4', label: 'Notes', iconType: ShortcutIconType.notes),
  QuickShortcutDto(
    id: '5',
    label: 'Ask Doubt',
    iconType: ShortcutIconType.doubts,
  ),
  QuickShortcutDto(
    id: '6',
    label: 'Schedule',
    iconType: ShortcutIconType.schedule,
  ),
];

/// Mock live classes for today.
const mockTodayClasses = [
  LiveClassDto(
    id: '1',
    subject: 'Physics - Thermodynamics',
    topic: 'Laws of Thermodynamics & Heat Engines',
    time: '10:00 AM - 12:00 PM',
    faculty: 'Prof. Anita Sharma',
    status: LiveClassStatus.completed,
  ),
  LiveClassDto(
    id: '2',
    subject: 'Chemistry - Organic Chemistry',
    topic: 'Reaction Mechanisms',
    time: '3:00 PM - 5:00 PM',
    faculty: 'Dr. Rajesh Kumar',
    status: LiveClassStatus.live,
  ),
  LiveClassDto(
    id: '3',
    subject: 'Mathematics - Calculus II',
    topic: 'Integration Techniques',
    time: '5:30 PM - 7:30 PM',
    faculty: 'Dr. Vikram Singh',
    status: LiveClassStatus.upcoming,
  ),
  LiveClassDto(
    id: '4',
    subject: 'English - Communication Skills',
    topic: 'Essay Writing & Comprehension',
    time: '8:00 PM - 9:00 PM',
    faculty: 'Ms. Priya Verma',
    status: LiveClassStatus.upcoming,
  ),
];

/// Mock assignments/assessments.
const mockAssignments = [
  AssignmentDto(
    id: '1',
    title: 'Problem Set - Differentiation',
    subject: 'Mathematics',
    dueTime: '11:59 PM',
    status: AssignmentStatus.overdue,
    progress: 0,
    description: 'Chapter 5 - Problems 1-20',
  ),
  AssignmentDto(
    id: '2',
    title: 'Thermodynamics Numericals',
    subject: 'Physics',
    dueTime: '6:00 PM',
    status: AssignmentStatus.pending,
    progress: 45,
    description: 'Heat transfer & entropy problems',
  ),
  AssignmentDto(
    id: '3',
    title: 'Organic Reaction Worksheet',
    subject: 'Chemistry',
    dueTime: '9:00 PM',
    status: AssignmentStatus.pending,
    progress: 80,
    description: '25 reactions with mechanisms',
  ),
  AssignmentDto(
    id: '4',
    title: 'Comprehension Exercises',
    subject: 'English',
    dueTime: '11:00 PM',
    status: AssignmentStatus.submitted,
    progress: 100,
    description: 'Reading passages & analysis',
  ),
];
