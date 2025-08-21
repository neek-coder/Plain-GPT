import 'package:my_gpt_client/chat/domain/entities/chat_content_entity.dart';

import '/core/entities/chat_role.dart';

final class ChatMessageViewModel {
  String message;
  final ChatRole role;

  ChatMessageViewModel({
    required this.message,
    required this.role,
  });

  ChatMessageViewModel.fromEntity(ChatMessageEntity entity)
      : message = entity.message,
        role = entity.role;

  ChatMessageEntity toEntity() =>
      ChatMessageEntity(message: message, role: role);
}

final class ChatContentViewModel {
  final int chatId;
  final List<ChatMessageViewModel> content = [];

  ChatContentViewModel(
      {required this.chatId, required List<ChatMessageViewModel> content}) {
    this.content.addAll(content);
  }

  ChatContentViewModel.fromEntity(ChatContentEntity entity)
      : chatId = entity.chatId {
    content.addAll(
        entity.content.map((e) => ChatMessageViewModel.fromEntity(e)).toList());
  }

  ChatContentEntity toEntity() => ChatContentEntity(
        chatId: chatId,
        content: content.map((e) => e.toEntity()).toList(),
      );
}
