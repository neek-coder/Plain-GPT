import 'dart:async';

import '/core/entities/usecase.dart';
import '../../entities/chat_system_entity.dart';
import '../../repositories/chat_system_repository_interface.dart';

final class StoreChatSystemUsecase implements UseCase<void, ChatSystemEntity> {
  final ChatSystemRepositoryIntf chatSystemRepository;
  final ChatSystemObjectIdRepositoryIntf idRepository;

  const StoreChatSystemUsecase({
    required this.chatSystemRepository,
    required this.idRepository,
  });

  @override
  FutureOr<void> call(ChatSystemEntity system) async {
    await chatSystemRepository.storeChatSystem(system);
    await idRepository.save();
  }
}
