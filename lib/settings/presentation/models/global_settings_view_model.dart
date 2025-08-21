import 'package:my_gpt_client/settings/presentation/models/tgm_container_view_model.dart';

import '/settings/domain/entities/global_settings_entity.dart';

export '/settings/domain/entities/global_settings_entity.dart';

final class GlobalSettingsViewModel {
  final TGMContainerViewModel modelContainer;

  const GlobalSettingsViewModel({required this.modelContainer});

  GlobalSettingsViewModel.defaultConfiguration()
      : modelContainer = TGMContainerViewModel();

  GlobalSettingsViewModel.fromEntity(GlobalSettingsEntity entity)
      : modelContainer =
            TGMContainerViewModel.fromEntity(entity.modelContainer);

  GlobalSettingsEntity toEntity() =>
      GlobalSettingsEntity(modelContainer: modelContainer.toEntity());

  GlobalSettingsViewModel copyWith({TGMContainerViewModel? modelContainer}) =>
      GlobalSettingsViewModel(
          modelContainer: modelContainer ?? this.modelContainer);
}
