import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:my_gpt_client/settings/presentation/views/settings_sheet.dart';

part 'settings_sheet_state.dart';

class SettingsSheetCubit extends Cubit<SettingsSheetState> {
  SettingsSheetCubit() : super(SettingsSheetHidden());

  void show(BuildContext context) {
    if (state is SettingsSheetHidden) {
      showMacosSheet(
        context: context,
        builder: (context) => const SettingsSheet(),
      );
      emit(SettingsSheetVisible());
    }
  }

  void hide(BuildContext context) {
    if (state is SettingsSheetVisible) {
      Navigator.of(context).pop();
      emit(SettingsSheetHidden());
    }
  }
}
