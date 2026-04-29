class InfoVideo {
  const InfoVideo({
    required this.id,
    required this.title,
    required this.duration,
    required this.url,
  });

  final String id;
  final String title;
  final String duration;
  final String url;
}

class InfoCourse {
  const InfoCourse({
    required this.id,
    required this.title,
    required this.instructor,
    required this.subject,
    required this.thumbnailUrl,
    required this.videoCount,
    required this.totalDuration,
    required this.videos,
  });

  final String id;
  final String title;
  final String instructor;
  final String subject;
  final String thumbnailUrl;
  final int videoCount;
  final String totalDuration;
  final List<InfoVideo> videos;
}

