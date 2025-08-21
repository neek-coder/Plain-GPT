import 'package:my_gpt_client/core/entities/usecase.dart';
import 'package:my_gpt_client/chat_system/domain/entities/chat_system_entity.dart';

final class InsertAboveChatSystemObjectRequest {
  final ChatSystemEntity system;
  final ChatSystemObjectEntity object;
  final ChatSystemObjectEntity anchor;

  const InsertAboveChatSystemObjectRequest({
    required this.system,
    required this.object,
    required this.anchor,
  });
}

final class InsertAboveChatSystemObjectUsecase
    implements UseCase<bool, InsertAboveChatSystemObjectRequest> {
  @override
  bool call(InsertAboveChatSystemObjectRequest request) => request.system
      .insertAbove(object: request.object, anchor: request.anchor);
}
