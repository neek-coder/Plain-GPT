import 'dart:async';

import '/core/entities/usecase.dart';
import '../../entities/chat_content_entity.dart';
import '../../repositories/chat_content_repository_interface.dart';

final class ReadChatContentUsecase implements UseCase<ChatContentEntity?, int> {
  final ChatContentRepositoryIntf repository;

  const ReadChatContentUsecase(this.repository);

  @override
  FutureOr<ChatContentEntity?> call(int chatId) =>
      repository.getContentFor(chatId);
}
