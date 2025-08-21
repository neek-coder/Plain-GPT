import 'package:hive/hive.dart';

import '../../infrastructure/models/text_generation_model_data_model_type_adapter.dart';
import '/settings/data/models/global_settings_data_model_type_adapter.dart';
import '/settings/data/models/chat_settings_data_model_type_adapter.dart';
import '../../settings/data/models/tgm_container_data_model_type_adapter.dart';
import '/chat/data/models/hive_chat_content_type_adapter.dart';
import '/chat_system/data/models/hive_chat_system_object_type_adapter.dart';

abstract class HiveTypeIdManager {
  static const Map<Type, int> _ids = {
    HiveChatDataModelTypeAdapter: 0,
    HiveChatFolderDataModelTypeAdapter: 1,
    HiveChatMessageStorageModelTypeAdapter: 2,
    HiveChatContentStorageModelTypeAdapter: 3,
    ChatSettingsDataModelTypeAdapter: 4,
    GlobalSettingsDataModelTypeAdapter: 5,
    TextGenerationModelDataModelTypeAdapter: 6,
    TGMContainerTypeAdapter: 7,
  };

  static int getId<T extends TypeAdapter>() {
    final id = _ids[T];

    if (id == null) {
      throw Exception('The type $T is not registered in HiveTypeIdManager');
    }

    return id;
  }
}
