import 'package:my_gpt_client/chat_system/data/models/chat_system_storage_model.dart';
import 'package:my_gpt_client/chat_system/data/sources/chat_system_datasource_interface.dart';

import '../../domain/entities/chat_system_entity.dart';
import '../../domain/repositories/chat_system_repository_interface.dart';
import '../models/chat_system_object_data_model.dart';

final class ChatSystemRepositoryImpl implements ChatSystemRepositoryIntf {
  final ChatSystemDatasuorceInterface dataSource;

  const ChatSystemRepositoryImpl(this.dataSource);

  @override
  Future<ChatSystemEntity> readChatSystem() async {
    final storedSystem = await dataSource.readChatSystem();

    final (systemContent, _) = _deepRead(storedSystem, 0, 0);

    final system = ChatSystemEntity(content: systemContent);

    return system;
  }

  @override
  Future<void> storeChatSystem(ChatSystemEntity system) async {
    final List<ChatSystemObjectDataModel> objects = [];

    for (final obj in system.content) {
      _deepStore(obj, (o) {
        objects.add(switch (o) {
          ChatEntity() => ChatDataModel.fromEntity(o),
          ChatFolderEntity() => ChatFolderDataModel.fromEntity(o),
        });
      });
    }

    await dataSource.storeChatSystem(ChatSystemDataModel(content: objects));
  }

  void _deepStore(ChatSystemObjectEntity obj,
      void Function(ChatSystemObjectEntity obj) store) {
    store(obj);

    if (obj is ChatFolderEntity) {
      for (final nestedObj in obj.children) {
        _deepStore(nestedObj, store);
      }
    }
  }

  (Set<ChatSystemObjectEntity>, int) _deepRead(
      ChatSystemDataModel storedSystem, int index, int layer) {
    final Set<ChatSystemObjectEntity> layerContent = {};

    while (index < storedSystem.content.length &&
        storedSystem.content[index].layer >= layer) {
      switch (storedSystem.content[index]) {
        case ChatDataModel():
          layerContent.add(
            ChatEntity(
              id: storedSystem.content[index].id,
              name: storedSystem.content[index].name,
            ),
          );
          index += 1;
        case ChatFolderDataModel():
          final folder = ChatFolderEntity(
            id: storedSystem.content[index].id,
            name: storedSystem.content[index].name,
          );
          layerContent.add(folder);
          final (nextLayerContent, step) =
              _deepRead(storedSystem, index + 1, layer + 1);
          folder.addAll(nextLayerContent);
          index = step;
      }
    }

    return (layerContent, index);
  }
}
