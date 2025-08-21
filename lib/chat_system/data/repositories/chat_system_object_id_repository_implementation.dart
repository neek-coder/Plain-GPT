import 'package:my_gpt_client/chat_system/domain/entities/chat_system_entity.dart';

import '../sources/chat_system_object_id_datasource_interface.dart';

final class ChatSystemObjectIdRepositoryImpl
    implements ChatSystemObjectIdRepositoryIntf {
  final ChatSystemObjectIdDatasourceIntf dataSource;

  int _id;

  @override
  int get id => _id;

  ChatSystemObjectIdRepositoryImpl(this.dataSource)
      : _id = dataSource.getLastId() ?? 0;

  @override
  int generateId() => ++_id;

  @override
  Future<void> save() => dataSource.saveLastId(_id);
}
