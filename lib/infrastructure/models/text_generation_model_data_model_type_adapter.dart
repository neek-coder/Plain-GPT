import 'package:hive/hive.dart';
import 'package:my_gpt_client/core/utils/hive_type_id_manager.dart';
import 'package:my_gpt_client/settings/domain/entities/global_settings_entity.dart';

import 'text_generation_model_data_model.dart';

final class TextGenerationModelDataModelTypeAdapter
    extends TypeAdapter<TextGenerationModelDataModel> {
  // Version of the storage format.
  static const _storageFormatVersion = 1;

  @override
  int get typeId =>
      HiveTypeIdManager.getId<TextGenerationModelDataModelTypeAdapter>();

  @override
  TextGenerationModelDataModel read(BinaryReader reader) {
    final version = reader.readInt();

    return _read(version, reader);
  }

  @override
  void write(BinaryWriter writer, TextGenerationModelDataModel obj) {
    writer.writeInt(_storageFormatVersion);
    writer.writeString(obj.instance.code);
    writer.writeString(obj.version.code);
    writer.writeString(obj.apiKey);
  }

  TextGenerationModelDataModel _read(int version, BinaryReader reader) {
    try {
      if (version == 1) {
        final code = reader.readString();
        final version = reader.readString();
        final apiKey = reader.readString();

        final instance = TextGenerationModelInstance.getInstance(code)!;

        return TextGenerationModelDataModel(
          instance: instance,
          version: instance.versions.firstWhere((v) => v.code == version),
          apiKey: apiKey,
        );
      }

      return TextGenerationModelDataModel(
        instance: TextGenerationModelInstance.chatGPT,
        version: TextGenerationModelInstance.chatGPT.versions.first,
        apiKey: '',
      );
    } catch (_) {
      return TextGenerationModelDataModel(
        instance: TextGenerationModelInstance.chatGPT,
        version: TextGenerationModelInstance.chatGPT.versions.first,
        apiKey: '',
      );
    }
  }
}
