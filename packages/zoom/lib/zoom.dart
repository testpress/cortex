import 'package:core/core.dart';
import 'src/zoom_meeting_service.dart';

export 'src/zoom_meeting_service.dart' show ZoomMeetingService;

class ZoomPlugin {
  static void registerWith() {
    MeetingServiceRegistry.register(ZoomMeetingService());
  }
}
