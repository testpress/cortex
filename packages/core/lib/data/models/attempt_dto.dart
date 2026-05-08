import '../../network/api_endpoints.dart';
import 'section_dto.dart';

/// Attempt DTO — represents an active or completed exam attempt.
class AttemptDto {
  final String id;
  final String? remainingTime;
  final String questionsUrl;
  final String heartbeatUrl;
  final String endUrl;
  final String? startUrl;
  final String? score;
  final String? date;
  final int? correctCount;
  final int? incorrectCount;
  final int? totalQuestions;
  final List<SectionDto>? sections;

  const AttemptDto({
    required this.id,
    this.remainingTime,
    required this.questionsUrl,
    required this.heartbeatUrl,
    required this.endUrl,
    this.startUrl,
    this.score,
    this.date,
    this.correctCount,
    this.incorrectCount,
    this.totalQuestions,
    this.sections,
  });

  factory AttemptDto.fromJson(Map<String, dynamic> json) {
    // Handle nested assessment/attempt object in some API versions
    final Map<String, dynamic> data = json['assessment'] as Map<String, dynamic>? ?? 
                                      json['attempt'] as Map<String, dynamic>? ?? 
                                      json;
    
    final String baseUrl = (data['url'] ?? json['url'] ?? data['object_url'] ?? json['object_url'] ?? '').toString();
    final String cleanBase = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    
    // For CourseAttempts, we must use the content_attempts end URL to ensure course progress is updated.
    final bool isCourseAttempt = json['assessment'] != null;
    final String courseAttemptId = json['id']?.toString() ?? '';
    final String contentAttemptEndUrl = isCourseAttempt && courseAttemptId.isNotEmpty 
        ? ApiEndpoints.contentAttemptEnd(courseAttemptId) 
        : '';

    final List<dynamic>? sectionsList = data['sections'] as List<dynamic>? ?? json['sections'] as List<dynamic>?;
    final List<SectionDto>? parsedSections = sectionsList?.map((s) => SectionDto.fromJson(s as Map<String, dynamic>)).toList();

    return AttemptDto(
      id: (data['id'] ?? json['id'] ?? '').toString(),
      remainingTime: (data['remaining_time'] ?? json['remaining_time'])?.toString(),
      questionsUrl: (data['questions_url'] ?? json['questions_url'])?.toString() ?? 
                    (cleanBase.isNotEmpty ? '${cleanBase}questions/' : ''),
      heartbeatUrl: (data['heartbeat_url'] ?? json['heartbeat_url'])?.toString() ?? 
                    (cleanBase.isNotEmpty ? '${cleanBase}heartbeat/' : ''),
      endUrl: contentAttemptEndUrl.isNotEmpty 
              ? contentAttemptEndUrl 
              : ((json['end_url'] ?? data['end_url'] ?? json['terminate_url'] ?? data['terminate_url'])?.toString() ?? 
                (cleanBase.isNotEmpty ? '${cleanBase}end/' : '')),
      startUrl: (data['start_url'] ?? json['start_url'])?.toString(),
      score: (data['score'] ?? json['score'])?.toString(),
      date: (data['date'] ?? json['date'] ?? data['started_on'] ?? json['started_on'] ?? data['date_created'] ?? json['date_created'])?.toString(),
      correctCount: (data['correct_count'] ?? json['correct_count'] ?? data['correct'] ?? json['correct']) != null
          ? int.tryParse((data['correct_count'] ?? json['correct_count'] ?? data['correct'] ?? json['correct']).toString())
          : null,
      incorrectCount: (data['incorrect_count'] ?? json['incorrect_count'] ?? data['incorrect'] ?? json['incorrect']) != null
          ? int.tryParse((data['incorrect_count'] ?? json['incorrect_count'] ?? data['incorrect'] ?? json['incorrect']).toString())
          : null,
      totalQuestions: (data['total_questions'] ?? json['total_questions']) != null
          ? int.tryParse((data['total_questions'] ?? json['total_questions']).toString())
          : null,
      sections: parsedSections,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'remaining_time': remainingTime,
      'questions_url': questionsUrl,
      'heartbeat_url': heartbeatUrl,
      'end_url': endUrl,
      'start_url': startUrl,
      'score': score,
      'date': date,
      'correct_count': correctCount,
      'incorrect_count': incorrectCount,
      'total_questions': totalQuestions,
      'sections': sections?.map((s) => s.toJson()).toList(),
    };
  }
}
