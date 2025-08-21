import '/core/entities/text_generation_model_entity.dart';

import 'chat_content_entity.dart';

final class TextGenerationRequestEntity {
  final List<ChatMessageEntity>? context;
  final TextGenerationModelEntity model;
  final double temperature;
  final String prompt;

  const TextGenerationRequestEntity({
    required this.prompt,
    required this.model,
    this.context,
    this.temperature = 0.5,
  }) : assert(temperature >= 0 && temperature <= 1);
}

final class TextGenerationResponseEntity {
  final String chunk;

  const TextGenerationResponseEntity({required this.chunk});
}
