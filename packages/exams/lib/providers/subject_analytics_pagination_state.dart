class SubjectAnalyticsPaginationState {
  final int currentPage;
  final bool hasMorePages;
  final bool isFetchingNextPage;
  final bool isFetchingInitial;

  SubjectAnalyticsPaginationState({
    required this.currentPage,
    required this.hasMorePages,
    required this.isFetchingNextPage,
    required this.isFetchingInitial,
  });

  SubjectAnalyticsPaginationState copyWith({
    int? currentPage,
    bool? hasMorePages,
    bool? isFetchingNextPage,
    bool? isFetchingInitial,
  }) {
    return SubjectAnalyticsPaginationState(
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      isFetchingNextPage: isFetchingNextPage ?? this.isFetchingNextPage,
      isFetchingInitial: isFetchingInitial ?? this.isFetchingInitial,
    );
  }
}
