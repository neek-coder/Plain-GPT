import 'dart:async';

import 'package:my_gpt_client/chat/domain/entities/chat_content_entity.dart';
import 'package:my_gpt_client/chat/domain/repositories/chat_content_repository_interface.dart';

import '/core/entities/usecase.dart';

final class StoreChatContentRequest {
  final int chatId;
  final ChatContentEntity content;

  const StoreChatContentRequest({required this.chatId, required this.content});
}

final class StoreChatContentUsecase
    implements UseCase<void, StoreChatContentRequest> {
  final ChatContentRepositoryIntf repository;

  const StoreChatContentUsecase(this.repository);

  @override
  FutureOr<void> call(StoreChatContentRequest request) =>
      repository.updateCotentFor(request.chatId, request.content);
}
