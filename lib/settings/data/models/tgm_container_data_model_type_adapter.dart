import 'package:hive/hive.dart';
import 'package:my_gpt_client/core/entities/text_generation_model_entity.dart';
import 'package:my_gpt_client/core/utils/hive_type_id_manager.dart';
import 'package:my_gpt_client/infrastructure/models/text_generation_model_data_model.dart';
import 'tgm_container_data_model.dart';

final class TGMContainerTypeAdapter extends TypeAdapter<TGMContainerDataModel> {
  // ignore: unused_field
  static const _storageFormatVersion = 1;

  @override
  int get typeId => HiveTypeIdManager.getId<TGMContainerTypeAdapter>();

  @override
  TGMContainerDataModel read(BinaryReader reader) {
    // ignore: unused_local_variable
    final version = reader.readInt();

    final selection =
        TextGenerationModelInstance.getInstance(reader.readString());

    final dataRaw =
        Map<String, TextGenerationModelDataModel>.from(reader.readMap());
    final Map<TextGenerationModelInstance, TextGenerationModelDataModel> data =
        {};

    for (final e in dataRaw.entries) {
      final i = TextGenerationModelInstance.getInstance(e.key);
      if (i != null) {
        data[i] = e.value;
      }
    }

    return TGMContainerDataModel(selection: selection, data: data);
  }

  @override
  void write(BinaryWriter writer, TGMContainerDataModel obj) {
    writer.writeInt(_storageFormatVersion);
    writer.writeString(obj.selection.code);

    writer.writeMap(obj.container.map(
      (key, value) => MapEntry(key.code, value),
    ));
  }
}
