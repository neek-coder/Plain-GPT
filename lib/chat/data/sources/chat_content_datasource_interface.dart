import '../models/chat_content_data_model.dart';

abstract interface class ChatContentDatasuorceInterface {
  Future<void> init();
  Future<ChatContentDataModel?> getContentFor(int chatId);
  Future<void> updateCotentFor(int chatId, ChatContentDataModel content);
  Future<void> removeContentFor(int chatId);
}
