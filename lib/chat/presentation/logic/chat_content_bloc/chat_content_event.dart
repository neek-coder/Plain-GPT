part of 'chat_content_bloc.dart';

sealed class ChatContentEvent {
  const ChatContentEvent();
}

final class ChatContentLoadEvent extends ChatContentEvent {
  final ChatViewModel chat;

  const ChatContentLoadEvent({required this.chat});
}

final class OpenQuickChatEvent extends ChatContentEvent {}

final class ChatContentUnloadEvent extends ChatContentEvent {}

final class ChatContentRenameEvent extends ChatContentEvent {
  final int chatId;
  final String oldName;
  final String newName;

  const ChatContentRenameEvent({
    required this.chatId,
    required this.oldName,
    required this.newName,
  });
}
