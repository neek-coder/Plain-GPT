import 'dart:async';

import '/core/entities/usecase.dart';
import '/settings/domain/entities/global_settings_entity.dart';
import '/settings/domain/repositories/settings_repository_interface.dart';

final class ReadGlobalSettingsUsecase
    implements UseCase<GlobalSettingsEntity?, void> {
  final SettingsRepositoryIntf repository;

  const ReadGlobalSettingsUsecase({required this.repository});

  @override
  FutureOr<GlobalSettingsEntity?> call(void request) =>
      repository.readGlobalSettings();
}
