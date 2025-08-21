import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

import '../logic/settings_sheet_cubit/settings_sheet_cubit.dart';
import '/settings/presentation/logic/chat_settings_bloc/chat_settings_bloc.dart';
import '/settings/presentation/logic/global_settings_bloc/global_settings_bloc.dart';
import '/settings/presentation/views/chat_settings_view.dart';
import '/settings/presentation/views/global_settings_view.dart';
import '/injector.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 140.0,
              vertical: 48.0,
            ),
            width: constraints.maxWidth.clamp(0, 300),
            child: MacosSheet(
              insetPadding: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            GlobalSettingsView(),
                            SizedBox(height: 16.0),
                            ChatSettingsView(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    PushButton(
                      onPressed: () {
                        g<GlobalSettingsBloc>().save();
                        g<ChatSettingsBloc>().save();
                        g<SettingsSheetCubit>().hide(context);
                      },
                      controlSize: ControlSize.large,
                      child: const Text('Done'),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
