import 'package:bloc/bloc.dart';
import 'package:my_gpt_client/chat_system/presentation/logic/chat_system_bloc/chat_system_bloc.dart';
import 'package:my_gpt_client/chat_system/presentation/models/chat_system_object_view_model.dart';
import 'package:my_gpt_client/injector.dart';
import 'package:my_gpt_client/settings/presentation/logic/chat_settings_bloc/chat_settings_bloc.dart';

import '../chat_content_manager/chat_content_manager.dart';
import '../../view_models/chat_content_view_model.dart';

part 'chat_content_event.dart';
part 'chat_content_state.dart';

class ChatContentBloc extends Bloc<ChatContentEvent, ChatContentState> {
  ChatContentBloc() : super(ChatContentInitial()) {
    on<ChatContentLoadEvent>((event, emit) async {
      if (state is ChatContentLoading) return;
      if (state is ChatContentLoaded &&
          (state as ChatContentLoaded).content.chatId == event.chat.id) return;

      final lastLoaded = (state is ChatContentLoaded)
          ? (state as ChatContentLoaded).content
          : null;

      if (state is ChatContentLoaded) {
        ChatContentManager().storeCcontentFor(
            (state as ChatContentLoaded).content.chatId, lastLoaded!);
      }

      emit(ChatContentLoading(event.chat));

      final content = await ChatContentManager().getCcontentFor(event.chat.id);

      if (state is ChatContentLoading &&
          (state as ChatContentLoading).chat.id == event.chat.id) {
        // If no interruptions have occured
        emit(
          ChatContentLoaded(
            content: content ??
                ChatContentViewModel(
                  chatId: event.chat.id,
                  content: [],
                ),
            chat: event.chat,
          ),
        );
      }
    });

    on<OpenQuickChatEvent>((event, emit) {
      if (state is ChatContentLoading) return;

      if (state is ChatContentLoaded) {
        ChatContentManager().storeCcontentFor(
          (state as ChatContentLoaded).content.chatId,
          (state as ChatContentLoaded).content,
        );
      }

      g<ChatSettingsBloc>().loadQuickChatSettings();
      g<ChatSystemBloc>().unselectChat();

      emit(QuickChat(
        content: ChatContentViewModel(chatId: -1, content: []),
      ));
    });

    on<ChatContentUnloadEvent>((event, emit) {
      emit(ChatContentInitial());
    });

    on<ChatContentRenameEvent>((event, emit) {
      if (state is! ChatContentLoaded) return;

      if ((state as ChatContentLoaded).chat.id != event.chatId) return;

      final loadedState = state as ChatContentLoaded;

      emit(
        ChatContentLoaded(
          content: loadedState.content,
          chat: loadedState.chat.copyWith(
            name: event.newName,
          ),
        ),
      );
    });
  }

  ChatViewModel? get currentChat {
    if (state is ChatContentLoaded) return (state as ChatContentLoaded).chat;
    if (state is ChatContentLoading) return (state as ChatContentLoading).chat;

    return null;
  }

  bool get busy =>
      (state is! ChatContentLoaded) &&
      (state is! ChatContentInitial) &&
      (state is! QuickChat);

  // bool get isQuickChat => state is QuickChat;

  void unloadChat() => add(ChatContentUnloadEvent());

  void quickChat() => add(OpenQuickChatEvent());

  Future<void> save() async {
    if (state is! ChatContentLoaded) return;

    final lastLoaded = (state as ChatContentLoaded).content;

    await ChatContentManager().storeCcontentFor(
        (state as ChatContentLoaded).content.chatId, lastLoaded);
  }

  void rename(int chatId, String newName) {
    if (state is! ChatContentLoaded) return;

    add(ChatContentRenameEvent(
      chatId: chatId,
      oldName: (state as ChatContentLoaded).chat.name,
      newName: newName,
    ));
  }

  void load(ChatViewModel chat) {
    add(ChatContentLoadEvent(chat: chat));
  }
}
