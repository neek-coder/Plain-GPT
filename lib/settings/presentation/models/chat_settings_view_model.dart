import 'package:equatable/equatable.dart';

import '/settings/domain/entities/chat_settings_entity.dart';

export '/settings/domain/entities/chat_settings_entity.dart';

final class ChatSettingsViewModel extends Equatable {
  final ContextBuffer contextBuffer;
  final double temperature;

  const ChatSettingsViewModel({
    required this.contextBuffer,
    required this.temperature,
  });

  const ChatSettingsViewModel.defaultConfiguration()
      : contextBuffer = const SmallContextBuffer(),
        temperature = 0.5;

  ChatSettingsViewModel.fromEntity(ChatSettingsEntity entity)
      : contextBuffer = entity.contextBuffer,
        temperature = entity.temperature;

  ChatSettingsEntity toEntity() => ChatSettingsEntity(
        contextBuffer: contextBuffer,
        temperature: temperature,
      );

  ChatSettingsViewModel copyWith(
          {ContextBuffer? contextBuffer, double? temperature}) =>
      ChatSettingsViewModel(
        contextBuffer: contextBuffer ?? this.contextBuffer,
        temperature: temperature ?? this.temperature,
      );

  @override
  List<Object?> get props => [contextBuffer, temperature];
}
