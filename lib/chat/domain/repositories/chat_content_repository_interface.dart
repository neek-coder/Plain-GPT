import '../entities/chat_content_entity.dart';

abstract interface class ChatContentRepositoryIntf {
  Future<ChatContentEntity?> getContentFor(int chatId);
  Future<void> updateCotentFor(int chatId, ChatContentEntity content);
  Future<void> removeContentFor(int chatId);
}
