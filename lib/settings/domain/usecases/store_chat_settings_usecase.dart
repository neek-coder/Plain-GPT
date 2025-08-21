import 'dart:async';

import '/core/entities/usecase.dart';
import '/settings/domain/entities/chat_settings_entity.dart';
import '/settings/domain/repositories/settings_repository_interface.dart';

final class StoreChatSettingsRequest {
  final int chatId;
  final ChatSettingsEntity settings;

  const StoreChatSettingsRequest(
      {required this.chatId, required this.settings});
}

final class StoreChatSettingsUsecase
    implements UseCase<void, StoreChatSettingsRequest> {
  final SettingsRepositoryIntf repository;

  const StoreChatSettingsUsecase({required this.repository});

  @override
  FutureOr<void> call(StoreChatSettingsRequest request) =>
      repository.storeChatSettings(request.chatId, request.settings);
}
