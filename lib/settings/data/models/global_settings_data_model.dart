import 'package:my_gpt_client/settings/data/models/tgm_container_data_model.dart';
import 'package:my_gpt_client/settings/domain/entities/global_settings_entity.dart';

final class GlobalSettingsDataModel {
  final TGMContainerDataModel tgmContainer;

  const GlobalSettingsDataModel({required this.tgmContainer});

  GlobalSettingsDataModel.fromEntity(GlobalSettingsEntity entity)
      : tgmContainer = TGMContainerDataModel.fromEntity(entity.modelContainer);

  GlobalSettingsEntity toEntity() =>
      GlobalSettingsEntity(modelContainer: tgmContainer.toEntity());
}
