import 'package:hive/hive.dart';
import 'package:my_gpt_client/chat/data/models/chat_content_data_model.dart';

import '/core/entities/chat_role.dart';

import '/core/utils/hive_type_id_manager.dart';

final class HiveChatMessageStorageModelTypeAdapter
    extends TypeAdapter<ChatMessageDataModel> {
  static const _storageFormatVersion = 1;

  @override
  int get typeId =>
      HiveTypeIdManager.getId<HiveChatMessageStorageModelTypeAdapter>();

  @override
  ChatMessageDataModel read(BinaryReader reader) {
    // ignore: unused_local_variable
    final version = reader.readInt();
    final message = reader.readString();
    final role = ChatRole.values.elementAtOrNull(reader.readInt());

    return ChatMessageDataModel(message: message, role: role!);
  }

  @override
  void write(BinaryWriter writer, ChatMessageDataModel obj) {
    writer.writeInt(_storageFormatVersion);
    writer.writeString(obj.message);
    writer.writeInt(obj.role.index);
  }
}

final class HiveChatContentStorageModelTypeAdapter
    extends TypeAdapter<ChatContentDataModel> {
  static const _storageFormatVersion = 1;

  @override
  int get typeId =>
      HiveTypeIdManager.getId<HiveChatContentStorageModelTypeAdapter>();

  @override
  ChatContentDataModel read(BinaryReader reader) {
    // ignore: unused_local_variable
    final version = reader.readInt();

    final chatId = reader.readInt();

    final rawContent = reader.readList();
    final List<ChatMessageDataModel> content =
        List<ChatMessageDataModel>.from(rawContent);

    return ChatContentDataModel(chatId: chatId, content: content);
  }

  @override
  void write(BinaryWriter writer, ChatContentDataModel obj) {
    writer.writeInt(_storageFormatVersion);
    writer.writeInt(obj.chatId);
    writer.writeList(obj.content);
  }
}
