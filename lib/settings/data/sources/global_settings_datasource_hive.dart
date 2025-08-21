import 'dart:async';

import 'package:hive/hive.dart';

import '../models/tgm_container_data_model_type_adapter.dart';
import '/core/utils/hive_initialization_manager.dart';
import '/settings/data/models/global_settings_data_model.dart';
import '/settings/data/models/global_settings_data_model_type_adapter.dart';
import '/settings/data/sources/global_settings_datasource_interface.dart';

final class GlobalSettingsDatasourceHive
    implements GlobalSettingsDatasourceIntf {
  static const _boxKey = 'global-settings-box';
  static const _contentKey = 'content';

  late final Box _box;

  Future<void> init() async {
    await HiveInitializationManager.init();

    Hive.registerAdapter(TGMContainerTypeAdapter());
    Hive.registerAdapter(GlobalSettingsDataModelTypeAdapter());

    _box = await Hive.openBox(_boxKey);
  }

  @override
  FutureOr<GlobalSettingsDataModel?> readGlobalSettings() =>
      _box.get(_contentKey);

  @override
  FutureOr<void> storeGlobalSettings(GlobalSettingsDataModel settings) async {
    await _box.put(_contentKey, settings);
  }
}
