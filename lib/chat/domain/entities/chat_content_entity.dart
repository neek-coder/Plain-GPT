import '/core/entities/chat_role.dart';

final class ChatMessageEntity {
  final String message;
  final ChatRole role;

  const ChatMessageEntity({
    required this.message,
    required this.role,
  });
}

final class ChatContentEntity {
  final int chatId;
  final List<ChatMessageEntity> content = [];

  ChatContentEntity(
      {required this.chatId, required List<ChatMessageEntity> content}) {
    this.content.addAll(content);
  }
}
