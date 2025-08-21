import 'package:my_gpt_client/core/entities/usecase.dart';
import 'package:my_gpt_client/chat_system/domain/entities/chat_system_entity.dart';

final class AddChatSystemObjectRequest {
  final ChatSystemEntity system;
  final ChatSystemObjectEntity object;
  final ChatFolderEntity? to;

  const AddChatSystemObjectRequest({
    required this.system,
    required this.object,
    required this.to,
  });
}

final class AddChatSystemObjectUseCase
    implements UseCase<bool, AddChatSystemObjectRequest> {
  @override
  bool call(AddChatSystemObjectRequest request) =>
      request.system.add(request.object, request.to);
}
