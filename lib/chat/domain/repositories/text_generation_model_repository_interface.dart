import '../entities/text_generation_api_entity.dart';

abstract interface class TextGenerationModelRepositoryIntf {
  Stream<TextGenerationResponseEntity> textStream(
      TextGenerationRequestEntity request);
}
