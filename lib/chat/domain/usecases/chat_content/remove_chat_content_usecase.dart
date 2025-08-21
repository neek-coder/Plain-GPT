import 'dart:async';

import 'package:my_gpt_client/chat/domain/repositories/chat_content_repository_interface.dart';

import '/core/entities/usecase.dart';

final class RemoveChatContentRequest {
  final int chatId;

  const RemoveChatContentRequest({required this.chatId});
}

final class RemoveChatContentUsecase
    implements UseCase<void, RemoveChatContentRequest> {
  final ChatContentRepositoryIntf repository;

  const RemoveChatContentUsecase(this.repository);

  @override
  FutureOr<void> call(RemoveChatContentRequest request) =>
      repository.removeContentFor(request.chatId);
}
