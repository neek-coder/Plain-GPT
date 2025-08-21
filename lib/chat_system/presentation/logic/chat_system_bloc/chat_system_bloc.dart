import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '/chat_system/domain/entities/chat_system_entity.dart';
import '/chat_system/domain/usecases/chat_system/store_chat_system_usecase.dart';
import '/chat_system/domain/usecases/chat_system/read_chat_system_usecase.dart';
import '/chat_system/presentation/models/chat_system_view_model.dart';
import '/chat_system/presentation/models/chat_system_object_view_model.dart';
import '/chat/presentation/logic/chat_content_bloc/chat_content_bloc.dart';
import '/settings/presentation/logic/chat_settings_bloc/chat_settings_bloc.dart';
import '/injector.dart';

export '/chat_system/domain/usecases/chat_system/add_chat_system_object_usecase.dart';
export '/chat_system/domain/usecases/chat_system/move_chat_system_object_usecase.dart';
export '/chat_system/domain/usecases/chat_system/remove_chat_system_object_usecase.dart';

part 'chat_system_event.dart';
part 'chat_system_state.dart';

class ChatSystemBloc extends Bloc<ChatSystemEvent, ChatSystemState> {
  ChatSystemBloc() : super(ChatSystemInitial()) {
    on<ChatSystemLoadEvent>((event, emit) async {
      if (state is! ChatSystemInitial) return;

      final system = await g<ReadChatSystemUsecase>()(null);

      emit(ChatSystemLoaded(system: ChatSystemViewModel(system: system)));
    });

    on<ChatSystemStoreEvent>((event, emit) async {
      if (state is! ChatSystemLoaded) return;

      await g<StoreChatSystemUsecase>()(
          (state as ChatSystemLoaded).system.system);
    });

    on<ChatSystemLoadedEvent>((event, emit) {
      emit(ChatSystemLoaded(system: event.system));
    });

    on<ChatSystemObjectAddEvent>((event, emit) {
      if (state is! ChatSystemLoaded) return;

      final system = (state as ChatSystemLoaded).system;

      if (system.add(event.object, event.to)) {
        emit(ChatSystemLoaded(system: system, selectedChat: getSelectedChat()));

        if (event.object is ChatViewModel) {
          add(ChatSelectEvent(event.object as ChatViewModel));
        }
      }

      add(ChatSystemStoreEvent());
    });

    on<ChatObjectRemoveEvent>((event, emit) {
      if (state is! ChatSystemLoaded) return;

      final system = (state as ChatSystemLoaded).system;

      if (system.remove(event.object, event.from)) {
        var selectedChat = getSelectedChat();

        if (event.object is ChatViewModel && event.object == selectedChat) {
          selectedChat = null;
        }

        emit(ChatSystemLoaded(system: system, selectedChat: selectedChat));
      }

      add(ChatSystemStoreEvent());
    });

    on<ChatObjectMoveEvent>((event, emit) {
      if (state is! ChatSystemLoaded) return;

      final system = (state as ChatSystemLoaded).system;

      if (system.move(object: event.object, from: event.from, to: event.to)) {
        emit(ChatSystemLoaded(system: system, selectedChat: getSelectedChat()));
      }

      add(ChatSystemStoreEvent());
    });

    on<ChatObjectInsertAboveEvent>((event, emit) {
      if (state is! ChatSystemLoaded) return;

      final system = (state as ChatSystemLoaded).system;

      if (system.insertAbove(object: event.object, anchor: event.anchor)) {
        emit(ChatSystemLoaded(system: system, selectedChat: getSelectedChat()));
      }

      add(ChatSystemStoreEvent());
    });

    on<ChatObjectInsertBelowEvent>((event, emit) {
      if (state is! ChatSystemLoaded) return;

      final system = (state as ChatSystemLoaded).system;

      if (system.insertBelow(object: event.object, anchor: event.anchor)) {
        emit(ChatSystemLoaded(system: system, selectedChat: getSelectedChat()));
      }

      add(ChatSystemStoreEvent());
    });

    on<ChatSelectEvent>((event, emit) {
      if (state is! ChatSystemLoaded) return;

      if (g<ChatContentBloc>().busy) return;

      if (event.chat == getSelectedChat()) return;

      g<ChatContentBloc>().load(event.chat);
      g<ChatSettingsBloc>().read(event.chat.id);

      emit(
        ChatSystemLoaded(
          system: (state as ChatSystemLoaded).system,
          selectedChat: event.chat,
        ),
      );
    });

    on<ChatUnselectEvent>((event, emit) {
      if (state is! ChatSystemLoaded) return;

      if (g<ChatContentBloc>().busy) return;

      emit(ChatSystemLoaded(
        system: (state as ChatSystemLoaded).system,
      ));
    });
  }

  ChatViewModel? getSelectedChat() {
    if (state is! ChatSystemLoaded) return null;

    return (state as ChatSystemLoaded).selectedChat;
  }

  void selectChat(ChatViewModel chat) {
    add(ChatSelectEvent(chat));
  }

  void unselectChat() {
    add(ChatUnselectEvent());
  }

  ChatFolderViewModel? getParentFolder(ChatSystemObjectViewModel object) {
    if (state is! ChatSystemLoaded) return null;

    return (state as ChatSystemLoaded).system.getParentForlder(object);
  }

  List<ChatSystemObjectViewModel> getFolderContent(ChatFolderViewModel folder) {
    if (state is! ChatSystemLoaded) {
      throw Exception('Chat system has not been loaded');
    }

    return (state as ChatSystemLoaded).system.getFolderContent(folder);
  }

  void newChat([ChatFolderViewModel? to]) => add(
        ChatSystemObjectAddEvent(
          object: ChatViewModel(
            chat: ChatEntity(
              name: 'New Chat',
              id: g<ChatSystemObjectIdRepositoryIntf>().generateId(),
            ),
            data: ChatViewModelData(),
          ),
          to: to,
        ),
      );

  void newFolder([ChatFolderViewModel? to]) => add(
        ChatSystemObjectAddEvent(
          object: ChatFolderViewModel(
            folder: ChatFolderEntity(
              name: 'New Folder',
              id: g<ChatSystemObjectIdRepositoryIntf>().generateId(),
            ),
            data: ChatFolderViewModelData(),
          ),
          to: to,
        ),
      );

  void storeSystem() => add(ChatSystemStoreEvent());

  void delete(ChatSystemObjectViewModel object, {ChatFolderViewModel? from}) =>
      add(
        ChatObjectRemoveEvent(object: object, from: from),
      );

  void moveObject(
    ChatSystemObjectViewModel obj, {
    ChatFolderViewModel? from,
    ChatFolderViewModel? to,
  }) =>
      add(
        ChatObjectMoveEvent(
          object: obj,
          from: from,
          to: to,
        ),
      );

  void insertAbove(
          ChatSystemObjectViewModel obj, ChatSystemObjectViewModel anchor) =>
      add(
        ChatObjectInsertAboveEvent(
          object: obj,
          anchor: anchor,
        ),
      );

  void insertBelow(
          ChatSystemObjectViewModel obj, ChatSystemObjectViewModel anchor) =>
      add(
        ChatObjectInsertBelowEvent(
          object: obj,
          anchor: anchor,
        ),
      );
}
