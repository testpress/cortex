import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/questionnaire_block.dart';

part 'custom_exam_builder_provider.g.dart';

class CustomExamBuilderState {
  final List<QuestionnaireBlock> blocks;
  final int? currentParentSubjectId;

  const CustomExamBuilderState({
    this.blocks = const [],
    this.currentParentSubjectId,
  });

  CustomExamBuilderState copyWith({
    List<QuestionnaireBlock>? blocks,
    int? currentParentSubjectId,
    bool clearParentSubject = false,
  }) {
    return CustomExamBuilderState(
      blocks: blocks ?? this.blocks,
      currentParentSubjectId: clearParentSubject
          ? null
          : (currentParentSubjectId ?? this.currentParentSubjectId),
    );
  }
}

@riverpod
class CustomExamBuilder extends _$CustomExamBuilder {
  @override
  CustomExamBuilderState build(String courseId) {
    return const CustomExamBuilderState();
  }

  void addBlock(QuestionnaireBlock block) {
    state = state.copyWith(
      blocks: [...state.blocks, block],
      clearParentSubject: true, // reset drill down when added
    );
  }

  void removeBlock(int index) {
    if (index >= 0 && index < state.blocks.length) {
      final newBlocks = List<QuestionnaireBlock>.from(state.blocks)
        ..removeAt(index);
      state = state.copyWith(blocks: newBlocks);
    }
  }

  void navigateToParentSubject(int parentId) {
    state = state.copyWith(currentParentSubjectId: parentId);
  }

  void resetDrillDown() {
    state = state.copyWith(clearParentSubject: true);
  }

  /// Implements subject ID resolution logic based on the spec:
  /// - Root "All" -> empty list []
  /// - Parent-level "All" -> [parentId]
  /// - Specific leaf subject -> [subjectId]
  List<int> resolveSubjectIds({
    required bool isAllSelected,
    int? selectedSubjectId,
  }) {
    if (isAllSelected) {
      if (state.currentParentSubjectId == null) {
        return [];
      } else {
        return [state.currentParentSubjectId!];
      }
    } else if (selectedSubjectId != null) {
      return [selectedSubjectId];
    }
    return [];
  }
}
