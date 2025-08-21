import 'package:my_gpt_client/core/entities/usecase.dart';
import 'package:my_gpt_client/chat_system/domain/entities/chat_system_entity.dart';

final class InsertBelowChatSystemObjectRequest {
  final ChatSystemEntity system;
  final ChatSystemObjectEntity object;
  final ChatSystemObjectEntity anchor;

  const InsertBelowChatSystemObjectRequest({
    required this.system,
    required this.object,
    required this.anchor,
  });
}

final class InsertBelowChatSystemObjectUsecase
    implements UseCase<bool, InsertBelowChatSystemObjectRequest> {
  @override
  bool call(InsertBelowChatSystemObjectRequest request) => request.system
      .insertBelow(object: request.object, anchor: request.anchor);
}
