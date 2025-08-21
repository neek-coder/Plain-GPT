import 'package:my_gpt_client/chat/data/models/chat_content_data_model.dart';
import 'package:my_gpt_client/chat/data/sources/chat_content_datasource_interface.dart';

import '../../domain/repositories/chat_content_repository_interface.dart';
import '../../domain/entities/chat_content_entity.dart';

final class ChatContentRepositoryImpl implements ChatContentRepositoryIntf {
  final ChatContentDatasuorceInterface dataSource;

  const ChatContentRepositoryImpl(this.dataSource);

  @override
  Future<ChatContentEntity?> getContentFor(int chatId) async {
    final storageModel = await dataSource.getContentFor(chatId);

    return storageModel?.toEntity();
  }

  @override
  Future<void> updateCotentFor(int chatId, ChatContentEntity content) async {
    await dataSource.updateCotentFor(
      chatId,
      ChatContentDataModel.fromEntity(content),
    );
  }

  @override
  Future<void> removeContentFor(int chatId) =>
      dataSource.removeContentFor(chatId);
}
