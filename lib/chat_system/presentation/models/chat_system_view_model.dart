import 'package:my_gpt_client/chat/domain/usecases/chat_content/remove_chat_content_usecase.dart';
import 'package:my_gpt_client/chat/presentation/logic/chat_content_bloc/chat_content_bloc.dart';
import 'package:my_gpt_client/chat_system/presentation/logic/chat_system_bloc/chat_system_bloc.dart';

import '../../domain/usecases/chat_system/insert_above_chat_system_object_usecase.dart';
import '../../domain/usecases/chat_system/insert_below_chat_system_object_usecase.dart';
import '../../domain/entities/chat_system_entity.dart';
import '/injector.dart';

import 'chat_system_object_view_model.dart';

final class ChatSystemViewModel {
  final ChatSystemEntity system;
  final Map<int, ChatSystemObjectViewModelData> _viewModelData = {};

  int get itemsCount => system.content.length;

  ChatSystemViewModel({required this.system}) {
    final content = system.content;
    for (var e in content) {
      final l = _deepRead(e);

      for (var e in l) {
        _viewModelData[e.id] = switch (e) {
          ChatEntity() => ChatViewModelData(),
          ChatFolderEntity() => ChatFolderViewModelData(),
        } as ChatSystemObjectViewModelData;
      }
    }
  }

  ChatSystemObjectViewModel rootElementAt(int index) {
    if (index < 0 || index >= system.content.length) {
      throw Exception(
          'Index ($index) is not in the range 0...${system.content.length}');
    }

    return _generateModel(system.content[index]);
  }

  ChatFolderViewModel? getParentForlder(ChatSystemObjectViewModel object) {
    if (object.entity.parentFolder == null) return null;

    final isRoot = object.entity.parentFolder?.parentFolder == null;

    if (isRoot) return null;

    return _generateModel(object.entity.parentFolder!) as ChatFolderViewModel;
  }

  List<ChatSystemObjectViewModel> getFolderContent(ChatFolderViewModel folder) {
    final List<ChatSystemObjectViewModel> out = [];

    for (final e in folder.entity.children) {
      out.add(_generateModel(e));
    }

    return out;
  }

  bool add(ChatSystemObjectViewModel object, [ChatFolderViewModel? to]) {
    final add = g<AddChatSystemObjectUseCase>();

    final success = add(AddChatSystemObjectRequest(
      system: system,
      object: object.entity,
      to: to?.entity,
    ));

    if (success) _viewModelData[object.id] = object.data;

    return success;
  }

  bool remove(ChatSystemObjectViewModel object, [ChatFolderViewModel? from]) {
    final removeObject = g<RemoveChatSystemObjectUseCase>();
    final removeContent = g<RemoveChatContentUsecase>();
    final chatContentBloc = g<ChatContentBloc>();

    final selectedChat = chatContentBloc.currentChat;

    final success = removeObject(RemoveChatSystemObjectRequest(
        system: system,
        object: object.entity,
        from: from?.entity,
        onChatRemoved: (c) {
          if (selectedChat?.id == c.id) {
            chatContentBloc.unloadChat();
          }
          removeContent(
            RemoveChatContentRequest(chatId: c.id),
          );
        }));

    if (success) _viewModelData.remove(object.id);

    return success;
  }

  bool insertAbove(
          {required ChatSystemObjectViewModel object,
          required ChatSystemObjectViewModel anchor}) =>
      g<InsertAboveChatSystemObjectUsecase>()(
          InsertAboveChatSystemObjectRequest(
        system: system,
        object: object.entity,
        anchor: anchor.entity,
      ));

  bool insertBelow(
          {required ChatSystemObjectViewModel object,
          required ChatSystemObjectViewModel anchor}) =>
      g<InsertBelowChatSystemObjectUsecase>()(
          InsertBelowChatSystemObjectRequest(
        system: system,
        object: object.entity,
        anchor: anchor.entity,
      ));

  bool move(
          {required ChatSystemObjectViewModel object,
          ChatFolderViewModel? from,
          ChatFolderViewModel? to}) =>
      g<MoveChatSystemObjectUseCase>()(MoveChatSystemObjectRequest(
        system: system,
        object: object.entity,
        from: from?.entity,
        to: to?.entity,
      ));

  Iterable<ChatSystemObjectEntity> _deepRead(
      ChatSystemObjectEntity entity) sync* {
    yield entity;
    switch (entity) {
      case ChatEntity():
        break;
      case ChatFolderEntity():
        for (var e in entity.children) {
          yield* _deepRead(e);
        }
    }
  }

  ChatSystemObjectViewModel _generateModel(ChatSystemObjectEntity entity) {
    final data = _viewModelData[entity.id];

    if (data == null) {
      throw Exception('No data registered for entity #${entity.id}');
    }

    return switch (entity) {
      ChatEntity() =>
        ChatViewModel(chat: entity, data: data as ChatViewModelData),
      ChatFolderEntity() => ChatFolderViewModel(
          folder: entity, data: data as ChatFolderViewModelData),
    } as ChatSystemObjectViewModel;
  }
}
