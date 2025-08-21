import 'dart:async';

import 'package:my_gpt_client/settings/data/models/global_settings_data_model.dart';

abstract interface class GlobalSettingsDatasourceIntf {
  FutureOr<GlobalSettingsDataModel?> readGlobalSettings();
  FutureOr<void> storeGlobalSettings(GlobalSettingsDataModel settings);
}
