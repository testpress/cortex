import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers/generic_ai_chat_provider.dart';
import '../localization/l10n_helper.dart';
import '../widgets/app_confirmation_dialog.dart';
import '../widgets/app_toast.dart';

/// Warns the user with a toast and returns true if [chatId] has an active response generating.
bool _warnIfAiGenerating(
  BuildContext context,
  GenericAiChatState chatState,
  String chatId,
) {
  if (chatState.hasActiveGeneration(chatId)) {
    AppToast.show(
      context,
      message: L10n.of(context).aiCannotDeleteWhileGenerating,
      isError: true,
    );
    return true;
  }
  return false;
}

/// Prompts the user with a confirmation dialog and deletes the conversation if confirmed.
///
/// Returns true if the conversation was deleted successfully.
Future<bool> confirmAndDeleteConversation({
  required BuildContext context,
  required WidgetRef ref,
  required String chatId,
  String? title,
}) async {
  final l10n = L10n.of(context);
  final chatState = ref.read(genericAiChatProvider);
  if (chatState.isDeletingConversation) return false;

  if (_warnIfAiGenerating(context, chatState, chatId)) return false;

  final content = title != null && title.trim().isNotEmpty
      ? l10n.aiDeleteConversationNamedMessage(title)
      : l10n.aiDeleteConversationMessage;

  final confirmed = await showConfirmationDialog(
    context,
    title: l10n.aiDeleteConversationTitle,
    content: content,
    confirmText: l10n.aiDeleteConversationAction,
    cancelText: l10n.labelCancel,
    isDestructive: true,
  );

  if (!confirmed || !context.mounted) return false;

  if (_warnIfAiGenerating(context, ref.read(genericAiChatProvider), chatId)) {
    return false;
  }

  final success = await ref
      .read(genericAiChatProvider.notifier)
      .deleteConversation(chatId);

  if (!context.mounted) return success;

  if (success) {
    AppToast.show(context, message: l10n.aiConversationDeleted);
  } else {
    AppToast.show(
      context,
      message: l10n.aiDeleteConversationFailed,
      isError: true,
    );
  }

  return success;
}
