import 'dart:collection';

import 'package:my_gpt_client/settings/domain/entities/tgm_container_entity.dart';

import 'text_generation_model_view_model.dart';

final class TGMContainerViewModel {
  late TextGenerationModelInstance _selection;
  final Map<TextGenerationModelInstance, TextGenerationModelViewModel>
      _container = {};

  UnmodifiableMapView<TextGenerationModelInstance, TextGenerationModelViewModel>
      get container => UnmodifiableMapView(_container);

  TextGenerationModelInstance get selection => _selection;

  TGMContainerViewModel({
    TextGenerationModelInstance? selection,
    Map<TextGenerationModelInstance, TextGenerationModelViewModel> data =
        const {},
  }) {
    for (final i in TextGenerationModelInstance.values) {
      _container[i] = data[i] ??
          TextGenerationModelViewModel(
            instance: i,
            version: i.versions.first,
            apiKey: '',
          );
    }

    _selection = selection ?? _container.keys.first;
  }

  TGMContainerViewModel.fromEntity(TGMContainerEntity entity) {
    for (final i in TextGenerationModelInstance.values) {
      _container[i] = (entity.container[i] != null)
          ? TextGenerationModelViewModel.fromEntity(entity.container[i]!)
          : TextGenerationModelViewModel(
              instance: i, version: i.versions.first, apiKey: '');
    }

    _selection = entity.selection;
  }

  TGMContainerEntity toEntity() => TGMContainerEntity(
        selection: _selection,
        data: _container.map(
          (key, value) => MapEntry(key, value.toEntity()),
        ),
      );

  TextGenerationModelViewModel getSelectedModel() => _container[_selection]!;

  void selectModel(TextGenerationModelInstance selection) =>
      _selection = selection;

  void updateModel(TextGenerationModelViewModel model) =>
      _container[model.instance] = model;
}
