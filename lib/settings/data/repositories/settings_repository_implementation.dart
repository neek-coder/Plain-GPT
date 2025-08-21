import 'dart:async';

import '../models/global_settings_data_model.dart';
import '/settings/data/sources/chat_settings_datasource_interface.dart';
import '/settings/data/models/chat_settiings_data_model.dart';
import '/settings/data/sources/global_settings_datasource_interface.dart';
import '/settings/domain/entities/chat_settings_entity.dart';

import 'package:my_gpt_client/settings/domain/entities/global_settings_entity.dart';

import '/settings/domain/repositories/settings_repository_interface.dart';

final class SettingsRepositoryImpl implements SettingsRepositoryIntf {
  final ChatSettingsDatasourceIntf chatSettingsDatasource;
  final GlobalSettingsDatasourceIntf globalSettingsDatasource;

  GlobalSettingsEntity? _globalSettings;
  ChatSettingsEntity? _currentChatSettings;

  @override
  GlobalSettingsEntity? get globalSettings => _globalSettings;

  @override
  ChatSettingsEntity? get currentChatSettings => _currentChatSettings;

  SettingsRepositoryImpl({
    required this.chatSettingsDatasource,
    required this.globalSettingsDatasource,
  });

  @override
  FutureOr<ChatSettingsEntity?> readChatSettings(int chatId) async {
    _currentChatSettings = null;
    final settings = await chatSettingsDatasource.readChatSettings(chatId);
    _currentChatSettings = settings?.toEntity();

    return settings?.toEntity();
  }

  @override
  FutureOr<GlobalSettingsEntity?> readGlobalSettings() async {
    final settings = await globalSettingsDatasource.readGlobalSettings();

    if (_globalSettings == null && settings != null) {
      _globalSettings = settings.toEntity();
    }

    return settings?.toEntity();
  }

  @override
  Future<void> storeChatSettings(
      int chatId, ChatSettingsEntity settings) async {
    _currentChatSettings = settings;

    await chatSettingsDatasource.storeChatSettings(
        chatId, ChatSettingsDataModel.fromEntity(settings));
  }

  @override
  Future<void> storeGlobalSettings(GlobalSettingsEntity settings) async {
    _globalSettings = settings;

    await globalSettingsDatasource
        .storeGlobalSettings(GlobalSettingsDataModel.fromEntity(settings));
  }
}
