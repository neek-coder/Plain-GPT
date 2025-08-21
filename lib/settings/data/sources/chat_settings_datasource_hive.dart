import 'dart:async';

import 'package:hive/hive.dart';
import 'package:my_gpt_client/settings/data/models/chat_settings_data_model_type_adapter.dart';

import '/core/utils/hive_initialization_manager.dart';

import '/settings/data/models/chat_settiings_data_model.dart';
import '/settings/data/sources/chat_settings_datasource_interface.dart';

final class ChatSettingsDatasourceHive implements ChatSettingsDatasourceIntf {
  static const _boxKey = 'chat-settings-box';

  late final Box _box;

  Future<void> init() async {
    await HiveInitializationManager.init();

    Hive.registerAdapter(ChatSettingsDataModelTypeAdapter());

    _box = await Hive.openBox(_boxKey);
  }

  @override
  FutureOr<ChatSettingsDataModel?> readChatSettings(int chatId) =>
      _box.get(chatId);

  @override
  FutureOr<void> storeChatSettings(
      int chatId, ChatSettingsDataModel settings) async {
    await _box.put(chatId, settings);
  }
}
