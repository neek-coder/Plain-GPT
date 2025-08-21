import 'dart:async';

import '/core/entities/usecase.dart';

import '../../entities/chat_system_entity.dart';
import '../../repositories/chat_system_repository_interface.dart';

final class ReadChatSystemUsecase implements UseCase<ChatSystemEntity, void> {
  final ChatSystemRepositoryIntf repository;

  const ReadChatSystemUsecase(this.repository);

  @override
  FutureOr<ChatSystemEntity> call(void params) => repository.readChatSystem();
}
