import 'package:hive/hive.dart';

import 'chat_system_object_id_datasource_interface.dart';
import '../../../core/utils/hive_initialization_manager.dart';

final class ChatSystemObjectIdDatasourceHive
    implements ChatSystemObjectIdDatasourceIntf {
  static const _boxKey = 'chat-system-object-id';
  static const _contentKey = 'id';

  late final Box _box;

  @override
  Future<void> init() async {
    await HiveInitializationManager.init();

    _box = await Hive.openBox(_boxKey);
  }

  @override
  int? getLastId() => _box.get(_contentKey);

  @override
  Future<void> saveLastId(int id) async {
    await _box.put(_contentKey, id);
  }
}
