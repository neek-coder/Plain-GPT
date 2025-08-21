import 'package:my_gpt_client/infrastructure/models/text_generation_model_data_model.dart';

import '../../domain/entities/text_generation_api_entity.dart';
import 'chat_content_data_model.dart';

final class TextGenerationRequestDataModel {
  final List<ChatMessageDataModel>? context;
  final TextGenerationModelDataModel model;
  final double temperature;
  final String prompt;

  const TextGenerationRequestDataModel({
    required this.prompt,
    required this.model,
    this.context,
    this.temperature = 0.5,
  }) : assert(temperature >= 0 && temperature <= 1);

  TextGenerationRequestDataModel.fromEntity(TextGenerationRequestEntity entity)
      : prompt = entity.prompt,
        model = TextGenerationModelDataModel.fromEntity(entity.model),
        context = entity.context
            ?.map((e) => ChatMessageDataModel.fromEntity(e))
            .toList(),
        temperature = entity.temperature;

  TextGenerationRequestEntity toEntity() => TextGenerationRequestEntity(
        prompt: prompt,
        model: model.toEntity(),
        context: context?.map((e) => e.toEntity()).toList(),
        temperature: temperature,
      );
}

final class TextGenerationResponseDataModel {
  final String chunk;

  const TextGenerationResponseDataModel({required this.chunk});

  TextGenerationResponseDataModel.fromEntity(
      TextGenerationResponseEntity entity)
      : chunk = entity.chunk;

  TextGenerationResponseEntity toEntity() =>
      TextGenerationResponseEntity(chunk: chunk);
}
