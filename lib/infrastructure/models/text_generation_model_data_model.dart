import 'package:my_gpt_client/core/entities/text_generation_model_entity.dart';

final class TextGenerationModelDataModel {
  final TextGenerationModelInstance instance;
  final TextGenerationModelVersion version;
  final String apiKey;

  const TextGenerationModelDataModel({
    required this.instance,
    required this.version,
    required this.apiKey,
  });

  TextGenerationModelDataModel.fromEntity(TextGenerationModelEntity entity)
      : instance = entity.instance,
        version = entity.version,
        apiKey = entity.apiKey;

  TextGenerationModelEntity toEntity() => TextGenerationModelEntity(
        instance: instance,
        version: version,
        apiKey: apiKey,
      );
}
