part of 'settings_sheet_cubit.dart';

sealed class SettingsSheetState {
  const SettingsSheetState();
}

final class SettingsSheetHidden extends SettingsSheetState {}

final class SettingsSheetVisible extends SettingsSheetState {}
