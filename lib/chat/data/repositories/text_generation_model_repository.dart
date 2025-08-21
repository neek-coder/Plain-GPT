import 'package:my_gpt_client/chat/data/models/text_generation_api_data_models.dart';

import '../sources/text_generation_model_datasource_interface.dart';
import '../../domain/entities/text_generation_api_entity.dart';

import '../../domain/repositories/text_generation_model_repository_interface.dart';

final class TextGenerationModelRepositoryImpl
    implements TextGenerationModelRepositoryIntf {
  final TextGenerationModelDatasourceInterface dataSource;

  const TextGenerationModelRepositoryImpl(this.dataSource);

  @override
  Stream<TextGenerationResponseEntity> textStream(
          TextGenerationRequestEntity request) =>
      dataSource
          .generateText(TextGenerationRequestDataModel.fromEntity(request))
          .map((m) => m.toEntity());
}
