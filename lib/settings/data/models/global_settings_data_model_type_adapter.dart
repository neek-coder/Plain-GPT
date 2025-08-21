import 'package:hive/hive.dart';

import '/core/utils/hive_type_id_manager.dart';
import '/settings/data/models/global_settings_data_model.dart';
import '/settings/data/models/tgm_container_data_model.dart';

final class GlobalSettingsDataModelTypeAdapter
    extends TypeAdapter<GlobalSettingsDataModel> {
  static const _storageFormatVersion = 1;

  @override
  int get typeId =>
      HiveTypeIdManager.getId<GlobalSettingsDataModelTypeAdapter>();

  @override
  GlobalSettingsDataModel read(BinaryReader reader) {
    // ignore: unused_local_variable
    final version = reader.readInt();
    final TGMContainerDataModel tgmContainer = reader.read();

    return GlobalSettingsDataModel(tgmContainer: tgmContainer);
  }

  @override
  void write(BinaryWriter writer, GlobalSettingsDataModel obj) {
    writer.writeInt(_storageFormatVersion);
    writer.write(obj.tgmContainer);
  }
}
