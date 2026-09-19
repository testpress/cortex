class LearnLensChatResponseDto {
  final String answer;
  final String conversationId;
  final String chatId;
  final String messageType;
  final List<dynamic>? citations;

  LearnLensChatResponseDto({
    required this.answer,
    String? conversationId,
    String? chatId,
    this.messageType = 'text',
    this.citations,
  }) : chatId = (chatId != null && chatId.isNotEmpty)
           ? chatId
           : (conversationId ?? ''),
       conversationId = (conversationId != null && conversationId.isNotEmpty)
           ? conversationId
           : (chatId ?? '');

  factory LearnLensChatResponseDto.fromJson(Map<String, dynamic> json) {
    final rawConvId = json['conversation_id'] as String?;
    final rawChatId = json['chat_id'] as String?;
    final effectiveId = rawChatId ?? rawConvId ?? '';
    return LearnLensChatResponseDto(
      answer: json['answer'] as String? ?? '',
      conversationId: rawConvId ?? effectiveId,
      chatId: rawChatId ?? effectiveId,
      messageType: json['message_type'] as String? ?? 'text',
      citations: json['citations'] as List<dynamic>?,
    );
  }
}

class LearnLensChatSessionDto {
  final String id;
  final String title;
  final DateTime? updatedAt;

  const LearnLensChatSessionDto({
    required this.id,
    this.title = '',
    this.updatedAt,
  });

  factory LearnLensChatSessionDto.fromJson(Map<String, dynamic> json) {
    return LearnLensChatSessionDto(
      id: json['chat_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())?.toUtc()
          : null,
    );
  }
}

class LearnLensMessageDto {
  final String id;
  final String role;
  final String content;
  final String messageType;
  final List<dynamic>? citations;

  const LearnLensMessageDto({
    required this.id,
    required this.role,
    required this.content,
    this.messageType = 'text',
    this.citations,
  });

  bool get isUser => role.toLowerCase() == 'user';
  bool get isAi => !isUser;

  factory LearnLensMessageDto.fromJson(Map<String, dynamic> json) {
    return LearnLensMessageDto(
      id: json['message_id']?.toString() ?? json['id']?.toString() ?? '',
      role: json['role'] as String? ?? 'assistant',
      content: json['content'] as String? ?? '',
      messageType: json['message_type'] as String? ?? 'text',
      citations: json['citations'] as List<dynamic>?,
    );
  }
}

class LearnLensQuizResponseDto {
  final List<LearnLensQuizQuestionDto> questions;

  LearnLensQuizResponseDto({required this.questions});

  factory LearnLensQuizResponseDto.fromJson(Map<String, dynamic> json) {
    return LearnLensQuizResponseDto(
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map(
                (e) => LearnLensQuizQuestionDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }
}

class LearnLensQuizQuestionDto {
  final String id;
  final String text;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final String hint;
  final double? startSec;

  LearnLensQuizQuestionDto({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    this.hint = '',
    this.startSec,
  });

  factory LearnLensQuizQuestionDto.fromJson(Map<String, dynamic> json) {
    double? sec;
    if (json['citations'] is List && (json['citations'] as List).isNotEmpty) {
      final firstCit = (json['citations'] as List).first;
      if (firstCit is Map && firstCit['start_sec'] != null) {
        sec = (firstCit['start_sec'] as num).toDouble();
      }
    }
    sec ??=
        (json['start_sec'] as num?)?.toDouble() ??
        (json['timestamp'] as num?)?.toDouble();

    String parsedHint = (json['hint'] as String? ?? '')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();
    if (parsedHint.isNotEmpty && sec != null) {
      final hasTimestampPattern = RegExp(r'\d{1,2}:\d{2}').hasMatch(parsedHint);
      if (!hasTimestampPattern) {
        final totalSecs = sec.round();
        final mins = totalSecs ~/ 60;
        final secs = totalSecs % 60;
        final formattedTime = '$mins:${secs.toString().padLeft(2, '0')}';
        parsedHint = '$parsedHint ($formattedTime)';
      }
    }

    return LearnLensQuizQuestionDto(
      id: json['question_index']?.toString() ?? json['id']?.toString() ?? '',
      text: json['question_text'] as String? ?? json['text'] as String? ?? '',
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      correctAnswer:
          json['correct_option'] as String? ??
          json['correct_answer'] as String? ??
          '',
      explanation: (json['explanation'] as String? ?? '').replaceAll(
        RegExp(r'<[^>]*>'),
        '',
      ),
      hint: parsedHint,
      startSec: sec,
    );
  }

  /// Checks whether the given [option] at [optionIndex] matches [correctAnswer].
  bool isOptionCorrect(String option, int optionIndex) {
    final cleanOpt = option.trim().toLowerCase();
    final cleanAns = correctAnswer.trim().toLowerCase();
    if (cleanOpt.isEmpty || cleanAns.isEmpty) return false;
    if (cleanOpt == cleanAns) return true;

    final letter = String.fromCharCode(65 + optionIndex).toLowerCase();
    if (cleanAns == letter ||
        cleanAns == 'option $letter' ||
        cleanAns.startsWith('$letter)') ||
        cleanAns.startsWith('$letter.')) {
      return true;
    }

    if (cleanOpt.startsWith(cleanAns)) return true;

    return false;
  }
}
