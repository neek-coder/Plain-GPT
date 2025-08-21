import 'package:hive/hive.dart';

import '../models/hive_chat_content_type_adapter.dart';
import '../models/chat_content_data_model.dart';
import '../../../core/utils/hive_initialization_manager.dart';
import 'chat_content_datasource_interface.dart';

final class ChatContentDatasourceHive
    implements ChatContentDatasuorceInterface {
  static const _boxKey = 'chats-content';

  late final Box _box;

  bool _initialized = false;

  @override
  Future<void> init() async {
    await HiveInitializationManager.init();

    Hive.registerAdapter(HiveChatMessageStorageModelTypeAdapter());
    Hive.registerAdapter(HiveChatContentStorageModelTypeAdapter());

    _box = await Hive.openBox(_boxKey);

    _initialized = true;
  }

  @override
  Future<ChatContentDataModel?> getContentFor(int chatId) async {
    if (!_initialized) {
      throw Exception('ChatContentDatasourceHive has not been initialized');
    }

    final ChatContentDataModel? s = _box.get(chatId);

    return s;
  }

  @override
  Future<void> updateCotentFor(int chatId, ChatContentDataModel content) async {
    if (!_initialized) {
      throw Exception('ChatContentDatasourceHive has not been initialized');
    }

    await _box.put(chatId, content);
  }

  @override
  Future<void> removeContentFor(int chatId) async {
    if (!_initialized) {
      throw Exception('ChatContentDatasourceHive has not been initialized');
    }

    await _box.delete(chatId);
  }
}
