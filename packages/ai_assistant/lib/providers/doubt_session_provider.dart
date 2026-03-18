import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ai_models.dart';

class DoubtSessionState {
  final List<AIChatSession> history;
  final String? activeSessionId;
  final bool isThinking;

  DoubtSessionState({
    required this.history,
    this.activeSessionId,
    required this.isThinking,
  });

  AIChatSession? get activeSession {
    final currentId = activeSessionId;
    if (currentId == null) return null;

    // Using a manual loop to avoid any potential FirstWhere/Iterable issues
    for (final session in history) {
      if (session.id == currentId) return session;
    }
    return null;
  }

  DoubtSessionState copyWith({
    List<AIChatSession>? history,
    String? activeSessionId,
    bool? isThinking,
  }) {
    return DoubtSessionState(
      history: history ?? this.history,
      activeSessionId: activeSessionId ?? this.activeSessionId,
      isThinking: isThinking ?? this.isThinking,
    );
  }

  static DoubtSessionState initial() {
    return DoubtSessionState(history: const [], isThinking: false);
  }
}

class DoubtSessionNotifier extends StateNotifier<DoubtSessionState> {
  DoubtSessionNotifier() : super(DoubtSessionState.initial());

  List<AIChatSession> _sortHistory(List<AIChatSession> sessions) {
    final sorted = [...sessions];
    sorted.sort((a, b) {
      if (a.isPinned != b.isPinned) {
        return a.isPinned ? -1 : 1;
      }
      return b.createdAt.compareTo(a.createdAt);
    });
    return sorted;
  }

  void createNewChat({required String newChatTitle}) {
    // Re-use existing empty chat if it exists
    for (final session in state.history) {
      if (session.messages.isEmpty) {
        state = state.copyWith(activeSessionId: session.id, isThinking: false);
        return;
      }
    }

    final newSession = AIChatSession(
      id: 'chat_${DateTime.now().microsecondsSinceEpoch}_${state.history.length}',
      title: newChatTitle,
      messages: const [],
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      history: _sortHistory([newSession, ...state.history]),
      activeSessionId: newSession.id,
      isThinking: false,
    );
  }

  void selectSession(String sessionId) {
    state = state.copyWith(activeSessionId: sessionId, isThinking: false);
  }

  void sendMessage(
    String content, {
    required String newChatTitle,
    required String defaultResponse,
    String? assistantResponse,
  }) {
    if (state.activeSessionId == null) {
      createNewChat(newChatTitle: newChatTitle);
    }

    final activeSession = state.activeSession;
    if (activeSession == null) return;

    final userMessage = AIMessage(
      id: 'msg_u_${DateTime.now().microsecondsSinceEpoch}_${activeSession.messages.length}',
      content: content,
      role: AIMessageRole.user,
      timestamp: DateTime.now(),
    );

    final updatedMessages = [...activeSession.messages, userMessage];
    String updatedTitle = activeSession.title;
    if (activeSession.messages.isEmpty) {
      updatedTitle = content.length > 30
          ? '${content.substring(0, 30)}...'
          : content;
    }

    final updatedSession = activeSession.copyWith(
      messages: updatedMessages,
      title: updatedTitle,
    );

    state = state.copyWith(
      history: _sortHistory(
        state.history
            .map((s) => s.id == updatedSession.id ? updatedSession : s)
            .toList(),
      ),
      isThinking: true,
    );

    Future.delayed(const Duration(seconds: 2), () {
      final aiMessage = AIMessage(
        id: 'msg_a_${DateTime.now().microsecondsSinceEpoch}',
        content: assistantResponse ?? defaultResponse,
        role: AIMessageRole.assistant,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        history: _sortHistory(
          state.history.map((s) {
            if (s.id == updatedSession.id) {
              return s.copyWith(messages: [...s.messages, aiMessage]);
            }
            return s;
          }).toList(),
        ),
        isThinking: false,
      );
    });
  }

  void addImageMessage(
    String imageUrl,
    String content, {
    required String newChatTitle,
    required String imageResponse,
  }) {
    if (state.activeSessionId == null) {
      createNewChat(newChatTitle: newChatTitle);
    }

    final activeSession = state.activeSession;
    if (activeSession == null) return;

    final userMessage = AIMessage(
      id: 'msg_img_${DateTime.now().microsecondsSinceEpoch}_${activeSession.messages.length}',
      content: content,
      role: AIMessageRole.user,
      timestamp: DateTime.now(),
      imageUrl: imageUrl,
    );

    final updatedTitle = activeSession.messages.isEmpty
        ? (content.length > 30 ? '${content.substring(0, 30)}...' : content)
        : activeSession.title;

    final updatedSession = activeSession.copyWith(
      messages: [...activeSession.messages, userMessage],
      title: updatedTitle,
    );

    state = state.copyWith(
      history: _sortHistory(
        state.history
            .map((s) => s.id == updatedSession.id ? updatedSession : s)
            .toList(),
      ),
      isThinking: true,
    );

    Future.delayed(const Duration(seconds: 2), () {
      final aiMessage = AIMessage(
        id: 'msg_a_img_${DateTime.now().microsecondsSinceEpoch}',
        content: imageResponse,
        role: AIMessageRole.assistant,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        history: _sortHistory(
          state.history.map((s) {
            if (s.id == updatedSession.id) {
              return s.copyWith(messages: [...s.messages, aiMessage]);
            }
            return s;
          }).toList(),
        ),
        isThinking: false,
      );
    });
  }

  void togglePinSession(String sessionId) {
    state = state.copyWith(
      history: _sortHistory(
        state.history.map((s) {
          if (s.id == sessionId) {
            return s.copyWith(isPinned: !s.isPinned);
          }
          return s;
        }).toList(),
      ),
    );
  }

  void renameSession(String sessionId, String newTitle) {
    state = state.copyWith(
      history: _sortHistory(
        state.history
            .map((s) => s.id == sessionId ? s.copyWith(title: newTitle) : s)
            .toList(),
      ),
    );
  }

  void deleteSession(String sessionId) {
    final newHistory = _sortHistory(
      state.history.where((s) => s.id != sessionId).toList(),
    );
    String? newActiveId = state.activeSessionId;
    if (newActiveId == sessionId) {
      newActiveId = newHistory.isNotEmpty ? newHistory.first.id : null;
    }
    state = state.copyWith(history: newHistory, activeSessionId: newActiveId);
  }

  void clearSession() {
    final activeSession = state.activeSession;
    if (activeSession != null) {
      final clearedSession = activeSession.copyWith(messages: const []);
      state = state.copyWith(
        history: _sortHistory(
          state.history
              .map((s) => s.id == clearedSession.id ? clearedSession : s)
              .toList(),
        ),
        isThinking: false,
      );
    }
  }
}

final doubtSessionProvider =
    StateNotifierProvider<DoubtSessionNotifier, DoubtSessionState>((ref) {
      return DoubtSessionNotifier();
    });
