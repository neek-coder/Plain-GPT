import '/core/entities/text_generation_model_entity.dart';
export '/core/entities/text_generation_model_entity.dart';

final class TextGenerationModelViewModel {
  final TextGenerationModelInstance instance;
  final TextGenerationModelVersion version;
  final String apiKey;

  const TextGenerationModelViewModel(
      {required this.instance, required this.version, required this.apiKey});

  TextGenerationModelViewModel.fromEntity(TextGenerationModelEntity entity)
      : instance = entity.instance,
        version = entity.version,
        apiKey = entity.apiKey;

  TextGenerationModelEntity toEntity() => TextGenerationModelEntity(
      instance: instance, version: version, apiKey: apiKey);

  TextGenerationModelViewModel copyWith({
    TextGenerationModelInstance? instance,
    TextGenerationModelVersion? version,
    String? apiKey,
  }) =>
      TextGenerationModelViewModel(
        instance: instance ?? this.instance,
        version: version ?? this.version,
        apiKey: apiKey ?? this.apiKey,
      );
}
