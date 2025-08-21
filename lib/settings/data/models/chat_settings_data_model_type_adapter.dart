import 'package:hive/hive.dart';
import 'package:my_gpt_client/core/utils/hive_type_id_manager.dart';
import 'package:my_gpt_client/settings/data/models/chat_settiings_data_model.dart';

final class ChatSettingsDataModelTypeAdapter
    extends TypeAdapter<ChatSettingsDataModel> {
  static const _storageFormatVersion = 1;

  @override
  int get typeId => HiveTypeIdManager.getId<ChatSettingsDataModelTypeAdapter>();

  @override
  ChatSettingsDataModel read(BinaryReader reader) {
    // ignore: unused_local_variable
    final version = reader.readInt();
    final bufferSize = reader.readInt();
    final temperature = reader.readDouble();

    return ChatSettingsDataModel(
      contextBufferSize: bufferSize,
      temperature: temperature,
    );
  }

  @override
  void write(BinaryWriter writer, ChatSettingsDataModel obj) {
    writer.writeInt(_storageFormatVersion);
    writer.writeInt(obj.contextBufferSize);
    writer.writeDouble(obj.temperature);
  }
}
