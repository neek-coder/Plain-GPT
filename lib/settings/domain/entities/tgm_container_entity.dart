import 'dart:collection';

import 'package:my_gpt_client/core/entities/text_generation_model_entity.dart';

final class TGMContainerEntity {
  late TextGenerationModelInstance _selection;
  final Map<TextGenerationModelInstance, TextGenerationModelEntity> _container =
      {};

  UnmodifiableMapView<TextGenerationModelInstance, TextGenerationModelEntity>
      get container => UnmodifiableMapView(_container);

  TextGenerationModelInstance get selection => _selection;

  TGMContainerEntity({
    TextGenerationModelInstance? selection,
    Map<TextGenerationModelInstance, TextGenerationModelEntity> data = const {},
  }) {
    for (final i in TextGenerationModelInstance.values) {
      _container[i] = data[i] ??
          TextGenerationModelEntity(
            instance: i,
            version: i.versions.first,
            apiKey: '',
          );
    }

    _selection = selection ?? _container.keys.first;
  }

  TextGenerationModelEntity getSelectedModel() => _container[_selection]!;

  void selectModel(TextGenerationModelInstance selection) =>
      _selection = selection;

  void updateModel(TextGenerationModelEntity model) =>
      _container[model.instance] = model;
}
