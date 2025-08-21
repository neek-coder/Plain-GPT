part of 'chat_settings_bloc.dart';

sealed class ChatSettingsEvent {
  const ChatSettingsEvent();
}

final class ChatSettingsLoadStartEvent extends ChatSettingsEvent {
  final int chatId;

  const ChatSettingsLoadStartEvent(this.chatId);
}

final class ChatSettingsLoadFinishEvent extends ChatSettingsEvent {
  final int chatId;
  final ChatSettingsViewModel settings;

  const ChatSettingsLoadFinishEvent(
      {required this.chatId, required this.settings});
}

final class ChatSettingsSaveEvent extends ChatSettingsEvent {
  final int chatId;
  final ChatSettingsViewModel settings;

  const ChatSettingsSaveEvent({
    required this.chatId,
    required this.settings,
  });
}

final class ChatSettingsUpdateEvent extends ChatSettingsEvent {
  final ChatSettingsViewModel settings;

  const ChatSettingsUpdateEvent(this.settings);
}

final class LoadQuickChatSettings extends ChatSettingsEvent {}

final class QuickChatSettingsUpdateEvent extends ChatSettingsEvent {
  final ChatSettingsViewModel settings;

  const QuickChatSettingsUpdateEvent(this.settings);
}
