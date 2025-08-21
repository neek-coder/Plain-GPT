import 'package:my_gpt_client/core/entities/usecase.dart';
import 'package:my_gpt_client/chat_system/domain/entities/chat_system_entity.dart';

final class MoveChatSystemObjectRequest {
  final ChatSystemEntity system;
  final ChatSystemObjectEntity object;
  final ChatFolderEntity? from;
  final ChatFolderEntity? to;

  const MoveChatSystemObjectRequest({
    required this.system,
    required this.object,
    this.from,
    this.to,
  });
}

final class MoveChatSystemObjectUseCase
    implements UseCase<bool, MoveChatSystemObjectRequest> {
  @override
  bool call(MoveChatSystemObjectRequest request) => request.system
      .move(object: request.object, from: request.from, to: request.to);
}
