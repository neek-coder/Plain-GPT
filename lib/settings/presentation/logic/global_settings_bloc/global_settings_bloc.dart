import 'package:bloc/bloc.dart';
import 'package:my_gpt_client/injector.dart';
import 'package:my_gpt_client/settings/domain/usecases/read_global_settings_usecase.dart';
import 'package:my_gpt_client/settings/domain/usecases/store_global_settings_usecase.dart';
import 'package:my_gpt_client/settings/presentation/models/global_settings_view_model.dart';

part 'global_settings_event.dart';
part 'global_settings_state.dart';

class GlobalSettingsBloc
    extends Bloc<GlobalSettingsEvent, GlobalSettingsState> {
  GlobalSettingsBloc() : super(const GlobalSettingsInitial()) {
    on<GlobalSettingsLoadEvent>((event, emit) async {
      if (state is! GlobalSettingsInitial) {
        return;
      }

      emit(const GlobalSettingsLoading());

      final read = g<ReadGlobalSettingsUsecase>();

      final settingsEntity = await read(null);
      final settings = (settingsEntity != null)
          ? GlobalSettingsViewModel.fromEntity(settingsEntity)
          : GlobalSettingsViewModel.defaultConfiguration();

      emit(GlobalSettingsLoaded(settings));
    });

    on<GlobalSettingsUpdateEvent>((event, emit) {
      if (state is! GlobalSettingsLoaded) return;

      emit(GlobalSettingsLoaded(event.settings));
    });

    on<GlobalSettingsSaveEvent>((event, emit) async {
      if (state is! GlobalSettingsLoaded) return;

      final settings = (state as GlobalSettingsLoaded).settings;

      emit(GlobalSettingsSaving(settings));

      final store = g<StoreGlobalSettingsUsecase>();

      await store(
        StoreGlobalSettingsRequest(
          settings.toEntity(),
        ),
      );

      emit(GlobalSettingsLoaded(settings));
    });
  }

  GlobalSettingsViewModel get currentSettings {
    switch (state) {
      case GlobalSettingsInitial():
        throw Exception('No settings are loaded');
      case GlobalSettingsLoading():
        throw Exception('No settings are loaded');
      case GlobalSettingsLoaded():
        return (state as GlobalSettingsLoaded).settings;
      case GlobalSettingsSaving():
        return (state as GlobalSettingsSaving).settings;
    }
  }

  void load() => add(const GlobalSettingsLoadEvent());

  void update(GlobalSettingsViewModel settings) =>
      add(GlobalSettingsUpdateEvent(settings));

  void save() => add(const GlobalSettingsSaveEvent());
}
