import 'package:my_gpt_client/chat_system/domain/entities/chat_system_entity.dart';

import '../../domain/entities/chat_system_object_entity.dart';

sealed class ChatSystemObjectViewModelData<T extends ChatSystemObjectEntity> {}

final class ChatViewModelData
    extends ChatSystemObjectViewModelData<ChatEntity> {}

final class ChatFolderViewModelData
    extends ChatSystemObjectViewModelData<ChatFolderEntity> {
  bool isOpen;

  ChatFolderViewModelData({this.isOpen = false});
}

sealed class ChatSystemObjectViewModel<T extends ChatSystemObjectEntity,
    D extends ChatSystemObjectViewModelData<T>> {
  final T entity;
  final D data;

  int get id => entity.id;
  String get name => entity.name;
  set name(String name) => entity.name = name;

  ChatSystemObjectViewModel({
    required this.entity,
    required this.data,
  });

  @override
  int get hashCode => entity.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is ChatSystemObjectViewModel) return hashCode == other.hashCode;

    return false;
  }
}

final class ChatViewModel
    extends ChatSystemObjectViewModel<ChatEntity, ChatViewModelData> {
  ChatViewModel({required ChatEntity chat, required ChatViewModelData data})
      : super(entity: chat, data: data);

  ChatViewModel copyWith({
    int? id,
    String? name,
    ChatFolderEntity? parentFolder,
  }) =>
      ChatViewModel(
        chat: entity.copyWith(
          id: id,
          name: name,
          parentFolder: parentFolder,
        ),
        data: ChatViewModelData(),
      );
}

final class ChatFolderViewModel extends ChatSystemObjectViewModel<
    ChatFolderEntity, ChatFolderViewModelData> {
  ChatFolderViewModel(
      {required ChatFolderEntity folder, required ChatFolderViewModelData data})
      : super(entity: folder, data: data);
}
