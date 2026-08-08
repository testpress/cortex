class BPElearnExamResultItemDto {
  final String? date;
  final String? examName;
  final String? physics;
  final String? chemistry;
  final String? biology;
  final String? maths;
  final String? p1;
  final String? p2;
  final String? totalMarks;
  final String? maxMarks;
  final String? highestMarks;
  final String? percent;
  final String? grade;
  final String? rank;
  final String? stuAppeared;
  final String? aptitude;
  final String? drawing;
  final String? type;
  final String? omr;

  BPElearnExamResultItemDto({
    this.date,
    this.examName,
    this.physics,
    this.chemistry,
    this.biology,
    this.maths,
    this.p1,
    this.p2,
    this.totalMarks,
    this.maxMarks,
    this.highestMarks,
    this.percent,
    this.grade,
    this.rank,
    this.stuAppeared,
    this.aptitude,
    this.drawing,
    this.type,
    this.omr,
  });

  factory BPElearnExamResultItemDto.fromJson(Map<String, dynamic> json) {
    return BPElearnExamResultItemDto(
      date: json['date']?.toString(),
      examName: json['examname']?.toString(),
      physics: json['physics']?.toString(),
      chemistry: json['chemistry']?.toString(),
      biology: json['biology']?.toString(),
      maths: json['maths']?.toString(),
      p1: json['p1']?.toString(),
      p2: json['p2']?.toString(),
      totalMarks: json['totalmarks']?.toString(),
      maxMarks: json['maxmarks']?.toString(),
      highestMarks: json['highestmarks']?.toString(),
      percent: json['percent']?.toString(),
      grade: json['grade']?.toString(),
      rank: json['rank']?.toString(),
      stuAppeared: json['stu_appeared']?.toString(),
      aptitude: json['aptitude']?.toString(),
      drawing: json['drawing']?.toString(),
      type: json['type']?.toString(),
      omr: json['omr']?.toString(),
    );
  }
}

class BPElearnPaginatedResponseDto {
  final int totalCount;
  final int currentPage;
  final int limit;
  final List<BPElearnExamResultItemDto> data;

  BPElearnPaginatedResponseDto({
    this.totalCount = 0,
    this.currentPage = 1,
    this.limit = 10,
    this.data = const [],
  });

  factory BPElearnPaginatedResponseDto.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List?;
    List<BPElearnExamResultItemDto> results = [];
    if (dataList != null) {
      results = dataList
          .map((e) => BPElearnExamResultItemDto.fromJson(e))
          .toList();
    }
    return BPElearnPaginatedResponseDto(
      totalCount: int.tryParse(json['total_count']?.toString() ?? '0') ?? 0,
      currentPage: int.tryParse(json['current_page']?.toString() ?? '1') ?? 1,
      limit: int.tryParse(json['limit']?.toString() ?? '10') ?? 10,
      data: results,
    );
  }
}
