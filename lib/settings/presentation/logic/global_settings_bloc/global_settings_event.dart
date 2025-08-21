part of 'global_settings_bloc.dart';

sealed class GlobalSettingsEvent {
  const GlobalSettingsEvent();
}

final class GlobalSettingsLoadEvent extends GlobalSettingsEvent {
  const GlobalSettingsLoadEvent();
}

final class GlobalSettingsUpdateEvent extends GlobalSettingsEvent {
  final GlobalSettingsViewModel settings;

  const GlobalSettingsUpdateEvent(this.settings);
}

final class GlobalSettingsSaveEvent extends GlobalSettingsEvent {
  const GlobalSettingsSaveEvent();
}
