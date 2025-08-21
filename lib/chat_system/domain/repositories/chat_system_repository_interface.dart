import '../entities/chat_system_entity.dart';

abstract interface class ChatSystemRepositoryIntf {
  Future<ChatSystemEntity> readChatSystem();
  Future<void> storeChatSystem(ChatSystemEntity system);
}
