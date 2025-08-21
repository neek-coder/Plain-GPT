import 'package:hive/hive.dart';
import 'package:my_gpt_client/chat_system/data/models/chat_system_object_data_model.dart';

import '../models/hive_chat_system_object_type_adapter.dart';
import '../models/chat_system_storage_model.dart';
import '../../../core/utils/hive_initialization_manager.dart';

import 'chat_system_datasource_interface.dart';

final class ChatSystemDatasourceHive implements ChatSystemDatasuorceInterface {
  static const _boxKey = 'chat-system-box';
  static const _contentKey = 'content';

  late final Box _box;

  bool _initialized = false;

  @override
  Future<void> init() async {
    await HiveInitializationManager.init();

    Hive.registerAdapter(HiveChatDataModelTypeAdapter());
    Hive.registerAdapter(HiveChatFolderDataModelTypeAdapter());

    _box = await Hive.openBox(_boxKey);

    _initialized = true;
  }

  @override
  Future<ChatSystemDataModel> readChatSystem() async {
    if (!_initialized) {
      throw Exception('HiveChatSystemRepository has not been initialized');
    }

    final raw = _box.get(_contentKey);

    final List<ChatSystemObjectDataModel>? tape =
        (raw == null) ? null : List<ChatSystemObjectDataModel>.from(raw);

    final system = ChatSystemDataModel(content: tape ?? []);

    return system;
  }

  @override
  Future<void> storeChatSystem(ChatSystemDataModel system) async {
    if (!_initialized) {
      throw Exception('HiveChatSystemRepository has not been initialized');
    }

    final List<ChatSystemObjectDataModel> content = [];

    for (final obj in system.content) {
      content.add(obj);
    }

    await _box.put(_contentKey, content);
  }
}
