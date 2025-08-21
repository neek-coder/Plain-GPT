part of 'global_settings_bloc.dart';

sealed class GlobalSettingsState {
  const GlobalSettingsState();
}

final class GlobalSettingsInitial extends GlobalSettingsState {
  const GlobalSettingsInitial();
}

final class GlobalSettingsLoading extends GlobalSettingsState {
  const GlobalSettingsLoading();
}

final class GlobalSettingsLoaded extends GlobalSettingsState {
  final GlobalSettingsViewModel settings;

  const GlobalSettingsLoaded(this.settings);
}

final class GlobalSettingsSaving extends GlobalSettingsState {
  final GlobalSettingsViewModel settings;

  const GlobalSettingsSaving(this.settings);
}
