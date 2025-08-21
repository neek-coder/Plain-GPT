part of 'chat_settings_bloc.dart';

sealed class ChatSettingsState extends Equatable {
  const ChatSettingsState();
}

final class ChatSettingsInitial extends ChatSettingsState {
  const ChatSettingsInitial();

  @override
  List<Object?> get props => [];
}

final class ChatSettingsLoading extends ChatSettingsState {
  final int chatId;
  const ChatSettingsLoading(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

final class ChatSettingsLoaded extends ChatSettingsState {
  final int chatId;
  final ChatSettingsViewModel settings;

  const ChatSettingsLoaded({required this.settings, required this.chatId});

  @override
  List<Object?> get props => [chatId, settings];
}

final class ChatSettingsSaving extends ChatSettingsState {
  final int chatId;
  final ChatSettingsViewModel settings;

  const ChatSettingsSaving({required this.settings, required this.chatId});

  @override
  List<Object?> get props => [chatId, settings];
}

final class QuickChatSettings extends ChatSettingsState {
  final ChatSettingsViewModel settings;

  const QuickChatSettings({required this.settings});

  @override
  List<Object?> get props => [settings];
}
