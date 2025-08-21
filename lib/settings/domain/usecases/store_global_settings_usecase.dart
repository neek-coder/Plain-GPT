import 'dart:async';

import '/core/entities/usecase.dart';
import '/settings/domain/entities/global_settings_entity.dart';
import '/settings/domain/repositories/settings_repository_interface.dart';

final class StoreGlobalSettingsRequest {
  final GlobalSettingsEntity settings;

  const StoreGlobalSettingsRequest(this.settings);
}

final class StoreGlobalSettingsUsecase
    implements UseCase<void, StoreGlobalSettingsRequest> {
  final SettingsRepositoryIntf repository;

  const StoreGlobalSettingsUsecase({required this.repository});

  @override
  FutureOr<void> call(StoreGlobalSettingsRequest request) =>
      repository.storeGlobalSettings(request.settings);
}
