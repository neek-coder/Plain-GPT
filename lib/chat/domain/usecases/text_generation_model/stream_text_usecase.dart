import 'dart:async';

import '/core/entities/usecase.dart';

import '../../entities/text_generation_api_entity.dart';
import '../../repositories/text_generation_model_repository_interface.dart';

final class StreamTextUsecase
    implements
        UseCase<Stream<TextGenerationResponseEntity>,
            TextGenerationRequestEntity> {
  final TextGenerationModelRepositoryIntf repository;

  const StreamTextUsecase(this.repository);

  @override
  FutureOr<Stream<TextGenerationResponseEntity>> call(
          TextGenerationRequestEntity request) =>
      repository.textStream(request);
}
