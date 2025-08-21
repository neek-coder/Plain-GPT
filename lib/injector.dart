import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '/base/data/start_count_repository.dart';

// Chat
import '/chat/domain/repositories/chat_content_repository_interface.dart';
import '/chat/domain/repositories/text_generation_model_repository_interface.dart';
import '/chat/domain/usecases/chat_content/read_chat_content_usecase.dart';
import '/chat/domain/usecases/chat_content/store_chat_content_usecase.dart';
import '/chat/domain/usecases/text_generation_model/stream_text_usecase.dart';
import '/chat/domain/usecases/chat_content/remove_chat_content_usecase.dart';

import '/chat/data/repositories/chat_content_repository_implementation.dart';
import '/chat/data/repositories/text_generation_model_repository.dart';
import '/chat/data/sources/chat_content_datasource_hive.dart';
import 'chat/data/sources/text_generation_model_datasource.dart';

import '/chat/presentation/logic/chat_content_bloc/chat_content_bloc.dart';
import 'settings/presentation/logic/settings_sheet_cubit/settings_sheet_cubit.dart';

// Chat System
import '/chat_system/domain/repositories/chat_system_object_id_repository_interface.dart';
import '/chat_system/domain/repositories/chat_system_repository_interface.dart';
import '/chat_system/domain/usecases/chat_system/read_chat_system_usecase.dart';
import '/chat_system/domain/usecases/chat_system/store_chat_system_usecase.dart';
import 'chat_system/domain/usecases/chat_system/insert_above_chat_system_object_usecase.dart';
import 'chat_system/domain/usecases/chat_system/insert_below_chat_system_object_usecase.dart';

import '/chat_system/data/repositories/chat_system_repository_implementation.dart';
import '/chat_system/data/repositories/chat_system_object_id_repository_implementation.dart';
import '/chat_system/data/sources/chat_system_object_id_datasource_hive.dart';
import '/chat_system/data/sources/chat_system_datasource_hive.dart';

import '/chat_system/presentation/logic/chat_system_bloc/chat_system_bloc.dart';

// Settings
import '/settings/domain/repositories/settings_repository_interface.dart';
import '/settings/domain/usecases/read_chat_settings_usecase.dart';
import '/settings/domain/usecases/store_chat_settings_usecase.dart';
import '/settings/domain/usecases/store_global_settings_usecase.dart';
import '/settings/domain/usecases/read_global_settings_usecase.dart';

import '/settings/data/repositories/settings_repository_implementation.dart';
import '/settings/data/sources/chat_settings_datasource_hive.dart';
import '/settings/data/sources/global_settings_datasource_hive.dart';
import '/settings/presentation/logic/chat_settings_bloc/chat_settings_bloc.dart';
import '/settings/presentation/logic/global_settings_bloc/global_settings_bloc.dart';

// Base
import '/base/presentation/logic/base_view_bloc.dart';

import 'infrastructure/models/text_generation_model_data_model_type_adapter.dart';

final g = GetIt.I;

Future<void> inject() async {
  // Main adapters
  Hive.registerAdapter(TextGenerationModelDataModelTypeAdapter());

  // Text Generation Model
  const textGenModelDS = TextGenerationModelDatasource();

  await textGenModelDS.init();

  g.registerSingleton<TextGenerationModelRepositoryIntf>(
    const TextGenerationModelRepositoryImpl(textGenModelDS),
  );

  g.registerSingleton<StreamTextUsecase>(StreamTextUsecase(g()));

  // Chat System Object ID Generator
  final chatSystemObjectIDDS = ChatSystemObjectIdDatasourceHive();
  await chatSystemObjectIDDS.init();

  final chatSystemObjectIDRepo =
      ChatSystemObjectIdRepositoryImpl(chatSystemObjectIDDS);

  g.registerSingleton<ChatSystemObjectIdRepositoryIntf>(chatSystemObjectIDRepo);

  // Chat System
  final chatSystemDS = ChatSystemDatasourceHive();

  await chatSystemDS.init();

  g.registerSingleton<ChatSystemRepositoryIntf>(
      ChatSystemRepositoryImpl(chatSystemDS));

  g.registerSingleton<ReadChatSystemUsecase>(ReadChatSystemUsecase(g()));
  g.registerSingleton<StoreChatSystemUsecase>(
      StoreChatSystemUsecase(chatSystemRepository: g(), idRepository: g()));

  g.registerSingleton<AddChatSystemObjectUseCase>(AddChatSystemObjectUseCase());
  g.registerSingleton<RemoveChatSystemObjectUseCase>(
      RemoveChatSystemObjectUseCase());
  g.registerSingleton<InsertAboveChatSystemObjectUsecase>(
      InsertAboveChatSystemObjectUsecase());
  g.registerSingleton<InsertBelowChatSystemObjectUsecase>(
      InsertBelowChatSystemObjectUsecase());
  g.registerSingleton<MoveChatSystemObjectUseCase>(
      MoveChatSystemObjectUseCase());

  // Chat Content

  final chatContentDS = ChatContentDatasourceHive();

  await chatContentDS.init();

  g.registerSingleton<ChatContentRepositoryIntf>(
      ChatContentRepositoryImpl(chatContentDS));

  g.registerSingleton<ReadChatContentUsecase>(ReadChatContentUsecase(g()));
  g.registerSingleton<StoreChatContentUsecase>(StoreChatContentUsecase(g()));
  g.registerSingleton<RemoveChatContentUsecase>(RemoveChatContentUsecase(g()));

  // Settings

  final chatSettingsDS = ChatSettingsDatasourceHive();
  final globalSettingsDS = GlobalSettingsDatasourceHive();

  await chatSettingsDS.init();
  await globalSettingsDS.init();

  final settingsRepo = SettingsRepositoryImpl(
    chatSettingsDatasource: chatSettingsDS,
    globalSettingsDatasource: globalSettingsDS,
  );

  g.registerSingleton<SettingsRepositoryIntf>(settingsRepo);

  g.registerSingleton<ReadChatSettingsUsecase>(
      ReadChatSettingsUsecase(repository: g()));
  g.registerSingleton<StoreChatSettingsUsecase>(
      StoreChatSettingsUsecase(repository: g()));
  g.registerSingleton<ReadGlobalSettingsUsecase>(
      ReadGlobalSettingsUsecase(repository: g()));
  g.registerSingleton<StoreGlobalSettingsUsecase>(
      StoreGlobalSettingsUsecase(repository: g()));

  // Start Count Repository

  final startCountRepository = StartCountRepository();
  await startCountRepository.init();

  g.registerSingleton<StartCountRepository>(startCountRepository);

  // Chat System BLoC
  final chatSystemBloc = ChatSystemBloc();
  chatSystemBloc.add(ChatSystemLoadEvent());

  g.registerSingleton<ChatSystemBloc>(chatSystemBloc);

  // Chat Content BLoC
  g.registerSingleton<ChatContentBloc>(ChatContentBloc());

  // Global Settings BLoC
  final globalSettingsBloc = GlobalSettingsBloc();
  globalSettingsBloc.load();

  g.registerSingleton<GlobalSettingsBloc>(globalSettingsBloc);

  // Chat Settings BLoC
  g.registerSingleton<ChatSettingsBloc>(ChatSettingsBloc());

  // Base View BLoC
  g.registerSingleton<BaseViewBloc>(BaseViewBloc());

  // Settings Sheet Cubit
  g.registerSingleton<SettingsSheetCubit>(SettingsSheetCubit());
}
