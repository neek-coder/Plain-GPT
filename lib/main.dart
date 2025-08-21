import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

import '/base/presentation/views/base_view.dart';
import '/chat/presentation/logic/chat_content_bloc/chat_content_bloc.dart';
import '/chat_system/presentation/logic/chat_system_bloc/chat_system_bloc.dart';
import 'settings/presentation/logic/settings_sheet_cubit/settings_sheet_cubit.dart';
import '/settings/presentation/logic/chat_settings_bloc/chat_settings_bloc.dart';
import '/settings/presentation/logic/global_settings_bloc/global_settings_bloc.dart';
import '/base/presentation/logic/base_view_bloc.dart';

import '/injector.dart';
import '/macos_window_config.dart';
import 'base/data/start_count_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setUpMethodChannel(saveDataBeforeClose);

  await configureWindow();

  await inject();

  // var appDir = await getApplicationDocumentsDirectory();
  // print(appDir);

  runApp(const App());
}

void setUpMethodChannel(Future<void> Function() handler) {
  const platform = MethodChannel('com.niksu.plain-gpt/save');

  platform.setMethodCallHandler((MethodCall call) async {
    if (call.method == "saveData") {
      await handler();

      try {
        await platform.invokeMethod<int>('saveComplete');
      } catch (e) {
        //
      }
    }
  });
}

Future<void> saveDataBeforeClose() async {
  g<BaseViewBloc>().add(const BaseViewWait());

  await g<ChatContentBloc>().save();
  await g<StartCountRepository>().registerTermination();
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => g<ChatSystemBloc>()),
        BlocProvider(create: (context) => g<ChatContentBloc>()),
        BlocProvider(create: (context) => g<GlobalSettingsBloc>()),
        BlocProvider(create: (context) => g<ChatSettingsBloc>()),
        BlocProvider(create: (context) => g<BaseViewBloc>()),
        BlocProvider(create: (context) => g<SettingsSheetCubit>()),
      ],
      child: const MacosApp(
        debugShowCheckedModeBanner: false,
        title: 'PlainGPT',
        localizationsDelegates: [DefaultMaterialLocalizations.delegate],
        themeMode: ThemeMode.system,
        home: BaseView(),
      ),
    );
  }
}
