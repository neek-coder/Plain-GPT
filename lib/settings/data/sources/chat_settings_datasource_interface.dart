import 'dart:async';

import '../models/chat_settiings_data_model.dart';

abstract interface class ChatSettingsDatasourceIntf {
  FutureOr<ChatSettingsDataModel?> readChatSettings(int chatId);
  FutureOr<void> storeChatSettings(int chatId, ChatSettingsDataModel settings);
}
