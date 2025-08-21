import 'dart:async';

import '/core/entities/usecase.dart';
import '/settings/domain/entities/chat_settings_entity.dart';
import '/settings/domain/repositories/settings_repository_interface.dart';

final class ReadChatSettingsRequest {
  final int chatId;

  const ReadChatSettingsRequest(this.chatId);
}

final class ReadChatSettingsUsecase
    implements UseCase<ChatSettingsEntity?, ReadChatSettingsRequest> {
  final SettingsRepositoryIntf repository;

  const ReadChatSettingsUsecase({required this.repository});

  @override
  FutureOr<ChatSettingsEntity?> call(ReadChatSettingsRequest request) async =>
      repository.readChatSettings(request.chatId);
}
