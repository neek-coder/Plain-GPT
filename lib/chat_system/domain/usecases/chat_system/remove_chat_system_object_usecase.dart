import 'package:my_gpt_client/core/entities/usecase.dart';
import 'package:my_gpt_client/chat_system/domain/entities/chat_system_entity.dart';

final class RemoveChatSystemObjectRequest {
  final ChatSystemEntity system;
  final ChatSystemObjectEntity object;
  final ChatFolderEntity? from;
  final void Function(ChatEntity chat)? onChatRemoved;

  const RemoveChatSystemObjectRequest({
    required this.system,
    required this.object,
    this.from,
    this.onChatRemoved,
  });
}

final class RemoveChatSystemObjectUseCase
    implements UseCase<bool, RemoveChatSystemObjectRequest> {
  @override
  bool call(RemoveChatSystemObjectRequest request) => request.system
      .remove(request.object, request.from, request.onChatRemoved);
}
