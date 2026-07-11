class CustomTestLimitsDto {
  final int maxQuestionsPerTest;
  final int dailyAttemptsAvailable;
  final int monthlyAttemptsAvailable;

  const CustomTestLimitsDto({
    required this.maxQuestionsPerTest,
    required this.dailyAttemptsAvailable,
    required this.monthlyAttemptsAvailable,
  });

  factory CustomTestLimitsDto.fromJson(Map<String, dynamic> json) {
    return CustomTestLimitsDto(
      maxQuestionsPerTest: json['max_questions_per_test'] as int? ?? 50,
      dailyAttemptsAvailable: json['daily_attempts_available'] as int? ?? 0,
      monthlyAttemptsAvailable: json['monthly_attempts_available'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'max_questions_per_test': maxQuestionsPerTest,
      'daily_attempts_available': dailyAttemptsAvailable,
      'monthly_attempts_available': monthlyAttemptsAvailable,
    };
  }
}

class CustomTestFilterOptionDto {
  final String value;
  final String label;

  const CustomTestFilterOptionDto({required this.value, required this.label});

  factory CustomTestFilterOptionDto.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return CustomTestFilterOptionDto(
        value: (json['value'] ?? json['id'])?.toString() ?? '',
        label: (json['label'] ?? json['name'])?.toString() ?? '',
      );
    } else {
      return CustomTestFilterOptionDto(
        value: json.toString(),
        label: json.toString(),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {'value': value, 'label': label};
  }
}

class CustomTestConfigDto {
  final List<CustomTestFilterOptionDto> subjects;
  final List<CustomTestFilterOptionDto> difficultyLevels;
  final List<CustomTestFilterOptionDto> questionTypes;
  final List<CustomTestFilterOptionDto> testModes;
  final CustomTestLimitsDto limits;

  const CustomTestConfigDto({
    this.subjects = const [],
    this.difficultyLevels = const [],
    this.questionTypes = const [],
    this.testModes = const [],
    required this.limits,
  });

  factory CustomTestConfigDto.fromJson(Map<String, dynamic> json) {
    return CustomTestConfigDto(
      subjects: _parseOptionsList(json['subjects']),
      difficultyLevels: _parseOptionsList(json['difficulty_levels']),
      questionTypes: _parseOptionsList(json['question_types']),
      testModes: _parseOptionsList(json['test_modes']),
      limits: CustomTestLimitsDto.fromJson(
        (json['limits'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }

  static List<CustomTestFilterOptionDto> _parseOptionsList(dynamic value) {
    if (value == null) return const [];
    if (value is List) {
      return value.map((e) => CustomTestFilterOptionDto.fromJson(e)).toList();
    }
    return const [];
  }

  Map<String, dynamic> toJson() {
    return {
      'subjects': subjects,
      'difficulty_levels': difficultyLevels,
      'question_types': questionTypes,
      'test_modes': testModes,
      'limits': limits.toJson(),
    };
  }
}
