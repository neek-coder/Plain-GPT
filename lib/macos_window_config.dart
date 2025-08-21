import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';

Future<void> configureWindow() async {
  const macosWindowConfig = MacosWindowUtilsConfig();
  await macosWindowConfig
      .apply(); // Calls WindowManipulator.initialize() automatically

  const platform =
      MethodChannel('com.niksu.plain-gpt/composite_window_delegate');

  await platform.invokeMethod<bool>("setUp");
}
