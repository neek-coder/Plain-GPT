import '../models/chat_system_storage_model.dart';

abstract interface class ChatSystemDatasuorceInterface {
  Future<void> init();
  Future<ChatSystemDataModel> readChatSystem();
  Future<void> storeChatSystem(ChatSystemDataModel system);
}
