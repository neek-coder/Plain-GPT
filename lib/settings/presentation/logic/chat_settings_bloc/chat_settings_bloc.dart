import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/settings/domain/usecases/read_chat_settings_usecase.dart';
import '/settings/domain/usecases/store_chat_settings_usecase.dart';
import '../../models/chat_settings_view_model.dart';

import '/injector.dart';

part 'chat_settings_event.dart';
part 'chat_settings_state.dart';

class ChatSettingsBloc extends Bloc<ChatSettingsEvent, ChatSettingsState> {
  /// Next chat in queue to be loaded. Used primarely to load a chat after the save operation.
  int? _pendingChatId;

  /// Current loading chat operation
  CancelableOperation<void>? _load;

  ChatSettingsBloc() : super(const ChatSettingsInitial()) {
    on<ChatSettingsLoadStartEvent>((event, emit) async {
      if (state is ChatSettingsSaving) {
        // Adding chat to the queue
        _pendingChatId = event.chatId;
        return;
      }

      // Interrupting previous loading, even if it is the same chat
      await _load?.cancel();

      emit(ChatSettingsLoading(event.chatId));

      // Forming a load
      _loadChatSettings(event.chatId).then(
        (settings) => add(
          ChatSettingsLoadFinishEvent(chatId: event.chatId, settings: settings),
        ),
      );
    });

    on<ChatSettingsLoadFinishEvent>((event, emit) async {
      if (state != ChatSettingsLoading(event.chatId)) return;

      emit(ChatSettingsLoaded(settings: event.settings, chatId: event.chatId));
    });

    on<LoadQuickChatSettings>((event, emit) async {
      if (state is ChatSettingsSaving) {
        _pendingChatId = -1;
        return;
      }

      await _load?.cancel();

      emit(const QuickChatSettings(
        settings: ChatSettingsViewModel.defaultConfiguration(),
      ));
    });

    on<ChatSettingsUpdateEvent>((event, emit) {
      if (state is! ChatSettingsLoaded) return;

      emit(
        ChatSettingsLoaded(
          settings: event.settings,
          chatId: (state as ChatSettingsLoaded).chatId,
        ),
      );
    });

    on<QuickChatSettingsUpdateEvent>((event, emit) {
      if (state is! QuickChatSettings) return;

      emit(
        QuickChatSettings(
          settings: event.settings,
        ),
      );
    });

    on<ChatSettingsSaveEvent>((event, emit) async {
      if (state is! ChatSettingsLoaded) {
        return;
      }

      emit(
        ChatSettingsSaving(
          chatId: event.chatId,
          settings: event.settings,
        ),
      );

      final store = g<StoreChatSettingsUsecase>();

      await store(
        StoreChatSettingsRequest(
          chatId: event.chatId,
          settings: event.settings.toEntity(),
        ),
      );

      if (_pendingChatId != null) {
        if (_pendingChatId == -1) {
          emit(const QuickChatSettings(
            settings: ChatSettingsViewModel.defaultConfiguration(),
          ));
          return;
        }

        emit(ChatSettingsLoading(_pendingChatId!));

        final settings = await _loadChatSettings(
          _pendingChatId!,
        );

        emit(ChatSettingsLoaded(settings: settings, chatId: _pendingChatId!));
        _pendingChatId = null;

        return;
      }

      emit(ChatSettingsLoaded(settings: event.settings, chatId: event.chatId));
    });
  }

  Future<ChatSettingsViewModel> _loadChatSettings(int chatId) async {
    final future = _readChatSettings(chatId, (settings) {
      _load = null;
    });

    _load = CancelableOperation.fromFuture(future);

    final settings = await future;

    return settings;
  }

  Future<ChatSettingsViewModel> _readChatSettings(int chatId,
      [void Function(ChatSettingsViewModel settings)? callback]) async {
    final read = g<ReadChatSettingsUsecase>();
    final settingsEntity = await read(ReadChatSettingsRequest(chatId));
    final settings = (settingsEntity != null)
        ? ChatSettingsViewModel.fromEntity(settingsEntity)
        : const ChatSettingsViewModel.defaultConfiguration();

    return settings;
  }

  bool get isQuickChat => state is QuickChatSettings;

  ChatSettingsViewModel get currentSettings {
    switch (state) {
      case ChatSettingsInitial():
        throw Exception('No settings are loaded');
      case ChatSettingsLoading():
        throw Exception('No settings are loaded');
      case ChatSettingsLoaded():
        return (state as ChatSettingsLoaded).settings;
      case ChatSettingsSaving():
        return (state as ChatSettingsSaving).settings;
      case QuickChatSettings():
        return (state as QuickChatSettings).settings;
    }
  }

  void read(int chatId) => add(ChatSettingsLoadStartEvent(chatId));

  void loadQuickChatSettings() => add(LoadQuickChatSettings());

  void update(ChatSettingsViewModel settings) {
    if (state is ChatSettingsLoaded) {
      add(ChatSettingsUpdateEvent(settings));
    } else if (state is QuickChatSettings) {
      add(QuickChatSettingsUpdateEvent(settings));
    }

    return;
  }

  void save() {
    if (state is! ChatSettingsLoaded) return;

    add(
      ChatSettingsSaveEvent(
        settings: (state as ChatSettingsLoaded).settings,
        chatId: (state as ChatSettingsLoaded).chatId,
      ),
    );
  }
}
