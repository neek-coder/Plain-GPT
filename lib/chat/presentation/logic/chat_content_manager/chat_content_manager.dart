import 'package:my_gpt_client/chat/domain/usecases/chat_content/read_chat_content_usecase.dart';
import 'package:my_gpt_client/chat/domain/usecases/chat_content/store_chat_content_usecase.dart';
import 'package:my_gpt_client/injector.dart';

import '../../view_models/chat_content_view_model.dart';

final class ChatContentManager {
  Future<ChatContentViewModel?> getCcontentFor(int chatId) async {
    final entity = await g<ReadChatContentUsecase>()(chatId);

    if (entity == null) return null;

    return ChatContentViewModel.fromEntity(entity);
  }

  Future<void> storeCcontentFor(
          int chatId, ChatContentViewModel content) async =>
      g<StoreChatContentUsecase>()(
        StoreChatContentRequest(
          chatId: chatId,
          content: content.toEntity(),
        ),
      );
}
