import 'tgm_container_entity.dart';

export '/core/entities/text_generation_model_entity.dart';

class GlobalSettingsEntity {
  final TGMContainerEntity modelContainer;

  const GlobalSettingsEntity({required this.modelContainer});

  GlobalSettingsEntity.defaultConfig() : modelContainer = TGMContainerEntity();
}
