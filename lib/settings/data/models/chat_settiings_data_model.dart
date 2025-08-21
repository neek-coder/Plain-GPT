import 'package:my_gpt_client/settings/domain/entities/chat_settings_entity.dart';

final class ChatSettingsDataModel {
  /// Context buffer size - either non-negative value or -1 (unlimited size)
  final int contextBufferSize;

  final double temperature;

  const ChatSettingsDataModel({
    required this.contextBufferSize,
    required this.temperature,
  }) : assert(contextBufferSize >= -1);

  ChatSettingsDataModel.fromEntity(ChatSettingsEntity entity)
      : contextBufferSize = switch (entity.contextBuffer) {
          UnlimitedContextBuffer() => -1,
          FixedContextBuffer() =>
            (entity.contextBuffer as FixedContextBuffer).size,
        },
        temperature = entity.temperature;

  ChatSettingsEntity toEntity() {
    if (contextBufferSize == -1) {
      return ChatSettingsEntity(
        temperature: temperature,
        contextBuffer: const UnlimitedContextBuffer(),
      );
    } else {
      return ChatSettingsEntity(
        contextBuffer: switch (contextBufferSize) {
          EmptyContextBuffer.staticSize => const EmptyContextBuffer(),
          SmallContextBuffer.staticSize => const SmallContextBuffer(),
          MediumContextBuffer.staticSize => const MediumContextBuffer(),
          LargeContextBuffer.staticSize => const LargeContextBuffer(),
          int() => CustomContextBuffer(contextBufferSize),
        },
        temperature: temperature,
      );
    }
  }
}
