import 'package:my_gpt_client/chat/domain/entities/chat_content_entity.dart';

import '/core/entities/chat_role.dart';

final class ChatMessageDataModel {
  final String message;
  final ChatRole role;

  const ChatMessageDataModel({
    required this.message,
    required this.role,
  });

  ChatMessageDataModel.fromEntity(ChatMessageEntity entity)
      : message = entity.message,
        role = entity.role;

  ChatMessageEntity toEntity() =>
      ChatMessageEntity(message: message, role: role);
}

final class ChatContentDataModel {
  final int chatId;
  final List<ChatMessageDataModel> content = [];

  ChatContentDataModel(
      {required this.chatId, required List<ChatMessageDataModel> content}) {
    this.content.addAll(content);
  }

  ChatContentDataModel.fromEntity(ChatContentEntity content)
      : chatId = content.chatId {
    this.content.addAll(content.content.map((m) => ChatMessageDataModel(
          message: m.message,
          role: m.role,
        )));
  }

  ChatMessageDataModel messageAt(int index) {
    if (index < 0 || index >= content.length) {
      throw Exception(
        'Invalid index - $index. Index must be in the range from 0 to ${content.length}',
      );
    }

    return content[index];
  }

  ChatContentEntity toEntity() => ChatContentEntity(
        chatId: chatId,
        content: content.map((m) => m.toEntity()).toList(),
      );
}
