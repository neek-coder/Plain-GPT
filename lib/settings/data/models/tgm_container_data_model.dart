import 'dart:collection';

import 'package:my_gpt_client/settings/domain/entities/tgm_container_entity.dart';

import '/core/entities/text_generation_model_entity.dart';

import '../../../infrastructure/models/text_generation_model_data_model.dart';

final class TGMContainerDataModel {
  late TextGenerationModelInstance _selection;
  final Map<TextGenerationModelInstance, TextGenerationModelDataModel>
      _container = {};

  UnmodifiableMapView<TextGenerationModelInstance, TextGenerationModelDataModel>
      get container => UnmodifiableMapView(_container);

  TextGenerationModelInstance get selection => _selection;

  TGMContainerDataModel({
    TextGenerationModelInstance? selection,
    Map<TextGenerationModelInstance, TextGenerationModelDataModel> data =
        const {},
  }) {
    for (final i in TextGenerationModelInstance.values) {
      _container[i] = data[i] ??
          TextGenerationModelDataModel(
            instance: i,
            version: i.versions.first,
            apiKey: '',
          );
    }

    _selection = selection ?? _container.keys.first;
  }

  TGMContainerDataModel.fromEntity(TGMContainerEntity entity) {
    for (final i in TextGenerationModelInstance.values) {
      _container[i] = (entity.container[i] != null)
          ? TextGenerationModelDataModel.fromEntity(entity.container[i]!)
          : TextGenerationModelDataModel(
              instance: i,
              version: i.versions.first,
              apiKey: '',
            );
    }

    _selection = entity.selection;
  }

  TGMContainerEntity toEntity() => TGMContainerEntity(
        selection: _selection,
        data: _container.map(
          (key, value) => MapEntry(key, value.toEntity()),
        ),
      );

  TextGenerationModelDataModel getSelectedModel() => _container[_selection]!;

  void selectModel(TextGenerationModelInstance selection) =>
      _selection = selection;

  void updateModel(TextGenerationModelDataModel model) =>
      _container[model.instance] = model;
}
