class LearnLensChatResponseDto {
  final String answer;
  final String conversationId;

  LearnLensChatResponseDto({
    required this.answer,
    required this.conversationId,
  });

  factory LearnLensChatResponseDto.fromJson(Map<String, dynamic> json) {
    return LearnLensChatResponseDto(
      answer: json['answer'] as String? ?? '',
      conversationId: json['conversation_id'] as String? ?? '',
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

/// Usage policy constraints enforced by LearnLens and Testpress.
class AiChatPolicyDto {
  final int maxMessagesPerConversation;
  final int maxMessagesPerHour;
  final int maxNewConversationsPerDay;
  final int maxMessageCharacters;
  final String instituteTimezone;

  const AiChatPolicyDto({
    this.maxMessagesPerConversation = 20,
    this.maxMessagesPerHour = 20,
    this.maxNewConversationsPerDay = 10,
    this.maxMessageCharacters = 4000,
    this.instituteTimezone = 'Asia/Kolkata',
  });

  factory AiChatPolicyDto.fromJson(Map<String, dynamic> json) {
    return AiChatPolicyDto(
      maxMessagesPerConversation:
          (json['max_messages_per_conversation'] as num?)?.toInt() ?? 20,
      maxMessagesPerHour:
          (json['max_messages_per_hour'] as num?)?.toInt() ?? 20,
      maxNewConversationsPerDay:
          (json['max_new_conversations_per_day'] as num?)?.toInt() ?? 10,
      maxMessageCharacters:
          (json['max_message_characters'] as num?)?.toInt() ?? 4000,
      instituteTimezone:
          json['institute_timezone'] as String? ?? 'Asia/Kolkata',
    );
  }

  Map<String, dynamic> toJson() => {
    'max_messages_per_conversation': maxMessagesPerConversation,
    'max_messages_per_hour': maxMessagesPerHour,
    'max_new_conversations_per_day': maxNewConversationsPerDay,
    'max_message_characters': maxMessageCharacters,
    'institute_timezone': instituteTimezone,
  };
}

/// Session token and dynamic base URL returned by Testpress AI session endpoint.
class AiChatSessionDto {
  final String sessionToken;
  final DateTime expiresAt;
  final int expiresAtMs;
  final String baseUrl;
  final AiChatPolicyDto policy;
  final bool attachmentsEnabled;

  const AiChatSessionDto({
    required this.sessionToken,
    required this.expiresAt,
    required this.expiresAtMs,
    required this.baseUrl,
    required this.policy,
    this.attachmentsEnabled = false,
  });

  bool get isExpired => DateTime.now().toUtc().isAfter(expiresAt);

  factory AiChatSessionDto.fromJson(Map<String, dynamic> json) {
    final rawExpires = json['expiresAt'];
    final int expiresMs = (rawExpires is num)
        ? rawExpires.toInt()
        : DateTime.now().add(const Duration(hours: 2)).millisecondsSinceEpoch;

    return AiChatSessionDto(
      sessionToken: (json['session_token'] ?? json['token']) as String? ?? '',
      expiresAt: DateTime.fromMillisecondsSinceEpoch(expiresMs, isUtc: true),
      expiresAtMs: expiresMs,
      baseUrl: (json['base_url'] as String? ?? '').replaceAll(
        RegExp(r'/+$'),
        '',
      ),
      policy: json['policy'] is Map<String, dynamic>
          ? AiChatPolicyDto.fromJson(json['policy'] as Map<String, dynamic>)
          : const AiChatPolicyDto(),
      attachmentsEnabled: json['attachments_enabled'] as bool? ?? false,
    );
  }

  /// Parses a content-scoped session response from Testpress `/contents/<id>/ai-sessions/create/`.
  factory AiChatSessionDto.fromContentSession(Map<String, dynamic> json) {
    final token = (json['token'] ?? json['session_token']) as String? ?? '';
    final expiresMs = DateTime.now()
        .add(const Duration(hours: 2))
        .millisecondsSinceEpoch;
    return AiChatSessionDto(
      sessionToken: token,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(expiresMs, isUtc: true),
      expiresAtMs: expiresMs,
      baseUrl: '',
      policy: const AiChatPolicyDto(),
      attachmentsEnabled: false,
    );
  }

  Map<String, dynamic> toJson() => {
    'session_token': sessionToken,
    'expiresAt': expiresAtMs,
    'base_url': baseUrl,
    'policy': policy.toJson(),
    'attachments_enabled': attachmentsEnabled,
  };
}

/// Generation metadata representing the backend's attempt to answer a user message.
class AiGenerationDto {
  final String generationId;
  final String requestId;
  final String userMessageId;
  final String? assistantMessageId;
  final String status;
  final String? errorCode;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime? finishedAt;

  const AiGenerationDto({
    required this.generationId,
    required this.requestId,
    required this.userMessageId,
    this.assistantMessageId,
    required this.status,
    this.errorCode,
    this.errorMessage,
    required this.createdAt,
    this.finishedAt,
  });

  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isProcessing => status.toLowerCase() == 'processing';
  bool get isFailed => status.toLowerCase() == 'failed';
  bool get isUnresolved => status.toLowerCase() == 'unresolved';

  factory AiGenerationDto.fromJson(Map<String, dynamic> json) {
    return AiGenerationDto(
      generationId: json['generation_id']?.toString() ?? '',
      requestId: json['request_id']?.toString() ?? '',
      userMessageId: json['user_message_id']?.toString() ?? '',
      assistantMessageId: json['assistant_message_id']?.toString(),
      status: json['status'] as String? ?? 'processing',
      errorCode: json['error_code'] as String?,
      errorMessage: json['error_message'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())?.toUtc() ??
                DateTime.now().toUtc()
          : DateTime.now().toUtc(),
      finishedAt: json['finished_at'] != null
          ? DateTime.tryParse(json['finished_at'].toString())?.toUtc()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'generation_id': generationId,
    'request_id': requestId,
    'user_message_id': userMessageId,
    'assistant_message_id': assistantMessageId,
    'status': status,
    'error_code': errorCode,
    'error_message': errorMessage,
    'created_at': createdAt.toIso8601String(),
    'finished_at': finishedAt?.toIso8601String(),
  };
}

/// Individual conversation summary item returned in history listings.
class AiConversationDto {
  final String chatId;
  final String title;
  final DateTime? updatedAt;
  final AiGenerationDto? generation;

  const AiConversationDto({
    required this.chatId,
    this.title = '',
    this.updatedAt,
    this.generation,
  });

  factory AiConversationDto.fromJson(Map<String, dynamic> json) {
    return AiConversationDto(
      chatId: json['chat_id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())?.toUtc()
          : null,
      generation: json['generation'] is Map<String, dynamic>
          ? AiGenerationDto.fromJson(json['generation'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'chat_id': chatId,
    'title': title,
    'updated_at': updatedAt?.toIso8601String(),
    if (generation != null) 'generation': generation!.toJson(),
  };
}

/// Paginated conversation list response.
class AiConversationListDto {
  final List<AiConversationDto> items;
  final String? nextCursor;

  const AiConversationListDto({required this.items, this.nextCursor});

  factory AiConversationListDto.fromJson(Map<String, dynamic> json) {
    final list = json['items'] as List<dynamic>? ?? [];
    return AiConversationListDto(
      items: list
          .whereType<Map<String, dynamic>>()
          .map(AiConversationDto.fromJson)
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );
  }
}

/// A persisted chat message (user query or assistant response).
class AiMessageDto {
  final String messageId;
  final String role;
  final String messageType;
  final String content;
  final List<dynamic> citations;
  final dynamic quiz;
  final DateTime createdAt;
  final AiGenerationDto? generation;

  const AiMessageDto({
    required this.messageId,
    required this.role,
    this.messageType = 'text',
    required this.content,
    this.citations = const [],
    this.quiz,
    required this.createdAt,
    this.generation,
  });

  bool get isUser => role.toLowerCase() == 'user';
  bool get isAssistant => role.toLowerCase() == 'assistant';

  factory AiMessageDto.fromJson(Map<String, dynamic> json) {
    return AiMessageDto(
      messageId: json['message_id']?.toString() ?? '',
      role: json['role'] as String? ?? 'user',
      messageType: json['message_type'] as String? ?? 'text',
      content: json['content'] as String? ?? '',
      citations: json['citations'] as List<dynamic>? ?? const [],
      quiz: json['quiz'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())?.toUtc() ??
                DateTime.now().toUtc()
          : DateTime.now().toUtc(),
      generation: json['generation'] is Map<String, dynamic>
          ? AiGenerationDto.fromJson(json['generation'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'message_id': messageId,
    'role': role,
    'message_type': messageType,
    'content': content,
    'citations': citations,
    'quiz': quiz,
    'created_at': createdAt.toIso8601String(),
    if (generation != null) 'generation': generation!.toJson(),
  };
}

/// Paginated message list response.
class AiMessageListDto {
  final List<AiMessageDto> items;
  final String? nextCursor;

  const AiMessageListDto({required this.items, this.nextCursor});

  factory AiMessageListDto.fromJson(Map<String, dynamic> json) {
    final list = json['items'] as List<dynamic>? ?? [];
    return AiMessageListDto(
      items: list
          .whereType<Map<String, dynamic>>()
          .map(AiMessageDto.fromJson)
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );
  }
}

/// Synchronous response or SSE done payload returned on turn completion.
class AiChatTurnResponseDto {
  final String? answer;
  final String chatId;
  final String title;
  final AiGenerationDto generation;

  const AiChatTurnResponseDto({
    this.answer,
    required this.chatId,
    required this.title,
    required this.generation,
  });

  factory AiChatTurnResponseDto.fromJson(Map<String, dynamic> json) {
    return AiChatTurnResponseDto(
      answer: json['answer'] as String?,
      chatId: json['chat_id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      generation: json['generation'] is Map<String, dynamic>
          ? AiGenerationDto.fromJson(json['generation'] as Map<String, dynamic>)
          : AiGenerationDto(
              generationId: '',
              requestId: '',
              userMessageId: '',
              status: 'processing',
              createdAt: DateTime.now().toUtc(),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    'answer': answer,
    'chat_id': chatId,
    'title': title,
    'generation': generation.toJson(),
  };
}

/// Normalized quota or validation error details from LearnLens.
class AiChatQuotaErrorDto {
  final String code;
  final String message;
  final int? limit;
  final DateTime? retryAt;

  const AiChatQuotaErrorDto({
    required this.code,
    required this.message,
    this.limit,
    this.retryAt,
  });

  factory AiChatQuotaErrorDto.fromDetail(dynamic detail) {
    if (detail is Map<String, dynamic>) {
      final code = detail['code']?.toString() ?? 'unknown_error';
      final message = detail['message']?.toString() ?? 'An error occurred';
      final limit = (detail['limit'] as num?)?.toInt();
      final retryAt = detail['retry_at'] != null
          ? DateTime.tryParse(detail['retry_at'].toString())?.toUtc()
          : null;
      return AiChatQuotaErrorDto(
        code: code,
        message: message,
        limit: limit,
        retryAt: retryAt,
      );
    } else if (detail is String) {
      return AiChatQuotaErrorDto(code: 'error', message: detail);
    } else if (detail is List && detail.isNotEmpty) {
      final first = detail.first;
      if (first is Map<String, dynamic>) {
        final msg = first['msg']?.toString() ?? 'Validation error';
        final loc = (first['loc'] as List?)?.join('.') ?? '';
        return AiChatQuotaErrorDto(
          code: 'validation_error',
          message: loc.isNotEmpty ? '$msg ($loc)' : msg,
        );
      }
    }
    return const AiChatQuotaErrorDto(
      code: 'unknown_error',
      message: 'An unexpected error occurred.',
    );
  }
}

/// Represents a query submission in progress, used for safe idempotency replays.
class PendingTurnRequest {
  final String requestId;
  final String? chatId;
  final String query;
  final DateTime createdAt;

  const PendingTurnRequest({
    required this.requestId,
    this.chatId,
    required this.query,
    required this.createdAt,
  });

  bool get isFirstMessage => chatId == null || chatId!.isEmpty;
}

/// Normalized result of loading a paginated page of conversation messages.
class AiMessagePageResult {
  final List<AiMessageDto> items;
  final String? nextCursor;
  final bool hasMore;

  const AiMessagePageResult({required this.items, this.nextCursor})
    : hasMore = nextCursor != null && nextCursor.length > 0;
}

/// Kinds of server-sent events emitted by the LearnLens streaming routes.
enum AiChatStreamEventType {
  /// The turn was accepted; carries the IDs and provisional title.
  accepted,

  /// A piece of answer text to append to the provisional answer.
  delta,

  /// The stream has ended; carries the authoritative turn state.
  done,

  /// The server could not finish the stream; the saved outcome is unknown.
  error,
}

/// One parsed event from `POST /stream/` endpoint
class AiChatStreamEvent {
  final AiChatStreamEventType type;

  /// Turn payload for [AiChatStreamEventType.accepted] and
  /// [AiChatStreamEventType.done].
  final AiChatTurnResponseDto? turn;

  /// Text piece for [AiChatStreamEventType.delta].
  final String text;

  /// Machine-readable code for [AiChatStreamEventType.error].
  final String? errorCode;

  /// Human-readable explanation for [AiChatStreamEventType.error].
  final String? errorMessage;

  const AiChatStreamEvent._({
    required this.type,
    this.turn,
    this.text = '',
    this.errorCode,
    this.errorMessage,
  });

  const AiChatStreamEvent.accepted(AiChatTurnResponseDto turn)
    : this._(type: AiChatStreamEventType.accepted, turn: turn);

  const AiChatStreamEvent.delta(String text)
    : this._(type: AiChatStreamEventType.delta, text: text);

  const AiChatStreamEvent.done(AiChatTurnResponseDto turn)
    : this._(type: AiChatStreamEventType.done, turn: turn);

  const AiChatStreamEvent.error({String? code, String? message})
    : this._(
        type: AiChatStreamEventType.error,
        errorCode: code,
        errorMessage: message,
      );

  bool get isAccepted => type == AiChatStreamEventType.accepted;
  bool get isDelta => type == AiChatStreamEventType.delta;
  bool get isDone => type == AiChatStreamEventType.done;
  bool get isError => type == AiChatStreamEventType.error;

  /// Whether this stream event terminates the stream.
  bool get isTerminal => isDone || isError;

  /// Builds an event from an SSE `event` name and already-decoded JSON `data`.
  ///
  /// Returns null for unknown event names so callers can ignore them.
  /// Throws [FormatException] when the payload shape does not match the
  /// documented contract.
  static AiChatStreamEvent? fromJson(String eventName, Object? data) {
    switch (eventName) {
      case 'accepted':
        return AiChatStreamEvent.accepted(
          AiChatTurnResponseDto.fromJson(_requireMap(data, eventName)),
        );
      case 'delta':
        final map = _requireMap(data, eventName);
        final text = map['text'];
        if (text != null && text is! String) {
          throw FormatException('delta.text must be a string');
        }
        return AiChatStreamEvent.delta((text as String?) ?? '');
      case 'done':
        return AiChatStreamEvent.done(
          AiChatTurnResponseDto.fromJson(_requireMap(data, eventName)),
        );
      case 'error':
        final map = _requireMap(data, eventName);
        return AiChatStreamEvent.error(
          code: map['code']?.toString(),
          message: map['message']?.toString(),
        );
      default:
        return null;
    }
  }

  static Map<String, dynamic> _requireMap(Object? data, String eventName) {
    if (data is Map<String, dynamic>) return data;
    throw FormatException('$eventName payload must be a JSON object');
  }
}
