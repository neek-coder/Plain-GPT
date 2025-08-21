import 'dart:async';

import '../entities/global_settings_entity.dart';

import '../entities/chat_settings_entity.dart';

abstract interface class SettingsRepositoryIntf {
  GlobalSettingsEntity? get globalSettings;
  ChatSettingsEntity? get currentChatSettings;

  FutureOr<ChatSettingsEntity?> readChatSettings(int chatId);
  FutureOr<void> storeChatSettings(int chatId, ChatSettingsEntity settings);

  FutureOr<GlobalSettingsEntity?> readGlobalSettings();
  FutureOr<void> storeGlobalSettings(GlobalSettingsEntity settings);
}
