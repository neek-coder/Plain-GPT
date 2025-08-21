import 'package:hive/hive.dart';

import '../../../core/utils/hive_type_id_manager.dart';
import 'chat_system_object_data_model.dart';

final class HiveChatDataModelTypeAdapter extends TypeAdapter<ChatDataModel> {
  static const _storageFormatVersion = 1;

  @override
  int get typeId => HiveTypeIdManager.getId<HiveChatDataModelTypeAdapter>();

  @override
  ChatDataModel read(BinaryReader reader) {
    // ignore: unused_local_variable
    final version = reader.readInt();

    final id = reader.readInt();
    final name = reader.readString();
    final int? parentFolderId = reader.read();
    final layer = reader.readInt();

    return ChatDataModel(
      id: id,
      name: name,
      parentFolderId: parentFolderId,
      layer: layer,
    );
  }

  @override
  void write(BinaryWriter writer, ChatDataModel obj) {
    writer.writeInt(_storageFormatVersion);
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
    writer.write<int?>(obj.parentFolderId);
    writer.writeInt(obj.layer);
  }
}

final class HiveChatFolderDataModelTypeAdapter
    extends TypeAdapter<ChatFolderDataModel> {
  static const _storageFormatVersion = 1;

  @override
  int get typeId =>
      HiveTypeIdManager.getId<HiveChatFolderDataModelTypeAdapter>();

  @override
  ChatFolderDataModel read(BinaryReader reader) {
    // ignore: unused_local_variable
    final version = reader.readInt();

    final id = reader.readInt();
    final name = reader.readString();
    final int? parentFolderId = reader.read();
    final layer = reader.readInt();

    final rawContent = reader.readList();
    final List<int> content = List<int>.from(rawContent);

    return ChatFolderDataModel(
      id: id,
      name: name,
      parentFolderId: parentFolderId,
      layer: layer,
      children: content,
    );
  }

  @override
  void write(BinaryWriter writer, ChatFolderDataModel obj) {
    writer.writeInt(_storageFormatVersion);
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
    writer.write<int?>(obj.parentFolderId);
    writer.writeInt(obj.layer);
    writer.writeList(obj.children.toList());
  }
}
