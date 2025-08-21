import '../models/text_generation_api_data_models.dart';

abstract interface class TextGenerationModelDatasourceInterface {
  Future<void> init();
  Stream<TextGenerationResponseDataModel> generateText(
      TextGenerationRequestDataModel request);
}
